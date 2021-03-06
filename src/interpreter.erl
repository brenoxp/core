-module(interpreter).

-export([process_request/2]).

insert(Key, Value) ->
    ets:insert(docs, {Key, Value}).

lookup(Key) -> 
    ets:lookup(docs, Key).

gen_id() ->
    Time=erlang:system_time(nano_seconds),
    StringTime=integer_to_list(Time),
    UniformRandom=rand:uniform(10000),
    StringRandom=integer_to_list(UniformRandom),
    {Id, _} = string:to_integer(StringRandom++StringTime),
    Ctx = hashids:new([{salt, "AngraDB"}, {min_hash_length, 1}, {default_alphabet, "ABCDEF0123456789"}]),
    hashids:encode(Ctx, Id).

process_request(save, Document) ->
    Id = gen_id(), 
    insert(Id, Document),
    {ok, Id};
process_request(lookup, Key) ->
    lookup(Key).

%% execute() ->
%%     receive 
%% 	{From, {[save, Document]}} -> 
%%             Id = gen_id(), 
%% 	    insert(Id, Document),
%%             From ! {self(), ok, Id};
%%         {From, {[lookup, Key]}} -> 
%% 	    From ! {self(), lookup(Key)}
%%     end.
