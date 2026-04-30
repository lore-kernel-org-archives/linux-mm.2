Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEDBECD13DA
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 20:23:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FE876B008A; Thu, 30 Apr 2026 16:22:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85FB06B0099; Thu, 30 Apr 2026 16:22:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FFE06B0098; Thu, 30 Apr 2026 16:22:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 55CAD6B008A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:22:57 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0B1681C020E
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:22:57 +0000 (UTC)
X-FDA: 84716345994.05.2619186
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf12.hostedemail.com (Postfix) with ESMTP id 673D04000E
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:22:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=e3CrL9iD;
	spf=pass (imf12.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777580575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jOC1UcN2vB0f4nIEYXZrKqkAXItZ6UqjP2wIrP5lxyo=;
	b=qGXGe5ds54QuLRmTBGlZ9XQvfjxJN8GGVwPyqkFpLCxJk12APmA9fPPIZRy8rripM8Ufdm
	hByict9rox5+JyUqj19yHfMBtB6OieG4t4BpDdvia8WW9xw2HgWdYzL5ShV9ePxguhbspS
	HedEHxriX87BNULCrBJoc2TR4iNHLPE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777580575; a=rsa-sha256;
	cv=none;
	b=ftDpxBhDIcM9TB3ZC8XDbP+bT/nSroVSAmQpcdfwW5xLDbvFikNrVtCZI4g45JDWOuY2xO
	ufOtO6mNgCDABWNhFafk2Yk4DxQSfyTaBlyt4O9poVT7Urcept1lUJCMhc9rFi4Z3V8r/6
	pxUc8p4m8vPJcd2w0ITsGBEzdzP4k1o=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=e3CrL9iD;
	spf=pass (imf12.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=jOC1UcN2vB0f4nIEYXZrKqkAXItZ6UqjP2wIrP5lxyo=; b=e3CrL9iDJQg3bLDxlljFIap7BW
	lZn3RrRMDEbMo8qCk+uSIdThugVMdFC65V8s1bsA7c8pv56Uw6Lykf8hFEQYLOQwrtGTB9DjpjWbc
	//IgIgPihUEM2B12OVjmFyIfTmAa8P16GeW85rhJal+dQrrhb8nIzY6AshJD4yYa9KfU5dXhqngAw
	cX0lF6+6luu9Ib9QmqXcBBMEuaporryobehBMWvyyZ8EOcXMxyP6+eqnw4B4CYe17xcQ3u89Aa8wl
	Saa/PDPYhymRd0vrEbAP5sWINvaQY2xF0Wkq/lTzsBlpqg/QbVFaF1nTD+WRVG022KDOnC8/QbdxZ
	7n3/Ikag==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wIXuC-000000001R0-34Ae;
	Thu, 30 Apr 2026 16:22:40 -0400
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
	Rik van Riel <riel@fb.com>,
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 13/45] mm: page_alloc: steer movable allocations to fullest clean superpageblocks
Date: Thu, 30 Apr 2026 16:20:42 -0400
Message-ID: <20260430202233.111010-14-riel@surriel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260430202233.111010-1-riel@surriel.com>
References: <20260430202233.111010-1-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 673D04000E
X-Stat-Signature: zc9gm5bc37hbgeb4axq6t85beai84gpc
X-Rspam-User: 
X-HE-Tag: 1777580575-17690
X-HE-Meta: U2FsdGVkX19QDpd5V6nV4AYNtZWRlM84wwCP9WYKhvtq9qXdDfVNyk8bCr9QlCPwBDL3qXg8LmXrDbg3aAjfzniUPlr7sd3x91UhVEUy7twnEnoN0czMLiJHxE9UmL1rqZwAzVusmS84QZahNSbKyD1/47E3DCyQzXEk2W9R/uTIyMMOjtQTaUmi0SaAYcZtMRiZoYZ/a8ri4RWuWaHt0UFQIUY7q5avPA0CTOVIX6qZoUlUlpU5S4Mvi9A010XgWy++6b+P9LFqYjB1LXvO0nyy6EVhNBooWxbaDfNesHO4ExGxH36J2ItvRYw/BUOfM6EOrJ2UVpTKezEo2XKVZHSAYo5Cn/nCjHL1YtUIceyzK2gXEgPqykbgnGE2GziIKWmbHestygTIDR3Puuu/zt/TPkpvFGo/1Ad/z4UzbpNHa/F7zlmZlK454YH22CH5AafSM2K1STposFy7dV6Z1ZKtFbdZowdo9scH46Lj9X4fdCp2Ljt1/2bAlJKIynrJthX3RrmAQEnsidZ6Wrk1g1UQgnGBrSp0T2Oly4DlRr1FX770iARM2J5bgDJEXQIjsJx7DfssF/lxzjvpiacrWhFzjpjFAFdKGZAO38OCObJ3NQkmmqnCnNqQk9h12h2kjwPIGg4FFxfQoU1neFmCu/pSJ8zJaRWm8uZkXJIhzoPkxqyFucOUJor8pQQV+7byUKA3cUJpPb8YFtrGTnoIZsyS/ZHYk3y96JXREQOpP7BnAXma74YOzZF1dfJOdGdtt/2OU20H1Jtlax+FP7JegEhmWfpGVXFkcfo4ExGz8vThiErU3veNHekHwLkNXYXNXvC5c+r7WQm9v+nHGaCl8t1VexpmGQQ25WvDRU7uKxEmCZbrU859vFJYKnHlwb+7ufZK2lgAQDj4IejFFCz6WFS7QAZmvc5R13yfGgDJqm+BE2SWvM4nuilV1Z2sT2lcDQ1xcf27aTD/gcVwN+/
 trZWS4pQ
 7zIOSe/A88vAWLT+Zd+Zqb1ulIQ5DM2vN+lho2Y39IMaDdnbhHu5Y5tPjDH50t6J+S/bpUR40tEm1Hx10NITnaDWGrsgy9oHvK2f1fipw6xLCs1Fz6BqW7qBMBSktMBWDqUqoYfoeQVZzabqAfnKiJ5L448iUvihWbx2ZwRQK3gAXnm7XYRIChQ2+upwsxIL+UGVoTyOuS72JdTdXM0K1iJiwC+QqQvkIaSewzBEJqbHPq6W7aHzfmQpLtMPn8yZRttU96DVLbD/AotQT+aSxsL3k8G1TgBYmAdK58vm75rjCpgGtwfZ1PZvsD+PlgVZZXdGmrTFKI3XdxN/Bi//GunnTbLd/wflHtg0FgkZADuXfvSATYvwUpliKqGUvB9YxQ/v2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rik van Riel <riel@fb.com>

When refilling PCP with whole pageblocks for movable allocations, prefer
pageblocks from the fullest clean (only free + movable) superpageblock.
This packs movable allocations into already-partial superpageblocks,
preserving empty superpageblocks for potential 1GB hugepage allocation.

Add sb_preferred_for_movable() which walks the clean superpageblock lists
from SB_FULL toward SB_ALMOST_EMPTY to find the fullest clean
superpageblock with available free pageblocks. Add __rmqueue_from_sb()
which scans the buddy free list for a page within a specific
superpageblock's PFN range, with a bounded scan limit (8 entries) to avoid
excessive latency.

Hook into rmqueue_bulk() phase 1 (whole pageblock grab for PCP refill) to
try the preferred superpageblock before falling back to the normal
__rmqueue() path. This is the primary steering point for movable
allocations without per-superpageblock free lists.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 mm/page_alloc.c | 89 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 86 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d795f41975c1..8b10322d5221 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2311,6 +2311,73 @@ static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags
 /* Bounded scan limit when searching free lists for tainted superpageblock pages */
 #define SPB_SCAN_LIMIT 8
 
+/**
+ * sb_preferred_for_movable - Find the fullest clean superpageblock for movable
+ * @zone: zone to search
+ *
+ * Walk spb_lists[CLEAN] from nearly full toward emptiest — pack movable
+ * allocations into already-partial superpageblocks before starting new ones.
+ * Skip SB_FULL since those have no free pageblocks.
+ * Returns NULL if no suitable superpageblock found.
+ */
+static struct superpageblock *sb_preferred_for_movable(struct zone *zone)
+{
+	int full;
+	struct superpageblock *sb;
+
+	for (full = SB_FULL_75; full < __NR_SB_FULLNESS; full++) {
+		list_for_each_entry(sb, &zone->spb_lists[SB_CLEAN][full], list) {
+			if (sb->nr_free)
+				return sb;
+		}
+	}
+	/* Fall back to empty superpageblocks — no clean partials available */
+	return NULL;
+}
+
+/**
+ * __rmqueue_from_sb - Try to allocate a page from a specific superpageblock
+ * @zone: zone to allocate from
+ * @order: allocation order
+ * @migratetype: type to allocate
+ * @sb: preferred superpageblock
+ *
+ * Scan the free list at the given order for a page within the superpageblock's
+ * PFN range. Bounded scan to avoid excessive latency. Returns NULL if
+ * no suitable page found.
+ */
+static struct page *__rmqueue_from_sb(struct zone *zone, unsigned int order,
+				      int migratetype, struct superpageblock *sb)
+{
+	unsigned int current_order;
+	unsigned long sb_start = sb->start_pfn;
+	unsigned long sb_end = sb_start + (1UL << SUPERPAGEBLOCK_ORDER);
+	struct free_area *area;
+	struct page *page;
+	int scanned;
+
+	for (current_order = order; current_order < NR_PAGE_ORDERS;
+	     ++current_order) {
+		area = &zone->free_area[current_order];
+		scanned = 0;
+
+		list_for_each_entry(page, &area->free_list[migratetype],
+				    buddy_list) {
+			unsigned long pfn = page_to_pfn(page);
+
+			if (pfn >= sb_start && pfn < sb_end) {
+				page_del_and_expand(zone, page, order,
+						    current_order,
+						    migratetype);
+				return page;
+			}
+			if (++scanned >= SPB_SCAN_LIMIT)
+				break;
+		}
+	}
+	return NULL;
+}
+
 /*
  * Go through the free lists for the given migratetype and remove
  * the smallest available page from the freelists
@@ -3103,12 +3170,26 @@ static bool rmqueue_bulk(struct zone *zone, unsigned int order,
 	 * small zones, pages_needed can be less than a whole
 	 * pageblock; skip to smaller blocks or individual pages to
 	 * avoid overshooting the PCP high watermark.
+	 *
+	 * For movable allocations, prefer pageblocks from the
+	 * fullest clean superpageblock to pack allocations and
+	 * preserve empty superpageblocks for 1GB hugepages.
 	 */
 	while (refilled + pageblock_nr_pages <= pages_needed) {
-		struct page *page;
+		struct page *page = NULL;
 
-		page = __rmqueue(zone, pageblock_order,
-				 migratetype, alloc_flags, &rmqm);
+		if (migratetype == MIGRATE_MOVABLE) {
+			struct superpageblock *sb;
+
+			sb = sb_preferred_for_movable(zone);
+			if (sb)
+				page = __rmqueue_from_sb(zone, pageblock_order,
+							 migratetype, sb);
+		}
+		if (!page)
+			page = __rmqueue(zone, pageblock_order,
+					 migratetype,
+					 alloc_flags, &rmqm);
 		if (!page)
 			break;
 
@@ -5738,6 +5819,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		goto out;
 	gfp = alloc_gfp;
 
+	alloc_flags |= alloc_flags_nofragment(zonelist_zone(ac.preferred_zoneref), gfp);
+
 	/* Find an allowed local zone that meets the low watermark. */
 	z = ac.preferred_zoneref;
 	for_next_zone_zonelist_nodemask(zone, z, ac.highest_zoneidx, ac.nodemask) {
-- 
2.52.0


