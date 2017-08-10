#!/bin/bash

echo "Running vegeta benchmark..."

CLIENT_SECRET="XXXXX-XXXXX-XXXXX-XXXXX"
CLIENT_ID="test-client"

USERNAME="testuser"
PASSWORD="testhector"

SCHEME="https"

KEYCLOAK_TOKEN_URL="172.30.17.248/auth/realms/test/protocol/openid-connect/token"
KEYCLOAK_ENTITLEMENT_URL="172.30.17.248/auth/realms/test/authz/entitlement/test-client"
KEYCLOAK_USERINFO_URL="172.30.17.248/auth/realms/fabric8/protocol/openid-connect/userinfo"
KEYCLOAK_REFRESH_URL="172.30.17.248/auth/realms/fabric8/protocol/openid-connect/token"
KEYCLOAK_GITHUB_TOKEN_URL="172.30.17.248/auth/realms/fabric8/broker/github/token"
MY_SPACE_NAME="MySpace"


#VEGETA_RATE=(10 50 100 150 200 250 300 350 400 450 500)
#VEGETA_DURATION=(30 30 30 30 30 30 30 30 30 30 30)


#echo "POST $SCHEME://$KEYCLOAK_TOKEN_URL" > targets
#echo "client_id=${CLIENT_ID}&client_secret=${CLIENT_SECRET}&username=${USERNAME}&password=${PASSWORD}&grant_type=password" > body.txt

#iter=0
#for i in "${VEGETA_RATE[@]}"
#do
#   echo $i
#   echo $VEGETA_DURATION[$iter]
#   vegeta -profile cpu attack -body=body.txt -header="Content-Type:application/x-www-form-urlencoded" -targets=targets -rate=$i -duration=30s > results_token_$i.bin
#   iter=$(expr ${iter} + 1 )
#   vegeta report -inputs results_token_$i.bin
#
#   sleep 300
#done


VEGETA_RATE=(250 300 350 400 450 500)
VEGETA_DURATION=120s

for i in "${VEGETA_RATE[@]}"
do

   echo "client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET&username=$USERNAME&password=$PASSWORD&grant_type=password"
   TOKENS=$(curl -H "Content-Type:application/x-www-form-urlencoded" -XPOST $SCHEME://$KEYCLOAK_TOKEN_URL --data "client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET&username=$USERNAME&password=$PASSWORD&grant_type=password")
   echo "Tokens: $TOKENS"
   ACCESS_TOKEN=$(echo $TOKENS | jq .access_token | tr -d '"')
   echo "Access token: $ACCESS_TOKEN"


   echo "user info..."
   curl -H "Content-Type:application/json;charset=UTF-8" -XGET $SCHEME://$KEYCLOAK_USERINFO_URL -H "Authorization: Bearer $ACCESS_TOKEN"
   echo "GET $SCHEME://$KEYCLOAK_USERINFO_URL" > targets
   vegeta -profile cpu attack -header="Authorization: Bearer $ACCESS_TOKEN" -header="Content-Type:application/json" -targets=targets -rate=$i -duration=$VEGETA_DURATION > results_userinfo_$i.bin
   cat results_userinfo_$i.bin | vegeta report

   sleep 300
done

#for i in "${VEGETA_RATE[@]}"
#do

#   echo "client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET&username=$USERNAME&password=$PASSWORD&grant_type=password"
#   TOKENS=$(curl -H "Content-Type:application/x-www-form-urlencoded" -XPOST $SCHEME://$KEYCLOAK_TOKEN_URL --data "client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET&username=$USERNAME&password=$PASSWORD&grant_type=password")
#   echo "Tokens: $TOKENS"
#   ACCESS_TOKEN=$(echo $TOKENS | jq .access_token | tr -d '"')
#   echo "Access token: $ACCESS_TOKEN"

#   REFRESH_TOKEN=$(echo $TOKENS | jq .refresh_token | tr -d '"')
#   echo "Refresh token: $REFRESH_TOKEN"
#   curl -H "Content-Type:application/x-www-form-urlencoded" -XPOST $SCHEME://$KEYCLOAK_REFRESH_URL --data "client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET&grant_type=refresh_token&refresh_token=$REFRESH_TOKEN"
#   echo "POST $SCHEME://$KEYCLOAK_REFRESH_URL" > targets
#   echo 'client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET&grant_type=refresh_token&refresh_token=$REFRESH_TOKEN' > body.json
#   vegeta -profile cpu attack -header="Content-Type:application/x-www-form-urlencode" -targets=targets -rate=$i -duration=$VEGETA_DURATION > results_refresh_$i.bin
#   cat results_refresh_$i.bin | vegeta report

#   sleep 300
#done

for i in "${VEGETA_RATE[@]}"
do

  echo "client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET&username=$USERNAME&password=$PASSWORD&grant_type=password"
  TOKENS=$(curl -H "Content-Type:application/x-www-form-urlencoded" -XPOST $SCHEME://$KEYCLOAK_TOKEN_URL --data "client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET&username=$USERNAME&password=$PASSWORD&grant_type=password")
  echo "Tokens: $TOKENS"
  ACCESS_TOKEN=$(echo $TOKENS | jq .access_token | tr -d '"')
  echo "Access token: $ACCESS_TOKEN"

   echo "github token..."
   curl -H "Content-Type:application/json" -XGET $SCHEME://$KEYCLOAK_GITHUB_TOKEN_URL -H "Authorization: Bearer $ACCESS_TOKEN"
   echo "GET $SCHEME://$KEYCLOAK_GITHUB_TOKEN_URL" > targets
   vegeta -profile cpu attack -header="Authorization: Bearer $ACCESS_TOKEN" -header="Content-Type:application/json" -targets=targets -rate=$i -duration=$VEGETA_DURATION > results_github_$i.bin
   cat results_github_$i.bin | vegeta report

   sleep 300
done

for i in "${VEGETA_RATE[@]}"
do

   echo "client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET&username=$USERNAME&password=$PASSWORD&grant_type=password"
   TOKENS=$(curl -H "Content-Type:application/x-www-form-urlencoded" -XPOST $SCHEME://$KEYCLOAK_TOKEN_URL --data "client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET&username=$USERNAME&password=$PASSWORD&grant_type=password")
   echo "Tokens: $TOKENS"
   ACCESS_TOKEN=$(echo $TOKENS | jq .access_token | tr -d '"')
   echo "Access token: $ACCESS_TOKEN"

   echo "entitlement..."
   curl -H "Content-Type:application/json;charset=UTF-8" -XPOST $SCHEME://$KEYCLOAK_ENTITLEMENT_URL --data '{"permissions":[{"resource_set_name":"9bedda80-7ec5-4bac-aee7-dfc0025cddbe"}]}' -H "Authorization: Bearer $ACCESS_TOKEN"
   echo "POST $SCHEME://$KEYCLOAK_ENTITLEMENT_URL" > targets
   echo '{"permissions":[{"resource_set_name":"MySpace"}]}' > body.json
   vegeta -profile cpu attack -body=body.json -header="Authorization: Bearer $ACCESS_TOKEN" -header="Content-Type:application/json" -targets=targets -rate=$i -duration=$VEGETA_DURATION > results_entitlement_$i.bin
   vegeta report -inputs results_entitlement_$i.bin

   sleep 300
done

echo "Benchmark is completed!"