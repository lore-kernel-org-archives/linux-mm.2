Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C270CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 14:29:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B40BC8E0011; Wed, 10 Sep 2025 10:29:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF1718E0003; Wed, 10 Sep 2025 10:29:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A07598E0011; Wed, 10 Sep 2025 10:29:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8E8A88E0003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 10:29:28 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 17CC911B05E
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:29:28 +0000 (UTC)
X-FDA: 83873573616.27.E630315
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2828FC000B
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:29:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=CRI3lzZi
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757514566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sn3ZiFBP5Eoi7oxhin88CuMlHzsJKR/vHa4PFQklVkU=;
	b=0ie8/nC/7hCYoKLnA3MuDxwC00shrJwn4VTt5PgLGWSmISIrHpunKG5/3DZxxAbMxdgolt
	mSSWQutrBjrkl0E/NHqrraavElmRI6DoT6FHSlgY6bJusFJPCU95wjFke56ltggjPxVJte
	7GzXUUuyWgPuZoAvxEMvWZ/AQx2CD1M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757514566; a=rsa-sha256;
	cv=none;
	b=Q2EhrXLMHX2a6jjcawRaDA0EUNhqEav9mU6Y7/tA3c+fuN+CKnPOLdL/dwd1phAy/HlHPH
	niN4B1qO3L66FRCbpvSuOhjcPmUiMwtjnkLLa7IWAfAAhYNuePpzgbJB/+VfULgVcpZPza
	A18ZDPzSKaSWJfWs3hnstHVt5nywha0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=CRI3lzZi;
	spf=none (imf28.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=Sn3ZiFBP5Eoi7oxhin88CuMlHzsJKR/vHa4PFQklVkU=; b=CRI3lzZiZBdWbQIgZ2wOzpXRHN
	qlXpLgimJXLuxRQtZHtGIvDm9nG3KgyG6M/JPmhorsh6A4kcCdYbQhDRqPISwoNieTb34Qt4p73JS
	Bz5S46ZRdRuT1pIto+haHWTOW6bZrwhKnb9fVz2trhbEUmht2WImS2PWkK91Wl5mQSt/zmZhOUzs+
	OolD593PoVhhVirRvS27JRbM7OjR456/JQec99RHQ4O9TUDgGMvNvj2xnxc46+/ceMZAOGBBb17yZ
	bS6aDEa6GFUxRh2ie4XNeANWyexDBJWt80pfp2+L6FcSgXxDtTU4OAi9CoHNR6CvF/LyXSs77ugLd
	24wNoA7w==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uwLp6-0000000ALQX-238o;
	Wed, 10 Sep 2025 14:29:24 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-mm@kvack.org,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 3/3] mm: Remove page->order
Date: Wed, 10 Sep 2025 15:29:19 +0100
Message-ID: <20250910142923.2465470-4-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910142923.2465470-1-willy@infradead.org>
References: <20250910142923.2465470-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2828FC000B
X-Stat-Signature: 1pshqw7auygzsrwk8ugkqp83js9r1zpf
X-Rspam-User: 
X-HE-Tag: 1757514565-956583
X-HE-Meta: U2FsdGVkX1+FQqQtV7XjgQtGWIzr9ziIQeMzgrSYkNxJv8WYUKkIPR5V7ftCBQamQYpxFHtoc2KxalsyKoWV7N/rsZOV+591DuOkR9owP+lgdkmDOlc2UnMHQ+u/mxBvtdA6KpPQvQNI8Hdlk3AiS+6OpuQ0vTsOd8j9YKdkBEVLWeIwBExF4OZALyUQRoe0hqW3dq/zqs8tJTt1DFZh6lwkeAV7sfcHfFedTW6Fm1z7edsuPFRhntRM/D3x94KvbV99lQ5XUWK3UtZtvpurRdMv0gfV003VEViwkuwRuvTDfs9z44gKyQpjC+f8u6Ds/NOA7iYfNtcD4MtCm1O+8VYMr2VF1YLPOtJIFae87HESdAJU2k3nSYymmPVTRUTPPiBEB3vfoWFOVH011DDez55JhEnrMHig7tbmlhz4/iyHGyPmobja8K9hRUTkm4bvHhKhn6tZM/MsaVsNXwoJth4vIqurm8xQ6He6gbCkZUgZTcL7xqF5x21Mfflv3J0GEWi48am6wyWk0wRBMQt9sNwzQASBbxV3CJQsq3D4BIJws09k4FT1Zp7m+vFZvuJ3p29t0Yxm2B6u5GfIth8ai20cd+j3wkD0fXD5OI7YiuPYczwBglfa3vYc0W/v/V9u2Zd/ACppiCzAe/ZzAUPO9M0pBHzhdLDfb3U+Cf4lyH9bC7HrlfyyBNfiRXcTrZ767JFjq5uys37Na0HWqjbbeyosELq8DJ/VbjBFDD2daNuWB7PuMqKUcNpoK8hqrQtv1nMY7+us/RouTPdjtb7cCN+E+vHmKdymCdo9x7ui/4gGQ8vgr5KMA9qPTr2Sr/A07xpIYYozixWVEQHGJ/a8i4YaeEF7eGnmSDqBK+x5zHrX6hfz0+Pp2KCz99aTodlrlHu9FeSUJALiumA7o1MR2w8aICCXsFVH4VoEMXN4C7BzGeN+ZSCJIO8lO8erZ7XZT7TeXznnq7eVfLVTZCw
 yWuyVn0t
 K/ScQ8fREIf7vfhUd0uJPgE5Rl3Y1Ct7G9VdBh8mPBEwkOXUpt4nXHbTxVXDF33+Yhq5ZZkJH8mHQQ+UcByQpRCyXeksT7pULNcpq2v0cWhuzTCTdxPYxv51frrrI9GE0tu6zVOiyu2hoTrlJrseYRIzl/yZnAsJjwIvTZi866qAr8wRhhot0bSofHecP9h41my/d3Sz2QdUxi/MGDfAXYLW9hLa3n+x6D/xu6V3RR+W0nlZDdet5QYVygQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We already use page->private for storing the order of a page while it's
in the buddy allocator system; extend that to also storing the order
while it's in the pcp_llist.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/mm_types.h | 8 +++-----
 mm/page_alloc.c          | 4 ++--
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 4a441f78340d..569265d159a5 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -97,10 +97,7 @@ struct page {
 				/* Or, free page */
 				struct list_head buddy_list;
 				struct list_head pcp_list;
-				struct {
-					struct llist_node pcp_llist;
-					unsigned int order;
-				};
+				struct llist_node pcp_llist;
 			};
 			struct address_space *mapping;
 			union {
@@ -111,7 +108,8 @@ struct page {
 			 * @private: Mapping-private opaque data.
 			 * Usually used for buffer_heads if PagePrivate.
 			 * Used for swp_entry_t if swapcache flag set.
-			 * Indicates order in the buddy system if PageBuddy.
+			 * Indicates order in the buddy system if PageBuddy
+			 * or on pcp_llist.
 			 */
 			unsigned long private;
 		};
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d21a411e807e..e71e23d1a747 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1520,7 +1520,7 @@ static void add_page_to_zone_llist(struct zone *zone, struct page *page,
 				   unsigned int order)
 {
 	/* Remember the order */
-	page->order = order;
+	page->private = order;
 	/* Add the page to the free list */
 	llist_add(&page->pcp_llist, &zone->trylock_free_pages);
 }
@@ -1549,7 +1549,7 @@ static void free_one_page(struct zone *zone, struct page *page,
 
 		llnode = llist_del_all(llhead);
 		llist_for_each_entry_safe(p, tmp, llnode, pcp_llist) {
-			unsigned int p_order = p->order;
+			unsigned int p_order = p->private;
 
 			split_large_buddy(zone, p, page_to_pfn(p), p_order, fpi_flags);
 			__count_vm_events(PGFREE, 1 << p_order);
-- 
2.47.2


