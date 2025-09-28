Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B261CAC5B5
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 14:51:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A173C8E0013; Sun, 28 Sep 2025 10:51:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C6D08E0001; Sun, 28 Sep 2025 10:51:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 868CE8E0013; Sun, 28 Sep 2025 10:51:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6E07A8E0001
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 10:51:44 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 305021359CC
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 14:51:44 +0000 (UTC)
X-FDA: 83938948128.21.8283623
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6BC4710000D
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 14:51:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IecM6cnp;
	spf=pass (imf14.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759071102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ycOkVza9CMd5BVqHPenAKmgAK/H/YxPqW2ZO6YZQ7b8=;
	b=JHCz/UWyOz/QdAVf/CVpHRXn6MbYdjqlfjuhShK8QK807MNbDU1OcYumESEbFrpLKPdyG8
	v0ZQGZGehr3LqmBJGkSbNDEYHvxHv/8He0dPYTysQLwU/h7vXjkp5/yafqQI4rvWfeee79
	AigQMt/1J4Xuq6oemjFI94Ff5obkVTM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IecM6cnp;
	spf=pass (imf14.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759071102; a=rsa-sha256;
	cv=none;
	b=DsLS2nHV5I0ZzCDXvoaVYO22AdeOs/CBINNttcfjrqRY0QJYpBVXGRs127Xwin5xbb7v6y
	c46vf5P+RZ8U/+m5gdqvN2e33JFl/M9AeEzjxlsYAAgLwNITeppMnBBZs43u04kxleKDrs
	M3QbPk/5e6ZD4A0bNJpIweN1h3ufX3I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B130437BA;
	Sun, 28 Sep 2025 14:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E67C4CEF0;
	Sun, 28 Sep 2025 14:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759071101;
	bh=dgoJMONAaQ0FkHEaGJp6kyyPUaHl6mfDGBVyCOc4l40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IecM6cnpNQvD5wQqEvIeJ/E6uGESzXx3kbcqbVzD/Dvj5U0kHPMCxBYsK134UQTWZ
	 peWN/Mt/KWo875ErMqKWbmPtdm2xxCfMfmCrH2YdSQnOSQ1/ns/IKgrB2tcvPrqHKX
	 R0UocbSiDFfdIt07cha7D7zhiujISujBVDlvoJDl5wLHXvjv/Trq4Q5svk4SUZPgxp
	 MkUrdGopSUJcJNHfP4+neherNzeyd4c/13oAnGUjCiy9UtYwSpXPvogFwrQdahEsL4
	 Qnv29RL4DibXJX7l9M8ynLh5Uv95cjHAoe/5jX7bEv8V5XHipTG+nX4GG8ICSoBY49
	 XuSzg+p6uWOFQ==
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
Subject: [PATCH v4 10/10] vfio/pci: Add dma-buf export support for MMIO regions
Date: Sun, 28 Sep 2025 17:50:20 +0300
Message-ID: <53f3ea1947919a5e657b4f83e74ca53aa45814d4.1759070796.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1759070796.git.leon@kernel.org>
References: <cover.1759070796.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6BC4710000D
X-Stat-Signature: kos1uygrtwne1ezdpfygpz8u197sy35a
X-HE-Tag: 1759071102-467023
X-HE-Meta: U2FsdGVkX1+y+MPXs2E5N97C6GXNMxRBxz+uEPui9rP+5Li1bdrv+MNlrt7RTU5wyEVLC1dLeeNhrpTxVrC0xQwnI2qlVPbGxqVY3jadum2hF6A4RjjkZAwAtmxYQ3V6pa7cZ+Z/N2SP9Nnt7DrHoMqyMcTpHFKqPHL2Di0zSVF1Uz8lNgd1HQor6OicfZ4bce/WO+iekR7p16he3wLcdA12Tg5hp7p3L7AX1DxOqnaJUi4bfxGi1ahcZhlD5/V0KpXBw226WlGazTxQ4+NQl3SZfkFCn9IJ2k94OnQF74YFxEKSZxsV5dQzIXqq9AqJ0ToOWDFpgNx1c6XyKFbmfcGY0Ew4jIJ6EoT4ENB/4h1/tLPD5wNAoLLNzOvb6nmF8YKgqeTTtrdqvL71o/bRU9/LBY58binAQNwRlf5nZUGcYZMAurnpRR9jxSR6/vJusN+XjVxvjVWBGkk2n67y72ZeMzDlML7lmryuxmlU6TIRdBzC7AGQdtZoIR+MPVnkGzC9Wf4cjfNE7FRhogX0Fz77E39PkWZdEbIJ0tdZOreJlO5aUItS5YR+QA20RZzEN35QVT25GHLpevCrJh1s8gOLVayL8YhEb/CTWeWViXi0ancSYx+CSWp4Ech/tpEnTfCJIRQtjGIecIU/Hr+mfS41XhJ1TXFWSXzIIw5pWg086rR8an2c+1/P7uRLHPOgTdQVH2KGpcJKixZGQ7vCxHfD1j/4EYOvncDAG0FDIXneudj6nWyy4nznvJ3rqjMmPgME8YFkG7flODZukSzrxPwGN6rh5kPP9lYjWG8zNkz69E9R8WmSSB4cH+IqZHd0LyFATlNP6mqtLCiNHtnY7r/Y0/MI3O/ZqbeCw+FnsNlMn1d0ZQc+LFY4layfUWyROREj80EhEeLVMAnwGdMaif8Mljn5AHIL0RdKUlHW9PxRvTOqgFgCWC3J/9++P0HurluXhcsxYZ5RRkjkHdd
 xrW64vBF
 jI2ySzttK9XrK1RVoWS6yyW6/FTUvkqwgE49krs0eypxy83UcUQ+FVd3zgL+0Dgsy9zODywzjArkTiVDqoOjfJnGn2dOE7AU3OzSA86+pJf+I2iy81BpaW+EsxWIWlVz5M6t6j4T61cmsOkj8R+Qbrg6CDQOGpdG5hF9G9Mn1sK6e2hJh+wbWrQfJqTKPRHM548ZRwOqBurjhYe/FqhC+c+qlhrsPiZP5VdK1b2sHSWT88fxZdY12Qw8Rlo9qoceqjpyF
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
 drivers/vfio/pci/vfio_pci_core.c   |  17 ++
 drivers/vfio/pci/vfio_pci_dmabuf.c | 398 +++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_priv.h   |  23 ++
 include/linux/vfio_pci_core.h      |   3 +
 include/uapi/linux/vfio.h          |  25 ++
 7 files changed, 486 insertions(+), 4 deletions(-)
 create mode 100644 drivers/vfio/pci/vfio_pci_dmabuf.c

diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index cf00c0a7e55c..f9155e9c5f63 100644
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
index 8f02f236b5b4..1f6008eabf23 100644
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
index 0c39368280d7..aa88c42db69b 100644
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
@@ -2098,6 +2109,7 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
 	ret = pcim_p2pdma_init(vdev->pdev);
 	if (ret)
 		return ret;
+	INIT_LIST_HEAD(&vdev->dmabufs);
 #endif
 	init_rwsem(&vdev->memory_lock);
 	xa_init(&vdev->ctx);
@@ -2463,6 +2475,7 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
 			break;
 		}
 
+		vfio_pci_dma_buf_move(vdev, true);
 		vfio_pci_zap_bars(vdev);
 	}
 
@@ -2486,6 +2499,10 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
 
 	ret = pci_reset_bus(pdev);
 
+	list_for_each_entry(vdev, &dev_set->device_list, vdev.dev_set_list)
+		if (__vfio_pci_memory_enabled(vdev))
+			vfio_pci_dma_buf_move(vdev, false);
+
 	vdev = list_last_entry(&dev_set->device_list,
 			       struct vfio_pci_core_device, vdev.dev_set_list);
 
diff --git a/drivers/vfio/pci/vfio_pci_dmabuf.c b/drivers/vfio/pci/vfio_pci_dmabuf.c
new file mode 100644
index 000000000000..838619f812aa
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
+	struct p2pdma_provider *provider;
+	u32 nr_ranges;
+	u8 revoked : 1;
+};
+
+static int vfio_pci_dma_buf_attach(struct dma_buf *dmabuf,
+				   struct dma_buf_attachment *attachment)
+{
+	struct vfio_pci_dma_buf *priv = dmabuf->priv;
+
+	if (!attachment->peer2peer)
+		return -EOPNOTSUPP;
+
+	if (priv->revoked)
+		return -ENODEV;
+
+	switch (pci_p2pdma_map_type(priv->provider, attachment->dev)) {
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
+	for (i = 0; i < priv->nr_ranges; i++) {
+		if (!state) {
+			addr = pci_p2pdma_bus_addr_map(priv->provider,
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
+				   struct vfio_region_dma_range *dma_ranges,
+				   struct p2pdma_provider *provider)
+{
+	struct pci_dev *pdev = priv->vdev->pdev;
+	phys_addr_t pci_start;
+	int i;
+
+	pci_start = pci_resource_start(pdev, dma_buf->region_index);
+	for (i = 0; i < dma_buf->nr_ranges; i++) {
+		priv->phys_vec[i].len = dma_ranges[i].length;
+		priv->phys_vec[i].paddr = pci_start + dma_ranges[i].offset;
+		priv->size += priv->phys_vec[i].len;
+	}
+	priv->nr_ranges = dma_buf->nr_ranges;
+	priv->provider = provider;
+}
+
+static int validate_dmabuf_input(struct vfio_pci_core_device *vdev,
+				 struct vfio_device_feature_dma_buf *dma_buf,
+				 struct vfio_region_dma_range *dma_ranges,
+				 struct p2pdma_provider **provider)
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
+	*provider = pcim_p2pdma_provider(pdev, bar);
+	if (!provider)
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
+	struct p2pdma_provider *provider;
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
+	ret = validate_dmabuf_input(vdev, &get_dma_buf, dma_ranges, &provider);
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
+	dma_ranges_to_p2p_phys(priv, &get_dma_buf, dma_ranges, provider);
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
index a9972eacb293..28a405f8b97c 100644
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
index f541044e42a2..68afa18630d4 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -94,6 +94,9 @@ struct vfio_pci_core_device {
 	struct vfio_pci_core_device	*sriov_pf_core_dev;
 	struct notifier_block	nb;
 	struct rw_semaphore	memory_lock;
+#ifdef CONFIG_VFIO_PCI_DMABUF
+	struct list_head	dmabufs;
+#endif
 };
 
 /* Will be exported for vfio pci drivers usage */
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 75100bf009ba..63214467c875 100644
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


