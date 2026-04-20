# Lab 1

## Introduction

In this lab, we will continue to build on the infrastructure that will be used in Lab 2. We will start by running iperf on bare metal servers to make sure that the network is working properly. Then, we will install and start DeathStarBench, a cloud microbenchmark suite, on the bare metal machines. You may read more details about DeathStarBench and its accompanying publication paper here: [DeathStarBench Docs](https://github.com/delimitrou/DeathStarBench/tree/master). After that, we will test DeathStarBench using curl. Finally (in lab2 next week), we will start VMs on the server machine and run iperf and DeathStarBench in the VMs to make sure everything works.

To start the experiments in this Lab, please instantiate the `csc2202-cloud-project` profile with the `lab1` parameter. You can find more details about how to start an experiment in the [Lab 0 documentation](lab0.md#start-an-experiment). This profile will create 2 server machines and 1 client machine. The server machines are named `server0` and `server1`, and the client machine is named `client0`. You can log in to these machines using SSH as before in Lab 0, but remember to enable SSH agent forwarding to access the whole environment from one machine. You can do this by adding the `-A` option to your SSH command, like this:

```bash
ssh -A user@server0
```

## Run iperf on bare metal servers

[iperf3](https://iperf.fr/iperf-doc.php) is a tool for network throughput measurements between two hosts (a client that generates traffic and a server that receives traffic). You'll use iperf to measure the bandwidth between nodes in your experiment to make sure everything is working okay. <br />

On the server side (`server0`), run the iperf3 server:

```console
user@server0:~$ iperf3 -s
-----------------------------------------------------------
Server listening on 5201
-----------------------------------------------------------

```

Then, log in to the client machine and run the iperf3 client:

```console
user@client0:~$ iperf3 -c server0
Connecting to host server0, port 5201
[  5] local 10.10.1.3 port 52942 connected to 10.10.1.1 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec  1.10 GBytes  9.44 Gbits/sec    0   1.43 MBytes       
[  5]   1.00-2.00   sec  1.09 GBytes  9.41 Gbits/sec    0   1.43 MBytes       
[  5]   2.00-3.00   sec   978 MBytes  8.20 Gbits/sec   11   1.05 MBytes       
[  5]   3.00-4.00   sec   945 MBytes  7.93 Gbits/sec    0   1.05 MBytes       
[  5]   4.00-5.00   sec   942 MBytes  7.91 Gbits/sec    0   1.05 MBytes       
[  5]   5.00-6.00   sec   945 MBytes  7.93 Gbits/sec    0   1.05 MBytes       
[  5]   6.00-7.00   sec   942 MBytes  7.91 Gbits/sec    0   1.05 MBytes       
[  5]   7.00-8.00   sec   942 MBytes  7.91 Gbits/sec    0   1.05 MBytes       
[  5]   8.00-9.00   sec   941 MBytes  7.90 Gbits/sec    0   1.05 MBytes       
[  5]   9.00-10.00  sec   942 MBytes  7.91 Gbits/sec    0   1.05 MBytes       
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  9.59 GBytes  8.24 Gbits/sec   11             sender
[  5]   0.00-10.00  sec  9.59 GBytes  8.24 Gbits/sec                  receiver

iperf Done.
```

The server will accept the connection from the client and print the measurement results.

```console
user@server0:~$ iperf3 -s
-----------------------------------------------------------
Server listening on 5201
-----------------------------------------------------------
Accepted connection from 10.10.1.3, port 52926
[  5] local 10.10.1.1 port 5201 connected to 10.10.1.3 port 52942
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-1.00   sec  1.10 GBytes  9.41 Gbits/sec                  
[  5]   1.00-2.00   sec  1.10 GBytes  9.41 Gbits/sec                  
[  5]   2.00-3.00   sec   974 MBytes  8.17 Gbits/sec                  
[  5]   3.00-4.00   sec   944 MBytes  7.92 Gbits/sec                  
[  5]   4.00-5.00   sec   943 MBytes  7.91 Gbits/sec                  
[  5]   5.00-6.00   sec   944 MBytes  7.92 Gbits/sec                  
[  5]   6.00-7.00   sec   943 MBytes  7.91 Gbits/sec                  
[  5]   7.00-8.00   sec   942 MBytes  7.90 Gbits/sec                  
[  5]   8.00-9.00   sec   941 MBytes  7.90 Gbits/sec                  
[  5]   9.00-10.00  sec   943 MBytes  7.91 Gbits/sec                  
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-10.00  sec  9.59 GBytes  8.24 Gbits/sec                  receiver
-----------------------------------------------------------
```

The server and client start printing measurement results around the same time, once both are running.


## Prepare the Server for DeathStarBench
On `server0`, run the following commands to prepare it for deployment of DeathStarBench. This will install some utilities required by the bash scripts.

```bash
sudo apt update
sudo apt install -y python-is-python3 python3-pip libxml2-utils libxml-xpath-perl
```


## Install and Start DeathStarBench on Bare Metal Machines

SSH into the `server0` node.

```bash
# Create the directory for the csc22020 repository. You will have write access to this directory.

sudo mkdir -p /local/repository

sudo chown $USER /local/repository

# Change to the directory and clone the csc2202 repository. You will have write access to this directory.

cd /local/repository

git clone https://gitlab.cranecloud.io/csc-2202-26/csc2202-cloud-project.git -b lab1 # we are using the lab1 branch

cd csc2202-cloud-project/

# This script will set up docker and docker swarm. 
./start_docker.sh

# Deploy the hotel reservation application
sudo docker stack deploy --compose-file hotelreservation.yml hotelreservation

# Check the status of deployment
sudo docker service ls
```

The `start_docker.sh` script will set up Docker and Docker Swarm on the server machines. You will receive outputs similar to the following:

```console
user@server0:/local/repository/csc2202-cloud-project$ ./start_docker.sh
n_servers=2
n_clients=1
Swarm initialized: current node (akqd1nfuvx00nm0t038ddmz4j) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-5f0hbsqhvn89nfw1ep3zxlp64sb22rqpuxly9gzmciwjedbs0f-5frxej9j175s1nmpex9l4i3s8 10.10.1.1:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.

This node joined a swarm as a worker.
ID                            HOSTNAME                                      STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
akqd1nfuvx00nm0t038ddmz4j *   server0.azz.cranecloud-pg0.utah.cloudlab.us   Ready     Active         Leader           26.1.3
9e9wg7ms6njemqj4u9ifcf3m8     server1.azz.cranecloud-pg0.utah.cloudlab.us   Ready     Active                          26.1.3
user@server0:/local/repository/csc2202-cloud-project$ 
```

The `docker stack deploy` command will deploy the hotel reservation application, which is one of the applications in DeathStarBench, on the server machines. The output of this will be similar to the following:

```console
user@@server0:/local/repository/csc2202-cloud-project$ sudo docker stack deploy --compose-file hotelreservation.yml hotelreservation
Since --detach=false was not specified, tasks will be created in the background.
In a future release, --detach=false will become the default.
Creating network hotelreservation_default
Creating service hotelreservation_jaeger
Creating service hotelreservation_memcached-rate
Creating service hotelreservation_geo
Creating service hotelreservation_mongodb-profile
Creating service hotelreservation_search
Creating service hotelreservation_profile
Creating service hotelreservation_mongodb-geo
Creating service hotelreservation_user
Creating service hotelreservation_reservation
Creating service hotelreservation_frontend
Creating service hotelreservation_mongodb-user
Creating service hotelreservation_memcached-profile
Creating service hotelreservation_recommendation
Creating service hotelreservation_mongodb-rate
Creating service hotelreservation_mongodb-recommendation
Creating service hotelreservation_rate
Creating service hotelreservation_memcached-reserve
Creating service hotelreservation_mongodb-reservation
Creating service hotelreservation_consul
```

Make sure all services are running by checking that their replica fractions are full (e.g.: 1/1 or 3/3) before you move to the next section.
```bash
sudo docker service ls
```

## Testing DeathStarBench using curl

Once all services are running, ssh into the client machine. 

```console
user@client0:~$ curl 'http://server0:5000/reservation?inDate=2015-04-19&outDate=2015-04-24&lat=nil&lon=nil&hotelId=9&customerName=Cornell_1&username=Cornell_1&password=1111111111&number=1'
{"message":"Reserve successfully!"}
user@client0:~$ curl 'http://server0:5000/user?username=Cornell_1&password=1111111111'
{"message":"Login successfully!"}
```

You should be able to get the same result.

## Running wrk2 on Client Machine

SSH into the `client0` node.

```bash
# Create the directory for the csc22020 repository. You will have write access to this directory.

sudo mkdir -p /local/repository

sudo chown $USER /local/repository

# Change to the directory and clone the csc2202 repository. You will have write access to this directory.

cd /local/repository

git clone https://gitlab.cranecloud.io/csc-2202-26/csc2202-cloud-project.git -b lab1 # we are using the lab1 branch


```

Many assignments will use `wrk2`, a HTTP benchmarking tool, as the load generator. I have compiled two versions of `wrk2` for x86 and ARM architectures, and they are located in the `wrk2` directory. These are named:

- `wrk2-amd64` for x86 architecture
- `wrk2-arm64` for ARM architecture

You need to check the architecture of your client machine and copy the corresponding version of `wrk2` to the `wrk2` directory on the client machine. You can check the architecture of your machine with the following command:

```console
user@client0:~$ uname -m
```

For mine, I have the ARM architecture, so I will copy the `wrk2-arm` binary for ARM to the `wrk2` directory on the client machine. You can do this with the following command:

```bash
# install the dependency for wrk2, which is the LuaJIT library. This is required to run the Lua scripts that define the request schedule for wrk2.
sudo apt install -y luarocks liblua5.1-dev luajit

cd /local/repository/csc2202-cloud-project/DeathStarBench/hotelReservation/wrk2
cp wrk-arm64 wrk
```

I can now run `wrk2` to generate load to the hotel reservation application. For example, I can run the following command to send requests according to a schedule defined in the `mixed-workload_type_1.lua` script for 10 seconds with 10 threads and 100 connections. The `-R` option specifies the target request rate, which is 2000 requests per second in this case. The `-L` option enables latency recording.


```console
user@client0:~$ cd /local/repository/csc2202-cloud-project/DeathStarBench/hotelReservation
user@client0:/local/repository/csc2202-cloud-project/DeathStarBench/hotelReservation$ ./wrk2/wrk -t 10 -c 100 -d 10 -s ./wrk2/scripts/hotel-reservation/mixed-workload_type_1.lua http://server0:5000 -R 2000 -L
Initialised 10 threads in 8 ms.
Running 10s test @ http://server0:5000
  10 threads and 100 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     3.20s     1.72s    7.02s    58.89%
    Req/Sec        nan       nan   0.00      0.00%
  Latency Distribution (HdrHistogram - Recorded Latency)
 50.000%    3.19s 
 75.000%    4.67s 
 90.000%    5.55s 
 99.000%    6.33s 
 99.900%    6.71s 
 99.990%    6.84s 
 99.999%    7.02s 
100.000%    7.02s 

  Detailed Percentile spectrum:
       Value   Percentile   TotalCount 1/(1-Percentile)

      19.807     0.000000            1         1.00
     814.591     0.100000          769         1.11
    1441.791     0.200000         1536         1.25
    2035.711     0.300000         2304         1.43
    2590.719     0.400000         3071         1.67
    3190.783     0.500000         3837         2.00
    3491.839     0.550000         4221         2.22
    3794.943     0.600000         4607         2.50
    4061.183     0.650000         4988         2.86
    4362.239     0.700000         5379         3.33
    4669.439     0.750000         5760         4.00
    4800.511     0.775000         5949         4.44
    4956.159     0.800000         6139         5.00
    5107.711     0.825000         6334         5.71
    5275.647     0.850000         6525         6.67
    5402.623     0.875000         6714         8.00
    5472.255     0.887500         6812         8.89
    5550.079     0.900000         6909        10.00
    5623.807     0.912500         7004        11.43
    5713.919     0.925000         7105        13.33
    5795.839     0.937500         7196        16.00
    5853.183     0.943750         7245        17.78
    5910.527     0.950000         7292        20.00
    5947.391     0.956250         7340        22.86
    5984.255     0.962500         7390        26.67
    6041.599     0.968750         7435        32.00
    6098.943     0.971875         7459        35.56
    6135.807     0.975000         7482        40.00
    6180.863     0.978125         7506        45.71
    6238.207     0.981250         7530        53.33
    6266.879     0.984375         7557        64.00
    6279.167     0.985938         7566        71.11
    6299.647     0.987500         7583        80.00
    6311.935     0.989062         7590        91.43
    6340.607     0.990625         7602       106.67
    6389.759     0.992188         7614       128.00
    6406.143     0.992969         7623       142.22
    6418.431     0.993750         7626       160.00
    6434.815     0.994531         7632       182.86
    6463.487     0.995313         7638       213.33
    6537.215     0.996094         7644       256.00
    6586.367     0.996484         7647       284.44
    6610.943     0.996875         7650       320.00
    6627.327     0.997266         7654       365.71
    6635.519     0.997656         7658       426.67
    6639.615     0.998047         7659       512.00
    6647.807     0.998242         7660       568.89
    6660.095     0.998437         7662       640.00
    6688.767     0.998633         7663       731.43
    6709.247     0.998828         7665       853.33
    6750.207     0.999023         7666      1024.00
    6754.303     0.999121         7667      1137.78
    6762.495     0.999219         7668      1280.00
    6762.495     0.999316         7668      1462.86
    6787.071     0.999414         7669      1706.67
    6807.551     0.999512         7670      2048.00
    6807.551     0.999561         7670      2275.56
    6823.935     0.999609         7671      2560.00
    6823.935     0.999658         7671      2925.71
    6823.935     0.999707         7671      3413.33
    6836.223     0.999756         7672      4096.00
    6836.223     0.999780         7672      4551.11
    6836.223     0.999805         7672      5120.00
    6836.223     0.999829         7672      5851.43
    6836.223     0.999854         7672      6826.67
    7024.639     0.999878         7673      8192.00
    7024.639     1.000000         7673          inf
#[Mean    =     3198.579, StdDeviation   =     1722.345]
#[Max     =     7020.544, Total count    =         7673]
#[Buckets =           27, SubBuckets     =         2048]
----------------------------------------------------------
  7683 requests in 10.01s, 2.47MB read
Requests/sec:    767.30
Transfer/sec:    252.58KB
```

Note: wrk2 is a open load generator, which means requests are sent according to the schedule. By contrast, in a closed-loop load generator, new requests are triggered by response arrival.

Feel free to run `./wrk2/wrk` to learn the command line options of wrk. Once you finish testing, stop and remove the hotel reservation application via `sudo docker stack rm hotelreservation`.


## Questions 
1. What is the bandwidth between the client and server machines on the bare metal setup? (2 Marks)

2. What is the average latency for the requests sent by `wrk2`? (Hint: you can check the latency numbers when you run `wrk2` with the `-L` option, as shown above.) (2 Marks)

3. Explain the difference between open-loop and closed-loop load generators. Which one is `wrk2`? Give one advantage and one disadvantage of each type of load generator? (4 Marks)

4. How many replicas of each service are running in the hotel reservation application? Why do you think the application is designed this way? (Hint: you can check this with `sudo docker service ls` on the bare metal server) (4 Marks)

5. In the Docker Swarm deployment of the hotel reservation application, which services are running on `server0` and which services are running on `server1`? (Hint: you can check this with `sudo docker service ps <service_name>` on bare metal) Why do you think the services are distributed this way? (2 Marks)

6. Document your lessons learned and any difficulties you encountered while doing this Lab. (3 Marks)