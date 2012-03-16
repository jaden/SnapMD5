{****************************************************
Snap MD5
Copyright (C) 2011 - Dan Hersam http://dan.hersam.com
*****************************************************}

program SnapMD5;

{$mode objfpc}{$H+}

uses
  Forms, Interfaces, Main, about;

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Snap MD5';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
