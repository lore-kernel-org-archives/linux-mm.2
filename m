Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D685CD4F26
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 00:10:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E28F8E0017; Wed, 12 Nov 2025 19:09:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9923A8E0012; Wed, 12 Nov 2025 19:09:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 798198E0017; Wed, 12 Nov 2025 19:09:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 60A6B8E0012
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:09:48 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 24CB0C072F
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:09:48 +0000 (UTC)
X-FDA: 84103650456.15.4414764
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6354610000F
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:09:46 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="ratrV/Mx";
	spf=none (imf14.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762992586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4usDvuAnGxU+IY89E5cvbLBdQIIKr1wKwsG92AZvKbQ=;
	b=WuXavmiNRkSw4Pd8qMi683awBR7B2SCs1112g24pr4cC+nxm3LKoOP5qWZR4R/CvtbgN7Y
	FfnRPjVKkYy2xzcXhM3ED9SInvfw//hxo4sdCVsx0p0XXybLZAYFZJNuh0aRVI3Fl7rn1M
	5D9O31pLietOU4qWcV5Q/HDdaX7bmSo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762992586; a=rsa-sha256;
	cv=none;
	b=r/JONF0aSgmfVquLhy2gTrBMm0w+LEvlm9/zN+jW5PmZRju8xFmh6Oznt8csY+AnI1ghn9
	1eHIW0TYLh0+Bfx7YOe6pXP5PEo/vbf+lSQrgDND9TFJ1kNqB1f6AgIqn8Dw3ernWz4KER
	VeQP3YbxXX5xX8hD8MKdibxPCg45rRE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="ratrV/Mx";
	spf=none (imf14.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=4usDvuAnGxU+IY89E5cvbLBdQIIKr1wKwsG92AZvKbQ=; b=ratrV/MxKHPa8kf1e8Bwxk1fAK
	UrGcDKKGJz4w2sff1BpRZtmjMh8dMWAx1FzrrgZgsHsDO/fefYfVUo2rC3rWKJcH0fi4EzquLb5xy
	xqpYMR/RLiIOsEjKmcWnizb765EntDZgEp0Gc9kkb8wVJvByRz0yW9oFoN1t0dtqSLlwiwZJ+xv2t
	s7kjUrV1BNVqVO6sC7Bvo23sFxUWf2fj8k5RglMe+dhAoqGNosRTjdicvxblYQXYITvASkkVsexCe
	vVqx40UhXygyUMtCujKsrfVIrmulsdIpG/O71ADVTZAJtl4rJAKB6dxikYVz6d1GjRXJn4TmmPNOT
	Wiyj49wg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJKu6-00000006fOQ-1uUa;
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
Subject: [PATCH v4 02/16] slab: Remove folio references from __ksize()
Date: Thu, 13 Nov 2025 00:09:16 +0000
Message-ID: <20251113000932.1589073-3-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251113000932.1589073-1-willy@infradead.org>
References: <20251113000932.1589073-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9p8chh8k56yascx4xfyiwzjexm9b5n6f
X-Rspam-User: 
X-Rspamd-Queue-Id: 6354610000F
X-Rspamd-Server: rspam01
X-HE-Tag: 1762992586-788619
X-HE-Meta: U2FsdGVkX18oqgZ2GE54xxTLL2n8A1687ZuwTPQzEgJzy1LX+eY46FTm1kPPhUkANCK05taDzV6hFmjIf7aa+Kvr9corFVmOahCtrj26zlLwadRrdUe1lmZ8300wX2sTsHW1y+vSGcko6PDKC3eY25CXGExS7rTcU1ogz2/xif08Ku2aElryM7ZHtM4RrbxXJIYDvtIs0vU4IBfhnxZnm7yGknm/mwQOdtyY4IjCgus54pioiwAEB+IoH4WkihbjdPCtDNssCm1jzcowVVP7Ds9T3fxxzo5gvV/9WWiBNJjulwfIB+0MqYAhoUbpLhnCU5197GorU9KiAZ6VwjV59NUuA2tN1SqftL3mrP/sWkPTvroQJs6KJMgLtACiiQWVB6bO5er3n+XeBLFgTPTBUp2eL4eMJVkACdBHuCmXHQn98tFt7QaI+npvk8D+HrUsZNky9fkYtJIehMX17XQmZTc3Sm6HNYGUJLIvf/b4Ad/QSFODz7P7DaEvlGe1qWnuZ3ZNsmRaqShU0cjFfhaS5v7hd8j2bDa25dpsbTH1vuoKup+aBcTrI5RMrc8gJXgtTX5xSz4AkKa4tYAknpwsauI8NaPILjFwZ5/SLeQ+JOfJ1+YrmuW/QG5oDgO4isLAJrfcuKRfFyBhg4zg8pYq5QtOMNQmE9fPixjRRDrX9lJ96QI6DDs/WXKImyPExT4X/d/wDX82Upgm5w7XL62ymoSc8jVCHP0X2efWSkWjG3UnXegjhdGw4iQqWdLxZgJ2hnM31Pa85qxJKE6ZVEBYm/0uK7i1NXbs8TjubVtG0OBOMze+lnbWryCWrJPgQUeZJhHlifE6233eZYUVmg+BXIQuageImADsRRtxnpq+cIi8HIR50vGFShrHukuXgFamTfS89UMxUfK+WJNBpVXs9I70rJ4YgNvdKCi+X/EvIPOj2G9M8u8+iDObT1Lvas7WEFDKzjDQPpUudn4IBqs
 IxpYGNXg
 p1t2A0gKA+KnYr/7KPgpf1td7onfMInk6o08RTIQECgo+AsoCa0zxuNvH0gDko9PRlYKRJ1LEVyWm6MydASoYMjzY9Y3RtrEMonJXpwiIjaMBuCqRzX2dEzw0RNo8pcZH4uUiCHOz1nE0tse14FgWPI+z/adZdW8Zw9OFyktl3+QWpCq9IwaCgaarEJiNep2kFqB6F+D7Z5TxgKn2roNTp/9H+6NI7EycEPPbORxNPNnnfhDeFneLvOf8i0tEoihBh3rR3Oqh/EqfID0=
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
There's a minor win for large kmalloc allocations as we avoid the
compound_head() hidden in virt_to_folio().

This deprecates calling ksize() on memory allocated by alloc_pages().
Today it becomes a warning and support will be removed entirely in
the future.

Introduce large_kmalloc_size() to abstract how we represent the size
of a large kmalloc allocation.  For now, this is the same as
page_size(), but it will change with separately allocated memdescs.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/page-flags.h |  2 +-
 mm/slab.h                  | 10 ++++++++++
 mm/slab_common.c           | 23 ++++++++++++-----------
 3 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 6d5e44968eab..f7a0e4af0c73 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -1064,7 +1064,7 @@ PAGE_TYPE_OPS(Zsmalloc, zsmalloc, zsmalloc)
  * Serialized with zone lock.
  */
 PAGE_TYPE_OPS(Unaccepted, unaccepted, unaccepted)
-FOLIO_TYPE_OPS(large_kmalloc, large_kmalloc)
+PAGE_TYPE_OPS(LargeKmalloc, large_kmalloc, large_kmalloc)
 
 /**
  * PageHuge - Determine if the page belongs to hugetlbfs
diff --git a/mm/slab.h b/mm/slab.h
index 18cdb8e85273..0422f2acf8c6 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -603,6 +603,16 @@ static inline size_t slab_ksize(const struct kmem_cache *s)
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
index d2824daa98cf..236b4e25fce0 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -997,26 +997,27 @@ void __init create_kmalloc_caches(void)
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


