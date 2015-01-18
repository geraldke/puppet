class eventmachine($version) {
  package { 'eventmachine':
    provider => gem,
    ensure => $version,
  }

  notify { "Your operating system is $::operatingsystemrelease": }
}
