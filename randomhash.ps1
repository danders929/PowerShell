$hash = @{}
For ($i=10; $i -gt 0; $i--) {
    $random = Get-Random -Minimum 1 -maximum 256
        while($hash.ContainsValue($random)){
            $random = Get-Random -Minimum 1 -maximum 10
            }
    $hash.add($i,$random)
}
$randomkey = Get-Random -Minimum 1 -maximum 11
$RandomNumber = $hash[$randomkey]
pause
"Your lucky number is $randomNumber"
