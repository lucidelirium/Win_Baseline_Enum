$headerDistinguisher = get-date -f "yyyyMMdd_HHmm"
$filename = Join-Path -Path $env:SystemDrive -ChildPath "${env:COMPUTERNAME}_$(get-date -f "yyyyMMdd_HHmm").txt"
Write-Host "Capturing baseline to $filename..."

$enum =
do {
Write-Output "|==========================  Start of System Date & Time ($headerDistinguisher)  ====================================================================|"
Get-Date

Write-Output "|==========================  Start of Hostname ($headerDistinguisher)  ==============================================================================|"
$env:ComputerName

Write-Output "|==========================  Start of Local Users ($headerDistinguisher)  ===========================================================================|"
(Get-LocalUser | select Name).Name

Write-Output "|==========================  Start of Local Groups ($headerDistinguisher)  ==========================================================================|"
(Get-LocalGroup | select Name).Name

Write-Output "|==========================  Start of Logged on Users ($headerDistinguisher)  =======================================================================|"
(Get-CimInstance Win32_LoggedOnUser).antecedent.name | Select-Object -Unique

Write-Output "|==========================  Start of Running Processes ($headerDistinguisher)  =====================================================================|"
$getProc = [System.Tuple]::Create((Get-Process).Id,(Get-Process).Name,(Get-Process).Path)
$n=0
$outputGetProc = foreach ($index in $getProc.item1) {
    Write-Output ("({0}, {1}, {2})" -f $getProc.Item1[$n], $getProc.Item2[$n], $getProc.Item3[$n])
    $n++
}
$outputGetProc

Write-Output "|==========================  Start of Services and States ($headerDistinguisher)  ===================================================================|"
$getServ = [System.Tuple]::Create((Get-WmiObject win32_service).Name,(Get-WmiObject win32_service).State,(Get-WmiObject win32_service).PathName)
$g=0
$outputGetServ = foreach ($index in $getServ.item1) {
    Write-Output ("({0}, {1}, {2})" -f $getServ.Item1[$g], $getServ.Item2[$g], $getServ.Item3[$g])
    $g++
}
$outputGetServ

Write-Output "|==========================  Start of Network Information ($headerDistinguisher)  ===================================================================|"
Get-NetIPConfiguration

Write-Output "|==========================  Start of Listening network sockets ($headerDistinguisher)  =============================================================|"
Get-NetTCPConnection | ? State -EQ Listen | Format-Table -AutoSize

Write-Output "|==========================  Start of System Configuration Information ($headerDistinguisher)  ======================================================|"
Get-ComputerInfo

Write-Output "|==========================  Start of Mapped Drives ($headerDistinguisher)  =========================================================================|"
Get-WmiObject win32_MappedLogicalDisk -ComputerName $env:COMPUTERNAME | Select-Object Name,ProviderName

Write-Output "|==========================  Start of PnP Devices ($headerDistinguisher)  ==========================================================================="
Get-PnpDevice | Format-Table -

Write-Output "|==========================  Start of Shared Resources ($headerDistinguisher)  ======================================================================|"
Get-WmiObject win32_Share -ComputerName $env:COMPUTERNAME

Write-Output "|==========================  Start of Scheduled Tasks ($headerDistinguisher)  =======================================================================|"
Get-ScheduledTask | Format-Table -AutoSize

$stop = $True
}
while ($stop = $False)

$enum | Out-File $filename -Encoding utf8 -Width 1000

Write-Host "Script complete"

