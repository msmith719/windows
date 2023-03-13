<#
.SYNOPSIS
Checks to see if a password has been pwned.
.DESCRIPTION
Enter a password. Module uses k-Anonymity model (allows a password to be searched for by partial hash) to search for the entered password in the haveibeenpwned.com password list.
.PARAMETER pass
The password to be checked for pwnage. Should be a System.Security.SecureString.
.INPUTS
System.Security.SecureString
.OUTPUTS
Boolean
.EXAMPLE
Invoke-PasswordPwnCheck (Read-Host -AsSecureString "Enter Password")
.NOTES
Author: msmith719

Possible Improvements: 
1) 
#>

function Invoke-PasswordPwnCheck {
    param (
        [Parameter(Mandatory=$true)][System.Security.SecureString]$pass
    )
    
    Function ConvertFrom-SecureString-AsPlainText{
        [CmdletBinding()]
        param (
            [Parameter(
                Mandatory = $true,
                ValueFromPipeline = $true
            )]
            [System.Security.SecureString]
            $SecureString
        )
        $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString);
        $PlainTextString = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr);
        $PlainTextString;
    }

    #$pass = Read-Host -AsSecureString "Enter Password"

    function Get-Sha1Hash {
        param (
            [Parameter(Mandatory=$true)]$string
        )

        $stringAsStream = [System.IO.MemoryStream]::new()
        $writer = [System.IO.StreamWriter]::new($stringAsStream)
        $writer.write((ConvertFrom-SecureString-AsPlainText $string))
        $writer.Flush()
        $stringAsStream.Position = 0
        (Get-FileHash -Algorithm SHA1 -InputStream $stringAsStream).Hash        
    }

    $hashedValue = Get-Sha1Hash $pass

    $firstFive = $hashedValue.SubString(0,5)
    $lastPart = $hashedValue.Substring(5,($hashedValue.Length-5))

    $results = (Invoke-WebRequest -Method Get https://api.pwnedpasswords.com/range/$firstFive).Content

    $results.Contains("$lastPart")
}