Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88D51CCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 20:47:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11B4D8E0115; Fri, 24 Oct 2025 16:45:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07D6E8E0112; Fri, 24 Oct 2025 16:45:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAE948E0115; Fri, 24 Oct 2025 16:45:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D589A8E0112
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:45:08 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A403D13C55C
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:45:08 +0000 (UTC)
X-FDA: 84034187496.20.D18C149
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3C8A51A000E
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:45:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=grKXqIW1
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761338707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xi0chut0Zn5EfsUQidD+3ryajMRdIyWV/pXsdDjiKwo=;
	b=vNMOCJdNmJPJKw/wqd3Wj6sCNT9cejt07ZzhcRa+ceQInIo9wrowJCcT+aCRElk+wl4fe1
	md+jYUUoXv6Z/MyQh9zYBS5wfIti0hj8R8QWODosrfh2eZhAvEUnb15FqYLbnuIpG8EdPS
	XNsb1V+GAUHmrzYxhUqrIxlZ6Pf5APY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761338707; a=rsa-sha256;
	cv=none;
	b=1YcEGS/MSMYKaP8sx2kHB3vbLmc5GIvQzrmWPNVlc0tNS5rBpYOKSB+0RpT7eDAGAzP5rk
	tQ2Zty2YsrgORmKDkwP4tpolhQ52ukIaxs+1FGCm0EHznkqg0aGJwYw7qGVWPMNGpMKAx7
	X1ghoSSJGPe5W9WGjOYuAw8ZgkhjBds=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=grKXqIW1;
	dmarc=none;
	spf=none (imf19.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=Xi0chut0Zn5EfsUQidD+3ryajMRdIyWV/pXsdDjiKwo=; b=grKXqIW1WPQ6om/Xn8epHW2azQ
	o8QF7D+8xJufQjDXOB6fbDq9QlgoZPWOf2+eyeFGFqQb5ixGFJDUQW1mVDy/lWKwFRD5UsGSxeAFl
	k6j08JobEgLQqwQEYNw+1YMInSCE8Zd1vfa7ZpSuKW9VaC41aWf+yy0e7cvqd9wEhQvX7wna5bI4B
	CYFNWyHGwOb/MQeoL4Nw3pJVpCmLs+nSnYJWIuj036GfFkRRyf59PG/he1vrOrkQ2ybU0j6ItVnMz
	1kwKBHl0M0hDGZ3TJawl7L1wHRZb1uYCs6/nPqQKatmuFy4XKu4C0h1gL3LubNp8alT4CuSurp1EN
	RrGuSVKA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vCOeO-0000000AKUp-2wpn;
	Fri, 24 Oct 2025 20:44:40 +0000
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
Subject: [PATCH v3 16/17] kasan: Remove references to folio in __kasan_mempool_poison_object()
Date: Fri, 24 Oct 2025 21:44:31 +0100
Message-ID: <20251024204434.2461319-17-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251024204434.2461319-1-willy@infradead.org>
References: <20251024204434.2461319-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3C8A51A000E
X-Rspamd-Server: rspam02
X-Stat-Signature: ixi7tkcj4k4ndpyk4xgowjigqoe8xgf3
X-HE-Tag: 1761338707-518586
X-HE-Meta: U2FsdGVkX19xHdv0bC8S1QEheJzUAEetZP04Cx7MSKreMDykUwb1kjvIOlQMrgMtEpB6mFPAwrX21FK15oYQCGuOz53YGojyQ9iz/gIDiN38qxe/cHaVRXrC1XU9ZvE9YC8ZZfVsXvSgi+nBim1wHYS2GbSq46LBvk+EdNGWRlG5ab0MQiP+NemxfV/5qr4DuzKE739HEpTd2iHtXe9koZfhUpLtKFtt76SITZhsMhWTIwVUBUhBJKxrL8JV5XYXeEX3qEORoWRq/g4HXGpGrgHHO0xKT2kmMz/FiXqJZ1rJmqryUqKiVzS2gvpeSvikANZuVK3xp6Xm+dcTtBoydEwhofE3Zt0SF5q0gMFltt2MJssS9uviTa/MLMa4lCyayddO6m61uwj6gw/RBOyMhInrANr0qMaYKwMYNjLmR12CFEkZ6KFVhLF4u3AudRQ06LeBE/N8H16jDxAPWELXNje+nEBjFW8AUv3U4UHYnlYPzv7M30RQxtfaWfMmEH03B0eTx0G0bt47sc8H04+XASLrhrDtqj/e7j6WNPO+nIP0YpgaTCFKSnNWyK9pDSYOGhS3udwY092ckf5TF3HzuUMlhqFy8paUS6COFH+D6b2x7ddSKARz5FrQOTYtqU5W/l29Gl0E5v8YYc80SyUJ/f+NA67lgMXBQk56hF/vgJS2eB/RPK2SqVEuyXQWwHEd+LRV//2U8FQlH/tdp/xgNAFtixWwIApbu+9B1xsNDcknFyOKiWqyxL+wVQDmyrCuSg+WB+AZ2T4YYx95G6GXREKE/iBQz3WlS6DBZo9XapO49V4CC9y1HAciRC4dC4HM3/h2kx9jGjP0f2JrdjZMfitu8l72fYb+RhgjbW+odJBan5MZoSA4ZLZJnrrnX0U03Z8x7wOR2AnYFMg7sKQo5A==
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
index 22e5d67ff064..1d27f1bd260b 100644
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


