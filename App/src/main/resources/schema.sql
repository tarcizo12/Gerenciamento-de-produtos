CREATE TABLE IF NOT EXISTS produto (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    data_vencimento DATETIME NOT NULL,
    categoria TINYINT NOT NULL,
    CONSTRAINT chk_categoria
    CHECK (categoria IN (0, 1, 2))
)

/*
* A ideia pro campo categoria é que tenha alguma maneira de agrupar os dados por tipo, e criar alguma regra em cima disso
* 0 - Produtos de higiene , 1 - Produtos pereciveis , 2 - Produtos NÃO pereciveis
*
*/