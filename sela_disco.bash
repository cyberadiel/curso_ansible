#!/bin/bash

# ==========================================================
# Script de Selamento de Evidência para Auditoria
# ==========================================================

# 1. Configurações (Caminhos)
DISCO="/data/vms/ansible/ansible.vdi"
MANIFESTO="manifesto_ansible_vdi.txt"

echo "Iniciando o processo de selamento do disco: $DISCO..."

# 2. Verifica se o arquivo de disco existe antes de continuar
if [ ! -f "$DISCO" ]; then
    echo "ERRO: O arquivo de disco não foi encontrado em $DISCO"
    exit 1
fi

# 3. Coletando as evidências e gerando o manifesto
echo "Gerando hash SHA256 (isso pode demorar dependendo do tamanho do disco)..."
{
  echo "=== RELATÓRIO DE INTEGRIDADE E COMPLIANCE ==="
  echo "Data do Selo: $(date '+%d/%m/%Y %H:%M:%S')"
  echo "Caminho do Disco: $DISCO"
  echo "Tamanho em Bytes: $(stat -c%s "$DISCO")"
  echo "------------------------------------------"
  echo "HASH SHA256 (ASSINATURA DO DISCO):"
  sha256sum "$DISCO"
} > "$MANIFESTO"

# 4. Selando o manifesto com GPG (Lacre Digital)
echo "Assinando digitalmente o manifesto..."
gpg --clearsign --digest-algo SHA256 "$MANIFESTO"

# 5. Limpeza
rm "$MANIFESTO" # Remove o arquivo .txt comum, deixando apenas o assinado (.asc)

echo "------------------------------------------------------"
echo "PROCESSO CONCLUÍDO COM SUCESSO!"
echo "Evidência gerada: ${MANIFESTO}.asc"
echo "------------------------------------------------------"