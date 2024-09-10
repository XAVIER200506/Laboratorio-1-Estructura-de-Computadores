.data
prompt_numbers: .asciiz "Ingrese la cantidad de numeros a comparar (minimo 3, maximo 5): "
prompt_input: .asciiz "Ingrese un numero: "
msg_menor: .asciiz "El numero menor es: "

.text
.globl main

main:
    # Pedir la cantidad de números a comparar
    li $v0, 4                 # syscall para imprimir string
    la $a0, prompt_numbers    # cargar dirección del mensaje
    syscall

    li $v0, 5                 # syscall para leer un entero
    syscall
    move $t0, $v0             # almacenar la cantidad de números en $t0

    # Comprobar si la cantidad de números es válida
    li $t1, 3                 # mínimo 3 números
    li $t2, 5                 # máximo 5 números
    blt $t0, $t1, exit        # si es menor que 3, salir
    bgt $t0, $t2, exit        # si es mayor que 5, salir

    # Inicializar contador y menor
    move $t3, $zero           # contador de números leídos
    li $t4, 2147483647        # valor máximo posible para el menor (max int)

input_loop:
    beq $t3, $t0, end_input   # si hemos leído todos los números, salir del bucle

    # Pedir un número
    li $v0, 4                 # syscall para imprimir string
    la $a0, prompt_input      # cargar dirección del mensaje
    syscall

    li $v0, 5                 # syscall para leer un entero
    syscall
    move $t5, $v0             # almacenar número en $t5

    # Comparar con el número menor actual
    bgt $t5, $t4, skip        # si $t5 > $t4, no hacer nada
    move $t4, $t5             # actualizar número menor

skip:
    addi $t3, $t3, 1          # incrementar contador
    j input_loop              # repetir el bucle

end_input:
    # Mostrar el número menor
    li $v0, 4                 # syscall para imprimir string
    la $a0, msg_menor         # cargar dirección del mensaje
    syscall

    li $v0, 1                 # syscall para imprimir un entero
    move $a0, $t4             # número menor en $t4
    syscall

exit:
    li $v0, 10                # syscall para salir
    syscall
