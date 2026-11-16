Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D47B1606A32A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 09:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Uyb2DaQC
Received: by kanga.kvack.org (Postfix)
	id D2C9F6B05B4; Mon, 16 Nov 2026 04:12:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDE226B05B5; Mon, 16 Nov 2026 04:12:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA6276B05B6; Mon, 16 Nov 2026 04:12:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 92D3C6B05B4
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:12:01 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 23785140565
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:12:01 +0000 (UTC)
X-FDA: 85440415242.12.A38E984
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7F17A100004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:11:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Uyb2DaQC;
	spf=pass (imf14.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794820319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=w3ZTI2Hxpp8i0Nf4hdErNJ38SFIe71jHPYvPRCA1ED0=;
	b=7v8e8j0Q4Z5ynuASL7r4oCpyMYX4SkEe9kKl/1S5pJz/0748k25D9cU2MkysbwebpnFksw
	o6O1BPBA03z3AaFMPuVx/+gx3zkrYO9trWK92K87DcdwZEDH1pGT1Ykro0MrRr9RPctiAV
	ICeFGAIJcdQhz9UUPf8SBXMROmdlaFM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794820319;
	b=Qgk9tALjI3e5Y/sgqZdg1D+8/WTI1vnug8RAtCkrwlKreH2SeEPr1F7s4+9R7Jln/DXdFo
	7qZDXpuxsX48vNmU+h81FYSB15cKzVkD4ueRUa7ZSCdX40rBYqxm4kVhm5mX9WpLfXST7C
	IN1Vx0ZHEcQG0QKWWE9uiwcWW71yK/c=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Uyb2DaQC;
	spf=pass (imf14.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E5A52627FC;
	Mon, 16 Nov 2026 09:11:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 008BB1F000C4;
	Mon, 16 Nov 2026 09:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794820318;
	bh=w3ZTI2Hxpp8i0Nf4hdErNJ38SFIe71jHPYvPRCA1ED0=;
	h=From:To:Cc:Subject:Date;
	b=Uyb2DaQCAcHg85gbVmEVzpWpk6cmUuQqb7L3dErPgBimrtNH86oMfqwAwDJKZIuZS
	 d/pzsSf0375D2Go2BKd6dIXZKeeYz/iB89b+kk1IfO1JTN/VTdLsq838cn/oIKUHhh
	 8c/PUUfnDANeuad296V9eMDCARmnazBLzWmMvE5zaeNSMYDn5ZUttTQyYD7WHrE8QY
	 1AwiiaItY6Z4MBj8zI13BoPXPTmA3KFrCE/vqBp7iR8vrO0UgKme2FAd9uXkuKUdY8
	 iCf7ja74Uz8JlZ60MJ9Yp7ZGPZh+jV1gsLPGwZRuAVi+v3lBjuyEgqnf2fpPULqx/n
	 RBo3ZCLh5dD9w==
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
Subject: [PATCH v10 00/13] coco: guest: Add a shared-granule allocator for host-shared memory
Date: Mon, 16 Nov 2026 14:41:23 +0530
Message-ID: <20261116091137.94252-1-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7F17A100004
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 4i6wkfhwt6yjzwzs84gs7gquobunox4j
X-Rspam-User: 
X-HE-Tag: 1794820319-415833
X-HE-Meta: U2FsdGVkX196uF2g+wM5VpY5BPvIjtIHCaQv4W0XgzTAMg8buCR5AwC7v+eIgtUU46aqmm5iaxJpETEI8XqAbW4YlAJwTYlet25y5pkK/uPPBzpsb7wEfUfgKfOV7/LN/B3Tk76W36JGN1WKNi+UynvdjCMWcXjxamapKuD0m298GP21S91rxX7fTV4b05UjUiElfqS32fy1o0i0eWttPaJbf1EADUhodrM1jz+fgC5L6DQ67pQrO5hVCQoqX076pn+dK2/0Z4ptQz3KN6Vy7RI+CYpuT+no3JxK0X4QldJD5e9tfoXaBtwSeD1/aKJUujghAapxmPGKZgtxYW3T/k7JhZyGYvs/egn8JLS0BSB+TEZV5g/lj1COfFQ/l9GXlx8nBGN1oZ8fuzmBjUC0LIIJo9dlCuUR0oOQc6ueXPefyFS87qIPPNf1qjZst9FYWicsSN91ZmV+DXjzrRUHHCnqPFmxFt8YbjykQQ7jFwOuYg4pTn5MPPqHdiUsKw6D2+qt7myAqh2LZ/MrpH68LprNty1SONlKplfcztnywRThLz0ibOSYRUF8EHuBbdCDltKuYyFNJIsWhb/KeOTkCakwsmZshSCv6g840oQueNp62aKpLP1/8ydkrSTZ5f2h20SfldLneEWPqfF2PE5cVMR3INiQ5NCMqTwM2KzQyDMHLYj7IdhkTtDfgb6bEe72T8lA51/WrumPcWqvoY3DXji1sng/cSBuQx09wwbjG0K8qtDIMSGKVp9fmHofjJD8ZKe/yCnq+D5FPVAsbbpeHovMsZNpheaTtV4qm/E2Ij7rdyyams0fbhQB2BF8aEs+uM9ZxD1zvix22KeD7IcwqOFGYa3l3jL3grEv0gzmB/zGHpRA9y0rR2bMu0rNAWrUBy40BBTxdCjmbHDQE9UKsxu8a18dNZNicQW/qMJAUwDjN1PgyN39o4TSKm4q0ALuwT09OlJJLpD6ymYuyVv
 yu3PKy3x
 VSRwHJxFV6Ho34O8+V1fgcYNaR+m+I9dxqv2b4GuTDFTbpgN2oEP8fZvUnwjMrXbg0c6oqJK26RJWIq3fw3cv2hbyo4xXmDsJ0922SAkfzKng5Ft0tlQFUQAE2qYe2yV5Ra10nZuFsGir4/Sb+aoKsJ53RjdUD+nR/6zXuOtDQLUxipZ5O7ZfhLeqvbdS8+BgUVNATjfQTpXCAcx7yIITOQfKM31CXpvoF7fxqJe3mF4W+kwXfMfz6fHJRORkD0FdSJs4MZZhLFv8f7dpSia9XVVo7SqSh5Xmhz1RXFLXn3wI3dkCekdOVMSQEO2DCnZjq4JJpGXmpLQykCz07RNknc+VCeySHTenLh9TNdNpGJdAMRzHcnod4tA/gyJCyZi7CLwtjXXXQmDdxZfuVD49DeaA2ObjO/w+eHqXfEwI8Gqw4d0twvFQS5zwlbojXYTd3PwBHZLgfFvbwHFcBNVW9bk02+GMDUKHySB2AcY2Ri6NdNwzvdLffUy6uW0sf8f3U9iq6LHG1sGNdTd52omT3Fw2+6tgVmtWf3e09GM0Qgt/NpmTvW0t+JRkxJfxd6UqjW7p2A5s6EK/+jsRFSXoIXjN+dU2UXtej9HwUEQNNReMGHFZmZhJqJbmlO9okliOOYhVuZPaTQGXKcumI4VA9J/VqHFiCOthlFa9llIKCKVxKqxQnqGXoMncwAMe9tpDvrrvEsqiSBIEZMLahdXuTiJcgSov8G/VeeL4QC9oPQLoLiVqdSJWg2Cd1Rq7R7lH28KXUt6sWuaEcOQqOaKF4CT5ZvS0E4RHQD9dupbA2goAhouJxX5YhnU5XhiSECt/fJe7h2WJxDOB7nAXNFUoOy8SsxqLMtaZTFaE9caVvhfieLMSZ52b7TMnvaXNl8YC4nKV7UxPjfJZ/j00mJx8/AqbJjYonhSGInGcQ2SXCUt5Xwp+XfrWdLY1pVSGu5D8PodEy+ewrJxuOC/MeL+hFKN+r+3p
 2vqBLFc9
 JXiFju8HkgXKldcZ7LWS4qVlpEzuqW6vbhacfP+/M0EOm3pW53uGh7eHD5zT6M/SlNchVBR2zv1CIXxKv4YIBpIYT2RNAWTtHI3eFEskfzCHu6CzGxz/JrBzqvCeK90KSvE28AeiNoeqbp31jrukcMs6RyaKfRdQau6F1jvjXOqRxlsJr7ZG3jOXXPIDlqM7KMhKEL4fqP6J4ivV+dxL9lLSwBhZDcwD0ziNov+u8IBAIh+NwijLWlvthrgPrcL+f8ihIgc3QoaO4ZibSoG3R1Mky5MT6cIs
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
changed to use cc_make_shared() by this series. Those paths are not
currently used by the arm64 CCA code path, and therefore are not part of
the arm64 CCA IPA state change alignment problem addressed here.

Notes:
* Codex assisted with implementation, review and series organization.

Changes from v9:
https://lore.kernel.org/all/20261104164555.3555725-1-aneesh.kumar@kernel.org
* Leak allocations after failed sharing in the common allocator and SWIOTLB.
* Move x86 zeroing from the AMD, TDX and Hyper-V vTOM callbacks to
  set_memory_decrypted(), after a successful transition
* Add set_memory_decrypted_nozero() for VGA mappings, which must change
  memory attributes without clearing device memory.
* Zero memory even when encryption is inactive in the generic, arm64 and
  pSeries implementations of set_memory_decrypted().
* Move pSeries zeroing after sharing. Document why pKVM and s390 must clear
  private contents before sharing
* Drop the GIC ITS VPE L1 preallocation patch from this series.
  This issue predates the series and will be addressed separately.
* Add mm/cc_shared.c and include/linux/cc_shared.h to the TSM MAINTAINERS
  entry.

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
Cc: patches@lists.linux.dev

Aneesh Kumar K.V (Arm) (13):
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

 MAINTAINERS                                   |   2 +
 arch/arm/mm/dma-mapping.c                     |   5 +-
 arch/arm64/mm/mem_encrypt.c                   |   8 +-
 arch/powerpc/platforms/pseries/svm.c          |  13 +-
 arch/s390/mm/init.c                           |   7 +
 arch/x86/hyperv/hv_init.c                     |   6 +-
 arch/x86/include/asm/set_memory.h             |   1 +
 arch/x86/include/asm/vga.h                    |   4 +-
 arch/x86/kernel/kvmclock.c                    |   6 +-
 arch/x86/mm/mem_encrypt_amd.c                 |   1 +
 arch/x86/mm/pat/set_memory.c                  |  19 +-
 drivers/dma-buf/heaps/system_heap.c           | 128 +++++-----
 drivers/firmware/arm_rmm/rsi.c                |   9 +
 drivers/hv/connection.c                       |  41 ++-
 drivers/hv/hv.c                               |  11 +-
 drivers/hv/hv_common.c                        |   2 -
 drivers/iommu/dma-iommu.c                     |   2 +-
 drivers/irqchip/irq-gic-v3-its.c              |  42 ++--
 drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c |   4 +
 include/linux/cc_shared.h                     |  39 +++
 include/linux/dma-map-ops.h                   |   9 +-
 include/linux/set_memory.h                    |   8 +-
 kernel/dma/contiguous.c                       |  41 ++-
 kernel/dma/direct.c                           |  73 ++++--
 kernel/dma/ops_helpers.c                      |   2 +-
 kernel/dma/pool.c                             |  27 +-
 kernel/dma/swiotlb.c                          |  94 ++++---
 kernel/kexec_file.c                           |   3 +-
 mm/Makefile                                   |   1 +
 mm/cc_shared.c                                | 238 ++++++++++++++++++
 30 files changed, 635 insertions(+), 211 deletions(-)
 create mode 100644 include/linux/cc_shared.h
 create mode 100644 mm/cc_shared.c


base-commit: aebb7274476403040d582c61478df8f4a7bf9cd3
prerequisite-patch-id: 121492d71cc22b2adbfdedd668868c5a449ad764
prerequisite-patch-id: ed31fd728f0adba3d60dcd6f3bae8da1a2193bcc
-- 
2.43.0


