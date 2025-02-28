@echo off
color 0A

REM Prompt user for action
echo Select an action:
echo 1. Backup
echo 2. Restore
set /p "choice=Enter your choice (1 or 2): "

if "%choice%"=="1" goto BACKUP
if "%choice%"=="2" goto RESTORE
echo Invalid choice. Exiting.
pause
exit /b

:BACKUP
REM Set default destination directory assuming D: as the external drive letter
set "destination=D:\Backups\%USERNAME%"

REM Ensure destination directory exists or prompt for drive letter
:CHECK_DESTINATION
if not exist "%destination%\" (
    echo Destination directory not found. Please insert your external drive and enter the drive letter (e.g., D:)
    set /p "drive_letter=Enter drive letter: "
    set "destination=%drive_letter%:\Backups\%USERNAME%"
    mkdir "%destination%" 2>nul
    if not exist "%destination%\" (
        echo Failed to create or locate destination directory. Exiting script.
        pause
        exit /b 1
    )
)

echo Backing up data...

REM Define source paths to backup
set "sourceAppData=%USERPROFILE%\AppData"
set "sourceDesktop=%USERPROFILE%\Desktop"
set "sourceDocuments=%USERPROFILE%\Documents"
set "sourceDownloads=%USERPROFILE%\Downloads"
set "sourceFavorites=%USERPROFILE%\Favorites"
set "sourcePictures=%USERPROFILE%\Pictures"
set "sourceVideos=%USERPROFILE%\Videos"

REM Backing up using robocopy 
robocopy "%sourceAppData%\Local\Google\Chrome\User Data\Default" "%destination%\AppData\Local\Google" "Bookmarks" /Z /COPY:DAT /R:3 /W:5 /LOG+:"%destination%\backup.log" /TEE
robocopy "%sourceAppData%\Local\Google\Chrome\User Data\Default" "%destination%\AppData\Local\Google" "Bookmarks.bak" /Z /COPY:DAT /R:3 /W:5 /LOG+:"%destination%\backup.log" /TEE
robocopy "%sourceAppData%\Local\Microsoft\Edge\User Data\Default" "%destination%\AppData\Local\Edge" "Bookmarks" /Z /COPY:DAT /R:3 /W:5 /LOG+:"%destination%\backup.log" /TEE
robocopy "%sourceAppData%\Local\Microsoft\Edge\User Data\Default" "%destination%\AppData\Local\Edge" "Bookmarks.bak" /Z /COPY:DAT /R:3 /W:5 /LOG+:"%destination%\backup.log" /TEE
robocopy "%sourceAppData%\Roaming\Microsoft\Signatures" "%destination%\AppData\Roaming\Microsoft\Signatures" /S /Z /COPY:DAT /R:3 /W:5 /LOG+:"%destination%\backup.log" /TEE
robocopy "%sourceDesktop%" "%destination%\Desktop" /S /Z /COPY:DAT /DCOPY:T /R:3 /W:5 /LOG+:"%destination%\backup.log" /TEE
robocopy "%sourceDocuments%" "%destination%\Documents" /S /Z /COPY:DAT /DCOPY:T /R:3 /W:5 /LOG+:"%destination%\backup.log" /TEE
robocopy "%sourcePictures%" "%destination%\Pictures" /S /Z /COPY:DAT /DCOPY:T /R:3 /W:5 /LOG+:"%destination%\backup.log" /TEE

timeout /t 10
cls
echo Backup Completed!
pause
exit /b

:RESTORE
REM Set destination directory and adjust the external drive letter (replace D: with your external drive letter)
set "destination=D:\Backups\%USERNAME%"

REM Check if destination directory creation was successful
if not exist "%destination%\" (
    echo Destination directory not found. Please insert your external drive and enter the drive letter (e.g., D:)
    set /p "drive_letter=Enter drive letter: "
    set "destination=%drive_letter%:\Backups\%USERNAME%"
    mkdir "%destination%" 2>nul
    if not exist "%destination%\" (
        echo Failed to create or locate destination directory. Exiting script.
        pause
        exit /b 1
    )
)

echo Restoring data...

REM Define source paths to restore
set "sourcePaths=AppData\Local\Google\Chrome\User Data\Default\Bookmarks"
set "sourcePaths=%sourcePaths% AppData\Local\Google\Chrome\User Data\Default\Bookmarks.bak"
set "sourcePaths=%sourcePaths% AppData\Local\Microsoft\Edge\User Data\Default\Bookmarks"
set "sourcePaths=%sourcePaths% AppData\Local\Microsoft\Edge\User Data\Default\Bookmarks.bak"
set "sourcePaths=%sourcePaths% Desktop"
set "sourcePaths=%sourcePaths% Documents"
set "sourcePaths=%sourcePaths% Pictures"

REM Loop through each source path and restore using robocopy
for %%i in (%sourcePaths%) do (
    robocopy "%destination%\%%i" "%USERPROFILE%\%%~pnxi" /S /Z /COPY:DAT /DCOPY:T /R:3 /W:5 /LOG+:"%destination%\restore.log" /TEE
)

timeout /t 10
cls
echo Restore Completed!
pause
exit /b
