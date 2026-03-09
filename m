Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D58C0FCA192
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 21:33:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B85CA6B0088; Mon,  9 Mar 2026 17:33:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B339C6B0089; Mon,  9 Mar 2026 17:33:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A40226B008A; Mon,  9 Mar 2026 17:33:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8FAFB6B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 17:33:35 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 27AA6B855C
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 21:33:35 +0000 (UTC)
X-FDA: 84527826390.13.41913B1
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf26.hostedemail.com (Postfix) with ESMTP id 55E1B14000E
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 21:33:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HilA6hXG;
	spf=pass (imf26.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773092013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rdIdQECuuDl6/Ar1yEpr/74GArV/vN6WZaGFta6VVEM=;
	b=HIVqe5hvJIXHZcBNJ5k5nIpM9cyMvgRfB8p2CX+PYluL20SYLHN6I2DPfT75hu3m5pisDM
	PdLfXhXJy1S0HRBPRDkibpdFsqhYTUGwHXV+xwH52hfkVUFZ6XGcWw+8NNTV+i+lN1QVDS
	+ucZOV5hqIFgAbK895DfN718fJcViD8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HilA6hXG;
	spf=pass (imf26.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773092013; a=rsa-sha256;
	cv=none;
	b=fJhfLg16QW9Z1ut6J+yf5unx2cgvCU7S8t939wmnWZfdqeo3q8IbkadQdPNtU/t2yH6nBy
	KsuOsjxjFfpsAB7oC1Lsm7Vdp2kbbOAWUJ789WVRaRF8rwCzJA8ykGF5FanLcFkJxT+umI
	E/CQguNgA+z8jVCMKcZDUOuVdEK6wys=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773092010;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rdIdQECuuDl6/Ar1yEpr/74GArV/vN6WZaGFta6VVEM=;
	b=HilA6hXGBS3zlK+1DJFkasUJrC0tswqKYMhZWKCAiaIEc2Egp+H0cvGUVM0xZu3ODgB951
	JUlv+ib/MdrGbUsFxrOEB1lSez7AepQYHC/Pvh1Gc4MJ1WSuo97JCC338RbrmNabeyxyIK
	fJ/df6cmzuFMGm5fFy3xj/H8Mslldow=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: lsf-pc@lists.linux-foundation.org,  Andrew Morton
 <akpm@linux-foundation.org>,  Tejun Heo <tj@kernel.org>,  Michal Hocko
 <mhocko@suse.com>,  Johannes Weiner <hannes@cmpxchg.org>,  Alexei
 Starovoitov <ast@kernel.org>,  Michal =?utf-8?Q?Koutn=C3=BD?=
 <mkoutny@suse.com>,  Hui Zhu
 <hui.zhu@linux.dev>,  JP Kobryn <inwardvessel@gmail.com>,  Muchun Song
 <muchun.song@linux.dev>,  Geliang Tang <geliang@kernel.org>,  Sweet Tea
 Dorminy <sweettea-kernel@dorminy.me>,  Emil Tsalapatis
 <emil@etsalapatis.com>,  David Rientjes <rientjes@google.com>,  Martin
 KaFai Lau <martin.lau@linux.dev>,  Meta kernel team
 <kernel-team@meta.com>,  linux-mm@kvack.org,  cgroups@vger.kernel.org,
  bpf@vger.kernel.org,  linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Reimagining Memory Cgroup (memcg_ext)
In-Reply-To: <20260307182424.2889780-1-shakeel.butt@linux.dev> (Shakeel Butt's
	message of "Sat, 7 Mar 2026 10:24:24 -0800")
References: <20260307182424.2889780-1-shakeel.butt@linux.dev>
Date: Mon, 09 Mar 2026 14:33:22 -0700
Message-ID: <87sea8zo0t.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 55E1B14000E
X-Rspamd-Server: rspam08
X-Stat-Signature: j1sanriofkupwm43gnyakikudr7js9eo
X-HE-Tag: 1773092013-264974
X-HE-Meta: U2FsdGVkX195gPI9lSFqj7Al8T1VIgF4KxQ/Z7TOU/2Ph8BLERzfAyKRYrUJfruV2BjocLc+URJUeDFcl3M5o64gsQVAyZgpAY2vmIwc3Sg8woeeICKpOEYwVnWWuasilZHANwuA3HInweSQybguZ/H/9EkAUvYRqj6O393dWv3k2kEwFl8ZMBTFB1T3aU2j+Y4YGdgSAZeCZY7joyY8FlH7hT9VSHPC5qTWRxHcAALm5wfb5/n5G+yRHzB5O/HjjkQaJb4chi6C+2g1cmmQEsIRzV1k4fNWCByvA8uLNXxKDmH1U8rIc6JhI+FYHA2TWIQrgBd3v1/xUSUW9bDz7kvUYRo53mH+EXQdSwAxmHrQZB+oBAvv1lbtwE3ncN3aYrS0zpEGlNIF3Ga0TunPrpEqBWjiUzdRpAhks1cMd7L5J5swgF7tOCZGpBKvPd4fAJWNN6JjgtwAxqylZRzZkrZHwewYWEVwPkZwfefAH1bx7tV7GJNcy9oYLIRgC/17IIb7L8+9x62aSkDPpdyf6GWnr6p07iDMoqAd5plYDeGyxC84jPKslIJzHACHGERls7Ehbf9rVKmVOuo+Q0A6cgOzDTmWGhSxBX4avEL8lP1xRVxEcFGn+XvxHopOLxwraUJOu4h9LaQkI76kGBxKQbnWlAj6EWc2KH5t0L4SubHYW+DUhQ8aDJBm4YQmr1HY/+Ux55/1UH9dBlPgql55eeVT+wr814HrS6SnbdDMt4jzM5XhXWCXcL/ZKVyPC8eSoCaVlDMC2gTic1muJlJLAuV920iQ6eJNTsw/P7MX5Hs1WdM9JqeJ/G01jH2dTMdaAiDEm/DK+q+JIw2sxcMmhSCareznUfD77DowhUVQ7a4tZnz0lpra6CzIPDh22wBUQhVg7Q8CVUL1pSLN3c7q3v3uAOg76A9k7jtwYJb029AWAW4oy5TcHD9AFGAip/NX79BA6oPz+e1xuouqKk3
 0D3fxTOf
 GKK4HJnNRBuphojBXykH9Oeci42GGksqhEkYkZ+2CIQs8KdBMELe8s7YICwMnBihCwVPmOivM+2FNI7DGrC6Yg4Pzzw068YcPcQQXiPhvDRXusJ48szlmFlrHUmpmRJilH7MFbLezFC6WBTtEObOCWXAqg/hp/alcA+9J0G1zM9kCZkPPG3GPs8kQF/DsFRI1RslGXEW+aQznSEs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Shakeel Butt <shakeel.butt@linux.dev> writes:

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
>
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
>
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
>
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
>
> Shared Memory Semantics
>
> With more flexibility in limit enforcement, the kernel should be able to
> account for memory shared between workloads (cgroups) during enforcement.
> Today, enforcement only looks at each workload's memory usage independently.
> Sensible shared memory semantics would allow the enforcer to consider
> cross-cgroup sharing when making reclaim and throttling decisions.
>
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
>
> Putting It All Together
> -----------------------
>
> To illustrate the end goal, here is an example of the scenario I want to
> enable. Suppose there is an AI agent controlling the resources of a host. I
> should be able to provide the following policy and everything should work out
> of the box:
>
> Policy: "keep system-level memory utilization below 95 percent;
> avoid priority inversions by not throttling allocators holding locks; trim each
> workload's usage to its working set without regressing its relevant performance
> metrics; collaborate with workloads on load shedding and memory trimming
> decisions; and under extreme memory pressure, collaborate with the OOM killer
> and the central job scheduler to kill and clean up a workload."

This is fantastic, thanks Shakeel!

I'd be very interested to discuss it! I suggested a somewhat
similar/related topic to the bpf track (bpf use cases in mm), we might
think of joining them.

Thanks!

