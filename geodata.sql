CREATE DATABASE geodata;
use geodata;

/* _countries*/
ALTER TABLE _countries RENAME COLUMN title_ru TO title;
ALTER TABLE _countries MODIFY COLUMN title VARCHAR(150) NOT NULL;
CREATE INDEX title ON _countries(title);

ALTER TABLE _countries RENAME COLUMN country_id TO id;
ALTER TABLE _countries MODIFY COLUMN id INT(11) PRIMARY KEY AUTO_INCREMENT;

ALTER TABLE _countries 
	DROP COLUMN title_ua,
	DROP COLUMN title_be,
	DROP COLUMN title_en,
	DROP COLUMN title_es,
	DROP COLUMN title_pt,
	DROP COLUMN title_de,
	DROP COLUMN title_fr,
	DROP COLUMN title_it,
	DROP COLUMN title_pl,
	DROP COLUMN title_ja,
	DROP COLUMN title_lt,
	DROP COLUMN title_lv,
	DROP COLUMN title_cz;
	
/* _regions */
ALTER TABLE _regions RENAME COLUMN region_id TO id;
ALTER TABLE _regions MODIFY COLUMN id INT PRIMARY KEY AUTO_INCREMENT;
ALTER TABLE _regions MODIFY COLUMN id INT AUTO_INCREMENT; /* (почему-то автоинкремент сначала, выше, не сработал) */

ALTER TABLE _regions MODIFY COLUMN country_id INT NOT NULL, 
	ADD CONSTRAINT fk_regions_countries
	FOREIGN KEY(country_id) 
	REFERENCES _countries(id);
	
ALTER TABLE _regions RENAME COLUMN title_ru TO title;
ALTER TABLE _regions MODIFY COLUMN title VARCHAR(150) NOT NULL;
CREATE INDEX title ON _regions(title);

ALTER TABLE _regions
	DROP COLUMN title_ua,
	DROP COLUMN title_be,
	DROP COLUMN title_en,
	DROP COLUMN title_es,
	DROP COLUMN title_pt,
	DROP COLUMN title_de,
	DROP COLUMN title_fr,
	DROP COLUMN title_it,
	DROP COLUMN title_pl,
	DROP COLUMN title_ja,
	DROP COLUMN title_lt,
	DROP COLUMN title_lv,
	DROP COLUMN title_cz;
	
/* _cities */
ALTER TABLE _cities RENAME COLUMN city_id TO id;
ALTER TABLE _cities MODIFY COLUMN id INT PRIMARY KEY AUTO_INCREMENT;

ALTER TABLE _cities MODIFY COLUMN country_id INT NOT NULL, 
	ADD CONSTRAINT fk_cities_countries
	FOREIGN KEY(country_id) 
	REFERENCES _countries(id);
	
ALTER TABLE _cities MODIFY COLUMN region_id INT,
	ADD CONSTRAINT fk_cities_regions
	FOREIGN KEY(region_id)
	REFERENCES _regions(id);
	
ALTER TABLE _cities RENAME COLUMN title_ru TO title;
ALTER TABLE _cities MODIFY COLUMN title VARCHAR(150) NOT NULL;
CREATE INDEX title ON _cities(title);

ALTER TABLE _cities
	DROP COLUMN area_ru,
	DROP COLUMN area_ua,
	DROP COLUMN area_be,
	DROP COLUMN area_en,
	DROP COLUMN area_es,
	DROP COLUMN area_pt,
	DROP COLUMN area_de,
	DROP COLUMN area_fr,
	DROP COLUMN area_it,
	DROP COLUMN area_pl,
	DROP COLUMN area_ja,
	DROP COLUMN area_lt,
	DROP COLUMN area_lv,
	DROP COLUMN area_cz,	
	DROP COLUMN region_ru,
	DROP COLUMN region_ua,
	DROP COLUMN region_be,
	DROP COLUMN region_en,
	DROP COLUMN region_es,
	DROP COLUMN region_pt,
	DROP COLUMN region_de,
	DROP COLUMN region_fr,
	DROP COLUMN region_it,
	DROP COLUMN region_pl,
	DROP COLUMN region_ja,
	DROP COLUMN region_lt,
	DROP COLUMN region_lv,
	DROP COLUMN region_cz,
	DROP COLUMN title_ua,
	DROP COLUMN title_be,
	DROP COLUMN title_en,
	DROP COLUMN title_es,
	DROP COLUMN title_pt,
	DROP COLUMN title_de,
	DROP COLUMN title_fr,
	DROP COLUMN title_it,
	DROP COLUMN title_pl,
	DROP COLUMN title_ja,
	DROP COLUMN title_lt,
	DROP COLUMN title_lv,
	DROP COLUMN title_cz;