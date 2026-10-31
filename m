Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87418606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=tozsAYZQ
Received: by kanga.kvack.org (Postfix)
	id 9BB746B05B5; Sat, 31 Oct 2026 05:01:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9930E6B05B6; Sat, 31 Oct 2026 05:01:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A8FD6B05B7; Sat, 31 Oct 2026 05:01:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5D05B6B05B5
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:01:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0FC33405FF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:01:35 +0000 (UTC)
X-FDA: 85382328150.01.104A182
Received: from mta0.migadu.com (out-141.mta0.migadu.com [91.218.175.141])
	by imf19.hostedemail.com (Postfix) with ESMTP id 07F481A000E
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:01:32 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tozsAYZQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.141 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793437293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fiiKrBCpHUYOHtqd9WqUWhp2nvmCUlooq/peEHqO4Go=;
	b=7Yhwo7I1aYjp2WlW6164TZB4TYE4G5NIrR4MqpPQ5Mzzl4P/QA/jmx5+Zu0WKq8TbMu1EB
	91Hr2KbBrKolbED+TycPh3wjRc3+3tYgiy5TgEy1etgnPOyh51mlVb4yjnlnXfnm277u5y
	5zpsWlAdZ6+zkeThoAVLzS1+GaJmwZU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tozsAYZQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.141 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793437293;
	b=Hizw90ywLScvNTuGKcjvQCmjaE2HysnBuchJJhSeGzUjilB7/tdhbB9BRfWSEozXG28Y2Q
	K7AaTMmuYXZtXgZin/mTLV8m04lhkEAHFck6q3uSE33a2mlEvCVpBOYkIWDVN6iW4J3rif
	3TXZe/CTkp9NNRkS9Z4ATj3UQ3mBqPU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Ef7uDXCWASIprI+9tULZE2dA/Lb+54sHHrZJ8AHqF0o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793437290; v=1; x=1794042090;
 b=tozsAYZQlWfc8MmPR1dbsAqTWJhTZ8NmRXZXD4xx7CZEfONDAItng6jipxhZBC6xc7OJpUyA
 ZF6A88vaAecXXnZtEV4UAmi7NNuw461Ul7c6Ymi2OFx0fF2127gBOlkwNQ/PvYO2kAW0YI9R6GJ
 CFnDhIeg20qynC3EinLYnfP0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d33284fd3119d6cd;
	Sat, 31 Oct 2026 09:01:29 +0000
X-Mizu-Trace-ID: d33284fd3119d6cd
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
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
	linux-mm@kvack.org,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	bpf@vger.kernel.org (open list:BPF [MISC]:Keyword:(?:\b|_)bpf(?:\b|_)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v5 3/6] mm/vmscan: move struct scan_control to a dedicated header
Date: Sat, 31 Oct 2026 17:00:38 +0800
Message-ID: <20261031090041.58574-4-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261031090041.58574-1-ridong.chen@linux.dev>
References: <20261031090041.58574-1-ridong.chen@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 07F481A000E
X-Stat-Signature: fnmyn5totxj6sacc79stiorcs7mywe94
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793437292-939428
X-HE-Meta: U2FsdGVkX1+7jsvlpptBNtsElfAu7BpY9+cwVdsaaGsrjVtqp9MYI5tNfXpsIqWd99uI2ULWVgCeyow93pyhlexL+WjdUw9+ZuwNjG9SatQztYFthYLWkGiTZPyJrquOr9K1NeWUKmguYm6TE0A8g5m7nrvYqYunQxwooRliFRDPluA7L7/Wlqa0qTGVyNFGOOlN8+n0+siCZAlnc8A5iQE2GxEhY3IIMhXV+FfnBSigM+j+ixjHuLM4nKINNve5nFI6M4mD1kJ2MizklxsweamZIgrFYy7Kfc7lI6aqT0Y/FSQBpUDWz7PiK/++UGkWrWSo2XF1XYkFW8FvIVJAUr8AeegEOESHUdEgtJlh1NxWc9ni56bfwXZeQ8yoUSU+bxxs2ttiVqMf7u/VlMhGM99+G4xN1nP7N+gYQ51EsD2Zde5Ldx2lV+whAwyKR0DdLYV9rAt/G13Kye6UuKqoEdzqWt4ES/WUkUhsN1a/MWGNKmc3nY5aG53Zhj1nThiOA37uOkJkhs4xhtepptncThe8yF/KFORMsPMFXB8Sya9AUipjm25xEp32QCTlF6ue7ih+3CI6/6Y3rGiiW/KmXV37i5pNeFMT+9tGfhH7v1ta15LpQ1itTi5V92orstIF9oQCFW89mHcABRR/H6QANDCjAtfG012kLkGMn93O6FJCc2u9qRm7PkMUE7IWy3kM5B9pz3jPNgwVXgBy361cEFBAQOpeJOgxZl3pwfrN7ytQLaCZ/dhe+GjdU9ZED26mReHqACDbkI+WwAZV3MR3jWNOEyTHNXj7FPVe4vVSY/lAR/pRGntRU1D4nhScfTF4bJUoxRjFJXhwygaN7oE19LGMP/FdE3LsN1SZCWCcNe29pqcpjEZZcJmNC5d0OTN1XJuIYN/UlFp+qIVYzdojQAqKOIHRC7XWG97b6Es6aQRLiXMHNR0AC0goD5BoJz07eLNPCGf2hg6vxz8Z6xc
 NKl5lW1p
 EBcy4AlKLDod9Bh1nT1AT1PiqzYOTg8y2tSmTIRBFgfnMVDvvmQFxf3T2cPdlPaNk7af7FWcdYnRHXQCG4/hhDtTeek79lTHH/f77i4p/dkU9YpFNW6lA+edS3Fd01ibwtrR3+PgfZsZf6cQmIGaYuZZhLt+vTQcWqGe/ivhx+pyKDcHrlEYPMlIGPwQier/gq56t8bjXTCQ5xXcFHSiweHHBRz2jQeqOb2/kWc6P8S7iSh4dJGVWCUKu75YrbtA5DEvXFdCgjlU6ywXIrAHPfCw5pFp54sDDXKmJQXSSxt4Q7KZ+Bcg94fzxrbsYwJKu3sIX59MFnaY4gMM+brGKdpS5xKB8Hd9teChehGbNGnA5gUw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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

Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 MAINTAINERS       |   2 +
 mm/trace_vmscan.h |   2 +
 mm/vmscan.c       | 108 ------------------------------------------
 mm/vmscan.h       | 118 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 122 insertions(+), 108 deletions(-)
 create mode 100644 mm/vmscan.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 2ad01107fa05..724791bb779f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17655,6 +17655,7 @@ F:	include/linux/mm_inline.h
 F:	include/linux/mmzone.h
 F:	mm/trace_vmscan.h
 F:	mm/vmscan.c
+F:	mm/vmscan.h
 F:	mm/workingset.c
 
 MEMORY MANAGEMENT - MIGRATION
@@ -17805,6 +17806,7 @@ L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/trace_vmscan.h
 F:	mm/vmscan.c
+F:	mm/vmscan.h
 F:	mm/workingset.c
 
 MEMORY MANAGEMENT - RMAP (REVERSE MAPPING)
diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
index ad90f0e9bf2e..3917e1b62dfa 100644
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
index 79d2d614afd0..49677464fc9a 100644
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
2.43.0


