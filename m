Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C63A1125807
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 13:20:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59B456B0005; Wed, 11 Mar 2026 09:20:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 549556B0089; Wed, 11 Mar 2026 09:20:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42AA06B008A; Wed, 11 Mar 2026 09:20:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1B1E96B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:20:23 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AC3901A01A4
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:20:22 +0000 (UTC)
X-FDA: 84533841084.02.F06FEAC
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf09.hostedemail.com (Postfix) with ESMTP id 73B5C140017
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:20:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=qrqKU90p;
	spf=pass (imf09.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.179 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773235220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bMIMU3sHJZlvMpoRZjdCQwXY7BleqcJF6IN8V8A9OHU=;
	b=UXBrHLqOoOGSqinUb+TLsFr2ZtbBgT7YSNmIbWc3OHr+KR5AGR+pEjxf3uH8CTB79ZXghS
	tdK0lG5KHxmZe23XFUNl52iAi0QDWxwX4peBAe4SQt6HFIXjZlN+K4SmIRF1ZFh9ll9Q1x
	5qnwvhRLA1Hfz8Jf4dQuHCIDemFrTek=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=qrqKU90p;
	spf=pass (imf09.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.179 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773235220; a=rsa-sha256;
	cv=none;
	b=PtxNPrpByycxZXzu7/Xpn+plIxIGcicacSdjwsbDuDPh3l+xLfygvjGbFxdE6IN8t3svZN
	YoxCQIReCXyjfGAzzabRyiwLYFD4U/Ywb0yvfBBoz57aDkAMBEaJI+8QnXtnBfl64c12qk
	xxYsnF9i6eJMavLMIpF+PgKOGZkzmlw=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-50939f851d1so6967991cf.3
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 06:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1773235219; x=1773840019; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bMIMU3sHJZlvMpoRZjdCQwXY7BleqcJF6IN8V8A9OHU=;
        b=qrqKU90pmGdkyWu8WBc4eu9dFSnyNdJUXrFswwqMGm9/Y8RvWwI/jTZdhugm2GQyzu
         uYyV23A5Fv45i/rhOP7nxhV9fGRKGjL8fsiO8iIrzr+bZkoLtVWNNM+mRiraWBaBc0uf
         SwkL4+PocUh+7D4FfJl1YW4M7TVUcTyv3RiHMEOKakFHsL+CILcLnDUlMjyL76eYgWep
         NiiSBIqRo7d4P9sa+ucilYZ108rggYoVyVF1BMvMkCqVwhX0IltBn5Wq/eVfuJIWlX33
         3fxYtV/hPjft1hBYWSYxi7tMJnfVhOeiE5L9MoLAooOpdgba6IdFzdjzR5BO2q9PcKl1
         oZ7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773235219; x=1773840019;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bMIMU3sHJZlvMpoRZjdCQwXY7BleqcJF6IN8V8A9OHU=;
        b=ElXVk84Mzy9uy5xxYQwOuHKF2O6L7lG8/CFi/KyHRn2z+KAU0whxOgbZJF7iQAa5bO
         t4y0E+3YqaAWIHWWx7GcJ9hV0mx//skju7vLizhod+GG5C2ZiDjZ96NPm3j5Jlv8WE+c
         SoRFGtqAnheCa3eDoDdZoajj9jcCREfTlKsztwNWFmdgtgB0smgS7jaqeEQtPaZTIrpG
         tQlhV/XpcOHfx31yadRm3Q5JYS2ETZrzYlDVpBnPhpV1qqq1z0yXNr50KAnvjkpRYkw2
         +OeElM3fkVInKT7H19Av6RrmY3EsXVC8GqCZpBP5HWQJVX2zZ1mgy/c4OZWdjAvWoXwU
         ZltA==
X-Forwarded-Encrypted: i=1; AJvYcCXvfRC3U6epkCmv2hV18wp0/kJFeS5FnSwuLZo+bh6l2/bweZPfb4FqIf1OP2or68leZDkaKjLC/Q==@kvack.org
X-Gm-Message-State: AOJu0YycmPzdTP3201nxD1aFUYCpHtyVF0NWGeOk1KYrctJN+FCvhHil
	+oqwUBI4MirQ0xB9zI5HHfG6JOsndeCUm7vkuZrp7AZUGMxzi9DlVQ+P1dnzZ1+g6Wg=
X-Gm-Gg: ATEYQzzR3FvyxLQqmYJgqr4xf7QLB04Ep+nNuAy0fzi1o7Mh8/+u+uWsWGQ2G4PV3rP
	uy5VpsCDo4IXs4aj16BKjugdYz5/IZp1gwo4Gl38a/eQl8omjtDwTP5uzpz59fV+flIEyZp/Fpr
	PdjJnKRLBlxN6mia3xf8RqpBq4BuaktmsD6y7w5ANACR5Xi6XREdNaD04dDSUvs/WChK1pqGHzj
	4qiWmMmq6CPap7HM87ZRy61EXPV+BA4RO3YogtZK1Mp/OJbHrIPAddr6x6HHLSY5/Pwv31jKljm
	CJbS3XBztNL5GqTBRdAPcadvKteMgzsodkkdq1uHDCWXYVV97Z8QwTDllolTNXqOlULx1zeGeNa
	DaD7CMgFp3GRZkHALzUcgNxJi/3N3/DHLe5UtAgP7tM1qZ0IdLnPFPGCGli6DkjlLozv8bpbwv6
	t2+tbFQorEQ5WsuzSA1BlQxw==
X-Received: by 2002:ac8:7fd6:0:b0:4ff:a946:7958 with SMTP id d75a77b69052e-50939fbfa52mr30872141cf.32.1773235219250;
        Wed, 11 Mar 2026 06:20:19 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89a65ce1c9esm13950426d6.27.2026.03.11.06.20.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 06:20:18 -0700 (PDT)
Date: Wed, 11 Mar 2026 09:20:14 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: lsf-pc@lists.linux-foundation.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hui Zhu <hui.zhu@linux.dev>, JP Kobryn <inwardvessel@gmail.com>,
	Muchun Song <muchun.song@linux.dev>,
	Geliang Tang <geliang@kernel.org>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	David Rientjes <rientjes@google.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Reimagining Memory Cgroup (memcg_ext)
Message-ID: <abFsDg5m3lp2vVOX@cmpxchg.org>
References: <20260307182424.2889780-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260307182424.2889780-1-shakeel.butt@linux.dev>
X-Rspamd-Queue-Id: 73B5C140017
X-Rspamd-Server: rspam07
X-Stat-Signature: jit8eo486ax594o3ppojx85yd6d33b7f
X-Rspam-User: 
X-HE-Tag: 1773235220-587151
X-HE-Meta: U2FsdGVkX1/5IP+grGuir8l53Kx2tXjYO5aO4dSxLZ5F7O2sVZQwA03jvuJBSp/lIF0Y64SgiVOQroUs8XQ+NStHUWqVf3SS5bVtKWFeIAhICpm4eTF7K1kQ75gXYbEIv/Ana5uCS5K2GslrNDCAwDirWYz7yz49XaAHAtuty5ljsd2vWS46QbYtmoi7YT31oMR1YLz/R259IXAKOZgEceBhTDSbXsD+ECOfcShDSmX6J73XAOc2dp2sdM09I53XwJurjMDMoQU4wTB2Lt+PurwWnlisrkeyXo6aUSKn0I1MMuuTlbVhvjk3ergjq58N/d5W3xZ4vSQnvAUUjrkdVKawie6H/6FI2hwQNdZavGywp7OrLEv7warE6u+2JXR7OT2OVosRqQPauJQmOsCc4hcpJia1gjscrbIrNTeaIz3iEoB6iEM/31ScojbTGVPYoT5jE4fPh8jFRS4anJmTvrr4Wh8mY/3rUm/w/UQmMVK6LvpoXnRhdfILHcN0xpyUtp08PUX5NXJ/B6Dwxp1f7vcu2j6PshORvyV/xBmpG4akErnOJZ5H7S9DtU90jPXlib+tZSdxDbRijSiZ80kwA7HLjMbyL5AiG9AdBSM9zl+wgcS1eej4E6WtQ/VIdWm+sqicDge6vgjJrmk5z8mFvguQY6gpjfJ1sK7OQ5eAGJOWxBgl+s9AMRDsIHMPhz1J9Gm/yBGYJkODYsEjj6vs4L7Z17OzALfG9NpwyuIX27XxY40YEU03izKUy/OwvbeliR8B5DbOd3pdr4ypP049BfIl5GhQG4D+E4ydVskaOeUUdM8Ls9Wo8wr7AWV5RF5LInu9+5nZX+2XpVTqTbb/i7Eu49suBbmU6uPDXWZCtgdf0uyZmWMi+4iHMlDtiRKWGVp3Il6WqGA226/HGYfkzJKCrCwelIFkOchTru12GDq9IkqCivyWkCy5ziXVwnOIPC7SCwscgsXIDvtK+7J
 AfkmicK2
 LaGqOhM4ZkHxB1BDUbE4VwblfXsV0Ua1gsNVFpvdCSTTz5vMgwZvBIk88ulK6qsy0gjoEIyImC0NXNK7h+7HSpmETCW6wpDfMg6P/h9X6A70PJiiivwYGCuTlCqn3R/SDRVKyF76iJa7OTFgk0BKqWelrA0XgQZo631RsqRIUPsXbAB5+iISZuAFE5+FK7AhldvsotLffUoAoZC5M1AkdpyPT54Wwp1F4BLj6D7MpXkxqNanCFzCeWYwH4UWFMcVRUPYcuLOJaEvriKWJISulo4mzjKQJO6t1dh8v3phLjYxCwUGD0CFLDfSrvGAn/VdMspsO5KXFbecre10o9WSGJR3FDmXQNodsFfFqzQ3LyY+RFObjuPLfhUtFG5EN88C4G0mMmCdOK4j2k/qBlQdPJPHAPWjYJxX1uZNeRGBSutxrEKkMTh2pApfCK/NiM12rNOHaXL6vS6lHJmcsIcR47djYzl7YwsvNDh6XV+ZhFY4slksxIoGPdh1qOB5i8DOlAgM9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 07, 2026 at 10:24:24AM -0800, Shakeel Butt wrote:
> Over the last couple of weeks, I have been brainstorming on how I would go
> about redesigning memcg, taking inspiration from sched_ext and bpfoom, with a
> focus on existing challenges and issues. This proposal outlines the high-level
> direction. Followup emails and patch series will cover and brainstorm the
> mechanisms (of course BPF) to achieve these goals.
> 
> Memory cgroups provide memory accounting and the ability to control memory usage
> of workloads through two categories of limits. Throttling limits (memory.max and
> memory.high) cap memory consumption. Protection limits (memory.min and
> memory.low) shield a workload's memory from reclaim under external memory
> pressure.
> 
> Challenges
> ----------
> 
> - Workload owners rarely know their actual memory requirements, leading to
>   overprovisioned limits, lower utilization, and higher infrastructure costs.

Is this actually a challenge?

It appears to me proactive reclaim is fairly widespread at this point,
giving workload owners, job schedulers, and capacity planners
real-world, long-term profiles of memory usage.

Workload owners can use this to adjust their limits accordingly, of
course, but even that is less relevant if schedulers and planners go
off of the measured information. The limits become failsafes, no
longer the declarative source of truth for memory size.

> - Throttling limit enforcement is synchronous in the allocating task's context,
>   which can stall latency-sensitive threads.
>
> - The stalled thread may hold shared locks, causing priority inversion -- all
>   waiters are blocked regardless of their priority.
> 
> - Enforcement is indiscriminate -- there is no way to distinguish a
>   performance-critical or latency-critical allocator from a latency-tolerant
>   one.
> 
> - Protection limits assume static working sets size, forcing owners to either
>   overprovision or build complex userspace infrastructure to dynamically adjust
>   them.
> 
> Feature Wishlist
> ----------------
> 
> Here is the list of features and capabilities I want to enable in the
> redesigned memcg limit enforcement world.
> 
> Per-Memcg Background Reclaim
> 
> In the new memcg world, with the goal of (mostly) eliminating direct synchronous
> reclaim for limit enforcement, provide per-memcg background reclaimers which can
> scale across CPUs with the allocation rate.

Meta has been carrying this patch for half a decade:

https://lore.kernel.org/linux-mm/20200219181219.54356-1-hannes@cmpxchg.org/

It sounds like others have carried similar patches.

The relevance of this, too, has somewhat faded with proactive
reclaim. But I think it would still be worthwhile to have. The primary
objection was a lack of attribution of the consumed CPU cycles.

> Lock-Aware Throttling
> 
> The ability to avoid throttling an allocating task that is holding locks, to
> prevent priority inversion. In Meta's fleet, we have observed lock holders stuck
> in memcg reclaim, blocking all waiters regardless of their priority or
> criticality.
> 
> Thread-Level Throttling Control
> 
> Workloads should be able to indicate at the thread level which threads can be
> synchronously throttled and which cannot. For example, while experimenting with
> sched_ext, we drastically improved the performance of AI training workloads by
> prioritizing threads interacting with the GPU. Similarly, applications can
> identify the threads or thread pools on their performance-critical paths and
> the memcg enforcement mechanism should not throttle them.

I'm struggling to envision this.

CPU and GPU are renewable resources where a bias in access time and
scheduling delays over time is naturally compensated.

With memory access past the limit, though, such a bias adds up over
time. How do you prevent high priority threads from runaway memory
consumption that ends up OOMing the host?

> Combined Memory and Swap Limits
> 
> Some users (Google actually) need the ability to enforce limits based on
> combined memory and swap usage, similar to cgroup v1's memsw limit, providing a
> ceiling on total memory commitment rather than treating memory and swap
> independently.
> 
> Dynamic Protection Limits
> 
> Rather than static protection limits, the kernel should support defining
> protection based on the actual working set of the workload, leveraging signals
> such as working set estimation, PSI, refault rates, or a combination thereof to
> automatically adapt to the workload's current memory needs.

This should be possible with today's interfaces of memory.reclaim,
memory.pressure and memory.low, right?

> Shared Memory Semantics
> 
> With more flexibility in limit enforcement, the kernel should be able to
> account for memory shared between workloads (cgroups) during enforcement.
> Today, enforcement only looks at each workload's memory usage independently.
> Sensible shared memory semantics would allow the enforcer to consider
> cross-cgroup sharing when making reclaim and throttling decisions.

My understanding is that this hasn't been a problem of implementation,
but one of identifying reasonable, predictable semantics - how exactly
the liability of shared resources are allocated to participating groups.

> Memory Tiering
> 
> With a flexible limit enforcement mechanism, the kernel can balance memory
> usage of different workloads across memory tiers based on their performance
> requirements. Tier accounting and hotness tracking are orthogonal, but the
> decisions of when and how to balance memory between tiers should be handled by
> the enforcer.
> 
> Collaborative Load Shedding
> 
> Many workloads communicate with an external entity for load balancing and rely
> on their own usage metrics like RSS or memory pressure to signal whether they
> can accept more or less work. This is guesswork. Instead of the
> workload guessing, the limit enforcer -- which is actually managing the
> workload's memory usage -- should be able to communicate available headroom or
> request the workload to shed load or reduce memory usage. This collaborative
> load shedding mechanism would allow workloads to make informed decisions rather
> than reacting to coarse signals.
> 
> Cross-Subsystem Collaboration
> 
> Finally, the limit enforcement mechanism should collaborate with the CPU
> scheduler and other subsystems that can release memory. For example, dirty
> memory is not reclaimable and the memory subsystem wakes up flushers to trigger
> writeback. However, flushers need CPU to run -- asking the CPU scheduler to
> prioritize them ensures the kernel does not lack reclaimable memory under
> stressful conditions. Similarly, some subsystems free memory through workqueues
> or RCU callbacks. While this may seem orthogonal to limit enforcement, we can
> definitely take advantage by having visibility into these situations.

It sounds like the lock holder problem would also fit into this
category: Identifying critical lock holders and allowing them
temporary access past the memory and CPU limits.

But as per above, I'm not sure if blank check exemptions are workable
for memory. It makes sense for allocations in the reclaim path for
example, because it doesn't leave us wondering who will pay for the
excess through a deficit. It's less obvious for a path that is
involved with further expansion of the cgroup's footprint.

