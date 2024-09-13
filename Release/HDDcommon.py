import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

# make a group with serial no of drive and return the last count no of days

def group_by_serial_number(df, count):

    # Group the instances dataframe by serial number
    grouped_instances = df.groupby('serial_number')

    # Create an empty list to store the last 150 samples for each serial number
    last_n = []

    # Iterate over each group
    for name, group in grouped_instances:
        # Get the last n (count) samples for the current serial number
        last_n_group = group.tail(count)
        # Append the last n samples to the list
        last_n.append(last_n_group)

    # Concatenate the list of dataframes into a single dataframe
    instance_last_n = pd.concat(last_n)

    # Reset the index of the dataframe
    instance_last_n.reset_index(drop=True, inplace=True)

    # Drop the date column from the dataframe
    # instance_last_n.drop(columns=['date'], inplace=True)

    # reset index
    instance_last_n.reset_index(drop=True, inplace=True)

    # Print the updated dataframe
    # instance_last_n.head()

    return instance_last_n


def get_model_data(df, model):
    model_df = df[df['model'] == model]
    if model_df.columns.contains('model'):
        model_df.drop(columns=['model'], inplace=True)
    if model_df.columns.contains('serial_number'):
        model_df.drop(columns=['serial_number'], inplace=True)
    return model_df

def get_clean_model_data(df):
    test = df.isnull().sum()
    d_col = []
    for k in test.keys():
        if test[k] == df.shape[0]:
            d_col.append(k)
    df.drop(columns=d_col, inplace=True)
    return df



def get_clear_data(df):
    # Drop the date column from the dataframe
    if df.columns.contains('date'):
        df.drop(columns=['date'], inplace=True)
    if df.columns.contains('model'):
        df.drop(columns=['model'], inplace=True)
    if df.columns.contains('serial_number'):
        df.drop(columns=['serial_number'], inplace=True)
    df_filled = df.fillna(df.mean())
    return df_filled