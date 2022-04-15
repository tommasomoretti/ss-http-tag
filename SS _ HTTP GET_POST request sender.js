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
