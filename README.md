# BookMemo

## Usage

Run these commands from the directory containing this README. Docker Engine and
Docker Compose v2 are required; Java and Gradle run inside the build image.

```bash
cp .env.sample .env
```

Set `POSTGRES_USER`, `POSTGRES_PASSWORD` and `POSTGRES_DB` in `.env` to local
values. `PORT` is the host HTTP port (8080 by default). Compose connects the app
to its PostgreSQL service automatically, so `DB_URL` is only needed for running
Java directly outside Compose.

```bash
docker compose up --build -d
```

Open `http://localhost:8080` (or the configured `PORT`) and create an account.
The default startup initializes roles without creating sample accounts, and
preserves accounts and memos across application restarts. The database is stored
in the Compose project's `dbvol` volume.

To stop the application while keeping the database:

```bash
docker compose down
```

The existing Nginx and Certbot services are optional and use the `tls` profile.
They require domain and certificate configuration before use; they are not
needed for local HTTP startup.

## How to Deploy

```sh
# install lib
sudo apt update
sudo apt upgrade -y
sudo apt install -y uidmap nginx certbot python3-certbot-nginx

# edit nginx conf
sudo vim /etc/nginx/sites-enabled/$DOMAIN
# validate nginx conf
sudo nginx -t

# setting dns at cloud dns

# generate crt files
sudo certbot --nginx -d $DOMAIN -d www.$DOMAIN
# setting certbot renew
sudo crontab -u root -e

# install rootless docker
curl -fsSL https://get.docker.com/rootless | sh
# set rootless docker PATH and Sock
vim .bashrc 
systemctl --user start docekr

# install docker compose
mkdir -p ~/.docker/cli-plugins
curl -L "https://github.com/docker/compose/releases/download/v2.16.0/docker-compose-linux-x86_64" -o ~/.docker/cli-plugins/docker-compose
chmod 744 ~/.docker/cli-plugins/docker-compose

cd bookmemo
# set docker env
vim .env
# run
docker compose build
docker compose up 
# press ctrl + z
bg 1
disown %1
```
