<#
.SYNOPSIS
Basic sysprep menu
.DESCRIPTION
Basic menu script with options for running Sysprep. Great to use to make a VM Template or machine image. It also does a little setup and clean up.
.INPUTS
None
.OUTPUTS
None
.EXAMPLE
Run-Sysprep
.NOTES
Author: msmith719

Possible Improvements: 
1) Rename script to use and approved verb. Possible name: Invoke-Sysprep.
2) Add code to enable Remote Desktop
#>

function Invoke-CleanUp {
    Write-Host "Clearing the Quick Access History..."
    echo "y" > cmd.exe /c del /f /s /q /a "%AppData%\Microsoft\Windows\Recent\AutomaticDestinations\f01b4d95cf55d32a.automaticDestinations-ms"

    Write-Host "Clearing recent places and items..."
    echo "y" > Remove-Item "$AppDataPath\Microsoft\Windows\Recent\*" -Force

    Write-Host "Clearing the Recycle Bin..."
    echo "y" > Clear-RecycleBin

    $username = $env:UserName
    if (Test-Path "C:\Users\$username\Desktop\Run-Sysprep.ps1 - Shortcut.lnk") {
        Write-Host "Removing Sysprep script shortcut from desktop..."
        echo "y" > Remove-Item "C:\Users\$username\Desktop\Run-Sysprep.ps1 - Shortcut.lnk" -Force
    }  
}

Write-Host "Welcome. We are about to run Sysprep and get the template ready." 

Write-Host "Setting Timezone..." 
Set-TimeZone -name "Eastern Standard Time" # To see timezones, use command Get-TimeZone -ListAvailable

Write-Host "Be sure to enable Remote Desktop..." -ForegroundColor Yellow; Pause
<#
# Will need to work on fixing this
Write-Host "Enabling Remote Desktop..." 
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -value 0
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
#>

Write-Host "We are about to run Sysprep..." -ForegroundColor Green
Write-Host @"

Please select an option:
1) Run Sysprep to skip OOBE, then Shutdown.
2) Run Sysprep to skip OOBE, then Reboot.
3) Run Sysprep with OOBE, then Shutdown.
4) Run Sysprep with OOBE, then Reboot.
5) CANCEL

"@

$option = Read-Host -Prompt "Please select an option"

$AppDataPath = $env:APPDATA

$sysprepDirectory = "C:\SysPrep"

if (!(Test-Path $sysprepDirectory))
{
    New-Item -ItemType Directory -Path $sysprepDirectory
    Write-Host "Directory '$sysprepDirectory' created."
}
else
{
    Write-Host "Directory '$sysprepDirectory' already exists."
}

$deploy = @"
<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend">
    <settings pass="oobeSystem">
        <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <OOBE>
                <HideEULAPage>true</HideEULAPage>
                <HideLocalAccountScreen>true</HideLocalAccountScreen>
                <HideOEMRegistrationScreen>true</HideOEMRegistrationScreen>
                <HideOnlineAccountScreens>true</HideOnlineAccountScreens>
                <HideWirelessSetupInOOBE>true</HideWirelessSetupInOOBE>
                <NetworkLocation>Home</NetworkLocation>
                <ProtectYourPC>3</ProtectYourPC>
                <SkipMachineOOBE>true</SkipMachineOOBE>
                <SkipUserOOBE>true</SkipUserOOBE>
                <UnattendEnableRetailDemo>false</UnattendEnableRetailDemo>
            </OOBE>
        </component>
    </settings>
</unattend>
"@

$deploy | Out-File $sysprepDirectory\deploy.xml

Switch ($option) {
    1 {
        Invoke-CleanUp
        Write-Host "Running Sysprep to skip OOBE, then Shutting down."
        $sysprepCommand = "C:\Windows\System32\Sysprep\sysprep.exe /oobe /generalize /unattend:$sysprepDirectory\deploy.xml /shutdown"
        }
    2 {
        Invoke-CleanUp
        Write-Host "Running Sysprep to skip OOBE, then Rebooting."
        $sysprepCommand = "C:\Windows\System32\Sysprep\sysprep.exe /oobe /generalize /unattend:$sysprepDirectory\deploy.xml /reboot"
        }
    3 {
        Write-Host "Running Sysprep with OOBE, then Shutting down."
        $sysprepCommand = "C:\Windows\System32\Sysprep\sysprep.exe /oobe /generalize /shutdown"
        }
    4 {
        Write-Host "Running Sysprep with OOBE, then Rebooting."
        $sysprepCommand = "C:\Windows\System32\Sysprep\sysprep.exe /oobe /generalize /reboot"
        }
    5 {exit}
}

Invoke-Expression $sysprepCommand