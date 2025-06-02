*----------------------------------------------------------------------*
***INCLUDE ZSALES_REPORT_L_TOP_OF_PAGF01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form TOP_OF_PAGE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM top_of_page .
  DATA : lt_list TYPE slis_t_listheader.
  DATA : lwa_list TYPE slis_listheader.

  lwa_list-typ = 'H'.
  lwa_list-info = 'Sales Order Item Details'.
  APPEND lwa_list TO lt_list.
  CLEAR : lwa_list.



  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = lt_list
*     I_LOGO             =
*     I_END_OF_LIST_GRID =
*     I_ALV_FORM         =
    .


ENDFORM.
