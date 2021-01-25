docker network create -d overlay backend
docker network create -d overlay frontend

docker service create --name db --network backend -e POSTGRES_HOST_AUTH_METHOD=trust --mount type=volume,source=db-data,target=/var/lib/postgresql/data --detach postgres:9.4

docker service create --name redis --network frontend --detach redis:3.2

docker service create --name worker --network frontend --network backend --detach bretfisher/examplevotingapp_worker:java

docker service create --name result --network backend -p 5001:80 --detach bretfisher/examplevotingapp_result

docker service create --name vote -p 80:80 --network frontend --replicas 3 --detach bretfisher/examplevotingapp_vote


