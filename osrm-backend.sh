#!/bin/bash

if [[ $DB_IS_DRIVER != "TRUE" ]]; then

  echo "installing osrm backend server dependencies"
  sudo apt -qq install -y build-essential git cmake pkg-config libbz2-dev libxml2-dev libzip-dev libboost-all-dev lua5.2 liblua5.2-dev libtbb-dev
  
  echo "launching osrm backend server"
  /dbfs/FileStore/osrm-backend/build/osrm-routed --algorithm=MLD /dbfs/FileStore/osrm-backend/maps/united-kingdom/united-kingdom-latest.osrm &
  
  echo "wait until osrm backend server becomes responsive"
  res=-1
  i=1

  # while no response
  while [ $res -ne 0 ]
  do

    # test connectivity
    curl --silent "http://127.0.0.1:5000/route/v1/driving/-0.00080678,51.47781737;0.07229157,51.26704151"
    res=$?
    
    # increment the loop counter
    if [ $i -gt 40 ] 
    then 
      break
    fi
    i=$(( $i + 1 ))

    # if no response, sleep
    if [ $res -ne 0 ]
    then
      sleep 30
    fi

  done  
  
fi
