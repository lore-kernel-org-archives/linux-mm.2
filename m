Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EF01CCD184
	for <linux-mm@archiver.kernel.org>; Sat, 18 Oct 2025 09:30:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0B078E0009; Sat, 18 Oct 2025 05:30:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABB618E0002; Sat, 18 Oct 2025 05:30:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AF008E0009; Sat, 18 Oct 2025 05:30:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3FCB98E0002
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 05:30:28 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A03DFC03F4
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 09:30:27 +0000 (UTC)
X-FDA: 84010714494.06.AE8D54F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7378440011
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 09:30:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FhlvX+ro;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760779825; a=rsa-sha256;
	cv=none;
	b=w0EZftigPjkI1n2jdXAC6AUguNsxKSAEo6QlgxQb3jHhLxU2jdvSNe5jOwsoLOv0HJEySP
	kD2CAGWLMS2hlhM1Hjz3LrpdtpoDPio69S2dyEwCvfieo1Z42Y6pIfKTZx4EuOxeO1Opcm
	KNF3k1MDhuVDrK8Ir6yQNCzBEV9T8Z4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FhlvX+ro;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760779825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2XTYHhWzQGKo3TIaziQ8fs9h9o7v3o8zWxlfX4KCsQc=;
	b=TIdOYSQ8z7L0CLYlXuifDqXbuVep8ZKlMbb1ze5U60XCWh1r/geG5bNLHH0i0XO7e5I6ic
	TTjLmynrfkR2wHCcOD91YQYuAoM6Ri1grXRMdb9fdychzLiBalAlWpFP2ySNiRxtuVn2xV
	iUKF1uH445XmclwOKpaef1W/W1g8iYY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6022060253;
	Sat, 18 Oct 2025 09:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E67C116B1;
	Sat, 18 Oct 2025 09:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760779824;
	bh=43xwtkJoS1zItTcQtJTtgXS9aAlGcNsIbB1WjEkYC6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FhlvX+rojC18pBt1iSdbsaAjlqyr4PjZvXBet3uTC+i/kLb+7LymdiW6tT/LDMaUG
	 iW9TbwcpJNV2hRtoFWkHO7W2aY65s1ZQEVJe9B9546idFlI2m/Wt7p8r2eFbvWJCpU
	 0PMb+NQcgph+zveiWpgIOiwmMrh9h5cwtUDcKn/R+gr/K1XDFo7hSjLpFIoYwpPMSX
	 ThJqs3Yhpubx0+VBYdpVorxbikLB3LkxT4+JMmktgAH9Av+c1QJYIwI9/G5hS7tyLn
	 QQTbr0RBpm7Pm16vWzbwqnzw6mUtuacN/Iv6PtXxizsG+H2p9HcFqZtaGNvrfaLrW6
	 oe40x2tZSnjkA==
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
Subject: [PATCH 3/3] mm, treewide: make addr parameter of free_pages() void *
Date: Sat, 18 Oct 2025 12:30:02 +0300
Message-ID: <20251018093002.3660549-4-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251018093002.3660549-1-rppt@kernel.org>
References: <20251018093002.3660549-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hb5xtcowjxwt93wcqe7i64eenc7o88de
X-Rspamd-Queue-Id: 7378440011
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760779825-433318
X-HE-Meta: U2FsdGVkX1/C1Xzj+lhb3U5qkUubo1AjChauvzhIFR+aSsnhpC/DVR4atEU+U4Q3t7iTjegPM2RDMQUvTMwfkWlQ1WsqQnsirtlBUsuJgLZSnkP5rRHH2ZeU4WG1HziughsmB7jLLBglBDWACS+5rQg1U0iabL20Kh/pYwGk3YoiZ8jkO+eXUvuYjQpb5NSuOOYulemmFjrCBUDvFso7rtkM7M+0PX3P8vXwxf/gKXKBdrCi+RCbn82ke+qpL875UOQ49n0RM/WrwGi1epuov2h1Kr1zpNWxkrRpxJO78xnqtpx1pAcAtgLc84Wm+wHsMHbKkEsbndTC8UAESfLfIki69IYe8X+XSVqkAcdpnMhQ0y9diwULk1UkroN5Y9pWj5ZCmeODCobNzU6vaWdcoBZp+OBzfrVIUx10gibxIL6Zc30cfjtX31N4qnbqlySW+wOrsMIaa/RqPzGMXyw6y6DNMYU8eJK1tY53Gau2RUsOUiZBKYkqGYgr8YcDInBO1bB/s9c8lhDeGiAQVKdkOAeWVC8m5hptwAWtPJt9C53deZEEyTx9sKkcv8f0hsqk++cgwm7LXzx91MRLE94WSsGl6IQRtONnx5mTQYWFS6cecZqUe84OiVp1QsgcdWepbRo4CSqa1tspNaZrrAyhH544ZbeQgtyU05Ro48gbxMlfpdaDwU/BUnRkhlwIpUKG/LhJSQPb0+ujhPrVlsPqpEnjK5sgnCe3XQa2lM1PnU1z//zMBWijRmGuFimcBeKGzMGcgyfzyGc2mJpI6KrzF5WYUhfQb5F2xFsMu+DTTM48QbkgszV2dmDZFkW76Hih9suvAo2Fo+Bj3+EAAm5M1jShRDjYi/mAijH7RYBOKEMwl9RTx9q5kMmhKq8fqcAC3UjzN6MhlNxmsdv2HgNi7ykJY+9YiCVKhus3WXD9MUXI8av0WC9o0x/3s7Gwq5mEBaBhK+wq8N9Vq7tvPS1
 VpdEZ9QE
 AO72rpUTDEOMwhyCFXyAGKCXpTpLOLKd9A4iiid2t/u7t4LsGzhmr7MPFe2GGhhjntA15l76QdoU/pw+kwkvnwT0cGV1mwQR+mnQT9VKagg+qU3iytJXHm7dsKGRWSGWtQjg1T/sWjRkCD8kglyVjdFI+FJGJ8pr6fGJWAArW6RGOCzr0gibvrYgTatfCzTigPTL7/qaIBhY1xDdh8zdPlfKMEUbr3HNeAlMycnkbGyOjrWQmvUedgJv4ypZ3SgQVNl5aaMXS/gCrwfU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Most callers of free_pages() and free_page() cast a pointer type to
unsigned long.

Make addr parameter of free_pages() and free_page() 'void *' and update
call sites with the following semantic patch and a bit of manual tweaking.

    @@
    identifier addr;
    expression order;
    @@
    (
    - free_pages(addr, order)
    + free_pages((void *)addr, order)
    |
    - free_page(addr)
    + free_page((void *)addr)
    )

    @@
    type T != void *;
    expression addr, order;
    @@
    (
    - free_pages((T)addr, order)
    + free_pages(addr, order)
    |
    - free_page((T)addr)
    + free_page(addr)
    )

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/alpha/kernel/pci_iommu.c                 |  4 +--
 arch/alpha/kernel/srm_env.c                   |  4 +--
 arch/arc/kernel/setup.c                       |  2 +-
 arch/arm64/kvm/arm.c                          |  8 ++++--
 arch/arm64/kvm/mmu.c                          |  2 +-
 arch/arm64/kvm/nested.c                       |  2 +-
 arch/arm64/kvm/reset.c                        |  2 +-
 arch/arm64/mm/mmu.c                           |  2 +-
 arch/loongarch/kvm/main.c                     |  3 +-
 arch/loongarch/kvm/mmu.c                      |  2 +-
 arch/loongarch/kvm/vm.c                       |  4 +--
 arch/m68k/sun3/sun3dvma.c                     |  4 +--
 arch/mips/include/asm/mach-generic/floppy.h   |  2 +-
 arch/mips/include/asm/mach-jazz/floppy.h      |  2 +-
 arch/parisc/include/asm/floppy.h              |  2 +-
 arch/parisc/kernel/pci-dma.c                  |  2 +-
 arch/powerpc/include/asm/book3s/64/pgalloc.h  |  4 +--
 arch/powerpc/kernel/iommu.c                   |  4 +--
 arch/powerpc/kvm/book3s_64_mmu_hv.c           |  4 +--
 arch/powerpc/kvm/book3s_pr.c                  |  4 +--
 arch/powerpc/kvm/book3s_xive.c                |  3 +-
 arch/powerpc/kvm/booke.c                      |  2 +-
 arch/powerpc/kvm/e500.c                       |  2 +-
 arch/powerpc/kvm/e500mc.c                     |  2 +-
 arch/powerpc/mm/book3s64/subpage_prot.c       |  6 ++--
 arch/powerpc/mm/init_64.c                     |  4 +--
 arch/powerpc/perf/imc-pmu.c                   |  8 +++---
 arch/powerpc/platforms/cell/spufs/inode.c     |  3 +-
 arch/powerpc/platforms/powernv/pci-ioda-tce.c |  2 +-
 arch/powerpc/platforms/ps3/system-bus.c       |  4 +--
 .../platforms/pseries/pseries_energy.c        |  4 +--
 arch/powerpc/sysdev/xive/native.c             |  2 +-
 arch/powerpc/sysdev/xive/spapr.c              |  2 +-
 arch/riscv/kvm/aia_imsic.c                    |  6 ++--
 arch/riscv/kvm/mmu.c                          |  2 +-
 arch/riscv/kvm/nacl.c                         |  3 +-
 arch/s390/crypto/aes_s390.c                   |  2 +-
 arch/s390/crypto/des_s390.c                   |  2 +-
 arch/s390/crypto/paes_s390.c                  |  2 +-
 arch/s390/crypto/prng.c                       |  2 +-
 arch/s390/hypfs/hypfs_diag_fs.c               |  4 +--
 arch/s390/hypfs/hypfs_sprp.c                  |  6 ++--
 arch/s390/include/asm/idals.h                 |  4 +--
 arch/s390/kernel/ipl.c                        | 22 +++++++--------
 arch/s390/kernel/perf_cpum_sf.c               | 10 +++----
 arch/s390/kernel/perf_pai_crypto.c            |  6 ++--
 arch/s390/kernel/perf_pai_ext.c               |  4 +--
 arch/s390/kernel/smp.c                        |  8 +++---
 arch/s390/kernel/sthyi.c                      |  6 ++--
 arch/s390/kernel/sysinfo.c                    | 10 +++----
 arch/s390/kernel/time.c                       |  2 +-
 arch/s390/kvm/intercept.c                     |  6 ++--
 arch/s390/kvm/interrupt.c                     |  6 ++--
 arch/s390/kvm/kvm-s390.c                      | 14 +++++-----
 arch/s390/kvm/pci.c                           |  2 +-
 arch/s390/kvm/priv.c                          |  4 +--
 arch/s390/kvm/pv.c                            | 13 +++++----
 arch/s390/kvm/vsie.c                          |  2 +-
 arch/s390/mm/cmm.c                            |  8 +++---
 arch/s390/mm/gmap.c                           |  2 +-
 arch/s390/mm/maccess.c                        |  2 +-
 arch/s390/mm/vmem.c                           |  2 +-
 arch/s390/pci/pci_clp.c                       |  2 +-
 arch/s390/pci/pci_report.c                    |  2 +-
 arch/sh/boards/mach-hp6xx/pm.c                |  2 +-
 arch/sparc/kernel/iommu.c                     |  6 ++--
 arch/sparc/kernel/ldc.c                       |  6 ++--
 arch/sparc/kernel/pci_fire.c                  |  2 +-
 arch/sparc/kernel/pci_sun4v.c                 | 10 +++----
 arch/sparc/mm/io-unit.c                       |  2 +-
 arch/sparc/mm/iommu.c                         |  2 +-
 arch/um/drivers/mconsole_kern.c               |  2 +-
 arch/um/kernel/process.c                      |  2 +-
 arch/um/kernel/skas/mmu.c                     |  4 +--
 arch/x86/coco/sev/core.c                      |  4 +--
 arch/x86/events/intel/ds.c                    |  4 +--
 arch/x86/events/intel/pt.c                    |  2 +-
 arch/x86/hyperv/ivm.c                         |  4 +--
 arch/x86/include/asm/floppy.h                 |  2 +-
 arch/x86/kernel/ldt.c                         |  2 +-
 arch/x86/kernel/machine_kexec_32.c            | 10 +++----
 arch/x86/kernel/machine_kexec_64.c            |  8 +++---
 arch/x86/kvm/lapic.c                          |  2 +-
 arch/x86/kvm/mmu/mmu.c                        | 14 +++++-----
 arch/x86/kvm/mmu/tdp_mmu.c                    |  4 +--
 arch/x86/kvm/svm/avic.c                       |  4 +--
 arch/x86/kvm/svm/sev.c                        |  4 +--
 arch/x86/kvm/vmx/nested.c                     |  2 +-
 arch/x86/kvm/vmx/sgx.c                        |  4 +--
 arch/x86/kvm/vmx/vmx.c                        | 10 +++----
 arch/x86/kvm/x86.c                            |  4 +--
 arch/x86/mm/pat/set_memory.c                  |  4 +--
 arch/x86/mm/pgtable.c                         |  2 +-
 arch/x86/pci/pcbios.c                         |  2 +-
 arch/x86/platform/efi/efi.c                   |  2 +-
 arch/x86/platform/efi/efi_64.c                |  4 +--
 arch/x86/virt/svm/sev.c                       |  2 +-
 arch/x86/xen/mmu_pv.c                         |  4 +--
 arch/x86/xen/p2m.c                            |  2 +-
 arch/x86/xen/pmu.c                            |  4 +--
 arch/x86/xen/time.c                           |  4 +--
 block/partitions/core.c                       |  4 +--
 crypto/scatterwalk.c                          |  2 +-
 crypto/scompress.c                            |  2 +-
 crypto/tcrypt.c                               |  6 ++--
 crypto/testmgr.c                              |  4 +--
 crypto/xor.c                                  |  2 +-
 drivers/acpi/nvs.c                            |  2 +-
 drivers/atm/eni.c                             |  2 +-
 drivers/atm/lanai.c                           |  2 +-
 drivers/auxdisplay/cfag12864b.c               |  4 +--
 drivers/auxdisplay/ht16k33.c                  |  4 +--
 drivers/base/devres.c                         |  4 +--
 drivers/block/drbd/drbd_main.c                |  4 +--
 drivers/block/floppy.c                        |  2 +-
 drivers/block/ps3vram.c                       |  4 +--
 drivers/block/ublk_drv.c                      |  2 +-
 drivers/char/agp/agp.h                        |  2 +-
 drivers/char/agp/amd-k7-agp.c                 |  2 +-
 drivers/char/agp/ati-agp.c                    |  4 +--
 drivers/char/agp/efficeon-agp.c               |  2 +-
 drivers/char/agp/sworks-agp.c                 |  2 +-
 drivers/char/agp/uninorth-agp.c               |  4 +--
 drivers/char/hw_random/s390-trng.c            |  2 +-
 drivers/char/tpm/tpm-buf.c                    |  2 +-
 drivers/char/tpm/tpm_ibmvtpm.c                |  4 +--
 drivers/char/xilinx_hwicap/xilinx_hwicap.c    | 14 +++++-----
 drivers/char/xillybus/xillyusb.c              |  6 ++--
 drivers/comedi/comedi_buf.c                   |  2 +-
 drivers/crypto/atmel-aes.c                    |  2 +-
 drivers/crypto/atmel-tdes.c                   |  8 +++---
 drivers/crypto/ccp/tee-dev.c                  |  3 +-
 .../crypto/inside-secure/eip93/eip93-common.c |  2 +-
 drivers/crypto/nx/nx-842.c                    |  8 +++---
 drivers/crypto/omap-crypto.c                  |  2 +-
 drivers/crypto/omap-sham.c                    |  3 +-
 drivers/crypto/s5p-sss.c                      |  5 ++--
 drivers/crypto/stm32/stm32-hash.c             |  2 +-
 drivers/dma/nbpfaxi.c                         |  2 +-
 drivers/dma/sh/rcar-dmac.c                    |  2 +-
 drivers/dma/ste_dma40.c                       |  8 +++---
 drivers/extcon/extcon.c                       |  2 +-
 drivers/firewire/ohci.c                       |  6 ++--
 drivers/firmware/efi/efi.c                    |  2 +-
 drivers/firmware/psci/psci_checker.c          |  2 +-
 drivers/fsi/fsi-occ.c                         |  2 +-
 drivers/fsi/fsi-sbefifo.c                     |  2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_events.c       |  2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_process.c      |  4 +--
 drivers/gpu/drm/i915/gt/selftest_lrc.c        |  2 +-
 drivers/gpu/drm/i915/gt/uc/intel_guc_log.c    |  4 +--
 drivers/gpu/drm/i915/gvt/gtt.c                |  2 +-
 drivers/gpu/drm/i915/gvt/opregion.c           |  2 +-
 drivers/gpu/drm/i915/i915_gpu_error.c         |  2 +-
 drivers/gpu/drm/msm/msm_iommu.c               |  2 +-
 drivers/gpu/drm/panthor/panthor_mmu.c         |  2 +-
 drivers/gpu/drm/tegra/drm.c                   |  4 +--
 drivers/hsi/clients/cmt_speech.c              |  4 +--
 drivers/hv/connection.c                       |  8 ++----
 drivers/hv/hv.c                               | 10 +++----
 drivers/hv/hv_proc.c                          |  4 +--
 drivers/hv/mshv_root_hv_call.c                |  2 +-
 drivers/hv/mshv_root_main.c                   |  2 +-
 drivers/infiniband/core/umem.c                |  2 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c      | 10 +++----
 drivers/infiniband/hw/bnxt_re/main.c          |  6 ++--
 drivers/infiniband/hw/cxgb4/device.c          |  4 +--
 drivers/infiniband/hw/cxgb4/mem.c             |  2 +-
 drivers/infiniband/hw/mlx4/mr.c               |  4 +--
 drivers/infiniband/hw/mlx5/main.c             |  6 ++--
 drivers/infiniband/hw/mlx5/odp.c              |  2 +-
 drivers/infiniband/hw/mlx5/umr.c              |  2 +-
 drivers/infiniband/hw/mthca/mthca_allocator.c |  4 +--
 drivers/infiniband/hw/mthca/mthca_provider.c  |  2 +-
 drivers/infiniband/hw/qedr/verbs.c            |  4 +--
 drivers/infiniband/hw/usnic/usnic_uiom.c      |  2 +-
 drivers/infiniband/sw/rdmavt/qp.c             |  4 +--
 drivers/input/misc/xen-kbdfront.c             |  2 +-
 drivers/iommu/fsl_pamu.c                      |  2 +-
 drivers/iommu/io-pgtable-arm-v7s.c            |  4 +--
 drivers/iommu/iommufd/iova_bitmap.c           |  2 +-
 drivers/iommu/iommufd/selftest.c              |  4 +--
 drivers/irqchip/irq-gic-v3-its.c              |  2 +-
 drivers/macintosh/rack-meter.c                |  4 +--
 drivers/mailbox/riscv-sbi-mpxy-mbox.c         |  2 +-
 drivers/md/bcache/bset.c                      | 10 +++----
 drivers/md/bcache/btree.c                     |  2 +-
 drivers/md/bcache/journal.c                   |  4 +--
 drivers/md/bcache/super.c                     |  4 +--
 drivers/md/dm-bufio.c                         |  2 +-
 drivers/media/pci/intel/ipu6/ipu6-mmu.c       | 18 ++++++------
 drivers/media/pci/pt1/pt1.c                   |  4 +--
 drivers/media/pci/saa7134/saa7134-go7007.c    |  8 +++---
 drivers/media/pci/solo6x10/solo6x10-p2m.c     |  6 ++--
 drivers/media/platform/ti/omap/omap_voutlib.c |  2 +-
 drivers/misc/ibmvmc.c                         |  4 +--
 drivers/misc/lkdtm/core.c                     | 10 +++----
 drivers/misc/lkdtm/heap.c                     | 14 +++++-----
 drivers/misc/ocxl/link.c                      |  2 +-
 drivers/misc/sgi-gru/grufile.c                |  4 +--
 drivers/misc/sgi-xp/xpc_uv.c                  |  4 +--
 drivers/misc/vmw_balloon.c                    |  2 +-
 drivers/mmc/host/renesas_sdhi_sys_dmac.c      |  2 +-
 drivers/net/ethernet/amd/mvme147.c            |  4 +--
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  |  2 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_sp.c    |  2 +-
 drivers/net/ethernet/cirrus/cs89x0.c          |  3 +-
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    | 20 ++++++-------
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 14 +++++-----
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |  2 +-
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  3 +-
 drivers/net/ethernet/i825xx/82596.c           |  4 +--
 drivers/net/ethernet/ibm/ehea/ehea_main.c     | 26 ++++++++---------
 drivers/net/ethernet/ibm/ehea/ehea_qmr.c      |  8 +++---
 drivers/net/ethernet/ibm/ibmveth.c            |  8 +++---
 drivers/net/ethernet/ibm/ibmvnic.c            |  8 +++---
 drivers/net/ethernet/intel/ice/ice_gnss.c     |  2 +-
 drivers/net/ethernet/mediatek/mtk_wed.c       |  2 +-
 .../mellanox/mlx5/core/diag/fw_tracer.c       |  4 +--
 .../ethernet/mellanox/mlx5/core/lib/clock.c   |  2 +-
 drivers/net/ethernet/meta/fbnic/fbnic_fw.c    | 28 +++++++++----------
 drivers/net/ethernet/sfc/mcdi.c               |  4 +--
 drivers/net/ethernet/sfc/siena/mcdi.c         |  4 +--
 drivers/net/ethernet/sun/niu.c                |  2 +-
 .../net/ethernet/toshiba/ps3_gelic_wireless.c | 12 ++++----
 drivers/net/rionet.c                          |  7 ++---
 drivers/net/usb/kaweth.c                      |  2 +-
 drivers/net/wireless/broadcom/b43/debugfs.c   |  6 ++--
 .../net/wireless/broadcom/b43legacy/debugfs.c |  6 ++--
 drivers/net/wireless/intel/iwlegacy/common.h  |  2 +-
 .../net/wireless/intel/iwlwifi/iwl-trans.h    |  2 +-
 .../net/wireless/marvell/libertas/debugfs.c   | 16 +++++------
 .../net/wireless/marvell/mwifiex/debugfs.c    | 18 ++++++------
 drivers/net/wireless/ti/wlcore/main.c         |  8 +++---
 drivers/parisc/ccio-dma.c                     |  2 +-
 drivers/parisc/sba_iommu.c                    | 14 +++++-----
 drivers/perf/riscv_pmu_sbi.c                  |  2 +-
 drivers/platform/goldfish/goldfish_pipe.c     |  6 ++--
 drivers/platform/x86/dell/dell_rbu.c          |  9 +++---
 drivers/power/supply/power_supply_sysfs.c     |  2 +-
 drivers/ptp/ptp_kvm_x86.c                     |  2 +-
 drivers/ptp/ptp_ocp.c                         |  2 +-
 drivers/ras/cec.c                             |  2 +-
 drivers/s390/block/dasd.c                     | 12 ++++----
 drivers/s390/block/dasd_diag.c                |  2 +-
 drivers/s390/block/dasd_eckd.c                |  8 +++---
 drivers/s390/block/dasd_eer.c                 |  2 +-
 drivers/s390/block/dasd_fba.c                 |  4 +--
 drivers/s390/block/scm_blk.c                  |  2 +-
 drivers/s390/char/con3270.c                   |  6 ++--
 drivers/s390/char/diag_ftp.c                  |  2 +-
 drivers/s390/char/hmcdrv_cache.c              |  3 +-
 drivers/s390/char/hmcdrv_ftp.c                |  4 +--
 drivers/s390/char/sclp.c                      |  4 +--
 drivers/s390/char/sclp_ap.c                   |  2 +-
 drivers/s390/char/sclp_cmd.c                  |  6 ++--
 drivers/s390/char/sclp_con.c                  |  2 +-
 drivers/s390/char/sclp_config.c               |  2 +-
 drivers/s390/char/sclp_cpi_sys.c              |  2 +-
 drivers/s390/char/sclp_ctl.c                  |  2 +-
 drivers/s390/char/sclp_ftp.c                  |  4 +--
 drivers/s390/char/sclp_mem.c                  |  6 ++--
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
 drivers/s390/cio/chsc.c                       | 12 ++++----
 drivers/s390/cio/chsc_sch.c                   | 24 ++++++++--------
 drivers/s390/cio/cmf.c                        |  4 +--
 drivers/s390/cio/qdio_main.c                  | 12 ++++----
 drivers/s390/cio/qdio_setup.c                 |  6 ++--
 drivers/s390/cio/scm.c                        |  2 +-
 drivers/s390/crypto/zcrypt_api.c              |  4 +--
 drivers/s390/crypto/zcrypt_msgtype6.c         |  4 +--
 drivers/s390/net/qeth_core_main.c             |  2 +-
 drivers/s390/net/qeth_l2_main.c               |  2 +-
 drivers/s390/scsi/zfcp_fc.c                   |  2 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                |  4 +--
 drivers/scsi/ibmvscsi/ibmvscsi.c              |  4 +--
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c      |  4 +--
 drivers/scsi/ipr.c                            |  2 +-
 drivers/scsi/libiscsi.c                       |  6 ++--
 drivers/scsi/megaraid/megaraid_sas_base.c     |  2 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c   |  8 +++---
 drivers/scsi/ncr53c8xx.c                      |  2 +-
 drivers/scsi/qedi/qedi_main.c                 |  8 +++---
 drivers/scsi/scsi_devinfo.c                   |  2 +-
 drivers/scsi/scsi_proc.c                      |  4 +--
 drivers/scsi/sym53c8xx_2/sym_hipd.h           |  2 +-
 drivers/scsi/vmw_pvscsi.c                     |  5 ++--
 drivers/sh/maple/maple.c                      |  2 +-
 drivers/spi/spi-ep93xx.c                      |  4 +--
 drivers/spi/spi-rockchip-sfc.c                |  4 +--
 drivers/spi/spi-sh-msiof.c                    |  8 +++---
 .../staging/media/atomisp/pci/mmu/isp_mmu.c   |  2 +-
 drivers/staging/media/av7110/av7110_ca.c      |  2 +-
 drivers/staging/media/ipu3/ipu3-mmu.c         |  6 ++--
 drivers/staging/media/ipu7/ipu7-mmu.c         | 18 ++++++------
 drivers/target/target_core_file.c             |  2 +-
 drivers/tee/amdtee/core.c                     |  2 +-
 drivers/tee/amdtee/shm_pool.c                 |  4 +--
 drivers/thunderbolt/debugfs.c                 | 22 +++++++--------
 drivers/tty/amiserial.c                       |  6 ++--
 drivers/tty/hvc/hvc_iucv.c                    |  4 +--
 drivers/tty/hvc/hvc_xen.c                     |  2 +-
 drivers/tty/hvc/hvcs.c                        |  4 +--
 drivers/tty/serial/men_z135_uart.c            |  4 +--
 drivers/tty/serial/pch_uart.c                 |  4 +--
 drivers/tty/serial/serial_core.c              |  4 +--
 drivers/tty/tty_port.c                        |  4 +--
 drivers/usb/atm/cxacru.c                      | 10 +++----
 drivers/usb/atm/speedtch.c                    |  2 +-
 drivers/usb/core/buffer.c                     |  2 +-
 drivers/usb/core/devices.c                    |  4 +--
 drivers/usb/core/devio.c                      |  2 +-
 drivers/usb/host/ohci-dbg.c                   |  2 +-
 drivers/usb/mon/mon_bin.c                     |  4 +--
 drivers/usb/serial/usb_wwan.c                 |  4 +--
 drivers/vfio/vfio_iommu_type1.c               |  2 +-
 drivers/vhost/vdpa.c                          |  2 +-
 drivers/video/fbdev/xen-fbfront.c             |  2 +-
 drivers/virt/vboxguest/vboxguest_utils.c      |  2 +-
 drivers/xen/events/events_base.c              |  4 +--
 drivers/xen/events/events_fifo.c              |  6 ++--
 drivers/xen/evtchn.c                          |  2 +-
 drivers/xen/grant-table.c                     |  4 +--
 drivers/xen/pvcalls-front.c                   |  2 +-
 drivers/xen/swiotlb-xen.c                     |  4 +--
 drivers/xen/xenbus/xenbus_probe.c             |  2 +-
 fs/affs/inode.c                               |  2 +-
 fs/bfs/inode.c                                |  2 +-
 fs/binfmt_misc.c                              |  2 +-
 fs/ceph/mds_client.c                          |  2 +-
 fs/configfs/file.c                            |  2 +-
 fs/ecryptfs/crypto.c                          |  2 +-
 fs/ext4/super.c                               |  2 +-
 fs/fuse/ioctl.c                               |  2 +-
 fs/isofs/dir.c                                |  2 +-
 fs/jbd2/journal.c                             |  2 +-
 fs/jfs/jfs_dtree.c                            |  6 ++--
 fs/libfs.c                                    |  4 +--
 fs/namespace.c                                |  2 +-
 fs/nfs/nfs4namespace.c                        |  4 +--
 fs/nfs/super.c                                |  2 +-
 fs/nfsd/vfs.c                                 |  2 +-
 fs/nilfs2/ioctl.c                             |  2 +-
 fs/ocfs2/dlm/dlmdebug.c                       |  4 +--
 fs/ocfs2/dlm/dlmdomain.c                      |  2 +-
 fs/ocfs2/dlm/dlmmaster.c                      |  2 +-
 fs/ocfs2/dlm/dlmrecovery.c                    |  2 +-
 fs/proc/base.c                                |  8 +++---
 fs/proc/vmcore.c                              |  4 +--
 fs/select.c                                   |  2 +-
 include/linux/gfp.h                           |  4 +--
 init/do_mounts.c                              |  2 +-
 kernel/dma/swiotlb.c                          | 14 +++++-----
 kernel/kexec_handover.c                       |  4 +--
 kernel/power/swap.c                           | 10 +++----
 kernel/trace/ftrace.c                         |  6 ++--
 kernel/trace/ring_buffer.c                    | 10 +++----
 kernel/trace/trace.c                          |  2 +-
 kernel/trace/trace_sched_switch.c             |  2 +-
 kernel/trace/trace_uprobe.c                   |  5 ++--
 kernel/trace/tracing_map.c                    |  2 +-
 kernel/vmcore_info.c                          |  2 +-
 lib/raid6/algos.c                             |  2 +-
 lib/scatterlist.c                             |  2 +-
 lib/stackdepot.c                              |  2 +-
 lib/test_free_pages.c                         |  2 +-
 mm/kasan/kasan_test_c.c                       | 10 +++----
 mm/kasan/shadow.c                             |  2 +-
 mm/mincore.c                                  |  2 +-
 mm/mmu_gather.c                               |  4 +--
 mm/page_alloc.c                               | 17 ++++++-----
 mm/slab_common.c                              |  6 ++--
 mm/slub.c                                     |  4 +--
 net/9p/trans_xen.c                            |  4 +--
 net/atm/mpoa_proc.c                           |  4 +--
 net/atm/proc.c                                |  2 +-
 net/netfilter/nf_tables_api.c                 |  2 +-
 net/packet/af_packet.c                        |  3 +-
 net/rds/cong.c                                |  4 +--
 net/sctp/protocol.c                           | 10 +++----
 net/sunrpc/backchannel_rqst.c                 |  4 +--
 net/sunrpc/xprtsock.c                         |  2 +-
 net/xfrm/xfrm_hash.c                          |  2 +-
 security/apparmor/apparmorfs.c                |  2 +-
 security/integrity/ima/ima_crypto.c           |  2 +-
 security/selinux/hooks.c                      |  2 +-
 security/selinux/selinuxfs.c                  |  6 ++--
 sound/drivers/dummy.c                         |  2 +-
 virt/kvm/coalesced_mmio.c                     |  2 +-
 virt/kvm/kvm_main.c                           |  6 ++--
 399 files changed, 854 insertions(+), 875 deletions(-)

diff --git a/arch/alpha/kernel/pci_iommu.c b/arch/alpha/kernel/pci_iommu.c
index 64c750fa6b3f..d8acd9a6e910 100644
--- a/arch/alpha/kernel/pci_iommu.c
+++ b/arch/alpha/kernel/pci_iommu.c
@@ -431,7 +431,7 @@ static void *alpha_pci_alloc_coherent(struct device *dev, size_t size,
 
 	*dma_addrp = pci_map_single_1(pdev, cpu_addr, size, 0);
 	if (*dma_addrp == DMA_MAPPING_ERROR) {
-		free_pages((unsigned long)cpu_addr, order);
+		free_pages(cpu_addr, order);
 		if (alpha_mv.mv_pci_tbi || (gfp & GFP_DMA))
 			return NULL;
 		/* The address doesn't fit required mask and we
@@ -458,7 +458,7 @@ static void alpha_pci_free_coherent(struct device *dev, size_t size,
 {
 	struct pci_dev *pdev = alpha_gendev_to_pci(dev);
 	dma_unmap_single(&pdev->dev, dma_addr, size, DMA_BIDIRECTIONAL);
-	free_pages((unsigned long)cpu_addr, get_order(size));
+	free_pages(cpu_addr, get_order(size));
 
 	DBGA2("pci_free_consistent: [%llx,%zx] from %ps\n",
 	      dma_addr, size, __builtin_return_address(0));
diff --git a/arch/alpha/kernel/srm_env.c b/arch/alpha/kernel/srm_env.c
index f50c9083b78a..f10db8f044bc 100644
--- a/arch/alpha/kernel/srm_env.c
+++ b/arch/alpha/kernel/srm_env.c
@@ -77,7 +77,7 @@ static int srm_env_proc_show(struct seq_file *m, void *v)
 		ret = 0;
 	} else
 		ret = -EFAULT;
-	free_page((unsigned long)page);
+	free_page(page);
 	return ret;
 }
 
@@ -115,7 +115,7 @@ static ssize_t srm_env_proc_write(struct file *file, const char __user *buffer,
 	}
 
  out:
-	free_page((unsigned long)buf);
+	free_page(buf);
 	return res;
 }
 
diff --git a/arch/arc/kernel/setup.c b/arch/arc/kernel/setup.c
index d9548c847580..f961b5454e9e 100644
--- a/arch/arc/kernel/setup.c
+++ b/arch/arc/kernel/setup.c
@@ -604,7 +604,7 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 
 	seq_printf(m, arc_platform_smp_cpuinfo());
 
-	free_page((unsigned long)str);
+	free_page(str);
 done:
 	seq_printf(m, "\n");
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a09b9edfff50..96a26f9b9587 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2364,7 +2364,8 @@ static void __init teardown_hyp_mode(void)
 		if (per_cpu(kvm_hyp_initialized, cpu))
 			continue;
 
-		free_pages(per_cpu(kvm_arm_hyp_stack_base, cpu), NVHE_STACK_SHIFT - PAGE_SHIFT);
+		free_pages((void *)per_cpu(kvm_arm_hyp_stack_base, cpu),
+			   NVHE_STACK_SHIFT - PAGE_SHIFT);
 
 		if (!kvm_nvhe_sym(kvm_arm_hyp_percpu_base)[cpu])
 			continue;
@@ -2373,10 +2374,11 @@ static void __init teardown_hyp_mode(void)
 			struct cpu_sve_state *sve_state;
 
 			sve_state = per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)->sve_state;
-			free_pages((unsigned long) sve_state, pkvm_host_sve_state_order());
+			free_pages(sve_state, pkvm_host_sve_state_order());
 		}
 
-		free_pages(kvm_nvhe_sym(kvm_arm_hyp_percpu_base)[cpu], nvhe_percpu_order());
+		free_pages((void *)kvm_nvhe_sym(kvm_arm_hyp_percpu_base)[cpu],
+			   nvhe_percpu_order());
 
 	}
 }
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index fa59e7984554..71c13191af5c 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1093,7 +1093,7 @@ static void hyp_mc_free_fn(void *addr, void *mc)
 	if (memcache->flags & HYP_MEMCACHE_ACCOUNT_STAGE2)
 		kvm_account_pgtable_pages(addr, -1);
 
-	free_page((unsigned long)addr);
+	free_page(addr);
 }
 
 static void *hyp_mc_alloc_fn(void *mc)
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 149cd43bb02a..a257f98a2aa6 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -112,7 +112,7 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
 		for (int i = kvm->arch.nested_mmus_size; i < num_mmus; i++)
 			kvm_free_stage2_pgd(&kvm->arch.nested_mmus[i]);
 
-		free_page((unsigned long)vcpu->arch.ctxt.vncr_array);
+		free_page(vcpu->arch.ctxt.vncr_array);
 		vcpu->arch.ctxt.vncr_array = NULL;
 
 		return ret;
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 959532422d3a..473061a389b2 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -158,7 +158,7 @@ void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
 	if (sve_state)
 		kvm_unshare_hyp(sve_state, sve_state + vcpu_sve_state_size(vcpu));
 	kfree(sve_state);
-	free_page((unsigned long)vcpu->arch.ctxt.vncr_array);
+	free_page(vcpu->arch.ctxt.vncr_array);
 	kfree(vcpu->arch.vncr_tlb);
 	kfree(vcpu->arch.ccsidr);
 }
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index a8ba67cade23..e854b51b8e5c 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1188,7 +1188,7 @@ static int __init __kpti_install_ng_mappings(void *__unused)
 	cpu_uninstall_idmap();
 
 	if (!cpu) {
-		free_pages(alloc, order);
+		free_pages((void *)alloc, order);
 		arm64_use_ng_mappings = true;
 	}
 
diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
index 1e00656ea806..16bc3a809e4d 100644
--- a/arch/loongarch/kvm/main.c
+++ b/arch/loongarch/kvm/main.c
@@ -422,7 +422,8 @@ static void kvm_loongarch_env_exit(void)
 	if (kvm_loongarch_ops) {
 		if (kvm_loongarch_ops->exc_entry) {
 			addr = (unsigned long)kvm_loongarch_ops->exc_entry;
-			free_pages(addr, kvm_loongarch_ops->page_order);
+			free_pages((void *)addr,
+				   kvm_loongarch_ops->page_order);
 		}
 		kfree(kvm_loongarch_ops);
 	}
diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
index ff56ec190395..d3956344f854 100644
--- a/arch/loongarch/kvm/mmu.c
+++ b/arch/loongarch/kvm/mmu.c
@@ -319,7 +319,7 @@ static void kvm_flush_range(struct kvm *kvm, gfn_t start_gfn, gfn_t end_gfn, int
 	 */
 	list_for_each_safe(pos, temp, &ctx.list) {
 		list_del(pos);
-		free_page((unsigned long)pos);
+		free_page(pos);
 	}
 }
 
diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
index a49b1c1a3dd1..7768400553ed 100644
--- a/arch/loongarch/kvm/vm.c
+++ b/arch/loongarch/kvm/vm.c
@@ -35,7 +35,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	kvm->arch.phyid_map = kvzalloc(sizeof(struct kvm_phyid_map), GFP_KERNEL_ACCOUNT);
 	if (!kvm->arch.phyid_map) {
-		free_page((unsigned long)kvm->arch.pgd);
+		free_page(kvm->arch.pgd);
 		kvm->arch.pgd = NULL;
 		return -ENOMEM;
 	}
@@ -71,7 +71,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 void kvm_arch_destroy_vm(struct kvm *kvm)
 {
 	kvm_destroy_vcpus(kvm);
-	free_page((unsigned long)kvm->arch.pgd);
+	free_page(kvm->arch.pgd);
 	kvm->arch.pgd = NULL;
 	kvfree(kvm->arch.phyid_map);
 	kvm->arch.phyid_map = NULL;
diff --git a/arch/m68k/sun3/sun3dvma.c b/arch/m68k/sun3/sun3dvma.c
index b81ab0a20788..c97278667014 100644
--- a/arch/m68k/sun3/sun3dvma.c
+++ b/arch/m68k/sun3/sun3dvma.c
@@ -330,7 +330,7 @@ void *dvma_malloc_align(unsigned long len, unsigned long align)
 		return NULL;
 
 	if((baddr = (unsigned long)dvma_map_align(kaddr, len, align)) == 0) {
-		free_pages(kaddr, get_order(len));
+		free_pages((void *)kaddr, get_order(len));
 		return NULL;
 	}
 
@@ -338,7 +338,7 @@ void *dvma_malloc_align(unsigned long len, unsigned long align)
 
 	if(dvma_map_cpu(kaddr, vaddr, len) < 0) {
 		dvma_unmap((void *)baddr);
-		free_pages(kaddr, get_order(len));
+		free_pages((void *)kaddr, get_order(len));
 		return NULL;
 	}
 
diff --git a/arch/mips/include/asm/mach-generic/floppy.h b/arch/mips/include/asm/mach-generic/floppy.h
index e0c9cd41f9b9..410e9445dd8b 100644
--- a/arch/mips/include/asm/mach-generic/floppy.h
+++ b/arch/mips/include/asm/mach-generic/floppy.h
@@ -119,7 +119,7 @@ static inline unsigned long fd_dma_mem_alloc(unsigned long size)
 
 static inline void fd_dma_mem_free(unsigned long addr, unsigned long size)
 {
-	free_pages(addr, get_order(size));
+	free_pages((void *)addr, get_order(size));
 }
 
 static inline unsigned long fd_drive_type(unsigned long n)
diff --git a/arch/mips/include/asm/mach-jazz/floppy.h b/arch/mips/include/asm/mach-jazz/floppy.h
index 294ebb834632..2bb8a9c25397 100644
--- a/arch/mips/include/asm/mach-jazz/floppy.h
+++ b/arch/mips/include/asm/mach-jazz/floppy.h
@@ -116,7 +116,7 @@ static inline unsigned long fd_dma_mem_alloc(unsigned long size)
 static inline void fd_dma_mem_free(unsigned long addr, unsigned long size)
 {
 	vdma_free(vdma_phys2log(CPHYSADDR(addr)));
-	free_pages(addr, get_order(size));
+	free_pages((void *)addr, get_order(size));
 }
 
 static inline unsigned long fd_drive_type(unsigned long n)
diff --git a/arch/parisc/include/asm/floppy.h b/arch/parisc/include/asm/floppy.h
index f15b69fea901..f626eab83490 100644
--- a/arch/parisc/include/asm/floppy.h
+++ b/arch/parisc/include/asm/floppy.h
@@ -167,7 +167,7 @@ static void _fd_dma_mem_free(unsigned long addr, unsigned long size)
 	if((unsigned int) addr >= (unsigned int) high_memory)
 		return vfree((void *)addr);
 	else
-		free_pages(addr, get_order(size));		
+		free_pages((void *)addr, get_order(size));		
 }
 
 #define fd_dma_mem_free(addr, size)  _fd_dma_mem_free(addr, size) 
diff --git a/arch/parisc/kernel/pci-dma.c b/arch/parisc/kernel/pci-dma.c
index 8f7e777b9ce2..9b87908ebdc9 100644
--- a/arch/parisc/kernel/pci-dma.c
+++ b/arch/parisc/kernel/pci-dma.c
@@ -432,7 +432,7 @@ void arch_dma_free(struct device *dev, size_t size, void *vaddr,
 	unmap_uncached_pages((unsigned long)vaddr, size);
 	pcxl_free_range((unsigned long)vaddr, size);
 
-	free_pages((unsigned long)__va(dma_handle), order);
+	free_pages(__va(dma_handle), order);
 }
 
 void arch_sync_dma_for_device(phys_addr_t paddr, size_t size,
diff --git a/arch/powerpc/include/asm/book3s/64/pgalloc.h b/arch/powerpc/include/asm/book3s/64/pgalloc.h
index 94ed0c4bdbe2..9f24f6fce7f1 100644
--- a/arch/powerpc/include/asm/book3s/64/pgalloc.h
+++ b/arch/powerpc/include/asm/book3s/64/pgalloc.h
@@ -39,9 +39,9 @@ static inline pgd_t *radix__pgd_alloc(struct mm_struct *mm)
 static inline void radix__pgd_free(struct mm_struct *mm, pgd_t *pgd)
 {
 #ifdef CONFIG_PPC_64K_PAGES
-	free_page((unsigned long)pgd);
+	free_page(pgd);
 #else
-	free_pages((unsigned long)pgd, 4);
+	free_pages(pgd, 4);
 #endif
 }
 
diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index 244eb4857e7f..caac9cf7c2e1 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -951,7 +951,7 @@ void *iommu_alloc_coherent(struct device *dev, struct iommu_table *tbl,
 	mapping = iommu_alloc(dev, tbl, ret, nio_pages, DMA_BIDIRECTIONAL,
 			      mask >> tbl->it_page_shift, io_order, 0);
 	if (mapping == DMA_MAPPING_ERROR) {
-		free_pages((unsigned long)ret, order);
+		free_pages(ret, order);
 		return NULL;
 	}
 
@@ -969,7 +969,7 @@ void iommu_free_coherent(struct iommu_table *tbl, size_t size,
 		nio_pages = IOMMU_PAGE_ALIGN(size, tbl) >> tbl->it_page_shift;
 		iommu_free(tbl, dma_handle, nio_pages);
 		size = PAGE_ALIGN(size);
-		free_pages((unsigned long)vaddr, get_order(size));
+		free_pages(vaddr, get_order(size));
 	}
 }
 
diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index a3189a88a1e5..28c807902b7d 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -103,7 +103,7 @@ int kvmppc_allocate_hpt(struct kvm_hpt_info *info, u32 order)
 		if (cma)
 			kvm_free_hpt_cma(page, 1 << (order - PAGE_SHIFT));
 		else
-			free_pages(hpt, order - PAGE_SHIFT);
+			free_pages((void *)hpt, order - PAGE_SHIFT);
 		return -ENOMEM;
 	}
 
@@ -186,7 +186,7 @@ void kvmppc_free_hpt(struct kvm_hpt_info *info)
 		kvm_free_hpt_cma(virt_to_page((void *)info->virt),
 				 1 << (info->order - PAGE_SHIFT));
 	else if (info->virt)
-		free_pages(info->virt, info->order - PAGE_SHIFT);
+		free_pages((void *)info->virt, info->order - PAGE_SHIFT);
 	info->virt = 0;
 	info->order = 0;
 }
diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index 2106679a6e55..1672bc340fcb 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -1782,7 +1782,7 @@ static int kvmppc_core_vcpu_create_pr(struct kvm_vcpu *vcpu)
 	return 0;
 
 free_shared_page:
-	free_page((unsigned long)vcpu->arch.shared);
+	free_page(vcpu->arch.shared);
 free_shadow_vcpu:
 #ifdef CONFIG_KVM_BOOK3S_32_HANDLER
 	kfree(vcpu->arch.shadow_vcpu);
@@ -1798,7 +1798,7 @@ static void kvmppc_core_vcpu_free_pr(struct kvm_vcpu *vcpu)
 	struct kvmppc_vcpu_book3s *vcpu_book3s = to_book3s(vcpu);
 
 	kvmppc_mmu_destroy_pr(vcpu);
-	free_page((unsigned long)vcpu->arch.shared & PAGE_MASK);
+	free_page(vcpu->arch.shared);
 #ifdef CONFIG_KVM_BOOK3S_32_HANDLER
 	kfree(vcpu->arch.shadow_vcpu);
 #endif
diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xive.c
index 63fe0995a922..5ef9fc50d1c8 100644
--- a/arch/powerpc/kvm/book3s_xive.c
+++ b/arch/powerpc/kvm/book3s_xive.c
@@ -1845,8 +1845,7 @@ void kvmppc_xive_cleanup_vcpu(struct kvm_vcpu *vcpu)
 
 		xive_native_disable_queue(xc->vp_id, q, i);
 		if (q->qpage) {
-			free_pages((unsigned long)q->qpage,
-				   xive->q_page_order);
+			free_pages(q->qpage, xive->q_page_order);
 			q->qpage = NULL;
 		}
 	}
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index 5b9fafd28fe9..33a2e59d8729 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -2237,6 +2237,6 @@ int __init kvmppc_booke_init(void)
 
 void __exit kvmppc_booke_exit(void)
 {
-	free_pages(kvmppc_booke_handlers, VCPU_SIZE_ORDER);
+	free_pages((void *)kvmppc_booke_handlers, VCPU_SIZE_ORDER);
 	kvm_exit();
 }
diff --git a/arch/powerpc/kvm/e500.c b/arch/powerpc/kvm/e500.c
index b1d79d446eea..1fca4aafe482 100644
--- a/arch/powerpc/kvm/e500.c
+++ b/arch/powerpc/kvm/e500.c
@@ -467,7 +467,7 @@ static void kvmppc_core_vcpu_free_e500(struct kvm_vcpu *vcpu)
 {
 	struct kvmppc_vcpu_e500 *vcpu_e500 = to_e500(vcpu);
 
-	free_page((unsigned long)vcpu->arch.shared);
+	free_page(vcpu->arch.shared);
 	kvmppc_e500_tlb_uninit(vcpu_e500);
 	kvmppc_e500_id_table_free(vcpu_e500);
 }
diff --git a/arch/powerpc/kvm/e500mc.c b/arch/powerpc/kvm/e500mc.c
index 1e1c0013b498..7fb7408d6308 100644
--- a/arch/powerpc/kvm/e500mc.c
+++ b/arch/powerpc/kvm/e500mc.c
@@ -338,7 +338,7 @@ static void kvmppc_core_vcpu_free_e500mc(struct kvm_vcpu *vcpu)
 {
 	struct kvmppc_vcpu_e500 *vcpu_e500 = to_e500(vcpu);
 
-	free_page((unsigned long)vcpu->arch.shared);
+	free_page(vcpu->arch.shared);
 	kvmppc_e500_tlb_uninit(vcpu_e500);
 }
 
diff --git a/arch/powerpc/mm/book3s64/subpage_prot.c b/arch/powerpc/mm/book3s64/subpage_prot.c
index 237ae658d19c..f760603ba680 100644
--- a/arch/powerpc/mm/book3s64/subpage_prot.c
+++ b/arch/powerpc/mm/book3s64/subpage_prot.c
@@ -30,7 +30,7 @@ void subpage_prot_free(struct mm_struct *mm)
 
 	for (i = 0; i < 4; ++i) {
 		if (spt->low_prot[i]) {
-			free_page((unsigned long)spt->low_prot[i]);
+			free_page(spt->low_prot[i]);
 			spt->low_prot[i] = NULL;
 		}
 	}
@@ -43,8 +43,8 @@ void subpage_prot_free(struct mm_struct *mm)
 		for (j = 0; j < SBP_L2_COUNT && addr < spt->maxaddr;
 		     ++j, addr += PAGE_SIZE)
 			if (p[j])
-				free_page((unsigned long)p[j]);
-		free_page((unsigned long)p);
+				free_page(p[j]);
+		free_page(p);
 	}
 	spt->maxaddr = 0;
 	kfree(spt);
diff --git a/arch/powerpc/mm/init_64.c b/arch/powerpc/mm/init_64.c
index b6f3ae03ca9e..0f707414d3c0 100644
--- a/arch/powerpc/mm/init_64.c
+++ b/arch/powerpc/mm/init_64.c
@@ -256,7 +256,7 @@ static int __meminit __vmemmap_populate(unsigned long start, unsigned long end,
 			if (altmap_alloc)
 				vmem_altmap_free(altmap, nr_pfns);
 			else
-				free_pages((unsigned long)p, page_order);
+				free_pages(p, page_order);
 			return -ENOMEM;
 		}
 
@@ -369,7 +369,7 @@ static void __ref __vmemmap_free(unsigned long start, unsigned long end,
 					free_reserved_page(page++);
 			}
 		} else {
-			free_pages((unsigned long)(__va(addr)), page_order);
+			free_pages(__va(addr), page_order);
 		}
 
 		vmemmap_remove_mapping(start, page_size);
diff --git a/arch/powerpc/perf/imc-pmu.c b/arch/powerpc/perf/imc-pmu.c
index 8664a7d297ad..2f7c33542fd5 100644
--- a/arch/powerpc/perf/imc-pmu.c
+++ b/arch/powerpc/perf/imc-pmu.c
@@ -625,7 +625,7 @@ static int core_imc_mem_init(int cpu, int size)
 				__pa((void *)mem_info->vbase),
 				get_hard_smp_processor_id(cpu));
 	if (rc) {
-		free_pages((u64)mem_info->vbase, get_order(size));
+		free_pages(mem_info->vbase, get_order(size));
 		mem_info->vbase = NULL;
 	}
 
@@ -1575,7 +1575,7 @@ static void cleanup_all_core_imc_memory(void)
 	/* mem_info will never be NULL */
 	for (i = 0; i < nr_cores; i++) {
 		if (ptr[i].vbase)
-			free_pages((u64)ptr[i].vbase, get_order(size));
+			free_pages(ptr[i].vbase, get_order(size));
 	}
 
 	kfree(ptr);
@@ -1602,7 +1602,7 @@ static void cleanup_all_thread_imc_memory(void)
 
 	for_each_online_cpu(i) {
 		if (per_cpu(thread_imc_mem, i))
-			free_pages((u64)per_cpu(thread_imc_mem, i), order);
+			free_pages(per_cpu(thread_imc_mem, i), order);
 
 	}
 }
@@ -1613,7 +1613,7 @@ static void cleanup_all_trace_imc_memory(void)
 
 	for_each_online_cpu(i) {
 		if (per_cpu(trace_imc_mem, i))
-			free_pages((u64)per_cpu(trace_imc_mem, i), order);
+			free_pages(per_cpu(trace_imc_mem, i), order);
 
 	}
 	kfree(trace_imc_refc);
diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
index f6f134ac2a06..81015ef297d2 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -657,8 +657,7 @@ static int spufs_parse_param(struct fs_context *fc, struct fs_parameter *param)
 
 static void spufs_exit_isolated_loader(void)
 {
-	free_pages((unsigned long) isolated_loader,
-			get_order(isolated_loader_size));
+	free_pages(isolated_loader, get_order(isolated_loader_size));
 }
 
 static void __init
diff --git a/arch/powerpc/platforms/powernv/pci-ioda-tce.c b/arch/powerpc/platforms/powernv/pci-ioda-tce.c
index e96324502db0..50b0a4afe73c 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda-tce.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda-tce.c
@@ -234,7 +234,7 @@ static void pnv_pci_ioda2_table_do_free_pages(__be64 *addr,
 		}
 	}
 
-	free_pages(addr_ul, get_order(size << 3));
+	free_pages((void *)addr_ul, get_order(size << 3));
 }
 
 void pnv_pci_ioda2_table_free_pages(struct iommu_table *tbl)
diff --git a/arch/powerpc/platforms/ps3/system-bus.c b/arch/powerpc/platforms/ps3/system-bus.c
index 9a55cc51460c..8b31b420cde8 100644
--- a/arch/powerpc/platforms/ps3/system-bus.c
+++ b/arch/powerpc/platforms/ps3/system-bus.c
@@ -534,7 +534,7 @@ static void * ps3_alloc_coherent(struct device *_dev, size_t size,
 	return (void*)virt_addr;
 
 clean_alloc:
-	free_pages(virt_addr, get_order(size));
+	free_pages((void *)virt_addr, get_order(size));
 clean_none:
 	dma_handle = NULL;
 	return NULL;
@@ -546,7 +546,7 @@ static void ps3_free_coherent(struct device *_dev, size_t size, void *vaddr,
 	struct ps3_system_bus_device *dev = ps3_dev_to_system_bus_dev(_dev);
 
 	ps3_dma_unmap(dev->d_region, dma_handle, size);
-	free_pages((unsigned long)vaddr, get_order(size));
+	free_pages(vaddr, get_order(size));
 }
 
 /* Creates TCEs for a user provided buffer.  The user buffer must be
diff --git a/arch/powerpc/platforms/pseries/pseries_energy.c b/arch/powerpc/platforms/pseries/pseries_energy.c
index b628dc9991eb..3b657f640f0a 100644
--- a/arch/powerpc/platforms/pseries/pseries_energy.c
+++ b/arch/powerpc/platforms/pseries/pseries_energy.c
@@ -204,7 +204,7 @@ static ssize_t get_best_energy_list(char *page, int activate)
 	rc = plpar_hcall9(H_BEST_ENERGY, retbuf, flags, 0, __pa(buf_page),
 				0, 0, 0, 0, 0, 0);
 	if (rc != H_SUCCESS) {
-		free_page((unsigned long) buf_page);
+		free_page(buf_page);
 		return -EINVAL;
 	}
 
@@ -220,7 +220,7 @@ static ssize_t get_best_energy_list(char *page, int activate)
 		s += sprintf(s, "\n");
 	}
 
-	free_page((unsigned long) buf_page);
+	free_page(buf_page);
 	return s-page;
 }
 
diff --git a/arch/powerpc/sysdev/xive/native.c b/arch/powerpc/sysdev/xive/native.c
index a0934b516933..1379768ef9fc 100644
--- a/arch/powerpc/sysdev/xive/native.c
+++ b/arch/powerpc/sysdev/xive/native.c
@@ -237,7 +237,7 @@ static void xive_native_cleanup_queue(unsigned int cpu, struct xive_cpu *xc, u8
 	 */
 	__xive_native_disable_queue(get_hard_smp_processor_id(cpu), q, prio);
 	alloc_order = xive_alloc_order(xive_queue_shift);
-	free_pages((unsigned long)q->qpage, alloc_order);
+	free_pages(q->qpage, alloc_order);
 	q->qpage = NULL;
 }
 
diff --git a/arch/powerpc/sysdev/xive/spapr.c b/arch/powerpc/sysdev/xive/spapr.c
index 5aedbe3e8e6a..d703938c55fc 100644
--- a/arch/powerpc/sysdev/xive/spapr.c
+++ b/arch/powerpc/sysdev/xive/spapr.c
@@ -558,7 +558,7 @@ static void xive_spapr_cleanup_queue(unsigned int cpu, struct xive_cpu *xc,
 	alloc_order = xive_alloc_order(xive_queue_shift);
 	if (is_secure_guest())
 		uv_unshare_page(PHYS_PFN(__pa(q->qpage)), 1 << alloc_order);
-	free_pages((unsigned long)q->qpage, alloc_order);
+	free_pages(q->qpage, alloc_order);
 	q->qpage = NULL;
 }
 
diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
index fda0346f0ea1..68ec05fdef0e 100644
--- a/arch/riscv/kvm/aia_imsic.c
+++ b/arch/riscv/kvm/aia_imsic.c
@@ -1111,8 +1111,7 @@ int kvm_riscv_vcpu_aia_imsic_init(struct kvm_vcpu *vcpu)
 	return 0;
 
 fail_free_swfile:
-	free_pages((unsigned long)imsic->swfile,
-		   get_order(sizeof(*imsic->swfile)));
+	free_pages(imsic->swfile, get_order(sizeof(*imsic->swfile)));
 fail_free_imsic:
 	vcpu->arch.aia_context.imsic_state = NULL;
 	kfree(imsic);
@@ -1133,8 +1132,7 @@ void kvm_riscv_vcpu_aia_imsic_cleanup(struct kvm_vcpu *vcpu)
 	kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS, &imsic->iodev);
 	mutex_unlock(&kvm->slots_lock);
 
-	free_pages((unsigned long)imsic->swfile,
-		   get_order(sizeof(*imsic->swfile)));
+	free_pages(imsic->swfile, get_order(sizeof(*imsic->swfile)));
 
 	vcpu->arch.aia_context.imsic_state = NULL;
 	kfree(imsic);
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 525fb5a330c0..26a2b2ec5660 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -472,7 +472,7 @@ void kvm_riscv_mmu_free_pgd(struct kvm *kvm)
 	spin_unlock(&kvm->mmu_lock);
 
 	if (pgd)
-		free_pages((unsigned long)pgd, get_order(kvm_riscv_gstage_pgd_size));
+		free_pages(pgd, get_order(kvm_riscv_gstage_pgd_size));
 }
 
 void kvm_riscv_mmu_update_hgatp(struct kvm_vcpu *vcpu)
diff --git a/arch/riscv/kvm/nacl.c b/arch/riscv/kvm/nacl.c
index 08a95ad9ada2..2fe74103317c 100644
--- a/arch/riscv/kvm/nacl.c
+++ b/arch/riscv/kvm/nacl.c
@@ -92,8 +92,7 @@ void kvm_riscv_nacl_exit(void)
 		if (!nacl->shmem)
 			continue;
 
-		free_pages((unsigned long)nacl->shmem,
-			   get_order(SBI_NACL_SHMEM_SIZE));
+		free_pages(nacl->shmem, get_order(SBI_NACL_SHMEM_SIZE));
 		nacl->shmem = NULL;
 		nacl->shmem_phys = 0;
 	}
diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index fe3c9d0aa60b..c63159e12c4a 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -1072,7 +1072,7 @@ static void aes_s390_fini(void)
 	while (aes_s390_skciphers_num--)
 		crypto_unregister_skcipher(aes_s390_skcipher_algs[aes_s390_skciphers_num]);
 	if (ctrblk)
-		free_page((unsigned long) ctrblk);
+		free_page(ctrblk);
 
 	if (aes_s390_aead_alg)
 		crypto_unregister_aead(aes_s390_aead_alg);
diff --git a/arch/s390/crypto/des_s390.c b/arch/s390/crypto/des_s390.c
index 78e7b6ff22da..5f5ea6a278eb 100644
--- a/arch/s390/crypto/des_s390.c
+++ b/arch/s390/crypto/des_s390.c
@@ -427,7 +427,7 @@ static void des_s390_exit(void)
 	while (des_s390_skciphers_num--)
 		crypto_unregister_skcipher(des_s390_skciphers_ptr[des_s390_skciphers_num]);
 	if (ctrblk)
-		free_page((unsigned long) ctrblk);
+		free_page(ctrblk);
 }
 
 static int __init des_s390_init(void)
diff --git a/arch/s390/crypto/paes_s390.c b/arch/s390/crypto/paes_s390.c
index c1a9d4e515c6..2c8267f5b57f 100644
--- a/arch/s390/crypto/paes_s390.c
+++ b/arch/s390/crypto/paes_s390.c
@@ -1617,7 +1617,7 @@ static void paes_s390_fini(void)
 	__crypto_unregister_skcipher(&cbc_paes_alg);
 	__crypto_unregister_skcipher(&ecb_paes_alg);
 	if (ctrblk)
-		free_page((unsigned long)ctrblk);
+		free_page(ctrblk);
 	misc_deregister(&paes_dev);
 }
 
diff --git a/arch/s390/crypto/prng.c b/arch/s390/crypto/prng.c
index 143ec756f609..1ef3e4acbe38 100644
--- a/arch/s390/crypto/prng.c
+++ b/arch/s390/crypto/prng.c
@@ -177,7 +177,7 @@ static int generate_entropy(u8 *ebuf, size_t nbytes)
 
 	memzero_explicit(pblock, sizeof(pblock));
 	memzero_explicit(pg, PAGE_SIZE);
-	free_page((unsigned long)pg);
+	free_page(pg);
 	return ret;
 }
 
diff --git a/arch/s390/hypfs/hypfs_diag_fs.c b/arch/s390/hypfs/hypfs_diag_fs.c
index dbd6752bfa84..b5309cb8cf15 100644
--- a/arch/s390/hypfs/hypfs_diag_fs.c
+++ b/arch/s390/hypfs/hypfs_diag_fs.c
@@ -371,7 +371,7 @@ static int diag224_get_name_table(void)
 	if (!diag224_cpu_names)
 		return -ENOMEM;
 	if (diag224(diag224_cpu_names)) {
-		free_page((unsigned long)diag224_cpu_names);
+		free_page(diag224_cpu_names);
 		return -EOPNOTSUPP;
 	}
 	EBCASC(diag224_cpu_names + 16, (*diag224_cpu_names + 1) * 16);
@@ -380,7 +380,7 @@ static int diag224_get_name_table(void)
 
 static void diag224_delete_name_table(void)
 {
-	free_page((unsigned long)diag224_cpu_names);
+	free_page(diag224_cpu_names);
 }
 
 int __init __hypfs_diag_fs_init(void)
diff --git a/arch/s390/hypfs/hypfs_sprp.c b/arch/s390/hypfs/hypfs_sprp.c
index 82eba1438656..cfd0da286c29 100644
--- a/arch/s390/hypfs/hypfs_sprp.c
+++ b/arch/s390/hypfs/hypfs_sprp.c
@@ -42,7 +42,7 @@ static unsigned long hypfs_sprp_diag304(void *data, unsigned long cmd)
 
 static void hypfs_sprp_free(const void *data)
 {
-	free_page((unsigned long) data);
+	free_page((void *)data);
 }
 
 static int hypfs_sprp_create(void **data_ptr, void **free_ptr, size_t *size)
@@ -57,7 +57,7 @@ static int hypfs_sprp_create(void **data_ptr, void **free_ptr, size_t *size)
 	if (rc != 1) {
 		*data_ptr = *free_ptr = NULL;
 		*size = 0;
-		free_page((unsigned long) data);
+		free_page(data);
 		return -EIO;
 	}
 	*data_ptr = *free_ptr = data;
@@ -105,7 +105,7 @@ static int __hypfs_sprp_ioctl(void __user *user_area)
 	rc = copy_to_user(user_area, diag304, sizeof(*diag304)) ? -EFAULT : 0;
 out:
 	kfree(diag304);
-	free_page((unsigned long) data);
+	free_page(data);
 	return rc;
 }
 
diff --git a/arch/s390/include/asm/idals.h b/arch/s390/include/asm/idals.h
index a09fdcaf2a5f..0faf1dcf25e0 100644
--- a/arch/s390/include/asm/idals.h
+++ b/arch/s390/include/asm/idals.h
@@ -157,7 +157,7 @@ static inline struct idal_buffer *idal_buffer_alloc(size_t size, int page_order)
 	while (i >= nr_chunks) {
 		i -= nr_chunks;
 		vaddr = dma64_to_virt(ib->data[i]);
-		free_pages((unsigned long)vaddr, ib->page_order);
+		free_pages(vaddr, ib->page_order);
 	}
 	kfree(ib);
 	return ERR_PTR(-ENOMEM);
@@ -175,7 +175,7 @@ static inline void idal_buffer_free(struct idal_buffer *ib)
 	nr_chunks = (PAGE_SIZE << ib->page_order) >> IDA_SIZE_SHIFT;
 	for (i = 0; i < nr_ptrs; i += nr_chunks) {
 		vaddr = dma64_to_virt(ib->data[i]);
-		free_pages((unsigned long)vaddr, ib->page_order);
+		free_pages(vaddr, ib->page_order);
 	}
 	kfree(ib);
 }
diff --git a/arch/s390/kernel/ipl.c b/arch/s390/kernel/ipl.c
index 0549fbdacc37..c63f7375c54c 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -1307,7 +1307,7 @@ static int __init reipl_ccw_init(void)
 {
 	int rc;
 
-	reipl_block_ccw = (void *) get_zeroed_page(GFP_KERNEL);
+	reipl_block_ccw = get_zeroed_page(GFP_KERNEL);
 	if (!reipl_block_ccw)
 		return -ENOMEM;
 
@@ -1340,7 +1340,7 @@ static int __init reipl_fcp_init(void)
 	reipl_fcp_kset = kset_create_and_add(IPL_FCP_STR, NULL,
 					     &reipl_kset->kobj);
 	if (!reipl_fcp_kset) {
-		free_page((unsigned long) reipl_block_fcp);
+		free_page(reipl_block_fcp);
 		return -ENOMEM;
 	}
 
@@ -1380,7 +1380,7 @@ static int __init reipl_fcp_init(void)
 	sysfs_remove_group(&reipl_fcp_kset->kobj, &reipl_fcp_attr_group);
 out1:
 	kset_unregister(reipl_fcp_kset);
-	free_page((unsigned long) reipl_block_fcp);
+	free_page(reipl_block_fcp);
 	return rc;
 }
 
@@ -1396,7 +1396,7 @@ static int __init reipl_nvme_init(void)
 	reipl_nvme_kset = kset_create_and_add(IPL_NVME_STR, NULL,
 					     &reipl_kset->kobj);
 	if (!reipl_nvme_kset) {
-		free_page((unsigned long) reipl_block_nvme);
+		free_page(reipl_block_nvme);
 		return -ENOMEM;
 	}
 
@@ -1436,7 +1436,7 @@ static int __init reipl_nvme_init(void)
 	sysfs_remove_group(&reipl_nvme_kset->kobj, &reipl_nvme_attr_group);
 out1:
 	kset_unregister(reipl_nvme_kset);
-	free_page((unsigned long) reipl_block_nvme);
+	free_page(reipl_block_nvme);
 	return rc;
 }
 
@@ -1455,7 +1455,7 @@ static int __init reipl_eckd_init(void)
 	reipl_eckd_kset = kset_create_and_add(IPL_ECKD_STR, NULL,
 					      &reipl_kset->kobj);
 	if (!reipl_eckd_kset) {
-		free_page((unsigned long)reipl_block_eckd);
+		free_page(reipl_block_eckd);
 		return -ENOMEM;
 	}
 
@@ -1488,7 +1488,7 @@ static int __init reipl_eckd_init(void)
 	sysfs_remove_group(&reipl_eckd_kset->kobj, &reipl_eckd_attr_group);
 out1:
 	kset_unregister(reipl_eckd_kset);
-	free_page((unsigned long)reipl_block_eckd);
+	free_page(reipl_block_eckd);
 	return rc;
 }
 
@@ -1785,7 +1785,7 @@ static int __init dump_ccw_init(void)
 		return -ENOMEM;
 	rc = sysfs_create_group(&dump_kset->kobj, &dump_ccw_attr_group);
 	if (rc) {
-		free_page((unsigned long)dump_block_ccw);
+		free_page(dump_block_ccw);
 		return rc;
 	}
 	dump_block_ccw->hdr.len = IPL_BP_CCW_LEN;
@@ -1807,7 +1807,7 @@ static int __init dump_fcp_init(void)
 		return -ENOMEM;
 	rc = sysfs_create_group(&dump_kset->kobj, &dump_fcp_attr_group);
 	if (rc) {
-		free_page((unsigned long)dump_block_fcp);
+		free_page(dump_block_fcp);
 		return rc;
 	}
 	dump_block_fcp->hdr.len = IPL_BP_FCP_LEN;
@@ -1830,7 +1830,7 @@ static int __init dump_nvme_init(void)
 		return -ENOMEM;
 	rc = sysfs_create_group(&dump_kset->kobj, &dump_nvme_attr_group);
 	if (rc) {
-		free_page((unsigned long)dump_block_nvme);
+		free_page(dump_block_nvme);
 		return rc;
 	}
 	dump_block_nvme->hdr.len = IPL_BP_NVME_LEN;
@@ -1853,7 +1853,7 @@ static int __init dump_eckd_init(void)
 		return -ENOMEM;
 	rc = sysfs_create_group(&dump_kset->kobj, &dump_eckd_attr_group);
 	if (rc) {
-		free_page((unsigned long)dump_block_eckd);
+		free_page(dump_block_eckd);
 		return rc;
 	}
 	dump_block_eckd->hdr.len = IPL_BP_ECKD_LEN;
diff --git a/arch/s390/kernel/perf_cpum_sf.c b/arch/s390/kernel/perf_cpum_sf.c
index 7d8ad44a571d..52fda02bf05a 100644
--- a/arch/s390/kernel/perf_cpum_sf.c
+++ b/arch/s390/kernel/perf_cpum_sf.c
@@ -192,11 +192,11 @@ static void free_sampling_buffer(struct sf_buffer *sfb)
 		if (is_link_entry(curr)) {
 			/* Process table-link entries */
 			curr = get_next_sdbt(curr);
-			free_page((unsigned long)sdbt);
+			free_page(sdbt);
 			sdbt = curr;
 		} else {
 			/* Process SDB pointer */
-			free_page((unsigned long)phys_to_virt(*curr));
+			free_page(phys_to_virt(*curr));
 			curr++;
 		}
 	} while (curr != head);
@@ -292,7 +292,7 @@ static int realloc_sampling_buffer(struct sf_buffer *sfb,
 			 */
 			if (tail_prev) {
 				sfb->num_sdbt--;
-				free_page((unsigned long)new);
+				free_page(new);
 				tail = tail_prev;
 			}
 			break;
@@ -1554,7 +1554,7 @@ static void aux_buffer_free(void *data)
 	/* Free SDBT. SDB is freed by the caller */
 	num_sdbt = aux->sfb.num_sdbt;
 	for (i = 0; i < num_sdbt; i++)
-		free_page(aux->sdbt_index[i]);
+		free_page((void *)aux->sdbt_index[i]);
 
 	kfree(aux->sdbt_index);
 	kfree(aux->sdb_index);
@@ -1671,7 +1671,7 @@ static void *aux_buffer_setup(struct perf_event *event, void **pages,
 no_sdbt:
 	/* SDBs (AUX buffer pages) are freed by caller */
 	for (i = 0; i < sfb->num_sdbt; i++)
-		free_page(aux->sdbt_index[i]);
+		free_page((void *)aux->sdbt_index[i]);
 	kfree(aux->sdb_index);
 no_sdb_index:
 	kfree(aux->sdbt_index);
diff --git a/arch/s390/kernel/perf_pai_crypto.c b/arch/s390/kernel/perf_pai_crypto.c
index 89907fa516a5..0527acb3263e 100644
--- a/arch/s390/kernel/perf_pai_crypto.c
+++ b/arch/s390/kernel/perf_pai_crypto.c
@@ -83,7 +83,7 @@ static DEFINE_MUTEX(pai_reserve_mutex);
 /* Free all memory allocated for event counting/sampling setup */
 static void paicrypt_free(struct paicrypt_mapptr *mp)
 {
-	free_page((unsigned long)mp->mapptr->page);
+	free_page(mp->mapptr->page);
 	kvfree(mp->mapptr->save);
 	kfree(mp->mapptr);
 	mp->mapptr = NULL;
@@ -113,7 +113,7 @@ static void paicrypt_event_destroy(struct perf_event *event)
 	int cpu;
 
 	static_branch_dec(&pai_key);
-	free_page(PAI_SAVE_AREA(event));
+	free_page((void *)PAI_SAVE_AREA(event));
 	if (event->cpu == -1) {
 		struct cpumask *mask = PAI_CPU_MASK(event);
 
@@ -293,7 +293,7 @@ static int paicrypt_event_init(struct perf_event *event)
 	else
 		rc = paicrypt_alloc(event);
 	if (rc) {
-		free_page(PAI_SAVE_AREA(event));
+		free_page((void *)PAI_SAVE_AREA(event));
 		goto out;
 	}
 	event->destroy = paicrypt_event_destroy;
diff --git a/arch/s390/kernel/perf_pai_ext.c b/arch/s390/kernel/perf_pai_ext.c
index ec3cb99aa659..62f37c4aa862 100644
--- a/arch/s390/kernel/perf_pai_ext.c
+++ b/arch/s390/kernel/perf_pai_ext.c
@@ -132,7 +132,7 @@ static void paiext_event_destroy(struct perf_event *event)
 {
 	int cpu;
 
-	free_page(PAI_SAVE_AREA(event));
+	free_page((void *)PAI_SAVE_AREA(event));
 	if (event->cpu == -1) {
 		struct cpumask *mask = PAI_CPU_MASK(event);
 
@@ -301,7 +301,7 @@ static int paiext_event_init(struct perf_event *event)
 	else
 		rc = paiext_alloc(event);
 	if (rc) {
-		free_page(PAI_SAVE_AREA(event));
+		free_page((void *)PAI_SAVE_AREA(event));
 		return rc;
 	}
 	event->destroy = paiext_event_destroy;
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 0bc4d836f794..a11adc9eabc9 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -217,8 +217,8 @@ static int pcpu_alloc_lowcore(struct pcpu *pcpu, int cpu)
 out:
 	stack_free(mcck_stack);
 	stack_free(async_stack);
-	free_pages(nodat_stack, THREAD_SIZE_ORDER);
-	free_pages((unsigned long) lc, LC_ORDER);
+	free_pages((void *)nodat_stack, THREAD_SIZE_ORDER);
+	free_pages(lc, LC_ORDER);
 	return -ENOMEM;
 }
 
@@ -237,8 +237,8 @@ static void pcpu_free_lowcore(struct pcpu *pcpu, int cpu)
 	nmi_free_mcesa(&lc->mcesad);
 	stack_free(async_stack);
 	stack_free(mcck_stack);
-	free_pages(nodat_stack, THREAD_SIZE_ORDER);
-	free_pages((unsigned long) lc, LC_ORDER);
+	free_pages((void *)nodat_stack, THREAD_SIZE_ORDER);
+	free_pages(lc, LC_ORDER);
 }
 
 static void pcpu_prepare_secondary(struct pcpu *pcpu, int cpu)
diff --git a/arch/s390/kernel/sthyi.c b/arch/s390/kernel/sthyi.c
index d6140ad14a42..075565bb8599 100644
--- a/arch/s390/kernel/sthyi.c
+++ b/arch/s390/kernel/sthyi.c
@@ -225,7 +225,7 @@ static void fill_stsi(struct sthyi_sctns *sctns)
 	fill_stsi_mac(sctns, sysinfo);
 	fill_stsi_par(sctns, sysinfo);
 
-	free_pages((unsigned long)sysinfo, 0);
+	free_pages(sysinfo, 0);
 }
 
 static void fill_diag_mac(struct sthyi_sctns *sctns,
@@ -417,7 +417,7 @@ static void fill_diag(struct sthyi_sctns *sctns, void *diag204_buf)
 	sctns->par.infpval1 |= PAR_WGHT_VLD;
 
 out:
-	free_page((unsigned long)diag224_buf);
+	free_page(diag224_buf);
 }
 
 static int sthyi(u64 vaddr, u64 *rc)
@@ -551,6 +551,6 @@ SYSCALL_DEFINE4(s390_sthyi, unsigned long, function_code, void __user *, buffer,
 	if (copy_to_user(buffer, info, PAGE_SIZE))
 		r = -EFAULT;
 out:
-	free_page((unsigned long)info);
+	free_page(info);
 	return r;
 }
diff --git a/arch/s390/kernel/sysinfo.c b/arch/s390/kernel/sysinfo.c
index 01b2ef34a1d1..57b8a937c2d2 100644
--- a/arch/s390/kernel/sysinfo.c
+++ b/arch/s390/kernel/sysinfo.c
@@ -270,7 +270,7 @@ static int sysinfo_show(struct seq_file *m, void *v)
 		stsi_2_2_2(m, info);
 	if (level >= 3)
 		stsi_3_2_2(m, info);
-	free_page((unsigned long)info);
+	free_page(info);
 	return 0;
 }
 
@@ -427,7 +427,7 @@ void s390_adjust_jiffies(void)
 		 */
 		capability = 42;
 	loops_per_jiffy = capability * (500000/HZ);
-	free_page((unsigned long) info);
+	free_page(info);
 }
 
 /*
@@ -447,11 +447,11 @@ void calibrate_delay(void)
 #define STSI_FILE(fc, s1, s2)						       \
 static int stsi_open_##fc##_##s1##_##s2(struct inode *inode, struct file *file)\
 {									       \
-	file->private_data = (void *) get_zeroed_page(GFP_KERNEL);	       \
+	file->private_data = get_zeroed_page(GFP_KERNEL);		       \
 	if (!file->private_data)					       \
 		return -ENOMEM;						       \
 	if (stsi(file->private_data, fc, s1, s2)) {			       \
-		free_page((unsigned long)file->private_data);		       \
+		free_page(file->private_data);				       \
 		file->private_data = NULL;				       \
 		return -EACCES;						       \
 	}								       \
@@ -466,7 +466,7 @@ static const struct file_operations stsi_##fc##_##s1##_##s2##_fs_ops = {       \
 
 static int stsi_release(struct inode *inode, struct file *file)
 {
-	free_page((unsigned long)file->private_data);
+	free_page(file->private_data);
 	return 0;
 }
 
diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index 5640e94a04c1..12ad34bf2e35 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -423,7 +423,7 @@ static void __init stp_reset(void)
 	if (rc == 0)
 		set_bit(CLOCK_SYNC_HAS_STP, &clock_sync_flags);
 	else if (stp_online) {
-		free_page((unsigned long) stp_page);
+		free_page(stp_page);
 		stp_page = NULL;
 		stp_online = false;
 	}
diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index d5da89b9e05b..1628b1e5ba87 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -437,7 +437,7 @@ int handle_sthyi(struct kvm_vcpu *vcpu)
 
 	cc = sthyi_fill(sctns, &rc);
 	if (cc < 0) {
-		free_page((unsigned long)sctns);
+		free_page(sctns);
 		return cc;
 	}
 out:
@@ -447,13 +447,13 @@ int handle_sthyi(struct kvm_vcpu *vcpu)
 		} else {
 			r = write_guest(vcpu, addr, reg2, sctns, PAGE_SIZE);
 			if (r) {
-				free_page((unsigned long)sctns);
+				free_page(sctns);
 				return kvm_s390_inject_prog_cond(vcpu, r);
 			}
 		}
 	}
 
-	free_page((unsigned long)sctns);
+	free_page(sctns);
 	vcpu->run->s.regs.gprs[reg2 + 1] = rc;
 	kvm_s390_set_psw_cc(vcpu, cc);
 	return r;
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 23ccf27395d1..8112e645d2a3 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -3426,7 +3426,7 @@ void kvm_s390_gib_destroy(void)
 	}
 	chsc_sgib(0);
 	unregister_adapter_interrupt(&gib_alert_irq);
-	free_page((unsigned long)gib);
+	free_page(gib);
 	gib = NULL;
 }
 
@@ -3459,7 +3459,7 @@ int __init kvm_s390_gib_init(u8 nisc)
 	gib_origin = virt_to_phys(gib);
 	if (chsc_sgib(gib_origin)) {
 		pr_err("Associating the GIB with the AIV facility failed\n");
-		free_page((unsigned long)gib);
+		free_page(gib);
 		gib = NULL;
 		rc = -EIO;
 		goto out_unreg_gal;
@@ -3479,7 +3479,7 @@ int __init kvm_s390_gib_init(u8 nisc)
 out_unreg_gal:
 	unregister_adapter_interrupt(&gib_alert_irq);
 out_free_gib:
-	free_page((unsigned long)gib);
+	free_page(gib);
 	gib = NULL;
 out:
 	return rc;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 8bacea966156..9fbb42649915 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3320,7 +3320,7 @@ static void sca_dispose(struct kvm *kvm)
 	if (kvm->arch.use_esca)
 		free_pages_exact(kvm->arch.sca, sizeof(struct esca_block));
 	else
-		free_page((unsigned long)(kvm->arch.sca));
+		free_page(kvm->arch.sca);
 	kvm->arch.sca = NULL;
 }
 
@@ -3473,7 +3473,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	return 0;
 out_err:
-	free_page((unsigned long)kvm->arch.sie_page2);
+	free_page(kvm->arch.sie_page2);
 	debug_unregister(kvm->arch.dbf);
 	sca_dispose(kvm);
 	KVM_EVENT(3, "creation of vm failed: %d", rc);
@@ -3500,7 +3500,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	/* We can not hold the vcpu mutex here, we are already dying */
 	if (kvm_s390_pv_cpu_get_handle(vcpu))
 		kvm_s390_pv_destroy_cpu(vcpu, &rc, &rrc);
-	free_page((unsigned long)(vcpu->arch.sie_block));
+	free_page(vcpu->arch.sie_block);
 }
 
 void kvm_arch_destroy_vm(struct kvm *kvm)
@@ -3526,7 +3526,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 		mmu_notifier_unregister(&kvm->arch.pv.mmu_notifier, kvm->mm);
 
 	debug_unregister(kvm->arch.dbf);
-	free_page((unsigned long)kvm->arch.sie_page2);
+	free_page(kvm->arch.sie_page2);
 	if (!kvm_is_ucontrol(kvm))
 		gmap_remove(kvm->arch.gmap);
 	kvm_s390_destroy_adapters(kvm);
@@ -3651,7 +3651,7 @@ static int sca_switch_to_extended(struct kvm *kvm)
 	write_unlock(&kvm->arch.sca_lock);
 	kvm_s390_vcpu_unblock_all(kvm);
 
-	free_page((unsigned long)old_sca);
+	free_page(old_sca);
 
 	VM_EVENT(kvm, 2, "Switched to ESCA (0x%p -> 0x%p)",
 		 old_sca, kvm->arch.sca);
@@ -3857,7 +3857,7 @@ static void kvm_s390_vcpu_crypto_setup(struct kvm_vcpu *vcpu)
 
 void kvm_s390_vcpu_unsetup_cmma(struct kvm_vcpu *vcpu)
 {
-	free_page((unsigned long)phys_to_virt(vcpu->arch.sie_block->cbrlo));
+	free_page(phys_to_virt(vcpu->arch.sie_block->cbrlo));
 	vcpu->arch.sie_block->cbrlo = 0;
 }
 
@@ -4045,7 +4045,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	if (kvm_is_ucontrol(vcpu->kvm))
 		gmap_remove(vcpu->arch.gmap);
 out_free_sie_block:
-	free_page((unsigned long)(vcpu->arch.sie_block));
+	free_page(vcpu->arch.sie_block);
 	return rc;
 }
 
diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
index 8c40154ff50f..b15b4dca812f 100644
--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -87,7 +87,7 @@ static int zpci_setup_aipb(u8 nisc)
 	return 0;
 
 free_gait:
-	free_pages((unsigned long)aift->gait, size);
+	free_pages(aift->gait, size);
 free_sbv:
 	airq_iv_release(aift->sbv);
 	zpci_aif_sbv = NULL;
diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index c031f7b628a9..799d08a906ee 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -979,14 +979,14 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
 		rc = -EREMOTE;
 	}
 	trace_kvm_s390_handle_stsi(vcpu, fc, sel1, sel2, operand2);
-	free_page(mem);
+	free_page((void *)mem);
 	kvm_s390_set_psw_cc(vcpu, 0);
 	vcpu->run->s.regs.gprs[0] = 0;
 	return rc;
 out_no_data:
 	kvm_s390_set_psw_cc(vcpu, 3);
 out:
-	free_page(mem);
+	free_page((void *)mem);
 	return rc;
 }
 
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index e8050eca6cb4..d534f34f3351 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -138,10 +138,10 @@ int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
 
 	/* Intended memory leak for something that should never happen. */
 	if (!cc)
-		free_pages(vcpu->arch.pv.stor_base,
+		free_pages((void *)vcpu->arch.pv.stor_base,
 			   get_order(uv_info.guest_cpu_stor_len));
 
-	free_page((unsigned long)sida_addr(vcpu->arch.sie_block));
+	free_page(sida_addr(vcpu->arch.sie_block));
 	vcpu->arch.sie_block->pv_handle_cpu = 0;
 	vcpu->arch.sie_block->pv_handle_config = 0;
 	memset(&vcpu->arch.pv, 0, sizeof(vcpu->arch.pv));
@@ -185,7 +185,7 @@ int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
 	/* Alloc Secure Instruction Data Area Designation */
 	sida_addr = __get_free_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 	if (!sida_addr) {
-		free_pages(vcpu->arch.pv.stor_base,
+		free_pages((void *)vcpu->arch.pv.stor_base,
 			   get_order(uv_info.guest_cpu_stor_len));
 		return -ENOMEM;
 	}
@@ -219,7 +219,7 @@ int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
 static void kvm_s390_pv_dealloc_vm(struct kvm *kvm)
 {
 	vfree(kvm->arch.pv.stor_var);
-	free_pages(kvm->arch.pv.stor_base,
+	free_pages((void *)kvm->arch.pv.stor_base,
 		   get_order(uv_info.guest_base_stor_len));
 	kvm_s390_clear_pv_state(kvm);
 }
@@ -294,8 +294,9 @@ static int kvm_s390_pv_dispose_one_leftover(struct kvm *kvm,
 	 * This can only happen in case of a serious KVM or hardware bug; it
 	 * is not expected to happen in normal operation.
 	 */
-	free_pages(leftover->stor_base, get_order(uv_info.guest_base_stor_len));
-	free_pages(leftover->old_gmap_table, CRST_ALLOC_ORDER);
+	free_pages((void *)leftover->stor_base,
+		   get_order(uv_info.guest_base_stor_len));
+	free_pages((void *)leftover->old_gmap_table, CRST_ALLOC_ORDER);
 	vfree(leftover->stor_var);
 done_fast:
 	atomic_dec(&kvm->mm->context.protected_count);
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 3961ea83aea5..c42aa59727fb 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -1541,7 +1541,7 @@ void kvm_s390_vsie_destroy(struct kvm *kvm)
 		if (vsie_page->scb_gpa != ULONG_MAX)
 			radix_tree_delete(&kvm->arch.vsie.addr_to_page,
 					  vsie_page->scb_gpa >> 9);
-		free_page((unsigned long)vsie_page);
+		free_page(vsie_page);
 	}
 	kvm->arch.vsie.page_count = 0;
 	mutex_unlock(&kvm->arch.vsie.mutex);
diff --git a/arch/s390/mm/cmm.c b/arch/s390/mm/cmm.c
index 7212ab4f0eaa..48fc3bc3a366 100644
--- a/arch/s390/mm/cmm.c
+++ b/arch/s390/mm/cmm.c
@@ -77,7 +77,7 @@ static long cmm_alloc_pages(long nr, long *counter,
 			npa =
 				__get_free_page(GFP_NOIO);
 			if (!npa) {
-				free_page(addr);
+				free_page((void *)addr);
 				break;
 			}
 			spin_lock(&cmm_lock);
@@ -88,7 +88,7 @@ static long cmm_alloc_pages(long nr, long *counter,
 				pa = npa;
 				*list = pa;
 			} else
-				free_page((unsigned long) npa);
+				free_page(npa);
 		}
 		diag10_range(virt_to_pfn((void *)addr), 1);
 		pa->pages[pa->index++] = addr;
@@ -113,10 +113,10 @@ static long __cmm_free_pages(long nr, long *counter, struct cmm_page_array **lis
 		addr = pa->pages[--pa->index];
 		if (pa->index == 0) {
 			pa = pa->next;
-			free_page((unsigned long) *list);
+			free_page(*list);
 			*list = pa;
 		}
-		free_page(addr);
+		free_page((void *)addr);
 		(*counter)--;
 		nr--;
 	}
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 8ff6bba107e8..c8c85d3dba80 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -213,7 +213,7 @@ static void gmap_free_crst(unsigned long *table, bool free_ptes)
 	}
 
 out:
-	free_pages((unsigned long)table, CRST_ALLOC_ORDER);
+	free_pages(table, CRST_ALLOC_ORDER);
 }
 
 /**
diff --git a/arch/s390/mm/maccess.c b/arch/s390/mm/maccess.c
index 4aa41186615d..765dd81c1c67 100644
--- a/arch/s390/mm/maccess.c
+++ b/arch/s390/mm/maccess.c
@@ -190,5 +190,5 @@ void *xlate_dev_mem_ptr(phys_addr_t addr)
 void unxlate_dev_mem_ptr(phys_addr_t addr, void *ptr)
 {
 	if (addr != virt_to_phys(ptr))
-		free_page((unsigned long)ptr);
+		free_page(ptr);
 }
diff --git a/arch/s390/mm/vmem.c b/arch/s390/mm/vmem.c
index 05eaabb0402f..a3c8972d2338 100644
--- a/arch/s390/mm/vmem.c
+++ b/arch/s390/mm/vmem.c
@@ -47,7 +47,7 @@ static void vmem_free_pages(unsigned long addr, int order, struct vmem_altmap *a
 	if (!slab_is_available() ||
 	    WARN_ON_ONCE(PageReserved(virt_to_page((void *)addr))))
 		return;
-	free_pages(addr, order);
+	free_pages((void *)addr, order);
 }
 
 void *vmem_crst_alloc(unsigned long val)
diff --git a/arch/s390/pci/pci_clp.c b/arch/s390/pci/pci_clp.c
index d56914baa06d..23b4d9548869 100644
--- a/arch/s390/pci/pci_clp.c
+++ b/arch/s390/pci/pci_clp.c
@@ -98,7 +98,7 @@ static void *clp_alloc_block(gfp_t gfp_mask)
 
 static void clp_free_block(void *ptr)
 {
-	free_pages((unsigned long) ptr, get_order(CLP_BLK_SIZE));
+	free_pages(ptr, get_order(CLP_BLK_SIZE));
 }
 
 static void clp_store_query_pci_fngrp(struct zpci_dev *zdev,
diff --git a/arch/s390/pci/pci_report.c b/arch/s390/pci/pci_report.c
index ec261a9acb12..32e3f4debb85 100644
--- a/arch/s390/pci/pci_report.c
+++ b/arch/s390/pci/pci_report.c
@@ -152,7 +152,7 @@ int zpci_report_status(struct zpci_dev *zdev, const char *operation, const char
 	else
 		pr_info("Reported PCI device status\n");
 
-	free_page((unsigned long)report);
+	free_page(report);
 
 	return ret;
 }
diff --git a/arch/sh/boards/mach-hp6xx/pm.c b/arch/sh/boards/mach-hp6xx/pm.c
index 0d048cf9ea3b..0e46690e6cc0 100644
--- a/arch/sh/boards/mach-hp6xx/pm.c
+++ b/arch/sh/boards/mach-hp6xx/pm.c
@@ -79,7 +79,7 @@ static void pm_enter(void)
 
 	asm volatile("ldc %0, vbr" : : "r" (vbr_old));
 
-	free_page(vbr_new);
+	free_page((void *)vbr_new);
 
 	/* enable PLL1 */
 	frqcr = __raw_readw(FRQCR);
diff --git a/arch/sparc/kernel/iommu.c b/arch/sparc/kernel/iommu.c
index da0363692528..4347342235e2 100644
--- a/arch/sparc/kernel/iommu.c
+++ b/arch/sparc/kernel/iommu.c
@@ -143,7 +143,7 @@ int iommu_table_init(struct iommu *iommu, int tsbsize,
 	return 0;
 
 out_free_dummy_page:
-	free_page(iommu->dummy_page);
+	free_page((void *)iommu->dummy_page);
 	iommu->dummy_page = 0UL;
 
 out_free_map:
@@ -223,7 +223,7 @@ static void *dma_4u_alloc_coherent(struct device *dev, size_t size,
 	iopte = alloc_npages(dev, iommu, size >> IO_PAGE_SHIFT);
 
 	if (unlikely(iopte == NULL)) {
-		free_pages(first_page, order);
+		free_pages((void *)first_page, order);
 		return NULL;
 	}
 
@@ -257,7 +257,7 @@ static void dma_4u_free_coherent(struct device *dev, size_t size,
 
 	order = get_order(size);
 	if (order < 10)
-		free_pages((unsigned long)cpu, order);
+		free_pages(cpu, order);
 }
 
 static dma_addr_t dma_4u_map_page(struct device *dev, struct page *page,
diff --git a/arch/sparc/kernel/ldc.c b/arch/sparc/kernel/ldc.c
index c7fbb5b3e245..5b45262a4ad4 100644
--- a/arch/sparc/kernel/ldc.c
+++ b/arch/sparc/kernel/ldc.c
@@ -1006,7 +1006,7 @@ static void free_queue(unsigned long num_entries, struct ldc_packet *q)
 	size = num_entries * LDC_PACKET_SIZE;
 	order = get_order(size);
 
-	free_pages((unsigned long)q, order);
+	free_pages(q, order);
 }
 
 static unsigned long ldc_cookie_to_index(u64 cookie, void *arg)
@@ -1087,7 +1087,7 @@ static int ldc_iommu_init(const char *name, struct ldc_channel *lp)
 	return 0;
 
 out_free_table:
-	free_pages((unsigned long) table, order);
+	free_pages(table, order);
 	ldc_iommu->page_table = NULL;
 
 out_free_map:
@@ -1109,7 +1109,7 @@ static void ldc_iommu_release(struct ldc_channel *lp)
 	tsbsize = num_tsb_entries * sizeof(struct ldc_mtable_entry);
 	order = get_order(tsbsize);
 
-	free_pages((unsigned long) ldc_iommu->page_table, order);
+	free_pages(ldc_iommu->page_table, order);
 	ldc_iommu->page_table = NULL;
 
 	kfree(iommu->map);
diff --git a/arch/sparc/kernel/pci_fire.c b/arch/sparc/kernel/pci_fire.c
index 2215d6c88ace..66688d19351b 100644
--- a/arch/sparc/kernel/pci_fire.c
+++ b/arch/sparc/kernel/pci_fire.c
@@ -269,7 +269,7 @@ static void pci_fire_msiq_free(struct pci_pbm_info *pbm)
 	order = get_order(512 * 1024);
 	pages = (unsigned long) pbm->msi_queues;
 
-	free_pages(pages, order);
+	free_pages((void *)pages, order);
 
 	pbm->msi_queues = NULL;
 }
diff --git a/arch/sparc/kernel/pci_sun4v.c b/arch/sparc/kernel/pci_sun4v.c
index 0a6462db97f6..713c1bd38a31 100644
--- a/arch/sparc/kernel/pci_sun4v.c
+++ b/arch/sparc/kernel/pci_sun4v.c
@@ -252,7 +252,7 @@ static void *dma_4v_alloc_coherent(struct device *dev, size_t size,
 	iommu_tbl_range_free(tbl, *dma_addrp, npages, IOMMU_ERROR_CODE);
 
 range_alloc_fail:
-	free_pages(first_page, order);
+	free_pages((void *)first_page, order);
 	return NULL;
 }
 
@@ -349,7 +349,7 @@ static void dma_4v_free_coherent(struct device *dev, size_t size, void *cpu,
 	iommu_tbl_range_free(tbl, dvma, npages, IOMMU_ERROR_CODE);
 	order = get_order(size);
 	if (order < 10)
-		free_pages((unsigned long)cpu, order);
+		free_pages(cpu, order);
 }
 
 static dma_addr_t dma_4v_map_page(struct device *dev, struct page *page,
@@ -791,7 +791,7 @@ static int pci_sun4v_atu_alloc_iotsb(struct pci_pbm_info *pbm)
 	return 0;
 
 iotsb_conf_failed:
-	free_pages((unsigned long)table, order);
+	free_pages(table, order);
 table_failed:
 	kfree(iotsb);
 out_err:
@@ -1103,7 +1103,7 @@ static int pci_sun4v_msiq_alloc(struct pci_pbm_info *pbm)
 	return 0;
 
 h_error:
-	free_pages(pages, order);
+	free_pages((void *)pages, order);
 	return -EINVAL;
 }
 
@@ -1124,7 +1124,7 @@ static void pci_sun4v_msiq_free(struct pci_pbm_info *pbm)
 
 	pages = (unsigned long) pbm->msi_queues;
 
-	free_pages(pages, order);
+	free_pages((void *)pages, order);
 
 	pbm->msi_queues = NULL;
 }
diff --git a/arch/sparc/mm/io-unit.c b/arch/sparc/mm/io-unit.c
index e5d309844c18..531d289a64aa 100644
--- a/arch/sparc/mm/io-unit.c
+++ b/arch/sparc/mm/io-unit.c
@@ -263,7 +263,7 @@ static void *iounit_alloc(struct device *dev, size_t len,
 	return (void *)ret;
 
 out_free_pages:
-	free_pages(va, get_order(len));
+	free_pages((void *)va, get_order(len));
 	return NULL;
 }
 
diff --git a/arch/sparc/mm/iommu.c b/arch/sparc/mm/iommu.c
index b6036dc4af95..f29a5c45d692 100644
--- a/arch/sparc/mm/iommu.c
+++ b/arch/sparc/mm/iommu.c
@@ -388,7 +388,7 @@ static void *sbus_iommu_alloc(struct device *dev, size_t len,
 	return (void *)ret;
 
 out_free_pages:
-	free_pages(va, get_order(len));
+	free_pages((void *)va, get_order(len));
 	return NULL;
 }
 
diff --git a/arch/um/drivers/mconsole_kern.c b/arch/um/drivers/mconsole_kern.c
index ff4bda95b9c7..f3d329b1549e 100644
--- a/arch/um/drivers/mconsole_kern.c
+++ b/arch/um/drivers/mconsole_kern.c
@@ -337,7 +337,7 @@ static int mem_config(char *str, char **error_out)
 				unplug_index = UNPLUGGED_PER_PAGE;
 			}
 
-			free_page((unsigned long) addr);
+			free_page(addr);
 			unplugged_pages_count--;
 		}
 		else {
diff --git a/arch/um/kernel/process.c b/arch/um/kernel/process.c
index 69815997db28..45f3e100aa1f 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -48,7 +48,7 @@ EXPORT_SYMBOL(cpu_tasks);
 
 void free_stack(unsigned long stack, int order)
 {
-	free_pages(stack, order);
+	free_pages((void *)stack, order);
 }
 
 unsigned long alloc_stack(int order, int atomic)
diff --git a/arch/um/kernel/skas/mmu.c b/arch/um/kernel/skas/mmu.c
index a4312704cf0f..3d0380d965c5 100644
--- a/arch/um/kernel/skas/mmu.c
+++ b/arch/um/kernel/skas/mmu.c
@@ -51,7 +51,7 @@ int init_new_context(struct task_struct *task, struct mm_struct *mm)
 	return 0;
 
  out_free:
-	free_pages(new_id->stack, ilog2(STUB_DATA_PAGES));
+	free_pages((void *)new_id->stack, ilog2(STUB_DATA_PAGES));
  out:
 	return ret;
 }
@@ -82,7 +82,7 @@ void destroy_context(struct mm_struct *mm)
 	if (using_seccomp && mmu->id.sock)
 		os_close_file(mmu->id.sock);
 
-	free_pages(mmu->id.stack, ilog2(STUB_DATA_PAGES));
+	free_pages((void *)mmu->id.stack, ilog2(STUB_DATA_PAGES));
 
 	guard(spinlock_irqsave)(&mm_list_lock);
 
diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 9ae3b11754e6..7b5abe4d3112 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -796,7 +796,7 @@ static void snp_cleanup_vmsa(struct sev_es_save_area *vmsa, int apic_id)
 	if (err)
 		pr_err("clear VMSA page failed (%u), leaking page\n", err);
 	else
-		free_page((unsigned long)vmsa);
+		free_page(vmsa);
 }
 
 static void set_pte_enc(pte_t *kpte, int level, void *va)
@@ -1130,7 +1130,7 @@ static int wakeup_cpu_via_vmgexit(u32 apic_id, unsigned long start_ip, unsigned
 	ret = snp_set_vmsa(vmsa, caa, apic_id, true);
 	if (ret) {
 		pr_err("set VMSA page failed (%u)\n", ret);
-		free_page((unsigned long)vmsa);
+		free_page(vmsa);
 
 		return -EINVAL;
 	}
diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index c0b7ac1c7594..8fda0ac51928 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -611,10 +611,10 @@ static void *dsalloc_pages(size_t size, gfp_t flags, int cpu)
 	return page ? page_address(page) : NULL;
 }
 
-static void dsfree_pages(const void *buffer, size_t size)
+static void dsfree_pages(void *buffer, size_t size)
 {
 	if (buffer)
-		free_pages((unsigned long)buffer, get_order(size));
+		free_pages(buffer, get_order(size));
 }
 
 static int alloc_pebs_buffer(int cpu)
diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index e8cf29d2b10c..35009013e8a3 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -707,7 +707,7 @@ static struct topa *topa_alloc(int cpu, gfp_t gfp)
  */
 static void topa_free(struct topa *topa)
 {
-	free_page((unsigned long)topa);
+	free_page(topa);
 }
 
 /**
diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
index c95e089b3e6a..df1f1bffbb86 100644
--- a/arch/x86/hyperv/ivm.c
+++ b/arch/x86/hyperv/ivm.c
@@ -288,7 +288,7 @@ static void snp_cleanup_vmsa(struct sev_es_save_area *vmsa)
 	if (err)
 		pr_err("clear VMSA page failed (%u), leaking page\n", err);
 	else
-		free_page((unsigned long)vmsa);
+		free_page(vmsa);
 }
 
 int hv_snp_boot_ap(u32 apic_id, unsigned long start_ip, unsigned int cpu)
@@ -349,7 +349,7 @@ int hv_snp_boot_ap(u32 apic_id, unsigned long start_ip, unsigned int cpu)
 	ret = snp_set_vmsa(vmsa, true);
 	if (ret) {
 		pr_err("RMPADJUST(%llx) failed: %llx\n", (u64)vmsa, ret);
-		free_page((u64)vmsa);
+		free_page(vmsa);
 		return ret;
 	}
 
diff --git a/arch/x86/include/asm/floppy.h b/arch/x86/include/asm/floppy.h
index e7a244051c62..65a480e87a82 100644
--- a/arch/x86/include/asm/floppy.h
+++ b/arch/x86/include/asm/floppy.h
@@ -168,7 +168,7 @@ static void _fd_dma_mem_free(unsigned long addr, unsigned long size)
 	if ((unsigned long)addr >= (unsigned long)high_memory)
 		vfree((void *)addr);
 	else
-		free_pages(addr, get_order(size));
+		free_pages((void *)addr, get_order(size));
 }
 
 #define fd_dma_mem_free(addr, size)  _fd_dma_mem_free(addr, size)
diff --git a/arch/x86/kernel/ldt.c b/arch/x86/kernel/ldt.c
index e7afcffc121a..039891429c1c 100644
--- a/arch/x86/kernel/ldt.c
+++ b/arch/x86/kernel/ldt.c
@@ -440,7 +440,7 @@ static void free_ldt_struct(struct ldt_struct *ldt)
 	if (ldt->nr_entries * LDT_ENTRY_SIZE > PAGE_SIZE)
 		vfree_atomic(ldt->entries);
 	else
-		free_page((unsigned long)ldt->entries);
+		free_page(ldt->entries);
 	kfree(ldt);
 }
 
diff --git a/arch/x86/kernel/machine_kexec_32.c b/arch/x86/kernel/machine_kexec_32.c
index c2a2e729f20a..17a7e66dc169 100644
--- a/arch/x86/kernel/machine_kexec_32.c
+++ b/arch/x86/kernel/machine_kexec_32.c
@@ -42,17 +42,17 @@ static void load_segments(void)
 
 static void machine_kexec_free_page_tables(struct kimage *image)
 {
-	free_pages((unsigned long)image->arch.pgd, pgd_allocation_order());
+	free_pages(image->arch.pgd, pgd_allocation_order());
 	image->arch.pgd = NULL;
 #ifdef CONFIG_X86_PAE
-	free_page((unsigned long)image->arch.pmd0);
+	free_page(image->arch.pmd0);
 	image->arch.pmd0 = NULL;
-	free_page((unsigned long)image->arch.pmd1);
+	free_page(image->arch.pmd1);
 	image->arch.pmd1 = NULL;
 #endif
-	free_page((unsigned long)image->arch.pte0);
+	free_page(image->arch.pte0);
 	image->arch.pte0 = NULL;
-	free_page((unsigned long)image->arch.pte1);
+	free_page(image->arch.pte1);
 	image->arch.pte1 = NULL;
 }
 
diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index 05785d2d018f..cb4c86628e85 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -150,13 +150,13 @@ map_efi_systab(struct x86_mapping_info *info, pgd_t *level4p)
 
 static void free_transition_pgtable(struct kimage *image)
 {
-	free_page((unsigned long)image->arch.p4d);
+	free_page(image->arch.p4d);
 	image->arch.p4d = NULL;
-	free_page((unsigned long)image->arch.pud);
+	free_page(image->arch.pud);
 	image->arch.pud = NULL;
-	free_page((unsigned long)image->arch.pmd);
+	free_page(image->arch.pmd);
 	image->arch.pmd = NULL;
-	free_page((unsigned long)image->arch.pte);
+	free_page(image->arch.pte);
 	image->arch.pte = NULL;
 }
 
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 42435f6f86a0..739c33a450e7 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2628,7 +2628,7 @@ void kvm_free_lapic(struct kvm_vcpu *vcpu)
 		static_branch_slow_dec_deferred(&apic_sw_disabled);
 
 	if (apic->regs)
-		free_page((unsigned long)apic->regs);
+		free_page(apic->regs);
 
 	kfree(apic);
 }
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index be916ba93ac9..7c97df40304b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1822,8 +1822,8 @@ static void kvm_mmu_free_shadow_page(struct kvm_mmu_page *sp)
 
 	hlist_del(&sp->hash_link);
 	list_del(&sp->link);
-	free_page((unsigned long)sp->spt);
-	free_page((unsigned long)sp->shadowed_translation);
+	free_page(sp->spt);
+	free_page(sp->shadowed_translation);
 	kmem_cache_free(mmu_page_header_cache, sp);
 }
 
@@ -4234,9 +4234,9 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
 
 #ifdef CONFIG_X86_64
 err_pml5:
-	free_page((unsigned long)pml4_root);
+	free_page(pml4_root);
 err_pml4:
-	free_page((unsigned long)pae_root);
+	free_page(pae_root);
 	return -ENOMEM;
 #endif
 }
@@ -6543,9 +6543,9 @@ static void free_mmu_pages(struct kvm_mmu *mmu)
 {
 	if (!tdp_enabled && mmu->pae_root)
 		set_memory_encrypted((unsigned long)mmu->pae_root, 1);
-	free_page((unsigned long)mmu->pae_root);
-	free_page((unsigned long)mmu->pml4_root);
-	free_page((unsigned long)mmu->pml5_root);
+	free_page(mmu->pae_root);
+	free_page(mmu->pml4_root);
+	free_page(mmu->pml5_root);
 }
 
 static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 65ca2d4a3ee1..b1e3ffe95261 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -55,8 +55,8 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 
 static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
 {
-	free_page((unsigned long)sp->external_spt);
-	free_page((unsigned long)sp->spt);
+	free_page(sp->external_spt);
+	free_page(sp->spt);
 	kmem_cache_free(mmu_page_header_cache, sp);
 }
 
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 6649fa1e72f6..4a3fe25bfa25 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -255,8 +255,8 @@ void avic_vm_destroy(struct kvm *kvm)
 	if (!enable_apicv)
 		return;
 
-	free_page((unsigned long)kvm_svm->avic_logical_id_table);
-	free_page((unsigned long)kvm_svm->avic_physical_id_table);
+	free_page(kvm_svm->avic_logical_id_table);
+	free_page(kvm_svm->avic_physical_id_table);
 
 	spin_lock_irqsave(&svm_vm_data_hash_lock, flags);
 	hash_del(&kvm_svm->hnode);
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0835c664fbfd..fe0a6e812902 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -5116,7 +5116,7 @@ struct vmcb_save_area *sev_decrypt_vmsa(struct kvm_vcpu *vcpu)
 		if (ret) {
 			pr_err("SEV: SNP_DBG_DECRYPT failed ret=%d, fw_error=%d (%#x)\n",
 			       ret, error, error);
-			free_page((unsigned long)vmsa);
+			free_page(vmsa);
 
 			return NULL;
 		}
@@ -5154,5 +5154,5 @@ void sev_free_decrypted_vmsa(struct kvm_vcpu *vcpu, struct vmcb_save_area *vmsa)
 	if (!vcpu->arch.guest_state_protected || !vmsa)
 		return;
 
-	free_page((unsigned long)vmsa);
+	free_page(vmsa);
 }
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index d65f97bc2803..162ff26a45ce 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -7441,7 +7441,7 @@ void nested_vmx_hardware_unsetup(void)
 
 	if (enable_shadow_vmcs) {
 		for (i = 0; i < VMX_BITMAP_NR; i++)
-			free_page((unsigned long)vmx_bitmap[i]);
+			free_page(vmx_bitmap[i]);
 	}
 }
 
diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
index 6210101c222b..3b752ea04419 100644
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -280,7 +280,7 @@ static int handle_encls_ecreate(struct kvm_vcpu *vcpu)
 
 	/* Exit to userspace if copying from a host userspace address fails. */
 	if (sgx_read_hva(vcpu, contents_hva, (void *)contents, PAGE_SIZE)) {
-		free_page((unsigned long)contents);
+		free_page(contents);
 		return 0;
 	}
 
@@ -289,7 +289,7 @@ static int handle_encls_ecreate(struct kvm_vcpu *vcpu)
 
 	r = __handle_encls_ecreate(vcpu, &pageinfo, secs_hva, secs_gva);
 
-	free_page((unsigned long)contents);
+	free_page(contents);
 
 	return r;
 }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4376e01509e6..8cfcbd3bf0dd 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2912,7 +2912,7 @@ struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags)
 
 void free_vmcs(struct vmcs *vmcs)
 {
-	free_page((unsigned long)vmcs);
+	free_page(vmcs);
 }
 
 /*
@@ -2926,7 +2926,7 @@ void free_loaded_vmcs(struct loaded_vmcs *loaded_vmcs)
 	free_vmcs(loaded_vmcs->vmcs);
 	loaded_vmcs->vmcs = NULL;
 	if (loaded_vmcs->msr_bitmap)
-		free_page((unsigned long)loaded_vmcs->msr_bitmap);
+		free_page(loaded_vmcs->msr_bitmap);
 	WARN_ON(loaded_vmcs->shadow_vmcs != NULL);
 }
 
@@ -7533,7 +7533,7 @@ void vmx_vcpu_free(struct kvm_vcpu *vcpu)
 	free_vpid(vmx->vpid);
 	nested_vmx_free_vcpu(vcpu);
 	free_loaded_vmcs(vmx->loaded_vmcs);
-	free_page((unsigned long)vmx->ve_info);
+	free_page(vmx->ve_info);
 }
 
 int vmx_vcpu_create(struct kvm_vcpu *vcpu)
@@ -8341,7 +8341,7 @@ void vmx_vm_destroy(struct kvm *kvm)
 {
 	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
 
-	free_pages((unsigned long)kvm_vmx->pid_table, vmx_get_pid_table_order(kvm));
+	free_pages(kvm_vmx->pid_table, vmx_get_pid_table_order(kvm));
 }
 
 /*
@@ -8674,7 +8674,7 @@ __init int vmx_hardware_setup(void)
 static void vmx_cleanup_l1d_flush(void)
 {
 	if (vmx_l1d_flush_pages) {
-		free_pages((unsigned long)vmx_l1d_flush_pages, L1D_CACHE_ORDER);
+		free_pages(vmx_l1d_flush_pages, L1D_CACHE_ORDER);
 		vmx_l1d_flush_pages = NULL;
 	}
 	/* Restore state so sysfs ignores VMX */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 42ecd093bb4c..abcc8a8de904 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12725,7 +12725,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 fail_free_mce_banks:
 	kfree(vcpu->arch.mce_banks);
 	kfree(vcpu->arch.mci_ctl2_banks);
-	free_page((unsigned long)vcpu->arch.pio_data);
+	free_page(vcpu->arch.pio_data);
 fail_free_lapic:
 	kvm_free_lapic(vcpu);
 fail_mmu_destroy:
@@ -12780,7 +12780,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
 	kvm_mmu_destroy(vcpu);
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
-	free_page((unsigned long)vcpu->arch.pio_data);
+	free_page(vcpu->arch.pio_data);
 	kvfree(vcpu->arch.cpuid_entries);
 }
 
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 5630add8eaac..963703701201 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1408,7 +1408,7 @@ static bool try_to_free_pte_page(pte_t *pte)
 		if (!pte_none(pte[i]))
 			return false;
 
-	free_page((unsigned long)pte);
+	free_page(pte);
 	return true;
 }
 
@@ -1420,7 +1420,7 @@ static bool try_to_free_pmd_page(pmd_t *pmd)
 		if (!pmd_none(pmd[i]))
 			return false;
 
-	free_page((unsigned long)pmd);
+	free_page(pmd);
 	return true;
 }
 
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index eee601e9204a..09e30fc9c4bd 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -755,7 +755,7 @@ int pud_free_pmd_page(pud_t *pud, unsigned long addr)
 		}
 	}
 
-	free_page((unsigned long)pmd_sv);
+	free_page(pmd_sv);
 
 	pmd_free(&init_mm, pmd);
 
diff --git a/arch/x86/pci/pcbios.c b/arch/x86/pci/pcbios.c
index c4b4a3483ae3..89bc220c46c6 100644
--- a/arch/x86/pci/pcbios.c
+++ b/arch/x86/pci/pcbios.c
@@ -411,7 +411,7 @@ struct irq_routing_table * pcibios_get_irq_routing_table(void)
 			printk(KERN_INFO "PCI: Using BIOS Interrupt Routing Table\n");
 		}
 	}
-	free_page(page);
+	free_page((void *)page);
 	return rt;
 }
 EXPORT_SYMBOL(pcibios_get_irq_routing_table);
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 2e4852ddf2df..60bb3159b5bb 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -553,7 +553,7 @@ static void *realloc_pages(void *old_memmap, int old_shift)
 	memcpy(ret, old_memmap, PAGE_SIZE << old_shift);
 
 out:
-	free_pages((unsigned long)old_memmap, old_shift);
+	free_pages(old_memmap, old_shift);
 	return ret;
 }
 
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 193c513e15bf..a40bce50bc22 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -95,9 +95,9 @@ int __init efi_alloc_page_tables(void)
 
 free_p4d:
 	if (pgtable_l5_enabled())
-		free_page((unsigned long)pgd_page_vaddr(*pgd));
+		free_page((void *)pgd_page_vaddr(*pgd));
 free_pgd:
-	free_pages((unsigned long)efi_pgd, pgd_allocation_order());
+	free_pages(efi_pgd, pgd_allocation_order());
 fail:
 	return -ENOMEM;
 }
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index ee643a6cd691..d9428290a4b9 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -344,7 +344,7 @@ static void __init free_rmp_segment_table(void)
 		kfree(desc);
 	}
 
-	free_page((unsigned long)rmp_segment_table);
+	free_page(rmp_segment_table);
 
 	rmp_segment_table = NULL;
 }
diff --git a/arch/x86/xen/mmu_pv.c b/arch/x86/xen/mmu_pv.c
index 5f76d99a2733..57459d6a8eab 100644
--- a/arch/x86/xen/mmu_pv.c
+++ b/arch/x86/xen/mmu_pv.c
@@ -151,7 +151,7 @@ static int alloc_discontig_frames(unsigned int order)
 
 	spin_unlock_irqrestore(&xen_reservation_lock, flags);
 
-	free_pages((unsigned long)old_array, old_order - MIN_CONTIG_ORDER);
+	free_pages(old_array, old_order - MIN_CONTIG_ORDER);
 
 	return 0;
 }
@@ -1479,7 +1479,7 @@ static void xen_pgd_free(struct mm_struct *mm, pgd_t *pgd)
 	pgd_t *user_pgd = xen_get_user_pgd(pgd);
 
 	if (user_pgd)
-		free_page((unsigned long)user_pgd);
+		free_page(user_pgd);
 }
 
 /*
diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 775c8e40e354..3bb6862fb856 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -191,7 +191,7 @@ static void __ref free_p2m_page(void *p)
 		return;
 	}
 
-	free_page((unsigned long)p);
+	free_page(p);
 }
 
 /*
diff --git a/arch/x86/xen/pmu.c b/arch/x86/xen/pmu.c
index f94d69f5fcfd..f2b7e0106c4e 100644
--- a/arch/x86/xen/pmu.c
+++ b/arch/x86/xen/pmu.c
@@ -531,7 +531,7 @@ void xen_pmu_init(int cpu)
 	else
 		pr_info_once("Could not initialize VPMU for cpu %d, error %d\n",
 			cpu, err);
-	free_pages((unsigned long)xenpmu_data, 0);
+	free_pages(xenpmu_data, 0);
 }
 
 void xen_pmu_finish(int cpu)
@@ -547,6 +547,6 @@ void xen_pmu_finish(int cpu)
 
 	(void)HYPERVISOR_xenpmu_op(XENPMU_finish, &xp);
 
-	free_pages((unsigned long)per_cpu(xenpmu_shared, cpu).xenpmu_data, 0);
+	free_pages(per_cpu(xenpmu_shared, cpu).xenpmu_data, 0);
 	per_cpu(xenpmu_shared, cpu).xenpmu_data = NULL;
 }
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index febf1e0a167d..ff138cc77af5 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -456,7 +456,7 @@ static void xen_setup_vsyscall_time_info(void)
 	ret = HYPERVISOR_vcpu_op(VCPUOP_register_vcpu_time_memory_area, 0, &t);
 	if (ret) {
 		pr_notice("xen: VDSO_CLOCKMODE_PVCLOCK not supported (err %d)\n", ret);
-		free_page((unsigned long)ti);
+		free_page(ti);
 		return;
 	}
 
@@ -470,7 +470,7 @@ static void xen_setup_vsyscall_time_info(void)
 		ret = HYPERVISOR_vcpu_op(VCPUOP_register_vcpu_time_memory_area,
 					 0, &t);
 		if (!ret)
-			free_page((unsigned long)ti);
+			free_page(ti);
 
 		pr_notice("xen: VDSO_CLOCKMODE_PVCLOCK not supported (tsc unstable)\n");
 		return;
diff --git a/block/partitions/core.c b/block/partitions/core.c
index 98c03654362a..67eda86f59dd 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -152,7 +152,7 @@ static struct parsed_partitions *check_partition(struct gendisk *hd)
 	if (res > 0) {
 		printk(KERN_INFO "%s", state->pp_buf);
 
-		free_page((unsigned long)state->pp_buf);
+		free_page(state->pp_buf);
 		return state;
 	}
 	if (state->access_beyond_eod)
@@ -168,7 +168,7 @@ static struct parsed_partitions *check_partition(struct gendisk *hd)
 		printk(KERN_INFO "%s", state->pp_buf);
 	}
 
-	free_page((unsigned long)state->pp_buf);
+	free_page(state->pp_buf);
 	free_partitions(state);
 	return ERR_PTR(res);
 }
diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index dbe3d080a7fc..ac577ef9d38f 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -373,7 +373,7 @@ int skcipher_walk_done(struct skcipher_walk *walk, int res)
 	if (walk->buffer != walk->page)
 		kfree(walk->buffer);
 	if (walk->page)
-		free_page((unsigned long)walk->page);
+		free_page(walk->page);
 
 out:
 	return res;
diff --git a/crypto/scompress.c b/crypto/scompress.c
index 1a7ed8ae65b0..63a4e7827e9a 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -74,7 +74,7 @@ static void crypto_scomp_free_scratches(void)
 	for_each_possible_cpu(i) {
 		scratch = per_cpu_ptr(&scomp_scratch, i);
 
-		free_page(scratch->saddr);
+		free_page((void *)scratch->saddr);
 		scratch->src = NULL;
 	}
 }
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 8bc373ac1cec..b76907f322b4 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -89,7 +89,7 @@ static int testmgr_alloc_buf(char *buf[XBUFSIZE])
 
 err_free_buf:
 	while (i-- > 0)
-		free_page((unsigned long)buf[i]);
+		free_page(buf[i]);
 
 	return -ENOMEM;
 }
@@ -99,7 +99,7 @@ static void testmgr_free_buf(char *buf[XBUFSIZE])
 	int i;
 
 	for (i = 0; i < XBUFSIZE; i++)
-		free_page((unsigned long)buf[i]);
+		free_page(buf[i]);
 }
 
 static void sg_init_aead(struct scatterlist *sg, char *xbuf[XBUFSIZE],
@@ -2841,7 +2841,7 @@ static int __init tcrypt_mod_init(void)
 
 err_free_tv:
 	for (i = 0; i < TVMEMSIZE && tvmem[i]; i++)
-		free_page((unsigned long)tvmem[i]);
+		free_page(tvmem[i]);
 
 	return err;
 }
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index c57a1118e86e..d58ee51e0ccd 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -183,7 +183,7 @@ static int __testmgr_alloc_buf(char *buf[XBUFSIZE], int order)
 
 err_free_buf:
 	while (i-- > 0)
-		free_pages((unsigned long)buf[i], order);
+		free_pages(buf[i], order);
 
 	return -ENOMEM;
 }
@@ -198,7 +198,7 @@ static void __testmgr_free_buf(char *buf[XBUFSIZE], int order)
 	int i;
 
 	for (i = 0; i < XBUFSIZE; i++)
-		free_pages((unsigned long)buf[i], order);
+		free_pages(buf[i], order);
 }
 
 static void testmgr_free_buf(char *buf[XBUFSIZE])
diff --git a/crypto/xor.c b/crypto/xor.c
index 5838f601ac6f..8523ebd73014 100644
--- a/crypto/xor.c
+++ b/crypto/xor.c
@@ -154,7 +154,7 @@ calibrate_xor_blocks(void)
 
 #undef xor_speed
 
-	free_pages((unsigned long)b1, 2);
+	free_pages(b1, 2);
 out:
 	active_template = fastest;
 	return 0;
diff --git a/drivers/acpi/nvs.c b/drivers/acpi/nvs.c
index 3f96cf7042e0..6afbdc630600 100644
--- a/drivers/acpi/nvs.c
+++ b/drivers/acpi/nvs.c
@@ -133,7 +133,7 @@ void suspend_nvs_free(void)
 
 	list_for_each_entry(entry, &nvs_list, node)
 		if (entry->data) {
-			free_page((unsigned long)entry->data);
+			free_page(entry->data);
 			entry->data = NULL;
 			if (entry->kaddr) {
 				if (entry->unmap) {
diff --git a/drivers/atm/eni.c b/drivers/atm/eni.c
index c899bf3ce3a1..1b34c3c6bdba 100644
--- a/drivers/atm/eni.c
+++ b/drivers/atm/eni.c
@@ -905,7 +905,7 @@ static int start_rx(struct atm_dev *dev)
 	if (!eni_dev->rx_map) {
 		printk(KERN_ERR DEV_LABEL "(itf %d): couldn't get free page\n",
 		    dev->number);
-		free_page((unsigned long) eni_dev->free_list);
+		free_page(eni_dev->free_list);
 		return -ENOMEM;
 	}
 	eni_dev->rx_mult = DEFAULT_RX_MULT;
diff --git a/drivers/atm/lanai.c b/drivers/atm/lanai.c
index c496b040b238..dec576deec2d 100644
--- a/drivers/atm/lanai.c
+++ b/drivers/atm/lanai.c
@@ -1454,7 +1454,7 @@ static int vcc_table_allocate(struct lanai_dev *lanai)
 static inline void vcc_table_deallocate(const struct lanai_dev *lanai)
 {
 #ifdef VCCTABLE_GETFREEPAGE
-	free_page((unsigned long) lanai->vccs);
+	free_page(lanai->vccs);
 #else
 	vfree(lanai->vccs);
 #endif
diff --git a/drivers/auxdisplay/cfag12864b.c b/drivers/auxdisplay/cfag12864b.c
index 693212c99470..eae1974a5e6c 100644
--- a/drivers/auxdisplay/cfag12864b.c
+++ b/drivers/auxdisplay/cfag12864b.c
@@ -345,7 +345,7 @@ static int __init cfag12864b_init(void)
 	kfree(cfag12864b_cache);
 
 bufferalloced:
-	free_page((unsigned long) cfag12864b_buffer);
+	free_page(cfag12864b_buffer);
 
 none:
 	return ret;
@@ -357,7 +357,7 @@ static void __exit cfag12864b_exit(void)
 	cfag12864b_off();
 	destroy_workqueue(cfag12864b_workqueue);
 	kfree(cfag12864b_cache);
-	free_page((unsigned long) cfag12864b_buffer);
+	free_page(cfag12864b_buffer);
 }
 
 module_init(cfag12864b_init);
diff --git a/drivers/auxdisplay/ht16k33.c b/drivers/auxdisplay/ht16k33.c
index f413b61b0a6b..3bf257b9aa1f 100644
--- a/drivers/auxdisplay/ht16k33.c
+++ b/drivers/auxdisplay/ht16k33.c
@@ -636,7 +636,7 @@ static int ht16k33_fbdev_probe(struct device *dev, struct ht16k33_priv *priv,
 err_fbdev_info:
 	framebuffer_release(fbdev->info);
 err_fbdev_buffer:
-	free_page((unsigned long) fbdev->buffer);
+	free_page(fbdev->buffer);
 
 	return err;
 }
@@ -731,7 +731,7 @@ static void ht16k33_remove(struct i2c_client *client)
 	case DISP_MATRIX:
 		unregister_framebuffer(fbdev->info);
 		framebuffer_release(fbdev->info);
-		free_page((unsigned long)fbdev->buffer);
+		free_page(fbdev->buffer);
 		break;
 
 	case DISP_QUAD_7SEG:
diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index 803d55bf7331..0b31ccdeaa3b 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -1155,7 +1155,7 @@ static void devm_pages_release(struct device *dev, void *res)
 {
 	struct pages_devres *devres = res;
 
-	free_pages(devres->addr, devres->order);
+	free_pages((void *)devres->addr, devres->order);
 }
 
 /**
@@ -1185,7 +1185,7 @@ unsigned long devm_get_free_pages(struct device *dev,
 	devres = devres_alloc(devm_pages_release,
 			      sizeof(struct pages_devres), GFP_KERNEL);
 	if (unlikely(!devres)) {
-		free_pages(addr, order);
+		free_pages((void *)addr, order);
 		return 0;
 	}
 
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index b3ef65a12865..67ba86e5bad7 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2429,8 +2429,8 @@ static int drbd_alloc_socket(struct drbd_socket *socket)
 
 static void drbd_free_socket(struct drbd_socket *socket)
 {
-	free_page((unsigned long) socket->sbuf);
-	free_page((unsigned long) socket->rbuf);
+	free_page(socket->sbuf);
+	free_page(socket->rbuf);
 }
 
 void conn_free_crypto(struct drbd_connection *connection)
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 5336c3c5ca36..96438fabe3ec 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -265,7 +265,7 @@ static int set_next_request(void);
 /* Dma Memory related stuff */
 
 #ifndef fd_dma_mem_free
-#define fd_dma_mem_free(addr, size) free_pages(addr, get_order(size))
+#define fd_dma_mem_free(addr, size) free_pages((void *)addr, get_order(size))
 #endif
 
 #ifndef fd_dma_mem_alloc
diff --git a/drivers/block/ps3vram.c b/drivers/block/ps3vram.c
index 8eeb3981de24..ca872c8fd3ba 100644
--- a/drivers/block/ps3vram.c
+++ b/drivers/block/ps3vram.c
@@ -774,7 +774,7 @@ static int ps3vram_probe(struct ps3_system_bus_device *dev)
 out_close_gpu:
 	ps3_close_hv_device(dev);
 out_free_xdr_buf:
-	free_pages((unsigned long) priv->xdr_buf, get_order(XDR_BUF_SIZE));
+	free_pages(priv->xdr_buf, get_order(XDR_BUF_SIZE));
 fail_free_priv:
 	kfree(priv);
 	ps3_system_bus_set_drvdata(dev, NULL);
@@ -798,7 +798,7 @@ static void ps3vram_remove(struct ps3_system_bus_device *dev)
 	lv1_gpu_context_free(priv->context_handle);
 	lv1_gpu_memory_free(priv->memory_handle);
 	ps3_close_hv_device(dev);
-	free_pages((unsigned long) priv->xdr_buf, get_order(XDR_BUF_SIZE));
+	free_pages(priv->xdr_buf, get_order(XDR_BUF_SIZE));
 	kfree(priv);
 	ps3_system_bus_set_drvdata(dev, NULL);
 }
diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 8cb10c7d887f..14e40b57d59b 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -2675,7 +2675,7 @@ static void ublk_deinit_queue(struct ublk_device *ub, int q_id)
 	}
 
 	if (ubq->io_cmd_buf)
-		free_pages((unsigned long)ubq->io_cmd_buf, get_order(size));
+		free_pages(ubq->io_cmd_buf, get_order(size));
 }
 
 static int ublk_init_queue(struct ublk_device *ub, int q_id)
diff --git a/drivers/char/agp/agp.h b/drivers/char/agp/agp.h
index 43ecf69ce5c6..256f7b39ba45 100644
--- a/drivers/char/agp/agp.h
+++ b/drivers/char/agp/agp.h
@@ -230,7 +230,7 @@ void agp3_generic_cleanup(void);
 #define alloc_gatt_pages(order)		\
 	(__get_free_pages(GFP_KERNEL, (order)))
 #define free_gatt_pages(table, order)	\
-	free_pages((unsigned long)(table), (order))
+	free_pages((table), (order))
 
 /* aperture sizes have been standardised since v3 */
 #define AGP_GENERIC_SIZES_ENTRIES 11
diff --git a/drivers/char/agp/amd-k7-agp.c b/drivers/char/agp/amd-k7-agp.c
index f3789188abd5..20e308527325 100644
--- a/drivers/char/agp/amd-k7-agp.c
+++ b/drivers/char/agp/amd-k7-agp.c
@@ -56,7 +56,7 @@ static int amd_create_page_map(struct amd_page_map *page_map)
 static void amd_free_page_map(struct amd_page_map *page_map)
 {
 	set_memory_wb((unsigned long)page_map->real, 1);
-	free_page((unsigned long) page_map->real);
+	free_page(page_map->real);
 }
 
 static void amd_free_gatt_pages(void)
diff --git a/drivers/char/agp/ati-agp.c b/drivers/char/agp/ati-agp.c
index 07d4c1a76d14..dac7ab82fbb9 100644
--- a/drivers/char/agp/ati-agp.c
+++ b/drivers/char/agp/ati-agp.c
@@ -64,7 +64,7 @@ static int ati_create_page_map(struct ati_page_map *page_map)
 	set_memory_uc((unsigned long)page_map->real, 1);
 	err = map_page_into_agp(virt_to_page(page_map->real));
 	if (err) {
-		free_page((unsigned long)page_map->real);
+		free_page(page_map->real);
 		return err;
 	}
 	page_map->remapped = page_map->real;
@@ -82,7 +82,7 @@ static void ati_free_page_map(struct ati_page_map *page_map)
 {
 	unmap_page_from_agp(virt_to_page(page_map->real));
 	set_memory_wb((unsigned long)page_map->real, 1);
-	free_page((unsigned long) page_map->real);
+	free_page(page_map->real);
 }
 
 
diff --git a/drivers/char/agp/efficeon-agp.c b/drivers/char/agp/efficeon-agp.c
index dab8c28dcd95..e16d9969f66d 100644
--- a/drivers/char/agp/efficeon-agp.c
+++ b/drivers/char/agp/efficeon-agp.c
@@ -163,7 +163,7 @@ static int efficeon_free_gatt_table(struct agp_bridge_data *bridge)
 		unsigned long page = efficeon_private.l1_table[index];
 		if (page) {
 			efficeon_private.l1_table[index] = 0;
-			free_page(page);
+			free_page((void *)page);
 			freed++;
 		}
 		printk(KERN_DEBUG PFX "efficeon_free_gatt_table(%p, %02x, %08x)\n",
diff --git a/drivers/char/agp/sworks-agp.c b/drivers/char/agp/sworks-agp.c
index fa247702903d..1b8533e67005 100644
--- a/drivers/char/agp/sworks-agp.c
+++ b/drivers/char/agp/sworks-agp.c
@@ -67,7 +67,7 @@ static int serverworks_create_page_map(struct serverworks_page_map *page_map)
 static void serverworks_free_page_map(struct serverworks_page_map *page_map)
 {
 	set_memory_wb((unsigned long)page_map->real, 1);
-	free_page((unsigned long) page_map->real);
+	free_page(page_map->real);
 }
 
 static void serverworks_free_gatt_pages(void)
diff --git a/drivers/char/agp/uninorth-agp.c b/drivers/char/agp/uninorth-agp.c
index b148aa8b4b18..b19999fef793 100644
--- a/drivers/char/agp/uninorth-agp.c
+++ b/drivers/char/agp/uninorth-agp.c
@@ -442,7 +442,7 @@ static int uninorth_create_gatt_table(struct agp_bridge_data *bridge)
 enomem:
 	kfree(uninorth_priv.pages_arr);
 	if (table)
-		free_pages((unsigned long)table, page_order);
+		free_pages(table, page_order);
 	return -ENOMEM;
 }
 
@@ -469,7 +469,7 @@ static int uninorth_free_gatt_table(struct agp_bridge_data *bridge)
 	for (page = virt_to_page(table); page <= virt_to_page(table_end); page++)
 		ClearPageReserved(page);
 
-	free_pages((unsigned long) bridge->gatt_table_real, page_order);
+	free_pages(bridge->gatt_table_real, page_order);
 
 	return 0;
 }
diff --git a/drivers/char/hw_random/s390-trng.c b/drivers/char/hw_random/s390-trng.c
index 5f60ea40aea3..0b4122048785 100644
--- a/drivers/char/hw_random/s390-trng.c
+++ b/drivers/char/hw_random/s390-trng.c
@@ -95,7 +95,7 @@ static ssize_t trng_read(struct file *file, char __user *ubuf,
 	}
 
 	if (p != buf)
-		free_page((unsigned long) p);
+		free_page(p);
 
 	DEBUG_DBG("trng_read()=%zd\n", ret);
 	return ret;
diff --git a/drivers/char/tpm/tpm-buf.c b/drivers/char/tpm/tpm-buf.c
index e3e1a1d46646..0530e1d2d5fb 100644
--- a/drivers/char/tpm/tpm-buf.c
+++ b/drivers/char/tpm/tpm-buf.c
@@ -80,7 +80,7 @@ EXPORT_SYMBOL_GPL(tpm_buf_reset_sized);
 
 void tpm_buf_destroy(struct tpm_buf *buf)
 {
-	free_page((unsigned long)buf->data);
+	free_page(buf->data);
 }
 EXPORT_SYMBOL_GPL(tpm_buf_destroy);
 
diff --git a/drivers/char/tpm/tpm_ibmvtpm.c b/drivers/char/tpm/tpm_ibmvtpm.c
index 1f0a6e1a0743..fece2e54d3a2 100644
--- a/drivers/char/tpm/tpm_ibmvtpm.c
+++ b/drivers/char/tpm/tpm_ibmvtpm.c
@@ -360,7 +360,7 @@ static void tpm_ibmvtpm_remove(struct vio_dev *vdev)
 
 	dma_unmap_single(ibmvtpm->dev, ibmvtpm->crq_dma_handle,
 			 CRQ_RES_BUF_SIZE, DMA_BIDIRECTIONAL);
-	free_page((unsigned long)ibmvtpm->crq_queue.crq_addr);
+	free_page(ibmvtpm->crq_queue.crq_addr);
 
 	if (ibmvtpm->rtce_buf) {
 		dma_unmap_single(ibmvtpm->dev, ibmvtpm->rtce_dma_handle,
@@ -704,7 +704,7 @@ static int tpm_ibmvtpm_probe(struct vio_dev *vio_dev,
 cleanup:
 	if (ibmvtpm) {
 		if (crq_q->crq_addr)
-			free_page((unsigned long)crq_q->crq_addr);
+			free_page(crq_q->crq_addr);
 		kfree(ibmvtpm);
 	}
 
diff --git a/drivers/char/xilinx_hwicap/xilinx_hwicap.c b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
index 4a83c408b35c..aa3f6bd3aa62 100644
--- a/drivers/char/xilinx_hwicap/xilinx_hwicap.c
+++ b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
@@ -412,13 +412,13 @@ hwicap_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 
 		/* If we didn't read correctly, then bail out. */
 		if (status) {
-			free_page((unsigned long)kbuf);
+			free_page(kbuf);
 			goto error;
 		}
 
 		/* If we fail to return the data to the user, then bail out. */
 		if (copy_to_user(buf, kbuf, bytes_to_read)) {
-			free_page((unsigned long)kbuf);
+			free_page(kbuf);
 			status = -EFAULT;
 			goto error;
 		}
@@ -426,7 +426,7 @@ hwicap_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 		       kbuf,
 		       bytes_remaining);
 		drvdata->read_buffer_in_use = bytes_remaining;
-		free_page((unsigned long)kbuf);
+		free_page(kbuf);
 	}
 	status = bytes_to_read;
  error:
@@ -479,13 +479,13 @@ hwicap_write(struct file *file, const char __user *buf,
 			    (((char *)kbuf) + drvdata->write_buffer_in_use),
 			    buf + written,
 			    len - (drvdata->write_buffer_in_use))) {
-				free_page((unsigned long)kbuf);
+				free_page(kbuf);
 				status = -EFAULT;
 				goto error;
 			}
 		} else {
 			if (copy_from_user(kbuf, buf + written, len)) {
-				free_page((unsigned long)kbuf);
+				free_page(kbuf);
 				status = -EFAULT;
 				goto error;
 			}
@@ -495,7 +495,7 @@ hwicap_write(struct file *file, const char __user *buf,
 				kbuf, len >> 2);
 
 		if (status) {
-			free_page((unsigned long)kbuf);
+			free_page(kbuf);
 			status = -EFAULT;
 			goto error;
 		}
@@ -516,7 +516,7 @@ hwicap_write(struct file *file, const char __user *buf,
 		}
 	}
 
-	free_page((unsigned long)kbuf);
+	free_page(kbuf);
 	status = written;
  error:
 	mutex_unlock(&drvdata->sem);
diff --git a/drivers/char/xillybus/xillyusb.c b/drivers/char/xillybus/xillyusb.c
index 5083cb5c6d7e..f4f370a44da9 100644
--- a/drivers/char/xillybus/xillyusb.c
+++ b/drivers/char/xillybus/xillyusb.c
@@ -417,7 +417,7 @@ static int fifo_init(struct xillyfifo *fifo,
 
 memfail:
 	for (i--; i >= 0; i--)
-		free_pages((unsigned long)fifo->mem[i], buf_order);
+		free_pages(fifo->mem[i], buf_order);
 
 	kfree(fifo->mem);
 	fifo->mem = NULL;
@@ -438,7 +438,7 @@ static void fifo_mem_release(struct xillyfifo *fifo)
 		return;
 
 	for (i = 0; i < fifo->bufnum; i++)
-		free_pages((unsigned long)fifo->mem[i], fifo->buf_order);
+		free_pages(fifo->mem[i], fifo->buf_order);
 
 	kfree(fifo->mem);
 }
@@ -477,7 +477,7 @@ static void endpoint_dealloc(struct xillyusb_endpoint *ep)
 		struct xillybuffer *xb =
 			list_entry(this, struct xillybuffer, entry);
 
-		free_pages((unsigned long)xb->buf, ep->order);
+		free_pages(xb->buf, ep->order);
 		kfree(xb);
 	}
 
diff --git a/drivers/comedi/comedi_buf.c b/drivers/comedi/comedi_buf.c
index 164d8a53b311..9ba3b3c0f393 100644
--- a/drivers/comedi/comedi_buf.c
+++ b/drivers/comedi/comedi_buf.c
@@ -37,7 +37,7 @@ static void comedi_buf_map_kref_release(struct kref *kref)
 			for (i = 0; i < bm->n_pages; i++) {
 				buf = &bm->page_list[i];
 				ClearPageReserved(virt_to_page(buf->virt_addr));
-				free_page((unsigned long)buf->virt_addr);
+				free_page(buf->virt_addr);
 			}
 		}
 		vfree(bm->page_list);
diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index b00ff9c0b45a..d3ab97c6920e 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -2131,7 +2131,7 @@ static int atmel_aes_buff_init(struct atmel_aes_dev *dd)
 
 static void atmel_aes_buff_cleanup(struct atmel_aes_dev *dd)
 {
-	free_page((unsigned long)dd->buf);
+	free_page(dd->buf);
 }
 
 static int atmel_aes_dma_init(struct atmel_aes_dev *dd)
diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index d1010206b713..a9ece5544e67 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -347,8 +347,8 @@ static int atmel_tdes_buff_init(struct atmel_tdes_dev *dd)
 		DMA_TO_DEVICE);
 err_map_in:
 err_alloc:
-	free_page((unsigned long)dd->buf_out);
-	free_page((unsigned long)dd->buf_in);
+	free_page(dd->buf_out);
+	free_page(dd->buf_in);
 	return err;
 }
 
@@ -358,8 +358,8 @@ static void atmel_tdes_buff_cleanup(struct atmel_tdes_dev *dd)
 			 DMA_FROM_DEVICE);
 	dma_unmap_single(dd->dev, dd->dma_addr_in, dd->buflen,
 		DMA_TO_DEVICE);
-	free_page((unsigned long)dd->buf_out);
-	free_page((unsigned long)dd->buf_in);
+	free_page(dd->buf_out);
+	free_page(dd->buf_in);
 }
 
 static int atmel_tdes_crypt_pdc(struct atmel_tdes_dev *dd,
diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
index 7cf7fe6bb9ba..58912e6e91e8 100644
--- a/drivers/crypto/ccp/tee-dev.c
+++ b/drivers/crypto/ccp/tee-dev.c
@@ -53,8 +53,7 @@ static void tee_free_ring(struct psp_tee_device *tee)
 	if (!rb_mgr->ring_start)
 		return;
 
-	free_pages((unsigned long)rb_mgr->ring_start,
-		   get_order(rb_mgr->ring_size));
+	free_pages(rb_mgr->ring_start, get_order(rb_mgr->ring_size));
 
 	rb_mgr->ring_start = NULL;
 	rb_mgr->ring_size = 0;
diff --git a/drivers/crypto/inside-secure/eip93/eip93-common.c b/drivers/crypto/inside-secure/eip93/eip93-common.c
index 5fa9b3b208bf..f52bae4018df 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-common.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-common.c
@@ -142,7 +142,7 @@ static void eip93_free_sg_copy(const int len, struct scatterlist **sg)
 	if (!*sg || !len)
 		return;
 
-	free_pages((unsigned long)sg_virt(*sg), get_order(len));
+	free_pages(sg_virt(*sg), get_order(len));
 	kfree(*sg);
 	*sg = NULL;
 }
diff --git a/drivers/crypto/nx/nx-842.c b/drivers/crypto/nx/nx-842.c
index 06e2d89a5e37..55613a2eac75 100644
--- a/drivers/crypto/nx/nx-842.c
+++ b/drivers/crypto/nx/nx-842.c
@@ -116,8 +116,8 @@ void *nx842_crypto_alloc_ctx(struct nx842_driver *driver)
 	ctx->dbounce = __get_free_pages(GFP_KERNEL, BOUNCE_BUFFER_ORDER);
 	if (!ctx->wmem || !ctx->sbounce || !ctx->dbounce) {
 		kfree(ctx->wmem);
-		free_page((unsigned long)ctx->sbounce);
-		free_page((unsigned long)ctx->dbounce);
+		free_page(ctx->sbounce);
+		free_page(ctx->dbounce);
 		kfree(ctx);
 		return ERR_PTR(-ENOMEM);
 	}
@@ -131,8 +131,8 @@ void nx842_crypto_free_ctx(void *p)
 	struct nx842_crypto_ctx *ctx = p;
 
 	kfree(ctx->wmem);
-	free_page((unsigned long)ctx->sbounce);
-	free_page((unsigned long)ctx->dbounce);
+	free_page(ctx->sbounce);
+	free_page(ctx->dbounce);
 }
 EXPORT_SYMBOL_GPL(nx842_crypto_free_ctx);
 
diff --git a/drivers/crypto/omap-crypto.c b/drivers/crypto/omap-crypto.c
index 4c8816dd798a..441e32923986 100644
--- a/drivers/crypto/omap-crypto.c
+++ b/drivers/crypto/omap-crypto.c
@@ -214,7 +214,7 @@ void omap_crypto_cleanup(struct scatterlist *sg, struct scatterlist *orig,
 		omap_crypto_copy_data(sg, orig, offset, len);
 
 	if (flags & OMAP_CRYPTO_DATA_COPIED)
-		free_pages((unsigned long)buf, pages);
+		free_pages(buf, pages);
 	else if (flags & OMAP_CRYPTO_SG_COPIED)
 		kfree(sg);
 }
diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 783da9f68a3d..e75849f5cb5d 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -1136,8 +1136,7 @@ static void omap_sham_finish_req(struct ahash_request *req, int err)
 	struct omap_sham_dev *dd = ctx->dd;
 
 	if (test_bit(FLAGS_SGS_COPIED, &dd->flags))
-		free_pages((unsigned long)sg_virt(ctx->sg),
-			   get_order(ctx->sg->length));
+		free_pages(sg_virt(ctx->sg), get_order(ctx->sg->length));
 
 	if (test_bit(FLAGS_SGS_ALLOCED, &dd->flags))
 		kfree(ctx->sg);
diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index bdc389ae41c8..1341f2f55eb9 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -450,7 +450,7 @@ static void s5p_free_sg_cpy(struct s5p_aes_dev *dev, struct scatterlist **sg)
 		return;
 
 	len = ALIGN(dev->req->cryptlen, AES_BLOCK_SIZE);
-	free_pages((unsigned long)sg_virt(*sg), get_order(len));
+	free_pages(sg_virt(*sg), get_order(len));
 
 	kfree(*sg);
 	*sg = NULL;
@@ -1308,8 +1308,7 @@ static void s5p_hash_finish_req(struct ahash_request *req, int err)
 	unsigned long flags;
 
 	if (test_bit(HASH_FLAGS_SGS_COPIED, &dd->hash_flags))
-		free_pages((unsigned long)sg_virt(ctx->sg),
-			   get_order(ctx->sg->length));
+		free_pages(sg_virt(ctx->sg), get_order(ctx->sg->length));
 
 	if (test_bit(HASH_FLAGS_SGS_ALLOCED, &dd->hash_flags))
 		kfree(ctx->sg);
diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index 23235287058c..5e3ac7366985 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -1346,7 +1346,7 @@ static void stm32_hash_unprepare_request(struct ahash_request *req)
 		dmaengine_terminate_sync(hdev->dma_lch);
 
 	if (state->flags & HASH_FLAGS_SGS_COPIED)
-		free_pages((unsigned long)sg_virt(rctx->sg), get_order(rctx->sg->length));
+		free_pages(sg_virt(rctx->sg), get_order(rctx->sg->length));
 
 	rctx->sg = NULL;
 	rctx->offset = 0;
diff --git a/drivers/dma/nbpfaxi.c b/drivers/dma/nbpfaxi.c
index d00c7802aedf..c606c9006ab6 100644
--- a/drivers/dma/nbpfaxi.c
+++ b/drivers/dma/nbpfaxi.c
@@ -1093,7 +1093,7 @@ static void nbpf_free_chan_resources(struct dma_chan *dchan)
 		     i++, ldesc++)
 			dma_unmap_single(dchan->device->dev, ldesc->hwdesc_dma_addr,
 					 sizeof(*ldesc->hwdesc), DMA_TO_DEVICE);
-		free_page((unsigned long)dpage);
+		free_page(dpage);
 	}
 }
 
diff --git a/drivers/dma/sh/rcar-dmac.c b/drivers/dma/sh/rcar-dmac.c
index e4c5d2980883..95597b920772 100644
--- a/drivers/dma/sh/rcar-dmac.c
+++ b/drivers/dma/sh/rcar-dmac.c
@@ -1110,7 +1110,7 @@ static void rcar_dmac_free_chan_resources(struct dma_chan *chan)
 
 	list_for_each_entry_safe(page, _page, &rchan->desc.pages, node) {
 		list_del(&page->node);
-		free_page((unsigned long)page);
+		free_page(page);
 	}
 
 	/* Remove slave mapping if present. */
diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 25b60b8b3da9..8acaa0abcdc3 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3394,7 +3394,8 @@ static int __init d40_lcla_allocate(struct d40_base *base)
 			ret = -ENOMEM;
 
 			for (j = 0; j < i; j++)
-				free_pages(page_list[j], base->lcla_pool.pages);
+				free_pages((void *)page_list[j],
+					   base->lcla_pool.pages);
 			goto free_page_list;
 		}
 
@@ -3404,7 +3405,7 @@ static int __init d40_lcla_allocate(struct d40_base *base)
 	}
 
 	for (j = 0; j < i; j++)
-		free_pages(page_list[j], base->lcla_pool.pages);
+		free_pages((void *)page_list[j], base->lcla_pool.pages);
 
 	if (i < MAX_LCLA_ALLOC_ATTEMPTS) {
 		base->lcla_pool.base = (void *)page_list[i];
@@ -3653,8 +3654,7 @@ static int __init d40_probe(struct platform_device *pdev)
 				 DMA_TO_DEVICE);
 
 	if (!base->lcla_pool.base_unaligned && base->lcla_pool.base)
-		free_pages((unsigned long)base->lcla_pool.base,
-			   base->lcla_pool.pages);
+		free_pages(base->lcla_pool.base, base->lcla_pool.pages);
 
 	kfree(base->lcla_pool.base_unaligned);
 
diff --git a/drivers/extcon/extcon.c b/drivers/extcon/extcon.c
index b6659e08045e..de681137e1dd 100644
--- a/drivers/extcon/extcon.c
+++ b/drivers/extcon/extcon.c
@@ -494,7 +494,7 @@ int extcon_sync(struct extcon_dev *edev, unsigned int id)
 	/* Unlock early before uevent */
 	spin_unlock_irqrestore(&edev->lock, flags);
 	kobject_uevent_env(&edev->dev.kobj, KOBJ_CHANGE, envp);
-	free_page((unsigned long)prop_buf);
+	free_page(prop_buf);
 
 	return 0;
 }
diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 030aed5453a1..1275a75e96be 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -2927,7 +2927,7 @@ static struct fw_iso_context *ohci_allocate_iso_context(struct fw_card *card,
 
 	memset(ctx, 0, sizeof(*ctx));
 	ctx->header_length = 0;
-	ctx->header = (void *) __get_free_page(GFP_KERNEL);
+	ctx->header = __get_free_page(GFP_KERNEL);
 	if (ctx->header == NULL) {
 		ret = -ENOMEM;
 		goto out;
@@ -2945,7 +2945,7 @@ static struct fw_iso_context *ohci_allocate_iso_context(struct fw_card *card,
 	return &ctx->base;
 
  out_with_header:
-	free_page((unsigned long)ctx->header);
+	free_page(ctx->header);
  out:
 	scoped_guard(spinlock_irq, &ohci->lock) {
 		switch (type) {
@@ -3045,7 +3045,7 @@ static void ohci_free_iso_context(struct fw_iso_context *base)
 
 	ohci_stop_iso(base);
 	context_release(&ctx->context);
-	free_page((unsigned long)ctx->header);
+	free_page(ctx->header);
 
 	guard(spinlock_irqsave)(&ohci->lock);
 
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index e2b69af4fd50..ad4f79e630e7 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -1137,7 +1137,7 @@ int __ref efi_mem_reserve_persistent(phys_addr_t addr, u64 size)
 
 	rc = efi_mem_reserve_iomem(__pa(rsv), SZ_4K);
 	if (rc) {
-		free_page((unsigned long)rsv);
+		free_page(rsv);
 		return rc;
 	}
 
diff --git a/drivers/firmware/psci/psci_checker.c b/drivers/firmware/psci/psci_checker.c
index c5d80366c0f7..e9456e670e45 100644
--- a/drivers/firmware/psci/psci_checker.c
+++ b/drivers/firmware/psci/psci_checker.c
@@ -220,7 +220,7 @@ static int hotplug_tests(void)
 		err += down_and_up_cpus(cpu_groups[i], offlined_cpus);
 	}
 
-	free_page((unsigned long)page_buf);
+	free_page(page_buf);
 out_free_cpu_groups:
 	free_cpu_groups(nb_cpu_group, &cpu_groups);
 out_free_cpus:
diff --git a/drivers/fsi/fsi-occ.c b/drivers/fsi/fsi-occ.c
index d3ff6b55b281..ce17e1c5d1ff 100644
--- a/drivers/fsi/fsi-occ.c
+++ b/drivers/fsi/fsi-occ.c
@@ -200,7 +200,7 @@ static int occ_release(struct inode *inode, struct file *file)
 	struct occ_client *client = file->private_data;
 
 	put_device(client->occ->dev);
-	free_page((unsigned long)client->buffer);
+	free_page(client->buffer);
 	kfree(client);
 
 	return 0;
diff --git a/drivers/fsi/fsi-sbefifo.c b/drivers/fsi/fsi-sbefifo.c
index b06b09bfcb1e..96a8d867f26c 100644
--- a/drivers/fsi/fsi-sbefifo.c
+++ b/drivers/fsi/fsi-sbefifo.c
@@ -936,7 +936,7 @@ static int sbefifo_user_release(struct inode *inode, struct file *file)
 		return -EINVAL;
 
 	sbefifo_release_command(user);
-	free_page((unsigned long)user->cmd_page);
+	free_page(user->cmd_page);
 	kfree(user);
 
 	return 0;
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_events.c b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
index 505ac574e99d..4083b1c1844f 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_events.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
@@ -300,7 +300,7 @@ static void shutdown_signal_page(struct kfd_process *p)
 
 	if (page) {
 		if (page->need_to_free_pages)
-			free_pages((unsigned long)page->kernel_address,
+			free_pages(page->kernel_address,
 				   get_order(KFD_SIGNAL_EVENT_LIMIT * 8));
 		kfree(page);
 	}
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process.c b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
index 1296b7eca686..b5e8dd08880e 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -1067,8 +1067,8 @@ static void kfd_process_destroy_pdds(struct kfd_process *p)
 			fput(pdd->drm_file);
 
 		if (pdd->qpd.cwsr_kaddr && !pdd->qpd.cwsr_base)
-			free_pages((unsigned long)pdd->qpd.cwsr_kaddr,
-				get_order(KFD_CWSR_TBA_TMA_SIZE));
+			free_pages(pdd->qpd.cwsr_kaddr,
+				   get_order(KFD_CWSR_TBA_TMA_SIZE));
 
 		idr_destroy(&pdd->alloc_idr);
 
diff --git a/drivers/gpu/drm/i915/gt/selftest_lrc.c b/drivers/gpu/drm/i915/gt/selftest_lrc.c
index 44cd6938537e..612dba1566c4 100644
--- a/drivers/gpu/drm/i915/gt/selftest_lrc.c
+++ b/drivers/gpu/drm/i915/gt/selftest_lrc.c
@@ -268,7 +268,7 @@ static int live_lrc_layout(void *arg)
 			break;
 	}
 
-	free_page((unsigned long)lrc);
+	free_page(lrc);
 	return err;
 }
 
diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_log.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_log.c
index 0366697ded94..dc5b3135dcb6 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_log.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_log.c
@@ -914,7 +914,7 @@ int intel_guc_log_dump(struct intel_guc_log *log, struct drm_printer *p,
 	if (IS_ERR(map)) {
 		guc_dbg(guc, "Failed to pin log object: %pe\n", map);
 		drm_puts(p, "(log data unaccessible)\n");
-		free_page((unsigned long)page);
+		free_page(page);
 		return PTR_ERR(map);
 	}
 
@@ -931,7 +931,7 @@ int intel_guc_log_dump(struct intel_guc_log *log, struct drm_printer *p,
 	drm_puts(p, "\n");
 
 	i915_gem_object_unpin_map(obj);
-	free_page((unsigned long)page);
+	free_page(page);
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/i915/gvt/gtt.c b/drivers/gpu/drm/i915/gvt/gtt.c
index 838bdc642b84..e56438e06920 100644
--- a/drivers/gpu/drm/i915/gvt/gtt.c
+++ b/drivers/gpu/drm/i915/gvt/gtt.c
@@ -2483,7 +2483,7 @@ static void clean_spt_oos(struct intel_gvt *gvt)
 	list_for_each_safe(pos, n, &gtt->oos_page_free_list_head) {
 		oos_page = container_of(pos, struct intel_vgpu_oos_page, list);
 		list_del(&oos_page->list);
-		free_page((unsigned long)oos_page->mem);
+		free_page(oos_page->mem);
 		kfree(oos_page);
 	}
 }
diff --git a/drivers/gpu/drm/i915/gvt/opregion.c b/drivers/gpu/drm/i915/gvt/opregion.c
index 5ec9d6d7e4a2..09d2579023dc 100644
--- a/drivers/gpu/drm/i915/gvt/opregion.c
+++ b/drivers/gpu/drm/i915/gvt/opregion.c
@@ -290,7 +290,7 @@ void intel_vgpu_clean_opregion(struct intel_vgpu *vgpu)
 		return;
 
 	/* Guest opregion is released by VFIO */
-	free_pages((unsigned long)vgpu_opregion(vgpu)->va,
+	free_pages(vgpu_opregion(vgpu)->va,
 		   get_order(INTEL_GVT_OPREGION_SIZE));
 
 	vgpu_opregion(vgpu)->va = NULL;
diff --git a/drivers/gpu/drm/i915/i915_gpu_error.c b/drivers/gpu/drm/i915/i915_gpu_error.c
index 7582ef34bf3f..d967aa0aa0cb 100644
--- a/drivers/gpu/drm/i915/i915_gpu_error.c
+++ b/drivers/gpu/drm/i915/i915_gpu_error.c
@@ -781,7 +781,7 @@ static void err_free_sgl(struct scatterlist *sgl)
 		}
 
 		sg = sg_is_last(sg) ? NULL : sg_chain_ptr(sg);
-		free_page((unsigned long)sgl);
+		free_page(sgl);
 		sgl = sg;
 	}
 }
diff --git a/drivers/gpu/drm/msm/msm_iommu.c b/drivers/gpu/drm/msm/msm_iommu.c
index 0e18619f96cb..cd6326b8f7af 100644
--- a/drivers/gpu/drm/msm/msm_iommu.c
+++ b/drivers/gpu/drm/msm/msm_iommu.c
@@ -423,7 +423,7 @@ msm_iommu_pagetable_free_pt(void *cookie, void *data, size_t size)
 	struct msm_iommu_pagetable *pagetable = cookie;
 
 	if (unlikely(pagetable->root_page_table == data)) {
-		free_pages((unsigned long)data, get_order(size));
+		free_pages(data, get_order(size));
 		pagetable->root_page_table = NULL;
 		return;
 	}
diff --git a/drivers/gpu/drm/panthor/panthor_mmu.c b/drivers/gpu/drm/panthor/panthor_mmu.c
index 6dec4354e378..0d2c55257e88 100644
--- a/drivers/gpu/drm/panthor/panthor_mmu.c
+++ b/drivers/gpu/drm/panthor/panthor_mmu.c
@@ -491,7 +491,7 @@ static void free_pt(void *cookie, void *data, size_t size)
 	struct panthor_vm *vm = cookie;
 
 	if (unlikely(vm->root_page_table == data)) {
-		free_pages((unsigned long)data, get_order(size));
+		free_pages(data, get_order(size));
 		vm->root_page_table = NULL;
 		return;
 	}
diff --git a/drivers/gpu/drm/tegra/drm.c b/drivers/gpu/drm/tegra/drm.c
index c346572a479d..be0993fa31a5 100644
--- a/drivers/gpu/drm/tegra/drm.c
+++ b/drivers/gpu/drm/tegra/drm.c
@@ -1063,7 +1063,7 @@ void *tegra_drm_alloc(struct tegra_drm *tegra, size_t size, dma_addr_t *dma)
 free_iova:
 	__free_iova(&tegra->carveout.domain, alloc);
 free_pages:
-	free_pages((unsigned long)virt, get_order(size));
+	free_pages(virt, get_order(size));
 
 	return ERR_PTR(err);
 }
@@ -1082,7 +1082,7 @@ void tegra_drm_free(struct tegra_drm *tegra, size_t size, void *virt,
 			  iova_pfn(&tegra->carveout.domain, dma));
 	}
 
-	free_pages((unsigned long)virt, get_order(size));
+	free_pages(virt, get_order(size));
 }
 
 static bool host1x_drm_wants_iommu(struct host1x_device *dev)
diff --git a/drivers/hsi/clients/cmt_speech.c b/drivers/hsi/clients/cmt_speech.c
index ed7f80d1dd41..5f943f32c080 100644
--- a/drivers/hsi/clients/cmt_speech.c
+++ b/drivers/hsi/clients/cmt_speech.c
@@ -1307,7 +1307,7 @@ static int cs_char_open(struct inode *unused, struct file *file)
 	return 0;
 
 out3:
-	free_page(p);
+	free_page((void *)p);
 out2:
 	spin_lock_bh(&cs_char_data.lock);
 	cs_char_data.opened = 0;
@@ -1338,7 +1338,7 @@ static int cs_char_release(struct inode *unused, struct file *file)
 	cs_hsi_stop(csdata->hi);
 	spin_lock_bh(&csdata->lock);
 	csdata->hi = NULL;
-	free_page(csdata->mmap_base);
+	free_page((void *)csdata->mmap_base);
 	cs_free_char_queue(&csdata->chardev_queue);
 	cs_free_char_queue(&csdata->dataind_queue);
 	csdata->opened = 0;
diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 54cc6e08566b..4a221949a4db 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -351,23 +351,21 @@ void vmbus_disconnect(void)
 		destroy_workqueue(vmbus_connection.work_queue);
 
 	if (vmbus_connection.int_page) {
-		free_page((unsigned long)vmbus_connection.int_page);
+		free_page(vmbus_connection.int_page);
 		vmbus_connection.int_page = NULL;
 	}
 
 	if (vmbus_connection.monitor_pages[0]) {
 		if (!set_memory_encrypted(
 			(unsigned long)vmbus_connection.monitor_pages[0], 1))
-			free_page((unsigned long)
-				vmbus_connection.monitor_pages[0]);
+			free_page(vmbus_connection.monitor_pages[0]);
 		vmbus_connection.monitor_pages[0] = NULL;
 	}
 
 	if (vmbus_connection.monitor_pages[1]) {
 		if (!set_memory_encrypted(
 			(unsigned long)vmbus_connection.monitor_pages[1], 1))
-			free_page((unsigned long)
-				vmbus_connection.monitor_pages[1]);
+			free_page(vmbus_connection.monitor_pages[1]);
 		vmbus_connection.monitor_pages[1] = NULL;
 	}
 }
diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
index 7e8bc36609cd..0471e4a70c6e 100644
--- a/drivers/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -159,7 +159,7 @@ int hv_synic_alloc(void)
 			if (!hv_cpu->synic_event_page) {
 				pr_err("Unable to allocate SYNIC event page\n");
 
-				free_page((unsigned long)hv_cpu->synic_message_page);
+				free_page(hv_cpu->synic_message_page);
 				hv_cpu->synic_message_page = NULL;
 				goto err;
 			}
@@ -177,7 +177,7 @@ int hv_synic_alloc(void)
 				 * Free the event page here so that hv_synic_free()
 				 * won't later try to re-encrypt it.
 				 */
-				free_page((unsigned long)hv_cpu->synic_event_page);
+				free_page(hv_cpu->synic_event_page);
 				hv_cpu->synic_event_page = NULL;
 				goto err;
 			}
@@ -246,9 +246,9 @@ void hv_synic_free(void)
 			}
 		}
 
-		free_page((unsigned long)hv_cpu->post_msg_page);
-		free_page((unsigned long)hv_cpu->synic_event_page);
-		free_page((unsigned long)hv_cpu->synic_message_page);
+		free_page(hv_cpu->post_msg_page);
+		free_page(hv_cpu->synic_event_page);
+		free_page(hv_cpu->synic_message_page);
 	}
 
 	kfree(hv_context.hv_numa_map);
diff --git a/drivers/hv/hv_proc.c b/drivers/hv/hv_proc.c
index fbb4eb3901bb..6b3a3059b870 100644
--- a/drivers/hv/hv_proc.c
+++ b/drivers/hv/hv_proc.c
@@ -42,7 +42,7 @@ int hv_call_deposit_pages(int node, u64 partition_id, u32 num_pages)
 
 	counts = kcalloc(HV_DEPOSIT_MAX, sizeof(int), GFP_KERNEL);
 	if (!counts) {
-		free_page((unsigned long)pages);
+		free_page(pages);
 		return -ENOMEM;
 	}
 
@@ -104,7 +104,7 @@ int hv_call_deposit_pages(int node, u64 partition_id, u32 num_pages)
 	}
 
 free_buf:
-	free_page((unsigned long)pages);
+	free_page(pages);
 	kfree(counts);
 	return ret;
 }
diff --git a/drivers/hv/mshv_root_hv_call.c b/drivers/hv/mshv_root_hv_call.c
index c9c274f29c3c..b32ef0b59cab 100644
--- a/drivers/hv/mshv_root_hv_call.c
+++ b/drivers/hv/mshv_root_hv_call.c
@@ -81,7 +81,7 @@ int hv_call_withdraw_memory(u64 count, int node, u64 partition_id)
 
 		remaining -= completed;
 	}
-	free_page((unsigned long)output_page);
+	free_page(output_page);
 
 	return hv_result_to_errno(status);
 }
diff --git a/drivers/hv/mshv_root_main.c b/drivers/hv/mshv_root_main.c
index e3b2bd417c46..86f905b7e21c 100644
--- a/drivers/hv/mshv_root_main.c
+++ b/drivers/hv/mshv_root_main.c
@@ -249,7 +249,7 @@ static int mshv_ioctl_passthru_hvcall(struct mshv_partition *partition,
 		ret = -EFAULT;
 
 free_pages_out:
-	free_pages((unsigned long)input_pg, pages_order);
+	free_pages(input_pg, pages_order);
 
 	return ret;
 }
diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 2627f3867dbd..9a41488650cb 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -261,7 +261,7 @@ struct ib_umem *ib_umem_get(struct ib_device *device, unsigned long addr,
 	__ib_umem_release(device, umem, 0);
 	atomic64_sub(ib_umem_num_pages(umem), &mm->pinned_vm);
 out:
-	free_page((unsigned long) page_list);
+	free_page(page_list);
 umem_kfree:
 	if (ret) {
 		mmdrop(umem->owning_mm);
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 301ddcb3d573..bf087aa3220e 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1831,7 +1831,7 @@ int bnxt_re_destroy_srq(struct ib_srq *ib_srq, struct ib_udata *udata)
 	struct bnxt_qplib_srq *qplib_srq = &srq->qplib_srq;
 
 	if (rdev->chip_ctx->modes.toggle_bits & BNXT_QPLIB_SRQ_TOGGLE_BIT) {
-		free_page((unsigned long)srq->uctx_srq_page);
+		free_page(srq->uctx_srq_page);
 		hash_del(&srq->hash_entry);
 	}
 	bnxt_qplib_destroy_srq(&rdev->qplib_res, qplib_srq);
@@ -3112,7 +3112,7 @@ int bnxt_re_destroy_cq(struct ib_cq *ib_cq, struct ib_udata *udata)
 	cctx = rdev->chip_ctx;
 
 	if (cctx->modes.toggle_bits & BNXT_QPLIB_CQ_TOGGLE_BIT) {
-		free_page((unsigned long)cq->uctx_cq_page);
+		free_page(cq->uctx_cq_page);
 		hash_del(&cq->hash_entry);
 	}
 	bnxt_qplib_destroy_cq(&rdev->qplib_res, &cq->qplib_cq);
@@ -3232,7 +3232,7 @@ int bnxt_re_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	return 0;
 
 free_mem:
-	free_page((unsigned long)cq->uctx_cq_page);
+	free_page(cq->uctx_cq_page);
 c2fail:
 	ib_umem_release(cq->umem);
 fail:
@@ -4419,7 +4419,7 @@ int bnxt_re_alloc_ucontext(struct ib_ucontext *ctx, struct ib_udata *udata)
 
 	return 0;
 cfail:
-	free_page((unsigned long)uctx->shpg);
+	free_page(uctx->shpg);
 	uctx->shpg = NULL;
 fail:
 	return rc;
@@ -4436,7 +4436,7 @@ void bnxt_re_dealloc_ucontext(struct ib_ucontext *ib_uctx)
 	rdma_user_mmap_entry_remove(uctx->shpage_mmap);
 	uctx->shpage_mmap = NULL;
 	if (uctx->shpg)
-		free_page((unsigned long)uctx->shpg);
+		free_page(uctx->shpg);
 
 	if (uctx->dpi.dbr) {
 		/* Free DPI only if this is the first PD allocated by the
diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index e0b42f6d9049..7f3c27617149 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -870,7 +870,7 @@ static int bnxt_re_initialize_dbr_pacing(struct bnxt_re_dev *rdev)
 	rdev->qplib_res.pacing_data = (struct bnxt_qplib_db_pacing_data *)rdev->pacing.dbr_page;
 
 	if (bnxt_re_hwrm_dbr_pacing_qcfg(rdev)) {
-		free_page((u64)rdev->pacing.dbr_page);
+		free_page(rdev->pacing.dbr_page);
 		rdev->pacing.dbr_page = NULL;
 		return -EIO;
 	}
@@ -885,7 +885,7 @@ static int bnxt_re_initialize_dbr_pacing(struct bnxt_re_dev *rdev)
 		pci_resource_start(rdev->qplib_res.pdev, 0) + rdev->pacing.dbr_db_fifo_reg_off;
 
 	if (is_dbr_fifo_full(rdev)) {
-		free_page((u64)rdev->pacing.dbr_page);
+		free_page(rdev->pacing.dbr_page);
 		rdev->pacing.dbr_page = NULL;
 		return -EIO;
 	}
@@ -907,7 +907,7 @@ static void bnxt_re_deinitialize_dbr_pacing(struct bnxt_re_dev *rdev)
 	cancel_work_sync(&rdev->dbq_fifo_check_work);
 	cancel_delayed_work_sync(&rdev->dbq_pacing_work);
 	if (rdev->pacing.dbr_page)
-		free_page((u64)rdev->pacing.dbr_page);
+		free_page(rdev->pacing.dbr_page);
 
 	rdev->pacing.dbr_page = NULL;
 	rdev->pacing.dbr_pacing = false;
diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index 47dbe3e02100..c51d9bae325a 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -906,7 +906,7 @@ static int c4iw_rdev_open(struct c4iw_rdev *rdev)
 	return 0;
 err_free_status_page_and_wr_log:
 	kfree(rdev->wr_log);
-	free_page((unsigned long)rdev->status_page);
+	free_page(rdev->status_page);
 destroy_ocqp_pool:
 	c4iw_ocqp_pool_destroy(rdev);
 destroy_rqtpool:
@@ -922,7 +922,7 @@ static void c4iw_rdev_close(struct c4iw_rdev *rdev)
 {
 	kfree(rdev->wr_log);
 	c4iw_release_dev_ucontext(rdev, &rdev->uctx);
-	free_page((unsigned long)rdev->status_page);
+	free_page(rdev->status_page);
 	c4iw_pblpool_destroy(rdev);
 	c4iw_rqtpool_destroy(rdev);
 	wait_for_completion(&rdev->pbl_compl);
diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index 941d4e0867b7..75e473ecebe7 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -568,7 +568,7 @@ struct ib_mr *c4iw_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 				mhp->wr_waitp);
 
 pbl_done:
-	free_page((unsigned long) pages);
+	free_page(pages);
 	if (err)
 		goto err_pbl_free;
 
diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
index 96ce8fe551d9..41d92a4900e8 100644
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -318,7 +318,7 @@ mlx4_alloc_priv_pages(struct ib_device *device,
 	return 0;
 
 err:
-	free_page((unsigned long)mr->pages);
+	free_page(mr->pages);
 	return ret;
 }
 
@@ -330,7 +330,7 @@ mlx4_free_priv_pages(struct mlx4_ib_mr *mr)
 
 		dma_unmap_single(device->dev.parent, mr->page_map,
 				 mr->page_map_size, DMA_TO_DEVICE);
-		free_page((unsigned long)mr->pages);
+		free_page(mr->pages);
 		mr->pages = NULL;
 	}
 }
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 61ee1e451cb8..0e199a33afd2 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -5123,7 +5123,7 @@ static int __init mlx5_ib_init(void)
 
 	mlx5_ib_event_wq = alloc_ordered_workqueue("mlx5_ib_event_wq", 0);
 	if (!mlx5_ib_event_wq) {
-		free_page((unsigned long)xlt_emergency_page);
+		free_page(xlt_emergency_page);
 		return -ENOMEM;
 	}
 
@@ -5157,7 +5157,7 @@ static int __init mlx5_ib_init(void)
 	mlx5_ib_qp_event_cleanup();
 qp_event_err:
 	destroy_workqueue(mlx5_ib_event_wq);
-	free_page((unsigned long)xlt_emergency_page);
+	free_page(xlt_emergency_page);
 	return ret;
 }
 
@@ -5170,7 +5170,7 @@ static void __exit mlx5_ib_cleanup(void)
 
 	mlx5_ib_qp_event_cleanup();
 	destroy_workqueue(mlx5_ib_event_wq);
-	free_page((unsigned long)xlt_emergency_page);
+	free_page(xlt_emergency_page);
 }
 
 module_init(mlx5_ib_init);
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 45818cfe1e38..9bd69755f81b 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -1464,7 +1464,7 @@ static void mlx5_ib_mr_wqe_pfault_handler(struct mlx5_ib_dev *dev,
 		    pfault->wqe.wq_num, resume_with_error,
 		    pfault->type);
 	mlx5_core_res_put(res);
-	free_page((unsigned long)wqe_start);
+	free_page(wqe_start);
 }
 
 static void mlx5_ib_mr_rdma_pfault_handler(struct mlx5_ib_dev *dev,
diff --git a/drivers/infiniband/hw/mlx5/umr.c b/drivers/infiniband/hw/mlx5/umr.c
index 012f2e246757..d6f08c8f36c2 100644
--- a/drivers/infiniband/hw/mlx5/umr.c
+++ b/drivers/infiniband/hw/mlx5/umr.c
@@ -547,7 +547,7 @@ static void mlx5r_umr_free_xlt(void *xlt, size_t length)
 		return;
 	}
 
-	free_pages((unsigned long)xlt, get_order(length));
+	free_pages(xlt, get_order(length));
 }
 
 static void mlx5r_umr_unmap_free_xlt(struct mlx5_ib_dev *dev, void *xlt,
diff --git a/drivers/infiniband/hw/mthca/mthca_allocator.c b/drivers/infiniband/hw/mthca/mthca_allocator.c
index 168571fb44fe..715c6404b5a0 100644
--- a/drivers/infiniband/hw/mthca/mthca_allocator.c
+++ b/drivers/infiniband/hw/mthca/mthca_allocator.c
@@ -142,7 +142,7 @@ void mthca_array_clear(struct mthca_array *array, int index)
 	int p = (index * sizeof (void *)) >> PAGE_SHIFT;
 
 	if (--array->page_list[p].used == 0) {
-		free_page((unsigned long) array->page_list[p].page);
+		free_page(array->page_list[p].page);
 		array->page_list[p].page = NULL;
 	} else
 		array->page_list[p].page[index & MTHCA_ARRAY_MASK] = NULL;
@@ -175,7 +175,7 @@ void mthca_array_cleanup(struct mthca_array *array, int nent)
 	int i;
 
 	for (i = 0; i < (nent * sizeof (void *) + PAGE_SIZE - 1) / PAGE_SIZE; ++i)
-		free_page((unsigned long) array->page_list[i].page);
+		free_page(array->page_list[i].page);
 
 	kfree(array->page_list);
 }
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index 05158af473e3..0d2350d193c8 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -900,7 +900,7 @@ static struct ib_mr *mthca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	if (i)
 		err = mthca_write_mtt(dev, mr->mtt, n, pages, i);
 mtt_done:
-	free_page((unsigned long) pages);
+	free_page(pages);
 	if (err)
 		goto err_mtt;
 
diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 35eb942fc8aa..13d482922b7a 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -378,7 +378,7 @@ void qedr_mmap_free(struct rdma_user_mmap_entry *rdma_entry)
 	struct qedr_dev *dev = entry->dev;
 
 	if (entry->mmap_flag == QEDR_USER_MMAP_PHYS_PAGE)
-		free_page((unsigned long)entry->address);
+		free_page(entry->address);
 	else if (entry->mmap_flag == QEDR_USER_MMAP_IO_WC)
 		dev->ops->rdma_remove_user(dev->rdma_ctx, entry->dpi);
 
@@ -782,7 +782,7 @@ static int qedr_init_user_db_rec(struct ib_udata *udata,
 	kfree(entry);
 
 err_free_db_data:
-	free_page((unsigned long)q->db_rec_data);
+	free_page(q->db_rec_data);
 	q->db_rec_data = NULL;
 	return -ENOMEM;
 }
diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.c b/drivers/infiniband/hw/usnic/usnic_uiom.c
index 20bd02120a0c..e7914984a6f3 100644
--- a/drivers/infiniband/hw/usnic/usnic_uiom.c
+++ b/drivers/infiniband/hw/usnic/usnic_uiom.c
@@ -183,7 +183,7 @@ static int usnic_uiom_get_pages(unsigned long addr, size_t size, int writable,
 		mmgrab(uiomr->owning_mm);
 
 	mmap_read_unlock(mm);
-	free_page((unsigned long) page_list);
+	free_page(page_list);
 	return ret;
 }
 
diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index ce64dc5fa285..2f6da02fd5d0 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -273,7 +273,7 @@ static void get_map_page(struct rvt_qpn_table *qpt,
 
 	spin_lock(&qpt->lock);
 	if (map->page)
-		free_page(page);
+		free_page((void *)page);
 	else
 		map->page = (void *)page;
 	spin_unlock(&qpt->lock);
@@ -345,7 +345,7 @@ static void free_qpn_table(struct rvt_qpn_table *qpt)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(qpt->map); i++)
-		free_page((unsigned long)qpt->map[i].page);
+		free_page(qpt->map[i].page);
 }
 
 /**
diff --git a/drivers/input/misc/xen-kbdfront.c b/drivers/input/misc/xen-kbdfront.c
index 3b29b7aec26f..102e79c2869d 100644
--- a/drivers/input/misc/xen-kbdfront.c
+++ b/drivers/input/misc/xen-kbdfront.c
@@ -415,7 +415,7 @@ static void xenkbd_remove(struct xenbus_device *dev)
 		input_unregister_device(info->ptr);
 	if (info->mtouch)
 		input_unregister_device(info->mtouch);
-	free_page((unsigned long)info->page);
+	free_page(info->page);
 	kfree(info);
 }
 
diff --git a/drivers/iommu/fsl_pamu.c b/drivers/iommu/fsl_pamu.c
index f37d3b044131..d2d61006c571 100644
--- a/drivers/iommu/fsl_pamu.c
+++ b/drivers/iommu/fsl_pamu.c
@@ -916,7 +916,7 @@ static int fsl_pamu_probe(struct platform_device *pdev)
 		iounmap(guts_regs);
 
 	if (ppaact)
-		free_pages((unsigned long)ppaact, order);
+		free_pages(ppaact, order);
 
 	ppaact = NULL;
 
diff --git a/drivers/iommu/io-pgtable-arm-v7s.c b/drivers/iommu/io-pgtable-arm-v7s.c
index 2de8985dae85..2b1bb17b891a 100644
--- a/drivers/iommu/io-pgtable-arm-v7s.c
+++ b/drivers/iommu/io-pgtable-arm-v7s.c
@@ -289,7 +289,7 @@ static void *__arm_v7s_alloc_table(int lvl, gfp_t gfp,
 	dma_unmap_single(dev, dma, size, DMA_TO_DEVICE);
 out_free:
 	if (lvl == 1)
-		free_pages((unsigned long)table, get_order(size));
+		free_pages(table, get_order(size));
 	else
 		kmem_cache_free(data->l2_tables, table);
 	return NULL;
@@ -306,7 +306,7 @@ static void __arm_v7s_free_table(void *table, int lvl,
 		dma_unmap_single(dev, __arm_v7s_dma_addr(table), size,
 				 DMA_TO_DEVICE);
 	if (lvl == 1)
-		free_pages((unsigned long)table, get_order(size));
+		free_pages(table, get_order(size));
 	else
 		kmem_cache_free(data->l2_tables, table);
 }
diff --git a/drivers/iommu/iommufd/iova_bitmap.c b/drivers/iommu/iommufd/iova_bitmap.c
index a0cccd040969..6fce34d8b8cd 100644
--- a/drivers/iommu/iommufd/iova_bitmap.c
+++ b/drivers/iommu/iommufd/iova_bitmap.c
@@ -288,7 +288,7 @@ void iova_bitmap_free(struct iova_bitmap *bitmap)
 	iova_bitmap_put(bitmap);
 
 	if (mapped->pages) {
-		free_page((unsigned long)mapped->pages);
+		free_page(mapped->pages);
 		mapped->pages = NULL;
 	}
 
diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index 1f90fc24b7a6..a134aad3c8aa 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -699,7 +699,7 @@ static void mock_viommu_destroy(struct iommufd_viommu *viommu)
 	if (mock_viommu->mmap_offset)
 		iommufd_viommu_destroy_mmap(&mock_viommu->core,
 					    mock_viommu->mmap_offset);
-	free_page((unsigned long)mock_viommu->page);
+	free_page(mock_viommu->page);
 	mutex_destroy(&mock_viommu->queue_mutex);
 
 	/* iommufd core frees mock_viommu and viommu */
@@ -933,7 +933,7 @@ static int mock_viommu_init(struct iommufd_viommu *viommu,
 	iommufd_viommu_destroy_mmap(&mock_viommu->core,
 				    mock_viommu->mmap_offset);
 err_free_page:
-	free_page((unsigned long)mock_viommu->page);
+	free_page(mock_viommu->page);
 	return rc;
 }
 
diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 467cb78435a9..7a08b4de9286 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -247,7 +247,7 @@ static void its_free_pages(void *addr, unsigned int order)
 	 */
 	if (set_memory_encrypted((unsigned long)addr, 1 << order))
 		return;
-	free_pages((unsigned long)addr, order);
+	free_pages(addr, order);
 }
 
 static struct gen_pool *itt_pool;
diff --git a/drivers/macintosh/rack-meter.c b/drivers/macintosh/rack-meter.c
index 59d3d82357a9..978ed0c521d6 100644
--- a/drivers/macintosh/rack-meter.c
+++ b/drivers/macintosh/rack-meter.c
@@ -509,7 +509,7 @@ static int rackmeter_probe(struct macio_dev* mdev,
 			  sizeof(struct rackmeter_dma),
 			  rm->dma_buf_v, rm->dma_buf_p);
  bail_free_samples:
-	free_page((unsigned long)rm->ubuf);
+	free_page(rm->ubuf);
  bail_release:
 #if 0
 	macio_release_resources(mdev);
@@ -549,7 +549,7 @@ static void rackmeter_remove(struct macio_dev *mdev)
 			  rm->dma_buf_v, rm->dma_buf_p);
 
 	/* Free samples */
-	free_page((unsigned long)rm->ubuf);
+	free_page(rm->ubuf);
 
 #if 0
 	/* Release resources */
diff --git a/drivers/mailbox/riscv-sbi-mpxy-mbox.c b/drivers/mailbox/riscv-sbi-mpxy-mbox.c
index 7c9c006b7244..b562118c1d9c 100644
--- a/drivers/mailbox/riscv-sbi-mpxy-mbox.c
+++ b/drivers/mailbox/riscv-sbi-mpxy-mbox.c
@@ -357,7 +357,7 @@ static int mpxy_setup_shmem(unsigned int cpu)
 	sret = sbi_ecall(SBI_EXT_MPXY, SBI_EXT_MPXY_SET_SHMEM,
 			 page_to_phys(shmem_page), 0, 0, 0, 0, 0);
 	if (sret.error) {
-		free_pages((unsigned long)page_to_virt(shmem_page),
+		free_pages(page_to_virt(shmem_page),
 			   get_order(mpxy_shmem_size));
 		return sbi_err_map_linux_errno(sret.error);
 	}
diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
index 3f27d2bb642b..508b6b0de31b 100644
--- a/drivers/md/bcache/bset.c
+++ b/drivers/md/bcache/bset.c
@@ -296,16 +296,14 @@ void bch_btree_keys_free(struct btree_keys *b)
 	if (bset_prev_bytes(b) < PAGE_SIZE)
 		kfree(t->prev);
 	else
-		free_pages((unsigned long) t->prev,
-			   get_order(bset_prev_bytes(b)));
+		free_pages(t->prev, get_order(bset_prev_bytes(b)));
 
 	if (bset_tree_bytes(b) < PAGE_SIZE)
 		kfree(t->tree);
 	else
-		free_pages((unsigned long) t->tree,
-			   get_order(bset_tree_bytes(b)));
+		free_pages(t->tree, get_order(bset_tree_bytes(b)));
 
-	free_pages((unsigned long) t->data, b->page_order);
+	free_pages(t->data, b->page_order);
 
 	t->prev = NULL;
 	t->tree = NULL;
@@ -1281,7 +1279,7 @@ static void __btree_sort(struct btree_keys *b, struct btree_iter *iter,
 	if (used_mempool)
 		mempool_free(virt_to_page(out), &state->pool);
 	else
-		free_pages((unsigned long) out, order);
+		free_pages(out, order);
 
 	bch_bset_build_written_tree(b);
 
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 099ddbe60a8f..26f2228cff1d 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -758,7 +758,7 @@ void bch_btree_cache_free(struct cache_set *c)
 	if (c->verify_data)
 		list_move(&c->verify_data->list, &c->btree_cache);
 
-	free_pages((unsigned long) c->verify_ondisk, ilog2(meta_bucket_pages(&c->cache->sb)));
+	free_pages(c->verify_ondisk, ilog2(meta_bucket_pages(&c->cache->sb)));
 #endif
 
 	list_splice(&c->btree_cache_freeable,
diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 28d80f0c0c08..ec77519e245a 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -973,8 +973,8 @@ void bch_journal_meta(struct cache_set *c, struct closure *cl)
 
 void bch_journal_free(struct cache_set *c)
 {
-	free_pages((unsigned long) c->journal.w[1].data, JSET_BITS);
-	free_pages((unsigned long) c->journal.w[0].data, JSET_BITS);
+	free_pages(c->journal.w[1].data, JSET_BITS);
+	free_pages(c->journal.w[0].data, JSET_BITS);
 	free_fifo(&c->journal.pin);
 }
 
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index e124a47eba81..c2e20e8d8941 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1676,7 +1676,7 @@ static CLOSURE_CALLBACK(cache_set_free)
 
 	mutex_lock(&bch_register_lock);
 	bch_bset_sort_state_free(&c->sort);
-	free_pages((unsigned long) c->uuids, ilog2(meta_bucket_pages(&c->cache->sb)));
+	free_pages(c->uuids, ilog2(meta_bucket_pages(&c->cache->sb)));
 
 	ca = c->cache;
 	if (ca) {
@@ -2205,7 +2205,7 @@ void bch_cache_release(struct kobject *kobj)
 		ca->set->cache = NULL;
 	}
 
-	free_pages((unsigned long) ca->disk_buckets, ilog2(meta_bucket_pages(&ca->sb)));
+	free_pages(ca->disk_buckets, ilog2(meta_bucket_pages(&ca->sb)));
 	kfree(ca->prio_buckets);
 	vfree(ca->buckets);
 
diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 96af91c7430f..a948622e61c6 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1206,7 +1206,7 @@ static void free_buffer_data(struct dm_bufio_client *c,
 		break;
 
 	case DATA_MODE_GET_FREE_PAGES:
-		free_pages((unsigned long)data,
+		free_pages(data,
 			   c->sectors_per_block_bits - (PAGE_SHIFT - SECTOR_SHIFT));
 		break;
 
diff --git a/drivers/media/pci/intel/ipu6/ipu6-mmu.c b/drivers/media/pci/intel/ipu6/ipu6-mmu.c
index 98429b23cf36..16e2fbdbf1f4 100644
--- a/drivers/media/pci/intel/ipu6/ipu6-mmu.c
+++ b/drivers/media/pci/intel/ipu6/ipu6-mmu.c
@@ -158,7 +158,7 @@ static int get_dummy_page(struct ipu6_mmu_info *mmu_info)
 	return 0;
 
 err_free_page:
-	free_page((unsigned long)pt);
+	free_page(pt);
 	return -ENOMEM;
 }
 
@@ -167,7 +167,7 @@ static void free_dummy_page(struct ipu6_mmu_info *mmu_info)
 	dma_unmap_single(mmu_info->dev,
 			 TBL_PHYS_ADDR(mmu_info->dummy_page_pteval),
 			 PAGE_SIZE, DMA_BIDIRECTIONAL);
-	free_page((unsigned long)mmu_info->dummy_page);
+	free_page(mmu_info->dummy_page);
 }
 
 static int alloc_dummy_l2_pt(struct ipu6_mmu_info *mmu_info)
@@ -196,7 +196,7 @@ static int alloc_dummy_l2_pt(struct ipu6_mmu_info *mmu_info)
 	return 0;
 
 err_free_page:
-	free_page((unsigned long)pt);
+	free_page(pt);
 	return -ENOMEM;
 }
 
@@ -205,7 +205,7 @@ static void free_dummy_l2_pt(struct ipu6_mmu_info *mmu_info)
 	dma_unmap_single(mmu_info->dev,
 			 TBL_PHYS_ADDR(mmu_info->dummy_l2_pteval),
 			 PAGE_SIZE, DMA_BIDIRECTIONAL);
-	free_page((unsigned long)mmu_info->dummy_l2_pt);
+	free_page(mmu_info->dummy_l2_pt);
 }
 
 static u32 *alloc_l1_pt(struct ipu6_mmu_info *mmu_info)
@@ -234,7 +234,7 @@ static u32 *alloc_l1_pt(struct ipu6_mmu_info *mmu_info)
 	return pt;
 
 err_free_page:
-	free_page((unsigned long)pt);
+	free_page(pt);
 	return NULL;
 }
 
@@ -340,7 +340,7 @@ static int l2_map(struct ipu6_mmu_info *mmu_info, unsigned long iova,
 			dma = map_single(mmu_info, l2_virt);
 			if (!dma) {
 				dev_err(dev, "Failed to map l2pt page\n");
-				free_page((unsigned long)l2_virt);
+				free_page(l2_virt);
 				err = -EINVAL;
 				goto error;
 			}
@@ -732,7 +732,7 @@ static void ipu6_mmu_destroy(struct ipu6_mmu *mmu)
 			dma_unmap_single(mmu_info->dev,
 					 TBL_PHYS_ADDR(mmu_info->l1_pt[l1_idx]),
 					 PAGE_SIZE, DMA_BIDIRECTIONAL);
-			free_page((unsigned long)mmu_info->l2_pts[l1_idx]);
+			free_page(mmu_info->l2_pts[l1_idx]);
 		}
 	}
 
@@ -740,8 +740,8 @@ static void ipu6_mmu_destroy(struct ipu6_mmu *mmu)
 	free_dummy_page(mmu_info);
 	dma_unmap_single(mmu_info->dev, TBL_PHYS_ADDR(mmu_info->l1_pt_dma),
 			 PAGE_SIZE, DMA_BIDIRECTIONAL);
-	free_page((unsigned long)mmu_info->dummy_l2_pt);
-	free_page((unsigned long)mmu_info->l1_pt);
+	free_page(mmu_info->dummy_l2_pt);
+	free_page(mmu_info->l1_pt);
 	kfree(mmu_info);
 }
 
diff --git a/drivers/media/pci/pt1/pt1.c b/drivers/media/pci/pt1/pt1.c
index 1e53b2d6b3f2..301847ef3d06 100644
--- a/drivers/media/pci/pt1/pt1.c
+++ b/drivers/media/pci/pt1/pt1.c
@@ -817,7 +817,7 @@ static void pt1_free_adapter(struct pt1_adapter *adap)
 	dvb_dmxdev_release(&adap->dmxdev);
 	dvb_dmx_release(&adap->demux);
 	dvb_unregister_adapter(&adap->adap);
-	free_page((unsigned long)adap->buf);
+	free_page(adap->buf);
 	kfree(adap);
 }
 
@@ -889,7 +889,7 @@ pt1_alloc_adapter(struct pt1 *pt1)
 err_unregister_adapter:
 	dvb_unregister_adapter(dvb_adap);
 err_free_page:
-	free_page((unsigned long)buf);
+	free_page(buf);
 err_kfree:
 	kfree(adap);
 err:
diff --git a/drivers/media/pci/saa7134/saa7134-go7007.c b/drivers/media/pci/saa7134/saa7134-go7007.c
index 7567f2e91932..5c04ad926f8b 100644
--- a/drivers/media/pci/saa7134/saa7134-go7007.c
+++ b/drivers/media/pci/saa7134/saa7134-go7007.c
@@ -462,9 +462,9 @@ static int saa7134_go7007_init(struct saa7134_dev *dev)
 
 allocfail:
 	if (saa->top)
-		free_page((unsigned long)saa->top);
+		free_page(saa->top);
 	if (saa->bottom)
-		free_page((unsigned long)saa->bottom);
+		free_page(saa->bottom);
 	kfree(saa);
 	kfree(go);
 	return -ENOMEM;
@@ -484,8 +484,8 @@ static int saa7134_go7007_fini(struct saa7134_dev *dev)
 
 	saa = go->hpi_context;
 	go->status = STATUS_SHUTDOWN;
-	free_page((unsigned long)saa->top);
-	free_page((unsigned long)saa->bottom);
+	free_page(saa->top);
+	free_page(saa->bottom);
 	v4l2_device_unregister_subdev(&saa->sd);
 	kfree(saa);
 	vb2_video_unregister_device(&go->vdev);
diff --git a/drivers/media/pci/solo6x10/solo6x10-p2m.c b/drivers/media/pci/solo6x10/solo6x10-p2m.c
index b3fa623d74b3..eba570a42b79 100644
--- a/drivers/media/pci/solo6x10/solo6x10-p2m.c
+++ b/drivers/media/pci/solo6x10/solo6x10-p2m.c
@@ -215,7 +215,7 @@ static int solo_p2m_test(struct solo_dev *solo_dev, int base, int size)
 
 	rd_buf = __get_free_pages(GFP_KERNEL, order);
 	if (rd_buf == NULL) {
-		free_pages((unsigned long)wr_buf, order);
+		free_pages(wr_buf, order);
 		return -1;
 	}
 
@@ -241,8 +241,8 @@ static int solo_p2m_test(struct solo_dev *solo_dev, int base, int size)
 	ret = 0;
 
 test_fail:
-	free_pages((unsigned long)wr_buf, order);
-	free_pages((unsigned long)rd_buf, order);
+	free_pages(wr_buf, order);
+	free_pages(rd_buf, order);
 
 	return ret;
 }
diff --git a/drivers/media/platform/ti/omap/omap_voutlib.c b/drivers/media/platform/ti/omap/omap_voutlib.c
index 8c60f00ecef7..4d975642fb76 100644
--- a/drivers/media/platform/ti/omap/omap_voutlib.c
+++ b/drivers/media/platform/ti/omap/omap_voutlib.c
@@ -339,7 +339,7 @@ void omap_vout_free_buffer(unsigned long virtaddr, u32 buf_size)
 		addr += PAGE_SIZE;
 		size -= PAGE_SIZE;
 	}
-	free_pages((unsigned long) virtaddr, order);
+	free_pages((void *)virtaddr, order);
 }
 
 bool omap_vout_dss_omap24xx(void)
diff --git a/drivers/misc/ibmvmc.c b/drivers/misc/ibmvmc.c
index adee4f06f61b..f10f6f766b72 100644
--- a/drivers/misc/ibmvmc.c
+++ b/drivers/misc/ibmvmc.c
@@ -154,7 +154,7 @@ static void ibmvmc_release_crq_queue(struct crq_server_adapter *adapter)
 	dma_unmap_single(adapter->dev,
 			 queue->msg_token,
 			 queue->size * sizeof(*queue->msgs), DMA_BIDIRECTIONAL);
-	free_page((unsigned long)queue->msgs);
+	free_page(queue->msgs);
 }
 
 /**
@@ -2179,7 +2179,7 @@ static int ibmvmc_init_crq_queue(struct crq_server_adapter *adapter)
 			 queue->msg_token,
 			 queue->size * sizeof(*queue->msgs), DMA_BIDIRECTIONAL);
 map_failed:
-	free_page((unsigned long)queue->msgs);
+	free_page(queue->msgs);
 malloc_failed:
 	return -ENOMEM;
 }
diff --git a/drivers/misc/lkdtm/core.c b/drivers/misc/lkdtm/core.c
index ae0a1c6c393a..0562c2f0b052 100644
--- a/drivers/misc/lkdtm/core.c
+++ b/drivers/misc/lkdtm/core.c
@@ -240,7 +240,7 @@ static ssize_t lkdtm_debugfs_entry(struct file *f,
 	if (!buf)
 		return -ENOMEM;
 	if (copy_from_user(buf, user_buf, count)) {
-		free_page((unsigned long) buf);
+		free_page(buf);
 		return -EFAULT;
 	}
 	/* NULL-terminate and remove enter */
@@ -248,7 +248,7 @@ static ssize_t lkdtm_debugfs_entry(struct file *f,
 	strim(buf);
 
 	crashtype = find_crashtype(buf);
-	free_page((unsigned long)buf);
+	free_page(buf);
 
 	if (!crashtype)
 		return -EINVAL;
@@ -290,7 +290,7 @@ static ssize_t lkdtm_debugfs_read(struct file *f, char __user *user_buf,
 
 	out = simple_read_from_buffer(user_buf, count, off,
 				      buf, n);
-	free_page((unsigned long) buf);
+	free_page(buf);
 
 	return out;
 }
@@ -317,7 +317,7 @@ static ssize_t direct_entry(struct file *f, const char __user *user_buf,
 	if (!buf)
 		return -ENOMEM;
 	if (copy_from_user(buf, user_buf, count)) {
-		free_page((unsigned long) buf);
+		free_page(buf);
 		return -EFAULT;
 	}
 	/* NULL-terminate and remove enter */
@@ -325,7 +325,7 @@ static ssize_t direct_entry(struct file *f, const char __user *user_buf,
 	strim(buf);
 
 	crashtype = find_crashtype(buf);
-	free_page((unsigned long) buf);
+	free_page(buf);
 	if (!crashtype)
 		return -EINVAL;
 
diff --git a/drivers/misc/lkdtm/heap.c b/drivers/misc/lkdtm/heap.c
index 14c1503d21e8..b445262e09c7 100644
--- a/drivers/misc/lkdtm/heap.c
+++ b/drivers/misc/lkdtm/heap.c
@@ -201,13 +201,13 @@ static void lkdtm_WRITE_BUDDY_AFTER_FREE(void)
 
 	pr_info("Writing to the buddy page before free\n");
 	memset((void *)p, 0x3, PAGE_SIZE);
-	free_page(p);
+	free_page((void *)p);
 	schedule();
 	pr_info("Attempting bad write to the buddy page after free\n");
 	memset((void *)p, 0x78, PAGE_SIZE);
 	/* Attempt to notice the overwrite. */
 	p = (unsigned long)__get_free_page(GFP_KERNEL);
-	free_page(p);
+	free_page((void *)p);
 	schedule();
 }
 
@@ -225,7 +225,7 @@ static void lkdtm_READ_BUDDY_AFTER_FREE(void)
 	val = kmalloc(1024, GFP_KERNEL);
 	if (!val) {
 		pr_info("Unable to allocate val memory.\n");
-		free_page(p);
+		free_page((void *)p);
 		return;
 	}
 
@@ -234,7 +234,7 @@ static void lkdtm_READ_BUDDY_AFTER_FREE(void)
 	*val = 0x12345678;
 	base[0] = *val;
 	pr_info("Value in memory before free: %x\n", base[0]);
-	free_page(p);
+	free_page((void *)p);
 	pr_info("Attempting to read from freed memory\n");
 	saw = base[0];
 	if (saw != *val) {
@@ -292,7 +292,7 @@ static void lkdtm_BUDDY_INIT_ON_ALLOC(void)
 	}
 
 	memset(first, 0xAB, PAGE_SIZE);
-	free_page((unsigned long)first);
+	free_page(first);
 
 	val = __get_free_page(GFP_KERNEL);
 	if (!val) {
@@ -310,7 +310,7 @@ static void lkdtm_BUDDY_INIT_ON_ALLOC(void)
 		pr_err("FAIL: Slab was not initialized\n");
 		pr_expected_config_param(CONFIG_INIT_ON_ALLOC_DEFAULT_ON, "init_on_alloc");
 	}
-	free_page((unsigned long)val);
+	free_page(val);
 }
 
 static void lkdtm_SLAB_FREE_DOUBLE(void)
@@ -352,7 +352,7 @@ static void lkdtm_SLAB_FREE_PAGE(void)
 
 	pr_info("Attempting non-Slab slab free ...\n");
 	kmem_cache_free(NULL, (void *)p);
-	free_page(p);
+	free_page((void *)p);
 }
 
 void __init lkdtm_heap_init(void)
diff --git a/drivers/misc/ocxl/link.c b/drivers/misc/ocxl/link.c
index 064689f1ad30..b9c256c5088f 100644
--- a/drivers/misc/ocxl/link.c
+++ b/drivers/misc/ocxl/link.c
@@ -376,7 +376,7 @@ static void free_spa(struct ocxl_link *link)
 		link->dev);
 
 	if (spa && spa->spa_mem) {
-		free_pages((unsigned long) spa->spa_mem, spa->spa_order);
+		free_pages(spa->spa_mem, spa->spa_order);
 		kfree(spa);
 		link->spa = NULL;
 	}
diff --git a/drivers/misc/sgi-gru/grufile.c b/drivers/misc/sgi-gru/grufile.c
index e755690c9805..97220533b298 100644
--- a/drivers/misc/sgi-gru/grufile.c
+++ b/drivers/misc/sgi-gru/grufile.c
@@ -294,7 +294,7 @@ static int gru_init_tables(unsigned long gru_base_paddr, void *gru_base_vaddr)
 
 fail:
 	for (bid--; bid >= 0; bid--)
-		free_pages((unsigned long)gru_base[bid], order);
+		free_pages(gru_base[bid], order);
 	return -ENOMEM;
 }
 
@@ -305,7 +305,7 @@ static void gru_free_tables(void)
 			      GRU_CHIPLETS_PER_BLADE);
 
 	for (bid = 0; bid < GRU_MAX_BLADES; bid++)
-		free_pages((unsigned long)gru_base[bid], order);
+		free_pages(gru_base[bid], order);
 }
 
 static unsigned long gru_chiplet_cpu_to_mmr(int chiplet, int cpu, int *corep)
diff --git a/drivers/misc/sgi-xp/xpc_uv.c b/drivers/misc/sgi-xp/xpc_uv.c
index 2f03a7080d96..47d5191954e2 100644
--- a/drivers/misc/sgi-xp/xpc_uv.c
+++ b/drivers/misc/sgi-xp/xpc_uv.c
@@ -227,7 +227,7 @@ xpc_create_gru_mq_uv(unsigned int mq_size, int cpu, char *irq_name,
 out_4:
 	xpc_gru_mq_watchlist_free_uv(mq);
 out_3:
-	free_pages((unsigned long)mq->address, pg_order);
+	free_pages(mq->address, pg_order);
 out_2:
 	kfree(mq->gru_mq_desc);
 out_1:
@@ -256,7 +256,7 @@ xpc_destroy_gru_mq_uv(struct xpc_gru_mq_uv *mq)
 	xpc_gru_mq_watchlist_free_uv(mq);
 
 	pg_order = mq->order - PAGE_SHIFT;
-	free_pages((unsigned long)mq->address, pg_order);
+	free_pages(mq->address, pg_order);
 
 	kfree(mq);
 }
diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
index cc1d18b3df5c..7b70454e4fb3 100644
--- a/drivers/misc/vmw_balloon.c
+++ b/drivers/misc/vmw_balloon.c
@@ -1290,7 +1290,7 @@ static unsigned long vmballoon_deflate(struct vmballoon *b, uint64_t n_frames,
  */
 static void vmballoon_deinit_batching(struct vmballoon *b)
 {
-	free_page((unsigned long)b->batch_page);
+	free_page(b->batch_page);
 	b->batch_page = NULL;
 	static_branch_disable(&vmw_balloon_batching);
 	b->batch_max_pages = 1;
diff --git a/drivers/mmc/host/renesas_sdhi_sys_dmac.c b/drivers/mmc/host/renesas_sdhi_sys_dmac.c
index 41d6a6370680..c41a144723cd 100644
--- a/drivers/mmc/host/renesas_sdhi_sys_dmac.c
+++ b/drivers/mmc/host/renesas_sdhi_sys_dmac.c
@@ -435,7 +435,7 @@ static void renesas_sdhi_sys_dmac_release_dma(struct tmio_mmc_host *host)
 		dma_release_channel(chan);
 	}
 	if (host->bounce_buf) {
-		free_pages((unsigned long)host->bounce_buf, 0);
+		free_pages(host->bounce_buf, 0);
 		host->bounce_buf = NULL;
 	}
 }
diff --git a/drivers/net/ethernet/amd/mvme147.c b/drivers/net/ethernet/amd/mvme147.c
index f19b04b92fa9..3b096998c1ae 100644
--- a/drivers/net/ethernet/amd/mvme147.c
+++ b/drivers/net/ethernet/amd/mvme147.c
@@ -129,7 +129,7 @@ static struct net_device * __init mvme147lance_probe(void)
 
 	err = register_netdev(dev);
 	if (err) {
-		free_pages(lp->ram, 3);
+		free_pages((void *)lp->ram, 3);
 		free_netdev(dev);
 		return ERR_PTR(err);
 	}
@@ -192,7 +192,7 @@ static void __exit m147lance_exit(void)
 {
 	struct m147lance_private *lp = netdev_priv(dev_mvme147_lance);
 	unregister_netdev(dev_mvme147_lance);
-	free_pages(lp->ram, 3);
+	free_pages((void *)lp->ram, 3);
 	free_netdev(dev_mvme147_lance);
 }
 module_exit(m147lance_exit);
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 46989cefb12c..b9334845754e 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -12530,7 +12530,7 @@ static void bnx2x_free_mcast_macs_list(struct list_head *mcast_group_list)
 				      struct bnx2x_mcast_list_elem_group,
 				      mcast_group_link);
 		list_del(&current_mcast_group->mcast_group_link);
-		free_page((unsigned long)current_mcast_group);
+		free_page(current_mcast_group);
 	}
 }
 
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
index 15a80d0e2af5..ae1cfac2eb25 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
@@ -2664,7 +2664,7 @@ static void bnx2x_free_groups(struct list_head *mcast_group_list)
 				      struct bnx2x_mcast_elem_group,
 				      mcast_group_link);
 		list_del(&current_mcast_group->mcast_group_link);
-		free_page((unsigned long)current_mcast_group);
+		free_page(current_mcast_group);
 	}
 }
 
diff --git a/drivers/net/ethernet/cirrus/cs89x0.c b/drivers/net/ethernet/cirrus/cs89x0.c
index fa5857923db4..c36b73961540 100644
--- a/drivers/net/ethernet/cirrus/cs89x0.c
+++ b/drivers/net/ethernet/cirrus/cs89x0.c
@@ -475,8 +475,7 @@ dma_rx(struct net_device *dev)
 static void release_dma_buff(struct net_local *lp)
 {
 	if (lp->dma_buff) {
-		free_pages((unsigned long)(lp->dma_buff),
-			   get_order(lp->dmasize * 1024));
+		free_pages(lp->dma_buff, get_order(lp->dmasize * 1024));
 		lp->dma_buff = NULL;
 	}
 }
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 3edc8d142dd5..4750b659f57c 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -1745,7 +1745,7 @@ static struct sk_buff *dpaa_cleanup_tx_fd(const struct dpaa_priv *priv,
 
 	if (qm_fd_get_format(fd) == qm_fd_sg)
 		/* Free the page that we allocated on Tx for the SGT */
-		free_pages((unsigned long)vaddr, 0);
+		free_pages(vaddr, 0);
 
 	return skb;
 }
@@ -1801,7 +1801,7 @@ static struct sk_buff *contig_fd_to_skb(const struct dpaa_priv *priv,
 	return skb;
 
 free_buffer:
-	free_pages((unsigned long)vaddr, 0);
+	free_pages(vaddr, 0);
 	return NULL;
 }
 
@@ -1908,7 +1908,7 @@ static struct sk_buff *sg_fd_to_skb(const struct dpaa_priv *priv,
 	WARN_ONCE(i == DPAA_SGT_MAX_ENTRIES, "No final bit on SGT\n");
 
 	/* free the SG table buffer */
-	free_pages((unsigned long)vaddr, 0);
+	free_pages(vaddr, 0);
 
 	return skb;
 
@@ -1921,7 +1921,7 @@ static struct sk_buff *sg_fd_to_skb(const struct dpaa_priv *priv,
 		if (j > i)
 			dma_unmap_page(priv->rx_dma_dev, qm_sg_addr(&sgt[j]),
 				       DPAA_BP_RAW_SIZE, DMA_FROM_DEVICE);
-		free_pages((unsigned long)sg_vaddr, 0);
+		free_pages(sg_vaddr, 0);
 		/* counters 0..i-1 were decremented */
 		if (j >= i) {
 			dpaa_bp = dpaa_bpid2pool(sgt[j].bpid);
@@ -1935,7 +1935,7 @@ static struct sk_buff *sg_fd_to_skb(const struct dpaa_priv *priv,
 			break;
 	}
 	/* free the SGT fragment */
-	free_pages((unsigned long)vaddr, 0);
+	free_pages(vaddr, 0);
 
 	return NULL;
 }
@@ -2096,7 +2096,7 @@ static int skb_to_sg_fd(struct dpaa_priv *priv,
 			       qm_sg_entry_get_len(&sgt[j]), dma_dir);
 sg0_map_failed:
 csum_failed:
-	free_pages((unsigned long)buff_start, 0);
+	free_pages(buff_start, 0);
 
 	return err;
 }
@@ -2643,7 +2643,7 @@ static u32 dpaa_run_xdp(struct dpaa_priv *priv, struct qm_fd *fd, void *vaddr,
 		xdp.frame_sz = DPAA_BP_RAW_SIZE;
 		xdpf = xdp_convert_buff_to_frame(&xdp);
 		if (unlikely(!xdpf)) {
-			free_pages((unsigned long)vaddr, 0);
+			free_pages(vaddr, 0);
 			break;
 		}
 
@@ -2659,7 +2659,7 @@ static u32 dpaa_run_xdp(struct dpaa_priv *priv, struct qm_fd *fd, void *vaddr,
 		err = xdp_do_redirect(priv->net_dev, &xdp, xdp_prog);
 		if (err) {
 			trace_xdp_exception(priv->net_dev, xdp_prog, xdp_act);
-			free_pages((unsigned long)vaddr, 0);
+			free_pages(vaddr, 0);
 		}
 		break;
 	default:
@@ -2670,7 +2670,7 @@ static u32 dpaa_run_xdp(struct dpaa_priv *priv, struct qm_fd *fd, void *vaddr,
 		fallthrough;
 	case XDP_DROP:
 		/* Free the buffer */
-		free_pages((unsigned long)vaddr, 0);
+		free_pages(vaddr, 0);
 		break;
 	}
 
@@ -2793,7 +2793,7 @@ static enum qman_cb_dqrr_result rx_default_dqrr(struct qman_portal *portal,
 			WARN_ONCE(1, "S/G frames not supported under XDP\n");
 			sgt = vaddr + qm_fd_get_offset(fd);
 			dpaa_release_sgt_members(sgt);
-			free_pages((unsigned long)vaddr, 0);
+			free_pages(vaddr, 0);
 			return qman_cb_dqrr_consume;
 		}
 		skb = sg_fd_to_skb(priv, fd);
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index c96d1d6ba8fe..e4748f5721e7 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -164,13 +164,13 @@ static void dpaa2_eth_free_rx_fd(struct dpaa2_eth_priv *priv,
 		dma_unmap_page(dev, addr, priv->rx_buf_size,
 			       DMA_BIDIRECTIONAL);
 
-		free_pages((unsigned long)sg_vaddr, 0);
+		free_pages(sg_vaddr, 0);
 		if (dpaa2_sg_is_final(&sgt[i]))
 			break;
 	}
 
 free_buf:
-	free_pages((unsigned long)vaddr, 0);
+	free_pages(vaddr, 0);
 }
 
 /* Build a linear skb based on a single-buffer frame descriptor */
@@ -231,7 +231,7 @@ static struct sk_buff *dpaa2_eth_build_frag_skb(struct dpaa2_eth_priv *priv,
 				/* Free the first SG entry now, since we already
 				 * unmapped it and obtained the virtual address
 				 */
-				free_pages((unsigned long)sg_vaddr, 0);
+				free_pages(sg_vaddr, 0);
 
 				/* We still need to subtract the buffers used
 				 * by this FD from our software counter
@@ -293,7 +293,7 @@ static void dpaa2_eth_free_bufs(struct dpaa2_eth_priv *priv, u64 *buf_array,
 		if (!xsk_zc) {
 			dma_unmap_page(dev, buf_array[i], priv->rx_buf_size,
 				       DMA_BIDIRECTIONAL);
-			free_pages((unsigned long)vaddr, 0);
+			free_pages(vaddr, 0);
 		} else {
 			swa = (struct dpaa2_eth_swa *)
 				(vaddr + DPAA2_ETH_RX_HWA_SIZE);
@@ -479,7 +479,7 @@ static u32 dpaa2_eth_run_xdp(struct dpaa2_eth_priv *priv,
 					    virt_to_page(vaddr), 0,
 					    priv->rx_buf_size, DMA_BIDIRECTIONAL);
 			if (unlikely(dma_mapping_error(priv->net_dev->dev.parent, addr))) {
-				free_pages((unsigned long)vaddr, 0);
+				free_pages(vaddr, 0);
 			} else {
 				ch->buf_count++;
 				dpaa2_eth_recycle_buf(priv, ch, addr);
@@ -626,7 +626,7 @@ void dpaa2_eth_rx(struct dpaa2_eth_priv *priv,
 		dma_unmap_page(dev, addr, priv->rx_buf_size,
 			       DMA_BIDIRECTIONAL);
 		skb = dpaa2_eth_build_frag_skb(priv, ch, buf_data);
-		free_pages((unsigned long)vaddr, 0);
+		free_pages(vaddr, 0);
 		percpu_extras->rx_sg_frames++;
 		percpu_extras->rx_sg_bytes += dpaa2_fd_get_len(fd);
 	} else {
@@ -681,7 +681,7 @@ static void dpaa2_eth_rx_err(struct dpaa2_eth_priv *priv,
 		dma_unmap_page(dev, addr, priv->rx_buf_size,
 			       DMA_BIDIRECTIONAL);
 		skb = dpaa2_eth_build_frag_skb(priv, ch, buf_data);
-		free_pages((unsigned long)vaddr, 0);
+		free_pages(vaddr, 0);
 	} else {
 		/* We don't support any other format */
 		dpaa2_eth_free_rx_fd(priv, fd, vaddr);
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index b1e1ad9e4b48..a9733d630dc0 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -2552,7 +2552,7 @@ static void dpaa2_switch_free_bufs(struct ethsw_core *ethsw, u64 *buf_array, int
 		vaddr = dpaa2_iova_to_virt(ethsw->iommu_domain, buf_array[i]);
 		dma_unmap_page(dev, buf_array[i], DPAA2_SWITCH_RX_BUF_SIZE,
 			       DMA_FROM_DEVICE);
-		free_pages((unsigned long)vaddr, 0);
+		free_pages(vaddr, 0);
 	}
 }
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index bfa5568baa92..74b8577c0f8d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -5049,8 +5049,7 @@ void hns3_fini_ring(struct hns3_enet_ring *ring)
 
 		dma_unmap_page(ring_to_dev(ring), tx_spare->dma, tx_spare->len,
 			       DMA_TO_DEVICE);
-		free_pages((unsigned long)tx_spare->buf,
-			   get_order(tx_spare->len));
+		free_pages(tx_spare->buf, get_order(tx_spare->len));
 		devm_kfree(ring_to_dev(ring), tx_spare);
 		ring->tx_spare = NULL;
 	}
diff --git a/drivers/net/ethernet/i825xx/82596.c b/drivers/net/ethernet/i825xx/82596.c
index 773d7aa29ef5..e5f2630d5333 100644
--- a/drivers/net/ethernet/i825xx/82596.c
+++ b/drivers/net/ethernet/i825xx/82596.c
@@ -1219,7 +1219,7 @@ static struct net_device * __init i82596_probe(void)
 	kernel_set_cachemode((void *)(dev->mem_start), 4096,
 			IOMAP_FULL_CACHING);
 #endif
-	free_page ((u32)(dev->mem_start));
+	free_page((void *)dev->mem_start);
 out1:
 out:
 	free_netdev(dev);
@@ -1530,7 +1530,7 @@ static void __exit i82596_cleanup(void)
 	kernel_set_cachemode((void *)(dev_82596->mem_start), 4096,
 			IOMAP_FULL_CACHING);
 #endif
-	free_page ((u32)(dev_82596->mem_start));
+	free_page((void *)dev_82596->mem_start);
 	free_netdev(dev_82596);
 }
 module_exit(i82596_cleanup);
diff --git a/drivers/net/ethernet/ibm/ehea/ehea_main.c b/drivers/net/ethernet/ibm/ehea/ehea_main.c
index 6017d34e7026..a848bbee7597 100644
--- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
@@ -374,7 +374,7 @@ static void ehea_update_stats(struct work_struct *work)
 	stats->rx_errors = cb2->rxuerr;
 
 out_herr:
-	free_page((unsigned long)cb2);
+	free_page(cb2);
 resched:
 	schedule_delayed_work(&port->stats_work,
 			      round_jiffies_relative(msecs_to_jiffies(1000)));
@@ -1051,7 +1051,7 @@ int ehea_sense_port_attr(struct ehea_port *port)
 out_free:
 	if (ret || netif_msg_probe(port))
 		ehea_dump(cb0, sizeof(*cb0), "ehea_sense_port_attr");
-	free_page((unsigned long)cb0);
+	free_page(cb0);
 out:
 	return ret;
 }
@@ -1130,7 +1130,7 @@ int ehea_set_portspeed(struct ehea_port *port, u32 port_speed)
 	if (!prop_carrier_state || (port->phy_link == EHEA_PHY_LINK_UP))
 		netif_carrier_on(port->netdev);
 
-	free_page((unsigned long)cb4);
+	free_page(cb4);
 out:
 	return ret;
 }
@@ -1386,7 +1386,7 @@ static int ehea_configure_port(struct ehea_port *port)
 	ret = 0;
 
 out_free:
-	free_page((unsigned long)cb0);
+	free_page(cb0);
 out:
 	return ret;
 }
@@ -1767,7 +1767,7 @@ static int ehea_set_mac_addr(struct net_device *dev, void *sa)
 out_upregs:
 	ehea_update_bcmc_registrations();
 out_free:
-	free_page((unsigned long)cb0);
+	free_page(cb0);
 out:
 	return ret;
 }
@@ -1810,7 +1810,7 @@ static void ehea_promiscuous(struct net_device *dev, int enable)
 
 	port->promisc = enable;
 out:
-	free_page((unsigned long)cb7);
+	free_page(cb7);
 }
 
 static u64 ehea_multicast_reg_helper(struct ehea_port *port, u64 mc_mac_addr,
@@ -2120,7 +2120,7 @@ static int ehea_vlan_rx_add_vid(struct net_device *dev, __be16 proto, u16 vid)
 		err = -EINVAL;
 	}
 out:
-	free_page((unsigned long)cb1);
+	free_page(cb1);
 	return err;
 }
 
@@ -2158,7 +2158,7 @@ static int ehea_vlan_rx_kill_vid(struct net_device *dev, __be16 proto, u16 vid)
 		err = -EINVAL;
 	}
 out:
-	free_page((unsigned long)cb1);
+	free_page(cb1);
 	return err;
 }
 
@@ -2233,7 +2233,7 @@ static int ehea_activate_qp(struct ehea_adapter *adapter, struct ehea_qp *qp)
 
 	ret = 0;
 out:
-	free_page((unsigned long)cb0);
+	free_page(cb0);
 	return ret;
 }
 
@@ -2570,7 +2570,7 @@ static int ehea_stop_qps(struct net_device *dev)
 
 	ret = 0;
 out:
-	free_page((unsigned long)cb0);
+	free_page(cb0);
 
 	return ret;
 }
@@ -2674,7 +2674,7 @@ static int ehea_restart_qps(struct net_device *dev)
 		ehea_refill_rq3(pr, 0);
 	}
 out:
-	free_page((unsigned long)cb0);
+	free_page(cb0);
 
 	return ret;
 }
@@ -2823,7 +2823,7 @@ static int ehea_sense_adapter_attr(struct ehea_adapter *adapter)
 	ret = 0;
 
 out_herr:
-	free_page((unsigned long)cb);
+	free_page(cb);
 out:
 	return ret;
 }
@@ -2865,7 +2865,7 @@ static int ehea_get_jumboframe_status(struct ehea_port *port, int *jumbo)
 		} else
 			ret = -EINVAL;
 
-		free_page((unsigned long)cb4);
+		free_page(cb4);
 	}
 out:
 	return ret;
diff --git a/drivers/net/ethernet/ibm/ehea/ehea_qmr.c b/drivers/net/ethernet/ibm/ehea/ehea_qmr.c
index a42969b71098..915facd773ff 100644
--- a/drivers/net/ethernet/ibm/ehea/ehea_qmr.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_qmr.c
@@ -82,7 +82,7 @@ static int hw_queue_ctor(struct hw_queue *queue, const u32 nr_of_pages,
 	for (i = 0; i < nr_of_pages; i += pages_per_kpage) {
 		if (!(queue->queue_pages)[i])
 			break;
-		free_page((unsigned long)(queue->queue_pages)[i]);
+		free_page((queue->queue_pages)[i]);
 	}
 	return -ENOMEM;
 }
@@ -100,7 +100,7 @@ static void hw_queue_dtor(struct hw_queue *queue)
 	nr_pages = queue->queue_length / queue->pagesize;
 
 	for (i = 0; i < nr_pages; i += pages_per_kpage)
-		free_page((unsigned long)(queue->queue_pages)[i]);
+		free_page((queue->queue_pages)[i]);
 
 	kfree(queue->queue_pages);
 }
@@ -907,7 +907,7 @@ int ehea_reg_kernel_mr(struct ehea_adapter *adapter, struct ehea_mr *mr)
 	mr->adapter = adapter;
 	ret = 0;
 out:
-	free_page((unsigned long)pt);
+	free_page(pt);
 	return ret;
 }
 
@@ -993,7 +993,7 @@ u64 ehea_error_data(struct ehea_adapter *adapter, u64 res_handle,
 	} else
 		pr_err("Error data could not be fetched: %llX\n", res_handle);
 
-	free_page((unsigned long)rblock);
+	free_page(rblock);
 out:
 	return type;
 }
diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 4e308daa7d80..8fa839b7b8cc 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -759,9 +759,9 @@ static int ibmveth_open(struct net_device *netdev)
 			  adapter->rx_queue.queue_addr,
 			  adapter->rx_queue.queue_dma);
 out_free_filter_list:
-	free_page((unsigned long)adapter->filter_list_addr);
+	free_page(adapter->filter_list_addr);
 out_free_buffer_list:
-	free_page((unsigned long)adapter->buffer_list_addr);
+	free_page(adapter->buffer_list_addr);
 out:
 	napi_disable(&adapter->napi);
 	return rc;
@@ -797,11 +797,11 @@ static int ibmveth_close(struct net_device *netdev)
 
 	dma_unmap_single(dev, adapter->buffer_list_dma, 4096,
 			 DMA_BIDIRECTIONAL);
-	free_page((unsigned long)adapter->buffer_list_addr);
+	free_page(adapter->buffer_list_addr);
 
 	dma_unmap_single(dev, adapter->filter_list_dma, 4096,
 			 DMA_BIDIRECTIONAL);
-	free_page((unsigned long)adapter->filter_list_addr);
+	free_page(adapter->filter_list_addr);
 
 	dma_free_coherent(dev, adapter->rx_queue.queue_len,
 			  adapter->rx_queue.queue_addr,
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 13447530abe1..7d5e6a0ac569 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4043,7 +4043,7 @@ static void release_sub_crq_queue(struct ibmvnic_adapter *adapter,
 
 	dma_unmap_single(dev, scrq->msg_token, 4 * PAGE_SIZE,
 			 DMA_BIDIRECTIONAL);
-	free_pages((unsigned long)scrq->msgs, 2);
+	free_pages(scrq->msgs, 2);
 	free_cpumask_var(scrq->affinity_mask);
 	kfree(scrq);
 }
@@ -4121,7 +4121,7 @@ static struct ibmvnic_sub_crq_queue *init_sub_crq_queue(struct ibmvnic_adapter
 map_failed:
 	free_cpumask_var(scrq->affinity_mask);
 cpumask_alloc_failed:
-	free_pages((unsigned long)scrq->msgs, 2);
+	free_pages(scrq->msgs, 2);
 zero_page_failed:
 	kfree(scrq);
 
@@ -6263,7 +6263,7 @@ static void release_crq_queue(struct ibmvnic_adapter *adapter)
 
 	dma_unmap_single(&vdev->dev, crq->msg_token, PAGE_SIZE,
 			 DMA_BIDIRECTIONAL);
-	free_page((unsigned long)crq->msgs);
+	free_page(crq->msgs);
 	crq->msgs = NULL;
 	crq->active = false;
 }
@@ -6341,7 +6341,7 @@ static int init_crq_queue(struct ibmvnic_adapter *adapter)
 reg_crq_failed:
 	dma_unmap_single(dev, crq->msg_token, PAGE_SIZE, DMA_BIDIRECTIONAL);
 map_failed:
-	free_page((unsigned long)crq->msgs);
+	free_page(crq->msgs);
 	crq->msgs = NULL;
 	return retrc;
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_gnss.c b/drivers/net/ethernet/intel/ice/ice_gnss.c
index f7184bf93a22..4005bc46c0b8 100644
--- a/drivers/net/ethernet/intel/ice/ice_gnss.c
+++ b/drivers/net/ethernet/intel/ice/ice_gnss.c
@@ -151,7 +151,7 @@ static void ice_gnss_read(struct kthread_work *work)
 			 count, i);
 	delay = ICE_GNSS_TIMER_DELAY_TIME;
 free_buf:
-	free_page((unsigned long)buf);
+	free_page(buf);
 requeue:
 	kthread_queue_delayed_work(gnss->kworker, &gnss->read_work, delay);
 	if (err)
diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
index c228b275d811..a1b1e7f5c8f4 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -581,7 +581,7 @@ mtk_wed_amsdu_free_buffer(struct mtk_wed_device *dev)
 	for (i = 0; i < MTK_WED_AMSDU_NPAGES; i++) {
 		dma_unmap_single(dev->hw->dev, wed_amsdu[i].txd_phy,
 				 MTK_WED_AMSDU_BUF_SIZE, DMA_TO_DEVICE);
-		free_pages((unsigned long)wed_amsdu[i].txd,
+		free_pages(wed_amsdu[i].txd,
 			   get_order(MTK_WED_AMSDU_BUF_SIZE));
 	}
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index c21f8b76586b..41fcf9b99fcf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -156,7 +156,7 @@ static int mlx5_fw_tracer_create_log_buf(struct mlx5_fw_tracer *tracer)
 	return 0;
 
 free_pages:
-	free_pages((unsigned long)tracer->buff.log_buf, get_order(tracer->buff.size));
+	free_pages(tracer->buff.log_buf, get_order(tracer->buff.size));
 
 	return err;
 }
@@ -171,7 +171,7 @@ static void mlx5_fw_tracer_destroy_log_buf(struct mlx5_fw_tracer *tracer)
 
 	ddev = mlx5_core_dma_dev(dev);
 	dma_unmap_single(ddev, tracer->buff.dma, tracer->buff.size, DMA_FROM_DEVICE);
-	free_pages((unsigned long)tracer->buff.log_buf, get_order(tracer->buff.size));
+	free_pages(tracer->buff.log_buf, get_order(tracer->buff.size));
 }
 
 static int mlx5_fw_tracer_create_mkey(struct mlx5_fw_tracer *tracer)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index d49e0dd724d1..f2f22791160b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -1385,7 +1385,7 @@ static void mlx5_destroy_clock_dev(struct mlx5_core_dev *mdev)
 	}
 
 	if (mdev->clock_info) {
-		free_page((unsigned long)mdev->clock_info);
+		free_page(mdev->clock_info);
 		mdev->clock_info = NULL;
 	}
 
diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_fw.c b/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
index 51f73a384777..7e9cb744c055 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
@@ -163,7 +163,7 @@ static void fbnic_mbx_unmap_and_free_msg(struct fbnic_dev *fbd, int mbx_idx,
 	dma_unmap_single(fbd->dev, mbx->buf_info[desc_idx].addr,
 			 PAGE_SIZE, direction);
 
-	free_page((unsigned long)mbx->buf_info[desc_idx].msg);
+	free_page(mbx->buf_info[desc_idx].msg);
 	mbx->buf_info[desc_idx].msg = NULL;
 }
 
@@ -215,7 +215,7 @@ static int fbnic_mbx_alloc_rx_msgs(struct fbnic_dev *fbd)
 		err = fbnic_mbx_map_msg(fbd, FBNIC_IPC_MBX_RX_IDX, msg,
 					FBNIC_RX_PAGE_SIZE, 0);
 		if (err)
-			free_page((unsigned long)msg);
+			free_page(msg);
 	}
 
 	return err;
@@ -411,7 +411,7 @@ static int fbnic_fw_xmit_simple_msg(struct fbnic_dev *fbd, u32 msg_type)
 
 	err = fbnic_mbx_map_tlv_msg(fbd, msg);
 	if (err)
-		free_page((unsigned long)msg);
+		free_page(msg);
 
 	return err;
 }
@@ -506,7 +506,7 @@ int fbnic_fw_xmit_ownership_msg(struct fbnic_dev *fbd, bool take_ownership)
 	return err;
 
 free_message:
-	free_page((unsigned long)msg);
+	free_page(msg);
 	return err;
 }
 
@@ -724,7 +724,7 @@ static int fbnic_fw_xmit_heartbeat_message(struct fbnic_dev *fbd)
 	return err;
 
 free_message:
-	free_page((unsigned long)msg);
+	free_page(msg);
 	return err;
 }
 
@@ -828,7 +828,7 @@ int fbnic_fw_xmit_coredump_info_msg(struct fbnic_dev *fbd,
 	return 0;
 
 free_msg:
-	free_page((unsigned long)msg);
+	free_page(msg);
 	return err;
 }
 
@@ -917,7 +917,7 @@ int fbnic_fw_xmit_coredump_read_msg(struct fbnic_dev *fbd,
 	return 0;
 
 free_message:
-	free_page((unsigned long)msg);
+	free_page(msg);
 	return err;
 }
 
@@ -1035,7 +1035,7 @@ int fbnic_fw_xmit_fw_start_upgrade(struct fbnic_dev *fbd,
 	return 0;
 
 free_message:
-	free_page((unsigned long)msg);
+	free_page(msg);
 	return err;
 }
 
@@ -1111,7 +1111,7 @@ int fbnic_fw_xmit_fw_write_chunk(struct fbnic_dev *fbd,
 	return 0;
 
 free_message:
-	free_page((unsigned long)msg);
+	free_page(msg);
 	return err;
 }
 
@@ -1236,7 +1236,7 @@ int fbnic_fw_xmit_qsfp_read_msg(struct fbnic_dev *fbd,
 	return 0;
 
 free_message:
-	free_page((unsigned long)msg);
+	free_page(msg);
 	return err;
 }
 
@@ -1346,7 +1346,7 @@ int fbnic_fw_xmit_tsene_read_msg(struct fbnic_dev *fbd,
 	return 0;
 
 free_message:
-	free_page((unsigned long)msg);
+	free_page(msg);
 	return err;
 }
 
@@ -1552,7 +1552,7 @@ int fbnic_fw_xmit_send_logs(struct fbnic_dev *fbd, bool enable,
 	return 0;
 
 free_message:
-	free_page((unsigned long)msg);
+	free_page(msg);
 	return err;
 }
 
@@ -1638,7 +1638,7 @@ static void fbnic_mbx_process_rx_msgs(struct fbnic_dev *fbd)
 		dev_dbg(fbd->dev, "Parsed msg type %d\n", msg->hdr.type);
 next_page:
 
-		free_page((unsigned long)rx_mbx->buf_info[head].msg);
+		free_page(rx_mbx->buf_info[head].msg);
 		rx_mbx->buf_info[head].msg = NULL;
 
 		head++;
@@ -1876,7 +1876,7 @@ int fbnic_fw_xmit_rpc_macda_sync(struct fbnic_dev *fbd)
 free_message_nospc:
 	err = -ENOSPC;
 free_message:
-	free_page((unsigned long)msg);
+	free_page(msg);
 	return err;
 }
 
diff --git a/drivers/net/ethernet/sfc/mcdi.c b/drivers/net/ethernet/sfc/mcdi.c
index 37da9fd51e9b..dfabf681e8ae 100644
--- a/drivers/net/ethernet/sfc/mcdi.c
+++ b/drivers/net/ethernet/sfc/mcdi.c
@@ -112,7 +112,7 @@ int efx_mcdi_init(struct efx_nic *efx)
 	return 0;
 fail2:
 #ifdef CONFIG_SFC_MCDI_LOGGING
-	free_page((unsigned long)mcdi->logging_buffer);
+	free_page(mcdi->logging_buffer);
 fail1:
 #endif
 	kfree(efx->mcdi);
@@ -138,7 +138,7 @@ void efx_mcdi_fini(struct efx_nic *efx)
 		return;
 
 #ifdef CONFIG_SFC_MCDI_LOGGING
-	free_page((unsigned long)efx->mcdi->iface.logging_buffer);
+	free_page(efx->mcdi->iface.logging_buffer);
 #endif
 
 	kfree(efx->mcdi);
diff --git a/drivers/net/ethernet/sfc/siena/mcdi.c b/drivers/net/ethernet/sfc/siena/mcdi.c
index 520d9d759d29..368664068704 100644
--- a/drivers/net/ethernet/sfc/siena/mcdi.c
+++ b/drivers/net/ethernet/sfc/siena/mcdi.c
@@ -116,7 +116,7 @@ int efx_siena_mcdi_init(struct efx_nic *efx)
 	return 0;
 fail2:
 #ifdef CONFIG_SFC_SIENA_MCDI_LOGGING
-	free_page((unsigned long)mcdi->logging_buffer);
+	free_page(mcdi->logging_buffer);
 fail1:
 #endif
 	kfree(efx->mcdi);
@@ -142,7 +142,7 @@ void efx_siena_mcdi_fini(struct efx_nic *efx)
 		return;
 
 #ifdef CONFIG_SFC_SIENA_MCDI_LOGGING
-	free_page((unsigned long)efx->mcdi->iface.logging_buffer);
+	free_page(efx->mcdi->iface.logging_buffer);
 #endif
 
 	kfree(efx->mcdi);
diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index e128ff1d41bd..30d5138b7d83 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -10013,7 +10013,7 @@ static void niu_phys_free_coherent(struct device *dev, size_t size,
 {
 	unsigned long order = get_order(size);
 
-	free_pages((unsigned long) cpu_addr, order);
+	free_pages(cpu_addr, order);
 }
 
 static u64 niu_phys_map_page(struct device *dev, struct page *page,
diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_wireless.c b/drivers/net/ethernet/toshiba/ps3_gelic_wireless.c
index 0ebdf6d90786..10259fcee842 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_wireless.c
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_wireless.c
@@ -1415,7 +1415,7 @@ static struct iw_statistics *gelic_wl_get_wireless_stats(
 		is->qual.updated = IW_QUAL_ALL_INVALID;
 
 	kfree(cmd);
-	free_page((unsigned long)buf);
+	free_page(buf);
 	pr_debug("%s: ->\n", __func__);
 	return is;
 }
@@ -1483,7 +1483,7 @@ static int gelic_wl_start_scan(struct gelic_wl_info *wl, int always_scan,
 	}
 	kfree(cmd);
 out:
-	free_page((unsigned long)buf);
+	free_page(buf);
 	mutex_unlock(&wl->scan_lock);
 	pr_debug("%s: ->\n", __func__);
 	return ret;
@@ -1627,7 +1627,7 @@ static void gelic_wl_scan_complete_event(struct gelic_wl_info *wl)
 	wireless_send_event(port_to_netdev(wl_port(wl)), SIOCGIWSCAN, &data,
 			    NULL);
 out:
-	free_page((unsigned long)buf);
+	free_page(buf);
 	complete(&wl->scan_done);
 	mutex_unlock(&wl->scan_lock);
 	pr_debug("%s:end\n", __func__);
@@ -1802,7 +1802,7 @@ static int gelic_wl_do_wep_setup(struct gelic_wl_info *wl)
 
 	kfree(cmd);
 out:
-	free_page((unsigned long)wep);
+	free_page(wep);
 	pr_debug("%s: ->\n", __func__);
 	return ret;
 }
@@ -1901,7 +1901,7 @@ static int gelic_wl_do_wpa_setup(struct gelic_wl_info *wl)
 	else if (cmd->status || cmd->cmd_status)
 		ret = -ENXIO;
 	kfree(cmd);
-	free_page((unsigned long)wpa);
+	free_page(wpa);
 	pr_debug("%s: --> %d\n", __func__, ret);
 	return ret;
 }
@@ -2012,7 +2012,7 @@ static int gelic_wl_associate_bss(struct gelic_wl_info *wl,
 		pr_info("%s: connected\n", __func__);
 	}
 out:
-	free_page((unsigned long)common);
+	free_page(common);
 	pr_debug("%s: ->\n", __func__);
 	return ret;
 }
diff --git a/drivers/net/rionet.c b/drivers/net/rionet.c
index 526999cdbdd7..0520e6ecd36b 100644
--- a/drivers/net/rionet.c
+++ b/drivers/net/rionet.c
@@ -526,7 +526,7 @@ static int rionet_setup_netdev(struct rio_mport *mport, struct net_device *ndev)
 
 	rc = register_netdev(ndev);
 	if (rc != 0) {
-		free_pages((unsigned long)nets[mport->id].active,
+		free_pages(nets[mport->id].active,
 			   get_order(rionet_active_bytes));
 		goto out;
 	}
@@ -680,9 +680,8 @@ static void rionet_remove_mport(struct device *dev)
 		netif_stop_queue(ndev);
 		unregister_netdev(ndev);
 
-		free_pages((unsigned long)nets[id].active,
-			   get_order(sizeof(void *) *
-			   RIO_MAX_ROUTE_ENTRIES(mport->sys_size)));
+		free_pages(nets[id].active,
+			   get_order(sizeof(void *) * RIO_MAX_ROUTE_ENTRIES(mport->sys_size)));
 		nets[id].active = NULL;
 		free_netdev(ndev);
 		nets[id].ndev = NULL;
diff --git a/drivers/net/usb/kaweth.c b/drivers/net/usb/kaweth.c
index 1830b7b48e57..06078ef7f596 100644
--- a/drivers/net/usb/kaweth.c
+++ b/drivers/net/usb/kaweth.c
@@ -974,7 +974,7 @@ static int kaweth_probe(
 		/* Device will now disappear for a moment...  */
 		dev_info(dev, "Firmware loaded.  I'll be back...\n");
 err_fw:
-		free_page((unsigned long)kaweth->firmware_buf);
+		free_page(kaweth->firmware_buf);
 		free_netdev(netdev);
 		return -EIO;
 	}
diff --git a/drivers/net/wireless/broadcom/b43/debugfs.c b/drivers/net/wireless/broadcom/b43/debugfs.c
index aa02860e2169..e7eafaf1c39d 100644
--- a/drivers/net/wireless/broadcom/b43/debugfs.c
+++ b/drivers/net/wireless/broadcom/b43/debugfs.c
@@ -526,7 +526,7 @@ static ssize_t b43_debugfs_read(struct file *file, char __user *userbuf,
 		memset(buf, 0, bufsize);
 		ret = dfops->read(dev, buf, bufsize);
 		if (ret <= 0) {
-			free_pages((unsigned long)buf, buforder);
+			free_pages(buf, buforder);
 			err = ret;
 			goto out_unlock;
 		}
@@ -538,7 +538,7 @@ static ssize_t b43_debugfs_read(struct file *file, char __user *userbuf,
 				      dfile->buffer,
 				      dfile->data_len);
 	if (*ppos >= dfile->data_len) {
-		free_pages((unsigned long)dfile->buffer, buforder);
+		free_pages(dfile->buffer, buforder);
 		dfile->buffer = NULL;
 		dfile->data_len = 0;
 	}
@@ -591,7 +591,7 @@ static ssize_t b43_debugfs_write(struct file *file,
 		goto out_freepage;
 
 out_freepage:
-	free_page((unsigned long)buf);
+	free_page(buf);
 out_unlock:
 	mutex_unlock(&dev->wl->mutex);
 
diff --git a/drivers/net/wireless/broadcom/b43legacy/debugfs.c b/drivers/net/wireless/broadcom/b43legacy/debugfs.c
index c540c798bc53..9193fbd2cdeb 100644
--- a/drivers/net/wireless/broadcom/b43legacy/debugfs.c
+++ b/drivers/net/wireless/broadcom/b43legacy/debugfs.c
@@ -228,7 +228,7 @@ static ssize_t b43legacy_debugfs_read(struct file *file, char __user *userbuf,
 		} else
 			ret = dfops->read(dev, buf, bufsize);
 		if (ret <= 0) {
-			free_pages((unsigned long)buf, buforder);
+			free_pages(buf, buforder);
 			err = ret;
 			goto out_unlock;
 		}
@@ -240,7 +240,7 @@ static ssize_t b43legacy_debugfs_read(struct file *file, char __user *userbuf,
 				      dfile->buffer,
 				      dfile->data_len);
 	if (*ppos >= dfile->data_len) {
-		free_pages((unsigned long)dfile->buffer, buforder);
+		free_pages(dfile->buffer, buforder);
 		dfile->buffer = NULL;
 		dfile->data_len = 0;
 	}
@@ -298,7 +298,7 @@ static ssize_t b43legacy_debugfs_write(struct file *file,
 		goto out_freepage;
 
 out_freepage:
-	free_page((unsigned long)buf);
+	free_page(buf);
 out_unlock:
 	mutex_unlock(&dev->wl->mutex);
 
diff --git a/drivers/net/wireless/intel/iwlegacy/common.h b/drivers/net/wireless/intel/iwlegacy/common.h
index 4c9836ab11dd..46d57434821d 100644
--- a/drivers/net/wireless/intel/iwlegacy/common.h
+++ b/drivers/net/wireless/intel/iwlegacy/common.h
@@ -1499,7 +1499,7 @@ __il_free_pages(struct il_priv *il, struct page *page)
 static inline void
 il_free_pages(struct il_priv *il, unsigned long page)
 {
-	free_pages(page, il->hw_params.rx_page_order);
+	free_pages((void *)page, il->hw_params.rx_page_order);
 	il->alloc_rxb_page--;
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index a0cc5d7745e8..4232fb5ee4e6 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -224,7 +224,7 @@ struct iwl_host_cmd {
 
 static inline void iwl_free_resp(struct iwl_host_cmd *cmd)
 {
-	free_pages(cmd->_rx_page_addr, cmd->_rx_page_order);
+	free_pages((void *)cmd->_rx_page_addr, cmd->_rx_page_order);
 }
 
 struct iwl_rx_cmd_buffer {
diff --git a/drivers/net/wireless/marvell/libertas/debugfs.c b/drivers/net/wireless/marvell/libertas/debugfs.c
index 310ccf2b2720..ab94967ecac3 100644
--- a/drivers/net/wireless/marvell/libertas/debugfs.c
+++ b/drivers/net/wireless/marvell/libertas/debugfs.c
@@ -48,7 +48,7 @@ static ssize_t lbs_dev_info(struct file *file, char __user *userbuf,
 
 	res = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
 
-	free_page(addr);
+	free_page((void *)addr);
 	return res;
 }
 
@@ -113,7 +113,7 @@ static ssize_t lbs_sleepparams_read(struct file *file, char __user *userbuf,
 	ret = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
 
 out_unlock:
-	free_page(addr);
+	free_page((void *)addr);
 	return ret;
 }
 
@@ -174,7 +174,7 @@ static ssize_t lbs_host_sleep_read(struct file *file, char __user *userbuf,
 
 	ret = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
 
-	free_page(addr);
+	free_page((void *)addr);
 	return ret;
 }
 
@@ -261,7 +261,7 @@ static ssize_t lbs_threshold_read(uint16_t tlv_type, uint16_t event_mask,
 	kfree(subscribed);
 
  out_page:
-	free_page((unsigned long)buf);
+	free_page(buf);
 	return ret;
 }
 
@@ -450,7 +450,7 @@ static ssize_t lbs_rdmac_read(struct file *file, char __user *userbuf,
 				priv->mac_offset, val);
 		ret = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
 	}
-	free_page(addr);
+	free_page((void *)addr);
 	return ret;
 }
 
@@ -520,7 +520,7 @@ static ssize_t lbs_rdbbp_read(struct file *file, char __user *userbuf,
 				priv->bbp_offset, val);
 		ret = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
 	}
-	free_page(addr);
+	free_page((void *)addr);
 
 	return ret;
 }
@@ -592,7 +592,7 @@ static ssize_t lbs_rdrf_read(struct file *file, char __user *userbuf,
 				priv->rf_offset, val);
 		ret = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
 	}
-	free_page(addr);
+	free_page((void *)addr);
 
 	return ret;
 }
@@ -836,7 +836,7 @@ static ssize_t lbs_debugfs_read(struct file *file, char __user *userbuf,
 
 	res = simple_read_from_buffer(userbuf, count, ppos, p, pos);
 
-	free_page(addr);
+	free_page((void *)addr);
 	return res;
 }
 
diff --git a/drivers/net/wireless/marvell/mwifiex/debugfs.c b/drivers/net/wireless/marvell/mwifiex/debugfs.c
index 1d00259c430f..bb47322237be 100644
--- a/drivers/net/wireless/marvell/mwifiex/debugfs.c
+++ b/drivers/net/wireless/marvell/mwifiex/debugfs.c
@@ -137,7 +137,7 @@ mwifiex_info_read(struct file *file, char __user *ubuf,
 				      (unsigned long) p - page);
 
 free_and_exit:
-	free_page(page);
+	free_page((void *)page);
 	return ret;
 }
 
@@ -224,7 +224,7 @@ mwifiex_getlog_read(struct file *file, char __user *ubuf,
 				      (unsigned long) p - page);
 
 free_and_exit:
-	free_page(page);
+	free_page((void *)page);
 	return ret;
 }
 
@@ -313,7 +313,7 @@ mwifiex_histogram_read(struct file *file, char __user *ubuf,
 				      (unsigned long)p - page);
 
 free_and_exit:
-	free_page(page);
+	free_page((void *)page);
 	return ret;
 }
 
@@ -400,7 +400,7 @@ mwifiex_debug_read(struct file *file, char __user *ubuf,
 				      (unsigned long) p - page);
 
 free_and_exit:
-	free_page(page);
+	free_page((void *)page);
 	return ret;
 }
 
@@ -497,7 +497,7 @@ mwifiex_regrdwr_read(struct file *file, char __user *ubuf,
 	ret = simple_read_from_buffer(ubuf, count, ppos, buf, pos);
 
 done:
-	free_page(addr);
+	free_page((void *)addr);
 	return ret;
 }
 
@@ -523,7 +523,7 @@ mwifiex_debug_mask_read(struct file *file, char __user *ubuf,
 			priv->adapter->debug_mask);
 	ret = simple_read_from_buffer(ubuf, count, ppos, buf, pos);
 
-	free_page(page);
+	free_page((void *)page);
 	return ret;
 }
 
@@ -663,7 +663,7 @@ mwifiex_memrw_read(struct file *file, char __user *ubuf,
 			priv->mem_rw.value);
 	ret = simple_read_from_buffer(ubuf, count, ppos, buf, pos);
 
-	free_page(addr);
+	free_page((void *)addr);
 	return ret;
 }
 
@@ -749,7 +749,7 @@ mwifiex_rdeeprom_read(struct file *file, char __user *ubuf,
 done:
 	ret = simple_read_from_buffer(ubuf, count, ppos, buf, pos);
 out_free:
-	free_page(addr);
+	free_page((void *)addr);
 	return ret;
 }
 
@@ -836,7 +836,7 @@ mwifiex_hscfg_read(struct file *file, char __user *ubuf,
 
 	ret = simple_read_from_buffer(ubuf, count, ppos, buf, pos);
 
-	free_page(addr);
+	free_page((void *)addr);
 	return ret;
 }
 
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index dfe2643da625..cd4ef029d31d 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -6498,13 +6498,13 @@ struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size, u32 aggr_buf_size,
 	kfree(wl->mbox);
 
 err_fwlog:
-	free_page((unsigned long)wl->fwlog);
+	free_page(wl->fwlog);
 
 err_dummy_packet:
 	dev_kfree_skb(wl->dummy_packet);
 
 err_aggr:
-	free_pages((unsigned long)wl->aggr_buf, order);
+	free_pages(wl->aggr_buf, order);
 
 err_wq:
 	destroy_workqueue(wl->freezable_wq);
@@ -6533,9 +6533,9 @@ int wlcore_free_hw(struct wl1271 *wl)
 
 	kfree(wl->buffer_32);
 	kfree(wl->mbox);
-	free_page((unsigned long)wl->fwlog);
+	free_page(wl->fwlog);
 	dev_kfree_skb(wl->dummy_packet);
-	free_pages((unsigned long)wl->aggr_buf, get_order(wl->aggr_buf_size));
+	free_pages(wl->aggr_buf, get_order(wl->aggr_buf_size));
 
 	wl1271_debugfs_exit(wl);
 
diff --git a/drivers/parisc/ccio-dma.c b/drivers/parisc/ccio-dma.c
index e39f0054b67c..e78524b59634 100644
--- a/drivers/parisc/ccio-dma.c
+++ b/drivers/parisc/ccio-dma.c
@@ -874,7 +874,7 @@ ccio_free(struct device *dev, size_t size, void *cpu_addr,
 		dma_addr_t dma_handle, unsigned long attrs)
 {
 	ccio_unmap_page(dev, dma_handle, size, 0, 0);
-	free_pages((unsigned long)cpu_addr, get_order(size));
+	free_pages(cpu_addr, get_order(size));
 }
 
 /*
diff --git a/drivers/parisc/sba_iommu.c b/drivers/parisc/sba_iommu.c
index 78b924e82906..0aa69f921c0f 100644
--- a/drivers/parisc/sba_iommu.c
+++ b/drivers/parisc/sba_iommu.c
@@ -915,7 +915,7 @@ sba_free(struct device *hwdev, size_t size, void *vaddr,
 		    dma_addr_t dma_handle, unsigned long attrs)
 {
 	sba_unmap_page(hwdev, dma_handle, size, 0, 0);
-	free_pages((unsigned long) vaddr, get_order(size));
+	free_pages(vaddr, get_order(size));
 }
 
 
@@ -1178,14 +1178,14 @@ sba_alloc_pdir(unsigned int pdir_size)
 			unsigned long new_pdir = (unsigned long)__get_free_pages(GFP_KERNEL,
 										 (19 - 12));
 			/* release original */
-			free_pages(pdir_base, pdir_order);
+			free_pages((void *)pdir_base, pdir_order);
 
 			pdir_base = new_pdir;
 
 			/* release excess */
 			while (pdir_order < (19-12)) {
 				new_pdir += pdir_size;
-				free_pages(new_pdir, pdir_order);
+				free_pages((void *)new_pdir, pdir_order);
 				pdir_order +=1;
 				pdir_size <<=1;
 			}
@@ -1199,10 +1199,10 @@ sba_alloc_pdir(unsigned int pdir_size)
 									 pdir_order + 1); /* 2 or 4MB */
 
 		/* release original */
-		free_pages( pdir_base, pdir_order);
+		free_pages((void *)pdir_base, pdir_order);
 
 		/* release first 1MB */
-		free_pages(new_pdir, 20-12);
+		free_pages((void *)new_pdir, 20 - 12);
 
 		pdir_base = new_pdir + 1024*1024;
 
@@ -1217,10 +1217,10 @@ sba_alloc_pdir(unsigned int pdir_size)
 
 			new_pdir += 3*1024*1024;
 			/* release last 1MB */
-			free_pages(new_pdir, 20-12);
+			free_pages((void *)new_pdir, 20 - 12);
 
 			/* release unusable 128KB */
-			free_pages(new_pdir - 128*1024 , 17-12);
+			free_pages((void *)(new_pdir - 128 * 1024), 17 - 12);
 
 			pdir_size -= 128*1024;
 		}
diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
index e255c1b069ec..797d8dc0ba52 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -663,7 +663,7 @@ static void pmu_sbi_snapshot_free(struct riscv_pmu *pmu)
 		if (!cpu_hw_evt->snapshot_addr)
 			continue;
 
-		free_page((unsigned long)cpu_hw_evt->snapshot_addr);
+		free_page(cpu_hw_evt->snapshot_addr);
 		cpu_hw_evt->snapshot_addr = NULL;
 		cpu_hw_evt->snapshot_addr_phys = 0;
 	}
diff --git a/drivers/platform/goldfish/goldfish_pipe.c b/drivers/platform/goldfish/goldfish_pipe.c
index 52674f4e70af..6504746d43d5 100644
--- a/drivers/platform/goldfish/goldfish_pipe.c
+++ b/drivers/platform/goldfish/goldfish_pipe.c
@@ -750,7 +750,7 @@ static int goldfish_pipe_open(struct inode *inode, struct file *file)
 	dev->pipes[id] = NULL;
 err_id_locked:
 	spin_unlock_irqrestore(&dev->lock, flags);
-	free_page((unsigned long)pipe->command_buffer);
+	free_page(pipe->command_buffer);
 err_pipe:
 	kfree(pipe);
 	return status;
@@ -771,7 +771,7 @@ static int goldfish_pipe_release(struct inode *inode, struct file *filp)
 	spin_unlock_irqrestore(&dev->lock, flags);
 
 	filp->private_data = NULL;
-	free_page((unsigned long)pipe->command_buffer);
+	free_page(pipe->command_buffer);
 	kfree(pipe);
 	return 0;
 }
@@ -869,7 +869,7 @@ static void goldfish_pipe_device_deinit(struct platform_device *pdev,
 {
 	misc_deregister(&dev->miscdev);
 	kfree(dev->pipes);
-	free_page((unsigned long)dev->buffers);
+	free_page(dev->buffers);
 }
 
 static int goldfish_pipe_probe(struct platform_device *pdev)
diff --git a/drivers/platform/x86/dell/dell_rbu.c b/drivers/platform/x86/dell/dell_rbu.c
index c37d7adfec58..75764c328b5a 100644
--- a/drivers/platform/x86/dell/dell_rbu.c
+++ b/drivers/platform/x86/dell/dell_rbu.c
@@ -194,7 +194,7 @@ static int create_packet(void *data, size_t length) __must_hold(&rbu_data.lock)
 	while (idx--) {
 		pr_debug("freeing unused packet below floor 0x%lx\n",
 			(unsigned long)virt_to_phys(invalid_addr_packet_array[idx]));
-		free_pages((unsigned long)invalid_addr_packet_array[idx], ordernum);
+		free_pages(invalid_addr_packet_array[idx], ordernum);
 	}
 	kfree(invalid_addr_packet_array);
 
@@ -326,8 +326,7 @@ static void packet_empty_list(void)
 		memset(newpacket->data, 0, newpacket->length);
 		set_memory_wb((unsigned long)newpacket->data,
 			1 << newpacket->ordernum);
-		free_pages((unsigned long) newpacket->data,
-			newpacket->ordernum);
+		free_pages(newpacket->data, newpacket->ordernum);
 		kfree(newpacket);
 	}
 	rbu_data.packet_read_count = 0;
@@ -349,8 +348,8 @@ static void img_update_free(void)
 	 */
 	memset(rbu_data.image_update_buffer, 0,
 		rbu_data.image_update_buffer_size);
-	free_pages((unsigned long) rbu_data.image_update_buffer,
-		rbu_data.image_update_ordernum);
+	free_pages(rbu_data.image_update_buffer,
+		   rbu_data.image_update_ordernum);
 
 	/*
 	 * Re-initialize the rbu_data variables after a free
diff --git a/drivers/power/supply/power_supply_sysfs.c b/drivers/power/supply/power_supply_sysfs.c
index 301ec33e8806..c8971ca339d2 100644
--- a/drivers/power/supply/power_supply_sysfs.c
+++ b/drivers/power/supply/power_supply_sysfs.c
@@ -593,7 +593,7 @@ int power_supply_uevent(const struct device *dev, struct kobj_uevent_env *env)
 	}
 
 out:
-	free_page((unsigned long)prop_buf);
+	free_page(prop_buf);
 
 	return ret;
 }
diff --git a/drivers/ptp/ptp_kvm_x86.c b/drivers/ptp/ptp_kvm_x86.c
index 6cea4fe39bcf..97581c0785a8 100644
--- a/drivers/ptp/ptp_kvm_x86.c
+++ b/drivers/ptp/ptp_kvm_x86.c
@@ -69,7 +69,7 @@ void kvm_arch_ptp_exit(void)
 {
 	if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT)) {
 		WARN_ON(set_memory_encrypted((unsigned long)clock_pair, 1));
-		free_page((unsigned long)clock_pair);
+		free_page(clock_pair);
 		clock_pair = NULL;
 	}
 }
diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 2015399f03fd..618f512a06c9 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -4297,7 +4297,7 @@ ptp_ocp_summary_show(struct seq_file *s, void *data)
 			   post_ns - pre_ns);
 	}
 
-	free_page((unsigned long)buf);
+	free_page(buf);
 	return 0;
 }
 DEFINE_SHOW_ATTRIBUTE(ptp_ocp_summary);
diff --git a/drivers/ras/cec.c b/drivers/ras/cec.c
index 3487df2387b8..a394c4beafbf 100644
--- a/drivers/ras/cec.c
+++ b/drivers/ras/cec.c
@@ -577,7 +577,7 @@ static int __init cec_init(void)
 	}
 
 	if (create_debugfs_nodes()) {
-		free_page((unsigned long)ce_arr.array);
+		free_page(ce_arr.array);
 		return -ENOMEM;
 	}
 
diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index 7fac01a9ccc8..4500987044d2 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -99,15 +99,15 @@ struct dasd_device *dasd_alloc_device(void)
 	/* Get one page for error recovery. */
 	device->erp_mem = get_zeroed_page(GFP_ATOMIC | GFP_DMA);
 	if (!device->erp_mem) {
-		free_pages((unsigned long) device->ccw_mem, 1);
+		free_pages(device->ccw_mem, 1);
 		kfree(device);
 		return ERR_PTR(-ENOMEM);
 	}
 	/* Get two pages for ese format. */
 	device->ese_mem = __get_free_pages(GFP_ATOMIC | GFP_DMA, 1);
 	if (!device->ese_mem) {
-		free_page((unsigned long) device->erp_mem);
-		free_pages((unsigned long) device->ccw_mem, 1);
+		free_page(device->erp_mem);
+		free_pages(device->ccw_mem, 1);
 		kfree(device);
 		return ERR_PTR(-ENOMEM);
 	}
@@ -137,9 +137,9 @@ struct dasd_device *dasd_alloc_device(void)
 void dasd_free_device(struct dasd_device *device)
 {
 	kfree(device->private);
-	free_pages((unsigned long) device->ese_mem, 1);
-	free_page((unsigned long) device->erp_mem);
-	free_pages((unsigned long) device->ccw_mem, 1);
+	free_pages(device->ese_mem, 1);
+	free_page(device->erp_mem);
+	free_pages(device->ccw_mem, 1);
 	kfree(device);
 }
 
diff --git a/drivers/s390/block/dasd_diag.c b/drivers/s390/block/dasd_diag.c
index 67031a6d9342..c4a6d26332f7 100644
--- a/drivers/s390/block/dasd_diag.c
+++ b/drivers/s390/block/dasd_diag.c
@@ -467,7 +467,7 @@ dasd_diag_check_device(struct dasd_device *device)
 out_bio:
 	kfree(bio);
 out_label:
-	free_page((long) label);
+	free_page(label);
 out:
 	if (rc) {
 		device->block = NULL;
diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index 8f7ef03ae444..5a70047f812f 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -5655,7 +5655,7 @@ static void dasd_eckd_dump_sense_ccw(struct dasd_device *device,
 		}
 		dasd_eckd_dump_ccw_range(device, from, last, page + len);
 	}
-	free_page((unsigned long) page);
+	free_page(page);
 }
 
 
@@ -5770,7 +5770,7 @@ static void dasd_eckd_dump_sense_tcw(struct dasd_device *device,
 		sprintf(page + len, "SORRY - NO TSB DATA AVAILABLE\n");
 	}
 	dev_err(&device->cdev->dev, "%s", page);
-	free_page((unsigned long) page);
+	free_page(page);
 }
 
 static void dasd_eckd_dump_sense(struct dasd_device *device,
@@ -6946,7 +6946,7 @@ dasd_eckd_init(void)
 		kfree(pe_handler_worker);
 		kfree(dasd_reserve_req);
 		kfree(dasd_vol_info_req);
-		free_page((unsigned long)rawpadpage);
+		free_page(rawpadpage);
 	}
 	return ret;
 }
@@ -6957,7 +6957,7 @@ dasd_eckd_cleanup(void)
 	ccw_driver_unregister(&dasd_eckd_driver);
 	kfree(pe_handler_worker);
 	kfree(dasd_reserve_req);
-	free_page((unsigned long)rawpadpage);
+	free_page(rawpadpage);
 }
 
 module_init(dasd_eckd_init);
diff --git a/drivers/s390/block/dasd_eer.c b/drivers/s390/block/dasd_eer.c
index 0d95c650a067..5527b01232a8 100644
--- a/drivers/s390/block/dasd_eer.c
+++ b/drivers/s390/block/dasd_eer.c
@@ -211,7 +211,7 @@ static void dasd_eer_free_buffer_pages(char **buf, int no_pages)
 	int i;
 
 	for (i = 0; i < no_pages; i++)
-		free_page((unsigned long) buf[i]);
+		free_page(buf[i]);
 }
 
 /*
diff --git a/drivers/s390/block/dasd_fba.c b/drivers/s390/block/dasd_fba.c
index 65e51c71e28c..b6c9ae2049cc 100644
--- a/drivers/s390/block/dasd_fba.c
+++ b/drivers/s390/block/dasd_fba.c
@@ -746,7 +746,7 @@ dasd_fba_dump_sense(struct dasd_device *device, struct dasd_ccw_req * req,
 	}
 	if (len > 0)
 		dev_err(dev, "%s", page);
-	free_page((unsigned long) page);
+	free_page(page);
 }
 
 static unsigned int dasd_fba_max_sectors(struct dasd_block *block)
@@ -805,7 +805,7 @@ static void __exit
 dasd_fba_cleanup(void)
 {
 	ccw_driver_unregister(&dasd_fba_driver);
-	free_page((unsigned long)dasd_fba_zero_page);
+	free_page(dasd_fba_zero_page);
 }
 
 module_init(dasd_fba_init);
diff --git a/drivers/s390/block/scm_blk.c b/drivers/s390/block/scm_blk.c
index c103059c4417..499b13a6de07 100644
--- a/drivers/s390/block/scm_blk.c
+++ b/drivers/s390/block/scm_blk.c
@@ -43,7 +43,7 @@ static void __scm_free_rq(struct scm_request *scmrq)
 {
 	struct aob_rq_header *aobrq = to_aobrq(scmrq);
 
-	free_page((unsigned long) scmrq->aob);
+	free_page(scmrq->aob);
 	kfree(scmrq->request);
 	kfree(aobrq);
 }
diff --git a/drivers/s390/char/con3270.c b/drivers/s390/char/con3270.c
index 1a9f7d38a0e0..c868b34a5f48 100644
--- a/drivers/s390/char/con3270.c
+++ b/drivers/s390/char/con3270.c
@@ -881,7 +881,7 @@ static void tty3270_free_view(struct tty3270 *tp)
 	raw3270_request_free(tp->kreset);
 	raw3270_request_free(tp->read);
 	raw3270_request_free(tp->write);
-	free_page((unsigned long)tp->converted_line);
+	free_page(tp->converted_line);
 	tty_port_destroy(&tp->port);
 	kfree(tp);
 }
@@ -1064,7 +1064,7 @@ static void tty3270_free(struct raw3270_view *view)
 
 	timer_delete_sync(&tp->timer);
 	tty3270_free_screen(tp->screen, tp->allocated_lines);
-	free_page((unsigned long)tp->converted_line);
+	free_page(tp->converted_line);
 	kfree(tp->input);
 	kfree(tp->prompt);
 	tty3270_free_view(tp);
@@ -1168,7 +1168,7 @@ tty3270_create_view(int index, struct tty3270 **newtp)
 out_free_input:
 	kfree(tp->input);
 out_free_converted_line:
-	free_page((unsigned long)tp->converted_line);
+	free_page(tp->converted_line);
 out_free_screen:
 	tty3270_free_screen(tp->screen, tp->view.rows);
 out_put_view:
diff --git a/drivers/s390/char/diag_ftp.c b/drivers/s390/char/diag_ftp.c
index 8867e10ebae9..6bedf252b7a9 100644
--- a/drivers/s390/char/diag_ftp.c
+++ b/drivers/s390/char/diag_ftp.c
@@ -209,7 +209,7 @@ ssize_t diag_ftp_cmd(const struct hmcdrv_ftp_cmdspec *ftp, size_t *fsize)
 	}
 
 out_free:
-	free_page((unsigned long) ldfpl);
+	free_page(ldfpl);
 out:
 	return len;
 }
diff --git a/drivers/s390/char/hmcdrv_cache.c b/drivers/s390/char/hmcdrv_cache.c
index 7d9033d4aa80..d8fcfa93cf3d 100644
--- a/drivers/s390/char/hmcdrv_cache.c
+++ b/drivers/s390/char/hmcdrv_cache.c
@@ -241,8 +241,7 @@ int hmcdrv_cache_startup(size_t cachesize)
 void hmcdrv_cache_shutdown(void)
 {
 	if (hmcdrv_cache_file.content) {
-		free_pages((unsigned long) hmcdrv_cache_file.content,
-			   hmcdrv_cache_order);
+		free_pages(hmcdrv_cache_file.content, hmcdrv_cache_order);
 		hmcdrv_cache_file.content = NULL;
 	}
 
diff --git a/drivers/s390/char/hmcdrv_ftp.c b/drivers/s390/char/hmcdrv_ftp.c
index 34cccd3ff88a..4a149938690e 100644
--- a/drivers/s390/char/hmcdrv_ftp.c
+++ b/drivers/s390/char/hmcdrv_ftp.c
@@ -219,7 +219,7 @@ int hmcdrv_ftp_probe(void)
 		break;
 	} /* switch */
 out:
-	free_page((unsigned long) ftp.buf);
+	free_page(ftp.buf);
 	return rc;
 }
 EXPORT_SYMBOL(hmcdrv_ftp_probe);
@@ -281,7 +281,7 @@ ssize_t hmcdrv_ftp_cmd(char __kernel *cmd, loff_t offset,
 		break;
 	}
 
-	free_pages((unsigned long) ftp.buf, order);
+	free_pages(ftp.buf, order);
 	return retlen;
 }
 
diff --git a/drivers/s390/char/sclp.c b/drivers/s390/char/sclp.c
index d06cf522c848..31d6facd5071 100644
--- a/drivers/s390/char/sclp.c
+++ b/drivers/s390/char/sclp.c
@@ -1302,8 +1302,8 @@ int sclp_init(void)
 fail_init_state_uninitialized:
 	list_del(&sclp_state_change_event.list);
 	sclp_init_state = sclp_init_state_uninitialized;
-	free_page((unsigned long) sclp_read_sccb);
-	free_page((unsigned long) sclp_init_sccb);
+	free_page(sclp_read_sccb);
+	free_page(sclp_init_sccb);
 fail_unlock:
 	spin_unlock_irqrestore(&sclp_lock, flags);
 	return rc;
diff --git a/drivers/s390/char/sclp_ap.c b/drivers/s390/char/sclp_ap.c
index cda419e8516e..173b4ea7707b 100644
--- a/drivers/s390/char/sclp_ap.c
+++ b/drivers/s390/char/sclp_ap.c
@@ -46,7 +46,7 @@ static int do_ap_configure(sclp_cmdw_t cmd, u32 apid)
 		break;
 	}
 out:
-	free_page((unsigned long) sccb);
+	free_page(sccb);
 	return rc;
 }
 
diff --git a/drivers/s390/char/sclp_cmd.c b/drivers/s390/char/sclp_cmd.c
index d9a0468e09b3..b8c2fdb806fe 100644
--- a/drivers/s390/char/sclp_cmd.c
+++ b/drivers/s390/char/sclp_cmd.c
@@ -120,7 +120,7 @@ int _sclp_get_core_info(struct sclp_core_info *info)
 	}
 	sclp_fill_core_info(info, sccb);
 out:
-	free_pages((unsigned long)sccb, get_order(length));
+	free_pages(sccb, get_order(length));
 	return rc;
 }
 
@@ -194,7 +194,7 @@ static int do_chp_configure(sclp_cmdw_t cmd)
 		break;
 	}
 out:
-	free_page((unsigned long)sccb);
+	free_page(sccb);
 	return rc;
 }
 
@@ -254,6 +254,6 @@ int sclp_chp_read_info(struct sclp_chp_info *info)
 	memcpy(info->standby, sccb->standby, SCLP_CHP_INFO_MASK_SIZE);
 	memcpy(info->configured, sccb->configured, SCLP_CHP_INFO_MASK_SIZE);
 out:
-	free_page((unsigned long)sccb);
+	free_page(sccb);
 	return rc;
 }
diff --git a/drivers/s390/char/sclp_con.c b/drivers/s390/char/sclp_con.c
index 5c801c4d7269..670f97201767 100644
--- a/drivers/s390/char/sclp_con.c
+++ b/drivers/s390/char/sclp_con.c
@@ -272,7 +272,7 @@ static void __init __sclp_console_free_pages(void)
 
 	list_for_each_safe(page, p, &sclp_con_pages) {
 		list_del(page);
-		free_page((unsigned long)page);
+		free_page(page);
 	}
 }
 
diff --git a/drivers/s390/char/sclp_config.c b/drivers/s390/char/sclp_config.c
index f15e78982672..212498d0d108 100644
--- a/drivers/s390/char/sclp_config.c
+++ b/drivers/s390/char/sclp_config.c
@@ -123,7 +123,7 @@ static int sclp_ofb_send_req(char *ev_data, size_t len)
 		rc = -EIO;
 	}
 out:
-	free_page((unsigned long)sccb);
+	free_page(sccb);
 	return rc;
 }
 
diff --git a/drivers/s390/char/sclp_cpi_sys.c b/drivers/s390/char/sclp_cpi_sys.c
index d194f0c86c12..697d944ca4ca 100644
--- a/drivers/s390/char/sclp_cpi_sys.c
+++ b/drivers/s390/char/sclp_cpi_sys.c
@@ -119,7 +119,7 @@ static struct sclp_req *cpi_prepare_req(void)
 
 static void cpi_free_req(struct sclp_req *req)
 {
-	free_page((unsigned long) req->sccb);
+	free_page(req->sccb);
 	kfree(req);
 }
 
diff --git a/drivers/s390/char/sclp_ctl.c b/drivers/s390/char/sclp_ctl.c
index f208be49fbbf..4fbc9c689c72 100644
--- a/drivers/s390/char/sclp_ctl.c
+++ b/drivers/s390/char/sclp_ctl.c
@@ -83,7 +83,7 @@ static int sclp_ctl_ioctl_sccb(void __user *user_area)
 	if (copy_to_user(u64_to_uptr(ctl_sccb.sccb), sccb, sccb->length))
 		rc = -EFAULT;
 out_free:
-	free_page((unsigned long) sccb);
+	free_page(sccb);
 	return rc;
 }
 
diff --git a/drivers/s390/char/sclp_ftp.c b/drivers/s390/char/sclp_ftp.c
index 0e3b2df04eab..a3424023f889 100644
--- a/drivers/s390/char/sclp_ftp.c
+++ b/drivers/s390/char/sclp_ftp.c
@@ -156,7 +156,7 @@ static int sclp_ftp_et7(const struct hmcdrv_ftp_cmdspec *ftp)
 	}
 
 out_free:
-	free_page((unsigned long) sccb);
+	free_page(sccb);
 	kfree(req);
 	return rc;
 }
@@ -263,7 +263,7 @@ int sclp_ftp_startup(void)
 				 info222->lpar_number, info222->name);
 		}
 
-		free_page(info);
+		free_page((void *)info);
 	}
 #endif	/* DEBUG */
 	return 0;
diff --git a/drivers/s390/char/sclp_mem.c b/drivers/s390/char/sclp_mem.c
index 2157b4f4fce2..8786876b07bc 100644
--- a/drivers/s390/char/sclp_mem.c
+++ b/drivers/s390/char/sclp_mem.c
@@ -87,7 +87,7 @@ static int do_assign_storage(sclp_cmdw_t cmd, u16 rn)
 		break;
 	}
 out:
-	free_page((unsigned long)sccb);
+	free_page(sccb);
 	return rc;
 }
 
@@ -136,7 +136,7 @@ static int sclp_attach_storage(u8 id)
 		break;
 	}
 out:
-	free_page((unsigned long)sccb);
+	free_page(sccb);
 	return rc;
 }
 
@@ -393,7 +393,7 @@ static int __init sclp_detect_standby_memory(void)
 		goto out;
 	sclp_add_standby_memory();
 out:
-	free_page((unsigned long)sccb);
+	free_page(sccb);
 	return rc;
 }
 __initcall(sclp_detect_standby_memory);
diff --git a/drivers/s390/char/sclp_pci.c b/drivers/s390/char/sclp_pci.c
index 2efbe0fe2390..fa89051ed653 100644
--- a/drivers/s390/char/sclp_pci.c
+++ b/drivers/s390/char/sclp_pci.c
@@ -66,7 +66,7 @@ static int do_pci_configure(sclp_cmdw_t cmd, u32 fid)
 		break;
 	}
 out:
-	free_page((unsigned long) sccb);
+	free_page(sccb);
 	return rc;
 }
 
@@ -174,7 +174,7 @@ int sclp_pci_report(struct zpci_report_error_header *report, u32 fh, u32 fid)
 	}
 
 out_free_req:
-	free_page((unsigned long) sccb);
+	free_page(sccb);
 out_unregister:
 	sclp_unregister(&sclp_pci_event);
 out_unlock:
diff --git a/drivers/s390/char/sclp_sd.c b/drivers/s390/char/sclp_sd.c
index 35c963d78019..6f8c77e63239 100644
--- a/drivers/s390/char/sclp_sd.c
+++ b/drivers/s390/char/sclp_sd.c
@@ -348,7 +348,7 @@ static int sclp_sd_store_data(struct sclp_sd_data *result, u8 di)
 
 out:
 	base_asce_free(asce);
-	free_page(page);
+	free_page((void *)page);
 
 	return rc;
 }
diff --git a/drivers/s390/char/sclp_sdias.c b/drivers/s390/char/sclp_sdias.c
index 0ac7220f2be6..ee795c32413c 100644
--- a/drivers/s390/char/sclp_sdias.c
+++ b/drivers/s390/char/sclp_sdias.c
@@ -269,7 +269,7 @@ int __init sclp_sdias_init(void)
 	if (sclp_sdias_init_async() == 0)
 		goto out;
 	TRACE("init failed\n");
-	free_page((unsigned long) sclp_sdias_sccb);
+	free_page(sclp_sdias_sccb);
 	return -ENODEV;
 out:
 	TRACE("init done\n");
diff --git a/drivers/s390/char/sclp_tty.c b/drivers/s390/char/sclp_tty.c
index fc4e20bc2b7c..3bd4eead9dbe 100644
--- a/drivers/s390/char/sclp_tty.c
+++ b/drivers/s390/char/sclp_tty.c
@@ -497,7 +497,7 @@ static void __init __sclp_tty_free_pages(void)
 
 	list_for_each_safe(page, p, &sclp_tty_pages) {
 		list_del(page);
-		free_page((unsigned long)page);
+		free_page(page);
 	}
 }
 
diff --git a/drivers/s390/char/sclp_vt220.c b/drivers/s390/char/sclp_vt220.c
index 268beae8086d..8c8f258556a4 100644
--- a/drivers/s390/char/sclp_vt220.c
+++ b/drivers/s390/char/sclp_vt220.c
@@ -659,7 +659,7 @@ static void __init __sclp_vt220_free_pages(void)
 
 	list_for_each_safe(page, p, &sclp_vt220_empty) {
 		list_del(page);
-		free_page((unsigned long) page);
+		free_page(page);
 	}
 }
 
diff --git a/drivers/s390/char/uvdevice.c b/drivers/s390/char/uvdevice.c
index ec51367120c4..d36d3341f8f3 100644
--- a/drivers/s390/char/uvdevice.c
+++ b/drivers/s390/char/uvdevice.c
@@ -377,7 +377,7 @@ static int uvio_list_secrets(struct uvio_ioctl_cb *uv_ioctl)
 
 	rc = uvio_get_list(zpage, uv_ioctl);
 
-	free_page((unsigned long)zpage);
+	free_page(zpage);
 	return rc;
 }
 
diff --git a/drivers/s390/char/vmcp.c b/drivers/s390/char/vmcp.c
index afefb33e16c3..fe7dba882867 100644
--- a/drivers/s390/char/vmcp.c
+++ b/drivers/s390/char/vmcp.c
@@ -93,7 +93,7 @@ static void vmcp_response_free(struct vmcp_session *session)
 		cma_release(vmcp_cma, page, nr_pages);
 		session->cma_alloc = 0;
 	} else {
-		free_pages((unsigned long)session->response, order);
+		free_pages(session->response, order);
 	}
 	session->response = NULL;
 }
diff --git a/drivers/s390/char/vmlogrdr.c b/drivers/s390/char/vmlogrdr.c
index b8b673bdc3e6..b7e9055e5139 100644
--- a/drivers/s390/char/vmlogrdr.c
+++ b/drivers/s390/char/vmlogrdr.c
@@ -794,7 +794,7 @@ static void vmlogrdr_cleanup(void)
 	}
 	for (i=0; i < MAXMINOR; ++i ) {
 		vmlogrdr_unregister_device(&sys_ser[i]);
-		free_page((unsigned long)sys_ser[i].buffer);
+		free_page(sys_ser[i].buffer);
 	}
 	vmlogrdr_unregister_driver();
 	if (vmlogrdr_major) {
diff --git a/drivers/s390/char/vmur.c b/drivers/s390/char/vmur.c
index dc3f1deaf20c..18fbf5acf88b 100644
--- a/drivers/s390/char/vmur.c
+++ b/drivers/s390/char/vmur.c
@@ -558,7 +558,7 @@ static ssize_t diag14_read(struct file *file, char __user *ubuf, size_t count,
 	*offs += copied;
 	rc = copied;
 fail:
-	free_page((unsigned long) buf);
+	free_page(buf);
 	return rc;
 }
 
@@ -643,7 +643,7 @@ static int verify_uri_device(struct urdev *urd)
 	rc = 0;
 
 fail_free_buf:
-	free_page((unsigned long) buf);
+	free_page(buf);
 fail_free_fcb:
 	kfree(fcb);
 	return rc;
diff --git a/drivers/s390/char/zcore.c b/drivers/s390/char/zcore.c
index 2faadd0cb62f..7eaa4bbeeef2 100644
--- a/drivers/s390/char/zcore.c
+++ b/drivers/s390/char/zcore.c
@@ -238,7 +238,7 @@ static int __init zcore_reipl_init(void)
 	if (rc || (__force u32)csum_partial(zcore_ipl_block, zcore_ipl_block->hdr.len, 0) !=
 	    ipib_info.checksum) {
 		TRACE("Checksum does not match\n");
-		free_page((unsigned long) zcore_ipl_block);
+		free_page(zcore_ipl_block);
 		zcore_ipl_block = NULL;
 	}
 	/*
@@ -269,7 +269,7 @@ static int __init zcore_reipl_init(void)
 			os_info_flags = 0;
 	}
 out:
-	free_page((unsigned long)os_info);
+	free_page(os_info);
 	return 0;
 }
 
diff --git a/drivers/s390/cio/chsc.c b/drivers/s390/cio/chsc.c
index c6e3efd4b4d1..a970f6cef70d 100644
--- a/drivers/s390/cio/chsc.c
+++ b/drivers/s390/cio/chsc.c
@@ -950,11 +950,11 @@ static void cub_free(struct channel_subsystem *css)
 	int i;
 
 	for (i = 0; i < CSS_NUM_CUB_PAGES; i++) {
-		free_page((unsigned long)css->cub[i]);
+		free_page(css->cub[i]);
 		css->cub[i] = NULL;
 	}
 	for (i = 0; i < CSS_NUM_ECUB_PAGES; i++) {
-		free_page((unsigned long)css->ecub[i]);
+		free_page(css->ecub[i]);
 		css->ecub[i] = NULL;
 	}
 }
@@ -1154,16 +1154,16 @@ int __init chsc_init(void)
 		goto out_err;
 	return ret;
 out_err:
-	free_page((unsigned long)chsc_page);
-	free_page((unsigned long)sei_page);
+	free_page(chsc_page);
+	free_page(sei_page);
 	return ret;
 }
 
 void __init chsc_init_cleanup(void)
 {
 	crw_unregister_handler(CRW_RSC_CSS);
-	free_page((unsigned long)chsc_page);
-	free_page((unsigned long)sei_page);
+	free_page(chsc_page);
+	free_page(sei_page);
 }
 
 int __chsc_enable_facility(struct chsc_sda_area *sda_area, int operation_code)
diff --git a/drivers/s390/cio/chsc_sch.c b/drivers/s390/cio/chsc_sch.c
index d29d32c21ae6..a52ff8b47550 100644
--- a/drivers/s390/cio/chsc_sch.c
+++ b/drivers/s390/cio/chsc_sch.c
@@ -322,7 +322,7 @@ static int chsc_ioctl_start(void __user *user_area)
 	snprintf(dbf, sizeof(dbf), "ret:%d", ret);
 	CHSC_LOG(0, dbf);
 	kfree(request);
-	free_page((unsigned long)chsc_area);
+	free_page(chsc_area);
 	return ret;
 }
 
@@ -354,7 +354,7 @@ static int chsc_ioctl_on_close_set(void __user *user_area)
 	goto out_unlock;
 
 out_free_chsc:
-	free_page((unsigned long)on_close_chsc_area);
+	free_page(on_close_chsc_area);
 	on_close_chsc_area = NULL;
 out_free_request:
 	kfree(on_close_request);
@@ -376,7 +376,7 @@ static int chsc_ioctl_on_close_remove(void)
 		ret = -ENOENT;
 		goto out_unlock;
 	}
-	free_page((unsigned long)on_close_chsc_area);
+	free_page(on_close_chsc_area);
 	on_close_chsc_area = NULL;
 	kfree(on_close_request);
 	on_close_request = NULL;
@@ -415,7 +415,7 @@ static int chsc_ioctl_start_sync(void __user *user_area)
 	else
 		ret = 0;
 out_free:
-	free_page((unsigned long)chsc_area);
+	free_page(chsc_area);
 	return ret;
 }
 
@@ -477,7 +477,7 @@ static int chsc_ioctl_info_channel_path(void __user *user_cd)
 		ret = 0;
 out_free:
 	kfree(cd);
-	free_page((unsigned long)scpcd_area);
+	free_page(scpcd_area);
 	return ret;
 }
 
@@ -539,7 +539,7 @@ static int chsc_ioctl_info_cu(void __user *user_cd)
 		ret = 0;
 out_free:
 	kfree(cd);
-	free_page((unsigned long)scucd_area);
+	free_page(scucd_area);
 	return ret;
 }
 
@@ -603,7 +603,7 @@ static int chsc_ioctl_info_sch_cu(void __user *user_cud)
 		ret = 0;
 out_free:
 	kfree(cud);
-	free_page((unsigned long)sscud_area);
+	free_page(sscud_area);
 	return ret;
 }
 
@@ -663,7 +663,7 @@ static int chsc_ioctl_conf_info(void __user *user_ci)
 		ret = 0;
 out_free:
 	kfree(ci);
-	free_page((unsigned long)sci_area);
+	free_page(sci_area);
 	return ret;
 }
 
@@ -746,7 +746,7 @@ static int chsc_ioctl_conf_comp_list(void __user *user_ccl)
 		ret = 0;
 out_free:
 	kfree(ccl);
-	free_page((unsigned long)sccl_area);
+	free_page(sccl_area);
 	return ret;
 }
 
@@ -776,7 +776,7 @@ static int chsc_ioctl_chpd(void __user *user_chpd)
 		ret = -EFAULT;
 out_free:
 	kfree(chpd);
-	free_page((unsigned long)scpd_area);
+	free_page(scpd_area);
 	return ret;
 }
 
@@ -835,7 +835,7 @@ static int chsc_ioctl_dcal(void __user *user_dcal)
 		ret = 0;
 out_free:
 	kfree(dcal);
-	free_page((unsigned long)sdcal_area);
+	free_page(sdcal_area);
 	return ret;
 }
 
@@ -908,7 +908,7 @@ static int chsc_release(struct inode *inode, struct file *filp)
 	}
 	snprintf(dbf, sizeof(dbf), "relret:%d", ret);
 	CHSC_LOG(0, dbf);
-	free_page((unsigned long)on_close_chsc_area);
+	free_page(on_close_chsc_area);
 	on_close_chsc_area = NULL;
 	kfree(on_close_request);
 	on_close_request = NULL;
diff --git a/drivers/s390/cio/cmf.c b/drivers/s390/cio/cmf.c
index 6cfda811c37d..738bf3cee098 100644
--- a/drivers/s390/cio/cmf.c
+++ b/drivers/s390/cio/cmf.c
@@ -507,7 +507,7 @@ static int alloc_cmb(struct ccw_device *cdev)
 
 		if (cmb_area.mem) {
 			/* ok, another thread was faster */
-			free_pages((unsigned long)mem, get_order(size));
+			free_pages(mem, get_order(size));
 		} else if (!mem) {
 			/* no luck */
 			ret = -ENOMEM;
@@ -551,7 +551,7 @@ static void free_cmb(struct ccw_device *cdev)
 		ssize_t size;
 		size = sizeof(struct cmb) * cmb_area.num_channels;
 		cmf_activate(NULL, CMF_OFF);
-		free_pages((unsigned long)cmb_area.mem, get_order(size));
+		free_pages(cmb_area.mem, get_order(size));
 		cmb_area.mem = NULL;
 	}
 	spin_unlock_irq(cdev->ccwlock);
diff --git a/drivers/s390/cio/qdio_main.c b/drivers/s390/cio/qdio_main.c
index 5e8c0b743c67..dcc6570859f1 100644
--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -933,10 +933,10 @@ int qdio_free(struct ccw_device *cdev)
 	mutex_unlock(&irq_ptr->setup_mutex);
 
 	qdio_free_queues(irq_ptr);
-	free_page((unsigned long) irq_ptr->qdr);
-	free_page(irq_ptr->chsc_page);
+	free_page(irq_ptr->qdr);
+	free_page((void *)irq_ptr->chsc_page);
 	kfree(irq_ptr->ccw);
-	free_page((unsigned long) irq_ptr);
+	free_page(irq_ptr);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(qdio_free);
@@ -1004,14 +1004,14 @@ int qdio_allocate(struct ccw_device *cdev, unsigned int no_input_qs,
 	return 0;
 
 err_queues:
-	free_page((unsigned long) irq_ptr->qdr);
+	free_page(irq_ptr->qdr);
 err_qdr:
-	free_page(irq_ptr->chsc_page);
+	free_page((void *)irq_ptr->chsc_page);
 err_chsc:
 err_dbf:
 	kfree(irq_ptr->ccw);
 err_ccw:
-	free_page((unsigned long) irq_ptr);
+	free_page(irq_ptr);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(qdio_allocate);
diff --git a/drivers/s390/cio/qdio_setup.c b/drivers/s390/cio/qdio_setup.c
index ee2f184cdc80..29ed1e431272 100644
--- a/drivers/s390/cio/qdio_setup.c
+++ b/drivers/s390/cio/qdio_setup.c
@@ -35,7 +35,7 @@ void qdio_free_buffers(struct qdio_buffer **buf, unsigned int count)
 	int pos;
 
 	for (pos = 0; pos < count; pos += QBUFF_PER_PAGE)
-		free_page((unsigned long) buf[pos]);
+		free_page(buf[pos]);
 }
 EXPORT_SYMBOL_GPL(qdio_free_buffers);
 
@@ -83,7 +83,7 @@ static void __qdio_free_queues(struct qdio_q **queues, unsigned int count)
 
 	for (i = 0; i < count; i++) {
 		q = queues[i];
-		free_page((unsigned long)q->sl_page);
+		free_page(q->sl_page);
 		kmem_cache_free(qdio_q_cache, q);
 	}
 }
@@ -270,7 +270,7 @@ int qdio_setup_get_ssqd(struct qdio_irq *irq_ptr,
 
 out:
 	if (!irq_ptr)
-		free_page((unsigned long)ssqd);
+		free_page(ssqd);
 
 	return rc;
 }
diff --git a/drivers/s390/cio/scm.c b/drivers/s390/cio/scm.c
index df84fb41ec4a..af81e0c35b08 100644
--- a/drivers/s390/cio/scm.c
+++ b/drivers/s390/cio/scm.c
@@ -250,7 +250,7 @@ int scm_update_information(void)
 		token = scm_info->restok;
 	} while (token);
 
-	free_page((unsigned long)scm_info);
+	free_page(scm_info);
 
 	return ret;
 }
diff --git a/drivers/s390/crypto/zcrypt_api.c b/drivers/s390/crypto/zcrypt_api.c
index dee1e0a22082..a5ab45b0fd34 100644
--- a/drivers/s390/crypto/zcrypt_api.c
+++ b/drivers/s390/crypto/zcrypt_api.c
@@ -1999,7 +1999,7 @@ int zcrypt_rng_device_add(void)
 	return 0;
 
 out_free:
-	free_page((unsigned long)zcrypt_rng_buffer);
+	free_page(zcrypt_rng_buffer);
 out:
 	mutex_unlock(&zcrypt_rng_mutex);
 	return rc;
@@ -2011,7 +2011,7 @@ void zcrypt_rng_device_remove(void)
 	zcrypt_rng_device_count--;
 	if (zcrypt_rng_device_count == 0) {
 		hwrng_unregister(&zcrypt_rng_dev);
-		free_page((unsigned long)zcrypt_rng_buffer);
+		free_page(zcrypt_rng_buffer);
 	}
 	mutex_unlock(&zcrypt_rng_mutex);
 }
diff --git a/drivers/s390/crypto/zcrypt_msgtype6.c b/drivers/s390/crypto/zcrypt_msgtype6.c
index d41471bebdd5..9026b60fdbce 100644
--- a/drivers/s390/crypto/zcrypt_msgtype6.c
+++ b/drivers/s390/crypto/zcrypt_msgtype6.c
@@ -993,7 +993,7 @@ static long zcrypt_msgtype6_modexpo(struct zcrypt_queue *zq,
 	}
 
 out_free:
-	free_page((unsigned long)ap_msg->msg);
+	free_page(ap_msg->msg);
 	ap_msg->msg = NULL;
 	return rc;
 }
@@ -1040,7 +1040,7 @@ static long zcrypt_msgtype6_modexpo_crt(struct zcrypt_queue *zq,
 	}
 
 out_free:
-	free_page((unsigned long)ap_msg->msg);
+	free_page(ap_msg->msg);
 	ap_msg->msg = NULL;
 	return rc;
 }
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 422ac9ca5dca..a0efaf12d0d3 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -3383,7 +3383,7 @@ static void qeth_get_trap_id(struct qeth_card *card, struct qeth_trap_id *tid)
 		EBCASC(info322->vm[0].name, sizeof(info322->vm[0].name));
 		memcpy(tid->vmname, info322->vm[0].name, sizeof(tid->vmname));
 	}
-	free_page(info);
+	free_page((void *)info);
 }
 
 static int qeth_hw_trap_cb(struct qeth_card *card,
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 75c38b61ffe2..67232edd745b 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -599,7 +599,7 @@ static int qeth_l2_pnso(struct qeth_card *card, u8 oc, int cnc,
 	if (rc)
 		QETH_CARD_TEXT_(card, 2, "PNrp%04x", rr->response.code);
 
-	free_page((unsigned long)rr);
+	free_page(rr);
 	return rc;
 }
 
diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
index b822787a6d33..5890ace570a2 100644
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -645,7 +645,7 @@ static void zfcp_fc_sg_free_table(struct scatterlist *sg, int count)
 
 	for (i = 0; i < count; i++, sg = sg_next(sg))
 		if (sg)
-			free_page((unsigned long) sg_virt(sg));
+			free_page(sg_virt(sg));
 		else
 			break;
 }
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index c12f611f94ea..f72a9869493c 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -882,7 +882,7 @@ static void ibmvfc_free_queue(struct ibmvfc_host *vhost,
 	struct device *dev = vhost->dev;
 
 	dma_unmap_single(dev, queue->msg_token, PAGE_SIZE, DMA_BIDIRECTIONAL);
-	free_page((unsigned long)queue->msgs.handle);
+	free_page(queue->msgs.handle);
 	queue->msgs.handle = NULL;
 
 	ibmvfc_free_event_pool(vhost, queue);
@@ -5840,7 +5840,7 @@ static int ibmvfc_alloc_queue(struct ibmvfc_host *vhost,
 					  DMA_BIDIRECTIONAL);
 
 	if (dma_mapping_error(dev, queue->msg_token)) {
-		free_page((unsigned long)queue->msgs.handle);
+		free_page(queue->msgs.handle);
 		queue->msgs.handle = NULL;
 		return -ENOMEM;
 	}
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index d02f6ab79145..5328aee80de4 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -154,7 +154,7 @@ static void ibmvscsi_release_crq_queue(struct crq_queue *queue,
 	dma_unmap_single(hostdata->dev,
 			 queue->msg_token,
 			 queue->size * sizeof(*queue->msgs), DMA_BIDIRECTIONAL);
-	free_page((unsigned long)queue->msgs);
+	free_page(queue->msgs);
 }
 
 /**
@@ -399,7 +399,7 @@ static int ibmvscsi_init_crq_queue(struct crq_queue *queue,
 			 queue->msg_token,
 			 queue->size * sizeof(*queue->msgs), DMA_BIDIRECTIONAL);
       map_failed:
-	free_page((unsigned long)queue->msgs);
+	free_page(queue->msgs);
       malloc_failed:
 	return -1;
 }
diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index 6159ecd0b4ae..68ccdc5c47bb 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -3013,7 +3013,7 @@ static long ibmvscsis_create_command_q(struct scsi_info *vscsi, int num_cmds)
 						vscsi->cmd_q.base_addr,
 						PAGE_SIZE, DMA_BIDIRECTIONAL);
 	if (dma_mapping_error(&vdev->dev, vscsi->cmd_q.crq_token)) {
-		free_page((unsigned long)vscsi->cmd_q.base_addr);
+		free_page(vscsi->cmd_q.base_addr);
 		return -ENOMEM;
 	}
 
@@ -3033,7 +3033,7 @@ static void ibmvscsis_destroy_command_q(struct scsi_info *vscsi)
 {
 	dma_unmap_single(&vscsi->dma_dev->dev, vscsi->cmd_q.crq_token,
 			 PAGE_SIZE, DMA_BIDIRECTIONAL);
-	free_page((unsigned long)vscsi->cmd_q.base_addr);
+	free_page(vscsi->cmd_q.base_addr);
 	vscsi->cmd_q.base_addr = NULL;
 	vscsi->state = NO_QUEUE;
 }
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 6e3b56594bee..59d7b2681f2a 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -3226,7 +3226,7 @@ static void ipr_release_dump(struct kref *kref)
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 
 	for (i = 0; i < dump->ioa_dump.next_page_index; i++)
-		free_page((unsigned long) dump->ioa_dump.ioa_data[i]);
+		free_page(dump->ioa_dump.ioa_data[i]);
 
 	vfree(dump->ioa_dump.ioa_data);
 	kfree(dump);
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index e1c51bfee444..3196193d4b2f 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -3223,8 +3223,7 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, int dd_size,
 	return cls_conn;
 
 login_task_add_dev_fail:
-	free_pages((unsigned long) conn->data,
-		   get_order(ISCSI_DEF_MAX_RECV_SEG_LEN));
+	free_pages(conn->data, get_order(ISCSI_DEF_MAX_RECV_SEG_LEN));
 
 login_task_data_alloc_fail:
 	kfifo_in(&session->cmdpool.queue, (void*)&conn->login_task,
@@ -3267,8 +3266,7 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 	iscsi_suspend_tx(conn);
 
 	spin_lock_bh(&session->frwd_lock);
-	free_pages((unsigned long) conn->data,
-		   get_order(ISCSI_DEF_MAX_RECV_SEG_LEN));
+	free_pages(conn->data, get_order(ISCSI_DEF_MAX_RECV_SEG_LEN));
 	kfree(conn->persistent_address);
 	kfree(conn->local_ipaddr);
 	/* regular RX path uses back_lock */
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index abbbc4b36cd1..da5cbe519de5 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -8056,7 +8056,7 @@ static void megasas_detach_one(struct pci_dev *pdev)
 				if (is_vmalloc_addr(fusion->ld_drv_map[i]))
 					vfree(fusion->ld_drv_map[i]);
 				else
-					free_pages((ulong)fusion->ld_drv_map[i],
+					free_pages(fusion->ld_drv_map[i],
 						   fusion->drv_map_pages);
 			}
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 579e0ea044f7..23cea5bbf216 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1693,7 +1693,7 @@ static inline int megasas_allocate_raid_maps(struct megasas_instance *instance)
 			if (is_vmalloc_addr(fusion->ld_drv_map[i]))
 				vfree(fusion->ld_drv_map[i]);
 			else
-				free_pages((ulong)fusion->ld_drv_map[i],
+				free_pages(fusion->ld_drv_map[i],
 					   fusion->drv_map_pages);
 		}
 	}
@@ -5351,15 +5351,15 @@ megasas_free_fusion_context(struct megasas_instance *instance)
 			if (is_vmalloc_addr(fusion->load_balance_info))
 				vfree(fusion->load_balance_info);
 			else
-				free_pages((ulong)fusion->load_balance_info,
-					fusion->load_balance_info_pages);
+				free_pages(fusion->load_balance_info,
+					   fusion->load_balance_info_pages);
 		}
 
 		if (fusion->log_to_span) {
 			if (is_vmalloc_addr(fusion->log_to_span))
 				vfree(fusion->log_to_span);
 			else
-				free_pages((ulong)fusion->log_to_span,
+				free_pages(fusion->log_to_span,
 					   fusion->log_to_span_pages);
 		}
 
diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 3576e00880d4..9ddbb2cd97e5 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -360,7 +360,7 @@ static m_addr_t ___mp0_getp(m_pool_s *mp)
 
 static void ___mp0_freep(m_pool_s *mp, m_addr_t m)
 {
-	free_pages(m, MEMO_PAGE_ORDER);
+	free_pages((void *)m, MEMO_PAGE_ORDER);
 	--mp->nump;
 }
 
diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 2433084f25af..795655105d0b 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -168,17 +168,17 @@ static int qedi_uio_close(struct uio_info *uinfo, struct inode *inode)
 static void __qedi_free_uio_rings(struct qedi_uio_dev *udev)
 {
 	if (udev->uctrl) {
-		free_page((unsigned long)udev->uctrl);
+		free_page(udev->uctrl);
 		udev->uctrl = NULL;
 	}
 
 	if (udev->ll2_ring) {
-		free_page((unsigned long)udev->ll2_ring);
+		free_page(udev->ll2_ring);
 		udev->ll2_ring = NULL;
 	}
 
 	if (udev->ll2_buf) {
-		free_pages((unsigned long)udev->ll2_buf, 2);
+		free_pages(udev->ll2_buf, 2);
 		udev->ll2_buf = NULL;
 	}
 }
@@ -253,7 +253,7 @@ static int __qedi_alloc_uio_rings(struct qedi_uio_dev *udev)
 	return rc;
 
 exit_alloc_buf:
-	free_page((unsigned long)udev->ll2_ring);
+	free_page(udev->ll2_ring);
 	udev->ll2_ring = NULL;
 exit_alloc_ring:
 	return rc;
diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 8a98ea647901..dbaf3830403a 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -707,7 +707,7 @@ static ssize_t proc_scsi_devinfo_write(struct file *file,
 	scsi_dev_info_list_add_str(buffer);
 
 out:
-	free_page((unsigned long)buffer);
+	free_page(buffer);
 	return err;
 }
 
diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
index 83dc96d65014..5b4c0e36a986 100644
--- a/drivers/scsi/scsi_proc.c
+++ b/drivers/scsi/scsi_proc.c
@@ -82,7 +82,7 @@ static ssize_t proc_scsi_host_write(struct file *file, const char __user *buf,
 		ret = shost->hostt->write_info(shost, page, count);
 	}
 out:
-	free_page((unsigned long)page);
+	free_page(page);
 	return ret;
 }
 
@@ -467,7 +467,7 @@ static ssize_t proc_scsi_write(struct file *file, const char __user *buf,
 		err = length;
 
  out:
-	free_page((unsigned long)buffer);
+	free_page(buffer);
 	return err;
 }
 
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.h b/drivers/scsi/sym53c8xx_2/sym_hipd.h
index a9d73199d433..19b424a484dd 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.h
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.h
@@ -1112,7 +1112,7 @@ sym_build_sge(struct sym_hcb *np, struct sym_tblmove *data, u64 badd, int len)
 #define sym_get_mem_cluster()	\
 	__get_free_pages(GFP_ATOMIC, SYM_MEM_PAGE_ORDER)
 #define sym_free_mem_cluster(p)	\
-	free_pages((unsigned long)p, SYM_MEM_PAGE_ORDER)
+	free_pages(p, SYM_MEM_PAGE_ORDER)
 
 /*
  *  Link between free memory chunks of a given size.
diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 8b2ed7424d6c..bb4a49e7adf6 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -1207,7 +1207,7 @@ static void pvscsi_free_sgls(const struct pvscsi_adapter *adapter)
 	unsigned i;
 
 	for (i = 0; i < adapter->req_depth; ++i, ++ctx)
-		free_pages((unsigned long)ctx->sgl, get_order(SGL_SIZE));
+		free_pages(ctx->sgl, get_order(SGL_SIZE));
 }
 
 static void pvscsi_shutdown_intr(struct pvscsi_adapter *adapter)
@@ -1279,8 +1279,7 @@ static int pvscsi_allocate_sg(struct pvscsi_adapter *adapter)
 		BUG_ON(!IS_ALIGNED(((unsigned long)ctx->sgl), PAGE_SIZE));
 		if (!ctx->sgl) {
 			for (; i >= 0; --i, --ctx) {
-				free_pages((unsigned long)ctx->sgl,
-					   get_order(SGL_SIZE));
+				free_pages(ctx->sgl, get_order(SGL_SIZE));
 				ctx->sgl = NULL;
 			}
 			return -ENOMEM;
diff --git a/drivers/sh/maple/maple.c b/drivers/sh/maple/maple.c
index 318cd44fe64b..34263bbfab8f 100644
--- a/drivers/sh/maple/maple.c
+++ b/drivers/sh/maple/maple.c
@@ -869,7 +869,7 @@ static int __init maple_bus_init(void)
 	free_irq(HW_EVENT_MAPLE_DMA, 0);
 
 cleanup_dma:
-	free_pages((unsigned long) maple_sendbuf, MAPLE_DMA_PAGES);
+	free_pages(maple_sendbuf, MAPLE_DMA_PAGES);
 
 cleanup_basic:
 	driver_unregister(&maple_unsupported_device.drv);
diff --git a/drivers/spi/spi-ep93xx.c b/drivers/spi/spi-ep93xx.c
index 8ceb17028276..a98dc2a46c75 100644
--- a/drivers/spi/spi-ep93xx.c
+++ b/drivers/spi/spi-ep93xx.c
@@ -597,7 +597,7 @@ static int ep93xx_spi_setup_dma(struct device *dev, struct ep93xx_spi *espi)
 	dma_release_channel(espi->dma_rx);
 	espi->dma_rx = NULL;
 fail_free_page:
-	free_page((unsigned long)espi->zeropage);
+	free_page(espi->zeropage);
 
 	return ret;
 }
@@ -614,7 +614,7 @@ static void ep93xx_spi_release_dma(struct ep93xx_spi *espi)
 	}
 
 	if (espi->zeropage)
-		free_page((unsigned long)espi->zeropage);
+		free_page(espi->zeropage);
 }
 
 static int ep93xx_spi_probe(struct platform_device *pdev)
diff --git a/drivers/spi/spi-rockchip-sfc.c b/drivers/spi/spi-rockchip-sfc.c
index d30ba0620581..5cd7eb613eb2 100644
--- a/drivers/spi/spi-rockchip-sfc.c
+++ b/drivers/spi/spi-rockchip-sfc.c
@@ -715,7 +715,7 @@ static int rockchip_sfc_probe(struct platform_device *pdev)
 
 	return 0;
 err_register:
-	free_pages((unsigned long)sfc->buffer, get_order(sfc->max_iosize));
+	free_pages(sfc->buffer, get_order(sfc->max_iosize));
 err_dma:
 	pm_runtime_get_sync(dev);
 	pm_runtime_put_noidle(dev);
@@ -736,7 +736,7 @@ static void rockchip_sfc_remove(struct platform_device *pdev)
 	struct spi_controller *host = sfc->host;
 
 	spi_unregister_controller(host);
-	free_pages((unsigned long)sfc->buffer, get_order(sfc->max_iosize));
+	free_pages(sfc->buffer, get_order(sfc->max_iosize));
 
 	clk_disable_unprepare(sfc->clk);
 	clk_disable_unprepare(sfc->hclk);
diff --git a/drivers/spi/spi-sh-msiof.c b/drivers/spi/spi-sh-msiof.c
index 7e5c393ab4e6..e4225860d6c1 100644
--- a/drivers/spi/spi-sh-msiof.c
+++ b/drivers/spi/spi-sh-msiof.c
@@ -1154,9 +1154,9 @@ static int sh_msiof_request_dma(struct sh_msiof_spi_priv *p)
 unmap_tx_page:
 	dma_unmap_single(tx_dev, p->tx_dma_addr, PAGE_SIZE, DMA_TO_DEVICE);
 free_rx_page:
-	free_page((unsigned long)p->rx_dma_page);
+	free_page(p->rx_dma_page);
 free_tx_page:
-	free_page((unsigned long)p->tx_dma_page);
+	free_page(p->tx_dma_page);
 free_rx_chan:
 	dma_release_channel(ctlr->dma_rx);
 free_tx_chan:
@@ -1176,8 +1176,8 @@ static void sh_msiof_release_dma(struct sh_msiof_spi_priv *p)
 			 DMA_FROM_DEVICE);
 	dma_unmap_single(ctlr->dma_tx->device->dev, p->tx_dma_addr, PAGE_SIZE,
 			 DMA_TO_DEVICE);
-	free_page((unsigned long)p->rx_dma_page);
-	free_page((unsigned long)p->tx_dma_page);
+	free_page(p->rx_dma_page);
+	free_page(p->tx_dma_page);
 	dma_release_channel(ctlr->dma_rx);
 	dma_release_channel(ctlr->dma_tx);
 }
diff --git a/drivers/staging/media/atomisp/pci/mmu/isp_mmu.c b/drivers/staging/media/atomisp/pci/mmu/isp_mmu.c
index 34cca9bdd12d..9649ebcb26ba 100644
--- a/drivers/staging/media/atomisp/pci/mmu/isp_mmu.c
+++ b/drivers/staging/media/atomisp/pci/mmu/isp_mmu.c
@@ -125,7 +125,7 @@ static void free_page_table(struct isp_mmu *mmu, phys_addr_t page)
 	set_memory_wb((unsigned long)virt, 1);
 #endif
 
-	free_page((unsigned long)virt);
+	free_page(virt);
 }
 
 static void mmu_remap_error(struct isp_mmu *mmu,
diff --git a/drivers/staging/media/av7110/av7110_ca.c b/drivers/staging/media/av7110/av7110_ca.c
index 4e92370a2ab7..c0d0beafc888 100644
--- a/drivers/staging/media/av7110/av7110_ca.c
+++ b/drivers/staging/media/av7110/av7110_ca.c
@@ -168,7 +168,7 @@ static ssize_t ci_ll_write(struct dvb_ringbuffer *cibuf, struct file *file,
 
 	res = dvb_ringbuffer_write(cibuf, page, count);
 out:
-	free_page((unsigned long)page);
+	free_page(page);
 	return res;
 }
 
diff --git a/drivers/staging/media/ipu3/ipu3-mmu.c b/drivers/staging/media/ipu3/ipu3-mmu.c
index bea11ebd2127..baad83373b6d 100644
--- a/drivers/staging/media/ipu3/ipu3-mmu.c
+++ b/drivers/staging/media/ipu3/ipu3-mmu.c
@@ -142,7 +142,7 @@ static u32 *imgu_mmu_alloc_page_table(u32 pteval)
 static void imgu_mmu_free_page_table(u32 *pt)
 {
 	set_memory_wb((unsigned long)pt, IPU3_PT_ORDER);
-	free_page((unsigned long)pt);
+	free_page(pt);
 }
 
 /**
@@ -488,7 +488,7 @@ struct imgu_mmu_info *imgu_mmu_init(struct device *parent, void __iomem *base)
 fail_l2pt:
 	imgu_mmu_free_page_table(mmu->dummy_l2pt);
 fail_dummy_page:
-	free_page((unsigned long)mmu->dummy_page);
+	free_page(mmu->dummy_page);
 fail_group:
 	kfree(mmu);
 
@@ -511,7 +511,7 @@ void imgu_mmu_exit(struct imgu_mmu_info *info)
 	imgu_mmu_free_page_table(mmu->l1pt);
 	vfree(mmu->l2pts);
 	imgu_mmu_free_page_table(mmu->dummy_l2pt);
-	free_page((unsigned long)mmu->dummy_page);
+	free_page(mmu->dummy_page);
 	kfree(mmu);
 }
 
diff --git a/drivers/staging/media/ipu7/ipu7-mmu.c b/drivers/staging/media/ipu7/ipu7-mmu.c
index 799c075ad61f..3594835ffe52 100644
--- a/drivers/staging/media/ipu7/ipu7-mmu.c
+++ b/drivers/staging/media/ipu7/ipu7-mmu.c
@@ -141,7 +141,7 @@ static int get_dummy_page(struct ipu7_mmu_info *mmu_info)
 	return 0;
 
 err_free_page:
-	free_page((unsigned long)pt);
+	free_page(pt);
 	return -ENOMEM;
 }
 
@@ -150,7 +150,7 @@ static void free_dummy_page(struct ipu7_mmu_info *mmu_info)
 	dma_unmap_single(mmu_info->dev,
 			 TBL_PHYS_ADDR(mmu_info->dummy_page_pteval),
 			 PAGE_SIZE, DMA_BIDIRECTIONAL);
-	free_page((unsigned long)mmu_info->dummy_page);
+	free_page(mmu_info->dummy_page);
 }
 
 static int alloc_dummy_l2_pt(struct ipu7_mmu_info *mmu_info)
@@ -179,7 +179,7 @@ static int alloc_dummy_l2_pt(struct ipu7_mmu_info *mmu_info)
 	return 0;
 
 err_free_page:
-	free_page((unsigned long)pt);
+	free_page(pt);
 	return -ENOMEM;
 }
 
@@ -188,7 +188,7 @@ static void free_dummy_l2_pt(struct ipu7_mmu_info *mmu_info)
 	dma_unmap_single(mmu_info->dev,
 			 TBL_PHYS_ADDR(mmu_info->dummy_l2_pteval),
 			 PAGE_SIZE, DMA_BIDIRECTIONAL);
-	free_page((unsigned long)mmu_info->dummy_l2_pt);
+	free_page(mmu_info->dummy_l2_pt);
 }
 
 static u32 *alloc_l1_pt(struct ipu7_mmu_info *mmu_info)
@@ -217,7 +217,7 @@ static u32 *alloc_l1_pt(struct ipu7_mmu_info *mmu_info)
 	return pt;
 
 err_free_page:
-	free_page((unsigned long)pt);
+	free_page(pt);
 	return NULL;
 }
 
@@ -323,7 +323,7 @@ static int l2_map(struct ipu7_mmu_info *mmu_info, unsigned long iova,
 			dma = map_single(mmu_info, l2_virt);
 			if (!dma) {
 				dev_err(dev, "Failed to map l2pt page\n");
-				free_page((unsigned long)l2_virt);
+				free_page(l2_virt);
 				err = -EINVAL;
 				goto error;
 			}
@@ -777,7 +777,7 @@ static void ipu7_mmu_destroy(struct ipu7_mmu *mmu)
 			dma_unmap_single(mmu_info->dev,
 					 TBL_PHYS_ADDR(mmu_info->l1_pt[l1_idx]),
 					 PAGE_SIZE, DMA_BIDIRECTIONAL);
-			free_page((unsigned long)mmu_info->l2_pts[l1_idx]);
+			free_page(mmu_info->l2_pts[l1_idx]);
 		}
 	}
 
@@ -785,8 +785,8 @@ static void ipu7_mmu_destroy(struct ipu7_mmu *mmu)
 	free_dummy_page(mmu_info);
 	dma_unmap_single(mmu_info->dev, TBL_PHYS_ADDR(mmu_info->l1_pt_dma),
 			 PAGE_SIZE, DMA_BIDIRECTIONAL);
-	free_page((unsigned long)mmu_info->dummy_l2_pt);
-	free_page((unsigned long)mmu_info->l1_pt);
+	free_page(mmu_info->dummy_l2_pt);
+	free_page(mmu_info->l1_pt);
 	kfree(mmu_info);
 }
 
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index cd37c766021e..1a6f18e0cd7d 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -524,7 +524,7 @@ fd_do_prot_unmap(struct se_cmd *cmd, sector_t lba, sector_t nolb)
 
 	rc = fd_do_prot_fill(cmd->se_dev, lba, nolb, buf, PAGE_SIZE);
 
-	free_page((unsigned long)buf);
+	free_page(buf);
 
 	return rc;
 }
diff --git a/drivers/tee/amdtee/core.c b/drivers/tee/amdtee/core.c
index 31d31fb847a1..fba5be4fb3b3 100644
--- a/drivers/tee/amdtee/core.c
+++ b/drivers/tee/amdtee/core.c
@@ -300,7 +300,7 @@ int amdtee_open_session(struct tee_context *ctx,
 	}
 
 out:
-	free_pages((u64)ta, get_order(ta_size));
+	free_pages(ta, get_order(ta_size));
 	return rc;
 }
 
diff --git a/drivers/tee/amdtee/shm_pool.c b/drivers/tee/amdtee/shm_pool.c
index 43d59e65b912..009d541b368c 100644
--- a/drivers/tee/amdtee/shm_pool.c
+++ b/drivers/tee/amdtee/shm_pool.c
@@ -30,7 +30,7 @@ static int pool_op_alloc(struct tee_shm_pool *pool, struct tee_shm *shm,
 	/* Map the allocated memory in to TEE */
 	rc = amdtee_map_shmem(shm);
 	if (rc) {
-		free_pages(va, order);
+		free_pages((void *)va, order);
 		shm->kaddr = NULL;
 		return rc;
 	}
@@ -42,7 +42,7 @@ static void pool_op_free(struct tee_shm_pool *pool, struct tee_shm *shm)
 {
 	/* Unmap the shared memory from TEE */
 	amdtee_unmap_shmem(shm);
-	free_pages((unsigned long)shm->kaddr, get_order(shm->size));
+	free_pages(shm->kaddr, get_order(shm->size));
 	shm->kaddr = NULL;
 }
 
diff --git a/drivers/thunderbolt/debugfs.c b/drivers/thunderbolt/debugfs.c
index a6384a297913..222825d184a5 100644
--- a/drivers/thunderbolt/debugfs.c
+++ b/drivers/thunderbolt/debugfs.c
@@ -142,7 +142,7 @@ static void *validate_and_copy_from_user(const void __user *user_buf,
 
 	nbytes = min_t(size_t, *count, PAGE_SIZE);
 	if (copy_from_user(buf, user_buf, nbytes)) {
-		free_page((unsigned long)buf);
+		free_page(buf);
 		return ERR_PTR(-EFAULT);
 	}
 
@@ -265,7 +265,7 @@ static ssize_t regs_write(struct tb_switch *sw, struct tb_port *port,
 out:
 	pm_runtime_mark_last_busy(&sw->dev);
 	pm_runtime_put_autosuspend(&sw->dev);
-	free_page((unsigned long)buf);
+	free_page(buf);
 
 	return ret < 0 ? ret : count;
 }
@@ -406,7 +406,7 @@ static ssize_t port_sb_regs_write(struct file *file, const char __user *user_buf
 out:
 	pm_runtime_mark_last_busy(&sw->dev);
 	pm_runtime_put_autosuspend(&sw->dev);
-	free_page((unsigned long)buf);
+	free_page(buf);
 
 	return ret < 0 ? ret : count;
 }
@@ -439,7 +439,7 @@ static ssize_t retimer_sb_regs_write(struct file *file,
 out:
 	pm_runtime_mark_last_busy(&rt->dev);
 	pm_runtime_put_autosuspend(&rt->dev);
-	free_page((unsigned long)buf);
+	free_page(buf);
 
 	return ret < 0 ? ret : count;
 }
@@ -652,7 +652,7 @@ margining_ber_level_write(struct file *file, const char __user *user_buf,
 	margining->ber_level = val;
 
 out_free:
-	free_page((unsigned long)buf);
+	free_page(buf);
 out_unlock:
 	mutex_unlock(&tb->lock);
 
@@ -829,7 +829,7 @@ margining_lanes_write(struct file *file, const char __user *user_buf,
 		}
 	}
 
-	free_page((unsigned long)buf);
+	free_page(buf);
 
 	if (lane == -1)
 		return -EINVAL;
@@ -1110,7 +1110,7 @@ static ssize_t margining_mode_write(struct file *file,
 	mutex_unlock(&tb->lock);
 
 out_free:
-	free_page((unsigned long)buf);
+	free_page(buf);
 	return ret ? ret : count;
 }
 
@@ -1497,7 +1497,7 @@ static ssize_t margining_test_write(struct file *file,
 	mutex_unlock(&tb->lock);
 
 out_free:
-	free_page((unsigned long)buf);
+	free_page(buf);
 	return ret ? ret : count;
 }
 
@@ -1563,7 +1563,7 @@ static ssize_t margining_margin_write(struct file *file,
 	mutex_unlock(&tb->lock);
 
 out_free:
-	free_page((unsigned long)buf);
+	free_page(buf);
 	return ret ? ret : count;
 }
 
@@ -1618,7 +1618,7 @@ static ssize_t margining_eye_write(struct file *file,
 			ret = -EINVAL;
 	}
 
-	free_page((unsigned long)buf);
+	free_page(buf);
 	return ret ? ret : count;
 }
 
@@ -1926,7 +1926,7 @@ static ssize_t counters_write(struct file *file, const char __user *user_buf,
 out:
 	pm_runtime_mark_last_busy(&sw->dev);
 	pm_runtime_put_autosuspend(&sw->dev);
-	free_page((unsigned long)buf);
+	free_page(buf);
 
 	return ret < 0 ? ret : count;
 }
diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
index aaee7bc901f5..c28fc56ef795 100644
--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -452,12 +452,12 @@ static int startup(struct tty_struct *tty, struct serial_state *info)
 	local_irq_save(flags);
 
 	if (tty_port_initialized(port)) {
-		free_page(page);
+		free_page((void *)page);
 		goto errout;
 	}
 
 	if (info->xmit.buf)
-		free_page(page);
+		free_page((void *)page);
 	else
 		info->xmit.buf = (unsigned char *) page;
 
@@ -537,7 +537,7 @@ static void shutdown(struct tty_struct *tty, struct serial_state *info)
 	 */
 	free_irq(IRQ_AMIGA_VERTB, info);
 
-	free_page((unsigned long)info->xmit.buf);
+	free_page(info->xmit.buf);
 	info->xmit.buf = NULL;
 
 	info->IER = 0;
diff --git a/drivers/tty/hvc/hvc_iucv.c b/drivers/tty/hvc/hvc_iucv.c
index d69d62e1f9bb..a78f3e6c0ede 100644
--- a/drivers/tty/hvc/hvc_iucv.c
+++ b/drivers/tty/hvc/hvc_iucv.c
@@ -1104,7 +1104,7 @@ static int __init hvc_iucv_alloc(int id, unsigned int is_console)
 out_error_dev:
 	hvc_remove(priv->hvc);
 out_error_hvc:
-	free_page((unsigned long) priv->sndbuf);
+	free_page(priv->sndbuf);
 	kfree(priv);
 
 	return rc;
@@ -1117,7 +1117,7 @@ static void __init hvc_iucv_destroy(struct hvc_iucv_private *priv)
 {
 	hvc_remove(priv->hvc);
 	device_unregister(priv->dev);
-	free_page((unsigned long) priv->sndbuf);
+	free_page(priv->sndbuf);
 	kfree(priv);
 }
 
diff --git a/drivers/tty/hvc/hvc_xen.c b/drivers/tty/hvc/hvc_xen.c
index 4114e9afefbe..cf3b2a82b9ab 100644
--- a/drivers/tty/hvc/hvc_xen.c
+++ b/drivers/tty/hvc/hvc_xen.c
@@ -397,7 +397,7 @@ static void xencons_disconnect_backend(struct xencons_info *info)
 
 static void xencons_free(struct xencons_info *info)
 {
-	free_page((unsigned long)info->intf);
+	free_page(info->intf);
 	info->intf = NULL;
 	info->vtermno = 0;
 	kfree(info);
diff --git a/drivers/tty/hvc/hvcs.c b/drivers/tty/hvc/hvcs.c
index 98fb63076369..5a1953534741 100644
--- a/drivers/tty/hvc/hvcs.c
+++ b/drivers/tty/hvc/hvcs.c
@@ -1487,7 +1487,7 @@ static int hvcs_initialize(void)
 	return 0;
 
 kthread_fail:
-	free_page((unsigned long)hvcs_pi_buff);
+	free_page(hvcs_pi_buff);
 buff_alloc_fail:
 	tty_unregister_driver(hvcs_tty_driver);
 register_fail:
@@ -1529,7 +1529,7 @@ static void __exit hvcs_module_exit(void)
 	kthread_stop(hvcs_task);
 
 	spin_lock(&hvcs_pi_lock);
-	free_page((unsigned long)hvcs_pi_buff);
+	free_page(hvcs_pi_buff);
 	hvcs_pi_buff = NULL;
 	spin_unlock(&hvcs_pi_lock);
 
diff --git a/drivers/tty/serial/men_z135_uart.c b/drivers/tty/serial/men_z135_uart.c
index 9295bd85948c..5085b24f8662 100644
--- a/drivers/tty/serial/men_z135_uart.c
+++ b/drivers/tty/serial/men_z135_uart.c
@@ -841,7 +841,7 @@ static int men_z135_probe(struct mcb_device *mdev,
 	return 0;
 
 err:
-	free_page((unsigned long) uart->rxbuf);
+	free_page(uart->rxbuf);
 	dev_err(dev, "Failed to add UART: %d\n", err);
 
 	return err;
@@ -858,7 +858,7 @@ static void men_z135_remove(struct mcb_device *mdev)
 
 	line--;
 	uart_remove_one_port(&men_z135_driver, &uart->port);
-	free_page((unsigned long) uart->rxbuf);
+	free_page(uart->rxbuf);
 }
 
 static const struct mcb_device_id men_z135_ids[] = {
diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 14675a6cc01d..07815504eba9 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -1728,7 +1728,7 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
 #ifdef CONFIG_SERIAL_PCH_UART_CONSOLE
 	pch_uart_ports[board->line_no] = NULL;
 #endif
-	free_page((unsigned long)rxbuf);
+	free_page(rxbuf);
 init_port_free_txbuf:
 	kfree(priv);
 init_port_alloc_err:
@@ -1743,7 +1743,7 @@ static void pch_uart_exit_port(struct eg20t_port *priv)
 	snprintf(name, sizeof(name), "uart%d_regs", priv->port.line);
 	debugfs_lookup_and_remove(name, NULL);
 	uart_remove_one_port(&pch_uart_driver, &priv->port);
-	free_page((unsigned long)priv->rxbuf.buf);
+	free_page(priv->rxbuf.buf);
 }
 
 static void pch_uart_pci_remove(struct pci_dev *pdev)
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index c787075a8547..70c4e9d21e1e 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -268,7 +268,7 @@ static int uart_alloc_xmit_buf(struct tty_port *port)
 		 * Do not free() the page under the port lock, see
 		 * uart_free_xmit_buf().
 		 */
-		free_page(page);
+		free_page((void *)page);
 	}
 
 	return 0;
@@ -293,7 +293,7 @@ static void uart_free_xmit_buf(struct tty_port *port)
 	INIT_KFIFO(port->xmit_fifo);
 	uart_port_unlock_deref(uport, flags);
 
-	free_page((unsigned long)xmit_buf);
+	free_page(xmit_buf);
 }
 
 /*
diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index 049dc37d52b0..4fd3b810bc46 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -239,7 +239,7 @@ EXPORT_SYMBOL(tty_port_alloc_xmit_buf);
 void tty_port_free_xmit_buf(struct tty_port *port)
 {
 	guard(mutex)(&port->buf_mutex);
-	free_page((unsigned long)port->xmit_buf);
+	free_page(port->xmit_buf);
 	port->xmit_buf = NULL;
 	INIT_KFIFO(port->xmit_fifo);
 }
@@ -267,7 +267,7 @@ static void tty_port_destructor(struct kref *kref)
 	/* check if last port ref was dropped before tty release */
 	if (WARN_ON(port->itty))
 		return;
-	free_page((unsigned long)port->xmit_buf);
+	free_page(port->xmit_buf);
 	tty_port_destroy(port);
 	if (port->ops && port->ops->destruct)
 		port->ops->destruct(port);
diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index 38d40e0ad66e..e218f89f2495 100644
--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -976,7 +976,7 @@ static int cxacru_fw(struct usb_device *usb_dev, enum cxacru_fw_request fw,
 	ret = 0;
 
 cleanup:
-	free_page((unsigned long) buf);
+	free_page(buf);
 	return ret;
 }
 
@@ -1218,8 +1218,8 @@ static int cxacru_bind(struct usbatm_data *usbatm_instance,
 	return 0;
 
  fail:
-	free_page((unsigned long) instance->snd_buf);
-	free_page((unsigned long) instance->rcv_buf);
+	free_page(instance->snd_buf);
+	free_page(instance->rcv_buf);
 	usb_free_urb(instance->snd_urb);
 	usb_free_urb(instance->rcv_urb);
 	kfree(instance);
@@ -1260,8 +1260,8 @@ static void cxacru_unbind(struct usbatm_data *usbatm_instance,
 	usb_free_urb(instance->snd_urb);
 	usb_free_urb(instance->rcv_urb);
 
-	free_page((unsigned long) instance->snd_buf);
-	free_page((unsigned long) instance->rcv_buf);
+	free_page(instance->snd_buf);
+	free_page(instance->rcv_buf);
 
 	kfree(instance);
 
diff --git a/drivers/usb/atm/speedtch.c b/drivers/usb/atm/speedtch.c
index 19b8645a7e46..55522b233ca3 100644
--- a/drivers/usb/atm/speedtch.c
+++ b/drivers/usb/atm/speedtch.c
@@ -339,7 +339,7 @@ static int speedtch_upload_firmware(struct speedtch_instance_data *instance,
 	ret = 0;
 
 out_free:
-	free_page((unsigned long)buffer);
+	free_page(buffer);
 out:
 	return ret;
 }
diff --git a/drivers/usb/core/buffer.c b/drivers/usb/core/buffer.c
index b3d8285dd39d..76e52617d06e 100644
--- a/drivers/usb/core/buffer.c
+++ b/drivers/usb/core/buffer.c
@@ -207,7 +207,7 @@ void hcd_buffer_free_pages(struct usb_hcd *hcd,
 	}
 
 	if (!hcd_uses_dma(hcd)) {
-		free_pages((unsigned long)addr, get_order(size));
+		free_pages(addr, get_order(size));
 		return;
 	}
 
diff --git a/drivers/usb/core/devices.c b/drivers/usb/core/devices.c
index 23ee8e6112d1..dc3137cf7738 100644
--- a/drivers/usb/core/devices.c
+++ b/drivers/usb/core/devices.c
@@ -479,7 +479,7 @@ static ssize_t usb_device_dump(char __user **buffer, size_t *nbytes,
 		if (length > *nbytes)
 			length = *nbytes;
 		if (copy_to_user(*buffer, pages_start + *skip_bytes, length)) {
-			free_pages((unsigned long)pages_start, 1);
+			free_pages(pages_start, 1);
 			return -EFAULT;
 		}
 		*nbytes -= length;
@@ -490,7 +490,7 @@ static ssize_t usb_device_dump(char __user **buffer, size_t *nbytes,
 	} else
 		*skip_bytes -= length;
 
-	free_pages((unsigned long)pages_start, 1);
+	free_pages(pages_start, 1);
 
 	/* Now look at all of this device's children. */
 	usb_hub_for_each_child(usbdev, chix, childdev) {
diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index a072bc74b920..422c07c71efb 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1265,7 +1265,7 @@ static int do_proc_control(struct usb_dev_state *ps,
  done:
 	kfree(dr);
 	usb_free_urb(urb);
-	free_page((unsigned long) tbuf);
+	free_page(tbuf);
 	usbfs_decrease_memory_usage(PAGE_SIZE + sizeof(struct urb) +
 			sizeof(struct usb_ctrlrequest));
 	return ret;
diff --git a/drivers/usb/host/ohci-dbg.c b/drivers/usb/host/ohci-dbg.c
index 88dceee751d3..d0f45df659a3 100644
--- a/drivers/usb/host/ohci-dbg.c
+++ b/drivers/usb/host/ohci-dbg.c
@@ -731,7 +731,7 @@ static int debug_close(struct inode *inode, struct file *file)
 
 	if (buf) {
 		if (buf->page)
-			free_page((unsigned long)buf->page);
+			free_page(buf->page);
 		kfree(buf);
 	}
 
diff --git a/drivers/usb/mon/mon_bin.c b/drivers/usb/mon/mon_bin.c
index ba3589e4edf7..3ac8eb70f0eb 100644
--- a/drivers/usb/mon/mon_bin.c
+++ b/drivers/usb/mon/mon_bin.c
@@ -1344,7 +1344,7 @@ static int mon_alloc_buff(struct mon_pgmap *map, int npages)
 		vaddr = (unsigned long)get_zeroed_page(GFP_KERNEL);
 		if (vaddr == 0) {
 			while (n-- != 0)
-				free_page((unsigned long) map[n].ptr);
+				free_page(map[n].ptr);
 			return -ENOMEM;
 		}
 		map[n].ptr = (unsigned char *) vaddr;
@@ -1358,7 +1358,7 @@ static void mon_free_buff(struct mon_pgmap *map, int npages)
 	int n;
 
 	for (n = 0; n < npages; n++)
-		free_page((unsigned long) map[n].ptr);
+		free_page(map[n].ptr);
 }
 
 int mon_bin_add(struct mon_bus *mbus, const struct usb_bus *ubus)
diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
index 0f9b26c5d62d..f0b228f73dd1 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -493,7 +493,7 @@ int usb_wwan_port_probe(struct usb_serial_port *port)
 bail_out_error:
 	for (i = 0; i < N_IN_URB; i++) {
 		usb_free_urb(portdata->in_urbs[i]);
-		free_page((unsigned long)portdata->in_buffer[i]);
+		free_page(portdata->in_buffer[i]);
 	}
 	kfree(portdata);
 
@@ -511,7 +511,7 @@ void usb_wwan_port_remove(struct usb_serial_port *port)
 
 	for (i = 0; i < N_IN_URB; i++) {
 		usb_free_urb(portdata->in_urbs[i]);
-		free_page((unsigned long)portdata->in_buffer[i]);
+		free_page(portdata->in_buffer[i]);
 	}
 	for (i = 0; i < N_OUT_URB; i++) {
 		usb_free_urb(portdata->out_urbs[i]);
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index aeedb079bb88..f8d5bdc7a13f 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -527,7 +527,7 @@ static void vfio_batch_unpin(struct vfio_batch *batch, struct vfio_dma *dma)
 static void vfio_batch_fini(struct vfio_batch *batch)
 {
 	if (batch->capacity == VFIO_BATCH_MAX_CAPACITY)
-		free_page((unsigned long)batch->pages);
+		free_page(batch->pages);
 }
 
 static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 1f27861d36b2..75e1670864e8 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -1210,7 +1210,7 @@ static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
 unlock:
 	mmap_read_unlock(dev->mm);
 free:
-	free_page((unsigned long)page_list);
+	free_page(page_list);
 	return ret;
 
 }
diff --git a/drivers/video/fbdev/xen-fbfront.c b/drivers/video/fbdev/xen-fbfront.c
index d55b6de455e6..60d42036684f 100644
--- a/drivers/video/fbdev/xen-fbfront.c
+++ b/drivers/video/fbdev/xen-fbfront.c
@@ -514,7 +514,7 @@ static void xenfb_remove(struct xenbus_device *dev)
 		fb_dealloc_cmap(&info->fb_info->cmap);
 		framebuffer_release(info->fb_info);
 	}
-	free_page((unsigned long)info->page);
+	free_page(info->page);
 	vfree(info->gfns);
 	vfree(info->fb);
 	kfree(info);
diff --git a/drivers/virt/vboxguest/vboxguest_utils.c b/drivers/virt/vboxguest/vboxguest_utils.c
index 96f1fb596d78..10f5e96b0a62 100644
--- a/drivers/virt/vboxguest/vboxguest_utils.c
+++ b/drivers/virt/vboxguest/vboxguest_utils.c
@@ -91,7 +91,7 @@ void vbg_req_free(void *req, size_t len)
 	if (!req)
 		return;
 
-	free_pages((unsigned long)req, get_order(PAGE_ALIGN(len)));
+	free_pages(req, get_order(PAGE_ALIGN(len)));
 }
 
 /* Note this function returns a VBox status code, not a negative errno!! */
diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index 4c77a638d906..1e3b2c12e92d 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -240,7 +240,7 @@ static int set_evtchn_to_irq(evtchn_port_t evtchn, unsigned int irq)
 		 * thread was faster inserting it, we can drop ours.
 		 */
 		if (cmpxchg(&evtchn_to_irq[row], NULL, evtchn_row) != NULL)
-			free_page((unsigned long) evtchn_row);
+			free_page(evtchn_row);
 	}
 
 	WRITE_ONCE(evtchn_to_irq[row][col], irq);
@@ -2324,7 +2324,7 @@ void __init xen_init_IRQ(void)
 		eoi_gmfn.gmfn = virt_to_gfn(pirq_eoi_map);
 		rc = HYPERVISOR_physdev_op(PHYSDEVOP_pirq_eoi_gmfn_v2, &eoi_gmfn);
 		if (rc != 0) {
-			free_page((unsigned long) pirq_eoi_map);
+			free_page(pirq_eoi_map);
 			pirq_eoi_map = NULL;
 		} else
 			pirq_needs_eoi = pirq_check_eoi_map;
diff --git a/drivers/xen/events/events_fifo.c b/drivers/xen/events/events_fifo.c
index 1aa276ad7be7..0c032ea1b0c6 100644
--- a/drivers/xen/events/events_fifo.c
+++ b/drivers/xen/events/events_fifo.c
@@ -125,7 +125,7 @@ static void free_unused_array_pages(void)
 	for (i = event_array_pages; i < MAX_EVENT_ARRAY_PAGES; i++) {
 		if (!event_array[i])
 			break;
-		free_page((unsigned long)event_array[i]);
+		free_page(event_array[i]);
 		event_array[i] = NULL;
 	}
 }
@@ -355,7 +355,7 @@ static void evtchn_fifo_resume(void)
 		 * used.
 		 */
 		if (!cpu_online(cpu)) {
-			free_page((unsigned long)control_block);
+			free_page(control_block);
 			per_cpu(cpu_control_block, cpu) = NULL;
 			continue;
 		}
@@ -390,7 +390,7 @@ static int evtchn_fifo_alloc_control_block(unsigned cpu)
 	return 0;
 
   error:
-	free_page((unsigned long)control_block);
+	free_page(control_block);
 	return ret;
 }
 
diff --git a/drivers/xen/evtchn.c b/drivers/xen/evtchn.c
index 630a05e14562..2468e475d1d3 100644
--- a/drivers/xen/evtchn.c
+++ b/drivers/xen/evtchn.c
@@ -311,7 +311,7 @@ static ssize_t evtchn_write(struct file *file, const char __user *buf,
 	rc = count;
 
  out:
-	free_page((unsigned long)kbuf);
+	free_page(kbuf);
 	return rc;
 }
 
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index fd9d6336017b..41aa0241420e 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -782,7 +782,7 @@ static int grow_gnttab_list(unsigned int more_frames)
 
 grow_nomem:
 	while (i-- > nr_glist_frames)
-		free_page((unsigned long) gnttab_list[i]);
+		free_page(gnttab_list[i]);
 	return -ENOMEM;
 }
 
@@ -1676,7 +1676,7 @@ int gnttab_init(void)
 
  ini_nomem:
 	for (i--; i >= 0; i--)
-		free_page((unsigned long)gnttab_list[i]);
+		free_page(gnttab_list[i]);
 	kfree(gnttab_list);
 	bitmap_free(gnttab_free_bitmap);
 	return ret;
diff --git a/drivers/xen/pvcalls-front.c b/drivers/xen/pvcalls-front.c
index 63a7b9230c51..8dbf4be17e15 100644
--- a/drivers/xen/pvcalls-front.c
+++ b/drivers/xen/pvcalls-front.c
@@ -350,7 +350,7 @@ static void free_active_ring(struct sock_mapping *map)
 
 	free_pages_exact(map->active.data.in,
 			 PAGE_SIZE << map->active.ring->ring_order);
-	free_page((unsigned long)map->active.ring);
+	free_page(map->active.ring);
 }
 
 static int alloc_active_ring(struct sock_mapping *map)
diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index e03bae63488b..29918b5d9bf2 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -170,7 +170,7 @@ xen_swiotlb_alloc_coherent(struct device *dev, size_t size,
 	return ret;
 
 out_free_pages:
-	free_pages((unsigned long)ret, get_order(size));
+	free_pages(ret, get_order(size));
 	return NULL;
 }
 
@@ -191,7 +191,7 @@ xen_swiotlb_free_coherent(struct device *dev, size_t size, void *vaddr,
 
 	if (TestClearPageXenRemapped(virt_to_page(vaddr)))
 		xen_destroy_contiguous_region(phys, order);
-	free_pages((unsigned long)vaddr, get_order(size));
+	free_pages(vaddr, get_order(size));
 }
 #endif /* CONFIG_X86 */
 
diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 1544fbf30acd..95540d3285f9 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -909,7 +909,7 @@ static int __init xenstored_local_init(void)
 
  out_err:
 	if (page != 0)
-		free_page(page);
+		free_page((void *)page);
 	return err;
 }
 
diff --git a/fs/affs/inode.c b/fs/affs/inode.c
index 0210df8d3500..47b03880b49d 100644
--- a/fs/affs/inode.c
+++ b/fs/affs/inode.c
@@ -277,7 +277,7 @@ affs_evict_inode(struct inode *inode)
 		pr_debug("freeing ext cache\n");
 		AFFS_I(inode)->i_lc = NULL;
 		AFFS_I(inode)->i_ac = NULL;
-		free_page(cache_page);
+		free_page((void *)cache_page);
 	}
 	affs_brelse(AFFS_I(inode)->i_ext_bh);
 	AFFS_I(inode)->i_ext_last = ~1;
diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index d975b557a335..88a3ee7aab42 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -302,7 +302,7 @@ void bfs_dump_imap(const char *prefix, struct super_block *s)
 			strcat(tmpbuf, "0");
 	}
 	printf("%s: lasti=%08lx <%s>\n", prefix, BFS_SB(s)->si_lasti, tmpbuf);
-	free_page((unsigned long)tmpbuf);
+	free_page(tmpbuf);
 #endif
 }
 
diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index e9bc76fd6ce8..1af3733eb401 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -711,7 +711,7 @@ bm_entry_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 
 	res = simple_read_from_buffer(buf, nbytes, ppos, page, strlen(page));
 
-	free_page((unsigned long) page);
+	free_page(page);
 	return res;
 }
 
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 8db0c4a826b0..9af200927d65 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -810,7 +810,7 @@ static void destroy_reply_info(struct ceph_mds_reply_info_parsed *info)
 		kfree(rde->inode.fscrypt_auth);
 		kfree(rde->inode.fscrypt_file);
 	}
-	free_pages((unsigned long)info->dir_entries, get_order(info->dir_buf_size));
+	free_pages(info->dir_entries, get_order(info->dir_buf_size));
 }
 
 /*
diff --git a/fs/configfs/file.c b/fs/configfs/file.c
index 7a138b3dbe81..7af570a58472 100644
--- a/fs/configfs/file.c
+++ b/fs/configfs/file.c
@@ -382,7 +382,7 @@ static int configfs_release(struct inode *inode, struct file *filp)
 
 	module_put(buffer->owner);
 	if (buffer->page)
-		free_page((unsigned long)buffer->page);
+		free_page(buffer->page);
 	mutex_destroy(&buffer->mutex);
 	kfree(buffer);
 	return 0;
diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index 69536cacdea8..45b5cbd2ce5b 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -1169,7 +1169,7 @@ int ecryptfs_write_metadata(struct dentry *ecryptfs_dentry,
 		goto out_free;
 	}
 out_free:
-	free_pages((unsigned long)virt, order);
+	free_pages(virt, order);
 out:
 	return rc;
 }
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 5b8332d441fd..c502ac50e7c7 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4236,7 +4236,7 @@ int ext4_calculate_overhead(struct super_block *sb)
 	}
 	sbi->s_overhead = overhead;
 	smp_wmb();
-	free_page((unsigned long) buf);
+	free_page(buf);
 	return 0;
 }
 
diff --git a/fs/fuse/ioctl.c b/fs/fuse/ioctl.c
index b97b6ee8e6a1..4b240f77a6b8 100644
--- a/fs/fuse/ioctl.c
+++ b/fs/fuse/ioctl.c
@@ -400,7 +400,7 @@ long fuse_do_ioctl(struct file *file, unsigned int cmd, unsigned long arg,
 	}
 	err = 0;
  out:
-	free_page((unsigned long) iov_page);
+	free_page(iov_page);
 	while (ap.num_folios)
 		folio_put(ap.folios[--ap.num_folios]);
 	kfree(ap.folios);
diff --git a/fs/isofs/dir.c b/fs/isofs/dir.c
index d19478110d2e..dbb38cb41c9e 100644
--- a/fs/isofs/dir.c
+++ b/fs/isofs/dir.c
@@ -262,7 +262,7 @@ static int isofs_readdir(struct file *file, struct dir_context *ctx)
 
 	result = do_isofs_readdir(inode, file, ctx, tmpname, tmpde);
 
-	free_page((unsigned long) tmpname);
+	free_page(tmpname);
 	return result;
 }
 
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 7a6e31231a3b..60a5f5cc8631 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2781,7 +2781,7 @@ void jbd2_free(void *ptr, size_t size)
 	if (size < PAGE_SIZE)
 		kmem_cache_free(get_slab(size), ptr);
 	else
-		free_pages((unsigned long)ptr, get_order(size));
+		free_pages(ptr, get_order(size));
 };
 
 /*
diff --git a/fs/jfs/jfs_dtree.c b/fs/jfs/jfs_dtree.c
index e85b0490d1e4..53e9dca248dd 100644
--- a/fs/jfs/jfs_dtree.c
+++ b/fs/jfs/jfs_dtree.c
@@ -2906,7 +2906,7 @@ int jfs_readdir(struct file *file, struct dir_context *ctx)
 			if (stbl[i] < 0 || stbl[i] >= DTPAGEMAXSLOT) {
 				jfs_err("JFS: Invalid stbl[%d] = %d for inode %ld, block = %lld",
 					i, stbl[i], (long)ip->i_ino, (long long)bn);
-				free_page(dirent_buf);
+				free_page((void *)dirent_buf);
 				DT_PUTPAGE(mp);
 				return -EIO;
 			}
@@ -3040,13 +3040,13 @@ int jfs_readdir(struct file *file, struct dir_context *ctx)
 
 		DT_GETPAGE(ip, bn, mp, PSIZE, p, rc);
 		if (rc) {
-			free_page(dirent_buf);
+			free_page((void *)dirent_buf);
 			return rc;
 		}
 	}
 
       out:
-	free_page(dirent_buf);
+	free_page((void *)dirent_buf);
 
 	return rc;
 }
diff --git a/fs/libfs.c b/fs/libfs.c
index f26c7ca71536..a3e835bf44a9 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -1247,7 +1247,7 @@ char *simple_transaction_get(struct file *file, const char __user *buf, size_t s
 	/* only one write allowed per open */
 	if (file->private_data) {
 		spin_unlock(&simple_transaction_lock);
-		free_page((unsigned long)ar);
+		free_page(ar);
 		return ERR_PTR(-EBUSY);
 	}
 
@@ -1274,7 +1274,7 @@ EXPORT_SYMBOL(simple_transaction_read);
 
 int simple_transaction_release(struct inode *inode, struct file *file)
 {
-	free_page((unsigned long)file->private_data);
+	free_page(file->private_data);
 	return 0;
 }
 EXPORT_SYMBOL(simple_transaction_release);
diff --git a/fs/namespace.c b/fs/namespace.c
index a6cc3c494a0b..7c56466fb1b6 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3198,7 +3198,7 @@ static void mnt_warn_timestamp_expiry(const struct path *mountpoint,
 
 		sb->s_iflags |= SB_I_TS_EXPIRY_WARNED;
 		if (buf)
-			free_page((unsigned long)buf);
+			free_page(buf);
 	}
 }
 
diff --git a/fs/nfs/nfs4namespace.c b/fs/nfs/nfs4namespace.c
index bca963fd6915..6e4b84939411 100644
--- a/fs/nfs/nfs4namespace.c
+++ b/fs/nfs/nfs4namespace.c
@@ -571,7 +571,7 @@ int nfs4_replace_transport(struct nfs_server *server,
 	}
 
 out:
-	free_page((unsigned long)page);
-	free_page((unsigned long)page2);
+	free_page(page);
+	free_page(page2);
 	return error;
 }
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index eea5802c11ca..4ef69a80a1ef 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -651,7 +651,7 @@ int nfs_show_devname(struct seq_file *m, struct dentry *root)
 		err = PTR_ERR(devname);
 	else
 		seq_escape(m, devname, " \t\n\\");
-	free_page((unsigned long)page);
+	free_page(page);
 	return err;
 }
 EXPORT_SYMBOL_GPL(nfs_show_devname);
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 888d95a33eb2..7c88d4df7cfe 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -2246,7 +2246,7 @@ static __be32 nfsd_buffered_readdir(struct file *file, struct svc_fh *fhp,
 		offset = vfs_llseek(file, 0, SEEK_CUR);
 	}
 
-	free_page((unsigned long)(buf.dirent));
+	free_page(buf.dirent);
 
 	if (host_err)
 		return nfserrno(host_err);
diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 615add8c29b2..d95a34c6d12f 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -107,7 +107,7 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
 	}
 	argv->v_nmembs = total;
 
-	free_pages((unsigned long)buf, 0);
+	free_pages(buf, 0);
 	return ret;
 }
 
diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
index 6eeb50df5cd1..7f688aeb3d70 100644
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -263,7 +263,7 @@ void dlm_print_one_mle(struct dlm_master_list_entry *mle)
 	buf = get_zeroed_page(GFP_ATOMIC);
 	if (buf) {
 		dump_mle(mle, buf, PAGE_SIZE - 1);
-		free_page((unsigned long)buf);
+		free_page(buf);
 	}
 }
 
@@ -280,7 +280,7 @@ static struct dentry *dlm_debugfs_root;
 /* begin - utils funcs */
 static int debug_release(struct inode *inode, struct file *file)
 {
-	free_page((unsigned long)file->private_data);
+	free_page(file->private_data);
 	return 0;
 }
 
diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 0f7c6022ca20..302ce83d3d1a 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -63,7 +63,7 @@ static inline void byte_copymap(u8 dmap[], unsigned long smap[],
 static void dlm_free_pagevec(void **vec, int pages)
 {
 	while (pages--)
-		free_page((unsigned long)vec[pages]);
+		free_page(vec[pages]);
 	kfree(vec);
 }
 
diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 920268eb868f..e3c967660c91 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -2727,7 +2727,7 @@ static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
 		wake_up(&res->wq);
 
 	if (mres)
-		free_page((unsigned long)mres);
+		free_page(mres);
 
 	dlm_put(dlm);
 
diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index b7b18b318558..52c972cae16b 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -933,7 +933,7 @@ static void dlm_request_all_locks_worker(struct dlm_work_item *item, void *data)
 		}
 	}
 leave:
-	free_page((unsigned long)data);
+	free_page(data);
 }
 
 
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 6bda8b411a17..40a2de383fee 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -284,7 +284,7 @@ static ssize_t get_mm_proctitle(struct mm_struct *mm, char __user *buf,
 			ret = len;
 		}
 	}
-	free_page((unsigned long)page);
+	free_page(page);
 	return ret;
 }
 
@@ -371,7 +371,7 @@ static ssize_t get_mm_cmdline(struct mm_struct *mm, char __user *buf,
 		count -= got;
 	}
 
-	free_page((unsigned long)page);
+	free_page(page);
 	return len;
 }
 
@@ -949,7 +949,7 @@ static ssize_t mem_rw(struct file *file, char __user *buf,
 
 	mmput(mm);
 free:
-	free_page((unsigned long) page);
+	free_page(page);
 	return copied;
 }
 
@@ -1062,7 +1062,7 @@ static ssize_t environ_read(struct file *file, char __user *buf,
 	mmput(mm);
 
 free:
-	free_page((unsigned long) page);
+	free_page(page);
 	return ret;
 }
 
diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index b578b210f764..048452f31ffe 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -1204,7 +1204,7 @@ static void set_vmcore_list_offsets(size_t elfsz, size_t elfnotes_sz,
 
 static void free_elfcorebuf(void)
 {
-	free_pages((unsigned long)elfcorebuf, get_order(elfcorebuf_sz_orig));
+	free_pages(elfcorebuf, get_order(elfcorebuf_sz_orig));
 	elfcorebuf = NULL;
 	vfree(elfnotes_buf);
 	elfnotes_buf = NULL;
@@ -1556,7 +1556,7 @@ static int vmcore_realloc_elfcore_buffer_elf64(size_t new_size)
 	if (!elfcorebuf_new)
 		return -ENOMEM;
 	memcpy(elfcorebuf_new, elfcorebuf, elfcorebuf_sz);
-	free_pages((unsigned long)elfcorebuf, get_order(elfcorebuf_sz_orig));
+	free_pages(elfcorebuf, get_order(elfcorebuf_sz_orig));
 	elfcorebuf = elfcorebuf_new;
 	elfcorebuf_sz_orig = new_size;
 	return 0;
diff --git a/fs/select.c b/fs/select.c
index 0ad836c747c8..6acb773f405a 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -150,7 +150,7 @@ void poll_freewait(struct poll_wqueues *pwq)
 		} while (entry > p->entries);
 		old = p;
 		p = p->next;
-		free_page((unsigned long) old);
+		free_page(old);
 	}
 }
 EXPORT_SYMBOL(poll_freewait);
diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 70478999731d..ffdd1500420f 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -380,12 +380,12 @@ __meminit void *alloc_pages_exact_nid_noprof(int nid, size_t size, gfp_t gfp_mas
 
 extern void __free_pages(struct page *page, unsigned int order);
 extern void free_pages_nolock(struct page *page, unsigned int order);
-extern void free_pages(unsigned long addr, unsigned int order);
+extern void free_pages(void *addr, unsigned int order);
 
 #define __free_page(page) __free_pages((page), 0)
 #define free_page(addr) free_pages((addr), 0)
 
-DEFINE_FREE(free_page, unsigned long, if (!IS_ERR_OR_NULL(_T)) free_page(_T));
+DEFINE_FREE(free_page, void *, if (!IS_ERR_OR_NULL(_T)) free_page(_T));
 
 void page_alloc_init_cpuhp(void);
 bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp);
diff --git a/init/do_mounts.c b/init/do_mounts.c
index ba7046b92099..13889ec6b59b 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -366,7 +366,7 @@ static int __init mount_nodev_root(char *root_device_name)
 			break;
 	}
 
-	free_page((unsigned long)fs_names);
+	free_page(fs_names);
 	return err;
 }
 
diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 63c2cdce0b2d..e062baa22760 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -480,7 +480,7 @@ int swiotlb_init_late(size_t size, gfp_t gfp_mask,
 	if (remap)
 		rc = remap(vstart, nslabs);
 	if (rc) {
-		free_pages((unsigned long)vstart, order);
+		free_pages(vstart, order);
 
 		nslabs = ALIGN(nslabs >> 1, IO_TLB_SEGSIZE);
 		if (nslabs < IO_TLB_MIN_SLABS)
@@ -516,9 +516,9 @@ int swiotlb_init_late(size_t size, gfp_t gfp_mask,
 	return 0;
 
 error_slots:
-	free_pages((unsigned long)mem->areas, area_order);
+	free_pages(mem->areas, area_order);
 error_area:
-	free_pages((unsigned long)vstart, order);
+	free_pages(vstart, order);
 	return -ENOMEM;
 }
 
@@ -544,9 +544,9 @@ void __init swiotlb_exit(void)
 	if (mem->late_alloc) {
 		area_order = get_order(array_size(sizeof(*mem->areas),
 			mem->nareas));
-		free_pages((unsigned long)mem->areas, area_order);
-		free_pages(tbl_vaddr, get_order(tbl_size));
-		free_pages((unsigned long)mem->slots, get_order(slots_size));
+		free_pages(mem->areas, area_order);
+		free_pages((void *)tbl_vaddr, get_order(tbl_size));
+		free_pages(mem->slots, get_order(slots_size));
 	} else {
 		memblock_free_late(__pa(mem->areas),
 			array_size(sizeof(*mem->areas), mem->nareas));
@@ -757,7 +757,7 @@ static void swiotlb_dyn_free(struct rcu_head *rcu)
 	size_t slots_size = array_size(sizeof(*pool->slots), pool->nslabs);
 	size_t tlb_size = pool->end - pool->start;
 
-	free_pages((unsigned long)pool->slots, get_order(slots_size));
+	free_pages(pool->slots, get_order(slots_size));
 	swiotlb_free_tlb(pool->vaddr, tlb_size);
 	kfree(pool);
 }
diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index 77940089ef31..f502a0352f56 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -858,7 +858,7 @@ static struct kho_vmalloc_chunk *new_vmalloc_chunk(struct kho_vmalloc_chunk *cur
 	return chunk;
 
 err_free:
-	free_page((unsigned long)chunk);
+	free_page(chunk);
 	return NULL;
 }
 
@@ -885,7 +885,7 @@ static void kho_vmalloc_free_chunks(struct kho_vmalloc *kho_vmalloc)
 		kho_vmalloc_unpreserve_chunk(chunk);
 
 		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
-		free_page((unsigned long)tmp);
+		free_page(tmp);
 	}
 }
 
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 6b662c687cef..d0f6a382ad66 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -400,7 +400,7 @@ static int write_page(void *buf, sector_t offset, struct hib_bio_batch *hb)
 static void release_swap_writer(struct swap_map_handle *handle)
 {
 	if (handle->cur)
-		free_page((unsigned long)handle->cur);
+		free_page(handle->cur);
 	handle->cur = NULL;
 }
 
@@ -899,7 +899,7 @@ static int save_compressed_image(struct swap_map_handle *handle,
 		}
 		vfree(data);
 	}
-	if (page) free_page((unsigned long)page);
+	if (page) free_page(page);
 
 	return ret;
 }
@@ -984,7 +984,7 @@ static void release_swap_reader(struct swap_map_handle *handle)
 
 	while (handle->maps) {
 		if (handle->maps->map)
-			free_page((unsigned long)handle->maps->map);
+			free_page(handle->maps->map);
 		tmp = handle->maps;
 		handle->maps = handle->maps->next;
 		kfree(tmp);
@@ -1058,7 +1058,7 @@ static int swap_read_page(struct swap_map_handle *handle, void *buf,
 		return error;
 	if (++handle->k >= MAP_PAGE_ENTRIES) {
 		handle->k = 0;
-		free_page((unsigned long)handle->maps->map);
+		free_page(handle->maps->map);
 		tmp = handle->maps;
 		handle->maps = handle->maps->next;
 		kfree(tmp);
@@ -1505,7 +1505,7 @@ static int load_compressed_image(struct swap_map_handle *handle,
 out_clean:
 	hib_finish_batch(&hb);
 	for (i = 0; i < ring_size; i++)
-		free_page((unsigned long)page[i]);
+		free_page(page[i]);
 	if (crc) {
 		if (crc->thr)
 			kthread_stop(crc->thr);
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 68e2b4da569e..477aa903e5e2 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -651,7 +651,7 @@ static int ftrace_profile_pages_init(struct ftrace_profile_stat *stat)
 		unsigned long tmp = (unsigned long)pg;
 
 		pg = pg->next;
-		free_page(tmp);
+		free_page((void *)tmp);
 	}
 
 	stat->pages = NULL;
@@ -3837,7 +3837,7 @@ static void ftrace_free_pages(struct ftrace_page *pages)
 
 	while (pg) {
 		if (pg->records) {
-			free_pages((unsigned long)pg->records, pg->order);
+			free_pages(pg->records, pg->order);
 			ftrace_number_of_pages -= 1 << pg->order;
 		}
 		pages = pg->next;
@@ -7489,7 +7489,7 @@ void ftrace_release_mod(struct module *mod)
 		clear_mod_from_hashes(pg);
 
 		if (pg->records) {
-			free_pages((unsigned long)pg->records, pg->order);
+			free_pages(pg->records, pg->order);
 			ftrace_number_of_pages -= 1 << pg->order;
 		}
 		tmp_page = pg->next;
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 1244d2c5c384..9dfcb0f5b7b5 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -397,7 +397,7 @@ static void free_buffer_page(struct buffer_page *bpage)
 {
 	/* Range pages are not to be freed */
 	if (!bpage->range)
-		free_pages((unsigned long)bpage->page, bpage->order);
+		free_pages(bpage->page, bpage->order);
 	kfree(bpage);
 }
 
@@ -2444,7 +2444,7 @@ static void rb_free_cpu_buffer(struct ring_buffer_per_cpu *cpu_buffer)
 		free_buffer_page(bpage);
 	}
 
-	free_page((unsigned long)cpu_buffer->free_page);
+	free_page(cpu_buffer->free_page);
 
 	kfree(cpu_buffer);
 }
@@ -6547,7 +6547,7 @@ void ring_buffer_free_read_page(struct trace_buffer *buffer, int cpu,
 	local_irq_restore(flags);
 
  out:
-	free_pages((unsigned long)bpage, data_page->order);
+	free_pages(bpage, data_page->order);
 	kfree(data_page);
 }
 EXPORT_SYMBOL_GPL(ring_buffer_free_read_page);
@@ -6944,7 +6944,7 @@ int ring_buffer_subbuf_order_set(struct trace_buffer *buffer, int order)
 			list_del_init(&bpage->list);
 			free_buffer_page(bpage);
 		}
-		free_pages((unsigned long)old_free_data_page, old_order);
+		free_pages(old_free_data_page, old_order);
 
 		rb_check_pages(cpu_buffer);
 	}
@@ -6995,7 +6995,7 @@ static void rb_free_meta_page(struct ring_buffer_per_cpu *cpu_buffer)
 {
 	unsigned long addr = (unsigned long)cpu_buffer->meta_page;
 
-	free_page(addr);
+	free_page((void *)addr);
 	cpu_buffer->meta_page = NULL;
 }
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index d1e527cf2aae..edc6f6661ee2 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2710,7 +2710,7 @@ void trace_buffered_event_disable(void)
 	synchronize_rcu();
 
 	for_each_tracing_cpu(cpu) {
-		free_page((unsigned long)per_cpu(trace_buffered_event, cpu));
+		free_page(per_cpu(trace_buffered_event, cpu));
 		per_cpu(trace_buffered_event, cpu) = NULL;
 	}
 
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index c46d584ded3b..621dc0b846bb 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -195,7 +195,7 @@ static void free_saved_cmdlines_buffer(struct saved_cmdlines_buffer *s)
 	int order = get_order(sizeof(*s) + s->cmdline_num * TASK_COMM_LEN);
 
 	kmemleak_free(s);
-	free_pages((unsigned long)s, order);
+	free_pages(s, order);
 }
 
 static struct saved_cmdlines_buffer *allocate_cmdlines_buffer(unsigned int val)
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 430d09c49462..815296311f04 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -919,7 +919,7 @@ static int uprobe_buffer_init(void)
 	for_each_possible_cpu(cpu) {
 		if (cpu == err_cpu)
 			break;
-		free_page((unsigned long)per_cpu_ptr(uprobe_cpu_buffer, cpu)->buf);
+		free_page(per_cpu_ptr(uprobe_cpu_buffer, cpu)->buf);
 	}
 
 	free_percpu(uprobe_cpu_buffer);
@@ -949,8 +949,7 @@ static void uprobe_buffer_disable(void)
 
 	if (--uprobe_buffer_refcnt == 0) {
 		for_each_possible_cpu(cpu)
-			free_page((unsigned long)per_cpu_ptr(uprobe_cpu_buffer,
-							     cpu)->buf);
+			free_page(per_cpu_ptr(uprobe_cpu_buffer, cpu)->buf);
 
 		free_percpu(uprobe_cpu_buffer);
 		uprobe_cpu_buffer = NULL;
diff --git a/kernel/trace/tracing_map.c b/kernel/trace/tracing_map.c
index 91ac1bef8525..5d2a7db6a4af 100644
--- a/kernel/trace/tracing_map.c
+++ b/kernel/trace/tracing_map.c
@@ -309,7 +309,7 @@ static void tracing_map_array_free(struct tracing_map_array *a)
 		if (!a->pages[i])
 			break;
 		kmemleak_free(a->pages[i]);
-		free_page((unsigned long)a->pages[i]);
+		free_page(a->pages[i]);
 	}
 
 	kfree(a->pages);
diff --git a/kernel/vmcore_info.c b/kernel/vmcore_info.c
index 69a8140fb9ed..dfe6857b6ec5 100644
--- a/kernel/vmcore_info.c
+++ b/kernel/vmcore_info.c
@@ -129,7 +129,7 @@ static int __init crash_save_vmcoreinfo_init(void)
 	vmcoreinfo_note = alloc_pages_exact(VMCOREINFO_NOTE_SIZE,
 						GFP_KERNEL | __GFP_ZERO);
 	if (!vmcoreinfo_note) {
-		free_page((unsigned long)vmcoreinfo_data);
+		free_page(vmcoreinfo_data);
 		vmcoreinfo_data = NULL;
 		pr_warn("Memory allocation for vmcoreinfo_note failed\n");
 		return -ENOMEM;
diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
index b5d15493fce8..41f53385f52e 100644
--- a/lib/raid6/algos.c
+++ b/lib/raid6/algos.c
@@ -275,7 +275,7 @@ int __init raid6_select_algo(void)
 	/* select raid recover functions */
 	rec_best = raid6_choose_recov();
 
-	free_pages((unsigned long)disk_ptr, RAID6_TEST_DISKS_ORDER);
+	free_pages(disk_ptr, RAID6_TEST_DISKS_ORDER);
 
 	return gen_best && rec_best ? 0 : -EINVAL;
 }
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index 662cc64781f7..612bcd837fc7 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -150,7 +150,7 @@ static void sg_kfree(struct scatterlist *sg, unsigned int nents)
 {
 	if (nents == SG_MAX_SINGLE_ALLOC) {
 		kmemleak_free(sg);
-		free_page((unsigned long) sg);
+		free_page(sg);
 	} else
 		kfree(sg);
 }
diff --git a/lib/stackdepot.c b/lib/stackdepot.c
index de0b0025af2b..cdd840f0f257 100644
--- a/lib/stackdepot.c
+++ b/lib/stackdepot.c
@@ -724,7 +724,7 @@ depot_stack_handle_t stack_depot_save_flags(unsigned long *entries,
 		if (!allow_spin)
 			free_pages_nolock(virt_to_page(prealloc), DEPOT_POOL_ORDER);
 		else
-			free_pages((unsigned long)prealloc, DEPOT_POOL_ORDER);
+			free_pages(prealloc, DEPOT_POOL_ORDER);
 	}
 	if (found)
 		handle = found->handle.handle;
diff --git a/lib/test_free_pages.c b/lib/test_free_pages.c
index 3f265ea1c07c..4577557706a6 100644
--- a/lib/test_free_pages.c
+++ b/lib/test_free_pages.c
@@ -21,7 +21,7 @@ static void test_free_pages(gfp_t gfp)
 
 		/* Simulate page cache getting a speculative reference */
 		get_page(page);
-		free_pages(addr, 3);
+		free_pages((void *)addr, 3);
 		put_page(page);
 	}
 }
diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
index 2cafca31b092..67f3ad63e5be 100644
--- a/mm/kasan/kasan_test_c.c
+++ b/mm/kasan/kasan_test_c.c
@@ -359,7 +359,7 @@ static void page_alloc_oob_right(struct kunit *test)
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 
 	KUNIT_EXPECT_KASAN_FAIL_READ(test, ptr[0] = ptr[size]);
-	free_pages((unsigned long)ptr, order);
+	free_pages(ptr, order);
 }
 
 static void page_alloc_uaf(struct kunit *test)
@@ -371,7 +371,7 @@ static void page_alloc_uaf(struct kunit *test)
 	pages = alloc_pages(GFP_KERNEL, order);
 	ptr = page_address(pages);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
-	free_pages((unsigned long)ptr, order);
+	free_pages(ptr, order);
 
 	KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)ptr)[0]);
 }
@@ -1934,7 +1934,7 @@ static void vmap_tags(struct kunit *test)
 	KUNIT_EXPECT_PTR_EQ(test, p_page, v_page);
 
 	vunmap(v_ptr);
-	free_pages((unsigned long)p_ptr, 1);
+	free_pages(p_ptr, 1);
 }
 
 static void vm_map_ram_tags(struct kunit *test)
@@ -1964,7 +1964,7 @@ static void vm_map_ram_tags(struct kunit *test)
 	*v_ptr = 0;
 
 	vm_unmap_ram(v_ptr, 1);
-	free_pages((unsigned long)p_ptr, 1);
+	free_pages(p_ptr, 1);
 }
 
 /*
@@ -1996,7 +1996,7 @@ static void match_all_not_assigned(struct kunit *test)
 		KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 		KUNIT_EXPECT_GE(test, (u8)get_tag(ptr), (u8)KASAN_TAG_MIN);
 		KUNIT_EXPECT_LT(test, (u8)get_tag(ptr), (u8)KASAN_TAG_KERNEL);
-		free_pages((unsigned long)ptr, order);
+		free_pages(ptr, order);
 	}
 
 	if (!kasan_vmalloc_enabled())
diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
index 0496221a681a..df9bab2d2dcd 100644
--- a/mm/kasan/shadow.c
+++ b/mm/kasan/shadow.c
@@ -390,7 +390,7 @@ static int __kasan_populate_vmalloc_do(unsigned long start, unsigned long end, g
 		nr_total -= nr_pages;
 	}
 
-	free_page((unsigned long)data.pages);
+	free_page(data.pages);
 
 	return ret;
 }
diff --git a/mm/mincore.c b/mm/mincore.c
index c98bd87733e6..63b756b45017 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -325,6 +325,6 @@ SYSCALL_DEFINE3(mincore, unsigned long, start, size_t, len,
 		start += retval << PAGE_SHIFT;
 		retval = 0;
 	}
-	free_page((unsigned long) tmp);
+	free_page(tmp);
 	return retval;
 }
diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index ebca167aa674..e9dc44dcb063 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -156,7 +156,7 @@ static void tlb_batch_list_free(struct mmu_gather *tlb)
 
 	for (batch = tlb->local.next; batch; batch = next) {
 		next = batch->next;
-		free_pages((unsigned long)batch, 0);
+		free_pages(batch, 0);
 	}
 	tlb->local.next = NULL;
 }
@@ -226,7 +226,7 @@ static void __tlb_remove_table_free(struct mmu_table_batch *batch)
 	for (i = 0; i < batch->nr; i++)
 		__tlb_remove_table(batch->tables[i]);
 
-	free_page((unsigned long)batch);
+	free_page(batch);
 }
 
 #ifdef CONFIG_MMU_GATHER_RCU_TABLE_FREE
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d9e644650a33..9047d4df9e08 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5352,11 +5352,11 @@ void free_pages_nolock(struct page *page, unsigned int order)
  * to free pages when you only have a valid virtual address. If you have
  * the page, call __free_pages() instead.
  */
-void free_pages(unsigned long addr, unsigned int order)
+void free_pages(void *addr, unsigned int order)
 {
-	if (addr != 0) {
-		VM_BUG_ON(!virt_addr_valid((void *)addr));
-		__free_pages(virt_to_page((void *)addr), order);
+	if (addr != NULL) {
+		VM_BUG_ON(!virt_addr_valid(addr));
+		__free_pages(virt_to_page(addr), order);
 	}
 }
 
@@ -5439,18 +5439,17 @@ void * __meminit alloc_pages_exact_nid_noprof(int nid, size_t size, gfp_t gfp_ma
 
 /**
  * free_pages_exact - release memory allocated via alloc_pages_exact()
- * @virt: the value returned by alloc_pages_exact.
+ * @addr: the value returned by alloc_pages_exact.
  * @size: size of allocation, same value as passed to alloc_pages_exact().
  *
  * Release the memory allocated by a previous call to alloc_pages_exact.
  */
-void free_pages_exact(void *virt, size_t size)
+void free_pages_exact(void *addr, size_t size)
 {
-	unsigned long addr = (unsigned long)virt;
-	unsigned long end = addr + PAGE_ALIGN(size);
+	void *end = addr + PAGE_ALIGN(size);
 
 	while (addr < end) {
-		free_page(addr);
+		free_page((void *)addr);
 		addr += PAGE_SIZE;
 	}
 }
diff --git a/mm/slab_common.c b/mm/slab_common.c
index cf5ab534b689..ffca2db25e01 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1497,7 +1497,7 @@ drain_page_cache(struct kfree_rcu_cpu *krcp)
 	raw_spin_unlock_irqrestore(&krcp->lock, flags);
 
 	llist_for_each_safe(pos, n, page_list) {
-		free_page((unsigned long)pos);
+		free_page(pos);
 		freed++;
 	}
 
@@ -1537,7 +1537,7 @@ kvfree_rcu_bulk(struct kfree_rcu_cpu *krcp,
 	raw_spin_unlock_irqrestore(&krcp->lock, flags);
 
 	if (bnode)
-		free_page((unsigned long) bnode);
+		free_page(bnode);
 
 	cond_resched_tasks_rcu_qs();
 }
@@ -1839,7 +1839,7 @@ static void fill_page_cache_func(struct work_struct *work)
 		raw_spin_unlock_irqrestore(&krcp->lock, flags);
 
 		if (!pushed) {
-			free_page((unsigned long) bnode);
+			free_page(bnode);
 			break;
 		}
 	}
diff --git a/mm/slub.c b/mm/slub.c
index 4b5fbce09a44..1f9b3c03d837 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -8757,8 +8757,8 @@ static struct dentry *slab_debugfs_root;
 static void free_loc_track(struct loc_track *t)
 {
 	if (t->max)
-		free_pages((unsigned long)t->loc,
-			get_order(sizeof(struct location) * t->max));
+		free_pages(t->loc,
+		           get_order(sizeof(struct location) * t->max));
 }
 
 static int alloc_loc_track(struct loc_track *t, unsigned long max, gfp_t flags)
diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index 45e7030598b1..837b8f2129bc 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -301,7 +301,7 @@ static void xen_9pfs_front_free(struct xen_9pfs_front_priv *priv)
 					   XEN_PAGE_SHIFT));
 		}
 		gnttab_end_foreign_access(priv->rings[i].ref, NULL);
-		free_page((unsigned long)priv->rings[i].intf);
+		free_page(priv->rings[i].intf);
 	}
 	kfree(priv->rings);
 	kfree(priv->tag);
@@ -371,7 +371,7 @@ static int xen_9pfs_front_alloc_dataring(struct xenbus_device *dev,
 		free_pages_exact(bytes, 1UL << (order + XEN_PAGE_SHIFT));
 	}
 	gnttab_end_foreign_access(ring->ref, NULL);
-	free_page((unsigned long)ring->intf);
+	free_page(ring->intf);
 	return ret;
 }
 
diff --git a/net/atm/mpoa_proc.c b/net/atm/mpoa_proc.c
index 5d6841f87f19..a7e4027ed615 100644
--- a/net/atm/mpoa_proc.c
+++ b/net/atm/mpoa_proc.c
@@ -221,7 +221,7 @@ static ssize_t proc_mpc_write(struct file *file, const char __user *buff,
 
 	for (p = page, len = 0; len < nbytes; p++) {
 		if (get_user(*p, buff++)) {
-			free_page((unsigned long)page);
+			free_page(page);
 			return -EFAULT;
 		}
 		len += 1;
@@ -234,7 +234,7 @@ static ssize_t proc_mpc_write(struct file *file, const char __user *buff,
 	if (!parse_qos(page))
 		printk("mpoa: proc_mpc_write: could not parse '%s'\n", page);
 
-	free_page((unsigned long)page);
+	free_page(page);
 
 	return len;
 }
diff --git a/net/atm/proc.c b/net/atm/proc.c
index ba3e2deb05af..6c4c78902580 100644
--- a/net/atm/proc.c
+++ b/net/atm/proc.c
@@ -337,7 +337,7 @@ static ssize_t proc_dev_atm_read(struct file *file, char __user *buf,
 			length = -EFAULT;
 		(*pos)++;
 	}
-	free_page(page);
+	free_page((void *)page);
 	return length;
 }
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0a4e2541f136..60921b1b9cee 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4774,7 +4774,7 @@ static int nf_tables_set_alloc_name(struct nft_ctx *ctx, struct nft_set *set,
 			memset(inuse, 0, PAGE_SIZE);
 			goto cont;
 		}
-		free_page((unsigned long)inuse);
+		free_page(inuse);
 	}
 
 	set->name = kasprintf(GFP_KERNEL_ACCOUNT, name, min + n);
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 28c9588cf3a2..03a7e5606481 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -4349,8 +4349,7 @@ static void free_pg_vec(struct pgv *pg_vec, unsigned int order,
 			if (is_vmalloc_addr(pg_vec[i].buffer))
 				vfree(pg_vec[i].buffer);
 			else
-				free_pages((unsigned long)pg_vec[i].buffer,
-					   order);
+				free_pages(pg_vec[i].buffer, order);
 			pg_vec[i].buffer = NULL;
 		}
 	}
diff --git a/net/rds/cong.c b/net/rds/cong.c
index dd72a6028dbf..00d29b88c8b3 100644
--- a/net/rds/cong.c
+++ b/net/rds/cong.c
@@ -170,7 +170,7 @@ static struct rds_cong_map *rds_cong_from_addr(const struct in6_addr *addr)
 out:
 	if (map) {
 		for (i = 0; i < RDS_CONG_MAP_PAGES && map->m_page_addrs[i]; i++)
-			free_page(map->m_page_addrs[i]);
+			free_page((void *)map->m_page_addrs[i]);
 		kfree(map);
 	}
 
@@ -407,7 +407,7 @@ void rds_cong_exit(void)
 		rdsdebug("freeing map %p\n", map);
 		rb_erase(&map->m_rb_node, &rds_cong_tree);
 		for (i = 0; i < RDS_CONG_MAP_PAGES && map->m_page_addrs[i]; i++)
-			free_page(map->m_page_addrs[i]);
+			free_page((void *)map->m_page_addrs[i]);
 		kfree(map);
 	}
 }
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index ca61ebeb5ff5..a3087709a457 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1674,9 +1674,8 @@ static __init int sctp_init(void)
 	sctp_v4_pf_exit();
 	sctp_v6_pf_exit();
 	sctp_sysctl_unregister();
-	free_pages((unsigned long)sctp_port_hashtable,
-		   get_order(sctp_port_hashsize *
-			     sizeof(struct sctp_bind_hashbucket)));
+	free_pages(sctp_port_hashtable,
+		   get_order(sctp_port_hashsize * sizeof(struct sctp_bind_hashbucket)));
 err_bhash_alloc:
 	sctp_transport_hashtable_destroy();
 err_thash_alloc:
@@ -1715,9 +1714,8 @@ static __exit void sctp_exit(void)
 
 	sctp_sysctl_unregister();
 
-	free_pages((unsigned long)sctp_port_hashtable,
-		   get_order(sctp_port_hashsize *
-			     sizeof(struct sctp_bind_hashbucket)));
+	free_pages(sctp_port_hashtable,
+		   get_order(sctp_port_hashsize * sizeof(struct sctp_bind_hashbucket)));
 	kfree(sctp_ep_hashtable);
 	sctp_transport_hashtable_destroy();
 
diff --git a/net/sunrpc/backchannel_rqst.c b/net/sunrpc/backchannel_rqst.c
index caa94cf57123..e89b4efc35be 100644
--- a/net/sunrpc/backchannel_rqst.c
+++ b/net/sunrpc/backchannel_rqst.c
@@ -44,9 +44,9 @@ static void xprt_free_allocation(struct rpc_rqst *req)
 	dprintk("RPC:        free allocations for req= %p\n", req);
 	WARN_ON_ONCE(test_bit(RPC_BC_PA_IN_USE, &req->rq_bc_pa_state));
 	xbufp = &req->rq_rcv_buf;
-	free_page((unsigned long)xbufp->head[0].iov_base);
+	free_page(xbufp->head[0].iov_base);
 	xbufp = &req->rq_snd_buf;
-	free_page((unsigned long)xbufp->head[0].iov_base);
+	free_page(xbufp->head[0].iov_base);
 	kfree(req);
 }
 
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 3aa987e7f072..43f38388db9f 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2975,7 +2975,7 @@ static void bc_free(struct rpc_task *task)
 	struct rpc_buffer *buf;
 
 	buf = container_of(buffer, struct rpc_buffer, data);
-	free_page((unsigned long)buf);
+	free_page(buf);
 }
 
 static int bc_sendto(struct rpc_rqst *req)
diff --git a/net/xfrm/xfrm_hash.c b/net/xfrm/xfrm_hash.c
index a47f14b437a8..83b7c251f020 100644
--- a/net/xfrm/xfrm_hash.c
+++ b/net/xfrm/xfrm_hash.c
@@ -36,5 +36,5 @@ void xfrm_hash_free(struct hlist_head *n, unsigned int sz)
 	else if (hashdist)
 		vfree(n);
 	else
-		free_pages((unsigned long)n, get_order(sz));
+		free_pages(n, get_order(sz));
 }
diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index 6560661ad377..54d15cade5b8 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -831,7 +831,7 @@ static void multi_transaction_kref(struct kref *kref)
 	struct multi_transaction *t;
 
 	t = container_of(kref, struct multi_transaction, count);
-	free_page((unsigned long) t);
+	free_page(t);
 }
 
 static struct multi_transaction *
diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index 343f314418a5..c507199a9d86 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -279,7 +279,7 @@ static void ima_free_pages(void *ptr, size_t size)
 {
 	if (!ptr)
 		return;
-	free_pages((unsigned long)ptr, get_order(size));
+	free_pages(ptr, get_order(size));
 }
 
 static struct crypto_ahash *ima_alloc_atfm(enum hash_algo algo)
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index cfb0b9b9d5f3..9a20faf42640 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1354,7 +1354,7 @@ static int selinux_genfs_get_sid(struct dentry *dentry,
 			rc = 0;
 		}
 	}
-	free_page((unsigned long)buffer);
+	free_page(buffer);
 	return rc;
 }
 
diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index 73a8c5c17c76..446121bb0277 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -1399,7 +1399,7 @@ static int sel_make_bools(struct selinux_policy *newpolicy, struct dentry *bool_
 		d_add(dentry, inode);
 	}
 out:
-	free_page((unsigned long)page);
+	free_page(page);
 	return ret;
 }
 
@@ -1465,7 +1465,7 @@ static ssize_t sel_read_avc_hash_stats(struct file *filp, char __user *buf,
 	length = avc_get_hash_stats(page);
 	if (length >= 0)
 		length = simple_read_from_buffer(buf, count, ppos, page, length);
-	free_page((unsigned long)page);
+	free_page(page);
 
 	return length;
 }
@@ -1484,7 +1484,7 @@ static ssize_t sel_read_sidtab_hash_stats(struct file *filp, char __user *buf,
 	if (length >= 0)
 		length = simple_read_from_buffer(buf, count, ppos, page,
 						length);
-	free_page((unsigned long)page);
+	free_page(page);
 
 	return length;
 }
diff --git a/sound/drivers/dummy.c b/sound/drivers/dummy.c
index 5e56157e0719..60d5333226db 100644
--- a/sound/drivers/dummy.c
+++ b/sound/drivers/dummy.c
@@ -598,7 +598,7 @@ static void free_fake_buffer(void)
 		int i;
 		for (i = 0; i < 2; i++)
 			if (dummy_page[i]) {
-				free_page((unsigned long)dummy_page[i]);
+				free_page(dummy_page[i]);
 				dummy_page[i] = NULL;
 			}
 	}
diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 375d6285475e..35a70d5d4819 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -116,7 +116,7 @@ int kvm_coalesced_mmio_init(struct kvm *kvm)
 void kvm_coalesced_mmio_free(struct kvm *kvm)
 {
 	if (kvm->coalesced_mmio_ring)
-		free_page((unsigned long)kvm->coalesced_mmio_ring);
+		free_page(kvm->coalesced_mmio_ring);
 }
 
 int kvm_vm_ioctl_register_coalesced_mmio(struct kvm *kvm,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a716c81e01e6..0cae34f318cc 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -416,7 +416,7 @@ void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
 		if (mc->kmem_cache)
 			kmem_cache_free(mc->kmem_cache, mc->objects[--mc->nobjs]);
 		else
-			free_page((unsigned long)mc->objects[--mc->nobjs]);
+			free_page(mc->objects[--mc->nobjs]);
 	}
 
 	kvfree(mc->objects);
@@ -475,7 +475,7 @@ static void kvm_vcpu_destroy(struct kvm_vcpu *vcpu)
 	 */
 	put_pid(vcpu->pid);
 
-	free_page((unsigned long)vcpu->run);
+	free_page(vcpu->run);
 	kmem_cache_free(kvm_vcpu_cache, vcpu);
 }
 
@@ -4265,7 +4265,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 arch_vcpu_destroy:
 	kvm_arch_vcpu_destroy(vcpu);
 vcpu_free_run_page:
-	free_page((unsigned long)vcpu->run);
+	free_page(vcpu->run);
 vcpu_free:
 	kmem_cache_free(kvm_vcpu_cache, vcpu);
 vcpu_decrement:
-- 
2.50.1


