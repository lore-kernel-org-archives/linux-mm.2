Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE754CAC5BB
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 14:51:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 338628E000E; Sun, 28 Sep 2025 10:51:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30FE48E0001; Sun, 28 Sep 2025 10:51:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 225F48E000E; Sun, 28 Sep 2025 10:51:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 122A78E0001
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 10:51:26 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CF7FEAD11E
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 14:51:25 +0000 (UTC)
X-FDA: 83938947330.19.09BB211
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 18ACE140007
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 14:51:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=diwHskkp;
	spf=pass (imf26.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759071084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qo8xCAiwha2ShbhTfwB3fa90Kobhf0sOYVLRL0h+2KM=;
	b=fEU79Ll+By5bN5KYR4I31qFAZfBFpsRlWlNgk0CCIPMQ8dz49PlIU4uH+JlGY+YuwQXsjP
	em+coAnD26H6bCZ3sVvN6vjPpS+5hcEbMO24BQ2tVV9UCOMSzIOPoGFoL70rRu1qaY5SGK
	iruGm5/iUm5umpYqAzDvxJ3PXaTdUio=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759071084; a=rsa-sha256;
	cv=none;
	b=0o/UeUX5H/RFiezpjL1y9vfE8w3GaqlaMIJI3NB7N+NU6mUzOIXN1ANTys6QJpkzLgduVI
	cVBRcf6LMzQ5vnKSiSLCx1Vk2dOCOi0vJSLqJKQzL0Dm0u8F33zvdGCx091OjFNYA1rn+C
	6HImLcnJQOC9zNPK86xsXqUCMlPLWsQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=diwHskkp;
	spf=pass (imf26.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2E26445EDA;
	Sun, 28 Sep 2025 14:51:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9921FC16AAE;
	Sun, 28 Sep 2025 14:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759071083;
	bh=fAY5V8PbsSKOA8DvUuCvu1FfIH+Qj+BY2oelYoa+EDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=diwHskkpa3p6F4VdCvgJNy/EuzDJs4pXPl6RrEDbNLJ+BIsyiUDIM19XjnlhulysH
	 rUff5YhqMltcMVJB8vUQ8Hbls521E8SrbV2SSi9Ruen5VCuHXGzT6sOu5E0mM+Ha64
	 AepfPnBfeSdUyrOCOcJXHT7GrTbHMCj7ayn8AI2JoHGjacPO43FjSGoZfZcrEvO0a6
	 j8QcyHFEQqhTjoLomr+sI5S935XCMN+Zvin9FCunYI3SU3xX3h9kb8BtQHMobl7ftQ
	 KQl4xsyBqIGAdnDA7itSE7WXLU2A5NvszEpo7tp7WMHg5UmpFoTFgJOxr+KTHl2v7+
	 R/puZG9ARaI+A==
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
Subject: [PATCH v4 02/10] PCI/P2PDMA: Simplify bus address mapping API
Date: Sun, 28 Sep 2025 17:50:12 +0300
Message-ID: <ce571cf4ddad1f9d4876365fc3c6ffb9321558a4.1759070796.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1759070796.git.leon@kernel.org>
References: <cover.1759070796.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 18ACE140007
X-Stat-Signature: y969wyazi6bnw9eocsqzhyebi9g4yq5g
X-Rspam-User: 
X-HE-Tag: 1759071083-202869
X-HE-Meta: U2FsdGVkX1+3JlwrAtErcV/p6myD1QdzESaT3rlk0drpb8pQuW61NknPeJN68XOBCkVUYzg95kWWs9fX0tsJIITS5Aei6FGTDglKqvqLLAjpc1mm5XNrdvM1ZQ4yZg+wIFTTDg1Fmgs0Mi3d2V40uqqSVZgWL5RzncVAPXYk8Rf5lFD6jFfJfuCj/uG7CTQSziYGipkCTxpmzlbw8JORH1LkVIDl8QyLXvAmR9sZDqXLu8OnsrWD1e5uPO/1MxmyhKIGBnMISbuUsKggzQGp9C3GB9Zyb+Uw+bYZbSxRiYNF+/iMdxq5L+PE/epil/VhOSiHp2FYiCKYkgtVzym198hK7v4O3LSTJ5Wvl4it5a47n7snxod/Ntzp1voUdSkTQFJIC/PACB3OPbrMdD0QeszxM3awXPnthQ4iQ/bad/M/WAJZSiArGgcimd13IlFH6tEtgwSbyBnNwAy6nSX+HYZ5InkgwcM94P6l1ehgBF8snD8ezpJTyqIjevniqa2MvXqt4wyqYlbnvjF8KrWcX4k22SKXadIGKAlxB4WWsraastJ7UsP72xn839XzEAJ0/CYrBuVlHx2TaHOH+xhTFg3C7d56cZfWWCGiLznAOis9SpF0epSUda4EV2e/FYj0/gZBRmBy6t6VBQcin1CCbM5Cc2fXUOmqqdRblN+guuotmPyLJDPbFgffpouSlP6PtMJJ0zk/cC6QlHNIUqzRyRyJGHPNmyuSlPLq7fKTqLxceyXU34bcd1MD8QF/+ZtvTcBsEwvMT4kFU8AZH1jNFFl/6ciBPO7gyQvBdHN3mh6ypgriq74BFYHmhUbWv0Z7EhX/S+usAwzO0B4hcebvKl5ZcHnQaNjVV2DyWw3rSr77nWhOMH35d9QWSCYHg3lB0nUZpxqoxrYXHky3XpTXjpjd+EO6q9o8TMsz9YYRjZ/zpYfhgsq8Tv/enWOJirLp/Jub7NiMIMF+8CHo/pL
 pV0PUcua
 neJoDtykcmCtNjcSEe6mukEwWDnVjNpyJ6bYWO6YqDuJiap4SYP3GZ37+hyXG/frz7IUaKe097UtE0zE2jmELXxvVpQo7ukk0BM/bWhb0hNfKuY2Sl9OfSuXMxJ933FSLoxHlSkQiIoDviGdUOfjp+kB2U+11Yi0VLNRwxYolOST1S9gjayAl0coqVAgdhNHVwhno1fS5cL8RVR2+DK2WOHF1sSx2ge/BhjQ1vtlXFJ2awk1+y4KIZA1aGxIh7z9HAReBAbyAqsW+I3hkgWSMOWBNJxriUxEZwoOR/OFj3aCibG2Rsgk1kxZBwuuBMSskIJdLaKV0PLKoBKVMz9GzlzmLNpOMQZdMbrsnbaNL7GGbHU1ytjo3VseWRcJ2XfM3Xe+s6JtEv5eSDqM=
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
index d415088ed9fd..430e51ec494a 100644
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
index 7944a3af4545..e52d19d2e833 100644
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
index 27a2c399f47d..eef96636c67e 100644
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
index 1062caac47e7..3e058c99fe85 100644
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
index 6556c0e074ba..012b78688fa1 100644
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


