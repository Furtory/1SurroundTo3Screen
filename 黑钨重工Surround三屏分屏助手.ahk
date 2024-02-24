管理员模式:
IfExist, %A_ScriptDir%\Settings.ini ;如果配置文件存在则读取
{
  IniRead, AdminMode, Settings.ini, 设置, 管理权限
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

Menu, Tray, Icon, %A_ScriptDir%\Running.ico ;任务栏图标改成正在运行
Process, Priority, , Realtime
#MenuMaskKey vkE8
#WinActivateForce
#InstallKeybdHook
#InstallMouseHook
#Persistent
#NoEnv
#SingleInstance Force
#MaxHotkeysPerInterval 2000
#KeyHistory 2000
SendMode Input
SetBatchLines -1
CoordMode Pixel Screen
CoordMode ToolTip Screen
SetKeyDelay -1, 30
SetWorkingDir %A_ScriptDir%
OnExit, 退出软件 
Gui, +HWNDhGui
Global hPic

/*
黑钨重工出品 免费开源 请勿商用 侵权必究
在线logo转换 https://convertio.co/zh/
更多免费教程尽在QQ群 1群763625227 2群643763519
*/

MButton_presses:=0
running:=1 ;1为运行 0为暂停
Menu, Tray, NoStandard ;不显示默认的AHK右键菜单
Menu, Tray, Add, 屏幕设置, 屏幕设置 ;添加新的右键菜单
Menu, Tray, Add, 基础功能, 基础功能 ;添加新的右键菜单
Menu, Tray, Add, 进阶功能, 进阶功能 ;添加新的右键菜单
Menu, Tray, Add
Menu, Tray, Add, 管理权限, 管理权限 ;添加新的右键菜单
Menu, Tray, Add, 媒体快捷, 媒体快捷 ;添加新的右键菜单
Menu, Tray, Add, 兼容模式, 兼容模式 ;添加新的右键菜单
Menu, Tray, Add, 锐化算法, 锐化算法 ;添加新的右键菜单
Menu, Tray, Add, 开机自启, 开机自启 ;添加新的右键菜单
Menu, Tray, Add
Menu, Tray, Add, 暂停运行, 暂停运行 ;添加新的右键菜单
Menu, Tray, Add, 重启软件, 重启脚本 ;添加新的右键菜单
Menu, Tray, Add, 退出软件, 退出软件 ;添加新的右键菜单

autostartLnk:=A_StartupCommon . "\SurroundHelper.lnk" ;开机启动文件的路径
IfExist, % autostartLnk ;检查开机启动的文件是否存在
{
  autostart:=1
  Menu, Tray, Check, 开机自启 ;右键菜单打勾
}
else
{
  autostart:=0
  Menu, Tray, UnCheck, 开机自启 ;右键菜单不打勾
}

IfExist, %A_ScriptDir%\Settings.ini ;如果配置文件存在则读取
{
  LastWinTop:=""
  IniWrite, %LastWinTop%, Settings.ini, 设置, 被总是顶置的窗口 ;写入设置到ini文件
  OldLastWinTop:=""
  IniWrite, %OldLastWinTop%, Settings.ini, 设置, 上次被总是顶置的窗口 ;写入设置到ini文件
  
  IniRead, antialize, Settings.ini, 设置, 锐化算法 ;从ini文件读取设置
  if (antialize=1)
  {
    Menu, Tray, UnCheck, 锐化算法 ;右键菜单不打勾
    DllCall("gdi32.dll\SetStretchBltMode", "uint", hdc_frame, "int", 4*antialize )
  }
  else
  {
    Menu, Tray, Check, 锐化算法 ;右键菜单打勾
    DllCall("gdi32.dll\SetStretchBltMode", "uint", hdc_frame, "int", 4*antialize )
  }
  
  IniRead, CompatibleMode, Settings.ini, 设置, 兼容模式
  if (CompatibleMode=0)
  {
    Menu, Tray, UnCheck, 兼容模式 ;右键菜单不打勾
  }
  else
  {
    Menu, Tray, Check, 兼容模式 ;右键菜单打勾
  }
  
  IniRead, AdminMode, Settings.ini, 设置, 管理权限 ;从ini文件读取设置
  if (AdminMode=0)
  {
    Menu, Tray, UnCheck, 管理权限 ;右键菜单不打勾
  }
  else
  {
    Menu, Tray, Check, 管理权限 ;右键菜单打勾
  }
  
  IniRead, MiniWinIDL, Settings.ini, 设置, 左边屏幕最近一次被最小化的窗口 ;从ini文件读取设置
  IniRead, MiniWinIDM, Settings.ini, 设置, 中间屏幕最近一次被最小化的窗口 ;从ini文件读取设置
  IniRead, MiniWinIDR, Settings.ini, 设置, 右边屏幕最近一次被最小化的窗口 ;从ini文件读取设置
  
  IniRead, MasterWinIDL, Settings.ini, 设置, 左边屏幕主窗口 ;写入设置到ini文件
  IniRead, MasterWinIDM, Settings.ini, 设置, 中间屏幕主窗口 ;写入设置到ini文件
  IniRead, MasterWinIDR, Settings.ini, 设置, 右边屏幕主窗口 ;写入设置到ini文件
  
  IniRead, ActiveWindowID, Settings.ini, 设置, 后台等待激活的窗口 ;从ini文件读取设置
  
  IniRead, LastWinTop, Settings.ini, 设置, 被总是顶置的窗口 ;从ini文件读取设置
  IniRead, OldLastWinTop, Settings.ini, 设置, 上次被总是顶置的窗口 ;从ini文件读取设置
  
  IniRead, BlackListWindow, Settings.ini, 设置, 自动暂停黑名单 ;从ini文件读取设置
  
  IniRead, MediaWindow, Settings.ini, 设置, 呼出播放器 ;从ini文件读取设置
  
  IniRead, 上组合键, Settings.ini, 设置, 双击箭头上输出组合键 ;从ini文件读取设置
  IniRead, 下组合键, Settings.ini, 设置, 双击箭头下输出组合键 ;
  
  IniRead, BKXZ, Settings.ini, 设置, 边框修正 ;写入设置到ini文件
  
  IniRead, KDXZ, Settings.ini, 设置, 宽度修正 ;写入设置到ini文件
  IniRead, GDXZ, Settings.ini, 设置, 高度修正 ;写入设置到ini文件
}
else ;如果配置文件不存在则新建
{
  antialize:=1
  IniWrite, %antialize%, Settings.ini, 设置, 锐化算法 ;写入设置到ini文件
  
  CompatibleMode:=0
  IniWrite, %CompatibleMode%, Settings.ini, 设置, 兼容模式 ;写入设置到ini文件
  
  AdminMode:=0
  IniWrite, %AdminMode%, Settings.ini, 设置, 管理权限 ;写入设置到ini文件
  
  MiniWinIDL:=0
  MiniWinIDM:=0
  MiniWinIDR:=0
  IniWrite, %MiniWinIDL%, Settings.ini, 设置, 左边屏幕最近一次被最小化的窗口 ;写入设置到ini文件
  IniWrite, %MiniWinIDM%, Settings.ini, 设置, 中间屏幕最近一次被最小化的窗口 ;写入设置到ini文件
  IniWrite, %MiniWinIDR%, Settings.ini, 设置, 右边屏幕最近一次被最小化的窗口 ;写入设置到ini文件
  
  MasterWinIDL:=0
  MasterWinIDM:=0
  MasterWinIDR:=0
  IniWrite, %MasterWinIDL%, Settings.ini, 设置, 左边屏幕主窗口 ;写入设置到ini文件
  IniWrite, %MasterWinIDM%, Settings.ini, 设置, 中间屏幕主窗口 ;写入设置到ini文件
  IniWrite, %MasterWinIDR%, Settings.ini, 设置, 右边屏幕主窗口 ;写入设置到ini文件
  
  ActiveWindowID:=""
  IniWrite, %ActiveWindowID%, Settings.ini, 设置, 后台等待激活的窗口 ;写入设置到ini文件
  
  LastWinTop:=""
  IniWrite, %LastWinTop%, Settings.ini, 设置, 被总是顶置的窗口 ;写入设置到ini文件
  OldLastWinTop:=""
  IniWrite, %OldLastWinTop%, Settings.ini, 设置, 上次被总是顶置的窗口 ;写入设置到ini文件
  
  BlackListWindow:=""
  IniWrite, %BlackListWindow%, Settings.ini, 设置, 自动暂停黑名单 ;写入设置到ini文件
  
  MediaWindow:=""
  IniWrite, %MediaWindow%, Settings.ini, 设置, 呼出播放器 ;写入设置到ini文件
  
  IniWrite, %上组合键%, Settings.ini, 设置, 双击箭头上输出组合键 ;写入设置到ini文件
  IniWrite, %下组合键%, Settings.ini, 设置, 双击箭头下输出组合键 ;写入设置到ini文件
  
  BKXZ:=0
  IniWrite, %BKXZ%, Settings.ini, 设置, 边框修正 ;写入设置到ini文件
  
  KDXZ:=Ceil(16*(A_ScreenHeight/1080)) ;宽度修正 如果全屏后窗口仍然没有填满屏幕增加这个值 一般是8的倍数
  GDXZ:=Ceil(8*(A_ScreenHeight/1080)) ;高度修正 如果全屏后窗口仍然没有填满屏幕增加这个值 一般是8的倍数
  IniWrite, %KDXZ%, Settings.ini, 设置, 宽度修正 ;写入设置到ini文件
  IniWrite, %GDXZ%, Settings.ini, 设置, 高度修正 ;写入设置到ini文件
}

SH:=A_ScreenHeight+GDXZ ;修正后屏幕高度
SW:=Round((A_ScreenWidth-2*BKXZ)/3)+KDXZ ;修正后屏幕宽度
RSW:=Floor((A_ScreenWidth-2*BKXZ)/3) ;物理屏幕宽度

FJL:=Floor(A_ScreenWidth/3-BKXZ/2) ;左分界线
FJR:=Ceil(A_ScreenWidth/3*2+BKXZ/2) ;右分界线
YDY:=0 ;屏幕原点Y
YDL:=Floor(0-KDXZ/2) ;左边屏幕左上角原点X
YDM:=Floor(RSW+BKXZ-KDXZ/2) ;中间屏幕左上角原点X
YDR:=Floor(RSW*2+BKXZ*2-KDXZ/2) ;右边屏幕左上角原点X

WinTop:=Round(A_ScreenHeight*(45/1080)) ;窗口顶部识别分界线
ScreenBottom:=A_ScreenHeight-Floor(A_ScreenHeight*(50/1080)) ;屏幕底部识别分界线
ScreenBottomMax:=A_ScreenHeight-Floor(A_ScreenHeight*(180/1080)) ;隐藏任务栏识别分界线
; MsgBox %SW% %SH%

HSJ:=0 ;后视镜打开状态
HSJM:=0 ;后视镜移动状态
rWidth:=Round(SW*(640/1920)) ;后视镜宽度
rHeight:=Round(A_ScreenHeight*(420/1080)) ;后视镜高度
HSJLX:=YDM+Round(A_ScreenHeight*(50/1080)) ;左后视镜显示位置X
HSJRX:=YDR-rWidth-Round(A_ScreenHeight*(50/1080)+(A_ScreenWidth-SW*3)/2+KDXZ/2) ;右后视镜显示位置X
HSJY:=A_ScreenHeight/2-rHeight/2 ;后视镜显示位置Y
HWNDarr:=[WinExist("ahk_class AHKEditor"), hGui]  ; 不需要显示后视镜窗口的黑名单 填WinTitle
黑名单:=0
媒体快捷键:=1
暂停:=0
SetTimer, 屏幕监测, 100 ;监测鼠标位置打开后视镜

FDJ:=0 ;放大镜打开状态
FDJM:=0 ;放大镜移动状态
zoom := 2 ;放大镜缩放倍率
Rx := Round(A_ScreenHeight*(100/1080))
Ry := Round(A_ScreenHeight*(100/1080))
Zx := Rx/zoom
Zy := Ry/zoom

TaskBar:=1 ;任务栏状态 1开启 0关闭

TopOpacity:=255 ;顶置窗口透明度
TopWindowTransparent:=0 ;顶置窗口穿透
return

屏幕设置:
OldBKXZ:=BKXZ
OldGDXZ:=GDXZ
OldKDXZ:=KDXZ
Gui 屏幕设置:+DPIScale -MinimizeBox -MaximizeBox -Resize -SysMenu
Gui 屏幕设置:Font, s9, Segoe UI
Gui 屏幕设置:Add, Picture, x-3 y-97 w1000 h600, %A_ScriptDir%\3屏示意图.jpg
Gui 屏幕设置:Add, Button, x778 y361 w94 h51 GButton确认2, &确认
Gui 屏幕设置:Add, Button, x877 y361 w94 h51 GButton取消2, &取消

Gui 屏幕设置:Add, Text, x387 y19 w120 h23 +0x200, 边框宽度
Gui 屏幕设置:Add, Edit, x387 y42 w120 h21 Number vBKXZ, %BKXZ%

Gui 屏幕设置:Add, Text, x700 y168 w120 h23 +0x200, 屏幕额外高度
Gui 屏幕设置:Add, Edit, x699 y191 w122 Number vGDXZ, %GDXZ%

Gui 屏幕设置:Add, Text, x438 y338 w120 h23 +0x200, 屏幕额外宽度
Gui 屏幕设置:Add, Edit, x438 y361 w120 h21 Number vKDXZ, %KDXZ%

Gui 屏幕设置:Show, w995 h433, 屏幕设置
Return

Button确认2:
Gui, 屏幕设置:Submit, NoHide
Gui, 屏幕设置:Destroy
IniWrite, %BKXZ%, Settings.ini, 设置, 边框修正 ;写入设置到ini文件
IniWrite, %KDXZ%, Settings.ini, 设置, 宽度修正 ;写入设置到ini文件
IniWrite, %GDXZ%, Settings.ini, 设置, 高度修正 ;写入设置到ini文件
return

Button取消2:
BKXZ:=OldBKXZ
GDXZ:=OldGDXZ
KDXZ:=OldKDXZ
Gui, 屏幕设置:Destroy
return


黑名单:
黑名单:=0
if (WinName="WorkerW") or (WinName="_cls_desk_") or (WinName="Progman") or (WinName="ActualTools_MultiMonitorTaskbar") or (WinName="SciTEWindow") ;黑名单列表 双引号内填类名 ahk_class
{
  Critical, Off
  黑名单:=1 ;如果在黑名单列表的窗口内操作则不执行
}
return

WheelUp:
Hotkey, ~WheelUp, On
return

~WheelUp:: ;触发按键 滚轮上
Hotkey, ~WheelUp, Off
Critical, On
CoordMode Mouse, Screen ;以屏幕为基准
MouseGetPos, MX, MY ;获取鼠标在屏幕中的位置
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
  SetTimer, 关闭提示, -500 ;500毫秒后关闭提示
}
else
{
  CoordMode Mouse, Window ;以窗口为基准
  MouseGetPos, WX, WY, WinID ;获取鼠标在窗口中的位置
  WinGetClass, WinName, ahk_id %WinID% ;获取窗口类名
  gosub 黑名单
  if (黑名单=1)
  {
    return
  }
  WinGetPos, SX, SY, W, H, ahk_id %WinID% ;获取窗口以屏幕为基准的位置 窗口的宽和高
  WinInScreenX:=SX+W/2 ;窗口中间以屏幕为基准的位置
  WinRestore, ahk_id %WinID% ;如果窗口已经最大化则还原窗口
  ; MsgBox ID:%WinID%`nX:%X% Y:%Y%`nW:%W% H:%H%`n`n左分界线:%FJL%`n右分界线:=%FJR%`n鼠标位置 X:%SX% Y:%SY%
  if (WinInScreenX<FJL) and (WY<WinTop) ;点击的窗口在左边屏幕 并且 点击位置在窗口顶部
  {
    ToolTip 最大化%WinID%窗口
    WinRestore, ahk_id %WinID%
    WinMove, ahk_id %WinID%, ,YDL ,YDY ,SW ,SH ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
    SetTimer, 关闭提示, -500 ;500毫秒后关闭提示
  }
  else if (WinInScreenX>FJL) and (WinInScreenX<FJR) and (WY<WinTop) ;点击的窗口在中间屏幕 并且 点击位置在窗口顶部
  {
    ToolTip 最大化%WinID%窗口
    WinRestore, ahk_id %WinID%
    WinMove, ahk_id %WinID%, ,YDM ,YDY ,SW ,SH ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
    SetTimer, 关闭提示, -500 ;500毫秒后关闭提示
  }
  else if (WinInScreenX>FJR) and (WY<WinTop) ;点击的窗口在右边屏幕 并且 点击位置在窗口顶部
  {
    ToolTip 最大化%WinID%窗口
    WinRestore, ahk_id %WinID%
    WinMove, ahk_id %WinID%, ,YDR ,YDY ,SW ,SH ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
    SetTimer, 关闭提示, -500 ;500毫秒后关闭提示
  }
}
Critical, Off
SetTimer, WheelUp, -100
return

WheelDown:
Hotkey, ~WheelDown, On
return

~WheelDown:: ;触发按键 滚轮下
Hotkey, ~WheelDown, Off
Critical, On
CoordMode Mouse, Screen ;以屏幕为基准
MouseGetPos, MX, MY ;获取鼠标在屏幕中的位置
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
  SetTimer, 关闭提示, -500 ;500毫秒后关闭提示
}
else
{
  CoordMode Mouse, Window ;以窗口为基准
  MouseGetPos, , WY, WinID ;获取鼠标在窗口中的位置
  WinGetClass, WinName, ahk_id %WinID% ;获取窗口类名
  gosub 黑名单
  if (黑名单=1)
  {
    return
  }
  else if (WY<WinTop) ;点击位置在窗口顶部
  {
    ToolTip 最小化%WinID%窗口
    WinMinimize, ahk_id %WinID% ;最小化窗口
    if (屏幕实时位置=1)
    {
      MiniWinIDL:=WinID ;记录最近一次被最小化的窗口
      IniWrite, %MiniWinIDL%, Settings.ini, 设置, 左边屏幕最近一次被最小化的窗口 ;写入设置到ini文件
      if (MiniWinIDL=MasterWinIDL)
      {
        MasterWinIDL:=0
        IniWrite, %MasterWinIDL%, Settings.ini, 设置, 左边屏幕主窗口 ;写入设置到ini文件
      }
    }
    else if (屏幕实时位置=2)
    {
      MiniWinIDM:=WinID ;记录最近一次被最小化的窗口
      IniWrite, %MiniWinIDM%, Settings.ini, 设置, 中间屏幕最近一次被最小化的窗口 ;写入设置到ini文件
      if (MiniWinIDM=MasterWinIDM)
      {
        MasterWinIDM:=0
        IniWrite, %MasterWinIDM%, Settings.ini, 设置, 中间屏幕主窗口 ;写入设置到ini文件
      }
    }
    else if (屏幕实时位置=3)
    {
      MiniWinIDR:=WinID ;记录最近一次被最小化的窗口
      IniWrite, %MiniWinIDR%, Settings.ini, 设置, 右边屏幕最近一次被最小化的窗口 ;写入设置到ini文件
      if (MiniWinIDR=MasterWinIDR)
      {
        MasterWinIDR:=0
        IniWrite, %MasterWinIDR%, Settings.ini, 设置, 右边屏幕主窗口 ;写入设置到ini文件
      }
    }
    SetTimer, 关闭提示, -500 ;500毫秒后关闭提示
  }
}
Critical, Off
SetTimer, WheelDown, -100
return

~+LButton:: ;Shift+左键
Critical, On
CoordMode Mouse, Window ;以窗口为基准
MouseGetPos, , WindowY, WinID ;;获取鼠标在窗口中的位置
WinGetClass, WinName, ahk_id %WinID% ;获取窗口类名
gosub 黑名单
if (黑名单=1)
{
  return
}
else if (WindowY<WinTop) ;如果没有处于总是顶置状态 并且 点击在窗口顶部
{
  if (屏幕实时位置=1)
  {
    MasterWinIDL:=WinID ;记录主窗口
    IniWrite, %MasterWinIDL%, Settings.ini, 设置, 左边屏幕主窗口 ;写入设置到ini文件
    if (MasterWinIDL=MiniWinIDL)
    {
      MiniWinIDL:=0
      IniWrite, %MiniWinIDL%, Settings.ini, 设置, 左边屏幕最近一次被最小化的窗口 ;写入设置到ini文件
    }
    ToolTip 设定%MasterWinIDL%左边屏幕主窗口
  }
  else if (屏幕实时位置=2)
  {
    MasterWinIDM:=WinID ;记录主窗口
    IniWrite, %MasterWinIDM%, Settings.ini, 设置, 中间屏幕主窗口 ;写入设置到ini文件
    if (MasterWinIDM=MiniWinIDM)
    {
      MiniWinIDM:=0
      IniWrite, %MiniWinIDM%, Settings.ini, 设置, 中间屏幕最近一次被最小化的窗口 ;写入设置到ini文件
    }
    ToolTip 设定%MasterWinIDM%中间屏幕主窗口
  }
  else if (屏幕实时位置=3)
  {
    MasterWinIDR:=WinID ;记录主窗口
    IniWrite, %MasterWinIDR%, Settings.ini, 设置, 右边屏幕主窗口 ;写入设置到ini文件
    if (MasterWinIDR=MiniWinIDR)
    {
      MiniWinIDR:=0
      IniWrite, %MiniWinIDR%, Settings.ini, 设置, 右边屏幕最近一次被最小化的窗口 ;写入设置到ini文件
    }
    ToolTip 设定%MasterWinIDR%右边屏幕主窗口
  }
  SetTimer, 关闭提示, -500 ;500毫秒后关闭提示
}
Critical, Off
return

~^LButton:: ;Ctrl+左键
Critical, On
CoordMode Mouse, Window ;以窗口为基准
MouseGetPos, , WindowY, WinID ;;获取鼠标在窗口中的位置
WinGetClass, WinName, ahk_id %WinID% ;获取窗口类名
WinGet, 窗口样式, ExStyle, ahk_id %WinID% ;获取窗口样式
窗口样式:= (窗口样式 & 0x8) ? true : false ;验证窗口是否处于总是顶置状态
; ToolTip %窗口样式%
if (窗口样式=0) and (WindowY<WinTop) ;如果没有处于总是顶置状态 并且 点击在窗口顶部
{
  MouseGetPos, , , WinID ;获取鼠标所在窗口的句柄
  WinGetTitle, ActiveWindowID, ahk_id %WinID% ;根据句柄获取窗口的名字
  ToolTip 窗口%ActiveWindowID%已准备好等待激活
  IniWrite, %ActiveWindowID%, Settings.ini, 设置, 后台等待激活的窗口 ;写入设置到ini文件
  KeyWait LButton
  ToolTip
  Critical, Off
  Return
}
else if (窗口样式=1) and (WindowY>WinTop) ;如果已经处于总是顶置状态 并且 没有点击在窗口顶部
{
  CoordMode Mouse, Screen ;以屏幕为基准
  MouseGetPos, , ScreenOldY, WinID ;;获取鼠标在屏幕中的位置
  Loop 30 ;如果300ms内不移动不调整透明度左键也不会抬起
  {
    if !GetKeyState("LButton", "P") ;左键抬起则暂停
    {
      break
    }
    
    Sleep 10
    CoordMode Mouse, Screen ;以屏幕为基准
    MouseGetPos, , ScreenY, WinID ;获取鼠标在屏幕中的位置
    if (ScreenY=ScreenOldY) ;如果鼠标没有移动
    {
      continue
    }
    else ;鼠标移动了
    {
      Send {LButton Up} ;抬起左键后再调整透明度
    }
    
    WinGetClass, WinName, ahk_id %WinID% ;获取窗口类名
    LastWinTop:=WinID
    IniWrite, %LastWinTop%, Settings.ini, 设置, 被总是顶置的窗口 ;写入设置到ini文件
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
        WinSet, Transparent, %TopOpacity%, ahk_id %LastWinTop%
        SetTimer, 关闭提示, -500 ;500毫秒后关闭提示
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
        WinSet, Transparent, %TopOpacity%, ahk_id %LastWinTop%
        SetTimer, 关闭提示, -500 ;500毫秒后关闭提示
      }
    }
  }
  KeyWait LButton
}
Critical, Off
return

~LButton:: ;左键
Critical, On
CoordMode Mouse, Screen ;以屏幕为基准
MouseGetPos, , WinSY ;;获取鼠标在屏幕中的位置
CoordMode Mouse, Window ;以窗口为基准
MouseGetPos, , WinWY, WinID  ;获取鼠标在窗口中的位置 获取鼠标所在窗口的句柄
WinGetTitle, WinName, ahk_id %WinID% ;获取窗口类名
WinGetClass, WinClass, ahk_id %WinID% ;获取窗口类名
WinGet, 窗口样式, ExStyle, ahk_id %WinID% ;获取窗口样式
窗口样式:= (窗口样式 & 0x8) ? true : false ;验证窗口是否处于总是顶置状态

if (WinExist("ahk_id" LastWinTop)=0) ;如果被总是顶置的窗口不存在 清除对应设置
{
  LastWinTop:=""
  IniWrite, %LastWinTop%, Settings.ini, 设置, 被总是顶置的窗口 ;写入设置到ini文件"
}
else
{
  if (窗口样式=1) and (WinName!="QQ") and (WinName!="任务管理器") and (WinClass!="Shell_TrayWnd") ;窗口处于顶置
  { 
    if (OldLastWinTop!="") and (WinID!=OldLastWinTop) ;上次被总是顶置的窗口 点击的窗口不是设置了鼠标穿透的
    {
      ToolTip 已恢复上一个总是顶置的窗口为初始状态
      TopWindowTransparent:=0
      WinSet, ExStyle, -0x20, ahk_id %OldLastWinTop% ;关闭鼠标穿透
      TopOpacity:=255
      WinSet, Transparent, %TopOpacity%, ahk_id %OldLastWinTop%
      WinSet, AlwaysOnTop, Off, ahk_id %OldLastWinTop%  ;切换窗口的顶置状态
      OldLastWinTop:=""
      IniWrite, %OldLastWinTop%, Settings.ini, 设置, 上次被总是顶置的窗口 ;写入设置到ini文件
    }
    LastWinTop:=WinID ;更新鼠标穿透对象
    IniWrite, %LastWinTop%, Settings.ini, 设置, 被总是顶置的窗口 ;写入设置到ini文件
    WinGet, TopOpacity, Transparent, ahk_id %WinID% ;获取窗口透明度
    ; ToolTip 当前窗口透明度`：%TopOpacity%
    if (TopOpacity="") ;如果没有设置透明度
    {
      TopOpacity:=255 ;当前窗口透明度等于255
      WinSet, Transparent, %TopOpacity%, ahk_id %LastWinTop%
    }
  }
}

WinGetPos, , , WinW, WinH, ahk_id %WinID% ;获取窗口的宽度和高度
if (WinWY<WinTop) and (WinW>=SW) and (WinH>=SH) ;鼠标点击在最大化的窗口顶部
{
  WinHide, ahk_id %MagnifierWindowID% ;关闭放大镜
  DllCall("QueryPerformanceFrequency", "Int64*", freq)
  DllCall("QueryPerformanceCounter", "Int64*", LBDown)
  OldWinSY:=WinSY
  KeyWait LButton
  CoordMode Mouse, Screen ;以屏幕为基准
  MouseGetPos, WinSX, WinSY ;;获取鼠标在屏幕中的位置
  DllCall("QueryPerformanceCounter", "Int64*", LBUp)
  按下时间:=(LBUp-LBDown)/freq*1000
  MoveSpeed:=Abs(Round((WinSY-OldWinSY)/按下时间*1000)) ;移动速度=移动距离/时间
  ; MsgBox 鼠标移动速度是%MoveSpeed%像素/秒
  if (MoveSpeed>Round(A_ScreenHeight*(1500/1080))) ;如果鼠标移动速度超过1500像素/秒
  {
    WinClose, ahk_id %WinID% ;关闭窗口
  }
  else if (WinSY>Round(A_ScreenHeight*(50/1080))) and (WinW!=Round(SW/5*3)) and (WinH!=Round(SH/5*3)) and (WinSY-OldWinSY>Round(A_ScreenHeight*(80/1080))) ;如果鼠标移动了窗口低于屏幕顶部范围
  {
    CoordMode Mouse, Screen ;以屏幕为基准 
    MouseGetPos, WinSX, WinSY ;;获取鼠标在屏幕中的位置
    WinRestore, ahk_id %WinID%
    WinMove, ahk_id %WinID%, ,WinSX-Round(SW/5*3/2) ,WinSY-Round(A_ScreenHeight*(10/1080)) ,Round(SW/5*3) ,Round(SH/5*3) ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
  }
}
else if (WinWY<WinTop) ;鼠标点击在窗口顶部
{
  WinHide, ahk_id %MagnifierWindowID% ;关闭放大镜
  LoopTimes:=20 ;检测2秒
  gosub AeroShake ;跳转检测程序
  if (摇晃次数>3) and (总移动距离>=Round(A_ScreenHeight*(800/1080)))
  {
    ; ToolTip %窗口样式%
    if (窗口样式=0) ;如果没有处于总是顶置状态
    {
      Critical On
      if (LastWinTop!="") and (LastWinTop!=WinID)
      {
        OldLastWinTop:=LastWinTop
        IniWrite, %OldLastWinTop%, Settings.ini, 设置, 上次被总是顶置的窗口 ;写入设置到ini文件
      }
      
      if (OldLastWinTop!="")
      {
        TopWindowTransparent:=0
        WinSet, ExStyle, -0x20, ahk_id %OldLastWinTop% ;关闭鼠标穿透
        TopOpacity:=255
        WinSet, Transparent, %TopOpacity%, ahk_id %OldLastWinTop%
        WinSet, AlwaysOnTop, Off, ahk_id %OldLastWinTop%  ;切换窗口的顶置状态
        OldLastWinTop:=""
        IniWrite, %OldLastWinTop%, Settings.ini, 设置, 上次被总是顶置的窗口 ;写入设置到ini文件
      }
      
      LastWinTop:=WinID
      WinSet, AlwaysOnTop, On, ahk_id %LastWinTop%  ;切换窗口的顶置状态
      IniWrite, %LastWinTop%, Settings.ini, 设置, 被总是顶置的窗口 ;写入设置到ini文件
      Loop 20
      {
        ToolTip 窗口%LastWinTop%设为总是顶置 O
        Sleep 30
      }
      Critical Off
    }
    else ;如果已经处于总是顶置状态
    {
      Critical On
      TopWindowTransparent:=0
      WinSet, ExStyle, -0x20, ahk_id %LastWinTop% ;关闭鼠标穿透
      WinSet, AlwaysOnTop, Off, ahk_id %LastWinTop%  ;切换窗口的顶置状态
      TopOpacity:=255
      WinSet, Transparent, %TopOpacity%, ahk_id %LastWinTop%
      LastWinTop:=""
      IniWrite, %LastWinTop%, Settings.ini, 设置, 被总是顶置的窗口 ;写入设置到ini文件
      Loop 20
      {
        ToolTip 窗口%LastWinTop%取消总是顶置 -
        Sleep 30
      }
      Critical Off  
    }
  }
}
ToolTip
Critical Off
return

~Tab::
if (WinExist("ahk_id" LastWinTop)=0) ;如果被总是顶置的窗口不存在 清除对应设置
{
  LastWinTop:=""
  IniWrite, %LastWinTop%, Settings.ini, 设置, 被总是顶置的窗口 ;写入设置到ini文件"
}
else if (LastWinTop!="") and (WinExist("ahk_id" LastWinTop)!=0)
{
  if (TopWindowTransparent=0) and (TopOpacity!=255) and (TopOpacity!="") ;如果没有开启鼠标穿透 
  {
    ToolTip 已打开鼠标穿透
    TopWindowTransparent:=1
    WinSet, ExStyle, +0x20, ahk_id %LastWinTop% ;打开鼠标穿透
  }
  else if (TopWindowTransparent=1) ;如果已经开启鼠标穿透
  {
    ToolTip 已关闭鼠标穿透
    TopWindowTransparent:=0
    WinSet, ExStyle, -0x20, ahk_id %LastWinTop% ;关闭鼠标穿透
  }
  Return
}
Return

AeroShake:
摇晃次数:=0
移动方向:=0 ;向左-1 向右1
移动距离:=0
总移动距离:=0
CoordMode Mouse, Screen ;以屏幕为基准
MouseGetPos, WinSX ;;获取鼠标在屏幕中的位置
Loop %LoopTimes% ;监测时间1次循环等于0.15秒
{
  ; ToolTip 摇晃次数:%摇晃次数%`n移动速度:%MoveSpeed%
  DllCall("QueryPerformanceFrequency", "Int64*", freq)
  DllCall("QueryPerformanceCounter", "Int64*", LBDown) ;第一次记录时间
  上次移动方向:=移动方向
  OldWinSX:=WinSX
  Sleep 100
  MouseGetPos, WinSX ;;获取鼠标在屏幕中的位置
  DllCall("QueryPerformanceCounter", "Int64*", LBUp) ;第二次记录时间
  移动距离:=Abs(WinSX-OldWinSX)
  总移动距离:=总移动距离+移动距离
  按下时间:=(LBUp-LBDown)/freq*1000 ;按下时间=第二次记录时间-第一次记录时间
  MoveSpeed:=Round(移动距离/按下时间*1000) ;移动速度=移动距离/时间
  if !GetKeyState("LButton", "P") and !GetKeyState("MButton", "P") ;左键抬起则暂停
  {
    break
  }
  else if (MoveSpeed<=Round(A_ScreenHeight*(1200/1080))) ;如果速度小于100像素/秒
  {
    continue ;不记录
  }
  
  if (WinSX-OldWinSX>0) ;向左移动
  {
    移动方向:=-1 ;向左-1 向右1
  }
  else if (WinSX-OldWinSX<0) ;向右移动
  {
    移动方向:=1 ;向左-1 向右1
  }
  
  if (上次移动方向!=移动方向) ;移动方向改变过
  {
    摇晃次数:=摇晃次数+1
  }
}
Return

$MButton:: ;中键
Critical, On
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
  WinHide, ahk_id %MagnifierWindowID%
  HSJM:=0
  
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
    SetTimer, KeyMButton, -500 ; 启动在 500 毫秒内等待更多键击的计时器
    Critical Off
    Return
  }

  CoordMode Mouse, Screen ;以屏幕为基准
  MouseGetPos, MXOld, MYOld, WinID ;获取鼠标在屏幕中的位置
  WinGetClass, WinName, ahk_id %WinID% ;获取窗口类名
  
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
  MouseGetPos, MXNew ;;获取鼠标在屏幕中的位置
  loop ;循环 放大镜功能 窗口传送功能
  {
    上次移动方向:=移动方向
    MXRecor:=MXNew
    Sleep 30
    MouseGetPos, MXNew
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
      ToolTip 打开放大镜
      if (FDJ=0)
      {
        SetTimer, 放大镜, -1
        SetTimer, 打开放大镜, -1
        FDJ:=1
      }
      else
      {
        SetTimer, 打开放大镜, -1
      }
      
      Sleep 300
      SetTimer, 关闭提示, -300 ;300毫秒后关闭提示
      Loop
      {
        if !GetKeyState("MButton", "P") ;抬起中键时关闭放大镜 Win+Esc
        {
          Hotkey, Shift, Off
          Hotkey, Ctrl, Off
          break
        }  
        
        Hotkey, Shift, On
        Hotkey, Ctrl, On
      }
      
      ToolTip 关闭放大镜
      FDJ:=0
      FDJM:=0
      SetTimer, 关闭放大镜, -1
      SetTimer, 关闭提示, -300 ;300毫秒后关闭提示
      
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
        MouseGetPos, MXNew
        
        if (MXNew>增加音量) ;向右滑动 增加音量
        {
          YLTZ:=1
          MXOld:=MXNew
          Send {Volume_Up}
          SoundGet, 音量
          音量:=Round(音量)
          ToolTip 增加音量+%音量%
        }
        else if (MXNew<降低音量) ;向左滑动 增加音量
        {
          YLTZ:=1
          MXOld:=MXNew
          Send {Volume_Down}
          SoundGet, 音量
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
              Hotkey, Left, On
              Hotkey, Right, On
              Hotkey, Up, On
              Hotkey, Down, On
              ToolTip 媒体快捷键已打开
            }
            else
            {
              ToolTip 播放/暂停媒体
              Send {Media_Play_Pause}
            }
          }
          MButton_presses:=0 ;键击记录重置为0
          SetTimer, 关闭提示, -500 ;500毫秒后关闭提示
          Critical Off
          Return
        }
      }
    }
  }
  
  if (屏幕位置=1)
  {
    if (MXNew>FJR) ;左边屏幕 到 右边屏幕
    {
      if (WinID=MiniWinIDL)
      {
        MiniWinIDR:=WinID
        IniWrite, %MiniWinIDR%, Settings.ini, 设置, 右边屏幕最近一次被最小化的窗口 ;写入设置到ini文件
        MiniWinIDL:=0
        IniWrite, %MiniWinIDL%, Settings.ini, 设置, 左边屏幕最近一次被最小化的窗口 ;写入设置到ini文件
      }
      else if (WinID=MasterWinIDL)
      {
        MasterWinIDR:=WinID
        IniWrite, %MasterWinIDR%, Settings.ini, 设置, 右边屏幕主窗口 ;写入设置到ini文件
        MasterWinIDL:=0
        IniWrite, %MasterWinIDL%, Settings.ini, 设置, 左边屏幕主窗口 ;写入设置到ini文件
      }
      
      ToolTip 发送%WinID%窗口到右边屏幕
      WinRestore, ahk_id %WinID%
      WinMove, ahk_id %WinID%, ,YDR ,YDY ,SW ,SH ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
      SetTimer, 关闭提示, -500 ;500毫秒后关闭提示
      MButton_presses:=0 ;键击记录重置为0
      Critical, Off
      return
    }
    else if (MXNew>FJL) ;左边屏幕 到 中间屏幕
    {
      if (WinID=MiniWinIDL)
      {
        MiniWinIDM:=WinID
        IniWrite, %MiniWinIDM%, Settings.ini, 设置, 中间屏幕最近一次被最小化的窗口 ;写入设置到ini文件
        MiniWinIDL:=0
        IniWrite, %MiniWinIDL%, Settings.ini, 设置, 左边屏幕最近一次被最小化的窗口 ;写入设置到ini文件
      }
      else if (WinID=MasterWinIDL)
      {
        MasterWinIDM:=WinID
        IniWrite, %MasterWinIDM%, Settings.ini, 设置, 中间屏幕主窗口 ;写入设置到ini文件
        MasterWinIDL:=0
        IniWrite, %MasterWinIDL%, Settings.ini, 设置, 左边屏幕主窗口 ;写入设置到ini文件
      }
      
      ToolTip 发送%WinID%窗口到中间屏幕
      WinRestore, ahk_id %WinID%
      WinMove, ahk_id %WinID%, ,YDM ,YDY ,SW ,SH ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
      SetTimer, 关闭提示, -500 ;500毫秒后关闭提示
      MButton_presses:=0 ;键击记录重置为0
      Critical, Off
      return
    }
  }
  else if (屏幕位置=2)
  {
    if (MXNew<FJL) ;中间屏幕 到 左边屏幕
    {
      if (WinID=MiniWinIDM)
      {
        MiniWinIDL:=WinID
        IniWrite, %MiniWinIDL%, Settings.ini, 设置, 左边屏幕最近一次被最小化的窗口 ;写入设置到ini文件
        MiniWinIDM:=0
        IniWrite, %MiniWinIDM%, Settings.ini, 设置, 中间屏幕最近一次被最小化的窗口 ;写入设置到ini文件
      }
      else if (WinID=MasterWinIDM)
      {
        MasterWinIDL:=WinID
        IniWrite, %MasterWinIDL%, Settings.ini, 设置, 左边屏幕主窗口 ;写入设置到ini文件
        MasterWinIDM:=0
        IniWrite, %MasterWinIDM%, Settings.ini, 设置, 中间屏幕主窗口 ;写入设置到ini文件
      }
      
      ToolTip 发送%WinID%窗口到左边屏幕
      WinRestore, ahk_id %WinID%
      WinMove, ahk_id %WinID%, ,YDL ,YDY ,SW ,SH ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
      SetTimer, 关闭提示, -500 ;500毫秒后关闭提示
      MButton_presses:=0 ;键击记录重置为0
      Critical, Off
      return
    }
    else if (MXNew>FJR) ;中间屏幕 到 右边屏幕
    {
      if (WinID=MiniWinIDM)
      {
        MiniWinIDR:=WinID
        IniWrite, %MiniWinIDR%, Settings.ini, 设置, 右边屏幕最近一次被最小化的窗口 ;写入设置到ini文件
        MiniWinIDM:=0
        IniWrite, %MiniWinIDM%, Settings.ini, 设置, 中间屏幕最近一次被最小化的窗口 ;写入设置到ini文件
      }
      else if (WinID=MasterWinIDM)
      {
        MasterWinIDR:=WinID
        IniWrite, %MasterWinIDR%, Settings.ini, 设置, 右边屏幕主窗口 ;写入设置到ini文件
        MasterWinIDM:=0
        IniWrite, %MasterWinIDM%, Settings.ini, 设置, 中间屏幕主窗口 ;写入设置到ini文件
      }
      
      ToolTip 发送%WinID%窗口到右边屏幕
      WinRestore, ahk_id %WinID%
      WinMove, ahk_id %WinID%, ,YDR ,YDY ,SW ,SH ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
      SetTimer, 关闭提示, -500 ;500毫秒后关闭提示
      MButton_presses:=0 ;键击记录重置为0
      Critical, Off
      return
    }
  }
  else if (屏幕位置=3)
  {
    if (MXNew<FJL) ;右边屏幕 到 左边屏幕
    {
      if (WinID=MiniWinIDR)
      {
        MiniWinIDL:=WinID
        IniWrite, %MiniWinIDL%, Settings.ini, 设置, 左边屏幕最近一次被最小化的窗口 ;写入设置到ini文件
        MiniWinIDR:=0
        IniWrite, %MiniWinIDR%, Settings.ini, 设置, 右边屏幕最近一次被最小化的窗口 ;写入设置到ini文件
      }
      else if (WinID=MasterWinIDR)
      {
        MasterWinIDL:=WinID
        IniWrite, %MasterWinIDL%, Settings.ini, 设置, 左边屏幕主窗口 ;写入设置到ini文件
        MasterWinIDR:=0
        IniWrite, %MasterWinIDR%, Settings.ini, 设置, 右边屏幕主窗口 ;写入设置到ini文件
      }
      
      ToolTip 发送%WinID%窗口到左边屏幕
      WinRestore, ahk_id %WinID%
      WinMove, ahk_id %WinID%, ,YDL ,YDY ,SW ,SH ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
      SetTimer, 关闭提示, -500 ;500毫秒后关闭提示
      MButton_presses:=0 ;键击记录重置为0
      Critical, Off
      return
    }
    else if (MXNew<FJR) ;右边屏幕 到 中间屏幕
    {
      if (WinID=MiniWinIDR)
      {
        MiniWinIDM:=WinID
        IniWrite, %MiniWinIDM%, Settings.ini, 设置, 中间屏幕最近一次被最小化的窗口 ;写入设置到ini文件
        MiniWinIDR:=0
        IniWrite, %MiniWinIDR%, Settings.ini, 设置, 右边屏幕最近一次被最小化的窗口 ;写入设置到ini文件
      }
      else if (WinID=MasterWinIDR)
      {
        MasterWinIDM:=WinID
        IniWrite, %MasterWinIDM%, Settings.ini, 设置, 中间屏幕主窗口 ;写入设置到ini文件
        MasterWinIDR:=0
        IniWrite, %MasterWinIDR%, Settings.ini, 设置, 右边屏幕主窗口 ;写入设置到ini文件
      }
      
      ToolTip 发送%WinID%窗口到中间屏幕
      WinRestore, ahk_id %WinID%
      WinMove, ahk_id %WinID%, ,YDM ,YDY ,SW ,SH ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
      SetTimer, 关闭提示, -500 ;500毫秒后关闭提示
      MButton_presses:=0 ;键击记录重置为0
      Critical, Off
      return
    }
  }
  
  CoordMode Mouse, Window ;以窗口为基准
  MouseGetPos, , WY, WinID ;获取鼠标在窗口中的位置
  WinGetClass, WinName, ahk_id %WinID% ;获取窗口类名
  DllCall("QueryPerformanceCounter", "Int64*", TapAfter)
  按下时间:=(TapAfter-TapBefore)/freq*1000, 2 ;长按时间检测
  if (按下时间>500) ;长按时间大于500ms将当前窗口填满所有屏幕
  {
    if (MButtonHotkey=0)
    {
      Return
    }
    else if (WY<WinTop) ;点击位置在窗口顶部
    {
      WinGetPos, , , WinW, WinH, ahk_id %WinID%
      if (WinW<A_ScreenWidth) or (WinH<A_ScreenHeight)
      {
        WinRestore, ahk_id %WinID%
        WinMove, ahk_id %WinID%, ,0-KDXZ/2 ,0 ,A_ScreenWidth+KDXZ ,A_ScreenHeight+GDXZ ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
        ToolTip 将%WinID%窗口填满所有屏幕
        SetTimer, 关闭提示, -500 ;500毫秒后关闭提示
      }
    }
    MButton_presses:=0 ;键击记录重置为0
    Critical, Off
    return
  }
  else
  {
    if (WY<WinTop) ;点击位置在窗口顶部
    {
      Send {MButton}
    }
    SetTimer, KeyMButton, -300 ; 启动在 300 毫秒内等待更多键击的计时器
  }
  Critical, Off
  return
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
  
  if (屏幕实时位置=1) and (MiniWinIDL!=0) ;鼠标在左边屏幕 有左边最小化窗口的历史记录
  {
    If (WinActive("ahk_id" MasterWinIDL)=0) and (MasterWinIDL!=0) ;主窗口
    {
      if (WinExist("ahk_id" MasterWinIDL)!=0)
      {
        WinGet, 窗口状态, MinMax, ahk_id %MasterWinIDL%
        if (窗口状态=-1)
        {
          WinRestore, ahk_id %MasterWinIDL% ;还原主窗口
        }
        else
        {
          WinActivate, ahk_id %MasterWinIDL%
        }
        ToolTip 还原左边屏幕%MasterWinIDL%主窗口
      }
      else
      {
        MasterWinIDL:=0
        IniWrite, %MasterWinIDL%, Settings.ini, 设置, 左边屏幕主窗口 ;写入设置到ini文件
      }
    }
    else If (WinActive("ahk_id" MiniWinIDL)=0) and (MasterWinIDL!=0) ;被最小化的窗口
    {
      if (WinExist("ahk_id" MiniWinIDL)!=0)
      {
        WinGet, 窗口状态, MinMax, ahk_id %MiniWinIDL%
        if (窗口状态=-1)
        {
          WinRestore, ahk_id %MiniWinIDL% ;还原主窗口
        }
        else
        {
          WinActivate, ahk_id %MiniWinIDL%
        }
        ToolTip 还原最近最小化%MiniWinIDL%窗口
      }
      else
      {
        MiniWinIDL:=0
        IniWrite, %MiniWinIDL%, Settings.ini, 设置, 左边屏幕最近一次被最小化的窗口 ;写入设置到ini文件
      }
    }
  }
  else if (屏幕实时位置=2) and (MiniWinIDM!=0) ;鼠标在中间屏幕 有中间最小化窗口的历史记录
  {
    If (WinActive("ahk_id" MasterWinIDM)=0) and (MasterWinIDM!=0) ;主窗口
    {
      if (WinExist("ahk_id" MasterWinIDM)!=0)
      {
        WinGet, 窗口状态, MinMax, ahk_id %MasterWinIDM%
        if (窗口状态=-1)
        {
          WinRestore, ahk_id %MasterWinIDM% ;还原主窗口
        }
        else
        {
          WinActivate, ahk_id %MasterWinIDM%
        }
        ToolTip 还原中间屏幕%MasterWinIDM%主窗口
      }
      else
      {
        MasterWinIDM:=0
        IniWrite, %MasterWinIDM%, Settings.ini, 设置, 中间屏幕主窗口 ;写入设置到ini文件
      }
    }
    else If (WinActive("ahk_id" MiniWinIDM)=0) and (MiniWinIDM!=0) ;被最小化的窗口
    {
      if (WinExist("ahk_id" MiniWinIDM)!=0)
      {
        WinGet, 窗口状态, MinMax, ahk_id %MiniWinIDM%
        if (窗口状态=-1)
        {
          WinRestore, ahk_id %MiniWinIDM% ;还原主窗口
        }
        else
        {
          WinActivate, ahk_id %MiniWinIDM%
        }
        ToolTip 还原最近最小化%MiniWinIDM%窗口
      }
      else
      {
        MiniWinIDL:=0
        IniWrite, %MiniWinIDM%, Settings.ini, 设置, 中间屏幕最近一次被最小化的窗口 ;写入设置到ini文件
      }
    }
  }
  else if (屏幕实时位置=3) and (MiniWinIDR!=0) ;鼠标在右边屏幕 有右边最小化窗口的历史记录 
  {
    If (WinActive("ahk_id" MasterWinIDR)=0) and (MasterWinIDR!=0) ;主窗口
    {
      if (WinExist("ahk_id" MasterWinIDR)!=0)
      {
        WinGet, 窗口状态, MinMax, ahk_id %MasterWinIDR%
        if (窗口状态=-1)
        {
          WinRestore, ahk_id %MasterWinIDR% ;还原主窗口
        }
        else
        {
          WinActivate, ahk_id %MasterWinIDR%
        }
        ToolTip 还原右边屏幕%MasterWinIDR%主窗口
      }
      else
      {
        MasterWinIDM:=0
        IniWrite, %MasterWinIDR%, Settings.ini, 设置, 右边屏幕主窗口 ;写入设置到ini文件
      }
    }
    else If (WinActive("ahk_id" MiniWinIDR)=0) and (MiniWinIDR!=0) ;被最小化的窗口
    {
      if (WinExist("ahk_id" MiniWinIDR)!=0)
      {
        WinGet, 窗口状态, MinMax, ahk_id %MiniWinIDR%
        if (窗口状态=-1)
        {
          WinRestore, ahk_id %MiniWinIDR% ;还原主窗口
        }
        else
        {
          WinActivate, ahk_id %MiniWinIDR%
        }
        ToolTip 还原最近最小化%MiniWinIDR%窗口
      }
      else
      {
        MiniWinIDL:=0
        IniWrite, %MiniWinIDR%, Settings.ini, 设置, 右边屏幕最近一次被最小化的窗口 ;写入设置到ini文件
      }
    }
  }
  
  SetTimer, 关闭提示, -300 ;300毫秒后关闭提示
}
else if (MButton_presses>=2) and (MYOld>WinTop) ;此键按下了两次及以上
{
  gosub 暂停运行
}
MButton_presses:=0 ;键击记录重置为0 下次键击重新开始记录是否双击
return

~^c:: ;Ctrl+C
Critical, On
MouseGetPos, , WY, WinID ;获取鼠标在窗口中的位置
WinGetClass, WinName, ahk_id %WinID% ;获取窗口类名
if (WY<WinTop) ;点击位置在窗口顶部
{
  BlackList:=" or (WinName=双引号窗口类名双引号)" ;黑名单格式
  StringReplace, BlackList, BlackList, 双引号,`" ,A ;“ 双引号 ”替换为“ " ”
  StringReplace, BlackList, BlackList, 窗口类名,%WinName% ,A ;填入刚刚获取的窗口类名
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

~#Space::
KeyWait, Space
WinGet, win_id, , A
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
SetTimer, 关闭提示, -800 ;800毫秒后关闭提示
Return

关闭提示:
ToolTip
return

基础功能:
MsgBox, ,基础功能 ,在窗口顶部`n      拨动滚轮最大或最小化当前窗口`n      长按中键窗口填满所有屏幕`n在最大化窗口顶部`n      鼠标左键点住快速往下拖关闭窗口`n      拖离屏幕顶部缩小窗口至屏幕36`%大小`n在窗口任意位置`n      按住中键并拖动窗口到其他屏幕`n      可以发送窗口到中键抬起时所处的屏幕`n在屏幕底部`n      滚轮最大或最小化全部窗口`n设置主窗口`n      在窗口顶部按下Shif`+左键设置主窗口`n呼出窗口`n      按中键可以呼出主窗口或最近一次最小化的窗口`n      优先呼出设置的主窗口`n`n双击中键`n      暂停运行`n      再次双击恢复运行`n`n黑钨重工出品 免费开源 请勿商用 侵权必究`n更多免费教程尽在QQ群`n1群763625227 2群643763519
return

进阶功能:
MsgBox, ,进阶功能 ,在非最大化窗口顶部`n      鼠标左键按住左右摇晃让窗口总是顶置`n      再次摇晃可以取消窗口顶置`n在总是顶置的窗口`n      Ctrl`+左键在窗口内上下滑动调整透明度`n      Tab开关鼠标穿透顶置窗口的功能`n      仅可调整被总是顶置的窗口的透明度`n`n按住中键的时候`n      左右晃动鼠标打开放大镜`n      放大镜激活期间按下Shift或者Ctrl改变缩放倍率`n      放大后如果太模糊打开锐化算法`n      抬起中键后关闭放大镜`n`n常用窗口`n      Ctrl`+鼠标左键单击窗口顶部设置常用窗口`n      当鼠标贴着屏幕顶部一段时间后激活`n自动暂停黑名单`n      Alt`+鼠标左键单击窗口顶部设置自动暂停黑名单`n      双击Alt清除黑名单设置`n`n黑名单添加`:`n      在窗口顶部按下ctrl+C即可复制窗口类名`n      需要手动添加类名到黑名单`n      改代码后需要重启脚本才能应用设置`n`n如果和某些软件冲突`n      导致无法最大化和还原所有窗口`n      请打开兼容模式运行本软件`n`n黑钨重工出品 免费开源 请勿商用 侵权必究`n更多免费教程尽在QQ群`n1群763625227 2群643763519
return

暂停运行: ;模式切换
Critical, On
if (running=0)
{
  Menu, Tray, Icon, %A_ScriptDir%\Running.ico ;任务栏图标改成正在运行
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
  Hotkey ^LButton, On ;打开Ctrl+左键的热键
  Hotkey ^c, On ;打开Ctrl+C的热键
  SetTimer, 自动隐藏任务栏, Delete
  SetTimer, 屏幕监测, 100
  Menu, Tray, UnCheck, 暂停运行 ;右键菜单不打勾
  
  if (Alt自动暂停=1)
  {
    ToolTip 自动恢复运行
  }
  else
  {
    ToolTip 分屏助手恢复运行
    Hotkey Alt, On ;打开Alt键的热键
  }
}
else
{
  Menu, Tray, Icon, %A_ScriptDir%\Stopped.ico ;任务栏图标改成暂停运行
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
  Hotkey ^LButton, Off ;关闭Ctrl+左键的热键
  Hotkey ^c, Off ;关闭Ctrl+C的热键
  if (Alt自动暂停=1)
  {
    WinGet TaskbarID, ID, ahk_class Shell_TrayWnd ;获取任务栏句柄
    DllCall("ShowWindow", "Ptr", TaskbarID, "Int", 0) ; 隐藏任务栏
    TaskBar:=0
  }
  else
  {
    SetTimer, 屏幕监测, Delete
    SetTimer, 自动隐藏任务栏, 100
  }
  WinHide, ahk_id %MagnifierWindowID%
  Menu, Tray, Check, 暂停运行 ;右键菜单打勾
  
  if (Alt自动暂停=1)
  {
    ToolTip 自动暂停运行
  }
  else
  {
    ToolTip 分屏助手暂停运行
    Hotkey Alt, Off ;关闭Alt键的热键
  }
}
SetTimer, 关闭提示, -500 ;500毫秒后关闭提示
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

管理权限: ;模式切换
Critical, On
if (AdminMode=1)
{
  AdminMode:=0
  IniWrite, %AdminMode%, Settings.ini, 设置, 管理权限 ;写入设置到ini文件
  Menu, Tray, UnCheck, 管理权限 ;右键菜单不打勾
  Critical, Off
  Reload
}
else
{
  AdminMode:=1
  IniWrite, %AdminMode%, Settings.ini, 设置, 管理权限 ;写入设置到ini文件
  Menu, Tray, Check, 管理权限 ;右键菜单打勾
  Critical, Off
  Reload
}
return

兼容模式: ;模式切换
Critical, On
if (CompatibleMode=1)
{
  CompatibleMode:=0
  IniWrite, %CompatibleMode%, Settings.ini, 设置, 兼容模式 ;写入设置到ini文件
  Menu, Tray, UnCheck, 兼容模式 ;右键菜单不打勾
}
else
{
  CompatibleMode:=1
  IniWrite, %CompatibleMode%, Settings.ini, 设置, 兼容模式 ;写入设置到ini文件
  Menu, Tray, Check, 兼容模式 ;右键菜单打勾
}
Critical, Off
return

开机自启: ;模式切换
Critical, On
if (autostart=1) ;关闭开机自启动
{
  IfExist, % autostartLnk ;如果开机启动的文件存在
  {
    FileDelete, %autostartLnk% ;删除开机启动的文件
  }
  
  autostart:=0
  Menu, Tray, UnCheck, 开机自启 ;右键菜单不打勾
}
else ;开启开机自启动
{
  IfExist, % autostartLnk ;如果开机启动的文件存在
  {
    FileGetShortcut, %autostartLnk%, lnkTarget ;获取开机启动文件的信息
    if (lnkTarget!=A_ScriptFullPath) ;如果启动文件执行的路径和当前脚本的完整路径不一致
    {
      FileCreateShortcut, %A_ScriptFullPath%, %autostartLnk%, %A_WorkingDir% ;将启动文件执行的路径改成和当前脚本的完整路径一致
    }
  }
  else ;如果开机启动的文件不存在
  {
    FileCreateShortcut, %A_ScriptFullPath%, %autostartLnk%, %A_WorkingDir% ;创建和当前脚本的完整路径一致的启动文件
  }
  
  autostart:=1
  Menu, Tray, Check, 开机自启 ;右键菜单打勾
}
Critical, Off
return

重启脚本:
Reload

~!LButton:: ;Alt+左键
Critical, On
CoordMode Mouse, Window ;以窗口为基准
MouseGetPos, , WindowY, WinID_Monitor ;;获取鼠标在窗口中的位置
WinGet, 窗口样式, ExStyle, ahk_id %WinID_Monitor% ;获取窗口样式
窗口样式:= (窗口样式 & 0x8) ? true : false ;验证窗口是否处于总是顶置状态
; ToolTip %窗口样式%
if (窗口样式=0) and (WindowY<WinTop) ;如果没有处于总是顶置状态 并且 点击在窗口顶部
{
  WinGetClass, BlackListWindow, ahk_id %WinID_Monitor% ;根据句柄获取窗口的名字
  IniWrite, %BlackListWindow%, Settings.ini, 设置, 自动暂停黑名单 ;写入设置到ini文件
  ToolTip 窗口%BlackListWindow%已加入黑名单
  KeyWait LButton
  ToolTip
  Critical, Off
  Return
}
Return

~Alt::
KeyWait Alt
if (Alt_presses > 0)
{
  Alt_presses += 1
  return
}
else
{
  Alt_presses := 1
  KeyWait, Alt
  SetTimer, KeyAlt, -300
}
return

KeyAlt:
if (Alt_presses >= 2) and (BlackListWindow!="") ;清除黑名单并恢复运行
{
  ToolTip 已清除黑名单设置
  Sleep 500
  BlackListWindow:=""
  IniWrite, %BlackListWindow%, Settings.ini, 设置, 自动暂停黑名单 ;写入设置到ini文件
  running:=0
  gosub 暂停运行
  Alt自动暂停:=0
  SetTimer, 关闭提示, -500
}
Alt_presses := 0
return

媒体快捷:
旧上组合键:=上组合键
旧下组合键:=下组合键
Gui 快捷键:+DPIScale -MinimizeBox -MaximizeBox -Resize -SysMenu
Gui 快捷键:Font, s9, Segoe UI
Gui 快捷键:Add, Hotkey, x58 y313 w120 h25 v上组合键, %上组合键%
Gui 快捷键:Add, Hotkey, x58 y375 w120 h25 v下组合键, %下组合键%
Gui 快捷键:Add, Text, x14 y13 w197 h281 +Left, 在屏幕底部`n      按住中键左右移动调整音量`n      单击中键可以播放/暂停媒体`n`n双击箭头`n      左箭头 上一曲   右箭头 下一曲`n同时按下两个箭头`n      左右箭头 暂停播放`n      上下箭头 呼出关`/闭播放器`n      上下箭头长按 清除呼出设置`n`n快捷键设置`n      下方功能输入组合键自定义`n      会在双击快捷键后输出组合键`n`n      长按左右箭头关闭媒体快捷键`n      在屏幕底部点击中键重新打开
Gui 快捷键:Add, Button, x15 y424 w69 h25 GButton重置, &重置
Gui 快捷键:Add, Button, x83 y424 w69 h25 GButton确认, &确认
Gui 快捷键:Add, Button, x151 y424 w69 h25 GButton取消, &取消
Gui 快捷键:Add, Text, x58 y288 w120 h25 +0x200, 喜欢歌曲
Gui 快捷键:Add, Text, x58 y350 w120 h25 +0x200, 歌曲歌词
Gui 快捷键:Show, w234 h466, 媒体快捷键设置
Return

Button重置:
Gui, 快捷键:Destroy
上组合键:=""
下组合键:=""
IniWrite, %上组合键%, Settings.ini, 设置, 双击箭头上输出组合键 ;写入设置到ini文件
IniWrite, %下组合键%, Settings.ini, 设置, 双击箭头下输出组合键 ;写入设置到ini文件
return

Button确认:
Gui, 快捷键:Submit, NoHide
Gui, 快捷键:Destroy
IniWrite, %上组合键%, Settings.ini, 设置, 双击箭头上输出组合键 ;写入设置到ini文件
IniWrite, %下组合键%, Settings.ini, 设置, 双击箭头下输出组合键 ;写入设置到ini文件
return

Button取消:
上组合键:=旧上组合键
下组合键:=旧下组合键
Gui, 快捷键:Destroy
return

~Left::
~Right::
~Up::
~Down::
if (暂停=1)
{
  Return
}
暂停:=1
Loop
{
  if GetKeyState("Left", "P") and GetKeyState("Right", "P")
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
        Hotkey, ~Left, Off
        Hotkey, ~Right, Off
        Hotkey, ~Up, Off
        Hotkey, ~Down, Off
        Loop 20
        {
          ToolTip 媒体快捷键已关闭
          Sleep 30
        }
        ToolTip
        暂停:=0
        Return
      }
      else if !GetKeyState("Left", "P") and !GetKeyState("Right", "P")
      {
        ; ToolTip %媒体快捷键% %媒体快捷键按下时长%
        Send {Media_Play_Pause}
        暂停:=0
        Return
      }
      Sleep 10
    }
  }
  else if GetKeyState("Up", "P") and GetKeyState("Down", "P")
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
        if (清除播放器快捷呼出设置记录时间>2000)
        {
          ToolTip %清除播放器快捷呼出设置记录时间%已清除播放器快捷呼出设置 
          MediaWindow:=""
          IniWrite, %MediaWindow%, Settings.ini, 设置, 呼出播放器 ;写入设置到ini文件
          暂停:=0
          Return
        }
        else
        {
          MouseGetPos, , , WinID ;获取鼠标所在窗口的句柄
          WinGetClass, WindowID, ahk_id %WinID% ;根据句柄获取窗口的名字
          if (MediaWindow="")
          {
            MouseGetPos, , , WinID_Media ;获取鼠标所在窗口的句柄
            WinGetClass, MediaWindow, ahk_id %WinID_Media% ;根据句柄获取窗口的名字
            IniWrite, %MediaWindow%, Settings.ini, 设置, 呼出播放器 ;写入设置到ini文件
            ToolTip 已设置%MediaWindow%为播放器快捷呼出
            SetTimer, 关闭提示, -500
          }
          else if (WindowID!=MediaWindow)
          {
            WinActivate, ahk_class %MediaWindow%
            WinShow, ahk_class %MediaWindow%
            ToolTip 快捷呼出%MediaWindow%播放器
            SetTimer, 关闭提示, -500
          }
          else
          {
            WinMinimize, ahk_class %MediaWindow%
            ToolTip 快捷关闭%MediaWindow%播放器
            SetTimer, 关闭提示, -500
          }
          暂停:=0
          Return
        }
      }
      Sleep 10
    }
  }
  
  if !GetKeyState("Left", "P") and !GetKeyState("Right", "P") and !GetKeyState("Up", "P") and !GetKeyState("Down", "P")
  {
    break
  }
  Sleep 10
}
if (Media_presses > 0) ;后续的按下
{
  Media_presses_New:=StrReplace(A_ThisHotkey,"~")
  if (Media_presses_New=Media_presses_History)
  {
    Media_presses += 1 ;2
  }
  else if (Media_presses_New!=Media_presses_History)
  {
    Media_presses := 0
    SetTimer, KeyMedia, Delete
  }
  暂停:=0
  return
}
else ;第一次按下
{
  Media_presses_History:=StrReplace(A_ThisHotkey,"~")
  Media_presses := 1
  SetTimer, KeyMedia, -400
  暂停:=0
  return
}
暂停:=0
return

KeyMedia:
if (Media_presses >= 2) ;双击
{
  if (A_PriorKey="Left")
  {
    ToolTip 上一曲
    Send {Media_Next}
  }
  else if (A_PriorKey="Right")
  {
    ToolTip 下一曲
    Send {Media_Next}
  }
  else if (A_PriorKey="Up")
  {
    ToolTip 喜欢歌曲
    Send %上组合键%
  }
  else if (A_PriorKey="Down")
  {
    ToolTip 歌曲歌词
    Send %下组合键%
  }
  SetTimer, 关闭提示, -500
}
Media_presses := 0
return

屏幕监测:
CoordMode Mouse, Screen ;以屏幕为基准
MouseGetPos, MISX, MISY ;获取鼠标在屏幕中的位置
WinGetClass, WinName, A ;ahk_id 获取窗口类名
; ToolTip %WinName%
if (WinName!="") and (WinName=BlackListWindow) and (running=1) ;自动暂停黑名单
{
  Alt自动暂停:=1
  gosub 暂停运行
  Sleep 300
  ToolTip
  Return
}
else if (WinName!="") and (WinName!=BlackListWindow) and (Alt自动暂停=1) and (running=0) ;恢复运行
{
  gosub 暂停运行
  Alt自动暂停:=0
  Return
}
else if (Alt自动暂停=1)
{
  Return
}

if (MISY<3) ;如果鼠标贴着屏幕顶部
{
  Critical, On
  Loop
  {
    ; ToolTip %A_Index%
    Sleep 60
    MouseGetPos, , MISY
    if (MISY<=3) and (A_Index=10)
    {
      WinActivate, %ActiveWindowID% ;激活后台等待激活的窗口
      WinShow, %ActiveWindowID% ;激活后台等待激活的窗口
    }
    else if (MISY>3)
    {
      ; ToolTip
      break
    }
  }
  Critical, Off
}
else if (MISY>=A_ScreenHeight-3) ;如果鼠标贴着屏幕底部
{
  WinShow, ahk_class Shell_TrayWnd ;显示任务栏
  TaskBar:=1
  任务栏计时器:=0
}
else if (MISY<A_ScreenHeight-3) and (MISY>ScreenBottom) ;如果鼠标回到任务栏重新开始计时
{
  任务栏计时器:=0
}
else if (TaskBar=1) and (MISY<ScreenBottom) and (任务栏计时器=0) ;如果鼠标离开任务栏 且任务栏处于激活状态 但是没有离开预览窗口范围 记录时间
{
  DllCall("QueryPerformanceFrequency", "Int64*", freq)
  DllCall("QueryPerformanceCounter", "Int64*", KeyDown_离开任务栏)
  任务栏计时器:=1
}
else if (TaskBar=1) and (MISY<ScreenBottom) and (MISY>ScreenBottomMax) ;如果鼠标处于预览窗口范围 且任务栏处于激活状态 等待3秒才隐藏任务栏
{
  DllCall("QueryPerformanceCounter", "Int64*", KeyUp_离开任务栏)
  记录时间:=Round((KeyUp_离开任务栏-KeyDown_离开任务栏)/freq*1000, 2)
  ; ToolTip 记录时间%记录时间%ms %WinName% %MISY% %MISX%
  if (记录时间>800)
  {
    WinGet TaskbarID, ID, ahk_class Shell_TrayWnd ;获取任务栏句柄
    DllCall("ShowWindow", "Ptr", TaskbarID, "Int", 0) ; 隐藏任务栏
    TaskBar:=0
  }
}
else if (TaskBar=1) and (MISY<ScreenBottomMax) ;如果鼠标离开预览窗口范围 且任务栏处于激活状态 隐藏任务栏
{
  WinGet TaskbarID, ID, ahk_class Shell_TrayWnd ;获取任务栏句柄
  DllCall("ShowWindow", "Ptr", TaskbarID, "Int", 0) ; 隐藏任务栏
  TaskBar:=0
}
else if (TaskBar=0) ;如果任务栏处于隐藏状态
{
  TaskbarID:=""
  WinGet TaskbarID, ID, ahk_class Shell_TrayWnd ;获取任务栏句柄
  if (TaskbarID!="") ;弹出的窗口唤醒任务栏后延迟3秒后再隐藏任务栏
  {
    Loop
    {
      CoordMode Mouse, Screen ;以屏幕为基准
      MouseGetPos, , MISY ;获取鼠标在屏幕中的位置
      if (MISY>A_ScreenHeight-3)
      {
        break
      }
      else if (A_Index>=100)
      {
        WinGet TaskbarID, ID, ahk_class Shell_TrayWnd ;获取任务栏句柄
        DllCall("ShowWindow", "Ptr", TaskbarID, "Int", 0) ; 隐藏任务栏
        TaskBar:=0
        break
      }
      Sleep 30
    }
  }
}

if (MISX<FJL)
{
  屏幕实时位置:=1
  ; ToolTip 屏幕实时位置%屏幕实时位置% w%rWidth% h%rHeight%
  if (HSJ=0)
  {
    IfWinNotActive ahk_id %MagnifierWindowID%
    {
      SetTimer, 后视镜, -1
    }
    HSJ:=1
  }
  else if (HSJM=0)
  {
    IfWinNotActive ahk_id %MagnifierWindowID%
    {
      ; ToolTip 打开后视镜
      WinShow, ahk_id %MagnifierWindowID%
      WinMove, ahk_id %MagnifierWindowID%, , HSJLX, HSJY
      HSJM:=1
    }
  }
}
else if (MISX>FJR)
{
  屏幕实时位置:=3
  ; ToolTip 屏幕实时位置%屏幕实时位置% w%rWidth% h%rHeight%
  if (HSJ=0)
  {
    IfWinNotActive ahk_id %MagnifierWindowID%
    {
      SetTimer, 后视镜, -1
    }
    HSJ:=1
  }
  else if (HSJM=0)
  {
    IfWinNotActive ahk_id %MagnifierWindowID%
    {
      ; ToolTip 打开后视镜
      WinShow, ahk_id %MagnifierWindowID%
      WinMove, ahk_id %MagnifierWindowID%, , HSJRX, HSJY
      HSJM:=1
    }
  }
}
else
{
  屏幕实时位置:=2
  ; ToolTip 屏幕实时位置%屏幕实时位置% w%rWidth% h%rHeight%
  if (HSJ=1)
  {
    ; ToolTip 关闭后视镜
    WinHide, ahk_id %MagnifierWindowID%
    HSJM:=0
  }
}
return

自动隐藏任务栏:
CoordMode Mouse, Screen ;以屏幕为基准
MouseGetPos, MISX, MISY ;获取鼠标在屏幕中的位置
if (MISY>=A_ScreenHeight-3) ;如果鼠标贴着屏幕底部
{
  WinShow, ahk_class Shell_TrayWnd ;显示任务栏
  TaskBar:=1
  任务栏计时器:=0
}
else if (MISY<A_ScreenHeight-3) and (MISY>ScreenBottom) ;如果鼠标回到任务栏重新开始计时
{
  任务栏计时器:=0
}
else if (TaskBar=1) and (MISY<ScreenBottom) and (任务栏计时器=0) ;如果鼠标离开任务栏 且任务栏处于激活状态 但是没有离开预览窗口范围 记录时间
{
  DllCall("QueryPerformanceFrequency", "Int64*", freq)
  DllCall("QueryPerformanceCounter", "Int64*", KeyDown_离开任务栏)
  任务栏计时器:=1
}
else if (TaskBar=1) and (MISY<ScreenBottom) and (MISY>ScreenBottomMax) ;如果鼠标处于预览窗口范围 且任务栏处于激活状态 等待3秒才隐藏任务栏
{
  DllCall("QueryPerformanceCounter", "Int64*", KeyUp_离开任务栏)
  记录时间:=Round((KeyUp_离开任务栏-KeyDown_离开任务栏)/freq*1000, 2)
  ; ToolTip 记录时间%记录时间%ms %WinName% %MISY% %MISX%
  if (记录时间>800)
  {
    WinGet TaskbarID, ID, ahk_class Shell_TrayWnd ;获取任务栏句柄
    DllCall("ShowWindow", "Ptr", TaskbarID, "Int", 0) ; 隐藏任务栏
    TaskBar:=0
  }
}
else if (TaskBar=1) and (MISY<ScreenBottomMax) ;如果鼠标离开预览窗口范围 且任务栏处于激活状态 隐藏任务栏
{
  WinGet TaskbarID, ID, ahk_class Shell_TrayWnd ;获取任务栏句柄
  DllCall("ShowWindow", "Ptr", TaskbarID, "Int", 0) ; 隐藏任务栏
  TaskBar:=0
}
else if (TaskBar=0) ;如果任务栏处于隐藏状态
{
  TaskbarID:=""
  WinGet TaskbarID, ID, ahk_class Shell_TrayWnd ;获取任务栏句柄
  if (TaskbarID!="") ;弹出的窗口唤醒任务栏后延迟3秒后再隐藏任务栏
  {
    Loop
    {
      CoordMode Mouse, Screen ;以屏幕为基准
      MouseGetPos, , MISY ;获取鼠标在屏幕中的位置
      if (MISY>A_ScreenHeight-3)
      {
        break
      }
      else if (A_Index>=100)
      {
        WinGet TaskbarID, ID, ahk_class Shell_TrayWnd ;获取任务栏句柄
        DllCall("ShowWindow", "Ptr", TaskbarID, "Int", 0) ; 隐藏任务栏
        TaskBar:=0
        break
      }
      Sleep 30
    }
  }
}
return

后视镜:
; ToolTip 打开后视镜
; Return
; /*
Ptr := A_PtrSize ? "UPtr" : "UInt"
if !DllCall("GetModuleHandle", "str", "gdiplus", Ptr)
	DllCall("LoadLibrary", "str", "gdiplus")
VarSetCapacity(GdiplusStartupInput, A_PtrSize = 8 ? 24 : 16, 0), GdiplusStartupInput := Chr(1)
DllCall("gdiplus\GdiplusStartup", A_PtrSize = 8 ? "UPtr*" : "UInt*", pToken, Ptr, &GdiplusStartupInput, Ptr, 0)

Gui, 后视镜:New
Gui, 后视镜:-Caption +AlwaysOnTop +E0x02000000 +E0x00080000  ;  WS_EX_COMPOSITED := E0x02000000  WS_EX_LAYERED := E0x00080000
Gui, 后视镜:Margin, 0,0  
Gui, 后视镜:Add, text, w%rWidth% h%rHeight% 0xE hwndhPic ; SS_BITMAP = 0xE
if (屏幕实时位置=1)
{
  Gui, 后视镜:Show, x%HSJLX% y%HSJY% NA, MagnifierCloneWindowAHK
}
else if (屏幕实时位置=3)
{
  Gui, 后视镜:Show, x%HSJRX% y%HSJY% NA, MagnifierCloneWindowAHK
}
WinGet MagnifierWindowID, ID, MagnifierCloneWindowAHK

Gui, MagnifierWindow:New
Gui, MagnifierWindow: +AlwaysOnTop -Caption +ToolWindow +HWNDhMagnifier
Gui, MagnifierWindow: Show, w%rWidth% h%rHeight% NA Hide, MagnifierWindowAHK
	
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
	, "Int", rWidth
	, "Int", rHeight
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

Loop
{
  CoordMode Mouse, Screen ;以屏幕为基准
	MouseGetPos, MXS, MYS
	NumPut(MXS - rWidth/2, RECT, 0, "Int")
	NumPut(MYS - rHeight/2, RECT, 4, "Int")
	NumPut(rWidth, RECT, 8, "Int")
	NumPut(rHeight, RECT, 12, "Int")
	DllCall("magnification.dll\MagSetWindowSource", Ptr, hChildMagnifier, Ptr, &RECT)
}
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
	
	SendMessage, STM_SETIMAGE, IMAGE_BITMAP, hBitmap,, ahk_id %hPic% 
	
	DllCall("DeleteObject", Ptr, ErrorLevel)
	DllCall("gdiplus\GdipDisposeImage", Ptr, pBitmap)
	DllCall("DeleteDC", Ptr, hDC)
	DllCall("DeleteObject", Ptr, hBMP)
	DllCall("DeleteObject", Ptr, hBitmap)
	Return 1
}
; */

放大镜:
Gui, 放大镜:New
Gui 放大镜:+AlwaysOnTop +Resize +ToolWindow +DPIScale -Caption -Resize
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
  IniWrite, %antialize%, Settings.ini, 设置, 锐化算法 ;写入设置到ini文件
  Menu, Tray, UnCheck, 锐化算法 ;右键菜单不打勾
}
else
{
  antialize:=0
  DllCall("gdi32.dll\SetStretchBltMode", "uint", hdc_frame, "int", 4*antialize )
  IniWrite, %antialize%, Settings.ini, 设置, 锐化算法 ;写入设置到ini文件
  Menu, Tray, Check, 锐化算法 ;右键菜单打勾
}
return

关闭放大镜:
Critical, On
SetTimer, Repaint, Off
DllCall("gdi32.dll\DeleteDC", UInt,hdc_frame )
DllCall("gdi32.dll\DeleteDC", UInt,hdd_frame )
Gui, 放大镜:Destroy
if (x<FJL) or (x>FJR) ;如果在两侧屏幕
{
  WinShow, ahk_id %MagnifierWindowID% ;打开后视镜
}
SetTimer, 屏幕监测, 100
Critical, Off
Return

打开放大镜:
SetTimer, 屏幕监测, Off
WinHide, ahk_id %MagnifierWindowID% ;关闭后视镜
gosub 放大镜
SetTimer, Repaint, 30
Return

In(x,a,b) 
{
  IfLess x,%a%, Return a
  IfLess b,%x%, Return b
  Return x
}

退出软件:
Critical, On
if (OldLastWinTop!="")
{
  TopWindowTransparent:=0
  WinSet, ExStyle, -0x20, ahk_id %OldLastWinTop% ;关闭鼠标穿透
  TopOpacity:=255
  WinSet, Transparent, %TopOpacity%, ahk_id %OldLastWinTop%
  WinSet, AlwaysOnTop, Off, ahk_id %OldLastWinTop%  ;切换窗口的顶置状态
  OldLastWinTop:=""
  IniWrite, %OldLastWinTop%, Settings.ini, 设置, 上次被总是顶置的窗口 ;写入设置到ini文件
}
if (OldLastWinTop!="")
{
  TopWindowTransparent:=0
  WinSet, ExStyle, -0x20, ahk_id %LastWinTop% ;关闭鼠标穿透
  ToolTip 窗口%LastWinTop%取消总是顶置 -
  WinSet, AlwaysOnTop, Off, ahk_id %LastWinTop%  ;切换窗口的顶置状态
  TopOpacity:=255
  WinSet, Transparent, %TopOpacity%, ahk_id %LastWinTop%
  LastWinTop:=""
  IniWrite, %LastWinTop%, Settings.ini, 设置, 被总是顶置的窗口 ;写入设置到ini文件
}
DllCall("gdi32.dll\DeleteDC", UInt,hdc_frame )
DllCall("gdi32.dll\DeleteDC", UInt,hdd_frame )
DllCall("magnification.dll\MagUninitialize")
DllCall("gdiplus\GdiplusShutdown", Ptr, pToken)
if hModule := DllCall("GetModuleHandle", "Str", "gdiplus", Ptr)
{
  DllCall("FreeLibrary", Ptr, hModule)
}
Gui, 后视镜:Destroy
WinShow, ahk_class Shell_TrayWnd ;显示任务栏
Critical, Off
ExitApp

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