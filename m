Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D6FEC87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 13:01:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E5DB6B00A3; Mon,  4 Aug 2025 09:01:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26F6A6B00C6; Mon,  4 Aug 2025 09:01:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 136D66B00C7; Mon,  4 Aug 2025 09:01:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EEB066B00A3
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 09:01:08 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C0D77134FE9
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 13:01:08 +0000 (UTC)
X-FDA: 83739085416.27.F173F96
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf21.hostedemail.com (Postfix) with ESMTP id E9BAC1C000D
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 13:01:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bWZsoudz;
	spf=pass (imf21.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754312467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pHRzV0nZhDRwAZX/h0iXaxSURv3goGztaYfIObze8wQ=;
	b=b3tTXfFmV0uJ2bq5giFwPhyrDFwdlkT+mzeIZLNYskNaCMED0/DMjznGX0ASbJkp4LQhgO
	MjzlAjuHH60YCrOK8TYE6OkaHYbVovXs85jqq85tLgZr585A3WwxmpD/dANSHTRrxAlkRz
	T2vDTzHSQ2usVLJDDDus73d8O9XDslg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bWZsoudz;
	spf=pass (imf21.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754312467; a=rsa-sha256;
	cv=none;
	b=j3duN9Tbx9TxVmjrNlCRR2YQULWYjgBgiyr6CJc3ddPdcwZbWLLnKaB4tZxzpjZXbvOmLP
	FIZBos0nSCbe4fmtNx59jOilIBElpwU5B0xR+kPOwf1E7rBO9SQNhV1sYeQHrC4EbMKVZ5
	qw/rXgt1UiDS67ANOUTvq6xvHKfJvQk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id E3BD05C5F99;
	Mon,  4 Aug 2025 13:01:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B19C2C4CEF8;
	Mon,  4 Aug 2025 13:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754312465;
	bh=8qxmxdh9Tl1pid/pFVwGchh9YQBVRkyxV5t2LJjeK0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bWZsoudzAzvO8pANyunPUzEQJJpTb4SI9lnyweA+J2BaiCRFA+yvJ9L2XvETLSzoj
	 5Ynx8IGcsYZdCNO/cxfuBj1RSztqX+Z8uC2m6fd9z+YbS3bWcmM59QFZligyPQ2ykV
	 Greycy0RMIuPVBkBZewbp1I5IzLOnDP5prFLmdEKPWbt2/5QEzBJc0mrXlSN4FYa1r
	 s0qmCa2rlJfr/+BfdpfAFoTyH/uGWTuc1xbv5zPZFjZnOxKVg+Eupv3qSy7v0A6kUb
	 w+LsFFEAYW5MYenbPxh9zRS/f8tQ26SkRNuuLInGtN1Z/+/xZV8RwpkjDwLLGkZ8qB
	 el8r5GE0b0y0w==
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Christoph Hellwig <hch@lst.de>,
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
Subject: [PATCH v1 03/10] PCI/P2PDMA: Simplify bus address mapping API
Date: Mon,  4 Aug 2025 16:00:38 +0300
Message-ID: <87064f6a9ae9617fb0665c201e4643cc430c3779.1754311439.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1754311439.git.leon@kernel.org>
References: <cover.1754311439.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: amtwnbk8umyoa9xks3g76kyw88yom895
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E9BAC1C000D
X-Rspam-User: 
X-HE-Tag: 1754312466-37431
X-HE-Meta: U2FsdGVkX1+sCmggf8r6ByZEur0Cqf9jBTYHfxqjjsHa88SNb1KzuOaUKMFw/uQhsIOBPNM/xG65hoJaH63pdjiAI5qmJ+UAybJrr1Z+yHPVr81I/RBxf9o7hDg+UUsw5HYxq+4h1sJB8SM5E74a/XoIj9EGrolU0dJltx/l3r8IbnrT3cSM+Q1N9VVtud5Q2z0K6noJSwzossdWMUPnlA7p7Ktzs4aD86dqGIF1DlGeqqZHNcZXao7tF6bwipqOKHsEiox/2uc+dp0w+cSt3bDj6I8t+CxDrVLCPYjLpBPA8BKqDHJsbJhaDaa30txE6OV22muxGHauNQDv+Xtam7aunGCNVDFGdmbTPX/Tc+XEcvqKMXL6grbBnCjaptqJ/m5TK9xAlz+z4ey35Slj0JQ4TNTlxRC6TLGynmFLqMIqjm0EoOXJLTMWOPcDkQ9KEs/lQbKjbj74aRcbJIo+xewMXt7Dr2MS05VIgLPtg3DMQKKzRXBHCYe1iRJVg808cMT06KXMT/3bgSZkwizLPHjijCIgTqOtWTW6ItjXDYLEXHzMj8Fr7SXDiVrK4hUtwTrQd7H22dVHHm5y5NAUWrsMXdF4DyH0iTDTrZjBmQFBYTCz8esnMYdqK89uYghbAdgwWo4Otnles2Vhrb4gNWAJd7Fx9lXwUOpJvfO/4hiqI4uDnBV17tK2nRNXX+LROnEwBBMTx1uvwkWtkn4BsKDCAnIXrtlrwE7vnqzMc8Xla/poEHtCh3aVrR+yHnMpr3jhCvqQlh+s91hP9LNgfDjpgc/ifZw87F+y+sLrpXNpaMc5CisA657tEh+sOmY88LAfrD68YpgKt0IBQNSdduFPTM5jjpoKHnE5wfJzlm8KIKX22tpfhp9hJChpB4kHZDNazHe6l9w19d9zAeUWzco8UQTPJw7/AoNGaxpoZJp/HIKPAl2K9z8o6zi+KeJyIHQ7O9gOC4Gg2qG45Fz
 TBe7EbqJ
 0Cxb+HW8OkM+G3dtuvcxJygcjX9gPZt+fLRqFNlh5YYA0/JwyztSdR+40w8nbQiP8cPPvgevYNGJxWblIGX7AguZSK7wZkfeTPa3lzu1lAX4U3seypu0kF8YLbwVfxwGpX+QF4rehIaegwRRWP6tvD5FD6VtD/j2/3CfnvhFHH5dm9mx2fmCQFZcbJf7qjBaViXlGaiQNRiCaSD/35vQdTBt/Ja6iwnwBFU8S+ExBPL8r3nxMUK/OW5pYYjUiJGhmXrilRA4ZDOSFh3o=
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
index 69f85209be7ab..7c1c25ffb804d 100644
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
2.50.1


