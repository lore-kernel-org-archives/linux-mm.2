Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A37E7CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:02:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8756D6B00C2; Wed, 20 May 2026 11:01:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FEC96B00C3; Wed, 20 May 2026 11:01:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6783A6B00C4; Wed, 20 May 2026 11:01:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 52CF96B00C2
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:01:07 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1DCDB120384
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:01:07 +0000 (UTC)
X-FDA: 84788110974.05.CB5AD12
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1D91616002B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:01:04 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=daREX2O7;
	spf=pass (imf08.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779289265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hC1C9EftDdYJ0I9PlrjUJ9mOTwszjXtUqK9pcRRvRfI=;
	b=u/50edFyARRAi6PSFvGix79UIFRQsvz3wJIbV+fvPD0kckvKMDgoTa4QY7b1AgO/AMHMMt
	wN+J1BuHbfwBWzy3iVsbkm8eudJRRecuUWAz4tTvH3Eob1kvbkNfRzVtL/j3InCygVO3Wf
	wcjNqXGUWplqNCez/FHBiQLV6cIgsn8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=daREX2O7;
	spf=pass (imf08.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779289265; a=rsa-sha256;
	cv=none;
	b=3iIEQiQQ3ORqNYiGNoLsysvVPa0FO7LJCFmTb7fmEWj50g/fz5t6Q/6OHNTA0Yq0oRSJyR
	I8bbLswM0ZsdRfxbzhlySOMqhaFhLqC14D4s/n5Tj5XYQayNRgSWDKrl9yAtFy6vMu8cQt
	6Zbfc4n6NgLZaUqpmBAxz/gTBhbfKe0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=hC1C9EftDdYJ0I9PlrjUJ9mOTwszjXtUqK9pcRRvRfI=; b=daREX2O7uq6uprF4Y/3TP/EAyE
	og/GcXVHMlrQDaIh32Df3Fo/KfstIHCi7DICOvLEtNk5DBqHosBdHHuEHiaqAjQkS7IRpEY678lmw
	vZIFGM45rQFlugo4EgGpfOL8/bWpXCQWWGaiRvcSpr4V18e71SdTQTw7nPpnf79AoSDz3JaapTtQS
	VuG3KQqPSalACFp/KcVMdGQvXG6NW9DsJdqzb2VplxFlfHrcnxxbzRH/Caz3/I3z8ugkbJoUL1CyF
	Sk9OiPA22JZwUYXqbV6BIseTEIgUFoMbQt6OjfVmuIAPAcXPAXzhMpsKabW3Bo3SkWBdjg7Ua7hEz
	FqhAiC1w==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wPiPM-0000000024Q-1XXJ;
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
Subject: [RFC PATCH 13/40] mm: page_alloc: extract claim_whole_block from try_to_claim_block
Date: Wed, 20 May 2026 10:59:19 -0400
Message-ID: <20260520150018.2491267-14-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520150018.2491267-1-riel@surriel.com>
References: <20260520150018.2491267-1-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1D91616002B
X-Stat-Signature: ywb8we9patmizae449s8ep7ts79o8ojs
X-HE-Tag: 1779289264-640259
X-HE-Meta: U2FsdGVkX1+r2m8+DV5cquQDtuAZKVtvjeIY3qLlMN+FFIAXzE/4nxYzEJm8SvVVY+jHr75KLnQZdaQ0njmtifXFLs43FHkI3zow2hInZxUWYitpoyXgIOREkRJz8olsQNFUY0qQM58+YWXkKiKRJRUdcrknszEbE2uvnfYU9hbiWc9LbnwEsvdWFHZ3adbJaxUyxycWURL9eRnXlfM3hD4D6Rf97ONn1rrKKY2RK/RgD34uTaHtLob+UcE5CpaxESzK5ZeDzb5jjfRgUCl6t7zqBXpVK/VE9Bn2gwmMyfeFgIHV/I0eaWMl4cQfpY6AhKfcS32OKSlUCuzQvtDxpCmd3RVtVYAZx4wJolmjQl24iKvjlhxu71VjfzOs1YTjvFxBV997nex3/q0Izo+VaFiFsPPAfF1uxYzbj+X1KVDlvkUCnQ5TG0F9Sfzsr0zIC6cMQG6DPDHq0xiFNXlGYINMWKvoxhbXL1fSDrJ2Ay5tJ+oWirpI40+7o2qE+HviuEf9xsr7JOQSQrsSXD+ezw46zP2VONU2WH5yQL+i+w4+a5tEAAw+GW9KtOSj59wzxghD4j6qOHvyFxsA+1F99/D+AcMFk+UbGDj6Wp0R1WwphumDNvU1ZAHIwI5/Y8edpn9eXXTACC/oCMYhm5JQFagjMykbHn/d6jjvSalPkXv6f4s4s7r/9j1kq0H4Oop0pJZlHpYuHpF24/E2VspCcqdIvuIh1EJwHxYZ62gF+gbzTsLMb2T7PZAmgR44J115p0DwT+eIGFX2wemPCn2ZROtTzVQ7dxrx1Cb3CUqtcr1oBrMPXo6zk3LbSaM3Qpydo3KHTxwb7OOq9QVBkxGps7OH5CIIw6PouV5L50oEtTG9GKhe9oksLY2cNlUnq+s/kxPjdcUZQUHXIKbp7z0qXchJzKsVE5T/JFgg16wGnKKItTzyu1/ZXsYx6YmVAxSMyABRv6Iw9iXb2XEJB7b
 t/F/XkVp
 oa++hk5WKuBrX16Y279TsKX/+cwOl1JLeiV+sC37V0WAGaY7SVt7FMPnayVru56XYGdJWG/rVAJRKIklgjr9Bex28qkubM5jw6YGA+OPf/AdfOwerzk1N5K42dtCmh9X8BgE6DrhwN19Mvwha+lHtsLi24709/zEhjd/gArfYRIqEzqtZ6AD4y02HkYH8oolLy+L603R0IGc4BE2DcOmaukwt6zJtad9j/ilF3cyYGVe3XJIhMOpR8wPvkvF6zrltpP68VP3fqLkPBP8MOJex0oWiYlMDMS32wuXEWLcDRAXcleX/+51/6yRA8ew6AMnkauYT82AC1jjMz8wMScJKiDzPNTYiAVkI2EgI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extract the whole-pageblock claiming logic from try_to_claim_block()
into a standalone claim_whole_block() function. This handles the
PB_all_free → used transition, pageblock migratetype change, and
block splitting for orders >= pageblock_order.

Pure refactoring, no functional change. Prepares for reuse of this
logic in the per-superpageblock free lists patch.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 mm/page_alloc.c | 89 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 55 insertions(+), 34 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9dc65bf93e71..1b619304864a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2750,6 +2750,57 @@ int find_suitable_fallback(struct free_area *area, unsigned int order,
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
@@ -2764,9 +2815,9 @@ try_to_claim_block(struct zone *zone, struct page *page,
 {
 	int free_pages, movable_pages, alike_pages;
 	unsigned long start_pfn;
-	struct superpageblock *sb;
 #ifdef CONFIG_COMPACTION
 	struct page *start_page;
+	struct superpageblock *sb;
 #endif
 
 	/*
@@ -2777,39 +2828,9 @@ try_to_claim_block(struct zone *zone, struct page *page,
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
-		sb = pfn_to_superpageblock(zone, page_to_pfn(page));
-		if (sb)
-			spb_update_list(sb);
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
2.54.0


