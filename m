Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73351CAC5BB
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 14:51:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD4868E0006; Sun, 28 Sep 2025 10:51:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CABF98E0001; Sun, 28 Sep 2025 10:51:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE8FF8E0006; Sun, 28 Sep 2025 10:51:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AF7B58E0001
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 10:51:06 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 764191D8B3E
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 14:51:06 +0000 (UTC)
X-FDA: 83938946532.16.17469F0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id EA44340002
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 14:51:04 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p1lrDqVG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759071065; a=rsa-sha256;
	cv=none;
	b=OKS5bTIPP3iRdv4xjE0soXjC8uPNO9dgDrdoltIkR+hzpLLEOsY3e+nEmv59kagxEdyJj9
	V4bTwUTCSPsKGZ/wCjlXgm1VeU3W8BR4Q3MWAZnWMPU41pIJN7baTDJSQx3bd9iyNJNaPw
	dn4/zA6EclJ8waZBHX7KiaYcHYJIS7Q=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p1lrDqVG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759071065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Jm40kIh6FnXnSS2R1qDI68TzWDyOgXZmgtX1QKTvOGA=;
	b=6bz3WLNEkhXAWfnNMLItCQjAF5hjLg5goOHacQeWirdqIZB1oBzIV61YZlKMz1RP6FREAU
	mBFaKxWFQ3vAF17kQuzwa1w1m9XQ7jRKbPgyUQKYo/+3xLciTcJdox6G4bO35A8PZowDDY
	QN3A2kk5TORv9Dm8xXzurI6TEjeXXGY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0363A62175;
	Sun, 28 Sep 2025 14:51:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12B8C4CEF0;
	Sun, 28 Sep 2025 14:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759071063;
	bh=VONrYQxoP8oMQLxNnSkk6QmAw8wYtiFvRYSA+pjUd/Y=;
	h=From:To:Cc:Subject:Date:From;
	b=p1lrDqVGm2h+IqmbzC4UeijKf/SHWc96sqEQB14/cn33jk/4ux8kg2qVwIdK4UCpD
	 IMdOltqVGarClLfgYb5XVTOwWA+k8XuhwlcMjKhmhXpYAfmib613trJBppLraR6Wu8
	 c2kfH5kMirZCHheP+4wFCx7QF/33w6BTMVk7ga7F7wtVipUwR6ihbsyuG20ou8kDk1
	 n7Yk0lGafNQ2GKdPzJIcwuNthHp5p1B2AtWUTZz/ZrBu585+LFPUMVt4+9TRGc2k8d
	 iS7qUSt1b8trgjdkGXO9SBYuFHbCnFJCHOBZgNPacPxJDLTo6w3CwRMHhp3uvPGGod
	 1b5YsB3cm6Bbg==
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>,
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
Subject: [PATCH v4 00/10] vfio/pci: Allow MMIO regions to be exported through dma-buf
Date: Sun, 28 Sep 2025 17:50:10 +0300
Message-ID: <cover.1759070796.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EA44340002
X-Stat-Signature: 7gx73dx31131umd3yceqahhrigjaiodw
X-Rspam-User: 
X-HE-Tag: 1759071064-864422
X-HE-Meta: U2FsdGVkX1+syXrhUmWHk7LOsCE1s51QCXEw+Pomba3fFxZkBFNKI27+n8XVDHrc/HXG+wJwUsP/fjGyAIeHqs1ZYDJcBnWgyu4qalvijQW05E9vBvVWI5Rg6prF4SvjD47L+VEJ7/tqxszKU6PyK8Id9j/ES/Pzz4SATILdJMjnYJB0jRzZ+L1S8DUXe2N2elEiiLHYdaH3emvFPDqCVY5IUQEOak3pSICXWqRAxNYnNVBmuDW13qmWZuoCMoIAaExMmWFGC8GhhSf6pzmRkrb1GK4iScTQQV6S2aZpSOZ7SCqff5C/h0qvo3sJ9NHAYfUCH5/1ZCEmJE1yoR6RUclZqo3mJT+ohYy0ljqmxrNASCKFI1chN0t4qabi+8q/u/DZDJYk4OnW4oLZdYcUWa1FmVSkxTj5ExMXIvMP993lhlKsc49vrN/W2LKN3GDXQbvsnCcJziiSpXT0+NPc0TwnZZ4NYwtDIkpp9iJLQ0W8nmOjszmhS6JRBMEFIUT9T9ubDRweQQL1Vv4VcQnRwmtF+qSZ5OqB4S2xsrqlJlSItS9gBKcR6oogvO/4ow2Vqn0mM1URWFHc6Dva2Y4PoaV7FHJX2lLJhpU3YpRkPUHzbxvG7xqDAURPZu6rm1xdblpJ9HJKM0PNbnlchyf/OuGFErr5dPPwwFs7bKrFBQUOa5bi+bAsoZoyI+fNoDIhYn1jzODtYL8j3LHOzyYswwgVugTMFWCcguSFrGo5nWvXVFFlSti6vFHbMVj7PZ9NzLkGKFV6ABOlACSPa3kt5yYe80HHbrU6aQvp+LeBPdbegYCo6webpM7bRQ+jKphP6yTuFHOM5EvLV6i2sAOVYGMjNKYYc0Z0GepV84Say/Qhl+DQIKAi2tDFi5X+7WhPrW729G4fGmkwEYAYVC0eYNHtxrkPf1htXn4WeLC2CLBWR1g8oudY2my+JtrQZwnz5WqDHBmIvbGwVSgmR3N
 Eu2VOO1I
 mkh8mDse9cDHOhJxYfobUNnrYkb9LFtWcxDr4KGIpfbhCXWuURsuAGSIQ1wmv+lr8gKx3h+Gr22fsscz34bY18O/ayOPQH8GYgrESeIt6Shiqw2zfY79ttcelcb5HOIyNy/93x5uoHLNbU5AsW2sub574hp+AitX5AM72mnQ7debVWuUyagq9fWZwrQGZtX+f1jSfXL1VTqSF5+gPTm5uCgNjqwV7OtE3h+Iu6zXGfAazbAKdY6wlZfxSjwTc605/v5ONPypgF3X1DVAtWtOwpIOdrg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changelog:
v4:
 * Split pcim_p2pdma_provider() to two functions, one that initializes
   array of providers and another to return right provider pointer.
v3: https://lore.kernel.org/all/cover.1758804980.git.leon@kernel.org
 * Changed pcim_p2pdma_enable() to be pcim_p2pdma_provider().
 * Cache provider in vfio_pci_dma_buf struct instead of BAR index.
 * Removed misleading comment from pcim_p2pdma_provider().
 * Moved MMIO check to be in pcim_p2pdma_provider().
v2: https://lore.kernel.org/all/cover.1757589589.git.leon@kernel.org/
 * Added extra patch which adds new CONFIG, so next patches can reuse it.
 * Squashed "PCI/P2PDMA: Remove redundant bus_offset from map state"
   into the other patch.
 * Fixed revoke calls to be aligned with true->false semantics.
 * Extended p2pdma_providers to be per-BAR and not global to whole device.
 * Fixed possible race between dmabuf states and revoke.
 * Moved revoke to PCI BAR zap block.
v1: https://lore.kernel.org/all/cover.1754311439.git.leon@kernel.org
 * Changed commit messages.
 * Reused DMA_ATTR_MMIO attribute.
 * Returned support for multiple DMA ranges per-dMABUF.
v0: https://lore.kernel.org/all/cover.1753274085.git.leonro@nvidia.com

---------------------------------------------------------------------------
Based on "[PATCH v6 00/16] dma-mapping: migrate to physical address-based API"
https://lore.kernel.org/all/cover.1757423202.git.leonro@nvidia.com/ series.
---------------------------------------------------------------------------

This series extends the VFIO PCI subsystem to support exporting MMIO
regions from PCI device BARs as dma-buf objects, enabling safe sharing of
non-struct page memory with controlled lifetime management. This allows RDMA
and other subsystems to import dma-buf FDs and build them into memory regions
for PCI P2P operations.

The series supports a use case for SPDK where a NVMe device will be
owned by SPDK through VFIO but interacting with a RDMA device. The RDMA
device may directly access the NVMe CMB or directly manipulate the NVMe
device's doorbell using PCI P2P.

However, as a general mechanism, it can support many other scenarios with
VFIO. This dmabuf approach can be usable by iommufd as well for generic
and safe P2P mappings.

In addition to the SPDK use-case mentioned above, the capability added
in this patch series can also be useful when a buffer (located in device
memory such as VRAM) needs to be shared between any two dGPU devices or
instances (assuming one of them is bound to VFIO PCI) as long as they
are P2P DMA compatible.

The implementation provides a revocable attachment mechanism using dma-buf
move operations. MMIO regions are normally pinned as BARs don't change
physical addresses, but access is revoked when the VFIO device is closed
or a PCI reset is issued. This ensures kernel self-defense against
potentially hostile userspace.

The series includes significant refactoring of the PCI P2PDMA subsystem
to separate core P2P functionality from memory allocation features,
making it more modular and suitable for VFIO use cases that don't need
struct page support.

-----------------------------------------------------------------------
The series is based originally on
https://lore.kernel.org/all/20250307052248.405803-1-vivek.kasireddy@intel.com/
but heavily rewritten to be based on DMA physical API.
-----------------------------------------------------------------------
The WIP branch can be found here:
https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/log/?h=dmabuf-vfio-v4

Thanks

Leon Romanovsky (8):
  PCI/P2PDMA: Separate the mmap() support from the core logic
  PCI/P2PDMA: Simplify bus address mapping API
  PCI/P2PDMA: Refactor to separate core P2P functionality from memory
    allocation
  PCI/P2PDMA: Export pci_p2pdma_map_type() function
  types: move phys_vec definition to common header
  vfio/pci: Add dma-buf export config for MMIO regions
  vfio/pci: Enable peer-to-peer DMA transactions by default
  vfio/pci: Add dma-buf export support for MMIO regions

Vivek Kasireddy (2):
  vfio: Export vfio device get and put registration helpers
  vfio/pci: Share the core device pointer while invoking feature
    functions

 block/blk-mq-dma.c                 |   7 +-
 drivers/iommu/dma-iommu.c          |   4 +-
 drivers/pci/p2pdma.c               | 177 +++++++++----
 drivers/vfio/pci/Kconfig           |  20 ++
 drivers/vfio/pci/Makefile          |   2 +
 drivers/vfio/pci/vfio_pci_config.c |  22 +-
 drivers/vfio/pci/vfio_pci_core.c   |  56 ++--
 drivers/vfio/pci/vfio_pci_dmabuf.c | 398 +++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_priv.h   |  23 ++
 drivers/vfio/vfio_main.c           |   2 +
 include/linux/pci-p2pdma.h         | 120 +++++----
 include/linux/types.h              |   5 +
 include/linux/vfio.h               |   2 +
 include/linux/vfio_pci_core.h      |   3 +
 include/uapi/linux/vfio.h          |  25 ++
 kernel/dma/direct.c                |   4 +-
 mm/hmm.c                           |   2 +-
 17 files changed, 750 insertions(+), 122 deletions(-)
 create mode 100644 drivers/vfio/pci/vfio_pci_dmabuf.c

-- 
2.51.0


