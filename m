Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81F79CD4F27
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 00:10:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 414BA8E0019; Wed, 12 Nov 2025 19:09:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3ECDB8E0012; Wed, 12 Nov 2025 19:09:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F1738E0019; Wed, 12 Nov 2025 19:09:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 031F68E0012
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:09:54 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D55EEBAEF4
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:09:53 +0000 (UTC)
X-FDA: 84103650666.17.6AF569A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4227E120007
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:09:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=p22QXoes;
	spf=none (imf29.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762992592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q6uVKKHGy21CPFPUIEaNz04U1lNrwLeiSCWoU3dtbpQ=;
	b=eYDApbWXkpai1dVMJTmxqg7ogFY2dLN/Tsk0UKqpVpP6mfJGjBdTxHwY9kHgCdgW1pxWnS
	SARaqITiq3UyZ6EAuQZvdo4fkohj8ml56t6FdsxdcpPQhUKI6vM9IM3/4H44Si0QW2S2F/
	/z2vb9eEH6lWS75oTVwkH08C/JHjAic=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762992592; a=rsa-sha256;
	cv=none;
	b=PFKhZVF9r5pu5Or0lNof81OSu3kUJzU380nfUq3YKtWLbBD9Z2nasK6HLfBDVlDhyJgDll
	4sG7Krg5GRFPHuVFUqjDuRBtoxm7vyCx5Hcb+cJtxIWS9s0IMY7qq8QiNjhFQEn7udsVfH
	w9SfoNcMtqKSSI57jhQeSD4xhy/CXnU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=p22QXoes;
	spf=none (imf29.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=q6uVKKHGy21CPFPUIEaNz04U1lNrwLeiSCWoU3dtbpQ=; b=p22QXoesV7j3U8s7IBVKK22nlu
	2F+FoCEUKP+cIhvm/8yte7EoimbXxHPO9X4qmAFrKt8h7zdRYymPsO0aBobRLHsPehvaCYSoBVcAz
	ozgeH+eM8w7AjJ3sZGMX0iI2Y0T8xcepeLTqdkCJU6J5ehk6xUyNnfeMrv11dyUMAE9xbah5DBtyM
	SQjmWGKP2+lnsgh8U9ojWPbKtKYLe0tXzuT1HTBrfnYPCNk0Z/N8QTVw2WQSevLdQEuKErTg3hxmO
	efnUWp3o1A8Z0MPOwbkRs0k0f7RtdYFoirI5oUKIyAHYzgWhZC3IsxgeJdnEPIp0AzkNcgN7ke35d
	itP2IdKA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJKu6-00000006fOU-2gvX;
	Thu, 13 Nov 2025 00:09:34 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH v4 04/16] slab: Remove folio references in slab alloc/free
Date: Thu, 13 Nov 2025 00:09:18 +0000
Message-ID: <20251113000932.1589073-5-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251113000932.1589073-1-willy@infradead.org>
References: <20251113000932.1589073-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xp5ch4reuphhkbpohxctodqj9gdm7qkh
X-Rspam-User: 
X-Rspamd-Queue-Id: 4227E120007
X-Rspamd-Server: rspam01
X-HE-Tag: 1762992592-282313
X-HE-Meta: U2FsdGVkX1/Th27zgNtkYUe6Z4VnbHBjNnUl1jBSkJjQvvSfWAB0Zo6M5eH+WlAtVMtHK+AHQ/he+VEPeqXTtqN1EFaX/UQ1QKr+oqEMHqYzTOfp/NYYMJjw8F3f32qCE9tEL7+2eO2onMGCWDJBQ/dc7wj/s83/zXbAlOp4uU7VJhlsL+WOepcREoTx3swKVKmNrjTW94587wsVY+gf1Pz0EgV1bDduZrP+R7oFFInD2VR8pgQV0G/VoBwgVIp4ffuoPgT7Gk8KcT4/xKQAOgAsRfZekUSouU0I++zlP7cFdOYgiP2WCSxVsEo9XaxWWnh2j1IKnZ9D5kw1abz1U2vA4/JmhqtkACpDA1qzIzWQ8Dea4jO7WpbeMEoHzvOgtm1kjvilEhPpwAvDEIOqXrVdksF6h11MeSBBvcd+z79yRzjZ+a+iowTxrL0xIcWHexxa/pxafEGz5OPbGuPJM47iw/tT4wJj0Dey3D9JJIXB6ql9ekQfnTytkGofXBsqDnAi9ZMA2fYsjze11alsfsNlOzLD2Z4l1eaSP1/RUU3uBiKJvlEx/ZljfJIzC09Udu++h/uwXsbiP9MMS3AXb9I5oN/rkt2Wb8jqslXF55Kh3IrI6kJRX9ff0x/SdR36NxDG9q0eiPYcLyDKQSfxZMopNSGFJ2EZ+/Dg7DNnbcp0QLEKxbNWgrqyCc9O60k/zipnHv0rBWZwDRwC7VgU7hgOIR15AU+rfGGVbN8pCinR0tVjjH1FEYFJClalnBbzej6WWMPGzYZv2HpIGkdvPbNMOiNPob/K78+DkZagdkL4f6SvV/0akPWGyjuQOKcr6PxcB/VWXQ/mckIbeCzbCe8xi//KB23Peb2kmSxyFZvyCTuEz2OKwTtdcYX4in1wpsAFDybYLMAWxM0mWQ0l9FZg8oUmas6mq4fp7tCspBUhlJvWE4F84zEKUaA/4T6Dm+yrjS5vpyGgyiw/e8T
 sZIKk6O0
 uj1baV25D72atRv4jq3ufMRoOrgDq28X7v2O5Znu4mM7QkyfWX6pX9TyGB31ycnrWrt0m7LNAB8wRQfdL874B7Ux1Px5Rz/cRe6CUOTnLyGHg+gv0x2bPVCwzGNJPyPPrHwA1llTKmOLJRt6HV8H9/GTw1u0umKU0E9mjWaOdi4jwKItuo4pyxbmURZrIYN/fFxo8hk4cZBNuo9sbJpCaZhj4J5Mo9bg7R3QrGru4cu7ig7DP/vTzXt/yf53tK4s9CHz3pVclrjPE9nMzPYZ9Ju21lA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use pages directly to further the split between slab and folio.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
---
 mm/slub.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index ddfc9db4c6c1..4a093140f985 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3074,24 +3074,24 @@ static inline struct slab *alloc_slab_page(gfp_t flags, int node,
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
@@ -3315,16 +3315,16 @@ static struct slab *new_slab(struct kmem_cache *s, gfp_t flags, int node)
 
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


