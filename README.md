# wordpress + nginx + mariadb + phpmyadmin with SSL 

## Version
* wordpress: latest
* phpmyadmin: 5.1.0
* php: 7.3-fpm

## 실행 방법

### build
```
docker build -t server .
```
* server 라는 태그로 현재 폴더에 있는 Dockerfile을 빌드

### 일반적인 실행 방법
```
DB_NAME=wordpress_db
DB_USER=wordpress_user
DB_PASSWORD=password
DB_ROOT_PASSWORD=root
```
* 반드시 docker 명령시 --env-file로 .env 파일을 포함시켜 주어야한다. 
* .env파일에는 database 정보를 환경변수 등록하며, 사용자 외에 절대 유출되면 안된다. (.gitignore 권장)

```
docker run --env-file secret.env --rm -d -p 80:80 -p 443:443 server
```
* 데몬으로 실행

### AUTO_INDEX 사용시
```
docker run --env-file secret.env -e AUTO_INDEX=on --rm -d -p 80:80 -p 443:443 server
```
* -e 옵션을 사용해 AUTO_INDEX를 on으로 해준다. 
* 기본 값은 off

## 서버 접근
* 총 wordpress 와 phpmyadmin을 URL로 접근할 수 있다.
* wordpress: https://127.0.0.1/wordpress/
* phpmyadmin: https://127.0.0.1/phpmyadmin/
