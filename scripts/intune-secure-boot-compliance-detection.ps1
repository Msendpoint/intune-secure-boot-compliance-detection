<#
.SYNOPSIS
    Detects Secure Boot status and OS build version for Intune Proactive Remediation compliance assessment.

.DESCRIPTION
    This script is designed to be deployed as an Intune Proactive Remediation (Remediations) detection script
    to assess Windows 11 device readiness ahead of the Microsoft Secure Boot certificate rotation in 2026.

    It performs the following checks on each managed endpoint:
      - Queries Secure Boot status using Confirm-SecureBootUEFI
      - Retrieves the current OS build number and Windows version
      - Outputs a structured JSON object for consumption by the Intune Remediations engine

    Devices where Secure Boot is disabled or unsupported, or where the OS build is below the
    acceptable minimum, can be identified from the Intune Remediations results and targeted for
    remediation before the certificate expiry deadline in June 2026.

    Deploy this script under:
      Intune > Devices > Remediations > Create > Detection Script

    Results are visible in the Intune portal under the Remediations node and can be exported
    to CSV for further filtering and reporting.

.NOTES
    Author:      Souhaiel Morhag
    Company:     MSEndpoint.com
    Blog:        https://msendpoint.com
    Academy:     https://app.msendpoint.com/academy
    LinkedIn:    https://linkedin.com/in/souhaiel-morhag
    GitHub:      https://github.com/Msendpoint
    License:     MIT

.EXAMPLE
    # Run locally on a single device to verify output before deploying via Intune:
    .\Detect-SecureBootCompliance.ps1

    # Expected output (JSON):
    # {"ComputerName":"DESKTOP-ABC123","SecureBootEnabled":true,"OSVersion":"22H2","OSBuild":"22621"}

.EXAMPLE
    # Deploy as an Intune Proactive Remediation Detection Script:
    # 1. Navigate to Intune > Devices > Remediations > + Create
    # 2. Paste this script into the Detection Script field
    # 3. Set 'Run this script using the logged-on credentials' to No (run as SYSTEM)
    # 4. Assign to a device group containing your Windows 11 fleet
    # 5. Review results under the Remediations node and export to CSV for analysis
#>

[CmdletBinding()]
param()

# ---------------------------------------------------------------------------
# Step 1: Determine Secure Boot status
# Confirm-SecureBootUEFI returns:
#   $true  - Secure Boot is enabled and active
#   $false - Secure Boot is supported but currently disabled
#   throws - Hardware does not support Secure Boot (legacy BIOS or unsupported firmware)
# ---------------------------------------------------------------------------
try {
    $SecureBoot = Confirm-SecureBootUEFI
} catch {
    # Device does not support Secure Boot (e.g., non-UEFI hardware or CSM-only boot)
    $SecureBoot = "Unsupported"
}

# ---------------------------------------------------------------------------
# Step 2: Collect OS version information
# OsBuildNumber surfaces the numeric build (e.g., 22621 for Windows 11 22H2)
# WindowsVersion surfaces the marketing version string (e.g., "22H2")
# Get-ComputerInfo can be slow; acceptable in a detection script context.
# ---------------------------------------------------------------------------
try {
    $ComputerInfo = Get-ComputerInfo -ErrorAction Stop
    $OSBuild    = $ComputerInfo.OsBuildNumber
    $OSVersion  = $ComputerInfo.WindowsVersion
} catch {
    # Fallback to registry-based retrieval if Get-ComputerInfo fails
    $OSBuild   = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name CurrentBuildNumber -ErrorAction SilentlyContinue).CurrentBuildNumber
    $OSVersion = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name DisplayVersion   -ErrorAction SilentlyContinue).DisplayVersion
}

# ---------------------------------------------------------------------------
# Step 3: Build structured output object
# The JSON output is consumed by Intune Remediations for reporting.
# Fields:
#   ComputerName      - Hostname of the device
#   SecureBootEnabled - True / False / "Unsupported"
#   OSVersion         - Windows release version string (e.g., "23H2")
#   OSBuild           - Numeric OS build number (e.g., 22631)
# ---------------------------------------------------------------------------
$Output = [PSCustomObject]@{
    ComputerName      = $env:COMPUTERNAME
    SecureBootEnabled = $SecureBoot
    OSVersion         = $OSVersion
    OSBuild           = $OSBuild
}

# ---------------------------------------------------------------------------
# Step 4: Emit compact JSON to stdout for Intune to capture
# -Compress removes whitespace to keep the output on a single line,
# which is friendlier for Intune's output field length constraints.
# ---------------------------------------------------------------------------
Write-Output ($Output | ConvertTo-Json -Compress)

# ---------------------------------------------------------------------------
# Step 5: Exit code convention for Intune Proactive Remediations
# Exit 0 = detected no issue (compliant) — no remediation script will run
# Exit 1 = issue detected (non-compliant) — triggers the paired remediation script
#
# Evaluate compliance criteria:
#   - Secure Boot must be enabled (not False or Unsupported)
#   - OS build should meet the minimum required threshold
#     Update $MinimumBuild to reflect your organisation's current baseline.
# ---------------------------------------------------------------------------
$MinimumBuild = 22621  # Windows 11 22H2 — adjust to your required minimum

$isSecureBootCompliant = ($SecureBoot -eq $true)
$isBuildCompliant      = ($OSBuild -ge $MinimumBuild)

if ($isSecureBootCompliant -and $isBuildCompliant) {
    # Device meets all compliance criteria — no remediation needed
    exit 0
} else {
    # Device is non-compliant — Intune will trigger the paired remediation script
    exit 1
}
