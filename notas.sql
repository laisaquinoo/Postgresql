-- tables ---

CREATE TABLE ALUNOS (
  nome 		varchar(20) NOT NULL,
  RA   			varchar(5) NOT NULL,
  sexo 			varchar(1) NOT NULL,	
  datanascimento 	varchar(10) NOT NULL,
  endereco 		varchar(100) NOT NULL,
  cidade 		varchar(100) NOT NULL,
  estado 		varchar(22) NOT NULL,
  cep 			varchar(15) NOT NULL,
  primary key (RA)
);

create table NOTAS(
  Disciplina		varchar(20) NOT NULL,
  alunoRA 		varchar(5) not null,
  n1 			numeric,
  n2 			numeric,
  n3 			numeric,
  media			numeric,
  constraint PK_alunora foreign key (alunoRA) references Alunos(ra)
);

--Implemente uma trigger para log na tabela Notas --
create table notas_log (
  operacao		varchar(10),
  Disciplina		varchar(20) NOT NULL,
  alunoRA 		varchar(5) not null,
  n1 			numeric,
  n2 			numeric,
  n3 			numeric,
  media			numeric
);


create function log_alteracao () returns trigger as 
$BODY$
begin 
	if (TG_OP = 'INSERT') then 
		insert into notas_log select 'INSERIDO', NEW.*;
		return new;
	elsif (TG_OP = 'UPDATE' )then 
		insert into notas_log select 'ATUALIZADO', NEW.*;
		return new;
	elsif (TG_OP = 'DELETE') then 
		insert into notas_log select 'EXCLUIDO',  OLD.*;
		return old;
	end if;
	RETURN NULL;
end
$BODY$
LANGUAGE plpgsql 

create trigger tr_notas_log after insert or update or delete
on NOTAS for each row
execute procedure log_alteracao();


-- inserts --

insert into ALUNOs values('Cauã','1','M','10/8/1991','Rua Laurinaldo Mendes 331','Osasco','SP','06038-280');
insert into ALUNOs values('Nicole','2','F','3/10/1982','Avenida Doutor Afonso Vergueiro 622','Sorocaba','SP','18035-370');
insert into ALUNOs values('Manuela','3','F','20/8/1989','Rua Maná 1594','Jaboatão dos Guararapes','PE','54490-190');
insert into ALUNOs values('Felipe','4','M','13/10/1997','Rua 20 1274','Taguatinga','DF','71925-360');

insert into NOTAS values('LPBD' ,'1',10,7,2);
insert into NOTAS values('LPBD' ,'2',7,9,1);
insert into NOTAS values('LPBD' ,'3',1,8,5);
insert into notas values('LPBD' ,'4',7,9,10);

select * from notas
select * from alunos

UPDATE notas
SET n3 = '9' 
WHERE alunoRA = '3';

DELETE FROM notas
WHERE alunoRA = '1';

select*from notas_log
select*from notas

--Implemente uma trigger para exibir msg caso tenham notas negativas
CREATE FUNCTION log_msg () returns trigger as 
$BODY$
    BEGIN
        IF NEW.n1 < 0 THEN
            RAISE EXCEPTION 'não pode ter nota negativa';
        END IF;

        IF NEW.n2 < 0 THEN
            RAISE EXCEPTION 'não pode ter nota negativa';
        END IF;
        
        IF NEW.n3 < 0 THEN
            RAISE EXCEPTION 'não pode ter nota negativa';
        END IF;

        RETURN NEW;
    END;
    $BODY$
 LANGUAGE plpgsql;

CREATE TRIGGER tr_msg
    BEFORE INSERT OR UPDATE ON NOTAS
    FOR EACH ROW EXECUTE PROCEDURE log_msg();

	insert into ALUNOs values('Gabrielly','5','F','6/11/1983','Alameda Inhambu 993','Barueri','SP','06428-230');
	insert into ALUNOs values('Diego','6','M','26/9/1990','Avenida Centenário 418','Maringá','PR','87050-040');

	insert into notas values('LPBD' ,'5',3,-7,7); 
	insert into notas values('LPBD' ,'6',-10,7,-2);

select*from notas_log
select*from notas

