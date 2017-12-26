-module(vtime_server).
-behaviour(gen_server).
-author ("Hisham Ismail <mhishami@gmail.com>").

%% API.
-export ([start_link/0]).
-export ([time/0]).

%% gen_server.
-export([init/1]).
-export([handle_call/3]).
-export([handle_cast/2]).
-export([handle_info/2]).
-export([terminate/2]).
-export([code_change/3]).

-record(state, {
        delta :: integer()
}).

-define (SERVER, ?MODULE).

%% API.

-spec start_link() -> {ok, pid()}.
start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

time() ->
  gen_server:call(?SERVER, {time}).

%% gen_server.

init([]) ->
  ?INFO("Module ~p started on node ~p~n", [?SERVER, node()]),
  process_flag(trap_exit, true),

  % TODO: fetch time from time server, and added delta here.
  {ok, #state{delta=0}}.

handle_call({time}, _From, State = #state{delta=Delta}) ->
  Time = erlang:universaltime_to_posixtime(erlang:universaltime()),
  {reply, {ok, Time + Delta}, State};
  
handle_call(_Request, _From, State) ->
  {reply, ignored, State}.

handle_cast(_Msg, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.
