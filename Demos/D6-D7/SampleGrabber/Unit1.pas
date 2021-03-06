unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, DSPack;

type
  TForm1 = class(TForm)
    FilterGraph: TFilterGraph;
    VideoWindow: TVideoWindow;
    SampleGrabber: TSampleGrabber;
    Image: TImage;
    OpenPlay: TButton;
    Snapshot: TButton;
    OpenDialog: TOpenDialog;
    CallBack: TCheckBox;
    procedure OpenPlayClick(Sender: TObject);
    procedure SnapshotClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SampleGrabberBuffer(sender: TObject; SampleTime: Double;
      pBuffer: Pointer; BufferLen: Integer);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.OpenPlayClick(Sender: TObject);
begin
  if OpenDialog.Execute then
  begin
    FilterGraph.Active := False;
    FilterGraph.Active := true;
    FilterGraph.RenderFile(OpenDialog.FileName);
    FilterGraph.Play;
  end;
end;

procedure TForm1.SnapshotClick(Sender: TObject);
begin
  SampleGrabber.GetBitmap(Image.Picture.Bitmap)
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CallBack.Checked := false;
  FilterGraph.ClearGraph;
  FilterGraph.Active := false;
end;

procedure TForm1.SampleGrabberBuffer(sender: TObject; SampleTime: Double;
  pBuffer: Pointer; BufferLen: Integer);
begin
  if CallBack.Checked then
  begin
    Image.Canvas.Lock; // to avoid flickering
    try
      SampleGrabber.GetBitmap(Image.Picture.Bitmap, pBuffer, BufferLen)
    finally
      Image.Canvas.Unlock;
    end;
  end;
end;

end.
