Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57E0DCCD18D
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 15:26:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B31E88E0057; Mon, 13 Oct 2025 11:26:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B09658E004E; Mon, 13 Oct 2025 11:26:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1EDC8E0057; Mon, 13 Oct 2025 11:26:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8E4158E004E
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 11:26:46 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4F29759211
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 15:26:46 +0000 (UTC)
X-FDA: 83993468412.08.6721309
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id B64B48000A
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 15:26:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IRks+DWi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760369204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TOrN9K6iU1nxK579VRuWQlHXICVbJam4V57fmeGQ33E=;
	b=BnAM33VDDfyOjiTFk3hpMwc+Lm9Ra2IPBPynPMN1Mhuu8HgX18txlxop2V0UzxhGO+DdAB
	RMGfiw3uTLGkmAhjkKWjqhzwKhEn/fpM9neukvtQkQNGxGWX1bmewYzPhh/+/PL7jz7u6C
	0G8CEG8m1boR3fOm4NKxx+sm5JD37aw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IRks+DWi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760369204; a=rsa-sha256;
	cv=none;
	b=I1dVLChRXFtQxs7/Wnqv5HlAvMx9Yl26HgpmmRmy51JGuGMA7BH7ICfOM1ZJpGsMiGWyea
	TPXc/uYlBR6LpQ5AFV2oEoSCxHX8Wqr1UyJFQuijY3cWOYAAXVCGJfb7/yzsba+8q6MEis
	KAUBP4nlSE7Ldmhtqu4mefnn1LlwIDo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C9C9861DF2;
	Mon, 13 Oct 2025 15:26:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5C88C4CEE7;
	Mon, 13 Oct 2025 15:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760369203;
	bh=/sqGzUlY70Md3kn/uqwkAy7zvckyzzhf3i23p85lfsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IRks+DWi1WAtZfZO4IdGAt75DsITSMamDbEAFdfZYPrtzEgNBjUnPFlFQdVlW2eme
	 bCe5WYUJahxlCezrgNA/V97lguT2tGgDGex42ykf7U8294Yuo+cPUh07NHKpS8eOvq
	 qz2awlV1qvXCCo7UVeewt3Sn6yV9nlx4UHHFNw5+M2nWz5h37jrlcFm+wwumAiJgmE
	 aRDsEH4O/nJZs0YKTzRkFNHX2Jo3jUhIgtI/lUiGINgbX4J+UnD1sGivrOYVCnsMAz
	 2JA0D7zRhqi2g4AQ14sYToHYl4vYxJDocUvA9r+b34jXBBMx3+uOkreQ/+cfbh8umo
	 xy5t3Z2knqK4w==
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
Subject: [PATCH v5 2/9] PCI/P2PDMA: Simplify bus address mapping API
Date: Mon, 13 Oct 2025 18:26:04 +0300
Message-ID: <a228e188e45f40f0b4e754d37f5ea7f9d92bd0c2.1760368250.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1760368250.git.leon@kernel.org>
References: <cover.1760368250.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B64B48000A
X-Rspamd-Server: rspam03
X-Stat-Signature: g5iiny498bj7wsfroofwz4uiigjbqkfa
X-HE-Tag: 1760369204-365720
X-HE-Meta: U2FsdGVkX1+UszWcfHyNdvM33eMuyhc4L9ZthhHOq0REq9SFSrWUNTAc7Ub4A+k+CJjokAMc5X+CJPHARybSvcB8hU5tmB53YnM/ItyrrSOlSp2z5kI8xU5YyTOi44PvLmMyQ68NtCOJ71T0BchlN/zu5Fnpi106PpVolmPlCWzz/WD1A+AC7xM9r/HnSBcyqKTmqx9CI0CrQgGpGGXYMHUdnfcCI4zkMxaQH4zPXucv9dPyFG5Ldc/7N7ZG5YnrYNQ3kqeKdxPd5dM1I49KJrrTbqQDNIC9nwfQoHzQ64q5QKeqcvt2GvLYC9FgwYC2cj3BaGrlvD9ErpEMzLHtihS1BWY8ByUB7ZrcSj25O+K8aBOuDtVUiBcps8FLMDsuBDhq2vJo85gLOlgLQ9Jagys1IKfP9ADe/DwHIlCZxIK6u78dz3KfJ6xVOaswoDr/dQI44I0jx99uJCRjjLVBVK3BGxMq4SrjTNIR0fJNkpmnOqLoTyEAjx2H2HI8FtY7jHHrs2qZfjVkKX/FX7aRJ5vZ51Xft03BiTBPYoSPAFjopplnE22uzpciY7T9EuF5X2rHLu2Jr5GCC6qqVuKI6U1SyCSBlMOYEaVeeiT5upOCVOHlY8fBrOrhyTFREPnMcU+cbA6tMXTkK758Lm+csWUw6F3tbanerj6A6W1T4O10f1Ockgvb9AD40C3rDh64CZAtlcXDa3/H5lGrqfQfR31j189jNVQTNwZ0ALogzWohSPSqAvg1rWNfG1bsu3bKl5L2CmGsrPsOQOHtzTVA7aqmo2XKCU+DkAZd2Nj19e6/bW3HAJ67Ijqqj5VzxSJaIxof17HVXhnbZPkD5bz3qjVWOp2WZZ9z5HKmzDLUXwAcfh2DO2+AzDTYiTm3JP3ugsjbNtz3nNECGhoT6pNBgZm7fPG5R/mu8Q6Pz9YwS//G/9G2bHsZHdAH+Ud9JIiavlMvdgMeI8mwkHI7Y6Z
 p01g0MBK
 69TJ2pN51oBN7lR+xU4Qv9N0ZH7uDw4ARyOxkk0GmpOYNaMV5qRJNNozTLzUq4eLA1KlbzrDU4d4MmJrSq26IlZ4imksJoola2fedU/OUkzjauEDRbu+Jpg/MRj5FUdy2Jg81wpTyuUjAQd/oqosfBtXIK/P/wwGfaIjGw0jl5md5z0uRX0yg4bnS7lKe7toOos2uFJ06emc4lgJMqYtEwYd/wYCXkbvt4WguEPWbTTiPO1MUCFE/zPBqoVUU+Olh9SHldKDZDfuW1Cg=
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
index 9495b78b6fd3..badef1d925b2 100644
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


