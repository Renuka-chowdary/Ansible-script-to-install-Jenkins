#!/bin/bash
for i in $(cat names.txt)
do
        CLIENT=Hu2k18-$i
        echo "Creating IAM user"
        aws iam create-user --user-name $CLIENT --output json
        echo "Updating IAM profile"
        aws iam create-login-profile --user-name $CLIENT --password Hasher@123
        #echo "Creating Folder"
        #aws s3 cp readme.txt  s3://hu2k18/$CLIENT/readme.txt
        echo " creating s3 buckets for IAM user"
        aws s3 mb s3:$CLIENT


cat > userpolicy.json << EOL
{
   "Version": "2012-10-17",
   "Statement": [
       {
           "Sid": "VisualEditor0",
           "Effect": "Allow",
           "Action": [
               "s3:ListAllMyBuckets",
               "s3:HeadBucket",
               "s3:ListObjects"
           ],
           "Resource": "*"
       },
       {
           "Sid": "VisualEditor1",
           "Effect": "Allow",
           "Action": "s3:*",
           "Resource": [
                "arn:aws:s3:::$CLIENT",                 
               "arn:aws:s3:::$CLIENT/*"
           ]
       }
   ]
}
EOL

        echo "Generating User Policy"
        aws iam put-user-policy --user-name $CLIENT --policy-name $CLIENT-buckets --policy-document file://userpolicy.json
        aws iam update-login-profile --user-name $CLIENT --password Hasher@123
echo "====================================================="
echo "Completed!  Created user: "$CLIENT
echo "====================================================="

done

