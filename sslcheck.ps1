param (
    [string]$o # Optional parameter for CSV output
)

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

# Loop through each URL
foreach ($url in $urls) {
    try {
        $req = [Net.HttpWebRequest]::Create($url)
        $req.GetResponse() | Out-Null

        $output = [PSCustomObject]@{
            URL              = $url
            'Cert Start Date' = $req.ServicePoint.Certificate.GetEffectiveDateString()
            'Cert End Date'   = $req.ServicePoint.Certificate.GetExpirationDateString()
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
