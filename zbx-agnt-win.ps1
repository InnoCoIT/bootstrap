$installPath = "C:\InnoCoIT"
$dnName = "zbx-agnt.zip"

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }


# create directory
if (!(Test-Path -Path $installPath))
{
    {Write-Host "Creating Installation Directory"}
    New-Item $installPath -ItemType Directory
}

# os ver checking
if ([System.IntPtr]::Size -eq 4)
{
    bitsadmin.exe /transfer "InnoCoIT" https://www.zabbix.com/downloads/5.0.1/zabbix_agent-5.0.1-windows-i386-openssl.zip "$installPath\$dnName"
}
else {
    bitsadmin.exe /transfer "InnoCoIT"  https://www.zabbix.com/downloads/5.0.1/zabbix_agent-5.0.1-windows-i386-openssl.zip  "$installPath\$dnName"
}

#extract downloaded file
{Write-Host "Extracting zip file"}
$shellApplication = new-object -com shell.application
$zipPackage = $shellApplication.NameSpace("$installPath\$dnName")
$destinationFolder = $shellApplication.NameSpace($installPath)
$destinationFolder.CopyHere($zipPackage.Items())

#configuraiton
$proxyIp = Read-host -Prompt  "Proxy Server IP :" 
$hostname = Read-host -Prompt "Hostname :" 
$server = "Server=$proxyIp"
$serverActive = "ServerActive=$proxyIp"
$hostname = "Hostname=$hostname"
$log = "LogFile=$installPath\zabbix_agent.log"

Write-Host "$server"
$config = Get-Content -path "$installPath\conf\zabbix_agentd.conf" -Raw
$config = $config -replace 'LogFile=c:\\zabbix_agentd.log',$log 
$config = $config -replace '# LogFileSize=1','LogFileSize=10'
$config = $config -replace '# EnableRemoteCommands=0','EnableRemoteCommands=1'
$config = $config -replace ('Server=127.0.0.1',$server)
$config = $config -replace ('ServerActive=127.0.0.1',$serverActive)
$config = $config -replace ('Hostname=Windows host',$hostname)
$config = $config -replace '# HostMetadataItem=','HostMetadataItem=system.uname'
$config | Set-Content -Path "$installPath\conf\zabbix_agentd.conf" 
#Get-Content -Path "$installPath\conf\zabbix_agentd.conf" 

#Firewall
New-NetFirewallRule -RemoteAddress $proxyIp -DisplayName "ProxyServer" -Direction inbound -Profile Any -Action Allow  -Protocol TCP -LocalPort 10050

#enable svc
Start-Process -FilePath "$installPath\bin\zabbix_agentd.exe" -ArgumentList "-c $installPath\conf\zabbix_agentd.conf -i" -NoNewWindow
Start-Sleep -Seconds 2
Start-Process -FilePath "$installPath\bin\zabbix_agentd.exe" -ArgumentList "-c $installPath\conf\zabbix_agentd.conf -s" -NoNewWindow

{Write-Host "Agent installed"}
Start-Sleep -Seconds 3
#[Environment]::Exit(0)
