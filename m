Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCD39CCFA06
	for <linux-mm@archiver.kernel.org>; Sun,  2 Nov 2025 08:01:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25B878E000E; Sun,  2 Nov 2025 03:01:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 233088E0002; Sun,  2 Nov 2025 03:01:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 121DD8E000E; Sun,  2 Nov 2025 03:01:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EF95F8E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 03:01:51 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9732312BC99
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 08:01:51 +0000 (UTC)
X-FDA: 84064923222.15.0A5F947
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id F0DE68000C
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 08:01:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GZGPhL6i;
	spf=pass (imf02.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762070510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aZPHlHJzd9mlc6mCDbIQ4lr6plnBTGtCGLAoEEQ25pU=;
	b=l8qAmOMTpFPceKjAZEMXny0bZWiOWPfnazpvTJGBlC4hV1M85Ma+atfPLFhN6hM5dFdxz1
	51sxUCWk4yyhmH0H0seeJuzJ5JrJGXR+J7TARYx2baErsd64pPbHBbGdAEf6r911M+gq10
	6df69s6OKswnx6rlLfI571OeBU5nlzw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GZGPhL6i;
	spf=pass (imf02.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762070510; a=rsa-sha256;
	cv=none;
	b=CH2l6+9r5qJr2v65rcIZdEzROQnXEZcm0GdRjsaZ+53B6vU8EOeAdheyNxBgcnCrv4eJyL
	2nYQiXd0JRaxBunDAgrL7ylYqSq3JW6lJXt95o/Jy8cUNBgIibMCo6QI19Mn1QcEM5zSO2
	MI9bAoJsG3fpS6S83d0BmTTJc3IabT8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 241A644614;
	Sun,  2 Nov 2025 08:01:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F9C3C4CEFB;
	Sun,  2 Nov 2025 08:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762070509;
	bh=RFrF2BF/mdmOYmAY1LEiW1Xg5AXsI7VY+PN6Vhlf1FA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GZGPhL6i0x0jO1hLSYtlil/xgFxl9nFGcgApoOn8jnoJEgQnQ99mAe2AbALvZzTT9
	 X/FcwfzOoiCHw15iJPlw6JVu1vVVT8Ki389gmSy9GE6Jan3VvRF0Wy3Jc2sjPos6VA
	 gCF/u99+pMqxTvilzvunCIlzR68fNqoK8bYwVJNasbFPXoWISUsybYHzZCuQMEb1/I
	 RXL3JPxjUyR3+dCilijLBEQLVsqjUz1KDwwPAcEDyVa/iCsKLKkENnlfetsai/iwvJ
	 /c9XBl/T45VEgeqAvZ0mpsNSy73y6J83ebQ3D6x5nhhrfu8ZvY+u9lsfH1ho4e9gmK
	 c6IpsZisbgjRg==
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
Subject: [PATCH v6 11/11] vfio/nvgrace: Support get_dmabuf_phys
Date: Sun,  2 Nov 2025 10:00:59 +0200
Message-ID: <20251102-dmabuf-vfio-v6-11-d773cff0db9f@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251102-dmabuf-vfio-v6-0-d773cff0db9f@nvidia.com>
References: <20251102-dmabuf-vfio-v6-0-d773cff0db9f@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F0DE68000C
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: hbm3d49tq5cccfcc7h3a7icdf5e9jtxh
X-HE-Tag: 1762070509-910085
X-HE-Meta: U2FsdGVkX1942YzaiNBxzrxdd0fOj68IXWkBJT86KszdgvqfdEbswyhLASjinEhq3PAh1knnj88AecCCXWnvTjgnmRfMA65IPnMjs0ipPQHVf9Prd55qaN7cld/y1DfwwYq6TXqjU5gzbaGDarTyGxyJcQPcEbo/Zhi8IZjw6Jjky0EyJEbdTSU8vF8UwHSUGe1JjOpt9Ha31uUAF57MatgxPaQdRWNKk+EVT0dl7ulw9wIHmxIcH2jWktGt2b3BmT83nRIrDEtrDbFtt5a140estCUg47pCcFjiR4KBfQ+UlzrD66Vd5gQsSei4g+ITwmZikTUBep8H3MqeuDwMlbXRVegtsUAQc8OiQ5VV9SHwoYELyegIOYroGLYiD32xvpNZH9NB66EpEFUCTnzaS48dBnouTNnH3SMEz1gjYSzohD8SVzS0w6VI+SQ8v29/MYt6nNlR8PAnlGVNPIpQdyk6FVQSKb6q3udNtBqP0r5a4jIpqRF/maQRHwjOaCFbqG3eDySlXhaquUUDzFIWnNYCEmFHHTXCEDrq/sbSjXj82muGiNyQkbvdvMnH7DtOu99lAellZ7QeTaUjRjXNm25vmXAdcxIYQly0y0sOTZFes8x2pum5e2c4kxi8jorUCHmSKISF7m1+8/WQWAxfWV/jAVSEHTtBN8+wu0mCPH0d2tRdAKqVRCStG+M1c1I+fGVJVwnvp2lnjPFSr6OryJTODgWde97DcuW09daev9rdh16l/AxePtsFN2E7XQkbeSJM7Hy4FAjbQjZXbk5LbNeyJl/nX7USmNC9sQYls4scynaJyMqjnkVYCVV3vhuAMD6BBG/L4CAly4hRRXuf64VtMVxSxbY3txBbdEGqlVy7TziqTIdnlb8tyj5WQGVrJ4zgPsrBuZpZJBrPSGDZ8A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jason Gunthorpe <jgg@nvidia.com>

Call vfio_pci_core_fill_phys_vec() with the proper physical ranges for the
synthetic BAR 2 and BAR 4 regions. Otherwise use the normal flow based on
the PCI bar.

This demonstrates a DMABUF that follows the region info report to only
allow mapping parts of the region that are mmapable. Since the BAR is
power of two sized and the "CXL" region is just page aligned the there can
be a padding region at the end that is not mmaped or passed into the
DMABUF.

The "CXL" ranges that are remapped into BAR 2 and BAR 4 areas are not PCI
MMIO, they actually run over the CXL-like coherent interconnect and for
the purposes of DMA behave identically to DRAM. We don't try to model this
distinction between true PCI BAR memory that takes a real PCI path and the
"CXL" memory that takes a different path in the p2p framework for now.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 56 +++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index e346392b72f6..7d7ab2c84018 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -7,6 +7,7 @@
 #include <linux/vfio_pci_core.h>
 #include <linux/delay.h>
 #include <linux/jiffies.h>
+#include <linux/pci-p2pdma.h>
 
 /*
  * The device memory usable to the workloads running in the VM is cached
@@ -683,6 +684,54 @@ nvgrace_gpu_write(struct vfio_device *core_vdev,
 	return vfio_pci_core_write(core_vdev, buf, count, ppos);
 }
 
+static int nvgrace_get_dmabuf_phys(struct vfio_pci_core_device *core_vdev,
+				   struct p2pdma_provider **provider,
+				   unsigned int region_index,
+				   struct dma_buf_phys_vec *phys_vec,
+				   struct vfio_region_dma_range *dma_ranges,
+				   size_t nr_ranges)
+{
+	struct nvgrace_gpu_pci_core_device *nvdev = container_of(
+		core_vdev, struct nvgrace_gpu_pci_core_device, core_device);
+	struct pci_dev *pdev = core_vdev->pdev;
+
+	if (nvdev->resmem.memlength && region_index == RESMEM_REGION_INDEX) {
+		/*
+		 * The P2P properties of the non-BAR memory is the same as the
+		 * BAR memory, so just use the provider for index 0. Someday
+		 * when CXL gets P2P support we could create CXLish providers
+		 * for the non-BAR memory.
+		 */
+		*provider = pcim_p2pdma_provider(pdev, 0);
+		if (!*provider)
+			return -EINVAL;
+		return vfio_pci_core_fill_phys_vec(phys_vec, dma_ranges,
+						   nr_ranges,
+						   nvdev->resmem.memphys,
+						   nvdev->resmem.memlength);
+	} else if (region_index == USEMEM_REGION_INDEX) {
+		/*
+		 * This is actually cachable memory and isn't treated as P2P in
+		 * the chip. For now we have no way to push cachable memory
+		 * through everything and the Grace HW doesn't care what caching
+		 * attribute is programmed into the SMMU. So use BAR 0.
+		 */
+		*provider = pcim_p2pdma_provider(pdev, 0);
+		if (!*provider)
+			return -EINVAL;
+		return vfio_pci_core_fill_phys_vec(phys_vec, dma_ranges,
+						   nr_ranges,
+						   nvdev->usemem.memphys,
+						   nvdev->usemem.memlength);
+	}
+	return vfio_pci_core_get_dmabuf_phys(core_vdev, provider, region_index,
+					     phys_vec, dma_ranges, nr_ranges);
+}
+
+static const struct vfio_pci_device_ops nvgrace_gpu_pci_dev_ops = {
+	.get_dmabuf_phys = nvgrace_get_dmabuf_phys,
+};
+
 static const struct vfio_device_ops nvgrace_gpu_pci_ops = {
 	.name		= "nvgrace-gpu-vfio-pci",
 	.init		= vfio_pci_core_init_dev,
@@ -703,6 +752,10 @@ static const struct vfio_device_ops nvgrace_gpu_pci_ops = {
 	.detach_ioas	= vfio_iommufd_physical_detach_ioas,
 };
 
+static const struct vfio_pci_device_ops nvgrace_gpu_pci_dev_core_ops = {
+	.get_dmabuf_phys = vfio_pci_core_get_dmabuf_phys,
+};
+
 static const struct vfio_device_ops nvgrace_gpu_pci_core_ops = {
 	.name		= "nvgrace-gpu-vfio-pci-core",
 	.init		= vfio_pci_core_init_dev,
@@ -965,6 +1018,9 @@ static int nvgrace_gpu_probe(struct pci_dev *pdev,
 						    memphys, memlength);
 		if (ret)
 			goto out_put_vdev;
+		nvdev->core_device.pci_ops = &nvgrace_gpu_pci_dev_ops;
+	} else {
+		nvdev->core_device.pci_ops = &nvgrace_gpu_pci_dev_core_ops;
 	}
 
 	ret = vfio_pci_core_register_device(&nvdev->core_device);

-- 
2.51.0


