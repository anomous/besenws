unit besenserverconfig;
{
 besen classes for server configuration & global server manager class

 Copyright (C) 2016 Simon Ley

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU Lesser General Public License as published
 by the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU Lesser General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
}
{$i besenws.inc}

interface

uses
    SysUtils,
    Classes,
    SyncObjs,
    {$i besenunits.inc},
    webserverhosts,
    besenevents,
    beseninstance,
    webserver;

type
  { TBESENWebserverSite }

  TBESENWebserverSite = class(TBESENNativeObject)
  private
    FServer: TWebserver;
    FSite: TWebserverSite;
    function GetAutoUpdate: LongBool;
    procedure SetAutoUpdate(AValue: LongBool);
  published
    procedure addCGIHandler(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);

    procedure addFastCGIHandler(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);

    procedure addIndexPage(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
    { addHostname(host) - binds a host to this site. requests made to this host will be processed by this site }
    procedure addHostname(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
    { addForward(url, newUrl) - redirects requests from "url" to newUrl" using a 301 status code

      Example: site.addForward("/index.html", "/index.jsp") }
    procedure addForward(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
    { addScriptAlias(urlAlias, urlTarget) - points all requests STARTING WITH "urlAlias" to "targetAlias".
      the remainder of the request url will be put in the client http-parameter property

      Example: site.addScriptAlias("/foo/", "/script.jsp");
        the request "/foo/" will become "/script.jsp"
        the request "/foo/bar" will become "/script.jsp?bar"
        the request "/foo/bar?hello" will become "/script.jsp?bar?hello"
     }
    procedure addScriptAlias(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
    { addStatusPage(statusCode, target) - replaces a http status page (404 etc) with a custom page. can be static html or script }
    procedure addStatusPage(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
    { addResponseHeader(name, value) - adds a default response header entry }
    procedure addResponseHeader(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
    { addWebsocket(url, script) - creates a new script instance & thread with "script" loaded.
         "script" must point to a filename in the site root directory }
    procedure addWebsocket(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
    { addWhitelistExecutable(filename) - adds an executable that may be executed in the site context }
    procedure addWhitelistExecutable(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
    { updateCache() - rescans web directory for modified files and updates file-cache }
    procedure updateCache(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
    { fileExists(filename) - check if file exists. root is site's web folder }
    procedure fileExists(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
    { readFile(filename) - returns the content of filename. directory root for this function is the site web folder }
    procedure readFile(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
    { flushFile(filename) - writes a file that has been modified in cache to disk }
    procedure flushFile(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
    { unload() - unloads the site. the ecmascript site object will remain in memory until the garbage collector frees it }
    procedure unload(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
    { cacheAutoUpdate - if true, files in cache will be updated automatically if they have been modified on disk }
    property cacheAutoUpdate: LongBool read GetAutoUpdate write SetAutoUpdate;
  end;

  { TBESENWebserverListener }

  TBESENWebserverListener= class(TBESENNativeObject)
  private
    FServer: TWebserver;
    FListener: TWebserverListener;
    function GetIP: TBESENString;
    function GetPort: TBESENString;
  published
    { remove() - removes this listener }
    procedure remove(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);

    procedure enableSSL(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);

    procedure setCiphers(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);

    property ip: TBESENString read GetIP;
    property port: TBESENString read GetPort;
  end;

  { TBESENWebserverObject }

  TBESENWebserverObject = class(TBESENNativeObject)
  private
    FServer: TWebserver;
  protected
    procedure InitializeObject; override;
  published
    { addListener(ip, port) - adds a listening socket to ip:port. }
    procedure addListener(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
    { removeListener(listener) - removes a listener }
    procedure removeListener(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
    { addSite(siteName) - returns a site-object. siteName must be equal to the site directory name }
    procedure addSite(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
    { setThreadCount(threadCount) - sets the number of worker threads to threadCount. number of cpu cores recommended }
    procedure setThreadCount(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
    { setMimeType(fileExtension, mimeType) - overwrites the mimetype for a specific file type }
    procedure setMimeType(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
    { setDefaultSite(siteObject) - sets the default site for unknown hosts }
    procedure setDefaultSite(const ThisArgument:TBESENValue;Arguments:PPBESENValues;CountArguments:integer;var ResultValue:TBESENValue);
  end;

  { TWebserverManager }

  TWebserverManager = class
  private
    FServer: TWebserver;
    FInstance: TBESENInstance;
    FServerObject: TBESENWebserverObject;
    FPath: ansistring;
  public
    constructor Create(const BasePath: ansistring; TestMode: Boolean = false);
    destructor Destroy; override;
    function Execute(Filename: string): Boolean;
    procedure Process;
    property Server: TWebserver read FServer;
    property Path: ansistring read FPath;
  end;

var
  ServerManager: TWebserverManager;

function StripBasePath(filename: ansistring): ansistring;

implementation

uses
  mimehelper,
  besenwebsocket,
  besenprocess,
  logging;

function StripBasePath(filename: ansistring): ansistring;
begin
  if not Assigned(ServerManager) then
    result:=filename
  else if Pos(lowercase(Servermanager.Path), lowercase(filename))=1 then
    result:=Copy(filename, Length(ServerManager.Path), Length(filename))
  else
    result:=filename;
end;

{ TBESENWebserverListener }

function TBESENWebserverListener.GetIP: TBESENString;
begin
  if Assigned(FListener) then
    result:=BESENUTF8ToUTF16(FListener.IP)
  else
    result:='';
end;

function TBESENWebserverListener.GetPort: TBESENString;
begin
  if Assigned(FListener) then
    result:=BESENUTF8ToUTF16(FListener.Port)
  else
    result:='';
end;

procedure TBESENWebserverListener.remove(const ThisArgument: TBESENValue;
  Arguments: PPBESENValues; CountArguments: integer;
  var ResultValue: TBESENValue);
begin
  ResultValue:=BESENBooleanValue(False);
  if Assigned(FListener) then
  begin
    if FServer.RemoveListener(FListener) then
    begin
      FListener:=nil;
      FServer:=nil;
      ResultValue:=BESENBooleanValue(True);
    end;
  end;
end;

procedure TBESENWebserverListener.enableSSL(const ThisArgument: TBESENValue;
  Arguments: PPBESENValues; CountArguments: integer;
  var ResultValue: TBESENValue);
begin
  if CountArguments<3 then
   Exit;
  if Assigned(FListener) then
    if not FListener.SSL then
    FListener.EnableSSL(BESENUTF16ToUTF8(TBESEN(Instance).ToStr(Arguments^[0]^)), BESENUTF16ToUTF8(TBESEN(Instance).ToStr(Arguments^[1]^)), BESENUTF16ToUTF8(TBESEN(Instance).ToStr(Arguments^[2]^)));
end;

procedure TBESENWebserverListener.setCiphers(const ThisArgument: TBESENValue;
  Arguments: PPBESENValues; CountArguments: integer;
  var ResultValue: TBESENValue);
begin
  if CountArguments<1 then
   Exit;
  if Assigned(FListener) and(FListener.SSL) then
    FListener.SetSSLCiphers(BESENUTF16ToUTF8(TBESEN(Instance).ToStr(Arguments^[0]^)));
end;

{ TBESENWebserverSite }

function TBESENWebserverSite.GetAutoUpdate: LongBool;
begin
  if Assigned(FSite) then
    result:=FSite.Files.AutoUpdate
  else
    result:=False;
end;

procedure TBESENWebserverSite.SetAutoUpdate(AValue: LongBool);
begin
  if Assigned(FSite) then
    FSite.Files.AutoUpdate:=True;
end;

procedure TBESENWebserverSite.addCGIHandler(const ThisArgument: TBESENValue;
  Arguments: PPBESENValues; CountArguments: integer;
  var ResultValue: TBESENValue);
var
  prefix, ext, binary, args: ansistring;
begin
  if (CountArguments<3) or (not Assigned(FSite)) then
    Exit;

  prefix:=ansistring(TBESEN(Instance).ToStr(Arguments^[0]^));
  ext:=ansistring(TBESEN(Instance).ToStr(Arguments^[1]^));
  binary:=ansistring(TBESEN(Instance).ToStr(Arguments^[2]^));
  if CountArguments>3 then
    args:=ansistring(TBESEN(Instance).ToStr(Arguments^[3]^))
  else
    args:='';

  FSite.AddCGI(prefix, ext, binary, args);
end;

procedure TBESENWebserverSite.addFastCGIHandler(
  const ThisArgument: TBESENValue; Arguments: PPBESENValues;
  CountArguments: integer; var ResultValue: TBESENValue);
var
  prefix, ext, host, port: ansistring;
begin
  if (CountArguments<4) or (not Assigned(FSite)) then
    Exit;

  prefix:=ansistring(TBESEN(Instance).ToStr(Arguments^[0]^));
  ext:=ansistring(TBESEN(Instance).ToStr(Arguments^[1]^));
  host:=ansistring(TBESEN(Instance).ToStr(Arguments^[2]^));
  port:=ansistring(TBESEN(Instance).ToStr(Arguments^[3]^));

  FSite.AddFastCGISocket(prefix, ext, host, port);
end;

procedure TBESENWebserverSite.addIndexPage(const ThisArgument: TBESENValue;
  Arguments: PPBESENValues; CountArguments: integer;
  var ResultValue: TBESENValue);
begin
  if (CountArguments <1) or (not Assigned(FSite)) then
    Exit;
  FSite.AddIndexPage(ansistring(TBESEN(Instance).ToStr(Arguments^[0]^)));
end;

procedure TBESENWebserverSite.addHostname(const ThisArgument: TBESENValue;
  Arguments: PPBESENValues; CountArguments: integer;
  var ResultValue: TBESENValue);
begin
  if CountArguments<1 then
    Exit;

  if not Assigned(FSite) then
    Exit;

  FSite.AddHostAlias(BESENUTF16ToUTF8(TBESEN(Instance).ToStr(Arguments^[0]^)));
end;

procedure TBESENWebserverSite.addForward(const ThisArgument: TBESENValue;
  Arguments: PPBESENValues; CountArguments: integer;
  var ResultValue: TBESENValue);
begin
  if CountArguments<2 then
    Exit;

  if not Assigned(FSite) then
    Exit;

  FSite.AddForward(BESENUTF16ToUTF8(TBESEN(Instance).ToStr(Arguments^[0]^)), BESENUTF16ToUTF8(TBESEN(Instance).ToStr(Arguments^[1]^)));
end;

procedure TBESENWebserverSite.addScriptAlias(const ThisArgument: TBESENValue;
  Arguments: PPBESENValues; CountArguments: integer;
  var ResultValue: TBESENValue);
begin
  if CountArguments<2 then
    Exit;

  if not Assigned(FSite) then
    Exit;

  FSite.AddScriptDirectory(BESENUTF16ToUTF8(TBESEN(Instance).ToStr(Arguments^[0]^)), BESENUTF16ToUTF8(TBESEN(Instance).ToStr(Arguments^[1]^)));
end;

procedure TBESENWebserverSite.addStatusPage(const ThisArgument: TBESENValue;
  Arguments: PPBESENValues; CountArguments: integer;
  var ResultValue: TBESENValue);
begin
  if not Assigned(FSite) then
    Exit;

  if CountArguments<2 then Exit;

  FSite.AddCustomStatusPage(TBESEN(Instance).ToInt(Arguments^[0]^), BESENUTF16ToUTF8(TBESEN(Instance).ToStr(Arguments^[1]^)));
end;

procedure TBESENWebserverSite.addResponseHeader(
  const ThisArgument: TBESENValue; Arguments: PPBESENValues;
  CountArguments: integer; var ResultValue: TBESENValue);
begin
  if CountArguments<2 then
    Exit;

  FSite.AddResponseHeader(BESENUTF16ToUTF8(TBESEN(Instance).ToStr(Arguments^[0]^)), BESENUTF16ToUTF8(TBESEN(Instance).ToStr(Arguments^[1]^)));
end;

procedure TBESENWebserverSite.addWebsocket(const ThisArgument: TBESENValue;
  Arguments: PPBESENValues; CountArguments: integer;
  var ResultValue: TBESENValue);
var
  url: TBESENString;
begin
  if not Assigned(FSite) then
    Exit;

  if CountArguments<2 then
    Exit;

  url:=TBESEN(Instance).ToStr(Arguments^[0]^);
  FSite.AddCustomHandler(BESENUTF16ToUTF8(url), TBESENWebsocket.Create(FServer, FSite, BESENUTF16ToUTF8(TBESEN(Instance).ToStr(Arguments^[1]^)), url));
end;

procedure TBESENWebserverSite.addWhitelistExecutable(
  const ThisArgument: TBESENValue; Arguments: PPBESENValues;
  CountArguments: integer; var ResultValue: TBESENValue);
var
  s: ansistring;
begin
  if (CountArguments<1) or not Assigned(FSite) then
    Exit;

  s:=ansistring(TBESEN(Instance).ToStr(Arguments^[0]^));
  if Pos('/', s)<>1 then
    s:=FSite.Path+'bin/'+s;

  FSite.AddWhiteListProcess(s);
end;

procedure TBESENWebserverSite.updateCache(const ThisArgument: TBESENValue;
  Arguments: PPBESENValues; CountArguments: integer;
  var ResultValue: TBESENValue);
begin
  if not Assigned(FSite) then
    Exit;

  FSite.Rescan;
end;

procedure TBESENWebserverSite.fileExists(const ThisArgument: TBESENValue;
  Arguments: PPBESENValues; CountArguments: integer;
  var ResultValue: TBESENValue);
begin
  resultValue:=BESENBooleanValue(False);

  if not Assigned(FSite) then
    Exit;

  if CountArguments<1 then
    Exit;

  if SysUtils.FileExists(FSite.Path + ansistring(TBESEN(Instance).ToStr(Arguments^[0]^))) then
    resultValue:=BESENBooleanValue(True);
end;

procedure TBESENWebserverSite.readFile(const ThisArgument: TBESENValue;
  Arguments: PPBESENValues; CountArguments: integer;
  var ResultValue: TBESENValue);
begin
  resultValue:=BESENUndefinedValue;

  if not Assigned(FSite) then
    Exit;

  if CountArguments<1 then
    Exit;

  resultValue:=BESENStringValue(BESENUTF8ToUTF16(BESENGetFileContent(FSite.Path + BESENUTF16ToUTF8(TBESEN(Instance).ToStr(Arguments^[0]^)))));
end;

procedure TBESENWebserverSite.flushFile(const ThisArgument: TBESENValue;
  Arguments: PPBESENValues; CountArguments: integer;
  var ResultValue: TBESENValue);
begin
  if CountArguments<1 then
    Exit;

  if not Assigned(FSite) then
    Exit;

  FSite.Files.WriteFile(BESENUTF16ToUTF8(TBESEN(Instance).ToStr(Arguments^[0]^)));

end;

procedure TBESENWebserverSite.unload(const ThisArgument: TBESENValue;
  Arguments: PPBESENValues; CountArguments: integer;
  var ResultValue: TBESENValue);
begin
  if not Assigned(FSite) then
    Exit;

  if FServer.SiteManager.UnloadSite(FSite.Name) then
    FSite:=nil;
end;

{ TBESENWebserverObject }

procedure TBESENWebserverObject.InitializeObject;
begin
  inherited InitializeObject;
end;

procedure TBESENWebserverObject.addListener(const ThisArgument: TBESENValue;
  Arguments: PPBESENValues; CountArguments: integer;
  var ResultValue: TBESENValue);
var
  Listener: TWebserverListener;
  ListenerObj: TBESENWebserverListener;
begin
  ResultValue:=BESENUndefinedValue;

  if CountArguments<2 then
    Exit;

  Listener:=FServer.AddListener(BESENUTF16ToUTF8(TBESEN(Instance).ToStr(Arguments^[0]^)), BESENUTF16ToUTF8(TBESEN(Instance).ToStr(Arguments^[1]^)));

  ListenerObj:=TBESENWebserverListener.Create(Instance);
  ListenerObj.FListener:=Listener;
  ListenerObj.FServer:=FServer;
  ListenerObj.InitializeObject;

  ResultValue:=BESENObjectValue(ListenerObj);

  if CountArguments<5 then
    Exit;
  if Assigned(Listener) then
    Listener.EnableSSL(BESENUTF16ToUTF8(TBESEN(Instance).ToStr(Arguments^[2]^)), BESENUTF16ToUTF8(TBESEN(Instance).ToStr(Arguments^[3]^)), BESENUTF16ToUTF8(TBESEN(Instance).ToStr(Arguments^[4]^)));
end;

procedure TBESENWebserverObject.removeListener(const ThisArgument: TBESENValue;
  Arguments: PPBESENValues; CountArguments: integer;
  var ResultValue: TBESENValue);
var
  obj: TObject;
begin
  ResultValue:=BESENBooleanValue(False);
  if CountArguments<1 then
    Exit;

  obj:=TBESEN(Instance).ToObj(Arguments^[0]^);

  if obj is TBESENWebserverListener then
  begin
    if FServer.RemoveListener(TBESENWebserverListener(obj).FListener) then
    begin
      ResultValue:=BESENBooleanValue(True);
      TBESENWebserverListener(obj).FListener:=nil;
    end;
  end;
end;

procedure TBESENWebserverObject.addSite(const ThisArgument: TBESENValue;
  Arguments: PPBESENValues; CountArguments: integer;
  var ResultValue: TBESENValue);
var
  Site: TWebserverSite;
  BESENHost: TBESENWebserverSite;
begin
  ResultValue:=BESENUndefinedValue;

  if CountArguments<1 then
    Exit;

  Site:=FServer.SiteManager.AddSite(BESENUTF16ToUTF8(TBESEN(Instance).ToStr(Arguments^[0]^)));

  if Assigned(Site) then
  begin
    BESENHost:=TBESENWebserverSite.Create(Instance);
    BESENHost.FSite:=Site;
    BESENHost.FServer:=FServer;
    BESENHost.InitializeObject;

    ResultValue:=BESENObjectValue(BESENHost);
  end;
end;

procedure TBESENWebserverObject.setThreadCount(const ThisArgument: TBESENValue;
  Arguments: PPBESENValues; CountArguments: integer;
  var ResultValue: TBESENValue);
begin

  ResultValue:=BESENUndefinedValue;

  if CountArguments<1 then
    Exit;

  if not Assigned(FServer) then
    Exit;

  FServer.SetThreadCount(TBESEN(Instance).ToInt32(Arguments^[0]^));
end;

procedure TBESENWebserverObject.setMimeType(const ThisArgument: TBESENValue;
  Arguments: PPBESENValues; CountArguments: integer;
  var ResultValue: TBESENValue);
begin
  if CountArguments<2 then Exit;

  OverwriteMimeType(BESENUTF16ToUTF8(TBESEN(Instance).ToStr(Arguments^[0]^)), BESENUTF16ToUTF8(TBESEN(Instance).ToStr(Arguments^[1]^)));
end;

procedure TBESENWebserverObject.setDefaultSite(const ThisArgument: TBESENValue;
  Arguments: PPBESENValues; CountArguments: integer;
  var ResultValue: TBESENValue);
var
  o: TObject;
begin
  if CountArguments<1 then
    Exit;

  o:=TBESEN(Instance).ToObj(Arguments^[0]^);

  if not (o is TBESENWebserverSite) then
    Exit;

  if not Assigned(TBESENWebserverSite(o).FSite) then
    Exit;

  FServer.SiteManager.DefaultHost:=TBESENWebserverSite(o).FSite;
end;

{ TWebserverManager }

constructor TWebserverManager.Create(const BasePath: ansistring;
  TestMode: Boolean);
begin
  ServerManager:=Self;
  FServer:=TWebserver.Create(BasePath, TestMode);
  FInstance:=TBESENInstance.Create(FServer.SiteManager, nil);
  FPath:=FServer.SiteManager.Path;
  FServerObject:=TBESENWebserverObject.Create(FInstance);
  FServerObject.FServer:=FServer;
  FServerObject.InitializeObject;
  FInstance.AddEventHandler(FServer.SiteManager.ProcessTick);
  FInstance.GarbageCollector.Add(TBESENObject(FServerObject));
  FInstance.GarbageCollector.Protect(TBESENObject(FServerObject));
end;

destructor TWebserverManager.Destroy;
begin
  FInstance.Destroy;
  FServer.Destroy;
  inherited Destroy;
end;

function TWebserverManager.Execute(Filename: string): Boolean;
var
  lastfile: Integer;
begin
  result:=False;
  lastfile:=FInstance.CurrentFile;
  FInstance.SetFilename(ExtractFileName(Filename));
  FInstance.ObjectGlobal.put('server', BESENObjectValue(FServerObject), false);

  try
    FInstance.Execute(BESENGetFileContent(Filename));
    result:=True;
  except
    on e: Exception do
      FInstance.OutputException(e, 'startup');
  end;
  FInstance.CurrentFile:=lastfile;
end;

procedure TWebserverManager.Process;
begin
  FServer.Ticks:=longword(GetTickCount64);
  Finstance.ProcessHandlers;
end;

end.

