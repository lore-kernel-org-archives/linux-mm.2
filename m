Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B895CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 13:28:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED25E8E0014; Tue,  9 Sep 2025 09:28:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA9E68E000F; Tue,  9 Sep 2025 09:28:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBFBA8E0014; Tue,  9 Sep 2025 09:28:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CBE1A8E000F
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:28:42 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 982B51A026A
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 13:28:42 +0000 (UTC)
X-FDA: 83869791684.14.E5FEEED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id CE569A0016
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 13:28:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H0K5skJh;
	spf=pass (imf15.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757424521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ox0T3nJrZzkkPKbqSqfbPUkq1ORzYA1qjjFfdvCJIM=;
	b=kCbMaJNT1GTXsDdRrlcHIuKWVigL1podFZSnXAIC9uiKPbz11wvQxiMMZwTk4IQca993OD
	jSkJdtQ58iLZ0NB273rjC1h8rVbfxRjF2DTr00LVKixB+lUscmspONVwwUVYV3PCB9FQEq
	iot/fQhm8TGw7lp9nOnxb7ocnoAOuyg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H0K5skJh;
	spf=pass (imf15.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757424521; a=rsa-sha256;
	cv=none;
	b=StI+OYB/Hp9BRR1qgoe2neD5kHLzDIxZLhvC/1AbU8yKye+SO9IzloKFF2BQjy4bGPwmIH
	YpQx982jGzrkTYCw0m2ILJ4nu0kFdMmKIGz4seWkfxcHkZLRQvg7L2d/BJUvp9n4yIsEQ5
	d7uUvrp6QpD2wYeNU0zSXbtlKWbrsjA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DABBA443D0;
	Tue,  9 Sep 2025 13:28:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AFE4C4CEFA;
	Tue,  9 Sep 2025 13:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757424519;
	bh=w8kS6Kv6jl4hijoz408buSvl4DjsRf9g5sD93Yq2Jnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H0K5skJh4/WF1ektaQtKz3ZvzjCQqgk/jPDZY831i1OmPzNKJt3zr0VMLZUn6Oalv
	 QZlGTWfPJFB7YeDbSMUjcTI8tj9oxelLdc6cTAEt8nQzs1r8TU1y2uFmuHgOFV+7c0
	 zEBCqYzjKQTExQMtJ79OmQvvY67JyWUakHS4U0Q2xmIwAQsk/PUF0NrIhd8JCJsskZ
	 VNR1XrQWFu6/SZ5+39SqVX3r9GV1SO+KxS4E9QiFH8hpgNXXzYyQoNPdKGBL9h1dD1
	 QxJaEGXOUKJTU4yZUiZoacSiZ+5WLQ3HXsD6ySMQJWATB9JTvrZUM1yN6Y9PbEE38Q
	 a/pRBshQSFabQ==
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
	David Hildenbrand <david@redhat.com>,
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
Subject: [PATCH v6 07/16] dma-mapping: convert dma_direct_*map_page to be phys_addr_t based
Date: Tue,  9 Sep 2025 16:27:35 +0300
Message-ID: <bb15a22f76dc2e26683333ff54e789606cfbfcf0.1757423202.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1757423202.git.leonro@nvidia.com>
References: <cover.1757423202.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CE569A0016
X-Stat-Signature: djjnnehos583gdcfgfm599hwujukgont
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757424520-430705
X-HE-Meta: U2FsdGVkX18sbB/WFRwxtU/cvzPxFULAWaEV0bU/y/S0pRpsAqdNSYVClBV114pgqbb7J8IFq0RNqDfXnPFCFhUAqFU71mR4ZwY3e6WZhJ7Fb9RXa/eRnrUyx7rpb0RpgUsFeh4rpXzg0lAMGpxqAV1TgIJ8qBzSpCmC3uqcCOGg139wjyDAA8UKaa04Tfs6lAXnSyOxF1DVmrTq+/eNk1I37wVTxHuEAxwgjtRelrCxjxre/gzstvqVrXo+/RsG3dyqPy5ZXDr32kxhJb6RGzNvH3k53m2QP9yQHLMj7iBmkzZEKPXEuGZA37c8L5SZabNB5vVKEZdyn5wG1XvJOzbflmzGsmgh/Cj3O8PWszZ+h2m8RdWgDnlvRsNEt3TuPKd8djTlAwzyzW7lr8JxTlPayJwJichddtffoodLEcwT6DmYkz/9hykBiw7AJcyIY8GL8jOWBHXb38B92VkGBPDC90acb2QKATa+mUSBTzGDeS8F8lZe5sFG+Z/ZIanbI27N4lVtCMGxTbC1zIc+/R5mgCFbVhXWRh2Gg8HZXfOnh+jHQdk/rXRG+tnuElCv4phcFK3UZIcH+gCS7DQ8SdnqTkaz42mVJeGs0QJrMNyXLbC8T3WYk6WGFC0FvPygzpFDXZRPuEOAGNBmUNLhpbv7UfW3TB/MeTSa15UmuXDMxDGI6fzpRf6gu44EAbumpLFi2nSYRsYpkVO5MdotA1S1Ud3UvxYkU/unFrEdzVlYf4Nc+XUCHQKjeRB3VJFNBSq24vEnDdgOCVAYJP5RojJMczbuNcmHgYGceGVly9GhP1ZxRBWXk5sJiU1uOzosGgHaHWjr9/wy66afVIkPK15U5OsJievStMuipT3dOqJiHGLB0lacmjnb8qPxW+/yY0N2htbXNYHNuwGxZ6wOY8uiqfY0nfMA84pQUYfIL1snMksd/CPv5ZxtutZlNwqQTXvy77nsMIJ/bBmOcSb
 55WQLjhN
 dNa2Vdf9mKEm9CHNXky95S2iSefUxQ63ug59qTWBeM4FjplHKXTclWTnZpIWpWVno7Y3frIMa+pf2WDiwR1PT7vg+q/0XCgG7FYLcBtsTRbydfZ0NgS47P/X0Kqnaz8TE6TnW5GqyrtpmvmZhSv1VN88bypoFn75KQAY4pZrG4cCc+9H2FXhPenScGkkOtzclTjWWR6P0wIMqpgOfRq++ki6TJ6/uyAdPmpAYI5AVa4c3bIO+T8XBKAFyuUgR2/ynZT+vekvsrtmMT0uf89FnDDF6M6JmmtKDnHXSlBrhgj2l7/YDCoDTh5S3cw==
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

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 arch/powerpc/kernel/dma-iommu.c |  4 +--
 include/linux/dma-map-ops.h     |  8 ++---
 kernel/dma/direct.c             |  6 ++--
 kernel/dma/direct.h             | 57 +++++++++++++++++++++------------
 kernel/dma/mapping.c            |  8 ++---
 5 files changed, 49 insertions(+), 34 deletions(-)

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
index d2c0b7e632fc0..da2fadf45bcd6 100644
--- a/kernel/dma/direct.h
+++ b/kernel/dma/direct.h
@@ -80,42 +80,57 @@ static inline void dma_direct_sync_single_for_cpu(struct device *dev,
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
+	dma_addr_t dma_addr;
 
 	if (is_swiotlb_force_bounce(dev)) {
-		if (is_pci_p2pdma_page(page))
-			return DMA_MAPPING_ERROR;
+		if (attrs & DMA_ATTR_MMIO)
+			goto err_overflow;
+
 		return swiotlb_map(dev, phys, size, dir, attrs);
 	}
 
-	if (unlikely(!dma_capable(dev, dma_addr, size, true)) ||
-	    dma_kmalloc_needs_bounce(dev, size, dir)) {
-		if (is_pci_p2pdma_page(page))
-			return DMA_MAPPING_ERROR;
-		if (is_swiotlb_active(dev))
-			return swiotlb_map(dev, phys, size, dir, attrs);
-
-		dev_WARN_ONCE(dev, 1,
-			     "DMA addr %pad+%zu overflow (mask %llx, bus limit %llx).\n",
-			     &dma_addr, size, *dev->dma_mask, dev->bus_dma_limit);
-		return DMA_MAPPING_ERROR;
+	if (attrs & DMA_ATTR_MMIO) {
+		dma_addr = phys;
+		if (unlikely(!dma_capable(dev, dma_addr, size, false)))
+			goto err_overflow;
+	} else {
+		dma_addr = phys_to_dma(dev, phys);
+		if (unlikely(!dma_capable(dev, dma_addr, size, true)) ||
+		    dma_kmalloc_needs_bounce(dev, size, dir)) {
+			if (is_swiotlb_active(dev))
+				return swiotlb_map(dev, phys, size, dir, attrs);
+
+			goto err_overflow;
+		}
 	}
 
-	if (!dev_is_dma_coherent(dev) && !(attrs & DMA_ATTR_SKIP_CPU_SYNC))
+	if (!dev_is_dma_coherent(dev) &&
+	    !(attrs & (DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_MMIO)))
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
index 90ad728205b93..3ac7d15e095f9 100644
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
2.51.0


