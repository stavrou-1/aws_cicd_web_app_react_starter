#!/bin/bash

set -euo pipefail

# Variables:

##### NOTE: THE BELOW VARIABLES MUST BE SET! ######
# Name of an S3 bucket to be created -- MUST BE GLOBALLY UNIQUE!
S3_BUCKET=MY-UNIQUE-BUCKETNAME
# Cloudformation template name:
CF_TEMPLATE_PATH=MY-CF-TEMPLATE-PATH
# S3 Bucket vars:
S3_BUCKET_NAME='react-bucket-name'
# Codecommit repository name:
CODECOMMIT_REPO_NAME='react-repo-name'
# Codecommit repository description:
CODECOMMIT_REPO_DESCRIPTION='a react repo description'
# CODEBUILD_NAME 
CODEBUILD_NAME='react-codebuild-name'
# Codebuild template path
CODEBUILD_TEMPLATE_PATH=../infrastructure/codebuild/create-build.yaml
# Codepipeline name:
CODEPIPELINE_NAME='react-pipeline-name'
# Codepipeline path:
CODEPIPELINE_PATH=../infrastructure/pipeline/create-pipeline.yaml

# Local repo folder to copy our work from to the newely created codecommit repo.
LOCAL_REPO_FOLDER=./REACT_SITE

# AWS Account IDs
DEV_ACCOUNT_ID=123456789123
PROD_ACCOUNT_ID=123456789123

###### THESE VARIABLES CAN BE OPTIONALLY ADJUSTED ######
# Prefix for files in S3 bucket. Default is fine for most scenarios.
S3_PREFIX=AWS-CICD-Quickstart
# A name for your CloudFormation stack 
STACK_NAME=cicd-serverless

# Relative path to local folder (that does not exist) to store git project 
# LOCAL_REPO_FOLDER=../sample-project-codecommit

TEST_VAR="React test."

echo $TEST_VAR
echo $S3_BUCKET