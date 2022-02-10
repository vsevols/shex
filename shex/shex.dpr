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
    handler:=TCommandHandler.Create;
    handler.Process(CmdLine);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
