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

    handler:=TCommandHandler.Create;
    handler.Process(CmdLine);
    if False then
      Sleep(MaxInt);
  except
    on E: Exception do
    begin
      Writeln(E.ClassName, ': ', E.Message);
      Sleep(MaxInt);
    end;
  end;
end.
