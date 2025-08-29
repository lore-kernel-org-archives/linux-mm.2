Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F72DCA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 15:47:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0C558E0015; Fri, 29 Aug 2025 11:47:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6FF08E0011; Fri, 29 Aug 2025 11:47:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAAF48E0014; Fri, 29 Aug 2025 11:47:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 931928E0011
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:47:40 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5159F8560C
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:47:40 +0000 (UTC)
X-FDA: 83830225080.16.87DE814
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf27.hostedemail.com (Postfix) with ESMTP id B38BE40014
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:47:38 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=vJ90wUoL
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756482458; a=rsa-sha256;
	cv=none;
	b=Ptot2TX3RzoAlojtXCVCfMjDWUyRsJ6OmTw5KcxjBKQK6sALPS/9hZ6aBV/bTxBJ/e5pu0
	esuAGT+Ykg87wa+6hmsoYR906LGRIZrSIo18G1bMxOg2JFWBIixxBSrbVue0r7jh/NfS/s
	GZS7dRlNqIw1BO6f4dORFu3TeURdi9k=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=vJ90wUoL;
	dmarc=none;
	spf=none (imf27.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756482458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=55YgvfGX88tXlzCtRoRlyS/JqWoUw9iTeqm/K5Sg/0I=;
	b=JVy14MOvXOKRFL64nuVUDcO3SUWw7S4HxyfNyshUQ39rznX9vpHw+jorbglvnJZvqVXGE1
	Q8J3qttiHVSqSvYwf4G0PlmNdSjPNs/52jGlf6dbXK/38oN8Ldc+zQymxqJfIqHTDd3URR
	I2clkdzEDklcoYVMV8A9fgPilTnSzow=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=55YgvfGX88tXlzCtRoRlyS/JqWoUw9iTeqm/K5Sg/0I=; b=vJ90wUoLCL2Vun8jaLoJycq/9n
	bZDkxKLlnPPJkKilWa6AyTlPezrfeBo7fzFneNeapD6Pv0q3kQUrv4/viHJ6HaNyQBno4aZE1lMkk
	RaGPP7wmJE5MQnQ2Tcq/QS6wR0uqSJ2tUCr4FZDVhuxJTXeo5uxYnzJqT/faOxU/uWxRUfAGidnDD
	9nUVbADctldU7xMbKUwl/4B/U8HkUI7yeHdqu0wME76BzWxxvzSXY0XLvcBG8P/pr5Cqf2jDAzvvz
	bUyiFkXsDLQvMSjjNsA+Jy+PCxaXGBYHsX3z8sTdxlDOOBiBzjUg8uGTI7vffDr/joUhS9BEXFiUc
	dcvFp5JA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1us1K7-0000000EFwo-3H8X;
	Fri, 29 Aug 2025 15:47:31 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH 11/22] slab: Remove folio references from free_large_kmalloc()
Date: Fri, 29 Aug 2025 16:47:15 +0100
Message-ID: <20250829154728.3397606-12-willy@infradead.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250829154728.3397606-1-willy@infradead.org>
References: <20250829154728.3397606-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B38BE40014
X-Stat-Signature: b68io51u7wmoo934jbhcq7z6xf9f5raj
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756482458-707458
X-HE-Meta: U2FsdGVkX1+WS+AGhvyWwjoRFiDCrK1/4yd6qYgy4YjMaoY8uLv3TcGeK5bG9dvJBJXdkHH4zITJhnU+n1h02gdeTqG1CfNSy+npFTw2v/esCbSmy+ub/LTaH6zp9JzCASFrAREHFbo7ffoeEttYQMTRQYlEYRGHJcfLyHkU0DUk2IQW6m6PZrTage5x+sAPrHsh4DAj4VH4ZEW8msoKz1tMWujRDBzwQEjFo5Z8g6So852m48QCPQ96tYEoTVZSH5dSq9wMjfGQ6KTADnw5fRqXojrpLFRNmK7dVR59iiwMzXws33ZD9AyZjInVSm+OHxFL4GJLFz1vcrs0dgID9ZNVgHbQ/UtWgY91SG9lVGmth9aBEjfbdz/fTjxiEkTPM4404Yshk8zRcT/2YCz5hocDH34TlFSbX3NTEOlNYaG6MfJ82XC9/YJCKaun53xc6voTkVgVHxgzoj+zBZBgoYaSJPjOgdvM/mNKDL1rvz7NcsqihmACd2SfZY9C6F80vhBu17CJYUP9SYrv1uaDqKgf3GdK84/7mVSAKQuGQ5ULN/+aCERZVkTQeXrxK/V30ts6hanjpn5Jt4qnjCsvU6Dk+LyczBCbUBP2Knthv3yP0VlUlMrY2/nwlQ8OwzTs1xTQNTa3vGkrkf7z93K32NchtTmjv2Orclgj7a+9675sIGhynkCHPwZLb0vj5i45SU1CgzZ+0mDni9ICzPvUqAMlOSLBiert8zd0UBFem2hDHy3l5+Rn/JxkAa6znYqmXCsJvhWt/Is3mqguxN3FjdZmvxMbXGB1WsfYswyRwzgomux4Jj/5W2As3yMwgaG1eiZ07PC2yoCvDXTlkuLrRQbXbZqHqNV2iOq+HEiUog3whvzEibiUemKpMvyZYWpsdxihEpUcEvJ+oNcmHJhMlHXRbqZ18ES1uC7ay2XM6tkyJNgp8ZGuPxZ+7icR28JhsqwyxsMy7MAzmXuobwr
 TpBlLB6A
 HceWYao00PdwIYTdf3HF0FGLPWIUdoD91rx2LSCQOB/l8oREo+bMrsniFFr5hYKIBBd8McLghN9N3MoBQ90jBRLaABRbrvGw0FccomSMCXcVJ7FbAnWT6536YJevcNf38FV+YESTCqGUj29OlvY2mGyI2k/220LPsWgZvjxu6Xaeu4+BZGHCP4oBlKQbrhotrFZ63
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There's no need to use folio APIs here; just use a page directly.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/slub.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 4e8104b05ed4..0330f7f21ef0 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6195,12 +6195,12 @@ void kmem_cache_free(struct kmem_cache *s, void *x)
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
-static void free_large_kmalloc(struct folio *folio, void *object)
+static void free_large_kmalloc(struct page *page, void *object)
 {
-	unsigned int order = folio_order(folio);
+	unsigned int order = compound_order(page);
 
-	if (WARN_ON_ONCE(!folio_test_large_kmalloc(folio))) {
-		dump_page(&folio->page, "Not a kmalloc allocation");
+	if (WARN_ON_ONCE(!PageLargeKmalloc(page))) {
+		dump_page(page, "Not a kmalloc allocation");
 		return;
 	}
 
@@ -6211,10 +6211,10 @@ static void free_large_kmalloc(struct folio *folio, void *object)
 	kasan_kfree_large(object);
 	kmsan_kfree_large(object);
 
-	lruvec_stat_mod_folio(folio, NR_SLAB_UNRECLAIMABLE_B,
+	mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE_B,
 			      -(PAGE_SIZE << order));
-	__folio_clear_large_kmalloc(folio);
-	free_frozen_pages(&folio->page, order);
+	__ClearPageLargeKmalloc(page);
+	free_frozen_pages(page, order);
 }
 
 /*
@@ -6242,7 +6242,7 @@ void kvfree_rcu_cb(struct rcu_head *head)
 		 * consider folio order
 		 */
 		obj = (void *) PAGE_ALIGN_DOWN((unsigned long)obj);
-		free_large_kmalloc(folio, obj);
+		free_large_kmalloc(&folio->page, obj);
 		return;
 	}
 
@@ -6282,7 +6282,7 @@ void kfree(const void *object)
 
 	folio = virt_to_folio(object);
 	if (unlikely(!folio_test_slab(folio))) {
-		free_large_kmalloc(folio, (void *)object);
+		free_large_kmalloc(&folio->page, (void *)object);
 		return;
 	}
 
@@ -6641,7 +6641,7 @@ int build_detached_freelist(struct kmem_cache *s, size_t size,
 	if (!s) {
 		/* Handle kalloc'ed objects */
 		if (unlikely(!folio_test_slab(folio))) {
-			free_large_kmalloc(folio, object);
+			free_large_kmalloc(&folio->page, object);
 			df->slab = NULL;
 			return size;
 		}
-- 
2.47.2


