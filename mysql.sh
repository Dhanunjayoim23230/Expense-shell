#!/bin/bash

USER_ID=$(id -u)

CHECK_ROOT(){
    if [ $USER_ID -ne 0 ]
    then
        echo " You must need sudo permissions "
        exit 1
    fi
}

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo " $2....:: FAILURE"
    else
        echo "$2.....:: SUCCESS "
    fi
}

CHECK_ROOT


dnf install mysql-server -y
VALIDATE $? "MYSQL server installing"

systemctl enable mysqld
VALIDATE $? "ENABLING Mysql"

systemctl start mysqld
VALIDATE $? "Starting MYSQL"

mysql -h mysql.vrushali.online -u root -pExpenseApp@1 -e 'show databases;'
if [ $? -ne 0 ]
then
    echo "ROOT PASSWORD NOT set"
    mysql_secure_installation --set-root-pass ExpenseApp@1
    VALIDATE $? "MYSQL root password setup"
else
    echo "MYSQL root password already set"
fi



