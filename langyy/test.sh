#!/bin/bash


###### get access_token (expires in 1799 seconds) by using client_id and client_secret
client_id=4V5ZxFgk7BYdIWhGUhMfqdweJyCI6sfj
client_secret=TGlUB0X2mbWJICA2
response=$(curl --data "client_id=${client_id}&client_secret=${client_secret}&grant_type=client_credentials" https://developer.api.autodesk.com/authentication/v1/authenticate --header "Content-Type: application/x-www-form-urlencoded" -k)
IFS=, DIRS=($response)
IFS='"' DD=(${DIRS[2]})
access_token=${DD[3]}
echo $access_token

###### create a bucket named awesome
response=$(curl -k --header "Content-Type:application/json" --header "Authorization: Bearer ${access_token}" --data "{\"bucketKey\":\"hackmanchesterwww\",\"policyKey\":\"transient\"}" https://developer.api.autodesk.com/oss/v2/buckets)
echo $response

###### put a file(test.3ds) into bucket && get the location include urn
file_location=$1
IFS=/ DIRS2=($file_location)
length=${#DIRS2[@]}
file_name=${DIRS2[$length-1]}
echo "${file_location}"
upload_path="https://developer.api.autodesk.com/oss/v2/buckets/hackmanchesterwww/objects/$file_name"
echo "${upload_path}"
response=$(curl --header "Authorization: Bearer ${access_token}" --header "Content-Length: 308331" -H "Content-Type:application/octet-stream" --header "Expect:" --upload-file "${file_location}" -X PUT "${upload_path}" -k)
IFS=, DIRS3=($response)
IFS='"' DIRS4=(${DIRS3[1]})
urn=${DIRS4[3]}
echo ${urn}
###### convert urn to base64 format
urn_converted=$(python -c "import base64;print base64.b64encode('${urn}');")
urn_converted=$(echo ${urn_converted} )
echo $urn_converted

###### register the data with the viewing service
response=$(curl -k -H "Content-Type: application/json" -H "Authorization: Bearer ${access_token}" -i -d "{\"urn\":\"$urn_converted\"}" https://developer.api.autodesk.com/viewingservice/v1/register)
echo $response

###### check the registration status
response=$(curl -k -i -H "Authorization: Bearer ${access_token}" -X GET \
https://developer.api.autodesk.com/viewingservice/v1/${urn_converted}/status)
echo $response

###### get a thumbnail
response=$(curl -k -H "Authorization: Bearer $access_token" -X GET \
https://developer.api.autodesk.com/viewingservice/v1/thumbnails/$urn_converted  > /Users/langyiying/Desktop/hackproject/thumb.png)


