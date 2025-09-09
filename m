Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F9DCCA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 13:28:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9F338E0017; Tue,  9 Sep 2025 09:28:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4F1F8E000F; Tue,  9 Sep 2025 09:28:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3D7F8E0017; Tue,  9 Sep 2025 09:28:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 91FFF8E000F
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:28:51 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 57F03140467
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 13:28:51 +0000 (UTC)
X-FDA: 83869792062.12.DD61717
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8761440002
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 13:28:49 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HCZ7zSxC;
	spf=pass (imf07.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757424529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=04QOoaAW1ThS4hmDN2nuVNJwVnp4KhYNWBVzVcpeXe4=;
	b=N1H0w+qJEEe/Pm/cCC0Zd38ASSApiH7/0Tx9H5LED+a/7New+vp9Z+cKWQjDZXdRSAt0tE
	BGW50AneylA1fXzSaEXSDmSiK+fH4IhiZE31HyqRxWuz8tB7NuiypPdC2mKizzFPUEBc0c
	20NjZRPJNnqv9e4edWwsstfCltsNDP8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HCZ7zSxC;
	spf=pass (imf07.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757424529; a=rsa-sha256;
	cv=none;
	b=zesg8j5GdMQ8lnR5qJlqmfSawGzkKlRNWqYiM0ehCcpflp2fxWxhZy5ijan98FvfaZwdep
	m819E6PFZjcX6uL0Pc1bhJ0RGNW3k+CwXc3xtaZXy1PmlcyrndlJ7/94sYYL6ku98FgZrp
	FFZrA6RV1wLh8UfeSiAElNWNNHvbKag=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7C4C74341A;
	Tue,  9 Sep 2025 13:28:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7058C4CEF4;
	Tue,  9 Sep 2025 13:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757424528;
	bh=4ePATvT4TR5ecFcfHcb8V41SufKtoqnQ4LoEjPMODUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HCZ7zSxCHQnq8uO02FHrTDo9Lqt2UvrUd/Tgm4oPlzwgbEeOTJx1Uy9r7p4JgvoxP
	 Ke745OYSHLnFUKGgFXhYbUeDG1Ihk0CUdGU2Mv0dG2bIzGkcdFea1d18yN1daQt2Cq
	 iE8mEQbhJv0nnhsjj7yBNFvA+tRmvDdUyCjHBsp2bhV8M2K26dI0FkoL3OriItB4Ey
	 j4HFlYSG1vzaC5yFi1GHGFn91SDzxPg6zuJo/1d/MJ0U7jdkP/E+fkInf5nUZVzXVB
	 NQAZUmfuLAG2fmHd3zdrILMZZNfdyg1Y7zH1yWXMPkYCce4fYkR3GLvIi+SX429ywB
	 1GtYpw9a64y9w==
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
Subject: [PATCH v6 05/16] iommu/dma: rename iommu_dma_*map_page to iommu_dma_*map_phys
Date: Tue,  9 Sep 2025 16:27:33 +0300
Message-ID: <ed172f95f8f57782beae04f782813366894e98df.1757423202.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1757423202.git.leonro@nvidia.com>
References: <cover.1757423202.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: a9g39qtpwcuzqz156ddzaebxsyo1ptej
X-Rspam-User: 
X-Rspamd-Queue-Id: 8761440002
X-Rspamd-Server: rspam04
X-HE-Tag: 1757424529-395449
X-HE-Meta: U2FsdGVkX1+dwFA6Wqohy9L3RY4Zv9LOPnPgQGd8G+1yxI5R1QZfaL5WXT1TKOAvaiTTbk5AiwlJsem8o78uUBpBdOtXySRBpuRA0nG+xJlUkjVYZn/Zu1onTTbLe+aa7MzIPws4IkibzXtqdnXdOw33GQyV35as1x9toZzYkUc3LUXwTnsm6GW2NofURMwRu+boQ4yzYlF17DMaCOouDzgAz68JQAjigmtENckJhMCwTnFZ2zC2otSrvkaQ5rgAHuUWolH1vFpK8J7ErWHfwGI1fWzRO2bvLsCS7gEoi4rNSTIc5aCTGCos7s7d4F9BQiXxEXXx6g/cIv+4vGhIMmvabO4ji9NQCb8jk1GsogP9085EZoGpI2SRvtFj7KK1itQYSieI66DhAqClvL2fA34cPqftAz8gpGLWH5TgjVyPZDtU5arAiltvkVCY96+X5O2IoVw+jc1jPqURZqJGIgoD/1lUpZk/3U95egm55NjrCTryJt7EPTJ2wXomb1aAXCod/0WByQNwacr4QPaL29+QlAwfB/GA/6dU+UGsS2CP5V8UTexkd0qOQ/9T5a4WaPOrpZrEDwC3r/b5EENC7l3gyUTE5nPBtYGTLAIVbhiGYBqKb/TfQ9dLd9pfpeHbuMh6E5/dHWiIjXNdDGgbzAAlxSMAH66OLlt4xQiEuklwpXUa2UbmVUGqOHXMI/ZudL9M3d1ZrItSsVMoUOH9nnchKZOl6Z07WN1imjWZMRTn7IqRYvdZ+ZphSnObAHvbHfk9/3sUzH/Jm40w80qpZww2zX2/3jrysxzt+2bjn0FJEjYWkw4W44wB5XhjJ/6AMF9IytfKRGf5JwqTmX2yqNK4MWroLgXereSQF8DHw60Ti9blgpBaWfl9G47NLmcHxDRLhyNXLNcaATqLqwASnNFM6fWLqB+M6ExZjfq0//Nj8L2K02pJ3nN/P3nRGQAazvngpSgLLMa2aH+y46r
 BxIB76ja
 JkJSQvsXLHRZpDI3plXX9siqUtG8V6JfVYTNqVxOaLwMfpRdyD+dRRiFZzAfUV3YILSG3Ldvf4mP1fOoxokE2jb+WID3MHQc+KU16P2MIqtpjlYfHTsiGiRTxuEMPJTENv75H7rxqF6ognr22HFUNRZ/SJj8D+eh1bF8ydRukvTfG5ib3TR3NlT6QWev88Lkf9Q5OtcnJCMh+itH3lmHykZoC+BiNTjY+jSA2okXKAeIyw2KHZvWnpav1701xIj4wRY97bajQ9QwdBXvs3KewadTgn58I3pWcbUCb3BEcRDUvC0Wv0uzqB7SwLgb8p3lp8oJ+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

Rename the IOMMU DMA mapping functions to better reflect their actual
calling convention. The functions iommu_dma_map_page() and
iommu_dma_unmap_page() are renamed to iommu_dma_map_phys() and
iommu_dma_unmap_phys() respectively, as they already operate on physical
addresses rather than page structures.

The calling convention changes from accepting (struct page *page,
unsigned long offset) to (phys_addr_t phys), which eliminates the need
for page-to-physical address conversion within the functions. This
renaming prepares for the broader DMA API conversion from page-based
to physical address-based mapping throughout the kernel.

All callers are updated to pass physical addresses directly, including
dma_map_page_attrs(), scatterlist mapping functions, and DMA page
allocation helpers. The change simplifies the code by removing the
page_to_phys() + offset calculation that was previously done inside
the IOMMU functions.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/iommu/dma-iommu.c | 14 ++++++--------
 include/linux/iommu-dma.h |  7 +++----
 kernel/dma/mapping.c      |  4 ++--
 kernel/dma/ops_helpers.c  |  6 +++---
 4 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index e1185ba73e23a..aea119f32f965 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1195,11 +1195,9 @@ static inline size_t iova_unaligned(struct iova_domain *iovad, phys_addr_t phys,
 	return iova_offset(iovad, phys | size);
 }
 
-dma_addr_t iommu_dma_map_page(struct device *dev, struct page *page,
-	      unsigned long offset, size_t size, enum dma_data_direction dir,
-	      unsigned long attrs)
+dma_addr_t iommu_dma_map_phys(struct device *dev, phys_addr_t phys, size_t size,
+		enum dma_data_direction dir, unsigned long attrs)
 {
-	phys_addr_t phys = page_to_phys(page) + offset;
 	bool coherent = dev_is_dma_coherent(dev);
 	int prot = dma_info_to_prot(dir, coherent, attrs);
 	struct iommu_domain *domain = iommu_get_dma_domain(dev);
@@ -1227,7 +1225,7 @@ dma_addr_t iommu_dma_map_page(struct device *dev, struct page *page,
 	return iova;
 }
 
-void iommu_dma_unmap_page(struct device *dev, dma_addr_t dma_handle,
+void iommu_dma_unmap_phys(struct device *dev, dma_addr_t dma_handle,
 		size_t size, enum dma_data_direction dir, unsigned long attrs)
 {
 	struct iommu_domain *domain = iommu_get_dma_domain(dev);
@@ -1346,7 +1344,7 @@ static void iommu_dma_unmap_sg_swiotlb(struct device *dev, struct scatterlist *s
 	int i;
 
 	for_each_sg(sg, s, nents, i)
-		iommu_dma_unmap_page(dev, sg_dma_address(s),
+		iommu_dma_unmap_phys(dev, sg_dma_address(s),
 				sg_dma_len(s), dir, attrs);
 }
 
@@ -1359,8 +1357,8 @@ static int iommu_dma_map_sg_swiotlb(struct device *dev, struct scatterlist *sg,
 	sg_dma_mark_swiotlb(sg);
 
 	for_each_sg(sg, s, nents, i) {
-		sg_dma_address(s) = iommu_dma_map_page(dev, sg_page(s),
-				s->offset, s->length, dir, attrs);
+		sg_dma_address(s) = iommu_dma_map_phys(dev, sg_phys(s),
+				s->length, dir, attrs);
 		if (sg_dma_address(s) == DMA_MAPPING_ERROR)
 			goto out_unmap;
 		sg_dma_len(s) = s->length;
diff --git a/include/linux/iommu-dma.h b/include/linux/iommu-dma.h
index 508beaa44c39e..485bdffed9888 100644
--- a/include/linux/iommu-dma.h
+++ b/include/linux/iommu-dma.h
@@ -21,10 +21,9 @@ static inline bool use_dma_iommu(struct device *dev)
 }
 #endif /* CONFIG_IOMMU_DMA */
 
-dma_addr_t iommu_dma_map_page(struct device *dev, struct page *page,
-		unsigned long offset, size_t size, enum dma_data_direction dir,
-		unsigned long attrs);
-void iommu_dma_unmap_page(struct device *dev, dma_addr_t dma_handle,
+dma_addr_t iommu_dma_map_phys(struct device *dev, phys_addr_t phys, size_t size,
+		enum dma_data_direction dir, unsigned long attrs);
+void iommu_dma_unmap_phys(struct device *dev, dma_addr_t dma_handle,
 		size_t size, enum dma_data_direction dir, unsigned long attrs);
 int iommu_dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 		enum dma_data_direction dir, unsigned long attrs);
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index bd3bb6d59d722..90ad728205b93 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -169,7 +169,7 @@ dma_addr_t dma_map_page_attrs(struct device *dev, struct page *page,
 	    arch_dma_map_page_direct(dev, phys + size))
 		addr = dma_direct_map_page(dev, page, offset, size, dir, attrs);
 	else if (use_dma_iommu(dev))
-		addr = iommu_dma_map_page(dev, page, offset, size, dir, attrs);
+		addr = iommu_dma_map_phys(dev, phys, size, dir, attrs);
 	else
 		addr = ops->map_page(dev, page, offset, size, dir, attrs);
 	kmsan_handle_dma(page, offset, size, dir);
@@ -190,7 +190,7 @@ void dma_unmap_page_attrs(struct device *dev, dma_addr_t addr, size_t size,
 	    arch_dma_unmap_page_direct(dev, addr + size))
 		dma_direct_unmap_page(dev, addr, size, dir, attrs);
 	else if (use_dma_iommu(dev))
-		iommu_dma_unmap_page(dev, addr, size, dir, attrs);
+		iommu_dma_unmap_phys(dev, addr, size, dir, attrs);
 	else
 		ops->unmap_page(dev, addr, size, dir, attrs);
 	trace_dma_unmap_phys(dev, addr, size, dir, attrs);
diff --git a/kernel/dma/ops_helpers.c b/kernel/dma/ops_helpers.c
index 9afd569eadb96..6f9d604d9d406 100644
--- a/kernel/dma/ops_helpers.c
+++ b/kernel/dma/ops_helpers.c
@@ -72,8 +72,8 @@ struct page *dma_common_alloc_pages(struct device *dev, size_t size,
 		return NULL;
 
 	if (use_dma_iommu(dev))
-		*dma_handle = iommu_dma_map_page(dev, page, 0, size, dir,
-						 DMA_ATTR_SKIP_CPU_SYNC);
+		*dma_handle = iommu_dma_map_phys(dev, page_to_phys(page), size,
+						 dir, DMA_ATTR_SKIP_CPU_SYNC);
 	else
 		*dma_handle = ops->map_page(dev, page, 0, size, dir,
 					    DMA_ATTR_SKIP_CPU_SYNC);
@@ -92,7 +92,7 @@ void dma_common_free_pages(struct device *dev, size_t size, struct page *page,
 	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	if (use_dma_iommu(dev))
-		iommu_dma_unmap_page(dev, dma_handle, size, dir,
+		iommu_dma_unmap_phys(dev, dma_handle, size, dir,
 				     DMA_ATTR_SKIP_CPU_SYNC);
 	else if (ops->unmap_page)
 		ops->unmap_page(dev, dma_handle, size, dir,
-- 
2.51.0


