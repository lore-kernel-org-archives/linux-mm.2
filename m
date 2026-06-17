Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F87CCD98ED
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 23:50:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29BAE6B0088; Wed, 17 Jun 2026 19:50:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24DB86B008A; Wed, 17 Jun 2026 19:50:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13E406B008C; Wed, 17 Jun 2026 19:50:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E28CF6B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 19:50:44 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6B6BA140584
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 23:50:44 +0000 (UTC)
X-FDA: 84891052008.27.601F64A
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf12.hostedemail.com (Postfix) with ESMTP id 358C74000B
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 23:50:42 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dTNDqQV3;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781740243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=V392dgNrreKWRUX2gW92j7T05f3F52/5QW2Ks5cjS98=;
	b=ljeMNn9Z9d3wkR+V+v37xAwcwLmxNfx5YXLzGotO6jutqjEccsm2PlgmFp2VHot9hU7sei
	Q9vFjI9gwWE7ekv4Kod+Nl9FZh0wHniL1roEv1Jg+1DiLm8BgJnuqZjWtgmI6S7qwbgupB
	4R1138DD0YVPS7UzeU5st0TMXt975l8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dTNDqQV3;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781740243;
	b=4EFj3kLQdV8WvL12uoE4kgrJCLiSOzXLIlZAFinykMZBDuysGPRa23wBdll7os01QRHhEQ
	KkJ/Gt0KL8y+ya8orR7TtraUwppcWj2qn9ChJM3N6O+czXP57Bh3TbjmhfYaT9UrSpsTWD
	hP1nivr7P2rDKCHIL9Fb33KckbF/f9I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781740239;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=V392dgNrreKWRUX2gW92j7T05f3F52/5QW2Ks5cjS98=;
	b=dTNDqQV3+Wy9fH4pp0rek+kRPjNzftVAX+LCmetX7LddRZ4Fk2phpAkfpVXusH3xGg3A3c
	XME8MYJJwUWuDv/rYFYIuzkeD/K42uyJGh8JWUDXXz2TSUMyUsQYcLu8E+O3Z3sg3mxrUH
	IvJxKF6CV+PU9aE0MYjdpVRsd10fL/k=
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
Subject: [PATCH v2] mm/page_alloc: use existing highatomic reserves on the buddy fastpath
Date: Wed, 17 Jun 2026 16:49:58 -0700
Message-ID: <20260617234958.150339-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 358C74000B
X-Stat-Signature: g7sjp5xxi35escgdb4geett4wu5r3shw
X-HE-Tag: 1781740242-987559
X-HE-Meta: U2FsdGVkX190iu7sFbVmvfYH/HFNo/j5z3VKHVM6p9WrQE1bFmg5+H3GQfNnJdjGa4roHn46PtpginFBbeEVSPlYyHPgf6GvM9SiB34y3MKm46uXvjXS71qXxNeuP1BzlzE08VeCNyLKk7DeEF+B0V6O8NgqQ3nIDHY3b9erkPur0sYbyc0E8sckldOVdO7XnpW6ypLL6hoDTYv8F+lyucsWT/M4stl3I8QQ0qqgrA4B6T3CtJmTJsDiBsfNZ2iedtlmtKWhYMyGbMCqIoRr6b8TxRUM50gWmU2ykmNtkxK04Y0KqLI2QEyrX/+FIHMgFgHFWrpwSwMc9qCx43HT+WBCFQBy6mUjLyqTbrP6jdXbHjBGC2ZSWmR8qD9RNXllhNbGUpJZtHt3H8CTj3IrfKUpdkXq4GoQW2AgiqO8B+LpN2e1D5gV+LkBS3osjNFqBBZ4it4HsOEzCGZhqO1KcYwbkhByaysXMdma7S1PLSxR+8URz3CPnRhASI2ubOCZGAMm4X0HV5KY4h27v3PJfmnFU8BscsAnxfrW1XoEYtrSOXXDLL0bdQ1CDM/Y0iqWkit52g1wQh6k4/i3iJVW3OzvGKP3HNiEQWbD3d08N25YAnlTQTP8GCdmT/vpYQjBLaeJWy/VGwInorP66Dp8o3Ot02CNGilf8zHf5L7Gx0DE7U7rwnsvgOLWlpVDwFNWT8VR9CzyIsT/h+XeWu0jV2nRU4oTsi4OuN2eG/KOh94C4OfZrpIVXn+3AmkhzxLnbh86xRM8k4Rp2q6K5LoMf2e5WVpQBuSgu83c1xo4EBkmAIaqUpCrGgL2QRJt/D3dhGCfJ9wyFBN6KlybPE1A6XWTJGX4T/i9yvsS/aa27wHhi/aDkBuubUGrT/Kdfxjzdd0urrLWuXHfDrQv319eYR2X7pmmyre+un+MJh38fdpFp82Irn4b88c8ZTMeOeqAz1zuvZ+9GuvFD0QgxXZ
 FW18nm7K
 rigIo+jjp0scY1ToFlEMQ1FFL5urhysAZmueZuu+0CKHNwsgHzCfNchMpWV6qnklAiXwrNyIqbOmOnzpe0TuVUt5zXThv0nFCHbqV1duz2l2UE/bchKlPr6g1tBTedEDQhM6R+Xqhp/LLwk6wEVGrrrDRBV/u9PEKcsZuKaeI+ELPDLdfuU78kwTOX1V5VYUPRQ0XZI5AKo4PmthNbkkeQOAXp5MFGgisdDAYqKJePUWmMTiK0o/jOC2gn8BnKFUAzBgYLZnwu5flZtnI32NVOTuAQw==
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
fastpath. Change the semantics of ALLOC_HIGHATOMIC so that it only allows
access to the reserves without permission to grow them. Add a new flag
ALLOC_HIGHATOMIC_RESERVE that specifically allows growing the reserves.

A UDP receive workload was run with free MIGRATE_HIGHATOMIC pageblocks
available in the target zone. Before this patch, the workload did not
consume these blocks. With this patch, eligible order-1 allocations
reaching the buddy path consumed existing MIGRATE_HIGHATOMIC pageblocks,
with no highatomic misses observed. The workload did not grow highatomic
reserves and NAPI page-frag allocations remained healthy with no failures
or order-0 fallbacks.

Signed-off-by: JP Kobryn <jp.kobryn@linux.dev>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
v2:
  - decouple use semantics from ALLOC_HIGHATOMIC_RESERVE
  - update changelog to reflect above change and reword test paragraph
  - adjust comment in PCP path
  - rebase onto Linus' tree ~v7.2-rc1

v1: https://lore.kernel.org/linux-mm/20260616191420.52556-1-jp.kobryn@linux.dev/

 mm/internal.h   |  1 +
 mm/page_alloc.c | 30 +++++++++++++++++++++++++-----
 2 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 5a2ddcf68e0b..6700659615e8 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1478,6 +1478,7 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 #define ALLOC_HIGHATOMIC	0x200 /* Allows access to MIGRATE_HIGHATOMIC */
 #define ALLOC_TRYLOCK		0x400 /* Only use spin_trylock in allocation path */
 #define ALLOC_KSWAPD		0x800 /* allow waking of kswapd, __GFP_KSWAPD_RECLAIM set */
+#define ALLOC_HIGHATOMIC_RESERVE	0x1000 /* Allows growing MIGRATE_HIGHATOMIC reserves */
 
 /* Flags that allow allocations below the min watermark. */
 #define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d49c254174da..ed919e2ac99a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3238,7 +3238,7 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 	 * If this is a high-order atomic allocation then check
 	 * if the pageblock should be reserved for the future
 	 */
-	if (unlikely(alloc_flags & ALLOC_HIGHATOMIC))
+	if (unlikely(alloc_flags & ALLOC_HIGHATOMIC_RESERVE))
 		reserve_highatomic_pageblock(page, order, zone);
 
 	__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
@@ -3320,8 +3320,9 @@ struct page *__rmqueue_pcplist(struct zone *zone, unsigned int order,
 			 *
 			 * Instead, direct it towards the reserves by
 			 * returning NULL, which will make the caller fall
-			 * back to rmqueue_buddy. This will try to use the
-			 * reserves first and grow them if needed.
+			 * back to rmqueue_buddy. There it will try to use
+			 * the reserves first and grow them if needed and
+			 * permitted by the ALLOC_HIGHATOMIC_RESERVE flag.
 			 */
 			if (alloc_flags & ALLOC_HIGHATOMIC)
 				return NULL;
@@ -3768,6 +3769,24 @@ alloc_flags_nofragment(struct zone *zone, gfp_t gfp_mask)
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
@@ -4495,7 +4514,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask, unsigned int order)
 			alloc_flags |= ALLOC_NON_BLOCK;
 
 			if (order > 0 && (alloc_flags & ALLOC_MIN_RESERVE))
-				alloc_flags |= ALLOC_HIGHATOMIC;
+				alloc_flags |= (ALLOC_HIGHATOMIC | ALLOC_HIGHATOMIC_RESERVE);
 		}
 
 		/*
@@ -5215,7 +5234,8 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
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


