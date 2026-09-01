Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49A80C61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 06:38:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18C346B0092; Tue,  1 Sep 2026 02:38:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 165326B009E; Tue,  1 Sep 2026 02:38:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A0516B009F; Tue,  1 Sep 2026 02:38:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D30E16B0092
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 02:38:10 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3DB1040341
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 06:38:10 +0000 (UTC)
X-FDA: 85164238740.17.091AB85
Received: from mta0.migadu.com (out-3.mta0.migadu.com [91.218.175.3])
	by imf11.hostedemail.com (Postfix) with ESMTP id AF1EF40003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 06:38:07 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.3 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788244688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=XlL8zCi+C13+sct6nh3Gy0ElyoSyS+ZKtjJj3TVS+Mo=;
	b=UavHxyN/wCEr8jlk9FSTFyj66pOUL6R5I2DTCgvgtwV4ZRz/VQhAfcWO+86h0ri3wqGV65
	wc/pZK6fdsxNt270NNo1bfaLP/RGWJvPcLskiEs8x6MBx+4VMy+fPEaV8SPfMX6EVUWbcg
	0dBZj7sNtDL5o5CRKQJnf3q2VK/WQAA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.3 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788244688;
	b=KqHZ9kzJEl19d/uh9lD502+e3S/7P6AMfxRQl8qgxVr1Oz36mxDkI/8g6v8f1FZINyN3+1
	MsuI6PJO0s7LUFAsLpr8sMwTtT9+2wHN9OGdLdMneWU2Ye7pP9v8a2Fh+7s/Jhp8mOr0sj
	teRxkan88WBkfghFzlpfklarhGjeXIg=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id da5c7d6f7e2206e2;
	Tue, 01 Sep 2026 06:38:06 +0000
X-Mizu-Trace-ID: da5c7d6f7e2206e2
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	baohua@kernel.org,
	kasong@tencent.com,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	david@kernel.org,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	hannes@cmpxchg.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v2 0/4] skip empty PUD subtrees during aging with a PUD-level Bloom filter
Date: Tue,  1 Sep 2026 14:37:51 +0800
Message-ID: <20260901063755.1519710-1-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tm4iqab7tz58wweznhfyxenfibk465nr
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AF1EF40003
X-Rspam-User: 
X-HE-Tag: 1788244687-83534
X-HE-Meta: U2FsdGVkX1+tv2jDbfA69ifDNkzPBAd3DWB8jGkzdowqnXWrgOWk7w8mRx9OLxGkjz0Hv5GiEReShwBV3+b+hZyS3At7B7R87oTZTM4GktLz07SisyaYr5VPth9Xim9NQ9M8PWyisHOW/rfSTe59F3w/GnU7TbXpGgu8+0nmvaPNyStF2SWaKSFzQ08au9Q+hrUQBlCJM48wBrpYJcuvQax2YC7zArmBWWLG6nqNDckyDmi3zEeZfF5Rdlm9wWVYszNkPpNuyuLzzGd9R2ySGs7Q3IpA6I/MrAVD2CAc3uYJJVLyx2IIoN83CAU5our0rMCMc4D55fSOzzcdgTjkiBF4jhxbaF/j8Q14Ey0RTAet+YzeII5EQus5Iff59FLCrsCXWJKfJbVnrwNRCEFauLiJtg2Yc2DEU2kasmdKeBvlkWho2CLF5tseM9zLPl6CNO3wCnlTOkBy3YLufIGHOlvhoi3Zp5vMgH9TybeQ5o2x7XTyBFOuGQFSv/SSkdOSjODqyWFSk/HGM0ivjGjIYMBJgPm8J62TLXUXkuangvYg7gbTREVTYarzp+I7RNSVBWiHOsYZlcws3432zCGt9fQgYeZSGFV8JN9UPCqeMyLJV/DT0sKpbWiX1bcWM6XkB4HhcGQ2K8BLTM9pV95+I42tplR8rF6q6NhwMV4RzmK9w9WVpXlFIkDQ5+p0i+kM7Mn2Wv7N/QfUlf3VVGH6rXs1rmUNZUUNYROl8RJHDUGQ0K43404q4rufn3yp3CS1g3mJuNL/Q/tJ6LlcZS2L/o7dpQMF38Pr6zl47ddbOX6c3wWl31LWy37Q1H/V+wu3h5mpTLGAAsSoUw49LGcX/dwgXkcT8fcmS/oCsm2PS3rBQ+2Ph6IQO/vRGXEVFLBUh7abmnKOFEvYtPjcxpPUp1mtGfkuxcMJHHNRHVTseRdQf79wiNzMnF59QvDK7u+R3X2yRfHthnGyVOfloLt
 ZzJghUoB
 rDAWkQEMEfC2lv5VtXq9C1xuPMZZvkr9sbt7oCcdQ6NrtWrIhq8n8j/fSd9UVWMua5D6/drzqVqLZou9lB3NbkdUBEbqKydlVRlb8HPbJ1wE8qI68sJ0L/ECNa0enK+NL7D7Uw2X7mu0RR80TcLd9rChhxa+FeLJBYnyoROJCc6nvaWkRJLuG2zyAZqs3OcvDmcHgqd2SJcF2phjxuLTGaoHd7AsDOK2AQd26
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Problem
=======
 
MGLRU's aging walks every present PUD of every mm in the mm_list. When
an mm has no pages on a given NUMA node, all 512 PMDs in each PUD fail
the existing PMD-level Bloom filter test, yet the walker still walks
into every PUD and iterates every PMD. This is pure waste.
 
These cross-node empty walks are structural: lru_gen_use_mm() sets
mm->lru_gen.bitmap to -1 (all nodes) at each context switch, so the
aging walker on every node including kswap, direct reclaim or proactive
aging independently walks the same mm. On the test of 2-node KVM
guest, node 1's walks of the node-0-pinned workload scan ~1235 PTE
entries per walk while finding no folio for node 1's lruvec.

Approach
========
  
Add a PUD-level Bloom filter, one level above the existing PMD filter.
The walker now:
  
  1. Tests the PUD filter before descending into a PUD subtree.
  2. If the PUD had no young entries last generation, skips the entire
     1GB region -- avoiding 512 PMD lookups. 
  3. walk_pmd_range() reports whether it found any young leaf entries;
     walk_pud_range() records that in the double-buffered PUD filter.
  4. The rmap feedback path (lru_gen_look_around()) marks hot PUDs, so
     newly hot or migrated-in regions are re-examined promptly.
  5. force_scan walks bypass the PUD test, so manual aging and newly
     added mm's always re-populate the filter.
 
The double-buffered filter flips each aging generation and the eviction
feedback keeps hot regions marked, so correctness holds without tracking
per-page residency or touching the page fault / rmap hot paths.

Test
====
 
Empty-walk suppression (8GB / 2-NUMA KVM guest, 32 x 64MB workers pinned
to node 0 via numactl --membind=0, 100 aging passes, 3 runs):
 
  node 1 (foreign mm walks):
    baseline (no PUD filter):   ~1235-1254 PTE entries scanned per walk
    with PUD filter:              0.04 / 1.3 / 2.0 per walk
                                (>99.8% reduction; what remains is a few
                                 other processes' pages on node 1,the
                                 cross-node workload mms are fully suppressed)
    pud_skipped:                 ~3.1 1GB subtrees per walk
    worker RSS delta:             0% (no premature reclaim)
 
Build-time regression (make -j4 in a 3G memory cgroup, 4 vCPU / 8GB
2-NUMA KVM guest, 3 runs each; the host was kept idle during the runs):
 
              baseline   patched
  build time  11m48      11m26     (within run-to-run variance; one
                                    patched run of 10m37 was an outlier)
  pgpgin      138k       139k      (unchanged)
  pgmajfault  1950       1950      (unchanged)

The PUD-level filter reduces the leaf scanning of empty aging walks on
the foreign node by >99.8% with no premature reclaim. The build test
shows no measurable regression.

Change log:
==========

v1->v2:
 
- Drop the empty_map (mm-level skip) mechanism. Per Barry Song's
  review, the PUD-level filter alone achieves the goal; empty_map added
  complexity (an mm_struct field, a skip_empty knob, re-scan bookkeeping)
  without being necessary. It can be revisited if very large memory
  systems make the residual walk count meaningful again.
- Rename the counters: MM_LEAF_ELIGIBLE -> MM_LEAF_ASSOCIATED,
  MM_LEAF_TOTAL_EMPTY -> MM_LEAF_EMPTY_WALKS; MM_WALK_EMPTY kept with its
  comment clarified.
- Patch 1 adds the per-walk counters and the mm_vmscan_lru_gen_walk()
  tracepoint used for the measurements below; the series is now 4 patches.

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

Baoquan He (4):
  mm/mglru: add MM_WALK_EMPTY stats and tracepoint
  mm/mglru: add PUD-level Bloom filter state and generic helpers
  mm/mglru: skip cold PUD subtrees during aging
  mm/mglru: count PUD subtrees skipped by the PUD-level filter

 include/linux/mmzone.h        |  11 ++-
 include/trace/events/vmscan.h |  30 ++++++++
 mm/vmscan.c                   | 132 +++++++++++++++++++++++++++-------
 3 files changed, 147 insertions(+), 26 deletions(-)


base-commit: 42d64d4fef83a241c919c8693fdf0a21b2cb6061
-- 
2.54.0


