#!/bin/bash

echo "Testing token endpoint of keycloak..."

CLIENT_SECRET="XXXXX-XXXXX-XXXXX-XXXXX"
CLIENT_ID="test-client"
USERNAME="XXXXXXXX"
PASSWORD="XXXXX"
KEYCLOAK_TOKEN_URL="sso.prod-preview.openshift.io/auth/realms/fabric8-test/protocol/openid-connect/token"
SCHEME="https"


while true; do

  curl -H "Content-Type:application/x-www-form-urlencoded" -XPOST $SCHEME://$KEYCLOAK_TOKEN_URL --data "client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET&username=$USERNAME&password=$PASSWORD&grant_type=password"

done
