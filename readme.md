This is a documentation made for following the process of this test.
It has been done using the Windows10 OS, with no Windows Subsystem for Linux (WSL) installed.

0. Test screen code:

(This html code has been updated on the link 'https://gist.githubusercontent.com/NathanVital/154509458111bf60f9991fd739231b8f/raw/c9d1975f0734ca92414d691a005828566939756b/index.html'
It will be used as another test subject for this test.

The code written inside 'index.html' is going to be used if the project ever requires a database-container volume driven project.
)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

1. 

At first, the test api have been built using React.JS using the port nº 3001. The idea is to keep it simple, as a simple second test object.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
2. Dockerfile & network:

I've downloaded nginx's LTS through the command 'docker pull nginx' through the Docker hub. 

Using the command 'docker network create test-network' is going to create the network where we'll run our containers after we provide it as an option.

Now, to get the Container running, i'll use:
- 'docker run -p 3010:80 -d --name nginxTest0 --net test-Network nginx'.
<!-- Personal note for this command - structured mode: 
docker run -d \
> -p 3010:80
> --name nginxTest
> --net test-Network
> nginx
-->
and then get check the log with 'docker logs <ID>' (It is also possible to search for it using the ID given by 'docker container ls' command)

In case there's already another container running on the same port, you can stop it and then remove it.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
3. Docker Compose:

-to start the docker-compose yaml file use the command 'docker-compose -f nginx.yaml up'
the 'up' part is responsible for starting all the containers registered in the nginx.yaml file.

Here i'll stop every container that's running to check if the nginx.yaml file is working.
It takes a few seconds to start, you'll notice it's working after seeing the information log that's shown to you through the terminal.

It's worth to notice that if you're starting more than one container, the logs may be mixed up, it is possible to distinguish them via log information.

On another terminal, be sure to check the Docker network using 'docker network ls'.

-to stop the containers and network using docker-compose (it's going to stop every container it is responsible for) use the command 'docker-compose -f nginx.yaml down'
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
4. Dockerfile - Custom Docker Image.

I'd like to use Jenkins for this part, but i'll simulate what it does: how it packages into a docker image on the local enviroment.

For this let's copy the contents of our application into the dockerfile. It could be an artifact, but as we don't have that many files, i'll copy them directly into the image using it.
It is based on the existing Nginx and Node:13-alpine images.

A few quick notes: 
- enviroment variables won't be written outside of the docker compose file, as it is easier to override it instead of rebuilding the image.
- the 'RUN' command line's going to create a directory INSIDE of the CONTAINER. This way, every command will apply to the container environment instead of the host environment.
- the 'COPY' command is going to execute on the HOST machine. This way it is possible to copy files inside the host environment into the container environment.

- be sure that you're using the correct directory on the dockerfile's CMD line.

I'm going to run the command 'docker build -t my-app:V1.0 .' to build the Docker image. It's going to install the node:13-alpine in case you don't have it already. 

Check the image with 'docker images'. If you've used exactly the same command as i did, it should be an image called "my-app" within the tag "V1.0".

Now let's run the container with the command 'docker run my-app:1.0'
In case the run hasn't been successful, check the Dockerfile. 

You also must remove the previous build using 'docker rmi <ID>' on a STOPPED container.

You may also use 'docker rm <ID>'. Build it again after fixing it and try to run.

-To enter the container, use 'docker exec -it <ID> /bin/sh'.  This is a way to verify the specifications.
We can check the directory made within the 'RUN' line with 'ls /home/app/'
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
5. Pushing the Docker Image into a private AWS registry - TEST -

After creating such repository (Ex: on AWS, using ECR) you must push the image into it. First, you must log into the repository and authenticate yourself. IF the image has been built and pushed from a Jenkins server, you must give it Jenkins credentials to log into it. 

- (On AWS, you must have a AWS CLI installed and use the given configured credentials.)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
6. Starting the application on development servers:

Check the nginx.yaml file and provide the image that has been uploaded on the private repository. If you try to use the same built-in image, Docker will think this image belongs to DockerHub.io .

Now you must set the docker-compose file avaliable on the Development Server. Create a .yaml file on the desired terminal and copy the nginx.yaml file content that's to be used.
You can start the desired containers using the Docker Compose command (previously shown on Section 4.)


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
10. Extra points:
- Image Naming in Docker registries normally follows:
    registryDomain/imageName:tag
Examples:
- DockerHub: 
    - docker pull Nginx:3.1
    - docker pull docker.io/library/mongo:4.4
- AWS ECR:
    - docker pull <Registry_Domain>:<tag>



- To load changes in application through Docker, you must build a new image. If trying to use the same tag, be sure to delete any containers (be sure to stop them first) using said image, as well deleting the previous, older image after that.

<!-- Just in case you need to use a MongoDB image, here's the spec's command running on the 'mongo' image and default (27017) port:
-------------------------
docker run -d\
--name mongodb \
-p 27017:27017
-e MONGO-INITDB_ROOT_USERNAME
=admin \
-e MONGO-INITDB_ROOT_USERNAME
= password \
--net mongo-network\

mongo
-------------------------

this network in specific must be created if ever used.

------------------------- MongoDB Express:
docker run -d\
--name mongo-express \
-p 8080:8080
-e ME_CONFIG_MONGODB_ADMINUSERNAME
=admin \
-e ME_CONFIG_MONGODB_ADMINPASSWORD
= password \
-e ME_CONFIG_MONGODB_SERVER=mongodb \

--net mongo-network\
mongo-express
-------------------------
 -->