<#
.SYNOPSIS
    Configures SCHANNEL ciphers, hashes, key exchanges, and cipher suites per current SOX compliance standards.

.DESCRIPTION
    Enables AES 128/256 ciphers, SHA and SHA2 hashes, Diffie-Hellman, PKCS, ECDH key exchanges,
    disables weak/insecure algorithms, and sets a modern cipher suite list.

.NOTES
    Requires reboot to apply.
#>

# -- Ciphers --
$ciphers = @{
    "NULL" = 0
    "DES 56/56" = 0
    "RC2 40/128" = 0
    "RC2 56/128" = 0
    "RC2 128/128" = 0
    "RC4 40/128" = 0
    "RC4 56/128" = 0
    "RC4 64/128" = 0
    "RC4 128/128" = 0
    "Triple DES 168" = 0
    "AES 128/128" = -1
    "AES 256/256" = -1
}

foreach ($cipher in $ciphers.Keys) {
    $path = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\$cipher"
    New-Item -Path $path -Force | Out-Null
    New-ItemProperty -Path $path -Name "Enabled" -Value $ciphers[$cipher] -PropertyType DWord -Force | Out-Null
}

# -- Hashes --
$hashes = @{
    "MD5" = 0
    "SHA" = -1
    "SHA 256" = -1
    "SHA 384" = -1
    "SHA 512" = -1
}

foreach ($hash in $hashes.Keys) {
    $path = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Hashes\$hash"
    New-Item -Path $path -Force | Out-Null
    New-ItemProperty -Path $path -Name "Enabled" -Value $hashes[$hash] -PropertyType DWord -Force | Out-Null
}

# -- Key Exchange Algorithms --
$keyExchanges = @{
    "Diffie-Hellman" = -1
    "PKCS" = -1
    "ECDH" = -1
}

foreach ($kex in $keyExchanges.Keys) {
    $path = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\KeyExchangeAlgorithms\$kex"
    New-Item -Path $path -Force | Out-Null
    New-ItemProperty -Path $path -Name "Enabled" -Value $keyExchanges[$kex] -PropertyType DWord -Force | Out-Null
}

# -- Cipher Suites --
$cipherSuites = @(
    "TLS_AES_256_GCM_SHA384",
    "TLS_AES_128_GCM_SHA256",
    "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384",
    "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256",
    "TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384",
    "TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256",
    "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384",
    "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256",
    "TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384",
    "TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256"
)

# Set Cipher Suites order - Windows 10 and Server 2019+ use TLS Cipher Suite Order here:
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\CipherSuites"
New-Item -Path $regPath -Force | Out-Null

# Join suites as comma-separated string
$cipherSuitesValue = $cipherSuites -join ","

# Set the value (REG_SZ)
New-ItemProperty -Path $regPath -Name "Enabled" -Value $cipherSuitesValue -PropertyType String -Force | Out-Null

Write-Output "Ciphers, hashes, key exchanges, and cipher suites configured. Please reboot for changes to take effect."
