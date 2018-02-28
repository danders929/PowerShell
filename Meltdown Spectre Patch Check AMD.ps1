$computer = Read-Host -Prompt 'Enter Server Name'
$ProcBrand = gwmi win32_processor -ComputerName $Computer | select Name -Unique
$ProcName = $procbrand.name

if ($ProcBrand -like "*AMD*")
    {
    Write-Host "Processor is $procName" 

    if  ((Get-HotFix -Id "KB4056895" -ComputerName $computer -ErrorAction SilentlyContinue))
        {
        Write-host "$computer has 'KB4056895' installed"
        }

    If  ((Get-HotFix -Id "KB4056898" -ComputerName $computer -ErrorAction SilentlyContinue))
        {
        Write-host "$computer has 'KB4056898' installed"
        }
    Else
        {
        Write-host "No patch installed"
        }
    }

Else 
    {
    Write-Host "Processor is $procname"
    }