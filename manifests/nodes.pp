node 'node1.gerald.local' {
  include puppet
  include memcached
  include admin::ntp
  include admin::stages
}
