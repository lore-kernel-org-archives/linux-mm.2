Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8742C55184
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 12:57:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF9C76B00B4; Mon,  3 Aug 2026 08:57:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA9296B00B5; Mon,  3 Aug 2026 08:57:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C22C26B00B6; Mon,  3 Aug 2026 08:57:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 95B626B00B4
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:57:57 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8E5C01A06DA
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:39:55 +0000 (UTC)
X-FDA: 85059763950.07.A889C81
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by imf30.hostedemail.com (Postfix) with ESMTP id DDFBF8000D
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:39:53 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cFYvRvF3;
	spf=pass (imf30.hostedemail.com: domain of 3CH5wagUKCCEMO77KDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--praan.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3CH5wagUKCCEMO77KDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--praan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785757193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3WS6p2C4BmwdiRsncUpnqm0L7Z6/0c6U1cXqlGa6Rj0=;
	b=QQQNoZowGC9cbESIRQ0BofijA/8x9a8hidc/KqG6kmUB6Jc5/uB1a0ORwcJ34V+y/QgOmK
	XqEzqw7HU6i0IrBZl3jj5bN4pKYwmH9yQziVuMqv6D+Wcm1hSJKiu9uPB9Z4u0a0BpOpwF
	Al967h0QZ+mYHW5ukkkakjAqFHMZoaE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785757193;
	b=L7RSDo4RbHFgvVLG8efGBSzuYQpPCtCmZPrniCnqLbc7HY4C/uTcrK+GcpUVI+eC/gBTx8
	WPN53OKFrUm5T+wiSWZ2uo6LlDhI9iEuX5ZoBPpFCaToZGC+d/Tc3TAvMw5W3FM75ioAQH
	h+i/VbpSsQOwHz9Kh0HrZglgc8sguQU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cFYvRvF3;
	spf=pass (imf30.hostedemail.com: domain of 3CH5wagUKCCEMO77KDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--praan.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3CH5wagUKCCEMO77KDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--praan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-ca860baea9fso8477603a12.2
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 04:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785757193; x=1786361993; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3WS6p2C4BmwdiRsncUpnqm0L7Z6/0c6U1cXqlGa6Rj0=;
        b=cFYvRvF3s984qXeHP9uP37QhYzGC69eJJBLfUFGEmghFxzdY1ukvxbpn7EQxj6Zs9u
         ac5+MRALwCol4FSVR8VTxqvwN0CpYwwZ6T/gQtuyrqcweGT7/Mjp08Am6bszEr0EaiqZ
         F60u3SE01ao9gf52ZyzioOI1z6XDTnPGcdfEYCtdxpI20S9+cXrRmkgkeQDeFOS/XyZV
         /p7tjWMagB79IowXmg1Mg1ReRwDEbAFufO4L0rewENRT06G/Cz1dji63zQH38dpIsa4s
         RaKdK2Cr9rBKC0rOgDECR6xfPR+qrUb2UbSfrtkJC2RPLPsSghu/M42vYj39Y4C+ykuH
         DpGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785757193; x=1786361993;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3WS6p2C4BmwdiRsncUpnqm0L7Z6/0c6U1cXqlGa6Rj0=;
        b=V/ZzBPoBZMqLUOpQwCHkbNhytxC7Vc8ovqIahwikSTYlfD+BPxlZwuY/ZOPd9ho7b1
         X13oe+iXcHKPL79MQ50Ct9WuNL9dPoNMwctsenOp3yDidcq+BMxBecPayE/rlVSk9oTr
         3mNUR925PH2sL+XiPgwBAML37DYBTmMsQCzCMF8AYFYm0LXulgH4nY1L1+6ghEzSVb1d
         p4A67qXLpxgrE2SZBRHOSfDWPamnlr3hImzoEkprPOBOiXvhxGrpXVTg5ZS85DFFSMAq
         FDzkCdcYBEN3SzxvlA/LA1XXIgisAUaXPbjLFbKXWOnecUW4ND/zAfKu0G0gDpKZhPOX
         8anw==
X-Forwarded-Encrypted: i=1; AHgh+Rrr3BkfZlpkXvRF75Zl7nUeKmJh2hC7MkEyt5vVUvpAZL9Fwdo79Gi5xNVts4K8qdp9h02B+ozRlA==@kvack.org
X-Gm-Message-State: AOJu0YwJRQKqrGeeAa8k/XMBZyu4Ws/drKhMnLfpGrg6skPSWCqmSiwb
	vrYevauEFIFqe5okQy+7jNeid4gsBBW+BgdqZh3sZVJkr+Q9TrArOyIjKDetV9pzbOzT55yBApK
	XZg==
X-Received: from pgno7.prod.google.com ([2002:a63:7e47:0:b0:ca2:10cf:5d95])
 (user=praan job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:710e:b0:3c3:6528:c87
 with SMTP id adf61e73a8af0-3c92a519c67mr10067044637.1.1785757192568; Mon, 03
 Aug 2026 04:39:52 -0700 (PDT)
Date: Mon,  3 Aug 2026 11:39:43 +0000
In-Reply-To: <20260803113944.3694290-1-praan@google.com>
Mime-Version: 1.0
References: <20260803113944.3694290-1-praan@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260803113944.3694290-3-praan@google.com>
Subject: [PATCH v4 2/2] kho: Introduce preserve/restore APIs for high-order pages
From: Pranjal Shrivastava <praan@google.com>
To: Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Samiullah Khawaja <skhawaja@google.com>, 
	David Matlack <dmatlack@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Pranjal Shrivastava <praan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DDFBF8000D
X-Stat-Signature: zjgwyjix5iay5ipf8iub85iyaqds35p6
X-HE-Tag: 1785757193-246499
X-HE-Meta: U2FsdGVkX1989JVl3UUnTOr9/guAjew4Cb0BCDQMdYWbb4z9eF58PbKOUhHfrZo+rUcGO9spxz3BY1onKNPxtW/uvqQKSXZ20T13WnyhsEVeo68quGHh5qvdh53hFKH/Qt4tQlFBLYDJdwHBPR+t0Nnqq3wONyKqitG67votSEEF+ZZgsjip1wq2WazNMTWJ5vsLZp07Pt2Us5lPygsv+lOycaTQl5fCO7fw05cZ1EMH2MWtJvdyDe45N0akGBY0GKIS6RvSp0PTbu5z05CISEFWtZM82c4TgkaByLNu8ICIQo0UwfooMoervW7/PDBU7NAQRI00+FiuicObZb7EUvEswUQpE1+aozwHXqxKvFVVBw977NVUQetMpX66s3SbJApqHRdT/JKRGzwHUVopPj7+A+4yaQeZuV9yZg7pmm3p77aAr9HvhzZN1ce/PMsJXcgKW1AIVz3LJpwaaBQbX4CaIgvwaC7cO/HSGdELnh2nL1M3WCJCyXqIsxf8HIC3CaU9cMT0MkBMjs8adg+JhZNwYIrjCZzFQ1ZJaXTh3nAD45bbmrhUmVsQI0jlJJgC0jD/FpGY2Q9lExch+/svsYS+d5LOr3HegPsWHbP1YWYlt16BBbsB1sPfc9U6jvks1AB9lPeXSEplytYj4ih/Fc3OfOxq3xs3q1mDKThWkvRZUmJ5Jf8CKBrcFe5eWYqSpvOo3SILwTFwRUDIdZ/aWqdkgxdrVap1QHv5a21H5YU17mFVcuhejx07re3QGIX/sp+RNCi10JTCnZcFWSmxkrx5k/13FtFWdTudwkyw9+zjdZEJhUmlNUDgXx2o3+Q0rhcLqwnIqf8qkiMKdLeuVPe6dUEjKlbTosSIoLh2uREBD0GVCmbI/2XNWOOxD5KQp2mu3W1RRE154azBQgT2gCaSewfO2CbwWZzF1h1lGyKbmvQ+QPoiITPGwNH9ReV8osMhKAQ3iyGiuG4OGH/
 VpTMMhro
 KWiyYtuQjnuMGDHE2XY/TI/3Nve3tGOQR223eXXWOaTZY5CM6XK5HNbWQ45iN6iTRtTWfGgJw+m4dNsX1uCPMpx7uSK7eXfVrgnbnYUtvnQd6otBa66R5vrHdtj+WeCf08xCbNbQWYHC/trHMXiNq80aE7EbY84lsczYsQ4sBoHEeFrqD3GAGc4DMpB0u9jx6stMTXqc8GaH0THaPj5y3C96tA8Hco5EXd8RPVawnU/nGN0911yvDPe6EGp3bs21cSY0LoVGLKyf/L7rdkwgNSCdj/CTShpS3FvrqSrJhiqL8m1xhvk7vpLc4gbM49QPtw7U3Oy9JLVa6TQTDOCrQsKhiqbcApleierfjOUk86MTXRRFiYQWRxqjWWuLU53GtqFcOxUMO1OvjCzCPIbRrTa+wc8tupP3n9wzd6tLBBJHm8RelDVidaMwCQKSYQrh43LsARGpmKc/hVCUahY1hpwHjBcvlP9iOxFqqmgyMxF8fwx2q0mS2ZX3uGJXkFpMyYDXYFVMUyFFznPHFLZMe0kbL28N/QbPXYWg3phzFUGu7qgRuYY81ZfKVpEVFV7Hdkhdd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current KHO page preservation APIs (e.g. kho_preserve_pages) assume
that multi-page blocks are split into independent 4KB pages during
restoration. This is incompatible with high-order non-compound pages,
such as DMA buffers, which must be restored with tail pages having a
zero reference count.

Introduce explicit preserve and restore APIs for high-order pages,
which preserve and restore a high-order page block as a single unit,
applying a refcount of 1 to the head page while leaving tail pages at 0.
Rename the existing internal helper to __kho_restore_page() and
consolidate the common restoration code into it.

Signed-off-by: Pranjal Shrivastava <praan@google.com>
---
 include/linux/kexec_handover.h     | 10 +++
 kernel/liveupdate/kexec_handover.c | 98 ++++++++++++++++++++++++++----
 2 files changed, 96 insertions(+), 12 deletions(-)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index 8968c56d2d73..6e2c75b16209 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -22,6 +22,8 @@ bool is_kho_boot(void);
 
 int kho_preserve_folio(struct folio *folio);
 void kho_unpreserve_folio(struct folio *folio);
+int kho_preserve_page(struct page *page, unsigned int order);
+void kho_unpreserve_page(struct page *page, unsigned int order);
 int kho_preserve_pages(struct page *page, unsigned long nr_pages);
 void kho_unpreserve_pages(struct page *page, unsigned long nr_pages);
 int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation);
@@ -30,6 +32,7 @@ void *kho_alloc_preserve(size_t size);
 void kho_unpreserve_free(void *mem);
 void kho_restore_free(void *mem);
 struct folio *kho_restore_folio(phys_addr_t phys);
+struct page *kho_restore_page(phys_addr_t phys);
 struct page *kho_restore_pages(phys_addr_t phys, unsigned long nr_pages);
 void *kho_restore_vmalloc(const struct kho_vmalloc *preservation);
 int kho_add_subtree(const char *name, void *blob, size_t size);
@@ -65,6 +68,13 @@ static inline int kho_preserve_pages(struct page *page, unsigned int nr_pages)
 
 static inline void kho_unpreserve_pages(struct page *page, unsigned int nr_pages) { }
 
+static inline int kho_preserve_page(struct page *page, unsigned int order)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void kho_unpreserve_page(struct page *page, unsigned int order) { }
+
 static inline int kho_preserve_vmalloc(void *ptr,
 				       struct kho_vmalloc *preservation)
 {
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index e836efd98795..dd41d324c213 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -393,10 +393,9 @@ static void kho_init_folio(struct page *page, unsigned int order)
 		prep_compound_page(page, order);
 }
 
-static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
+static struct page *__kho_restore_page(phys_addr_t phys, unsigned int *order)
 {
 	struct page *page = pfn_to_online_page(PHYS_PFN(phys));
-	unsigned long nr_pages;
 	union kho_page_info info;
 
 	if (!page)
@@ -410,17 +409,14 @@ static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
 	 */
 	if (WARN_ON_ONCE(info.magic != KHO_PAGE_MAGIC))
 		return NULL;
-	nr_pages = (1 << info.order);
 
 	/* Clear private to make sure later restores on this page error out. */
 	page->private = 0;
+	if (order)
+		*order = info.order;
 
-	if (is_folio)
-		kho_init_folio(page, info.order);
-	else
-		kho_init_pages(page, nr_pages);
+	adjust_managed_page_count(page, 1UL << info.order);
 
-	adjust_managed_page_count(page, nr_pages);
 	return page;
 }
 
@@ -432,12 +428,41 @@ static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
  */
 struct folio *kho_restore_folio(phys_addr_t phys)
 {
-	struct page *page = kho_restore_page(phys, true);
+	unsigned int order;
+	struct page *page = __kho_restore_page(phys, &order);
+
+	if (!page)
+		return NULL;
+
+	kho_init_folio(page, order);
 
-	return page ? page_folio(page) : NULL;
+	return page_folio(page);
 }
 EXPORT_SYMBOL_GPL(kho_restore_folio);
 
+/**
+ * kho_restore_page - restore a high-order page block.
+ * @phys: physical address of the first page.
+ *
+ * Restore a high-order page block that was preserved with
+ * kho_preserve_page().
+ *
+ * Return: the head page on success, NULL on failure.
+ */
+struct page *kho_restore_page(phys_addr_t phys)
+{
+	unsigned int order;
+	struct page *page = __kho_restore_page(phys, &order);
+
+	if (!page)
+		return NULL;
+
+	kho_init_high_order_page(page, order);
+
+	return page;
+}
+EXPORT_SYMBOL_GPL(kho_restore_page);
+
 /**
  * kho_restore_pages - restore list of contiguous order 0 pages.
  * @phys: physical address of the first page.
@@ -457,10 +482,13 @@ struct page *kho_restore_pages(phys_addr_t phys, unsigned long nr_pages)
 	while (pfn < end_pfn) {
 		const unsigned int order =
 			min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
-		struct page *page = kho_restore_page(PFN_PHYS(pfn), false);
+		unsigned int info_order;
+		struct page *page = __kho_restore_page(PFN_PHYS(pfn), &info_order);
 
 		if (!page)
 			return NULL;
+
+		kho_init_pages(page, 1UL << info_order);
 		pfn += 1 << order;
 	}
 
@@ -890,6 +918,51 @@ void kho_unpreserve_folio(struct folio *folio)
 }
 EXPORT_SYMBOL_GPL(kho_unpreserve_folio);
 
+/**
+ * kho_preserve_page - preserve a high-order page block.
+ * @page: head page of the block.
+ * @order: order of the allocation.
+ *
+ * Instructs KHO to preserve a high-order contiguous allocation (like a DMA
+ * buffer) as a single unit. It must be restored using kho_restore_page() to
+ * ensure the tail pages are correctly initialized with a zero refcount.
+ *
+ * If a driver needs to split a block that has been preserved with this
+ * function, it must first unpreserve the block using kho_unpreserve_page(),
+ * perform the split, and then re-preserve the individual pages using
+ * kho_preserve_pages().
+ *
+ * Return: 0 on success, error code on failure
+ */
+int kho_preserve_page(struct page *page, unsigned int order)
+{
+	struct kho_radix_tree *tree = &kho_out.radix_tree;
+	const unsigned long pfn = page_to_pfn(page);
+
+	if (WARN_ON(kho_scratch_overlap(pfn << PAGE_SHIFT, PAGE_SIZE << order)))
+		return -EINVAL;
+
+	return kho_radix_add_page(tree, pfn, order);
+}
+EXPORT_SYMBOL_GPL(kho_preserve_page);
+
+/**
+ * kho_unpreserve_page - unpreserve a high-order page block.
+ * @page: head page of the block.
+ * @order: order of the allocation.
+ *
+ * Instructs KHO to unpreserve a high-order block that was preserved by
+ * kho_preserve_page() before.
+ */
+void kho_unpreserve_page(struct page *page, unsigned int order)
+{
+	struct kho_radix_tree *tree = &kho_out.radix_tree;
+	const unsigned long pfn = page_to_pfn(page);
+
+	kho_radix_del_page(tree, pfn, order);
+}
+EXPORT_SYMBOL_GPL(kho_unpreserve_page);
+
 static unsigned int __kho_preserve_pages_order(unsigned long start_pfn,
 					       unsigned long end_pfn)
 {
@@ -927,7 +1000,8 @@ static void __kho_unpreserve(struct kho_radix_tree *tree,
  * @nr_pages: number of pages.
  *
  * Preserve a contiguous list of order 0 pages. Must be restored using
- * kho_restore_pages() to ensure the pages are restored properly as order 0.
+ * kho_restore_pages() to ensure the pages are restored properly as order 0
+ * with each page having a reference count of 1 (split).
  *
  * Return: 0 on success, error code on failure
  */
-- 
2.55.0.508.g3f0d502094-goog


