
$real_appdir = "${confluence_installdir}/atlassian-confluence-${confluence_version}"


# Fix dos2unix
exec {'dos2unix-fix':
  path    => '/bin:/sbin:/usr/bin:/usr/sbin',
  cwd     => "${real_appdir}/bin",
  command => '/opt/scripts/fixline.sh'
} ->

exec {'dos2unix-fix-start-service':
  path    => '/bin:/sbin:/usr/bin:/usr/sbin',
  cwd     => "/opt/scripts",
  command => '/opt/scripts/fixline.sh'
}

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

user {'confluence':
  ensure => present
}
# Using Pre-run CMD
exec {'Pre Run CMD':
  path  => '/bin:/sbin:/usr/bin:/usr/sbin',
  command => $real_pre_run_cmd
} ->
exec {'Coping Configs':
  path    => '/bin:/sbin:/usr/bin:/usr/sbin',
  command => "echo \"Coping configs ...\"; cp -r /opt/confluence-config/* ${real_appdir}/conf; chown -R confluence:confluence ${real_appdir}/conf ",
  creates => "${real_appdir}/conf/web.xml"
} ->
# Starting jira
exec {'Starting Confluence':
  path  => '/bin:/sbin:/usr/bin:/usr/sbin',
  command => "echo \"Starting Confluence Server ...\"; ${real_appdir}/bin/start-confluence.sh & ",
  user => 'confluence',
  require => Exec['dos2unix-fix-start-service']
}
