#!/bin/bash
# set -x
npm install
npm run start-server & npm run test-unit
npm run test-fvt
if jq -e '.services[] | select(.service_id=="draservicebroker")' _toolchain.json; then
    ibmcloud login --apikey ${IBM_CLOUD_API_KEY} --no-region
    ibmcloud doi publishtestrecord --logicalappname ${IMAGE_NAME} --buildnumber=$BUILD_NUMBER --filelocation=./tests/unit-test.json --type=unittest
    ibmcloud doi publishtestrecord --logicalappname ${IMAGE_NAME} --buildnumber=$BUILD_NUMBER --filelocation=./tests/fvt-test.json --type=fvt
fi