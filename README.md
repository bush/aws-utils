# aws-utils

## Dependencies

You need to install this aws api tool:

```
$ sudo npm install -g aws-api-gateway-cli-test
```

If you don't want to install the npm module globally you can change the script
to call `npx aws-api-gateway-cli-test` instead of `apig-test`.  npx is installed with npm and allows you to call an npm cli tool without installing it globally.  

You also need to install jq on your system.

On mac:

If you don't have brew installed, install it first:

```
$ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null 2> /dev/null
```

then install jq:

```
brew install jq
```

On linux:

```
$ sudo apt-get install jq
```

## Run the environment script

Run the `env.sh` to get call the environment variables setup.  Simple send the ouput to a file named `env` in the same directory that you will run the script.  Before running the script modify the following environment varibles in `env.sh`

```
STAGE="dev"
PROFILE="p2c-dev"
DEFAULT_REGION="us-east-1"
```

### STAGE

`STAGE` referes the lambda deployment stage

### PROFILE

`PROFILE` is your aws profile

### DEFAULT_REGION

`DEFAULT_REGION` is used for the lambda region


Once you have matched the above variables to your environment run the script:

```
$ ./env.sh | tee env
```

## Run the helper scripts

Now you can run the helper scripts.  `api.sh` allows you to call an authenticated lambda api.  `signup.sh` allows you to setup a new cognito user.  Simply run -h on a script to get instructions on how to use it.
