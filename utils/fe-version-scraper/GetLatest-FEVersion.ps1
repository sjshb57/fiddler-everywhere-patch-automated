# GetLatest-FEVersion.ps1 (GHA output directly)

try {
    Write-Host "🔎 Fetching latest version of Fiddler Everywhere..."
    $url = "https://www.telerik.com/support/whats-new/fiddler-everywhere/release-history"

    $htmlContent = Invoke-RestMethod -Uri $url -Method Get

    if ($htmlContent -match 'Fiddler Everywhere v(\d+\.\d+\.\d+)') {
        $version = $matches[1]
        Write-Host "✅ Latest Version Found: $version"

        # --- THIS IS THE NEW PART ---
        # Check if the GITHUB_OUTPUT environment variable exists.
        if ($env:GITHUB_OUTPUT) {
            Write-Host "🚀 Setting GitHub Actions output variable..."
            # Write in the format "key=value" to the file specified by GITHUB_OUTPUT
            echo "scraped_version=$version" | Out-File -Append -FilePath $env:GITHUB_OUTPUT
        }
    }
    else {
        throw "Could not find the version pattern in the page's HTML."
    }
}
catch {
    Write-Error $_.Exception.Message
    exit 1
}
