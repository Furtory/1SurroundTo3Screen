管理员模式:
    IfExist, %A_ScriptDir%\Settings.ini ;如果配置文件存在则读取
    {
        IniRead AdminMode, Settings.ini, 设置, 管理权限
        if (AdminMode=1)
        {
            ShellExecute := A_IsUnicode ? "shell32\ShellExecute":"shell32\ShellExecuteA"

            if not A_IsAdmin
            {
                If A_IsCompiled
                    DllCall(ShellExecute, uint, 0, str, "RunAs", str, A_ScriptFullPath, str, params , str, A_WorkingDir, int, 1)
                Else
                    DllCall(ShellExecute, uint, 0, str, "RunAs", str, A_AhkPath, str, """" . A_ScriptFullPath . """" . A_Space . params, str, A_WorkingDir, int, 1)
                ExitApp
            }
        }
    }

    Menu Tray, Icon, %A_ScriptDir%\Running.ico ;任务栏图标改成正在运行
    Process Priority, , Realtime
    #MenuMaskKey vkE8
    #WinActivateForce
    #InstallKeybdHook
    #InstallMouseHook
    #Persistent
    #NoEnv
    #SingleInstance Force
    #MaxHotkeysPerInterval 2000
    #KeyHistory 2000
    Gui +HWNDhGui
    Global hPic
    CoordMode Pixel, Screen
    CoordMode ToolTip, Screen
    SetBatchLines -1
    SetWinDelay 10
    SetKeyDelay -1, 30
    SetWorkingDir %A_ScriptDir%
    OnExit 退出软件

    /*
    黑钨重工出品 免费开源 请勿商用 侵权必究
    在线logo转换 https://convertio.co/zh/
    更多免费教程尽在QQ群 1群763625227 2群643763519
    */

    MButton_presses:=0
    running:=1 ;1为运行 0为暂停
    Menu Tray, NoStandard ;不显示默认的AHK右键菜单
    Menu Tray, Add, 基础功能, 基础功能 ;添加新的右键菜单
    Menu Tray, Add, 进阶功能, 进阶功能 ;添加新的右键菜单
    Menu Tray, Add, 兼容说明, 兼容说明 ;添加新的右键菜单
    Menu Tray, Add
    Menu Tray, Add, 屏幕设置, 屏幕设置 ;添加新的右键菜单
    Menu Tray, Add, 开机自启, 开机自启 ;添加新的右键菜单
    Menu Tray, Add, 管理权限, 管理权限 ;添加新的右键菜单
    Menu Tray, Add, 兼容模式, 兼容模式 ;添加新的右键菜单
    Menu Tray, Add, 锐化算法, 锐化算法 ;添加新的右键菜单
    Menu Tray, Add, 顶置轮切, 顶置轮切 ;添加新的右键菜单
    Menu Tray, Add
    Menu Tray, Add, 窗口找回, 窗口找回 ;添加新的右键菜单
    Menu Tray, Add, 媒体快捷, 媒体快捷 ;添加新的右键菜单
    Menu Tray, Add, 自动暂停, 自动暂停 ;添加新的右键菜单
    Menu Tray, Add, 神隐窗口, 神隐窗口 ;添加新的右键菜单
    Menu Tray, Add, 飘逸窗口, 飘逸窗口 ;添加新的右键菜单
    Menu Tray, Add, 标签页适配, 标签页适配 ;添加新的右键菜单
    Menu Tray, Add
    Menu Tray, Add, 新增白名单, 新增白名单 ;添加新的右键菜单
    Menu Tray, Add, 白名单设置, 白名单设置 ;添加新的右键菜单
    Menu Tray, Add
    Menu Tray, Add, 新增黑名单, 新增黑名单 ;添加新的右键菜单
    Menu Tray, Add, 黑名单设置, 黑名单设置 ;添加新的右键菜单
    Menu Tray, Add
    Menu Tray, Add, 初始化记录, 初始化记录 ;添加新的右键菜单
    Menu Tray, Add, 高效模式, 高效模式 ;添加新的右键菜单
    Menu Tray, Add, 暂停运行, 暂停运行 ;添加新的右键菜单
    Menu Tray, Add, 重启软件, 重启软件 ;添加新的右键菜单
    Menu Tray, Add, 退出软件, 退出软件 ;添加新的右键菜单

    autostartLnk:=A_StartupCommon . "\SurroundHelper.lnk" ;开机启动文件的路径
    IfExist, % autostartLnk ;检查开机启动的文件是否存在
    {
        autostart:=1
        Menu Tray, Check, 开机自启 ;右键菜单打勾
    }
    else
    {
        autostart:=0
        Menu Tray, UnCheck, 开机自启 ;右键菜单不打勾
    }

    IfExist, %A_ScriptDir%\Settings.ini ;如果配置文件存在则读取
    {
        IniRead antialize, Settings.ini, 设置, 锐化算法 ;从ini文件读取设置
        if (antialize=1)
        {
            Menu Tray, UnCheck, 锐化算法 ;右键菜单不打勾
            DllCall("gdi32.dll\SetStretchBltMode", "uint", hdc_frame, "int", 4*antialize )
        }
        else
        {
            Menu Tray, Check, 锐化算法 ;右键菜单打勾
            DllCall("gdi32.dll\SetStretchBltMode", "uint", hdc_frame, "int", 4*antialize )
        }

        IniRead CompatibleMode, Settings.ini, 设置, 兼容模式
        if (CompatibleMode=0)
        {
            Menu Tray, UnCheck, 兼容模式 ;右键菜单不打勾
        }
        else
        {
            Menu Tray, Check, 兼容模式 ;右键菜单打勾
        }

        IniRead ExtraHeightFit, Settings.ini, 设置, 标签页适配
        if (ExtraHeightFit=0)
        {
            ExtraHeight:=0
            Menu Tray, UnCheck, 标签页适配 ;右键菜单不打勾
        }
        else
        {
            IniRead ExtraHeight, Settings.ini, 设置, 标签页适配高度
            Menu Tray, Check, 标签页适配 ;右键菜单打勾
        }

        IniRead 高效模式, Settings.ini, 设置, 高效模式
        if (高效模式=0)
        {
            Menu Tray, UnCheck, 高效模式 ;右键菜单不打勾
        }
        else
        {
            Menu Tray, Check, 高效模式 ;右键菜单打勾
        }

        IniRead AdminMode, Settings.ini, 设置, 管理权限 ;从ini文件读取设置
        if (AdminMode=0)
        {
            Menu Tray, UnCheck, 管理权限 ;右键菜单不打勾
        }
        else
        {
            Menu Tray, Check, 管理权限 ;右键菜单打勾
        }

        IniRead MiniWinIDL, Settings.ini, 设置, 左边屏幕最近一次被最小化的窗口 ;从ini文件读取设置
        IniRead MiniWinIDM, Settings.ini, 设置, 中间屏幕最近一次被最小化的窗口 ;从ini文件读取设置
        IniRead MiniWinIDR, Settings.ini, 设置, 右边屏幕最近一次被最小化的窗口 ;从ini文件读取设置

        IniRead MasterWinIDL, Settings.ini, 设置, 左边屏幕主窗口 ;写入设置到ini文件
        IniRead MasterWinIDM, Settings.ini, 设置, 中间屏幕主窗口 ;写入设置到ini文件
        IniRead MasterWinIDR, Settings.ini, 设置, 右边屏幕主窗口 ;写入设置到ini文件

        IniRead ActiveWindowID, Settings.ini, 设置, 后台等待激活的窗口 ;从ini文件读取设置

        IniRead WinTopSetting, Settings.ini, 设置, 主动顶置窗口 ;从ini文件读取设置
        ; MsgBox % WinTopSetting
        if (WinTopSetting!="")
        {
            if (InStr(WinTopSetting, "|")!=0)
            {
                WinActiveTop:=StrSplit(WinTopSetting, "|") ;将字符串分割成数组
            }
            else
            {
                WinActiveTop:=[]
                WinActiveTop.Push(WinTopSetting)
            }
        }
        else
        {
            WinActiveTop:=[]
        }

        WinTopSetting:=""
        loop % WinActiveTop.Length()
        {
            if (A_Index<WinActiveTop.Length())
                WinTopSetting.=WinActiveTop[A_Index] . "|"
            else
                WinTopSetting.=WinActiveTop[A_Index]
        }
        ; MsgBox % WinTopSetting

        IniRead WhiteList, Settings.ini, Settings, 白名单列表 ;从ini文件读取

        IniRead BlackList, Settings.ini, 设置, 黑名单列表 ;从ini文件读取设置

        IniRead BlackListWindow_AutoStop, Settings.ini, 设置, 自动暂停黑名单 ;从ini文件读取设置
        if (BlackListWindow_AutoStop!="") and (BlackListWindow_AutoStop!="ERROR")
            Menu Tray, Check, 自动暂停

        IniRead MediaWindow, Settings.ini, 设置, 呼出播放器 ;从ini文件读取设置
        IniRead AutoHideWindow, Settings.ini, 设置, 神隐窗口 ;写入设置到ini文件
        if (AutoHideWindow!="") and (AutoHideWindow!="ERROR")
        {
            Menu Tray, Check, 神隐窗口
            WinSet AlwaysOnTop, On, ahk_class %AutoHideWindow%  ;切换窗口的顶置状态
        }

        IniRead AutoMoveWindow, Settings.ini, 设置, 飘逸窗口 ;写入设置到ini文件
        if (AutoMoveWindow!="") and (AutoMoveWindow!="ERROR")
        {
            Menu Tray, Check, 飘逸窗口
        }

        IniRead TabSwitch, Settings.ini, 设置, 顶置轮切 ;写入设置到ini文件
        if (TabSwitch!="") and (TabSwitch!="ERROR") and (TabSwitch=1)
        {
            Menu Tray, Check, 顶置轮切
        }

        IniRead 上组合键, Settings.ini, 设置, 双击箭头上输出组合键 ;从ini文件读取设置
        IniRead 下组合键, Settings.ini, 设置, 双击箭头下输出组合键 ;

        IniRead BKXZ, Settings.ini, 设置, 边框修正 ;写入设置到ini文件

        IniRead KDXZ, Settings.ini, 设置, 宽度修正 ;写入设置到ini文件
        IniRead GDXZ, Settings.ini, 设置, 高度修正 ;写入设置到ini文件

        IniRead 左边快捷呼出窗口, Settings.ini, 设置, 左边快捷呼出窗口 ;写入设置到ini文件
        IniRead 右边快捷呼出窗口, Settings.ini, 设置, 右边快捷呼出窗口 ;写入设置到ini文件
    }
    else ;如果配置文件不存在则新建
    {
        antialize:=1
        IniWrite %antialize%, Settings.ini, 设置, 锐化算法 ;写入设置到ini文件
        Menu Tray, Check, 锐化算法 ;右键菜单打勾

        CompatibleMode:=0
        IniWrite %CompatibleMode%, Settings.ini, 设置, 兼容模式 ;写入设置到ini文件

        ExtraHeightFit:=0
        ExtraHeight:=Round(A_ScreenHeight*(25/1080))
        IniWrite %ExtraHeightFit%, Settings.ini, 设置, ExtraHeightFit ;写入设置到ini文件
        IniWrite %ExtraHeight%, Settings.ini, 设置, ExtraHeight ;写入设置到ini文件

        高效模式:=1
        IniWrite %高效模式%, Settings.ini, 设置, 高效模式 ;写入设置到ini文件
        Menu Tray, Check, 高效模式 ;右键菜单打勾

        AdminMode:=0
        IniWrite %AdminMode%, Settings.ini, 设置, 管理权限 ;写入设置到ini文件

        MiniWinIDL:=0
        MiniWinIDM:=0
        MiniWinIDR:=0
        IniWrite %MiniWinIDL%, Settings.ini, 设置, 左边屏幕最近一次被最小化的窗口 ;写入设置到ini文件
        IniWrite %MiniWinIDM%, Settings.ini, 设置, 中间屏幕最近一次被最小化的窗口 ;写入设置到ini文件
        IniWrite %MiniWinIDR%, Settings.ini, 设置, 右边屏幕最近一次被最小化的窗口 ;写入设置到ini文件

        MasterWinIDL:=0
        MasterWinIDM:=0
        MasterWinIDR:=0
        IniWrite %MasterWinIDL%, Settings.ini, 设置, 左边屏幕主窗口 ;写入设置到ini文件
        IniWrite %MasterWinIDM%, Settings.ini, 设置, 中间屏幕主窗口 ;写入设置到ini文件
        IniWrite %MasterWinIDR%, Settings.ini, 设置, 右边屏幕主窗口 ;写入设置到ini文件

        ActiveWindowID:=""
        IniWrite %ActiveWindowID%, Settings.ini, 设置, 后台等待激活的窗口 ;写入设置到ini文件

        WinActiveTop:=""
        IniWrite %WinActiveTop%, Settings.ini, 设置, 主动顶置窗口 ;写入设置到ini文件
        WinActiveTop:=[]

        BlackList:="Same Class===ActualTools_MultiMonitorTaskbar|Same Class===DesktopLyrics|Same Class===WorkerW"
        IniWrite %BlackList%, Settings.ini, 设置, 黑名单列表 ;写入设置到ini文件

        WhiteList:="Same Exe===Code.exe|Same Exe===Notepad--.exe"
        IniRead WhiteList, Settings.ini, Settings, 白名单列表 ;从ini文件读取

        BlackListWindow_AutoStop:=""
        IniWrite %BlackListWindow_AutoStop%, Settings.ini, 设置, 自动暂停黑名单 ;写入设置到ini文件

        MediaWindow:=""
        IniWrite %MediaWindow%, Settings.ini, 设置, 呼出播放器 ;写入设置到ini文件

        IniWrite %上组合键%, Settings.ini, 设置, 双击箭头上输出组合键 ;写入设置到ini文件
        IniWrite %下组合键%, Settings.ini, 设置, 双击箭头下输出组合键 ;写入设置到ini文件

        BKXZ:=0
        IniWrite %BKXZ%, Settings.ini, 设置, 边框修正 ;写入设置到ini文件

        KDXZ:=Ceil(16*(A_ScreenHeight/1080)) ;宽度修正 如果全屏后窗口仍然没有填满屏幕增加这个值 一般是8的倍数
        GDXZ:=Ceil(8*(A_ScreenHeight/1080)) ;高度修正 如果全屏后窗口仍然没有填满屏幕增加这个值 一般是8的倍数
        IniWrite %KDXZ%, Settings.ini, 设置, 宽度修正 ;写入设置到ini文件
        IniWrite %GDXZ%, Settings.ini, 设置, 高度修正 ;写入设置到ini文件

        左边快捷呼出窗口:=""
        IniWrite %左边快捷呼出窗口%, Settings.ini, 设置, 左边快捷呼出窗口 ;写入设置到ini文件
        右边快捷呼出窗口:=""
        IniWrite %右边快捷呼出窗口%, Settings.ini, 设置, 右边快捷呼出窗口 ;写入设置到ini文件

        TabSwitch:=1
        IniWrite %TabSwitch%, Settings.ini, 设置, 顶置轮切 ;写入设置到ini文件
        Menu Tray, Check, 顶置轮切 ;右键菜单打勾
    }

    ; MsgBox %A_ScreenWidth% %A_ScreenHeight%

    WinDefaultTop:=[]

    HWNDarr:=[WinExist("ahk_class AHKEditor"), hGui]  ; 不需要显示后视镜窗口的黑名单 填WinTitle
    黑名单:=0
    白名单:=0
    媒体快捷键:=1
    暂停:=0
    KeyMediaDown:=""
    主动呼出任务栏:=0

    FDJ:=0 ;放大镜打开状态
    FDJM:=0 ;放大镜移动状态
    zoom := 2 ;放大镜缩放倍率
    Rx := Round(A_ScreenHeight*(100/1080))
    Ry := Round(A_ScreenHeight*(100/1080))
    Zx := Rx/zoom
    Zy := Ry/zoom
    Hotkey ~Shift, Off
    Hotkey ~Ctrl, Off

    HSJ:=0 ;后视镜打开状态
    HSJM:=0 ;后视镜移动状态 每次关闭后视镜时重置为0 只移动一次节省性能开销
    HSJH:=0 ;后视镜隐藏状态 隐藏直到移动到中间屏幕
    OpenHSJ:=0 ;打开后视镜中
    ToolTipTimes:=0 ;后视镜提示文字显示
    ToolTipCount:=0 ;后视镜提示文字计时
    ToolTipText:="" ;后视镜提示文字

    搜索栏:=0
    开始菜单:=0
    任务栏计时器:=0
    KeyDown_屏幕底部:=""

    WheelUpRecord:=0
    WheelDownRecord:=0

    AutoMove:=0
    AutoHide:=1

    快捷呼出计时:=-1
    停留呼出左边快捷窗口:=0
    停留呼出右边快捷窗口:=0
    ; 主动隐藏快捷呼出窗口:=0
    if (WinActive("ahk_id "左边快捷呼出窗口)!=0)
        已激活左边快捷呼出窗口:=1
    else
        已激活左边快捷呼出窗口:=0

    if (WinActive("ahk_id "右边快捷呼出窗口)!=0)
        已激活右边快捷呼出窗口:=1
    else
        已激活右边快捷呼出窗口:=0

    GoSub 白名单
    gosub 更新数据
    Sleep 100

    if (running=1)
        SetTimer 屏幕监测, 50 ;监测鼠标位置打开后视镜
return

更新数据:
    if (白名单=1)
    {
        GDXZ:=0
        KDXZ:=0
        SW:=Round((A_ScreenWidth-2*BKXZ)/3) ;修正后屏幕宽度
        SH:=A_ScreenHeight ;修正后屏幕高度

        YDY:=0 ;屏幕原点Y
        YDL:=0 ;左边屏幕左上角原点X
        YDM:=RSW+BKXZ ;中间屏幕左上角原点X
        YDR:=RSW*2+BKXZ*2 ;右边屏幕左上角原点X
    }
    else
    {
        IniRead KDXZ, Settings.ini, 设置, 宽度修正
        IniRead GDXZ, Settings.ini, 设置, 高度修正
        SW:=Round((A_ScreenWidth-2*BKXZ)/3)+KDXZ ;修正后屏幕宽度
        SH:=A_ScreenHeight+GDXZ ;修正后屏幕高度

        YDY:=0 ;屏幕原点Y
        YDL:=Floor(0-KDXZ/2) ;左边屏幕左上角原点X
        YDM:=Floor(RSW+BKXZ-KDXZ/2) ;中间屏幕左上角原点X
        YDR:=Floor(RSW*2+BKXZ*2-KDXZ/2) ;右边屏幕左上角原点X
    }

    FJL:=Floor((A_ScreenWidth-BKXZ*2)/3) ;左分界线
    FJR:=Ceil(A_ScreenWidth-FJL) ;右分界线
    RSW:=Floor((A_ScreenWidth-2*BKXZ)/3) ;物理屏幕宽度
    RSH:=A_ScreenHeight ;物理屏幕高度

    搜索栏W:=Round(RSW/3*2)
    搜索栏H:=Round(RSH/3*2)
    搜索栏X:=RSW+BKXZ
    WinGetPos, , , , ShellTrayWndHeight, ahk_class Shell_TrayWnd
    搜索栏Y:=RSH-搜索栏H-ShellTrayWndHeight-10

    WinTop:=Round(RSH*(45/1080)) ;窗口顶部识别分界线
    ScreenBottom:=RSH-Floor(RSH*(40/1080)) ;屏幕底部识别分界线

    HSJWidth:=Round(RSH/2) ;后视镜宽度
    HSJHeight:=Round(HSJWidth/4*3) ;后视镜高度
    HSJLX:=Round(FJL+RSH/10) ;左后视镜显示位置X
    HSJRX:=Round(FJR-HSJWidth-RSH/10) ;右后视镜显示位置X
    HSJY:=Round(RSH/2-HSJHeight/2) ;后视镜显示位置Y
    ; MsgBox, %HSJLX% %HSJRX% %HSJY%

    ; MsgBox 屏幕高度%A_ScreenHeight%`n修正后屏幕高度%SH% 高度修正%GDXZ%`n`n屏幕宽度%A_ScreenWidth%`n修正后屏幕宽度%SW% 宽度修正%KDXZ%`n`n分界线 %FJL% %FJM% %FJR%`n原点 %YDL% %YDM% %YDR%
Return

新增白名单:
    if (running=1)
        SetTimer 屏幕监测, Off

    if (HSJ=1)
    {
        ; ToolTip 关闭后视镜
        WinSet Transparent, 0, ahk_id %MagnifierWindowID%
        WinHide ahk_id %MagnifierWindowID%
        HSJM:=0
    }

    KeyWait LButton
    Critical, On
    WhiteListType:=1
    WhiteListMode:=1 ; 1=完全匹配 2=包含
    防误触:=0
    loop
    {
        MouseGetPos, , , WinID
        ; WinActivate ahk_id %WinID%
        WinGetTitle WinTitle, ahk_id %WinID%
        WinGetClass WinClass, ahk_id %WinID%
        WinGet WinExe, ProcessName, ahk_id %WinID%

        if (WhiteListType=1)
            WhiteListToolTip:="当前窗口Title:" . WinTitle
        Else if (WhiteListType=2)
            WhiteListToolTip:="当前窗口Class:" . WinClass
        Else if (WhiteListType=3)
            WhiteListToolTip:="当前窗口Exe:" . WinExe

        if (WhiteListMode=1)
            WhiteListToolTip.=" 完全匹配"
        else if (WhiteListMode=2)
            WhiteListToolTip.=" 包含内容"

        WhiteListToolTip.= "`n点击左键确定添加到白名单 点击Esc键退出白名单设置`n点击Ctrl键切换类型 点击Shift键切换匹配模式"
        ToolTip %WhiteListToolTip% %防误触%

        if (防误触=1)
        {
            if GetKeyState("Ctrl", "P") or GetKeyState("Shift", "P")
            {
                Sleep 30
                Continue
            }
            else if !GetKeyState("Ctrl", "P") and !GetKeyState("Shift", "P")
            {
                防误触:=0
            }
        }

        if GetKeyState("Ctrl", "P")
        {
            防误触:=1
            WhiteListType:=WhiteListType+1
            if (WhiteListType>3)
                WhiteListType:=1
        }
        else if GetKeyState("Shift", "P")
        {
            防误触:=1
            if (WhiteListMode=2)
                WhiteListMode:=1
            else ;if (WhiteListMode=1)
                WhiteListMode:=2

        }
        else if GetKeyState("Esc", "P")
        {
            ToolTip
            Break
        }
        else if GetKeyState("Lbutton", "P")
        {
            if (WhiteListMode=1)
                NewWhiteList:="Same "
            else if (WhiteListMode=2)
                NewWhiteList:="Include "

            if (WhiteListType=1)
            {
                NewWhiteList.="Title==="
                NewWhiteList.=WinTitle
            }
            else if (WhiteListType=2)
            {
                NewWhiteList.="Class==="
                NewWhiteList.=WinClass
            }
            else if (WhiteListType=3)
            {
                NewWhiteList.="Exe==="
                NewWhiteList.=WinExe
            }
            ToolTip
            Sleep 100

            IniRead WhiteListRecord, Settings.ini, Settings, 白名单列表 ;从ini文件读取
            if (InStr(WhiteListRecord, NewWhiteList)=0) ; 新增白名单
            {
                if (WhiteList="") or (WhiteList="ERROR")
                {
                    WhiteList:="Same Exe===Code.exe|Same Exe===Notepad--.exe"
                }
                WhiteList.="|"
                WhiteList.=NewWhiteList
                Sleep 100
                KeyWait LButton
                goto 白名单设置
            }
            else
            {
                LbuttonUp:=0
                loop 50
                {
                    ToolTip 白名单中已存在相同内容`,请重新设置!
                    if !GetKeyState("Lbutton", "P")
                        LbuttonUp:=1

                    if GetKeyState("Lbutton", "P") and (LbuttonUp=1)
                    {
                        ToolTip
                        KeyWait LButton
                        Break
                    }
                    Sleep 30
                }
            }
        }
    }

    if (running=1)
        SetTimer 屏幕监测, 50
    Critical, Off
Return

白名单设置:
    InputBox WhiteList, 白名单设置, 匹配模式作为开头并跟随空格 匹配模式有 Same完全匹配 Include包含内容`n请用 “===” 分隔开 匹配类型 和 匹配特征`n匹配类型有 Title Class Exe`n请用 “|” 分隔开每个窗口`n举例: Include Title===窗口标题 表示:匹配窗口标题包含内容为"窗口标题"的窗口, , A_ScreenHeight, 200, , , Locale, ,%WhiteList%
    if !ErrorLevel
    {
        ;如果白名单最后的字符串是"|"则删除
        if (InStr(WhiteList, "|", , 0)=StrLen(WhiteList))
        {
            WhiteList:=SubStr(WhiteList, 1, StrLen(WhiteList)-1)
        }
        IniWrite %WhiteList%, Settings.ini, Settings, 白名单列表 ;写入设置到ini文件
    }
    else
    {
        IniRead WhiteList, Settings.ini, Settings, 白名单列表 ;写入设置到ini文件
    }
Return

白名单:
    白名单:=0
    MouseGetPos, , , 白名单识别包含ID
    白名单列表:=StrSplit(WhiteList,"|")
    匹配次数:=白名单列表.Length() 
    Loop %匹配次数% ;Title Class Exe
    {
        ; ToolTip % 白名单列表[A_Index]
        if (InStr(白名单列表[A_Index], "Title")!=0)
            WinGetTitle 当前特征, ahk_id %白名单识别包含ID%
        else if (InStr(白名单列表[A_Index], "Class")!=0)
            WinGetClass 当前特征, ahk_id %白名单识别包含ID%
        else if (InStr(白名单列表[A_Index], "Exe")!=0)
            WinGet 当前特征, ProcessName, ahk_id %白名单识别包含ID%

        包含项位置:=InStr(白名单列表[A_Index], "===")+3
        包含项:=SubStr(白名单列表[A_Index], 包含项位置)
        ; ToolTip, 包含项%包含项%`n当前特征%当前特征%

        if (InStr(白名单列表[A_Index], "Same")!=0) and (当前特征=包含项)
        {
            白名单:=1
        }
        else if (InStr(白名单列表[A_Index], "Include")!=0) and (InStr(当前特征, 包含项)!=0)
        {
            白名单:=1
        }
    }
Return

新增黑名单:
    if (running=1)
        SetTimer 屏幕监测, Off

    if (HSJ=1)
    {
        ; ToolTip 关闭后视镜
        WinSet Transparent, 0, ahk_id %MagnifierWindowID%
        WinHide ahk_id %MagnifierWindowID%
        HSJM:=0
    }

    KeyWait LButton
    Critical, On
    BlackListType:=1
    BlackListMode:=1 ; 1=完全匹配 2=包含
    防误触:=0
    loop
    {
        MouseGetPos, , , WinID
        WinGetTitle WinTitle, ahk_id %WinID%
        WinGetClass WinClass, ahk_id %WinID%
        WinGet WinExe, ProcessName, ahk_id %WinID%

        if (BlackListType=1)
            BlackListToolTip:="当前窗口Title:" . WinTitle
        Else if (BlackListType=2)
            BlackListToolTip:="当前窗口Class:" . WinClass
        Else if (BlackListType=3)
            BlackListToolTip:="当前窗口Exe:" . WinExe

        if (BlackListMode=1)
            BlackListToolTip.=" 完全匹配"
        else if (BlackListMode=2)
            BlackListToolTip.=" 包含内容"

        BlackListToolTip.= "`n点击左键确定添加到黑名单 点击Esc键退出黑名单设置`n点击Ctrl键切换类型 点击Shift键切换匹配模式"
        ToolTip %BlackListToolTip%

        if (防误触=1)
        {
            if GetKeyState("Ctrl", "P") or GetKeyState("Shift", "P")
            {
                Sleep 30
                Continue
            }
            else if !GetKeyState("Ctrl", "P") and !GetKeyState("Shift", "P")
            {
                防误触:=0
            }
        }

        if GetKeyState("Ctrl", "P")
        {
            防误触:=1
            BlackListType:=BlackListType+1
            if (BlackListType>3)
                BlackListType:=1
        }
        else if GetKeyState("Shift", "P")
        {
            防误触:=1
            if (BlackListMode=2)
                BlackListMode:=1
            else ;;if (BlackListMode=1)
                BlackListMode:=2
        }
        else if GetKeyState("Esc", "P")
        {
            ToolTip
            Break
        }
        else if GetKeyState("Lbutton", "P")
        {
            if (BlackListMode=1)
                NewBlackList:="Same "
            else if (BlackListMode=2)
                NewBlackList:="Include "

            if (BlackListType=1)
            {
                NewBlackList.="Title==="
                NewBlackList.=WinTitle
            }
            else if (BlackListType=2)
            {
                NewBlackList.="Class==="
                NewBlackList.=WinClass
            }
            else if (BlackListType=3)
            {
                NewBlackList.="Exe==="
                NewBlackList.=WinExe
            }
            ToolTip
            Sleep 100

            IniRead BlackListRecord, Settings.ini, Settings, 黑名单列表 ;从ini文件读取
            if (InStr(BlackListRecord, NewBlackList)=0) ; 新增黑名单
            {
                if (BlackList="") or (BlackList="ERROR")
                {
                    BlackList:="Same Class===ActualTools_MultiMonitorTaskbar|Same Class===DesktopLyrics|Same Class===WorkerW"
                }
                BlackList.="|"
                BlackList.=NewBlackList
                Sleep 100
                KeyWait LButton
                goto 黑名单设置
            }
            else
            {
                LbuttonUp:=0
                loop 50
                {
                    ToolTip 黑名单中已存在相同内容`,请重新设置!
                    if !GetKeyState("Lbutton", "P")
                        LbuttonUp:=1

                    if GetKeyState("Lbutton", "P") and (LbuttonUp=1)
                    {
                        ToolTip
                        KeyWait LButton
                        Break
                    }
                    Sleep 30
                }
            }
        }
    }

    if (running=1)
        SetTimer 屏幕监测, 50
    Critical, Off
Return

黑名单设置:
    InputBox BlackList, 黑名单设置, 匹配模式作为开头并跟随空格 匹配模式有 Same完全匹配 Include包含内容`n请用 “===” 分隔开 匹配类型 和 匹配特征`n匹配类型有 Title Class Exe`n请用 “|” 分隔开每个窗口`n举例: Include Title===窗口标题 表示:匹配窗口标题包含内容为"窗口标题"的窗口, , A_ScreenHeight, 200, , , Locale, ,%BlackList%
    if !ErrorLevel
    {
        ;如果黑名单最后的字符串是"|"则删除
        if (InStr(BlackList, "|", , 0)=StrLen(BlackList))
        {
            BlackList:=SubStr(BlackList, 1, StrLen(BlackList)-1)
        }
        IniWrite %BlackList%, Settings.ini, 设置, 黑名单列表 ;写入设置到ini文件
    }
    else
    {
        IniRead BlackList, Settings.ini, 设置, 黑名单列表 ;写入设置到ini文件
    }
Return

黑名单:
    黑名单:=0
    MouseGetPos, , , 黑名单识别排除ID
    黑名单列表:=StrSplit(BlackList,"|")
    匹配次数:=黑名单列表.Length()
    Loop %匹配次数% ;Title Class Exe
    {
        ; ToolTip % 黑名单列表[A_Index]
        if (InStr(黑名单列表[A_Index], "Title")!=0)
            WinGetTitle 当前特征, ahk_id %黑名单识别排除ID%
        else if (InStr(黑名单列表[A_Index], "Class")!=0)
            WinGetClass 当前特征, ahk_id %黑名单识别排除ID%
        else if (InStr(黑名单列表[A_Index], "Exe")!=0)
            WinGet 当前特征, ProcessName, ahk_id %黑名单识别排除ID%

        排除项位置:=InStr(黑名单列表[A_Index], "===")+3
        排除项:=SubStr(黑名单列表[A_Index], 排除项位置)
        ; ToolTip, 排除项%排除项%`n当前特征%当前特征%

        if (InStr(黑名单列表[A_Index], "Same")!=0) and (当前特征=排除项)
        {
            黑名单:=1
        }
        else if (InStr(黑名单列表[A_Index], "Include")!=0) and (InStr(当前特征, 排除项)!=0)
        {
            黑名单:=1
        }
    }

    if (黑名单=1)
        Critical, Off
Return

自动暂停:
    if (running=1)
        SetTimer 屏幕监测, Off

    Critical, on
    if (BlackListWindow_AutoStop="") or (BlackListWindow_AutoStop="ERROR")
    {
        Menu Tray, Check, 自动暂停
        KeyWait Lbutton
        loop
        {
            MouseGetPos, , , WinID
            WinGetClass WinClass, ahk_id %WinID%
            ToolTip 当前窗口%WinClass%`n请按下左键捕获自动暂停窗口

            if GetKeyState("LButton", "P") and (危险操作=0)
            {
                BlackListWindow_AutoStop:=WinClass
                IniWrite %BlackListWindow_AutoStop%, Settings.ini, 设置, 自动暂停黑名单 ;写入设置到ini文件
                Break
            }
        }
    }
    else
    {
        Menu Tray, UnCheck, 自动暂停
        BlackListWindow_AutoStop:=""
        IniWrite %BlackListWindow_AutoStop%, Settings.ini, 设置, 自动暂停黑名单 ;写入设置到ini文件
        running:=0
        gosub 暂停运行
        Alt自动暂停:=0
    }

    if (running=1)
        SetTimer 屏幕监测, 50
    critical, Off
Return

危险操作识别:
    危险操作:=0
    if (WinClass="_cls_desk_") or (WinClass="Shell_TrayWnd") or (WinClass="WorkerW") or (WinClass="Qt51513QWindowToolSaveBits") or (InStr(WinClass, "spy")!=0) ;or (WinTitle="QQ")
        危险操作:=1

    GoSub 黑名单
    if (黑名单=1)
        危险操作:=1
Return

~WheelUp:: ;触发按键 滚轮上
    GoSub 白名单
    gosub 更新数据
    if (A_TickCount-WheelUpRecord<=300)
    {
        WheelUpRecord:=A_TickCount
        Return
    }
    else
    {
        WheelUpRecord:=A_TickCount
    }
    Critical, On
    CoordMode Mouse, Screen ;以屏幕为基准
    MouseGetPos MX, MY, WinID ;获取鼠标在屏幕中的位置
    WinID:=HexToDec(WinID) ;将句柄转换为16进制格式
    WinGetPos WinX, WinY, WinW, WinH, ahk_id %WinID% ;获取窗口位置和大小
    WinGetClass WinClass, ahk_id %WinID% ;获取窗口类名
    WinGetTitle WinTitle, ahk_id %WinID% ;获取窗口类名
    WinGet WinExe, ProcessName, ahk_id %WinID%
    ; MsgBox, %WinExe%
    ; WinGet 窗口样式, ExStyle, ahk_id %WinID% ;获取窗口样式
    ; 窗口样式:= (窗口样式 & 0x8) ? true : false ;验证窗口是否处于总是顶置状态
    if (MY>ScreenBottom) ;如果鼠标在屏幕底部
    {
        if (CompatibleMode=0) ;不是兼容模式
        {
            ToolTip 还原所有窗口
            WinMinimizeAllUndo ;还原所有窗口
        }
        else ;是兼容模式 用快捷键的方式还原所有窗口 Shif+Win+M
        {
            ToolTip 还原所有窗口 兼容模式
            Send {LWin Down}
            Send {Shift Down}
            Sleep 15
            Send {m Down}
            Sleep 15
            Send {m Up}
            Sleep 15
            Send {Shift Up}
            Send {LWin Up}
        }
        SetTimer 关闭提示, -500 ;500毫秒后关闭提示
    }
    else
    {
        WinGetClass WinClass, ahk_id %WinID% ;获取窗口类名
        WinGetTitle WinTitle, ahk_id %WinID% ;获取窗口类名
        WinGet WinExe, ProcessName, ahk_id %WinID%
        GoSub 危险操作识别
        if (危险操作=1)
        {
            Return
        }
        WinGetPos SX, SY, W, H, ahk_id %WinID% ;获取窗口以屏幕为基准的位置 窗口的宽和高
        WX:=MX-SX ; 鼠标在窗口中的X位置
        WY:=MY-SY ; 鼠标在窗口中的Y位置
        ; WinInScreenX:=SX+W/2 ;窗口中间以屏幕为基准的位置
        WinInScreenX:=MX ;窗口中间以屏幕为基准的位置
        WinRestore ahk_id %WinID% ;如果窗口已经最大化则还原窗口
        ; MsgBox ID:%WinID%`nX:%X% Y:%Y%`nW:%W% H:%H%`n`n左分界线:%FJL%`n右分界线:=%FJR%`n鼠标位置 X:%SX% Y:%SY%
        if (WinInScreenX<FJL) and (WY<WinTop) ;点击的窗口在左边屏幕 并且 点击位置在窗口顶部
        {
            ToolTip 最大化%WinTitle%窗口
            WinRestore ahk_id %WinID%
            if (ExtraHeightFit=1)
            {
                WinMove ahk_id %WinID%, ,YDL ,YDY+ExtraHeight ,SW ,SH-ExtraHeight ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
            }
            else
            {
                WinMove ahk_id %WinID%, ,YDL ,YDY ,SW ,SH ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
            }

            if (WinExe!="ugraf.exe")
                WinSet Style, -0x40000, ahk_id %WinID% ;禁止调整窗口大小

            SetTimer 关闭提示, -500 ;500毫秒后关闭提示
        }
        else if (WinInScreenX>FJL) and (WinInScreenX<FJR) and (WY<WinTop) ;点击的窗口在中间屏幕 并且 点击位置在窗口顶部
        {
            ToolTip 最大化%WinTitle%窗口
            WinRestore ahk_id %WinID%
            if (ExtraHeightFit=1)
            {
                WinMove ahk_id %WinID%, ,YDM ,YDY+ExtraHeight ,SW ,SH-ExtraHeight ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
            }
            else
            {
                WinMove ahk_id %WinID%, ,YDM ,YDY ,SW ,SH ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
            }

            if (WinExe!="ugraf.exe")
                WinSet Style, -0x40000, ahk_id %WinID% ;禁止调整窗口大小

            SetTimer 关闭提示, -500 ;500毫秒后关闭提示
        }
        else if (WinInScreenX>FJR) and (WY<WinTop) ;点击的窗口在右边屏幕 并且 点击位置在窗口顶部
        {
            ToolTip 最大化%WinTitle%窗口
            WinRestore ahk_id %WinID%
            if (ExtraHeightFit=1)
            {
                WinMove ahk_id %WinID%, ,YDR ,YDY+ExtraHeight ,SW ,SH-ExtraHeight ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
            }
            else
            {
                WinMove ahk_id %WinID%, ,YDR ,YDY ,SW ,SH ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
            }

            if (WinExe!="ugraf.exe")
                WinSet Style, -0x40000, ahk_id %WinID% ;禁止调整窗口大小

            SetTimer 关闭提示, -500 ;500毫秒后关闭提示
        }
    }
    Critical, Off
return

~WheelDown:: ;触发按键 滚轮下
    GoSub 白名单
    gosub 更新数据
    if (A_TickCount-WheelDownRecord<=300)
    {
        WheelDownRecord:=A_TickCount
        Return
    }
    else
    {
        WheelDownRecord:=A_TickCount
    }
    Critical, On
    CoordMode Mouse, Screen ;以屏幕为基准
    MouseGetPos MX, MY, WinID ;获取鼠标在屏幕中的位置
    if (MY>ScreenBottom) ;如果鼠标在屏幕底部
    {
        if (CompatibleMode=0) ;不是兼容模式
        {
            ToolTip 最小化所有窗口
            WinMinimizeAll ;最小化所有窗口
        }
        else ;是兼容模式 用快捷键的方式最小化所有窗口 Win+M
        {
            ToolTip 最小化所有窗口 兼容模式
            Send {Shift Up}
            Sleep 15
            Send {LWin Down}
            Sleep 15
            Send {m Down}
            Sleep 15
            Send {m Up}
            Sleep 15
            Send {LWin Up}
        }
        SetTimer 关闭提示, -500 ;500毫秒后关闭提示
    }
    else
    {
        WinGetClass WinClass, ahk_id %WinID% ;获取窗口类名
        WinGetTitle WinTitle, ahk_id %WinID% ;获取窗口类名
        WinGet WinExe, ProcessName, ahk_id %WinID%
        GoSub 危险操作识别
        if (危险操作=1)
        {
            Critical, Off
            Return
        }
        WinGetPos SX, SY, W, H, ahk_id %WinID% ;获取窗口以屏幕为基准的位置 窗口的宽和高
        WX:=MX-SX ; 鼠标在窗口中的X位置
        WY:=MY-SY ; 鼠标在窗口中的Y位置
        ; WinInScreenX:=SX+W/2 ;窗口中间以屏幕为基准的位置
        WinInScreenX:=MX ;窗口中间以屏幕为基准的位置
        if (WY<WinTop) ;点击位置在窗口顶部
        {
            ToolTip 最小化%WinTitle%窗口
            WinMinimize ahk_id %WinID% ;最小化窗口
            if (屏幕实时位置=1)
            {
                MiniWinIDL:=WinID ;记录最近一次被最小化的窗口
                IniWrite %MiniWinIDL%, Settings.ini, 设置, 左边屏幕最近一次被最小化的窗口 ;写入设置到ini文件
                if (MiniWinIDL=MasterWinIDL)
                {
                    MasterWinIDL:=0
                    IniWrite %MasterWinIDL%, Settings.ini, 设置, 左边屏幕主窗口 ;写入设置到ini文件
                }
            }
            else if (屏幕实时位置=2)
            {
                MiniWinIDM:=WinID ;记录最近一次被最小化的窗口
                IniWrite %MiniWinIDM%, Settings.ini, 设置, 中间屏幕最近一次被最小化的窗口 ;写入设置到ini文件
                if (MiniWinIDM=MasterWinIDM)
                {
                    MasterWinIDM:=0
                    IniWrite %MasterWinIDM%, Settings.ini, 设置, 中间屏幕主窗口 ;写入设置到ini文件
                }
            }
            else if (屏幕实时位置=3)
            {
                MiniWinIDR:=WinID ;记录最近一次被最小化的窗口
                IniWrite %MiniWinIDR%, Settings.ini, 设置, 右边屏幕最近一次被最小化的窗口 ;写入设置到ini文件
                if (MiniWinIDR=MasterWinIDR)
                {
                    MasterWinIDR:=0
                    IniWrite %MasterWinIDR%, Settings.ini, 设置, 右边屏幕主窗口 ;写入设置到ini文件
                }
            }
            SetTimer 关闭提示, -500 ;500毫秒后关闭提示
        }
    }
    Critical, Off
return

~^LButton:: ;Ctrl+左键
    Critical, On
    CoordMode Mouse, Window ;以窗口为基准
    MouseGetPos, , WindowY, WinID ;获取鼠标在窗口中的位置
    WinGetClass WinClass, ahk_id %WinID% ;获取窗口类名
    WinGet 窗口样式, ExStyle, ahk_id %WinID% ;获取窗口样式
    窗口样式:= (窗口样式 & 0x8) ? true : false ;验证窗口是否处于总是顶置状态
    ; ToolTip %窗口样式%

    ClickActiveTop:=0
    Loop % WinActiveTop.Length()
    {
        if (窗口样式=1) and (WinActiveTop[A_Index]=WinID) ;如果点击的是主动顶置窗口存在 调整顶置的顺序
        {
            WinActiveTop.RemoveAt(A_Index)
            WinActiveTop.InsertAt(1, WinID)
            ClickActiveTop:=1
            ActiveTopNow:=1
        }
    }
    ; WinGet Opacity, Transparent, ahk_id %WinID%
    ; ToolTip Opacity%Opacity%
    ; ToolTip %ClickActiveTop%

    if (窗口样式=0) and (WindowY<WinTop) ;如果没有处于总是顶置状态 并且 点击在窗口顶部
    {
        WinGetTitle ActiveWindowID, ahk_id %WinID% ;根据句柄获取窗口的名字
        IniWrite %ActiveWindowID%, Settings.ini, 设置, 后台等待激活的窗口 ;写入设置到ini文件
        loop 20
        {
            ToolTip 窗口%ActiveWindowID%已准备好等待激活
            sleep 30
        }
        ToolTip
    }
    else if (窗口样式=1) and (WindowY>WinTop) and (WinClass!="AutoHotkeyGUI") and (ClickActiveTop=1) ;如果点击主动顶置窗口内部 并且 没有点击在窗口顶部
    {
        ; ToolTip 关闭后视镜
        WinSet Transparent, 0, ahk_id %MagnifierWindowID%
        WinHide ahk_id %MagnifierWindowID% ;关闭后视镜
        HSJM:=0
        HSJH:=1

        CoordMode Mouse, Screen ;以屏幕为基准
        MouseGetPos, , ScreenOldY, WinID ;获取鼠标在屏幕中的位置
        WinGet TopOpacity, Transparent, ahk_id %WinID%
        if (TopOpacity="")
        {
            TopOpacity:=255
        }
        LButtonMove:=A_TickCount
        Loop ;如果200ms内不移动不调整透明度左键也不会抬起
        {
            if !GetKeyState("LButton", "P") or (A_TickCount-LButtonMove>200) ;左键抬起则暂停
            {
                break
            }

            Sleep 10
            CoordMode Mouse, Screen ;以屏幕为基准
            MouseGetPos, , ScreenY ;获取鼠标在屏幕中的位置
            if (ScreenY>=ScreenOldY-3) and (ScreenY<=ScreenOldY+3) ;如果鼠标没有移动
            {
                continue
            }
            else ;if GetKeyState("Lbutton") ;如果鼠标移动了
            {
                Send {LButton Up} ;抬起左键后再调整透明度
            }

            Loop
            {
                OldWinSY:=ScreenY
                Sleep 10
                MouseGetPos, , ScreenY ;获取鼠标在屏幕中的位置

                if !GetKeyState("LButton", "P") ;左键抬起则暂停
                {
                    break
                }

                if (ScreenY<OldWinSY) ;向上移动降低透明度
                {
                    TopOpacity:=TopOpacity+2
                    if (TopOpacity>255)
                    {
                        TopOpacity:=255
                    }
                    TopOpacityPercent:=Round(TopOpacity/255*100, 2)
                    ToolTip 增加顶置窗口的透明度 %TopOpacityPercent%`%
                    WinSet Transparent, %TopOpacity%, ahk_id %WinID%
                    SetTimer 关闭提示, -500 ;500毫秒后关闭提示
                }

                if (ScreenY>OldWinSY) ;向下移动增加透明度
                {
                    TopOpacity:=TopOpacity-2
                    if (TopOpacity<2)
                    {
                        TopOpacity:=2
                    }
                    TopOpacityPercent:=Round(TopOpacity/255*100, 2)
                    ToolTip 减少顶置窗口的透明度 %TopOpacityPercent%`%
                    WinSet Transparent, %TopOpacity%, ahk_id %WinID%
                    SetTimer 关闭提示, -500 ;500毫秒后关闭提示
                }
            }
        }

        if (HSJ=1)
        {
            CoordMode Mouse, Screen ;以屏幕为基准
            MouseGetPos ReloadX, ReloadY
            ; MsgBox, ReloadX%ReloadX% ReloadY%ReloadY%
            if (ReloadX<FJL) or (ReloadX>FJR) ;如果在左侧屏幕或者在右侧屏幕
            {
                HSJM:=0
                HSJH:=0
                WinShow ahk_id %MagnifierWindowID% ;打开后视镜

                if (HSJM=0) and (ReloadX<FJL) ;如果在左侧屏幕
                {
                    WinMove ahk_id %MagnifierWindowID%, , HSJLX, HSJY
                    HSJM:=1
                }
                else if (HSJM=0) and (ReloadX>FJR) ;如果在右侧屏幕
                {
                    WinMove ahk_id %MagnifierWindowID%, , HSJRX, HSJY
                    HSJM:=1
                }

                WinSet Transparent, 255, ahk_id %MagnifierWindowID%
            }
        }
    }
    Critical, Off
return

~+LButton:: ;Shift+左键
    Critical, On
    CoordMode Mouse, Window ;以窗口为基准
    MouseGetPos, , WindowY, WinID ;获取鼠标在窗口中的位置
    WinGetClass WinClass, ahk_id %WinID% ;获取窗口类名
    WinGetTitle WinTitle, ahk_id %WinID% ;获取窗口类名
    if (WindowY<WinTop) ;如果没有处于总是顶置状态 并且 点击在窗口顶部
    {
        if (屏幕实时位置=1)
        {
            MasterWinIDL:=WinID ;记录主窗口
            IniWrite %MasterWinIDL%, Settings.ini, 设置, 左边屏幕主窗口 ;写入设置到ini文件
            if (MasterWinIDL=MiniWinIDL)
            {
                MiniWinIDL:=0
                IniWrite %MiniWinIDL%, Settings.ini, 设置, 左边屏幕最近一次被最小化的窗口 ;写入设置到ini文件
            }
            loop 20
            {
                ToolTip 设定%WinTitle%左边屏幕主窗口
                Sleep 30
            }
            ToolTip
        }
        else if (屏幕实时位置=2)
        {
            MasterWinIDM:=WinID ;记录主窗口
            IniWrite %MasterWinIDM%, Settings.ini, 设置, 中间屏幕主窗口 ;写入设置到ini文件
            if (MasterWinIDM=MiniWinIDM)
            {
                MiniWinIDM:=0
                IniWrite %MiniWinIDM%, Settings.ini, 设置, 中间屏幕最近一次被最小化的窗口 ;写入设置到ini文件
            }
            loop 20
            {
                ToolTip 设定%WinTitle%中间屏幕主窗口
                Sleep 30
            }
            ToolTip
        }
        else if (屏幕实时位置=3)
        {
            MasterWinIDR:=WinID ;记录主窗口
            IniWrite %MasterWinIDR%, Settings.ini, 设置, 右边屏幕主窗口 ;写入设置到ini文件
            if (MasterWinIDR=MiniWinIDR)
            {
                MiniWinIDR:=0
                IniWrite %MiniWinIDR%, Settings.ini, 设置, 右边屏幕最近一次被最小化的窗口 ;写入设置到ini文件
            }
            loop 20
            {
                ToolTip 设定%WinTitle%右边屏幕主窗口
                Sleep 30
            }
            ToolTip
        }
        SetTimer 关闭提示, -500 ;500毫秒后关闭提示
    }
    Critical, Off
return

~!LButton:: ;Alt+左键
    Critical, On
    CoordMode Mouse, Window ;以窗口为基准
    MouseGetPos, , WindowY, WinID_Monitor ;获取鼠标在窗口中的位置
    WinGetClass WinClass, ahk_id %WinID_Monitor% ;获取窗口类名
    WinGetTitle WinTitle, ahk_id %WinID_Monitor% ;获取窗口类名
    WinGet WinExe, ProcessName, ahk_id %WinID_Monitor%
    GoSub 危险操作识别
    if (危险操作=1)
    {
        Return
    }
    WinGet 窗口样式, ExStyle, ahk_id %WinID_Monitor% ;获取窗口样式
    窗口样式:= (窗口样式 & 0x8) ? true : false ;验证窗口是否处于总是顶置状态
    ; ToolTip %窗口样式%
    if (窗口样式=0) and (WindowY<WinTop) and (WinClass!=AutoHideWindow) and (危险操作=0) ;如果没有处于总是顶置状态 并且 点击在窗口顶部
    {
        Menu Tray, Check, 自动暂停
        WinGetClass WinClass, ahk_id %WinID_Monitor% ;根据句柄获取窗口的名字
        loop
        {
            ToolTip 窗口%WinTitle%自动暂停
            Sleep 30
            if !GetKeyState("LButton", "P") ;如果左键松开
            {
                loop 20
                {
                    ToolTip 窗口%WinTitle%自动暂停
                    Sleep 30
                }
                Break ;跳出循环
            }
        }
        ToolTip
        BlackListWindow_AutoStop:=WinClass
        IniWrite %BlackListWindow_AutoStop%, Settings.ini, 设置, 自动暂停黑名单 ;写入设置到ini文件
    }
    Critical, Off
Return

HexToDec(hex)
{
    ; 如果字符串以 "0x" 开头，则去掉它
    if (SubStr(hex, 1, 2) = "0x")
    {
        hex := SubStr(hex, 3)
    }

    ; 如果字符串为空，则返回0
    if (StrLen(hex) = 0)
    {
        return 0
    }

    decimal := 0
    StringUpper hex, hex  ; 将输入字符串转换为大写
    Loop, Parse, hex
    {
        char := A_LoopField
        value := 0
        if (char >= "0" && char <= "9")
            value := char
        else if (char >= "A" && char <= "F")
            value := Asc(char) - 55
        else
            return "Invalid input"

        decimal := decimal * 16 + value
    }
    return decimal
}

~LButton:: ;左键
    GoSub 白名单
    gosub 更新数据

    CoordMode Mouse, Window ;以窗口为基准
    MouseGetPos WinWX, WinWY, WinID  ;获取鼠标在窗口中的位置 获取鼠标所在窗口的句柄
    WinID:=HexToDec(WinID) ;将句柄转换为16进制格式
    WinGetPos WinX, WinY, WinW, WinH, ahk_id %WinID% ;获取窗口位置和大小
    WinGetClass WinClass, ahk_id %WinID% ;获取窗口类名
    WinGetTitle WinTitle, ahk_id %WinID% ;获取窗口类名
    WinGet WinExe, ProcessName, ahk_id %WinID%
    WinGet 窗口样式, ExStyle, ahk_id %WinID% ;获取窗口样式
    窗口样式:= (窗口样式 & 0x8) ? true : false ;验证窗口是否处于总是顶置状态

    ; 鼠标穿透
    ClickActiveTop:=0 ;如果点击的顶置窗口在主动顶置窗口列表中
    ClickDefaultTop:=0
    Loop % WinActiveTop.Length()
    {
        ; MsgBox ActiveTopID:=WinActiveTop[A_Index]
        if (WinExist("ahk_id "WinActiveTop[A_Index])=0) ;如果主动顶置窗口不存在 清除对应设置
        {
            WinActiveTop.RemoveAt(A_Index)
            Loop % WinDefaultTop.Length()
            {
                ; DefaultTopID:=WinDefaultTop[A_Index]
                if (WinExist("ahk_id "WinDefaultTop[A_Index])=0) ;如果主动顶置窗口不存在 清除对应设置
                {
                    WinDefaultTop.RemoveAt(A_Index)
                }
            }
        }
        else if (窗口样式=1) and (WinActiveTop[A_Index]=WinID) ;如果点击的是主动顶置窗口存在 调整顶置的顺序
        {
            ActiveTopID:=WinActiveTop[A_Index]
            WinActiveTop.RemoveAt(A_Index)
            WinActiveTop.InsertAt(1, WinID)
            ClickActiveTop:=1
            ActiveTopNow:=1

            ;如果点击的顶置窗口在主动顶置窗口列表中
            Loop % WinDefaultTop.Length()
            {
                if (窗口样式=1) and (WinDefaultTop[A_Index]=ActiveTopID) ;如果点击的是主动顶置窗口存在 调整顶置的顺序
                {
                    ClickDefaultTop:=1
                }
            }
        }
    }

    WinTopSetting:=""
    loop % WinActiveTop.Length()
    {
        if (A_Index<WinActiveTop.Length())
            WinTopSetting.=WinActiveTop[A_Index] . "|"
        else
            WinTopSetting.=WinActiveTop[A_Index]
    }
    IniWrite %WinTopSetting%, Settings.ini, 设置, 主动顶置窗口 ;写入设置到ini文件
    ; ToolTip WinTopSetting%WinTopSetting%
    ; ToolTip %WinID%`n%WinTopSetting%`n主动%ClickActiveTop% 默认%ClickDefaultTop%

    ; 手势时间
    WinGetPos WinXHistory, WinYHistory, WinW, WinH, ahk_id %WinID% ;获取窗口的宽度和高度
    if (WinWY<WinTop+ExtraHeight) ;鼠标点击在窗口顶部
    {
        WinSet Transparent, 0, ahk_id %MagnifierWindowID%
        WinHide ahk_id %MagnifierWindowID% ;关闭后视镜
        HSJM:=0
        HSJH:=1

        if (WinExe="firefox.exe") or (WinExe="chrome.exe") or (WinExe="msedge.exe") ;如果是浏览器
        {
            WinGet WinIDListNumber, List, Ahk_exe %WinExe% ;获取所有窗口ID
            WinIDListDown := []
            Loop %WinIDListNumber%
            {
                WinIDListDown.Push(WinIDListNumber%A_Index%)
            }
        }

        Critical, on
        CoordMode Mouse, Screen ;以屏幕为基准
        MouseGetPos, , OldWinSY
        gosub AeroShake ;跳转检测程序
        HSJH:=0
        DllCall("QueryPerformanceCounter", "Int64*", LBUpOnTop) ;第二次记录时间
        MouseGetPos, , NewWinSY
        下移距离:=NewWinSY-OldWinSY
        MoveDownSpeed:=Round(Abs(下移距离)/((LBUpOnTop-LBDownOnTop)/freq*1000)*1000) ;移动速度=移动距离/时间
        Critical, off
        ; ToolTip, 下移距离%下移距离% MoveDownSpeed%MoveDownSpeed%, , ,2

        if (WinExe="firefox.exe") or (WinExe="chrome.exe") or (WinExe="msedge.exe") ;如果是浏览器
        {
            Sleep 200
            WinGet WinIDListNumber, List, Ahk_exe %WinExe% ;获取所有窗口ID
            WinIDListUp := []
            Loop %WinIDListNumber%
            {
                WinIDListUp.Push(WinIDListNumber%A_Index%)
            }

            NewWindowIDs:=""
            loop % WinIDListUp.Count()
            {
                ChangeWindow:=WinIDListUp[A_Index]
                SameWindow:=0
                loop % WinIDListDown.Count()
                {
                    if (ChangeWindow=WinIDListDown[A_Index])
                    {
                        SameWindow:=SameWindow+1
                    }
                }
                if (SameWindow=0)
                {
                    NewWindowIDs.=ChangeWindow . "|"
                    WinID:=ChangeWindow
                }
            }
        }

        ; 顶置窗口
        if (摇晃次数>=3) and (总移动距离>=Round(A_ScreenHeight*(300/1080)))
        {
            ; ToolTip %窗口样式%
            if (窗口样式=0) ;如果没有处于总是顶置状态
            {
                Critical On
                ; MsgBox % WinActiveTop.Length()
                ; if (WinActiveTop.Length()=0) or (WinActiveTop.Length()="")
                ;     WinActiveTop.Push(WinID)
                ; else
                WinActiveTop.InsertAt(1, WinID)

                WinTopSetting:=""
                loop % WinActiveTop.Length()
                {
                    if (A_Index<WinActiveTop.Length())
                        WinTopSetting.=WinActiveTop[A_Index] . "|"
                    else
                        WinTopSetting.=WinActiveTop[A_Index]
                }
                IniWrite %WinTopSetting%, Settings.ini, 设置, 主动顶置窗口 ;写入设置到ini文
                WinSet AlwaysOnTop, On, ahk_id %WinID%  ;切换窗口的顶置状态

                Loop 20
                {
                    ToolTip 窗口%WinTitle%设为总是顶置 O
                    Sleep 30
                }
                ToolTip
                ; ToolTip %WinTopSetting%`n主动%ClickActiveTop% 默认%ClickDefaultTop%
                Critical Off
            }
            else ;(窗口样式=1) ;如果已经处于总是顶置状态
            {
                Critical On
                if (ClickActiveTop=1) ; 如果点击的是主动顶置窗口
                {
                    if (ClickDefaultTop=1) ; 如果点击的是默认顶置窗口
                    {
                        Loop % WinDefaultTop.Length()
                        {
                            if (WinDefaultTop[A_Index] = WinID)
                            {
                                WinDefaultTop.RemoveAt(A_Index)
                                break
                            }
                        }

                        Loop % WinActiveTop.Length()
                        {
                            if (WinActiveTop[A_Index] = WinID)
                            {
                                WinActiveTop.RemoveAt(A_Index)
                                break
                            }
                        }

                        WinTopSetting:=""
                        loop % WinActiveTop.Length()
                        {
                            if (A_Index<WinActiveTop.Length())
                                WinTopSetting.=WinActiveTop[A_Index] . "|"
                            else
                                WinTopSetting.=WinActiveTop[A_Index]
                        }
                        IniWrite %WinTopSetting%, Settings.ini, 设置, 主动顶置窗口 ;写入设置到ini文件"

                        Loop 20
                        {
                            ToolTip 窗口%WinTitle%从主动顶置窗口移除 -
                            Sleep 30
                        }
                        ToolTip
                        ; ToolTip %WinTopSetting%`n主动%ClickActiveTop% 默认%ClickDefaultTop%
                    }
                    else ; 如果点击的是主动顶置窗口
                    {
                        Loop % WinActiveTop.Length()
                        {
                            if (WinActiveTop[A_Index] = WinID)
                            {
                                WinActiveTop.RemoveAt(A_Index)
                                break
                            }
                        }
                        WinTopSetting:=""
                        loop % WinActiveTop.Length()
                        {
                            if (A_Index<WinActiveTop.Length())
                                WinTopSetting.=WinActiveTop[A_Index] . "|"
                            else
                                WinTopSetting.=WinActiveTop[A_Index]
                        }
                        IniWrite %WinTopSetting%, Settings.ini, 设置, 主动顶置窗口 ;写入设置到ini文件"

                        WinGet WinExStyle, ExStyle, ahk_id %WinID%
                        if (WinExStyle & 0x20)
                            WinSet ExStyle, -0x20, ahk_id %WinID% ;关闭鼠标穿透

                        WinGet WinTransparent, Transparent, ahk_id %WinID%
                        if (WinTransparent<255)
                            WinSet Transparent, 255, ahk_id %WinID%

                        WinSet AlwaysOnTop, Off, ahk_id %WinID%  ;切换窗口的顶置状态
                        Loop 20
                        {
                            ToolTip 窗口%WinTitle%取消总是顶置 -
                            Sleep 30
                        }
                        ToolTip
                        ; ToolTip %WinTopSetting%`n主动%ClickActiveTop% 默认%ClickDefaultTop%
                    }
                }
                else ;if (ClickActiveTop=0) and (窗口样式=1) ;如果是非主动顶置的默认顶置窗口不取消顶置加入主动顶置窗口列表内
                {
                    WinDefaultTop.InsertAt(1, WinID)
                    WinActiveTop.InsertAt(1, WinID)
                    WinTopSetting:=""
                    loop % WinActiveTop.Length()
                    {
                        if (A_Index<WinActiveTop.Length())
                            WinTopSetting.=WinActiveTop[A_Index] . "|"
                        else
                            WinTopSetting.=WinActiveTop[A_Index]
                    }
                    IniWrite %WinTopSetting%, Settings.ini, 设置, 主动顶置窗口 ;写入设置到ini文

                    Loop 20
                    {
                        ToolTip 窗口%WinTitle%添加进主动顶置窗口 O
                        Sleep 30
                    }
                    ToolTip
                    ; ToolTip %WinTopSetting%`n主动%ClickActiveTop% 默认%ClickDefaultTop%
                }
                Critical Off
            } ; (窗口样式=1)
        }
        else if (下移距离>Round(A_ScreenHeight*(600/1080))) and (MoveDownSpeed>1500) ; 关闭窗口
        {
            Critical On

            GoSub 危险操作识别
            if (危险操作=1)
            {
                Return
            }

            WinMove ahk_id %WinID%, , WinXHistory, WinYHistory, WinW, WinH
            WinClose ahk_id %WinID% ;关闭窗口
            WinGetTitle WinTitle, ahk_id %WinID%
            Loop 20
            {
                ToolTip 窗口%WinTitle%已关闭
                Sleep 30
            }
            ToolTip
            Critical Off
        }
        else ; 缩放窗口
        {
            loop
            {
                if !GetKeyState("LButton","P") ;如果鼠标左键松开
                    Break
                Sleep 50
            }

            GoSub 危险操作识别
            if (危险操作=1)
            {
                Return
            }

            CoordMode Mouse, Screen
            MouseGetPos SX, SY
            下移距离:=SY-OldWinSY

            if (OldWinSY>WinTop) and (下移距离<-30*(A_ScreenHeight/1080)) and (SY<=WinTop)
            {
                Critical, on
                窗口贴顶:=1
            }
            Else if (OldWinSY<=WinTop) and (SY<=0)
            {
                Critical, on
                窗口贴顶:=1
            }
            Else
                窗口贴顶:=0

            if (SX>=FJL) and (SX<=FJL+BKXZ) and (危险操作=0) ; 设置快捷键窗口 左
            {
                左边快捷呼出窗口:=WinID
                IniWrite %左边快捷呼出窗口%, Settings.ini, 设置, 左边快捷呼出窗口 ;写入设置到ini文件
                左边快捷呼出窗口X:=WinXHistory
                左边快捷呼出窗口Y:=WinYHistory
                WinMove ahk_id %左边快捷呼出窗口%, , 左边快捷呼出窗口X, 左边快捷呼出窗口Y
                WinSet Style, +0x40000, ahk_id %左边快捷呼出窗口% ;允许调整窗口大小
                WinMinimize ahk_id %左边快捷呼出窗口% ;隐藏窗口
                主动隐藏快捷呼出窗口:=1
                快捷呼出计时:=-1
                Critical Off  
            }
            else if (SX<=FJR) and (SX>=FJR-BKXZ) and (危险操作=0) ; 设置快捷键窗口 右
            {
                右边快捷呼出窗口:=WinID
                IniWrite %右边快捷呼出窗口%, Settings.ini, 设置, 右边快捷呼出窗口 ;写入设置到ini文件
                右边快捷呼出窗口X:=WinXHistory
                右边快捷呼出窗口Y:=WinYHistory
                WinMove ahk_id %右边快捷呼出窗口%, , 右边快捷呼出窗口X, 右边快捷呼出窗口Y
                WinSet Style, +0x40000, ahk_id %右边快捷呼出窗口% ;允许调整窗口大小
                WinMinimize ahk_id %右边快捷呼出窗口% ;隐藏窗口
                主动隐藏快捷呼出窗口:=1
                快捷呼出计时:=-1
                Critical Off  
            }
            else if (SX<=FJL-Round(RSW/5*2+KDXZ/2)) and (窗口贴顶=1) and (危险操作=0) and (WinTitle!="QQ") ;左边屏幕贴顶 最大化
            {
                if (ExtraHeightFit=1)
                {
                    WinMove ahk_id %WinID%, ,YDL ,YDY+ExtraHeight ,SW ,SH-ExtraHeight ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
                }
                else
                {
                    WinMove ahk_id %WinID%, ,YDL ,YDY ,SW ,SH ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
                }

                if (WinExe!="ugraf.exe")
                    WinSet Style, -0x40000, ahk_id %WinID% ;禁止调整窗口大小

                Critical Off  
            }
            else if (SX>=FJL) and (SX<=FJR) and (窗口贴顶=1) and (危险操作=0) and (WinTitle!="QQ") ;中间屏幕贴顶 最大化
            {
                if (ExtraHeightFit=1)
                {
                    WinMove ahk_id %WinID%, ,YDM ,YDY+ExtraHeight ,SW ,SH-ExtraHeight ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
                }
                else
                {
                    WinMove ahk_id %WinID%, ,YDM ,YDY ,SW ,SH ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
                }

                if (WinExe!="ugraf.exe")
                    WinSet Style, -0x40000, ahk_id %WinID% ;禁止调整窗口大小

                Critical Off  
            }
            else if (SX>=FJR+Round(RSW/5*2)) and (窗口贴顶=1) and (危险操作=0) and (WinTitle!="QQ") ;右边屏幕贴右半边顶 最大化
            {
                if (ExtraHeightFit=1)
                {
                    WinMove ahk_id %WinID%, ,YDR ,YDY+ExtraHeight ,SW ,SH-ExtraHeight ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
                }
                else
                {
                    WinMove ahk_id %WinID%, ,YDR ,YDY ,SW ,SH ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
                }

                if (WinExe!="ugraf.exe")
                    WinSet Style, -0x40000, ahk_id %WinID% ;禁止调整窗口大小

                Critical Off  
            }
            else if (SX>FJL-Round(RSW/5*2+KDXZ/2)) and (SX<FJL) and (窗口贴顶=1) and (危险操作=0) and (WinTitle!="QQ") ;左边屏幕贴右半边顶 竖条显示
            {
                if (ExtraHeightFit=1)
                {
                    WinMove ahk_id %WinID%, , FJL-Round(SW/5*2+KDXZ/2), 0-GDXZ/2+ExtraHeight, Round(SW/5*2)+KDXZ, SH+GDXZ-ExtraHeight
                }
                else
                {
                    WinMove ahk_id %WinID%, , FJL-Round(SW/5*2+KDXZ/2), 0-GDXZ/2, Round(SW/5*2)+KDXZ, SH+GDXZ
                }

                WinSet Style, +0x40000, ahk_id %WinID% ;允许调整窗口大小
                Critical Off  
            }
            else if (SX<FJR+Round(RSW/5*2)) and (SX>FJR) and (窗口贴顶=1) and (危险操作=0) and (WinTitle!="QQ") ;右边屏幕贴左半边顶 竖条显示
            {
                if (ExtraHeightFit=1)
                {
                    WinMove ahk_id %WinID%, , FJR-KDXZ/2, 0-GDXZ/2+ExtraHeight, Round(SW/5*2)+KDXZ, SH+GDXZ-ExtraHeight
                }
                else
                {
                    WinMove ahk_id %WinID%, , FJR-KDXZ/2, 0-GDXZ/2, Round(SW/5*2)+KDXZ, SH+GDXZ
                }

                WinSet Style, +0x40000, ahk_id %WinID% ;允许调整窗口大小
                Critical Off  
            }
            else if (SX<=3) and (危险操作=0) and (WinTitle!="QQ") ;and (窗口贴顶=1) ;左边屏幕贴右半边顶 竖条左边填充显示
            {
                if (ExtraHeightFit=1)
                {
                    WinMove ahk_id %WinID%, ,YDL ,YDY+ExtraHeight ,SW-Round(SW/5*2) ,SH-ExtraHeight ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
                }
                else
                {
                    WinMove ahk_id %WinID%, ,YDL ,YDY ,SW-Round(SW/5*2) ,SH ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
                }

                WinSet Style, +0x40000, ahk_id %WinID% ;允许调整窗口大小
                Critical Off  
            }
            else if (SX>=A_ScreenWidth-3) and (危险操作=0) and (WinTitle!="QQ") ;and (窗口贴顶=1) ;右边屏幕贴右半边顶 竖条右边填充显示
            {
                if (ExtraHeightFit=1)
                {
                    WinMove ahk_id %WinID%, , FJR-KDXZ/2+Round(SW/5*2)+KDXZ, 0-GDXZ/2+ExtraHeight, RSW-Round(SW/5*2)+KDXZ, SH+GDXZ-ExtraHeight
                }
                else
                {
                    WinMove ahk_id %WinID%, , FJR-KDXZ/2+Round(SW/5*2)+KDXZ, 0-GDXZ/2, RSW-Round(SW/5*2)+KDXZ, SH+GDXZ
                }

                WinSet Style, +0x40000, ahk_id %WinID% ;允许调整窗口大小
                Critical Off  
            }
            else if (NewWinSY>Round(A_ScreenHeight*(50/1080))) and (NewWinSY-OldWinSY>Round(A_ScreenHeight*(80/1080))) and (WinYHistory<=ExtraHeight) and (WinH>=A_ScreenHeight-ExtraHeight) and (危险操作=0) and (WinTitle!="QQ") ;如果鼠标移动了窗口低于屏幕顶部范围 还原窗口大小
            {
                WinRestore ahk_id %WinID%
                WinMove ahk_id %WinID%, ,SX-Round(SW/5*3/2) ,SY-Round(A_ScreenHeight*(10/1080)) ,Round(SW/5*3) ,Round(SH/5*4) ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
                WinSet Style, +0x40000, ahk_id %WinID% ;允许调整窗口大小
                Critical Off  
            }
            else if (WinW>SW) and (WinH<SH-ExtraHeight) and (危险操作=0) ; 如果窗口宽度大于物理屏幕宽度 修正窗口大小
            {
                WinRestore ahk_id %WinID%
                WinMove ahk_id %WinID%, ,SX-Round(SW/5*3/2) ,SY-Round(A_ScreenHeight*(10/1080)) ,Round(SW/5*3) ,Round(SH/5*4) ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
                WinSet Style, +0x40000, ahk_id %WinID% ;允许调整窗口大小
                Critical Off  
            }
        }
    }

    CoordMode Mouse, Screen ;以屏幕为基准
    MouseGetPos WinSX, WinSY, WinID ;获取鼠标在屏幕中的位置

    ;呼出快捷窗口
    if (WinSX>=FJL) and (WinSX<=FJL+BKXZ) and (左边快捷呼出窗口!="")
    {
        if (WinExist("ahk_id" 左边快捷呼出窗口)=0)
        {
            左边快捷呼出窗口:=""
            IniWrite %左边快捷呼出窗口%, Settings.ini, 设置, 左边快捷呼出窗口 ;写入设置到ini文件
        }
        else
        {
            if (已激活左边快捷呼出窗口=1) ;and (WinActive("ahk_id "左边快捷呼出窗口)!=0) 因为点击边框会导致窗口没被激活
            {
                WinMinimize ahk_id %左边快捷呼出窗口% ;隐藏窗口
                已激活左边快捷呼出窗口:=0
                主动隐藏快捷呼出窗口:=1
                停留呼出左边快捷窗口:=0
                快捷呼出计时:=-1

                loop 20
                {
                    ToolTip 隐藏左边快捷呼出窗口
                    Sleep 30
                }
                ToolTip
            }
            else ;If (已激活左边快捷呼出窗口=0)
            {
                WinActivate ahk_id %左边快捷呼出窗口% ;激活窗口
                已激活左边快捷呼出窗口:=1
                主动隐藏快捷呼出窗口:=0

                if (停留呼出左边快捷窗口=0)
                {
                    loop 20
                    {
                        ToolTip 激活左边快捷呼出窗口
                        Sleep 30
                    }
                    ToolTip
                }
            }
        }
    }
    else if (WinSX<=FJR) and (WinSX>=FJR-BKXZ) and (右边快捷呼出窗口!="")
    {
        if (WinExist("ahk_id" 左边快捷呼出窗口)=0)
        {
            右边快捷呼出窗口:=""
            IniWrite %右边快捷呼出窗口%, Settings.ini, 设置, 右边快捷呼出窗口 ;写入设置到ini文件
        }
        else
        {
            if (已激活右边快捷呼出窗口=1) ;and (WinActive("ahk_id "右边快捷呼出窗口)!=0) 因为点击边框会导致窗口没被激活
            {
                WinMinimize ahk_id %右边快捷呼出窗口% ;隐藏窗口
                已激活右边快捷呼出窗口:=0
                主动隐藏快捷呼出窗口:=1
                停留呼出右边快捷窗口:=0
                快捷呼出计时:=-1

                loop 20
                {
                    ToolTip 隐藏右边快捷呼出窗口
                    Sleep 30
                }
                ToolTip
            }
            else ;If (已激活右边快捷呼出窗口=0)
            {
                WinActivate ahk_id %右边快捷呼出窗口% ;激活窗口
                已激活右边快捷呼出窗口:=1
                主动隐藏快捷呼出窗口:=0

                if (停留呼出右边快捷窗口=0)
                {
                    loop 20
                    {
                        ToolTip 激活右边快捷呼出窗口
                        Sleep 30
                    }
                    ToolTip
                }
            }
        }
    }
    else ; 点击在非边框时候立即刷新状态
    {
        if (WinID!=左边快捷呼出窗口)
        {
            已激活左边快捷呼出窗口:=0
            停留呼出左边快捷窗口:=0
            快捷呼出计时:=-1
        }
        else
        {
            已激活左边快捷呼出窗口:=1
            停留呼出左边快捷窗口:=1
            快捷呼出计时:=-1
        }

        if (WinID!=右边快捷呼出窗口)
        {
            已激活右边快捷呼出窗口:=0
            停留呼出右边快捷窗口:=0 
            快捷呼出计时:=-1
        }
        else
        {
            已激活右边快捷呼出窗口:=1
            停留呼出右边快捷窗口:=1
            快捷呼出计时:=-1
        }
    }
return

+CapsLock::
    WinGetPos AMoveX, AMoveY, AMoveW, AMoveH, A
    CoordMode Mouse, Screen
    MouseGetPos MouseX, MouseY
    ; ToolTip %A_ScreenWidth% %A_ScreenHeight% %FJL% %FJR%

    if (MouseX<Round(AMoveW/2))
        AMoveWinX:=0
    else if (MouseX>Round(FJL-BKXZ/2-AMoveW/2)) and (MouseX<FJL)
        AMoveWinX:=Round(FJL-AMoveW)
    else if (MouseX<=Round(FJL+BKXZ/2+AMoveW/2)) and (MouseX>=FJL)
        AMoveWinX:=Round(FJL+BKXZ)
    else if (MouseX<Round(FJR+BKXZ/2+AMoveW/2)) and (MouseX>FJR)
        AMoveWinX:=FJR
    else if (MouseX>=Round(FJR-BKXZ/2-AMoveW/2)) and (MouseX<=FJR)
        AMoveWinX:=Round(FJR-AMoveW-BKXZ)
    else if (MouseX>Round(A_ScreenWidth-AMoveW/2))
        AMoveWinX:=A_ScreenWidth-AMoveW
    else
        AMoveWinX:=Round(MouseX-AMoveW/2)

    if (MouseY<Round(AMoveH/2))
        AMoveWinY:=0
    else if (MouseY>Round(A_ScreenHeight-AMoveH/2))
        AMoveWinY:=A_ScreenHeight-AMoveH
    else
        AMoveWinY:=Round(MouseY-AMoveH/2)

    WinMove A, , AMoveWinX, AMoveWinY
Return

MoveWinFllowMouse(WinID, InitialW, InitialH)
{
    global SW
    global SH
    global RSW
    global RSH
    global YDY
    global YDL
    global FJL
    global FJR
    global BKXZ

    CoordMode Mouse, Screen
    MouseGetPos MouseX, MouseY
    ; ToolTip %A_ScreenWidth% %A_ScreenHeight% %FJL% %FJR%

    WinRestore ahk_id %WinID%
    if (InitialW>=RSW) and (InitialH>=RSH) ;如果窗口初始大小大于等于物理屏幕大小
    {
        if (MouseX<FJL)
            WinMove ahk_id %WinID%, ,YDL ,YDY ,SW ,SH ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
        if (MouseX>FJR)
            WinMove ahk_id %WinID%, ,YDR ,YDY ,SW ,SH ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
        else if (MouseX>=FJL) and (MouseX<=FJR)
            WinMove ahk_id %WinID%, ,YDM ,YDY ,SW ,SH ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
    }
    else
    {
        if (MouseX<Round(InitialW/2))
            FMoveWinX:=0
        else if (MouseX>Round(FJL-BKXZ/2-InitialW/2)) and (MouseX<FJL)
            FMoveWinX:=Round(FJL-InitialW)
        else if (MouseX<=Round(FJL+BKXZ/2+InitialW/2)) and (MouseX>=FJL)
            FMoveWinX:=Round(FJL+BKXZ)
        else if (MouseX<Round(FJR+BKXZ/2+InitialW/2)) and (MouseX>FJR)
            FMoveWinX:=FJR
        else if (MouseX>=Round(FJR-BKXZ/2-InitialW/2)) and (MouseX<=FJR)
            FMoveWinX:=Round(FJR-InitialW-BKXZ)
        else if (MouseX>Round(A_ScreenWidth-InitialW/2))
            FMoveWinX:=A_ScreenWidth-InitialW
        else
            FMoveWinX:=Round(MouseX-InitialW/2)

        if (MouseY<Round(InitialH/2))
            FMoveWinY:=0
        else if (MouseY>Round(A_ScreenHeight-InitialH/2))
            FMoveWinY:=A_ScreenHeight-InitialH
        else
            FMoveWinY:=Round(MouseY-InitialH/2)

        WinMove ahk_id %WinID%, , FMoveWinX, FMoveWinY
    }
    Return
}

~Tab::  
    ; ToolTip %WinID%`n%WinTopSetting%`n主动%ClickActiveTop% 默认%ClickDefaultTop%
    CoordMode Mouse,Screen
    MouseGetPos TabX, TabY, TabWinID
    ActiveTopNowID:=WinActiveTop[ActiveTopNow]
    WinGetPos ActiveX, ActiveY, ActiveW, ActiveH, ahk_id %ActiveTopNowID%
    ; ToolTip %ActiveTopNow% ID:%ActiveTopNowID%`nX:%ActiveX% Y:%ActiveY% W:%ActiveW% H:%ActiveH%`n%TabX% %TabY%`n
    if (TabX>=ActiveX) and (TabX<=ActiveX+ActiveW) and (TabY>=ActiveY) and (TabY<=ActiveY+ActiveH) ; 如果点击在当前主动顶置窗口内
    {
        WinGet TabTopOpacity, Transparent, ahk_id %ActiveTopNowID%
        if (TabTopOpacity="")
        {
            TabTopOpacity:=255 
        }
        if (TabTopOpacity<255)
        {
            WinGet WinExStyle, ExStyle, ahk_id %ActiveTopNowID%
            if (WinExStyle & 0x20)
            {
                ToolTip 已关闭鼠标穿透
                WinSet ExStyle, -0x20, ahk_id %ActiveTopNowID% ;关闭鼠标穿透
            }
            else
            {
                ToolTip 已打开鼠标穿透
                WinSet ExStyle, +0x20, ahk_id %ActiveTopNowID% ;打开鼠标穿透
            }
        }
    }

    WinGetClass TabClass, A
    WinGet TabProcessName, ProcessName, A
    if (WinActiveTop.Length()>=1) and (TabSwitch=1) and (TabProcessName!="Code.exe") ;如果存在主动顶置窗口
    {
        if (ClickActiveTop=1) ;如果鼠标点击过主动顶置窗口 则从第二个窗口开始顶置显示
        {
            ClickActiveTop:=0
            if (WinActiveTop.Length()>1)
            {
                ActiveTopNow:=2
                ActiveTopNowID:=WinActiveTop[ActiveTopNow]
                WinActivate ahk_id %ActiveTopNowID%
            }
            else
                ActiveTopNow:=1
        }
        else ;如果鼠标没有点击过主动顶置窗口 则从下一个窗口开始顶置显示
        {
            ActiveTopNow:=ActiveTopNow+1
            if (ActiveTopNow>WinActiveTop.Length())
            {
                ActiveTopNow:=1
            }
            ActiveTopNowID:=WinActiveTop[ActiveTopNow]
            WinActivate ahk_id %ActiveTopNowID%
        }
    }
Return

AeroShake:
    摇晃次数:=0
    移动方向:=0 ;向左-1 向右1
    移动距离:=0
    总移动距离:=0
    开始计时:=0
    CoordMode Mouse, Screen ;以屏幕为基准
    MouseGetPos OldAeroShakeX ;获取鼠标在屏幕中的位置
    DllCall("QueryPerformanceFrequency", "Int64*", freq)
    DllCall("QueryPerformanceCounter", "Int64*", LBDownOnTop)
    LBDown:=LBDownOnTop
    Loop ;监测时间1次循环等于0.15秒
    {
        if (开始计时=1)
            上次移动方向:=移动方向

        Sleep 10
        MouseGetPos AeroShakeX ;获取鼠标在屏幕中的位置
        if (开始计时=0) and (AeroShakeX!=OldAeroShakeX)
        {
            开始计时:=1
            DllCall("QueryPerformanceCounter", "Int64*", LBDownOnTop)
            LBDown:=LBDownOnTop
        }
        else if (开始计时=0) and (AeroShakeX=OldAeroShakeX)
            Continue

        if (AeroShakeX-OldAeroShakeX>0) ;向左移动
        {
            移动方向:=-1 ;向左-1 向右1
        }
        else if (AeroShakeX-OldAeroShakeX<0) ;向右移动
        {
            移动方向:=1 ;向左-1 向右1
        }

        if (上次移动方向!=移动方向) and (移动方向!=0) and (开始计时=1) ;移动方向改变过
        {
            移动距离:=Abs(AeroShakeX-OldAeroShakeX)
            总移动距离:=总移动距离+移动距离
            DllCall("QueryPerformanceCounter", "Int64*", LBUp) ;第二次记录时间
            按下时间:=(LBUp-LBDown)/freq*1000 ;按下时间=第二次记录时间-第一次记录时间
            AeroShakeMoveSpeed:=Round(移动距离/按下时间*1000) ;移动速度=移动距离/时间
            if (AeroShakeMoveSpeed>=Round(A_ScreenHeight*(500/1080)))
            {
                ; ToolTip 摇晃次数:%摇晃次数%`n移动距离:%移动距离%`n移动速度:%AeroShakeMoveSpeed%`n`n总移动距离%总移动距离%
                摇晃次数:=摇晃次数+1
            }
            OldAeroShakeX:=AeroShakeX
            DllCall("QueryPerformanceCounter", "Int64*", LBDown) ;第一次记录时间
        }

        DllCall("QueryPerformanceCounter", "Int64*", LBUpOnTop)
        检测时长:=Round((LBUpOnTop-LBDownOnTop)/freq*1000)
        if !GetKeyState("LButton", "P") or (检测时长>2000) ;左键抬起则暂停 或 检测时长大于2000毫秒
        {
            if (摇晃次数=0)
            {
                MouseGetPos AeroShakeX ;获取鼠标在屏幕中的位置
                移动距离:=Abs(AeroShakeX-OldAeroShakeX)
                总移动距离:=总移动距离+移动距离
                DllCall("QueryPerformanceCounter", "Int64*", LBUp) ;第二次记录时间
                按下时间:=(LBUp-LBDown)/freq*1000 ;按下时间=第二次记录时间-第一次记录时间
                AeroShakeMoveSpeed:=Round(移动距离/按下时间)*1000 ;移动速度=移动距离/时间
            }
            break
        }
    }
Return

$MButton:: ;中键
    GoSub 白名单
    gosub 更新数据
    Critical, On
    GoSub 危险操作识别
    DllCall("QueryPerformanceFrequency", "Int64*", freq)
    DllCall("QueryPerformanceCounter", "Int64*", TapBefore)
    if (MButton_presses>0) ;因为键击记录不是0 证明这不是首次按下
    {
        中键按下:=A_TickCount
        Send {MButton Down}
        Loop
        {
            Sleep 10
            if !GetKeyState("MButton", "P")
            {
                Send {MButton Up}
                break
            }
        }
        中键按下:=A_TickCount-中键按下
        if (中键按下<300)
        {
            MButton_presses:=MButton_presses+1 ;所以记录键击次数+1
        }
        Critical, Off
        return
    }
    else ;因为键击记录是0 证明这是首次按下 把键击记录次数设为 1 并启动计时器
    {
        ; ToolTip 关闭后视镜
        WinSet Transparent, 0, ahk_id %MagnifierWindowID%
        WinHide ahk_id %MagnifierWindowID% ;关闭后视镜
        MouseGetPos InitiaMouseX, InitiaMouseY, InitiaWinID  ;获取鼠标在屏幕中的位置
        WinGetPos InitialWinX, InitialWinY, InitialWinW, InitialWinH, ahk_id %InitiaWinID% ;获取窗口位置
        WinActivate ahk_id %InitiaWinID%
        HSJM:=0
        HSJH:=1

        MButton_presses:=1
        if (MButtonHotkey=0)
        {
            if (running=0)
            {
                Send {MButton Down}
                Loop
                {
                    Sleep 10
                    if !GetKeyState("MButton", "P")
                    {
                        Send {MButton Up}
                        break
                    }
                }
            }
            SetTimer KeyMButton, -500 ; 启动在 500 毫秒内等待更多键击的计时器
            Critical Off
            Return
        }

        CoordMode Mouse, Screen ;以屏幕为基准
        MouseGetPos MXOld, MYOld, WinID ;获取鼠标在屏幕中的位置
        WinGetClass WinClass, ahk_id %WinID% ;获取窗口类名

        if (MXOld<FJL)
        {
            屏幕位置:=1
        }
        else if (MXOld>FJR)
        {
            屏幕位置:=3
        }
        else
        {
            屏幕位置:=2
        }

        摇晃次数:=0
        移动方向:=0 ;向左-1 向右1
        移动距离:=0
        总移动距离:=0
        CoordMode Mouse, Screen ;以屏幕为基准
        MouseGetPos MXNew, MYNew, WinID  ;获取鼠标在屏幕中的位置
        WinGetPos WinX, WinY, , , ahk_id %WinID% ;获取窗口位置
        if (MYNew-WinY<WinTop) and (MYNew-WinY>0) ;初次点击又没有点在窗口顶部
            FirstClickTop:=1
        else
            FirstClickTop:=0

        loop ;循环 放大镜功能 窗口传送功能
        {
            上次移动方向:=移动方向
            MXRecor:=MXNew
            Sleep 30
            MouseGetPos MXNew
            ; ToolTip 屏幕位置%屏幕位置%`n%FJL% %MXNew% %FJR%
            移动距离:=Abs(MXNew-MXRecor)
            总移动距离:=总移动距离+移动距离

            if !GetKeyState("MButton", "P")
            {
                break
            }

            if (MXNew-MXRecor>0)
            {
                移动方向:=1 ;向左-1 向右1
            }
            else if (MXNew-MXRecor<0)
            {
                移动方向:=-1 ;向左-1 向右1
            }

            if (上次移动方向!=移动方向) ;移动方向改变过
            {
                摇晃次数:=摇晃次数+1
            }

            if (摇晃次数>3) and (总移动距离>=Round(A_ScreenHeight*(800/1080))) ;按下滚轮时打开放大镜 Win+加号
            {
                FDJM:=1
                Critical, Off
                ; ToolTip 打开放大镜
                if (FDJ=0)
                {
                    SetTimer 放大镜, -1
                    SetTimer 打开放大镜, -1
                    FDJ:=1
                }
                else
                {
                    SetTimer 打开放大镜, -1
                }

                Hotkey ~Shift, On
                Hotkey ~Ctrl, On
                Loop
                {
                    if !GetKeyState("MButton", "P") ;抬起中键时关闭放大镜 Win+Esc
                    {
                        Hotkey ~Shift, Off
                        Hotkey ~Ctrl, Off
                        break
                    }  
                }

                ; ToolTip 关闭放大镜
                FDJ:=0
                FDJM:=0
                SetTimer 关闭放大镜, -1
                SetTimer 关闭提示, -300 ;300毫秒后关闭提示

                MButton_presses:=0 ;键击记录重置为0
                return
            }

            if (MYOld>ScreenBottom) ;音量调整功能
            {
                YLTZ:=0 ;音量调整状态
                Loop
                {
                    增加音量:=MXOld+5
                    降低音量:=MXOld-5
                    Sleep 30
                    MouseGetPos MXNew

                    if (MXNew>增加音量) ;向右滑动 增加音量
                    {
                        YLTZ:=1
                        MXOld:=MXNew
                        Send {Volume_Up}
                        SoundGet 音量
                        音量:=Round(音量)
                        ToolTip 增加音量+%音量%
                    }
                    else if (MXNew<降低音量) ;向左滑动 增加音量
                    {
                        YLTZ:=1
                        MXOld:=MXNew
                        Send {Volume_Down}
                        SoundGet 音量
                        音量:=Round(音量)
                        ToolTip 降低音量-%音量%
                    }

                    if !GetKeyState("MButton", "P")
                    {
                        if (MXNew<增加音量) and (MXNew>降低音量) and (YLTZ=0) ;没有滑动且没有调整过音量 播放/暂停媒体
                        {
                            if (媒体快捷键=0)
                            {
                                媒体快捷键:=1
                                Hotkey Left, On
                                Hotkey Right, On
                                Hotkey Up, On
                                Hotkey Down, On
                                ToolTip 媒体快捷键已打开
                            }
                            else
                            {
                                ToolTip 播放/暂停媒体
                                Send {Media_Play_Pause}
                            }
                        }
                        MButton_presses:=0 ;键击记录重置为0
                        SetTimer 关闭提示, -500 ;500毫秒后关闭提示
                        Critical Off
                        Return
                    }
                }
            }
        }

        ; ToolTip %危险操作%
        if (屏幕位置=1) and (危险操作!=1)
        {
            if (MXNew>FJR) ;左边屏幕 到 右边屏幕
            {
                ; ToolTip 左边屏幕 到 右边屏幕
                if (WinID=MiniWinIDL)
                {
                    MiniWinIDR:=WinID
                    IniWrite %MiniWinIDR%, Settings.ini, 设置, 右边屏幕最近一次被最小化的窗口 ;写入设置到ini文件
                    MiniWinIDL:=0
                    IniWrite %MiniWinIDL%, Settings.ini, 设置, 左边屏幕最近一次被最小化的窗口 ;写入设置到ini文件
                }
                else if (WinID=MasterWinIDL)
                {
                    MasterWinIDR:=WinID
                    IniWrite %MasterWinIDR%, Settings.ini, 设置, 右边屏幕主窗口 ;写入设置到ini文件
                    MasterWinIDL:=0
                    IniWrite %MasterWinIDL%, Settings.ini, 设置, 左边屏幕主窗口 ;写入设置到ini文件
                }

                WinGetTitle ActiveWindowID, ahk_id %WinID% ;根据句柄获取窗口的名字
                ToolTip 发送%ActiveWindowID%窗口到右边屏幕
                WinRestore ahk_id %WinID%
                if (InitialWinW>=RSW) and (InitialWinH>=RSH) ;如果窗口初始大小大于等于物理屏幕大小
                    WinMove ahk_id %WinID%, ,YDR ,YDY ,SW ,SH ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
                else
                    MoveWinFllowMouse(InitiaWinID, InitialWinW, InitialWinH)
                WinActivate ahk_id %WinID% ; 激活窗口
                SetTimer 关闭提示, -500 ;500毫秒后关闭提示
                MButton_presses:=0 ;键击记录重置为0
                Critical, Off

                HSJM:=1
                HSJH:=0
                WinShow ahk_id %MagnifierWindowID% ;打开后视镜
                WinMove ahk_id %MagnifierWindowID%, , HSJRX, HSJY
                WinSet Transparent, 255, ahk_id %MagnifierWindowID%
                return
            }
            else if (MXNew>=FJL) ;左边屏幕 到 中间屏幕
            {
                ; ToolTip 左边屏幕 到 中间屏幕
                if (WinID=MiniWinIDL)
                {
                    MiniWinIDM:=WinID
                    IniWrite %MiniWinIDM%, Settings.ini, 设置, 中间屏幕最近一次被最小化的窗口 ;写入设置到ini文件
                    MiniWinIDL:=0
                    IniWrite %MiniWinIDL%, Settings.ini, 设置, 左边屏幕最近一次被最小化的窗口 ;写入设置到ini文件
                }
                else if (WinID=MasterWinIDL)
                {
                    MasterWinIDM:=WinID
                    IniWrite %MasterWinIDM%, Settings.ini, 设置, 中间屏幕主窗口 ;写入设置到ini文件
                    MasterWinIDL:=0
                    IniWrite %MasterWinIDL%, Settings.ini, 设置, 左边屏幕主窗口 ;写入设置到ini文件
                }

                WinGetTitle ActiveWindowID, ahk_id %WinID% ;根据句柄获取窗口的名字
                ToolTip 发送%ActiveWindowID%窗口到中间屏幕
                WinRestore ahk_id %WinID%
                if (InitialWinW>=RSW) and (InitialWinH>=RSH) ;如果窗口初始大小大于等于物理屏幕大小
                    WinMove ahk_id %WinID%, ,YDM ,YDY ,SW ,SH ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
                else
                    MoveWinFllowMouse(InitiaWinID, InitialWinW, InitialWinH)
                WinActivate ahk_id %WinID% ; 激活窗口
                SetTimer 关闭提示, -500 ;500毫秒后关闭提示
                MButton_presses:=0 ;键击记录重置为0
                Critical, Off
                return
            }
            else ;依然在左边屏幕不变
            {
                MoveWinFllowMouse(InitiaWinID, InitialWinW, InitialWinH)
                Critical, Off
                HSJM:=1
                HSJH:=0
                WinShow ahk_id %MagnifierWindowID% ;打开后视镜
                WinMove ahk_id %MagnifierWindowID%, , HSJLX, HSJY
                WinSet Transparent, 255, ahk_id %MagnifierWindowID%
            }
        }
        else if (屏幕位置=2) and (危险操作!=1)
        {
            if (MXNew<FJL) ;中间屏幕 到 左边屏幕
            {
                ; ToolTip 中间屏幕 到 左边屏幕
                if (WinID=MiniWinIDM)
                {
                    MiniWinIDL:=WinID
                    IniWrite %MiniWinIDL%, Settings.ini, 设置, 左边屏幕最近一次被最小化的窗口 ;写入设置到ini文件
                    MiniWinIDM:=0
                    IniWrite %MiniWinIDM%, Settings.ini, 设置, 中间屏幕最近一次被最小化的窗口 ;写入设置到ini文件
                }
                else if (WinID=MasterWinIDM)
                {
                    MasterWinIDL:=WinID
                    IniWrite %MasterWinIDL%, Settings.ini, 设置, 左边屏幕主窗口 ;写入设置到ini文件
                    MasterWinIDM:=0
                    IniWrite %MasterWinIDM%, Settings.ini, 设置, 中间屏幕主窗口 ;写入设置到ini文件
                }

                WinGetTitle ActiveWindowID, ahk_id %WinID% ;根据句柄获取窗口的名字
                ToolTip 发送%ActiveWindowID%窗口到左边屏幕
                WinRestore ahk_id %WinID%
                if (InitialWinW>=RSW) and (InitialWinH>=RSH) ;如果窗口初始大小大于等于物理屏幕大小
                    WinMove ahk_id %WinID%, ,YDL ,YDY ,SW ,SH ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
                else
                    MoveWinFllowMouse(InitiaWinID, InitialWinW, InitialWinH)
                WinActivate ahk_id %WinID% ; 激活窗口
                SetTimer 关闭提示, -500 ;500毫秒后关闭提示
                MButton_presses:=0 ;键击记录重置为0
                Critical, Off

                HSJM:=1
                HSJH:=0
                WinShow ahk_id %MagnifierWindowID% ;打开后视镜
                WinMove ahk_id %MagnifierWindowID%, , HSJLX, HSJY
                WinSet Transparent, 255, ahk_id %MagnifierWindowID%
                return
            }
            else if (MXNew>FJR) ;中间屏幕 到 右边屏幕
            {
                ; ToolTip 中间屏幕 到 右边屏幕
                if (WinID=MiniWinIDM)
                {
                    MiniWinIDR:=WinID
                    IniWrite %MiniWinIDR%, Settings.ini, 设置, 右边屏幕最近一次被最小化的窗口 ;写入设置到ini文件
                    MiniWinIDM:=0
                    IniWrite %MiniWinIDM%, Settings.ini, 设置, 中间屏幕最近一次被最小化的窗口 ;写入设置到ini文件
                }
                else if (WinID=MasterWinIDM)
                {
                    MasterWinIDR:=WinID
                    IniWrite %MasterWinIDR%, Settings.ini, 设置, 右边屏幕主窗口 ;写入设置到ini文件
                    MasterWinIDM:=0
                    IniWrite %MasterWinIDM%, Settings.ini, 设置, 中间屏幕主窗口 ;写入设置到ini文件
                }

                WinGetTitle ActiveWindowID, ahk_id %WinID% ;根据句柄获取窗口的名字
                ToolTip 发送%ActiveWindowID%窗口到右边屏幕
                WinRestore ahk_id %WinID%
                if (InitialWinW>=RSW) and (InitialWinH>=RSH) ;如果窗口初始大小大于等于物理屏幕大小
                    WinMove ahk_id %WinID%, ,YDR ,YDY ,SW ,SH ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
                else
                    MoveWinFllowMouse(InitiaWinID, InitialWinW, InitialWinH)
                WinActivate ahk_id %WinID% ; 激活窗口
                SetTimer 关闭提示, -500 ;500毫秒后关闭提示
                MButton_presses:=0 ;键击记录重置为0
                Critical, Off

                HSJM:=1
                HSJH:=0
                WinShow ahk_id %MagnifierWindowID% ;打开后视镜
                WinMove ahk_id %MagnifierWindowID%, , HSJRX, HSJY
                WinSet Transparent, 255, ahk_id %MagnifierWindowID%
                return
            }
            else ;依然在 中间屏幕 不变
            {
                MoveWinFllowMouse(InitiaWinID, InitialWinW, InitialWinH)
                Critical, Off
            }
        }
        else if (屏幕位置=3) and (危险操作!=1)
        {
            if (MXNew<FJL) ;右边屏幕 到 左边屏幕
            {
                ; ToolTip 右边屏幕 到 左边屏幕
                if (WinID=MiniWinIDR)
                {
                    MiniWinIDL:=WinID
                    IniWrite %MiniWinIDL%, Settings.ini, 设置, 左边屏幕最近一次被最小化的窗口 ;写入设置到ini文件
                    MiniWinIDR:=0
                    IniWrite %MiniWinIDR%, Settings.ini, 设置, 右边屏幕最近一次被最小化的窗口 ;写入设置到ini文件
                }
                else if (WinID=MasterWinIDR)
                {
                    MasterWinIDL:=WinID
                    IniWrite %MasterWinIDL%, Settings.ini, 设置, 左边屏幕主窗口 ;写入设置到ini文件
                    MasterWinIDR:=0
                    IniWrite %MasterWinIDR%, Settings.ini, 设置, 右边屏幕主窗口 ;写入设置到ini文件
                }

                WinGetTitle ActiveWindowID, ahk_id %WinID% ;根据句柄获取窗口的名字
                ToolTip 发送%ActiveWindowID%窗口到左边屏幕
                WinRestore ahk_id %WinID%
                if (InitialWinW>=RSW) and (InitialWinH>=RSH) ;如果窗口初始大小大于等于物理屏幕大小
                    WinMove ahk_id %WinID%, ,YDL ,YDY ,SW ,SH ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
                else
                    MoveWinFllowMouse(InitiaWinID, InitialWinW, InitialWinH)
                WinActivate ahk_id %WinID% ; 激活窗口
                SetTimer 关闭提示, -500 ;500毫秒后关闭提示
                MButton_presses:=0 ;键击记录重置为0
                Critical, Off

                HSJM:=1
                HSJH:=0
                WinShow ahk_id %MagnifierWindowID% ;打开后视镜
                WinMove ahk_id %MagnifierWindowID%, , HSJLX, HSJY
                WinSet Transparent, 255, ahk_id %MagnifierWindowID%
                return
            }
            else if (MXNew<=FJR) ;右边屏幕 到 中间屏幕
            {
                ; ToolTip 右边屏幕 到 中间屏幕
                if (WinID=MiniWinIDR)
                {
                    MiniWinIDM:=WinID
                    IniWrite %MiniWinIDM%, Settings.ini, 设置, 中间屏幕最近一次被最小化的窗口 ;写入设置到ini文件
                    MiniWinIDR:=0
                    IniWrite %MiniWinIDR%, Settings.ini, 设置, 右边屏幕最近一次被最小化的窗口 ;写入设置到ini文件
                }
                else if (WinID=MasterWinIDR)
                {
                    MasterWinIDM:=WinID
                    IniWrite %MasterWinIDM%, Settings.ini, 设置, 中间屏幕主窗口 ;写入设置到ini文件
                    MasterWinIDR:=0
                    IniWrite %MasterWinIDR%, Settings.ini, 设置, 右边屏幕主窗口 ;写入设置到ini文件
                }

                WinGetTitle ActiveWindowID, ahk_id %WinID% ;根据句柄获取窗口的名字
                ToolTip 发送%ActiveWindowID%窗口到中间屏幕
                WinRestore ahk_id %WinID%
                if (InitialWinW>=RSW) and (InitialWinH>=RSH) ;如果窗口初始大小大于等于物理屏幕大小
                    WinMove ahk_id %WinID%, ,YDM ,YDY ,SW ,SH ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
                else
                    MoveWinFllowMouse(InitiaWinID, InitialWinW, InitialWinH)
                WinActivate ahk_id %WinID% ; 激活窗口
                SetTimer 关闭提示, -500 ;500毫秒后关闭提示
                MButton_presses:=0 ;键击记录重置为0
                Critical, Off
                return
            }
            else ;依然在右边屏幕不变
            {
                MoveWinFllowMouse(InitiaWinID, InitialWinW, InitialWinH)
                Critical, Off
                HSJM:=1
                HSJH:=0
                WinShow ahk_id %MagnifierWindowID% ;打开后视镜
                WinMove ahk_id %MagnifierWindowID%, , HSJRX, HSJY
                WinSet Transparent, 255, ahk_id %MagnifierWindowID%
            }
        }

        CoordMode Mouse, Window ;以窗口为基准
        MouseGetPos, , WY, WinID ;获取鼠标在窗口中的位置
        WinGetClass WinClass, ahk_id %WinID% ;获取窗口类名
        WinGetTitle WinTitle, ahk_id %WinID% ;获取窗口类名
        DllCall("QueryPerformanceCounter", "Int64*", TapAfter)
        按下时间:=(TapAfter-TapBefore)/freq*1000, 2 ;长按时间检测
        if (按下时间>500) ;长按时间大于500ms将当前窗口超大化
        {
            if (MButtonHotkey=0)
            {
                Return
            }
            else if (WY<WinTop) and (FirstClickTop=1) and (危险操作=0) ;点击位置在窗口顶部
            {
                WinGetPos, , , WinW, WinH, ahk_id %WinID%
                if (WinW<A_ScreenWidth) or (WinH<A_ScreenHeight)
                {
                    WinRestore ahk_id %WinID%
                    WinMove ahk_id %WinID%, ,0-KDXZ/2 ,0 ,A_ScreenWidth+KDXZ ,A_ScreenHeight+GDXZ ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度

                    if (WinExe!="ugraf.exe")
                        WinSet Style, -0x40000, ahk_id %WinID% ;禁止调整窗口大小

                    WinActivate ahk_id %WinID% ; 激活窗口
                    ToolTip 将%WinTitle%窗口超大化
                    SetTimer 关闭提示, -500 ;500毫秒后关闭提示
                }
            }
            MButton_presses:=0 ;键击记录重置为0
        }
        else
        {
            WinGetPos, , , WinWidth, WinHeight, ahk_id %WinID%
            if (WinHeight>=A_ScreenHeight) and (WinWidth>=A_ScreenWidth) and (WY<WinTop) and (FirstClickTop=1) and (危险操作=0) ;如果窗口已经超大化
            {
                WinGet WinExStyle, Style, ahk_id %WinID%
                if (WinExStyle & 0xC00000)
                {
                    WinSet Style, -0xC00000, ahk_id %WinID%  ; 切换窗口的标题栏显示或隐藏
                    loop 20
                    {
                        ToolTip 已隐藏%WinTitle%超大化窗口的标题栏
                        Sleep 30
                    }
                    ToolTip
                }
                else
                {
                    WinSet Style, +0xC00000, ahk_id %WinID%  ; 切换窗口的标题栏显示或隐藏
                    loop 20
                    {
                        ToolTip 已显示%WinTitle%超大化窗口的标题栏
                        Sleep 30
                    }
                    ToolTip
                }
                ; WinSet Style, ^0xC00000, ahk_id %WinID%  ; 切换窗口的标题栏显示或隐藏
                WinMove ahk_id %WinID%, ,0-KDXZ/2 ,0 ,A_ScreenWidth+KDXZ ,A_ScreenHeight+GDXZ ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
                ; WinSet, Redraw ,, ahk_id %WinID%  ; 刷新窗口
            }
            else if (WY<WinTop) and (FirstClickTop=1) ;点击位置在窗口顶部
            {
                Send {MButton}
            }
            SetTimer KeyMButton, -300 ; 启动在 300 毫秒内等待更多键击的计时器
        }
    }
    Critical, Off
return

KeyMButton: ;计时器
    CoordMode Mouse, Window ;以窗口为基准
    MouseGetPos, , WY ;获取鼠标在窗口中的位置
    if (MButton_presses=1) and (running=1) and (WY>WinTop) ;此键按下了一次 软件正在运行中 没有点击在窗口顶部
    {
        if (MButtonHotkey=0)
        {
            Return
        }

        ; ToolTip 屏幕实时位置%屏幕实时位置%`n`n左边屏幕主窗口:%MasterWinIDL%`n左边屏幕最近最小化:%MiniWinIDL%`n`n中间屏幕主窗口:%MasterWinIDM%`n中间屏幕最近最小化:%MiniWinIDM%`n`n右边屏幕主窗口:%MasterWinIDR%`n右边屏幕最近最小化:%MiniWinIDR%, , ,2
        if (屏幕实时位置=1) ;鼠标在左边屏幕 有左边最小化窗口的历史记录
        {
            If (WinActive("ahk_id" MasterWinIDL)=0) and (MasterWinIDL!=0) ;主窗口
            {
                if (WinExist("ahk_id" MasterWinIDL)!=0)
                {
                    WinGet 窗口状态, MinMax, ahk_id %MasterWinIDL%
                    if (窗口状态=-1)
                    {
                        WinRestore ahk_id %MasterWinIDL% ;还原左边主窗口
                    }
                    else
                    {
                        WinActivate ahk_id %MasterWinIDL%
                    }
                    WinGetTitle ActiveWindowID, ahk_id %MasterWinIDL% ;根据句柄获取窗口的名字
                    ToolTip L-还原左边屏幕%ActiveWindowID%主窗口
                }
                else
                {
                    MasterWinIDL:=0
                    IniWrite %MasterWinIDL%, Settings.ini, 设置, 左边屏幕主窗口 ;写入设置到ini文件
                }
            }
            else If (WinActive("ahk_id" MiniWinIDL)=0) and (MiniWinIDL!=0) ;被最小化的窗口
            {
                if (WinExist("ahk_id" MiniWinIDL)!=0)
                {
                    WinGet 窗口状态, MinMax, ahk_id %MiniWinIDL%
                    if (窗口状态=-1)
                    {
                        WinRestore ahk_id %MiniWinIDL% ;还原最近被最小化左边窗口
                    }
                    else
                    {
                        WinActivate ahk_id %MiniWinIDL%
                    }
                    WinGetTitle ActiveWindowID, ahk_id %MiniWinIDL% ;根据句柄获取窗口的名字
                    ToolTip L-还原左边屏幕最近最小化%ActiveWindowID%窗口
                }
                else
                {
                    MiniWinIDL:=0
                    IniWrite %MiniWinIDL%, Settings.ini, 设置, 左边屏幕最近一次被最小化的窗口 ;写入设置到ini文件
                }
            }
        }
        else if (屏幕实时位置=2) ;鼠标在中间屏幕 有中间最小化窗口的历史记录
        {
            If (WinActive("ahk_id" MasterWinIDM)=0) and (MasterWinIDM!=0) ;主窗口
            {
                if (WinExist("ahk_id" MasterWinIDM)!=0)
                {
                    WinGet 窗口状态, MinMax, ahk_id %MasterWinIDM%
                    if (窗口状态=-1)
                    {
                        WinRestore ahk_id %MasterWinIDM% ;还原中间主窗口
                    }
                    else
                    {
                        WinActivate ahk_id %MasterWinIDM%
                    }
                    WinGetTitle ActiveWindowID, ahk_id %MasterWinIDM% ;根据句柄获取窗口的名字
                    ToolTip M-还原中间屏幕%ActiveWindowID%主窗口
                }
                else
                {
                    MasterWinIDM:=0
                    IniWrite %MasterWinIDM%, Settings.ini, 设置, 中间屏幕主窗口 ;写入设置到ini文件
                }
            }
            else If (WinActive("ahk_id" MiniWinIDM)=0) and (MiniWinIDM!=0) ;被最小化的窗口
            {
                if (WinExist("ahk_id" MiniWinIDM)!=0)
                {
                    WinGet 窗口状态, MinMax, ahk_id %MiniWinIDM%
                    if (窗口状态=-1)
                    {
                        WinRestore ahk_id %MiniWinIDM% ;还原最近被最小化中间窗口
                    }
                    else
                    {
                        WinActivate ahk_id %MiniWinIDM%
                    }
                    WinGetTitle ActiveWindowID, ahk_id %MiniWinIDM% ;根据句柄获取窗口的名字
                    ToolTip M-还原中间屏幕最近最小化%ActiveWindowID%窗口
                }
                else
                {
                    MiniWinIDL:=0
                    IniWrite %MiniWinIDM%, Settings.ini, 设置, 中间屏幕最近一次被最小化的窗口 ;写入设置到ini文件
                }
            }
        }
        else if (屏幕实时位置=3) ;鼠标在右边屏幕 有右边最小化窗口的历史记录 
        {
            If (WinActive("ahk_id" MasterWinIDR)=0) and (MasterWinIDR!=0) ;主窗口
            {
                if (WinExist("ahk_id" MasterWinIDR)!=0)
                {
                    WinGet 窗口状态, MinMax, ahk_id %MasterWinIDR%
                    if (窗口状态=-1)
                    {
                        WinRestore ahk_id %MasterWinIDR% ;还原右边主窗口
                    }
                    else
                    {
                        WinActivate ahk_id %MasterWinIDR%
                    }
                    WinGetTitle ActiveWindowID, ahk_id %MasterWinIDR% ;根据句柄获取窗口的名字
                    ToolTip R-还原右边屏幕%ActiveWindowID%主窗口
                }
                else
                {
                    MasterWinIDM:=0
                    IniWrite %MasterWinIDR%, Settings.ini, 设置, 右边屏幕主窗口 ;写入设置到ini文件
                }
            }
            else If (WinActive("ahk_id" MiniWinIDR)=0) and (MiniWinIDR!=0) ;被最小化的窗口
            {
                if (WinExist("ahk_id" MiniWinIDR)!=0)
                {
                    WinGet 窗口状态, MinMax, ahk_id %MiniWinIDR%
                    if (窗口状态=-1)
                    {
                        WinRestore ahk_id %MiniWinIDR% ;还原最近被最小化右边窗口
                    }
                    else
                    {
                        WinActivate ahk_id %MiniWinIDR%
                    }
                    WinGetTitle ActiveWindowID, ahk_id %MiniWinIDR% ;根据句柄获取窗口的名字
                    ToolTip R-还原右边屏幕最近最小化%ActiveWindowID%窗口
                }
                else
                {
                    MiniWinIDL:=0
                    IniWrite %MiniWinIDR%, Settings.ini, 设置, 右边屏幕最近一次被最小化的窗口 ;写入设置到ini文件
                }
            }
        }

        SetTimer 关闭提示, -300 ;300毫秒后关闭提示
    }
    else if (MButton_presses>=2) and (MYOld>WinTop) ;此键按下了两次及以上
    {
        gosub 暂停运行
    }
    MButton_presses:=0 ;键击记录重置为0 下次键击重新开始记录是否双击
return

; ~^c:: ;Ctrl+C
Critical, On
MouseGetPos, , WY, WinID ;获取鼠标在窗口中的位置
WinGetClass WinClass, ahk_id %WinID% ;获取窗口类名
if (WY<WinTop) ;点击位置在窗口顶部
{
    BlackList:=" or (WinClass=双引号窗口类名双引号)" ;黑名单格式
    StringReplace BlackList, BlackList, 双引号,`" ,A ;“ 双引号 ”替换为“ " ”
    StringReplace BlackList, BlackList, 窗口类名,%WinClass% ,A ;填入刚刚获取的窗口类名
    Clipboard:=BlackList ;黑名单复制到剪贴板
    loop 20
    {
        ToolTip 已复制当前窗口类名到剪贴板
        Sleep 30
    }
    ToolTip ;关闭提示
}
Critical, Off
return

; ~#Space::
KeyWait Space
WinGet win_id, , A
thread_id := DllCall("GetWindowThreadProcessId", "UInt", win_id, "UInt", 0)
输入法 := DllCall("GetKeyboardLayout", "UInt", thread_id)
if (输入法=67699721)
{
    ToolTip 中文输入法 ;%输入法%
}
else if (输入法=134481924)
{
    ToolTip 英文输入法 ;%输入法%
}
SetTimer 关闭提示, -800 ;800毫秒后关闭提示
Return

关闭提示:
    ToolTip
return

基础功能:
    MsgBox, ,基础功能 ,在窗口顶部`n      拨动滚轮最大或最小化当前窗口`n      如果最大化过大请加入白名单`n      长按中键窗口填满整个屏幕`n      填满后短按中键可以切换标题栏显示或隐藏`n在最大化窗口顶部`n      鼠标左键点住快速往下拖关闭窗口`n      拖离屏幕顶部缩小窗口至适合大小`n      窗口拖动到靠近主屏幕顶部设为条状贴边`n在窗口任意位置`n      按住中键并拖动窗口可以移动窗口`n      Shift`+Capslock 将当前激活的窗口移到鼠标位置`n在屏幕底部`n      拨动滚轮最大或最小化全部窗口`n      打开兼容模式将会以输出快捷键方式`n设置主窗口`n      在窗口顶部按下Shif`+左键设置主窗口`n呼出窗口`n      按中键可以呼出主窗口或最近一次最小化的窗口`n      优先呼出设置的主窗口`n`n双击中键`n      暂停运行`n      再次双击恢复运行`n`n黑钨重工出品 免费开源 请勿商用 侵权必究`n更多免费教程尽在`nQQ频道AutoHotKey12`nQQ5群793083640`nhttps://github.com/Furtory
return

进阶功能:
    MsgBox, ,进阶功能 ,在非最大化窗口顶部`n      鼠标左键按住左右摇晃让窗口总是顶置`n      再次摇晃可以取消窗口总是顶置`n在总是顶置的窗口内`n      Ctrl`+左键按住 上下滑动调整透明度`n      仅可调整主动总是顶置窗口的透明度`n      你可以左右摇晃原本总是顶置的窗口加入主动窗口列表内`n      Tab键 允许鼠标穿透半透明窗口`n在总是顶置的窗口外`n      Tab键 轮流切换显示主动顶置的窗口`n`n按住中键的时候`n      左右晃动鼠标打开放大镜`n      放大镜激活期间按下Shift或者Ctrl改变缩放倍率`n      放大后如果太模糊打开锐化算法`n      抬起中键后关闭放大镜`n`n贴顶激活窗口`n      Ctrl`+鼠标左键单击窗口顶部设置`n      当鼠标贴着屏幕顶部一段时间后激活`n`n自动暂停名单`n      Alt`+鼠标左键单击窗口顶部设置自动暂停窗口`n`n快捷呼出窗口`n      按住窗口顶部拖动至分界线内以设置`n      再次点击分界线可以激活快捷窗口`n      悬停在分界线上可以暂时呼出快捷窗口`n`n神隐窗口`n      鼠标移动到神隐窗口内会自动降低透明度`n      并且鼠标允许穿透窗口`n      按住Alt可以操作穿透窗口`n`n飘逸窗口`n      鼠标移动到飘逸窗口内会自动移动窗口防止遮挡
return

兼容说明:
    MsgBox, ,兼容说明 ,因为软件部分功能实现需要劫持中键`n      想输出中键请双击中键后保持按住`n      在窗口顶部点击中键不会被劫持`n`n窗口找回`n      将超出屏幕范围的窗口移动到屏幕内`n`n高效模式`n      加快后视镜加载速度`n      但是会增加后台占用`n`n黑名单`n      不允许本软件控制大小缩放`n      以防缩放动态壁纸等危险软件`n`n白名单`n      缩放没有问题的软件请加入白名单`n      这样窗口就不会比屏幕大导致显示不全`n`n其他说明`n      本软件功能实现方式为调用Windows API`n      不用担心快捷键占用问题`n      可以强制缩放一些不允许手动调整的窗口`n      如果窗口位置调不回来重启电脑即可`n      本软件不包含任何恶意代码请放心使用
return

屏幕设置:
    If (WinExist("屏幕设置")!=0)
    {
        WinActivate 屏幕设置
        Return
    }
    Critical, On
    白名单:=0
    gosub 更新数据
    OldBKXZ:=BKXZ
    OldGDXZ:=GDXZ
    OldKDXZ:=KDXZ
    Gui 屏幕设置:+DPIScale -MinimizeBox -MaximizeBox -Resize -SysMenu
    Gui 屏幕设置:Font, s9, Segoe UI
    Gui 屏幕设置:Add, Picture, x-3 y-97 w1000 h600, %A_ScriptDir%\3屏示意图.jpg
    Gui 屏幕设置:Add, Button, x778 y361 w94 h51 G屏幕设置确认, &确认
    Gui 屏幕设置:Add, Button, x877 y361 w94 h51 G屏幕设置取消, &取消

    Gui 屏幕设置:Add, Text, x387 y19 w120 h23 +0x200, 边框宽度
    Gui 屏幕设置:Add, Edit, x387 y42 w120 h21 Number vBKXZ, %BKXZ%

    Gui 屏幕设置:Add, Text, x700 y168 w120 h23 +0x200, 屏幕额外高度
    Gui 屏幕设置:Add, Edit, x699 y191 w122 Number vGDXZ, %GDXZ%

    Gui 屏幕设置:Add, Text, x438 y338 w120 h23 +0x200, 屏幕额外宽度
    Gui 屏幕设置:Add, Edit, x438 y361 w120 h21 Number vKDXZ, %KDXZ%

    Gui 屏幕设置:Show, w995 h433, 屏幕设置
    Critical, Off
Return

屏幕设置确认:
    Gui 屏幕设置:Submit, NoHide
    Gui 屏幕设置:Destroy
    IniWrite %BKXZ%, Settings.ini, 设置, 边框修正 ;写入设置到ini文件
    IniWrite %KDXZ%, Settings.ini, 设置, 宽度修正 ;写入设置到ini文件
    IniWrite %GDXZ%, Settings.ini, 设置, 高度修正 ;写入设置到ini文件
    GoSub 白名单
    gosub 更新数据
return

屏幕设置取消:
    BKXZ:=OldBKXZ
    GDXZ:=OldGDXZ
    KDXZ:=OldKDXZ
    Gui 屏幕设置:Destroy
return

开机自启: ;模式切换
    Critical, On
    if (autostart=1) ;关闭开机自启动
    {
        IfExist, % autostartLnk ;如果开机启动的文件存在
        {
            FileDelete %autostartLnk% ;删除开机启动的文件
        }

        autostart:=0
        Menu Tray, UnCheck, 开机自启 ;右键菜单不打勾
    }
    else ;开启开机自启动
    {
        IfExist, % autostartLnk ;如果开机启动的文件存在
        {
            FileGetShortcut %autostartLnk%, lnkTarget ;获取开机启动文件的信息
            if (lnkTarget!=A_ScriptFullPath) ;如果启动文件执行的路径和当前脚本的完整路径不一致
            {
                FileCreateShortcut %A_ScriptFullPath%, %autostartLnk%, %A_WorkingDir% ;将启动文件执行的路径改成和当前脚本的完整路径一致
            }
        }
        else ;如果开机启动的文件不存在
        {
            FileCreateShortcut %A_ScriptFullPath%, %autostartLnk%, %A_WorkingDir% ;创建和当前脚本的完整路径一致的启动文件
        }

        autostart:=1
        Menu Tray, Check, 开机自启 ;右键菜单打勾
    }
    Critical, Off
return

管理权限: ;模式切换
    Critical, On
    if (AdminMode=1)
    {
        AdminMode:=0
        IniWrite %AdminMode%, Settings.ini, 设置, 管理权限 ;写入设置到ini文件
        Menu Tray, UnCheck, 管理权限 ;右键菜单不打勾
        Critical, Off
        Reload
    }
    else
    {
        AdminMode:=1
        IniWrite %AdminMode%, Settings.ini, 设置, 管理权限 ;写入设置到ini文件
        Menu Tray, Check, 管理权限 ;右键菜单打勾
        Critical, Off
        Reload
    }
return

兼容模式: ;模式切换
    Critical, On
    if (CompatibleMode=1)
    {
        CompatibleMode:=0
        IniWrite %CompatibleMode%, Settings.ini, 设置, 兼容模式 ;写入设置到ini文件
        Menu Tray, UnCheck, 兼容模式 ;右键菜单不打勾
    }
    else
    {
        CompatibleMode:=1
        IniWrite %CompatibleMode%, Settings.ini, 设置, 兼容模式 ;写入设置到ini文件
        Menu Tray, Check, 兼容模式 ;右键菜单打勾
    }
    Critical, Off
return

顶置轮切: ;模式切换
    Critical, On
    if (TabSwitch=1)
    {
        TabSwitch:=0
        IniWrite %TabSwitch%, Settings.ini, 设置, 顶置轮切 ;写入设置到ini文件
        Menu Tray, UnCheck, 顶置轮切 ;右键菜单不打勾
    }
    else
    {
        TabSwitch:=1
        IniWrite %TabSwitch%, Settings.ini, 设置, 顶置轮切 ;写入设置到ini文件
        Menu Tray, Check, 顶置轮切 ;右键菜单打勾
    }
    Critical, Off
return

窗口找回:
    Critical, On
    ; 遍历所有窗口
    WinGet idList, List
    Loop, %idList%
    {
        ; 获取窗口句柄
        thisID := idList%A_Index%
        WinGetClass WinClass, ahk_id %thisID%
        WinGetTitle WinTitle, ahk_id %thisID% ;获取窗口类名
        WinGet WinExe, ProcessName, ahk_id %thisID%
        GoSub 危险操作识别

        ; 获取窗口的位置和大小
        WinGetPos winX, winY, winWidth, winHeight, ahk_id %thisID%

        ; 检查窗口是否超出屏幕范围，并调整位置
        if (winWidth>RSW) or (winHeight>RSH)
        {
            if (危险操作=0)
            {
                白名单:=0
                gosub 更新数据

                if (winWidth<A_ScreenWidth)
                {
                    if (winX < 0-Round(KDXZ/2))
                        YDX:=YDL
                    else if (winX + winWidth > A_ScreenWidth+Round(KDXZ/2))
                        YDX:=YDR
                    else
                        YDX:=YDM
                    WinMove ahk_id %thisID%, ,YDX ,YDY ,SW ,SH ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
                }
                else
                {
                    白名单:=1
                    gosub 更新数据

                    WinMove ahk_id %thisID%, ,0-KDXZ/2 ,0 ,A_ScreenWidth+KDXZ ,A_ScreenHeight+GDXZ ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
                }
            }
        }
        else
        {
            if (winX < 0)
                winX := 0
            else if (winX + winWidth > A_ScreenWidth)
                winX := A_ScreenWidth - winWidth

            if (winY < 0)
                winY := 0
            else if (winY + winHeight > A_ScreenHeight)
                winY := A_ScreenHeight - winHeight
        }

        ; 移动窗口到新的位置
        WinMove ahk_id %thisID%, , %winX%, %winY%
    }
    Critical, Off
return

媒体快捷:
    If (WinExist("媒体快捷键设置")!=0)
    {
        WinActivate 媒体快捷键设置
        Return
    }
    旧上组合键:=上组合键
    旧下组合键:=下组合键
    Gui 快捷键:+DPIScale -MinimizeBox -MaximizeBox -Resize -SysMenu
    Gui 快捷键:Font, s9, Segoe UI
    Gui 快捷键:Add, Text, x14 y13 w210 h281 +Left, 在屏幕底部`n   按住中键左右移动 调整音量`n   单击中键 播放`/暂停媒体`n`n同时按下左右箭头 暂停/继续播放`n双击左箭头 上一曲`n双击右箭头 下一曲`n双击上箭头 喜欢歌曲`n双击下箭头桌面歌词`n`n上下箭头长按 设置`/清除播放器后`n同时按下上下箭头 呼出`/关闭播放器`n`n临时输出原义按键长按箭头`n长按左右箭头关闭媒体快捷键`n在屏幕底部点击中键重新打开`n`n请保证以下设置和播放器一致
    Gui 快捷键:Add, Button, x15 y424 w69 h25 G媒体快捷重置, &重置
    Gui 快捷键:Add, Button, x83 y424 w69 h25 G媒体快捷确认, &确认
    Gui 快捷键:Add, Button, x151 y424 w69 h25 G媒体快捷取消, &取消
    Gui 快捷键:Add, Text, x58 y295 w120 h25 +0x200, 喜欢歌曲
    Gui 快捷键:Add, Hotkey, x58 y320 w120 h25 v上组合键, %上组合键%
    Gui 快捷键:Add, Text, x58 y355 w120 h25 +0x200, 桌面歌词
    Gui 快捷键:Add, Hotkey, x58 y380 w120 h25 v下组合键, %下组合键%
    Gui 快捷键:Show, w234 h466, 媒体快捷键设置
Return

媒体快捷重置:
    上组合键:=""
    下组合键:=""
    GuiControl 快捷键:, 上组合键, ""
    GuiControl 快捷键:, 下组合键, ""
return

媒体快捷确认:
    Gui 快捷键:Submit, NoHide
    Gui 快捷键:Destroy
    IniWrite %上组合键%, Settings.ini, 设置, 双击箭头上输出组合键 ;写入设置到ini文件
    IniWrite %下组合键%, Settings.ini, 设置, 双击箭头下输出组合键 ;写入设置到ini文件
return

媒体快捷取消:
    上组合键:=旧上组合键
    下组合键:=旧下组合键
    Gui 快捷键:Destroy
return

神隐窗口:
    if (running=1)
        SetTimer 屏幕监测, Off

    if (HSJ=1)
    {
        ; ToolTip 关闭后视镜
        WinSet Transparent, 0, ahk_id %MagnifierWindowID%
        WinHide ahk_id %MagnifierWindowID%
        HSJM:=0
    }

    KeyWait LButton
    Critical, on

    if (AutoHideWindow="") or (AutoHideWindow="ERROR")
    {
        AutoHideType:=1
        AutoHideMode:=1 ; 1=完全匹配 2=包含
        防误触:=0
        loop
        {
            MouseGetPos, , , WinID
            ; WinActivate ahk_id %WinID%
            WinGetTitle WinTitle, ahk_id %WinID%
            WinGetClass WinClass, ahk_id %WinID%
            WinGet WinExe, ProcessName, ahk_id %WinID%

            if (AutoHideType=1)
                AutoHideToolTip:="当前窗口Title:" . WinTitle
            Else if (AutoHideType=2)
                AutoHideToolTip:="当前窗口Class:" . WinClass
            Else if (AutoHideType=3)
                AutoHideToolTip:="当前窗口Exe:" . WinExe

            if (AutoHideMode=1)
                AutoHideToolTip.=" 完全匹配"
            else if (AutoHideMode=2)
                AutoHideToolTip.=" 包含内容"

            GoSub 危险操作识别
            if (危险操作=1)
            {
                ToolTip 当前窗口不可设置!`n请重新尝试其他窗口
                Sleep 30
                Continue
            }
            else
            {
                AutoHideToolTip.= "`n点击左键确定添加到神隐窗口 点击Esc键退出神隐窗口设置`n点击Ctrl键切换类型 点击Shift键切换匹配模式"
                ToolTip %AutoHideToolTip% %防误触%
            }

            if (防误触=1)
            {
                if GetKeyState("Ctrl", "P") or GetKeyState("Shift", "P")
                {
                    Sleep 30
                    Continue
                }
                else if !GetKeyState("Ctrl", "P") and !GetKeyState("Shift", "P")
                {
                    防误触:=0
                }
            }

            if GetKeyState("Ctrl", "P")
            {
                防误触:=1
                AutoHideType:=AutoHideType+1
                if (AutoHideType>3)
                    AutoHideType:=1
            }
            else if GetKeyState("Shift", "P")
            {
                防误触:=1
                if (AutoHideMode=2)
                    AutoHideMode:=1
                else ;if (AutoHideMode=1)
                    AutoHideMode:=2

            }
            else if GetKeyState("Esc", "P")
            {
                ToolTip
                Break
            }
            else if GetKeyState("Lbutton", "P")
            {
                if (AutoHideMode=1)
                    AutoHideWindow:="Same "
                else if (AutoHideMode=2)
                    AutoHideWindow:="Include "

                if (AutoHideType=1)
                {
                    AutoHideWindow.="Title==="
                    AutoHideWindow.=WinTitle
                }
                else if (AutoHideType=2)
                {
                    AutoHideWindow.="Class==="
                    AutoHideWindow.=WinClass
                }
                else if (AutoHideType=3)
                {
                    AutoHideWindow.="Exe==="
                    AutoHideWindow.=WinExe
                }
                ToolTip
                Sleep 100

                ; ToolTip, 包含项%包含项%`n当前特征%当前特征%

                if (AutoHideMode=2)
                {
                    InputBox AutoHideWindow, 神隐窗口设置, 匹配模式作为开头并跟随空格 匹配模式有 Same完全匹配 Include包含内容`n请用 “===” 分隔开 匹配类型 和 匹配特征`n匹配类型有 Title Class Exe`n举例: Include Title===窗口标题 表示:匹配窗口标题包含内容为"窗口标题"的窗口, , A_ScreenHeight, 200, , , Locale, ,%AutoHideWindow%
                    if !ErrorLevel
                        IniWrite %AutoHideWindow%, Settings.ini, Settings, 神隐窗口 ;写入设置到ini文件
                    else
                        IniRead AutoHideWindow, Settings.ini, Settings, 神隐窗口 ;写入设置到ini文件
                }
                else
                    IniWrite %AutoHideWindow%, Settings.ini, 设置, 神隐窗口 ;写入设置到ini文件

                窗口控制(AutoHideWindow, AutoHideMode, 1, 255, 0, "")

                Menu Tray, Check, 神隐窗口
                loop 20
                {
                    ToolTip %AutoHideWindow%已设为神隐窗口
                    Sleep 30
                }
                ToolTip
                Break
            }
        }
    }
    else
    {
        Menu Tray, UnCheck, 神隐窗口
        窗口控制(AutoHideWindow, AutoHideMode, 0, 255, 0, "")

        AutoHideWindow:=""
        IniWrite %AutoHideWindow%, Settings.ini, 设置, 神隐窗口 ;写入设置到ini文件
    }

    if (running=1)
        SetTimer 屏幕监测, 50
    Critical, Off
Return

窗口控制(识别特征, 匹配方式, 顶置状态, 透明度, 鼠标穿透, 移动Y)
{
    global ControlWindowID
    包含项位置:=InStr(识别特征, "===")+3
    包含项:=SubStr(识别特征, 包含项位置)

    ; 遍历所有窗口
    匹配特征:=""
    WinGet idList, List
    Loop, %idList%
    {
        ; 获取当前窗口的ID
        thisID := idList%A_Index%

        ; 获取当前窗口的信息
        匹配成功:=0
        if (InStr(识别特征, "Title")!=0)
        {
            ; 检查类名是否包含指定的内容
            类型:="标题"
            WinGetTitle 当前特征, ahk_id %thisID%
            if (当前特征=包含项) and (匹配方式=1) ;完全匹配
                匹配成功:=1
            else if (InStr(当前特征, 包含项)!=0) and (匹配方式=2) ;包含
                匹配成功:=1
        }
        else if (InStr(识别特征, "Class")!=0)
        {
            ; 检查类名是否包含指定的内容
            类型:="类名"
            WinGetClass 当前特征, ahk_id %thisID%
            if (当前特征=包含项) and (匹配方式=1) ;完全匹配
                匹配成功:=1
            else if (InStr(当前特征, 包含项)!=0) and (匹配方式=2) ;包含
                匹配成功:=1
        }
        else if (InStr(识别特征, "Exe")!=0)
        {
            ; 检查类名是否包含指定的内容
            类型:="进程名"
            WinGet 当前特征, ProcessName, ahk_id %thisID%
            if (当前特征=包含项) and (匹配方式=1) ;完全匹配
                匹配成功:=1
            else if (InStr(当前特征, 包含项)!=0) and (匹配方式=2) ;包含
                匹配成功:=1
        }

        匹配特征.=匹配成功 . 类型 . " " . 当前特征 . "`n" ;记录匹配特征
        if (匹配成功=1)
        {
            ControlWindowID:=thisID

            if (顶置状态!="")
                WinSet AlwaysOnTop, %顶置状态%, ahk_id %thisID%  ;切换窗口的顶置状态

            if (透明度!="")
                WinSet Transparent, %透明度%, ahk_id %thisID%

            if (鼠标穿透=1)
                WinSet ExStyle, +0x20, ahk_id %thisID% ;开启鼠标穿透
            else if (鼠标穿透=0)
                WinSet ExStyle, -0x20, ahk_id %thisID% ;关闭鼠标穿透

            if (移动Y!="") ;and (移动窗口=1)
                WinMove ahk_id %thisID%, , , 移动Y ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度

            Break
        }
    }

    ; ToolTip 方式%匹配方式% 次数%idList% %识别特征%`n识别特征: %包含项%`n当前特征:`n%匹配特征%`n顶置%顶置状态% 透明度%透明度% 穿透%鼠标穿透% 移动%移动Y%, , ,2
    ; ToolTip ControlWindowID%ControlWindowID%`n顶置%顶置状态% 透明度%透明度% 穿透%鼠标穿透% 移动%移动Y%, , ,2
    Return ControlWindowID
}

飘逸窗口:
    if (running=1)
        SetTimer 屏幕监测, Off

    if (HSJ=1)
    {
        ; ToolTip 关闭后视镜
        WinSet Transparent, 0, ahk_id %MagnifierWindowID%
        WinHide ahk_id %MagnifierWindowID%
        HSJM:=0
    }

    KeyWait LButton
    Critical, on

    if (AutoMoveWindow="") or (AutoMoveWindow="ERROR")
    {
        AutoMoveType:=1
        AutoMoveMode:=1 ; 1=完全匹配 2=包含
        防误触:=0
        loop
        {
            MouseGetPos, , , WinID
            ; WinActivate ahk_id %WinID%
            WinGetTitle WinTitle, ahk_id %WinID%
            WinGetClass WinClass, ahk_id %WinID%
            WinGet WinExe, ProcessName, ahk_id %WinID%

            if (AutoMoveType=1)
                AutoMoveToolTip:="当前窗口Title:" . WinTitle
            Else if (AutoMoveType=2)
                AutoMoveToolTip:="当前窗口Class:" . WinClass
            Else if (AutoMoveType=3)
                AutoMoveToolTip:="当前窗口Exe:" . WinExe

            if (AutoMoveMode=1)
                AutoMoveToolTip.=" 完全匹配"
            else if (AutoMoveMode=2)
                AutoMoveToolTip.=" 包含内容"

            GoSub 危险操作识别
            if (危险操作=1) and (WinClass!="DesktopLyrics")
            {
                ToolTip 当前窗口不可设置!`n请重新尝试其他窗口
                Sleep 30
                Continue
            }
            else
            {
                AutoMoveToolTip.= "`n点击左键确定添加到飘逸窗口 点击Esc键退出飘逸窗口设置`n点击Ctrl键切换类型 点击Shift键切换匹配模式"
                ToolTip %AutoMoveToolTip% %防误触%
            }

            if (防误触=1)
            {
                if GetKeyState("Ctrl", "P") or GetKeyState("Shift", "P")
                {
                    Sleep 30
                    Continue
                }
                else if !GetKeyState("Ctrl", "P") and !GetKeyState("Shift", "P")
                {
                    防误触:=0
                }
            }

            if GetKeyState("Ctrl", "P")
            {
                防误触:=1
                AutoMoveType:=AutoMoveType+1
                if (AutoMoveType>3)
                    AutoMoveType:=1
            }
            else if GetKeyState("Shift", "P")
            {
                防误触:=1
                if (AutoMoveMode=2)
                    AutoMoveMode:=1
                else ;if (AutoMoveMode=1)
                    AutoMoveMode:=2

            }
            else if GetKeyState("Esc", "P")
            {
                ToolTip
                Break
            }
            else if GetKeyState("Lbutton", "P")
            {
                if (AutoMoveMode=1)
                    AutoMoveWindow:="Same "
                else if (AutoMoveMode=2)
                    AutoMoveWindow:="Include "

                if (AutoMoveType=1)
                {
                    AutoMoveWindow.="Title==="
                    AutoMoveWindow.=WinTitle
                }
                else if (AutoMoveType=2)
                {
                    AutoMoveWindow.="Class==="
                    AutoMoveWindow.=WinClass
                }
                else if (AutoMoveType=3)
                {
                    AutoMoveWindow.="Exe==="
                    AutoMoveWindow.=WinExe
                }
                ToolTip
                Sleep 100

                ; ToolTip, 包含项%包含项%`n当前特征%当前特征%

                if (AutoMoveMode=2)
                {
                    InputBox AutoMoveWindow, 飘逸窗口设置, 匹配模式作为开头并跟随空格 匹配模式有 Same完全匹配 Include包含内容`n请用 “===” 分隔开 匹配类型 和 匹配特征`n匹配类型有 Title Class Exe`n举例: Include Title===窗口标题 表示:匹配窗口标题包含内容为"窗口标题"的窗口, , A_ScreenHeight, 200, , , Locale, ,%AutoMoveWindow%
                    if !ErrorLevel
                        IniWrite %AutoMoveWindow%, Settings.ini, Settings, 飘逸窗口 ;写入设置到ini文件
                    else
                        IniRead AutoMoveWindow, Settings.ini, Settings, 飘逸窗口 ;写入设置到ini文件
                }
                else
                    IniWrite %AutoMoveWindow%, Settings.ini, 设置, 飘逸窗口 ;写入设置到ini文件

                窗口控制(AutoMoveWindow, AutoMoveMode, "", "", "", "")
                WinGetPos AutoMoveWinX, AutoMoveWinY, AutoMoveWinWidth, AutoMoveWinHeight, ahk_id %AutoMoveWindowID%

                Menu Tray, Check, 飘逸窗口
                loop 20
                {
                    ToolTip %AutoMoveWindow%已设为飘逸窗口
                    Sleep 30
                }
                ToolTip
                Break
            }
        }
    }
    else
    {
        Menu Tray, UnCheck, 飘逸窗口
        窗口控制(AutoMoveWindow, AutoMoveMode, "", "", "", AutoMoveWinY)

        AutoMoveWindow:=""
        IniWrite %AutoMoveWindow%, Settings.ini, 设置, 飘逸窗口 ;写入设置到ini文件
    }

    if (running=1)
        SetTimer 屏幕监测, 50
    Critical, Off
Return

标签页适配: ;模式切换
    Critical, On
    if (ExtraHeightFit=1)
    {
        ExtraHeightFit:=0
        ExtraHeight:=0
        IniWrite %ExtraHeightFit%, Settings.ini, 设置, 标签页适配 ;写入设置到ini文件
        Menu Tray, UnCheck, 标签页适配 ;右键菜单不打勾
    }
    else
    {
        ExtraHeightFit:=1
        ExtraHeight:=Round(A_ScreenHeight*(25/1080))

        InputBox ExtraHeight, 标签页高度适配, 请输入标签页的高度(单位:像素)`n最大化会留出空间用于显示标签页, , , 170, , , Locale, ,%ExtraHeight%
        if !ErrorLevel
        {
            if (ExtraHeight<=0)
                ExtraHeight:=1

            IniWrite %ExtraHeight%, Settings.ini, 设置, 标签页适配高度 ;写入设置到ini文件
        }
        else
            IniRead ExtraHeight, Settings.ini, 设置, 标签页适配高度 ;写入设置到ini文件

        IniWrite %ExtraHeightFit%, Settings.ini, 设置, 标签页适配 ;写入设置到ini文件
        Menu Tray, Check, 标签页适配 ;右键菜单打勾
    }
    Critical, Off
return

初始化记录:
    MiniWinIDL:=0
    MiniWinIDM:=0
    MiniWinIDR:=0
    IniWrite %MiniWinIDL%, Settings.ini, 设置, 左边屏幕最近一次被最小化的窗口 ;写入设置到ini文件
    IniWrite %MiniWinIDM%, Settings.ini, 设置, 中间屏幕最近一次被最小化的窗口 ;写入设置到ini文件
    IniWrite %MiniWinIDR%, Settings.ini, 设置, 右边屏幕最近一次被最小化的窗口 ;写入设置到ini文件

    MasterWinIDL:=0
    MasterWinIDM:=0
    MasterWinIDR:=0
    IniWrite %MasterWinIDL%, Settings.ini, 设置, 左边屏幕主窗口 ;写入设置到ini文件
    IniWrite %MasterWinIDM%, Settings.ini, 设置, 中间屏幕主窗口 ;写入设置到ini文件
    IniWrite %MasterWinIDR%, Settings.ini, 设置, 右边屏幕主窗口 ;写入设置到ini文件
Return

高效模式: ;模式切换
    Critical, On
    if (高效模式=1)
    {
        高效模式:=0
        IniWrite %高效模式%, Settings.ini, 设置, 高效模式 ;写入设置到ini文件
        Menu Tray, UnCheck, 高效模式 ;右键菜单不打勾
    }
    else
    {
        高效模式:=1
        IniWrite %高效模式%, Settings.ini, 设置, 高效模式 ;写入设置到ini文件
        Menu Tray, Check, 高效模式 ;右键菜单打勾
    }
    Critical, Off
return

暂停运行: ;模式切换
    Critical, On
    if (running=0)
    {
        Menu Tray, Icon, %A_ScriptDir%\Running.ico ;任务栏图标改成正在运行
        running:=1
        MButtonHotkey:=1 ;打开中键的部分功能
        Hotkey WheelUp, On ;打开滚轮上的热键
        Hotkey WheelDown, On ;打开滚轮下的热键
        Hotkey LButton, On ;打开左键的热键
        Hotkey Tab, On ;打开Tab键的热键
        Hotkey Up, On ;打开箭头上键的热键
        Hotkey Down, On ;打开箭头下键的热键
        Hotkey Left, On ;打开箭头左键的热键
        Hotkey Right, On ;打开箭头右键的热键
        Hotkey ~^LButton, On ;打开Ctrl+左键的热键
        Hotkey ~+LButton, On ;打开Shift+左键的热键
        Hotkey ~!LButton, On ;打开Alt+左键的热键
        ; Hotkey ^c, On ;打开Ctrl+C的热键
        ; SetTimer 自动隐藏任务栏, Delete

        if (HSJ=1)
        {
            CoordMode Mouse, Screen ;以屏幕为基准
            MouseGetPos ReloadX, ReloadY
            ; MsgBox, ReloadX%ReloadX% ReloadY%ReloadY%
            if (ReloadX<FJL) or (ReloadX>FJR) ;如果在左侧屏幕或者在右侧屏幕
            {
                HSJM:=0
                HSJH:=0
                WinShow ahk_id %MagnifierWindowID% ;打开后视镜

                if (HSJM=0) and (ReloadX<FJL) ;如果在左侧屏幕
                {
                    WinMove ahk_id %MagnifierWindowID%, , HSJLX, HSJY
                    HSJM:=1
                }
                else if (HSJM=0) and (ReloadX>FJR) ;如果在右侧屏幕
                {
                    WinMove ahk_id %MagnifierWindowID%, , HSJRX, HSJY
                    HSJM:=1
                }

                WinSet Transparent, 255, ahk_id %MagnifierWindowID%
            }
        }

        ; SetTimer 屏幕监测, 50
        Menu Tray, UnCheck, 暂停运行 ;右键菜单不打勾

        if (Alt自动暂停=1)
        {
            ToolTip 自动恢复运行
        }
        else
        {
            ToolTip 分屏助手恢复运行
        }
    }
    else
    {
        Menu Tray, Icon, %A_ScriptDir%\Stopped.ico ;任务栏图标改成暂停运行
        running:=0
        MButtonHotkey:=0 ;关闭中键的部分功能
        Hotkey WheelUp, Off ;关闭滚轮上的热键
        Hotkey WheelDown, Off ;关闭滚轮下的热键
        Hotkey LButton, Off ;关闭左键的热键
        Hotkey Tab, Off ;关闭Tab键的热键
        Hotkey Up, Off ;关闭箭头上键的热键
        Hotkey Down, Off ;关闭箭头下键的热键
        Hotkey Left, Off ;关闭箭头左键的热键
        Hotkey Right, Off ;关闭箭头右键的热键
        Hotkey ~^LButton, Off ;关闭Ctrl+左键的热键
        Hotkey ~+LButton, Off ;关闭Shift+左键的热键
        Hotkey ~!LButton, Off ;关闭Alt+左键的热键
        ; Hotkey ^c, Off ;关闭Ctrl+C的热键
        if (Alt自动暂停=1)
        {
            WinGet TaskbarID, ID, ahk_class Shell_TrayWnd ;获取任务栏句柄
            DllCall("ShowWindow", "Ptr", TaskbarID, "Int", 0) ; 隐藏任务栏
        }
        else
        {
            ; SetTimer 屏幕监测, Delete
            ; SetTimer 自动隐藏任务栏, 50
        }
        WinSet Transparent, 0, ahk_id %MagnifierWindowID%
        WinHide ahk_id %MagnifierWindowID% ;关闭后视镜
        HSJM:=0
        Menu Tray, Check, 暂停运行 ;右键菜单打勾

        if (Alt自动暂停=1)
        {
            ToolTip 自动暂停运行
        }
        else
        {
            ToolTip 分屏助手暂停运行
        }
    }
    SetTimer 关闭提示, -500 ;500毫秒后关闭提示
    loop 10
    {
        if !GetKeyState("MButton", "P")
        {
            Send {MButton Up}
        }
        Sleep 10
    }
    Critical, Off
return

重启软件:
    if (AutoMoveWindow!="") and (AutoMoveWindow!="ERROR") and (AutoMoveWinX!="") and (AutoMoveWinY!="") and (AutoMoveWinWidth!="") and (AutoMoveWinHeight!="")
    {
        窗口控制(AutoMoveWindow, AutoMoveMode, "", "", "", AutoMoveWinY) ;还原飘逸窗口
    }
Reload
Return

退出软件:
    Critical, On
    if (AutoHideWindow!="") and (AutoHideWindow!="ERROR")
    {
        窗口控制(AutoHideWindow, AutoHideMode, 0, 255, 0, "") ;关闭神隐窗口
    }
    if (AutoMoveWindow!="") and (AutoMoveWindow!="ERROR") and (AutoMoveWinX!="") and (AutoMoveWinY!="") and (AutoMoveWinWidth!="") and (AutoMoveWinHeight!="")
    {
        窗口控制(AutoMoveWindow, AutoMoveMode, "", "", "", AutoMoveWinY) ;还原飘逸窗口
    }
    DllCall("gdi32.dll\DeleteDC", UInt,hdc_frame )
    DllCall("gdi32.dll\DeleteDC", UInt,hdd_frame )
    DllCall("magnification.dll\MagUninitialize")
    DllCall("gdiplus\GdiplusShutdown", Ptr, pToken)
    if hModule := DllCall("GetModuleHandle", "Str", "gdiplus", Ptr)
    {
        DllCall("FreeLibrary", Ptr, hModule)
    }
    Gui 后视镜:Destroy
    WinShow ahk_class Shell_TrayWnd ;显示任务栏
    Critical, Off
ExitApp

Left::
    if GetKeyState("Right", "P")
    {
        Return
    }
    SetTimer KeyMedia, -1
Return

Right::
    if GetKeyState("Left", "P")
    {
        Return
    }
    SetTimer KeyMedia, -1
Return

Up::
    if GetKeyState("Down", "P")
    {
        Return
    }
    SetTimer KeyMedia, -1
Return

Down::
    if GetKeyState("Up", "P")
    {
        Return
    }
    SetTimer KeyMedia, -1
Return

KeyMedia:
    双击限时:=200
    if (KeyMediaDown="")
    {
        DllCall("QueryPerformanceFrequency", "Int64*", freq)
        DllCall("QueryPerformanceCounter", "Int64*", KeyMediaDown)
        最近按键:=A_PriorKey
    }
    else
    {
        DllCall("QueryPerformanceCounter", "Int64*", KeyMediaUp)
        媒体快捷键按下时长:=Round((KeyMediaUp-KeyMediaDown)/freq*1000, 2)
        if (媒体快捷键按下时长>双击限时) ;超过限时 重新记录按下时间
        {
            DllCall("QueryPerformanceFrequency", "Int64*", freq)
            DllCall("QueryPerformanceCounter", "Int64*", KeyMediaDown)
            最近按键:="无"
        }
        else
        {
            最近按键:=A_PriorKey
        }
    }

    Loop
    {
        DllCall("QueryPerformanceCounter", "Int64*", KeyMediaUp)
        媒体快捷键按下时长:=Round((KeyMediaUp-KeyMediaDown)/freq*1000, 2)
        ; ToolTip 媒体快捷键按下时长%媒体快捷键按下时长%ms 最近按键%最近按键%, , ,2

        if (最近按键="Left") and (媒体快捷键按下时长<=双击限时) and GetKeyState("Left", "P") and !GetKeyState("Right", "P") and !GetKeyState("Up", "P") and !GetKeyState("Down", "P")
        {
            Send {Media_Prev}
            if (WinExist("ahk_id "MagnifierWindowID)=0) ;后视镜窗口不存在
            {
                Loop
                {
                    ToolTip 上一曲
                    Sleep 30

                    if !GetKeyState("Left", "P")
                    {
                        Loop, 20
                        {
                            ToolTip 上一曲
                            Sleep 30
                        }
                        ToolTip
                        break
                    }
                }
                break
            }
            else ;后视镜窗口存在
            {
                ToolTipText:="上一曲"
            }
        }
        else if (最近按键="Right") and (媒体快捷键按下时长<=双击限时) and !GetKeyState("Left", "P") and GetKeyState("Right", "P") and !GetKeyState("Up", "P") and !GetKeyState("Down", "P")
        {
            Send {Media_Next}
            if (WinExist("ahk_id "MagnifierWindowID)=0) ;后视镜窗口不存在
            {
                Loop
                {
                    ToolTip 下一曲
                    Sleep 30

                    if !GetKeyState("Right", "P")
                    {
                        Loop 20
                        {
                            ToolTip 下一曲
                            Sleep 30
                        }
                        ToolTip
                        break
                    }
                }
            }
            else ;后视镜窗口存在
            {
                ToolTipText:="下一曲"
            }
        }
        else if (最近按键="Up") and (媒体快捷键按下时长<=双击限时) and !GetKeyState("Left", "P") and !GetKeyState("Right", "P") and GetKeyState("Up", "P") and !GetKeyState("Down", "P")
        {
            Send %上组合键%
            if (WinExist("ahk_id "MagnifierWindowID)=0) ;后视镜窗口不存在
            {
                Loop
                {
                    ToolTip 喜欢歌曲
                    Sleep 30

                    if !GetKeyState("Up", "P")
                    {
                        Loop 20
                        {
                            ToolTip 喜欢歌曲
                            Sleep 30
                        }
                        ToolTip
                        break
                    }
                }
            }
            else ;后视镜窗口存在
            {
                ToolTipText:="喜欢歌曲"
            }
        }
        else if (最近按键="Down") and (媒体快捷键按下时长<=双击限时) and !GetKeyState("Left", "P") and !GetKeyState("Right", "P") and !GetKeyState("Up", "P") and GetKeyState("Down", "P")
        {
            Send %下组合键%
            if (WinExist("ahk_id "MagnifierWindowID)=0) ;后视镜窗口不存在
            {
                Loop
                {
                    ToolTip 桌面歌词
                    Sleep 30

                    if !GetKeyState("Down", "P")
                    {
                        Loop 20
                        {
                            ToolTip 桌面歌词
                            Sleep 30
                        }
                        ToolTip
                        break
                    }
                }
            }
            else ;后视镜窗口存在
            {
                ToolTipText:="桌面歌词"
            }
        }
        else if GetKeyState("Left", "P") and GetKeyState("Right", "P") and (媒体快捷键按下时长<=双击限时)
        {
            DllCall("QueryPerformanceFrequency", "Int64*", freq)
            DllCall("QueryPerformanceCounter", "Int64*", KeyDown_Lefty_Right)
            Loop  
            {
                DllCall("QueryPerformanceCounter", "Int64*", KeyUp_Lefty_Right)
                媒体快捷键按下时长:=Round((KeyUp_Lefty_Right-KeyDown_Lefty_Right)/freq*1000, 2)
                ; ToolTip LR
                if (媒体快捷键按下时长>1000) and (媒体快捷键=1)
                {
                    媒体快捷键:=0
                    Hotkey Left, Off
                    Hotkey Right, Off
                    Hotkey Up, Off
                    Hotkey Down, Off
                    if (WinExist("ahk_id "MagnifierWindowID)=0) ;后视镜窗口不存在
                    {
                        Loop 20
                        {
                            ToolTip 媒体快捷键已关闭
                            Sleep 30
                        }
                    }
                    else ;后视镜窗口存在
                    {
                        ToolTipText:="媒体快捷键已关闭"
                    }
                    ToolTip
                    Break
                }
                else if !GetKeyState("Left", "P") and !GetKeyState("Right", "P")
                {
                    ; ToolTip %媒体快捷键% %媒体快捷键按下时长%
                    Send {Media_Play_Pause}
                    Break
                }
                Sleep 10
            }
        }
        else if GetKeyState("Up", "P") and GetKeyState("Down", "P") and (媒体快捷键按下时长<=双击限时)
        {
            DllCall("QueryPerformanceFrequency", "Int64*", freq)
            DllCall("QueryPerformanceCounter", "Int64*", KeyDown_Up_Down)
            Loop
            {
                ; ToolTip UD
                if !GetKeyState("Up", "P") and !GetKeyState("Down", "P")
                {
                    DllCall("QueryPerformanceCounter", "Int64*", KeyUp_Up_Down)
                    清除播放器快捷呼出设置记录时间:=Round((KeyUp_Up_Down-KeyDown_Up_Down)/freq*1000, 2)
                    if (清除播放器快捷呼出设置记录时间>2000) and (MediaWindow!="") ;如果按下时长超过2秒，则清除快捷呼出设置
                    {
                        MediaWindow:=""
                        IniWrite %MediaWindow%, Settings.ini, 设置, 呼出播放器 ;写入设置到ini文件
                        if (WinExist("ahk_id "MagnifierWindowID)=0) ;后视镜窗口不存在
                        {
                            Loop 20
                            {
                                ToolTip 已清除播放器快捷呼出设置
                                Sleep 30
                            }
                        }
                        else ;后视镜窗口存在
                        {
                            ToolTipText:=清除播放器快捷呼出设置记录时间 . "已清除播放器快捷呼出设置"
                        }
                        ToolTip
                        Break
                    }
                    else
                    {
                        MouseGetPos, , , WinID ;获取鼠标所在窗口的句柄
                        WinGetClass WindowID, ahk_id %WinID% ;根据句柄获取窗口的名字
                        if (MediaWindow="") or (MediaWindow="ERROR")
                        {
                            MouseGetPos, , , WinID_Media ;获取鼠标所在窗口的句柄
                            WinGetClass MediaWindow, ahk_id %WinID_Media% ;根据句柄获取窗口的名字

                            if (MediaWindow!="_cls_desk_") and (MediaWindow!="Shell_TrayWnd") and (MediaWindow!="WorkerW")
                            {
                                IniWrite %MediaWindow%, Settings.ini, 设置, 呼出播放器 ;写入设置到ini文件

                                if (WinExist("ahk_id "MagnifierWindowID)=0) ;后视镜窗口不存在
                                {
                                    Loop 20
                                    {
                                        ToolTip 已设置%MediaWindow%为播放器快捷呼出
                                        Sleep 30
                                    }
                                }
                                else ;后视镜窗口存在
                                {
                                    ToolTipText:="已设置" . MediaWindow . "为播放器快捷呼出"
                                }
                                ToolTip
                            }
                        }
                        else if (WindowID!=MediaWindow)
                        {
                            WinActivate ahk_class %MediaWindow%
                            WinShow ahk_class %MediaWindow%

                            if (WinExist("ahk_id "MagnifierWindowID)=0) ;后视镜窗口不存在
                            {
                                Loop 20
                                {
                                    ToolTip 快捷呼出%MediaWindow%播放器
                                    Sleep 30
                                }
                            }
                            else ;后视镜窗口存在
                            {
                                ToolTipText:="快捷呼出" . MediaWindow . "播放器"
                            }
                            ToolTip
                        }
                        else
                        {
                            WinMinimize ahk_class %MediaWindow%

                            if (WinExist("ahk_id "MagnifierWindowID)=0) ;后视镜窗口不存在
                            {
                                Loop 20
                                {
                                    ToolTip 快捷关闭%MediaWindow%播放器
                                    Sleep 30
                                }
                            }
                            else ;后视镜窗口存在
                            {
                                ToolTipText:="快捷关闭" . MediaWindow . "播放器"
                            }
                            ToolTip
                        }
                        Break
                    }
                }
                Sleep 10
            }
        }
        else if (媒体快捷键按下时长>双击限时)
        {
            if GetKeyState("Left", "P")
            {
                Send {Left Down}
            }
            if GetKeyState("Right", "P")
            {
                Send {Right Down}
            }
            if GetKeyState("Up", "P")
            {
                Send {Up Down}
            }
            if GetKeyState("Down", "P")
            {
                Send {Down Down}
            }

            Loop
            {
                if !GetKeyState("Left", "P") and !GetKeyState("Right", "P") and !GetKeyState("Up", "P") and !GetKeyState("Down", "P")
                {
                    break
                }
                Sleep 10
            }

            if !GetKeyState("Left", "P")
            {
                Send {Left Up}
            }
            if !GetKeyState("Right", "P")
            {
                Send {Right Up}
            }
            if !GetKeyState("Up", "P")
            {
                Send {Up Up}
            }
            if !GetKeyState("Down", "P")
            {
                Send {Down Up}
            }
            break
        }

        if !GetKeyState("Left", "P") and !GetKeyState("Right", "P") and !GetKeyState("Up", "P") and !GetKeyState("Down", "P")
        {
            break
        }
        Sleep 10
    }

    if (NeedReloadHSJ=1)
        SetTimer 恢复运行后视镜, -1
return

屏幕监测:
    ;自动暂停
    CoordMode Mouse, Screen ;以屏幕为基准
    MouseGetPos MISX, MISY, AWinID ;获取鼠标在屏幕中的位置
    WinGetClass AWinClass, ahk_id %AWinID% ;ahk_id 获取窗口类名
    WinGet AWinExeName, ProcessName , ahk_id %AWinID%
    任务栏激活:=WinActive("ahk_class Shell_TrayWnd")!=0
    任务栏存在:=WinExist("ahk_class Shell_TrayWnd")!=0
    ; ToolTip Exe %AWinExeName%   Class %AWinClass%`n任务栏激活 %任务栏激活%   任务栏存在 %任务栏存在%
    ; ToolTip % WinExist("ahk_class TaskListThumbnailWnd") WinExist("ahk_class DV2ControlHost") WinExist("ahk_class Windows.UI.Core.CoreWindow") WinExist("ahk_class Xaml_WindowedPopupClass") 开始菜单
    ; ToolTip % WinExist("ahk_exe EverythingToolbar.Launcher.exe") 搜索栏
    ; ToolTip % WinActive("ahk_class" BlackListWindow_AutoStop)
    if (AWinClass!="") and (AWinClass=BlackListWindow_AutoStop) and (WinActive("ahk_class" BlackListWindow_AutoStop)!=0) and (running=1) ;自动暂停黑名单
    {
        Alt自动暂停:=1
        gosub 暂停运行
        Sleep 300
        ToolTip
        Return
    }
    else if (AWinClass!="") and (AWinClass!=BlackListWindow_AutoStop) and (WinActive("ahk_class" BlackListWindow_AutoStop)=0) and (Alt自动暂停=1) and (running=0) ;恢复运行
    {
        Loop
        {
            Sleep 30
            if !GetKeyState("Alt", "P") and !GetKeyState("Tab", "P")
                break
        }
        gosub 暂停运行
        Alt自动暂停:=0
        Return
    }
    else if (Alt自动暂停=1)
    {
        Return
    }

    ;=====================================================================Y轴
    ; ToolTip 防误触时间%防误触时间%ms
    if (MISY<3) ;如果鼠标贴着屏幕顶部
    {
        Loop
        {
            ; ToolTip %A_Index%
            Sleep 60
            MouseGetPos, , MISY
            if (MISY<=3) and (A_Index=10)
            {
                WinActivate %ActiveWindowID% ;激活后台等待激活的窗口
                WinShow %ActiveWindowID% ;激活后台等待激活的窗口
            }
            else if (MISY>3)
            {
                ; ToolTip
                break
            }
        }
    }
    else if (开始菜单=1) ;如果呼出了开始菜单
    {
        if (WinExist("ahk_class TaskListThumbnailWnd")!=0) or (WinExist("ahk_class DV2ControlHost")!=0) or (WinExist("ahk_class Windows.UI.Core.CoreWindow")!=0) or (WinExist("ahk_class Xaml_WindowedPopupClass")!=0) ;如果开始菜单显示了
        {
            WinShow ahk_class Shell_TrayWnd ;显示任务栏
            开始菜单:=开始菜单+1
        }
        else ;一直没显示
        {
            开始菜单检测:=开始菜单检测+1
            if (开始菜单检测>=5)
            {
                开始菜单:=0
            }
        }
    }
    else if (WinExist("ahk_class TaskListThumbnailWnd")=0) and (WinExist("ahk_class DV2ControlHost")=0) and (WinExist("ahk_class Windows.UI.Core.CoreWindow")=0) and (WinExist("ahk_class Xaml_WindowedPopupClass")=0) and (开始菜单>1) ;如果开始菜单没有显示并且弹出过任务栏
    {
        WinGet TaskbarID, ID, ahk_class Shell_TrayWnd ;获取任务栏句柄
        DllCall("ShowWindow", "Ptr", TaskbarID, "Int", 0) ; 隐藏任务栏
        开始菜单:=0
    }
    else if (MISY>=A_ScreenHeight-3) and (任务栏存在=0) and (开始菜单=0) and (搜索栏=0) ;如果鼠标贴着屏幕底部
    {
        任务栏沉浸:=0
        WinGetPos AWinX, AWinY, AWinWidth, AWinHeight, ahk_id %AWinID%
        if (AWinWidth>=A_ScreenWidth-KDXZ) and (AWinHeight>=A_ScreenHeight-GDXZ) and (AWinClass!="Shell_TrayWnd") and (AWinClass!="DesktopLyrics") and (AWinClass!="WorkerW")  ;如果当前窗口是全屏
        {
            任务栏沉浸:=1
        }

        if (KeyDown_屏幕底部="")  ;开始计时
        {
            DllCall("QueryPerformanceFrequency", "Int64*", freq)
            DllCall("QueryPerformanceCounter", "Int64*", KeyDown_屏幕底部)
        }
        else
        {
            DllCall("QueryPerformanceCounter", "Int64*", KeyUp_屏幕底部)
            防误触时间:=Round((KeyUp_屏幕底部-KeyDown_屏幕底部)/freq*1000, 2)
            if (防误触时间>250) and (任务栏沉浸=0) ;如果按下时间大于250毫秒并且任务栏没有沉浸
            {
                主动呼出任务栏:=1
                WinShow ahk_class Shell_TrayWnd ;显示任务栏
                WinSet AlwaysOnTop, On, ahk_class Shell_TrayWnd
                任务栏计时器:=0
            }
            else if (防误触时间>800) and (任务栏沉浸=1) ;如果按下时间大于800毫秒并且任务栏沉浸
            {
                主动呼出任务栏:=1
                WinShow ahk_class Shell_TrayWnd ;显示任务栏
                WinSet AlwaysOnTop, On, ahk_class Shell_TrayWnd
                任务栏计时器:=0
            }
        }
    }
    else if (任务栏存在=1) and (MISY<A_ScreenHeight-3) and (MISY>ScreenBottom) and (开始菜单=0) and (搜索栏=0) ;如果鼠标回到任务栏重新开始计时
    {
        任务栏计时器:=0
        KeyDown_屏幕底部:=""
    }
    else if (任务栏存在=1) and (MISY<ScreenBottom) and (任务栏计时器=0) and (开始菜单=0) and (搜索栏=0) ;如果鼠标离开任务栏 且任务栏处于激活状态 但是没有离开预览窗口范围 记录时间
    {
        DllCall("QueryPerformanceFrequency", "Int64*", freq)
        DllCall("QueryPerformanceCounter", "Int64*", KeyDown_离开任务栏)
        任务栏计时器:=1
    }
    else if (任务栏存在=1) and (MISY<ScreenBottom) and (任务栏计时器!=0) and (开始菜单=0) and (搜索栏=0) ;and (MISY>ScreenBottomMax) ;任务栏处于激活状态没有开始菜单和预览窗口 等待3秒才隐藏任务栏
    {
        if (AWinExeName="explorer.exe") or (AWinClass="TaskListThumbnailWnd") or (AWinClass="DV2ControlHost") or (AWinClass="Windows.UI.Core.CoreWindow") or (AWinClass="Xaml_WindowedPopupClass") ;
        {
            任务栏计时器:=0
        }
        else
        {
            DllCall("QueryPerformanceCounter", "Int64*", KeyUp_离开任务栏)
            记录时间:=Round((KeyUp_离开任务栏-KeyDown_离开任务栏)/freq*1000, 2)
            ; ToolTip 记录时间%记录时间%ms %AWinClass% %MISY% %MISX%
            if (记录时间>800) and (任务栏激活=0) ; 点击任务栏后不再隐藏
            {
                WinGet TaskbarID, ID, ahk_class Shell_TrayWnd ;获取任务栏句柄
                DllCall("ShowWindow", "Ptr", TaskbarID, "Int", 0) ; 隐藏任务栏
                主动呼出任务栏:=0
                KeyDown_屏幕底部:=""
            }
        }
    }

    if (任务栏存在=1) and (主动呼出任务栏=0) and (开始菜单=0) ; 如果没有主动呼出任务栏但是任务栏显示了
    {
        WinGet TaskbarID, ID, ahk_class Shell_TrayWnd ;获取任务栏句柄
        DllCall("ShowWindow", "Ptr", TaskbarID, "Int", 0) ; 隐藏任务栏
    }

    if (running=0)
        Return

    ;=====================================================================X轴
    ; 调试模式:=1
    if (MISX<FJL) ;and !GetKeyState("Lbutton", "P") ;如果鼠标在屏幕左侧 且鼠标左键没有按下
    {
        if (调试模式=1)
            ToolTip 鼠标在屏幕左侧
        屏幕实时位置:=1
        主动隐藏快捷呼出窗口:=0
        ; ToolTip 屏幕实时位置%屏幕实时位置% w%HSJWidth% h%HSJHeight%
        if (HSJ=0)
        {
            if (WinExist("ahk_id "MagnifierWindowID)=0) and (OpenHSJ=0) and !GetKeyState("Lbutton", "P") ;如果鼠标在屏幕左侧 且鼠标左键没有按下
            {
                SetTimer 后视镜, -1 ;打开后视镜
            }
        }
        else if (HSJ=1)
        {
            if (WinExist("ahk_id "MagnifierWindowID)=0) and (HSJH=0) and !GetKeyState("Lbutton", "P") ;如果鼠标在屏幕左侧 且鼠标左键没有按下
            {
                ; ToolTip 打开后视镜
                WinShow ahk_id %MagnifierWindowID%
                if (HSJM=0)
                {
                    WinMove ahk_id %MagnifierWindowID%, , HSJLX, HSJY
                    HSJM:=1
                }
                WinSet Transparent, 255, ahk_id %MagnifierWindowID%
            }
        }

        快捷呼出计时:=-1
        if (停留呼出左边快捷窗口=1) and (已激活左边快捷呼出窗口=0)
        {
            WinMinimize ahk_id %左边快捷呼出窗口% ;隐藏窗口
            停留呼出左边快捷窗口:=0
        }
        else if (停留呼出右边快捷窗口=1) and (已激活右边快捷呼出窗口=0)
        {
            WinMinimize ahk_id %右边快捷呼出窗口% ;隐藏窗口
            停留呼出右边快捷窗口:=0
        }
    }
    else if (MISX>FJR) ;and !GetKeyState("Lbutton", "P") ;如果鼠标在屏幕右侧 且鼠标左键没有按下
    {
        if (调试模式=1)
            ToolTip 鼠标在屏幕右侧
        屏幕实时位置:=3
        主动隐藏快捷呼出窗口:=0
        ; ToolTip 屏幕实时位置%屏幕实时位置% w%HSJWidth% h%HSJHeight%
        if (HSJ=0)
        {
            if (WinExist("ahk_id "MagnifierWindowID)=0) and (OpenHSJ=0) and !GetKeyState("Lbutton", "P") ;如果鼠标在屏幕右侧 且鼠标左键没有按下
            {
                SetTimer 后视镜, -1 ;打开后视镜
            }
        }
        else if (HSJ=1)
        {
            if (WinExist("ahk_id "MagnifierWindowID)=0) and (HSJH=0) and !GetKeyState("Lbutton", "P") ;如果鼠标在屏幕右侧 且鼠标左键没有按下
            {
                ; ToolTip 打开后视镜
                WinShow ahk_id %MagnifierWindowID%
                if (HSJM=0)
                {
                    WinMove ahk_id %MagnifierWindowID%, , HSJRX, HSJY
                    HSJM:=1
                }
                WinSet Transparent, 255, ahk_id %MagnifierWindowID%
            }
        }

        快捷呼出计时:=-1
        if (停留呼出左边快捷窗口=1) and (已激活左边快捷呼出窗口=0)
        {
            WinMinimize ahk_id %左边快捷呼出窗口% ;隐藏窗口
            停留呼出左边快捷窗口:=0
        }
        else if (停留呼出右边快捷窗口=1) and (已激活右边快捷呼出窗口=0)
        {
            WinMinimize ahk_id %右边快捷呼出窗口% ;隐藏窗口
            停留呼出右边快捷窗口:=0
        }
    }
    else if (MISX>FJL+BKXZ) and (MISX<FJR-BKXZ) ; 如果鼠标在屏幕中间
    {
        if (调试模式=1)
            ToolTip 鼠标在屏幕中间
        屏幕实时位置:=2
        主动隐藏快捷呼出窗口:=0
        HSJH:=0
        ; ToolTip 屏幕实时位置%屏幕实时位置% w%HSJWidth% h%HSJHeight%
        if (HSJ=1)
        {
            ; ToolTip 关闭后视镜
            WinSet Transparent, 0, ahk_id %MagnifierWindowID%
            WinHide ahk_id %MagnifierWindowID%
            HSJM:=0
        }

        快捷呼出计时:=-1
        if (停留呼出左边快捷窗口=1) and (已激活左边快捷呼出窗口=0)
        {
            WinMinimize ahk_id %左边快捷呼出窗口% ;隐藏窗口
            停留呼出左边快捷窗口:=0
        }
        else if (停留呼出右边快捷窗口=1) and (已激活右边快捷呼出窗口=0)
        {
            WinMinimize ahk_id %右边快捷呼出窗口% ;隐藏窗口
            停留呼出右边快捷窗口:=0
        }
    }
    else if (MISX>=FJL) and (MISX<=FJL+BKXZ) and (左边快捷呼出窗口!="") ;鼠标停留在左侧屏幕边框内
    {
        if (快捷呼出计时=-1)
        {
            快捷呼出计时:=A_TickCount
        }
        else
        {
            停留时间:=A_TickCount-快捷呼出计时
            if (调试模式=1)
                ToolTip 停留时间%停留时间%ms 停留%停留呼出左边快捷窗口%`n左边窗口%左边快捷呼出窗口% 状态%已激活左边快捷呼出窗口%`n主动隐藏%主动隐藏快捷呼出窗口%

            if (停留时间>800) and (已激活左边快捷呼出窗口=0) and !GetKeyState("LButton", "P") and !GetKeyState("MButton", "P") and !GetKeyState("RButton", "P") ;左边快捷呼出窗口没有激活
            {
                if (WinExist("ahk_id" 左边快捷呼出窗口)=0)
                {
                    左边快捷呼出窗口:=""
                    IniWrite %左边快捷呼出窗口%, Settings.ini, 设置, 左边快捷呼出窗口 ;写入设置到ini文件
                }
                else if (主动隐藏快捷呼出窗口=0) and (停留呼出左边快捷窗口=0)
                {
                    WinActivate ahk_id %左边快捷呼出窗口% ;激活窗口
                    停留呼出左边快捷窗口:=1
                }
            }
        }
    }
    else if (MISX<=FJR) and (MISX>=FJR-BKXZ) and (右边快捷呼出窗口!="") ;鼠标停留在右侧屏幕边框内
    {
        if (快捷呼出计时=-1)
        {
            快捷呼出计时:=A_TickCount
        }
        else
        {
            停留时间:=A_TickCount-快捷呼出计时
            if (调试模式=1)
                ToolTip 停留时间%停留时间%ms 停留%停留呼出右边快捷窗口%`n右边窗口%右边快捷呼出窗口% 状态%已激活右边快捷呼出窗口%`n主动隐藏%主动隐藏快捷呼出窗口%

            if (停留时间>800) and (已激活右边快捷呼出窗口=0) and !GetKeyState("LButton", "P") and !GetKeyState("MButton", "P") and !GetKeyState("RButton", "P") ;右边快捷呼出窗口没有激活
            {
                if (WinExist("ahk_id" 右边快捷呼出窗口)=0)
                {
                    右边快捷呼出窗口:=""
                    IniWrite %右边快捷呼出窗口%, Settings.ini, 设置, 右边快捷呼出窗口 ;写入设置到ini文件
                }
                else if (主动隐藏快捷呼出窗口=0) and (停留呼出右边快捷窗口=0)
                {
                    WinActivate ahk_id %右边快捷呼出窗口% ;激活窗口
                    停留呼出右边快捷窗口:=1
                }
            }
        }
    }
    ; 停留时间:=A_TickCount-快捷呼出计时
    ; 实际左边状态:=WinActive("ahk_id "左边快捷呼出窗口)
    ; 实际右边状态:=WinActive("ahk_id "右边快捷呼出窗口)
    ; ToolTip 快捷呼出计时%快捷呼出计时%`n停留时间%停留时间%ms 停留%停留呼出左边快捷窗口%`n左边窗口%左边快捷呼出窗口% 状态%已激活左边快捷呼出窗口% 实际%实际左边状态%`n主动隐藏%主动隐藏快捷呼出窗口%`n`n停留时间%停留时间%ms 停留%停留呼出右边快捷窗口%`n右边窗口%右边快捷呼出窗口% 状态%已激活右边快捷呼出窗口% 实际%实际右边状态%`n主动隐藏%主动隐藏快捷呼出窗口%

    ;=====================================================================其他功能
    ;后视镜线程卡顿重启
    if (NeedReloadHSJ=1) and !GetKeyState("Left", "P") and !GetKeyState("Right", "P") and !GetKeyState("Up", "P") and !GetKeyState("Down", "P")
        SetTimer 恢复运行后视镜, -1

    ;搜索栏 Everything 修正
    WinGetPos EverythingToolbarX, EverythingToolbarY, EverythingToolbarW, EverythingToolbarH, ahk_exe EverythingToolbar.Launcher.exe
    ; ToolTip %EverythingToolbarX% %搜索栏X%`n%EverythingToolbarY% %搜索栏Y%`n%EverythingToolbarW% %搜索栏W%`n%EverythingToolbarH% %搜索栏H%
    if (WinExist("ahk_exe EverythingToolbar.Launcher.exe")!=0)
    {
        搜索栏:=1
        if (EverythingToolbarX!=搜索栏X) or (EverythingToolbarY!=搜索栏Y) or (EverythingToolbarW!=搜索栏W) or (EverythingToolbarH!=搜索栏H)
        {
            if (任务栏移动完成!=1)
                WinMove ahk_exe EverythingToolbar.Launcher.exe, , 搜索栏X, 搜索栏Y, 搜索栏W, 搜索栏H
        }
        if (EverythingToolbarX=搜索栏X) and (EverythingToolbarY=搜索栏Y) and (EverythingToolbarW=搜索栏W) and (EverythingToolbarH=搜索栏H)
        {
            任务栏移动完成:=1
        }
    }
    else
    {
        if (搜索栏=1)
            DllCall("ShowWindow", "Ptr", TaskbarID, "Int", 0) ; 隐藏任务栏
        搜索栏:=0
        任务栏移动完成:=0
    }

    ; 神隐窗口 窗口自动调整透明度
    if (AutoHideWindow!="") and (AutoHideWindow!="ERROR")
    {
        Critical, On
        ; MouseGetPos AutoHideMX, AutoHideMY
        神隐窗口:=0
        AutoHideMX:=MISX
        AutoHideMY:=MISY

        MouseGetPos, , , 神隐窗口识别包含ID ;获取鼠标所在窗口的句柄
        if (InStr(AutoHideWindow, "Title")!=0)
            WinGetTitle 当前特征, ahk_id %神隐窗口识别包含ID%
        else if (InStr(AutoHideWindow, "Class")!=0)
            WinGetClass 当前特征, ahk_id %神隐窗口识别包含ID%
        else if (InStr(AutoHideWindow, "Exe")!=0)
            WinGet 当前特征, ProcessName, ahk_id %神隐窗口识别包含ID%

        包含项位置:=InStr(AutoHideWindow, "===")+3
        包含项:=SubStr(AutoHideWindow, 包含项位置)
        if (InStr(AutoHideWindow, "Same")!=0) and (当前特征=包含项)
        {
            神隐窗口:=1
            AutoHideMode:=1
        }
        else if (InStr(AutoHideWindow, "Include")!=0) and (InStr(当前特征, 包含项)!=0)
        {
            神隐窗口:=1
            AutoHideMode:=2
        }

        if (神隐窗口=1) ;是自动隐藏窗口 打开神隐
        {
            if !GetKeyState("Alt", "P")
                OutOfAutoHide:=0

            AutoHide:=0
            窗口控制(AutoHideWindow, AutoHideMode, 1, 100, 1, "")
            AutoHideWindowID:=ControlWindowID
            WinGetPos AutoHideWinX, AutoHideWinY, AutoHideWinWidth, AutoHideWinHeight, ahk_id %AutoHideWindowID%
            ; ToolTip AutoHideWindowID%AutoHideWindowID%`nX%AutoHideWinX% Y%AutoHideWinY% Width%AutoHideWinWidth% Height%AutoHideWinHeight%`n鼠标X%AutoHideMX% Y%AutoHideMY%
        }
        else ;不是自动隐藏窗口 关闭神隐
        {
            if (AutoHideMX<AutoHideWinX) or (AutoHideMX>AutoHideWinX+AutoHideWinWidth) or (AutoHideMY<AutoHideWinY) or (AutoHideMY>AutoHideWinY+AutoHideWinHeight) ; 鼠标在窗口外
            {
                ; ToolTip 鼠标在窗口外
                if GetKeyState("Alt", "P")
                    OutOfAutoHide:=1
                else
                    OutOfAutoHide:=0

                if (AutoHide=0)
                {
                    AutoHide:=1
                    窗口控制(AutoHideWindow, AutoHideMode, 1, 255, 0, "")
                }
            }
            else ;鼠标在窗口内
            {
                ; 按住Alt允许控制窗口
                if GetKeyState("Alt", "P") and (OutOfAutoHide=0)
                {
                    CoordMode Mouse, Screen ;以屏幕为基准
                    MouseGetPos ReloadX, ReloadY

                    if (ReloadX<FJL) or (ReloadX>FJR) ;如果在左侧屏幕或者在右侧屏幕
                    {
                        WinSet Transparent, 0, ahk_id %MagnifierWindowID%
                        WinHide ahk_id %MagnifierWindowID% ;关闭后视镜
                    }

                    窗口控制(AutoHideWindow, AutoHideMode, 1, 175, 0, "")

                    loop
                    {
                        if !GetKeyState("Alt", "P")
                        {
                            CoordMode Mouse, Screen ;以屏幕为基准
                            MouseGetPos AutoHideMX, AutoHideMY
                            if (AutoHideMX<AutoHideWinX) or (AutoHideMX>AutoHideWinX+AutoHideWinWidth) or (AutoHideMY<AutoHideWinY) or (AutoHideMY>AutoHideWinY+AutoHideWinHeight) ; 鼠标在窗口外
                            {
                                OutOfAutoHide:=1
                                AutoHide:=1
                                窗口控制(AutoHideWindow, AutoHideMode, 1, 255, 0, "")穿透
                            }
                            else ; 鼠标在窗口内
                            {
                                OutOfAutoHide:=0
                                窗口控制(AutoHideWindow, AutoHideMode, 1, 100, 1, "")
                            }

                            if (HSJ=1)
                            {
                                CoordMode Mouse, Screen ;以屏幕为基准
                                MouseGetPos ReloadX, ReloadY
                                ; MsgBox, ReloadX%ReloadX% ReloadY%ReloadY%
                                if (ReloadX<FJL) or (ReloadX>FJR) ;如果在左侧屏幕或者在右侧屏幕
                                {
                                    HSJM:=0
                                    HSJH:=0
                                    WinShow ahk_id %MagnifierWindowID% ;打开后视镜

                                    if (HSJM=0) and (ReloadX<FJL) ;如果在左侧屏幕
                                    {
                                        WinMove ahk_id %MagnifierWindowID%, , HSJLX, HSJY
                                        HSJM:=1
                                    }
                                    else if (HSJM=0) and (ReloadX>FJR) ;如果在右侧屏幕
                                    {
                                        WinMove ahk_id %MagnifierWindowID%, , HSJRX, HSJY
                                        HSJM:=1
                                    }

                                    WinSet Transparent, 255, ahk_id %MagnifierWindowID%
                                }
                            }
                            break
                        }
                    }
                }
            }
        }
        Critical, Off
    }

    ; 飘逸窗口 自动移动位置
    if (AutoMoveWindow!="") and (AutoMoveWindow!="ERROR")
    {
        Critical, On
        ; MouseGetPos AutoMoveMX, AutoMoveMY
        AutoMoveMX:=MISX
        AutoMoveMY:=MISY
        ; ToolTip %AutoMoveWindow%`nID: %AutoMoveWindowID%`nX%AutoMoveWinX% Y%AutoMoveWinY% W%AutoMoveWinWidth% H%AutoMoveWinHeight%
        if (AutoMoveWindowID="") or (AutoMoveWinX="") or (AutoMoveWinY="") or (AutoMoveWinWidth="") or (AutoMoveWinHeight="") ;第一次运行
        {
            if (InStr(AutoMoveWindow, "Same")!=0)
                AutoMoveMode:=1
            else if (InStr(AutoMoveWindow, "Include")!=0)
                AutoMoveMode:=2

            窗口控制(AutoMoveWindow, AutoMoveMode, "", "", "", "")
            AutoMoveWindowID:=ControlWindowID
            WinGetPos AutoMoveWinX, AutoMoveWinY, AutoMoveWinWidth, AutoMoveWinHeight, ahk_id %AutoMoveWindowID%
        }
        else ;不是第一次运行
        {

            if (AutoMoveMY>=AutoMoveWinY) and (AutoMoveMY<=AutoMoveWinY+AutoMoveWinHeight) and (AutoMoveMX>=AutoMoveWinX) and (AutoMoveMX<=AutoMoveWinX+AutoMoveWinWidth) ;鼠标在窗口内
            {
                if (AutoMoveWinY+AutoMoveWinHeight/2<=A_ScreenHeight/2) ;窗口在屏幕上半部分
                {
                    if (AutoMoveWinY<AutoMoveWinHeight) and (AutoMove=1) ;窗口上方位置不足以显示 向下移动
                    {
                        AutoMove:=0
                        窗口控制(AutoMoveWindow, AutoMoveMode, "", "", "", AutoMoveWinY+AutoMoveWinHeight) ;关闭神隐窗口
                    }
                    else if (AutoMove=1) ;窗口上方位置足够 向上移动
                    {
                        AutoMove:=0
                        窗口控制(AutoMoveWindow, AutoMoveMode, "", "", "", AutoMoveWinY-AutoMoveWinHeight) ;关闭神隐窗口
                    }
                }
                else if (AutoMoveWinY+AutoMoveWinHeight/2>A_ScreenHeight/2) ;窗口在屏幕下半部分
                {
                    if (A_ScreenHeight-(AutoMoveWinY+AutoMoveWinHeight)<AutoMoveWinHeight) and (AutoMove=1) ;窗口下方位置不足以显示 向上移动
                    {
                        AutoMove:=0
                        窗口控制(AutoMoveWindow, AutoMoveMode, "", "", "", AutoMoveWinY-AutoMoveWinHeight) ;关闭神隐窗口
                    }
                    else if (AutoMove=1) ;窗口下方位置足够 向下移动
                    {
                        AutoMove:=0
                        窗口控制(AutoMoveWindow, AutoMoveMode, "", "", "", AutoMoveWinY+AutoMoveWinHeight) ;关闭神隐窗口
                    }
                }
            }
            else if (AutoMoveMY<AutoMoveWinY-20) or (AutoMoveMY>AutoMoveWinY+AutoMoveWinHeight+20) or (AutoMoveMX<AutoMoveWinX-20) or (AutoMoveMX>AutoMoveWinX+AutoMoveWinWidth+20) ;鼠标在窗口外
            {
                AutoMove:=1
                窗口控制(AutoMoveWindow, AutoMoveMode, "", "", "", AutoMoveWinY) ;还原窗口位置
            }
        }
        Critical, Off
    }
return

~$LWin::
    开始菜单:=1
    开始菜单检测:=0
Return
; KeyList:="1234567890-=QWERTYUIOP[]\\ASDFGHJKL;'ZXCVBNM,./~"
; Loop, Parse, KeyList
; {
; pressedKeys := ""
; if GetKeyState(A_LoopField, "P")
; {
; pressedKeys .= A_LoopField . ", "
; }
; if !GetKeyState("LWin", "P")
; break
; }
; if (pressedKeys="")
; {
; 任务栏计时器:=1
; DllCall("QueryPerformanceFrequency", "Int64*", freq)
; DllCall("QueryPerformanceCounter", "Int64*", KeyDown_屏幕底部)
; WinShow, ahk_class Shell_TrayWnd ;显示任务栏
; Loop
; {
; Sleep 30
; If (WinActive("ahk_class Shell_TrayWnd")!=0)
; {
; break
; }
; else
; {
; WinShow, ahk_class Shell_TrayWnd ;显示任务栏
; break
; }
; }
; }
; Return

后视镜: ;打开后视镜
    if (HSJ=0) and (OpenHSJ=0) ;如果后视镜没有打开
    {
        OpenHSJ:=1
        Ptr := A_PtrSize ? "UPtr" : "UInt"
        if !DllCall("GetModuleHandle", "str", "gdiplus", Ptr)
            DllCall("LoadLibrary", "str", "gdiplus")
        VarSetCapacity(GdiplusStartupInput, A_PtrSize = 8 ? 24 : 16, 0), GdiplusStartupInput := Chr(1)
        DllCall("gdiplus\GdiplusStartup", A_PtrSize = 8 ? "UPtr*" : "UInt*", pToken, Ptr, &GdiplusStartupInput, Ptr, 0)

        Gui 后视镜:New
        Gui 后视镜:-Caption +AlwaysOnTop +E0x02000000 +E0x00080000 -DPIScale  ;  WS_EX_COMPOSITED := E0x02000000  WS_EX_LAYERED := E0x00080000
        Gui 后视镜:Margin, 0,0
        Gui 后视镜:Add, text, w%HSJWidth% h%HSJHeight% 0xE hwndhPic ; SS_BITMAP = 0xE
        if (屏幕实时位置=1)
        {
            Gui 后视镜:Show, x%HSJLX% y%HSJY% NA, MagnifierCloneWindowAHK
        }
        else if (屏幕实时位置=3)
        {
            Gui 后视镜:Show, x%HSJRX% y%HSJY% NA, MagnifierCloneWindowAHK
        }
        WinGet MagnifierWindowID, ID, MagnifierCloneWindowAHK

        Gui MagnifierWindow:New
        Gui MagnifierWindow: +AlwaysOnTop -Caption +ToolWindow +HWNDhMagnifier -DPIScale
        Gui MagnifierWindow: Show, w%HSJWidth% h%HSJHeight% NA Hide, MagnifierWindowAHK

        DllCall("LoadLibrary", "str", "magnification.dll")
        DllCall("magnification.dll\MagInitialize")

        WS_CHILD := 0x40000000, WS_VISIBLE := 0x10000000, MS_SHOWMAGNIFIEDCURSOR := 0x1 

        hChildMagnifier := DllCall("CreateWindowEx"
            , "UInt", 0
            , "Str", "Magnifier"
            , "Str", "MagnifierWindow"
            , "UInt", MS_SHOWMAGNIFIEDCURSOR | WS_CHILD | WS_VISIBLE
            , "Int", 0
            , "Int", 0
            , "Int", HSJWidth
            , "Int", HSJHeight
            , Ptr, hMagnifier
            , "UInt", 0
            , Ptr, DllCall("GetWindowLong", Ptr, hMagnifier, "UInt", GWL_HINSTANCE := -6)
            , "UInt", 0)

        VarSetCapacity(HWNDstruct, HWNDarr.Count() * A_PtrSize, 0)
        Loop % HWNDarr.Count()
            NumPut(HWNDarr[A_Index], HWNDstruct, (A_Index - 1) * A_PtrSize, "UPtr")
        DllCall("magnification.dll\MagSetWindowFilterList", Ptr, hChildMagnifier, "Int", MW_FILTERMODE_EXCLUDE := 0, "Int", HWNDarr.Count(), Ptr, &HWNDstruct)

        Matrix := "1|0|0|"
            . "0|1|0|"
            . "0|0|1"  
        VarSetCapacity(MAGTRANSFORM, 36, 0)
        Loop, Parse, Matrix, |  
            NumPut(A_LoopField, MAGTRANSFORM, (A_Index - 1) * 4, "Float")
        DllCall("magnification.dll\MagSetWindowTransform", Ptr, hChildMagnifier, Ptr, &MAGTRANSFORM)

        DllCall("magnification.dll\MagSetImageScalingCallback", Ptr, hChildMagnifier, "Int", RegisterCallback("MagImageScalingCallback", "Fast"))

        VarSetCapacity(RECT, 16, 0)
        HSJ:=1
    }

恢复运行后视镜:
    NeedReloadHSJ:=0
    Loop
    {
        ; WinExistMagnifierWindow:=WinExist("ahk_id "MagnifierWindowID)
        ; ToolTip %高效模式% 后视镜%HSJ%`n%MagnifierWindowID% : %WinExistMagnifierWindow%
        if (高效模式=0) and (WinExist("ahk_id "MagnifierWindowID)=0)
        {
            Sleep 50
            Continue
        }
        else if (running=0) ;自动暂停
        {
            if (WinExist("ahk_id "MagnifierWindowID)!=0)
            {
                WinSet Transparent, 0, ahk_id %MagnifierWindowID%
                WinHide ahk_id %MagnifierWindowID%
                HSJM:=0
            }
            Sleep 100
            Continue
        }
        else if GetKeyState("Left", "P") or GetKeyState("Right", "P") or GetKeyState("Up", "P") or GetKeyState("Down", "P") ;打断循环
        {
            NeedReloadHSJ:=1
            break
        }

        if (ToolTipText!="")
        {
            if (ToolTipCount=0)
                ToolTipCount:=A_TickCount
            else if (A_TickCount-ToolTipCount>30)
            {
                ToolTip %ToolTipText%
                ToolTipTimes:=ToolTipTimes+1

                if (ToolTipTimes>20)
                {
                    ToolTipText:=""
                    ToolTipTimes:=0
                    ToolTip
                }
            }
        }

        CoordMode Mouse, Screen ;以屏幕为基准
        MouseGetPos MXS, MYS
        NumPut(MXS - HSJWidth/2, RECT, 0, "Int")
        NumPut(MYS - HSJHeight/2, RECT, 4, "Int")
        NumPut(HSJWidth, RECT, 8, "Int")
        NumPut(HSJHeight, RECT, 12, "Int")
        DllCall("magnification.dll\MagSetWindowSource", Ptr, hChildMagnifier, Ptr, &RECT)
    }

    ; Gui 后视镜:Destroy
    ; Gui MagnifierWindow:Destroy
Return 

MagImageScalingCallback(hwnd, srcdata, srcheader, destdata, destheader, unclipped, clipped, dirty) 
{
    Static BI_RGB := 0, CBM_INIT := 6, DIB_RGB_COLORS := 0
        , Ptr := A_PtrSize = 8 ? "UPtr" : "UInt"
        , STM_SETIMAGE := 0x172, IMAGE_BITMAP := 0x0
        , _ := VarSetCapacity(BITMAPV5HEADER, 124, 0)
        , __ := VarSetCapacity(BITMAPINFO, 44, 0)

    bV5Width := NumGet(srcheader + 0, 0, "UInt")
    bV5Height := NumGet(srcheader + 0, 4, "UInt") 

    NumPut(124, BITMAPV5HEADER, 0, "UInt")  		;	DWORD		bV5Size;
    NumPut(bV5Width, BITMAPV5HEADER, 4, "UInt")		;	LONG		bV5Width;
    NumPut(bV5Height, BITMAPV5HEADER, 8, "UInt")	;	LONG		bV5Height;
    NumPut(1, BITMAPV5HEADER, 12, "Short")			;	WORD		bV5Planes;
    NumPut(32, BITMAPV5HEADER, 14, "Short")			;	WORD		bV5BitCount;
    NumPut(BI_RGB, BITMAPV5HEADER, 16, "UInt")		;	DWORD		bV5Compression; 

    NumPut(44, BITMAPINFO, 0, "UInt")  				;	DWORD biSize;
    NumPut(bV5Width, BITMAPINFO, 4, "UInt")  		;	LONG  biWidth;
    NumPut(bV5Height, BITMAPINFO, 8, "UInt")  		;	LONG  biHeight;
    NumPut(1, BITMAPINFO, 12, "Short")  			;	WORD  biPlanes;
    NumPut(32, BITMAPINFO, 14, "Short")  			;	WORD  biBitCount;
    NumPut(BI_RGB, BITMAPINFO, 16, "UInt")  		;	DWORD biCompression;

    hDC := DllCall("GetDC", Ptr, hwnd)

    hBMP := DllCall("CreateDIBitmap"
        , Ptr, hDC
        , Ptr, &BITMAPV5HEADER
        , "UInt", CBM_INIT
        , Ptr,  srcdata
        , Ptr, &BITMAPINFO
        , "UInt", DIB_RGB_COLORS) 

    DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", Ptr, hBMP, Ptr, 0, A_PtrSize = 8 ? "UPtr*" : "UInt*", pBitmap)
    DllCall("gdiplus\GdipImageRotateFlip", Ptr, pBitmap, "Int", 6)   ;	Rotate180FlipX
    DllCall("gdiplus\GdipCreateHBITMAPFromBitmap", Ptr, pBitmap, A_PtrSize = 8 ? "UPtr*" : "UInt*", hBitmap, "Int", 0xffffffff)

    SendMessage STM_SETIMAGE, IMAGE_BITMAP, hBitmap,, ahk_id %hPic%

    DllCall("DeleteObject", Ptr, ErrorLevel)
    DllCall("gdiplus\GdipDisposeImage", Ptr, pBitmap)
    DllCall("DeleteDC", Ptr, hDC)
    DllCall("DeleteObject", Ptr, hBMP)
    DllCall("DeleteObject", Ptr, hBitmap)
    Return 1
}
; */

放大镜:
    Gui 放大镜:New
    Gui 放大镜:+AlwaysOnTop +Resize +ToolWindow -Caption -Resize -DPIScale
    Gui 放大镜:Show, % "w" 2*Rx " h" 2*Ry, Magnifier
    WinGet MagnifierID, ID,  Magnifier
    WinSet Transparent, 255, Magnifier
    WinGet PrintSourceID, ID

    hdd_frame := DllCall("GetDC", UInt, PrintSourceID)
    hdc_frame := DllCall("GetDC", UInt, MagnifierID)
Return

Repaint:
    CoordMode Mouse, Screen
    MouseGetPos x, y
    xz := In(x-Zx-6,0,A_ScreenWidth-2*Zx)
    yz := In(y-Zy-6,0,A_ScreenHeight-2*Zy)
    if (x>FJL) and (x<FJR) ;中间屏幕
    {
        if (x>A_ScreenWidth/2+Round(A_ScreenHeight*(500/1080))) ;中线+500x
        {
            WinMove ahk_id %MagnifierID%,,x-Round(A_ScreenHeight*(80/1080))-Rx*2, y-Ry ;放大镜位置 左
        }
        else if (x<A_ScreenWidth/2-Round(A_ScreenHeight*(500/1080))) ;中线-500x
        {
            WinMove ahk_id %MagnifierID%,,x+Round(A_ScreenHeight*(80/1080)), y-Ry ;放大镜位置 右
        }
        else if (y>A_ScreenHeight/2+Round(A_ScreenHeight*(200/1080))) ;中线+200y
        {
            WinMove ahk_id %MagnifierID%,,x-Rx, y-Round(A_ScreenHeight*(80/1080))-Ry*2  ;放大镜位置 上
        }
        else
        {
            WinMove ahk_id %MagnifierID%,,x-Rx, y+Round(A_ScreenHeight*(80/1080)) ;放大镜位置 下
        }
    }
    else if (x<FJL) ;左边屏幕
    {
        if (x>SW/2+Round(A_ScreenHeight*(500/1080))) ;中线+500x
        {
            WinMove ahk_id %MagnifierID%,,x-Round(A_ScreenHeight*(80/1080))-Rx*2, y-Ry ;放大镜位置 左
        }
        else if (x<SW/2-Round(A_ScreenHeight*(500/1080))) ;中线-500x
        {
            WinMove ahk_id %MagnifierID%,,x+Round(A_ScreenHeight*(80/1080)), y-Ry ;放大镜位置 右
        }
        else if (y>A_ScreenHeight/2+Round(A_ScreenHeight*(200/1080))) ;中线+200y
        {
            WinMove ahk_id %MagnifierID%,,x-Rx, y-Round(A_ScreenHeight*(80/1080))-Ry*2  ;放大镜位置 上
        }
        else
        {
            WinMove ahk_id %MagnifierID%,,x-Rx, y+Round(A_ScreenHeight*(80/1080)) ;放大镜位置 下
        }
    }
    else if (x>FJR) ;右边屏幕
    {
        if (x>SW*2+SW/2+Round(A_ScreenHeight*(500/1080))) ;中线+500x
        {
            WinMove ahk_id %MagnifierID%,,x-Round(A_ScreenHeight*(80/1080))-Rx*2, y-Ry ;放大镜位置 左
        }
        else if (x<SW*2+SW/2-Round(A_ScreenHeight*(500/1080))) ;中线-500x
        {
            WinMove ahk_id %MagnifierID%,,x+Round(A_ScreenHeight*(80/1080)), y-Ry ;放大镜位置 右
        }
        else if (y>A_ScreenHeight/2+Round(A_ScreenHeight*(200/1080))) ;中线+200y
        {
            WinMove ahk_id %MagnifierID%,,x-Rx, y-Round(A_ScreenHeight*(80/1080))-Ry*2  ;放大镜位置 上
        }
        else
        {
            WinMove ahk_id %MagnifierID%,,x-Rx, y+Round(A_ScreenHeight*(80/1080)) ;放大镜位置 下
        }
    }

    DllCall("gdi32.dll\StretchBlt", UInt,hdc_frame, Int,0, Int,0, Int,2*Rx, Int,2*Ry, UInt,hdd_frame, UInt,xz, UInt,yz, Int,2*Zx, Int,2*Zy, UInt,0xCC0020) ; SRCCOPY
    DllCall("gdi32.dll\SetStretchBltMode", "uint", hdc_frame, "int", 4*antialize )
Return

GuiSize:
    Rx := A_GuiWidth/2
    Ry := A_GuiHeight/2
    Zx := Rx/zoom
    Zy := Ry/zoom
    TrayTip,,% "Frame  =  " Round(2*Zx) " × " Round(2*Zy) "`nMagnified to = " A_GuiWidth "×" A_GuiHeight
Return

锐化算法:
    if (antialize=0)
    {
        antialize:=1
        DllCall("gdi32.dll\SetStretchBltMode", "uint", hdc_frame, "int", 4*antialize )
        IniWrite %antialize%, Settings.ini, 设置, 锐化算法 ;写入设置到ini文件
        Menu Tray, UnCheck, 锐化算法 ;右键菜单不打勾
    }
    else
    {
        antialize:=0
        DllCall("gdi32.dll\SetStretchBltMode", "uint", hdc_frame, "int", 4*antialize )
        IniWrite %antialize%, Settings.ini, 设置, 锐化算法 ;写入设置到ini文件
        Menu Tray, Check, 锐化算法 ;右键菜单打勾
    }
return

关闭放大镜:
    SetTimer Repaint, Off
    DllCall("gdi32.dll\DeleteDC", UInt,hdc_frame )
    DllCall("gdi32.dll\DeleteDC", UInt,hdd_frame )
    Gui 放大镜:Destroy
    ; ToolTip X%X% Y%Y%`nL%FJL% R%FJR%, , , 2
    if (x<FJL) or (x>FJR) ;如果在两侧屏幕
    {
        HSJM:=0
        HSJH:=0
        WinShow ahk_id %MagnifierWindowID% ;打开后视镜

        if (HSJM=0) and (x<FJL) ;如果在左侧屏幕
        {
            WinMove ahk_id %MagnifierWindowID%, , HSJLX, HSJY
            HSJM:=1
        }
        else if (HSJM=0) and (x>FJR) ;如果在右侧屏幕
        {
            WinMove ahk_id %MagnifierWindowID%, , HSJRX, HSJY
            HSJM:=1
        }

        WinSet Transparent, 255, ahk_id %MagnifierWindowID%
        ; ToolTip 打开后视镜, , , 2
    }

    if (running=1)
        SetTimer 屏幕监测, 50
Return

打开放大镜:
    if (running=1)
        SetTimer 屏幕监测, Off
    IfWinActive ahk_id %MagnifierWindowID%
    {
        WinSet Transparent, 0, ahk_id %MagnifierWindowID%
        WinHide ahk_id %MagnifierWindowID% ;关闭后视镜
        HSJM:=0
        HSJH:=1
    }
    gosub 放大镜
    SetTimer Repaint, 30
Return

In(x,a,b) 
{
    IfLess x,%a%, Return a
    IfLess b,%x%, Return b
    Return x
}

~Shift::
    ; ToolTip 放大镜放大
    zoom *= 1.189207115
    KeyWait Shift
    Zx := Rx/zoom
    Zy := Ry/zoom
Return

~Ctrl::
    ; ToolTip 放大镜缩小
    zoom /= 1.189207115
    KeyWait Ctrl
    Zx := Rx/zoom
    Zy := Ry/zoom
Return