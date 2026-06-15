# Livox Avia ROS2 Dockerfile

## Description
The Docker container and docker-compose file made to use Livox Avia and connect it to ROS2 inside the Docker container.

## How to use
The Dockerfile is saved inside the Dockerhub, and you can pull the docker container just using this command:

```bash
docker pull yeongyoo/livox_ros2_driver_avia:latest
```
and for the xhost, network connection, you should build the Docker container using the given ```docker-compose.yml```.
```bash
docker compose up -d
```
And for use GUI like Rviz, you must connect the xhost.
```bash
xhost +local:root
```
Then docker container is successfully generated. After physically connecting Livox Avia with your computer, you can write and edit you code inside the container!

If you want to connect your local directory and Docker work environment, you should add something in ```volume```. For example like this:

```yml
    volumes:
      - /tmp/.X11-unix:/tmp/.X11-unix:rw 
      - [THE DIRECTORY OF YOUR REPO]:/workspace
```