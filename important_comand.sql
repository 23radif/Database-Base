cd /d D: /*изменение выбранного каталога в Win10*/
chdir /d D:\MainFolder\SubFilder /*изменение выбранного каталога в Win10*/
cd "D:\OpenServer\OpenServer_5.3\OSPanel\domains\yii2.uni.local" /*пример для Git Bash*/

ls /*показать содержимое текущеей папки*/

mkdir mongo_backups /*создание директории mongo_backups*/
cd mongo_backups\ /*переход в директорию mongo_backups*/
dir  /*обзор директории, дополнения в интернете*/
\! "командаf" /*работа с глобальными командами, например из mysql*/
"команда" --help /*посмотреть возможные опции для команд*/

mysql -u root -p
mysql -u root -p < 'upload_file.sql'

SHOW DATABASES;
use table_name;
SHOW TABLES;
DESC 'table_name'\G; /*( \G решает проблему с отображением переносов строк, вертикальный формат)*/
SHOW CREATE TABLE 'table_name'; --как создавался запрос, позволяет увидеть в том числе foreign key и т.д.

SELECT database();
SHOW WARNINGS;

-- если нужно удалить таблицу с внешним ключем:
-- отключаем проверку
SET foreign_key_checks = 0; 
-- выполняем нужные запросы
DELETE FROM downloads WHERE id = 59;
-- включаем проверку назад
SET foreign_key_checks = 1;

delimiter // --разделитель, например тут // вместо ;

--PHP Yii2 миграция базы данных (в папке с проектом)
--1. создание:
php yii
php yii migrate/create create_task_attachments_table --по названию формируется новая таблица
--2. добавление в базу:
php yii
php yii migrate

--Добавление проекта в Git репозиторий
git init
git status
git add .
git commit -m "first commit"
git status
git remote add origin https://github.com/23radif/yii2.uni.local.git
git push -u origin master


--сбросить кэш ('cache' в конце - имя кэша)
php yii cache/flush cache

Миграция RBAC из вендора Yii2
php yii migrate --migrationPath=@yii/rbac/migrations

--поднять виртуальную машину:
vagrant up 
--войти в неё:
vagrant ssh
--остановить:
vagrant halt


yii2-advanced

vagrant ssh - /* войти в окружение сервера */
cd ../../app -/* тут лежит проект на сервере */
php init /* выбрать окружение (разработка или продакшн) */


composer update --no-interaction

тесты Codeception:
vendor/bin/codecept run | -c frontend unit | models/ContactFormTest -к примеру конкретный тест в модульном тестировании
Пример создания теста по шаблону:
vendor/bin/codecept generate:test -c frontend unit FirstTest

???
curl -u '23radif' https://github.com/23radif/repos -d'{"name":"yii2-app-advanced"}'



http://95.183.8.118:8080


var conn = new WebSocket('ws://95.183.8.118:9090');conn.onopen = function(e) {    console.log("Connection established!");};conn.onmessage = function(e) {    console.log(e.data);};


conn.send('qwerty');




php yii ws & запуск Демона

ps aux | grep ws

kill 14330


var conn = new WebSocket('ws://localhost:9090');
conn.onopen = function(e) {
    console.log("Connection established!");
};

conn.onmessage = function(e) {
    console.log(e.data);
};


conn.send('Hello World!');



cd