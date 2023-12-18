#NoEnv
#Persistent
SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Screen

; 定义要监测的进程名
ProcessName := "python38.exe"

; 定义要运行的Python脚本路径
PythonScript = "%A_ScriptDir%\soft\启动uvicorn.bat"

hidescript = "%A_ScriptDir%\soft\nircmd启动uvicorn.bat"
;hidescript = "%A_ScriptDir%\soft\启动uvicorn.bat"
; 创建托盘图标
Menu, Tray, NoStandard ; 移除原有菜单
Menu, Tray, Icon, soft\w.ico

Menu, Tray, Add, 打开网页, GetLocalIPAddressWithPort
Menu, Tray, Add, 显示网页二维码, qrcodeweb
Menu, Tray, Add
Menu, Tray, Add, 修改网页, modifyindex
Menu, Tray, Add, Excel修改网页, excelmodifyindex

Menu, Tray, Add
;Menu, Tray, Add, 更新python库, updatepython
Menu, Tray, Add, 运行服务器, RunScript
Menu, Tray, Add, 调试服务器, TestScript
Menu, Tray, Add, 开机启动, Runstartup
Menu, Tray, Add, 关闭并退出服务器, ExitScript
OnMessage(0x200, "ShowMenu")

hasRun := 0
if (hasRun = 0) {
    hasRun := 1
    goipport()
    goto CheckProcess

}

; 在这里放置其他代码
aa:
; 在这里放置只在首次运行时调用的代码
return

; 设置定时器，每隔一段时间检查进程是否存在
SetTimer, CheckProcess, 10000

return

modifyindex:
    run, notepad.exe templates\index.html
return
updatepython:
    run, soft\py38-安装python环境.bat
return


excelmodifyindex:
    run, notepad.exe templates\网址生成.xlsm
return

CheckProcess:

    ; 检查进程是否存在
    If !ProcessExist(ProcessName)
    {
        ; 运行Python脚本
        Run, %hidescript%,, Min
    }
return
TestScript:

    Run, "%PythonScript%"
return 


RunScript:
    ; 运行Python脚本
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
            ; 打开地址
            Run, % "cmd /c start https://cli.im/api/qrcode/code?text=" address
    } else {
            MsgBox, 程序没找到你的IP地址，请自己查找本地IP，服务端口 5034.
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

    ; 创建一个临时文件来存储ipconfig输出
    filePath := A_ScriptDir . "\ipconfig_output.txt"

    ; 执行ipconfig命令并将输出写入临时文件
    RunWait, cmd /c %ipconfigCmd% > "%filePath%", , Hide

    ; 读取ipconfig输出文件
    FileRead, fileContent, %filePath%
	FileDelete, %filePath% ; 删除临时文件

    pattern := ".*IPv4.*192\.168.*" ; 匹配同时包含 "IPv4" 和 "192.168" 的行
    matches := RegExMatch(fileContent, pattern)

    if (matches){
        ipPattern := "192\.168\.\d{1,3}\.\d{1,3}" ; 匹配以192.168开头的IP地址
        RegExMatch(fileContent, ipPattern, IP) ; 提取IP地址
        return  IP
    }else{
        return "127.0.0.1"
    }

}
goipport(){
    ipAddress := GetLocalIP()
    if(ipAddress!=0){
            address := ipAddress ":5034"
            ; 打开地址
            Run, % "cmd /c start http://" address, , min
    } else {
            MsgBox, 程序没找到你的IP地址，请自己查找本地IP，服务端口 5034.
    }   
}

CreateShortcutToStartup()
{


    ; 获取当前运行脚本的文件名
    scriptName := A_ScriptName
    ; 提取无后缀文件名
    scriptNameWithoutExt := SubStr(scriptName, 1, InStr(scriptName, ".") - 1)

    ; 获取当前运行脚本的工作目录
    workingDir := A_WorkingDir
    ProcessPath :=  workingDir "\" scriptNameWithoutExt ".exe"
    if (ProcessPath != "")
    {
        startupFolder := A_Startup
        shortcutPath := startupFolder . "\" scriptNameWithoutExt ".lnk"

        ; 创建快捷方式
        CreateShortcut(ProcessPath, shortcutPath)
    }
}

OpenStartupFolder()
{
    startupFolder := A_Startup

    ; 打开开机启动文件夹
    Run, % "explorer.exe " . startupFolder
}

CreateShortcut(targetPath, shortcutPath)
{
    shell := ComObjCreate("WScript.Shell")
    shortcut := shell.CreateShortcut(shortcutPath)
    shortcut.TargetPath := targetPath
    shortcut.Save()
}

