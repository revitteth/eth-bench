#!/bin/bash

PROFILE=$1
RPC_URL=$2
PRIVATE_KEY=$3

cat <<EOF > ./profiles.json
{
  "profiles": {
    "$PROFILE": {
      "node_url": "$RPC_URL",
      "key_file": "$PRIVATE_KEY"
    }
  }
}
EOF