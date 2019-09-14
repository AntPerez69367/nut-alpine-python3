# nut-alpine-python3
Base image to run https://github.com/blawar/nut on my unraid server using docker.

This image creates a base alpine linux image with python 3.6.8 and adds the dependencies required to run nut. 

When starting this docker you need to define two variables: 

IPADDR: The IP address of your container.
GAMEDIR: The location of your games.
