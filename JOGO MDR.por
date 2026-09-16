programa {
    inclua biblioteca Matematica --> m
    inclua biblioteca Util --> u
 
    // Variáveis globais de controle do jogo
    cadeia tabuleiro[5][5]
    real percNivel1, percNivel2, percNivel3
    inteiro casasNivel1, casasNivel2, casasNivel3
    inteiro bateria = 100
 
    funcao inicio() {
        ConfigurarNiveis()
        CalcularCasasPorNivel()
        GerarCenario()
        ExecutarJogo()
    }
 
    // Entrada e validação dos percentuais (soma estrita de 100%)
    funcao ConfigurarNiveis() {
        faca {
            escreva("=== CONFIGURAÇÃO DOS NÍVEIS ===\n")
            escreva("Percentual do Nível I (ex: 25): ")
            leia(percNivel1)
            escreva("Percentual do Nível II (ex: 35): ")
            leia(percNivel2)
            escreva("Percentual do Nível III (ex: 40): ")
            leia(percNivel3)
 
            se (percNivel1 + percNivel2 + percNivel3 != 100.0) {
                escreva("\n[ERRO] A soma dos percentuais deve ser exatamente 100%. Tente novamente.\n\n")
            }
        } enquanto (percNivel1 + percNivel2 + percNivel3 != 100.0)
    }
 
    // Cálculo da quantidade de casas por nível com arredondamento
    funcao CalcularCasasPorNivel() {
        real calcNivel1 = (percNivel1 / 100.0) * 25.0
        real calcNivel2 = (percNivel2 / 100.0) * 25.0
        casasNivel1 = m.arredondar(calcNivel1, 0)
        casasNivel2 = m.arredondar(calcNivel2, 0)
        casasNivel3 = 25 - (casasNivel1 + casasNivel2)
        escreva("\nDistribuição: Nível I (", casasNivel1, " casas) | Nível II (", casasNivel2, " casas) | Nível III (", casasNivel3, " casas)\n")
    }
 
    // Função Obrigatória: Inicialização da matriz e sorteio de elementos
    funcao GerarCenario() {
        inteiro linhaSorteada, colunaSorteada, numeroCasa
        logico posicaoValida
 
        // Inicializa todas as 25 casas como vazias
        para (inteiro l = 0; l < 5; l++) {
            para (inteiro c = 0; c < 5; c++) {
                tabuleiro[l][c] = "---"
            }
        }
 
        // Sorteio de B05
        faca {
            linhaSorteada = u.sorteia(0, 4)
            colunaSorteada = u.sorteia(0, 4)
        } enquanto (tabuleiro[linhaSorteada][colunaSorteada] != "---")
        tabuleiro[linhaSorteada][colunaSorteada] = "B05"
 
        // Sorteio de B10
        faca {
            linhaSorteada = u.sorteia(0, 4)
            colunaSorteada = u.sorteia(0, 4)
        } enquanto (tabuleiro[linhaSorteada][colunaSorteada] != "---")
        tabuleiro[linhaSorteada][colunaSorteada] = "B10"
 
        // Sorteio de RIS (Proibido no Nível I)
        faca {
            posicaoValida = falso
            linhaSorteada = u.sorteia(0, 4)
            colunaSorteada = u.sorteia(0, 4)
            numeroCasa = (linhaSorteada * 5) + colunaSorteada + 1
            se (tabuleiro[linhaSorteada][colunaSorteada] == "---" e numeroCasa > casasNivel1) {
                posicaoValida = verdadeiro
            }
        } enquanto (posicaoValida == falso)
        tabuleiro[linhaSorteada][colunaSorteada] = "RIS"
 
        // Sorteio de $$$ (Proibido no Nível I)
        faca {
            posicaoValida = falso
            linhaSorteada = u.sorteia(0, 4)
            colunaSorteada = u.sorteia(0, 4)
            numeroCasa = (linhaSorteada * 5) + colunaSorteada + 1
            se (tabuleiro[linhaSorteada][colunaSorteada] == "---" e numeroCasa > casasNivel1) {
                posicaoValida = verdadeiro
            }
        } enquanto (posicaoValida == falso)
        tabuleiro[linhaSorteada][colunaSorteada] = "$$$"
    }
 
    // Funções Obrigatórias: Manipulação de bateria
    funcao DiminuirBateria() {
        bateria = bateria - 10
    }
 
    funcao Bonus(inteiro valor) {
        bateria = bateria + valor
    }
 
    funcao Risco() {
        bateria = bateria - 3
    }
 
    // Auxiliar: Determina o nível da casa percorrida
    funcao inteiro ObterNivelAtual(inteiro casa) {
        se (casa <= casasNivel1) {
            retorne 1
        } senao se (casa <= (casasNivel1 + casasNivel2)) {
            retorne 2
        } senao {
            retorne 3
        }
    }
 
    // Fluxo principal da partida (Game Loop)
    funcao ExecutarJogo() {
        inteiro linha, coluna, casaAtual = 0
        cadeia conteudo
        logico vitoria = falso
 
        escreva("\n=== INICIANDO A CAÇA AO TESOURO ===\n")
 
        para (inteiro casa = 1; casa <= 25; casa++) {
            se (bateria < 10) {
                escreva("\n[ALERTA] Bateria insuficiente para iniciar a próxima rodada!\n")
                pare
            }
 
            casaAtual = casa
            linha = (casa - 1) / 5
            coluna = (casa - 1) % 5
 
            DiminuirBateria()
            conteudo = tabuleiro[linha][coluna]
 
            escreva("Rodada ", casa, " | Posição [", linha, "][", coluna, "] | Conteúdo: ", conteudo)
 
            se (conteudo == "B05") {
                Bonus(5)
                escreva(" -> Bônus ativado! (+5 créditos)")
            } senao se (conteudo == "B10") {
                Bonus(10)
                escreva(" -> Bônus ativado! (+10 créditos)")
            } senao se (conteudo == "RIS") {
                Risco()
                escreva(" -> Risco ativado! (-3 créditos)")
            } senao se (conteudo == "$$$") {
                escreva(" -> ENCONTROU O TESOURO!")
                vitoria = verdadeiro
                pare
            }
 
            escreva(" | Bateria Restante: ", bateria, "\n")
        }
 
        ExibirRelatorioFinal(vitoria, casaAtual, ObterNivelAtual(casaAtual))
    }
 
    // Relatório de encerramento e exibição da matriz
    funcao ExibirRelatorioFinal(logico vitoria, inteiro rodadasTotais, inteiro nivelAtingido) {
        escreva("\n====================================\n")
        escreva("       RELATÓRIO FINAL DO JOGO      \n")
        escreva("====================================\n")
        se (vitoria) {
            escreva("Resultado        : VITÓRIA (Tesouro Encontrado!)\n")
        } senao {
            escreva("Resultado        : DERROTA (Bateria Esgotada)\n")
        }
        escreva("Bateria Restante : ", bateria, " créditos\n")
        escreva("Total de Rodadas : ", rodadasTotais, "\n")
        escreva("Nível Atingido   : Nível ", nivelAtingido, "\n")
        escreva("------------------------------------\n")
        escreva("MAPA REVELADO:\n\n")
 
        para (inteiro l = 0; l < 5; l++) {
            para (inteiro c = 0; c < 5; c++) {
                escreva("[", tabuleiro[l][c], "]\t")
            }
            escreva("\n")
        }
        escreva("====================================\n")
    }
}