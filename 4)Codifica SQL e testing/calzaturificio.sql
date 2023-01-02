create table Persona
(
    Codice_pers varchar(11) not null
        primary key,
	check (Codice_pers = 11),
    cap         int  not null,
    citta       varchar(40) not null,
    n_civico    int  not null,
    via         varchar(40) not null,
    nome        varchar(20) not null,
    telefono    int  not null,
    email       varchar(40) null
);

create table Cliente
(
     P_iva_cliente varchar(11) not null
        primary key
);

create table Contratto
(
    data 		date not null,
    Codice_cont int not null
        primary key
);

create table ContrattoAcquisto
(
    Codice_acqu int not null
        primary key,
    importo          int not null,
	check (importo > 0),
	constraint Fornitore
		foreign key (Fornitore) references Fornitore (Codice_forn)
);

create table ContrattoVendita
(
    Codice_ven 		int   not null
        primary key,
    prezzo         float not null,
    check (prezzo > 0),
    Cliente        varchar(40)  null,
    constraint Cliente
        foreign key (Cliente) references Cliente (P_iva_cliente)
);

create table ContrattoLavoro
(
    Codice_lav	 int   not null
        primary key,
    stipendio     float not null,
    check (stipendio > 0),
    durata        time  not null,
    Dipendente    varchar(40)  null,
    constraint Dipendente
        foreign key (Dipendente) references Dipendente (Codice_dip)
);

create table Dipendente
(
    Codice_dip    varchar(40) not null
        primary key,
    cognome varchar(40) not null,
    ruolo   varchar(40) not null,
    check(ruolo="ia" or ruolo="ip" or ruolo="ocq" or ruolo="os" or ruolo="oc" or ruolo="a")
);



create table Fornitore
(
    Codice_forn varchar(40) not null
        primary key,
	constraint Tipologia
        foreign key (Tipologia) references Tipologia (Tipo_prod)
);

create table Tipologia
(
	Tipo_prod char not null,
    Fornitore char not null,
    primary key (Tipo_prod, Fornitore),
    constraint Fornitore
		foreign key (Fornitore) references Fornitore (Codice_forn)
);

create table Materiale
(
    scaffale         varchar(40)  not null,
    ripiano          varchar(40)  not null,
    settore          varchar(40)  not null,
    colore           varchar(40)  null,
    prezzo           float not null,
    tipologia        varchar(40)  null,
    quantita         int   not null,
    altre_spec		 varchar(40)  null,
    Codice_mat int   not null
        primary key
);

create table MateriaPrima
(
    Codice_mat_prim int not null
        primary key,
    categoria            int not null,
    elasticita           int not null,
    durezza              int not null,
    Contratto_acquisto   int null,
    constraint Contratto_acquisto
        foreign key (Contratto_acquisto) references ContrattoAcquisto (Codice_acqu)
);

create table ProdottoFinito
(
    
    Codice_prod_fin int  not null
        primary key,
    imballaggio            varchar(40) not null,
    Contratto_vendita      int  null,
    constraint Contratto_vendita
        foreign key (Contratto_vendita) references ContrattoVendita (Codice_ven)
);

create table Semilavorato
(
    Codice_semi        int not null
        primary key,
    Contratto_acquisto int null,
    constraint Contratto_acquisto
        foreign key (Contratto_acquisto) references Contratto_acquisto (Codice_acqu)
);

