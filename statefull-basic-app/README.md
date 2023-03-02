Repo for a todo app statefull application with Quarkus and Postgresql

# Quickstart

```shell
git clone https://github.com/feven-redhat/statefull-basic-app.git
cd statefull-basic-app
```

## local environment

```shell
podman run --name postgres-db -e POSTGRES_USER=feven -e POSTGRES_PASSWORD=redhat -p 5432:5432 -d postgres
```

```shell
mvn quarkus:dev
```

## Openshift

```shell
oc apply -f manifest/todo-app.yaml
oc apply -f  manifest/postgres.yaml
oc apply -f manifest/quarkus-app-config.yaml
oc create secret generic postgres-credentials -n todo-demo    --from-literal=POSTGRES_USER=task-user     --from-literal=POSTGRES_PASSWORD=mysecretpassword     --from-literal=POSTGRES_DB=task     --from-literal=POSTGRES_PORT=5432
```
Get the url

```shell
oc get route -n todo-demo -o json | jq -r '.items[0].spec.host' | sed 's/^/https:\/\//'
```

# DIY Package the app

```shell
cd todo-demo

./mvnw package

podman build -f src/main/docker/Dockerfile.jvm -t quay.io/feven/todoapp:latest .
podman tag quay.io/feven/todoapp:latest quay.io/feven/todoapp:$APP_VERSION
podman push quay.io/feven/todoapp:$APP_VERSION
podman push quay.io/feven/todoapp:latest   
```

# Clean

```shell
oc delete ns todo-demo
```
 
