# Haxe/hxnodejs externs for the [backoff](https://www.npmjs.com/package/backoff) npm library

Tested using `backoff` version **2.5.0**

Example:
```haxe
import js.npm.Backoff;

var fibonacciBackoff = js.npm.Backoff.fibonacci({
    randomisationFactor: 0,
    initialDelay: 10,
    maxDelay: 300
});
 
fibonacciBackoff.failAfter(10);
 
fibonacciBackoff.on(BackoffEvent.Backoff, function(number, delay) {
    // Do something when backoff starts, e.g. show to the 
    // user the delay before next reconnection attempt. 
    trace(number + ' ' + delay + 'ms');
});
 
fibonacciBackoff.on(BackoffEvent.Ready, function(number, delay) {
    // Do something when backoff ends, e.g. retry a failed 
    // operation (DNS lookup, API call, etc.). If it fails 
    // again then backoff, otherwise reset the backoff 
    // instance. 
    fibonacciBackoff.backoff();
});
 
fibonacciBackoff.on(BackoffEvent.Fail, function() {
    // Do something when the maximum number of backoffs is 
    // reached, e.g. ask the user to check its connection. 
    trace('fail');
});
 
fibonacciBackoff.backoff();
```