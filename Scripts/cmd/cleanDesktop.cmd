@echo off

REM Check if the script is running with admin rights
NET SESSION >NUL 2>NUL
if %ERRORLEVEL% EQU 0 (
    REM Script is already running with admin rights
    goto :main
) else (
    REM Relaunch the script with admin rights
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\run.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\run.vbs"
    "%temp%\run.vbs"
    del "%temp%\run.vbs"
    exit /B
)

:main
setlocal enabledelayedexpansion

REM Set the path to the Public Desktop folder
set "desktopPath=%PUBLIC%\Desktop"

REM Loop through all files in the Public Desktop folder
for %%G in ("%desktopPath%\*.*") do (
    REM Check if the file is a shortcut
    if %%~xG==.lnk (
        REM Remove the shortcut file
        del "%%G" /f /q
    )
)

REM End of the script
echo All app shortcuts have been removed from the Public Desktop.
pause
