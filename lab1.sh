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
while getopts "hk:-:au:d:so:p:m:g:n:" opt
do
	case ${opt} in
	-) case "${OPTARG}" in
		help)
			echo "Авторы: Виктория Гацуля"
			echo "Доступные аргументы: "
			echo -e "\n-h\t--help\tпомощь\n"
			echo "    Примеры использования:"
			echo "    -h | --help"
			echo -e "\n-a\t--all\tвывод всех сетевых интерфейсов\n"
			echo "    Примеры использования:"
			echo "    -a | --all"
			echo -e "\n-u\t--up\tвключение сетевых интерфейсов\n"
			echo "    Примеры использования:"
			echo "    -u lo enp2s0 | --up lo enp2s0 - запустит интерфейс lo и enp2s0"
			echo -e "\n-d\t--down\tвыключение сетевых интерфейсов\n"
			echo "    Примеры использования:"
			echo "    -d lo enp2s0 | -dowh lo enp2s0 - отключит интерфейс lo и enp2s0"
			echo -e "\n-p\t--ip\tустановка IP для интерфейса\n"
			echo "    Примеры использования:"
			echo "    -p lo 127.0.0.1 | --ip lo 127.0.0.1 - установит для интерфейса lo ip-адресс 127.0.0.1"
			echo -e "\n-m\t--mask\tустановка mask для интерфейса\n"
			echo "    Примеры использования:"
			echo "    -m lo 255.0.0.0 | --mask lo 255.0.0.0 - установит для интерфейса lo маску сети 255.0.0.0"
			echo -e "\n-g\t--gateway\tустановка шлюза по умолчанию\n"
			echo "    Примеры использования:"
			echo "    -g 192.168.0.1 | --gateway 192.168.0.1 - добавит шлюз по умолчанию с адресом 192.168.0.1"
			echo -e "\n-k\t--kill\tубийство процесса по занимаемому порту\n"
			echo "    Примеры использования:"
			echo "    -k 9999 | -kill 9999 - убивает процесс, который использует порт 9999"
			echo -e "\n-s\t--stat\tотображение сетевой статистики (статистика использования трафика)\n"
			echo "    Примеры использования:"
			echo "    -s | --stat"
			echo -e "\n-n\t--nmap\tотображение карты сети\n"
			echo "    Примеры использования:"
			echo "    -n | --nmap localhost - выведет результаты сканирования сети localhost"
			echo -e "Опции можно группировать в любом порядке, пример:\n"
			echo "    --up lo enp2s0 -d wlp3s0 - запустит интерфейсы lo и enp2s0, отключит интерфейс wlp3s0"
			echo
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
				shift
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
			echo "Установка шлюза по умолчанию с адресом ${1}"
			route add default gw ${1}
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
			name=$(lsof -i -P -n | grep :${1} | gawk '{print $2}')
			kill -9 ${name}
			;;
		stat) echo "Сетевая статистика (статистика использования трафика)"
			cat /proc/net/dev
			;;
		nmap) echo "Карта сети для ${1}"
			nmap -A ${1}
			;;
		*) echo "Воспользуйтесь --help|-h"
			;;
		esac;;
	h)
					echo "Авторы: Виктория Гацуля"
			echo "Доступные аргументы: "
			echo -e "\n-h\t--help\tпомощь\n"
			echo "    Примеры использования:"
			echo "    -h | --help"
			echo -e "\n-a\t--all\tвывод всех сетевых интерфейсов\n"
			echo "    Примеры использования:"
			echo "    -a | --all"
			echo -e "\n-u\t--up\tвключение сетевых интерфейсов\n"
			echo "    Примеры использования:"
			echo "    -u lo enp2s0 | --up lo enp2s0 - запустит интерфейс lo и enp2s0"
			echo -e "\n-d\t--down\tвыключение сетевых интерфейсов\n"
			echo "    Примеры использования:"
			echo "    -d lo enp2s0 | -dowh lo enp2s0 - отключит интерфейс lo и enp2s0"
			echo -e "\n-p\t--ip\tустановка IP для интерфейса\n"
			echo "    Примеры использования:"
			echo "    -p lo 127.0.0.1 | --ip lo 127.0.0.1 - установит для интерфейса lo ip-адресс 127.0.0.1"
			echo -e "\n-m\t--mask\tустановка mask для интерфейса\n"
			echo "    Примеры использования:"
			echo "    -m lo 255.0.0.0 | --mask lo 255.0.0.0 - установит для интерфейса lo маску сети 255.0.0.0"
			echo -e "\n-g\t--gateway\tустановка gateway по умолчанию\n"
			echo "    -g 192.168.1.5 | --gateway 192.168.1.5 - добавит шлюз по умолчанию с адресом 192.168.1.5"
			echo -e "\n-k\t--kill\tубийство процесса по занимаемому порту\n"
			echo "    Примеры использования:"
			echo "    -k 9999 | -kill 9999 - убивает процесс, который использует порт 9999"
			echo -e "\n-s\t--stat\tотображение сетевой статистики (статистика использования трафика)\n"
			echo "    Примеры использования:"
			echo "    -s | --stat"
			echo -e "\n-n\t--nmap\tотображение карты сети\n"
			echo "    Примеры использования:"
			echo "    -n | --nmap localhost - выведет результаты сканирования сети localhost"
			echo -e "Опции можно группировать в любом порядке, пример:\n"
			echo "    --up lo enp2s0 -d wlp3s0 --help - запустит интерфейсы lo и enp2s0, отключит интерфейс wlp3s0 и отобразит подсказки"
			echo
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
	g) echo "Установка шлюза по умолчанию с адресом ${OPTARG}"
		route add default gw ${OPTARG}
		;;
	k) echo "Убийство процесса который занимает порт ${OPTARG}"
		name=$(lsof -i -P -n | grep :${OPTARG} | gawk '{print $2}')
		kill -9 ${name}
		;;		
	s) echo "Сетевая статистика (статистика использования трафика)"
		cat /proc/net/dev
		;;
	n) echo "Карта сети для ${OPTARG}"
		nmap -A ${OPTARG}
		;;
	# Если опция была неизвестной
	*) echo "Воспользуйтесь --help|-h";;
esac
done


