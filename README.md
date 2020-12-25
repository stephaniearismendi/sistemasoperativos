# sistemasoperativos
1. Funcionamiento básico y listado de usuarios con archivos abiertos
Usando lo aprendido hasta el momento en clase, desarrolla el script 'open_files' que, si no se especifica opción, muestre una lista ordenada y sin duplicados de todos los usuarios conectados en el sistema y la cuenta del número de ficheros abiertos que tiene actualmente cada usuario.  En este listado se debe incluir los usuarios que se incluyen en el resultado del comando who, y no usuarios como root o demonios. Tambien se debe incluir el UID del usuario, y el PID de su proceso más antiguo.

Recuerda facilitar la lectura de tu código:
Usa comentarios en los elementos más complejos del programa para que te sea más sencillo entenderlo cuando haya pasado un tiempo y no te acuerdes
Usa funciones para compartimentar el programa, así como variables y constantes (variables en mayúsculas) que hagan tu código más legible.
Incluye código para procesar la línea de comandos.
Se debe mostrar ayuda sobre el uso si el usuario emplea la opción -h o --help.
Se debe indicar el error y mostrar ayuda sobre el uso si el usuario emplea uno opción no soportada
Ojo con la sustitución de variables y las comillas. En caso de problemas piensa en cómo quedarían las sentencias si las variables no valieran nada ¿tendría sentido para BASH el comando a ejecutar?
Maneja adecuadamente los errores.
En caso de error muestra un mensaje y sal con código de salida distinto de 0. Recuerda la función error_exit de ejercicios anteriores y, si lo crees conveniente, reúsala o haz la tuya propia.
Trata como un error que el usuario emplee opciones no soportadas
Detecta si lsof está instalado antes de usarlo. Si no lo está, indica el error.
Haz lo mismo con las otras posibles condiciones de error que se te ocurran ¿has probado a invocar tu programa opciones absurdas a ver si lo haces fallar?
2. Busca archivos según un patrón
La última columna de lsof muestra la ruta del archivo abierto.

Añade la opción '-f filtro' de tal forma que filtro pueda ser una expresión regular. Esta expresión se usaría para filtrar la salida de lsof en base a la última columna. Es decir que al usar tu script así:

open_files -f '.*sh'

En lugar de contar todos los ficheros abiertos, se contarán los que coincidan con esta expresión regular.

Para refinar los resultados, recuerda:

Un $ en una expresión regular en grep que indica un match con el final de la línea. Quizás sea buena idea añadir este caracter al filtro indicado por el usuario.
Un tail +n te permite eliminar de la salida las primeras n líneas ¿para qué lo podrías usar?
4. Ficheros de Usuarios no conectados
Si se incluye el parámetro -o --off_line se debe incluir el listado anterior pero únicamente para los usuarios que no estén conectados al sistema, es decir aquellos que no salgan en el resultado de who.

5. Filtra por usuario
Finalmente incluye que si el script se invoca así:

open_files -u jmtorres jttoledo dabreu

Sólo se muestre la información de lsof para aquellos archivos abiertos por los usuario especificados en la opción -u. Mientras que si se invoca así:

open_files -u jmtorres jttoledo -f '.*sh'

Se muestre la información para aquellos archivos terminados en 'sh' que además hayan sido abiertos por el usuario especificado.
