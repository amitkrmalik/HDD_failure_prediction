# /bin/bash

mkdir -p dataset
cd dataset

echo "downloading the dataset from the backblaze website"
wget -nd -p https://f001.backblazeb2.com/file/Backblaze-Hard-Drive-Data/data_Q1_2024.zip

echo downloading complted..

echo "unzipping the dataset"
unzip data_Q1_2024.zip

echo "remove metadata/stale directory"
rm -rf __MACOSX/

echo "creating a test data set for initial pre-processing testing"
mkdir -p test
cp data_Q1_2024/2024-0[1,2,3]-01.csv ./test/
