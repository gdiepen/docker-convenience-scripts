#!/bin/bash


echo "List of all volumes:"
echo 

#Loop over all the data volumes
for docker_volume_id in $(docker volume ls -q)
do
	echo "(Un)named volume: ${docker_volume_id}"
	
	#Obtain the size of the data volume by starting a docker container
	#that uses this data volume and determines the size of this data volume	
	docker_volume_size=$(docker run --rm -t -v ${docker_volume_id}:/volume_data alpine sh -c "du -hs /volume_data | cut -f1" ) 

	echo "    Size: ${docker_volume_size}"
	
	#Determine the number of stopped and running containers that
	#have a connection to this data volume
	num_related_containers=$(docker ps -a --filter=volume=${docker_volume_id} -q | wc -l)

	#If the number is non-zero, we show the information about the container and the image
	#and otherwise we show the message that are no connected containers
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
