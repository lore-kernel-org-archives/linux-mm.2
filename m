Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4463CA5FED
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 02:14:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 268A26B0093; Tue,  6 Oct 2026 22:14:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C9446B0098; Tue,  6 Oct 2026 22:14:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06AAD6B0093; Tue,  6 Oct 2026 22:14:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C37E46B0095
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 22:14:19 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 413CE1203D9
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 02:14:19 +0000 (UTC)
X-FDA: 85294210638.20.82CAD6E
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf12.hostedemail.com (Postfix) with ESMTP id B190D40004
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 02:14:17 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="ihoaRL /";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf12.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791339257;
	b=miyMSnGilqR3L0iFaShB1SKAZZ8xcvoXqzABaDCffW9Yo/e52ALL2ZSiGMfSNzWr/Wa7ub
	FehreSSg76wD1ZIRznvm0SH30+SGq2HrhnFBBMBDv8zTAkP0WGGHSionM2W7YuVQRjJA/t
	UfxXb7cAiw2/H0KHhORIf91M/UHijUA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="ihoaRL /";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf12.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791339257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KKwgm8GYqC75llmIOjDyRDwXwz0fzp2oGMn97550NgY=;
	b=pbJrFay9TDrN1rPtCBB2WihXF2pcOK5gyaGwIh/GPD2kgieInLT+KlrCXBKIIbY2A5P2pb
	4m5CEYYcUFh5S4XZledpqp2lljX+qJmIl7kh4c66Mx4QmUa3N6psGHYFembV5tBXRze7h+
	D5m/hrlQ9I4QAgqQ9D787tYDoeUjKaM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=KKwgm8GYqC75llmIOjDyRDwXwz0fzp2oGMn97550NgY=; b=ihoaRL
	/nvNDCZIENCIKpJn4IOmYiiebYNBOHhRtpChwA46ZrSrYqXSBV3fJDmXg34NghbGsem1rHoACfzQG
	DOoKdkNXOLEj6+AUnRR3IIPs8+X4iYCB8an9HO1iMWEZprooieQsvNteP7EeAK4RED/oTjERwAjUK
	srktbb+uAFAQfsdPySsbyeAZMZmmIyx7HutjWmIX1NSiNRsoC6AfwM2s+Gdl71+6RwkBtM9u9I7Wk
	WHSPnHJjQTHBkZ1+1BMBSfEmpVzs9H4gbqx3+aqqhQbwRee1bCdTqaYPbue8iEF0LgfmT7k08Cpnj
	jzQ1sf+Hi65KiIXtEe+EZJpZP8Yw==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xEH9N-0000000B2cT-02Yo;
	Wed, 07 Oct 2026 02:12:57 +0000
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	linux-mm@kvack.org,
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 3/5] mm/page_alloc: convert any movable pageblock on a non-movable allocation
Date: Tue,  6 Oct 2026 22:12:48 -0400
Message-ID: <20261007021250.1665929-4-riel@surriel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261007021250.1665929-1-riel@surriel.com>
References: <20261007021250.1665929-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rw83eqke3x4r6hmakcnoh61tq61nes4t
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B190D40004
X-HE-Tag: 1791339257-239795
X-HE-Meta: U2FsdGVkX1+qmnC/6eC1kGmJT1/PMHNxIQjBcyLxpZkmfG237mZ0w2MMN+xDmzr26IBnV4IZxTfAw0wU33hmPn4M+uAPOO8YeZU9R/fR+XU+n5ndJPItFwtJ0F8EMvHxFJASISeG2hsvbRSRQRguJjDl9m5j6yES+3ZbEv7I1YthDbX0BZBYeQ6jvmsmFMM7K0PBF+McMLdZ4SHywZmGI/bfimWlOYyrrhzSYfxnqPSHM135j5jtxp0k8fFutxlb98RILnD8jYoIrEhuC1tc8dh27CDbfNNyJXb8qB1CzyWuqlc6SixILqXJgYKW2aGmDDXxev58tNCN3ejBruo6PL+A2vgCqkHPq5Lz7Vrgl8HHEwMjyzmcSrdhZPjxwHM+B8pXK+kl7LOBS0Vais5KdEEqe16YQAgouM9iTWBwPMe2W+Bk3UY8MdbQd8gEyawSm2SYihEX/Jksf2hJQo72hUME/7C9uhAhsfU3xEX7AT00k0vDDmg5+pRuKZxEu6sFl3g6EAUTXaxSLiIJ2sKVjKEiK+GGOmcfUvEyiDRmtQpLpsy3YK960X8D82k65Anrt1TxsJqYdQsVKrsyUnC8VCFG20pyeT3j/BCnEn5hxwlyOLKuHtNDa7wM1V/k2xS6BjWXgOgnvlZ33fh7DCRhxf2sxZxT78bDkdWEKmcBYHPZvRdz+E6oh4n1pDyZqvNsztRN6+1pEmU1t5iyHn/SEDuknYK3iIKJreFct8s62JWv4My8pk3I/4BkB9WZUA8A6YWaCEMOniThmt4GKKJPGUQ57Xv/Vh/LNEXAGU+04mBfRwg9gFrYvM2yI0dtkhY0P+OvCv2f6mFI4Fch+OvGXsQet2f83tEeU4ifSFzBC/gw3TCjiVRnnY4ipD410z0rZEz3q1EQ6Nj4+ycXE0uFj+zzQRB9iTWfSF8CVVu+c61BEdppFE4/qPz3sJT/MHZy3VQ/DmOyisH2SicUpfs
 YQY+896h
 3UDPPBqtfgF9wLiOgma1YKn1kDhWCrSE2aTHVYVxgRyE9xlFVrecXx5NXo0hQDPj/pvfqJZJvYH8/mZmXi2I7+F+EHee8hC+4ufRWzDpsZtPDBQh7tIUEqSF/eF5kLxyMV9lTxmX/G1vNEc7395ScFe227bj1r7LX8SWE/hUbxEyH05bkyJqs3LaRRX22TRaHlTnpzdUyqwtp7KqGY0VNNSuyAPSA/r5uni2Oc7OFcWoPMuu1mNiMIMidVSd5cgzIVxI3QZIrAfEid/KbZJWmxjSroy9DDGP1W3UxsfvIfl8IlCiycYNzgZp5DtFfPZ0+izLyQpuev8dqpfPT4/UEFXPUasN+NOP0oW6hIdMrsgtMvMt8sGy9aOdOag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

try_to_claim_block() converts a movable pageblock for a non-movable
allocation only when half its pages are free or compatible.
Otherwise the steal path takes pages without converting, and
non-movable content sits in a block still typed movable.

Convert a movable block on any non-movable claim, however few of
its pages are free, so the block's type matches the allocation it
serves.

When other pages in the block are freed later, they end up on the
non-movable free lists, directing more non-movable allocations to
the already non-movable page blocks.

Converting a non-movable pageblock to movable is made stricter:
a movable claim takes a non-movable block only when every page
is free or movable.

Blocks straddling a zone edge are never claimed;
zone_spans_pageblock() tests for a block wholly inside its zone.

Assisted-by: LLM
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 include/linux/mmzone.h | 13 ++++++++
 mm/page_alloc.c        | 71 ++++++++++++++++++++----------------------
 2 files changed, 46 insertions(+), 38 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 94f9c3ff54160..81ad83ff69073 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1227,6 +1227,19 @@ static inline bool zone_spans_pfn(const struct zone *zone, unsigned long pfn)
 	return zone->zone_start_pfn <= pfn && pfn < zone_end_pfn(zone);
 }
 
+/*
+ * Whether the pageblock holding @pfn lies wholly inside @zone. Zone
+ * spans are not pageblock-aligned, so the edge pageblocks of a zone
+ * can straddle into the next zone; those never change type.
+ */
+static inline bool zone_spans_pageblock(const struct zone *zone, unsigned long pfn)
+{
+	unsigned long start = pageblock_start_pfn(pfn);
+
+	return zone->zone_start_pfn <= start &&
+	       start + pageblock_nr_pages <= zone_end_pfn(zone);
+}
+
 static inline bool zone_is_initialized(const struct zone *zone)
 {
 	return zone->initialized;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ae38e25971559..9f1520506ae1d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2295,18 +2295,39 @@ find_suitable_fallback(struct free_area *area, unsigned int order,
 }
 
 /*
- * This function implements actual block claiming behaviour. If order is large
- * enough, we can claim the whole pageblock for the requested migratetype. If
- * not, we check the pageblock for constituent pages; if at least half of the
- * pages are free or compatible, we can still claim the whole block, so pages
- * freed in the future will be put on the correct free list.
+ * Whether to retype a partly used block. A block wholly inside its zone
+ * takes the allocation's type, so no non-movable page sits in a
+ * movable-typed block; a straddling block is never retyped.
  */
+static bool should_claim_used_block(struct zone *zone, unsigned long start_pfn,
+				    int start_type, int block_type,
+				    int free_pages, int movable_pages)
+{
+	if (!zone_spans_pageblock(zone, start_pfn))
+		return false;
+
+	if (page_group_by_mobility_disabled)
+		return true;
+
+	/* Convert to movable only if no non-movable pages are present. */
+	if (is_migrate_movable(start_type))
+		return free_pages + movable_pages == pageblock_nr_pages;
+
+	/* Non-movable pages break compaction; claim as non-movable */
+	if (is_migrate_movable(block_type))
+		return true;
+
+	/* Unmovable or reclaimable claiming from the other. */
+	return free_pages >= (1 << (pageblock_order - 1));
+}
+
+/* Convert the block so later frees use the allocation's migratetype. */
 static struct page *
 try_to_claim_block(struct zone *zone, struct page *page,
 		   int current_order, int order, int start_type,
 		   int block_type, unsigned int alloc_flags)
 {
-	int free_pages, movable_pages, alike_pages;
+	int free_pages, movable_pages;
 	unsigned long start_pfn;
 
 	/* Take ownership for orders >= pageblock_order */
@@ -2333,39 +2354,13 @@ try_to_claim_block(struct zone *zone, struct page *page,
 				       &movable_pages))
 		return NULL;
 
-	/*
-	 * Determine how many pages are compatible with our allocation.
-	 * For movable allocation, it's the number of movable pages which
-	 * we just obtained. For other types it's a bit more tricky.
-	 */
-	if (start_type == MIGRATE_MOVABLE) {
-		alike_pages = movable_pages;
-	} else {
-		/*
-		 * If we are falling back a RECLAIMABLE or UNMOVABLE allocation
-		 * to MOVABLE pageblock, consider all non-movable pages as
-		 * compatible. If it's UNMOVABLE falling back to RECLAIMABLE or
-		 * vice versa, be conservative since we can't distinguish the
-		 * exact migratetype of non-movable pages.
-		 */
-		if (block_type == MIGRATE_MOVABLE)
-			alike_pages = pageblock_nr_pages
-						- (free_pages + movable_pages);
-		else
-			alike_pages = 0;
-	}
-	/*
-	 * If a sufficient number of pages in the block are either free or of
-	 * compatible migratability as our allocation, claim the whole block.
-	 */
-	if (free_pages + alike_pages >= (1 << (pageblock_order-1)) ||
-			page_group_by_mobility_disabled) {
-		__move_freepages_block(zone, start_pfn, block_type, start_type);
-		set_pageblock_migratetype(pfn_to_page(start_pfn), start_type);
-		return __rmqueue_smallest(zone, order, start_type);
-	}
+	if (!should_claim_used_block(zone, start_pfn, start_type, block_type,
+				     free_pages, movable_pages))
+		return NULL;
 
-	return NULL;
+	__move_freepages_block(zone, start_pfn, block_type, start_type);
+	set_pageblock_migratetype(pfn_to_page(start_pfn), start_type);
+	return __rmqueue_smallest(zone, order, start_type);
 }
 
 /*
-- 
2.53.0-Meta


