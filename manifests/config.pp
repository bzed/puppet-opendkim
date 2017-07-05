# == Class: opendkim::config
#
# Manage OpenDKIM configuration
#
# === Parameters
#
# [*syslog*]
#   Inherited from params class.
#
# [*umask*]
#   Inherited from params class.
#
# [*oversignheaders*]
#   Inherited from params class.
#
# === Examples
#
#   See opendkim init for complete example.
#
# === Authors
#
#  rjpearce https://github.com/rjpearce
#


class opendkim::config(
  $syslog                  = $opendkim::params::syslog,
  $syslog_success          = $opendkim::params::syslog_success,
  $log_why                 = $opendkim::params::log_why,
  $umask                   = $opendkim::params::umask,
  $oversignheaders         = $opendkim::params::oversignheaders,
  $signature_algorithm     = $opendkim::params::signature_algorithm,
) inherits ::opendkim::params {

  concat { ['/etc/opendkim.conf', '/etc/default/opendkim', '/etc/opendkim/KeyTable', '/etc/opendkim/SigningTable',
            '/etc/opendkim/TrustedHosts' ]:
    owner  => root,
    group  => root,
    mode   => '0644',
    notify => Service[$opendkim::params::service],
  }
  concat::fragment {
    'opendkim config header':
      target  => '/etc/opendkim.conf',
      content => "###### MANAGED BY PUPPET\n",
      order   => '01';

    'opendkim config':
      target  => '/etc/opendkim.conf',
      content => template('opendkim/opendkim.conf.erb'),
      order   => '02';

    'opendkim default config header':
      target  => '/etc/default/opendkim',
      content => "###### MANAGED BY PUPPET\n",
      order   => '01';

    'opendkim default config':
      target  => '/etc/default/opendkim',
      content => template('opendkim/opendkim_default.erb'),
      order   => '02';

    'opendkim keytable header':
      target  => '/etc/opendkim/KeyTable',
      content => "###### MANAGED BY PUPPET\n",
      order   => '01';

    'opendkim signing table header':
      target  => '/etc/opendkim/SigningTable',
      content => "###### MANAGED BY PUPPET\n",
      order   => '01';

    'trust localhost':
      target  => '/etc/opendkim/TrustedHosts',
      content => "localhost\n",
      order   => '01';
  }
}
