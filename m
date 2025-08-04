Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D79AC87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 13:01:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EA176B00A7; Mon,  4 Aug 2025 09:00:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99A716B00C5; Mon,  4 Aug 2025 09:00:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 862736B00C6; Mon,  4 Aug 2025 09:00:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7119C6B00A7
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 09:00:59 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2BF811A01CF
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 13:00:59 +0000 (UTC)
X-FDA: 83739085038.30.D657BDD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 84574A000B
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 13:00:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="snB5SB/e";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754312457; a=rsa-sha256;
	cv=none;
	b=vSvUBMiF/5BPOC6qK+INpdlJEQj0EznaSi4390JyCb03TBvJb+H76gP9zZC5Nxw+OyF4Uo
	I95s+YLieB0kENkNAAjHgpbo1Vyb5hekDhZgxjrm1Vpd+zu8iaHQorkFgYieRH0lRLv2sF
	eamPEUQ2Fa0vDlQBKztE9tPkr1ayx14=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="snB5SB/e";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754312457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=PZgjtmfHJwKq/Wk3dZBPVtPsEo7rLSMWGACD9OJPr4M=;
	b=NBFmEZbUp0t8xOcd3lkKpBkGIgiMZoj2G6fWNZA7SRH4p/z3GrENUB8lsDZQtbtH+zdRDO
	yHgYvCm1n4wGR2eBiQpRV2FnqvZNJI/PC0ag9jA2vsj4K57vZ/wtmXnLjp/wrRi3/CMu29
	f04flksZKQy+tyQsyIWF0xfiA7hUqzM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 79D6144916;
	Mon,  4 Aug 2025 13:00:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D16C4CEE7;
	Mon,  4 Aug 2025 13:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754312456;
	bh=L+bDZNrpRD6+NWnAqrJEaGTijfdyb7IbO9utRG6Adzo=;
	h=From:To:Cc:Subject:Date:From;
	b=snB5SB/ehi27xLbb8aXhBb2ZiyhJ9e2m9WSnuYjDNUxyhSq9Re9sx8WnUosm/3yxL
	 SN+3fMWL37eSzIUuNZEpqvSRbpU4PmQ9ZQZ/z/4VzZJKU+kN7HvBN/F1h/BSrkWO4H
	 eehopP6+SZUepq07StYSJKXP/s6hK7iUlUNz/zLE1wzKs99j9fG2ZEivbECfeIUph9
	 mrTs+HP3dr/zmRQ7l+QB7kp63HpOLpvFMfwujRo8eiMA/fuNXqD90jHbTmSImsSBka
	 U9Vy29jyCkt6W0MVTKUgd+gmftF40ONXFbnqj01gMf7pyAukD8MzMoYkOvBk/LgfIf
	 0LjjJU3m+NNxQ==
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Christoph Hellwig <hch@lst.de>,
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
Subject: [PATCH v1 00/10] vfio/pci: Allow MMIO regions to be exported through dma-buf
Date: Mon,  4 Aug 2025 16:00:35 +0300
Message-ID: <cover.1754311439.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 56rqr196e757urbtoc7e1gr1tdckxutb
X-Rspam-User: 
X-Rspamd-Queue-Id: 84574A000B
X-Rspamd-Server: rspam02
X-HE-Tag: 1754312457-428708
X-HE-Meta: U2FsdGVkX1+0WoSRGQ//kMugSd8N0X/velpwCFIjF7WsITkXy6qQROlIku9lRGHI6oL+jCuk1HGzgOFTRl1wyVvv99Jiym0RU6RxxX0k0KGrWWMN6eus2gBr1nqge+wU/qwClBvHPw6SmIcs1Ly7Ih7O1WRNDBF+8lmIQMtJkvoKzOjCmoy6aMPVOg8ijXD8fQkBBhBCQZaRhyuursC2wQdUsxr5xkikoGWYqAmE7Ua62vyqCwplJMaUfxpkLFZ30kGQmQ+z6M6GP4vRtR3Rsn1+eApgUPjxWs4pP6xKIlIac6EzyNXMz7M/LiyswM6AaBQuKXvy49iZSiyaiTDd/VU+RfFZdnemHUIFRnkeF6SCWOsNR54E0PWalkfTNqIb6N7S0VTWyK3nLt6/PC4H2vtQYXQDwofDgeM92ceOMBUyFNK7ZVWvioKHkQcL/npHGewlgNxujKtqiIiIkQEiqj6rlvhVNc5nywDYcPzCX8u8nifjn+XvQFPujvuzyiFw9EUxFUZpOcQT4G6kruQQl/gEWUy/u662gxsSrdf3pDBauR8aw2CVqIyuF6wDq6HnZOgxdk+IRrfAC+ipN9YLlQJ8TXgEwoa7B46J+UUmuogYI4HVt1SPyF1DMmdE65C8wW1Ks+ta23KIJMhfZ2htCdGDeroZvn0BwiC9WS9tbjaa+UeQGWWwWR7SLYnlfQshPN3f836bokuiDUMbAhkVkTGPAqonYLJwZHXW8TJ1a1x/Mdm5qLr1nr8RDJ/+daveQAG4BgYsWxc+5bOtj/zeakfgWwBgg/mxmKJzVSepLzlzMdCW7mlb3B6AkOPc0GiVcW53aDgcH97VLFB3vUq4C+kQzodAOoYuIKA3Y87ssqq6Bk0lo6fO2ky27Hzk0ZplWheGSqPJYwe1IKAk69e+6IGWdvh5CWMh+kKcB8/P/MQhPR1xkeD6qCMy/zD25Ehc0htxDfDL662IL2YJnfX
 GR9ILXFB
 4osnQYkDv2mOvJaO8vTYXL1FixjVdT9UPPRuszBhCI2coEYw97JZMjlzLj56O4cvvJpEt8ELvHbJvlKLNfzHc8b5DIdpUIVc6QMjU9Ceo0tZnkTLvX9OL8YT2XW69fb1bd8wc7XRkfzIRPuIk1diDEe8IMAAOhHynC5gIXYKuXO0WJmAPVNZZGIk+JA34BFeHGx0HXJdWj2gaYTNQwsbPEr8y3tTprDb9PgLZa6Jscof8kfyr7g8xQJnpy784/wTJt5jsdllfgjcr254EWVZmLiJrRA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changelog:
v1:
 * Changed commit messages.
 * Reused DMA_ATTR_MMIO attribute.
 * Returned support for multiple DMA ranges per-dMABUF.
v0: https://lore.kernel.org/all/cover.1753274085.git.leonro@nvidia.com

---------------------------------------------------------------------------
Based on "[PATCH v1 00/16] dma-mapping: migrate to physical address-based API"
https://lore.kernel.org/all/cover.1754292567.git.leon@kernel.org series.
---------------------------------------------------------------------------

This series extends the VFIO PCI subsystem to support exporting MMIO regions
from PCI device BARs as dma-buf objects, enabling safe sharing of non-struct
page memory with controlled lifetime management. This allows RDMA and other
subsystems to import dma-buf FDs and build them into memory regions for PCI
P2P operations.

The series supports a use case for SPDK where a NVMe device will be owned
by SPDK through VFIO but interacting with a RDMA device. The RDMA device
may directly access the NVMe CMB or directly manipulate the NVMe device's
doorbell using PCI P2P.

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
https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/log/?h=dmabuf-vfio-v1

Thanks

Leon Romanovsky (8):
  PCI/P2PDMA: Remove redundant bus_offset from map state
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
 drivers/pci/p2pdma.c               | 154 ++++++++----
 drivers/vfio/pci/Kconfig           |  20 ++
 drivers/vfio/pci/Makefile          |   2 +
 drivers/vfio/pci/vfio_pci_config.c |  22 +-
 drivers/vfio/pci/vfio_pci_core.c   |  59 +++--
 drivers/vfio/pci/vfio_pci_dmabuf.c | 390 +++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_priv.h   |  23 ++
 drivers/vfio/vfio_main.c           |   2 +
 include/linux/dma-buf.h            |   1 +
 include/linux/pci-p2pdma.h         | 114 +++++----
 include/linux/types.h              |   5 +
 include/linux/vfio.h               |   2 +
 include/linux/vfio_pci_core.h      |   4 +
 include/uapi/linux/vfio.h          |  25 ++
 kernel/dma/direct.c                |   4 +-
 mm/hmm.c                           |   2 +-
 18 files changed, 715 insertions(+), 125 deletions(-)
 create mode 100644 drivers/vfio/pci/vfio_pci_dmabuf.c

-- 
2.50.1


