___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "SS | HTTP GET/POST request sender",
  "brand": {
    "id": "brand_dummy",
    "displayName": ""
  },
  "description": "",
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "GROUP",
    "name": "basic_settings",
    "displayName": "Basic settings",
    "groupStyle": "ZIPPY_OPEN",
    "subParams": [
      {
        "type": "TEXT",
        "name": "domain_name",
        "displayName": "Domain name",
        "simpleValueType": true,
        "alwaysInSummary": true,
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          }
        ],
        "valueHint": "(not set)",
        "help": "Domain for the request. Es: gtm.domain.com"
      },
      {
        "type": "TEXT",
        "name": "endpoint_name",
        "displayName": "Endpoint",
        "simpleValueType": true,
        "valueHint": "(not set)",
        "alwaysInSummary": true,
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          }
        ]
      },
      {
        "type": "RADIO",
        "name": "request_method",
        "displayName": "Request method",
        "radioItems": [
          {
            "value": "GET",
            "displayValue": "GET"
          },
          {
            "value": "POST",
            "displayValue": "POST"
          }
        ],
        "simpleValueType": true
      },
      {
        "type": "RADIO",
        "name": "event_type",
        "displayName": "Request payload type",
        "radioItems": [
          {
            "value": "request_data",
            "displayValue": "Request data"
          },
          {
            "value": "custom_event",
            "displayValue": "Custom event"
          }
        ],
        "simpleValueType": true
      }
    ],
    "help": "Lorem ipsum"
  },
  {
    "type": "GROUP",
    "name": "data_options",
    "displayName": "Data options",
    "groupStyle": "ZIPPY_OPEN",
    "subParams": [
      {
        "type": "TEXT",
        "name": "event_name",
        "displayName": "Event name",
        "simpleValueType": true,
        "valueHint": "custom_event",
        "help": "Lorem ipsum",
        "alwaysInSummary": true,
        "enablingConditions": [
          {
            "paramName": "event_type",
            "paramValue": "custom_event",
            "type": "EQUALS"
          }
        ],
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          }
        ]
      },
      {
        "type": "SIMPLE_TABLE",
        "name": "event_parameters",
        "displayName": "Event parameters",
        "simpleTableColumns": [
          {
            "defaultValue": "",
            "displayName": "Param name",
            "name": "param_name",
            "type": "TEXT"
          },
          {
            "defaultValue": "",
            "displayName": "Param value",
            "name": "param_value",
            "type": "TEXT"
          }
        ],
        "help": "Insert column name and values.",
        "alwaysInSummary": true,
        "enablingConditions": [
          {
            "paramName": "event_type",
            "paramValue": "custom_event",
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "CHECKBOX",
        "name": "add_timestamp",
        "checkboxText": "Add timestamp",
        "simpleValueType": true,
        "displayName": "Timestamp settings",
        "alwaysInSummary": true,
        "help": "Add timestamp column in micros",
        "defaultValue": true
      },
      {
        "type": "TEXT",
        "name": "timestamp_param_name",
        "displayName": "Timestamp parameter name",
        "simpleValueType": true,
        "valueHint": "",
        "defaultValue": "timestamp",
        "alwaysInSummary": true,
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          }
        ],
        "enablingConditions": [
          {
            "paramName": "add_timestamp",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      }
    ],
    "help": "Lorem ipsum"
  },
  {
    "type": "GROUP",
    "name": "debug_options",
    "displayName": "Debug options",
    "groupStyle": "ZIPPY_OPEN",
    "subParams": [
      {
        "type": "CHECKBOX",
        "name": "enable_logs",
        "checkboxText": "Set enableLogs",
        "simpleValueType": true,
        "displayName": "Enable logs",
        "help": "If set to true, then enable logging on GTM debug console.",
        "defaultValue": false,
        "alwaysInSummary": true
      }
    ],
    "help": "Lorem ipsum"
  }
]


___SANDBOXED_JS_FOR_SERVER___

const log = require('logToConsole');
const getTimestampMillis = require('getTimestampMillis');
const queryPermission = require('queryPermission');
const sendHttpRequest = require('sendHttpRequest');
const getAllEventData = require('getAllEventData');


if(data.enable_logs){log('CLIENT-SIDE GTM TAG: TAG CONFIGURATION');}

const script_url = 'https://rawcdn.githack.com/tommasomoretti/cs-http-tag/9471f8feee209bfd3544801fa1940ce796a52063/XMLHttpRequest.js';

const domain = data.domain_name;
if(data.enable_logs){log('👉 Endpoint domain:', domain);}

const endpoint = data.endpoint_name;
if(data.enable_logs){log('👉 Endpoint path:', endpoint);}

const full_endpoint = 'https://' + domain + "/" + endpoint;

const request_method = data.request_method;
if(data.enable_logs){log('👉 Request method:', request_method);}

const event_type = data.event_type;
if(data.enable_logs){log('👉 Request payload type: ' + data.event_type);}

if(data.enable_logs){log('EVENT DATA');}

const timestamp = getTimestampMillis() / 1000;
const timestamp_param_name = data.timestamp_param_name;

var payload_obj = {};
var payload_url = '';

// Request data mode
if (data.event_type === 'request_data') {
  const dataLayer_data = getAllEventData();
  const dataLayer = dataLayer_data[dataLayer_data.length -1]; 
  const event_name = dataLayer.event;
      
  payload_obj.event_name = event_name;
  if(data.add_timestamp){payload_obj[timestamp_param_name] = timestamp;}
  
  payload_obj.dataLayer = dataLayer;
  // payload_obj.page_location = getUrl();
  // payload_obj.page_hostname = getUrl('host');
  // payload_obj.page_path = getUrl('path');
  // payload_obj.page_referrer = getReferrerUrl();
  // payload_obj.page_title = readTitle();  
  
  if(data.enable_logs){log('👉 Request endpoint:', full_endpoint);}
  if(data.enable_logs){log('👉 Request payload:', payload_obj);}
  send_request(full_endpoint, request_method, payload_obj);
  
// Custom event mode
} else {
  const event_name = data.event_name;
  
  payload_obj.event_name = event_name;
  if(data.add_timestamp){payload_obj[data.timestamp_param_name] = timestamp;}
  
  const event_params = data.event_parameters;

  if (event_params != undefined) {
    for (let i = 0; i < event_params.length; i++) {
      const name = event_params[i].param_name;
      const value = event_params[i].param_value;
      payload_obj[name] = value;
    }
  }
    
  // payload_obj.page_location = getUrl();
  // payload_obj.page_hostname = getUrl('host');
  // payload_obj.page_path = getUrl('path');
  // payload_obj.page_referrer = getReferrerUrl();
  // payload_obj.page_title = readTitle();
  
  if(data.enable_logs){log('👉 Request endpoint:', full_endpoint);}
  if(data.enable_logs){log('👉 Request payload:', payload_obj);}
  send_request(full_endpoint, request_method, payload_obj);
}


// Send request
function send_request(endpoint, request_method, payload){                  
  sendHttpRequest(endpoint, {headers: payload,method: request_method})
    .then(()=>{
      if(data.enable_logs){log('🟢 ' + request_method + ' request sent succesfully.');}
      data.gtmOnSuccess();
    })
    .catch((e) => {
      if(data.enable_logs){log('🔴 ' + request_method + ' request not sent.');}
      data.gtmOnFailure();
    });
}


___SERVER_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "read_event_data",
        "versionId": "1"
      },
      "param": [
        {
          "key": "eventDataAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "send_http",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedUrls",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 15/4/2022, 18:17:31


