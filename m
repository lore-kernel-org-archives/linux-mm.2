Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67EF2C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 07:38:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F70C6B008C; Mon, 24 Aug 2026 03:38:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CE206B0092; Mon, 24 Aug 2026 03:38:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30BF86B0095; Mon, 24 Aug 2026 03:38:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 034196B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 03:38:21 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EA39C16047D
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:38:19 +0000 (UTC)
X-FDA: 85135359918.11.DC9F1D3
Received: from mta0.migadu.com (out-67.mta0.migadu.com [91.218.175.67])
	by imf03.hostedemail.com (Postfix) with ESMTP id BFB6520005
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:38:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	spf=pass (imf03.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.67 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787557098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=AIdYWWKSCbRp+yyd/lZ0XSdv8FSpL5i4C45Wtxg6PfA=;
	b=GkMCjNePnu9+MxQNYV088a6H/ge38mqd18mZajV1Vvszh6b455x9LaXYlNWMuVht9o70wL
	ubgIZznOeNvw76nuYyzIgc/NtSvSTwejKHCHr9QOjrMVhddoxjJELc6+wpP1QPZ6jEzVzp
	aHlJ4240tvQY5IQYnD/gXEQ7kWFCFjQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787557098;
	b=XTkQW+ZoRc2AfiZbqPHlsF9rbByMO9RKLgXYpFcYNVL3HZnsAuombMc3hBN6upXzbNyl3b
	CArNw3oFkboeFtvvHhQwKxLP+UXHcMewi2Trx4fz1DzbVIa2yGCSLZAGYQXKWgRg+X1Pf3
	WE0hzoGyDv2bwNooZzVX8fC5bXQwtcU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.67 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (3.112.29.171)
	by mta10.migadu.com with ESMTPS id 41a8bfae78f4319d;
	Mon, 24 Aug 2026 07:38:16 +0000
X-Mizu-Trace-ID: 41a8bfae78f4319d
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	kasong@tencent.com,
	baohua@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baolin.wang@linux.alibaba.com,
	hannes@cmpxchg.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH 0/9] mm/mglru: suppress empty page table walks during aging
Date: Mon, 24 Aug 2026 15:37:57 +0800
Message-ID: <20260824073806.629593-1-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: s3t41bqa7ghsp8koq1dn381jjej9fpdh
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BFB6520005
X-HE-Tag: 1787557097-98754
X-HE-Meta: U2FsdGVkX1+MS9Uz2uFk7CFLVA2wtL7LeRj5io/2FGMGGPhcE7uLfMSlqqkK5ddumxJOtgrgHqsdxgfM0ciJq3FbhFxP2/OuZtufNLjzsJZDRnG5q7FZpAvNH0r1sswTZw3uwPzsdu2LlhVQ9y+Kuf8cx5B8aQEonDr7lPvELrOhjZpYySGYn42TKM2KWY1dwDSO7g5J0s81Vra3nzXBrjbZxBANJZnQk9sYTMoaqikhnhwCnUMZUtgD4vUQcSj6p6Q1g5np03Nshk0Vm7XtX3u/Wn/g0nC6c+CdxaFRtfY4vOQgA8pT5IZ0ciOefC9NECRTjBX8nxyns8MvVQhiOmZGL4hmL2Nd00/0X8KyL9JiwPSHFPFHyZBTOFepxDol0Nkb3MuJyjCKDohdXP7lAVvwoM8HJ/SFanw/EDloHN3tak7gnTMiV9/iuK69m1k4QqIfPmLOMGrqlTipuoV5PR4yU2pmZSA+YZrTYn/XXXS41cuEswEfJbKzKhR6diT5Gkjq5xnAaiEtYGiiD75Be1tO5jSaK73GHI+k1lHeV0zw+YnUrayQDIeGdTolrnfMyBl0cuot4sHsXgNYjDlCaVi1sNxDpVUIeYxaxMXrN6pQ3dtcncQiPjJlUv3YLVZbuWcSXwBD/oiNg+5RoD3Y0eVE8DY9JvSlZo559bZqC48AXL3MlBkYdXMnAUIPBdiYcr2cJIZAcCdR4iQoIg8LSYe2IpxU9G2WGm+/OKkUFqN5bjX/pmN3a7DgEiO39hB8PHhiy6Yqjz8I7fDTQ/kHkRsk3d0pzRUCCetuQU44ZQMq7rnBBXUCfmivKjAOf7ULM4ZTPch3MD/fJmPM581UHPsM5s4oEUj0545XV45X5OzyH30RQ/B/mW67Ca83r5KpEwPD897OfDITFGWjKlc3Ny8KuSAucuP6YivC089K5ol3uq0sgSMBZyDHaRjsPzoOCw/Mv4jS5iM7bOw1W3c
 LXK848SM
 a3gIB7vK7QxiKPA1zZ62pitrT4ZPowPQ0ZUz6wX03D/INYvKYol5uoEKJpVo3dR8MCGdY/OYgczNrhZ+kUTiccFedzmePNYpVXEm1wiyST8N0XbWFpn08fljK6zjga1QtsFNeG1ghN5kq2PW1ilF+6LH+ZKABqb0qneIzqWIScqeVDu2E80Kb2YALjcNZvkOxD3VY+xZOSOo8MtJAgmWs17gfRSWy9aqOxkUoBlwcX5Mq9+LRqUXONm6IV4gZDB4NAufPUaer5MH/lH7hDblRd6t+87u+FrZEhQ9RFHhZN0Sjn6gapXmCvZrF5EYsjr8J4s65M42TrUQh5zzX+SWv4bRQyHG8Y1lcQObzSOd7V6YrbFIH9mZokwK1C+8zeipDkhSyStzSm6wm+kQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the current MGLRU, lru_gen_use_mm() will mark an mm for all nodes at
each context switch, so on each node aging will walk into each mm's page
table independently. On a multi-NUMA node system, one process launched
on one or a subset of nodes, its mm is walked by all other nodes's aging
while finds on pages for their lruvec. This is pure waste (100% walks
are empty on those other nodes)

This patch series suppresses these empty page table walks with two
complementary mechanisms at different levels:

  - empty_map (cross-node specifc). At mm granularity, one process's mm
    whose walk found no pages for one node's lruvec is skipped on that
    node between re-scan passes.

  - PUD-level Bloom filter (general). One level up from the existing PMD
    filters, it skips any 1GB PUD that had no young entries last
    generation - namely whose 512 PMDs all failed PMD test. Cross-node
    empty walks can prove its effect the best, but it also suppresses
    purely code PUD inside local mms. So it reduces unnecessary walking
    in any workload with cold areas.

The two complement each other: empty_map reduces the *number* of
cross-node walks, the PUD-level filter reduces the *cost* of the walks
that remain.

Measurement test (3-socket Xeon 6766E, 32 x 256MB workers pinned to node 0):

  node 1 (foreign mm walks):
    empty_map off (PUD filter on): 3300 walks, all empty, ~1238 PTE scans/walk
    both on:                       900 walks (-73%), ~0 PTE scans/walk

  - empty_map cuts node 1's walk count by ~73% (every 4th pass re-scans
    to close migration/fault windows).
  - the PUD-level filter makes the remaining walks nearly free: the 1GB
    subtrees are skipped instead of iterating their 512 PMDs
    (leaf_total drops from ~1238 to ~0 per walk).
  - worker RSS is unchanged in both modes - no premature reclaim. A
    force_scan pass confirms the local pages are found young and eligible
    (leaf_eligible == young == 21320 on node 0) when the filters are
    bypassed, i.e. the pages are hot and the aging walker can find them.

Performance regression test (make -j4 in a 3G memory cgroup, 4 vCPU / 8GB
2-NUMA VM, median of 3 runs):

                  baseline   patch    diff
    build time     10m01s    9m41s    -3.4%
    pgpgin        136868    138080   +0.9%
    pgmajfault      1832      1862   +1.6%

Build time, page-in and major-fault counts are within run-to-run
variance of a no-patch baseline - no measurable regression. The build
time is if anything slightly lower, consistent with the suppression
reducing reclaim overhead (fewer cross-node empty walks) during a real
memory-pressure workload.

The test codes/scripts (numa_workload + run_test_v4.sh) are available at:
https://github.com/baoquan-he/mglru-empty-walk-test

RFC-v1:
  - Bloom filter helpers are named symmetrically -
    test/update/reset_pmd_bloom_filter() alongside the PUD-level ones, and
    the struct field filters -> pmd_filters (Barry).

  - An mm is marked empty only when its page tables were actually walked
    (a failed mmap_read_trylock() or a stale seq is not empty), and the skip
    is invalidated on the major page-fault and migration paths. (Sashiko)

  - Reworked the re-scan: the old shared counter across nodes got stuck at
    the slowest node, so the skip never really engaged. Now each node re-scans
    its empty mms every N passes on its own clock. N is the skip_empty knob
    (default 4, proper read/write with input validation). (Sashiko)

  - Added measurement counters/tracepoint, and a kernel-build regression
    test (no measurable impact).


Baoquan He (9):
  mm/mglru: add MM_WALK_EMPTY stats and tracepoint
  mm/mglru: suppress cross-node empty page table walks
  mm/mglru: add debugfs knob for the empty-walk skip threshold
  mm/mglru: invalidate empty-walk skip on page fault and migration
  mm/mglru: add PUD-level Bloom filter state
  mm/mglru: refactor Bloom filter helpers for two filter levels
  mm/mglru: skip PUD subtrees during aging
  mm/mglru: report hot PUDs from the rmap feedback path
  mm/mglru: count PUD subtrees skipped by the PUD-level filter

 include/linux/mm_types.h      |  22 ++++
 include/linux/mmzone.h        |  13 ++-
 include/trace/events/vmscan.h |  30 +++++
 mm/huge_memory.c              |   3 +
 mm/memory.c                   |  15 +++
 mm/migrate.c                  |   4 +
 mm/vmscan.c                   | 205 +++++++++++++++++++++++++++++-----
 7 files changed, 264 insertions(+), 28 deletions(-)


base-commit: efecab401cb15fd3bb9bc05990609acb6b267ff2
-- 
2.54.0


