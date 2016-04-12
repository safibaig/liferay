FROM ubuntu:trusty
MAINTAINER Ritesh Patel <ritesh@nirmata.com>

RUN groupadd -r mysql && useradd -r -g mysql mysql

# Install packages
RUN apt-get update
RUN apt-get -y install wget
RUN apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-server-5.6 pwgen

# Remove pre-installed database
RUN rm -rf /var/lib/mysql/*

# Add MySQL configuration
ADD my.cnf /etc/mysql/conf.d/my.cnf
ADD mysqld_charset.cnf /etc/mysql/conf.d/mysqld_charset.cnf

# Add MySQL scripts
ADD create_mysql_admin_user.sh /create_mysql_admin_user.sh
ADD import_sql.sh /import_sql.sh
ADD run.sh /run.sh
RUN chmod 755 /*.sh
RUN chown -R mysql /var/lib/mysql
RUN chgrp -R mysql /var/lib/mysql

# Exposed ENV
ENV MYSQL_PASS password

# Add VOLUMEs to allow backup of config and databases
VOLUME  ["/etc/mysql", "/var/lib/mysql"]

CMD ["/run.sh"]
