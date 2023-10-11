# ssh on docker 

Run custom docker instance with openssh-server and preset user.

### First steps
- Create .env file on the root directory from example.env file

- Generate ssh keys in ssh_keys directory and save as id_rsa - run `ssh-keygen -f ssh_keys/id_rsa`

Build and start the container 
```
docker compose up -d --build 
```

Get IP of the instance
```
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ubuntu-ssh
```

You can login with password or ssh-key 
```
ssh user@container-ip -i ssh_keys/id_rsa
```