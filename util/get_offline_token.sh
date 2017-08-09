#!/bin/bash

echo "Getting offline token..."


CLIENT_SECRET="XXX-XXXX-XXXX-XXXX"
CLIENT_ID="fabric8-online-platform"
PASSWORD="XXXX"
USERNAME="testuser"

SCHEME="https"
KEYCLOAK_TOKEN_URL="sso.prod-preview.openshift.io/auth/realms/fabric8/protocol/openid-connect/token"


echo "client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET&username=$USERNAME&password=$PASSWORD&grant_type=password&scope=offline_access"

TOKENS=$(curl -H "Content-Type:application/x-www-form-urlencoded" -XPOST $SCHEME://$KEYCLOAK_TOKEN_URL --data "client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET&username=$USERNAME&password=$PASSWORD&grant_type=password&scope=offline_access")

echo "Print offline token: $TOKENS"
