<#
.SYNOPSIS
Password/passphrase generator
.DESCRIPTION
Generates a passphrase that memomerable. Has option to have a space as a separator or a special character. You can increase the length and complexity as well. The generated passphrase is copied to your clipboard so that you can use it right way. Please note, some of the passphrases that are generated may be concidered NSFW and/or offesnsive.
.PARAMETER NoSpaces
Use a random special character as a separator instead of a space.
.PARAMETER Secure
Increases the length and complexity of the password/passphrase.
.PARAMETER TestLocal
Simulate the output when the required json file cannot be accessed. Uses words from the $wordList array instead of from the json file.
.INPUTS
None
.OUTPUTS
String
.EXAMPLE
Invoke-PasswordGen
A password has been generated for you:

soap CHAIN constant 7

This password has been copied to the clipboard.
.EXAMPLE
Invoke-PasswordGen -NoSpaces
A password has been generated for you:

LOAT-penny-FLU-4

This password has been copied to the clipboard.
.EXAMPLE
Invoke-PasswordGen -Secure
A SECURE password has been generated:

rumor1@solo7=choke5!pupil9-MARSH4#SLAP2$

This password has been copied to the clipboard.
.NOTES
Author: msmith719

Planned Improvements: Cache the json file instead of downloading it each time.
#>

function Invoke-PasswordGen {
    param (
        [Parameter(Mandatory=$false)] [Switch]$NoSpaces,
        [Parameter(Mandatory=$false)] [Switch]$Secure,
        [Parameter(Mandatory=$false)] [Switch]$TestLocal
    )

    $url = "https://randomwordgenerator.com/json/words_ws.json"
    
    # First we create the request.
    $HTTP_Request = [System.Net.WebRequest]::Create($url)

    # We then get a response from the site.
    $HTTP_Response = $HTTP_Request.GetResponse()

    # We then get the HTTP code as an integer.
    if ( !$TestLocal) {
        $HTTP_Status = [int]$HTTP_Response.StatusCode
    } else {
        $HTTP_Status = 404
        Write-Host "HELLO! This is an EXAMPLE of an error that would be shown if the JSON file could not be reached." -ForegroundColor Magenta
        Write-Host @"
Exception calling "GetResponse" with "0" argument(s): "The remote server returned an error: (404) Not Found."
At line:13 char:5                                                                                                                                                                                    +     $HTTP_Response = $HTTP_Request.GetResponse()                                                                                                                                                   +     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                                                                                                                                                       + CategoryInfo          : NotSpecified: (:) [], MethodInvocationException                                                                                                                        
    + FullyQualifiedErrorId : WebException
"@ -ForegroundColor Red
    }

    If ($HTTP_Status -eq 200) {
        $json = (New-Object System.Net.WebClient).DownloadString($url)
        $data = $json | ConvertFrom-Json
        
        $words = Get-Random -InputObject ($data.data.word | ?{$_.numSyllables -lt 3}).value -Count 10
    }
    Else {
        $wordList = @("bless","aloof","fight","scene","movie","month","entry","bland","leave","story","spite","study","flush","agony","reign",`
            "dance","bible","theft","cheat","table","refer","begin","style","deter","harsh","yearn","shave","sting","shark","still","right",`
            "blade","fence","dairy","groan","brush","issue","other","quota","pluck","prove","plane","ghost","shaft","learn","greet","value",`
            "trait","mercy","plant","tired","crash","level","peace","glove","owner","orbit","water","toast","cater","salon","grand","rumor",`
            "truck","berry","guilt","fibre","beard","decay","front","layer","flock","pilot","smash","snarl","force","class","glass","grant",`
            "watch","knock","start","brown","shout","guess","brick","cable","organ","loose","snail","store","fresh","frame","giant","stool",`
            "drain","tiger","heavy","favor","trunk","waste","blind","color","court","reach","judge","faith","print","blast","linen","wreck",`
            "stick","tract","knife","young","green","quiet","eject","prize","bunny","throw","thick","stamp","party","onion","sweat","drink",`
            "storm","dough","arena","drive","chalk","slump","block","rally","train","sword","power","wheel","voter","title","steak","miner",`
            "marsh","great","spare","write","salad","union","angle","shock","rabbit","split","arrow","draft","sharp","scale","share","carve",`
            "truth","elect","cross","chord","smile","scrap","angel","feast","slide","spine","score","burst","doubt","carry","blame","forge",`
            "think","spoil","wound","light","shelf","grind","embox","proof","kneel","screw","tense","build","honor","fault","guide","virus",`
            "stand","piece","worry","climb","weave","jewel","thigh","offer","tight","dream","proud","sniff","outer","irony","tasty","blank",`
            "flesh","motif","radio","clerk","crowd","ridge","turtle")
            Write-Host "*******************" -ForegroundColor Magenta
            Write-Host "*******************" -ForegroundColor Magenta
            Write-Host ""
            Write-Host "The normal word list JSON file could not be reached. This password will be created Using the backup word list." -ForegroundColor Magenta
            write-host  "FYI, this word list is limited to" $wordList.Count "words." -ForegroundColor Magenta
            Write-Host ""
            Write-Host "*******************" -ForegroundColor Magenta
            Write-Host "*******************" -ForegroundColor Magenta
            $words = Get-Random -InputObject $wordList -Count 10
    }

    # Finally, we clean up the http request by closing it.
    If ($HTTP_Response -eq $null) { } 
    Else { $HTTP_Response.Close() }
    $HTTP_Status = $null
    $HTTP_Response = $null  

    $specialChars = '!@#$%&*-+=:?'.ToCharArray()
    $seperators = '+-='.ToCharArray()
    $numbers = '123456789'.ToCharArray()

    if ( !$Secure ) {
        if ( !$NoSpaces ) {
            $options = @(
                $words[0].ToUpper() + " " + $words[1] + " " + $words[2].ToUpper() + " " + (Get-Random -InputObject $numbers)
                $words[0] + " " + $words[1].ToUpper() + " " + $words[2] + " " + (Get-Random -InputObject $numbers)
            )
            $password = Get-Random -InputObject $options
        } else {
            $sep = (Get-Random -InputObject $seperators)
            $options = @(
                $words[0].ToUpper() + $sep + $words[1] + $sep + $words[2].ToUpper() + $sep + (Get-Random -InputObject $numbers)
                $words[0] + $sep + $words[1].ToUpper() + $sep + $words[2] + $sep + (Get-Random -InputObject $numbers)
            )
            $password = Get-Random -InputObject $options
        }
    } else {
        $sep = (Get-Random -InputObject $seperators)
        $specChar = (Get-Random -InputObject $specialChars -Count 10)
        $num = (Get-Random -InputObject $numbers -Count 10)
        #$password = $num[0] + $specChar[0] + $specChar[1] + (Get-Random $words[0].ToUpper(),$words[0].ToLower()) + $specChar[2] + (Get-Random $words[1].ToUpper(),$words[1].ToLower())+ $specChar[3] + (Get-Random $words[2].ToUpper(),$words[2].ToLower()) + $specChar[4] + $num[1]
        
        $password = ""
        
        for ($i=0; $i -lt 6; $i++) {
            $password = [System.String]::Concat($password,(Get-Random $words[$i].ToUpper(),$words[$i].ToLower()),$num[$i] + $specChar[$i])
        }
    }

    $password | clip

    Write-Host @'

'@

    Write-Host @"
    
     .--.
    /.-. '----------.
    \'-' .--"--""-"-'
     '--'

"@ -ForegroundColor Cyan
    if ($Secure) {
        Write-Host "A " -ForegroundColor Green -NoNewline
        Write-Host "SECURE " -ForegroundColor DarkRed -NoNewline
        Write-Host "password has been generated:" -ForegroundColor Green
    } else {
        Write-Host "A password has been generated for you:" -ForegroundColor Green
    }
    Write-Host ""
    Write-Host $password -ForegroundColor Yellow
    Write-Host ""
    Write-Host "This password has been copied to the clipboard." -ForegroundColor Green
}