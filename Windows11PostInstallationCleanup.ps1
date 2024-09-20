Clear-Host

# Set time zone and locale (Local change requires reboot)
Set-TimeZone -Id 'AUS Eastern Standard Time'
Set-WinSystemLocale -SystemLocale en-AU
Write-Host "Time Set to Australian Eastern Standard time." -BackgroundColor Black -ForegroundColor Green

# Left align taskbar icons 
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\" /V "TaskbarAl" /T REG_DWORD /D "0" /F | Out-Null
Write-Host "Taskbar align changed to left-aligned." -BackgroundColor Black -ForegroundColor Green

# Disable UAC Prompts
Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0
Write-Host "Disabled UAC Prompts" -BackgroundColor Black -ForegroundColor Green

# Disable Screen Timeout & Standby
powercfg -change -monitor-timeout-ac 0
powercfg -Change -standby-timeout-ac 0
powercfg -Change -standby-timeout-dc 0
Write-Host "Disabled screen timeout & standby." -BackgroundColor Black -ForegroundColor Green

# Launch Explorer to This PC
$sipParams = @{
    Path  = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
    Name  = 'LaunchTo'
    Value = 1 
  }
  Set-ItemProperty @sipParams
  Write-Host "Set explorer.exe to launch to 'This PC'" -BackgroundColor Black -ForegroundColor Green

#Unpin applications from taskbar
function Unpin-App([string]$appname) {
    ((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() |
        ?{$_.Name -eq $appname}).Verbs() | ?{$_.Name.replace('&','') -match 'Unpin from taskbar'} | %{$_.DoIt()}
}
Unpin-App("Microsoft Edge")
Write-Host "Unpinned Microsoft Edge from taskbar" -BackgroundColor Black -ForegroundColor Green
Unpin-App("Microsoft Store") 
Write-Host "Unpinned Microsoft Store from taskbar" -BackgroundColor Black -ForegroundColor Green
Unpin-App("Mail") 
Write-Host "Unpinned Mail from taskbar" -BackgroundColor Black -ForegroundColor Green

# Unpin Chat, Task view, Widdgets and Search from taskbar
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name TaskbarMn -Value 0 -Force
Write-Host "Removed Chat from taskbar." -BackgroundColor Black -ForegroundColor Green
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name TaskbarDa -Value 0 -Force
Write-Host "Removed Widgets from taskbar." -BackgroundColor Black -ForegroundColor Green
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowTaskViewButton -Value 0 -Force
Write-Host "Removed Task View from taskbar." -BackgroundColor Black -ForegroundColor Green
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Search -Name SearchboxTaskbarMode -Value 0 -Force
Write-Host "Removed Search from taskbar." -BackgroundColor Black -ForegroundColor Green

# Enable dark mode and set dark wallpaper 
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme -Value 0 -Force
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -Value 0 -Force
Write-Host "Enabled dark mode for system and applications" -BackgroundColor Black -ForegroundColor Green

# Change Wallpaper
Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name WallPaper -Value 'C:\Windows\Web\Wallpaper\Windows\img19.jpg' -Force
Write-Host "Set wallpaper to darkmode appropriate" -BackgroundColor Black -ForegroundColor Green

# Restore explorer ribbon 
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /V "{e2bf9676-5f8f-435c-97eb-11607a5bedf7}" /T REG_SZ /D "0" /F | Out-Null

# Restore right click context menu 
reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve

# Kill OneDrive process
taskkill /f /im OneDrive.exe

# Uninstall OneDrive
%SystemRoot%\System32\OneDriveSetup.exe /uninstall 2>nul

# Remove OneDrive leftovers
Remove-Item "%UserProfile%\OneDrive" /q /s
Remove-Item "%LocalAppData%\Microsoft\OneDrive" /q /s
Remove-Item "%ProgramData%\Microsoft OneDrive" /q /s
Remove-Item "%SystemDrive%\OneDriveTemp" /q /s


# Delete OneDrive shortcuts
Remove-Item "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Microsoft OneDrive.lnk" /s /f /q
Remove-Item "%APPDATA%\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk" /s /f /q
Remove-Item "%USERPROFILE%\Links\OneDrive.lnk" /s /f /q


# Disable usage of OneDrive
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /t REG_DWORD /v "DisableFileSyncNGSC" /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /t REG_DWORD /v "DisableFileSync" /d 1 /f


# Prevent automatic OneDrive install for current user
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "OneDriveSetup" /f


# Prevent automatic OneDrive install for new users
reg load "HKU\Default" "%SystemDrive%\Users\Default\NTUSER.DAT" 
reg delete "HKU\Default\software\Microsoft\Windows\CurrentVersion\Run" /v "OneDriveSetup" /f
reg unload "HKU\Default"


# Remove OneDrive from explorer menu
reg delete "HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f
reg delete "HKCR\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f
reg add "HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v System.IsPinnedToNameSpaceTree /d "0" /t REG_DWORD /f
reg add "HKCR\Wow6432Node\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v System.IsPinnedToNameSpaceTree /d "0" /t REG_DWORD /f

# Delete OneDrive path from registry
reg delete "HKCU\Environment" /v "OneDrive" /f

#
# Don't show recently used files in quick access 
#
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowRecent" /d 0 /t "REG_DWORD" /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HomeFolderDesktop\NameSpace\DelegateFolders\{3134ef9c-6b18-4996-ad04-ed5912e00eb5}" /f

#
# Don't keep history of recently opened documents
#
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRecentDocsHistory" /t REG_DWORD /d 1 /f

# Remove Windows bloatware
Get-AppxPackage 'Microsoft.549981C3F5F10' | Remove-AppxPackage
Get-AppxPackage 'Microsoft.XboxIdentityProvider' | Remove-AppxPackage
Get-AppxPackage 'Microsoft.XboxIdentityProvider' | Remove-AppxPackage
Get-AppxPackage 'Microsoft.XboxIdentityProvider' | Remove-AppxPackage
Get-AppxPackage 'Microsoft.OneDriveSync' | Remove-AppxPackage
Get-AppxPackage 'Microsoft.XboxGamingOverlay' | Remove-AppxPackage
Get-AppxPackage 'Microsoft.WindowsAlarms' | Remove-AppxPackage
Get-AppxPackage 'Microsoft.ZuneVideo' | Remove-AppxPackage
Get-AppxPackage 'Microsoft.ZuneMusic' | Remove-AppxPackage
Get-AppxPackage 'Microsoft.YourPhone' | Remove-AppxPackage
Get-AppxPackage 'Microsoft.XboxSpeechToTextOverlay' | Remove-AppxPackage
Get-AppxPackage 'Microsoft.Xbox.TCUI' | Remove-AppxPackage
Get-AppxPackage 'Microsoft.WindowsSoundRecorder' | Remove-AppxPackage
Get-AppxPackage 'Microsoft.WindowsMaps' | Remove-AppxPackage
Get-AppxPackage 'Microsoft.WindowsFeedbackHub' | Remove-AppxPackage
Get-AppxPackage 'Microsoft.Todos' | Remove-AppxPackage
Get-AppxPackage 'Microsoft.PowerAutomateDesktop' | Remove-AppxPackage
Get-AppxPackage 'Microsoft.People' | Remove-AppxPackage
Get-AppxPackage 'Microsoft.MicrosoftStickyNotes' | Remove-AppxPackage
Get-AppxPackage 'Microsoft.MicrosoftSolitaireCollection' | Remove-AppxPackage
Get-AppxPackage 'Microsoft.MicrosoftOfficeHub' | Remove-AppxPackage
Get-AppxPackage 'Microsoft.GetHelp' | Remove-AppxPackage
Get-AppxPackage 'Microsoft.BingWeather' | Remove-AppxPackage
Get-AppxPackage 'Microsoft.BingNews' | Remove-AppxPackage
Get-AppxPackage 'Microsoft.XboxGameOverlay' | Remove-AppxPackage
Get-AppxPackage 'MicrosoftTeams' | Remove-AppxPackage
Get-AppxPackage 'Microsoft.Windows.Photos' | Remove-AppxPackage
Get-AppxPackage 'Microsoft.GamingApp'| Remove-AppxPackage

# Restart Explorer
Stop-Process -Name explorer -Force


