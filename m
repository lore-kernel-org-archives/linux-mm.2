Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D026DCCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 09:58:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 328738E0015; Tue, 11 Nov 2025 04:58:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FFB58E0002; Tue, 11 Nov 2025 04:58:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23D508E0015; Tue, 11 Nov 2025 04:58:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 132D78E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 04:58:10 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AF13B8772B
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:58:09 +0000 (UTC)
X-FDA: 84097875498.04.0B7723A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 104AC100003
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:58:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PpdOFyIy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762855087; a=rsa-sha256;
	cv=none;
	b=opvwmn7aHhNTMoCqQtFMBAVjG+rA96Npt2/r9OTlVuuVuZpyo7R79hw00pGbuoq3vpvjiy
	I0jj6UI0ftAIzk5F5/k7TKI5VvWKD1OGVTE87fVx/2oiNqpBH20k6ElJ3OevGT4qknDy9y
	MNryk2Us0jkVQYP6EfeLl8uNp6YoLCo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PpdOFyIy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762855087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sac2gWwtS3qyo1lm5LRvirpkfA5AwBQv7rs+QevdvNc=;
	b=w/8+7Ygz9qnz5oFazAaxVud3Mnpb5wbQgKnqMpEleF059j+V/VeakxvGIFlIw8XwOBZyxK
	k68hroZNxb6foIE6DpVNCYjxBccoytUBUrBAeQktAXK09YWyQVrMJWLyrUSXq8wJCniqJO
	GlUuaevNJy2GU8zcwwNGYkuj1XJrsgM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E5ED61907;
	Tue, 11 Nov 2025 09:58:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF5EC116B1;
	Tue, 11 Nov 2025 09:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762855086;
	bh=L8qqZS4yiGoy/yDtN7UUvNA+Wvt8X2u1F0Wzw5L9TQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PpdOFyIyspm59Mu6z2SrIhsLr/8KoxMfJojwN+8SJyOu4SsAGzqCI/Fk2iEo+DYV8
	 HbrJ/U99lYXD5mNuqUki7hVfc1CQDo8WHv/NG0mVX1qdcyK3bG3dRscWK14oCtS/YL
	 W5T8daUVkogQ9DoozSeZTDUpIhX14N5GoZS0Wy8zKEFqPQ4QJT8AaoxqE9pHqN1eVk
	 oU03dfaH/GtMoHYwo4vlbVZ2vyg8CYuuphncIDLOg3vMWJSTwcwBKvYzhEjDwysCAO
	 j+GycmCGIoQLoCalsxPBxTotXfLB2s20KmZceg0TKBVhyqtFvH2uFQsvMa8+U3MPum
	 4g/ObhXd6Yjzg==
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
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>
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
	linux-hardening@vger.kernel.org,
	Alex Mastro <amastro@fb.com>,
	Nicolin Chen <nicolinc@nvidia.com>
Subject: [PATCH v8 02/11] PCI/P2PDMA: Simplify bus address mapping API
Date: Tue, 11 Nov 2025 11:57:44 +0200
Message-ID: <20251111-dmabuf-vfio-v8-2-fd9aa5df478f@nvidia.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-3ae27
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 104AC100003
X-Stat-Signature: xkj41dbyid5ttgwd9ucxidwhszhjc1j6
X-HE-Tag: 1762855086-852190
X-HE-Meta: U2FsdGVkX1+LUuKDSb+dna01SFu3rUNvm57MINvyQGzraDFF5hJ05bpbBYmp8b4IocsjBegcHXiXGTJDrioQrhwHWn4ml5wMstZe+eh2T2o3S3/vfsfD6sNWH1yerDNILujNh+8pjM5b1zwBMeATrFAJAgmz6spZ0zchiX+4ykz8EmEWuyu5iiGhzNssC6P5UkbtvNdhJMsTEiFacLdO6erNCDeE/5FUVjI+0Gm8IFdM3x6AOOGr0G52ajUWTkA4CfAAgb9CBr/7Q0af8mEfALADgGR2iTTGnCg/GuZON8Ubt2zASeLW9fHZ2vgez+WT+3sz2pXIFixsZQNggO9qDTG7Q6cInFoGpPSVhuYmQ/Xs/ZrivvIerT8WaP5yjGzOpgDXkzrXbVkqDfurw9OCgagXQUSy4q8NvAmtbf9jVuZj79NOUZBMmhLdUVpdapfr1qe3WtY/SD08rSxGnG3HF06/W/IARiIc745TQNXw5BCjRXN6TljyL20/aB9eq3U8a5b7U+2aQ4BVHteUK1WFjVV4ve9xf5JFC3zUHV9DcebpGVZYBTUNd1bQHcIyA2AQNJBwUhW3e6FVukoaPPuHA8FYLFeUZMZe0FsNpmrbzW1RW1Du1IURq3E0fQuy5duIOyK1o4uYHEwnRb4/AN0L4zXbfyOBsXqj7sCf3cpVrKiLWa12/TRcqrhwnMrf8QWgaFY05FwVC2V8T8cyvarDD+d6pdqOGvfnl0njhACKNkY+YlFBcPNJRRHSld83S8jbqs8/ebZYgv2sxEIEXrJ5sZBbU2hZwYkfEzyeb5NcTVDEmI8cRj3SDniyx0G6190aE6cqa2OgqoT/cN+f8fWZYQt9cXwa8lpy5mMfdbLYjopys8V4kVj3GT14Pt73DPQMPskdU3REPZ4N4fWNE84hyUpviz6vUBoB6fZVOIwar/pqqC7Dd6rrh/iTTQorSFtBFZHJy39MHvJcx9SbUMh
 YlJGdwo6
 th3P0JL2dLNrpsW+uiTlNrokOyDQ4KngznfLS//85zyk/Jl+WKnz1zE9wFk/1aQtN0YAUVQitvJ0KxATScqSQFAnaBAwhHVm7CQcAekY+MhY6TX7oIi51uJnFSy4v2Ek0dHow/FBgei3h6XvQurHpYMmGVGTz8PkQyk/ydeZh+xuvRxtp7NnZapxVsKQA1UKpZztT375t60Q5JrGhaOj19n/eiAcQFK33bjEJbV2oCt+UuOp4ltEoXpepQSHt3n7GQqVxJDFvF/EEYHryR3165a4hQBNf/lKWj1qWcQNtzp+yueeHLZBS6Bb1ZjLYxVMqYaqsSLO11KEtlrV9gPUMFTHDDg==
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

Tested-by: Alex Mastro <amastro@fb.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
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
2.51.1


