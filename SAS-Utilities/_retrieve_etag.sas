/************************************************* 
    The _retrieve_etag macro requires the input
      of a full URI and then writes the eTag of
      that resource to the global macro variable
      _resource_etag.

    Please note this macro is focused on getting
      the eTag from SAS Viya APIs.
*************************************************/
%macro _retrieve_etag(_resourceURI);
    %global _resource_etag;
    %local _viya_host;

    * Get the SAS Viya host URL;
    %let _viya_host = %sysFunc(getOption(servicesBaseURL));

    * Create a temporary header output file;
    filename hdrOut temp;

    * Call the resource to get the header;
    proc http
        method = 'Get'
        url = "&_viya_host.&_resourceURI."
        oauth_bearer = sas_services
        headerOut = hdrOut;
        headers 'Accept' = 'application/json';
    run; quit;

    * Check that the resource was found and only then extract the ETag;
    %if &SYS_PROCHTTP_STATUS_CODE. EQ 200 %then %do;
        * Extract the ETag, this is needed to update the resource;
        data _null_;
            length headerLine $256.;
            inFile hdrOut delimiter='|' missover;
            input headerLine $;

            if substr(headerLine, 1, 4) EQ 'ETag' then do;
                headerLine = translate(substr(headerLine, 7), '', '"');
                eTag1 = '"' || headerLine || '"';
                eTag2 = "'" || eTag1 || "'";
                call symputx('_resource_etag', compress(eTag2));
            end;
        run;
    %end;
    %else %do;
        %put ERROR: The resource could not be found. The API responded with &SYS_PROCHTTP_STATUS_CODE.: SYS_PROCHTTP_STATUS_PHRASE.;
    %end;

    filename hdrOut clear;
%mend _retrieve_etag;