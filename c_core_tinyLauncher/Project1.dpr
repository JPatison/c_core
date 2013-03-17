program Project1;

uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  c_crypt in 'c_crypt.pas',
  c_core in 'c_core.pas',
  Unit2 in 'Unit2.pas' {Form2},
  Unit3 in 'Unit3.pas' {Form3},
  Unit4 in 'Unit4.pas' {Form4},
  Unit5 in 'Unit5.pas' {Form5},
  Unit6 in 'Unit6.pas' {Form6};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'TinyLauncher';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.