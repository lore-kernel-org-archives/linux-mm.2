Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A7B3CAC5BB
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 14:51:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92C588E0010; Sun, 28 Sep 2025 10:51:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DC838E0001; Sun, 28 Sep 2025 10:51:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A4518E0010; Sun, 28 Sep 2025 10:51:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 66A178E0001
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 10:51:33 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0025E1D8B3E
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 14:51:32 +0000 (UTC)
X-FDA: 83938947624.15.8C40CDC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4869F180008
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 14:51:31 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MXWBemys;
	spf=pass (imf06.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759071091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tgwQ9hlmWsCgJjn2J04tD5PsR0XsDqgaLXM3MVGznVU=;
	b=h8RTA0x2BZUXq73beNPY5/5Tew6b/XVgcruTUcuw4bAPREsLFpNqVizJs96fNDoKZzE4B2
	FZoANLLZ2bNHCU4q1BZ88Ex4hk8LPp2GZcun0ujsDBE2MJYenuK/k6ULCgCrgpz0Fra1Ti
	joTP1fH1kZ9IuYJSi5XEkBNcIJimIrw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759071091; a=rsa-sha256;
	cv=none;
	b=DKU1PmLr4qpPOjLN8wfcSmCjBWakKqgXejCwUPz1EH3LXJ1TzIFusAvOprGu1XwtkxJ+SS
	gC2oeuKl52mlmpbtpwCzcg3LwXTj7Nlgvag2TAzLdZx2JdssxN93asnXI7qoyn6QC9hnU4
	3Fhb0QWFTgLGF2kncwPOEjokSRewdM4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MXWBemys;
	spf=pass (imf06.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 50B7145EF0;
	Sun, 28 Sep 2025 14:51:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE71C4CEF0;
	Sun, 28 Sep 2025 14:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759071090;
	bh=eDZRe+uiWG1FtMFnPzVJnvcS6Jw2rXL9T58ek6nzrEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MXWBemyst2DNL4Nx0TAlj+1GLFiWX9QtAuizKw6bPWVd+d1GjMbABZgdikCVqKrNB
	 k+ekJUujdc+dXJX/TQGz6h7B/KkC2ygc3ieVxnnAdlZflRhVo0EUuZojYmcH0lKr3r
	 NgFC0Xd24eGucNH1bDepZ10SkBSL4/4HS1VWSmKckK8PjHAU/cq6pIkwCyjCLl2vU/
	 uVzKxC18j3BNJHGLIpsM/zz7pFrvfWFIJxSMT9bPpnUo9KwegpIbpNCY+YyYxSaXQz
	 yJDhBxW2XHOS3xz779v9FPbbO+dCOxaMQrwRKja2yAPZOzMVPs+BFtKnIawYwXFApC
	 PappgcsvPHiOQ==
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
Subject: [PATCH v4 08/10] vfio/pci: Enable peer-to-peer DMA transactions by default
Date: Sun, 28 Sep 2025 17:50:18 +0300
Message-ID: <ac8c6ccd792e79f9424217d4bca23edd249916ca.1759070796.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1759070796.git.leon@kernel.org>
References: <cover.1759070796.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: q517q356ftde37bt8hd6m4eja4dgywpb
X-Rspamd-Queue-Id: 4869F180008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759071091-72901
X-HE-Meta: U2FsdGVkX19uD81U23YC/KvubW1M/Is7WQC7WJ54m3MyLMQ26FWzoyF+aCxARLv4wardpLNohwHQReWj6dc3mPVeVh6tBGxzIoYzUqLapbJ5BiuSOXvSSTYkmBKcYRwp2fz0+Mn7IZqz1f5nqhZISOTwUuUpnkLegbNxUObd1iG4PEhNSxXZuKkV9PrLxItkA6tvVQ9AzCm2UUjDTa6UJwbgLv09HPZ2jftc6EkRT3pTVhnVFgTN9XvsJKuxOqyluc9N/DFllVXYPq/coo861cp/dmQfWblLOTrX3swset/uGU3dwhqB2zQboQyozfs+eYwrTLu657vp7PngzZ62txPG1PuBBQ65cZAX3WhJKx/6GmvAUC2Q3pllGU80NUC43uAGo2ahwLh4sPYXzj+FsJTa7Jy9buVF2WAQ5nhRLMldSd8CSNFCBI+x+qrrq0kgwzZCWt07eiwpOsN8FQoUHB0k1dQyoMaM2gLcOQTqXl/zidSeaH27bEG9O+EKEIFbGCyxhNUA4o8F0mu5VhMEsK7kgHCOM6/zcSlJKgr3Zi/bQr1UsWtaw525yGq/On87y+LXUiiEaoNOeQcG7ynBIet2XE9ZA73l1uiJNPZaN3iT6lcz+fIfxNLlrilfFsYlAF27wE8RPEZKgYinQQ6aOgRRrgpIwWB+qsEN/9tprq+bHI14UColJCxSX9v07W/GCtZaU/6/06WYEOUMS5Z+eeE2Y8wBUoEM7MYiuEW8mopadGffrUWJ3rgxVvn2wBAtAD92VfVSaX3m7EL0x4wUdVMaHLtLSaz9syrFHpFEt9GCLrVfHXjbVUuu4GpX9ZBX230X4hGf+97rP3zhgFCuq6WufaM7GKUG6RwOmwpYzU1OyI6hRV0CBBldnCpZBMVfnyO9Q78EG29GHJfVGKmRSnzfKa4po00wz87DD9+BB15kbS4ynN7MbJJdlIh1rklImzy3ehvFlOUwyTIRtdF
 Avkc+QKk
 J9mp387RbuiFCNVAoG7Ax8fYDqe4xdTxJnYry+xI5xs6nrFz6ksOhC4tJrqQ6/kvEXYg6mDoZrV0rSJAjiy6SmCvkLgS6U89c6OTzlfVCxhSSRo5VJ2IGr8TujFjHvaZLHcLFZR/frkY6NqVOFIqkSnQOAO78hk4hXrYLWwVP0l+7vp2NL38LEf7M6AOP6T8v3QWe9s5GlAbATFOS7AVZ9F5fNKVkhul9VLpREvRkBS+lLStCcLE+MGxBo8YfE0DRY+DdL7UW0jIgUM1hl9kJFJUScXjGu0TtiKZCQ7ZYV0cnZ2E=
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
 drivers/vfio/pci/vfio_pci_core.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 7dcf5439dedc..608af135308e 100644
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
+	int __maybe_unused ret;
 
 	vdev->pdev = to_pci_dev(core_vdev->dev);
 	vdev->irq_type = VFIO_PCI_NUM_IRQS;
@@ -2094,6 +2098,11 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
 	INIT_LIST_HEAD(&vdev->dummy_resources_list);
 	INIT_LIST_HEAD(&vdev->ioeventfds_list);
 	INIT_LIST_HEAD(&vdev->sriov_pfs_item);
+#ifdef CONFIG_VFIO_PCI_DMABUF
+	ret = pcim_p2pdma_init(vdev->pdev);
+	if (ret)
+		return ret;
+#endif
 	init_rwsem(&vdev->memory_lock);
 	xa_init(&vdev->ctx);
 
-- 
2.51.0


