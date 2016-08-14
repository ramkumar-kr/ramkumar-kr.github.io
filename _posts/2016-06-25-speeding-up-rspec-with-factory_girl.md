---
id: 46
title: Speeding up Rspec with factory_girl
date: 2016-06-25T17:48:02+00:00
author: Ramkumar K R
layout: post
guid: https://blogkrr.wordpress.com/?p=46
permalink: /2016/06/25/speeding-up-rspec-with-factory_girl/
categories:
  - Tech
tags:
  - RSpec
---
I use `rspec` and `factory_girl` in my organization for writing unit tests. However, it used to be very very slow. I took some steps to speed it up.

## Using `build_stubbed` instead of `build` or `create` for creating objects using factories as much as possible

Using `build_stubbed` builds factories and stubs all associations for the object. There were a lot of specs which could use the `build_stubbed` method instead of `create` or `build` for creation/building of objects from factories. This resulted in a non-requirement of a database connection and neccesity to create associated objects which sped up the tests by about 55-60%.  For more details you can refer to the link &#8211;  <a href="http://here" target="_blank">https://robots.thoughtbot.com/use-factory-girls-build-stubbed-for-a-faster-test</a>

## Using an in-memory database

Database was a considerable bottleneck for the performance of our tests. This is a common scenario which happens either due to a slow disk or due to a large number/complexity (or both) of queries being executed.

To solve this problem, I used the `memory_test_fix`  gem which uses the sqlite3 database adapter and uses your memory as the database. This sped up the tests by about 18-20%.

Github link &#8211; <a href="https://github.com/mvz/memory_test_fix" target="_blank">https://github.com/mvz/memory_test_fix</a>

## Running multiple tests at once

Tests run only in a single process and results in under utilizing the processor (which is usually dual or quad core). Running multiple processes to run tests in parallel resulted in a much shorter duration than running them sequentially.

I used the `parallel_tests` gem and ran tests with 4 processes. This resulted in reducing the duration  by approximately 2.5-3 times. (This should have ideally been 4 times but since I had a lot of applications running the performance obtained is less).

Github Link &#8211; <a href="https://github.com/grosser/parallel_tests" target="_blank">https://github.com/grosser/parallel_tests</a>

## Results

I had a test suite containing 100 unit tests. build_stubbed was used for only 4 tests (I should have done this for atleast 40 and ran the tests). Making improvements one by one on the same suite reduced the overall execution time from 20 minutes to 6 minutes. Here&#8217;s a Before-After table containing execution times (rounded to the minute).

| Improvement Done |   Before |   After |
|------------------|----------|---------|
| Using `build_stubbed` for 4 out of 100 tests | 20 minutes | 19 minutes |
| Using an in-memory database | 19 minutes | 16 minutes |
| Using `parallel_tests` gem with 4 processes | 16 minutes | 6 minutes |