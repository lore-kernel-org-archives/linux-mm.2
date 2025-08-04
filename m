Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC572C87FD1
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 12:43:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D93C6B00AD; Mon,  4 Aug 2025 08:43:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 889B66B00AE; Mon,  4 Aug 2025 08:43:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 779216B00AF; Mon,  4 Aug 2025 08:43:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 658536B00AD
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:43:52 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1CAC458057
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:43:52 +0000 (UTC)
X-FDA: 83739041904.03.24FC933
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7F76E1A0017
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:43:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Aa0MuxNB;
	spf=pass (imf19.hostedemail.com: domain of leon@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754311430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aUGRZ8OiFKTYz3bE7TMZcKc2yGhFtaAdl3sZst6yCGU=;
	b=OTEsPu3UmFoYmFW7Uss1IAu5C5Ea9tteVAIqnJmH5ggv4TQMT2QB8uWjxfC/x1hm6ABAZ6
	rgapwSFdRFJr15bHQZ3dab8ILP7qz8y+ohm1nheay56rgzvseuFfYfuB+6KDYqnn8GVGCJ
	IHWkP4ulk1+V8Q/PojmM0ozi+/qBHUE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754311430; a=rsa-sha256;
	cv=none;
	b=L6YGodR4Wej99FBZzli072WNdPJeOHbvCwCIAhrwEIEXqI8TarNTflI26RS1XGtYVXQWpP
	+s6w4ywPM5aY97kM3rlY2GoJEHHe1d0FKFMyEXh2JOJHwI9GXQ9pZsCqueux4/rJOxix8T
	uDjR947EvU6L43HXf5H0vaAtpdfv/8w=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Aa0MuxNB;
	spf=pass (imf19.hostedemail.com: domain of leon@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id DB03EA55869;
	Mon,  4 Aug 2025 12:43:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77632C4CEF8;
	Mon,  4 Aug 2025 12:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754311429;
	bh=fV/HgrK+DFqDLLsHNIEfHPO7ePKynetLmNvxMPUxMvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Aa0MuxNBbcIy902+5pajDqLKZSF1w44g4nO478lMbvVmelIgJo9/XEVtOJdLolm32
	 q7aXDo/HichuVD7Pb+Aa/K/QU+jft9TqQt6qSowqpu9o7oVK33kF7h87bAMiCEuh7J
	 GTG4UxRiY9ThlFKl1TYW6avleePvBUl4DfH/vEF1Kr9msK2hTjqPSEBQo2CPPDN9XL
	 cmvQ+Y6RsY/GLJU2K2UCJxW/9snuDBWIgUSq51tLUxcQc4tM8wxjYyQbIJau+bNm5z
	 oI+I/YZiPTOQKrn1/OVrXurN2c10xr6JyOZLXzeR/bxU8ANAxJ8GIadB+SKB840EpC
	 wLychapzdplKg==
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
Subject: [PATCH v1 05/16] iommu/dma: rename iommu_dma_*map_page to iommu_dma_*map_phys
Date: Mon,  4 Aug 2025 15:42:39 +0300
Message-ID: <9186ccefda5ea97b56ec006900127650f9e324b5.1754292567.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1754292567.git.leon@kernel.org>
References: <cover.1754292567.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7F76E1A0017
X-Stat-Signature: 6r8kb8rpzxdyg8qicfoqq1mt373u8qrb
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754311430-772235
X-HE-Meta: U2FsdGVkX1/vzv61qW9Fp9WEGvETplDolobUt5sHmjVBzOXc8fYcrUL3aDZBhYrgkD2dwLW5OO05OZXnWBNLSowhlhd0vqPvPRUOzQ+ZpqdpwpBi6BjzMraTXbYc/FU2/0SmGBiP8SBNp5nQfrSfmuBXollV62de+2mVkFCsj4EgLDtbsCHqr5k1gR4IGkazu5uDcZKYjpCICnkffSwgtSRdogFchQ+81R3CRZThdGoVG/UWnuXP09HBo7X1kvkAvdylDieb4L5lHT9+jfdkrfP/Q15S9rV+Pn+MXg6QrwVeKWlkhuvFqSuHOzMLYBIUcT8Ha+XJXm8CDpuF5I8+9RDPvIfe3zxCrkEN/sO4jQFIxyDD32zkz35lmDf6APIzB299pjNJHF34twL7KI8n/GS3rNUGz3fLZpZ5TVWZYA434SmZ4S7y+2hWSIbqhHguvHQoEoR/b5p8l1Fv1O215v4A5YBaGHG1wdKoOlJeSsxpLPxBDVQJn70/0XciXKLSh2t0Vx4altOyCTXMFvUY1cRiCGu/b6jOpoF77MRtTwsqsrtNiDkpbeDi16siKLciLO9cDMYB66i5sRr/3L+xqwgaVVQc++Qh4k4YFWX+6ievjB2y3ydchvame0rIztWt4O+IcDm6vy0JnKcnoloKPzsCexqoNWOlYQooHVXcoqXaBSIbn874xa2IfS4GRnxkdyZiTpw06Vq9z45mmRttqDWUuc15RrXzokxyhlm3cU+igyQrEn8U4gTCjI/Cjgc2Tvx07bFhTdmtGNFVvBUKBAUWwOBijDTuj09CfLz1fADw1/oUaFnpJOyR4TtAa0kf1byHOKUUNv/64/sTp7k7ey/YUUEUaXGw91TvBPC+9rO6DoXkQbSrvwRYQBYn/qNBVYTdu6bkyFs0sb7+kplda0Yx4X6yFCrzS2+LZEaPCCGvWArvHqBFDcOMVfXwXvEE7Ex8S1d0hOl9ZbO4N54
 bIP6a9Lw
 fDGuD1hyIMq4wuWYD6/2d++eaYa+VUSM4CDVroAoX+H1N7Ykj2F6+Ce12rCpUDFB6xRtay5d2MZar8XXZQDGenh+0tp8ZTCKRd20kSzQMy46snDp2ILl9faQ2kwWxzTviKfpivofFeOc1KgAFJYD3z1jKmDL0rjOCjEbxwyVNgPdeX6kyOYaSjoTf8hPzRQc+DSpiJz5Rydz7IJjQcQbQd6CWidcWv9pQWhGOl9zNwklAwBjwmynGFHFJ/x7nKAV+DIvLXOOEiuyxJTYBbTUVBXkgp5I0S14a4JNACkAFPDwONyiXgiqti9SsMhGYaicDKfIFn/nnZ/tzrdSNObS7Y2as2SkpPxVFmt5/
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

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/iommu/dma-iommu.c | 14 ++++++--------
 include/linux/iommu-dma.h |  7 +++----
 kernel/dma/mapping.c      |  4 ++--
 kernel/dma/ops_helpers.c  |  6 +++---
 4 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 399838c17b705..11c5d5f8c0981 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1190,11 +1190,9 @@ static inline size_t iova_unaligned(struct iova_domain *iovad, phys_addr_t phys,
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
@@ -1222,7 +1220,7 @@ dma_addr_t iommu_dma_map_page(struct device *dev, struct page *page,
 	return iova;
 }
 
-void iommu_dma_unmap_page(struct device *dev, dma_addr_t dma_handle,
+void iommu_dma_unmap_phys(struct device *dev, dma_addr_t dma_handle,
 		size_t size, enum dma_data_direction dir, unsigned long attrs)
 {
 	struct iommu_domain *domain = iommu_get_dma_domain(dev);
@@ -1341,7 +1339,7 @@ static void iommu_dma_unmap_sg_swiotlb(struct device *dev, struct scatterlist *s
 	int i;
 
 	for_each_sg(sg, s, nents, i)
-		iommu_dma_unmap_page(dev, sg_dma_address(s),
+		iommu_dma_unmap_phys(dev, sg_dma_address(s),
 				sg_dma_len(s), dir, attrs);
 }
 
@@ -1354,8 +1352,8 @@ static int iommu_dma_map_sg_swiotlb(struct device *dev, struct scatterlist *sg,
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
index fe1f0da6dc507..58482536db9bb 100644
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
2.50.1


