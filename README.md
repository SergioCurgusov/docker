Дано:

НОписание домашнего задания
    1. Установите Docker на хост машину
https://docs.docker.com/engine/install/ubuntu/
    2. Установите Docker Compose - как плагин, или как отдельное приложение
    3. Создайте свой кастомный образ nginx на базе alpine. После запуска nginx должен отдавать кастомную страницу (достаточно изменить дефолтную страницу nginx)
    4. Определите разницу между контейнером и образом. Вывод опишите в домашнем задании.
    5. Ответьте на вопрос: Можно ли в контейнере собрать ядро?
Собранный образ необходимо запушить в docker hub и дать ссылку на ваш репозиторий.


Решение:

Хостовая система: Xubuntu

Прикладываю: default.conf (конфигурация nginx), Dockerfile, index.html (моя страница), README.txt (описание моих действий), screenshot.png (скриншот работающей системы). Следует все эти файлы расположить в одном каталоге.

Ремарка: alpine - всё-таки очень урезан. Это с одной стороны хорошо, ничего лишнего. С другой стороны нужно добавлять кучу элементов для диагностики. Я всю голову сломал, почему образ не запускается, dockerfile достаточно прост у меня. Я сначала ставил nginx, а потом копировал конфигурацию. Видно, после установки, nginx автоматом запускался и не применял конфигурацию. Потому, я поменял местами копирование и установку, чтобы минимизировать действия и не усложнять dockerfile.

1) См. README.txt
2) См. README.txt
3) См. README.txt
4) Отвечаю своими словами. Образ - это некий шаблон, по которому создаются контейнеры. Контейнер - это аналог виртуальной машины (то, ради чего всё затевалось).
5) Собрать можно. Но загрузиться с него нельзя. 