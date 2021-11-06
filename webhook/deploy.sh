#!/bin/bash

check="docker ps"
checking=$(eval "$check")
image="fauzanooor/stkbt_nginx"

if [[ $checking =~ "stkbt_nginx" ]]; then
        docker rm -f stkbt_nginx && docker rmi -f $image && docker run --name=stkbt_nginx -d -p 80:80 $image:latest; else
        docker run --name=stkbt_nginx -d -p 80:80 $image:latest
fi