program Project1;
{$APPTYPE CONSOLE}

uses
  windows,AbArcTyp, SysUtils,
  c_menu in 'c_menu.pas',
  c_core in 'c_core.pas';

type
  TEventHandlers = class // create a dummy class
     procedure BadLogin();
     procedure UnknownErr(Reciev : string);
     procedure OldVer();
     procedure OldLauncher();
     procedure ConnectErr();
     procedure Downloading(DwnFile: downloadInfo; Sender:TObject);
     procedure Unzip(Sender : TObject; Item : TAbArchiveItem; Progress : Byte; var Abort : Boolean);
   end;
   
var
  console : TConsoleOutput;
  typed : string;
  newOptions : globalOptions;
  Core : TCore;
  EvHandler:TEventHandlers;

{
��������� �������. ��������� � �������� ��������
}

procedure TEventHandlers.BadLogin();
begin
 console.ConsoleLongMessage(3,14,60,'������������ �� ���������� ��� ������ ������ �������');
 readln;
end;

procedure TEventHandlers.UnknownErr(Reciev : string);
begin
 console.ConsoleLongMessage(3,14,60,'������ ������ ������������ �����: '+ Reciev);
 readln;
end;

procedure TEventHandlers.OldVer();
begin
 console.ConsoleLongMessage(3,14,60,'������ ������ �� ������������� ������ ��������� ��������');
 readln;
end;

procedure TEventHandlers.OldLauncher();
begin
 console.ConsoleLongMessage(3,14,60,'������� �������');
 readln;
end;

procedure TEventHandlers.ConnectErr();
begin
 console.ConsoleLongMessage(3,14,60,'������ ����������� ����������');
 readln;
end;

procedure TEventHandlers.Downloading(DwnFile: downloadInfo; Sender:TObject);
var
 total, cur : integer;
begin
cur := DwnFile.currentsize;
total := DwnFile.size;

  console.ConsoleLongMessage(3,14,60,'[�������� ����������] [' + IntToStr(round((cur/total)*100)) + '%] ����: ' + DwnFile.name);
end;

procedure TEventHandlers.Unzip(Sender : TObject; Item : TAbArchiveItem; Progress : Byte; var Abort : Boolean);
var
  fname : string;
begin

fname := ExtractFileName(StringReplace(Item.FileName,'/','\',[rfReplaceAll]));

if Length(fname) > 0 then
 console.ConsoleLongMessage(3,14,60,'[�������������] ����: ' + fname); 
end;

begin

 // Create(_���_�����_��������_, _�����_�_�����_)
 // ����� ��������� � AppData\Application Data ����������� ������������

 Core := TCore.Create('ConsoleLauncher', 'TWEBMCR'); // ������� ��������� ������� "����"
 {
  ��������� ���� ��������. �� ��������� craft.catface.ru... ��� ��������� � c_core

  ��� ���������� ����� �������� ���������������� ������ ������
  � ��������� ������ ����������� ��� �����������
  ���������� ��. ��� ��������� � c_core
 }

  Core.DownloadConfig;

 {
  ��������� ��������� �������
 }
  Core.OnUnarchItem      := EvHandler.Unzip;       // ���������������� zip ������
  Core.OnDownloadProcess := EvHandler.Downloading; // ������� �������� �����
  Core.OnUnknown         := EvHandler.UnknownErr;  // ����������� ����� �� �������
  Core.OnOldLauncher     := EvHandler.OldLauncher; // �������� �������� ������� ( ������ ��������� ��� ��������� ������ ����� ������������ \ �������� )
  Core.OnOldVer          := EvHandler.OldVer;      // ����� ������� - Old version
  Core.OnConnectErr      := EvHandler.ConnectErr;  // ������ ����������� ����������
  Core.OnBadLogin        := EvHandler.BadLogin;    // ����� ������� - Bad Login

 console := TConsoleOutput.Create;   // ��� ��� ����� ��� ������ � ��������, �� �������� �������� >_>
 console.ConsoleInit;


 newOptions := Core.currentOptions; // ����������� � ���� ������� ���������

 console.ConsoleLine(3,5,'������ �������������: ', 40);
 console.ConsoleLine(3,6,newOptions.webOptions.AutoConfig, 40);

 console.ConsoleLine(3,7,'������� ���: ', 14);
 console.CursorPos(18,7); readln(typed);

 newOptions.pOptions.Login := typed;  // �������� ��� ������������
 
 console.ConsoleLine(3,8,'������� ������: ', 14);
 console.CursorPos(20,8); readln(typed);

 newOptions.pOptions.Password := typed;  // �������� ������ ������������

 Core.currentOptions := newOptions; // �������� ���������� ��������� �������

  if Core.Login then begin // ������� �������� ������ ��� ����� �� ������ ( ������������� ������ )
     if Core.DownloadFileList() then Core.Play; // ��������� �����, ��������� � ����� �������� ( �� ��������� �������� ������ ������ �� c_core ), ���� ��� ������ �������, ��������� ����
  end;
end.
