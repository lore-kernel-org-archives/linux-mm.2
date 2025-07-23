Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91166C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 13:02:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F05C8E0007; Wed, 23 Jul 2025 09:02:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27BB08E0002; Wed, 23 Jul 2025 09:02:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 190B18E0007; Wed, 23 Jul 2025 09:02:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0A9B88E0002
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:02:07 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CA8371DB5FC
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:02:06 +0000 (UTC)
X-FDA: 83695542252.16.091F5A7
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf09.hostedemail.com (Postfix) with ESMTP id 127CF140022
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:02:04 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CMXvNedL;
	spf=pass (imf09.hostedemail.com: domain of leon@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753275725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eFufXXnDD2AzLMk5uZcnI09iyIHnqilnbBLLWqau6fU=;
	b=TJpx+K1Bll9OuqvYow0Nt1qDncHXGH1FwK2K0XNQpsskPx3juu9C9OjcZX6RjAEqvHhEkR
	4ow1A6AcxKlvX8at7wtALeJ1nsbola3OkTtlfGI47bXVtPHsaFa0lZauVlkhueeIgyWA7r
	qjbDCn96TuRpKGPw9w8aZeXjpzucG6Q=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CMXvNedL;
	spf=pass (imf09.hostedemail.com: domain of leon@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753275725; a=rsa-sha256;
	cv=none;
	b=C29ZWbF1oFQem6skaqqHWJE1650ntoYKGK7BWBS8AzxmsW/z/jIdMge9ZiNh6Q5PiD0/tN
	WU2Fbko+7ohly80Qbv5gzgQJn407HyMl2HEgv7mvWePFUw474U14AM5WVSoE4043TQpNu1
	rN/DU1SoCfH9iTKb8AfK5KCGFtHmgOI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 4E234A52853;
	Wed, 23 Jul 2025 13:02:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D21EC4CEF5;
	Wed, 23 Jul 2025 13:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753275724;
	bh=uuCb+V2zNc5XSrBnwxrMawyQmHST6eRwzZ5HxKmtUAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CMXvNedLSRoRNIwJaHFwymWQJoLQyy5HeCJn+iVUJAlK00FGokYtqVBrXV4haQEzj
	 4iM1gvpoEs6p9cZdfKk01lySbx1k78BYRLrfwsTbzRoWU+Q+XH+Qd9DgCFFmNzMZs5
	 L4oDttcRXsp/Ta90c0k8VhrbYHR9/CeOaCy2K7cOOav1SR+AaaCAhZ8YMlUBM1+C3G
	 YmlkbaQZzVl0iP3yUEOECQOLzv8Tu8kLt0j1LO5zFl7MasnoEyvYAVwA7owgkFzqoV
	 AkQjTLVdtMNW/QuID+PRdNgGe47BkgzJUFzNMwQOk/GEInoTws1TVgMkin8/vgBYB5
	 3BbS2oJqswGwA==
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org,
	iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
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
Subject: [PATCH 03/10] PCI/P2PDMA: Simplify bus address mapping API
Date: Wed, 23 Jul 2025 16:00:04 +0300
Message-ID: <30640b5e4ec975f928e685b92aaaf3e2e5e08f72.1753274085.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1753274085.git.leonro@nvidia.com>
References: <cover.1753274085.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 127CF140022
X-Rspamd-Server: rspam06
X-Stat-Signature: tfcdmpdihcewircymqy5jd1sbezu6ybo
X-HE-Tag: 1753275724-354536
X-HE-Meta: U2FsdGVkX193aywm4JNHsSwoEJP+XWAMeFY95C26Jvvo2c3dwGa+q//TnfX/DwydOfKGnzya2KoEreXi/w/gBUUhC+iskzLelu+dA0Ms0LYHdhLuSH9Dd/grbDANtriM1gPEzo79zbiYcNP/YwbnoawkdO75iZli0JRl3pv+5WE757AqHo/447dixY3/71CZTNQfLOOTA5A/6EiELUoETcdvnoUnIhQpasryc5NxEzKqZWgqRkT7q4xk3wQI/YW0UG2Xs+P1V8A8WcDUILyo6OS73tx7pefvu88uoXj78qVbiqR6DsOf6zQ4wHYpiMoazci8/hEkdQtacY2bbQSOyyuVRO3HFfuHD3y1W553yFMDkFPbbYZvyHEU1TpmdzBsWDw3fnWj8NA2X7xXaWr4e2IKrxZG/242PIhgORuqNHSi7hfhOXyx9VE5qQw7tNEncmX9dAefP0l3pSjF1QxcmTV3LliOJ1yN1SOCyYwnlJbElBiqSx9WwohUdZqbbpYlvO144YwYf0PVarGfqzf5cag73TabWtrwhjH2ExPQ1W64O19Pq/ggHDnZqbAQNAjlru7ee3LQqCbXceP44Mf8R80H1iuvIfIHKdW0v4T4E04njZvDx8SSJK+kyZL5znOLeVFVRJwOLrg6waV3ea4nNYlKeaODxI+vmYLqXmAm18wNwgbwM5claeATpJ8wCjE25ULwiEBTDZrc+Qs959Diwc5rUrRxYarUk9EQ+5bzmcFcZcr9rl9cxIsDwmscMLACx7tC3zDj0kH9+ge2QXtpzMKX92lhTTRL3g++/jfMwuLETYYOS50dpJDPO7NPLG/RKKTYPAmcBcRmB9LnLukGSWPPkchL/wPONoSAUer+jmVTDs2VRNukwTuvWG1icHIXY656swLKbMkjktTpTkgQqZuLsZ5fYUxAgfN71Hq3pmMmbN/6+TQk/ku/LgKn9KLNwiPcQoBGClIY692YKtn
 Vqxb4oOI
 QAOVf4mNSXfgMzJ8gDGIWt9zy7tCV5FrBN6xJF7DddxaU24lFkss83ovEg7BqW9t3cLNZaO2YGgzzt/vh0OP5Q6EOZXQntgcW5l1TkhgqU3Ac60BOSb/ok1ByirGz+CYYD/7UbC+A+4Wa4p7YtKIicfTvLUhi7WuUw/ydrdNPvAo+d5pHGZN1ZEd/dAjhUgNHAM2FaNMFr44x4+FMC4lHKwlZbSIatWIrAQR0
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
index 37e2142be4f7d..eeac653e3f3bd 100644
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
index cd4bc22efa966..1853a969e1978 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1427,8 +1427,8 @@ int iommu_dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
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
index fa75e30700730..de34ee5903766 100644
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
index 9354fae3ae06f..f9970b0e527ed 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -755,7 +755,7 @@ dma_addr_t hmm_dma_map_pfn(struct device *dev, struct hmm_dma_map *map,
 		break;
 	case PCI_P2PDMA_MAP_BUS_ADDR:
 		pfns[idx] |= HMM_PFN_P2PDMA_BUS | HMM_PFN_DMA_MAPPED;
-		return pci_p2pdma_bus_addr_map(p2pdma_state, paddr);
+		return pci_p2pdma_bus_addr_map(p2pdma_state->mem, paddr);
 	default:
 		return DMA_MAPPING_ERROR;
 	}
-- 
2.50.1


