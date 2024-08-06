/*********************************************
 *  File:     WinSize2.ahk
 *  Author:   Kalle Koseck
 *  License:  GPL / GNU General Public License
 *  Date:     2005-05-06
 *  Revision: 2009-06-05
 *            2010-03-24   V2.31.03
 *            2010-03-26   V2.32.01
 *            2010-04-01   V2.32.02  Swedish
 *            2010-05-20   V2.33.01d
 *            2010-07-08   V2.34.05
 *            2011-04-18   V2.38.02
 *            
 *********************************************
 */
 
	Titles_Sort_Basis := 0
	Titles_Sort_ZA := 0
	ChkInactive_TickCount := 0
	TabNumber_Open_Last_Tab := 0
	Delay_Show_Tooltip := 1
	vWinSize2_Not_Active := 0
	IniFile_PathFile_DesktopIcon_IsChecked := 0
	RunWait_Min := "Min"
	CUT30 := "|"
	CUT   := "|"
	CUT   := Chr(2)
	CUT1  := Chr(3)

	; 1xxxxx is used only to produce n digits
	split_AhkClass_UsedBase := 100000
	split_AhkClass_UsedYes := 999
	split_AhkClass_UsedBaseYes := split_AhkClass_UsedBase + split_AhkClass_UsedYes
	
	#SingleInstance Off
	DetectHiddenWindows Off    ; which is the default
	;#NoTrayIcon               ; do not show any icon
Menu, Tray, Icon,,, 1 ; b/c otherwise the icon will often get stuck on the pause icon somehow (w/o actually being in the pause/suspend state)
	vMenuTrayIcon_Show := 0
	mMenuTrayIcon()

;finishedWinIds := {}

	SetWorkingDir, %A_ScriptDir%
/*
 *************************************************************************
 */
	vVersion_Test       := 0
	If ( vVersion_Test )
		vVersion           = 2.36.00
	Else
		vVersion           = 2.38.04

Goto NachHotkey

#Include inc_ctrl_alt_a.ahk

NachHotkey:
/*
 *************************************************************************
 */

	mFullScreen_Init()   ; first INIT: Filename is not set now

	; 0: do not show   1: show tips
	Tooltip_Show_Tip      := 0
	Tooltip_Show_Store    := 0
	Tooltip_Show_Pause    := 0
	Tooltip_Show_Numbers  := 0
	DesktopIcon_CheckAfterLogin := 1

	; 0: no log
	; 1: insert, delete, move
	; 2: explaining lines, no doubles
	; 3: explaining lines, all
	LogFile_Level         := 3
	LogFile_Cnt           := 0
	
	If ( Tooltip_Show_Tip )
		Tooltip_Show_Store  := 1

	Tooltip_Show_Tip_SignOn  := 0
	Exclude_List_Timer_Add := 1000
	vLang_Message = 1
	AW_AsBefore := 1
	AA1 = 

	vIniScreen_Logo_Show := FALSE
	split_FullScr_Sum = {Return}

	#Include inc_vProgramName.ahk

	/*
	; %0% = No of Startparameter
	MsgBox %0% Startparameter:  %1%  %2%    %3%   %4%     %5%   %6%   %7%     %8%               %9%
	MsgBox (00) %vProgram_NNamExt%   "%P1_Cmd%"
	*/
	P1_Cmd = %1%
	StringUpper P1_Cmd, P1_Cmd

	P0_NoParams = %0%
	P2 = %2%
	P3 = %3%
	P4 = %4%
	P5 = %5%
	P6 = %6%
	P7 = %7%
	P8 = %8%
	P9 = %9%

	If ( P1_Cmd = "RenameTitle" )
	{
		P1_Cmd = /RenameTitle
		Tooltip `n`nBitte ändern / Please change: RENAMETITLE -> /RENAMETITLE`n`n
		Sleep 4000
	}
	If ( P1_Cmd = "/RenameTitle" )
	{
		; msgbox %P1_Cmd% %P2% %P3%
		Cmd_WinRenameTitle( P2, P3 )
		ExitApp, %ExitApp_Code%
	}

	Else If ( P1_Cmd = "/VERS" )
	{
		; FileAppend, %vProgram_NNam% %vVersion%, *
		
		FileOut =%vProgram_NNam%_wrote_this_file.CMD 
		FileRecycle %FileOut%   ; FileDelete
		FileAppend, 
		(
Rem --- %vProgram_NNam% wrote this file
Set %vProgram_NNam%_Version=%vVersion%
		
		) , %FileOut%
		ExitApp
	}

	Else If ( %P0_NoParams% > 0 )
	{
		MsgBox ******   WinSize2  %vVersion%  ******`n`nunknown command: "%P1_Cmd% %P1% %P2%"`n`nSee Handbook "WinSize2" for details.`n`n
		ExitApp, 10
	}

	/*
	IfInString, vProgram_NNamExt, .AHK
	{
		; msgbox vProgram_NNamExt %vProgram_NNamExt%
	}
	*/

	#InstallKeybdHook 
	; #Include inc_WinSize_Init.ahk
	; #Include inc_WinSize_Subr.ahk


/*********************************************
 *  File:     #Include inc_WinSize_Init.ahk
 *  Author:   Kalle Koseck
 *  License:  GPL / GNU General Public License
 *  Date:     2008-09-16
 *  Revision: 
 *
 *********************************************
 */

TTM=30  ; Tooltip_Multiplicator Line-Height
TTP=2  ; Tooltip_Plus
TTX=60  ; Tooltip_XCoordinate

If ( Tooltip_Show_Tip
	OR Tooltip_Show_Tip_SignOn )
{
CoordMode, ToolTip, Screen
TTL := 001
Command_Update := 0
If ( P1_Cmd = "" )
{
	Tooltip % vProgram_NNamExt " " vVersion
	,TTX , TTL*TTM, TTL+TTP ;%
	; MsgBox Tooltip Init 01
}
Else
{
	Tooltip % vProgram_NNamExt " " vVersion "   ' " P1_Cmd " '" 
	,TTX , TTL*TTM, TTL+TTP ;%
	If ( P1_Cmd = "/UPDATE" )
	{
		Command_Update := 1
		vIniScreen_Logo_Show := FALSE
		; MsgBox Tooltip Init 02-Update
	}
	; Else
		; MsgBox Tooltip Init 03-Else
}
If ( Tooltip_Show_Tip_SignOn )
	Tooltip_Show_Tip_SignOn := A_TickCount + 5000
CoordMode, ToolTip, Relative
}

	mScreen_Size( 0 )
	; Tooltip mScreen_Size :: %Screen_Width% :: %Screen_Height%
	mIniFile_Init( 5000 )
	mIniRead_All_User() 
	; msgbox mWS2_InitCmdOnce 01   %Screen_Width_Height_OLD%  %Screen_Width_Height%
	mWS2_InitCmdOnce()
	; msgbox mWS2_InitCmdOnce 91   %Screen_Width_Height_OLD%  %Screen_Width_Height%
	Screen_Width_Height_OLD := Screen_Width_Height
	mLogFile_Write( -1, "." )
	LogText := ">>>Loaded " vVersion " " vProgram_NExt " Lang:'" vLanguage_INI ":" vLanguage_NameLong "' " vLanguage_Reg_Hex " Log:" LogFile_Level ":" LogFile_Size_kB "kB  " Screen_Width_Height " " Screen_dpi "dpi"
	If ( P1_Cmd <> "" )
		LogText .= "'" P1_Cmd "' / '" P2 "' / '" P3 "'"
	mLogFile_Write( 0, LogText )
	
	;*************************************************
	; Check if an instance of WS is already running
	; does last saved Process_ID still exist
	; when Process_ID is valid it is returned, 0=not valid
	Process, Exist, %Process_ID%
	Process_ID_last := errorlevel
	; 0 = does not exist any more
	; WinSize2 is not running; get act ID and save in root
	If ( Process_ID_last = 0 )
	{
		Process, Exist   ; name is empty: get ID of this process
		Process_ID := errorlevel
		IniFile_Write_All = 1
	}
	;*************************************************
	Else
	{
		; --- be sure, that ID belongs to this process (AHK or EXE version)
		WinGet , Name_of_Process , ProcessName , ahk_pid %Process_ID_last%
		
		; *** (1094)  WinSize2 is already running   ... can only be started once
		If ( Name_of_Process = "WinSize2.exe"        ; the EXE version: compiled
			OR Name_of_Process = "AutoHotkey.exe" )  ; the AHK version: source
		{
			Text := Message_Get( 1094 )
			MsgBox, %Text%
			ExitApp
		}
	}
	;*************************************************


	If ( P1_Cmd = "/UNINSTALL" )
	{
		MsgBox, 262180, WinSize2 UnInstall, % Message_Get(1046)  ; % (1046) You want to UNinstall WinSize2 ?
		WinSize2_Registry( 3 )   ; RegDelete
		; msgbox Remove Dir "%IniFile_Path%"
		; and all sub-dirs
		; FileRemoveDir, %IniFile_Path%, 1
		MsgBox % Message_Get(1045) "`n`n" A_WorkingDir  ; (1045) UnInstall: Please remove directory: ;%
		ExitApp
	}

	vIniScreen_Time_End := 0
	If ( vIniScreen_Time_Show > 0 AND vIniScreen_Logo_Show )
	{
		WinSize2_IniScreen_Show()
		vIniScreen_Time_End := A_TickCount + vIniScreen_Time_Show
		/*
		Sleep %vIniScreen_Time_Show%
		Gui, Destroy
		*/
	}

	mMenuTray()

	; these are the defaults: will be overwritten by INI file: 7=German
	If ( vLanguage_ID = 7 )
		mCtrl_Alt_Y_Init( ^!Y, 2005 )
	Else
		mCtrl_Alt_Y_Init( ^!Z, 2005 )
	mActWin_Init( vTitleTimer )
	; #Include inc_WinSize.AHK
	
	#Include inc_AutoReLoad_Error.ahk
	AutoReLoad_Tooltip := False
	If (A_AhkVersion < "1.0.39.00")
	{
		; 16: Icon Hand  4: Yes/No
	   MsgBox,20
			,Wrong AHK version
			,This script may not work properly with your version of AutoHotkey. Continue?
		IfMsgBox,No
			ExitApp
	}
	; msgbox mWS2_InitCmdOnce 02   %Screen_Width_Height_OLD%  %Screen_Width_Height%
	mWS2_InitCmdOnce()
	; msgbox mWS2_InitCmdOnce 92   %Screen_Width_Height_OLD%  %Screen_Width_Height%
/*********************************************
 *  END of  #Include inc_WinSize_Init.ahk
 *********************************************
 */

/*********************************************
 *  File:     #Include inc_WinSize.ahk
 *  Author:   Kalle Koseck
 *  License:  GPL / GNU General Public License
 *  Date:     2005-05-06
 *  Revision: 2008-01-07   Title for windows with CONTAINS
 *            2008-05-26   as a stand-alone program
 *
 *********************************************
 */

	; If ( vVersion = "" )
	;	vVersion = V2.xx
	If ( vAuthor = "" )
		vAuthor = ©WinSize2.SourceForge.com 
/*
 *  ?   according to the OS
 *  DE  German
 *  EN  English (everything that is not known)
 */
	; vLanguage_NameLong =?
	Message_Get( 1000 )
	vTooltipPubSleep =  3000
	vTooltipIntSleep =  3000
	vTooltipIntSleepShort =  2000
	vTooltipIntSleepVeryShort =  1000
	
	#Include inc_AutoReLoad.AHK
	; #Include inc_IniReadWrite.AHK
	; #Include inc_IniReadWrite_User.AHK
	#IncludeAgain inc_vProgramName.AHK
	; #Include inc_Ctrl_Alt_Y.ahk
	
	Return


;	#Include NumberCheck.AHK
NumberCheck( VarIn , Default=0 )
	{
		If ( VarIn = "" OR VarIn = "ERROR" )
			VarOut = %Default%
		Else
			VarOut = %VarIn%
		
		; msgbox mIsNumber "%VarOut%"
		Return VarOut
	}
/*
 *  END of initialization
 *************************************************************************
 */


/*
 *************************************************************************
 *  right mouse click to Tray-Icon:
 *  -- Edit INI-File
 *  -- Special Parameters
 */
	Exit:
	ExitApp
/*
 *************************************************************************
 *   Start of "WinSize"
 *************************************************************************
 */

/*
 *************************************************************************
 *  Initialisation of periodically executing method "mActWin_Timer"
 *
 *  Zeit  the time period when to execute again
 *
 *************************************************************************
 */

mScreen_Size( Desktop_DoUpdate=1 )
{
	Global
	
	/*
	Gui, Color, Grey
	Gui, -Caption
	Gui, Show, Center h0 w0 , WinSize2 INI

	; Delete_All_Tooltips()
	WinGetActiveStats , New_Title, New_Width, New_Height, New_X, New_Y
	New_Title1 =   ; if string is empty
	StringSplit , New_Title, New_Title, `n
	New_Title := New_Title1
	; tooltip New_Title-2: "%New_Title%"
	
	Screen_Width := Floor( ( New_X + New_Width / 2 ) * 2 )
	Screen_Height := Floor( ( New_Y + New_Height / 2 ) * 2 )
	
	; Tooltip WinGetActiveStats %New_Title% / %New_Width% / %New_Height% / %New_X% / %New_Y% :: %Screen_Width% :: %Screen_Height%
	Gui Destroy
	*/

	; http://msdn.microsoft.com/en-us/library/ms724385(VS.85).aspx

	; read width and height of screen
	Screen_Width := GetSystemMetrics( 0 )   ; SM_CXSCREEN = 0
	Screen_Height := GetSystemMetrics( 1 )   ; SM_CYSCREEN = 1
	Screen_Width_Height := Screen_Width "x" Screen_Height

	; http://www.autohotkey.com/forum/topic7489-15.html by Zippo
	; http://msdn.microsoft.com/en-us/library/ms724947(VS.85).aspx

	Screen_dpi := GetDeviceCaps( 90 ) ; 90 is LOGPIXELSY.
	; MsgBox DPI = %Screen_dpi%

	If ( Desktop_DoUpdate
		AND Screen_Width_Height_OLD <> Screen_Width_Height )
	{
		; msgbox mDesktopIconChanged_NoOK   %Screen_Width_Height_OLD%  %Screen_Width_Height%
		LogText := "Screen resolution changed from: " Screen_Width_Height_OLD " to " Screen_Width_Height
		mLogFile_Write( 2, LogText )
		
		mIniMake_SaveINI()
		Network_ID_Select := 
		mNetwork_MakeFile()
		If ( DesktopIcon_CheckResolution )
			mDesktopIconChanged_NoOK()
	}

	Screen_Width_Height_OLD := Screen_Width_Height

	Return
}
; --------------------------------------------------------------------------
GetSystemMetrics( p_index )
{
	return, DllCall( "user32.dll\GetSystemMetrics", "int", p_index )
	; return, DllCall( "GetSystemMetrics", "int", p_index )
} 
; --------------------------------------------------------------------------
GetDeviceCaps( p_index )
{
	hdc := DllCall( "GetDC", UInt, 0 )
	Value := DllCall( "GetDeviceCaps", UInt, hdc, Int, p_index )
	DllCall( "ReleaseDC", UInt, 0, UInt, hdc )
	; MsgBox ( p_index ) = %Value%
	
	Return Value
} 



/*
 *************************************************************************
 *  Initialisation of periodically executing method "mActWin_Timer"
 *
 *  Zeit  the time period when to execute again
 *
 *************************************************************************
 */
mActWin_Init( Zeit )
{
	Global
	
	; msgbox mActWin_Init %Zeit%
	; AWNr_CntEntries := 0
	split_MatchMode := 3	 ; --- Wintitle / 2: contains / 3: exact match
	vTitleTimer := Zeit

	;Settimer, mActWin_Timer, %Zeit%

/*
Return
}

mActWin_Init( Zeit )
{
	Global
*/

	Gui 2:+LastFound
	hWnd := WinExist()

	DllCall( "RegisterShellHookWindow", UInt,hWnd )
	MsgNum := DllCall( "RegisterWindowMessage", Str,"SHELLHOOK" )

	OnMessage( MsgNum, "ShellMessage" )

;https://www.magnumdb.com/search?q=title%3AEVENT_SYSTEM_MINIMIZEEND+OR+title%3AEVENT_OBJECT_DESTROY+OR+title%3AEVENT_OBJECT_SHOW
EVENT_SYSTEM_MINIMIZEEND := 23
;EVENT_OBJECT_DESTROY := 32769 ; gets triggered non-stop, so I'll just keep using the shell hook for that
EVENT_OBJECT_SHOW := 32770
DllCall("SetWinEventHook", "UInt", EVENT_SYSTEM_MINIMIZEEND, "UInt", EVENT_SYSTEM_MINIMIZEEND, "Ptr", 0, "Ptr", RegisterCallback("HandleWinEvent"), "UInt", 0, "UInt", 0, "UInt", 0)
DllCall("SetWinEventHook", "UInt", EVENT_OBJECT_SHOW, "UInt", EVENT_OBJECT_SHOW, "Ptr", 0, "Ptr", RegisterCallback("HandleWinEvent"), "UInt", 0, "UInt", 0, "UInt", 0)
;DllCall("SetWinEventHook", "UInt", EVENT_OBJECT_DESTROY, "UInt", EVENT_OBJECT_DESTROY, "Ptr", 0, "Ptr", RegisterCallback("HandleWinEvent"), "UInt", 0, "UInt", 0, "UInt", 0)

	;Settimer, mActWin_Timer, %Zeit%

Return
}

HandleWinEvent(hWinEventHook, event, hWnd, _*)
{
	Global

if (A_IsPaused)
	Return

; This skips specific EVENT_OBJECT_DESTROY events that are unnecessary (but the shell hook doesn't generate them in the first place, so that's better b/c it uses less resources)
;if (DllCall("GetAncestor", "Ptr", hWnd, "UInt", 2) != hwnd)
	;Return
	
	; WS2 is deactivated
	If ( vWinSize2_Not_Active = 1 )
		Return

local title, class, minMax, style
WinGetTitle, title, ahk_id %hWnd%

if (title = "")
{
	Sleep 400
	WinGetTitle, title, ahk_id %hWnd%

	if (title = "")
		Return
}

WinGetClass, class, ahk_id %hWnd%
WinGet, minMax, MinMax, ahk_id %hWnd%
WinGet, style, Style, ahk_id %hWnd%

; It being either minMax 1 or 0 means that it's not minimized
; 0xC00000 is WS_CAPTION, which means that it has a title bar
if ((minMax = 1 || minMax = 0) && style & 0xC00000)
{
	HWND_UniqueID := WinExist( title )
	; push to stack
	Stack_OnOff( "ShellMsg" , 0 )
	Stack_Push( "ShellMsg" , title )
	Stack_Push( "ShellMsg" , class )
	Stack_OnOff( "ShellMsg" , 1 )
	LogText := "PUSH ShellMessage to stack  :" title ": Cl=" class ": ID=" HWND_UniqueID ":"
	mLogFile_Write( 2, LogText )

	; Text := Stack_List( "ShellMsg" )
	; msgbox Push: %Text%

;static debugText := ""
;debugText .= "`n" event " " minMax " " hWnd " " title " " class
;Tooltip % debugText

SetTimer, mProcess_ActiveWindow, -10
}

Return
}

/*
And a new function handling the shellhook:
https://web.archive.org/web/20150107010129/http://shell.codeplex.com/wikipage?title=Shell%20Events
The wParam will be one of the following:

https://web.archive.org/web/20090318162820/http://doc.ddart.net/msdn/header/include/winuser.h.html
 *
 * Shell support
 *
HSHELL_ EVENTS OMITTED B/C IT'S NOT VERY CLEAR, A BETTER ONE BELOW

https://www.magnumdb.com/search?q=title%3AHSHELL_*
HSHELL_WINDOWCREATED		1
HSHELL_WINDOWDESTROYED		2
HSHELL_ACTIVATESHELLWINDOW	3
HSHELL_WINDOWACTIVATED		4
HSHELL_GETMINRECT		5
HSHELL_REDRAW			6
HSHELL_TASKMAN			7
HSHELL_LANGUAGE			8
HSHELL_SYSMENU			9
HSHELL_ENDTASK			10
HSHELL_ACCESSIBILITYSTATE	11
HSHELL_APPCOMMAND		12
HSHELL_WINDOWREPLACED		13
HSHELL_WINDOWREPLACING		14
HSHELL_MONITORCHANGED		16
HSHELL_HIGHBIT			32768
HSHELL_FLASH			32774
HSHELL_RUDEAPPACTIVATED		32772

None of these were usable for detecting when the user unminimizes an app,
which is necessary because these HSHELL_ events causes minimized apps to become unminimized/affected by this script
They should obviously remain minimized. Therefore I'll use a different event watcher as well that's taking over this responsibility
*/
ShellMessage( wParam, lParam ) 
{
	Global

	if (A_IsPaused)
		Return
	
	; WS2 is deactivated
	If ( vWinSize2_Not_Active = 1 )
		Return

	; If ( Name <> "" )
	; If ( wParam = 1 )
	If ( wParam = 2 )
	{
local Title, Class ;, windowToProcess
		;  name of process identified by lParam
		WinGet , Name  , ProcessName , ahk_id %lParam%
		;  list of windows owned by the program
		WinList1 :=
		WinList2 :=
		WinList3 :=
		WinGet , WinList , List        , ahk_id %lParam%
		; title of the window identified by WinList1
		; If set to <> "": has to be processed next
		If ( WinList > 0 )
		{
			WinGetTitle , Title , ahk_id %WinList1%
			WinGetClass , Class , ahk_id %WinList1%
		}
		; Tooltip ShellMessage %wParam%  %lParam%  "%Name%"

		AW_Title_hWnd := WinList1

/*
windowToProcess := % Title Class
if (finishedWinIds.HasKey(windowToProcess))
{
	loop % finishedWinIds[windowToProcess].Length()
		if (finishedWinIds[windowToProcess][A_Index] = hWnd)
		{
			finishedWinIds.RemoveAt(A_Index)
			break
		}
}
*/
		
		If 0   ; If ( wParam = 1 )
		{
			;* AAAA
			/*
			If ( Tooltip_Show_Store )
			*/
			If ( 1 )
			{
			TTL := 003
			TTLMsg := 
			TTLMsg := ATime() ":  (" TTL ")  ShellMessage " wParam " / " lParam "  ::  " Name "`n" WinList "/" WinList1 ":"  Title "/" WinList2 "/" WinList3
			Tooltip_%TTL% := TTLMsg
			/*
			If ( Tooltip_Show_Tip = 1 )
			*/
			If ( 1 )
			{
			CoordMode, ToolTip, Screen
			Tooltip %TTLMsg%  ,TTX , TTL*TTM, TTL+TTP ;%
			CoordMode, ToolTip, Relative
			}  }
			;* EEEE
		}

		LogText := "Window is finished; ShellMessage 2 from Windows"
		mLogFile_Write( 3, LogText )

	}
	
	; mProcessActiveWindow()
	
Return
}


/*
 *************************************************************************
 search for a special window name and, if correct, move it to a given place
 
 The names of the windows to be moved are held in a table
 located in the users "documents and settings":
 "C:\Documents and Settings\<USER>\Application Data\AutoHotkey\Stars Little Helper.INI"
 
 Method:
 =====================
 - Load a program and
 - Position the desired window on screen,
 - Change the X- and Y-size to the desired size
 - Press <Ctrl+Alt+Y> once to include a new window into the table
   OR to change the position / size of an existing window in the table (overwrite)
 
 - Edit the name in the table-entry (press <Ctrl+Alt+Y> 3 times) if you
   want to apply the new size to different captions like the editor that
   contains the editors name plus the pathname of the edited file like:

      Notepad++ - D:\Install\Autohotkey\Helper.ahk
   
   you may change it to:
   
      Notepad++

   Attention please if you alter the INI-File
   Do not destroy the first pipe symbol(s) "|" !!
   
 - Functions for Window Resize:
 
   Press <Ctrl+Alt+Y> N times shortly after each other (not longer then 500 msec):
 
 <Ctrl+Alt+Y>
 pressed
 n times
 -----		--------------------------------------------------------------
	1		insert or override the on-top Windows into table
				set the Contains-parameter to "Whole title must match"
			
	2		delete the table-entry for the on-top window
	
	3		edit the match parameter for the on-top window title
			select PART of the name:
				that PART must be contained in the title
			restore full name manually:
				set match to: "Whole title must match"
			clear all of the characters (blank line):
				restore full name of the window and
				set match to: "Whole title must match"
   
 What is missing:
 
- Please send me a mail.
 
 */

/*
 *************************************************************************
 *
 *  periodically executed method "mActWin_Timer"
 *
 *  executed e.g. every 100 msec
 *
 *************************************************************************
 */

mActWinFkt()
{
	Global

mActWin_Timer:

	SetTimer, mActWin_Timer, Off
	; clear Tooltip after predefined time
	If ( Tooltip_Time_Next > 0 )
	{
		If ( Tooltip_Time_Next < A_TickCount )
		{
			Tooltip ,, vCtrl_Alt_Y_MouseX, vCtrl_Alt_Y_MouseY, 20
			Tooltip_Time_Next := 0
		}
	}
	
	;  = 1: WS2 deactivated
	If ( vWinSize2_Not_Active <> 1 )
	{
		mActWin_Timer_Zhl += 1
		If ( mActWin_Timer_Zhl > 9999 )
			mActWin_Timer_Zhl := 1
		; msgbox SetTimer mActWin_Timer Off

		mScreen_Size()
		Update_WinSize2()
		Exclude_List()

		
		If ( vIniScreen_Time_End > 0 
			AND vIniScreen_Time_End < A_TickCount )
		{
			vIniScreen_Time_End := 0 
			WinSize2_IniScreen_Hide()
		}
		

		; clear sign-on tooltip
		If ( Tooltip_Show_Tip_SignOn > 0 
			AND Tooltip_Show_Tip_SignOn < A_TickCount )
		{
			Tooltip_Show_Tip_SignOn := 0
			Tooltip, % "" ,TTX , TTL*TTM, 1+TTP   ;%;
		}

		mProcess_ActiveWindow()
	}
	
	;SetTimer, mActWin_Timer, On

Return
}

/*
 ***************************************************************************
 *  sub mActWin_Timer_SetTimer
 *  switch timer on or off from outside the routine
mActWin_Timer_SetTimer( OnOff )
{
	If ( OnOff = 0 )
		SetTimer, mActWin_Timer, Off
	;Else
		;SetTimer, mActWin_Timer, On
Return
}
 */

mProcess_ActiveWindow()
{
	Global
	
	LogTrace := "Trace: "
	LogTrace_StartTime := A_TickCount

	; =*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
	; --- get parameter of Active Window (AW_.. ) window must be visible
	; Delete_All_Tooltips()
   ;	WinGetActiveStats , New_Title, New_Width, New_Height, New_X, New_Y
   ;	WinGetClass , AW_AhkClass, %New_Title%
   ;	AW_UniqueID := WinExist( New_Title )

mProcess_ShellMessage:
   ;	LogTrace .= ":1=" New_Title ": Cl=" AW_AhkClass ": ID=" AW_UniqueID
   ;	New_Title1 =   ; if string is empty
   ;	StringSplit , New_Title, New_Title, `n
   ;	New_Title := New_Title1
	
AW_AhkClass := Stack_Pop( "ShellMsg" )
AW_Title := Stack_Pop( "ShellMsg" )

	; --- should also work, if window does not have the focus
	;     e.g. in case of a window where we got a "Created Message"
	;     that is not active now
	WinGet      , AW_UniqueID, ID, %AW_Title% ahk_class %AW_AhkClass%
	WinGetPos   , New_X, New_Y, New_Width, New_Height, %AW_Title% ahk_class %AW_AhkClass%
	
	; WinGetTitle , New_Title, ahk_id %AW_UniqueID%
	; New_Title1 =   ; if string is empty
	; StringSplit , New_Title, New_Title, `n
	; New_Title := New_Title1
	split_AhkClass_Set( -1, AW_AhkClass )

	; Tooltip % "New_Title-1:`n" New_Title "`n" AW_UniqueID "  Cl=" AW_AhkClass "`n" New_Width " / " New_Height " / " New_X " / " New_Y  ;%;
	; =*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
   /*
	; --- remember the last window activated -------------------------
	;     for "Last Add/Overwrite" and "Last Delete" in the try
	If ( New_Title != "" )
	{
		LogTrace .= ":1.0"
		If ( AW_UniqueID = AW_Last_UniqueID 
			AND New_Title = AW_Last_Title
			AND ( ! XYWH_Last_or_Always)  )
		{
			Match := 0
			If ( AW_Last_MatchMode = 3 OR AW_Last_MatchMode = "" )   ; 2:contains  3:exact match
			{
				; If ( New_Title = AW_Last_Title ) {}
					Search_Title := AW_Last_Title
					Match := 1
					LogTrace .= ".1=" Search_Title
			}
			Else
			{
				If ( AW_Last_Title_inTable = "" )
					Search_Title := AW_Last_Title
				Else
					Search_Title := AW_Last_Title_inTable
				Match := InStr( New_Title , Search_Title )
				LogTrace .= ".2=" Search_Title
			}
			; --- the same as last time ?
			If ( Match )
			{
				If ( AW_Last_ListIndex <> AW_ListIndex )
				{
					AW_Last_ListIndex := AW_ListIndex 
					mAWNr_Display()
				}

				;* AAAA
				If ( Tooltip_Show_Store )
				{
				TTL := 002
				TTLMsg := 
				TTLMsg := ATime() ":  (" TTL ") AS BEFORE #" AW_ListIndex " (" AW_Last_MatchMode ") ***     " Titles_Sort_Basis Titles_Sort_ZA "  ID=" AW_UniqueID " Cl=" AW_AhkClass "  /" Search_Title
				Tooltip_%TTL% := TTLMsg
				If ( Tooltip_Show_Tip = 1 )
				{
				CoordMode, ToolTip, Screen
				Tooltip %TTLMsg%  ,TTX , TTL*TTM, TTL+TTP ;%
				CoordMode, ToolTip, Relative
				}  }
				;* EEEE

				AW_AsBefore := 1
				
				; ------------------------
				ChkInactiveWindows()
				;If ( Inactive_RowNo = 0 )
				;{
					;Tooltip WinActivate  %Inactive_Title%  %Inactive_RowNo%
					;WinActivate , %Inactive_Title%
					;LogText := "WinActivate:" Inactive_Title ":"
					;mLogFile_Write( 4, LogText )
					;Sleep 4000
					;AW_Last_UniqueID := 0   ; prevent entering a second time
					;Goto mActWin_2nd_Time
				;}
				LogTrace .= ":1.3"
				
				;------------------------------------------------------------------------------
				; is there a message from the Windows message system about a new created window ?
				AW_AhkClass := Stack_Pop( "ShellMsg" )
				New_Title := Stack_Pop( "ShellMsg" )
				; LogText = Stack_Pop  T:%New_Title%:  Cl=%AW_AhkClass%:
				; mLogFile_Write( 4, LogText )
				; tooltip % ATime() "  " LogText
				
				If ( New_Title <> "" )
				{
					;* AAAA
					;TTL := 003
					;TTLMsg := ATime() ":  (" TTL ")  ShellMessage Pop from stack  :" New_Title ": Cl=" AW_AhkClass
					;Tooltip_%TTL% := TTLMsg
					;CoordMode, ToolTip, Screen
					;Tooltip %TTLMsg%  ,TTX , TTL*TTM, TTL+TTP ;%
					;CoordMode, ToolTip, Relative
					;* EEEE

					LogText := "POP ShellMessage from stack  :" New_Title ": Cl=" AW_AhkClass
					mLogFile_Write( 4, LogText )
					; msgbox %logtext%

					LogTrace .= ".4"
					Goto mProcess_ShellMessage
				}
				;------------------------------------------------------------------------------
				

				LogTrace .= ".5"
				Goto mActWin_Timer_Return   ; Kurz-Schluss
				; ------------------------
			}
		}
		
		AW_AsBefore := 0
		AW_Last_Title := AW_Title
		AW_Last_UniqueID := AW_UniqueID
		AW_Last_AhkClass := AW_AhkClass
		AW_Last_Width := AW_Width
		AW_Last_Height := AW_Height
		AW_Last_X := AW_X
		AW_Last_Y := AW_Y
		
		; Display_All_AW_Slots(13)
	}
   */
   ;	AW_Title := New_Title
	AW_Width := New_Width
	AW_Height := New_Height
	AW_X := New_X
	AW_Y := New_Y
	; ----------------------------------------------------------------

	; --- WinGet, OutputVar [, Cmd, WinTitle, WinText, ExcludeTitle, ExcludeText]
	; --- Quick Mode A: get GID of active Window

	;* AAAA
	If ( Tooltip_Show_Store )
	{
	TTL := 001
	TTLMsg := 
	TTLMsg := ATime() ":  (" TTL ") mActWin_Timer  ***  "  " ID=" AW_UniqueID " Cl=" AW_AhkClass " /"  AW_Title
	Tooltip_%TTL% := TTLMsg
	If ( Tooltip_Show_Tip = 1 )
	{
	CoordMode, ToolTip, Screen
	Tooltip %TTLMsg%  ,TTX , TTL*TTM, TTL+TTP ;%
	CoordMode, ToolTip, Relative
	}  }
	;* EEEE

	; ========== short end ==========
	If ( AW_Title = "" )
	{
		LogTrace .= ":2"
		AW_TitleOld := 
		AW_Last_UniqueID := 0
		Goto mActWin_Timer_Return
	}
	; ==============================


	If ( AW_X = -1 )
						AW_X = -2
	If ( AW_Y = -1 )
						AW_Y = -2
	If ( AW_Width = -1 )
						AW_Width = -2
	If ( AW_Height = -1 )
						AW_Height = -2

	; =*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
	AW_ListIndex := mActWin_CheckExists()
	mWinSize2_StringSplit( AW_ListIndex )
	; Tooltip Name: %AWNr_Array_1% %AWNr_Array_2% %AWNr_Array_3% %AWNr_Array_4% %AWNr_Array_5%
	; Sleep 500
	; =*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
	
	mWinSize2_WinMove( 0 )
	
mActWin_Timer_Return:

Return
}
	
; =*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
mWinSize2_WinMove( command_nr )
{

	Global
	
	If ( command_nr = 1 )
	{
		AW_TitleOld := 
		LogTrace := "ExtCall:" AW_Title
	}
	
	; --- XY_Always  OR  WH_Always
	XY_Always := split_XY_Always
	WH_Always := split_WH_Always
	XYWH_or_Always := XY_Always OR WH_Always
	XYWH_and_Always := XY_Always AND WH_Always
	; dont overwrite act class (for class changing programs)
	;KK AW_AhkClass := split_AhkClass_Name

	XY_Last_Always := XY_Always
	WH_Last_Always := WH_Always
	XYWH_Last_or_Always := XYWH_or_Always
	XYWH_Last_and_Always := XYWH_and_Always

		; the focus of the window changed to another window
	; Tooltip Actual window: %AW_Title%  ALWAYS: %XY_Always%  %WH_Always%   %XYWH_or_Always%
	If ( AW_TitleOld <> AW_Title  OR  XYWH_or_Always )
	{
		; ----------------------------------------------------------
		; --- does active window exist in out list of titles?
		If ( command_nr = 0 )
			AW_ListIndex := mActWin_CheckExists()
		LogTrace .= ":2=" AW_ListIndex

		; Tooltip Window changed since last time `nold: %AW_TitleOld% `nnew: %AW_Title% `nList: %AW_ListIndex%
		; ----------------------------------------------------------

		If ( AW_TitleOld <> AW_Title )
			AW_UniqueID_Old := 0
		AW_TitleOld = %AW_Title%
		AW_MatchMode := split_MatchMode
		;Tooltip mActWin_Timer / AW_ListIndex: %AW_ListIndex% ID= %AW_UniqueID% Cl= %AW_AhkClass%
		; Sleep 5000
		; --- name of windows IS in the list
		If ( AW_ListIndex <> 0  OR  XYWH_or_Always )
		{
			/*
			AW_UniqueID_Old := AWNr__GID_%AW_ListIndex%
			If ( AW_UniqueID_Old = "" )
			{
				LogTrace .= ":3a"
				AW_UniqueID_Old := 0
			}
			*/
			LogTrace .= ":3=" AW_UniqueID_Old "," AW_UniqueID
			
			;Tooltip Win "%AW_Title%" / List:  %AW_ListIndex% `nold:%AW_UniqueID_Old% `nnew:%AW_UniqueID%
			;Sleep 5000
			;If ( AW_UniqueID_Old = AW_UniqueID  AND  XYWH_or_Always )
			;		Tooltip ID gleich aber: "%XY_Always%" "%split_WH_Always%" 
			; --- when window appears for the first time

			If ( AW_UniqueID_Old <> AW_UniqueID 
				OR ( AW_UniqueID_Old = AW_UniqueID  AND  XYWH_or_Always ) )
			{
				LogTrace .= ":4"
; tooltip % "zzzzzzzzzzzzzzzzzz" AW_UniqueID_Old "  " AW_UniqueID "zzzzzzzzzzzzzzzzzz"  ;%
				AW_UniqueID_Old := AW_UniqueID 
				; Tooltip FIRST time: %AW_ListIndex%   GID old: %AW_UniqueID_Old%   new: %AW_UniqueID%
				;Sleep %vTooltipIntSleep%
				AWNr__GID_%AW_ListIndex% = %AW_UniqueID%
				AWNr__AhkClass_%AW_ListIndex% = %AW_AhkClass%
				; Tooltip AWNr__GID_%AW_ListIndex% = %AW_UniqueID%
				; --- if any of these number = -1:
				;     do not alter this parameter, take the existing value
				AMove_2 = %AWNr_Array_2%    ; X
				AMove_3 = %AWNr_Array_3%    ; Y
				AMove_4 = %AWNr_Array_4%    ; Width
				AMove_5 = %AWNr_Array_5%    ; Height

				AMove_8 = %AWNr_Array_8%    ; Delay
				AMove_9 = %AWNr_Array_9%    ; XY Always
				AMove_10 = %AWNr_Array_10%  ; WH Always
				AMove_11 = %AWNr_Array_11%  ; Norm/Min/Max/FullScreen
				; AMove_12 = %AWNr_Array_12%  ; AhkClass

				; --- XY should be fixed: if demanded X/Y <> actual, set actual
				If ( AMove_9  <> 0 )
					If ( AMove_2 <> AW_X OR AMove_3 <> AW_Y )
					{
						/*
						If ( XYWH_and_Always ) 
							WinSet, Disable,, A   ; fix window: no movement
						Else
							WinSet,  Enable,, A   ; window can be moved now
						*/
						;*** (1067)  WinSize2: X- and Y-position cannot be changed: LOCKED by "always"
						Tooltip % Message_Get(1067)  ;%;
						If ( AW_X_old <> AW_X  OR  AW_Y_old <> AW_Y )
						{
							AW_Tick_old := A_TickCount
						}
						AW_X_old := AW_X
						AW_Y_old := AW_Y
					}
				; --- WidthHeight should be fixed: if demanded W/H <> actual, set actual
				If ( AMove_10 <> 0 )
					If ( AMove_4 <> AW_Width OR AMove_5 <> AW_Height )
					{
						;*** (1068)  WinSize2: Width and Height cannot be changed: LOCKED by "always"
						Tooltip  % Message_Get(1068)  ;%;
						If ( AW_Width_old <> AW_Width  OR  AW_Height_old <> AW_Height )
						{
							AW_Tick_old := A_TickCount
						}
						AW_Width_old := AW_Width
						AW_Height_old := AW_Height
					}

				Err := 0
WinGetActiveStatsError:
				If ( Err = 1 )
				{
					Err := 0
					; WinGetActiveStats , AW_Title, AW_Width, AW_Height, AW_X, AW_Y
					WinGetPos , AW_X, AW_Y, AW_Width, AW_Height, %AW_Title%
				}

				AMove_2Star := 
				AMove_3Star := 
				AMove_4Star := 
				AMove_5Star := 
				If ( AMove_2 = -1 ) 
				{
									AMove_2Star := "*"
									AMove_2 := AW_X
					If ( AMove_2 = 0 )
					{
						AMove_2 := -1
						Err := 1
					}
				}
				If ( AMove_3 = -1 )
				{
									AMove_3Star := "*"
									AMove_3 := AW_Y
					If ( AMove_3 = 0 )
					{
						AMove_3 := -1
						Err := 1
					}
				}
				If ( AMove_4 = -1 )
				{
									AMove_4Star := "*"
									AMove_4 := AW_Width
					If ( AMove_4 = 0 )
					{
						AMove_4 := -1
						Err := 1
					}
				}
				If ( AMove_5 = -1 )
				{
									AMove_5Star := "*"
									AMove_5 := AW_Height
					If ( AMove_5 = 0 )
					{
						AMove_5 := -1
						Err := 1
					}
				}
				If ( Err = 1 )
				{
					LogText := "* " "WinGetActiveStatsError: " AW_Title " / " AMove_2Star AMove_2 " / " AMove_3Star AMove_3 " / " AMove_4Star AMove_4 " / " AMove_5Star AMove_5
					mLogFile_Write ( LogText )
					Goto WinGetActiveStatsError
				}

				If ( split_MinNormMax = 5 )  ; full screen
				{
					If ( split_FullScr_Sum = "" )
						split_FullScr_Sum := mFullScreen_Find( AW_Title_inTable )
				}
				; do the MOVE whatever is to do later
				; -- so maximize can be done on the right screen if more than one exist
				SetTitleMatchMode, %split_MatchMode%   ; 1: start with  2: contains  3: exact match
				; split_MinNormMax   1:Normal  2:Hidden  3:Minimized  4:Maximized  5:FullScreen
				AW_Last_MatchMode := split_MatchMode
				AW_Last_Title_inTable := AW_Title_inTable
				
				Exclude_List_Timer := 0
				Exclude_List()
static finishedWinIds := {}
/*
WinGet, AW_UniqueID, ID, %AW_Title% ahk_class %AW_AhkClass%
local windowToProcess := % AW_Title AW_AhkClass
local mayContinue := 1
if (finishedWinIds.HasKey(windowToProcess))
{
	loop % finishedWinIds[windowToProcess].Length()
		if (finishedWinIds[windowToProcess][A_Index] = AW_UniqueID)
		{
			mayContinue := 0
			break
		}
}
else
	finishedWinIds[windowToProcess] := []
*/

				If ( ( AW_Title_Fnd_inExcludeTable = 0 
					OR XYWH_or_Always 
					OR command_nr = 1 )
AND ( !finishedWinIds.HasKey(windowToProcess)
	OR finishedWinIds[windowToProcess] != AW_UniqueID ) )
;AND mayContinue )
				{

					; check the Title does exist: if not, UniqueID is set to blank
					WinGet    , AW_UniqueID, ID    , %AW_Title% ahk_class %AW_AhkClass%
					If ( AW_UniqueID = "" )
					{
						; LogText := "Move Abort: Does not exist any longer: " AW_Title
						; mLogFile_Write( 3, LogText )
						LogTrace .= ":5b.NExist-Abort"
						Goto LogFile_Write_Exit
					}
					split_Window_Delay := AMove_8
					; *** (1173) WinSize2: waiting for resizing window / waiting: 0.3
					Sleep_Show( split_Window_Delay , 1173 )

					LogTrace .= ":5a"
					SetTitleMatchMode, %split_MatchMode%   ; 2: contains  3: exact
					/*
					If ( AW_AhkClass = "" )
						WinActivate %AW_Title%
					Else
						WinActivate %AW_Title% ahk_class %AW_AhkClass%
					*/

					; WinRestore --- Unminimizes or unmaximizes ---
					; WinMove, WinTitle, WinText, X        , Y       [, Width    , Height, ExclTitle, ExclText]

					; if window starts maximized it will be moved and resized in maximized mode
					; = attributes not movable / not resizable are not changed
					; = first set window to resizable mode with WinRestore, then move
					; (seen with IrfanView)
					WinRestore  %AW_Title% ahk_class %AW_AhkClass%
					; Sleep 50
					; WinGetActiveStats , New_Title, New_Width, New_Height, New_X, New_Y
					WinGetPos , Old_X, Old_Y, Old_Width, Old_Height, %AW_Title% ahk_class %AW_AhkClass%
					LogText := "Restored_from_OLD:"  AW_Title " Cl=" AW_AhkClass " M=" split_MatchMode "  " Old_X "/ " Old_Y "/ " Old_Width "/ " Old_Height
					mLogFile_Write( 3, LogText )

					WinMove     %AW_Title% ahk_class %AW_AhkClass% ,, %AMove_2%, %AMove_3%, %AMove_4%, %AMove_5%
finishedWinIds[windowToProcess] := AW_UniqueID
;finishedWinIds[windowToProcess].Push(AW_UniqueID)

					;  wait a time and read back the paras of the moved window
					; Sleep 50
					; WinGetActiveStats , New_Title, New_Width, New_Height, New_X, New_Y
					WinGetPos , New_X, New_Y, New_Width, New_Height, %AW_Title% ahk_class %AW_AhkClass%
					
					LogText := "Move " MoveText "  :" AW_Title " ID=" AW_UniqueID " Cl=" AW_AhkClass " " AMove_2Star AMove_2 "/ " AMove_3Star AMove_3 "/ " AMove_4Star AMove_4 "/ " AMove_5Star AMove_5 " (before: " Old_X "/ " Old_Y "/ " Old_Width "/ " Old_Height ")  [after: " New_X "/ " New_Y "/ " New_Width "/ " New_Height "]"
					mLogFile_Write( 2, LogText )
					; msgbox WinMove %AW_Title%

					;* AAAA
					If ( Tooltip_Show_Store )
					{
					TTL := 008
					TTLMsg := ATime() ":  (" TTL ")   ***MOVE*** " AW_Title_Fnd_canMove ": Index: " AW_ListIndex "`n" AW_UniqueID "    " AW_Title "  /" AMove_2 "/" AMove_3 "/" AMove_4 "/" AMove_5
					Tooltip_%TTL% := TTLMsg
					If ( Tooltip_Show_Tip )
					{
					CoordMode, ToolTip, Screen
					Tooltip %TTLMsg%  ,TTX , TTL*TTM, TTL+TTP ;%
					CoordMode, ToolTip, Relative
					}  }
					;* EEEE

					; msgbox WinMove done: %AW_Title%  %AMove_2%  %AMove_3%  %AMove_4%  %AMove_5%

					If ( split_MinNormMax = 5 )  ; full screen
					{
		LogTrace .= ":6"
		If ( split_Window_Delay > 0 )
		LogTrace .= "(" split_Window_Delay "ms)"
						; send as quick as possible
						; SetKeyDelay [, Delay, PressDuration, Play]
						SetKeyDelay, %Char_Delay_msec%, -1

						; *** (M1174) WinSize2: SENDING CHARACTERS to this window
						Sleep_Show( split_Window_Delay , 1174 )

						Send %split_FullScr_Sum%
						LogText := "Send_to:" AW_Title " ID=" AW_UniqueID "  /" split_FullScr_Sum "/"
						mLogFile_Write( 3, LogText )
						; WinSet , Top,, %AW_Title%
						; WinSet , Top,, A
						
						; Tooltip waiting for WinGet for a Full Screen window
						; Sleep 1000
						; Tooltip WinGet is executed now
						; is window still reachable
						WinGet , Count , Count , %AW_Title%
						; WinGet , Count , Count , A

						;  --- full screen window has got another (Title+ID)
						;  some - not all - have no title and had got another ID
						;  but they should exist again when leaving full screen mode
						If ( Count = 0 )
						{
		LogTrace .= ":7a"
							RowNo := Exclude_List_INS( AW_Title_inTable, AW_UniqueID, 1, split_MatchMode )
							Exclude_Text = %Exclude_IO_1%  %Exclude_IO_2%   is Protected: %Exclude_IO_3%  
						}
						Else
						{
		LogTrace .= ":7b"
							RowNo := Exclude_List_INS( AW_Title_inTable, AW_UniqueID, 0, split_MatchMode )
							Exclude_Text = %Exclude_IO_1%  %Exclude_IO_2%  NOT Protected: %Exclude_IO_3%  Cnt:%Count%
						}

						;* AAAA
						If ( Tooltip_Show_Store )
						{
						TTL := 007
						TTLMsg := ATime() ":  (" TTL ")   " Exclude_Text
						Tooltip_%TTL% := TTLMsg
						If ( Tooltip_Show_Tip )
						{
						CoordMode, ToolTip, Screen
						Tooltip %TTLMsg%  ,TTX , TTL*TTM, TTL+TTP
						CoordMode, ToolTip, Relative
						}  }
						;* EEEE


					}
					Else If ( split_MinNormMax = 1 )  ; normal
					{
					}
					Else If ( split_MinNormMax = 2 )  ; hidden
					{
						WinHide A
					}
					Else If ( split_MinNormMax = 3 )  ; minimize
					{
						WinMinimize A
					}
					Else If ( split_MinNormMax = 4 )  ; maximize
					{
						WinMaximize A
					}
					If ( split_MinNormMax <> 5 )  ; maximize
						RowNo := Exclude_List_INS( AW_Title_inTable, AW_UniqueID, 0, split_MatchMode )
				}
				
				WinGet, ExStyle, ExStyle, A
				If ( ExStyle & 0x8 )  ; 0x8 is WS_EX_TOPMOST, the window is always-on-top
					Window_AlwaysOnTop := 1
				Else
					Window_AlwaysOnTop := 0

				; WinSet AlwaysOnTop, [On/Off/Toggle], WindowName
				If ( AWNr_Array_7 = 0 )
				{
					If ( Window_AlwaysOnTop )
					{
						LogTrace .= ":8a"
						WinSet AlwaysOnTop, Off, A
						;tooltip WinSet AlwaysOnTop Off 001
					}
				}
				Else
				{
					If ( ! Window_AlwaysOnTop )
					{
						LogTrace .= ":8b"
						WinSet AlwaysOnTop, On, A
						;tooltip WinSet AlwaysOnTop On 002
					}
				}
				
				;listvars
				;msgbox WINMOVE: "%AW_Title%" to: `nX:%AMove_2% `nY:%AMove_3%  `nW:%AMove_4% `nH:%AMove_5% `nM=%split_MatchMode%  ":"
				;Sleep %vTooltipIntSleep%
			}
		}

LogFile_Write_Exit:
		LogTrace_Diff := A_TickCount - LogTrace_StartTime
		LogTrace .= "[" LogTrace_Diff "ms]"
		mLogFile_Write( 3, LogTrace )
		If ( AW_ListIndex > 0 )
		{
			;* AAAA
			If ( Tooltip_Show_Store )
			{
			TTL := 006
			TTLMsg := ATime() ":  (" TTL ")   " LogTrace
			Tooltip_%TTL% := TTLMsg
			If ( Tooltip_Show_Tip )
			{
			CoordMode, ToolTip, Screen
			Tooltip %TTLMsg%  ,TTX , TTL*TTM, TTL+TTP
			CoordMode, ToolTip, Relative
			}  }
			;* EEEE
		}
		mActWinGetGID()
	}

	Return
}

/*
 **************************************************************
 */
Sleep_Show( Wait_Time , Msg_Nr )
{

	Global Delay_Show_Tooltip
	
	If ( Wait_Time <= 300 )
	{
		Sleep Wait_Time
		Return
	}

	; msgbox Sleep_Show %Wait_Time%   %Msg_Nr%  "%Delay_Show_Tooltip%"
	
	Text := Message_Get( Msg_Nr )
	; FormatFloat := A_FormatFloat
	; SetFormat Float, 0.1
	
	; --- Delay for resizing the window
	Wait_Time_Int := Wait_Time
	
	While  Wait_Time_Int > 0
	{
		If ( Delay_Show_Tooltip )
		{
			Wait_Proz := 1 - ( Wait_Time_Int / Wait_Time )
			Wait_sChr := Floor( 30 * Wait_Proz )
			Wait_uChr := 30 - Wait_sChr
			Wait_aChr := Wait_sChr + Wait_uChr
			Wait_Text := "!"
			Loop %Wait_sChr%
			{
				Wait_Text .= "*"
			}
			Loop %Wait_uChr%
			{
				Wait_Text .= "_"
			}
			Wait_Text .= "!"
			Text0 = %Text%    %Wait_Text% `n
			Tooltip %Text0% , 30 , 30
		}
		Wait_Time_Int -= 50
		Sleep 50
	}
	
	If ( Wait_Time > 0 )
		Tooltip   ; clear tip
	; SetFormat Float, %FormatFloat%
	Return
}
/*
 **************************************************************
 */
WinSize2_IniScreen_Show()
{
	Global
	
	iVersion := vVersion

	Gui, 2:Color, White
	Gui, 2:-Caption
	Gui, 2:Font, S12 W800, %FontName%
	Gui, 2:Add, Picture, x1 y1    h320 w400, WinSize2_IniScreen.jpg
	Gui, 2:Add, Text, x270 y275 w200 h30 giVersion, %iVersion%
	Gui, 2:Show, Center h322 w402, WinSize2 INI
Return

iVersion:
	Gui, 2:Submit, NoHide
	Return

}   ; END WinSize2_IniScreen_Show
/*
 **************************************************************
 */
WinSize2_IniScreen_Hide()
{
	Global
	
	Gui , 2:Hide   ; the "INI Screen"

	Return

}   ; END WinSize2_IniScreen_Hide

/*
 *************************************************************************
 *
 *  method   Display_All_AW_Slots()
 *
 *************************************************************************
 */

/*
If ( Tooltip_Show_Store )
{
TTL := 013
TTLMsg := ATime() ":  (" TTL ") Last Win: " AW_Title " " AW_X " " AW_Y 
Tooltip_%TTL% := TTLMsg
If ( Tooltip_Show_Tip )
{
CoordMode, ToolTip, Screen
Tooltip %TTLMsg%  ,TTX , TTL*TTM, TTL+TTP ;%
CoordMode, ToolTip, Relative
}  }
*/

Display_All_AW_Slots(Cnt)
{
	Global
	
	; If ( Tooltip_Show_Tip )
	{
		LoopText =
		Loop , %AWNr_CntEntries%
		{
			mWinSize2_StringSplit( A_Index )
			AW_Title = %split_Title%
			; split_MatchMode := AWNr_Array_6   ; 1: start with  2: contains  3: exact match
			MatchMode := 2
			SetTitleMatchMode, %MatchMode%
			SetTitleMatchMode, slow
			; SetTitleMatchMode, 2
			
			If ( split_AhkClass_Name = "" )
			{
				; Delete_All_Tooltips()
				WinGet, AW_GID, ID, %AW_Title%
			}
			Else
			{
				WinGet, AW_GID, ID, %AW_Title% ahk_class %split_AhkClass_Name%
			}
			If ( AW_GID = "" )
				AW_GID := --
		
			AWNr_Element := AWNr_%A_Index%
			If ( AWNr_Element <> "" )
				LoopText = %LoopText%`n%A_Index%/%MatchMode%  GID %AW_GID%        "%AW_Title%"
			Else
			{
				LoopText = %LoopText%`n%A_Index%/0  GID 0/0        << deleted >>
				AWNr__GID_%A_Index% := 
				AWNr__AhkClass_%A_Index% := 
			}
		}
/*
If ( Tooltip_Show_Store )
{
TTL := 013
TTLMsg := ATime() ":  (" TTL ") Watched Windows: " LoopText
Tooltip_%TTL% := TTLMsg
If ( Tooltip_Show_Tip = 1 )
{
CoordMode, ToolTip, Screen
Tooltip %TTLMsg%  ,TTX , TTL*TTM, TTL+TTP ;%
CoordMode, ToolTip, Relative
}  }
*/
		; msgbox %Cnt%:   Watched Windows:  %LoopText%
	}
	Return
}

/*
 *************************************************************************
 *
 *  Get UniqueID of all windows in the list
 *
 *************************************************************************
 */
mActWinGetGID()
{
	Global

	Loop , %AWNr_CntEntries%
	{
		;-------------------------------
		mWinSize2_StringSplit( A_Index )
		;-------------------------------
		AW_Title = %AWNr_Array_1%
		AW_AhkClass = %AWNr_Array_12%

		DetectHiddenWindows On
		; split_MatchMode_Set( AWNr_Array_6 )   ; 1: start with  2: contains  3: exact match
		SetTitleMatchMode, %split_MatchMode%
		
		If ( AW_AhkClass = "" )
		{
			; Delete_All_Tooltips()
			WinGet, AW_GID, ID, %AW_Title%
		}
		; --- if Class is known: ask for a window with that class
		Else
		{
			WinGet, AW_GID, ID, %AW_Title% ahk_class %AW_AhkClass%
		}
		DetectHiddenWindows Off

		If ( AW_GID = "" )
			AW_GID := 0
		AWNr__GID_%A_Index% := AW_GID
		WinGetClass, AW_AhkClass, %AW_Title%
		AWNr__Class_%A_Index% := AW_AhkClass
		; MsgBox Title: %AW_Title%   GID "%AW_GID%"
	}
/*
If ( Tooltip_Show_Store )
{
TTL := 002
TTLMsg := ATime() ":  (" TTL ")   HWND: " AWNr__GID_1 " /2:" AWNr__GID_2 " /3:" AWNr__GID_3 " /4:" AWNr__GID_4 " /5:" AWNr__GID_5 " /6:" AWNr__GID_6 " /7:" AWNr__GID_7 
Tooltip_%TTL% := TTLMsg
If ( Tooltip_Show_Tip = 1 )
{
CoordMode, ToolTip, Screen
Tooltip %TTLMsg%  ,TTX , TTL*TTM, TTL+TTP ;%
CoordMode, ToolTip, Relative
}  }
*/	
	/*
	split_MatchMode:
	1: A window's title must start with the specified WinTitle to be a match.
	2: A window's title can contain WinTitle anywhere inside it to be a match. 
	3: A window's title must exactly match WinTitle to be a match.
	
	WinGet, OutputVar [, Cmd, WinTitle, WinText, ExcludeTitle, ExcludeText]

	*/
}

/*
; --- insert TAB / delete TAB on pos. 1
^!Right::Send {HOME}{TAB}{LEFT}{DOWN}	; <Ctrl+Alt+CursorRight>
^!Left::Send {HOME}{BACKSPACE}{DOWN}	; <Ctrl+Alt+CursorLeft>

^!X::  ; zum Testen <Ctrl+Alt+...>
msgbox 00 %AWNr_1%
Return
*/

/*
 *************************************************************************
 */
mCtrl_Alt_Y_And_Action( vCtrl_Alt_Y_Cnt )
{
	Global
/*
If ( Tooltip_Show_Store )
{
TTL := 005
TTLMsg := ATime() ":  (" TTL ") mCtrl_Alt_Y_And_Action " vCtrl_Alt_Y_Cnt
Tooltip_%TTL% := TTLMsg
If ( Tooltip_Show_Tip = 1 )
{
CoordMode, ToolTip, Screen
Tooltip %TTLMsg%  ,TTX , TTL*TTM, TTL+TTP ;%
CoordMode, ToolTip, Relative
}  }
*/
	;------------------------------------------------------------------------------
	If ( vCtrl_Alt_Y_Cnt < 0 )
	{
		AW_Title := AW_Last_Title
		AW_Width := AW_Last_Width
		AW_Height := AW_Last_Height
		AW_X := AW_Last_X
		AW_Y := AW_Last_Y
		
		XY_Always := XY_Last_Always
		WH_Always := WH_Last_Always
		XYWH_or_Always := XYWH_Last_or_Always
		XYWH_and_Always := XYWH_Last_and_Always
	}
	Else
	{
		; Delete_All_Tooltips()
		WinGetActiveStats , AW_Title, AW_Width, AW_Height, AW_X, AW_Y
		AW_Title1 =   ; if string is empty
		StringSplit , AW_Title, AW_Title, `n
		AW_Title := AW_Title1
		WinGetClass       , AW_AhkClass    , %AW_Title%
		WinGet            , AW_UniqueID, ID, %AW_Title%
		split_AhkClass_Set( -1, AW_AhkClass )
	}
	If ( AW_X = -1 )
						AW_X = -2
	If ( AW_Y = -1 )
						AW_Y = -2
	If ( AW_Width = -1 )
						AW_Width = -2
	If ( AW_Height = -1 )
						AW_Height = -2
	; Tooltip  WinGetActiveStats 01: %AW_Title%/%AW_X%/%AW_Y%/%AW_Width%/%AW_Height%
	; Sleep 3000

	SetTimer, mActWin_Timer, Off
	AIndex := mActWin_CheckExists()
	; Tooltip mActWin_CheckExists  AIndex: "%AIndex%" ,30,0,
	; Sleep 3000
	
	;------------------------------------------------------------------------------
	If ( vCtrl_Alt_Y_Cnt = 1 OR vCtrl_Alt_Y_Cnt = -1 )
	{

		; search next empty element
		AW_NeuEintrag := False
		If ( AIndex = 0 )
		{
			Loop , %AWNr_CntEntries%
			{
				AWNr_Element := AWNr_%A_Index%  
				If ( AWNr_Element = "" )
				{
					AIndex := A_Index
					; msgbox  AWNr_Element %AWNr_Element%
				}
				; Msgbox, Suche Leer: %A_Index%:%AIndex%  AWNr_%A_Index%  // %AWNr_Element%
				; sleep 3000
			}
			If ( AIndex = 0 )
			{
				AIndex := AWNr_CntEntries + 1
				; msgbox vCtrl_Alt_Y_Cnt %vCtrl_Alt_Y_Cnt% AWNr_CntEntries+1: %AWNr_CntEntries%
				; AIndex := AWNr_CntEntries
				; Msgbox nächstes nehmen: %AIndex% 
				; sleep 3000
			}
			AW_NeuEintrag := True
			split_MatchMode := 3
			; AIndex := AWNr_CntEntries
			; Tooltip AIndex war Null: %AIndex% / %AWNr_CntEntries%
			; Sleep %vTooltipIntSleep%
		}
		Else   ; Title was found 
		{
			;----------------------------------
			mWinSize2_StringSplit( AIndex )
			;----------------------------------
			AWNr_%AIndex%_alt = AWNr_1
			split_MatchMode_Set( AWNr_Array_6 )
		}
		; Tooltip WinGetActiveStats 02: %AW_Title% %AW_UniqueID%/%AW_X%/%AW_Y%/%AW_Width%/%AW_Height% 
		; Sleep 3000
		split_AhkClass_Set( -1, AW_AhkClass )
		AWNr_Name = AWNr_%AIndex%
		AWNr_Element := AWNr_%AIndex%
		Error := 0


		AWNr__GID_%AIndex% = %AW_UniqueID%
		; tooltip AWNr__GID_%AIndex% = %AW_UniqueID%
		If AW_NeuEintrag
		{
			split_MatchMode    := 3   ; --- exact match
			split_AlwaysOnTop  := 0
			split_MinNormMax   := 1
			split_Delay        := 0
			
			split_Comment_Use  := 0
			split_Comment_Text := 
			
			AWNr_Koord :=     AW_Title          CUT AW_X              CUT AW_Y
			AWNr_Koord .= CUT AW_Width          CUT AW_Height         CUT split_MatchMode
			AWNr_Koord .= CUT split_AlwaysOnTop CUT split_Delay       CUT split_XY_Always
			AWNr_Koord .= CUT split_WH_Always   CUT split_MinNormMax  CUT split_AhkClass
			AWNr_Koord .= CUT split_FullScr_Sum CUT split_Comment_Use CUT split_Comment_Text
			AWNr_Koord .= CUT AA1

			AWNr_%AIndex% := AWNr_Koord
			AWNr_Element := AWNr_%AIndex%

			If ( AIndex > AWNr_CntEntries )
				AWNr_CntEntries := AIndex
			;*** (1001)  Tooltip Inserted NEW: %AWNr_Element%
			;*** (1179)  NOT ACTIVE
			Message := 
			If ( vWinSize2_Not_Active = 1 )
			Message .= Message_Get( 1179 ) "   "
			Message .= Message_Get( 1001 )
			If ( Tooltip_Next() )
				; Tooltip %Message% (%AIndex%) : `n%AWNr_Koord%`n%AW_Title%  (%AW_AhkClass%)
				Tooltip %Message% (%AIndex%) : `n%AW_Title%  (%AW_AhkClass%)
					,vCtrl_Alt_Y_MouseX,vCtrl_Alt_Y_MouseY,20

			Message .= " " AIndex ": '" AWNr_Koord "'"
			mLogFile_Write( 2, Message )

		}
		Else   ; was changed
		{
			; keep poss. changed name like "Idoswin Pro - C:\..." to "Idoswin"  KK 2008-01-06
			; --- if any of these number <> -1:
			;     overwrite with the new values  KK 2008-09-13
			AW_Arr2 := AWNr_Array_2
			AW_Arr3 := AWNr_Array_3
			AW_Arr4 := AWNr_Array_4
			AW_Arr5 := AWNr_Array_5
			If ( AW_Arr2 <> -1 ) 
								AW_Arr2 := AW_X
			If ( AW_Arr3 <> -1 )
								AW_Arr3 := AW_Y
			If ( AW_Arr4 <> -1 )
								AW_Arr4 := AW_Width
			If ( AW_Arr5 <> -1 )
								AW_Arr5 := AW_Height
			If ( split_MinNormMax <> 5 )
								split_FullScr_Sum := 
			AWNr_Koord :=     AWNr_Array_1    CUT AW_Arr2           CUT AW_Arr3
			AWNr_Koord .= CUT AW_Arr4         CUT AW_Arr5           CUT split_MatchMode 
			AWNr_Koord .= CUT split_AlwaysOnTop CUT split_Delay     CUT split_XY_Always 
			AWNr_Koord .= CUT split_WH_Always   CUT split_MinNormMax CUT split_AhkClass
			AWNr_Koord .= CUT split_FullScr_Sum CUT split_Comment_Use CUT split_Comment_Text
			AWNr_Koord .= CUT AA1
			AWNr_%AIndex% := AWNr_Koord
			AWNr_Element := AWNr_%AIndex% 
			; msgbox Overwrite AWNr_Element: %AWNr_Element% 
			AWNr_Element := AWNr_%AIndex%
			
			;*** (1006)  Overwritten no. %AIndex%: `n%AWNr_Element%
			;*** (1179)  NOT ACTIVE
			Message := 
			If ( vWinSize2_Not_Active = 1 )
			Message .= Message_Get( 1179 ) "   "
			Message .= Message_Get( 1006 )
			If ( Tooltip_Next() )
				Tooltip %Message% (%AIndex%) : `n%AWNr_Array_1%  (%AW_AhkClass%)
					,vCtrl_Alt_Y_MouseX,vCtrl_Alt_Y_MouseY,20
				; Tooltip %Message% (%AIndex%) : `n%AWNr_Koord%`n%AWNr_Array_1%  (%AW_AhkClass%)

			Message .= " " AIndex ": '" AWNr_Koord "'"
			mLogFile_Write( 2, Message )
		}
		;listvars
		;msgbox ersetzen AW_NeuEintrag %AW_NeuEintrag% 
		vCtrl_Alt_Y_Cnt := 0
		Sort_Titles()
	}
	;------------------------------------------------------------------------------
	Else If ( vCtrl_Alt_Y_Cnt = 2  OR vCtrl_Alt_Y_Cnt = -2 )
	{
		If ( AIndex = 0 )
		{
			;*** (1049)  *** Could not delete: Actual window not found in list ***
			Message := Message_Get( 1049 )
			If ( Tooltip_Next() )
			{
				Tooltip %Message%
			}
		}
		Else
		{
			mWinSize2_StringSplit( AIndex )

			AWNr_Koord :=     AWNr_Array_1      CUT AWNr_Array_2     CUT AWNr_Array_3
			AWNr_Koord .= CUT AWNr_Array_4      CUT AWNr_Array_5     CUT AWNr_Array_6
			AWNr_Koord .= CUT split_AlwaysOnTop CUT split_Delay      CUT split_XY_Always
			AWNr_Koord .= CUT split_WH_Always   CUT split_MinNormMax CUT split_AhkClass
			AWNr_Koord .= CUT split_FullScr_Sum CUT split_Comment_Use CUT split_Comment_Text
			AWNr_Koord .= CUT AA1
			;*** (1007)  Deleted: 
			;*** (1179)  NOT ACTIVE
			Message := 
			If ( vWinSize2_Not_Active = 1 )
			Message .= Message_Get( 1179 ) "   "
			Message .= Message_Get( 1007 )
			If ( Tooltip_Next() )
				Tooltip %Message% (%AIndex%) : `n%AWNr_Array_1%
					,vCtrl_Alt_Y_MouseX,vCtrl_Alt_Y_MouseY,20

			Message .= " " AIndex ": '" AWNr_Koord "'"
			mLogFile_Write( 2, Message )

			AWNr_%AIndex% :=
			AWNr_XRef_%AIndex% := 9999
			AWNr__GID_%AIndex% := 0
			AWNr__AhkClass_%AIndex% := 
			If ( AIndex = AWNr_CntEntries )
				AWNr_CntEntries -= 1
			;listvars
			vCtrl_Alt_Y_Cnt := 0
		}
	}
	;------------------------------------------------------------------------------
	Else If ( vCtrl_Alt_Y_Cnt = 3 )
	{
		vGUI_TERMINATE_NOW := 0
		Tooltip_Next()
		Tooltip ,,,,20
		Gui, Destroy
		WinSize2_Parameter()
		; tooltip WaitGuiEnd: vGUI_TERMINATE_NOW %vGUI_TERMINATE_NOW%
		If ( vGUI_TERMINATE_NOW = 10 )   ; Abort: Discard all and Read again
			mIniRead_All_User() 
		Else   ; User said: OK
		{
			IniFile_Write_All = 1
			; mIniWrite_All_User() 
			mCtrl_Alt_Y_Init( vCtrl_Alt_Y_Hotkey, vCtrl_Alt_Y_Time )
			mCtrl_Alt_Y_Hotkey_SetMessage()
			; mMenuTrayIcon()
			mActWin_Init( vTitleTimer )

			Loop , %AWNr_CntEntries%   ; any changes in "On Top"
			{
				mWinSize2_StringSplit( A_Index )
				WinGet, ExStyle, ExStyle, %split_Title%
				If ( ExStyle & 0x8 )  ; 0x8 is WS_EX_TOPMOST, the window is always-on-top
					Window_AlwaysOnTop := 1
				Else
					Window_AlwaysOnTop := 0

				; WinSet AlwaysOnTop, [On/Off/Toggle], WindowName
				If ( split_AlwaysOnTop = 0 )
				{
					If ( Window_AlwaysOnTop )
					{
						WinSet AlwaysOnTop, Off, %split_Title%
						;tooltip WinSet AlwaysOnTop Off 003
					}
				}
				Else
				{
					If ( ! Window_AlwaysOnTop )
					{
						WinSet AlwaysOnTop, On,  %split_Title%
						;tooltip WinSet AlwaysOnTop On 004
					}
				}
				
			}
		}
	}
	;------------------------------------------------------------------------------
	Else If ( vCtrl_Alt_Y_Cnt = 4 
		AND InStr( vProgram_NNamExt, ".ahk" ) )
	{
		Reload
	}
	;------------------------------------------------------------------------------
	Else
	{
		;*** (1015)  Hotkey ignored.
		Message := Message_Get( 1015 )
		If ( Tooltip_Next() )
			Tooltip %Message% ,vCtrl_Alt_Y_MouseX,vCtrl_Alt_Y_MouseY,20
		vCtrl_Alt_Y_Cnt := 0
	}
	mMenuTrayIcon()


	IniFile_Write_All = 1 
	; Sleep %vTooltipPubSleepVeryShort%

 	;SetTimer, mActWin_Timer, On
Return
}


/*
 **********************************************************************
 */


/*
 **********************************************************************
 * Routine Sort_Titles
 */
Sort_Titles()
{
	Global
	
	; --- assign 1 to 1 to the XRefs
	If ( ! Titles_Sort_Basis )
	{
		Loop, %AWNr_CntEntries%
		{
			AWNr_XRef_%A_Index% := A_Index
		}
		mTitle_Number_XRefStr_Disp()
		Return
	}

	; --- combine all titles into 1 string TITLES
	Titles =
	; msgbox ################ Sort_Titles Anfg #####################
	Loop , %AWNr_CntEntries%
	{
		; the line-end delimiter
		If ( A_Index > 1 )
			Titles .= CUT
		AWNr_Element := AWNr_%A_Index%  
		mWinSize2_StringSplit( A_Index )
		split_MatchMode_Set( AWNr_Array_6 )
		; --- "Title<Index-Nr"
		;     CUT1 the delimiter that separates
		;     title and index-number
		; sort with comment + titles / Index-Nr
		If ( Titles_Sort_Basis AND ( Titles_Sort_wComm OR split_Comment_Use ) AND split_Comment_Text <> "" )
			Titles .= split_Comment_Text " :: " AWNr_Array_1 CUT1 A_Index
		Else
			Titles .= AWNr_Array_1 CUT1 A_Index
			
	}
	; msgbox 01 %Titles%
	; --- now sort this ( R = reverse = Z..A / D-Delimiter )
	If ( Titles_Sort_ZA )
		Sort , Titles , D%CUT% R
	; --- normal sort: ( A .. Z )
	Else If ( Titles_Sort_Basis )
		Sort , Titles , D%CUT%
	
	StringReplace , Titles_Sort_Str , Titles , %CUT%,`r`n , All
	; msgbox 02 SORT:`n%Titles_Sort_Str%
	
	; --- split the sorted titles
	StringSplit , Titles_Split_ , Titles , %CUT%
	; msgbox , % "03:  " Titles

	; --- and break in peaces again - rewrite the original lines
	;     insert the XREF section
	Titles_Str =
	Loop , %AWNr_CntEntries%
	{
		StringSplit , Titles_SplitPart_ , Titles_Split_%A_Index% , %CUT1%   ; split at CUT
		Titles_Str .= Titles_SplitPart_2 "   " Titles_SplitPart_1 "`n"
		
		mWinSize2_StringSplit( Titles_SplitPart_2 )
		
		If ( AWNr_Array_11 <> 5 )
			split_FullScr_Sum := 
		
		AWNr_Koord :=     AWNr_Array_1  CUT AWNr_Array_2  CUT AWNr_Array_3
		AWNr_Koord .= CUT AWNr_Array_4  CUT AWNr_Array_5  CUT AWNr_Array_6
		AWNr_Koord .= CUT AWNr_Array_7  CUT AWNr_Array_8  CUT AWNr_Array_9
		AWNr_Koord .= CUT AWNr_Array_10 CUT AWNr_Array_11 CUT AWNr_Array_12
		AWNr_Koord .= CUT split_FullScr_Sum  CUT split_Comment_Use CUT split_Comment_Text
		AWNr_Koord .= CUT AA1
		
		AWNr_%Titles_SplitPart_2% = %AWNr_Koord%
		AWNr_Element := AWNr_%AIndex%
		
		AWNr_XRef_%A_Index% := Titles_SplitPart_2
	}
	; listvars
	mTitle_Number_XRefStr_Disp()
	; msgbox , Sort_Titles 2: %Titles_Sort_Basis% %Titles_Sort_ZA%`n%Titles_Str%   ------2:Ende
	Return
}

/*
 **********************************************************************
 * Routine mGroup_Select
 */
mGroup_Select( Sort_Index )
{
	Global
	
	Group_Sort_Index_Str01 := Group_Sort_Index_%Sort_Index%
	
	;--------------------------------------------------------
	; get the titles and the index of the title into the AWNr_ array
	; build "Title01" CUT "Index01", ..
	Group_Content_Str02 := 
	
	Loop, Parse, Group_Sort_Index_Str01 , %CUT1%
	{
		mWinSize2_StringSplit( A_LoopField )
		; AW_ListIndex := A_LoopField
		If ( A_Index > 1 )
			Group_Content_Str02 .= CUT
		Group_Content_Str02 .= split_Title CUT1 A_LoopField
	}
	
	;--------------------------------------------------------
	; sort the titles
	; msgbox mGroup_Select-01 %Group_Content_Str02%
	; --- now sort this ( R = reverse = Z..A / D-Delimiter )
	If ( Titles_Sort_ZA )
		Sort , Group_Content_Str02 , D%CUT% R
	; --- normal sort: ( A .. Z )
	Else If ( Titles_Sort_Basis )
		Sort , Group_Content_Str02 , D%CUT%
	; msgbox mGroup_Select-02 %Group_Content_Str02%

	;--------------------------------------------------------
	; decode the titles: the _Index numbers are now sorted
	; according to the title names
	Group_Content_Str := 
	Group_Sort_Index := 
	
	Loop, Parse, Group_Content_Str02 , %CUT%
	{
		StringSplit , Group_Split_ , A_LoopField , %CUT1%
		Group_Content_Str .= "|" Group_Split_1
		If ( A_Index > 1 )
			Group_Sort_Index .= CUT1
		Group_Sort_Index .= Group_Split_2
		; msgbox %A_Index%. mGroup_Select-04 "%Group_Content_Str%"  "%Group_Sort_Index%"
	}
	;--------------------------------------------------------
	; and write the sorted _Index back
	Group_Sort_Index_%Sort_Index% := Group_Sort_Index
	
Return	
}

/*
 **********************************************************************
 * Routine mGroup_Resize
 */
mGroup_Resize( Sort_Index )
{
	Global
	
	Group_Sort_Index_Str := Group_Sort_Index_%Sort_Index%

	; StringSplit , AAA_ , Group_Sort_Index_Str , %CUT1%

	Group_Content_Out := 
	
	Loop, Parse, Group_Sort_Index_Str , %CUT1%
	{
		AW_ListIndex := A_LoopField
		mWinSize2_StringSplit( A_LoopField )
		mWinSize2_StringSplit_to_AW()
		Group_Content_Out .= "`n(" A_LoopField ") " AW_Title
		mWinSize2_WinMove( 1 )
	}
	; msgbox %Group_Choose_Nr%. mGroup_Resize %Group_Content_Out%
Return	
}

/*
 **********************************************************************
 * Routine mGroup_Sort
 *
 *  Get the Group names and sort the names
 */
mGroup_Sort()
{
	Global
	
	; --- combine all titles into 1 string TITLES
	Titles =
	Group_Cnt := 1
	; *** (1132)  <all entries>
	Group_Name_1 := Message_Get( 1132 )
	Group_Sort_Index_1 := 
	Loop , %AWNr_CntEntries%
	{
		If ( A_Index >= 2 )
			Group_Sort_Index_1 .= CUT1
		Group_Sort_Index_1 .= A_Index
	}
	; msgbox ################ Group Anfg #####################
	
	; *=*=*=*=*=*=*=*  START: search all Group names in all slots *=*=*=*=*=*=*=*
	;     construct _Name_<Nr> = Name / Index1 / Index2 / ...
	Loop , %AWNr_CntEntries%
	{
		AWNr_Element := AWNr_%A_Index%  
		mWinSize2_StringSplit( A_Index )
			
		;  InStr(Haystack, Needle [, CaseSensitive = false, StartingPos = 1])
		;  "Group:Comment"  search for a group delimiter
		Group_Colon := InStr( split_Comment_Text, ":" )
		If ( Group_Colon > 0 )
		{
			Group_Name := SubStr( split_Comment_Text, 1, Group_Colon - 1 )
			Group_Index := A_Index
			; msgbox Groupname found # %Group_Index%: %Group_Name%
			Group_CntWhile := 1
			
			; in all existing groups: search for this name
			While Group_CntWhile <= Group_Cnt
			{
				; --- exists already: do not enter but append the index
				If ( Group_Name_%Group_CntWhile% = Group_Name )
				{
					Group_Sort_Index_%Group_CntWhile% .= CUT1 Group_Index
					Group_Index := Group_Sort_Index_%Group_CntWhile%
					; msgbox Group # %Group_CntWhile% - %Group_Index% already exists: Group_Name_%Group_CntWhile%:  %Group_Name% / %Group_Index%
					Group_CntWhile := 0
					Break
				}
				Group_CntWhile += 1
			}
			; --- this is a NEW group: insert name and index
			If ( Group_CntWhile > 0 )
			{
				Group_Cnt += 1
				Group_Name_%Group_Cnt% := Group_Name
				Group_Name_Var = Group_Name_%Group_Cnt%
				Group_Sort_Index_%Group_Cnt% := Group_Index
				Group_Index := Group_Sort_Index_%Group_Cnt%
				; msgbox Group # %Group_Cnt% - %Group_Index% NEW: %Group_Name_Var%:  %Group_Name% / %Group_Index%
			}
		}
		Else
			Group_Name := 
	}
	; Result: Group_Name_xx and Group_Sort_Index_xx
	; *=*=*=*=*=*=*=*  END: search all Group names in all slots *=*=*=*=*=*=*=*

	If ( Group_Cnt = 0 )
	{
		; *** (1127)  No groups defined:|insert "Group:Comment"|to comment field
		Group_Choose_List := Message_Get( 1127 )
		Group_Cnt := 0
		Return
	}
		
	; *=*=*=*=*=*=*=*  START: Sorting: append Index_ to Name_ *=*=*=*=*=*=*=*
	Group_Sort_Name := 
	Loop , %Group_Cnt%
	{
		If ( A_Index >= 2 )
			Group_Sort_Name .= CUT
		Group_Sort_Name .= Group_Name_%A_Index% CUT1 Group_Sort_Index_%A_Index%
	}
	; msgbox 01 # %Group_Cnt% Group_Sort_Name: %Group_Sort_Name%
	; *=*=*=*=*=*=*=*  END: Sorting: append Index_ to Name_ *=*=*=*=*=*=*=*
	
	Sort , Group_Sort_Name , D%CUT%
	; msgbox 02 # %Group_Cnt% Group_Sort_Name: %Group_Sort_Name%
	
	; StringReplace , Titles_Sort_Str , Titles , %CUT%,`r`n , All
	
	; --- split the sorted titles
	StringSplit , Group_Sort_Name_ , Group_Sort_Name , %CUT%
	; msgbox , % "03:  " Titles

	; --- and break in peaces again - rewrite the original lines
	;     insert the XREF section
	If ( Group_Choose_Nr = "" )
		Group_Choose_Nr := 1
	Group_Choose_List =
	Group_Sort_Str := "Cnt: " Group_Cnt "`r`n"
	Loop , %Group_Cnt%
	{
		; Name1 CUT1 Nr1  CUT  Name2 CUT1 Nr2
		Group_Sort_Name_Index := Group_Sort_Name_%A_Index%
		Group_CUT := InStr( Group_Sort_Name_Index, CUT1 )

		Group_Sort_Name_%A_Index% := SubStr( Group_Sort_Name_Index, 1, Group_CUT - 1 )
		Group_Sort_Index_%A_Index% := SubStr( Group_Sort_Name_Index, Group_CUT + 1 )
		
		; build list for display in ListBox
		; "Entry1 | Entry2 | ..."
		If ( A_Index >= 2 )
			Group_Choose_List .= "|"
		Group_Choose_List .= Group_Sort_Name_%A_Index%
		
		Group_Sort_Str .= Group_Sort_Name_%A_Index% " :: " Group_Sort_Index_%A_Index%  "`r`n"
	}
	; Group_Choose_List .= "|a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|q|q|q|q|q|z"
	; listvars
	; msgbox %Group_Sort_Str%
	Return
}

/*
 **********************************************************************
 */


/*
 **********************************************************************
 * Routine 
 */
mActWin_CheckExists()
{
	Global

	AW_Title_inTable :=
	AW_Last_MatchMode :=
	AW_Last_Title_inTable :=
	XYWH_Last_or_Always :=
	XYWH_Last_and_Always :=

	MoveIndex := 0
	MoveText := "NOT_in_Table"

	; look if window-title already exists
	; for all titles in the list
	Loop , %AWNr_CntEntries%
	{
		AWNr_Element := AWNr_%A_Index%  
		;-------------------------------
		mWinSize2_StringSplit( A_Index )
		;-------------------------------

		split_MatchMode_Set( AWNr_Array_6 )

		; Tooltip Split: %AWNr_Array_1%
		; Titel ist in Tabelle vorhanden; Index zurückgeben
		; If ( AW_Title = AWNr_Array_1 )
		; Tooltip search: %AW_Title% // %AWNr_Array_1%
		; Sleep %vTooltipIntSleep%
		; --- split_MatchMode 2=part of title / 3=whole title 2008-01-06
		If ( split_MatchMode = 3 )
		{
			If ( AW_Title = AWNr_Array_1 )
			{
				MoveText := "FULL_in_Table(" A_Index ")"
				MoveIndex := A_Index
				Break
			}
		}
		; MatchMode <> 3
		Else
		{
			IfInString, AW_Title, %AWNr_Array_1%
			{
				MoveText := "PART_in_Table(" A_Index ")"
				MoveIndex := A_Index
				Break
			}
		}
	}
	Class_Chr := AW_AhkClass
	MoveText2 :=
	MoveClass := 0

	; --------------- the program WAS FOUND in the table ---------------
	; AND the classes of actual window
	; AND in the list are defined
	If ( MoveIndex > 0
		AND AW_AhkClass <> ""
		AND split_AhkClass_Name <> ""
		AND split_AhkClass_Name <> "-" )
	{
		; BUT the classes are not identical
		; sometimes the class is changed with each created window
		; like with "ZiLOG Developer Studio"
		; ahk_class "Afx:400000:8:10013:0:3606a3"
		;            123456789.123456789.123456789.
		; where the last 6 chars are changed

		; if ahk_class is used (>0: use it)   KKKK 2010-05-17
		If ( split_AhkClass_Used > 0 )
		{
			; if all chars of ahk_class are equal
			If ( AW_AhkClass = split_AhkClass_Name )
			{
				Class_Chr := AW_AhkClass
				MoveText2 := "Cl=" AW_AhkClass " ID=" AW_UniqueID ":"
				LogTrace .= ":101-" A_Index
				/*
				LogText := "1 " MoveText "           :" AW_Title ":" MoveText2
				mLogFile_Write( 4, LogText )
				*/
			}
			; ----- down from here:
			; ----- the ahk_class does not fit to class in list
			; ----- clear AW_AhkClass so only the AW_Title can be used
			; ----- to adress the window
			Else
			{
				; 1/2 of chars of ahk_class are equal
				Class_Len := Floor( StrLen( AW_AhkClass ) / 2 )
				Class_Chr := SubStr( AW_AhkClass, 1, Class_Len )
				If ( Class_Chr = SubStr( split_AhkClass_Name, 1, Class_Len ) )
				{
					MoveText2 := "Cls/2(L=" Class_Len "):" Class_Chr ":"
					MoveClass := 1
					LogTrace .= ":102-" A_Index
		/*
		LogText := "2 " MoveText "           :" AW_Title ":" MoveText2
		mLogFile_Write( 4, LogText )
		*/
				}
				Else
				{
					; 1/4 of chars of ahk_class are equal
					Class_Len := Floor( StrLen( AW_AhkClass ) / 4 )
					Class_Chr := SubStr( AW_AhkClass, 1, Class_Len )
					If ( Class_Chr = SubStr( split_AhkClass_Name, 1, Class_Len ) )
					{
						MoveText2 := "Cls/4(L=" Class_Len "):" Class_Chr ":"
						MoveClass := 1
						LogTrace .= ":103-" A_Index
		/*
		LogText := "3 " MoveText "           :" AW_Title ":" MoveText2
		mLogFile_Write( 4, LogText )
		*/
					}
					Else
					{
						; "-": class is passivated, all classes fit
						; especially needed for programs that change their
						; class every time the window is created
						If ( split_AhkClass_Name <> "-" )
						{
							MoveText := "NOT_in_Table "
							MoveText2 := "Cls/Error(L=" Class_Len "):" Class_Chr ":"
							MoveIndex := 0
							LogTrace .= ":104"
						}
					}
				}
			}
		}
	}


	; WAS FOUND; (may be part of) ahk_class found
	If ( MoveIndex > 0 )
	{
		AW_Title_inTable := AWNr_Array_1
	}

	;* AAAA
	If ( Tooltip_Show_Store )
	{
	TTL := 007
	TTLMsg := ATime() ":  (" TTL ")   " MoveText ": Index: " A_Index  "   "AWNr_Array_1 "`n" " ID=" AW_UniqueID " Cl=" MoveText2 "  " AW_Title 
	Tooltip_%TTL% := TTLMsg
	If ( Tooltip_Show_Tip = 1 )
	{
	CoordMode, ToolTip, Screen
	Tooltip %TTLMsg%  ,TTX , TTL*TTM, TTL+TTP ;%
	CoordMode, ToolTip, Relative
	}  }
	;* EEEE

	LogText := MoveText "             :" AW_Title ":" MoveText2
	mLogFile_Write( 4, LogText )

	Return MoveIndex
	

/*
	LogText := "NOT_in_Table              :" AW_Title ":" AWNr_Array_1
	mLogFile_Write( 4, LogText )

	;* AAAA
	If ( Tooltip_Show_Store )
	{
	TTL := 007
	TTLMsg := ATime() ":  (" TTL ")   NOT_in_Table (5): Index: " A_Index "`n"  " ID=" AW_UniqueID " Cl=" split_AhkClass_Name "  " AW_Title  
	Tooltip_%TTL% := TTLMsg
	If ( Tooltip_Show_Tip = 1 )
	{
	CoordMode, ToolTip, Screen
	Tooltip %TTLMsg%  ,TTX , TTL*TTM, TTL+TTP ;%
	CoordMode, ToolTip, Relative
	}  }
	;* EEEE


	AW_Title_inTable := 
	AW_Last_MatchMode :=
	AW_Last_Title_inTable :=
	XYWH_Last_or_Always :=
	XYWH_Last_and_Always :=
	Return 0
*/
}

; ===========================================================

/*
 **********************************************************************
 * Routine 
 */
Tooltip_Next()
{
	Global

	If ( vTooltip_Time_Show = "" )
		vTooltip_Time_Show := 3000
	If ( Tooltip_Time_Next = "" )
		Tooltip_Time_Next := 0

	If ( Tooltip_Time_Next < A_TickCount )
	{
		Tooltip_Time_Next := A_TickCount + vTooltip_Time_Show
		Return TRUE
	}
	Else
	{
		; Return FALSE
		Return TRUE
	}
}

/*
 *************************************************************************
 *   End of "WinSize"
 *************************************************************************
 */
 
 
 /******************************************************************************
 *  #Include inc_IniReadWrite.AHK
 *
 *  Date:   2005-05-06 14:27
 *  Author: Kalle Koseck
 *  Vers:   0.09
 *  Typ:    Method
 *  AHK:    1.0.35+
 *  OS:     Win 2000
 *
 *  PnP:    no;
 *          user actions needed: search for: NextUserChange
 *
 ******************************************************************************
 *
 *  Benefits:
 *
 *  - INI file only written when changes detected
 *    (set externally by calling program = has to be user provided)
 *
 *  - saved after a user selectable time interval;
 *    default setting of the time interval is supplied
 *
 *  - can be kept for different purposes in different directories
 *    (see "where does the INI file exist ?"):
 *    1. per user
 *    2. per computer
 *    3. universal per network
 *
 *  - detects external changes of the INI file done by the user e.g. with
 *    an editor; rereads INI file to fetch the user changes
 *    but discards any changes detected by the program
 *
 *  - everything is kept in one INI file, no changes to the registry
 *    made. If you don't want to use this module any longer just
 *    delete the #Include and the INI file.
 *
 *  Call:
 *
 *    IniFile_TimeInterval = 15000  ; this line omitted: default is 10 sec
 *    #Include inc_IniReadWrite.AHK
 *
 *  User has to provide two functions
 *  (see appended examples inc_IniReadWrite_User.AHK):
 *
 *    mIniRead_All_User() { ... }
 *    mIniWrite_All_User() { ... }
 *
 ******************************************************************************
 * where does the INI file exist ?
 *
 * 1.: dir in <This User>
 *     (every user has his own file)
 *     e.g. "C:\Documents and Settings\<Username>\ApplicationData\AutoHotkey\<Prog>.INI"
 *
 * 2.: dir in "All Users"
 *     (one file for all users of this computer)
 *     e.g. "C:\Documents and Settings\All Users\ApplicationData\AutoHotkey\<Prog>.INI"
 *
 * 3.: in %A_WorkingDir%
 *     (the dir that contain the (main) AHK file:
 *     universal setting if AHK file is e.g. in a mapped drive on a server.
 *     Remember: Writing for the INI file should be allowed)
 *     e.g. "U:\Programs\AHKs\<Prog>.INI" where U: could be the mapped drive to a server.
 *
 *  How to change the location of the INI file:
 *  If you want to change from e.g. 1. (per user) to 3. (universal) just copy the file
 *  into the new dir and delete the old one. (Copy not rename because the file inherits
 *  the NTFS access rights from the dir it is copied to.)
 *
 *  When two files e.g. in 1. and 2. exist testing for existens is started at location 1,
 *  then tests 2. and then 3. Testing stopps when the first file is detected.
 *  It is possible that some computers (all using the same AHK in a mapped drive)
 *  use the per user setting while others use the per computer setting (2.)
 *  or the universal (3.).
 *
 *  Please remember:
 *  ----------------
 *  Universal setting (3.) on a mapped drive means that several computers work
 *  on the same INI file.
 *  This also means (write rights provided) that any changes done by one computer
 *  in the INI file are re-read by all other computers !!
 *
 ******************************************************************************
 *
 *  With any changes of an INI value IniFile_Write_All should be set to 1
 *  this method should be called periodically (e.g. every 5 seconds)
 *  so not to overload the system with writing to the INI file
 *  (e.g. when the window is moved on the screen and the new coordinates
 *  should save these).
 *
 *  When the main program detects a change in these values it should set:
 *
 *    IniFile_Write_All := 1
 *
 * ----------------------------------------------------------------------------
 *  Wenn das Hauptprogramm Änderungen an den INI-Werten erkennt, sollte es
 *
 *    IniFile_Write_All := 1
 *
 *  setzen. Die Schreibroutine sollten nicht zu häufig gerufen werden
 *  (z.B. alle 5 sek oder langfristiger), um den Schreibaufwand auf die
 *  Platte nicht zu hoch werden zu lassen (z.B. wenn ein Fenster auf dem
 *  Bildschirm bewegt wird).
 *
 ******************************************************************************
 *
 *  this function call is the only command that is executed
 *  in the auto-execute section !
 *  The following function definitions are skipped.
 * ----------------------------------------------------------------------------
 *  dieses ist das einzige Kommando, das im Kopfbereich des AHK-Files
 *  ausgeführt wird. Die nachfolgenden Funktionsdefinitionen werden übersprungen.
 */

 ; CALL 
 
 mIniFile_Init( IniFile_TimeInterval )

/*
 ******************************************************************************
 */
mIniFile_Init( IniFile_TimeInterval )
{
	Global
	
	; ...\WinSize2_INIPath.INI has to be in the working directory of WinSize2
	; if exist: Line1: the path where the INI files are stored (write access is needed)
	; it may be missing
	;
	; Example WinSize2_INIPath_Template.INI:
	;------------------------------------------------------
	;   E:\Data\Magrasoft\INI_Files
	;   Line2: reserved
	;   Line3: reserved
	;   Line4: reserved
	;   Line5: reserved
	;   Line6: reserved
	;   Line7: reserved
	;   Line8: reserved
	;   Line9: reserved
	;   ^^^^^^^^^^^^^^
	;   Line1: has to contain the pathname to the directory
	;   where the INI files of WinSize2 are found.
	;   (This is called the "Magrasoft" directory in the Handbook.)
	;------------------------------------------------------

	IniFile_INIPath_INI = %vProgram_NNam%_INIPath.INI
	IfExist %IniFile_INIPath_INI%
	{
		FileReadLine, IniFile_Path_RootINI, %IniFile_Path_RootINI%\%IniFile_INIPath_INI% , 1
		LogText := "Directory for INI files (WS2_INIPath.INI) found: '" IniFile_Path_RootINI "'"
		mLogFile_Write( 2, LogText )
	}
		
	; msgbox IniFile_Path_RootINI  %IniFile_Save_File_found%  "%IniFile_Path_RootINI%"

	; --- create INI filenames "WinSize2_Root.INI"
	vWinSize2_Root_INI = %vProgram_NNam%_Root.INI

	; msgbox mIniFile_Init 01 ( %IniFile_TimeInterval% )
	If ( IniFile_TimeInterval <> "" )
		IniFile_Write_TimeInterval := IniFile_TimeInterval
	Else
		If ( ! IniFile_Write_TimeInterval )   ; if not defined before
			IniFile_Write_TimeInterval := 10000  ; default: 10 sec

	vTooltip := False
	IniFile_Write_All := 0
	IniFile_Dir_SaveINI = MagraSoft

; Local vProgram_NNam, Laenge
; #IncludeAgain inc_vProgramName.AHK

	; find "ApplicationData" (only defined for "This User" not for "All Users")
	IniFile_Path = %APPDATA%
	StringSplit, IniFile_Array_, IniFile_Path , \, ,
	IniFile_Nr := IniFile_Array_0   ; Nr of the last element
	IniFile_ApplicationData := IniFile_Array_%IniFile_Nr%   ; contains only "ApplicationData"
	; construct ...\All Users\ApplicationData
	IniFile_ApplicationData_AllUsers = %ALLUSERSPROFILE%\%IniFile_ApplicationData%
	IniFile_ApplicationData_ThisUser = %APPDATA%

	IniFile_Path_SaveINI_ThisUser = %IniFile_ApplicationData_ThisUser%\%IniFile_Dir_SaveINI%
	IniFile_Path_SaveINI_AllUsers = %IniFile_ApplicationData_AllUsers%\%IniFile_Dir_SaveINI%

	; msgbox mIniFile_Init 03 %IniFile_Path_SaveINI_ThisUser%`n`n04 %IniFile_Path_SaveINI_AllUsers%`nIniFile_Path = "%APPDATA%"
	
	; --- now find the place where the "WinSize2_Root.INI" is located
	IniFile_Save_File_in_Dir := 0


	mWS2_Exist_Where( vWinSize2_Root_INI )
	If ( IniFile_Save_File_found = 0 )
		MsgBox INI file not found`n`nI created in new one in:`n`n%IniFile_Path_RootINI%\%vWinSize2_Root_INI% 

	; --- all dirs are fixed; now create file names
	IniFile_PathFile_RootINI = %IniFile_Path_RootINI%\%vWinSize2_Root_INI%
	IniFile_Path := IniFile_Path_RootINI

	mIniRead_Root()
	mIniMake_SaveINI()
	
	LogFile_PathFile = %IniFile_Path%\%vProgram_NNam%.LOG

	vWinSize2_INI =%vProgram_NNam%.INI     ; "WinSize2.INI"
	If ( INI_with_ScreenSize = 1 )
	{
		; KK 2010-07-21
		; if exist: rename the old version to to the new version
		vWinSize2_INI_OLD = %vProgram_NNam%_%Screen_Width%.INI          ; e.g. "WinSize2_1280.INI"
		vWinSize2_INI     = %vProgram_NNam%_%Screen_Width_Height%.INI   ; e.g. "WinSize2_1280x1024.INI"
		If ( FileExist( "%vWinSize2_INI_OLD%" ) <> "" )
		{
			Msgbox  Rename %vWinSize2_INI_OLD%  to  %vWinSize2_INI%
			FileMove, %vWinSize2_INI_OLD%, %vWinSize2_INI% , 1    ; 1=overwrite
		}
	}

	IniFile_PathFile_SaveINI = %IniFile_Path%\%vWinSize2_INI%

	; msgbox mIniFile_Init / %INI_with_ScreenSize% / %vWinSize2_INI% / %vProgram_NNam%_%Screen_Width%.INI `n`nIniFile_PathFile_SaveINI in Dir: %IniFile_Save_File_in_Dir% / %IniFile_PathFile_SaveINI% / 
	
	StringSplit, IniFile_Array_, IniFile_PathFile_SaveINI , \, ,
	IniFile_Drive = %IniFile_Array_1%
	;Tooltip IniFile_Drive:`n`n%IniFile_Drive%`n`n%IniFile_PathFile_SaveINI%
	;Sleep 5000

	StringRight IniFile_PathFile_SaveINI_aaRIGHT, IniFile_PathFile_SaveINI, 60  ; for Debug purposes
	StringRight IniFile_PathFile_RootINI_aaRIGHT, IniFile_PathFile_RootINI, 60  ; for Debug purposes
	;Tooltip %IniFile_ScriptRight%
	FileCreateDir, %IniFile_Path%

	/*
	* use external INI file for compiled scripts or for network installations:
	* (If commented out: use external INI file.)
	* /
	IfInString, vProgram_NNamExt, .ahk
		; IniFile_PathFile_SaveINI = %A_ScriptFullPath%
	Else
		IniFile_PathFile_SaveINI = %A_ScriptDir%\%vWinSize2_INI%
	/*
	...
	*/
	mIniRead_All()
	FileGetTime, IniFile_FileTime , %IniFile_PathFile_SaveINI%, M   ; Modified-Last
	IniFile_FileTime_Old = %IniFile_FileTime%

	SetTimer lbIniFile_Write_Timer, %IniFile_Write_TimeInterval%
Return 0

lbIniFile_Write_Timer:
	
	mIniWrite_All()

	; --- command from _parameter( )
	If ( WinSize2_Exit_Now = 1 )
	{
		TTL := 001
		TTLMsg := "`n`n      " Message_Get(1013) "      `n`n"
		Tooltip_%TTL% := TTLMsg
		CoordMode, ToolTip, Screen
		Tooltip %TTLMsg%  ,TTX , TTL*TTM, TTL+TTP
		CoordMode, ToolTip, Relative
		Sleep 3000
		ExitApp
	}
	
	Return

}   ; END of method mIniFile_Init
/*
 *************************************************************************
 *  mWS2_Exist_Where( Filename )
 */
mWS2_Exist_Where( Filename )
{
	Global
	
	; --- 1. in the current dir "WorkingDir"
	IfExist %Filename%
	{
		IniFile_Save_File_found    := 1
		IniFile_Save_File_in_Dir   := 3
		IniFile_Path_RootINI       := A_WorkingDir
	}

	; --- 2. in dir "...\All Users\..."
	Else IfExist %IniFile_Path_SaveINI_AllUsers%\%Filename%    
	{
		IniFile_Save_File_found    := 1
		IniFile_Save_File_in_Dir   := 2
		IniFile_Path_RootINI       := IniFile_Path_SaveINI_AllUsers
	}

	; --- 3. in dir "...\<This-User>\..."
	Else IfExist %IniFile_Path_SaveINI_ThisUser%\%Filename%   
	{
		IniFile_Save_File_found    := 1
		IniFile_Save_File_in_Dir   := 1
		IniFile_Path_RootINI       := IniFile_Path_SaveINI_ThisUser
	}

	; --- if not found in any location; take "This User"
	Else
	{
		IniFile_Save_File_found    := 0
		IniFile_Save_File_in_Dir   := 1
		IniFile_Path_RootINI       := IniFile_Path_SaveINI_ThisUser
		IniFile_Write_All          := 1
	}
}
/*
 *************************************************************************
 */
mIniMake_SaveINI()
{

	Global
	
	vWinSize2_INI =%vProgram_NNam%.INI     ; "WinSize2.INI"
	If ( INI_with_ScreenSize = 1 )
		vWinSize2_INI =%vProgram_NNam%_%Screen_Width_Height%.INI     ; e.g. "WinSize2_1280.INI" depending on screen width

	IniFile_PathFile_SaveINI = %IniFile_Path%\%vWinSize2_INI%
	IniFile_PathFile_FullScreen = %IniFile_Path%\WinSize2_FullScreen.INI

	; Desktop Icon
	IniFile_File_DesktopIcon_0 = WinSize2_Icon_
	IniFile_File_DesktopIcon = %IniFile_File_DesktopIcon_0%%Screen_Width_Height%
	IniFile_File_DesktopIcon_DTR = %IniFile_File_DesktopIcon%.dtr
	IniFile_File_DesktopIcon_NEW = %IniFile_File_DesktopIcon%.new
	IniFile_PathFile_DesktopIcon_DTR = %IniFile_Path%\%IniFile_File_DesktopIcon_DTR%
	IniFile_PathFile_DesktopIcon_NEW = %IniFile_Path%\%IniFile_File_DesktopIcon_NEW%

	; Network
	IniFile_File_Network_0 = WinSize2_Network_
	IniFile_File_Network = %IniFile_File_Network_0%%Screen_Width_Height%
	IniFile_PathFile_Network = %IniFile_Path%\%IniFile_File_Network%.NSH
	
	; msgbox mIniMake_SaveINI %IniFile_PathFile_FullScreen%
	mFullScreen_Init()

}   ; END of method mIniMake_SaveINI
/*
 *************************************************************************
 */

mIniWrite_All()
{
	Global

	;  file was altered from outside the program: maybe edited
	;  and saved by the user to change one of the values by
	;  an editor: then read instead of write (changes in this
	;  program are lost in this case)
	;  --- M=Modified A=Access-Last C=Creation
	FileGetTime, IniFile_FileTime , %IniFile_PathFile_SaveINI%, M
	; Tooltip mIniWrite_All:`n%IniFile_PathFile_SaveINI%`n%IniFile_FileTime_Old% : %IniFile_FileTime%
	If ( IniFile_FileTime_Old <> IniFile_FileTime )
	{
		mIniRead_All()
		IniFile_FileTime_Old = %IniFile_FileTime%

		;*** (1016)  INI file was read - has been overwritten by the user
		; Message := Message_Get( 1016 ) " / " IniFile_FileTime_Old " / " IniFile_FileTime
		Message := Message_Get( 1016 )
		/*
		If ( Tooltip_Next() )
			Tooltip %Message% ,vCtrl_Alt_Y_MouseX,vCtrl_Alt_Y_MouseY,20
		*/
		mLogFile_Write( 1, Message )
	}
	Else
	{
 		; Tooltip  mIniWrite_All: INI-File will be written
		; Sleep %vTooltipPubSleep%
		mIniWrite_All_User()
		/*********************************************************************************
		 * only if INI values are saved in AHK file !!
		 * and "#Include inc_AutoReLoad.AHK" is used.
		 * Writing of INI values should not be seen as modification
		 * modify only if values are saved !
		 * if INI files has been written: update time marker
		 */
		; If ( IniFile_PathFile_SaveINI = A_ScriptFullPath OR IniFile_Write_All )
		If ( IniFile_Write_All )
		{
			FileGetTime, IniFile_FileTime , %IniFile_PathFile_SaveINI%, M  ; Modified last
			IniFile_FileTime_Old := IniFile_FileTime
		}
		/*********************************************************************************
		 */
		IniFile_Write_All := 0
		; Tooltip  mIniWrite_All: INI file has been written
		; Sleep 5000

	}

	Return 0
}   ; END of method mIniWrite_All

/*
 *************************************************************************
 */
mIniRead_All()
{
	Global
	Loop , %AWNr_CntEntries%
	{
		AWNr_%A_Index% =
		AWNr__GID_%A_Index% := 0
		; Tooltip AWNr__GID_%A_Index% := 0
	}
	mIniRead_All_User()
	If ( vTooltip )
		Tooltip  mIniRead_All: INI file has been read
	mFullScreen_Read()

	Return
}   ; END of method mIniRead_All

/*************************************************************************
 *   END of inc_IniReadWrite.AHK
 *************************************************************************
 */

/*
 *************************************************************************
 *  initialize the FullScreen matrix
 *  initialize the Exclude-List matrix
 */
mFullScreen_Init()
{
	Global

	AW_FullScreen_IO_1 := IniFile_PathFile_FullScreen
	AW_FullScreen_IO_2 :=     ; # rows: if not exist: = 0  if exist: keep old value
	AW_FullScreen_IO_3 := 2   ; # cols
	Matrix_Operate( "INIT", "AW_FullScreen_IO", "AW_FullScreen" )

	Exclude_IO_1 :=     ; filename
	Exclude_IO_2 :=     ; # rows: if not exist: = 0  if exist: keep old value
	Exclude_IO_3 := 4   ; # cols   1:Name/2:ID/3:Protect/4:MatchMode=2:contains 3:exact
	Matrix_Operate( "INIT", "Exclude_IO", "Exclude" )
	
	/*
	If ( IniFile_PathFile_FullScreen <> "" )
		FileGetTime, IniFile_PathFile_FullScreen_Time , %IniFile_PathFile_FullScreen%, M
	Else
		IniFile_PathFile_FullScreen_Time = 1
	IniFile_PathFile_FullScreen_Time_Old := IniFile_PathFile_FullScreen_Time
	*/
	
}   ; END of method mFullScreen_Init

/*
 *************************************************************************
 *  read the FullScreen matrix
 */
mFullScreen_Read()
{
	Global

	; msgbox mFullScreen_Read

	AW_FullScreen_IO_1 := IniFile_PathFile_FullScreen
	Matrix_Operate( "RD", "AW_FullScreen_IO", "AW_FullScreen" )

	; msgbox END of method mFullScreen_Read

}   ; END of method mFullScreen_Read

/*
 *************************************************************************
 *  write the FullScreen matrix
 */
mFullScreen_Write()
{
	Global


	FileGetTime, IniFile_PathFile_FullScreen_Time , %IniFile_PathFile_FullScreen%, M
	; Tooltip mIniWrite_All:`n%IniFile_PathFile_SaveINI%`n%IniFile_FileTime_Old% : %IniFile_FileTime%
	If ( IniFile_PathFile_FullScreen_Time_Old <> IniFile_PathFile_FullScreen_Time )
	{
	
		AW_FullScreen_IO_1 := IniFile_PathFile_FullScreen
		Matrix_Operate( "RD", "AW_FullScreen_IO", "AW_FullScreen" )
		IniFile_PathFile_FullScreen_Time_Old := IniFile_PathFile_FullScreen_Time
	}
	Else
	{
		; msgbox mFullScreen_Write

		AW_FullScreen_IO_1 := IniFile_PathFile_FullScreen
		Matrix_Operate( "WR", "AW_FullScreen_IO", "AW_FullScreen" )
		FileGetTime, IniFile_PathFile_FullScreen_Time_Old , %IniFile_PathFile_FullScreen%, M

		; msgbox END of method mFullScreen_Write
	}


	}   ; END of method mFullScreen_Write

/*
 *************************************************************************
 *  replace one line in the FullScreen matrix
 */
mFullScreen_Replace( Title_Old, Title_New, FullScreen_Char )
{
	Global

	If ( Title_Old <> "" )
	{
		AW_FullScreen_IO_1 = %Title_Old%
	}
	Else
	{
		AW_FullScreen_IO_1 = %Title_New%
	}

	Row := Matrix_Operate( "DEL", "AW_FullScreen_IO", "AW_FullScreen" )
	FullScreen_Text = "DEL" Nr. %Row% Total-Rows: %AW_FullScreen__aRows%  Title %AW_FullScreen_IO_1%
	; ListVars
	; msgbox mFullScreen_Replace 01-DEL Row: %Row%  Total: %AW_FullScreen__aRows% / %Title_Old% / %Title_New%

	AW_FullScreen_IO_1 = %Title_New%
	AW_FullScreen_IO_2 = %FullScreen_Char%
	Row := Matrix_Operate( "INS", "AW_FullScreen_IO", "AW_FullScreen" )
	FullScreen_Text .= "`n" Row " 'INS'  Nr. " Row " Total-Rows: " AW_FullScreen__aRows "  Title " AW_FullScreen_IO_1 " " AW_FullScreen_IO_2
	; Tooltip %FullScreen_Text%
	; msgbox mFullScreen_Replace 02-INS Nr. %Row%  Total: %AW_FullScreen__aRows% / %Title_New% / %FullScreen_Char%

}   ; END of method mFullScreen_Replace

/*
 *************************************************************************
 *
 *  FullScreen_Char := mFullScreen_Find( Title )
 *
 */
mFullScreen_Find( Title )
{
	Global

	AW_FullScreen_IO_1 = %Title%
	Row := Matrix_Operate( "FND", "AW_FullScreen_IO", "AW_FullScreen" )

	; msgbox mFullScreen_Find: "%AW_FullScreen_IO_1%"`n`nChar: "%AW_FullScreen_IO_2%"`n`nReihe: %Row%

	Return %AW_FullScreen_IO_2%
	
}   ; END of method mFullScreen_Find

/*
 *************************************************************************
 */
mFullScreen_Display()
{
	Global

	Matrix_Operate( "DISP", "", "AW_FullScreen" )

}   ; END of method mFullScreen_Display

/*************************************************************************
 *  <<<<< NextUserChange (and last)
 *  Template for your code; you will have to change this
 *************************************************************************
 *
 *  #Include inc_IniReadWrite_User.AHK
 *
 *  Date:   2005-05-06 14:27
 *  Author: Kalle Koseck
 *  Typ:    Method
 *************************************************************************
 *
 *  this has to be a function declaration for use in #Include statement: 
 */
mIniWrite_All_User()
{
	Global  ; don't forget: necessary to access global variables
	;
	; detect changes here (If ( Var <> Var_Old) ... IniFile_Write_All := True)
	; or in your main program.
	;
	; !!   P L E A S E :
	; !!   DO NOT reset "IniFile_Write_All" before leaving this method.
	; !!   The calling method needs this variable and will reset it.
	;
	If ( ! IniFile_Write_All )
		Return

	mFullScreen_Write()
	
	; change the following lines to the variables you want to save !!!

	; ------------------------------------------------------------------------
	; [Settings]
	
	; Tooltip  INI-Write: %A_YYYY%-%A_MM%-%A_DD% %A_Hour%.%A_Min%.%A_Sec%  %IniFile_PathFile_SaveINI%
	
	; IniDelete, %IniFile_PathFile_SaveINI%, Settings   ; also deletes possible comments !!

	IniWrite, %A_YYYY%-%A_MM%-%A_DD% %A_Hour%.%A_Min%.%A_Sec% , %IniFile_PathFile_SaveINI%, Settings, Date  ; only for documentation
	IniWrite, %vVersion%             , %IniFile_PathFile_SaveINI%, Settings, Version
	IniWrite, %vLanguage_Reg_Hex%    , %IniFile_PathFile_SaveINI%, Settings, LangIDHex   ; for documentation only (not read)
	IniWrite, %vLanguage_Reg_Intg%    , %IniFile_PathFile_SaveINI%, Settings, LangIDDec   ; for documentation only (not read)
	; If ( CurrText <> "" )
	;	IniWrite, %CurrText%      , %IniFile_PathFile_SaveINI%, Settings, CurrText

	; X and Y: blank if hidden
	If ( GuiWindowX <> "" )
	IniWrite, %GuiWindowX%           , %IniFile_PathFile_SaveINI%, Settings, GuiWindowX

	If ( GuiWindowY <> "" )
	IniWrite, %GuiWindowY%           , %IniFile_PathFile_SaveINI%, Settings, GuiWindowY

	IniWrite, %GuiWindowWidth%       , %IniFile_PathFile_SaveINI%, Settings, GuiWindowWidth
	IniWrite, %GuiWindowHeight%      , %IniFile_PathFile_SaveINI%, Settings, GuiWindowHeight
	IniWrite, %vCtrl_Alt_Y_Hotkey%   , %IniFile_PathFile_SaveINI%, Settings, Hotkey

	IniWrite, %vMessage_Help%        , %IniFile_PathFile_SaveINI%, Settings, Message_Help
	IniWrite, %vLanguage_INI%        , %IniFile_PathFile_SaveINI%, Settings, Language
	IniWrite, %vTitleTimer%          , %IniFile_PathFile_SaveINI%, Settings, TitleTimer
	IniWrite, %vTooltip_Time_Show%   , %IniFile_PathFile_SaveINI%, Settings, Tooltip_Time_Show
	IniWrite, %vCtrl_Alt_Y_Time%     , %IniFile_PathFile_SaveINI%, Settings, Command_Time_Wait
	IniWrite, %vIniScreen_Time_Show% , %IniFile_PathFile_SaveINI%, Settings, IniScreen_Time_Show
	IniWrite, %vMenuTrayIcon_Show%   , %IniFile_PathFile_SaveINI%, Settings, MenuTrayIcon_Show
	IniWrite, %Update_UpdPath%       , %IniFile_PathFile_SaveINI%, Settings, Update_Path
	IniWrite, %StartWinChecked%      , %IniFile_PathFile_SaveINI%, Settings, StartWithLogon
	IniWrite, %Char_Delay_msec%      , %IniFile_PathFile_SaveINI%, Settings, Char_Delay_msec
	If ( Tooltip_Show_Tip = 0 )    ; if = 1 do not over-write
	IniWrite, %Tooltip_Show_Tip%     , %IniFile_PathFile_SaveINI%, Settings, Tooltip_Show_Tip

	
	IniWrite, %Titles_Sort_Basis%           , %IniFile_PathFile_SaveINI%, Settings, Titles_Sort_Basis
	IniWrite, %Titles_Sort_ZA%              , %IniFile_PathFile_SaveINI%, Settings, Titles_Sort_ZA
	IniWrite, %Titles_Sort_wComm%           , %IniFile_PathFile_SaveINI%, Settings, Titles_Sort_with_Comment
	IniWrite, %LogFile_Level%               , %IniFile_PathFile_SaveINI%, Settings, LogFile_Level
	IniWrite, %TabNumber_Open_Last_Tab%     , %IniFile_PathFile_SaveINI%, Settings, TabNumber_Open_Last_Tab
	IniWrite, %TabNumber_ActTab%            , %IniFile_PathFile_SaveINI%, Settings, TabNumber_ActTab
	IniWrite, %Group_Choose_Nr%             , %IniFile_PathFile_SaveINI%, Settings, Group_Choose_Nr
	IniWrite, %Screen_dpi_Font_Factor%      , %IniFile_PathFile_SaveINI%, Settings, Font_Factor
	IniWrite, %DesktopIcon_CheckAfterLogin% , %IniFile_PathFile_SaveINI%, Settings, DesktopIcon_CheckAfterLogin
	IniWrite, %DesktopIcon_AutoRestore%     , %IniFile_PathFile_SaveINI%, Settings, DesktopIcon_AutoRestore
	IniWrite, %DesktopIcon_CheckResolution% , %IniFile_PathFile_SaveINI%, Settings, DesktopIcon_CheckResolution
	IniWrite, %DesktopIcon_StoreInFile%     , %IniFile_PathFile_SaveINI%, Settings, DesktopIcon_StoreInFile
	IniWrite, %Network_WithIconSave%        , %IniFile_PathFile_SaveINI%, Settings, Network_WithIconSave
	IniWrite, %Network_WithIconRestore%     , %IniFile_PathFile_SaveINI%, Settings, Network_WithIconRestore
	IniWrite, %Delay_Show_Tooltip%          , %IniFile_PathFile_SaveINI%, Settings, Delay_Show_Tooltip


	; ------------------------------------------------------------------------
	; ROOT.INI  [Settings]
	IniWrite, %INI_with_ScreenSize%  , %IniFile_PathFile_RootINI%, Settings, INIWithScreenSize
	IniWrite, %IniFile_Path%         , %IniFile_PathFile_RootINI%, Settings, INIFile_Path
	IniWrite, %Process_ID%           , %IniFile_PathFile_RootINI%, Settings, Process_ID
	IniWrite, %LogFile_Size_kB%      , %IniFile_PathFile_RootINI%, Settings, LogFile_Size_kB
	mIniMake_SaveINI()
	
	; copy INI file to LOG
	If ( LogFile_Level >= 4 )
	{
		LogText := "`n`n========== INIWRITE Start ==========`nRoot: " IniFile_PathFile_RootINI "`nINI:  " IniFile_PathFile_SaveINI
		mLogFile_Write( 4, Logtext )
		FileRead    File_INI_total  , %IniFile_PathFile_SaveINI%
		FileAppend `n%File_INI_total%`n , %LogFile_PathFile%
		; msgbox FileCopy `n  %IniFile_PathFile_SaveINI%  `n  %LogFile_PathFile%  `n  "%errorlevel%"
	}

	; ------------------------------------------------------------------------
	; [WinSize]

	; delete section to remove extended ctrl's at the end
	; IniDelete, %IniFile_PathFile_SaveINI%, WinSize
	; msgbox IniDelete %IniFile_PathFile_SaveINI% WinSize

	Z_Deleted := Message_Get(1031)   ; << deleted >>
	INI_Element_Str :=
	Loop , %AWNr_CntEntries%
	{
		AWNr_Name     = AWNr_%A_Index%
		AWNr_Element := AWNr_%A_Index%

		StringSplit, Z_Deleted_, AWNr_Element , %CUT%, ,
		If ( Z_Deleted_1 = Z_Deleted )
		{
			AWNr_Element := 
		}
		If ( AWNr_Element = "" )
			INI_Element_Write := 
		Else
			INI_Element_Write := AWNr_Element CUT "Z"

		; --- IniWrite, Value, Filename, Section, Key
		IniWrite, %INI_Element_Write%, %IniFile_PathFile_SaveINI%, WinSize, %AWNr_Name%
		INI_Element_Str .= "`n" AWNr_Element
 		; Tooltip IniWrite: %AWNr_Name%: %AWNr_Element%
		; Sleep 2000
	}

	; msgbox INI_Element_Str WRITE %INI_Element_Str%
	
	; --- Delete all entries that were written last time
	;     but that do not exist now any longer
	If ( AWNr_CntEntries_Max = "" )
		AWNr_CntEntries_Max = %AWNr_CntEntries%
	AWNr_ActCnt = %AWNr_CntEntries%
	Loop
	{
		If ( AWNr_ActCnt >= AWNr_CntEntries_Max + 3 )
			Break
		AWNr_ActCnt += 1
		AWNr_Name	  = AWNr_%AWNr_ActCnt%
		Rem --- IniDelete, Filename, Section [, Key]
		IniDelete, %IniFile_PathFile_SaveINI%, WinSize, %AWNr_Name%

		;*** (1017)  Deleted INI-Element: %AWNr_Name%
		; Message := Message_Get( 1017 )
		; Tooltip %Message% %AIndex%: %AWNr_Array_1%
		; Sleep %vTooltipPubSleep%
	}
	AWNr_CntEntries_Max := AWNr_CntEntries
	If ( vTooltip )
		Tooltip mIniWrite_All_User: has been written

Return
}
;
;***************************************************************************
;
mIniRead_Root()
{
	Global

	; ------------------------------------------------------------------------
	; ROOT.INI  [Settings]

	; IniRead, OutputVar           , Filename                  , Section , Key [, Default]
	IniRead, INI_with_ScreenSize   , %IniFile_PathFile_RootINI%, Settings, INIWithScreenSize
	IniRead, IniFile_Path_tmp      , %IniFile_PathFile_RootINI%, Settings, INIFile_Path
	IniRead, Process_ID            , %IniFile_PathFile_RootINI%, Settings, Process_ID
	IniRead, LogFile_Size_kB       , %IniFile_PathFile_RootINI%, Settings, LogFile_Size_kB

	INI_with_ScreenSize     := NumberCheck( INI_with_ScreenSize      , 0 )
	LogFile_Size_kB         := NumberCheck( LogFile_Size_kB          , 100 )   ; kB if not defined
	If ( IniFile_Path_tmp <> "ERROR" )
	{
		IniFile_Path := IniFile_Path_tmp
		IniFile_Write_All = 1
	}

	mIniMake_SaveINI()

	Return
}
;
;***************************************************************************
;
mIniRead_All_User()
{
	Global
	
	mIniRead_Root()

	; ------------------------------------------------------------------------
	; [Settings]

	; IniRead, UsedList, %IniFile_PathFile_SaveINI%, Settings, UsedList
/*
	; IniRead, vPath_StarsData1, %IniFile_PathFile_SaveINI%, Settings, Path_StarsData
	If ( vPath_StarsData1 <> "" )
		If vPath_StarsData1 = ERROR
			vPath_StarsData1 = D:\StarsData\Root\UserData\
		vPath_StarsData = %vPath_StarsData1%
	IfEqual, UsedList, ERROR
		UsedList =
*/
	;msgbox IniRead IniFile_PathFile_SaveINI: %IniFile_PathFile_SaveINI%

	; IniRead, CurrText              , %IniFile_PathFile_SaveINI%, Settings, CurrText
	If ( GuiWindowX = "" )   ; do not overwrite the internal settings
	{
	;        variable-name           filename                    section   key-name
	IniRead, INIVersion            , %IniFile_PathFile_SaveINI%, Settings, Version
	IniRead, GuiWindowX            , %IniFile_PathFile_SaveINI%, Settings, GuiWindowX
	IniRead, GuiWindowY            , %IniFile_PathFile_SaveINI%, Settings, GuiWindowY
	IniRead, GuiWindowWidth        , %IniFile_PathFile_SaveINI%, Settings, GuiWindowWidth
	IniRead, GuiWindowHeight       , %IniFile_PathFile_SaveINI%, Settings, GuiWindowHeight
	}
	IniRead, vTitleTimer           , %IniFile_PathFile_SaveINI%, Settings, TitleTimer
	IniRead, vTooltip_Time_Show    , %IniFile_PathFile_SaveINI%, Settings, Tooltip_Time_Show
	IniRead, vCtrl_Alt_Y_Time      , %IniFile_PathFile_SaveINI%, Settings, Command_Time_Wait
	IniRead, vIniScreen_Time_Show  , %IniFile_PathFile_SaveINI%, Settings, IniScreen_Time_Show
	IniRead, vMenuTrayIcon_Show    , %IniFile_PathFile_SaveINI%, Settings, MenuTrayIcon_Show
	IniRead, Update_UpdPath        , %IniFile_PathFile_SaveINI%, Settings, Update_Path
	IniRead, StartWinChecked       , %IniFile_PathFile_SaveINI%, Settings, StartWithLogon
	IniRead, Char_Delay_msec       , %IniFile_PathFile_SaveINI%, Settings, Char_Delay_msec
	If ( Tooltip_Show_Tip = 0 )    ; if = 1 do not over-write
	IniRead, Tooltip_Show_Tip      , %IniFile_PathFile_SaveINI%, Settings, Tooltip_Show_Tip

	IniRead, Titles_Sort_Basis           , %IniFile_PathFile_SaveINI%, Settings, Titles_Sort_Basis
	IniRead, Titles_Sort_ZA              , %IniFile_PathFile_SaveINI%, Settings, Titles_Sort_ZA
	IniRead, Titles_Sort_wComm           , %IniFile_PathFile_SaveINI%, Settings, Titles_Sort_with_Comment
	IniRead, LogFile_Level               , %IniFile_PathFile_SaveINI%, Settings, LogFile_Level
	If ( TabNumber_Open_Last_Tab = 0 )
	{
		IniRead, TabNumber_Open_Last_Tab , %IniFile_PathFile_SaveINI%, Settings, TabNumber_Open_Last_Tab
		IniRead, TabNumber_ActTab        , %IniFile_PathFile_SaveINI%, Settings, TabNumber_ActTab
	}
	IniRead, Group_Choose_Nr             , %IniFile_PathFile_SaveINI%, Settings, Group_Choose_Nr
	IniRead, Screen_dpi_Font_Factor      , %IniFile_PathFile_SaveINI%, Settings, Font_Factor
	IniRead, DesktopIcon_CheckAfterLogin , %IniFile_PathFile_SaveINI%, Settings, DesktopIcon_CheckAfterLogin
	IniRead, DesktopIcon_AutoRestore     , %IniFile_PathFile_SaveINI%, Settings, DesktopIcon_AutoRestore
	IniRead, DesktopIcon_CheckResolution , %IniFile_PathFile_SaveINI%, Settings, DesktopIcon_CheckResolution
	IniRead, DesktopIcon_StoreInFile     , %IniFile_PathFile_SaveINI%, Settings, DesktopIcon_StoreInFile
	IniRead, Network_WithIconSave        , %IniFile_PathFile_SaveINI%, Settings, Network_WithIconSave
	IniRead, Network_WithIconRestore     , %IniFile_PathFile_SaveINI%, Settings, Network_WithIconRestore
	IniRead, Delay_Show_Tooltip          , %IniFile_PathFile_SaveINI%, Settings, Delay_Show_Tooltip

	StringSplit , INIVersion_ , INIVersion , .     ; INIVersion_1: Main-Vers   _2: Version   _3: Sub-Version
	INIVersion_Nr := SubStr(INIVersion_1, 2 ) * 10000 + INIVersion_2 * 100 + INIVersion_3
	; msgbox %INIVersion%   "%INIVersion_1%" "%INIVersion_2%" "%INIVersion_3%"   %INIVersion_Nr%
	
	vTitleTimer          := NumberCheck( vTitleTimer           , 200 )
	vTooltip_Time_Show   := NumberCheck( vTooltip_Time_Show    , 3000 )
	vCtrl_Alt_Y_Time     := NumberCheck( vCtrl_Alt_Y_Time      , 2000 )
	vIniScreen_Time_Show := NumberCheck( vIniScreen_Time_Show  , 4000 )
	Tooltip_Show_Tip     := NumberCheck( Tooltip_Show_Tip      , 0 )
	If ( Tooltip_Show_Tip )
		Tooltip_Show_Store  := 1
	vMenuTrayIcon_Show   := NumberCheck( vMenuTrayIcon_Show    , 1 )
	If ( Update_UpdPath = "ERROR" )
		Update_UpdPath =--
	GuiWindowX           := NumberCheck( GuiWindowX            , 1 )
	GuiWindowY           := NumberCheck( GuiWindowY            , 1 )
	GuiWindowWidth       := NumberCheck( GuiWindowWidth        , 500 )
	GuiWindowHeight      := NumberCheck( GuiWindowHeight       , 500 )
	
	; Check position of  Spec. Parameters window: if outside screen move to upper right
	If ( GuiWindowX > Screen_Width
		OR GuiWindowX + GuiWindowWidth < 0
		OR GuiWindowY < 0
		OR GuiWindowY > GuiWindowHeight )
	{
		LogText = Spec. Parameters window outside screen: "%GuiWindowX%" "%GuiWindowY%" "%GuiWindowWidth%" "%GuiWindowHeight%"
		mLogFile_Write( 1, LogText )
		; MsgBox, 262192, WinSize2 not visible, Spec. Parameters window outside screen`n`nCorrected., 30
		GuiWindowX := Screen_Width - 100
		GuiWindowY := 50
	}
	; MsgBox Spec. Parameters X Y Width Height: "%GuiWindowX%" "%GuiWindowY%" "%GuiWindowWidth%" "%GuiWindowHeight%"
	Char_Delay_msec              := NumberCheck( Char_Delay_msec       , 50 )

	Titles_Sort_Basis            := NumberCheck( Titles_Sort_Basis       , 0 )
	Titles_Sort_ZA               := NumberCheck( Titles_Sort_ZA          , 0 )
	Titles_Sort_wComm            := NumberCheck( Titles_Sort_wComm       , 0 )
	LogFile_Level                := NumberCheck( LogFile_Level           , 3 )

	Group_Choose_Nr              := NumberCheck( Group_Choose_Nr         , 1 )
	Screen_dpi_Font_Factor       := NumberCheck( Screen_dpi_Font_Factor  , 1 )
	DesktopIcon_CheckAfterLogin  := ChkLogical( DesktopIcon_CheckAfterLogin )
	DesktopIcon_CheckAfterLogin_Once := DesktopIcon_CheckAfterLogin
	
	; msgbox mIniRead_All_User DesktopIcon_CheckAfterLogin "%DesktopIcon_CheckAfterLogin%"
	
	DesktopIcon_AutoRestore     := NumberCheck( DesktopIcon_AutoRestore , 0 )
	DesktopIcon_AutoRestore     := ChkLogical(  DesktopIcon_AutoRestore )
	DesktopIcon_CheckResolution := ChkLogical(  DesktopIcon_CheckResolution )
	DesktopIcon_StoreInFile     := ChkLogical(  DesktopIcon_StoreInFile )
	DesktopIcon_StoreInFile     := 1
	
	Network_WithIconSave        := NumberCheck( Network_WithIconSave    , 0 )
	Network_WithIconSave        := ChkLogical(  Network_WithIconSave    )
	Network_WithIconRestore     := NumberCheck( Network_WithIconRestore , 0 )
	Network_WithIconRestore     := ChkLogical(  Network_WithIconRestore )
	Delay_Show_Tooltip          := ChkLogical(  Delay_Show_Tooltip )

	mMenuTrayIcon()

	GuiWindowXOld := GuiWindowX
	GuiWindowYOld := GuiWindowY
	GuiWindowWidthOld := GuiWindowWidth
	GuiWindowHeightOld := GuiWindowHeight

	vCtrl_Alt_Y_Hotkey_Old = %vCtrl_Alt_Y_Hotkey%
	IniRead, vCtrl_Alt_Y_Hotkey, %IniFile_PathFile_SaveINI%, Settings, Hotkey
	If ( vCtrl_Alt_Y_Hotkey = ""
		OR vCtrl_Alt_Y_Hotkey = "ERROR" )   ; Blank oder ERROR
	{
		; If ( LangIDDec = 7 )
		If ( vLanguage_ID = 7 )
			vCtrl_Alt_Y_Hotkey = ^!Y
		Else
			vCtrl_Alt_Y_Hotkey = ^!Z
	}
	; If ( vCtrl_Alt_Y_Hotkey_Old <> vCtrl_Alt_Y_Hotkey )   ; wenn was geaendert wurde
	{
		;msgbox mCtrl_Alt_Y_Init( vCtrl_Alt_Y_Hotkey, vCtrl_Alt_Y_Time )
		mCtrl_Alt_Y_Init( vCtrl_Alt_Y_Hotkey, vCtrl_Alt_Y_Time )
	}

	; AW_Control = %vCtrl_Alt_Y_Hotkey%

	; --- show the message numbers: "(xxxx)"
	IniRead, vMessage_Help  , %IniFile_PathFile_SaveINI%, Settings, Message_Help
	If ( vMessage_Help    = "" OR vMessage_Help           = "ERROR" )
		vMessage_Help    := 0
	If ( vMessage_Help   >= 1 )
	{
		If ( vMessage_MsgBox = "" )
		{
			MsgBox, 52, INI File, Message_Help > 0:  Message_Help = %vMessage_Help%`n`n"No" = reset to 0 (default), 10
			vMessage_MsgBox = NO
		}
		IfMsgBox No
			vMessage_Help := 0
		Else
		{
			vMessage_Font := 6
			If ( vMessage_Help   >= 101 )
				vMessage_Font := Mod( vMessage_Help, 100 )
			If ( vMessage_Font < 4 )
				vMessage_Font = 4
		}
	}

	IniRead, vLanguage_INI     , %IniFile_PathFile_SaveINI%, Settings, Language
	If ( vLanguage_INI = "" OR vLanguage_INI = "ERROR" )
		vLanguage_INI := "?"
	StringUpper vLanguage_INI, vLanguage_INI
	; in inc_message
	; mLang_Select_All_Set()
	; has to be done only when language is changed
	; mLanguage_Set( vLanguage_Name_Long )

	Message_Get( 1000 , 1 )  ; INIT

	; msgbox vLanguage_NameLong 01  "%vLanguage_NameLong%"  "%vLanguage_INI%"

	mCtrl_Alt_Y_Hotkey_SetMessage()

	; ------------------------------------------------------------------------
	; [WinSize]

	Nr := 0
	AWNr_CntEntries := 0
	AWNr_CntLines := 0
	INI_Element_Str :=
	Loop
	{
		AWNr_Name		= AWNr_%A_Index%
		; INI_Element	:= AWNr_%A_Index%
		; --- read one complete line with all parameters for that window
		;     whatever is in there
		;-------------------------------------------------------------------------
		; AWNr_2=Viewer|89|34|1398|1076|3|0|0|0|0|1|TfrmMain||
		IniRead, INI_Element, %IniFile_PathFile_SaveINI%, WinSize, %AWNr_Name%

		If ( INIVersion_Nr <= 23000 )
		{
			StringReplace, INI_Element, INI_Element, %CUT30%, %CUT%, All
		}
		;-------------------------------------------------------------------------
		;msgbox [WinSize] %AWNr_Name% = %INI_Element%
		If ( INI_Element = "ERROR" )
		{
			If ( A_Index > AWNr_CntLines + 10 )
				Break
			Else
				Continue
		}
		
		INI_Write_Delete_WinSize = 0
		If ( INI_Element <> "" )
		{
			AWNr_CntLines += 1

			AWNr_Array_13 := 
			AWNr_Array_14 := 
			AWNr_Array_15 := 
			AWNr_Array_16 := 
			;--------------------------------------------------
			StringSplit, AWNr_Array_, INI_Element , %CUT%, ,
			;--------------------------------------------------

			;  INIWrite problem: if ctrl-char are at the end of a string the old
			;  char at the end are left and added to the new string:
			;  2 ctrl's at the end make 4 at the 2. update, 6 at the 3. and so on.
			;
			;  as long as this problem exists:
			;  create new string, then delete the section and write a new one
			;
			IniFile_Write_All = 1

			INI_ElementNew :=     AWNr_Array_1  CUT AWNr_Array_2  CUT AWNr_Array_3
			INI_ElementNew .= CUT AWNr_Array_4  CUT AWNr_Array_5  CUT AWNr_Array_6
			INI_ElementNew .= CUT AWNr_Array_7  CUT AWNr_Array_8  CUT AWNr_Array_9
			INI_ElementNew .= CUT AWNr_Array_10 CUT AWNr_Array_11 CUT AWNr_Array_12
			INI_ElementNew .= CUT AWNr_Array_13 CUT AWNr_Array_14 CUT AWNr_Array_15
			INI_ElementNew .= CUT AA1

			; msgbox INI_Element %A_Index% `n`n%INI_Element%   `n%INI_ElementNew%
			INI_Element := INI_ElementNew
			INI_Element_Str .= "`n" A_Index ": " INI_ElementNew
			
			; msgbox 01 %A_Index%  ::  %INI_ElementNew%  ::  %AWNr_Name%
			If ( AWNr_Array_1 = "" )
			{
				AWNr_%Nr% =
				IniFile_Write_All = 1
				; Tooltip IniRead SKIP: %Nr% / %AWNr_Name%: `n%INI_Element%  `n%AWNr_Array_1%
			}
			Else   ; ---------- store the line read in AWNr_... ----------
			{
				Nr += 1
				AWNr_Name = AWNr_%Nr%
				AWNr_%Nr% := INI_Element
				AWNr__GID_%Nr% := 0
				AWNr__AhkClass_%Nr% := 
				; Tooltip IniRead: %Nr% / %AWNr_Name%: `n%AWNr_Array_1% `n%INI_Element% 
			}
			/*
			If ( AWNr_Array_11 = 5 )   ; special Functions selected ...
			{
				If ( AWNr_Array_13 = "" )   ; but spec. char(s) is blank
				If ( AWNr_Array_13 = "" )   ; but spec. char(s) is blank
				{
					AWNr_Array_13 := mFullScreen_Find( AWNr_Array_1 )
				}
				split_FullScr_Sum := AWNr_Array_13
				AWNr_Element_Make()
				AWNr_%Nr% := AWNr_Element
				INI_Element := AWNr_Element
			}
			*/
			AWNr_CntEntries := Nr
			;Sleep 2000
			; msgbox 02 %A_Index%  ::  %INI_Element%  ::  %AWNr_Name%
		}
	}
	; msgbox INI_ElementStr READ %INI_Element_Str%
	
	If ( INIVersion_2 <= 30 AND INIVersion_MsgBox = "" )
	{
		;*** (1117)  "WinSize2.INI" was upgraded.\nIn the future do not use earlier versions of WinSize2 !"
		; Exclamation-mark OK-Button 120s timeout
		TTLMsg := vWinSize2_INI " " Message_Get(1117)
		MsgBox , 48, Upgrade, %TTLMsg%, 120
		INIVersion_MsgBox := "Done"
	}
	
	; mListVars()
	; msgbox mIniRead_All_User vor Sort_Titles  "%vLanguage_NameLong%"  "%IniFile_PathFile_SaveINI%"
	
	Sort_Titles()
	
	; msgbox Anzahl in WinSize: %AWNr_CntEntries% 
	AWNr_CntEntries_Max := AWNr_CntEntries

	If ( vTooltip )
		Tooltip mIniRead_All_User has been read

	; mListVars()
	; msgbox mIniRead_All_User Return  "%vLanguage_NameLong%"  "%IniFile_PathFile_SaveINI%"

Return
}
/*
 ***************************************************************************
 *  END of #Include inc_IniReadWrite_User.AHK
 ***************************************************************************
 */

/*************************************************************************
 *  Routine mCtrl_Alt_Y_Hotkey_SetMessage
 */
mCtrl_Alt_Y_Hotkey_SetMessage()
{
	Global
	
	vCtrl_Alt_Y_Hotkey_Char ="
	; msgbox GEFUNDEN: %vCtrl_Alt_Y_Hotkey%  %vCtrl_Alt_Y_Hotkey%
	IfInString, vCtrl_Alt_Y_Hotkey, +
	{
		;*** (1040) Shift
		Message := Message_Get( 1040 )
		vCtrl_Alt_Y_Hotkey_Char =%vCtrl_Alt_Y_Hotkey_Char%%Message%+
		; msgbox GEFUNDEN: Shift
	}
	IfInString, vCtrl_Alt_Y_Hotkey, #
	{
		;*** (1002) Win
		Message := Message_Get( 1002 )
		vCtrl_Alt_Y_Hotkey_Char =%vCtrl_Alt_Y_Hotkey_Char%%Message%+
		; msgbox GEFUNDEN: Ctrl
	}
	IfInString, vCtrl_Alt_Y_Hotkey, ^
	{
		;*** (1018) Ctrl
		Message := Message_Get( 1018 )
		vCtrl_Alt_Y_Hotkey_Char =%vCtrl_Alt_Y_Hotkey_Char%%Message%+
		; msgbox GEFUNDEN: Ctrl
	}
	IfInString, vCtrl_Alt_Y_Hotkey, ^!
	{
		;*** (1019) Alt
		Message := Message_Get( 1019 )
		vCtrl_Alt_Y_Hotkey_Char =%vCtrl_Alt_Y_Hotkey_Char%%Message%+
		; msgbox GEFUNDEN: Alt
	}
	StringRight, Buch, vCtrl_Alt_Y_Hotkey, 1
	vCtrl_Alt_Y_Hotkey_Char =%vCtrl_Alt_Y_Hotkey_Char%%Buch%"
	; msgbox GEFUNDEN Char: %vCtrl_Alt_Y_Hotkey_Char%

	vAuthor =Hotkey: %vCtrl_Alt_Y_Hotkey_Char%
	
	#IncludeAgain inc_vProgramName.ahk

	Return
}
/*
 *  END mCtrl_Alt_Y_Hotkey_SetMessage
 *************************************************************************
 */

/*************************************************************************
 *   File:  #Include inc_Ctrl_Alt_Y.ahk
 *   Author:Kalle Koseck
 *   Date:  2005-05-20 18:29
 *   Vers:  0.10
 *          0.11  2005-06-21 Hotkey was Off after initialisation
 *   AHK:   1.0.35+
 *   OS:    Win 2000
 *
 *   PnP:   in principle YES; Template for your hotkey
 *          #Include this file in your auto-execute section
 *
 *          search for neccessary user changes: NextUserChange
 *
 *************************************************************************
 *  If you receive the error message:
 *
 *    Line Text: IniFile_TimeInterval=500
 *    Error: This variable or function name contains an illegal character
 *
 *  update to the actual version of AutoHotkey (the version you are using
 *  does not know this function).
 *
 *************************************************************************
 *  Hotkey-Method for a special key
 *
 *  Benefits:
 *
 *  - no wasting of special keys; one key may have different options
 *    you have to remember only one key
 *
 *  - run-time changeable timeout time
 *
 *  - run-time changeable hotkey
 *    can e.g. be read from an INI file and
 *    can be redefined on and off line
 *
 *  - defaults are defined;
 *    you don't have to call the mCtrl_Alt_Y_Init( "" , "" ) method
 *    explicitly in your code; the #Include does that for you
 *    You only have to #Include inc_Ctrl_Alt_Y.ahk somewhere in the
 *    autoexecute section of your AHK main program.
 *
 *    If you call the _Init method with blank parameters (as above)
 *    and if no old values exist, the defaults will be taken.
 *    (That means: if you once set the time to 300 msec and call
 *    _Init ( Key, "" ) then the 300 msec are preserved.)
 *
 *  Example for the use of this module:
 *
 *    1 key-click:  could be: insert function
 *    2 key-clicks: delete function
 *    3 key-clicks: show options
 *
 *    I used this module in a WinSize module, which positions
 *    and sizes special windows that did not remember there last
 *    setting.
 *
 *  Description:
 *
 *  This module includes everything needed for processing one or more
 *  key-clicks to one special key (here to the keys Ctrl_Alt_Y).
 *
 *  After each pressing of the specified hotkey the routine waits for a
 *  user defined time for another click to that key (may be as
 *  in this example 500 msec).
 *
 *  When the time is elapsed and the hotkey is not pressed again
 *  a user supplied routine is called.
 *  The method gets the number of key-clicks before timeout.
 *
 *  Please look at:
 *  ---------------
 *  Lines marked with "<<<<<": please insert your own values here.
 *
 *  If you want to change this module to another key combination
 *  just replace for the whole text the "Ctrl_Alt_Y" with you new
 *  keys (e.g. "Win_X") and adjust the "<<<<<" lines.
 *------------------------------------------------------------------------
 *  Hotkey-Methode für eine spezielle Taste
 *
 *  Diese Methode kapselt auch die über ein implizites Gosub angesprungenen
 *  Routinen des Hotkeys und des Timers, so dass sie bei einem #Include
 *  im Kopf-Teil eines Programms übersprungen werden.
 *
 *  Bitte beachten Sie:
 *  -------------------
 *  Tragen Sie in Zeilen, die mit "<<<<<" markiert sind
 *  Ihre eigenen Werte ein. Suchen Sie nach: NextUserChange
 *
 *  Wenn Sie eine andere Tastenkombination verwenden wollen,
 *  ersetzen Sie einfach im gesamten Text die "Ctrl_Alt_Y"
 *  durch Ihre Tasten.
 *
 *************************************************************************
 *   Aufruf (auch für eine Umdefinition zur Laufzeit):
 *   Call (also for run-time redefinition):
 */

	mCtrl_Alt_Y_Init( HotkeyChars, IniFile_TimeInterval )

/*
 *   Parameter:
 *     HotkeyChars   one or more characters defining the hotkey
 *                   definition like AutohotKey uses it
 *
 * 	 IniFile_TimeInterval	timeout time [msec]
 *                   for the following character to be counted
 *                   as a double (...) clicked key
 */
;/////////////////////////////////////////////////////////////////////
mCtrl_Alt_Y_Init( HotkeyChars, IniFile_TimeInterval=5000 )
{
	; nicht vergessen, sonst koennen die draussen es nicht sehen
	; don't forget, otherwise those from outside can't see the variables
	Global
	Static vCtrl_Alt_Y_Hotkey_Old, vCtrl_Alt_Y_Time_Old, vCtrl_Alt_Y_Cnt


 	; <<<<< NextUserChange (more) <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	; <<<<< hier ev. andere Zeit eintragen <<<<<
	; <<<<< select other timeout time here <<<<<
	
	IniFile_TimeInterval_default = 2000
	
	; <<<<< hier die  Hotkey Buchstaben eintragen     <<<<<
	; <<<<< put in the correct hotkey characters here <<<<<
	;       ^! = Ctrl Alt
	StringRight, HotkeyChars_Char, HotkeyChars, 1
	HotkeyChars_default  = ^!%HotkeyChars_Char%
	; msgbox hotkey  "%HotkeyChars_default%"  "%HotkeyChars_Char%"
 	; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

	If ( IniFile_TimeInterval )
		vCtrl_Alt_Y_Time := IniFile_TimeInterval
	Else
		If ( ! vCtrl_Alt_Y_Time )   ; if no old values exist
			vCtrl_Alt_Y_Time := IniFile_TimeInterval_default

	; run-time redefinition: if another (or the same) hotkey was set before
	; disable old hotkey first
	If ( vCtrl_Alt_Y_Hotkey_Old )
	{
		HotKey, %vCtrl_Alt_Y_Hotkey_Old% , Off
		;Tooltip Old Hotkey %vCtrl_Alt_Y_Hotkey_Old% OFF
		;Sleep 5000
	}
	vCtrl_Alt_Y_Hotkey := HotkeyChars_default
	If ( HotkeyChars )
	{
		; listvars
		; MsgBox Hotkey alt/Neu: "%vCtrl_Alt_Y_Hotkey%" "%HotkeyChars%" 
		vCtrl_Alt_Y_Hotkey =%HotkeyChars%
	}

	;msgbox mCtrl_Alt_Y_Init: vCtrl_Alt_Y_Hotkey = %vCtrl_Alt_Y_Hotkey%
	;Tooltip mCtrl_Alt_Y_Init: %HotkeyChars% : %IniFile_TimeInterval% / %vCtrl_Alt_Y_Hotkey% : %vCtrl_Alt_Y_Time%
	;Sleep 5000
	HotKey, %vCtrl_Alt_Y_Hotkey% , mCtrl_Alt_Y_Hotkey
	HotKey, %vCtrl_Alt_Y_Hotkey% , On
	vCtrl_Alt_Y_Hotkey_Old = %vCtrl_Alt_Y_Hotkey%

Return	; of Init method but not the end

/*
 *------------------------------------------------------------------------
 */
mCtrl_Alt_Y_Hotkey:
	vCtrl_Alt_Y_Cnt += 1
	MouseGetPos, vCtrl_Alt_Y_MouseX, vCtrl_Alt_Y_MouseY
	vCtrl_Alt_Y_MouseX := vCtrl_Alt_Y_MouseX + 10

/*
If ( Tooltip_Show_Store )
{
TTL := 002
TTLMsg := ATime() ":  (" TTL ") mCtrl_Alt_Y_Hotkey pressed " vCtrl_Alt_Y_Cnt
Tooltip_%TTL% := TTLMsg
If ( Tooltip_Show_Tip = 1 )
{
CoordMode, ToolTip, Screen
Tooltip %TTLMsg%  ,TTX , TTL*TTM, TTL+TTP ;%
CoordMode, ToolTip, Relative
}  }
*/
	; Zeit nach jedem Buchstaben neu starten
	; Start the time interval again after each character
	SetTimer mCtrl_Alt_Y_Timer, %vCtrl_Alt_Y_Time%
	; SetTimer mCtrl_Alt_Y_Timer, 5000
	SetTimer_Start =%A_TickCount%

	; determin the max. message belonging to the set
	If ( ValueStartIgnored = "" )
	{
		; behind last function = no function
		; StringReplace, OutputVar, InputVar, SearchText
		; ErrorLevel = 0: SearchText was found
		Message_No := 1050 - 1
		Loop , 10
		{
			Message_No += 1
			Message := Message_Get( Message_No ) 
			; last message is, when *** contained
			IfInString, Message, ***
			{
				ValueStartIgnored := A_Index
				ValueMsgIgnored := A_Index
				IfNotInString, vProgram_NNamExt, .AHK
				{
					ValueStartIgnored -= 1
					; tooltip ValueStartIgnored-1  "%ValueStartIgnored%"  "%Message%"
				}
				Else
				{
					; tooltip ValueStartIgnored   "%ValueStartIgnored%"  "%Message%"
				}
				Break
			}
		}
	}

	; *** (1050) Insert / Overwrite Entry
	; *** (1051) Delete Entry
	; *** (1052) Special Parameters
	; *** (1053) Reload (only .AHK-version)
	; *** (1054) *** No Function ***

	Value := vCtrl_Alt_Y_Cnt
	If ( Value >= ValueStartIgnored )
	{
		Value := ValueMsgIgnored
	}
	; Tooltip "%Stars%" "%ErrorLevel%" "%Value%" "%ValueStartIgnored%" %vCtrl_Alt_Y_Hotkey_Char%:  %vCtrl_Alt_Y_Cnt%  *  %Message% ,vCtrl_Alt_Y_MouseX,vCtrl_Alt_Y_MouseY,20
	Message_No := 1050 + Value - 1
	Message := Message_Get( Message_No ) 

	;*** (1179)  NOT ACTIVE
	If ( vWinSize2_Not_Active = 1 )
	Message .= "   " Message_Get( 1179 ) 

	Tooltip %vCtrl_Alt_Y_Hotkey_Char%:  %vCtrl_Alt_Y_Cnt%  *    %Message% ,vCtrl_Alt_Y_MouseX,vCtrl_Alt_Y_MouseY,20

Return	; END mCtrl_Alt_Y_Init

/*
 *------------------------------------------------------------------------
 *
 * erreicht dieses Label nur, wenn der nächste Buchstabe nicht mehr
 * rechtzeitig kommt !
 * --------------------
 * only reaches this label if the next char is not pressed before the
 * timer expires !
 */
mCtrl_Alt_Y_Timer:

	SetTimer mCtrl_Alt_Y_Timer, Off
	SetTimer_Diff := A_TickCount - SetTimer_Start

;* AAAA
If ( Tooltip_Show_Store )
{
TTL := 007
TTLMsg := ATime() ":  (" TTL ") timeout received: Cnt: " vCtrl_Alt_Y_Cnt " msec: " SetTimer_Diff
Tooltip_%TTL% := TTLMsg
If ( Tooltip_Show_Tip = 1 )
{
CoordMode, ToolTip, Screen
Tooltip %TTLMsg%  ,TTX , TTL*TTM, TTL+TTP ;%
CoordMode, ToolTip, Relative
}  }
;* EEEE

 
	; <<<<< hier die eigentliche USER-Nutz-Funktion      <<<<<
	; <<<<< this is the function the USER has to provide <<<<<
	; <<<<< somewhere in his code                        <<<<<
	mCtrl_Alt_Y_And_Action( vCtrl_Alt_Y_Cnt )
	;
	; Deklaration der Funktion in Ihrem Programm:
	; declaration of the user function in your code:
	;
	;	mCtrl_Alt_Y_und_Action( Counter )
	;	{
	;		 ...
	;	}

	vCtrl_Alt_Y_Cnt := 0

	Return

}   ; END of method mCtrl_Alt_Y_Init
/*
 *************************************************************************
 *  END #Include inc_Ctrl_Alt_Y.ahk 
 *************************************************************************
 */

ATime()
{
	MilliSec := Floor( A_mSec / 100 )
	TimeMsg = %A_Hour%:%A_Min%:%A_Sec%.%MilliSec%
	Return TimeMsg
}

/*
 *************************************************************************
 *  ROUTINE mWinSize2_StringSplit
 */
mWinSize2_StringSplit( Index )
{
	Global
	
	AWNr_Index   := Index
	AWNr_Array_1 := Message_Get(1031)   ; << deleted >>
	AWNr_Array_2 := 
	AWNr_Array_3 := 
	AWNr_Array_4 := 
	AWNr_Array_5 := 
	AWNr_Array_6 := 
	AWNr_Array_7 := 0
	AWNr_Array_8 := 
	AWNr_Array_9 := 0
	AWNr_Array_10 := 0
	AWNr_Array_11 := 1
	AWNr_Array_12 := 
	AWNr_Array_13 := split_FullScr_Sum
	AWNr_Array_14 := split_Comment_Use
	AWNr_Array_15 := split_Comment_Text
	AWNr_Array_16 := AA1
	AWNr_Deleted = 1
	
	; -------------------------------------------------
	split_Done = NO-%A_TickCount%
	If ( Index >= 1 AND Index <= AWNr_CntEntries )
	{
		If ( AWNr_%Index% <> "" )
		{
			AWNr_Deleted = 0
			;----------------------------------------------
			StringSplit , AWNr_Array_, AWNr_%Index% , %CUT%, ,
			split_Done = sp-%A_TickCount%
			;----------------------------------------------
			If ( AWNr_Array_7 = "" )
				AWNr_Array_7 = 0
			If ( AWNr_Array_9 = "" )
				AWNr_Array_9 = 0
			If ( AWNr_Array_10 = "" )
				AWNr_Array_10 = 0
			If ( AWNr_Array_11 = "" )
				AWNr_Array_11 = 1
		}
	}
	
	; -------------------------------------------------

	mWinSize2_StringSplit_Cnt += 1

	; 1: starting with  2: contains  3: exact match
	; AWNr_Array_1        .= "   " mWinSize2_StringSplit_Cnt
	split_Title         := AWNr_Array_1
	split_X_Coord       := AWNr_Array_2
	split_Y_Coord       := AWNr_Array_3
	split_Width         := AWNr_Array_4
	split_Height        := AWNr_Array_5
	split_MatchMode_Set(   AWNr_Array_6 )
	split_AlwaysOnTop   := AWNr_Array_7
	split_Delay         := AWNr_Array_8
	split_XY_Always     := AWNr_Array_9
	split_WH_Always     := AWNr_Array_10
	split_MinNormMax    := AWNr_Array_11
	split_AhkClass      := AWNr_Array_12
	split_FullScr_Sum   := AWNr_Array_13
	split_Comment_Use   := AWNr_Array_14
	split_Comment_Text  := AWNr_Array_15
	split_AA1           := AWNr_Array_16
	
	; if string is empty: fill it and use the Class
	/*
	If ( split_AhkClass = "" )
	{
		WinGetClass, split_AhkClass_Name, %split_Title%
		split_AhkClass_UsedAll := split_AhkClass_UsedBase + 999   ; use it (all characters)
	}
	*/
	If ( split_AhkClass <> "" )
	{
		; SubStr(String, StartingPos [, Length])
		;  _UsedBase:  100000
		;  _UsedAll:   100999
		split_AhkClass_UsedAll := SubStr( split_AhkClass, 1, StrLen(split_AhkClass_UsedBase) )
		; old version does not contain this number: update
		If split_AhkClass_UsedAll Is Integer
		{
			split_AhkClass_Name := SubStr( split_AhkClass, StrLen(split_AhkClass_UsedBase)+1 )
			split_AhkClass_Str = 01:%Index%:
		}
		Else
		{
			split_AhkClass_UsedAll := split_AhkClass_UsedBase + 999   ; use it (all characters)
			split_AhkClass_Name := split_AhkClass
			split_AhkClass_Str = 02:%Index%:
		}
		split_AhkClass_Set( split_AhkClass_UsedAll,  split_AhkClass_Name )
		;  SubStr( String, StartPos, [Len] )
		;  _UsedAll:   100999
		;  _Used:         999
		split_AhkClass_Used := SubStr( split_AhkClass_UsedAll, StrLen(split_AhkClass_UsedAll)-3 ) + 0
		; msgbox split_AhkClass_Used "%split_AhkClass_UsedAll%" "%split_AhkClass_Used%" 
		split_AhkClass_Str .= "split_AhkClass_Name: " split_AhkClass_UsedAll "/" split_AhkClass_Used "/" split_AhkClass_Name
	}
	

/*	;* AAAA
	If ( Tooltip_Show_Store )
	{
	TTL := 002

	TTLMsg := ATime() ":  (" TTL ") " mWinSize2_StringSplit_Cnt " mWinSize2_StringSplit " Number ":" split_Title "|" split_X_Coord "|" split_Y_Coord "|" split_Width "|" split_Height
	TTLMsg .= "|  " split_MatchMode "|" split_AlwaysOnTop "|" split_Delay 
	TTLMsg .= "|  " split_XY_Always "|" split_WH_Always "|" split_MinNormMax "|" split_AhkClass_Name "|" split_FullScr_Sum "|" split_Comment_Use "|" split_Comment_Text CUT AA1

	Tooltip_%TTL% := TTLMsg
	If ( Tooltip_Show_Tip = 1 )
	{
	CoordMode, ToolTip, Screen
	Tooltip %TTLMsg%  ,TTX , TTL*TTM, TTL+TTP ;%
	CoordMode, ToolTip, Relative
	}  }
	;* EEEE
*/
	Return
}

/*
 *************************************************************************
 *  ROUTINE mWinSize2_StringSplit_to_AW
 */
mWinSize2_StringSplit_to_AW()
{
	Global
	
	AW_Title        := split_Title
	AW_X_Coord      := split_X_Coord
	AW_Y_Coord      := split_Y_Coord
	AW_Width        := split_Width
	AW_Height       := split_Height
	AW_MatchMode    := split_MatchMode_Set(   AWNr_Array_6 )
	AW_AlwaysOnTop  := split_AlwaysOnTop
	AW_Delay        := split_Delay 
	AW_XY_Always    := split_XY_Always
	AW_WH_Always    := split_WH_Always
	AW_MinNormMax   := split_MinNormMax
	AW_AhkClass     := split_AhkClass_Name
	AW_FullScr_Sum  := split_FullScr_Sum
	AW_Comment_Use  := split_Comment_Use
	AW_Comment_Text := split_Comment_Text
	AW_AA1          := split_AA1

	Return
}

/*
 *************************************************************************
 */
mAWNr_Display()
{
	Global

	If ( Tooltip_Show_Store )
	{

	AWNr_String := "mAWNr_Display: " A_TickCount
	Loop, %AWNr_CntEntries%
	{
		AWNr_String .=  "`n"
		; If ( A_Index = AWNr_XRef_%split_Title_NrInt% )
		If ( A_Index = AW_ListIndex )
			AWNr_String .=  "> "
		AWNr_String .=  A_Index ":" AWNr_%A_Index%
	}
	
	;* AAAA

	TTL := 015
	TTLMsg := 
	TTLMsg := ATime() ":  (" TTL ")  " split_Title_NrInt "/" split_Title_NrAW "  ::  " XRef_Str " :: " AWNr_String
	Tooltip_%TTL% := TTLMsg
	If ( Tooltip_Show_Tip = 1 )
	{
	CoordMode, ToolTip, Screen
	Tooltip %TTLMsg%  ,TTX , TTL*TTM, TTL+TTP ;%
	CoordMode, ToolTip, Relative
	}  }
	;* EEEE

}   ; END of method mAWNr_Display

/*
 **********************************************************************
 * ROUTINE 
 */
split_MatchMode_Set( Mode )
{
	Global
	
	split_MatchMode := Mode
	
	If ( split_MatchMode < 1 OR split_MatchMode > 3 )
		split_MatchMode := 3

	; If ( split_MatchMode = 2 )
	;	msgbox split_MatchMode_Set: /%split_Title_NrInt_Old%/%split_Title_NrInt%/
		
	
	Return
}

/*
 **********************************************************************
 * ROUTINE 
 */
Delete_All_Tooltips()
{
	Global
	
	Tooltip
	
	If ( Tooltip_Show_Tip = 1 )
	{
		Loop , 19
		{
			Index := A_Index + 1
			Tooltip,,,, %A_Index%
		}
	}
}

/*
 **********************************************************************
 *  ROUTINE 
 *
 *  Loop through all lines of exclude list
 *  and check if (window-title + ) Win-ID still exists
 *  if not exist: delete that row
 *
 *  search all xx msec
 */
Exclude_List()
{
	Global

	If ( Exclude_List_Timer > 0  AND  Exclude_List_Timer > A_TickCount )
	{
		Return
	}

	Exclude_List_Timer := A_TickCount + Exclude_List_Timer_Add

	; --- check if the actual window exists in table
	Exclude_Text = *** Exclude-List *** `n
	AW_Title_Fnd_inExcludeTable = 0
	RowNoDeleted = 0

	; --------------------------------------------------------------------------------
	; go through all lines of the table
	Loop
	{
		; get table content
		Exclude_IO_1 := A_Index
		Exclude_IO_2 := 
		RowNoFnd := Matrix_Operate( "RowGet", "Exclude_IO", "Exclude" )
		;  Exclude_Title := Exclude_IO_1
		;  ID :=  Exclude_IO_2
		;  Protected := Exclude_IO_3
		;  MatchMode := Exclude_IO_4   ; 2:contains 3:exact
		; tooltip % ATime() " " A_Index  ;%;
		If ( RowNoFnd = 0 )   ; end of list reached
			Break
		If ( Exclude_IO_1 = "" )   ; is empty: skip to end of loop
			Continue

		If ( Exclude_IO_3 = "" )   ; Protected
			Exclude_IO_3 := 0
		AW_UniqueID_bool := 0
		AW_Title_bool := 0
		If ( AW_UniqueID = Exclude_IO_2 )
		{
			AW_UniqueID_bool := 1
			If ( AW_MatchMode = Exclude_IO_4
				AND ( ( AW_MatchMode = 2  AND  InStr( AW_Title, Exclude_IO_1 ) )
				OR ( AW_MatchMode = 3  AND  AW_Title = Exclude_IO_1 ) )  )
			{
				AW_Title_bool := 1
				AW_Title_Fnd_inExcludeTable := 1
			}
		}
		Count := 0
		If ( Exclude_IO_1 <> "" )   ; lines with information
		{
			; -------------------------------------------------------------------------
			SetTitleMatchMode, %Exclude_IO_4%   ; 2:contains 3:exact
			; WinGet, OutputVar, Cmd, WinTitle  ; Count of windows with this Exclude_IO_1 + ID
			; WinGet , Count , Count , %Exclude_IO_1% ahk_id %Exclude_IO_2%
			; search for Win-ID only (Exclude_Title may have changed)
			;=============
			; DetectHiddenWindows On
			WinGet      , Count , Count , %Exclude_IO_1% ahk_id %Exclude_IO_2%   ; ID
			WinGetClass , Class         , %Exclude_IO_1% ahk_id %Exclude_IO_2%
			DetectHiddenWindows Off
			;=============
			; Exclude_Text .= ">> WinGet Ind:" A_Index " Cnt:" Count " M=" Exclude_IO_4 " ID=" Exclude_IO_2 " Cl=" Class " / P:" Exclude_IO_3  "`n" 
			; -------------------------------------------------------------------------
		}
		If ( Exclude_IO_1 = "" ) 
			Exclude_IO_1 = -
		If ( Exclude_IO_2 = "" )
			Exclude_IO_2 = -

		Exclude_Text .= RowNoFnd "/" Exclude__aRows " Cnt:" Count " [" AW_UniqueID_bool "," AW_Title_bool "]:  Prot:" Exclude_IO_3 " M=" Exclude_IO_4 " ID=" Exclude_IO_2 " Cl=" Class "   :" Exclude_IO_1 ":"
		; msgbox RowGet %RowNoFnd%/%Exclude__aRows%: "%Exclude_IO_2%" "%Exclude_IO_1%" Count:"%Count%"
		; /*
		; application does not exist AND not Protected
		If ( Count = 0 AND Exclude_IO_3 = 0 )   
		{
			RowNoDeleted = 1
			Exclude_IO_1 := A_Index
			RowNoFnd := Matrix_Operate( "RowDel","Exclude_IO", "Exclude" )
			Exclude_Text .= "  << Deleted >>"
			AW_UniqueID_Old :=    ; delete - could most probably be the act window

			LogText :=  "< " "Delete [Excl:" A_Index "] :" Exclude_IO_1 ":"
			mLogFile_Write( 2, LogText )
		}
		; */
		Exclude_Text .= "`n"
	}
	; --------------------------------------------------------------------------------
	AW_Title_Fnd_canMove := ! AW_Title_Fnd_inExcludeTable
	
	Exclude_TextAct := "ID=" AW_UniqueID " Cl=" AW_AhkClass " :" AW_Title ": Fnd:" AW_Title_Fnd_inExcludeTable
	If ( AW_Title_Fnd_inExcludeTable )
	{
		TTL := 009
		Exclude_TextAct .= "     in Excl-Table: CANNOT be moved"
		LogText := "--  " "in_Excl_Table: NO Move    :" AW_Title ": M=" Exclude_IO_4 ":"
	}
	Else
	{
		TTL := 010
		Exclude_TextAct .= "     not in Excl-Table: possible  MOVE"
		LogText := "not_in_Excl: CAN be Moved :" AW_Title ": M=" Exclude_IO_4 ":"
	}
	mLogFile_Write( 4, LogText )
	
	If ( ! AW_AsBefore )
	;* AAAA
	If ( Tooltip_Show_Store )
	{
	; TTL := 009
	TTLMsg := ATime() ":  (" TTL ")   " Exclude_TextAct
	Tooltip_%TTL% := TTLMsg
	If ( Tooltip_Show_Tip )
	{
		If ( RowNoDeleted )
		{
			Exclude_List_Timer += 4000
		}
	CoordMode, ToolTip, Screen
	Tooltip %TTLMsg%  ,TTX , TTL*TTM, TTL+TTP
	CoordMode, ToolTip, Relative
	}  }
	;* EEEE

	; msgbox %Exclude_Text%

	;* AAAA
	If ( Tooltip_Show_Store )
	{
	TTL := 011
	TTLMsg := ATime() ":  (" TTL ")   " Exclude_Text
	Tooltip_%TTL% := TTLMsg
	If ( Tooltip_Show_Tip )
	{
	CoordMode, ToolTip, Screen
	Tooltip %TTLMsg%  ,TTX , TTL*TTM, TTL+TTP
	CoordMode, ToolTip, Relative
	}  }
	;* EEEE


	; mFullScreen_Display()

	Return
}

/*
 **********************************************************************
 * ROUTINE 
 */
Exclude_List_INS( Title, UniqueID, Protected=0, MatchMode=3 )
{
	Global
/*
	Exclude_IO_1 := AW_Title_inTable   ; col 1 INSert into table
	Exclude_IO_2 := AW_UniqueID        ; col 2
*/
	Exclude_IO_1 := Title           ; col 1 INSert into table
	Exclude_IO_2 := UniqueID        ; col 2
	Exclude_IO_3 := Protected       ; col 3
	Exclude_IO_4 := MatchMode       ; col 4

	If ( Exclude_IO_1 = "" )
		Return 0
	
	RowNo := Matrix_Operate( "FND*", "Exclude_IO", "Exclude" )
	If ( RowNo = 0 )
	{
		RowNo := Matrix_Operate( "EMPTY", "Exclude_IO", "Exclude" )
	}

	Exclude_IO_5 := RowNo
	RowNo := Matrix_Operate( "ROWINS", "Exclude_IO", "Exclude" )
	If ( RowNo = "" )
	{
		LogText = ERROR Exclude_List_INS: RowNo=EMPTY   "%Title%"  ID="%UniqueID%" P:"%Protected%"  M="%MatchMode%"
		Tooltip %LogText%`n`n         *** see LOG file ***
		mLogFile_Write( 1, LogText )
	}
	
	LogText := "> " "Insert [Excl:" RowNo "] :" Title ": Cl=" AW_AhkClass " ID=" UniqueID " M=" MatchMode
	mLogFile_Write( 2, LogText )

	;RowNo := Matrix_Operate( "INS" , "Exclude_IO", "Exclude" )

	Return %RowNo%
}

/*
 **********************************************************************
 * ROUTINE 
 */
mListVars()
{
	; If ( Tooltip_Show_Tip )
	If ( 1 )
	{
		ListVars
		; WinMove, WinTitle, WinText, X        , Y       [, Width    , Height, ExclTitle, ExclText]
		WinMove , C:\Program Files\Scripte\SF_WinSize2\WinSize2.ahk - AutoHotkey v1.0.48.05,, 2500, -180, 700, 1280
	}

}

/*
 **********************************************************************
 * ROUTINE 
 */
ChkInactiveWindows()
{
	Global

	Inactive_RowNo := -1
	If ( ChkInactive_TickCount <= A_TickCount )
	{
		; --- next check: in 1000 msec
		ChkInactive_TickCount := A_TickCount + 1000
		
		; through all window names in the list
		; if window exists (count > 0)
		; and not in exclude-list (= not registered till now)
		; it should be moved
		
		Loop, %AWNr_CntEntries%
		{
			mWinSize2_StringSplit( A_Index )
			AW_Title = %split_Title%
			
			WinGet , Count , Count , %split_Title%
			If ( Count > 0 )   ; Window exists
			{
				Exclude_IO_1 := split_Title
				Inactive_RowNo := Matrix_Operate( "FND", "Exclude_IO", "Exclude" )
				
				; Inactive_RowNo = 0: window is new: not entered in exclude list
				If ( Inactive_RowNo = 0 )
				{
					Inactive_Title := split_Title
					Break
				}
			}
		}

	}
	Return Inactive_RowNo
}

/*
 *************************************************************************
 *  mLogFile_Write: Routine
 */
mLogFile_Write( Level, Text )
{
	Global LogFile_PathFile, LogFile_Size_kB, LogFile_Text_Last, LogFile_Level, LogFile_Cnt, mActWin_Timer_Zhl
	
	If ( Level = -1 )
	{
		; --- = -1: do not delete/recycle
		If ( LogFile_Size_kB <> -1 )
		{
			LogFile_Size_kB_Abs := Abs( LogFile_Size_kB )
			FileGetSize, Size, %LogFile_PathFile%, K   ; FileSize
			If ( Size > LogFile_Size_kB_Abs )
			{
				; --- if negative: FileRecycle;  if positive: FileDelete
				If ( LogFile_Size_kB < 0 )
				{
					; MsgBox Log-FileSize-Recycle: "%Size%" > "%LogFile_Size_kB%"
					FileRecycle, %LogFile_PathFile%
				}
				Else
				{
					; MsgBox Log-FileSize-Delete: "%Size%" > "%LogFile_Size_kB%"
					FileDelete, %LogFile_PathFile%
				}
			}
		}
		Text := ".`n"
	}
	Else
	{
		;-------------------------------------------
		; no log
		If ( Level > LogFile_Level )
			Return

		;-------------------------------------------
		; no double lines please
		If ( LogFile_Text_Last = Text )
			Return

			LogFile_Text_Last := Text

		;-------------------------------------------
		LogFile_Cnt += 1

		; StringLeft, OutputVar, InputVar, Count
		; StringLeft  Text01, Text, 1
		
		If ( Level = 1 )
			Text := "*** " Text   ; ERROR
		If ( Level = 2 )
			Text := " == " Text   ; Move
		If ( Level = 3 )
			Text := "    " Text   ; Trace
		If ( Level = 4 )
			Text := "    -- " Text    ; Info

		Text := ATime() " [" mActWin_Timer_Zhl "," LogFile_Cnt "] " Level " " Text "`n"
	}
	
	FileAppend, %Text%, %LogFile_PathFile%
	
	; Tooltip mLogFile_Write %Text%


	Return
}   ; END of method mLogFile_Write


/*
 *************************************************************************
 * ROUTINE ChkLogical
 */
ChkLogical( LogicalVar )
{
	/*
	If ( LogicalVar <> -1
			AND LogicalVar <> 0
			AND LogicalVar <> 1 )
	*/
	If ( LogicalVar Is Integer )
	{
		If ( LogicalVar = -1 )
			Return -1
		Else If ( LogicalVar <> 0 )
			Return 1
		Else
			Return 0
	}
	Else
		Return 0
}
/*
 *************************************************************************
 * ROUTINE split_AhkClass_Set
 */
split_AhkClass_Set( Used, Name )
{
	Global split_AhkClass, split_AhkClass_UsedBase, split_AhkClass_UsedBaseYes, split_AhkClass_UsedStr
	
	; Class = 100999ClassName
	If ( Used = -1 )
	{
		split_AhkClass := split_AhkClass_UsedBaseYes Name
		split_AhkClass_UsedStr = YES %split_AhkClass%--%split_AhkClass_UsedBaseYes% :: %Name%
		Return
	}

	If ( Used >= split_AhkClass_UsedBase )
	{
		UsedInt := Used
		split_AhkClass_UsedStr = GTR 
	}
	Else
	{
		UsedInt := split_AhkClass_UsedBase + Used
		split_AhkClass_UsedStr = ELSE 
	}
	
	split_AhkClass := UsedInt Name
	split_AhkClass_UsedStr = %split_AhkClass_UsedStr%--%split_AhkClass%--%UsedInt%--%Name%
	; tooltip split_AhkClass_Set --%split_AhkClass% :: %UsedInt%--%Name%
	Return
}

/*
 **********************************************************************
 * SUB mWS2_InitCmdOnce:
 */
mWS2_InitCmdOnce()
{
	Global
	
	; msgbox SUB mWS2_InitCmdOnce "%IniFile_PathFile_DesktopIcon_IsChecked%"  "%DesktopIcon_AutoRestore%"  "%DesktopIcon_CheckAfterLogin_Once%"  "%DesktopIcon_CheckAfterLogin%"
	; only used here to do this once
	If ( IniFile_PathFile_DesktopIcon_IsChecked = 0
		AND Command_Update = 0 )
	{
		IniFile_PathFile_DesktopIcon_IsChecked := 1
		
		; msgbox mWS2_InitCmdOnce 20 "WS2_InitCmd.cmd"
		mRunCheck( 2, "WS2_InitCmd.cmd" )

		If ( DesktopIcon_AutoRestore = 1 )
		{
			mDesktopIconRestore()
		}
		
		Else If ( DesktopIcon_CheckAfterLogin_Once > 0 )
		{
			IniFile_PathFile_DesktopIcon_IsChecked := 1
			; dont show box if nothing was changed
			mDesktopIconCreateFile( "CheckNoBox" )  
			; msgbox mWS2_InitCmdOnce 21 mDesktopIconCreateFile "CheckNoBox" 

			mRunCheck( 1, IniFile_Utils_CMD_Run , "Desktop CheckNoBox " Screen_Width_Height )
			; msgbox mWS2_InitCmdOnce 22 mDesktopIconCreateFile "CheckNoBox" 

			Desktop_Network_Ready_Error := ErrorLevel
			Desktop_Network_Ready_File := IniFile_Utils_CMD
		}
	}

}
/*
 **********************************************************************
 * SUB mRunCheck:
 *     Para1: 1: Run   2: RunWait
 */
 mRunCheck( Run_or_Wait, Filename , Parameter="")
 {
	Global RunWait_Min
	
	IfExist %Filename%
	{
		;  e.g. "WS2_InitCmd.Cmd"
		
		mLogFile_Write( 2, "Started: " Filename "  Para: " Parameter )
		Run_Error :=
		If ( Run_or_Wait = 1 )
		{
			; msgbox mRunCheck Run: "%Filename%"  "%Parameter%"  "%RunWait_Min%"
			Run  %Filename% %Parameter% ,  , %RunWait_Min%
		}
		If ( Run_or_Wait = 2 )
		{
			; msgbox mRunCheck RunWait: "%Filename%"  "%Parameter%"  "%RunWait_Min%"
			RunWait  %Filename% %Parameter% ,  , %RunWait_Min%
		}
	}
	Else
	{
		; *** (1181)  ##File does not exist##Please re-install WinSize2
		MsgBox % Filename  Message_Get( 1181 )    ; % ; 
		mLogFile_Write( 2,  "*** File does not exist: " Filename "  Para: " Parameter )
	}
	; msgbox mRunCheck 99: %Filename% %Parameter%
 }

/*
 **********************************************************************
 * SUB :
 */
#Include inc_Message.ahk
#Include inc_WinSize2_Parameter.ahk
#Include inc_MenuTray.ahk
#Include inc_Update_WinSize2.ahk
#Include inc_SlashAtTheEnd.ahk
#Include inc_Cmd.ahk
#Include inc_Matrix.ahk
#Include inc_Stack.ahk
