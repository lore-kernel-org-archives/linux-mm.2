Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4E11C87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 12:43:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 640EC6B00AB; Mon,  4 Aug 2025 08:43:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 619586B00AC; Mon,  4 Aug 2025 08:43:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 507D76B00AD; Mon,  4 Aug 2025 08:43:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 403786B00AB
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:43:47 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0C9F2C0287
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:43:47 +0000 (UTC)
X-FDA: 83739041694.02.2ECB7B5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7E98A20006
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:43:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sRzNIswy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754311425; a=rsa-sha256;
	cv=none;
	b=cj/oq9fXonbWHne9nxf7jORi6mdf3V9o3+XM4cyfUOc5/LAo9jl269tizoGNqpFAYplBxw
	h2fJyD58QiaIBfj514wCia+GTd2dXfMiLLrMBFXibO83WGl60rJ9htiYVGB6EcvJaUQ/e5
	kMSn7QtFimzHpIDcgH3hcHHMGTpnRMc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sRzNIswy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754311425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u2ZFZgNbfoXn5jH3X4iUOrDOvE7XGwUp7euhaxLVE2Q=;
	b=x/49cXEYcDZZlq5vqCv+exKW+QHfUrQnWpvAGo6/PwKQllAH0X8jnrC2ifGjwa/fq5w1Pz
	LkBz7Sk0W5BcWfYMujkxNEHjNBhhQIyCvwFAiDDy0P/fsDt/T3SggG85kTQNh/ajX08y7L
	X2h4gDbMS0QdAfXPDp5hGvH/slYAG1M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AE031601FD;
	Mon,  4 Aug 2025 12:43:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9423FC4CEE7;
	Mon,  4 Aug 2025 12:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754311424;
	bh=974P2mquMC7dLPtwo4RbF3aKdnRgjXusEE0OKr9VEPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sRzNIswyOXbP49BscDBQ+94sPL3uQydFVa6yD3MLC4jh0WkntDIM+qnsOlQuXDIVr
	 wxnQwyeKJFQGPd7H59/m+DRXV9WGkkfngBQYFQnV2Vx5zdbDTmlp3SKPzzugttJ5wK
	 Y94WaLaho7OI9fqCDv7wnjA4LbMPxMu1m7XNoFz9vxQttjkrfNEZgFRlKOgE5FUG9O
	 9S+EDseCadKtr6Zd8jY55mBnPek99fWQfl0LLIwkcioEL+wWEh9akcqBS/aNmw3uOI
	 i2gfa9Kf8zAEiD7yipdlK7kOpCvN+05lo1g4pMkP27RWr31YBzoQ7Nv4fuU8IiE/Yw
	 SuLv6jnr2CKZg==
From: Leon Romanovsky <leon@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Abdiel Janulgue <abdiel.janulgue@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>,
	Danilo Krummrich <dakr@kernel.org>,
	iommu@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Joerg Roedel <joro@8bytes.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Juergen Gross <jgross@suse.com>,
	kasan-dev@googlegroups.com,
	Keith Busch <kbusch@kernel.org>,
	linux-block@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-nvme@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-trace-kernel@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	rust-for-linux@vger.kernel.org,
	Sagi Grimberg <sagi@grimberg.me>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	virtualization@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	xen-devel@lists.xenproject.org
Subject: [PATCH v1 07/16] dma-mapping: convert dma_direct_*map_page to be phys_addr_t based
Date: Mon,  4 Aug 2025 15:42:41 +0300
Message-ID: <882499bb37bf4af3dece27d9f791a8982ca4c6a7.1754292567.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1754292567.git.leon@kernel.org>
References: <cover.1754292567.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7E98A20006
X-Stat-Signature: dmaztjn38by774itkophxcbwgrxe448t
X-Rspam-User: 
X-HE-Tag: 1754311425-294634
X-HE-Meta: U2FsdGVkX18v6VeuA7cyfrfWL1EXcOKbZrrMdiPpME7YSidvkn/1ZnHAzYL5ajdLr/Ttw9FAlXmyyZk53kR/+WioN3+Og3Ty+tFJmcNtOBIP+BOXwcSyh/B5ITXeTt70hc0jHsGUBgf0+x+Wyvl30lpOXhV51fuZglJv2NE1YQe2D8GIxDs0EICn5Jk2kektJTHWF/P0ZqjKV+7MjpA6r3+VinWwn+KUpOG9h09nGsbT7IY0L1JVMFpjMBeYIdo5VYzd9xNT4ubCpbz9GWGNzatdwb/CeU6Vxx0bE8+ucrSWKSgGRtm2vrS8YyNeukh1fRKfw4RWvJ7hALPU5Oqi05kiGXa/uHJkNbR4Qv15av7hdBaIyroIxQ5LSLHS9xylTPJzLXsH2NgHUSE8Qx+21tn5rteeNp0Q1owRxzLXgiAsyiw4y6IRXmbySpI3TyrgwCB9huas1r3VZzB9n4hIxF1KFnKSj4Y+St6bYarsL74MioIdJx5ALJq42dhm47BcQ8PQ7/Pwf9Y/fZQWZT3ofpNwHUzo67KdV4aOJAhbctziXkWguhOrVz5dCtgse5uBYkX7MQNuKbsovTL1Q0QDnZ1MlVhOVKiT01gweV/diLceX8RFaJ69D99ijggHA7KuQluqZGa32A0BtEn0zhZnE7SPxtgu3rR8+/cWDVNQLfbvfr+EYA+ROqNS4vZ9tqRNt5XdVQPumq/6qLwy07iH+RKvXQpMoYDxPSiusgaR0NtPSo0sNZWcTpN+F7YBAH2MUTP6T7PGwhjk1whQn3Ea6CyjXkkSp+BjceCkGF5qQICBkhiiuPeW6+GzlLRibulMsvVAaG31hcMtR+aq+AApiYUF4PXvEz8ZClOzsQO/+ZPHCBvmMlBStzln8vhQrkMweEZMZ/2tjC4wMEVtgB8jAEBh4MYA3pTnAZXlv8B0rqXTxp1/R9MZc4nHdB+EGS8i6DuNkHGuBarALJ2TRq3
 eu6VxaiF
 cDgzMZ0suZVlNeV+Leo2GxglpDBcULcLsmIYnH8OywPPtE9aKcD1nwkHP30Rr0Go/6jkYHGDA3Cnxat/wK+VjaD/GrSGkm3FhrEjbWkwck2Bmag/er+LTf2r+1wAz7tR9CFI0/qARUfrO5qngvy/oJJhS2tlg44LGr4a2WE8zqiU+vOv81M8xjQic3hq4bO3/erIy4/iQUTV7xNV5BeYrQd/IAeNiyZuLvt3aLC3jRQx72Z8kF0YBAKaryoSve+evNhCb976AIPPtuyF4xNY0IypDI6uaa69sylBlFRsIwFNM3KH+gfn1f0lmjgu+i37ESiwi1CMKlzRCQ2eooJ8yf8bJXWUkjyvyfm16
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

Convert the DMA direct mapping functions to accept physical addresses
directly instead of page+offset parameters. The functions were already
operating on physical addresses internally, so this change eliminates
the redundant page-to-physical conversion at the API boundary.

The functions dma_direct_map_page() and dma_direct_unmap_page() are
renamed to dma_direct_map_phys() and dma_direct_unmap_phys() respectively,
with their calling convention changed from (struct page *page,
unsigned long offset) to (phys_addr_t phys).

Architecture-specific functions arch_dma_map_page_direct() and
arch_dma_unmap_page_direct() are similarly renamed to
arch_dma_map_phys_direct() and arch_dma_unmap_phys_direct().

The is_pci_p2pdma_page() checks are replaced with DMA_ATTR_MMIO checks
to allow integration with dma_direct_map_resource and dma_direct_map_phys()
is extended to support MMIO path either.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 arch/powerpc/kernel/dma-iommu.c |  4 +--
 include/linux/dma-map-ops.h     |  8 +++---
 kernel/dma/direct.c             |  6 ++--
 kernel/dma/direct.h             | 50 ++++++++++++++++++++-------------
 kernel/dma/mapping.c            |  8 +++---
 5 files changed, 44 insertions(+), 32 deletions(-)

diff --git a/arch/powerpc/kernel/dma-iommu.c b/arch/powerpc/kernel/dma-iommu.c
index 4d64a5db50f38..0359ab72cd3ba 100644
--- a/arch/powerpc/kernel/dma-iommu.c
+++ b/arch/powerpc/kernel/dma-iommu.c
@@ -14,7 +14,7 @@
 #define can_map_direct(dev, addr) \
 	((dev)->bus_dma_limit >= phys_to_dma((dev), (addr)))
 
-bool arch_dma_map_page_direct(struct device *dev, phys_addr_t addr)
+bool arch_dma_map_phys_direct(struct device *dev, phys_addr_t addr)
 {
 	if (likely(!dev->bus_dma_limit))
 		return false;
@@ -24,7 +24,7 @@ bool arch_dma_map_page_direct(struct device *dev, phys_addr_t addr)
 
 #define is_direct_handle(dev, h) ((h) >= (dev)->archdata.dma_offset)
 
-bool arch_dma_unmap_page_direct(struct device *dev, dma_addr_t dma_handle)
+bool arch_dma_unmap_phys_direct(struct device *dev, dma_addr_t dma_handle)
 {
 	if (likely(!dev->bus_dma_limit))
 		return false;
diff --git a/include/linux/dma-map-ops.h b/include/linux/dma-map-ops.h
index f48e5fb88bd5d..71f5b30254159 100644
--- a/include/linux/dma-map-ops.h
+++ b/include/linux/dma-map-ops.h
@@ -392,15 +392,15 @@ void *arch_dma_set_uncached(void *addr, size_t size);
 void arch_dma_clear_uncached(void *addr, size_t size);
 
 #ifdef CONFIG_ARCH_HAS_DMA_MAP_DIRECT
-bool arch_dma_map_page_direct(struct device *dev, phys_addr_t addr);
-bool arch_dma_unmap_page_direct(struct device *dev, dma_addr_t dma_handle);
+bool arch_dma_map_phys_direct(struct device *dev, phys_addr_t addr);
+bool arch_dma_unmap_phys_direct(struct device *dev, dma_addr_t dma_handle);
 bool arch_dma_map_sg_direct(struct device *dev, struct scatterlist *sg,
 		int nents);
 bool arch_dma_unmap_sg_direct(struct device *dev, struct scatterlist *sg,
 		int nents);
 #else
-#define arch_dma_map_page_direct(d, a)		(false)
-#define arch_dma_unmap_page_direct(d, a)	(false)
+#define arch_dma_map_phys_direct(d, a)		(false)
+#define arch_dma_unmap_phys_direct(d, a)	(false)
 #define arch_dma_map_sg_direct(d, s, n)		(false)
 #define arch_dma_unmap_sg_direct(d, s, n)	(false)
 #endif
diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 24c359d9c8799..fa75e30700730 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -453,7 +453,7 @@ void dma_direct_unmap_sg(struct device *dev, struct scatterlist *sgl,
 		if (sg_dma_is_bus_address(sg))
 			sg_dma_unmark_bus_address(sg);
 		else
-			dma_direct_unmap_page(dev, sg->dma_address,
+			dma_direct_unmap_phys(dev, sg->dma_address,
 					      sg_dma_len(sg), dir, attrs);
 	}
 }
@@ -476,8 +476,8 @@ int dma_direct_map_sg(struct device *dev, struct scatterlist *sgl, int nents,
 			 */
 			break;
 		case PCI_P2PDMA_MAP_NONE:
-			sg->dma_address = dma_direct_map_page(dev, sg_page(sg),
-					sg->offset, sg->length, dir, attrs);
+			sg->dma_address = dma_direct_map_phys(dev, sg_phys(sg),
+					sg->length, dir, attrs);
 			if (sg->dma_address == DMA_MAPPING_ERROR) {
 				ret = -EIO;
 				goto out_unmap;
diff --git a/kernel/dma/direct.h b/kernel/dma/direct.h
index d2c0b7e632fc0..2b442efc9b5a7 100644
--- a/kernel/dma/direct.h
+++ b/kernel/dma/direct.h
@@ -80,42 +80,54 @@ static inline void dma_direct_sync_single_for_cpu(struct device *dev,
 		arch_dma_mark_clean(paddr, size);
 }
 
-static inline dma_addr_t dma_direct_map_page(struct device *dev,
-		struct page *page, unsigned long offset, size_t size,
-		enum dma_data_direction dir, unsigned long attrs)
+static inline dma_addr_t dma_direct_map_phys(struct device *dev,
+		phys_addr_t phys, size_t size, enum dma_data_direction dir,
+		unsigned long attrs)
 {
-	phys_addr_t phys = page_to_phys(page) + offset;
-	dma_addr_t dma_addr = phys_to_dma(dev, phys);
+	bool is_mmio = attrs & DMA_ATTR_MMIO;
+	dma_addr_t dma_addr;
+	bool capable;
+
+	dma_addr = (is_mmio) ? phys : phys_to_dma(dev, phys);
+	capable = dma_capable(dev, dma_addr, size, is_mmio);
+	if (is_mmio) {
+	       if (unlikely(!capable))
+		       goto err_overflow;
+	       return dma_addr;
+	}
 
-	if (is_swiotlb_force_bounce(dev)) {
-		if (is_pci_p2pdma_page(page))
-			return DMA_MAPPING_ERROR;
+	if (is_swiotlb_force_bounce(dev))
 		return swiotlb_map(dev, phys, size, dir, attrs);
-	}
 
-	if (unlikely(!dma_capable(dev, dma_addr, size, true)) ||
-	    dma_kmalloc_needs_bounce(dev, size, dir)) {
-		if (is_pci_p2pdma_page(page))
-			return DMA_MAPPING_ERROR;
+	if (unlikely(!capable) || dma_kmalloc_needs_bounce(dev, size, dir)) {
 		if (is_swiotlb_active(dev))
 			return swiotlb_map(dev, phys, size, dir, attrs);
 
-		dev_WARN_ONCE(dev, 1,
-			     "DMA addr %pad+%zu overflow (mask %llx, bus limit %llx).\n",
-			     &dma_addr, size, *dev->dma_mask, dev->bus_dma_limit);
-		return DMA_MAPPING_ERROR;
+		goto err_overflow;
 	}
 
 	if (!dev_is_dma_coherent(dev) && !(attrs & DMA_ATTR_SKIP_CPU_SYNC))
 		arch_sync_dma_for_device(phys, size, dir);
 	return dma_addr;
+
+err_overflow:
+	dev_WARN_ONCE(
+		dev, 1,
+		"DMA addr %pad+%zu overflow (mask %llx, bus limit %llx).\n",
+		&dma_addr, size, *dev->dma_mask, dev->bus_dma_limit);
+	return DMA_MAPPING_ERROR;
 }
 
-static inline void dma_direct_unmap_page(struct device *dev, dma_addr_t addr,
+static inline void dma_direct_unmap_phys(struct device *dev, dma_addr_t addr,
 		size_t size, enum dma_data_direction dir, unsigned long attrs)
 {
-	phys_addr_t phys = dma_to_phys(dev, addr);
+	phys_addr_t phys;
+
+	if (attrs & DMA_ATTR_MMIO)
+		/* nothing to do: uncached and no swiotlb */
+		return;
 
+	phys = dma_to_phys(dev, addr);
 	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC))
 		dma_direct_sync_single_for_cpu(dev, addr, size, dir);
 
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 58482536db9bb..80481a873340a 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -166,8 +166,8 @@ dma_addr_t dma_map_page_attrs(struct device *dev, struct page *page,
 		return DMA_MAPPING_ERROR;
 
 	if (dma_map_direct(dev, ops) ||
-	    arch_dma_map_page_direct(dev, phys + size))
-		addr = dma_direct_map_page(dev, page, offset, size, dir, attrs);
+	    arch_dma_map_phys_direct(dev, phys + size))
+		addr = dma_direct_map_phys(dev, phys, size, dir, attrs);
 	else if (use_dma_iommu(dev))
 		addr = iommu_dma_map_phys(dev, phys, size, dir, attrs);
 	else
@@ -187,8 +187,8 @@ void dma_unmap_page_attrs(struct device *dev, dma_addr_t addr, size_t size,
 
 	BUG_ON(!valid_dma_direction(dir));
 	if (dma_map_direct(dev, ops) ||
-	    arch_dma_unmap_page_direct(dev, addr + size))
-		dma_direct_unmap_page(dev, addr, size, dir, attrs);
+	    arch_dma_unmap_phys_direct(dev, addr + size))
+		dma_direct_unmap_phys(dev, addr, size, dir, attrs);
 	else if (use_dma_iommu(dev))
 		iommu_dma_unmap_phys(dev, addr, size, dir, attrs);
 	else
-- 
2.50.1


