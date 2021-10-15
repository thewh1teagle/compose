#!/usr/bin/bash
cd "$(dirname "$(realpath "$0")")";

declare -a services=(
    "serviceName"
)

case $1 in 
    "start")
        for service in ${services[@]}; do
            pushd $service
            if [[ $2 == "--build" ]]; then
                docker-compose up -d --build
            else
                docker-compose up -d
            fi
            if [[ `docker-compose logs` =~ "Err" ]]; then
                echo "[ERROR] $service"
                popd && exit 1
            fi
            popd
        done
        ;;
    
    "stop")
        for service in ${services[@]}; do
            pushd $service
            docker-compose down
            popd
        done
        ;;
    
    "status")
        for service in ${services[@]}; do
            pushd $service
            docker-compose logs
            popd
        done
        ;;
    *)
        echo "No command specified"
        exit 1
esac