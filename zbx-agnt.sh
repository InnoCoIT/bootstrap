#!/bin/bash

OS=`cat /etc/*-release | grep "PRETTY_NAME" | sed 's/PRETTY_NAME="//g'`
SERVER_IP=$1
function zbxAgnt {
	os=$1
	ver=$2
	echo "Downloading repository... for $SERVER_IP"
	rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/${ver}/x86_64/zabbix-release-5.0-1.el${ver}.noarch.rpm
	yum clean

	echo "Installation zbxAgnt for $1 $2"
	yum install zabbix-agent

	echo "Changing agent configuration"
	sed -i "s/Server=127.0.0.1/Server=$SERVER_IP/gi" /etc/zabbix/zabbix_agentd.conf > /dev/null 2>&1
	sed -i "s/ServerActive=127.0.0.1/ServerActive=$SERVER_IP/gi" /etc/zabbix/zabbix_agentd.conf > /dev/null 2>&1
	sed -i "s/Hostname=Zabbix server/Hostname=$SERVER_IP/gi" /etc/zabbix/zabbix_agentd.conf > /dev/null 2>&1

	echo "Registering service..."
	ckconfig --level 345 zabbix-on

	echo "Starting monitoring agent..."
	service zabbix-agent start
}
if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root privileges"
	exit -1
fi

if [[ "$OS" == *"Linux 7"* ]]; then
  zbxAgnt CentOS 7

elif [[ "$OS" == *"Linux 6"* ]]; then
  zbxAgnt CentOS 6
else
  echo "unknown os"
fi