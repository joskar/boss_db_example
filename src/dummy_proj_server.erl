-module(dummy_proj_server).

-behaviour(gen_server).

%% API
-export([start_link/0, list/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
     terminate/2, code_change/3]).

-record(state, {}).

%% API
start_link() ->
    DBOptions = [
      {adapter, pgsql},
      {cache_enable, false},
      {shards, []},
      {db_database, "boss_test"},
      {db_password, "notasecret"},
      {db_username, "boss_test"},
      {db_host, "localhost"},
      {db_port, 5432}
    ],
    boss_db:start(DBOptions),
    boss_news:start(),
    compile_models(),
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

check_invoices() ->
    gen_server:call(?MODULE, check).

%% gen_server callbacks
init([]) ->
    {ok, #state{}}.

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% Internal
compile_models() ->
    Models = [ "invoice" ],
    compile_models(Models),
    ok.

compile_models([ ]) -> ok;
compile_models([Model | L]) ->
    Name = Model ++ ".erl",
    boss_record_compiler:compile(Name),
    compile_models(L).
