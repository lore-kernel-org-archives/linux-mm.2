Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66626CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 09:58:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B668B8E0020; Tue, 11 Nov 2025 04:58:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B16F88E0002; Tue, 11 Nov 2025 04:58:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A339E8E0020; Tue, 11 Nov 2025 04:58:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 914248E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 04:58:46 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 643E312D197
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:58:46 +0000 (UTC)
X-FDA: 84097877052.20.65D087E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9098E20007
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:58:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m91Cvs5L;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762855124; a=rsa-sha256;
	cv=none;
	b=gVj+Ut61Hqf9syx0UtH4obakIyLT5TT2uqc14ue68qpBW7MxlhJ2PsvPys4Xc6HdaP+A8f
	lOrHyn7aof2iNkUKk/bhcvmOEoB/mQ+uhNuH2A980/VjC7ZYZFN97M7CGqLFCZTOEqotk+
	vTgzwNrakQuPABMZi+msK9J+NGXmNNc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m91Cvs5L;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762855124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J+hCtphTek4rIcDdECZc1NVwwb/iWryElbMcv+WGJdQ=;
	b=k7Wyn/sek6cdzjM1Z8DLQfg2OSKjtN/wblCztQ5IQGmFbPbNt1RSjDpznrKSMpHyWp5dpP
	1bK/bNC0fTatnkcvYEPmvcQfsr+BuSieT74jr3gcJRgyfcg2UynUKsZ4ijFaWroXn3nfdH
	7mM/zn5KeSkrYSdMrjnIRoCGyCtvjDk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B82A840051;
	Tue, 11 Nov 2025 09:58:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF8DEC4AF0C;
	Tue, 11 Nov 2025 09:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762855123;
	bh=RNhQRersDtpXI6Het2PRLPg6Pf8djhGeIyqap//L360=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m91Cvs5LMEj+eGKN/zSGKHFgLn5OOKb6iBpr2HEAPuKEuOKnCutXDEc5JBoZrO3dp
	 nX6pZtBqyo1gEDea8WYR/UY3E1b1aOvK9J4eK7Sh2Ip7fE9o07N1yzx0Nw2z5GjK3Z
	 HJgPAsEptYiJPdaHwSLGVCZ20GpxOY76HvEh8MzXAIc3DmPRhCkeAtpy525bRKlimk
	 C2aytYrId2LtUJW8EPhTIZ4E4Jw+gvI27B9jqMhKdjFxvv1gxRBqG5MKBDZQjAcvyt
	 e2DJ4lzH4e3tl+6nlqXTZeHgMeor6n8DtPFTPJVpcFDxJR0fmhy90/cN2Z1HsDkssQ
	 NcMMmjN0stnWw==
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
Subject: [PATCH v8 09/11] vfio/pci: Enable peer-to-peer DMA transactions by default
Date: Tue, 11 Nov 2025 11:57:51 +0200
Message-ID: <20251111-dmabuf-vfio-v8-9-fd9aa5df478f@nvidia.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-3ae27
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9098E20007
X-Stat-Signature: fwpd7kgptkn5mmrybbn6c5dr6fjbo6j7
X-HE-Tag: 1762855124-809118
X-HE-Meta: U2FsdGVkX18xxXFm96Iu7Szvkbew01wgNlorJIFr/ZRC9PPX8FUR/ml/XkdjlwJK7gaaha0G1/4RMxOLAQ5SWvEJ6Dpzb0CubeRDVY+ImH/OV2cad/2LMhd0GOf9UuEDCO2K0uropFCJM1eq5dl0a99Q/xVn5n7CMMZkXg8yReh2/0M7tAkgCkEoUtOKwIgld36b9tR+M1p9sX7DpUq/irpfXoODlFCY+35H+QiaYwwwkmbCE0Rx4s09toqyRSoGnecPB5y+YSHVCnqNzFxysoSkyhfEUDU5B3HF4IY5ZW40asZJUFxcq06lcES0A9mWsyKkXeF7XdZ9d04MDhBbehHho5FrTPM0sBAA1GgWM30GbO5ozFTUlY2D/7fnKjyOheaAY88FTemFSoYQ9BRUk2O8tg+cnelqSAB1J3qVla3eLXnpSAd0yetvJo6dg+1cs1AaoQ/rI8xq0XS621X9EN7QIZpnYKnEqOz+n+yfOHRw9afkIAx9HCUnzZtKQvftSmCKhuLaOvzPLoXGSjKIgP2LSg9BAgn4c6Ml4AmvNh8SdkNY1lXxDpfbSvY/RbUYWPYm3Bk69JNLKB51owa0vU9Dk66iMCy2ZZSQ4MrBJN/GBbpd859EMOP3dGGHSzCnRSdpETlRmfaNYyL1dbd4CEpjdn1oWH00K9xewJuvaZhk8YZEMo3Um4pXu/FcFQ2STE6dV4X6GTb37heVqG+AFnZJt09qsp68WPysW2UV4QSh0MKzkgjKq4Pjkrw7ujj5HP+amlPTk/dX9AjbDfKInagO7A8j8isNq2Zkdbh/OBCzqZQ/0SBfIuqsHPmBmklHY776u/a2Ezl4V/PDUhmv2Vyr94iqXqrkzEUSDEuowf84LVU4zwHcCzb6WJQGl6OBmjhQLbS9P0JlBs2s1sF1oXUje2lJSsmpvOeJrnQkWm3zVr/HxzKGY7Snh4NglAfQ839VMQ2zmeTQhPoJ7Mu
 GrbYA6Dj
 W5+PG5/PR5KG4ioVlmXlaM0wNCIvfJrrRbtl0+phvM5oWpwD2dAodtIPTzXiaOhmjRUHTYZ8gPyMTHPAUB+Cqb5C/35dstiBwihPPtxNhx1MZS+iqIqkNri2DDpvirL4kKYuDqiG7hQ7jOnonypmnTzrM81k7O8ENpXvfwfw9w484lfFkr2Se33QlHTnqyTaJHTgXHxK4ok9QSzE78h5y79Jo7Tpl0MvWZ0dOhJIo2b86M/zlqLHhZ08KUKT5RnZnisHBxtYsoaPfKenyTYuuFAEA33h1kwInWRurDrRLGGNzNlVroesctxqGuiRsBIdwJnQntzgTbUFPIWxZeCAtcAh8HA==
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


