section .text
    global _start

    _start:
        push ebp            ; Salva o ponteiro da base da pilha atual
        mov ebp, esp        ; Inicializa o ponteiro da base da pilha

        ; MENSAGEM DE BOAS VINDAS
        mov edx, len        ; Tamanho da mensagem de boas-vindas
        mov ecx, menu       ; Endere?o da mensagem de boas-vindas
        mov ebx, 1          ; Descritor de arquivo para sa?da padr?o (stdout)
        mov eax, 4          ; Chamada do sistema para escrever
        int 0x80            ; Interrup??o para syscall

        ; ENTRADA DO TECLADO (USU?RIO DIGITA A QUANTIDADE DE DISCOS)
        mov edx, 5          ; Tamanho do buffer de entrada
        mov ecx, disk       ; Endere?o do buffer de entrada
        mov ebx, 0          ; Descritor de arquivo para entrada padr?o (stdin)
        mov eax, 3          ; Chamada do sistema para ler
        int 0x80            ; Interrup??o para syscall

        mov edx, disk       ; Endere?o do buffer convertido em string
        call str_to_int          ; Chama a fun??o para converter string para inteiro

        push dword 2        ; Pino intermedi?rio
        push dword 3        ; Pino de destino
        push dword 1        ; Pino de origem
        push eax            ; N?mero de discos
        call hanoi          ; Chama a fun??o de resolu??o da Torre de Hanoi

        ; Finaliza??o do programa
        mov eax, 1          ; Chamada do sistema para sair
        mov ebx, 0          ; C?digo de sa?da
        int 0x80            ; Interrup??o para syscall

    str_to_int:
        xor eax, eax        ; Limpa o registrador eax
        mov ebx, 10         ; Base decimal

        .loop:
            movzx ecx, byte [edx]  ; Carrega o byte da string
            inc edx                ; Move para o pr?ximo caractere
            cmp ecx, '0'           ; Compara com '0'
            jb .done               ; Se menor, termina o loop
            cmp ecx, '9'           ; Compara com '9'
            ja .done               ; Se maior, termina o loop

            sub ecx, '0'           ; Converte caractere para valor num?rico
            imul eax, ebx          ; Multiplica eax por 10
            add eax, ecx           ; Adiciona o valor num?rico a eax
            jmp .loop              ; Loop de repeti??o

        .done:
            test eax, eax
            jz erro 
            ret
    erro:
    mov eax, 4
    mov ebx, 1
    mov ecx, inv
    mov edx, len_inv
    int 0x80
    
    jmp _start

    hanoi:
        push ebp            ; Salva o ponteiro da base da pilha atual
        mov ebp, esp        ; Inicializa o ponteiro da base da pilha
        mov eax, [ebp+8]    ; N?mero de discos
        cmp eax, 0          ; Verifica se n?o h? discos para mover
        je desempilhar      ; Se n?o, desempilha a pilha

        push dword [ebp+16] ; Pino de destino
        push dword [ebp+20] ; Pino intermedi?rio
        push dword [ebp+12] ; Pino de origem
        dec eax             ; Decrementa o n?mero de discos
        push dword eax      ; Empilha o novo n?mero de discos
        call hanoi          ; Chama recursivamente para mover discos
        add esp, 16         ; Desempilha os argumentos

        push dword [ebp+16] ; Pino intermedi?rio
        push dword [ebp+12] ; Pino de origem
        push dword [ebp+8]  ; N?mero de discos restantes
        call imprimir       ; Chama a fun??o para imprimir movimento
        add esp, 12         ; Desempilha os argumentos

        push dword [ebp+12] ; Pino de origem
        push dword [ebp+16] ; Pino de destino
        push dword [ebp+20] ; Pino intermedi?rio
        mov eax, [ebp+8]    ; N?mero de discos restantes
        dec eax             ; Decrementa o n?mero de discos
        push dword eax      ; Empilha o novo n?mero de discos
        call hanoi          ; Chama recursivamente para mover discos

    desempilhar:
        mov esp, ebp        ; Restaura o ponteiro da pilha
        pop ebp             ; Desempilha a base da pilha
        ret                 ; Retorna

    imprimir:
        push ebp            ; Salva o ponteiro da base da pilha atual
        mov ebp, esp        ; Inicializa o ponteiro da base da pilha
        mov eax, [ebp + 8]  ; N?mero do disco
        add al, 48           ; Converte para caractere ASCII
        mov [disco], al     ; Armazena o caractere no buffer disco

        mov eax, [ebp + 12] ; Pino de destino
        add al, 64           ; Converte para caractere ASCII
        mov [torre_saida], al ; Armazena o caractere no buffer torre_saida

        mov eax, [ebp + 16] ; Pino de origem
        add al, 64           ; Converte para caractere ASCII
        mov [torre_ida], al   ; Armazena o caractere no buffer torre_ida

        mov edx, lenght      ; Tamanho da mensagem
        mov ecx, msg         ; Endere?o da mensagem
        mov ebx, 1           ; Descritor de arquivo para sa?da padr?o (stdout)
        mov eax, 4           ; Chamada do sistema para escrever
        int 128              ; Interrup??o para syscall

        mov esp, ebp        ; Restaura o ponteiro da pilha
        pop ebp             ; Desempilha a base da pilha
        ret                 ; Retorna

section .data
    menu db 'DIGITE A QUANTIDADE DE DISCOS: ', 0xa ; Mensagem de boas-vindas
    len equ $-menu         ; Tamanho da mensagem de boas-vindas
    
    inv db 'Erro: Utilize apenas n?meros inteiros ', 0xa
    len_inv equ $ - inv
   
    msg:
        db "Mova o disco " ; Mensagem para impress?o
        disco: db " "       ; Buffer para n?mero do disco
        db " da torre "
        torre_saida: db " " ; Buffer para pino de destino
        db " para a torre "
        torre_ida: db " ", 0xa ; Buffer para pino de origem, com nova linha
    lenght equ $-msg        ; Tamanho da mensagem

section .bss
    disk resb 5             ; Buffer para a entrada do n?mero de discos
