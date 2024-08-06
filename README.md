# Yii 2 alá készített docker környezet, frontend/backend/api részegységeihez

## Project telepítése

Linuxnál elsősorban csak: Elérhető a project rootban a MAKEFILE is, make parancs kiadása után lehet válogatni a megfelelő parancsok között, pl `make upd` a docker-compose up -d-t futtatja.

**Mindenféleképp fontos, hogy vagy az egyik, vagy a másik megoldással legyen használva a projekt, vegyesen ne**

### 1. MAKE paranccsal (csak Linux)

`make` vagy `make help` listázza a kiadható parancsokat.

0. **Ha nincs a make feltelepítve: `sudo apt-get install make`**

1. cp .env.sample .env és .env kitöltése a megfelelő értékekkel, ha nem tudod, mik lehetnek ezek, kérj segítséget egy kollegádtól
2. `make upd` -> docker-compose up -d --build parancsot futtatja
3. `make composer` -> composer install-t futtatja.
   Szükség lehet github tokenre, ha kér, csinálni kell egyet a github.com-on, saját profil alatt, és bemásolni.
4. `make npm` -> npm install-t futtatja
5. `make init` -> php init-et futtatja (dotenv környezet)
6. `make migration` -> php yii migration -t futtatja
7`make writables` -> jogosultságot ad számos mappának

#### Opcionális futtatások:

8`make down` -> leállítja a futó konténereket

#### Automatizált telepítés
`make all` -> leállítja a lehetséges futó konténereket, majd végigmegy az összes korábban felsorolt pontokon

#### Adatbázis migrálása sample db-ből


`docker exec -i {project_name} -uusername -pusername project < project.sql`

### Elérhető host-ok

- 127.0.0.1:8080 -> frontend
- 127.0.0.1:8081 -> backend
- 127.0.0.1:8082 -> api
- 127.0.0.1:43238 -> phpMyAdmin

### 2. Dockerrel való telepítés

- {project_root}/.docker/config mappába belépve: `docker-compose up -d -p`

Elvileg, ha kész a build, akkor létre fog jönni egy project-php72-fpm konténer.

Konténerek listázására: `docker ps -a`

Be kell lépni a `docker exec -it project-php72-fpm bash` paranccsal, majd a következő parancsokat kell kiadni:

- `composer install`

Ha github tokent kér, csinálni kell egyet a github.com-on, saját profil alatt, és bemásolni.

- `php init`
    
    - dev,
    - prod    


- `php yii migrate` Adatbázis migrálása

### Elérhető host-ok

- 127.0.0.1:8080 -> frontend
- 127.0.0.1:8081 -> backend
- 127.0.0.1:8082 -> api
- 127.0.0.1:43238 -> phpMyAdmin

Npm van a php-fpm konténerben:

- `npm install`


#### SQL beállítások:

- **New: .env.sample -> .env , majd sql és egyéb paraméterek beállítása**

### Elérhető docker containerek

- project-php72-fpm -> php + composer + node/npm-t tartalmazza
- project-frontend-webserver -> nginx server, frontend mappára (frontend/web/index.php-ra állítva)
- project-backend-webserver -> nginx server, backend mappára
- project-api-webserver -> nginx server api mappára (api lekérések)
- project-reverse-proxy -> az ip-k átfordításra megfelelő domain-ekre
- project-phpmyadmin -> PhpMyAdmin
- project-db-mysql -> mysql 5.6
- project-db-mysql82 -> mysql 8.2

### Migrálás

- `php yii migrate` -> futtatja a migrációs file-okat
- `php yii migrate/create migration-file-neve` -> létrehoz egy új migrációs file-t a console/migration alá, timestamp-pel együtt


## Docker telepítése

### Linux

- Ubuntu: https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04
- Linux Mint alá: https://computingforgeeks.com/install-docker-and-docker-compose-on-linux-mint-19/

### Windows

- https://docs.docker.com/desktop/windows/install/

## Docker Compose telepítése

### Linux

https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-20-04

### Windows
- Feltelepíti automatikusan a Docker