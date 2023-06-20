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
Menu, Tray, Icon, %A_ScriptDir%\Running.ico ;任务栏图标改成正在运行
Menu, Tray, NoStandard ;不显示默认的AHK右键菜单
Menu, Tray, Add, 使用教程, 使用教程 ;添加新的右键菜单
Menu, Tray, Add, 暂停运行, 暂停运行 ;添加新的右键菜单
Menu, Tray, Add, 锐化算法, 锐化算法 ;添加新的右键菜单
Menu, Tray, Add, 管理权限, 管理权限 ;添加新的右键菜单
Menu, Tray, Add, 兼容模式, 兼容模式 ;添加新的右键菜单
Menu, Tray, Add, 开机自启, 开机自启 ;添加新的右键菜单
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
  IniRead, antialize, Settings.ini, 设置, 锐化算法 ;从ini文件读取设置
  if (antialize=0)
  {
    Menu, Tray, UnCheck, 锐化算法 ;右键菜单不打勾
  }
  else
  {
    Menu, Tray, Check, 锐化算法 ;右键菜单打勾
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
  
  IniRead, MiniWinID, Settings.ini, 设置, 最近一次被最小化的窗口 ;从ini文件读取设置
}
else ;如果配置文件不存在则新建
{
  antialize:=0
  IniWrite, %antialize%, Settings.ini, 设置, 锐化算法 ;写入设置到ini文件
  CompatibleMode:=0
  IniWrite, %CompatibleMode%, Settings.ini, 设置, 兼容模式 ;写入设置到ini文件
  AdminMode:=0
  IniWrite, %AdminMode%, Settings.ini, 设置, 管理权限 ;写入设置到ini文件
  MiniWinID:=0
  IniWrite, %MiniWinID%, Settings.ini, 设置, 最近一次被最小化的窗口 ;写入设置到ini文件
}

KDXZ:=16 ;宽度修正 如果全屏后窗口仍然没有填满屏幕增加这个值 一般是8的倍数
GDXZ:=8 ;高度修正 如果全屏后窗口仍然没有填满屏幕增加这个值 一般是8的倍数

FJL:=Round(A_ScreenWidth/3) ;左分界线
FJR:=Round(A_ScreenWidth/3)*2 ;右分界线
WinTop:=Round(A_ScreenHeight*(25/1080)) ;窗口顶部识别分界线
SH:=A_ScreenHeight+GDXZ ;屏幕高度
if (A_ScreenHeight=1080) ;1080P屏宽度
{
  SW:=120*16+KDXZ ;第二个数字填屏幕长宽比的长比例 16：9就填16 21：9就填21
}
else if (A_ScreenHeight=1440) ;2K屏宽度
{
  SW:=160*16+KDXZ ;第二个数字填屏幕长宽比的长比例 16：9就填16 21：9就填21
}
else if (A_ScreenHeight=2160) ;4K屏宽度
{
  SW:=240*16+KDXZ ;第二个数字填屏幕长宽比的长比例 16：9就填16 21：9就填21
}
YDL:=Round(0-KDXZ/2) ;左边屏幕左上角原点X
YDY:=0 ;屏幕原点Y
YDM:=(A_ScreenWidth-SW*3)/2+SW ;中间屏幕左上角原点X
YDR:=Round((A_ScreenWidth-SW*3)+SW*2+KDXZ/2) ;右边屏幕左上角原点X
ScreenBottom:=A_ScreenHeight-Round(A_ScreenHeight*(50/1080)) ;屏幕底部识别分界线
; MsgBox %SW% %SH%

HSJ:=0 ;后视镜打开状态
HSJM:=0 ;后视镜移动状态
rWidth:=Round(SW*(600/1920)) ;后视镜宽度
rHeight:=Round(A_ScreenHeight*(400/1080)) ;后视镜高度
HSJLX:=YDM+Round(A_ScreenHeight*(50/1080)) ;左后视镜显示位置X
HSJRX:=YDR-rWidth-Round(A_ScreenHeight*(50/1080)) ;右后视镜显示位置X
HSJY:=A_ScreenHeight/2-rHeight/2 ;后视镜显示位置Y
HWNDarr:=[WinExist("ahk_class AHKEditor"), hGui]  ; 不需要显示后视镜窗口的黑名单 填WinTitle
SetTimer, 屏幕监测, 100 ;监测鼠标位置打开后视镜

FDJ:=0 ;放大镜打开状态
FDJM:=0 ;放大镜移动状态
zoom := 2 ;放大镜缩放倍率
Rx := Round(A_ScreenHeight*(100/1080))
Ry := Round(A_ScreenHeight*(100/1080))
Zx := Rx/zoom
Zy := Ry/zoom

~WheelUp:: ;触发按键 滚轮上
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
  if (WinName="WorkerW") or (WinName="_cls_desk_") or (WinName="Progman") or (WinName="ActualTools_MultiMonitorTaskbar") ;黑名单列表 双引号内填类名 ahk_class
  {
    Critical, Off
    return ;如果在黑名单列表的窗口内操作则不执行
  }
  WinGetPos, SX, SY, W, H, ahk_id %WinID% ;获取窗口以屏幕为基准的位置 窗口的宽和高
  WinInScreenX:=SX+W/2 ;窗口中间以屏幕为基准的位置
  WinRestore, ahk_id %WinID% ;如果窗口已经最大化则还原窗口
  ; MsgBox ID:%WinID%`nX:%X% Y:%Y%`nW:%W% H:%H%`n`n左分界线:%FJL%`n右分界线:=%FJR%`n鼠标位置 X:%SX% Y:%SY%
  if (WinInScreenX<FJL) and (WY<WinTop) ;点击的窗口在左边屏幕 并且 点击位置在窗口顶部
  {
    ToolTip 最大化%WinID%窗口
    WinMove, ahk_id %WinID%, ,YDL ,YDY ,SW ,SH ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
    SetTimer, 关闭提示, -500 ;500毫秒后关闭提示
  }
  else if (WinInScreenX>FJL) and (WinInScreenX<FJR) and (WY<WinTop) ;点击的窗口在中间屏幕 并且 点击位置在窗口顶部
  {
    ToolTip 最大化%WinID%窗口
    WinMove, ahk_id %WinID%, ,YDM ,YDY ,SW ,SH ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
    SetTimer, 关闭提示, -500 ;500毫秒后关闭提示
  }
  else if (WinInScreenX>FJR) and (WY<WinTop) ;点击的窗口在右边屏幕 并且 点击位置在窗口顶部
  {
    ToolTip 最大化%WinID%窗口
    WinMove, ahk_id %WinID%, ,YDR ,YDY ,SW ,SH ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
    SetTimer, 关闭提示, -500 ;500毫秒后关闭提示
  }
}
Critical, Off
return

~WheelDown:: ;触发按键 滚轮下
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
  if (WinName="WorkerW") or (WinName="_cls_desk_") or (WinName="Progman") or (WinName="ActualTools_MultiMonitorTaskbar") ;黑名单列表 双引号内填类名 ahk_class
  {
    Critical, Off
    return ;如果在黑名单列表的窗口内操作则不执行
  }
  if (WY<WinTop) ;点击位置在窗口顶部
  {
    ToolTip 最小化%WinID%窗口
    WinMinimize, ahk_id %WinID% ;最小化窗口
    MiniWinID:=WinID ;记录最近一次被最小化的窗口
    IniWrite, %MiniWinID%, Settings.ini, 设置, 最近一次被最小化的窗口 ;写入设置到ini文件
    SetTimer, 关闭提示, -500 ;500毫秒后关闭提示
  }
}
return

; ~LButton:: ;左键
; CoordMode Mouse, Screen ;以屏幕为基准
; MouseGetPos, , , WinID
; WinGetClass, WinName, ahk_id %WinID% ;获取窗口类名
; return

~MButton:: ;中键
Critical, On
DllCall("QueryPerformanceFrequency", "Int64*", freq)
DllCall("QueryPerformanceCounter", "Int64*", TapBefore)
if (MButton_presses > 0) ;因为键击记录不是0 证明这不是首次按下
{
  MButton_presses:=MButton_presses+1 ;所以记录键击次数+1
  Critical, Off
  return
}
else ;因为键击记录是0 证明这是首次按下 把键击记录次数设为 1 并启动计时器
{
  MButton_presses:=1
  CoordMode Mouse, Screen ;以屏幕为基准
  MouseGetPos, MXOld, ,WinID ;获取鼠标在屏幕中的位置
  WinGetClass, WinName, ahk_id %WinID% ;获取窗口类名
  摇晃阈值:=10
  LJX:=MXOld-摇晃阈值
  RJX:=MXOld+摇晃阈值
  已向左:=0
  已向右:=0
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
  
  loop ;循环 放大镜功能 窗口传送功能
  {
    MouseGetPos, MXNew
    
    if !GetKeyState("MButton", "P")
    {
      break
    }
    
    if (MXNew<LJX)
    {
      已向左:=1
    }
    
    if (MXNew>RJX)
    {
      已向右:=1
    }
    
    if (已向左=1) and (已向右=1) ;按下滚轮上时打开放大镜 Win+加号
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
          break
        }
        
        If (zoom<31 and GetKeyState("w", "P"))
        {
          zoom *= 1.189207115
          KeyWait w
        }
        If (zoom> 1 and GetKeyState("s", "P"))
        {
          zoom /= 1.189207115
          KeyWait s
        }
        Zx := Rx/zoom
        Zy := Ry/zoom
        TrayTip,,% "Zoom = " Round(100*zoom) "%"
      }
      
      ToolTip 关闭放大镜
      FDJ:=0
      FDJM:=0
      SetTimer, 关闭放大镜, -1
      SetTimer, 关闭提示, -300 ;300毫秒后关闭提示
      
      MButton_presses:=0 ;键击记录重置为0
      return
    }
  }
  
  if (屏幕位置=1)
  {
    if (MXNew>FJR)
    {
      ToolTip 发送%WinID%窗口到右边屏幕
      WinMove, ahk_id %WinID%, ,YDR ,YDY ,SW ,SH ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
      SetTimer, 关闭提示, -500 ;500毫秒后关闭提示
      MButton_presses:=0 ;键击记录重置为0
      Critical, Off
      return
    }
    else if (MXNew>FJL)
    {
      ToolTip 发送%WinID%窗口到中间屏幕
      WinMove, ahk_id %WinID%, ,YDM ,YDY ,SW ,SH ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
      SetTimer, 关闭提示, -500 ;500毫秒后关闭提示
      MButton_presses:=0 ;键击记录重置为0
      Critical, Off
      return
    }
  }
  else if (屏幕位置=2)
  {
    if (MXNew<FJL)
    {
      ToolTip 发送%WinID%窗口到左边屏幕
      WinMove, ahk_id %WinID%, ,YDL ,YDY ,SW ,SH ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
      SetTimer, 关闭提示, -500 ;500毫秒后关闭提示
      MButton_presses:=0 ;键击记录重置为0
      Critical, Off
      return
    }
    else if (MXNew>FJR)
    {
      ToolTip 发送%WinID%窗口到右边屏幕
      WinMove, ahk_id %WinID%, ,YDR ,YDY ,SW ,SH ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
      SetTimer, 关闭提示, -500 ;500毫秒后关闭提示
      MButton_presses:=0 ;键击记录重置为0
      Critical, Off
      return
    }
  }
  else if (屏幕位置=3)
  {
    if (MXNew<FJL)
    {
      ToolTip 发送%WinID%窗口到左边屏幕
      WinMove, ahk_id %WinID%, ,YDL ,YDY ,SW ,SH ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
      SetTimer, 关闭提示, -500 ;500毫秒后关闭提示
      MButton_presses:=0 ;键击记录重置为0
      Critical, Off
      return
    }
    else if (MXNew<FJR)
    {
      ToolTip 发送%WinID%窗口到中间屏幕
      WinMove, ahk_id %WinID%, ,YDM ,YDY ,SW ,SH ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
      SetTimer, 关闭提示, -500 ;500毫秒后关闭提示
      MButton_presses:=0 ;键击记录重置为0
      Critical, Off
      return
    }
  }
  
  DllCall("QueryPerformanceCounter", "Int64*", TapAfter)
  按下时间:=(TapAfter-TapBefore)/freq*1000, 2 ;长按时间检测
  if (按下时间>300) ;长按时间大于300ms将当前窗口填满所有屏幕
  {
    CoordMode Mouse, Window ;以窗口为基准
    MouseGetPos, , WY, WinID ;获取鼠标在窗口中的位置
    WinGetClass, WinName, ahk_id %WinID% ;获取窗口类名
    if (WY<WinTop) ;点击位置在窗口顶部
    {
      ToolTip 将%WinID%窗口填满所有屏幕
      WinMove, ahk_id %WinID%, ,0-KDXZ/2 ,0 ,A_ScreenWidth+KDXZ ,A_ScreenHeight+GDXZ ;移动窗口 窗口句柄 位置X 位置Y 宽度 高度
      SetTimer, 关闭提示, -500 ;500毫秒后关闭提示
    }
    MButton_presses:=0 ;键击记录重置为0
    Critical, Off
    return
  }
  else
  {
    SetTimer, KeyMButton, -300 ; 启动在 300 毫秒内等待更多键击的计时器
  }
  Critical, Off
  return
}

KeyMButton: ;计时器
if (MButton_presses=1) and (running=1) and (MiniWinID!=0) ;此键按下了一次 并且 软件正在运行中
{
  ToolTip 还原最%MiniWinID%窗口
  WinRestore, ahk_id %MiniWinID% ;还原最近一次被最小化的窗口
  SetTimer, 关闭提示, -300 ;300毫秒后关闭提示
}
else if (MButton_presses>=2) ;此键按下了两次及以上
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

关闭提示:
ToolTip
return

使用教程:
MsgBox, ,使用教程 ,在窗口顶部`n      拨动滚轮最大或最小化当前窗口`n在窗口顶部`n      长按中键窗口填满所有屏幕`n在窗口任意位置`n      按住中键并拖动到其他窗口`n      可以发送窗口到中键抬起的时候的屏幕`n在屏幕底部`n      滚轮最大或最小化全部窗口`n最小化窗口后`n      按中键可以呼出最近一次最小化的窗口`n`n按住中键的时候`n      左右晃动鼠标打开放大镜`n      放大镜激活期间按下W或者S改变缩放倍率`n      放大后如果太模糊打开锐化算法`n      抬起中键后关闭放大镜`n`n双击中键`n      暂停运行`n      再次双击恢复运行`n`n黑名单添加`:`n      在窗口顶部按下ctrl+C即可复制窗口类名`n      需要手动添加类名到黑名单`n      改代码后需要重启脚本才能应用设置`n`n如果和某些软件冲突`n      导致无法最大化和还原所有窗口`n      例如Actual Multiple Monitors`n      请打开兼容模式运行本软件`n`n黑钨重工出品 免费开源 请勿商用 侵权必究`n更多免费教程尽在QQ群`n1群763625227 2群643763519
return

暂停运行: ;模式切换
Critical, On
if (running=0)
{
  ToolTip 分屏助手恢复运行
  Menu, Tray, Icon, %A_ScriptDir%\Running.ico ;任务栏图标改成正在运行
  running:=1
  Hotkey WheelUp, On ;打开滚轮上的热键
  Hotkey WheelDown, On ;打开滚轮下的热键
  Hotkey ^c, On ;打开Ctrl+C的热键
  Hotkey w, On ;打开W的热键
  Hotkey s, On ;打开S的热键
  SetTimer, 屏幕监测, 100
  Menu, Tray, UnCheck, 暂停运行 ;右键菜单不打勾
}
else
{
  ToolTip 分屏助手暂停运行
  Menu, Tray, Icon, %A_ScriptDir%\Stopped.ico ;任务栏图标改成暂停运行
  running:=0
  Hotkey WheelUp, Off ;关闭滚轮上的热键
  Hotkey WheelDown, Off ;关闭滚轮下的热键
  Hotkey ^c, Off ;关闭Ctrl+C的热键
  Hotkey w, Off ;关闭W的热键
  Hotkey s, Off ;关闭S的热键
  SetTimer, 屏幕监测, Off
  WinHide, ahk_id %MagnifierWindowID%
  Menu, Tray, Check, 暂停运行 ;右键菜单打勾
}
Critical, Off
SetTimer, 关闭提示, -500 ;500毫秒后关闭提示
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

屏幕监测:
CoordMode Mouse, Screen ;以屏幕为基准
MouseGetPos, MISX ;获取鼠标在屏幕中的位置
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

MagImageScalingCallback(hwnd, srcdata, srcheader, destdata, destheader, unclipped, clipped, dirty) {
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
	Return
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
if (x>A_ScreenWidth/2+Round(A_ScreenHeight*(500/1080)))
{
  WinMove ahk_id %MagnifierID%,,x-Round(A_ScreenHeight*(80/1080))-Rx*2, y-Ry
}
else if (x<A_ScreenWidth/2-Round(A_ScreenHeight*(500/1080)))
{
  WinMove ahk_id %MagnifierID%,,x+Round(A_ScreenHeight*(80/1080)), y-Ry
}
else if (y>A_ScreenHeight/2+Round(A_ScreenHeight*(200/1080)))
{
  WinMove ahk_id %MagnifierID%,,x-Rx, y-Round(A_ScreenHeight*(80/1080))-Ry*2
}
else
{
  WinMove ahk_id %MagnifierID%,,x-Rx, y+Round(A_ScreenHeight*(80/1080))
}

DllCall("gdi32.dll\StretchBlt", UInt,hdc_frame, Int,0, Int,0, Int,2*Rx, Int,2*Ry, UInt,hdd_frame, UInt,xz, UInt,yz, Int,2*Zx, Int,2*Zy, UInt,0xCC0020) ; SRCCOPY
Return

GuiSize:
Rx := A_GuiWidth/2
Ry := A_GuiHeight/2
Zx := Rx/zoom
Zy := Ry/zoom
TrayTip,,% "Frame  =  " Round(2*Zx) " × " Round(2*Zy) "`nMagnified to = " A_GuiWidth "×" A_GuiHeight
Return

锐化算法:
Critical, On
if (antialize=1)
{
  antialize:=0
  DllCall( "gdi32.dll\SetStretchBltMode", "uint", hdc_frame, "int", 4*antialize )
  IniWrite, %antialize%, Settings.ini, 设置, 锐化算法 ;写入设置到ini文件
  Menu, Tray, UnCheck, 锐化算法 ;右键菜单不打勾
}
else
{
  antialize:=1
  DllCall( "gdi32.dll\SetStretchBltMode", "uint", hdc_frame, "int", 4*antialize )
  IniWrite, %antialize%, Settings.ini, 设置, 锐化算法 ;写入设置到ini文件
  Menu, Tray, Check, 锐化算法 ;右键菜单打勾
}
Critical, Off
return

关闭放大镜:
SetTimer, Repaint, Off
DllCall("gdi32.dll\DeleteDC", UInt,hdc_frame )
DllCall("gdi32.dll\DeleteDC", UInt,hdd_frame )
Gui, 放大镜:Destroy
Return

打开放大镜:
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
DllCall("gdi32.dll\DeleteDC", UInt,hdc_frame )
DllCall("gdi32.dll\DeleteDC", UInt,hdd_frame )
DllCall("magnification.dll\MagUninitialize")
DllCall("gdiplus\GdiplusShutdown", Ptr, pToken)
if hModule := DllCall("GetModuleHandle", "Str", "gdiplus", Ptr)
{
  DllCall("FreeLibrary", Ptr, hModule)
}
ExitApp

$w::
if (FDJM=0)
{
  Send {w Down}
  KeyWait w
  Send {w Up}
}
Return

$s::
if (FDJM=0)
{
  Send {s Down}
  KeyWait s
  Send {s Up}
}
Return