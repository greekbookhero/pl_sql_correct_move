SET SERVEROUTPUT ON;
CREATE OR REPLACE TYPE horizontal IS VARRAY(8) OF VARCHAR2(1);
CREATE OR REPLACE TYPE GAME_TABLE_TYPE IS VARRAY(8) OF horizontal;

CREATE OR REPLACE PROCEDURE PRINT_MATRIX (GAME_TABLE IN GAME_TABLE_TYPE) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('A B C D E F G H');
        for i in 1..8 loop
      for j in 1..8 loop
          DBMS_OUTPUT.PUT(GAME_TABLE(i)(j) || ' ' );
    end loop;
    DBMS_OUTPUT.PUT_LINE(i);
    end loop;
    DBMS_OUTPUT.PUT_LINE(' ');
    END;

declare
    game_table GAME_TABLE_TYPE:= GAME_TABLE_TYPE(horizontal('w','b','w','b','w','b','w','b'),horizontal('b','w','b','w','b','w','b','w'),horizontal('w','b','w','b','w','b','w','b'),horizontal('b','w','b','w','b','w','b','w'),horizontal('w','b','w','b','w','b','w','b'),horizontal('b','w','b','w','b','w','b','w'),horizontal('w','b','w','b','w','b','w','b'),horizontal('b','w','b','w','b','w','b','w'));
    type_of_figure VARCHAR2(10);
    horiz_start CHAR;
    horiz_start_int number;
    vert_start number;
    horiz_end CHAR;
    horiz_end_int number;
    vert_end number;
    start_pos game_move;
    end_pos game_move;
begin
 PRINT_MATRIX(game_table);
 DBMS_OUTPUT.PUT_LINE('Please enter figure between');
 DBMS_OUTPUT.PUT_LINE('King, Queen, Bishop, Knight, Rook, Pawn');
  type_of_figure := '&type_of_figure';
  horiz_start := '&horiz_start';
  horiz_start_int := ASCII(lower(horiz_start))-96;
  vert_start := &vert_start;
  horiz_end := '&horiz_end';
  horiz_end_int := ASCII(lower(horiz_end))-96;
  vert_end := &vert_end;
    if(vert_start>8 or horiz_start_int >8 or vert_start<0 or horiz_start_int <0) then
    dbms_output.put_line('Wrong input');
    else
        change_pos(horiz_start, vert_start, game_table, type_of_figure);
        PRINT_MATRIX(game_table);
            if(isRightMove( horiz_start_int, vert_start, horiz_end_int, vert_end, type_of_figure) = true) then
                change_pos(horiz_end, vert_end, game_table, type_of_figure);
                print_matrix(game_table);
            else
                dbms_output.put_line('You cannot make this move');
                end if;
    end if;
end;
/




CREATE OR REPLACE PROCEDURE change_pos (horiz in number, vert in number, game_table in OUT game_table_type, figure in VARCHAR2) 
    IS
        begin
        case lower(figure)
            when 'king' then
            game_table(vert)(int_horiz) := 'K';
            when 'queen' then
            game_table(vert)(int_horiz) := 'Q';
            when 'bishop' then
            game_table(vert)(int_horiz) := 'B';
            when 'knight' then
            game_table(vert)(int_horiz) := 'k';
            when 'rook' then
            game_table(vert)(int_horiz) := 'r';
            when 'pawn' then
            game_table(vert)(int_horiz) := 'p';
            else
            dbms_output.put_line('error, please enter right figure name');
            end case;
    end;

CREATE OR REPLACE FUNCTION pawn  (horiz_start_int in number, vert_start in number, horiz_end_int in number, vert_end in number)
RETURN BOOLEAN 
IS
    horiz_diff number;
    vert_diff number;
    
    BEGIN
        horiz_diff := (horiz_start_int-horiz_end_int);
        vert_diff := (vert_start-vert_end);
     if ( horiz_diff = 0 and vert_diff = 1  ) then
      return true;
      else
      return false;
      end if;
      end;

CREATE OR REPLACE FUNCTION rook  (horiz_start_int in number, vert_start in number, horiz_end_int in number, vert_end in number)
RETURN BOOLEAN 
IS
    horiz_diff number;
    vert_diff number;
    
    BEGIN
        horiz_diff := (horiz_start_int-horiz_end_int);
        vert_diff := (vert_start-vert_end);
     if ( horiz_diff = 0 and vert_diff < 9  ) then
      return true;
    elsif(vert_diff = 0 and horiz_diff < 9) then
      return true;
      else
      return false;
      end if;
      end;

CREATE OR REPLACE FUNCTION knight  (horiz_start_int in number, vert_start in number, horiz_end_int in number, vert_end in number)
RETURN BOOLEAN 
IS
    horiz_diff number;
    vert_diff number;
    
    BEGIN
        horiz_diff := ABS(horiz_start_int-horiz_end_int);
        vert_diff := ABS(vert_start-vert_end);
     if ( horiz_diff = 1 and vert_diff = 2  ) then
      return true;
    ELSIF ( horiz_diff = 2 and vert_diff = 1  ) then
      return true;
    elsif(vert_diff = 2 and horiz_diff = 1) then
      return true;
    elsif(vert_diff = 1 and horiz_diff = 2) then
      return true;
      else
      return false;
      end if;
      end;

CREATE OR REPLACE FUNCTION bishop (horiz_start_int in number, vert_start in number, horiz_end_int in number, vert_end in number)
RETURN BOOLEAN 
IS
    horiz_diff number;
    vert_diff number;
    
    BEGIN
        horiz_diff := ABS(horiz_start_int-horiz_diff);
        vert_diff := ABS(vert_start-vert_end);
     if ( vert_diff= horiz_diff ) then
      return true;
      else
      return false;
      end if;
      end;

CREATE OR REPLACE FUNCTION king  (horiz_start_int in number, vert_start in number, horiz_end_int in number, vert_end in number)
RETURN BOOLEAN 
IS
    horiz_diff number;
    vert_diff number;

    BEGIN
        horiz_diff := ABS(horiz_start_int-horiz_end_int);
        vert_diff := ABS(vert_start-vert_end);
     if ( horiz_diff = 1 and vert_diff= 0 ) then
      return true;
    elsif ( horiz_diff = 0 and vert_diff= 1 ) then
      return true;
    elsif ( horiz_diff = 1 and vert_diff= 1 ) then
      return true;
      else
      return false;
      end if;
      end;

CREATE OR REPLACE FUNCTION queen  (horiz_start_int in number, vert_start in number, horiz_end_int in number, vert_end in number)
RETURN BOOLEAN 
IS
    horiz_diff number;
    vert_diff number;
    
    BEGIN
        horiz_diff := ABS(horiz_start_int-horiz_end_int);
        vert_diff := ABS(vert_start-vert_end);
     if ( horiz_diff = 0 and vert_diff < 9  ) then
      return true;
    elsif(vert_diff = 0 and horiz_diff < 9) then
      return true;
    elsif( vert_diff = horiz_diff) then
        return true;
      else
      return false;
      end if;
      end;


create or replace FUNCTION isRightMove(horiz_start_int in number, vert_start in number, horiz_end_int in number, vert_end in number, figure VARCHAR2)
return BOOLEAN
IS
        begin
        case lower(figure)
            when 'king' then
            if(king(horiz_start_int,vert_start,horiz_end_int,vert_end)) then
            return true;
            else
            return false;
            end if;
            when 'queen' then
            if(queen(horiz_start_int,vert_start,horiz_end_int,vert_end)) then
            return true;
            else
            return false;
            end if;
            when 'bishop' then
            if(bishop(horiz_start_int,vert_start,horiz_end_int,vert_end)) then
            return true;
            else
            return false;
            end if;
            when 'knight' then
            if(knight(horiz_start_int,vert_start,horiz_end_int,vert_end)) then
            return true;
            else
            return false;
            end if;
            when 'rook' then
            if(rook(horiz_start_int,vert_start,horiz_end_int,vert_end)) then
            return true;
            else
            return false;
            end if;
            when 'pawn' then
            if(pawn(horiz_start_int,vert_start,horiz_end_int,vert_end)) then
            return true;
            else
            return false;
            end if;
            else
            dbms_output.put_line('error, please write to programmer ');
            end case;
    end;







