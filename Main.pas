{****************************************************
Snap MD5
Copyright (C) 2011 - Dan Hersam http://dan.hersam.com
*****************************************************}

{%RunFlags BUILD-}

unit Main;

interface

uses
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls,
  ClipBrd, LResources, Menus, ComCtrls, Md5, Sha1, About, ShellApi, FileUtil;

type

  { TMainForm }

  TMainForm = class(TForm)
    BrowseBtn: TButton;
    MenuReset: TMenuItem;
    MenuHash: TMenuItem;
    sha1: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    FileField: TEdit;
    md5sum: TEdit;
    GroupBox3: TGroupBox;
    Clipfield: TEdit;
    GroupBox4: TGroupBox;
    MatchStatus: TLabel;
    MainMenu1: TMainMenu;
    MenuFile: TMenuItem;
    MenuHelp: TMenuItem;
    MenuAbout: TMenuItem;
    MenuOpen: TMenuItem;
    MenuExit: TMenuItem;
    StatusBar1: TStatusBar;
    procedure ActivateForm(Sender: TObject);
    procedure BrowseBtnClick(Sender: TObject);
    procedure ResetFields(Sender: TObject);
    procedure CloseApp(Sender: TObject);
    procedure DropFiles(Sender: TObject; const FileNames: array of String);
    procedure FillFields(Sender: TObject);
    procedure ClipfieldChange(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure SelectField(Sender: TObject);
    procedure ShowAbout(Sender: TObject);
    procedure UpdateStatus();
    procedure GetTextFromClipboard();
    procedure CalcHashes(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation


procedure TMainForm.BrowseBtnClick(Sender: TObject);
var
  openDialog : TOpenDialog;
begin
  openDialog := TOpenDialog.Create(self);
  openDialog.FileName := '';
  openDialog.InitialDir := GetCurrentDir;
  openDialog.Options := [ofFileMustExist];
  openDialog.Filter := '*.*';

  if openDialog.Execute then
  begin
    FileField.Text := OpenDialog.FileName;
  end;
  openDialog.Free;
  CalcHashes(Sender);
end;

procedure TMainForm.ResetFields(Sender: TObject);
begin
   FileField.Text := '';
	 md5sum.Text := '';
	 sha1.Text := '';
   GetTextFromClipboard();
   MatchStatus.Caption := '';
   MatchStatus.Color := clNone;
   // This will set the status bar appropriately
   CalcHashes(Sender);
end;

procedure TMainForm.ActivateForm(Sender: TObject);
begin
  WindowState   := wsNormal;
  ShowInTaskBar := stDefault;
  Show;
  // Only update if Filename is populated, status is empty and both hash fields are empty
  if (Length(FileField.Text) > 0) And (Length(StatusBar1.SimpleText) = 0) And
  	(Length(md5sum.Text) = 0) And (Length(sha1.Text) = 0) then
    CalcHashes(Sender);
end;

procedure TMainForm.CloseApp(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.DropFiles(Sender: TObject; const FileNames: array of String);
begin
  FileField.Text := FileNames[0];
  CalcHashes(Sender);
end;

procedure TMainForm.CalcHashes(Sender: TObject);
var fname : String;
begin
  fname := UTF8ToSys(FileField.Text);

  md5sum.Text := '';
  sha1.Text := '';
  MatchStatus.Caption := '';
  MatchStatus.Color := clNone;
  GetTextFromClipboard();

  if Length(fname) = 0 then
  begin
    StatusBar1.SimpleText := 'Browse to a file';
    Exit;
  end;

  if Not FileExists(fname) then
  begin
    StatusBar1.SimpleText := 'That file doesn''t exist';
    Exit;
  end;

  try
    StatusBar1.SimpleText := 'Generating MD5 sum...';
    MainForm.Repaint;
    md5sum.Text := MD5Print(MD5File(fname));
    MainForm.Repaint;
    StatusBar1.SimpleText := 'Generating SHA-1 hash...';
    MainForm.Repaint;
    sha1.Text := SHA1Print(SHA1File(fname));
    StatusBar1.SimpleText := 'Done';
    UpdateStatus();
  except
    StatusBar1.SimpleText := 'Error opening file: ' + fname;
  end;
end;

procedure TMainForm.UpdateStatus();
begin
  if (md5sum.Text = '') or (Clipfield.Text = '') then
  begin
    Exit
  end;
  // Get rid of trailing whitespace
  Clipfield.Text := trim(Clipfield.Text);

  if md5sum.Text = Clipfield.Text then
  begin
    MatchStatus.Caption := 'MD5 sum matches';
    MatchStatus.Color := clGreen;
    StatusBar1.SimpleText := 'Success';
  end
  else if sha1.Text = Clipfield.Text then
  begin
    MatchStatus.Caption := 'SHA-1 hash matches';
    MatchStatus.Color := clTeal;
    StatusBar1.SimpleText := 'Success';
  end
  else begin
    MatchStatus.Caption := 'No match';
    MatchStatus.Color := clRed;
    StatusBar1.SimpleText := 'File does not match either hash';
  end;
end;

procedure TMainForm.FillFields(Sender: TObject);
begin
  DragAcceptFiles(Handle, True);
  if ParamCount >= 1 then
  begin
    FileField.Text := SysToUTF8(ParamStr(1));
  end;
  GetTextFromClipboard();
  StatusBar1.SimpleText := '';
end;

procedure TMainForm.GetTextFromClipboard();
var
  clipText : String;
begin
  clipText := Clipboard.AsText;
  if length(clipText) = 0 then
  begin
    Clipfield.Text := 'No text was in the clipboard';
  end
  else begin
	  setLength(clipText, 40);
		Clipfield.Text := clipText;
  end;
end;

procedure TMainForm.ClipfieldChange(Sender: TObject);
begin
  updateStatus();
end;

procedure TMainForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
   if key = #27 then Close;
end;

procedure TMainForm.SelectField(Sender: TObject);
begin
  If (Sender is TEdit) then
     TEdit(Sender).SelectAll;
end;

procedure TMainForm.ShowAbout(Sender: TObject);
var AboutForm : TAboutForm;
begin
     AboutForm := TAboutForm.Create(nil);
     AboutForm.ShowModal;
     AboutForm.Release;
end;

initialization
  {$i Main.lrs}
end.
