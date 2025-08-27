Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6ACCCA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 22:08:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 074706B0011; Wed, 27 Aug 2025 18:08:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04BFF6B0025; Wed, 27 Aug 2025 18:08:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA39E6B002C; Wed, 27 Aug 2025 18:08:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D64D96B0011
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:08:21 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9A398C0898
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:08:21 +0000 (UTC)
X-FDA: 83823926802.10.DAB5A61
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id DCA392000B
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:08:19 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YcbTnbnU;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756332499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oNaSehEob45J6rBCmQiuv1tai/IG2I8b55z4DkHJozQ=;
	b=HExCBVHJV837LWtKWVBWHLflTUer0HWiVygXT/ToVjYxyOl3sceiI5bLUYUHpBTPAz3xaF
	xZbI+6KcGB1/7S3/xf4tuGVkQCnOfU1eC+e6iclUXl+9cWxA2gdlQjIKM2YqR1R+7DJduk
	jzwBRluHyA4znW8o5WowEjHLp6buxuo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YcbTnbnU;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756332499; a=rsa-sha256;
	cv=none;
	b=H6cNYEN7iKpbYUbC5je8IJmdVYnOuntzJwk/wyStfXmisMbRHoMq6vnq9f0Onpt7+ZMN3p
	xwOUjwR2gfwmkDLOcGjyRgyPFHlZoDpjkAgbseRh0gkZpjVkvlkIcNlPUs0582ER7Fuhf7
	yal+rSdwv7Sep+phTdwvdz/F54sP9SQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756332499;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oNaSehEob45J6rBCmQiuv1tai/IG2I8b55z4DkHJozQ=;
	b=YcbTnbnUSUStxQz2bx+rxrTcyNiFq6xZnwgXpct6npK3yePSuwPc6XscqT8BhqKogPbGUA
	yuZWh4so783Y3JUeNn8wFtpbG7o0YnjlEC5Zw/b4jj7WvjWgsUla9QeGpTIfWZNNMEyD7K
	xfpiywNLjXth3VxjMKqwY8LJSyibpfU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-376-aT4Dz_AHNuy0h_90DuEaig-1; Wed,
 27 Aug 2025 18:08:13 -0400
X-MC-Unique: aT4Dz_AHNuy0h_90DuEaig-1
X-Mimecast-MFC-AGG-ID: aT4Dz_AHNuy0h_90DuEaig_1756332487
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2D1AD1800296;
	Wed, 27 Aug 2025 22:08:07 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.22.80.195])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 478603001453;
	Wed, 27 Aug 2025 22:07:50 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
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
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
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
Subject: [PATCH v1 21/36] mm/cma: refuse handing out non-contiguous page ranges
Date: Thu, 28 Aug 2025 00:01:25 +0200
Message-ID: <20250827220141.262669-22-david@redhat.com>
In-Reply-To: <20250827220141.262669-1-david@redhat.com>
References: <20250827220141.262669-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Stat-Signature: x9sp77cwnfds89ebcgbguk1gxd6o4c5d
X-Rspam-User: 
X-Rspamd-Queue-Id: DCA392000B
X-Rspamd-Server: rspam05
X-HE-Tag: 1756332499-860929
X-HE-Meta: U2FsdGVkX19C2nj6vo8uLVtVESrs1EspSrvfEeaDgHOPm8HdOPYdCixWPDeezR3HQsvcrYOpJTjeMxpJ/UnaIGnjQkGmnzco5FjTS72Hy8o7yIrZtedFJLtUmll6NgTwP/F1TT5WI9Fg4sW02Aur9AfiMHuJJiKSH7ndabwXNMNaWVzS+MUMNtBEktIoHKaP1m/d/xE9Rl7HMWUEimXSWHijCngd8bgv7n7wfEwrndnCbYI8ExUKotyj5yvyLtdKGpfSrzOsduaazSpT7VWhMMs7N2z/F5DcVSVqeXdRQKOWVRxQ1D5kMiR8DUCWOiEMP+cPznoykKnI1IyBSfapNuHXgRf9RTDgGzJQAaF7Q/1aGaCgcxdAKU8AYBd6PlF6kUdPi/qPWlNWS4j0yl9iXT8Cd1nL9chFNu5H5g634yCf5AuLkpCrK3g8CuvDgzvUs1E523pqBVjPkqMDbCWHPsE4SecKMK37lia6iq3gg5yVhbl6z16vmAen3TmlFis+N8mxOJwcpLuAROK1ZB7/k5Ou8aRKYDgCaNtKI0LspxhgMULRkJlx3YGoZib3qWJnMX/KVb6CUb5nQhpwviB8WqnYEjV/63fmPU7KESQkvTsbIAVL1jEQhu34h5lx9QwNHUjNMaNM8KF4J+FrNIueXt9UpOFfa1FG4klSrlMtuOYvYgesev345ZVcWCFapOp4OoMbLV3x/kcinMxa6WNlsU4pURVKqsKaetLVK/4N2emaTbAkgoGrx64mYyCEaULKnW6ptqC7ccJrsQXojwtpYb1fXEX5lLZ8ckh+9Tb9NJv+TNoxKpOk4XWT+1EDYFOqvrp976RMgGmyDjNeu4qH/cbM+DJbclUiVHiwAS1jqTusIAXLZ/MmhVmIA4eTKvRJWDUG7KeEQAzCGSNpW3qGHyC4Y7tV1lzwwjr3OzQi2fWdwUJffKs8/hL6DJH75lz1Vfp5tEOoZ8ZM4702j7j
 ON34dft1
 mMpDHSDGea7bsfptDvh1NSvU4QewM8a48n9IAUdyTlQTcC6ZQdaRbOABJ7qSE2hugCpQSDkG1ulx64sufsMKk7Iq61CFyqgdU++8acwr+HQ0EBPdpVLMnTctyomDI7p4qGGaJ4n72lxsQO+KuT7BpiEchJVilEM6KoRkS9zWwaUU/BB4h0mgEWvXu1beMeq6X8tHDhoAcccF7aG5rv3poLblD3CnTfVAlgd7r4Fgdl++PzMiCNGdIwDlG+xU02x2e6qL3Ipj2RhrmnjZ3RycJDSkvtpSeSj7ZyE+qbddv5UGnXUxGeRIigtoRVUuzxK70y+VDAvXF4EKyiwMWWqyZSw5nRBwrrVCm54Uf
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
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/mm.h |  6 ++++++
 mm/cma.c           | 39 ++++++++++++++++++++++++---------------
 mm/util.c          | 33 +++++++++++++++++++++++++++++++++
 3 files changed, 63 insertions(+), 15 deletions(-)

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
index d235b74f7aff7..0bf349b19b652 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1280,4 +1280,37 @@ unsigned int folio_pte_batch(struct folio *folio, pte_t *ptep, pte_t pte,
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
+	 * The memmap is allocated per memory section. We need to check
+	 * each involved memory section once.
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


