#!/bin/bash
set -e
cd "$(dirname "$0")"
echo "=== Publicar Órbita no GitHub ==="
if ! command -v git >/dev/null 2>&1; then echo 'Git não está instalado. Instale as ferramentas de linha de comando do macOS com: xcode-select --install'; read -p 'Enter para sair'; exit 1; fi
if [ ! -f orbita_site_com_videos.zip ]; then echo 'Coloque orbita_site_com_videos.zip na mesma pasta deste instalador.'; read -p 'Enter para sair'; exit 1; fi
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
unzip -q orbita_site_com_videos.zip -d "$WORK/site"
echo 'Conectando ao repositório...'
if ! git clone https://github.com/antoniatrocha/Orbita.git "$WORK/repo"; then echo 'Não foi possível conectar ao GitHub. Verifique login/permissões.'; read -p 'Enter para sair'; exit 1; fi
cp -R "$WORK/site/". "$WORK/repo/"
cd "$WORK/repo"
git add -A
if git diff --cached --quiet; then echo 'Os arquivos já estão atualizados.'; else
 git commit -m 'Publicar apresentação Órbita com 64 slides e vídeos'
 git push origin main
fi
echo ''
echo 'Arquivos enviados com sucesso!'
echo 'Se ainda não ativou o GitHub Pages: Settings > Pages > Deploy from a branch > main > /(root) > Save'
echo 'URL: https://antoniatrocha.github.io/Orbita/'
read -p 'Pressione Enter para fechar...'
