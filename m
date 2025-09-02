Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BDCDCA100D
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 14:49:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D8F58E0007; Tue,  2 Sep 2025 10:49:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B0DA6B0027; Tue,  2 Sep 2025 10:49:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89FD88E0007; Tue,  2 Sep 2025 10:49:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7A7B66B0026
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 10:49:25 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3D54F139E7D
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:49:25 +0000 (UTC)
X-FDA: 83844593490.14.0870CAA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 94660180013
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:49:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="myJAVWf/";
	spf=pass (imf06.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756824563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0r28goZFSxu4+TQiPbsxYpHpPmrnbh7KwEU70GjOWDk=;
	b=mhY2cHzrBTYRuhsAthy6ruG+E+5fFUMGSWFXsLMZ0RGmfcFNn9p5vHPPwABgKDBu8ubpXd
	+v8UHV/nK4S/Dq2KoTxfjAOfOXNmUIhksRqc/u99WXCtNUs8Ga+EP77CWvcS8P+RPSuup6
	hTizyILtbpOmct2gvXO5vBoibMoqwVs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="myJAVWf/";
	spf=pass (imf06.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756824563; a=rsa-sha256;
	cv=none;
	b=oUAT4CcWjEojV9+2EwCyhjeSl3GqjhnnyfcdxEZswv7rfu/KLXvAcYRqD0CHphIZMKxCFQ
	CcUrX22UNo0vwmbnaG3ezZny74gT8FDrkXFqfkSlEtvjLg/nkCotnF6CrpQBPfjJ0hBlks
	E1BvGHDDpq0KZJODUPsFAbSMJD6mgF0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 997C144B04;
	Tue,  2 Sep 2025 14:49:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63F72C4CEED;
	Tue,  2 Sep 2025 14:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756824562;
	bh=O6uMPMfn6w3e8A1zwYyTqdbKBNXEs5PSAm4+nCx8TRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=myJAVWf/5pP27hEdW1OJXdbXUSkcP79/L41p91PWbmM6tvhAAcY6WU3zAKSpQUomc
	 QH4aB6lvbbnIYw7q8DRSz00YjYtr7WYWtgm6T5RhfgesFjn7nG+KObPUcI6F2HA1Qe
	 Y6d+0zlZE+phzYvWQX50DgVolFKX74Cyn9ITd/6PeRHDBMZF1q+BC/2sjXYDIX8w7t
	 EVN4ghuKO3fVzEnRThIGn3kbv/JwxhkY6m6ltUwZQmazTDeuiTfOD6OQCFhjVu+HL1
	 Xj0ZRiNUw+h9pJF3hE1a+8iqZ02XyqiZEyRBb6QcXs/uIx6mg3fOHMcxuzeC43FpQ6
	 9gnsufUbJk7Lw==
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
Subject: [PATCH v5 05/16] iommu/dma: rename iommu_dma_*map_page to iommu_dma_*map_phys
Date: Tue,  2 Sep 2025 17:48:42 +0300
Message-ID: <9b7eebd170d68db9854056e24b94ec1fdad73d6f.1756822782.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1756822782.git.leon@kernel.org>
References: <cover.1756822782.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 94660180013
X-Stat-Signature: rhuo49wygzhappttkuha6rnrfdsybhg3
X-Rspam-User: 
X-HE-Tag: 1756824563-469128
X-HE-Meta: U2FsdGVkX18OmINxdWzbI6amjycJ13oun4Y4E9WXHo21G7LQDWF1WCnLlY2nhKjX7wOxMvYNRjp1o9/4HgOB4Rfe/jLdcTdmMNEN3XuRE8h/2Vpt5rvJKbP4VqwsmCj3t+db1xX7oVZIXPINzpzUd/VzcdAshGyFYctqGA4Nar4lCfm+0dkzlPr3Hd8Uuxe1HVPVCekhsuh0NRLtfiCTKWpnY+IrJoQIcKm9CXxzbLKmE6iGLSayN1FyU91UuEBHQ/ScHx4HvzIXehmKs3eC5Py1tSSqOH4vUVeLohMFKEuvqmN8o5td8hiqrJShwnY6kquIzuWzKLCKXuIq7u0HF9pe4kVhBnjaEAZv2f3wA/MWh8qipkizD4tqxK6XV5nd4lMH3IB/1oDeU9h+EKWjL9Kpc2EBz9WLrWTikg4+2DbBSKYD/9Yj6ldAwfPOJm0wne9yMaMp+iCYMQT1wIwb+oB7vpLUNPECT2PUvO+Tzm9DTgciFm3sjMyX2SpdJ1qqtCqvJ/QEb11Ou3VyN7kfX0oqJT/u1WAJ5pr2+bEOnBDhl4ICmy/rczS2oVhZe6L8/HR5wTZPAOYqF4IPWtP1Rqe9mk3Kju/QAKp2AETODGaEy2kyXBBjvqveaPm7QEuAFY+353Z/Ln4zUcZ6DQfu0OtrNPAYtoXJ4GqeLg2mQTorvKpQNfjXzUiBiMJWZkrrl+yKpTg6nDgb+FyNkbrfq/LuLww/bKcqNdwrOGk6OZAwp2ILlENzz/rh/Fpwd/dcIPoRhjn0DQLOyR+BJw6hqq5NKcpcQid9grQpTueC6r7mmn9HPuJ/BdOAEKmVP+5zbmPLuXOh2Ok51ilIG5XpXJz6oqlZEXadGEXV2/5iAgxZlLZtCsibYSZZMHPPDmGCuZ5e/jWsaXbt3WZp9g0hAd2EoWjcc57z/GXmzdvWivdVqA8lLiAqSlRZldj171c0LxtVPFDZznoKlgCQQwb
 /B6FdLl6
 O2XP2k6w1w/Gy8dizoONVajjD6T5SsvEheIDS5bsdnklKCJneXt6nZpR0h/gTj435odoPNzXAGG2uxsM=
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


