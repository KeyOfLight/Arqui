.section .data
msg_even:    .ascii "El numero es par.\n"
msg_even_len = . - msg_even
msg_odd:     .ascii "El numero es impar.\n"
msg_odd_len = . - msg_odd

.section .bss

.section .text
.global _start

_start:
    // Generar número aleatorio
    mov x0, 0                   // syscall number for getrandom
    mov x1, sp                  // buffer to store the random number
    mov x2, 4                   // size of the random number (4 bytes for a 32-bit number)
    mov x8, 278                 // syscall number for getrandom
    svc 0                       // invoke syscall

    ldr w0, [sp]                // cargar el número aleatorio generado en w0
    and w1, w0, #1              // w1 = w0 & 1, verifica si el número es par o impar

    cbz w1, print_even          // si w1 es 0, el número es par, salta a print_even

    // Caso impar
    ldr x0, =msg_odd            // cargar la dirección del mensaje impar en x0
    ldr x1, =msg_odd_len        // cargar la longitud del mensaje impar en x1
    bl print_message            // llamar a la función print_message
    b exit                      // saltar a exit

print_even:
    // Caso par
    ldr x0, =msg_even           // cargar la dirección del mensaje par en x0
    ldr x1, =msg_even_len       // cargar la longitud del mensaje par en x1
    bl print_message            // llamar a la función print_message

exit:
    mov x8, 93                  // syscall number for exit
    mov x0, 0                   // exit code 0
    svc 0                       // invoke syscall

print_message:
    // Imprimir mensaje (usa syscall write)
    mov x8, 64                  // syscall number for write
    mov x1, x0                  // file descriptor (stdout)
    mov x2, x0                  // pointer to the message
    mov x3, x1                  // message length
    mov x0, 1                   // stdout
    svc 0                       // invoke syscall
    ret                         // retornar
