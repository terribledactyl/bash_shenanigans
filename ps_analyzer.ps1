<#
.SYNOPSIS
    Scans a target PowerShell script for specific keywords and reports the line numbers where matches are found.

.DESCRIPTION
    This script accepts the path to a PowerShell script and one or more keywords to search for.
    It scans each line of the script and reports lines containing the keywords, along with their line numbers.
    Useful for auditing scripts for specific commands (e.g., systeminfo, Invoke-WebRequest, etc.).

.PARAMETER ScriptPath
    Full path to the PowerShell script you want to analyze.

.PARAMETER Keywords
    One or more keywords to search for in the script.

.EXAMPLE
    .\Analyze-Script.ps1 -ScriptPath .\Example.ps1 -Keywords "systeminfo", "Invoke-WebRequest"
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$ScriptPath,  # Path to the target script to analyze

    [Parameter(Mandatory=$true)]
    [string[]]$Keywords   # Array of keywords to search for
)

# Validate file exists
if (-not (Test-Path $ScriptPath)) {
    Write-Error "File '$ScriptPath' not found."
    exit 1
}

# Read all lines from the script
$lines = Get-Content -Path $ScriptPath

# Loop through each keyword
foreach ($keyword in $Keywords) {
    Write-Host "`n=== Matches for keyword: '$keyword' ===" -ForegroundColor Cyan
    $matchFound = $false

    # Loop through each line and check for keyword match
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match [regex]::Escape($keyword)) {
            $lineNumber = $i + 1  # Line numbers are 1-based
            Write-Host "Line $lineNumber: $($lines[$i])" -ForegroundColor Yellow
            $matchFound = $true
        }
    }

    # Notify if no matches were found for this keyword
    if (-not $matchFound) {
        Write-Host "No matches found for '$keyword'." -ForegroundColor DarkGray
    }
}
