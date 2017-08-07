#!/bin/bash

source $1
# curl --silent -T $war -u $username:$password $url

if [ -z "$war" ]; then
  printf '{"failed":true, "msg":"missing required arguments: war"}'
  exit 1
fi

if [ -z "$url" ]; then
  printf '{"failed":true, "msg":"missing required arguments: url"}'
  exit 1
fi

msg=`curl -s --connect-timeout 60 -T "$war" -u "$username":"$password" "$url"`

printf '{"changed": true, "failed": false, "msg": "%s"}' "$msg"
#deploy: url=... war=… username=… password=…
exit 0
