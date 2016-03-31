package js.npm;
import js.node.events.EventEmitter;

@:enum abstract BackoffEvent<T:haxe.Constraints.Function>(Event<T>) to Event<T> {
  /**
    Emitted when a backoff operation is started. Signals to the client how long the next backoff delay will be.
    number: number of backoffs since last reset, starting at 0
    delay: backoff delay in milliseconds
    err: optional error parameter passed to backoff.backoff([err])
  */
  var Backoff : BackoffEvent<Int->Float->Null<js.Error>->Void> = "backoff";

  /**
    Emitted when a backoff operation is done. Signals that the failing operation should be retried.
    number: number of backoffs since last reset, starting at 0
    delay: backoff delay in milliseconds
   */
  var Ready : BackoffEvent<Int->Float->Void> = "ready";

  /**
    Emitted when the maximum number of backoffs is reached. This event will only be emitted if the 
    client has set a limit on the number of backoffs by calling backoff.failAfter(numberOfBackoffs).
    The backoff instance is automatically reset after this event is emitted.
    err: optional error parameter passed to backoff.backoff([err])
   **/
  var Fail : BackoffEvent<Null<js.Error>->Void> = "fail";
}

@:jsRequire("backoff")
extern class Backoff extends EventEmitter<Backoff> {

  /**
    Sets a limit on the maximum number of backoffs that can be performed before a fail event gets
    emitted and the backoff instance is reset. By default, there is no limit on the number of
    backoffs that can be performed.

    Arguments
    @param numberOfBackoffs: maximum number of backoffs before the fail event gets emitted, must
                             be greater than 0
   **/
  function failAfter(numberOfBackoffs:Int):Void;

  /** 
    Starts a backoff operation. If provided, the error parameter will be emitted as the last
    argument of the backoff and fail events to let the listeners know why the backoff operation
    was attempted.
    An error will be thrown if a backoff operation is already in progress.
    In practice, this method should be called after a failed attempt to perform a sensitive
    operation (connecting to a database, downloading a resource over the network, etc.).

    Arguments
    @param err: optional error parameter
   **/
  @:overload(function (err:js.Error):Void {})
  function backoff():Void;

  /** 
    Resets the backoff delay to the initial backoff delay and stop any backoff operation in
    progress. After reset, a backoff instance can and should be reused.

    In practice, this method should be called after having successfully completed the sensitive
    operation guarded by the backoff instance or if the client code request to stop any
    reconnection attempt.
   **/
  function reset():Void;

  /**
    Constructs a Fibonacci backoff (10, 10, 20, 30, 50, etc.).
    The options are the following.
      randomisationFactor: defaults to 0, must be between 0 and 1
      initialDelay: defaults to 100 ms
      maxDelay: defaults to 10000 ms
    With these values, the backoff delay will increase from 100 ms to 10000 ms. The
    randomisation factor controls the range of randomness and must be between 0 and 1. By
    default, no randomisation is applied on the backoff delay.
   **/
  @:overload(function (options:Dynamic):Backoff {})
  static function fibonacci():Backoff;

  /**
    Constructs an exponential backoff (10, 20, 40, 80, etc.).
    The options are the following.
      randomisationFactor: defaults to 0, must be between 0 and 1
      initialDelay: defaults to 100 ms
      maxDelay: defaults to 10000 ms
      factor: defaults to 2, must be greater than 1
    With these values, the backoff delay will increase from 100 ms to 10000 ms. The
    randomisation factor controls the range of randomness and must be between 0 and 1. By
    default, no randomisation is applied on the backoff delay.
   **/
  @:overload(function (options:Dynamic):Backoff {})
  static function exponential():Backoff;
}
