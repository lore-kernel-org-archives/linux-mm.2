Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C148CCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 20:44:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92FF08E0107; Fri, 24 Oct 2025 16:44:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F6F68E0106; Fri, 24 Oct 2025 16:44:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C0A48E0107; Fri, 24 Oct 2025 16:44:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 540B58E0106
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:44:48 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3232D129E8B
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:44:48 +0000 (UTC)
X-FDA: 84034186656.29.79C711E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf04.hostedemail.com (Postfix) with ESMTP id 83D2F40009
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:44:46 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=IJQJtRnD
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761338686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=woaaYE/yBaGlo76779ig5r4oT+eTNHEPhBAUr1c0org=;
	b=7CiDMFqtPnhRoX/8fCew/3A2CtLlethZ+oJG0ZLaaoUjkEBUM7uQH5Uub2feTYvHMNeXYy
	gsi860vuRmGqH/czGi3jLc39dEC0iJIWWzD3JV5k1GakAuNVkvSux0sJscQ3gvgmb83C4q
	0RUHwhToFDbQKFe6dgPFNPI0fBxSum8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761338686; a=rsa-sha256;
	cv=none;
	b=50bxvY2oLfXY18mXUw0qP8JKc5BzWSflr6Dl9t434XZFUwoLKVzdAt6lMpjaUCWrOev8z2
	6yfgksPW++Rl3z+1/WUUK0MbqpEo6SXU4uJqsn8Ue6I9GrxTy8d0I8mbJSalWrsjtlbGei
	8n+D3Vo6/8TXD9OkirzZ9cMrUmex/SI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=IJQJtRnD;
	dmarc=none;
	spf=none (imf04.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=woaaYE/yBaGlo76779ig5r4oT+eTNHEPhBAUr1c0org=; b=IJQJtRnDqD7GK/7IRAqz5xUrW7
	L+9fe5OZUiic8xuUf2oofWZfThISkK4hZxrDjoJcY4yImX4aUy2TZdePMP4UbUnOvERpckHUKowX/
	tZbfoqLKXhwa9ZoaIVyaJ/DPDFhJa0i3CrEkv7nKwYgkNsUHHZc5PKPcG+hYhJDIIa7Wed/HnhK0T
	2rQHz9QwSoKFYoYZZ8hnjzeOET5vnNDxj284J5KgvP/HheEYvNjgEMXSYMcGO6uvEegB1VOJ7288M
	eHs9NW2VPByGGT0Xp82cuSF/5cKB6pmFTbXlyTtL9cZmKZADlMFZJLhrxiwbi1q8l3f7zgJwDlNLc
	KobpEbeA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vCOeO-0000000AKSQ-05ut;
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
Subject: [PATCH v3 08/17] slab: Remove folio references from kvfree()
Date: Fri, 24 Oct 2025 21:44:23 +0100
Message-ID: <20251024204434.2461319-9-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251024204434.2461319-1-willy@infradead.org>
References: <20251024204434.2461319-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: din1ejim5qxcngtwxtp7y4hqp7zz786m
X-Rspam-User: 
X-Rspamd-Queue-Id: 83D2F40009
X-HE-Tag: 1761338686-662165
X-HE-Meta: U2FsdGVkX18lNTMTlUIGz8cs/ju+z0Ib18Gtf1VxXrMf2IJSnHhmYEO2/CWHFFWf5Z+V7t7uU9ttuknvoQ3daxLrmd9OAFI5V8GdutTG35up+HjD5ernXs35XBPj7EoIAE33b9DktilIBmP2RNOPs2pltftrL2CpLbvTPV+DzNCv3U1fR7XjiorYVS0e+I5NxueVQsN0G6Qtn1ff61DLYIbKIzKJHvfZ4AWOlRnCYJSTRCqVVC59dAVKZHBJnymsfLbNxAk8lniC7s3V4M/FILxCRJcmS7p7CIZ22P/Cmx/HLi+9r5rYhGEg9nV0L1Dz3EOwsRIJsaDWgJLB4NZk21bhAonbfbkSTB9X8KEFSqOEcXDwgikRIfU5HrW5ZGj7r9fwvQ8fiUazniZ1sAMlAqAUVphmP2tNThV+7KyQF7RZTQ9l65cExdp209Xp72ZmJv9u/+GUXBQg4WZ6b94CxRc7ccSB8XQYstp2iJIuga50EvGnoxi6yCWw8aga9o7H2gn5baM1S2DFtYzWsj3wNiX96vSHutq/REifhSG9UFTJPTr0PxuC8kF6pAmparPbss6KoyKEnreeFArzOVMalD/ZnI3icV0r34etlJvbRhgOG0BySSzZRK6iZRUqW4orybz+za5bRk+gwlMJg57oiWZFYAvzXw4G0JHVjLBiFCxr6M4tm3HgDRtT1V90stKfSkXnE4qrcYXyKBwRVilULvV4McEKOa1+3vs9CB1s3htT17u9wTQlLrOhw7X8+0BLRGPpax6yfuWJDz76y4TYwygSgxM8P9qIylrAyredC5iXFBbi/lkNitl5nkcFftjVpTPt+ml7PB7/jGCX4IzGNcABxutR9z7kLVyshZek79U7SutpXpxze0acMtmh9khAONbgTr/gMuGLlQrKOyuXSfoRM+hUy71BuQpIGJmq+VahHeaiTh0QrGyQlpyKdRqmY8cY9XK4bKWsEoxFcpX
 OZQXCE9q
 1chqdLTKVUM3DLSuhxMZPqabNTtgGX9OdA1ACsMov1B5AGb+hs84rqtPYnY5qp4m5i3mdWA7yEfbike5yAWhWMV/mzU/k+XXrowz7hBuDfOx6G1X1tYFh5L4FtzBr+QGRA1fLYbHA7aklT6SQrl7Q8idwzeIFI1/LdpAgtBQWIdrXtX+MdwLZkZwfDQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As with memcg_slab_post_charge(), we save a call to compound_head()
for large kmallocs.  This has a slight change of behaviour in that
non-vmalloc, non-slab, non-kmalloc pointers will now cause a NULL
pointer dereference rather than a warning.  We could add that back if
really needed.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/slub.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index debe7132b343..100ed979312d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6809,7 +6809,7 @@ void kvfree_rcu_cb(struct rcu_head *head)
  */
 void kfree(const void *object)
 {
-	struct folio *folio;
+	struct page *page;
 	struct slab *slab;
 	struct kmem_cache *s;
 	void *x = (void *)object;
@@ -6819,13 +6819,13 @@ void kfree(const void *object)
 	if (unlikely(ZERO_OR_NULL_PTR(object)))
 		return;
 
-	folio = virt_to_folio(object);
-	if (unlikely(!folio_test_slab(folio))) {
-		free_large_kmalloc(&folio->page, (void *)object);
+	page = virt_to_page(object);
+	if (unlikely(PageLargeKmalloc(page))) {
+		free_large_kmalloc(page, (void *)object);
 		return;
 	}
 
-	slab = folio_slab(folio);
+	slab = page_slab(page);
 	s = slab->slab_cache;
 	slab_free(s, slab, x, _RET_IP_);
 }
-- 
2.47.2


