@echo off
color 0A

set /p computername="Enter target identifier: "
if "%computername"=="" (
    echo Computer name cannot be empty.
    exit /b 1
)

psexec \\%computername% cmd
exit /b 0