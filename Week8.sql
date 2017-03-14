-- Implicit Cursor 

BEGIN
UPDATE bb_product
SET stock = stock + 25 
WHERE idproduct = 15;
DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT);
IF SQL%NOTFOUND THEN
DBMS_OUTPUT.PUT_LINE('NOT FOUND');
END IF;
END;

-- Explicit Cursor 
SELECT * FROM bb_product;
DECLARE
   CURSOR cur_prod IS
        SELECT type, price
          FROM bb_product
          WHERE active = 1
        FOR UPDATE NOWAIT;
   lv_sale bb_product.saleprice%TYPE;
BEGIN
  FOR rec_prod IN cur_prod LOOP
     IF rec_prod.type = 'C' THEN lv_sale := rec_prod.price * .9;
      ELSIF rec_prod.type = 'E' THEN lv_sale := rec_prod.price * .95;
     END IF;
     UPDATE bb_product
       SET saleprice = lv_sale
       WHERE CURRENT OF cur_prod;
   END LOOP;
COMMIT;
END;

-- PARAMETRISED CURSOR 

DECLARE
     CURSOR cur_order (p_basket NUMBER) IS
        SELECT idBasket, idProduct, price, quantity
         FROM bb_basketitem
         WHERE idBasket = p_basket;
     lv_bask1_num bb_basket.idbasket%TYPE := 6;
     lv_bask2_num bb_basket.idbasket%TYPE := 10;
BEGIN
   FOR rec_order IN cur_order(lv_bask1_num) LOOP
       DBMS_OUTPUT.PUT_LINE(rec_order.idBasket || ' - ' ||
                              rec_order.idProduct || ' - ' || rec_order.price);
   END LOOP;
   FOR rec_order IN cur_order(lv_bask2_num) LOOP
        DBMS_OUTPUT.PUT_LINE(rec_order.idBasket || ' - ' ||
                              rec_order.idProduct || ' - ' || rec_order.price);
   END LOOP;
END;

-- cursor variable 
DECLARE
      cv_prod SYS_REFCURSOR;
      rec_item bb_basketitem%ROWTYPE;
      rec_status bb_basketstatus%ROWTYPE;
      lv_input1_num NUMBER(2) := 2;
      lv_input2_num NUMBER(2) := 3;
BEGIN
      IF lv_input1_num = 1 THEN
          OPEN cv_prod FOR SELECT * FROM bb_basketitem
             WHERE idBasket = lv_input2_num;
           LOOP
              FETCH cv_prod INTO rec_item;
              EXIT WHEN cv_prod%NOTFOUND;
              DBMS_OUTPUT.PUT_LINE(rec_item.idProduct);
           END LOOP;
  ELSIF lv_input1_num = 2 THEN
       OPEN cv_prod FOR SELECT * FROM bb_basketstatus
                                            WHERE idBasket = lv_input2_num;
             LOOP
                  FETCH cv_prod INTO rec_status;
                  EXIT WHEN cv_prod%NOTFOUND;
                  DBMS_OUTPUT.PUT_LINE(rec_status.idStage || ' - '
                                                                           || rec_status.dtstage);
             END LOOP;
  END IF;
END;
SELECT * FROM BB_BASKET;
SELECT * FROM bb_basketitem;
select * from bb_basketstatus;

-- Bulk Processing 
DECLARE
      CURSOR cur_item IS
            SELECT *
            FROM bb_basketitem;
      TYPE type_item IS TABLE OF cur_item%ROWTYPE
                               INDEX BY PLS_INTEGER;
       tbl_item type_item;
BEGIN
       OPEN cur_item;
       LOOP
            FETCH cur_item BULK COLLECT INTO tbl_item LIMIT 10;
            FOR i IN 1..tbl_item.COUNT LOOP
               DBMS_OUTPUT.PUT_LINE(tbl_item(i).idBasketitem || ' -'
                                                                               || tbl_item(i).idProduct);
            END LOOP;
            EXIT WHEN cur_item%NOTFOUND;
       END LOOP;
       CLOSE cur_item;
END;

-- Bulk Processing (DML) 
DECLARE
     TYPE emp_type IS TABLE OF NUMBER INDEX
             BY BINARY_INTEGER;
     emp_tbl emp_type;
BEGIN
      SELECT empID
         BULK COLLECT INTO emp_tbl
         FROM employees
           WHERE classtype = '100';
      FORALL i IN d_emp_tbl.FIRST .. emp_tbl.LAST
         UPDATE employees
              SET raise = salary * .06
              WHERE empID = emp_tbl(i);
         COMMIT;
END;


-- Exception Handling 
DECLARE
  ex_basket_fk EXCEPTION;
  PRAGMA EXCEPTION_INIT (ex_basket_fk, -2292);
BEGIN
  DELETE FROM bb_basket 
  WHERE idBasket = 4;
EXCEPTION
  WHEN ex_basket_fk THEN
  DBMS_OUTPUT.PUT_LINE('ITEMS STILL IN BASKET');
END;

-- USER DEFINED EXCEPTION EXAMPLE 
DECLARE
  ex_prod_update EXCEPTION; -- For update of no rows exception
BEGIN
/* to update prdct description */
  UPDATE bb_product
    SET description = 'Mill grinder with 5 grind settings'
    WHERE idProduct = 30;
    -- Check if any rows updated
  IF SQL%NOTFOUND THEN
    RAISE ex_prod_update;
  END IF;
EXCEPTION
  WHEN ex_prod_update THEN
    DBMS_OUTPUT.PUT_LINE('Invalid Product Id Entered');
END;