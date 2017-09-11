
# Mongo Docker

For details on the Mongo Docker configuration, please check: [Mongo Docker Official Site][1]

## Configure the Mongo Docker Container

1. (Optional) Copy the setenv.sh.orig to setenv.sh

2. (Optional) Uncomment following variables in the setenv.sh to customize the values:

| Variable                | Description                                                        |
| ----------------------- | ------------------------------------------------------------------ |
| `DOCKER_CONTAINER_NAME` | Name of the Mongo container, default is "mongo"                    |
| `MONGO_DATA`            | Folder to persist the data, default is $currentFolder/mongo_data   |
| `MONGO_PORT`            | Port of the Mongo DB, default is 27017                             |


## Start the Mongo Docker Container

Run following command:
```
./run_mongo.sh
```

## Stop the Mongo Docker Container

Run following command:
```
docker stop `$DOCKER_CONTAINER_NAME`
```

## Create new admin DB user

1. Connect to the docker admin shell:
```
docker exec -it `$DOCKER_CONTAINER_NAME` mongo admin
```

2. Run following command to create an admin user `test` with password `p`:
```
db.createUser({user: 'test', pwd: 'p', roles: [{role: "userAdminAnyDatabase", db: "admin"}]});
```

[1]: https://hub.docker.com/_/mongo/
