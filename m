Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D11F5CCF9E3
	for <linux-mm@archiver.kernel.org>; Sun,  2 Nov 2025 08:01:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36D0B8E000F; Sun,  2 Nov 2025 03:01:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31D028E0002; Sun,  2 Nov 2025 03:01:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E6048E000F; Sun,  2 Nov 2025 03:01:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 044738E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 03:01:56 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 94EB612BBFD
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 08:01:55 +0000 (UTC)
X-FDA: 84064923390.26.7B2DC62
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 01EAA1C000A
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 08:01:53 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V8cZCg+G;
	spf=pass (imf20.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762070514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FSMZ1gz/paYdc9wCux4QR9CCFBF3S6LbaeB7FwxEYTQ=;
	b=5QBXcjCeGdRIMkDGPjq3z0NqRj9VEkZx5zHlsVzJMDd8V73AeMR//E0fyOo7fweGRa1MFI
	i+zibAH1J05uVU58kOw2RFvYJnpKLix3JUggB+NERHXHdSUy8pBWuXexJv57fuA04DuaDZ
	HGdQOjX7Vbewx0DwL+NOtHPVRRkXsr4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V8cZCg+G;
	spf=pass (imf20.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762070514; a=rsa-sha256;
	cv=none;
	b=l8OnLG1c5tiWoviKsan4XkKOuewVot4Yv20mwjUslA2HA3zp5etm14Uun+DbZEAP3U57I1
	G9XrOAoF9+0qQBabaXR7nlhIghYvNhsudHGTZc0IknP/a4lDVpYz/VP6pRqmLR2x8HEqC1
	kyc7H+J7HC7DckPVetIZdbH+WFg7XPw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 54DC7601F8;
	Sun,  2 Nov 2025 08:01:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 587D2C116B1;
	Sun,  2 Nov 2025 08:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762070513;
	bh=uCY80udWH1E5dnNUaTEth5SWNH14l/8yeNTFZKFyjkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V8cZCg+G2951KSUZxkFRwAN9P7XfvYitAfCyWmeMXKS5oM/ikMbrBB8vbt9O8AFmv
	 D0ae2XJQk2A/zCNKd374QwVpX5qV4Q9+gyZrhBsGX4epyM882G4Lg6gYIi2XfB9vr3
	 3V4SLGAgqvQB6LXe7X18+BskZ+O41JrW+lgepSk7c5CTE87Ju+Drlp+3upPpfzPtM4
	 /jmlMcgxezSjBLctTMLEOoCghOiKWFWXFG8omUipiue3Tbvc28tM6RbLU0p8JDgLET
	 Yo6QbRBWc6KdV3UiNxmxppf4/H+nqqEOM6GUZD/mIQgvgk4UgGbakUTTb9kh7kxCMa
	 9ZEIZqV6cGRlA==
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
	Alex Williamson <alex.williamson@redhat.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>
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
	linux-hardening@vger.kernel.org
Subject: [PATCH v6 09/11] vfio/pci: Enable peer-to-peer DMA transactions by default
Date: Sun,  2 Nov 2025 10:00:57 +0200
Message-ID: <20251102-dmabuf-vfio-v6-9-d773cff0db9f@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251102-dmabuf-vfio-v6-0-d773cff0db9f@nvidia.com>
References: <20251102-dmabuf-vfio-v6-0-d773cff0db9f@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 01EAA1C000A
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 8rrjcu6b5efrtt65x5nb9dbuj6yhduzc
X-HE-Tag: 1762070513-902981
X-HE-Meta: U2FsdGVkX1+Zd3Nf1XbEvMPucPF2SKc1n4JPvkcXpKkocL3kZfhLtF4uj/K5neoIswv1GJD6tl2VoWS2E+RXhAWWH4b+XXwiXQ2EZTERDN11pcMIDRjy537JOohtP+mniJBg8DuqJEl81Qumugb95Mr81NK6NFJSsqk5OYuKqHyJhw7Bz1fT85e/KN9SRP+4D0Gy19+kCy8dUqEkWkC80b2DWdh+xFVHd5JUMePBAaTJ7Tdg1s1MdKB5mHyBfRcOpjipy2gIRAZDKvCayiQXfQb8mPgQj9Fd6YeS9wK2darAKwzFBE8omPt/SNZzwuIZ5QrzQ4kHAWaizXOzy9R2thuGo1rBtUnXZNmI0+88efSuPJS4+RnBxUOoqYEcprFOWuTTjCPl9K7MYy8Toz6HZ5Rhw59/dFM5DtzkTykE0jr59lUWyjat5Kpfcr22gLso5eBipxQqf3GXrikQ5pWv+MFlXoaKSyS/G8XbgkTnt8H6h6E6159VzcS5KiTERXXX/CmcbpkZcI2azG3FHSrPtPfZj7j4Jriv2gcXioNFnuiQ0qLL28UoTfkLVDdDFLRbCYPDPBtB5GVIS0OFpy9ZDPHLGTWx8QkKq+IhNOtHRIfgd9RhNE/wBiAIKJniNvBG/WSrTckOJscLF4wGu7aisQmepsKcqNpB5mLOLUt8tzsUawr7IPgUFndSu5HdYQ+gizkz1ASi+CdyowqvHl+kRnhdePF06s7/OkMyoVgDvf0J4fYpVnRrU+Evd4WizUJEc5+F4kBJ1bI83tF3bxkfBAxcoSazEMMvdLZ/my5wazGKBTbdYG2Fxxu1F+dQ62wruxy4S3GxgNmIb6zVo6WY2SnRmRJ63bI+E48qoSvFbpWB/7VSxjcPpAN3ePF5nBSKgiV4sblJ7kroXIlyNEWENrGaCQsKLmLJ1O6+CCjxzJO6NZHypzHtH6+4RYJmoz80BrmXdyavQiVcl2Zj89B
 6xLttG0j
 MpRiS/Qo74x1LjgdBcxJzmnHwCi7wVG6EUV1zzA7RjjqZxqigHIMwLrIM2jPPt5oz2S059nztr05ZBub4DaZK3vNYUdOXJB5IX5M/tg65cpyGKFBlT44DVtfcxttXIl/RaeEtlNF8/rOR/dXX+hWdNlmWuQgyGgeOdq7OlXwcaSdEwRmgIIICL+sXxwiPZdAY6qO1Tz1OE9HEaK/XWZ4OJaWsDyDC4R1USnh7rke9wjn48g0=
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
2.51.0


