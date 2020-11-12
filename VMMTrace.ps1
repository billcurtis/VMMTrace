# Quickly written script.  Put in the active VMMServer FQDN and execute script. 


$ActiveVMMServer = "vmmnode1.wcurtis.net"
$Cred = get-credential
$guid = (New-Guid).Guid

$trace = Invoke-Command -ComputerName $ActiveVMMServer -ArgumentList $guid -Credential $Cred -ScriptBlock {

    $guid = $args[0]

    $filePath = "C:\VMMTrace-$guid"

    New-Item -ItemType Directory -Path $filepath | Out-Null

    $expression = "logman create trace VMM-$guid -v mmddhhmm -o $filepath\VMMLog_$env:computername.ETL -cnf 01:00:00 -p Microsoft-VirtualMachineManager-Debug -nb 10 250 -bs 16 -max 512" 

    Invoke-Expression $expression | Out-Null

    $expression = "logman start VMM-$guid"

    Invoke-Expression $expression | Out-Null

    Read-Host -Prompt "Trace Started. Press ENTER to stop Trace"

    $expression = "logman stop VMM-$guid"

    Invoke-Expression $expression | Out-Null

    $expression = "logman delete VMM-$guid"

    Invoke-Expression $expression | Out-Null

    $etlFile = Get-ChildItem $filePath -Filter *.etl

    $expression = "netsh trace convert $($etlFile.FullName)"

    Invoke-Expression $expression | Out-Null

    $txtFile = Get-ChildItem $filePath -Filter *.txt

    $fulltrace = Get-Content -Path $txtFile.FullName

    Remove-Item $filePath -Recurse -Force | Out-Null
 
    return $fulltrace

}

$trace | Out-File -FilePath ".\VMMTrace-$guid.txt"