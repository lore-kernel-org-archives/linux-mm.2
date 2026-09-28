Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CADD8C9833F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 11:47:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC5756B0096; Mon, 28 Sep 2026 07:47:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E994E6B0098; Mon, 28 Sep 2026 07:47:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAFCB6B0099; Mon, 28 Sep 2026 07:47:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B41106B0096
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 07:47:27 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 496981401C2
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:47:27 +0000 (UTC)
X-FDA: 85262995734.09.81CCC22
Received: from mta1.migadu.com (out-69.mta1.migadu.com [95.215.58.69])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4468F40005
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:47:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SxEn55a6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.69 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790596045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZGcNNGn9a4CiKA0zNyML74zEt4GSSkxP59wVUnaSLw4=;
	b=I0v1PEBvOveQs8d1nJjfuwotBFHU8UczQOve167M9ZWiPqhdRjvRb3jWMcLb2ANcE/Ddex
	UrAMv3eHz1HpV2+nsPEGkqRKjJB2vQ+aVFIDIhmE6y25tzaguTMrRtM7DA8Lx/njSPpiBL
	42U1BJzcMHlc5WBDkaXvx+OK2+zoKFo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SxEn55a6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.69 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790596045;
	b=1C2GL+tCBSKH1+b7was3wmWDZFWiVH1za+iKlkkc7tAr03ZLUqmLnkN/elB9jvDSn186vN
	DLeIc9u0gH17qFtr86qEvAubPfZpxTiDGLU7uxYYy3thGtSSGESnplXQIKBSYkjXBvI6PH
	XCYOk6HXlrWina0Iq9/KqTYebg7rac4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=7zFwk4Paje4E5pTLU+7aaS/dSd6Pnl+CakDhLvoL16c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790596044; v=1; x=1791200844;
 b=SxEn55a6Uu29QitRQWjd3yxoGrRAwZdr8JsQM3uHY00QB4aqhqA0nljpx/88GhmqXaQqyC9I
 eBTw1jqUvLGLBLSqhTmgvXZg2HDJmD/X20jBZMsQi3fckiUBps6EdP25ofiymBgMGS1im1u/xhf
 jlqPq0HrlAmJDpa74Gb8aZMA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 24ef6038d28926c4;
	Mon, 28 Sep 2026 11:47:23 +0000
X-Mizu-Trace-ID: 24ef6038d28926c4
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
Subject: [PATCH RFC v2 3/7] mm/vmscan: move struct scan_control to a dedicated header
Date: Mon, 28 Sep 2026 19:46:20 +0800
Message-Id: <20260928114625.3609130-4-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260928114625.3609130-1-ridong.chen@linux.dev>
References: <20260928114625.3609130-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: x7kk8xwha5mcoztcga9fenkgycbwnrak
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4468F40005
X-HE-Tag: 1790596045-454610
X-HE-Meta: U2FsdGVkX18br9qtWQIlmIzPv3kVVX37umrVzdCXndiDlWom6LhV/ytRjNE4bT6calWDq2fqmY1K0+I7DsdAamfhx+84TRv2FYjcPKgCC/oo1l2pUxxPyDKSujLxmGZN/vFX4eRhJ4/SGZ2XokcPSksjwoCg+lGC0Rj3GOUh5U0jdQDkq/lypwGpyfif5SQV5OH6XjwJvf7sPNGVoh/chenBwHVhr37og5iQUHi3wK9Jx7/UtC/9FuCDh5LBZXMUsMTcGVA8n1LaEg2kPOs4X+Pnmz+BO34N1kbAGc4aFR43O+nNT/QhH0qrF7esRraVoAl7SleNFxt0mNWXx+mGlRpnvG306Lhq3dFKYdMIYoqrtiJ5U5x5mFhzEfWToloSgc7BXwbXEjX1nOZcfWjxUkHLeBalBb3UdAhy2zn959+aDZkN6M4gHYy7t6agw0R0bdl31uFGF11NB0Pg9Lq1JNQIYugmDpXJXvkv1hG6YkAbYCeWBhbYYkCRaOtqmkrmchVOZY3vs2Orf1B+wQuJQLxUh4uloaBZKm/+A6uHG2qiTObNeSqQBM5G7Oce5jomWeON350ACyeRX83ufwLI1pG5YZNpBKWECYD4foN7mvsTuXr2li4La+t12wSfVk5DpGF1LTHBzQ89e+oEx2IrLmjI0fxOIcSWSij6xJm6qSQFzFc73nKx5k7chPYuvrXURQV7f+aaBcAcS4s72wZJF4xDHZSImz26kk04zrCTmsqvTprhIXWGLpIkpDcSZuuKn5Of5nyJuuvHsN6uh2q4DVUuKUY+js9q4JP7CBmWmUHuzAKeuXVVTXrg/5jGE/6LLjE0frqN73qz2COoKuOJLSQlIvV+A5InksCEh5GmBf13fSxa3gELDax8LMTWogIndPcpCA+VQvmibEJMlueDsx4gov9zATY2mnbYcrX2qPdXv3K0mgU1SkxmJRRTytkHvrZ5VVXpBPN2ekXaUk2
 3q3VA74D
 Y6VrhJ/qb4Q1HS8nmU4LOj0lntmopzCBUPucURG3i6bsHX0Imy8S8U9fvutW4igliS+AreyKm0lUIAUDUxlwZqVdcfE4Tzy1fP8Po/Pe5hSAe9lz5sjXTd2MTrXCfd9Ic+MA3ATCJBkM9x9hXKz7aofE1fcWlpqj0EZjuXQ5zDY8umK5J/+0Nf07QZH7fgseVCzmtxgnK8vjBPy0SKiHFfJv+toR3i9PqzBYK9HqbkHSf1W2u8WqxArRpyAgDAJVgFUpU+3hpHzYff64A5us3D4hpfznfKq5IYXEwggvNEENAlvaDhPVJwdnZRVnTYQU7SgK5yBcSf6a1Q6Tu+itMyBq6OSiTT3/CyHdadadV8XIiN0NhxwFWHfYLGRtgt79x0G5arq013Vb7DvklIP8Yso2jZqegyuzx83aJBmVH1N1wJswAiB1gWbWbtUdzULt66hprDZRLw/53dZ+CwVDAqdGDSdzHu3R50Qw6B4yJBiv3Vj9mJyLNPvIBe2GCWDBgtHzFaqpyEnqOmYgjE282B4T/V5921Fw2PkKJCia3LoHcSuRursCGZLoYsCIp63UAFhCNWBFrAyquMuRrjCH//d9RRvmpjHr9+XrVCvVVLTQh5OOGhJhroQpl+kxJ0x/60a8Rrg2xOzLeVCO0YAX7zKLBNEsJtFp6Tz3gglJ0vgmE8wRcGb+/xsu4vDDi5uLRO9bfwbM/0A/MT4CvYp78fHW7Cq3scaNnoJhNtqkuh52deJwAucoKy+bHWazNJfyU9QLK36EEVCw91AWvGB/ht1Qv5Wc3PDklFpXKHruL8boYqZBJ+Les02xPeqribM5lYgwDXr9/i4U1x5psJ9WUOhp9z30IqM41qhUU/E2esSkAJYMNqvQoujnMRsMppUhik5mkb5PrvMB/cIHfosxlX9iYhFfZuFDXlA7OnOmc2C9eCnWH/YYqtg3Mwsq6uE+005+xVzqQ7BlrWOFkVKiVXRN8ywYW
 8p2d+DgP
 R3TbjJMyA0GKgO8ScdZ8p5O4lIV0F7w+PsfWfSvGcNOyXlTaToSFjsapWom+bUiSDXQFAKgW9O937WhOfoKoEyaSbEXFCILHLRobCsNDq2HcPAbQIYOAcr+n4btEiqh+sDUN1dMe4Ww=
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

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 MAINTAINERS       |   2 +
 mm/trace_vmscan.h |   2 +
 mm/vmscan.c       | 108 ------------------------------------------
 mm/vmscan.h       | 118 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 122 insertions(+), 108 deletions(-)
 create mode 100644 mm/vmscan.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 281a6aca73cc..4751712d0b55 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17231,6 +17231,7 @@ F:	include/linux/mm_inline.h
 F:	include/linux/mmzone.h
 F:	mm/trace_vmscan.h
 F:	mm/vmscan.c
+F:	mm/vmscan.h
 F:	mm/workingset.c
 
 MEMORY MANAGEMENT - MIGRATION
@@ -17379,6 +17380,7 @@ L:	linux-mm@kvack.org
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


