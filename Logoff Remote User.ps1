CLS
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
If (!$user){"`nCould not find user.`n"
}
    Else {
            #Gets SAMAccount name from query, 
            $SamAccount = $user.SamAccountName
            $sessionID = (quser /server:$server | Where-Object { $_ -match $SamAccount })[1] 
            If(!$sessionID){"`n$User is not logged into this server`n"
            }
                Else {
            "`n`n*********************************"
            "`nLogging off user from $server`n"
            "UserAccount: $SamAccount"
            "Session ID Number: $sessionid`n"
            "*********************************`n"
            write-host -nonewline "Do you wish to continue? (Y/N) "
            $response = read-host
            if ( $response -ne "Y" ) { exit }
            
            }}