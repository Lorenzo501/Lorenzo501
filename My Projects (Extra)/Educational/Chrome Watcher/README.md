# Windows API

### Accessibility <!-- a.k.a. Acc (Microsoft Active Accessibility) -->
* [Event Constants](https://learn.microsoft.com/en-us/windows/win32/winauto/event-constants)  
* [SetWinEventHook function](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-setwineventhook)  
* [WinEventProc callback function](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nc-winuser-wineventproc)  
* [UnhookWinEvent function](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-unhookwinevent)

### Performance Counter <!-- a.k.a. QPC (Query Performance Counter) -->
* [QueryPerformanceFrequency function](https://learn.microsoft.com/en-us/windows/win32/api/profileapi/nf-profileapi-queryperformancefrequency)
* [QueryPerformanceCounter function](https://learn.microsoft.com/en-us/windows/win32/api/profileapi/nf-profileapi-queryperformancecounter)

# [Chrome Watcher (automatic)](https://github.com/Lorenzo501/Lorenzo501/blob/main/My%20Projects%20(Extra)/Educational/Chrome%20Watcher/Chrome%20Watcher%20(automatic).ahk)
Writes to TXT, functions only (very basic).

IMPORTANT: this AHK script expects Tabs Outliner to appear and uses this as the cue to stop the script. If you just want to see chrome event data without logging that of Tabs Outliner, then make sure to exit the script when you're done by using the tray icon (to stop the logger). Otherwise make sure that Tabs Outliner gets started automatically at chrome startup before using this script.

And if you don't want chrome event data of chrome windows that were already open, then ofcourse you should close all chrome windows (including Tabs Outliner) before using this script. When you start this script, chrome will start automatically and you'll get a logger.txt on your desktop with all the chrome/Tabs Outliner event data.

# [Chrome Watcher (with hotkeys)](https://github.com/Lorenzo501/Lorenzo501/blob/main/My%20Projects%20(Extra)/Educational/Chrome%20Watcher/Chrome%20Watcher%20(with%20hotkeys).ahk)
Writes to TXT, functions only and has 6 hotkeys (basic).

# Chrome Watcher (with debug console)
[![](https://raw.githubusercontent.com/Lorenzo501/Lorenzo501/main/My%20Projects%20(Extra)/Educational/Chrome%20Watcher/Snippet.png)](#)

### [Version 1 (intermediate)](https://github.com/Lorenzo501/Lorenzo501/blob/main/My%20Projects%20(Extra)/Educational/Chrome%20Watcher/Chrome%20Watcher%20(with%20debug%20console)%20v1.ahk)
Edit control, functions only and has 5 buttons.

### [Version 2 (advanced)](https://github.com/Lorenzo501/Lorenzo501/blob/main/My%20Projects%20(Extra)/Educational/Chrome%20Watcher/Chrome%20Watcher%20(with%20debug%20console)%20v2.ahk)
ListView control, functions only, 6 buttons and has 1 hotkey.

### [Version 3 (very advanced)](https://github.com/Lorenzo501/Lorenzo501/blob/main/My%20Projects%20(Extra)/Educational/Chrome%20Watcher/Chrome%20Watcher%20(with%20debug%20console)%20v3.ahk)
ListView control, classes only, 6 buttons and has 1 hotkey.
