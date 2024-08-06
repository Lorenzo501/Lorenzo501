#Requires AutoHotkey <=2.0.10 ; Preventing any future AHK patch from adding the missing space to the right of the first column of the 2nd and subsequent rows (b/c I already added it)
#NoTrayIcon
A_WinDelay := -1

class ChromeWatcher
{
    static __New()
    {
        this.EVENT_MIN := 0x00000001
        this.EVENT_MAX := 0x7FFFFFFF
        this._Hook := 0
        this.Cb := CallbackCreate((params*) => (this.HandleWinEvent)(this, params*),, this.HandleWinEvent.MaxParams - 1)
    }

    static Hook(shouldRunChrome := false)
    {
        this.Index := 0
        Dbg.Reset(1)
        this._Hook := DllCall("SetWinEventHook", "UInt", this.EVENT_MIN, "UInt", this.EVENT_MAX, "Ptr", 0, "Ptr", this.Cb, "UInt", 0, "UInt", 0, "UInt", 0, "Ptr")
        DllCall("QueryPerformanceFrequency", "Int64*", &Qpf := 0), this.Qpf := Qpf
        DllCall("QueryPerformanceCounter", "Int64*", &QpcPrevious := 0), this.QpcPrevious := QpcPrevious

        if (shouldRunChrome)
            Run("chrome.exe --start-maximized --hide-crash-restore-bubble")
    }

    static Unhook()
    {
        DllCall("UnhookWinEvent", "Ptr", this._Hook)
        Dbg.Reset(2)
        this._Hook := 0
    }

    static HandleWinEvent(hWinEventHook, event, hWnd, *)
    {
        try
            if (WinGetProcessName(hWnd) = "chrome.exe")
            {
                try winTitle := WinGetTitle(hWnd)
                eventName := this.Events(event, &eventHex)
                DllCall("QueryPerformanceCounter", "Int64*", &qpc := 0)
                Dbg.Update(++this.Index, Round((qpc - this.QpcPrevious) / this.Qpf * 1000), eventHex, eventName, hWnd, winTitle?)
                this.QpcPrevious := qpc
            }
    }

    static Events(event, &eventHex?)
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

class Dbg
{
    static __New()
    {
        this.FormatString := "{1:3} | {2:13} | {3:-10} | {4:-27} | 0x{5:08X} | {5:10} | {6}`r`n"
        this.Header := "  # | Interval (ms) | Event      | Event Name                  | hWnd (hex) | hWnd (dec) | Window Title"
        this.Text := this.Header "`r`n"

        this._Gui := Gui("+AlwaysOnTop -Theme", "Debug Console")
        this._Gui.OnEvent("Close", (*) => ExitApp())
        this._Gui.SetFont(, "Verdana")
        this._Gui.AddButton(, "Hook/Unhook && Run Chrome").OnEvent("Click", (*) => (ChromeWatcher._Hook ? ChromeWatcher.Unhook() : ChromeWatcher.Hook(true), ControlClick(hiddenButton)))
        this._Gui.AddButton("x+6", "Hook/Unhook").OnEvent("Click", (*) => (ChromeWatcher._Hook ? ChromeWatcher.Unhook() : ChromeWatcher.Hook(), ControlClick(hiddenButton)))
        this._Gui.AddButton("x+6", "Close Chrome").OnEvent("Click", (*) => (ProcessClose("chrome.exe"), ControlClick(hiddenButton)))
        this._Gui.AddButton("x+6", "Always On Top").OnEvent("Click", (*) => (Dbg.ToggleAlwaysOnTop(), ControlClick(hiddenButton)))
        this._Gui.AddButton("x+6", "Point Marker").OnEvent("Click", (*) => (ChromeWatcher._Hook ? Dbg.Update() : Exit(), ControlClick(hiddenButton)))
        this._Gui.AddButton("x+6", "Export To TXT").OnEvent("Click", (*) => (ExportToTextFile(), ControlClick(hiddenButton)))
        hiddenButton := this._Gui.AddButton("-Tabstop y-100")
        this.ListView := this._Gui.AddListView("x10 w1000 h1080 LV0x10000 Count1000", StrSplit(this.Header, " | "))
        this.ListView.OnEvent("Click", (*) => ControlClick(hiddenButton))
        
        for (col in [1, 2, 6])
            this.ListView.ModifyCol(col, "Right")

        this._Gui.Show()

        ExportToTextFile()
        {
            filePath := A_Desktop "\logger.txt"
            try FileDelete(filePath)
            FileAppend(Dbg.Text, filePath)
            Msgbox("Exported to " filePath,, 0x40000)
        }
    }

    static Update(params_text*)
    {
        if (params_text.Length = 6)
            this.Text .= Format(this.FormatString, params_text*), params_text[1] := params_text[1] " ", params_text.InsertAt(5, Format("0x{1:08X}", params_text[5]))
        else
            this.Text .= "`r`n"

        this.ListView.Modify(this.ListView.Add(, params_text*), "+Vis")

        loop (this.ListView.GetCount("Column"))
            this.ListView.ModifyCol(A_Index, "AutoHdr")

        Sleep(-1) ; Force immediate redraw
    }

    static Reset(mode)
    {
        if (mode = 1)
        {
            this.ListView.Delete()
            this.Text := this.Header "`r`n"
            this._Gui.Title := "Debug Console (hooked)"
        }
        else if (mode = 2)
            this._Gui.Title := "Debug Console (unhooked)"
    }

    static ToggleAlwaysOnTop() => WinSetAlwaysOnTop(-1, this._Gui)
}

#HotIf WinActive("Debug Console ahk_class AutoHotkeyGUI")
^c:: ; Ctrl+C to copy selected line(s)
{
    selectedRowsCopy := Dbg.Header "`r`n"
    remainingRowsCopyAmount := Dbg.ListView.GetCount("Selected")
    selectedRow := Dbg.ListView.GetNext() + 1
    shouldSelectNextRow := false

    loop parse (Dbg.Text), "`n"
    {
        if (!shouldSelectNextRow)
            if (A_Index = selectedRow)
                shouldSelectNextRow := true
            else
                continue

        if (remainingRowsCopyAmount-- > 0)
            selectedRowsCopy .= A_LoopField
    }

    A_Clipboard := selectedRowsCopy
}
