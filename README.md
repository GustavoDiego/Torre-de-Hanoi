# Torre-de-Hanoi

Este é um programa Assembly que resolve o problema da Torre de Hanoi. A Torre de Hanoi é um quebra-cabeça matemático que envolve a movimentação de discos entre três pinos. O objetivo é mover a pilha de discos de um pino de origem para um pino de destino, utilizando um pino intermediário, seguindo algumas regras específicas.

Funcionamento do Programa

1.	O programa inicia exibindo uma mensagem de boas-vindas, solicitando ao usuário que digite a quantidade de discos para a Torre de Hanoi.
   
2.	O usuário digita o número de discos no teclado.
	
3.	O programa converte a entrada do usuário em um número inteiro.
	
4.	Utilizando a lógica recursiva, o programa resolve a Torre de Hanoi para a quantidade especificada de discos, exibindo os movimentos realizados.

5.	O programa encerra, exibindo uma mensagem de despedida

Funções Principais

•	_atoi: Converte uma string para um número inteiro.

•	erro: Exibe uma mensagem de erro caso a conversão da entrada do usuário para inteiro falhe.

•	hanoi: Função recursiva para resolver a Torre de Hanoi.

•	desempilhar: Desempilha a pilha e retorna.

•	imprimir: Exibe os movimentos realizados na Torre de Hanoi.

Variáveis e Mensagens

•	menu: Mensagem de boas-vindas.

•	inv: Mensagem de erro para entrada inválida.

•	msg: Mensagem utilizada para imprimir os movimentos realizados.
