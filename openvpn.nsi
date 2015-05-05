; ****************************************************************************
; * Copyright (C) 2002-2006 OpenVPN Solutions LLC                            *
; *               2004-2006 Updated by Mathias Sundman <mathias@openvpn.se>  * 
; *  This program is free software; you can redistribute it and/or modify    *
; *  it under the terms of the GNU General Public License as published by    *
; *  the Free Software Foundation; either version 2 of the License, or       *
; *  (at your option) any later version.                                     *
; ****************************************************************************

; ****************************************************************************
; * Updated February 2011 by Matthew Marable <mmarable@oitibs.com>
; * Removed OpenVPN server executables (corporate - client only installation)
; * Added processor architecture detection to make installer x86_64 capable 
; * Update source paths for installer building with NSIS
; * Added OpenVPN icon to installer for clean appearance
; * Set OpenVPN GUI registry key entries to disable options
; * Added Custom OpenVPN GUI Client
; ****************************************************************************

; OpenVPN install script for Windows, using NSIS
!include "x64.nsh"
!include "MUI.nsh"
!include "setpath.nsi"

!define HOME "openvpn"
!define BIN "${HOME}\bin"

!define PRODUCT_NAME "OpenVPN"
!define OPENVPN_VERSION "2.3.6-N6"
!define GUI_VERSION "2.3.6-N6"
!define VERSION "${OPENVPN_VERSION}"

!define TAP "tap0901"
!define TAPDRV "${TAP}.sys"
!define TAPCAT "${TAP}.cat"

; something like "-DBG2"
!define OUTFILE_LABEL ""

; Default OpenVPN Service registry settings
!define SERV_CONFIG_DIR   "$INSTDIR\config"
!define SERV_CONFIG_EXT   "ovpn"
!define SERV_EXE_PATH     "$INSTDIR\bin\openvpn.exe"
!define SERV_LOG_DIR      "$INSTDIR\log"
!define SERV_PRIORITY     "NORMAL_PRIORITY_CLASS"
!define SERV_LOG_APPEND   "0"

; Default OpenVPN GUI registry settings
!define GUI_CONFIG_DIR    "$INSTDIR\config"
!define GUI_CONFIG_EXT    "ovpn"
!define GUI_EXE_PATH      "$INSTDIR\bin\openvpn.exe"
!define GUI_LOG_DIR       "$INSTDIR\log"
!define GUI_PRIORITY      "NORMAL_PRIORITY_CLASS"
!define GUI_LOG_APPEND    "0"
!define GUI_ALLOW_EDIT    "1"
!define GUI_ALLOW_SERVICE "0"
!define GUI_ALLOW_PROXY   "0"
!define GUI_ALLOW_PASSWORD "0"
!define GUI_SERVICE_ONLY  "0"
!define GUI_PSW_ATTEMPTS  "3"
!define GUI_UP_TIMEOUT    "15"
!define GUI_DOWN_TIMEOUT  "10"
!define GUI_PRE_TIMEOUT   "10"
!define GUI_SHOW_BALLOON  "1"
!define GUI_SHOW_SCRIPT   "1"
!define GUI_LOG_VIEWER    "$WINDIR\notepad.exe"
!define GUI_EDITOR        "$WINDIR\notepad.exe"
!define GUI_SUSPEND       "1"
!define GUI_SILENT_CONN   "1"

;--------------------------------
;Configuration

  ;General

  OutFile "OITIBS-openvpn-${OPENVPN_VERSION}-client-install-x86_64.exe"

  SetCompressor bzip2

  ShowInstDetails show
  ShowUninstDetails show

  ;Folder selection page
  InstallDir "$PROGRAMFILES\${PRODUCT_NAME}"
  
  ;Remember install folder
  InstallDirRegKey HKCU "Software\${PRODUCT_NAME}" ""

  !define SOURCE_ZIP_DEST "openvpn-${OPENVPN_VERSION}.zip"
  !define SOURCE_ZIP_SRC "${HOME}\${SOURCE_ZIP_DEST}"

  !define GUI_SOURCE_ZIP_DEST "openvpn-gui-${GUI_VERSION}.zip"
  !define GUI_SOURCE_ZIP_SRC "${HOME}\${GUI_SOURCE_ZIP_DEST}"

;--------------------------------
;Modern UI Configuration

  Name "${PRODUCT_NAME} ${OPENVPN_VERSION}"

  !define MUI_COMPONENTSPAGE_SMALLDESC
  !define MUI_FINISHPAGE_NOAUTOCLOSE
  !define MUI_FINISHPAGE_SHOWREADME_NOTCHECKED
  !define MUI_ABORTWARNING
  !define MUI_ICON "${HOME}\openvpn.ico"
  !define MUI_UNICON "${HOME}\openvpn.ico"
  !define MUI_HEADERIMAGE
  !define MUI_UNFINISHPAGE_NOAUTOCLOSE

  !define MUI_WELCOMEPAGE_TITLE "Welcome to the ${PRODUCT_NAME} Setup"

  !define MUI_WELCOMEPAGE_TEXT "OpenVPN -  an Open Source VPN package by James Yonan.\r\n\r\nService provided on behalf of BurstVPN Networks."

  !define MUI_COMPONENTSPAGE_TEXT_TOP "Select the components to install/upgrade.  Stop any OpenVPN or OpenVPN GUI processes or the OpenVPN service if it is running."

  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH
  
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES  
  !insertmacro MUI_UNPAGE_FINISH

;--------------------------------
;Languages

  !insertmacro MUI_LANGUAGE "English"
  
;--------------------------------
;Language Strings

  LangString DESC_SecOpenVPNUserSpace ${LANG_ENGLISH} "Install OpenVPN user-space components, including openvpn.exe."

  LangString DESC_SecOpenVPNEasyRSA ${LANG_ENGLISH} "Install OpenVPN RSA scripts for X509 certificate management."
 
  LangString DESC_SecOpenSSLDLLs ${LANG_ENGLISH} "Install OpenSSL DLLs locally (may be omitted if DLLs are already installed globally)."

  LangString DESC_SecTAP ${LANG_ENGLISH} "Install/Upgrade the TAP virtual device driver.  Will not interfere with CIPE."
  
  LangString DESC_SecTAPHidden ${LANG_ENGLISH} "Install the TAP device as hidden. The TAP device will not be visible under Network Connections."

  LangString DESC_SecService ${LANG_ENGLISH} "Install the OpenVPN service wrapper (openvpnserv.exe)"

  LangString DESC_SecOpenSSLUtilities ${LANG_ENGLISH} "Install the OpenSSL Utilities (used for generating public/private key pairs)."

; LangString DESC_SecOpenVPNSource ${LANG_ENGLISH} "Install (but do not unzip) the source code zip files."

  LangString DESC_SecAddPath ${LANG_ENGLISH} "Add OpenVPN executable directory to the current user's PATH."

  LangString DESC_SecAddShortcuts ${LANG_ENGLISH} "Add shortcuts to the current user's Start Menu."

  LangString DESC_SecFileAssociation ${LANG_ENGLISH} "Register OpenVPN config file association (*.${SERV_CONFIG_EXT})"

  LangString DESC_SecGUI ${LANG_ENGLISH} "Install OpenVPN GUI (A System tray application to control OpenVPN)"

  LangString DESC_SecGUIAuto ${LANG_ENGLISH} "Automatically start OpenVPN GUI at system startup"

  LangString DESC_SecMYCERT ${LANG_ENGLISH} "Install My Certificate Wizard - A tool to create a certificate request."
;--------------------------------
;Data
  
;  LicenseData "${HOME}\install-win32\license.txt"

;--------------------------------
;Reserve Files
  
  ;Things that need to be extracted on first (keep these lines before any File command!)
  ;Only useful for BZIP2 compression
  
;  ReserveFile "${HOME}\install-win32\install-whirl.bmp"

;--------------------------------
;Macros

!macro WriteRegStringIfUndef ROOT SUBKEY KEY VALUE
Push $R0
ReadRegStr $R0 "${ROOT}" "${SUBKEY}" "${KEY}"
StrCmp $R0 "" +1 +2
WriteRegStr "${ROOT}" "${SUBKEY}" "${KEY}" '${VALUE}'
Pop $R0
!macroend

!macro DelRegStringIfUnchanged ROOT SUBKEY KEY VALUE
Push $R0
ReadRegStr $R0 "${ROOT}" "${SUBKEY}" "${KEY}"
StrCmp $R0 '${VALUE}' +1 +2
DeleteRegValue "${ROOT}" "${SUBKEY}" "${KEY}"
Pop $R0
!macroend

!macro DelRegKeyIfUnchanged ROOT SUBKEY VALUE
Push $R0
ReadRegStr $R0 "${ROOT}" "${SUBKEY}" ""
StrCmp $R0 '${VALUE}' +1 +2
DeleteRegKey "${ROOT}" "${SUBKEY}"
Pop $R0
!macroend

!macro DelRegKeyIfEmpty ROOT SUBKEY
Push $R0
EnumRegValue $R0 "${ROOT}" "${SUBKEY}" 1
StrCmp $R0 "" +1 +2
DeleteRegKey /ifempty "${ROOT}" "${SUBKEY}"
Pop $R0
!macroend

;------------------------------------------
;Set reboot flag based on tapinstall return

Function CheckReboot
  IntCmp $R0 1 "" noreboot noreboot
  IntOp $R0 0 & 0
  SetRebootFlag true
  DetailPrint "REBOOT flag set"
 noreboot:
FunctionEnd

;--------------------------------
;Installer Sections

;!define SF_SELECTED   1
;!define SF_RO         16
!define SF_NOT_RO     0xFFFFFFEF

Section "OpenVPN User-Space Components" SecOpenVPNUserSpace

  SetOverwrite on
  SetOutPath "$INSTDIR\bin"
  
  ${If} ${RunningX64}
	File "${BIN}\x64\openvpn.exe"
  ${Else}
    File "${BIN}\x86\openvpn.exe"
  ${EndIf}

SectionEnd

Section "OpenVPN GUI" SecGUI

  SetOverwrite on
  SetOutPath "$INSTDIR\bin"
  
 ${If} ${RunningX64}
	File "${BIN}\x64\openvpn-gui.exe"
  ${Else}
    File "${BIN}\x86\openvpn-gui.exe"
  ${EndIf}  
  
  # Include your custom config file(s) here.
  SetOutPath "$INSTDIR\config"
  File "${HOME}\config\Asia - Hong Kong.ovpn"
  File "${HOME}\config\USA - Las Vegas (Optimized for China Telecom).ovpn"
  File "${HOME}\config\USA - Los Angeles (Optimized for China Unicom).ovpn"
  File "${HOME}\config\USA - New York.ovpn"


  CreateDirectory "$INSTDIR\log"
  CreateDirectory "$INSTDIR\config"
  CreateShortcut "$DESKTOP\BurstVPN.lnk" "$INSTDIR\bin\openvpn-gui.exe"

SectionEnd

Section "OpenSSL DLLs" SecOpenSSLDLLs

  SetOverwrite on
  SetOutPath "$INSTDIR\bin"
  
   ${If} ${RunningX64}
	  File "${BIN}\x64\libeay32.dll"
	  File "${BIN}\x64\ssleay32.dll"
	  File "${BIN}\x64\liblzo2-2.dll"
	  File "${BIN}\x64\libpkcs11-helper-1.dll"
  ${Else}
	  File "${BIN}\x86\libeay32.dll"
	  File "${BIN}\x86\ssleay32.dll"
	  File "${BIN}\x86\liblzo2-2.dll"
	  File "${BIN}\x86\libpkcs11-helper-1.dll"
  ${EndIf}  

SectionEnd

Section "AutoStart OpenVPN GUI" SecGUIAuto
SectionEnd

Section "OpenVPN File Associations" SecFileAssociation
SectionEnd


Section "TAP Virtual Ethernet Adapter" SecTAP

  SetOverwrite on

  FileWrite $R0 "REM Add a new TAP virtual ethernet adapter$\r$\n"
  FileWrite $R0 '"$INSTDIR\bin\devcon.exe" install "$INSTDIR\driver\OemVista.inf" ${TAP}$\r$\n'
  FileWrite $R0 "PAUSE$\r$\n"
  FileClose $R0

  FileWrite $R0 "ECHO WARNING: this script will delete ALL TAP virtual adapters (use the device manager to delete adapters one at a time)$\r$\n"
  FileWrite $R0 "PAUSE$\r$\n"
  FileWrite $R0 '"$INSTDIR\bin\devcon.exe" remove ${TAP}$\r$\n'
  FileWrite $R0 "PAUSE$\r$\n"
  FileClose $R0

  ${If} ${RunningX64}
	DetailPrint "We are running on a 64-bit system."
	SetOutPath "$INSTDIR\bin"
	File "${BIN}\x64\devcon.exe"
	SetOutPath "$INSTDIR\driver"
	File "${HOME}\driver\x64\${TAPDRV}"
	File "${HOME}\driver\x64\${TAPCAT}"
	IntOp $R0 $R0 & ${SF_SELECTED}
	IntCmp $R0 ${SF_SELECTED} "" nohiddentap64 nohiddentap64
  ${Else}
	DetailPrint "We are running on a 32-bit system."
	SetOutPath "$INSTDIR\bin"
	File "${BIN}\x86\devcon.exe"
	SetOutPath "$INSTDIR\driver"
	File "${HOME}\driver\x86\${TAPDRV}"
	File "${HOME}\driver\x86\${TAPCAT}"
	IntOp $R0 $R0 & ${SF_SELECTED}
	IntCmp $R0 ${SF_SELECTED} "" nohiddentap32 nohiddentap32
  ${EndIf}  


  nohiddentap64:
  File "${HOME}\driver\x64\OemVista.inf"
  goto end

  nohiddentap32:
  File "${HOME}\driver\x86\OemVista.inf"

  end:

SectionEnd

Section "Add OpenVPN to PATH" SecAddPath

  ; remove previously set path (if any)
  Push "$INSTDIR\bin"
  Call RemoveFromPath

  ; append our bin directory to end of current user path
  Push "$INSTDIR\bin"
  Call AddToPath

SectionEnd


;--------------------
;Post-install section

Section -post

  ; delete old devcon.exe
  ; Delete "$INSTDIR\bin\devcon.exe"

  ;
  ; install/upgrade TAP-Win32 driver if selected, using devcon.exe
  ;
  SectionGetFlags ${SecTAP} $R0
  IntOp $R0 $R0 & ${SF_SELECTED}
  IntCmp $R0 ${SF_SELECTED} "" notap notap
    ; TAP install/update was selected.
    ; Should we install or update?
    ; If tapinstall error occurred, $5 will
    ; be nonzero.
    IntOp $5 0 & 0
    nsExec::ExecToStack '"$INSTDIR\bin\devcon.exe" hwids ${TAP}'
    Pop $R0 # return value/error/timeout
    IntOp $5 $5 | $R0
    DetailPrint "devcon hwids returned: $R0"

    ; If tapinstall output string contains "${TAP}" we assume
    ; that TAP device has been previously installed,
    ; therefore we will update, not install.
    Push "${TAP}"
    Call StrStr
    Pop $R0

    IntCmp $5 0 "" tapinstall_check_error tapinstall_check_error
    IntCmp $R0 -1 tapinstall

 tapinstall:
    DetailPrint "TAP REMOVE OLD TAP"
    nsExec::ExecToLog '"$INSTDIR\bin\devcon.exe" remove TAP'
    Pop $R0 # return value/error/timeout
    DetailPrint "devcon remove TAP returned: $R0"
    nsExec::ExecToLog '"$INSTDIR\bin\devcon.exe" remove TAPDEV'
    Pop $R0 # return value/error/timeout
    DetailPrint "devcon remove TAPDEV returned: $R0"

    DetailPrint "TAP INSTALL (${TAP})"
    nsExec::ExecToLog '"$INSTDIR\bin\devcon.exe" install "$INSTDIR\driver\OemVista.inf" ${TAP}'
    Pop $R0 # return value/error/timeout
    Call CheckReboot
    IntOp $5 $5 | $R0
    DetailPrint "devcon install returned: $R0"

 tapinstall_check_error:
    DetailPrint "devcon cumulative status: $5"
    IntCmp $5 0 notap
    MessageBox MB_OK "An error occurred installing the TAP device driver."

 notap:

  ; Store install folder in registry
  WriteRegStr HKLM SOFTWARE\OpenVPN "" $INSTDIR

  ; install as a service if requested
  IntOp $R0 $R0 & ${SF_SELECTED}
  IntCmp $R0 ${SF_SELECTED} "" noserv noserv

    ; set registry parameters for openvpnserv	
    !insertmacro WriteRegStringIfUndef HKLM "SOFTWARE\OpenVPN" "config_dir"  "${SERV_CONFIG_DIR}"
    !insertmacro WriteRegStringIfUndef HKLM "SOFTWARE\OpenVPN" "config_ext"  "${SERV_CONFIG_EXT}"
    !insertmacro WriteRegStringIfUndef HKLM "SOFTWARE\OpenVPN" "exe_path"    "${SERV_EXE_PATH}"
    !insertmacro WriteRegStringIfUndef HKLM "SOFTWARE\OpenVPN" "log_dir"     "${SERV_LOG_DIR}"
    !insertmacro WriteRegStringIfUndef HKLM "SOFTWARE\OpenVPN" "priority"    "${SERV_PRIORITY}"
    !insertmacro WriteRegStringIfUndef HKLM "SOFTWARE\OpenVPN" "log_append"  "${SERV_LOG_APPEND}"

    ; install openvpnserv as a service
    DetailPrint "Previous Service REMOVE (if exists)"
    nsExec::ExecToLog '"$INSTDIR\bin\openvpnserv.exe" -remove'
    Pop $R0 # return value/error/timeout
    DetailPrint "Service INSTALL"
    nsExec::ExecToLog '"$INSTDIR\bin\openvpnserv.exe" -install'
    Pop $R0 # return value/error/timeout

 noserv:
  ; Store install folder in registry
  WriteRegStr HKLM SOFTWARE\OpenVPN-GUI "" $INSTDIR

  ; Set registry keys for openvpn-gui if gui is requested
  SectionGetFlags ${SecGUI} $R0
  IntOp $R0 $R0 & ${SF_SELECTED}
  IntCmp $R0 ${SF_SELECTED} "" nogui nogui

	; set registry parameters for openvpn-gui	
	!insertmacro WriteRegStringIfUndef HKLM "SOFTWARE\OpenVPN-GUI" "config_dir"      "${GUI_CONFIG_DIR}"
	!insertmacro WriteRegStringIfUndef HKLM "SOFTWARE\OpenVPN-GUI" "config_ext"      "${GUI_CONFIG_EXT}"
	!insertmacro WriteRegStringIfUndef HKLM "SOFTWARE\OpenVPN-GUI" "exe_path"        "${GUI_EXE_PATH}"
	!insertmacro WriteRegStringIfUndef HKLM "SOFTWARE\OpenVPN-GUI" "log_dir"         "${GUI_LOG_DIR}"
	!insertmacro WriteRegStringIfUndef HKLM "SOFTWARE\OpenVPN-GUI" "priority"        "${GUI_PRIORITY}"
	!insertmacro WriteRegStringIfUndef HKLM "SOFTWARE\OpenVPN-GUI" "log_append"      "${GUI_LOG_APPEND}"
	!insertmacro WriteRegStringIfUndef HKLM "SOFTWARE\OpenVPN-GUI" "allow_edit"      "${GUI_ALLOW_EDIT}"
	!insertmacro WriteRegStringIfUndef HKLM "SOFTWARE\OpenVPN-GUI" "allow_service"   "${GUI_ALLOW_SERVICE}"
	!insertmacro WriteRegStringIfUndef HKLM "SOFTWARE\OpenVPN-GUI" "allow_proxy"     "${GUI_ALLOW_PROXY}"
	!insertmacro WriteRegStringIfUndef HKLM "SOFTWARE\OpenVPN-GUI" "allow_password"  "${GUI_ALLOW_PASSWORD}"
	!insertmacro WriteRegStringIfUndef HKLM "SOFTWARE\OpenVPN-GUI" "service_only"    "${GUI_SERVICE_ONLY}"
	!insertmacro WriteRegStringIfUndef HKLM "SOFTWARE\OpenVPN-GUI" "log_viewer"      "${GUI_LOG_VIEWER}"
	!insertmacro WriteRegStringIfUndef HKLM "SOFTWARE\OpenVPN-GUI" "passphrase_attempts"   "${GUI_PSW_ATTEMPTS}"
	!insertmacro WriteRegStringIfUndef HKLM "SOFTWARE\OpenVPN-GUI" "editor"                "${GUI_EDITOR}"
	!insertmacro WriteRegStringIfUndef HKLM "SOFTWARE\OpenVPN-GUI" "connectscript_timeout" "${GUI_UP_TIMEOUT}"
	!insertmacro WriteRegStringIfUndef HKLM "SOFTWARE\OpenVPN-GUI" "disconnectscript_timeout" "${GUI_DOWN_TIMEOUT}"
	!insertmacro WriteRegStringIfUndef HKLM "SOFTWARE\OpenVPN-GUI" "preconnectscript_timeout" "${GUI_PRE_TIMEOUT}"
	!insertmacro WriteRegStringIfUndef HKLM "SOFTWARE\OpenVPN-GUI" "silent_connection"     "${GUI_SILENT_CONN}"
	!insertmacro WriteRegStringIfUndef HKLM "SOFTWARE\OpenVPN-GUI" "show_balloon"          "${GUI_SHOW_BALLOON}"
	!insertmacro WriteRegStringIfUndef HKLM "SOFTWARE\OpenVPN-GUI" "show_script_window"    "${GUI_SHOW_SCRIPT}"
	!insertmacro WriteRegStringIfUndef HKLM "SOFTWARE\OpenVPN-GUI" "disconnect_on_suspend" "${GUI_SUSPEND}"

  ; AutoStart OpenVPN GUI if requested
  SectionGetFlags ${SecGUIAuto} $R0
  IntOp $R0 $R0 & ${SF_SELECTED}
  IntCmp $R0 ${SF_SELECTED} "" nogui nogui

	; set registry parameters for openvpn-gui	
	WriteRegStr HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Run" "openvpn-gui"  "$INSTDIR\bin\openvpn-gui.exe"

 nogui:
  ; Store README, license, icon
  SetOverwrite on
  SetOutPath $INSTDIR
  File "${HOME}\openvpn.ico"

  ; Create file association if requested
  SectionGetFlags ${SecFileAssociation} $R0
  IntOp $R0 $R0 & ${SF_SELECTED}
  IntCmp $R0 ${SF_SELECTED} "" noshortcuts
    !insertmacro WriteRegStringIfUndef HKCR ".${SERV_CONFIG_EXT}" "" "OpenVPNFile"
    !insertmacro WriteRegStringIfUndef HKCR "OpenVPNFile" "" "OpenVPN Config File"
    !insertmacro WriteRegStringIfUndef HKCR "OpenVPNFile\shell" "" "open"
    !insertmacro WriteRegStringIfUndef HKCR "OpenVPNFile\DefaultIcon" "" "$INSTDIR\openvpn.ico,0"
    !insertmacro WriteRegStringIfUndef HKCR "OpenVPNFile\shell\open\command" "" 'notepad.exe "%1"'
    !insertmacro WriteRegStringIfUndef HKCR "OpenVPNFile\shell\run" "" "Start OpenVPN on this config file"
    !insertmacro WriteRegStringIfUndef HKCR "OpenVPNFile\shell\run\command" "" '"$INSTDIR\bin\openvpn.exe" --pause-exit --config "%1"'

 noshortcuts:
  ; Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"

  ; Show up in Add/Remove programs
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OpenVPN" "DisplayName" "OpenVPN ${VERSION}"
  WriteRegExpandStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OpenVPN" "UninstallString" "$INSTDIR\Uninstall.exe"

  ; Advise a reboot
  ;Messagebox MB_OK "IMPORTANT: Rebooting the system is advised in order to finalize TAP-Win32 driver installation/upgrade (this is an informational message only, pressing OK will not reboot)."

  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "DisplayIcon" "$INSTDIR\openvpn.ico"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "DisplayVersion" "${VERSION}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "Publisher" "American Electronics, Inc."

SectionEnd

;--------------------------------
;Descriptions

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SecOpenVPNUserSpace} $(DESC_SecOpenVPNUserSpace)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecGUI} $(DESC_SecGUI)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecGUIAuto} $(DESC_SecGUIAuto)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecTAP} $(DESC_SecTAP)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecOpenSSLDLLs} $(DESC_SecOpenSSLDLLs)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecAddPath} $(DESC_SecAddPath)
  !insertmacro MUI_DESCRIPTION_TEXT ${SecFileAssociation} $(DESC_SecFileAssociation)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

Function .onInit
   ${If} ${RunningX64}
        SetRegView 64
        StrCpy $INSTDIR "$PROGRAMFILES64\${PRODUCT_NAME}"
   ${EndIf}
  ClearErrors
  UserInfo::GetName
  IfErrors ok
  Pop $R0
  UserInfo::GetAccountType
  Pop $R1
  StrCmp $R1 "Admin" ok
    Messagebox MB_OK "Administrator privileges required to install OpenVPN [$R0/$R1]"
    Abort
  ok:

  Push $R0
  ReadRegStr $R0 HKLM SOFTWARE\OpenVPN-GUI ""
  StrCmp $R0 "" goon

    Messagebox MB_YESNO "It seems the package ${PRODUCT_NAME} (OpenVPN GUI) is already installed.$\r$\nWe recommend you to uninstall it in the standard way before proceeding. Continue installing?" IDYES goon
    Abort

  goon:
  Pop $R0

  Push $R0
  Push $R1
  FindWindow $R0 "openvpn-gui"
  IntCmp $R0 0 donerun

    Messagebox MB_YESNO|MB_ICONEXCLAMATION "OpenVPN GUI is currently running.$\r$\nUntil you terminate it, all files that belong to it cannot be updated.$\r$\nShall this program be killed now? If true, all existing connections will be closed." IDNO donerun

    SendMessage $R0 ${WM_DESTROY} 0 0 $R1 /TIMEOUT=7000
    IntCmp $R1 0 donerun

      Messagebox MB_OK|MB_ICONEXCLAMATION "Trouble terminating OpenVPN GUI, please close it and then click OK."

  donerun:
  Pop $R1
  Pop $R0

FunctionEnd

Function .onSelChange
  Push $0

  ;Check if Section OpenVPN GUI is selected.
  SectionGetFlags ${SecGUI} $0
  IntOp $0 $0 & ${SF_SELECTED}
  IntCmp $0 ${SF_SELECTED} "" noautogui noautogui

  ;GUI was selected so set GUIAuto to Not-ReadOnly.
  SectionGetFlags ${SecGUIAuto} $0
  IntOp $0 $0 & ${SF_NOT_RO}
  SectionSetFlags ${SecGUIAuto} $0
  goto CheckTAP

  noautogui:
  SectionSetFlags ${SecGUIAuto} ${SF_RO}


  CheckTAP:
  ;Check if Section Install-TAP is selected.
  SectionGetFlags ${SecTAP} $0
  IntOp $0 $0 & ${SF_SELECTED}
  IntCmp $0 ${SF_SELECTED} "" notap notap

  ;TAP was selected so set TAPHidden to Not-ReadOnly.
  IntOp $0 $0 & ${SF_NOT_RO}
  goto end

  notap:

  end:
  Pop $0

FunctionEnd

Function .onInstSuccess
  IfFileExists "$INSTDIR\bin\openvpn-gui.exe" "" nogui
    ExecShell open "$INSTDIR\bin\openvpn-gui.exe"
  nogui:

FunctionEnd

;--------------------------------
;Uninstaller Section

Function un.onInit
  ${If} ${RunningX64}
        SetRegView 64
        StrCpy $INSTDIR "$PROGRAMFILES64\${PRODUCT_NAME}"
  ${EndIf}
  ClearErrors
  UserInfo::GetName
  IfErrors ok
  Pop $R0
  UserInfo::GetAccountType
  Pop $R1
  StrCmp $R1 "Admin" ok
    Messagebox MB_OK "Administrator privileges required to uninstall OpenVPN [$R0/$R1]"
    Abort
  ok:
  Push $R0
  Push $R1
  FindWindow $R0 "openvpn-gui"
  IntCmp $R0 0 donerun

    Messagebox MB_YESNO|MB_ICONEXCLAMATION "OpenVPN GUI is currently running.$\r$\nUntil you terminate it, all files that belong to it cannot be removed.$\r$\nShall this program be killed now? If true, all existing connections will be closed." IDNO donerun

    SendMessage $R0 ${WM_DESTROY} 0 0 $R1 /TIMEOUT=7000
    IntCmp $R1 0 donerun

      Messagebox MB_OK|MB_ICONEXCLAMATION "Trouble terminating OpenVPN GUI, please close it and then click OK."

  donerun:
  Pop $R1
  Pop $R0


FunctionEnd

Section "Uninstall"

  DetailPrint "Service REMOVE"
  nsExec::ExecToLog '"$INSTDIR\bin\openvpnserv.exe" -remove'
  Pop $R0 # return value/error/timeout

  Sleep 2000

  DetailPrint "TAP REMOVE"
  nsExec::ExecToLog '"$INSTDIR\bin\devcon.exe" remove ${TAP}'
  Pop $R0 # return value/error/timeout
  DetailPrint "devcon remove returned: $R0"

  Push "$INSTDIR\bin"
  Call un.RemoveFromPath

  RMDir /r $SMPROGRAMS\OpenVPN

  Delete "$INSTDIR\bin\openvpn.exe"
  Delete "$INSTDIR\bin\openvpnserv.exe"
  Delete "$INSTDIR\bin\openvpn-gui.exe"
  Delete "$INSTDIR\bin\libeay32.dll"
  Delete "$INSTDIR\bin\ssleay32.dll"
  Delete "$INSTDIR\bin\liblzo2-2.dll"
  Delete "$INSTDIR\bin\libpkcs11-helper-1.dll"
  Delete "$INSTDIR\bin\tapinstall.exe"
  Delete "$INSTDIR\bin\mycert.exe"
  Delete "$INSTDIR\bin\mycert.ini"
  Delete "$INSTDIR\bin\devcon.exe"

  Delete "$INSTDIR\config\README.txt"
  Delete "$INSTDIR\config\sample.${SERV_CONFIG_EXT}.txt"

  Delete "$INSTDIR\log\README.txt"

  Delete "$INSTDIR\driver\OemVista.inf"
  Delete "$INSTDIR\driver\${TAPDRV}"
  Delete "$INSTDIR\driver\${TAPCAT}"

  Delete "$INSTDIR\bin\openssl.exe"

  Delete "$INSTDIR\${SOURCE_ZIP_DEST}"
  Delete "$INSTDIR\${GUI_SOURCE_ZIP_DEST}"
  Delete "$INSTDIR\OpenVPN GUI ReadMe.txt"
  Delete "$INSTDIR\INSTALL-win32.txt"
  Delete "$INSTDIR\openvpn.ico"
  Delete "$INSTDIR\license.txt"
  Delete "$INSTDIR\Uninstall.exe"

  Delete "$INSTDIR\easy-rsa\openssl.cnf.sample"
  Delete "$INSTDIR\easy-rsa\vars.bat.sample"
  Delete "$INSTDIR\easy-rsa\init-config.bat"
  Delete "$INSTDIR\easy-rsa\README.txt"
  Delete "$INSTDIR\easy-rsa\build-ca.bat"
  Delete "$INSTDIR\easy-rsa\build-dh.bat"
  Delete "$INSTDIR\easy-rsa\build-key-server.bat"
  Delete "$INSTDIR\easy-rsa\build-key.bat"
  Delete "$INSTDIR\easy-rsa\clean-all.bat"
  Delete "$INSTDIR\easy-rsa\index.txt.start"
  Delete "$INSTDIR\easy-rsa\revoke-key.bat"
  Delete "$INSTDIR\easy-rsa\serial.start"

  Delete "$INSTDIR\sample-config\*.ovpn"
  Delete "$INSTDIR\log\*.log"

  RMDir "$INSTDIR\bin"
  RMDir "$INSTDIR\driver"
  RMDir "$INSTDIR\easy-rsa"
  RMDir "$INSTDIR\sample-config"
  RMDir "$INSTDIR\log"
  RMDir "$INSTDIR"

  !insertmacro DelRegKeyIfUnchanged HKCR ".${SERV_CONFIG_EXT}" "OpenVPNFile"
  DeleteRegKey HKCR "OpenVPNFile"
  DeleteRegKey HKLM SOFTWARE\OpenVPN
  DeleteRegKey HKLM SOFTWARE\OpenVPN-GUI
  DeleteRegKey HKCU "Software\${PRODUCT_NAME}"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OpenVPN"
  DeleteRegValue HKLM "Software\Microsoft\Windows\CurrentVersion\Run" "openvpn-gui"
  DeleteRegValue HKCU "Software\Microsoft\Windows\CurrentVersion\Run" "openvpn-gui"

SectionEnd
