Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82F5BCD4F27
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 00:10:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80E6A8E001C; Wed, 12 Nov 2025 19:10:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BE088E0012; Wed, 12 Nov 2025 19:10:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ACF98E001C; Wed, 12 Nov 2025 19:10:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 54E008E0012
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:10:03 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 10C955AA0A
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:10:03 +0000 (UTC)
X-FDA: 84103651086.02.468F0E2
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9C1521A0004
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:10:01 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="WMeq/DV0";
	spf=none (imf19.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762992601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1dMr5uZJAP7D1M07gok8QVRonytS3TrK162s8UWCFkc=;
	b=jxjGswJURXg9z8Vl/5P69cqiPbySRUr92yMzI194papQ3YiFBIxYarVmGhHSszx1ZsHIiV
	cM91vc8GbXg/uQp9JKRg+DXcGYrE7W8Y6PvxaeRKAIWYC/9VqmruEfzfHjGlAEMVhWm6UH
	QrDMIpsWwZO/1oyShBhELU/p3K0VL18=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762992601; a=rsa-sha256;
	cv=none;
	b=uM4ARDTfZNanE1Nk3cMKfPh/HdgT8kx5sSo6fs8jdis6djWDZfJ59rT7wZE274MLTe9NsF
	mRfFCkMvH6yJEi2o171mcl+ONJhbvqtvC/8RwqCwP1ji2BsvUp7zO+s+eZIEj0CVWmoRhi
	q7nTHbvxwv/qciA0aoC69cTpmo91c0k=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="WMeq/DV0";
	spf=none (imf19.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=1dMr5uZJAP7D1M07gok8QVRonytS3TrK162s8UWCFkc=; b=WMeq/DV0lK13oDRUv4k/a/qt0J
	cAgyzMmoS4KcNK62cGlXuEzj+aH7tSvGYW+qvFfoZgJcs05rozvXeoUdmxa5y4aCUCK+bdDYo9VN8
	DsIw0HRdWWt8YV9oVefX8BWunZgepzNX8mEKvpEzCX9mKfQWEEkMdZc/aWjFSpCTuozlXooyquirK
	2uJYMDLTe6MtOQJu9JpUmNNX8sQAlGY/68Toxhf0a1XSSZnwCiwSjziwKf7F+pR/ImGH31IIv7Yal
	eeppy33f1LWgUNABy4l3HzvWWuW3H3lN0ltSHSiNgxO0ihU1ab+HCe+0gBWijoEHl5ZMNd9JmayEU
	3Ky3buwA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJKu6-00000006fOS-2JLx;
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
Subject: [PATCH v4 03/16] slab: Remove folio references in memcg_slab_post_charge()
Date: Thu, 13 Nov 2025 00:09:17 +0000
Message-ID: <20251113000932.1589073-4-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251113000932.1589073-1-willy@infradead.org>
References: <20251113000932.1589073-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 9C1521A0004
X-Stat-Signature: 594wq7xqq6i68rubwncg1szz6rqk7s13
X-HE-Tag: 1762992601-434999
X-HE-Meta: U2FsdGVkX18IBLevCiJenUsO0FG4X12/d/KplK4fbitZVVkyrK2oyG2NKyS1hgZfxGznZIVkaOZIHrNhs9/woxLARexesZS4GToPBNeAoYRaBT5wguF/QIAi09o4QjRsSX9ct4Lyb6eqeV/yXLrG+lSRfxpl8TiyLHZnBybtO9xxHyGSEMS4YtSIGYi37R9AUXJjopHVK/bKSfGcW/yVS0xXV/L+0kMzjN3DrRrPjfP/zmBxmhWd1hKGSAuLuVsLAbzshB79MTsvDsYIXvmsOgDhys5XdWLbtI1dUUJ+ppUr7ieKpdXWFczJThkMVxN81GPpms/0am04kmrBqeFPE5dsHm7icod16IV2h0XvkKszDuGpUb5pbrg15sHS9U2SHwylWS4zAiK5vjISyJ1BZP1TuCC5bFg7tc1/q75fLOoXW+AdKjEHiQ7Rm0GbMJEQSGCXpyEALHdsgKfKDVy20s8jYoI3UTW7AiCY9ATipVzBtgk9VITKugerp6PhAcRl3ariTuz/O0zrAuGeWEIP5H2JUQLrxW/mMjQAeTmYNQ65RXZgt+rF07jTCI36qECvOS4GjwqvWCRebq+RXTac6ckb5+UX01NZ9xOzwE9HVW2Re52uX6cx5yhZubFqnYaVc7KWExB4LVvq4QWxiUmPE8pSRMuRVI7jz7iBmENkux4LhhezZkX08U1IiIiehXVIu35gvzpLtvAmQuiH4E6Um6aOgZWmAOck5efdXyt5YHHO90AaCXATd93JD935lG4A6EeFETohISAYur8LS2Ql9ZmdP0MHzvkXQdE1iz2mkeeHlEOkIN39HwtkidIMJrPYH0NEiktVfsM8dElt/2NEGqOUwIKIaqqH8feJzPrswA/S+/wg3x84n0P8fmm7afofCGyV1QFKVnMA9V9ByTQ+QoPkuN+GRU22PpUsaYP3wY20rlRusk2o8cso1hEKZcuyWoXtiU6HypvsTpDPd7z
 4Sv6ZzKP
 m5xro
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This allows us to skip the compound_head() call for large kmalloc
objects as the virt_to_page() call will always give us the head page
for the large kmalloc case.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
---
 mm/slub.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 7715c40672a7..ddfc9db4c6c1 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2376,33 +2376,34 @@ bool memcg_slab_post_charge(void *p, gfp_t flags)
 {
 	struct slabobj_ext *slab_exts;
 	struct kmem_cache *s;
-	struct folio *folio;
+	struct page *page;
 	struct slab *slab;
 	unsigned long off;
 
-	folio = virt_to_folio(p);
-	if (!folio_test_slab(folio)) {
+	page = virt_to_page(p);
+	if (PageLargeKmalloc(page)) {
+		unsigned int order;
 		int size;
 
-		if (folio_memcg_kmem(folio))
+		if (PageMemcgKmem(page))
 			return true;
 
-		if (__memcg_kmem_charge_page(folio_page(folio, 0), flags,
-					     folio_order(folio)))
+		order = large_kmalloc_order(page);
+		if (__memcg_kmem_charge_page(page, flags, order))
 			return false;
 
 		/*
-		 * This folio has already been accounted in the global stats but
+		 * This page has already been accounted in the global stats but
 		 * not in the memcg stats. So, subtract from the global and use
 		 * the interface which adds to both global and memcg stats.
 		 */
-		size = folio_size(folio);
-		node_stat_mod_folio(folio, NR_SLAB_UNRECLAIMABLE_B, -size);
-		lruvec_stat_mod_folio(folio, NR_SLAB_UNRECLAIMABLE_B, size);
+		size = PAGE_SIZE << order;
+		mod_node_page_state(page_pgdat(page), NR_SLAB_UNRECLAIMABLE_B, -size);
+		mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE_B, size);
 		return true;
 	}
 
-	slab = folio_slab(folio);
+	slab = page_slab(page);
 	s = slab->slab_cache;
 
 	/*
-- 
2.47.2


