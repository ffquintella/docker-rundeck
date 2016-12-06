package {'sudo':
  ensure => present
}->
package{'zip':
  ensure => present
}

package{'dos2unix':
  ensure => present
}

package{'perl':
  ensure => present
}

file{ '/etc/yum.repos.d/epel.repo':
  ensure => present,
  content => '[epel]
name=Extra Packages for Enterprise Linux 7 - $basearch
#baseurl=http://download.fedoraproject.org/pub/epel/7/$basearch
mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-7&arch=$basearch
failovermethod=priority
enabled=1
gpgcheck=0'
}

class { 'jdk_oracle':
  version     => $java_version,
  install_dir => $java_home,
  version_update => $java_version_update,
  version_build  => $java_version_build,
  package     => 'server-jre'
} ->

file { '/etc/pki/tls/certs/java':
  ensure  => directory
} ->

file { '/etc/pki/tls/certs/java/cacerts':
  ensure  => link,
  target  => '/etc/pki/ca-trust/extracted/java/cacerts'
} ->

file { "/opt/java_home/jdk1.${java_version}.0_${java_version_update}/jre/lib/security/cacerts":
  ensure  => link,
  target  => '/etc/pki/tls/certs/java/cacerts'
}

# Full update
exec {'Install repository':
  path  => '/bin:/sbin:/usr/bin:/usr/sbin',
  command => 'rpm -Uvh http://repo.rundeck.org/latest.rpm'
} ->

class { '::rundeck':
  package_ensure => $rundeck_version,
  rdeck_home     => $rundeck_homedir,
  user           => $rundeck_user,
  user_id        => $rundeck_user_id,
  group_id       => $rundeck_group_id,
}

/*
class { '::rundeck':
  key_storage_type      => 'db',
  projects_storage_type => 'db',
  properties_dir        => $rundeck_configdir,
  database_config       => {
    'type'              => 'mysql',
    'url'               => $db_url,
    'username'          => 'rundeck',
    'password'          => $db_pass,
    'driverClassName'   => 'com.mysql.jdbc.Driver',
  }
}
*/


# Full update
exec {'Full update':
  path  => '/bin:/sbin:/usr/bin:/usr/sbin',
  command => 'yum -y update'
} ->
# Cleaning unused packages to decrease image size
exec {'erase installer':
  path  => '/bin:/sbin:/usr/bin:/usr/sbin',
  command => 'rm -rf /tmp/*; rm -rf /opt/staging/*'
} ->

exec {'erase cache':
  path  => '/bin:/sbin:/usr/bin:/usr/sbin',
  command => 'rm -rf /var/cache/*'
} ->
exec {'erase logs':
  path  => '/bin:/sbin:/usr/bin:/usr/sbin',
  command => 'rm -rf /var/log/*'
}


package {'openssh': ensure => absent }
package {'openssh-clients': ensure => absent }
package {'openssh-server': ensure => absent }
package {'rhn-check': ensure => absent }
package {'rhn-client-tools': ensure => absent }
package {'rhn-setup': ensure => absent }
package {'rhnlib': ensure => absent }

package {'/usr/share/kde4':
  ensure => absent
}
