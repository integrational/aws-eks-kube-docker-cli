#!/bin/bash
set -Eeo pipefail

if [ -z "$AWS_ACCESS_KEY_ID" ]; then
    echo "Must set AWS_ACCESS_KEY_ID environment variable" 1>&2
    exit 1
fi
if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
    echo "Must set AWS_SECRET_ACCESS_KEY environment variable" 1>&2
    exit 1
fi
if [ -z "$AWS_DEFAULT_REGION" ]; then
    echo "Must set AWS_DEFAULT_REGION environment variable" 1>&2
    exit 1
fi
AWS_DEFAULT_OUTPUT=${AWS_DEFAULT_OUTPUT:=json} # if not set default to json

# Configure the AWS CLI suppressing output to stdout
aws configure > /dev/null << END_AWS_CONFIG
$AWS_ACCESS_KEY_ID
$AWS_SECRET_ACCESS_KEY
$AWS_DEFAULT_REGION
$AWS_DEFAULT_OUTPUT
END_AWS_CONFIG

# Run CMD
exec "$@"
