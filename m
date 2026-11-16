Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BC42606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 12:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jvlm1zom
Received: by kanga.kvack.org (Postfix)
	id B8D276B05C9; Mon, 16 Nov 2026 07:51:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B64A96B05CA; Mon, 16 Nov 2026 07:51:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A53906B05CB; Mon, 16 Nov 2026 07:51:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 865F46B05C9
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:51:24 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 022C5160666
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:51:24 +0000 (UTC)
X-FDA: 85440968088.06.0F2DFC1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 014F1A0002
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:51:21 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jvlm1zom;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794833482;
	b=Oy0i9h07CHoKSyvnznKmu3H9EI0SKWBtcKz/k5GrUMyDF0bV4P27hJzYqoU/rVY/cIGB2I
	sy4RZbTeIS6uccCR3CTkGMNb0W05YsmHnUv8l5q0HiLeuDAA2mMoGSVtUDiKWvHlbhYd9g
	uFwI3yWc87WMaWCz06SAGAg24Bl9YDE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794833482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FawFGpu24nqmYgxnTPWSScuSy3Ov5v1Ccl8krMGTmys=;
	b=kwayj8TC2OkkDnyL6W5IZ5ptNT181JE4O3S7jV3fXyrO6d4C3YMW+ha6UnJZk6fVnFTbMM
	LCB54kv005kHPS3428FbOBYtFriPJevsILOIfTbctLRVG6AcJHQQB0liiBX4iollTqNhZW
	/ztn0AqszYzcrQHak/SSCCGlbzc/Udg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jvlm1zom;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 576E640883;
	Mon, 16 Nov 2026 12:51:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C034E1F000C9;
	Mon, 16 Nov 2026 12:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794833481;
	bh=FawFGpu24nqmYgxnTPWSScuSy3Ov5v1Ccl8krMGTmys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jvlm1zom8lgjE2YfF399PEuQif74vKLO1uT8/u9rRZkhCo9/MR/J2fBMeEPTNxj0z
	 yBkZtVjxbkfYP5+YE96tzbiIUyzytZKP+aH5ykUg4VZDNyKAlKY2wHtT0I4qpq52gT
	 rkrGlRaAYvug19nSHpNLjsXCBlIyWRfAX+Y90D+90GPeDC1wa11yfBplc4p5isnEIr
	 fssDk9BGRCK0mHjWdVd/fQqgPFsk7Nd0P+dTs3hl7CrL9MF2lJw2mEgsB6jPYQNyrT
	 TEQgu2Ft2lBhejh0c9TvR9No9oMvbrcEjFlaK91MOM0dLrknLdjFwbvg9tMXQwKxqZ
	 HO+MBWZJel0+Q==
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfauth.ams.internal (Postfix) with ESMTP id 1E982198004A;
	Mon, 16 Nov 2026 07:51:16 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Mon, 16 Nov 2026 07:51:18 -0500
X-ME-Sender: <xms:Q_z6atC5knrIKpJYfuAdL5cJeNJhfVQekE1ChuOZj9PTu8UjBL8LmA>
    <xme:Q_z6asm02pZpipO3debddEWc_4JLbs1coDZ8lmiDd0__ifIG2dG-oXVJpbJYyElan
    uX-XKBEEMpx3M9vndennPFragIXoG7VXFKMZcZRXuJgXPCVxfcqxaE>
X-ME-Received: <xmr:Q_z6arhkX-dgwz4ea6l48Ijqueyr1LT42G3rqTHInfSKWSEq9BvbJ_oTu-s>
X-ME-Proxy-Cause: dmFkZTEndR1twvEtVV9H42M6Qp3CHlOf2K86xhOcIvsHlI0qPC43EEHmYQS8lk+yVDorCL
    4AZIMFoK0mM5jxtyIPxyjz9+QW+KDyr5a1QI5LAVNOvvdezfJIUFEiBk8hqwDUM1ipGtqV
    Yj2cbe2LqPMwyAo52y79X45epac/GwTfTEU69t1sP1+Wb/QEsMx5rWyZD+nPZUaFTyFXG+
    5CQ4wZzn6SCh8TwXgLLqjmYSN52Omu45Pq5Ep93lX5zHUXxZrJ0QNbBDhUDgexZPkTOOE8
    szf9NTieQQj+m2laq7APapu9RHhoSoGNwFFQicqgJd//nPpk/ulYLPxsZmBstc/W7NyVKP
    L0TVWOyeltJ1Dtn1gieignN7lmvkRBxENIvN8YpQIucfXbD+g1AkSIh4Pd97MqwFMjd43t
    CDWdyOmng1aIntp6RfUI8PoiLHeZK7ZnDeKvKYBVA8iPBlD2J5KBy/ajJAxgYw4mAVh87y
    BBNCintJqsHd5v2ckYXBmPRSm/jVB9f8IWroAINDQn6VNnEGILq/adb2sgWASZmddAnCig
    WALZZEMCzwqS589GcXGtpcEgyavKLKqyy+DW54Oo0iW9I9Xce7DCOERlht71GEIAQhfko0
    jh8vDGuh+wEXq+35+/wvPtCK4hqABxrbirXNhPL+uR3RLORqavtfejOwQviQ
X-ME-Proxy: <xmx:Q_z6ald4lfRMZ8F97vcX40jsFdyBuQe1cVAWDiMkze63k1ZGANOoBA>
    <xmx:Q_z6arAiR-5JRz8tKSQt57ocEogBicWXKU9KjYBD-cAN6UxAbVu4ew>
    <xmx:Q_z6ap59-GHrHSM9ekcLRZO2Ke4y4zR9eSsMk0tQVYUtdcqfKxxDjQ>
    <xmx:Q_z6aozIFfQX_VyIS1ghfM2FQ88Jqveg05wL9rysonZuVC3-93913A>
    <xmx:Q_z6alld4rl4nnZTtfyVcpcFMPnmg5mkODZqXnxJRxiP2mR76b8SXzwQ>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 16 Nov 2026 07:51:14 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Harry Yoo <harry@kernel.org>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Dev Jain <dev.jain@arm.com>,
	Usama Arif <usama.arif@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v3 2/3] mm: page_alloc: make the high-order watermark check honour ALLOC_NOFRAGMENT
Date: Mon, 16 Nov 2026 12:51:00 +0000
Message-ID: <20261116125103.2894162-3-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261116125103.2894162-1-kas@kernel.org>
References: <20261116125103.2894162-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 014F1A0002
X-Rspamd-Server: rspam12
X-Stat-Signature: 8jg5jjo6fhosoxtew417x54pf3xg8kah
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794833481-662751
X-HE-Meta: U2FsdGVkX19VzHLIjufYWqC7kr9n0jci6PvZGjFOozcNU0KFg74QzMUY+BSwgSuSkybVhX9SZ7adkKStkLoph2h+E/iTuo6XW4wXCZgtIE6SrSOZThdfqejwhYHohUxy/TtiDegnBF+8BV7MY0+LGe1SF99tTfFH8EIUzDgEZyJQsFv5+F21H8fxQYjphhgCOuCCr5QJjZG6Wqu77CVn+zN5hjr+RbH397aIkdNWO0WJNrqngGPgschm3lNMuwMQrY75AZfGeHd1jPsR9DT7H6NGVC3HL7y93UP6nlK6nKUaRgXOtmhXk5/iwiUiyLgl7AKMoAtfavOxfNuY3/1ZS1ooQEEmj7U1y5IXdfNf/lZeXq02AJTzVpedcQAYvzJptXL02Dxztc6j9y9cH/PgH5ShwjHbkXACX0K8jHdWV5h/E+Ztwp+DK9EjadFSXO1vbE7B/wGxJsH3kbyGvjjvZUVEGT4fkJV9O5E12rFhuUPaeNw43ye0S1xsVXvP1WGfy2rCJxqBAnOc4U8AYvywzU4c5EDCh9aSlf23TAznnJP4mqIhMDFJqV9w6LlY/ubgBXxviu/bIWPJYKDoNdoVakkjgTmHJdoSwEcUUM4UKtYNniO8YTCGTZDgmR/KzGZDOVjU19Jx5J4gTR8Ejy2ZGSXU8KmLx2Gg6tuPSHrkBL+OF2Rm4YvdNeeAFWmYo/qYOlMxjyMAuYIRwpEjeI0llY6h90Dl8Ny0z7FyAS9ieqpg9WLHlfACnRTiIMEdQs91vlRaqNSGy3wbfBRzBUS0XzOcPMGrnC1wrix72kZ+/Dari6HFSQdWBppIkmt1NXW6HRPWVGyD4kd0tIRXNhCMNTVbIXgrvxXWg1xXIbc806XSBPCqysscXrHFckmwJr0PJqpmog+fAfgxsGTw2OzEeaAJaPlQ4z1ntOW02PJ2luSlxDh6A4ndI7fyuKN+/8eR/rOJO0R5VVOmYWZNv/V
 FCUHwDGa
 tyUD80CGvTTHay6YtyksFIEqbW+HD2nEBp5uIYzlkKJR1z6XNKfvpyBwzVuavCRuQ59IZm10xCvJsxXsodL3q7sjJP0uFagA+oMBAnz2ZULN1foxJSOrGXfD9ygOyeESnTVYSK/F+iT44MurjXATP25PWP+dpxFIu7u9I0pfuFiVsHXrK8yNcOvjXM7IkA+X7KrGuiQnY/hG7ApurUjvj82HJwqjWpqrUcKiZ5RZF2dT/t6SXLLcn26Gjudap8TKKIriAINd6kMs6xGUlmYunR2J3kfivsAYta3tM2V/p+fOssWIQ9zHBhkdmz91zQ8l3fP8OT3ZOWjCkf33/hBVctnJXWPbpxY8ENP3BiJNei2z+z01s+mNbSJWGFe1h0TGD9/AiBMHM8wU/z7HxueGKbgAl4QNM7rd2GCcxCXgQ56zF+5/Y01J76O47oPqbtrw2kbzSCpieIWqgbFC+/3EyyPpypM4ut5T5RUU2JpszpWzHCB7vGf431Hfv83LZi4XnEwDGb9dqKxeyE+g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

With defrag_mode, every slowpath allocation carries ALLOC_NOFRAGMENT.  A
request below pageblock_order may take a page of its own migratetype or
claim a whole free block, but not steal from another migratetype's block.
For a high-order request, the watermark check still accepts a free page
of any migratetype.

Under memory pressure, movable allocations take free movable pages as
soon as reclaim frees them.  Free space in unmovable and reclaimable
pageblocks is off-limits to them under ALLOC_NOFRAGMENT, and builds up.
The free pages of order 4 and up end up mostly in those pageblocks.

A 64K mTHP fault cannot take them, but direct compaction's up-front check
counts them and returns COMPACT_SUCCESS without compacting anything.  The
allocation then fails.  Because compaction "succeeded", it is never
deferred, and every fault stalls in it again before falling back to small
pages.

Dev Jain's benchmark faults 64K mTHPs under swap pressure, in a 7G VM
with only the 64K size enabled.  With defrag_mode, those faults stall in
compaction 18 times as often and get about a third of the folios
(medians of 15 runs):

                              defrag_mode=0  defrag_mode=1  defrag_mode=1
                                                            + this patch
    compact_stall                      1690          30669          2607
    compact_fail                        621          30531           906
    64K faults allocated              20750           7391         11538
    64K faults falling back to 4K       725          13832          9945

Make __zone_watermark_ok_mt() skip other migratetypes' free lists below
pageblock_order for an ALLOC_NOFRAGMENT request.  Give
__compact_finished() the same rule for its fallback test, so that
compaction, once it runs, stops on a page the request can take.

zone_watermark_fast() calls __zone_watermark_ok_mt() too.  With
defrag_mode, an allocation now wakes kswapd and starts reclaim or
compaction as soon as the free lists hold nothing it can take.  For the
orders the per-cpu lists serve, that is earlier than before: the check
does not count their pages, so the allocation no longer uses up the local
list first.  A request that may not wake kswapd or reclaim, such as an
mTHP fault with THP defrag=never, falls back to a smaller folio instead.

Fixes: e3aa7df331bc ("mm: page_alloc: defrag_mode")
Reported-by: Dev Jain <dev.jain@arm.com>
Closes: https://lore.kernel.org/all/4aa14b41-9b89-494c-8825-55fffd5a541c@arm.com/
Tested-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/compaction.c |  5 +++++
 mm/page_alloc.c | 21 ++++++++++++++++++---
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 6c553d0e90f8..7312f7515c53 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -2365,6 +2365,11 @@ static enum compact_result __compact_finished(struct compact_control *cc)
 			!free_area_empty(area, MIGRATE_CMA))
 			return COMPACT_SUCCESS;
 #endif
+		/* An ALLOC_NOFRAGMENT request may only claim a whole block */
+		if ((cc->alloc_flags & ALLOC_NOFRAGMENT) &&
+		    order < pageblock_order)
+			continue;
+
 		/*
 		 * Job done if allocation would steal freepages from
 		 * other migratetype buddy lists.
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 0ebfbbb5d7c5..6e75c03b303b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3587,6 +3587,11 @@ static inline long __zone_watermark_unusable_free(struct zone *z,
  * will return true of the order-0 watermark is reached and there is at least
  * one free page of a suitable size. Checking now avoids taking the zone lock
  * to check in the allocation paths if no pages are free.
+ *
+ * Under ALLOC_NOFRAGMENT, a request below pageblock_order can take another
+ * migratetype's page only by claiming the whole block, so only free pages of
+ * @migratetype count below pageblock_order.  Without ALLOC_NOFRAGMENT,
+ * @migratetype is not used.
  */
 bool __zone_watermark_ok_mt(struct zone *z, unsigned int order,
 			    unsigned long mark, int highest_zoneidx,
@@ -3649,6 +3654,9 @@ bool __zone_watermark_ok_mt(struct zone *z, unsigned int order,
 			continue;
 
 		for (mt = 0; mt < MIGRATE_PCPTYPES; mt++) {
+			if ((alloc_flags & ALLOC_NOFRAGMENT) &&
+			    mt != migratetype && o < pageblock_order)
+				continue;
 			if (!free_area_empty(area, mt))
 				return true;
 		}
@@ -3677,8 +3685,12 @@ bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
 			 int highest_zoneidx, unsigned int alloc_flags,
 			 long free_pages)
 {
+	/* Serving an ALLOC_NOFRAGMENT request needs __zone_watermark_ok_mt() */
+	VM_WARN_ON_ONCE(order && order < pageblock_order &&
+			(alloc_flags & ALLOC_NOFRAGMENT));
 	return __zone_watermark_ok_mt(z, order, mark, highest_zoneidx,
-				      alloc_flags, free_pages, MIGRATE_MOVABLE);
+				      alloc_flags & ~ALLOC_NOFRAGMENT,
+				      free_pages, MIGRATE_MOVABLE);
 }
 
 bool zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
@@ -4693,10 +4705,13 @@ should_reclaim_retry(gfp_t gfp_mask, unsigned order,
 
 		/*
 		 * Would the allocation succeed if we reclaimed all
-		 * reclaimable pages?
+		 * reclaimable pages?  Count free pages of all migratetypes.
+		 * Compaction can then free a whole pageblock for the
+		 * allocation to claim.
 		 */
 		wmark = __zone_watermark_ok(zone, order, min_wmark,
-				ac->highest_zoneidx, alloc_flags, available);
+				ac->highest_zoneidx,
+				alloc_flags & ~ALLOC_NOFRAGMENT, available);
 		trace_reclaim_retry_zone(z, order, reclaimable,
 				available, min_wmark, *no_progress_loops, wmark);
 		if (wmark) {
-- 
2.54.0


