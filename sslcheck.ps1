param (
    [switch]$h,    # Help switch
    [string]$o     # Optional parameter for CSV output
)

# Display help information if -h is used
if ($h) {
    Write-Output @"
    Script to check SSL certificate details for multiple URLs.

    Usage:
    .\your-script.ps1 [-h] [-o <output_csv_path>]

    Parameters:
    -h              Display this help message.
    -o <path>       Specify the output CSV file path to save the results. If not specified, the results will only be displayed.

    Example:
    .\your-script.ps1 -o "certificates.csv"   # Save output to certificates.csv
"@
    exit
}

# Ignore certificate validation errors
[Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }

# List of URLs to check
$urls = @(
    "https://www.microsoft.com/",
    "https://www.google.com/",
    "https://www.github.com/"
)

# Create an array to store the output
$outputArray = @()
$totalUrls = $urls.Count # Total number of URLs

# Loop through each URL
for ($i = 0; $i -lt $totalUrls; $i++) {
    $url = $urls[$i]
    
    # Update progress bar
    $percentComplete = (($i + 1) / $totalUrls) * 100
    Write-Progress -Activity "Checking certificates" -Status "Processing $url" -PercentComplete $percentComplete

    try {
        $req = [Net.HttpWebRequest]::Create($url)
        $req.GetResponse() | Out-Null

        # Get certificate details
        $certStartDate = [DateTime]::Parse($req.ServicePoint.Certificate.GetEffectiveDateString())
        $certEndDate = [DateTime]::Parse($req.ServicePoint.Certificate.GetExpirationDateString())
        $daysUntilExpiration = ($certEndDate - (Get-Date)).Days

        $output = [PSCustomObject]@{
            URL                  = $url
            'Cert Start Date'    = $certStartDate
            'Cert End Date'      = $certEndDate
            'Days Until Expiry'  = $daysUntilExpiration
        }

        # Add the result to the output array
        $outputArray += $output
    }
    catch {
        Write-Warning "Failed to retrieve certificate information for $url"
    }
}

# Display the results
$outputArray | Format-Table -AutoSize

# Export the results to a CSV file if a path is provided
if ($o) {
    try {
        $outputArray | Export-Csv -Path $o -NoTypeInformation -Force
        Write-Output "Results saved to $o"
    }
    catch {
        Write-Warning "Failed to save to CSV file at $o"
    }
}
