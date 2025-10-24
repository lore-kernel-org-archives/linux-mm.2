Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C10DECCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 20:44:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C2888E0109; Fri, 24 Oct 2025 16:44:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 623878E0108; Fri, 24 Oct 2025 16:44:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 279028E0107; Fri, 24 Oct 2025 16:44:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 122898E0106
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:44:48 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D10E3129E8B
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:44:47 +0000 (UTC)
X-FDA: 84034186614.27.6D9947A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3BE0A100010
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:44:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=wBZxVZXn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761338686; a=rsa-sha256;
	cv=none;
	b=KvqMW2D0S09/nvXT3PLBuC3d64UBZq8doPr5rCyBY1Jto4Ihu71WqCb4DJm78FqGWpNpJe
	UmpZpFBd07TP90bjHG+WYRjl6MDOoq9cZ8kiLdXjHc2MlCIYi9P6pw2sDwsvFKtNtZfjCW
	y5M+9yRMx06sm3XLAV1p4fedTJ9k+AQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=wBZxVZXn;
	spf=none (imf05.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761338686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=957dwkdyrRLRxtuB83F6lWAnh0+jZIZmYtBOnlNy69s=;
	b=39qIQWO9M9aOuahnyg0n0UnItBLQC5ulSBvAx5libij21CBztlofvCkL/zu5moqXz9TJor
	q2fhAOCYq1c2FMvN6BvXMXk8OvqFeMTKLMmM2yj8NWGdZ6kcKJg/4pz6HFb60NcwDotnRH
	ekH+n28pNiuNuKGp+Rp+P8nveSlm1z4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=957dwkdyrRLRxtuB83F6lWAnh0+jZIZmYtBOnlNy69s=; b=wBZxVZXnHrVYyYtHdb0U9CSx5T
	ckS2R88HnFKIqCWBLbj+1xYlvGlKyLCUY8tzQp6vhsyIOsSVHSSKEcdPsgI/H8RS9DvsM0q/AibLk
	DEUlrNa1RBgpE3P44FP0ITJxan2sfhyHm5qS3rTi5Yv/ZpwLuzOdAbN/0GZPPGGl5GKdBuSpSpKBV
	VuLFzMt3R2hhVJwnNdkIG/I30IdKpztbd3TUaT0GupO5qwrJo4pK2qLwo/glQbQreIBM4fVIeA+y1
	w43QuhqpYGA1olvpC8Ru0wX7ZOGwrSM3I14G/xbi9M49/707M1pI2j+0wyfSThbzyGz5CKB4kMmtU
	M6JkpdWA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vCOeN-0000000AKRe-39Tu;
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
Subject: [PATCH v3 05/17] slab: Remove folio references from ___kmalloc_large_node()
Date: Fri, 24 Oct 2025 21:44:20 +0100
Message-ID: <20251024204434.2461319-6-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251024204434.2461319-1-willy@infradead.org>
References: <20251024204434.2461319-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: seeagagohqdpkb9yd85gykh8jfyipq39
X-Rspamd-Queue-Id: 3BE0A100010
X-Rspamd-Server: rspam09
X-HE-Tag: 1761338686-929462
X-HE-Meta: U2FsdGVkX1+4WRn+tzOECh0MPdW10tXVU4nh5telJVk5KbfS9Wkb0xDwkmuD/Ibb3KXskVRKm27NAayy7C6dmh49ST6HgqJB/BqalK2eA4SIX+YGApCIYEJbfZoDMqIZj3+/ShhGQ649H4YYWjfL4PE0vix+GucgX/yayGdtpvET9om6Vdox2z7z5Lujk+gVU7rQ4wyC17CK32p3Y14piOLd2fKBEUxRYAaXw22Y9BKW4+IriOMmx4fnJNUywovQBQ5IzNgXrdCnZHtXEJ5y4RlJnco6SIRkbgCg4NrdsN2orBp/wjPv5wiiYL2cJcB1Edj5XsitDRx+kKoU95JVVOzjDaFi4KcpwJwOVWxUcUEo7MnFXvIs+1OhYFh2d1wcVuXOsCfzFNHhSXX9ffWjCE3a26E5Vc7lT67OZeXTSGyITSJlLRSmvFkLtBZuRohmBuJi5/vEJvrrb65l6gxmMNiBoupcreBo8pd4dcolN3G3UEWnsaM1cooklo4r47lJHTBr5HDhrrwtiY4j2U5x9UbEhjRtTVGupMYyPmHBCD1dteqC2VfHBhvOuGY4pVPh/clh2lkzSY04qNlVTjNK1Jdiw9aAc3hyl69lvnYLbX0FYC1pu1hg5F4dcuPZVg6Z0o1PIHwg9TUF2+nmC8mDGVyuMiPzmtGcV/PDcKT2XdTmMtQIo3E6nGjQrdOSNbUlyneYWOmMXLbcl0x8OTcZO+CC86y9NQFY2jHDbEaQVz4WwEkYlveyPrPLaBgdw5gh/Xe1lLhPN3DixbjejfpoMONeQMqBcGQTqBNQrj+gLgSVOErRHZzi7J4wnHC8RZLDJ2b/UudTPefqathgPwJUcJkI9Ozsps8gIkBpTm6bzS5DY968ttORk5OemhJuOAR6Tn/IRKupxYWIv0fyRel0KGQF7R9Vvg6flO2Pn19PpvCag0pn1k8/dqhLZjTPH13uPNeEwRkty0bliHPHjP4
 4BfApMCh
 aYRfGKUnFEvd2+ifc+ekBSvEk/C3YsWpupicY+6xEFr4Ba7idTfIh6pYbIADB44iIuMzkfjNu3KNddxUuzbvvakKaLny58GIfzYZGIVesNWHSEfc+ypOJF7qZb1AB/4ynv6bVZoSTOr6NdH6LYfcVzJqJf+1Oy8ANHxfXJzgXu9PpO2lNsoPrgporAqD0cXzr+nbUFg48pTtqL3hZtnDUzQqVgeJGEmt/CqG6tct9p+ijG4k=
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
 mm/slub.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index fb4a43a16269..8bf7d818d13b 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5566,7 +5566,7 @@ unsigned int kmem_cache_sheaf_size(struct slab_sheaf *sheaf)
  */
 static void *___kmalloc_large_node(size_t size, gfp_t flags, int node)
 {
-	struct folio *folio;
+	struct page *page;
 	void *ptr = NULL;
 	unsigned int order = get_order(size);
 
@@ -5576,15 +5576,15 @@ static void *___kmalloc_large_node(size_t size, gfp_t flags, int node)
 	flags |= __GFP_COMP;
 
 	if (node == NUMA_NO_NODE)
-		folio = (struct folio *)alloc_frozen_pages_noprof(flags, order);
+		page = alloc_frozen_pages_noprof(flags, order);
 	else
-		folio = (struct folio *)__alloc_frozen_pages_noprof(flags, order, node, NULL);
+		page = __alloc_frozen_pages_noprof(flags, order, node, NULL);
 
-	if (folio) {
-		ptr = folio_address(folio);
-		lruvec_stat_mod_folio(folio, NR_SLAB_UNRECLAIMABLE_B,
+	if (page) {
+		ptr = page_address(page);
+		mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE_B,
 				      PAGE_SIZE << order);
-		__folio_set_large_kmalloc(folio);
+		__SetPageLargeKmalloc(page);
 	}
 
 	ptr = kasan_kmalloc_large(ptr, size, flags);
-- 
2.47.2


