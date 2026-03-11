Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7AB3FD0644
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 07:20:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85F946B0005; Wed, 11 Mar 2026 03:20:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 803356B0089; Wed, 11 Mar 2026 03:20:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7438A6B008A; Wed, 11 Mar 2026 03:20:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 53AAF6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 03:20:19 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0AB99C251D
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 07:20:18 +0000 (UTC)
X-FDA: 84532933716.30.287488F
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0DF1620004
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 07:20:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=B4SoRGum;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773213616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fZMD/sJA4LMvqV3IqO8URaQyrG4pgARgby5cxcACKCs=;
	b=a5Ttq8QLokKQtykiVlHCOlhGjszKQ8QV+Nfkq/fDoayEo72YODIBE5xW6E/V/PPUmuwNBM
	5xCEHjEvQ2fzxWLVnrFNmfTJCNxGgFqFQCSE2Lc1jwMyn576i32vFEYvdUSxVZB3vzxpQ1
	J866RM8aSlltvJq0DdV0z2XDxbMtOWI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=B4SoRGum;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773213616; a=rsa-sha256;
	cv=none;
	b=8ZRu2DFp/tO5T6HBaylaapobXRSPRSsh6Adcy305KD051AeYqlQ9uJfQXv4N9eDLCiNFfB
	GKQHvCvb3ompEw0RngDrVfL8a5ivrQsjchezwT9gVZo9OL5kBHENR2fLforEY8E1K0FPR1
	qrNc0rCQJ6acW4H/rbuABc2WnmZuQfE=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773213613;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fZMD/sJA4LMvqV3IqO8URaQyrG4pgARgby5cxcACKCs=;
	b=B4SoRGumncYXIg1Q5KjqNrXefOYWre+2JGAyUd0dSia0fADwuCqmUYy/hZbuhP6aQXP0C+
	aYdnnMFywzIJM7L3qVKZ2yZiLSg2xSdfmhps5VN2N+3vHBPowxrbjOuz53+6JCoRXJMni9
	mn3M4WREOkjNz1zRO87BIPZFPnRfY6Q=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.400.21\))
Subject: Re: [LSF/MM/BPF TOPIC] Reimagining Memory Cgroup (memcg_ext)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260307182424.2889780-1-shakeel.butt@linux.dev>
Date: Wed, 11 Mar 2026 15:19:31 +0800
Cc: lsf-pc@lists.linux-foundation.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Tejun Heo <tj@kernel.org>,
 Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Alexei Starovoitov <ast@kernel.org>,
 =?utf-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Hui Zhu <hui.zhu@linux.dev>,
 JP Kobryn <inwardvessel@gmail.com>,
 Geliang Tang <geliang@kernel.org>,
 Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
 Emil Tsalapatis <emil@etsalapatis.com>,
 David Rientjes <rientjes@google.com>,
 Martin KaFai Lau <martin.lau@linux.dev>,
 Meta kernel team <kernel-team@meta.com>,
 linux-mm@kvack.org,
 cgroups@vger.kernel.org,
 bpf@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <3ECC9B38-6C1A-4F60-9C18-98B7A1A56355@linux.dev>
References: <20260307182424.2889780-1-shakeel.butt@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 0DF1620004
X-Stat-Signature: yj16d4u3i517nxy3uedkd4geo8j11wue
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773213615-565500
X-HE-Meta: U2FsdGVkX198Sj2UfeyRbZAQHDVKT5gV6dOPo1SaYEMqS4oATVLVRY2wmNn0FvwDwd/899qP2K1NHcVC1eFq6ufZE07Ha76C5HxJtqcyVujZHxXPbgyq5szShmAgTq6ISZNtiaWl9u/Rn0oEE+t2BLQsPe3mRzsBLOOU0dkODhig1/ymBQQ5FFPGg5I+WhaPAvueRohelBArfdvVoq3klzUty4IctcDIXNo5asP7itXbient/9jlfz4sH+6NNM1iP1sdY8jOFMhC94E7LT3E2xCG48SFCnFjOBfwqHpnCsEKLwOOw29uybHkjsvbfT3nr8u8EPJ1WCcoqdaarF2N95Lw1hXEp9BKYKKIewqk47j/L4KNKuSYA1nVqT6FaFzKHwkKVGpNuRqVrdC8i/R+G4NClM+IxWPU7Ty5XDZKf50tDl6VrjQQlRuQqv5FyDlBfZkzGCs2E2HIk4Qhgly7qqKqjvYW2C0nMnI36d7lxAcQWdqsihf+NcqfvJOxscoe6NRwmMCBD3j6rHs8/X7fwGeXlzOfkBkOsTbJ+2q/oefvnRVfPWt1LSAIBtogTFLAz1LT1D/wm5bWQ1fzHwvrTHDHGo7rzMk3Y1GHfEobawA8V/jJMToa+G0PkoGUz4GxziE3slV2UYdegAjQm80pnXGVx+TYCXtwykduO5YxPOYuABCJAgygYDV8lIkxHwoe0S/sMsOir+xOJL4+NL2v5ZoZUKF2EArFWawUQwdBbujvXxsiPLKRj6Pr4hajEbVdGWJevC26rLjKAy+Hb2O3tM14gzbCbYjrpinFf0XeSI4yBtUiRsaWRA7akKPJ0ogIitf5lCoRQd0LAWW2CaOFFZZaEHFmfjOTTzYlF9B1p3oA6XVlol2FEjh6YadiDSnIaiqzGsvfkrovxqWRDrOVzMNKcHRCi6NTfTkLiTThPG2cQwPVJEdHaKDOJn0FusrczaZ3iwANyvpAahsBtX0
 jd2kdqOY
 SqEWyzW3EPb7pNB/UuK7xN0kAm5SZj6UixWMTXGoLRl9vFFnQLiKbVks/F9BkF9ls/ePNbTW03N4em8x4lGzNWL7LH9xsr/AMaZAdmp1oPcSvxpRU87/OlDsbDnrtjc5WQQJ7Qzs7Sc3+txxY+pqcyX2NUVeaMQfs/mW+TTE48rqcrboHvHJcz2l80tI46dHpGj4Uu+tPlU3yfSDg37Zat+49vEL1/Zc66DrvirRVzU+vUtgECHZiM4bsGI8ULg7eN0DrgdwJvbebnPdSB4KUZUavRi+TSrpjWZMyKruIHfM6xAjvPs/wHY6L0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Mar 8, 2026, at 02:24, Shakeel Butt <shakeel.butt@linux.dev> wrote:
>=20
> Over the last couple of weeks, I have been brainstorming on how I =
would go
> about redesigning memcg, taking inspiration from sched_ext and bpfoom, =
with a
> focus on existing challenges and issues. This proposal outlines the =
high-level
> direction. Followup emails and patch series will cover and brainstorm =
the
> mechanisms (of course BPF) to achieve these goals.
>=20
> Memory cgroups provide memory accounting and the ability to control =
memory usage
> of workloads through two categories of limits. Throttling limits =
(memory.max and
> memory.high) cap memory consumption. Protection limits (memory.min and
> memory.low) shield a workload's memory from reclaim under external =
memory
> pressure.
>=20
> Challenges
> ----------
>=20
> - Workload owners rarely know their actual memory requirements, =
leading to
>  overprovisioned limits, lower utilization, and higher infrastructure =
costs.
>=20
> - Throttling limit enforcement is synchronous in the allocating task's =
context,
>  which can stall latency-sensitive threads.
>=20
> - The stalled thread may hold shared locks, causing priority inversion =
-- all
>  waiters are blocked regardless of their priority.
>=20
> - Enforcement is indiscriminate -- there is no way to distinguish a
>  performance-critical or latency-critical allocator from a =
latency-tolerant
>  one.
>=20
> - Protection limits assume static working sets size, forcing owners to =
either
>  overprovision or build complex userspace infrastructure to =
dynamically adjust
>  them.
>=20
> Feature Wishlist
> ----------------
>=20
> Here is the list of features and capabilities I want to enable in the
> redesigned memcg limit enforcement world.
>=20
> Per-Memcg Background Reclaim
>=20
> In the new memcg world, with the goal of (mostly) eliminating direct =
synchronous
> reclaim for limit enforcement, provide per-memcg background reclaimers =
which can
> scale across CPUs with the allocation rate.

Hi Shakeel,

I'm quite interested in this. Internally, we privately maintain a set
of code to implement asynchronous reclamation, but we're also trying to
discard these private codes as much as possible. Therefore, we want to
implement a similar asynchronous reclamation mechanism in user space
through the memory.reclaim mechanism. However, currently there's a lack
of suitable policy notification mechanisms to trigger user threads to
proactively reclaim in advance.

>=20
> Lock-Aware Throttling
>=20
> The ability to avoid throttling an allocating task that is holding =
locks, to
> prevent priority inversion. In Meta's fleet, we have observed lock =
holders stuck
> in memcg reclaim, blocking all waiters regardless of their priority or
> criticality.

This is a real problem we encountered, especially with the jbd handler
resources of the ext4 file system. Our current attempt is to defer
memory reclamation until returning to user space, in order to solve
various priority inversion issues caused by the jbd handler. Therefore,
I would be interested to discuss this topic.

Muchun,
Thanks.

>=20
> Thread-Level Throttling Control
>=20
> Workloads should be able to indicate at the thread level which threads =
can be
> synchronously throttled and which cannot. For example, while =
experimenting with
> sched_ext, we drastically improved the performance of AI training =
workloads by
> prioritizing threads interacting with the GPU. Similarly, applications =
can
> identify the threads or thread pools on their performance-critical =
paths and
> the memcg enforcement mechanism should not throttle them.
>=20
> Combined Memory and Swap Limits
>=20
> Some users (Google actually) need the ability to enforce limits based =
on
> combined memory and swap usage, similar to cgroup v1's memsw limit, =
providing a
> ceiling on total memory commitment rather than treating memory and =
swap
> independently.
>=20
> Dynamic Protection Limits
>=20
> Rather than static protection limits, the kernel should support =
defining
> protection based on the actual working set of the workload, leveraging =
signals
> such as working set estimation, PSI, refault rates, or a combination =
thereof to
> automatically adapt to the workload's current memory needs.
>=20
> Shared Memory Semantics
>=20
> With more flexibility in limit enforcement, the kernel should be able =
to
> account for memory shared between workloads (cgroups) during =
enforcement.
> Today, enforcement only looks at each workload's memory usage =
independently.
> Sensible shared memory semantics would allow the enforcer to consider
> cross-cgroup sharing when making reclaim and throttling decisions.
>=20
> Memory Tiering
>=20
> With a flexible limit enforcement mechanism, the kernel can balance =
memory
> usage of different workloads across memory tiers based on their =
performance
> requirements. Tier accounting and hotness tracking are orthogonal, but =
the
> decisions of when and how to balance memory between tiers should be =
handled by
> the enforcer.
>=20
> Collaborative Load Shedding
>=20
> Many workloads communicate with an external entity for load balancing =
and rely
> on their own usage metrics like RSS or memory pressure to signal =
whether they
> can accept more or less work. This is guesswork. Instead of the
> workload guessing, the limit enforcer -- which is actually managing =
the
> workload's memory usage -- should be able to communicate available =
headroom or
> request the workload to shed load or reduce memory usage. This =
collaborative
> load shedding mechanism would allow workloads to make informed =
decisions rather
> than reacting to coarse signals.
>=20
> Cross-Subsystem Collaboration
>=20
> Finally, the limit enforcement mechanism should collaborate with the =
CPU
> scheduler and other subsystems that can release memory. For example, =
dirty
> memory is not reclaimable and the memory subsystem wakes up flushers =
to trigger
> writeback. However, flushers need CPU to run -- asking the CPU =
scheduler to
> prioritize them ensures the kernel does not lack reclaimable memory =
under
> stressful conditions. Similarly, some subsystems free memory through =
workqueues
> or RCU callbacks. While this may seem orthogonal to limit enforcement, =
we can
> definitely take advantage by having visibility into these situations.
>=20
> Putting It All Together
> -----------------------
>=20
> To illustrate the end goal, here is an example of the scenario I want =
to
> enable. Suppose there is an AI agent controlling the resources of a =
host. I
> should be able to provide the following policy and everything should =
work out
> of the box:
>=20
> Policy: "keep system-level memory utilization below 95 percent;
> avoid priority inversions by not throttling allocators holding locks; =
trim each
> workload's usage to its working set without regressing its relevant =
performance
> metrics; collaborate with workloads on load shedding and memory =
trimming
> decisions; and under extreme memory pressure, collaborate with the OOM =
killer
> and the central job scheduler to kill and clean up a workload."
>=20
> Initially I added this example for fun, but from [1] it seems like =
there is a
> real need to enable such capabilities.
>=20
> [1] https://arxiv.org/abs/2602.09345


