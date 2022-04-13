#!/bin/bash

docker-compose down && docker volume rm my-elastic-stack_es-data && cat /dev/null > mount/filebeat/7/usr/share/filebeat/data/registry/filebeat/log.json
