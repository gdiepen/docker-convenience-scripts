#!/bin/bash


echo "List of all volumes:"
echo 

for docker_volume_id in $(docker volume ls -q)
do
	echo "(Un)named volume: ${docker_volume_id}"
	
	
	docker_volume_size=$(docker run --rm -t -v ${docker_volume_id}:/volume_data ubuntu bash -c "du -hs /volume_data | cut -f1" ) 

	echo "    Size: ${docker_volume_size}"
	

	num_related_containers=$(docker ps -a --filter=volume=${docker_volume_id} -q | wc -l)

	if (( $num_related_containers > 0 )) 
	then
		echo "    Connected containers:"
		docker ps -a --filter=volume=${docker_volume_id} --format "{{.Names}} [{{.Image}}] ({{.Status}})" | while read containerDetails
		do
			echo "        ${containerDetails}"
		done
	else
		echo "    No connected containers"
	fi
	
	echo
done
