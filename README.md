## Script to set up Docker container running IIS Application Request Routing.
```
To test this container you must choose what two servers to route to, 
this is something i set up to get the diffrent ports sorted,
to be able to route to services that dont use the standard ports.
```
The ARR rule number one is set up to route to server farm 1 by mask *1/* to http://1/{R:2} 
this means http://servername/1/ will point to the first serverfarm and http://servername/2/ will point to the second.

To build the docker image type:
```
"docker image build --tag myname/docker-iis-arr ." 
```
in the docker-iis-arr folder.
to run the container type: 
```
"docker run --publish 80:80 myname/docker-iis-arr"
```
to test it you can type http://localhost/1/ and http://localhost/2/ on the dockerhost.
or change localhost with the servername if you can reach it.