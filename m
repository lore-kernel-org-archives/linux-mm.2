Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 833B3CAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 13:18:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D89CB8E0005; Thu, 25 Sep 2025 09:18:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3A248E0001; Thu, 25 Sep 2025 09:18:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C290F8E0005; Thu, 25 Sep 2025 09:18:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AA4918E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:18:35 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4C7C9140200
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 13:18:35 +0000 (UTC)
X-FDA: 83927826990.02.7AD8ADD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8DD4B12000E
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 13:18:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dZ0bIaXN;
	spf=pass (imf29.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758806313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Quo/3xsr+gtT7afDGGKyyokptJbQTqajVAxeYtXoWqs=;
	b=DWA+5LRxpH00JbWKtuVdmEipiL5MdXOXeTMNoYboCPN0Jq4nnrHpsD6+HfC95s3IOkPxsY
	9HFF9OArD9BIEALd8x4axbxX6IQHBMqFOvDtbK4vZZfpaMpo5EtTYGIOJgKfGCBXeZmRAt
	d39FydqU1HJ6T2pi38rP+PmvBbZv3tA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758806313; a=rsa-sha256;
	cv=none;
	b=DLaP292Rykj9cknHbuP0XqjZgTfoA2NkMTbu9Bg+XQGXcVtKSGiEWL39Hv7IY3BdgF00Mz
	kCJlAHplIgXVxWON5UXkTBc+Rxoy9ph7HOpYr5P5TbPq3+brEKdmIU4rAHclLdy6oJcviy
	voEtHOuo0BDj3u8Qa76OrLK9T86+pSc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dZ0bIaXN;
	spf=pass (imf29.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 46EBE4521F;
	Thu, 25 Sep 2025 13:18:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA7B1C4CEF5;
	Thu, 25 Sep 2025 13:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758806312;
	bh=LldS4UL7ZlxQUaPAsaNZtO9N1rGFM0ivWFvFz+2VF14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dZ0bIaXN1PNaTAD9Kjs2+Ss22c94ZLLAQ4uBkcOYx+4DrRfD8Ljbo+7DR4+/wrM70
	 p/8S1PqUZ8eIRnYejDIXO+xLr++iHb38s22BV20uCzd8BjS2yX6RYCu7uVD4Gk8Avh
	 lhVtk/aazGItiQgVbCSmrm8pXgCs8HUb3O5Hwq+DwbGW7LxonUFPF1IjyuMn/9spNB
	 WJXJIpN+U176dqfHLdBpIo1RFdmWFUuSRbnMAGrWO9p2UUXf/t+fEKnJCJPGWeEFHy
	 d6UwfMnq2MHRc1mozoUURZ0ev5Dkq8os7bPCApIuZ0ExOIXY2BFneibYTHrVqLpLMD
	 /ST1Js7q/4XLw==
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org,
	iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Joerg Roedel <joro@8bytes.org>,
	kvm@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v3 02/10] PCI/P2PDMA: Simplify bus address mapping API
Date: Thu, 25 Sep 2025 16:14:30 +0300
Message-ID: <ce571cf4ddad1f9d4876365fc3c6ffb9321558a4.1758804980.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1758804980.git.leon@kernel.org>
References: <cover.1758804980.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8DD4B12000E
X-Stat-Signature: 6g1o4jzob5xmf5w7das5uteenodstngi
X-Rspam-User: 
X-HE-Tag: 1758806313-704034
X-HE-Meta: U2FsdGVkX1+OsIsrn1e6IGTBJ2iJPGaNMaAxInWvrekEnNeCnnquQib3CyOTpWvfMntzAP4pg7t2HjwtXzuf/uIZT2q4nP2aS6EUDn9pdfogDAknWSBIGmQqnQLO2pC1/VHsQ48PAcuTEl9TppMq8W5uj7pUYfqmjFULIMG4EP++C4G7AOvfpz3Ny3FHhrXorNrvqr7y+cMZ5dyQdsQTj6E1GKx/okdZ97V8O/18uWotdcw1uCNbvuqNEwK/0xercCehPy32uEVQmRL2GKbOrl2gVi1vo0HUozaHbagaXaaVURO2rUQ73IXJr39HvdHj1LYSToYBItlnIzxsSUsxVJfLx6hh1RQp6jLbjgrc5TMH6EMl250r2oLMw7Wu47qYU3S56H5ynUE76QqUErIvE5G2Z3mbRTuEArZxvzGrWMR60CY8kLRd3G2gevXVW+UY/LngMa1Nho/EbdM0qsVoA0IliIwKuykbPeURkNOPQX/BGvedP+JxPEmXkKW/JD55FliWrCo9CcTUhUaEn4kJecPzdtWrgDKl4ORE8+JrlpRdJv7ST2q/JRFJEarKDABPB6Xo5VqgeTWitkK1ACUAgxt7xOFJx5V4URsffYyrtv6r3JqjX0iI04De75GdHPnKxAth/MEq+GsXaHrPWlp5UTBXVnyPCg96Uf5bkY3LyIWAeCkECJmKiKnDjXL+3meuHRjtpxfkTNnf5rO7Tzy8h5vL+nR8sdsoBDmmeOD7Kf54r9wd8QIWOcnMl5YdQrhM583JPR/bQMRplnZqpJm+H+iveJy1fBUtepG+QVDNnKjxFiJ608qxyXCDiYbNiniEbmGjMedvte7YbWXl5TCiXSfLLhjK78A/X0TzNS2mR60D3dpvaELVf1rDi/iUKmabJJRhyRq879lvgaRvAPHIgBDYjC37oqdrnWZcNYFplz/FI2RD7kdIHeIXR2R/lcSnMWfV1Na4X+GyEMa7OEG
 lUCy/W3A
 EhlkDSwPnr7LZ33QMDZq4AtEGfAFg9a8riIPlHevJ16o1ySEzGx7puOD5/wHaMaHQ3S7D2CAdrO257v89TrsHBELJ8FMAoaNomOXsqSC3yp0asNL1+ROxxwdL3p1BxQ79Q//GQ7I2NmASCemqzOR3UCFPV7324Jebxn2coUPO1e94J1jWSLLbm7ykuSbXiiU4bNR+JxLSzpKJRAqoikk4lmlYiRH7lVAXJlekKjla9LtXBdd7ZIOKftWdnXpouYesugA2h554XRgSJbk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

Update the pci_p2pdma_bus_addr_map() function to take a direct pointer
to the p2pdma_provider structure instead of the pci_p2pdma_map_state.
This simplifies the API by removing the need for callers to extract
the provider from the state structure.

The change updates all callers across the kernel (block layer, IOMMU,
DMA direct, and HMM) to pass the provider pointer directly, making
the code more explicit and reducing unnecessary indirection. This
also removes the runtime warning check since callers now have direct
control over which provider they use.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 block/blk-mq-dma.c         | 2 +-
 drivers/iommu/dma-iommu.c  | 4 ++--
 include/linux/pci-p2pdma.h | 7 +++----
 kernel/dma/direct.c        | 4 ++--
 mm/hmm.c                   | 2 +-
 5 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/block/blk-mq-dma.c b/block/blk-mq-dma.c
index d415088ed9fd2..430e51ec494a6 100644
--- a/block/blk-mq-dma.c
+++ b/block/blk-mq-dma.c
@@ -79,7 +79,7 @@ static inline bool blk_can_dma_map_iova(struct request *req,
 
 static bool blk_dma_map_bus(struct blk_dma_iter *iter, struct phys_vec *vec)
 {
-	iter->addr = pci_p2pdma_bus_addr_map(&iter->p2pdma, vec->paddr);
+	iter->addr = pci_p2pdma_bus_addr_map(iter->p2pdma.mem, vec->paddr);
 	iter->len = vec->len;
 	return true;
 }
diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 7944a3af4545e..e52d19d2e8334 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1439,8 +1439,8 @@ int iommu_dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 			 * as a bus address, __finalise_sg() will copy the dma
 			 * address into the output segment.
 			 */
-			s->dma_address = pci_p2pdma_bus_addr_map(&p2pdma_state,
-						sg_phys(s));
+			s->dma_address = pci_p2pdma_bus_addr_map(
+				p2pdma_state.mem, sg_phys(s));
 			sg_dma_len(s) = sg->length;
 			sg_dma_mark_bus_address(s);
 			continue;
diff --git a/include/linux/pci-p2pdma.h b/include/linux/pci-p2pdma.h
index 27a2c399f47da..eef96636c67e6 100644
--- a/include/linux/pci-p2pdma.h
+++ b/include/linux/pci-p2pdma.h
@@ -186,16 +186,15 @@ pci_p2pdma_state(struct pci_p2pdma_map_state *state, struct device *dev,
 /**
  * pci_p2pdma_bus_addr_map - Translate a physical address to a bus address
  *			     for a PCI_P2PDMA_MAP_BUS_ADDR transfer.
- * @state:	P2P state structure
+ * @provider:	P2P provider structure
  * @paddr:	physical address to map
  *
  * Map a physically contiguous PCI_P2PDMA_MAP_BUS_ADDR transfer.
  */
 static inline dma_addr_t
-pci_p2pdma_bus_addr_map(struct pci_p2pdma_map_state *state, phys_addr_t paddr)
+pci_p2pdma_bus_addr_map(struct p2pdma_provider *provider, phys_addr_t paddr)
 {
-	WARN_ON_ONCE(state->map != PCI_P2PDMA_MAP_BUS_ADDR);
-	return paddr + state->mem->bus_offset;
+	return paddr + provider->bus_offset;
 }
 
 #endif /* _LINUX_PCI_P2P_H */
diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 1062caac47e7b..3e058c99fe856 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -484,8 +484,8 @@ int dma_direct_map_sg(struct device *dev, struct scatterlist *sgl, int nents,
 			}
 			break;
 		case PCI_P2PDMA_MAP_BUS_ADDR:
-			sg->dma_address = pci_p2pdma_bus_addr_map(&p2pdma_state,
-					sg_phys(sg));
+			sg->dma_address = pci_p2pdma_bus_addr_map(
+				p2pdma_state.mem, sg_phys(sg));
 			sg_dma_mark_bus_address(sg);
 			continue;
 		default:
diff --git a/mm/hmm.c b/mm/hmm.c
index 6556c0e074ba8..012b78688fa18 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -751,7 +751,7 @@ dma_addr_t hmm_dma_map_pfn(struct device *dev, struct hmm_dma_map *map,
 		break;
 	case PCI_P2PDMA_MAP_BUS_ADDR:
 		pfns[idx] |= HMM_PFN_P2PDMA_BUS | HMM_PFN_DMA_MAPPED;
-		return pci_p2pdma_bus_addr_map(p2pdma_state, paddr);
+		return pci_p2pdma_bus_addr_map(p2pdma_state->mem, paddr);
 	default:
 		return DMA_MAPPING_ERROR;
 	}
-- 
2.51.0


