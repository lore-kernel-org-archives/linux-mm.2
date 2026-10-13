Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F059CC6B03
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 13:14:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 722316B0096; Tue, 13 Oct 2026 09:14:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F9EF6B0098; Tue, 13 Oct 2026 09:14:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60FE86B0099; Tue, 13 Oct 2026 09:14:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3C5286B0096
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:14:10 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A8D90160BF9
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 13:14:09 +0000 (UTC)
X-FDA: 85317646218.20.D3C50AD
Received: from mta1.migadu.com (out-169.mta1.migadu.com [95.215.58.169])
	by imf04.hostedemail.com (Postfix) with ESMTP id AEFEA4000D
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 13:14:07 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JzoHZx87;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.169 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791897247;
	b=Mya02MDv5ATrNlcKxJCO+nHg8vb8uvV6wA+1+OS1jPAzHXjvFcazewOmb2atpWvq7Xwj9L
	IQVS1zBmd9bTEpvj5feyTteH4YabSQomJj3MLLUA+Wl0Ybx0VhN1uApQeGCRhY6mxtAdhE
	bY4T/llcG7t37ANlP/hPzOHgmUH+qR4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JzoHZx87;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.169 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791897247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UiOBeViobk1obxWohPtKOE4rVRnFttAZkE4NVeYczl4=;
	b=dReCmP6P32G/lALV7BeRlMnPmBBGVzX00TscRtoY4LLUoSMuOgtACapd7n3nfdCK2xZgG6
	wxxLiVeXeUV6Mww+61i/UTNx9cQVAQ/6SdY1SLMeB3CakBMQyMrqMHrmPYHtFZFLGu5X8l
	gg6PJaODghdPSAxPisGpgNyqWJ6EhSk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=eKkH5LZpx1O+6s3LteldUr3wXvE1BxOolkV5VXVdICA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791897246; v=1; x=1792502046;
 b=JzoHZx87HFoI5KoVo156PO9OfYBc+AHnPtWqjV95NwQVh4+9k0zZOw+lP1Vdh6CfGTcYi5QT
 AOuKxtZ2u7K8hzy7YZIfp8KESurGY3HQAgp2qVNB84lnNYKvaEtMOXMrOLthwGQX3vngl13gN8l
 xEJANYcKlj70GGoITo5Dzi3c=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id af0246310e5422fc;
	Tue, 13 Oct 2026 13:14:06 +0000
X-Mizu-Trace-ID: af0246310e5422fc
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
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-mm@kvack.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	bpf@vger.kernel.org (open list:BPF [MISC]:Keyword:(?:\b|_)bpf(?:\b|_)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH RFC v3 3/7] mm/vmscan: move struct scan_control to a dedicated header
Date: Tue, 13 Oct 2026 21:13:05 +0800
Message-Id: <20261013131309.2790253-4-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261013131309.2790253-1-ridong.chen@linux.dev>
References: <20261013131309.2790253-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: shkznjxhpnwxt5xwun5dja864i6net49
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AEFEA4000D
X-HE-Tag: 1791897247-22823
X-HE-Meta: U2FsdGVkX186FE2aNPvxirg09lFOwwTdHEoDByk6TVpKYWtN6lLywl8LwXpk3KWKpIg7b8ed/HOO5pXbuNAJCbkyQMNW2QDq2N6YzQa65RlS4SDr3nqwEdY5nWLb3omc3FVk7OefklVt9AJRbc5Jlo27aw1gQg2Wv1PdmTHoqWgq/wfBTaeTKfWMe1yC7wGS7y/v0u9kzHgAIu67sIPY3pJwozXOw3wxzpDs02BnetyyCbJPQFsJaVcE3nHN1QT/N0rgqa0G1Q0V5bNuBT8J/TVQcRCMrY+3QmJ8b4G+xlescgzoXr+qPv+pU4l6d6KoDhAd2YbQJ8QMFGXltYM6V1HVAZ2PqzjHZteuCk9NjuYpFQf3nk1kbnU3tcgw07V/KSV+DxemRC1GYAD/XNrESL7ptJc6QoH3MX8FgnlY3E+5hGJC9EhgABwz3K1n+wBmEgPmYbgFjdJA1EP9bPRYD5cRP+ACrfal1k18FNx1YJBB/K5RQaOk8lwvwu5Pxp0zxWLVMFfhjEyCCD5756puuybgX40ZJafb9pGwg1vIrcVe7HkXBLNjnbovKjgSKmNP0D4/llSErQl86Mof0rv4OrSDwT7ARD7snN5pCc4Zc8DTytUpjmYmaTKUWMPZ+wmu4zLZdtUswbdcyGWlMGOEJrKn+q7rP+zOQuIf+8htThQNnH0PepNfAg/V+flahLaejeOxVhYAdqVPC7291uc6nAV0FLTDbfK8Gwgh6Z6WwM4iscEhEenPWYrhthrSUiFcKSpaGN5LM0R9w2Jnf6mesI59ybeiSpUEQwVh19/PmDgO29rTr1SrR4fpVsQeLtCgdmOuBuVcUxy035g8yeqQnZpnKl8cB+mv5OyXWyasXYl57i2v+JCAzdc//i46hLn0a5ZIepNe/3e0yZth33+g1IRwe92pMsT9WN7Wo8EFVx9fyoLTuXyIKYtl8dbSPu9ycSZuX6gBIgDmjJhVZFo
 pPd+96C2
 FySEmRyMvVbb+FajqvWPJpeep8kVn7uhi22HQbkpCwkDP88D8WGBs6ayoihwDzqSzQmLVww3uAVRuFlDIZ0wLHVM/HorOFyWAt0jXGaYrQFvyB0UYcRm4m0/04Hno/P038+pQahUs0nGNDc4Cu2Z1/OmWHRGUHogP2AbXwNArTFbsX51R3zthZUTiggFPHGvVu4vVM1/+QruoqqWB8moaWuC21VCmb7HpYzBVCf4Pa8lv3DxPV0JDQWPAWcVTPsgJJkIXDW1TOvaYiDABqi2QGNVpietwDN4Y8FWvs3bhN+ih2xxDHc0CfVJ6fR0weksGp+1i94TLpUSEuc7Gay4XO4MtlG9AFZyIX7xMuhvXbyDh1tQ7sLSueEJTmJopNP64RmRD8c1lJ0xITGIUnrhF63+MGotX3AtqJSle2BzLwNiNW0xIJpTUJnwIVhxZl6yWUJhYDpQRCX94MmWW9TncRShDL/0IZ88dBT569hw2WxdtXeYLqrclX0zRBmZQcwxvxtFbp/AlaReN8Vo1u+lduO5UdGOF/R8gZotY2HjPSuwQurJE4Lrpy50C8zX5IQH6cuFiL81nwBvp1fub9zKWGyWKjG+HNdAKM8vc4wF1TDDvjUeG08OoxIiwRJ4hXoD73ZccW+s3kmm0Dx6rEwwaBvLHkxF9YavsbtBjk7TG3q8B+c0SoBTD9zWaSW9VWz3IHOxA/ObNniOdo+GiWJ9ulq/DhpVwYb+6kEWeh0xPgqaxhQU9BNw4kic1zBZp6XF3O5eZUBJNz4UlLniNOr0hxWuCO6qJR1hA9FzjdCoqwtG11/BCTatMl6an/dScvtcBHVjcM/yWlypWGlElwzGZ0uB7e7XFBENSpJkUi9cmhy0iIDnwVRZOirOR/ZWb/2mUlHsKi0BUA0ffr2OCnseFhYhrx6oH+TqHnOEAnDbcG5Ml4Hm42w5UWSGXxsfltsBfEJeYKdpbRRw8Ef4YmoN/NrhrA4AP
 J111SEJ+
 nOP6TdSjPUkH2dubyTbpY5OHjTSJNsf9oEpiSAx6gnY1rqNPVhGls4/JUWMdwtngWLk5ejnzFHP5Q6azBFC8HCNg6OIbMi3FujYIIpirWfi3N1ek8nDpX6netmp97NCC9ev04tOpSMA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

The definition of struct scan_control has lived inline at the top of
mm/vmscan.c. Move it out to a new mm/vmscan.h so the reclaim-internal
state can be referenced from other reclaim translation units without
duplicating the definition.

The header uses an ordinary include guard and pulls in only what the
struct needs (nodemask_t, gfp_t and struct reclaim_state).

mm/trace_vmscan.h includes the new header directly so that any
translation unit pulling in the trace events (mm/vmscan.c, mm/shrinker.c)
sees the full definition of struct scan_control regardless of include
order.

No functional change.

Assisted-by: LLM
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 MAINTAINERS       |   2 +
 mm/trace_vmscan.h |   2 +
 mm/vmscan.c       | 108 ------------------------------------------
 mm/vmscan.h       | 118 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 122 insertions(+), 108 deletions(-)
 create mode 100644 mm/vmscan.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 80d2a9dd0525..1f2d7dcbfd1b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17577,6 +17577,7 @@ F:	include/linux/mm_inline.h
 F:	include/linux/mmzone.h
 F:	mm/trace_vmscan.h
 F:	mm/vmscan.c
+F:	mm/vmscan.h
 F:	mm/workingset.c
 
 MEMORY MANAGEMENT - MIGRATION
@@ -17725,6 +17726,7 @@ L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/trace_vmscan.h
 F:	mm/vmscan.c
+F:	mm/vmscan.h
 F:	mm/workingset.c
 
 MEMORY MANAGEMENT - RMAP (REVERSE MAPPING)
diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
index c5d824fef554..91fb1c30dd46 100644
--- a/mm/trace_vmscan.h
+++ b/mm/trace_vmscan.h
@@ -11,6 +11,8 @@
 #include <linux/memcontrol.h>
 #include <trace/events/mmflags.h>
 
+#include "vmscan.h"
+
 #define RECLAIM_WB_ANON		0x0001u
 #define RECLAIM_WB_FILE		0x0002u
 #define RECLAIM_WB_MIXED	0x0010u
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 6207dad9e644..ab118f6b32eb 100644
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
diff --git a/mm/vmscan.h b/mm/vmscan.h
new file mode 100644
index 000000000000..adb22e80d760
--- /dev/null
+++ b/mm/vmscan.h
@@ -0,0 +1,118 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _MM_VMSCAN_H
+#define _MM_VMSCAN_H
+
+#include <linux/gfp_types.h>
+#include <linux/nodemask.h>
+#include <linux/swap.h>
+#include <linux/types.h>
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
+#endif /* _MM_VMSCAN_H */
-- 
2.34.1


