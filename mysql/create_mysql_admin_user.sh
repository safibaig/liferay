#!/bin/bash

cp /etc/mysql/my.cnf /usr/share/mysql/my-default.cnf
/usr/bin/mysql_install_db --user=mysql --basedir=/usr/ --ldata=/var/lib/mysql/
/usr/bin/mysqld_safe > /dev/null 2>&1 &

RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MySQL service startup"
    sleep 5
    mysql -uroot -e "status" > /dev/null 2>&1
    RET=$?
done

if [ "$MYSQL_PASS" = "**Random**" ]; then
    unset MYSQL_PASS
fi

PASS=${MYSQL_PASS:-$(pwgen -s 12 1)}
_word=$( [ ${MYSQL_PASS} ] && echo "preset" || echo "random" )
echo "=> Creating MySQL admin user with ${_word} password"

mysql -uroot -e "CREATE USER 'admin'@'%' IDENTIFIED BY '$PASS'"
mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION"

echo "=> Creating MySQL lportal user with lportal password"
mysql -uroot -e "create user 'lportal'@'%' identified by 'lportal';"
mysql -uroot -e "create database lportal CHARACTER SET utf8 COLLATE utf8_general_ci;"
mysql -uroot -e "grant all privileges on lportal.* to lportal;"
mysql -uroot -e "flush privileges;"


echo "=> Done!"

echo "========================================================================"
echo "You can now connect to this MySQL Server using:"
echo ""
echo "    mysql -u admin -p $PASS -h <host> -P <port>"
echo ""
echo "Please remember to change the above password as soon as possible!"
echo "MySQL user 'root' has no password but only allows local connections"
echo "========================================================================"

mysqladmin -uroot shutdown
