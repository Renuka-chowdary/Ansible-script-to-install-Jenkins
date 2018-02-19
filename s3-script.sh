#!/bin/bash

# Variables

s3_bucket=hu-devops-renuka
Now=$(date +%d-%m-%y)
year=$(date +%Y)
month=$(date +%m)
date=$(date +%d)
db=sonar
dbuser=root
dbpwd=root


#Gitlab:

GitTemp_backup=/var/opt/gitlab/backups/
GitBackup_file=gitlab-backup-$Now
/opt/gitlab/bin/gitlab-rake gitlab:backup:create CRON=1

# AWS Sync
aws s3 sync $GitTemp_backup s3://$s3_bucket/Backups/Gitlab/$year/$month/$date/$GitBackup_file
sudo rm -rf $GitTemp_backup/*


#Jenkins:

cd /jenkins/
sudo mkdir tmp-bkp
sudo tar -cvzf tmp-bkp/jenkins.tar.gz jenkins

JenkinsTemp_backup=/jenkins/tmp-bkp/
JenkinsBackup_file=jenkins-backup-$Now

# AWS Sync
aws s3 sync $JenkinsTemp_backup s3://$s3_bucket/Backups/Jenkins/$year/$month/$date/$Backup_file
sudo rm -rf tmp-bkp


#sonar:

cd /sonar/
sudo mkdir tmp-bkp
sudo tar -cvzf tmp-bkp/sonar.tar.gz sonarqube-6.7.1

SonarTemp_backup=/sonar/tmp-bkp/
SonarBackup_file=sonar-backup-files-$Now

aws s3 sync $SonarTemp_backup s3://$s3_bucket/Backups/Sonar/daily/$year/$month/$date/$SonarBackup_file
sudo rm -rf tmp-bkp

cd ~
mkdir tmp
cd tmp/
mysqldump -u $dbuser -p$dbpwd $db > $date-sonar.sql
tar -czf sonar-backup-db-sonar.tar.gz $date-sonar.sql

sudo rm -rf $date-sonar.sql

aws s3 cp /home/ubuntu/tmp/ s3://$s3_bucket/Backups/Sonar/daily/$year/$month/$date/ --recursive

cd ~
sudo rm -rf tmp


