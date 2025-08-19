Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8631DCA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 17:38:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B1F28E0036; Tue, 19 Aug 2025 13:38:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 862858E0005; Tue, 19 Aug 2025 13:38:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 702C68E0036; Tue, 19 Aug 2025 13:38:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 587F08E0005
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:38:14 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3ABA51A0155
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:38:13 +0000 (UTC)
X-FDA: 83794215666.16.5CAD37B
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf17.hostedemail.com (Postfix) with ESMTP id 793954000E
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:38:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MouP3Mq9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755625091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kCJU29SWd1OR3k6ZUoBci43zBS+gLO8fdMAUUcFIoOc=;
	b=c9xcsse33CIga2ctxRhkbCPJ1A23M5feNyXngukwEBePnLZvOL+MoCZXjhXj2OWTJXaBTI
	dgZRifMvLDckGEu9szikRjlEdHOW/Mhs0QKit4Rbgs4rHMdJIimfamEJWSETyAPOHRPLYp
	Kb0l+ZSFqLTjWrQjNvAnsGJr7iTQEos=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MouP3Mq9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755625091; a=rsa-sha256;
	cv=none;
	b=5KUo6kEHN6X/YKombQk8rBulJS15DHw+utdUOAcXcDE9sPTb5y8FXYd0KAzXvkSsmaU0YJ
	ZsqLx/BkkmiSGWfRd71Ljrgvz4UqgyQu78Ce/fSZV1I2wF0G637imWsAeFtKGZ8w5sV12W
	MaI/DTEAaV4l+8trpIVrnJifckKdlMA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 890FC5C64A4;
	Tue, 19 Aug 2025 17:38:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E64ECC116D0;
	Tue, 19 Aug 2025 17:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755625079;
	bh=0MhcGdVdXvKtqKaQ8KaQcBZJnClPr0/vCjOFn/qCf0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MouP3Mq9M8VNSNcbEF4xEUjffk0Xzg4jGWqmsxG9iYcCqntVe/Pra1WM/OxT1i1Od
	 Aqi9aVBPbjVG96dIo5N5sOwNqlHm0xNRYmPytNGAePyWcADWp6NFOTVh93u4yekuvo
	 BDRr7Gj4XsLIJlrnY9jCLDXfSVxrgkDw+nSJXtT6ZqXHvw7L2bv3qnt948dTovXsa/
	 uxIFxcEgqXl4qbxMLy+2MwPZUpjLU1sqX6ZOTX60mm9/q3qMX2In4Sn81lZs6DgRgW
	 rcsL+GG13KPKOW+YPm37p0kWoUppDQCXi1rzzvUpGo7tZHKA9IUUOQMyoCKJOrAcvx
	 i6WFhL6htpvlA==
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
Subject: [PATCH v4 05/16] iommu/dma: rename iommu_dma_*map_page to iommu_dma_*map_phys
Date: Tue, 19 Aug 2025 20:36:49 +0300
Message-ID: <66e7cc6854e4e40278b598b38e0c4d49d7fcec91.1755624249.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755624249.git.leon@kernel.org>
References: <cover.1755624249.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 793954000E
X-Stat-Signature: 4wk3jbhzu59ftggu3gn6wcp8qh3iru7b
X-Rspam-User: 
X-HE-Tag: 1755625091-675600
X-HE-Meta: U2FsdGVkX1/AFXpUxA5anwWCdUstsELJiWbSVaYRfE5/FpKcugLbAU9yKYovDKKXbhS6TH35GhmoHT1VkEroaLWCkmrCykl3KTUsGK3U0Hhp2OpCqrkf8t/hakFAG7mQZ0qFAFrDyDLODlHHfpK5P9F/BzlRdj5EqsQehgfYE/eKqnej9Tqfv7SQyLVQl9A4N70fK7+rFBPDXwotxavrD1xtRASG3g1DXT5TwXTs4/AQIlMED3MESkNY0u/T/CKir+veMu6qIrgKRHcCXpZODqD9dV/+BVPLogImA6oxjwe0GpKlI0bA6UuoFKGgHthuZFCsfV9I+COkcCSnJAvMKffRFxnEmOADS4q1ZlizK4r+TscHn1Doe5sozfZkPCLadYr6eLjzYLO8UnkSYe/fOjuD+r8IEDZhUyWhH4ti4s0ZiQQXXBS9rcy1lD4SLf+LROMiHEJli2Jqd2K2NQUZgQ5QduZ0HuaipJzNpG3938Wvq1jlVcWHbt/HfIA4ygZ/x6xu6kB7uUdZrmAHK/97a/ujMkNgBCbQd/DhGe4IR+3O/RbB1TT74ONaFO5BGrWpCVbeVuKBrxnv6ppmzPk1PIrB8I3uyAeCZDPsRxrunDbETBncmkzMdzA2T0FFtrwfAF41GJPvcGY0wjbinDsaIgGvmayh8Qdu7anQG8hh1XaELLl1YUlRgMbigLszRy2eY+pgdSU4+NjpCshEuFHp2DlTS6g8WEL/wSyjSjXFvHWwpmG1Pa1jsDDFUY3/MVK9G58SjX8N9sNW4/0qIowTjGMirRFanUrrpmITcxlzy6J7G9f+PzHhiZlYyttou8QFJZkdHKIC6xIYHp016+DYIkiAZSrsSX0VrzlXotwpRIeB5oeiyBR0yJJg9dDDgmgfhU1rM0bF9oi22T11hqgufMjhUTfERYnf34e4RCbOUsDs08qOXKwrV0k+WVpw3AQQu5zMmrXMtHZYdNsN0vq
 RPpAkcF/
 GAh2Fv4tCVHi4UhFNsS21LvjBl+JeZTso3SECShggQsLkZ8elP33AiedhWCzxluLV/YSbNmFagpdlH447Wnbtzz7Gmg0+Mf9mZoMZNHfSOE/UUmqa3TzPKzmdwxXqmYI5nWpfYX/ZqovkGWQpiZOEfdlDtowHmPHLvuoSJP9DTVBECnl35u3e4nvynJT5sDiE17dYr7W5HIHOgESCFBoZI7ehDeJPExh84vIc0ivseu2+I4oBT+mcN8rbS0XlktZ4aBSY7KqLQABpkAW8749UBtXTnaUYLGC7PUhriVx8Ty/B1saO0q13P1g/GscNCiMhkf0H1+pc8Xn+gNoyxmYBH+86g5TrjfeGaAcc
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
index e1185ba73e23..aea119f32f96 100644
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
index 508beaa44c39..485bdffed988 100644
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
index fe1f0da6dc50..58482536db9b 100644
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
index 9afd569eadb9..6f9d604d9d40 100644
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


