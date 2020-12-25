#!/bin/bash

# correo institucional : alu0101351728@ull.edu.es - > Stephanie Arismendi Escobar
# PRACTICA FINAL DE BASH: ficheros abiertos por usuarios

# DECLARACIÓN DE VARIABLES GLOBALES

USUARIOS=$(who | sort | uniq | awk '{print $1}')
USUARIOS_PC=$(awk -F: '{print $1}' /etc/passwd)
multiusuario=
# offline=
declare -a ARRAYUSUARIO

# ESTILOS DE TEXTO

TEXT_ULINE=$(tput sgr 0 1)
TEXT_BOLD=$(tput bold)
TEXT_GREEN=$(tput setaf 2)
TEXT_BLUE=$(tput setaf 4)
TEXT_RESET=$(tput sgr0)

# FUNCIONES

funcion_predeterminada() {
    # printf "\nUSUARIOS\tNUM FICHEROS\tUID\tPID\n"
    for i in $USUARIOS; do
        FICHEROS=$(lsof -w -u $i | wc -l) 2>/dev/null
        U_ID=$(id -u $i) 2>/dev/null
        ANTIGUO_PID=$(ps -u $i -ostart,time,pid --noheader | sort | head -n1 | awk ' { print $3 } ') 2>/dev/null
        printf "\n"
        printf "${TEXT_BLUE}${TEXT_BOLD}  USUARIO: ${TEXT_RESET}\t %s \t\t" "$i"
        printf "${TEXT_BLUE}${TEXT_BOLD}  NUM FICHEROS: ${TEXT_RESET}\t %d \t\t" "$FICHEROS"
        printf "${TEXT_BLUE}${TEXT_BOLD}  UID: ${TEXT_RESET}\t %d \t\t" "$U_ID"
        printf "${TEXT_BLUE}${TEXT_BOLD}  PID: ${TEXT_RESET}\t %d \t\t \n" "$ANTIGUO_PID" 2>/dev/null
        # if [ "$offline" -ne 1 ]; then
        #     printf "${TEXT_BLUE}${TEXT_BOLD}  UID: ${TEXT_RESET}\t %d \t\t" "$U_ID"
        #     printf "${TEXT_BLUE}${TEXT_BOLD}  PID: ${TEXT_RESET}\t %d \t\t \n" "$ANTIGUO_PID" 2>/dev/null
        # elif [ "$offline" -ne 0 ]; then
        printf "\n"
        # fi
    done
}

funcion_filtrar() {
    no_pertenece=1
    if [ "$multiusuario" -eq 0 ]; then
        filtro=$1
        printf "${TEXT_BOLD}${TEXT_BLUE}\nNúmero de ficheros que coinciden con %s :\n ${TEXT_RESET}" "$filtro"
        for i in $USUARIOS; do
            FICHEROS=$(lsof -w -u $i | grep -i "$filtro" | wc -l) 2>/dev/null
            printf "${TEXT_BOLD}USUARIO:${TEXT_RESET} %s\t\t" "$i"
            printf "${TEXT_BOLD}Nº FICHEROS:${TEXT_RESET} %d \n" "$FICHEROS"
        done
    elif [ "$multiusuario" -eq 1 ]; then
        printf "${TEXT_BOLD}${TEXT_BLUE}\nNúmero de ficheros que coinciden con %s :\n ${TEXT_RESET}" "$filtro"
        for i in "${ARRAYUSUARIO[@]}"; do
            if [ "$i" != "-f" ]; then
                if [ "$i" != "-u" ]; then
                    # comprobamos que existe el usuario
                    Comprobacion_Usuario $i
                    # terminamos de comprobar que existe el usuario
                    FICHEROS=$(lsof -w -u $i | wc -l) 2>/dev/null
                    printf "${TEXT_BOLD}USUARIO:${TEXT_RESET} %s\t\t" "$i"
                    printf "${TEXT_BOLD}Nº FICHEROS:${TEXT_RESET} %d\n" "$FICHEROS"
                fi
            fi
        done
    fi
}

funcion_filtrar_multi() {
    filtro=$1
    final=0
    printf "${TEXT_BOLD}${TEXT_BLUE}\nNúmero de ficheros que coinciden con %s :\n ${TEXT_RESET}" "$filtro"
    for i in "${ARRAYUSUARIO[@]}"; do
        if [ "$i" != "-u" ]; then
            if [ "$i" == "-f" ]; then
                final=1
            fi
            if [ "$final" -ne 1 ] 2>/dev/null; then
                # comprobamos que existe el usuario
                Comprobacion_Usuario $i
                # terminamos de comprobar que existe el usuario
                FICHEROS=$(lsof -w -u $i | grep -i "$filtro" | wc -l) 2>/dev/null
                printf "${TEXT_BOLD}USUARIO:${TEXT_RESET} %s\t" "$i"
                printf "${TEXT_BOLD}Nº FICHEROS:${TEXT_RESET} %d \n" "$FICHEROS"
            fi
        fi
    done
}

# comprobacion de los comandos
Comprobacion_Comandos() {
    test -x "$(which ps)" || Error_Exit "El comando <ps> no se puede ejcutar"
    test -x "$(which who)" || Error_Exit "El comando <who> no se puede ejcutar"
    test -x "$(which awk)" || Error_Exit "El comando <awk> no se puede ejcutar"
    test -x "$(which sed)" || Error_Exit "El comando <sed> no se puede ejcutar"
    test -x "$(which printf)" || Error_Exit "El comando <printf> no se puede ejcutar"
    test -x "$(which uniq)" || Error_Exit "El comando <uniq> no se puede ejcutar"
    test -x "$(which lsof)" || Error_Exit "El comando <lsof> no se puede ejcutar"
    test -x "$(which id)" || Error_Exit "El comando <id> no se puede ejcutar"
    test -x "$(which head)" || Error_Exit "El comando <head> no se puede ejcutar"
    test -x "$(which tail)" || Error_Exit "El comando <tail> no se puede ejcutar"
    test -x "$(which wc)" || Error_Exit "El comando <wc> no se puede ejcutar"
}

# Funcion para comprobar que existe el usuario introducido
Comprobacion_Usuario() {
    i=$1
    no_pertenece=1
    for j in $USUARIOS_PC; do
        if [ "$i" == "$j" ]; then
            no_pertenece=0
        fi
    done
    if [ "$no_pertenece" -eq 1 ]; then
        error_exit "No se ha encontrado el usuario"
    fi
}

error_exit() {
    # --------------------------------------------------
    # FUNCIÓN PARA SALIR EN CASO DE ERROR FATAL
    # ACEPTA DOS ARGUMETNOS
    # --------------------------------------------------

    echo "${PROGNAME}: ${1:- "Error desconocido"}" 1>&2
    exit 1
}

instrucciones() {
    echo "${TEXT_ULINE}${TEXT_GREEN}COMO USAR${TEXT_RESET}"

    printf "${TEXT_BOLD}DESCRIPCION\n${TEXT_RESET}"
    printf "Script que automatiza las tareas más comunes \n"
    printf "${TEXT_BOLD}OPCIONES\n${TEXT_RESET}"

    printf "*******************************************************************************************************************************************************"
    printf "\n"
    printf "\t Sin opción                               Muestra todos los usuarios contectados al sistema y la cuenta del número de ficheros abiertos\n"
    printf "\t[open_files -f '.*sh']                    En lugar de contar todos los ficheros abiertos, se contarán los que coincidan con esta expresión regular.\n"
    printf "\t[-o] [--off_line]                       Muestra la informacion de los usuarios que no estan conectados al sistema\n"
    printf "\t[-u usuarios] [-u usuarios -f patron]     Elimina los procesos con un número de ficheros abiertos superior al indicado\n"
    printf "\n"
    printf "*******************************************************************************************************************************************************"
    printf "\n"
}

# MENÚ PRINCIPAL
# ejecutamos la comprobación de comandos
Comprobacion_Comandos
# si no le pasamos una opción
if [ "$1" == "" ]; then
    USUARIOS=$(who | sort | uniq | awk '{print $1}') 2>/dev/null
    echo
    echo ${TEXT_BOLD}${TEXT_GREEN}LISTA ORDENADA DE TODOS LOS USUARIOS DEL SISTEMA${TEXT_RESET}
    # offline=0
    funcion_predeterminada
fi

while [ "$1" != "" ]; do
    case $1 in
    -f)
        USUARIOS=$(who | sort | uniq | awk '{print $1}') 2>/dev/null
        if [ "$2" == "" ]; then
            error_exit "No se ha introducido una cadena"
        fi
        multiusuario=0
        funcion_filtrar $2
        exit
        ;;
    -o | --off_line)
        # aprovechamos la funcion predeterminada pero le pasamos otro parametro de usuario para que solo lo haga con los desconectados
        echo
        printf "${TEXT_BOLD}${TEXT_BLUE} USUARIOS NO CONECTADOS \n\n ${TEXT_RESET}"
        USUARIOS=$(ps -A --no-headers -ouser | sort | uniq | sed "s/$(who | sort | awk '{ print $1 }')//g" | sort | uniq | sed "1d") 2>/dev/null
        # offline=1
        funcion_predeterminada
        exit
        ;;
    -h | --help)
        instrucciones
        exit
        ;;
    -u)
        USUARIOS=$(who | sort | uniq | awk '{print $1}') 2>/dev/null
        multiusuario=1
        patron=0
        ARRAYUSUARIO=("${@}")
        for i in "${ARRAYUSUARIO[@]}"; do
            if [ "$i" == "-f" ]; then
                patron=1
            elif [ "$i" != "-f" ] && [ "$patron" -ne 1 ] 2>/dev/null; then
                patron=0
            fi
            cadena="$i"
        done
        if [ "$patron" -eq 1 ]; then
            funcion_filtrar_multi $cadena
            exit
        elif [ "$patron" -eq 0 ]; then
            funcion_filtrar
            exit
        fi
        ;;
    *)
        instrucciones
        error_exit "Opción desconocida"
        ;;
    esac
    shift
done
