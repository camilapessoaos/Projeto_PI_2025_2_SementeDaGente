USE semente_da_gente;

-- -----------------------------------------------------
-- Tabela: Usuario (20 Registros)
-- -----------------------------------------------------
INSERT INTO Usuario (nome, login, senha) VALUES
('João Silva', 'joao.silva', 'senha123'),
('Maria Santos', 'maria.santos', 'mariasenha'),
('Pedro Oliveira', 'pedro.oliveira', 'pedro123'),
('Ana Costa', 'ana.costa', 'ana456'),
('Carlos Pereira', 'carlos.pereira', 'carlos789'),
('Fernanda Lima', 'fernanda.lima', 'fer123'),
('Ricardo Souza', 'ricardo.souza', 'ric456'),
('Juliana Alves', 'juliana.alves', 'jul789'),
('Roberto Martins', 'roberto.martins', 'rob123'),
('Amanda Rocha', 'amanda.rocha', 'ama456'),
('Lucas Ferreira', 'lucas.ferreira', 'luc789'),
('Patrícia Dias', 'patricia.dias', 'pat123'),
('Marcos Santos', 'marcos.santos', 'mar456'),
('Cristina Oliveira', 'cristina.oliveira', 'cri789'),
('Felipe Costa', 'felipe.costa', 'fel123'),
('Vanessa Silva', 'vanessa.silva', 'van456'),
('Bruno Pereira', 'bruno.pereira', 'bru789'),
('Daniela Lima', 'daniela.lima', 'dan123'),
('Alexandre Souza', 'alexandre.souza', 'ale456'),
('Tatiane Alves', 'tatiane.alves', 'tat789');

-- -----------------------------------------------------
-- Tabela: Semente (20 Registros)
-- -----------------------------------------------------
INSERT INTO Semente (nome, nome_cientifico, descricao) VALUES
('Milho', 'Zea mays', 'Semente de milho para plantio direto'),
('Soja', 'Glycine max', 'Soja transgênica resistente a herbicidas'),
('Arroz', 'Oryza sativa', 'Arroz irrigado de alta produtividade'),
('Feijão', 'Phaseolus vulgaris', 'Feijão carioca tipo 1'),
('Trigo', 'Triticum aestivum', 'Trigo melhorador para panificação'),
('Café', 'Coffea arabica', 'Café arábica catuaí vermelho'),
('Algodão', 'Gossypium hirsutum', 'Algodão herbáceo de fibra longa'),
('Cana-de-açúcar', 'Saccharum officinarum', 'Mudas de cana pré-brotada'),
('Girassol', 'Helianthus annuus', 'Girassol para produção de óleo'),
('Sorgo', 'Sorghum bicolor', 'Sorgo granífero para ração animal'),
('Aveia', 'Avena sativa', 'Aveia branca para cobertura do solo'),
('Cevada', 'Hordeum vulgare', 'Cevada cervejeira de qualidade superior'),
('Amendoim', 'Arachis hypogaea', 'Amendoim de casca vermelha'),
('Mamona', 'Ricinus communis', 'Mamona para produção de biodiesel'),
('Sésamo', 'Sesamum indicum', 'Gergelim preto orgânico'),
('Linhaça', 'Linum usitatissimum', 'Linhaça dourada para alimentação'),
('Quinoa', 'Chenopodium quinoa', 'Quinoa real importada da Bolívia'),
('Amaranto', 'Amaranthus cruentus', 'Amaranto grão para alimentação saudável'),
('Centeio', 'Secale cereale', 'Centeio para rotação de culturas'),
('Triticale', 'Triticosecale', 'Triticale para silagem e grãos');

-- -----------------------------------------------------
-- Tabela: Banco (20 Registros)
-- -----------------------------------------------------
INSERT INTO Banco (numAgencia, numConta, chavePix) VALUES
('0001', '12345-6', 'pix1@banco.com'),
('0002', '23456-7', 'pix2@banco.com'),
('0003', '34567-8', '12.345.678/0001-90'), -- CNPJ como Pix
('0004', '45678-9', 'pix4@banco.com'),
('0005', '56789-0', '23.456.789/0001-91'), -- CNPJ como Pix
('0006', '67890-1', 'pix6@banco.com'),
('0007', '78901-2', '34.567.890/0001-92'), -- CNPJ como Pix
('0008', '89012-3', 'pix8@banco.com'),
('0009', '90123-4', '45.678.901/0001-93'), -- CNPJ como Pix
('0010', '01234-5', 'pix10@banco.com'),
('0011', '11223-4', '56.789.012/0001-94'), -- CNPJ como Pix
('0012', '22334-5', 'pix12@banco.com'),
('0013', '33445-6', '67.890.123/0001-95'), -- CNPJ como Pix
('0014', '44556-7', 'pix14@banco.com'),
('0015', '55667-8', '78.901.234/0001-96'), -- CNPJ como Pix
('0016', '66778-9', 'pix16@banco.com'),
('0017', '77889-0', '89.012.345/0001-97'), -- CNPJ como Pix
('0018', '88990-1', 'pix18@banco.com'),
('0019', '99001-2', '90.123.456/0001-98'), -- CNPJ como Pix
('0020', '00112-3', 'pix20@banco.com');

-- -----------------------------------------------------
-- Tabela: Beneficiario (20 Registros)
-- -----------------------------------------------------
INSERT INTO Beneficiario (nome, cpf, Banco_idBanco) VALUES
('José Ferreira', '11122233344', 1),
('Antônio Santos', '22233344455', 2),
('Jorge Caruaru', '12345678000', 3), -- Será UndRecebedora
('Francisco Oliveira', '33344455566', 4),
('Cassio Fernando', '23456789000', 5), -- Será UndRecebedora
('Ricardo Silva', '44455566677', 6),
('Inácio Monteiro', '34567890000', 7), -- Será UndRecebedora
('Carlos Mendes', '55566677788', 8),
('Luiz Nunes', '78901000193', 9), -- Será UndRecebedora
('Roberto Alves', '66677788899', 10),
('Xuxa Meneguel', '89012000194', 11), -- Será UndRecebedora
('Miguel Costa', '77788899900', 12),
('São João', '67893000195', 13), -- Será UndRecebedora
('Paulo Rodrigues', '88899900011', 14),
('Lula Coração', '78234000196', 15), -- Será UndRecebedora
('Luiz Gonçalves', '99900011122', 16),
('Clara Monteiro', '89012300197', 17), -- Será UndRecebedora
('Eduardo Nunes', '10011122233', 18),
('Honda Accord', '90456000198', 19), -- Será UndRecebedora
('Marcos Pinto', '11133344455', 20);

-- -----------------------------------------------------
-- Tabela: Fornecedor (20 Registros)
-- -----------------------------------------------------
INSERT INTO Fornecedor (nome, cpf_cnpj) VALUES
('Sementes Premium Ltda', '11222333000144'),
('AgroSementes do Brasil', '22333444000155'),
('João Produtor', '33344455566'),
('Cooperativa Sementes Livres', '33444555000166'),
('Fazenda Boa Esperança', '44555666000177'),
('Maria Agricultora', '55566677788'),
('Sementes Certificadas SA', '55666777000188'),
('Antônio Fornecedor', '66677788899'),
('AgroTech Sementes', '66777888000199'),
('Carlos Produtor Rural', '77788899900'),
('Sementes Nobres Ltda', '77888999000100'),
('Francisco Fornecedor', '88899900011'),
('BioSementes Orgânicas', '88999000000111'),
('Roberto Agricultor', '99900011122'),
('Sementes do Futuro', '99000111000122'),
('Luiz Fornecedor', '10011122233'),
('AgroNatural Sementes', '00111222000133'),
('Eduardo Produtor', '21122233344'),
('Sementes Selecionadas', '31222333000144'),
('Marcos Fornecedor', '42233344455');

-- -----------------------------------------------------
-- Tabela: Armazem (20 Registros)
-- Ajustando as capacidades para valores maiores, conforme a análise anterior, para simular uma operação em larga escala e garantir que as consultas com filtros altos funcionem.
-- -----------------------------------------------------
INSERT INTO Armazem (nome, capacidade) VALUES
('Armazém Central SP', 6000000.000),    -- 6.000 toneladas (Maior que 700.000)
('Armazém Regional MG', 8000000.000),   -- 8.000 toneladas (Maior que 700.000)
('Armazém Norte PR', 750000.000),      -- 750 toneladas (Maior que 700.000)
('Armazém Sul RS', 9000000.000),       -- 9.000 toneladas (Maior que 700.000)
('Armazém Leste SC', 600000.000),      -- 600 toneladas
('Armazém Oeste MT', 8500000.000),     -- 8.500 toneladas (Maior que 700.000)
('Armazém Centro GO', 200000.000),     -- 200 toneladas
('Armazém Nordeste BA', 1050000.000),  -- 1.050 toneladas (Maior que 700.000)
('Armazém Sudeste RJ', 5000000.000),   -- 5.000 toneladas (Maior que 700.000)
('Armazém Norte PA', 500000.000),      -- 500 toneladas
('Armazém Cerrado MS', 350000.000),    -- 350 toneladas
('Armazém Pampa RS', 140000.000),      -- 140 toneladas
('Armazém Mata Atlântica', 290000.000),-- 290 toneladas
('Armazém Caatinga', 240000.000),      -- 240 toneladas
('Armazém Pantanal', 50000.000),       -- 50 toneladas
('Armazém Amazônia', 45000.000),       -- 45 toneladas
('Armazém Cerrado II', 63000.000),     -- 63 toneladas
('Armazém Central II', 95000.000),     -- 95 toneladas
('Armazém Regional II', 67000.000),    -- 67 toneladas
('Armazém Estratégico', 88000.000);    -- 88 toneladas

-- -----------------------------------------------------
-- Tabela: LoteSemente (20 Registros)
-- -----------------------------------------------------
INSERT INTO LoteSemente (data_producao, data_validade, qtd_original_kg, certificado_origem, local_armazenamento, qtd_disponivel_kg, valor, Semente_idSemente, Armazem_idArmazenamento) VALUES
('2024-01-15', '2025-01-15', 50000.000, 'CERT-001', 'Prateleira A1', 45000.000, 25000.50, 1, 1),
('2024-02-10', '2025-02-10', 30000.000, 'CERT-002', 'Prateleira B2', 28000.000, 45000.75, 2, 2),
('2024-03-05', '2025-03-05', 20000.000, 'CERT-003', 'Prateleira C3', 18000.000, 12000.30, 3, 3),
('2024-01-20', '2025-01-20', 15000.000, 'CERT-004', 'Prateleira D4', 12000.000, 18000.90, 4, 4),
('2024-02-25', '2025-02-25', 40000.000, 'CERT-005', 'Prateleira E5', 35000.000, 32000.15, 5, 5),
('2024-03-15', '2025-03-15', 25000.000, 'CERT-006', 'Prateleira F6', 22000.000, 28000.40, 6, 6),
('2024-01-30', '2025-01-30', 18000.000, 'CERT-007', 'Prateleira G7', 15000.000, 22000.75, 7, 7),
('2024-02-20', '2025-02-20', 32000.000, 'CERT-008', 'Prateleira H8', 30000.000, 15000.60, 8, 8),
('2024-03-10', '2025-03-10', 28000.000, 'CERT-009', 'Prateleira I9', 25000.000, 19000.25, 9, 9),
('2024-01-25', '2025-01-25', 22000.000, 'CERT-010', 'Prateleira J10', 20000.000, 24000.80, 10, 10),
('2024-02-15', '2025-02-15', 35000.000, 'CERT-011', 'Prateleira K11', 32000.000, 21000.45, 11, 11),
('2024-03-20', '2025-03-20', 19000.000, 'CERT-012', 'Prateleira L12', 17000.000, 16000.90, 12, 12),
('2024-01-18', '2025-01-18', 27000.000, 'CERT-013', 'Prateleira M13', 24000.000, 29000.75, 13, 13),
('2024-02-28', '2025-02-28', 31000.000, 'CERT-014', 'Prateleira N14', 29000.000, 14000.20, 14, 14),
('2024-03-08', '2025-03-08', 23000.000, 'CERT-015', 'Prateleira O15', 21000.000, 26000.35, 15, 15),
('2024-01-22', '2025-01-22', 26000.000, 'CERT-016', 'Prateleira P16', 23000.000, 31000.80, 16, 16),
('2024-02-12', '2025-02-12', 33000.000, 'CERT-017', 'Prateleira Q17', 31000.000, 17000.95, 17, 17),
('2024-03-25', '2025-03-25', 24000.000, 'CERT-018', 'Prateleira R18', 22000.000, 23000.10, 18, 18),
('2024-01-28', '2025-01-28', 29000.000, 'CERT-019', 'Prateleira S19', 27000.000, 20000.65, 19, 19),
('2024-02-18', '2025-02-18', 21000.000, 'CERT-020', 'Prateleira T20', 19000.000, 27000.40, 20, 20);

-- -----------------------------------------------------
-- Tabela: Endereco (20 Registros)
-- Cada Endereço é associado a um Fornecedor, Beneficiário OU Armazém.
-- -----------------------------------------------------
INSERT INTO Endereco (logradouro, numero, complemento, bairro, cidade, uf, cep, Fornecedor_idFornecedor, Beneficiario_idBeneficiario, Armazem_idArmazenamento) VALUES
('Rua das Flores', 100, 'Sala 1', 'Centro', 'São Paulo', 'SP', '01001000', 1, NULL, NULL),
('Avenida Brasil', 500, NULL, 'Jardins', 'Belo Horizonte', 'MG', '30110000', 2, NULL, NULL),
('Rua Principal', 200, 'Fazenda', 'Zona Rural', 'Londrina', 'PR', '86010000', NULL, 1, NULL),
('Avenida Paulista', 1000, NULL, 'Bela Vista', 'São Paulo', 'SP', '01311000', NULL, NULL, 1),
('Rua das Palmeiras', 300, 'Galpão 2', 'Industrial', 'Curitiba', 'PR', '81010000', NULL, NULL, 2),
('Estrada Municipal', 50, 'Sítio', 'Rural', 'Porto Alegre', 'RS', '90010000', NULL, 2, NULL),
('Avenida Getúlio Vargas', 800, NULL, 'Centro', 'Florianópolis', 'SC', '88010000', 3, NULL, NULL),
('Rua dos Agricultores', 150, NULL, 'Agricultura', 'Cuiabá', 'MT', '78010000', NULL, 3, NULL),
('Rodovia BR-101', 1200, 'Km 10', 'Industrial', 'Goiânia', 'GO', '74010000', NULL, NULL, 3),
('Avenida Central', 600, NULL, 'Comércio', 'Salvador', 'BA', '40010000', 4, NULL, NULL),
('Rua das Sementes', 250, 'Loja A', 'Comercial', 'Rio de Janeiro', 'RJ', '20010000', NULL, 4, NULL),
('Estrada do Campo', 75, 'Chácara', 'Rural', 'Belém', 'PA', '66010000', NULL, NULL, 4),
('Avenida Produção', 900, NULL, 'Industrial', 'Campo Grande', 'MS', '79010000', 5, NULL, NULL),
('Rua da Colheita', 180, NULL, 'Agrícola', 'Pelotas', 'RS', '96010000', NULL, 5, NULL),
('Rodovia Estadual', 1500, 'Km 25', 'Zona Rural', 'Vitória', 'ES', '29010000', NULL, NULL, 5),
('Avenida das Indústrias', 700, NULL, 'Industrial', 'Fortaleza', 'CE', '60010000', 6, NULL, NULL),
('Rua do Produtor', 220, NULL, 'Comércio', 'Recife', 'PE', '50010000', NULL, 6, NULL),
('Estrada Velha', 90, 'Fazenda Velha', 'Rural', 'Manaus', 'AM', '69010000', NULL, NULL, 6),
('Avenida Tecnologia', 1100, NULL, 'Tecnoparque', 'Brasília', 'DF', '70010000', 7, NULL, NULL),
('Rua do Agricultor', 190, NULL, 'Agricultura', 'Natal', 'RN', '59010000', NULL, 7, NULL);

-- -----------------------------------------------------
-- Tabela: Contato (20 Registros)
-- Cada Contato é associado a um Fornecedor, Usuário, Beneficiário OU Armazém.
-- -----------------------------------------------------
INSERT INTO Contato (numero, email, Fornecedor_idFornecedor, Usuario_idusuario, Beneficiario_idBeneficiario, Armazem_idArmazenamento) VALUES
('11999999999', 'joao.silva@email.com', NULL, 1, NULL, NULL),
('11888888888', 'contato@sementespremium.com', 1, NULL, NULL, NULL),
('11777777777', 'maria.santos@email.com', NULL, 2, NULL, NULL),
('11666666666', 'vendas@agrosementes.com', 2, NULL, NULL, NULL),
('11555555555', 'jose.ferreira@email.com', NULL, NULL, 1, NULL),
('11444444444', 'contato@armazemcentral.com', NULL, NULL, NULL, 1),
('11333333333', 'pedro.oliveira@email.com', NULL, 3, NULL, NULL),
('11222222222', 'joaoprodutor@email.com', 3, NULL, NULL, NULL),
('11111111111', 'ana.costa@email.com', NULL, 4, NULL, NULL),
('11000000000', 'cooperativa@sementeslivres.com', 4, NULL, NULL, NULL),
('11999998888', 'antonio.santos@email.com', NULL, NULL, 2, NULL),
('11999997777', 'gerente@armazemregional.com', NULL, NULL, NULL, 2),
('11999996666', 'carlos.pereira@email.com', NULL, 5, NULL, NULL),
('11999995555', 'fazenda@boaesperanca.com', 5, NULL, NULL, NULL),
('11999994444', 'francisco.oliveira@email.com', NULL, NULL, 3, NULL),
('11999993333', 'admin@armazemnorte.com', NULL, NULL, NULL, 3),
('11999992222', 'fernanda.lima@email.com', NULL, 6, NULL, NULL),
('11999991111', 'maria.agricultora@email.com', 6, NULL, NULL, NULL),
('11999990000', 'cooperativa@valeverde.com', NULL, NULL, 4, NULL),
('11998888999', 'diretor@armazemsul.com', NULL, NULL, NULL, 4);

-- -----------------------------------------------------
-- Tabela: UndRecebedora (9 Registros)
-- Herança do Beneficiário: Beneficiários que representam empresas/unidades (têm CNPJ)
-- -----------------------------------------------------
INSERT INTO UndRecebedora (Beneficiario_idBeneficiario, cnpj) VALUES
(3, '12345678000190'),
(5, '23456789000191'),
(7, '34567890000192'),
(9, '45678901000193'),
(11, '56789012000194'),
(13, '67890123000195'),
(15, '78901234000196'),
(17, '89012345000197'),
(19, '90123456000198');

-- -----------------------------------------------------
-- Tabela: Pedido (20 Registros)
-- -----------------------------------------------------
INSERT INTO Pedido (Fornecedor_idFornecedor, Beneficiario_idBeneficiario, LoteSemente_idLote_Semente, data, valor, status) VALUES
(1, 1, 1, '2024-04-01', 5000.00, 'ENTREGUE'),
(2, 2, 2, '2024-04-02', 8000.00, 'PROCESSANDO'),
(3, 3, 3, '2024-04-03', 3000.00, 'PENDENTE'),
(4, 4, 4, '2024-04-04', 4500.00, 'ENTREGUE'),
(5, 5, 5, '2024-04-05', 6000.00, 'CANCELADO'),
(6, 6, 6, '2024-04-06', 7000.00, 'ENTREGUE'),
(7, 7, 7, '2024-04-07', 3500.00, 'PROCESSANDO'),
(8, 8, 8, '2024-04-08', 4800.00, 'PENDENTE'),
(9, 9, 9, '2024-04-09', 5200.00, 'ENTREGUE'),
(10, 10, 10, '2024-04-10', 3900.00, 'CANCELADO'),
(11, 11, 11, '2024-04-11', 6100.00, 'PROCESSANDO'),
(12, 12, 12, '2024-04-12', 2800.00, 'ENTREGUE'),
(13, 13, 13, '2024-04-13', 4300.00, 'PENDENTE'),
(14, 14, 14, '2024-04-14', 5700.00, 'ENTREGUE'),
(15, 15, 15, '2024-04-15', 3200.00, 'PROCESSANDO'),
(16, 16, 16, '2024-04-16', 4900.00, 'CANCELADO'),
(17, 17, 17, '2024-04-17', 5400.00, 'ENTREGUE'),
(18, 18, 18, '2024-04-18', 3700.00, 'PENDENTE'),
(19, 19, 19, '2024-04-19', 6200.00, 'PROCESSANDO'),
(20, 20, 20, '2024-04-20', 2900.00, 'ENTREGUE');