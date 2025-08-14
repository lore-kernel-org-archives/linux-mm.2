Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78761CA0EE8
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 17:54:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13BF99001BD; Thu, 14 Aug 2025 13:54:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EDB9900172; Thu, 14 Aug 2025 13:54:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF6E19001BD; Thu, 14 Aug 2025 13:54:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DA240900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:54:34 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 636881A0504
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:54:34 +0000 (UTC)
X-FDA: 83776112868.22.F60E337
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id BD546A0008
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:54:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GiDx2YUA;
	spf=pass (imf25.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755194072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kCJU29SWd1OR3k6ZUoBci43zBS+gLO8fdMAUUcFIoOc=;
	b=obkwhEHNSDnQCiVuou+KJxgxZQ0zfLcvNjDvgnC2RP9yEEUaC2xyCyTqYWPwTOsw5MLgNd
	DENa3QwMgtc3NvBshJzy7iVMwDtNCnIjqTaPJlXJ0PmQmGiiQtBRH5QHxq0aIhF3rcQXNF
	E/zGR1+DFJqDLhNV1RfGRJS/xcUYrHw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GiDx2YUA;
	spf=pass (imf25.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755194072; a=rsa-sha256;
	cv=none;
	b=LEf467IADGpGGcA2Fbi71TMRMqV3fRs2OJSFpXkmemjVY9huBr2rfNTZ0n6kHHn0EzkWSl
	uUWbgpAz9W139alr88qwSQAroH7rK2wrqj0U1eyX7ULk7ahUkp1HEjrsj1HQY/ev37NejK
	Gg0XsRso6qeQ9/goq+DU7WDrR2h+d1E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 51186601D8;
	Thu, 14 Aug 2025 17:54:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E4C7C4CEF4;
	Thu, 14 Aug 2025 17:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755194072;
	bh=0MhcGdVdXvKtqKaQ8KaQcBZJnClPr0/vCjOFn/qCf0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GiDx2YUAvdSAgdlNedcslwbPWUjIzBCh3H4y4Z2cOp+Za2TXJshVjl0dRbygvJ6fm
	 w4pwmjvnGMtLaeWgVgvSrwVZS4eKaY0eu1ewavbC/hKQ/HDxUGqrtI63NTSsINiqAo
	 B3N0EibDob/Ah5ZvgcmHmf1FmzrR4VW5fnpzgourjkfZUXlvT9U33FbDnbj5mhQ+ki
	 kybEqlGmRFj7sXpjJkISBnna9ohQzWpq6yGNawv36+FjVbNXwqIivN32e/FyqrDjU+
	 9JdIiLz3vmtHul2VhTtnInFiLRRKdhfQ/3K+QZv14C1JTDouJBSGFbjxpROdID/txT
	 DgAY4TGXRn43Q==
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
Subject: [PATCH v3 05/16] iommu/dma: rename iommu_dma_*map_page to iommu_dma_*map_phys
Date: Thu, 14 Aug 2025 20:53:56 +0300
Message-ID: <66e7cc6854e4e40278b598b38e0c4d49d7fcec91.1755193625.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755193625.git.leon@kernel.org>
References: <cover.1755193625.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BD546A0008
X-Stat-Signature: jh69yszw4ijerdzhr1e9fnnxmwxkccye
X-Rspam-User: 
X-HE-Tag: 1755194072-42560
X-HE-Meta: U2FsdGVkX19rD+xbnuCkIeOBPANB5VJRVECjCmINCG4hcJV+ttzD+/Ne78d8MTnfcTUUrbPMWelDaJUlSXbmfjzG+/Bj4MT5hQbZBkt017gfzaIziYw6Iiwvm/9xH2WUwlSL65fAOxv4YTTManXA7v0AtFOtvZcRM6fk3aLdDh8rKep8zGn+uiEX9uxPOeRANhNz1K+67OGjV8v8rHMmiIoBf5q7GWsfBWdwmMS9uJovOtAPQGHRaQadGcgt4mY7Jqm7nB2C2hVUSA0n5x8DOvNXs47Ccb40tQj3TeEBug0o8qOpoKUkUixwBg7Rq10MZrDNBnKjXbs4qr/COXTlS4dWfJ6DRpQGRKPbP6iw1qzuqJExESplDrEXeAepvIwHN9ZGcupzYsrouPiMGPx//9hv6DtEY3cQ2HKi1bddFkQblYxZmpfoKIpHQ2AoEzWw60xI29XNxwIk8jiOvX5g/gqGcT6Cia2OSmj7ge5WWYMJcNULCHYy9TrkbMxRqOkl+rCwlzv5p61Clb0qemE4r1EcIflgwXZRb2uuyiHoU2J+ITNLSO7E593fhsamCYr6EkwoJlyLSlHpROxOsTKori6ja6yJDvowP6v+L2UnNC+jcu7I2zQfedzwsrH1s2PL2mYleiPNZ7uxVPOSFEm+8Iu7nF8Xu5V0G4hEaA1JxP70xdZz+pu0KESBXJO/K9p4i96CwkgO6b7S7Lm0Sn6MDwUSaEphs2DzqQQtKoM7SirVOzmcCMkNOlLHeVxcOwcdzzf8BSia6ytKMaQs4XS0CpouBx/htpmyHKLeguqlP1Nb4i40VvrKQh8m3jl0RTJAHtIj38HhvBiUlyL3jMmQKDrDY8aADLIMPQ6BRH9IJ1NMoXXpIVgHxXMX+dAsTVL/RrP3JU9lhargDLtMRzbBXVcNwrLTMyQch2kmgZEsHJIhxMD/7Y9LqLackoUbOL28CTKdm0FNPBFVK6fsYQQ
 xRNaDgQ6
 oxOAnfP+UZCk/kiVec/a03w0OBykwzrHiuJhWR6DiP+OKXeSvVoecpM2XNl8Zin/WazSnHvX7V9MmlBtXDcyE27IgRrLLaS9MByJo3IV8sSTRoVGE1dEg36Axc7Y+p5Bc7l0fpYWWhsesfJA0tRMjcAEDhJ9nBNd2Y5X0JouEghvCQ5zfpKFn5mgtW+dq+TgXmKdE/RA1nwmmX54FL8etgyRNRrdY050TuUnocskOhXkyREF3dpSZduAWwi9kNLtY4mcor4S4Ikki8yAX+ytnV77fPEb7Kmvi5VtpFTiZKAefsg4mFBSY8OgT/lQCO4RGne4GFFoirO1/ZbwYwhXMhIMqUaJEkFNFk3YH
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


