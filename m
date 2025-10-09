Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E126ACCD183
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 16:06:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CEFA8E0008; Thu,  9 Oct 2025 12:06:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A6738E009B; Thu,  9 Oct 2025 12:06:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E4BF8E0008; Thu,  9 Oct 2025 12:06:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F2D0F8E009B
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 12:06:24 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B4052BC45E
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 16:06:24 +0000 (UTC)
X-FDA: 83979053088.02.DE50EB8
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf21.hostedemail.com (Postfix) with ESMTP id CBFDF1C0019
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 16:06:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZUm0GTpV;
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760025983; a=rsa-sha256;
	cv=none;
	b=VoTDEglKbB4yu1KHQuJVHfzEYcHlj6HbtCBTabi0BOkaBHdNcmB3IRSXYfNJ+eXooHj0vZ
	t2WDQULpw5B32FbWeqynqMJoiXlom2CzSnZOlm9KmJgWdlf2w+2FtOkkiSHNGf4c8Jz5mG
	U/qrl7B/20efCS831GcddKNu0RRZH5E=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZUm0GTpV;
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760025983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KukbsMbl2huYRhlfoo2l0mDAbmiuXFQP1BtPelYVi10=;
	b=UrPPwPSPDiUOhXjVD14fQj0WMlG5KR2ziYIux8LPuBYHGCb3ETeTVw7arJrgaM6qpcHezG
	NoTtEy8X5DbZtHtktnwaTh0H6r507rE6b/BgUkQZF27XIoe6UREcPkdOhpExF/4XQumUJR
	vMukHAvsS3+YCt5jBt80vsGpA2nZ42U=
Date: Thu, 9 Oct 2025 09:06:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760025980;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KukbsMbl2huYRhlfoo2l0mDAbmiuXFQP1BtPelYVi10=;
	b=ZUm0GTpVawkjiuJwQRpZJGGk3dlnInR8BQqp+avz857kSA9AMtwUiJc7SoyzfdEfczhfgI
	t4YvP0k8b3mNJ0nUQGPRRxpmwogQOXrODl08eBC2UrQ9b2x+HSYz41SR2yCPRxhwqnizPK
	1dbY1/nAOQlraza2002+CzXHfj4NQzw=
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
Message-ID: <tr7hsmxqqwpwconofyr2a6czorimltte5zp34sp6tasept3t4j@ij7acnr6dpjp>
References: <20251007125056.115379-1-daniel.sedlak@cdn77.com>
 <87qzvdqkyh.fsf@linux.dev>
 <13b5aeb6-ee0a-4b5b-a33a-e1d1d6f7f60e@cdn77.com>
 <87o6qgnl9w.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o6qgnl9w.fsf@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: izaggh481s4437jg771sjwnikppk855u
X-Rspamd-Queue-Id: CBFDF1C0019
X-Rspamd-Server: rspam09
X-HE-Tag: 1760025982-165288
X-HE-Meta: U2FsdGVkX19oG4k/zd0rrGf8k2D9jyZFjCTIYKjdHLbCq0e3UgbWuQPxZku/dumiA/zYIIBbeFMoTeoI1FPvYrN9NBkzM3ZUPACftUk0j+8D+cFjBlwf3hzOj8Xg1Fc7tomH6nynfle7NGlaLNp7EC1+bJI2u/tXWN3zFhDJtqQ7aOxbsEgY5m/eMZT0Uj8Zku8y1uj1LzomK11kWdX+jbMMSZqgNbwcnlC/BEsMKqDBygE8PN7aCjJWILoYTk51JwftJ+oiZwSl/wE4tjWTOxpYtG8K5Ie9HUMFU2dGqL8t5l4//ehUth5oP/Ir/B0YZwyWSrA8bzEuoZkrCrer2SNrzAetyjNo7JQpxaNKfAWDVD9TVxt2IJ2q1VaxPDN2QfH+k7TUD4xuE/F+WtqlO1d18c67fNtnW32jBbHmwibDg9itCIEjnYu+sMkR+ZryleM1Yf+5i04kbn94ZNaylKq4K2ISMclAWRHMyLHik0QdNwE0uyMD7k9WhbTBF+UCgmCRgjltC45Xwv3Jpxtkx/GHBs+q/onuxLdI9J2ugd9TZ+J+oPhNwdX3OBe5uKhqe9DYPjsAL2BuJ27SIR33urDB5W47ulrwJxXHexLxN/CL4EEphF2Ank7SJqcvCFeWr7rkpuUC6VV4r61VVDUqehFTLrbboG2g/7jUjx4NPFau/jOYgWkqJk3hOLuPlZGqdpjGUZfCqmy3pq7EzVxOYJ6/bb7ZtwD48w0lbBSIYnx+sumRROSyv4x77nPFk73WYGeNdSARXGUXS+fob48g/swRfbJoKLEmPWqZ45CwgAIVkkkcofxIY9RxIOl0KAZsd/p0JAyRYewJjyg0pg9Zsj9r3/m2g5jogIsJ3T06lmYUjHVK4UaHa9VCIbxcFvoxG+clrMxdU/a7moElN3shdb1VWtWvPTTim+0oBozu0vfo5cg1ADkX0qOpvDLsRovZT52DMp/VR/vx1G3apdq
 5Hmjq5v7
 a8pLHT5sL6xXwIAH5Te781HK8KIRfwFae/kvfCLQXOdmOfgOix6eJbGZ1ifMc98bG5fMjQQS4KJuhSwuC7cJQdOWx86e/tbgSKXgjm0mq4TSuWFDwy9iQwGqkMuKthu9iLMFXTMApMhzax0n8iIv2DGxawp1kaK0mIWr7hlmzDEZU9XOo33bcm3GehL/0AUj40qc6T1X+K/Z0rdma/G0AZ7UXuY7brpB6eHop/Mxq0GLCmZuWncrotGKfcQspZ7COsBQqm7Yor+4VxT3ORkAfhxSZrQYU0oqEjuXf3W4G0mhKAthIEnPX5AkX2g5Gt8mse1sRIBw7fy7OyZQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 09, 2025 at 08:32:27AM -0700, Roman Gushchin wrote:
> Daniel Sedlak <daniel.sedlak@cdn77.com> writes:
> 
> > Hi Roman,
> >
> > On 10/8/25 8:58 PM, Roman Gushchin wrote:
> >>> This patch exposes a new file for each cgroup in sysfs which is a
> >>> read-only single value file showing how many microseconds this cgroup
> >>> contributed to throttling the throughput of network sockets. The file is
> >>> accessible in the following path.
> >>>
> >>>    /sys/fs/cgroup/**/<cgroup name>/memory.net.throttled_usec
> >> Hi Daniel!
> >> How this value is going to be used? In other words, do you need an
> >> exact number or something like memory.events::net_throttled would be
> >> enough for your case?
> >
> > Just incrementing a counter each time the vmpressure() happens IMO
> > provides bad semantics of what is actually happening, because it can
> > hide important details, mainly the _time_ for how long the network
> > traffic was slowed down.
> >
> > For example, when memory.events::net_throttled=1000, it can mean that
> > the network was slowed down for 1 second or 1000 seconds or something
> > between, and the memory.net.throttled_usec proposed by this patch
> > disambiguates it.
> >
> > In addition, v1/v2 of this series started that way, then from v3 we
> > rewrote it to calculate the duration instead, which proved to be
> > better information for debugging, as it is easier to understand
> > implications.
> 
> But how are you planning to use this information? Is this just
> "networking is under pressure for non-trivial amount of time ->
> raise the memcg limit" or something more complicated?
> 
> I am bit concerned about making this metric the part of cgroup API
> simple because it's too implementation-defined and in my opinion
> lack the fundamental meaning.
> 
> Vmpressure is calculated based on scanned/reclaimed ratio (which is
> also not always the best proxy for the memory pressure level), then
> if it reaches some level we basically throttle networking for 1s.
> So it's all very arbitrary.
> 
> I totally get it from the debugging perspective, but not sure about
> usefulness of it as a permanent metric. This is why I'm asking if there
> are lighter alternatives, e.g. memory.events or maybe even tracepoints.
> 

I also have a very similar opinion that if we expose the current
implementation detail through a stable interface, we might get stuck
with this implementation and I want to change this in future.

Coming back to what information should we expose that will be helpful
for Daniel & Matyas and will be beneficial in general. After giving some
thought, I think the time "network was slowed down" or more specifically
time window when mem_cgroup_sk_under_memory_pressure() returns true
might not be that useful without the actual network activity. Basically
if no one is calling mem_cgroup_sk_under_memory_pressure() and doing
some actions, the time window is not that useful.

How about we track the actions taken by the callers of
mem_cgroup_sk_under_memory_pressure()? Basically if network stack
reduces the buffer size or whatever the other actions it may take when
mem_cgroup_sk_under_memory_pressure() returns, tracking those actions
is what I think is needed here, at least for the debugging use-case.

WDYT?

