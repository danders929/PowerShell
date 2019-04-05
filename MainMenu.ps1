function Show-Menu{
$Credential = get-credential
######################Main Menu####################

        [string]$Title = 'Main Menu'
    
    Clear-Host
    Write-Host "================ $Title ================"
    
    Write-Host "1: Notify When Server is Online"
    Write-Host "2: Remotely Kill Session"
    Write-Host "3: Server info"
    Write-Host "Q: Press 'Q' to quit."
    }

do
    {
     Show-Menu
     $selection = Read-Host "`nPlease make a selection"
     switch ($selection)
     {

######################Online Notify###################

        '1' 
         {
            $ComputerName = Read-Host -Prompt "Enter Computer Name."
            $ComputerName = $ComputerName.toupper()
            Try
            {
                $testConnect  = [System.Net.DNS]::GetHostByName($computerName)
                $test = $true
                }

            Catch
            {
                write-host -ForegroundColor red " Could not Resolve $computername, please check the spelling and try again."
                pause
                $test = $false
                }

            If ($test -eq $false)
            {
                show-menu
                }

             Else
             {
                do 
                {
                "***************`n"
                $AddressList = $testConnect.AddressList
                
                (write-host "Testing Connection to $ComputerName $AddressList.")
                }

                Until (test-connection $ComputerName -Quiet)

                Write-host "$ComputerName is now online." -ForegroundColor Green
         
                $sound= new-Object System.media.soundplayer;
                $sound.Soundlocation ="C:\windows\media\chimes.wav";
                $sound.Play();
                $wshell = New-Object -ComObject wscript.shell;
                $wshellReturn = $wshell.popup("$ComputerName is now online.",0,"Complete",0x0);
                }
}
######################Remote Kill#####################
                
         '2' 
         {
                Import-module ActiveDirectory

                Write-Host '*************************'
                Write-Host '* Log Off User Remotely *'
                Write-Host '*************************'"`n"
                #Prompts for admin credentials.
                $global:adminCreds = $host.ui.PromptForCredential("Need credentials", "Please enter your DOMAIN\USERNAME and password.", "", "")


                #Prompts user input for the server customers first and last name.
                $server = Read-Host -Prompt "Enter Server Name"
                $fName = Read-Host -Prompt "Enter First Name"
                $lName = Read-Host -Prompt "Enter last name"

                #Concantenates the Last and First name as such "First, Last", and then query's active directory.
                $fullName = "$lname, $fName"
                $user = get-adUser -Filter "Name -like '$fullName'"

                #Tests if query failed, if not then continues to terminate session 
                If (!$user)
                {
                    "`nCould not find user.`n"
                }
                Else 
                {
                    #Gets SAMAccount name from query, 
                    $SamAccount = $user.SamAccountName
                    $sessionID = (quser /server:$server | Where-Object { $_ -match $SamAccount })[3]
                    If(!$sessionID)
                    {
                        "`n$User is not logged into this server`n"
                     }

                    Else 
                    {
                        "`n`n*********************************"
                        "`nLogging off user from $server`n"
                        "UserAccount: $SamAccount"
                        "Session ID Number: $sessionid`n"
                        "*********************************`n"
                        write-host -nonewline "Do you wish to continue? (Y/N) "
                        $response = read-host
                        if ( $response -ne "Y" ) { exit }
                     }          
                 }
             }  
###################### Server Info #####################
         '3' 
         {
                
$computer = Read-Host "Enter Computer Name"
Write-Verbose "Checking $Computer"
            try {
                # Check to see if $Computer resolves DNS lookup successfuly.
                $null = [System.Net.DNS]::GetHostEntry($Computer)
                
                $ComputerSystemInfo = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $Computer -ErrorAction Stop -Credential $Credential
                
                switch ($ComputerSystemInfo.Model) {
                    
                # Check for Hyper-V Machine Type
                    "Virtual Machine" {
                        $MachineType="VM"
                        }

                # Check for VMware Machine Type
                    "VMware Virtual Platform" {
                        $MachineType="VM"
                        }

                # Check for Oracle VM Machine Type
                    "VirtualBox" {
                        $MachineType="VM"
                        }

                # Check for Xen
                    "HVM domU" {
                        $MachineType="VM"
                        }

                # Check for KVM
                # I need the values for the Model for which to check.

                # Otherwise it is a physical Box
                    default {
                        $MachineType="Physical"
                        }
                    }
                
                # Building MachineTypeInfo Object
                $MachineTypeInfo = New-Object -TypeName PSObject -Property ([ordered]@{
                    ComputerName=$ComputerSystemInfo.PSComputername
                    Type=$MachineType
                    Manufacturer=$ComputerSystemInfo.Manufacturer
                    Model=$ComputerSystemInfo.Model
                    })
                $MachineTypeInfo
                }
            catch [Exception] {
                Write-Output "$Computer`: $($_.Exception.Message)"
                }
 }
    }
}
until ($selection -eq 'q')
