program shex;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  CommandHandlerUnit in 'Units\CommandHandlerUnit.pas';

{
  * gitProjectWorkingPath
    shex://d:\Git\shex\shex?
  * build target
    shex://d:\Git\shex\shex\Win32\Debug?
	* deployed
    shex://x:\programs\shex?
}

//TODO: implement command:
//* manual deploying
//shex://lr?d:\Git\shex\shex&x:\programs\shex
//- split by ? and &
//lr handler: lr.exe or tcSetLeftRightTabs(parsedCmdLine.Params)

var
  handler: ICommandHandler;
  freezeAfterFinish: Boolean;
begin
  try
    WriteLn('received: '+CmdLine);

    handler:=TCommandHandler.Create;
    handler.Process(CmdLine);
    freezeAfterFinish:=FileExists(ExtractFilePath(ParamStr(0))+'.freezeAfterFinish=True');
    //TODO:
    //WriteLn('type "config" or Enter to exit');
    //if Readln.LowerCase='config' then
    //  handler.locateConfig();

    if freezeAfterFinish then
      ReadLn;
  except
    on E: Exception do
    begin
      Writeln(E.ClassName, ': ', E.Message);
      Sleep(MaxInt);
    end;
  end;
end.
