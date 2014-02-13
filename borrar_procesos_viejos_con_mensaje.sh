#!/bin/bash
numerodeprocesos=0
nprocesos=0
echo 'Numero de procesos maximos' #pido el numero de procesos maximos al usuario
read nmax

echo 'Lista de usuarios conectados:'

for nombre in $(ps aux h | tr -s ' ' '%' | cut -d'%' -f1 | sort -u|tr -s '%' ' ') #saco los usuarios conectados 
do
  echo '****************************'
  echo 'Usuario: ' $nombre
  nprocesos=$(ps U $nombre | wc -l ) #calculo el numero de procesos de cada usuarios
  nprocesos=$((nprocesos-1)) #le resto la cabecera
  echo 'Numero de procesos ' $nprocesos #muestro el numero de procesos de cada usuario
  if(($nprocesos>$nmax)) #compruebo que el nº de procesos maximos no ha sido exedido
  then
    echo 'numero maximo de procesos superados'|write $nombre #envio un mensaje a cada usuario que exeda el nº max de procesos
    pid=$(ps U  $nombre h|tr -s ' ' '%' |cut -d '%' -f2|tr -s '%' ' '|sort -R) #guardo en una variable todos los PID de los procesos de cada usuario
    while [ $nprocesos>$nmax ]; #ira cerrando procesos aleatoriamente asta que deje de execer el nº max de procesos
      do
	kiled=`echo $pid| head -n 1` #guardo en la variable kiled el PID elejido aleatoriamente
	kill -9 $kiled #cierro el procesos
	((nprocesos--))
      done
      echo 'Numero de procesos del usuario despues de el cierre aleatorio de algunos de ellos' $nprocesos #muestro el numero de procesos actual.
  fi
   
    echo 'Tiempo del proceso mas viejo' $(ps U $nombre h | tr -s ' ' '%' | cut -d'%' -f5 | sort -k 3 -r | head -n 1) #muestra el tiempo mas viejo de los procesos de usuarios
      for tiempo in $(ps U $nombre h | tr -s ' ' '%' | cut -d'%' -f5 | sort | tr -s '%' ' ') #calculo los tiempos totales, siendo la suma de todos los tiempos de lso proceoss de usuario
	do
	  tiempototales=0
	  minutos=`echo $tiempo |cut -d":" -f1`
	  segundos=`echo $tiempo |cut -d":" -f2`
	  tiempototales=`expr  $minutos "*" 60 + $segundos`
	done
	  echo $tiempototales '>>>>'$nombre $endl >> Archivo #guardo lso tiempos en un archivo para ordenarlos
	  echo 'tiempo consumido por el usuario:' $nombre 'y su tiempo consumido es:'$tiempototales # muestro los tiempos totales de usuario
done
  sort -n Archivo #ordeno los tiempos totales y los muestra
