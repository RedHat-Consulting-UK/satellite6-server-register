#!/bin/bash

# Basic validation checks on script parameters
if [ -z "${1}" ]; then
        echo "Organization has not been specified."
fi
if [ -z "${2}" ]; then
        echo "Satellite FQDN or IP Address has not been specified"
fi
if [ -z "${3}" ]; then
        echo "The list of repositories to enable have not been specified"
fi
if [ -z "${4}" ]; then
        echo "Activation key name not specified"
fi
if [ -z "${5}" ]; then
        echo "Puppet environment name not specified"
fi

# Get script parameters from user
organization=$1
satellitefqdn=$2
repolist=$3
activationkey=$4
puppetenv=$5

# Install Katello
rpm -ivh http://${satellitefqdn}/pub/katello-ca-consumer-latest.noarch.rpm
subscription-manager register --force --org="$organization" --activationkey="$activationkey"
subscription-manager repos --enable $repolist

# Update packages on host
yum -y update

# Install the katello-agent
yum -y install katello-agent
chkconfig goferd on

# Katello Package upload
katello-package-upload

# Install & Configure puppet client
yum install -y puppet

# Configure puppet config
echo """[main]
        vardir = /var/lib/puppet
        logdir = /var/log/puppet
        rundir = /var/run/puppet
        ssldir = \$vardir/ssl

        [agent]
	waitforcert = 300
        pluginsync = true
        report = true
        ignoreschedules = true
        daemon = false
        ca_server = $satellitefqdn
        certname = `facter fqdn`
        environment = $puppetenv
        server = $satellitefqdn""" > /etc/puppet/puppet.conf

# Setup puppet to run on system reboot
/sbin/chkconfig --level 345 puppet on
systemctl enable puppet 

# Start the agent & run a test
puppet agent
puppet agent -tdv 

sync
