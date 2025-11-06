Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 614B4CCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 14:17:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBBBD8E0013; Thu,  6 Nov 2025 09:17:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6C6E8E0002; Thu,  6 Nov 2025 09:17:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5B8C8E0013; Thu,  6 Nov 2025 09:17:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9013A8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 09:17:37 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 55FA9160762
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 14:17:37 +0000 (UTC)
X-FDA: 84080385354.11.76BC87B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 641E28000F
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 14:17:35 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U6fIiXaZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762438655; a=rsa-sha256;
	cv=none;
	b=USoD67kmvqDcomfwjlkc+vnn2Yrf5w1nhKpPAO8GUznvGYKFZmmm7KaCxQGXkigEJl/Hmu
	1Se5JszZxrgKhP3j77zU57Rg/PdCrjO8eE/EXAWQw7gMXkIjVYo4FxQCGurenmakTJmyGd
	3Qvblehu18zwLHgojLhmMdjgEkDSaCM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U6fIiXaZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762438655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J+hCtphTek4rIcDdECZc1NVwwb/iWryElbMcv+WGJdQ=;
	b=qN9sOg2qvd9zAxOpAGW4QzreAc7Ra8xUxEKkfLy+udC9MOBdaarYX6kj0r6fS5PnlgwccY
	JIKvKvWii5xZb1q1VH8OViquFyQb5pLn1SCgp9Kd3GRNXB0eGoRZ+c+YtOF89ZSmjavSqi
	nRFMC3fCo8ng/nS1QWn+0hlBipkWPuQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8BB90445AC;
	Thu,  6 Nov 2025 14:17:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98255C4CEF7;
	Thu,  6 Nov 2025 14:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762438654;
	bh=RNhQRersDtpXI6Het2PRLPg6Pf8djhGeIyqap//L360=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U6fIiXaZ/5bDfsBac8hg5pWveRHm4jDtJ2Pmq07lX/LOeyz3dSevkXrcQBCfyKuYd
	 U6SG36gTUwmv+VFgY/8Pi+n7w47W3F7HTwRRr4BHxDzJb3cyzVpP9wQ+r67ua/6N6I
	 jrgQKVzXxaJ/KaSZ87yyM64Tq1xoytln/zo7dCi1D1j/3osmxVx2BtmmLHnYiqda0p
	 RYm+25mT+E/zXXt1d3pA710K6i6NRouDKuwBIp797LHzwsEpR9aTnm1E31rgSOEK6i
	 iGKmgGdq0Q6+3C70mrCecWpZ/CFCYZZ3LIDg12Y42stnh1UvnmfA9P8IRgHSyLSp/g
	 vt+l5+4vaek2g==
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
Subject: [PATCH v7 09/11] vfio/pci: Enable peer-to-peer DMA transactions by default
Date: Thu,  6 Nov 2025 16:16:54 +0200
Message-ID: <20251106-dmabuf-vfio-v7-9-2503bf390699@nvidia.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251106-dmabuf-vfio-v7-0-2503bf390699@nvidia.com>
References: <20251106-dmabuf-vfio-v7-0-2503bf390699@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-3ae27
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 641E28000F
X-Stat-Signature: s5ua6kuzqn3h5byymkizqpdq1oemiahu
X-HE-Tag: 1762438655-354528
X-HE-Meta: U2FsdGVkX19gchdg86Ol04hFrthSq5PTBhWUVDPhcjNJBppgWmfSu0XpJ0I4qqcSlbkUzPVpdStWGTljg432pyTahEjDjWzguDQDO0QAn+UD5b8hoM/X9tUqVia6/3vOpGZA29uyriSoR2TrS0Vp6aQpjPFEnhJf6vBDRj69ViMDKXcW6TYXDf+9gNC2oDnEt4cuXl9tYtUPdPfcaKSdwB+qQZiRfseFrsrBjFpx7TV1Bv4H+UOTM/BNp93HjdjvL5yIKY6t7svW4ABYwqnBiktyRcXmTZc2xtvnkeLxFIBKry0lVZV5dgeZfzabImWt9fc0LC1e0XncXvIN4vrYOF9TP42EisrHqETyw5MhQMCl5GbjdEttEsc7CH3ZiAyCvifQnoGv5w/TazaRE+Fx2jjePz78SuavJhNrsLHdPWCK7CXqGZRzYbtSjhw3V3ql0YmNplzRVVecvXuwKeQLVOXEdeL3BeZ0S1QJ27KcuSquRAswDqbUMd/lCnAetIijZM71wc9oRBHDpHAr3nbZLstwwwQPeQ1nFPG3D7stakqwGXtZnwkBR4Gbyyoa/TchJEh6X2aCI0B0OQdOUCWZLt5nBwwYGZ8TVv4gRHYFD1fkjChtxeKb1fyIIjb5nP+a7N3ogual3ok7iWSduoZBIPIHs1esYO6ymqWlmT+e+GxO5zx8qao5AYeJaIko38RJu5vX0UqvE7n0zqGsFxhkbOHAitHHAbGw3xNR1RkFypU29XlfhvDjdB5ouBxC/NK65uTtP7jKAH6cbM/fqx/ZJgrDJtBunliIbdyryao1G+YXPbp3sicpwWDBRHLi1VmItWGzlrAkMLcoomg7VkfBBUyfBbVUWdg7gEadlcJGc4xyRGLWcAYI9zP/meG52sQbVb+SrVJo780HKai3+ZKEmBPcHz5pQZNnF73C+XMgMAXQI5XLe4Zw6u0kkBM3CfQXS4pQUH37NAKRmcToC/x
 u2ZJRh2p
 UshKPPXEYTn1YWwARjeZMoueMdw6LC51EO6bXOTuVIuKZs928esalcghPxSfZjN/xQWf+24T8tJ/OU5cY8lOV0tmErAledQr2h+Qemy2hG1pwjLypLGBHhN2fEy1BjlqCoV5z8uD4cp27fxdQSglsuIJ0/N0jXXmMzdPGkMrdYcq0plA21Efk20N99jgu0P35tS3YvCiuxSHUuT5xsNBIAuBgcpC2oPy3Nz1H
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

Make sure that all VFIO PCI devices have peer-to-peer capabilities
enables, so we would be able to export their MMIO memory through DMABUF,

VFIO has always supported P2P mappings with itself. VFIO type 1
insecurely reads PFNs directly out of a VMA's PTEs and programs them
into the IOMMU allowing any two VFIO devices to perform P2P to each
other.

All existing VMMs use this capability to export P2P into a VM where
the VM could setup any kind of DMA it likes. Projects like DPDK/SPDK
are also known to make use of this, though less frequently.

As a first step to more properly integrating VFIO with the P2P
subsystem unconditionally enable P2P support for VFIO PCI devices. The
struct p2pdma_provider will act has a handle to the P2P subsystem to
do things like DMA mapping.

While real PCI devices have to support P2P (they can't even tell if an
IOVA is P2P or not) there may be fake PCI devices that may trigger
some kind of catastrophic system failure. To date VFIO has never
tripped up on such a case, but if one is discovered the plan is to add
a PCI quirk and have pcim_p2pdma_init() fail. This will fully block
the broken device throughout any users of the P2P subsystem in the
kernel.

Thus P2P through DMABUF will follow the historical VFIO model and be
unconditionally enabled by vfio-pci.

Tested-by: Alex Mastro <amastro@fb.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index ca9a95716a85..142b84b3f225 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -28,6 +28,7 @@
 #include <linux/nospec.h>
 #include <linux/sched/mm.h>
 #include <linux/iommufd.h>
+#include <linux/pci-p2pdma.h>
 #if IS_ENABLED(CONFIG_EEH)
 #include <asm/eeh.h>
 #endif
@@ -2081,6 +2082,7 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+	int ret;
 
 	vdev->pdev = to_pci_dev(core_vdev->dev);
 	vdev->irq_type = VFIO_PCI_NUM_IRQS;
@@ -2090,6 +2092,9 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
 	INIT_LIST_HEAD(&vdev->dummy_resources_list);
 	INIT_LIST_HEAD(&vdev->ioeventfds_list);
 	INIT_LIST_HEAD(&vdev->sriov_pfs_item);
+	ret = pcim_p2pdma_init(vdev->pdev);
+	if (ret && ret != -EOPNOTSUPP)
+		return ret;
 	init_rwsem(&vdev->memory_lock);
 	xa_init(&vdev->ctx);
 

-- 
2.51.1


