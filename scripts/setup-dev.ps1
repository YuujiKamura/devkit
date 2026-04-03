#Requires -RunAsAdministrator
<#
.SYNOPSIS
    YuujiKamura dev environment setup for Windows.
    Installs all tools needed for ghostty, deckpilot, and related projects.
.USAGE
    Run as Administrator:
    powershell -ExecutionPolicy Bypass -File setup-dev.ps1

    Skip prompts:
    powershell -ExecutionPolicy Bypass -File setup-dev.ps1 -All
#>
param(
    [switch]$All,
    [switch]$Minimal,    # Go + gh + git only (deckpilot dev)
    [switch]$Full        # Everything including VS Build Tools
)

$ErrorActionPreference = "Stop"

function Install-Tool {
    param([string]$Id, [string]$Name, [string]$Override)

    $installed = winget list --id $Id 2>$null | Select-String $Id
    if ($installed) {
        Write-Host "[SKIP] $Name already installed" -ForegroundColor DarkGray
        return
    }
    Write-Host "[INSTALL] $Name ..." -ForegroundColor Cyan
    $args = @("install", $Id, "--accept-package-agreements", "--accept-source-agreements")
    if ($Override) { $args += "--override"; $args += $Override }
    & winget @args
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[WARN] $Name install may have failed (exit $LASTEXITCODE)" -ForegroundColor Yellow
    } else {
        Write-Host "[OK] $Name" -ForegroundColor Green
    }
}

Write-Host "=== YuujiKamura Dev Environment Setup ===" -ForegroundColor White
Write-Host ""

# --- Core tools (always installed) ---
Write-Host "--- Core Tools ---" -ForegroundColor White
Install-Tool "Git.Git"          "Git"
Install-Tool "GitHub.cli"       "GitHub CLI"
Install-Tool "GoLang.Go"        "Go"

if ($Minimal) {
    Write-Host "`nMinimal setup complete. Restart your terminal to pick up PATH changes." -ForegroundColor Green
    exit 0
}

# --- Extended tools ---
Write-Host "`n--- Extended Tools ---" -ForegroundColor White
Install-Tool "zig.zig"              "Zig"              # ghostty ビルド可 (prebuilt モード)
Install-Tool "Rustlang.Rustup"      "Rust (rustup)"    # control-plane-server
Install-Tool "Python.Python.3.12"   "Python 3.12"      # manifest 管理等

if (-not $Full -and -not $All) {
    Write-Host "`nExtended setup complete. Run with -Full to also install VS Build Tools." -ForegroundColor Green
    Write-Host "Restart your terminal to pick up PATH changes." -ForegroundColor Green
    exit 0
}

# --- Heavy tools (VS Build Tools + Windows SDK) ---
Write-Host "`n--- Build Tools (this may take a while) ---" -ForegroundColor White

$vsOverride = "--add Microsoft.VisualStudio.Workload.VCTools " +
              "--add Microsoft.VisualStudio.Component.Windows11SDK.22621 " +
              "--add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 " +
              "--quiet --wait"

Install-Tool "Microsoft.VisualStudio.2022.BuildTools" "VS 2022 Build Tools" $vsOverride
Install-Tool "Microsoft.DotNet.SDK.9"                 ".NET 9 SDK"

Write-Host "`n=== Full setup complete ===" -ForegroundColor Green
Write-Host "Restart your terminal to pick up PATH changes." -ForegroundColor Green
Write-Host ""
Write-Host "Quick check:" -ForegroundColor White
Write-Host "  git --version && gh --version && go version && zig version && rustc --version"
