Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19541C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 11:46:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F21226B00E4; Mon, 21 Sep 2026 07:46:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF8116B00E5; Mon, 21 Sep 2026 07:46:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE75B6B00E6; Mon, 21 Sep 2026 07:46:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BB6666B00E4
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:46:56 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5AB551A015A
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:46:56 +0000 (UTC)
X-FDA: 85237592832.03.E4D461A
Received: from mta1.migadu.com (out-71.mta1.migadu.com [95.215.58.71])
	by imf18.hostedemail.com (Postfix) with ESMTP id 584D41C0004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:46:54 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oy9ctfqp;
	spf=pass (imf18.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.71 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789991214;
	b=xayh53yuDQqBILNhLiSsiGIbrV9EkB0jdAwNfWm2T280uPZFluuaYXhPvlnakAl0uxs9ii
	E1gQuiyMNa4TBtC3EDpT3OTL4mmmgE6Lrz1UCV51224mLp36s8bftJXIo3YVeJcbs3a1zP
	uGt7DlPbvKgWCmBkEr5C2j5QiUZtdFQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oy9ctfqp;
	spf=pass (imf18.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.71 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789991214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bRrJOd5tVhMoVjqXUdmWm8khHPokSUmi1g3FFEbjt2U=;
	b=ZAbBdrfd/ac4re54Yz6CYJKmjdFkmGVrvfSCTBnuWFJOZeR46dTLfMHhp57sarACZobH4+
	iw7feDhJYE+/pWnvf4TJQbr2r6p6RQ8gw43OjCtpUFIeWFRNS+NbfBAJD7mTUdJBDqMOTV
	5bZ/xwkFIdAWcNgF5q1CFNb30qCLqhc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=OhxhrbKLBotENqeglIYbgbCgzsQP2IEJ2k2gb4BjpUc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789991213; v=1; x=1790596013;
 b=oy9ctfqpv6m8GH/0H9CCnAf87+Pk8zU+1ER5Cz0YZSWrdy1ScDKv5KHaIdShJb4hQfBDvZ5S
 oQPZKPSpd+pmfEfpiL7a2WlPVKwBtcJ6g9U9Fl3n+euAH5CzYkO3aXbwGYQlF/3WbeliY82mZB6
 48q+XKazpSeoSzwhBB99oGso=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9d7bc3f172d5fd19;
	Mon, 21 Sep 2026 11:46:52 +0000
X-Mizu-Trace-ID: 9d7bc3f172d5fd19
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-mm@kvack.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH RFC 3/4] mm/vmscan: move struct scan_control to the local trace header
Date: Mon, 21 Sep 2026 19:46:05 +0800
Message-Id: <20260921114606.3871820-4-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260921114606.3871820-1-ridong.chen@linux.dev>
References: <20260921114606.3871820-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 584D41C0004
X-Rspam-User: 
X-Stat-Signature: afxwoqbprz3xg1qhdj1sti3sh9udm5ba
X-HE-Tag: 1789991214-770977
X-HE-Meta: U2FsdGVkX18X/Tvy2GCYFP3HGL+OYw4rIHMP5XJYfY+wqljVhgo2ojBmdZFTHimVET9CoXUCFsNRq0EuJFpLRZukuvpRzlHoGuwKJow7d31sHNNc8+ffsZ6F9mAef7PCukXqFZOToW8+sFmqUpl7WJ6Qs35G6qZBBKdbjQM0OECC7CmhCUVHLTP/6SZE1n3rdnJNGln5pf5uHtwhdFvPpS7PGvIZh09u2HZHNndgig2EC9kCjs8xhFCvgkJTDJ3RDPY/Aa8WEE9f0ZOnD3tCRnfuYz0qMPKa03d8Fq6uSDa0y6Yf7JYSLs8Nt1mNupuu1Svz4dPbQBVgXsnulH8Yxahc/ovkfkRCwguLpKxeugpRa8LITiLwlXDmmajsMSsdEfsVuLlD6HrXrQ7zvUucL6GXA7BfTzEn88dI3UrqFvo4GnNfLFmcDF8mgliWh5CJ6FMcRk2uBC0BCqWaXk0ar9ofLwitG/fidOJmNIBdJTfMwVKj4vgmJmG+7p58gD5ADHKjVJVT2N/KxiCFWgWoCgrhNnKVhxqRdJN9aoAoCCy5dVjxBJVQ4Lq2BNnQ36HqBUlpkWBn94za2ae4xa4kdBczab+7wZB5Ke9qleaHLwnOIEHYc5XQJKxaAqBMJX1YwFOTGtj/vEpn8E1AQeZtOhn6B+OuCQC/B4lePPeBHJcWhSzW3lFDudW0pqQb13GJ1hJjyvzJaHDPFzm6c6anbRlDx00oRt/GR0fgIJrCdspgo0Mg5301MfGWqOOZGT8jhAZwBwbelOa0JDNWYEjpo8Sa44ttO4/a6TO8ye76YMy0djpusQkWy1XlA2AmRLTiLEdcsQtlb7bbrCzMbX4OQVQia5rD7YnSWIAK7G33c1S9s8QYHPAS4FWixTfuRuE9IcifXaG6Fb5IDrNdQrvevtov0wUhNY5+pS9PyU7MktOhq5Jqc1LWVB76SU/UrCrzIlHZE0ESrE0xPc9ODkN
 sUoorzim
 pB/ZQWx0VtwZlubXwTjAdC8TlsZb6OM1tDbEOZTBEFhNfh0lEmn4HStVaxu658qww7LW35PuCZkze/lgH8gi0kP3tjoejshb+eeqsU9n/KH/X/MKYx5HOgsdMNLRzDeYtW4AL4VuK0JOcpf5GMsLgOazL8Fmnv7v2VKS7VmTcwMFoMu4DJy8aWkBSm7KDNfvsNh8xOO+zaGdw7IC+MMWnBhzQKyVeyXdCOxyCVl+gusKggZWt7f5COZq1EKY+JCIuIPck7yL9kwUkxMNEmJtZqUO85djMNxZQPyU1eKorOY3Tw9t6cTjwowONFsntnS05sGNfTZXKo0a6/9oOQdy1G2Ekzc4x7jxBRTavBNZyitbzdtdur54RgW792s5jFcVEcJNLy090BSyZMk2iMs1UvabP2H375FRnko9a8zJqH7ZnH+mflHNiZMApbiFrljAGp9rfovQbCTShKiI7nWxw6s5z95VM7QQ7sAsMrqWM789x1nIS+WnKApSBRlZVHsywWBZKX839o+3XyqrhebH7trVyioMmYKIo3IRsK/AaEYnDYnEyAOtiXGdQddPaodlZlRleQNAkwiGZP4rRoqWF3vZypZXliXIOrPvWdqKBQA+t5aWEuEgeny2IGfA0Ym7wgZ4t0y0b+uHJY7smhG0zHHtPG6JX0gNjITRK8eOYT0FLc51VGQBxn7pyC2+OuJxOSqAKtSxxbMAqJCzItbwcww8gkcs+WvHE+BqldJmNW6fZ1/+O3weIPiqMNVp8KiN3wA8/ICXWFDSzSGSDgp315Ems5OrrvB7Xm0efnVlJbdj59zHYKnL/64yzAON6krjHWmTZVxNbbfqICuMsUWVBa1WN8AABo0jCXSA5SEoTQyOUD7r3ZUZuzTDu9iISAj1LqbeRzrC8TZiIiDXrWFli/pQh0klZh8+y4+tkE5z3PdCNwyVewK32VYcmbmv4inEvfOO+hSLQaCrXlwzSghp+EWv/hVBS
 L8v05ZeD
 PmgYt5qF5g7k0bntMGh0v1Z09VfvUD/itdLNiAUs0idqyHI7jDhmzcOin5fH4XLgjLEnUmpICHo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

Now that the vmscan tracepoints live in mm/trace_vmscan.h, move
struct scan_control there as well so the trace events can reference
reclaim-internal state directly. The definition is wrapped in its own
include guard because the trace header is re-read under
TRACE_HEADER_MULTI_READ, while a C struct may only be defined once.

No functional change.

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/trace_vmscan.h | 115 ++++++++++++++++++++++++++++++++++++++++++++++
 mm/vmscan.c       | 108 -------------------------------------------
 2 files changed, 115 insertions(+), 108 deletions(-)

diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
index c5d824fef554..c8ac5d4e4043 100644
--- a/mm/trace_vmscan.h
+++ b/mm/trace_vmscan.h
@@ -9,8 +9,123 @@
 #include <linux/tracepoint.h>
 #include <linux/mm.h>
 #include <linux/memcontrol.h>
+#include <linux/swap.h>
 #include <trace/events/mmflags.h>
 
+/* Guard the struct against define_trace.h's repeated inclusion. */
+#ifndef _MM_VMSCAN_INTERNAL_H
+#define _MM_VMSCAN_INTERNAL_H
+
+struct scan_control {
+	/* How many pages shrink_list() should reclaim */
+	unsigned long nr_to_reclaim;
+
+	/*
+	 * Nodemask of nodes allowed by the caller. If NULL, all nodes
+	 * are scanned.
+	 */
+	const nodemask_t *nodemask;
+
+	/*
+	 * The memory cgroup that hit its limit and as a result is the
+	 * primary target of this reclaim invocation.
+	 */
+	struct mem_cgroup *target_mem_cgroup;
+
+	/*
+	 * Scan pressure balancing between anon and file LRUs
+	 */
+	unsigned long	anon_cost;
+	unsigned long	file_cost;
+
+	/* Swappiness value for proactive reclaim. Always use sc_swappiness()! */
+	int *proactive_swappiness;
+
+	/* Can active folios be deactivated as part of reclaim? */
+#define DEACTIVATE_ANON 1
+#define DEACTIVATE_FILE 2
+	unsigned int may_deactivate:2;
+	unsigned int force_deactivate:1;
+	unsigned int skipped_deactivate:1;
+
+	/* zone_reclaim_mode, boost reclaim */
+	unsigned int may_writepage:1;
+
+	/* zone_reclaim_mode */
+	unsigned int may_unmap:1;
+
+	/* zone_reclaim_mode, boost reclaim, cgroup restrictions */
+	unsigned int may_swap:1;
+
+	/* Not allow cache_trim_mode to be turned on as part of reclaim? */
+	unsigned int no_cache_trim_mode:1;
+
+	/* Has cache_trim_mode failed at least once? */
+	unsigned int cache_trim_mode_failed:1;
+
+	/* Proactive reclaim invoked by userspace */
+	unsigned int proactive:1;
+
+	/*
+	 * Cgroup memory below memory.low is protected as long as we
+	 * don't threaten to OOM. If any cgroup is reclaimed at
+	 * reduced force or passed over entirely due to its memory.low
+	 * setting (memcg_low_skipped), and nothing is reclaimed as a
+	 * result, then go back for one more cycle that reclaims the protected
+	 * memory (memcg_low_reclaim) to avert OOM.
+	 */
+	unsigned int memcg_low_reclaim:1;
+	unsigned int memcg_low_skipped:1;
+
+	/* Shared cgroup tree walk failed, rescan the whole tree */
+	unsigned int memcg_full_walk:1;
+
+	unsigned int hibernation_mode:1;
+
+	/* One of the zones is ready for compaction */
+	unsigned int compaction_ready:1;
+
+	/* There is easily reclaimable cold cache in the current node */
+	unsigned int cache_trim_mode:1;
+
+	/* The file folios on the current node are dangerously low */
+	unsigned int file_is_tiny:1;
+
+	/* Always discard instead of demoting to lower tier memory */
+	unsigned int no_demotion:1;
+
+	/* Allocation order */
+	s8 order;
+
+	/* Scan (total_size >> priority) pages at once */
+	s8 priority;
+
+	/* The highest zone to isolate folios for reclaim from */
+	s8 reclaim_idx;
+
+	/* This context's GFP mask */
+	gfp_t gfp_mask;
+
+	/* Incremented by the number of inactive pages that were scanned */
+	unsigned long nr_scanned;
+
+	/* Number of pages freed so far during a call to shrink_zones() */
+	unsigned long nr_reclaimed;
+
+	struct {
+		unsigned int dirty;
+		unsigned int congested;
+		unsigned int writeback;
+		unsigned int immediate;
+		unsigned int taken;
+	} nr;
+
+	/* for recording the reclaimed slab by now */
+	struct reclaim_state reclaim_state;
+};
+
+#endif /* _MM_VMSCAN_INTERNAL_H */
+
 #define RECLAIM_WB_ANON		0x0001u
 #define RECLAIM_WB_FILE		0x0002u
 #define RECLAIM_WB_MIXED	0x0010u
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0eb7fa8e1d43..2fd9b42f89d8 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -73,114 +73,6 @@
 #define CREATE_TRACE_POINTS
 #include "trace_vmscan.h"
 
-struct scan_control {
-	/* How many pages shrink_list() should reclaim */
-	unsigned long nr_to_reclaim;
-
-	/*
-	 * Nodemask of nodes allowed by the caller. If NULL, all nodes
-	 * are scanned.
-	 */
-	const nodemask_t *nodemask;
-
-	/*
-	 * The memory cgroup that hit its limit and as a result is the
-	 * primary target of this reclaim invocation.
-	 */
-	struct mem_cgroup *target_mem_cgroup;
-
-	/*
-	 * Scan pressure balancing between anon and file LRUs
-	 */
-	unsigned long	anon_cost;
-	unsigned long	file_cost;
-
-	/* Swappiness value for proactive reclaim. Always use sc_swappiness()! */
-	int *proactive_swappiness;
-
-	/* Can active folios be deactivated as part of reclaim? */
-#define DEACTIVATE_ANON 1
-#define DEACTIVATE_FILE 2
-	unsigned int may_deactivate:2;
-	unsigned int force_deactivate:1;
-	unsigned int skipped_deactivate:1;
-
-	/* zone_reclaim_mode, boost reclaim */
-	unsigned int may_writepage:1;
-
-	/* zone_reclaim_mode */
-	unsigned int may_unmap:1;
-
-	/* zone_reclaim_mode, boost reclaim, cgroup restrictions */
-	unsigned int may_swap:1;
-
-	/* Not allow cache_trim_mode to be turned on as part of reclaim? */
-	unsigned int no_cache_trim_mode:1;
-
-	/* Has cache_trim_mode failed at least once? */
-	unsigned int cache_trim_mode_failed:1;
-
-	/* Proactive reclaim invoked by userspace */
-	unsigned int proactive:1;
-
-	/*
-	 * Cgroup memory below memory.low is protected as long as we
-	 * don't threaten to OOM. If any cgroup is reclaimed at
-	 * reduced force or passed over entirely due to its memory.low
-	 * setting (memcg_low_skipped), and nothing is reclaimed as a
-	 * result, then go back for one more cycle that reclaims the protected
-	 * memory (memcg_low_reclaim) to avert OOM.
-	 */
-	unsigned int memcg_low_reclaim:1;
-	unsigned int memcg_low_skipped:1;
-
-	/* Shared cgroup tree walk failed, rescan the whole tree */
-	unsigned int memcg_full_walk:1;
-
-	unsigned int hibernation_mode:1;
-
-	/* One of the zones is ready for compaction */
-	unsigned int compaction_ready:1;
-
-	/* There is easily reclaimable cold cache in the current node */
-	unsigned int cache_trim_mode:1;
-
-	/* The file folios on the current node are dangerously low */
-	unsigned int file_is_tiny:1;
-
-	/* Always discard instead of demoting to lower tier memory */
-	unsigned int no_demotion:1;
-
-	/* Allocation order */
-	s8 order;
-
-	/* Scan (total_size >> priority) pages at once */
-	s8 priority;
-
-	/* The highest zone to isolate folios for reclaim from */
-	s8 reclaim_idx;
-
-	/* This context's GFP mask */
-	gfp_t gfp_mask;
-
-	/* Incremented by the number of inactive pages that were scanned */
-	unsigned long nr_scanned;
-
-	/* Number of pages freed so far during a call to shrink_zones() */
-	unsigned long nr_reclaimed;
-
-	struct {
-		unsigned int dirty;
-		unsigned int congested;
-		unsigned int writeback;
-		unsigned int immediate;
-		unsigned int taken;
-	} nr;
-
-	/* for recording the reclaimed slab by now */
-	struct reclaim_state reclaim_state;
-};
-
 #ifdef ARCH_HAS_PREFETCHW
 static inline void prefetchw_prev_lru_folio(struct folio *folio,
 		struct list_head *base)
-- 
2.34.1


