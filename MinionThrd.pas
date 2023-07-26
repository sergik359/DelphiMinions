unit MinionThrd;

interface

uses
  System.Classes, Windows;

type
  MinionThread = class(TThread)
  private
    FNumberMinion: integer;
    DepositMinion: integer;
    ContributionMinion: integer;
  protected
    procedure Execute; override;
    procedure UpdateResults;
  public
    property NumberMinion: integer write FNumberMinion;
  end;

implementation
uses SysUtils, Dialogs, Unit1;


procedure MinionThread.Execute;
begin
  ContributionMinion:= 0;
  while(Form1.FillingDC < Form1.DepositCart) do
  begin
    DepositMinion:= random(2) + 1;
    Synchronize(UpdateResults);
  end;
end;


procedure MinionThread.UpdateResults();
begin
      EnterCriticalSection(Form1.StringSection);
      if(Form1.FillingDC + DepositMinion <= Form1.DepositCart ) then
      begin
          Form1.FillingDC:= Form1.FillingDC + DepositMinion;
          ContributionMinion:= ContributionMinion + DepositMinion;
          Form1.Memo1.Lines.Add('Номер миньона ' + IntToStr(FNumberMinion) + ' Вклад: ' +
            IntToStr(DepositMinion) + ' Общий вклад миниона ' + IntToStr(ContributionMinion));
          Form1.Label2.Caption:= 'Корзина заполнена на ' + IntToStr(Form1.FillingDC);
          Form1.ProgressBar1.Position:= Form1.FillingDC;
      end;
      Sleep(100);
      LeaveCriticalSection(Form1.StringSection);
end;

end.
