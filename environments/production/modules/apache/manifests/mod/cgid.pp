class apache::mod::cgid {
  case $::osfamily {
    'FreeBSD': {}
    default: {
      if defined(Class['::apache::mod::event']) {
        Class['::apache::mod::event'] -> Class['::apache::mod::cgid']
      } else {
        Class['::apache::mod::worker'] -> Class['::apache::mod::cgid']
      }
    }
  }

  # Debian specifies it's cgid sock path, but RedHat uses the default value
  # with no config file
  $cgisock_path = $::osfamily ? {
    'debian'  => "\${APACHE_RUN_DIR}/cgisock",
    'freebsd' => 'cgisock',
    default   => undef,
  }
  ::apache::mod { 'cgid': }
  if $cgisock_path {
    # Template uses $cgisock_path
    file { 'cgid.conf':
      ensure  => file,
      path    => "${::apache::mod_dir}/cgid.conf",
      mode    => $::apache::file_mode,
      content => template('apache/mod/cgid.conf.erb'),
      require => Exec["mkdir ${::apache::mod_dir}"],
      before  => File[$::apache::mod_dir],
      notify  => Class['apache::service'],
    }
  }
}
