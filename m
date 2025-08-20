Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4465BCA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 10:39:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCA2D6B0122; Wed, 20 Aug 2025 06:39:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA2166B0123; Wed, 20 Aug 2025 06:39:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDECB6B0124; Wed, 20 Aug 2025 06:39:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AC8166B0122
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 06:39:33 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 527061DC316
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 10:39:33 +0000 (UTC)
X-FDA: 83796789426.26.B533CBC
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5BED7100005
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 10:39:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eci2odmY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755686371; a=rsa-sha256;
	cv=none;
	b=IHnfeqfaJjkhNnbB/XhO596NHtLn7DCOWUL8vL6kK22VozSk0MDHd+N+1qJ6wdO1Hodz0e
	9ApRZU1BKSbog1UKhrlG2oz19T41HSBPVNf2Abvr4qbO+1/8NVtfY8CNRKC1z7w+WiV1KH
	VYTvWLn9W6u9xpwqFPu/scB1lulJhMA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eci2odmY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755686371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0JEL0qQNPV6M/qOGIsQOAetnYYV4YPCbvB8NI4rcmrw=;
	b=oYCzadacgivQHR+xLAkD3soenxVg/wPZ+NDhCGcAKXDQxMhLk/bj+XaCPCBy4xPPVj2pjL
	YLOaOSh5S/YUUODkTU41C+O3bvUEWIomL+BL+GNOmpwPI3Pu0RfetHeiAvOjWghjzI6yTP
	82IZyKUpKnFPkBfo6xjwNaFIDLtzJdE=
Message-ID: <d9510f7c-c9a0-4ebe-87d5-19ad6a783121@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755686369;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0JEL0qQNPV6M/qOGIsQOAetnYYV4YPCbvB8NI4rcmrw=;
	b=eci2odmY5AvMvqAXli7nCNec0jkbmwDAhyukUUGK62nOaIEuwrgywZPdZcyNRvpAebM5+I
	9TJEGKYFlNJXi9+sIRDBTSFavKfrP3vtRrMG+Jz4nyHtAT3Bb+fexCktTxAKI5kHRGhm8H
	5OxSh3bIArxMHr6twIFrcXSObG+juGM=
Date: Wed, 20 Aug 2025 18:39:21 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] panic: Clean up message about deprecated 'panic_print'
 parameter
Content-Language: en-US
To: Petr Mladek <pmladek@suse.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 Linux Memory Management List <linux-mm@kvack.org>,
 Steven Rostedt <rostedt@goodmis.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-kernel@vger.kernel.org, paulmck@kernel.org, john.ogness@linutronix.de,
 kernel test robot <lkp@intel.com>, Feng Tang <feng.tang@linux.alibaba.com>
References: <aKRJKZHgcxyNF3y7@pathway.suse.cz>
 <202508200907.PsZ3geub-lkp@intel.com>
 <ae9bb2ea-c6e5-4a4b-ae25-aea1d6fe084d@linux.dev>
 <33a897b4-7d9a-4641-9c7a-07c19bb9cb6f@linux.dev>
 <7a34da58-874d-4271-9dbb-7991468d58ff@linux.dev>
 <aKWWcPOf9qPIoCe4@pathway.suse.cz>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <aKWWcPOf9qPIoCe4@pathway.suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 5BED7100005
X-Stat-Signature: ahwebjdqxkkfqjy67p6ot3zqu4qsg1ng
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755686371-193503
X-HE-Meta: U2FsdGVkX1/yxEMlXh79sACYPcQgNX94LzJrlX3yfWjWNJdL7Cbkb9ODzXEGAdOHJFr3gv4nIj6O0XzqXXhlGcwQdXBMoILnILavJAOEsB5QcREv9kxBOsemo9zKViAs+cA4IGG9GXSpCSuZW2u4+vGgcwCoTqqjzbY7AnqMC4I24das9uY+3fn9DfaXel+jR7ozSIJGVBMjKX6q4zpKuY6s5LwlhTwTJh4aHs23AYvNedKzvSLpFUsCP/zvumBw5kruUiiooxD88jvN3rOcKL+5Lh5lJzDBqbOIacWX15g1eNPUHSM/1ggNvV2bMUgw7suUnGkOjlpqsfJwDt4Vb8XKbNxDAx86dYWYL0yPVweG8m5e9DkGY2IxksyQH5iRVLCLBYsuuno/4wWdXSIkSP9ebIgIPVo5mmYToMZKBnm9I+yGdRruwsf2WmiVcl0hpHqlAToWtNljli/YttTA+RF91pOUPcCycaPOUNTbRlxf6Mb7MWaN1f+vmsj5lvHpKZoCOffFtslEsFBvZixvAk2csH9cpfMkFC55oDFub6aH5j4mVrHPB6fHrh0n5ExBxWbFLZ5WCJI8RLlCEELUb+T8sj4YBHIY2MHnc3nq4GKL6luNDpkLtVDX4dZx6JmyDa/b7Yrxk0vg1mHRcj9VfcKnwo/UPmoUwdDefF5OXAGvEPhrn9HuZiBimN+DDhgBGZpa7mU4CF5iyFQWPSaddGpgnVUg6ybE3wo21otv6xAoa8ijrhj5ZOlCZ+Zjv76sAFxly4ePJoYFsrwluZgtgdGY/P4vMx41Ik7FsUmgjA9k9WhGdVyNOkPAqzbBuuRgu9cHMx4OrLB9ZzRrmMf5dBB4bvoc7+AH/7hPGTqzRhheBhtb8q4N/tjrAhcQJ2wmfSsXV1ihR2UklH8vn/MClo7mCzsegADyu2BOp9BOLL14HYeneiqt5bUilMvT3AXRtxC59arCXnDNwPZ0VFj
 iHYowtLR
 WakS8f4KP5gfjbIFCrNjKWD6wvbuXIiz06Ee4wLAAbX4JlB9o/wIhdfU5yTCcCV1//Sz5UoTYVpC3sK47bYCpdNAaBTPoB96D+wqTRZNPx/G8SysJDP/gMozcHUxQNB91MDbqjrBqbgPhdj4cWO/V5yX1AgE7AmAiYrzyjflk8cTG4JtXmd5CQ3d9kHZvk9ORw7rwhtf0orGpFESY7wdf8lOOeS4ItzhZ2znBE32HuCJhnH6DbZAwwe9qon8ATYeiqy9aInhb/lpm9Eg0mUm335sNKg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/8/20 17:33, Petr Mladek wrote:
> On Wed 2025-08-20 16:57:48, Lance Yang wrote:
>> On 2025/8/20 09:56, Lance Yang wrote:
>>> On 2025/8/20 09:54, Lance Yang wrote:
>>>> On 2025/8/20 09:31, kernel test robot wrote:
>>>>> All errors (new ones prefixed by >>):
>>>>>
>>>>>>> kernel/panic.c:952:2: error: call to undeclared function
>>>>>>> 'panic_print_deprecated'; ISO C99 and later do not
>>>>>>> support implicit function declarations
>>>>>>> [-Wimplicit-function-declaration]
>>>>>        952 |         panic_print_deprecated();
>>>>>            |         ^
>>>>>      kernel/panic.c:958:2: error: call to undeclared function
>>>>> 'panic_print_deprecated'; ISO C99 and later do not support
>>>>> implicit function declarations [-Wimplicit-function-declaration]
>>>>>        958 |         panic_print_deprecated();
>>>>>            |         ^
>>>>>      2 errors generated.
>>>>
>>>>
>>>> Oops, panic_print_deprecated() is defined within the #ifdef
>>>> CONFIG_PROC_SYSCTL block, but it's also called from panic_print_set()
>>>
>>
>> If Petr is cool, @Andrew could you squash the following?
>>
>> ---
>> Subject: [PATCH 1/1] fixup: panic: clean up message about deprecated
>>   'panic_print' parameter
> 
> The patch was malformed probably by your mail client.
> Below is the fixed and revied variant.

Yes. My client messed up the formatting - git send-email it is ;)

Thanks,
Lance

