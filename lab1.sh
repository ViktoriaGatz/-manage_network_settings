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
		help) echo "Здесь будет хелп инфо (--help)"
			echo "Авторы: Виктория Гацуля, Сапронов Евгений"
			echo "Доступные аргументы: "
			echo -e "-h\t--help\tпомощь"
			echo -e "-a\t--all\tвывод всех сетевых интерфейсов"
			echo -e "-u\t--up\tвключение сетевых интерфейсов"
			echo -e "-d\t--down\tвыключение сетевых интерфейсов"
			echo -e "-p\t--ip\tустановка IP для интерфейса"
			echo -e "-m\t--mask\tустановка mask для интерфейса"
			echo -e "-g\t--gateway\tустановка gateway для интерфейса"
			echo -e "-k\t--kill\tубийство процесса по занимаемому порту"
			echo -e "-o\t--otcl\tотклчение сетевого интерфейса по шаблону IP"
			echo -e "-s\t--stat\tотображение сетевой статистики (статистика использования трафика)"
			;;
		all) "Вывод всех сетевых интерфейсов"
			ifconfig -a
			;;
		up) echo "Включение сетевых интерфейсов"
			while true;
			do
				
				shift # Переход к следующему аргументу строки args
				if [[ ${1} == "" ]]
				then
					break
				fi			
				if [[ ${1} =~ ^-[a-zA-Z]$ ]]
				then
					OPTIND=$OPTIND-1
					break
				fi
				ifup ${1}
			done		
			;;
		down) echo "Выключение сетевых интерфейсов"
			while true;
			do
				shift # Переход к следующему аргументу строки args
				if [[ ${1} == "" ]]
				then
					break
				fi			
				if [[ ${1} =~ ^-[a-zA-Z]$ ]]
				then
					OPTIND=$OPTIND-1
					break
				fi
				ifdown ${1}
			done		
			;;
		ip) shift
			echo "Установка IP для интерфейса ${1}"
			if [[ ${1} == "" ]]
			then
				echo "Не указано имя интерфейса"
				break
			fi			
			if [[ ${1} =~ ^-[a-zA-Z]$ ]]
			then
				OPTIND=$OPTIND-1
				break
			fi

			echo "Введите устанавливаемый IP: "
			read my_ip;
			ifconfig ${1} ${my_ip}
			;;
		mask) shift
			echo "Установка mask для интерфейса ${1}"
			if [[ ${1} == "" ]]
			then
				echo "Не указано имя интерфейса"
				break
			fi			
			if [[ ${1} =~ ^-[a-zA-Z]$ ]]
			then
				OPTIND=$OPTIND-1
				break
			fi

			echo "Введите устанавливаемый mask: "
			read my;
			ifconfig ${1} netmask ${my}
			;;
		gateway) shift 
			echo "Установка gateway для интерфейса ${1}"
			# Доделать
			;;
		kill) shift
			echo "Убийство процесса который занимает порт ${1}"
			if [[ ${1} == "" ]]
			then
				echo "Не указан порт"
				break
			fi			
			if [[ ${1} =~ ^-[a-zA-Z]$ ]]
			then
				OPTIND=$OPTIND-1
				break
			fi
			kill -9 ${1}
			;;
		otcl) shift
			echo "Отключение сетевого интерфейса по шаблону IP: ${1}"
			# Что имеется ввиду под шаблоном IP?
			n=$(ip addr | grep ${1} | wc -w)
			name=$(ip addr | grep ${1} | gawk '{print $'${n}'}')
			ifconfig ${name} down
			;;
		stat) echo "Сетевая статистика (статистика использования трафика)"
			iptraf-ng
			;;
		*) echo "Воспользуйтесь --help|-h";;
		esac;;
	h) echo "Здесь будет хелп инфо (--help|-h)"
		;;		
	a) echo "Вывод всех сетевых интерфейсов"
		ifconfig -a
		;;
	u) echo "Включение сетевых интерфейсов"
		while true;
		do
			shift
			if [[ ${1} == "" ]]
			then
				break
			fi			
			if [[ ${1} =~ ^-[a-zA-Z]$ ]]
			then
				OPTIND=$OPTIND-2
				break
			fi
			ifup ${1}
		done		
		;;
	d) echo "Выключение сетевых интерфейсов"
				while true;
		do
			shift
			if [[ ${1} == "" ]]
			then
				break
			fi			
			if [[ ${1} =~ ^-[a-zA-Z]$ ]]
			then
				OPTIND=$OPTIND-2
				break
			fi
			ifdown ${1}
		done		
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
		# Доделать
		;;
	k) echo "Убийство процесса который занимает порт ${OPTARG}"
		kill -9 ${OPTARG}
		;;		
	o) echo "Отключение сетевого интерфейса по шаблону IP: ${OPTARG}"
		# Што имеется ввиду под шаблоном IP?
		n=$(ip addr | grep ${OPTARG} | wc -w)
		name=$(ip addr | grep ${OPTARG} | gawk '{print $'${n}'}')
		ifconfig ${name} down
		;;
	s) echo "Сетевая статистика (статистика использования трафика)"
		iptraf-ng
		;;
	# Если опция была неизвестной
	*) echo "Воспользуйтесь --help|-h";;
esac
done
