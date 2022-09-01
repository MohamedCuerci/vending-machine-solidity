// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract BeerVending {

  string public nomeAplicacao;
  uint public qtdProduto = 0;

  mapping(uint => Produto) public produtos;

  struct Produto {
    uint idProduto;
    string nomeProduto;
    uint preco;
    address payable owner;
    bool vendido;
  }

  event ProdutoCriado(
    uint idProdutoCriado,
    string nomeProdutoCriado,
    uint precoProdutoCriado,
    address payable owner,
    bool vendido
  );

  event ProdutoVendido(
    uint idProdutoVendido,
    string nomeProdutoVendido,
    uint precoProdutoVendido,
    address payable owner,
    bool vendido
  );

  constructor() {
    nomeAplicacao = "dAPP BEER MACHINE";
  }

  function criarProduto(string memory _nome, uint _preco) public {
    //verifica se o produto tem nome válido
    require(bytes(_nome).length > 0, unicode"ERRO: Nome inválido");
    require(_preco > 0, unicode"ERRO: preço inválido");

    qtdProduto += 1; // ou qtdProduto ++;

    produtos[qtdProduto] = Produto(qtdProduto, _nome, _preco, payable(msg.sender), false);

    //chamar evento
    emit ProdutoCriado(qtdProduto, _nome, _preco, payable(msg.sender), false);
  }

  function comprarProduto(uint _id) public payable {
    Produto memory _produto = produtos[_id];

    address payable _vendedor = _produto.owner; // comprador do pdotuto

    require(_produto.idProduto > 0 && _produto.idProduto <= qtdProduto);
    require(msg.value >= _produto.preco); //tem grana suficinte ?
    require(!_produto.vendido);//produto ja foi vendido ?
    require(_vendedor != msg.sender); //comprador não pode ser o vendedor

    _produto.owner = payable(msg.sender); //quem comrpou se torna o dono
    _produto.vendido = true;

    //atualizar estoque
    produtos[_id] = _produto;

    //vendedor recebe a grana pelos produto
    payable(_vendedor).transfer(msg.value);

    emit ProdutoVendido(qtdProduto, _produto.nomeProduto, _produto.preco, payable(msg.sender), true);
  }
}
