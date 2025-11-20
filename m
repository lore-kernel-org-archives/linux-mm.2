Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6352FCF8577
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 09:28:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF6376B009B; Thu, 20 Nov 2025 04:28:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA5F36B00A0; Thu, 20 Nov 2025 04:28:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6DCC6B00A1; Thu, 20 Nov 2025 04:28:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 919006B009B
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:28:50 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3820E58FBD
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:28:50 +0000 (UTC)
X-FDA: 84130460820.05.C8DFC5F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 92564180009
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:28:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s4xF+5wM;
	spf=pass (imf16.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763630928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=nnZAg260bNVk9k9sZ7Du68nvNeUB7e1zU7SwzSNzsxI=;
	b=uLdlyQkeNi2f2FfMfi0b8BGpwgIMmu9YPwAYD8aS1JCrXIaHjQPPuWhtzkDziK/UL3oW7Y
	x3wtXgFvgue76Nowu8DqIkgBI5v8UaDLjpAIKwVEpmbVWaU/zw8o5EFwr2fDXCukbAiF5N
	kRjSau6jsZrs9Fgc8vCWFS0bNmq6KpY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s4xF+5wM;
	spf=pass (imf16.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763630928; a=rsa-sha256;
	cv=none;
	b=ZZEPVoyzWKb11jlSv98oZ0RnMfOEgslO5ExmwcdE46+vofFYjRiRbXzRvnMSysu1ZBNi4k
	VEGnY+Q3ayJHV73oEZsrOOGsBkZ7OxQOcB/jDx94GGajfqDrG35ulR8tJsJY1uKTpfMD5o
	Pw54kn+GMNsuZBrznIYtAHqq6lgAbn4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E87A06014A;
	Thu, 20 Nov 2025 09:28:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1571C4CEF1;
	Thu, 20 Nov 2025 09:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763630927;
	bh=I2Ow+FoVVNgAF5HMTVEjWmPor12AxpDfs1Z6H54cyr8=;
	h=From:To:Cc:Subject:Date:From;
	b=s4xF+5wMT4a8M94UXO4W8SX/ZHtbVxbZgyCr/zZ5AEZBu/b5ZsWpMuuX/n+r8u+h5
	 4rH9JeGqKTNngFLaGXWvqxsGZ4yMgs1vFlNWwhUHJWM/6XvWGNFLVWSFy0CkQbXgTL
	 gg1nPrdVyPsYvj/myW5kVgUbLFTZT1fViF0ZH/gb2yBqGDfoMNVpSnxjeERbZipKjH
	 CiIUaWD/18OOt/YX1zmcUySs76rRrFCbbN8Z8HZL1FS5unC8MMWfa0rw3G41S5awu7
	 2m3Haa7BYkL+Gt3HSqKUFqGLCyXFOaLHpYPLakvL+iVUzMzpKjlkOboqpB4QnfJ7QW
	 i0kRKIqxKZ//A==
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
	Nicolin Chen <nicolinc@nvidia.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: [PATCH v9 00/11] vfio/pci: Allow MMIO regions to be exported through dma-buf
Date: Thu, 20 Nov 2025 11:28:19 +0200
Message-ID: <20251120-dmabuf-vfio-v9-0-d7f71607f371@nvidia.com>
X-Mailer: git-send-email 2.51.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Change-ID: 20251016-dmabuf-vfio-6cef732adf5a
X-Mailer: b4 0.15-dev-a6db3
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 92564180009
X-Stat-Signature: 3oz3o4teds6qq6msae4ij4cjiqixcgfi
X-Rspam-User: 
X-HE-Tag: 1763630928-408246
X-HE-Meta: U2FsdGVkX1/ZcvV95AmqS7Dsyq+6h5LySn0LfkeTCOa42wbd2ynFt6USOEndg8sbKXbo8RHLYHge+Omgtd7YvovdNlY94MZGeginbgNSbkvROX9He71NP9vab9lskZYOWJdGSEkbA+Va7mTEeocdsjsfDxDhbj1ru8z2cEUGZyW4IZs4n3YWxO+yoTY26ijv6mjeh0mhJ2p/hbzZc+iBsYuzAHYeTPUsh2Cwr8/mUIt+kzxGblIAIOC+ELMCTshf2Q6H752O8pJUcoIp4E/HPI2mylhzvJkLm/mDtVQ+JfiLT8bV8qanBfVDH0r6rzIyJlH9uETwRBUc1C6f7nG3hK5rowXat9Yp5knl5uKpK13ozP9QV6wah75s33cDoxeQ6oZ0YaIX9qU5S0+efsNcP0VRLWOS8sgi3ks7X8aWCd0ZVuGu7zbpUYTd4HfIfKMdtSXH+8L2W5w1fGqtE/fXYRJtqtylYxQg/4qdyFk17D8Ix32RoVi46et087Lp5Bq0PeuqrCh9Ujlu9Iar5yKbtNzDHQkLCFXNzn2zCB2Mhd9T+b3W0OfiPuMiz9fjq4xkdh/48JKbDm8SK6UJvToDKA+qQhS7Yb5DU9AGRgjeFdey6Sc5aMfjZmqkKUEkTLXcyykDG0S4vQufnwgQndjlo/GH4aMGRG+MpKp+CkXZmZVaw3NgYBJj64dAf4CqYissJmHo1a0ll8OI8zuagULd5ZeNZ2oeihnsiLIxMZKsVKOxyGBJi5b62lU1rjYh/GYO7zhcY2srYuMPRC+EjLew/W4kNlFnSqlc/HYb8zxN7/E1jy56jKASX0KxSNDQozxm2gmWnSqnydqzTxqhPac8Andnlj+FBXaAFwlHUdf7LPZsi7oLTW/BbXhR/irlw/TL1WAbbUG2jUrp6W0Rg0BRrILSD2rtFHs4mSGvGfv6EHPcQu3K7eSwTuW0ZKeUpI+1XNFJKhmuj9bCrgYZw3F
 OZBxV2Ao
 YHKX6eZyYmreX6/7cNvvg9xObGGUSK6TIwNaRIRPuKhAmU3byQl8Xbum3U1KySyfdcqNxrkfeENY9+UXm9SF7Vco4OllC9oeSyJh26j7kJc3l8AwLIqGh4/cPyT5m15PVef/2OSloBl1sltcPD6Sj1y7Nw+N5HFFTLdJK8SfXljpO3pIPztVjmVfafo4hzTVfa0KljnSYiut9Sa/AYExizLI80PbPjh3FIaRNmouamhhG0ETTnNNxQXZ7H8E1IzJDLkc1zk6ib50tpHFSTCKpiVRVlbGSQJt1Xc95wCfUXoI68O3w0l2L5Nak+4Yn2szfHPPBQxxcBPT3UHQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changelog:
v9:
 * Added Reviewed-by tags.
 * Fixes to p2pdma documentation.
 * Renamed dma_buf_map and unmap.
 * Moved them to separate file.
 * Used nvgrace_gpu_memregion() function instead of open-coded variant.
 * Paired get_file_active() with fput().
v8: https://patch.msgid.link/20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com
 * Fixed spelling errors in p2pdma documentation file.
 * Added vdev->pci_ops check for NULL in vfio_pci_core_feature_dma_buf().
 * Simplified the nvgrace_get_dmabuf_phys() function.
 * Added extra check in pcim_p2pdma_provider() to catch missing call
   to pcim_p2pdma_init().
v7: https://patch.msgid.link/20251106-dmabuf-vfio-v7-0-2503bf390699@nvidia.com
 * Dropped restore_revoke flag and added vfio_pci_dma_buf_move
   to reverse loop.
 * Fixed spelling errors in documentation patch.
 * Rebased on top of v6.18-rc3.
 * Added include to stddef.h to vfio.h, to keep uapi header file independent.
v6: https://patch.msgid.link/20251102-dmabuf-vfio-v6-0-d773cff0db9f@nvidia.com
 * Fixed wrong error check from pcim_p2pdma_init().
 * Documented pcim_p2pdma_provider() function.
 * Improved commit messages.
 * Added VFIO DMA-BUF selftest, not sent yet.
 * Added __counted_by(nr_ranges) annotation to struct vfio_device_feature_dma_buf.
 * Fixed error unwind when dma_buf_fd() fails.
 * Document latest changes to p2pmem.
 * Removed EXPORT_SYMBOL_GPL from pci_p2pdma_map_type.
 * Moved DMA mapping logic to DMA-BUF.
 * Removed types patch to avoid dependencies between subsystems.
 * Moved vfio_pci_dma_buf_move() in err_undo block.
 * Added nvgrace patch.
v5: https://lore.kernel.org/all/cover.1760368250.git.leon@kernel.org
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
https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/log/?h=dmabuf-vfio-v9

Thanks

---
Jason Gunthorpe (2):
      PCI/P2PDMA: Document DMABUF model
      vfio/nvgrace: Support get_dmabuf_phys

Leon Romanovsky (7):
      PCI/P2PDMA: Separate the mmap() support from the core logic
      PCI/P2PDMA: Simplify bus address mapping API
      PCI/P2PDMA: Refactor to separate core P2P functionality from memory allocation
      PCI/P2PDMA: Provide an access to pci_p2pdma_map_type() function
      dma-buf: provide phys_vec to scatter-gather mapping routine
      vfio/pci: Enable peer-to-peer DMA transactions by default
      vfio/pci: Add dma-buf export support for MMIO regions

Vivek Kasireddy (2):
      vfio: Export vfio device get and put registration helpers
      vfio/pci: Share the core device pointer while invoking feature functions

 Documentation/driver-api/pci/p2pdma.rst |  97 +++++++---
 block/blk-mq-dma.c                      |   2 +-
 drivers/dma-buf/Makefile                |   2 +-
 drivers/dma-buf/dma-buf-mapping.c       | 248 +++++++++++++++++++++++++
 drivers/iommu/dma-iommu.c               |   4 +-
 drivers/pci/p2pdma.c                    | 186 ++++++++++++++-----
 drivers/vfio/pci/Kconfig                |   3 +
 drivers/vfio/pci/Makefile               |   1 +
 drivers/vfio/pci/nvgrace-gpu/main.c     |  52 ++++++
 drivers/vfio/pci/vfio_pci.c             |   5 +
 drivers/vfio/pci/vfio_pci_config.c      |  22 ++-
 drivers/vfio/pci/vfio_pci_core.c        |  53 ++++--
 drivers/vfio/pci/vfio_pci_dmabuf.c      | 316 ++++++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_priv.h        |  23 +++
 drivers/vfio/vfio_main.c                |   2 +
 include/linux/dma-buf-mapping.h         |  17 ++
 include/linux/dma-buf.h                 |  11 ++
 include/linux/pci-p2pdma.h              | 120 +++++++-----
 include/linux/vfio.h                    |   2 +
 include/linux/vfio_pci_core.h           |  42 +++++
 include/uapi/linux/vfio.h               |  28 +++
 kernel/dma/direct.c                     |   4 +-
 mm/hmm.c                                |   2 +-
 23 files changed, 1101 insertions(+), 141 deletions(-)
---
base-commit: dcb6fa37fd7bc9c3d2b066329b0d27dedf8becaa
change-id: 20251016-dmabuf-vfio-6cef732adf5a

Best regards,
--  
Leon Romanovsky <leonro@nvidia.com>


