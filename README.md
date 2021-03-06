# docker-rundeck
Job Scheduler Manager

# Table of Contents

This container contains the Rundeck Job Scheduler server installation based on Linux Centos 7 & puppet.

## Supported tags

Current branch: latest

*  `3.0.2-1`, `3.0.2-2`
*  `2.10.2.1`
*  `2.7.2.1`
*  `2.7.1.7`, `2.7.1.6`, `2.7.1.5`, `2.7.1.4`, `2.7.1.3`, `2.7.1.2`, `2.7.1.1`

For previous versions or newest releases see other branches.

## Introduction

Rundeck is a jobseduler with interdependeces and a nice GUI (http://rundeck.org)

### Version

* Version: `3.0.2-2` - Latest: Upgrade to 3.0.7 Upgrade to java 8-162
* Version: `2.10.2.1` - Upgrade to 2.10.2 Upgrade to java 8-152
* Version: `2.7.2.1` - Upgrade to 2.7.2
* Version: `2.7.1.7` - Changed the monitored file to see if sync is needed to jaas-loginmodule.conf
* Version: `2.7.1.6` - Small adjustments on logs
* Version: `2.7.1.5` - Change configuration file to rundeck-config.properties
* Version: `2.7.1.4` - Added the RUNDECK_URL parameter
* Version: `2.7.1.3` - Fixes on the docker image & puppet base image upgrade
* Version: `2.7.1.2` - Auto repopulation of /etc/rundeck in the case you want to mount it
* Version: `2.7.1.1` - First version


## Installation

Pull the image from docker hub.

```bash
docker pull ffquintella/docker-rundeck:latest
```

Alternately you can build the image locally.

```bash
git clone https://github.com/ffquintella/docker-rundeck.git
cd docker-rundeck
./build.sh
```

## Quick Start

docker run ffquintella/rundeck:latest

## Configuration

You can mount directly /etc/rundeck on a local folder because the start script you deal with the files recreation
We also sugest creating a volume to /var/lib/rundeck/projects

### Build Variables

- RUNDECK_VERSION - The version to be installed

### Extra Variables

- FACTER_RUNDECK_DB_TYPE - HSQL or DEDICATED
- FACTER_RUNDECK_DB_TECH - postgresql mysql sqlserver or oracle
- FACTER_RUNDECK_DB_SERVER - the fqdn of the database server
- FACTER_RUNDECK_DB_PORT - ex 5432
- FACTER_RUNDECK_DB_SCHEMA - the name of the database schema
- FACTER_RUNDECK_DB_USER - the name of the database user
- FACTER_RUNDECK_DB_PASSWORD - the password to the database
- FACTER_EXTRA_PACKS - A way to add extra packs that will be installed on the container initialization. The packs must be centos  7 packs and must be seppared by ;

### Data Store

You can mount directly

- /etc/rundeck - Don't worry about overwritting the files. This is handled by the startup scripts
- /var/lib/rundeck/projects - It's a good idea to create a volume here
- /var/lib/rundeck/logs

### User

No special users

### Ports

Next ports are exposed

* `8080/tcp` - default port


### Entrypoint

We use puppet as the default entry point to manage the environment

*Service is launched in background. Which means that is possible to restart without restarting the container.*

### Hostname

It is recommended to specify `hostname` for this image.

### SSL certs
The image is configured to use /etc/pki/tls/certs as the base ssl cert configuration. Java will use /etc/pki/tls/certs/java/cacerts as it's keychain.

If you want to add more certs to it ou can mount this file.

### Basic configuration using Environment Variables

> Some basic configurations are allowed to configure the system and make it easier to change at docker command line


## Upgrade from previous version

Basically stop your running container;

Docker pull latest version

Start a new instance with the new image (backup your data dir)

## Credits

My thanks to the following

- The Rundeck guys for providing this application
- Every one who worked building docker
- Github for the dvcs support
- Puppet guys for the great tool
