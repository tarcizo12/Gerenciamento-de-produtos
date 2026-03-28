# Gerenciamento-de-produtos
Projeto backend com fins educativos


## Orientações Iniciais 

### Como entrar no container do banco de dados MYSQL

- 1º Entrar no container ``docker exec -it mysql-dev bash``

- 2º Conectar ao banco de dados dentro do bash e digitar a senha que foi definida no .env ``mysql -u root -p``

### Requisições na api local
* Para testar se api esta up ``http://localhost:8080/produtos/ping``