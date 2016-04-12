#!/bin/bash

MYSQL_DB_IP=${MYSQL_DB_IP:-localhost}
echo "Updating database IP address to ${MYSQL_DB_IP}"
sed -i "s/MYSQL_DB_IP/$MYSQL_DB_IP/g" /opt/liferay-portal/portal-ext.properties

echo "Starting liferay..."
exec /opt/liferay-portal/tomcat/bin/catalina.sh run
