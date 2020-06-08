echo 'Start docker app ..'
FD="$PWD"
cd dockerFiles/
docker build -f  angular11 -t docker_ui_image .
docker container stop docker_ui_container
docker container rm docker_ui_container
docker run -d -v "app":/var/_dockerApp  --name docker_ui_container  docker_ui_image
# docker run -d --name docker_ui_container  docker_ui_image
echo "$FD/app"