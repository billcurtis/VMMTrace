$Report = @()

$IOPSDataSet = Get-SCVirtualMachine | Get-SCPerformanceData -PerformanceCounter StorageIOPSUsage -TimeFrame Hour


foreach ($IOPSData in $IOPSDataSet) {

    $vhdLocation = (Get-SCVirtualMachine $IOPSData.Name).VirtualHardDisks.Location
    $IOPSAvg = [math]::Round(($IOPSData.PerformanceHistory | Measure-Object -Average).Average)

    $Report += [pscustomobject]@{

        VM_Name             = $IOPSData.Name
        IOPs_Average_Hourly = $IOPSAvg
        VHD_Location        = $vhdLocation

    }


}

$Report | Sort-Object IOPs_Average_Hourly -Descending | Out-GridView -OutputMode None -Title "Hourly IOPS Performance"
