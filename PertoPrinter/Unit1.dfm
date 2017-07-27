object Form1: TForm1
  Left = 1106
  Top = 281
  Width = 646
  Height = 576
  Caption = 'Exemplo PertoPrinter'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 16
    Top = 72
    Width = 137
    Height = 25
    Caption = 'Abre Comunica'#231#227'o'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 16
    Top = 112
    Width = 75
    Height = 25
    Caption = 'Status'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 16
    Top = 152
    Width = 105
    Height = 25
    Caption = 'Drawer Status'
    TabOrder = 2
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 16
    Top = 192
    Width = 75
    Height = 25
    Caption = 'Cortar Papel'
    TabOrder = 3
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 16
    Top = 232
    Width = 75
    Height = 25
    Caption = 'Imprimir'
    TabOrder = 4
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 104
    Top = 192
    Width = 89
    Height = 25
    Caption = 'Avan'#231'ar e cortar'
    TabOrder = 5
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 16
    Top = 272
    Width = 75
    Height = 25
    Caption = 'QRCode'
    TabOrder = 6
    OnClick = Button7Click
  end
  object Memo1: TMemo
    Left = 288
    Top = 16
    Width = 329
    Height = 481
    TabStop = False
    Lines.Strings = (
      'Memo1')
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 7
  end
  object Button8: TButton
    Left = 16
    Top = 312
    Width = 75
    Height = 25
    Caption = 'Abrir Gaveta'
    TabOrder = 8
    OnClick = Button8Click
  end
  object Button9: TButton
    Left = 16
    Top = 352
    Width = 75
    Height = 25
    Caption = 'Codigo Barras'
    TabOrder = 9
    OnClick = Button9Click
  end
  object Button10: TButton
    Left = 16
    Top = 392
    Width = 75
    Height = 25
    Caption = 'PrinterInfo'
    TabOrder = 10
    OnClick = Button10Click
  end
  object rdbUSB: TRadioButton
    Left = 16
    Top = 16
    Width = 97
    Height = 17
    Caption = 'USB'
    Checked = True
    TabOrder = 11
    TabStop = True
  end
  object rdbCOM: TRadioButton
    Left = 16
    Top = 40
    Width = 113
    Height = 17
    Caption = 'COM'
    TabOrder = 12
  end
  object edtPortaCOM: TEdit
    Left = 136
    Top = 40
    Width = 65
    Height = 21
    TabOrder = 13
    Text = 'COM1'
  end
  object Button11: TButton
    Left = 16
    Top = 488
    Width = 121
    Height = 25
    Caption = 'Fechar Comunica'#231#227'o'
    TabOrder = 14
    OnClick = Button11Click
  end
  object btnRealTimeStatus: TButton
    Left = 104
    Top = 112
    Width = 89
    Height = 25
    Caption = 'RealTime Status'
    TabOrder = 15
    OnClick = btnRealTimeStatusClick
  end
  object btnLimparMemo: TButton
    Left = 496
    Top = 504
    Width = 75
    Height = 25
    Caption = 'Limpar Memo'
    TabOrder = 16
    OnClick = btnLimparMemoClick
  end
end
