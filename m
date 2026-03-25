Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E232B109C04A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 17:55:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 284EE6B0005; Wed, 25 Mar 2026 13:55:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 235AE6B0089; Wed, 25 Mar 2026 13:55:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FD8E6B008A; Wed, 25 Mar 2026 13:55:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ED0CE6B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 13:55:01 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9EDAA160A44
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 17:55:01 +0000 (UTC)
X-FDA: 84585336402.13.1D0B277
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf24.hostedemail.com (Postfix) with ESMTP id 71C2A180008
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 17:54:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774461300; a=rsa-sha256;
	cv=none;
	b=algJSJh2iog2JwHAwzAbM/3cIaI1OcT07KzeVRFRz1Yl8VEf46XNCHzuvS/vUm6PpaoEYr
	SsognukgvIkf1b5eFpO6UAk2W/xEfkTzYjCVNeZg3xYwrjBs1sbS9MQNyzj1mAzfnU378M
	Q/sOYxucyvohoZn8Mc16Iyvz3t8AAeA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774461300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=NPycBRWEaQ5W/s1eKUZdWSqPyDHH0vLvX4h1Yp3r7p4=;
	b=qVV+J8Gu+dRmXrAbVkfpo1zDufvIg49Fq+G/aQkb/jTK8p0Pk+a01AKS0Lvzy7KTxkwwDr
	kaYGReH/tt1GNonB+nGciY4u7NxS2Ks5InsA7JzU68UgP06lnWxXrTApewPW/3I8zpi1yn
	u90RsqQ0lFu4RP95v8C8LNmei1pDhaU=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 26 Mar 2026 02:54:54 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
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
	mkoutny@suse.com
Subject: [PATCH v5 0/4] mm/swap, memcg: Introduce swap tiers for cgroup based swap control
Date: Thu, 26 Mar 2026 02:54:49 +0900
Message-Id: <20260325175453.2523280-1-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 71C2A180008
X-Stat-Signature: 1tcki4g87z7nu5yioop9xhtgwqk387pj
X-Rspam-User: 
X-HE-Tag: 1774461298-340004
X-HE-Meta: U2FsdGVkX1+amyBgpxLiHfRgYwFSMfI7V2Gswq/oD2ej3ct3jmOB4Idd2nF1Gefv2CkmZxT2QKC51LEx5/pYXsV7+rFDP7P0O3dPSPOYv7t9gWYZ/w2Ki+o69bBGEgNKTmHaRsyVSDFUoAZEKn8/sBS7gY+A6D/byB3GD/m58djWGFlF6/0U5xibLG8gLya1VVb6/XhylB/qFqfAH/ETa6gty4gRERgDsRdldIxCWhcYg26RmvZWpPdXCmPjFCe9rZNOrhnyd4j1U1Hvm6VhqLk9G4ZoxfsPKudrR+RnXN9KxmyCJ9G5KsxAD4ZHMF22MmlsblZy2US4zQlZMN+/FgglIKBP9MiESc1Q8JdtYxUlYG2G839O6Z/z24TT1Uyj98URPHdAzpFAJezvnCbNOb2FGF2TsRpDpulm4iD4Na0zRZi55g9XcUHbrfcjuVxZKznRgs+yhBEjMBdKJ5U/wNA7loEWFPhZyE3epsl+XfvP1NZwH6Z4JY9lrHFfQGWKN1u5DgdKEGN18Jqqm0g0Un1zbxhONdqJOIjMT1+sDUWgMUOY7+R/GXk+BmoXvS70KvMoDkpS+fyN3yuWUoXzprGELcAuv0ttvDfIrbQ68oWa+8gl9G72cy2UYqs6CBxUihtsxzdDfi4EdO7y/2qRJAa17+rVb3AyNG7qBkATScD+AtboHAuu8hi5l0uOhhdAbzDvNZQr1OYdHT0rkDWJDs4iZuLg4J+0YCbBLTSZSyhRCwo+TfbF69hOalFmraeBPJUDF6nR+PtPaUtKr0TsSdKCOm5pZJjSUgkVJm0g65GKQ3KuGnO2F5N1vsWbdXAcgg/B/qrZYNin8aZK9WGR83oYJ4vMOGXfAlOTU9iup9d5PmNWnDxGAtv0Kn/vVcIFXg3cl7VHgJ/P9zHwMZPItxL8hTE13QtwY6IXDWSL3STPtIvQzwN0MvIbU2L5CVHnkSfa/k2W0DC5j005I+I
 z1tgIyVu
 ZRbiijd/DcOJiQ4ozDEL52g9K7xyn2xErO2iMbcoiPuyNJ3TseuUxKTVJh4jzITKqgylqUak8GQb2G53tYelRZYUrhHBGMqOEMSIOvYGHvLmFuTbHbWIlHP9xWmOMJE2e8KLOu7esQOcLQB5s3CUCyk4bmElmYdtsQ6CTYI5pthUzfG3bz5s4bXLwXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is v5 of the "Swap Tiers" series.
For clarity, this cover letter is structured in two parts:

  Part 1 describes the patch series itself (what is implemented in v5).
  Part 2 consolidates the design rationale and use case discussion,
  including clarification around the memcg-integrated model and
  comparison with BPF-based approaches.

This separation is intentional so reviewers can clearly distinguish
between patch introduction and design discussion (for Shakeel's
ongoing feedback).

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

 Documentation/admin-guide/cgroup-v2.rst |  27 ++
 Documentation/mm/swap-tier.rst          | 159 +++++++++
 MAINTAINERS                             |   3 +
 include/linux/memcontrol.h              |   3 +-
 include/linux/swap.h                    |   1 +
 mm/Kconfig                              |  12 +
 mm/Makefile                             |   2 +-
 mm/memcontrol.c                         |  95 +++++
 mm/swap.h                               |   4 +
 mm/swap_state.c                         |  75 ++++
 mm/swap_tier.c                          | 451 ++++++++++++++++++++++++
 mm/swap_tier.h                          |  74 ++++
 mm/swapfile.c                           |  23 +-
 13 files changed, 923 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/mm/swap-tier.rst
 create mode 100644 mm/swap_tier.c
 create mode 100644 mm/swap_tier.h

base-commit: 6381a729fa7dda43574d93ab9c61cec516dd885b 
-- 
2.34.1

