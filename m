Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAD18CA1016
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 11:33:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBEA36B0011; Thu, 11 Sep 2025 07:33:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6F796B0012; Thu, 11 Sep 2025 07:33:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5EE16B0022; Thu, 11 Sep 2025 07:33:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C423B6B0011
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 07:33:52 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 684B7160473
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 11:33:52 +0000 (UTC)
X-FDA: 83876759904.07.A3B2BA0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9D1D04000C
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 11:33:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tEhGjanb;
	spf=pass (imf27.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757590430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Quo/3xsr+gtT7afDGGKyyokptJbQTqajVAxeYtXoWqs=;
	b=XKqo3a6T1j2L6xNEIkuW7pnwTHBaW7oI58bAqEGobecFiXbJA50K9mQyDjuEI1iwYBld1z
	7jH4y4t8MEEqjc9zYoBc0DEIomZV4xmEfpXVKi/jjD/LQ8swA/xOMz5psZ+/nc8nL6v1si
	V47zVzOp4K0XsZ6307eEX+IFaxu/OCU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tEhGjanb;
	spf=pass (imf27.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757590430; a=rsa-sha256;
	cv=none;
	b=FrGWnu6hgNu79V/BvQAvjzY78kurSogZOi4zQUYZtypb9Bk7j4uYZcnyMU+NE3EteKhsMB
	4DxMD/utR5mzrw+6M1ylzIh0d9XSMpgcCaqsUIzVFTlBafhm5AxFUkAsPV8W/fLss6N46s
	BLJlT9r4kYjXozrVGHMuoUffBacgkx8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 61FAC43588;
	Thu, 11 Sep 2025 11:33:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C97B2C4CEF1;
	Thu, 11 Sep 2025 11:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757590429;
	bh=LldS4UL7ZlxQUaPAsaNZtO9N1rGFM0ivWFvFz+2VF14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tEhGjanbuu0QU4sUBUSidfb0VG5s2MoYJlC/z3ojPIZ+oodrsfgopYPiSVx/9AoFa
	 nWEJSXlTVHyGSPuC8e4j3/5uE40ZYkF9/bZ+7v+TK9XQHe6Tln0P+nQ8UbQuoxiLZ+
	 FZBpVNuNJEjC0EH2IJaq3/5hH8Kai9Fn7otuWVp5zxSZ5LijoMW/v6kG+c8arkw8Ce
	 0ZkGEXMaGVoyCa/aN3HSCLK8G4pBw2sIUVazUi9PWDBlQqFE7CAwveihbb8Cyw1O02
	 kQBUbBuqXLZB5QXGbK79GQF7X7AyOs7of1c1qIS792JTEIscJjN7CRnXGBrKt1XuLU
	 WydIw7KydrlTw==
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
Subject: [PATCH v2 02/10] PCI/P2PDMA: Simplify bus address mapping API
Date: Thu, 11 Sep 2025 14:33:06 +0300
Message-ID: <59e073a3dcb01bb70240fc95c2f13f30ed6b6e55.1757589589.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1757589589.git.leon@kernel.org>
References: <cover.1757589589.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9D1D04000C
X-Stat-Signature: n8jdfqmak36e4z16zuugjnrrh34jyurf
X-HE-Tag: 1757590430-523656
X-HE-Meta: U2FsdGVkX19I+XPZb0zTlZ5On3g1MwRH19gdvvo87BSHUntTU+nJ8mbST3ry8utpbtXxcujpDsxPv74bCaasM/5rif/mUQUK8VvR0AhnKpWZCtJ/tfE3pIbMmY/prS1NtHtGSF7RL3WaXt8S54lV17S6M8cW2Nn0cebTnZPhqhgw1giy/i9sbAs9l9ueWIlL8+wNG8mEzN4wDj2+4yky/4qvg9uFHCZ1ceLo16q0Q6PFYm4euS0Y+iGtWBvICYx/sFZ7OQp5nKcXZXCC/j18KqOnMM/hgjLe4fssfB/PGUHep1MHtZjzpsVhCk9gft+LRhbm9CbMdm6TRNPW63eOBmvtoul8PzNicBvdTie6wUaPk56a/1VDXM9mCsTZbm09MoxY0dr9icBRBwFQJXibX6BLG7xl6+WSOFCO08O3Dl+ymArxv4aW6jrLLT9Rod/94HtJAk9T74q+/3lrq4B0FWwLGANBjoTSqvEFWVXZqw55KPSVgZP+SFllwU7npwtSs0aqMw4alNNwkZC3PMJwX5GuQExb4eXkiAmp4Mjjsp91czESx3rsPZatYRcv4g+yXzOHg0Qgr0BgfMi5pEbSx75ka2yx5GL1RFSVvIkz8ND7nYT79mQBwa/QdVOFQRqH2IUMSNu4FkbQzrWZ8DTJI6p4MqrtHy2Di/pD6pG/FdoeWCoK5/N/y9OWBwpJ2ZQ4Fjr2Yh+jH1xt3LOWC42s640f5s/D9Br9F9Sr3+w3j3eB+NTp03vTYmBqQu8lFfn8wjL/dA0nXZJ5rT+nz2mun7MMwGbd4hWegq+xhxOtPZDrtSpxoj1ThTQzwoxcVL+hGhdWIZE3dUZlcS7899njP1X4RZnephKmmUZnBbtR8yTRcllSndoWmmr4MMF0dng6B53zhRlV62HSQHW8fi51PgPoFbF8C2/qOq+KBREqbG9JEAdT6Jg0CDjUY3eqThjFRu+CiQmRguGayy5ib2F
 /mRTwWxx
 /y9dtGNRAKPDxpAMJudjEDoHfrS1vnLXApNMBbVmI9diyL/8f3C6ENQMTc39KjzmfufiPL+DSupkfwde48rdolD3+/nV9SXBcPAcReUnHuHoUT0UdcB0KuN1Z1W7AHFfwQsPpZEPOsf6Gspf+g5xCu/W6ca+PyFSKaUoLEYxBsZ6qLL1GU7g81OMB8LzKreXFwTtUW7RpoC/qNamkAOFV7/OoU9oxFi/xroQAXV1D6MaDJ/7mE1y8dgCrT9/6t/4PVhOum9Dw/OZ4dtE=
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


