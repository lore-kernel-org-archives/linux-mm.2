Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E359FCCD18E
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 15:26:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3900E8E0053; Mon, 13 Oct 2025 11:26:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 340D28E004E; Mon, 13 Oct 2025 11:26:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27D458E0053; Mon, 13 Oct 2025 11:26:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 142C38E004E
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 11:26:31 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B5823B8955
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 15:26:30 +0000 (UTC)
X-FDA: 83993467740.07.6C6A5F7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0ED0A140004
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 15:26:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QI46AevF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760369189; a=rsa-sha256;
	cv=none;
	b=0vol0MD7W1ZiWO9TYIsMaq/BWR2jsZU0FnILpOELZjRUA5ErYyFO6/Xa4kPaQb8U6oGDSu
	93pwYShWEIrdEQs0ez9u4JJQJbSoqkY+/D1niVfXNl4NxB8f86n0OojXun+WuAf4ACFmWS
	vU5ItPp+zE/cUBdYXGvu6dCcGXpsJyU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QI46AevF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760369189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZlGVTp6U3CDjsH0UnaN4N17k9bUWxwI//SizfAED89Y=;
	b=iJqnX8Lvgnv2tqHnyb6mO2BwyhtH1q2r4cGTZbzKEvDDNdwTBGypKGYxZNMqs6XgV56Egd
	dqq/+tP8f+TMZ+rq4IH5yMYuZVWMh5q3dtwpbW3gm5Vwx0MmqciFo/8MlS5O49C3iGoUHQ
	gzl41kcgtP/IBhclncCc59SfzSuI/a4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ABF2C48AA4;
	Mon, 13 Oct 2025 15:26:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F303AC4CEFE;
	Mon, 13 Oct 2025 15:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760369187;
	bh=iwT2J/6Ee3JNCasRQZJmlsM7yv8uBxsSvtO7x8CH+0Y=;
	h=From:To:Cc:Subject:Date:From;
	b=QI46AevFpmY08Ci9IDO9Gbh1+r/WU2BxnmEGrp2cn2WKFO9huEbazJLddAk4lN5GX
	 b5c/n1Xuj+sMBclqJh5bm30LuSPzc6gcOuf3MBJoABy1hwPlYjR9mrnXGr0b+7QdBH
	 fhxk9/aQRt4ipCV+PI/GqslOGkkvvHIuFGClxI7pj6yC11uh2TNxiWya2U/uyAT24m
	 ZNi8xuJ0//k5X/ObU507wts9lR7ncxAQFX2BVBDLEAaxW0xvMTsRJHR/EzMS3LIB1a
	 WgkAoZ71H1kPSiyyABQNvnMsFUwlG5bAg4iD17Ru5KX1wb5ub49SkfrHTpAFNdvccF
	 ulvZnDXcm9buA==
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
Subject: [PATCH v5 0/9] vfio/pci: Allow MMIO regions to be exported through dma-buf
Date: Mon, 13 Oct 2025 18:26:02 +0300
Message-ID: <cover.1760368250.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 17s55dcnns4oye3kqentpw9mdkgqa1j8
X-Rspamd-Queue-Id: 0ED0A140004
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760369188-343868
X-HE-Meta: U2FsdGVkX1/PJRhTm8DdziCKVSOpDxS49pZrcwIcMfCQj5S7fxl7w1fvZsWx8wTHbCTDtm5j3CpBol0MyTY49MkhbwtmlyVN692BK4IXYFN6Iha4y67DVUxkLPERZYjxIrG2wEpkP24qZ99XS2lZ3FX8k573HhDjGFlRsZ9Fb9ViPAyOCqmExibFhnI7X1hE/dITsNU7Dcd2lxxNSGO5eq13JVPWudWY0n0xcgtnNpK5+VyzIauvrK5O1okENZJ78/RXWWyhnTjPa3l6a+xRl71mB81tx0bhMtnNpkCZbmeOzrPhBP09HrYoj3LwJgGTvxpJcYacpaNVcasao5KcPh6YE5Fiykf+WP2REws6vhk2YK33PpFVrt9uwcMT4fAdBZPtlr6wbDAzF6aT6bPjQ8kSCRj4ZJe5tAT2SwmjbJo3PJxiKJQT4/7sNbVBzxMlnQWH/ocMbPAOazaHv8Ce8I+JgoCbPEUWFbOELGvX4IuqobUOb8iYd2i1t1axk6MrCUyfYu/wz/a+DFZNaJT1dXjlcWEub7vkFwaXr1K5ry53sUa8JntuxH2YA4OjDa2/BpHN07mT57X1LO/x0PRVIRo6cx7Ez1xr9Lrbo5lZ96qGv/fXm8nvfpYDxc0nNhGdlpXEY17cHcU4WjYfE5l9RaMhlmg+lhYAY/XLpufb7rhAR/DMMufvwRhhbqda60TzDKBvyurCihUWY32FRAsslbsbmsCjIrivvaSlBvzO8r5ps3WfyUPtVq3XOMFCHnk+DXo1l2hIOYTlHcmfu5JSYQkPyJMrhSG/L0cUJNkiOb+ioQCSChlLuc2VYzMF9FTq+M0eY3ZnWLSJqIoyjJlsiciBK6Ep/vdiOuotg628QD7Nouu6MGeI5CUKfvdeln0kYIw+ABcHWw+2ZOAD7R8mxi9kDFRfKAZ2ypGKcn4p/cx7elz0Kv315ryI3Jrgnz24/uiTJS+dIfdx/zsx3Kn
 FOkvM/g0
 aOvDnuSmmutbbJSeGme6DxXsGh1dU0uDIBdI4LN5lPG+f57ly71NfXejooop2/dx9uDoViXS6gy7J/ire0lJBHb9CgdmdOKGC6NmYhWLOsXhG765s6DsMEfCSnzkKJsYV2aiAjSq56WwbTdVuBSl10y9Btk+vY0UV8zhSAeDsE+aD4LVmBjD3dfIR42gbyf//+JbMHqk+jmafJAHU6bhz6pf8TmZjq1BdsItak50KVTr5aak4WE6a4dSa9WhrOiIDfmBgY8Qd9euxPlKHjQFeXzfHCw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changelog:
v5:
 * Rebased on top of v6.18-rc1.
 * Added more validation logic to make sure that DMA-BUF length doesn't
   overflow in various scenarios.
 * Hide kernel config from the users.
 * Fixed type conversion issue. DMA ranges are exposed with u64 length,
   but DMA-BUF uses "unsigned int" as a length for SG entries.
 * Added check to prevent from VFIO drivers which reports BAR size
   different from PCI, do not use DMA-BUF functionality.
v4: https://lore.kernel.org/all/cover.1759070796.git.leon@kernel.org
 * Split pcim_p2pdma_provider() to two functions, one that initializes
   array of providers and another to return right provider pointer.
v3: https://lore.kernel.org/all/cover.1758804980.git.leon@kernel.org
 * Changed pcim_p2pdma_enable() to be pcim_p2pdma_provider().
 * Cache provider in vfio_pci_dma_buf struct instead of BAR index.
 * Removed misleading comment from pcim_p2pdma_provider().
 * Moved MMIO check to be in pcim_p2pdma_provider().
v2: https://lore.kernel.org/all/cover.1757589589.git.leon@kernel.org/
 * Added extra patch which adds new CONFIG, so next patches can reuse
 * it.
 * Squashed "PCI/P2PDMA: Remove redundant bus_offset from map state"
   into the other patch.
 * Fixed revoke calls to be aligned with true->false semantics.
 * Extended p2pdma_providers to be per-BAR and not global to whole
 * device.
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
https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/log/?h=dmabuf-vfio-v5

Thanks

Leon Romanovsky (7):
  PCI/P2PDMA: Separate the mmap() support from the core logic
  PCI/P2PDMA: Simplify bus address mapping API
  PCI/P2PDMA: Refactor to separate core P2P functionality from memory
    allocation
  PCI/P2PDMA: Export pci_p2pdma_map_type() function
  types: move phys_vec definition to common header
  vfio/pci: Enable peer-to-peer DMA transactions by default
  vfio/pci: Add dma-buf export support for MMIO regions

Vivek Kasireddy (2):
  vfio: Export vfio device get and put registration helpers
  vfio/pci: Share the core device pointer while invoking feature
    functions

 block/blk-mq-dma.c                 |   7 +-
 drivers/iommu/dma-iommu.c          |   4 +-
 drivers/pci/p2pdma.c               | 175 ++++++++---
 drivers/vfio/pci/Kconfig           |   3 +
 drivers/vfio/pci/Makefile          |   2 +
 drivers/vfio/pci/vfio_pci_config.c |  22 +-
 drivers/vfio/pci/vfio_pci_core.c   |  63 ++--
 drivers/vfio/pci/vfio_pci_dmabuf.c | 446 +++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_priv.h   |  23 ++
 drivers/vfio/vfio_main.c           |   2 +
 include/linux/pci-p2pdma.h         | 120 +++++---
 include/linux/types.h              |   5 +
 include/linux/vfio.h               |   2 +
 include/linux/vfio_pci_core.h      |   1 +
 include/uapi/linux/vfio.h          |  25 ++
 kernel/dma/direct.c                |   4 +-
 mm/hmm.c                           |   2 +-
 17 files changed, 785 insertions(+), 121 deletions(-)
 create mode 100644 drivers/vfio/pci/vfio_pci_dmabuf.c

-- 
2.51.0


