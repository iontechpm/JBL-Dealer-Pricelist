$manifestPath = Join-Path $PSScriptRoot 'drive-asset-manifest.generated.csv'
$outPath = Join-Path $PSScriptRoot 'drive-asset-map.js'
$rows = Import-Csv -LiteralPath $manifestPath
$lines = @()
$lines += 'window.DRIVE_ASSET_MAP = {'
foreach ($row in $rows) {
  $url = $row.direct_url
  if (-not $url -and $row.file_id) {
    $url = 'https://drive.google.com/uc?export=view&id=' + $row.file_id
  }
  if ($url) {
    $key = $row.path.Replace('\','\\').Replace('"','\"')
    $value = $url.Replace('\','\\').Replace('"','\"')
    $lines += "  `"$key`": `"$value`","
  }
}
$lines += '};'
Set-Content -LiteralPath $outPath -Value $lines -Encoding UTF8
Write-Host "Wrote $outPath from $manifestPath"
