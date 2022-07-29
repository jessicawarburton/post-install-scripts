Clear-Host

#
# Set time zone and locale (Local change requires reboot)
#
Set-TimeZone -Id 'AUS Eastern Standard Time'
Set-WinSystemLocale -SystemLocale en-AU
Write-Host "Time Set to Australian Eastern Standard time." -BackgroundColor Black -ForegroundColor Green

#
# Left align taskbar icons 
#
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\" /V "TaskbarAl" /T REG_DWORD /D "0" /F | Out-Null
Write-Host "Taskbar align changed to left-aligned." -BackgroundColor Black -ForegroundColor Green

#
# Disable UAC Prompts
#
Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0
Write-Host "Disabled UAC Prompts" -BackgroundColor Black -ForegroundColor Green

#
# Disable Screen Timeout & Standby
#
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

#
# Unpin Chat, Task view, Widdgets and Search from taskbar
#
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name TaskbarMn -Value 0 -Force
Write-Host "Removed Chat from taskbar." -BackgroundColor Black -ForegroundColor Green
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name TaskbarDa -Value 0 -Force
Write-Host "Removed Widgets from taskbar." -BackgroundColor Black -ForegroundColor Green
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowTaskViewButton -Value 0 -Force
Write-Host "Removed Task View from taskbar." -BackgroundColor Black -ForegroundColor Green
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Search -Name SearchboxTaskbarMode -Value 0 -Force
Write-Host "Removed Search from taskbar." -BackgroundColor Black -ForegroundColor Green


#
# Enable dark mode and set dark wallpaper 
#
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme -Value 0 -Force
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -Value 0 -Force
Write-Host "Enabled dark mode for system and applications" -BackgroundColor Black -ForegroundColor Green

#
# Change Wallpaper (Requires Reboot )
#
Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name WallPaper -Value 'C:\Windows\Web\Wallpaper\Windows\img19.jpg' -Force
Write-Host "Set wallpaper to darkmode appropriate" -BackgroundColor Black -ForegroundColor Green

#
# Restore explorer ribbon 
#
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /V "{e2bf9676-5f8f-435c-97eb-11607a5bedf7}" /T REG_SZ /D "0" /F | Out-Null



#
# Restart Explorer
#
Stop-Process -Name explorer -Force


