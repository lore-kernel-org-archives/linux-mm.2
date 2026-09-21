Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91A6EC982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 14:49:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3069C6B00C5; Mon, 21 Sep 2026 10:49:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B75D6B00CC; Mon, 21 Sep 2026 10:49:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CD836B00CD; Mon, 21 Sep 2026 10:49:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E43406B00C5
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:49:07 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 724D31A016B
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:49:07 +0000 (UTC)
X-FDA: 85238051934.13.F76B5C1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id D6F174000C
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:49:05 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AZS5BWYg;
	spf=pass (imf27.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790002146;
	b=a8GXgguXHCQGjI0erU11DG6PZorgL7lE4/teRgeDmF6wYeVaFmgH4d+NChhbJeMjceAxrR
	Qky3Iu5hfuaHNk3MWdfhNxbfBAAov5vbeeHJJtbpg6K8BqSoNc+LKPLRynrUogE8tc2s1t
	e4xX0mNU9Ayk3NdmJfancn1uCGj8bXs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AZS5BWYg;
	spf=pass (imf27.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790002146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/Lkgz98kmoNVfPiZtUjlz1I7ZL706Byj55J2FNtyPqQ=;
	b=uUPZGuggQ7/4Quei1w0iPBCmva5r9zL5h9NYVebSfqO/0pNLcPnCcZqxQkmLsDA9EPghLj
	WrYmx4zLmW2+UytAxinnmM98wrJml2CVc/lyX2AT1eQhqELotnE8k+b4MU78MuiRtVptBE
	DmR+b4ah8dhC8us9SYbaHVE9bTE++9Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 07A364183D;
	Mon, 21 Sep 2026 14:49:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D581F000FF;
	Mon, 21 Sep 2026 14:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790002144;
	bh=/Lkgz98kmoNVfPiZtUjlz1I7ZL706Byj55J2FNtyPqQ=;
	h=From:To:Cc:Subject:Date;
	b=AZS5BWYgcRs9dqkQfvQ6iimxVWMS0upWyGswZHtnACOlJPQp6vXIN4W+cmjg3N59a
	 U0FN3eQ5R/r5/4dF5pqTEC4HteALSLwC/BzUm50j968a9Kioq54AhdIyJDi2fucnSg
	 vwcxd98mb0Mg9TXXEgvG8WS4ptgAeJ8qJtjLUUj1OuW6JEVB/NNjvyiP8qG/0WarOI
	 1xMgtBCoN6azE2ESjlDpM4qNAzdTNXkg1g2ugnpVngq7rQi0SuI3CC2OfZYqznaPqr
	 ZluZjb7lwcLlweCWQ1w0Nj2ujGhRoIHX7XE/xrFKXoKry43DqzFBuRu/qBTE4euDms
	 LnvETXcMVA0HA==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	christian.koenig@amd.com,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v7 00/13] coco: guest: Add a shared-granule allocator for host-shared memory
Date: Mon, 21 Sep 2026 20:18:34 +0530
Message-ID: <20260921144847.501151-1-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D6F174000C
X-Stat-Signature: gqe8xayasswf5t6s6xmwy7ype3r9mboo
X-HE-Tag: 1790002145-6910
X-HE-Meta: U2FsdGVkX1/y1BHc5TIzO2PYNifNNrd1zfzBXOV/9X6C8Rd/nmFkQMJNlydSLV9UZ8Xs/VuK7A/1bB2auYwEN81U/Fsde/vaE48Yq7BTNv6/a1PkNjQAf5xJY7OxKidvy2zqYxJCatewKVXJF8+inTiTvazI7t9pSlVktFg6K1za+pqajK+T5L+mGRC23a7UPtBn6FSJz66ss8IFQjuzKCm2jL4f3BHjYbC0mLYHTEnRrJBApUGPuao5BeSuIJ0tc3LzXXnRG5x0dNVDZ5vTln4HhGGeUoUD6/G+vgk8e3VOfYOq+MGwktKU1XnVpv80BytEW7VMaUoEXwFWeXm6N96mutaeISWBgwvA8OZxSrQoiw2wV6UDDap8yrfotmlustTtVxGXa1HM2J+n4glLQGUjhqXSqLrEvsnopdlqHgtxXzcGafELTUaUSEmF8YLhFFiFJf6v6ST/Eh39gJM4j+xbnEMIuSG3waqKw639e6qkOU2RiQrdIxas0PQSKfsHv9XUzpx77OPkPMdPa5TqxNPoKdn173qDQO9GO0LsT4oCDiG4n83l77diHlDXrykCUvU/66uAHv1rF+RkBYMuqZKNzkYEmx5G6/cloXCoNOXWxZ6jDhUc6SPx0/IcH4JHTI4FwpADY7o8CnMg7s8CwrIB4YVSnat4ROn9MfmTrpxw3gbI/m/sUX9qmuncV9KK3jENoqoNyigJSNVW0MITtcQVoit5ZrUhHLOZaRVV/qdlwU4OClkKfqcZtKq76/qUszmhGiU7z/awfdUFxJKGoP0aEc3bMsUeUKuM+bQEl3iPs8t5slfBJSqKNf0ebJ4ulO+g3u0HJ0ceP3+8OhjpXYNHWwFzaSZT1DJBAj+us0LYcn0+7SBbUISXZde+ciEtC3muVBZb6dz0gCctfSuP5BAWATRasOgp/4o1fMPMXNbkkKEAelgdlAAPn4QxLKL3sSl0hS0txfYiXkKYDup
 ChgS7ly3
 9OzFdFGhoX9aynvmCbMSZXlsBZ4NGjBPYF8I/ttRSVPQX8Obe562I1KpPx3iUtMSd6vAGLMRv+72sm/QLWCJ/2Jxz9OipDejaLC+qMS8SsVMxhJq4JBzPOxtG7dzRH8VZ69+PMuIzgdCIIDkmgb9WxcFOCmh774lwnvj3HtqGpjkmpyFJqYthiO1fv0Dnb5gEYU0jbNA4OTuOY2LBXcMtJlzkgFbQF63QxtBiKE6difsweGE6TGDO0QcPeocr29xPl7QW4+2GTd6oJ7cHulZ7/5WO9Ay66jRBXDDvOPgyq9Dzsf3QUwwXTBL6WPf3Agvw+7OVXrEMsHba2UXP66k65wdcqhjJYw9AFPDZ+K/BUOnjSLUcBotmPjWTY2fKrcww6VK6y+j0t3tg3noZxoAcJJz0qVVK2lEKmBb8DfkT1uMRrC/YG/7hzHKYHTyJZa8FA6yByzDo6pwv1UkF5L0boqJFYLO3mU4YZxuJv+xXeLsB8VjeWoC4gn/hXnd/cI4uXXNP9Q+msQC+GfXnQdzPOG0TNZqL5X9Yb3oCuD5xpWMBrrqaLKC2LM20gfLb7lN+W8HUnqtqNx2FBEVr8znD4jGIH/6PQ4d93As43LHmNec0i9Vzt1jH2O3r5ybC5JUPqJ6IyZCe4Tn3DzqkvpUVb/xK/VaSPZ+QtHhE6AB6PHwWmqfUdcOLs0abf2YI0gH1GHBcKHf6MhIITiMt+xydjDoEN/eRGN9uEQe5q7fMqCVf+iDYxQGXT+Aqi0gN+5b7KftlRUrwq/bhcA2MpNaKxplD1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

This series tightens the alignment requirements for buffers that are shared
between confidential-computing guests and the host, and adds a common
allocator for host-shared memory.

When a guest runs with private memory, buffers shared with the hypervisor
are not only accessed by the guest. They are also accessed by the host
kernel, and the host may manage the corresponding shared/private state at a
granularity larger than the guest page size.

This matters for CCA systems where the Realm stage-2 mappings managed by
the RMM can still operate at 4K granularity, while the non-secure host may
manage the IPA state change at a larger page size, for example 64K. In that
case, allowing a guest to convert and share only a 4K subrange of a
host-managed granule is unsafe.

Architectures such as Arm can detect incorrect accesses to Realm physical
address space PFNs through GPC faults. However, relying on that as the only
line of defence is fragile and can still lead to kernel crashes. The risk
is especially visible for shared buffers that are later mmapped into
userspace, such as guest_memfd or dma-buf backed allocations. Once
userspace can access the mapping, the kernel cannot guarantee that
applications will only touch the intended 4K region rather than the whole
host page mapped into their address space. Those userspace addresses may
also be passed back into the kernel and accessed through the linear map,
resulting in a GPC fault.

To avoid this, host-shared buffers must satisfy two constraints:

  - the address must be aligned to the CoCo shared-granule size
  - the size must be a multiple of that granule size

The series adds a common CoCo shared-memory layer for enforcing these
constraints. It provides shared-granule geometry and range-validation
helpers, byte-oriented private/shared transition helpers, and
alloc_cc_shared_pages() with a node-aware variant. The allocator rounds a
request to the architecture shared granule, allocates suitably aligned
contiguous pages, transitions the complete allocation to shared state, and
returns the transitioned size alongside the page.

The corresponding free helper restores the complete allocation to private
state before returning it to the buddy allocator. If private state cannot
be restored safely, the allocation is deliberately leaked rather than
returning potentially shared memory for unrelated use. Since a
private-to-shared transition may modify memory contents, __GFP_ZERO is
applied after the transition.

The generic shared-granule size defaults to PAGE_SIZE. For arm64 CCA, the
series queries the host IPA state change alignment through the Realm Host
Interface, caches it during Realm initialization, and exposes it through
the arm64 memory-encryption operations.

The common allocator is used for host-shared allocations whose backing is
owned by an individual caller:

  - GIC ITS command queues and tables
  - dma-direct allocations backed by CMA or the page allocator
  - backing allocations for the CoCo atomic DMA pools
  - dma-buf system_cc_shared heap allocations

Hyper-V users of set_memory_encrypted() and set_memory_decrypted() are not
changed by this series. Those paths are not currently used by the arm64 CCA
code path, and therefore are not part of the arm64 CCA IPA state change
alignment problem addressed here.

NOTE: I have not added explicit MAINTAINERS entries for mm/cc_shared.c and
include/linux/cc_shared.h, as I am unsure whether we need a separate section
for common CoCo-related files. I will add the entries based on feedback.

The series is based on:
  - https://lore.kernel.org/all/20260921053807.354802-1-aneesh.kumar@kernel.org

Changes from v6:
https://lore.kernel.org/all/20260904103452.1197239-1-aneesh.kumar@kernel.org
* Add a common allocator and geometry/transition helpers for CoCo host-shared
  memory.
* Convert GIC ITS, dma-direct, atomic DMA pools, and the dma-buf
  system_cc_shared heap to the common allocator.
* Limit dma-buf scatterlist entries to the requested buffer size so rounded
  backing is not exposed to importers.

Changes from v5:
https://lore.kernel.org/all/20260706060432.1375570-1-aneesh.kumar@kernel.org
* Rebased to latest kernel
* Drop patch arm64: realm: Move Realm memory encryption ops to RSI code

Changes from v4:
https://lore.kernel.org/all/20260427063108.909019-1-aneesh.kumar@kernel.org
* Rename the helpers to use CoCo terminology
  (mem_cc_shared_granule_size() / mem_cc_align_to_shared_granule() instead of
  mem_decrypt_granule_size() / mem_decrypt_align()).
* Use __DMA_ATTR_ALLOC_CC_SHARED to pass CoCo shared allocation requirements
  down to CMA-based allocation helpers.
* Add validation for restricted DMA pools to reject pools that are not aligned
  to the shared granule size.
* Add dma-buf system heap handling for cc-shared buffers.
* Split the previous combined DMA/SWIOTLB/ITS change into smaller subsystem
  patches covering ITS, DMA direct, SWIOTLB, restricted DMA pools, dma-buf
  system heap, and arm64 Realm support.
* Rework arm64 Realm support by moving Realm memory encryption ops into RSI
  code and exposing the CCA shared granule size through arm64_mem_crypt_ops.

Changes from v3:
https://lore.kernel.org/all/20260309102625.2315725-1-aneesh.kumar@kernel.org
* Fix build error reported by kernel test robot <lkp@intel.com>

Changes from v2:
https://lore.kernel.org/all/20251221160920.297689-1-aneesh.kumar@kernel.org
* Rebase to latest kernel
* Consider swiotlb always decrypted and don't align when allocating from swiotlb.

Changes from v1:
* Rename the helper to mem_encrypt_align
* Improve the commit message
* Handle DMA allocations from contiguous memory
* Handle DMA allocations from the pool
* swiotlb is still considered unencrypted. Support for an encrypted swiotlb pool
  is left as TODO and is independent of this series.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: christian.koenig@amd.com
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Joerg Roedel (AMD) <joro@8bytes.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: dri-devel@lists.freedesktop.org
Cc: iommu@lists.linux.dev
Cc: linaro-mm-sig@lists.linaro.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: linux-mm@kvack.org


Aneesh Kumar K.V (Arm) (13):
  arm64: realm: Add RHI helper to query IPA state change alignment
  mm: Add an allocator for CoCo shared memory
  arm64: realm: Expose the CCA shared granule size through mem_encrypt
    ops
  irqchip/gic-v3-its: Resolve the default NUMA node explicitly
  irqchip/gic-v3-its: Allocate shared tables using CoCo shared memory
    allocator
  dma-contiguous: Accept an explicit minimum alignment
  dma-pool: Allocate CoCo atomic pools using CoCo shared memory
    allocator
  dma-direct: Align CoCo shared DMA allocations to the shared granule
    size
  swiotlb: Align shared IO TLB pools to the shared granule size
  swiotlb: Reject misaligned restricted DMA pools for CoCo guests
  dma-buf: system_heap: Limit scatterlist entries to the buffer size
  dma-buf: system_heap: Allocate shared buffers using CoCo shared memory
    allocator
  swiotlb: Make rounded shared pool capacity allocatable

 MAINTAINERS                          |   1 +
 arch/arm/mm/dma-mapping.c            |   5 +-
 arch/arm64/include/asm/mem_encrypt.h |   1 +
 arch/arm64/mm/mem_encrypt.c          |  13 +-
 drivers/dma-buf/heaps/system_heap.c  | 126 +++++++++-----------
 drivers/firmware/arm_rmm/rsi.c       |  58 +++++++++
 drivers/iommu/dma-iommu.c            |   2 +-
 drivers/irqchip/irq-gic-v3-its.c     |  43 +++----
 include/linux/arm-rsi-cmds.h         |  10 ++
 include/linux/arm-smccc-rhi.h        |  25 ++++
 include/linux/arm-smccc-rsi.h        |   7 ++
 include/linux/cc_shared.h            |  39 ++++++
 include/linux/dma-map-ops.h          |  10 +-
 kernel/dma/contiguous.c              |  33 +++--
 kernel/dma/direct.c                  |  55 +++++++--
 kernel/dma/ops_helpers.c             |   2 +-
 kernel/dma/pool.c                    |  23 +++-
 kernel/dma/swiotlb.c                 |  81 +++++++++----
 kernel/kexec_file.c                  |   3 +-
 mm/Makefile                          |   1 +
 mm/cc_shared.c                       | 172 +++++++++++++++++++++++++++
 21 files changed, 552 insertions(+), 158 deletions(-)
 create mode 100644 include/linux/arm-smccc-rhi.h
 create mode 100644 include/linux/cc_shared.h
 create mode 100644 mm/cc_shared.c

-- 
2.43.0


