Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37602CCD185
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 01:44:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C9DD8E002A; Mon, 13 Oct 2025 21:44:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37A018E0007; Mon, 13 Oct 2025 21:44:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2425E8E002A; Mon, 13 Oct 2025 21:44:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 09F8A8E0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:44:02 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 86296C069A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 01:44:01 +0000 (UTC)
X-FDA: 83995023882.25.3FDD1FD
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf16.hostedemail.com (Postfix) with ESMTP id C7769180005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 01:43:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="FTfxEID/";
	spf=pass (imf16.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760406240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vO/ZDB4TMtmLh64kPiFotXh5bUAaUBwq3BsPKySjreM=;
	b=tRKqh0Q4xC+IaBFpOhF7DAiv5jQdvKKdyH1fCqZCdSFT920ODqX9HwYrpX8chPySz5iOxr
	wy8Uq6Wpg4lcaBasHhCI8IabAFZgtEef0rxP8epcK36pkCHJ9+Dlx5E1CiVlOb/xrDHCyG
	s/5zrZVxF4ITI17j7vfb/pKWWtwrrLY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="FTfxEID/";
	spf=pass (imf16.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760406240; a=rsa-sha256;
	cv=none;
	b=iQbYoMbppy10iaEuJY0UfHP//5QQ9BCN3U4cCTogRBuygwuAShjCQFvgHOGzFzTDMHhNFi
	6oz7wtlDE76yrVDCTP8OMBqxQzqJUICYK5dTkP98TMmbG2i40IhF8sTsVmvwVRYr5qKRGA
	iZEgtixidkQ1ODcJfrqIxvIRtTw3sR8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760406237;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vO/ZDB4TMtmLh64kPiFotXh5bUAaUBwq3BsPKySjreM=;
	b=FTfxEID/GkjBTTNzzbc45gGoh12Ba6wQqrzY/bO5nzi4cY4mfksqWw34ZkxG1aUz4cnX5l
	taZo3/Bi+V1OBjRFo9bvgPqAb9tbY0t0Dknl/C/QBjFoIbPjxAIWONbpk1/ahMJVoCvZBq
	INPVlegL1EDnAvlD6y6JwifiV1O529E=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Daniel Sedlak <daniel.sedlak@cdn77.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,  "David S. Miller"
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
In-Reply-To: <89618dcb-7fe3-4f15-931b-17929287c323@cdn77.com> (Daniel Sedlak's
	message of "Mon, 13 Oct 2025 16:30:53 +0200")
References: <20251007125056.115379-1-daniel.sedlak@cdn77.com>
	<87qzvdqkyh.fsf@linux.dev>
	<13b5aeb6-ee0a-4b5b-a33a-e1d1d6f7f60e@cdn77.com>
	<87o6qgnl9w.fsf@linux.dev>
	<tr7hsmxqqwpwconofyr2a6czorimltte5zp34sp6tasept3t4j@ij7acnr6dpjp>
	<87a5205544.fsf@linux.dev>
	<qdblzbalf3xqohvw2az3iogevzvgn3c3k64nsmyv2hsxyhw7r4@oo7yrgsume2h>
	<875xcn526v.fsf@linux.dev>
	<89618dcb-7fe3-4f15-931b-17929287c323@cdn77.com>
Date: Mon, 13 Oct 2025 18:43:45 -0700
Message-ID: <87h5w2w94e.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: C7769180005
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: afkaoghycw6u68t8qod1d7fmfe57bj3y
X-HE-Tag: 1760406239-617105
X-HE-Meta: U2FsdGVkX1/5ZwThtRXu1V56GhwVfRPEAKhDb+stu+ujnfbkODfnVJBuuC97AgOgZ50CmipW1YgXsxBlmN3RB+P9WBLUgvYo1k5okcTwHJf4OVXv6sri8H9sOuPJg4qNVIrKR58y5g99etg0RcbYPqe4viqeEKha4LNu4wzOekWXJvcb0GbtumWm0uP9d2IddIHs2qy6TlB1MtQQsDqr9IOCcaIBzBmN9aitdCKGWMxu2+Ji2ZhgcjOo9Yos8ovImF75E5Y1onuVJo/5GxVh/L3AQ1xbnIgHfbHwKwp5chKKnhlAH2QERb5XA3OCrYxQY7UummI9cOKTX0dQyylgy7bsvWa5a3Ap42QmaxE8aB+qQIMzfZgdbJRR40rF9UaTc6tiMmCQMJJVmeUqFHxCo0LmezZZCnT5UnAD6AmQVwwSgUisEH6Qxd9b0bwEcJt2lKLSjYqKu0rUP6jj7Zg7ihoTT1pz74mXUN1N1fCs95Qvt37JUsWoUoFZ+ybkvsnv5XcKsPagZbYQ2BErrcGLojItXYeZqsnM7GB2Q8x+OAhJEisIWhdNSzJkpo+CAj4SlelV0mSuMY/8jbwzN5wcWm02KBYld88lw29kzS5jBxacJvueAaQVFc2oLcDI67F4tfxAZOlcsDvxWr2cYfFRaSSxLMXmQ7gg6558G6PqVcVXiseO13K9faKhqs7YOfEbZNrnpco33+WsYEGcINA6swKQ0sY0ZV2AWxo2303YAnbLuTowi8IalflppT1U3EU/W2PEx1Wm+vmIrF9PW2fHEwPL3AYZHT1qvrnvfTS2RJOSj7cNKHKY0paEZnF/2U+AU8tS23+inpy5JZastm/GY+hAvjIG5Vw+zRBMuCnCK84o6MuZK2s0OcaCZb56T0bdlo7/vdGb+Ke9AK03NQg/qYSry/I1/rIMcE67WgMZWslE/FZa3NY3CZXDXlTuNgM64K+Igww98+a9fYSVrfh
 EXN59g2b
 V7RDDVgDWpXD7iU9suK0WyBfmPYjwFkIkWL8/nqtU69rUapQjcaF5yOeV3nPXJiG+nwxeNdisahi/ZHlr5kf6V8UMabP4AUadmOvbCUTRlIGPSH9U3jpS6kBeVKY5LWh3Lq7mDwCSKVYPg4TSAZ59igi4nOEzkW6v/dSP9VGbQYoefwtNbB6nyCkoi4eXeSIu+l9LPQb/BY84IenxyQzUL2uTfS5S0BsWDS0xrgexv3fWHGeeGKrxsaDeXWdimInzOWVEQvzIwU21JfXtHwTXtadZuQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Daniel Sedlak <daniel.sedlak@cdn77.com> writes:

> On 10/9/25 9:02 PM, Roman Gushchin wrote:
>> Shakeel Butt <shakeel.butt@linux.dev> writes:
>> 
>>> On Thu, Oct 09, 2025 at 10:58:51AM -0700, Roman Gushchin wrote:
>>>> Shakeel Butt <shakeel.butt@linux.dev> writes:
>>>>
>>>>> On Thu, Oct 09, 2025 at 08:32:27AM -0700, Roman Gushchin wrote:
>>>>>> Daniel Sedlak <daniel.sedlak@cdn77.com> writes:
>>>>>>
>>>>>>> Hi Roman,
>>>>>>>
>>>>>>> On 10/8/25 8:58 PM, Roman Gushchin wrote:
>>>>>>>>> This patch exposes a new file for each cgroup in sysfs which is a
>>>>>>>>> read-only single value file showing how many microseconds this cgroup
>>>>>>>>> contributed to throttling the throughput of network sockets. The file is
>>>>>>>>> accessible in the following path.
>>>>>>>>>
>>>>>>>>>     /sys/fs/cgroup/**/<cgroup name>/memory.net.throttled_usec
>>>>>>>> Hi Daniel!
>>>>>>>> How this value is going to be used? In other words, do you need an
>>>>>>>> exact number or something like memory.events::net_throttled would be
>>>>>>>> enough for your case?
>>>>>>>
>>>>>>> Just incrementing a counter each time the vmpressure() happens IMO
>>>>>>> provides bad semantics of what is actually happening, because it can
>>>>>>> hide important details, mainly the _time_ for how long the network
>>>>>>> traffic was slowed down.
>>>>>>>
>>>>>>> For example, when memory.events::net_throttled=1000, it can mean that
>>>>>>> the network was slowed down for 1 second or 1000 seconds or something
>>>>>>> between, and the memory.net.throttled_usec proposed by this patch
>>>>>>> disambiguates it.
>>>>>>>
>>>>>>> In addition, v1/v2 of this series started that way, then from v3 we
>>>>>>> rewrote it to calculate the duration instead, which proved to be
>>>>>>> better information for debugging, as it is easier to understand
>>>>>>> implications.
>>>>>>
>>>>>> But how are you planning to use this information? Is this just
>>>>>> "networking is under pressure for non-trivial amount of time ->
>>>>>> raise the memcg limit" or something more complicated?
>
> We plan to use it mostly for observability purposes and to better
> understand which traffic patterns affect the socket pressure the most
> (so we can try to fix/delay/improve it). We do not know how commonly
> this issue appears in other deployments, but in our deployment, many
> of servers were affected by this slowdown, which varied in terms of
> hardware and software configuration. Currently, it is very hard to
> detect if the socket is under pressure without using tools like
> bpftrace, so we would like to expose this metric in a more accessible
> way. So in the end, we do not really care in which file this "socket
> pressure happened" notification will be stored.
>>>>>> I totally get it from the debugging perspective, but not sure about
>>>>>> usefulness of it as a permanent metric. This is why I'm asking if there
>>>>>> are lighter alternatives, e.g. memory.events or maybe even tracepoints.
>
> If the combination of memory.events(.local) and tracepoint hook(s) is
> okay with you(?), we can use that and export the same information as
> in the current patch version. We can incorporate that into the next
> version.

In my opinion
tracepoint > memory.events entry > memory.stat entry > new cgroupfs file.

>
> Also, would it be possible to make the socket pressure signal
> configurable, e.g., allowing it to be configured via sysctl or per
> cgroup not to trigger the socket pressure signal? I cannot find the
> reasoning why this throttling cannot (maybe it can) be opt-out.

It's a good point.

First, I think that vmpressure implementation is not the best
and we might want to switch to PSI (or something else) there.
This is why I'm resistant to exposing implementation-specific
metrics.

That said, I believe that some level of customization here is justified.
Maybe opting out completely is too much, but in the end it's hard for
the kernel to balance the importance of e.g. page cache vs networking
buffers as it might be really workload-dependent. Or some workloads
would prefer to risk being oom-killed rather than to tolerate a sub-par
networking performance.

Thanks!

