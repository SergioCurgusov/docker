1) Установка Docker:

sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

Для упрощения дадим возможность работать без sudo

sudo usermod -aG docker sergio

Проверяем:

sergio@sergio-Z87P-D3:~$ docker run hello-world

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/

Проверяем docker compose:

sergio@sergio-Z87P-D3:~$ docker compose version
Docker Compose version v2.28.1

Настраиваем автоозапуск при загрузке:

sudo systemctl enable docker.service
sudo systemctl enable containerd.service

2) Поднимаем nginx в docker-контейнере. Используем заранее подготовленне default.conf и index.html в той же дирректории.


sergio@sergio-Z87P-D3:/media/VM/docker$ ls -la
итого 40
drwxrwxr-x  4 sergio sergio 4096 июл 13 15:52 .
drwxrwx--- 22 sergio sergio 4096 июл  7 20:26 ..
-rw-rw-r--  1 sergio sergio  243 июл 13 15:36 default.conf
-rw-rw-r--  1 sergio sergio  390 июл 13 15:55 Dockerfile
-rw-rw-r--  1 sergio sergio   15 июл  7 23:47 index.html
drwxrwxr-x  2 sergio sergio 4096 июл  7 22:26 old
-rw-rw-r--  1 sergio sergio 2191 июл  7 20:48 README.md
-rw-rw-r--  1 sergio sergio 4769 июл 13 15:34 README.txt

sergio@sergio-Z87P-D3:/media/VM/docker$ docker build -t ziclopentan/nginx_alpine_otuslab:nginx .
[+] Building 1.1s (10/10) FINISHED                                                                             docker:default
 => [internal] load build definition from Dockerfile                                                                     0.0s
 => => transferring dockerfile: 450B                                                                                     0.0s
 => [internal] load metadata for docker.io/library/alpine:3.20.1                                                         1.1s
 => [auth] library/alpine:pull token for registry-1.docker.io                                                            0.0s
 => [internal] load .dockerignore                                                                                        0.0s
 => => transferring context: 2B                                                                                          0.0s
 => [1/4] FROM docker.io/library/alpine:3.20.1@sha256:b89d9c93e9ed3597455c90a0b88a8bbb5cb7188438f70953fede212a0c4394e0   0.0s
 => [internal] load build context                                                                                        0.0s
 => => transferring context: 63B                                                                                         0.0s
 => CACHED [2/4] COPY default.conf /etc/nginx/http.d/                                                                    0.0s
 => CACHED [3/4] COPY index.html /var/www/default/html/                                                                  0.0s
 => CACHED [4/4] RUN apk add nginx                                                                                       0.0s
 => exporting to image                                                                                                   0.0s
 => => exporting layers                                                                                                  0.0s
 => => writing image sha256:5a4d87073f648c2dae5427b29546c3a68183a5ef5268713209e76c8698a89c84                             0.0s
 => => naming to docker.io/ziclopentan/nginx_alpine_otuslab:nginx                                                        0.0s
sergio@sergio-Z87P-D3:/media/VM/docker$                                                                         0.0s 

sergio@sergio-Z87P-D3:/media/VM/docker$ docker images
REPOSITORY                         TAG       IMAGE ID       CREATED       SIZE
ziclopentan/nginx_alpine_otuslab   nginx     5a4d87073f64   2 hours ago   11.6MB
sergio@sergio-Z87P-D3:/media/VM/docker$

sergio@sergio-Z87P-D3:/media/VM/docker$ docker run -d --name nginx_app_container -p 8081:80 ziclopentan/nginx_alpine_otuslab:nginx
0e958c2f9af1c5911d1b8b0f279bd9b803235a10e339118344a737a8228de461

sergio@sergio-Z87P-D3:/media/VM/docker$ docker ps -a
CONTAINER ID   IMAGE                                    COMMAND                  CREATED          STATUS          PORTS                                   NAMES
0e958c2f9af1   ziclopentan/nginx_alpine_otuslab:nginx   "nginx -g 'daemon of…"   43 seconds ago   Up 43 seconds   0.0.0.0:8081->80/tcp, :::8081->80/tcp   nginx_app_container
sergio@sergio-Z87P-D3:/media/VM/docker$

Всё работает. Скриншот прилагаю.

Теперь оправим на docker hub:

sergio@sergio-Z87P-D3:/media/VM/docker$ docker login
Log in with your Docker ID or email address to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com/ to create one.
You can log in with your password or a Personal Access Token (PAT). Using a limited-scope PAT grants better security and is required for organizations using SSO. Learn more at https://docs.docker.com/go/access-tokens/

Username: ziclopentan
Password: 
WARNING! Your password will be stored unencrypted in /home/sergio/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credential-stores

Login Succeeded
sergio@sergio-Z87P-D3:/media/VM/docker$

sergio@sergio-Z87P-D3:/media/VM/docker$ docker push ziclopentan/nginx_alpine_otuslab:nginx
The push refers to repository [docker.io/ziclopentan/nginx_alpine_otuslab]
db77947bf342: Pushed 
cca69db0214f: Pushed 
d244ab567db2: Pushed 
94e5f06ff8e3: Pushed 
nginx: digest: sha256:f149a1d6b8cb5f7ab88e928dcb1075c6f055be76b109c410e52739d6f3b02fcd size: 1153
sergio@sergio-Z87P-D3:/media/VM/docker$








