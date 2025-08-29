Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68CF6CA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 19:10:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1CBB8E0002; Fri, 29 Aug 2025 15:10:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF4688E0001; Fri, 29 Aug 2025 15:10:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A321F8E0002; Fri, 29 Aug 2025 15:10:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9587F8E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:10:30 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1D4271406DD
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:10:30 +0000 (UTC)
X-FDA: 83830736220.22.FEFDC5E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf21.hostedemail.com (Postfix) with ESMTP id 43E7D1C0003
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:10:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="L/QNqxql"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756494628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SSNsVmqAkPZOUcrXGoKMXI8PeCeq54LG6hsCWxkDPlc=;
	b=fcn0U1J8Cl5c7SkwCx0RSU8VmHetm+MygYXVzndrbB7K1ocli5oxM9iEW4HLzIqt+BxxdL
	EfWujqWlf4CGF0EOnS616YWFeyNaU4pU3cBZ2N9oc4mNcbsdbAZx/HxOf2Zr5o/mjmiY1T
	TsM+mcnz1DozWlp1IxSiHffHAT6aSBs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="L/QNqxql";
	spf=none (imf21.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756494628; a=rsa-sha256;
	cv=none;
	b=V+DUCAEqEPhx3YU5Q+LN/j9IvayTuzbiukpF3ScSWNWwjG0ASzKn3VXByjoBMFr/jNNsKU
	Rl8iKzXvLfAkdZpNDkfNsMkJ+LrwJpsuKN+5dU3V5wD3FNnFEK92G7I7/a3VrFK85MxLWg
	KatDIkNPyQrLuyWYbfwW2KkHbw3yGAE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=SSNsVmqAkPZOUcrXGoKMXI8PeCeq54LG6hsCWxkDPlc=; b=L/QNqxqlCFSXbHyGh1vTJdJgBR
	f7QYBA2fIyw08EiRD3dnTpwWTrz2SrvNJZDVMasnGjejeNNXuVZ+3y+Z1pAJrTmSTzHN4lrWEEmtl
	7SiRlJkkI8NFwo1IaIcoRqgrn8vVcLzwY9/HtxvpVSaaH1hx8HwAwedXs6m8O3XqDoIxQGlz40Bcj
	uCETE0R2jKxuznTrKF9nhXVRdwG7rtBo28v0G7uNxOgVuKsS33z8MDb9hpmILEXjvd8ZRwg2lMiUu
	e+/0gAwLXK0pB+JGjXrv1ejHn44GQioyHYT5Rqr00y5lY+Qi17nun9hv1RezrqBfrX2y78ZnuaixQ
	Kt8oYErQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1us1K7-0000000EFwP-1hEQ;
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
Subject: [PATCH 07/22] slab: Remove folio references from __ksize()
Date: Fri, 29 Aug 2025 16:47:11 +0100
Message-ID: <20250829154728.3397606-8-willy@infradead.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250829154728.3397606-1-willy@infradead.org>
References: <20250829154728.3397606-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 43E7D1C0003
X-Rspam-User: 
X-Stat-Signature: r1fewyfruaq1w1gh53cnn7ngw8brhcjy
X-Rspamd-Server: rspam09
X-HE-Tag: 1756494628-619663
X-HE-Meta: U2FsdGVkX1/i7+2aKi9Mf7SxPcvbKoS5aUIWFeVWPXJyrWbHj3Fxkvf+/8T6+qC9m0nx1hgxYTYinZP/vG1+Z+fUllu62mOwyf3T9VwtM/iFhLqVDsDJnWvFWCFU0JTwr6UmcaJjEsNX6al/VVTtnd8PQbMX6eb8o0b/PwjuLnXcpKAm7iSXYfcMg5a6IwY0WmpOBhU6sqYCVWxdQdcWwVDBVVAeZ5ypEaEihXUuQetLPAzzO5WeS8fFw4ElF5lXmYJIFMlVrAqA517lKUeb0t1Z0dvVEjKd/ARCzrjRKwndLgH1M2Dwn+qPg/7HkH4f8aK5dRNC6pq6BmqfMxttPu4Pf0a2NUuUfKa3Xxs1XUw7aIwZryt1YlWGdPz8kH9CRbbGRwwuVtN/HTOgGPyVGhv05eldUyMx8fANbtD2W21XuMZXcHk5+CaZKCyIbBxzTyZh7y6JrHyCERCzVFj0x+jYyYESrnLtJz76fbk/Y1cFC2F0U6TZmmyqcAphWO4lnCEpMJVBM1P6OiFcIL47uTzKbk74YTqpO0B7tPgvvymCnPbYK5LV2mnxFXAL3sDO7QtetY7WTtPxbJxHjApwhNcxRJyXQwJdT7+qqxbmmeTqxHB0qUjkXfL3sXmjOAFh9TwmoleYrKn/AIBJ2AXQ+x5VyZ/uLh3khCTV93gl7z0onQl8bSpwiVHO94xf5tarePD9hJM9wm76GpdUYDmlDpv+lsLQjHSnvB27K52wC2/t2nMEe12Zb2bIdx4e5z32ykakSN0itZKH7c2JsBsvZEa7WskjPQeLLfR2mQrsUEMyfxgL2wxcjht17c+9lmy38MEfDCPuOgYLTUNQZKdL9oM6cc73hVqVYWVksmiSseuujW9b58Gr3eJAIJbUkxTu9mkfgemIef1LnIAFeycWF6RV4pmlWpYA1Ujyk/CHWDm/tKhHU6szBzhqIZ6OXhe5Eyf10yQXlrrVSrrOLZd
 MQyLOCuP
 u/m+hV9F0NgdFCJFIOjt7ANr82wye8yzqMYxPA8YIElH5dP595yqA9RsUrUUuE5S/JHNAqxazFwEwFxx7hedmY+Y2lc+OcMwjNIDRTzCBEdOGbcoMJdPfcPZ5RxX+Saifvqlm5oXHaK1uxfbld4Zl5kEIY0WUpQR+jhl3ZUznZFRU9QDkx0N6J66a82z1eZjZVp1TTIo8mq1zMk8clX/IwMsPS7So9JKzkJfHRJH7ptgpwUISoPuGPTcXdPU+HJRp9fCF0MzOoE4r1lM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the future, we will separate slab, folio and page from each other
and calling virt_to_folio() on an address allocated from slab will
return NULL.  Delay the conversion from struct page to struct slab
until we know we're not dealing with a large kmalloc allocation.

This deprecates calling ksize() on memory allocated by alloc_pages().
Today it becomes a warning and support will be removed entirely in
the future.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/page-flags.h |  2 +-
 mm/slab.h                  | 10 ++++++++++
 mm/slab_common.c           | 24 ++++++++++++++++--------
 3 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 39ed2f243279..f0f7b536b9e5 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -1068,7 +1068,7 @@ PAGE_TYPE_OPS(Zsmalloc, zsmalloc, zsmalloc)
  * Serialized with zone lock.
  */
 PAGE_TYPE_OPS(Unaccepted, unaccepted, unaccepted)
-FOLIO_TYPE_OPS(large_kmalloc, large_kmalloc)
+PAGE_TYPE_OPS(LargeKmalloc, large_kmalloc, large_kmalloc)
 
 /**
  * PageHuge - Determine if the page belongs to hugetlbfs
diff --git a/mm/slab.h b/mm/slab.h
index 084231394250..e3a85318a6e5 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -595,6 +595,16 @@ static inline size_t slab_ksize(const struct kmem_cache *s)
 	return s->size;
 }
 
+static inline unsigned int large_kmalloc_order(const struct page *page)
+{
+	return page[1].flags.f & 0xff;
+}
+
+static inline size_t large_kmalloc_size(const struct page *page)
+{
+	return PAGE_SIZE << large_kmalloc_order(page);
+}
+
 #ifdef CONFIG_SLUB_DEBUG
 void dump_unreclaimable_slab(void);
 #else
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 08f5baee1309..e017ed0cd438 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -994,26 +994,34 @@ void __init create_kmalloc_caches(void)
  */
 size_t __ksize(const void *object)
 {
-	struct folio *folio;
+	const struct page *page;
+	const struct slab *slab;
 
 	if (unlikely(object == ZERO_SIZE_PTR))
 		return 0;
 
-	folio = virt_to_folio(object);
+	page = virt_to_page(object);
+
+	if (unlikely(PageLargeKmalloc(page))) {
+		size_t size = large_kmalloc_size(page);
 
-	if (unlikely(!folio_test_slab(folio))) {
-		if (WARN_ON(folio_size(folio) <= KMALLOC_MAX_CACHE_SIZE))
+		if (WARN_ON(size <= KMALLOC_MAX_CACHE_SIZE))
 			return 0;
-		if (WARN_ON(object != folio_address(folio)))
+		if (WARN_ON(object != page_address(page)))
 			return 0;
-		return folio_size(folio);
+		return size;
 	}
 
+	/* Delete this after we're sure there are no users */
+	if (WARN_ON(!PageSlab(page)))
+		return page_size(page);
+
+	slab = page_slab(page);
 #ifdef CONFIG_SLUB_DEBUG
-	skip_orig_size_check(folio_slab(folio)->slab_cache, object);
+	skip_orig_size_check(slab->slab_cache, object);
 #endif
 
-	return slab_ksize(folio_slab(folio)->slab_cache);
+	return slab_ksize(slab->slab_cache);
 }
 
 gfp_t kmalloc_fix_flags(gfp_t flags)
-- 
2.47.2


