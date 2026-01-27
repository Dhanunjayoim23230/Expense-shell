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

dnf module disable nodejs -y
VALIDATE $? "DISABLING nodejs"

dnf module enable nodejs:20 -y
VALIDATE $? "ENABLING nodejs"

dnf install nodejs -y
VALIDATE $? "Installing nodejs"

id expense
if [ $? -ne 0 ]
then
    echo "user id expense is not present, creating now"
    useradd expense
else
    echo "User id expense is already present"
fi

mkdir -p /app

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip

cd /app

unzip /tmp/backend.zip