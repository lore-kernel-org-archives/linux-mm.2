Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD14CCA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 10:14:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BCE190012F; Thu, 14 Aug 2025 06:14:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71E6B900121; Thu, 14 Aug 2025 06:14:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C01190012F; Thu, 14 Aug 2025 06:14:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4102D900121
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 06:14:14 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 17621138556
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:14:14 +0000 (UTC)
X-FDA: 83774952828.12.C1991E2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 57B2A180003
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:14:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gYSTOUUB;
	spf=pass (imf24.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755166452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+qkotKjA29uhp00A8rkqHQXkiTzDF9Aqh1SY8eRdGdo=;
	b=ADsHpECrH/P20TV2vdQ4jIDWIM4L9b6slK1oIDqtenUmgWVpvFOEEIDx0vFX4CZQbcdigb
	NgCUpAwhCwJZ+2a+bEInc0oXBHIvPxbdkNRDh69LL5TFxlRRcR9QJKHVlnL8A0Ze4s98oS
	TNMaJ5mS9y4glAKNEpG6lse07ex9u48=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755166452; a=rsa-sha256;
	cv=none;
	b=v5urcxsdVMtFQA2c7P3XT00BAucadPQoFY6w3ugCokxkdjs30Ax/AD0myHq31mlIFnV4DO
	rnHvE9mm686+qd/Ke4PXQgIRJ6hE46N9rvkT1UQGYQguLp757dmzg8y4AA2Oq76uz/nZ1b
	sSDg7X5x/VM+3JrtsrKSIR48pfUieTA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gYSTOUUB;
	spf=pass (imf24.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6330E43582;
	Thu, 14 Aug 2025 10:14:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A63C4CEED;
	Thu, 14 Aug 2025 10:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755166451;
	bh=dJuAJRFwFKXIJkybNGJNx5df3xqMYXp7O5ndEMDZg04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gYSTOUUBhXP9oYVeGhvKAxkKtotRiKvTg0RZNz5VHsEaCJX2eHmD/K9w5qQtOdsaI
	 y5jL775CbyjUQrmgE50XrKUnHBz170vHKkADm0guG8UONTpIhdOC5F323EiEF29wv2
	 QwHY4aIgwraPerETB0r/ojs0AyO4T+0+stcRCguPuAhk+m/gmOjrihbhskyvMwc76V
	 7KY3xjUJx9KToKwhJ4n4n4bsbHow2xCAf2WHn2KwBEezrtyiM32lypcGqEOd3EwGUr
	 M4D8CAuNqM6OABoBZDrH4H+rPpHALQRE9/xcG9RN53uHeZ/mIgd3xyDNiQYOaPXJsW
	 FYRlTCCOPlK7A==
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
Subject: [PATCH v2 06/16] iommu/dma: extend iommu_dma_*map_phys API to handle MMIO memory
Date: Thu, 14 Aug 2025 13:13:24 +0300
Message-ID: <3086f426f3ded9c671e9a6441810c21efc9ad87f.1755153054.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755153054.git.leon@kernel.org>
References: <cover.1755153054.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 57B2A180003
X-Stat-Signature: djgim5kmwkqqfzq9gdnp94o5c3c58ug1
X-HE-Tag: 1755166452-642355
X-HE-Meta: U2FsdGVkX19NGzapn5P7Qb5YPdG+GFuVMvzhWGCo24MTzzHAu7/rZEGFgH1w8DYQeeHwoSmnIlvPsZG/WI6l+3bI8JgijVBHgXLFyAEc4mRBN0/sJVQUAUUug0iWCxYnmM8kwxV1ut3VIWyDmAOchrco3gcs785VTxLtsJlDM1Hof6d8pn7X9TSpaWe0tANeto8LdVIt5rZ8B3nanZZtE2tZlb8fhzsaLWcB8vlNdqv6ntlM/Qh++hB9eK4y+psXa1FS6uxl57oJPG0N0PDvemgsib+kxF388qzUd+DxZP+OcMOB8SPbVUZPh1Km9XIqnz6Mia930XO3rbpV8RUmnjQft97t1OilHhhaX8Hj5zCooRpnxNsNrWE7l0hA5wOv8jCtl3ryhYaLAx+w788ITUNsW5nmZQqGp0hOn2QrvdBpPjs9oE4PKmb8qfhJ2PJ88AqB1rR82eiB/dLPZAVn2femymI4ILq0ukIf4HCiZmjshFBTKjqbjLxga0DNevkxSkDwihhmQbaN4eFL5kSPU/Aldes1wxpCAsbFl+xvfial+mGlYR+GEVnseJkndtO1gJpLQuiBder+LWvwHBq/Q4yQpTguy2GJVOwGavDdb88lRcsXKWpCI0LFJxQlFaUlILAT76UAlZjXRMkmfPnnrMPJS1i+MAkJd/AVQ0yBXnOCrAOrqCifnJrChaoMwb+iDgHMAaixy7iq6v7unGWDUqyJEHvkFuDnakIOngBajUXmtdh/pUFm0wuXgqQEQjxdjXf/81HnG8EODnh0NGI6GKfMykpVyBKNtwd81hhdpu8++7L+AkBS0r9IVw8UQ4HADkzRdq1DRESy4D20MRW4VjlgLTUflby0Mat8tXblRlBs1rnf3bmhn0IBVNUfxpZSJ62bPxjbjB0E2z1dCfKmGJOAPVr3h3VxoJFDcLrh0zESBak841lilkN4TemagZESdq40O5FQQ3st0poMyjb
 Qf/eMMuT
 vpo37WCOxfqqW0+cgo7t7BjhBL5NkFq65UzxXqtZMISgzAo4x7sRAGK+YnmaztjKGoIWDcnIZMqW1/QhCClfm2+4XPcemAtdQC/WprcqTbL7Logl5oiNgEdBzZoDupQP3hKzt7BYVsZaX1u6VeLDeyqnnWcxmDTc/An5xt6M1tW3QlpRLWwUWFxiqYm2QdojRb/fo9Vjn7hweyv6WB2HcmEEset9uYVjxDjgl5cPcJJ23EwWPaaeOq3SQ7XgqgIy6/qxJ24Hynuz6ZNnotn/zLOUAbalL5hrRn/p5zTGrv08v8ET3raZ9U3tbSMYMeg35Wm/Cy6yqom1ftKKtY5Ne16TyCOX6+pvpypio
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

Combine iommu_dma_*map_phys with iommu_dma_*map_resource interfaces in
order to allow single phys_addr_t flow.

In the following patches, the iommu_dma_map_resource() will be removed
in favour of iommu_dma_map_phys(..., attrs | DMA_ATTR_MMIO) flow.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/iommu/dma-iommu.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index aea119f32f96..6804aaf034a1 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1211,16 +1211,19 @@ dma_addr_t iommu_dma_map_phys(struct device *dev, phys_addr_t phys, size_t size,
 	 */
 	if (dev_use_swiotlb(dev, size, dir) &&
 	    iova_unaligned(iovad, phys, size)) {
+		if (attrs & DMA_ATTR_MMIO)
+			return DMA_MAPPING_ERROR;
+
 		phys = iommu_dma_map_swiotlb(dev, phys, size, dir, attrs);
 		if (phys == (phys_addr_t)DMA_MAPPING_ERROR)
 			return DMA_MAPPING_ERROR;
 	}
 
-	if (!coherent && !(attrs & DMA_ATTR_SKIP_CPU_SYNC))
+	if (!coherent && !(attrs & (DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_MMIO)))
 		arch_sync_dma_for_device(phys, size, dir);
 
 	iova = __iommu_dma_map(dev, phys, size, prot, dma_mask);
-	if (iova == DMA_MAPPING_ERROR)
+	if (iova == DMA_MAPPING_ERROR && !(attrs & DMA_ATTR_MMIO))
 		swiotlb_tbl_unmap_single(dev, phys, size, dir, attrs);
 	return iova;
 }
@@ -1228,10 +1231,14 @@ dma_addr_t iommu_dma_map_phys(struct device *dev, phys_addr_t phys, size_t size,
 void iommu_dma_unmap_phys(struct device *dev, dma_addr_t dma_handle,
 		size_t size, enum dma_data_direction dir, unsigned long attrs)
 {
-	struct iommu_domain *domain = iommu_get_dma_domain(dev);
 	phys_addr_t phys;
 
-	phys = iommu_iova_to_phys(domain, dma_handle);
+	if (attrs & DMA_ATTR_MMIO) {
+		__iommu_dma_unmap(dev, dma_handle, size);
+		return;
+	}
+
+	phys = iommu_iova_to_phys(iommu_get_dma_domain(dev), dma_handle);
 	if (WARN_ON(!phys))
 		return;
 
-- 
2.50.1


