#Requires AutoHotkey 2.0
Persistent()
ChromeWatcher()

ChromeWatcher()
{
    static index := 0, logger := FileOpen(A_Desktop "\logger.txt", 0x101)
    logger.WriteLine("  # | Event      | Event Name                  | hWnd (hex) | hWnd (dec) | Window Title")

    DllCall("SetWinEventHook",
        "UInt", 0x00000001, ; EVENT_MIN
        "UInt", 0x7FFFFFFF, ; EVENT_MAX
        "Ptr", 0,
        "Ptr", CallbackCreate(HandleWinEvent),
        "UInt", 0,
        "UInt", 0,
        "UInt", 0)
    Run("chrome.exe --start-maximized")

    HandleWinEvent(hWinEventHook, event, hWnd, *)
    {
        try
            if (WinGetProcessName(hWnd) = "chrome.exe")
            {
                try winTitle := WinGetTitle(hWnd)
                eventName := Events(event, &eventHex)
                text := Format("{1:3} | {2:-10} | {3:-27} | 0x{4:08X} | {4:10} | {5}", ++index, eventHex, eventName, hWnd, winTitle?)
                logger.WriteLine(text)
                logger.Read(0) ; Flush buffer (sometimes necessary to guarantee the proper write order)

                if ((winTitle ?? 0) = "Tabs Outliner")
                {
                    TrayTip("Finished", "Chrome Watcher", 0x34)
                    Sleep(4000)
                    ExitApp()
                }
            }
    }

    Events(event, &eventHex?)
    {
        static events := Map(0x0001, "EVENT_SYSTEM_SOUND", 0x0002, "EVENT_SYSTEM_ALERT", 0x0003, "EVENT_SYSTEM_FOREGROUND", 0x0004, "EVENT_SYSTEM_MENUSTART", 0x0005, "EVENT_SYSTEM_MENUEND", 0x0006, "EVENT_SYSTEM_MENUPOPUPSTART", 0x0007, "EVENT_SYSTEM_MENUPOPUPEND", 0x0008, "EVENT_SYSTEM_CAPTURESTART", 0x0009, "EVENT_SYSTEM_CAPTUREEND", 0x000A, "EVENT_SYSTEM_MOVESIZESTART", 0x000B, "EVENT_SYSTEM_MOVESIZEEND", 0x000C, "EVENT_SYSTEM_CONTEXTHELPSTART", 0x000D, "EVENT_SYSTEM_CONTEXTHELPEND", 0x000E, "EVENT_SYSTEM_DRAGDROPSTART", 0x000F, "EVENT_SYSTEM_DRAGDROPEND", 0x0010, "EVENT_SYSTEM_DIALOGSTART", 0x0011, "EVENT_SYSTEM_DIALOGEND", 0x0012, "EVENT_SYSTEM_SCROLLINGSTART", 0x0013, "EVENT_SYSTEM_SCROLLINGEND", 0x0014, "EVENT_SYSTEM_SWITCHSTART", 0x0015, "EVENT_SYSTEM_SWITCHEND", 0x0016, "EVENT_SYSTEM_MINIMIZESTART", 0x0017, "EVENT_SYSTEM_MINIMIZEEND", 0x0020, "EVENT_SYSTEM_DESKTOPSWITCH", 0x00FF, "EVENT_SYSTEM_END", 0x0101, "EVENT_OEM_DEFINED_START", 0x01FF, "EVENT_OEM_DEFINED_END", 0x4E00, "EVENT_UIA_EVENTID_START", 0x4EFF, "EVENT_UIA_EVENTID_END", 0x7500, "EVENT_UIA_PROPID_START", 0x75FF, "EVENT_UIA_PROPID_END", 0x8000, "EVENT_OBJECT_CREATE", 0x8001, "EVENT_OBJECT_DESTROY", 0x8002, "EVENT_OBJECT_SHOW", 0x8003, "EVENT_OBJECT_HIDE", 0x8004, "EVENT_OBJECT_REORDER", 0x8005, "EVENT_OBJECT_FOCUS", 0x8006, "EVENT_OBJECT_SELECTION", 0x8007, "EVENT_OBJECT_SELECTIONADD", 0x8008, "EVENT_OBJECT_SELECTIONREMOVE", 0x8009, "EVENT_OBJECT_SELECTIONWITHIN", 0x800A, "EVENT_OBJECT_STATECHANGE", 0x800B, "EVENT_OBJECT_LOCATIONCHANGE", 0x800C, "EVENT_OBJECT_NAMECHANGE", 0x800D, "EVENT_OBJECT_DESCRIPTIONCHANGE", 0x800E, "EVENT_OBJECT_VALUECHANGE", 0x800F, "EVENT_OBJECT_PARENTCHANGE", 0x8010, "EVENT_OBJECT_HELPCHANGE", 0x8011, "EVENT_OBJECT_DEFACTIONCHANGE", 0x8012, "EVENT_OBJECT_ACCELERATORCHANGE", 0x8013, "EVENT_OBJECT_INVOKED", 0x8014, "EVENT_OBJECT_TEXTSELECTIONCHANGED", 0x8015, "EVENT_OBJECT_CONTENTSCROLLED", 0x8016, "EVENT_SYSTEM_ARRANGMENTPREVIEW", 0x8017, "EVENT_OBJECT_CLOAKED", 0x8018, "EVENT_OBJECT_UNCLOAKED", 0x8019, "EVENT_OBJECT_LIVEREGIONCHANGED", 0x8020, "EVENT_OBJECT_HOSTEDOBJECTSINVALIDATED", 0x8021, "EVENT_OBJECT_DRAGSTART", 0x8022, "EVENT_OBJECT_DRAGCANCEL", 0x8023, "EVENT_OBJECT_DRAGCOMPLETE", 0x8024, "EVENT_OBJECT_DRAGENTER", 0x8025, "EVENT_OBJECT_DRAGLEAVE", 0x8026, "EVENT_OBJECT_DRAGDROPPED", 0x8027, "EVENT_OBJECT_IME_SHOW", 0x8028, "EVENT_OBJECT_IME_HIDE", 0x8029, "EVENT_OBJECT_IME_CHANGE", 0x8030, "EVENT_OBJECT_TEXTEDIT_CONVERSIONTARGETCHANGED", 0x80FF, "EVENT_OBJECT_END", 0xA000, "EVENT_AIA_START", 0xAFFF, "EVENT_AIA_END")
        eventHex := Format("0x{1:04X}", event)

        if (events.Has(event))
            return events[event]

        if (event >= 0x0001 && event <= 0x00FF)
            return "EVENT_SYSTEM_UNKNOWN"

        if (event >= 0x0101 && event <= 0x01FF)
            return "EVENT_OEM_UNKNOWN"

        if (event >= 0x4E00 && event <= 0x4EFF)
            return "EVENT_UIA_EVENTID_UNKNOWN"

        if (event >= 0x7500 && event <= 0x75FF)
            return "EVENT_UIA_PROPID_UNKNOWN"

        if (event >= 0x8000 && event <= 0x80FF)
            return "EVENT_OBJECT_UNKNOWN"

        if (event >= 0xA000 && event <= 0xAFFF)
            return "EVENT_AIA_UNKNOWN"

        return "EVENT_UNKNOWN"
    }
}
