#!/bin/bash

# Función para crear un usuario con o sin permisos de root
crear_usuario() {
    # Solicitar nombre de usuario
    read -p "Introduce el nombre del usuario: " username

    # Verificar si el usuario ya existe
    if id "$username" &>/dev/null; then
        echo "El usuario '$username' ya existe."
        return
    fi

    # Crear el usuario
    sudo useradd "$username"
    echo "Usuario '$username' creado con éxito."

    # Solicitar y asignar una contraseña
    passwd "$username"

    # Preguntar si se desea dar permisos de root (agregar al grupo wheel)
    while true; do
        read -p "¿Deseas que '$username' tenga permisos de root (sí/no)? " respuesta
        case $respuesta in
            [sS][iI]|[sS]) 
                sudo usermod -aG wheel "$username"
                echo "El usuario '$username' ha sido añadido al grupo 'wheel' con permisos de root."
                break
                ;;
            [nN][oO]|[nN]) 
                echo "El usuario '$username' no tendrá permisos de root."
                break
                ;;
            *) 
                echo "Respuesta no válida. Introduce 'sí' o 'no'."
                ;;
        esac
    done
}

# Ciclo para seguir creando usuarios hasta que el usuario decida parar
while true; do
    crear_usuario

    # Preguntar si se desea crear otro usuario
    while true; do
        read -p "¿Deseas crear otro usuario (sí/no)? " continuar
        case $continuar in
            [sS][iI]|[sS])
                break
                ;;
            [nN][oO]|[nN])
                echo "Saliendo del script."
                exit 0
                ;;
            *) 
                echo "Respuesta no válida. Introduce 'sí' o 'no'."
                ;;
        esac
    done
done
