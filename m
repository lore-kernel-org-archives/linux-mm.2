Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE62CCF8575
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 09:28:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16F136B00A0; Thu, 20 Nov 2025 04:28:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 120176B00A1; Thu, 20 Nov 2025 04:28:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F28F56B00A2; Thu, 20 Nov 2025 04:28:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DEEC46B00A0
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:28:54 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9250612F9E1
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:28:54 +0000 (UTC)
X-FDA: 84130460988.29.388ED14
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id C12DE180009
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:28:52 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R+Y1NRHn;
	spf=pass (imf16.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763630932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sac2gWwtS3qyo1lm5LRvirpkfA5AwBQv7rs+QevdvNc=;
	b=0ftukvISjTONtIA7E/+sccyyCt1gHd4OV2p0Vq4z6C4/xdH+JG0Fi7Cxhd3PnR3aCOM3/g
	z7n+4QD8qj7QT4WsDj5/laPJvRLxzrXEy/N3Mmd70wM3yEoOW4L9uTzEwk9vYr66trv6WQ
	eY+KNaOxzqnzGK5h3wV7BH4q8Lel8u4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R+Y1NRHn;
	spf=pass (imf16.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763630932; a=rsa-sha256;
	cv=none;
	b=CgguliPbJxcFwjYy7F1ELr0BQ+mzDoDUwM4buB4WQNKYISZFTHcJeFs0wwVZ9EQbCbqZUV
	TzHS0OaifKFedCbGLCG0qZ9bjmhuXZMSUSs+HFDWFfTdejLb0OCZD18xq715EC5hCqtAjz
	pkA/rY/d21F/g2NdvIbGC77CEwnUzDM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C973444323;
	Thu, 20 Nov 2025 09:28:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC4ABC4CEF1;
	Thu, 20 Nov 2025 09:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763630931;
	bh=L8qqZS4yiGoy/yDtN7UUvNA+Wvt8X2u1F0Wzw5L9TQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R+Y1NRHnGPLyO/BFtxhfd9k3Q7K9qbr7g4K0c2byYN9E4lhULnlGv95N6cDj56WFY
	 yIbxqo9NA0lfwRg7XEcbuwoqzHUs9B5wBFs1djxjejjeWvFeMWFfw/WXvxeibmEjRB
	 Mng8OQnkLxwHQGhdLV8pVDsTV1OqQhrxvA3Od8Fi4HE7ERxrEqp6YKme/huMT4Ir8T
	 EW1FJLO0DWlXRo0oSZqetr47MDHSzw0vn/uAIZuE/zlSTAMzTABLDfnH8ZMOmhSAD4
	 faqkHxmKFwMlP0O4juar1wPhNK0g/du2RnUL7BU+Sjw2dI5c5yzlL65qwyi+XhtkgK
	 OR9SsBocykGbw==
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
Subject: [PATCH v9 02/11] PCI/P2PDMA: Simplify bus address mapping API
Date: Thu, 20 Nov 2025 11:28:21 +0200
Message-ID: <20251120-dmabuf-vfio-v9-2-d7f71607f371@nvidia.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251120-dmabuf-vfio-v9-0-d7f71607f371@nvidia.com>
References: <20251120-dmabuf-vfio-v9-0-d7f71607f371@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-a6db3
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C12DE180009
X-Stat-Signature: iurxz3fmo1343xmy8sa4jqgqkqrj53mb
X-Rspam-User: 
X-HE-Tag: 1763630932-913260
X-HE-Meta: U2FsdGVkX19nKncyDpbw6CSC1ukhAQK8rnw5TeTJHM4GVWOgVcx1BpNoaPqq3I3OgIIGkgj981cQ4SJX7894XvB/5jGHTh0r7Xyesq9AJOTREN3lz+K1gIwPHVaYazyTTH1iypGI6AjWu4cqqN8PHHMXLvSvByxWN+T9z3wupcGKL2sI9KuJDhhUlmWKun3ohICHGzzPWVylD7z1/lNVW0FqSIR4clGCXyou4Ju0NzWcF2sKeFfnD845sXXAXa+FqstghfxCO/Bn7kCrgebIw6TrAhoI/uomBEFVtQXqHeGSqmewzKfT4y/OeajPrspuoX8xkDW2nZvxvplOlP7IxcQD3fafWgKEOBJsvFrGP3XdELZ+nfEoB5jJ06l9nEgXLKhH72h9sdNPONhJakAw123vL9Aa9ZP43dr6hZlz5F2QG2PdkRq6Snqba8cvyhBkWqZsn1cE+42HCAyYi9UD8mVp3W8TjQecTEVUYwYw2kCJFguXucp6s4zFQOG8KRki03h+fZVbT7XJtRS7keEkYSaI/M+wWCuLIjVd+ED88/++AyB+TGdovRmrV/MAwbm8qtHamUTZbk32u9dXVvb7J82VLgFGWefiUVVcxZiOd3uvgoqXHR7Tbx9mGJOJ/0JTL9YqUVX6F7f7EPbFB9HcG5zVMdjm4Rw/DjewFB80INffjZEmyjLUJg8UV2fnKAnlewLiDY1+a+Mdw7Mh+XvPhN9CQCbH7qy47iWFEIiVGG8vRXIdfOODzuMWKbVCWPsmNmlAE+/yRo8QWT+cdoEs0Vqqse8cNRzqvVObUZwL93PGVxhL01YvPQpyZaub9emKhLpeT67jE4HwZ6Ssgnua8ixOO40EDzBAcKC3OQg5CbHP9jFPe4GDp3dOe9qdAn94qclJNKYUU8HsmcVajJ1BuOBA706tsIBDxk8MPOCkpjvbpLmODo0FbyyBNXKhdZ2k4nnUe0hL2/K0i2K3jwn
 minb0eyi
 CaDsAolD7JAMo9+YULchnXGy1owBsiPJntoTN9Md33tci6JrjnwluGE3JLk/3FXFL0qaUfFC9TlSWy+1FS0VR2t5lrxIvbXPyny0Zd7nFw/IOR50W/Wl4nZTCg0VxOY6pwARduBvPvPWeohXVn0N6npKfarBhATzGkBsEY0EEaBizSVtuH2CjA/mTFMUVFX8ykSHX
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


