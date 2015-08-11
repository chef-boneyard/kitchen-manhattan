Function Unresolve-Path($p) {
  if ($p -eq $null) {return $null}
  else { return $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($p) }
}

$msi = Unresolve-Path $install_file
Write-Host "----> Installing Chef Omnibus Package $msi`n"
$p = Start-Process -FilePath "msiexec.exe" -ArgumentList "/qn /i $msi" -Passthru -Wait
if ($p.ExitCode -ne 0) { throw "msiexec was unsuccessful. Received exit code $($p.ExitCode)" }
Write-Host "      Installation Complete`n"
