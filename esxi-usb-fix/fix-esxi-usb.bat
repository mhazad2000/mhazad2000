@echo off
REM Adds cpuUniformityHardCheckPanic=FALSE to the ESXi installer USB (drive H:)
REM so ESXi 8 boots on Intel hybrid (P-core + E-core) CPUs.
set DRIVE=H:
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$found=$false; foreach ($f in '%DRIVE%\BOOT.CFG','%DRIVE%\EFI\BOOT\BOOT.CFG') { if (Test-Path $f) { $found=$true; $t = Get-Content $f -Raw; if ($t -notmatch 'cpuUniformityHardCheckPanic') { Copy-Item $f ($f + '.bak') -Force; $t = $t -replace '(?m)^(kernelopt=.*?)\s*$', '$1 cpuUniformityHardCheckPanic=FALSE'; Set-Content $f $t -NoNewline; Write-Host ('Patched: ' + $f) } else { Write-Host ('Already patched: ' + $f) } } }; if (-not $found) { Write-Host 'BOOT.CFG not found on %DRIVE%' }"
pause
