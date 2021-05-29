var _string = "";
_string += "Snitch by @jujuadams " + SNITCH_VERSION + ", " + SNITCH_DATE + "\n";
_string += "Log files can be found in " + game_save_id + "\n\n";
_string += "Press 1 to log a message\n";
_string += "Press 2 to call show_debug_message() (redirected to Snitch() by default)\n";
_string += "Press 3 to crash the game\n";
_string += "Press 4 to call show_error()\n";
_string += "Press L to toggle logging (currently = " + string(SnitchLogGet()) + ")\n";
_string += "\n";
_string += "\n";
_string += "\n";

//Display crash data if we have any
//  N.B. This particular code expects SWITCH_CRASH_CLIPBOARD_MODE to be set to 1
if (is_struct(previousCrashData))
{
    _string += "Previous crash data:\n";
    
    try
    {
        _string += "message = \"" + string(previousCrashData.message) + "\"\n\n";
        _string += "longMessage = \"" + string(previousCrashData.longMessage) + "\"\n\n";
        _string += "script = \"" + string(previousCrashData.script) + "\"\n\n";
        _string += "line = " + string(previousCrashData.line) + "\n\n";
        _string += "stacktrace = " + string(previousCrashData.stacktrace) + "\n\n";
    }
    catch(_)
    {
        _string += "(Crash data in unexpected format)";
    }
}
else
{
    _string += "No previous crash detected";
}

draw_text(10, 10, _string);