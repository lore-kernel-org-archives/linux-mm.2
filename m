Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B66FFCCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 20:45:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D8818E010A; Fri, 24 Oct 2025 16:44:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6732C8E010D; Fri, 24 Oct 2025 16:44:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AD068E010A; Fri, 24 Oct 2025 16:44:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3B4408E010C
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:44:51 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EE55A8956E
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:44:50 +0000 (UTC)
X-FDA: 84034186740.04.B085D60
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5270F14000B
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:44:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Hx9JyGnj
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761338689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2xqs7v3YyWeZnHpz/+74BwvXCnxr5dqxR2m8s8XdqdQ=;
	b=Sc+8p29V7tkKcaOiAg+neXUsWGzgQtVV3+wPjW7Wn4ucGaPIv2/Fz14FnQrbb92QEMV126
	kSc9TMwhp5RMae/FRjS7XfFXlegi6ev7bPeH4TvhydWXYL9scvEf0RaZB3pnQ6ojjdI6jz
	S9bsFOlTCbaTGmOXzk5f9iqyN3XQnLc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761338689; a=rsa-sha256;
	cv=none;
	b=i1n2BQT2OGjcUEd1HAI6AtK3nbAhkg2c4mFAjV8t+xu9qAQgVd+5g+2Fj4SV1EGXe1zbAc
	ZQ4HuBPMthN+UNyRL5K6xxuQQz+t51CC0h731qY7ceFohVfSbi8JzRox9uyGbt969yRUlT
	S1CKwS6QDUYkUwxMPddWURKblpSE5lI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Hx9JyGnj;
	dmarc=none;
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=2xqs7v3YyWeZnHpz/+74BwvXCnxr5dqxR2m8s8XdqdQ=; b=Hx9JyGnj4O20AiRWrRyEOQ6On9
	/H2guDEIJ2JKuSy8Jz/hQuN8Zu+AStE+DCZwtsGatfN3qRg13xf7/bNYLpuMhIAiv/TGst9UUOah6
	q5TlF8uZsznb3h4KFRKd/wubl09pJR/oJeUwBWWp5LKLzC0l63u0rl8FtmMgCc8jgBhSA7Nbr6rNF
	q1Awl7GMldrjA8eQUJq4NNtrTNDJDZ8jQan302TMWdAxFXENuAvvjlGiDEmfZTPu1w8zJVzSm5XmQ
	eR8oJa0HnguhEaQ8G2V6f0ln/MLleiOHU0wN0AUiNpfiluiO1S0FAB/6t3gFyK+1RM9RH5YBpdeMO
	XfSAI10g==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vCOeN-0000000AKRP-2m5t;
	Fri, 24 Oct 2025 20:44:39 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH v3 04/17] slab: Remove folio references in slab alloc/free
Date: Fri, 24 Oct 2025 21:44:19 +0100
Message-ID: <20251024204434.2461319-5-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251024204434.2461319-1-willy@infradead.org>
References: <20251024204434.2461319-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5270F14000B
X-Rspamd-Server: rspam02
X-Stat-Signature: zwmimetjafoy315whjx483ukpi9rarpy
X-HE-Tag: 1761338689-627064
X-HE-Meta: U2FsdGVkX18kCVpskTTCMM9uiOrWN4/VpxkKygQ2daIHqiWf21DDN5qxca40ECp6yUsWReR/BTlO1AE3QzRf80ZwNb1Ge002y5hxp5waHc7d5CEhF5sgWjpwRo7fPQPiLlttmt+LwrwM24uc9Uo+A78VO+dA+bhk+w7cyTRc/m3Vd4E48TgfWe9in+XO8OrYwieumPlageMzQo0BDaNlw2oilaG52IgveQs+okxxgA6rcsFXKSh2ryqsSLliZTq8t3lnUP0bwQhhOvPrSlfKdRuAb9doA4CNiV2SoKHo30EP+nxAWqf/I3v8zKqEcAYc0pwd8/lGliFBl2kEm/Pd116FsxiUwvrnpNPdC1DbWDOYa7t4kOwvgyYTLIc/1laD6j+8jG349YFrXI/Xbo5b3DlrhFARAD7jdAtsC+nmdtPqvOwXxLxdQaDR+LRVwOld91TK65CKt8n23+u4J4Typm6NhfmyIE3jd65Ol1w+qcf/IVtSUSipSI5G3W+ETqeVXcOIPNFRNTVl5neeZ79twLE+Myc/c+l6GzLXFNHEpu0pUpxZknC7+cvjaYUnmDtHFXF7lhFffunMugpwvVSPBH1GalNxHFowsB5evbCIUOSvAAJp+7qXoZX37Xw41ztjJEEgVLxRJ8phoIja14Tinm6ic05EO7EPkh92+ALYX/QyLliVIWoU5eE/2+9mFqbWwAXMC3xHnx97F4aqEtqST2K85B8OVH6aC13Viw+B3KcHPFy89L5EMzoqy+Yf+Ml7pGWjLRGdDcsbcWQbo5wiv1/spJQacf0eC3rDntHskEk1igdPXSTf3Y6k6N1JViZjtFP4a/lKCSGxkhTKIYTDsUxnXsJ4RwaJWN6IUe4U6F5rhSvmZzMGmUC1+Kxo/VsApvPXR3NXOJ9yBE71eOfsADSkSoBmnWh21Gwjw3C+2qaj1hWZRTQILZhXtXEu/0aFEF8GIRhX2daJ0hd0iV8
 NY4/ZcIO
 YnGjVV9Q73FdVxt8TvHUsSGhiJ2j/mEb76WHfDoUTQbx1ilB3VaS6UPBwV9KZEe1MpynBXKC3VwJZ7aRZ6hNZUXHTcDkR3q0DaBvs1OuFdKOxFcSQFXL11NWHE6D6yAcUSVccubU1vmvsmXk+2HsKAC/qHMitMgfP+RP1d0Ludb72ZsdPBJxuf+Ed8A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use pages directly to further the split between slab and folio.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/slub.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index c72795f4f433..fb4a43a16269 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3039,24 +3039,24 @@ static inline struct slab *alloc_slab_page(gfp_t flags, int node,
 					   struct kmem_cache_order_objects oo,
 					   bool allow_spin)
 {
-	struct folio *folio;
+	struct page *page;
 	struct slab *slab;
 	unsigned int order = oo_order(oo);
 
 	if (unlikely(!allow_spin))
-		folio = (struct folio *)alloc_frozen_pages_nolock(0/* __GFP_COMP is implied */,
+		page = alloc_frozen_pages_nolock(0/* __GFP_COMP is implied */,
 								  node, order);
 	else if (node == NUMA_NO_NODE)
-		folio = (struct folio *)alloc_frozen_pages(flags, order);
+		page = alloc_frozen_pages(flags, order);
 	else
-		folio = (struct folio *)__alloc_frozen_pages(flags, order, node, NULL);
+		page = __alloc_frozen_pages(flags, order, node, NULL);
 
-	if (!folio)
+	if (!page)
 		return NULL;
 
-	slab = folio_slab(folio);
-	__folio_set_slab(folio);
-	if (folio_is_pfmemalloc(folio))
+	__SetPageSlab(page);
+	slab = page_slab(page);
+	if (page_is_pfmemalloc(page))
 		slab_set_pfmemalloc(slab);
 
 	return slab;
@@ -3280,16 +3280,16 @@ static struct slab *new_slab(struct kmem_cache *s, gfp_t flags, int node)
 
 static void __free_slab(struct kmem_cache *s, struct slab *slab)
 {
-	struct folio *folio = slab_folio(slab);
-	int order = folio_order(folio);
+	struct page *page = slab_page(slab);
+	int order = compound_order(page);
 	int pages = 1 << order;
 
 	__slab_clear_pfmemalloc(slab);
-	folio->mapping = NULL;
-	__folio_clear_slab(folio);
+	page->mapping = NULL;
+	__ClearPageSlab(page);
 	mm_account_reclaimed_pages(pages);
 	unaccount_slab(slab, order, s);
-	free_frozen_pages(&folio->page, order);
+	free_frozen_pages(page, order);
 }
 
 static void rcu_free_slab(struct rcu_head *h)
-- 
2.47.2


