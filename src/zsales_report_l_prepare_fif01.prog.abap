*----------------------------------------------------------------------*
***INCLUDE ZSALES_REPORT_L_PREPARE_FIF01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form PREPARE_FIELDCAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> P_
*&      --> TEXT_001
*&      <-- LT_FIELDCAT
*&---------------------------------------------------------------------*
FORM prepare_fieldcat  USING    pv_colpos
                                pv_fieldname
                                pv_text
                                pv_checkbox
                                pv_edit
                       CHANGING pt_fieldcat TYPE slis_t_fieldcat_alv.


  lwa_fieldcat-col_pos = pv_colpos.
  lwa_fieldcat-fieldname = pv_fieldname.
  lwa_fieldcat-seltext_l = pv_text.
  lwa_fieldcat-checkbox = pv_checkbox.
  lwa_fieldcat-edit = pv_edit.
  APPEND lwa_fieldcat TO pt_fieldcat.
  CLEAR : lwa_fieldcat.


ENDFORM.
