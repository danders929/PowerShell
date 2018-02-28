$ComputerName = Read-Host -Prompt "Enter Computer Name."
$ComputerName = $ComputerName.toupper()

"***************`n"

do {
    (write-host "Testing Connection to $ComputerName.")
    }
Until (test-connection $ComputerName -Quiet)

         Write-host "$ComputerName is now online." -ForegroundColor Green
         
         $sound= new-Object System.media.soundplayer;
         $sound.Soundlocation ="C:\windows\media\chimes.wav";
         $sound.Play();
         $wshell = New-Object -ComObject wscript.shell;
         $wshellReturn = $wshell.popup("$ComputerName is now online.",0,"Complete",0x0);


            

         
"`n***************"
