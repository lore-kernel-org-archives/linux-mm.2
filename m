Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D73ECD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:11:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0BE16B00EE; Wed, 20 May 2026 11:11:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 995016B00F0; Wed, 20 May 2026 11:11:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 881586B00EE; Wed, 20 May 2026 11:11:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 71E3A6B00EE
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:11:35 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F0529140370
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:11:34 +0000 (UTC)
X-FDA: 84788137308.12.4C15D34
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf01.hostedemail.com (Postfix) with ESMTP id 651ED40011
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:11:33 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=Q3g3M3cu;
	spf=pass (imf01.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779289893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2mObITUgdhBLk6YJLrlPC+4yDufeWuD49GNrXgWFp2A=;
	b=3acXb6CdUM+y8qCfdgRnwbe/V1UjPZ3f1zgrYN4nFr1HLTdnXpoPuDxFnLre985cvMFYch
	DYz3J+tUMQ2U+WdfIxK4N1rK+kQu4r7l4bGkiXINdbHE0dOvyd4XRg1anR+9VyWQz2eefP
	COPEY+QF589PrOvJsRilUuHn6vBnhhw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=Q3g3M3cu;
	spf=pass (imf01.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779289893; a=rsa-sha256;
	cv=none;
	b=hwUlSavBt/kPsbneCUp4KakvoOeoZydFzbAd0NfpS0rJZQiLO7nGzThWgVHqw26IOCr34Y
	3yY6F+yWMjoloRL0MCkS2zRHpucmiyAmNykRYLQAj8WGofqb5l0Ba09X3AY3/iz2dIoAL9
	aAG2jOqXaCj86oZiYAPTtudE7vLyFR4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=2mObITUgdhBLk6YJLrlPC+4yDufeWuD49GNrXgWFp2A=; b=Q3g3M3cuLNQOnlx/T4T8wwyvb2
	ZzVgqv5JOIILXSp/eKFOk/t+n2LV8HCzoWneM6SV9jUlF0K+bBTJ5zGPleK3hxVrNP02djh7mObXQ
	hNRI2ePsozXIiHTc5/U9qbJYTGUbzXDTy8sN5U9GxypamHGjPRr8aRdnTVHyl1G0Zl9YIGMZJ5Gn0
	/ve03MW0czNeY8ykz+i1EnkHCiJ4zARSwHKQc306mImNoeFjgEiRYfxvTZbUZ26MLW25bQ9sLTqg7
	abfErKa3EE1LXcOCy5V98g0+bLMo2RhRGnuhPu8I1CHUxJTnFS4xD1GPVLp96gIWOQ6Puwd3bWO0x
	DGLKPhJw==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wPiPM-0000000024Q-1RlE;
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
Subject: [RFC PATCH 12/40] mm: page_alloc: steer movable allocations to fullest clean superpageblocks
Date: Wed, 20 May 2026 10:59:18 -0400
Message-ID: <20260520150018.2491267-13-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520150018.2491267-1-riel@surriel.com>
References: <20260520150018.2491267-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 651ED40011
X-Rspam-User: 
X-Stat-Signature: bobn3mcyn6qoymd16xf8q5g76fjuwis5
X-HE-Tag: 1779289893-813288
X-HE-Meta: U2FsdGVkX1+lLQsr0nky56ryC66aeAwrkHBtPuyw5Fi8RgOH5MpMRgf/0qia7mOODnfRzzzgBLrxM4DMKRNU2MEVJsiQSrBQR7k9eGAxHX8NM6LXCStI8LXV+qiW9mPHIJwyNIHDDbdpu1viNtI5bgDYHudRiLftmjrDmSig1jC15B4b+FCi8mulU5pme9gFECX+57shMs/wtGSLq2Ef/Ce07i3mSRzP3Ts24PD9z627g/oHd5T0lTMm+lX9QPM0vXjN1g0Rm9532psHegw5ZoXh06KT2EBBXW0esP+n8NvumzynBe8I55d6VJTTVBTcafNEAsVqeySH5qe8IO40zmzlb2wh2Uxcplu+7PmbK/NgfioR84oeBGX/E1JeOrBkFjyVr8kp3i+LjFnZkadMcDjijxL9GOvbAhoiBNuZPWv2ODbZ5l4ayiQq1tYz4uarHFUb4Dls5/sLvI30BAU2LNiFLVI7ho7iwTla8cy8CG5M2cO82NsnLCgCY58mUdqH4QkJ6Mp398bnlxTKfqeSe+penXSudQVC+rQRxgCXi+6bLhdrWLi4X3s4SZ910bcYZUU+I59qB75izDI5yTgOciGut6kzagPoSwJR78BN4YMvSfMczVtO30x9bSpNEjLaWyVslAHoQVUIVDK3FZINqlkzoKvBYhBv9AVNJ62Hq5U56b5FlxLTKykizOgh5EcdAGitE9MM7hgOaG83VgysKsiH0f/gO6hBxqGWfFFMvHYpEadFkDR1m3G5RHEFBTWHJpDi3Lt4Bn96VaJbx7e9kXqbJ9gJsSCVF4l/wOtCOXhyqoCYuzrU9m5kcAYH7yumVlPxVPRMap2nHoa37wrZfeqS1vM4Piu/+eWLcnb9e3DklMF4DdHtN4H82WXW4EhcGaRkGZED7dHhGi8keJcCVf7bwNl3kV5RhyYefyTdQX10wKhIKb22F2VPoIKhUbtJ8YzrsQszXa3wLalMh4D
 ALs7ppG9
 0SbRwo17oOZUbk9PeVjxYTxO3CPBXTuaAWfm4z2Q1jPJSPkH1D7HtdLFUUI9PhkFpwMHo/MGhlEhrxtZGvgtiKhhMbDEEeSEhPCDZM+YkcI9u3UAlzwF8MWJk1gaIIclrCowMenvLLgErDQ2B1iQVsWzpZcDPJ1S9MhU6iL0gqy2vztG6g1dtoDGvgPaZAQO3nZI74MbrHRIqA9xZ5ThnubRlPtkD3jjGbvDuysh1YvSsvkHIWvDejPZa7ruimnVBcBHVT/Nyf+fUmzIEQimlbmw5D6SHyeSL1EuDjPJB5o3o6uiICxcYfimkXznDChQRxewu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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

Also fix an ALLOC_NOFRAGMENT propagation oversight in
alloc_pages_bulk_noprof(): the bulk allocator's preferred_zoneref is
computed locally, so it must also call alloc_flags_nofragment() to match
the protection that the single-page fastpath gets via
prepare_alloc_pages(). Without this, bulk folio refills for the page
cache could taint clean SPBs that the single-page path would have left
alone.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 mm/page_alloc.c | 89 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 86 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a17c4cd9a788..9dc65bf93e71 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2330,6 +2330,73 @@ static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags
 /* Bounded scan limit when searching free lists for tainted superpageblock pages */
 #define SPB_SCAN_LIMIT 8
 
+/**
+ * sb_preferred_for_movable - Find the fullest clean superpageblock for movable
+ * @zone: zone to search
+ *
+ * Walk spb_lists[CLEAN] from nearly full toward emptiest -- pack movable
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
+	/* Fall back to empty superpageblocks -- no clean partials available */
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
@@ -3119,12 +3186,26 @@ static bool rmqueue_bulk(struct zone *zone, unsigned int order,
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
 
@@ -5843,6 +5924,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		goto out;
 	gfp = alloc_gfp;
 
+	alloc_flags |= alloc_flags_nofragment(zonelist_zone(ac.preferred_zoneref), gfp);
+
 	/* Find an allowed local zone that meets the low watermark. */
 	z = ac.preferred_zoneref;
 	for_next_zone_zonelist_nodemask(zone, z, ac.highest_zoneidx, ac.nodemask) {
-- 
2.54.0


