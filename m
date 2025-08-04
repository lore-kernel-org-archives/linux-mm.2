Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A3D1C87FD1
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 12:43:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A10D36B009E; Mon,  4 Aug 2025 08:43:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E85C6B009F; Mon,  4 Aug 2025 08:43:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FDE16B00A0; Mon,  4 Aug 2025 08:43:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7E7D06B009E
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:43:16 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 387A8C01C4
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:43:16 +0000 (UTC)
X-FDA: 83739040392.21.57574B9
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf03.hostedemail.com (Postfix) with ESMTP id C24AE2000E
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:43:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ea6NngjA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of leon@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754311394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9mBSq747xnxKM4OSX34hdNxsM5vfVfa6L4EsHB97MsM=;
	b=TgRj8KiVPoAMwqITk+rDlw5gfF9UNGIo58KwsE/MGUQdNUpdY4bmniW7Yf4xGbzsl8nQLQ
	SkFgeGhCdzbM5UeEFTjuM8UjFg3UsNj7M9zdT7BZGH/AWlLZTuMjqbisANJKjkcuxwtQKs
	k2eOyDycPXEdbblc3LVqL3PeMcR476U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754311394; a=rsa-sha256;
	cv=none;
	b=s4WY9WFm/q3rH9xV+T8W2dTL7n05I9oVK5ctoHrmVBbnn4RJpp/7oPjp8gkJKIWaNF+OYN
	L1A+8fmZk76YQdmSrVRi8bXTWLVJEUqWHpLweyS8gPql9lavOHm2/aBrc6WpQ2KXf3m4vg
	ql9wAb1eV9gJYqKheiNRLuB57+ISgMA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ea6NngjA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of leon@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=leon@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 030FAA55811;
	Mon,  4 Aug 2025 12:43:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73ED3C4CEE7;
	Mon,  4 Aug 2025 12:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754311393;
	bh=5JNlmVmGVDRpHLFMyx/IqEG6PVqYnGg8cLXnDHx1P9k=;
	h=From:To:Cc:Subject:Date:From;
	b=Ea6NngjAGEvyrXvmgnjdDyM3mXPSC8QQfT+nOKbotr6HcSnhW9BlM6zfns9p9k3kL
	 aHN1p5RrLF18qj2RnxxdzX8nS9REiqaWtNTzVJNCM1ShLOSb5FfV99ZaNORp06pQRf
	 K3R1pWS9saoxzj1xXJAIiMxruqRredF2Zi+OmY/oC+bQ4mzzuhWorXTUyup4qpTeuv
	 RrIC3bsvwJsKhiLKd060hGDOvjUq+dNjvySky2bOV6npAhY9wBNf0nitks6Cij982L
	 fFaJuAYxFYDUX0NP4XT5/rJMF9kRy2ZpZIT9BlCY9GVEvgTb44GAyAGaBkqZ5aGmE4
	 Sus5Is+qyLnxQ==
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
Subject: [PATCH v1 00/16] dma-mapping: migrate to physical address-based API
Date: Mon,  4 Aug 2025 15:42:34 +0300
Message-ID: <cover.1754292567.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dnhqa4spoastsykyktr6sr3dx5c3ge74
X-Rspamd-Queue-Id: C24AE2000E
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754311394-606259
X-HE-Meta: U2FsdGVkX19QFnCtVf6bFEWPh8DzZiOEfgLwbG3taKaXStt5ow3TkBAbKYavcvjZjVbjhpz7nNB78Bm0zbcFy2RvkOprbU/bZa3s3Z/u/waDmjIHKXY01AHjMHpTed5wYkWy1gFEbWpaMhAiVGauaBvL8NwWo6HbK8Ffb1HbDJZ/kbcAT6dyGd1zYBIM6VN314kJTIu7f38UcOKsqA/RxdBjTNMVWxpaR2SD+N0Y8n9OdJ2M2Q+QvcKgt4qZZsQctdxom2+TXL5hfqSkgsFI1B+T99D6bjIltVBYM79Lp56aGKyHHAvuUUUuiVAggVpoLIo228lxNK6Ni5ejPh7nljIw4PH5DHq9hW7zU2otnOpMIMTxAlCIAfBqm0RglGH74GxvqcLFpq2uErXumGl9Z25ib0OC24AVONxTFmGjYGnqDqNCj8F+B9vqLy8pMG2lXextDRq1VfFIOom2bcrOK/P2h0PgNgrP5ITcfs22ybBzvPduoSCDov6noYhmWZNP9gcrb3dex+H3DIxCd/8r6uuzZ6xwub1xI3lI1wjQk4ijRCxW5cowNxB9Rh3eONOYcdHh+1LHNLLzhd9a54V4rXdONbQffoKDkJPG3gmKjr/IErGoUSfiy/MH3VhZs8CTQgkJgF6U0rncGPru2kn/+Eq448D7G8zybphOQyZPg2nUjFtNHeQqVCWvEYiYRauF/JIXDShY3AI5gyS/R9h8hGHMTPEajmYDJR9orh4RKIAzgA2IuTm0CvIt9iHhP3YSDJXocInjbdGbVKCNEr4qlCk6AVlZ0ksBP3XyOBChT2eUsBi2d6kfz/TV3GTyCXoK+0CzRcoxABIi8XDxve9ULbdmYpHNCO0wtQdavcQOjhHv6Ug2Vt1g24voIbX1ifKiMRGd9TxFOTzDv/L8/VPeBUOHuAD9/AQgiB/YxvzIEGSmHXcd/E2FbZgOU/QVE5EvBXXWa56UBvLlfZqAHP+
 YY2AO9Us
 H1sgHS7p/cYU8I0K//M5/V+ynbR48rjwbEi5n
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changelog:
v1:
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

Thanks

Leon Romanovsky (16):
  dma-mapping: introduce new DMA attribute to indicate MMIO memory
  iommu/dma: handle MMIO path in dma_iova_link
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
 Documentation/core-api/dma-attributes.rst |   7 ++
 arch/powerpc/kernel/dma-iommu.c           |   4 +-
 block/blk-mq-dma.c                        |  15 ++-
 drivers/iommu/dma-iommu.c                 |  69 +++++++------
 drivers/nvme/host/pci.c                   |  18 +++-
 drivers/virtio/virtio_ring.c              |   4 +-
 drivers/xen/swiotlb-xen.c                 |  21 +++-
 include/linux/blk-mq-dma.h                |   6 +-
 include/linux/blk_types.h                 |   2 +
 include/linux/dma-direct.h                |   2 -
 include/linux/dma-map-ops.h               |   8 +-
 include/linux/dma-mapping.h               |  27 +++++
 include/linux/iommu-dma.h                 |  11 +--
 include/linux/kmsan.h                     |  12 ++-
 include/trace/events/dma.h                |   9 +-
 kernel/dma/debug.c                        |  71 ++++---------
 kernel/dma/debug.h                        |  37 ++-----
 kernel/dma/direct.c                       |  22 +----
 kernel/dma/direct.h                       |  50 ++++++----
 kernel/dma/mapping.c                      | 115 +++++++++++++---------
 kernel/dma/ops_helpers.c                  |   6 +-
 mm/hmm.c                                  |  19 ++--
 mm/kmsan/hooks.c                          |  36 +++++--
 rust/kernel/dma.rs                        |   3 +
 tools/virtio/linux/kmsan.h                |   2 +-
 26 files changed, 320 insertions(+), 260 deletions(-)

-- 
2.50.1


