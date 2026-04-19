package api.produtos.service;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;

@ExtendWith(MockitoExtension.class)
class ProdutoServiceTest {

    @Mock
    private ProdutoService produtoService;

    @Test
    void deveRetornarListaDeProdutos() {
        //Arrange
        List<String> list = produtoService.findAllProdutos();

        String breakpoint = "";
    }
}

