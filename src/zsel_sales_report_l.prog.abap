*&---------------------------------------------------------------------*
*& Include          ZSEL_SALES_REPORT_L
*&---------------------------------------------------------------------*

SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-000.
  SELECT-OPTIONS : s_erdat FOR lv_erdat OBLIGATORY NO-EXTENSION.
  SELECT-OPTIONS : s_ernam FOR lv_ernam NO INTERVALS NO-EXTENSION.
SELECTION-SCREEN : END OF BLOCK b1.
