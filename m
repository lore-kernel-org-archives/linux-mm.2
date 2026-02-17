Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B58CE83844
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 00:10:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 909526B008C; Mon, 16 Feb 2026 19:09:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88C626B0092; Mon, 16 Feb 2026 19:09:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78B8F6B0093; Mon, 16 Feb 2026 19:09:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 668FF6B008C
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 19:09:59 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F10511D028
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 00:09:58 +0000 (UTC)
X-FDA: 84452015676.26.F1ACA34
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf16.hostedemail.com (Postfix) with ESMTP id 95D3D18000D
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 00:09:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf16.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771286997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=7tfOuuMeTuUDyjRw5nNrzNu/vH46czple8xP3HGOHxc=;
	b=VvtYigwEbSGWhpCwNT10USaiEIcUi6OF5ic8ieLEi1oDoK/ejzuUgXQv/eY52408ktWkrv
	cEHQxrc2f0Tf/eBzR04zrAQ4GET37g68A0b4dbNMdp2JdIWaS5O6KPCaK8LWv0e98EY+z9
	YifU6Ysu+8c2dx2WEsi/6IXSf0JG0tA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf16.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771286997; a=rsa-sha256;
	cv=none;
	b=BmUuDlLXnfher585ZEY5YrYC7uFWB/HFsiwVophXkjL6xIADdWA9oHmQcpzye+EomShEQa
	tP5U6eXNDhV3ziHYHn/+PZDmo3lysVtPp6YKJhvD8QJepdVx54gVFgJqja9NISOW7tc6Bz
	JWd71j0Zd3HucEpoQJcfTkOsc+7U2FM=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 17 Feb 2026 09:09:53 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>,
	linux-mm@kvack.org,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	gunho.lee@lge.com,
	taejoon.song@lge.com,
	austin.kim@lge.com,
	youngjun.park@lge.com
Subject: [PATCH v4 0/4] mm/swap, memcg: Introduce swap tiers for cgroup based swap control
Date: Tue, 17 Feb 2026 09:09:46 +0900
Message-Id: <20260217000950.4015880-1-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: gi75wgaiwtinuwje9wksyaagm1iiaeya
X-Rspam-User: 
X-Rspamd-Queue-Id: 95D3D18000D
X-HE-Tag: 1771286996-722360
X-HE-Meta: U2FsdGVkX18EDhU+8LM/VejklTNCl8xZEaQoFetNnYI82WZnOgUzNKoaZ0mwk10zIIe5QlF9tEPJRIjr7h8jEcfSIzxlepwmGrg3l1FKT4COel4Y9rNJcIuGEtXNgW7f/DBh20+HI3PFAhELlPZBEIvh6HGJeMYhTXawVOw5y3yR0+6WFnAXxfC8IL6OEyuQZ1jtbs/cZwvunHFeNkSCMsfHUXEDHdzputtfDTqt+RtcOcCp579ZFSBkC2EUuTlAVlTACZlT1aCVzerb6WVCc3kJV7KNF+2k5euAXC350EyGxWvk+EC711OdQQZwiOfxL6axLXgD8grAFFum5eXTwJXaDPyEvTzd6KIsnR9HP9zu5Dq2tL02PF6jfbLxuMIcKmUfOFJ29iH5+EYCYLKx7bd2N2GaFQHa6IG7TURDUVgWkkdEJs39raGoeSx8OydZyg1QXHmllVxG0vwsb0BfqfH2Mk1d5hockV3LjeWnz3ize9i8Oicpfu2+jHF5MMZ5bxWXDt3evjzggsvxlxWmJJUwu/iZF1bh7DRYJ/FcAzUANaMjEDmBpsR3BourpFCuM9+fbU/MvuMBF0I/U+JTmJWBnk29ZK/U26w3ODxRzhOvx3BU+XZN1URQ+JPqKz3cZhrxLErAW3kinFaviH5OolJeQzj8TM+e+QShaqjbh5xbbTJiMp2JILQU7SOzoj8QmTE+AoBwuKQ/WvhVoc2180C3YX3//EPgne1b4FbN5xDKbbb9wd5ZZGhgp+ts4ZgRxc59+wbEyICygEdVt4MzOu7AxV92Oy94qulqiXRvwckYgN2uR3qMfVKcQEZ3Lram5Y+P6q+JaXn414Lz5PNTdZvgPCBvx/dIc/fZa3AyeF7LpdZ/uT7qvGBAnQwRIiQUSJFs75L6HNFQWbG24Xx5EbloQ1kXzRAKIJR5RtXXKKS6NHQai/rJdHrABj25mGgDfTUZ1tQidsgbKOruw/S
 sSQQJQIr
 c/5nz//2+c5qe76s2beCznzUaEnzs9pKlj51BbUeHOB4N8OA2ojt4V/MzP9mEBtfZyZ6w7bTDDCBPduKJSTx8JXtmJNTxKxnKJ+4lzoBawhELVhEF/MSqb4XE76jgW12C42QKAQhir3f9s9Xpzk8wb6Ic+TmaMkXwU7odDC49+yrg5U5UMe6Us8zY12W4mtlnDRJRPKEpke/Xd6NUfUs3vmyTLw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is the fourth version of the "Swap Tiers" concept.
Following Chris Li's suggestion to focus on small, mergeable
steps, this series covers the core tier infrastructure and
memcg-based tier assignment as a minimal usable feature set.
Further extensions are deferred to subsequent series.

Previous versions:
  RFC v3: https://lore.kernel.org/linux-mm/20260131125454.3187546-1-youngjun.park@lge.com/
  RFC v2: https://lore.kernel.org/linux-mm/20260126065242.1221862-1-youngjun.park@lge.com/
  RFC v1: https://lore.kernel.org/linux-mm/20251109124947.1101520-1-youngjun.park@lge.com/

Overview (Recap)
================
Swap Tiers enable grouping swap devices into named tiers based on
performance characteristics (e.g., NVMe, HDD, Network). This allows
faster devices to be dedicated to latency-sensitive workloads while
slower devices serve background tasks. The concept was suggested by
Chris Li.

Changes in v4
=================
- Simplified control flow to flatten indentation (Chris Li)
- Added CONFIG option for MAX_SWAPTIER with a small default of 4
  (Chris Li)
- Added memory.swap.tiers.effective read interface, following cpuset
  convention of splitting into configuration and effective files
  (Michal Koutný)
- cgroup docs refinement. (Michal Koutný)
- Reworked save/restore logic into a clearer "snapshot and rollback"
  model for improved readability and simpler control flow (Chris Li)
- Removed tier priority modification operation to reduce complexity;
  may be revisited in a future series
- Added tier name validation: only alphanumeric characters and
  underscores are allowed
- Fixed several edge case bugs
- Swap allocation logic improvements: integrating percpu global 
  cluster swap cache onto the swap device will be handled as 
  part of Kairui Song's ongoing work. Drop that logic on this patch.
- Rebased onto latest mm-new

Deferred and Future work:
- Per-tier swap_active_head to reduce contention across tiers when
  releasing swap entries on different tiers (Chris Li). This is an
  improvement to the swap_avail_head / swap_active_head (which must be done)
  and is not critical for the initial infrastructure.

- Round-robin rotation (Kairui) cleanup will be proposed after
  this series lands, as swap tiers can naturally abstract away
  round-robin behavior (round-robin is unnecessary when no
  equal-priority devices exist. possibly can disable it. and also can make round-robin
  priority selectable).

- BPF interfaces (Shakeel Butt). beyond memcg  
  are potential future extensions once the base infrastructure is
  established and real-world use cases are ((including, per-VMA, DAMON, etc.)).

Changes in RFC v3
=================
- Fixed swap_alloc_fast() tier eligibility check
- Fixed tier_mask restoration on error paths
- Fixed priority -1 tier deletion bug
- Fixed !CONFIG_MEMCG build failures
- Improved commit messages
- Fix improper error handling
- Fixed coding style violations
- Fixed tier deletion propagation to cgroups

Changes in RFC v2
=================
- Strict cgroup hierarchy compliance (LPC 2025 feedback)
- Percpu swap device cache to preserve fastpath performance
  (Kairui Song, Baoquan He)
- Simplified tier structure (Chris Li)
- Removed explicit "+" selection; default is all tiers, use "-"
  to exclude (Chris Li)
- Removed CONFIG_SWAP_TIER; now base kernel feature (Chris Li)
- Effective tier calculation moved to configuration time
  (swap.tiers write)
- Mixed operation support for "+" and "-" in
  /sys/kernel/mm/swap/tiers (Chris Li)
- Commit reorganization for clarity (Chris Li)
- Added tier priority modification support
- Added documentation for swap tiers concept and usage (Chris Li)

Real-world Results
==================
App preloading on our internal platform using NBD as a separate tier.

Without a separate swap tier:
- Cannot selectively avoid default flash swap, unable to reduce
  flash wear and lifespan issues.
- Cannot selectively assign NBD to specific apps that need it.

Result (cold launch vs. preloaded):
- Streaming App A: 13.17s → 4.18s (68% faster)
- Streaming App B: 5.60s → 1.12s (80% faster)
- E-commerce App C: 10.25s → 2.00s (80% faster)

Performance validation against baseline (no tiers configured) shows
negligible overhead (<1%) in kernel build and vm-scalability
benchmarks. Detailed results in RFC v2 cover letter.

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
 mm/swapfile.c                           |  22 +-
 13 files changed, 922 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/mm/swap-tier.rst
 create mode 100644 mm/swap_tier.c
 create mode 100644 mm/swap_tier.h

base-commit: 776250964cbaa49ebe6b8bb2870765cc89cece59
-- 
2.34.1


