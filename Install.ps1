##########CheckUpdate############

Write-Host "`nUpdate OS & Antivirus"
write-host "-------------------------"
try { 
    Install-Module -Name PSWindowsUpdate
    Get-WUInstall -Download -AcceptAll
    Get-WUInstall -Install -AcceptAll
    Update-MpSignature
    }

catch {
    write-Host "Error, restart this in administrator !" -ForegroundColor Red
    exit 0
      }

#######DisableNetDiscover########
Write-Host "`nDisable net discover and Share"
write-host "-------------------------"
#Get-NetFirewallRule -DisplayName 'Découverte du réseau*' |select Name,DisplayName,Enabled,Profile
#Get-NetFirewallRule -DisplayName 'Partage*' |select Name,DisplayName,Enabled,Profile
Get-NetFirewallRule -DisplayGroup 'Découverte du réseau*'|Set-NetFirewallRule -Enabled false -PassThru|select Name,DisplayName,Enabled,Profile|ft -a
Get-NetFirewallRule -DisplayGroup 'Partage*'|Set-NetFirewallRule -Enabled false -PassThru|select Name,DisplayName,Enabled,Profile|ft -a

#####Check LLMNR#####
Write-Host "`nCheck LLMNR is enabled"
write-host "-------------------------"

$LLMNR_reg_exist = [bool] (Get-ItemProperty 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient' | select EnableMulticast)
If ($LLMNR_reg_exist -eq "True")
{ 
    $LLMNR_reg_state = Get-ItemPropertyValue 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient' -Name EnableMulticast
    if ($LLMNR_reg_state -eq "0")
    {
        Write-Host "LLMNR is disabled" -ForegroundColor Green
    }
    else
    {
        Write-Host "LLMNR is enabled" -ForegroundColor Red
        Write-Host "We will disable it"
        REG ADD  “HKLM\Software\policies\Microsoft\Windows NT\DNSClient”
        REG ADD  “HKLM\Software\policies\Microsoft\Windows NT\DNSClient” /v ” EnableMulticast” /t REG_DWORD /d “0” /f
    }
}
Else
{
    Write-Host "LLMNR is enabled" -ForegroundColor Red
    Write-Host "We will disable it"
    REG ADD  “HKLM\Software\policies\Microsoft\Windows NT\DNSClient”
    REG ADD  “HKLM\Software\policies\Microsoft\Windows NT\DNSClient” /v ” EnableMulticast” /t REG_DWORD /d “0” /f
}
Write-Host "-------------------------`n"

####################### SMB #######################
Write-Host "check active SMB Protocols"
write-host "-------------------------"

$smbv1 = Get-SmbServerConfiguration | select EnableSMB1Protocol 
If ($smbv1 = "True"){ 
    Write-Host "SMBv1 is enabled" -ForegroundColor Red
    Write-Host "We Will Disable it"
    Set-SmbServerConfiguration -EnableSMB1Protocol $False
}Else{ 
    Write-Host "SMBv1 is disabled" -ForegroundColor Green 
}

$smbv2 = Get-SmbServerConfiguration | select EnableSMB2Protocol
If ($smbv2 = "True"){ 
    Write-Host "SMBv2 is enabled" -ForegroundColor Green
}Else{ 
    Write-Host "SMBv2 is disabled" -ForegroundColor Red 
}
write-host "-------------------------`n"

##################### Net-BIOS ############################
Write-Host "`ncheck Netbios is enabled"
write-host "-------------------------"

Get-wmiobject -ClassName Win32_NetworkAdapterConfiguration |  where { $_.IPEnabled -eq $true } | select Description,tcpipnetbiosoptions | ForEach-Object{
    If ($_.tcpipnetbiosoptions -ne "2")
    {
        write-Host "$_ NetBios is enabled" -ForegroundColor Red
        Write-Host "we will disable NBT on all interfaces"
        $adapters=(Get-WmiObject win32_networkadapterconfiguration )
        Foreach ($adapter in $adapters)
        {
        $adapter.settcpipnetbios(2)
        }
        Write-Host("----- NetBIOS is now disabled -----") -ForegroundColor Green
    }
    Else
    {
        Write-Host "$_ NetBios is disabled" -ForegroundColor Green
    }
}

