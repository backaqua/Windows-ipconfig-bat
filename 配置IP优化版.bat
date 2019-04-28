@echo off
@REM Release：2.1 2019/04/27 李晨


@echo off
fltmc>nul||cd/d %~dp0&&mshta vbscript:CreateObject("Shell.Application").ShellExecute("%~nx0","%1","","runas",1)(window.close)&&exit
@REM 跳出UAC，保证脚本是以管理员身份运行


@echo off
cls
color 0A


cd /d %~dp0
@REM 切换到bat文件所在的目录


echo ***********************************************
echo * 此脚本文件用于备份/修改IP地址，备份的IP保存 *
echo * 在脚本所在的目录中，文件名为ip的txt文档。   *
echo *                                             *
echo * 支持自动分配IP，同时也支持手动输入IP地址    *
echo ***********************************************
echo.
echo 输入（ 1 ）选择备份IP
echo 输入（ 2 ）选择配置IP
echo 输入（ 3 ）查看当前IP
echo.
set /p choice=请选择操作内容:
if "%choice%"=="1" goto BackupIP
if "%choice%"=="2" goto ConfigIP
if "%choice%"=="3" goto ShowIP
echo 输入错误，脚本即将退出
goto end





%----------------------------------------------------------------------%
:BackupIP
@REM 备份本地连接的IP地址
@REM 首先检测网卡状态，找到目前状态为已连接的网卡
set "InterTmp=%temp%\interface.txt"
cmd /c netsh interface show interface | findstr "已连接" > "%InterTmp%"
@REM 使用netsh命令，找出已连接状态的网卡，并输出到文件中，方便之后处理
setlocal enabledelayedexpansion
set num=0
for /F "tokens=3,*" %%i in ('type "%InterTmp%" ') do (
    set /a num+=1
    set var!num!=%%j
)
@REM 使用for语句，把已连接状态的网络名称取出来

echo.
echo ************************************
echo *  请注意，备份的文件保存在此脚本  *
echo *   所在的目录中，文件名为ip.txt   *
echo ************************************

echo.
echo "正在检测网络状态，请稍后..."
echo.
echo "目前处在活跃状态的网络连接有"
echo.

echo,(1)%var1% 2>nul
echo,(2)%var2% 2>nul
echo,(3)%var3% 2>nul
echo,(4)%var4% 2>nul
echo,(5)%var5% 2>nul
@REM 列出5个处于连接状态的网卡名

set /p select="请选择需要备份的网络连接: "
@REM 把网卡状态打印出来，让用户选择需要操作的网卡

call :activelink %select%
@REM 把用户输入的参数带入activelink标签中，根据用户的输入得到相应的网络连接名

set "IPTmp=%temp%\iplist.txt"
set "DNSTmp=%temp%\dnslist.txt"
cmd /c netsh interface ipv4 show address name=%chr% > %IPTmp%
cmd /c netsh interface ipv4 show dnsservers name=%chr% > %DNSTmp%
@REM 使用netsh来得到网卡的IP地址等信息。目前几乎所有的bat脚本都是用ipconfig来获取的。
@REM 此处我使用netsh来获取主要是为了方便之后处理

for /f "tokens=2 delims=:" %%i in ('findstr /c:"地址" "%IPTmp%"') do (
    set "IP=%%i"
)
for /f "tokens=2 delims=:" %%i in ('findstr /c:"默认网关" "%IPTmp%"') do (
    set "GATEWAY=%%i"
)
for /f "tokens=3 delims=:()" %%i in ('more %IPTmp% ^| findstr "子网"') do (
    set "MASK=%%i"
)
for /f "tokens=2 delims=:" %%i in ('findstr /c:"DNS" "%DNSTmp%"') do (
    set "DNS=%%i"
)
@REM 使用for语句来获取需要的值

set "IP=%IP: =%"
set "MASK=%MASK:掩码 =%"
set "GATEWAY=%GATEWAY: =%"
set "DNS=%DNS: =%"
@REM 由于获取的值带空格等无关参数，这边使用set来重新整理下输出结果

echo,IP地址:%IP% > %CD%/ip.txt
echo,子网掩码:%MASK% >> %CD%/ip.txt
echo,默认网关:%GATEWAY% >> %CD%/ip.txt
echo,DNS服务器:%DNS% >> %CD%/ip.txt
@REM 已追加方式逐条写入

echo 备份IP成功 按任意键退出
pause 1>nul
exit





%-----------------------------------------------------------------------%
:ShowIP
@REM 首先检测网卡状态，找到目前状态为已连接的网卡

set "InterTmp=%temp%\interface.txt"
cmd /c netsh interface show interface | findstr "已连接" > "%InterTmp%"
@REM 使用netsh命令，找出已连接状态的网卡，并输出到文件中，方便之后处理

setlocal enabledelayedexpansion
set num=0
for /F "tokens=3,*" %%i in ('type "%InterTmp%" ') do (
    set /a num+=1
    set var!num!=%%j
)
@REM 使用for语句，把已连接状态的网络名称取出来

echo.
echo "正在检测网络状态，请稍后..."
echo.
echo "目前处在活跃状态的网络连接有"
echo.
echo,(1)%var1% 2>nul
echo,(2)%var2% 2>nul
echo,(3)%var3% 2>nul
echo,(4)%var4% 2>nul
echo,(5)%var5% 2>nul
@REM 列出5个处于连接状态的网卡名

set /p select="请选择需要查看的网络连接: "
@REM 把网卡状态打印出来，让用户选择需要操作的网卡

call :activelink %select%
@REM 把用户输入的参数带入activelink标签中，根据用户的输入得到相应的网络连接名

set "IPTmp=%temp%\iplist.txt"
set "DNSTmp=%temp%\dnslist.txt"
cmd /c netsh interface ipv4 show address name=%chr% > %IPTmp%
cmd /c netsh interface ipv4 show dnsservers name=%chr% > %DNSTmp%
@REM 使用netsh来得到网卡的IP地址等信息。目前几乎所有的bat脚本都是用ipconfig来获取的。
@REM 此处我使用netsh来获取主要是为了方便之后处理

for /f "tokens=2 delims=:" %%i in ('findstr /c:"地址" "%IPTmp%"') do (
    set "IP=%%i"
)
for /f "tokens=2 delims=:" %%i in ('findstr /c:"默认网关" "%IPTmp%"') do (
    set "GATEWAY=%%i"
)
for /f "tokens=3 delims=:()" %%i in ('more %IPTmp% ^| findstr "子网"') do (
    set "MASK=%%i"
)
for /f "tokens=2 delims=:" %%i in ('findstr /c:"DNS" "%DNSTmp%"') do (
    set "DNS=%%i"
)
@REM 使用for语句来获取需要的值

set "IP=%IP: =%"
set "MASK=%MASK:掩码 =%"
set "GATEWAY=%GATEWAY: =%"
set "DNS=%DNS: =%"
@REM 由于获取的值带空格等无关参数，这边使用set来重新整理下输出结果
echo.
echo,"IP地址:%IP%"
echo,"子网掩码:%MASK%"
echo,"默认网关:%GATEWAY%"
echo,"DNS服务器:%DNS%"
echo.
@REM 已追加方式逐条写入
goto end





%-----------------------------------------------------------------------------%
:ConfigIP
@echo off
echo.
echo ********************************
echo *     修改有线网卡的IP地址     *
echo * 多网卡时只能修改本地连接的IP *
echo ********************************
echo.
echo 输入（ 1 ）选择自动获取
echo 输入（ 2 ）选择手动输入
echo 输入（ 3 ）从刚才备份IP文件导入设置
echo.
set/p choice=请选择修改方式：
if "%choice%"=="1" goto dhcp
if "%choice%"=="2" goto static
if "%choice%"=="3" goto import
echo 输入错误，脚本即将退出
goto end





%----------------------------------------------------------------------------------%
:dhcp
@REM 将ip分配方式改为dhcp并重启网卡
@REM 首先检测网卡状态，找到目前状态为已连接的网卡
set "InterTmp=%temp%\interface.txt"
cmd /c netsh interface show interface | findstr "已连接" > "%InterTmp%"
@REM 使用netsh命令，找出已连接状态的网卡，并输出到文件中，方便之后处理
setlocal enabledelayedexpansion
set num=0
for /F "tokens=3,*" %%i in ('type "%InterTmp%" ') do (
    set /a num+=1
    set var!num!=%%j
)
@REM 使用for语句，把已连接状态的网络名称取出来

echo.
echo "正在检测网络状态,请稍后..."
echo.
echo "目前处在活跃状态的网络连接有"
echo.
echo,(1)%var1% 2>nul
echo,(2)%var2% 2>nul
echo,(3)%var3% 2>nul
echo,(4)%var4% 2>nul
echo,(5)%var5% 2>nul
@REM 列出5个处于连接状态的网卡名

set /p select="请选择需要设置的连接:"
@REM 把网卡状态打印出来，让用户选择需要操作的网卡

call :activelink %select%
@REM 把用户输入的参数带入activelink标签中，根据用户的输入得到相应的网络连接名

cmd /c netsh interface ip set address name=%chr% source=dhcp
cmd /c netsh interface ip set dns name=%chr% source=dhcp
cmd /c netsh interface set interface %chr% disabled
cmd /c netsh interface set interface %chr% enabled
@REM 使用netsh命令设置ip

echo 配置IP成功...
goto end






%------------------------------------------------------------------------------%
:static
@REM 使用手动输入的方式配置IP
@REM 首先检测网卡状态，找到目前状态为已连接的网卡

set "InterTmp=%temp%\interface.txt"
cmd /c netsh interface show interface | findstr "已连接" > "%InterTmp%"
@REM 使用netsh命令，找出已连接状态的网卡，并输出到文件中，方便之后处理

setlocal enabledelayedexpansion
set num=0
for /F "tokens=3,*" %%i in ('type "%InterTmp%" ') do (
    set /a num+=1
    set var!num!=%%j
)
@REM 使用for语句，把已连接状态的网络名称取出来

echo.
echo "正在检测网络状态,请稍后..."
echo.
echo "目前处在活跃状态的网络连接有"
echo.
echo,(1)%var1% 2>nul
echo,(2)%var2% 2>nul
echo,(3)%var3% 2>nul
echo,(4)%var4% 2>nul
echo,(5)%var5% 2>nul
@REM 列出5个处于连接状态的网卡名

set /p select="请选择需要设置的连接:"
@REM 把网卡状态打印出来，让用户选择需要操作的网卡

call :activelink %select%
@REM 把用户输入的参数带入activelink标签中，根据用户的输入得到相应的网络连接名

SET /p IP=请输入IP地址：
SET /p MASK=请输入子网掩码：
SET /p GATEWAY=请输入默认网关：
SET /p DNS=请输入DNS： 
@REM 接收用户输入，并赋值给变量
echo.
echo 正在更改IP地址，请稍等......
echo.
cmd /c netsh interface ip set address name=%chr% source=static addr=%IP% mask=%MASK% gateway=%GATEWAY% gwmetric=1
cmd /c netsh interface ip set dns name=%chr% source=static addr=%DNS% 1>nul 2>nul
cmd /c netsh interface set interface %chr% disabled
cmd /c netsh interface set interface %chr% enabled
@REM 将输入的值配置成ip，并重启网卡

echo 配置IP成功
goto end






%------------------------------------------------------------------------------------------%
:import

@REM 首先检测网卡状态，找到目前状态为已连接的网卡

set "InterTmp=%temp%\interface.txt"
cmd /c netsh interface show interface | findstr "已连接" > "%InterTmp%"
@REM 使用netsh命令，找出已连接状态的网卡，并输出到文件中，方便之后处理

setlocal enabledelayedexpansion
set num=0
for /F "tokens=3,*" %%i in ('type "%InterTmp%" ') do (
    set /a num+=1
    set var!num!=%%j
)
@REM 使用for语句，把已连接状态的网络名称取出来

echo.
echo "正在检测网络状态，请稍等..."
echo.
echo "目前处在活跃状态的网络连接有"
echo.
echo,(1)%var1% 2>nul
echo,(2)%var2% 2>nul
echo,(3)%var3% 2>nul
echo,(4)%var4% 2>nul
echo,(5)%var5% 2>nul
@REM 列出5个处于连接状态的网卡名

set /p select="请选择需要导入设置的连接:"
@REM 把网卡状态打印出来，让用户选择需要操作的网卡

call :activelink %select%
@REM 把用户输入的参数带入activelink标签中，根据用户的输入得到相应的网络连接名

echo 正在导入配置,请稍等...
set "ipfile=%CD%\ip.txt"

for /f "delims=: tokens=2" %%i in ('findstr /c:"IP" "%ipfile%"') do (
    set IP=%%i
)
for /f "delims=: tokens=2" %%i in ('findstr /c:"子网掩码" "%ipfile%"') do (
    set MASK=%%i
)
for /f "delims=: tokens=2" %%i in ('findstr /c:"默认网关" "%ipfile%"') do (
    set GATEWAY=%%i
)
for /f "delims=: tokens=2" %%i in ('findstr /c:"DNS" "%ipfile%"') do (
    set DNS=%%i
)

cmd /c netsh interface ip set address name=%chr% source=static addr=%IP% mask=%MASK% gateway=%GATEWAY% gwmetric=1
cmd /c netsh interface ip set dns name=%chr% source=static addr=%DNS% 1>nul 2>nul
netsh interface set interface %chr% disabled
netsh interface set interface %chr% enabled
echo 导入网卡配置成功
goto end

:end
echo 按回车键退出
pause 1>nul
exit

:activelink
if "%~1"=="1" (set chr="%var1%") else (if "%~1"=="2" (set chr="%var2%") else (if "%~1"=="3" (set chr="%var3%") else (if "%~1"=="4" (set chr="%var4%") else (if "%~1"=="5" (set chr="%var5%")))))
@REM activelink标签用于根据接收到的参数，得到不同的chr值。即是我们用来根据用户的输入值，得到用户选择的网络名。此网络名称会作为变量用户之后的配置等操作。