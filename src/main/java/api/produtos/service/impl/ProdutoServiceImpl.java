package api.produtos.service.impl;

import api.produtos.service.ProdutoService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProdutoServiceImpl implements ProdutoService {
    @Override
    public List<String> findAllProdutos() {
        return List.of("Hello world");
    }
}
