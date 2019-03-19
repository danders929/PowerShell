$serverList = Read-Host "Enter filepath of server list text file (No quotations)"
$Servers    = get-content $serverlist
$objs       = @()

foreach($s in $servers){
    $test = Test-NetConnection -ComputerName $s -CommonTCPPort RDP
    $obj  = New-Object PSObject -Property @{
                'Server'                  = $s
                'RDPEnabled'             = $test.TcpTestSucceeded
    }
        $objs += $obj
}
$objs | ft -AutoSize

$Prompt =[System.Windows.MessageBox]::Show('Would you like to enable RDP on all machines that do not have RDP enabled?',`
                                           'Required Response','YesNo')
if($Prompt -eq "Yes"){
    $Credential = $host.ui.PromptForCredential("Need credentials", "Please enter your user name and password.",`
                  "", "NetBiosUserName")
    foreach($o in $objs){
        if ($o.rdpenabled -like "false"){
            $session = New-PSSession -ComputerName $o.Server -Credential $Credential
            invoke-Command -session $session -scriptblock {Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 0}
            invoke-Command -session $session -scriptblock {Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "UserAuthentication" -Value 1}
            invoke-Command -session $session -scriptblock {Enable-NetFirewallRule -DisplayGroup "Remote Desktop"}
            Remove-PSSession -Session $session
        }
    }
}

exit
