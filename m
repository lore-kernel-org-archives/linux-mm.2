Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81F72CCFA13
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 14:17:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDDDF8E000E; Thu,  6 Nov 2025 09:17:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB57E8E0002; Thu,  6 Nov 2025 09:17:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCBCF8E000E; Thu,  6 Nov 2025 09:17:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA8F48E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 09:17:18 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8564016075F
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 14:17:18 +0000 (UTC)
X-FDA: 84080384556.10.AF28D8A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id D359F4001B
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 14:17:16 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R9hpxrrn;
	spf=pass (imf27.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762438636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sac2gWwtS3qyo1lm5LRvirpkfA5AwBQv7rs+QevdvNc=;
	b=gMUphbI0wqLoaDRbf9XXk34YOM950E2KCCVZcCigHU3lzLccaimZDFgZx8FOMcmNa8JXwm
	BBParShauxzMCLIJVq81EypiLmTD5FvIS+R6s8IzPfAzJ5l1j0GGiy/Dxd9N/nl1v1O6UX
	BynhPJqpomsTPqsEbGLyKatH4Z8GfUw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R9hpxrrn;
	spf=pass (imf27.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762438636; a=rsa-sha256;
	cv=none;
	b=UiAlsQSxWo/5KURM26mgNiO+bMW3tiaiVCCRTI+FmIgkIOiUKCZ7GkU9kJTdXBo1hrMccb
	juq2iKF8g+bMHGgLK2vxG4qQfRm7jcJ6irVAS3FFtzngiIMFDSuTMEh9LaPOzWZK+dXBi7
	zemlF2i977Eu+uPfmX9WXaopWv3A6jY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4539C60232;
	Thu,  6 Nov 2025 14:17:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67465C19424;
	Thu,  6 Nov 2025 14:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762438636;
	bh=L8qqZS4yiGoy/yDtN7UUvNA+Wvt8X2u1F0Wzw5L9TQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R9hpxrrnZDPzLG8PEs8eK8wlTjBzyH2whMTaIdfsvA9PpD2lr32JS2LhGNuLS/T/5
	 HG9qQ+sVyXNxE6AY2d8wu/+6R2LMDsgahnTTJKsp1F3MuAwRZZNKlQhx4BheXUu3Sp
	 iLneJhqwECayFkn14U6TdGJvP4NzsiMyTdXaXvsn0V6qTEaGYghMhR3KThffImdAJu
	 LGOyVqTfVe8VH88FOlJ2JK3ZTRX8dSxCkUv/FVpsR6cTFbtAfa8REKHLYwQkxefoiv
	 NagQFkgZaW6pF7P9UOvceNwPkvTcELNYWCUrXoYUfu865Sv2GpHNFi3RPXxhTbzPk3
	 x5dF4fd+MSwYw==
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
Subject: [PATCH v7 02/11] PCI/P2PDMA: Simplify bus address mapping API
Date: Thu,  6 Nov 2025 16:16:47 +0200
Message-ID: <20251106-dmabuf-vfio-v7-2-2503bf390699@nvidia.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251106-dmabuf-vfio-v7-0-2503bf390699@nvidia.com>
References: <20251106-dmabuf-vfio-v7-0-2503bf390699@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-3ae27
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D359F4001B
X-Stat-Signature: 44ihm7u397fjnz8s6yzryxsic7pxkryb
X-Rspam-User: 
X-HE-Tag: 1762438636-148776
X-HE-Meta: U2FsdGVkX19MuCijDKL6C7v5+pgCgvP0IQ1hWf8HEW+E2SV+iTCVVI0CRoozgFfYfSQIwXU8oTBFRDeyFFD9nvXTwwKdcFIgiXY+6jKpTSCWnTS/SKGLyOdALfrLeICPeSWWUzeCixJDdcMUEKeVULLQfzUZZjVDxdysO+y/6aMGmdIHdm1UStkxFcKD1ys7J0pGS5lq/50wyHUDZecGwoht35NA41OqdmIBDMzV/LZhaxt4XIHCeNFIZR7mv1vSpo91/y/4yl0qp/pgFTFanG9PnnQVMgXZVK6MFa6kF6VUlSH0y/4XoKV+Jo0TaXyrWl/HmS2QLPPbws2quDvhx3DYep5PhjOs1eptYCEiry/JtA1rdWrvpDTPiqaA9PzYxsomTSVRP31iy7IGVzKqIf3NgV/Fv7dNgxOQGvcfWNMbtsaVzE6gAKt+dBoPwuH7UUToXzeGhOrLic7iM1Gc75R+5pOQE0D64K2vTLl4TEyWQ3aguhS+b6GlKrjYx20bsoR1rkrLvYTUZQSqiExiCWnmJOGMWZZdNIBKbbus7Rfv/8Qpe3UfFpvpeCICejfXrKcoyRNu1/UCEmhMbyd6O9Z8zVXEtUM7BNiIbj6pUo4cphXhw2/q3peA7ovrdgAh27rcU7+HWo77igVl2AuHSs3K8YYYgT4nec/64yElp0EJTedXLsETNhNJjpqBhjEK3XIHTEgjoPVUtH+cYjEEYPgUXWEx7X8Ua6aTpoPZva5xrkTVidcRBgiwlBEZbTygjXkfbUjaBaBDUn4LdYYmdPT1wAM7C6zNVYvbTipAMxI0IqGAdfcwGaPHxsj3wuWcGkMRVszdhiq1MTl9CodjfmtCvSjtNR7vIl6vuIPbvScktAnkwB7JteN1J1Dc4axlrahzjFe9Z3du8JTuZ3AUFh45ygz1SEFoGk4swyrLlSgJvc0cd0Qe3jbni+Ovgru0k6DPhAOaE0NZ+4DyQfu
 BJMWPgJg
 C8ZwHxKwuTfVjufAW/IGBJGCw7YDXQ0JzPWk6MDWlY/3pGsKbzsD7RZ69p/rbh4FiCCYOkBzSHC5gvbEq31zFpaxGo76muIcj/4Fc6+77/jkghSdMP2cMQiqABBQaZSl68+PBdI3O9U74X6ihC+VDIoDrZBRq1lA8yxq4tLaiYiUvNEfBpcDnX59Ycw==
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


