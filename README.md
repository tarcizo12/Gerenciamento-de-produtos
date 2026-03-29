# Gerenciamento-de-produtos. Projeto backend com fins educativos

## Orientações Iniciais 

### Como subir a aplicação no docker compose
```bash
docker compose up --build
````

### Como entrar no container do banco de dados MYSQL

- 1º Entrar no container ``docker exec -it mysql-dev bash``

- 2º Conectar ao banco de dados dentro do bash e digitar a senha que foi definida no .env ``mysql -u root -p``

### Requisições na api local
* Para testar se api esta no ar ``http://localhost:8080/produtos/ping``

### Como foi gerado a imagem  para publicação no Docker hub
* Executar na raiz do projeto para gerar o .jar:``./mvnw clean package``
* Buildar a imagem:``docker build -t gerenciamento-produtos:1.0 .``
* Subir o docker com a imagem gerada ``docker run -p 8080:8080 gerenciamento-produtos:1.0``
