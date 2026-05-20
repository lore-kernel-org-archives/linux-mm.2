Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9992CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:01:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BAAD6B00A3; Wed, 20 May 2026 11:00:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F5296B00A8; Wed, 20 May 2026 11:00:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AEDA6B00A3; Wed, 20 May 2026 11:00:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E26FC6B00A7
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:00:48 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8F8D0120376
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:00:48 +0000 (UTC)
X-FDA: 84788110176.01.96F41E4
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf17.hostedemail.com (Postfix) with ESMTP id CE53D4001F
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:00:46 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=JljjMHsj;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779289246; a=rsa-sha256;
	cv=none;
	b=CqjnJYz46I77EebxIozKnHpkJNXZJEGVKGjOiaZfGwSzFDXdQ65mCwgrhhWwQp/YwIb/UK
	loR4Pp/cvLPhVY+Rf3laeeOJjJt81BkTk5QbxSxEf42CsomkmOoIS37DHw8tN8X7F9s4Nu
	ILSswBsaBRoNBoHUWDHI29C1w+UFnFo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=JljjMHsj;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779289246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z/qj+KWI7h9JqJhNq4BxI6ZWMV4VhY1/AXzq1+33pR8=;
	b=Kf32kOdQZG1Rpl4lOzoEJ1eJ9m9lFGwidY0XzpnnytR+V8ewwS681wlSOT29M60KME4jnH
	QFnxqJ5b3Nyq0uyEhOTz35eVzRG8+7W5i2Vi/bm82NflnR26A1dMxspbMBW/shGa88gYza
	/CCzt7OD3VFwZDO2Wd72vlJDrt1tRV8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Z/qj+KWI7h9JqJhNq4BxI6ZWMV4VhY1/AXzq1+33pR8=; b=JljjMHsjzfjFl41mysnmQ4YPui
	WwF5xRbeUYxYn0fHLSJFHja4dAlFQORwSTO+1qHgIyhDk437Q3g6Hi2uJHpt7EYp+NJ35oBzoqOhj
	tERvokdbIWMRRY+/E0sTto3XzjcLSD2BVoqB+15Ov3T1dyvBeWfbw779ICcOquCw3HsURR3NUaij4
	E7HJy9jGspfLZILp8cBANa55xskwfSvMmBsXpFKc02shXc7tRdFQB19tYd/GCddrl4eWosWgH1w7X
	DdxkoaTD3e2KdWkVehdurLQegmAegjepGWrnRFSuxg+x7Vhsl1joZW6dczIr6qG/Hk0RIHX4AlrJi
	8WB5OKfw==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wPiPM-0000000024Q-0Moh;
	Wed, 20 May 2026 11:00:28 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com,
	linux-mm@kvack.org,
	david@kernel.org,
	willy@infradead.org,
	surenb@google.com,
	hannes@cmpxchg.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	usama.arif@linux.dev,
	fvdl@google.com,
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 03/40] mm: page_alloc: split-path PCP free with local-trylock + remote-llist
Date: Wed, 20 May 2026 10:59:09 -0400
Message-ID: <20260520150018.2491267-4-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520150018.2491267-1-riel@surriel.com>
References: <20260520150018.2491267-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sm1y18f9zmidrq1981huzzzif6b8wihd
X-Rspam-User: 
X-Rspamd-Queue-Id: CE53D4001F
X-Rspamd-Server: rspam07
X-HE-Tag: 1779289246-93852
X-HE-Meta: U2FsdGVkX1/wksFfM96PNgQyP/zZ5r76OWJB5B8gGhmAuholBo/srAjf+HkQLPJwL9gEXD3XT8Hg+P2FqFj6YuUxQrpNsH0wFYM1fAPhMZuvr/AeykwEAOKDq85n1U8CHiu/wL2bwYVjtxc1kXGts6qejvnClp1eswWSzZR59PfN/V5g64af9ZgkbRYWelsg5LHMPmBoWPLzNNIwqOYx9bb8SaeEOCu+sLPFov8BvPkaVE0+RjifNZ78/My98r0FQUVZCHH2oOJ8I4FvDVtIPgOZHTeJ1vZMYfadZrvXK3pWILKkzlSQCYlqD9yzPyZZISB+jHupkdMWs86n3v/nO5y0bQb/Dvjg8ywUm+SHqEEU7LqJqdKVleUyZjaldO5VErGXdwQNi9vmJa27MPI6d479QVYI51vCiT80ntMrkxHWijl+1JIOZvhVOI90YB119vazHHX4XXtMT4crqskVB1rlZ5vhXB3QMysGijRTcG2jPj4Z/exSd2JNTkFtXSubAY7x2HgV41GnLmTzVDkor2kXyKqlr9iQIDEGyH5piaahzSH2rEVPSP2wW3KuOwO2geKjr+/tFlAD7HQCF8eeuYuZxGJiN/BF21Ay84bkKVJ++7n9wom1CGxSo1LEHOb7uAloZWeeA7eY/w+VuCFOhQBeyDMmzAFdw0WYeC0ocpX+pCoZsuVsgc3H1wUPfewOcjiNSsOWVwromU11PyaPX0IW9/qBtKjKA9SN2k5RyGVFuXt24o59LOmqOaij9eWglbPwf6JeMgIxOLZAOvWjocZyHRIme5uO1Y1AY1nSvYgDa6Jost7uNHmcmORKZ28UtF8ybW+oLyaJ9MkWB6ch8tZzc4UpYOYOUriFoMOt2l0BkT1AB10S+4Fq8V/Kt8xEuHoE6sbe11xGnWTUL4lbzeZi2vtV6s3n0X+kRPQJnmZt+nGLk0OoWmHQ4hqjeeHY/JrdK4OPFsgtgoS4WPn
 j3Epj5Tz
 SEzVqbcKVqwl5MUPHgacr8Z8wlG2yev0wuG9+VpBwSYCWpI9335hfanNuywd1eV/W9Nl71JJV58FSIxtF7NwA0QELOEdaSQWM1hcUJO2EyF9QetgnaK8RwEZQdfuHXru3tlBVQjhLOZNDWIEvjM0H5UjKT966SvkoQyen1EF/EBx6LOz/3Q+ihh7kILGONRdWTGoDOZDbdz4HhFlx5UrGVV0btFJWsSUJNkhHfz7cOdL5JeVBqKQuBs1xwNc0yXrR+eUM2a/YUznjlHhpleJiBjH4ru+d2mYdSytftDV3vAtF525pXj+6Ut3tTIS3wMchOk5e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The page allocator's PCP free path needs lock-inversion protection
against zone->lock.  The natural form -- always take pcp->lock with
spin_lock -- can deadlock because callers may hold locks (e.g.
xa_lock via slab/stack_depot) that are also taken in hardirq context,
and pcp->lock is acquired with IRQs enabled on the allocation side.

A coarse fix is to use spin_trylock and fall back to free_one_page()
(direct zone-buddy free) on contention.  That removes the inversion
risk but defeats the per-CPU pageset benefits on a busy multi-CPU
system: many frees take the slow zone->lock path, and the per-CPU
pcp->count visible to allocators understates real free-page
availability for the remote CPU's pageset.

Replace the trylock-fallback with a per-CPU remote free list (llist)
consumed by the owning CPU.  Local frees still use the trylock path;
remote frees push onto the target's lockless llist; the owning CPU
absorbs the queued pages back onto its PCP buddy lists at the next
opportunity.  Result: zero lock-inversion risk, no zone->lock
fallback storm, and remote frees become near-free at the freer's
side.

Mechanics:

  - per_cpu_pages gains struct llist_head free_llist.
  - absorb_remote_frees(pcp) drains the llist into the local PCP buddy
    lists. Called from pcp_rmqueue_smallest(), free_pcppages_bulk(),
    and drain_pages_zone().
  - __free_frozen_pages and free_unref_folios are split into a local
    path (spin_trylock on pcp->lock; on success enqueue locally) and
    a remote path (llist_add to the target CPU's free_llist).
  - The local-side spin_trylock no longer takes irqsave: lockdep
    analysis showed no IRQ-context caller of the local PCP free path
    that is also a holder of pcp->lock; the remote-from-IRQ case
    routes through llist_add (NMI-safe).
  - Memory hot-add lazy init: page_alloc_cpu_dead drains the dead PCP
    via existing drain_pages_zone (which now also drains the llist
    via absorb_remote_frees). For the narrow race where a remote freer
    raced PCPF_CPU_DEAD and pushed onto the dead PCP's llist after the
    drain, page_alloc_cpu_online absorbs any stranded pages.
  - page_alloc_cpu_dead detaches every entry from owned_blocks via
    list_del_init before reinitializing the list head.  A simpler
    INIT_LIST_HEAD-only form leaves owned PB entries with stale
    ->prev/->next pointing at the dead head -- they get list_del()'d
    later by clear_pcpblock_owner() under zone->lock, corrupting
    whatever now happens to be at the dead head address.  A
    stress-test reproducer surfaced this as a list_del prev->next ==
    prev WARN.

QEMU stress (234K worker iters + 5 hotplug cycles + 30 hugepages):
zero WARN/BUG.  Bare-metal test machine ran for ~14 hours under
production-style load with no list_del corruption, no WARN, no panic.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 include/linux/mmzone.h |   9 ++
 mm/page_alloc.c        | 249 ++++++++++++++++++++++++++++++-----------
 2 files changed, 193 insertions(+), 65 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index f0eb16390906..732e4dd181b9 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -843,6 +843,15 @@ struct per_cpu_pages {
 	/* Pageblocks owned by this CPU, for fragment recovery */
 	struct list_head owned_blocks;
 
+	/*
+	 * Pages remotely freed by other CPUs into pageblocks owned by
+	 * this CPU. Lock-free push by remote freers via llist_add(); the
+	 * owning CPU drains and merges them into its PCP buddy lists at
+	 * convenient moments (start of pcp_rmqueue_smallest, drain
+	 * paths) under pcp->lock.
+	 */
+	struct llist_head free_llist;
+
 	/* Lists of pages, one per migrate type stored on the pcp-lists */
 	struct list_head lists[NR_PCP_LISTS];
 } ____cacheline_aligned_in_smp;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a3448a97bab2..47d314e77151 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1482,6 +1482,8 @@ bool free_pages_prepare(struct page *page, unsigned int order)
 	return __free_pages_prepare(page, order, FPI_NONE);
 }
 
+static void absorb_remote_frees(struct per_cpu_pages *pcp);
+
 /*
  * Free PCP pages to zone buddy. First does a bottom-up merge pass
  * over PagePCPBuddy entries under pcp->lock only (already held by
@@ -1502,6 +1504,13 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 	struct page *page;
 	int mt, pindex;
 
+	/*
+	 * Pull in any pages remotely freed to our pageblocks before the
+	 * merge pass -- they participate in merging just like locally
+	 * freed pages.
+	 */
+	absorb_remote_frees(pcp);
+
 	/*
 	 * Ensure proper count is passed which otherwise would stuck in the
 	 * below while (list_empty(list)) loop.
@@ -1596,6 +1605,45 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 	spin_unlock_irqrestore(&zone->lock, flags);
 }
 
+/*
+ * Absorb pages remotely freed into this CPU's pageblocks. Remote freers
+ * push pages onto pcp->free_llist lock-free (no remote PCP lock taken);
+ * the owning CPU pulls them onto its PCP buddy lists here, where they
+ * become eligible for normal merging on the next free_pcppages_bulk()
+ * pass.
+ *
+ * Called with pcp->lock held. Must be cheap on the empty path; the
+ * llist_empty() check is the fast-path bail-out.
+ */
+static void absorb_remote_frees(struct per_cpu_pages *pcp)
+{
+	struct llist_node *node;
+	struct page *p, *tmp;
+	int absorbed = 0;
+
+	if (likely(llist_empty(&pcp->free_llist)))
+		return;
+
+	node = llist_del_all(&pcp->free_llist);
+	llist_for_each_entry_safe(p, tmp, node, pcp_llist) {
+		unsigned long pfn = page_to_pfn(p);
+		unsigned int order = pcp_buddy_order(p);
+		int mt = pbd_migratetype(pfn_to_pageblock(p, pfn));
+
+		if (unlikely(mt >= MIGRATE_PCPTYPES))
+			mt = MIGRATE_MOVABLE;
+
+		/*
+		 * Pages on the llist came from pageblocks owned by this CPU
+		 * (that's how the freer picked our llist), so they are
+		 * eligible for PCP-buddy merging.
+		 */
+		__SetPagePCPBuddy(p);
+		pcp_enqueue(pcp, p, mt, order);
+		absorbed += 1 << order;
+	}
+}
+
 /*
  * Search PCP free lists for a page of at least the requested order.
  * If found at a higher order, split and place remainders on PCP lists.
@@ -1606,6 +1654,8 @@ static struct page *pcp_rmqueue_smallest(struct per_cpu_pages *pcp,
 {
 	unsigned int high;
 
+	absorb_remote_frees(pcp);
+
 	for (high = order; high <= pageblock_order; high++) {
 		struct list_head *list;
 		unsigned long size;
@@ -2884,6 +2934,7 @@ static void drain_pages_zone(unsigned int cpu, struct zone *zone)
 
 	do {
 		pcp_spin_lock_nopin(pcp);
+		absorb_remote_frees(pcp);
 		count = pcp->count;
 		if (count) {
 			int to_drain = min(count,
@@ -3247,11 +3298,22 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
 	}
 
 	/*
-	 * Route page to the owning CPU's PCP for merging, or to
-	 * the local PCP for batching (zone-owned pages). Zone-owned
-	 * pages are cached without PagePCPBuddy -- the merge pass
-	 * skips them, so they're inert on any PCP list and drain
-	 * individually to zone buddy.
+	 * Route the page based on pageblock ownership:
+	 *
+	 *  - owner_cpu == this CPU (or no owner): take the local PCP
+	 *    lock with spin_trylock and enqueue normally. The trylock
+	 *    fails only on rare local self re-entry (IRQ/NMI fires
+	 *    while the interrupted task already holds the lock) or
+	 *    while a remote drain is active; either way, fall back to
+	 *    free_one_page (or the zone-llist for FPI_TRYLOCK). No
+	 *    irqsave: the trylock cannot block on self, and remote
+	 *    CPUs never take this pcp->lock (they go via free_llist),
+	 *    so an interruption cannot deadlock against another freer.
+	 *
+	 *  - owner_cpu != this CPU: lock-free push onto the owner's
+	 *    free_llist. The owner absorbs the page into its PCP buddy
+	 *    lists at its next alloc/drain. No remote PCP lock taken,
+	 *    so no cross-CPU contention.
 	 *
 	 * Ownership is stable here: it can only change when the
 	 * pageblock is complete -- either fully free in zone buddy
@@ -3259,31 +3321,46 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
 	 * Since we hold this page, neither can happen.
 	 */
 	owner_cpu = pbd->cpu - 1;
-	cache_cpu = owner_cpu;
-	if (cache_cpu < 0)
-		cache_cpu = raw_smp_processor_id();
+	cache_cpu = raw_smp_processor_id();
+
+	if (owner_cpu < 0 || owner_cpu == cache_cpu) {
+		pcp = per_cpu_ptr(zone->per_cpu_pageset, cache_cpu);
 
-	pcp = per_cpu_ptr(zone->per_cpu_pageset, cache_cpu);
-	if (unlikely(fpi_flags & FPI_TRYLOCK) || !in_task()) {
 		if (!spin_trylock(&pcp->lock)) {
+			if (fpi_flags & FPI_TRYLOCK)
+				add_page_to_zone_llist(zone, page, order);
+			else
+				free_one_page(zone, page, pfn, order, fpi_flags);
+			return;
+		}
+
+		if (unlikely(pcp->flags & PCPF_CPU_DEAD)) {
+			spin_unlock(&pcp->lock);
 			free_one_page(zone, page, pfn, order, fpi_flags);
 			return;
 		}
-	} else {
-		spin_lock(&pcp->lock);
+
+		if (free_frozen_page_commit(zone, pcp, page, migratetype,
+					    order, fpi_flags,
+					    owner_cpu == cache_cpu))
+			spin_unlock(&pcp->lock);
+		/* If commit returned false, pcp was already unlocked
+		 * (migration or trylock failure inside the batched-free
+		 * loop). */
+		return;
 	}
 
-	if (unlikely(pcp->flags & PCPF_CPU_DEAD)) {
-		spin_unlock(&pcp->lock);
+	/* Remote owner: lock-free llist hand-off. */
+	pcp = per_cpu_ptr(zone->per_cpu_pageset, owner_cpu);
+
+	if (unlikely(READ_ONCE(pcp->flags) & PCPF_CPU_DEAD)) {
 		free_one_page(zone, page, pfn, order, fpi_flags);
 		return;
 	}
 
-	if (free_frozen_page_commit(zone, pcp, page, migratetype, order,
-				    fpi_flags, cache_cpu == owner_cpu))
-		spin_unlock(&pcp->lock);
-	/* If commit returned false, pcp was already unlocked (migration or
-	 * trylock failure inside the batched-free loop). */
+	set_pcp_order(page, order);
+	llist_add(&page->pcp_llist, &pcp->free_llist);
+	__count_vm_events(PGFREE, 1 << order);
 }
 
 void free_frozen_pages(struct page *page, unsigned int order)
@@ -3335,60 +3412,78 @@ void free_unref_folios(struct folio_batch *folios)
 		struct zone *zone = folio_zone(folio);
 		unsigned long pfn = folio_pfn(folio);
 		unsigned int order = (unsigned long)folio->private;
+		struct per_cpu_pages *remote_pcp;
 		struct pageblock_data *pbd;
 		int migratetype;
-		int owner_cpu, cache_cpu;
+		int owner_cpu;
 
 		folio->private = NULL;
 		pbd = pfn_to_pageblock(&folio->page, pfn);
 		migratetype = pbd_migratetype(pbd);
 		owner_cpu = pbd->cpu - 1;
-		cache_cpu = owner_cpu;
-		if (cache_cpu < 0)
-			cache_cpu = raw_smp_processor_id();
 
-		/*
-		 * Re-lock needed if zone changed, page is isolate,
-		 * or target CPU changed.
-		 */
-		if (zone != locked_zone ||
-		    is_migrate_isolate(migratetype) ||
-		    cache_cpu != locked_cpu) {
+		/* Isolated pages always go directly to the zone buddy. */
+		if (unlikely(is_migrate_isolate(migratetype))) {
 			if (pcp) {
 				spin_unlock(&pcp->lock);
+				pcp = NULL;
 				locked_zone = NULL;
 				locked_cpu = -1;
-				pcp = NULL;
 			}
+			free_one_page(zone, &folio->page, pfn,
+				      order, FPI_NONE);
+			continue;
+		}
 
-			/*
-			 * Free isolated pages directly to the
-			 * allocator, see comment in free_frozen_pages.
-			 */
-			if (is_migrate_isolate(migratetype)) {
+		if (locked_cpu < 0)
+			locked_cpu = raw_smp_processor_id();
+
+		/*
+		 * Remote owner: lock-free push onto the owner's free_llist.
+		 * Drop any local PCP lock first; the remote llist needs no
+		 * lock and the next folio may belong to a different owner.
+		 */
+		if (owner_cpu >= 0 && owner_cpu != locked_cpu) {
+			if (pcp) {
+				spin_unlock(&pcp->lock);
+				pcp = NULL;
+				locked_zone = NULL;
+			}
+			remote_pcp = per_cpu_ptr(zone->per_cpu_pageset,
+						 owner_cpu);
+			if (unlikely(READ_ONCE(remote_pcp->flags) &
+				     PCPF_CPU_DEAD)) {
 				free_one_page(zone, &folio->page, pfn,
 					      order, FPI_NONE);
 				continue;
 			}
+			set_pcp_order(&folio->page, order);
+			llist_add(&folio->page.pcp_llist,
+				  &remote_pcp->free_llist);
+			__count_vm_events(PGFREE, 1 << order);
+			trace_mm_page_free_batched(&folio->page);
+			continue;
+		}
 
-			pcp = per_cpu_ptr(zone->per_cpu_pageset,
-					  cache_cpu);
-			/*
-			 * Use trylock when not in task context (IRQ,
-			 * softirq) to avoid spinning with IRQs
-			 * disabled. In task context, spin -- brief
-			 * contention on a per-CPU lock beats the
-			 * unbatched zone->lock fallback.
-			 */
-			if (!in_task()) {
-				if (unlikely(!spin_trylock(&pcp->lock))) {
-					pcp = NULL;
-					free_one_page(zone, &folio->page, pfn,
-						      order, FPI_NONE);
-					continue;
-				}
-			} else {
-				spin_lock(&pcp->lock);
+		/*
+		 * Local owner (or unowned): take the local PCP lock with
+		 * spin_trylock. On failure (rare local re-entry or a remote
+		 * drain in progress) fall back to the zone buddy. No
+		 * irqsave -- trylock cannot block on self, and remote
+		 * CPUs never take this pcp->lock (they go via free_llist).
+		 */
+		if (zone != locked_zone) {
+			if (pcp) {
+				spin_unlock(&pcp->lock);
+				pcp = NULL;
+				locked_zone = NULL;
+			}
+			pcp = per_cpu_ptr(zone->per_cpu_pageset, locked_cpu);
+			if (!spin_trylock(&pcp->lock)) {
+				pcp = NULL;
+				free_one_page(zone, &folio->page, pfn,
+					      order, FPI_NONE);
+				continue;
 			}
 			if (unlikely(pcp->flags & PCPF_CPU_DEAD)) {
 				spin_unlock(&pcp->lock);
@@ -3398,7 +3493,6 @@ void free_unref_folios(struct folio_batch *folios)
 				continue;
 			}
 			locked_zone = zone;
-			locked_cpu = cache_cpu;
 		}
 
 		/*
@@ -3411,7 +3505,7 @@ void free_unref_folios(struct folio_batch *folios)
 		trace_mm_page_free_batched(&folio->page);
 		if (!free_frozen_page_commit(zone, pcp, &folio->page,
 				migratetype, order, FPI_NONE,
-				cache_cpu == owner_cpu)) {
+				owner_cpu == locked_cpu)) {
 			pcp = NULL;
 			locked_zone = NULL;
 			locked_cpu = -1;
@@ -6361,6 +6455,7 @@ static void per_cpu_pages_init(struct per_cpu_pages *pcp, struct per_cpu_zonesta
 	for (pindex = 0; pindex < NR_PCP_LISTS; pindex++)
 		INIT_LIST_HEAD(&pcp->lists[pindex]);
 	INIT_LIST_HEAD(&pcp->owned_blocks);
+	init_llist_head(&pcp->free_llist);
 
 	/*
 	 * Set batch and high values safe for a boot pageset. A true percpu
@@ -6581,19 +6676,38 @@ static int page_alloc_cpu_dead(unsigned int cpu)
 		drain_pages_zone(cpu, zone);
 
 		/*
-		 * Drain released all pages. Reinitialize the
-		 * owned-blocks list -- any remaining entries are
-		 * stale (fragments that merged in zone buddy and
-		 * cleared ownership, but weren't removed from
-		 * the list because __free_one_page doesn't hold
-		 * pcp->lock).
+		 * drain_pages_zone iterates absorb_remote_frees +
+		 * free_pcppages_bulk until both pcp->count and the
+		 * remote-free llist are empty. A remote freer that
+		 * read PCPF_CPU_DEAD as clear *before* the flag was set
+		 * above and does llist_add *after* the drain exits will
+		 * leave a few pages on the dead PCP's free_llist; they
+		 * are harmless and absorbed when the CPU comes back
+		 * online (any first alloc/free runs absorb_remote_frees).
 		 *
-		 * Hold zone lock to prevent racing with other
-		 * CPUs doing list_del_init on stale entries
-		 * from this list during their Phase 1.
+		 * Drain released all pages. Tear down the owned-blocks
+		 * list cleanly: walk each entry and list_del_init() it
+		 * before INIT_LIST_HEAD on the head. INIT_LIST_HEAD
+		 * alone would leave stale entries with prev/next
+		 * pointing at the (now self-pointing) head, so a future
+		 * clear_pcpblock_owner -> list_del_init on a stale
+		 * pbd->cpu_node would corrupt the list head it walks
+		 * back through. Detaching each entry first makes the
+		 * subsequent list_del_init a safe self-loop no-op.
+		 *
+		 * Hold zone lock to serialize with concurrent Phase 0
+		 * iteration on this same list from other CPUs (which
+		 * also hold zone->lock).
 		 */
 		pcp_spin_lock_nopin(pcp);
 		spin_lock_irqsave(&zone->lock, zflags);
+		while (!list_empty(&pcp->owned_blocks)) {
+			struct pageblock_data *pbd =
+				list_first_entry(&pcp->owned_blocks,
+						 struct pageblock_data,
+						 cpu_node);
+			list_del_init(&pbd->cpu_node);
+		}
 		INIT_LIST_HEAD(&pcp->owned_blocks);
 		spin_unlock_irqrestore(&zone->lock, zflags);
 		pcp_spin_unlock_nopin(pcp);
@@ -6632,6 +6746,11 @@ static int page_alloc_cpu_online(unsigned int cpu)
 		pcp = per_cpu_ptr(zone->per_cpu_pageset, cpu);
 		pcp_spin_lock_nopin(pcp);
 		pcp->flags &= ~PCPF_CPU_DEAD;
+		/*
+		 * Pull in any pages that landed on the free_llist while
+		 * the CPU was down (rare race in page_alloc_cpu_dead).
+		 */
+		absorb_remote_frees(pcp);
 		pcp_spin_unlock_nopin(pcp);
 
 		zone_pcp_update(zone, 1);
-- 
2.54.0


