define opendkim::trustedhost(
  $trustedhost = $name
) {
    concat::fragment { "trustedhost_${trustedhost}" :
        target  => '/etc/opendkim/TrustedHosts',
        content => "${trustedhost}\n"
    }
}

