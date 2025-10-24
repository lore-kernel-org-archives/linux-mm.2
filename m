Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAA1ACCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 20:45:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D398C8E010C; Fri, 24 Oct 2025 16:44:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC7AB8E0111; Fri, 24 Oct 2025 16:44:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A418D8E010C; Fri, 24 Oct 2025 16:44:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7F5268E010F
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:44:55 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2EF558956D
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:44:55 +0000 (UTC)
X-FDA: 84034186950.15.E39D042
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id 91BBA40017
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:44:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=u2PmXqw0
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761338693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7HDcPcouU3UKqeXWsNJM/8LBHnqz2JY6JwBJq9RG+Bc=;
	b=uphVA/JqQ4/+kW9C7py5UKGKlZQqAa1cYZtuUZBTmiS2Hwm2R7S20arPc7qH3Jg6vVnRsp
	YsmfhSKvhIOmB7uZGDjzfMF/zlLeOfEbEzqCf1bz8PgO9Crrad/z02t68f9tcRVmaZYdSh
	SPqVT9PZQH5pSKzn2CnWmMD0SwuDH1Y=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=u2PmXqw0;
	spf=none (imf11.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761338693; a=rsa-sha256;
	cv=none;
	b=Rdxn5DLFrpz6U6soNfIdz71BSzrZLy5H8HhD6/knbDwjjBNsu7C2eTKNJ4NYv3iNCydU8L
	x+xNklgwk7G/PMMqPHXfAvqOm1NwJ73MOR0BjCEZ0SZA2xOTxQEtNFtu6VbWFOCELuJWCj
	0SJHazBI77er19iE8WHTcQSlay9uuj0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=7HDcPcouU3UKqeXWsNJM/8LBHnqz2JY6JwBJq9RG+Bc=; b=u2PmXqw0Gpz19HaivWh0d/l1tq
	0csbQlMKFlX8XyubMQNPdJJA+h8KDCP+2iChmXLIB8WyTbE9c2Kdqgp0Bm3NWbCQ1zeBGQC1sJ1IV
	qAXE74LGKTKy3eiRYMONqjv+qp5h28OORJJk3DPY4KxUPZEE+QYx9eraT5+JYoPmkcNpzobAJ6f3R
	RJ70WzWu0dj89nbqxUzJk8kvRI4LTdw8rm739osmGPIASo2NKdwMJcXX4W5lU78qvXDcx5UnBB4Nw
	X2W8NTzXc2S/dcBanJ6EnRVqGhTC5QsrCN8UWYfD8WHmd5fyUcKA+dbQeO7I3mgzkgFWlJ2FsiOA7
	vU684GyQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vCOeO-0000000AKUC-2Ce4;
	Fri, 24 Oct 2025 20:44:40 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH v3 14/17] usercopy: Remove folio references from check_heap_object()
Date: Fri, 24 Oct 2025 21:44:29 +0100
Message-ID: <20251024204434.2461319-15-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251024204434.2461319-1-willy@infradead.org>
References: <20251024204434.2461319-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yjb8udu7fmdntn9mknm1rad7drf1gpnp
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 91BBA40017
X-HE-Tag: 1761338693-896872
X-HE-Meta: U2FsdGVkX18vJ6tDsq745wuyj4JJS24yD523Kmudg90dIky7dCpUVhEUpTyLFrj/25UypOFVsFksp+xPENNQmBmefTl5vXprZdbl9vo3KC3Mp50EvTcSYhZCVttNlVgOvo1jHoWyaN9COfMEmTT0P93da2C5fbkVxZEO+qJhrQcC0Qwd0iMs727LT8dwm0QTNDeoasHt+3zFyjwsneSBZpCNZG8dNNr08xFGG3sZor5harDH5S54ippEwI653vRDLIkJHnBrpVBkyQTedgmqU3UE6a/FX8vcohsRB/6C8i/lxOKO5ZpInMzNjsu+R9TF9+e/6bk00MfW8lZIqbGvC+sOGhpHchmSLivIIw5FjLSyOf5YuR4ZsgJeJlYuKTrFdOtwXifpcn5Be8+p/WtMqy0hhUTTYhshlR1X7M5ygikXc+69i7ktF1ZcHIGkPwzGFXNHfeYhcMPSifWOYILeBwl18anT+77y0XYSN4xCzeqy47SNgYRuyQ+B0X6ssSQ8PsPsb+NqKC4poZ53GOAY7lZBUnmUzfRxxyvMJqxvQGiXbbtQAxwUz9XQo/LA2orW3fKzhCurCHw0sUFPYh3nihVrs5lxCWHI8pn1bjlZ5F9TBXojRw6/l4T+ODTMiw9yryXMF6WH9y9/plO0IOvk3orvIhhq8MfoMlssYRfdQgoBWicgLGhVcNsQ0mO8sLErBmyjvdwmgTJjnDAnugaOVYVp3tcQ/lD3acO2fmMbbmwNNpNJqq/LpbJC9wEfKUbP1xX+KP22eodZEbuy+XmAk5WleRjaSDnH8b/zfcsk1uZ5YDbNRe8VtcGqAXmS+6i0Z5cJJ6ZK7fmHChryiXSaXLMRNZKFhv3TPXS0BAfvmjqjDdJ5PcDLMnO2YjnS2JbO6aGIJV7ryd+mkcjZsJyyRNk75KnBMe95rLPc6yg1czDND2WOVevTVgpPENFqoSOwHcDhW7EQ+fYLWi62Qq1
 M64R5TFK
 r0h6LFsex8y3INpaJkS71uQwvIgU9NOWxJTUOJ2ev45JNngplTJToz0SOfSFZS01b1+YF5XeZKUeNve+RCZcPruwbt6ojuJYTEvnOR8kieVl+ZTAVtB/I+9/aL4vwZGTrzpc9eEVq11/p8EwqycqM1PvYc3j6DRVeQ8Y6BT3ip5nNRb6MBrssDZSgEaqLwYKpOMYUE3NuqPo34HvJ1SVtEJ8pbAuGe8hQb5Nfs9LdraZ3G3afyCfUrTIIgiMeI1JObnrziiW0nf8FDN8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Because the pointer being checked may not lie within the first PAGE_SIZE
bytes of the object, we have to mark all pages as being LargeKmalloc.
We could use virt_to_head_page() instead, but that would pessimize
slab objects.  Once we move to memdescs properly, we'll tag each page
as being LargeKmalloc anyway, so this is more in keeping with how code
will be written in the future.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/slub.c     |  8 ++++++--
 mm/usercopy.c | 21 ++++++++++++---------
 2 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 39a26a970018..54e425efaa6f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5581,10 +5581,12 @@ static void *___kmalloc_large_node(size_t size, gfp_t flags, int node)
 		page = __alloc_frozen_pages_noprof(flags, order, node, NULL);
 
 	if (page) {
+		unsigned long i;
 		ptr = page_address(page);
 		mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE_B,
 				      PAGE_SIZE << order);
-		__SetPageLargeKmalloc(page);
+		for (i = 0; i < 1UL << order; i++)
+			__SetPageLargeKmalloc(page + i);
 	}
 
 	ptr = kasan_kmalloc_large(ptr, size, flags);
@@ -6737,6 +6739,7 @@ EXPORT_SYMBOL(kmem_cache_free);
 static void free_large_kmalloc(struct page *page, void *object)
 {
 	unsigned int order = compound_order(page);
+	unsigned long i;
 
 	if (WARN_ON_ONCE(order == 0))
 		pr_warn_once("object pointer: 0x%p\n", object);
@@ -6747,7 +6750,8 @@ static void free_large_kmalloc(struct page *page, void *object)
 
 	mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE_B,
 			      -(PAGE_SIZE << order));
-	__ClearPageLargeKmalloc(page);
+	for (i = 0; i < 1UL << order; i++)
+		__ClearPageLargeKmalloc(page + i);
 	free_frozen_pages(page, order);
 }
 
diff --git a/mm/usercopy.c b/mm/usercopy.c
index dbdcc43964fb..8d21635147a4 100644
--- a/mm/usercopy.c
+++ b/mm/usercopy.c
@@ -164,7 +164,7 @@ static inline void check_heap_object(const void *ptr, unsigned long n,
 {
 	unsigned long addr = (unsigned long)ptr;
 	unsigned long offset;
-	struct folio *folio;
+	struct page *page;
 
 	if (is_kmap_addr(ptr)) {
 		offset = offset_in_page(ptr);
@@ -189,15 +189,18 @@ static inline void check_heap_object(const void *ptr, unsigned long n,
 	if (!virt_addr_valid(ptr))
 		return;
 
-	folio = virt_to_folio(ptr);
-
-	if (folio_test_slab(folio)) {
+	page = virt_to_page(ptr);
+	if (PageLargeKmalloc(page)) {
+		page = compound_head(page);
+		offset = ptr - page_address(page);
+		if (n > page_size(page) - offset)
+			usercopy_abort("kmalloc", NULL, to_user, offset, n);
+		return;
+	} else {
+		struct slab *slab = page_slab(page);
 		/* Check slab allocator for flags and size. */
-		__check_heap_object(ptr, n, folio_slab(folio), to_user);
-	} else if (folio_test_large(folio)) {
-		offset = ptr - folio_address(folio);
-		if (n > folio_size(folio) - offset)
-			usercopy_abort("page alloc", NULL, to_user, offset, n);
+		if (slab)
+			__check_heap_object(ptr, n, slab, to_user);
 	}
 }
 
-- 
2.47.2


