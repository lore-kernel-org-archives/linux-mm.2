Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C92A8C531F7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 20:42:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D23946B0095; Thu, 23 Jul 2026 16:42:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD3D76B0096; Thu, 23 Jul 2026 16:42:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC2876B0098; Thu, 23 Jul 2026 16:42:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8D4F16B0095
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 16:42:19 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 18162160182
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 20:42:19 +0000 (UTC)
X-FDA: 85021213998.09.76C8502
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by imf07.hostedemail.com (Postfix) with ESMTP id BE2F140007
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 20:42:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nowLb3bg;
	spf=pass (imf07.hostedemail.com: domain of 3pnxiagUKCIMwyhhunvvnsl.jvtspu14-ttr2hjr.vyn@flex--praan.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3pnxiagUKCIMwyhhunvvnsl.jvtspu14-ttr2hjr.vyn@flex--praan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784839335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/sU7OskJpEHtaekLlZ/5Z4YIkxuA4+y1ea25Y5pF/Mc=;
	b=PD9wwYdN0MqNgq20WJOo/zr++fMwuJd2rVQ0xjsxg7PzDCyNyOHLg+wqS+N1y/FpUAlIWF
	yxIgsyMAqIoXztq96iADFQyaddEv8ibw5H0cTn5JkFilz/LiE+6Tpakt5FvY7Uwycg39Bg
	2w6zmvEpMz8/Esosp1IJ2BSlXxZtolM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784839335;
	b=M9a3OpjxaBoFHz41wVAe7lQtZjZNNW7J9dFL5TJvwKMiMx6VIlqVRW9AEaydQVyXpJMtqT
	oRo4HCnP6YOUy2198twe6Z4STvBf1AvJwDxXAMKxaio2EqU/Sacw8jCdtxBCPTcsaHzNHR
	5HBvN4WuC/4jp0gVoTVFNNrvQSwaMdg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nowLb3bg;
	spf=pass (imf07.hostedemail.com: domain of 3pnxiagUKCIMwyhhunvvnsl.jvtspu14-ttr2hjr.vyn@flex--praan.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3pnxiagUKCIMwyhhunvvnsl.jvtspu14-ttr2hjr.vyn@flex--praan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2cce14a21faso11831885ad.0
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 13:42:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784839335; x=1785444135; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/sU7OskJpEHtaekLlZ/5Z4YIkxuA4+y1ea25Y5pF/Mc=;
        b=nowLb3bgIoA88dSMhYH4Ftd3Nx/XHhoA7AYpfR80j4jRDNAw8ilUTDKwDhoK4xk4o5
         9sA3QEgWAgMfslL2BCis4Stt0YqJmEePWkEpP0pZ3WJuQmarq76HeYBk8RUpaImjPxP7
         QvYiWIG49OmxjKj/lugF2V7BExef5EeGAt7jJHLGMDoMCwCEP0G3Sk9/nFjY4s9zmQuu
         Hj3AdEDtGY7ll4v4PQ6Tz9g/bRmuyFrY1Y9BMwec92PJ6DF7ukAO8Jdt81PA/nsSl5eB
         x4eBe0HSBNzfqdUoXJLHFRDsm+MOuFmmH6uhtHPVT1vwRSeW381cSP14zMNzeUSZu4Iy
         zjzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784839335; x=1785444135;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/sU7OskJpEHtaekLlZ/5Z4YIkxuA4+y1ea25Y5pF/Mc=;
        b=DLnb11zU6dMR7DLBKZ2Q/Iz8nkFzLCOGnEMxnagI+TjwJD+8pjExPPBbt9DcM2Em8D
         WDZQ7wSnPMAYJhv7AdUYD9OsYptmWobruY9Y0cSTphV1PVlIKobl/0+ac0lsMNtwTUzV
         k4xIFo5Qm7B0bCdQM86E3QdRkRtBHWrNDMlGKaJl2DjTsk1ZWbcMjcfYqC6OlmWgAgKd
         JpxntZ9fNuPskk3TKT/CjlkDbKmlMcMI+CfK4IXYnOZ6Zo4SakYvAfON+sfOV2RZLRPn
         +yIkcgQ+vF6Z1bwIN4v+t3UeKvf2+ULVJVtlFDdel3tmraczmsD+DbkEaVX3uhglGu6F
         jzxg==
X-Forwarded-Encrypted: i=1; AHgh+Rqh5qBkoN21mg3y9c8WbWq3pHLjW3d9cjMO/3noOocx+shv7qWUgrGLcSqY1A8lJAOKamGWS9Ixbw==@kvack.org
X-Gm-Message-State: AOJu0YyBztDosLjM+m4K9/SFwQW9hWK9/vTjAGIhK0gGy9WDDsHy6w8d
	ZMxMKCCU+heX2Fy9DjUZhASOy7EnoLPIF97VhvVy9Th/XVdGdGxfVYQO9eygafSheZPzlpVFbeS
	rkQ==
X-Received: from plrs15.prod.google.com ([2002:a17:902:b18f:b0:2cc:ae2b:c324])
 (user=praan job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:41c3:b0:2c9:fc0d:165b
 with SMTP id d9443c01a7336-2cfa9552729mr45540675ad.23.1784839334260; Thu, 23
 Jul 2026 13:42:14 -0700 (PDT)
Date: Thu, 23 Jul 2026 20:42:02 +0000
In-Reply-To: <20260723204203.2997395-1-praan@google.com>
Mime-Version: 1.0
References: <20260723204203.2997395-1-praan@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260723204203.2997395-3-praan@google.com>
Subject: [PATCH v3 2/2] kho: Introduce preserve/restore APIs for high-order pages
From: Pranjal Shrivastava <praan@google.com>
To: Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Samiullah Khawaja <skhawaja@google.com>, 
	David Matlack <dmatlack@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Pranjal Shrivastava <praan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BE2F140007
X-Stat-Signature: ff13hbm8qb8k94ghpgtijrfjt51tyyow
X-HE-Tag: 1784839335-721353
X-HE-Meta: U2FsdGVkX1+hL+bjTvusccd1ON/9vlk1yfTBE+GD/Ld9pVswhlcmBD3lneE4+eSKgkpsKz/CjYfoflwIQUzc7fJK2J9IB3U6KD3NPUzY8hw8bRgIWwnj3uSi79MBpmVAh8dIt7xGfWTwqN1PaL+fuGQWgWxQ50cSTk368sJmlyoYDHbD6bexr949lnB0BJsIROzVkdIxkS1tDLbPSocZ5joTrPTotOYU8Gdt3gcLLHJ6P8iB3ur0RDvp6rIxugb8Y0F2Dcu4AeCJcQGtsI0HDaoCi1mY4M6DbxqiD4/tb4E/oN7FfmTO0R5ohwC8XGu+m1VPAISLQ0perp65Ob4z4MwYYY+TZ4hfE6cHGYHws7J26RUo6hvIHloC00bVxG2KIzDDToUYvEymtjMMr3Rn4kYkqaNhjtRepHVFzaPXQzHOdKrNeUm/nhL5FCYIvyn0MWnZVBZWGlYoUdnMuQcEwMtUjTVccQ834ccbDqJDrP2tkDdjN5P/aliy15j3bpavBzhNBYdAMueavpLNQkuhtmitW1Ie8Rt2W5IWSp9IvEV86WgraFQbn9FNN3CZlkD9Ir7I5YVcHynSWNWW1APu2EF3YQebCckFJhm6kkfTt7jaqXSBLRhC4vcUyfKxeXFicndL7v7F7oxMxcFLkd4bra+1xwkSnBW4BK2GtXZpb/2RjN1s/fgc7A57Hh/sgE/ABccuL55len8njDRls7sBZ8gDmD5a9A9m2TuKn0xDTSxGoLifjjBJCi7iLPoBtfdLQouTg8p9b6bi2fjCJrVRIS7phJisKlRpxRuemSt+YWHHJQedTjqcnhStAJw/yPSjkiLCQpd3H39LunOYP61fv3SPTFKIxFB5rl2ZVbH9THgFrKoJRvwKTyfgjnDK7fagcbXkCYiCMVU0eiMVw376WQ39ptod+2BxTVGfG72ahQKbwdd+s7D/zgdh1zK0pB1nV0Be4ggmlmTLxDIoH14
 aSPYItAn
 iblImOnV8JBWc2xZ65Ci8WYNVseRqED1ToXPLIL4xWmOPkBthTE6ieDYWZ5WI50/LursON46fDWu7fHkTucBF883JTXWz43D/vh2vpXlEYWrOewneYkcP9P73pmziCDl1/MdxEqX7mNrjH5cAHIbA+EOTq+9a1joypv3Fw0SMS7pMLajF7TWp9o+rWHk2S2D5Bm/3jYe4CKkA6p91zjdvuOc1kBHBNZW+/8xVw2mDEQkehevkM6bSSOAbrp5JDY09i9usjoRtyEa5u+qQp3niMAzQtBah4ddYoi1b8vSBt4fph2J+hlJYS/sTgdCx9Bh3uV8/SKbhUegTWowjPByivBUOxafmIaLdQiIJEOX+vLwgN4zi966IAotHfXG77AdWOxs7MNnGFYmMurBsBUsRUhdhY95H73M0wlnLm+R55Jb+6ICVBbm75O/jsEfcrQFmgpMlftzku7CGV520kAJFfizrPEC9muOESoomwh+gcB+fhUhXn25mpQoCTwgehW6niCx2CzTq2yjOXbpRrccce6w2UEfzAQC/OhgoYehA8wj2L4u0TxZ3ExqmxLS5SqlMOWwC
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
 include/linux/kexec_handover.h     |  10 +++
 kernel/liveupdate/kexec_handover.c | 101 +++++++++++++++++++++++++----
 2 files changed, 98 insertions(+), 13 deletions(-)

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
index e836efd98795..abe1a800fb27 100644
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
@@ -410,17 +409,12 @@ static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
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
-
-	adjust_managed_page_count(page, nr_pages);
 	return page;
 }
 
@@ -432,12 +426,43 @@ static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
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
+	adjust_managed_page_count(page, 1UL << order);
 
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
+	adjust_managed_page_count(page, 1UL << order);
+
+	return page;
+}
+EXPORT_SYMBOL_GPL(kho_restore_page);
+
 /**
  * kho_restore_pages - restore list of contiguous order 0 pages.
  * @phys: physical address of the first page.
@@ -457,10 +482,14 @@ struct page *kho_restore_pages(phys_addr_t phys, unsigned long nr_pages)
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
+		adjust_managed_page_count(page, 1UL << info_order);
 		pfn += 1 << order;
 	}
 
@@ -890,6 +919,51 @@ void kho_unpreserve_folio(struct folio *folio)
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
@@ -927,7 +1001,8 @@ static void __kho_unpreserve(struct kho_radix_tree *tree,
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
2.55.0.229.g6434b31f56-goog


