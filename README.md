# docker-iis-arr
Script to set up Docker container running IIS and ARR 

# The ARR rule number one  is set up to route to with filter *1/* to http://1/{R:2} witch means http://servername/1/ will point to the first serverfarm
# and http://servername/2/ will point to the second.

# To build the docker image type  "docker image build --tag myname/docker-iis-arr ." in the docker-iis-arr folder.
# to run it type docker run --publish 80:80 myname/docker-iis-arr