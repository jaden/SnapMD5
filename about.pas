{****************************************************
Snap MD5
Copyright (C) 2011 - Dan Hersam http://dan.hersam.com
*****************************************************}

unit About;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, LCLIntf;

type

  { TAboutForm }

  TAboutForm = class(TForm)
    Button1: TButton;
    Image1: TImage;
    TextLbl: TLabel;
    TitleLbl: TLabel;
    UrlLbl: TLabel;
    procedure Exit(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure GotoUrl(Sender: TObject);
    procedure ShowAboutForm(Sender: TObject);
    procedure CloseForm();
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  AboutForm: TAboutForm;

implementation

{ TAboutForm }

const
     URL = 'http://dan.hersam.com/software/snap-md5/';
     AppTitle = 'Snap MD5';

procedure TAboutForm.ShowAboutForm(Sender: TObject);
const
  VersionStr = {$I version.inc};
begin
  TitleLbl.Caption := AppTitle + ' v' + VersionStr;
  TextLbl.Caption := 'Snapmagic Software' + sLineBreak + 'Written by Dan Hersam';
  UrlLbl.Caption := URL;
end;

procedure TAboutForm.FormKeyPress(Sender: TObject; var Key: char);
begin
  if key = #27 then CloseForm();
end;

procedure TAboutForm.GotoUrl(Sender: TObject);
begin
  //ShellExecute(0, 'open', PChar(TLabel(Sender).Caption), nil, nil, SW_SHOWNORMAL);
  OpenURL(PChar(TLabel(Sender).Caption));
end;

procedure TAboutForm.Exit(Sender: TObject);
begin
  CloseForm();
end;

procedure TAboutForm.CloseForm();
begin
     Close;
end;

initialization
  {$I about.lrs}
end.

