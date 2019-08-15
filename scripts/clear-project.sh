set -euo pipefail

# Variables:
source shell-vars.sh

# Clear S3 Bucket
echo 'Clearing S3 bucket'
aws s3api delete-bucket
    --bucket ${S3_BUCKET_NAME}
    --region ${REGION_NAME}