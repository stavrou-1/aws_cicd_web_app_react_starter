#!/bin/bash
# Requires AWS CLI: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html

set -euo pipefail

# Variables:
source shell-vars.sh



# Create S3 bucket for CloudFormation sub-templates
echo "Creating S3 bucket and uploading sub-templates"
aws s3 mb s3://${S3_BUCKET_NAME}

# Put bucket policy
echo 'Adding bucket policy'
aws s3api put-bucket-policy \
    --bucket ${S3_BUCKET_NAME} --policy file://../infrastructure/policies/s3-policy.json

# enable website hosting
echo 'Enabling website hosting'
aws s3 website s3://${S3_BUCKET_NAME} --index-document index.html --error-document index.html

# Create Codecommit repository
echo 'Create codecommit repository'
aws codecommit create-repository \
    --repository-name ${CODECOMMIT_REPO_NAME} \
    --repository-description "React repo description"


# Now get our codecommit repo https url.
FULL_CODECOMMIT_HTTPSURL=https://git-codecommit.us-east-1.amazonaws.com/v1/repos/${CODECOMMIT_REPO_NAME}
echo "Run: git clone $FULL_CODECOMMIT_HTTPSURL"
cd ..
cd ..
git clone $FULL_CODECOMMIT_HTTPSURL $LOCAL_REPO_FOLDER

# Then add your files and commit
# Using the sample project in this Quick Start
cp -a ./myapp/. $LOCAL_REPO_FOLDER

echo 'Attempting to git add and push to repository'
cd $LOCAL_REPO_FOLDER
git add .
git commit -m "initial commit. did it work?"
git push

# cd ./

CODEBUILD_TEMPLATE_PATH2=./infrastructure/codebuild/create-build.yaml
CODEPIPELINE_TEMPLATE_PATH2=./infrastructure/pipeline/create-pipeline.yaml

# Create Code Build Stack
echo 'Creating Codebuild CF stack'
aws cloudformation deploy \
    --stack-name ${CODEBUILD_NAME} \
    --template-file ${CODEBUILD_TEMPLATE_PATH2} \
    --capabilities CAPABILITY_IAM


# Create Code Build Stack
echo 'Creating Codepipeline CF stack'
aws cloudformation deploy \
    --stack-name ${CODEPIPELINE_NAME} \
    --template-file ${CODEPIPELINE_TEMPLATE_PATH2} \
    --capabilities CAPABILITY_IAM

# Wait until assets are created.
sleep 40

# List CF Stacks
echo 'Listing cloudformation stacks'
aws cloudformation describe-stacks \
    --stack-name ${CODEPIPELINE_NAME} \
    --query "Stacks[*].Outputs[?OutputKey=='IAMUserName'].OutputValue" \
    --output text
