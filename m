Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7194CC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 02:56:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D488B6B0005; Sun, 12 Jul 2026 22:56:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD22A6B0088; Sun, 12 Jul 2026 22:56:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B99B26B008A; Sun, 12 Jul 2026 22:56:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 823BC6B0005
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 22:56:54 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EA29E1409CE
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 02:56:53 +0000 (UTC)
X-FDA: 84982241106.13.8850CDF
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf27.hostedemail.com (Postfix) with ESMTP id 55ED140003
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 02:56:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf27.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783911412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=JUIZGqCq9oRztl+19IpPZlqrSaZvbufUZQ3EU9irQ1w=;
	b=ugiI+3oPd3F9gcpOlmIb3/IAD6E22IYePEfwXQb7oPGVrrm3ctELGWOl4YdBDhZn4Djwzr
	1Po7X02uNVjO7PzMGExsFYS33rLd+lTwiozLLd8pYCP7aKvXfsvnksLq55Z6txSiN5L1bd
	Qt5SXKEoyw+7f/O/cdTVliDPnk2Xmz0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf27.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783911412;
	b=TOWwdBjQpcvrtPgZq9AxzI/z6Xy3lLxbP8OFC4liLeSArDk6eCw39FmPys+eoZL227HVlz
	yw1sItO0/xwtWH1vgBBRKAw2EtEmcApzwShju5gUIVzmoGevi7g1KzVUwBtJImS8fgnQJw
	xAgZuTsIiBowVqoDJoGqhjNkh2CFliw=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 13 Jul 2026 11:56:47 +0900
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
	baoquan.he@linux.dev,
	baohua@kernel.org,
	yosry@kernel.org,
	joshua.hahnjy@gmail.com,
	gunho.lee@lge.com,
	taejoon.song@lge.com,
	hyungjun.cho@lge.com,
	baver.bae@lge.com,
	her0gyugyu@gmail.com
Subject: [PATCH v10 0/6] mm/swap, memcg: Introduce swap tiers for cgroup based swap control
Date: Mon, 13 Jul 2026 11:56:38 +0900
Message-Id: <20260713025644.170839-1-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 55ED140003
X-Stat-Signature: h53kiybuqgbjpski5uzp36uh7c6ejqy5
X-HE-Tag: 1783911410-163840
X-HE-Meta: U2FsdGVkX18DZqikwWHGHM9batkNJpaZzzBeldYkjefSMQZLTbVZ8DemOmVcKVJDsUA7HwtAxkJE0fNT28Lt1hhh+jLu7lkTxucYu+McEJoy7tOp4E8RxYRVxuopaZihDsbdY8k7sXCUXK8wG5e9owfKjqDMo7VGkXOJio41xZRPsAZDf5j4P1tpBeSeuZ+eKBC3ttT7CBZCtv2q3YlNRoiEF2dtH1PoRgvzHPAz8umIcnt5AO9uRQQq6E5zSq8Sf+Si3/ai4POU91lj6FQx0dWcZyoAUhT34ylZrcGLQHR/luFHjSVX/sdrCyWvxQCzDZxcVfsYSYR1bI/IyWS7Os/bzvZ+x2/+RukH6hV0A1p8RobBGVZ4nS8eoQp3flE8jBbpUH1fe7ZS/Wp9Z57STchvuzEOv6w9WEx+NBkhCRrWQdqZnNjmsrq2ixlV94z4D2yGIe72QIldcqDgo1muIkdA1xWd42xFKQqrafpZFLQP9/Dq1FJhtE75R9i4iaxJHpXDLc2wuiQYPNIR8KZCITwaw6az2wEckC7j8T45KYiS6SpwcVKHGzTLB9Kwc7dCThjoeJ/p1vt4aRX3HNtt7R8TVEsv8sm+m33TWUPh1RSG+8DI5PEPjX3BvOwQGCmDfK/GlYAiDLtM6prl0vFqm+H1kKLtPnbRJx04XE1UqlYXfnU8sUWic4PN2IyRz/mMuh9cDQldjoKc6BH0hb6ZGK0pmiZQh37eLh/QEHIQ6f8mrPP+hApTgghq6knHVhlhMjoyGZFG2DDIxsxNCJF57w7viBhJpVsBh/kcErUOiNnq6IF2Rv7m0ZJrG/vBxDeDRkEn3br1wdRqBCp3VZtsVOmmoq5P97cx9DP8ZGaTAzuiBi7k7mZeQkezQgKdqYkioNdZqJSHp7jEvI85/nAWOmW+yNQOBfd1jLKa4s3LJp9JRhKQR5pD1gqfhd5oFkESOQlhU6XCQ5IRqczvoLR
 Zh2U2GkU
 ptzF0W4eZODaeV7kW7wvVigYVrObXLKKfHNU3YgXi2tam0tFRDTaHrw1uPw/M5Yi1wyfw0rErn5VFS0ofhRPQ+ZpqXh8pacztrR6N2T5PmNXWt3vNPSu2KZdEBzkPCHNWxuy+D1UEKPmAlgGmJBO+tybiGgrlboNQo9hU2WveEMDBGfWbCoPP7zub03MvhFj7RT6xbOXfJSTRdnhaizXX6PWAMtY3xQZggReF3LGHDJgBwhkZg6aX9CMPY8bTznYjcSn1R9Z8IMWsXWFpsCGY6QSTWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is the v10 series of the swap tier patchset.

v10 folds in the Sashiko review fixes for the selftests added in v9 and
rebases onto the current mm-new. There are no functional changes to the
core swap or memcg code since v9; see the changelog for details.

For context, the bulk of the series is unchanged since v8, with great thanks
to Shakeel Butt and Yosry for the reviews and discussions [1] that shaped it.
The main change in v8 was the interface change to use memory.swap.tiers.max
with '0' (disable) and 'max' (enable) values. This mechanism was suggested
by Shakeel and Yosry.

This change allows for future extensions to control swap between tiers and
aligns better with existing memcg interfaces. It is confined to patch #3's
user-facing interface; internally, patch #3 still uses the existing mask
processing method, which is implementation-efficient.

We also discussed tier extensions. Thanks to Yosry, Nhat and Shakeel for their
valuable feedback.

Here is a brief summary of our tentative conclusions. Please correct me
if anything is misrepresented (details in references):

* Zswap tiering [2]:
  Zswap can itself be a tier (typically the fastest one). But, until vswap lands, 
  zswap cannot be the only allowed tier, 
  since it still needs a physical device for allocation;
  that restriction can be lifted once vswap is supported.
* Vswap tiering [3]:
  Vswap should be handled transparently to the user. Vswap itself will
  not be tiered. But, someday supported if there is strong and real usecase.
* Relationship with zswap.writeback [4]:
  If zswap tiering is introduced, it could replace the zswap-only tier.
  However, since zswap cannot be tiered independently without vswap, it is still
  needed for non-vswap cases.
* Tier demotion [5]:
  A separate interface like memory.swap.tiers.demotion might be needed.
  For now, we only support 0/max to enable/disable tiers. A future "auto"
  mode could scale a per-tier limit from swapfile size and memory.swap.max,
  similar to the direction memory tiering is heading in; the exact
  default-scaling behaviour is still under discussion.

I plan to apply the swap tier infrastructure and the first use case
(cgroup-based swap control) first, and continue following up on the
discussions above.

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
Each workload selects a swap tier via memory.swap.tiers.max according to
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
memory.swap.tiers.max. In this deployment, swap device selection
happens at the child level from the parent's available set.

#3: Tier isolation for reduced contention (hypothetical)
  [ / ]                    (tiers: A, B)
     |
     +-- workload X        (tiers: A)
     +-- workload Y        (tiers: B)

Each child uses a different tier. Since swap paths are separated
per tier, synchronization overhead between the two workloads is
reduced.

Future extension (Follow up)
============================

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
  Not just for memcg based swap, possible to extend Per-VMA or per-process
  swap. Or we can use it as BPF program.

#4: Zswap and vswap tiering:
  Tiering applies to the vswap + zswap combination.

#5: Vswap on/off control:
  Currently not supported. If a strong use case arises where vswap needs
  to be controlled by memcg, the tier interface could be used for it.

#6: Per-CPU swap allocation caching:
  Per-si/per-tier per-CPU caching of allocations to reduce contention in
  the tier-filtered allocation path.

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

v10
- selftests: applied the Sashiko review fixes, and dropped redundant comments and dead code.
  (#5, #6 patches)
- Rebased on recent mm-new.
- v9 link: https://lore.kernel.org/linux-mm/20260620181635.299364-1-youngjun.park@lge.com/

v9
- Added selftests (per Nhat's request):
 - selftests/mm: swap tier configuration test for /sys/kernel/mm/swap/tiers.(#5 patch)
 - selftests/cgroup: swap tier routing test for memory.swap.tiers.max. (#6 patch)
- Removed the redundant rcu_read_lock() around the memcg tier-mask tree walk;
  for_each_mem_cgroup_tree() already takes RCU internally and returns each
  memcg with a reference held. (#3 patch)
- Sashiko review: swap_sync_discard() now honors the memcg tier mask, so the
  discard fallback no longer drains clusters on disallowed tiers. Left as-is:
  the cgroup tree walk under spinlock (bounded by cgroup.max.descendants, an
  admin-controlled limit, and triggered only by infrequent tier writes) and
  the pre-existing swap_avail_lock drop in swap_alloc_slow(). (#4 patch)
- Dropped patch #4's Reviewed-by tags (Nhat, Kairui, Baoquan): the
  swap_sync_discard() change above modifies that patch (the tier mask is now
  passed as a parameter into the alloc and discard paths), so the earlier tags
  no longer apply. Re-review would be welcome.
- v8 link: https://lore.kernel.org/linux-mm/20260617053447.2831896-1-youngjun.park@lge.com/

v8
- Changed the memcg interface to memory.swap.tiers.max.
  Values are '0' (disable) and 'max' (enable). Default is 'max'.
- Addressed Sashiko's review: Update the mask value atomically at once and
  read the mask value while grabbing lock.
- Collected review tags from Kairui and Nhat.
- Rebase on recent mm-new
- v7 link: https://lore.kernel.org/linux-mm/20260527062247.3440692-1-youngjun.park@lge.com/

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
 - Fix build error reintroduced due to missing v5 change
 - Fix WARNING in folio_tier_effective_mask by adding rcu_read_lock()
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

Reference
=========

[1] https://lore.kernel.org/linux-doc/aiw2p5ANjsQUCIHA@linux.dev/
[2] https://lore.kernel.org/linux-mm/CAKEwX=Nz9SWcEVQGQjHN8P8OANJY4BG0w+iQOzoNOWuteoVjAg@mail.gmail.com/
[3] https://lore.kernel.org/cgroups/CAKEwX=O23a4iWBZoewKVb8QqODte6r3Xijckw3_oCJNoiO9M5A@mail.gmail.com/
[4] https://lore.kernel.org/linux-mm/CAO9r8zOg0OP1Ak1v7CRzSfQq0D8b4Dw+_T0Jui6YTM_KwQQNOA@mail.gmail.com/
[5] https://lore.kernel.org/linux-mm/CAO9r8zNi4-QC4sUi=xXWHt9WMeG39mbyoSf8kON9vLOZ=cbCmw@mail.gmail.com/

Youngjun Park (6):
  mm: swap: introduce swap tier infrastructure
  mm: swap: associate swap devices with tiers
  mm: memcontrol: add interface for swap tier selection
  mm: swap: filter swap allocation by memcg tier mask
  selftests/mm: add a swap tier configuration test
  selftests/cgroup: add a swap tier routing test

 Documentation/admin-guide/cgroup-v2.rst       |  20 +
 Documentation/mm/index.rst                    |   1 +
 Documentation/mm/swap-tier.rst                | 159 ++++++
 MAINTAINERS                                   |   3 +
 include/linux/memcontrol.h                    |   5 +
 include/linux/swap.h                          |   1 +
 mm/Kconfig                                    |  12 +
 mm/Makefile                                   |   2 +-
 mm/memcontrol.c                               |  67 +++
 mm/swap.h                                     |   4 +
 mm/swap_state.c                               |  75 +++
 mm/swap_tier.c                                | 477 ++++++++++++++++
 mm/swap_tier.h                                |  76 +++
 mm/swapfile.c                                 |  34 +-
 tools/testing/selftests/cgroup/.gitignore     |   1 +
 tools/testing/selftests/cgroup/Makefile       |   2 +
 tools/testing/selftests/cgroup/config         |   2 +
 .../selftests/cgroup/test_swap_tiers.c        | 509 ++++++++++++++++++
 tools/testing/selftests/mm/.gitignore         |   1 +
 tools/testing/selftests/mm/Makefile           |   1 +
 tools/testing/selftests/mm/config             |   2 +
 tools/testing/selftests/mm/run_vmtests.sh     |   5 +
 tools/testing/selftests/mm/swap_tier.c        | 337 ++++++++++++
 23 files changed, 1785 insertions(+), 11 deletions(-)
 create mode 100644 Documentation/mm/swap-tier.rst
 create mode 100644 mm/swap_tier.c
 create mode 100644 mm/swap_tier.h
 create mode 100644 tools/testing/selftests/cgroup/test_swap_tiers.c
 create mode 100644 tools/testing/selftests/mm/swap_tier.c

base-commit: 61cccb8363fcc282d4ae0555b8739dd227f5ad0b
-- 
2.34.1

