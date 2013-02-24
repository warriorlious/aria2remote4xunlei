; Script generated by the HM NIS Edit Script Wizard.

; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "Aria2 Downloader"
!define PRODUCT_VERSION "0.1.1"
!define PRODUCT_PUBLISHER "Julian"
!define PRODUCT_WEB_SITE "http://sourceforge.net/projects/aria2cremote/develop"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\Aria2cRemoteControl.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
!define PRODUCT_STARTUP_RUN_KEY "Software\Microsoft\Windows\CurrentVersion\Run"

SetCompressor /SOLID lzma

; MUI 1.67 compatible ------
!include "MUI.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "..\icon\install.ico"
!define MUI_UNICON "..\icon\uninstall.ico"

; Language Selection Dialog Settings
!define MUI_LANGDLL_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!define MUI_LANGDLL_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_LANGDLL_REGISTRY_VALUENAME "NSIS:Language"

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; License page
!insertmacro MUI_PAGE_LICENSE "license.txt"
; Directory page
!insertmacro MUI_PAGE_DIRECTORY
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!define MUI_FINISHPAGE_RUN "$INSTDIR\Aria2cRemoteControl.exe"
!define MUI_FINISHPAGE_SHOWREADME "$INSTDIR\license.txt"
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "Hungarian"

; Reserve files
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS

; MUI end ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "Aria2cRemoteControlSetup.exe"
InstallDir "$PROGRAMFILES\${PRODUCT_NAME}"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails show
ShowUnInstDetails show

RequestExecutionLevel admin

Function .onInit
UserInfo::GetAccountType
pop $0
${If} $0 != "admin" ;Require admin rights on NT4+
    MessageBox mb_iconstop "Administrator rights required!"
    SetErrorLevel 740 ;ERROR_ELEVATION_REQUIRED
    Quit
${EndIf}
  !insertmacro MUI_LANGDLL_DISPLAY
FunctionEnd

Section "MainSection" SEC01
  SetOverwrite ifnewer
  CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME}"
 
  SetOutPath "$INSTDIR"
  File "QtNetwork4.dll"
  File "QtGui4.dll"
  File "QtCore4.dll"
  File "mingwm10.dll"
  File "license.txt"
  File "libgcc_s_dw2-1.dll"
  File "Aria2cRemoteControl.exe"
  File "QtXml4.dll"
  File "aria2c.exe"
  File "ServiceEx.exe"
  File "Aria2Deamon.ini"
  
  CreateDirectory "$INSTDIR\imageformats"
  SetOutPath "$INSTDIR\imageformats"
  File "imageformats\qmng4.dll"
  
  ;Languages files
  CreateDirectory "$INSTDIR\languages"
  SetOutPath "$INSTDIR\languages"
  File "languages\Aria2cRemoteControl_hu.qm"
  File "languages\Aria2cRemoteControl_en.qm"

  ;GeoIP dat file
  CreateDirectory "$APPDATA\${PRODUCT_NAME}"
  SetOutPath "$APPDATA\${PRODUCT_NAME}"
  File "GeoIP.dat"
  
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk" "$INSTDIR\Aria2cRemoteControl.exe"
  CreateShortCut "$DESKTOP\${PRODUCT_NAME}.lnk" "$INSTDIR\Aria2cRemoteControl.exe"
SectionEnd

Section -AdditionalIcons
  WriteIniStr "$INSTDIR\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\Website.lnk" "$INSTDIR\${PRODUCT_NAME}.url"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\Uninstall.lnk" "$INSTDIR\uninst.exe"
SectionEnd

;WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_STARTUP_RUN_KEY}" "Aria2" "$INSTDIR\aria2c.exe --enable-rpc=true --rpc-listen-all=true --dir=$PROFILE\Downloads"
Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\Aria2cRemoteControl.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\Aria2cRemoteControl.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
  
  FileOpen $0 $INSTDIR\Aria2Deamon.ini w
  FileWrite $0 "[ServiceEx]"
  FileWrite $0 "$\r$\n"
  FileWrite $0 "ServiceExeFullPath=$INSTDIR\aria2c.exe"
  FileWrite $0 "$\r$\n"
  FileWrite $0 'options ="--enable-rpc=true --rpc-listen-all=true --dir=$PROFILE\Downloads"'
  FileWrite $0 "$\r$\n"
  FileWrite $0 "desktop = false"
  FileWrite $0 "$\r$\n"
  FileWrite $0 "Start=Auto"
  FileWrite $0 "$\r$\n"
  FileWrite $0 "StartNow=true"
  Exec '"$INSTDIR\ServiceEx.exe" install Aria2Deamon'
SectionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "Ariac2 Downloader was successfully removed."
FunctionEnd

Function un.onInit
!insertmacro MUI_UNGETLANGUAGE
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Do you want to uninstall Ariac2 Downloader?" IDYES +2
  Abort
FunctionEnd

Section Uninstall
;Stop Aria2Deamon Service and remove service
  Exec "net stop Aria2Deamon"
  Exec '"$INSTDIR\ServiceEx.exe" remove Aria2Deamon'
  
  Delete "$INSTDIR\${PRODUCT_NAME}.url"
  Delete "$INSTDIR\uninst.exe"
  Delete "$INSTDIR\imageformats\qmng4.dll"
  Delete "$INSTDIR\languages\Aria2cRemoteControl_hu.qm"
  Delete "$INSTDIR\languages\Aria2cRemoteControl_en.qm"
  Delete "$INSTDIR\QtXml4.dll"
  Delete "$INSTDIR\Aria2cRemoteControl.exe"
  Delete "$APPDATA\${PRODUCT_NAME}\configuration.xml"
  Delete "$APPDATA\${PRODUCT_NAME}\GeoIP.dat"
  Delete "$INSTDIR\libgcc_s_dw2-1.dll"
  Delete "$INSTDIR\license.txt"
  Delete "$INSTDIR\mingwm10.dll"
  Delete "$INSTDIR\QtCore4.dll"
  Delete "$INSTDIR\QtGui4.dll"
  Delete "$INSTDIR\QtNetwork4.dll"
  Delete "$INSTDIR\aria2c.exe"
  Delete "$INSTDIR\ServiceEx.exe"
  Delete "$INSTDIR\Aria2Deamon.ini"

  Delete "$SMPROGRAMS\${PRODUCT_NAME}\Uninstall.lnk"
  Delete "$SMPROGRAMS\${PRODUCT_NAME}\Website.lnk"
  Delete "$DESKTOP\${PRODUCT_NAME}.lnk"
  Delete "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk"

  RMDir "$APPDATA\${PRODUCT_NAME}"
  RMDir "$INSTDIR\imageformats"
  RMDir "$INSTDIR\languages"
  RMDir "$SMPROGRAMS\${PRODUCT_NAME}"
  RMDir "$INSTDIR"
  
  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  DeleteRegValue HKLM "Software\Microsoft\Windows\CurrentVersion\Run" "Aria2"
  SetAutoClose true
SectionEnd