$selectBaseline = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
    InitialDirectory = $env:SystemDrive
    Filter = 'Text File (*.txt)|*.txt'
}

Write-Host "Choose first baseline to compare"
$selectBaseline.ShowDialog()
$baseline1 = $selectBaseline.FileName

Write-Host "Choose second baseline to compare"
$selectBaseline.ShowDialog()
$baseline2 = $selectBaseline.FileName

$inputfile1 = [System.IO.Path]::GetFileNameWithoutExtension($baseline1)
$inputfile2 = [System.IO.Path]::GetFileNameWithoutExtension($baseline2)

$filename= join-path -path $env:SystemDrive -childpath ($inputfile1 + "_vs_"  + $inputfile2 + ".txt")

Write-Host "Writing output to $filename.."

(Compare-Object -ReferenceObject $(Get-Content $baseline1) -DifferenceObject $(Get-Content $baseline2)).InputObject | Out-File $filename -Encoding utf8 -Width 1000

$openOutput = Read-Host "Open comparison output? [Y]/[N]"
if ($openOutput -eq 'Y') {
Invoke-Item $filename
}

Write-Host "Script complete"