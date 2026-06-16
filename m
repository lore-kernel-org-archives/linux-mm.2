Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2782ACD98D2
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 20:55:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 188EA6B00AB; Tue, 16 Jun 2026 16:55:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 166B26B00B4; Tue, 16 Jun 2026 16:55:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09E5A6B00B4; Tue, 16 Jun 2026 16:55:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D043E6B00A8
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 16:55:51 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 672241C37E5
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:55:51 +0000 (UTC)
X-FDA: 84886982502.27.69E1612
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf03.hostedemail.com (Postfix) with ESMTP id A1EF920004
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:55:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=p2PkWtj6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781643349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1hyb9sq/pDu2vAWByIj5s/oybcaQC5FJ8ZbbzIxTBqU=;
	b=og7HIAW4nlT/d+piAL6BDsOtW9JfOa5MQfAtP6AR7X1e7O/JSOVUGJG4/jibkE7hNBYyiV
	ogBr6F6n7lGKH56R22t68EiZIdrt3t83byX+06kujncd21bgfMbYip4zpag+aqYBgxvNVT
	qh8OC/FQ3z5w+2m+fMOHmhBaHFMrwho=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=p2PkWtj6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781643349;
	b=QFkuaXILKwN2sn//Qg6V6PKC4HLcf1WJb9cl9qwbummKL7HMwJUDo9NQ3DECeJGdn+1BY/
	urq7vN2fsXq9CB5FHZwg17ONFEZfVyTCTD425FOr4l0gxGqpy7Anq9PhXIdwJaI81lS3Lk
	rESrQznw55JsZBUGLimc27c8bRs61/c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781637305;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1hyb9sq/pDu2vAWByIj5s/oybcaQC5FJ8ZbbzIxTBqU=;
	b=p2PkWtj6CKG2gyrtbPEdLk4B3wWGQLE7aaGewHGIneXFiEEa5/YFkCru72qnkH7OL4kdYP
	7vEV+HDtJNT59vutmfddOYlKataaXdlEs0aCZ11ANsO+19L2UnSIJL0CjTMV4MSHtapFAp
	oClkG1la1mdCh3fw7YYSYl0T5qkZJdw=
From: JP Kobryn <jp.kobryn@linux.dev>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	fvdl@google.com,
	linux-mm@kvack.org
Cc: shakeel.butt@linux.dev,
	usama.arif@linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/page_alloc: use existing highatomic reserves on the buddy fastpath
Date: Tue, 16 Jun 2026 12:14:20 -0700
Message-ID: <20260616191420.52556-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A1EF920004
X-Stat-Signature: efqghwngkc4jsgm1q14zdxkcr38fr6iy
X-Rspam-User: 
X-HE-Tag: 1781643349-123116
X-HE-Meta: U2FsdGVkX1/O5/U5xEIAIa8bhUPOjLDu49rOdqCFa/zSN+3G+C7YG5GJB3DKMkRZhq7u3D9EprAkit2c1DmOK9IiHCgmBKZsF5qVg1RnAHnay54Ai83B8ZusMfYJFJqjG3r4nKd2sZvyKgHMp7QD2NMEdYrOpwd7h31tWogP+OV00o0Bv/alpoXaCCUMh/D8ogPDdRZkWezYIKfpTXmVO6cep6WlRzFSLucGoIMPbMwuxFeVh3BsmyYbi+sfsH0AZT/o++8AeCF0V27lbZxroo9XgfnIG0DW5iNsPB50P7RBuiZsWHkL3bSPJTuAmo+QSP3F7o0G7fIrrhocWu/r7PQYtpmgZsAQpRAXeh/pMTwhWSa3IQBIVO0PlaG77iZwNSCxp6lKgU96sKeg5PJS+GbL79wcloLoURScAwgm4YngcW1xRXCYm3jONNN/DH9uzXSGjdAOmo0aFVPB08AN4MdY6c/AQM+C/0imYzWLfEQlEvuKgcLXmrAZnFt/VI3Iz+o1+gyvvoz0jSYRJTKb6KJqhChQKcE24YgtbD8e4QyrSx4ypV6HodD2y5rhk6oXIj4+74VN+RGjVcMKpOxOJQtCr7+dyQTJujMtMVja+CZRR/33UFjiluYhDuGEz1mdINdWGYWPrW0qqVJwKvKNEcrOnZ1QmDzWvNqxgksU/KUnS48/T58xEH3j01wc65rs9MgBSArL+GcMx6tdosALllVc7BOE9X+Z+DcJZxHQ6fVS+czCqNByqWIXnaCwXcbdgTdOz5qGCB4IviZ4VOGY6cKuQ2LHPLFeTosb85A2JdP6qrPXZ+vImlOEKcB+57HBm7caA6iVnHelgGLzPMqhTfmUC4C5yGB1VQCtoZaCl1s4ReZRQvFEdycD6peO/GooRxuczb8LOkdjya2i0W6/MdP5D4EpZy1v6wKNzEC0PkTS84g1bWT/yx9MfLeW+capxjvafb4GhANXYOtcJMp
 ejcW7FaI
 48m0I3o7jrkqTcm/OJswhsgQMjwy0HQEM1v+bFVph0O8ezBwl6FJ59yEMrLOmLK4ntBs5zTSH+DzbTPtOgfpKmmL2FdT5KFNlZicRi2pVs3N8j71F7yPol1bhoqu9SrCBfld4XVImuhUHYmFoSkD0pwALy97X/Oq22MkdzhicHsKCI9sct893FbqH4BJ3VEDLbIaoF6t9MGuIU/qniOPuwhlEyvdfvxBt7V0OI01L+kp0PYIA1wASo546yw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ALLOC_HIGHATOMIC currently provides both access to MIGRATE_HIGHATOMIC free
pages and permission to create new highatomic pageblock reserves. This
makes it unsuitable for the fastpath.

However, the fastpath can reach rmqueue_buddy() while MIGRATE_HIGHATOMIC
reserves have free pages available. In this situation, the allocation can
fall back to other migratetypes without trying those reserves first.

Allow high-priority non-blocking allocations above order-0 and up to the
costly order to use existing MIGRATE_HIGHATOMIC reserves on the buddy
fastpath without granting permission to grow these reserves. Add
ALLOC_HIGHATOMIC_RESERVE for allocations that may both access
MIGRATE_HIGHATOMIC and grow the reserves. Change the semantics of
ALLOC_HIGHATOMIC so that it may only access the reserves.

A UDP receive workload was run with free MIGRATE_HIGHATOMIC pageblocks
available in the target zone. Before this patch, the workload did not
consume these blocks. With this patch, comparable runs consumed available
blocks for 96-100% of eligible order-1 atomic allocations reaching the
buddy path, with no highatomic misses observed. The workload did not grow
highatomic reserves and NAPI page-frag allocations remained healthy with no
failures or order-0 fallbacks.

Signed-off-by: JP Kobryn <jp.kobryn@linux.dev>
---
 mm/internal.h   |  4 +++-
 mm/page_alloc.c | 34 +++++++++++++++++++++++++++-------
 2 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 181e79f1d6a2..a7693a9fdd29 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1477,9 +1477,11 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 #define ALLOC_HIGHATOMIC	0x200 /* Allows access to MIGRATE_HIGHATOMIC */
 #define ALLOC_TRYLOCK		0x400 /* Only use spin_trylock in allocation path */
 #define ALLOC_KSWAPD		0x800 /* allow waking of kswapd, __GFP_KSWAPD_RECLAIM set */
+#define ALLOC_HIGHATOMIC_RESERVE	0x1000 /* Allows growing MIGRATE_HIGHATOMIC reserves */
 
 /* Flags that allow allocations below the min watermark. */
-#define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
+#define ALLOC_RESERVES (ALLOC_NON_BLOCK | ALLOC_MIN_RESERVE | \
+	ALLOC_HIGHATOMIC | ALLOC_OOM | ALLOC_HIGHATOMIC_RESERVE)
 
 enum ttu_flags;
 struct tlbflush_unmap_batch;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ee902a468c2f..e1c28bc0ba3f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3222,7 +3222,7 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 		} else {
 			spin_lock_irqsave(&zone->lock, flags);
 		}
-		if (alloc_flags & ALLOC_HIGHATOMIC)
+		if (alloc_flags & (ALLOC_HIGHATOMIC | ALLOC_HIGHATOMIC_RESERVE))
 			page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
 		if (!page) {
 			enum rmqueue_mode rmqm = RMQUEUE_NORMAL;
@@ -3250,7 +3250,7 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 	 * If this is a high-order atomic allocation then check
 	 * if the pageblock should be reserved for the future
 	 */
-	if (unlikely(alloc_flags & ALLOC_HIGHATOMIC))
+	if (unlikely(alloc_flags & ALLOC_HIGHATOMIC_RESERVE))
 		reserve_highatomic_pageblock(page, order, zone);
 
 	__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
@@ -3333,9 +3333,10 @@ struct page *__rmqueue_pcplist(struct zone *zone, unsigned int order,
 			 * Instead, direct it towards the reserves by
 			 * returning NULL, which will make the caller fall
 			 * back to rmqueue_buddy. This will try to use the
-			 * reserves first and grow them if needed.
+			 * reserves first and grow them if permitted by
+			 * the ALLOC_HIGHATOMIC_RESERVE flag.
 			 */
-			if (alloc_flags & ALLOC_HIGHATOMIC)
+			if (alloc_flags & (ALLOC_HIGHATOMIC | ALLOC_HIGHATOMIC_RESERVE))
 				return NULL;
 
 			alloced = rmqueue_bulk(zone, order,
@@ -3653,7 +3654,7 @@ bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
 			return true;
 		}
 #endif
-		if ((alloc_flags & (ALLOC_HIGHATOMIC|ALLOC_OOM)) &&
+		if ((alloc_flags & (ALLOC_HIGHATOMIC | ALLOC_HIGHATOMIC_RESERVE | ALLOC_OOM)) &&
 		    !free_area_empty(area, MIGRATE_HIGHATOMIC)) {
 			return true;
 		}
@@ -3773,6 +3774,24 @@ alloc_flags_nofragment(struct zone *zone, gfp_t gfp_mask)
 	return alloc_flags;
 }
 
+/*
+ * Let high-priority non-blocking allocations above order-0 and up
+ * to the costly order try to use existing MIGRATE_HIGHATOMIC
+ * reserves on the fastpath.
+ */
+static inline unsigned int
+alloc_flags_highatomic_fastpath(gfp_t gfp_mask, unsigned int order)
+{
+	if (!order || order > PAGE_ALLOC_COSTLY_ORDER)
+		return 0;
+	if (!(gfp_mask & __GFP_HIGH))
+		return 0;
+	if (gfp_mask & (__GFP_DIRECT_RECLAIM | __GFP_NOMEMALLOC))
+		return 0;
+
+	return ALLOC_HIGHATOMIC;
+}
+
 /* Must be called after current_gfp_context() which can change gfp_mask */
 static inline unsigned int gfp_to_alloc_flags_cma(gfp_t gfp_mask,
 						  unsigned int alloc_flags)
@@ -4504,7 +4523,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask, unsigned int order)
 			alloc_flags |= ALLOC_NON_BLOCK;
 
 			if (order > 0 && (alloc_flags & ALLOC_MIN_RESERVE))
-				alloc_flags |= ALLOC_HIGHATOMIC;
+				alloc_flags |= ALLOC_HIGHATOMIC_RESERVE;
 		}
 
 		/*
@@ -5298,7 +5317,8 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 	 * Forbid the first pass from falling back to types that fragment
 	 * memory until all local zones are considered.
 	 */
-	alloc_flags |= alloc_flags_nofragment(zonelist_zone(ac.preferred_zoneref), gfp);
+	alloc_flags |= alloc_flags_nofragment(zonelist_zone(ac.preferred_zoneref), gfp) |
+			alloc_flags_highatomic_fastpath(alloc_gfp, order);
 
 	/* First allocation attempt */
 	page = get_page_from_freelist(alloc_gfp, order, alloc_flags, &ac);
-- 
2.54.0


