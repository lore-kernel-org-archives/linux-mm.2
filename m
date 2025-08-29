Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4367CA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 15:47:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94C4C8E0016; Fri, 29 Aug 2025 11:47:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AF808E0011; Fri, 29 Aug 2025 11:47:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 775E88E0016; Fri, 29 Aug 2025 11:47:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 580838E0011
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:47:41 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1EE6885570
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:47:41 +0000 (UTC)
X-FDA: 83830225122.18.30C02D1
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf12.hostedemail.com (Postfix) with ESMTP id AAC7440004
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:47:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=sqCJ6Nma
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756482459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Qtmeml9ONcrr2VBMLBz1K9AzwlLIb8CwxjaKAjMEvQ=;
	b=eOq06/g3arWN37Aa3N1rh8uHaEwP+zaUhvpGomae8d5xr1dE7jL8NSN3YthC4yNFvIG/rR
	7Om4q31YSs7pPTW2+luWJVbEDmtBXqg6TIr2USsfizJxh7q1lslBx3IRKasBCFJHtxbtoB
	vZH0a+7KCTjt105N++ulUJP/D7d+o1E=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=sqCJ6Nma;
	spf=none (imf12.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756482459; a=rsa-sha256;
	cv=none;
	b=GYSxnOiU534dfHDSvhXU6q4r/kJz9fYfbkTatd3SS+9WhtuJtY7d4HYpdhxUalH17t6QgT
	rbAKvLemWJ4tyLuBD/o8C1kp+xi1Ju3GVezNfpxiDX9sI2V/V1udtZgnJJ1AxyTbXbfoA/
	HZuF8E8CELZgl7OChklW9Q4FgGTVPXc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=8Qtmeml9ONcrr2VBMLBz1K9AzwlLIb8CwxjaKAjMEvQ=; b=sqCJ6NmaYk0+siuROiXd3t9k+u
	YEe8IeuPFHBthy4Ks9nxqfT60hUZcfQ/Q9hI7ClFuJhm76LbZ8IPxbB6HhTYhfVnUZWaMXpw2b6bQ
	scXyOMzb0fIDzdZ3MDyXfhUA0Jieggs+3gMAH0ozepCydnMiUcu4diGJSsmVnfACZ/PT45rP1Ntwo
	rG8N7XP/t0xgtFKZ49NxfQDzBw6uRc3Bsf9uxpZK7JhdahmgPxM0pRqIA2rh195QP3AuNo+dJcc4M
	XXiDZWwinc3vHFZNNxVi7IIycLyKLh2Y/Je0sjQtCxPJ1vGA4ry7+puf+v5t3APOBgGSKAwuPFjyn
	daxvNWqA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1us1K8-0000000EFyH-2s1d;
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
Subject: [PATCH 20/22] kasan: Remove references to folio in __kasan_mempool_poison_object()
Date: Fri, 29 Aug 2025 16:47:24 +0100
Message-ID: <20250829154728.3397606-21-willy@infradead.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250829154728.3397606-1-willy@infradead.org>
References: <20250829154728.3397606-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AAC7440004
X-Stat-Signature: 1aop9yt11z4yqhoc7wgszwbitwpfzf1c
X-Rspam-User: 
X-HE-Tag: 1756482459-942931
X-HE-Meta: U2FsdGVkX1+m55zI+FXGu918IdLtGFwOrMMRsKgCNplfGhZOqlROpdumfB6cy7kYnrME1zuFEIIR3XXtMi75qR48uVTbn89EBk6Cr+lWXzxbB0y2WMuz09rROA4qFJU7yffCMt0g6kBKrvt8QKCWN4XwGzz1nrnu7poRT6GqkaftXXpyEeiMaPOvP/OSYf3lZCY2P1rGtG8t8Ww79Q6F90pOIUtr72JC2EOBnOb6awniCRpykrYoYXId15ETADwBs8BeORcK/q3qOF+KS82ZWNmyNSBZ0+62BB+OpluDbW+hBdstoS/3lpho8ZVenPUUM+RtKgV4ErXy35UhHDsKKdjKqlb7wVfsefbhdwiVYWvqwETgIfwj1UfnqyCz5XjjYAedLPqH+gn91s4XSvknBbwpqVpDgMoNZudfZpjHyOALRCU8yFws+hpgCNhoCCwWsUmoAJYTLuF1S5tmVHR8Q49vXeZswcgUfYIzV1xRI9bBWdOc1wIriE/BZlsUrGkNAMifLAYk3XzbYTo/+5I8JUHEkokVl1uWjFeZsn0y+BlZRTwjgx0+4FGINUbsB06QcRoeMeqZo/Tf/Z6ZRn4VRRkHmnHkkeEpKQoTGo/GW4ujyztkujySCunR5Q3wq+bWH/7b5up/xVOPTwWzv9ZQAF9izL+cdY/cwzBJTj4/ax1McOwmpnXWlVAE1oNG0GWpYvnzHw4zqvnICuFHr/ab/FKStiT3hGGnEHbvrlX1yLVQ+5yd/h1zeSq6c7i5MhNJw03/C432h2ZlvcyK2aoAeZb01sgGseFTYfNKjC12V6Wrk0gfzq+z4fvTcRSf51F6w7XlJcqfuNWHou8sKkUwVIYO2F1c74JNgPqjBQFJnL1kEpmZSTiWpZUgdtBkywsOA/U03F1q6g94YECHP+1BVw==
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


