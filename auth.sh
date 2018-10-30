#!/bin/bash

. ./env

#aws --profile $PROFILE cognito-idp admin-initiate-auth \
#    --user-pool-id $USER_POOL_ID \
#    --client-id $APP_CLIENT_ID \
#    --auth-flow "ADMIN_NO_SRP_AUTH" \
#    --auth-parameters "USERNAME=admin@example.com,PASSWORD=Passw0rd!"

aws --profile $PROFILE cognito-idp admin-respond-to-auth-challenge \
    --user-pool-id $USER_POOL_ID \
    --client-id $APP_CLIENT_ID \
    --challenge-name "ADMIN_NO_SRP_AUTH" \
    --challenge-responses "USERNAME=admin@example.com,PASSWORD=Passw0rd!"
