Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F623CD13DA
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 20:23:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68BC66B0099; Thu, 30 Apr 2026 16:22:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63ABD6B0096; Thu, 30 Apr 2026 16:22:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D6D36B0096; Thu, 30 Apr 2026 16:22:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 221E46B0096
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:22:58 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C25821A01BD
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:22:57 +0000 (UTC)
X-FDA: 84716345994.06.7A607B7
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf24.hostedemail.com (Postfix) with ESMTP id 21EB218000A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:22:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=P11XhRCO;
	spf=pass (imf24.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777580576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oDRktvTM/qypK4RLJHwBR8Udqq/qtl1o5oc/hIDnT74=;
	b=sP9gfsC5O/z1jJAg1Mv7PRNhUUaA8fO3Vp3GKyG1vEOKQ2sjbKwFg5/ZXSo4EevIZkxkCN
	dBJLU2wknbJYAZyWwAcJf8xi9Ha5td43/QrzOwEfLgW6eFIDvWIfzWg2iJ6G3F4QyXjw+z
	8nI53FeFvwADprO2yqnqZeX/Og1NMog=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=P11XhRCO;
	spf=pass (imf24.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777580576; a=rsa-sha256;
	cv=none;
	b=qp7fmH66j/1jcUUNpoHLK3e55cYQK4PJsVQBPA69XE2XCwbsCCvDkCWJcnOvAxBgxExoj8
	ISm6z9oyoTeWoAG24bie8lLIBd1tOQDZ/sH9Tog9VfRj3iOzAaWlmfcwFe8VO/l+n5tCer
	cvSXohSpWYn5039N/+C0A4t9kArEqz0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=oDRktvTM/qypK4RLJHwBR8Udqq/qtl1o5oc/hIDnT74=; b=P11XhRCOE5PnDPaG5xTDFtCSFh
	DlZx/vQn4T28j3eKgm1TYWaS+Jp28QpC9w7hcFG0m+A5eL7rvwaODim1CcIazRWdHAomkKnBJgpqr
	WEDsSiRPOd9TuqutVv/tI5zRwe/zK00DsnR0XRzbDg7au8UYJsn9o7t8XUeqxRfMr8NrHgo0p48Mi
	7locO8kyZjTakSwPWsLJwGjdnEG3Xnype7eW2qHMfPlajrRE5osTrkQXxvEugX4oRndQFrDeLF+zF
	ZwuYBss6mqIUHRnavvLr3F2h3czrWKUVZWJQnq/A8wnhDy50XrA73snPFT/HOgZz/pvpC8yWXLiJv
	cxjOGezg==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wIXuC-000000001R0-39ZE;
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
	Rik van Riel <riel@meta.com>,
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 14/45] mm: page_alloc: extract claim_whole_block from try_to_claim_block
Date: Thu, 30 Apr 2026 16:20:43 -0400
Message-ID: <20260430202233.111010-15-riel@surriel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260430202233.111010-1-riel@surriel.com>
References: <20260430202233.111010-1-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 21EB218000A
X-Stat-Signature: cbxr4pifz1qphsxp8tukunm73mthwcsn
X-HE-Tag: 1777580575-164293
X-HE-Meta: U2FsdGVkX19wQT9ui+IhJXINjOcs5T7KpGg02D7iz1fglM7zk1hjQ0rYOuSDvMzGbyKldN5k8wvWusVC/h3Jc9c01V5f/jr8k2IBRispkTiR3f8/0rlQgVyjZN3HNttht1xSsBzNFBQKQXJb3ILe3sr2OWyaubUvpQC3nQs8cxWwVCJcNNMdMJOSxIP1H0ZRJ4Jld9dT6RqMmWUA/BwFpqkmoiN77Pg7KOB5wmcqU2K5F7DTgfUCBc2zgOjZ2hnzMFljfNy76zVqd9iWCL7uelgFmothsYkHDMuQgp7BM4pfDCNwMzldf4EGB2988lJkDJ/VvEFXpqNT/TRa5rh13niq/Yrju4Etw9rPkWkGkjvcJcB4S9PNpnZYvBwIM1Gb2PNZAPVifmHTnAfM657yiFSfmha8dPtZSC6HUuuYGpZB99/wr9mUOoqIMbCiN8G8vH8VJuiq/pzrLCgvpZrLGG3Uy0LL0jkpEP0d26rTqrYZzD5yETT9GvqDwd2ZnbDsN5ZjuUJ9ZysOcgrmrF7TCzfOWTdQXAeWnuNUqfP/kfGxi0b7j3LnxSqnBK+gst4T7XjKlgFvAqSfR7kcG9PEFzLElBCtoMNUoBis4LHaYTvrL3P4ATUSMYfeJGyAf+RGApulB0mGcnImn0dhPla+siHTleFzTr3yjD9tChYHzxODA7x90oufdiCuefNB6LSYLTjngGgmj7kpWAm2tUMAkAkyfUVFVJYmlnW9ySlaxILsTzw0Hx7wRruRtVYlWWm6BGCOd+EkYoG9tx2V0aaOr0OqjVXCEXxet7NPNmW4jKuHl8J0CP2mB6Ew24Z22Pb8s+Iu31RI/CTxrzz9M5FtMFymG3juSqMD7b9P4btRVX7WSpRnbFML8n3umyu7l2tLCzUSFNikHs9FG9sKGQ4nfQqRQUXTl85E9X6F06t/TSUGnhsV8UreD28CCNkERZ4jFyReALypQu8PiO8m0TE
 h4ueJ+US
 6nsCzIiJ4pR9oAiH7ATUJNaqzUDT4KSBuvYxMb667nJPK9fXqHpr13vvntApeOJAi/QFQ7QvCxD4GmV5ipX3Bkabv+B8a2Sw0wwBa19sD/zWiilFkCWTBEPMOgIsaUVqgmvn4FwlzS6BGbHJlNhBGSRBipbSkCOBIwC+XK6WCJADx+zXzRi3coWHes0NeOwZ1alswegrM7PJpJdiia00PY2AHbey4p84+UskzEZGZT5a/SPhfe49Uk7mGgl9nMv7ySYUAr/mW+DSkkJvpjmcqetr8Ig6WTHRpGBRFDPtiWYY5EGt6ir6Btheu3A03Kgdxcz53Pa/oPmosS8dRyv0iOX1THg4KuRgNrg2gXU1YU4usalAoTEQXU1Msenvww3W1omgcb5HxD3oVsyQNzCxk9CkDaKwBQw4j37tZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rik van Riel <riel@meta.com>

Extract the whole-pageblock claiming logic from try_to_claim_block()
into a standalone claim_whole_block() function. This handles the
PB_all_free → used transition, pageblock migratetype change, and
block splitting for orders >= pageblock_order.

Pure refactoring, no functional change. Prepares for reuse of this
logic in the per-superpageblock free lists patch.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 mm/page_alloc.c | 90 +++++++++++++++++++++++++++++--------------------
 1 file changed, 54 insertions(+), 36 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8b10322d5221..907ce46c060f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2731,6 +2731,57 @@ int find_suitable_fallback(struct free_area *area, unsigned int order,
 	return -1;
 }
 
+/*
+ * claim_whole_block - claim a free block (>= pageblock_order) for a new type
+ * @zone: zone containing the page
+ * @page: free page to claim
+ * @current_order: order of the free page
+ * @order: requested allocation order
+ * @new_type: migratetype to assign
+ * @old_type: current migratetype of the block (for free list removal)
+ *
+ * Handle the PB_all_free → used transition, change the pageblock
+ * migratetype, split the block down to @order, and return the page.
+ */
+static struct page *
+claim_whole_block(struct zone *zone, struct page *page,
+		  int current_order, int order, int new_type, int old_type)
+{
+	struct superpageblock *sb;
+	unsigned int nr_added;
+	unsigned long pb_pfn;
+
+	VM_WARN_ON_ONCE(current_order < order);
+
+	/*
+	 * Clear PB_all_free for pageblocks being claimed.
+	 * This path bypasses page_del_and_expand(), so we
+	 * must handle the free→used transition here.
+	 */
+	for (pb_pfn = page_to_pfn(page);
+	     pb_pfn < page_to_pfn(page) + (1 << current_order);
+	     pb_pfn += pageblock_nr_pages) {
+		struct page *pb_page = pfn_to_page(pb_pfn);
+
+		if (get_pfnblock_bit(pb_page, pb_pfn, PB_all_free)) {
+			clear_pfnblock_bit(pb_page, pb_pfn, PB_all_free);
+			superpageblock_pb_now_used(pb_page);
+		}
+		__spb_set_has_type(pb_page, new_type);
+	}
+
+	del_page_from_free_list(page, zone, current_order, old_type);
+	change_pageblock_range(page, current_order, new_type);
+	nr_added = expand(zone, page, order, current_order, new_type);
+	account_freepages(zone, nr_added, new_type);
+
+	/* Single list update after all pageblocks processed */
+	sb = pfn_to_superpageblock(zone, page_to_pfn(page));
+	if (sb)
+		spb_update_list(sb);
+	return page;
+}
+
 /*
  * This function implements actual block claiming behaviour. If order is large
  * enough, we can claim the whole pageblock for the requested migratetype. If
@@ -2754,42 +2805,9 @@ try_to_claim_block(struct zone *zone, struct page *page,
 		return NULL;
 
 	/* Take ownership for orders >= pageblock_order */
-	if (current_order >= pageblock_order) {
-		unsigned int nr_added;
-		unsigned long pb_pfn;
-
-		/*
-		 * Clear PB_all_free for pageblocks being claimed.
-		 * This path bypasses page_del_and_expand(), so we
-		 * must handle the free→used transition here.
-		 * Use block_type (the original migratetype) because
-		 * that's what was decremented when PB_all_free was set.
-		 */
-		for (pb_pfn = page_to_pfn(page);
-		     pb_pfn < page_to_pfn(page) + (1 << current_order);
-		     pb_pfn += pageblock_nr_pages) {
-			struct page *pb_page = pfn_to_page(pb_pfn);
-
-			if (get_pfnblock_bit(pb_page, pb_pfn, PB_all_free)) {
-				clear_pfnblock_bit(pb_page, pb_pfn, PB_all_free);
-				superpageblock_pb_now_used(pb_page);
-			}
-			__spb_set_has_type(pb_page, start_type);
-		}
-		/* Single list update after all pageblocks processed */
-		{
-			struct superpageblock *sb =
-				pfn_to_superpageblock(zone, page_to_pfn(page));
-			if (sb)
-				spb_update_list(sb);
-		}
-
-		del_page_from_free_list(page, zone, current_order, block_type);
-		change_pageblock_range(page, current_order, start_type);
-		nr_added = expand(zone, page, order, current_order, start_type);
-		account_freepages(zone, nr_added, start_type);
-		return page;
-	}
+	if (current_order >= pageblock_order)
+		return claim_whole_block(zone, page, current_order, order,
+					start_type, block_type);
 
 	/* moving whole block can fail due to zone boundary conditions */
 	if (!prep_move_freepages_block(zone, page, &start_pfn, &free_pages,
-- 
2.52.0


