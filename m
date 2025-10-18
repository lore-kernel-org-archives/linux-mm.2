Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13EB3CCD193
	for <linux-mm@archiver.kernel.org>; Sat, 18 Oct 2025 09:30:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C54E8E0008; Sat, 18 Oct 2025 05:30:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 674CB8E0002; Sat, 18 Oct 2025 05:30:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DDF68E0008; Sat, 18 Oct 2025 05:30:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ECF478E0002
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 05:30:22 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 725FFC03FB
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 09:30:22 +0000 (UTC)
X-FDA: 84010714284.03.3F1EC6C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9F9E1C0007
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 09:30:20 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kKC5okxE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760779820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nqe1Un4dmIdrBeJE7SDqAlqRE5x4rcM1MeRtZZN4t3g=;
	b=Epy+cbvoIPIVBs72LRwmHG7f+gmDewn8f9F3Y3maF5bSucTmpGZ1hUXWa6Pen/wWZFRph4
	SdSHTRhzVxJdH0zIiEn4+FaLU/oT345ZlF8A0+TczlRkRJFRcGSAbStX6ty2xzcZY6Owjm
	OKcN8mYnJsDzrLYEqi5fMNxkdnBzJ20=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760779820; a=rsa-sha256;
	cv=none;
	b=FM0Dho995JGCHZMSL/9/TPVNagt+iyTeiy3JLBH5umIcdkQIM6iNI4JWwEFQ+anOmTAb64
	w2cuOVdJavInCHmNxw2keSU/5jsxdAy1oNhdn4prg9oNoY3CLIjU5K+XvvcbAO2z42Bozg
	hgsp3fyYto8FVZaf2Dlt9iX9ZyYRoVc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kKC5okxE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A6D6260611;
	Sat, 18 Oct 2025 09:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01055C116C6;
	Sat, 18 Oct 2025 09:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760779819;
	bh=FMcj6/gnvlpAPzBySFtCmuvLQ81AZm/jSe2FoxqdBrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kKC5okxEiiKdkjOTJtclkbbWLSFrZPsADwLz48pUdp4FDxmt3Q1ODSuB+bEHh9OoY
	 J77PiWVelZ7KTejabqYWLsS76JjVCl/QWchFTt7f8PihUzfSc8cTK4GcxrYiFOIF8P
	 rgoE/gXYWmdnj4BMtOmsLpRIpBox+db2E8ZCe+Qm/cDlV7YLcqHxjLsjEUlfd+nEeX
	 /cSSHAl8BpxxruQE/V/1qAh1FXMrO7hv9iMUIr/+QywnWYZu4zd3NubWIsxRaqaX3C
	 UzQZf4NSxRUskwFLf6yM0XMQff6l1K+WWq6M1GGk2sNmISUPTofbyNyvbkjqVs8PxL
	 xgPUNZ7Ej5rLw==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brendan Jackman <jackmanb@google.com>,
	David Hildenbrand <david@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Julia Lawall <Julia.Lawall@inria.fr>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/3] mm, treewide: make get_free_pages() and friends return void *
Date: Sat, 18 Oct 2025 12:30:01 +0300
Message-ID: <20251018093002.3660549-3-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251018093002.3660549-1-rppt@kernel.org>
References: <20251018093002.3660549-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: 6pkdhyx3hey4k46ooz6cy135yhjtradf
X-Rspam-User: 
X-Rspamd-Queue-Id: 9F9E1C0007
X-HE-Tag: 1760779820-115308
X-HE-Meta: U2FsdGVkX1/RRsUp7VzvsP0HBcqYp3EGI5G5ctBfXcMldoYvIeikwtDbgXRsdHNrkz7zv6RbfVD6m/A31nU1mx+oT8GP1JAVpLB3Ya423K6HUr56vMuqD/NVTLW8ca7w/x1YzbU34zToTC/A1ZByvBsfMRE8Am2TJlvAsC1moWxe4lOZ+C5yKDPxqLCKOdDeahhgxsZ7rzjQlneZHm1K5AcSjfFp5nTL5aiPoDa4hoA+989DIUDwEUnETxxhJN44KQSaX7GVX2DVgNLKXxpJkE7i/nMUyejdc6onpWBA7RL/0HxHRMS8MagUz1ZQQvROPJfpwvabd/16Ktf3c+GX/w7sxcqWFJ7jL5yQjrDpciZQyx9DOV50QdjCN3bEgWq2oPGaOKIq8eWOJZ/XUCVY85n5j5FGseOTJ2KWUftUoKDAp4uoEZCYD3/YRGN9lgv9eJdewoGEeHC84w6j4IED7HUQxLhlnvvTdTM6QIt0s71lig3T2O466Okzc2+mWOADeFL48iK891IX6sqZB+ZSbYMLk+h3ES9YuzAwyhK9nXchVF6taAZ3Uv4A17rqdFyBHhCR6g5pY5v1fsve1HFlouWkV0y1g29XdhzVYtH3l5zV3JfqTjLmGPWDosPAenpCQRycBoAdezvvS6NIOJ+BvsSI8LZFyeEWupu437dFvRhi/DMH+dpHDvSfOMQvqe7a8wH1r6+uJ1FelPxiN3EMsjF0NDaUeQ/oen5Ye3cbcSkZSloKj1ab5LxgdGrXLLYGVmscnjMZ8bTi/zE75TEwTXQNIqaCGaxw+WRrKqGkHnUHezXmHBhdtH1BFf6kwXank1QvktX6EVheJO8uGLW3TvyO3FyC5x9MhxJpqlEI4lLoTdybXxeHTOByNur7nk+hQ51prEDhHxN8rdb+fMF5WbeHDHD+UnN6F7Yz5JT71bmSgS5Om/nBClpvfGE/eDc4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Vast majority of allocations that use get_free_pages() and it's
derivatives cast the returned value to a pointer type.

Make get_free_pages() and it derivatives return 'void *' with the exception of __get_dma_pages() whose callers all expect an unsigned long.

The call sites are updated with the semantic patch below and a bit of
manual tweaking.

    @@
    type T;
    T addr;
    expression gfp, order;
    @@
    (
    - addr = __get_free_pages(gfp, order)
    + addr = (T)__get_free_pages(gfp, order)
    |
    - addr = __get_free_page(gfp)
    + addr = (T)__get_free_page(gfp)
    |
    - addr = get_zeroed_page(gfp)
    + addr = (T)get_zeroed_page(gfp)
    )

    @@
    type T;
    @@
    (
    - (T *)
      \(__get_free_pages\|get_zeroed_page\|__get_free_page\)(...)
    )

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/alpha/kernel/pci_iommu.c                 |  2 +-
 arch/alpha/kernel/srm_env.c                   |  4 +--
 arch/arc/kernel/setup.c                       |  2 +-
 arch/arm/kernel/irq.c                         |  2 +-
 arch/arm/kernel/traps.c                       |  2 +-
 arch/arm/xen/enlighten.c                      |  2 +-
 arch/arm64/kernel/vdso.c                      |  4 +--
 arch/arm64/kvm/arm.c                          |  3 ++-
 arch/arm64/kvm/mmu.c                          |  4 +--
 arch/arm64/kvm/nested.c                       |  2 +-
 arch/arm64/mm/mmu.c                           |  2 +-
 arch/loongarch/kvm/main.c                     |  2 +-
 arch/loongarch/kvm/mmu.c                      |  2 +-
 arch/m68k/sun3/sun3dvma.c                     |  2 +-
 arch/mips/jazz/jazzdma.c                      |  2 +-
 arch/mips/kernel/irq.c                        |  2 +-
 arch/mips/kvm/mmu.c                           |  2 +-
 arch/nios2/mm/init.c                          |  2 +-
 arch/parisc/kernel/pci-dma.c                  |  4 +--
 arch/powerpc/include/asm/book3s/64/pgalloc.h  |  2 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c           |  4 +--
 arch/powerpc/kvm/book3s_pr.c                  |  2 +-
 arch/powerpc/kvm/book3s_xive.c                |  2 +-
 arch/powerpc/kvm/booke.c                      |  4 +--
 arch/powerpc/kvm/e500.c                       |  2 +-
 arch/powerpc/kvm/e500mc.c                     |  2 +-
 arch/powerpc/mm/book3s64/subpage_prot.c       |  4 +--
 arch/powerpc/platforms/cell/spufs/inode.c     |  2 +-
 arch/powerpc/platforms/ps3/system-bus.c       |  2 +-
 arch/powerpc/platforms/pseries/iommu.c        |  4 +--
 .../platforms/pseries/pseries_energy.c        |  2 +-
 arch/s390/crypto/aes_s390.c                   |  2 +-
 arch/s390/crypto/des_s390.c                   |  2 +-
 arch/s390/crypto/paes_s390.c                  |  2 +-
 arch/s390/crypto/prng.c                       |  2 +-
 arch/s390/hypfs/hypfs_diag_fs.c               |  2 +-
 arch/s390/hypfs/hypfs_sprp.c                  |  4 +--
 arch/s390/include/asm/idals.h                 |  2 +-
 arch/s390/kernel/ipl.c                        | 16 ++++++------
 arch/s390/kernel/perf_cpum_sf.c               | 10 +++----
 arch/s390/kernel/perf_pai_crypto.c            |  8 +++---
 arch/s390/kernel/perf_pai_ext.c               |  6 +++--
 arch/s390/kernel/smp.c                        |  5 ++--
 arch/s390/kernel/sthyi.c                      |  8 +++---
 arch/s390/kernel/sysinfo.c                    |  4 +--
 arch/s390/kernel/time.c                       |  2 +-
 arch/s390/kvm/intercept.c                     |  2 +-
 arch/s390/kvm/interrupt.c                     |  2 +-
 arch/s390/kvm/kvm-s390.c                      |  8 +++---
 arch/s390/kvm/priv.c                          |  4 +--
 arch/s390/kvm/pv.c                            | 17 +++++++-----
 arch/s390/kvm/vsie.c                          |  2 +-
 arch/s390/mm/cmm.c                            |  4 +--
 arch/s390/mm/maccess.c                        |  2 +-
 arch/s390/mm/vmem.c                           |  2 +-
 arch/s390/pci/pci_clp.c                       |  2 +-
 arch/s390/pci/pci_report.c                    |  2 +-
 arch/sh/boards/mach-hp6xx/pm.c                |  2 +-
 arch/sh/kernel/vsyscall/vsyscall.c            |  2 +-
 arch/sparc/kernel/irq_64.c                    |  6 ++---
 arch/sparc/kernel/ldc.c                       |  4 +--
 arch/sparc/kernel/pci_fire.c                  |  3 ++-
 arch/sparc/kernel/pci_sun4v.c                 |  7 ++---
 arch/sparc/kernel/traps_64.c                  |  2 +-
 arch/sparc/mm/io-unit.c                       |  2 +-
 arch/sparc/mm/iommu.c                         |  4 +--
 arch/um/kernel/process.c                      |  2 +-
 arch/um/kernel/skas/mmu.c                     |  3 ++-
 arch/x86/hyperv/ivm.c                         |  2 +-
 arch/x86/kernel/amd_gart_64.c                 |  6 ++---
 arch/x86/kernel/ldt.c                         |  2 +-
 arch/x86/kernel/machine_kexec_32.c            | 10 +++----
 arch/x86/kernel/machine_kexec_64.c            |  8 +++---
 arch/x86/kvm/lapic.c                          |  2 +-
 arch/x86/kvm/mmu/mmu.c                        |  6 ++---
 arch/x86/kvm/mmu/tdp_mmu.c                    |  2 +-
 arch/x86/kvm/svm/avic.c                       |  4 +--
 arch/x86/kvm/vmx/nested.c                     |  2 +-
 arch/x86/kvm/vmx/sgx.c                        |  2 +-
 arch/x86/kvm/vmx/vmx.c                        |  2 +-
 arch/x86/mm/init.c                            |  2 +-
 arch/x86/mm/init_64.c                         |  2 +-
 arch/x86/mm/pat/set_memory.c                  |  8 +++---
 arch/x86/mm/pgtable.c                         |  2 +-
 arch/x86/mm/pti.c                             |  8 +++---
 arch/x86/pci/pcbios.c                         |  2 +-
 arch/x86/platform/efi/efi.c                   |  2 +-
 arch/x86/platform/efi/efi_64.c                |  2 +-
 arch/x86/xen/mmu_pv.c                         |  4 +--
 arch/x86/xen/p2m.c                            |  2 +-
 arch/x86/xen/pmu.c                            |  2 +-
 arch/x86/xen/time.c                           |  2 +-
 block/partitions/core.c                       |  2 +-
 crypto/scatterwalk.c                          |  2 +-
 crypto/tcrypt.c                               |  4 +--
 crypto/testmgr.c                              |  2 +-
 crypto/xor.c                                  |  2 +-
 drivers/acpi/nvs.c                            |  2 +-
 drivers/atm/eni.c                             |  2 +-
 drivers/atm/lanai.c                           |  2 +-
 drivers/auxdisplay/cfag12864b.c               |  2 +-
 drivers/auxdisplay/ht16k33.c                  |  2 +-
 drivers/base/devres.c                         |  2 +-
 drivers/block/aoe/aoecmd.c                    |  2 +-
 drivers/block/drbd/drbd_main.c                |  4 +--
 drivers/block/ps3vram.c                       |  2 +-
 drivers/block/ublk_drv.c                      |  2 +-
 drivers/char/agp/agp.h                        |  2 +-
 drivers/char/agp/amd-k7-agp.c                 |  2 +-
 drivers/char/agp/ati-agp.c                    |  2 +-
 drivers/char/agp/efficeon-agp.c               |  2 +-
 drivers/char/agp/sworks-agp.c                 |  2 +-
 drivers/char/agp/uninorth-agp.c               |  2 +-
 drivers/char/hw_random/s390-trng.c            |  2 +-
 drivers/char/tpm/tpm-buf.c                    |  4 +--
 drivers/char/tpm/tpm_ibmvtpm.c                |  2 +-
 drivers/char/xilinx_hwicap/xilinx_hwicap.c    |  4 +--
 drivers/char/xillybus/xillyusb.c              |  4 +--
 drivers/comedi/comedi_buf.c                   |  2 +-
 drivers/crypto/atmel-aes.c                    |  2 +-
 drivers/crypto/atmel-tdes.c                   |  4 +--
 drivers/crypto/ccp/tee-dev.c                  |  2 +-
 .../crypto/inside-secure/eip93/eip93-common.c |  2 +-
 drivers/crypto/nx/nx-842.c                    |  4 +--
 drivers/crypto/omap-crypto.c                  |  2 +-
 drivers/crypto/omap-sham.c                    |  2 +-
 drivers/crypto/s5p-sss.c                      |  4 +--
 drivers/crypto/stm32/stm32-hash.c             |  2 +-
 drivers/dma/nbpfaxi.c                         |  2 +-
 drivers/dma/sh/rcar-dmac.c                    |  4 +--
 drivers/dma/ste_dma40.c                       |  4 +--
 drivers/extcon/extcon.c                       |  2 +-
 drivers/firmware/efi/efi.c                    |  2 +-
 drivers/firmware/psci/psci_checker.c          |  2 +-
 drivers/fsi/fsi-occ.c                         |  2 +-
 drivers/fsi/fsi-sbefifo.c                     |  2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_events.c       |  2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_process.c      |  2 +-
 drivers/gpu/drm/i915/gt/selftest_lrc.c        |  2 +-
 drivers/gpu/drm/i915/gt/uc/intel_guc_log.c    |  2 +-
 drivers/gpu/drm/i915/gvt/gtt.c                |  6 ++---
 drivers/gpu/drm/i915/gvt/opregion.c           |  2 +-
 drivers/gpu/drm/tegra/drm.c                   |  2 +-
 drivers/hsi/clients/cmt_speech.c              |  2 +-
 drivers/hv/connection.c                       |  6 ++---
 drivers/hv/hv.c                               |  6 ++---
 drivers/infiniband/core/umem.c                |  2 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c      |  6 ++---
 drivers/infiniband/hw/bnxt_re/main.c          |  2 +-
 drivers/infiniband/hw/cxgb4/device.c          |  2 +-
 drivers/infiniband/hw/cxgb4/mem.c             |  2 +-
 drivers/infiniband/hw/mlx4/mr.c               |  2 +-
 drivers/infiniband/hw/mlx5/main.c             |  2 +-
 drivers/infiniband/hw/mlx5/odp.c              |  2 +-
 drivers/infiniband/hw/mlx5/umr.c              |  6 ++---
 drivers/infiniband/hw/mthca/mthca_allocator.c |  2 +-
 drivers/infiniband/hw/mthca/mthca_provider.c  |  2 +-
 drivers/infiniband/hw/qedr/verbs.c            |  2 +-
 drivers/infiniband/hw/usnic/usnic_uiom.c      |  2 +-
 drivers/infiniband/sw/rdmavt/qp.c             |  2 +-
 drivers/input/misc/xen-kbdfront.c             |  2 +-
 drivers/iommu/amd/iommu.c                     |  2 +-
 drivers/iommu/io-pgtable-arm-v7s.c            |  2 +-
 drivers/iommu/iommufd/iova_bitmap.c           |  2 +-
 drivers/iommu/iommufd/selftest.c              |  2 +-
 drivers/macintosh/rack-meter.c                |  2 +-
 drivers/md/bcache/bset.c                      |  8 +++---
 drivers/md/bcache/btree.c                     |  2 +-
 drivers/md/bcache/journal.c                   |  4 +--
 drivers/md/bcache/super.c                     |  2 +-
 drivers/md/dm-bufio.c                         |  4 +--
 drivers/media/pci/intel/ipu6/ipu6-mmu.c       |  8 +++---
 drivers/media/pci/pt1/pt1.c                   |  2 +-
 drivers/media/pci/saa7134/saa7134-go7007.c    |  4 +--
 drivers/media/pci/solo6x10/solo6x10-p2m.c     |  4 +--
 drivers/media/platform/ti/omap/omap_voutlib.c |  2 +-
 drivers/misc/ibmvmc.c                         |  2 +-
 drivers/misc/lkdtm/core.c                     |  6 ++---
 drivers/misc/lkdtm/heap.c                     | 12 ++++-----
 drivers/misc/ocxl/link.c                      |  2 +-
 drivers/mmc/host/renesas_sdhi_sys_dmac.c      |  2 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   |  2 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  |  1 -
 .../net/ethernet/broadcom/bnx2x/bnx2x_sp.c    |  2 +-
 drivers/net/ethernet/ibm/ehea/ehea_main.c     | 26 +++++++++----------
 drivers/net/ethernet/ibm/ehea/ehea_qmr.c      |  6 ++---
 drivers/net/ethernet/ibm/ibmveth.c            |  4 +--
 drivers/net/ethernet/ibm/ibmvnic.c            |  4 +--
 drivers/net/ethernet/intel/ice/ice_gnss.c     |  2 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  4 +--
 drivers/net/ethernet/mediatek/mtk_wed.c       |  2 +-
 .../mellanox/mlx5/core/diag/fw_tracer.c       |  2 +-
 .../ethernet/mellanox/mlx5/core/lib/clock.c   |  2 +-
 drivers/net/ethernet/meta/fbnic/fbnic_fw.c    |  2 +-
 drivers/net/ethernet/meta/fbnic/fbnic_tlv.c   |  2 +-
 drivers/net/ethernet/sfc/mcdi.c               |  2 +-
 drivers/net/ethernet/sfc/siena/mcdi.c         |  2 +-
 drivers/net/ethernet/sun/niu.c                |  2 +-
 .../net/ethernet/toshiba/ps3_gelic_wireless.c | 12 ++++-----
 drivers/net/rionet.c                          |  2 +-
 drivers/net/usb/kaweth.c                      |  2 +-
 drivers/net/wireless/broadcom/b43/debugfs.c   |  4 +--
 .../net/wireless/broadcom/b43legacy/debugfs.c |  4 +--
 .../net/wireless/marvell/libertas/debugfs.c   | 16 ++++++------
 .../net/wireless/marvell/mwifiex/debugfs.c    | 18 ++++++-------
 drivers/net/wireless/ti/wlcore/main.c         |  4 +--
 drivers/parisc/ccio-dma.c                     |  6 ++---
 drivers/parisc/sba_iommu.c                    | 14 +++++-----
 drivers/platform/goldfish/goldfish_pipe.c     |  4 +--
 drivers/platform/x86/dell/dell_rbu.c          |  4 +--
 drivers/power/supply/power_supply_sysfs.c     |  2 +-
 drivers/ptp/ptp_ocp.c                         |  2 +-
 drivers/ras/cec.c                             |  2 +-
 drivers/s390/block/dasd.c                     |  6 ++---
 drivers/s390/block/dasd_diag.c                |  2 +-
 drivers/s390/block/dasd_eckd.c                |  6 ++---
 drivers/s390/block/dasd_eer.c                 |  2 +-
 drivers/s390/block/dasd_fba.c                 |  4 +--
 drivers/s390/block/scm_blk.c                  |  2 +-
 drivers/s390/char/con3270.c                   |  2 +-
 drivers/s390/char/diag_ftp.c                  |  2 +-
 drivers/s390/char/hmcdrv_cache.c              |  2 +-
 drivers/s390/char/hmcdrv_ftp.c                |  4 +--
 drivers/s390/char/sclp.c                      |  4 +--
 drivers/s390/char/sclp_ap.c                   |  2 +-
 drivers/s390/char/sclp_cmd.c                  |  6 ++---
 drivers/s390/char/sclp_con.c                  |  2 +-
 drivers/s390/char/sclp_config.c               |  2 +-
 drivers/s390/char/sclp_cpi_sys.c              |  2 +-
 drivers/s390/char/sclp_ctl.c                  |  2 +-
 drivers/s390/char/sclp_ftp.c                  |  4 +--
 drivers/s390/char/sclp_mem.c                  |  6 ++---
 drivers/s390/char/sclp_pci.c                  |  4 +--
 drivers/s390/char/sclp_sd.c                   |  2 +-
 drivers/s390/char/sclp_sdias.c                |  2 +-
 drivers/s390/char/sclp_tty.c                  |  2 +-
 drivers/s390/char/sclp_vt220.c                |  2 +-
 drivers/s390/char/uvdevice.c                  |  2 +-
 drivers/s390/char/vmcp.c                      |  2 +-
 drivers/s390/char/vmlogrdr.c                  |  2 +-
 drivers/s390/char/vmur.c                      |  4 +--
 drivers/s390/char/zcore.c                     |  4 +--
 drivers/s390/cio/chsc.c                       |  8 +++---
 drivers/s390/cio/chsc_sch.c                   | 20 +++++++-------
 drivers/s390/cio/cmf.c                        |  2 +-
 drivers/s390/cio/qdio_main.c                  |  6 ++---
 drivers/s390/cio/qdio_setup.c                 |  6 ++---
 drivers/s390/cio/scm.c                        |  2 +-
 drivers/s390/crypto/zcrypt_api.c              |  2 +-
 drivers/s390/crypto/zcrypt_msgtype6.c         |  4 +--
 drivers/s390/net/qeth_core_main.c             |  2 +-
 drivers/s390/net/qeth_l2_main.c               |  2 +-
 drivers/s390/scsi/zfcp_fc.c                   |  2 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                |  2 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c              |  2 +-
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c      |  2 +-
 drivers/scsi/ipr.c                            |  2 +-
 drivers/scsi/libiscsi.c                       |  2 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c   |  4 +--
 drivers/scsi/ncr53c8xx.c                      |  3 ++-
 drivers/scsi/qedi/qedi_main.c                 |  6 ++---
 drivers/scsi/scsi_devinfo.c                   |  2 +-
 drivers/scsi/scsi_proc.c                      |  4 +--
 drivers/scsi/sym53c8xx_2/sym_hipd.h           |  2 +-
 drivers/scsi/vmw_pvscsi.c                     |  2 +-
 drivers/sh/maple/maple.c                      |  2 +-
 drivers/spi/spi-ep93xx.c                      |  2 +-
 drivers/spi/spi-rockchip-sfc.c                |  2 +-
 drivers/spi/spi-sh-msiof.c                    |  4 +--
 .../staging/media/atomisp/pci/mmu/isp_mmu.c   |  2 +-
 drivers/staging/media/av7110/av7110_ca.c      |  2 +-
 drivers/staging/media/ipu3/ipu3-mmu.c         |  4 +--
 drivers/staging/media/ipu7/ipu7-mmu.c         |  8 +++---
 drivers/target/target_core_file.c             |  2 +-
 drivers/tee/amdtee/core.c                     |  2 +-
 drivers/tee/amdtee/shm_pool.c                 |  2 +-
 drivers/thunderbolt/debugfs.c                 |  2 +-
 drivers/tty/amiserial.c                       |  2 +-
 drivers/tty/hvc/hvc_iucv.c                    |  2 +-
 drivers/tty/hvc/hvc_xen.c                     |  2 +-
 drivers/tty/hvc/hvcs.c                        |  2 +-
 drivers/tty/serial/men_z135_uart.c            |  2 +-
 drivers/tty/serial/pch_uart.c                 |  2 +-
 drivers/tty/serial/serial_core.c              |  2 +-
 drivers/tty/tty_port.c                        |  2 +-
 drivers/tty/vt/vc_screen.c                    |  4 +--
 drivers/usb/atm/cxacru.c                      |  6 ++---
 drivers/usb/atm/speedtch.c                    |  2 +-
 drivers/usb/core/buffer.c                     |  4 +--
 drivers/usb/core/devices.c                    |  2 +-
 drivers/usb/core/devio.c                      |  2 +-
 drivers/usb/host/ohci-dbg.c                   |  2 +-
 drivers/usb/mon/mon_bin.c                     |  2 +-
 drivers/usb/serial/usb_wwan.c                 |  2 +-
 drivers/vfio/vfio_iommu_type1.c               |  2 +-
 drivers/vhost/vdpa.c                          |  2 +-
 drivers/video/fbdev/ssd1307fb.c               |  2 +-
 drivers/video/fbdev/xen-fbfront.c             |  2 +-
 drivers/virt/vboxguest/vboxguest_utils.c      |  2 +-
 drivers/xen/events/events_base.c              |  4 +--
 drivers/xen/events/events_fifo.c              |  4 +--
 drivers/xen/evtchn.c                          |  2 +-
 drivers/xen/grant-table.c                     |  4 +--
 drivers/xen/pvcalls-front.c                   |  4 +--
 drivers/xen/swiotlb-xen.c                     |  2 +-
 drivers/xen/xenbus/xenbus_probe.c             |  2 +-
 fs/affs/file.c                                |  2 +-
 fs/bfs/inode.c                                |  2 +-
 fs/binfmt_misc.c                              |  2 +-
 fs/ceph/mds_client.c                          |  2 +-
 fs/configfs/file.c                            |  4 +--
 fs/ext4/super.c                               |  2 +-
 fs/fuse/ioctl.c                               |  2 +-
 fs/isofs/dir.c                                |  2 +-
 fs/jbd2/journal.c                             |  2 +-
 fs/jfs/jfs_dtree.c                            |  2 +-
 fs/libfs.c                                    |  2 +-
 fs/namespace.c                                |  2 +-
 fs/nfs/nfs4namespace.c                        |  4 +--
 fs/nfs/super.c                                |  2 +-
 fs/nfsd/vfs.c                                 |  2 +-
 fs/nilfs2/ioctl.c                             |  2 +-
 fs/ocfs2/dlm/dlmdebug.c                       |  8 +++---
 fs/ocfs2/dlm/dlmdomain.c                      |  2 +-
 fs/ocfs2/dlm/dlmmaster.c                      |  2 +-
 fs/ocfs2/dlm/dlmrecovery.c                    |  2 +-
 fs/proc/base.c                                |  8 +++---
 fs/proc/vmcore.c                              |  6 ++---
 fs/quota/dquot.c                              |  2 +-
 fs/select.c                                   |  2 +-
 include/linux/gfp.h                           |  6 ++---
 init/do_mounts.c                              |  2 +-
 kernel/dma/debug.c                            |  2 +-
 kernel/dma/swiotlb.c                          |  8 +++---
 kernel/kexec_handover.c                       |  2 +-
 kernel/power/snapshot.c                       |  6 ++---
 kernel/power/swap.c                           | 14 +++++-----
 kernel/trace/ftrace.c                         |  6 ++---
 kernel/trace/tracing_map.c                    |  2 +-
 kernel/vmcore_info.c                          |  2 +-
 lib/raid6/algos.c                             |  2 +-
 lib/scatterlist.c                             |  2 +-
 lib/test_free_pages.c                         |  2 +-
 mm/kasan/shadow.c                             |  2 +-
 mm/mincore.c                                  |  2 +-
 mm/mmu_gather.c                               |  4 +--
 mm/page_alloc.c                               | 16 ++++++------
 mm/slab_common.c                              |  4 +--
 mm/slub.c                                     |  2 +-
 net/9p/trans_xen.c                            |  2 +-
 net/atm/mpoa_proc.c                           |  2 +-
 net/atm/proc.c                                |  2 +-
 net/netfilter/nf_tables_api.c                 |  2 +-
 net/packet/af_packet.c                        |  4 +--
 net/rds/cong.c                                |  2 +-
 net/sctp/protocol.c                           |  2 +-
 net/xfrm/xfrm_hash.c                          |  2 +-
 security/apparmor/apparmorfs.c                |  2 +-
 security/integrity/ima/ima_crypto.c           |  4 +--
 security/selinux/hooks.c                      |  2 +-
 security/selinux/selinuxfs.c                  |  6 ++---
 sound/drivers/dummy.c                         |  2 +-
 virt/kvm/kvm_main.c                           |  2 +-
 363 files changed, 614 insertions(+), 600 deletions(-)

diff --git a/arch/alpha/kernel/pci_iommu.c b/arch/alpha/kernel/pci_iommu.c
index dc91de50f906..64c750fa6b3f 100644
--- a/arch/alpha/kernel/pci_iommu.c
+++ b/arch/alpha/kernel/pci_iommu.c
@@ -418,7 +418,7 @@ static void *alpha_pci_alloc_coherent(struct device *dev, size_t size,
 	gfp &= ~GFP_DMA;
 
 try_again:
-	cpu_addr = (void *)__get_free_pages(gfp | __GFP_ZERO, order);
+	cpu_addr = __get_free_pages(gfp | __GFP_ZERO, order);
 	if (! cpu_addr) {
 		printk(KERN_INFO "pci_alloc_consistent: "
 		       "get_free_pages failed from %ps\n",
diff --git a/arch/alpha/kernel/srm_env.c b/arch/alpha/kernel/srm_env.c
index 217b4dca51dd..f50c9083b78a 100644
--- a/arch/alpha/kernel/srm_env.c
+++ b/arch/alpha/kernel/srm_env.c
@@ -66,7 +66,7 @@ static int srm_env_proc_show(struct seq_file *m, void *v)
 	unsigned long	id = (unsigned long)m->private;
 	char		*page;
 
-	page = (char *)__get_free_page(GFP_USER);
+	page = __get_free_page(GFP_USER);
 	if (!page)
 		return -ENOMEM;
 
@@ -91,7 +91,7 @@ static ssize_t srm_env_proc_write(struct file *file, const char __user *buffer,
 {
 	int res;
 	unsigned long	id = (unsigned long)pde_data(file_inode(file));
-	char		*buf = (char *) __get_free_page(GFP_USER);
+	char		*buf = __get_free_page(GFP_USER);
 	unsigned long	ret1, ret2;
 
 	if (!buf)
diff --git a/arch/arc/kernel/setup.c b/arch/arc/kernel/setup.c
index 7b6a9beba9db..d9548c847580 100644
--- a/arch/arc/kernel/setup.c
+++ b/arch/arc/kernel/setup.c
@@ -581,7 +581,7 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 		goto done;
 	}
 
-	str = (char *)__get_free_page(GFP_KERNEL);
+	str = __get_free_page(GFP_KERNEL);
 	if (!str)
 		goto done;
 
diff --git a/arch/arm/kernel/irq.c b/arch/arm/kernel/irq.c
index e1993e28a9ec..9d57041c13fa 100644
--- a/arch/arm/kernel/irq.c
+++ b/arch/arm/kernel/irq.c
@@ -58,7 +58,7 @@ static void __init init_irq_stacks(void)
 
 	for_each_possible_cpu(cpu) {
 		if (!IS_ENABLED(CONFIG_VMAP_STACK))
-			stack = (u8 *)__get_free_pages(GFP_KERNEL,
+			stack = __get_free_pages(GFP_KERNEL,
 						       THREAD_SIZE_ORDER);
 		else
 			stack = __vmalloc_node(THREAD_SIZE, THREAD_ALIGN,
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index afbd2ebe5c39..ee00d07e05e2 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -909,7 +909,7 @@ static int __init allocate_overflow_stacks(void)
 	int cpu;
 
 	for_each_possible_cpu(cpu) {
-		stack = (u8 *)__get_free_page(GFP_KERNEL);
+		stack = __get_free_page(GFP_KERNEL);
 		if (WARN_ON(!stack))
 			return -ENOMEM;
 		per_cpu(overflow_stack_ptr, cpu) = &stack[OVERFLOW_STACK_SIZE];
diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index 8655bc3d3634..b9493e28cd9a 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -461,7 +461,7 @@ static int __init xen_guest_init(void)
 	if (efi_enabled(EFI_RUNTIME_SERVICES))
 		xen_efi_runtime_setup();
 
-	shared_info_page = (struct shared_info *)get_zeroed_page(GFP_KERNEL);
+	shared_info_page = get_zeroed_page(GFP_KERNEL);
 
 	if (!shared_info_page) {
 		pr_err("not enough memory\n");
diff --git a/arch/arm64/kernel/vdso.c b/arch/arm64/kernel/vdso.c
index 78ddf6bdecad..dfc59c276d1e 100644
--- a/arch/arm64/kernel/vdso.c
+++ b/arch/arm64/kernel/vdso.c
@@ -189,7 +189,7 @@ static int aarch32_alloc_kuser_vdso_page(void)
 	if (!IS_ENABLED(CONFIG_KUSER_HELPERS))
 		return 0;
 
-	vdso_page = get_zeroed_page(GFP_KERNEL);
+	vdso_page = (unsigned long)get_zeroed_page(GFP_KERNEL);
 	if (!vdso_page)
 		return -ENOMEM;
 
@@ -207,7 +207,7 @@ static int aarch32_alloc_sigpage(void)
 	__le32 poison = cpu_to_le32(COMPAT_SIGPAGE_POISON_WORD);
 	void *sigpage;
 
-	sigpage = (void *)__get_free_page(GFP_KERNEL);
+	sigpage = __get_free_page(GFP_KERNEL);
 	if (!sigpage)
 		return -ENOMEM;
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index f21d1b7f20f8..a09b9edfff50 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2571,7 +2571,8 @@ static int __init init_hyp_mode(void)
 	for_each_possible_cpu(cpu) {
 		unsigned long stack_base;
 
-		stack_base = __get_free_pages(GFP_KERNEL, NVHE_STACK_SHIFT - PAGE_SHIFT);
+		stack_base = (unsigned long)__get_free_pages(GFP_KERNEL,
+							     NVHE_STACK_SHIFT - PAGE_SHIFT);
 		if (!stack_base) {
 			err = -ENOMEM;
 			goto out_err;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 7cc964af8d30..fa59e7984554 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1101,7 +1101,7 @@ static void *hyp_mc_alloc_fn(void *mc)
 	struct kvm_hyp_memcache *memcache = mc;
 	void *addr;
 
-	addr = (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
+	addr = __get_free_page(GFP_KERNEL_ACCOUNT);
 	if (addr && memcache->flags & HYP_MEMCACHE_ACCOUNT_STAGE2)
 		kvm_account_pgtable_pages(addr, 1);
 
@@ -2157,7 +2157,7 @@ static int kvm_map_idmap_text(void)
 
 static void *kvm_hyp_zalloc_page(void *arg)
 {
-	return (void *)get_zeroed_page(GFP_KERNEL);
+	return get_zeroed_page(GFP_KERNEL);
 }
 
 static struct kvm_pgtable_mm_ops kvm_hyp_mm_ops = {
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 7a045cad6bdf..149cd43bb02a 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -76,7 +76,7 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
 		return -EINVAL;
 
 	if (!vcpu->arch.ctxt.vncr_array)
-		vcpu->arch.ctxt.vncr_array = (u64 *)__get_free_page(GFP_KERNEL_ACCOUNT |
+		vcpu->arch.ctxt.vncr_array = __get_free_page(GFP_KERNEL_ACCOUNT |
 								    __GFP_ZERO);
 
 	if (!vcpu->arch.ctxt.vncr_array)
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index b8d37eb037fc..a8ba67cade23 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1158,7 +1158,7 @@ static int __init __kpti_install_ng_mappings(void *__unused)
 	remap_fn = (void *)__pa_symbol(idmap_kpti_install_ng_mappings);
 
 	if (!cpu) {
-		alloc = __get_free_pages(GFP_ATOMIC | __GFP_ZERO, order);
+		alloc = (u64)__get_free_pages(GFP_ATOMIC | __GFP_ZERO, order);
 		kpti_ng_temp_pgd = (pgd_t *)(alloc + (levels - 1) * PAGE_SIZE);
 		kpti_ng_temp_alloc = kpti_ng_temp_pgd_pa = __pa(kpti_ng_temp_pgd);
 
diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
index 80ea63d465b8..1e00656ea806 100644
--- a/arch/loongarch/kvm/main.c
+++ b/arch/loongarch/kvm/main.c
@@ -366,7 +366,7 @@ static int kvm_loongarch_env_init(void)
 	 * need to copy world switch code to DMW area.
 	 */
 	order = get_order(kvm_exception_size + kvm_enter_guest_size);
-	addr = (void *)__get_free_pages(GFP_KERNEL, order);
+	addr = __get_free_pages(GFP_KERNEL, order);
 	if (!addr) {
 		free_percpu(vmcs);
 		vmcs = NULL;
diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
index 7c8143e79c12..ff56ec190395 100644
--- a/arch/loongarch/kvm/mmu.c
+++ b/arch/loongarch/kvm/mmu.c
@@ -113,7 +113,7 @@ kvm_pte_t *kvm_pgd_alloc(void)
 {
 	kvm_pte_t *pgd;
 
-	pgd = (kvm_pte_t *)__get_free_pages(GFP_KERNEL, 0);
+	pgd = __get_free_pages(GFP_KERNEL, 0);
 	if (pgd)
 		pgd_init((void *)pgd);
 
diff --git a/arch/m68k/sun3/sun3dvma.c b/arch/m68k/sun3/sun3dvma.c
index 225fc735e466..b81ab0a20788 100644
--- a/arch/m68k/sun3/sun3dvma.c
+++ b/arch/m68k/sun3/sun3dvma.c
@@ -326,7 +326,7 @@ void *dvma_malloc_align(unsigned long len, unsigned long align)
 	pr_debug("dvma_malloc request %lx bytes\n", len);
 	len = ((len + (DVMA_PAGE_SIZE-1)) & DVMA_PAGE_MASK);
 
-        if((kaddr = __get_free_pages(GFP_ATOMIC, get_order(len))) == 0)
+        if((kaddr = (unsigned long)__get_free_pages(GFP_ATOMIC, get_order(len))) == 0)
 		return NULL;
 
 	if((baddr = (unsigned long)dvma_map_align(kaddr, len, align)) == 0) {
diff --git a/arch/mips/jazz/jazzdma.c b/arch/mips/jazz/jazzdma.c
index c97b089b9902..558c2c0cb1b3 100644
--- a/arch/mips/jazz/jazzdma.c
+++ b/arch/mips/jazz/jazzdma.c
@@ -68,7 +68,7 @@ static int __init vdma_init(void)
 	 * aligned and should be uncached to avoid cache flushing after every
 	 * update.
 	 */
-	pgtbl = (VDMA_PGTBL_ENTRY *)__get_free_pages(GFP_KERNEL | GFP_DMA,
+	pgtbl = __get_free_pages(GFP_KERNEL | GFP_DMA,
 						    get_order(VDMA_PGTBL_SIZE));
 	BUG_ON(!pgtbl);
 	dma_cache_wback_inv((unsigned long)pgtbl, VDMA_PGTBL_SIZE);
diff --git a/arch/mips/kernel/irq.c b/arch/mips/kernel/irq.c
index 5e11582fe308..5bf2ac053d67 100644
--- a/arch/mips/kernel/irq.c
+++ b/arch/mips/kernel/irq.c
@@ -64,7 +64,7 @@ void __init init_IRQ(void)
 	arch_init_irq();
 
 	for_each_possible_cpu(i) {
-		void *s = (void *)__get_free_pages(GFP_KERNEL, order);
+		void *s = __get_free_pages(GFP_KERNEL, order);
 
 		irq_stack[i] = s;
 		pr_debug("CPU%d IRQ stack at 0x%p - 0x%p\n", i,
diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
index d2c3b6b41f18..d9a8d0da1d40 100644
--- a/arch/mips/kvm/mmu.c
+++ b/arch/mips/kvm/mmu.c
@@ -80,7 +80,7 @@ pgd_t *kvm_pgd_alloc(void)
 {
 	pgd_t *ret;
 
-	ret = (pgd_t *)__get_free_pages(GFP_KERNEL, PGD_TABLE_ORDER);
+	ret = __get_free_pages(GFP_KERNEL, PGD_TABLE_ORDER);
 	if (ret)
 		kvm_pgd_init(ret);
 
diff --git a/arch/nios2/mm/init.c b/arch/nios2/mm/init.c
index 94efa3de3933..97ff9ac27f60 100644
--- a/arch/nios2/mm/init.c
+++ b/arch/nios2/mm/init.c
@@ -79,7 +79,7 @@ static int alloc_kuser_page(void)
 	int kuser_sz = __kuser_helper_end - __kuser_helper_start;
 	unsigned long vpage;
 
-	vpage = get_zeroed_page(GFP_ATOMIC);
+	vpage = (unsigned long)get_zeroed_page(GFP_ATOMIC);
 	if (!vpage)
 		return -ENOMEM;
 
diff --git a/arch/parisc/kernel/pci-dma.c b/arch/parisc/kernel/pci-dma.c
index bf9f192c826e..8f7e777b9ce2 100644
--- a/arch/parisc/kernel/pci-dma.c
+++ b/arch/parisc/kernel/pci-dma.c
@@ -378,7 +378,7 @@ pcxl_dma_init(void)
 
 	pcxl_res_size = PCXL_DMA_MAP_SIZE >> (PAGE_SHIFT + 3);
 	pcxl_res_hint = 0;
-	pcxl_res_map = (char *)__get_free_pages(GFP_KERNEL,
+	pcxl_res_map = __get_free_pages(GFP_KERNEL,
 					    get_order(pcxl_res_size));
 	memset(pcxl_res_map, 0, pcxl_res_size);
 	proc_gsc_root = proc_mkdir("bus/gsc", NULL);
@@ -411,7 +411,7 @@ void *arch_dma_alloc(struct device *dev, size_t size,
 	order = get_order(size);
 	size = 1 << (order + PAGE_SHIFT);
 	vaddr = pcxl_alloc_range(size);
-	paddr = __get_free_pages(gfp | __GFP_ZERO, order);
+	paddr = (unsigned long)__get_free_pages(gfp | __GFP_ZERO, order);
 	flush_kernel_dcache_range(paddr, size);
 	paddr = __pa(paddr);
 	map_uncached_pages(vaddr, size, paddr);
diff --git a/arch/powerpc/include/asm/book3s/64/pgalloc.h b/arch/powerpc/include/asm/book3s/64/pgalloc.h
index dd2cff53a111..94ed0c4bdbe2 100644
--- a/arch/powerpc/include/asm/book3s/64/pgalloc.h
+++ b/arch/powerpc/include/asm/book3s/64/pgalloc.h
@@ -25,7 +25,7 @@ void pte_frag_destroy(void *pte_frag);
 static inline pgd_t *radix__pgd_alloc(struct mm_struct *mm)
 {
 #ifdef CONFIG_PPC_64K_PAGES
-	return (pgd_t *)__get_free_page(pgtable_gfp_flags(mm, PGALLOC_GFP));
+	return __get_free_page(pgtable_gfp_flags(mm, PGALLOC_GFP));
 #else
 	struct page *page;
 	page = alloc_pages(pgtable_gfp_flags(mm, PGALLOC_GFP | __GFP_RETRY_MAYFAIL),
diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index f305395cf26e..a3189a88a1e5 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -88,8 +88,8 @@ int kvmppc_allocate_hpt(struct kvm_hpt_info *info, u32 order)
 	}
 
 	if (!hpt)
-		hpt = __get_free_pages(GFP_KERNEL|__GFP_ZERO|__GFP_RETRY_MAYFAIL
-				       |__GFP_NOWARN, order - PAGE_SHIFT);
+		hpt = (unsigned long)__get_free_pages(GFP_KERNEL | __GFP_ZERO | __GFP_RETRY_MAYFAIL | __GFP_NOWARN,
+						      order - PAGE_SHIFT);
 
 	if (!hpt)
 		return -ENOMEM;
diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index 83bcdc80ce51..2106679a6e55 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -1744,7 +1744,7 @@ static int kvmppc_core_vcpu_create_pr(struct kvm_vcpu *vcpu)
 		goto free_vcpu3s;
 #endif
 
-	p = __get_free_page(GFP_KERNEL|__GFP_ZERO);
+	p = (unsigned long)__get_free_page(GFP_KERNEL | __GFP_ZERO);
 	if (!p)
 		goto free_shadow_vcpu;
 	vcpu->arch.shared = (void *)p;
diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xive.c
index 1302b5ac5672..63fe0995a922 100644
--- a/arch/powerpc/kvm/book3s_xive.c
+++ b/arch/powerpc/kvm/book3s_xive.c
@@ -945,7 +945,7 @@ static int xive_provision_queue(struct kvm_vcpu *vcpu, u8 prio)
 		return 0;
 
 	/* Allocate the queue and retrieve infos on current node for now */
-	qpage = (__be32 *)__get_free_pages(GFP_KERNEL, xive->q_page_order);
+	qpage = __get_free_pages(GFP_KERNEL, xive->q_page_order);
 	if (!qpage) {
 		pr_err("Failed to allocate queue %d for VCPU %d\n",
 		       prio, xc->server_num);
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index 3401b96be475..5b9fafd28fe9 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -2193,8 +2193,8 @@ int __init kvmppc_booke_init(void)
 
 	/* We install our own exception handlers by hijacking IVPR. IVPR must
 	 * be 16-bit aligned, so we need a 64KB allocation. */
-	kvmppc_booke_handlers = __get_free_pages(GFP_KERNEL | __GFP_ZERO,
-	                                         VCPU_SIZE_ORDER);
+	kvmppc_booke_handlers = (unsigned long)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
+								VCPU_SIZE_ORDER);
 	if (!kvmppc_booke_handlers)
 		return -ENOMEM;
 
diff --git a/arch/powerpc/kvm/e500.c b/arch/powerpc/kvm/e500.c
index b0f695428733..b1d79d446eea 100644
--- a/arch/powerpc/kvm/e500.c
+++ b/arch/powerpc/kvm/e500.c
@@ -448,7 +448,7 @@ static int kvmppc_core_vcpu_create_e500(struct kvm_vcpu *vcpu)
 	if (err)
 		goto uninit_id;
 
-	vcpu->arch.shared = (void*)__get_free_page(GFP_KERNEL|__GFP_ZERO);
+	vcpu->arch.shared = __get_free_page(GFP_KERNEL|__GFP_ZERO);
 	if (!vcpu->arch.shared) {
 		err = -ENOMEM;
 		goto uninit_tlb;
diff --git a/arch/powerpc/kvm/e500mc.c b/arch/powerpc/kvm/e500mc.c
index e476e107a932..1e1c0013b498 100644
--- a/arch/powerpc/kvm/e500mc.c
+++ b/arch/powerpc/kvm/e500mc.c
@@ -321,7 +321,7 @@ static int kvmppc_core_vcpu_create_e500mc(struct kvm_vcpu *vcpu)
 	if (err)
 		return err;
 
-	vcpu->arch.shared = (void *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
+	vcpu->arch.shared = __get_free_page(GFP_KERNEL | __GFP_ZERO);
 	if (!vcpu->arch.shared) {
 		err = -ENOMEM;
 		goto uninit_tlb;
diff --git a/arch/powerpc/mm/book3s64/subpage_prot.c b/arch/powerpc/mm/book3s64/subpage_prot.c
index ec98e526167e..237ae658d19c 100644
--- a/arch/powerpc/mm/book3s64/subpage_prot.c
+++ b/arch/powerpc/mm/book3s64/subpage_prot.c
@@ -238,7 +238,7 @@ SYSCALL_DEFINE3(subpage_prot, unsigned long, addr,
 		} else {
 			spm = spt->protptrs[addr >> SBP_L3_SHIFT];
 			if (!spm) {
-				spm = (u32 **)get_zeroed_page(GFP_KERNEL);
+				spm = get_zeroed_page(GFP_KERNEL);
 				if (!spm)
 					goto out;
 				spt->protptrs[addr >> SBP_L3_SHIFT] = spm;
@@ -247,7 +247,7 @@ SYSCALL_DEFINE3(subpage_prot, unsigned long, addr,
 		spm += (addr >> SBP_L2_SHIFT) & (SBP_L2_COUNT - 1);
 		spp = *spm;
 		if (!spp) {
-			spp = (u32 *)get_zeroed_page(GFP_KERNEL);
+			spp = get_zeroed_page(GFP_KERNEL);
 			if (!spp)
 				goto out;
 			*spm = spp;
diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
index 7ec60290abe6..f6f134ac2a06 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -678,7 +678,7 @@ spufs_init_isolated_loader(void)
 		return;
 
 	/* the loader must be align on a 16 byte boundary */
-	isolated_loader = (char *)__get_free_pages(GFP_KERNEL, get_order(size));
+	isolated_loader = __get_free_pages(GFP_KERNEL, get_order(size));
 	if (!isolated_loader)
 		return;
 
diff --git a/arch/powerpc/platforms/ps3/system-bus.c b/arch/powerpc/platforms/ps3/system-bus.c
index afbaabf182d0..9a55cc51460c 100644
--- a/arch/powerpc/platforms/ps3/system-bus.c
+++ b/arch/powerpc/platforms/ps3/system-bus.c
@@ -513,7 +513,7 @@ static void * ps3_alloc_coherent(struct device *_dev, size_t size,
 	flag &= ~(__GFP_DMA | __GFP_HIGHMEM);
 	flag |= __GFP_ZERO;
 
-	virt_addr = __get_free_pages(flag, get_order(size));
+	virt_addr = (unsigned long)__get_free_pages(flag, get_order(size));
 
 	if (!virt_addr) {
 		pr_debug("%s:%d: get_free_pages failed\n", __func__, __LINE__);
diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index eec333dd2e59..e528020d8824 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -276,7 +276,7 @@ static int tce_buildmulti_pSeriesLP(struct iommu_table *tbl, long tcenum,
 	 * from iommu_alloc{,_sg}()
 	 */
 	if (!tcep) {
-		tcep = (__be64 *)__get_free_page(GFP_ATOMIC);
+		tcep = __get_free_page(GFP_ATOMIC);
 		/* If allocation fails, fall back to the loop implementation */
 		if (!tcep) {
 			local_irq_restore(flags);
@@ -502,7 +502,7 @@ static int tce_setrange_multi_pSeriesLP(unsigned long start_pfn,
 	tcep = __this_cpu_read(tce_page);
 
 	if (!tcep) {
-		tcep = (__be64 *)__get_free_page(GFP_ATOMIC);
+		tcep = __get_free_page(GFP_ATOMIC);
 		if (!tcep) {
 			local_irq_enable();
 			return -ENOMEM;
diff --git a/arch/powerpc/platforms/pseries/pseries_energy.c b/arch/powerpc/platforms/pseries/pseries_energy.c
index 2c661b798235..b628dc9991eb 100644
--- a/arch/powerpc/platforms/pseries/pseries_energy.c
+++ b/arch/powerpc/platforms/pseries/pseries_energy.c
@@ -193,7 +193,7 @@ static ssize_t get_best_energy_list(char *page, int activate)
 	u32 *buf_page;
 	char *s = page;
 
-	buf_page = (u32 *) get_zeroed_page(GFP_KERNEL);
+	buf_page = get_zeroed_page(GFP_KERNEL);
 	if (!buf_page)
 		return -ENOMEM;
 
diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 5d36f4020dfa..fe3c9d0aa60b 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -1125,7 +1125,7 @@ static int __init aes_s390_init(void)
 	if (cpacf_test_func(&kmctr_functions, CPACF_KMCTR_AES_128) ||
 	    cpacf_test_func(&kmctr_functions, CPACF_KMCTR_AES_192) ||
 	    cpacf_test_func(&kmctr_functions, CPACF_KMCTR_AES_256)) {
-		ctrblk = (u8 *) __get_free_page(GFP_KERNEL);
+		ctrblk = __get_free_page(GFP_KERNEL);
 		if (!ctrblk) {
 			ret = -ENOMEM;
 			goto out_err;
diff --git a/arch/s390/crypto/des_s390.c b/arch/s390/crypto/des_s390.c
index 8e75b83a5ddc..78e7b6ff22da 100644
--- a/arch/s390/crypto/des_s390.c
+++ b/arch/s390/crypto/des_s390.c
@@ -468,7 +468,7 @@ static int __init des_s390_init(void)
 
 	if (cpacf_test_func(&kmctr_functions, CPACF_KMCTR_DEA) ||
 	    cpacf_test_func(&kmctr_functions, CPACF_KMCTR_TDEA_192)) {
-		ctrblk = (u8 *) __get_free_page(GFP_KERNEL);
+		ctrblk = __get_free_page(GFP_KERNEL);
 		if (!ctrblk) {
 			ret = -ENOMEM;
 			goto out_err;
diff --git a/arch/s390/crypto/paes_s390.c b/arch/s390/crypto/paes_s390.c
index a624a43a2b54..c1a9d4e515c6 100644
--- a/arch/s390/crypto/paes_s390.c
+++ b/arch/s390/crypto/paes_s390.c
@@ -1679,7 +1679,7 @@ static int __init paes_s390_init(void)
 	if (cpacf_test_func(&kmctr_functions, CPACF_KMCTR_PAES_128) ||
 	    cpacf_test_func(&kmctr_functions, CPACF_KMCTR_PAES_192) ||
 	    cpacf_test_func(&kmctr_functions, CPACF_KMCTR_PAES_256)) {
-		ctrblk = (u8 *)__get_free_page(GFP_KERNEL);
+		ctrblk = __get_free_page(GFP_KERNEL);
 		if (!ctrblk) {
 			rc = -ENOMEM;
 			goto out_err;
diff --git a/arch/s390/crypto/prng.c b/arch/s390/crypto/prng.c
index 2becd77df741..143ec756f609 100644
--- a/arch/s390/crypto/prng.c
+++ b/arch/s390/crypto/prng.c
@@ -150,7 +150,7 @@ static int generate_entropy(u8 *ebuf, size_t nbytes)
 		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x00 };
 
 	/* allocate one page stckf buffer */
-	pg = (u8 *) __get_free_page(GFP_KERNEL);
+	pg = __get_free_page(GFP_KERNEL);
 	if (!pg) {
 		prng_errorflag = PRNG_GEN_ENTROPY_FAILED;
 		return -ENOMEM;
diff --git a/arch/s390/hypfs/hypfs_diag_fs.c b/arch/s390/hypfs/hypfs_diag_fs.c
index ede951dc0085..dbd6752bfa84 100644
--- a/arch/s390/hypfs/hypfs_diag_fs.c
+++ b/arch/s390/hypfs/hypfs_diag_fs.c
@@ -367,7 +367,7 @@ static int diag224_idx2name(int index, char *name)
 static int diag224_get_name_table(void)
 {
 	/* memory must be below 2GB */
-	diag224_cpu_names = (char *)__get_free_page(GFP_KERNEL | GFP_DMA);
+	diag224_cpu_names = __get_free_page(GFP_KERNEL | GFP_DMA);
 	if (!diag224_cpu_names)
 		return -ENOMEM;
 	if (diag224(diag224_cpu_names)) {
diff --git a/arch/s390/hypfs/hypfs_sprp.c b/arch/s390/hypfs/hypfs_sprp.c
index a2952ed5518b..82eba1438656 100644
--- a/arch/s390/hypfs/hypfs_sprp.c
+++ b/arch/s390/hypfs/hypfs_sprp.c
@@ -50,7 +50,7 @@ static int hypfs_sprp_create(void **data_ptr, void **free_ptr, size_t *size)
 	unsigned long rc;
 	void *data;
 
-	data = (void *) get_zeroed_page(GFP_KERNEL);
+	data = get_zeroed_page(GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 	rc = hypfs_sprp_diag304(data, DIAG304_QUERY_PRP);
@@ -74,7 +74,7 @@ static int __hypfs_sprp_ioctl(void __user *user_area)
 	int rc;
 
 	rc = -ENOMEM;
-	data = (void *)get_zeroed_page(GFP_KERNEL);
+	data = get_zeroed_page(GFP_KERNEL);
 	diag304 = kzalloc(sizeof(*diag304), GFP_KERNEL);
 	if (!data || !diag304)
 		goto out;
diff --git a/arch/s390/include/asm/idals.h b/arch/s390/include/asm/idals.h
index ac68c657b28c..a09fdcaf2a5f 100644
--- a/arch/s390/include/asm/idals.h
+++ b/arch/s390/include/asm/idals.h
@@ -147,7 +147,7 @@ static inline struct idal_buffer *idal_buffer_alloc(size_t size, int page_order)
 			ib->data[i] = dma64_add(ib->data[i - 1], IDA_BLOCK_SIZE);
 			continue;
 		}
-		vaddr = (void *)__get_free_pages(GFP_KERNEL, page_order);
+		vaddr = __get_free_pages(GFP_KERNEL, page_order);
 		if (!vaddr)
 			goto error;
 		ib->data[i] = virt_to_dma64(vaddr);
diff --git a/arch/s390/kernel/ipl.c b/arch/s390/kernel/ipl.c
index 961a3d60a4dd..0549fbdacc37 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -1290,7 +1290,7 @@ static int __init reipl_nss_init(void)
 	if (!machine_is_vm())
 		return 0;
 
-	reipl_block_nss = (void *) get_zeroed_page(GFP_KERNEL);
+	reipl_block_nss = get_zeroed_page(GFP_KERNEL);
 	if (!reipl_block_nss)
 		return -ENOMEM;
 
@@ -1332,7 +1332,7 @@ static int __init reipl_fcp_init(void)
 {
 	int rc;
 
-	reipl_block_fcp = (void *) get_zeroed_page(GFP_KERNEL);
+	reipl_block_fcp = get_zeroed_page(GFP_KERNEL);
 	if (!reipl_block_fcp)
 		return -ENOMEM;
 
@@ -1388,7 +1388,7 @@ static int __init reipl_nvme_init(void)
 {
 	int rc;
 
-	reipl_block_nvme = (void *) get_zeroed_page(GFP_KERNEL);
+	reipl_block_nvme = get_zeroed_page(GFP_KERNEL);
 	if (!reipl_block_nvme)
 		return -ENOMEM;
 
@@ -1447,7 +1447,7 @@ static int __init reipl_eckd_init(void)
 	if (!sclp.has_sipl_eckd)
 		return 0;
 
-	reipl_block_eckd = (void *)get_zeroed_page(GFP_KERNEL);
+	reipl_block_eckd = get_zeroed_page(GFP_KERNEL);
 	if (!reipl_block_eckd)
 		return -ENOMEM;
 
@@ -1780,7 +1780,7 @@ static int __init dump_ccw_init(void)
 {
 	int rc;
 
-	dump_block_ccw = (void *) get_zeroed_page(GFP_KERNEL);
+	dump_block_ccw = get_zeroed_page(GFP_KERNEL);
 	if (!dump_block_ccw)
 		return -ENOMEM;
 	rc = sysfs_create_group(&dump_kset->kobj, &dump_ccw_attr_group);
@@ -1802,7 +1802,7 @@ static int __init dump_fcp_init(void)
 
 	if (!sclp_ipl_info.has_dump)
 		return 0; /* LDIPL DUMP is not installed */
-	dump_block_fcp = (void *) get_zeroed_page(GFP_KERNEL);
+	dump_block_fcp = get_zeroed_page(GFP_KERNEL);
 	if (!dump_block_fcp)
 		return -ENOMEM;
 	rc = sysfs_create_group(&dump_kset->kobj, &dump_fcp_attr_group);
@@ -1825,7 +1825,7 @@ static int __init dump_nvme_init(void)
 
 	if (!sclp_ipl_info.has_dump)
 		return 0; /* LDIPL DUMP is not installed */
-	dump_block_nvme = (void *) get_zeroed_page(GFP_KERNEL);
+	dump_block_nvme = get_zeroed_page(GFP_KERNEL);
 	if (!dump_block_nvme)
 		return -ENOMEM;
 	rc = sysfs_create_group(&dump_kset->kobj, &dump_nvme_attr_group);
@@ -1848,7 +1848,7 @@ static int __init dump_eckd_init(void)
 
 	if (!sclp_ipl_info.has_dump || !sclp.has_sipl_eckd)
 		return 0; /* LDIPL DUMP is not installed */
-	dump_block_eckd = (void *)get_zeroed_page(GFP_KERNEL);
+	dump_block_eckd = get_zeroed_page(GFP_KERNEL);
 	if (!dump_block_eckd)
 		return -ENOMEM;
 	rc = sysfs_create_group(&dump_kset->kobj, &dump_eckd_attr_group);
diff --git a/arch/s390/kernel/perf_cpum_sf.c b/arch/s390/kernel/perf_cpum_sf.c
index f432869f8921..7d8ad44a571d 100644
--- a/arch/s390/kernel/perf_cpum_sf.c
+++ b/arch/s390/kernel/perf_cpum_sf.c
@@ -209,7 +209,7 @@ static int alloc_sample_data_block(unsigned long *sdbt, gfp_t gfp_flags)
 	unsigned long sdb;
 
 	/* Allocate and initialize sample-data-block */
-	sdb = get_zeroed_page(gfp_flags);
+	sdb = (unsigned long)get_zeroed_page(gfp_flags);
 	if (!sdb)
 		return -ENOMEM;
 	te = trailer_entry_ptr(sdb);
@@ -266,7 +266,7 @@ static int realloc_sampling_buffer(struct sf_buffer *sfb,
 	for (i = 0; i < num_sdb; i++) {
 		/* Allocate a new SDB-table if it is full. */
 		if (require_table_link(tail)) {
-			new = (unsigned long *)get_zeroed_page(gfp_flags);
+			new = get_zeroed_page(gfp_flags);
 			if (!new) {
 				rc = -ENOMEM;
 				break;
@@ -328,7 +328,7 @@ static int alloc_sampling_buffer(struct sf_buffer *sfb, unsigned long num_sdb)
 		return -EINVAL;
 
 	/* Allocate the sample-data-block-table origin */
-	sfb->sdbt = (unsigned long *)get_zeroed_page(GFP_KERNEL);
+	sfb->sdbt = get_zeroed_page(GFP_KERNEL);
 	if (!sfb->sdbt)
 		return -ENOMEM;
 	sfb->num_sdb = 0;
@@ -1628,7 +1628,7 @@ static void *aux_buffer_setup(struct perf_event *event, void **pages,
 
 	/* Allocate the first SDBT */
 	sfb->num_sdbt = 0;
-	sfb->sdbt = (unsigned long *)get_zeroed_page(GFP_KERNEL);
+	sfb->sdbt = get_zeroed_page(GFP_KERNEL);
 	if (!sfb->sdbt)
 		goto no_sdbt;
 	aux->sdbt_index[sfb->num_sdbt++] = (unsigned long)sfb->sdbt;
@@ -1640,7 +1640,7 @@ static void *aux_buffer_setup(struct perf_event *event, void **pages,
 	 */
 	for (i = 0; i < nr_pages; i++, tail++) {
 		if (require_table_link(tail)) {
-			new = (unsigned long *)get_zeroed_page(GFP_KERNEL);
+			new = get_zeroed_page(GFP_KERNEL);
 			if (!new)
 				goto no_sdbt;
 			aux->sdbt_index[sfb->num_sdbt++] = (unsigned long)new;
diff --git a/arch/s390/kernel/perf_pai_crypto.c b/arch/s390/kernel/perf_pai_crypto.c
index 62bf8a15bf32..89907fa516a5 100644
--- a/arch/s390/kernel/perf_pai_crypto.c
+++ b/arch/s390/kernel/perf_pai_crypto.c
@@ -201,7 +201,7 @@ static int paicrypt_alloc_cpu(struct perf_event *event, int cpu)
 		 * Only the first counting event has to allocate a page.
 		 */
 		mp->mapptr = cpump;
-		cpump->page = (unsigned long *)get_zeroed_page(GFP_KERNEL);
+		cpump->page = get_zeroed_page(GFP_KERNEL);
 		cpump->save = kvmalloc_array(paicrypt_cnt + 1,
 					     sizeof(struct pai_userdata),
 					     GFP_KERNEL);
@@ -279,11 +279,13 @@ static int paicrypt_event_init(struct perf_event *event)
 		return -EINVAL;
 	/* Get a page to store last counter values for sampling */
 	if (a->sample_period) {
-		PAI_SAVE_AREA(event) = get_zeroed_page(GFP_KERNEL);
-		if (!PAI_SAVE_AREA(event)) {
+		void *save_area = get_zeroed_page(GFP_KERNEL);
+
+		if (!save_area) {
 			rc = -ENOMEM;
 			goto out;
 		}
+		PAI_SAVE_AREA(event) = (unsigned long)save_area;
 	}
 
 	if (event->cpu >= 0)
diff --git a/arch/s390/kernel/perf_pai_ext.c b/arch/s390/kernel/perf_pai_ext.c
index 7b32935273ce..ec3cb99aa659 100644
--- a/arch/s390/kernel/perf_pai_ext.c
+++ b/arch/s390/kernel/perf_pai_ext.c
@@ -289,9 +289,11 @@ static int paiext_event_init(struct perf_event *event)
 		return -EINVAL;
 	/* Get a page to store last counter values for sampling */
 	if (a->sample_period) {
-		PAI_SAVE_AREA(event) = get_zeroed_page(GFP_KERNEL);
-		if (!PAI_SAVE_AREA(event))
+		void *save_area = get_zeroed_page(GFP_KERNEL);
+
+		if (!save_area)
 			return -ENOMEM;
+		PAI_SAVE_AREA(event) = (unsigned long)save_area;
 	}
 
 	if (event->cpu >= 0)
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index da84c0dc6b7e..0bc4d836f794 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -186,8 +186,9 @@ static int pcpu_alloc_lowcore(struct pcpu *pcpu, int cpu)
 	unsigned long async_stack, nodat_stack, mcck_stack;
 	struct lowcore *lc;
 
-	lc = (struct lowcore *) __get_free_pages(GFP_KERNEL | GFP_DMA, LC_ORDER);
-	nodat_stack = __get_free_pages(GFP_KERNEL, THREAD_SIZE_ORDER);
+	lc = __get_free_pages(GFP_KERNEL | GFP_DMA, LC_ORDER);
+	nodat_stack = (unsigned long)__get_free_pages(GFP_KERNEL,
+						      THREAD_SIZE_ORDER);
 	async_stack = stack_alloc();
 	mcck_stack = stack_alloc();
 	if (!lc || !nodat_stack || !async_stack || !mcck_stack)
diff --git a/arch/s390/kernel/sthyi.c b/arch/s390/kernel/sthyi.c
index f4ccdbed4b89..d6140ad14a42 100644
--- a/arch/s390/kernel/sthyi.c
+++ b/arch/s390/kernel/sthyi.c
@@ -218,7 +218,7 @@ static void fill_stsi(struct sthyi_sctns *sctns)
 	void *sysinfo;
 
 	/* Errors are handled through the validity bits in the response. */
-	sysinfo = (void *)__get_free_page(GFP_KERNEL);
+	sysinfo = __get_free_page(GFP_KERNEL);
 	if (!sysinfo)
 		return;
 
@@ -354,7 +354,7 @@ static void fill_diag(struct sthyi_sctns *sctns, void *diag204_buf)
 	struct diag204_x_phys_block *phys_block;
 	struct lpar_cpu_inf lpar_inf = {};
 
-	diag224_buf = (void *)__get_free_page(GFP_KERNEL | GFP_DMA);
+	diag224_buf = __get_free_page(GFP_KERNEL | GFP_DMA);
 	if (!diag224_buf || diag224(diag224_buf))
 		goto out;
 
@@ -470,7 +470,7 @@ static int sthyi_init_cache(void)
 {
 	if (sthyi_cache.info)
 		return 0;
-	sthyi_cache.info = (void *)get_zeroed_page(GFP_KERNEL);
+	sthyi_cache.info = get_zeroed_page(GFP_KERNEL);
 	if (!sthyi_cache.info)
 		return -ENOMEM;
 	sthyi_cache.end = jiffies - 1; /* expired */
@@ -538,7 +538,7 @@ SYSCALL_DEFINE4(s390_sthyi, unsigned long, function_code, void __user *, buffer,
 		return -EINVAL;
 	if (function_code != STHYI_FC_CP_IFL_CAP)
 		return -EOPNOTSUPP;
-	info = (void *)get_zeroed_page(GFP_KERNEL);
+	info = get_zeroed_page(GFP_KERNEL);
 	if (!info)
 		return -ENOMEM;
 	r = sthyi_fill(info, &sthyi_rc);
diff --git a/arch/s390/kernel/sysinfo.c b/arch/s390/kernel/sysinfo.c
index 1ea84e942bd4..01b2ef34a1d1 100644
--- a/arch/s390/kernel/sysinfo.c
+++ b/arch/s390/kernel/sysinfo.c
@@ -254,7 +254,7 @@ static void stsi_3_2_2(struct seq_file *m, struct sysinfo_3_2_2 *info)
 
 static int sysinfo_show(struct seq_file *m, void *v)
 {
-	void *info = (void *)get_zeroed_page(GFP_KERNEL);
+	void *info = get_zeroed_page(GFP_KERNEL);
 	int level;
 
 	if (!info)
@@ -394,7 +394,7 @@ void s390_adjust_jiffies(void)
 	struct sysinfo_1_2_2 *info;
 	unsigned long capability;
 
-	info = (void *) get_zeroed_page(GFP_KERNEL);
+	info = get_zeroed_page(GFP_KERNEL);
 	if (!info)
 		return;
 
diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index 63517b85f4c9..5640e94a04c1 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -418,7 +418,7 @@ static void __init stp_reset(void)
 {
 	int rc;
 
-	stp_page = (void *) get_zeroed_page(GFP_ATOMIC);
+	stp_page = get_zeroed_page(GFP_ATOMIC);
 	rc = chsc_sstpc(stp_page, STP_OP_CTRL, 0x0000, NULL);
 	if (rc == 0)
 		set_bit(CLOCK_SYNC_HAS_STP, &clock_sync_flags);
diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index c7908950c1f4..d5da89b9e05b 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -431,7 +431,7 @@ int handle_sthyi(struct kvm_vcpu *vcpu)
 	if (!kvm_s390_pv_cpu_is_protected(vcpu) && (addr & ~PAGE_MASK))
 		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
 
-	sctns = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
+	sctns = get_zeroed_page(GFP_KERNEL_ACCOUNT);
 	if (!sctns)
 		return -ENOMEM;
 
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index c62a868cf2b6..23ccf27395d1 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -3440,7 +3440,7 @@ int __init kvm_s390_gib_init(u8 nisc)
 		goto out;
 	}
 
-	gib = (struct kvm_s390_gib *)get_zeroed_page(GFP_KERNEL_ACCOUNT | GFP_DMA);
+	gib = get_zeroed_page(GFP_KERNEL_ACCOUNT | GFP_DMA);
 	if (!gib) {
 		rc = -ENOMEM;
 		goto out;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 16ba04062854..8bacea966156 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3360,7 +3360,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 		alloc_flags |= GFP_DMA;
 	rwlock_init(&kvm->arch.sca_lock);
 	/* start with basic SCA */
-	kvm->arch.sca = (struct bsca_block *) get_zeroed_page(alloc_flags);
+	kvm->arch.sca = get_zeroed_page(alloc_flags);
 	if (!kvm->arch.sca)
 		goto out_err;
 	mutex_lock(&kvm_lock);
@@ -3379,7 +3379,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	BUILD_BUG_ON(sizeof(struct sie_page2) != 4096);
 	kvm->arch.sie_page2 =
-	     (struct sie_page2 *) get_zeroed_page(GFP_KERNEL_ACCOUNT | GFP_DMA);
+	     get_zeroed_page(GFP_KERNEL_ACCOUNT | GFP_DMA);
 	if (!kvm->arch.sie_page2)
 		goto out_err;
 
@@ -3863,7 +3863,7 @@ void kvm_s390_vcpu_unsetup_cmma(struct kvm_vcpu *vcpu)
 
 int kvm_s390_vcpu_setup_cmma(struct kvm_vcpu *vcpu)
 {
-	void *cbrlo_page = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
+	void *cbrlo_page = get_zeroed_page(GFP_KERNEL_ACCOUNT);
 
 	if (!cbrlo_page)
 		return -ENOMEM;
@@ -3981,7 +3981,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	int rc;
 
 	BUILD_BUG_ON(sizeof(struct sie_page) != 4096);
-	sie_page = (struct sie_page *) get_zeroed_page(GFP_KERNEL_ACCOUNT);
+	sie_page = get_zeroed_page(GFP_KERNEL_ACCOUNT);
 	if (!sie_page)
 		return -ENOMEM;
 
diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index 9a71b6e00948..c031f7b628a9 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -945,7 +945,7 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
 	switch (fc) {
 	case 1: /* same handling for 1 and 2 */
 	case 2:
-		mem = get_zeroed_page(GFP_KERNEL_ACCOUNT);
+		mem = (unsigned long)get_zeroed_page(GFP_KERNEL_ACCOUNT);
 		if (!mem)
 			goto out_no_data;
 		if (stsi((void *) mem, fc, sel1, sel2))
@@ -954,7 +954,7 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
 	case 3:
 		if (sel1 != 2 || sel2 != 2)
 			goto out_no_data;
-		mem = get_zeroed_page(GFP_KERNEL_ACCOUNT);
+		mem = (unsigned long)get_zeroed_page(GFP_KERNEL_ACCOUNT);
 		if (!mem)
 			goto out_no_data;
 		handle_stsi_3_2_2(vcpu, (void *) mem);
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 6ba5a0305e25..e8050eca6cb4 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -163,16 +163,18 @@ int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
 		.header.cmd = UVC_CMD_CREATE_SEC_CPU,
 		.header.len = sizeof(uvcb),
 	};
+	void *stor_base;
 	void *sida_addr;
 	int cc;
 
 	if (kvm_s390_pv_cpu_get_handle(vcpu))
 		return -EINVAL;
 
-	vcpu->arch.pv.stor_base = __get_free_pages(GFP_KERNEL_ACCOUNT,
-						   get_order(uv_info.guest_cpu_stor_len));
-	if (!vcpu->arch.pv.stor_base)
+	stor_base = __get_free_pages(GFP_KERNEL_ACCOUNT,
+				     get_order(uv_info.guest_cpu_stor_len));
+	if (!stor_base)
 		return -ENOMEM;
+	vcpu->arch.pv.stor_base = (unsigned long)stor_base;
 
 	/* Input */
 	uvcb.guest_handle = kvm_s390_pv_get_handle(vcpu->kvm);
@@ -181,7 +183,7 @@ int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
 	uvcb.stor_origin = virt_to_phys((void *)vcpu->arch.pv.stor_base);
 
 	/* Alloc Secure Instruction Data Area Designation */
-	sida_addr = (void *)__get_free_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	sida_addr = __get_free_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 	if (!sida_addr) {
 		free_pages(vcpu->arch.pv.stor_base,
 			   get_order(uv_info.guest_cpu_stor_len));
@@ -227,12 +229,13 @@ static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
 	unsigned long base = uv_info.guest_base_stor_len;
 	unsigned long virt = uv_info.guest_virt_var_stor_len;
 	unsigned long npages = 0, vlen = 0;
+	void *stor_base;
 
 	kvm->arch.pv.stor_var = NULL;
-	kvm->arch.pv.stor_base = __get_free_pages(GFP_KERNEL_ACCOUNT, get_order(base));
-	if (!kvm->arch.pv.stor_base)
+	stor_base = __get_free_pages(GFP_KERNEL_ACCOUNT, get_order(base));
+	if (!stor_base)
 		return -ENOMEM;
-
+	kvm->arch.pv.stor_base = (unsigned long)stor_base;
 	/*
 	 * Calculate current guest storage for allocation of the
 	 * variable storage, which is based on the length in MB.
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 347268f89f2f..3961ea83aea5 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -1423,7 +1423,7 @@ static struct vsie_page *get_vsie_page(struct kvm *kvm, unsigned long addr)
 
 	mutex_lock(&kvm->arch.vsie.mutex);
 	if (kvm->arch.vsie.page_count < nr_vcpus) {
-		vsie_page = (void *)__get_free_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO | GFP_DMA);
+		vsie_page = __get_free_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO | GFP_DMA);
 		if (!vsie_page) {
 			mutex_unlock(&kvm->arch.vsie.mutex);
 			return ERR_PTR(-ENOMEM);
diff --git a/arch/s390/mm/cmm.c b/arch/s390/mm/cmm.c
index e2a6eb92420f..7212ab4f0eaa 100644
--- a/arch/s390/mm/cmm.c
+++ b/arch/s390/mm/cmm.c
@@ -66,7 +66,7 @@ static long cmm_alloc_pages(long nr, long *counter,
 	unsigned long addr;
 
 	while (nr) {
-		addr = __get_free_page(GFP_NOIO);
+		addr = (unsigned long)__get_free_page(GFP_NOIO);
 		if (!addr)
 			break;
 		spin_lock(&cmm_lock);
@@ -74,7 +74,7 @@ static long cmm_alloc_pages(long nr, long *counter,
 		if (!pa || pa->index >= CMM_NR_PAGES) {
 			/* Need a new page for the page list. */
 			spin_unlock(&cmm_lock);
-			npa = (struct cmm_page_array *)
+			npa =
 				__get_free_page(GFP_NOIO);
 			if (!npa) {
 				free_page(addr);
diff --git a/arch/s390/mm/maccess.c b/arch/s390/mm/maccess.c
index cfd219fe495c..4aa41186615d 100644
--- a/arch/s390/mm/maccess.c
+++ b/arch/s390/mm/maccess.c
@@ -163,7 +163,7 @@ void *xlate_dev_mem_ptr(phys_addr_t addr)
 		if (cpu < 0)
 			goto out;
 	}
-	bounce = (void *)__get_free_page(GFP_ATOMIC);
+	bounce = __get_free_page(GFP_ATOMIC);
 	if (!bounce)
 		goto out;
 	size = PAGE_SIZE - (addr & ~PAGE_MASK);
diff --git a/arch/s390/mm/vmem.c b/arch/s390/mm/vmem.c
index f48ef361bc83..05eaabb0402f 100644
--- a/arch/s390/mm/vmem.c
+++ b/arch/s390/mm/vmem.c
@@ -33,7 +33,7 @@ static void __ref *vmem_alloc_pages(unsigned int order)
 	unsigned long size = PAGE_SIZE << order;
 
 	if (slab_is_available())
-		return (void *)__get_free_pages(GFP_KERNEL, order);
+		return __get_free_pages(GFP_KERNEL, order);
 	return memblock_alloc(size, size);
 }
 
diff --git a/arch/s390/pci/pci_clp.c b/arch/s390/pci/pci_clp.c
index 241f7251c873..d56914baa06d 100644
--- a/arch/s390/pci/pci_clp.c
+++ b/arch/s390/pci/pci_clp.c
@@ -93,7 +93,7 @@ static __always_inline int clp_req(void *data, unsigned int lps)
 
 static void *clp_alloc_block(gfp_t gfp_mask)
 {
-	return (void *) __get_free_pages(gfp_mask, get_order(CLP_BLK_SIZE));
+	return __get_free_pages(gfp_mask, get_order(CLP_BLK_SIZE));
 }
 
 static void clp_free_block(void *ptr)
diff --git a/arch/s390/pci/pci_report.c b/arch/s390/pci/pci_report.c
index 1b494e5ecc4d..ec261a9acb12 100644
--- a/arch/s390/pci/pci_report.c
+++ b/arch/s390/pci/pci_report.c
@@ -119,7 +119,7 @@ int zpci_report_status(struct zpci_dev *zdev, const char *operation, const char
 	if (prot_virt_guest)
 		return -ENODATA;
 
-	report = (void *)get_zeroed_page(GFP_KERNEL);
+	report = get_zeroed_page(GFP_KERNEL);
 	if (!report)
 		return -ENOMEM;
 	if (zdev->zbus->bus)
diff --git a/arch/sh/boards/mach-hp6xx/pm.c b/arch/sh/boards/mach-hp6xx/pm.c
index fe505ec168d0..0d048cf9ea3b 100644
--- a/arch/sh/boards/mach-hp6xx/pm.c
+++ b/arch/sh/boards/mach-hp6xx/pm.c
@@ -66,7 +66,7 @@ static void pm_enter(void)
 
 	/* set interrupt handler */
 	asm volatile("stc vbr, %0" : "=r" (vbr_old));
-	vbr_new = get_zeroed_page(GFP_ATOMIC);
+	vbr_new = (u32)get_zeroed_page(GFP_ATOMIC);
 	udelay(50);
 	memcpy((void*)(vbr_new + INTR_OFFSET),
 	       &wakeup_start, &wakeup_end - &wakeup_start);
diff --git a/arch/sh/kernel/vsyscall/vsyscall.c b/arch/sh/kernel/vsyscall/vsyscall.c
index 1563dcc55fd3..9d3ab48c1239 100644
--- a/arch/sh/kernel/vsyscall/vsyscall.c
+++ b/arch/sh/kernel/vsyscall/vsyscall.c
@@ -56,7 +56,7 @@ static struct vm_special_mapping vdso_mapping = {
 
 int __init vsyscall_init(void)
 {
-	void *syscall_page = (void *)get_zeroed_page(GFP_ATOMIC);
+	void *syscall_page = get_zeroed_page(GFP_ATOMIC);
 	syscall_pages[0] = virt_to_page(syscall_page);
 
 	/*
diff --git a/arch/sparc/kernel/irq_64.c b/arch/sparc/kernel/irq_64.c
index ded463c82abd..54cc23441105 100644
--- a/arch/sparc/kernel/irq_64.c
+++ b/arch/sparc/kernel/irq_64.c
@@ -1019,7 +1019,7 @@ static void __init alloc_one_queue(unsigned long *pa_ptr, unsigned long qmask)
 	unsigned long order = get_order(size);
 	unsigned long p;
 
-	p = __get_free_pages(GFP_KERNEL | __GFP_ZERO, order);
+	p = (unsigned long)__get_free_pages(GFP_KERNEL | __GFP_ZERO, order);
 	if (!p) {
 		prom_printf("SUN4V: Error, cannot allocate queue.\n");
 		prom_halt();
@@ -1045,7 +1045,7 @@ static void __init init_cpu_send_mondo_info(struct trap_per_cpu *tb)
 	mondo = (void *)(((unsigned long)p + 63) & ~0x3f);
 	tb->cpu_mondo_block_pa = __pa(mondo);
 
-	page = get_zeroed_page(GFP_KERNEL);
+	page = (unsigned long)get_zeroed_page(GFP_KERNEL);
 	if (!page) {
 		prom_printf("SUN4V: Error, cannot allocate cpu list page.\n");
 		prom_halt();
@@ -1102,7 +1102,7 @@ static void __init irq_ivector_init(void)
 	ivecs = size_nr_ivec();
 	size = sizeof(struct ino_bucket) * ivecs;
 	order = get_order(size);
-	ivector_table = (struct ino_bucket *)
+	ivector_table =
 		__get_free_pages(GFP_KERNEL | __GFP_ZERO, order);
 	if (!ivector_table) {
 		prom_printf("Fatal error, cannot allocate ivector_table\n");
diff --git a/arch/sparc/kernel/ldc.c b/arch/sparc/kernel/ldc.c
index 7f3cdb6f644d..c7fbb5b3e245 100644
--- a/arch/sparc/kernel/ldc.c
+++ b/arch/sparc/kernel/ldc.c
@@ -981,7 +981,7 @@ static int alloc_queue(const char *name, unsigned long num_entries,
 	size = num_entries * LDC_PACKET_SIZE;
 	order = get_order(size);
 
-	q = (void *) __get_free_pages(GFP_KERNEL, order);
+	q = __get_free_pages(GFP_KERNEL, order);
 	if (!q) {
 		printk(KERN_ERR PFX "Alloc of %s queue failed with "
 		       "size=%lu order=%lu\n", name, size, order);
@@ -1065,7 +1065,7 @@ static int ldc_iommu_init(const char *name, struct ldc_channel *lp)
 
 	order = get_order(tsbsize);
 
-	table = (struct ldc_mtable_entry *)
+	table =
 		__get_free_pages(GFP_KERNEL, order);
 	err = -ENOMEM;
 	if (!table) {
diff --git a/arch/sparc/kernel/pci_fire.c b/arch/sparc/kernel/pci_fire.c
index 0b91bde80fdc..2215d6c88ace 100644
--- a/arch/sparc/kernel/pci_fire.c
+++ b/arch/sparc/kernel/pci_fire.c
@@ -234,7 +234,8 @@ static int pci_fire_msiq_alloc(struct pci_pbm_info *pbm)
 	unsigned long pages, order, i;
 
 	order = get_order(512 * 1024);
-	pages = __get_free_pages(GFP_KERNEL | __GFP_COMP, order);
+	pages = (unsigned long)__get_free_pages(GFP_KERNEL | __GFP_COMP,
+						order);
 	if (pages == 0UL) {
 		printk(KERN_ERR "MSI: Cannot allocate MSI queues (o=%lu).\n",
 		       order);
diff --git a/arch/sparc/kernel/pci_sun4v.c b/arch/sparc/kernel/pci_sun4v.c
index b720b21ccfbd..0a6462db97f6 100644
--- a/arch/sparc/kernel/pci_sun4v.c
+++ b/arch/sparc/kernel/pci_sun4v.c
@@ -757,7 +757,7 @@ static int pci_sun4v_atu_alloc_iotsb(struct pci_pbm_info *pbm)
 	/* calculate size of IOTSB */
 	table_size = (atu->size / IO_PAGE_SIZE) * 8;
 	order = get_order(table_size);
-	table = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, order);
+	table = __get_free_pages(GFP_KERNEL | __GFP_ZERO, order);
 	if (!table) {
 		err = -ENOMEM;
 		goto table_failed;
@@ -1060,7 +1060,8 @@ static int pci_sun4v_msiq_alloc(struct pci_pbm_info *pbm)
 	q_size = pbm->msiq_ent_count * sizeof(struct pci_sun4v_msiq_entry);
 	alloc_size = (pbm->msiq_num * q_size);
 	order = get_order(alloc_size);
-	pages = __get_free_pages(GFP_KERNEL | __GFP_COMP, order);
+	pages = (unsigned long)__get_free_pages(GFP_KERNEL | __GFP_COMP,
+						order);
 	if (pages == 0UL) {
 		printk(KERN_ERR "MSI: Cannot allocate MSI queues (o=%lu).\n",
 		       order);
@@ -1275,7 +1276,7 @@ static int pci_sun4v_probe(struct platform_device *op)
 	err = -ENOMEM;
 	if (!iommu_batch_initialized) {
 		for_each_possible_cpu(i) {
-			unsigned long page = get_zeroed_page(GFP_KERNEL);
+			unsigned long page = (unsigned long)get_zeroed_page(GFP_KERNEL);
 
 			if (!page)
 				goto out_err;
diff --git a/arch/sparc/kernel/traps_64.c b/arch/sparc/kernel/traps_64.c
index 28cb0d66ab40..4b7354524265 100644
--- a/arch/sparc/kernel/traps_64.c
+++ b/arch/sparc/kernel/traps_64.c
@@ -902,7 +902,7 @@ void __init cheetah_ecache_flush_init(void)
 		if ((PAGE_SIZE << order) >= sz)
 			break;
 	}
-	cheetah_error_log = (struct cheetah_err_info *)
+	cheetah_error_log =
 		__get_free_pages(GFP_KERNEL, order);
 	if (!cheetah_error_log) {
 		prom_printf("cheetah_ecache_flush_init: Failed to allocate "
diff --git a/arch/sparc/mm/io-unit.c b/arch/sparc/mm/io-unit.c
index d8376f61b4d0..e5d309844c18 100644
--- a/arch/sparc/mm/io-unit.c
+++ b/arch/sparc/mm/io-unit.c
@@ -226,7 +226,7 @@ static void *iounit_alloc(struct device *dev, size_t len,
 		return NULL;
 
 	len = PAGE_ALIGN(len);
-	va = __get_free_pages(gfp | __GFP_ZERO, get_order(len));
+	va = (unsigned long)__get_free_pages(gfp | __GFP_ZERO, get_order(len));
 	if (!va)
 		return NULL;
 
diff --git a/arch/sparc/mm/iommu.c b/arch/sparc/mm/iommu.c
index 5a5080db800f..b6036dc4af95 100644
--- a/arch/sparc/mm/iommu.c
+++ b/arch/sparc/mm/iommu.c
@@ -93,7 +93,7 @@ static void __init sbus_iommu_init(struct platform_device *op)
 	   We need 256K or 512K or 1M or 2M area aligned to
            its size and current gfp will fortunately give
            it to us. */
-        tmp = __get_free_pages(GFP_KERNEL, IOMMU_ORDER);
+        tmp = (unsigned long)__get_free_pages(GFP_KERNEL, IOMMU_ORDER);
 	if (!tmp) {
 		prom_printf("Unable to allocate iommu table [0x%lx]\n",
 			    IOMMU_NPTES * sizeof(iopte_t));
@@ -324,7 +324,7 @@ static void *sbus_iommu_alloc(struct device *dev, size_t len,
 		return NULL;
 
 	len = PAGE_ALIGN(len);
-	va = __get_free_pages(gfp | __GFP_ZERO, get_order(len));
+	va = (unsigned long)__get_free_pages(gfp | __GFP_ZERO, get_order(len));
 	if (va == 0)
 		return NULL;
 
diff --git a/arch/um/kernel/process.c b/arch/um/kernel/process.c
index 9c9c66dc45f0..69815997db28 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -58,7 +58,7 @@ unsigned long alloc_stack(int order, int atomic)
 
 	if (atomic)
 		flags = GFP_ATOMIC;
-	page = __get_free_pages(flags, order);
+	page = (unsigned long)__get_free_pages(flags, order);
 
 	return page;
 }
diff --git a/arch/um/kernel/skas/mmu.c b/arch/um/kernel/skas/mmu.c
index afe9a2f251ef..a4312704cf0f 100644
--- a/arch/um/kernel/skas/mmu.c
+++ b/arch/um/kernel/skas/mmu.c
@@ -29,7 +29,8 @@ int init_new_context(struct task_struct *task, struct mm_struct *mm)
 	unsigned long stack = 0;
 	int ret = -ENOMEM;
 
-	stack = __get_free_pages(GFP_KERNEL | __GFP_ZERO, ilog2(STUB_DATA_PAGES));
+	stack = (unsigned long)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
+						ilog2(STUB_DATA_PAGES));
 	if (stack == 0)
 		goto out;
 
diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
index 651771534cae..c95e089b3e6a 100644
--- a/arch/x86/hyperv/ivm.c
+++ b/arch/x86/hyperv/ivm.c
@@ -293,7 +293,7 @@ static void snp_cleanup_vmsa(struct sev_es_save_area *vmsa)
 
 int hv_snp_boot_ap(u32 apic_id, unsigned long start_ip, unsigned int cpu)
 {
-	struct sev_es_save_area *vmsa = (struct sev_es_save_area *)
+	struct sev_es_save_area *vmsa =
 		__get_free_page(GFP_KERNEL | __GFP_ZERO);
 	struct sev_es_save_area *cur_vmsa;
 	struct desc_ptr gdtr;
diff --git a/arch/x86/kernel/amd_gart_64.c b/arch/x86/kernel/amd_gart_64.c
index 3485d419c2f5..c9a46d15471d 100644
--- a/arch/x86/kernel/amd_gart_64.c
+++ b/arch/x86/kernel/amd_gart_64.c
@@ -641,7 +641,7 @@ static __init int init_amd_gatt(struct agp_kern_info *info)
 	info->aper_size = aper_size >> 20;
 
 	gatt_size = (aper_size >> PAGE_SHIFT) * sizeof(u32);
-	gatt = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
+	gatt = __get_free_pages(GFP_KERNEL | __GFP_ZERO,
 					get_order(gatt_size));
 	if (!gatt)
 		panic("Cannot allocate GATT table");
@@ -750,7 +750,7 @@ int __init gart_iommu_init(void)
 	iommu_size = check_iommu_size(info.aper_base, aper_size);
 	iommu_pages = iommu_size >> PAGE_SHIFT;
 
-	iommu_gart_bitmap = (void *) __get_free_pages(GFP_KERNEL | __GFP_ZERO,
+	iommu_gart_bitmap = __get_free_pages(GFP_KERNEL | __GFP_ZERO,
 						      get_order(iommu_pages/8));
 	if (!iommu_gart_bitmap)
 		panic("Cannot allocate iommu bitmap\n");
@@ -798,7 +798,7 @@ int __init gart_iommu_init(void)
 	 * Any prefetches that hit unmapped entries won't get an bus abort
 	 * then. (P2P bridge may be prefetching on DMA reads).
 	 */
-	scratch = get_zeroed_page(GFP_KERNEL);
+	scratch = (unsigned long)get_zeroed_page(GFP_KERNEL);
 	if (!scratch)
 		panic("Cannot allocate iommu scratch page");
 	gart_unmapped_entry = GPTE_ENCODE(__pa(scratch));
diff --git a/arch/x86/kernel/ldt.c b/arch/x86/kernel/ldt.c
index 0f19ef355f5f..e7afcffc121a 100644
--- a/arch/x86/kernel/ldt.c
+++ b/arch/x86/kernel/ldt.c
@@ -170,7 +170,7 @@ static struct ldt_struct *alloc_ldt_struct(unsigned int num_entries)
 	if (alloc_size > PAGE_SIZE)
 		new_ldt->entries = __vmalloc(alloc_size, GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 	else
-		new_ldt->entries = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
+		new_ldt->entries = get_zeroed_page(GFP_KERNEL_ACCOUNT);
 
 	if (!new_ldt->entries) {
 		kfree(new_ldt);
diff --git a/arch/x86/kernel/machine_kexec_32.c b/arch/x86/kernel/machine_kexec_32.c
index 1f325304c4a8..c2a2e729f20a 100644
--- a/arch/x86/kernel/machine_kexec_32.c
+++ b/arch/x86/kernel/machine_kexec_32.c
@@ -58,14 +58,14 @@ static void machine_kexec_free_page_tables(struct kimage *image)
 
 static int machine_kexec_alloc_page_tables(struct kimage *image)
 {
-	image->arch.pgd = (pgd_t *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
+	image->arch.pgd = __get_free_pages(GFP_KERNEL | __GFP_ZERO,
 						    pgd_allocation_order());
 #ifdef CONFIG_X86_PAE
-	image->arch.pmd0 = (pmd_t *)get_zeroed_page(GFP_KERNEL);
-	image->arch.pmd1 = (pmd_t *)get_zeroed_page(GFP_KERNEL);
+	image->arch.pmd0 = get_zeroed_page(GFP_KERNEL);
+	image->arch.pmd1 = get_zeroed_page(GFP_KERNEL);
 #endif
-	image->arch.pte0 = (pte_t *)get_zeroed_page(GFP_KERNEL);
-	image->arch.pte1 = (pte_t *)get_zeroed_page(GFP_KERNEL);
+	image->arch.pte0 = get_zeroed_page(GFP_KERNEL);
+	image->arch.pte1 = get_zeroed_page(GFP_KERNEL);
 	if (!image->arch.pgd ||
 #ifdef CONFIG_X86_PAE
 	    !image->arch.pmd0 || !image->arch.pmd1 ||
diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index 201137b98fb8..05785d2d018f 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -180,7 +180,7 @@ static int init_transition_pgtable(struct kimage *image, pgd_t *pgd,
 	paddr = control_page;
 	pgd += pgd_index(vaddr);
 	if (!pgd_present(*pgd)) {
-		p4d = (p4d_t *)get_zeroed_page(GFP_KERNEL);
+		p4d = get_zeroed_page(GFP_KERNEL);
 		if (!p4d)
 			goto err;
 		image->arch.p4d = p4d;
@@ -188,7 +188,7 @@ static int init_transition_pgtable(struct kimage *image, pgd_t *pgd,
 	}
 	p4d = p4d_offset(pgd, vaddr);
 	if (!p4d_present(*p4d)) {
-		pud = (pud_t *)get_zeroed_page(GFP_KERNEL);
+		pud = get_zeroed_page(GFP_KERNEL);
 		if (!pud)
 			goto err;
 		image->arch.pud = pud;
@@ -196,7 +196,7 @@ static int init_transition_pgtable(struct kimage *image, pgd_t *pgd,
 	}
 	pud = pud_offset(p4d, vaddr);
 	if (!pud_present(*pud)) {
-		pmd = (pmd_t *)get_zeroed_page(GFP_KERNEL);
+		pmd = get_zeroed_page(GFP_KERNEL);
 		if (!pmd)
 			goto err;
 		image->arch.pmd = pmd;
@@ -204,7 +204,7 @@ static int init_transition_pgtable(struct kimage *image, pgd_t *pgd,
 	}
 	pmd = pmd_offset(pud, vaddr);
 	if (!pmd_present(*pmd)) {
-		pte = (pte_t *)get_zeroed_page(GFP_KERNEL);
+		pte = get_zeroed_page(GFP_KERNEL);
 		if (!pte)
 			goto err;
 		image->arch.pte = pte;
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 0ae7f913d782..42435f6f86a0 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2998,7 +2998,7 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu)
 	if (kvm_x86_ops.alloc_apic_backing_page)
 		apic->regs = kvm_x86_call(alloc_apic_backing_page)(vcpu);
 	else
-		apic->regs = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
+		apic->regs = get_zeroed_page(GFP_KERNEL_ACCOUNT);
 	if (!apic->regs) {
 		printk(KERN_ERR "malloc apic regs error for vcpu %x\n",
 		       vcpu->vcpu_id);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 667d66cf76d5..be916ba93ac9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4210,17 +4210,17 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
 	 * Unlike 32-bit NPT, the PDP table doesn't need to be in low mem, and
 	 * doesn't need to be decrypted.
 	 */
-	pae_root = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
+	pae_root = get_zeroed_page(GFP_KERNEL_ACCOUNT);
 	if (!pae_root)
 		return -ENOMEM;
 
 #ifdef CONFIG_X86_64
-	pml4_root = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
+	pml4_root = get_zeroed_page(GFP_KERNEL_ACCOUNT);
 	if (!pml4_root)
 		goto err_pml4;
 
 	if (need_pml5) {
-		pml5_root = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
+		pml5_root = get_zeroed_page(GFP_KERNEL_ACCOUNT);
 		if (!pml5_root)
 			goto err_pml5;
 	}
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index c5734ca5c17d..65ca2d4a3ee1 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1510,7 +1510,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(void)
 	if (!sp)
 		return NULL;
 
-	sp->spt = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
+	sp->spt = get_zeroed_page(GFP_KERNEL_ACCOUNT);
 	if (!sp->spt) {
 		kmem_cache_free(mmu_page_header_cache, sp);
 		return NULL;
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index f286b5706d7c..6649fa1e72f6 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -274,11 +274,11 @@ int avic_vm_init(struct kvm *kvm)
 	if (!enable_apicv)
 		return 0;
 
-	kvm_svm->avic_physical_id_table = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
+	kvm_svm->avic_physical_id_table = get_zeroed_page(GFP_KERNEL_ACCOUNT);
 	if (!kvm_svm->avic_physical_id_table)
 		goto free_avic;
 
-	kvm_svm->avic_logical_id_table = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
+	kvm_svm->avic_logical_id_table = get_zeroed_page(GFP_KERNEL_ACCOUNT);
 	if (!kvm_svm->avic_logical_id_table)
 		goto free_avic;
 
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 76271962cb70..d65f97bc2803 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -7457,7 +7457,7 @@ __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *))
 			 * The vmx_bitmap is not tied to a VM and so should
 			 * not be charged to a memcg.
 			 */
-			vmx_bitmap[i] = (unsigned long *)
+			vmx_bitmap[i] =
 				__get_free_page(GFP_KERNEL);
 			if (!vmx_bitmap[i]) {
 				nested_vmx_hardware_unsetup();
diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
index df1d0cf76947..6210101c222b 100644
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -274,7 +274,7 @@ static int handle_encls_ecreate(struct kvm_vcpu *vcpu)
 	 * simultaneously set SGX_ATTR_PROVISIONKEY to bypass the check to
 	 * enforce restriction of access to the PROVISIONKEY.
 	 */
-	contents = (struct sgx_secs *)__get_free_page(GFP_KERNEL);
+	contents = __get_free_page(GFP_KERNEL);
 	if (!contents)
 		return -ENOMEM;
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f87c216d976d..4376e01509e6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2944,7 +2944,7 @@ int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs)
 	loaded_vmcs->launched = 0;
 
 	if (cpu_has_vmx_msr_bitmap()) {
-		loaded_vmcs->msr_bitmap = (unsigned long *)
+		loaded_vmcs->msr_bitmap =
 				__get_free_page(GFP_KERNEL_ACCOUNT);
 		if (!loaded_vmcs->msr_bitmap)
 			goto out_vmcs;
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 8bf6ad4b9400..e5da2cd0fee9 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -133,7 +133,7 @@ __ref void *alloc_low_pages(unsigned int num)
 		unsigned int order;
 
 		order = get_order((unsigned long)num << PAGE_SHIFT);
-		return (void *)__get_free_pages(GFP_ATOMIC | __GFP_ZERO, order);
+		return __get_free_pages(GFP_ATOMIC | __GFP_ZERO, order);
 	}
 
 	if ((pgt_buf_end + num) > pgt_buf_top || !can_use_brk_pgt) {
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 0e4270e20fad..e871b6092ab7 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -250,7 +250,7 @@ static __ref void *spp_getpage(void)
 	void *ptr;
 
 	if (after_bootmem)
-		ptr = (void *) get_zeroed_page(GFP_ATOMIC);
+		ptr = get_zeroed_page(GFP_ATOMIC);
 	else
 		ptr = memblock_alloc(PAGE_SIZE, PAGE_SIZE);
 
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index d2d54b8c4dbb..5630add8eaac 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1539,7 +1539,7 @@ static void unmap_pud_range(p4d_t *p4d, unsigned long start, unsigned long end)
 
 static int alloc_pte_page(pmd_t *pmd)
 {
-	pte_t *pte = (pte_t *)get_zeroed_page(GFP_KERNEL);
+	pte_t *pte = get_zeroed_page(GFP_KERNEL);
 	if (!pte)
 		return -1;
 
@@ -1549,7 +1549,7 @@ static int alloc_pte_page(pmd_t *pmd)
 
 static int alloc_pmd_page(pud_t *pud)
 {
-	pmd_t *pmd = (pmd_t *)get_zeroed_page(GFP_KERNEL);
+	pmd_t *pmd = get_zeroed_page(GFP_KERNEL);
 	if (!pmd)
 		return -1;
 
@@ -1743,7 +1743,7 @@ static int populate_pgd(struct cpa_data *cpa, unsigned long addr)
 	pgd_entry = cpa->pgd + pgd_index(addr);
 
 	if (pgd_none(*pgd_entry)) {
-		p4d = (p4d_t *)get_zeroed_page(GFP_KERNEL);
+		p4d = get_zeroed_page(GFP_KERNEL);
 		if (!p4d)
 			return -1;
 
@@ -1755,7 +1755,7 @@ static int populate_pgd(struct cpa_data *cpa, unsigned long addr)
 	 */
 	p4d = p4d_offset(pgd_entry, addr);
 	if (p4d_none(*p4d)) {
-		pud = (pud_t *)get_zeroed_page(GFP_KERNEL);
+		pud = get_zeroed_page(GFP_KERNEL);
 		if (!pud)
 			return -1;
 
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index ddf248c3ee7d..eee601e9204a 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -733,7 +733,7 @@ int pud_free_pmd_page(pud_t *pud, unsigned long addr)
 	int i;
 
 	pmd = pud_pgtable(*pud);
-	pmd_sv = (pmd_t *)__get_free_page(GFP_KERNEL);
+	pmd_sv = __get_free_page(GFP_KERNEL);
 	if (!pmd_sv)
 		return 0;
 
diff --git a/arch/x86/mm/pti.c b/arch/x86/mm/pti.c
index b10d4d131dce..5f190e049629 100644
--- a/arch/x86/mm/pti.c
+++ b/arch/x86/mm/pti.c
@@ -186,7 +186,7 @@ static p4d_t *pti_user_pagetable_walk_p4d(unsigned long address)
 	}
 
 	if (pgd_none(*pgd)) {
-		unsigned long new_p4d_page = __get_free_page(gfp);
+		unsigned long new_p4d_page = (unsigned long)__get_free_page(gfp);
 		if (WARN_ON_ONCE(!new_p4d_page))
 			return NULL;
 
@@ -215,7 +215,7 @@ static pmd_t *pti_user_pagetable_walk_pmd(unsigned long address)
 
 	BUILD_BUG_ON(p4d_leaf(*p4d));
 	if (p4d_none(*p4d)) {
-		unsigned long new_pud_page = __get_free_page(gfp);
+		unsigned long new_pud_page = (unsigned long)__get_free_page(gfp);
 		if (WARN_ON_ONCE(!new_pud_page))
 			return NULL;
 
@@ -229,7 +229,7 @@ static pmd_t *pti_user_pagetable_walk_pmd(unsigned long address)
 		return NULL;
 	}
 	if (pud_none(*pud)) {
-		unsigned long new_pmd_page = __get_free_page(gfp);
+		unsigned long new_pmd_page = (unsigned long)__get_free_page(gfp);
 		if (WARN_ON_ONCE(!new_pmd_page))
 			return NULL;
 
@@ -270,7 +270,7 @@ static pte_t *pti_user_pagetable_walk_pte(unsigned long address, bool late_text)
 	}
 
 	if (pmd_none(*pmd)) {
-		unsigned long new_pte_page = __get_free_page(gfp);
+		unsigned long new_pte_page = (unsigned long)__get_free_page(gfp);
 		if (!new_pte_page)
 			return NULL;
 
diff --git a/arch/x86/pci/pcbios.c b/arch/x86/pci/pcbios.c
index 244c643bb0b5..c4b4a3483ae3 100644
--- a/arch/x86/pci/pcbios.c
+++ b/arch/x86/pci/pcbios.c
@@ -372,7 +372,7 @@ struct irq_routing_table * pcibios_get_irq_routing_table(void)
 
 	if (!pci_bios_present)
 		return NULL;
-	page = __get_free_page(GFP_KERNEL);
+	page = (unsigned long)__get_free_page(GFP_KERNEL);
 	if (!page)
 		return NULL;
 	opt.table = (struct irq_info *) page;
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 463b784499a8..2e4852ddf2df 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -540,7 +540,7 @@ static void *realloc_pages(void *old_memmap, int old_shift)
 {
 	void *ret;
 
-	ret = (void *)__get_free_pages(GFP_KERNEL, old_shift + 1);
+	ret = __get_free_pages(GFP_KERNEL, old_shift + 1);
 	if (!ret)
 		goto out;
 
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index b4409df2105a..193c513e15bf 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -73,7 +73,7 @@ int __init efi_alloc_page_tables(void)
 	gfp_t gfp_mask;
 
 	gfp_mask = GFP_KERNEL | __GFP_ZERO;
-	efi_pgd = (pgd_t *)__get_free_pages(gfp_mask, pgd_allocation_order());
+	efi_pgd = __get_free_pages(gfp_mask, pgd_allocation_order());
 	if (!efi_pgd)
 		goto fail;
 
diff --git a/arch/x86/xen/mmu_pv.c b/arch/x86/xen/mmu_pv.c
index 2a4a8deaf612..5f76d99a2733 100644
--- a/arch/x86/xen/mmu_pv.c
+++ b/arch/x86/xen/mmu_pv.c
@@ -127,7 +127,7 @@ static int alloc_discontig_frames(unsigned int order)
 	BUG_ON(order < MIN_CONTIG_ORDER);
 	BUILD_BUG_ON(sizeof(discontig_frames_early) != PAGE_SIZE);
 
-	new_array = (unsigned long *)__get_free_pages(GFP_KERNEL,
+	new_array = __get_free_pages(GFP_KERNEL,
 						      order - MIN_CONTIG_ORDER);
 	if (!new_array)
 		return -ENOMEM;
@@ -1458,7 +1458,7 @@ static int xen_pgd_alloc(struct mm_struct *mm)
 	BUG_ON(PagePinned(virt_to_page(pgd)));
 	BUG_ON(page->private != 0);
 
-	user_pgd = (pgd_t *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
+	user_pgd = __get_free_page(GFP_KERNEL | __GFP_ZERO);
 	page->private = (unsigned long)user_pgd;
 
 	if (user_pgd != NULL) {
diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 2dd12b61a230..775c8e40e354 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -181,7 +181,7 @@ static void * __ref alloc_p2m_page(void)
 		return memblock_alloc_or_panic(PAGE_SIZE, PAGE_SIZE);
 	}
 
-	return (void *)__get_free_page(GFP_KERNEL);
+	return __get_free_page(GFP_KERNEL);
 }
 
 static void __ref free_p2m_page(void *p)
diff --git a/arch/x86/xen/pmu.c b/arch/x86/xen/pmu.c
index 8f89ce0b67e3..f94d69f5fcfd 100644
--- a/arch/x86/xen/pmu.c
+++ b/arch/x86/xen/pmu.c
@@ -499,7 +499,7 @@ void xen_pmu_init(int cpu)
 	if (xen_hvm_domain() || (cpu != 0 && !is_xen_pmu))
 		return;
 
-	xenpmu_data = (struct xen_pmu_data *)get_zeroed_page(GFP_KERNEL);
+	xenpmu_data = get_zeroed_page(GFP_KERNEL);
 	if (!xenpmu_data) {
 		pr_err("VPMU init: No memory\n");
 		return;
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 96521b1874ac..febf1e0a167d 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -447,7 +447,7 @@ static void xen_setup_vsyscall_time_info(void)
 	struct pvclock_vsyscall_time_info *ti;
 	int ret;
 
-	ti = (struct pvclock_vsyscall_time_info *)get_zeroed_page(GFP_KERNEL);
+	ti = get_zeroed_page(GFP_KERNEL);
 	if (!ti)
 		return;
 
diff --git a/block/partitions/core.c b/block/partitions/core.c
index 815ed33caa1b..98c03654362a 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -122,7 +122,7 @@ static struct parsed_partitions *check_partition(struct gendisk *hd)
 	state = allocate_partitions(hd);
 	if (!state)
 		return NULL;
-	state->pp_buf = (char *)__get_free_page(GFP_KERNEL);
+	state->pp_buf = __get_free_page(GFP_KERNEL);
 	if (!state->pp_buf) {
 		free_partitions(state);
 		return NULL;
diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index 1d010e2a1b1a..dbe3d080a7fc 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -237,7 +237,7 @@ static int skcipher_walk_next(struct skcipher_walk *walk)
 		if (!walk->page) {
 			gfp_t gfp = skcipher_walk_gfp(walk);
 
-			walk->page = (void *)__get_free_page(gfp);
+			walk->page = __get_free_page(gfp);
 			if (!walk->page)
 				goto slow_path;
 		}
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index d1d88debbd71..8bc373ac1cec 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -80,7 +80,7 @@ static int testmgr_alloc_buf(char *buf[XBUFSIZE])
 	int i;
 
 	for (i = 0; i < XBUFSIZE; i++) {
-		buf[i] = (void *)__get_free_page(GFP_KERNEL);
+		buf[i] = __get_free_page(GFP_KERNEL);
 		if (!buf[i])
 			goto err_free_buf;
 	}
@@ -2815,7 +2815,7 @@ static int __init tcrypt_mod_init(void)
 	int i;
 
 	for (i = 0; i < TVMEMSIZE; i++) {
-		tvmem[i] = (void *)__get_free_page(GFP_KERNEL);
+		tvmem[i] = __get_free_page(GFP_KERNEL);
 		if (!tvmem[i])
 			goto err_free_tv;
 	}
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 6a490aaa71b9..c57a1118e86e 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -174,7 +174,7 @@ static int __testmgr_alloc_buf(char *buf[XBUFSIZE], int order)
 	int i;
 
 	for (i = 0; i < XBUFSIZE; i++) {
-		buf[i] = (char *)__get_free_pages(GFP_KERNEL, order);
+		buf[i] = __get_free_pages(GFP_KERNEL, order);
 		if (!buf[i])
 			goto err_free_buf;
 	}
diff --git a/crypto/xor.c b/crypto/xor.c
index f39621a57bb3..5838f601ac6f 100644
--- a/crypto/xor.c
+++ b/crypto/xor.c
@@ -127,7 +127,7 @@ calibrate_xor_blocks(void)
 		goto out;
 	}
 
-	b1 = (void *) __get_free_pages(GFP_KERNEL, 2);
+	b1 = __get_free_pages(GFP_KERNEL, 2);
 	if (!b1) {
 		printk(KERN_WARNING "xor: Yikes!  No memory available.\n");
 		return -ENOMEM;
diff --git a/drivers/acpi/nvs.c b/drivers/acpi/nvs.c
index a2b11069e792..3f96cf7042e0 100644
--- a/drivers/acpi/nvs.c
+++ b/drivers/acpi/nvs.c
@@ -156,7 +156,7 @@ int suspend_nvs_alloc(void)
 	struct nvs_page *entry;
 
 	list_for_each_entry(entry, &nvs_list, node) {
-		entry->data = (void *)__get_free_page(GFP_KERNEL);
+		entry->data = __get_free_page(GFP_KERNEL);
 		if (!entry->data) {
 			suspend_nvs_free();
 			return -ENOMEM;
diff --git a/drivers/atm/eni.c b/drivers/atm/eni.c
index 3011cf1a84a9..c899bf3ce3a1 100644
--- a/drivers/atm/eni.c
+++ b/drivers/atm/eni.c
@@ -901,7 +901,7 @@ static int start_rx(struct atm_dev *dev)
 	struct eni_dev *eni_dev;
 
 	eni_dev = ENI_DEV(dev);
-	eni_dev->rx_map = (struct atm_vcc **) get_zeroed_page(GFP_KERNEL);
+	eni_dev->rx_map = get_zeroed_page(GFP_KERNEL);
 	if (!eni_dev->rx_map) {
 		printk(KERN_ERR DEV_LABEL "(itf %d): couldn't get free page\n",
 		    dev->number);
diff --git a/drivers/atm/lanai.c b/drivers/atm/lanai.c
index 0dfa2cdc897c..c496b040b238 100644
--- a/drivers/atm/lanai.c
+++ b/drivers/atm/lanai.c
@@ -1440,7 +1440,7 @@ static int vcc_table_allocate(struct lanai_dev *lanai)
 #ifdef VCCTABLE_GETFREEPAGE
 	APRINTK((lanai->num_vci) * sizeof(struct lanai_vcc *) <= PAGE_SIZE,
 	    "vcc table > PAGE_SIZE!");
-	lanai->vccs = (struct lanai_vcc **) get_zeroed_page(GFP_KERNEL);
+	lanai->vccs = get_zeroed_page(GFP_KERNEL);
 	return (lanai->vccs == NULL) ? -ENOMEM : 0;
 #else
 	int bytes = (lanai->num_vci) * sizeof(struct lanai_vcc *);
diff --git a/drivers/auxdisplay/cfag12864b.c b/drivers/auxdisplay/cfag12864b.c
index e1a94ae3eb0c..693212c99470 100644
--- a/drivers/auxdisplay/cfag12864b.c
+++ b/drivers/auxdisplay/cfag12864b.c
@@ -313,7 +313,7 @@ static int __init cfag12864b_init(void)
 	}
 	BUILD_BUG_ON(PAGE_SIZE < CFAG12864B_SIZE);
 
-	cfag12864b_buffer = (unsigned char *) get_zeroed_page(GFP_KERNEL);
+	cfag12864b_buffer = get_zeroed_page(GFP_KERNEL);
 	if (cfag12864b_buffer == NULL) {
 		printk(KERN_ERR CFAG12864B_NAME ": ERROR: "
 			"can't get a free page\n");
diff --git a/drivers/auxdisplay/ht16k33.c b/drivers/auxdisplay/ht16k33.c
index 0b8ba754b343..f413b61b0a6b 100644
--- a/drivers/auxdisplay/ht16k33.c
+++ b/drivers/auxdisplay/ht16k33.c
@@ -591,7 +591,7 @@ static int ht16k33_fbdev_probe(struct device *dev, struct ht16k33_priv *priv,
 
 	/* Framebuffer (2 bytes per column) */
 	BUILD_BUG_ON(PAGE_SIZE < HT16K33_FB_SIZE);
-	fbdev->buffer = (unsigned char *) get_zeroed_page(GFP_KERNEL);
+	fbdev->buffer = get_zeroed_page(GFP_KERNEL);
 	if (!fbdev->buffer)
 		return -ENOMEM;
 
diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index c948c88d3956..803d55bf7331 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -1177,7 +1177,7 @@ unsigned long devm_get_free_pages(struct device *dev,
 	struct pages_devres *devres;
 	unsigned long addr;
 
-	addr = __get_free_pages(gfp_mask, order);
+	addr = (unsigned long)__get_free_pages(gfp_mask, order);
 
 	if (unlikely(!addr))
 		return 0;
diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index a9affb7c264d..bf50b2eae1f7 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -1692,7 +1692,7 @@ aoecmd_init(void)
 	int ret;
 
 	/* get_zeroed_page returns page with ref count 1 */
-	p = (void *) get_zeroed_page(GFP_KERNEL);
+	p = get_zeroed_page(GFP_KERNEL);
 	if (!p)
 		return -ENOMEM;
 	empty_page = virt_to_page(p);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index c73376886e7a..b3ef65a12865 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2418,10 +2418,10 @@ struct drbd_connection *conn_get_by_addrs(void *my_addr, int my_addr_len,
 
 static int drbd_alloc_socket(struct drbd_socket *socket)
 {
-	socket->rbuf = (void *) __get_free_page(GFP_KERNEL);
+	socket->rbuf = __get_free_page(GFP_KERNEL);
 	if (!socket->rbuf)
 		return -ENOMEM;
-	socket->sbuf = (void *) __get_free_page(GFP_KERNEL);
+	socket->sbuf = __get_free_page(GFP_KERNEL);
 	if (!socket->sbuf)
 		return -ENOMEM;
 	return 0;
diff --git a/drivers/block/ps3vram.c b/drivers/block/ps3vram.c
index bdcf083b45e2..8eeb3981de24 100644
--- a/drivers/block/ps3vram.c
+++ b/drivers/block/ps3vram.c
@@ -624,7 +624,7 @@ static int ps3vram_probe(struct ps3_system_bus_device *dev)
 	ps3_system_bus_set_drvdata(dev, priv);
 
 	/* Allocate XDR buffer (1MiB aligned) */
-	priv->xdr_buf = (void *)__get_free_pages(GFP_KERNEL,
+	priv->xdr_buf = __get_free_pages(GFP_KERNEL,
 		get_order(XDR_BUF_SIZE));
 	if (priv->xdr_buf == NULL) {
 		dev_err(&dev->core, "Could not allocate XDR buffer\n");
diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 0c74a41a6753..8cb10c7d887f 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -2691,7 +2691,7 @@ static int ublk_init_queue(struct ublk_device *ub, int q_id)
 	ubq->q_depth = ub->dev_info.queue_depth;
 	size = ublk_queue_cmd_buf_size(ub);
 
-	ptr = (void *) __get_free_pages(gfp_flags, get_order(size));
+	ptr = __get_free_pages(gfp_flags, get_order(size));
 	if (!ptr)
 		return -ENOMEM;
 
diff --git a/drivers/char/agp/agp.h b/drivers/char/agp/agp.h
index 67d7be800a7c..43ecf69ce5c6 100644
--- a/drivers/char/agp/agp.h
+++ b/drivers/char/agp/agp.h
@@ -228,7 +228,7 @@ void agp3_generic_cleanup(void);
 
 /* GATT allocation. Returns/accepts GATT kernel virtual address. */
 #define alloc_gatt_pages(order)		\
-	((char *)__get_free_pages(GFP_KERNEL, (order)))
+	(__get_free_pages(GFP_KERNEL, (order)))
 #define free_gatt_pages(table, order)	\
 	free_pages((unsigned long)(table), (order))
 
diff --git a/drivers/char/agp/amd-k7-agp.c b/drivers/char/agp/amd-k7-agp.c
index 795c8c9ff680..f3789188abd5 100644
--- a/drivers/char/agp/amd-k7-agp.c
+++ b/drivers/char/agp/amd-k7-agp.c
@@ -38,7 +38,7 @@ static int amd_create_page_map(struct amd_page_map *page_map)
 {
 	int i;
 
-	page_map->real = (unsigned long *) __get_free_page(GFP_KERNEL);
+	page_map->real = __get_free_page(GFP_KERNEL);
 	if (page_map->real == NULL)
 		return -ENOMEM;
 
diff --git a/drivers/char/agp/ati-agp.c b/drivers/char/agp/ati-agp.c
index f7871afe08cf..07d4c1a76d14 100644
--- a/drivers/char/agp/ati-agp.c
+++ b/drivers/char/agp/ati-agp.c
@@ -57,7 +57,7 @@ static int ati_create_page_map(struct ati_page_map *page_map)
 {
 	int i, err;
 
-	page_map->real = (unsigned long *) __get_free_page(GFP_KERNEL);
+	page_map->real = __get_free_page(GFP_KERNEL);
 	if (page_map->real == NULL)
 		return -ENOMEM;
 
diff --git a/drivers/char/agp/efficeon-agp.c b/drivers/char/agp/efficeon-agp.c
index 0d25bbdc7e6a..dab8c28dcd95 100644
--- a/drivers/char/agp/efficeon-agp.c
+++ b/drivers/char/agp/efficeon-agp.c
@@ -213,7 +213,7 @@ static int efficeon_create_gatt_table(struct agp_bridge_data *bridge)
 		page = efficeon_private.l1_table[index];
 		BUG_ON(page);
 
-		page = get_zeroed_page(GFP_KERNEL);
+		page = (unsigned long)get_zeroed_page(GFP_KERNEL);
 		if (!page) {
 			efficeon_free_gatt_table(agp_bridge);
 			return -ENOMEM;
diff --git a/drivers/char/agp/sworks-agp.c b/drivers/char/agp/sworks-agp.c
index 0ab7562d17c9..fa247702903d 100644
--- a/drivers/char/agp/sworks-agp.c
+++ b/drivers/char/agp/sworks-agp.c
@@ -49,7 +49,7 @@ static int serverworks_create_page_map(struct serverworks_page_map *page_map)
 {
 	int i;
 
-	page_map->real = (unsigned long *) __get_free_page(GFP_KERNEL);
+	page_map->real = __get_free_page(GFP_KERNEL);
 	if (page_map->real == NULL) {
 		return -ENOMEM;
 	}
diff --git a/drivers/char/agp/uninorth-agp.c b/drivers/char/agp/uninorth-agp.c
index b8d7115b8c9e..b148aa8b4b18 100644
--- a/drivers/char/agp/uninorth-agp.c
+++ b/drivers/char/agp/uninorth-agp.c
@@ -391,7 +391,7 @@ static int uninorth_create_gatt_table(struct agp_bridge_data *bridge)
 		page_order = A_SIZE_32(temp)->page_order;
 		num_entries = A_SIZE_32(temp)->num_entries;
 
-		table = (char *) __get_free_pages(GFP_KERNEL, page_order);
+		table = __get_free_pages(GFP_KERNEL, page_order);
 
 		if (table == NULL) {
 			i++;
diff --git a/drivers/char/hw_random/s390-trng.c b/drivers/char/hw_random/s390-trng.c
index d27e32e9bfee..5f60ea40aea3 100644
--- a/drivers/char/hw_random/s390-trng.c
+++ b/drivers/char/hw_random/s390-trng.c
@@ -68,7 +68,7 @@ static ssize_t trng_read(struct file *file, char __user *ubuf,
 	 */
 
 	if (nbytes > sizeof(buf)) {
-		p = (u8 *) __get_free_page(GFP_KERNEL);
+		p = __get_free_page(GFP_KERNEL);
 		if (!p)
 			return -ENOMEM;
 	}
diff --git a/drivers/char/tpm/tpm-buf.c b/drivers/char/tpm/tpm-buf.c
index dc882fc9fa9e..e3e1a1d46646 100644
--- a/drivers/char/tpm/tpm-buf.c
+++ b/drivers/char/tpm/tpm-buf.c
@@ -17,7 +17,7 @@
  */
 int tpm_buf_init(struct tpm_buf *buf, u16 tag, u32 ordinal)
 {
-	buf->data = (u8 *)__get_free_page(GFP_KERNEL);
+	buf->data = __get_free_page(GFP_KERNEL);
 	if (!buf->data)
 		return -ENOMEM;
 
@@ -56,7 +56,7 @@ EXPORT_SYMBOL_GPL(tpm_buf_reset);
  */
 int tpm_buf_init_sized(struct tpm_buf *buf)
 {
-	buf->data = (u8 *)__get_free_page(GFP_KERNEL);
+	buf->data = __get_free_page(GFP_KERNEL);
 	if (!buf->data)
 		return -ENOMEM;
 
diff --git a/drivers/char/tpm/tpm_ibmvtpm.c b/drivers/char/tpm/tpm_ibmvtpm.c
index 4734a69406ce..1f0a6e1a0743 100644
--- a/drivers/char/tpm/tpm_ibmvtpm.c
+++ b/drivers/char/tpm/tpm_ibmvtpm.c
@@ -621,7 +621,7 @@ static int tpm_ibmvtpm_probe(struct vio_dev *vio_dev,
 	ibmvtpm->vdev = vio_dev;
 
 	crq_q = &ibmvtpm->crq_queue;
-	crq_q->crq_addr = (struct ibmvtpm_crq *)get_zeroed_page(GFP_KERNEL);
+	crq_q->crq_addr = get_zeroed_page(GFP_KERNEL);
 	if (!crq_q->crq_addr) {
 		dev_err(dev, "Unable to allocate memory for crq_addr\n");
 		goto cleanup;
diff --git a/drivers/char/xilinx_hwicap/xilinx_hwicap.c b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
index 34a345dc5e72..4a83c408b35c 100644
--- a/drivers/char/xilinx_hwicap/xilinx_hwicap.c
+++ b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
@@ -382,7 +382,7 @@ hwicap_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 		       4 - bytes_to_read);
 	} else {
 		/* Get new data from the ICAP, and return what was requested. */
-		kbuf = (u32 *) get_zeroed_page(GFP_KERNEL);
+		kbuf = get_zeroed_page(GFP_KERNEL);
 		if (!kbuf) {
 			status = -ENOMEM;
 			goto error;
@@ -457,7 +457,7 @@ hwicap_write(struct file *file, const char __user *buf,
 		goto error;
 	}
 
-	kbuf = (u32 *) __get_free_page(GFP_KERNEL);
+	kbuf = __get_free_page(GFP_KERNEL);
 	if (!kbuf) {
 		status = -ENOMEM;
 		goto error;
diff --git a/drivers/char/xillybus/xillyusb.c b/drivers/char/xillybus/xillyusb.c
index 45771b1a3716..5083cb5c6d7e 100644
--- a/drivers/char/xillybus/xillyusb.c
+++ b/drivers/char/xillybus/xillyusb.c
@@ -399,7 +399,7 @@ static int fifo_init(struct xillyfifo *fifo,
 		return -ENOMEM;
 
 	for (i = 0; i < fifo->bufnum; i++) {
-		fifo->mem[i] = (void *)
+		fifo->mem[i] =
 			__get_free_pages(GFP_KERNEL, buf_order);
 
 		if (!fifo->mem[i])
@@ -529,7 +529,7 @@ static struct xillyusb_endpoint
 			return NULL;
 		}
 
-		addr = __get_free_pages(GFP_KERNEL, order);
+		addr = (unsigned long)__get_free_pages(GFP_KERNEL, order);
 
 		if (!addr) {
 			kfree(xb);
diff --git a/drivers/comedi/comedi_buf.c b/drivers/comedi/comedi_buf.c
index 002c0e76baff..164d8a53b311 100644
--- a/drivers/comedi/comedi_buf.c
+++ b/drivers/comedi/comedi_buf.c
@@ -97,7 +97,7 @@ comedi_buf_map_alloc(struct comedi_device *dev, enum dma_data_direction dma_dir,
 	} else {
 		for (i = 0; i < n_pages; i++) {
 			buf = &bm->page_list[i];
-			buf->virt_addr = (void *)get_zeroed_page(GFP_KERNEL);
+			buf->virt_addr = get_zeroed_page(GFP_KERNEL);
 			if (!buf->virt_addr)
 				break;
 
diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 3a2684208dda..b00ff9c0b45a 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -2117,7 +2117,7 @@ static struct aead_alg aes_authenc_algs[] = {
 
 static int atmel_aes_buff_init(struct atmel_aes_dev *dd)
 {
-	dd->buf = (void *)__get_free_pages(GFP_KERNEL, ATMEL_AES_BUFFER_ORDER);
+	dd->buf = __get_free_pages(GFP_KERNEL, ATMEL_AES_BUFFER_ORDER);
 	dd->buflen = ATMEL_AES_BUFFER_SIZE;
 	dd->buflen &= ~(AES_BLOCK_SIZE - 1);
 
diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 3b2a92029b16..d1010206b713 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -313,8 +313,8 @@ static int atmel_tdes_buff_init(struct atmel_tdes_dev *dd)
 {
 	int err = -ENOMEM;
 
-	dd->buf_in = (void *)__get_free_pages(GFP_KERNEL, 0);
-	dd->buf_out = (void *)__get_free_pages(GFP_KERNEL, 0);
+	dd->buf_in = __get_free_pages(GFP_KERNEL, 0);
+	dd->buf_out = __get_free_pages(GFP_KERNEL, 0);
 	dd->buflen = PAGE_SIZE;
 	dd->buflen &= ~(DES_BLOCK_SIZE - 1);
 
diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
index 5e1d80724678..7cf7fe6bb9ba 100644
--- a/drivers/crypto/ccp/tee-dev.c
+++ b/drivers/crypto/ccp/tee-dev.c
@@ -33,7 +33,7 @@ static int tee_alloc_ring(struct psp_tee_device *tee, int ring_size)
 	/* We need actual physical address instead of DMA address, since
 	 * Trusted OS running on AMD Secure Processor will map this region
 	 */
-	start_addr = (void *)__get_free_pages(GFP_KERNEL, get_order(ring_size));
+	start_addr = __get_free_pages(GFP_KERNEL, get_order(ring_size));
 	if (!start_addr)
 		return -ENOMEM;
 
diff --git a/drivers/crypto/inside-secure/eip93/eip93-common.c b/drivers/crypto/inside-secure/eip93/eip93-common.c
index 66153aa2493f..5fa9b3b208bf 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-common.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-common.c
@@ -156,7 +156,7 @@ static int eip93_make_sg_copy(struct scatterlist *src, struct scatterlist **dst,
 	if (!*dst)
 		return -ENOMEM;
 
-	pages = (void *)__get_free_pages(GFP_KERNEL | GFP_DMA,
+	pages = __get_free_pages(GFP_KERNEL | GFP_DMA,
 					 get_order(len));
 	if (!pages) {
 		kfree(*dst);
diff --git a/drivers/crypto/nx/nx-842.c b/drivers/crypto/nx/nx-842.c
index b950fcce8a9b..06e2d89a5e37 100644
--- a/drivers/crypto/nx/nx-842.c
+++ b/drivers/crypto/nx/nx-842.c
@@ -112,8 +112,8 @@ void *nx842_crypto_alloc_ctx(struct nx842_driver *driver)
 	spin_lock_init(&ctx->lock);
 	ctx->driver = driver;
 	ctx->wmem = kmalloc(driver->workmem_size, GFP_KERNEL);
-	ctx->sbounce = (u8 *)__get_free_pages(GFP_KERNEL, BOUNCE_BUFFER_ORDER);
-	ctx->dbounce = (u8 *)__get_free_pages(GFP_KERNEL, BOUNCE_BUFFER_ORDER);
+	ctx->sbounce = __get_free_pages(GFP_KERNEL, BOUNCE_BUFFER_ORDER);
+	ctx->dbounce = __get_free_pages(GFP_KERNEL, BOUNCE_BUFFER_ORDER);
 	if (!ctx->wmem || !ctx->sbounce || !ctx->dbounce) {
 		kfree(ctx->wmem);
 		free_page((unsigned long)ctx->sbounce);
diff --git a/drivers/crypto/omap-crypto.c b/drivers/crypto/omap-crypto.c
index a4cc6bf146ec..4c8816dd798a 100644
--- a/drivers/crypto/omap-crypto.c
+++ b/drivers/crypto/omap-crypto.c
@@ -62,7 +62,7 @@ static int omap_crypto_copy_sgs(int total, int bs, struct scatterlist **sg,
 	new_len = ALIGN(total, bs);
 	pages = get_order(new_len);
 
-	buf = (void *)__get_free_pages(GFP_ATOMIC, pages);
+	buf = __get_free_pages(GFP_ATOMIC, pages);
 	if (!buf) {
 		pr_err("%s: Couldn't allocate pages for unaligned cases.\n",
 		       __func__);
diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index ff8aac02994a..783da9f68a3d 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -698,7 +698,7 @@ static int omap_sham_copy_sgs(struct omap_sham_reqctx *ctx,
 
 	pages = get_order(new_len);
 
-	buf = (void *)__get_free_pages(GFP_ATOMIC, pages);
+	buf = __get_free_pages(GFP_ATOMIC, pages);
 	if (!buf) {
 		pr_err("Couldn't allocate pages for unaligned cases.\n");
 		return -ENOMEM;
diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index b829c84f60f2..bdc389ae41c8 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -504,7 +504,7 @@ static int s5p_make_sg_cpy(struct s5p_aes_dev *dev, struct scatterlist *src,
 		return -ENOMEM;
 
 	len = ALIGN(dev->req->cryptlen, AES_BLOCK_SIZE);
-	pages = (void *)__get_free_pages(GFP_ATOMIC, get_order(len));
+	pages = __get_free_pages(GFP_ATOMIC, get_order(len));
 	if (!pages) {
 		kfree(*dst);
 		*dst = NULL;
@@ -1010,7 +1010,7 @@ static int s5p_hash_copy_sgs(struct s5p_hash_reqctx *ctx,
 	len = new_len + ctx->bufcnt;
 	pages = get_order(len);
 
-	buf = (void *)__get_free_pages(GFP_ATOMIC, pages);
+	buf = __get_free_pages(GFP_ATOMIC, pages);
 	if (!buf) {
 		dev_err(ctx->dd->dev, "alloc pages for unaligned case.\n");
 		ctx->error = true;
diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index a4436728b0db..23235287058c 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -1109,7 +1109,7 @@ static int stm32_hash_copy_sgs(struct stm32_hash_request_ctx *rctx,
 
 	pages = get_order(new_len);
 
-	buf = (void *)__get_free_pages(GFP_ATOMIC, pages);
+	buf = __get_free_pages(GFP_ATOMIC, pages);
 	if (!buf) {
 		pr_err("Couldn't allocate pages for unaligned cases.\n");
 		return -ENOMEM;
diff --git a/drivers/dma/nbpfaxi.c b/drivers/dma/nbpfaxi.c
index 765462303de0..d00c7802aedf 100644
--- a/drivers/dma/nbpfaxi.c
+++ b/drivers/dma/nbpfaxi.c
@@ -689,7 +689,7 @@ static dma_cookie_t nbpf_tx_submit(struct dma_async_tx_descriptor *tx)
 static int nbpf_desc_page_alloc(struct nbpf_channel *chan)
 {
 	struct dma_chan *dchan = &chan->dma_chan;
-	struct nbpf_desc_page *dpage = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	struct nbpf_desc_page *dpage = get_zeroed_page(GFP_KERNEL | GFP_DMA);
 	struct nbpf_link_desc *ldesc;
 	struct nbpf_link_reg *hwdesc;
 	struct nbpf_desc *desc;
diff --git a/drivers/dma/sh/rcar-dmac.c b/drivers/dma/sh/rcar-dmac.c
index 0c45ce8c74aa..e4c5d2980883 100644
--- a/drivers/dma/sh/rcar-dmac.c
+++ b/drivers/dma/sh/rcar-dmac.c
@@ -534,7 +534,7 @@ static int rcar_dmac_desc_alloc(struct rcar_dmac_chan *chan, gfp_t gfp)
 	LIST_HEAD(list);
 	unsigned int i;
 
-	page = (void *)get_zeroed_page(gfp);
+	page = get_zeroed_page(gfp);
 	if (!page)
 		return -ENOMEM;
 
@@ -665,7 +665,7 @@ static int rcar_dmac_xfer_chunk_alloc(struct rcar_dmac_chan *chan, gfp_t gfp)
 	LIST_HEAD(list);
 	unsigned int i;
 
-	page = (void *)get_zeroed_page(gfp);
+	page = get_zeroed_page(gfp);
 	if (!page)
 		return -ENOMEM;
 
diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index d52e1685aed5..25b60b8b3da9 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3385,8 +3385,8 @@ static int __init d40_lcla_allocate(struct d40_base *base)
 	base->lcla_pool.pages = SZ_1K * base->num_phy_chans / PAGE_SIZE;
 
 	for (i = 0; i < MAX_LCLA_ALLOC_ATTEMPTS; i++) {
-		page_list[i] = __get_free_pages(GFP_KERNEL,
-						base->lcla_pool.pages);
+		page_list[i] = (unsigned long)__get_free_pages(GFP_KERNEL,
+							       base->lcla_pool.pages);
 		if (!page_list[i]) {
 
 			d40_err(base->dev, "Failed to allocate %d pages.\n",
diff --git a/drivers/extcon/extcon.c b/drivers/extcon/extcon.c
index e7f55c021e56..b6659e08045e 100644
--- a/drivers/extcon/extcon.c
+++ b/drivers/extcon/extcon.c
@@ -463,7 +463,7 @@ int extcon_sync(struct extcon_dev *edev, unsigned int id)
 
 	spin_lock_irqsave(&edev->lock, flags);
 	/* This could be in interrupt handler */
-	prop_buf = (char *)get_zeroed_page(GFP_ATOMIC);
+	prop_buf = get_zeroed_page(GFP_ATOMIC);
 	if (!prop_buf) {
 		/* Unlock early before uevent */
 		spin_unlock_irqrestore(&edev->lock, flags);
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 1ce428e2ac8a..e2b69af4fd50 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -1131,7 +1131,7 @@ int __ref efi_mem_reserve_persistent(phys_addr_t addr, u64 size)
 	}
 
 	/* no slot found - allocate a new linked list entry */
-	rsv = (struct linux_efi_memreserve *)__get_free_page(GFP_ATOMIC);
+	rsv = __get_free_page(GFP_ATOMIC);
 	if (!rsv)
 		return -ENOMEM;
 
diff --git a/drivers/firmware/psci/psci_checker.c b/drivers/firmware/psci/psci_checker.c
index df02a4ec3398..c5d80366c0f7 100644
--- a/drivers/firmware/psci/psci_checker.c
+++ b/drivers/firmware/psci/psci_checker.c
@@ -195,7 +195,7 @@ static int hotplug_tests(void)
 	nb_cpu_group = alloc_init_cpu_groups(&cpu_groups);
 	if (nb_cpu_group < 0)
 		goto out_free_cpus;
-	page_buf = (char *)__get_free_page(GFP_KERNEL);
+	page_buf = __get_free_page(GFP_KERNEL);
 	if (!page_buf)
 		goto out_free_cpu_groups;
 
diff --git a/drivers/fsi/fsi-occ.c b/drivers/fsi/fsi-occ.c
index d3e6bf37878a..d3ff6b55b281 100644
--- a/drivers/fsi/fsi-occ.c
+++ b/drivers/fsi/fsi-occ.c
@@ -86,7 +86,7 @@ static int occ_open(struct inode *inode, struct file *file)
 	if (!client)
 		return -ENOMEM;
 
-	client->buffer = (u8 *)__get_free_page(GFP_KERNEL);
+	client->buffer = __get_free_page(GFP_KERNEL);
 	if (!client->buffer) {
 		kfree(client);
 		return -ENOMEM;
diff --git a/drivers/fsi/fsi-sbefifo.c b/drivers/fsi/fsi-sbefifo.c
index 0a98517f3959..b06b09bfcb1e 100644
--- a/drivers/fsi/fsi-sbefifo.c
+++ b/drivers/fsi/fsi-sbefifo.c
@@ -798,7 +798,7 @@ static int sbefifo_user_open(struct inode *inode, struct file *file)
 
 	file->private_data = user;
 	user->sbefifo = sbefifo;
-	user->cmd_page = (void *)__get_free_page(GFP_KERNEL);
+	user->cmd_page = __get_free_page(GFP_KERNEL);
 	if (!user->cmd_page) {
 		kfree(user);
 		return -ENOMEM;
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_events.c b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
index 82905f3e54dd..505ac574e99d 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_events.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
@@ -71,7 +71,7 @@ static struct kfd_signal_page *allocate_signal_page(struct kfd_process *p)
 	if (!page)
 		return NULL;
 
-	backing_store = (void *) __get_free_pages(GFP_KERNEL,
+	backing_store = __get_free_pages(GFP_KERNEL,
 					get_order(KFD_SIGNAL_EVENT_LIMIT * 8));
 	if (!backing_store)
 		goto fail_alloc_signal_store;
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process.c b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
index ddfe30c13e9d..1296b7eca686 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -2137,7 +2137,7 @@ int kfd_reserved_mem_mmap(struct kfd_node *dev, struct kfd_process *process,
 		return -EINVAL;
 	qpd = &pdd->qpd;
 
-	qpd->cwsr_kaddr = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
+	qpd->cwsr_kaddr = __get_free_pages(GFP_KERNEL | __GFP_ZERO,
 					get_order(KFD_CWSR_TBA_TMA_SIZE));
 	if (!qpd->cwsr_kaddr) {
 		dev_err(dev->adev->dev,
diff --git a/drivers/gpu/drm/i915/gt/selftest_lrc.c b/drivers/gpu/drm/i915/gt/selftest_lrc.c
index 23f04f6f8fba..44cd6938537e 100644
--- a/drivers/gpu/drm/i915/gt/selftest_lrc.c
+++ b/drivers/gpu/drm/i915/gt/selftest_lrc.c
@@ -166,7 +166,7 @@ static int live_lrc_layout(void *arg)
 	 * match the layout saved by HW.
 	 */
 
-	lrc = (u32 *)__get_free_page(GFP_KERNEL); /* requires page alignment */
+	lrc = __get_free_page(GFP_KERNEL); /* requires page alignment */
 	if (!lrc)
 		return -ENOMEM;
 	GEM_BUG_ON(offset_in_page(lrc));
diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_log.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_log.c
index cdff48920ee6..0366697ded94 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_log.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_log.c
@@ -904,7 +904,7 @@ int intel_guc_log_dump(struct intel_guc_log *log, struct drm_printer *p,
 	if (!obj)
 		return 0;
 
-	page = (u32 *)__get_free_page(GFP_KERNEL);
+	page = __get_free_page(GFP_KERNEL);
 	if (!page)
 		return -ENOMEM;
 
diff --git a/drivers/gpu/drm/i915/gvt/gtt.c b/drivers/gpu/drm/i915/gvt/gtt.c
index ae9b0ded3651..838bdc642b84 100644
--- a/drivers/gpu/drm/i915/gvt/gtt.c
+++ b/drivers/gpu/drm/i915/gvt/gtt.c
@@ -2303,7 +2303,7 @@ static int alloc_scratch_pages(struct intel_vgpu *vgpu,
 			type < GTT_TYPE_PPGTT_PTE_PT || type >= GTT_TYPE_MAX))
 		return -EINVAL;
 
-	scratch_pt = (void *)get_zeroed_page(GFP_KERNEL);
+	scratch_pt = get_zeroed_page(GFP_KERNEL);
 	if (!scratch_pt) {
 		gvt_vgpu_err("fail to allocate scratch page\n");
 		return -ENOMEM;
@@ -2504,7 +2504,7 @@ static int setup_spt_oos(struct intel_gvt *gvt)
 			ret = -ENOMEM;
 			goto fail;
 		}
-		oos_page->mem = (void *)__get_free_pages(GFP_KERNEL, 0);
+		oos_page->mem = __get_free_pages(GFP_KERNEL, 0);
 		if (!oos_page->mem) {
 			ret = -ENOMEM;
 			kfree(oos_page);
@@ -2633,7 +2633,7 @@ int intel_gvt_init_gtt(struct intel_gvt *gvt)
 	gvt->gtt.pte_ops = &gen8_gtt_pte_ops;
 	gvt->gtt.gma_ops = &gen8_gtt_gma_ops;
 
-	page = (void *)get_zeroed_page(GFP_KERNEL);
+	page = get_zeroed_page(GFP_KERNEL);
 	if (!page) {
 		gvt_err("fail to allocate scratch ggtt page\n");
 		return -ENOMEM;
diff --git a/drivers/gpu/drm/i915/gvt/opregion.c b/drivers/gpu/drm/i915/gvt/opregion.c
index dbad4d853d3a..5ec9d6d7e4a2 100644
--- a/drivers/gpu/drm/i915/gvt/opregion.c
+++ b/drivers/gpu/drm/i915/gvt/opregion.c
@@ -224,7 +224,7 @@ int intel_vgpu_init_opregion(struct intel_vgpu *vgpu)
 	struct vbt v;
 
 	gvt_dbg_core("init vgpu%d opregion\n", vgpu->id);
-	vgpu_opregion(vgpu)->va = (void *)__get_free_pages(GFP_KERNEL |
+	vgpu_opregion(vgpu)->va = __get_free_pages(GFP_KERNEL |
 			__GFP_ZERO,
 			get_order(INTEL_GVT_OPREGION_SIZE));
 	if (!vgpu_opregion(vgpu)->va) {
diff --git a/drivers/gpu/drm/tegra/drm.c b/drivers/gpu/drm/tegra/drm.c
index 4596073fe28f..c346572a479d 100644
--- a/drivers/gpu/drm/tegra/drm.c
+++ b/drivers/gpu/drm/tegra/drm.c
@@ -1031,7 +1031,7 @@ void *tegra_drm_alloc(struct tegra_drm *tegra, size_t size, dma_addr_t *dma)
 		gfp |= GFP_DMA;
 	}
 
-	virt = (void *)__get_free_pages(gfp, get_order(size));
+	virt = __get_free_pages(gfp, get_order(size));
 	if (!virt)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/drivers/hsi/clients/cmt_speech.c b/drivers/hsi/clients/cmt_speech.c
index daa8e1bff5d9..ed7f80d1dd41 100644
--- a/drivers/hsi/clients/cmt_speech.c
+++ b/drivers/hsi/clients/cmt_speech.c
@@ -1286,7 +1286,7 @@ static int cs_char_open(struct inode *unused, struct file *file)
 	cs_char_data.dataind_pending = 0;
 	spin_unlock_bh(&cs_char_data.lock);
 
-	p = get_zeroed_page(GFP_KERNEL);
+	p = (unsigned long)get_zeroed_page(GFP_KERNEL);
 	if (!p) {
 		ret = -ENOMEM;
 		goto out2;
diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 1fe3573ae52a..54cc6e08566b 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -219,7 +219,7 @@ int vmbus_connect(void)
 	 * abstraction stuff
 	 */
 	vmbus_connection.int_page =
-		(void *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
+		__get_free_page(GFP_KERNEL | __GFP_ZERO);
 	if (vmbus_connection.int_page == NULL) {
 		ret = -ENOMEM;
 		goto cleanup;
@@ -234,8 +234,8 @@ int vmbus_connect(void)
 	 * Setup the monitor notification facility. The 1st page for
 	 * parent->child and the 2nd page for child->parent
 	 */
-	vmbus_connection.monitor_pages[0] = (void *)__get_free_page(GFP_KERNEL);
-	vmbus_connection.monitor_pages[1] = (void *)__get_free_page(GFP_KERNEL);
+	vmbus_connection.monitor_pages[0] = __get_free_page(GFP_KERNEL);
+	vmbus_connection.monitor_pages[1] = __get_free_page(GFP_KERNEL);
 	if ((vmbus_connection.monitor_pages[0] == NULL) ||
 	    (vmbus_connection.monitor_pages[1] == NULL)) {
 		ret = -ENOMEM;
diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
index b14c5f9e0ef2..7e8bc36609cd 100644
--- a/drivers/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -125,7 +125,7 @@ int hv_synic_alloc(void)
 			     vmbus_on_msg_dpc, (unsigned long)hv_cpu);
 
 		if (ms_hyperv.paravisor_present && hv_isolation_type_tdx()) {
-			hv_cpu->post_msg_page = (void *)get_zeroed_page(GFP_ATOMIC);
+			hv_cpu->post_msg_page = get_zeroed_page(GFP_ATOMIC);
 			if (!hv_cpu->post_msg_page) {
 				pr_err("Unable to allocate post msg page\n");
 				goto err;
@@ -148,14 +148,14 @@ int hv_synic_alloc(void)
 		 */
 		if (!ms_hyperv.paravisor_present && !hv_root_partition()) {
 			hv_cpu->synic_message_page =
-				(void *)get_zeroed_page(GFP_ATOMIC);
+				get_zeroed_page(GFP_ATOMIC);
 			if (!hv_cpu->synic_message_page) {
 				pr_err("Unable to allocate SYNIC message page\n");
 				goto err;
 			}
 
 			hv_cpu->synic_event_page =
-				(void *)get_zeroed_page(GFP_ATOMIC);
+				get_zeroed_page(GFP_ATOMIC);
 			if (!hv_cpu->synic_event_page) {
 				pr_err("Unable to allocate SYNIC event page\n");
 
diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index c5b686394760..2627f3867dbd 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -198,7 +198,7 @@ struct ib_umem *ib_umem_get(struct ib_device *device, unsigned long addr,
 	umem->owning_mm = mm = current->mm;
 	mmgrab(mm);
 
-	page_list = (struct page **) __get_free_page(GFP_KERNEL);
+	page_list = __get_free_page(GFP_KERNEL);
 	if (!page_list) {
 		ret = -ENOMEM;
 		goto umem_kfree;
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 4dab5ca7362b..301ddcb3d573 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1941,7 +1941,7 @@ int bnxt_re_create_srq(struct ib_srq *ib_srq,
 		resp.srqid = srq->qplib_srq.id;
 		if (rdev->chip_ctx->modes.toggle_bits & BNXT_QPLIB_SRQ_TOGGLE_BIT) {
 			hash_add(rdev->srq_hash, &srq->hash_entry, srq->qplib_srq.id);
-			srq->uctx_srq_page = (void *)get_zeroed_page(GFP_KERNEL);
+			srq->uctx_srq_page = get_zeroed_page(GFP_KERNEL);
 			if (!srq->uctx_srq_page) {
 				rc = -ENOMEM;
 				goto fail;
@@ -3210,7 +3210,7 @@ int bnxt_re_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 		if (cctx->modes.toggle_bits & BNXT_QPLIB_CQ_TOGGLE_BIT) {
 			hash_add(rdev->cq_hash, &cq->hash_entry, cq->qplib_cq.id);
 			/* Allocate a page */
-			cq->uctx_cq_page = (void *)get_zeroed_page(GFP_KERNEL);
+			cq->uctx_cq_page = get_zeroed_page(GFP_KERNEL);
 			if (!cq->uctx_cq_page) {
 				rc = -ENOMEM;
 				goto c2fail;
@@ -4358,7 +4358,7 @@ int bnxt_re_alloc_ucontext(struct ib_ucontext *ctx, struct ib_udata *udata)
 
 	uctx->rdev = rdev;
 
-	uctx->shpg = (void *)__get_free_page(GFP_KERNEL);
+	uctx->shpg = __get_free_page(GFP_KERNEL);
 	if (!uctx->shpg) {
 		rc = -ENOMEM;
 		goto fail;
diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index b13810572c2e..e0b42f6d9049 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -862,7 +862,7 @@ void bnxt_re_pacing_alert(struct bnxt_re_dev *rdev)
 static int bnxt_re_initialize_dbr_pacing(struct bnxt_re_dev *rdev)
 {
 	/* Allocate a page for app use */
-	rdev->pacing.dbr_page = (void *)__get_free_page(GFP_KERNEL);
+	rdev->pacing.dbr_page = __get_free_page(GFP_KERNEL);
 	if (!rdev->pacing.dbr_page)
 		return -ENOMEM;
 
diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index d892f55febe2..47dbe3e02100 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -868,7 +868,7 @@ static int c4iw_rdev_open(struct c4iw_rdev *rdev)
 		pr_err("error %d initializing ocqp pool\n", err);
 		goto destroy_rqtpool;
 	}
-	rdev->status_page = (struct t4_dev_status_page *)
+	rdev->status_page =
 			    __get_free_page(GFP_KERNEL);
 	if (!rdev->status_page) {
 		err = -ENOMEM;
diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index dcdfe250bdbe..941d4e0867b7 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -541,7 +541,7 @@ struct ib_mr *c4iw_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	if (err)
 		goto err_umem_release;
 
-	pages = (__be64 *) __get_free_page(GFP_KERNEL);
+	pages = __get_free_page(GFP_KERNEL);
 	if (!pages) {
 		err = -ENOMEM;
 		goto err_pbl_free;
diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
index 94464f1694d9..96ce8fe551d9 100644
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -303,7 +303,7 @@ mlx4_alloc_priv_pages(struct ib_device *device,
 				    MLX4_MR_PAGES_ALIGN);
 
 	/* Prevent cross page boundary allocation. */
-	mr->pages = (__be64 *)get_zeroed_page(GFP_KERNEL);
+	mr->pages = get_zeroed_page(GFP_KERNEL);
 	if (!mr->pages)
 		return -ENOMEM;
 
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index fc1e86f6c409..61ee1e451cb8 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -5117,7 +5117,7 @@ static int __init mlx5_ib_init(void)
 {
 	int ret;
 
-	xlt_emergency_page = (void *)__get_free_page(GFP_KERNEL);
+	xlt_emergency_page = __get_free_page(GFP_KERNEL);
 	if (!xlt_emergency_page)
 		return -ENOMEM;
 
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 0e8ae85af5a6..45818cfe1e38 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -1403,7 +1403,7 @@ static void mlx5_ib_mr_wqe_pfault_handler(struct mlx5_ib_dev *dev,
 		goto resolve_page_fault;
 	}
 
-	wqe_start = (void *)__get_free_page(GFP_KERNEL);
+	wqe_start = __get_free_page(GFP_KERNEL);
 	if (!wqe_start) {
 		mlx5_ib_err(dev, "Error allocating memory for IO page fault handling.\n");
 		goto resolve_page_fault;
diff --git a/drivers/infiniband/hw/mlx5/umr.c b/drivers/infiniband/hw/mlx5/umr.c
index 4e562e0dd9e1..012f2e246757 100644
--- a/drivers/infiniband/hw/mlx5/umr.c
+++ b/drivers/infiniband/hw/mlx5/umr.c
@@ -516,7 +516,7 @@ static void *mlx5r_umr_alloc_xlt(size_t *nents, size_t ent_size, gfp_t gfp_mask)
 	size = min_t(size_t, ent_size * ALIGN(*nents, xlt_chunk_align),
 		     MLX5_MAX_UMR_CHUNK);
 	*nents = size / ent_size;
-	res = (void *)__get_free_pages(gfp_mask | __GFP_NOWARN,
+	res = __get_free_pages(gfp_mask | __GFP_NOWARN,
 				       get_order(size));
 	if (res)
 		return res;
@@ -524,14 +524,14 @@ static void *mlx5r_umr_alloc_xlt(size_t *nents, size_t ent_size, gfp_t gfp_mask)
 	if (size > MLX5_SPARE_UMR_CHUNK) {
 		size = MLX5_SPARE_UMR_CHUNK;
 		*nents = size / ent_size;
-		res = (void *)__get_free_pages(gfp_mask | __GFP_NOWARN,
+		res = __get_free_pages(gfp_mask | __GFP_NOWARN,
 					       get_order(size));
 		if (res)
 			return res;
 	}
 
 	*nents = PAGE_SIZE / ent_size;
-	res = (void *)__get_free_page(gfp_mask);
+	res = __get_free_page(gfp_mask);
 	if (res)
 		return res;
 
diff --git a/drivers/infiniband/hw/mthca/mthca_allocator.c b/drivers/infiniband/hw/mthca/mthca_allocator.c
index 9f0f79d02d3c..168571fb44fe 100644
--- a/drivers/infiniband/hw/mthca/mthca_allocator.c
+++ b/drivers/infiniband/hw/mthca/mthca_allocator.c
@@ -126,7 +126,7 @@ int mthca_array_set(struct mthca_array *array, int index, void *value)
 
 	/* Allocate with GFP_ATOMIC because we'll be called with locks held. */
 	if (!array->page_list[p].page)
-		array->page_list[p].page = (void **) get_zeroed_page(GFP_ATOMIC);
+		array->page_list[p].page = get_zeroed_page(GFP_ATOMIC);
 
 	if (!array->page_list[p].page)
 		return -ENOMEM;
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index dd572d76866c..05158af473e3 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -871,7 +871,7 @@ static struct ib_mr *mthca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 		goto err_umem;
 	}
 
-	pages = (u64 *) __get_free_page(GFP_KERNEL);
+	pages = __get_free_page(GFP_KERNEL);
 	if (!pages) {
 		err = -ENOMEM;
 		goto err_mtt;
diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index ab9bf0922979..35eb942fc8aa 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -755,7 +755,7 @@ static int qedr_init_user_db_rec(struct ib_udata *udata,
 		return 0;
 
 	/* Allocate a page for doorbell recovery, add to mmap */
-	q->db_rec_data = (void *)get_zeroed_page(GFP_USER);
+	q->db_rec_data = get_zeroed_page(GFP_USER);
 	if (!q->db_rec_data) {
 		DP_ERR(dev, "get_zeroed_page failed\n");
 		return -ENOMEM;
diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.c b/drivers/infiniband/hw/usnic/usnic_uiom.c
index 3fbf99757b11..20bd02120a0c 100644
--- a/drivers/infiniband/hw/usnic/usnic_uiom.c
+++ b/drivers/infiniband/hw/usnic/usnic_uiom.c
@@ -114,7 +114,7 @@ static int usnic_uiom_get_pages(unsigned long addr, size_t size, int writable,
 
 	INIT_LIST_HEAD(chunk_list);
 
-	page_list = (struct page **) __get_free_page(GFP_KERNEL);
+	page_list = __get_free_page(GFP_KERNEL);
 	if (!page_list)
 		return -ENOMEM;
 
diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 134a79eecfcb..ce64dc5fa285 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -265,7 +265,7 @@ static inline bool wss_exceeds_threshold(struct rvt_wss *wss)
 static void get_map_page(struct rvt_qpn_table *qpt,
 			 struct rvt_qpn_map *map)
 {
-	unsigned long page = get_zeroed_page(GFP_KERNEL);
+	unsigned long page = (unsigned long)get_zeroed_page(GFP_KERNEL);
 
 	/*
 	 * Free the page if someone raced with us installing it.
diff --git a/drivers/input/misc/xen-kbdfront.c b/drivers/input/misc/xen-kbdfront.c
index 67f1c7364c95..3b29b7aec26f 100644
--- a/drivers/input/misc/xen-kbdfront.c
+++ b/drivers/input/misc/xen-kbdfront.c
@@ -216,7 +216,7 @@ static int xenkbd_probe(struct xenbus_device *dev,
 	info->gref = -1;
 	snprintf(info->phys, sizeof(info->phys), "xenbus/%s", dev->nodename);
 
-	info->page = (void *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
+	info->page = __get_free_page(GFP_KERNEL | __GFP_ZERO);
 	if (!info->page)
 		goto error_nomem;
 
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 2e1865daa1ce..a6a28be0374e 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1941,7 +1941,7 @@ static u64 *__get_gcr3_pte(struct gcr3_tbl_info *gcr3_info,
 			if (!alloc)
 				return NULL;
 
-			root = (void *)get_zeroed_page(GFP_ATOMIC);
+			root = get_zeroed_page(GFP_ATOMIC);
 			if (root == NULL)
 				return NULL;
 
diff --git a/drivers/iommu/io-pgtable-arm-v7s.c b/drivers/iommu/io-pgtable-arm-v7s.c
index 523355e91a2c..2de8985dae85 100644
--- a/drivers/iommu/io-pgtable-arm-v7s.c
+++ b/drivers/iommu/io-pgtable-arm-v7s.c
@@ -254,7 +254,7 @@ static void *__arm_v7s_alloc_table(int lvl, gfp_t gfp,
 		 GFP_KERNEL : ARM_V7S_TABLE_GFP_DMA;
 
 	if (lvl == 1)
-		table = (void *)__get_free_pages(gfp_l1 | __GFP_ZERO, get_order(size));
+		table = __get_free_pages(gfp_l1 | __GFP_ZERO, get_order(size));
 	else if (lvl == 2)
 		table = kmem_cache_zalloc(data->l2_tables, gfp);
 
diff --git a/drivers/iommu/iommufd/iova_bitmap.c b/drivers/iommu/iommufd/iova_bitmap.c
index 4514575818fc..a0cccd040969 100644
--- a/drivers/iommu/iommufd/iova_bitmap.c
+++ b/drivers/iommu/iommufd/iova_bitmap.c
@@ -260,7 +260,7 @@ struct iova_bitmap *iova_bitmap_alloc(unsigned long iova, size_t length,
 	bitmap->iova = iova;
 	bitmap->length = length;
 	mapped->iova = iova;
-	mapped->pages = (struct page **)__get_free_page(GFP_KERNEL);
+	mapped->pages = __get_free_page(GFP_KERNEL);
 	if (!mapped->pages) {
 		rc = -ENOMEM;
 		goto err;
diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index de178827a078..1f90fc24b7a6 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -900,7 +900,7 @@ static int mock_viommu_init(struct iommufd_viommu *viommu,
 
 		/* Allocate two pages */
 		mock_viommu->page =
-			(u32 *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 1);
+			__get_free_pages(GFP_KERNEL | __GFP_ZERO, 1);
 		if (!mock_viommu->page)
 			return -ENOMEM;
 
diff --git a/drivers/macintosh/rack-meter.c b/drivers/macintosh/rack-meter.c
index 896a43bd819f..59d3d82357a9 100644
--- a/drivers/macintosh/rack-meter.c
+++ b/drivers/macintosh/rack-meter.c
@@ -441,7 +441,7 @@ static int rackmeter_probe(struct macio_dev* mdev,
 	pr_debug("  dma @0x%08x\n", (unsigned int)rdma.start);
 	pr_debug("  irq %d\n", rm->irq);
 
-	rm->ubuf = (u8 *)__get_free_page(GFP_KERNEL);
+	rm->ubuf = __get_free_page(GFP_KERNEL);
 	if (rm->ubuf == NULL) {
 		printk(KERN_ERR
 		       "rackmeter: failed to allocate samples page !\n");
diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
index 463eb13bd0b2..3f27d2bb642b 100644
--- a/drivers/md/bcache/bset.c
+++ b/drivers/md/bcache/bset.c
@@ -322,19 +322,19 @@ int bch_btree_keys_alloc(struct btree_keys *b,
 
 	b->page_order = page_order;
 
-	t->data = (void *) __get_free_pages(__GFP_COMP|gfp, b->page_order);
+	t->data = __get_free_pages(__GFP_COMP|gfp, b->page_order);
 	if (!t->data)
 		goto err;
 
 	t->tree = bset_tree_bytes(b) < PAGE_SIZE
 		? kmalloc(bset_tree_bytes(b), gfp)
-		: (void *) __get_free_pages(gfp, get_order(bset_tree_bytes(b)));
+		: __get_free_pages(gfp, get_order(bset_tree_bytes(b)));
 	if (!t->tree)
 		goto err;
 
 	t->prev = bset_prev_bytes(b) < PAGE_SIZE
 		? kmalloc(bset_prev_bytes(b), gfp)
-		: (void *) __get_free_pages(gfp, get_order(bset_prev_bytes(b)));
+		: __get_free_pages(gfp, get_order(bset_prev_bytes(b)));
 	if (!t->prev)
 		goto err;
 
@@ -1238,7 +1238,7 @@ static void __btree_sort(struct btree_keys *b, struct btree_iter *iter,
 {
 	uint64_t start_time;
 	bool used_mempool = false;
-	struct bset *out = (void *) __get_free_pages(__GFP_NOWARN|GFP_NOWAIT,
+	struct bset *out = __get_free_pages(__GFP_NOWARN|GFP_NOWAIT,
 						     order);
 	if (!out) {
 		struct page *outp;
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 210b59007d98..099ddbe60a8f 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -804,7 +804,7 @@ int bch_btree_cache_alloc(struct cache_set *c)
 #ifdef CONFIG_BCACHE_DEBUG
 	mutex_init(&c->verify_lock);
 
-	c->verify_ondisk = (void *)
+	c->verify_ondisk =
 		__get_free_pages(GFP_KERNEL|__GFP_COMP,
 				 ilog2(meta_bucket_pages(&c->cache->sb)));
 	if (!c->verify_ondisk) {
diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index d50eb82ccb4f..28d80f0c0c08 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -992,8 +992,8 @@ int bch_journal_alloc(struct cache_set *c)
 	j->w[1].c = c;
 
 	if (!(init_fifo(&j->pin, JOURNAL_PIN, GFP_KERNEL)) ||
-	    !(j->w[0].data = (void *) __get_free_pages(GFP_KERNEL|__GFP_COMP, JSET_BITS)) ||
-	    !(j->w[1].data = (void *) __get_free_pages(GFP_KERNEL|__GFP_COMP, JSET_BITS)))
+	    !(j->w[0].data = __get_free_pages(GFP_KERNEL|__GFP_COMP, JSET_BITS)) ||
+	    !(j->w[1].data = __get_free_pages(GFP_KERNEL|__GFP_COMP, JSET_BITS)))
 		return -ENOMEM;
 
 	return 0;
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 6d250e366412..e124a47eba81 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1850,7 +1850,7 @@ void bch_cache_set_unregister(struct cache_set *c)
 }
 
 #define alloc_meta_bucket_pages(gfp, sb)		\
-	((void *) __get_free_pages(__GFP_ZERO|__GFP_COMP|gfp, ilog2(meta_bucket_pages(sb))))
+	(__get_free_pages(__GFP_ZERO|__GFP_COMP|gfp, ilog2(meta_bucket_pages(sb))))
 
 struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
 {
diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index e6d28be11c5c..96af91c7430f 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1181,8 +1181,8 @@ static void *alloc_buffer_data(struct dm_bufio_client *c, gfp_t gfp_mask,
 	if (c->block_size <= KMALLOC_MAX_SIZE &&
 	    gfp_mask & __GFP_NORETRY) {
 		*data_mode = DATA_MODE_GET_FREE_PAGES;
-		return (void *)__get_free_pages(gfp_mask,
-						c->sectors_per_block_bits - (PAGE_SHIFT - SECTOR_SHIFT));
+		return __get_free_pages(gfp_mask,
+					c->sectors_per_block_bits - (PAGE_SHIFT - SECTOR_SHIFT));
 	}
 
 	*data_mode = DATA_MODE_VMALLOC;
diff --git a/drivers/media/pci/intel/ipu6/ipu6-mmu.c b/drivers/media/pci/intel/ipu6/ipu6-mmu.c
index 6d1c0b90169d..98429b23cf36 100644
--- a/drivers/media/pci/intel/ipu6/ipu6-mmu.c
+++ b/drivers/media/pci/intel/ipu6/ipu6-mmu.c
@@ -138,7 +138,7 @@ static dma_addr_t map_single(struct ipu6_mmu_info *mmu_info, void *ptr)
 
 static int get_dummy_page(struct ipu6_mmu_info *mmu_info)
 {
-	void *pt = (void *)get_zeroed_page(GFP_ATOMIC | GFP_DMA32);
+	void *pt = get_zeroed_page(GFP_ATOMIC | GFP_DMA32);
 	dma_addr_t dma;
 
 	if (!pt)
@@ -172,7 +172,7 @@ static void free_dummy_page(struct ipu6_mmu_info *mmu_info)
 
 static int alloc_dummy_l2_pt(struct ipu6_mmu_info *mmu_info)
 {
-	u32 *pt = (u32 *)get_zeroed_page(GFP_ATOMIC | GFP_DMA32);
+	u32 *pt = get_zeroed_page(GFP_ATOMIC | GFP_DMA32);
 	dma_addr_t dma;
 	unsigned int i;
 
@@ -210,7 +210,7 @@ static void free_dummy_l2_pt(struct ipu6_mmu_info *mmu_info)
 
 static u32 *alloc_l1_pt(struct ipu6_mmu_info *mmu_info)
 {
-	u32 *pt = (u32 *)get_zeroed_page(GFP_ATOMIC | GFP_DMA32);
+	u32 *pt = get_zeroed_page(GFP_ATOMIC | GFP_DMA32);
 	dma_addr_t dma;
 	unsigned int i;
 
@@ -240,7 +240,7 @@ static u32 *alloc_l1_pt(struct ipu6_mmu_info *mmu_info)
 
 static u32 *alloc_l2_pt(struct ipu6_mmu_info *mmu_info)
 {
-	u32 *pt = (u32 *)get_zeroed_page(GFP_ATOMIC | GFP_DMA32);
+	u32 *pt = get_zeroed_page(GFP_ATOMIC | GFP_DMA32);
 	unsigned int i;
 
 	if (!pt)
diff --git a/drivers/media/pci/pt1/pt1.c b/drivers/media/pci/pt1/pt1.c
index 121a4a92ea10..1e53b2d6b3f2 100644
--- a/drivers/media/pci/pt1/pt1.c
+++ b/drivers/media/pci/pt1/pt1.c
@@ -844,7 +844,7 @@ pt1_alloc_adapter(struct pt1 *pt1)
 	adap->voltage = SEC_VOLTAGE_OFF;
 	adap->sleep = 1;
 
-	buf = (u8 *)__get_free_page(GFP_KERNEL);
+	buf = __get_free_page(GFP_KERNEL);
 	if (!buf) {
 		ret = -ENOMEM;
 		goto err_kfree;
diff --git a/drivers/media/pci/saa7134/saa7134-go7007.c b/drivers/media/pci/saa7134/saa7134-go7007.c
index bd37db5ce363..7567f2e91932 100644
--- a/drivers/media/pci/saa7134/saa7134-go7007.c
+++ b/drivers/media/pci/saa7134/saa7134-go7007.c
@@ -434,10 +434,10 @@ static int saa7134_go7007_init(struct saa7134_dev *dev)
 	strscpy(sd->name, "saa7134-go7007", sizeof(sd->name));
 
 	/* Allocate a couple pages for receiving the compressed stream */
-	saa->top = (u8 *)get_zeroed_page(GFP_KERNEL);
+	saa->top = get_zeroed_page(GFP_KERNEL);
 	if (!saa->top)
 		goto allocfail;
-	saa->bottom = (u8 *)get_zeroed_page(GFP_KERNEL);
+	saa->bottom = get_zeroed_page(GFP_KERNEL);
 	if (!saa->bottom)
 		goto allocfail;
 
diff --git a/drivers/media/pci/solo6x10/solo6x10-p2m.c b/drivers/media/pci/solo6x10/solo6x10-p2m.c
index 5f100e5e03d9..b3fa623d74b3 100644
--- a/drivers/media/pci/solo6x10/solo6x10-p2m.c
+++ b/drivers/media/pci/solo6x10/solo6x10-p2m.c
@@ -209,11 +209,11 @@ static int solo_p2m_test(struct solo_dev *solo_dev, int base, int size)
 	int ret = -EIO;
 	int order = get_order(size);
 
-	wr_buf = (u32 *)__get_free_pages(GFP_KERNEL, order);
+	wr_buf = __get_free_pages(GFP_KERNEL, order);
 	if (wr_buf == NULL)
 		return -1;
 
-	rd_buf = (u32 *)__get_free_pages(GFP_KERNEL, order);
+	rd_buf = __get_free_pages(GFP_KERNEL, order);
 	if (rd_buf == NULL) {
 		free_pages((unsigned long)wr_buf, order);
 		return -1;
diff --git a/drivers/media/platform/ti/omap/omap_voutlib.c b/drivers/media/platform/ti/omap/omap_voutlib.c
index 0ac46458e41c..8c60f00ecef7 100644
--- a/drivers/media/platform/ti/omap/omap_voutlib.c
+++ b/drivers/media/platform/ti/omap/omap_voutlib.c
@@ -309,7 +309,7 @@ unsigned long omap_vout_alloc_buffer(u32 buf_size, u32 *phys_addr)
 
 	size = PAGE_ALIGN(buf_size);
 	order = get_order(size);
-	virt_addr = __get_free_pages(GFP_KERNEL, order);
+	virt_addr = (unsigned long)__get_free_pages(GFP_KERNEL, order);
 	addr = virt_addr;
 
 	if (virt_addr) {
diff --git a/drivers/misc/ibmvmc.c b/drivers/misc/ibmvmc.c
index e5f935b5249d..adee4f06f61b 100644
--- a/drivers/misc/ibmvmc.c
+++ b/drivers/misc/ibmvmc.c
@@ -2117,7 +2117,7 @@ static int ibmvmc_init_crq_queue(struct crq_server_adapter *adapter)
 	int rc = 0;
 	int retrc = 0;
 
-	queue->msgs = (struct ibmvmc_crq_msg *)get_zeroed_page(GFP_KERNEL);
+	queue->msgs = get_zeroed_page(GFP_KERNEL);
 
 	if (!queue->msgs)
 		goto malloc_failed;
diff --git a/drivers/misc/lkdtm/core.c b/drivers/misc/lkdtm/core.c
index 5732fd59a227..ae0a1c6c393a 100644
--- a/drivers/misc/lkdtm/core.c
+++ b/drivers/misc/lkdtm/core.c
@@ -236,7 +236,7 @@ static ssize_t lkdtm_debugfs_entry(struct file *f,
 	if (count >= PAGE_SIZE)
 		return -EINVAL;
 
-	buf = (char *)__get_free_page(GFP_KERNEL);
+	buf = __get_free_page(GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 	if (copy_from_user(buf, user_buf, count)) {
@@ -271,7 +271,7 @@ static ssize_t lkdtm_debugfs_read(struct file *f, char __user *user_buf,
 	ssize_t out;
 	char *buf;
 
-	buf = (char *)__get_free_page(GFP_KERNEL);
+	buf = __get_free_page(GFP_KERNEL);
 	if (buf == NULL)
 		return -ENOMEM;
 
@@ -313,7 +313,7 @@ static ssize_t direct_entry(struct file *f, const char __user *user_buf,
 	if (count < 1)
 		return -EINVAL;
 
-	buf = (char *)__get_free_page(GFP_KERNEL);
+	buf = __get_free_page(GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 	if (copy_from_user(buf, user_buf, count)) {
diff --git a/drivers/misc/lkdtm/heap.c b/drivers/misc/lkdtm/heap.c
index c1a05b935894..14c1503d21e8 100644
--- a/drivers/misc/lkdtm/heap.c
+++ b/drivers/misc/lkdtm/heap.c
@@ -193,7 +193,7 @@ static void lkdtm_KFENCE_READ_AFTER_FREE(void)
 
 static void lkdtm_WRITE_BUDDY_AFTER_FREE(void)
 {
-	unsigned long p = __get_free_page(GFP_KERNEL);
+	unsigned long p = (unsigned long)__get_free_page(GFP_KERNEL);
 	if (!p) {
 		pr_info("Unable to allocate free page\n");
 		return;
@@ -206,14 +206,14 @@ static void lkdtm_WRITE_BUDDY_AFTER_FREE(void)
 	pr_info("Attempting bad write to the buddy page after free\n");
 	memset((void *)p, 0x78, PAGE_SIZE);
 	/* Attempt to notice the overwrite. */
-	p = __get_free_page(GFP_KERNEL);
+	p = (unsigned long)__get_free_page(GFP_KERNEL);
 	free_page(p);
 	schedule();
 }
 
 static void lkdtm_READ_BUDDY_AFTER_FREE(void)
 {
-	unsigned long p = __get_free_page(GFP_KERNEL);
+	unsigned long p = (unsigned long)__get_free_page(GFP_KERNEL);
 	int saw, *val;
 	int *base;
 
@@ -285,7 +285,7 @@ static void lkdtm_BUDDY_INIT_ON_ALLOC(void)
 	u8 *first;
 	u8 *val;
 
-	first = (u8 *)__get_free_page(GFP_KERNEL);
+	first = __get_free_page(GFP_KERNEL);
 	if (!first) {
 		pr_info("Unable to allocate first free page\n");
 		return;
@@ -294,7 +294,7 @@ static void lkdtm_BUDDY_INIT_ON_ALLOC(void)
 	memset(first, 0xAB, PAGE_SIZE);
 	free_page((unsigned long)first);
 
-	val = (u8 *)__get_free_page(GFP_KERNEL);
+	val = __get_free_page(GFP_KERNEL);
 	if (!val) {
 		pr_info("Unable to allocate second free page\n");
 		return;
@@ -348,7 +348,7 @@ static void lkdtm_SLAB_FREE_CROSS(void)
 
 static void lkdtm_SLAB_FREE_PAGE(void)
 {
-	unsigned long p = __get_free_page(GFP_KERNEL);
+	unsigned long p = (unsigned long)__get_free_page(GFP_KERNEL);
 
 	pr_info("Attempting non-Slab slab free ...\n");
 	kmem_cache_free(NULL, (void *)p);
diff --git a/drivers/misc/ocxl/link.c b/drivers/misc/ocxl/link.c
index 03402203cacd..064689f1ad30 100644
--- a/drivers/misc/ocxl/link.c
+++ b/drivers/misc/ocxl/link.c
@@ -354,7 +354,7 @@ static int alloc_spa(struct pci_dev *dev, struct ocxl_link *link)
 	INIT_WORK(&spa->xsl_fault.fault_work, xsl_fault_handler_bh);
 
 	spa->spa_order = SPA_SPA_SIZE_LOG - PAGE_SHIFT;
-	spa->spa_mem = (struct ocxl_process_element *)
+	spa->spa_mem =
 		__get_free_pages(GFP_KERNEL | __GFP_ZERO, spa->spa_order);
 	if (!spa->spa_mem) {
 		dev_err(&dev->dev, "Can't allocate Shared Process Area\n");
diff --git a/drivers/mmc/host/renesas_sdhi_sys_dmac.c b/drivers/mmc/host/renesas_sdhi_sys_dmac.c
index 822a310c9bba..41d6a6370680 100644
--- a/drivers/mmc/host/renesas_sdhi_sys_dmac.c
+++ b/drivers/mmc/host/renesas_sdhi_sys_dmac.c
@@ -397,7 +397,7 @@ static void renesas_sdhi_sys_dmac_request_dma(struct tmio_mmc_host *host,
 		if (ret < 0)
 			goto ecfgrx;
 
-		host->bounce_buf = (u8 *)__get_free_page(GFP_KERNEL | GFP_DMA);
+		host->bounce_buf = __get_free_page(GFP_KERNEL | GFP_DMA);
 		if (!host->bounce_buf)
 			goto ebouncebuf;
 
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index e59530357e2c..b9c1c9c9dfc4 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -698,7 +698,7 @@ static void *bnx2x_frag_alloc(const struct bnx2x_fastpath *fp, gfp_t gfp_mask)
 	if (fp->rx_frag_size) {
 		/* GFP_KERNEL allocations are used only during initialization */
 		if (unlikely(gfpflags_allow_blocking(gfp_mask)))
-			return (void *)__get_free_page(gfp_mask);
+			return __get_free_page(gfp_mask);
 
 		return napi_alloc_frag(fp->rx_frag_size);
 	}
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index f0f05d7315ac..46989cefb12c 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -12548,7 +12548,6 @@ static int bnx2x_init_mcast_macs_list(struct bnx2x *bp,
 	netdev_for_each_mc_addr(ha, bp->dev) {
 		if (!offset) {
 			current_mcast_group =
-				(struct bnx2x_mcast_list_elem_group *)
 				__get_free_page(GFP_ATOMIC);
 			if (!current_mcast_group) {
 				bnx2x_free_mcast_macs_list(mcast_group_list);
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
index 02c8213915a5..15a80d0e2af5 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
@@ -2713,7 +2713,7 @@ static int bnx2x_mcast_enqueue_cmd(struct bnx2x *bp,
 				total_elems = BNX2X_MCAST_BINS_NUM;
 		}
 		while (total_elems > 0) {
-			elem_group = (struct bnx2x_mcast_elem_group *)
+			elem_group =
 				     __get_free_page(GFP_ATOMIC | __GFP_ZERO);
 			if (!elem_group) {
 				bnx2x_free_groups(&new_cmd->group_head);
diff --git a/drivers/net/ethernet/ibm/ehea/ehea_main.c b/drivers/net/ethernet/ibm/ehea/ehea_main.c
index 9b006bc353a1..6017d34e7026 100644
--- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
@@ -353,7 +353,7 @@ static void ehea_update_stats(struct work_struct *work)
 	struct hcp_ehea_port_cb2 *cb2;
 	u64 hret;
 
-	cb2 = (void *)get_zeroed_page(GFP_KERNEL);
+	cb2 = get_zeroed_page(GFP_KERNEL);
 	if (!cb2) {
 		netdev_err(dev, "No mem for cb2. Some interface statistics were not updated\n");
 		goto resched;
@@ -977,7 +977,7 @@ int ehea_sense_port_attr(struct ehea_port *port)
 	struct hcp_ehea_port_cb0 *cb0;
 
 	/* may be called via ehea_neq_tasklet() */
-	cb0 = (void *)get_zeroed_page(GFP_ATOMIC);
+	cb0 = get_zeroed_page(GFP_ATOMIC);
 	if (!cb0) {
 		pr_err("no mem for cb0\n");
 		ret = -ENOMEM;
@@ -1062,7 +1062,7 @@ int ehea_set_portspeed(struct ehea_port *port, u32 port_speed)
 	u64 hret;
 	int ret = 0;
 
-	cb4 = (void *)get_zeroed_page(GFP_KERNEL);
+	cb4 = get_zeroed_page(GFP_KERNEL);
 	if (!cb4) {
 		pr_err("no mem for cb4\n");
 		ret = -ENOMEM;
@@ -1350,7 +1350,7 @@ static int ehea_configure_port(struct ehea_port *port)
 	struct hcp_ehea_port_cb0 *cb0;
 
 	ret = -ENOMEM;
-	cb0 = (void *)get_zeroed_page(GFP_KERNEL);
+	cb0 = get_zeroed_page(GFP_KERNEL);
 	if (!cb0)
 		goto out;
 
@@ -1725,7 +1725,7 @@ static int ehea_set_mac_addr(struct net_device *dev, void *sa)
 		goto out;
 	}
 
-	cb0 = (void *)get_zeroed_page(GFP_KERNEL);
+	cb0 = get_zeroed_page(GFP_KERNEL);
 	if (!cb0) {
 		pr_err("no mem for cb0\n");
 		ret = -ENOMEM;
@@ -1791,7 +1791,7 @@ static void ehea_promiscuous(struct net_device *dev, int enable)
 	if (enable == port->promisc)
 		return;
 
-	cb7 = (void *)get_zeroed_page(GFP_ATOMIC);
+	cb7 = get_zeroed_page(GFP_ATOMIC);
 	if (!cb7) {
 		pr_err("no mem for cb7\n");
 		goto out;
@@ -2095,7 +2095,7 @@ static int ehea_vlan_rx_add_vid(struct net_device *dev, __be16 proto, u16 vid)
 	u64 hret;
 	int err = 0;
 
-	cb1 = (void *)get_zeroed_page(GFP_KERNEL);
+	cb1 = get_zeroed_page(GFP_KERNEL);
 	if (!cb1) {
 		pr_err("no mem for cb1\n");
 		err = -ENOMEM;
@@ -2133,7 +2133,7 @@ static int ehea_vlan_rx_kill_vid(struct net_device *dev, __be16 proto, u16 vid)
 	u64 hret;
 	int err = 0;
 
-	cb1 = (void *)get_zeroed_page(GFP_KERNEL);
+	cb1 = get_zeroed_page(GFP_KERNEL);
 	if (!cb1) {
 		pr_err("no mem for cb1\n");
 		err = -ENOMEM;
@@ -2170,7 +2170,7 @@ static int ehea_activate_qp(struct ehea_adapter *adapter, struct ehea_qp *qp)
 	u64 dummy64 = 0;
 	struct hcp_modify_qp_cb0 *cb0;
 
-	cb0 = (void *)get_zeroed_page(GFP_KERNEL);
+	cb0 = get_zeroed_page(GFP_KERNEL);
 	if (!cb0) {
 		ret = -ENOMEM;
 		goto out;
@@ -2518,7 +2518,7 @@ static int ehea_stop_qps(struct net_device *dev)
 	u64 dummy64 = 0;
 	u16 dummy16 = 0;
 
-	cb0 = (void *)get_zeroed_page(GFP_KERNEL);
+	cb0 = get_zeroed_page(GFP_KERNEL);
 	if (!cb0) {
 		ret = -ENOMEM;
 		goto out;
@@ -2620,7 +2620,7 @@ static int ehea_restart_qps(struct net_device *dev)
 	u64 dummy64 = 0;
 	u16 dummy16 = 0;
 
-	cb0 = (void *)get_zeroed_page(GFP_KERNEL);
+	cb0 = get_zeroed_page(GFP_KERNEL);
 	if (!cb0)
 		return -ENOMEM;
 
@@ -2806,7 +2806,7 @@ static int ehea_sense_adapter_attr(struct ehea_adapter *adapter)
 	u64 hret;
 	int ret;
 
-	cb = (void *)get_zeroed_page(GFP_KERNEL);
+	cb = get_zeroed_page(GFP_KERNEL);
 	if (!cb) {
 		ret = -ENOMEM;
 		goto out;
@@ -2837,7 +2837,7 @@ static int ehea_get_jumboframe_status(struct ehea_port *port, int *jumbo)
 	*jumbo = 0;
 
 	/* (Try to) enable *jumbo frames */
-	cb4 = (void *)get_zeroed_page(GFP_KERNEL);
+	cb4 = get_zeroed_page(GFP_KERNEL);
 	if (!cb4) {
 		pr_err("no mem for cb4\n");
 		ret = -ENOMEM;
diff --git a/drivers/net/ethernet/ibm/ehea/ehea_qmr.c b/drivers/net/ethernet/ibm/ehea/ehea_qmr.c
index db45373ea31c..a42969b71098 100644
--- a/drivers/net/ethernet/ibm/ehea/ehea_qmr.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_qmr.c
@@ -62,7 +62,7 @@ static int hw_queue_ctor(struct hw_queue *queue, const u32 nr_of_pages,
 	 */
 	i = 0;
 	while (i < nr_of_pages) {
-		u8 *kpage = (u8 *)get_zeroed_page(GFP_KERNEL);
+		u8 *kpage = get_zeroed_page(GFP_KERNEL);
 		if (!kpage)
 			goto out_nomem;
 		for (k = 0; k < pages_per_kpage && i < nr_of_pages; k++) {
@@ -863,7 +863,7 @@ int ehea_reg_kernel_mr(struct ehea_adapter *adapter, struct ehea_mr *mr)
 
 	unsigned long top;
 
-	pt = (void *)get_zeroed_page(GFP_KERNEL);
+	pt = get_zeroed_page(GFP_KERNEL);
 	if (!pt) {
 		pr_err("no mem\n");
 		ret = -ENOMEM;
@@ -975,7 +975,7 @@ u64 ehea_error_data(struct ehea_adapter *adapter, u64 res_handle,
 	u64 *rblock;
 	u64 type = 0;
 
-	rblock = (void *)get_zeroed_page(GFP_KERNEL);
+	rblock = get_zeroed_page(GFP_KERNEL);
 	if (!rblock) {
 		pr_err("Cannot allocate rblock memory\n");
 		goto out;
diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 6f0821f1e798..4e308daa7d80 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -629,13 +629,13 @@ static int ibmveth_open(struct net_device *netdev)
 		rxq_entries += adapter->rx_buff_pool[i].size;
 
 	rc = -ENOMEM;
-	adapter->buffer_list_addr = (void*) get_zeroed_page(GFP_KERNEL);
+	adapter->buffer_list_addr = get_zeroed_page(GFP_KERNEL);
 	if (!adapter->buffer_list_addr) {
 		netdev_err(netdev, "unable to allocate list pages\n");
 		goto out;
 	}
 
-	adapter->filter_list_addr = (void*) get_zeroed_page(GFP_KERNEL);
+	adapter->filter_list_addr = get_zeroed_page(GFP_KERNEL);
 	if (!adapter->filter_list_addr) {
 		netdev_err(netdev, "unable to allocate filter pages\n");
 		goto out_free_buffer_list;
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 3808148c1fc7..13447530abe1 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4060,7 +4060,7 @@ static struct ibmvnic_sub_crq_queue *init_sub_crq_queue(struct ibmvnic_adapter
 		return NULL;
 
 	scrq->msgs =
-		(union sub_crq *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 2);
+		__get_free_pages(GFP_KERNEL | __GFP_ZERO, 2);
 	if (!scrq->msgs) {
 		dev_warn(dev, "Couldn't allocate crq queue messages page\n");
 		goto zero_page_failed;
@@ -6278,7 +6278,7 @@ static int init_crq_queue(struct ibmvnic_adapter *adapter)
 	if (crq->msgs)
 		return 0;
 
-	crq->msgs = (union ibmvnic_crq *)get_zeroed_page(GFP_KERNEL);
+	crq->msgs = get_zeroed_page(GFP_KERNEL);
 	/* Should we allocate more than one page? */
 
 	if (!crq->msgs)
diff --git a/drivers/net/ethernet/intel/ice/ice_gnss.c b/drivers/net/ethernet/intel/ice/ice_gnss.c
index 6b26290452d4..f7184bf93a22 100644
--- a/drivers/net/ethernet/intel/ice/ice_gnss.c
+++ b/drivers/net/ethernet/intel/ice/ice_gnss.c
@@ -124,7 +124,7 @@ static void ice_gnss_read(struct kthread_work *work)
 
 	data_len = min_t(typeof(data_len), data_len, PAGE_SIZE);
 
-	buf = (char *)get_zeroed_page(GFP_KERNEL);
+	buf = get_zeroed_page(GFP_KERNEL);
 	if (!buf) {
 		err = -ENOMEM;
 		goto requeue;
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index e68997a29191..30239907f15a 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1262,8 +1262,8 @@ static void *mtk_max_lro_buf_alloc(gfp_t gfp_mask)
 	unsigned int size = mtk_max_frag_size(MTK_MAX_LRO_RX_LENGTH);
 	unsigned long data;
 
-	data = __get_free_pages(gfp_mask | __GFP_COMP | __GFP_NOWARN,
-				get_order(size));
+	data = (unsigned long)__get_free_pages(gfp_mask | __GFP_COMP | __GFP_NOWARN,
+					       get_order(size));
 
 	return (void *)data;
 }
diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
index 3dbb113b792c..c228b275d811 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -544,7 +544,7 @@ mtk_wed_amsdu_buffer_alloc(struct mtk_wed_device *dev)
 		void *ptr;
 
 		/* each segment is 64K */
-		ptr = (void *)__get_free_pages(GFP_KERNEL | __GFP_NOWARN |
+		ptr = __get_free_pages(GFP_KERNEL | __GFP_NOWARN |
 					       __GFP_ZERO | __GFP_COMP |
 					       GFP_DMA32,
 					       get_order(MTK_WED_AMSDU_BUF_SIZE));
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index 080e7eab52c7..c21f8b76586b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -134,7 +134,7 @@ static int mlx5_fw_tracer_create_log_buf(struct mlx5_fw_tracer *tracer)
 	tracer->buff.size = TRACE_BUFFER_SIZE_BYTE;
 
 	gfp = GFP_KERNEL | __GFP_ZERO;
-	buff = (void *)__get_free_pages(gfp,
+	buff = __get_free_pages(gfp,
 					get_order(tracer->buff.size));
 	if (!buff) {
 		err = -ENOMEM;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index d0ba83d77cd1..d49e0dd724d1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -1266,7 +1266,7 @@ static void mlx5_init_clock_info(struct mlx5_core_dev *mdev)
 	struct mlx5_ib_clock_info *info;
 	struct mlx5_timer *timer;
 
-	mdev->clock_info = (struct mlx5_ib_clock_info *)get_zeroed_page(GFP_KERNEL);
+	mdev->clock_info = get_zeroed_page(GFP_KERNEL);
 	if (!mdev->clock_info) {
 		mlx5_core_warn(mdev, "Failed to allocate IB clock info page\n");
 		return;
diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_fw.c b/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
index c87cb9ed09e7..51f73a384777 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
@@ -205,7 +205,7 @@ static int fbnic_mbx_alloc_rx_msgs(struct fbnic_dev *fbd)
 	while (!err && count--) {
 		struct fbnic_tlv_msg *msg;
 
-		msg = (struct fbnic_tlv_msg *)__get_free_page(GFP_ATOMIC |
+		msg = __get_free_page(GFP_ATOMIC |
 							      __GFP_NOWARN);
 		if (!msg) {
 			err = -ENOMEM;
diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_tlv.c b/drivers/net/ethernet/meta/fbnic/fbnic_tlv.c
index 517ed8b2f1cb..6ee9700ffb3c 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_tlv.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_tlv.c
@@ -24,7 +24,7 @@ struct fbnic_tlv_msg *fbnic_tlv_msg_alloc(u16 msg_id)
 	struct fbnic_tlv_hdr hdr = { 0 };
 	struct fbnic_tlv_msg *msg;
 
-	msg = (struct fbnic_tlv_msg *)__get_free_page(GFP_KERNEL);
+	msg = __get_free_page(GFP_KERNEL);
 	if (!msg)
 		return NULL;
 
diff --git a/drivers/net/ethernet/sfc/mcdi.c b/drivers/net/ethernet/sfc/mcdi.c
index 5e9b8def5e42..37da9fd51e9b 100644
--- a/drivers/net/ethernet/sfc/mcdi.c
+++ b/drivers/net/ethernet/sfc/mcdi.c
@@ -71,7 +71,7 @@ int efx_mcdi_init(struct efx_nic *efx)
 	mcdi->efx = efx;
 #ifdef CONFIG_SFC_MCDI_LOGGING
 	/* consuming code assumes buffer is page-sized */
-	mcdi->logging_buffer = (char *)__get_free_page(GFP_KERNEL);
+	mcdi->logging_buffer = __get_free_page(GFP_KERNEL);
 	if (!mcdi->logging_buffer)
 		goto fail1;
 	mcdi->logging_enabled = mcdi_logging_default;
diff --git a/drivers/net/ethernet/sfc/siena/mcdi.c b/drivers/net/ethernet/sfc/siena/mcdi.c
index c8f0fb43e285..520d9d759d29 100644
--- a/drivers/net/ethernet/sfc/siena/mcdi.c
+++ b/drivers/net/ethernet/sfc/siena/mcdi.c
@@ -73,7 +73,7 @@ int efx_siena_mcdi_init(struct efx_nic *efx)
 	mcdi->efx = efx;
 #ifdef CONFIG_SFC_SIENA_MCDI_LOGGING
 	/* consuming code assumes buffer is page-sized */
-	mcdi->logging_buffer = (char *)__get_free_page(GFP_KERNEL);
+	mcdi->logging_buffer = __get_free_page(GFP_KERNEL);
 	if (!mcdi->logging_buffer)
 		goto fail1;
 	mcdi->logging_enabled = efx_siena_mcdi_logging_default;
diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index 893216b0e08d..e128ff1d41bd 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -9998,7 +9998,7 @@ static void *niu_phys_alloc_coherent(struct device *dev, size_t size,
 				     u64 *dma_addr, gfp_t flag)
 {
 	unsigned long order = get_order(size);
-	unsigned long page = __get_free_pages(flag, order);
+	unsigned long page = (unsigned long)__get_free_pages(flag, order);
 
 	if (page == 0UL)
 		return NULL;
diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_wireless.c b/drivers/net/ethernet/toshiba/ps3_gelic_wireless.c
index 4fbe4b7cd12a..0ebdf6d90786 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_wireless.c
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_wireless.c
@@ -1397,7 +1397,7 @@ static struct iw_statistics *gelic_wl_get_wireless_stats(
 
 	pr_debug("%s: <-\n", __func__);
 
-	buf = (void *)__get_free_page(GFP_KERNEL);
+	buf = __get_free_page(GFP_KERNEL);
 	if (!buf)
 		return NULL;
 
@@ -1457,7 +1457,7 @@ static int gelic_wl_start_scan(struct gelic_wl_info *wl, int always_scan,
 
 	/* ESSID scan ? */
 	if (essid_len && essid) {
-		buf = (void *)__get_free_page(GFP_KERNEL);
+		buf = __get_free_page(GFP_KERNEL);
 		if (!buf) {
 			ret = -ENOMEM;
 			goto out;
@@ -1508,7 +1508,7 @@ static void gelic_wl_scan_complete_event(struct gelic_wl_info *wl)
 	pr_debug("%s:start\n", __func__);
 	mutex_lock(&wl->scan_lock);
 
-	buf = (void *)__get_free_page(GFP_KERNEL);
+	buf = __get_free_page(GFP_KERNEL);
 	if (!buf) {
 		pr_info("%s: scan buffer alloc failed\n", __func__);
 		goto out;
@@ -1749,7 +1749,7 @@ static int gelic_wl_do_wep_setup(struct gelic_wl_info *wl)
 
 	pr_debug("%s: <-\n", __func__);
 	/* we can assume no one should uses the buffer */
-	wep = (struct gelic_eurus_wep_cfg *)__get_free_page(GFP_KERNEL);
+	wep = __get_free_page(GFP_KERNEL);
 	if (!wep)
 		return -ENOMEM;
 
@@ -1839,7 +1839,7 @@ static int gelic_wl_do_wpa_setup(struct gelic_wl_info *wl)
 
 	pr_debug("%s: <-\n", __func__);
 	/* we can assume no one should uses the buffer */
-	wpa = (struct gelic_eurus_wpa_cfg *)__get_free_page(GFP_KERNEL);
+	wpa = __get_free_page(GFP_KERNEL);
 	if (!wpa)
 		return -ENOMEM;
 
@@ -1920,7 +1920,7 @@ static int gelic_wl_associate_bss(struct gelic_wl_info *wl,
 	pr_debug("%s: <-\n", __func__);
 
 	/* do common config */
-	common = (struct gelic_eurus_common_cfg *)__get_free_page(GFP_KERNEL);
+	common = __get_free_page(GFP_KERNEL);
 	if (!common)
 		return -ENOMEM;
 
diff --git a/drivers/net/rionet.c b/drivers/net/rionet.c
index 318a0ef1af50..526999cdbdd7 100644
--- a/drivers/net/rionet.c
+++ b/drivers/net/rionet.c
@@ -487,7 +487,7 @@ static int rionet_setup_netdev(struct rio_mport *mport, struct net_device *ndev)
 	const size_t rionet_active_bytes = sizeof(void *) *
 				RIO_MAX_ROUTE_ENTRIES(mport->sys_size);
 
-	nets[mport->id].active = (struct rio_dev **)__get_free_pages(GFP_KERNEL,
+	nets[mport->id].active = __get_free_pages(GFP_KERNEL,
 						get_order(rionet_active_bytes));
 	if (!nets[mport->id].active) {
 		rc = -ENOMEM;
diff --git a/drivers/net/usb/kaweth.c b/drivers/net/usb/kaweth.c
index c9efb7df892e..1830b7b48e57 100644
--- a/drivers/net/usb/kaweth.c
+++ b/drivers/net/usb/kaweth.c
@@ -924,7 +924,7 @@ static int kaweth_probe(
 	} else {
 		/* Download the firmware */
 		dev_info(dev, "Downloading firmware...\n");
-		kaweth->firmware_buf = (__u8 *)__get_free_page(GFP_KERNEL);
+		kaweth->firmware_buf = __get_free_page(GFP_KERNEL);
 		if (!kaweth->firmware_buf) {
 			rv = -ENOMEM;
 			goto err_free_netdev;
diff --git a/drivers/net/wireless/broadcom/b43/debugfs.c b/drivers/net/wireless/broadcom/b43/debugfs.c
index 5a49970afc8c..aa02860e2169 100644
--- a/drivers/net/wireless/broadcom/b43/debugfs.c
+++ b/drivers/net/wireless/broadcom/b43/debugfs.c
@@ -518,7 +518,7 @@ static ssize_t b43_debugfs_read(struct file *file, char __user *userbuf,
 	dfile = fops_to_dfs_file(dev, dfops);
 
 	if (!dfile->buffer) {
-		buf = (char *)__get_free_pages(GFP_KERNEL, buforder);
+		buf = __get_free_pages(GFP_KERNEL, buforder);
 		if (!buf) {
 			err = -ENOMEM;
 			goto out_unlock;
@@ -577,7 +577,7 @@ static ssize_t b43_debugfs_write(struct file *file,
 		goto out_unlock;
 	}
 
-	buf = (char *)get_zeroed_page(GFP_KERNEL);
+	buf = get_zeroed_page(GFP_KERNEL);
 	if (!buf) {
 		err = -ENOMEM;
 		goto out_unlock;
diff --git a/drivers/net/wireless/broadcom/b43legacy/debugfs.c b/drivers/net/wireless/broadcom/b43legacy/debugfs.c
index 5d04bcc216e5..c540c798bc53 100644
--- a/drivers/net/wireless/broadcom/b43legacy/debugfs.c
+++ b/drivers/net/wireless/broadcom/b43legacy/debugfs.c
@@ -215,7 +215,7 @@ static ssize_t b43legacy_debugfs_read(struct file *file, char __user *userbuf,
 	dfile = fops_to_dfs_file(dev, dfops);
 
 	if (!dfile->buffer) {
-		buf = (char *)__get_free_pages(GFP_KERNEL, buforder);
+		buf = __get_free_pages(GFP_KERNEL, buforder);
 		if (!buf) {
 			err = -ENOMEM;
 			goto out_unlock;
@@ -279,7 +279,7 @@ static ssize_t b43legacy_debugfs_write(struct file *file,
 		goto out_unlock;
 	}
 
-	buf = (char *)get_zeroed_page(GFP_KERNEL);
+	buf = get_zeroed_page(GFP_KERNEL);
 	if (!buf) {
 		err = -ENOMEM;
 		goto out_unlock;
diff --git a/drivers/net/wireless/marvell/libertas/debugfs.c b/drivers/net/wireless/marvell/libertas/debugfs.c
index c604613ab506..310ccf2b2720 100644
--- a/drivers/net/wireless/marvell/libertas/debugfs.c
+++ b/drivers/net/wireless/marvell/libertas/debugfs.c
@@ -35,7 +35,7 @@ static ssize_t lbs_dev_info(struct file *file, char __user *userbuf,
 {
 	struct lbs_private *priv = file->private_data;
 	size_t pos = 0;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
+	unsigned long addr = (unsigned long)get_zeroed_page(GFP_KERNEL);
 	char *buf = (char *)addr;
 	ssize_t res;
 	if (!buf)
@@ -96,7 +96,7 @@ static ssize_t lbs_sleepparams_read(struct file *file, char __user *userbuf,
 	ssize_t ret;
 	size_t pos = 0;
 	struct sleep_params sp;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
+	unsigned long addr = (unsigned long)get_zeroed_page(GFP_KERNEL);
 	char *buf = (char *)addr;
 	if (!buf)
 		return -ENOMEM;
@@ -165,7 +165,7 @@ static ssize_t lbs_host_sleep_read(struct file *file, char __user *userbuf,
 	struct lbs_private *priv = file->private_data;
 	ssize_t ret;
 	size_t pos = 0;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
+	unsigned long addr = (unsigned long)get_zeroed_page(GFP_KERNEL);
 	char *buf = (char *)addr;
 	if (!buf)
 		return -ENOMEM;
@@ -228,7 +228,7 @@ static ssize_t lbs_threshold_read(uint16_t tlv_type, uint16_t event_mask,
 	u8 freq;
 	int events = 0;
 
-	buf = (char *)get_zeroed_page(GFP_KERNEL);
+	buf = get_zeroed_page(GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
@@ -436,7 +436,7 @@ static ssize_t lbs_rdmac_read(struct file *file, char __user *userbuf,
 	struct lbs_private *priv = file->private_data;
 	ssize_t pos = 0;
 	int ret;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
+	unsigned long addr = (unsigned long)get_zeroed_page(GFP_KERNEL);
 	char *buf = (char *)addr;
 	u32 val = 0;
 
@@ -506,7 +506,7 @@ static ssize_t lbs_rdbbp_read(struct file *file, char __user *userbuf,
 	struct lbs_private *priv = file->private_data;
 	ssize_t pos = 0;
 	int ret;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
+	unsigned long addr = (unsigned long)get_zeroed_page(GFP_KERNEL);
 	char *buf = (char *)addr;
 	u32 val;
 
@@ -578,7 +578,7 @@ static ssize_t lbs_rdrf_read(struct file *file, char __user *userbuf,
 	struct lbs_private *priv = file->private_data;
 	ssize_t pos = 0;
 	int ret;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
+	unsigned long addr = (unsigned long)get_zeroed_page(GFP_KERNEL);
 	char *buf = (char *)addr;
 	u32 val;
 
@@ -812,7 +812,7 @@ static ssize_t lbs_debugfs_read(struct file *file, char __user *userbuf,
 	char *p;
 	int i;
 	struct debug_data *d;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
+	unsigned long addr = (unsigned long)get_zeroed_page(GFP_KERNEL);
 	char *buf = (char *)addr;
 	if (!buf)
 		return -ENOMEM;
diff --git a/drivers/net/wireless/marvell/mwifiex/debugfs.c b/drivers/net/wireless/marvell/mwifiex/debugfs.c
index 9deaf59dcb62..1d00259c430f 100644
--- a/drivers/net/wireless/marvell/mwifiex/debugfs.c
+++ b/drivers/net/wireless/marvell/mwifiex/debugfs.c
@@ -67,7 +67,7 @@ mwifiex_info_read(struct file *file, char __user *ubuf,
 	struct net_device *netdev = priv->netdev;
 	struct netdev_hw_addr *ha;
 	struct netdev_queue *txq;
-	unsigned long page = get_zeroed_page(GFP_KERNEL);
+	unsigned long page = (unsigned long)get_zeroed_page(GFP_KERNEL);
 	char *p = (char *) page, fmt[64];
 	struct mwifiex_bss_info info;
 	ssize_t ret;
@@ -168,7 +168,7 @@ mwifiex_getlog_read(struct file *file, char __user *ubuf,
 {
 	struct mwifiex_private *priv =
 		(struct mwifiex_private *) file->private_data;
-	unsigned long page = get_zeroed_page(GFP_KERNEL);
+	unsigned long page = (unsigned long)get_zeroed_page(GFP_KERNEL);
 	char *p = (char *) page;
 	ssize_t ret;
 	struct mwifiex_ds_get_stats stats;
@@ -247,7 +247,7 @@ mwifiex_histogram_read(struct file *file, char __user *ubuf,
 	ssize_t ret;
 	struct mwifiex_histogram_data *phist_data;
 	int i, value;
-	unsigned long page = get_zeroed_page(GFP_KERNEL);
+	unsigned long page = (unsigned long)get_zeroed_page(GFP_KERNEL);
 	char *p = (char *)page;
 
 	if (!p)
@@ -383,7 +383,7 @@ mwifiex_debug_read(struct file *file, char __user *ubuf,
 {
 	struct mwifiex_private *priv =
 		(struct mwifiex_private *) file->private_data;
-	unsigned long page = get_zeroed_page(GFP_KERNEL);
+	unsigned long page = (unsigned long)get_zeroed_page(GFP_KERNEL);
 	char *p = (char *) page;
 	ssize_t ret;
 
@@ -457,7 +457,7 @@ mwifiex_regrdwr_read(struct file *file, char __user *ubuf,
 {
 	struct mwifiex_private *priv =
 		(struct mwifiex_private *) file->private_data;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
+	unsigned long addr = (unsigned long)get_zeroed_page(GFP_KERNEL);
 	char *buf = (char *) addr;
 	int pos = 0, ret = 0;
 	u32 reg_value;
@@ -511,7 +511,7 @@ mwifiex_debug_mask_read(struct file *file, char __user *ubuf,
 {
 	struct mwifiex_private *priv =
 		(struct mwifiex_private *)file->private_data;
-	unsigned long page = get_zeroed_page(GFP_KERNEL);
+	unsigned long page = (unsigned long)get_zeroed_page(GFP_KERNEL);
 	char *buf = (char *)page;
 	size_t ret = 0;
 	int pos = 0;
@@ -652,7 +652,7 @@ mwifiex_memrw_read(struct file *file, char __user *ubuf,
 		   size_t count, loff_t *ppos)
 {
 	struct mwifiex_private *priv = (void *)file->private_data;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
+	unsigned long addr = (unsigned long)get_zeroed_page(GFP_KERNEL);
 	char *buf = (char *)addr;
 	int ret, pos = 0;
 
@@ -719,7 +719,7 @@ mwifiex_rdeeprom_read(struct file *file, char __user *ubuf,
 {
 	struct mwifiex_private *priv =
 		(struct mwifiex_private *) file->private_data;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
+	unsigned long addr = (unsigned long)get_zeroed_page(GFP_KERNEL);
 	char *buf = (char *) addr;
 	int pos, ret, i;
 	u8 value[MAX_EEPROM_DATA];
@@ -820,7 +820,7 @@ mwifiex_hscfg_read(struct file *file, char __user *ubuf,
 		   size_t count, loff_t *ppos)
 {
 	struct mwifiex_private *priv = (void *)file->private_data;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
+	unsigned long addr = (unsigned long)get_zeroed_page(GFP_KERNEL);
 	char *buf = (char *)addr;
 	int pos, ret;
 	struct mwifiex_ds_hs_cfg hscfg;
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 6116a8522d96..dfe2643da625 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -6459,7 +6459,7 @@ struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size, u32 aggr_buf_size,
 	init_completion(&wl->nvs_loading_complete);
 
 	order = get_order(aggr_buf_size);
-	wl->aggr_buf = (u8 *)__get_free_pages(GFP_KERNEL, order);
+	wl->aggr_buf = __get_free_pages(GFP_KERNEL, order);
 	if (!wl->aggr_buf) {
 		ret = -ENOMEM;
 		goto err_wq;
@@ -6473,7 +6473,7 @@ struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size, u32 aggr_buf_size,
 	}
 
 	/* Allocate one page for the FW log */
-	wl->fwlog = (u8 *)get_zeroed_page(GFP_KERNEL);
+	wl->fwlog = get_zeroed_page(GFP_KERNEL);
 	if (!wl->fwlog) {
 		ret = -ENOMEM;
 		goto err_dummy_packet;
diff --git a/drivers/parisc/ccio-dma.c b/drivers/parisc/ccio-dma.c
index feef537257d0..e39f0054b67c 100644
--- a/drivers/parisc/ccio-dma.c
+++ b/drivers/parisc/ccio-dma.c
@@ -849,7 +849,7 @@ ccio_alloc(struct device *dev, size_t size, dma_addr_t *dma_handle, gfp_t flag,
 		return 0;
 	}
 #endif
-	ret = (void *) __get_free_pages(flag, get_order(size));
+	ret = __get_free_pages(flag, get_order(size));
 
 	if (ret) {
 		memset(ret, 0, size);
@@ -1283,7 +1283,7 @@ ccio_ioc_init(struct ioc *ioc)
 			iova_space_size>>20,
 			iov_order + PAGE_SHIFT);
 
-	ioc->pdir_base = (__le64 *)__get_free_pages(GFP_KERNEL,
+	ioc->pdir_base = __get_free_pages(GFP_KERNEL,
 						 get_order(ioc->pdir_size));
 	if(NULL == ioc->pdir_base) {
 		panic("%s() could not allocate I/O Page Table\n", __func__);
@@ -1297,7 +1297,7 @@ ccio_ioc_init(struct ioc *ioc)
 	ioc->res_size = (ioc->pdir_size / sizeof(u64)) >> 3;
 	DBG_INIT("%s() res_size 0x%x\n", __func__, ioc->res_size);
 	
-	ioc->res_map = (u8 *)__get_free_pages(GFP_KERNEL, 
+	ioc->res_map = __get_free_pages(GFP_KERNEL, 
 					      get_order(ioc->res_size));
 	if(NULL == ioc->res_map) {
 		panic("%s() could not allocate resource map\n", __func__);
diff --git a/drivers/parisc/sba_iommu.c b/drivers/parisc/sba_iommu.c
index fc3863c09f83..78b924e82906 100644
--- a/drivers/parisc/sba_iommu.c
+++ b/drivers/parisc/sba_iommu.c
@@ -889,7 +889,7 @@ static void *sba_alloc(struct device *hwdev, size_t size, dma_addr_t *dma_handle
 		return NULL;
 	}
 
-        ret = (void *) __get_free_pages(gfp, get_order(size));
+        ret = __get_free_pages(gfp, get_order(size));
 
 	if (ret) {
 		memset(ret, 0, size);
@@ -1137,7 +1137,7 @@ sba_alloc_pdir(unsigned int pdir_size)
         unsigned long pdir_base;
 	unsigned long pdir_order = get_order(pdir_size);
 
-	pdir_base = __get_free_pages(GFP_KERNEL, pdir_order);
+	pdir_base = (unsigned long)__get_free_pages(GFP_KERNEL, pdir_order);
 	if (NULL == (void *) pdir_base)	{
 		panic("%s() could not allocate I/O Page Table\n",
 			__func__);
@@ -1175,7 +1175,8 @@ sba_alloc_pdir(unsigned int pdir_size)
 	if (pdir_order <= (19-12)) {
 		if (((virt_to_phys(pdir_base)+pdir_size-1) & PIRANHA_ADDR_MASK) == PIRANHA_ADDR_VAL) {
 			/* allocate a new one on 512k alignment */
-			unsigned long new_pdir = __get_free_pages(GFP_KERNEL, (19-12));
+			unsigned long new_pdir = (unsigned long)__get_free_pages(GFP_KERNEL,
+										 (19 - 12));
 			/* release original */
 			free_pages(pdir_base, pdir_order);
 
@@ -1194,7 +1195,8 @@ sba_alloc_pdir(unsigned int pdir_size)
 		** 1MB or 2MB Pdir
 		** Needs to be aligned on an "odd" 1MB boundary.
 		*/
-		unsigned long new_pdir = __get_free_pages(GFP_KERNEL, pdir_order+1); /* 2 or 4MB */
+		unsigned long new_pdir = (unsigned long)__get_free_pages(GFP_KERNEL,
+									 pdir_order + 1); /* 2 or 4MB */
 
 		/* release original */
 		free_pages( pdir_base, pdir_order);
@@ -1302,7 +1304,7 @@ sba_ioc_init_pluto(struct parisc_device *sba, struct ioc *ioc, int ioc_num)
 		__func__, ioc->ioc_hpa, iova_space_size >> 20,
 		iov_order + PAGE_SHIFT);
 
-	ioc->pdir_base = (void *) __get_free_pages(GFP_KERNEL,
+	ioc->pdir_base = __get_free_pages(GFP_KERNEL,
 						   get_order(ioc->pdir_size));
 	if (!ioc->pdir_base)
 		panic("Couldn't allocate I/O Page Table\n");
@@ -1716,7 +1718,7 @@ sba_common_init(struct sba_device *sba_dev)
 			__func__, res_size);
 
 		sba_dev->ioc[i].res_size = res_size;
-		sba_dev->ioc[i].res_map = (char *) __get_free_pages(GFP_KERNEL, get_order(res_size));
+		sba_dev->ioc[i].res_map = __get_free_pages(GFP_KERNEL, get_order(res_size));
 
 #ifdef DEBUG_DMB_TRAP
 		iterate_pages( sba_dev->ioc[i].res_map, res_size,
diff --git a/drivers/platform/goldfish/goldfish_pipe.c b/drivers/platform/goldfish/goldfish_pipe.c
index abc31971fe6a..52674f4e70af 100644
--- a/drivers/platform/goldfish/goldfish_pipe.c
+++ b/drivers/platform/goldfish/goldfish_pipe.c
@@ -714,7 +714,7 @@ static int goldfish_pipe_open(struct inode *inode, struct file *file)
 	 */
 	BUILD_BUG_ON(sizeof(struct goldfish_pipe_command) > PAGE_SIZE);
 	pipe->command_buffer =
-		(struct goldfish_pipe_command *)__get_free_page(GFP_KERNEL);
+		__get_free_page(GFP_KERNEL);
 	if (!pipe->command_buffer) {
 		status = -ENOMEM;
 		goto err_pipe;
@@ -840,7 +840,7 @@ static int goldfish_pipe_device_init(struct platform_device *pdev,
 	 * is to just allocate a page and place the buffers in it.
 	 */
 	BUILD_BUG_ON(sizeof(struct goldfish_pipe_dev_buffers) > PAGE_SIZE);
-	dev->buffers = (struct goldfish_pipe_dev_buffers *)
+	dev->buffers =
 		__get_free_page(GFP_KERNEL);
 	if (!dev->buffers) {
 		kfree(dev->pipes);
diff --git a/drivers/platform/x86/dell/dell_rbu.c b/drivers/platform/x86/dell/dell_rbu.c
index 403df9bd9522..c37d7adfec58 100644
--- a/drivers/platform/x86/dell/dell_rbu.c
+++ b/drivers/platform/x86/dell/dell_rbu.c
@@ -145,7 +145,7 @@ static int create_packet(void *data, size_t length) __must_hold(&rbu_data.lock)
 	}
 
 	while (!packet_data_temp_buf) {
-		packet_data_temp_buf = (unsigned char *)
+		packet_data_temp_buf =
 			__get_free_pages(GFP_KERNEL, ordernum);
 		if (!packet_data_temp_buf) {
 			pr_warn("failed to allocate new packet\n");
@@ -405,7 +405,7 @@ static int img_update_realloc(unsigned long size)
 
 	ordernum = get_order(size);
 	image_update_buffer =
-		(unsigned char *)__get_free_pages(GFP_DMA32, ordernum);
+		__get_free_pages(GFP_DMA32, ordernum);
 	spin_lock(&rbu_data.lock);
 	if (!image_update_buffer) {
 		pr_debug("Not enough memory for image update: size = %ld\n", size);
diff --git a/drivers/power/supply/power_supply_sysfs.c b/drivers/power/supply/power_supply_sysfs.c
index 198405f7126f..301ec33e8806 100644
--- a/drivers/power/supply/power_supply_sysfs.c
+++ b/drivers/power/supply/power_supply_sysfs.c
@@ -578,7 +578,7 @@ int power_supply_uevent(const struct device *dev, struct kobj_uevent_env *env)
 	if (psy->removing)
 		return 0;
 
-	prop_buf = (char *)get_zeroed_page(GFP_KERNEL);
+	prop_buf = get_zeroed_page(GFP_KERNEL);
 	if (!prop_buf)
 		return -ENOMEM;
 
diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 794ec6e71990..2015399f03fd 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -4079,7 +4079,7 @@ ptp_ocp_summary_show(struct seq_file *s, void *data)
 	bool on, map;
 	int i;
 
-	buf = (char *)__get_free_page(GFP_KERNEL);
+	buf = __get_free_page(GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
diff --git a/drivers/ras/cec.c b/drivers/ras/cec.c
index e440b15fbabc..3487df2387b8 100644
--- a/drivers/ras/cec.c
+++ b/drivers/ras/cec.c
@@ -570,7 +570,7 @@ static int __init cec_init(void)
 	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL)
 		action_threshold = 2;
 
-	ce_arr.array = (void *)get_zeroed_page(GFP_KERNEL);
+	ce_arr.array = get_zeroed_page(GFP_KERNEL);
 	if (!ce_arr.array) {
 		pr_err("Error allocating CE array page!\n");
 		return -ENOMEM;
diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index 7765e40f7cea..7fac01a9ccc8 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -91,20 +91,20 @@ struct dasd_device *dasd_alloc_device(void)
 		return ERR_PTR(-ENOMEM);
 
 	/* Get two pages for normal block device operations. */
-	device->ccw_mem = (void *) __get_free_pages(GFP_ATOMIC | GFP_DMA, 1);
+	device->ccw_mem = __get_free_pages(GFP_ATOMIC | GFP_DMA, 1);
 	if (!device->ccw_mem) {
 		kfree(device);
 		return ERR_PTR(-ENOMEM);
 	}
 	/* Get one page for error recovery. */
-	device->erp_mem = (void *) get_zeroed_page(GFP_ATOMIC | GFP_DMA);
+	device->erp_mem = get_zeroed_page(GFP_ATOMIC | GFP_DMA);
 	if (!device->erp_mem) {
 		free_pages((unsigned long) device->ccw_mem, 1);
 		kfree(device);
 		return ERR_PTR(-ENOMEM);
 	}
 	/* Get two pages for ese format. */
-	device->ese_mem = (void *)__get_free_pages(GFP_ATOMIC | GFP_DMA, 1);
+	device->ese_mem = __get_free_pages(GFP_ATOMIC | GFP_DMA, 1);
 	if (!device->ese_mem) {
 		free_page((unsigned long) device->erp_mem);
 		free_pages((unsigned long) device->ccw_mem, 1);
diff --git a/drivers/s390/block/dasd_diag.c b/drivers/s390/block/dasd_diag.c
index 56f1af8a7ddd..67031a6d9342 100644
--- a/drivers/s390/block/dasd_diag.c
+++ b/drivers/s390/block/dasd_diag.c
@@ -388,7 +388,7 @@ dasd_diag_check_device(struct dasd_device *device)
 	mdsk_term_io(device);
 
 	/* figure out blocksize of device */
-	label = (struct vtoc_cms_label *) get_zeroed_page(GFP_KERNEL);
+	label = get_zeroed_page(GFP_KERNEL);
 	if (label == NULL)  {
 		DBF_DEV_EVENT(DBF_WARNING, device, "%s",
 			    "No memory to allocate initialization request");
diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index 88fa17aea2ec..8f7ef03ae444 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -5580,7 +5580,7 @@ static void dasd_eckd_dump_sense_ccw(struct dasd_device *device,
 
 	dev = &device->cdev->dev;
 
-	page = (char *) get_zeroed_page(GFP_ATOMIC);
+	page = get_zeroed_page(GFP_ATOMIC);
 	if (page == NULL) {
 		DBF_DEV_EVENT(DBF_WARNING, device, "%s",
 			      "No memory to dump sense data\n");
@@ -5670,7 +5670,7 @@ static void dasd_eckd_dump_sense_tcw(struct dasd_device *device,
 	struct tsb *tsb;
 	u8 *sense, *rcq;
 
-	page = (char *) get_zeroed_page(GFP_ATOMIC);
+	page = get_zeroed_page(GFP_ATOMIC);
 	if (page == NULL) {
 		DBF_DEV_EVENT(DBF_WARNING, device, " %s",
 			    "No memory to dump sense data");
@@ -6932,7 +6932,7 @@ dasd_eckd_init(void)
 		kfree(dasd_vol_info_req);
 		return -ENOMEM;
 	}
-	rawpadpage = (void *)__get_free_page(GFP_KERNEL);
+	rawpadpage = __get_free_page(GFP_KERNEL);
 	if (!rawpadpage) {
 		kfree(pe_handler_worker);
 		kfree(dasd_reserve_req);
diff --git a/drivers/s390/block/dasd_eer.c b/drivers/s390/block/dasd_eer.c
index b177b7952f2e..0d95c650a067 100644
--- a/drivers/s390/block/dasd_eer.c
+++ b/drivers/s390/block/dasd_eer.c
@@ -222,7 +222,7 @@ static int dasd_eer_allocate_buffer_pages(char **buf, int no_pages)
 	int i;
 
 	for (i = 0; i < no_pages; i++) {
-		buf[i] = (char *) get_zeroed_page(GFP_KERNEL);
+		buf[i] = get_zeroed_page(GFP_KERNEL);
 		if (!buf[i]) {
 			dasd_eer_free_buffer_pages(buf, i);
 			return -ENOMEM;
diff --git a/drivers/s390/block/dasd_fba.c b/drivers/s390/block/dasd_fba.c
index a2216795591d..65e51c71e28c 100644
--- a/drivers/s390/block/dasd_fba.c
+++ b/drivers/s390/block/dasd_fba.c
@@ -663,7 +663,7 @@ dasd_fba_dump_sense(struct dasd_device *device, struct dasd_ccw_req * req,
 
 	dev = &device->cdev->dev;
 
-	page = (char *) get_zeroed_page(GFP_ATOMIC);
+	page = get_zeroed_page(GFP_ATOMIC);
 	if (page == NULL) {
 		DBF_DEV_EVENT(DBF_WARNING, device, "%s",
 			      "No memory to dump sense data");
@@ -790,7 +790,7 @@ dasd_fba_init(void)
 
 	ASCEBC(dasd_fba_discipline.ebcname, 4);
 
-	dasd_fba_zero_page = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	dasd_fba_zero_page = get_zeroed_page(GFP_KERNEL | GFP_DMA);
 	if (!dasd_fba_zero_page)
 		return -ENOMEM;
 
diff --git a/drivers/s390/block/scm_blk.c b/drivers/s390/block/scm_blk.c
index 91bbe9d2e5ac..c103059c4417 100644
--- a/drivers/s390/block/scm_blk.c
+++ b/drivers/s390/block/scm_blk.c
@@ -74,7 +74,7 @@ static int __scm_alloc_rq(void)
 		return -ENOMEM;
 
 	scmrq = (void *) aobrq->data;
-	scmrq->aob = (void *) get_zeroed_page(GFP_DMA);
+	scmrq->aob = get_zeroed_page(GFP_DMA);
 	if (!scmrq->aob)
 		goto free;
 
diff --git a/drivers/s390/char/con3270.c b/drivers/s390/char/con3270.c
index a367f95c7c53..1a9f7d38a0e0 100644
--- a/drivers/s390/char/con3270.c
+++ b/drivers/s390/char/con3270.c
@@ -1122,7 +1122,7 @@ tty3270_create_view(int index, struct tty3270 **newtp)
 		goto out_put_view;
 	}
 
-	tp->converted_line = (void *)__get_free_page(GFP_KERNEL);
+	tp->converted_line = __get_free_page(GFP_KERNEL);
 	if (!tp->converted_line) {
 		rc = -ENOMEM;
 		goto out_free_screen;
diff --git a/drivers/s390/char/diag_ftp.c b/drivers/s390/char/diag_ftp.c
index f41b39c9d267..8867e10ebae9 100644
--- a/drivers/s390/char/diag_ftp.c
+++ b/drivers/s390/char/diag_ftp.c
@@ -153,7 +153,7 @@ ssize_t diag_ftp_cmd(const struct hmcdrv_ftp_cmdspec *ftp, size_t *fsize)
 #endif
 	init_completion(&diag_ftp_rx_complete);
 
-	ldfpl = (void *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	ldfpl = get_zeroed_page(GFP_KERNEL | GFP_DMA);
 	if (!ldfpl) {
 		len = -ENOMEM;
 		goto out;
diff --git a/drivers/s390/char/hmcdrv_cache.c b/drivers/s390/char/hmcdrv_cache.c
index 43df27ceec11..7d9033d4aa80 100644
--- a/drivers/s390/char/hmcdrv_cache.c
+++ b/drivers/s390/char/hmcdrv_cache.c
@@ -218,7 +218,7 @@ int hmcdrv_cache_startup(size_t cachesize)
 	if (cachesize > 0) { /* perform caching ? */
 		hmcdrv_cache_order = get_order(cachesize);
 		hmcdrv_cache_file.content =
-			(void *) __get_free_pages(GFP_KERNEL | GFP_DMA,
+			__get_free_pages(GFP_KERNEL | GFP_DMA,
 						  hmcdrv_cache_order);
 
 		if (!hmcdrv_cache_file.content) {
diff --git a/drivers/s390/char/hmcdrv_ftp.c b/drivers/s390/char/hmcdrv_ftp.c
index 4e3c7ec6749b..34cccd3ff88a 100644
--- a/drivers/s390/char/hmcdrv_ftp.c
+++ b/drivers/s390/char/hmcdrv_ftp.c
@@ -195,7 +195,7 @@ int hmcdrv_ftp_probe(void)
 		.len = PAGE_SIZE
 	};
 
-	ftp.buf = (void *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	ftp.buf = get_zeroed_page(GFP_KERNEL | GFP_DMA);
 
 	if (!ftp.buf)
 		return -ENOMEM;
@@ -248,7 +248,7 @@ ssize_t hmcdrv_ftp_cmd(char __kernel *cmd, loff_t offset,
 		return retlen;
 
 	order = get_order(ftp.len);
-	ftp.buf = (void *) __get_free_pages(GFP_KERNEL | GFP_DMA, order);
+	ftp.buf = __get_free_pages(GFP_KERNEL | GFP_DMA, order);
 
 	if (!ftp.buf)
 		return -ENOMEM;
diff --git a/drivers/s390/char/sclp.c b/drivers/s390/char/sclp.c
index 98e334724a62..d06cf522c848 100644
--- a/drivers/s390/char/sclp.c
+++ b/drivers/s390/char/sclp.c
@@ -1268,8 +1268,8 @@ int sclp_init(void)
 	if (sclp_init_state != sclp_init_state_uninitialized)
 		goto fail_unlock;
 	sclp_init_state = sclp_init_state_initializing;
-	sclp_read_sccb = (void *) __get_free_page(GFP_ATOMIC | GFP_DMA);
-	sclp_init_sccb = (void *) __get_free_page(GFP_ATOMIC | GFP_DMA);
+	sclp_read_sccb = __get_free_page(GFP_ATOMIC | GFP_DMA);
+	sclp_init_sccb = __get_free_page(GFP_ATOMIC | GFP_DMA);
 	BUG_ON(!sclp_read_sccb || !sclp_init_sccb);
 	/* Set up variables */
 	list_add(&sclp_state_change_event.list, &sclp_reg_list);
diff --git a/drivers/s390/char/sclp_ap.c b/drivers/s390/char/sclp_ap.c
index 0dd1ca712795..cda419e8516e 100644
--- a/drivers/s390/char/sclp_ap.c
+++ b/drivers/s390/char/sclp_ap.c
@@ -27,7 +27,7 @@ static int do_ap_configure(sclp_cmdw_t cmd, u32 apid)
 	if (!SCLP_HAS_AP_RECONFIG)
 		return -EOPNOTSUPP;
 
-	sccb = (struct ap_cfg_sccb *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	sccb = get_zeroed_page(GFP_KERNEL | GFP_DMA);
 	if (!sccb)
 		return -ENOMEM;
 
diff --git a/drivers/s390/char/sclp_cmd.c b/drivers/s390/char/sclp_cmd.c
index 3480198eac02..d9a0468e09b3 100644
--- a/drivers/s390/char/sclp_cmd.c
+++ b/drivers/s390/char/sclp_cmd.c
@@ -103,7 +103,7 @@ int _sclp_get_core_info(struct sclp_core_info *info)
 		return -EOPNOTSUPP;
 
 	length = test_facility(140) ? EXT_SCCB_READ_CPU : PAGE_SIZE;
-	sccb = (void *)__get_free_pages(GFP_KERNEL | GFP_DMA | __GFP_ZERO, get_order(length));
+	sccb = __get_free_pages(GFP_KERNEL | GFP_DMA | __GFP_ZERO, get_order(length));
 	if (!sccb)
 		return -ENOMEM;
 	sccb->header.length = length;
@@ -174,7 +174,7 @@ static int do_chp_configure(sclp_cmdw_t cmd)
 
 	if (!SCLP_HAS_CHP_RECONFIG)
 		return -EOPNOTSUPP;
-	sccb = (struct chp_cfg_sccb *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	sccb = get_zeroed_page(GFP_KERNEL | GFP_DMA);
 	if (!sccb)
 		return -ENOMEM;
 	sccb->header.length = sizeof(*sccb);
@@ -237,7 +237,7 @@ int sclp_chp_read_info(struct sclp_chp_info *info)
 
 	if (!SCLP_HAS_CHP_INFO)
 		return -EOPNOTSUPP;
-	sccb = (struct chp_info_sccb *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	sccb = get_zeroed_page(GFP_KERNEL | GFP_DMA);
 	if (!sccb)
 		return -ENOMEM;
 	sccb->header.length = sizeof(*sccb);
diff --git a/drivers/s390/char/sclp_con.c b/drivers/s390/char/sclp_con.c
index d8544c485808..5c801c4d7269 100644
--- a/drivers/s390/char/sclp_con.c
+++ b/drivers/s390/char/sclp_con.c
@@ -294,7 +294,7 @@ sclp_console_init(void)
 		return rc;
 	/* Allocate pages for output buffering */
 	for (i = 0; i < sclp_console_pages; i++) {
-		page = (void *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
+		page = get_zeroed_page(GFP_KERNEL | GFP_DMA);
 		if (!page) {
 			__sclp_console_free_pages();
 			return -ENOMEM;
diff --git a/drivers/s390/char/sclp_config.c b/drivers/s390/char/sclp_config.c
index 356d26a09af0..f15e78982672 100644
--- a/drivers/s390/char/sclp_config.c
+++ b/drivers/s390/char/sclp_config.c
@@ -97,7 +97,7 @@ static int sclp_ofb_send_req(char *ev_data, size_t len)
 
 	if (len > OFB_DATA_MAX)
 		return -EINVAL;
-	sccb = (struct sclp_ofb_sccb *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	sccb = get_zeroed_page(GFP_KERNEL | GFP_DMA);
 	if (!sccb)
 		return -ENOMEM;
 	/* Setup SCCB for Control-Program Identification */
diff --git a/drivers/s390/char/sclp_cpi_sys.c b/drivers/s390/char/sclp_cpi_sys.c
index d8f91aab11e8..d194f0c86c12 100644
--- a/drivers/s390/char/sclp_cpi_sys.c
+++ b/drivers/s390/char/sclp_cpi_sys.c
@@ -85,7 +85,7 @@ static struct sclp_req *cpi_prepare_req(void)
 	req = kzalloc(sizeof(struct sclp_req), GFP_KERNEL);
 	if (!req)
 		return ERR_PTR(-ENOMEM);
-	sccb = (struct cpi_sccb *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	sccb = get_zeroed_page(GFP_KERNEL | GFP_DMA);
 	if (!sccb) {
 		kfree(req);
 		return ERR_PTR(-ENOMEM);
diff --git a/drivers/s390/char/sclp_ctl.c b/drivers/s390/char/sclp_ctl.c
index dd6051602070..f208be49fbbf 100644
--- a/drivers/s390/char/sclp_ctl.c
+++ b/drivers/s390/char/sclp_ctl.c
@@ -63,7 +63,7 @@ static int sclp_ctl_ioctl_sccb(void __user *user_area)
 		return -EFAULT;
 	if (!sclp_ctl_cmdw_supported(ctl_sccb.cmdw))
 		return -EOPNOTSUPP;
-	sccb = (void *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	sccb = get_zeroed_page(GFP_KERNEL | GFP_DMA);
 	if (!sccb)
 		return -ENOMEM;
 	copied = PAGE_SIZE -
diff --git a/drivers/s390/char/sclp_ftp.c b/drivers/s390/char/sclp_ftp.c
index d27e2cbfbccb..0e3b2df04eab 100644
--- a/drivers/s390/char/sclp_ftp.c
+++ b/drivers/s390/char/sclp_ftp.c
@@ -94,7 +94,7 @@ static int sclp_ftp_et7(const struct hmcdrv_ftp_cmdspec *ftp)
 	int rc;
 
 	req = kzalloc(sizeof(*req), GFP_KERNEL);
-	sccb = (void *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	sccb = get_zeroed_page(GFP_KERNEL | GFP_DMA);
 	if (!req || !sccb) {
 		rc = -ENOMEM;
 		goto out_free;
@@ -251,7 +251,7 @@ int sclp_ftp_startup(void)
 		return rc;
 
 #ifdef DEBUG
-	info = get_zeroed_page(GFP_KERNEL);
+	info = (unsigned long)get_zeroed_page(GFP_KERNEL);
 
 	if (info != 0) {
 		struct sysinfo_2_2_2 *info222 = (struct sysinfo_2_2_2 *)info;
diff --git a/drivers/s390/char/sclp_mem.c b/drivers/s390/char/sclp_mem.c
index 27f49f5fd358..2157b4f4fce2 100644
--- a/drivers/s390/char/sclp_mem.c
+++ b/drivers/s390/char/sclp_mem.c
@@ -68,7 +68,7 @@ static int do_assign_storage(sclp_cmdw_t cmd, u16 rn)
 	struct assign_storage_sccb *sccb;
 	int rc;
 
-	sccb = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	sccb = get_zeroed_page(GFP_KERNEL | GFP_DMA);
 	if (!sccb)
 		return -ENOMEM;
 	sccb->header.length = PAGE_SIZE;
@@ -114,7 +114,7 @@ static int sclp_attach_storage(u8 id)
 	struct attach_storage_sccb *sccb;
 	int rc, i;
 
-	sccb = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	sccb = get_zeroed_page(GFP_KERNEL | GFP_DMA);
 	if (!sccb)
 		return -ENOMEM;
 	sccb->header.length = PAGE_SIZE;
@@ -347,7 +347,7 @@ static int __init sclp_detect_standby_memory(void)
 	if ((sclp.facilities & 0xe00000000000UL) != 0xe00000000000UL)
 		return 0;
 	rc = -ENOMEM;
-	sccb = (void *)__get_free_page(GFP_KERNEL | GFP_DMA);
+	sccb = __get_free_page(GFP_KERNEL | GFP_DMA);
 	if (!sccb)
 		goto out;
 	assigned = 0;
diff --git a/drivers/s390/char/sclp_pci.c b/drivers/s390/char/sclp_pci.c
index 56400886f7fc..2efbe0fe2390 100644
--- a/drivers/s390/char/sclp_pci.c
+++ b/drivers/s390/char/sclp_pci.c
@@ -45,7 +45,7 @@ static int do_pci_configure(sclp_cmdw_t cmd, u32 fid)
 	if (!SCLP_HAS_PCI_RECONFIG)
 		return -EOPNOTSUPP;
 
-	sccb = (struct pci_cfg_sccb *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	sccb = get_zeroed_page(GFP_KERNEL | GFP_DMA);
 	if (!sccb)
 		return -ENOMEM;
 
@@ -131,7 +131,7 @@ int sclp_pci_report(struct zpci_report_error_header *report, u32 fh, u32 fid)
 		goto out_unregister;
 	}
 
-	sccb = (void *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	sccb = get_zeroed_page(GFP_KERNEL | GFP_DMA);
 	if (!sccb) {
 		ret = -ENOMEM;
 		goto out_unregister;
diff --git a/drivers/s390/char/sclp_sd.c b/drivers/s390/char/sclp_sd.c
index 129b89fe40a3..35c963d78019 100644
--- a/drivers/s390/char/sclp_sd.c
+++ b/drivers/s390/char/sclp_sd.c
@@ -298,7 +298,7 @@ static int sclp_sd_store_data(struct sclp_sd_data *result, u8 di)
 	void *data = NULL;
 	int rc;
 
-	page = __get_free_page(GFP_KERNEL | GFP_DMA);
+	page = (unsigned long)__get_free_page(GFP_KERNEL | GFP_DMA);
 	if (!page)
 		return -ENOMEM;
 
diff --git a/drivers/s390/char/sclp_sdias.c b/drivers/s390/char/sclp_sdias.c
index e915a343fcf5..0ac7220f2be6 100644
--- a/drivers/s390/char/sclp_sdias.c
+++ b/drivers/s390/char/sclp_sdias.c
@@ -259,7 +259,7 @@ int __init sclp_sdias_init(void)
 {
 	if (!is_ipl_type_dump())
 		return 0;
-	sclp_sdias_sccb = (void *) __get_free_page(GFP_KERNEL | GFP_DMA);
+	sclp_sdias_sccb = __get_free_page(GFP_KERNEL | GFP_DMA);
 	BUG_ON(!sclp_sdias_sccb);
 	sdias_dbf = debug_register("dump_sdias", 4, 1, 4 * sizeof(long));
 	debug_register_view(sdias_dbf, &debug_sprintf_view);
diff --git a/drivers/s390/char/sclp_tty.c b/drivers/s390/char/sclp_tty.c
index 0a92d08830e7..fc4e20bc2b7c 100644
--- a/drivers/s390/char/sclp_tty.c
+++ b/drivers/s390/char/sclp_tty.c
@@ -525,7 +525,7 @@ sclp_tty_init(void)
 	}
 	/* Allocate pages for output buffering */
 	for (i = 0; i < MAX_KMEM_PAGES; i++) {
-		page = (void *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
+		page = get_zeroed_page(GFP_KERNEL | GFP_DMA);
 		if (page == NULL) {
 			__sclp_tty_free_pages();
 			tty_driver_kref_put(driver);
diff --git a/drivers/s390/char/sclp_vt220.c b/drivers/s390/char/sclp_vt220.c
index 62979adcb381..268beae8086d 100644
--- a/drivers/s390/char/sclp_vt220.c
+++ b/drivers/s390/char/sclp_vt220.c
@@ -695,7 +695,7 @@ static int __init __sclp_vt220_init(int num_pages)
 	/* Allocate pages for output buffering */
 	rc = -ENOMEM;
 	for (i = 0; i < num_pages; i++) {
-		page = (void *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
+		page = get_zeroed_page(GFP_KERNEL | GFP_DMA);
 		if (!page)
 			goto out;
 		list_add_tail(page, &sclp_vt220_empty);
diff --git a/drivers/s390/char/uvdevice.c b/drivers/s390/char/uvdevice.c
index 2b83fb6dc1d7..ec51367120c4 100644
--- a/drivers/s390/char/uvdevice.c
+++ b/drivers/s390/char/uvdevice.c
@@ -371,7 +371,7 @@ static int uvio_list_secrets(struct uvio_ioctl_cb *uv_ioctl)
 	    uv_ioctl->argument_len % UVIO_LIST_SECRETS_LEN != 0)
 		return -EINVAL;
 
-	zpage = (void *)get_zeroed_page(GFP_KERNEL);
+	zpage = get_zeroed_page(GFP_KERNEL);
 	if (!zpage)
 		return -ENOMEM;
 
diff --git a/drivers/s390/char/vmcp.c b/drivers/s390/char/vmcp.c
index 69899bb86b3e..afefb33e16c3 100644
--- a/drivers/s390/char/vmcp.c
+++ b/drivers/s390/char/vmcp.c
@@ -76,7 +76,7 @@ static void vmcp_response_alloc(struct vmcp_session *session)
 		session->cma_alloc = 1;
 		return;
 	}
-	session->response = (char *)__get_free_pages(GFP_KERNEL | __GFP_RETRY_MAYFAIL, order);
+	session->response = __get_free_pages(GFP_KERNEL | __GFP_RETRY_MAYFAIL, order);
 }
 
 static void vmcp_response_free(struct vmcp_session *session)
diff --git a/drivers/s390/char/vmlogrdr.c b/drivers/s390/char/vmlogrdr.c
index e284eea331d7..b8b673bdc3e6 100644
--- a/drivers/s390/char/vmlogrdr.c
+++ b/drivers/s390/char/vmlogrdr.c
@@ -827,7 +827,7 @@ static int __init vmlogrdr_init(void)
 		goto cleanup;
 
 	for (i=0; i < MAXMINOR; ++i ) {
-		sys_ser[i].buffer = (char *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
+		sys_ser[i].buffer = get_zeroed_page(GFP_KERNEL | GFP_DMA);
 		if (!sys_ser[i].buffer) {
 			rc = -ENOMEM;
 			break;
diff --git a/drivers/s390/char/vmur.c b/drivers/s390/char/vmur.c
index 0fd918769a4b..dc3f1deaf20c 100644
--- a/drivers/s390/char/vmur.c
+++ b/drivers/s390/char/vmur.c
@@ -531,7 +531,7 @@ static ssize_t diag14_read(struct file *file, char __user *ubuf, size_t count,
 		return rc;
 
 	len = min((size_t) PAGE_SIZE, count);
-	buf = (char *) __get_free_page(GFP_KERNEL | GFP_DMA);
+	buf = __get_free_page(GFP_KERNEL | GFP_DMA);
 	if (!buf)
 		return -ENOMEM;
 
@@ -623,7 +623,7 @@ static int verify_uri_device(struct urdev *urd)
 	}
 
 	/* open file on virtual reader	*/
-	buf = (char *) __get_free_page(GFP_KERNEL | GFP_DMA);
+	buf = __get_free_page(GFP_KERNEL | GFP_DMA);
 	if (!buf) {
 		rc = -ENOMEM;
 		goto fail_free_fcb;
diff --git a/drivers/s390/char/zcore.c b/drivers/s390/char/zcore.c
index 33cebb91b933..2faadd0cb62f 100644
--- a/drivers/s390/char/zcore.c
+++ b/drivers/s390/char/zcore.c
@@ -227,7 +227,7 @@ static int __init zcore_reipl_init(void)
 		return rc;
 	if (ipib_info.ipib == 0)
 		return 0;
-	zcore_ipl_block = (void *) __get_free_page(GFP_KERNEL);
+	zcore_ipl_block = __get_free_page(GFP_KERNEL);
 	if (!zcore_ipl_block)
 		return -ENOMEM;
 	if (ipib_info.ipib < sclp.hsa_size)
@@ -247,7 +247,7 @@ static int __init zcore_reipl_init(void)
 	 * to continue dump processing, considering that os_info could be
 	 * corrupted on the panicked system.
 	 */
-	os_info = (void *)__get_free_page(GFP_KERNEL);
+	os_info = __get_free_page(GFP_KERNEL);
 	if (!os_info)
 		return -ENOMEM;
 	rc = memcpy_hsa_kernel(&os_info_addr, __LC_OS_INFO, sizeof(os_info_addr));
diff --git a/drivers/s390/cio/chsc.c b/drivers/s390/cio/chsc.c
index 239c92d4ec11..c6e3efd4b4d1 100644
--- a/drivers/s390/cio/chsc.c
+++ b/drivers/s390/cio/chsc.c
@@ -932,12 +932,12 @@ static int cub_alloc(struct channel_subsystem *css)
 	int i;
 
 	for (i = 0; i < CSS_NUM_CUB_PAGES; i++) {
-		css->cub[i] = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
+		css->cub[i] = get_zeroed_page(GFP_KERNEL | GFP_DMA);
 		if (!css->cub[i])
 			return -ENOMEM;
 	}
 	for (i = 0; i < CSS_NUM_ECUB_PAGES; i++) {
-		css->ecub[i] = (void *)get_zeroed_page(GFP_KERNEL);
+		css->ecub[i] = get_zeroed_page(GFP_KERNEL);
 		if (!css->ecub[i])
 			return -ENOMEM;
 	}
@@ -1143,8 +1143,8 @@ int __init chsc_init(void)
 {
 	int ret;
 
-	sei_page = (void *)get_zeroed_page(GFP_KERNEL);
-	chsc_page = (void *)get_zeroed_page(GFP_KERNEL);
+	sei_page = get_zeroed_page(GFP_KERNEL);
+	chsc_page = get_zeroed_page(GFP_KERNEL);
 	if (!sei_page || !chsc_page) {
 		ret = -ENOMEM;
 		goto out_err;
diff --git a/drivers/s390/cio/chsc_sch.c b/drivers/s390/cio/chsc_sch.c
index 1e58ee3cc87d..d29d32c21ae6 100644
--- a/drivers/s390/cio/chsc_sch.c
+++ b/drivers/s390/cio/chsc_sch.c
@@ -293,7 +293,7 @@ static int chsc_ioctl_start(void __user *user_area)
 	if (!css_general_characteristics.dynio)
 		/* It makes no sense to try. */
 		return -EOPNOTSUPP;
-	chsc_area = (void *)get_zeroed_page(GFP_KERNEL);
+	chsc_area = get_zeroed_page(GFP_KERNEL);
 	if (!chsc_area)
 		return -ENOMEM;
 	request = kzalloc(sizeof(*request), GFP_KERNEL);
@@ -341,7 +341,7 @@ static int chsc_ioctl_on_close_set(void __user *user_area)
 		ret = -ENOMEM;
 		goto out_unlock;
 	}
-	on_close_chsc_area = (void *)get_zeroed_page(GFP_KERNEL);
+	on_close_chsc_area = get_zeroed_page(GFP_KERNEL);
 	if (!on_close_chsc_area) {
 		ret = -ENOMEM;
 		goto out_free_request;
@@ -393,7 +393,7 @@ static int chsc_ioctl_start_sync(void __user *user_area)
 	struct chsc_sync_area *chsc_area;
 	int ret, ccode;
 
-	chsc_area = (void *)get_zeroed_page(GFP_KERNEL);
+	chsc_area = get_zeroed_page(GFP_KERNEL);
 	if (!chsc_area)
 		return -ENOMEM;
 	if (copy_from_user(chsc_area, user_area, PAGE_SIZE)) {
@@ -439,7 +439,7 @@ static int chsc_ioctl_info_channel_path(void __user *user_cd)
 		u8 data[PAGE_SIZE - 20];
 	} __attribute__ ((packed)) *scpcd_area;
 
-	scpcd_area = (void *)get_zeroed_page(GFP_KERNEL);
+	scpcd_area = get_zeroed_page(GFP_KERNEL);
 	if (!scpcd_area)
 		return -ENOMEM;
 	cd = kzalloc(sizeof(*cd), GFP_KERNEL);
@@ -501,7 +501,7 @@ static int chsc_ioctl_info_cu(void __user *user_cd)
 		u8 data[PAGE_SIZE - 20];
 	} __attribute__ ((packed)) *scucd_area;
 
-	scucd_area = (void *)get_zeroed_page(GFP_KERNEL);
+	scucd_area = get_zeroed_page(GFP_KERNEL);
 	if (!scucd_area)
 		return -ENOMEM;
 	cd = kzalloc(sizeof(*cd), GFP_KERNEL);
@@ -564,7 +564,7 @@ static int chsc_ioctl_info_sch_cu(void __user *user_cud)
 		u8 data[PAGE_SIZE - 20];
 	} __attribute__ ((packed)) *sscud_area;
 
-	sscud_area = (void *)get_zeroed_page(GFP_KERNEL);
+	sscud_area = get_zeroed_page(GFP_KERNEL);
 	if (!sscud_area)
 		return -ENOMEM;
 	cud = kzalloc(sizeof(*cud), GFP_KERNEL);
@@ -626,7 +626,7 @@ static int chsc_ioctl_conf_info(void __user *user_ci)
 		u8 data[PAGE_SIZE - 20];
 	} __attribute__ ((packed)) *sci_area;
 
-	sci_area = (void *)get_zeroed_page(GFP_KERNEL);
+	sci_area = get_zeroed_page(GFP_KERNEL);
 	if (!sci_area)
 		return -ENOMEM;
 	ci = kzalloc(sizeof(*ci), GFP_KERNEL);
@@ -697,7 +697,7 @@ static int chsc_ioctl_conf_comp_list(void __user *user_ccl)
 		u32 res;
 	} __attribute__ ((packed)) *cssids_parm;
 
-	sccl_area = (void *)get_zeroed_page(GFP_KERNEL);
+	sccl_area = get_zeroed_page(GFP_KERNEL);
 	if (!sccl_area)
 		return -ENOMEM;
 	ccl = kzalloc(sizeof(*ccl), GFP_KERNEL);
@@ -757,7 +757,7 @@ static int chsc_ioctl_chpd(void __user *user_chpd)
 	int ret;
 
 	chpd = kzalloc(sizeof(*chpd), GFP_KERNEL);
-	scpd_area = (void *)get_zeroed_page(GFP_KERNEL);
+	scpd_area = get_zeroed_page(GFP_KERNEL);
 	if (!scpd_area || !chpd) {
 		ret = -ENOMEM;
 		goto out_free;
@@ -797,7 +797,7 @@ static int chsc_ioctl_dcal(void __user *user_dcal)
 		u8 data[PAGE_SIZE - 36];
 	} __attribute__ ((packed)) *sdcal_area;
 
-	sdcal_area = (void *)get_zeroed_page(GFP_KERNEL);
+	sdcal_area = get_zeroed_page(GFP_KERNEL);
 	if (!sdcal_area)
 		return -ENOMEM;
 	dcal = kzalloc(sizeof(*dcal), GFP_KERNEL);
diff --git a/drivers/s390/cio/cmf.c b/drivers/s390/cio/cmf.c
index b7048f2b036e..6cfda811c37d 100644
--- a/drivers/s390/cio/cmf.c
+++ b/drivers/s390/cio/cmf.c
@@ -502,7 +502,7 @@ static int alloc_cmb(struct ccw_device *cdev)
 		WARN_ON(!list_empty(&cmb_area.list));
 
 		spin_unlock(&cmb_area.lock);
-		mem = (void *)__get_free_pages(GFP_KERNEL, get_order(size));
+		mem = __get_free_pages(GFP_KERNEL, get_order(size));
 		spin_lock(&cmb_area.lock);
 
 		if (cmb_area.mem) {
diff --git a/drivers/s390/cio/qdio_main.c b/drivers/s390/cio/qdio_main.c
index 7dd967165025..5e8c0b743c67 100644
--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -961,7 +961,7 @@ int qdio_allocate(struct ccw_device *cdev, unsigned int no_input_qs,
 	    no_output_qs > QDIO_MAX_QUEUES_PER_IRQ)
 		return -EINVAL;
 
-	irq_ptr = (void *) get_zeroed_page(GFP_KERNEL);
+	irq_ptr = get_zeroed_page(GFP_KERNEL);
 	if (!irq_ptr)
 		return -ENOMEM;
 
@@ -986,12 +986,12 @@ int qdio_allocate(struct ccw_device *cdev, unsigned int no_input_qs,
 	 * qdio_establish. In case of low memory and swap on a zfcp disk
 	 * we may not be able to allocate memory otherwise.
 	 */
-	irq_ptr->chsc_page = get_zeroed_page(GFP_KERNEL);
+	irq_ptr->chsc_page = (unsigned long)get_zeroed_page(GFP_KERNEL);
 	if (!irq_ptr->chsc_page)
 		goto err_chsc;
 
 	/* qdr is used in ccw1.cda which is u32 */
-	irq_ptr->qdr = (struct qdr *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	irq_ptr->qdr = get_zeroed_page(GFP_KERNEL | GFP_DMA);
 	if (!irq_ptr->qdr)
 		goto err_qdr;
 
diff --git a/drivers/s390/cio/qdio_setup.c b/drivers/s390/cio/qdio_setup.c
index ea09aadaae4e..ee2f184cdc80 100644
--- a/drivers/s390/cio/qdio_setup.c
+++ b/drivers/s390/cio/qdio_setup.c
@@ -49,7 +49,7 @@ int qdio_alloc_buffers(struct qdio_buffer **buf, unsigned int count)
 	int pos;
 
 	for (pos = 0; pos < count; pos += QBUFF_PER_PAGE) {
-		buf[pos] = (void *) get_zeroed_page(GFP_KERNEL);
+		buf[pos] = get_zeroed_page(GFP_KERNEL);
 		if (!buf[pos]) {
 			qdio_free_buffers(buf, count);
 			return -ENOMEM;
@@ -109,7 +109,7 @@ static int __qdio_allocate_qs(struct qdio_q **irq_ptr_qs, int nr_queues)
 			return -ENOMEM;
 		}
 
-		q->sl_page = (void *)__get_free_page(GFP_KERNEL);
+		q->sl_page = __get_free_page(GFP_KERNEL);
 		if (!q->sl_page) {
 			kmem_cache_free(qdio_q_cache, q);
 			__qdio_free_queues(irq_ptr_qs, i);
@@ -249,7 +249,7 @@ int qdio_setup_get_ssqd(struct qdio_irq *irq_ptr,
 
 	DBF_EVENT("getssqd:%4x", schid->sch_no);
 	if (!irq_ptr) {
-		ssqd = (struct chsc_ssqd_area *)__get_free_page(GFP_KERNEL);
+		ssqd = __get_free_page(GFP_KERNEL);
 		if (!ssqd)
 			return -ENOMEM;
 	} else {
diff --git a/drivers/s390/cio/scm.c b/drivers/s390/cio/scm.c
index 9b4da237a0ed..df84fb41ec4a 100644
--- a/drivers/s390/cio/scm.c
+++ b/drivers/s390/cio/scm.c
@@ -229,7 +229,7 @@ int scm_update_information(void)
 	size_t num;
 	int ret;
 
-	scm_info = (void *)__get_free_page(GFP_KERNEL);
+	scm_info = __get_free_page(GFP_KERNEL);
 	if (!scm_info)
 		return -ENOMEM;
 
diff --git a/drivers/s390/crypto/zcrypt_api.c b/drivers/s390/crypto/zcrypt_api.c
index 4e6bf1cb3475..dee1e0a22082 100644
--- a/drivers/s390/crypto/zcrypt_api.c
+++ b/drivers/s390/crypto/zcrypt_api.c
@@ -1982,7 +1982,7 @@ int zcrypt_rng_device_add(void)
 
 	mutex_lock(&zcrypt_rng_mutex);
 	if (zcrypt_rng_device_count == 0) {
-		zcrypt_rng_buffer = (u32 *)get_zeroed_page(GFP_KERNEL);
+		zcrypt_rng_buffer = get_zeroed_page(GFP_KERNEL);
 		if (!zcrypt_rng_buffer) {
 			rc = -ENOMEM;
 			goto out;
diff --git a/drivers/s390/crypto/zcrypt_msgtype6.c b/drivers/s390/crypto/zcrypt_msgtype6.c
index 9cefbb30960f..d41471bebdd5 100644
--- a/drivers/s390/crypto/zcrypt_msgtype6.c
+++ b/drivers/s390/crypto/zcrypt_msgtype6.c
@@ -965,7 +965,7 @@ static long zcrypt_msgtype6_modexpo(struct zcrypt_queue *zq,
 	struct ap_response_type *resp_type = &ap_msg->response;
 	int rc;
 
-	ap_msg->msg = (void *)get_zeroed_page(GFP_KERNEL);
+	ap_msg->msg = get_zeroed_page(GFP_KERNEL);
 	if (!ap_msg->msg)
 		return -ENOMEM;
 	ap_msg->bufsize = PAGE_SIZE;
@@ -1012,7 +1012,7 @@ static long zcrypt_msgtype6_modexpo_crt(struct zcrypt_queue *zq,
 	struct ap_response_type *resp_type = &ap_msg->response;
 	int rc;
 
-	ap_msg->msg = (void *)get_zeroed_page(GFP_KERNEL);
+	ap_msg->msg = get_zeroed_page(GFP_KERNEL);
 	if (!ap_msg->msg)
 		return -ENOMEM;
 	ap_msg->bufsize = PAGE_SIZE;
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index edc0bcd46923..422ac9ca5dca 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -3364,7 +3364,7 @@ static int qeth_query_setdiagass(struct qeth_card *card)
 
 static void qeth_get_trap_id(struct qeth_card *card, struct qeth_trap_id *tid)
 {
-	unsigned long info = get_zeroed_page(GFP_KERNEL);
+	unsigned long info = (unsigned long)get_zeroed_page(GFP_KERNEL);
 	struct sysinfo_2_2_2 *info222 = (struct sysinfo_2_2_2 *)info;
 	struct sysinfo_3_2_2 *info322 = (struct sysinfo_3_2_2 *)info;
 	struct ccw_dev_id ccwid;
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 2a3888283a94..75c38b61ffe2 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -560,7 +560,7 @@ static int qeth_l2_pnso(struct qeth_card *card, u8 oc, int cnc,
 	int i, size, elems;
 	int rc;
 
-	rr = (struct chsc_pnso_area *)get_zeroed_page(GFP_KERNEL);
+	rr = get_zeroed_page(GFP_KERNEL);
 	if (rr == NULL)
 		return -ENOMEM;
 	do {
diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
index 1d50f463afe7..b822787a6d33 100644
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -665,7 +665,7 @@ static int zfcp_fc_sg_setup_table(struct scatterlist *sg, int count)
 
 	sg_init_table(sg, count);
 	for (i = 0; i < count; i++, sg = sg_next(sg)) {
-		addr = (void *) get_zeroed_page(GFP_KERNEL);
+		addr = get_zeroed_page(GFP_KERNEL);
 		if (!addr) {
 			zfcp_fc_sg_free_table(sg, i);
 			return -ENOMEM;
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 228daffb286d..c12f611f94ea 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -5832,7 +5832,7 @@ static int ibmvfc_alloc_queue(struct ibmvfc_host *vhost,
 		return -ENOMEM;
 	}
 
-	queue->msgs.handle = (void *)get_zeroed_page(GFP_KERNEL);
+	queue->msgs.handle = get_zeroed_page(GFP_KERNEL);
 	if (!queue->msgs.handle)
 		return -ENOMEM;
 
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 3d65a498b701..d02f6ab79145 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -331,7 +331,7 @@ static int ibmvscsi_init_crq_queue(struct crq_queue *queue,
 	int retrc;
 	struct vio_dev *vdev = to_vio_dev(hostdata->dev);
 
-	queue->msgs = (struct viosrp_crq *)get_zeroed_page(GFP_KERNEL);
+	queue->msgs = get_zeroed_page(GFP_KERNEL);
 
 	if (!queue->msgs)
 		goto malloc_failed;
diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index 5a3787f27369..6159ecd0b4ae 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -3003,7 +3003,7 @@ static long ibmvscsis_create_command_q(struct scsi_info *vscsi, int num_cmds)
 	vscsi->cmd_q.size = pages;
 
 	vscsi->cmd_q.base_addr =
-		(struct viosrp_crq *)get_zeroed_page(GFP_KERNEL);
+		get_zeroed_page(GFP_KERNEL);
 	if (!vscsi->cmd_q.base_addr)
 		return -ENOMEM;
 
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 44214884deaf..6e3b56594bee 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -2893,7 +2893,7 @@ static int ipr_sdt_copy(struct ipr_ioa_cfg *ioa_cfg,
 	       (ioa_dump->hdr.len + bytes_copied) < max_dump_size) {
 		if (ioa_dump->page_offset >= PAGE_SIZE ||
 		    ioa_dump->page_offset == 0) {
-			page = (__be32 *)__get_free_page(GFP_ATOMIC);
+			page = __get_free_page(GFP_ATOMIC);
 
 			if (!page) {
 				ipr_trace;
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index c9f410c50978..e1c51bfee444 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -3210,7 +3210,7 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, int dd_size,
 	}
 	spin_unlock_bh(&session->frwd_lock);
 
-	data = (char *) __get_free_pages(GFP_KERNEL,
+	data = __get_free_pages(GFP_KERNEL,
 					 get_order(ISCSI_DEF_MAX_RECV_SEG_LEN));
 	if (!data)
 		goto login_task_data_alloc_fail;
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index a6794f49e9fa..579e0ea044f7 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1646,7 +1646,7 @@ static inline int megasas_allocate_raid_maps(struct megasas_instance *instance)
 	for (i = 0; i < 2; i++) {
 		fusion->ld_map[i] = NULL;
 
-		fusion->ld_drv_map[i] = (void *)
+		fusion->ld_drv_map[i] =
 			__get_free_pages(__GFP_ZERO | GFP_KERNEL,
 					 fusion->drv_map_pages);
 
@@ -5327,7 +5327,7 @@ megasas_alloc_fusion_context(struct megasas_instance *instance)
 	fusion->load_balance_info_pages = get_order(MAX_LOGICAL_DRIVES_EXT *
 		sizeof(struct LD_LOAD_BALANCE_INFO));
 	fusion->load_balance_info =
-		(struct LD_LOAD_BALANCE_INFO *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
+		__get_free_pages(GFP_KERNEL | __GFP_ZERO,
 		fusion->load_balance_info_pages);
 	if (!fusion->load_balance_info) {
 		fusion->load_balance_info =
diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 34ba9b137789..3576e00880d4 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -351,7 +351,8 @@ static void __m_free(m_pool_s *mp, void *ptr, int size, char *name)
 
 static m_addr_t ___mp0_getp(m_pool_s *mp)
 {
-	m_addr_t m = __get_free_pages(MEMO_GFP_FLAGS, MEMO_PAGE_ORDER);
+	m_addr_t m = (m_addr_t)__get_free_pages(MEMO_GFP_FLAGS,
+						MEMO_PAGE_ORDER);
 	if (m)
 		++mp->nump;
 	return m;
diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index b168bb2178e9..2433084f25af 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -229,13 +229,13 @@ static int __qedi_alloc_uio_rings(struct qedi_uio_dev *udev)
 		return rc;
 
 	/* Memory for control area.  */
-	udev->uctrl = (void *)get_zeroed_page(GFP_KERNEL);
+	udev->uctrl = get_zeroed_page(GFP_KERNEL);
 	if (!udev->uctrl)
 		return -ENOMEM;
 
 	/* Allocating memory for LL2 ring  */
 	udev->ll2_ring_size = QEDI_PAGE_SIZE;
-	udev->ll2_ring = (void *)get_zeroed_page(GFP_KERNEL | __GFP_COMP);
+	udev->ll2_ring = get_zeroed_page(GFP_KERNEL | __GFP_COMP);
 	if (!udev->ll2_ring) {
 		rc = -ENOMEM;
 		goto exit_alloc_ring;
@@ -244,7 +244,7 @@ static int __qedi_alloc_uio_rings(struct qedi_uio_dev *udev)
 	/* Allocating memory for Tx/Rx pkt buffer */
 	udev->ll2_buf_size = TX_RX_RING * qedi_ll2_buf_size;
 	udev->ll2_buf_size = QEDI_PAGE_ALIGN(udev->ll2_buf_size);
-	udev->ll2_buf = (void *)__get_free_pages(GFP_KERNEL | __GFP_COMP |
+	udev->ll2_buf = __get_free_pages(GFP_KERNEL | __GFP_COMP |
 						 __GFP_ZERO, 2);
 	if (!udev->ll2_buf) {
 		rc = -ENOMEM;
diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 78346b2b69c9..8a98ea647901 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -690,7 +690,7 @@ static ssize_t proc_scsi_devinfo_write(struct file *file,
 
 	if (!buf || length>PAGE_SIZE)
 		return -EINVAL;
-	if (!(buffer = (char *) __get_free_page(GFP_KERNEL)))
+	if (!(buffer = __get_free_page(GFP_KERNEL)))
 		return -ENOMEM;
 	if (copy_from_user(buffer, buf, length)) {
 		err =-EFAULT;
diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
index 41f23cd0bfb4..83dc96d65014 100644
--- a/drivers/scsi/scsi_proc.c
+++ b/drivers/scsi/scsi_proc.c
@@ -74,7 +74,7 @@ static ssize_t proc_scsi_host_write(struct file *file, const char __user *buf,
 	if (!shost->hostt->write_info)
 		return -EINVAL;
 
-	page = (char *)__get_free_page(GFP_KERNEL);
+	page = __get_free_page(GFP_KERNEL);
 	if (page) {
 		ret = -EFAULT;
 		if (copy_from_user(page, buf, count))
@@ -412,7 +412,7 @@ static ssize_t proc_scsi_write(struct file *file, const char __user *buf,
 	if (!buf || length > PAGE_SIZE)
 		return -EINVAL;
 
-	buffer = (char *)__get_free_page(GFP_KERNEL);
+	buffer = __get_free_page(GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.h b/drivers/scsi/sym53c8xx_2/sym_hipd.h
index 9231a2899064..a9d73199d433 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.h
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.h
@@ -1110,7 +1110,7 @@ sym_build_sge(struct sym_hcb *np, struct sym_tblmove *data, u64 badd, int len)
  */
 
 #define sym_get_mem_cluster()	\
-	(void *) __get_free_pages(GFP_ATOMIC, SYM_MEM_PAGE_ORDER)
+	__get_free_pages(GFP_ATOMIC, SYM_MEM_PAGE_ORDER)
 #define sym_free_mem_cluster(p)	\
 	free_pages((unsigned long)p, SYM_MEM_PAGE_ORDER)
 
diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 32242d86cf5b..8b2ed7424d6c 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -1273,7 +1273,7 @@ static int pvscsi_allocate_sg(struct pvscsi_adapter *adapter)
 	BUILD_BUG_ON(sizeof(struct pvscsi_sg_list) > SGL_SIZE);
 
 	for (i = 0; i < adapter->req_depth; ++i, ++ctx) {
-		ctx->sgl = (void *)__get_free_pages(GFP_KERNEL,
+		ctx->sgl = __get_free_pages(GFP_KERNEL,
 						    get_order(SGL_SIZE));
 		ctx->sglPA = 0;
 		BUG_ON(!IS_ALIGNED(((unsigned long)ctx->sgl), PAGE_SIZE));
diff --git a/drivers/sh/maple/maple.c b/drivers/sh/maple/maple.c
index 6dc0549f7900..318cd44fe64b 100644
--- a/drivers/sh/maple/maple.c
+++ b/drivers/sh/maple/maple.c
@@ -739,7 +739,7 @@ static int maple_set_vblank_interrupt_handler(void)
 static int maple_get_dma_buffer(void)
 {
 	maple_sendbuf =
-	    (void *) __get_free_pages(GFP_KERNEL | __GFP_ZERO,
+	    __get_free_pages(GFP_KERNEL | __GFP_ZERO,
 				      MAPLE_DMA_PAGES);
 	if (!maple_sendbuf)
 		return -ENOMEM;
diff --git a/drivers/spi/spi-ep93xx.c b/drivers/spi/spi-ep93xx.c
index e1d097091925..8ceb17028276 100644
--- a/drivers/spi/spi-ep93xx.c
+++ b/drivers/spi/spi-ep93xx.c
@@ -575,7 +575,7 @@ static int ep93xx_spi_setup_dma(struct device *dev, struct ep93xx_spi *espi)
 {
 	int ret;
 
-	espi->zeropage = (void *)get_zeroed_page(GFP_KERNEL);
+	espi->zeropage = get_zeroed_page(GFP_KERNEL);
 	if (!espi->zeropage)
 		return -ENOMEM;
 
diff --git a/drivers/spi/spi-rockchip-sfc.c b/drivers/spi/spi-rockchip-sfc.c
index 9eba5c0a60f2..d30ba0620581 100644
--- a/drivers/spi/spi-rockchip-sfc.c
+++ b/drivers/spi/spi-rockchip-sfc.c
@@ -698,7 +698,7 @@ static int rockchip_sfc_probe(struct platform_device *pdev)
 	pm_runtime_get_noresume(dev);
 
 	if (sfc->use_dma) {
-		sfc->buffer = (u8 *)__get_free_pages(GFP_KERNEL | GFP_DMA32,
+		sfc->buffer = __get_free_pages(GFP_KERNEL | GFP_DMA32,
 						     get_order(sfc->max_iosize));
 		if (!sfc->buffer) {
 			ret = -ENOMEM;
diff --git a/drivers/spi/spi-sh-msiof.c b/drivers/spi/spi-sh-msiof.c
index b695870fae8c..7e5c393ab4e6 100644
--- a/drivers/spi/spi-sh-msiof.c
+++ b/drivers/spi/spi-sh-msiof.c
@@ -1128,11 +1128,11 @@ static int sh_msiof_request_dma(struct sh_msiof_spi_priv *p)
 	if (!ctlr->dma_rx)
 		goto free_tx_chan;
 
-	p->tx_dma_page = (void *)__get_free_page(GFP_KERNEL | GFP_DMA);
+	p->tx_dma_page = __get_free_page(GFP_KERNEL | GFP_DMA);
 	if (!p->tx_dma_page)
 		goto free_rx_chan;
 
-	p->rx_dma_page = (void *)__get_free_page(GFP_KERNEL | GFP_DMA);
+	p->rx_dma_page = __get_free_page(GFP_KERNEL | GFP_DMA);
 	if (!p->rx_dma_page)
 		goto free_tx_page;
 
diff --git a/drivers/staging/media/atomisp/pci/mmu/isp_mmu.c b/drivers/staging/media/atomisp/pci/mmu/isp_mmu.c
index 5193a7eb7d9f..34cca9bdd12d 100644
--- a/drivers/staging/media/atomisp/pci/mmu/isp_mmu.c
+++ b/drivers/staging/media/atomisp/pci/mmu/isp_mmu.c
@@ -89,7 +89,7 @@ static phys_addr_t alloc_page_table(struct isp_mmu *mmu)
 	phys_addr_t page;
 	void *virt;
 
-	virt = (void *)__get_free_page(GFP_KERNEL | GFP_DMA32);
+	virt = __get_free_page(GFP_KERNEL | GFP_DMA32);
 
 	if (!virt)
 		return (phys_addr_t)NULL_PAGE;
diff --git a/drivers/staging/media/av7110/av7110_ca.c b/drivers/staging/media/av7110/av7110_ca.c
index fce4023c9dea..4e92370a2ab7 100644
--- a/drivers/staging/media/av7110/av7110_ca.c
+++ b/drivers/staging/media/av7110/av7110_ca.c
@@ -138,7 +138,7 @@ static ssize_t ci_ll_write(struct dvb_ringbuffer *cibuf, struct file *file,
 {
 	int free;
 	int non_blocking = file->f_flags & O_NONBLOCK;
-	u8 *page = (u8 *)__get_free_page(GFP_USER);
+	u8 *page = __get_free_page(GFP_USER);
 	int res;
 
 	if (!page)
diff --git a/drivers/staging/media/ipu3/ipu3-mmu.c b/drivers/staging/media/ipu3/ipu3-mmu.c
index cb9bf5fb29a5..bea11ebd2127 100644
--- a/drivers/staging/media/ipu3/ipu3-mmu.c
+++ b/drivers/staging/media/ipu3/ipu3-mmu.c
@@ -123,7 +123,7 @@ static u32 *imgu_mmu_alloc_page_table(u32 pteval)
 	u32 *pt;
 	int pte;
 
-	pt = (u32 *)__get_free_page(GFP_KERNEL);
+	pt = __get_free_page(GFP_KERNEL);
 	if (!pt)
 		return NULL;
 
@@ -444,7 +444,7 @@ struct imgu_mmu_info *imgu_mmu_init(struct device *parent, void __iomem *base)
 	 * The MMU does not have a "valid" bit, so we have to use a dummy
 	 * page for invalid entries.
 	 */
-	mmu->dummy_page = (void *)__get_free_page(GFP_KERNEL);
+	mmu->dummy_page = __get_free_page(GFP_KERNEL);
 	if (!mmu->dummy_page)
 		goto fail_group;
 	pteval = IPU3_ADDR2PTE(virt_to_phys(mmu->dummy_page));
diff --git a/drivers/staging/media/ipu7/ipu7-mmu.c b/drivers/staging/media/ipu7/ipu7-mmu.c
index ded1986eb8ba..799c075ad61f 100644
--- a/drivers/staging/media/ipu7/ipu7-mmu.c
+++ b/drivers/staging/media/ipu7/ipu7-mmu.c
@@ -121,7 +121,7 @@ static dma_addr_t map_single(struct ipu7_mmu_info *mmu_info, void *ptr)
 
 static int get_dummy_page(struct ipu7_mmu_info *mmu_info)
 {
-	void *pt = (void *)get_zeroed_page(GFP_ATOMIC | GFP_DMA32);
+	void *pt = get_zeroed_page(GFP_ATOMIC | GFP_DMA32);
 	dma_addr_t dma;
 
 	if (!pt)
@@ -155,7 +155,7 @@ static void free_dummy_page(struct ipu7_mmu_info *mmu_info)
 
 static int alloc_dummy_l2_pt(struct ipu7_mmu_info *mmu_info)
 {
-	u32 *pt = (u32 *)get_zeroed_page(GFP_ATOMIC | GFP_DMA32);
+	u32 *pt = get_zeroed_page(GFP_ATOMIC | GFP_DMA32);
 	dma_addr_t dma;
 	unsigned int i;
 
@@ -193,7 +193,7 @@ static void free_dummy_l2_pt(struct ipu7_mmu_info *mmu_info)
 
 static u32 *alloc_l1_pt(struct ipu7_mmu_info *mmu_info)
 {
-	u32 *pt = (u32 *)get_zeroed_page(GFP_ATOMIC | GFP_DMA32);
+	u32 *pt = get_zeroed_page(GFP_ATOMIC | GFP_DMA32);
 	dma_addr_t dma;
 	unsigned int i;
 
@@ -223,7 +223,7 @@ static u32 *alloc_l1_pt(struct ipu7_mmu_info *mmu_info)
 
 static u32 *alloc_l2_pt(struct ipu7_mmu_info *mmu_info)
 {
-	u32 *pt = (u32 *)get_zeroed_page(GFP_ATOMIC | GFP_DMA32);
+	u32 *pt = get_zeroed_page(GFP_ATOMIC | GFP_DMA32);
 	unsigned int i;
 
 	if (!pt)
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 2d78ef74633c..cd37c766021e 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -516,7 +516,7 @@ fd_do_prot_unmap(struct se_cmd *cmd, sector_t lba, sector_t nolb)
 	void *buf;
 	int rc;
 
-	buf = (void *)__get_free_page(GFP_KERNEL);
+	buf = __get_free_page(GFP_KERNEL);
 	if (!buf) {
 		pr_err("Unable to allocate FILEIO prot buf\n");
 		return -ENOMEM;
diff --git a/drivers/tee/amdtee/core.c b/drivers/tee/amdtee/core.c
index fb39d9a19c69..31d31fb847a1 100644
--- a/drivers/tee/amdtee/core.c
+++ b/drivers/tee/amdtee/core.c
@@ -204,7 +204,7 @@ static int copy_ta_binary(struct tee_context *ctx, void *ptr, void **ta,
 	}
 
 	*ta_size = roundup(fw->size, PAGE_SIZE);
-	*ta = (void *)__get_free_pages(GFP_KERNEL, get_order(*ta_size));
+	*ta = __get_free_pages(GFP_KERNEL, get_order(*ta_size));
 	if (!*ta) {
 		pr_err("%s: get_free_pages failed\n", __func__);
 		rc = -ENOMEM;
diff --git a/drivers/tee/amdtee/shm_pool.c b/drivers/tee/amdtee/shm_pool.c
index 6346e0bc8a64..43d59e65b912 100644
--- a/drivers/tee/amdtee/shm_pool.c
+++ b/drivers/tee/amdtee/shm_pool.c
@@ -19,7 +19,7 @@ static int pool_op_alloc(struct tee_shm_pool *pool, struct tee_shm *shm,
 	 * Ignore alignment since this is already going to be page aligned
 	 * and there's no need for any larger alignment.
 	 */
-	va = __get_free_pages(GFP_KERNEL | __GFP_ZERO, order);
+	va = (unsigned long)__get_free_pages(GFP_KERNEL | __GFP_ZERO, order);
 	if (!va)
 		return -ENOMEM;
 
diff --git a/drivers/thunderbolt/debugfs.c b/drivers/thunderbolt/debugfs.c
index 46a2a3550be7..a6384a297913 100644
--- a/drivers/thunderbolt/debugfs.c
+++ b/drivers/thunderbolt/debugfs.c
@@ -136,7 +136,7 @@ static void *validate_and_copy_from_user(const void __user *user_buf,
 	if (!access_ok(user_buf, *count))
 		return ERR_PTR(-EFAULT);
 
-	buf = (void *)get_zeroed_page(GFP_KERNEL);
+	buf = get_zeroed_page(GFP_KERNEL);
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
index 5af46442a792..aaee7bc901f5 100644
--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -445,7 +445,7 @@ static int startup(struct tty_struct *tty, struct serial_state *info)
 	int	retval=0;
 	unsigned long page;
 
-	page = get_zeroed_page(GFP_KERNEL);
+	page = (unsigned long)get_zeroed_page(GFP_KERNEL);
 	if (!page)
 		return -ENOMEM;
 
diff --git a/drivers/tty/hvc/hvc_iucv.c b/drivers/tty/hvc/hvc_iucv.c
index 4ca7472c38e0..d69d62e1f9bb 100644
--- a/drivers/tty/hvc/hvc_iucv.c
+++ b/drivers/tty/hvc/hvc_iucv.c
@@ -1061,7 +1061,7 @@ static int __init hvc_iucv_alloc(int id, unsigned int is_console)
 	INIT_DELAYED_WORK(&priv->sndbuf_work, hvc_iucv_sndbuf_work);
 	init_waitqueue_head(&priv->sndbuf_waitq);
 
-	priv->sndbuf = (void *) get_zeroed_page(GFP_KERNEL);
+	priv->sndbuf = get_zeroed_page(GFP_KERNEL);
 	if (!priv->sndbuf) {
 		kfree(priv);
 		return -ENOMEM;
diff --git a/drivers/tty/hvc/hvc_xen.c b/drivers/tty/hvc/hvc_xen.c
index 388a71afd6ef..4114e9afefbe 100644
--- a/drivers/tty/hvc/hvc_xen.c
+++ b/drivers/tty/hvc/hvc_xen.c
@@ -504,7 +504,7 @@ static int xencons_probe(struct xenbus_device *dev,
 	dev_set_drvdata(&dev->dev, info);
 	info->xbdev = dev;
 	info->vtermno = xenbus_devid_to_vtermno(devid);
-	info->intf = (void *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
+	info->intf = __get_free_page(GFP_KERNEL | __GFP_ZERO);
 	if (!info->intf)
 		goto error_nomem;
 
diff --git a/drivers/tty/hvc/hvcs.c b/drivers/tty/hvc/hvcs.c
index f57fd9095f75..98fb63076369 100644
--- a/drivers/tty/hvc/hvcs.c
+++ b/drivers/tty/hvc/hvcs.c
@@ -1471,7 +1471,7 @@ static int hvcs_initialize(void)
 		goto register_fail;
 	}
 
-	hvcs_pi_buff = (unsigned long *) __get_free_page(GFP_KERNEL);
+	hvcs_pi_buff = __get_free_page(GFP_KERNEL);
 	if (!hvcs_pi_buff) {
 		rc = -ENOMEM;
 		goto buff_alloc_fail;
diff --git a/drivers/tty/serial/men_z135_uart.c b/drivers/tty/serial/men_z135_uart.c
index 9cc15449b673..9295bd85948c 100644
--- a/drivers/tty/serial/men_z135_uart.c
+++ b/drivers/tty/serial/men_z135_uart.c
@@ -811,7 +811,7 @@ static int men_z135_probe(struct mcb_device *mdev,
 	if (!uart)
 		return -ENOMEM;
 
-	uart->rxbuf = (unsigned char *)__get_free_page(GFP_KERNEL);
+	uart->rxbuf = __get_free_page(GFP_KERNEL);
 	if (!uart->rxbuf)
 		return -ENOMEM;
 
diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 884fefbfd5a1..14675a6cc01d 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -1655,7 +1655,7 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
 	if (priv == NULL)
 		goto init_port_alloc_err;
 
-	rxbuf = (unsigned char *)__get_free_page(GFP_KERNEL);
+	rxbuf = __get_free_page(GFP_KERNEL);
 	if (!rxbuf)
 		goto init_port_free_txbuf;
 
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 4757293ece8c..c787075a8547 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -252,7 +252,7 @@ static int uart_alloc_xmit_buf(struct tty_port *port)
 	 * Initialise and allocate the transmit and temporary
 	 * buffer.
 	 */
-	page = get_zeroed_page(GFP_KERNEL);
+	page = (unsigned long)get_zeroed_page(GFP_KERNEL);
 	if (!page)
 		return -ENOMEM;
 
diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index fe67c5cb0a3f..049dc37d52b0 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -226,7 +226,7 @@ int tty_port_alloc_xmit_buf(struct tty_port *port)
 	if (port->xmit_buf)
 		return 0;
 
-	port->xmit_buf = (u8 *)get_zeroed_page(GFP_KERNEL);
+	port->xmit_buf = get_zeroed_page(GFP_KERNEL);
 	if (port->xmit_buf == NULL)
 		return -ENOMEM;
 
diff --git a/drivers/tty/vt/vc_screen.c b/drivers/tty/vt/vc_screen.c
index d2029f029de6..31f4d01fc582 100644
--- a/drivers/tty/vt/vc_screen.c
+++ b/drivers/tty/vt/vc_screen.c
@@ -369,7 +369,7 @@ vcs_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	loff_t pos;
 	bool viewed, attr, uni_mode;
 
-	char *con_buf __free(free_page) = (char *)__get_free_page(GFP_KERNEL);
+	char *con_buf __free(free_page) = __get_free_page(GFP_KERNEL);
 	if (!con_buf)
 		return -ENOMEM;
 
@@ -594,7 +594,7 @@ vcs_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 	if (use_unicode(inode))
 		return -EOPNOTSUPP;
 
-	char *con_buf __free(free_page) = (char *)__get_free_page(GFP_KERNEL);
+	char *con_buf __free(free_page) = __get_free_page(GFP_KERNEL);
 	if (!con_buf)
 		return -ENOMEM;
 
diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index 68a8e9de8b4f..38d40e0ad66e 100644
--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -940,7 +940,7 @@ static int cxacru_fw(struct usb_device *usb_dev, enum cxacru_fw_request fw,
 	int offd, offb;
 	const int stride = CMD_PACKET_SIZE - 8;
 
-	buf = (u8 *) __get_free_page(GFP_KERNEL);
+	buf = __get_free_page(GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
@@ -1144,13 +1144,13 @@ static int cxacru_bind(struct usbatm_data *usbatm_instance,
 
 	mutex_init(&instance->adsl_state_serialize);
 
-	instance->rcv_buf = (u8 *) __get_free_page(GFP_KERNEL);
+	instance->rcv_buf = __get_free_page(GFP_KERNEL);
 	if (!instance->rcv_buf) {
 		usb_dbg(usbatm_instance, "cxacru_bind: no memory for rcv_buf\n");
 		ret = -ENOMEM;
 		goto fail;
 	}
-	instance->snd_buf = (u8 *) __get_free_page(GFP_KERNEL);
+	instance->snd_buf = __get_free_page(GFP_KERNEL);
 	if (!instance->snd_buf) {
 		usb_dbg(usbatm_instance, "cxacru_bind: no memory for snd_buf\n");
 		ret = -ENOMEM;
diff --git a/drivers/usb/atm/speedtch.c b/drivers/usb/atm/speedtch.c
index 773ac2725532..19b8645a7e46 100644
--- a/drivers/usb/atm/speedtch.c
+++ b/drivers/usb/atm/speedtch.c
@@ -240,7 +240,7 @@ static int speedtch_upload_firmware(struct speedtch_instance_data *instance,
 
 	usb_dbg(usbatm, "%s entered\n", __func__);
 
-	buffer = (unsigned char *)__get_free_page(GFP_KERNEL);
+	buffer = __get_free_page(GFP_KERNEL);
 	if (!buffer) {
 		ret = -ENOMEM;
 		usb_dbg(usbatm, "%s: no memory for buffer!\n", __func__);
diff --git a/drivers/usb/core/buffer.c b/drivers/usb/core/buffer.c
index 87230869e1fa..b3d8285dd39d 100644
--- a/drivers/usb/core/buffer.c
+++ b/drivers/usb/core/buffer.c
@@ -186,8 +186,8 @@ void *hcd_buffer_alloc_pages(struct usb_hcd *hcd,
 	/* some USB hosts just use PIO */
 	if (!hcd_uses_dma(hcd)) {
 		*dma = DMA_MAPPING_ERROR;
-		return (void *)__get_free_pages(mem_flags,
-				get_order(size));
+		return __get_free_pages(mem_flags,
+					get_order(size));
 	}
 
 	return dma_alloc_coherent(hcd->self.sysdev,
diff --git a/drivers/usb/core/devices.c b/drivers/usb/core/devices.c
index a247da73f34d..23ee8e6112d1 100644
--- a/drivers/usb/core/devices.c
+++ b/drivers/usb/core/devices.c
@@ -408,7 +408,7 @@ static ssize_t usb_device_dump(char __user **buffer, size_t *nbytes,
 		return 0;
 	/* allocate 2^1 pages = 8K (on i386);
 	 * should be more than enough for one device */
-	pages_start = (char *)__get_free_pages(GFP_NOIO, 1);
+	pages_start = __get_free_pages(GFP_NOIO, 1);
 	if (!pages_start)
 		return -ENOMEM;
 
diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index f6ce6e26e0d4..a072bc74b920 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1190,7 +1190,7 @@ static int do_proc_control(struct usb_dev_state *ps,
 		return ret;
 
 	ret = -ENOMEM;
-	tbuf = (unsigned char *)__get_free_page(GFP_KERNEL);
+	tbuf = __get_free_page(GFP_KERNEL);
 	if (!tbuf)
 		goto done;
 	urb = usb_alloc_urb(0, GFP_NOIO);
diff --git a/drivers/usb/host/ohci-dbg.c b/drivers/usb/host/ohci-dbg.c
index 76bc8d56325d..88dceee751d3 100644
--- a/drivers/usb/host/ohci-dbg.c
+++ b/drivers/usb/host/ohci-dbg.c
@@ -683,7 +683,7 @@ static int fill_buffer(struct debug_buffer *buf)
 	int ret;
 
 	if (!buf->page)
-		buf->page = (char *)get_zeroed_page(GFP_KERNEL);
+		buf->page = get_zeroed_page(GFP_KERNEL);
 
 	if (!buf->page) {
 		ret = -ENOMEM;
diff --git a/drivers/usb/mon/mon_bin.c b/drivers/usb/mon/mon_bin.c
index e713fc5964b1..ba3589e4edf7 100644
--- a/drivers/usb/mon/mon_bin.c
+++ b/drivers/usb/mon/mon_bin.c
@@ -1341,7 +1341,7 @@ static int mon_alloc_buff(struct mon_pgmap *map, int npages)
 	unsigned long vaddr;
 
 	for (n = 0; n < npages; n++) {
-		vaddr = get_zeroed_page(GFP_KERNEL);
+		vaddr = (unsigned long)get_zeroed_page(GFP_KERNEL);
 		if (vaddr == 0) {
 			while (n-- != 0)
 				free_page((unsigned long) map[n].ptr);
diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
index 0017f6e969e1..0f9b26c5d62d 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -456,7 +456,7 @@ int usb_wwan_port_probe(struct usb_serial_port *port)
 	init_usb_anchor(&portdata->delayed);
 
 	for (i = 0; i < N_IN_URB; i++) {
-		buffer = (u8 *)__get_free_page(GFP_KERNEL);
+		buffer = __get_free_page(GFP_KERNEL);
 		if (!buffer)
 			goto bail_out_error;
 		portdata->in_buffer[i] = buffer;
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 916cad80941c..aeedb079bb88 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -491,7 +491,7 @@ static void __vfio_batch_init(struct vfio_batch *batch, bool single)
 	if (single || unlikely(disable_hugepages))
 		goto fallback;
 
-	batch->pages = (struct page **) __get_free_page(GFP_KERNEL);
+	batch->pages = __get_free_page(GFP_KERNEL);
 	if (!batch->pages)
 		goto fallback;
 
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 05a481e4c385..1f27861d36b2 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -1105,7 +1105,7 @@ static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
 	int ret = 0;
 
 	/* Limit the use of memory for bookkeeping */
-	page_list = (struct page **) __get_free_page(GFP_KERNEL);
+	page_list = __get_free_page(GFP_KERNEL);
 	if (!page_list)
 		return -ENOMEM;
 
diff --git a/drivers/video/fbdev/ssd1307fb.c b/drivers/video/fbdev/ssd1307fb.c
index aa6cc0a8151a..a60be37bb44e 100644
--- a/drivers/video/fbdev/ssd1307fb.c
+++ b/drivers/video/fbdev/ssd1307fb.c
@@ -667,7 +667,7 @@ static int ssd1307fb_probe(struct i2c_client *client)
 
 	vmem_size = DIV_ROUND_UP(par->width, 8) * par->height;
 
-	vmem = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
+	vmem = __get_free_pages(GFP_KERNEL | __GFP_ZERO,
 					get_order(vmem_size));
 	if (!vmem) {
 		dev_err(dev, "Couldn't allocate graphical memory.\n");
diff --git a/drivers/video/fbdev/xen-fbfront.c b/drivers/video/fbdev/xen-fbfront.c
index d8f3bfb2dd6c..d55b6de455e6 100644
--- a/drivers/video/fbdev/xen-fbfront.c
+++ b/drivers/video/fbdev/xen-fbfront.c
@@ -395,7 +395,7 @@ static int xenfb_probe(struct xenbus_device *dev,
 		goto error_nomem;
 
 	/* set up shared page */
-	info->page = (void *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
+	info->page = __get_free_page(GFP_KERNEL | __GFP_ZERO);
 	if (!info->page)
 		goto error_nomem;
 
diff --git a/drivers/virt/vboxguest/vboxguest_utils.c b/drivers/virt/vboxguest/vboxguest_utils.c
index 1c02b3c0d934..96f1fb596d78 100644
--- a/drivers/virt/vboxguest/vboxguest_utils.c
+++ b/drivers/virt/vboxguest/vboxguest_utils.c
@@ -70,7 +70,7 @@ void *vbg_req_alloc(size_t len, enum vmmdev_request_type req_type,
 	struct vmmdev_request_header *req;
 	int order = get_order(PAGE_ALIGN(len));
 
-	req = (void *)__get_free_pages(GFP_KERNEL | GFP_DMA32, order);
+	req = __get_free_pages(GFP_KERNEL | GFP_DMA32, order);
 	if (!req)
 		return NULL;
 
diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index 9478fae014e5..4c77a638d906 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -229,7 +229,7 @@ static int set_evtchn_to_irq(evtchn_port_t evtchn, unsigned int irq)
 		if (irq == -1)
 			return 0;
 
-		evtchn_row = (int *) __get_free_pages(GFP_KERNEL, 0);
+		evtchn_row = __get_free_pages(GFP_KERNEL, 0);
 		if (evtchn_row == NULL)
 			return -ENOMEM;
 
@@ -2320,7 +2320,7 @@ void __init xen_init_IRQ(void)
 		int rc;
 		struct physdev_pirq_eoi_gmfn eoi_gmfn;
 
-		pirq_eoi_map = (void *)__get_free_page(GFP_KERNEL|__GFP_ZERO);
+		pirq_eoi_map = __get_free_page(GFP_KERNEL|__GFP_ZERO);
 		eoi_gmfn.gmfn = virt_to_gfn(pirq_eoi_map);
 		rc = HYPERVISOR_physdev_op(PHYSDEVOP_pirq_eoi_gmfn_v2, &eoi_gmfn);
 		if (rc != 0) {
diff --git a/drivers/xen/events/events_fifo.c b/drivers/xen/events/events_fifo.c
index 655775db7caf..1aa276ad7be7 100644
--- a/drivers/xen/events/events_fifo.c
+++ b/drivers/xen/events/events_fifo.c
@@ -155,7 +155,7 @@ static int evtchn_fifo_setup(evtchn_port_t port)
 		/* Might already have a page if we've resumed. */
 		array_page = event_array[event_array_pages];
 		if (!array_page) {
-			array_page = (void *)__get_free_page(GFP_KERNEL);
+			array_page = __get_free_page(GFP_KERNEL);
 			if (array_page == NULL) {
 				ret = -ENOMEM;
 				goto error;
@@ -377,7 +377,7 @@ static int evtchn_fifo_alloc_control_block(unsigned cpu)
 	void *control_block = NULL;
 	int ret = -ENOMEM;
 
-	control_block = (void *)__get_free_page(GFP_KERNEL);
+	control_block = __get_free_page(GFP_KERNEL);
 	if (control_block == NULL)
 		goto error;
 
diff --git a/drivers/xen/evtchn.c b/drivers/xen/evtchn.c
index 7e4a13e632dc..630a05e14562 100644
--- a/drivers/xen/evtchn.c
+++ b/drivers/xen/evtchn.c
@@ -273,7 +273,7 @@ static ssize_t evtchn_write(struct file *file, const char __user *buf,
 			    size_t count, loff_t *ppos)
 {
 	int rc, i;
-	evtchn_port_t *kbuf = (evtchn_port_t *)__get_free_page(GFP_KERNEL);
+	evtchn_port_t *kbuf = __get_free_page(GFP_KERNEL);
 	struct per_user_data *u = file->private_data;
 
 	if (kbuf == NULL)
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 478d2ad725ac..fd9d6336017b 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -763,7 +763,7 @@ static int grow_gnttab_list(unsigned int more_frames)
 	nr_glist_frames = gnttab_frames(nr_grant_frames, RPP);
 	new_nr_glist_frames = gnttab_frames(new_nr_grant_frames, RPP);
 	for (i = nr_glist_frames; i < new_nr_glist_frames; i++) {
-		gnttab_list[i] = (grant_ref_t *)__get_free_page(GFP_ATOMIC);
+		gnttab_list[i] = __get_free_page(GFP_ATOMIC);
 		if (!gnttab_list[i])
 			goto grow_nomem;
 	}
@@ -1643,7 +1643,7 @@ int gnttab_init(void)
 
 	nr_glist_frames = gnttab_frames(nr_grant_frames, RPP);
 	for (i = 0; i < nr_glist_frames; i++) {
-		gnttab_list[i] = (grant_ref_t *)__get_free_page(GFP_KERNEL);
+		gnttab_list[i] = __get_free_page(GFP_KERNEL);
 		if (gnttab_list[i] == NULL) {
 			ret = -ENOMEM;
 			goto ini_nomem;
diff --git a/drivers/xen/pvcalls-front.c b/drivers/xen/pvcalls-front.c
index 4926d4badc57..63a7b9230c51 100644
--- a/drivers/xen/pvcalls-front.c
+++ b/drivers/xen/pvcalls-front.c
@@ -357,7 +357,7 @@ static int alloc_active_ring(struct sock_mapping *map)
 {
 	void *bytes;
 
-	map->active.ring = (struct pvcalls_data_intf *)
+	map->active.ring =
 		get_zeroed_page(GFP_KERNEL);
 	if (!map->active.ring)
 		goto out;
@@ -1194,7 +1194,7 @@ static int pvcalls_front_probe(struct xenbus_device *dev,
 	for (i = 0; i < PVCALLS_NR_RSP_PER_RING; i++)
 		bedata->rsp[i].req_id = PVCALLS_INVALID_ID;
 
-	sring = (struct xen_pvcalls_sring *) __get_free_page(GFP_KERNEL |
+	sring = __get_free_page(GFP_KERNEL |
 							     __GFP_ZERO);
 	if (!sring)
 		goto error;
diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index dd7747a2de87..e03bae63488b 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -151,7 +151,7 @@ xen_swiotlb_alloc_coherent(struct device *dev, size_t size,
 	/* Align the allocation to the Xen page size */
 	size = ALIGN(size, XEN_PAGE_SIZE);
 
-	ret = (void *)__get_free_pages(flags, get_order(size));
+	ret = __get_free_pages(flags, get_order(size));
 	if (!ret)
 		return ret;
 	phys = virt_to_phys(ret);
diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 86fe6e779056..1544fbf30acd 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -887,7 +887,7 @@ static int __init xenstored_local_init(void)
 	struct evtchn_alloc_unbound alloc_unbound;
 
 	/* Allocate Xenstore page */
-	page = get_zeroed_page(GFP_KERNEL);
+	page = (unsigned long)get_zeroed_page(GFP_KERNEL);
 	if (!page)
 		goto out_err;
 
diff --git a/fs/affs/file.c b/fs/affs/file.c
index 765c3443663e..b1fbd4d80bbd 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -55,7 +55,7 @@ affs_grow_extcache(struct inode *inode, u32 lc_idx)
 	int i, j, key;
 
 	if (!AFFS_I(inode)->i_lc) {
-		char *ptr = (char *)get_zeroed_page(GFP_NOFS);
+		char *ptr = get_zeroed_page(GFP_NOFS);
 		if (!ptr)
 			return -ENOMEM;
 		AFFS_I(inode)->i_lc = (u32 *)ptr;
diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index 1d41ce477df5..d975b557a335 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -290,7 +290,7 @@ void bfs_dump_imap(const char *prefix, struct super_block *s)
 {
 #ifdef DEBUG
 	int i;
-	char *tmpbuf = (char *)get_zeroed_page(GFP_KERNEL);
+	char *tmpbuf = get_zeroed_page(GFP_KERNEL);
 
 	if (!tmpbuf)
 		return;
diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index a839f960cd4a..e9bc76fd6ce8 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -703,7 +703,7 @@ bm_entry_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 	ssize_t res;
 	char *page;
 
-	page = (char *) __get_free_page(GFP_KERNEL);
+	page = __get_free_page(GFP_KERNEL);
 	if (!page)
 		return -ENOMEM;
 
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 1740047aef0f..8db0c4a826b0 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2548,7 +2548,7 @@ int ceph_alloc_readdir_reply_buffer(struct ceph_mds_request *req,
 
 	order = get_order((unsigned long)bytes_count);
 	while (order >= 0) {
-		rinfo->dir_entries = (void*)__get_free_pages(GFP_KERNEL |
+		rinfo->dir_entries = __get_free_pages(GFP_KERNEL |
 							     __GFP_NOWARN |
 							     __GFP_ZERO,
 							     order);
diff --git a/fs/configfs/file.c b/fs/configfs/file.c
index 0ad32150611e..7a138b3dbe81 100644
--- a/fs/configfs/file.c
+++ b/fs/configfs/file.c
@@ -59,7 +59,7 @@ static int fill_read_buffer(struct file *file, struct configfs_buffer *buffer)
 	ssize_t count = -ENOENT;
 
 	if (!buffer->page)
-		buffer->page = (char *) get_zeroed_page(GFP_KERNEL);
+		buffer->page = get_zeroed_page(GFP_KERNEL);
 	if (!buffer->page)
 		return -ENOMEM;
 
@@ -184,7 +184,7 @@ static int fill_write_buffer(struct configfs_buffer *buffer,
 	int copied;
 
 	if (!buffer->page)
-		buffer->page = (char *)__get_free_pages(GFP_KERNEL, 0);
+		buffer->page = __get_free_pages(GFP_KERNEL, 0);
 	if (!buffer->page)
 		return -ENOMEM;
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 33e7c08c9529..5b8332d441fd 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4188,7 +4188,7 @@ int ext4_calculate_overhead(struct super_block *sb)
 	unsigned int j_blocks, j_inum = le32_to_cpu(es->s_journal_inum);
 	ext4_group_t i, ngroups = ext4_get_groups_count(sb);
 	ext4_fsblk_t overhead = 0;
-	char *buf = (char *) get_zeroed_page(GFP_NOFS);
+	char *buf = get_zeroed_page(GFP_NOFS);
 
 	if (!buf)
 		return -ENOMEM;
diff --git a/fs/fuse/ioctl.c b/fs/fuse/ioctl.c
index 57032eadca6c..b97b6ee8e6a1 100644
--- a/fs/fuse/ioctl.c
+++ b/fs/fuse/ioctl.c
@@ -252,7 +252,7 @@ long fuse_do_ioctl(struct file *file, unsigned int cmd, unsigned long arg,
 
 	err = -ENOMEM;
 	ap.folios = fuse_folios_alloc(fm->fc->max_pages, GFP_KERNEL, &ap.descs);
-	iov_page = (struct iovec *) __get_free_page(GFP_KERNEL);
+	iov_page = __get_free_page(GFP_KERNEL);
 	if (!ap.folios || !iov_page)
 		goto out;
 
diff --git a/fs/isofs/dir.c b/fs/isofs/dir.c
index 09df40b612fb..d19478110d2e 100644
--- a/fs/isofs/dir.c
+++ b/fs/isofs/dir.c
@@ -254,7 +254,7 @@ static int isofs_readdir(struct file *file, struct dir_context *ctx)
 	struct iso_directory_record *tmpde;
 	struct inode *inode = file_inode(file);
 
-	tmpname = (char *)__get_free_page(GFP_KERNEL);
+	tmpname = __get_free_page(GFP_KERNEL);
 	if (tmpname == NULL)
 		return -ENOMEM;
 
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index d480b94117cd..7a6e31231a3b 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2767,7 +2767,7 @@ void *jbd2_alloc(size_t size, gfp_t flags)
 	if (size < PAGE_SIZE)
 		ptr = kmem_cache_alloc(get_slab(size), flags);
 	else
-		ptr = (void *)__get_free_pages(flags, get_order(size));
+		ptr = __get_free_pages(flags, get_order(size));
 
 	/* Check alignment; SLUB has gotten this wrong in the past,
 	 * and this can lead to user data corruption! */
diff --git a/fs/jfs/jfs_dtree.c b/fs/jfs/jfs_dtree.c
index 0ab83bb7bbdf..e85b0490d1e4 100644
--- a/fs/jfs/jfs_dtree.c
+++ b/fs/jfs/jfs_dtree.c
@@ -2887,7 +2887,7 @@ int jfs_readdir(struct file *file, struct dir_context *ctx)
 		}
 	}
 
-	dirent_buf = __get_free_page(GFP_KERNEL);
+	dirent_buf = (unsigned long)__get_free_page(GFP_KERNEL);
 	if (dirent_buf == 0) {
 		DT_PUTPAGE(mp);
 		jfs_warn("jfs_readdir: __get_free_page failed!");
diff --git a/fs/libfs.c b/fs/libfs.c
index ce8c496a6940..f26c7ca71536 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -1238,7 +1238,7 @@ char *simple_transaction_get(struct file *file, const char __user *buf, size_t s
 	if (size > SIMPLE_TRANSACTION_LIMIT - 1)
 		return ERR_PTR(-EFBIG);
 
-	ar = (struct simple_transaction_argresp *)get_zeroed_page(GFP_KERNEL);
+	ar = get_zeroed_page(GFP_KERNEL);
 	if (!ar)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/fs/namespace.c b/fs/namespace.c
index d82910f33dc4..a6cc3c494a0b 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3182,7 +3182,7 @@ static void mnt_warn_timestamp_expiry(const struct path *mountpoint,
 	   (ktime_get_real_seconds() + TIME_UPTIME_SEC_MAX > sb->s_time_max)) {
 		char *buf, *mntpath;
 
-		buf = (char *)__get_free_page(GFP_KERNEL);
+		buf = __get_free_page(GFP_KERNEL);
 		if (buf)
 			mntpath = d_path(mountpoint, buf, PAGE_SIZE);
 		else
diff --git a/fs/nfs/nfs4namespace.c b/fs/nfs/nfs4namespace.c
index 9a98595bb160..bca963fd6915 100644
--- a/fs/nfs/nfs4namespace.c
+++ b/fs/nfs/nfs4namespace.c
@@ -549,10 +549,10 @@ int nfs4_replace_transport(struct nfs_server *server,
 		goto out;
 
 	error = -ENOMEM;
-	page = (char *) __get_free_page(GFP_USER);
+	page = __get_free_page(GFP_USER);
 	if (!page)
 		goto out;
-	page2 = (char *) __get_free_page(GFP_USER);
+	page2 = __get_free_page(GFP_USER);
 	if (!page2)
 		goto out;
 
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 72dee6f3050e..eea5802c11ca 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -641,7 +641,7 @@ static void show_implementation_id(struct seq_file *m, struct nfs_server *nfss)
 
 int nfs_show_devname(struct seq_file *m, struct dentry *root)
 {
-	char *page = (char *) __get_free_page(GFP_KERNEL);
+	char *page = __get_free_page(GFP_KERNEL);
 	char *devname, *dummy;
 	int err = 0;
 	if (!page)
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 9cb20d4aeab1..888d95a33eb2 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -2195,7 +2195,7 @@ static __be32 nfsd_buffered_readdir(struct file *file, struct svc_fh *fhp,
 	loff_t offset;
 	struct readdir_data buf = {
 		.ctx.actor = nfsd_buffered_filldir,
-		.dirent = (void *)__get_free_page(GFP_KERNEL)
+		.dirent = __get_free_page(GFP_KERNEL)
 	};
 
 	if (!buf.dirent)
diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 3288c3b4be9e..615add8c29b2 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -69,7 +69,7 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
 	if (argv->v_index > ~(__u64)0 - argv->v_nmembs)
 		return -EINVAL;
 
-	buf = (void *)get_zeroed_page(GFP_NOFS);
+	buf = get_zeroed_page(GFP_NOFS);
 	if (unlikely(!buf))
 		return -ENOMEM;
 	maxmembs = PAGE_SIZE / argv->v_size;
diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index fe4fdd09bae3..6eeb50df5cd1 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -260,7 +260,7 @@ void dlm_print_one_mle(struct dlm_master_list_entry *mle)
 {
 	char *buf;
 
-	buf = (char *) get_zeroed_page(GFP_ATOMIC);
+	buf = get_zeroed_page(GFP_ATOMIC);
 	if (buf) {
 		dump_mle(mle, buf, PAGE_SIZE - 1);
 		free_page((unsigned long)buf);
@@ -327,7 +327,7 @@ static int debug_purgelist_open(struct inode *inode, struct file *file)
 	struct dlm_ctxt *dlm = inode->i_private;
 	char *buf = NULL;
 
-	buf = (char *) get_zeroed_page(GFP_NOFS);
+	buf = get_zeroed_page(GFP_NOFS);
 	if (!buf)
 		goto bail;
 
@@ -384,7 +384,7 @@ static int debug_mle_open(struct inode *inode, struct file *file)
 	struct dlm_ctxt *dlm = inode->i_private;
 	char *buf = NULL;
 
-	buf = (char *) get_zeroed_page(GFP_NOFS);
+	buf = get_zeroed_page(GFP_NOFS);
 	if (!buf)
 		goto bail;
 
@@ -775,7 +775,7 @@ static int debug_state_open(struct inode *inode, struct file *file)
 	struct dlm_ctxt *dlm = inode->i_private;
 	char *buf = NULL;
 
-	buf = (char *) get_zeroed_page(GFP_NOFS);
+	buf = get_zeroed_page(GFP_NOFS);
 	if (!buf)
 		goto bail;
 
diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 2347a50f079b..0f7c6022ca20 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -76,7 +76,7 @@ static void **dlm_alloc_pagevec(int pages)
 		return NULL;
 
 	for (i = 0; i < pages; i++)
-		if (!(vec[i] = (void *)__get_free_page(GFP_KERNEL)))
+		if (!(vec[i] = __get_free_page(GFP_KERNEL)))
 			goto out_free;
 
 	mlog(0, "Allocated DLM hash pagevec; %d pages (%lu expected), %lu buckets per page\n",
diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 4145e06d2c08..920268eb868f 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -2549,7 +2549,7 @@ static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
 
 	/* preallocate up front. if this fails, abort */
 	ret = -ENOMEM;
-	mres = (struct dlm_migratable_lockres *) __get_free_page(GFP_NOFS);
+	mres = __get_free_page(GFP_NOFS);
 	if (!mres) {
 		mlog_errno(ret);
 		goto leave;
diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 843ee02bd85f..b7b18b318558 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -837,7 +837,7 @@ int dlm_request_all_locks_handler(struct o2net_msg *msg, u32 len, void *data,
 	}
 
 	/* this will get freed by dlm_request_all_locks_worker */
-	buf = (char *) __get_free_page(GFP_NOFS);
+	buf = __get_free_page(GFP_NOFS);
 	if (!buf) {
 		kfree(item);
 		dlm_put(dlm);
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 6299878e3d97..6bda8b411a17 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -261,7 +261,7 @@ static ssize_t get_mm_proctitle(struct mm_struct *mm, char __user *buf,
 	if (pos >= PAGE_SIZE)
 		return 0;
 
-	page = (char *)__get_free_page(GFP_KERNEL);
+	page = __get_free_page(GFP_KERNEL);
 	if (!page)
 		return -ENOMEM;
 
@@ -347,7 +347,7 @@ static ssize_t get_mm_cmdline(struct mm_struct *mm, char __user *buf,
 	if (count > arg_end - pos)
 		count = arg_end - pos;
 
-	page = (char *)__get_free_page(GFP_KERNEL);
+	page = __get_free_page(GFP_KERNEL);
 	if (!page)
 		return -ENOMEM;
 
@@ -908,7 +908,7 @@ static ssize_t mem_rw(struct file *file, char __user *buf,
 	if (!mm)
 		return 0;
 
-	page = (char *)__get_free_page(GFP_KERNEL);
+	page = __get_free_page(GFP_KERNEL);
 	if (!page)
 		return -ENOMEM;
 
@@ -1016,7 +1016,7 @@ static ssize_t environ_read(struct file *file, char __user *buf,
 	if (!mm || !mm->env_end)
 		return 0;
 
-	page = (char *)__get_free_page(GFP_KERNEL);
+	page = __get_free_page(GFP_KERNEL);
 	if (!page)
 		return -ENOMEM;
 
diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index f188bd900eb2..b578b210f764 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -1241,7 +1241,7 @@ static int __init parse_crash_elf64_headers(void)
 	elfcorebuf_sz_orig = sizeof(Elf64_Ehdr) +
 				ehdr.e_phnum * sizeof(Elf64_Phdr);
 	elfcorebuf_sz = elfcorebuf_sz_orig;
-	elfcorebuf = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
+	elfcorebuf = __get_free_pages(GFP_KERNEL | __GFP_ZERO,
 					      get_order(elfcorebuf_sz_orig));
 	if (!elfcorebuf)
 		return -ENOMEM;
@@ -1296,7 +1296,7 @@ static int __init parse_crash_elf32_headers(void)
 	/* Read in all elf headers. */
 	elfcorebuf_sz_orig = sizeof(Elf32_Ehdr) + ehdr.e_phnum * sizeof(Elf32_Phdr);
 	elfcorebuf_sz = elfcorebuf_sz_orig;
-	elfcorebuf = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
+	elfcorebuf = __get_free_pages(GFP_KERNEL | __GFP_ZERO,
 					      get_order(elfcorebuf_sz_orig));
 	if (!elfcorebuf)
 		return -ENOMEM;
@@ -1551,7 +1551,7 @@ static int vmcore_realloc_elfcore_buffer_elf64(size_t new_size)
 		return 0;
 	}
 
-	elfcorebuf_new = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
+	elfcorebuf_new = __get_free_pages(GFP_KERNEL | __GFP_ZERO,
 						  get_order(new_size));
 	if (!elfcorebuf_new)
 		return -ENOMEM;
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 6c4a6ee1fa2b..c2d1a4912319 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -3014,7 +3014,7 @@ static int __init dquot_init(void)
 			NULL);
 
 	order = 0;
-	dquot_hash = (struct hlist_head *)__get_free_pages(GFP_KERNEL, order);
+	dquot_hash = __get_free_pages(GFP_KERNEL, order);
 	if (!dquot_hash)
 		panic("Cannot create dquot hash table");
 
diff --git a/fs/select.c b/fs/select.c
index 082cf60c7e23..0ad836c747c8 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -165,7 +165,7 @@ static struct poll_table_entry *poll_get_entry(struct poll_wqueues *p)
 	if (!table || POLL_TABLE_FULL(table)) {
 		struct poll_table_page *new_table;
 
-		new_table = (struct poll_table_page *) __get_free_page(GFP_KERNEL);
+		new_table = __get_free_page(GFP_KERNEL);
 		if (!new_table) {
 			p->error = -ENOMEM;
 			return NULL;
diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index ee3f27046667..70478999731d 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -357,10 +357,10 @@ static inline struct page *alloc_page_vma_noprof(gfp_t gfp,
 struct page *alloc_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned int order);
 #define alloc_pages_nolock(...)			alloc_hooks(alloc_pages_nolock_noprof(__VA_ARGS__))
 
-extern unsigned long get_free_pages_noprof(gfp_t gfp_mask, unsigned int order);
+void *get_free_pages_noprof(gfp_t gfp_mask, unsigned int order);
 #define __get_free_pages(...)			alloc_hooks(get_free_pages_noprof(__VA_ARGS__))
 
-extern unsigned long get_zeroed_page_noprof(gfp_t gfp_mask);
+void *get_zeroed_page_noprof(gfp_t gfp_mask);
 #define get_zeroed_page(...)			alloc_hooks(get_zeroed_page_noprof(__VA_ARGS__))
 
 void *alloc_pages_exact_noprof(size_t size, gfp_t gfp_mask) __alloc_size(1);
@@ -376,7 +376,7 @@ __meminit void *alloc_pages_exact_nid_noprof(int nid, size_t size, gfp_t gfp_mas
 	__get_free_pages((gfp_mask), 0)
 
 #define __get_dma_pages(gfp_mask, order)				\
-	__get_free_pages((gfp_mask) | GFP_DMA, (order))
+	(unsigned long)__get_free_pages((gfp_mask) | GFP_DMA, (order))
 
 extern void __free_pages(struct page *page, unsigned int order);
 extern void free_pages_nolock(struct page *page, unsigned int order);
diff --git a/init/do_mounts.c b/init/do_mounts.c
index 6af29da8889e..ba7046b92099 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -349,7 +349,7 @@ static int __init mount_nodev_root(char *root_device_name)
 	int err = -EINVAL;
 	int num_fs, i;
 
-	fs_names = (void *)__get_free_page(GFP_KERNEL);
+	fs_names = __get_free_page(GFP_KERNEL);
 	if (!fs_names)
 		return -EINVAL;
 	num_fs = split_fs_names(fs_names, PAGE_SIZE);
diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
index 138ede653de4..4304180341b5 100644
--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -608,7 +608,7 @@ static int dma_debug_create_entries(gfp_t gfp)
 	struct dma_debug_entry *entry;
 	int i;
 
-	entry = (void *)get_zeroed_page(gfp);
+	entry = get_zeroed_page(gfp);
 	if (!entry)
 		return -ENOMEM;
 
diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 0d37da3d95b6..63c2cdce0b2d 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -465,7 +465,7 @@ int swiotlb_init_late(size_t size, gfp_t gfp_mask,
 	nslabs = SLABS_PER_PAGE << order;
 
 	while ((SLABS_PER_PAGE << order) > IO_TLB_MIN_SLABS) {
-		vstart = (void *)__get_free_pages(gfp_mask | __GFP_NOWARN,
+		vstart = __get_free_pages(gfp_mask | __GFP_NOWARN,
 						  order);
 		if (vstart)
 			break;
@@ -496,12 +496,12 @@ int swiotlb_init_late(size_t size, gfp_t gfp_mask,
 
 	nareas = limit_nareas(default_nareas, nslabs);
 	area_order = get_order(array_size(sizeof(*mem->areas), nareas));
-	mem->areas = (struct io_tlb_area *)
+	mem->areas =
 		__get_free_pages(GFP_KERNEL | __GFP_ZERO, area_order);
 	if (!mem->areas)
 		goto error_area;
 
-	mem->slots = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
+	mem->slots = __get_free_pages(GFP_KERNEL | __GFP_ZERO,
 		get_order(array_size(sizeof(*mem->slots), nslabs)));
 	if (!mem->slots)
 		goto error_slots;
@@ -711,7 +711,7 @@ static struct io_tlb_pool *swiotlb_alloc_pool(struct device *dev,
 	}
 
 	slot_order = get_order(array_size(sizeof(*pool->slots), nslabs));
-	pool->slots = (struct io_tlb_slot *)
+	pool->slots =
 		__get_free_pages(gfp, slot_order);
 	if (!pool->slots)
 		goto error_slots;
diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index 76f0940fb485..77940089ef31 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -846,7 +846,7 @@ static struct kho_vmalloc_chunk *new_vmalloc_chunk(struct kho_vmalloc_chunk *cur
 	struct kho_vmalloc_chunk *chunk;
 	int err;
 
-	chunk = (struct kho_vmalloc_chunk *)get_zeroed_page(GFP_KERNEL);
+	chunk = get_zeroed_page(GFP_KERNEL);
 	if (!chunk)
 		return NULL;
 
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 645f42e40478..ec6a733ef6a0 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -192,13 +192,13 @@ static void *get_image_page(gfp_t gfp_mask, int safe_needed)
 {
 	void *res;
 
-	res = (void *)get_zeroed_page(gfp_mask);
+	res = get_zeroed_page(gfp_mask);
 	if (safe_needed)
 		while (res && swsusp_page_is_free(virt_to_page(res))) {
 			/* The page is unsafe, mark it for swsusp_free() */
 			swsusp_set_page_forbidden(virt_to_page(res));
 			allocated_unsafe_pages++;
-			res = (void *)get_zeroed_page(gfp_mask);
+			res = get_zeroed_page(gfp_mask);
 		}
 	if (res) {
 		swsusp_set_page_forbidden(virt_to_page(res));
@@ -2685,7 +2685,7 @@ static int prepare_image(struct memory_bitmap *new_bm, struct memory_bitmap *bm,
 	/* Preallocate memory for the image */
 	nr_pages = (nr_zero_pages + nr_copy_pages) - nr_highmem - allocated_unsafe_pages;
 	while (nr_pages > 0) {
-		lp = (struct linked_page *)get_zeroed_page(GFP_ATOMIC);
+		lp = get_zeroed_page(GFP_ATOMIC);
 		if (!lp) {
 			error = -ENOMEM;
 			goto Free;
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 0beff7eeaaba..6b662c687cef 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -381,12 +381,12 @@ static int write_page(void *buf, sector_t offset, struct hib_bio_batch *hb)
 	if (!hb)
 		goto sync_io;
 
-	src = (void *)__get_free_page(gfp);
+	src = __get_free_page(gfp);
 	if (!src) {
 		ret = hib_wait_io(hb); /* Free pages */
 		if (ret)
 			return ret;
-		src = (void *)__get_free_page(gfp);
+		src = __get_free_page(gfp);
 		if (WARN_ON_ONCE(!src))
 			goto sync_io;
 	}
@@ -414,7 +414,7 @@ static int get_swap_writer(struct swap_map_handle *handle)
 			pr_err("Cannot find swap device, try swapon -a\n");
 		return ret;
 	}
-	handle->cur = (struct swap_map_page *)get_zeroed_page(GFP_KERNEL);
+	handle->cur = get_zeroed_page(GFP_KERNEL);
 	if (!handle->cur) {
 		ret = -ENOMEM;
 		goto err_close;
@@ -705,7 +705,7 @@ static int save_compressed_image(struct swap_map_handle *handle,
 	nr_threads = num_online_cpus() - 1;
 	nr_threads = clamp_val(nr_threads, 1, CMP_THREADS);
 
-	page = (void *)__get_free_page(GFP_NOIO | __GFP_HIGH);
+	page = __get_free_page(GFP_NOIO | __GFP_HIGH);
 	if (!page) {
 		pr_err("Failed to allocate %s page\n", hib_comp_algo);
 		ret = -ENOMEM;
@@ -1019,7 +1019,7 @@ static int get_swap_reader(struct swap_map_handle *handle,
 			last->next = tmp;
 		last = tmp;
 
-		tmp->map = (struct swap_map_page *)
+		tmp->map =
 			   __get_free_page(GFP_NOIO | __GFP_HIGH);
 		if (!tmp->map) {
 			release_swap_reader(handle);
@@ -1313,7 +1313,7 @@ static int load_compressed_image(struct swap_map_handle *handle,
 	read_pages = clamp_val(read_pages, CMP_MIN_RD_PAGES, CMP_MAX_RD_PAGES);
 
 	for (i = 0; i < read_pages; i++) {
-		page[i] = (void *)__get_free_page(i < CMP_PAGES ?
+		page[i] = __get_free_page(i < CMP_PAGES ?
 						  GFP_NOIO | __GFP_HIGH :
 						  GFP_NOIO | __GFP_NOWARN |
 						  __GFP_NORETRY);
@@ -1660,7 +1660,7 @@ int swsusp_unmark(void)
 
 static int __init swsusp_header_init(void)
 {
-	swsusp_header = (struct swsusp_header*) __get_free_page(GFP_KERNEL);
+	swsusp_header = __get_free_page(GFP_KERNEL);
 	if (!swsusp_header)
 		panic("Could not allocate memory for swsusp_header\n");
 	return 0;
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 42bd2ba68a82..68e2b4da569e 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -615,7 +615,7 @@ static int ftrace_profile_pages_init(struct ftrace_profile_stat *stat)
 	if (stat->pages)
 		return 0;
 
-	stat->pages = (void *)get_zeroed_page(GFP_KERNEL);
+	stat->pages = get_zeroed_page(GFP_KERNEL);
 	if (!stat->pages)
 		return -ENOMEM;
 
@@ -637,7 +637,7 @@ static int ftrace_profile_pages_init(struct ftrace_profile_stat *stat)
 	pages = DIV_ROUND_UP(functions, PROFILES_PER_PAGE);
 
 	for (i = 1; i < pages; i++) {
-		pg->next = (void *)get_zeroed_page(GFP_KERNEL);
+		pg->next = get_zeroed_page(GFP_KERNEL);
 		if (!pg->next)
 			goto out_free;
 		pg = pg->next;
@@ -3809,7 +3809,7 @@ static int ftrace_allocate_records(struct ftrace_page *pg, int count)
 	order = fls(pages) - 1;
 
  again:
-	pg->records = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, order);
+	pg->records = __get_free_pages(GFP_KERNEL | __GFP_ZERO, order);
 
 	if (!pg->records) {
 		/* if we can't allocate this size, try something smaller */
diff --git a/kernel/trace/tracing_map.c b/kernel/trace/tracing_map.c
index 7f8da4dab69d..91ac1bef8525 100644
--- a/kernel/trace/tracing_map.c
+++ b/kernel/trace/tracing_map.c
@@ -341,7 +341,7 @@ static struct tracing_map_array *tracing_map_array_alloc(unsigned int n_elts,
 		goto free;
 
 	for (i = 0; i < a->n_pages; i++) {
-		a->pages[i] = (void *)get_zeroed_page(GFP_KERNEL);
+		a->pages[i] = get_zeroed_page(GFP_KERNEL);
 		if (!a->pages[i])
 			goto free;
 		kmemleak_alloc(a->pages[i], PAGE_SIZE, 1, GFP_KERNEL);
diff --git a/kernel/vmcore_info.c b/kernel/vmcore_info.c
index e066d31d08f8..69a8140fb9ed 100644
--- a/kernel/vmcore_info.c
+++ b/kernel/vmcore_info.c
@@ -120,7 +120,7 @@ EXPORT_SYMBOL(paddr_vmcoreinfo_note);
 
 static int __init crash_save_vmcoreinfo_init(void)
 {
-	vmcoreinfo_data = (unsigned char *)get_zeroed_page(GFP_KERNEL);
+	vmcoreinfo_data = get_zeroed_page(GFP_KERNEL);
 	if (!vmcoreinfo_data) {
 		pr_warn("Memory allocation for vmcoreinfo_data failed\n");
 		return -ENOMEM;
diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
index 799e0e5eac26..b5d15493fce8 100644
--- a/lib/raid6/algos.c
+++ b/lib/raid6/algos.c
@@ -250,7 +250,7 @@ int __init raid6_select_algo(void)
 	int i, cycle;
 
 	/* prepare the buffer and fill it circularly with gfmul table */
-	disk_ptr = (char *)__get_free_pages(GFP_KERNEL, RAID6_TEST_DISKS_ORDER);
+	disk_ptr = __get_free_pages(GFP_KERNEL, RAID6_TEST_DISKS_ORDER);
 	if (!disk_ptr) {
 		pr_err("raid6: Yikes!  No memory available.\n");
 		return -ENOMEM;
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index 4af1c8b0775a..662cc64781f7 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -138,7 +138,7 @@ static struct scatterlist *sg_kmalloc(unsigned int nents, gfp_t gfp_mask)
 		 * false-positive) we need to inform kmemleak of all the
 		 * intermediate allocations.
 		 */
-		void *ptr = (void *) __get_free_page(gfp_mask);
+		void *ptr = __get_free_page(gfp_mask);
 		kmemleak_alloc(ptr, PAGE_SIZE, 1, gfp_mask);
 		return ptr;
 	} else
diff --git a/lib/test_free_pages.c b/lib/test_free_pages.c
index 48952364c540..3f265ea1c07c 100644
--- a/lib/test_free_pages.c
+++ b/lib/test_free_pages.c
@@ -16,7 +16,7 @@ static void test_free_pages(gfp_t gfp)
 	unsigned int i;
 
 	for (i = 0; i < 1000 * 1000; i++) {
-		unsigned long addr = __get_free_pages(gfp, 3);
+		unsigned long addr = (unsigned long)__get_free_pages(gfp, 3);
 		struct page *page = virt_to_page((void *)addr);
 
 		/* Simulate page cache getting a speculative reference */
diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
index 29a751a8a08d..0496221a681a 100644
--- a/mm/kasan/shadow.c
+++ b/mm/kasan/shadow.c
@@ -361,7 +361,7 @@ static int __kasan_populate_vmalloc_do(unsigned long start, unsigned long end, g
 	unsigned int flags;
 	int ret = 0;
 
-	data.pages = (struct page **)__get_free_page(gfp_mask | __GFP_ZERO);
+	data.pages = __get_free_page(gfp_mask | __GFP_ZERO);
 	if (!data.pages)
 		return -ENOMEM;
 
diff --git a/mm/mincore.c b/mm/mincore.c
index 8ec4719370e1..c98bd87733e6 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -300,7 +300,7 @@ SYSCALL_DEFINE3(mincore, unsigned long, start, size_t, len,
 	if (!access_ok(vec, pages))
 		return -EFAULT;
 
-	tmp = (void *) __get_free_page(GFP_USER);
+	tmp = __get_free_page(GFP_USER);
 	if (!tmp)
 		return -EAGAIN;
 
diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index 374aa6f021c6..ebca167aa674 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -32,7 +32,7 @@ static bool tlb_next_batch(struct mmu_gather *tlb)
 	if (tlb->batch_count == MAX_GATHER_BATCH_COUNT)
 		return false;
 
-	batch = (void *)__get_free_page(GFP_NOWAIT);
+	batch = __get_free_page(GFP_NOWAIT);
 	if (!batch)
 		return false;
 
@@ -364,7 +364,7 @@ void tlb_remove_table(struct mmu_gather *tlb, void *table)
 	struct mmu_table_batch **batch = &tlb->batch;
 
 	if (*batch == NULL) {
-		*batch = (struct mmu_table_batch *)__get_free_page(GFP_NOWAIT);
+		*batch = __get_free_page(GFP_NOWAIT);
 		if (*batch == NULL) {
 			tlb_table_invalidate(tlb);
 			tlb_remove_table_one(table);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index fb91c566327c..d9e644650a33 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5266,18 +5266,18 @@ EXPORT_SYMBOL(__folio_alloc_noprof);
  * address cannot represent highmem pages. Use alloc_pages and then kmap if
  * you need to access high mem.
  */
-unsigned long get_free_pages_noprof(gfp_t gfp_mask, unsigned int order)
+void *get_free_pages_noprof(gfp_t gfp_mask, unsigned int order)
 {
 	struct page *page;
 
 	page = alloc_pages_noprof(gfp_mask & ~__GFP_HIGHMEM, order);
 	if (!page)
 		return 0;
-	return (unsigned long) page_address(page);
+	return page_address(page);
 }
 EXPORT_SYMBOL(get_free_pages_noprof);
 
-unsigned long get_zeroed_page_noprof(gfp_t gfp_mask)
+void *get_zeroed_page_noprof(gfp_t gfp_mask)
 {
 	return get_free_pages_noprof(gfp_mask | __GFP_ZERO, 0);
 }
@@ -5362,12 +5362,12 @@ void free_pages(unsigned long addr, unsigned int order)
 
 EXPORT_SYMBOL(free_pages);
 
-static void *make_alloc_exact(unsigned long addr, unsigned int order,
+static void *make_alloc_exact(void *addr, unsigned int order,
 		size_t size)
 {
 	if (addr) {
 		unsigned long nr = DIV_ROUND_UP(size, PAGE_SIZE);
-		struct page *page = virt_to_page((void *)addr);
+		struct page *page = virt_to_page(addr);
 		struct page *last = page + nr;
 
 		split_page_owner(page, order, 0);
@@ -5380,7 +5380,7 @@ static void *make_alloc_exact(unsigned long addr, unsigned int order,
 		for (page += nr; page < last; page++)
 			__free_pages_ok(page, 0, FPI_TO_TAIL);
 	}
-	return (void *)addr;
+	return addr;
 }
 
 /**
@@ -5401,7 +5401,7 @@ static void *make_alloc_exact(unsigned long addr, unsigned int order,
 void *alloc_pages_exact_noprof(size_t size, gfp_t gfp_mask)
 {
 	unsigned int order = get_order(size);
-	unsigned long addr;
+	void *addr;
 
 	if (WARN_ON_ONCE(gfp_mask & (__GFP_COMP | __GFP_HIGHMEM)))
 		gfp_mask &= ~(__GFP_COMP | __GFP_HIGHMEM);
@@ -5434,7 +5434,7 @@ void * __meminit alloc_pages_exact_nid_noprof(int nid, size_t size, gfp_t gfp_ma
 	p = alloc_pages_node_noprof(nid, gfp_mask, order);
 	if (!p)
 		return NULL;
-	return make_alloc_exact((unsigned long)page_address(p), order, size);
+	return make_alloc_exact(page_address(p), order, size);
 }
 
 /**
diff --git a/mm/slab_common.c b/mm/slab_common.c
index d2824daa98cf..cf5ab534b689 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1828,7 +1828,7 @@ static void fill_page_cache_func(struct work_struct *work)
 		1 : rcu_min_cached_objs;
 
 	for (i = READ_ONCE(krcp->nr_bkv_objs); i < nr_pages; i++) {
-		bnode = (struct kvfree_rcu_bulk_data *)
+		bnode =
 			__get_free_page(GFP_KERNEL | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
 
 		if (!bnode)
@@ -1886,7 +1886,7 @@ add_ptr_to_bulk_krc_lock(struct kfree_rcu_cpu **krcp,
 			// __GFP_NOWARN - it is supposed that an allocation can
 			// be failed under low memory or high memory pressure
 			// scenarios.
-			bnode = (struct kvfree_rcu_bulk_data *)
+			bnode =
 				__get_free_page(GFP_KERNEL | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
 			raw_spin_lock_irqsave(&(*krcp)->lock, *flags);
 		}
diff --git a/mm/slub.c b/mm/slub.c
index b7442015f640..4b5fbce09a44 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -8768,7 +8768,7 @@ static int alloc_loc_track(struct loc_track *t, unsigned long max, gfp_t flags)
 
 	order = get_order(sizeof(struct location) * max);
 
-	l = (void *)__get_free_pages(flags, order);
+	l = __get_free_pages(flags, order);
 	if (!l)
 		return 0;
 
diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index b9ff69c7522a..45e7030598b1 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -328,7 +328,7 @@ static int xen_9pfs_front_alloc_dataring(struct xenbus_device *dev,
 	spin_lock_init(&ring->lock);
 	INIT_WORK(&ring->work, p9_xen_response);
 
-	ring->intf = (struct xen_9pfs_data_intf *)get_zeroed_page(GFP_KERNEL);
+	ring->intf = get_zeroed_page(GFP_KERNEL);
 	if (!ring->intf)
 		return ret;
 	ret = gnttab_grant_foreign_access(dev->otherend_id,
diff --git a/net/atm/mpoa_proc.c b/net/atm/mpoa_proc.c
index aaf64b953915..5d6841f87f19 100644
--- a/net/atm/mpoa_proc.c
+++ b/net/atm/mpoa_proc.c
@@ -215,7 +215,7 @@ static ssize_t proc_mpc_write(struct file *file, const char __user *buff,
 	if (nbytes >= PAGE_SIZE)
 		nbytes = PAGE_SIZE-1;
 
-	page = (char *)__get_free_page(GFP_KERNEL);
+	page = __get_free_page(GFP_KERNEL);
 	if (!page)
 		return -ENOMEM;
 
diff --git a/net/atm/proc.c b/net/atm/proc.c
index 9bf736290e48..ba3e2deb05af 100644
--- a/net/atm/proc.c
+++ b/net/atm/proc.c
@@ -321,7 +321,7 @@ static ssize_t proc_dev_atm_read(struct file *file, char __user *buf,
 
 	if (count == 0)
 		return 0;
-	page = get_zeroed_page(GFP_KERNEL);
+	page = (unsigned long)get_zeroed_page(GFP_KERNEL);
 	if (!page)
 		return -ENOMEM;
 	dev = pde_data(file_inode(file));
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index eed434e0a970..0a4e2541f136 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4751,7 +4751,7 @@ static int nf_tables_set_alloc_name(struct nft_ctx *ctx, struct nft_set *set,
 		if (strnlen(name, NFT_SET_MAX_ANONLEN) >= NFT_SET_MAX_ANONLEN)
 			return -EINVAL;
 
-		inuse = (unsigned long *)get_zeroed_page(GFP_KERNEL);
+		inuse = get_zeroed_page(GFP_KERNEL);
 		if (inuse == NULL)
 			return -ENOMEM;
 cont:
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 173e6edda08f..28c9588cf3a2 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -4363,7 +4363,7 @@ static char *alloc_one_pg_vec_page(unsigned long order)
 	gfp_t gfp_flags = GFP_KERNEL | __GFP_COMP |
 			  __GFP_ZERO | __GFP_NOWARN | __GFP_NORETRY;
 
-	buffer = (char *) __get_free_pages(gfp_flags, order);
+	buffer = __get_free_pages(gfp_flags, order);
 	if (buffer)
 		return buffer;
 
@@ -4374,7 +4374,7 @@ static char *alloc_one_pg_vec_page(unsigned long order)
 
 	/* vmalloc failed, lets dig into swap here */
 	gfp_flags &= ~__GFP_NORETRY;
-	buffer = (char *) __get_free_pages(gfp_flags, order);
+	buffer = __get_free_pages(gfp_flags, order);
 	if (buffer)
 		return buffer;
 
diff --git a/net/rds/cong.c b/net/rds/cong.c
index 8b689ebbd5b5..dd72a6028dbf 100644
--- a/net/rds/cong.c
+++ b/net/rds/cong.c
@@ -152,7 +152,7 @@ static struct rds_cong_map *rds_cong_from_addr(const struct in6_addr *addr)
 	INIT_LIST_HEAD(&map->m_conn_list);
 
 	for (i = 0; i < RDS_CONG_MAP_PAGES; i++) {
-		zp = get_zeroed_page(GFP_KERNEL);
+		zp = (unsigned long)get_zeroed_page(GFP_KERNEL);
 		if (zp == 0)
 			goto out;
 		map->m_page_addrs[i] = zp;
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 9dbc24af749b..ca61ebeb5ff5 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1588,7 +1588,7 @@ static __init int sctp_init(void)
 	 * reduce the order and try again
 	 */
 	do {
-		sctp_port_hashtable = (struct sctp_bind_hashbucket *)
+		sctp_port_hashtable =
 			__get_free_pages(GFP_KERNEL | __GFP_NOWARN, order);
 	} while (!sctp_port_hashtable && --order > 0);
 
diff --git a/net/xfrm/xfrm_hash.c b/net/xfrm/xfrm_hash.c
index eca8d84d99bf..a47f14b437a8 100644
--- a/net/xfrm/xfrm_hash.c
+++ b/net/xfrm/xfrm_hash.c
@@ -22,7 +22,7 @@ struct hlist_head *xfrm_hash_alloc(unsigned int sz)
 	else if (hashdist)
 		n = vzalloc(sz);
 	else
-		n = (struct hlist_head *)
+		n =
 			__get_free_pages(GFP_KERNEL | __GFP_NOWARN | __GFP_ZERO,
 					 get_order(sz));
 
diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index 391a586d0557..6560661ad377 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -874,7 +874,7 @@ static struct multi_transaction *multi_transaction_new(struct file *file,
 	if (size > MULTI_TRANSACTION_LIMIT - 1)
 		return ERR_PTR(-EFBIG);
 
-	t = (struct multi_transaction *)get_zeroed_page(GFP_KERNEL);
+	t = get_zeroed_page(GFP_KERNEL);
 	if (!t)
 		return ERR_PTR(-ENOMEM);
 	kref_init(&t->count);
diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index 6f5696d999d0..343f314418a5 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -246,7 +246,7 @@ static void *ima_alloc_pages(loff_t max_size, size_t *allocated_size,
 		order = min(get_order(max_size), order);
 
 	for (; order; order--) {
-		ptr = (void *)__get_free_pages(gfp_mask, order);
+		ptr = __get_free_pages(gfp_mask, order);
 		if (ptr) {
 			*allocated_size = PAGE_SIZE << order;
 			return ptr;
@@ -260,7 +260,7 @@ static void *ima_alloc_pages(loff_t max_size, size_t *allocated_size,
 	if (!last_warn)
 		gfp_mask |= __GFP_NOWARN;
 
-	ptr = (void *)__get_free_pages(gfp_mask, 0);
+	ptr = __get_free_pages(gfp_mask, 0);
 	if (ptr) {
 		*allocated_size = PAGE_SIZE;
 		return ptr;
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index dfc22da42f30..cfb0b9b9d5f3 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1329,7 +1329,7 @@ static int selinux_genfs_get_sid(struct dentry *dentry,
 	struct super_block *sb = dentry->d_sb;
 	char *buffer, *path;
 
-	buffer = (char *)__get_free_page(GFP_KERNEL);
+	buffer = __get_free_page(GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index 232e087bce3e..73a8c5c17c76 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -1347,7 +1347,7 @@ static int sel_make_bools(struct selinux_policy *newpolicy, struct dentry *bool_
 	char **names, *page;
 	u32 i, num;
 
-	page = (char *)get_zeroed_page(GFP_KERNEL);
+	page = get_zeroed_page(GFP_KERNEL);
 	if (!page)
 		return -ENOMEM;
 
@@ -1458,7 +1458,7 @@ static ssize_t sel_read_avc_hash_stats(struct file *filp, char __user *buf,
 	char *page;
 	ssize_t length;
 
-	page = (char *)__get_free_page(GFP_KERNEL);
+	page = __get_free_page(GFP_KERNEL);
 	if (!page)
 		return -ENOMEM;
 
@@ -1476,7 +1476,7 @@ static ssize_t sel_read_sidtab_hash_stats(struct file *filp, char __user *buf,
 	char *page;
 	ssize_t length;
 
-	page = (char *)__get_free_page(GFP_KERNEL);
+	page = __get_free_page(GFP_KERNEL);
 	if (!page)
 		return -ENOMEM;
 
diff --git a/sound/drivers/dummy.c b/sound/drivers/dummy.c
index 1860ff75fe15..5e56157e0719 100644
--- a/sound/drivers/dummy.c
+++ b/sound/drivers/dummy.c
@@ -611,7 +611,7 @@ static int alloc_fake_buffer(void)
 	if (!fake_buffer)
 		return 0;
 	for (i = 0; i < 2; i++) {
-		dummy_page[i] = (void *)get_zeroed_page(GFP_KERNEL);
+		dummy_page[i] = get_zeroed_page(GFP_KERNEL);
 		if (!dummy_page[i]) {
 			free_fake_buffer();
 			return -ENOMEM;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 226faeaa8e56..a716c81e01e6 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -355,7 +355,7 @@ static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
 	if (mc->kmem_cache)
 		return kmem_cache_alloc(mc->kmem_cache, gfp_flags);
 
-	page = (void *)__get_free_page(gfp_flags);
+	page = __get_free_page(gfp_flags);
 	if (page && mc->init_value)
 		memset64(page, mc->init_value, PAGE_SIZE / sizeof(u64));
 	return page;
-- 
2.50.1


