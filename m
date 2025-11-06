Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85775CCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 14:17:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E54098E0016; Thu,  6 Nov 2025 09:17:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2C2E8E0002; Thu,  6 Nov 2025 09:17:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D41CF8E0016; Thu,  6 Nov 2025 09:17:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BFBB78E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 09:17:48 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8CB595A844
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 14:17:48 +0000 (UTC)
X-FDA: 84080385816.05.CE56096
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id BE487180012
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 14:17:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qSfbrYle;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762438666; a=rsa-sha256;
	cv=none;
	b=BITplrp6UzC/TqJdqqws27CaUoH71O4+54JvSulx8j9HvJ3NYw0EvAleYWzeMYh7YpaiHt
	28asVgDyrsBiSjh/Sax253lfqITBigDN8B3vXZ8HrS3axhYbxIdQ8foMy4UivhXQj/mdEA
	R5fZ+ifSq+tDljusUOCyLmtSerw5tak=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qSfbrYle;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762438666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n9Pa915vF3b9nS6QG4sBnH5C+yyQGkIw/jI8QpkfHQA=;
	b=WEp1awiOnEn+3rTXfxs44aDJVkNO8d4uWNGSEqH0B+kseaEiXCaTS0EPb4/KR+c7KQu+nk
	mg6StbSTDEYBrvheMao8yFZ0dzOotSjVZ1SA9Rx75R/5rENl+vXRhjrOyTW9ORHviOXjEI
	Q3CNZ9kPMcTTbRoJul3fplqfzB+T4VE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4496F60232;
	Thu,  6 Nov 2025 14:17:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40CACC19423;
	Thu,  6 Nov 2025 14:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762438665;
	bh=Ysr30Sn5K0VIh/QChgAA+mxNzBcIIHvszbujsNqJTIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qSfbrYleS0pgRnWFVOVVECfkmFN3RhXDUr/qoNyfh3zGJM1uA2s4UV18MtwOik7ka
	 O4/CuPI1n6UVPro/r9Jyh/hs/0aO7rlsmwPkiXVCMLbBw0Bh9xwKkhVFBUffXCLwUj
	 5b8B6F2h7nhjNngQA8Rq0R9L5064vJnmjKlDemXUyy2OEQdvyHHjaucrxksP26KgZ1
	 rnT5Ep8vEinwOQ7uBWN57R2mEmsTM9V47wfGBgzEwiHvgH4i9Rv0SMKteBvBGq3dty
	 +GPOfSKQdiHbe2RpZM3uiqyZNrzu0UXvfyY38PqqqLZdXOqMkkKwxarubXjozUjpZ3
	 7AN5yEPxfo5Kg==
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
Subject: [PATCH v7 11/11] vfio/nvgrace: Support get_dmabuf_phys
Date: Thu,  6 Nov 2025 16:16:56 +0200
Message-ID: <20251106-dmabuf-vfio-v7-11-2503bf390699@nvidia.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251106-dmabuf-vfio-v7-0-2503bf390699@nvidia.com>
References: <20251106-dmabuf-vfio-v7-0-2503bf390699@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-3ae27
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BE487180012
X-Stat-Signature: mxguao5ni4ozonf4owpo8dmqiqkofhd4
X-Rspam-User: 
X-HE-Tag: 1762438666-963636
X-HE-Meta: U2FsdGVkX1+IImWkQNPp+3y2qjYzo3EtquHRRt8unHgevnU8o60KjhN7I74bV/9e9n13OZODDS1qwDZfKrGDxZYmv259wkzrm22OoQL6fMS8lhzj/TvHIg3w4bSHrSXz4tq/ALYclJz+uwRdRk326HwAwN+Pbc9PGYkfb2cADIWhWv58XBCRlZ0oan5EZDEQHmGsealMh+p6c4bsYhvMZgN6DhYcL5uZTOZyq/PM93THhHLoZTw5XK1A2wrAK5LYLzxNqeV0Td2EonVXtKrJCc1WKNrucT/ecf+zrDNgy4+dYSWdrGi5QJnkzAACVwMoSB3wZC858v/xNpVFagE+ROmx/hEV7fCD39ZRHCA3qebL7ZnaRjcpwtzLzhadcubMltaz0m4Lo787xPMUQPUH0pz005v4h9y3AiwZvxLUP15VAll2e2eFPWRw5szdy6dJWhMsD19bg0e0E1LBniRP9TC5oaH2OF6BKlkICWSrAvS0tiSu2aZgBIGQM82sIayL8ZyKml6FbyXnvuUHInOUtOnU1+VKjjVja3iJQPot7gQxYkEFSO02OBj43Zoww6Cicx09rdPgxLiui4DjswJrqHmRTlvLTDJaTAvYIgxOXlxdUhJa3QIGdNh59bjfnyL2VPZdX5SFl/JwZOjgKC5tVOPZiXbX5mx80T5hplbbwuvnGSyTeY+KuI9bo2Y1Dul7pK4GTrD+1p2pKgVAAbpssVdiSo1iIAxoWcDbiwi6eLU896KX/lR0nZKaT0xMlTkKevFhINUbd15xm1as+gagoU15VyqfMgJDMsEFWL4rLP9q6c0F+KfxK5SkZtIJNeimP6Y1LR1FdkqTiOe+Tctc2pEYyjZwgFB6dCoV39oosX9qk0l2yXJpi5NYEKM3e76UqjvIXKjaiiPPZNmAEQAXDKjTAodwVtkeD70Vpj1jL4z29Svauj6AbTtLw+YBaz10LjK0wHl/0Pf5dzFqykm
 c+HnJ6md
 QkIh7z0kX6BAZ4vMrND2fDzvjEVWujMtuqxuFkvrhH/YsVQOItlJkJKmpUAJVs58FwX/ZcucPwS/v8LarYlSHyK2SuQL6ZysnPuG93uJgcnwZC156XAXClaWIR+XJghyjieftifAYmc47tmMBFwOBRz3e4hTyDp2+LivCPhtHk4/x/8cFZ7neaaQWL96HWLljT5qj50t2rzOXZiPq8Vv+hATA3KNJTuvpfI7l1eP5JDlDhbXxvnTUyeTKFsn9HtMW1yq3ahA/hnlQ5YrxHpoTAlsTdw==
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
Tested-by: Alex Mastro <amastro@fb.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
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
2.51.1


