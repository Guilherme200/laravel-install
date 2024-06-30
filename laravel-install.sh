docker info > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "Docker não está em execução."
    exit 1
fi

read -p "Nome do projeto: " PROJECT_NAME

if [ -z "${PROJECT_NAME}" ]; then
  echo "O nome do projeto não pode estar vazio."
  exit 1
fi

echo "Projeto: ${PROJECT_NAME}"

docker run --rm \
    --pull=always \
    -v "$(pwd)":/opt \
    -w /opt \
    laravelsail/php83-composer:latest \
    bash -c "laravel new ${PROJECT_NAME} --no-interaction && cd ${PROJECT_NAME} && php ./artisan sail:install --with=pgsql,redis"

cd ${PROJECT_NAME}

CYAN='\033[0;36m'
LIGHT_CYAN='\033[1;36m'
BOLD='\033[1m'
NC='\033[0m'

echo ""

if sudo -n true 2>/dev/null; then
    sudo chown -R $USER: .
    echo "${BOLD}Iniciar aplicação:${NC} cd ${PROJECT_NAME} && ./vendor/bin/sail up"
else
    echo "${BOLD}Forneça sua senha para que possamos fazer alguns ajustes finais nas permissões da sua aplicação.${NC}"
    echo ""
    sudo chown -R $USER: .
    echo ""
    echo "${BOLD}Iniciar aplicação:${NC} cd ${PROJECT_NAME} && ./vendor/bin/sail up"
fi
