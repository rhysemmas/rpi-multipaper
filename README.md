# rpi-multipaper

* Build `builder`:

``` shell
docker buildx build --push --platform=linux/arm64 --tag rhysemmas/multipaper-builder:arm64-1.20.1 ./builder
```

* Build `leader`:

``` shell
docker buildx build --push --platform=linux/arm64 --tag rhysemmas/multipaper-leader:arm64-1.20.1 ./leader
```

* Build `server`:

``` shell
docker buildx build --push --platform=linux/arm64 --tag rhysemmas/multipaper-server:arm64-1.20.1 ./server
```

