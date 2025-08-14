Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA30ECA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 17:54:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A39F9001B9; Thu, 14 Aug 2025 13:54:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77B86900172; Thu, 14 Aug 2025 13:54:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66A789001B9; Thu, 14 Aug 2025 13:54:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 51B4E900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:54:19 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CC040C037D
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:54:18 +0000 (UTC)
X-FDA: 83776112196.01.B96B4D9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 55A5E120017
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:54:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OcmeWeuk;
	spf=pass (imf29.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755194057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hygAWsv6Yve4N+8ShnO81RkdjrmkzVxj8VTWU3zpjB0=;
	b=rOWStFBqWRSoabOlpLBMFoj9jnHitO3gYGk5tvjexkZ/7jWpYHkcj5uoSmjh6UjZAG1TAX
	rKcLWZoOxv3TzZvGaY1xBWJspmFJdnijtRLgvPt55jqHRo7Fd3L0jijrN8JPj3MoFwgc8z
	kuGq/eKFFiYqarS34R+/Fi52GSvA+SQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755194057; a=rsa-sha256;
	cv=none;
	b=Q5iTu51gO2huEUtN+6EgPxYptSY9D0Yhw8Smzfp1rk6bmP2XKXFpucap/Oa8fbdq/VeMpg
	VWXqYGa0v1nTjwwyupZW1CVkB7+nPsnCGUgvWQXnmvcEFcrqHASO1J9oN51Q8eX8OdrCUR
	/wMZxAJpxdGzzDFw+PWhQ4NlGRF8jpw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OcmeWeuk;
	spf=pass (imf29.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 92993601D8;
	Thu, 14 Aug 2025 17:54:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF51C4CEED;
	Thu, 14 Aug 2025 17:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755194056;
	bh=4y9YNTqs9ATD73KrJOwGSmCUPGlXOqneFIdpT6164E0=;
	h=From:To:Cc:Subject:Date:From;
	b=OcmeWeukMp2SnwuNGWIvA4eA/M6CtC77rgEGKJ+lP8E1ncVU3Rmm5LjSTPE0H8OIk
	 JZc0BQ5Uii4DFY4trcWY4DohMWke+oNy5brn/WmBiBVBoMxElYNdjsyjyNfvJZipWu
	 rD3GletMxA6oI7vW8NFEBfCcopcc0RYA3HnpqlvuA1f4tTqJ0+y3JOCfgCc3d9hfs8
	 ttOaiCXhCd9V6vk0MBmgu5dxIIxE7tYYoSllHfQFqM08tNP1IKiV4A7io6lECGj6Np
	 ZY5UolVIrPEH6pl1NJx2zRjMl+SdP2cIEKEsjWmwcNT4ScCkWZF9oA7VDmsnbc8OhT
	 4x50cIzc9r3Fw==
From: Leon Romanovsky <leon@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	Abdiel Janulgue <abdiel.janulgue@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>,
	Danilo Krummrich <dakr@kernel.org>,
	iommu@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Joerg Roedel <joro@8bytes.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Juergen Gross <jgross@suse.com>,
	kasan-dev@googlegroups.com,
	Keith Busch <kbusch@kernel.org>,
	linux-block@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-nvme@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-trace-kernel@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	rust-for-linux@vger.kernel.org,
	Sagi Grimberg <sagi@grimberg.me>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	virtualization@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	xen-devel@lists.xenproject.org
Subject: [PATCH v3 00/16] dma-mapping: migrate to physical address-based API
Date: Thu, 14 Aug 2025 20:53:51 +0300
Message-ID: <cover.1755193625.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 55A5E120017
X-Stat-Signature: rzoq6wnihequqzqbgtusanqxa9cih7x5
X-Rspam-User: 
X-HE-Tag: 1755194057-819859
X-HE-Meta: U2FsdGVkX18V2KyidCQeMpugCtwxbO3e/vcuujnVv0k/DOMo5yCRLeRTcF9uLi2TkukXYM8h1fcgepMpSxo7s8cnyx/k3Ukszjl8iLetCBP+DYreCCFmnScYeTrSpUiMKWsBqzfpu/1Db6DFZAfbbaTkIpiztaLruiYlRWmVojIB9G6ViJHjhdnMdryIbweAGO+RgD+mWvcnPWpCYKLPguCiHgEJDeXFyBFHh6hwBlThVPA3Tigign7avcljWuqQwbYiLuZbkyx3tPbnEnBBEhFuHCIQu9h6iTSWH8ooxyg/7/YWvO3Yw45Rksin6fC02cOAagCbBXXJtr+1vMSJjXtipxqAyQzCQ0KqKEqP8A4iXxYWIOixocF6kmKrpPWIGjp20eiJQZa9KV0KKW2t9uhg3vqMA17v8EoXvWpeq3Z6g4/ON66V/JxykWwRj3dWL5rgYB6NOh2+Mew/X8pYI5sITBJ4WeibfKqEpuHCmaBkaZ40rCbSV2sSiZ84Yb3qvlQtgUtmkWKRBtHyZXbiGe5wJj1hS7oh/UbADbohiluUDwmmMbEoGU7tz7BR2v96LRX+jwKUXKgF3b/GDvp80i2gc9Z0CxunjdC7EkBlXEABhwZ1DW8yUFNFbwNEZ8WN24YCOWS2g+lJ5936dTU36HNNTpfNdR6XqfDCDYmnli24QLUtj8oWZm/NT6B8hrHT8e+DuX9I7azngbgH+bR8xspFlpYTBDQG4+Fgqt/ffmxK8ogxoyUFCztHWCleX3lNEnyDqUFsDcgeYUcu21sjuwW9fNToJXewhUZGgsK2JCEfWCEzXs4xq8b3pBGBq9P7dSVNGup1QtQrJgN7mjrGmMmmRM5bgwvW/B03LrSjoRaTm/o5djlffPqo2vsd2nMDL6ua2dJdEVG3BCEe5NOHYg85h7gj9AKcSwya933GLyT+kKtUY7Qrj3G86j5AfNN2iGOtmoURSbc0MtPJ5Dv
 Iauhxg+I
 HRgDg1C3Z81M/XjmJdiJkKTJrKs5vMewSV+om1Pk9/c5dhPXzCYxgtXZ6/36Dtw8a5w4xMpxQqHkJzHyQQ7xg3wHeOnr5fsVatX4cO/S1ET2gSkAvH1YyvdSeo0n0o5oVZZb7lQMm8g3z9eoJJLsKcOZYfhXsZIQ5o5ikShUQoyosW7GVrYh4BhWkno7gLn2akL0VTwh6QgLfP9Vr0mhOZ//vKkai0yBxdmia6gdPO8Hou0+OUek+jVORTJucDu6Ur+0NxqoIs4b87Pv2h70ev9kS+jrF0tGs3jd6GNGvfYu66KlK3UrkKK0ekg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changelog:
v3:
 * Fixed typo in "cacheable" word
 * Simplified kmsan patch a lot to be simple argument refactoring
v2: https://lore.kernel.org/all/cover.1755153054.git.leon@kernel.org
 * Used commit messages and cover letter from Jason
 * Moved setting IOMMU_MMIO flag to dma_info_to_prot function
 * Micro-optimized the code
 * Rebased code on v6.17-rc1
v1: https://lore.kernel.org/all/cover.1754292567.git.leon@kernel.org
 * Added new DMA_ATTR_MMIO attribute to indicate
   PCI_P2PDMA_MAP_THRU_HOST_BRIDGE path.
 * Rewrote dma_map_* functions to use thus new attribute
v0: https://lore.kernel.org/all/cover.1750854543.git.leon@kernel.org/
------------------------------------------------------------------------

This series refactors the DMA mapping to use physical addresses
as the primary interface instead of page+offset parameters. This
change aligns the DMA API with the underlying hardware reality where
DMA operations work with physical addresses, not page structures.

The series maintains export symbol backward compatibility by keeping
the old page-based API as wrapper functions around the new physical
address-based implementations.

This series refactors the DMA mapping API to provide a phys_addr_t
based, and struct-page free, external API that can handle all the
mapping cases we want in modern systems:

 - struct page based cachable DRAM
 - struct page MEMORY_DEVICE_PCI_P2PDMA PCI peer to peer non-cachable
   MMIO
 - struct page-less PCI peer to peer non-cachable MMIO
 - struct page-less "resource" MMIO

Overall this gets much closer to Matthew's long term wish for
struct-pageless IO to cachable DRAM. The remaining primary work would
be in the mm side to allow kmap_local_pfn()/phys_to_virt() to work on
phys_addr_t without a struct page.

The general design is to remove struct page usage entirely from the
DMA API inner layers. For flows that need to have a KVA for the
physical address they can use kmap_local_pfn() or phys_to_virt(). This
isolates the struct page requirements to MM code only. Long term all
removals of struct page usage are supporting Matthew's memdesc
project which seeks to substantially transform how struct page works.

Instead make the DMA API internals work on phys_addr_t. Internally
there are still dedicated 'page' and 'resource' flows, except they are
now distinguished by a new DMA_ATTR_MMIO instead of by callchain. Both
flows use the same phys_addr_t.

When DMA_ATTR_MMIO is specified things work similar to the existing
'resource' flow. kmap_local_pfn(), phys_to_virt(), phys_to_page(),
pfn_valid(), etc are never called on the phys_addr_t. This requires
rejecting any configuration that would need swiotlb. CPU cache
flushing is not required, and avoided, as ATTR_MMIO also indicates the
address have no cachable mappings. This effectively removes any
DMA API side requirement to have struct page when DMA_ATTR_MMIO is
used.

In the !DMA_ATTR_MMIO mode things work similarly to the 'page' flow,
except on the common path of no cache flush, no swiotlb it never
touches a struct page. When cache flushing or swiotlb copying
kmap_local_pfn()/phys_to_virt() are used to get a KVA for CPU
usage. This was already the case on the unmap side, now the map side
is symmetric.

Callers are adjusted to set DMA_ATTR_MMIO. Existing 'resource' users
must set it. The existing struct page based MEMORY_DEVICE_PCI_P2PDMA
path must also set it. This corrects some existing bugs where iommu
mappings for P2P MMIO were improperly marked IOMMU_CACHE.

Since ATTR_MMIO is made to work with all the existing DMA map entry
points, particularly dma_iova_link(), this finally allows a way to use
the new DMA API to map PCI P2P MMIO without creating struct page. The
VFIO DMABUF series demonstrates how this works. This is intended to
replace the incorrect driver use of dma_map_resource() on PCI BAR
addresses.

This series does the core code and modern flows. A followup series
will give the same treatment to the legacy dma_ops implementation.

Thanks

Leon Romanovsky (16):
  dma-mapping: introduce new DMA attribute to indicate MMIO memory
  iommu/dma: implement DMA_ATTR_MMIO for dma_iova_link().
  dma-debug: refactor to use physical addresses for page mapping
  dma-mapping: rename trace_dma_*map_page to trace_dma_*map_phys
  iommu/dma: rename iommu_dma_*map_page to iommu_dma_*map_phys
  iommu/dma: extend iommu_dma_*map_phys API to handle MMIO memory
  dma-mapping: convert dma_direct_*map_page to be phys_addr_t based
  kmsan: convert kmsan_handle_dma to use physical addresses
  dma-mapping: handle MMIO flow in dma_map|unmap_page
  xen: swiotlb: Open code map_resource callback
  dma-mapping: export new dma_*map_phys() interface
  mm/hmm: migrate to physical address-based DMA mapping API
  mm/hmm: properly take MMIO path
  block-dma: migrate to dma_map_phys instead of map_page
  block-dma: properly take MMIO path
  nvme-pci: unmap MMIO pages with appropriate interface

 Documentation/core-api/dma-api.rst        |   4 +-
 Documentation/core-api/dma-attributes.rst |  18 ++++
 arch/powerpc/kernel/dma-iommu.c           |   4 +-
 block/blk-mq-dma.c                        |  15 ++-
 drivers/iommu/dma-iommu.c                 |  61 +++++------
 drivers/nvme/host/pci.c                   |  18 +++-
 drivers/virtio/virtio_ring.c              |   4 +-
 drivers/xen/swiotlb-xen.c                 |  21 +++-
 include/linux/blk-mq-dma.h                |   6 +-
 include/linux/blk_types.h                 |   2 +
 include/linux/dma-direct.h                |   2 -
 include/linux/dma-map-ops.h               |   8 +-
 include/linux/dma-mapping.h               |  33 ++++++
 include/linux/iommu-dma.h                 |  11 +-
 include/linux/kmsan.h                     |   9 +-
 include/trace/events/dma.h                |   9 +-
 kernel/dma/debug.c                        |  71 ++++---------
 kernel/dma/debug.h                        |  37 ++-----
 kernel/dma/direct.c                       |  22 +---
 kernel/dma/direct.h                       |  52 ++++++----
 kernel/dma/mapping.c                      | 117 +++++++++++++---------
 kernel/dma/ops_helpers.c                  |   6 +-
 mm/hmm.c                                  |  19 ++--
 mm/kmsan/hooks.c                          |   7 +-
 rust/kernel/dma.rs                        |   3 +
 tools/virtio/linux/kmsan.h                |   2 +-
 26 files changed, 306 insertions(+), 255 deletions(-)

-- 
2.50.1


