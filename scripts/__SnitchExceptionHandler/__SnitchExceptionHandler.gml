// Feather disable all
function __SnitchExceptionHandler(_struct)
{
    __SnitchTrace("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    var _event = new __SnitchClassSoftError();
    
    if (SNITCH_SENTRY_SEND_SCREEENSHOT_ENVELOPE) {
        var screenshot_name = "__screenshot__";
        screen_save(screenshot_name);
        var envelope_buffer = buffer_load(screenshot_name);
        file_delete(screenshot_name);
        _event.__SetEnvelopeBuffer(envelope_buffer);
    }
    
    _event.__SetException(_struct);
    __SnitchTrace("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    
    
    
    //Call the exception handler defined by the native exception_unhandled_handler() function
    try
    {
        if (__SnitchState().__GMExceptionHandler != undefined) __SnitchState().__GMExceptionHandler(_struct);
    }
    catch(_error)
    {
        __SnitchTrace("Exception encountered when executing exception handler");
        __SnitchTrace(json_stringify(_error));
    }
    
    
    
    //Save out the crash dump
    try
    {
        if (SWITCH_CRASH_DUMP_MODE > 0)
        {
            var _text = "No data available";
            switch(SWITCH_CRASH_DUMP_MODE)
            {
                case 1: _text = json_stringify(_struct, true);          break;
                case 2: _text = _event.__GetExceptionString();           break;
                case 3: _text = _event.__GetCompressedExceptionString(); break;
            }
            
            var _buffer = buffer_create(string_byte_length(_text), buffer_fixed, 1);
            buffer_write(_buffer, buffer_text, _text);
            buffer_save(_buffer, SNITCH_CRASH_DUMP_FILENAME);
            buffer_delete(_buffer);
            
            __SnitchTrace("Saved crash dump to \"", SNITCH_CRASH_DUMP_FILENAME, "\"");
        }
    }
    catch(_error)
    {
        __SnitchTrace("Exception when writing crash dump");
        __SnitchTrace(json_stringify(_error));
    }
    
    
    
    //Show a pop-up message
    try
    {
        if (SWITCH_CRASH_CLIPBOARD_MODE > 0)
        {
            if (show_question(SNITCH_CRASH_CLIPBOARD_REQUEST_MESSAGE))
            {
                var _text = "No data available";
                switch(SWITCH_CRASH_CLIPBOARD_MODE)
                {
                    case 1: _text = json_stringify(_struct, true);           break;
                    case 2: _text = _event.__GetExceptionString();           break;
                    case 3: _text = _event.__GetCompressedExceptionString(); break;
                }
                _text = string_replace_all(_text, "\\n", @'
');
                _text = string_replace_all(_text, "\\r", @'
');
                _text = string_replace_all(_text, "\\t", "   ");
                clipboard_set_text("#####" + _text + "#####");
                show_message(SNITCH_CRASH_CLIPBOARD_ACCEPT_MESSAGE);
            }
        }
        else if (SNITCH_CRASH_NO_CLIPBOARD_MESSAGE != "")
        {
            show_message(SNITCH_CRASH_NO_CLIPBOARD_MESSAGE);
        }
    }
    catch(_error)
    {
        __SnitchTrace("Exception when showing user-facing pop-up");
        __SnitchTrace(json_stringify(_error));
    }
}