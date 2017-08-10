#!/bin/bash

echo "Getting local access token..."

CLIENT_SECRET="18d87ab1-31b1-4600-96e9-2d1dbeec5e2b"
CLIENT_ID="test-client"
USERNAME="testuser"
PASSWORD="almighty"
KEYCLOAK_TOKEN_URL="192.168.50.4:8080/auth/realms/test/protocol/openid-connect/token"
KEYCLOAK_ENTITLEMENT_URL="192.168.50.4:8080/auth/realms/test/authz/entitlement/test-client"
SCHEME="http"
MY_SPACE_NAME="MySpace"

VEGETA_RATE=(500)
VEGETA_DURATION=60s

for i in "${VEGETA_RATE[@]}"
do

   echo "client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET&username=$USERNAME&password=$PASSWORD&grant_type=password"
   TOKENS=$(curl -H "Content-Type:application/x-www-form-urlencoded" -XPOST $SCHEME://$KEYCLOAK_TOKEN_URL --data "client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET&username=$USERNAME&password=$PASSWORD&grant_type=password")
   echo "Tokens: $TOKENS"
   ACCESS_TOKEN=$(echo $TOKENS | jq .access_token | tr -d '"')
   echo "Access token: $ACCESS_TOKEN"

   echo "entitlement..."
   curl -H "Content-Type:application/json;charset=UTF-8" -XPOST $SCHEME://$KEYCLOAK_ENTITLEMENT_URL --data '{"permissions":[{"resource_set_name":"MySpace"}]}' -H "Authorization: Bearer $ACCESS_TOKEN"
   echo "POST $SCHEME://$KEYCLOAK_ENTITLEMENT_URL" > targets
   echo '{"permissions":[{"resource_set_name":"MySpace"}]}' > body.json
   vegeta -profile cpu attack -body=body.json -header="Authorization: Bearer $ACCESS_TOKEN" -header="Content-Type:application/json" -targets=targets -rate=$i -duration=$VEGETA_DURATION > results_entitlement_$i.bin
   vegeta report -inputs results_entitlement_$i.bin

done


echo "Benchmark is completed!"