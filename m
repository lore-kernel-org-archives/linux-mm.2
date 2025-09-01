Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F143CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:19:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 504038E0024; Mon,  1 Sep 2025 11:10:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48C1C8E0084; Mon,  1 Sep 2025 11:10:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 334398E0024; Mon,  1 Sep 2025 11:10:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 17E2B8E0024
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:10:24 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D5F011608C8
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:10:23 +0000 (UTC)
X-FDA: 83841017526.16.18C2793
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2304C14000E
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:10:21 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CtAIwORK;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756739422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qfiq0B+dTjY9T7uZZN1EGvA+QpBiXzU5iR+jbjMvbBM=;
	b=tWnk+MrbPm3sxqhOC48eIyCjH1BuGY/jXiSLqeVV5cTJ2Dn1qbK2419l88ig06UII/xaxz
	+H7dHQzs9eirC6UXlEENb11/34N1O5XmcgR5UPCRJKQ4JeA8ghyDt9Om/vCDG/wvJugcML
	wD/zP3k2AXTeB/GUisBY8wK3XzYMh5g=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CtAIwORK;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756739422; a=rsa-sha256;
	cv=none;
	b=n96eLK23rDwsG3QUf7hqTj95zJQTQCiHxo23l0BS5AvSyuPK9BqOgRCMj34yWuTgB1/dbV
	+w+3vHs/MMUMvFyqGpgVD4DKyT6B37aDLaRH22VDFU2tmz3LhsVUrFxaHVVYHeJHmMOi7J
	d6PYYIrRF+zWqvGLd/o+9z9j8XsiirQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756739421;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qfiq0B+dTjY9T7uZZN1EGvA+QpBiXzU5iR+jbjMvbBM=;
	b=CtAIwORKbrgLmdiJywtggQySMZOpTbhDZ47uVaFtZmO32scO089xPluQX3CZGIC7p0B3Uk
	12bRw0RTVnWWJ1t6SAwev12P3D2pE3HWfNxTm6zbFi22DG3gvOQ5l4Ayf3oJxaFJEit2RJ
	9dKcj+h5PxPHnP1dBC4mm5/Hb1Rv5no=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-576-C7HqVpXnPaeMVQh_fJcpwQ-1; Mon,
 01 Sep 2025 11:10:19 -0400
X-MC-Unique: C7HqVpXnPaeMVQh_fJcpwQ-1
X-Mimecast-MFC-AGG-ID: C7HqVpXnPaeMVQh_fJcpwQ_1756739414
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AFFD4195608C;
	Mon,  1 Sep 2025 15:10:13 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.22.88.45])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1094E18003FC;
	Mon,  1 Sep 2025 15:09:58 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>,
	Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	iommu@lists.linux.dev,
	io-uring@vger.kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>,
	kasan-dev@googlegroups.com,
	kvm@vger.kernel.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com,
	linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com,
	x86@kernel.org,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v2 22/37] mm/cma: refuse handing out non-contiguous page ranges
Date: Mon,  1 Sep 2025 17:03:43 +0200
Message-ID: <20250901150359.867252-23-david@redhat.com>
In-Reply-To: <20250901150359.867252-1-david@redhat.com>
References: <20250901150359.867252-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2304C14000E
X-Stat-Signature: 36bxf4dqn7mb8j8pxm4oqameejpf1wfm
X-Rspam-User: 
X-HE-Tag: 1756739421-196001
X-HE-Meta: U2FsdGVkX1/bVZN3A9XHg/iuFXMTPgKS54HP46nCcRTeeCXlTkIvF6b8CKclhszvH3Ql3QIokx4ltSLvG+Uy617CBywqYmZ2dIkXt4uALBHAAs/0ZDM9on/TfyrP+A7twVvSK/y8syRFLLIa+d6kMpxLbi0ObU7VJL428wfhr2EHqJ4JxoGfhK6Wmdtp4LeDvO6GJDC0og6EBgb3uPDRuGxTCygwbeg3oDD3dioGoYonuZNL/N19ihqB6Hgoc2aNZyWvsWIHnfXvNzsqplPweI1aY9mjVPMOW5CyqLe400ub9VLXEI0hDae5GaJiLZJ0Qz5MBG87H16pigewlI07j2uF0bGbuM6pOR1TYKX3PE2gtMBzCaPXhtkHfwHJqFnQ0R4Ft3IOIFO5Jyhp8XQuFLdqeOkB7TQZf/c/lbX9oCYRDf33LXK08MGdlkctQooSiaaigudvBkVpgW/cu25OSbVacT5W4XnK7J+FjajBjgMlfau3Lj9SXdTVYhOnaQdCM7jg5kFCc2J05pr4yLMv3B65LxG6US3LhGFZVrDn8Hm2nqCVLlDU0rn64Ay7Ds8xNi05zlhQY9oFVCvwN/mSk6FXSt5wZt3I3NdMo1gAE56modBr7Mx7mLauYdDN5LpBFExzlWlkwFOgY4yNwKEfpv78BEgUBpj9x6mWZ4QZP4BWERiWeSRDD8BFjzInfVegN39mvlZgXlkU9wfrsoRUTHcxArZ3sBR43zfY9kggJUjBbuj1OpiKG7odd8UeQ1n04f0zfKfDwVsAnFyMFjQYcOxjuha9YGDF/awO3LagRpTdf/cSm+qKsOcWJ3lpadLbU4O7rqlJX/JlQ+9KGt2MOISNqgIDo5ZUfnjHxe9QBZ4SWoLsOaU0UrecajPx9AYtFpILzw29Hrg/ygfNBHfmSVXFmRN32rpOt6o8rP9oaYaCwWAwFpQ5D1lz6F/sH9vOP+pogZPeijeXgQ+4y/G
 5EoDk+HU
 zL4D3CLktZhSnvej5LpsTnN//lNkUOUMRePFZYPbVMK9kXS4BJfl6FeXIby2VZN/zR3UIxYz35/pqxEz7NGJ940yI8qHEvbM0+sV/jLMhT+La8s0cFnKFRK3k/wZ4ymgyg7gpcQ4VzTXsG0UBUWx9egZqVhLap+/kiqFoZ1uKmkaLVAghDyTU/JojbC2bx5enQxnsp7acgKT/5loF6p8iWbNncflZSOehpqehnaGk3BlLT273oCvbYv2/hiwfgt/qXz4vKZ9LpOz+2mihtxOOb/tfBNYgK2Vka1nPFV55kdt3hw3dWNlsTbqI4R080DtdeztYUZOdZlzVI7nvtK7H5nW+zLXn0oFThA3zS5g2cRiGQ4prSd69a8Gy1Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's disallow handing out PFN ranges with non-contiguous pages, so we
can remove the nth-page usage in __cma_alloc(), and so any callers don't
have to worry about that either when wanting to blindly iterate pages.

This is really only a problem in configs with SPARSEMEM but without
SPARSEMEM_VMEMMAP, and only when we would cross memory sections in some
cases.

Will this cause harm? Probably not, because it's mostly 32bit that does
not support SPARSEMEM_VMEMMAP. If this ever becomes a problem we could
look into allocating the memmap for the memory sections spanned by a
single CMA region in one go from memblock.

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/mm.h |  6 ++++++
 mm/cma.c           | 39 ++++++++++++++++++++++++---------------
 mm/util.c          | 35 +++++++++++++++++++++++++++++++++++
 3 files changed, 65 insertions(+), 15 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index f6880e3225c5c..2ca1eb2db63ec 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -209,9 +209,15 @@ extern unsigned long sysctl_user_reserve_kbytes;
 extern unsigned long sysctl_admin_reserve_kbytes;
 
 #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
+bool page_range_contiguous(const struct page *page, unsigned long nr_pages);
 #define nth_page(page,n) pfn_to_page(page_to_pfn((page)) + (n))
 #else
 #define nth_page(page,n) ((page) + (n))
+static inline bool page_range_contiguous(const struct page *page,
+		unsigned long nr_pages)
+{
+	return true;
+}
 #endif
 
 /* to align the pointer to the (next) page boundary */
diff --git a/mm/cma.c b/mm/cma.c
index e56ec64d0567e..813e6dc7b0954 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -780,10 +780,8 @@ static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
 				unsigned long count, unsigned int align,
 				struct page **pagep, gfp_t gfp)
 {
-	unsigned long mask, offset;
-	unsigned long pfn = -1;
-	unsigned long start = 0;
 	unsigned long bitmap_maxno, bitmap_no, bitmap_count;
+	unsigned long start, pfn, mask, offset;
 	int ret = -EBUSY;
 	struct page *page = NULL;
 
@@ -795,7 +793,7 @@ static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
 	if (bitmap_count > bitmap_maxno)
 		goto out;
 
-	for (;;) {
+	for (start = 0; ; start = bitmap_no + mask + 1) {
 		spin_lock_irq(&cma->lock);
 		/*
 		 * If the request is larger than the available number
@@ -812,6 +810,22 @@ static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
 			spin_unlock_irq(&cma->lock);
 			break;
 		}
+
+		pfn = cmr->base_pfn + (bitmap_no << cma->order_per_bit);
+		page = pfn_to_page(pfn);
+
+		/*
+		 * Do not hand out page ranges that are not contiguous, so
+		 * callers can just iterate the pages without having to worry
+		 * about these corner cases.
+		 */
+		if (!page_range_contiguous(page, count)) {
+			spin_unlock_irq(&cma->lock);
+			pr_warn_ratelimited("%s: %s: skipping incompatible area [0x%lx-0x%lx]",
+					    __func__, cma->name, pfn, pfn + count - 1);
+			continue;
+		}
+
 		bitmap_set(cmr->bitmap, bitmap_no, bitmap_count);
 		cma->available_count -= count;
 		/*
@@ -821,29 +835,24 @@ static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
 		 */
 		spin_unlock_irq(&cma->lock);
 
-		pfn = cmr->base_pfn + (bitmap_no << cma->order_per_bit);
 		mutex_lock(&cma->alloc_mutex);
 		ret = alloc_contig_range(pfn, pfn + count, ACR_FLAGS_CMA, gfp);
 		mutex_unlock(&cma->alloc_mutex);
-		if (ret == 0) {
-			page = pfn_to_page(pfn);
+		if (!ret)
 			break;
-		}
 
 		cma_clear_bitmap(cma, cmr, pfn, count);
 		if (ret != -EBUSY)
 			break;
 
 		pr_debug("%s(): memory range at pfn 0x%lx %p is busy, retrying\n",
-			 __func__, pfn, pfn_to_page(pfn));
+			 __func__, pfn, page);
 
-		trace_cma_alloc_busy_retry(cma->name, pfn, pfn_to_page(pfn),
-					   count, align);
-		/* try again with a bit different memory target */
-		start = bitmap_no + mask + 1;
+		trace_cma_alloc_busy_retry(cma->name, pfn, page, count, align);
 	}
 out:
-	*pagep = page;
+	if (!ret)
+		*pagep = page;
 	return ret;
 }
 
@@ -882,7 +891,7 @@ static struct page *__cma_alloc(struct cma *cma, unsigned long count,
 	 */
 	if (page) {
 		for (i = 0; i < count; i++)
-			page_kasan_tag_reset(nth_page(page, i));
+			page_kasan_tag_reset(page + i);
 	}
 
 	if (ret && !(gfp & __GFP_NOWARN)) {
diff --git a/mm/util.c b/mm/util.c
index d235b74f7aff7..fbdb73aaf35fe 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1280,4 +1280,39 @@ unsigned int folio_pte_batch(struct folio *folio, pte_t *ptep, pte_t pte,
 {
 	return folio_pte_batch_flags(folio, NULL, ptep, &pte, max_nr, 0);
 }
+
+#if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
+/**
+ * page_range_contiguous - test whether the page range is contiguous
+ * @page: the start of the page range.
+ * @nr_pages: the number of pages in the range.
+ *
+ * Test whether the page range is contiguous, such that they can be iterated
+ * naively, corresponding to iterating a contiguous PFN range.
+ *
+ * This function should primarily only be used for debug checks, or when
+ * working with page ranges that are not naturally contiguous (e.g., pages
+ * within a folio are).
+ *
+ * Returns true if contiguous, otherwise false.
+ */
+bool page_range_contiguous(const struct page *page, unsigned long nr_pages)
+{
+	const unsigned long start_pfn = page_to_pfn(page);
+	const unsigned long end_pfn = start_pfn + nr_pages;
+	unsigned long pfn;
+
+	/*
+	 * The memmap is allocated per memory section, so no need to check
+	 * within the first section. However, we need to check each other
+	 * spanned memory section once, making sure the first page in a
+	 * section could similarly be reached by just iterating pages.
+	 */
+	for (pfn = ALIGN(start_pfn, PAGES_PER_SECTION);
+	     pfn < end_pfn; pfn += PAGES_PER_SECTION)
+		if (unlikely(page + (pfn - start_pfn) != pfn_to_page(pfn)))
+			return false;
+	return true;
+}
+#endif
 #endif /* CONFIG_MMU */
-- 
2.50.1


