Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31C5DCD5BD5
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 06:23:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98C816B008C; Wed, 27 May 2026 02:23:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 964D46B0092; Wed, 27 May 2026 02:23:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87A796B0093; Wed, 27 May 2026 02:23:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7766F6B008C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 02:23:46 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 44D6BA0532
	for <linux-mm@kvack.org>; Wed, 27 May 2026 06:23:46 +0000 (UTC)
X-FDA: 84812208852.26.584C86C
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2E07940014
	for <linux-mm@kvack.org>; Wed, 27 May 2026 06:23:42 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779863024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=f5Pi58qbtNBN3p2DzsXwPjeVM4MqJfNllTdLKWTf1QE=;
	b=kdCQIaS/Vvlts1HiE0S+d+XA36vZckTNIVFX82FNtJUvXNWb/nPM5UT1xogqXYSL8Nuaj8
	JeRIpi2FPCPxo/VqC83yJvWl5+ViGdeBiAkWL6rqk2GJ91mmd1B9OiS7bnU0nqqPLd9GpA
	/JzSxcG3TSpOlcJ0MZMs/xeUuFBP5Tc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779863024; a=rsa-sha256;
	cv=none;
	b=M8t5Ksn3/CfgCWjkj91dX0zzS57sBHikVn2QYl2ySWiQy2Qyy0gQdFzDPHesMEXmmwdzZh
	c+tEQiNcXj1L9k+lc7ooETsa6sU+W3aoHpaWNuAr3FOmcMMFF1DMIa2OYaphmiLRDjXAm5
	mjRJgcYPRFc5RBNd5HgcYQfhTnsAsjQ=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 27 May 2026 15:23:38 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	gunho.lee@lge.com,
	taejoon.song@lge.com,
	hyungjun.cho@lge.com,
	mkoutny@suse.com,
	baver.bae@lge.com,
	matia.kim@lge.com
Subject: [PATCH v7 0/4] mm: swap: introduce swap tier infrastructure
Date: Wed, 27 May 2026 15:22:43 +0900
Message-Id: <20260527062247.3440692-1-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: zjgu6yjrm1tky7qik8wwdxgnnnkpk7q4
X-Rspam-User: 
X-Rspamd-Queue-Id: 2E07940014
X-HE-Tag: 1779863022-187539
X-HE-Meta: U2FsdGVkX19d0L+mbMuV4yCHoE1icDWxsoIgBaSi8a5mZS6/yX5XN+fBcf5tDTWqN3baQqlotK1yfsC00AkQtnfRl/HDXIZ8JbwG7BfphNXneI2aXw9yF8OXOnRpFxylUBtIxm8fduq/3DQPTQzoWv1ZlciTUyBh9Dp8cwj5aHpW7fQAnkzpJNjXZ9h2SrBVOAaYbW1/OvJe0jAgUbOy8wFBPvQXyGRILSsxPz3Cv3UCuYSPlkfKFBXmwjHCxa2hj4FaIwgZgGKe8ceJnF1v+LO/qPx8h5EyCM0iL/tLGlfEPf92tq2vY4Ut4UZxP4Gd+FSy2a9JNjkiDsarHIoUnvYLdbIyVrMnG+CHIl3JZaT9Hp050WYEFaNwl4V9YnKZp64O8RH/Y31neVW1y2qhGLRTktNCSjrLa7GdWE+xNt1NxXLfRZGm755BJvf6wVamYSNrVvmE5SR/RlN6/kaCEM6ZiW3ff+06ejhkns6WaJk09UJNEKwJPVhuFPplsYVmch0ZHkJtXNcqXWRgFuj7a233MzrEJrd8fZfS3+0qZz/0UxQMH2I+QTovIUFh6u/Q6gz1bsJ9fguLG+D50Yx+Hqrghgqo2g4GhGupLHJ7ckRK3uO0TyrspAvsleS9Nm+SWcYMLB7SJCyUEzJbwVuNx9RjWMgjB+NJGMcIqvuDQhJb9LVcE282CFlQGncutpcVVZP4w0jNj+9eelOo+otT7cn6tx5MIBMGJflRLSm3Q/SuzFXSAHGxe7glR+t9o+yocJfuA6DqKTGqvC+sXbx9f87k4wagYU+HJHD/qEzFXJSTXONkHcNaV9Oi3987PTDQ8Cc7VfmtzKvJuKCUxlwS4waWZiQjyHb4Uh/EL6hxj0Kgcs1FFVnnVVb3sFW2iP/rQakf5RZR5RU/HZLTQOSpGZdUsqUyIQmFUJnDTNDqF7egnUgR1m+bn3+n8SyIjRhjQqFHPwBnFMWZ4XxUmTp
 +evWbcM+
 Cpy0ta/tLoerRmV5QQQpt5o14k5AUid7fnWG6RIAo0uGUqzoLNAtSjYVyzuxe2xVmw+G58JJESctWVVbH9ht8ECANilp10HdoUUdUHiSAzhDNdrG3mICVy7CadaZ6UTfclCMluDLQOmqFkg4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is v7 of the swap tier series addressing review feedback.
The cover letter has been simplified.

I revisited the design (see Design Rationale). Since our use case
fits best with a memcg-based model, the implementation remains
within memcg and preserves its resource accounting semantics.

Alternatives considered:

1. A separate sysfs interface under swap. (Workable. But, it would still
   need to reference memcg paths, and fully decoupling it would add
   swap-layer logic to manage memcgs, making it secondary option.)

2. Making the feature non-default.

Other interfaces were also reviewed. Aside from sysfs and BPF,
the options involve trade-offs and are largely design choices.
BPF was excluded due to possible disablement on our embedded
platform, though future extension remains possible.

Overview
========

Swap Tiers group swap devices into performance classes (e.g. NVMe,
HDD, Network) and allow per-memcg selection of which tiers to use.
This mechanism was suggested by Chris Li.

Design Rationale
================

Swap tier selection is attached to memcg. A child cgroup may select a
subset of the parent's allowed tiers.

This
- Preserves cgroup inheritance semantics (boundary at parent,
  refinement at child).
- Reuses memcg, which already groups processes and enforces
  hierarchical memory limits.
- Aligns with existing memcg swap controls (e.g. swap.max, zswap.writeback)
- Avoids introducing a parallel swap control hierarchy.

Placing tier control outside memcg (e.g., via BPF, syscalls, or
madvise) would allow swap preference to diverge from the memcg
hierarchy. Integrating it into memcg keeps the swap policy
consistent with existing memory ownership semantics. There are
also real use cases built around memcg.

In the future, this can be extended to other interfaces to cover
additional use cases.

I believe a memcg-based swap control is a good starting point
before such extensions.

Use Cases
=========

#1: Latency separation (our primary deployment scenario)
  [ / ]
     |
     +-- latency-sensitive workload  (fast tier)
     +-- background workload         (slow tier)

The parent defines the memory boundary.
Each workload selects a swap tier via memory.swap.tiers according to
latency requirements.

This prevents latency-sensitive workloads from being swapped to
slow devices used by background workloads.

#2: Per-VM swap selection (Chris Li's deployment scenario)
  [ / ]
     |
     +-- [ Job on VM ]              (tiers: zswap, SSD)
            |
            +-- [ VMM guest memory ]  (tiers: SSD)

The parent (job) has access to both zswap and SSD tiers.
The child (VMM guest memory) selects SSD as its swap tier via
memory.swap.tiers. In this deployment, swap device selection
happens at the child level from the parent's available set.

#3: Tier isolation for reduced contention (hypothetical)
  [ / ]                    (tiers: A, B)
     |
     +-- workload X        (tiers: A)
     +-- workload Y        (tiers: B)

Each child uses a different tier. Since swap paths are separated
per tier, synchronization overhead between the two workloads is
reduced.

Future extension
================

#1: Intra-tier distribution policy:
  Currently, swap devices with the same priority are allocated in a
  round-robin fashion. Per-tier policy files under
  /sys/kernel/mm/swap/tiers/ can control how devices within a tier
  are selected (e.g. round-robin, weighted).

#2: Inter-tier promotion and demotion:
  Promotion and demotion apply between tiers, not within a single
  tier. The current interface defines only tier assignment; it does
  not yet define when or how pages move between tiers. Two triggering
  models are possible:

  (a) User-triggered: userspace explicitly initiates migration between
      tiers (e.g. via a new interface or existing move_pages semantics).
  (b) Kernel-triggered: the kernel moves pages between tiers at
      appropriate points such as reclaim or refault.

#3: Per-VMA, per-process swap and BPF:
  Not just for memcg based swap, possible to extend Per-VMA or per-process swap.
  Or we can use it as BPF program.

Experimentation
===============

Tested on our internal platform using NBD as a separate swap tier.
Our first production's simple usecase.

Without tiers:
- No selective control over flash wear
- Cannot selectively assign NBD to specific applications

Cold launch improvement (preloaded vs. baseline):
- App A: 13.17s -> 4.18s (68%)
- App B: 5.60s -> 1.12s (80%)
- App C: 10.25s -> 2.00s (80%)

Performance impact with no tiers configured:
<1% regression in kernel build and vm-scalability benchmarks

Change log
===========

v7
- Collect Baoquan's review tag
- Baoquan's feedback on fixing improper comment
- Minor code adjustments per Baoquan's feedback.
- Rebase on recent mm-new
- v6 link: https://lore.kernel.org/linux-mm/20260421055323.940344-1-youngjun.park@lge.com/

v6
- Sashiko AI review fixes
 - Fix batch parsing error path to restore snapshot before exit
 - Reject overlong tier names to prevent truncated duplicates
 - Avoid restoring raw list_head via memcpy (stale pointer risk)
 - Ensure early parse errors do not skip DEF_SWAP_PRIO validation
 - Use (1U << TIER_DEFAULT_IDX) to avoid signed shift UB
 - Defer tier mask inheritance to css_online() to close race window
 - Add READ_ONCE()/WRITE_ONCE() for tier mask accesses
- Other fixes
 - Fix build error reintroduced due to missing v5 change (sorry for that..)
 - Fix WARNING in folio_tier_effective_mask by adding rcu_read_lock() (syzbot CI fix)
 - default number of swap tier max (change to 32->31, for reserving last bit)
 - commit message refinement.
 - rebased on recently mm-new 
- v5 link: https://lore.kernel.org/linux-mm/20260325175453.2523280-1-youngjun.park@lge.com/

v5
- Fixed build errors reported in v4
- rebased on up to date mm-new 
- Minor cleanups
- Design docs with validation (by Shakeel Butt discussion)
- v4 link : https://lore.kernel.org/linux-mm/20260217000950.4015880-1-youngjun.park@lge.com/

v4
- Simplified control flow and indentation
- Added CONFIG option for MAX_SWAPTIER (default: 4)
- Added memory.swap.tiers.effective interface
- Reworked save/restore logic into snapshot/rollback model
- Removed tier priority modification support (deferred)
- Improved validation and fixed edge cases
- Rebased onto latest mm-new
- RFC v3 link: https://lore.kernel.org/linux-mm/20260131125454.3187546-1-youngjun.park@lge.com/

RFC v1 ~ v3
- Change the direction after discussion with Chris-Li
- apply some LPC feedback.
- RFC v2 - https://lore.kernel.org/linux-mm/20260126065242.1221862-1-youngjun.park@lge.com/
- RFC v1 - https://lore.kernel.org/linux-mm/20251109124947.1101520-1-youngjun.park@lge.com/

Earlier Approach (per cgroup swap priority)
- v1: https://lore.kernel.org/linux-mm/20250716202006.3640584-1-youngjun.park@lge.com/
- RFC: https://lore.kernel.org/linux-mm/aEvLjEInMQC7hEyh@yjaykim-PowerEdge-T330/T/#mbbb6a5e9e30843097e1f5f65fb98f31d582b973d

Youngjun Park (4):
  mm: swap: introduce swap tier infrastructure
  mm: swap: associate swap devices with tiers
  mm: memcontrol: add interfaces for swap tier selection
  mm: swap: filter swap allocation by memcg tier mask

 Documentation/admin-guide/cgroup-v2.rst |  29 ++
 Documentation/mm/index.rst              |   1 +
 Documentation/mm/swap-tier.rst          | 159 ++++++++
 MAINTAINERS                             |   3 +
 include/linux/memcontrol.h              |   5 +
 include/linux/swap.h                    |   1 +
 mm/Kconfig                              |  12 +
 mm/Makefile                             |   2 +-
 mm/memcontrol.c                         |  96 +++++
 mm/swap.h                               |   4 +
 mm/swap_state.c                         |  75 ++++
 mm/swap_tier.c                          | 482 ++++++++++++++++++++++++
 mm/swap_tier.h                          |  75 ++++
 mm/swapfile.c                           |  20 +-
 14 files changed, 959 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/mm/swap-tier.rst
 create mode 100644 mm/swap_tier.c
 create mode 100644 mm/swap_tier.h

base-commit: 938bf00744a1b82cefd551f848a927cc24d5fb2f
-- 
2.34.1


