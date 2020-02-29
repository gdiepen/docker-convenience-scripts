#!/bin/bash

if [ ! "$(docker images | grep "^<none>" | awk '{print $3}')" ]; then
  echo "No untagged images to remove. Exiting."
  exit 0
fi

echo "Removing all untagged images..."
docker rmi $(docker images | grep "^<none>" | awk '{print $3}')

echo "Done."
