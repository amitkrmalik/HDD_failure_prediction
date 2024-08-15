# /bin/bash

mkdir -p dataset
cd dataset

echo "downloading the dataset from the backblaze website"

if [ ! -f data_Q2_2024.zip ]; then
    wget -nd -p https://f001.backblazeb2.com/file/Backblaze-Hard-Drive-Data/data_Q2_2024.zip
fi


if [ ! -f data_Q1_2024.zip ]; then
    wget -nd -p https://f001.backblazeb2.com/file/Backblaze-Hard-Drive-Data/data_Q1_2024.zip
fi

if [ ! -f data_Q4_2023.zip ]; then
    wget -nd -p https://f001.backblazeb2.com/file/Backblaze-Hard-Drive-Data/data_Q4_2023.zip
fi

if [ ! -f data_Q3_2023.zip ]; then
    wget -nd -p https://f001.backblazeb2.com/file/Backblaze-Hard-Drive-Data/data_Q3_2023.zip
fi

if [ ! -f data_Q2_2023.zip ]; then
    wget -nd -p https://f001.backblazeb2.com/file/Backblaze-Hard-Drive-Data/data_Q2_2023.zip
fi

echo downloading complted..

echo "unzipping the dataset"
unzip -qq data_Q2_2024.zip
unzip -qq data_Q1_2024.zip
unzip -qq data_Q4_2023.zip
unzip -qq data_Q3_2023.zip
unzip -qq data_Q2_2023.zip

echo "remove metadata/stale directory"
find . -type d -name "__MACOSX" -exec rm -rf {} +

# coallating the data into a single directory

mkdir data
mv data_Q2_2023/*.csv data
mv data_Q3_2023/*.csv data
mv data_Q4_2023/*.csv data
mv data_Q1_2024/*.csv data
