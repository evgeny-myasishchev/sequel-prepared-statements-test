Sequel & Postgres prepared statement issue
===================================

Test to demonstrate sequel issue when working with prepared statements and binary data using postgres. On SQLite it works fine. Other databases wasn't tested.

Tested using:

* sequel 4.16.0
* pg 0.17.1
* PostgreSQL 9.3.5 on x86_64-apple-darwin13.4.0, compiled by Apple LLVM version 6.0 (clang-600.0.51) (based on LLVM 3.5svn), 64-bit
* ruby 2.1.2p95 (2014-05-08 revision 45877) [x86_64-darwin13.0]

Install deps: ```gem install sequel pg```

Run the test: ```ruby test.rb```

The test does following:

1. Prepare binary data (bytes from 0 to 255)
2. Insert using DataSet#insert
3. Select and compare
4. Insert using prepared statement
5. Select and compare
