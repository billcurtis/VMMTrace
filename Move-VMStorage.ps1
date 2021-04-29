# Quickly written script. 4/29/2021

# Just run script in a VMM PowerShell environment. 


function move-vmmStorage {

    param (
    
        $VMName,
        $DestinationFileShare
    
    )
    
    # Load Modules
    $ErrorActionPreference = "Stop"
    $VerbosePreference = "SilentlyContinue"
    Import-Module virtualmachinemanager
    $VerbosePreference = "Continue"
    
    
    $VM = Get-SCVirtualMachine -Name $VMName
    $VMHost = Get-SCVMHost -ID $VM.HostId
    
    Move-SCVirtualMachine -VM -UseLAN -RunAsynchronously -VMHost $VMHost -Path $DestinationFileShare 
    
}
    

# Load Modules
$ErrorActionPreference = "Stop"
$VerbosePreference = "SilentlyContinue"
Import-Module virtualmachinemanager
$VerbosePreference = "Continue"
    
$title = "Please select the VMs to migrate:"
$vmDataSet = (Get-SCVirtualMachine | Select-Object Name, Location) | Out-GridView -Title $title -OutputMode Multiple
$title = "Please select the File Share to migrate to:"
$DestinationFileShare = (Get-SCStorageFileShare | Select-Object SharePath) | Out-GridView -Title $title -OutputMode Single
    
Write-Output $vmDataSet
Write-Verbose "Destination File Share is: $($DestinationFileShare.SharePath)"

foreach ($vmData in $vmDataSet) {
    
    Write-Verbose "Moving virtual machine: $($vmData.Name)"
    move-vmmStorage -VMName $vmData.Name -DestinationFileShare $DestinationFileShare.SharePath
    
}
     