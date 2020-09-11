#!/bin/bash

# Вывод сообщения об ошибке, если не указано ни одной опции
if [ $# -lt 1 ]
then
	echo "Нет параметров, воспользуйтесь --help|-h"
	exit 1
fi

# Двоеточие после имени опции в списке означает, что для неё
# обязателен аргумент
while getopts "hk:-:au:d:so:p:m:g:" opt
do
	case ${opt} in
	-) case "${OPTARG}" in
		help) echo "Здесь будет хелп инфо (-help)";;
	esac;;
	h) echo "Здесь будет хелп инфо (-h)";;
	k) echo "Вызвана команда -${opt} kill"
		echo "Убийство процесса который занимает порт ${OPTARG}"
		kill -9 ${OPTARG}
		;;
	a) echo "Вывод всех сетевых интерфейсов"
		ifconfig -a
		;;
	u) echo "Включение сетевого интерфейса ${OPTARG}"
		ifconfig ${OPTARG} up
		;;
	d) echo "Выключение сетевого интерфейса ${OPTARG}"
		ifconfig ${OPTARG} down
		;;
	p) echo "Установка IP для интерфейса ${OPTARG}"
		echo "Введите устанавливаемый IP: "
		read my_ip;
		ifconfig ${OPTARG} ${my_ip}
		;;
	m) echo "Установка mask для интерфейса ${OPTARG}"
		echo "Введите устанавливаемый mask: "
		read my_mask;
		ifconfig ${OPTARG} netmask ${my_mask}
		;;
	g) echo "Установка gateway для интерфейса ${OPTARG}"
		echo "Введите устанавливаемый gateway: "
		read my_gateway;
		# route add ${OPTARG} gw ${my_gateway}
		;;
		
	o) echo "Отключение сетевого интерфейса по шаблону IP: ${OPTARG}"
		n=$(ip addr | grep ${OPTARG} | wc -w)
		name=$(ip addr | grep ${OPTARG} | gawk '{print $'${n}'}')
		ifconfig ${name} down
		;;
	s) echo "Статистика по сетевым интерфейсам: "
		ip -s link
		;;
	# Если опция была неизвестной
	*) echo "Воспользуйтесь --help|-h";;
esac
done
