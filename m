Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CA1E1099B34
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:24:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77E916B00D9; Fri, 20 Mar 2026 14:24:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72FB46B00DA; Fri, 20 Mar 2026 14:24:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61FBD6B00DB; Fri, 20 Mar 2026 14:24:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5086B6B00D9
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:24:06 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C9F16160348
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:24:05 +0000 (UTC)
X-FDA: 84567265650.14.F54D9DA
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf16.hostedemail.com (Postfix) with ESMTP id DF094180015
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:24:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kqPwrK7J;
	spf=pass (imf16.hostedemail.com: domain of 3wpC9aQgKCC8ULNVXLYMRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3wpC9aQgKCC8ULNVXLYMRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774031044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LYutBkNzGTjSKKTNrswnBU+hV/hIHGIX2yw2puv+rhw=;
	b=D+5VinDpdEQDC4Gx9veE/X3wbMsMGO3T8dCxEfpq0Phmb6sUxraDLZPn15aZfpPY1ypmdS
	oF2yuwmf0RyT1bjT9TT7aZYaOZZwt4WMEYyHlKgJYP4WQNBtCCAAGwIOn6ldUOajYtjSo3
	NZempduiimziDmCcPSFrMTSg6uUyVl0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774031044; a=rsa-sha256;
	cv=none;
	b=xl0lT9Ty5Ydsnp0jL0QLGWO13KkBhfPmbp7ZBDULF8UIos0MiJ/TWsNzbPBw5Z4BvcPtX+
	TRqPQ+GWd9EWWvgAfHLtc528RaD1FTJ25qaFHBMAoyEfhEnhkdtO8XRnSX2uTovGrPYSFg
	4kspM99WxTWu6UQ04xixmm29wgu7duQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kqPwrK7J;
	spf=pass (imf16.hostedemail.com: domain of 3wpC9aQgKCC8ULNVXLYMRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3wpC9aQgKCC8ULNVXLYMRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-439bab2d095so1319208f8f.3
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:24:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774031042; x=1774635842; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LYutBkNzGTjSKKTNrswnBU+hV/hIHGIX2yw2puv+rhw=;
        b=kqPwrK7JxSbFW7JwQBDhRUcJ9fPD5IDtlDBDsYbfsnefTjOeLk4Fb9RZ8ZU+1vPFCo
         Kp6ycyTD5SbJ2ymdfV6109DBHiW9RnGxzZUp+M1yt04LErTzUPb4Rm39aFTAWFWZOGHa
         3ZxfXwA5iB6mhZkrj2QYGyAiZ6kPzQr8FpoCtxxEH0iqU0b2MFWjHsUMMlUhcuH7D5FB
         pwyJnfBvgLQUdS1ISpF3GH/MmrpTa6FoXRnOZrW2O9CJCeGbOd4fZH9KwZIFhsJnQP4i
         OdqOv8spE/WuOkIch7NOdd33FQipQStZ4OA97c33R3tlV/VfGahBA2nSGp90eLCiOU6S
         3Fig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774031042; x=1774635842;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LYutBkNzGTjSKKTNrswnBU+hV/hIHGIX2yw2puv+rhw=;
        b=mamrqvVDPEeeQrgXTRB3ooHdZxTylH3/0L6sdiDA7TJYdJNXetaVhi0wLDsVqubdiY
         G8HNfLidxVKAlrq7UWg6+7VF8qovGt6lj8VpK6seHBQxPhrCqn2WyYPi28Q2W8PBfBaj
         jQ163V5pYsUEdwPvmDoLGH21ck3/bimtsmTYyioJGHYUAHkKi5FCua/RN6tkjyQn/Qne
         gw37eThYdjzZVVpBjeAv8Nkz7m6QpisB+hCf3Rtqvehy46kBLT3YiHs+dgR82fOEKXsG
         JO3i8tBUA3CbK7y6mLIeukH8ve/fh26chxSgkwG8cTVJ9Ew4d2XqxW3EZQR5D5MeV5Pz
         MuQQ==
X-Gm-Message-State: AOJu0Yy4JQvld4HW4kS6oqVWiDha/xh6esBL0WFAqjwogDbyVQNwC2jI
	TraFhf7Pye4N602bsnmcKDNmEoFfgjUYU/ZqrGEZWBLsBUbqLDhG5QoOSFhZ6TkP9YHI1HPdOZs
	6dPbCdFEMAYHdlA==
X-Received: from wrsy7.prod.google.com ([2002:a5d:4ac7:0:b0:43b:4eb4:e4ea])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:4203:b0:43b:47ee:4586 with SMTP id ffacd0b85a97d-43b642755e8mr6997133f8f.29.1774031042331;
 Fri, 20 Mar 2026 11:24:02 -0700 (PDT)
Date: Fri, 20 Mar 2026 18:23:40 +0000
In-Reply-To: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
Mime-Version: 1.0
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260320-page_alloc-unmapped-v2-16-28bf1bd54f41@google.com>
Subject: [PATCH v2 16/22] mm/page_alloc: separate pcplists by freetype flags
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, derkling@google.com, 
	reijiw@google.com, Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, 
	Brendan Jackman <jackmanb@google.com>, Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DF094180015
X-Stat-Signature: fcxguiihxr4frxsyff3fuf9s3g7qwnd1
X-Rspam-User: 
X-HE-Tag: 1774031043-265191
X-HE-Meta: U2FsdGVkX18i7goJrkuOhxTcOWnPv2dAUhFGz0Pl6yTnkzHyZJhm/GuWW1J1UitY9HJ7kTEMeWI8AzISuu4ghzIiXvloxhcaXWJED45tUnQ5HIafBlTFfN6cHDqHCJICE38WR1vS7oEVySaPRtSrmUbsqC1uxL8N5+r1X+GEgO69+5wgTVezsgx3NjycmrqDrVGNHaKTfqFkycthJWEvPnNthRopPjbXLvzRu62arLscFz5Aks3Qk0+B6yEcCpjS9cpAjpySTuIJCqNSSVPGuCtZulKbTKewlnjapYvcUuUnpM4v5tqQ2SxoKMH5j6SDZ37OdEMLodkS+YgZpx1lOd/71ejSyXENfqqAIgyQ68LjsWf2jGbHKTAJJbYIuPOh16PxEealDjs69GhWzMv9ZUjRJNzph6PxYIOZSExfIfdlu3cs3CyesXPYIz4vyzmos38BFQA7So2HQzyAh6+Ii2IAG7+5QC/6zzur1oDtEAXLb6yrc2VvPqnTt8vEDwZa5yj75/cyN699QUO9jqTAgKexl+mKAcsiPxj5ExJYlp1to+JMgkbOn3Ci7rEQaSx0Cvb+sJqPv73PH0u+gAmY3CaQVi1Ra84XOLpv6yb3DfgSO3CPSgXySW/SHT3vdWl39q9dqHXImvDdX++hAPPklekrGr5q1S/A1pz/xDp7fqD8cgZvGkeghEr+HT+kwuWeeQHcP0EcUuwhFMz3LEcq+Mm31z2qgs8eECwM4dekIBkUmDOw7qDnoWyBRYnuLKv17FSD+fOFhIFbN/c6Pru61NyraaD5kxJB0qYtMFUQTnxL71of6zaFf9STih93yQik/SppE3BZqOfZ6S1e4y5coZyaUhJsRD4jQrAhi79re6UyPrB7OHPAcyke1u1dhnXnHJuYbTvUSuWL3ZS982OvKoQ0wtIsCCpurggy4gipsqZii7S6bc//HfbLDMdma0D7N5DpJEzflD7H7vF/M6F
 aRxX00vO
 cs7ddh//u6aR+iYfoJM38qPMbD+oftUkpeGvezjllHdJ89Rln49DQbdNu9vu6p0FVc8KMpaXEhKuFSYFUbLHDTVfiJe2DfxAlJVCCVwsFU0zmy2GfJ2g2O2xIsa3lFxqpk2Jc/fYD6lPavDQlM2MkAh2c15+f0JnKLKNtCcy5FJqz9l4H8FGR3uvUn3doT78KHFfAy0WJ6zvMp0GBeft/y0fxX3I8XUW8UGFrla31xVeE4oaaI+xPZXxdXox6jlJYcPAYQ3Bm6GtCVIh9DslfRrp2SiSCdhON7RZCULgqf5tkbgGHlKqlLqNDHrDt70NTFcC8IXmbkM1ByCyb0MEeu7BZayhEiR8HZoRPRgM66oRWJLFFTcy0I55u54gPwyM9XRLb/M2Ql6ryrowldgKfTOVR/bFIPkfQKHt+kbCWuZqq+EulalkHaRiMNDDSJb3vIqM16pHw631he1wn9LzBTP0GCq0PZ90PKdymj1DyNE05K3Wvk2rHRrhiGKFUVBkkOuoBXfTcNrw2FPrZfqB8u1tmy9m8wR1DjfDswkbN95hxRmEQAXVMKi1vX2PXNwZFm2K//gCgfEuuYvYQIZUnyYXqfApxNWJJQMkes9RDIw9eIFa5jZLc8lfwrkpu/H9EJZZSLGgzlpwiyjc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The normal freelists are already separated by this flag, so now update
the pcplists accordingly. This follows the most "obvious" design where
__GFP_UNMAPPED is supported at arbitrary orders.

If necessary, it would be possible to avoid the proliferation of
pcplists by restricting orders that can be allocated from them with this
FREETYPE_UNMAPPED.

On the other hand, there's currently no usecase for movable/reclaimable
unmapped memory, and constraining the migratetype doesn't have any
tricky plumbing implications. So, take advantage of that and assume that
FREETYPE_UNMAPPED implies MIGRATE_UNMOVABLE.

Overall, this just takes the existing space of pindices and tacks
another bank on the end. For !THP this is just 4 more lists, with THP
there is a single additional list for hugepages.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 include/linux/mmzone.h | 11 ++++++++++-
 mm/page_alloc.c        | 44 +++++++++++++++++++++++++++++++++-----------
 2 files changed, 43 insertions(+), 12 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index af662e4912591..65efc08152b0c 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -778,8 +778,17 @@ enum zone_watermarks {
 #else
 #define NR_PCP_THP 0
 #endif
+/*
+ * FREETYPE_UNMAPPED can currently only be used with MIGRATE_UNMOVABLE, no for
+ * those there's no need to encode the migratetype in the pindex.
+ */
+#ifdef CONFIG_PAGE_ALLOC_UNMAPPED
+#define NR_UNMAPPED_PCP_LISTS (PAGE_ALLOC_COSTLY_ORDER + 1 + !!NR_PCP_THP)
+#else
+#define NR_UNMAPPED_PCP_LISTS 0
+#endif
 #define NR_LOWORDER_PCP_LISTS (MIGRATE_PCPTYPES * (PAGE_ALLOC_COSTLY_ORDER + 1))
-#define NR_PCP_LISTS (NR_LOWORDER_PCP_LISTS + NR_PCP_THP)
+#define NR_PCP_LISTS (NR_LOWORDER_PCP_LISTS + NR_PCP_THP + NR_UNMAPPED_PCP_LISTS)
 
 /*
  * Flags used in pcp->flags field.
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f125eae790f73..53848312a0c21 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -694,18 +694,30 @@ static void bad_page(struct page *page, const char *reason)
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 }
 
-static inline unsigned int order_to_pindex(int migratetype, int order)
+static inline unsigned int order_to_pindex(freetype_t freetype, int order)
 {
+	int migratetype = free_to_migratetype(freetype);
+
+	VM_BUG_ON(migratetype >= MIGRATE_PCPTYPES);
+	VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER &&
+		(!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) || order != HPAGE_PMD_ORDER));
+
+	/* FREETYPE_UNMAPPED currently always means MIGRATE_UNMOVABLE. */
+	if (freetype_flags(freetype) & FREETYPE_UNMAPPED) {
+		int order_offset = order;
+
+		VM_BUG_ON(migratetype != MIGRATE_UNMOVABLE);
+		if (order > PAGE_ALLOC_COSTLY_ORDER)
+			order_offset = PAGE_ALLOC_COSTLY_ORDER + 1;
+
+		return NR_LOWORDER_PCP_LISTS + NR_PCP_THP + order_offset;
+	}
+
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 		bool movable = migratetype == MIGRATE_MOVABLE;
 
-		if (order > PAGE_ALLOC_COSTLY_ORDER) {
-			VM_BUG_ON(!is_pmd_order(order));
-
+		if (order > PAGE_ALLOC_COSTLY_ORDER)
 			return NR_LOWORDER_PCP_LISTS + movable;
-		}
-	} else {
-		VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
 	}
 
 	return (MIGRATE_PCPTYPES * order) + migratetype;
@@ -713,8 +725,18 @@ static inline unsigned int order_to_pindex(int migratetype, int order)
 
 static inline int pindex_to_order(unsigned int pindex)
 {
-	int order = pindex / MIGRATE_PCPTYPES;
+	unsigned int unmapped_base = NR_LOWORDER_PCP_LISTS + NR_PCP_THP;
+	int order;
 
+	if (pindex >= unmapped_base) {
+		order = pindex - unmapped_base;
+		if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+		    order > PAGE_ALLOC_COSTLY_ORDER)
+			return HPAGE_PMD_ORDER;
+		return order;
+	}
+
+	order = pindex / MIGRATE_PCPTYPES;
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 		if (pindex >= NR_LOWORDER_PCP_LISTS)
 			order = HPAGE_PMD_ORDER;
@@ -2935,7 +2957,7 @@ static bool free_frozen_page_commit(struct zone *zone,
 	 */
 	pcp->alloc_factor >>= 1;
 	__count_vm_events(PGFREE, 1 << order);
-	pindex = order_to_pindex(free_to_migratetype(freetype), order);
+	pindex = order_to_pindex(freetype, order);
 	list_add(&page->pcp_list, &pcp->lists[pindex]);
 	pcp->count += 1 << order;
 
@@ -3452,7 +3474,7 @@ static struct page *rmqueue_pcplist(struct zone *preferred_zone,
 	 * frees.
 	 */
 	pcp->free_count >>= 1;
-	list = &pcp->lists[order_to_pindex(free_to_migratetype(freetype), order)];
+	list = &pcp->lists[order_to_pindex(freetype, order)];
 	page = __rmqueue_pcplist(zone, order, freetype, alloc_flags, pcp, list);
 	pcp_spin_unlock(pcp);
 	if (page) {
@@ -5236,7 +5258,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		goto failed;
 
 	/* Attempt the batch allocation */
-	pcp_list = &pcp->lists[order_to_pindex(free_to_migratetype(ac.freetype), 0)];
+	pcp_list = &pcp->lists[order_to_pindex(ac.freetype, 0)];
 	while (nr_populated < nr_pages) {
 
 		/* Skip existing pages */

-- 
2.51.2


