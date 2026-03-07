Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D203DF55104
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 18:24:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C09796B0005; Sat,  7 Mar 2026 13:24:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB6FB6B0088; Sat,  7 Mar 2026 13:24:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC2F16B0089; Sat,  7 Mar 2026 13:24:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 99F9B6B0005
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 13:24:38 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2C7AF160146
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 18:24:38 +0000 (UTC)
X-FDA: 84520092636.23.D35C37F
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 403D9100006
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 18:24:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Yr93vZIU;
	spf=pass (imf05.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772907876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3t0Kg5Rp4+B0pW4g3HfgV1XxcRBiIIV6pjcS9WKTZpo=;
	b=vFWR/12Z9A3P2GK9PHswJ8nQZfQPo50/Ow9ppKI/P1RxQAFejSgpDjgrhZOFJURb3PY1+m
	Eo0LNDRUZuzt7sa1CTz3HUvQhdVglslRvbJ9oX3gqE5XnzttCqRU9M0NoFf3jHrlPueO7i
	57bK8yvgu9Y7gInV8zTNzYdsQ9WjJ4o=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Yr93vZIU;
	spf=pass (imf05.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772907876; a=rsa-sha256;
	cv=none;
	b=39nW3pMXZxL1GnPLHVdMPdo7Mq2XnEmm9klhedf3HO5aw0aLbFcQcGbGXd9IdbWjtHk8Bv
	6+zCxvxp13coiBGvFERMVTJvYCC1W4/PW5EoM8o+nKMFr+nj8Xj/zmT/zxYEl8+Ik3nX3g
	pRUmimQ29IB7dOws4mm7MEWgjUaglt8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772907872;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3t0Kg5Rp4+B0pW4g3HfgV1XxcRBiIIV6pjcS9WKTZpo=;
	b=Yr93vZIU/9FTq2N3W+CLFQpHOnWJOoOlHH0hv+nked4gC1lopvAg3gisKJWSx/GXwTm623
	kZHWTqT0Zvdld/dL4DfMdRb3yCqk0/aKzDLEgXl13ADcsVB1ZU3bhEIB7STp0H3bip+rHz
	d2djOnWQdt2ey4gh2IEdRiJqzYYJvTg=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: lsf-pc@lists.linux-foundation.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Alexei Starovoitov <ast@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hui Zhu <hui.zhu@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	Muchun Song <muchun.song@linux.dev>,
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
Subject: [LSF/MM/BPF TOPIC] Reimagining Memory Cgroup (memcg_ext)
Date: Sat,  7 Mar 2026 10:24:24 -0800
Message-ID: <20260307182424.2889780-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 403D9100006
X-Stat-Signature: a47wewbwdj91afhwebequx656b3ef7px
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772907875-216429
X-HE-Meta: U2FsdGVkX1+wMa318OmqLyTuf7G0Dix343ZlKiFQY9+TZn5DLYDZBZyBB0OJXk20ubAd/Tl3HXpJxzweznBuJhMSEOt+ytdt35XyBv/Gs98BW6M+NlI/3SLKBoXNHdTMy7jgRdUcoL9CySZvb/SivELLCA2mhe7cjjPhmgPDOsC8CevSDvl6vVXWaSUcfbtNB4/EAki7yi3jGjvkZ8ButDaxxXpxGLhoDJuUMjSdyJt9qh2NAshpA6mNPAczBqcSh08egwqOeguXhUwcqszvmZlLvCCPqHmDMKxNKG735sZR8h0LgTmbECeAr4KU++sdY7aPRyr94qaJ2+ORX4WO580NfPiYH92xfoI3/W0mIl5DBI50VmquocE/rrfn3PBmeo9s1RuLqci1fhpZ9FsdHxBfZ2RKkAxvZu899yhWGXf7ZfcXET3LquiBGsbj6C8fvJ9p6Svef/Rjg39gGnxq7AH54aO2jI1F1ayfnmcI8hSRawsQZYdzeKujF+jKMS73yvt1jOJnlTszO5R+HYsj7nH1eVv3PHG+nYKYMydtRWZeiRBHDi74jt/Vwum7VxB/wxm6OHO9WDCu/LQbh0AZzYuIYDINlrYa0c8L/2yoi6Am9gkAVW/9j9onqRQ8jndw9b/JdZuHaKbi0Mb4PFZN7JbZBohMSLpVRAB2fdJkvcqespRXeuHKJBeLjoR55NhwDwXUzzzbOowxedo7T89fE43EE6KqdJxhenFKmDSENShMd6G1+aIy/MVt0+gMEAl9tGkVbv8rA3Lxv3T1zXTqM661KJQjn0EfbtHgc5nDKIfPo8dK0brrcgDIfBdrRq1Wv/MxTMEi4tWdOSOOS3nS5O2Knwi914WmJUByx9um1HjsSttI86QA/1+T9bkUIiH8N/H39LiiOrYi50xTJ0xh8UmB+7WoC60Bw2GZhK4BiAqSOB6O91vvJJGxgKdf8flV9cZthJZdi8wNwx/Mim8
 SGN0fTF8
 WePD30+GP+9Xb8CinJOu4m7uVj+kc2bDVVkH545yVbOk7s2SqkvfJrWHxxC7Btx5Tq/eTtUeQwXhj4ylufec8DHocS9eRGv+zrPe1uzV0VbiC5snqT//5M8OUKicZw1OV76/UytwqXiKWO7evoME3r4OdZuKFmz7pxn96wxt5o4oVvfd7O6+aTuYDKy210N/1P4ksaUwdIiiSRqjSZ65GNy4Mv9NMhv3nziHfw7hiflSWOuZk3/xbAL8qsnUbgWXvni2vC/fkkO+gIcE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Over the last couple of weeks, I have been brainstorming on how I would go
about redesigning memcg, taking inspiration from sched_ext and bpfoom, with a
focus on existing challenges and issues. This proposal outlines the high-level
direction. Followup emails and patch series will cover and brainstorm the
mechanisms (of course BPF) to achieve these goals.

Memory cgroups provide memory accounting and the ability to control memory usage
of workloads through two categories of limits. Throttling limits (memory.max and
memory.high) cap memory consumption. Protection limits (memory.min and
memory.low) shield a workload's memory from reclaim under external memory
pressure.

Challenges
----------

- Workload owners rarely know their actual memory requirements, leading to
  overprovisioned limits, lower utilization, and higher infrastructure costs.

- Throttling limit enforcement is synchronous in the allocating task's context,
  which can stall latency-sensitive threads.

- The stalled thread may hold shared locks, causing priority inversion -- all
  waiters are blocked regardless of their priority.

- Enforcement is indiscriminate -- there is no way to distinguish a
  performance-critical or latency-critical allocator from a latency-tolerant
  one.

- Protection limits assume static working sets size, forcing owners to either
  overprovision or build complex userspace infrastructure to dynamically adjust
  them.

Feature Wishlist
----------------

Here is the list of features and capabilities I want to enable in the
redesigned memcg limit enforcement world.

Per-Memcg Background Reclaim

In the new memcg world, with the goal of (mostly) eliminating direct synchronous
reclaim for limit enforcement, provide per-memcg background reclaimers which can
scale across CPUs with the allocation rate.

Lock-Aware Throttling

The ability to avoid throttling an allocating task that is holding locks, to
prevent priority inversion. In Meta's fleet, we have observed lock holders stuck
in memcg reclaim, blocking all waiters regardless of their priority or
criticality.

Thread-Level Throttling Control

Workloads should be able to indicate at the thread level which threads can be
synchronously throttled and which cannot. For example, while experimenting with
sched_ext, we drastically improved the performance of AI training workloads by
prioritizing threads interacting with the GPU. Similarly, applications can
identify the threads or thread pools on their performance-critical paths and
the memcg enforcement mechanism should not throttle them.

Combined Memory and Swap Limits

Some users (Google actually) need the ability to enforce limits based on
combined memory and swap usage, similar to cgroup v1's memsw limit, providing a
ceiling on total memory commitment rather than treating memory and swap
independently.

Dynamic Protection Limits

Rather than static protection limits, the kernel should support defining
protection based on the actual working set of the workload, leveraging signals
such as working set estimation, PSI, refault rates, or a combination thereof to
automatically adapt to the workload's current memory needs.

Shared Memory Semantics

With more flexibility in limit enforcement, the kernel should be able to
account for memory shared between workloads (cgroups) during enforcement.
Today, enforcement only looks at each workload's memory usage independently.
Sensible shared memory semantics would allow the enforcer to consider
cross-cgroup sharing when making reclaim and throttling decisions.

Memory Tiering

With a flexible limit enforcement mechanism, the kernel can balance memory
usage of different workloads across memory tiers based on their performance
requirements. Tier accounting and hotness tracking are orthogonal, but the
decisions of when and how to balance memory between tiers should be handled by
the enforcer.

Collaborative Load Shedding

Many workloads communicate with an external entity for load balancing and rely
on their own usage metrics like RSS or memory pressure to signal whether they
can accept more or less work. This is guesswork. Instead of the
workload guessing, the limit enforcer -- which is actually managing the
workload's memory usage -- should be able to communicate available headroom or
request the workload to shed load or reduce memory usage. This collaborative
load shedding mechanism would allow workloads to make informed decisions rather
than reacting to coarse signals.

Cross-Subsystem Collaboration

Finally, the limit enforcement mechanism should collaborate with the CPU
scheduler and other subsystems that can release memory. For example, dirty
memory is not reclaimable and the memory subsystem wakes up flushers to trigger
writeback. However, flushers need CPU to run -- asking the CPU scheduler to
prioritize them ensures the kernel does not lack reclaimable memory under
stressful conditions. Similarly, some subsystems free memory through workqueues
or RCU callbacks. While this may seem orthogonal to limit enforcement, we can
definitely take advantage by having visibility into these situations.

Putting It All Together
-----------------------

To illustrate the end goal, here is an example of the scenario I want to
enable. Suppose there is an AI agent controlling the resources of a host. I
should be able to provide the following policy and everything should work out
of the box:

Policy: "keep system-level memory utilization below 95 percent;
avoid priority inversions by not throttling allocators holding locks; trim each
workload's usage to its working set without regressing its relevant performance
metrics; collaborate with workloads on load shedding and memory trimming
decisions; and under extreme memory pressure, collaborate with the OOM killer
and the central job scheduler to kill and clean up a workload."

Initially I added this example for fun, but from [1] it seems like there is a
real need to enable such capabilities.

[1] https://arxiv.org/abs/2602.09345

