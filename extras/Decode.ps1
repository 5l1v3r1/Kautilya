﻿<#
.SYNOPSIS
Script for Kautilya to decode the data encoded by DNS TXT and POST exfiltration methods.

.DESCRIPTION
The script asks for an encoded string as an option, decodes it and writes to a file "decoded.txt" in the current working directory.
Both the encoding and decoding is based on Compress-PostScript by Carlos Perez.

.LINK
http://www.darkoperator.com/blog/2013/3/21/powershell-basics-execution-policy-and-code-signing-part-2.html
http://code.google.com/p/kautilya

#>

Param ([Parameter(Position = 0, Mandatory = $True)] [String]$data)

function Decode
{
    $command = "`$(New-Object IO.StreamReader (" +

    "`$(New-Object IO.Compression.DeflateStream (" +

    "`$(New-Object IO.MemoryStream (,"+

    "`$([Convert]::FromBase64String('$data')))), " +

    "[IO.Compression.CompressionMode]::Decompress)),"+

    " [Text.Encoding]::ASCII)).ReadToEnd();"

    $output = Invoke-Expression $command
    $output
    Out-File -InputObject $output -FilePath .\decoded.txt
}

Decode