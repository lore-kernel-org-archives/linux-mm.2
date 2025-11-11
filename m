Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21DE0CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 09:58:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7476F8E0014; Tue, 11 Nov 2025 04:58:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71EC58E0002; Tue, 11 Nov 2025 04:58:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65B278E0014; Tue, 11 Nov 2025 04:58:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4FBBC8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 04:58:05 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F417712D04E
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:58:04 +0000 (UTC)
X-FDA: 84097875330.20.790BEBB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 63FB420002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:58:03 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LoGvYxIS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762855083; a=rsa-sha256;
	cv=none;
	b=chllfaj2RTRFfhUFSLBBTuUs26ZO5rtm+wk9G9OcrowDB7Q7u7VtgT8OCxVVNX7kKBgJoc
	eCqQJ8CmQM0DH68Iui6GyTt2VlBCogT6EWvjd5htzr2nOcGrT6lvq46VUo3XvlFiOA61Sd
	mjxtG7CU2RidbCGH9H33dJbNoIVH7/4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LoGvYxIS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762855083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=BliTlROGH5Tv17G1d+zTxfwTWzg2PydX1a2NV0Hrj8A=;
	b=iEImX8XNor4jkAFA6kbqF4fWgiYV7slfKZOt/4hHusmT+yx5reuKOcoaczGfqsRqFQJi+j
	7f+PgpoE3jj+98d8Xk0dNce0hnKDlowgkuXZ9B7NfM/BTjP+FoUMc4trvYIy+5VX4hZCP8
	OjIXwgw4+OAwWZ906rMXlJANu5FQivY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9DEF06190D;
	Tue, 11 Nov 2025 09:58:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F142C116B1;
	Tue, 11 Nov 2025 09:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762855082;
	bh=wRqC9BBU7AK8hlNM/MuZzbx4CSE/qfPFFz8/AqwN1y8=;
	h=From:To:Cc:Subject:Date:From;
	b=LoGvYxISSsbWSJpLSqoMmA8ayVVoAMBqC33CwOv+ST2WvWqOPENKtInN3CtWQUbq4
	 HEVtxnuQ09/GPb58NWlgbsmtR4dG7E1L3mHeysOkRl8qsSY0YgbXAlkn4GidI9s1iH
	 kjd+1j1fT+KsBaPKI2RCeHvOYOvACu63NIeBrlm8rLU0twScUJgCE6zFSrF04c2qKE
	 kf0eJrz9bSHASxpdosWmkT9sSCYIgyk+gCRDOkaUuCB/54JpdyXuSzkBjKl7u4i+7S
	 MUgJjp1vmLLeKKAsgz5c8TACT2i42q1X1EAWZcC1P5NvukX2U0R9f/TzlJHBDZ+OYD
	 kRdSc68o9dneA==
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
Subject: [PATCH v8 00/11] vfio/pci: Allow MMIO regions to be exported through dma-buf
Date: Tue, 11 Nov 2025 11:57:42 +0200
Message-ID: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
X-Mailer: git-send-email 2.51.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Change-ID: 20251016-dmabuf-vfio-6cef732adf5a
X-Mailer: b4 0.15-dev-3ae27
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 63FB420002
X-Stat-Signature: ewy9mwwjsdy1cp4jcibnksy589khkd7c
X-HE-Tag: 1762855083-902782
X-HE-Meta: U2FsdGVkX19W1Q2tXdX8DqYodfJV0WQwUrHl6aIHFtoWdbQaKtztKcXe7gNnYYNODgJzh9Tw1gAZRcoRzz7No+XzMqAD4LI7vXGNsYafaVpw4G246JMzPrX/n7by/gROK8IdV4zFB6dyEdOOizmRz2t0XrUu0R78WVjogASY376Jpok8naAabq364ChljbipdPb/4ONwCeHY9eD6Mw2b76sjGOAVMEp54IeYnSaFbeP4CZgErEt10g7EZdfswqkvq/LuYmMEjrL3JmLsGiqdME0X64RdNLQiyHHeGFaHuCcSAUhhAzAi8wYrFgguYcXQdLqIdl4HM13GsR6brbOzaRVqFZFf4qcT45ydQ9tX8b+2M1nlgjqHmrs4X77cN/NtlQboNcOwuW0/2vUtrsfQBSc9sfStK9L85NpxlRBIuLK5EdjD1fOfxQ4+QhCp9ZvnicdU69FDdQDywyMFwFLLqbAKRrnoT2zumIEnqZCmimRGY7wyPECN7TILDbRnV9b+N9TnAXUBpf4mx8QowJaIdx2TWwooOY4m4nqOdQLXw7s2plhvEMl7gRm0pYoeUpU+L7FIeQeTM8bt/MpnwmAO6lNbVnva+TThyDLMrSl6Q5DPsfMn/AWAriWcYAbKFzpYPBtjPBIYQ4UvXsrm5wpbMFOsCHy5C/75i50UhAMcObkZjUe7JS14bqNMrcprARQHXQMMqdPzHaRS6Evv8uScVrFA/jbtZtblVqMjZudjSAZGN6eZphkJ+vhML3hX8HcYhHg7HxUxP0d+pKobk0u9IMOQMeJtv0tqUqW2YZKMDWvUXf85caYoeEnsfxrKHH44laRAt/wtM9LGlQTdM8du0eYUuv7wDG4kBEadRyKGvpmb11o70j27Qjr+U7lOX1uJVTikiYX6caOibU1yIwFzdgg4Jn0R9IMwTZ0T9lhCNNWiMWLHsU1w1s2Plhlnrxx3IbeuNlcwaRPXWB6TFe2
 QxWVRXrE
 d32YhWw1UbibBFap+LnmmaqDVurnV528jfuCxTfflpQVM0QQjva8+7YBqXwN4xak/0NX1WTvxZgAarT1h61aacVSOiapV8pCMjvPrX7oS8aW6g7QHsnlRNXCLf/I0CflExSsQ+4oIfR8U1HqMDGyy/weuHBWmYpAu5Rxg1ewx8ia7+fBejwAXLjoYW7GV/TSUYFfga6+1K5dWPXTF33D3O6kNS074RwFAsNVe+FXRLpqDxLPOofNBkF4QNzZ586QIhExY4w5iG27uBt7qRpg+yY7H3fwtVASu+SuA5K4ZUeRTn8NQNwboIcqCgBaHe4YKanBMNxROu3Wwyus=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changelog:
v8:
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
https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/log/?h=dmabuf-vfio-v8

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

 Documentation/driver-api/pci/p2pdma.rst |  95 +++++++---
 block/blk-mq-dma.c                      |   2 +-
 drivers/dma-buf/dma-buf.c               | 235 ++++++++++++++++++++++++
 drivers/iommu/dma-iommu.c               |   4 +-
 drivers/pci/p2pdma.c                    | 186 ++++++++++++++-----
 drivers/vfio/pci/Kconfig                |   3 +
 drivers/vfio/pci/Makefile               |   1 +
 drivers/vfio/pci/nvgrace-gpu/main.c     |  56 ++++++
 drivers/vfio/pci/vfio_pci.c             |   5 +
 drivers/vfio/pci/vfio_pci_config.c      |  22 ++-
 drivers/vfio/pci/vfio_pci_core.c        |  53 ++++--
 drivers/vfio/pci/vfio_pci_dmabuf.c      | 315 ++++++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_priv.h        |  23 +++
 drivers/vfio/vfio_main.c                |   2 +
 include/linux/dma-buf.h                 |  18 ++
 include/linux/pci-p2pdma.h              | 120 +++++++-----
 include/linux/vfio.h                    |   2 +
 include/linux/vfio_pci_core.h           |  42 +++++
 include/uapi/linux/vfio.h               |  28 +++
 kernel/dma/direct.c                     |   4 +-
 mm/hmm.c                                |   2 +-
 21 files changed, 1078 insertions(+), 140 deletions(-)
---
base-commit: dcb6fa37fd7bc9c3d2b066329b0d27dedf8becaa
change-id: 20251016-dmabuf-vfio-6cef732adf5a

Best regards,
--  
Leon Romanovsky <leonro@nvidia.com>


