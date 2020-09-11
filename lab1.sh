#!/bin/bash

# Вывод сообщения об ошибке, если не указано ни одной опции
if [ $# -lt 1 ]
then
	echo "Нет параметров, воспользуйтесь --help|-h"
	exit 1
fi
# OPTIND, OPTARG
# Двоеточие после имени опции в списке означает, что для неё
# обязателен аргумент
while getopts "hk:-:au:d:so:p:m:g:" opt
do
	case ${opt} in
	-) case "${OPTARG}" in
		help) echo "Здесь будет хелп инфо (-help)";;
		esac;;
	h) echo "Здесь будет хелп инфо (--help|-h)"
		echo "${OPTIND}"
		echo "Авторы: Виктория Гацуля, Сапронов Евгений"
		echo "Доступные аргументы: "
		echo -e "-a\tall\tвывод всех сетевых интерфейсов"
		echo -e "-u\tup\tвключение сетевого интерфейса"
		echo -e "-d\tdown\tвывод всех сетевых интерфейсов"
		echo -e "-p\tip\tвывод всех сетевых интерфейсов"
		echo -e "-m\tmask\tвывод всех сетевых интерфейсов"
		echo -e "-g\tgateway\tвывод всех сетевых интерфейсов"
		echo -e "-k\tkill\tвывод всех сетевых интерфейсов"
		echo -e "-o\totcl\tвывод всех сетевых интерфейсов"
		echo -e "-s\tstat\tвывод всех сетевых интерфейсов"
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
	k) echo "Вызвана команда -${opt} kill"
		echo "Убийство процесса который занимает порт ${OPTARG}"
		kill -9 ${OPTARG}
		;;		
	o) echo "Отключение сетевого интерфейса по шаблону IP: ${OPTARG}"
		n=$(ip addr | grep ${OPTARG} | wc -w)
		name=$(ip addr | grep ${OPTARG} | gawk '{print $'${n}'}')
		ifconfig ${name} down
		;;
	s) echo "Сетевая статистика: "
		;;
	# Если опция была неизвестной
	*) echo "Воспользуйтесь --help|-h";;
esac
done
