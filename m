Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBB0CCCD184
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 18:33:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F8308E0006; Thu,  9 Oct 2025 14:33:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 081208E0002; Thu,  9 Oct 2025 14:33:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB25C8E0006; Thu,  9 Oct 2025 14:33:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D526C8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 14:33:07 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 80E1E13C0BE
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 18:33:07 +0000 (UTC)
X-FDA: 83979422814.04.F77E15B
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5D7FC16000E
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 18:33:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fMwvbgW5;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760034785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0GKlNRtXQVWz7matsuaXITEJm/SgqFeAxjg040aWhIc=;
	b=sFNZMdVaRloadqFo6zOyU+qB6nXqytq/l1fJ4kEV48WES6Y8DRniLeWOW7qWO+HdDtzw5Y
	A9KnGR74qdPDooKK4K1/VaFmtD8bPVpKFgdbGXKf78eKmOpFHckqPaFx5C5PGPOHsU//Cw
	BsWbcWlPGxhUCeSy85LyU3MDVYuSXQY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760034785; a=rsa-sha256;
	cv=none;
	b=sLq9XuK40iOJ4WJD7JG6cbYolffRRRUMdkrKaadUjWFpFswcyV76KFHhmrkVVZiEG7kxL4
	Mn70k18Fvb26+jkXBsMF7DNA4eFNrW5i78CBjoiAbvhYPtoHCOFhNyvFSEoIxj9XMcVMms
	1NIHUkx9LvtOsNzrafoJI/AF7vehPe8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fMwvbgW5;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 9 Oct 2025 11:32:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760034783;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0GKlNRtXQVWz7matsuaXITEJm/SgqFeAxjg040aWhIc=;
	b=fMwvbgW5NU8rfyCYDx/y79epIaulMjI73DtKanxOs0MWufrPjUL1RpX2fJdHa3DAICZgSZ
	znPirEdk5QR80c8V/42Qq+CTKidwg6e0BRzzD7dkt74X6GMALkDzkR9TpZAIQrFPN9Wb3z
	hIr3m5lCDzg+c8LlEPpCy4hjX2zvNas=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Daniel Sedlak <daniel.sedlak@cdn77.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Neal Cardwell <ncardwell@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, David Ahern <dsahern@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org, 
	netdev@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	Tejun Heo <tj@kernel.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Matyas Hurtik <matyas.hurtik@cdn77.com>
Subject: Re: [PATCH v5] memcg: expose socket memory pressure in a cgroup
Message-ID: <qdblzbalf3xqohvw2az3iogevzvgn3c3k64nsmyv2hsxyhw7r4@oo7yrgsume2h>
References: <20251007125056.115379-1-daniel.sedlak@cdn77.com>
 <87qzvdqkyh.fsf@linux.dev>
 <13b5aeb6-ee0a-4b5b-a33a-e1d1d6f7f60e@cdn77.com>
 <87o6qgnl9w.fsf@linux.dev>
 <tr7hsmxqqwpwconofyr2a6czorimltte5zp34sp6tasept3t4j@ij7acnr6dpjp>
 <87a5205544.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a5205544.fsf@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Stat-Signature: 4sfin4fzokoh6w79j1ixco83e8k7pgnq
X-Rspam-User: 
X-Rspamd-Queue-Id: 5D7FC16000E
X-HE-Tag: 1760034785-804115
X-HE-Meta: U2FsdGVkX1/N/F6hVjG5D7ifUU/lvU2+8hF6qljDbXQQcB8fuAIRXroMVI5aYN3ulR09PIsU8gfLj3m87pOAExjmKjTwt6jzP7uFA3SfLeu2obI0mgWNHUr32Mg/ZIsjejOD8ji0pp5MhHBcWyAY/KJe6Ex4RYEI+/CYE7RfZ0J0TUkcgj2DL1QYdGOqdmndwaI2Tvq8XLHwYORJxNbWZCrXydn8LRgjR+nZ4T4iZFWqhBeBXOuiPP+xN3ommBwYW8kgiUYd7GifaLdvum6d9TqbZnaaWhMI9NIcIms5eie2I4pDM5OrA6JrBteFB3V4FaEKsl67XHZjgFj9O8KmS8hTL6yKgXOdTfgS5mX0KkwVUJNL+vE0Ehnqqjp+WM+1HDzmzc0xMslciDPAU91u4vHyVkklqtuNHEdKTU2uyEvG63v9NKBnrFyfb9pQQcpus0Q99oWnDEuCkZJbW2uG/JShI/J4GMwMAPyV6/xrTos1hEhEBMvL8k3gZB+bauiZ230GCLBpY6gxc7E46kT+GcNsCqmW8xQVDW4sMmkxm4QRXPB6oENa0b+6rTxb0R//eJKmMiMcujtE1UjPDES6cHWlYXT24mC1l5atzVu3XglscKF7ZKeVL78r9YqwMv5+2mHwhIvnJNrbrd7xWkc6s7HJc+GWunoZHFFVF5MHrH37VzBfpb9yjgQhXE7teuOVaCp3gvOvOSvJ43U2qO96tOslg9svyGDNdMFrEZYRHK0WtW6zb+xv6/i0sQ80jlj03TyPUHhD1w9KlU0nR554WIgAXw4PeM+2epJowQAwV4e9ZqwNfuLyo7mumIbV8O5ypzTr8mDW27Zfb5tzJFtAra0EG7tpF3S4iJBLcDyzbZy/XZrGZkDg7YJ+kHgBA+abqLLDhC+FuRL4/AdjNo7KOGxCmVMHpmPQXLrIpnQDTv5CE/g3kUV11j0VJ2thvUZYbIBl/KeFWOl1boZkmv9
 8cxDJLSq
 pWFpuOYDuPdUvZWTFIb53PhMnmKPlWM+2d31KDcpsZDav8ANKn46lizOSnv9qBtVqw002+T/jQ9eehyERmvImsUsC5/Bil8ltUZpcHaOkV1UEhXozScfe5MDwBWpeugmJqfmnHcMYRFQtPXiFo0UOFTGlZuXe5FRgoUkjzwNy+o/RbQhlsAmRGeu96tw8p9gCDGkpDjlyO5GfZqEY9WXQf7WZ+JsFESbeXxkkMJkcbdnI8j/EivUzWDGV4wZ3r+1ZKNXnXA7QUZ7thHhvYIbqtJBLyThKc/YH+kpNwy/Jl1fegWahqGPGD1A1qGBM9s7CkMcYSpud8EhdvYk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 09, 2025 at 10:58:51AM -0700, Roman Gushchin wrote:
> Shakeel Butt <shakeel.butt@linux.dev> writes:
> 
> > On Thu, Oct 09, 2025 at 08:32:27AM -0700, Roman Gushchin wrote:
> >> Daniel Sedlak <daniel.sedlak@cdn77.com> writes:
> >> 
> >> > Hi Roman,
> >> >
> >> > On 10/8/25 8:58 PM, Roman Gushchin wrote:
> >> >>> This patch exposes a new file for each cgroup in sysfs which is a
> >> >>> read-only single value file showing how many microseconds this cgroup
> >> >>> contributed to throttling the throughput of network sockets. The file is
> >> >>> accessible in the following path.
> >> >>>
> >> >>>    /sys/fs/cgroup/**/<cgroup name>/memory.net.throttled_usec
> >> >> Hi Daniel!
> >> >> How this value is going to be used? In other words, do you need an
> >> >> exact number or something like memory.events::net_throttled would be
> >> >> enough for your case?
> >> >
> >> > Just incrementing a counter each time the vmpressure() happens IMO
> >> > provides bad semantics of what is actually happening, because it can
> >> > hide important details, mainly the _time_ for how long the network
> >> > traffic was slowed down.
> >> >
> >> > For example, when memory.events::net_throttled=1000, it can mean that
> >> > the network was slowed down for 1 second or 1000 seconds or something
> >> > between, and the memory.net.throttled_usec proposed by this patch
> >> > disambiguates it.
> >> >
> >> > In addition, v1/v2 of this series started that way, then from v3 we
> >> > rewrote it to calculate the duration instead, which proved to be
> >> > better information for debugging, as it is easier to understand
> >> > implications.
> >> 
> >> But how are you planning to use this information? Is this just
> >> "networking is under pressure for non-trivial amount of time ->
> >> raise the memcg limit" or something more complicated?
> >> 
> >> I am bit concerned about making this metric the part of cgroup API
> >> simple because it's too implementation-defined and in my opinion
> >> lack the fundamental meaning.
> >> 
> >> Vmpressure is calculated based on scanned/reclaimed ratio (which is
> >> also not always the best proxy for the memory pressure level), then
> >> if it reaches some level we basically throttle networking for 1s.
> >> So it's all very arbitrary.
> >> 
> >> I totally get it from the debugging perspective, but not sure about
> >> usefulness of it as a permanent metric. This is why I'm asking if there
> >> are lighter alternatives, e.g. memory.events or maybe even tracepoints.
> >> 
> >
> > I also have a very similar opinion that if we expose the current
> > implementation detail through a stable interface, we might get stuck
> > with this implementation and I want to change this in future.
> >
> > Coming back to what information should we expose that will be helpful
> > for Daniel & Matyas and will be beneficial in general. After giving some
> > thought, I think the time "network was slowed down" or more specifically
> > time window when mem_cgroup_sk_under_memory_pressure() returns true
> > might not be that useful without the actual network activity. Basically
> > if no one is calling mem_cgroup_sk_under_memory_pressure() and doing
> > some actions, the time window is not that useful.
> >
> > How about we track the actions taken by the callers of
> > mem_cgroup_sk_under_memory_pressure()? Basically if network stack
> > reduces the buffer size or whatever the other actions it may take when
> > mem_cgroup_sk_under_memory_pressure() returns, tracking those actions
> > is what I think is needed here, at least for the debugging use-case.
> >
> > WDYT?
> 
> I feel like if it's mostly intended for debugging purposes,
> a combination of a trace point and bpftrace can work pretty well,
> so there is no need to create a new sysfs interface.
> 

Definitely not a new interface but I think having such information in
memory.events or memory.stat would be more convenient. Basically the
number of times the sockets in this memcg have to be clamped due to
memory pressure would be useful in general.

