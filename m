Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BD9BC9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 10:05:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 438086B0092; Thu, 24 Sep 2026 06:05:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40F876B0098; Thu, 24 Sep 2026 06:05:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3258F6B0099; Thu, 24 Sep 2026 06:05:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EE89E6B0092
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:05:52 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7252D802B4
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:05:52 +0000 (UTC)
X-FDA: 85248224544.29.2D58FE1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id D7D1840006
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:05:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HuU4b+q4;
	spf=pass (imf04.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790244350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ztftWGB4Dg2CGLoIiNhW4BtmrBs2qH8L0ze0TvfkyVY=;
	b=fTvQHjaF0Qqwpu40zbbPnHsBTycAFuNQVrlsC/KxWMFTuYGxkcu6Ify7CHFhpkTIMSRdp3
	12amDysto/38+Mek6JbD8GRi1scev4YhhSAGeBLuPKJwCJhGCr5kM6ixrTsktfryt84fMh
	3EIPkeCpbYfjsbC+CYQ7dm6cYD00WYY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790244350;
	b=X92VDs5w4f5QOgwt0Qz8X1C9Cc/qdqmlVTK9fNTlnmKS1K11FPZy0Vgv/ejSMbD67OrU4g
	66ZPnsIkOjjm8enGFwzfD4BOju4/9b7lcRT7frrvBf3mW9fnV0LXMAfDQioaOfFGOXjqMz
	I9YtZGQ79pdiPKa3LdreRRVbL+Rod8A=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HuU4b+q4;
	spf=pass (imf04.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5CD386021E;
	Thu, 24 Sep 2026 10:05:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F5F1F000FF;
	Thu, 24 Sep 2026 10:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790244350;
	bh=ztftWGB4Dg2CGLoIiNhW4BtmrBs2qH8L0ze0TvfkyVY=;
	h=From:To:Cc:Subject:Date;
	b=HuU4b+q4DW0y1jFU/pkX+Y4Fhfh0EI89bHg3rugjNjh68OTBVkfJc+jWtGFdfePnm
	 k+qTHsx1VdLGmFvtcQe3yLmTJMO+2UbYXbjlLAUNUeew/THoupZHRLbW1A+sOnnaQ3
	 suyP7PpixoipAIDRd40wP6z9vX1F9/BcjD/3E3z3FzealKw9unKna4CfSYTU3chF/M
	 BeCJzSCxycJ/7UMrx5MowndgxpxqIxGYqaQyXAS8Ec2aRI5BwolYB0Ad2GmT9tcAOp
	 yB9imNYXb3ltmkm/2TqZzdLOGvB5zSz7bCVC0xidic9b4NEkeHKnJBgiAZ81jpwAar
	 C+jT4eU3TVRTg==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
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
	Russell King <linux@armlinux.org.uk>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Radu Rendec <radu@rendec.net>,
	"T.J. Mercier" <tjmercier@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v8 00/14] coco: guest: Add a shared-granule allocator for host-shared memory
Date: Thu, 24 Sep 2026 15:35:15 +0530
Message-ID: <20260924100529.1398790-1-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D7D1840006
X-Stat-Signature: n918dw4y1daitoiien6x8wthj93zhod3
X-HE-Tag: 1790244350-874099
X-HE-Meta: U2FsdGVkX188P9/ZKeiB+fYjQf40ZPWe6xse9pl4NPXCCeLiPSW09cTMz6nP+edLqmADfV5M99CL9Xek8C10SO8l77iYl4LnoDCroETDFncGQs3ex0zT0vt6Mt9eR1P7nIOIl1WkOf6btEYLH2qY39WRWJ1YI5WgbSlv3YmMG6FufAFMvJj04Q9XqZrVBFKS8wsZPjfXxgOD1df6dJvTxbMcpAXh5Ierq18N3JF3p3heSPACXrtetMKCJVecaLzURPTySpXD9bGl6vigdRBMCXFP2ysZnGQdjC09amcr1THT3Gy31Cv9fxdUlyM/MA/eKm5U1KfkytX6K8N8hjUvoCX9ZuGS0rPKlVdtMYNZQIB0cflEKYtQxnY3gwRYmYg9XUmbSwI9CFrm8EP0l8FJU0R638Ao7AZq56Uzblc2DepPZiS6nqEOm48r0LnWXjrCpd77GBLjVa766XI20k79XPGLaK0tGEca0+CFulGSSDf6HXnrWm2isoGhaXcELqsHWCi/gWn+ezfHUSZUp08yKvfmFfSxwhIM5qOYN7aiHkHzxd8SihN954jlBGHYpWGOJnKnxTKScPg4T3wHgiUh3OjTFWtcruW4P0bJNBqeyZjj8EgSFKodFByJ54cPg9nD2yLMJ/jDjtIcH6cmQS27yO+5qb0lpuviBoeONVzYhzawf3le9dxjsip0uAJez6xYTYwZriUdprgEdWA9PNOLW6yIdZb/PNnoQSdIjzBfeDkMyPcqOAdVZz7M6npbggAsQbv9QJinxTI6pjoPyhiLlIaaLAMviWOVQ5Rt9PezxRubWZTMfKkx9VCut98OJpoawOdRhkZEIB17husbRfx/qgC0+NAkeaexgWAfzA5RrW+JXiFkCIQ7WMZiQ3lTX41A150wPqUMR4fAZeWIxuoe1S1xLzlGSkbe/UHFi4UjYqpEEF+LZ2pbEz4xOB06m1P85M78QEpZgduxt2DiDJi
 Nce0xqnI
 AYPt+m3Z6WeFU9YMZy6I+wD7uYCeBqw704lTE9cXNvHzdL+a658OzEDIsyPCwCMzEcvhDtZ9BPJZ3pQwRz5W4rRbiNnhtL9bzxtfYAcp9pzz/5kRC6+AWa6we1xrbsTMkoxsdBroom+e8wX6yvxIb9RLqkO9wnmDoC7qDpNeGP2LinIFJaMkZRA6Ex5GS7/O07clVL/Epdy1DY9RVK8b6SBPEn7uGd9nJB5htwbOwLRSArDn1xjqM9Cdq2X7YYmGHM73IwpR6dfzuYCiuWT4JW/Dl01NXGBovdst68/3T9N8JFQVcUFdl0zK+NlqTugHTsBVHoWJy0IWEd/8u34cEDm5H4NCGWZEjznRAxM5BQ1oh7yG0U/rBhWDm09n8jmiL67UMcPlnr66yY2bELqQFBswteerYjYJi/oZEFBHtidO+UlXufGqu71iukHW3CfhSUhgtttwIKwbc5Rg1v6VtOqUpm/+LGFNrFBE3GlMBlCKKnRVDVThQLzhHQKurAqgIOJh8HfiLR4t+5m6GJJCZUgBkeuebzDclAb9G5Xyce+vqXoqlSNo2LE2rdfVAz/8nkmkrkSDm0yJgrSSn2Fk3NI8xyQaLzcG9uf0Wf0uDMMYacBtQD3CUWrzhKdYoNRr0zduDMj8FUcEmu4KkNoov82CdCevb5Rk4IfCT0ewTRbR7/Dm7AR3sqhfsRNE+ETE2mofgzqmhfAIt7xhC/jH/FxmhQNxh1Q/LIDRZqiH+6S2KFIZASkrz07JvM0XAF3lhH7nXTz9smN8Fia/OghLlH+O93qxOWjdI/ci0vFpBxlR+7x4j0mQR6vexoAtTp614/5ibqpDnjHI3ZoPec+P2Qqb4frc1KNge1spJQUsidaCialmQRlwJpOXBl/o/Of/KtZ9fh/kRwfBd68PCg196N+HK0enogDtrUvIYhRCZGLwZLEgswVnQUbo60yRAkDeFdQ1+6U88Yr3GeeDBMiC2REn4zBLe
 AR2Jj2IB
 Tu1+GS6t2chGfb7leb42Kps0CGENfanwMz+JE5fA0MI0VMaJSlPfdBGCMBANjgTTgvxLJk7jmqjF4AljC1yREELpVI1ME6cAqz02dl7XjpEU/3lvJDr8gZ1l4A8rl9nsb7ZiyN0RMQkkVCSiP6EThYt/izS2KLi04tis7jWp5dx6BzNVRlqeG2wyvwYa/U6daYIRdjLBNhRuNSLMWTlXBIQ0UYsD3l+f8F210qf1DFGVjeGKLwsEs4ZdYg2usNW8EfNei00tDUyqkb61mr0B4Y4yr7XFvzz5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


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

Changes from v7:
https://lore.kernel.org/all/20260921144847.501151-1-aneesh.kumar@kernel.org
* Add the following new patches:
  * "irqchip/gic-v3-its: Preallocate VPE L1 tables"
  * "mm: Assert CoCo shared allocations may sleep"
  * "mm: Zero memory during shared memory transitions"
* Drop the arm64 RHI and shared granule size patches so that the series can
  be rebased on top of upstream to enable Shashiko review.

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
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: "Christian König" <christian.koenig@amd.com>
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
Cc: Russell King <linux@armlinux.org.uk>
Cc: Benjamin Gaignard <benjamin.gaignard@collabora.com>
Cc: Brian Starkey <Brian.Starkey@arm.com>
Cc: John Stultz <jstultz@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Radu Rendec <radu@rendec.net>
Cc: "T.J. Mercier" <tjmercier@google.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Shrikanth Hegde <sshegde@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: x86@kernel.org
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: Long Li <longli@microsoft.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: dri-devel@lists.freedesktop.org
Cc: iommu@lists.linux.dev
Cc: linaro-mm-sig@lists.linaro.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: linux-mm@kvack.org

Aneesh Kumar K.V (Arm) (14):
  mm: Add an allocator for CoCo shared memory
  mm: Zero memory during shared memory transitions
  irqchip/gic-v3-its: Resolve the default NUMA node explicitly
  irqchip/gic-v3-its: Allocate shared tables using CoCo shared memory
    allocator
  dma-contiguous: Derive shared alignment from DMA attributes
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
  mm: Assert CoCo shared allocations may sleep
  irqchip/gic-v3-its: Preallocate VPE L1 tables

 arch/arm/mm/dma-mapping.c                     |   5 +-
 arch/arm64/mm/pageattr.c                      |   3 +
 arch/powerpc/platforms/pseries/svm.c          |   2 +
 arch/s390/mm/init.c                           |   3 +
 arch/x86/coco/tdx/tdx.c                       |   3 +
 arch/x86/hyperv/hv_init.c                     |   6 +-
 arch/x86/hyperv/ivm.c                         |   4 +
 arch/x86/kernel/kvmclock.c                    |   6 +-
 arch/x86/mm/mem_encrypt_amd.c                 |   4 +
 drivers/dma-buf/heaps/system_heap.c           | 128 +++++-----
 drivers/hv/connection.c                       |  41 ++--
 drivers/hv/hv.c                               |  11 +-
 drivers/hv/hv_common.c                        |   2 -
 drivers/iommu/dma-iommu.c                     |   2 +-
 drivers/irqchip/irq-gic-v3-its.c              | 153 +++++++++---
 drivers/irqchip/irq-gic-v3.c                  |   4 +-
 drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c |   3 +
 include/linux/cc_shared.h                     |  39 +++
 include/linux/dma-map-ops.h                   |   9 +-
 include/linux/irqchip/arm-gic-v3.h            |   3 +-
 kernel/dma/contiguous.c                       |  41 +++-
 kernel/dma/direct.c                           |  73 ++++--
 kernel/dma/ops_helpers.c                      |   2 +-
 kernel/dma/pool.c                             |  25 +-
 kernel/dma/swiotlb.c                          |  80 ++++--
 kernel/kexec_file.c                           |   3 +-
 mm/Makefile                                   |   1 +
 mm/cc_shared.c                                | 232 ++++++++++++++++++
 28 files changed, 682 insertions(+), 206 deletions(-)
 create mode 100644 include/linux/cc_shared.h
 create mode 100644 mm/cc_shared.c


base-commit: 704340f1cd0dcef829eb62f5b48ae95a2ce17bdf
-- 
2.43.0


