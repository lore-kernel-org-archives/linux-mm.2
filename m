Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E29BECA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 15:47:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BCE58E0018; Fri, 29 Aug 2025 11:47:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 246388E0017; Fri, 29 Aug 2025 11:47:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10DDE8E0018; Fri, 29 Aug 2025 11:47:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EC6CB8E0017
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:47:48 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 795151607F3
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:47:48 +0000 (UTC)
X-FDA: 83830225416.06.2042D71
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id EA7D51C0006
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:47:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=sinOi2tk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756482467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a9KeXVIBXNcPaIHlEBE4YbD12UTBzJClDDJxD+2yXSM=;
	b=XzTIYq0ncFNNYcejxib/Jgy5PnvpSJFDTXlPxXHDSmFliWb1QwXQA3DzvXBVBnYJljCEjV
	0V2/k/wT1YISztudcY3H3yb0WJJpBvMOptrf6KihhQf+YmL1ZlxLlWVU1LxwYWWDNWTkIV
	T/wOBT7P9ntWNIMQ2qJgn7l3UrgDZDA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756482467; a=rsa-sha256;
	cv=none;
	b=3QudA67+5ih/vFLMHxPCiBdPZYieaaSq1s1SMqHlKZ8kjGy02ihvScspHxD76Uw1heM0DJ
	RGSiGvEb1VMRGfWXijBv+bQfC2vz4qWPPE7eVK3nkmL2x2vZONOqG8s5TIf0eg7ekT49SZ
	ZBdc4p2cWt3EM/DKYweLy+sT0ck05Rc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=sinOi2tk;
	spf=none (imf20.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=a9KeXVIBXNcPaIHlEBE4YbD12UTBzJClDDJxD+2yXSM=; b=sinOi2tk6YYAG4KSBqv8imrmqV
	FWeVuOuP21xIKy7R7ZX3Mx81Lz4eFETOrQ5sAQQ5pM1Wss6k8vLAvu4nHtEC7ROc5NwX8ra/WGPRa
	Homuhvr9ujvsjhBDCVrJL78ADSUUc34t7tE7dA02ghas8AW2jlyoCoK2qEIR3MSQ15PucGdAbxg5M
	zIgLPd7umE6YFPrXdnWVlXd6cAK4Rp2AUapFN6nkKynr84SUA6lqeosuG5VanpHiCyNbKlroWcfZx
	4rVAtDg6RaT8KSsFNYVjY1JXiMW+eLeKAg6e1nNXMgetHg+WiaY35f+7XL2llF/dph3VUCQ71gUHI
	iuzidwQA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1us1K7-0000000EFwb-2YeZ;
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
Subject: [PATCH 09/22] slab: Remove folio references in slab alloc/free
Date: Fri, 29 Aug 2025 16:47:13 +0100
Message-ID: <20250829154728.3397606-10-willy@infradead.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250829154728.3397606-1-willy@infradead.org>
References: <20250829154728.3397606-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EA7D51C0006
X-Stat-Signature: ihcg8jwarrmrzqxw9akkj16555ypa3f5
X-HE-Tag: 1756482466-161466
X-HE-Meta: U2FsdGVkX1/MGfNECY4S9VbND3ACIaNKomVYVr81s1gzhnC+2pwh26ohQjvdu05F+/u1Op2OR2CPzPI+GCmPPQ3sxD0ya5zPpSdPd1c7FATqCNw4P4uuqrlAA6G64qkOEd3u1o7AvK408DTxOc+YThAa3AqYfdw9Srhp+7rfppAK0dOE+BNwGmbSvYP6pvh9zsYZUk+v7OOVyCu54CwjGEM/nmDkYihjynlDey7o5y9D2QBnh29b7EPM5dKv3glWwN5mNzd+/Ef/hNBIErf692ps7FUOPkk/Aojpsj47dHNbBe7MmptM7N8xCHig0tKNhGsQr1Oq9J6LiOY9ZPIoVE/0RWO6ems+El7Xrq2w9bWdkMmOFEH3XWyQhyqJQvlod+CiG0BY0DJAgd9jJuE7gmvMqs7EWGwMZz72oSZSCEyxseFnVZ59DY5r66rZbvYkaD4QL8HDlZiEn/h82cbIjyzYGlrZ08x+nLLOjCN5IaOcjoSP35KhElnVvQ+v9WsysNKPHBJ7vTejqvVBwwMdkdGwV6DMZi9Xdppypw3s5qRV2hBC5urPdIqCZKkDBo4yld2XC9TxskRbRrHwy06ngmuWg/Y4icpp1zfnDXiWo1UBOL9VVNN4nu4G2FHZim8FJaIXYCqM/b3hY6pVU4gmZRAIp/xCcW1k7Qun0rfvVVrKPvozqqsq55ev8beUF5QPsdgfERlKZJMd5iOMBTsZlGrX4GXgbsgoA97SGO5GcaLK9WM/LFQDj4S3IN0l2OZ23EKNR1fQ/XwgzgvHR9qmN2BGFtHRAcANVN6ji83UYB6XGxM1I5VFJltH+N8Jm/8Nrj+R46+ArSALpaRGDuxAGYSC+avCLO31dr1rjgL/Ih7ScCzQccjipfDZVVnByyhCmpwhI6hU+Hh+G9dgZNc+CGZBhchROq7lCyeIUXu/0D7MMwJlErxkps5JyCgbla0uISkTbrTWU5dSg9zCxBv
 S+Umt8Qj
 fca2uhVWSA9S1oNXk40GFmpMSpKqMT6Q3C5igVgCKNR3eDRg1DthjLDMZwIp264VGIk2LeudHHcJeyIe+sBHO9xUXCXjw2Uqu4oQASi/bqpUS/wDuSgOLsPXcmBBrSKlbqekBCtho6/ngfLBTo1IfUQxIO4Cp5R3SlrMtTHfDGb2QavlF34gTukiYHhVRLsVP4ZJWu0Z/AnRY3/ZA7XVucc0s6KmQtvGrMIgu
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
 mm/slub.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 8d984fb5208c..883a351255bf 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2974,21 +2974,21 @@ static void barn_shrink(struct kmem_cache *s, struct node_barn *barn)
 static inline struct slab *alloc_slab_page(gfp_t flags, int node,
 		struct kmem_cache_order_objects oo)
 {
-	struct folio *folio;
+	struct page *page;
 	struct slab *slab;
 	unsigned int order = oo_order(oo);
 
 	if (node == NUMA_NO_NODE)
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
@@ -3207,16 +3207,16 @@ static struct slab *new_slab(struct kmem_cache *s, gfp_t flags, int node)
 
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


