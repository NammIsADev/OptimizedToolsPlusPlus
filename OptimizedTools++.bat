@echo off
title OptimizedTools++: Preparing...
REM Run as Admin
REM Delete the registry key
reg delete HKLM\Software\Microsoft\Windows\CurrentVersion\Run /v DummyEntry /f >reg_log.txt 2>&1
reg add HKLM\Software\Microsoft\Windows\CurrentVersion\Run /v DummyEntry /t REG_SZ /d 1 >reg_log.txt 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process '%~dpnx0' -Verb RunAs"
    exit /b
)

Mode 100,43
setlocal EnableDelayedExpansion


REM Blank/Color Character
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (set "DEL=%%a" & set "COL=%%b")
REM Add ANSI escape sequences
reg add HKCU\CONSOLE /v VirtualTerminalLevel /t REG_DWORD /d 1 /f >nul 2>&1

REM Save the current directory
set CURRENT_DIR=%~dp0

REM Change to the 'bin' directory within the current directory
cd /d %CURRENT_DIR%bin

:update
echo.
echo                   --------------------------------------------------------------
echo                                        Check for updates
echo                   --------------------------------------------------------------
echo.
echo                                    Checking for new updates...
echo                                           Please wait.
echo.
echo.
curl -s -o "%temp%\check.txt" https://raw.githubusercontent.com/NammIsADev/OptimizedToolsPlusPlus/main-development/update/check.txt
ping -n 10 localhost > nul

:: Read the content of the downloaded file
set "fileContent="
for /f "usebackq tokens=* delims=" %%i in ("%temp%\check.txt") do (
    set "fileContent=%%i"
)

:: Remove any quotation marks
set "fileContent=!fileContent:"=!"

:: Trim leading and trailing spaces
for /f "tokens=* delims=" %%a in ("!fileContent!") do set "fileContent=%%a"

set "newVersion=!fileContent!"

:: Check the content and decide the action
if "!fileContent!"=="2.9.1" (
    echo                         Your version is !newVersion!, you are up to date.
	ping -n 3 localhost > nul
) else (
    echo                           We found a new version. Newer version: !newVersion!
	echo                                      Do you want to update?
	:loop2
	Batbox /h 0
	Call Button 35 14 "Yes" 55 14 "No" # Press
	Getinput /m %Press% /h 70
	:: Check for the pressed button 
	if %errorlevel%==1 (goto downloadupd)
	if %errorlevel%==2 (goto restorepoint)
	goto loop2
	ping -n 5 localhost > nul
	
	:downloadupd
	cls
	echo.
    echo                                        Downloading update...
    :: Download and replace the batch file
    curl -s -o "OptimizedTools++.bat" https://raw.githubusercontent.com/NammIsADev/OptimizedToolsPlusPlus/main-development/OptimizedTools%2B%2B%20first%20test%20version.bat
    echo                                   Updated. Press Enter to continue.
    pause > nul
    goto restorepoint
)


:restorepoint
cls
echo.
echo                   --------------------------------------------------------------
echo                                          Restore Point
echo                   --------------------------------------------------------------
echo.
echo                                     Create a restore point?
echo.
echo.
echo.
goto loop

:loop
Batbox /h 0

Call Button 35 10 "Yes" 55 10 "No" # Press
Getinput /m %Press% /h 70

:: Check for the pressed button 
if %errorlevel%==1 (goto startbackup)
if %errorlevel%==2 (goto dir)
goto loop

:startbackup
cd..
mkdir OPTPlusPlus >nul 2>&1
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v "SystemRestorePointCreationFrequency" /t REG_DWORD /d 0 /f >nul 2>&1
powershell -ExecutionPolicy Unrestricted -NoProfile Enable-ComputerRestore -Drive 'C:\', 'D:\', 'E:\', 'F:\', 'G:\' >nul 2>&1
powershell -ExecutionPolicy Unrestricted -NoProfile Checkpoint-Computer -Description 'OptimizedTools++ Restore Point' >nul 2>&1
REM HKCU & HKLM backups
mkdir OPTPlusPlusTemp\RegRevert >nul 2>&1
for /F "tokens=2" %%i in ('date /t') do set date=%%i
set date1=%date:/=.%
>nul 2>&1 md OPTPlusPlusTemp\RegRevert\%date1%
reg export HKCU OPTPlusPlusTemp\RegRevert\%date1%\HKLM.reg /y >nul 2>&1
reg export HKCU OPTPlusPlusTemp\RegRevert\%date1%\HKCU.reg /y >nul 2>&1
echo set "firstlaunch=0" > OPTPlusPlusTemp\RegRevert\firstlaunchcheck

:dir
start /b mp -nodisp -autoexit s.mp3 > NUL 2>&1
cd..
REM Make Directories
mkdir OPTPlusPlus >nul 2>&1
mkdir OPTPlusPlus\Resources >nul 2>&1
mkdir OPTPlusPlus\Drivers >nul 2>&1
mkdir OPTPlusPlus\Renders >nul 2>&1
cd OPTPlusPlus
REM Show Detailed BSoD
reg add "HKLM\System\CurrentControlSet\Control\CrashControl" /v "DisplayParameters" /t REG_DWORD /d "1" /f >nul 2>&1
goto warn

:warn
cls
title OptimizedTools++: Warning
echo.
echo.
call :title
echo.
echo                          %COL%[36mRework version of old OptimizedTools version.%COL%[0m
echo                                   Simple - fast - lightweight.
echo                         NOTE: OptimizedTools++ is free and open-source. 
echo              If you paid for this program/downloaded from another source (not GitHub)
echo                       %COL%[33mPLEASE DELETE THE PROGRAM, SCAN YOUR PC FOR VIRUS NOW!!%COL%[0m
echo.
echo.
echo    %COL%[91mWARNING:%COL%[0m
echo    %COL%[91mUse at your own risk.%COL%[0m
echo    I am not %COL%[91mRESPONSIBLE%COL%[0m for cases of BSOD after tweaking, 
echo    unable to boot after restart, missing files/OS not working properly, etc.
echo.
echo    %COL%[91mPLEASE%COL%[0m do some research if you have any questions about the features 
echo    included in this software before you use it.
echo.
echo    %COL%[91mYOU%COL%[0m are choosing to make these modifications, and if you %COL%[91mPOINT%COL%[0m the finger 
echo    at me for damaging your operating system, I will laugh at you.
echo.
echo    Even though my software have an automatic restore point feature, I highly recommend 
echo    making a manual restore point before running.
echo.
echo    For any questions and/or concerns, please go to my GitHub: test_link
echo    Type "Yes" to continue: 
set /p "input=%DEL%                                     Your input:
if /i "!input!" neq "yes" goto warn
reg add "HKCU\Software\HoneCTRL" /v "Disclaimer" /f >nul 2>&1
goto mainmenu
goto :eof

:mainmenu
cls
echo.
echo.
call :title
echo.
echo.
echo                                           testmainmenu().
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo                                           Welcome. %username%
echo %COL%[33m////////////////////////////////////////////TEST BUILD//////////////////////////////////////////////%COL%[0m

pause >nul

:title
echo.
echo                         "   ___       _   _           _             _ "
echo                         "  /___\_ __ | |_(_)_ __ ___ (_)_______  __| |"
echo                         " //  // '_ \| __| | '_ \` _\| |_  / _ \/ _\`|"
echo                         "/ \_//| |_) | |_| | | | | | | |/ /  __/ (_| |"
echo                         "\___/ | .__/ \__|_|_| |_| |_|_/___\___|\__,_|"
echo                         "      |_|                                    "
echo                         "                                             "
echo                         "      _____            _                     "
echo                         "     /__   \___   ___ | |___   _     _       "
echo                         "       / /\/ _ \ / _ \| / __|_| |_ _| |_     "
echo                         "      / / | (_) | (_) | \__ \_   _|_   _|    "
echo                         "      \/   \___/ \___/|_|___/ |_|   |_|      "
echo                         "                                             "
echo.


endlocal
