
$packs = split($extra_packs, ";")

$packs.each |String $value| {
  package{$value:
    ensure => present
  }
}

if $pre_run_cmd != '' {
  $real_pre_run_cmd = $pre_run_cmd
} else {
  $real_pre_run_cmd = "echo 0;"
}

exec {'Resync rundeck etc dir':
  path    => '/bin:/sbin:/usr/bin:/usr/sbin',
  command => 'cp -a /d_bck/rundeck/* /etc/rundeck/',
  creates => '/etc/rundeck/realm.properties',
  before  => Exec['Starting Rundeck'],
}

if $rundeck_db_type == "DEDICATED" {

  $url = "jdbc:${rundeck_db_tech}://${rundeck_db_server}:${rundeck_db_port}/${rundeck_db_schema}"

  case $rundeck_db_tech {
    'postgresql':           { $driver = 'org.postgresql.Driver' }
    'mysql' :               { $driver = 'com.mysql.jdbc.Driver' }
    'mssql' :               { $driver = 'com.inet.tds.TdsDriver' }
    'oracle' :              { $driver = 'oracle.jdbc.driver.OracleDriver' }
    default:                { $driver = 'org.postgresql.Driver' }
  }

  file{ '/etc/rundeck/rundeck-config.groovy':
    content => "loglevel.default = \"INFO\"
rdeck.base = \"/var/lib/rundeck\"
rss.enabled = \"false\"

rundeck.security.useHMacRequestTokens = true
rundeck.security.apiCookieAccess.enabled = true

dataSource {
  dbCreate = \"update\"
  url = \"${url}\"
  driverClassName = \"${driver}\"
  username = \"${rundeck_db_user}\"
  password = \"${rundeck_db_password}\"
  dialect = \"\"
}

grails.serverURL = \"http://127.0.0.1:4440\"
rundeck.clusterMode.enabled = \"false\"
",
  require => Exec['Resync rundeck etc dir'],
  }
}

# Using Pre-run CMD
exec {'Pre Run CMD':
  path  => '/bin:/sbin:/usr/bin:/usr/sbin',
  command => $real_pre_run_cmd,
} ->

# Starting jira
exec {'Starting Rundeck':
  path  => '/bin:/sbin:/usr/bin:/usr/sbin',
  command => "echo \"Starting Rundeck Server ...\"; /etc/init.d/rundeckd start & ",
}
