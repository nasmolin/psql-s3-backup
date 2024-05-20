#!/bin/bash

now=$(date '+%d.%m.%Y-%H:%M');

dbs=( \
'<dbname>' \
'<dbname>' \
'<dbname>' \
'<dbname>' \
'<dbname>' \
'<dbname>' \
'<dbname>' \
'<dbname>' \
'<dbname>' 
)

for db in ${dbs[@]}
do
echo -e "\033[33m --- Create backup of $db \033[0m"
pg_dump --dbname=postgresql://<username>:<password>@<hostname>:<port>/$db -Fd -x -O -f "/backups/$now-$db"
if [ $? -eq 0 ]
then
echo -e "\033[32m Done \033[0m"
else
echo -e "\033[41m Could not create backup of $db \033[0m"
exit 1
fi
done

echo -e "\033[33m --- Create tar.gz archive \033[0m"
tar -cvf /backups/$now.tar /backups/
if [ $? -eq 0 ]
then
echo -e "\033[32m Done \033[0m"
else
echo -e "\033[41m Could not create tar.gz archive \033[0m"
exit 1
fi

echo -e "\033[33m --- Upload to S3 bucket \033[0m"
aws --endpoint-url=<endpointurl> \
  s3 cp /backups/$now.tar s3://<path/to>/$now.tar
if [ $? -eq 0 ]
then
echo -e "\033[32m Done \033[0m"
exit 0
else
echo -e "\033[41m Could not upload tar.gz archive to s3 bucket \033[0m"
exit 1
fi