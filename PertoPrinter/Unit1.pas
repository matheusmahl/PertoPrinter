{
Projeto exemplo (convertido de C++) para a utilização da API ptptrpro.dll em Delphi 6 ou superior.
Desenvolvedor: Matheus Mahl
Data: 28/11/2016

Requisitos:
Ter instalado o driver da impressora PertoPrinter para a utilização com a biblioteca PTPTRPRO.dll

Obs: O executável deve ser executado na mesma pasta que contém as DLLs instaladas com o pacote da Perto Printer.
Por padrão é: C:\PertoPrinterTEC\ptptrpro-win\bin
}

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  //*! printer information (GetPrinterInfo) */
  PrinterInfoStruct = record
    printer_model: integer;   //*!< printer model */
    tipo: Integer ;           //*!< printer type */
    rom_version: String[12];      //*!< printer version */
  end;


  POpenPort = function(port: String; baud_rate: integer; parity: char; data_size: integer; stop_bit: integer): Integer; Cdecl;
  PSetProtocol = function(protocol: integer): Integer; Cdecl;
  PGetPrinterStatus = function(var status: integer): Integer; Cdecl;
  Pptptrpro_GetMediaStatus = function(var status: integer): Integer; Cdecl;
  PGetDrawerStatus = function(drawer_id: integer; var status: integer): Integer; Cdecl;
  PSendData = function(const data: String; size: Integer): Integer; Cdecl;
  PMakePrint = function(): Integer; Cdecl;

  PMakeCut = function(tipo: Integer): Integer; Cdecl;
  PMakeCutnLines = function(tipo, linhas: Integer): Integer; Cdecl;

  PStoreQrCodeData = function(data: String; size: Integer): Integer; Cdecl;
  PMakeQrCode = function(): Integer; Cdecl;
  PSetQrCodeModel = function(model: Integer): Integer; Cdecl;
  PSetQrCodeResolution = function(factor: Integer): Integer; Cdecl;
  PSetQrCodeErrorCorretion = function(level: Integer): Integer; Cdecl;
  PSetJustification = function(pos: Integer): Integer; Cdecl;

  PSetTextProperties = function(font: Integer; italic, underlined, bold: boolean): Integer; Cdecl;
  PSetPrintMode = function(mode: Integer): Integer; Cdecl;

  PGeneratePulse = function(pin: Integer; time_on: Integer; time_off: Integer): Integer; Cdecl;

  PPrintBarCode = function(tipo: Integer; height: Integer; width: Integer; left_margin: Integer; text_pos: Integer; text_font: Integer; const data: String): Integer; Cdecl;
  PSetHriFont = function(font: Integer): Integer; Cdecl;
  PSetHriPosition = function(pos: Integer): Integer; Cdecl;

  PSetLineSpacing = function(size: Integer): Integer; Cdecl;
  PGetPartialLineFeed = function(lines: Integer): Integer; Cdecl;
  PGetPrinterInfo = function(var info: PrinterInfoStruct): Integer; Cdecl;

  PClosePort = function: Integer; Cdecl;


  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Memo1: TMemo;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    rdbUSB: TRadioButton;
    rdbCOM: TRadioButton;
    edtPortaCOM: TEdit;
    Button11: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
  private
    procedure CarregaECF;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

  OpenPort: POpenPort;
  SetProtocol: PSetProtocol;
  GetPrinterStatus: PGetPrinterStatus;
  ptptrpro_GetMediaStatus: Pptptrpro_GetMediaStatus;
  GetDrawerStatus: PGetDrawerStatus;
  MakeCut: PMakeCut;
  SendData: PSendData;
  MakePrint: PMakePrint;
  MakeCutnLines: PMakeCutnLines;
  StoreQrCodeData: PStoreQrCodeData;
  MakeQrCode: PMakeQrCode;
  SetQrCodeModel: PSetQrCodeModel;
  SetQrCodeResolution: PSetQrCodeResolution;
  SetQrCodeErrorCorretion: PSetQrCodeErrorCorretion;
  SetJustification: PSetJustification;
  SetTextProperties: PSetTextProperties;
  SetPrintMode: PSetPrintMode;
  GeneratePulse: PGeneratePulse;
  PrintBarCode: PPrintBarCode;
  SetHriFont: PSetHriFont;
  SetHriPosition: PSetHriPosition;
  SetLineSpacing: PSetLineSpacing;
  GetPartialLineFeed: PGetPartialLineFeed;
  GetPrinterInfo: PGetPrinterInfo;
  ClosePort: PClosePort;


implementation

const
  //*! Protocol types */
  PTR_PROT_NOTDEF = 0;       //   /*!< Protocol not defined */
  PTR_PROT_PERTO = 100;    //    /*!< Perto protocol */
  PTR_PROT_ESCPOS = 101; //       /*!< ESC/POS protocol */

  //*! Return codes */
  PTR_OK             =      1 ;//  /*!< success */
  PTR_ERROR           =    -1 ;//  /*!< error */
  PTR_ERR_UNSUPPORTED   =  -2   ;//*!< not supported */
  PTR_ERR_INVALIDPARAM   = -3   ;//*!< invalid parameter */
  PTR_ERR_NOTOPENED   =    -4   ;//*!< communication not opened */
  PTR_ERR_DETACHED    =    -5   ;//*!< communication closed */
  PTR_ERR_NOMEM       =    -6   ;//*!< memory not available */
  PTR_ERR_NOTIMPL     =    -7   ;//*!< not implemented */
  PTR_ERR_PROTNOTDEF  =    -8   ;//*!< protocol not defined */
  PTR_ERR_USB_OPEN    =    -9   ;//*!< error opening USB device */
  PTR_ERR_USB_CONFIG  =    -10  ;//*!< error setting USB configuration */
  PTR_ERR_USB_CLAIM   =    -11  ;//*!< error claiming USB interface */
  PTR_ERR_USB_RELEASE =    -12  ;//*!< error releasing USB interface */
  PTR_ERR_USB_CLOSE   =    -13  ;//*!< error closing USB handle */
  PTR_ERR_NOPRESENCE  =    -14  ;//*!< error printer not presence */
  PTR_ERR_PORTNOTFOUND =    -15  ;//*!< error port not found */
  PTR_ERR_IOERROR      =   -16  ;//*!< error I/O */
  PTR_ERR_NORESOURCES	 =	-17  ;//*!< error no resources */

  //*! Printer status bits (GetPrinterStatus) */
  PTR_ST_OK                   =    0; //     0       /*!< operational */
  PTR_ST_OFFLINE              =    1; //     0x0001  /*!< off line */
  PTR_ST_NOPAPER              =    2; //     0x0002  /*!< paper out */
  PTR_ST_LOWPAPER             =    4; //     0x0004  /*!< paper low */
  PTR_ST_HEADUP               =    8; //     0x0008  /*!< head up */
  PTR_ST_JAMMED               =   10; //     0x0010  /*!< jammed */
  PTR_ST_BUSY                 =   32; //     0x0020  /*!< busy */
  PTR_ST_HEAD_TEMP_HIGH       =   64; //     0x0040  /*!< head temperature high */
  PTR_ST_MOTOR_TEMP_HIGH      =  128; //     0x0080  /*!< motor temperature high */
  PTR_ST_COVEROPEN            =  256; //     0x0100  /*!< cover openned */
  PTR_ST_ONLINE               =  512; //     0x0200  /*!< on line */
  PTR_ST_UNKNOWN              = 1024; //     0x0400  /*!< unknown */
  PTR_ST_VALIDATION_COVEROPEN = 2048; //     0x0800  /*!< unknown */


  //*! Printer media status bits (GetMediaStatus) */
  PTR_MEDIA_ST_ATEXIT = 1; //                0x0001   /*!< positioned at exit */
  PTR_MEDIA_ST_LOWPAPER = 4; //              0x0004   /*!< low paper */
  PTR_MEDIA_ST_NOPAPER = 8; //               0x0008   /*!< no paper */

  //*! Drawer identifier (GetDrawerStatus) */
  PTR_DRAWERONE =          1       ;//*!< drawer 1 */
  PTR_DRAWERTWO =          2       ;//*!< drawer 2 */

  //*! Drawer status (GetDrawerStatus) */
  PTR_DRAWER_ST_CLOSED =   0;   //    /*!< drawer closed */
  PTR_DRAWER_ST_OPENED =   1;   //    /*!< drawer opened */
  PTR_DRAWER_ST_UNKNOWN =  64 ; //0x0040  /*!< unknown */

  //*! Paper cur type (MakeCut) */
  PTR_CUT_FULL =           0;   //*!< full cut */
  PTR_CUT_PARTIAL =        1;  //*!< partial cut */

  //*! Printer QrCode Model (SetQrCodeModel) */
  PTR_QRCODE_MODELONE  =       1;       //*!< Model 1 (not supported) */
  PTR_QRCODE_MODELTWO  =       2;       //*!< Model 2 */


  //*! Printer QrCode Error Correction (SetQrCodeErrorCorretion) */
  PTR_QRCODE_LEVEL_L =   0 ;      //*!< Error Corretion Level L 7 */
  PTR_QRCODE_LEVEL_M =   1 ;      //*!< Error Corretion Level M 15 */
  PTR_QRCODE_LEVEL_Q =   2 ;      //*!< Error Corretion Level Q 25 */
  PTR_QRCODE_LEVEL_H =   3 ;      //*!< Error Corretion Level H 30 */


  //*! Printer QrCode Resolution (SetQrCodeResolution) */
  PTR_QRCODE_FACTOR1 =         1;       //*!< Factor 1 */
  PTR_QRCODE_FACTOR2 =         2;       //*!< Factor 2 */
  PTR_QRCODE_FACTOR3 =         3;       //*!< Factor 3 */
  PTR_QRCODE_FACTOR4 =         4;       //*!< Factor 4 */
  PTR_QRCODE_FACTOR5 =         5;       //*!< Factor 5 */
  PTR_QRCODE_FACTOR6 =         6;       //*!< Factor 6 */
  PTR_QRCODE_FACTOR7 =         7;       //*!< Factor 7 */

  //*! Justification (SetJustification) */
  PTR_POS_LEFT     =       0;   //*!< left justified */
  PTR_POS_CENTER  =        1;   //*!< center justified */
  PTR_POS_RIGHT  =         2;   //*!< right justified */

  //*! Font type (SetTextProperties) */
  PTR_FONT_NORMAL =        0;       //*!< normal */
  PTR_FONT_NARROW =        1;       //*!< narrow */
  PTR_FONT_EXPANDED =      2;       //*!< expanded */

  //*! Bar code types (PrintBarCode) */
  PTR_BAR_CODE_UPCA     =  65 ;     //*!< UPCA */
  PTR_BAR_CODE_UPCE     =  66 ;     //*!< UPCE */
  PTR_BAR_CODE_EAN13    =  67 ;     //*!< EAN13 */
  PTR_BAR_CODE_EAN8     =  68 ;     //*!< EAN8 */
  PTR_BAR_CODE_CODE39   =  69 ;     //*!< CODE39 */
  PTR_BAR_CODE_ITF      =  70 ;     //*!< ITF */
  PTR_BAR_CODE_CODABAR  =  71 ;     //*!< CODABAR */
  PTR_BAR_CODE_CODE93   =  72 ;     //*!< CODE93 */
  PTR_BAR_CODE_CODE128  =  73 ;     //*!< CODE128 */
  PTR_BAR_CODE_CODE32   =  90 ;     //*!< CODE32 */
  PTR_BAR_CODE_PDF417   =  128;     //*!< PDF-417 */

  //*! Bar code width (PrintBarCode) */
  PTR_BAR_CODE_WIDTH_SLIM    =    0;    //*!< slim width */
  PTR_BAR_CODE_WIDTH_MEDIUM  =    1;    //*!< medium width */
  PTR_BAR_CODE_WIDTH_WIDE    =    2;    //*!< wide width */

  //*! Bar code text pos (PrintBarCode) */
  PTR_BAR_CODE_POS_NO            = 0 ;   //*!< not apply */
  PTR_BAR_CODE_POS_ABOVE         = 1 ;   //*!< positioned above */
  PTR_BAR_CODE_POS_BELOW         = 2 ;   //*!< positioned below */
  PTR_BAR_CODE_POS_ABOVEANDBELOW = 3 ;   //*!< positioned above and below */

  //*! Bar code text type (PrintBarCode) */
  PTR_BAR_CODE_FONT_NORMAL = 0;     //*!< normal */
  PTR_BAR_CODE_FONT_NARROW = 1;     //*!< narrow */


{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  iRetorno: Integer;
begin
  CarregaECF;

  iRetorno := SetProtocol(PTR_PROT_ESCPOS);
  memo1.Lines.Add('SetProtocol: ' + IntToStr(iRetorno));

  if (rdbUSB.Checked) then
  begin
    iRetorno := OpenPort('USB', 0, '0', 0, 0);
    memo1.Lines.Add('OpenPort(USB): ' + IntToStr(iRetorno));
  end else
  if (rdbCOM.Checked) then
  begin
    iRetorno := OpenPort(edtPortaCOM.Text, 115200, 'n', 8, 1);
    memo1.Lines.Add('OpenPort(SERIAL): ' + IntToStr(iRetorno));
  end;

  iRetorno := SetLineSpacing(30);
  memo1.Lines.Add('SetLineSpacing(30): ' + IntToStr(iRetorno));
end;



procedure TForm1.CarregaECF();
var
  sNomeDll: String;
  HandleDLL: THandle;
begin
  sNomeDll := 'C:\PertoPrinterTEC\ptptrpro-win\bin\ptptrpro.dll';
  HandleDLL := LoadLibrary(PChar(sNomeDll));

  if (HandleDLL = 0) then
    raise Exception.Create('Erro ao carregar a DLL');


  @OpenPort := GetProcAddress(HandleDLL, 'OpenPort');
  @SetProtocol := GetProcAddress(HandleDLL, 'SetProtocol');
  @GetPrinterStatus := GetProcAddress(HandleDLL, 'GetPrinterStatus');
  @ptptrpro_GetMediaStatus := GetProcAddress(HandleDLL, 'ptptrpro_GetMediaStatus');
  @GetDrawerStatus := GetProcAddress(HandleDLL, 'GetDrawerStatus');
  @MakeCut := GetProcAddress(HandleDLL, 'MakeCut');
  @SendData := GetProcAddress(HandleDLL, 'SendData');
  @MakePrint := GetProcAddress(HandleDLL, 'MakePrint');
  @MakeCutnLines := GetProcAddress(HandleDLL, 'MakeCutnLines');
  @StoreQrCodeData := GetProcAddress(HandleDLL, 'StoreQrCodeData');
  @MakeQrCode := GetProcAddress(HandleDLL, 'MakeQrCode');
  @SetQrCodeModel := GetProcAddress(HandleDLL, 'SetQrCodeModel');
  @SetQrCodeResolution := GetProcAddress(HandleDLL, 'SetQrCodeResolution');
  @SetQrCodeErrorCorretion := GetProcAddress(HandleDLL, 'SetQrCodeErrorCorretion');
  @SetJustification := GetProcAddress(HandleDLL, 'SetJustification');
  @SetTextProperties := GetProcAddress(HandleDLL, 'SetTextProperties');
  @SetPrintMode := GetProcAddress(HandleDLL, 'SetPrintMode');
  @GeneratePulse := GetProcAddress(HandleDLL, 'GeneratePulse');
  @PrintBarCode := GetProcAddress(HandleDLL, 'PrintBarCode');
  @SetHriFont := GetProcAddress(HandleDLL, 'SetHriFont');
  @SetHriPosition := GetProcAddress(HandleDLL, 'SetHriPosition');
  @SetLineSpacing := GetProcAddress(HandleDLL, 'SetLineSpacing');
  @GetPartialLineFeed := GetProcAddress(HandleDLL, 'GetPartialLineFeed');
  @GetPrinterInfo := GetProcAddress(HandleDLL, 'GetPrinterInfo');
  @ClosePort := GetProcAddress(HandleDLL, 'ClosePort');

  memo1.Clear;
end;



procedure TForm1.Button2Click(Sender: TObject);
var
  iRetorno: Integer;
  iStatus: integer;
begin
  iRetorno := GetPrinterStatus(iStatus);
  memo1.Lines.Add('GetPrinterStatus - Retorno:' + IntToStr(iRetorno) + ' Status: ' + IntToStr(iStatus));

  iRetorno := ptptrpro_GetMediaStatus(iStatus);
  memo1.Lines.Add('ptptrpro_GetMediaStatus - Retorno:' + IntToStr(iRetorno) + ' Status: ' + IntToStr(iStatus));
end;



procedure TForm1.Button3Click(Sender: TObject);
var
  iRetorno: Integer;
  iStatus: integer;
begin
  iRetorno := GetDrawerStatus(PTR_DRAWERONE, iStatus);
  memo1.Lines.Add('GetDrawerStatus - Retorno:' + IntToStr(iRetorno) + ' Status: ' + IntToStr(iStatus));
end;



procedure TForm1.Button4Click(Sender: TObject);
var
  iRetorno: Integer;
begin
  iRetorno := MakeCut(PTR_CUT_PARTIAL);
  memo1.Lines.Add('MakeCut(Partial) - Retorno:' + IntToStr(iRetorno));
end;



procedure TForm1.Button5Click(Sender: TObject);
var
  iRetorno: Integer;
  iTamanho: integer;
  sTexto: String;
begin
  sTexto := 'Teste de impressao PertoPrinter';
  iTamanho := length(sTexto);

  iRetorno := SendData(sTexto, iTamanho);
  memo1.Lines.Add('SendData - Retorno:' + IntToStr(iRetorno));

  if (iRetorno = PTR_OK) then
  begin
    iRetorno := MakePrint;
    memo1.Lines.Add('MakePrint - Retorno:' + IntToStr(iRetorno));
  end;


  iRetorno := SetTextProperties(PTR_FONT_NARROW, false, false, false);     //* font, italic, underlined, bold */
  memo1.Lines.Add('SetTextProperties(NARROW) - Retorno:' + IntToStr(iRetorno));

  sTexto := '1234567890123456789012345678901234567890123456789012345678901234567890';
  iTamanho := length(sTexto);

  iRetorno := SendData(sTexto, iTamanho);
  memo1.Lines.Add('SendData - Retorno:' + IntToStr(iRetorno));

  if (iRetorno = PTR_OK) then
  begin
    iRetorno := MakePrint;
    memo1.Lines.Add('MakePrint - Retorno:' + IntToStr(iRetorno));
  end;


  iRetorno := SetPrintMode(1);
  memo1.Lines.Add('SetPrintMode(1) - Retorno:' + IntToStr(iRetorno));

  sTexto := '1234567890123456789012345678901234567890123456789012345678901234567890';
  iTamanho := length(sTexto);

  iRetorno := SendData(sTexto, iTamanho);
  memo1.Lines.Add('SendData - Retorno:' + IntToStr(iRetorno));

  if (iRetorno = PTR_OK) then
  begin
    iRetorno := MakePrint;
    memo1.Lines.Add('MakePrint - Retorno:' + IntToStr(iRetorno));
  end;

end;



procedure TForm1.Button6Click(Sender: TObject);
var
  iRetorno: Integer;
begin
  iRetorno := GetPartialLineFeed(3);
    memo1.Lines.Add('GetPartialLineFeed(3) - Retorno:' + IntToStr(iRetorno));

  iRetorno := MakeCutnLines(PTR_CUT_PARTIAL, 0);
  memo1.Lines.Add('MakeCutnLines(Partial, 0) - Retorno:' + IntToStr(iRetorno));


end;



procedure TForm1.Button7Click(Sender: TObject);
var
  iRetorno: Integer;
  sData: String;
begin
  sData := 'http://www.perto.com.br/pt/produtos/varejo/pertoprinter.html';

  iRetorno := SetJustification(PTR_POS_CENTER);
  memo1.Lines.Add('SetJustification(CENTER) - Retorno:' + IntToStr(iRetorno));

  iRetorno := SetQrCodeModel( PTR_QRCODE_MODELTWO );
  memo1.Lines.Add('SetQrCodeModel(MODELTWO) - Retorno:' + IntToStr(iRetorno));

  iRetorno := SetQrCodeResolution( PTR_QRCODE_FACTOR4 );
  memo1.Lines.Add('SetQrCodeResolution(FACTOR4) - Retorno:' + IntToStr(iRetorno));

  iRetorno := SetQrCodeErrorCorretion(PTR_QRCODE_LEVEL_M );
  memo1.Lines.Add('SetQrCodeErrorCorretion(LEVEL_M) - Retorno:' + IntToStr(iRetorno));


  iRetorno := StoreQrCodeData(sData, Length(sData));
  memo1.Lines.Add('StoreQrCodeData - Retorno:' + IntToStr(iRetorno));

  iRetorno := MakeQrCode;
  memo1.Lines.Add('MakeQrCode - Retorno:' + IntToStr(iRetorno));

  iRetorno := SetJustification(PTR_POS_LEFT);
  memo1.Lines.Add('SetJustification(LEFT) - Retorno:' + IntToStr(iRetorno));
end;



procedure TForm1.Button8Click(Sender: TObject);
var
  iRetorno: Integer;
begin
  iRetorno := GeneratePulse(1, 100, 100);     //* pin, time_on, time_off */
  memo1.Lines.Add('GeneratePulse(1, 100, 100) - Retorno:' + IntToStr(iRetorno));
end;



procedure TForm1.Button9Click(Sender: TObject);
var
  iRetorno: Integer;
begin
  iRetorno := SetHriFont(PTR_BAR_CODE_FONT_NORMAL);
  memo1.Lines.Add('SetHriFont - Retorno:' + IntToStr(iRetorno));

  iRetorno := SetHriPosition(PTR_BAR_CODE_POS_BELOW);
  memo1.Lines.Add('SetHriPosition - Retorno:' + IntToStr(iRetorno));

  iRetorno := SetJustification(PTR_POS_LEFT);
  memo1.Lines.Add('SetJustification(LEFT) - Retorno:' + IntToStr(iRetorno));

  iRetorno := PrintBarCode(PTR_BAR_CODE_EAN13,              //* type */
                       100,                              //* height */
                       PTR_BAR_CODE_WIDTH_MEDIUM,       //* width */
                       0,                               //* left_margin */
                       PTR_BAR_CODE_POS_BELOW,          //* text_pos */
                       PTR_BAR_CODE_FONT_NORMAL,        //* text_font */
                       '123456789012');                 //* data */

  memo1.Lines.Add('PrintBarCode - Retorno:' + IntToStr(iRetorno));
end;



procedure TForm1.Button10Click(Sender: TObject);
var
  iRetorno: Integer;
  PrinterInfoType: PrinterInfoStruct;
begin
  iRetorno := GetPrinterInfo(PrinterInfoType);
  memo1.Lines.Add('GetPrinterInfo - Retorno:' + IntToStr(iRetorno));

  memo1.Lines.Add('Printer model: ' + IntToStr(PrinterInfoType.printer_model));
  memo1.Lines.Add('Printer type: ' + IntToStr(PrinterInfoType.tipo));
  memo1.Lines.Add('Printer version: ' + PrinterInfoType.rom_version);
end;



procedure TForm1.Button11Click(Sender: TObject);
var
  iRetorno: Integer;
begin
  iRetorno := ClosePort;
  memo1.Lines.Add('ClosePort - Retorno:' + IntToStr(iRetorno));
end;

end.
