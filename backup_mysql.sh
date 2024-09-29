#!/bin/bash

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_DIR="/home/ubuntu/Wheel-Project/mysql_backups"
DOCKER_COMPOSE_DIR="/home/ubuntu/Wheel-Project"

mkdir -p $BACKUP_DIR

cd $DOCKER_COMPOSE_DIR

set -a
source .env
set +a

docker exec wheel-project-db mysqldump -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE_NAME > $BACKUP_DIR/backup_$TIMESTAMP.sql

gzip $BACKUP_DIR/backup_$TIMESTAMP.sql

aws s3 cp $BACKUP_DIR/backup_$TIMESTAMP.sql.gz s3://${MYSQL_S3_BUCKET_NAME}/

rm $BACKUP_DIR/backup_$TIMESTAMP.sql.gz

echo "Backup completed and uploaded to S3: $TIMESTAMP"
