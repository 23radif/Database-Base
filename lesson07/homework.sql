--1. Создать нового пользователя и задать ему права доступа на базу данных «Страны и города мира».

CREATE USER newuser@localhost IDENTIFIED BY 'password';

GRANT ALL PRIVILEGES ON geodata.* TO 'newuser'@'localhost';


--2. Сделать резервную копию базы, удалить базу и пересоздать из бекапа.
mysqldump -u root -p geodata > ./backups/geodata.sql

DROP DATABASE geodata;

CREATE DATABASE geodata;

\q

mysql -u root -p geodata < ./backups/geodata.sql

mysqlshow -u root -p geodata

