Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0981CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 09:58:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43B0D8E001F; Tue, 11 Nov 2025 04:58:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4129E8E0002; Tue, 11 Nov 2025 04:58:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34FC58E001F; Tue, 11 Nov 2025 04:58:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 24A1F8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 04:58:43 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E0AD51A04C6
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:58:42 +0000 (UTC)
X-FDA: 84097876884.19.4A4FC59
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1AA1D1A0007
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:58:40 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c6TO75Hg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762855121; a=rsa-sha256;
	cv=none;
	b=iR//NxEMv0vqFcJ8XMTrBenpk29t+5fOysbZp7KKZVPXmjud7omBL5e2USS9LlNs/TKyz8
	cxG58CsuPk5+63gBJBQAJ42bZPyLmv5x2J8cJ4Utc/yiiY8lilEB4BQdS6lq6COeSyyann
	fWSxze6uwDwTYjxfja2BSxQHbOlFfbw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c6TO75Hg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762855121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=edoM04lxFLS5YIUroKNZUCgyhcp7vpL+uaDpOnzrNsE=;
	b=UXvsVvw2sRcrNAhanfcHRbtvsSw7OqUH9DrKYuTsFJtJQAwoAk4o38x9P9YWwfmVRF0oeC
	VscdBDri1OlVkdczxMabwcNUilN6ceq1AHzOg0HFhyVkwApnQRIliOjuTkX4DZ/KVhZAAg
	QLBlYLjsbWKIMQTMLLdCx0LQkv04Bg8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C1A14070A;
	Tue, 11 Nov 2025 09:58:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60293C4CEF7;
	Tue, 11 Nov 2025 09:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762855120;
	bh=hGmajxlDJlAingg+sMFEgHzEUxbqZIX0LckFEalkMa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c6TO75HgWBSedoFSI6DBHfNuMauD9JTPQMXcQSJH2P/6QVP4ahaVtGzBdjTDsgiOU
	 yfE0ZeELUXBvHWYn9hhbIXs5gN3510BOQOdtk/STs0fDP18MtSqvpxFddK1MoihHFN
	 jBVi1l5H29Z6YcV0gPfKQnXpdoY58b49TosuqUBZOjM87VUh/Ak0C5iL/z/mAB56X5
	 q/g9Iv0V78+XUmI1umdda8TmtcbjzKX4OshpgPVmyyQX9x37/AYmGROapgj8+gpoVC
	 wfiNIofMGf2xKcCaN925rYF3KO976nEo74zQqyLyBCUPRhtLsDRzd4Umv7hXaCIQc/
	 F+wCk0MrQBLXw==
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
Subject: [PATCH v8 11/11] vfio/nvgrace: Support get_dmabuf_phys
Date: Tue, 11 Nov 2025 11:57:53 +0200
Message-ID: <20251111-dmabuf-vfio-v8-11-fd9aa5df478f@nvidia.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-3ae27
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1AA1D1A0007
X-Stat-Signature: nb5wtqakzgotsz3t7cpfunkchp5nktqw
X-HE-Tag: 1762855120-172356
X-HE-Meta: U2FsdGVkX18LFLJjaVMB2YED6eOwZFGaLJjfOMe5G9lo+wT9Mv9vvgQflQBDDqENIAGXEsC7etSqDVVVJxALA8XQzjcN3c1PYe5SIUCjvxmNP6GC4WjRh1CFU3MxKGoC7VyI++2DBRHx6xbz8DZEjLEhmHb9CrcJVfB523BE9eBd6blj4mbrvqx3hKlNZBF0n2xkck+wnjSj0shH6KYvCYAmmSl2brB+Jo/g4E0a2XW/SuEyCLVGMEhyrGCWDcwgdseN64emBMATX7L9HLubSy5wk5lJZvLJYTb7dQG4BYurjX5Wa75Zw5jSPqiwGAUA+S0KCPruVNBBRHLbfG3nh8UHiQqMjab9H+x2jDPwKA5Vsjfe6gpymwQFilu7UwU+FhiYYIZH9zsUduX9tI15M2Lw0x1Jelx6frtQ41W8CCqBEpp9re6zmlaHX2u9GeEQ83m+NxjS9ddMSsNTNtArMDMJZBoV3JC+ERD6eeuoffCj05s0SPUFqGCz5ZgXQLkoGoeLBu/u/y0tIeAw1/FVN426JGGp7uW2M3PYpYlDQpBbIYaQHMsJykIpGdanoPCs997/jDmiqk4bfGs0Hlzil0agahsy/dXjXhMDCXWsIyMnud7D3L8gnF8UXtLzt0p6CteIfhNpEHmEh32uaI0qZE8JnflAu+rHEfdTmz80zXoTaTUrXAMC4KbL0F9/kq7oDCvsZkK0pO5xoRhcjuIY+Xklw4YUaI28s+NPro3w+h8Vk/cU+53r+luhEbChmuNZtawaw4yf/ZqvgfzVRGE+be5MCTYGgQuOe/0Gqvvglts5JDMReLPQFmXPAkSlfwAmEXc+dZ7vTgBmJOpqha4vqmH9h47gJvaVmBrWTJNmmxDlR1S9wDi05bByS/RQzpcFVpQ7J/Bo62n6pUR+4PXPHYuPLmQa0E0Cdzq6llq2TAvO6Ot2rN3C5Bcs17LliqQCgzUeGOS5kpNiz3xbeeg
 DL2UMTDa
 PRtV6psZ0HW3wLJVuGFVfBz17LpbkefjeRy79T74MzNtXcF/KDjWxp4xikrSpZX7wBAQ2Rgu3+F8IS5gkh/W6akr+HLWYNfGr9DZB6SB4odP0lUfgjoCTanwRubkdLP+q23EittffuoDh9bsWN8AWhtlyDOqazCCBJvNgHzEkU8wl3Vb7P0gNaCZ+GwCADQoSuUkde6ccqLluw+ZavFFrpZyiMQ6m5AqDVkgf4aAIrJV/Cb9NEYHvaD69zxz11U9KGOkPfABAmsqAnNwWFzbhvNxtVQ==
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
index e346392b72f6..1a15c928f067 100644
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
+	struct mem_region *mem_region = NULL;
+
+	if (nvdev->resmem.memlength && region_index == RESMEM_REGION_INDEX) {
+		/*
+		 * The P2P properties of the non-BAR memory is the same as the
+		 * BAR memory, so just use the provider for index 0. Someday
+		 * when CXL gets P2P support we could create CXLish providers
+		 * for the non-BAR memory.
+		 */
+		mem_region = &nvdev->resmem;
+	} else if (region_index == USEMEM_REGION_INDEX) {
+		/*
+		 * This is actually cachable memory and isn't treated as P2P in
+		 * the chip. For now we have no way to push cachable memory
+		 * through everything and the Grace HW doesn't care what caching
+		 * attribute is programmed into the SMMU. So use BAR 0.
+		 */
+		mem_region = &nvdev->usemem;
+	}
+
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


