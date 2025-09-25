Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEAFACAC5A7
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 13:18:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12F378E000F; Thu, 25 Sep 2025 09:18:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DFC58E0001; Thu, 25 Sep 2025 09:18:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F10D98E000F; Thu, 25 Sep 2025 09:18:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DCE508E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:18:58 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B2B131180E1
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 13:18:58 +0000 (UTC)
X-FDA: 83927827956.13.0510A6F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 11FA9180011
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 13:18:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ifN8f/b7";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758806337; a=rsa-sha256;
	cv=none;
	b=rRoqzYKvRE2wj6p54ID4Nu82A+w7XDVFNFwfB3NW7zwqnnx5hVuzMlGQB6mi2l/uIumVKP
	nSlQwSRFxugnTLwLvyl6KMbEgNSSsl7A6PMKAGUsXkUyWa77XG8U+yS+B0Xix8Ls8kjau+
	9CicMl/aHpk22xWjKZDl18oQM1mgvxw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ifN8f/b7";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758806337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nx9IO1+XN+3QiLjrc2b+vVLahJ3Yrbnc+Ng1uv/ui2Y=;
	b=lbwBOR/p14CvBnI94ZJoz9qi9HWMDU83X9Hv5lVgqY0/StkOBBiD1JulAngjzpPBAUN/Pn
	EsgARwOS6JqXOILBQxpcLN0S9rtf6x8VE5eP1PNAN0LXFK1qoDX9XUTQEIWi3A3+DtVVJV
	BLBivyxCipdTKlYTW/KZSRnFiVHGI2E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 257B543B3F;
	Thu, 25 Sep 2025 13:18:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87DBCC4CEF7;
	Thu, 25 Sep 2025 13:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758806336;
	bh=KyvoIVO5yd9BSrcJftqBm+1vYzNbuC1mO8MyRdzIYcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ifN8f/b7xNvXk4yklfFciNbhLhFDN2pkIXiduF42mX7McmhVOTROAIJh6sdHzyR7I
	 IgdkvMQHVN0FjSppxopIVWhetGWpoc7kqFpxnE+6X8JlNiiR4kNGHaBlnLHPqV+PPZ
	 LOWF7+YNsb2VWjaT9ndJ/3LA6FJNOMYmVy49i8vb0YVcC4GME3GFK294j6S/HWUFN5
	 kcpF1JjtOTynLslV5scuGLfXWpLz9sFkXFYp3MulpMtWLJRadTHqkH3RxVyANqRyKW
	 uoJCxqeEv5HGx32G2ndbHij44kNTxzyNHZzLt4Vc3ZrDCB3RgHP7gHcSs7FXaQlGdX
	 dl7ukQUm8QdXQ==
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
Subject: [PATCH v3 08/10] vfio/pci: Enable peer-to-peer DMA transactions by default
Date: Thu, 25 Sep 2025 16:14:36 +0300
Message-ID: <79ffd43cd22763a376a3abc75fc7f9ed89ec9a9d.1758804980.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1758804980.git.leon@kernel.org>
References: <cover.1758804980.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 11FA9180011
X-Stat-Signature: wuyttu64w5dbq6xrzwqcy6ybhtuqca1j
X-Rspam-User: 
X-HE-Tag: 1758806336-793370
X-HE-Meta: U2FsdGVkX187UBLGeJFcdQWNV9fLreyXBLWmNI0kPf6HSr/fvTGxn5ZXleYDPLry0FCbA5Ee/m8cx2/mlCz6mCL0+GYypPfDwzX2sNp7g+8kG8j+u+PBqLhUdLMRU9PZu+7I6IaF7X6T4tvSQGCr4J6TsciqnwNb/+yG/NsYHdtIRlWdiC38dBaJXHFFr3sAq/nBMEPnsxmetFjLXKI95wpyMy4G66r41WUQJOFfO666vy5yYNYsq8rSmVHZfMpgUbrHpmmJGCGWo155CcXPQ2bWEprNvKw16nsUD5k9/wYJTwcHyG43OwUkmiTNh7AmOMSfBOSb7/21fGG2CdKmZd1eFZwDytECiUU1NZwKb7KAbo+V/BfXm/pd3mEE6r9caXWwoYmh0idqyMsgI0UxgYPMzFQKYLUW0LB21gHz5QVKLqKhVAIwjGQBcUlVbeVwu2xBq59yt27zd7b3utFAB0eXRjKO2TA3D43w0v1tjimIQpWYOw+bWJuqEByi5XCTmCLIT2PqwvqtBowE19WsxqRmnoJZau4Neg92khIl1mLJIP7OvxOrhrjeCXHxeZ4rRtPWFj476UEkv8yAwX2qDHT2Ex2hpUMtQw8t5RmzsdEjzKM8FeFjIm+bGTcLu2/W0uS4d2G8y2zLero05o4mkeL+5ToUBuayUutIufgNxIXwrwpaK41/PfHnRO8DZVpk8JOTajmlbio6J1IlrdRJ69j8jn2imgsQKLLz5IAPWZkplURfeLgynoBjdAc3+xcL0e67QAyOeY97nlu4xnHPcpQGaB2jmdAnihuhoC3O3F9qBQ+4rdQLRHqSNE+mcn9GSMm82F/f4brOb3Adh9RxxPgXQdq1ffKAW3M402i7KS3hyim1jNg7t7uUod1qenzRmUvCEqZh0FqEusFEfhbwnUjMcf25dfo9IU/6RXbVEDwJ53KcSlZfghdoF8/auAIbxSvusywWd2dqYQFwa3h
 1CFauGq3
 0xhKpElEjGy5JAuwIvu+gBhm6TCeiFZ8aIJcfgyJNRsd5hLbc+vJzKUGIIBjPXMxiX2ZrpMI/ZYE/EAKFSrS31v9We7XV6IHMr6UgbXBZ0nk+HZ2nZerJPNdJcRD+RC+jK7jNCJ1CR2jN82KtJ8dnBl63skotgEgF78gnr7AOT87AzuY9uSFWykmAClIFnxaPGgFaqdu9aEaIrBzvjJahmLWMnUMCLD1I76tKLcM2ASZaC6RF3n7hU9Mfxa90E8/Cn7yrpr6bcbMqtrmgHPEpJfCJIjTep+WaML3PDDwqVyv7VfQ=
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

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 11 +++++++++++
 include/linux/vfio_pci_core.h    |  3 +++
 2 files changed, 14 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 7dcf5439dedc9..356a0e2fd3780 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -28,6 +28,9 @@
 #include <linux/nospec.h>
 #include <linux/sched/mm.h>
 #include <linux/iommufd.h>
+#ifdef CONFIG_VFIO_PCI_DMABUF
+#include <linux/pci-p2pdma.h>
+#endif
 #if IS_ENABLED(CONFIG_EEH)
 #include <asm/eeh.h>
 #endif
@@ -2085,6 +2088,7 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+	int __maybe_unused i;
 
 	vdev->pdev = to_pci_dev(core_vdev->dev);
 	vdev->irq_type = VFIO_PCI_NUM_IRQS;
@@ -2094,6 +2098,13 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
 	INIT_LIST_HEAD(&vdev->dummy_resources_list);
 	INIT_LIST_HEAD(&vdev->ioeventfds_list);
 	INIT_LIST_HEAD(&vdev->sriov_pfs_item);
+#ifdef CONFIG_VFIO_PCI_DMABUF
+	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
+		vdev->provider[i] = pcim_p2pdma_provider(vdev->pdev, i);
+		if (IS_ERR(vdev->provider[i]))
+			return PTR_ERR(vdev->provider[i]);
+	}
+#endif
 	init_rwsem(&vdev->memory_lock);
 	xa_init(&vdev->ctx);
 
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index f541044e42a2a..2184ba65348b8 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -94,6 +94,9 @@ struct vfio_pci_core_device {
 	struct vfio_pci_core_device	*sriov_pf_core_dev;
 	struct notifier_block	nb;
 	struct rw_semaphore	memory_lock;
+#ifdef CONFIG_VFIO_PCI_DMABUF
+	struct p2pdma_provider  *provider[PCI_STD_NUM_BARS];
+#endif
 };
 
 /* Will be exported for vfio pci drivers usage */
-- 
2.51.0


