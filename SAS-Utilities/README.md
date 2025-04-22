# SAS Utilities

This folder contains special utilities written in SAS to help making the usage of the SAS Viya APIs easier.

Find a short description and example usage of each below.

## [Retrieve ETag](./_retrieve_etag.sas)

This utility is a SAS macro that helps to get the [ETag](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/ETag) of a URI in SAS Viya in order to be able to modify it.

```sas
* Call the macro with the URI - here a report;
%_retrieve_etag(/reports/reports/&reportID.);

filename rprtOut temp;

* Call the /visualAnalytics/reports/{reportId} endpoint;
proc http
    method = 'Put'
    url = "&viyaHost./visualAnalytics/reports/&reportID." 
    in = addObj
    out = rprtOut
    oauth_bearer = sas_services;
    headers 'Accept' = 'application/json'
        'Content-Type' = 'application/json'
        'If-Match' = &_resource_etag.; /* Here you can see the ETag being passed into the endpoint */
run; quit;
```