Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1182CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 13:31:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27C2D6B000C; Wed, 10 Sep 2025 09:31:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22C966B000E; Wed, 10 Sep 2025 09:31:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 169E06B0012; Wed, 10 Sep 2025 09:31:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 04B146B000C
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:31:25 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A8EAB86A48
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:31:24 +0000 (UTC)
X-FDA: 83873427288.03.69C0632
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0A66DC0009
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:31:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=WqzV5q4e
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757511083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QFYEXfk1+cEN+TXp0FIDTxyYhH24GG6SmGgomzzqRa4=;
	b=YYKXKy0bqIFZh/1WuFaT8Q/SJxaExfWewi7m+clq2+zcWVSleyztO7kLLI0lMITf1CNhit
	k5jGsUeEPrYdVqjkWdOFygUuKqkWrk5muZkZ0Z3XA2ErsvHoFg8hfrRQxA+f6xbj/X2y4w
	Y4WsQ3s+8BT/U/+875gs+AnTg3QI3GQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757511083; a=rsa-sha256;
	cv=none;
	b=dOs4E3yPkMmCJzjz3ZoaGJniRCi6acOGA1bPT93ni8ylXv4uTs2uCaazOcZFqhyChYly+p
	T5SFqNrylWX/HcNpO3v+fR/5BEQiZhSKxRWWpKZrfEYfChYfSlvlx1TO2wvGXuOlowQ6w4
	kSUm3p2YFUR8swdFGYU+wdeJi7DYcLY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=WqzV5q4e;
	spf=none (imf10.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=QFYEXfk1+cEN+TXp0FIDTxyYhH24GG6SmGgomzzqRa4=; b=WqzV5q4e+4kk1e3r1lV4JGd6Cr
	ZHEItM3JZbHVpu9Yo1Izkz+AJnmgdpzQ1RKWLoH7Ur0kzlgw1s/BkcgVZWy0A1D+aabuIKYYLsBXb
	F4FsFx8eBdXNoZkhi+JU/lPpZKSM0P29rY2IkZLGTXDQhGCzKfCpcHLq0L9Rp496Q4mDNxWDZK4EF
	3fa0mmLehsj0m0U6EA51Sw+AS1WTdygL+Gi02SAzvv3LCiMEF2nHEH35jsXJ+DRItKcH92ozeIqty
	dfXZIF6dZTa1hK6wUAFeKnmXD2NAXI4CAPJ3jdYG3als7BYHtZUZoDRPm7RemM8J7e1bDpSyl6Hsh
	dh/Fq/sA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uwJPq-00000008MFd-3I0R;
	Wed, 10 Sep 2025 11:55:10 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH v2 20/22] kasan: Remove references to folio in __kasan_mempool_poison_object()
Date: Wed, 10 Sep 2025 12:55:02 +0100
Message-ID: <20250910115507.1991829-21-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910115507.1991829-1-willy@infradead.org>
References: <20250910115507.1991829-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0A66DC0009
X-Stat-Signature: x363p5cmjtkdk7t9nj87uxsxzyb8p5bc
X-Rspam-User: 
X-HE-Tag: 1757511082-497268
X-HE-Meta: U2FsdGVkX1+ibILMySC7M/SAHV/cRWFc5aD5DFKFrUgvee7gwaA/WSQ/WT8SUGzcYd4vFnTg1sJD3ZhVhQXTK6+qqh3CT+OuOI7wsa15tBtQk4CkqhPvi7R7GbUxJi6RPHDY53jP6aArYiOPPZeqLWxqqCbakltOEA/XERH69N7E7/W3oxlYgKLGOgPZGcjlN6++6cngFBcfSjtSnuSwWf5N5Y71eb4aVJvqT8n7Lgm6hKICK527K4V34m6xhnHQZhT/CykRqnW1AoH9aHxFBlFHUKxNDvxUCT960reRJFYBcTD1RkJsJBu5RbgeARkmaiza0l9YaPgHa67LJvcQAosTRy/X9VDPLa2p0WJ63eHj6nNOtgk1xanl7ovvtVGc8+GfhJPi7KHQoH3e1H2cyV/J0v1/MAOVLi/r1/Edig3670jLkXOKCCpcwkF5puLr1BmEkX+pQe9t2byWzuGy5MyvgBwWbzeF62P1HlJcoSRU5312MmN2U2UIGyGXWMAKO2/+oIXO8v1uSChdVc/c0wVTZHYa78lDZoAUuc1I8dwgZuEvjOSQCA9g1W9qK26TKZEVYJL3EDYC6c/JKsQFLu7ze9I4kIyXA7nBQbyLErKH9q9i+e8Os/9yWAaaBePw0LXLiQ4JX0SfRp6dtyk7co4IU/MZ8kFKxejgRGwj2b/hoFJCO2OV8soSQO/oVEnMHx9+UMoiC7j2GoBTZ9ejbllMj55YLtJjtV253IPTtd7ksGNKWdoW/3ceb6a1om3BtwLaOAVQtLxN/XmP+uMEVa9EE9I5hKtfV1V54xC8cwupDSXICLn/8wBPs3KROcYuABQpuwjQKiSjdmgzDyu6sOqbFUz1YOcEWtNP4suLJsCqDbJ6O5wQRD6VnTC2key8MDcku+GUvDVJvmN/33G3zg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for splitting struct slab from struct page and struct
folio, remove mentions of struct folio from this function.  We can
discard the comment as using PageLargeKmalloc() rather than
!folio_test_slab() makes it obvious.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand <david@redhat.com>
---
 mm/kasan/common.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/mm/kasan/common.c b/mm/kasan/common.c
index e3765931a31f..e90f24aa76db 100644
--- a/mm/kasan/common.c
+++ b/mm/kasan/common.c
@@ -517,24 +517,20 @@ void __kasan_mempool_unpoison_pages(struct page *page, unsigned int order,
 
 bool __kasan_mempool_poison_object(void *ptr, unsigned long ip)
 {
-	struct folio *folio = virt_to_folio(ptr);
+	struct page *page = virt_to_page(ptr);
 	struct slab *slab;
 
-	/*
-	 * This function can be called for large kmalloc allocation that get
-	 * their memory from page_alloc. Thus, the folio might not be a slab.
-	 */
-	if (unlikely(!folio_test_slab(folio))) {
+	if (unlikely(PageLargeKmalloc(page))) {
 		if (check_page_allocation(ptr, ip))
 			return false;
-		kasan_poison(ptr, folio_size(folio), KASAN_PAGE_FREE, false);
+		kasan_poison(ptr, page_size(page), KASAN_PAGE_FREE, false);
 		return true;
 	}
 
 	if (is_kfence_address(ptr))
 		return true;
 
-	slab = folio_slab(folio);
+	slab = page_slab(page);
 
 	if (check_slab_allocation(slab->slab_cache, ptr, ip))
 		return false;
-- 
2.47.2


