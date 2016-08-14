---
id: 17
title: Extension development in firefox and chrome
date: 2016-04-09T11:17:31+00:00
author: Ramkumar K R
layout: post
guid: https://blog-ramkumarkr.rhcloud.com/?p=5
permalink: /2016/04/09/extension-development-in-firefox-and-chrome/
original_post_id:
  - 5
  - 5
categories:
  - Tech
tags:
  - Chrome
  - Firefox
---
I developed an extension in both chrome and firefox which provides a new tab page resembling a speed dial. I&#8217;ll just highlight the advantages and disadvantages of development in both the browsers.

* * *

##  Chrome

#### Advantages

  * Chrome has a very good [documentation](https://developer.chrome.com/extensions/api_index) and [tutorials](https://developer.chrome.com/extensions/getstarted) having a step by step explanation for a few [examples](https://developer.chrome.com/extensions/samples) as well.
  * Since the APIs were based on javascript, no more additional learning was required to start.
  * Testing or Trying out the extension in chrome on Mac or Linux is pretty simple as well. 
      1. Go to chrome://extensions and enable developer preview
      2. Click on the Load unpacked extension and select the folder having the extension code
      3. Your extension is now loaded to the browser
  * Google Analytics works very well with the extension
  * Publishing updates to your extension is hassle free and all your users are updated to the latest version within a few minutes
  * Ability to have the extensions paid and can be a source of income.
  * An extension written for chrome will work in chromium and is most likely to work in opera , vivaldi and other chromium based browsers as well.

#### Disadvantages

  * An amount of **$5.00** needs to be paid to google for publishing your first app or extension on the chrome web store.
  * Trying out the extension in a developer mode in Windows with a stable version of chrome can be very annoying  since chrome asks you to disable the extension every time the browser is opened.
  * Stable versions of chrome on Windows  disables all the extensions which are not from the chrome web store. These extensions cannot be enabled again either manually or using an API. You can read more about it in [here](http://www.howtogeek.com/191364/how-do-you-re-enable-non-web-store-extensions-in-the-stable-and-beta-channels-of-chrome/).
  * There is a cap of 20 apps/extensions/themes (combined) which can be published to the chrome web store. If you want to publish more, you need to get an approval from google for this.

&nbsp;

* * *

## Firefox

#### Advantages

  *  No payment required to publish the addon
  * Very easy to translate a chrome extension to a firefox addon. Only the manifest file format needs to change
  * Testing, building and trying out the extension in any operating system is possible
  * Extensive libraries for customization options which can change the entire look and feel of the browser.
  * No cap on the number of extensions you can release to the add on store
  * Ability to distribute the extension outside the addon store

#### Disadvantages

  * Each review takes about a week to complete
  * Multiple libraries can be used to implement a single functionality. For example, the new tab page can be overriden either by XUL or by using the new tab override API provided by firefox
  * Poor or no documentation for the libraries
  * Accessing external scripts from the extension is not allowed. This would require you to have all the library scripts ( such as jquery) as a part of your add on therby increasing the addon size
  * Dwindling user base&#8230;..The number of users for firefox is going down in the past few months. This forces me to think if the effort required for writing an extension is worthy or not
  * No Pricing &#8211; You can request for users to donate some amount for the development and maintainence of the addon. This has discouraged many companies to create addons for firefox

* * *

###  Footnotes

  * All the points are classified under advantage/disadvantage are purely in my opinion
  * In case you want to try out my extension, you can find the links below
  * Chrome &#8211; <https://chrome.google.com/webstore/detail/new-tab/dbnbjnjckidjkjdocfflalcgmlhkcfee>
  * Firefox &#8211; [https://addons.mozilla.org/en-US/firefox/addon/yet-another-new-tab-page/?src=search](https://addons.mozilla.org/en-US/firefox/addon/yet-another-new-tab-page/)

&nbsp;

&nbsp;