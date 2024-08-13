# /bin/bash

mkdir -p dataset
cd dataset

echo "downloading the dataset from the backblaze website"
wget -nd -p https://f001.backblazeb2.com/file/Backblaze-Hard-Drive-Data/data_Q2_2024.zip
wget -nd -p https://f001.backblazeb2.com/file/Backblaze-Hard-Drive-Data/data_Q1_2024.zip
wget -nd -p https://f001.backblazeb2.com/file/Backblaze-Hard-Drive-Data/data_Q4_2023.zip
wget -nd -p https://f001.backblazeb2.com/file/Backblaze-Hard-Drive-Data/data_Q3_2023.zip


echo downloading complted..

echo "unzipping the dataset"
unzip data_Q2_2024.zip
unzip data_Q1_2024.zip
unzip data_Q4_2023.zip
unzip data_Q3_2023.zip

echo "remove metadata/stale directory"
rm -rf __MACOSX/

