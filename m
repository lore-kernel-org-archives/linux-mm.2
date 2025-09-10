Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F29E1CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 12:51:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37A3D8E0006; Wed, 10 Sep 2025 08:51:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 352308E0002; Wed, 10 Sep 2025 08:51:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28F018E0006; Wed, 10 Sep 2025 08:51:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1568E8E0002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:51:26 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AF04486FA2
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:51:25 +0000 (UTC)
X-FDA: 83873326530.25.395A13F
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id CC269A0011
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:51:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=BqRZ4jP9
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757508684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S2f01htXH8N+CIEor6uAxDcWxjOWvAGL7YqE7Lw5Hy8=;
	b=0VFAJ/qtMpMMInKvuk02aGsW+yHbT/XOVt4kw5CdUw1z+E+TguY9Mburrly1UShymWgKx+
	QHaGuDiVBihsmxVbX/Qsd7uRZV85UcmMIMwiVPYk6OoasO37EKY6eR/LyWUKrf+hpniJH6
	lV9UavoKcXsWEksINC/RfARgUTCas9U=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=BqRZ4jP9;
	spf=none (imf15.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757508684; a=rsa-sha256;
	cv=none;
	b=AoPebnKJJZe++yrzik/nWDbwGNF6EwJJa8V9gQZBEbSnNEYGbtULOW+zIaMIO3YkNxuoGg
	DXThTwl8xac1M87eS5D9wmYfVHdx6qEfLcA1qtkfrE9R5j0uMuB/i4r3+LKGTNWJuckJW3
	GtJc2cTrQSQmWwLfz9pnfBMpjbJAl68=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=S2f01htXH8N+CIEor6uAxDcWxjOWvAGL7YqE7Lw5Hy8=; b=BqRZ4jP95H8y3+NmRjf65BowOr
	C9ZC24OpMq3sLvT4ogVWsOU1yZ6i8XL8v6wokSd3TREVm1z8cPZak/ybS/Ex5x8VPsXmtW7MiADDb
	Y2iP7z6KJ/EwybScaXu0IZIlTLQPtK9XfrvqIEuVVUiz7lAMz/ruwjK7KLtZX9m19s97FC5MzEGkh
	SO08+ZNx+N9ULTKZr084dHCDlaGpauJsJWtzjIY+14l0t9tSU9T2k910mgTm9hRFErkFmfddHQODj
	qCce25wSsPlc1x7NzmSJp1OZ4wyMhZd72gmfX7P3RZZhHLH6woS1prDLsLKuKQtEZcGTr7L5PFbMB
	O+Rz0r7Q==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uwJPp-00000008MEr-22IF;
	Wed, 10 Sep 2025 11:55:09 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH v2 07/22] slab: Remove folio references from __ksize()
Date: Wed, 10 Sep 2025 12:54:49 +0100
Message-ID: <20250910115507.1991829-8-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910115507.1991829-1-willy@infradead.org>
References: <20250910115507.1991829-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CC269A0011
X-Stat-Signature: 9g7denunfehpwpsg479q6o9ufpjjjoz6
X-HE-Tag: 1757508683-649223
X-HE-Meta: U2FsdGVkX199D5h3BwQq9bWbi2a1HZVlhv77lGSjELs3koKn5O2Yke35d6QfM8EF8bo0RQJwj05znlEaE56jbHp4vCmfwmpl3dJXHk2Q2xrUBffScmKfmDyUynbZrsNxcg0K3wGSkYCrWmMm6zTbSzNgGkJSMmD8F4uB9rMdDW/erTvliu2HhrqWcWc/i5boVILyrLUApfUiZss3eesOYowiHqBLhVqt+vt8/9WP3KBlimFohyQs5XRJg404s7/jOQa67gUtidvOQIXrEnoEFrq5ZB2iOYpcvzyQqM6d5KePYcbu+tWYU4RRJgWlsENcVAKQ6rvDmUmaiwq5D53DcIk941Axe8jH9Qe7XXvCGrNRvEmTh3u6FjdSm4bXtJdyWQ8iCICmlRmY4u5LbKsyGtisVIDJU1Y5IRvX6PKEz1VDlwkS6GJ0uEHTEb2SD/YT/teld3KSXvatg8m2ihhQEQkFXcVbFqDgSYaaXqXlPNo/D9+nGonHRkMN09WFH4cMuMJajeuX4/dZI569tyNlako6Syc2zWzDacA3J9P9lSNsikCsLiAfNjvHgkHEe2HPb+jcMdTl2nmM3AacvS81Ex5+i/zksOyZOYGcvtsaAlcXQcTgIcHUzckd4VD+EVZTSQubPHr1ApFVpUe8sImbgLd6J7z4GK5pLFKXHJBewtC7FJekMa4EwD+3CrlEMFErKdIBpnenZQUeinrOX8zahRi0eKnuoiEyePP7e+01o8eP9jq403H9CtbvTFaJmoTEpONSAIDjzlcIuqTQOVTDLGjLsMKYaZslfsHdxcEtv9j7iitHBMfcQ2PpDHK18+NRpWR3aSfLXtXw01v3m4CXiIQ5UsLTP88lqTRZy8tN5q6KhlcgDoQl4FF6SOxq1Vu8754uPaLKHc2+Ydq8F8nhoV1FE85AKnyISfXpKGs+K7hpHP3WkeRXWPiLH3wSS92ZaXfAdNx/W6tCBc2Hgzw
 UQjuOmKy
 yZ1QAVZVy8luPtvynfQ66KXvpghimiZIZ4SSJkv/NoPPzEIJUihrGLKR9f/QGXWB6eTfE1aGbuh6F1W5Hl7ih2tEGvelM5zJ/zEcwTtbZYiunGdWZBJKGio0XC90zqh0s9X4EoO4qgqdMIO0EMKrICSKQviShvmxfb/ZYPw2FRO1wO4Qw6ju6AUxR/4IM4N+HzKmyPGHme1jYfu/Rr8b29w9n80MAfQTxWBYG1pWCVngdeEWwSzg50VDrA/g0G9qHMAXBChuPzRRJlS0=
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
 mm/slab_common.c           | 23 ++++++++++++-----------
 3 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index a997207c3b71..57684c643456 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -1071,7 +1071,7 @@ PAGE_TYPE_OPS(Zsmalloc, zsmalloc, zsmalloc)
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
index 08f5baee1309..3216a4e65b51 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -994,26 +994,27 @@ void __init create_kmalloc_caches(void)
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
 
-	if (unlikely(!folio_test_slab(folio))) {
-		if (WARN_ON(folio_size(folio) <= KMALLOC_MAX_CACHE_SIZE))
-			return 0;
-		if (WARN_ON(object != folio_address(folio)))
-			return 0;
-		return folio_size(folio);
-	}
+	if (unlikely(PageLargeKmalloc(page)))
+		return large_kmalloc_size(page);
+
+	slab = page_slab(page);
+	/* Delete this after we're sure there are no users */
+	if (WARN_ON(!slab))
+		return page_size(page);
 
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


