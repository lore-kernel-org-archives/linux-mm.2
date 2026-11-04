Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A36E606D81A
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 16:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JiYFumdX
Received: by kanga.kvack.org (Postfix)
	id 8503D6B05B5; Wed,  4 Nov 2026 11:46:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 802516B05B7; Wed,  4 Nov 2026 11:46:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C8FE6B05B8; Wed,  4 Nov 2026 11:46:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 346906B05B5
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:46:58 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9D28E407AE
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:46:57 +0000 (UTC)
X-FDA: 85398016074.15.EB16589
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 050D540005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:46:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JiYFumdX;
	spf=pass (imf11.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793810816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=mrj1RHzBr9lFPxEPcZNWDZfBeJOGthj8B3nIsgiRgYA=;
	b=zKlLn39h0sw8Pi7BtpCOQqkS+xTeNNj3ety1LjNFfvRIvuw4mANocnAmtT41yPQGshbJhj
	FqxsTuaG64y5C02FKpJ7YZqaMCo3LpfbrFbpiCz+kaKJzGSHVK/IQD0p/fAYyEUboDKKxR
	vY0vJbS7IwDgTVO9BADrW7uyAX+J6cU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793810816;
	b=q0FOp2T012U8vzHtFvur1OV7JTAiQ4YR/Em1fURKgmteM+F2DHisoGcGASSS6tvCnB8EV1
	c7SclDybrCfZ4dHpVD+e4KwcHbIVPZ9aRtMSemYbx/PWIs2s9/FTsZAZeWa5LKirnGM6wj
	B5G0WS0LH4/raq1N3V6AjiISo+L9oWE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JiYFumdX;
	spf=pass (imf11.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A7CB943852;
	Wed,  4 Nov 2026 16:46:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0AAF1F00A16;
	Wed,  4 Nov 2026 16:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793810814;
	bh=mrj1RHzBr9lFPxEPcZNWDZfBeJOGthj8B3nIsgiRgYA=;
	h=From:To:Cc:Subject:Date;
	b=JiYFumdX1kW2MrKZksZooxbQY6RBIzupSHXG+La1/uDEn14++2uJp9HpNG70MMBlD
	 h8PrFbaBOav3/rqvgLc0fc7BPqmE+v77ICnKYtkVcP4uqLqMN4xW8IAHdSFn3ws1gy
	 e0OvsfLMh/c2+lmvyZtvI3JiIdUPmxb0wgheKaONGmNuE4ynMtUIiyEMN+FDRjEwO9
	 R5wUcO3fEKraXYRjIEtnjGhNn3g4qOiXXHYMM/YYLMFlK02+31mt4VAX7+y080F/jb
	 dyBxHIgATgN19yINWuhIjkzj2UooK+L6Sn8CN4bOGmVHNJTlm3xKEz6JjITGuYc7+R
	 IgSswZF3IyLug==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev
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
	iommu@lists.linux.dev,
	linaro-mm-sig@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org,
	kvmarm@lists.linux.dev,
	patches@lists.linux.dev
Subject: [PATCH v9 00/14] coco: guest: Add a shared-granule allocator for host-shared memory
Date: Wed,  4 Nov 2026 22:15:41 +0530
Message-ID: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 050D540005
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: dc18opyty44t5k1imoqhtmbr7dtmsbhx
X-Rspam-User: 
X-HE-Tag: 1793810815-916403
X-HE-Meta: U2FsdGVkX19IqE42ur6yJ804XWEpupmQLum3VjHauxVqq1XxhdwbaHPrIHC2Z1PNXaRFNn0mbpQNmhgC5GUZCklO1wd+SzCZQnI0DEhXY+e7KN3KjI09pLemeAougYl+jUe1y7icpQyFbwG9X7WnXxbdYx9ibVGYmZPyGNUVzqkD6UxBDQlI49tXT2bad2RvvPFKi9/8R22Sp6kDGKrB0TMUUZ2hEw+TWOuo0RYFJtRtuDH0D5RDu/mT5mFLbsXs0fFyWcjnDHAoI/w686voVonw+ZTk9HihGNkpB5d4ZaXZEnya8CMfL4Tj33UuEQN6ifT8isu6dYSeqK86Vpad16UuoqZ4XNLmGPfnf3JsYrW7MjiI4sldo88Dwy5WrtzTdTAL70D4DV54T+R3w3hRKOf+gGPwjfwNodydaYYi9zgj/eq/66C4QGroWdseUC3v3E7YTgZtg3e+CChVMqysP4q4XShlI1lx9IcYq4cJexdER29uuDvucqtl6jMpM65jsaJCV+Dug5SWAvYpIFb348XRa86nhoFNmVXfSgONsovalSEGVBXds5cENsATfwDARWQUd7HGqsd/NcNilDoo0hoCWCoa7dNe8Rt3HyH3OYfSePWrO/KcJTb0LeYktCM7ouZz15H+hauVKN4aRjAVC8redyXJF1mXbKnnPWLKrvT+C8Qyts87ZFf8Q/Fwwe787tlBlLhlQRjCCCsCLwpJQLoZW8IFFa8Px5xH3dKmf6EF8k/R6s93/Qg827Y62zjT9dVclDsMmm0C3AatyMX+3fAVi8/HF5eSZO7ObADB4kzQxJu+C5BVYT+5W9O4DFsBX/WBrhdQ2t3Jtsu8hIpUt/dsrS/YuLxtZvm50Q3uwrp5d5ATjjwzfyBRlqcph/qr5aXZcQVae16b6FZtK5ZhtlKZvJrtdq8syHry0mg/bJ1NP5We88r6c3K91SlRQeZo8dRPoB5fy/3bY2Mfm4Q
 bKMkk3rj
 EFUjmzhR3akSCP1x/7Yjds5X3g4eKRcKAunqsMc6ZTG1sDOJHmcV/oh21c9tDtBBmREFyfFnc9/OMzJhY/Tz+WpelVutV2M1St4JvjrqWyhwpmBbYyPVs8o54OHADoibd37AFepagudVO2DBFjDTwEZTqC/8uqJojlevAGe8Sfc7Fesl5pqH/MzEbE12PaZ2rAndCJbnhDwM8QPyq2FOa/GUdSS6CYIdGfoTue9cNrYttSlsZ/tTk7xAzDp5kKBuRPiimpXN5u5LtcOuPdNsf8eZ1y55KVEvReHp22MgvkG+GZ3VWL141GwFA1F9ad3zoTlB0GOsmWwpPaVbE52Wl+elMMg8kqJ+SAGlV+7Ewz87O5tZ+sgV1o9hO4X+RTzxIqkomF6l7K6DB9+1N7gtnyvlYQffHQU8ny5828/Bjp+Xvzddu9Gl+0bcEv2H/DL41DvzjzgoozwD4spcf2Mr00YUmep2sHHsXRDFbnzQJd+ayhlR7F/Ruqno7eJE2iwbBv3Eulxavg8EtxpU1KuMJtK717eNV+WFzWnr/LSu0zWkUncvPbtRy+bYAmu9FwzfAO0NzGhRwJd+uFzyZUnn5fYqBPisbrHxS9IEP9vUAb/7dyw5NLVqwpFaImqWhExQ+aTdgbemoKSNd9NoReLWej4bdY6GKpO5mgfRJqf3S+ub0hCmyV3/5a7n+pznbbx1VraCBJcEoBGAFjsYdkaUqdxxw5vqVvoSJQlzROXjg5u4bvG28lDB362kHVUny3JeiDtTVs+K8Bthf89veD0ZpIGcMZnctVNcBCcvPul56Dll04UJua6G0HcAfE0DTq2t2o1Lz4MJsG6Uq2IEObydHqXsYCXbEO+Ez6pIIfsuggcVLEDeEDOoaVuhzmiWcqpDeDafgu51g7PQJ1pEfO3YQHpCMt3Cf6Z8yqBlEqwi+Abz4PMsfGW+buWrHdxiDKAuQXFrkltP4KSjP67qhg9lm/PumhP+8
 DNGU3SSr
 16sn9ZT77WF9mW5bQ6f61lWBGE6h4zxA73QKAP5e0LZYl1iPVoU0PczBr8NXYDN6SrP9AaPgaWiRHf2Pv78097Xn2a7nYk1XRB6fAFRysaQK71Dxjqd4EUs6uPGUfwW+bWTd1MzNztr9F5UuQdgpOWA18zY818+PQ5aklCRpeMdHr0MAOfa3qbJ4zeAmAMSHhmiBb1x+BkjlW521CMb2WBUoK1KpM4jaaiv0q55rpgViozo3PNI/29baM2sADpAyEKKRq1iiURxklLZ0dUkQzUMzygieQOvu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


This series tightens the alignment requirements for buffers that are shared
between confidential-computing guests and the host, and adds a common
allocator for host-shared memory.

When a guest runs with private memory, buffers shared with the hypervisor
are not only accessed by the guest. They are also accessed by the host
kernel, and the host may manage the corresponding shared/private state at a
granularity larger than the guest page size.

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
alloc_cc_shared_pages(). The allocator rounds a request to the architecture
shared granule, allocates suitably aligned contiguous pages, transitions
the complete allocation to shared state, and returns the transitioned size
alongside the page.

The corresponding free helper restores the complete allocation to private
state before returning it to the buddy allocator. If private state cannot
be restored safely, the allocation is deliberately leaked rather than
returning potentially shared memory for unrelated use.

The series also makes zeroing part of private-to-shared transitions, with
each architecture clearing memory at the appropriate point. Callers must
therefore initialize shared buffers after the transition; existing contents
are not preserved.

The shared-granule size defaults to PAGE_SIZE and can be overridden by an
architecture. The arm64 CCA changes to discover the host's IPA state change
alignment are not included in this series.

GIC ITS command queues and tables and the dma-buf system_cc_shared heap
use the common allocator. DMA direct, atomic DMA pools and SWIOTLB retain
their allocation paths and use the common layout or transition helpers.
Restricted DMA pools are checked for shared-granule alignment.

Hyper-V users of set_memory_encrypted() and set_memory_decrypted() are not
changed by this series. Those paths are not currently used by the arm64 CCA
code path, and therefore are not part of the arm64 CCA IPA state change
alignment problem addressed here.

The series also preallocates GIC ITS VPE L1 tables so shared-memory
transitions are performed in a context that may sleep.

Notes:
* I have not added explicit MAINTAINERS entries for mm/cc_shared.c and
  include/linux/cc_shared.h, as I am unsure whether we need a separate section
  for common CoCo-related files. I will add the entries based on feedback.
* Codex assisted with implementation, review and series organization.

Changes from v8:
https://lore.kernel.org/all/20260924100529.1398790-1-aneesh.kumar@kernel.org
* Rebase onto the 7.4-rc1
* Move TDX and AMD (including SEV-SNP) zeroing to their finish callbacks
  so private-to-shared transitions clear the final shared mapping.
* Clear __GFP_MOVABLE for shared allocations, which cannot be migrated.
* Resolve NUMA_NO_NODE in the common ITS allocation helper to preserve
  placement for all ITS callers.
* Stop SWIOTLB allocation retries when the reduced pool would fall below
  the shared granule size, avoiding an allocation retry loop.

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
Cc: linux-media@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org
Cc: patches@lists.linux.dev


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
 arch/powerpc/platforms/pseries/svm.c          |   2 +
 arch/s390/mm/init.c                           |   3 +
 arch/x86/coco/tdx/tdx.c                       |   3 +
 arch/x86/hyperv/hv_init.c                     |   6 +-
 arch/x86/hyperv/ivm.c                         |   4 +
 arch/x86/kernel/kvmclock.c                    |   6 +-
 arch/x86/mm/mem_encrypt_amd.c                 |   4 +
 drivers/dma-buf/heaps/system_heap.c           | 128 +++++-----
 drivers/firmware/arm_rmm/rsi.c                |   4 +
 drivers/hv/connection.c                       |  41 ++-
 drivers/hv/hv.c                               |  11 +-
 drivers/hv/hv_common.c                        |   2 -
 drivers/iommu/dma-iommu.c                     |   2 +-
 drivers/irqchip/irq-gic-v3-its.c              | 152 +++++++++---
 drivers/irqchip/irq-gic-v3.c                  |   4 +-
 drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c |   3 +
 include/linux/cc_shared.h                     |  39 +++
 include/linux/dma-map-ops.h                   |   9 +-
 include/linux/irqchip/arm-gic-v3.h            |   3 +-
 kernel/dma/contiguous.c                       |  41 ++-
 kernel/dma/direct.c                           |  73 ++++--
 kernel/dma/ops_helpers.c                      |   2 +-
 kernel/dma/pool.c                             |  27 +-
 kernel/dma/swiotlb.c                          |  87 +++++--
 kernel/kexec_file.c                           |   3 +-
 mm/Makefile                                   |   1 +
 mm/cc_shared.c                                | 233 ++++++++++++++++++
 28 files changed, 693 insertions(+), 205 deletions(-)
 create mode 100644 include/linux/cc_shared.h
 create mode 100644 mm/cc_shared.c


base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
prerequisite-patch-id: 1d4a2fa9dc0f4b560e55f419d23835f0a9fbe485
-- 
2.43.0


