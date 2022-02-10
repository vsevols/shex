unit CommandHandlerUnit;

interface

uses
  System.SysUtils;

type
  ICommandHandler = interface(IInterface)
    procedure Process(CmdLine: string); stdcall;
  end;

  TParsedCmdLine = record
    Path: string;
    Params: string;
  end;

  TCommandHandler = class(TInterfacedObject, ICommandHandler)
    procedure Process(CmdLine: string); stdcall;
  public
    function ParseCmdLine(CmdLine: string): TParsedCmdLine;
    procedure Shex(parsed: TParsedCmdLine);
    procedure tcLocate(parsed: TParsedCmdLine);
  end;


implementation

uses
  Winapi.ShellAPI, Winapi.Windows, System.WideStrings,
  System.Classes;

procedure TCommandHandler.Process(CmdLine: string);
var
  parsed: TParsedCmdLine;
begin
  parsed:=ParseCmdLine(CmdLine);
  if parsed.Path.EndsWith('?') then
  begin
    parsed.Path:=copy(parsed.Path, 1, parsed.Path.Length-1);
    tcLocate(parsed);
  end
  else
    Shex(parsed);
end;

function TCommandHandler.ParseCmdLine(CmdLine: string): TParsedCmdLine;
var
  hinst: Winapi.Windows.HINST;
  selfPath: string;
  sl: TStringList;
  I: Integer;
begin
  sl:=TStringList.Create;
  try
    sl.Delimiter:=' ';
    sl.DelimitedText:=CmdLine;
    if sl.Count<2 then
      raise Exception.Create('no params in CmdLine');

    selfPath:=sl[0];
    Result.Path:=sl[1];
    for I := 2 to sl.Count-1 do
      Result.Params:=Result.Params+' '+sl[i];

    Result.Path:=Result.Path.Substring('shex:\\'.Length)
  finally
    FreeAndNil(sl);
  end;
end;

procedure TCommandHandler.Shex(parsed: TParsedCmdLine);
begin
  Winapi.ShellApi.ShellExecute(0, nil, pChar(parsed.Path), pChar(parsed.Params), nil, SW_NORMAL);
end;

procedure TCommandHandler.tcLocate(parsed: TParsedCmdLine);
begin
  //E:\drbVsev\Dropbox\programs\totalcmd8\TOTALCMD.EXE /O /R=D:\test.txt
  parsed.Params:='/O /R='+parsed.Path.Replace('/', '\');
  parsed.Path:='E:\drbVsev\Dropbox\programs\totalcmd8\TOTALCMD.EXE';
  Shex(parsed);
end;

end.
