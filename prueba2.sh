#!/bin/bash

# Crear el archivo técnicos_preparados.txt en el home del usuario y establecer permisos 744
touch ~/técnicos_preparados.txt
chmod 744 ~/técnicos_preparados.txt

while true; do
    opcion=$(zenity --list --title="Menú de operaciones tecnológicas" --column="Opción" --column="Descripción" \
        1 "Crear grupos de técnicos" \
        2 "Crear usuarios técnicos" \
        3 "Añadir técnico a un grupo" \
        4 "Crear árbol de datos" \
        5 "Visualizar técnicos preparados" \
        6 "Realizar salvaguarda de datos" \
        7 "Conexion remota entre equipos" \
        8 "Salir" \
        --height=400 --width=400)

    case $opcion in
        1)
            grupo=$(zenity --entry --title="Crear grupos de técnicos" --text="Introduzca el nombre del grupo a crear:")
            if [ -z "$grupo" ]; then
                zenity --error --text="Error: debe introducir un nombre de grupo"
            else
                if getent group $grupo > /dev/null; then
                    zenity --info --text="El grupo $grupo ya existe"
                else
                    groupadd $grupo
                    zenity --info --text="Grupo $grupo creado correctamente"
                fi
            fi
            ;;

 	2)
            usuario=$(zenity --entry --title="Crear usuarios técnicos" --text="Introduzca el nombre del usuario a crear:")
            if [ -z "$usuario" ]; then
                zenity --error --text="Error: Debe introducir un nombre de usuario."
            else
                if grep -q "^$usuario:" /etc/passwd; then
                    zenity --error --text="Error: El usuario $usuario ya existe."
                else
                    if useradd "$usuario"; then
                        zenity --info --text="Usuario $usuario creado correctamente."
                    else
                        zenity --error --text="Error: No se pudo crear el usuario $usuario."
                    fi
                fi
            fi
            ;;
        3)
            usuario=$(zenity --entry --title="Añadir técnico a un grupo" --text="Introduzca el nombre del usuario a agregar:")
            grupo=$(zenity --entry --title="Añadir técnico a un grupo" --text="Introduzca el nombre del grupo al que agregar:")
            if [ -z "$usuario" ] || [ -z "$grupo" ]; then
                zenity --error --text="Error: debe introducir ambos valores"
            else
                if id $usuario > /dev/null && getent group $grupo > /dev/null; then
                    usermod -aG $grupo $usuario
                    zenity --info --text="Usuario $usuario agregado al grupo $grupo correctamente"
                else
                    zenity --error --text="Error: usuario o grupo no existen"
                fi
            fi
            ;;
        4)
            usuario=$(zenity --entry --title="Crear árbol de datos" --text="Introduzca el nombre del usuario al que crear el árbol de datos:")
            if id $usuario > /dev/null; then
                mkdir -p /home/$usuario/{Empresas_afectadas,Familias_afectadas,Patrimonio_afectado,Decesos}
                echo "$usuario" >> ~/tecnicos_preparados.txt
                zenity --info --text="Árbol de datos creado correctamente para $usuario"
            else
                zenity --error --text="Error: usuario no existe"
            fi
            ;;
        5)
            tecnicos=$(cat ~/tecnicos_preparados.txt)
            zenity --info --text="Técnicos preparados:\n$tecnicos"
            ;;
        6)
            usuario=$(zenity --entry --title="Realizar salvaguarda de datos" --text="Introduzca el nombre del usuario para realizar la salvaguarda de datos:")
            if id $usuario > /dev/null; then
                mkdir -p /root/$usuario/salvaguarda_datos
                cp -r /home/$usuario/* /root/$usuario/salvaguarda_datos
                zenity --info --text="Salvaguarda de datos realizada correctamente"
            else
                zenity --error --text="Error: usuario no existe"
            fi
            ;;
7)
    if zenity --question --text="¿Desea abrir AnyDesk?" ; then
        if command -v anydesk &> /dev/null; then
            # Ejecutar AnyDesk sin usar sudo
            anydesk &
            zenity --info --text="AnyDesk abierta."
        else
            zenity --error --text="AnyDesk no está instalado."
        fi
    else
        zenity --info --text="Operación cancelada."
    fi
    ;;


         8)
		 exit 0
            ;;
        *)
            zenity --error --text="Opción no válida"
            ;;
    esac
done
