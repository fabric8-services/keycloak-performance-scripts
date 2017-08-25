# keycloak-performance-scripts


We used three different tools to evaluate the performance behavior of some of
the main Keycloak API endpoints. The tools are:

* [Hey](https://github.com/rakyll/hey)
* [Vegeta](https://github.com/tsenart/vegeta)
* [WRT](https://github.com/wg/wrk)

We suggest to use Vegeta although the other tools can provide some metrics that
are missing in Vegeta.

Note: you can also find some scripts used to test endpoints, generate reports
or to obtain offline tokens.

## Run

### Hey scripts

It runs a test with 10, 100 and 1000 connections respectively for each of these
three iterations. Each requests sets 1, 10 and 1000 concurrent requests for
each iteration.

This script runs two benchmark operations:
- 1) Test the access token operation
- 2) Test the entitlement endpoint

To run this test, you just simply type this command. Note that, you need to update
the variables used in this script.

`$./hey_scripts/hey_kc_perf.sh `

In the following, we show an example of the result of the benchmark that tests the access token:

```
Getting access token...
10
1 requests done.
2 requests done.
4 requests done.
6 requests done.
8 requests done.
All requests done.

Summary:
  Total:        3.4762 secs
  Slowest:      0.6522 secs
  Fastest:      0.2417 secs
  Average:      0.3475 secs
  Requests/sec: 2.8767
  Total data:   38690 bytes
  Size/request: 3869 bytes

Detailed Report:

        DNS+dialup:
                Average:        0.0207 secs
                Fastest:        0.0000 secs
                Slowest:        0.2067 secs

        DNS-lookup:
                Average:        0.0098 secs
                Fastest:        0.0000 secs
                Slowest:        0.0978 secs

        Request Write:
                Average:        0.0001 secs
                Fastest:        0.0000 secs
                Slowest:        0.0002 secs

        Response Wait:
                Average:        0.3267 secs
                Fastest:        0.2414 secs
                Slowest:        0.6521 secs

        Response Read:
                Average:        0.0001 secs
                Fastest:        0.0001 secs
```

### Vegeta scripts

To run this test, you just simply type this command. Note that, you need to update
the variables used in this script.

`$./vegeta_scripts/vegeta_kc_perf.sh `

This script runs four internal benchmarks:
- 1) Test the user info endpoint
- 2) Test the github token
- 2) Test to refresh the access token
- 3) Test the entitlement endpoint

These benchmarks are configured to run benchmarks with a rate of 250, 300, 350, 400, 450 and 500 requests per second. Consequently, each benchmark runs 6 iterations during a maximum of 120 seconds for each iteration.

Note that, these benchmarks run with a 300 seconds sleep time in between them to cool down the targeted keycloak instance. Moreover, this test uses two files `targets` and `body.json` to perform the bencharks. These files are automatically updated to target a different API endpoint with a specific body request.

In the vegeta directory, there is a script that creates reports out of the `.bin`
files that vegeta generates for each iteration. To run, these files has to be located in the same directory where this script lives.

```
Requests      [total, rate]            300, 10.03
Duration      [total, attack, wait]    30.032670403s, 29.899999694s, 132.670709ms
Latencies     [mean, 50, 95, 99, max]  135.253703ms, 120.603945ms, 215.038853ms, 406.047471ms, 700.119535ms
Bytes In      [total, mean]            476400, 1588.00
Bytes Out     [total, mean]            15000, 50.00
Success       [ratio]                  100.00%
Status Codes  [code:count]             200:300
Error Set:
```

### Wrk scripts

To run this test, you just simply type this command. Note that, you need to update
the variables used in this script.

`$./wrk_scripts/wrk-kc-test.sh `

This script runs two benchmarks:
- 1) Test the access token operation. The access token test runs 10 concurrent connections with 1 thread during 10 seconds.
- 2) Test the entitlement endpoint. The entitlement test runs 400 concurrent connections with 12 threads during 60 seconds.
