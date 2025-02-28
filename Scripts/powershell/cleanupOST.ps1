# Get all user profiles in C:\Users
$profilesPath = "C:\Users"
$profiles = Get-ChildItem -Path $profilesPath -Directory

# Define Outlook OST cache location
$ostCacheLocation = "\AppData\Local\Microsoft\Outlook\"

# Log deleted files
$logFile = "C:\Outlook_OST_Cleanup.log"
"Outlook .OST Cache Cleanup Log - $(Get-Date)" | Out-File -FilePath $logFile -Encoding UTF8 -Force

# Loop through each user profile
foreach ($profile in $profiles) {
    $userProfilePath = $profile.FullName
    $fullPath = $userProfilePath + $ostCacheLocation

    if (Test-Path $fullPath) {
        # Find only .ost files
        $ostFiles = Get-ChildItem -Path $fullPath -Recurse -Force -ErrorAction SilentlyContinue |
        Where-Object { $_.Extension -eq ".ost" }

        foreach ($file in $ostFiles) {
            $fileSizeGB = [math]::Round($file.Length / 1GB, 4)
            $fileSizeMB = [math]::Round($file.Length / 1MB, 2)

            # Show file details
            Write-Host "`nUser: $($profile.Name)"
            Write-Host "File: $($file.FullName)"
            Write-Host "Size: $fileSizeMB MB ($fileSizeGB GB)"
            
            # Ask for confirmation
            $confirmation = Read-Host "Do you want to delete this file? (Y/N)"
            if ($confirmation -eq "Y" -or $confirmation -eq "y") {
                Remove-Item -Path $file.FullName -Force -ErrorAction SilentlyContinue
                Write-Host "Deleted: $($file.FullName)" -ForegroundColor Green
                "Deleted: $($file.FullName)" | Out-File -FilePath $logFile -Append
            }
            else {
                Write-Host "Skipped: $($file.FullName)" -ForegroundColor Yellow
            }
        }
    }
}

Write-Host "`nCleanup complete. Check log: $logFile"
