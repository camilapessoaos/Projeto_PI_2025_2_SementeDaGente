# 📄 Projeto Integrador: Sistema de Gerenciamento "Semente da Gente" 🌱

Este repositório contém a documentação técnica e os scripts SQL para o projeto de Banco de Dados "Semente da Gente", um sistema focado no controle de estoque, logística e distribuição de sementes agrícolas.

## I. Descrição Detalhada do Minimundo (Escopo do PI) 🗺️

O sistema "Semente da Gente" é uma aplicação de **controle de inventário e rastreabilidade logística** desenvolvida para gerenciar o ciclo completo de sementes, desde o fornecimento até a distribuição final aos produtores rurais (Beneficiários).

### 🎯 Componentes e Funções

* **Inventário e Rastreabilidade:** O controle é feito por **LoteSemente**, que rastreia a validade, a quantidade disponível e a localização física em um **Armazem**.
* **Atores:** O sistema modela a relação entre **Fornecedores** (empresas que fornecem os lotes) e **Beneficiários** (produtores rurais ou **Unidades Recebedoras**—modeladas com herança).
* **Transações:** A entidade **Pedido** é a tabela associativa que registra a transação entre Fornecedor, Beneficiário e LoteSemente, garantindo a rastreabilidade da distribuição.
* **Integridade de Dados:** A lógica de negócio é imposta via **Procedures** (ex: transacional para criação de pedidos e baixa de estoque) e **Triggers** (ex: padronização de CPF/CNPJ, validação de campos obrigatórios).

---

## II. Modelo Conceitual (Diagrama de Entidade-Relacionamento - MER) 🔗

O MER define as entidades e os relacionamentos no mundo do negócio.

### Entidades e Relacionamentos Chave

| Entidade | Chave Primária | Relacionamentos Chave |
| :--- | :--- | :--- |
| **Semente** | `idSemente` | **1:N** com LoteSemente |
| **Armazem** | `idArmazenamento` | **1:N** com LoteSemente |
| **LoteSemente** | `idLote_Semente` | **N:M** com Pedido |
| **Fornecedor** | `idFornecedor` | **N:M** com Pedido |
| **Beneficiario** | `idBeneficiario` | **N:M** com Pedido |
| **Pedido** | Chave Composta | Associa Fornecedor, Beneficiário, LoteSemente |
| **UndRecebedora** | `Beneficiario_idBeneficiario` | Herança do Beneficiário |



---

## III. Modelo Lógico (Diagrama Relacional - MR) 🗄️

O Modelo Lógico traduz o MER para a estrutura de tabelas, com a definição de Ch
