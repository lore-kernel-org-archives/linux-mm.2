Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B452103E2EA
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 22:47:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72E896B0088; Wed, 11 Mar 2026 18:47:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DC7C6B0089; Wed, 11 Mar 2026 18:47:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BE456B008A; Wed, 11 Mar 2026 18:47:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4A0536B0088
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 18:47:45 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E1A268BA86
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 22:47:44 +0000 (UTC)
X-FDA: 84535270848.14.6E119C0
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf30.hostedemail.com (Postfix) with ESMTP id DFF8980003
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 22:47:42 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="J3/Q3jJl";
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773269263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=idJIoDyRymSwYZXU6eln9CZA4jpBWR8zpwLI0BXP8sA=;
	b=w1oJ/MdbZti1H09ojoJHbCp6zrGCsp7dSsrakockMROoa1DiTE00ezl+0lSIaRNl4VFWHR
	F9PXJVUtYvCDwwVigWqSq76A+m4m+sch7btCTA9HUvOrH6Co/7Xqr1z7mo0CEKdxAzsKKK
	dbG2odcgyerlXn/0QjJhPqW+TlJ1TfM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="J3/Q3jJl";
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773269263; a=rsa-sha256;
	cv=none;
	b=gOQdkqkZYgJ0rgdhNEqeeWJHIeoGPTNljrlL8EL1U55tcGKx3QshRs+aCtv+4GQnUTyuvP
	zYSF5U5IGsEHuJOr9YfHWyoA/GDI+SwBDh9iH1+8cOBfA3Wh2djOzMT2jQ0jtWwgrJkl9f
	8oEcmo1Q2KoWGXEYRobImJeyQnxgRtM=
Date: Wed, 11 Mar 2026 15:47:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773269260;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=idJIoDyRymSwYZXU6eln9CZA4jpBWR8zpwLI0BXP8sA=;
	b=J3/Q3jJlcBtYWHhvfiCDAHeSGCSlT63Vi8A2HqV+6c/5XDOdfLpWbNuGt1jCGMEAnhkiGv
	1pDFkLzGdte5uWGuunLt/DbDcC3xMOZwa0IS5kUmCFRjhAUMgzzSqde38mxX34LAABpGOn
	V55eKMA2a90nM1sz4o6MVtdgvrJp+Wg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: lsf-pc@lists.linux-foundation.org, 
	Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Alexei Starovoitov <ast@kernel.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hui Zhu <hui.zhu@linux.dev>, JP Kobryn <inwardvessel@gmail.com>, 
	Muchun Song <muchun.song@linux.dev>, Geliang Tang <geliang@kernel.org>, 
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>, Emil Tsalapatis <emil@etsalapatis.com>, 
	David Rientjes <rientjes@google.com>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, bpf@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Reimagining Memory Cgroup (memcg_ext)
Message-ID: <abHkgYHEq5U7G7rF@linux.dev>
References: <20260307182424.2889780-1-shakeel.butt@linux.dev>
 <abFsDg5m3lp2vVOX@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abFsDg5m3lp2vVOX@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: DFF8980003
X-Rspamd-Server: rspam08
X-Stat-Signature: am6trgnansnactkrcsuixuzhfam65h8c
X-HE-Tag: 1773269262-870105
X-HE-Meta: U2FsdGVkX19pjxcPzKV+RIIy/I0LYvqC3v1hAp+tBcKClLRVjniRYnEs5D1sNtWHwpWdLMWuvOsf5WIwTtJ10C8EcValsUgqrGi97jPC6ELCXt/dk6HV+EgEljweCO9oyCTZGnuMj46vnODay8l2kwAutI4gBRNNu4hrUAO6VdP7PdavnSHNNlYEzP7pHrqg5y8shzG4Ed/y4xQtcC/LUYTm/OaN5BSrEiUvBJcZWs/WO6rye7fy4//tRwclS2w7sIE3p2t/kt7tZ3oZ48zKN3ECtOYxt7GKZ/I7nGdIFA/waLGLhfQgfR2IMkJXTQrTTernI842/9+vZgOZ6PWDS3Xv3mlHSKBbWDkdj9ekUYV5gVZLp6WUy0gawyJ7wkBDq/haBhi1hSQgHnLuQPXi7RD3sOgDilBuuDIioTjPP5yTdYa7pwVLNTI+g6a/XmrtJDvHYeFiXTkJkQCzFPRd95tCyUz/8ikXTkwB7ExkArFLFDPF9pNEl5DW9vWcXfQqE2wqAqbfW6Bnjntf7imeKIp/CFjaH0ZQLHAXfjpntrtEtd86ymongWeWS5e6hF+NPKcvRjaACx+AhBKbX5jmMInrjsrn4dsAM+WGvTXnuui7lR2Tu5jCNB0cOEt3uAeQCNcpEkeODyHqDd1v619KRlslj+SkgWmD0lbXBR/6PhVY25YBPXmtT70DnDzlTUKdSbupLBPU5vUzo9ioNN6Wd7No428qBcuVv4FdroZtd+18+Aumene5PBs5im8p3sfq5UAuQwD6gZ4YMTNUdM2+dTZCxrDKuG22eEelj2wSyO/hmluLQrdkaw/CuJO0/R6CC9oY+QTsPfMElyVdlyYsPheVIo8z4YIn0L/PaZDRpoi5K5ZKpxMDE24lCSICNet2EZIA51RE5VzkOlCpeVCEHJOFXfN2LuEZ9SalhMlP8a84tiEYasl556c63jhVv4RSJ31XTYBNjWjGfdw3B9z
 Pnf+oMpB
 BU5En/q9HZeM9YLL7s/p494g0OZAyI81wt7K01IEK/Mx08cOunzTtp1D30Ch+fQYR4s3/SVbFm46XKBb7tBhUkaa3ax7HSRBNjUp28TaIDD1Hi+cvwhDgy96JuuO3ICd6heAQFPUCBmJubFZInISLNbYRVghRuI5awgPnY7h5Gcm+4znmr8q3jGPkC5vWVS5i7NcahVWXYqerrwtZ4iSXUgWP7a4Sw+uZXovCM5Ke5717MO0itozw8NPH2Ag/wN3GSFS26NIAyBN1OzLzceZ+F7cmgoH5SLED4a/s6ncIGYZTkKsMG/qketbFPUSYE1lVXLKUrGEz67kQdhl0/KKJ1PiVqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 09:20:14AM -0400, Johannes Weiner wrote:
> On Sat, Mar 07, 2026 at 10:24:24AM -0800, Shakeel Butt wrote:

[...]

> > 
> > - Workload owners rarely know their actual memory requirements, leading to
> >   overprovisioned limits, lower utilization, and higher infrastructure costs.
> 
> Is this actually a challenge?
> 
> It appears to me proactive reclaim is fairly widespread at this point,
> giving workload owners, job schedulers, and capacity planners
> real-world, long-term profiles of memory usage.
> 
> Workload owners can use this to adjust their limits accordingly, of
> course, but even that is less relevant if schedulers and planners go
> off of the measured information. The limits become failsafes, no
> longer the declarative source of truth for memory size.

Yes for sophisticated users, this is a solved problem, particularly for
workloads with consistent memory usage behavior. I think workloads with
inconsistent or sporadic usage behavior is still a challenge. 

> 
> > 
> > Per-Memcg Background Reclaim
> > 
> > In the new memcg world, with the goal of (mostly) eliminating direct synchronous
> > reclaim for limit enforcement, provide per-memcg background reclaimers which can
> > scale across CPUs with the allocation rate.
> 
> Meta has been carrying this patch for half a decade:
> 
> https://lore.kernel.org/linux-mm/20200219181219.54356-1-hannes@cmpxchg.org/
> 
> It sounds like others have carried similar patches.

Yeah ByteDance has something similar too.

> 
> The relevance of this, too, has somewhat faded with proactive
> reclaim. But I think it would still be worthwhile to have. The primary
> objection was a lack of attribution of the consumed CPU cycles.
> 
> > Lock-Aware Throttling
> > 
> > The ability to avoid throttling an allocating task that is holding locks, to
> > prevent priority inversion. In Meta's fleet, we have observed lock holders stuck
> > in memcg reclaim, blocking all waiters regardless of their priority or
> > criticality.
> > 
> > Thread-Level Throttling Control
> > 
> > Workloads should be able to indicate at the thread level which threads can be
> > synchronously throttled and which cannot. For example, while experimenting with
> > sched_ext, we drastically improved the performance of AI training workloads by
> > prioritizing threads interacting with the GPU. Similarly, applications can
> > identify the threads or thread pools on their performance-critical paths and
> > the memcg enforcement mechanism should not throttle them.
> 
> I'm struggling to envision this.
> 
> CPU and GPU are renewable resources where a bias in access time and
> scheduling delays over time is naturally compensated.
> 
> With memory access past the limit, though, such a bias adds up over
> time. How do you prevent high priority threads from runaway memory
> consumption that ends up OOMing the host?

Oh don't consider this feature in isolation. In practice there definitely will
be background reclaimers running here. The way I am envisioning the scenario for
this feature is something like: At some usage threshold, we will start the
background reclaimers, at the next threshold, we will start synchronously
throttle the threads that are allowed by the workload and at next threshold
point we may decide to just kill the workload.

> 
> > Combined Memory and Swap Limits
> > 
> > Some users (Google actually) need the ability to enforce limits based on
> > combined memory and swap usage, similar to cgroup v1's memsw limit, providing a
> > ceiling on total memory commitment rather than treating memory and swap
> > independently.
> > 
> > Dynamic Protection Limits
> > 
> > Rather than static protection limits, the kernel should support defining
> > protection based on the actual working set of the workload, leveraging signals
> > such as working set estimation, PSI, refault rates, or a combination thereof to
> > automatically adapt to the workload's current memory needs.
> 
> This should be possible with today's interfaces of memory.reclaim,
> memory.pressure and memory.low, right?

Yes, node controller or workload can dynamically their protection limit based on
psi or refaults or some other metrics.

> 
> > Shared Memory Semantics
> > 
> > With more flexibility in limit enforcement, the kernel should be able to
> > account for memory shared between workloads (cgroups) during enforcement.
> > Today, enforcement only looks at each workload's memory usage independently.
> > Sensible shared memory semantics would allow the enforcer to consider
> > cross-cgroup sharing when making reclaim and throttling decisions.
> 
> My understanding is that this hasn't been a problem of implementation,
> but one of identifying reasonable, predictable semantics - how exactly
> the liability of shared resources are allocated to participating groups.
> 

This particular feature is hand-wavy at the moment particulary due to lack of
mechanism that tells how much memory is really shared.

The high level idea is when we know there is shared memory/fs between different
workloads, during throttling decision, we can consider their memory usage
excluding the shared usage. So, mainly their exclusive memory usage. Will this
help or is useful, I need to brainstorm more.

> > Memory Tiering
> > 
> > With a flexible limit enforcement mechanism, the kernel can balance memory
> > usage of different workloads across memory tiers based on their performance
> > requirements. Tier accounting and hotness tracking are orthogonal, but the
> > decisions of when and how to balance memory between tiers should be handled by
> > the enforcer.
> > 
> > Collaborative Load Shedding
> > 
> > Many workloads communicate with an external entity for load balancing and rely
> > on their own usage metrics like RSS or memory pressure to signal whether they
> > can accept more or less work. This is guesswork. Instead of the
> > workload guessing, the limit enforcer -- which is actually managing the
> > workload's memory usage -- should be able to communicate available headroom or
> > request the workload to shed load or reduce memory usage. This collaborative
> > load shedding mechanism would allow workloads to make informed decisions rather
> > than reacting to coarse signals.
> > 
> > Cross-Subsystem Collaboration
> > 
> > Finally, the limit enforcement mechanism should collaborate with the CPU
> > scheduler and other subsystems that can release memory. For example, dirty
> > memory is not reclaimable and the memory subsystem wakes up flushers to trigger
> > writeback. However, flushers need CPU to run -- asking the CPU scheduler to
> > prioritize them ensures the kernel does not lack reclaimable memory under
> > stressful conditions. Similarly, some subsystems free memory through workqueues
> > or RCU callbacks. While this may seem orthogonal to limit enforcement, we can
> > definitely take advantage by having visibility into these situations.
> 
> It sounds like the lock holder problem would also fit into this
> category: Identifying critical lock holders and allowing them
> temporary access past the memory and CPU limits.
> 
> But as per above, I'm not sure if blank check exemptions are workable
> for memory. It makes sense for allocations in the reclaim path for
> example, because it doesn't leave us wondering who will pay for the
> excess through a deficit. It's less obvious for a path that is
> involved with further expansion of the cgroup's footprint.

No need to have blank check. Same as above for the thread throttling, the lock
holder not getting throttled will be, in practice, in the presense of background
reclaimers and may get killed if going over board too much.

Thanks for taking a look and poking holes.

