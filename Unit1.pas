unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Button1: TButton;
    Memo1: TMemo;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    ProgressBar1: TProgressBar;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    FThreadCount: integer;
    procedure HandleTerminate(Sender: TObject);
  public
    { Public declarations }
    FillingDC: integer;
    DepositCart: integer;
    StringSection: TRTLCriticalSection;
  end;

var
  Form1: TForm1;

implementation
uses  MinionThrd;
{$R *.dfm}


procedure TForm1.Button1Click(Sender: TObject);
var
  NewThread: MinionThread;
begin
  Memo1.Clear();
  FillingDC:= 0;
  FThreadCount:= StrToInt(Edit1.Text);
  DepositCart:= StrToInt(Edit2.Text);

  ProgressBar1.Max:= DepositCart;

  InitializeCriticalSection(StringSection);

  for var  i := 1 to FThreadCount do
    begin
      NewThread := MinionThread.Create(True);
      NewThread.FreeOnTerminate := True;
      try
        with NewThread do
        begin
          NumberMinion:= i;
          OnTerminate:= HandleTerminate;
          Resume;
        end;
      except on EConvertError do
        begin
          NewThread.Free;
          ShowMessage('That is not a valid number!');
        end;
      end;
  end;
end;


procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := true;
  if FThreadCount > 0 then
  begin
    if MessageDlg('Threads active. Do you still want to quit?',
      mtWarning, [mbYes, mbNo], 0) = mrNo then
      CanClose := false;
  end;
end;


procedure TForm1.FormCreate(Sender: TObject);
begin
   FThreadCount:= 0;
   DepositCart:= 0;
   FillingDC:= 0;
end;


procedure TForm1.HandleTerminate(Sender: TObject);
begin
  Dec(FThreadCount);
end;
end.
