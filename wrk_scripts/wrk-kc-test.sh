#!/bin/bash


echo "Running wrk benchmarks..."

CLIENT_SECRET="XXX-XXXX-XXXX-XXXX"
CLIENT_ID="test-client"
USERNAME="XXXXXX"
PASSWORD="XXXXXX"
SCHEME="http"
KEYCLOAK_TOKEN_URL="xxxxxxxxxx.openshiftapps.com/auth/realms/test/protocol/openid-connect/token"
KEYCLOAK_ENTITLEMENT_URL="xxxxxx.openshiftapps.com/auth/realms/test/authz/entitlement/test-client"

echo "Getting access token.."

echo "client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET&username=$USERNAME&password=$PASSWORD&grant_type=password"
TOKENS=$(curl -H "Content-Type:application/x-www-form-urlencoded" -XPOST $SCHEME://$KEYCLOAK_TOKEN_URL --data "client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET&username=$USERNAME&password=$PASSWORD&grant_type=password")
echo "Tokens: $TOKENS"
ACCESS_TOKEN=$(echo $TOKENS | jq .access_token | tr -d '"')

## entitlement
echo "Running performance test against the entitlement endpoint..."
DURATION=60s
CONNECTIONS=400
THREADS=12
wrk -t$THREADS -c$CONNECTIONS -d$DURATION http://keycloak-keycloak-cluster-test.b6ff.rh-idev.openshiftapps.com/auth/realms/test/authz/entitlement/test-client -H "Authorization: Bearer $ACCESS_TOKEN" -s script_kc_authorization.lua


## Access token
echo "Running performance test against access token endpoint..."
DURATION=10s
CONNECTIONS=10
THREADS=1
wrk -t$THREADS -c$CONNECTIONS -d$DURATION $SCHEME://$KEYCLOAK_TOKEN_URL -s script_kc_access_token.lua


echo "Benchmark is completed!"