create table Persona(
Codice_pers varchar(16) not null,
via varchar(40) not null,
n_civico varchar(5) not null,
citta varchar(20) not null,
cap char(5) not null,
nome varchar(40) not null,
telefono char(10) not null,
email varchar(40) not null,
primary key (Codice_pers)
);

create table Cliente(
P_iva_cliente char(11) not null references Persona(Codice_pers),
primary key (P_iva_cliente)
);
create table Dipendente(
Codice_dip char(16) not null references Persona(Codice_pers),
cognome varchar(40) not null,
ruolo varchar(3) not null,
check(ruolo="ia" or ruolo="ip" or ruolo="ocq" or ruolo="os" or ruolo="oc" or ruolo="a"),
primary key(Codice_dip)
);

create table Fornitore(
Codice_forn char(11) not null references Persona(Codice_pers),
primary key(Codice_forn)
);

create table Tipologia(
Tipo_forn varchar(2) not null,
check(Tipo_forn="m" or Tipo_forn="s" or Tipo_forn="ms" or Tipo_forn="t"),
primary key(Tipo_forn)
);

create table Rifornimento(
Codice_fornitore char(11) not null references Fornitore(Codice_forn),
Tipo_fornitore varchar(2) not null references Tipologia(Tipo_forn),
primary key(Codice_fornitore, Tipo_fornitore)
);

create table Contratto(
Codice_cont int not null auto_increment,
data date not null,
primary key(Codice_cont)
);

create table ContrattoAcquisto(
Codice_acqu int not null references Contratto(Codice_cont),
importo numeric(7,2) not null,
check(importo > 0),
Fornitore char(11),
primary key(Codice_acqu),
foreign key(Fornitore) references Fornitore(Codice_forn)
);

create table ContrattoVendita(
Codice_ven int not null references Contratto(Codice_cont),
prezzo numeric(7,2),
check(prezzo > 0),
Cliente char(11),
primary key(Codice_ven),
foreign key(Cliente) references Cliente(P_iva_cliente)
);

create table ContrattoLavoro(
Codice_lav int not null references Contratto(Codice_cont),
stipendio numeric(7,2) not null,
check(stipendio > 0),
durata varchar(13) not null,
check(durata = "indeterminato" or durata = "3mesi" or durata = "6mesi" or durata = "12mesi" or durata = "24mesi"),
Dipendente char(16) not null,
primary key(Codice_lav),
foreign key(Dipendente) references Dipendente(Codice_dip)
);

create table Materiale(
Codice_mat int not null,
settore tinyint not null,
check(settore > 0 and settore < 4),
scaffale char not null,
ripiano tinyint not null,
check(ripiano > 0 and ripiano < 21),
altre_spec varchar(40) not null,
colore varchar(40) not null,
prezzo numeric(5,2) not null,
check(prezzo > 0),
tipologia varchar(20) not null,
check (tipologia = "materiaprima" or tipologia="prodottofinito" or tipologia="semilavorato"),
quantita int not null,
check(quantita >= 0),
primary key(Codice_mat)
);

create table MateriaPrima(
Codice_mat_prim int not null references Materiale(Codice_mat),
categoria varchar(8) not null,
check(categoria = "polimero" or categoria = "vernice"),
elasticita tinyint not null,
check(elasticita > 0 and elasticita < 100),
durezza tinyint not null,
check(durezza > 0 and durezza < 100),
primary key(Codice_mat_prim)
);

create table ProdottoFinito(
Codice_prod_fin int not null references Materiale(Codice_mat),
imballaggio varchar(9) not null,
check(imballaggio = "primario" or imballaggio = "terziario"),
primary key(Codice_prod_fin)
);
create table Semilavorato(
Codice_semi int not null references Materiale(Codice_mat),
primary key(Codice_semi)
);

create table catal_vendita(
ContrVendita int not null references ContrattoVendita(Codice_ven),
materiale int not null references Materiale(Codice_mat),
prezzo numeric(5,2) not null,
quantita int not null,
primary key(ContrVendita, materiale)
);

create table catal_semilavorato(
ContrAcquisto int not null references ContrattoAcquisto(Codice_acqu),
materiale int not null references Semilavorato(Codice_semi),
prezzo numeric(5,2) not null,
quantita int not null,
primary key(ContrAcquisto, materiale)
);

create table catal_materiaprima(
ContrAcquisto int not null references ContrattoAcquisto(Codice_acqu),
materiale int not null references MawteriaPrima(Codice_mat_prim),
prezzo numeric(5,2) not null,
quantita int not null,
primary key(ContrAcquisto, materiale)
);