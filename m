Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFE65CF8577
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 09:29:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CFFA6B00AD; Thu, 20 Nov 2025 04:29:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A8306B00AE; Thu, 20 Nov 2025 04:29:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 196596B00AF; Thu, 20 Nov 2025 04:29:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 08DBD6B00AD
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:29:29 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BFCE31A0802
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:29:28 +0000 (UTC)
X-FDA: 84130462416.26.C3C6956
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1AB731A0004
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:29:26 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uO5bvReP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763630967; a=rsa-sha256;
	cv=none;
	b=y9mak1fFV/MgMED0TcNvC7bMXNFok8lff1F+KXyAYckU13kAYPzyOHmxoAr8WKKtAvADLr
	zRB375bcFhYr6y4/VZxadciRdmR99HKMI2sK6kOrovzljTB7aWLZdx+UaWoyZmAb9HB3Ol
	h9airMB3yMj6sNsZ9LzTECjkN1yUMtQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uO5bvReP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763630967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hjBFCuRKuZQASwYrBOmmqcBS1aN7fgK5fmRLPT5DewY=;
	b=mT/ek8XTaNS230JJ0iKas0r/Nc0jpN57k3X7a3VUPP9JLqLBdJAHhROsrf9ZToPm/y2Jm1
	TUES3aY9AW1sREmqAuol0zY0zQBdvAT+Uu0dZtnMzuPWccKAlyDGDUPzf7XByQCdAPpD4E
	uw2u7vh04iVHFsdETlV5hO80+pXj4Ng=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9E28B60149;
	Thu, 20 Nov 2025 09:29:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8EE2C116C6;
	Thu, 20 Nov 2025 09:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763630966;
	bh=LFSaVFGXyqZ1Ymg7hrWHvuDYaezafYJR42/4yF3AC6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uO5bvReP4vqmF17vp4umydSjwbMPlUEBwrr06wx2F06At0/D21mfaz/7x8ruRvX1v
	 3Uq6tUwzacon0WOtQFzpZGt0RcDpBSDOHYKNsLthJEbiBNaxV80Ir0z6pZR3p1qV7x
	 dYAq1ufKqD7WSUWjj2c+VaxFnLI5cuf1bYNHnTmdN6EBNBg1de5v+GG2XKWf9NcHYD
	 FAzZjictEB2q/huOTMy21YG403zsmAl6hCATZRJReXLB03B8swFxed7wkRnmWjPcT2
	 6mrCIzwnXTd2Cp6XwJSoeCi2stzNxUdFQ34bfMGdm8qh30x4qLAgam/sJ1wdVrEbvC
	 SupDOjG80fwmg==
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
Subject: [PATCH v9 11/11] vfio/nvgrace: Support get_dmabuf_phys
Date: Thu, 20 Nov 2025 11:28:30 +0200
Message-ID: <20251120-dmabuf-vfio-v9-11-d7f71607f371@nvidia.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251120-dmabuf-vfio-v9-0-d7f71607f371@nvidia.com>
References: <20251120-dmabuf-vfio-v9-0-d7f71607f371@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-a6db3
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1AB731A0004
X-Stat-Signature: wtqdsyjwt59w88kcu7xq7ofmzachg3ym
X-HE-Tag: 1763630966-476949
X-HE-Meta: U2FsdGVkX19zlsj0VBHr1N3KAwLiji0fA54aMgz3vluvi+JVC+9xM+tplnk0GoIiqjt3hImm7CNdoN+JuKNkUNmv05Zv0qJzR4mVLEf5il+dNLtMSjRuRmrEGgIYLmGPon+83zK6VPV/shUaCWwDCkUYd1J/QmdvaYoIpK4VHfzWtZlm68dg4UGgNRlr9l+Lr1713j8Z/icQCCzxzRAbPoBHcTA03rUigaf36jyGsQHIwI3pyofR810Ps8TQIBYEwNL7KCOloxHtL0LS6IbMwQ6U/Qe1XjkC3Y3VvkbwyRreiO2HbhlyFi33s5K31YrZgd3eNe2Zbu2C+J5C5nlEhwfeK2R+CYCAZcK6XEugtDmfDVnDpR99rbVae4lUcWkzjKleNranw5QLUjSjKjTkbQzQFWaq8eDFlW1dn9hPfvVOghaGoV9/mMhH7gSth2XJjjG9pvHjaFjf1jErlcqRgWaWwTqkf0l4v86xsutMQr2bo6w438La83r9WpuLNmy0Yq50Jj2XOGjD8oPyfxAYXe3bgTjhI/v5JcIXqj+gXZXRPJpBFETIOe8/KaFiXZ3enS/X5/9wuweviI+lPCrBiOTWIdD7bWaUqzjTB4ptfYKXQtKKYlWJNDUSFuwyJmDw2GUQI1sjGIuoubkAhUqb7ivSpbTEAxwYFW3UlzbBpDkeAE19xJlZ6CKPPIJVxOjgEyDtPJsPtNRjjkH1Ip2YAIBowBAAJpDS95XXh4LRU4aLizal3yXozv2STqhud9RUYE/41Odptxzk1k76cZiJZ1+ToMpNY04MkfXe7tBxp21nLf7LxWdEWcZVoJdOOXtGjwz3DuvhfvRio3YN7yl6qTODCtGbu/j8+qWt2+fOjjKY+F8iPUKfWQBZbxTp8GO/dT6y7Uo/ekqki2cvsKrzsBe/Wla1xBx5Wm59fEl69YS9cxv7Wdo76N8yepngJ68uhWpSocbrw5A9MKAM/qo
 K/yIssuc
 YUp788lQ11Tg+9oI21t8IAsVQ5LE8+s4wtSfWgpK8w97WQmDiPdccox4iOvouDn+lI0p+Qb1MsqYJLLPzx/VH1lpbuIK29zCbfCiUau7VeJ5C9hONSMqrymh1VLhDTNBaXAiTzVB/jaQkE1xfjf+LWagdrfHgeFiCaZCSvkzfF7Lz+mUj32zWVZH4MOVwwc/UOXppMkc8OJeAnP/czCO2/ZjNlJQLSFUgFSktzKj5nHVn2K4QMluRyyjM6jHfqsF6hflF63VjowP9DCBjKXtSn6TrTOFpTbbN0qfNFRl97uRFyQ8=
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
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Tested-by: Alex Mastro <amastro@fb.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 52 +++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index e346392b72f6..691e56944882 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -7,6 +7,7 @@
 #include <linux/vfio_pci_core.h>
 #include <linux/delay.h>
 #include <linux/jiffies.h>
+#include <linux/pci-p2pdma.h>
 
 /*
  * The device memory usable to the workloads running in the VM is cached
@@ -683,6 +684,50 @@ nvgrace_gpu_write(struct vfio_device *core_vdev,
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
+	struct mem_region *mem_region;
+
+	/* 
+	 * if (nvdev->resmem.memlength && region_index == RESMEM_REGION_INDEX) {
+	 * 	The P2P properties of the non-BAR memory is the same as the
+	 * 	BAR memory, so just use the provider for index 0. Someday
+	 * 	when CXL gets P2P support we could create CXLish providers
+	 * 	for the non-BAR memory.
+	 * } else if (region_index == USEMEM_REGION_INDEX) {
+	 * 	This is actually cachable memory and isn't treated as P2P in
+	 * 	the chip. For now we have no way to push cachable memory
+	 * 	through everything and the Grace HW doesn't care what caching
+	 * 	attribute is programmed into the SMMU. So use BAR 0.
+	 * }
+	 */
+	mem_region = nvgrace_gpu_memregion(region_index, nvdev);
+	if (mem_region) {
+		*provider = pcim_p2pdma_provider(pdev, 0);
+		if (!*provider)
+			return -EINVAL;
+		return vfio_pci_core_fill_phys_vec(phys_vec, dma_ranges,
+						   nr_ranges,
+						   mem_region->memphys,
+						   mem_region->memlength);
+	}
+
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
@@ -703,6 +748,10 @@ static const struct vfio_device_ops nvgrace_gpu_pci_ops = {
 	.detach_ioas	= vfio_iommufd_physical_detach_ioas,
 };
 
+static const struct vfio_pci_device_ops nvgrace_gpu_pci_dev_core_ops = {
+	.get_dmabuf_phys = vfio_pci_core_get_dmabuf_phys,
+};
+
 static const struct vfio_device_ops nvgrace_gpu_pci_core_ops = {
 	.name		= "nvgrace-gpu-vfio-pci-core",
 	.init		= vfio_pci_core_init_dev,
@@ -965,6 +1014,9 @@ static int nvgrace_gpu_probe(struct pci_dev *pdev,
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


