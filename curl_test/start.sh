#!/bin/bash
curl -X GET -H 'Content-Type: application/json' http://172.168.2.106:4243/containers/json?all=1 |python -mjson.tool | grep Id > container_Id
containers=()
for line in `cat container_Id`
do
	if echo $line | grep -q "Id"
		then continue;
	fi	
        #echo ${line:1:64}
        containers=( ${containers[@]} ${line:1:64})
done

echo ${containers[@]}

function start() {
	curl -X POST http://172.168.2.106:4243/containers/$1/start
}

export -f start
parallel start ::: "${containers[@]}"

