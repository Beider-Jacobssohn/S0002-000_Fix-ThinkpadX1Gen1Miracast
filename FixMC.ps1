$device1 = "Intel(R) HD Graphics 520"
$device2 = "Intel(R) Dual Band Wireless-AC 8260"
$sleepLength = 12

Function Get-Device {
    param (
        [string]$deviceName
    )
    $device = Get-WmiObject -Class Win32_PnPEntity |
            Where-Object { $_.Name -like $deviceName }
    return $device
}

Function Toggle-Device($deviceName) {
    $device = Get-Device -deviceName $deviceName
    if ($device) {
        if ($device.Status -eq "OK") {
            Write-Output "Disabling ($($device.Name))..."
            Disable-PnpDevice -InstanceId $device.PNPDeviceID -Confirm:$false
        } elseif ($device.Status -eq "Error") {
            Write-Output "Enabling ($($device.Name))..."
            Enable-PnpDevice -InstanceId $device.PNPDeviceID -Confirm:$false
        }
    } else {
        Write-Output "Device not found."
    }
}

Toggle-Device -deviceName $device1
Toggle-Device -deviceName $device2
Start-Sleep -Seconds $sleepLength

Toggle-Device -deviceName $device2
Start-Sleep -Seconds $sleepLength

Toggle-Device -deviceName $device1
