Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 840AECA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 15:47:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA17D8E0014; Fri, 29 Aug 2025 11:47:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E07B58E0017; Fri, 29 Aug 2025 11:47:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF54B8E0014; Fri, 29 Aug 2025 11:47:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 996F18E0017
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:47:41 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 17FC81DE777
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:47:41 +0000 (UTC)
X-FDA: 83830225122.15.1C5FA0D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf02.hostedemail.com (Postfix) with ESMTP id 780608000E
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:47:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=AYekPg5y
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756482459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YAePvsUBO2CHWx8ILp3NodUyggNGnuQh47I0inSL/lU=;
	b=bytOtHicnJkWOk/WIoAAE4nOWP6KjFQ1Pp4ZR9/fWGCq6G1YdC3sNiyAlNpsKM69hYAk92
	EABLLt/mY5heEOWxVSu+nPEBYgRkNkrsZUXsjrApJk7n0LsW2HMKkpf35J9QE41iF/Keqb
	6E0LVcEGKf7LdbBlwMPJeT/VTfho2vU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756482459; a=rsa-sha256;
	cv=none;
	b=OZh0NslT+Tbz4vCoi+ztu0TrHO7quSZeMRi8l8/ejVoXGwRIYjyuLoGE0CZe96QH6vcXX4
	r1ulK8dyB37qO/rTpz8stvfjfOzyvhvOZ5vcEvGvtExq5G811WNNKhrm4RLm8jprci5bjy
	LS3mf/M3TmeD5fsUwRcSCqbt3IAr9V0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=AYekPg5y;
	spf=none (imf02.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=YAePvsUBO2CHWx8ILp3NodUyggNGnuQh47I0inSL/lU=; b=AYekPg5yj4E2AGspbIx7f4ofkM
	9HXkXYQJWMKSEoTl9Dqh45ceRP2IhbPNTkG7tT7S0F7UuAB+W4OqEVNF3deX+ktXdNPUFvJXq/hod
	41MQYgV8JzE5FCgqAddhOLQWsS+p6IuzKJVyA2qc5PclwV296NxNiNapYD0eA4Rsav1X/351C03WF
	f85+8YysAKnU1mejmIdABqTlyNJeLt+PIc484TwSqnPDkCqJBCeF2m2Y5R8kAjwOsV/3ds3grvwau
	TZcQ+2fbLlvb38hTR2WKfsd578kJ1DSbqImEaDDHI7AdPJqMa/7LCdKIon+0gfo+VXWTlFQ30P+5C
	EyEqXJlw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1us1K8-0000000EFy1-25qu;
	Fri, 29 Aug 2025 15:47:32 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH 18/22] usercopy: Remove folio references from check_heap_object()
Date: Fri, 29 Aug 2025 16:47:22 +0100
Message-ID: <20250829154728.3397606-19-willy@infradead.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250829154728.3397606-1-willy@infradead.org>
References: <20250829154728.3397606-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 780608000E
X-Stat-Signature: ifc9gwpu1km9iz7ah5mezkgpymoxzqn6
X-Rspam-User: 
X-HE-Tag: 1756482459-825355
X-HE-Meta: U2FsdGVkX1+AaX545HmAlSi0QF7rMYf7W9NhBhR49ITZ4VQqj28nXn6PY++7BBWXNiEhyHefZHWq9iJFtN+qankk92xLwYza8095Jmi5DAxO4xlrXhMIkVBkpuj60H+W7k3Q5liuLSVAdZEmgEsYHyoRvGaiAhRMue5he2s6TxjS/Z2BEixT1ENOGoYJIt6zNc4Hv1mBBJYZwHX0JQc1E7oTDTuhIHm1t8a++fzWYF1pa0HP4cdLPBqguiqK4IHshwEt8N1MloPB5dYsyLpB6anSAcgnVWEBLEIqd0B4f1vpaDx+ApLIe2ohzjfihky99kcad+xCN7X9Z7bVytG9oep1DPWp57WSGLawh/Lwf+XZ3eT5+4GQXp9zxl5oi0wf7bA6wkY1ZVg9zSvLOUeGDGUKzUU6v4eUqOp4xYm3Z3L2cpywUk63YFXmdDV2pQVwmOjQdCyfhTeJ7BAXriFs9EMma1D9lwuqXE/Pb7MO4mxJRkd3fZcP3wDKXqjIQzAtozqe8l87H6cwIdk3s3UDhw4bWNleeW0oS03oytiZNl/0ObItTiAYJl/I1QWT/uldGlNG0bbfsEpzc6uPllDa4TpW2S2/p6wbu5n6wiLGoFyKGza2CNCkfU03J8Mr+mwiLms/lbs49D3ksWkXHNXzv4TpTbA5J8aPibEueBayTvdYa4H8kqxD0cyxQHYHZ3kozx0TJa1RMFr1YcJ+gyCkgPvEF47yCsUuDefjHNtME6ofH6yZ9oJS3XnFIVs5DhYsll8Ek4gy8vY8qJvji2ALTc6t+5dg/F8/s+8HJO1LN/sBJyPFK0CBqfHdcYjFRsnecGgiLVJkO1pSB7gOPbOIcrOz3pOUfl9O/fiIwumQT6ZsP4QuUZuSZqFtpalFBCeIRwdIukCOUg3VHTGAuvW0eV6hX41kS7U7jcogdqG/XWcSlb5uFe8CnxJNuvYKje8oZNyJHEojUP1feXxmskq
 CKqbX0LX
 iwgZkDnoV9oLi6yxC5Z1+toHRxYcpblfPpcYJdUyWnodO4971X+vNJR9VHxMDnqeZ82ZFTNi2SVBTW/NmsVk4Ts9tPC9omm1qe/Yo1Dbh/WNffDcUenbkpN0cKpZJSwVrHlq9/NAME2/GyM02/3rlCRD6j+PthFWEgOjSfeubz6rOVQVaA4Q7n/ZINuYChhoe3kmBxvlnVVsjXGYmg2oo8T8sEzM59l00x8LFeE1AWN3CuXtbdKGtIAth63UnWxcnCKXFXgldBhRv+94=
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
index 8ab2d329664b..8226d2d9ff21 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5287,10 +5287,12 @@ static void *___kmalloc_large_node(size_t size, gfp_t flags, int node)
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
@@ -6198,6 +6200,7 @@ EXPORT_SYMBOL(kmem_cache_free);
 static void free_large_kmalloc(struct page *page, void *object)
 {
 	unsigned int order = compound_order(page);
+	unsigned long i;
 
 	if (WARN_ON_ONCE(order == 0))
 		pr_warn_once("object pointer: 0x%p\n", object);
@@ -6208,7 +6211,8 @@ static void free_large_kmalloc(struct page *page, void *object)
 
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


