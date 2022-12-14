#!/bin/bash

# типичный пример, когда необходимо сделать celanup - после неудачного окончания программы
# как правило после неожиданного завершения остаются lock-файлы, которые потом приходится удалять руками
# с помощью обработчиков сигналов можно обрабатывать такие исключительные ситуации и "подчищать" ненужные файлы

LOCKFILE=/var/lock/updatedbmy.lock

# ситуация возможна тогда (lock-фал существует), когда скрипт уже
# работает в системе (например он был запущен cron-ом минуту назад и еще не завершил работу)
# обработчик еще не определен поэтому скрипт просто завершится ничего не сделав
[ -f $LOCKFILE ] && exit 0

# после завершения очищаем lock-файл
# в данном примере обрабатывается сигнал завершения bash (отправляется после exit) и SIGTERM (Ctrl+C)
trap "{ rm -f $LOCKFILE ; exit 255; }" SIGTERM EXIT

# создаем lock-файл
touch $LOCKFILE
# выполняем "длительную" комманду
sudo updatedb
exit 0