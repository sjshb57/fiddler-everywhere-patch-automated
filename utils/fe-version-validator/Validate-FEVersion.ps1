param(
    [string]$VersionToPatch
)

try {
    Write-Host "🔎 Fetching all available Fiddler Everywhere versions..."
    $url = "https://www.telerik.com/support/whats-new/fiddler-everywhere/release-history"
    $htmlContent = Invoke-RestMethod -Uri $url -Method Get
    $pattern = 'Fiddler Everywhere v(\d+\.\d+\.\d+)'
    $matches = [regex]::Matches($htmlContent, $pattern)

    if ($matches.Count -eq 0) {
        throw "Could not find any version patterns in the page's HTML."
    }
    
    $allVersions = @()
    foreach ($match in $matches) {
        $allVersions += $match.Groups[1].Value
    }
    Write-Host "✅ Found $($allVersions.Count) versions."

    $isValid = 'false'
    
    if (-not [string]::IsNullOrEmpty($VersionToPatch)) {
      if ($allVersions -contains $VersionToPatch) {
        if ([version]$VersionToPatch -ge [version]"5.9.0") {
          $isValid = 'true'
          Write-Host "✅ Version $VersionToPatch is valid and compatible."
        } else {
          throw "❌ Version $VersionToPatch was found but is not compatible (older than 5.9.0)."
        }
      } else {
        throw "❌ Version $VersionToPatch was not found in the release history list."
      }
    } else {
      throw "❌ VERSION_TO_PATCH was not provided to the script."
    }

    if ($env:GITHUB_OUTPUT) {
        echo "is_valid=$isValid" >> $env:GITHUB_OUTPUT
    }
}
catch {
    Write-Error $_.Exception.Message
    exit 1
}
