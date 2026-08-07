Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24BC5C2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 20:21:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 737F86B0088; Fri,  7 Aug 2026 16:21:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E8A16B008C; Fri,  7 Aug 2026 16:21:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B4326B0092; Fri,  7 Aug 2026 16:21:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 257DE6B0088
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 16:21:05 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2849A1C0137
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:21:03 +0000 (UTC)
X-FDA: 85075592406.29.01D8376
Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6F9F5100006
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:21:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kIgVk5RM;
	spf=pass (imf14.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786134061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OG7Zox/EULKY3yZgjkLir0Fh0uNyC4YIaQWO7jxGtO8=;
	b=D43QDRA+Y9cyJF0uaEOflWAK1U3EvcLpFPsFASGrVwfkaUbMJSpC0frOWcX6NoPUhnz5GV
	LzS/mbjB9fy7R2szUv2A0p+ES66DrEQpxsvqct+eSKnlXCCtDEsfgju6HEokETe0o7HwqN
	ov53yuA+n+lx8VaNwhA3N4VKe1axNC4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kIgVk5RM;
	spf=pass (imf14.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786134061;
	b=jM832M1gXY1lDXnqCIKUqRwu8OOsLf49lNtT2KI2E5N0Os4ZGkZLLdGQBlS+ccmcz5hfKL
	ivbYtV2isLjeqsRV/FjbL7v5lNeNm5tshRq+BqQVHtDEWZFF1WFurvf70o5J16e3HKdySV
	4EiDNZfGgPeXHrk/lud1rVyurS5MUNs=
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-6b0496f4bbcso4395eaf.0
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 13:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786134060; x=1786738860; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OG7Zox/EULKY3yZgjkLir0Fh0uNyC4YIaQWO7jxGtO8=;
        b=kIgVk5RM5Cb52wtiQi7DLXqICkxRGLAGpsdKVoP0maMZclTpTnL9FIp77xec3LhAwd
         GDUlvjLl6bVrrPwv5p5zLyVm7r0qU7x2EbesZu95JuBIHj+/eWVdwIh0/UXSzchUQvu7
         rbfmL6OkffKdnNDXXs0V9ncpPhhzDgaOFqXKolQUADgm8GEq7quiZvWNk89bOC4Oib3L
         1U+aNldnO1L4X4jVZ+B+S4VKlKQ6yKSu8VqNmAOMbVtuHa27EHGWJAghZY3OWKlJSxYc
         Zs86GkfyfM2Ex9lhF93LYSyct0bNRr/YzhM0Y+6oZ3URadI00nxVgfP4W9Lgbj2BSO0C
         19pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786134060; x=1786738860;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OG7Zox/EULKY3yZgjkLir0Fh0uNyC4YIaQWO7jxGtO8=;
        b=gwUsH3RKzse7vvJCtsKretDQ24fHakWACTpxBXJm/DeQYJvCZNa/bAH70OJsM8mhMY
         19S6YDyGVwdhtvXuHwzjT3jcF3mpkdNjJgWux1NBixD43oM4lLqSUz5YaJOEeBiH/BXq
         z0Xd77yIWiHfQa5i7gjzxSr7D2ftZjF/xWajyPM7QQQxoAsw1CjUiANBk/G1NO7X6zBJ
         Sz18bTK8Ndz6YQEnNYQrztG7+vxRNo/4f6nxoB4ynjhLzjtqMe/8PUocDTWv29my5dsF
         q9x9CXmQkqaHuvcMf73cz/Q+CAhxfYg2vgMkkyBT8dzEjA78JOnB3dDi3e4trbQjtJZu
         m5sQ==
X-Forwarded-Encrypted: i=1; AHgh+RqBui6Py8fVV/GlavcGZdtH8SoyuCUum8NV+qF+ZbbBkJGLPvEMrhdv0oD7wUY0WOJboTr/jvdBWA==@kvack.org
X-Gm-Message-State: AOJu0YxVpZi/nT2RJtHAGI4NWOhp149+rKbt7AFo8S7XoYj7Yhm2ItFv
	uxmDxiXYx1gVWdBdNXE+PAYrKQet+3faiklfzcyvF8rXBZb0aaGxNpQT
X-Gm-Gg: AR+sD11a+HXLCy/TgG7DQKBOsMIf0j+8kYqWWoZp+lAJhuArJqd6+9rjzxLNj0Bmd2b
	2LLyFoKlaubDMpm9CEJRobb5q1eNu7YOAti2P7IB6xvOOuCTf2rOMBTHhKg2aZbbladDCQjaTDm
	gHrAHmcl4hXTyUm16FHmSUu7HukG3DCj7gDQmTlsmJ/pz9PSupgXucbC6F2SaRp0UNq/FTQklQR
	XgmBmlq7yIcce/ecLGVnwWGHiHvGE8qEGhMh0eNeoCLke8RIl41QH3kv9LBZx3vHmDbjOinFi0F
	mLxKP71o6EpopP4xujWFLveUS5XgCbFMzYobOisPNoUFLjyybzi0cmpJ+r9TJDgPgzfejeD3BG7
	xTuhecZ07Cr3xqjLlM5GyLnoTuql3Vy+ICgTEZfLicdJ49axZvJCNDn3KIbpaUR0imQr29g7A2q
	133TUb5z2zBP8+G5Xd+/BkzoeNIvrNjO1c2gkyicr6HuBBAWkkpxSiRMc9d52N5yW/OJ8DIIexy
	dMpxH3dhP2CrC8lUQ==
X-Received: by 2002:a05:6820:8cc:b0:6aa:d97f:4564 with SMTP id 006d021491bc7-6b042151708mr1639179eaf.28.1786134060230;
        Fri, 07 Aug 2026 13:21:00 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:d::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-459f1d793c9sm2788490fac.9.2026.08.07.13.20.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 13:20:59 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Gregory Price <gourry@gourry.net>
Cc: Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Barry Song <baohua@kernel.org>,
	Ben Segall <bsegall@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Byungchul Park <byungchul@sk.com>,
	David Hildenbrand <david@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kairui Song <kasong@tencent.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Peter Zijlstra <peterz@infradead.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Rakie Kim <rakie.kim@sk.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Wei Xu <weixugc@google.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Yuanchu Xie <yuanchu@google.com>,
	Zi Yan <ziy@nvidia.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [RFC PATCH v3 00/14] Introduce tiered memcg limits
Date: Fri,  7 Aug 2026 13:20:43 -0700
Message-ID: <20260807202059.2620949-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: refqc9qqcpsgkgb7dz7pp6xh9s64skck
X-Rspamd-Queue-Id: 6F9F5100006
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786134061-995947
X-HE-Meta: U2FsdGVkX19jCfo6m8fu0TlZWUwB3jHgkWy7Sygt00MlMY0Og/TI3O93dFOmBqGWAx8Qd8bdSesw0/jMVs7MPu/TTI1NBdyfOPD6KXq/k4xvxDaNvQsiy7DaD8vDWUXD7iwt7AcngPmBVTWhYDehWxif/we+Ew0uuq1oTPsCTPm+3zjC1a4NmqPE1DA6RQ7e+BCzzjWt4rcdUHM3VOa1DjEkNGtzzLq+lrlYOT0bXDVZRQ6av5lSp6IGg6d6mpW6XmSFleol6/GkW2fSkzqXy/y5LwIxeEMBzEe2gNhfRr7kJ2II3NNnxmibVhXXzEW0HYroCkZhtvgpx99pWhMfwfJTb57/Hn5JAfILHGwfcr3zdikUqWNrr9edjTAJuxPhVhlJEIlOmEFH44CagUMfI/CPSsmiiO9EdtA/om0M0mEpeRfI8cxoHf/IebTfGkdnERfE2Vs0gbNSaseAXaKDxv/mf3WT62d//K7IZy+hvGUVcFKXmGb8Z6mBhwtYHBjYzlH0dIjoE8/cs+0xx/auzm/sMz93vL2Isgz4euppxsjBtmie8WUIdAC5Obd0HL6BHIFvL5dMNwccd4v7fu5o9OslNa6UALFAVa2MvrEzq9NBaAd6jn6WFYis4QHNMdTpk/Krd9wTlSxBzbk5fOte1H8nt+RXqoZCOjDLWYSBMfuOsXukWUxX6UoQG+XhW6FlkSTlFk84LQ/MoAJ6175H6E6rcSZV8AbdydwGEaicLsK+s9u+5qmb0qAK1vNuVJLzdA3dn5BqR6n+dD77FE7LQJcJc8SN/Xv1Gq0/IZCpXV/trpuhKWa4zd/tkZti3HvyknwT/fILKroogweyzzKR47Mg3nQ8y/C0CHfJFNGeZOhOdA23zHKrVgGIT/bpD1XPh3pGpU4j8K4gVDhdq3Yh0h2NeP72cThJI4BRaVhXvsOP5irxOFbYAY259OyyVKCq10AVgBbL9t2CEasD3YF
 M/Ve1w4q
 cSalvu7D019htB5Yf25trgzrJeXYFelTOssFiCcI880lw1IkRKGH4fd8XpejCu/34P0sILXCbEKflcsRPyHe/S/8PzuI6v1VRPb5Bm3NYsMBwY160lDJwAmjlNuRdY/zv0qJtzVLAGo+2s+KdQ25E/k8ZnV8okF0N+jFGgg7iFEhEVdjVAMzGp1mOpYmW+Wc70Q6y1SPT5zeP5f6+SQPjwaH2jvRNjtW+QypJMKL0fIhL73QPzZm/wg1WQDym0cjCvve9zNIK4IB66PJWdcQADoATH55PcFeOADBS10ff83Xklyf7iBiHXVT4nVxBWeuueIGjQq7WDVPwQZppuGL5ukTrZXBQY1N53qXgo29r5WbrS1rXB/QaImJMkIPy/hXDrFb1pTQYM9HZTfwkWBbf6EYhFSFKkxY8HIU5ekFBZOSFHsz22cfukW9Mww6cl4judc1nkEZoMFcU+kQzvGOTxTOVuJSUpxK1urXx8+xtbf5WQZ68HQaz7URW0MR3ZZL/oepVfEtLoLcYb68o9i1nix4tgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

INTRODUCTION
============
On machines serving multiple workloads whose memory is isolated with the
memory cgroup controller, it is currently impossible to enforce a fair
distribution of memory placement. memory.{max, high} bounds a cgroup's
total footprint but says nothing about where that memory resides, so a
cgroup that starts first can occupy all of a fast tier, while latecomers
are pushed out to slower tiers.

On systems with tiered memory (e.g. HBM, DRAM, CXL, PMEM, etc.),
memory placement directly maps to performance, meaning memory and
performance isolation breaks down on tiered systems; well-behaved
workloads using less memory than their memcg limits may still hurt other
workloads' performance by hogging more than their "fair share" of memory
on fast tiers. Performance then depends on workload-external factors,
like which other workloads are present on the system and what order they
were launched in.

However, ensuring fairness in memory placement is not free; ensuring
fair memory placement can mean underutilizing fast tiers, entering
reclaim earlier to proactively prevent overconsuming on fast tiers,
and host-level hotness inversion. On lightly-loaded systems, it means
that reclaim happens on fast tiers, even if no other workloads compete
for that memory. For some workloads, this tradeoff can be worth taking
to ensure higher run-to-run consistency and isolation from
noisy neighbors (see USECASES).

Introduce tiered memcg limits, which establish memory limits per-tier
that scale with memcg limits and the system's per-tier capacity.

MECHANISM
=========
memory.{min, low, high, max} are partitioned across the system's memory
tiers in proportion to the tiers' share of the total memory.
For instance, on a two-tier system with 75% of its memory in tier 0:
  - a cgroup with memory.max = 100G has a 75G tier 0 max limit
  - a cgroup with memory.low = 40G has 30G of tier 0 protection

Enforcement limits (high / max) are enforced in five ways:
  - At allocation time, a cgroup's allocation will try to serve a page
    from a tier where it still has headroom.
  - At try_charge_memcg time, a folio that lands on an exhausted tier
    anyways (because of __GFP_THISNODE, mempolicy, or memory pressure)
    triggers targeted reclaim restricted to that tier's nodes.
  - In the background, a tier pushed over its tiered memcg limit by page
    migration or folio replacement gets reclaimed by the memory.high
    worker.
  - Migration (promotion / demotion) now performs a try_charge on
    cross-tier migrations, and will attempt to reclaim the destination
    tier if it breaches the limits.
  - In addition, promotions are ratelimited when they are attempted on
    exhausted memcg tiers.

A few details about the enforcement:
  - Allocation time steering is best-effort and yields to explicit
    allocation requests, like mempolicy, cpusets, and allocations that
    request a specific node (promotion / demotion). If that allocation
    were to push the memcg tier over its limit, enforcement happens at
    charge time.
  - Tier max can be exceeded by demotions, which may force charge
    since they can't (and should not) trigger recursive reclaim.
  - As of this time, the mechanism is completely transparent to the
    user. Booting the system with the "cgroup.memory=tiered_limits"
    boot parameter will enable the feature, with no other interfaces.
  - There are no behavioral or performance effects on systems without
    the boot parameter, since all of the hooks are gated behind a static
    branch that compiles to a no-op. However, there are allocations and
    static variables that we must define unconditionally
    (even though they are not used).
  - Tiered memcg limits are a v2-only feature. A warning is emitted if a
    cgroup v1 user attempts to use tiered memcg limits.

USECASES
========
As mentioned in the introduction, some users may prefer to trade off
total throughput for reduced run-to-run variance:
  - VM hosting services that must provide the maximal performance
    guarantee for any workload present on a host.
  - Database workloads that want to minimize the maximum latency for
    queries hosted on the host.
  - Hosts running memory-isolated sharded workloads that block progress
    until the last shard terminates.
  - Any workload that wants to minimize variance, as a means to gather
    measurable gains in performance over time.

RFC QUESTIONS
=============
  - Should we OOM when we fail to allocate on a given tier?
  - What kinds of observability (if any) do we want?
  - What kinds of user interfaces (if any) do we want?

TESTING
=======
All the tests were run on a 1TB 2-tier 316 CPU machine, with
750G DRAM and 250G CXL. The first benchmark runs 12 containers on the
host, where each container runs an identical pointer-chasing task in a
loop. Each container is 80GB, so DRAM is overcommitted:
    (80GB * 12 = 960GB > 750GB)
I ran 8 trials and aggregated the data. When 50% of the pointers
are kept hot, these are the results:

Mean DRAM usage across the 12 workloads:
+---------+----------+--------+
|         | Untiered | Tiered |
+---------+----------+--------+
| min     | 43.09    | 51.25  |
| max     | 68.54    | 53.03  |
| max/min | 1.59x    | 1.03x  |
+---------+----------+--------+

Mean CXL usage across the 12 workloads:
+---------+----------+--------+
|         | Untiered | Tiered |
+---------+----------+--------+
| min     | 3.05     | 13.98  |
| max     | 21.65    | 14.87  |
| max/min | 7.10x    | 1.06x  |
+---------+----------+--------+

For the tiered system, the deviance from max to min DRAM and CXL usage
is quite low across workloads. What is interesting is that for untiered
systems, there is up to a 7x difference between the cgroup using the
most CXL and the least CXL; there's a clear inequality in how the
resource gets allocated.

This gets reflected in the distribution of the job completion times of
the 12 workloads as well.

Job completion time (s)
+-----------+----------+--------+-------+
|           | Untiered | Tiered | Delta |
+-----------+----------+--------+-------+
| min       |    260.1 |  276.5 | +6.3% |
| mean      |    274.4 |  290.0 | +5.7% |
| max       |    315.0 |  302.6 | -3.9% |
| max - min |     54.9 |   26.1 | -52%  |
+-----------+----------+--------+-------+

SERIES OVERVIEW
===============
Commits 1-3 are preparatory patches. We introduce the new boot
parameter, refactor try_charge_memcg() to make the following charges
easier to follow, and cache frequently-used values like the
node <-> tier mapping.

Commits 4-5 allocate the new per-memcg-tier page_counters for tracking
and set their limits according to the standard memcg limits.

Commits 6-10 track per-tier charges, and introduce the protection and
enforcement mechanisms for min/low/high/max. 

Commits 11-13 further enforce the migration (promotion / demotion) paths
and ensure that we do not introduce unnecessary churn by reclaiming
earlier. 

Commit 14 steers allocations so that we do not accidentally introduce
zone_reclaim_mode-like behavior and immediately reclaim after allocating
on exhausted memcg tiers.

FUTURE WORK
===========
I am currently working on another series [1], which pushes the memcg
cached charges (stock) to the page_counter level, meaning each tier can
manage its own independent stock. This should increase the performance
and simplicity of the code much more.

CHANGELOG
=========
v2 --> v3
- N tier support, instead of toptier vs. rest enforcement
- Max enforcement
- Migration enforcement
- Page allocator steering for exhausted tiers
- Promotion fastpath restriction & throttling

[1] https://lore.kernel.org/all/20260623180124.868655-1-joshua.hahnjy@gmail.com/

Joshua Hahn (14):
  mm/memcontrol: Introduce cgroup.memory=tiered_limits boot parameter
  mm/memcontrol: Refactor page_counter charging in try_charge_memcg
  mm/memory-tiers: Introduce a mapping from nid to tier_slot
  mm/memcontrol: Allocate per-tier page_counters
  mm/memcontrol: Set tier limits proportional to memory limits
  mm/vmscan, memcontrol: Add nodemask to try_to_free_mem_cgroup_pages
  mm/memcontrol: Charge/uncharge tiered memory to mem_cgroup
  mm/memcontrol: Make memory.low and memory.min tier-aware
  mm/memcontrol: Make memory.high tier-aware
  mm/memcontrol: Make memory.max tier-aware
  mm/memcontrol, migrate: Transfer tier charge on migration
  mm/memcontrol: Kick async reclaim on migration and folio replacement
  mm/memcontrol, sched/numa: Gate NUMA promotions into memcg tiers
  mm/page_alloc: steer allocations away from exhausted memory tiers

 include/linux/memcontrol.h   |  75 ++++-
 include/linux/memory-tiers.h |  24 ++
 kernel/sched/fair.c          |   3 +-
 mm/internal.h                |   3 +-
 mm/memcontrol-v1.c           |   5 +-
 mm/memcontrol.c              | 528 ++++++++++++++++++++++++++++++++---
 mm/memory-tiers.c            | 110 +++++++-
 mm/migrate.c                 |  30 +-
 mm/page_alloc.c              |  19 +-
 mm/vmscan.c                  |  25 +-
 10 files changed, 753 insertions(+), 69 deletions(-)


base-commit: 7b25c83e4711038989b5b08a8977fb68468c854e
-- 
2.53.0-Meta


