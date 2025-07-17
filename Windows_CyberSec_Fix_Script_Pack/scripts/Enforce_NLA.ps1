<#
.SYNOPSIS
    Enforces Network Level Authentication (NLA) for Remote Desktop (Term Services).

.DESCRIPTION
    Sets registry key to require NLA, improving RDP security by requiring authentication before session establishment.

.NOTES
    Requires reboot to take full effect.
#>

Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "UserAuthentication" -Value 1 -Type DWord

Write-Output "Network Level Authentication (NLA) enforced for RDP. Please reboot to apply changes."
