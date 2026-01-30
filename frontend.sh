#!/bin/bash

USER_ID=$(id -u)


CHECK_ROOT(){
    if [ $USER_ID -ne 0 ]
    then
        echo "YOU MUST NEED SUDO PERMISSIONS"
        exit 1
    fi
}

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo " $2::..... FAILURE "
    else
        echo " $2::......SUCCESS"
    fi
}

CHECK_ROOT
dnf install nginx -y
VALIDATE $? "INSTALLING NGINX"

systemctl enable nginx
VALIDATE $? "ENABLING NGINX"
systemctl start nginx
VALIDATE $? "STARTING NGINX"

rm -rf /usr/share/nginx/html/*
VALIDATE $? "REMOVING OLD HTML CONTENT"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip
VALIDATE $? "DOWNLOAD FRONTEND CONTENT"

cd /usr/share/nginx/html
VALIDATE $? "OPEND HTML DIRECTORY"

unzip /tmp/frontend.zip
VALIDATE $? "UNZIP CONTENT"


cp /home/ec2-user/Expense-shell/expense.conf /etc/nginx/default.d/expense.conf
VALIDATE $? "COPYING REVERSE PROXY CONFIGURATION"

systemctl restart nginx
VALIDATE $? "RESTART NGINX"