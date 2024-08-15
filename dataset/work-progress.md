# Intent of this document
Intent of this document is to save the sate and information regarding the project and its various steps

## Data source and selection of data
BackBlaze is publishing the data of SSD drives used in their datacenters from quite some time. this data is an Open Source data and can be used for machine learning.
https://www.backblaze.com/cloud-storage/resources/hard-drive-test-data

For this project I will be using the Q1 2024 dataset, which can be downloaded from there site
https://f001.backblazeb2.com/file/Backblaze-Hard-Drive-Data/data_Q1_2024.zip

## Data Pre-processing
1. Data can be downloaded to local using the script [download_dataset.sh](download_dataset.sh)
2. Uncompressed dataset is huge and partitioned using the per-day data files.
3. It would be good to identify few of the basic parameters and dimention of the dataset under question.

Since the dat set is huge would be using the BIG-Data tools to currate the dateset in the format which can be used for trend and other analysis.


### Tools used 
1. Apache Druid
2. Influxdb

**Apache Druid**

I would be using the Apache Druid for the dataset pre-processing and converting the dataset which can be used for ML/DL.

- [Download Apache Druid] (https://druid.apache.org/downloads/)
- Untar the druid in a local directory
- start the Apache Druid using ./bin/start-druid 

```
|/nobackup/amimalik/druid/apache-druid-29.0.1 > ./bin/start-druid
```
- Load the dataset to druid


**Influxdb**

A docker instance can be run post downloading the image to ADS

```
docker run \
 --name influxdb2 \
 --publish 8086:8086 \
 --mount type=volume,source=influxdb2-data,target=/nobackup/amimalik/influxdb2/data \
 --mount type=volume,source=influxdb2-config,target=/nobackup/amimalik/influxdb2/config \
 --env DOCKER_INFLUXDB_INIT_MODE=setup \
 --env DOCKER_INFLUXDB_INIT_USERNAME=amimalik \
 --env DOCKER_INFLUXDB_INIT_PASSWORD=amimalik \
 --env DOCKER_INFLUXDB_INIT_ORG=bits \
 --env DOCKER_INFLUXDB_INIT_BUCKET=bits-blackblaze \
 influxdb:2
 ```

#### Dimention of the dataset
1. Identify the Number of devices for each Device Model
```
SELECT
  model,
  COUNT(*) AS device_count
FROM "dataset"
GROUP BY model
ORDER BY device_count DESC
```
Query results can be reviewed at [Device model by counts in descending orcer](dataset/dimentions/device_model_by_failure_counts.csv)

2. Identify the device model by failure observed
```
SELECT
  model,
  COUNT(*) AS failure_count
FROM "dataset"
WHERE failure = 1
GROUP BY model
ORDER BY failure_count DESC
```
Query resutls can be reviewd at [device model by failure counts](dataset/dimentions/device_model_by_failure_counts.csv)

3. Identify serial numbers of failing drives and create a new table named "failed_table"
```
REPLACE INTO failed_table 
OVERWRITE ALL
SELECT
  "__time",
  "serial_number",
  "model"
FROM "dataset"
WHERE failure = 1
PARTITIONED BY DAY
```
Query results can be reviewed at [serial number and model of failing devices](dataset/dimentions/serial-num_of_failing_device_model.csv)

4. Create a new table/dataset for the device type as ST12000NM0008
```
REPLACE INTO all_features_specific_serial
SELECT 
  yt.*
FROM dataset yt
JOIN failed_table ft ON yt.serial_number = ft.serial_number
WHERE yt.serial_number LIKE 'Z%' AND model = 'ST12000NM0008'
PARTITIONED BY DAY
```
Query results can be reviewed at 


Above steps can also be performed using the Python Dask dataframe handler code for the same can be found at [TBD]

Choice of above dataset is due to.

1. failure observed is 1000/25,189,213 which is not a balanced dataset to start with for any model traning.
2. to create the balance of the data we will be using the data from the failed drives from all available days, that should give the sample which has a good sample points.

### Data cleaning.
Data cleaning will be carried out on the row and column wise to ensure we are having the data which can generate good features and trends

Data cleaning is done as part of the Python workbook using pandas, dask and other libraries.

Data cleaning Columns:
1. Drop normalised columns:

> Original dataset has raw and normalised value instance. it is usually recommended to normalise the data to have a perfect fit, hence I intend to drop all columns having pattern 'smart.*normalised'

2. Drop any other feature column which has no valuable information

> Original dataset has some of the columns which do not reflect any feature leading to failure trends. 