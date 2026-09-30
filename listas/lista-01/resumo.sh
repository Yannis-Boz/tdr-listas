#!/usr/bin/env bash
set -euo pipefail

# Garante que recusará rodar se faltar argumento
if [ "$#" -lt 2 ]; then
    echo "Erro: Uso incorreto. Informe o arquivo e a coluna." >&2
    echo "Uso: $0 <arquivo.csv> <numero_da_coluna>" >&2
    exit 1
fi

ARQUIVO="$1"
COLUNA="$2"

# 1. Nome da coluna lido do cabeçalho
NOME_COLUNA=$(head -1 "$ARQUIVO" | cut -d',' -f"$COLUNA" | tr -d '"\r')

# 2. Número de observações
TOTAL_LINHAS=$(wc -l < "$ARQUIVO")
TOTAL_OBS=$((TOTAL_LINHAS - 1))

# 3. Quantidade de valores NA
VALORES_NA=$(cut -d',' -f"$COLUNA" "$ARQUIVO" | tail -n +2 | grep -x -c "NA" || true)

# Exibe as informações gerais
echo "Nome da coluna: $NOME_COLUNA"
echo "Número de observações: $TOTAL_OBS"
echo "Valores NA: $VALORES_NA"
echo "Média por mês:"

# 4. Cálculo da média por mês via awk
tail -n +2 "$ARQUIVO" | awk -F',' -v col="$COLUNA" '
BEGIN {
    m_nome[5]="Mai"; m_nome[6]="Jun"; m_nome[7]="Jul";
    m_nome[8]="Ago"; m_nome[9]="Set";
}
{
    val = $col
    mes = $5
    
    gsub(/"|\r/, "", val)
    gsub(/"|\r/, "", mes)
    
    if (val != "NA" && val != "") {
        soma[mes] += val
        dias[mes]++
    }
}
END {
    for (m = 5; m <= 9; m++) {
        if (dias[m] > 0) {
            media = soma[m] / dias[m]
            printf "  %s: Média = %.2f (%d dias medidos)\n", m_nome[m], media, dias[m]
        }
    }
}
'
