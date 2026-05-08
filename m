Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAE7BCD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 16:22:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F40146B01F1; Fri,  8 May 2026 12:22:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F17346B01F2; Fri,  8 May 2026 12:22:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2DB96B01F3; Fri,  8 May 2026 12:22:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CCE266B01F1
	for <linux-mm@kvack.org>; Fri,  8 May 2026 12:22:19 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 74CA91C0268
	for <linux-mm@kvack.org>; Fri,  8 May 2026 16:22:19 +0000 (UTC)
X-FDA: 84744769998.21.0F237F5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 903BC140005
	for <linux-mm@kvack.org>; Fri,  8 May 2026 16:22:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G6zcL0rJ;
	spf=pass (imf09.hostedemail.com: domain of hawk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=hawk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778257337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ctpT/9bVhdbgOS1uhsKUzKobV3FP0udSEA0vPIhakaM=;
	b=SD+o93SaE9uAVZiyt0IL0mIZ3F5s6LRgSP09QZlhQMggeQvno8/GwhPGXRm3X2IZvt3Une
	NSAv7z+UigIa2U1uwMYpAMeOolhUD/Nsj57PcSm2RAjZBHAYvBYehPKxwenq3uUL9dSIge
	++pGFvZgWYfLZJQlq/r996eUCcvV3NA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G6zcL0rJ;
	spf=pass (imf09.hostedemail.com: domain of hawk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=hawk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778257337; a=rsa-sha256;
	cv=none;
	b=gUbg/XXfVyr4aFFgC0kPyCx3gHxAp1biSAx/W6I1Et2Cft32oqCo2wGiAdWN/M8bwaCtol
	cOTQ5dKaIKm09SpPXM0FizUsOg/MIHjVO5+IBZZcAY68iu2aIsOz78psr5tdJ6DgQwm1QD
	i+/x8ajJB3q7wJ5axiXAxUbAGzuJgyU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A16E64354C;
	Fri,  8 May 2026 16:22:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD07C2BCB0;
	Fri,  8 May 2026 16:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778257336;
	bh=1uMuGN04UYFs3z+YrwL58o6n66Bmk4tKC0/21HQOwpM=;
	h=From:To:Cc:Subject:Date:From;
	b=G6zcL0rJ8Qr/uA3lwhygDYoxgmjWaahp9qUo7LK4StbMtC/ZyGqIDbVsYTcf9/0sK
	 f9TJKVCw58sLiXS9+KDAr7mbuUYZV/qysOLLPmkE3+0gI21VEwm7YcFcJwwFvjrXvE
	 7aehZRqfgGbeXdkBfmgQjBVRzbZpP1g+vbFuD9UKuf0x/mEgrMSBMKrR26O5QebuzD
	 gjwIZjFX54weoAVo8kRzd7EkbyeDsPUbWnk2C9hD2wmhFSyUrjO1qUiTfj1xrfdfhZ
	 tsHlVrTy3k54IQqm15MSogoHD3rY2qh39iVjqLLdOu7p5kx6SeQAvz/8A9WrsH8/Om
	 Ixi2voU2uPsMQ==
From: hawk@kernel.org
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	kernel-team@cloudflare.com,
	hawk@kernel.org
Subject: [PATCH 1/2] mm/page_alloc: add tracepoints for zone->lock acquisitions
Date: Fri,  8 May 2026 18:22:06 +0200
Message-ID: <20260508162207.3315781-1-hawk@kernel.org>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 903BC140005
X-Stat-Signature: 9tccujd88yazuf5eksqxqar8zcgozyyz
X-HE-Tag: 1778257337-884840
X-HE-Meta: U2FsdGVkX18JAYGNJaQAY524lXCRk132iNiZFvk3WYWfEkoFmyczC8tn7y6nEDtn1iOD3eBQGGCH+7sTTloRafgWVIXentp6SUVKwxrCtdBhpep9DXfR3JUhmA9IwEk7IWd4V1nrNELSRopyWgImQ7vGD6I11dIJBQvGbXmX0LHetBn1mcwxs1iFy5p9KNi08FVa/snkwrw8UDiy6X9hj69f28PBMEM6qg6IDHzS49Ot9X3Mp6f1Nh82AQZAMoH3SVmIPCXpJeTPA6rr/cMvaQoXd+UAhTRD0+LHyrjFuSG70n/0BahExxIzl7B5jUsO68w3/9KIZjWbByafOf73+BQvVe8cXt60Kg6ER67Y0T+TevG1kwzBf24+uC0frEUuhkcfLE/YLBoUsebJImKXPRARFlxL2LSkoQrtzIMSc9TmC9X9VII7GvQAhHsneezxRmXbWm0yBN0WahcEa28YC5gA4qrFRiXdNFxlY+EjPX2TA/MDbcL6+QXaIxPM5MPyqIO8XzDjidePZTYetyTTzFnvFBMCV7Rj7j30r/BYUXWTwSDhhn+iecYN15YJWUaBqRWGlsXu0QIieRTO82MYE8ftstyQlmgjcJPY41Xqdah/hi1n8yZyF91tfrfDPbGHIBqZoQ3NOwYgDJPKQq32asH0ikM/QH7ISw3NJI7ZFLHSYn1nDnfhGvd/tT9J//R8DYDer5v5SbtipdQjHl/yNEbJ8B5ENsZqEHBCfUk7OwQC5ij5sq8635rYlwgjRUPm48U7FmqGchLUmIMYxaZTPRAIR5V7GbLrRegQ79CYlhJ+1y9kt5BqL4zmthyL+lmiaGuwglxaxWkNxpvkHJ180APyBax1ZWB/uKuWcchKSl/C3a6EBNKrvMdaSHIwwK2OR8S/PutBaPY+Ux8DG10EOcaqISjlZ18/W3wyjsEtyvCpc5403PsHZmpmJD0GcjDFofB5mTI0JwqvQJfAFVT
 rbnOVi+n
 3sW66qhYzm6WHicsZlJ59/farr9yYjrFiSB+iAxRTqylWaASGrRfyc1+gHONhQjo2X24IgpSFDGzQIsb1r6cK2jzKOOexD7twruYr3W4b38n3zEElzK+iHE6D3BuiKKrC5Tm3d8UdE1XhdjmMNUxD4FFaiOeBmI7Zr5n6q2n3l2vsPW/v7dgE2ZpjUHSfdy6y+ZourPEDYFqCL9QUOOc3amVDneiPqiRkw/8uO/4Skh2iv2OL/NAjqhUL880I2BljizjkGrgOIOe6N5DDqA4LBiH45w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jesper Dangaard Brouer <hawk@kernel.org>

Add tracepoints to the page allocator fast paths that acquire
zone->lock, allowing diagnosis of lock contention in production.

Three tracepoints are introduced:
  kmem:mm_zone_lock_contended - fires when trylock fails (lock is held)
  kmem:mm_zone_locked         - fires on every acquisition
  kmem:mm_zone_lock_unlock    - fires on every release

Each event records the NUMA node, zone name, batch count, and caller.
The mm_zone_locked event additionally records wait_ns: the time spent
spinning when contended, measured via local_clock() with IRQs disabled
to ensure accurate same-CPU timestamps.

The lock/unlock paths are wrapped in __zone_lock()/__zone_unlock()
helpers that use trylock-first to separate the contended and
uncontended cases.  Only the fast paths (free_pcppages_bulk,
rmqueue_bulk, free_one_page) are covered.  Other zone->lock holders
such as compaction, page isolation, and memory hotplug are not
instrumented.

For minimum overhead in production, enable only mm_zone_lock_contended
which fires only on actual contention.  Enable mm_zone_locked for
wait-time analysis, and add mm_zone_lock_unlock for hold-time
measurement.

Signed-off-by: Jesper Dangaard Brouer <hawk@kernel.org>
---
 include/trace/events/kmem.h | 101 ++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c             |  50 +++++++++++++++---
 2 files changed, 145 insertions(+), 6 deletions(-)

diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
index cd7920c81f85..870c68c70d57 100644
--- a/include/trace/events/kmem.h
+++ b/include/trace/events/kmem.h
@@ -458,6 +458,107 @@ TRACE_EVENT(rss_stat,
 		__print_symbolic(__entry->member, TRACE_MM_PAGES),
 		__entry->size)
 	);
+
+/*
+ * Tracepoints for zone->lock on the page allocator fast paths only.
+ * Other code paths that acquire zone->lock (compaction, isolation,
+ * memory hotplug, vmstat, etc.) are not covered here.
+ *
+ * Three events:
+ *   mm_zone_lock_contended - trylock failed, about to spin
+ *   mm_zone_locked         - lock acquired, includes wait_ns when
+ *                            contended (zero otherwise)
+ *   mm_zone_lock_unlock    - lock released
+ *
+ * For production use with minimum overhead, enable only
+ * mm_zone_lock_contended -- it fires only when trylock detects the
+ * lock is already held.
+ *
+ * For wait-time analysis, enable mm_zone_locked -- its wait_ns
+ * field gives the spin duration directly.  Adding unlock allows
+ * hold-time measurement, at the cost of one event per acquisition.
+ */
+TRACE_EVENT(mm_zone_lock_contended,
+
+	TP_PROTO(struct zone *zone, int count, unsigned long caller),
+
+	TP_ARGS(zone, count, caller),
+
+	TP_STRUCT__entry(
+		__field(	int,		node_id		)
+		__string(	name,		zone->name	)
+		__field(	int,		count		)
+		__field(	unsigned long,	caller		)
+	),
+
+	TP_fast_assign(
+		__entry->node_id = zone_to_nid(zone);
+		__assign_str(name);
+		__entry->count = count;
+		__entry->caller = caller;
+	),
+
+	TP_printk("node=%d zone=%-8s count=%-5d caller=%pS",
+		  __entry->node_id, __get_str(name),
+		  __entry->count, (void *)__entry->caller)
+);
+
+TRACE_EVENT(mm_zone_locked,
+
+	TP_PROTO(struct zone *zone, int count, bool contended,
+		 unsigned long caller, u64 wait_ns),
+
+	TP_ARGS(zone, count, contended, caller, wait_ns),
+
+	TP_STRUCT__entry(
+		__field(	int,		node_id		)
+		__string(	name,		zone->name	)
+		__field(	int,		count		)
+		__field(	bool,		contended	)
+		__field(	unsigned long,	caller		)
+		__field(	u64,		wait_ns		)
+	),
+
+	TP_fast_assign(
+		__entry->node_id = zone_to_nid(zone);
+		__assign_str(name);
+		__entry->count = count;
+		__entry->contended = contended;
+		__entry->caller = caller;
+		__entry->wait_ns = wait_ns;
+	),
+
+	TP_printk("node=%d zone=%-8s count=%-5d contended=%d caller=%pS wait=%llu ns",
+		  __entry->node_id, __get_str(name),
+		  __entry->count, __entry->contended,
+		  (void *)__entry->caller, __entry->wait_ns)
+);
+
+TRACE_EVENT(mm_zone_lock_unlock,
+
+	TP_PROTO(struct zone *zone, int count, unsigned long caller),
+
+	TP_ARGS(zone, count, caller),
+
+	TP_STRUCT__entry(
+		__field(	int,		node_id		)
+		__string(	name,		zone->name	)
+		__field(	int,		count		)
+		__field(	unsigned long,	caller		)
+	),
+
+	TP_fast_assign(
+		__entry->node_id = zone_to_nid(zone);
+		__assign_str(name);
+		__entry->count = count;
+		__entry->caller = caller;
+	),
+
+	TP_printk("node=%d zone=%-8s count=%-5d caller=%pS",
+		  __entry->node_id, __get_str(name),
+		  __entry->count, (void *)__entry->caller)
+);
+
 #endif /* _TRACE_KMEM_H */
 
 /* This part must be outside protection */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 227d58dc3de6..08018e9beab4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -19,6 +19,7 @@
 #include <linux/highmem.h>
 #include <linux/interrupt.h>
 #include <linux/jiffies.h>
+#include <linux/sched/clock.h>
 #include <linux/compiler.h>
 #include <linux/kernel.h>
 #include <linux/kasan.h>
@@ -1447,6 +1448,43 @@ bool free_pages_prepare(struct page *page, unsigned int order)
 	return __free_pages_prepare(page, order, FPI_NONE);
 }
 
+/*
+ * Helper functions for locking zone->lock with tracepoints.
+ *
+ * This makes it easier to diagnose locking issues and contention in
+ * production environments.  The @count parameter indicates the number
+ * of pages being freed or allocated in the batch operation.
+ *
+ * For minimum overhead attach to kmem:mm_zone_lock_contended, which
+ * only gets activated when trylock detects lock is contended.
+ */
+static inline void
+__zone_lock(struct zone *zone, int count, unsigned long *flags)
+	__acquires(&zone->lock)
+{
+	unsigned long caller = _RET_IP_;
+	u64 wait_start, wait_time = 0;
+	bool contended;
+
+	local_irq_save(*flags);
+	contended = !spin_trylock(&zone->lock);
+	if (contended) {
+		wait_start = local_clock();
+		trace_mm_zone_lock_contended(zone, count, caller);
+		spin_lock(&zone->lock);
+		wait_time = local_clock() - wait_start;
+	}
+	trace_mm_zone_locked(zone, count, contended, caller, wait_time);
+}
+
+static inline void
+__zone_unlock(struct zone *zone, int count, unsigned long *flags)
+	__releases(&zone->lock)
+{
+	trace_mm_zone_lock_unlock(zone, count, _RET_IP_);
+	spin_unlock_irqrestore(&zone->lock, *flags);
+}
+
 /*
  * Frees a number of pages from the PCP lists
  * Assumes all pages on list are in same zone.
@@ -1469,7 +1507,7 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 	/* Ensure requested pindex is drained first. */
 	pindex = pindex - 1;
 
-	spin_lock_irqsave(&zone->lock, flags);
+	__zone_lock(zone, count, &flags);
 
 	while (count > 0) {
 		struct list_head *list;
@@ -1502,7 +1540,7 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 		} while (count > 0 && !list_empty(list));
 	}
 
-	spin_unlock_irqrestore(&zone->lock, flags);
+	__zone_unlock(zone, count, &flags);
 }
 
 /* Split a multi-block free page into its individual pageblocks. */
@@ -1551,7 +1589,7 @@ static void free_one_page(struct zone *zone, struct page *page,
 			return;
 		}
 	} else {
-		spin_lock_irqsave(&zone->lock, flags);
+		__zone_lock(zone, 1 << order, &flags);
 	}
 
 	/* The lock succeeded. Process deferred pages. */
@@ -1569,7 +1607,7 @@ static void free_one_page(struct zone *zone, struct page *page,
 		}
 	}
 	split_large_buddy(zone, page, pfn, order, fpi_flags);
-	spin_unlock_irqrestore(&zone->lock, flags);
+	__zone_unlock(zone, 1 << order, &flags);
 
 	__count_vm_events(PGFREE, 1 << order);
 }
@@ -2525,7 +2563,7 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
 		if (!spin_trylock_irqsave(&zone->lock, flags))
 			return 0;
 	} else {
-		spin_lock_irqsave(&zone->lock, flags);
+		__zone_lock(zone, count, &flags);
 	}
 	for (i = 0; i < count; ++i) {
 		struct page *page = __rmqueue(zone, order, migratetype,
@@ -2545,7 +2583,7 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
 		 */
 		list_add_tail(&page->pcp_list, list);
 	}
-	spin_unlock_irqrestore(&zone->lock, flags);
+	__zone_unlock(zone, i, &flags);
 
 	return i;
 }
-- 
2.43.0


