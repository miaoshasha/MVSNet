#!/usr/bin/env bash

# code version
codev=$(git rev-parse HEAD)
echo "code version is "$codev

# update gcloud
gcloud components update

# set up cloud bucket for source code
MODEL_FOLDER="dtu_train_test_model"
SOURCE_BUCKET_NAME=${MODEL_FOLDER}

# package code
python setup.py sdist

# upload packed source code
local_file_path="/Users/yishasun/Documents/dl_models/MVSNet/dist"
file_name="mvsnet-0.1.tar.gz"
SOURCE_CODE="gs://$SOURCE_BUCKET_NAME/project/$file_name"
gsutil cp $local_file_path/$file_name $SOURCE_CODE

# train log bucket
BUCKET_NAME_SUR="mvsnet"
echo $BUCKET_NAME_SUR
REGION=us-central1

PROJECT="project"

now=$(date +"%Y%m%d_%H%M%S")
JOB_NAME="mvsnet_$now"

# create the new bucket
out_dir="${BUCKET_NAME_SUR}-out"
# gsutil mb -l $REGION gs://$out_dir # comment out after first run

# log folder for each training
OUTPUT_DIR="gs://$out_dir/$JOB_NAME"

#gsutil mb -l $REGION $PACKAGE_STAGING_BUCKET

# hardware to use
TIER="BASIC_GPU" # BASIC | BASIC_GPU | STANDARD_1 | PREMIUM_1

# data dir
MVSNET_BUCKET_NAME=${MODEL_FOLDER}
test_folder="gs://$MVSNET_BUCKET_NAME/dtu_test_scan9.zip"
echo "test data folder is ${test_folder}"
# checkpoint file
ckpt_file="gs://$MVSNET_BUCKET_NAME/model/model.ckpt"

# package and submit job
gcloud ml-engine jobs submit training $JOB_NAME \
    --scale-tier "${TIER}"  \
    --module-name mvsnet.test \
    --region "${REGION}" \
    --packages "${SOURCE_CODE}" \
    --runtime-version 1.8  \
    --\
    --job_name=$JOB_NAME \
    --pretrained_model_ckpt_path=$ckpt_file \
    --dense_folder=$test_folder \
    --output_folder="${OUTPUT_DIR}"
