Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9552CCCD184
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 19:02:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D95868E004C; Thu,  9 Oct 2025 15:02:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D46298E0002; Thu,  9 Oct 2025 15:02:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5BB18E004C; Thu,  9 Oct 2025 15:02:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B02DB8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 15:02:14 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5F47A140B0B
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 19:02:14 +0000 (UTC)
X-FDA: 83979496188.21.CFB9CA9
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf29.hostedemail.com (Postfix) with ESMTP id 57988120009
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 19:02:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iKpFldBH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760036532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tEZY6b9Il/bPIuUgXhNINbaf1qEh3uV81jyRdL6VxBg=;
	b=SvM8RignKwOqow8ClOriMbhtT19D8SKCU2jkvOCh8N0xnNUK9D8gXX9EDF+a3K9ZWwbXN6
	8+8vAgrsUju6U0SAbrhKYbLA9h1EiftdRixgtaE24GKGBwVQ1+qr9bQ2ulIrIt91NuHBqc
	QKdOoNF4cZ+TVQwKMXQVSSZdtRTQGnk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760036532; a=rsa-sha256;
	cv=none;
	b=qDwood2aIocIacTMaPJ8hRN44xPCVvbfWaczocZnHZxjbW0Tu27FUyqRzF2U5EVUyvSKmb
	x4b01C2XRfieviN0vLHoB7nO61pDvd0U92EkwLra0d2jPVWxIdrBtLSI3SbocmenkWeH8m
	HHhSR02sWgR/DLeexw05MnhjWjq3JqI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iKpFldBH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760036528;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tEZY6b9Il/bPIuUgXhNINbaf1qEh3uV81jyRdL6VxBg=;
	b=iKpFldBHyIIoqxe6JgGEDlkn6AJo8vprgXkgchWpTr+HDYbXIVn0Wo0bfG6Qj9Kx1si1qA
	dt5eDxW521POW0bcUPeN/UWnyHgbK7GLEwG1g3EPenu0oHvml/5Jc5SUsum/acZdSTrAH4
	pezT2MwlyiGTAisl7TC1BJF2YoEM34I=
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
In-Reply-To: <qdblzbalf3xqohvw2az3iogevzvgn3c3k64nsmyv2hsxyhw7r4@oo7yrgsume2h>
	(Shakeel Butt's message of "Thu, 9 Oct 2025 11:32:56 -0700")
References: <20251007125056.115379-1-daniel.sedlak@cdn77.com>
	<87qzvdqkyh.fsf@linux.dev>
	<13b5aeb6-ee0a-4b5b-a33a-e1d1d6f7f60e@cdn77.com>
	<87o6qgnl9w.fsf@linux.dev>
	<tr7hsmxqqwpwconofyr2a6czorimltte5zp34sp6tasept3t4j@ij7acnr6dpjp>
	<87a5205544.fsf@linux.dev>
	<qdblzbalf3xqohvw2az3iogevzvgn3c3k64nsmyv2hsxyhw7r4@oo7yrgsume2h>
Date: Thu, 09 Oct 2025 12:02:00 -0700
Message-ID: <875xcn526v.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 57988120009
X-Rspamd-Server: rspam02
X-Stat-Signature: ut8f9hfnj38zfa36nrn4wt1gq5ms87yr
X-HE-Tag: 1760036532-896587
X-HE-Meta: U2FsdGVkX18+6Tq/Fowg5R+bDgkYcip2r+0W3bpNs6mcfD1DpHY5iJJ3KUubVpmBab1D1fiyVJ0wqtF32vJVTlBIkvR0bKORY8VXI4XdQZ6zbyfN1F9ZcU2sJF/mKZx2DydRYMMSFgglNcQQLsaT04Nx/OlrKr9AxOFgPUMU7LE5LsCpl1LkDotZTMfxo5YCx/ovm9r7YmfkrDxmcfl9Lh2ypNeVMkGXduhZztE9rKwsPJ5pGgpd37u7qkn8fhNDZCxNojTLKBaWJQs4BHy5etx8nV9j9k+Bje4fODwDAgMVBeRDduTDLU/DE4PM6PpWePnbjeIE1Mz3N7OqmkzNRo6ZMwc0KD0r6R9jFUL3jwDNBLGW4v4nXDEAXTHluZ5Ab0a+tK1BzPNjIVs6iWHiF3DmwGiqdUEpMT8A1nIThr/Ev+81s1EnRTs2kLk3XqQdjA/wLQkCErbdVNaPTUUJNenvuWojO1k061xbonAVcMY+itWdK451JF6y7otCKJkRAB2NjONp2IAyAv5OUdS6V2jjVj0goAFOSOIhFyp7b+NsYBhW5J7ZW65KJYZR75CtEvMmOANZZVxrkcY88X8XqgRncMc9CbNoU6QdLVe2arURIWD9dS9/2jwTU95Y6qebGnQ9ZILdk80rmagz8oX7nXHcTGGMTl+wPYKO7LJne/JfqxE4Jfp/mo94PLd+N4tBcto1xlChZ8JfPjUP4VPGy32ixWGNGBHUnoV6w2JPuHcCthtt3OWTWYuI4i4hISbtg7wJM2gefmWzcOva+dpu9DVPgMXS72p+M/+8EhMtmDQxreCXTY9/V0ShkixSZ5sxaXdW1z2zV1GcFo3Upi3DcFwKpW+p8BQKTj4ee9PT8pAUR03wE5W/qIaI3Xa0Q7FPj0glZshV2ZT42pbjYVTI2bIs72Feg2IcFORlzl+BdhV9UJoLl2kVgUsAhR7WHLZf8Jv0nPhFYoIl3Iu2YqL
 KMK5naau
 UwMQBVze067+SvTnV3ZmPSwgWVGeZJ1OPymgX3ZqwzCYOgjiPCaXr+MoXknv4bzTXS9CCbWcH89gRrcGD03jYDQkrwPrOjeGwPHTuUqf9n2mmsnhhZ2ojEbJ+z9y71eQrYbBlBmKSvv8J3mtDtcPMYzJBjIWJ9OYL/HOEo+QTwn7ECG1EnnQmB3m/9hTomsf2eSBKtiMjcJzGniuoRfppUpqW2khnqcGKRME6PsXAK9jvudloTQV/dsP1zxaKwNJZRg8PxDVpDOjOFBAC6L79kTHTiQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Shakeel Butt <shakeel.butt@linux.dev> writes:

> On Thu, Oct 09, 2025 at 10:58:51AM -0700, Roman Gushchin wrote:
>> Shakeel Butt <shakeel.butt@linux.dev> writes:
>> 
>> > On Thu, Oct 09, 2025 at 08:32:27AM -0700, Roman Gushchin wrote:
>> >> Daniel Sedlak <daniel.sedlak@cdn77.com> writes:
>> >> 
>> >> > Hi Roman,
>> >> >
>> >> > On 10/8/25 8:58 PM, Roman Gushchin wrote:
>> >> >>> This patch exposes a new file for each cgroup in sysfs which is a
>> >> >>> read-only single value file showing how many microseconds this cgroup
>> >> >>> contributed to throttling the throughput of network sockets. The file is
>> >> >>> accessible in the following path.
>> >> >>>
>> >> >>>    /sys/fs/cgroup/**/<cgroup name>/memory.net.throttled_usec
>> >> >> Hi Daniel!
>> >> >> How this value is going to be used? In other words, do you need an
>> >> >> exact number or something like memory.events::net_throttled would be
>> >> >> enough for your case?
>> >> >
>> >> > Just incrementing a counter each time the vmpressure() happens IMO
>> >> > provides bad semantics of what is actually happening, because it can
>> >> > hide important details, mainly the _time_ for how long the network
>> >> > traffic was slowed down.
>> >> >
>> >> > For example, when memory.events::net_throttled=1000, it can mean that
>> >> > the network was slowed down for 1 second or 1000 seconds or something
>> >> > between, and the memory.net.throttled_usec proposed by this patch
>> >> > disambiguates it.
>> >> >
>> >> > In addition, v1/v2 of this series started that way, then from v3 we
>> >> > rewrote it to calculate the duration instead, which proved to be
>> >> > better information for debugging, as it is easier to understand
>> >> > implications.
>> >> 
>> >> But how are you planning to use this information? Is this just
>> >> "networking is under pressure for non-trivial amount of time ->
>> >> raise the memcg limit" or something more complicated?
>> >> 
>> >> I am bit concerned about making this metric the part of cgroup API
>> >> simple because it's too implementation-defined and in my opinion
>> >> lack the fundamental meaning.
>> >> 
>> >> Vmpressure is calculated based on scanned/reclaimed ratio (which is
>> >> also not always the best proxy for the memory pressure level), then
>> >> if it reaches some level we basically throttle networking for 1s.
>> >> So it's all very arbitrary.
>> >> 
>> >> I totally get it from the debugging perspective, but not sure about
>> >> usefulness of it as a permanent metric. This is why I'm asking if there
>> >> are lighter alternatives, e.g. memory.events or maybe even tracepoints.
>> >> 
>> >
>> > I also have a very similar opinion that if we expose the current
>> > implementation detail through a stable interface, we might get stuck
>> > with this implementation and I want to change this in future.
>> >
>> > Coming back to what information should we expose that will be helpful
>> > for Daniel & Matyas and will be beneficial in general. After giving some
>> > thought, I think the time "network was slowed down" or more specifically
>> > time window when mem_cgroup_sk_under_memory_pressure() returns true
>> > might not be that useful without the actual network activity. Basically
>> > if no one is calling mem_cgroup_sk_under_memory_pressure() and doing
>> > some actions, the time window is not that useful.
>> >
>> > How about we track the actions taken by the callers of
>> > mem_cgroup_sk_under_memory_pressure()? Basically if network stack
>> > reduces the buffer size or whatever the other actions it may take when
>> > mem_cgroup_sk_under_memory_pressure() returns, tracking those actions
>> > is what I think is needed here, at least for the debugging use-case.
>> >
>> > WDYT?
>> 
>> I feel like if it's mostly intended for debugging purposes,
>> a combination of a trace point and bpftrace can work pretty well,
>> so there is no need to create a new sysfs interface.
>> 
>
> Definitely not a new interface but I think having such information in
> memory.events or memory.stat would be more convenient. Basically the
> number of times the sockets in this memcg have to be clamped due to
> memory pressure would be useful in general.

Yeah, if we're going to add something, memory.events looks like the best
option, also because it allows to poll and get notified when the event
occurs.

