program shex;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  CommandHandlerUnit in 'Units\CommandHandlerUnit.pas';

var
  handler: ICommandHandler;
begin
  try
    WriteLn('received: '+CmdLine);
    if False then
      Sleep(MaxInt);

    handler:=TCommandHandler.Create;
    handler.Process(CmdLine);
  except
    on E: Exception do
    begin
      Writeln(E.ClassName, ': ', E.Message);
      Sleep(MaxInt);
    end;
  end;
end.
