Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5022DCCD184
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 17:59:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A48068E00A3; Thu,  9 Oct 2025 13:59:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F87A8E0010; Thu,  9 Oct 2025 13:59:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E6E88E00A3; Thu,  9 Oct 2025 13:59:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7B36D8E0010
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 13:59:04 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3351AB72BE
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 17:59:04 +0000 (UTC)
X-FDA: 83979337008.18.B754955
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5C47D40005
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 17:59:02 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=brCnqSu9;
	spf=pass (imf11.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760032742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/LjspjRAg7UFQe7nc1ChhpN/Yf6KjTCzKdSwL9hxGYw=;
	b=ieYxd9cK7o5hOin6zXDKx6UiWz+xRzY0Gw6znHgGbC7C6yVLrStC6HEjk2rAcPmysUnPBW
	GBWORTCKlP775VTCZqV5jQp4le9rXsvR+jMVFCxgctxQJVvF/Xfe5gz9yhGejoPhzfzMM0
	34s3NCPMNgpAAOyX2Dn0RYX5K2GuJSQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=brCnqSu9;
	spf=pass (imf11.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760032742; a=rsa-sha256;
	cv=none;
	b=Enm+p1I3xv5LSoD+BwrXyvK74fIqkHEum2v60k7tOeJubv1OtyHW9g/tS3sSd0RbCddDdV
	Zn084XuepIcXzde/dupubFlhWbrJDRP44eBtXeee1cps/rMY2+X3B9wV2TtbgmucB/igrQ
	lGvBogImd+nTyvtjpDJqgJ9pC7za90I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760032740;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/LjspjRAg7UFQe7nc1ChhpN/Yf6KjTCzKdSwL9hxGYw=;
	b=brCnqSu9VGHT/fqGA/etX42LAH8RMi97BzTQX1ZjtyFYtW6GOyWeZ+wGb2YEtlGBv6H3Bl
	XYJ3EXWAoposyXg6l44USDV3nGpuzuqGmgcv6+YgqJLf9ZWRVe1iRr0f4pj4w8Ez7DC9Dw
	YCmA0inAJt2DGY6aumLG9v0/vUhRasw=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Daniel Sedlak <daniel.sedlak@cdn77.com>,  "David S. Miller"
 <davem@davemloft.net>,  Eric Dumazet <edumazet@google.com>,  Jakub
 Kicinski <kuba@kernel.org>,  Paolo Abeni <pabeni@redhat.com>,  Simon
 Horman <horms@kernel.org>,  Jonathan Corbet <corbet@lwn.net>,  Neal
 Cardwell <ncardwell@google.com>,  Kuniyuki Iwashima <kuniyu@google.com>,
  David Ahern <dsahern@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Yosry Ahmed <yosry.ahmed@linux.dev>,
  linux-mm@kvack.org,  netdev@vger.kernel.org,  Johannes Weiner
 <hannes@cmpxchg.org>,  Michal Hocko <mhocko@kernel.org>,  Muchun Song
 <muchun.song@linux.dev>,  cgroups@vger.kernel.org,  Tejun Heo
 <tj@kernel.org>,  Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>,
  Matyas Hurtik
 <matyas.hurtik@cdn77.com>
Subject: Re: [PATCH v5] memcg: expose socket memory pressure in a cgroup
In-Reply-To: <tr7hsmxqqwpwconofyr2a6czorimltte5zp34sp6tasept3t4j@ij7acnr6dpjp>
	(Shakeel Butt's message of "Thu, 9 Oct 2025 09:06:13 -0700")
References: <20251007125056.115379-1-daniel.sedlak@cdn77.com>
	<87qzvdqkyh.fsf@linux.dev>
	<13b5aeb6-ee0a-4b5b-a33a-e1d1d6f7f60e@cdn77.com>
	<87o6qgnl9w.fsf@linux.dev>
	<tr7hsmxqqwpwconofyr2a6czorimltte5zp34sp6tasept3t4j@ij7acnr6dpjp>
Date: Thu, 09 Oct 2025 10:58:51 -0700
Message-ID: <87a5205544.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: jix5jtzafutysyp7gfmb7znr3kfc1fzc
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5C47D40005
X-HE-Tag: 1760032742-739769
X-HE-Meta: U2FsdGVkX18XtLLDYKQPIK5ki/RN69c1YnYjqqkxx05xlHjhyQGcOlwTu52Ll4aCnH94QBoJNkaFgAldMFrnsP1Jw5rBSfsSMfxR7zDMlVG+FHiw12EZo6SHzlw0LSTo7ZmlnjzCdsoP7ObWOAA2YoXWZr04Bu3U6/9UVzLY8GS7Y2Ukn/WpxzfU4zye6kUJJk6f4rs7kLXyaDEZ9ZFiVg/KHnDf6cV95bZgxKtANQl6aY99vKCx7WheIm4Zhy7U77ZX0Iep5psuDLn44d6uHyUHI3vXEfoCzfDodSLOtH9Fa1uiashS9Rv01uz4Oddmrg3SkleGBrnhPnG23yM2kd3VhYixdXSwtEdYJpnD4sT3VqswJFizMKHNdLTLcSt4FWgkYE6ho9pFSSVVe5Q7F36mnSE2N9UyQ9Rzr9espAGm53OXW9dP/YUnauZoetIgY/XZuFMYQL8fgWsBJehNjT4QQKaEDQmrs1rUEHuTQwuBhhOZvEEvOmaTJFkloEYTB49rewqOf2E39G252N9cwfBm21I/V312HhKPoxYKuSp4RYRZ0W1ADAiAaYpHkZ56F8vXW/psXnULXPAeCbeSf6nt1CFH75hLuQ3md+AToZMQJqVvMaugx+K7RbxFGtrJJg2WhLEhjoM8LmFq6oO2kRovvRrFuTYP43SV6adzIeQTFA3sDkzCKMqHCDHqxrjZTpvrKAPkyS4xfufGTtarO/JSXmu0RI7Tyn9H5a/ZTmPrQ5TNN0iaeIodNyK9M5az0AG34MLbBme3BnWxABtSVoZXEvFGk5QUWSVWO0E5PF/tL9ZFXY4GMXAbNrQxzE8j6nuh5O8m69LHEoBC1mjm+AKTxlkitNO3MBaIvCUOclCmGFbXrMB8g2ge3Ik19blApHmaIMQ/5TVqrU+M6TaDLfmBMv8dOTNyetCvV3FkHGKDBwVxNjk91G6oZ0e2S4yDEtp3P0l41djiArAHjdU
 CWyY3u5Z
 izd5ytTLimqGRANAG9prwzn7hw8XLeIW6BFzyi56v8Fy/RsbHuG1XOu3x0/zQoN8D50o1LY0maywP4eO+COfRXO0Ucli7loJt8yznxU9UKe3SvyrxFJqdiFw72w2tja8DJG3JMk1Z2yaxUHEF1ZBAekTd6Bf2ywsFfuUur8XeuxCcp1y5vNkZAYD9vu2/NNv96m8JYY4SUciopHHwX0dyUqKIB9V2C/FOwdLZ7BT+Ssq50qGN/uD9Up4omGTSDJClTpYmwgEKRQaVHGDTglUFqFAqBQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Shakeel Butt <shakeel.butt@linux.dev> writes:

> On Thu, Oct 09, 2025 at 08:32:27AM -0700, Roman Gushchin wrote:
>> Daniel Sedlak <daniel.sedlak@cdn77.com> writes:
>> 
>> > Hi Roman,
>> >
>> > On 10/8/25 8:58 PM, Roman Gushchin wrote:
>> >>> This patch exposes a new file for each cgroup in sysfs which is a
>> >>> read-only single value file showing how many microseconds this cgroup
>> >>> contributed to throttling the throughput of network sockets. The file is
>> >>> accessible in the following path.
>> >>>
>> >>>    /sys/fs/cgroup/**/<cgroup name>/memory.net.throttled_usec
>> >> Hi Daniel!
>> >> How this value is going to be used? In other words, do you need an
>> >> exact number or something like memory.events::net_throttled would be
>> >> enough for your case?
>> >
>> > Just incrementing a counter each time the vmpressure() happens IMO
>> > provides bad semantics of what is actually happening, because it can
>> > hide important details, mainly the _time_ for how long the network
>> > traffic was slowed down.
>> >
>> > For example, when memory.events::net_throttled=1000, it can mean that
>> > the network was slowed down for 1 second or 1000 seconds or something
>> > between, and the memory.net.throttled_usec proposed by this patch
>> > disambiguates it.
>> >
>> > In addition, v1/v2 of this series started that way, then from v3 we
>> > rewrote it to calculate the duration instead, which proved to be
>> > better information for debugging, as it is easier to understand
>> > implications.
>> 
>> But how are you planning to use this information? Is this just
>> "networking is under pressure for non-trivial amount of time ->
>> raise the memcg limit" or something more complicated?
>> 
>> I am bit concerned about making this metric the part of cgroup API
>> simple because it's too implementation-defined and in my opinion
>> lack the fundamental meaning.
>> 
>> Vmpressure is calculated based on scanned/reclaimed ratio (which is
>> also not always the best proxy for the memory pressure level), then
>> if it reaches some level we basically throttle networking for 1s.
>> So it's all very arbitrary.
>> 
>> I totally get it from the debugging perspective, but not sure about
>> usefulness of it as a permanent metric. This is why I'm asking if there
>> are lighter alternatives, e.g. memory.events or maybe even tracepoints.
>> 
>
> I also have a very similar opinion that if we expose the current
> implementation detail through a stable interface, we might get stuck
> with this implementation and I want to change this in future.
>
> Coming back to what information should we expose that will be helpful
> for Daniel & Matyas and will be beneficial in general. After giving some
> thought, I think the time "network was slowed down" or more specifically
> time window when mem_cgroup_sk_under_memory_pressure() returns true
> might not be that useful without the actual network activity. Basically
> if no one is calling mem_cgroup_sk_under_memory_pressure() and doing
> some actions, the time window is not that useful.
>
> How about we track the actions taken by the callers of
> mem_cgroup_sk_under_memory_pressure()? Basically if network stack
> reduces the buffer size or whatever the other actions it may take when
> mem_cgroup_sk_under_memory_pressure() returns, tracking those actions
> is what I think is needed here, at least for the debugging use-case.
>
> WDYT?

I feel like if it's mostly intended for debugging purposes,
a combination of a trace point and bpftrace can work pretty well,
so there is no need to create a new sysfs interface.


