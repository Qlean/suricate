# Suricate

Suricate - это REST API над MaxMind GeoLite2 базой. На вход подаем IP-адрес, на выходе получаем 
примерный город и страну (можно на русском или англиском языках) 

### Обновление

Файл базы находится в maxminddb/GeoLite2-City.mmdb. MaxMind обновляет эту базу раз в месяц. 
Свежую базу можно скачать по адресу http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz
Далее ее надо распаковать и положить в maxminddb/GeoLite2-City.mmdb.

### Интерфейс
 
Поддерживаются следующие роуты:

##### /lookup?ip=8.8.8.8&language=ru
Запрос к базе. Параметры:
* `ip` (обязательный) - ip адрес в формате x.x.x.x
* `language` (необязательльный, по умолчанию ru) - выбор языка ответа, возможные варианты ru, en

Формат ответа:
* `200` и json в теле ответа:
 
```json
{
  "country":"США",
  "city":"Маунтин-Вью"
}
```
* `400` если ничего не найдено

##### /health 
Проверка сервиса, делает внутренний запрок к самому себе, если все ОК - возвращает `200`, 
в противном случае - `400`
