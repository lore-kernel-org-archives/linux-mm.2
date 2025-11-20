Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7C2FCF8577
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 09:29:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D07F6B00B7; Thu, 20 Nov 2025 04:29:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 280836B00B9; Thu, 20 Nov 2025 04:29:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1215B6B00BA; Thu, 20 Nov 2025 04:29:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F029F6B00B7
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:29:32 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B42805B267
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:29:32 +0000 (UTC)
X-FDA: 84130462584.07.247B0BC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0B86B4000D
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:29:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g2l4BV16;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763630971; a=rsa-sha256;
	cv=none;
	b=NoesaUJVuyqkL783PD70Y/L4WXw/DCB2AP32sY/wvR0KsnqaoHf4dXP+J2Q3Q3ga3oYoLh
	0G5JkfOraiJNoxAOr5CWdbe0I+ACnGeD/oeskbYdlhNOAWlwDME6M1qS0w8PGWrE2JITFR
	IyTUkv6XCNN//6qgl7bD9Vyl/gVwmL4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g2l4BV16;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763630971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cSmPd9tKXH767QlU7X9OY7oXxQPhEl2IID4D2NFVMKs=;
	b=YxxaZdg7SgmgvvKv0Z44vdCjopF830y845558Qdnp/2a8YxW+uwuXjosNCeO/oV6v16Sra
	n2dbQU0vlt6LUyRTNOUqRRKZaDlcNjaZhndM3X8MREJpPRv2lmISnrXilRNWqzGT01Ogdy
	Fp86xwxiCVRdKPeIqWqBA+PVKCyueHo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8683F60174;
	Thu, 20 Nov 2025 09:29:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DFDFC116C6;
	Thu, 20 Nov 2025 09:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763630970;
	bh=TYZN/mvASZVK9qFe7+ikMiLynVdctM3LNTh3cHN7Nb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g2l4BV16UqpfJQIQxe53UwLkUgeclXpzgA/cFuTY0DizNIs8fLTtXdJjVUpcCJxar
	 jYV+7Rsr8RLZ27pc+2tQmbQkwpqYzQcY2hgAizwcxswbLH3gP0GnGnqVLbKYaNBbJ7
	 +DBpB0sc3mFOe0PaC727RO4U75ehgm3/Z36NQ0UHXkJ4Ftvnu24r1CdqkaGNwlIm2s
	 v3QD76BVntv/d1+THDqKCNcH2pCEDO1lZVWqZFJ+2MvwmzOiUf9v1SommTLXWRQHWH
	 CkiF6pX8hIM4+FTq/NCnd+b2iRvTsIkcDvy9a4+AduKgjEgdD632hrpgr3/2p0ABQJ
	 kohkYric/6tNg==
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
Subject: [PATCH v9 09/11] vfio/pci: Enable peer-to-peer DMA transactions by default
Date: Thu, 20 Nov 2025 11:28:28 +0200
Message-ID: <20251120-dmabuf-vfio-v9-9-d7f71607f371@nvidia.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251120-dmabuf-vfio-v9-0-d7f71607f371@nvidia.com>
References: <20251120-dmabuf-vfio-v9-0-d7f71607f371@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-a6db3
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0B86B4000D
X-Stat-Signature: 6x4kh5mxq1tmi51wdpfca7oy7g78pr9p
X-HE-Tag: 1763630970-581524
X-HE-Meta: U2FsdGVkX1/Nz9xWIEVq7Ber6teP0x0jOpFqaLnbs/B/5AGINSPJnh3fdmz/93H6RTGAfFKF2jz66Fj+YQ16h9gk5fy9s8PiYF2r6i0cUswLGBSrVIQNtvqEcrmnw58HBdTQ5XuUSC8lbykxrZRqCgq8f9QkWU1OsU6D8kogXMABMgtq5WSef4S6LSYZQZiyvW+PpHycQxpY33MoGMb5QlnQ9g8RdlGDtvi5MQe1OwhLAcwTKp1xS+E2toZpJoD9tf1Vv95WoX1QDUQBWwCh9ZBv5Ci5Cm9JmASgZY8Ox7BH/Mf3GWLH97fqxtDGN2idVcf/J3v9Kb7tM1p9sebLJ0v+iyzkfplZSpLbH1pQpr4nXX8W0c4eHImWpQGnXCc7eXa2ccakthA+lcs9+aFanWmcd8FnIB4J0vuVprBQYiXcWGyJVtIHno09tu7HBedOAQMIXl4ZTwgYFFOH++sIrl/OLlB01zkDmzypyzJ0dUWGIat9wOxAuQXDVNrnQpAHSg+bRyFe5pDcr5kJKYEn6Hw+69wPQa7kEMCU3DX3UpgivPSFKQ7HrmqrlpoBZKAtHCthGatkkj7zD8LzblOnvJS4OewJPv1jDFDSdo8TyWDh2ELXuEL6B7aHgvuFfLIqiC1Ox/xVfRNH3Ginj10bnzstXssclAkRv3fmMh3/1wsHWVP5oS2/SR1TcbuIOmFPVKkv6PrWkZ8Iw0/URZzyP2aarhqA8Hak1FG3K92vUELdBaO+ffhb6fKQPMmevF47zm4W0rJOBelgoD3xVL/ItJb1iOFrgh24YqI+wASGgaK/JRsbc83PSRH+NWC/z4EaKiLScUckJzHOR2x2gP4aFswL4pIgbeXg6Els402F2KqmDpv+WEcGeD+W9HE13mBK9WmQUL9akK2jgr/HIuRABuh6xbsoQekr31MlzuyA4DZKHEPBb5n2ygiWtKGLeWzy9doUQ3RiRmBfz5twobI
 4YmBk7HK
 uepNEe3V8F/jf+N3I/XUJkOHeLOQtXvQgelHt3FgvMs+57zxLWIOZwHb6+Xe2dP7IT0xdRzNUgwtyLFgxAxLF4Ocio7YNZS/yORXV+8VkpTgWqHKDExr5h3xGLv/N1yEpwtHL1S5L/4qyqdUsvDXTOW0O7G7jnu4rtsJYQuBvnBvN1pEze7Ir530+SnHROTx4L/tbogys+/FCFCgt5XHb9fGVUJAQzDpTQtMSBL/mNRcp96Z8HaUTOm/GEHVwjT0icRE6
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

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
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


