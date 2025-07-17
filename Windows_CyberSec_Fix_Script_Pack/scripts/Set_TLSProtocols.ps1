<#
.SYNOPSIS
    Enables TLS 1.2 and disables SSL 2.0, SSL 3.0, TLS 1.0, TLS 1.1, and Multi-Protocol Unified Hello.

.DESCRIPTION
    This script configures SCHANNEL protocols per current SOX compliance standards.

.NOTES
    Requires reboot to apply.
#>

$protocols = @{
    "Multi-Protocol Unified Hello" = 0
    "PCT 1.0" = 0
    "SSL 2.0" = 0
    "SSL 3.0" = 0
    "TLS 1.0" = 0
    "TLS 1.1" = 0
    "TLS 1.2" = 1
}

foreach ($protocol in $protocols.Keys) {
    $base = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\$protocol"
    foreach ($side in @("Client", "Server")) {
        # Create the registry keys if they don't exist
        New-Item -Path "$base\$side" -Force | Out-Null

        # Set Enabled property (1 = enabled, 0 = disabled)
        New-ItemProperty -Path "$base\$side" -Name "Enabled" -Value $protocols[$protocol] -PropertyType DWord -Force | Out-Null

        # Set DisabledByDefault property (inverse of Enabled)
        $disabledValue = if ($protocols[$protocol] -eq 1) { 0 } else { 1 }
        New-ItemProperty -Path "$base\$side" -Name "DisabledByDefault" -Value $disabledValue -PropertyType DWord -Force | Out-Null
    }
}

Write-Output "TLS protocols configured. Please reboot for changes to take effect."
