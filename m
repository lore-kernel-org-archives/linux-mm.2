Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86E97C982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 14:50:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 972386B00A6; Mon, 21 Sep 2026 10:50:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 948CA6B00B1; Mon, 21 Sep 2026 10:50:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 837936B00BC; Mon, 21 Sep 2026 10:50:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 608FF6B00A6
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:50:17 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0CCC9A4126
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:50:17 +0000 (UTC)
X-FDA: 85238054874.25.08A924B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 63ADD40009
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:50:15 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ik8PkMSE;
	spf=pass (imf04.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790002215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aWYdZ91y2ZIXgzfNWppX/K87BNGkPgAm/JMTyJDzEh4=;
	b=hnAdNEN1ChbOb7fqOguD22faw7IpFlJkZb/fZ8Vy3iev4Dbz5yfo2DbvwPbc/X8g6PhNRR
	zzN4HET5sPlzNs1mWUoV6Hblj1AipI5tfzCT2wX/8uNIHCqk+dqSh9r1Nt51js+tlIHATH
	FsP4hg3rEutlUUtnwmkVPwcPxzTCbjc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790002215;
	b=8kmhTft9TBY+j5oBgibcooOhK5IcCOLvVwFiTjeRBZMBE/i8ZW5OSYTM0wgIxa1VYJNf52
	k8eIJZLP4JbjKAlEW+U9nqbdxS/1xB8zSvciKjxJuuUzgKphSYIxQzNqSk41piXwYgKOyu
	e8Qskw897DWqf/tmhs8OBKVPXawVAm0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ik8PkMSE;
	spf=pass (imf04.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AE08F433F7;
	Mon, 21 Sep 2026 14:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 817AE1F008A1;
	Mon, 21 Sep 2026 14:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790002214;
	bh=aWYdZ91y2ZIXgzfNWppX/K87BNGkPgAm/JMTyJDzEh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ik8PkMSEyJLfZFUGTT09e/znzmIj1IQB1TBp51D5k+Yy0ho+aw3/dRdBdIpRmKYnr
	 ZX0EP5g0NObBCy2Gjw2BuyvDeKhrqS+fY/IdnQoAEEECDsWQ3gk00OnyJEj94hJEsS
	 jcs/OA949tuP2PX2vfy+us7YkGRG7OZKcMEHoajnenBSSE1rRr5PMTaippawTE2vpC
	 678DJsoB1qY8zfYxIX4yfz7lpI2H6IGYT22cB5GPSXDOBmyMgKu3O0QYqM4ivx4SfI
	 Cld32H3UEmro8rXX+UU0djHeoYDylyNw0S8cJfuOsD6TdJzT/bK/IAFSMizS0sB+UB
	 4AZHXeqwquuiw==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	christian.koenig@amd.com,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v7 08/13] dma-direct: Align CoCo shared DMA allocations to the shared granule size
Date: Mon, 21 Sep 2026 20:18:42 +0530
Message-ID: <20260921144847.501151-9-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260921144847.501151-1-aneesh.kumar@kernel.org>
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 63ADD40009
X-Stat-Signature: hfx5rsjwo1ggat989zy3hs36mg7rnqt5
X-Rspam-User: 
X-HE-Tag: 1790002215-446999
X-HE-Meta: U2FsdGVkX19f5bf2WvYHE99EVLw+V8wrdA0q5vVUYQ0ASQJ/bAKNect/QTf4eKHDdjbZrdXOa1eESEzyrwf9ZkDwZpUYVM8oVDXPrg+tpIhe5+1Mxi0fYlqKXlbky4aXXvOTuvFLXwLVp24xGpmivHcxzMIPAnOrEGs/KBSLkvGdX1N3dKWCc5EiLyezHwYBhVOP5EhlhE0ZPY25WhEPZhQxBVFcDQXxJSlw+W+TtP0jVeadQ56dnuAt8FWzTQMSeyfs6ZREbjkOmuyu63BauppNktTDdtH+m0Q3JT1SdJ8liZUxXfxfuSkHhbDzMP79kXu74yVWWAFfaZyvWUwqokYLCSimeVAaq7ZyNzfqkU0lF2L5GpW1HpwGxo+ukoA7HxgVnqW4pthi0bRSuIqtg5iwlp27E8I69AnebPEuChR0jQlyRUblNj2HVbNoR1E5Y0fkqQhnegtECnkunRJvHxZWMm4k9hlarJnFtqBB5k/1EDIGEi36roBuNijeBBdMsibeek1E5gIiuZOZsB2WR3Q/QK1EY388BBLPJwXLBzFNzVAFSg8eS9uZNmtUqTx1tG4gJCXV9smK21uJRvVH0Jz/q94O/wpf2m68mdxTq6QXszDEJzRZhqWpxLxK8lqgn4Ayehr5omormpoL0cMmTQ/MNr05L5jQQIEtoLdDKsaqDxfTl4i7/Rd7a3+kyEwOgUSZ4dexaqaUUtgmReztWRX2H/rOJwfA1uYZfMALrXu2FLUm0Yxs6fjVtqrQysBwfWCE7nhaf1QFrLohcOIzXnB5Jl/kdi2xgHZuDMdK5pWq+LZLrvyaxzdKp5kTsYw8PngBEmhXhBRXcLalCup0/Z9D/ziGY7tpxMPLTa9avPi+O/GfU3mozfnxj5U0AQofMPaf7IFgT0r96mpgzKNedhxZ5FxIByOR4b4evFUnFmvDnsqL8o9PWhqPWsSADIOBq9A+0T3ggjqX1YJAfUZ
 G3h4yYvf
 CrTe2qXD7vFKkzTpZ5TrYv5IcobcoVtZ1IL06RnyeDMB+3X47d85LKfobdojQkdTe8R9/Y09DLIpkAdKbB6WYI+dP4ru1SVR23trD8JdalrgSjZcRlFO8Qd23UsWoCa8qlxjBguBkm4orhssQLuR1/9s4H8+IP+x4xVS3DWiX4pOMwVTUJ2BWfM6Omq2r5DwrJBfzLB5SLCLwPZvaQw6Zu8WymPBkQVUBLmWyWBmsny4mMs0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the common CoCo shared-memory geometry helpers for allocations
backed directly by CMA or the page allocator. Round the backing
allocation to a whole shared granule, pass the required alignment order
through the DMA contiguous allocator, and transition the complete range
through the common shared/private helpers.

Recompute the layout before freeing ordinary direct allocations so the
transition back to private memory and dma_free_contiguous() cover
exactly the range acquired by the allocation path. If restoring private
state fails, retain the existing fail-safe behavior and leak the pages
rather than returning potentially shared memory to the allocator.

This also applies the same rules to dma_direct_alloc_pages(), covering
callers which require a struct page result rather than a CPU virtual
address.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 kernel/dma/direct.c | 55 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 43 insertions(+), 12 deletions(-)

diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index d968a0c81e73..d293198384c3 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -11,10 +11,10 @@
 #include <linux/scatterlist.h>
 #include <linux/pfn.h>
 #include <linux/vmalloc.h>
-#include <linux/set_memory.h>
 #include <linux/slab.h>
 #include <linux/pci-p2pdma.h>
 #include <linux/cc_platform.h>
+#include <linux/cc_shared.h>
 
 #include "direct.h"
 
@@ -85,7 +85,7 @@ static int dma_set_decrypted(struct device *dev, void *vaddr, size_t size)
 {
 	int ret;
 
-	ret = set_memory_decrypted((unsigned long)vaddr, PFN_UP(size));
+	ret = cc_make_shared(vaddr, size);
 	if (ret)
 		pr_warn_ratelimited("leaking DMA memory that can't be decrypted\n");
 	return ret;
@@ -95,7 +95,7 @@ static int dma_set_encrypted(struct device *dev, void *vaddr, size_t size)
 {
 	int ret;
 
-	ret = set_memory_encrypted((unsigned long)vaddr, PFN_UP(size));
+	ret = cc_make_private(vaddr, size);
 	if (ret)
 		pr_warn_ratelimited("leaking DMA memory that can't be re-encrypted\n");
 	return ret;
@@ -115,7 +115,7 @@ static struct page *dma_direct_alloc_swiotlb(struct device *dev, size_t size,
 }
 
 static struct page *__dma_direct_alloc_pages(struct device *dev, size_t size,
-		gfp_t gfp, bool allow_highmem)
+		gfp_t gfp, bool allow_highmem, unsigned int align_order)
 {
 	int node = dev_to_node(dev);
 	struct page *page;
@@ -124,7 +124,7 @@ static struct page *__dma_direct_alloc_pages(struct device *dev, size_t size,
 	WARN_ON_ONCE(!PAGE_ALIGNED(size));
 
 	gfp |= dma_direct_optimal_gfp_mask(dev, &phys_limit);
-	page = dma_alloc_contiguous(dev, size, gfp, 0);
+	page = dma_alloc_contiguous(dev, size, gfp, align_order);
 	if (page) {
 		if (dma_coherent_ok(dev, page_to_phys(page), size) &&
 		    (allow_highmem || !PageHighMem(page)))
@@ -184,7 +184,7 @@ static void *dma_direct_alloc_no_mapping(struct device *dev, size_t size,
 {
 	struct page *page;
 
-	page = __dma_direct_alloc_pages(dev, size, gfp & ~__GFP_ZERO, true);
+	page = __dma_direct_alloc_pages(dev, size, gfp & ~__GFP_ZERO, true, 0);
 	if (!page)
 		return NULL;
 
@@ -205,6 +205,8 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 	bool remap = false, set_uncached = false;
 	bool mark_mem_decrypt = false;
 	bool allow_highmem = true;
+	struct cc_shared_layout layout;
+	unsigned int align_order = 0;
 	struct page *page;
 	void *cpu_addr;
 
@@ -285,8 +287,16 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 		return NULL;
 	}
 
+	if (mark_mem_decrypt) {
+		if (cc_shared_calc_layout(size, &layout))
+			return NULL;
+		size = layout.shared_size;
+		align_order = get_order(layout.alignment);
+	}
+
 	/* we always manually zero the memory once we are done */
-	page = __dma_direct_alloc_pages(dev, size, gfp & ~__GFP_ZERO, allow_highmem);
+	page = __dma_direct_alloc_pages(dev, size, gfp & ~__GFP_ZERO,
+					allow_highmem, align_order);
 	if (!page)
 		return NULL;
 
@@ -305,7 +315,7 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 		void *lm_addr;
 
 		lm_addr = page_address(page);
-		if (set_memory_decrypted((unsigned long)lm_addr, PFN_UP(size)))
+		if (dma_set_decrypted(dev, lm_addr, size))
 			goto out_leak_pages;
 	}
 
@@ -362,6 +372,7 @@ void dma_direct_free(struct device *dev, size_t size,
 	phys_addr_t phys;
 	bool mark_mem_encrypted = false;
 	struct io_tlb_pool *swiotlb_pool;
+	struct cc_shared_layout layout;
 	unsigned int page_order = get_order(size);
 
 	/*
@@ -406,6 +417,12 @@ void dma_direct_free(struct device *dev, size_t size,
 		/* Swiotlb doesn't need a page attribute update on free */
 		mark_mem_encrypted = false;
 
+	if (mark_mem_encrypted) {
+		if (WARN_ON_ONCE(cc_shared_calc_layout(size, &layout)))
+			return;
+		size = layout.shared_size;
+	}
+
 	if (is_vmalloc_addr(cpu_addr)) {
 		vunmap(cpu_addr);
 	} else {
@@ -417,10 +434,8 @@ void dma_direct_free(struct device *dev, size_t size,
 		void *lm_addr;
 
 		lm_addr = phys_to_virt(phys);
-		if (set_memory_encrypted((unsigned long)lm_addr, PFN_UP(size))) {
-			pr_warn_ratelimited("leaking DMA memory that can't be re-encrypted\n");
+		if (dma_set_encrypted(dev, lm_addr, size))
 			return;
-		}
 	}
 
 	if (swiotlb_pool)
@@ -433,6 +448,8 @@ struct page *dma_direct_alloc_pages(struct device *dev, size_t size,
 		dma_addr_t *dma_handle, enum dma_data_direction dir, gfp_t gfp)
 {
 	unsigned long attrs = 0;
+	struct cc_shared_layout layout;
+	unsigned int align_order = 0;
 	struct page *page;
 	void *cpu_addr;
 
@@ -452,7 +469,14 @@ struct page *dma_direct_alloc_pages(struct device *dev, size_t size,
 		goto setup_page;
 	}
 
-	page = __dma_direct_alloc_pages(dev, size, gfp, false);
+	if (attrs & __DMA_ATTR_ALLOC_CC_SHARED) {
+		if (cc_shared_calc_layout(size, &layout))
+			return NULL;
+		size = layout.shared_size;
+		align_order = get_order(layout.alignment);
+	}
+
+	page = __dma_direct_alloc_pages(dev, size, gfp, false, align_order);
 	if (!page)
 		return NULL;
 
@@ -476,6 +500,7 @@ void dma_direct_free_pages(struct device *dev, size_t size,
 	phys_addr_t phys;
 	void *vaddr = page_address(page);
 	struct io_tlb_pool *swiotlb_pool;
+	struct cc_shared_layout layout;
 	/*
 	 * if the device had requested for an unencrypted buffer,
 	 * convert it to encrypted on free
@@ -492,6 +517,12 @@ void dma_direct_free_pages(struct device *dev, size_t size,
 	if (swiotlb_pool)
 		mark_mem_encrypted = false;
 
+	if (mark_mem_encrypted) {
+		if (WARN_ON_ONCE(cc_shared_calc_layout(size, &layout)))
+			return;
+		size = layout.shared_size;
+	}
+
 	if (mark_mem_encrypted && dma_set_encrypted(dev, vaddr, size))
 		return;
 
-- 
2.43.0


