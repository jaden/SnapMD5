program SnapMD5;

uses
  Forms, Interfaces,
  Main in 'Main.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Quick MD5';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
