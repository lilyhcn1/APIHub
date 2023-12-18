#NoEnv
#Persistent
SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Screen

; ����Ҫ���Ľ�����
ProcessName := "python38.exe"

; ����Ҫ���е�Python�ű�·��
PythonScript = "%A_ScriptDir%\soft\����uvicorn.bat"

hidescript = "%A_ScriptDir%\soft\nircmd����uvicorn.bat"
;hidescript = "%A_ScriptDir%\soft\����uvicorn.bat"
; ��������ͼ��
Menu, Tray, NoStandard ; �Ƴ�ԭ�в˵�
Menu, Tray, Icon, soft\w.ico

Menu, Tray, Add, ����ҳ, GetLocalIPAddressWithPort
Menu, Tray, Add, ��ʾ��ҳ��ά��, qrcodeweb
Menu, Tray, Add
Menu, Tray, Add, �޸���ҳ, modifyindex
Menu, Tray, Add, Excel�޸���ҳ, excelmodifyindex

Menu, Tray, Add
;Menu, Tray, Add, ����python��, updatepython
Menu, Tray, Add, ���з�����, RunScript
Menu, Tray, Add, ���Է�����, TestScript
Menu, Tray, Add, ��������, Runstartup
Menu, Tray, Add, �رղ��˳�������, ExitScript
OnMessage(0x200, "ShowMenu")

hasRun := 0
if (hasRun = 0) {
    hasRun := 1
    goipport()
    goto CheckProcess

}

; �����������������
aa:
; ���������ֻ���״�����ʱ���õĴ���
return

; ���ö�ʱ����ÿ��һ��ʱ��������Ƿ����
SetTimer, CheckProcess, 10000

return

modifyindex:
    run, notepad.exe templates\index.html
return
updatepython:
    run, soft\py38-��װpython����.bat
return


excelmodifyindex:
    run, notepad.exe templates\��ַ����.xlsm
return

CheckProcess:

    ; �������Ƿ����
    If !ProcessExist(ProcessName)
    {
        ; ����Python�ű�
        Run, %hidescript%,, Min
    }
return
TestScript:

    Run, "%PythonScript%"
return 


RunScript:
    ; ����Python�ű�
    Run, "%hidescript%",, Min
return

ExitScript:
    RunWait, taskkill /F /IM python38.exe, , Hide
    RunWait, taskkill /F /IM nircmd.exe, , Hide
    RunWait, taskkill /F /IM cmd.exe, , Hide
    ExitApp
    
 
GetLocalIPAddressWithPort:
goipport()

return
qrcodeweb:
    ipAddress := GetLocalIP()
    if(ipAddress!=0){
            address := ipAddress ":5034"
            ; �򿪵�ַ
            Run, % "cmd /c start https://cli.im/api/qrcode/code?text=" address
    } else {
            MsgBox, ����û�ҵ����IP��ַ�����Լ����ұ���IP������˿� 5034.
    }

return
Runstartup:
    CreateShortcutToStartup()
    OpenStartupFolder()
return 

;-------------------------------------------------------
 
ShowMenu() {
    Menu, Tray, Show
}
ProcessExist(ProcessName)
{
    Process, Exist, %ProcessName%
    return ErrorLevel
}

GetLocalIP(){

    ipconfigCmd := "ipconfig /all"

    ; ����һ����ʱ�ļ����洢ipconfig���
    filePath := A_ScriptDir . "\ipconfig_output.txt"

    ; ִ��ipconfig��������д����ʱ�ļ�
    RunWait, cmd /c %ipconfigCmd% > "%filePath%", , Hide

    ; ��ȡipconfig����ļ�
    FileRead, fileContent, %filePath%
	FileDelete, %filePath% ; ɾ����ʱ�ļ�

    pattern := ".*IPv4.*192\.168.*" ; ƥ��ͬʱ���� "IPv4" �� "192.168" ����
    matches := RegExMatch(fileContent, pattern)

    if (matches){
        ipPattern := "192\.168\.\d{1,3}\.\d{1,3}" ; ƥ����192.168��ͷ��IP��ַ
        RegExMatch(fileContent, ipPattern, IP) ; ��ȡIP��ַ
        return  IP
    }else{
        return "127.0.0.1"
    }

}
goipport(){
    ipAddress := GetLocalIP()
    if(ipAddress!=0){
            address := ipAddress ":5034"
            ; �򿪵�ַ
            Run, % "cmd /c start http://" address, , min
    } else {
            MsgBox, ����û�ҵ����IP��ַ�����Լ����ұ���IP������˿� 5034.
    }   
}

CreateShortcutToStartup()
{


    ; ��ȡ��ǰ���нű����ļ���
    scriptName := A_ScriptName
    ; ��ȡ�޺�׺�ļ���
    scriptNameWithoutExt := SubStr(scriptName, 1, InStr(scriptName, ".") - 1)

    ; ��ȡ��ǰ���нű��Ĺ���Ŀ¼
    workingDir := A_WorkingDir
    ProcessPath :=  workingDir "\" scriptNameWithoutExt ".exe"
    if (ProcessPath != "")
    {
        startupFolder := A_Startup
        shortcutPath := startupFolder . "\" scriptNameWithoutExt ".lnk"

        ; ������ݷ�ʽ
        CreateShortcut(ProcessPath, shortcutPath)
    }
}

OpenStartupFolder()
{
    startupFolder := A_Startup

    ; �򿪿��������ļ���
    Run, % "explorer.exe " . startupFolder
}

CreateShortcut(targetPath, shortcutPath)
{
    shell := ComObjCreate("WScript.Shell")
    shortcut := shell.CreateShortcut(shortcutPath)
    shortcut.TargetPath := targetPath
    shortcut.Save()
}

