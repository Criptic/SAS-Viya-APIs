# This code is intented to run inside a Proc Python procedure within a SAS session

# First we are going to submit SAS code to create a macro variable
# This macro variable will contain the bearer token of your SAS session
SAS.submit('%let bearerToken = %sysget(SAS_CLIENT_TOKEN);')
bearerToken = SAS.symget('bearerToken')
# Second we create a SAS macro variable to retrieve the SAS Viya URL
SAS.submit('%let viyaHost = %sysfunc(getoption(SERVICESBASEURL));')
viyaHost = SAS.symget('viyaHost')

# Now we can write our request - here as an example based on the files endpoint
# We will return the result as a table to SAS
import requests
import pandas as pd

# https://developer.sas.com/rest-apis/files/getfileindexschema
url = f'{viyaHost}/files/files?limit=10'
payload={}
headers = {
  'Accept': 'application/json',
  'Authorization': f'Bearer {bearerToken}'
}

response = requests.request('GET', url, headers=headers, data=payload)
j = response.json()
df = pd.json_normalize(j, 'items')
SAS.df2sd(df, 'work.response')