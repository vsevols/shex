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
    IsLocateQuery: Boolean;
  public
    constructor Create(inst: TParsedCmdLine);
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

  //if parsed.Path.EndsWith('?') then
  if parsed.IsLocateQuery then
  begin
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
  Result:=Result.Create(Result);
  sl:=TStringList.Create;
  try
    CmdLine:=CmdLine.Replace('"', '');
    if CmdLine.contains('/?') then
    begin
      //? doesn't works
      //sl.QuoteChar:=#0;
      sl.Delimiter:='?';
      sl.DelimitedText:=CmdLine;
      //if sl[1].EndsWith('/') then
        //sl[1]:=sl[1].Substring(0, sl[1].Length-1);
      if (sl.Count<3) or sl[2].IsEmpty then
        Result.isLocateQuery:=True;
    end
    else
    begin
      //Похоже, избыточный блок
      sl.Delimiter:=' ';
      sl.DelimitedText:=CmdLine;
    end;

    if sl.Count<2 then
      raise Exception.Create('no params in CmdLine');

    selfPath:=sl[0];
    Result.Path:=sl[1];
    for I := 2 to sl.Count-1 do
      Result.Params:=Result.Params+' '+sl[i];

    Result.Path:=Result.Path.Substring('shex:\\'.Length);
    if Result.Path.EndsWith('/') then
      Result.Path:=copy(Result.Path, 0, Result.Path.Length-1);

  finally
    FreeAndNil(sl);
  end;
end;

procedure TCommandHandler.Shex(parsed: TParsedCmdLine);
begin
  Writeln(Format(
  'executing Path: %s ;Params: %s ;IsLocateQuery: %s',
    [parsed.Path, parsed.Params, BoolToStr(parsed.IsLocateQuery, True)]
    ));
  Winapi.ShellApi.ShellExecute(0, nil, pChar(parsed.Path), pChar(parsed.Params), nil, SW_NORMAL);
end;

procedure TCommandHandler.tcLocate(parsed: TParsedCmdLine);
begin
  //E:\drbVsev\Dropbox\programs\totalcmd8\TOTALCMD.EXE /O /R=D:\test.txt
  parsed.Params:='/O /R='+parsed.Path.Replace('/', '\');
  parsed.Path:='E:\drbVsev\Dropbox\programs\totalcmd8\TOTALCMD.EXE';
  Shex(parsed);
end;

constructor TParsedCmdLine.Create(inst: TParsedCmdLine);
begin
  inherited;
  IsLocateQuery:=False;
end;

end.
