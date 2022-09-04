#!/bin/bash

# единственное отличие от предыдущего примера это то, что в команде
# вместо функции в фон отпавляется процесс на выполнение внешней программы

# макс. количество дочерних процессов
MAX_CHILDREN=4

# массив для хранения PID дочерних процессов
children_PID=()

# запускаем необходимое количество дочерних процессов
for ((i=0; i<MAX_CHILDREN; i++)); do
    # выполняем коьанду в фоновом процессе, добавив & в конце строки
    bash -c 'while : ; do echo "Children $$ works"; sleep 1; done' &
    # переменная $! содержит PID последнего созданного процесса
    background_process_id=$!
    echo "Process started in background: PID=${background_process_id}"
    # добавляем PID дочернего процесса, созданного последним, в массив
    children_PID[$i]=$background_process_id
done

# даем поработать
sleep 3

# поочередно посылаем сигнал завершения дочерним процессам
for chldpid in ${children_PID[@]}; do
    echo "Sending SIGTERM to ${chldpid}..."
    # отправляем сигнал процессу
    kill -n SIGTERM ${chldpid}

    if (( $? == 0 )) ; then
        echo "Process ${chldpid} was successfully terminated."
    else
        echo "Failed to terminate ${chldpid}."
    fi
done
