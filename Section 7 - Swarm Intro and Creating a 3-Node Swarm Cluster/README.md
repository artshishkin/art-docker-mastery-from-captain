####  Section 7: Swarm Intro and Creating a 3-Node Swarm Cluster

#####  63. Create Your First Service and Scale It Locally

1.  Check Swarm Mode
    -  `docker info` -> 
    -  view `Swarm: inactive`
2.  Initialize Swarm
    -  `docker swarm init`
    -  response
        -  Swarm initialized: current node (tqekx9ytjb7f7huc00c6quizi) is now a manager.
        -  To add a worker to this swarm, run the following command:
            -  `docker swarm join --token SWMTKN-1-4yja8jql2ittudvja5rglsrwufaultm3p1a1li0ncm074mez6r-727umacaalu22016idybmfvt7 192.168.65.3:2377`
        -  To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
3.  List of nodes
    -  `docker node ls`
        -  ID                            HOSTNAME         STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
        -  tqekx9ytjb7f7huc00c6quizi *   docker-desktop   Ready     Active         Leader           20.10.2
4.  `docker node --help`
5.  `docker swarm --help`
6.  `docker service --help` - `service` in a Swarm replaces the `docker run` command
7.  Create simple service to ping Google DNS server
    -  `docker service create alpine ping 8.8.8.8`
        -  `uflpabs8gh2stj1aanu3lfdnu` - this is NOT a container ID, it's service JD
        -  `overall progress: 1 out of 1 tasks`
        -  `1/1: running   [==================================================>]`
        -  `verify: Service converged`
    -  `docker service ls` -> 
        -  ID: `uflpabs8gh2s`
        -  REPLICAS: 1/1 - how many actually running / count of specified to run
    -  `docker service logs -f`
8.  View tasks/containers of service
    -  `docker service ps agitated_mirzakhani`
        -  `ID             NAME                    IMAGE           NODE             DESIRED STATE   CURRENT STATE         ERROR     PORTS`
        -  `im52pd7y70ui   agitated_mirzakhani.1   alpine:latest   docker-desktop   Running         Running 2 hours ago`            
    -  present NODE, STATEs columns
9.  Make 3 replicas of a service
    -  `docker service update --replicas 3 agitated_mirzakhani`
        -  `overall progress: 3 out of 3 tasks`
        -  `1/3: running   [==================================================>]`
        -  `2/3: running   [==================================================>]`
        -  `3/3: running   [==================================================>]`
        -  `verify: Service converged`
    -  `docker service ls` -> see REPLICAS 3/3
    -  `docker service ps agitated_mirzakhani` - all containers of this service
10.  Compare update command for container and service
    -  `docker container update --help`
    -  `docker service update --help` - much more options
11.  Swarm spin up containers
    -  remove one container
        -  `docker container rm -f agitated_mirzakhani.1.im52pd7y70uidyaixfemg6ug7`
    -  view Swarm containers
        -  `docker service ls` - REPLICAS **2/3**
    -  wait 5 sec
    -  `docker service ls` - REPLICAS **3/3**
    -  `docker service ps agitated_mirzakhani` - shows history of containers
        -  ID             NAME                        IMAGE           NODE             DESIRED STATE   CURRENT STATE         ERROR                         PORTS
        -  b5avlgsgy0mj   agitated_mirzakhani.1       alpine:latest   docker-desktop   Running         Running 2 hours ago
        -  k510ij98mbsl    \_ agitated_mirzakhani.1   alpine:latest   docker-desktop   Shutdown        Failed 2 hours ago    "task: non-zero exit (137)"
        -  im52pd7y70ui    \_ agitated_mirzakhani.1   alpine:latest   docker-desktop   Shutdown        Failed 2 hours ago    "task: non-zero exit (137)"
        -  cfb96gicuf9n   agitated_mirzakhani.2       alpine:latest   docker-desktop   Running         Running 2 hours ago
        -  x3v4qhac2bbf   agitated_mirzakhani.3       alpine:latest   docker-desktop   Running         Running 2 hours ago    
12.  Stopping service
    -  `docker service rm agitated_mirzakhani`
    -  `docker container ls` -> containers are still there
    -  wait some time
    -  `docker container ls` -> containers are gone
                      
                                        