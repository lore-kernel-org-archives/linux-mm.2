Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2D4CCCFA05
	for <linux-mm@archiver.kernel.org>; Sun,  2 Nov 2025 08:01:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 280B68E0006; Sun,  2 Nov 2025 03:01:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 258BA8E0002; Sun,  2 Nov 2025 03:01:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 147CF8E0006; Sun,  2 Nov 2025 03:01:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F18498E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 03:01:15 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8B21913BE91
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 08:01:15 +0000 (UTC)
X-FDA: 84064921710.02.AB6A399
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id E713240010
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 08:01:13 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e6A9ZpxE;
	spf=pass (imf07.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762070473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kq2cQlVij65sisaqrogGNzYAQSBpX+4ylmHJGBKkVDM=;
	b=p72agwXd7T80Ov6CmoojZhEZw+TcnuOh1pdRp068XM6Ao/B833/BOH6rhbzldmNvViOk/0
	jW767iyxfhQ7FDEvMdKj3lg7clMsx/EMALE2AkrX68cpRPy/zv9+BJKPvj8pxjg6qVc30V
	Th7nvy+IXbnnh+TvW3xm0dTrkMXeMSI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762070473; a=rsa-sha256;
	cv=none;
	b=KCLpXLAO+SgNivwwQPG1uTY7v6KQMnkny/iUmQLet/0rJEQrVBqiJQ+SyUqbD0fsa2hgCI
	GcVzIfJhTNTrKLIDedg1H6qq0T6zRApf6YQND58YNxhxhPqYyRAF4K4ZbgLDsHmjYz3mel
	8aJskpXHNk4/mn/gIZu2Oe+T+EhCqqs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e6A9ZpxE;
	spf=pass (imf07.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6645160191;
	Sun,  2 Nov 2025 08:01:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 677E1C4CEF7;
	Sun,  2 Nov 2025 08:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762070473;
	bh=52xkct7RbiP7TJxlq5gwk/kVznK8/SfQCbvw+RbdY44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e6A9ZpxEqoHrezmIRLUWP4C9FuKcChx1MzF+ANQrFoHfWubxuREk7ChjWYRcjbn2k
	 NSgmX3tttWgri+ua1AVKyqTUOQILrsHbsvtkARsaynpNy12etUr6WazrrDIS3Q1t9i
	 pR27s/pa/6rAk5YFrHn2CVkGBDs7EWqZfr+QWveDKqHzaqwGwMIzqi+E8p3E7GiQgh
	 8UI3iemxx456383VIz4Uumykyee9LkYw8ClV8xTQy18ZNeg/S0NvoJujCeWuNlCtgq
	 Luhrbmk9tA0ilYBENnTAlI60GN5tldInDOsfoD5fDM112ecZL+IzvHs8XROYhUhREu
	 R46SQKKObXnnA==
From: Leon Romanovsky <leon@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>
Cc: Krishnakant Jaju <kjaju@nvidia.com>,
	Matt Ochs <mochs@nvidia.com>,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	iommu@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH v6 02/11] PCI/P2PDMA: Simplify bus address mapping API
Date: Sun,  2 Nov 2025 10:00:50 +0200
Message-ID: <20251102-dmabuf-vfio-v6-2-d773cff0db9f@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251102-dmabuf-vfio-v6-0-d773cff0db9f@nvidia.com>
References: <20251102-dmabuf-vfio-v6-0-d773cff0db9f@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: hc6gug973pm1p5c5s8j4kbhswwahgkmq
X-Rspam-User: 
X-Rspamd-Queue-Id: E713240010
X-HE-Tag: 1762070473-248435
X-HE-Meta: U2FsdGVkX19YkmT3hZLUuPYOXOl9SLT3CPqHnD1Fd+WH0XY86nFjwBL0ZWn+sg94+a33vKBZ2r2jFCY+BwIxQaQ9om7GVMaEgtjFLKsWX7DEjZyT+YFCmUdtCYPN2QltvI3UVoFsOudWKzcoDFngd9otQY/SkmsHZIIB6ZRkjRkui03VMGrdeuuWUVdLOJ5ekeiH/0jBdmNVhP67EtIPH/Ysvx+0Z7je4/tJx64maq2QipJWebGgfZ7D2FUBNXP9Q/coxNPZ8JV2KJtGuBl6zh4Bzwvqgk+jSitFa6QS0W4iQ+1AsilvpEO1GIvZOZLEsm6Nao+YB4yN2TkgaFkr4DAYcz0uWojwOG0ybdVkS9pUM9PHOTbAZjR/Du00pepbjdMw7bPAK1tMj8ZG4TbSCAYwjbojNgSvDWHtfbK9v1h9cImHmnaHztFljNb8S7wv14+ECVpx4m8vjeMbAqgwPcJHtrxoB2ntNT6koMlpWSDOkNiGfzc/Kd3i52BM8Mw77KHso7dvtLCqZxnNp0cV0Y69ajz410t54DSoytmpC+e0JxBrnZUs8F5v5KNNTF91fwwi/iFGl08/3+QfYDhxx1Kr3JCpNUrhPjN2f1sYcvXiPMxd51eyuOR6iCU3KW0/nvvw4xjtlOG2B2nNSRfml7jZVI/PPXh8VNmSD8cFRCkWMAxATT/ihJToGNkvtzEYiDz3HwkOposHcaYgq82mPIRF3S5sqPRrwHnRNwCatzHaUKPL8vUyqn+LWy/qvz05LSrPQ/AC9U15YX0BPOyUK8n0UJdRd/kPqs3k/0EU2YSDPVeS4u3gr8bRhCQP1Fcyn9CGaHxEH8/apJDelY0KnYDbfXSnZadHygfwwZLyHB9Zy4HesO/G44bDnUHhATUUQLOllter2m50yB5cc5fPIJOd7EVYE5smptP5D4nUaAl7xRcriiTU39pAbSegtnGjRN8vORU/GFtvAd4KFUM
 ArnjkPE5
 oZ1FlqiOjU644tzrDjUqZGIHzzRK5Fe4Fo+J4EgVGBpFR66q7teFw/df/EWEt290I6uKEAVO7xD4NVJUc73ZwYMn9gEdKDXmXDej+XDdRNhaTDQtmPVoGlE3agZFZ4kxohnzAO5bgxbyqH3iJKmZW9ZvzJcBhffnhJBgV
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
index 449950029872..a1b623744b2f 100644
--- a/block/blk-mq-dma.c
+++ b/block/blk-mq-dma.c
@@ -85,7 +85,7 @@ static inline bool blk_can_dma_map_iova(struct request *req,
 
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
index 1400f3ad4299..9516ef97b17a 100644
--- a/include/linux/pci-p2pdma.h
+++ b/include/linux/pci-p2pdma.h
@@ -181,16 +181,15 @@ pci_p2pdma_state(struct pci_p2pdma_map_state *state, struct device *dev,
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
index 1f9ee9759426..d8b3dfc598b2 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -479,8 +479,8 @@ int dma_direct_map_sg(struct device *dev, struct scatterlist *sgl, int nents,
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
index 87562914670a..9bf0b831a029 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -811,7 +811,7 @@ dma_addr_t hmm_dma_map_pfn(struct device *dev, struct hmm_dma_map *map,
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


