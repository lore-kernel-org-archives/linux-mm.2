Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2AB6CA1016
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 11:34:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4ADEF8E0001; Thu, 11 Sep 2025 07:34:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45E5C940008; Thu, 11 Sep 2025 07:34:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FF678E0007; Thu, 11 Sep 2025 07:34:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1CCFB8E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 07:34:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D3BE513AFB5
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 11:34:15 +0000 (UTC)
X-FDA: 83876760870.20.B4BDFE3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1A1AB40009
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 11:34:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ad2yV5YN;
	spf=pass (imf17.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757590454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=752B/BBs3ap6p0gS1t/frP/9I43EPABrqJ+kwMeMoyg=;
	b=zE+EXV9ZUGQ5Od3CMzHEVwAf/c+yiWOrcE5+LhfdobFCw+ss8mLAHpdZuDREA9BWkmP9Bq
	WI6tsDf7mq/cW868zXNpTOZuVRKoS09ica51RxaCuybv6LjVq64bc2Ca6JsKoqKu4ExcYd
	/AhU+gz521vyU8uXNl2A/9KwTFt2HMM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757590454; a=rsa-sha256;
	cv=none;
	b=5GpAxf/4X3eHdMNh34gj6ZVYqG0arS9rKJ44UOufOVMN7KEgc+asr7t5blpftCf9466+f7
	cEn8naVyGg4NmJZXawj1ynek55AsOd8RYCi9ydkfvTD+37qLrq61oivZyDNaeDY2zr56SI
	1te51HArVebouJMUMblL5rGlOWPeCJ4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ad2yV5YN;
	spf=pass (imf17.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 297D440899;
	Thu, 11 Sep 2025 11:34:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74F21C4CEFA;
	Thu, 11 Sep 2025 11:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757590453;
	bh=mSqO5z/pzcDb//9yVcXdFaM2PL2BJKuKbGZo2SMKi0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ad2yV5YNeoJ9zzsdaHBjO699sFgtNfEpNes8sd89X4omIZJ0YEBy1O3hp6lny0yrZ
	 ILWO5eA0XWuT9RzwLMcDuv6Ntp704U58ULZdRrvE0BRzdadauWkHDNUhlIy8diW1Sr
	 y2192xF79yqliPNZoabgcXQVuZLHO4PMDutNKFhydmoevRH0wase5xQGcjIK3FY0MF
	 X68jQ0rwPyOETqlGGi+u4y12ceGmY4P7LGDzXxyCxL6+cmnuL8MODVCaf7moeka6WD
	 3HKhRHP7rRXVx3CpCriHEXbkddLjKiLXtEypIBzfxSe7hBKwxGoElFYScXxEcY8u6u
	 LdzxlHXBI2jCg==
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
Subject: [PATCH v2 08/10] vfio/pci: Enable peer-to-peer DMA transactions by default
Date: Thu, 11 Sep 2025 14:33:12 +0300
Message-ID: <536369328cdeda87ae37b37c63f800d38186034d.1757589589.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1757589589.git.leon@kernel.org>
References: <cover.1757589589.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1A1AB40009
X-Stat-Signature: smrj3jidffdds11zd5ki79itkzmjkqoz
X-Rspam-User: 
X-HE-Tag: 1757590453-420096
X-HE-Meta: U2FsdGVkX19A1S9lPFzlZA1ZbvzVovX4qgS2mWiDxmbkXFsbXpARQs0AeFszrClyjL3xmzYM3uofhyf1RqMjFL1/2OPzeWl7YrA+pPwEajWEKBIMblj4WXGwG+B32bRCqQNX8Tbdgf3I8ZARMNp30h4FlxwOmaL/qz/yFetc/F89AODmLNNGmxMNJp1ZPrQpuCrf2MLEcvoSEew+WqCleRHxMCuDLDNAUvCg1bu1EQ0Dax25q5pFrSbDF/BVUYN2otXoGRzsoJ5V+K+irrlZJdq6ngtXkF70U4vjCYVvBoqgFTQZxlay/AAR/nWvwDAc0h9PVNAoNsXNQQkHr9+24OyJRXklr6QoqsMDs6zdRww1a6pubfceH3bT1KnIHu0vQ5gXxTyKecIpNkSILQG+KurA0I6DZ3Wu/kpk7FmQBbt9wYsBmUHDwHphV/lhVimTVwXCYr/BK/Y2Phq3hYcbHjnPX83Tk9nTQAJtrxyhMDdn4OfecUAvyKx8+3qR9ji9fzr5uecyLAdGwbK34jUElwTGeN0m1HNhMozLxCbRGM/puTYwSVXPSIyW2nlidea9nBTiy4FNBRyG36PQY++k4zERhya2CybCS+sYF3GT20mlWqT3WpvUDRyxkT70wK20R8haPGHQ/8sUykYQixn+3wTBP0aLNE2mSR0sZ+0EuOZPYFTGUJO1RIDxiFceY+Q4p7goBxbYgdSy2dx+aCfh0yfHrckW5GPRE2iC/Ac2blFeiSL2KnaKJxSAvxM5xxFRXpZZLEIPpJmosxetx+QePP7Xb6m3LBmMtiMHQdmaZcaE/ZmyOBaQ3BpCtps+SHbWACRCwNdLLgL/YuFKfW/BzjGc3/96r67dd4IIA1o6BhmOhbCxJpAErFRfWU8rgUMKswilufGik8Pr5CkubmGAciG/PKwkEzhvKsK4cobRqBXLr62rf256HvhA3LacRlSA3/ki0dhwEU7guAGCoA7
 98MoBu5I
 oS9xcwJOZBcfGRc7RRI6wR7zbVlWemiMFqxzSP81lAnro6kNRiTFp94oq3Al7zt9GKFwxX3sd5/cLDSXY38Py2LiGjgdtn0CmbiPxOGVun/KoYEaWM7Ow6HHrWQzSfmXpy4B7TEJVkLzYxuUVWQYn4FtsOA0GWHGIwI32wZjBF7umkdVHylxAu19ySoGERlL/f2CiyO26sFKfC+m8nLM66+9lLmlRUkmGVIhy5gwk5duachEtIyUQHrJRxJHuAVpLJo18BPedj8gHUAdtWNx+QDCiThYBLlYNQZQTJmAKrW11+hw=
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
index 7dcf5439dedc9..b02dda8c96341 100644
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
+	int i;
 
 	vdev->pdev = to_pci_dev(core_vdev->dev);
 	vdev->irq_type = VFIO_PCI_NUM_IRQS;
@@ -2094,6 +2098,13 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
 	INIT_LIST_HEAD(&vdev->dummy_resources_list);
 	INIT_LIST_HEAD(&vdev->ioeventfds_list);
 	INIT_LIST_HEAD(&vdev->sriov_pfs_item);
+#ifdef CONFIG_VFIO_PCI_DMABUF
+	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
+		vdev->provider[i] = pcim_p2pdma_enable(vdev->pdev, i);
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


