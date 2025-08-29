Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B210CA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 18:30:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EB756B000D; Fri, 29 Aug 2025 14:30:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C3326B000E; Fri, 29 Aug 2025 14:30:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FF866B0022; Fri, 29 Aug 2025 14:30:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F7B06B000D
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 14:30:31 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C6209BB9E9
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:30:30 +0000 (UTC)
X-FDA: 83830635420.17.9103626
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id 09652180016
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:30:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=L3aCWzIM
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756492229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RAfhMp+e/jYgcCt5xNbmP+TBHcH2De6I1nW9KZHIuVo=;
	b=rY5gEnTPtdURBfAoH43bm+/EEEKpU7Omf/wMDxpjpQtYomTPzySDCe5FgTeiiBr6AnE93x
	TmgT2vBoPtYZcDiROXZSUU98XQkf/cBMDyh4fnegHWuqV5Vc3MfU1/NTCJZgeSGP+rvgZA
	3ApZTY2ldcLqkqTBELWx9s04gdYsrZ0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=L3aCWzIM;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756492229; a=rsa-sha256;
	cv=none;
	b=w8sBfsMpwyPlpMnc2MUefLpDHw+v4xbA6n7pXjFC+sXjwgGOFPhuqRwPV4mLZf+B1yqkgS
	0rcG19sLxKvjreJdX8ay08XTHMHldiUXS8YiTpHdxsCOPk/57cYIcreXtzfFlMu4PNFU31
	kLxUkjfILMqeyotk/6H15FKFUjFTu5Q=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=RAfhMp+e/jYgcCt5xNbmP+TBHcH2De6I1nW9KZHIuVo=; b=L3aCWzIMX+LtJnh0oPb1T9Gkom
	T8m3bJfKlyuRm1cYEWkiw2wIAwUYclL5uvgt5acOorC+HBq+CnEr29Z1/qSrZa0cSKILKreinzaQA
	/tqQ78jXI+mtHbwot83Qf92rLOAl5iGm8x/cvrOVvZHn8hG4iUgXeFTytyNWNISeKt+X73FD/qESf
	8KCLMgVutvBcQLkVl1p+tofo/mCXtWycw2xTI2dETXVQT5LdKUpb5K/cIxUvECm7nkD45DBdCkIxX
	XaSTxbxgkYE/tPckvohZaML4hwoy+RIxFkJiDEKg6Bw1ptSqtExXFu9PEdVt9Jz8swHveiWLE6Iv2
	Cnx7aGUA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1us1K8-0000000EFxa-10hp;
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
Subject: [PATCH 15/22] slab: Remove folio references from build_detached_freelist()
Date: Fri, 29 Aug 2025 16:47:19 +0100
Message-ID: <20250829154728.3397606-16-willy@infradead.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250829154728.3397606-1-willy@infradead.org>
References: <20250829154728.3397606-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 09652180016
X-Stat-Signature: xtoaweyknx5m7w7jkigxuh68gdz5y7nd
X-Rspam-User: 
X-HE-Tag: 1756492228-511220
X-HE-Meta: U2FsdGVkX19pt4/VlMagwQS2OtQRSpvCw5a3fufP98N0zyg3jiMuDWm5R6tI0DLIl2/rr6mQf9S0cmWYpWZVhRLhKrHnhSFla2t4FVo0MvDqBWAfJ2Zy/QEQWYMy1SYYvyZklOxMo+X3ypwrckVcWOD24Kb6ccaQvx0qIuZ6a4KdG87wNjLncWJLNnpQzCj+8GMFMhe/Yz4yhMUDiHioCjCu844fyoXVY0grOxuG9CMEbequmxov1wo3X2a/WUmOXfeXdjidfRHymrySuZugUz079uHycZ/n5gg4mTpJnvkn3j50E4T+Y+e9+8gZeSrAtyvRnu9WIoCXZx4D1qii3qAR6LarLKOjm3BVfd6iVJ8ylr75wzqMy0VlYHxFLzZnBJv0FzwrgGySnUTbr3r49DyTwpxyBLppu3iIfmmIE+x0nJd2duFDPrvnK6XzQ4fDkiAnqQY2Qn18PqrXwFcUV2PorchDaj7pMVptuoX/OST95Fc9OP/VeGeB5AiEKLEBnUNKkOjgoVmzMROI5VuqhZhxkUF6+Ft8AJxjzzeJ3vgC43DfUWoLLmcAOy8lWmMdHt3na97QgeyNMTql9L39tVWt/uyGCoyX8SCYqSdNWukovq4ulbf8YXoGyiTQuTEVJAROBqObhpuKwAHiax3sHr0khNqj/jpE08PBX70j5Dk2tDeYTlYce7Fcheyu0DSJ84N1/27bJi3hJT0EljgQhNdGxL1bjWAmfndTEwzWzbf4HiG/9NlXCX/8qma7ne9pLMCFal/e1GLAvl4zMT2eao7fnWbC/9FfmW1JM4QHDogPuykVhVlUPKwU/DpbY9I4sRBkJV4hfs3YZr38OjjuTLINhyAOeUInz69csmyeJYOKAduD+SQMEiJOJSZgLPTyi+WH5+esJBrqfKWryM4qItVK2KIoWpiLWSNnsweMxMEP2DEN0zQzvq7r0Te3OWhY3ladWHuU2798VlS2CAg
 api4cZ63
 g/qSmTDdJyJCc/wey8kpJFv0oenP7mp5YkBc/xNjPadkZ9Uj7JN/SCSCd1fOnwBzk+onYmhX8eVe+grfy8+11UP9ajaIv7BcL+gT2HzOq56AVs18oDp4paR2Lh4NelsuW3Jx5K7hAqIQFd0mcMrUGd4krqfFgEnQNLt4/2jZPfZmqmHFJW8uB75/j0N0rOjgBoBAC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As with memcg_slab_post_charge(), we save a call to compound_head() for
large kmallocs.  This has a slight change of behaviour in that non-slab,
non-kmalloc pointers will now cause a NULL pointer dereference rather
than a warning.  We could add that back if really needed.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/slub.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index f31206e5c89a..af3e7ef30b5d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6633,23 +6633,23 @@ int build_detached_freelist(struct kmem_cache *s, size_t size,
 {
 	int lookahead = 3;
 	void *object;
-	struct folio *folio;
+	struct page *page;
 	size_t same;
 
 	object = p[--size];
-	folio = virt_to_folio(object);
+	page = virt_to_page(object);
 	if (!s) {
 		/* Handle kalloc'ed objects */
-		if (unlikely(!folio_test_slab(folio))) {
-			free_large_kmalloc(&folio->page, object);
+		if (unlikely(PageLargeKmalloc(page))) {
+			free_large_kmalloc(page, object);
 			df->slab = NULL;
 			return size;
 		}
 		/* Derive kmem_cache from object */
-		df->slab = folio_slab(folio);
+		df->slab = page_slab(page);
 		df->s = df->slab->slab_cache;
 	} else {
-		df->slab = folio_slab(folio);
+		df->slab = page_slab(page);
 		df->s = cache_from_obj(s, object); /* Support for memcg */
 	}
 
-- 
2.47.2


