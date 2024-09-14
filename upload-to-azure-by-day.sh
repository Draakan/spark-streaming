#!/bin/bash

LOCAL_DIR="./hotel-weather"
DELAY=30

copy_to_azure() {
  local local_path=$1
  local azure_path=$2

  az storage blob upload-batch \
    --source "$local_path" \
    --destination "$AZURE_CONTAINER" \
    --account-name "$AZURE_STORAGE_ACCOUNT" \
    --account-key "$AZURE_STORAGE_ACCOUNT_KEY" \
    --destination-path "$azure_path" \
    --overwrite \
    >/dev/null
}

while IFS= read -r -d '' folder_path; do
  azure_path=${folder_path#./}

  copy_to_azure "$folder_path" "$azure_path"

  echo "$azure_path has been copied"

  sleep $DELAY
done < <(find "$LOCAL_DIR" -type d -name "day=*" -print0 | sort -z)
