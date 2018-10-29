#!/bin/bash

#defaults
STAGE="dev"
PROFILE="p2c-dev"
DEFAULT_REGION="us-east-1"
USERNAME="admin@example.com"
PASSWORD="Passw0rd!"
BODY="{}"

help ()
{
  echo "Usage: $0 [-h] [-a aws-profile] [-u username] [-p password] <method> <path>"
  echo "$0 -p p2c-prod -u admin@example.com -p Passw0rd! GET notes"
}

while getopts ":hr:p:" option; do
  case "$option" in
    h)
        help
        exit 0
        ;;
    a)
        PROFILE="$OPTARG"
        ;;
    u)
        USERNAME="$OPTAGRG"
        ;;
    p)
        PASSWORD="$OPTAGRG"
        ;;
    b)
        BODY="$OPTAGRG"
        ;;
    :)
        echo "Error: -$OPTARG requires an argument" 
        help
        exit 0
        ;;
    ?)
        echo "Error: unknown option -$OPTARG" 
        help
        exit 0
        ;;
  esac
done

if [ -z "$1" ] || [ -z "$2" ]
then
  help
  exit 0
fi

. ./env

echo "User Pool ID: $USER_POOL_ID"
echo "App Client ID: $APP_CLIENT_ID"
echo "Identity Pool ID: $IDENTITY_POOL_ID"
echo

ENDPOINT="https://$REST_API_ID.execute-api.$DEFAULT_REGION.amazonaws.com/$STAGE"
echo "Calling: $1 $ENDPOINT/$2"
echo "Body: $BODY"
echo

#npx aws-api-gateway-cli-test \
apig-test \
--username=$USERNAME \
--password=$PASSWORD \
--user-pool-id=$USER_POOL_ID \
--app-client-id=$APP_CLIENT_ID \
--cognito-region=$USER_POOL_REGION \
--identity-pool-id=$IDENTITY_POOL_ID \
--invoke-url="https://$REST_API_ID.execute-api.$DEFAULT_REGION.amazonaws.com/$STAGE" \
--api-gateway-region='us-east-1' \
--path-template="/$2" \
--method=$1 \
--body=$BODY



# https://<restApiId>.execute-api.<awsRegion>.amazonaws.com/<stageName>
