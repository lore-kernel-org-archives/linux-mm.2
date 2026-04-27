Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C98B6FF8850
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 06:02:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 159956B0005; Mon, 27 Apr 2026 02:02:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E3596B008A; Mon, 27 Apr 2026 02:02:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EED6D6B008C; Mon, 27 Apr 2026 02:02:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D5D8D6B0005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 02:02:16 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 817BA1A077D
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 06:02:16 +0000 (UTC)
X-FDA: 84703290672.16.FF3C00E
Received: from smtp186.sjtu.edu.cn (smtp186.sjtu.edu.cn [202.120.2.186])
	by imf06.hostedemail.com (Postfix) with ESMTP id 484FC180005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 06:02:12 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=sjtu.edu.cn header.s=default header.b=itanz32k;
	spf=pass (imf06.hostedemail.com: domain of b.suvonov@sjtu.edu.cn designates 202.120.2.186 as permitted sender) smtp.mailfrom=b.suvonov@sjtu.edu.cn;
	dmarc=pass (policy=none) header.from=sjtu.edu.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777269734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yUGOCbAx1XpsLO7GEZR7Q5292zPE3EIEBGnTQiy5krQ=;
	b=t30+KYgdOYxBWMXbiQObhIoq2avWKR1rlIIuzbVs8C4OZOwinwxpD9q9dQ/wMyv+IF8Ckw
	Pr7t2ASJ86RUi+4CsyxMboqI4NZoSjMkie8EVp1l6M+3cCNW2Cp82GeUt46M9aJvThb0z6
	A59OaUpQ9t61IvOfGXDrW8ARqTSOylo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777269734; a=rsa-sha256;
	cv=none;
	b=D1AcPkIoaGCN32Rh5zNtPP2VSeby8olLo3S3b3Yp/979gYumLsRqrb9SAy3fDcbBPox27A
	dJgiciMjBGv59QH/AVrg7g/HsTnyqJdEbkTtreETNXNyTCf/wSBvNM5OMMliuLozcJFvkR
	3aJnlo9bi5Ewv6dJg0HwSU57q4pu9BU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=sjtu.edu.cn header.s=default header.b=itanz32k;
	spf=pass (imf06.hostedemail.com: domain of b.suvonov@sjtu.edu.cn designates 202.120.2.186 as permitted sender) smtp.mailfrom=b.suvonov@sjtu.edu.cn;
	dmarc=pass (policy=none) header.from=sjtu.edu.cn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=sjtu.edu.cn;
	s=default; t=1777269728;
	bh=/UzigxygkmT91dr6p0hNFprzzI5KRjYCyq8YphKvwBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=itanz32k22Q4lFE8Y4XZpCt1ER+SKjMQZ4GqQxqYIb9t8Y+kt71I0go5AYOnHs8Ci
	 mpxmDvBNSwYeKQBpHu2AEpa7YHysA4Rs2HaXQ5Qx9ph7dh8QQll1KSN0CLVqiqUrxY
	 7ztkm/AVyyMkKe0yXac/I2X1RZnohHTY93A5tRY405iihLuy3KutvLbpuRj19j55Wa
	 jKSbLgYTBpHS/7Su3kRQNrujrzJuRjOwUt2F4NU+FTF5h7UNGqU76eQnhv4rH3iR7s
	 Z3mj4m2TF9YXhEsDtWzFoJPu5gsBG1nR3JL0C3UT9Ery90IT0yKC/e9c33BDcQ81ZO
	 kT34Z9IZ8TK/w==
Received: from proxy188.sjtu.edu.cn (smtp188.sjtu.edu.cn [202.120.2.188])
	by smtp186.sjtu.edu.cn (Postfix) with ESMTPS id 822D33008C9;
	Mon, 27 Apr 2026 06:02:08 +0000 (UTC)
Received: from dynamic.ipv6.sjtu.edu.cn (unknown [10.180.122.86])
	by proxy188.sjtu.edu.cn (Postfix) with ESMTPSA id F27D537C96D;
	Mon, 27 Apr 2026 14:02:07 +0800 (CST)
From: Bunyod Suvonov <b.suvonov@sjtu.edu.cn>
To: akpm@linux-foundation.org,
	vbabka@kernel.org,
	linux-mm@kvack.org
Cc: rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	linux-trace-kernel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	david@kernel.org,
	vishal.moola@gmail.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	Bunyod Suvonov <b.suvonov@sjtu.edu.cn>
Subject: [PATCH v2] mm/page_alloc: trace PCP refills and PCP zone lock usage
Date: Mon, 27 Apr 2026 14:01:42 +0800
Message-ID: <20260427060142.131055-1-b.suvonov@sjtu.edu.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260425091335.346504-1-b.suvonov@sjtu.edu.cn>
References: <20260425091335.346504-1-b.suvonov@sjtu.edu.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 484FC180005
X-Rspam-User: 
X-Stat-Signature: 3f7r47a84tpajpzt9cd3q8gotiw8orde
X-HE-Tag: 1777269732-655062
X-HE-Meta: U2FsdGVkX182+agD0ZKsQNPFhWrB/uM1rXx+wFkAKaAkaj7lrZLBbZ36MAOvghz6Io4nhtlZLNfjVoBJsAQHeFXu8WPNQWRYcubGbIbQaIk0Sff4t7XmzLBDle353RzAgJZX/qjFLZM2vO0nzfBbJ8nbxkFOwG4iaqQ1Cgz8EXpphMT1ENIlqoKAkxy0QD2qzUarad6xi+BtW4z+3n/IEOJ1v2nXmHII2pSHtOb4BYqpnwAbntsD8rJbNHBye+npmkpd4UgOIeX5T+ZEDt2SvjSyfRgPuewVUZ2zBBgKZ5P5hm7xOgt7lsSXsrOn0UTXQuzbskeiv8+bWCbWq8KaC/5Xzt4CtjGgE3RhePEAFt/sSJGKgA55i1S6D9J9ZDkcdFEM8tv/s0C/v1u9ShFuUn7dUA9s57bfcSPeIaL6xNIjrbgC74nh1Zy6loESp4ZuuBh1Lk7I5ndHt6/1myWY33RPeadRFVYvnKNkuC/RIfoqf6ltQjhXgzPXy/XVS4YXE2WE7HoRICEtAggEwK5zD3DaM+seT1MUihT0Dd5QTFnmlOIpitiXOUY9LOofFnCCETaTFkh0gEIAx+8/4X16tEDE719WFLjPNjeg4n7H2AsE6OJt2lc5nzQI4IAl9Vu70tk605TKcZ2HYg3+feDk1/GJxHWFzJMqaPaxOwdIzURLDEINmd/er9VVmaVodXweKWcJpD/1w3b+590OgVXruwGTFUtyGm8T3OVLjFGoYVmml5lVcXzL4DL5wDQQn4cgdi/HY++L/08AZ9tFKwWVdTG+cCyL4RtZCmDf2pW18Be+SPH6C4HWK5xVWvJn830VRiVrbrYtS+iiqdO9yd26XUtnufTDTM4rX2sM0EYdgKlYMgViYnnVjPXDzpGmX1DDbE5WYf0V3YHzz30dFCUQz2nuPwVf8wQ5IZEyOKiKHOWhGVPUybFBKFrY5jThCQ/GvckVLNyacLwDq7u4YoY
 0pnTnsqR
 HTgKkkqGqwYERHITzoecIJkuhKMe9QS6M6spjTxvJ4+1fDI/Zaids6TMpBqa79FlcpMOYVcD1xdoRG9iZGoWWPVzMnuHb8mijkVAFRkDj6tlckJsdI+w5kqD7OGU3/tL/+T59frR8FrVeWqwhvrYNZ9Js2PYPr+lrhcvNfn8O31P4MveOr/0NNSPXSH7EpTuG4SzuE9kI5WWCYCd5p7Y76J3moAEML17sg1rvZClGsQepx3+jaJ7UPyTf0JS4hLOc1uEniwxtOa0PZv0zz0GnsmrIagMvpNOYdl3Z+fVD2/9qqo4DQykA1FXQ/Nu7aq2KJWVMucBcOfKlNx03NSLozKE6ou76CV3fQQdG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mm_page_pcpu_drain traces page blocks drained from the per-cpu page
lists back to the buddy allocator. There is no matching tracepoint for
the opposite direction, where rmqueue_bulk() refills a PCP list from the
buddy allocator.

Add mm_page_pcpu_refill as the counterpart to mm_page_pcpu_drain. The
pair makes PCP traffic observable in both directions: refill shows page
blocks moving from the buddy allocator into PCP lists, while drain shows
page blocks moving from PCP lists back to the buddy allocator. Comparing
the two helps identify PCP churn, imbalance between CPUs, and cases where
pages repeatedly cycle between PCP lists and the buddy allocator instead
of being served efficiently from PCP.

PCP refill and drain activity can also require entering the buddy
allocator under zone->lock. The per-page-block refill and drain events do
not directly count those lock acquisitions, because a single bulk
operation can move multiple page blocks.

Add mm_page_pcpu_refill_zone_locked and
mm_page_pcpu_drain_zone_locked to trace successful PCP bulk operations
after acquiring the zone lock. These events make it possible to count how
often PCP refill and drain paths enter the zone-locked buddy allocator.
Frequent events can indicate that PCP lists are under pressure and are
not avoiding the zone lock as effectively as expected.

mm_page_alloc_zone_locked is not a reliable substitute for PCP refill
activity. It is emitted from __rmqueue_smallest(), which is reached with
zone->lock already held by both rmqueue_bulk() and the direct buddy
allocation path. Its percpu_refill field is derived from the allocation
order and migratetype, so it does not reliably identify whether the
allocation came from a PCP refill.

Document the new kmem tracepoints.

Signed-off-by: Bunyod Suvonov <b.suvonov@sjtu.edu.cn>
---
Changes since v1:
- Add mm_page_pcpu_refill as the per-page-block counterpart to
  mm_page_pcpu_drain.
- Add mm_page_pcpu_refill_zone_locked and
  mm_page_pcpu_drain_zone_locked to count PCP bulk operations that
  acquired zone->lock.
- Document the new kmem tracepoints and clarify the PCP refill/drain
  semantics.

 Documentation/trace/events-kmem.rst | 65 ++++++++++++++++++-----------
 include/trace/events/kmem.h         | 58 +++++++++++++++++++++++--
 mm/page_alloc.c                     |  5 +++
 3 files changed, 100 insertions(+), 28 deletions(-)

diff --git a/Documentation/trace/events-kmem.rst b/Documentation/trace/events-kmem.rst
index 68fa75247488..9f935db1ea88 100644
--- a/Documentation/trace/events-kmem.rst
+++ b/Documentation/trace/events-kmem.rst
@@ -75,30 +75,47 @@ contention on the lruvec->lru_lock.
 =============================
 ::
 
-  mm_page_alloc_zone_locked	page=%p pfn=%lu order=%u migratetype=%d cpu=%d percpu_refill=%d
-  mm_page_pcpu_drain		page=%p pfn=%lu order=%d cpu=%d migratetype=%d
-
-In front of the page allocator is a per-cpu page allocator. It exists only
-for order-0 pages, reduces contention on the zone->lock and reduces the
-amount of writing on struct page.
-
-When a per-CPU list is empty or pages of the wrong type are allocated,
-the zone->lock will be taken once and the per-CPU list refilled. The event
-triggered is mm_page_alloc_zone_locked for each page allocated with the
-event indicating whether it is for a percpu_refill or not.
-
-When the per-CPU list is too full, a number of pages are freed, each one
-which triggers a mm_page_pcpu_drain event.
-
-The individual nature of the events is so that pages can be tracked
-between allocation and freeing. A number of drain or refill pages that occur
-consecutively imply the zone->lock being taken once. Large amounts of per-CPU
-refills and drains could imply an imbalance between CPUs where too much work
-is being concentrated in one place. It could also indicate that the per-CPU
-lists should be a larger size. Finally, large amounts of refills on one CPU
-and drains on another could be a factor in causing large amounts of cache
-line bounces due to writes between CPUs and worth investigating if pages
-can be allocated and freed on the same CPU through some algorithm change.
+  mm_page_alloc_zone_locked	page=%p pfn=0x%lx order=%u migratetype=%d percpu_refill=%d
+  mm_page_pcpu_refill		page=%p pfn=0x%lx order=%d migratetype=%d
+  mm_page_pcpu_drain		page=%p pfn=0x%lx order=%d migratetype=%d
+  mm_page_pcpu_refill_zone_locked nid=%d zid=%d nr_pages=%lu
+  mm_page_pcpu_drain_zone_locked  nid=%d zid=%d nr_pages=%lu
+
+In front of the buddy allocator are per-cpu page lists. They reduce
+contention on the zone->lock and reduce the amount of writing on struct
+page.
+
+When an allocation finds the target per-CPU list empty, the zone->lock may
+be taken once and the per-CPU list refilled from the buddy allocator. The
+mm_page_pcpu_refill_zone_locked event is emitted once after the refill path
+successfully acquires the zone lock. The mm_page_pcpu_refill event is
+emitted for each page block added to the per-CPU list.
+
+When per-CPU pages are drained back to the buddy allocator, for example
+because a per-CPU list is above its high mark, PCP high is decayed, or an
+explicit drain is requested, the drain path takes the zone lock. The
+mm_page_pcpu_drain_zone_locked event is emitted once after the drain path
+successfully acquires the zone lock. The mm_page_pcpu_drain event is emitted
+for each page block drained from the per-CPU list.
+
+The individual refill and drain events allow pages to be tracked between
+allocation and freeing. The zone_locked events allow the bulk operations to
+be counted directly. A single zone_locked event may be followed by multiple
+refill or drain events, depending on how many page blocks are moved while
+holding the zone lock. The nr_pages field in the zone_locked events is the
+target number of base pages for the bulk operation when the zone lock is
+acquired. The individual refill or drain events describe the page blocks
+actually moved.
+
+Large amounts of per-CPU refills and drains could imply an imbalance between
+CPUs where too much work is being concentrated in one place. Frequent
+zone_locked events can indicate that the per-CPU lists are under pressure
+and are not avoiding the zone lock as effectively as expected. It could also
+indicate that the per-CPU lists should be a larger size. Finally, large
+amounts of refills on one CPU and drains on another could be a factor in
+causing large amounts of cache line bounces due to writes between CPUs and
+worth investigating if pages can be allocated and freed on the same CPU
+through some algorithm change.
 
 5. External Fragmentation
 =========================
diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
index cd7920c81f85..68f5d4a84da6 100644
--- a/include/trace/events/kmem.h
+++ b/include/trace/events/kmem.h
@@ -243,16 +243,52 @@ DEFINE_EVENT(mm_page, mm_page_alloc_zone_locked,
 	TP_ARGS(page, order, migratetype, percpu_refill)
 );
 
-TRACE_EVENT(mm_page_pcpu_drain,
+DECLARE_EVENT_CLASS(mm_page_pcpu_zone_locked,
+
+	TP_PROTO(int nid, int zid, unsigned long nr_pages),
+
+	TP_ARGS(nid, zid, nr_pages),
+
+	TP_STRUCT__entry(
+		__field(int, nid)
+		__field(int, zid)
+		__field(unsigned long, nr_pages)
+	),
+
+	TP_fast_assign(
+		__entry->nid		= nid;
+		__entry->zid		= zid;
+		__entry->nr_pages	= nr_pages;
+	),
+
+	TP_printk("nid=%d zid=%d nr_pages=%lu",
+		__entry->nid, __entry->zid, __entry->nr_pages)
+);
+
+DEFINE_EVENT(mm_page_pcpu_zone_locked, mm_page_pcpu_refill_zone_locked,
+
+	TP_PROTO(int nid, int zid, unsigned long nr_pages),
+
+	TP_ARGS(nid, zid, nr_pages)
+);
+
+DEFINE_EVENT(mm_page_pcpu_zone_locked, mm_page_pcpu_drain_zone_locked,
+
+	TP_PROTO(int nid, int zid, unsigned long nr_pages),
+
+	TP_ARGS(nid, zid, nr_pages)
+);
+
+DECLARE_EVENT_CLASS(mm_page_pcpu,
 
 	TP_PROTO(struct page *page, unsigned int order, int migratetype),
 
 	TP_ARGS(page, order, migratetype),
 
 	TP_STRUCT__entry(
-		__field(	unsigned long,	pfn		)
-		__field(	unsigned int,	order		)
-		__field(	int,		migratetype	)
+		__field(unsigned long, pfn)
+		__field(unsigned int, order)
+		__field(int, migratetype)
 	),
 
 	TP_fast_assign(
@@ -266,6 +302,20 @@ TRACE_EVENT(mm_page_pcpu_drain,
 		__entry->order, __entry->migratetype)
 );
 
+DEFINE_EVENT(mm_page_pcpu, mm_page_pcpu_refill,
+
+	TP_PROTO(struct page *page, unsigned int order, int migratetype),
+
+	TP_ARGS(page, order, migratetype)
+);
+
+DEFINE_EVENT(mm_page_pcpu, mm_page_pcpu_drain,
+
+	TP_PROTO(struct page *page, unsigned int order, int migratetype),
+
+	TP_ARGS(page, order, migratetype)
+);
+
 TRACE_EVENT(mm_page_alloc_extfrag,
 
 	TP_PROTO(struct page *page,
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 65e205111553..9323bdbce731 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1470,6 +1470,8 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 	pindex = pindex - 1;
 
 	spin_lock_irqsave(&zone->lock, flags);
+	trace_mm_page_pcpu_drain_zone_locked(zone_to_nid(zone), zone_idx(zone),
+					     count);
 
 	while (count > 0) {
 		struct list_head *list;
@@ -2527,6 +2529,8 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
 	} else {
 		spin_lock_irqsave(&zone->lock, flags);
 	}
+	trace_mm_page_pcpu_refill_zone_locked(zone_to_nid(zone), zone_idx(zone),
+					      count << order);
 	for (i = 0; i < count; ++i) {
 		struct page *page = __rmqueue(zone, order, migratetype,
 					      alloc_flags, &rmqm);
@@ -2544,6 +2548,7 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
 		 * pages are ordered properly.
 		 */
 		list_add_tail(&page->pcp_list, list);
+		trace_mm_page_pcpu_refill(page, order, migratetype);
 	}
 	spin_unlock_irqrestore(&zone->lock, flags);
 
-- 
2.53.0

