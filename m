Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB532CCF9E9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 20:45:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 673FA8E010E; Fri, 24 Oct 2025 16:44:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D41D8E010C; Fri, 24 Oct 2025 16:44:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 426868E010D; Fri, 24 Oct 2025 16:44:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1FE868E010A
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:44:51 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CF817498F7
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:44:50 +0000 (UTC)
X-FDA: 84034186740.13.2A19AF1
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4D5F3C0011
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:44:49 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=XgvJfr2e
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761338689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IwOEof2Ks7gaRYI8l1oIihpkFLH1M4eU+Sdbk7N+VO4=;
	b=aUUg/Wzoh5+06AoxBOx7DeDJ+D9cJyKeHVkfgSHqHadckK0so3dUcHmV9IOjc5FNXaFXJa
	NprURqZ014hS+l7rtQx+8Tr4SHmr9YFw6VI4PV29pncgW1WWgD+dem3ghdr17UxW6z+5f8
	iAkUf1vXrMfsUswvvqv0DnS76H62xZE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=XgvJfr2e;
	spf=none (imf22.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761338689; a=rsa-sha256;
	cv=none;
	b=yq4KHF17lBxYjCgoOx+QhsOCZWHjmuJeWzVnW9OOVXcEZOEDYTm58tT8fOF8bLfpRd0Tsm
	dcuIY3Bc9gm6xV74DFNrLVf/rv/aXAby9NlS1fQPSpNI57cFSx27QQlatuMRPJ6QlHQ6tN
	+UYNqHeXy4ClatLaZuOZ6mwksRR75q8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=IwOEof2Ks7gaRYI8l1oIihpkFLH1M4eU+Sdbk7N+VO4=; b=XgvJfr2elD25OW9iN6LpOEt0AR
	ros6kCTjcSGzF5B9irvxdx1NTKNpb2HMQvGbdctlJeBIRByLG6sZ3Ano9vVJgXMcv55GrolD+6raD
	iHB1TkCrBhD4CK/dkZ9DjNNJMoU3S/5WJES+ucLI6okxCv3mrVyxgaWvr9PRjNxWlQnTLWgD+VOcI
	toJaT6Wf7yjbOkukfpMFsT8EcCb2MhYReBD25cguuQoMdM98Pgrod09m7y5xHqIa8Hcqxu+mO8nsN
	/C3l5tArljlC6eAjNPb3jD518iPTmBNenzXrOaCrLtNdat8FCLkOYxjb9M/FQLM08dheULWV8h39Z
	4zv/zjOA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vCOeN-0000000AKQq-1r21;
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
Subject: [PATCH v3 02/17] slab: Remove folio references from __ksize()
Date: Fri, 24 Oct 2025 21:44:17 +0100
Message-ID: <20251024204434.2461319-3-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251024204434.2461319-1-willy@infradead.org>
References: <20251024204434.2461319-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4D5F3C0011
X-Stat-Signature: au64j1ws9y6iybtigujwhmx9m16dzfab
X-Rspam-User: 
X-HE-Tag: 1761338689-418223
X-HE-Meta: U2FsdGVkX1/RHcpJ+bwhF/3xH/aA/2JdCWoWFBT8CN4u+HLu5d+d032osfh8Qv9FY07cYpxSIcMuapj8VgVxbUIgUoXmZ7Y3pgZ+zsyp/UAGe3it2Yfo53W0nChhZ7h6HX0TVsy2olE0RU/jSdrR+yaxk7jyfnh03nACHggF71FawprheZQWP1AxPN0BPAseOUw5V+FaqUT/tviWa7yDDqHszNncy5DrZUJrJOtjSIMfSnD98mW6XnRFj02bIlosrLBlg1cJvZpHSPZjCOzv/ZKNRIzYnQPCCh9nQXAyy+9BRfXb1ChgJrWp2JoDkvvK5Wl852eqASLBvYjATT8ln8YqxCF1/PtaFlyV5UD4kL0lgqcfJFuMzeWpTFVYELSvQW11tksmXoW/JTTR4x5mOr1B/XJ9gawXWbcO1hEYLbVg9cQDYfI23vMUhvwBtw1WqXdO8UdoPD1KCP9gXYa/jusUcRXF0ST1OzCWBKPJ2sZ97XHwl9ats8LC6TfHFfUSAyOfMQxv8eqhZtwft7z1X/xI340SqwDSwHMF1AF1/atZwPpwI7GEgXjxJ6YW9nb5AdTB4Crre2lEyHAVHn4+79Q7UQ+uWIEyvNV/VDlOHQBIrlz9uG6lHtyKBCtm6Vo7fdgevThqmYsq6iXQ9dAzibZN/TmiRu74J+31Ufeloq5ZlkUdUHhWCoepPZkts2oizPIywWO9+XmcS5q9rT1/x7RvreNxi8aVikR9cowPMloiSr6QW7mF74GCsuCnxorDOSHlYLA5D3k4PxTIb8ch1kg8NT9+b8NGSX//X3n1FsCbCuR8pgOP3Jffeem3bDaIVqdHoQGiANR0yuzNMwIfGOHKOMojd8wzRjop3DstwCnNw8zZlcKv72Zr1lAAxXCCBl6JLqs8dJ8SQ1P1Hc2x5TvWFe5IYqOMujJVmpbeU0/q2fds3G4LfMhEEZ96gO5UTiCXuIE9ftCBtX/clwV
 r0xVqtMu
 1j9QrDq4eSGiQP8JYnYJNlVU4wQ9cJhr1Do0vzavbkXDdOQeMXXbbueTXKtJlFiYg0ahhV2dxcWbleimnysbUo2+tTOSltaD5kH/4Gn87AVFag/+nECxW2AIxTmyPWBliPjvQY13HKeGZe3CpDb8tS34F/NhB/eNCYZgjWu0ACzkJy3yUoCJ5mhgUbUYVRBSTlpuXT9J6LlXcMIf+xePQCVycvLJeQVXVpviK/eS3KmSVULSxZyJ5V8PFjQqzy59M3M3Nnp1FbpuPOos=
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
index a64b9b2c8731..31ccf0f6d3a1 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -605,6 +605,16 @@ static inline size_t slab_ksize(const struct kmem_cache *s)
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


