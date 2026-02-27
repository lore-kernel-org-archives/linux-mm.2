Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01F1AFEFB6D
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 17:08:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6423D6B0095; Fri, 27 Feb 2026 12:08:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 613816B0098; Fri, 27 Feb 2026 12:08:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 540546B0099; Fri, 27 Feb 2026 12:08:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3A8476B0095
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:08:11 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BEA0DC24EE
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:08:10 +0000 (UTC)
X-FDA: 84490869540.06.F6990F5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0FD4DA000C
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:08:08 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ExBYdjB9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772212089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M8dpHCX14QIIhweNEHDB8uT4XlhE7BE3CcmVSPJ2PRs=;
	b=cvWXsB3vXpMjJw6IU5fjk+FgMBszYiCEcjLnuhy5QQZDd2Ejyvc3d/dB68Uf6zbJzRPiGg
	aLuorAt116Z0FhdC0P0d+OxU1ZBtsM4a91Wy53bmwdGe/FUr1DR2NtTNPjh3JEQWbqs2/r
	GAf/zrxglPAN5LO9h+4BPBcV6XHa6so=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772212089; a=rsa-sha256;
	cv=none;
	b=elGi+fL4gIJqDDuQkAukdVPTT8GZdiHPqqUXi7W9SjczgVWXDkNER9AUCVrE3X0NWD0WmY
	E9M/fnRk2T5z9IER9rcyZwJ74XFzwikdF6oMe7lsY3oup/YNqsgeuAHDpseUPrgZZ1OBBn
	/jgExQj6p6zPu+GYoy2zGtsokeNmUkg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ExBYdjB9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 809AA60126;
	Fri, 27 Feb 2026 17:08:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35CDCC19423;
	Fri, 27 Feb 2026 17:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772212088;
	bh=xzzax/yNRqu9CL3hLPRcqTuNkH/bgHYNAcmNkRo/28k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ExBYdjB9dWW23PKnxzDlcn96ALg/fpm43vsvY9bbV1N1GCICFt73WT+GPKGWlItJo
	 Et1mTK9o8vn85QQFYhdMrrL7GQ7bfotjBI+WBEEJVffHerL5ip3MU8CaCmURZlOIM7
	 a+SFIRF9pFpEZzuVX16xs9nXjOb45JM3qWI3QwB/FCQH1J4FgbpayMev8QPOGttSYI
	 /Sg/+Cqq1BlolT/EG4QgQMerHHBqG0o7+lRJ614v9+BipqD8pNi1uo+sxBNjnHftZg
	 pIG5WYfe+cBPMX+tuOaHIr07FS/ULvRMb2AXI8J0OcRjrX8YceCCFQumT4UHTp2b28
	 60PBrwqoKWqFw==
From: Vlastimil Babka <vbabka@kernel.org>
Date: Fri, 27 Feb 2026 18:07:58 +0100
Subject: [PATCH 1/3] mm/page_alloc: effectively disable pcp with
 CONFIG_SMP=n
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260227-b4-pcp-locking-cleanup-v1-1-f7e22e603447@kernel.org>
References: <20260227-b4-pcp-locking-cleanup-v1-0-f7e22e603447@kernel.org>
In-Reply-To: <20260227-b4-pcp-locking-cleanup-v1-0-f7e22e603447@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>
Cc: Mel Gorman <mgorman@techsingularity.net>, 
 Matthew Wilcox <willy@infradead.org>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-rt-devel@lists.linux.dev, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.14.3
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0FD4DA000C
X-Stat-Signature: gxb6a5y3xquoorf3g6zaugk53aiosi1y
X-Rspam-User: 
X-HE-Tag: 1772212088-991923
X-HE-Meta: U2FsdGVkX19fVA1yCsw/coOSxBEGcdfuJIy0u1qfz71H6u8vjwo5k25EJmoqrg6Ae7/l6CD8+6Maewd6kFaJYjUqFXM9L8VAvguaLNXV4OJpXOpqhSkEpV1k6IuqpdDWh/dosxJJkUvjsggR8UL4ZNyta1BKy0Oslqa8Fg9O29YhKpuW5gy6ITQlDJIiHxavo0KhXyg4Bk7VpNLMvEUQuvNSbt2zYe5eRC8VD3q2XO4pYsKninl/m7WlF4/4897LnjxpIIcjsomaWVOqrNO8Ms4WJ6DJzk2UYpio2YRRRx3BzAMyUimzlK+EQUb2xa1aATJb+WY/QreNOMsv2XLWclR6V0qbIyaU3SzdFa3ynY3UL+5alrtDNVpRBnphvhY4Gg3ucExpR8fFj4/xIz6uRypdUpT4YEPt83i+D9mlR9njmdEnjuK6RRJL6mQV9+u4376K31hjID8tnD6t6cjT0zXU1DMKCj3TSwUqN8SI6fLxpoeyyHOpb/S5v4mxyIX/2y50hGFaojeBi+YQEwlDmhXBFZyNotQB2k83+Vcm8SRDDzsO0XWsP5C3JoBRpi3e31W1GRJqUN/rTwbBStpuNSI9UBODCOuQ0tYWkPWQzv2qCzGPt0FHWHCfVjBI/oCDR8c02BJAJMonGIECCqwYMBOifm6CJEsp8tUJeZi6hHRf2I3lnxynpE1TUyqm7aajB/ch+RnMDuItkBmS7MjUayY8an/x9mws2wKx0J4VqPQld9BlMmAvv3JXK/F7QZQnTs/KLfVtxEGu0hvzO4k6ZOsV67qEImCgmbGcAHBTRnI96lGrNfI+NfFzwxYwlR2bNbwGBU/ZUUVqASIIr4+WoOqZ81OwPQV6nWXt/hn7bGdXGjxoSbHUy+cuBkWGkkpUF+nNf4YgiWFG+Bwx2+MNgvjd2KZ86SaEzdjzfh3ibcyNpNG2oxFI28XgMxrIyWofwhrPamRGw9wfCtkkT8F
 6sOq5+WV
 SYyxH7AI8XDWUwDwCp4S9PsI8aJCV0wpwCXz0JF5Tq1Xo/bbUWsPYbfucjfoOkCmryQHgczpfn0W31gWtrb8LmBFeoUPj9UPCsbv5VTvcMA0Tis++5ciE9DOgYKjsMRd1B0ef5rqdJV+N/BlW5beH6vjnFoPZbdY6fwk3+LDHrTwXJb73ay1qQOx+KCY4AZLaJ9VgP7sZ560NMOy1dEFkT/RVGMJPR+GVTjsDIaC5w4ZtM7rLSTmCT5JRGijR33OOfJplWLtDlAQxDrllDhiypHYgBVIBgHCcr7tw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The page allocator has been using a locking scheme for its percpu page
caches (pcp) based on spin_trylock() with no _irqsave() part. The trick
is that if we interrupt the locked section, we fail the trylock and just
fallback to the slowpath taking the zone lock. That's more expensive,
but rare, so we don't need to pay the irqsave/restore cost all the time
in the fastpaths.

It's similar to but not exactly local_trylock_t (which is also newer anyway)
because in some cases we do lock the pcp of a non-local cpu to drain it, in
a way that's cheaper than using IPI or queue_work_on().

The complication of this scheme has been UP non-debug spinlock
implementation which assumes spin_trylock() can't fail on UP and has no
state to track whether it's locked. It just doesn't anticipate this
usage scenario. So to work around that we disable IRQs only on UP,
complicating the implementation. Also recently we found years old bug in
where we didn't disable IRQs in related paths - see 038a102535eb
("mm/page_alloc: prevent pcp corruption with SMP=n").

We can avoid this UP complication by realizing that we do not need the
pcp caching for scalability on UP in the first place. Removing it
completely with #ifdefs is not worth the trouble either. Just make
pcp_spin_trylock() return NULL unconditionally on CONFIG_SMP=n. This
makes the slowpaths unconditional, and we can remove the IRQ
save/restore handling in pcp_spin_trylock()/unlock() completely.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/page_alloc.c | 92 +++++++++++++++++++++------------------------------------
 1 file changed, 34 insertions(+), 58 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2d2e9eea077f..65efcaeb8800 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -95,23 +95,6 @@ typedef int __bitwise fpi_t;
 static DEFINE_MUTEX(pcp_batch_high_lock);
 #define MIN_PERCPU_PAGELIST_HIGH_FRACTION (8)
 
-#if defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT)
-/*
- * On SMP, spin_trylock is sufficient protection.
- * On PREEMPT_RT, spin_trylock is equivalent on both SMP and UP.
- * Pass flags to a no-op inline function to typecheck and silence the unused
- * variable warning.
- */
-static inline void __pcp_trylock_noop(unsigned long *flags) { }
-#define pcp_trylock_prepare(flags)	__pcp_trylock_noop(&(flags))
-#define pcp_trylock_finish(flags)	__pcp_trylock_noop(&(flags))
-#else
-
-/* UP spin_trylock always succeeds so disable IRQs to prevent re-entrancy. */
-#define pcp_trylock_prepare(flags)	local_irq_save(flags)
-#define pcp_trylock_finish(flags)	local_irq_restore(flags)
-#endif
-
 /*
  * Locking a pcp requires a PCP lookup followed by a spinlock. To avoid
  * a migration causing the wrong PCP to be locked and remote memory being
@@ -150,31 +133,28 @@ static inline void __pcp_trylock_noop(unsigned long *flags) { }
 	pcpu_task_unpin();						\
 })
 
-/* struct per_cpu_pages specific helpers. */
-#define pcp_spin_trylock(ptr, UP_flags)					\
-({									\
-	struct per_cpu_pages *__ret;					\
-	pcp_trylock_prepare(UP_flags);					\
-	__ret = pcpu_spin_trylock(struct per_cpu_pages, lock, ptr);	\
-	if (!__ret)							\
-		pcp_trylock_finish(UP_flags);				\
-	__ret;								\
-})
+/* struct per_cpu_pages specific helpers.*/
+#ifdef CONFIG_SMP
+#define pcp_spin_trylock(ptr)						\
+		pcpu_spin_trylock(struct per_cpu_pages, lock, ptr)
 
-#define pcp_spin_unlock(ptr, UP_flags)					\
-({									\
-	pcpu_spin_unlock(lock, ptr);					\
-	pcp_trylock_finish(UP_flags);					\
-})
+#define pcp_spin_unlock(ptr)						\
+		pcpu_spin_unlock(lock, ptr)
 
 /*
- * With the UP spinlock implementation, when we spin_lock(&pcp->lock) (for i.e.
- * a potentially remote cpu drain) and get interrupted by an operation that
- * attempts pcp_spin_trylock(), we can't rely on the trylock failure due to UP
- * spinlock assumptions making the trylock a no-op. So we have to turn that
- * spin_lock() to a spin_lock_irqsave(). This works because on UP there are no
- * remote cpu's so we can only be locking the only existing local one.
+ * On CONFIG_SMP=n the UP implementation of spin_trylock() never fails and thus
+ * is not compatible with our locking scheme. However we do not need pcp for
+ * scalability in the first place, so just make all the trylocks fail and take
+ * the slow path unconditionally.
  */
+#else
+#define pcp_spin_trylock(ptr)		\
+		NULL
+
+#define pcp_spin_unlock(ptr)		\
+		BUG_ON(1)
+#endif
+
 #if defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT)
 static inline void __flags_noop(unsigned long *flags) { }
 #define pcp_spin_lock_maybe_irqsave(ptr, flags)		\
@@ -2862,7 +2842,7 @@ static int nr_pcp_high(struct per_cpu_pages *pcp, struct zone *zone,
  */
 static bool free_frozen_page_commit(struct zone *zone,
 		struct per_cpu_pages *pcp, struct page *page, int migratetype,
-		unsigned int order, fpi_t fpi_flags, unsigned long *UP_flags)
+		unsigned int order, fpi_t fpi_flags)
 {
 	int high, batch;
 	int to_free, to_free_batched;
@@ -2922,9 +2902,9 @@ static bool free_frozen_page_commit(struct zone *zone,
 		if (to_free == 0 || pcp->count == 0)
 			break;
 
-		pcp_spin_unlock(pcp, *UP_flags);
+		pcp_spin_unlock(pcp);
 
-		pcp = pcp_spin_trylock(zone->per_cpu_pageset, *UP_flags);
+		pcp = pcp_spin_trylock(zone->per_cpu_pageset);
 		if (!pcp) {
 			ret = false;
 			break;
@@ -2936,7 +2916,7 @@ static bool free_frozen_page_commit(struct zone *zone,
 		 * returned in an unlocked state.
 		 */
 		if (smp_processor_id() != cpu) {
-			pcp_spin_unlock(pcp, *UP_flags);
+			pcp_spin_unlock(pcp);
 			ret = false;
 			break;
 		}
@@ -2968,7 +2948,6 @@ static bool free_frozen_page_commit(struct zone *zone,
 static void __free_frozen_pages(struct page *page, unsigned int order,
 				fpi_t fpi_flags)
 {
-	unsigned long UP_flags;
 	struct per_cpu_pages *pcp;
 	struct zone *zone;
 	unsigned long pfn = page_to_pfn(page);
@@ -3004,12 +2983,12 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
 		add_page_to_zone_llist(zone, page, order);
 		return;
 	}
-	pcp = pcp_spin_trylock(zone->per_cpu_pageset, UP_flags);
+	pcp = pcp_spin_trylock(zone->per_cpu_pageset);
 	if (pcp) {
 		if (!free_frozen_page_commit(zone, pcp, page, migratetype,
-						order, fpi_flags, &UP_flags))
+						order, fpi_flags))
 			return;
-		pcp_spin_unlock(pcp, UP_flags);
+		pcp_spin_unlock(pcp);
 	} else {
 		free_one_page(zone, page, pfn, order, fpi_flags);
 	}
@@ -3030,7 +3009,6 @@ void free_frozen_pages_nolock(struct page *page, unsigned int order)
  */
 void free_unref_folios(struct folio_batch *folios)
 {
-	unsigned long UP_flags;
 	struct per_cpu_pages *pcp = NULL;
 	struct zone *locked_zone = NULL;
 	int i, j;
@@ -3073,7 +3051,7 @@ void free_unref_folios(struct folio_batch *folios)
 		if (zone != locked_zone ||
 		    is_migrate_isolate(migratetype)) {
 			if (pcp) {
-				pcp_spin_unlock(pcp, UP_flags);
+				pcp_spin_unlock(pcp);
 				locked_zone = NULL;
 				pcp = NULL;
 			}
@@ -3092,7 +3070,7 @@ void free_unref_folios(struct folio_batch *folios)
 			 * trylock is necessary as folios may be getting freed
 			 * from IRQ or SoftIRQ context after an IO completion.
 			 */
-			pcp = pcp_spin_trylock(zone->per_cpu_pageset, UP_flags);
+			pcp = pcp_spin_trylock(zone->per_cpu_pageset);
 			if (unlikely(!pcp)) {
 				free_one_page(zone, &folio->page, pfn,
 					      order, FPI_NONE);
@@ -3110,14 +3088,14 @@ void free_unref_folios(struct folio_batch *folios)
 
 		trace_mm_page_free_batched(&folio->page);
 		if (!free_frozen_page_commit(zone, pcp, &folio->page,
-				migratetype, order, FPI_NONE, &UP_flags)) {
+				migratetype, order, FPI_NONE)) {
 			pcp = NULL;
 			locked_zone = NULL;
 		}
 	}
 
 	if (pcp)
-		pcp_spin_unlock(pcp, UP_flags);
+		pcp_spin_unlock(pcp);
 	folio_batch_reinit(folios);
 }
 
@@ -3375,10 +3353,9 @@ static struct page *rmqueue_pcplist(struct zone *preferred_zone,
 	struct per_cpu_pages *pcp;
 	struct list_head *list;
 	struct page *page;
-	unsigned long UP_flags;
 
 	/* spin_trylock may fail due to a parallel drain or IRQ reentrancy. */
-	pcp = pcp_spin_trylock(zone->per_cpu_pageset, UP_flags);
+	pcp = pcp_spin_trylock(zone->per_cpu_pageset);
 	if (!pcp)
 		return NULL;
 
@@ -3390,7 +3367,7 @@ static struct page *rmqueue_pcplist(struct zone *preferred_zone,
 	pcp->free_count >>= 1;
 	list = &pcp->lists[order_to_pindex(migratetype, order)];
 	page = __rmqueue_pcplist(zone, order, migratetype, alloc_flags, pcp, list);
-	pcp_spin_unlock(pcp, UP_flags);
+	pcp_spin_unlock(pcp);
 	if (page) {
 		__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
 		zone_statistics(preferred_zone, zone, 1);
@@ -5071,7 +5048,6 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 			struct page **page_array)
 {
 	struct page *page;
-	unsigned long UP_flags;
 	struct zone *zone;
 	struct zoneref *z;
 	struct per_cpu_pages *pcp;
@@ -5165,7 +5141,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		goto failed;
 
 	/* spin_trylock may fail due to a parallel drain or IRQ reentrancy. */
-	pcp = pcp_spin_trylock(zone->per_cpu_pageset, UP_flags);
+	pcp = pcp_spin_trylock(zone->per_cpu_pageset);
 	if (!pcp)
 		goto failed;
 
@@ -5184,7 +5160,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		if (unlikely(!page)) {
 			/* Try and allocate at least one page */
 			if (!nr_account) {
-				pcp_spin_unlock(pcp, UP_flags);
+				pcp_spin_unlock(pcp);
 				goto failed;
 			}
 			break;
@@ -5196,7 +5172,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		page_array[nr_populated++] = page;
 	}
 
-	pcp_spin_unlock(pcp, UP_flags);
+	pcp_spin_unlock(pcp);
 
 	__count_zid_vm_events(PGALLOC, zone_idx(zone), nr_account);
 	zone_statistics(zonelist_zone(ac.preferred_zoneref), zone, nr_account);

-- 
2.53.0


