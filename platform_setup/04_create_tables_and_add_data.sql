USE ROLE SYSADMIN;

USE SCHEMA RAW;
--- 1. CUSTOMERS TABLE CREATION & COLUMN COMMENTS ---
CREATE OR REPLACE TABLE CCLAVE_PRD.RAW.CUSTOMERS (
    CUSTOMER_ID VARCHAR(36) PRIMARY KEY COMMENT 'Identifiant unique du client (Clé Primaire), généralement un UUID ou une clé système.',
    CUSTOMER_NAME VARCHAR(100) COMMENT 'Nom complet du client.',
    EMAIL VARCHAR(100) COMMENT 'Adresse email du client.',
    CITY VARCHAR(50) COMMENT 'Ville de résidence du client.',
    COUNTRY VARCHAR(50) COMMENT 'Pays de résidence du client (ex: France).',
    LAST_UPDATE TIMESTAMP_NTZ COMMENT 'Horodatage indiquant la dernière mise à jour de cet enregistrement client.',
    LOAD_TIMESTAMP TIMESTAMP_NTZ COMMENT 'Horodatage indiquant la date et l''heure de chargement dans la zone RAW.'
);

-- Ajout d'un commentaire pour l'ensemble de la table
COMMENT ON TABLE CCLAVE_PRD.RAW.CUSTOMERS IS
'Cette table stocke les données maîtres essentielles des clients, y compris les identifiants, coordonnées, informations géographiques et l''heure de la dernière mise à jour. Sert de zone d''atterrissage pour les données brutes clients.';

INSERT INTO CCLAVE_PRD.RAW.CUSTOMERS (CUSTOMER_ID, CUSTOMER_NAME, EMAIL, CITY, COUNTRY, LAST_UPDATE, LOAD_TIMESTAMP)
VALUES
    ('CUST_001', 'Jean Dupont', 'jean.dupont@email.com', 'Paris', 'France', DATEADD(minute, -5, CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP()))::TIMESTAMP_NTZ, CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP())::TIMESTAMP_NTZ),
    ('CUST_002', 'Marie Dubois', 'marie.dubois@email.com', 'Marseille', 'France', DATEADD(minute, -4, CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP()))::TIMESTAMP_NTZ, CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP())::TIMESTAMP_NTZ),
    ('CUST_003', 'Pierre Martin', 'pierre.martin@email.com', 'Lyon', 'France', DATEADD(minute, -3, CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP()))::TIMESTAMP_NTZ, CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP())::TIMESTAMP_NTZ),
    ('CUST_004', 'Sophie Bernard', 'sophie.bernard@email.com', 'Toulouse', 'France', DATEADD(minute, -2, CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP()))::TIMESTAMP_NTZ,CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP())::TIMESTAMP_NTZ),
    ('CUST_005', 'Lucie Petit', 'lucie.petit@email.com', 'Nice', 'France', DATEADD(minute, -1, CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP()))::TIMESTAMP_NTZ, CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP())::TIMESTAMP_NTZ);

--- 2. PRODUCTS TABLE CREATION & COLUMN COMMENTS ---
CREATE OR REPLACE TABLE CCLAVE_PRD.RAW.PRODUCTS (
    PRODUCT_ID VARCHAR(36) COMMENT 'Identifiant unique du produit (Clé Primaire).',
    PRODUCT_NAME VARCHAR(100) COMMENT 'Nom complet du produit (ex: Sac à main bandoulière).',
    CATEGORY VARCHAR(50) COMMENT 'Catégorie du produit (ex: Sacs, Portefeuilles).',
    MATERIAL VARCHAR(50) COMMENT 'Matière principale du produit (ex: Cuir).',
    PRICE NUMBER(10, 2) COMMENT 'Prix de vente actuel du produit.',
    LAST_UPDATE TIMESTAMP_NTZ COMMENT 'Horodatage indiquant la dernière mise à jour de cet enregistrement produit.',
    LOAD_TIMESTAMP TIMESTAMP_NTZ COMMENT 'Horodatage indiquant la date et l''heure de chargement dans la zone RAW.'
);

COMMENT ON TABLE CCLAVE_PRD.RAW.PRODUCTS IS
'Cette table stocke les données maîtres des produits (maroquinerie). Elle inclut les identifiants, noms, catégories, matériel et le prix. Sert de zone d''atterrissage pour les données brutes produits.';

INSERT INTO CCLAVE_PRD.RAW.PRODUCTS (PRODUCT_ID, PRODUCT_NAME, CATEGORY, MATERIAL, PRICE, LAST_UPDATE, LOAD_TIMESTAMP)
VALUES
    ('PROD_001', 'Sac à main bandoulière', 'Sacs', 'Cuir', 350.00, DATEADD(minute, -1, CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP()))::TIMESTAMP_NTZ, CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP())::TIMESTAMP_NTZ),
    ('PROD_002', 'Portefeuille compagnon', 'Portefeuilles', 'Cuir', 120.00, DATEADD(minute, -3, CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP()))::TIMESTAMP_NTZ, CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP())::TIMESTAMP_NTZ),
    ('PROD_003', 'Ceinture réversible', 'Ceintures', 'Cuir', 85.50, DATEADD(minute, -2, CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP()))::TIMESTAMP_NTZ, CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP())::TIMESTAMP_NTZ),
    ('PROD_004', 'Sac à dos urbain', 'Sacs', 'Toile', 480.00, DATEADD(minute, -4, CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP()))::TIMESTAMP_NTZ, CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP())::TIMESTAMP_NTZ),
    ('PROD_005', 'Porte-cartes minimaliste', 'Portefeuilles', 'Toile', 60.00, DATEADD(minute, -5, CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP()))::TIMESTAMP_NTZ, CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP())::TIMESTAMP_NTZ),
    ('PROD_006', 'Trousse de toilette en cuir', 'Accessoires', 'Cuir', 180.00, DATEADD(minute, -6, CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP()))::TIMESTAMP_NTZ, CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP())::TIMESTAMP_NTZ),
    ('PROD_007', 'Étui à passeport en cuir', 'Accessoires', 'Cuir', 95.00, DATEADD(minute, -7, CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP()))::TIMESTAMP_NTZ, CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP())::TIMESTAMP_NTZ);

----------------------------------------------------

--- 3. TRANSACTIONS TABLE CREATION & COLUMN COMMENTS ---
CREATE OR REPLACE TABLE CCLAVE_PRD.RAW.TRANSACTIONS (
    TRANSACTION_ID VARCHAR(36) COMMENT 'Identifiant unique de chaque transaction (UUID).',
    CUSTOMER_ID VARCHAR(36) COMMENT 'Identifiant unique du client impliqué (Clé Étrangère vers CUSTOMERS).',
    PRODUCT_ID VARCHAR(36) COMMENT 'Identifiant unique du produit acheté (Clé Étrangère vers PRODUCTS).',
    QUANTITY NUMBER(10) COMMENT 'Nombre d''unités du produit dans la transaction.',
    TRANSACTION_DATETIME TIMESTAMP_TZ COMMENT 'Horodatage de l''occurrence de la transaction, incluant le fuseau horaire.',
    LOAD_TIMESTAMP TIMESTAMP_TZ COMMENT 'Horodatage du chargement de cet enregistrement dans la table.'
);

COMMENT ON TABLE CCLAVE_PRD.RAW.TRANSACTIONS IS
'Table brute des transactions de vente, reliant les clients et les produits. Sert de base pour l''analyse des ventes.';
