Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62282606B59A
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 18:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=T9YUTmzQ
Received: by kanga.kvack.org (Postfix)
	id 88A0D6B05BB; Mon,  9 Nov 2026 13:25:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 837F26B05BC; Mon,  9 Nov 2026 13:25:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63FED6B05BD; Mon,  9 Nov 2026 13:25:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 352966B05BB
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:25:51 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B7907A8421
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:25:50 +0000 (UTC)
X-FDA: 85416409260.14.88579C4
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	by imf16.hostedemail.com (Postfix) with ESMTP id DBF1818000B
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:25:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=T9YUTmzQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3KxDyagYKCHIbhYppeWeeWbU.SecbYdkn-ccalQSa.ehW@flex--lrizzo.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3KxDyagYKCHIbhYppeWeeWbU.SecbYdkn-ccalQSa.ehW@flex--lrizzo.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794248749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nKbnCwTfLzajXiNpupOHjxARAnB6qVXNJxTLmCpPRqc=;
	b=4P3jVB0pBgU/8X82lE4YZKn5V13tGKzGPit+5DnfNGjTJZ5CoDeMBbmY6r0vVOh01ui0u8
	yQVSL5ftvQmOMq5iFmVUKJH83O4bBzyg+ZSN/16d10th980BwNb1ZmIxTgPuY0U804WS5a
	pzpjlHSjURCwVCfLYoh4/ZGB+uzOWbo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794248749;
	b=vL2tqkzBH2Gm/70MbRT3NfJLBDd9acfViTsVXN5aBEl7v0bBFGCS7e83P/WDjKHdN0GZoR
	9v7NTmemkEb2TTka4F++s06yRzNMBIMmgQJ5eQPexXNt7725pdUuHUVPFT+3US18djDFBG
	XPllIBvrOcAJHz1MmyOROmBaNwEagfo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=T9YUTmzQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3KxDyagYKCHIbhYppeWeeWbU.SecbYdkn-ccalQSa.ehW@flex--lrizzo.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3KxDyagYKCHIbhYppeWeeWbU.SecbYdkn-ccalQSa.ehW@flex--lrizzo.bounces.google.com
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c4d28d38d79so124867266b.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 10:25:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794248747; x=1794853547; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nKbnCwTfLzajXiNpupOHjxARAnB6qVXNJxTLmCpPRqc=;
        b=T9YUTmzQO76OHw2DN+r6vhUtkqCj6cphWBFFHR8YgrfKx3aff7q2RxKCrijP0rN4qa
         gyR5er9GuC6EVogsLDe3qo3gZHRd4pNhMjx0WON+pbkQ/FDRZNhObPVq76cx/ysuKuVt
         YaigwKVHmhd2SvW4260ifBrHXS2rxV/iXtnJ//TC5HAg8O64RKl9C8/rQKL0dnplMmiN
         NoLTJFkDAQEQS9QQc6zRzwLnbgKmSQq6zTVeV7DqxhHLlkuC6qs3okDe1gRSCmbg2acP
         emSMmCrC3se6/r0lmbg7nkeOBgMheBl3/U5/WDhXE3LqSR9XA03ykLKlBK+gVpi+uImH
         w26A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794248747; x=1794853547;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nKbnCwTfLzajXiNpupOHjxARAnB6qVXNJxTLmCpPRqc=;
        b=ixakfYhBnS8qO822NHmfeCp79OueS7LqKciWZcuDd1OiBqhT+cF5glcUS5buxycv3m
         MX1HyWGA2AObbfl6SZTjPRVx6evaW9SK1KpGobpBEiW/aOx9f3Q0WlyIhjHUmpAptmiK
         aTK6amR0zAGfXDysPDpC5+FBISm5tgiLUgifRBXLJNci68Xgd0lTechK4TsEI8ZfDtRl
         xBpIccZ7YbppDbbJBavXTJvgzVpeKa9JuOebpR9JsLtzez+LmL8c3gqN/Po/N5agBE0o
         yCn4Onru0atTkvksNpwzoLDV+qP3T4DMDrV3vyvTgZsVbDHfjq6vIVDez9hOQPy4Sfp6
         b4nQ==
X-Forwarded-Encrypted: i=1; AL+hErHubrRu9uxI7sXM2rYAA1rnv/ES36cHSrIKaIjFgFm8IIgIQiekLpdWZR65F6gO5yGJoMQsiIir4Q==@kvack.org
X-Gm-Message-State: APuU4Z+epuS/YT9X8zDeDrWKWGPirU2bUFT7bYda0vRlBfvNJM3Q9ciF
	h7OzbKooYirpAV4ShtDAo97sthpYGovDDdMbcoD0GWjYD6Cyig63ij/oG4RFVAmZLVicayODHpQ
	GWTJm2g==
X-Received: from ejdlt8-n1.prod.google.com ([2002:a17:907:c648:10b0:c2e:34bc:d4b1])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:3e20:b0:c41:64c1:cc2d
 with SMTP id a640c23a62f3a-c50491bd62emr17857866b.2.1794248747203; Mon, 09
 Nov 2026 10:25:47 -0800 (PST)
Date: Mon,  9 Nov 2026 18:25:18 +0000
In-Reply-To: <20261003212241.3432303-1-lrizzo@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261109182533.3594984-11-lrizzo@google.com>
Subject: [RFC PATCH v2 10/25] iommu/dma: Use PISA for coherent DMA allocations
From: Luigi Rizzo <lrizzo@google.com>
To: Luigi Rizzo <rizzo.unipi@gmail.com>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <willy@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Willem de Bruijn <willemb@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Joshua Washington <joshwash@google.com>, 
	Harshitha Ramamurthy <hramamurthy@google.com>, Alexander Lobakin <aleksander.lobakin@intel.com>, 
	iommu@lists.linux.dev, netdev@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: dbktnwmahk51jpcyptmom7sy9kscxrjc
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DBF1818000B
X-HE-Tag: 1794248748-234315
X-HE-Meta: U2FsdGVkX1/dRJWPCWrNlceZ03g4joAYggThxlVugIMX3oJi05XbUbuSJm4iEwB+24THIQEmKDlBfiOk8Ig9SxgDm0MBGFmkMg+FhsemZOojPfsQy+y/4AlC3Kt0yrWvSljmuOt+FDqDBuFGi14VnR/cSAQTkbP9aNKdrMqDrRCxLCs+M8ZmAE3GEqB13Up+E2nAIIZTCd4jZiLvbmghhhPmLP0rV3LnGJldcKup+K1s7JuCppQ7ZeYbHg+HZEi4eyNePm1lGDTcVOVF0xvZ1kPxOEn0YGEv0UHDYAI2y+Sf7IV85Kh3+5UygRvOvnYltxqkr2Jr93+bF/Nb6kpQZxSgeszamzfmc34PK6q6SYKcYROdEPIr6EmquLpBOcW/UCpefIm4rAjqaR5xPErrb1sVHuX5/hWEXXnYnAYz/QCBN77s/QJk1t6tezlStcriuOJibQMmF4MUM7pOFLBnEBjbHGoOQvNUW338dNx8GDwxxUhAVnmDzpFlAXacTWt/IDXH3iF88DDQ8hhgictlSvwAnhkSyF0vcQrY3ces3nFot1wODpPus68EnQZrRMS3eKodzJkkLdFGWiDYD9bqj2OnUGMuEwYr5jxgibZOwwuMXl+X95nJ4rm+QrqMam60/Dw4PgJbu9xa6EdM4yom6ZVldSjTpVJRN/iOv81vK/eBMYwWFuYpH+6N2t43syFpVYn9rNvWfLUOdhPRD9rfNDlNY7CONz50QBkDQY/oL4fZbpBSVQsqfwppdyL5vxXwYuXpheLHlQEAVS1Zw/oZ3KtI/wNDQHmQa8FuLeM3dIc4jeDGaZdRS3fATC+gurg9lNnxI3ghNZExchgE0J51iyzmOj1k9ER8K0UbJmOhJsXWF/u+ZZ2O2FK/0hCMenucH1ebpwNOf8BrrbsV0VYpScSWaMdBwfDUbAiz3LylGwOVbXy4srpUr3fNQbwrXUt8Bz2lxln36TVeAhwNr/0
 p3tVHxtR
 WHK7Ue1+ovqjxQvRwUF3rN8uV9j7FNlxbx/dRHNddo47TOSfguBweIiIaOw2mPOyFxBaPy2DFcW9WVsgfjp96edUc6vjIBenaajqrw/lsw9644g4QDsOiO3+jDDgf3zj+lbdAfUAf7BYMZG3Ee7jF/rwsg8gPYFUDCEFLVA2aKUAPWXklfz20F/wgcVNIaEfHpspZA1QDFVoyqVZHBe5i9nuKXCrCXWC6dIRa7EB/YRG0gbtrdy6bCWyricNe6ZTwOGDCNRFLlngXSgqTK2ihRSg2nZZCNKYDLKxMAqFMuijkDpR21tX9AoKI/zir0QnWc+ho8wQKj9A9V88I3O5aw2YOU/aSUGIlJNUPLwm4pzL+S6j7m6Zm03stDYKSfH9wLY3IuXNmBH7jcH4iiSxvbchPc9yq3FjLCU6thN9J4iCUZVMsRQgdy6OrxyFYEsqbGTNnIIaYmVT8c4W4wzH9ffvcSadHhB6/RyvFVw6KQJmiGjExOCfPFzBFmLCvdQYvk9YSNpwkFRStiv2WBoReFkLxk/dTBjv53kRywd31z85+yriKjklW8/1mGKLsH28Z2IZCIbSGvgwRl/ILDH5Zsq2he7c5LVLaXaJyLAr8RjjTrKeh2qkjdvT+Dg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Coherent DMA allocations (e.g. TX/RX descriptor rings allocated via
dma_alloc_attrs() / dma_alloc_coherent()) are long-lived and accessed
on every packet or I/O operation, so they benefit from sharing 2MB IOMMU
leaf mappings.

When dev->pisa_coherent is enabled, serve coherent DMA allocations up
to 2MB from the device's per-NUMA-node order-0 read-write PISA
allocator.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 drivers/iommu/dma-iommu.c  |  10 +++
 drivers/iommu/pisa-alloc.c | 146 +++++++++++++++++++++++++++++++++++++
 drivers/iommu/pisa-kunit.c |  67 +++++++++++++++++
 include/linux/pisa.h       |  30 ++++++++
 kernel/dma/direct.c        |   9 +++
 5 files changed, 262 insertions(+)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index eb920ad77c783..a0c5ddab7a8b6 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1658,6 +1658,8 @@ static void __iommu_dma_free(struct device *dev, size_t size, void *cpu_addr)
 	} else {
 		/* Lowmem means a coherent atomic or CMA allocation */
 		page = virt_to_page(cpu_addr);
+		if (pisa_free_coherent(page, alloc_size))
+			return;
 	}
 
 	if (pages)
@@ -1716,6 +1718,7 @@ void *iommu_dma_alloc(struct device *dev, size_t size, dma_addr_t *handle,
 		gfp_t gfp, unsigned long attrs)
 {
 	bool coherent = dev_is_dma_coherent(dev);
+	struct iommu_domain *domain = iommu_get_dma_domain(dev);
 	int ioprot = dma_info_to_prot(DMA_BIDIRECTIONAL, coherent, attrs);
 	bool is_alloc_cc_shared = attrs & __DMA_ATTR_ALLOC_CC_SHARED;
 	struct page *page = NULL;
@@ -1727,6 +1730,12 @@ void *iommu_dma_alloc(struct device *dev, size_t size, dma_addr_t *handle,
 
 	gfp |= __GFP_ZERO;
 
+	if (domain) {
+		cpu_addr = pisa_alloc_coherent(&page, dev, domain, size, gfp, attrs);
+		if (cpu_addr)
+			goto map;
+	}
+
 	if (gfpflags_allow_blocking(gfp) &&
 	    !(attrs & DMA_ATTR_FORCE_CONTIGUOUS)) {
 		return iommu_dma_alloc_remap(dev, size, handle, gfp, attrs);
@@ -1744,6 +1753,7 @@ void *iommu_dma_alloc(struct device *dev, size_t size, dma_addr_t *handle,
 			return NULL;
 	}
 
+map:
 	*handle = __iommu_dma_map(dev, page_to_phys(page), size, ioprot,
 			dev->coherent_dma_mask);
 	if (*handle == DMA_MAPPING_ERROR) {
diff --git a/drivers/iommu/pisa-alloc.c b/drivers/iommu/pisa-alloc.c
index b0d968aa9181c..25e4645310678 100644
--- a/drivers/iommu/pisa-alloc.c
+++ b/drivers/iommu/pisa-alloc.c
@@ -10,6 +10,8 @@
 #include <linux/bitops.h>
 #include <linux/cache.h>
 #include <linux/device.h>
+#include <linux/dma-direct.h>
+#include <linux/dma-map-ops.h>
 #include <linux/dma-mapping.h>
 #include <linux/pisa.h>
 #include <linux/export.h>
@@ -697,6 +699,150 @@ unsigned long pisa_alloc_bulk(struct pisa_alloc *pa, gfp_t gfp,
 	return i;
 }
 
+/* Find and reserve @nblocks aligned contiguous blocks in @meta under @pa->lock. */
+static struct page *pisa_take_contig(struct pisa_meta *meta, unsigned int nblocks,
+				     unsigned long align_mask)
+{
+	DECLARE_BITMAP(busy, PISA_MAX_BLOCKS);
+	struct pisa_alloc *pa = meta->pa;
+	unsigned int bpp = PISA_BLOCKS(0), i;
+	bool poisoned = false;
+	unsigned long off;
+	struct page *page;
+
+	if (pisa_meta_avail(meta) < nblocks)
+		return NULL;
+
+	bitmap_or(busy, meta->clean_bitmap, meta->dirty_bitmap, bpp);
+	bitmap_complement(busy, busy, bpp);
+
+	off = 0;
+	for (;;) {
+		off = bitmap_find_next_zero_area(busy, bpp, off, nblocks, align_mask);
+		if (off >= bpp) {
+			if (poisoned) {
+				if (meta->on_list == PISA_LIST_IDLE_CLEAN ||
+				    meta->on_list == PISA_LIST_IDLE_DIRTY)
+					pa->num_idle_pages--;
+				pisa_place_meta(meta);
+			}
+			return NULL;
+		}
+
+		page = pfn_to_page(pisa_meta_to_pfn(meta) + off);
+		for (i = 0; i < nblocks; i++) {
+			if (!pisa_block_poisoned(pa, page + i))
+				continue;
+			if (__test_and_clear_bit(off + i, meta->clean_bitmap))
+				meta->nr_clean--;
+			else if (__test_and_clear_bit(off + i, meta->dirty_bitmap))
+				meta->nr_dirty--;
+			__set_bit(off + i, busy);
+			poisoned = true;
+			off += i + 1;
+			break;
+		}
+		if (i == nblocks)
+			break;
+	}
+
+	if (meta->on_list == PISA_LIST_IDLE_CLEAN ||
+	    meta->on_list == PISA_LIST_IDLE_DIRTY)
+		pa->num_idle_pages--;
+
+	for (i = 0; i < nblocks; i++) {
+		if (__test_and_clear_bit(off + i, meta->clean_bitmap)) {
+			meta->nr_clean--;
+		} else {
+			__clear_bit(off + i, meta->dirty_bitmap);
+			meta->nr_dirty--;
+		}
+		pisa_block_prep(page + i);
+		page_ref_unfreeze(page + i, 1);
+	}
+	pisa_place_meta(meta);
+	return page;
+}
+
+/*
+ * Specialized memory provider for iommu_dma_alloc() and dma_direct_alloc():
+ * allocate a zeroed, naturally aligned contiguous range of order-0 pages for
+ * @size bytes (<= PISA_SIZE) from @dev's per-node coherent allocator into
+ * *@pagep and return its kernel virtual address, or NULL.
+ */
+void *pisa_alloc_coherent(struct page **pagep, struct device *dev,
+			  struct iommu_domain *domain, size_t size,
+			  gfp_t gfp, unsigned long attrs)
+{
+	bool should_release = false;
+	struct list_head *lists[3];
+	unsigned long align_mask, flags;
+	unsigned int nblocks, i;
+	struct pisa_meta *meta;
+	struct pisa_alloc *pa;
+	struct page *page = NULL;
+
+	size = PAGE_ALIGN(size);
+	if (!pagep || !dev || !READ_ONCE(dev->pisa_coherent) ||
+	    !dev_is_dma_coherent(dev) || !size || size > PISA_SIZE)
+		return NULL;
+	if (min_not_zero(dev->coherent_dma_mask, dev->bus_dma_limit) <= DMA_BIT_MASK(32))
+		return NULL;
+	if ((current_gfp_context(gfp) & ~(__GFP_ZERO | __GFP_NOWARN)) != GFP_KERNEL ||
+	    (attrs & ~DMA_ATTR_NO_WARN))
+		return NULL;
+
+	if (domain) {
+		struct pisa_window *win = pisa_dma_window(domain);
+
+		if (!win || pisa_window_declined(win) || !(domain->pgsize_bitmap & PISA_SIZE))
+			return NULL;
+	} else if (is_swiotlb_for_alloc(dev) ||
+		   force_dma_unencrypted(dev) ||
+		   !dma_coherent_ok(dev, PFN_PHYS(max_pfn) - 1, 1)) {
+		return NULL;
+	}
+
+	pa = pisa_node_pa(dev_to_node(dev), 0, false);
+	if (!pa)
+		return NULL;
+
+	nblocks = size >> PAGE_SHIFT;
+	align_mask = (1UL << get_order(size)) - 1;
+	lists[0] = &pa->partial;
+	lists[1] = &pa->partial_dirty;
+	lists[2] = &pa->idle;
+
+	spin_lock_irqsave(&pa->lock, flags);
+	for (i = 0; i < ARRAY_SIZE(lists) && !page; i++) {
+		list_for_each_entry(meta, lists[i], list) {
+			page = pisa_take_contig(meta, nblocks, align_mask);
+			if (page)
+				break;
+		}
+	}
+	if (!page) {
+		spin_unlock_irqrestore(&pa->lock, flags);
+		meta = pisa_alloc_split_page(0, gfp, pa->nid);
+		if (IS_ERR(meta))
+			return NULL;
+		spin_lock_irqsave(&pa->lock, flags);
+		meta->pa = pa;
+		meta->prot = pa->prot;
+		WRITE_ONCE(meta->flags, meta->flags | PISA_ACTIVE);
+		page = pisa_take_contig(meta, nblocks, align_mask);
+		if (unlikely(!page))
+			should_release = pisa_place_meta(meta);
+	}
+	spin_unlock_irqrestore(&pa->lock, flags);
+
+	if (should_release)
+		pisa_schedule_reclaim();
+	if (!page)
+		return NULL;
+	*pagep = page;
+	return memset(page_address(page), 0, size);
+}
 
 /**
  * __pisa_free_page - Recycle a freed block back into its PISA allocator
diff --git a/drivers/iommu/pisa-kunit.c b/drivers/iommu/pisa-kunit.c
index ab64657ad5c58..72ee8986b4802 100644
--- a/drivers/iommu/pisa-kunit.c
+++ b/drivers/iommu/pisa-kunit.c
@@ -352,6 +352,72 @@ static void test_map_and_domain_lifecycle(struct kunit *test)
 }
 #endif /* CONFIG_IOMMU_DMA */
 
+static void test_coherent_alloc_and_free(struct kunit *test)
+{
+	struct device dev = { .init_name = "pisa_kunit", .numa_node = NUMA_NO_NODE,
+			      .coherent_dma_mask = DMA_BIT_MASK(64),
+			      .pisa_coherent = true };
+	struct page *p1, *p2, *p3;
+	void *v1, *v2, *v3;
+#ifdef CONFIG_IOMMU_DMA
+	struct pisa_window *win;
+	dma_addr_t d1, d2;
+#endif
+
+	dev.dma_mask = &dev.coherent_dma_mask;
+	/* NUMA_NO_NODE would follow the node of the CPU the test runs on. */
+	set_dev_node(&dev, first_memory_node);
+#if defined(CONFIG_ARCH_HAS_SYNC_DMA_FOR_DEVICE) || \
+	defined(CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU) || \
+	defined(CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU_ALL)
+	dev.dma_coherent = true;
+#endif
+	KUNIT_EXPECT_NULL(test, pisa_alloc_coherent(&p1, NULL, NULL, SZ_4K, GFP_KERNEL, 0));
+	KUNIT_EXPECT_NULL(test, pisa_alloc_coherent(&p1, &dev, NULL, SZ_4K,
+						    GFP_KERNEL | __GFP_ACCOUNT, 0));
+	KUNIT_EXPECT_NULL(test, pisa_alloc_coherent(&p1, &dev, NULL, PISA_SIZE + SZ_4K,
+						    GFP_KERNEL, 0));
+
+#ifdef CONFIG_IOMMU_DMA
+	/* Uninitialized domain has no DMA cookie/window yet. */
+	KUNIT_EXPECT_NULL(test, pisa_alloc_coherent(&p1, &dev, &fake_domain, SZ_4K,
+						    GFP_KERNEL | __GFP_NOWARN, 0));
+
+	KUNIT_ASSERT_EQ(test, fake_domain_setup(test), 0);
+	win = pisa_dma_window(&fake_domain);
+
+	v1 = pisa_alloc_coherent(&p1, &dev, &fake_domain, SZ_64K, GFP_KERNEL, 0);
+	KUNIT_ASSERT_NOT_NULL(test, v1);
+	KUNIT_ASSERT_EQ(test,
+			pisa_map_phys(&d1, &dev, &fake_domain, page_to_phys(p1), SZ_64K,
+				      IOMMU_READ | IOMMU_WRITE | IOMMU_CACHE), 0);
+	KUNIT_EXPECT_TRUE(test, is_pisa_iova(win, d1));
+
+	v2 = pisa_alloc_coherent(&p2, &dev, &fake_domain, SZ_64K, GFP_KERNEL, 0);
+	KUNIT_ASSERT_NOT_NULL(test, v2);
+	KUNIT_EXPECT_PTR_EQ(test, v2, v1 + SZ_64K);
+	KUNIT_ASSERT_EQ(test,
+			pisa_map_phys(&d2, &dev, &fake_domain, page_to_phys(p2), SZ_64K,
+				      IOMMU_READ | IOMMU_WRITE | IOMMU_CACHE), 0);
+	KUNIT_EXPECT_EQ(test, d2, d1 + SZ_64K);
+#else
+	v1 = pisa_alloc_coherent(&p1, &dev, NULL, SZ_64K, GFP_KERNEL, 0);
+	KUNIT_ASSERT_NOT_NULL(test, v1);
+	v2 = pisa_alloc_coherent(&p2, &dev, NULL, SZ_64K, GFP_KERNEL, 0);
+	KUNIT_ASSERT_NOT_NULL(test, v2);
+	KUNIT_EXPECT_PTR_EQ(test, v2, v1 + SZ_64K);
+#endif
+
+	/* Freeing p1 returns its 16 order-0 pages; next 64K alloc reuses them. */
+	KUNIT_EXPECT_TRUE(test, pisa_free_coherent(p1, SZ_64K));
+	v3 = pisa_alloc_coherent(&p3, &dev, NULL, SZ_64K, GFP_KERNEL, 0);
+	KUNIT_ASSERT_NOT_NULL(test, v3);
+	KUNIT_EXPECT_PTR_EQ(test, p3, p1);
+
+	KUNIT_EXPECT_TRUE(test, pisa_free_coherent(p2, SZ_64K));
+	KUNIT_EXPECT_TRUE(test, pisa_free_coherent(p3, SZ_64K));
+}
+
 static void kunit_check_pisa_attr(struct kunit *test, struct device *dev,
 				  const char *name, bool *field)
 {
@@ -431,6 +497,7 @@ static struct kunit_case pisa_meta_test_cases[] = {
 	KUNIT_CASE(test_window_helpers),
 	KUNIT_CASE(test_map_and_domain_lifecycle),
 #endif
+	KUNIT_CASE(test_coherent_alloc_and_free),
 	KUNIT_CASE(test_dev_pisa_attrs),
 	KUNIT_CASE(test_reservoir_and_scrubber),
 	{}
diff --git a/include/linux/pisa.h b/include/linux/pisa.h
index 92482fce943e9..a6556aa403a09 100644
--- a/include/linux/pisa.h
+++ b/include/linux/pisa.h
@@ -13,6 +13,7 @@
 #include <linux/rcupdate.h>
 
 struct device;
+struct iommu_domain;
 
 #ifdef CONFIG_PISA
 
@@ -78,6 +79,21 @@ static inline bool pisa_free_page(struct page *page)
 	return ret;
 }
 
+void *pisa_alloc_coherent(struct page **pagep, struct device *dev,
+			  struct iommu_domain *domain, size_t size,
+			  gfp_t gfp, unsigned long attrs);
+
+static inline bool pisa_free_coherent(struct page *page, size_t size)
+{
+	unsigned long count = PAGE_ALIGN(size) >> PAGE_SHIFT;
+
+	if (!page || !is_pisa_page(page))
+		return false;
+	while (count--)
+		__free_page(page++);
+	return true;
+}
+
 unsigned long pisa_alloc_pages_bulk(gfp_t gfp, unsigned int order,
 				    int preferred_nid, nodemask_t *nodemask,
 				    int nr_pages, struct page **page_array,
@@ -109,6 +125,20 @@ static inline bool pisa_free_page(struct page *page)
 	return false;
 }
 
+static inline void *pisa_alloc_coherent(struct page **pagep,
+					struct device *dev,
+					struct iommu_domain *domain,
+					size_t size, gfp_t gfp,
+					unsigned long attrs)
+{
+	return NULL;
+}
+
+static inline bool pisa_free_coherent(struct page *page, size_t size)
+{
+	return false;
+}
+
 static inline unsigned long
 pisa_alloc_pages_bulk(gfp_t gfp, unsigned int order, int preferred_nid,
 		      nodemask_t *nodemask, int nr_pages,
diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 25e9a86835fd3..11052b65e573b 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 #include <linux/pci-p2pdma.h>
 #include <linux/cc_platform.h>
+#include <linux/pisa.h>
 
 #include "direct.h"
 
@@ -244,6 +245,12 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 	if (attrs & DMA_ATTR_NO_WARN)
 		gfp |= __GFP_NOWARN;
 
+	cpu_addr = pisa_alloc_coherent(&page, dev, NULL, size, gfp, attrs);
+	if (cpu_addr) {
+		*dma_handle = phys_to_dma_direct(dev, page_to_phys(page), false);
+		return cpu_addr;
+	}
+
 	if (dma_direct_use_no_mapping(dev, attrs))
 		return dma_direct_alloc_no_mapping(dev, size, dma_handle, gfp);
 
@@ -424,6 +431,8 @@ void dma_direct_free(struct device *dev, size_t size,
 
 	if (is_vmalloc_addr(cpu_addr)) {
 		vunmap(cpu_addr);
+	} else if (pisa_free_coherent(virt_to_page(cpu_addr), size)) {
+		return;
 	} else {
 		if (IS_ENABLED(CONFIG_ARCH_HAS_DMA_CLEAR_UNCACHED))
 			arch_dma_clear_uncached(cpu_addr, size);
-- 
2.56.0.542.g3ef89b7020-goog


