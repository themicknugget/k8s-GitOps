#!/bin/bash

# Usage:
# bash s3-multipart-upload.sh YOUR_FILE YOUR_BUCKET
# bash s3-multipart-upload.sh files.zip my-files

set -e

# Check if the script is run with the correct number of arguments
if [ $# -ne 2 ]; then
  echo "Usage: $0 <input_file>"
  exit 1
fi

filePath=$1
fileName=$(basename "$filePath")
bucket=$2
profile=default
tmpdir=$(mktemp -d -p /dev/shm)

# Chunk size in bytes (4.5 GB)
chunk_size=$(bc <<< "4.5 * 1024 * 1024 * 1024")
chunk_size=${chunk_size%.*}

# Get the total size of the input file
file_size=$(stat -c%s "$filePath")

# Calculate the number of chunks required
num_chunks=$((file_size / chunk_size))
if [ $((file_size % chunk_size)) -ne 0 ]; then
  num_chunks=$((num_chunks + 1))
fi

# Create multipart upload
echo "Initiating multipart upload for $fileName"
uploadId=$(aws s3api create-multipart-upload --bucket "$bucket" --key "$fileName" --profile "$profile" | jq -r '.UploadId')

# Split the file into chunks and upload
jsonData="{\"Parts\": ["
for ((i = 1; i <= num_chunks; i++)); do
  [ "$i" -ne 1 ] && skip=skip=$((i - 1))
  dd if="$filePath" of="$tmpdir/filepart.tmp" bs=$chunk_size $skip count=1

  eTag=$(aws s3api upload-part --bucket "$bucket" --key "$fileName" --part-number "$i" \
         --body "${tmpdir}/filepart.tmp" --upload-id "$uploadId" --profile "$profile" | jq -r '.ETag')

  jsonData+="\{\"ETag\": $eTag,\"PartNumber\": $i\}"

  if ((i != num_chunks)); then
    jsonData+=", "
  fi
done
jsonData+="]}"

echo "$jsonData" > fileparts.json

# Complete multipart upload and check ETag to verify success
mainEtag=$(aws s3api complete-multipart-upload --multipart-upload "file://fileparts.json" \
           --bucket "$bucket" --key "$fileName" --upload-id "$uploadId" --profile "$profile" | jq -r '.ETag')

if [[ $mainEtag != "" ]]; then
  echo "Successfully uploaded: $fileName to S3 bucket: $bucket"
else
  echo "Something went wrong! $fileName was not uploaded to S3 bucket: $bucket"
fi

# Cleanup temporary directory
rm -rf "$tmpdir"
