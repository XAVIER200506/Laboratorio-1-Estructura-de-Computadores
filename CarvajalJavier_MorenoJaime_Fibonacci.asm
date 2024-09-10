.data
prompt_fibonacci: .asciiz "Ingrese cuantos numeros de la serie Fibonacci desea generar: "
msg_fibonacci: .asciiz "Serie Fibonacci: "
msg_suma: .asciiz "Suma de la serie: "
comma_space: .asciiz ", "       # Declarar coma y espacio en la sección .data
newline: .asciiz "\n"            # Declarar salto de línea en la sección .data

.text
.globl main

main:
    # Pedir al usuario cuántos números de la serie quiere generar
    li $v0, 4                 # syscall para imprimir string
    la $a0, prompt_fibonacci  # cargar dirección del mensaje
    syscall

    li $v0, 5                 # syscall para leer un entero
    syscall
    move $t0, $v0             # almacenar la cantidad de números en $t0

    # Comprobar si la cantidad de números es válida (debe ser mayor que 0)
    blez $t0, exit            # si la cantidad de números es menor o igual a 0, salir

    # Inicializar los dos primeros números de la serie Fibonacci
    li $t1, 0                 # Fibonacci(0) = 0
    li $t2, 1                 # Fibonacci(1) = 1
    li $t3, 2                 # contador para el bucle de la serie (empezamos en el tercer número)
    move $t4, $t1             # inicializar suma con el primer número
    add $t4, $t4, $t2         # agregar el segundo número a la suma

    # Mostrar mensaje de la serie Fibonacci
    li $v0, 4                 # syscall para imprimir string
    la $a0, msg_fibonacci     # cargar dirección del mensaje
    syscall

    # Imprimir los dos primeros números de la serie (Fibonacci 0 y 1)
    li $v0, 1                 # syscall para imprimir entero
    move $a0, $t1             # imprimir Fibonacci(0)
    syscall
    li $v0, 4                 # syscall para imprimir coma y espacio
    la $a0, comma_space       # cargar dirección de la coma y espacio
    syscall

    li $v0, 1                 # syscall para imprimir entero
    move $a0, $t2             # imprimir Fibonacci(1)
    syscall

fibonacci_loop:
    beq $t3, $t0, end_fibonacci   # si hemos generado la cantidad deseada, salir del bucle

    # Calcular el siguiente número de Fibonacci
    add $t5, $t1, $t2          # t5 = Fibonacci(n-2) + Fibonacci(n-1)
    move $t1, $t2              # actualizar Fibonacci(n-2) = Fibonacci(n-1)
    move $t2, $t5              # actualizar Fibonacci(n-1) = Fibonacci(n)

    # Imprimir el número de Fibonacci actual
    li $v0, 4                 # syscall para imprimir coma y espacio
    la $a0, comma_space       # cargar dirección de la coma y espacio
    syscall

    li $v0, 1                 # syscall para imprimir entero
    move $a0, $t5             # imprimir Fibonacci(n)
    syscall

    # Sumar el número actual a la suma total
    add $t4, $t4, $t5          # suma += Fibonacci(n)

    # Incrementar contador
    addi $t3, $t3, 1           # incrementar contador
    j fibonacci_loop           # repetir el bucle

end_fibonacci:
    # Imprimir un salto de línea después de la serie
    li $v0, 4
    la $a0, newline
    syscall

    # Mostrar mensaje de la suma de la serie
    li $v0, 4                 # syscall para imprimir string
    la $a0, msg_suma          # cargar dirección del mensaje
    syscall

    # Imprimir la suma total de la serie Fibonacci
    li $v0, 1                 # syscall para imprimir entero
    move $a0, $t4             # imprimir la suma total
    syscall

exit:
    li $v0, 10                # syscall para salir
    syscall

