Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74C9BCAC58D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 11:34:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9DC1280001; Thu, 11 Sep 2025 07:34:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4DC2940008; Thu, 11 Sep 2025 07:34:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91BF9280001; Thu, 11 Sep 2025 07:34:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7B77B940008
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 07:34:27 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 42B728665E
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 11:34:27 +0000 (UTC)
X-FDA: 83876761374.30.0482A1A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7C2FE80002
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 11:34:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ta8NxR9t;
	spf=pass (imf30.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757590465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/4j5Ui/EbDAbErXaEIF1W+BLrvKmw8nFuwRLLX30kvI=;
	b=ciH9cobodOxFW51rpZSDzhxVEJ9bv4lPQ5kRVFG+vAze2WNU3wiQjyG0oVvAvaeDiutQ2L
	gzSCtSL0gAmwrSpv7QtjqMaANlPyeGJAfpoUsxmCx5DaPJruG7v8aqxzx9glgyXZNZ9027
	IHryFGZv4Hv4qN9MfnfXExat1k6X4cY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ta8NxR9t;
	spf=pass (imf30.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757590465; a=rsa-sha256;
	cv=none;
	b=Gg01lDAHfuLP8jhcpkk/knuzK5lufIyaov74xVhJCt8Qsl3tkn3rkLqzsQFN7/kPVIvhso
	XeT/YQBNrRXSh0xwFV8dBhQxeOTNCMomz8Ld1HrSQTeC7bPFT2EoFNvA0CDQIW9VCU+TUp
	A5GGxMUoLxt2/lbyRWW2tRsiXNScqEE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8CFC14084E;
	Thu, 11 Sep 2025 11:34:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8FCC4CEF0;
	Thu, 11 Sep 2025 11:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757590464;
	bh=F6/4EKQ7srTGRmCvCyrGxQfH5v8P8XujJIofitJtyUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ta8NxR9tuMdH4Yb5xbEnTICl7dk3diUX398T6QA1bQPLkopHGZdYerYhL1nsJeIHN
	 RdqIkaOqGSuFBVKsXLnqDtONFqjiiZ2fnjlZ1WnDSFVa1ogO/s26HFP2OprOuJaJzO
	 xd6c6t6Wenxp1rfqlCYSvh32QNTzWHNY6e6uq5tZg7Qw2peOpXFN/e5frVp37+PBWa
	 ixMQzbyBA0IsOpoyRznWLrh2jVfyPZNvOLfMPrcaXXMjRPOEi9UCa1emfgB1p/ByUO
	 Ob83apxRPdMVKIsaacrHFRSzOPywBQBJDgEHekWtH0hCGoheBTDPcnB/jRbZgb43yg
	 IKf+Mre5iwqMA==
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
Subject: [PATCH v2 10/10] vfio/pci: Add dma-buf export support for MMIO regions
Date: Thu, 11 Sep 2025 14:33:14 +0300
Message-ID: <a4c3fd3a4dcfe901f37538b7f6679844d6c50f3d.1757589589.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1757589589.git.leon@kernel.org>
References: <cover.1757589589.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7C2FE80002
X-Stat-Signature: hgp1c45h7tdb1xknrcrnx384d9z6yyc9
X-HE-Tag: 1757590465-757742
X-HE-Meta: U2FsdGVkX1/CTDdEQxfO+whPAw5nwROh3JQNjNxkuk3MBF823JvdGWvohCD+WjIn2Zc1/rBAlB48QxTYEGS643nqOZbnIqwgHphg716QiW0CWV8rbUIPVDvjwg6d11P57CQ1O+AwDmIpPQj8oQyPg9mLIsVp054rBmvt1MAFrEw9BAsWbhadRBbbCkzr/HBICciNGljw3Etu8M+U+Hq0/lMQBkHVng/VZJor2IEu2t73KVWuV094Zwn9akO7/hj/QdTwFpjS1E1xij4rD+fuxJKd1H1s3SoqaMVekbjUCB779PnpsVcP4DnHxQdu285XTuw7xVmQJVibDYw7TCb1c2PVKPtIY0IQGQy+PIWy6Fg+OAeYlOAknfw3cmRpKkDNzPPNIpZJl8M1HlR7R3JTDYmobDevk5jIllAxMxejYEmljkXqDMhUGIi0bmTHkw3aLfn86iRhATzeH+rxIV8hOSyrh4JT1yMPqa930kp6ksdQH3AaxDQY0vOJfbaVDtTGUedJjZiz24bju6/2KkYUMFmga3Vp43CNJlXnynrHW1fGZu1UJEnM8mYbnhmmoaPRUymWBFabAtQCPvFBhwQTHi2Kq/YGALBuWG2Re5hAeeelcCAn/SqE9/gskH1JBRX3jfQzzGM9f/f4PL+ECCiDe/e9y5CMSEaC4VzU/fxDLrFxcFLkyQ8kMF0uwb0VS6J4ObHE0Y0waUh2iXGbWeEqQf7imoMWr/FsV3Rp+ITJx31GyCIG9L36Fyv86dv2wlcGPMRroeOiIiBxWEtnTE5j1Eqt+vNcdHrwH4YizTlm2a3NSSzSu6cVq/7HkUUDFTLzQTO31D7JaQmmpXEWnHRvbrwQWG/OijBdQdu0XiKFn65W2hyczs+L6AeukdYW8pBLcHPVgtu7JCjhVaiYWJMfQmhz7HqwIEWKUzqRle/KlnLZLywMyhiNiPEDlWxoMHUABR46pJ+b12EMLDyEP/M
 Z+aKfkMT
 NNlt+8to14Ab1vlx/rsWW07WrpJdOPOUC3bbmj4n2DKL8ClNv/WCA4RBa4GB1Y8mdjQGJxKkcA00AA7N5r7NGgkFXKG5er6Zj57gVPFgqxocuY9edhUhw7V3tHV8xy8QMtWEmYVoPCr45B02KP1wHLojTMntz30HXhf4cB167fajySRs6GpTRxeOZLkiHRGqsMMrsYnGo8KvcuNT0ou/vW7KyNapzdxCbCyx0MFyOpSqC6i8jeveo/fIVP0CQ0jsYn3db
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

Add support for exporting PCI device MMIO regions through dma-buf,
enabling safe sharing of non-struct page memory with controlled
lifetime management. This allows RDMA and other subsystems to import
dma-buf FDs and build them into memory regions for PCI P2P operations.

The implementation provides a revocable attachment mechanism using
dma-buf move operations. MMIO regions are normally pinned as BARs
don't change physical addresses, but access is revoked when the VFIO
device is closed or a PCI reset is issued. This ensures kernel
self-defense against potentially hostile userspace.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vfio/pci/Makefile          |   2 +
 drivers/vfio/pci/vfio_pci_config.c |  22 +-
 drivers/vfio/pci/vfio_pci_core.c   |  18 ++
 drivers/vfio/pci/vfio_pci_dmabuf.c | 398 +++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_priv.h   |  23 ++
 include/linux/vfio_pci_core.h      |   1 +
 include/uapi/linux/vfio.h          |  25 ++
 7 files changed, 485 insertions(+), 4 deletions(-)
 create mode 100644 drivers/vfio/pci/vfio_pci_dmabuf.c

diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index cf00c0a7e55c8..f9155e9c5f630 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -2,7 +2,9 @@
 
 vfio-pci-core-y := vfio_pci_core.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_config.o
 vfio-pci-core-$(CONFIG_VFIO_PCI_ZDEV_KVM) += vfio_pci_zdev.o
+
 obj-$(CONFIG_VFIO_PCI_CORE) += vfio-pci-core.o
+vfio-pci-core-$(CONFIG_VFIO_PCI_DMABUF) += vfio_pci_dmabuf.o
 
 vfio-pci-y := vfio_pci.o
 vfio-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 8f02f236b5b4b..1f6008eabf236 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -589,10 +589,12 @@ static int vfio_basic_config_write(struct vfio_pci_core_device *vdev, int pos,
 		virt_mem = !!(le16_to_cpu(*virt_cmd) & PCI_COMMAND_MEMORY);
 		new_mem = !!(new_cmd & PCI_COMMAND_MEMORY);
 
-		if (!new_mem)
+		if (!new_mem) {
 			vfio_pci_zap_and_down_write_memory_lock(vdev);
-		else
+			vfio_pci_dma_buf_move(vdev, true);
+		} else {
 			down_write(&vdev->memory_lock);
+		}
 
 		/*
 		 * If the user is writing mem/io enable (new_mem/io) and we
@@ -627,6 +629,8 @@ static int vfio_basic_config_write(struct vfio_pci_core_device *vdev, int pos,
 		*virt_cmd &= cpu_to_le16(~mask);
 		*virt_cmd |= cpu_to_le16(new_cmd & mask);
 
+		if (__vfio_pci_memory_enabled(vdev))
+			vfio_pci_dma_buf_move(vdev, false);
 		up_write(&vdev->memory_lock);
 	}
 
@@ -707,12 +711,16 @@ static int __init init_pci_cap_basic_perm(struct perm_bits *perm)
 static void vfio_lock_and_set_power_state(struct vfio_pci_core_device *vdev,
 					  pci_power_t state)
 {
-	if (state >= PCI_D3hot)
+	if (state >= PCI_D3hot) {
 		vfio_pci_zap_and_down_write_memory_lock(vdev);
-	else
+		vfio_pci_dma_buf_move(vdev, true);
+	} else {
 		down_write(&vdev->memory_lock);
+	}
 
 	vfio_pci_set_power_state(vdev, state);
+	if (__vfio_pci_memory_enabled(vdev))
+		vfio_pci_dma_buf_move(vdev, false);
 	up_write(&vdev->memory_lock);
 }
 
@@ -900,7 +908,10 @@ static int vfio_exp_config_write(struct vfio_pci_core_device *vdev, int pos,
 
 		if (!ret && (cap & PCI_EXP_DEVCAP_FLR)) {
 			vfio_pci_zap_and_down_write_memory_lock(vdev);
+			vfio_pci_dma_buf_move(vdev, true);
 			pci_try_reset_function(vdev->pdev);
+			if (__vfio_pci_memory_enabled(vdev))
+				vfio_pci_dma_buf_move(vdev, false);
 			up_write(&vdev->memory_lock);
 		}
 	}
@@ -982,7 +993,10 @@ static int vfio_af_config_write(struct vfio_pci_core_device *vdev, int pos,
 
 		if (!ret && (cap & PCI_AF_CAP_FLR) && (cap & PCI_AF_CAP_TP)) {
 			vfio_pci_zap_and_down_write_memory_lock(vdev);
+			vfio_pci_dma_buf_move(vdev, true);
 			pci_try_reset_function(vdev->pdev);
+			if (__vfio_pci_memory_enabled(vdev))
+				vfio_pci_dma_buf_move(vdev, false);
 			up_write(&vdev->memory_lock);
 		}
 	}
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 93b6cecfcab49..6d466faddb3a9 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -289,6 +289,8 @@ static int vfio_pci_runtime_pm_entry(struct vfio_pci_core_device *vdev,
 	 * semaphore.
 	 */
 	vfio_pci_zap_and_down_write_memory_lock(vdev);
+	vfio_pci_dma_buf_move(vdev, true);
+
 	if (vdev->pm_runtime_engaged) {
 		up_write(&vdev->memory_lock);
 		return -EINVAL;
@@ -372,6 +374,8 @@ static void vfio_pci_runtime_pm_exit(struct vfio_pci_core_device *vdev)
 	 */
 	down_write(&vdev->memory_lock);
 	__vfio_pci_runtime_pm_exit(vdev);
+	if (__vfio_pci_memory_enabled(vdev))
+		vfio_pci_dma_buf_move(vdev, false);
 	up_write(&vdev->memory_lock);
 }
 
@@ -692,6 +696,8 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev)
 #endif
 	vfio_pci_core_disable(vdev);
 
+	vfio_pci_dma_buf_cleanup(vdev);
+
 	mutex_lock(&vdev->igate);
 	if (vdev->err_trigger) {
 		eventfd_ctx_put(vdev->err_trigger);
@@ -1224,7 +1230,10 @@ static int vfio_pci_ioctl_reset(struct vfio_pci_core_device *vdev,
 	 */
 	vfio_pci_set_power_state(vdev, PCI_D0);
 
+	vfio_pci_dma_buf_move(vdev, true);
 	ret = pci_try_reset_function(vdev->pdev);
+	if (__vfio_pci_memory_enabled(vdev))
+		vfio_pci_dma_buf_move(vdev, false);
 	up_write(&vdev->memory_lock);
 
 	return ret;
@@ -1513,6 +1522,8 @@ int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
 		return vfio_pci_core_pm_exit(vdev, flags, arg, argsz);
 	case VFIO_DEVICE_FEATURE_PCI_VF_TOKEN:
 		return vfio_pci_core_feature_token(vdev, flags, arg, argsz);
+	case VFIO_DEVICE_FEATURE_DMA_BUF:
+		return vfio_pci_core_feature_dma_buf(vdev, flags, arg, argsz);
 	default:
 		return -ENOTTY;
 	}
@@ -2100,6 +2111,8 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
 		if (IS_ERR(vdev->provider[i]))
 			return PTR_ERR(vdev->provider[i]);
 	}
+
+	INIT_LIST_HEAD(&vdev->dmabufs);
 #endif
 	init_rwsem(&vdev->memory_lock);
 	xa_init(&vdev->ctx);
@@ -2465,6 +2478,7 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
 			break;
 		}
 
+		vfio_pci_dma_buf_move(vdev, true);
 		vfio_pci_zap_bars(vdev);
 	}
 
@@ -2488,6 +2502,10 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
 
 	ret = pci_reset_bus(pdev);
 
+	list_for_each_entry(vdev, &dev_set->device_list, vdev.dev_set_list)
+		if (__vfio_pci_memory_enabled(vdev))
+			vfio_pci_dma_buf_move(vdev, false);
+
 	vdev = list_last_entry(&dev_set->device_list,
 			       struct vfio_pci_core_device, vdev.dev_set_list);
 
diff --git a/drivers/vfio/pci/vfio_pci_dmabuf.c b/drivers/vfio/pci/vfio_pci_dmabuf.c
new file mode 100644
index 0000000000000..3d4839873f03d
--- /dev/null
+++ b/drivers/vfio/pci/vfio_pci_dmabuf.c
@@ -0,0 +1,398 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2025, NVIDIA CORPORATION & AFFILIATES.
+ */
+#include <linux/dma-buf.h>
+#include <linux/pci-p2pdma.h>
+#include <linux/dma-resv.h>
+
+#include "vfio_pci_priv.h"
+
+MODULE_IMPORT_NS("DMA_BUF");
+
+struct vfio_pci_dma_buf {
+	struct dma_buf *dmabuf;
+	struct vfio_pci_core_device *vdev;
+	struct list_head dmabufs_elm;
+	size_t size;
+	struct phys_vec *phys_vec;
+	int bar;
+	u32 nr_ranges;
+	u8 revoked : 1;
+};
+
+static int vfio_pci_dma_buf_attach(struct dma_buf *dmabuf,
+				   struct dma_buf_attachment *attachment)
+{
+	struct vfio_pci_dma_buf *priv = dmabuf->priv;
+	struct p2pdma_provider *provider;
+
+	if (!attachment->peer2peer)
+		return -EOPNOTSUPP;
+
+	if (priv->revoked)
+		return -ENODEV;
+
+	provider = priv->vdev->provider[priv->bar];
+	switch (pci_p2pdma_map_type(provider, attachment->dev)) {
+	case PCI_P2PDMA_MAP_THRU_HOST_BRIDGE:
+		break;
+	case PCI_P2PDMA_MAP_BUS_ADDR:
+		/*
+		 * There is no need in IOVA at all for this flow.
+		 * We rely on attachment->priv == NULL as a marker
+		 * for this mode.
+		 */
+		return 0;
+	default:
+		return -EINVAL;
+	}
+
+	attachment->priv = kzalloc(sizeof(struct dma_iova_state), GFP_KERNEL);
+	if (!attachment->priv)
+		return -ENOMEM;
+
+	dma_iova_try_alloc(attachment->dev, attachment->priv, 0, priv->size);
+	return 0;
+}
+
+static void vfio_pci_dma_buf_detach(struct dma_buf *dmabuf,
+				    struct dma_buf_attachment *attachment)
+{
+	kfree(attachment->priv);
+}
+
+static void fill_sg_entry(struct scatterlist *sgl, unsigned int length,
+			 dma_addr_t addr)
+{
+	/*
+	 * Follow the DMABUF rules for scatterlist, the struct page can be
+	 * NULL'd for MMIO only memort.
+	 */
+	sg_set_page(sgl, NULL, length, 0);
+	sg_dma_address(sgl) = addr;
+	sg_dma_len(sgl) = length;
+}
+
+static struct sg_table *
+vfio_pci_dma_buf_map(struct dma_buf_attachment *attachment,
+		     enum dma_data_direction dir)
+{
+	struct vfio_pci_dma_buf *priv = attachment->dmabuf->priv;
+	struct dma_iova_state *state = attachment->priv;
+	struct phys_vec *phys_vec = priv->phys_vec;
+	unsigned long attrs = DMA_ATTR_MMIO;
+	struct p2pdma_provider *provider;
+	unsigned int mapped_len = 0;
+	struct scatterlist *sgl;
+	struct sg_table *sgt;
+	dma_addr_t addr;
+	int ret, i;
+
+	dma_resv_assert_held(priv->dmabuf->resv);
+
+	if (priv->revoked)
+		return ERR_PTR(-ENODEV);
+
+	sgt = kzalloc(sizeof(*sgt), GFP_KERNEL);
+	if (!sgt)
+		return ERR_PTR(-ENOMEM);
+
+	ret = sg_alloc_table(sgt, 1, GFP_KERNEL | __GFP_ZERO);
+	if (ret)
+		goto err_kfree_sgt;
+
+	sgl = sgt->sgl;
+
+	provider = priv->vdev->provider[priv->bar];
+	for (i = 0; i < priv->nr_ranges; i++) {
+		if (!state) {
+			addr = pci_p2pdma_bus_addr_map(provider,
+						       phys_vec[i].paddr);
+		} else if (dma_use_iova(state)) {
+			ret = dma_iova_link(attachment->dev, state,
+					    phys_vec[i].paddr, 0,
+					    phys_vec[i].len, dir, attrs);
+			if (ret)
+				goto err_unmap_dma;
+
+			mapped_len += phys_vec[i].len;
+		} else {
+			addr = dma_map_phys(attachment->dev, phys_vec[i].paddr,
+					    phys_vec[i].len, dir, attrs);
+			ret = dma_mapping_error(attachment->dev, addr);
+			if (ret)
+				goto err_unmap_dma;
+		}
+
+		if (!state || !dma_use_iova(state)) {
+			/*
+			 * In IOVA case, there is only one SG entry which spans
+			 * for whole IOVA address space. So there is no need
+			 * to call to sg_next() here.
+			 */
+			fill_sg_entry(sgl, phys_vec[i].len, addr);
+			sgl = sg_next(sgl);
+		}
+	}
+
+	if (state && dma_use_iova(state)) {
+		WARN_ON_ONCE(mapped_len != priv->size);
+		ret = dma_iova_sync(attachment->dev, state, 0, mapped_len);
+		if (ret)
+			goto err_unmap_dma;
+		fill_sg_entry(sgl, mapped_len, state->addr);
+	}
+
+	return sgt;
+
+err_unmap_dma:
+	if (!i || !state)
+		; /* Do nothing */
+	else if (dma_use_iova(state))
+		dma_iova_destroy(attachment->dev, state, mapped_len, dir,
+				 attrs);
+	else
+		for_each_sgtable_dma_sg(sgt, sgl, i)
+			dma_unmap_phys(attachment->dev, sg_dma_address(sgl),
+					sg_dma_len(sgl), dir, attrs);
+	sg_free_table(sgt);
+err_kfree_sgt:
+	kfree(sgt);
+	return ERR_PTR(ret);
+}
+
+static void vfio_pci_dma_buf_unmap(struct dma_buf_attachment *attachment,
+				   struct sg_table *sgt,
+				   enum dma_data_direction dir)
+{
+	struct vfio_pci_dma_buf *priv = attachment->dmabuf->priv;
+	struct dma_iova_state *state = attachment->priv;
+	unsigned long attrs = DMA_ATTR_MMIO;
+	struct scatterlist *sgl;
+	int i;
+
+	if (!state)
+		; /* Do nothing */
+	else if (dma_use_iova(state))
+		dma_iova_destroy(attachment->dev, state, priv->size, dir,
+				 attrs);
+	else
+		for_each_sgtable_dma_sg(sgt, sgl, i)
+			dma_unmap_phys(attachment->dev, sg_dma_address(sgl),
+				       sg_dma_len(sgl), dir, attrs);
+
+	sg_free_table(sgt);
+	kfree(sgt);
+}
+
+static void vfio_pci_dma_buf_release(struct dma_buf *dmabuf)
+{
+	struct vfio_pci_dma_buf *priv = dmabuf->priv;
+
+	/*
+	 * Either this or vfio_pci_dma_buf_cleanup() will remove from the list.
+	 * The refcount prevents both.
+	 */
+	if (priv->vdev) {
+		down_write(&priv->vdev->memory_lock);
+		list_del_init(&priv->dmabufs_elm);
+		up_write(&priv->vdev->memory_lock);
+		vfio_device_put_registration(&priv->vdev->vdev);
+	}
+	kfree(priv->phys_vec);
+	kfree(priv);
+}
+
+static const struct dma_buf_ops vfio_pci_dmabuf_ops = {
+	.attach = vfio_pci_dma_buf_attach,
+	.detach = vfio_pci_dma_buf_detach,
+	.map_dma_buf = vfio_pci_dma_buf_map,
+	.release = vfio_pci_dma_buf_release,
+	.unmap_dma_buf = vfio_pci_dma_buf_unmap,
+};
+
+static void dma_ranges_to_p2p_phys(struct vfio_pci_dma_buf *priv,
+				   struct vfio_device_feature_dma_buf *dma_buf,
+				   struct vfio_region_dma_range *dma_ranges)
+{
+	struct pci_dev *pdev = priv->vdev->pdev;
+	phys_addr_t pci_start;
+	int i;
+
+	pci_start = pci_resource_start(pdev, dma_buf->region_index);
+	for (i = 0; i < dma_buf->nr_ranges; i++) {
+		priv->phys_vec[i].len = dma_ranges[i].length;
+		priv->phys_vec[i].paddr += pci_start + dma_ranges[i].offset;
+		priv->size += priv->phys_vec[i].len;
+	}
+	priv->nr_ranges = dma_buf->nr_ranges;
+	priv->bar = dma_buf->region_index;
+}
+
+static int validate_dmabuf_input(struct vfio_pci_core_device *vdev,
+				 struct vfio_device_feature_dma_buf *dma_buf,
+				 struct vfio_region_dma_range *dma_ranges)
+{
+	struct pci_dev *pdev = vdev->pdev;
+	u32 bar = dma_buf->region_index;
+	resource_size_t bar_size;
+	u64 sum;
+	int i;
+
+	if (dma_buf->flags)
+		return -EINVAL;
+	/*
+	 * For PCI the region_index is the BAR number like  everything else.
+	 */
+	if (bar >= VFIO_PCI_ROM_REGION_INDEX)
+		return -ENODEV;
+
+	if (!(pci_resource_flags(pdev, bar) & IORESOURCE_MEM))
+		return -EINVAL;
+
+	bar_size = pci_resource_len(pdev, bar);
+	for (i = 0; i < dma_buf->nr_ranges; i++) {
+		u64 offset = dma_ranges[i].offset;
+		u64 len = dma_ranges[i].length;
+
+		if (!PAGE_ALIGNED(offset) || !PAGE_ALIGNED(len))
+			return -EINVAL;
+
+		if (check_add_overflow(offset, len, &sum) || sum > bar_size)
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
+int vfio_pci_core_feature_dma_buf(struct vfio_pci_core_device *vdev, u32 flags,
+				  struct vfio_device_feature_dma_buf __user *arg,
+				  size_t argsz)
+{
+	struct vfio_device_feature_dma_buf get_dma_buf = {};
+	struct vfio_region_dma_range *dma_ranges;
+	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
+	struct vfio_pci_dma_buf *priv;
+	int ret;
+
+	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_GET,
+				 sizeof(get_dma_buf));
+	if (ret != 1)
+		return ret;
+
+	if (copy_from_user(&get_dma_buf, arg, sizeof(get_dma_buf)))
+		return -EFAULT;
+
+	if (!get_dma_buf.nr_ranges)
+		return -EINVAL;
+
+	dma_ranges = memdup_array_user(&arg->dma_ranges, get_dma_buf.nr_ranges,
+				       sizeof(*dma_ranges));
+	if (IS_ERR(dma_ranges))
+		return PTR_ERR(dma_ranges);
+
+	ret = validate_dmabuf_input(vdev, &get_dma_buf, dma_ranges);
+	if (ret)
+		return ret;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv) {
+		ret = -ENOMEM;
+		goto err_free_ranges;
+	}
+	priv->phys_vec = kcalloc(get_dma_buf.nr_ranges, sizeof(*priv->phys_vec),
+				 GFP_KERNEL);
+	if (!priv->phys_vec) {
+		ret = -ENOMEM;
+		goto err_free_priv;
+	}
+
+	priv->vdev = vdev;
+	dma_ranges_to_p2p_phys(priv, &get_dma_buf, dma_ranges);
+	kfree(dma_ranges);
+	dma_ranges = NULL;
+
+	if (!vfio_device_try_get_registration(&vdev->vdev)) {
+		ret = -ENODEV;
+		goto err_free_phys;
+	}
+
+	exp_info.ops = &vfio_pci_dmabuf_ops;
+	exp_info.size = priv->size;
+	exp_info.flags = get_dma_buf.open_flags;
+	exp_info.priv = priv;
+
+	priv->dmabuf = dma_buf_export(&exp_info);
+	if (IS_ERR(priv->dmabuf)) {
+		ret = PTR_ERR(priv->dmabuf);
+		goto err_dev_put;
+	}
+
+	/* dma_buf_put() now frees priv */
+	INIT_LIST_HEAD(&priv->dmabufs_elm);
+	down_write(&vdev->memory_lock);
+	dma_resv_lock(priv->dmabuf->resv, NULL);
+	priv->revoked = !__vfio_pci_memory_enabled(vdev);
+	list_add_tail(&priv->dmabufs_elm, &vdev->dmabufs);
+	dma_resv_unlock(priv->dmabuf->resv);
+	up_write(&vdev->memory_lock);
+
+	/*
+	 * dma_buf_fd() consumes the reference, when the file closes the dmabuf
+	 * will be released.
+	 */
+	return dma_buf_fd(priv->dmabuf, get_dma_buf.open_flags);
+
+err_dev_put:
+	vfio_device_put_registration(&vdev->vdev);
+err_free_phys:
+	kfree(priv->phys_vec);
+err_free_priv:
+	kfree(priv);
+err_free_ranges:
+	kfree(dma_ranges);
+	return ret;
+}
+
+void vfio_pci_dma_buf_move(struct vfio_pci_core_device *vdev, bool revoked)
+{
+	struct vfio_pci_dma_buf *priv;
+	struct vfio_pci_dma_buf *tmp;
+
+	lockdep_assert_held_write(&vdev->memory_lock);
+
+	list_for_each_entry_safe(priv, tmp, &vdev->dmabufs, dmabufs_elm) {
+		if (!get_file_active(&priv->dmabuf->file))
+			continue;
+
+		if (priv->revoked != revoked) {
+			dma_resv_lock(priv->dmabuf->resv, NULL);
+			priv->revoked = revoked;
+			dma_buf_move_notify(priv->dmabuf);
+			dma_resv_unlock(priv->dmabuf->resv);
+		}
+		dma_buf_put(priv->dmabuf);
+	}
+}
+
+void vfio_pci_dma_buf_cleanup(struct vfio_pci_core_device *vdev)
+{
+	struct vfio_pci_dma_buf *priv;
+	struct vfio_pci_dma_buf *tmp;
+
+	down_write(&vdev->memory_lock);
+	list_for_each_entry_safe(priv, tmp, &vdev->dmabufs, dmabufs_elm) {
+		if (!get_file_active(&priv->dmabuf->file))
+			continue;
+
+		dma_resv_lock(priv->dmabuf->resv, NULL);
+		list_del_init(&priv->dmabufs_elm);
+		priv->vdev = NULL;
+		priv->revoked = true;
+		dma_buf_move_notify(priv->dmabuf);
+		dma_resv_unlock(priv->dmabuf->resv);
+		vfio_device_put_registration(&vdev->vdev);
+		dma_buf_put(priv->dmabuf);
+	}
+	up_write(&vdev->memory_lock);
+}
diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
index a9972eacb2936..28a405f8b97c9 100644
--- a/drivers/vfio/pci/vfio_pci_priv.h
+++ b/drivers/vfio/pci/vfio_pci_priv.h
@@ -107,4 +107,27 @@ static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
 	return (pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA;
 }
 
+#ifdef CONFIG_VFIO_PCI_DMABUF
+int vfio_pci_core_feature_dma_buf(struct vfio_pci_core_device *vdev, u32 flags,
+				  struct vfio_device_feature_dma_buf __user *arg,
+				  size_t argsz);
+void vfio_pci_dma_buf_cleanup(struct vfio_pci_core_device *vdev);
+void vfio_pci_dma_buf_move(struct vfio_pci_core_device *vdev, bool revoked);
+#else
+static inline int
+vfio_pci_core_feature_dma_buf(struct vfio_pci_core_device *vdev, u32 flags,
+			      struct vfio_device_feature_dma_buf __user *arg,
+			      size_t argsz)
+{
+	return -ENOTTY;
+}
+static inline void vfio_pci_dma_buf_cleanup(struct vfio_pci_core_device *vdev)
+{
+}
+static inline void vfio_pci_dma_buf_move(struct vfio_pci_core_device *vdev,
+					 bool revoked)
+{
+}
+#endif
+
 #endif
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 2184ba65348b8..2d612c14d3cb3 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -96,6 +96,7 @@ struct vfio_pci_core_device {
 	struct rw_semaphore	memory_lock;
 #ifdef CONFIG_VFIO_PCI_DMABUF
 	struct p2pdma_provider  *provider[PCI_STD_NUM_BARS];
+	struct list_head	dmabufs;
 #endif
 };
 
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 75100bf009baf..63214467c875a 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -1478,6 +1478,31 @@ struct vfio_device_feature_bus_master {
 };
 #define VFIO_DEVICE_FEATURE_BUS_MASTER 10
 
+/**
+ * Upon VFIO_DEVICE_FEATURE_GET create a dma_buf fd for the
+ * regions selected.
+ *
+ * open_flags are the typical flags passed to open(2), eg O_RDWR, O_CLOEXEC,
+ * etc. offset/length specify a slice of the region to create the dmabuf from.
+ * nr_ranges is the total number of (P2P DMA) ranges that comprise the dmabuf.
+ *
+ * Return: The fd number on success, -1 and errno is set on failure.
+ */
+#define VFIO_DEVICE_FEATURE_DMA_BUF 11
+
+struct vfio_region_dma_range {
+	__u64 offset;
+	__u64 length;
+};
+
+struct vfio_device_feature_dma_buf {
+	__u32	region_index;
+	__u32	open_flags;
+	__u32   flags;
+	__u32   nr_ranges;
+	struct vfio_region_dma_range dma_ranges[];
+};
+
 /* -------- API for Type1 VFIO IOMMU -------- */
 
 /**
-- 
2.51.0


