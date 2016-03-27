-module(dummy_proj_app).

-behaviour(application).

%% Application callbacks
-export([start/0, start/2, stop/1]).

start() ->
    application:start(dummy_proj).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    dummy_proj_sup:start_link().

stop(_State) ->
    ok.
