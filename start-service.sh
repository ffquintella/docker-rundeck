#!/bin/bash

set -e

export JAVA_HOME=/opt/java_home/java_home
export java_home=$JAVA_HOME

/opt/puppetlabs/puppet/bin/puppet apply -l /var/log/puppet.log --modulepath=/etc/puppet/modules /etc/puppet/manifests/start.pp

#echo "Starting Jira Server ..."
#/opt/jira/atlassian-jira-software-7.2.2-standalone/bin/start-jira.sh &


while [ ! -f /var/log/rundeck/rundeck.log ]
do
  sleep 2
done
ls -l /var/log/rundeck/rundeck.log

tail -n 0 -f /var/log/rundeck/rundeck.log &
wait
