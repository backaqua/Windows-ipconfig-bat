@echo off
@REM Release��2.1 2019/04/27 �


@echo off
fltmc>nul||cd/d %~dp0&&mshta vbscript:CreateObject("Shell.Application").ShellExecute("%~nx0","%1","","runas",1)(window.close)&&exit
@REM ����UAC����֤�ű����Թ���Ա�������


@echo off
cls
color 0A


cd /d %~dp0
@REM �л���bat�ļ����ڵ�Ŀ¼


echo ***********************************************
echo * �˽ű��ļ����ڱ���/�޸�IP��ַ�����ݵ�IP���� *
echo * �ڽű����ڵ�Ŀ¼�У��ļ���Ϊip��txt�ĵ���   *
echo *                                             *
echo * ֧���Զ�����IP��ͬʱҲ֧���ֶ�����IP��ַ    *
echo ***********************************************
echo.
echo ���루 1 ��ѡ�񱸷�IP
echo ���루 2 ��ѡ������IP
echo ���루 3 ���鿴��ǰIP
echo.
set /p choice=��ѡ���������:
if "%choice%"=="1" goto BackupIP
if "%choice%"=="2" goto ConfigIP
if "%choice%"=="3" goto ShowIP
echo ������󣬽ű������˳�
goto end





%----------------------------------------------------------------------%
:BackupIP
@REM ���ݱ������ӵ�IP��ַ
@REM ���ȼ������״̬���ҵ�Ŀǰ״̬Ϊ�����ӵ�����
set "InterTmp=%temp%\interface.txt"
cmd /c netsh interface show interface | findstr "������" > "%InterTmp%"
@REM ʹ��netsh����ҳ�������״̬����������������ļ��У�����֮����
setlocal enabledelayedexpansion
set num=0
for /F "tokens=3,*" %%i in ('type "%InterTmp%" ') do (
    set /a num+=1
    set var!num!=%%j
)
@REM ʹ��for��䣬��������״̬����������ȡ����

echo.
echo ************************************
echo *  ��ע�⣬���ݵ��ļ������ڴ˽ű�  *
echo *   ���ڵ�Ŀ¼�У��ļ���Ϊip.txt   *
echo ************************************

echo.
echo "���ڼ������״̬�����Ժ�..."
echo.
echo "Ŀǰ���ڻ�Ծ״̬������������"
echo.

echo,(1)%var1% 2>nul
echo,(2)%var2% 2>nul
echo,(3)%var3% 2>nul
echo,(4)%var4% 2>nul
echo,(5)%var5% 2>nul
@REM �г�5����������״̬��������

set /p select="��ѡ����Ҫ���ݵ���������: "
@REM ������״̬��ӡ���������û�ѡ����Ҫ����������

call :activelink %select%
@REM ���û�����Ĳ�������activelink��ǩ�У������û�������õ���Ӧ������������

set "IPTmp=%temp%\iplist.txt"
set "DNSTmp=%temp%\dnslist.txt"
cmd /c netsh interface ipv4 show address name=%chr% > %IPTmp%
cmd /c netsh interface ipv4 show dnsservers name=%chr% > %DNSTmp%
@REM ʹ��netsh���õ�������IP��ַ����Ϣ��Ŀǰ�������е�bat�ű�������ipconfig����ȡ�ġ�
@REM �˴���ʹ��netsh����ȡ��Ҫ��Ϊ�˷���֮����

for /f "tokens=2 delims=:" %%i in ('findstr /c:"��ַ" "%IPTmp%"') do (
    set "IP=%%i"
)
for /f "tokens=2 delims=:" %%i in ('findstr /c:"Ĭ������" "%IPTmp%"') do (
    set "GATEWAY=%%i"
)
for /f "tokens=3 delims=:()" %%i in ('more %IPTmp% ^| findstr "����"') do (
    set "MASK=%%i"
)
for /f "tokens=2 delims=:" %%i in ('findstr /c:"DNS" "%DNSTmp%"') do (
    set "DNS=%%i"
)
@REM ʹ��for�������ȡ��Ҫ��ֵ

set "IP=%IP: =%"
set "MASK=%MASK:���� =%"
set "GATEWAY=%GATEWAY: =%"
set "DNS=%DNS: =%"
@REM ���ڻ�ȡ��ֵ���ո���޹ز��������ʹ��set������������������

echo,IP��ַ:%IP% > %CD%/ip.txt
echo,��������:%MASK% >> %CD%/ip.txt
echo,Ĭ������:%GATEWAY% >> %CD%/ip.txt
echo,DNS������:%DNS% >> %CD%/ip.txt
@REM ��׷�ӷ�ʽ����д��

echo ����IP�ɹ� ��������˳�
pause 1>nul
exit





%-----------------------------------------------------------------------%
:ShowIP
@REM ���ȼ������״̬���ҵ�Ŀǰ״̬Ϊ�����ӵ�����

set "InterTmp=%temp%\interface.txt"
cmd /c netsh interface show interface | findstr "������" > "%InterTmp%"
@REM ʹ��netsh����ҳ�������״̬����������������ļ��У�����֮����

setlocal enabledelayedexpansion
set num=0
for /F "tokens=3,*" %%i in ('type "%InterTmp%" ') do (
    set /a num+=1
    set var!num!=%%j
)
@REM ʹ��for��䣬��������״̬����������ȡ����

echo.
echo "���ڼ������״̬�����Ժ�..."
echo.
echo "Ŀǰ���ڻ�Ծ״̬������������"
echo.
echo,(1)%var1% 2>nul
echo,(2)%var2% 2>nul
echo,(3)%var3% 2>nul
echo,(4)%var4% 2>nul
echo,(5)%var5% 2>nul
@REM �г�5����������״̬��������

set /p select="��ѡ����Ҫ�鿴����������: "
@REM ������״̬��ӡ���������û�ѡ����Ҫ����������

call :activelink %select%
@REM ���û�����Ĳ�������activelink��ǩ�У������û�������õ���Ӧ������������

set "IPTmp=%temp%\iplist.txt"
set "DNSTmp=%temp%\dnslist.txt"
cmd /c netsh interface ipv4 show address name=%chr% > %IPTmp%
cmd /c netsh interface ipv4 show dnsservers name=%chr% > %DNSTmp%
@REM ʹ��netsh���õ�������IP��ַ����Ϣ��Ŀǰ�������е�bat�ű�������ipconfig����ȡ�ġ�
@REM �˴���ʹ��netsh����ȡ��Ҫ��Ϊ�˷���֮����

for /f "tokens=2 delims=:" %%i in ('findstr /c:"��ַ" "%IPTmp%"') do (
    set "IP=%%i"
)
for /f "tokens=2 delims=:" %%i in ('findstr /c:"Ĭ������" "%IPTmp%"') do (
    set "GATEWAY=%%i"
)
for /f "tokens=3 delims=:()" %%i in ('more %IPTmp% ^| findstr "����"') do (
    set "MASK=%%i"
)
for /f "tokens=2 delims=:" %%i in ('findstr /c:"DNS" "%DNSTmp%"') do (
    set "DNS=%%i"
)
@REM ʹ��for�������ȡ��Ҫ��ֵ

set "IP=%IP: =%"
set "MASK=%MASK:���� =%"
set "GATEWAY=%GATEWAY: =%"
set "DNS=%DNS: =%"
@REM ���ڻ�ȡ��ֵ���ո���޹ز��������ʹ��set������������������
echo.
echo,"IP��ַ:%IP%"
echo,"��������:%MASK%"
echo,"Ĭ������:%GATEWAY%"
echo,"DNS������:%DNS%"
echo.
@REM ��׷�ӷ�ʽ����д��
goto end





%-----------------------------------------------------------------------------%
:ConfigIP
@echo off
echo.
echo ********************************
echo *     �޸�����������IP��ַ     *
echo * ������ʱֻ���޸ı������ӵ�IP *
echo ********************************
echo.
echo ���루 1 ��ѡ���Զ���ȡ
echo ���루 2 ��ѡ���ֶ�����
echo ���루 3 ���Ӹղű���IP�ļ���������
echo.
set/p choice=��ѡ���޸ķ�ʽ��
if "%choice%"=="1" goto dhcp
if "%choice%"=="2" goto static
if "%choice%"=="3" goto import
echo ������󣬽ű������˳�
goto end





%----------------------------------------------------------------------------------%
:dhcp
@REM ��ip���䷽ʽ��Ϊdhcp����������
@REM ���ȼ������״̬���ҵ�Ŀǰ״̬Ϊ�����ӵ�����
set "InterTmp=%temp%\interface.txt"
cmd /c netsh interface show interface | findstr "������" > "%InterTmp%"
@REM ʹ��netsh����ҳ�������״̬����������������ļ��У�����֮����
setlocal enabledelayedexpansion
set num=0
for /F "tokens=3,*" %%i in ('type "%InterTmp%" ') do (
    set /a num+=1
    set var!num!=%%j
)
@REM ʹ��for��䣬��������״̬����������ȡ����

echo.
echo "���ڼ������״̬,���Ժ�..."
echo.
echo "Ŀǰ���ڻ�Ծ״̬������������"
echo.
echo,(1)%var1% 2>nul
echo,(2)%var2% 2>nul
echo,(3)%var3% 2>nul
echo,(4)%var4% 2>nul
echo,(5)%var5% 2>nul
@REM �г�5����������״̬��������

set /p select="��ѡ����Ҫ���õ�����:"
@REM ������״̬��ӡ���������û�ѡ����Ҫ����������

call :activelink %select%
@REM ���û�����Ĳ�������activelink��ǩ�У������û�������õ���Ӧ������������

cmd /c netsh interface ip set address name=%chr% source=dhcp
cmd /c netsh interface ip set dns name=%chr% source=dhcp
cmd /c netsh interface set interface %chr% disabled
cmd /c netsh interface set interface %chr% enabled
@REM ʹ��netsh��������ip

echo ����IP�ɹ�...
goto end






%------------------------------------------------------------------------------%
:static
@REM ʹ���ֶ�����ķ�ʽ����IP
@REM ���ȼ������״̬���ҵ�Ŀǰ״̬Ϊ�����ӵ�����

set "InterTmp=%temp%\interface.txt"
cmd /c netsh interface show interface | findstr "������" > "%InterTmp%"
@REM ʹ��netsh����ҳ�������״̬����������������ļ��У�����֮����

setlocal enabledelayedexpansion
set num=0
for /F "tokens=3,*" %%i in ('type "%InterTmp%" ') do (
    set /a num+=1
    set var!num!=%%j
)
@REM ʹ��for��䣬��������״̬����������ȡ����

echo.
echo "���ڼ������״̬,���Ժ�..."
echo.
echo "Ŀǰ���ڻ�Ծ״̬������������"
echo.
echo,(1)%var1% 2>nul
echo,(2)%var2% 2>nul
echo,(3)%var3% 2>nul
echo,(4)%var4% 2>nul
echo,(5)%var5% 2>nul
@REM �г�5����������״̬��������

set /p select="��ѡ����Ҫ���õ�����:"
@REM ������״̬��ӡ���������û�ѡ����Ҫ����������

call :activelink %select%
@REM ���û�����Ĳ�������activelink��ǩ�У������û�������õ���Ӧ������������

SET /p IP=������IP��ַ��
SET /p MASK=�������������룺
SET /p GATEWAY=������Ĭ�����أ�
SET /p DNS=������DNS�� 
@REM �����û����룬����ֵ������
echo.
echo ���ڸ���IP��ַ�����Ե�......
echo.
cmd /c netsh interface ip set address name=%chr% source=static addr=%IP% mask=%MASK% gateway=%GATEWAY% gwmetric=1
cmd /c netsh interface ip set dns name=%chr% source=static addr=%DNS% 1>nul 2>nul
cmd /c netsh interface set interface %chr% disabled
cmd /c netsh interface set interface %chr% enabled
@REM �������ֵ���ó�ip������������

echo ����IP�ɹ�
goto end






%------------------------------------------------------------------------------------------%
:import

@REM ���ȼ������״̬���ҵ�Ŀǰ״̬Ϊ�����ӵ�����

set "InterTmp=%temp%\interface.txt"
cmd /c netsh interface show interface | findstr "������" > "%InterTmp%"
@REM ʹ��netsh����ҳ�������״̬����������������ļ��У�����֮����

setlocal enabledelayedexpansion
set num=0
for /F "tokens=3,*" %%i in ('type "%InterTmp%" ') do (
    set /a num+=1
    set var!num!=%%j
)
@REM ʹ��for��䣬��������״̬����������ȡ����

echo.
echo "���ڼ������״̬�����Ե�..."
echo.
echo "Ŀǰ���ڻ�Ծ״̬������������"
echo.
echo,(1)%var1% 2>nul
echo,(2)%var2% 2>nul
echo,(3)%var3% 2>nul
echo,(4)%var4% 2>nul
echo,(5)%var5% 2>nul
@REM �г�5����������״̬��������

set /p select="��ѡ����Ҫ�������õ�����:"
@REM ������״̬��ӡ���������û�ѡ����Ҫ����������

call :activelink %select%
@REM ���û�����Ĳ�������activelink��ǩ�У������û�������õ���Ӧ������������

echo ���ڵ�������,���Ե�...
set "ipfile=%CD%\ip.txt"

for /f "delims=: tokens=2" %%i in ('findstr /c:"IP" "%ipfile%"') do (
    set IP=%%i
)
for /f "delims=: tokens=2" %%i in ('findstr /c:"��������" "%ipfile%"') do (
    set MASK=%%i
)
for /f "delims=: tokens=2" %%i in ('findstr /c:"Ĭ������" "%ipfile%"') do (
    set GATEWAY=%%i
)
for /f "delims=: tokens=2" %%i in ('findstr /c:"DNS" "%ipfile%"') do (
    set DNS=%%i
)

cmd /c netsh interface ip set address name=%chr% source=static addr=%IP% mask=%MASK% gateway=%GATEWAY% gwmetric=1
cmd /c netsh interface ip set dns name=%chr% source=static addr=%DNS% 1>nul 2>nul
netsh interface set interface %chr% disabled
netsh interface set interface %chr% enabled
echo �����������óɹ�
goto end

:end
echo ���س����˳�
pause 1>nul
exit

:activelink
if "%~1"=="1" (set chr="%var1%") else (if "%~1"=="2" (set chr="%var2%") else (if "%~1"=="3" (set chr="%var3%") else (if "%~1"=="4" (set chr="%var4%") else (if "%~1"=="5" (set chr="%var5%")))))
@REM activelink��ǩ���ڸ��ݽ��յ��Ĳ������õ���ͬ��chrֵ�������������������û�������ֵ���õ��û�ѡ��������������������ƻ���Ϊ�����û�֮������õȲ�����