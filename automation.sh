#!/bin/bash

# Variables
myname="shivraj"
s3_bucket="upgrad-shivraj"

# 1st
sudo apt update -y

# 2nd
if [[ apache2 != $(dpkg --get-selections apache2 | awk '{print $1}') ]]; 
then
	apt install apache2 -y
fi

# 3rd
running=$(systemctl status apache2 | grep active | awk '{print $3}' | tr -d '()')
if [[ running != ${running} ]]; 
then
	systemctl start apache2
fi

# 4th 
enabled=$(systemctl is-enabled apache2 | grep "enabled")
if [[ enabled != ${enabled} ]]; 
then
	systemctl enable apache2
fi

timestamp=$(date '+%d%m%Y-%H%M%S')

# 5th
cd /var/log/apache2
tar -cf /tmp/${myname}-httpd-logs-${timestamp}.tar *.log

# 6th
if [[ -f /tmp/${myname}-httpd-logs-${timestamp}.tar ]]; 
then
	aws s3 cp /tmp/${myname}-httpd-logs-${timestamp}.tar s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar
fi
