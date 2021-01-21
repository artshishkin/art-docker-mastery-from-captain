# art-docker-mastery-from-captain
Tutorial on Udemy - Docker Mastery: with Kubernetes +Swarm from a Docker Captain - from Bret Fisher

####  Section 2: The Best Way to Setup Docker for Your OS

#####  14. Docker for Linux Setup and Tips

-  Link for script for quick & easy install
    -  [https://get.docker.com/](https://get.docker.com/)
    -  `curl -fsSL https://get.docker.com -o get-docker.sh`
    -  `sh get-docker.sh`
-  Install docker-machine
    -  [Install Docker Machine](https://docs.docker.com/machine/install-machine/)
```shell script
base=https://github.com/docker/machine/releases/download/v0.16.0 &&
  curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine &&
  sudo mv /tmp/docker-machine /usr/local/bin/docker-machine &&
  chmod +x /usr/local/bin/docker-machine
```
-  Install Docker Compose
    -  [Install Docker Compose](https://docs.docker.com/compose/install/)
    -  `sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose`
    -  `sudo chmod +x /usr/local/bin/docker-compose`
    -  **or**
    -  `https://github.com/docker/compose/releases`
    -  use installation from there
-  Customize shell (Optional)
    -  [Sweet Shell: With Oh-My-Zsh, SpaceVim, Gruvbox, True Color, and Demo Mode. For macOS, Linux, and Windows 10](https://www.bretfisher.com/shell/)    
    
#####  18. Check Our Docker Install and Config

-  `docker version`
-  `docker info`
-  `docker` - list of available commands
-  docker command line structure:
    -  old (still works): `docker <command> (options)` - ex.: docker run ...   
    -  new: `docker <command> <sub-command> (options)` - ex.: docker container run ...   
    
#####  19. Starting a Nginx Web Server

-  `docker container run --publish 80:80 nginx`
-  `docker container run --publish 80:80 --detach nginx`
-  `docker container ls` - list running containers
-  `docker container stop 52` - few digits are enough for container with ID `52fe11b4e90c`
-  `docker container ls -a` - list running and stopped containers
-  `docker container run --detach --publish 80:80 --name webhost` - give container a name
-  `docker container logs webhost`
-  `docker container top webhost` - list processes inside the container
-  `docker container --help` - all sub-commands of `container` command
-  `docker container rm ef6 52f 596` - remove containers (must be stopped) 
-  `docker container rm ef6 52f 596 -f` - force remove containers (can remove even running) 

#####  21. Container VS. VM: It's Just a Process

-  `docker container run --name mongo -d mongo`
-  `docker container top mongo`
-  response
    -  `PID                 USER                TIME                COMMAND`
    -  `3236                999                 0:00                mongod --bind_ip_all`
-  just a process
-  `ps aux` - show me all running processes on host (Linux)
-  will see mongod
-  `999      20238  4.8  2.6 1579620 105960 ?      Ssl  12:03   0:01 mongod --bind_ip_all`
-  `ps aux | grep mongo` - list processes filtered by mongo

#####  23. Assignment: Manage Multiple Containers

-  `docker container run --name nginx --detach --publish 80:80 nginx`
-  `docker container run --name httpd --detach --publish 8080:80 httpd`    
-  `docker container run --env MYSQL_RANDOM_ROOT_PASSWORD=yes --name mysql --detach --publish 3307:3306 mysql`
-  `docker container logs mysql` - to view generated password in logs

#####  25. What's Going On In Containers: CLI Process Monitoring

1.  Start containers
    -  `docker container run --name nginx -d nginx`
    -  `docker container run --name mysql -d -e MYSQL_RANDOM_ROOT_PASSWORD=true mysql`
2.  top
    -  `docker container top mysql`
    -  `docker container top nginx`
3.  inspect    
    -  `docker container inspect mysql`
    -  `docker container inspect nginx`
4.  stats
    -  `docker container stats` - cpu, memory usage of all containers  

#####  26. Getting a Shell Inside Containers: No Need for SSH

1.  Command `it`
    -  `docker container run --help`
        -  `-t, --tty                            Allocate a pseudo-TTY`
        -  `-i, --interactive                    Keep STDIN open even if not attached`
        -  `docker container run [OPTIONS] IMAGE [COMMAND] [ARG...]`
    -  `docker container run -it --name proxy nginx bash`
        -  `ls -al` - view files
        -  `exit` - exit from bash
    -  `docker ps`
    -  **container __proxy__ is stopped**
    -  because we changed the default command
    -  `"/docker-entrypoint.sh bash"` but was `"/docker-entrypoint.sh nginx -g 'daemon off;"'
    -  `docker container run --name ubuntu -it ubuntu` -> bash is default no need to add at the end
    -  `apt-get update`
    -  `apt-get install -y curl`
    -  `exit` -> container stops
    -  `docker container start --help`
        -  `-a, --attach               Attach STDOUT/STDERR and forward signals`
        -  `-i, --interactive          Attach container's STDIN`
    -  `docker container start -ai ubuntu`
    -  `curl google.com`
    -  `exit`
2.  Command `exec`
    -  `docker container exec --help`
    -  `docker container exec -it mysql bash`
        -  `apt-get update && apt-get install -y procps` - install `ps`
        -  `ps aux`
    -  `exit`
    -  still runs
3.  Alpine image
    -  `docker pull alpine`
    -  `docker image ls`
    -  `alpine                                               latest           7731472c3f2a   5 days ago     5.61MB`
    -  `docker container run -it alpine bash`
        -  **got an error**
        -  `docker: Error response from daemon: OCI runtime create failed: container_linux.go:370: starting container process caused: exec: "bash": executable file not found in $PATH: unknown.`       
    -  `docker container run -it alpine sh`
    -  `apk` - alpine's install manager
    
#####  27. Docker Networks: Concepts for Private and Public Comms in Containers

1.  publish
    -  `docker container run -p 80:80 --name webhost -d nginx`
2.  port    
    -  `docker container port webhost`
        -  `80/tcp -> 0.0.0.0:80`
3.  inspect format        
    -  `docker container inspect --format "{{ .NetworkSettings.IPAddress }}" webhost` - filter like JSONPath
        -  `172.17.0.2` - **not** like local address of host machine        
    
#####  29. Docker Networks: CLI Management of Virtual Networks

1.  List networks
    -  `docker network ls`
        -  `NETWORK ID          NAME                DRIVER              SCOPE`
        -  `5fdac00ce9db        bridge              bridge              local`
        -  `0ff20076244a        host                host                local`
        -  `ccdb0e91ac9e        none                null                local`    
2.  Inspect
    -  `docker network inspect bridge`
3.  Create network
    -  `docker network create my_app_net` - creates network with driver bridge (default)
    -  `docker network create --help`
        -  has `--driver` option
4.  Run container in new network
    -  `docker container run -d --name new_nginx --network my_app_net nginx`
5.  Connect container to network
    -  `docker network --help`
    -  `docker network connect my_app_net webhost`
    -  `docker container inspect webhost` -> 2 networks
        -  "bridge": 172.**17**.0.2
        -  "my_app_net": 172.**18**.0.3
6.  Disconnect container from network
    -  `docker network disconnect my_app_net webhost`
    -  `docker container inspect webhost` -> 1 network - bridge    
        
#####  30. Docker Networks: DNS and How Containers Find Each Other

1.  Create new container
    -  `docker container run -d --name my_nginx --network my_app_net nginx:alpine`
2.  Inspect network
    -  `docker network inspect my_app_net` -> 2 containers:
        -  `new_nginx`
        -  `my_nginx`
3.  DNS resolution
    -  `docker container exec -it my_nginx ping new_nginx`
        -  `PING new_nginx (172.18.0.2): 56 data bytes`
        -  `64 bytes from 172.18.0.2: seq=0 ttl=64 time=2.889 ms`

#####  31. Assignment: Using Containers for CLI Testing

1.  Use different Linux distro containers to check `curl` cli tool version
2.  Use two different terminal windows to start bash in both `centos:7` and `ubuntu:14.04`, using -it
3.  Learn the `docker container --rm` option so you can save cleanup
4.  Ensure `curl` is installed and on latest version for that distro
    -  ubuntu: `apt-get update && apt-get install curl`
    -  centos: `yum update curl`

Solution
-  for centos
    -  `docker container run -it --rm centos:7`
    -  `curl --version`
        -  `curl 7.29.0 (x86_64-redhat-linux-gnu) libcurl/7.29.0 NSS/3.44 zlib/1.2.7 libidn/1.28 libssh2/1.8.0`
    -  `yum update curl`
    -  `curl --version`
        -  `curl 7.29.0 (x86_64-redhat-linux-gnu) libcurl/7.29.0 NSS/3.53.1 zlib/1.2.7 libidn/1.28 libssh2/1.8.0`
    -  `exit`
    -  `docker ps -a` -> container absent
    -  `docker image ls` -> present
-  for ubuntu
    -  `docker container run -it --rm ubuntu:14.04`
    -  `curl --version`
        -  `bash: curl: command not found`
    -  `apt-get update && apt-get install curl`
    -  `curl --version`    
        -  `curl 7.35.0 (x86_64-pc-linux-gnu) libcurl/7.35.0 OpenSSL/1.0.1f zlib/1.2.8 libidn/1.28 librtmp/2.3`    

#####  34. Assignment: DNS Round Robin Test

We can have multiple containers on a created network respond to the same DNS address
1.  Create a new virtual network (default bridge driver)
    -  `docker network create network_elasticsearch`
2.  Create two containers from elasticsearch:2 image
    -  `docker container run -d --network network_elasticsearch --network-alias search elasticsearch:2`    
    -  twice
    -  **or** use `--net` instead of `--network`    
3.  Research and use `--network-alias search` when creating them to give them an additional DNS name to respond to
4.  Run `alpine nslookup search` with `--net` to see the two containers list for the same DNS name
    -  `docker network connect network_elasticsearch 75b781023e95` - connect alpine container to network 
    -  `docker container inspect 75b781023e95` -> two networks
    -  `docker container start -ai 75b781023e95`
    -  `docker network inspect network_elasticsearch` -> 3 running containers (test from another shell)
    -  in alpine sh run `nslookup search`        
        -  `Server:         127.0.0.11`
        -  `Address:        127.0.0.11:53`
        -  `Non-authoritative answer:`
        -  `*** Can't find search: No answer`
        -  `Non-authoritative answer:`
        -  `Name:   search`
        -  `Address: 172.19.0.3`
        -  `Name:   search`
        -  `Address: 172.19.0.2`
    -  **or**
    -  `docker container run --rm  --net network_elasticsearch alpine nslookup search`
5.  Run `centos curl -s search:9200` with `--net` multiple times until you see both "name" fields show
    -  `docker container run --rm --network network_elasticsearch centos curl -s search:9200`
    -  **or** use `--net` instead of `--network`    
```json
{
  "name" : "Thunderball",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "xaUroCScQAi0TJX_04inKQ",
  "version" : {
    "number" : "2.4.6",
    "build_hash" : "5376dca9f70f3abef96a77f4bb22720ace8240fd",
    "build_timestamp" : "2017-07-18T12:17:44Z",
    "build_snapshot" : false,
    "lucene_version" : "5.5.4"
  },
  "tagline" : "You Know, for Search"
}
```

#####  38. Images and Their Layers: Discover the Image Cache

-  `docker history nginx:latest` - history of the image layers
-  `docker history mysql` - other layers
-  `docker image inspect nginx`
    -  `"CMD [\"nginx\" \"-g\" \"daemon off;\"]"` - command by default
-  Images are made up of file system changes and metadata
-  Each layer is uniquely identified (SHA) and only stored once on a host
-  This saves storage space on host and transfer time on push/pull
-  A container is just a single read/write layer on top of image
-  `docker image history` and `inspect` commands can teach us    

#####  39. Image Tagging and Pushing to Docker Hub

1.  Tags 
    -  `docker image tag --help`
    -  `docker image ls` - no name column -> images do not have names technically
    -  to address image we must have 3 peaces of info `<user>/<repo>:<tag>`
    -  official images have no `<user>` part
    -  `docker pull mysql/mysql-server`
    -  TAG is not a version. It is like Git tag. It is a pointer to a specific image commit.
    -  `docker pull nginx:mainline` -> already downloaded -> compare by image id
        -  `mainline: Pulling from library/nginx`
        -  `Digest: sha256:10b8cc432d56da8b61b070f4c7d2543a9ed17c2b23010b43af434fd40e2ca4aa`
        -  `Status: Downloaded newer image for nginx:mainline`
        -  `docker.io/library/nginx:mainline`
2.  Create own tag of an image
    -  `docker tag nginx artarkatesoft/nginx`
    -  `docker image ls` -> view `artarkatesoft/nginx`    
    -  `docker push artarkatesoft/nginx`
        -  `Using default tag: latest`
        -  `The push refers to repository [docker.io/artarkatesoft/nginx]`
        -  `85fcec7ef3ef: Preparing`
        -  `3e5288f7a70f: Preparing`
        -  `56bc37de0858: Preparing`
        -  `1c91bf69a08b: Preparing`
        -  `cb42413394c4: Preparing`
        -  `denied: requested access to the resource is denied`
    -  Need to login
3.  Login    
    -  `docker login` -> enter username and pass
    -  credentials are stored in filesystem so it is better to logout (if you do not trust working station (PC))
    -  `docker logout`
4.  Push image    
    -  `docker push artarkatesoft/nginx` -> success
        -  `latest: digest: sha256:0b159cd1ee1203dad901967ac55eee18c24da84ba3be384690304be93538bea8 size: 1362`
5.  Give new tag to my tagged image
    -  `docker tag artarkatesoft/nginx artarkatesoft/nginx:testing`
    -  `docker push artarkatesoft/nginx:testing`
        -  `The push refers to repository [docker.io/artarkatesoft/nginx]`
        -  `85fcec7ef3ef: Layer already exists`
        -  `3e5288f7a70f: Layer already exists`
        -  `56bc37de0858: Layer already exists`
        -  `1c91bf69a08b: Layer already exists`
        -  `cb42413394c4: Layer already exists`
        -  `testing: digest: sha256:0b159cd1ee1203dad901967ac55eee18c24da84ba3be384690304be93538bea8 size: 1362`
    -  Awesome savings
6.  Private repo
    -  first create private repo
    -  then push to it                 
                        