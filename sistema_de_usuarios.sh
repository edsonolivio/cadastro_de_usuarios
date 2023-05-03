#!/usr/bin/env bash

ARQUIVO_DADOS="arquivo_de_dados.txt"
TEMP="arquivo_de_dados.tmp"
VERDE="\e[32;1m"
F_VERDE="\e[32;0m"
AMARELO="\e[33;1m"
F_AMARELO="\e[33;0m"
VERMELHO="\e[31;1m"
F_VERMELHO="\e[31;0m"

[ ! -e "$ARQUIVO_DADOS" ] && echo $VERMELHO"--> Arquivo não existe !!"$F_VERMELHO && exit 1
[ ! -r "$ARQUIVO_DADOS" ] && echo $VERMELHO"--> Arquivo não tem permisão de leitura !!"$F_VERMELHO && exit 1
[ ! -w "$ARQUIVO_DADOS" ] && echo $VERMELHO"--> Arquivo não tem permisão de escrita !!"$F_VERMELHO && exit 1

cadastro_usuario(){
    read -p "Nome do usuário: " cad_nome
    nome=$(echo "$cad_nome" | tr '[:upper:]' '[:lower:]')
    read -p "Sobrenome do usuário: " cad_sobrenome
    sobrenome=$(echo "$cad_sobrenome" | tr '[:upper:]' '[:lower:]')
    if [ "$(grep -i $cad_nome "$ARQUIVO_DADOS")" ] && [ "$(grep -i $cad_sobrenome "$ARQUIVO_DADOS")" ]; then
        echo "${VERMELHO}"USUARIO JÁ CADASTRADO!! "${F_VERMELHO}""${VERDE}"Aguarde..."${F_VERDE}" && sleep 2
        else
            cod="$(tail -n1 $ARQUIVO_DADOS | cut -d: -f 1)"
            id="$(expr $cod + 1)"
            read -p "Email: " email
            echo $id:$nome.$sobrenome:$email >> $ARQUIVO_DADOS
            echo echo $nome $sobrenome,"${AMARELO}" cadastrado com sucesso !!"${F_AMARELO}" && sleep 2
    fi
}

procura_usuario(){
    read -p "Qual usuario? " usuario
        ValidaUsuario
    if [ $? -eq 0 ]; then
        while read nome; do
            local id="$(grep -i $usuario $ARQUIVO_DADOS | cut -d: -f 1)"
            local nome="$(grep -i $usuario $ARQUIVO_DADOS | cut -d: -f 2 | tr '[:lower:]' '[:upper:]')"
            local email="$(grep -i $usuario $ARQUIVO_DADOS | cut -d: -f 3)"
            clear
            
            echo "${AMARELO}"Codigo: "${F_AMARELO}""$id"
            echo "${AMARELO}"Nome: "${F_AMARELO}" "$nome" 
            echo "${AMARELO}"Email: "${F_AMARELO}""$email"
            echo "${AMARELO}"------------------------------"${F_AMARELO}"
            
        done < "$ARQUIVO_DADOS"
        echo "${VERDE}"Pressione "ENTER" para continuar"${F_VERDE}"
        read enter
        clear
    else
        echo "${VERMELHO}"USUARIO NÃO ENCONTRADO!! "${F_VERMELHO}""${VERDE}"Aguarde..."${F_VERDE}" && sleep 2 && clear
    fi
}

remove_usuario(){
    read -p "Qual usuário deseja REMOVER?: " usuario
    ValidaUsuario
    if [ $? -eq 0 ]; then
        clear
        local nome="$(grep -i $usuario $ARQUIVO_DADOS | cut -d: -f 2 | tr '[:lower:]' '[:upper:]')"
        read -p "REMOVER o usuário $nome (s/n) ? " remover
        if [ $remover = "s" ]; then
            grep -i -v $usuario $ARQUIVO_DADOS > $TEMP
            cp -R "$TEMP" "$ARQUIVO_DADOS"
            echo $nome,"${AMARELO}" REMOVIDO com sucesso !!"${F_AMARELO}" && sleep 2
        fi
    else
        echo "${VERMELHO}"USUARIO NÃO ENCONTRADO!! "${F_VERMELHO}""${VERDE}"Aguarde..."${F_VERDE}" && sleep 2
   fi
}

ValidaUsuario() {
    grep -i $usuario "$ARQUIVO_DADOS"
}

lista(){
    less "$ARQUIVO_DADOS"
}

while true; do
    clear
    echo "${AMARELO}""== Cadastro de usuários ==""${F_AMARELO}"
    echo "${AMARELO}"" 1 -"${F_AMARELO}" Procurar"
    echo "${AMARELO}"" 2 - "${F_AMARELO}"Cadastrar"
    echo "${AMARELO}"" 3 - "${F_AMARELO}"Listar todos os usuários(q para sair)"
    echo "${VERMELHO}"" 4 - Remover"${F_VERMELHO}""
    echo "${AMARELO}"" 5 - "${F_AMARELO}"Sair do sistema"
    echo "${AMARELO}""----------------------------""${F_AMARELO}"
    read -p "Opção: " opcao_menu

    case $opcao_menu in
        1) procura_usuario     ;;
        2) cadastro_usuario  ;;
        3) lista ;;
        4) remove_usuario   ;;
        5) exit 1 ;;
        *) echo "${VERMELHO}"OPÇÃO INVALIDA!!"${F_VERMELHO}""${VERDE}" Aguarde..."${F_VERDE}" && sleep 1 && clear ;;
    esac
done
