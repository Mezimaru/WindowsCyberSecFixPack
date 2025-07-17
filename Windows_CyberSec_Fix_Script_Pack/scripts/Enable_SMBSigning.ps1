<#
.SYNOPSIS
    Enables SMB Signing requirement on both Server and Client.

.DESCRIPTION
    Sets registry keys to require SMB signing, which prevents man-in-the-middle attacks on SMB traffic.

.NOTES
    Requires reboot to take full effect.
#>

# Enable SMB Signing on Server
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "RequireSecuritySignature" -Value 1 -Type DWord

# Enable SMB Signing on Client
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" -Name "RequireSecuritySignature" -Value 1 -Type DWord

Write-Output "SMB Signing enabled for Server and Client. Please reboot to apply changes."
