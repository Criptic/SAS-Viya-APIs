/*****************************************************
    This code snippet explains how you can use
      the input function to convert a data-timestamp
      returned by the SAS Viya APIs into a SAS
      datetime formatted value.
*****************************************************/

data work.datetime_example;
    length api_datetime_stamp $ sas_datetime 8.;
    format sas_datetime datetime22.8;

    * Set an example value as it would be returned by the API;
    api_datetime_stamp = '2025-07-22T20:23:33.410Z';
    
    * Convert it into the SAS Datetime;
    sas_datetime = input(api_datetime_stamp, E8601DZE8601DZ24.);
run;