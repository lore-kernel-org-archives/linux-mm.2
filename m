Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D905CAC5A7
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 13:18:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65D9F8E0003; Thu, 25 Sep 2025 09:18:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60E398E0001; Thu, 25 Sep 2025 09:18:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FD0A8E0003; Thu, 25 Sep 2025 09:18:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C1AF8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:18:31 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 03DB0140198
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 13:18:30 +0000 (UTC)
X-FDA: 83927826822.04.96A0204
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 74FF840004
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 13:18:29 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tyMtduVm;
	spf=pass (imf12.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758806309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=QQDEM5zIBNnOPCZxgPAQYDOaZ7lSL6TtvAvS1Ebd+l8=;
	b=v9PKRqFEYv3S9x/6HCgcwT1z1hXT5H9kV/drRLX1nt6VLDpLpQ+ot/CrIAfhpxvIPuVruI
	ijxuX346zNK282oCPZXRMoM9PxW8wAAvGwKTjQ9H5pxSTOOiJoo9lAMMPk7SphaffeLPTW
	43+Z3p+dyEln1B9CtFteIIPxPzjZwkI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758806309; a=rsa-sha256;
	cv=none;
	b=uiRdSWirNAqaGoaSHtzpsm+fgxrZFQ7Kkcs0kPWUfQynT7qIA+IUKte6EAYrEBjxTo7vaQ
	KjGfrShg9cVEmxpKClQ613D2uTHtjkOcin2DCfJXmbrtv9UU31i+6M83qWKnZW1YbTcBdn
	vH4O9IBcMDRXa43Vbn3zQLDWctkqHYM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tyMtduVm;
	spf=pass (imf12.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B01716057F;
	Thu, 25 Sep 2025 13:18:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E522DC4CEF0;
	Thu, 25 Sep 2025 13:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758806308;
	bh=jQzVVFrSJ7ucYZq15uO8/5+M3IU4mjEtHjNrG1vAE+o=;
	h=From:To:Cc:Subject:Date:From;
	b=tyMtduVmcBWMzBWiJspZLwmeJ2ceNqfCyWctxCHtsWpa33DUFzUSwR+lAYuXSkSbq
	 7hyAzyHDnJmIUikYk3CItyM7Uh35bR2JxITeQkJhmDYCJYXHsKr+LGIuRm4+yXoCaD
	 JZiNMdX+Zw0TOCsazhHYjXM8C1WC31w10xakUJdR/Vn7x+k3dTdJUf9G5Maob/fD4A
	 26gabXuJymbyanTC7dVHAFcKpHr6e/oODVxTFeiHGn/xxwdP5aGAzn0HBac9BEnYEm
	 arr3AcxqjEzjhe0bR+w8YwaGFfWHj/09uhM6APuXkZfWoicvjxRbdiHLgAavHVhOcQ
	 +hGPrG6oy4xJQ==
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
Subject: [PATCH v3 00/10] vfio/pci: Allow MMIO regions to be exported through dma-buf
Date: Thu, 25 Sep 2025 16:14:28 +0300
Message-ID: <cover.1758804980.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dft4sn9ersqyjp8etaiktocpsiens3hc
X-Rspam-User: 
X-Rspamd-Queue-Id: 74FF840004
X-Rspamd-Server: rspam10
X-HE-Tag: 1758806309-906167
X-HE-Meta: U2FsdGVkX1+Ck4CLW0t+eQLH2olhsBeI3ssrhNiS7S1JQuoMCwBWy6yCeYJYXF3u+hPLOX8lzxfVqiriTJ1CnfFlNcQoPnZSF5ndlc8HXm0tT+8uDTNYzIecKCFBO5rD6wby7EmLoBQAMxD/SpJ4bcrzUXKOfRrqjjGfTkOkaTFleEMF9S1CUaHD1iWgsktqnnAFMxBrQQvCACOPBo0reFek4TNSHRjLIoWI/5axdlLOckGT3en65f8r0hyOu+XueEsENqJkTqNT3YEkM1ve+zWp+3p09UFpbIFULcpot0AKB+/uI1XzaV2Fs8V2dYavsxU/1JMI6DWwWdeDzf7eqeROOH5AMris7XA7E1mYhAWcULx01GYUCRoGuPW0K3dX+PkPGKGBMwKrWSnt16+PPEpAyPW6OhTkcY3Df4pTMmByhL690WhOQd1U3D8uZmmAvgVNbZgP575UBfnrcnhD3BNC2XzgA5CGG2d2FCByp8pFQvw15O5y2b3y9dKadyq77cywR71TohVcir01ZOFDuW3o/Dc2hWC5eEEW4LmQuavlE4qPCeYYfoM1X05clwTetQQ+waRA5j08C5eTj6RR7mI2l/YIHW4RMxX4Zyh1bvCD9zsmc4Fc4ffahMuKO7PrmUN/GHaRmlEXu1gdds60RfTv09geyH28N0PUJmds2ZFnG7MkotW+Tcj6oF3CuGJCn0+0yoAOtch83nJF4sP04iykRDe+CM3GJy1alMRVHCCIyoatoXjb3/OkRNvp7jnZTS7F3JCHNszIqOzY3zG/ImxEZWfWhEc5b1dL4B3LJjak2PCEYs9UhWjKPhqKdex4Uqd80zGUz/QucCHJty4oBjdAcAQMWgSjLUwDQ2Q3WPJ/0qNEdjb0lOnKZfSrDOWvnX8RNo/tQR/d2rhNCbOJAbqQn6tX9FdY0QuSeTPiMu0vaIrGWJE7HAWNhfheaAStVLik6/R0SOICUZtMzUN
 Y4ys6w6H
 gFL+JcqAWv4OPGGYjb0aBeNDlqznzltOuE+D5/NXKOjZ3FANXJZMBDf6YF25ZC7qty1P5wKpJEJ86wfNE699s/ZxpUgliRwS+tKSp9hQ/JHg/aYNEF8gYRY6SHNjwwYRNAwR0qL3wFXArZPZubxbM/F4YObBrbsXQGwGW0CSkaK2eEfZLXdqG4zH/jTI2sY9fnTrf1iobhDVj8CAIunC8qEhBfc5ovXiBObcH5QOJUVYNqS1a60dTsyf53r10vWTCz22fiw6B19A0SaNF1dC4ch+flw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changelog:
v3:
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
https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/log/?h=dmabuf-vfio-v3

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
 drivers/pci/p2pdma.c               | 176 +++++++++----
 drivers/vfio/pci/Kconfig           |  20 ++
 drivers/vfio/pci/Makefile          |   2 +
 drivers/vfio/pci/vfio_pci_config.c |  22 +-
 drivers/vfio/pci/vfio_pci_core.c   |  58 +++--
 drivers/vfio/pci/vfio_pci_dmabuf.c | 394 +++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_priv.h   |  23 ++
 drivers/vfio/vfio_main.c           |   2 +
 include/linux/pci-p2pdma.h         | 115 +++++----
 include/linux/types.h              |   5 +
 include/linux/vfio.h               |   2 +
 include/linux/vfio_pci_core.h      |   4 +
 include/uapi/linux/vfio.h          |  25 ++
 kernel/dma/direct.c                |   4 +-
 mm/hmm.c                           |   2 +-
 17 files changed, 741 insertions(+), 124 deletions(-)
 create mode 100644 drivers/vfio/pci/vfio_pci_dmabuf.c

-- 
2.51.0


