#!/bin/bash

# Basic validation checks on script variables
if [ -z "${1}" ]; then
	echo "Organization has not been specified."
fi 
if [ -z "${2}" ]; then
	echo "Satellite FQDN or IP Address has not been specified"
fi 
if [ -z "${3}" ]; then
	echo "The list of repistories to enable have not been specified"
fi 
if [ -z "${4}" ]; then
	echo "Activation key name not specified"
fi
if [ -z "${5}" ]; then
	echo "Puppet environment name not specified"
fi 

# Script variables
organization=$1
satellitefqdn=$2
repolist=$3
activationkey=$4
puppetenv=$5


