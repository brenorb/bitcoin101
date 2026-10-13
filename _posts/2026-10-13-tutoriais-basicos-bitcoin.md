---
title: "Três tutoriais básicos para entender Bitcoin na prática"
date: 2026-10-13 00:00:00 -0300
categories:
  - Guia
  - Iniciantes
  - Tutoriais
author_staff_member: breno-brito
image: "/uploads/livro.png"
large_header: false
description: "Aprenda a ler um bloco, acompanhar uma transação e experimentar envio e confirmação em uma regtest local, sem usar dinheiro real."
---

Você pode observar como o Bitcoin funciona antes de comprar bitcoin ou escolher uma carteira. Os dois primeiros exercícios usam apenas dados públicos no navegador. O terceiro é opcional: um laboratório local no terminal, com moedas de teste.

## 1. Ler um bloco no explorador

**Objetivo:** distinguir a altura do bloco de seu identificador e observar as transações agrupadas nele.

1. Abra o [bloco 800.000 no mempool.space](https://mempool.space/block/00000000000000000002a7c4c1e48d76c5a37902165a270156b7a8d72728a054).
2. Localize a altura, o hash do bloco e a quantidade de transações.
3. Abra o bloco anterior pelo link do explorador e observe sua altura.
4. Escreva, com suas palavras, a diferença entre **altura** e **hash**: a primeira é uma posição na cadeia; o segundo identifica o conteúdo do cabeçalho do bloco.

O explorador é uma interface para consultar dados. Para aprender o que um nó verifica, use também o [guia de cadeia de blocos](https://developer.bitcoin.org/devguide/block_chain.html). Abrir uma página de explorador não equivale a validar a cadeia por conta própria.

## 2. Acompanhar uma transação sem enviar dinheiro

**Objetivo:** reconhecer entradas, saídas, taxa e inclusão em um bloco.

1. Na lista do bloco, escolha uma transação comum, não a transação **coinbase**, que cria a recompensa do bloco.
2. Abra a transação e localize seu identificador (**txid**), as entradas e as saídas.
3. Compare a soma dos valores das entradas com a soma das saídas. Para uma transação comum, a diferença é a taxa.
4. Confira o bloco em que ela foi incluída e o número de confirmações mostrado pelo explorador.

Uma saída pode ser um pagamento, troco ou ter outra finalidade. Os dados do explorador, sozinhos, não dizem quem são as pessoas envolvidas nem qual saída é o troco. Confirmações indicam profundidade na cadeia; não são uma promessa absoluta de irreversibilidade.

Para conferir essas relações, consulte as fontes sobre [transações](https://developer.bitcoin.org/devguide/transactions.html) e [cadeia de blocos](https://developer.bitcoin.org/devguide/block_chain.html). Neste exercício não é necessário informar um endereço seu nem conectar uma carteira.

## 3. Enviar e confirmar moedas numa regtest local

**Objetivo:** observar o caminho de uma transação de zero para uma confirmação.

Esta parte usa terminal **Bash em macOS ou Linux**, com `bitcoind` e `bitcoin-cli` do [Bitcoin Core](https://bitcoincore.org/en/download/) já instalados e disponíveis no `PATH`. Os comandos foram conferidos com Bitcoin Core 31.1.

**Regtest é uma cadeia privada de teste. Seu saldo não é bitcoin da rede principal e não tem valor monetário.** Os comandos abaixo usam uma pasta nova e desligam a atividade de rede do nó. Mantenha `-regtest` e a mesma pasta em todos os comandos.

### Criar o laboratório

```bash
btc_tutorial_dir=$(mktemp -d)
bitcoind -regtest -datadir="$btc_tutorial_dir" -daemonwait \
  -networkactive=0 -listen=0 -fallbackfee=0.0001

bitcoin-cli -regtest -datadir="$btc_tutorial_dir" createwallet estudos
bitcoin-cli -regtest -datadir="$btc_tutorial_dir" createwallet receptora

endereco_mineracao=$(bitcoin-cli -regtest -datadir="$btc_tutorial_dir" \
  -rpcwallet=estudos getnewaddress)
bitcoin-cli -regtest -datadir="$btc_tutorial_dir" \
  generatetoaddress 101 "$endereco_mineracao"
bitcoin-cli -regtest -datadir="$btc_tutorial_dir" \
  -rpcwallet=estudos getbalance
```

Nessa cadeia nova, o último comando mostra **50.00000000** disponíveis para a carteira `estudos`. Geramos 101 blocos para que a primeira recompensa tenha maturado. A taxa de fallback é apenas uma configuração deste laboratório: sem histórico suficiente, o nó não consegue estimar automaticamente uma taxa para o envio.

### Enviar e conferir a confirmação

```bash
endereco_destino=$(bitcoin-cli -regtest -datadir="$btc_tutorial_dir" \
  -rpcwallet=receptora getnewaddress)
txid=$(bitcoin-cli -regtest -datadir="$btc_tutorial_dir" \
  -rpcwallet=estudos sendtoaddress "$endereco_destino" 1)

bitcoin-cli -regtest -datadir="$btc_tutorial_dir" \
  -rpcwallet=estudos gettransaction "$txid"
bitcoin-cli -regtest -datadir="$btc_tutorial_dir" \
  generatetoaddress 1 "$endereco_mineracao"
bitcoin-cli -regtest -datadir="$btc_tutorial_dir" \
  -rpcwallet=estudos gettransaction "$txid"
bitcoin-cli -regtest -datadir="$btc_tutorial_dir" \
  -rpcwallet=receptora getbalance
```

Compare o campo `confirmations`: antes do novo bloco ele é **0**; depois, **1**. A carteira `receptora` passa a mostrar **1.00000000** confirmado. Assim você separa duas etapas: criar/enviar a transação e incluí-la em um bloco.

### Encerrar

```bash
bitcoin-cli -regtest -datadir="$btc_tutorial_dir" stop
```

A pasta indicada em `btc_tutorial_dir` contém apenas este laboratório e pode ser mantida para inspeção. Não use uma carteira real ou uma pasta de dados já existente neste exercício.

Fontes para aprofundar: [modo regtest](https://developer.bitcoin.org/examples/testing.html), [createwallet](https://bitcoincore.org/en/doc/31.0.0/rpc/wallet/createwallet/) e [gettransaction](https://bitcoincore.org/en/doc/31.0.0/rpc/wallet/gettransaction/).

## Continuar estudando

Se os termos ainda parecem novos, volte ao [capítulo sobre fontes de estudo]({% post_url 2023-05-27-onde-posso-informar-melhor %}) ou à [lista de livros introdutórios]({% post_url 2026-03-14-5-melhores-livros-para-aprender-bitcoin %}). Para aprender sobre custódia e backups, consulte também a [orientação de segurança do Bitcoin.org](https://bitcoin.org/pt_BR/proteja-sua-carteira).

Você terminou estes exercícios quando consegue explicar a diferença entre bloco e transação, entre enviar e confirmar, e entre um saldo de laboratório e bitcoin da rede principal.
