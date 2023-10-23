// Feather disable all
// https://develop.sentry.dev/sdk/overview/
// https://develop.sentry.dev/sdk/event-payloads/

function __SnitchConfigPayloadSentry(_uuid, _message, _longMessage, _callstack, _level_type/*:int<SNITCH_LEVEL_TYPE>*/)
{
    return {
        event_id: _uuid,
        timestamp: SnitchConvertToUnixTime(date_current_datetime()),
        level: __SnitchLevelTypeName(_level_type),
        release: GM_version, //Game version
        
        //Error message data
        exception: {
            values: [
                {
                    type: _message,
                    value: _longMessage,
                    stacktrace: {
                        frames: _callstack,
                    },
                },
            ],
        },
        
        //Tags to help filter issues/events inside sentry.io
        tags: {
            device_string: SNITCH_ENVIRONMENT_NAME,
            config:        os_get_config(),
            version:       GM_version,
        },
        
        //Information on what environment the code is running in
        contexts: {
            //OS-level data
            os: {
                name:              SNITCH_OS_NAME,
                version:           SNITCH_OS_VERSION,
                //browser:           SNITCH_BROWSER, //Feel free to use this but, realistically, it's unlikely that you'll be using HTML5
                paused:            bool(os_is_paused()),
                network_connected: bool(os_is_network_connected(false)),
                language:          os_get_language(),
                region:            os_get_region(),
                info:              SNITCH_OS_INFO,
            },
            
            //What version of GameMaker are you using?
            runtime: {
                name: "GameMaker",
                version: GM_runtime_version,
            },
            
            app: {
                app_start_time:   SnitchFormatTimestamp(SNITCH_SESSION_START_TIME), //This has to be formatted as a string unfortunately <_<
                config:           os_get_config(),
                yyc:              bool(code_is_compiled()),
                app_name:         game_display_name,
                app_version:      GM_version,
                running_from_ide: bool(SNITCH_RUNNING_FROM_IDE),
                app_build:        SnitchFormatTimestamp(GM_build_date),
                parameters:       SNITCH_BOOT_PARAMETERS,
                steam:            bool(SnitchSteamInitializedSafe()),
            },
        },
        
        breadcrumbs: SnitchSentryBreadcrumbsGet()
    };
}

function __SnitchConfigEnvelope(_uuid, _buffer_data)
{
    var header = {
        event_id: _uuid,
    }
    
    var file_base64     = buffer_base64_encode(_buffer_data, 0, buffer_get_size(_buffer_data));
    var buffer_content	= buffer_read(_buffer_data, buffer_text);
    
    var item = {
        type : "attachment",
        content_type : "image/png;base64",
        filename : "screenshot_in_base64_" + _uuid
    }
    var envelope = json_stringify(header) + "\n" + json_minifying(json_stringify(item)) + "\n" + string(file_base64);
    
    buffer_delete(_buffer_data);
    
    return envelope;
}