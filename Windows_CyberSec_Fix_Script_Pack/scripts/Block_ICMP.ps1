<#
.SYNOPSIS
    Blocks ICMP Timestamp Requests and Replies via Windows Firewall.

.DESCRIPTION
    These rules mitigate vulnerabilities flagged by vulnerability scanners (e.g., Nessus Plugin ID 19506)
    by preventing inbound ICMP Timestamp Requests (Type 13) and outbound Timestamp Replies (Type 14).

.NOTES
    ICMP Type 13: Timestamp Request
    ICMP Type 14: Timestamp Reply
    Blocking these helps prevent reconnaissance via timestamp queries.

    No reboot is required. Firewall rules take effect immediately.
#>

# Block incoming ICMPv4 Timestamp Requests (Type 13)
New-NetFirewallRule -DisplayName "Block ICMPv4 Timestamp Request" `
  -Protocol ICMPv4 -ICMPType 13 -Direction Inbound -Action Block `
  -Profile Any -Enabled True

# Block outgoing ICMPv4 Timestamp Replies (Type 14)
New-NetFirewallRule -DisplayName "Block ICMPv4 Timestamp Reply" `
  -Protocol ICMPv4 -ICMPType 14 -Direction Outbound -Action Block `
  -Profile Any -Enabled True
