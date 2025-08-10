# test.ps1
# Harmless lab script to prove download & execution
$desktop = [Environment]::GetFolderPath('Desktop')
$filePath = Join-Path $desktop 'ps1_test_proof.txt'

"Test script executed at $(Get-Date)" | Out-File -FilePath $filePath -Encoding UTF8

Write-Host "Proof file written to $filePath" -ForegroundColor Green
Start-Sleep -Seconds 5
