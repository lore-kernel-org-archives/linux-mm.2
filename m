Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4F4CF327A3
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 05:53:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A6656B008A; Tue, 21 Apr 2026 01:53:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 157166B008C; Tue, 21 Apr 2026 01:53:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 045836B0092; Tue, 21 Apr 2026 01:53:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E253C6B008A
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 01:53:33 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5B3EE8CFF0
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 05:53:33 +0000 (UTC)
X-FDA: 84681495906.28.3474FE9
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf26.hostedemail.com (Postfix) with ESMTP id E562F140010
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 05:53:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf26.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776750811; a=rsa-sha256;
	cv=none;
	b=28oCnuFf6cWpiBZ7t1hFwBQUZuFlfQcm5Y7MFwFaeDoQC8Nr7xQgcnlUqch6/DRz90GETO
	pZKmlvZoe4EepNoa/6e19YDf8uFVnYo2e+vJzOqvbXxAfpwEMrWmR2Nf16jUyHq3zMDyYo
	PRxebTAAIWj0wWqzScvqDMki4LZFY70=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf26.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776750811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=BoHSrsQMwwKTuV5atHWrKAoZw57L6t10Fzv4TX5TdN8=;
	b=hhHKVrFIG5Nu9SQLuBdNCXP9c7dIoso3PmU7TcnUi0pgNhOn2y+pwlT/H7xeUsAvoJFV1F
	WJf9QHUOyNKonM3s3Jk2OCP0ifeoGZCBA4W/2XUR+/mNCiNF2reu7uVBlW9jY7c0LQP3DQ
	0IJQ53XrxNoR7/WORYFBc7Fq004NN24=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 21 Apr 2026 14:53:26 +0900
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
	bhe@redhat.com,
	baohua@kernel.org,
	gunho.lee@lge.com,
	taejoon.song@lge.com,
	hyungjun.cho@lge.com,
	mkoutny@suse.com,
	baver.bae@lge.com,
	matia.kim@lge.com
Subject: [PATCH v6 0/4] mm/swap, memcg: Introduce swap tiers for cgroup based swap control
Date: Tue, 21 Apr 2026 14:53:19 +0900
Message-Id: <20260421055323.940344-1-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E562F140010
X-Stat-Signature: y3cbbinzb861dyi3zd9h353aq7bjqoee
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776750810-860708
X-HE-Meta: U2FsdGVkX1/4sbqCeN+96mzdYgHfHTa7UaEFAGCnRCatN3dvSLiXuWssov35McemDYUhM9BBufwLTLYIf4g0wP1m9CcOJAsAqcGDZLACmHyFsSMd4S1Sv+7ZpQrTQT1pPLCTyDhEGLOSrnz2ghML4C3nwFdsDOETW730ao914P5hknq3tRFdlJ2Ife7wmHes4tvbN1R/zWuYnZJa/hLOzy9rmHMjgr4GJ6fdmTGGBzILAOUGRXsS8T0T9Wv/2evfm6r2EAa5zj7saYrS7asBHRsHSIHOvQ5W6JWS0CHatKPaiPeV7tGbxgCT4ZbAOQ+/EnjJx2InOf8xZIADugGcMPpRXfgBz3D5O5frTqxkoTHSrOk5ZLAUs6EWvqJVQB4IgZ3tlU1h93mUqC5AlyWUwfazfhZVn0XwlExNsjQoRHkzAgyuWBjUuBCWCZPfrmxONNILGLOf6gt2RF2jpRZA3safupQskTMsukeK1njnQjySMhG32TEtLjnu/fwBH4cinlxAOlc3MDalmSy8qGEzxdy80j/pWir34cXPGXsx/QqyIn3I5HcUw8U8I1FewN8ZCs9kJdfasSM/Isg0eP5zjks6UJN/IfUO9R/HNjN2LCmk4Btt66FuOjYPTC85TZaLRuVoJP4i+z//yHdUdcyz7IXmk1D63F7W23IaF1DxIvlKXx+xSxmkwKuK8S7R7lg2Ve6b6gC6vAJMy+DQly5rF4n6+t1XtSRPrYPMX9SvBhyuxS4DxQctpyqrJJBM1UDAVgd8TQ8WdMhM4NMN/KrkHDKu53BAyd+NXdwdPgM5PYKmqBgIvkKqxORgtcva5dCq4ZLyitI4cWAmPNy24e9E23/0ELaKVr/kfxF4NmWtOxYHgUY+BDawb+IDnIDnH+1jX0F7oRQxOBFWxhsDJbjWTYY80AasWDb9X4UvMtJ7DcTY5yr+PhqWs+gt9tpk+R2jYCfTmko2VL555jlhJ3J
 TlmkVQKh
 icjSIZ+7JfkN0kMzzyN5KUQywp9rUB+Z4diZFehpXgJjMeGQH2aB1swr5MlEf2s5bSUn9Jlo1zfdzD/n41BsZQlFY33AbcpP21Q7lgZvQDvxaas6XvGFa4lhuIz/CBzIxnJxll2RTHFrTxJtzJxb/xAy31XpofsigBe3Z8pthSqNPGRUqv8ADN4TLCoH+LHHX0iZSBeXJPmzQRTVRzwHUn6uvlIk6rHwUjBbc818VMOlK4PjPDTgxyPDCEA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This version mainly addresses meaningful issues reported by Sashiko AI
review (https://sashiko.dev/#/patchset/20260325175453.2523280-1-youngjun.park%40lge.com)
False positives were excluded, 
and some items were determined not to require changes at this time.

For clarity, this cover letter is structured in two parts:

  Part 1 describes the patch series itself (what is implemented in v5).
  Part 2 consolidates the design rationale and use case discussion,
  including clarification around the memcg-integrated model and
  comparison with BPF-based approaches.

This separation is intentional so reviewers can clearly distinguish
between patch introduction and design discussion (for Shakeel's
ongoing feedback).

v5:
  https://lore.kernel.org/linux-mm/20260325175453.2523280-1-youngjun.park@lge.com/

v4:
  https://lore.kernel.org/linux-mm/20260217000950.4015880-1-youngjun.park@lge.com/

Earlier RFC versions:
  v3: https://lore.kernel.org/linux-mm/20260131125454.3187546-1-youngjun.park@lge.com/
  v2: https://lore.kernel.org/linux-mm/20260126065242.1221862-1-youngjun.park@lge.com/
  v1: https://lore.kernel.org/linux-mm/20251109124947.1101520-1-youngjun.park@lge.com/

Earlier Approach (per cgroup swap priority)
  RFC: https://lore.kernel.org/linux-mm/aEvLjEInMQC7hEyh@yjaykim-PowerEdge-T330/T/#mbbb6a5e9e30843097e1f5f65fb98f31d582b973d
  v1: https://lore.kernel.org/linux-mm/20250716202006.3640584-1-youngjun.park@lge.com/
======================================================================
Part 1: Patch Series Summary
======================================================================

Overview
========
Swap Tiers group swap devices into performance classes (e.g. NVMe,
HDD, Network) and allow per-memcg selection of which tiers to use.
This mechanism was suggested by Chris Li.

This series introduces:

- Core tier infrastructure
- Per-memcg tier assignment (subset of parent)
- memory.swap.tiers and memory.swap.tiers.effective interfaces

Changed in v6
=============
 
Sashiko AI review fixes:
------------------------
- Fix batch parsing error path to restore snapshot before exit
- Reject overlong tier names to prevent truncated duplicates
- Avoid restoring raw list_head via memcpy (stale pointer risk)
- Ensure early parse errors do not skip DEF_SWAP_PRIO validation
- Use (1U << TIER_DEFAULT_IDX) to avoid signed shift UB
- Defer tier mask inheritance to css_online() to close race window
- Add READ_ONCE()/WRITE_ONCE() for tier mask accesses

FYI. there are items. reviewed but no code change
- Legacy default swap priorities (-2, -3, etc.) are no longer used. (False positive)
- Large tree traversal under spin_lock not observed as a practical issue.
- Lowest tier (DEF_SWAP_PRIO) replacement in a single batch update
  remains a functional limitation. (for interface usage enhancement. next feature update target.)

Other fixes:
------------
- Fix build error reintroduced due to missing v5 change (sorry for that..)
- Fix WARNING in folio_tier_effective_mask by adding rcu_read_lock() (syzbot CI fix)
- default number of swap tier max (change to 32->31, for reserving last bit)
- commit message refinement.
- rebased on recently mm-new 

Changes in v5
=============
- Fixed build errors reported in v4
- rebased on up to date mm-new 
- Minor cleanups
- Design docs with validation (by Shakeel Butt discussion)

Changes in v4 (summary)
=======================
- Simplified control flow and indentation
- Added CONFIG option for MAX_SWAPTIER (default: 4)
- Added memory.swap.tiers.effective interface
- Reworked save/restore logic into snapshot/rollback model
- Removed tier priority modification support (deferred)
- Improved validation and fixed edge cases
- Rebased onto latest mm-new

Deferred / Future Work
======================
- Per-tier swap_active_head to reduce contention (Suggested by Chris Li)
- Fast path and slow path allocation improvement
  (this will be introduced after Kairui's work)

Real-world Results
==================
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
(measured in RFC v2).

======================================================================
Part 2: Design Rationale and Use Cases
======================================================================

Design Rationale
================
Swap tier selection is attached to memcg. A child cgroup may select a
subset of the parent's allowed tiers.

This:
- Preserves cgroup inheritance semantics (boundary at parent,
  refinement at child).
- Reuses memcg, which already groups processes and enforces
  hierarchical memory limits.
- Aligns with existing memcg swap controls (e.g. swap.max, zswap.writeback)
- Avoids introducing a parallel swap control hierarchy.

Placing tier control outside memcg (e.g. bpf, syscall, madvise etc..)
would allow swap preference to diverge from the memcg hierarchy.
Integrating it into memcg keeps swap policy consistent with
existing memory ownership semantics.

Use case #1: Latency separation (our primary deployment scenario)
=================================================================
  [ / ]
     |
     +-- latency-sensitive workload  (fast tier)
     +-- background workload         (slow tier)

The parent defines the memory boundary.
Each workload selects a swap tier via memory.swap.tiers according to
latency requirements.

This prevents latency-sensitive workloads from being swapped to
slow devices used by background workloads.

Use case #2: Per-VM swap selection (Chris Li's deployment scenario)
==================================================================
  [ / ]
     |
     +-- [ Job on VM ]              (tiers: zswap, SSD)
            |
            +-- [ VMM guest memory ]  (tiers: SSD)

The parent (job) has access to both zswap and SSD tiers.
The child (VMM guest memory) selects SSD as its swap tier via
memory.swap.tiers. In this deployment, swap device selection
happens at the child level from the parent's available set.


Use case #3: Tier isolation for reduced contention (hypothetical)
=================================================================
  [ / ]                    (tiers: A, B)
     |
     +-- workload X        (tiers: A)
     +-- workload Y        (tiers: B)

Each child uses a different tier. Since swap paths are separated
per tier, synchronization overhead between the two workloads is
reduced.

How the Current Interface Supports Future Extensions
====================================================

- Intra-tier distribution policy:
  Currently, swap devices with the same priority are allocated in a
  round-robin fashion. Per-tier policy files under
  /sys/kernel/mm/swap/tiers/ can control how devices within a tier
  are selected (e.g. round-robin, weighted).

- Inter-tier promotion and demotion:
  Promotion and demotion apply between tiers, not within a single
  tier. The current interface defines only tier assignment; it does
  not yet define when or how pages move between tiers. Two triggering
  models are possible:

  (a) User-triggered: userspace explicitly initiates migration between
      tiers (e.g. via a new interface or existing move_pages semantics).
  (b) Kernel-triggered: the kernel moves pages between tiers at
      appropriate points such as reclaim or refault.

  From the memcg perspective, inter-tier movement is bounded by
  memory.swap.tiers.effective -- pages can only be promoted or demoted
  to tiers within the memcg's effective set. The specific policy and
  triggering mechanism require further discussion and are not part of
  this series.

- Per-VMA or per-process swap hints:
  A future madvise-style hint (e.g. MADV_SWAP_TIER) could reference
  the tier indices in /sys/kernel/mm/swap/tiers/. At reclaim time,
  the kernel would check the VMA hint against the memcg's effective
  tier set to pick the swap-out target.

BPF Comparison
==============
The use cases described above already rely on memcg for swap tier
control, and real deployments are built around this model.
A BPF-based approach has additional considerations:

- Hierarchy consistency: BPF programs operate outside the memcg
  tree. Without explicit constraints, a BPF selector could
  contradict parent tier restrictions. Edge cases such as zombie
  memcgs make the resolution less clear.
- Deployment scope: requiring BPF for core swap behavior may not
  be suitable for constrained or embedded configurations.

BPF could still work as an extension on top of the tier model
in the future.

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
 mm/swap_tier.c                          | 483 ++++++++++++++++++++++++
 mm/swap_tier.h                          |  75 ++++
 mm/swapfile.c                           |  23 +-
 14 files changed, 963 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/mm/swap-tier.rst
 create mode 100644 mm/swap_tier.c
 create mode 100644 mm/swap_tier.h

base-commit: 90f88d13d60cb842cfb6290b6e80a1cd86f37915
-- 
2.34.1

