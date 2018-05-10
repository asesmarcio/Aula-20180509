SE30 -> Análise de tempo de resposta de transações

IP:
179.228.113.45




*&---------------------------------------------------------------------------
*& Report ZCOMPRAS08_00 NO STANDARD PAGE HEADING LINE-COUNT 65
*&						 LINE-SIZE 50.
*&
*&---------------------------------------------------------------------------
*& Descrição: Relatório de compras
*& Autor: Márcio Augusto - Data: 09/05/2018
*&---------------------------------------------------------------------------
REPORT zcompras08_00.

*----------------------------------------------------------------------------
* Tables
*----------------------------------------------------------------------------

TABLES EKKO.

*----------------------------------------------------------------------------
* Types / Structure
*----------------------------------------------------------------------------
TYPES: BEGIN OF ty_ekko,
        ebeln TYPE ekko-ebeln,
        bsart TYPE ekko-bsart,
       END OF ty_ekko.


       BEGIN OF ty_EKPO,
	ebeln TYPE ekpo-ebeln,
	ebelp TYPE ekpo-ebelp,
        matnr TYPE ekpo_matnr,
       END OF ty_ekpo.

*----------------------------------------------------------------------------
* WorkArea
*----------------------------------------------------------------------------
DATA: wa_ekko TYPE ty_ekko,
      wa_ekpo TYPE ty_ekpo.

*----------------------------------------------------------------------------
* Internal Table
*----------------------------------------------------------------------------
DATA: ti_ekko TYPE TABLE OF ty_ekko,
      ti_ekpo TYPE TABLE OF ty_ekpo.

*----------------------------------------------------------------------------
* CABEÇALHO
*----------------------------------------------------------------------------

   TOP-OF-PAGE

     WRITE:    'Relatório de Compras'(001),
	    40 'Paginas'(002),
	    47 SY-PAGNO.
     ULINE.

     WRITE: 'Doc. Compras'(003),
	    'Item'(004),
	    'Tipo'(005),
	    'Material'(006).

   ULINE.

*----------------------------------------------------------------------------
* Selection Screen
*----------------------------------------------------------------------------
SELECTION-SCREEN BEGIN OF BLOCK A1 WITH FRAME TITLE TEXT-T01.
SELECT-OPTIONS s_ebeln FOR ekko-ebeln. (COMANDO PARA-> DE: ___ ATÉ: ___).
SELECTION-SCREEN END OF BLOCK a1.

*----------------------------------------------------------------------------
* Start-of-Selection - Event.
*----------------------------------------------------------------------------
START-OF-SELECTION.

*----------------------------------------------------------------------------
* Seleciona Dados (Header)
*----------------------------------------------------------------------------
   SELECT EBELN
          BSART
          FROM EKKO
          INTO TABLE TI_EKKO
          WHERE EBELN IN S_EBELN.

   IF SY-SUBRC EQ 0.

     SELECT EBELN
            EBELP
            MATNR
            FROM EKPO
            INTO TABLE TI_EKPO
	    FOR ALL ENTRIES IN TI_EKKO
	    WHERE EBELN EQ TI_EKKO-EBELN.

   ENDIF.

*----------------------------------------------------------------------------


*******   BREAK-POINT. (comando que pode ser colocado somente durante os testes - nunca colocar para produção).


*----------------------------------------------------------------------------
* Seleciona Dados (Item)
*----------------------------------------------------------------------------

	ESTÁ FALTANDO DADOS AQUI


	    EBELP
	    MATNR
	    FROM EKPO
	    INTO TABLE TI_EKPO
	    FOR ALL ENTRIES IN TI_EKKO.

     SORT TI_EKPO BY EBELN EBELP.

  ELSE.

     MESSAGE 'Dados não encontrados'(M01) TYPE 'I'. (pode ser também 'E' ou 'S' ou 'W').

   ENDIF.

*----------------------------------------------------------------------------
* IMPRIME OS DADOS
*----------------------------------------------------------------------------
   LOOP AT TI_EKPO INTO WA_EKPO.

	READ TABLE TI_EKKO INTO WA_EKKO WITH KEY EBELN = WA_EKPO-EBELN.
						 BINARY SEARCH.
	WRITE: / WA_EKPO-EBELN COLOR COL_TOTAL,
	         WA_EKPO-EBELP,
	         WA_EKKO-BSART,
	         WA_EKPO-MATNR,

   ENDLOOP.

*----------------------------------------------------------------------------
* FIM
*----------------------------------------------------------------------------
