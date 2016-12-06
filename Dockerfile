FROM ffquintella/docker-puppet:latest

MAINTAINER Felipe Quintella <docker-jira@felipe.quintella.email>

LABEL version="2.7.1.1"
LABEL description="This image contais the rundeck application to be used \
as a server."


ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

ENV JAVA_HOME "/opt/java_home/java_home"

ENV RUNDECK_VERSION "2.7.1"

# HSQL or DEDICATED
ENV RUNDECK_DB_TYPE "HSQL"


ENV FACTER_RUNDECK_VERSION $RUNDECK_VERSION
ENV FACTER_RUNDECK_DB_TYPE $RUNDECK_DB_TYPE

ENV FACTER_JAVA_HOME "/opt/java_home"
ENV FACTER_JAVA_VERSION "8"
ENV FACTER_JAVA_VERSION_UPDATE "111"
ENV FACTER_JAVA_VERSION_BUILD "14"


ENV FACTER_PRE_RUN_CMD ""
ENV FACTER_EXTRA_PACKS ""

# Puppet stuff all the instalation is donne by puppet
# Just after it we clean up everthing so the end image isn't too big
RUN mkdir /etc/puppet; mkdir /etc/puppet/manifests ; mkdir /etc/puppet/modules ; mkdir /opt/scripts
COPY manifests /etc/puppet/manifests/
COPY modules /etc/puppet/modules/
COPY start-service.sh /opt/scripts/start-service.sh
RUN chmod +x /opt/scripts/start-service.sh ; ln -s /opt/scripts/start-service.sh /usr/bin/start-service ;/opt/puppetlabs/puppet/bin/puppet apply -l /tmp/puppet.log  --modulepath=/etc/puppet/modules /etc/puppet/manifests/base.pp  ;\
 yum clean all ; rm -rf /tmp/* ; rm -rf /var/cache/* ; rm -rf /var/tmp/* ; rm -rf /var/opt/staging

# Ports Jira web interface
EXPOSE 4440/tcp

WORKDIR '/var/lib/rundeck'

# Configurations folder, install dir
#VOLUME  $CONFLUENCE_HOME

#CMD /opt/puppetlabs/puppet/bin/puppet apply -l /tmp/puppet.log  --modulepath=/etc/puppet/modules /etc/puppet/manifests/start.pp
CMD ["start-service"]
