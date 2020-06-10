echo 'Start docker app ..'
FD="$PWD"
cd dockerFiles
docker build -f  angular11 -t docker_ui_image .
docker container stop docker_ui_container
docker container rm docker_ui_container
docker run -d -p 3000:3000 -p 4200:4200 -v "$FD/app":/var/_dockerApp  --name docker_ui_container  docker_ui_image