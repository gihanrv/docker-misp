#!/bin/bash
    sed -i -e "s/db login/$KMYSQL_USER/g" /var/www/MISP/app/Config/database.php
    sed -i -e "s/db password/$KMYSQL_PASSWORD/g" /var/www/MISP/app/Config/database.php
    sed -i -e "s/localhost/$KMYSQL_HOST/g" /var/www/MISP/app/Config/database.php
    sed -i -e "s/misp/$KMYSQL_DATABASE/g" /var/www/MISP/app/Config/database.php
    sed -i -E "s/'salt'(\s+)=>\s''/'salt' => '`openssl rand -base64 32 | tr \'/\' \'0\'`'/" /var/www/MISP/app/Config/config.php 
    sed -i -E "s/'baseurl'(\s+)=>\s''/'baseurl' => 'https:\/\/${MISP_FQDN}'/" /var/www/MISP/app/Config/config.php 
    sed -i -e "s/email@address.com/$KMISP_EMAIL/" /var/www/MISP/app/Config/config.php 

    if [ ! -f /var/lib/mysql/.db_initialized ]; then

            mysql -h$KMYSQL_HOST -uroot -p$KMYSQL_ROOT_PASSWORD -e "create database $KMYSQL_DATABASE"
            mysql -h$KMYSQL_HOST -uroot -p$KMYSQL_ROOT_PASSWORD -e "CREATE USER $KMYSQL_USER@'%' IDENTIFIED BY '$KMYSQL_PASSWORD'"
            mysql -h$KMYSQL_HOST -uroot -p$KMYSQL_ROOT_PASSWORD -e "grant usage on *.* to $KMYSQL_USER@'%' identified by '$KMYSQL_DATABASE'"
            mysql -h$KMYSQL_HOST -uroot -p$KMYSQL_ROOT_PASSWORD -e "grant all privileges on $KMYSQL_DATABASE.* to $KMYSQL_USER@'%'"
            mysql -h$KMYSQL_HOST -uroot -p$KMYSQL_ROOT_PASSWORD -e "flush privileges;"
            mysql -h$KMYSQL_HOST -u$KMYSQL_USER -pdevelop $KMYSQL_DATABASE < /var/www/MISP/INSTALL/MYSQL.sql
            mysql -h$KMYSQL_HOST -u$KMYSQL_USER -p$KMYSQL_PASSWORD $KMYSQL_DATABASE < /var/www/MISP/INSTALL/MYSQL.sql
            touch /var/lib/mysql/.db_initialized
            chown -R mysql:mysql /var/lib/mysql
    fi
