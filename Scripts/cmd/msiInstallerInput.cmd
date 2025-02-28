@echo off
set /p pathOrFileName="Enter the full path or file name of the MSI file you would like to install: "

if exist "%pathOrFileName%" (
    msiexec.exe /i "%pathOrFileName%" /qb
) else (
    echo The path or file "%pathOrFileName%" was not found. Please check that the path is correct or file is in the current directory.
    pause
)
