Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1712FCCD185
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 01:58:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 577708E0026; Wed,  8 Oct 2025 21:58:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 528518E0002; Wed,  8 Oct 2025 21:58:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43E088E0026; Wed,  8 Oct 2025 21:58:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F0508E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 21:58:44 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CCE785B986
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:58:43 +0000 (UTC)
X-FDA: 83976916926.07.30DFE6E
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf04.hostedemail.com (Postfix) with ESMTP id 034C640004
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:58:41 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=SVk3HeVW;
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf04.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759975122; a=rsa-sha256;
	cv=none;
	b=6fft2R5sIwo3+VsrQwpzeyubWwci/AfqqTzQrist6Y/I/hQF3D4fHxiODl1+I19DO8Th9u
	WvDTiAApq8wi66xHJgvoabX3lOwyBJFt7VThDce24kDNcCQ4R+g5Oio6v56dJBaITLzAcR
	oh0o+IvMut6fPm9pob/SmWSBnGHq0Qc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=SVk3HeVW;
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf04.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759975122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=MGhJn0zuB3cjukhWEpGI8TCi/TsRvbfQ2QIBtaBaaG4=;
	b=oV75x9g9EofRzvXdNOnIConFXu9BVRIgE2bsGVrgVAIam+/2bD3rCUbj6hRzf+KRW42ksK
	npin7uBS36f+dcBUnVoK9VMlCRypDISzO15cbdbZZqQxLzDQkFtYT5ki+l2Het/OS73iGi
	gzKF7UwbB6NokkxHyve/gSNlLoMuovw=
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-b631b435d59so270981a12.0
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 18:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1759975121; x=1760579921; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MGhJn0zuB3cjukhWEpGI8TCi/TsRvbfQ2QIBtaBaaG4=;
        b=SVk3HeVW6S9frppQAeRy4IWW/iLaUWjuF01kZxVezHEIFed5n4CdFzW5E5pXRhKVAe
         VCRJajTsQcWBgA5SBEe9j524aVt88Bv7hG6ioOG3fs3zjy6Ln7JpTC2fbiYdIMhWdlmi
         yGCotZqXUdC8hd0L77AZR12e4AgOBRl1jCStbRtaey+466d+hnPFyP0qb5JzA7nYOVr3
         ziVtMvdqIgIm2Vlqvl3C9Gwb5km1Jmg4icRV29Ceg9PYAasTlZFL1nwS5F/2ggSonOJg
         i0Upl3Qo9NMFEUNf9VCrU1Syi0b4G1RTibcv7LEzZQ17L1BgSYdinYe+h/AhWnt2QIpc
         8ing==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759975121; x=1760579921;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MGhJn0zuB3cjukhWEpGI8TCi/TsRvbfQ2QIBtaBaaG4=;
        b=vr+aedfcsHaZsZNP7qkMCeB8FhUwD7ygsxgYzGzDuC3NvKZGSQX2le0hGUqnL8BgV3
         wx7AVSYdDcv7Ka4p0AP/zpX6jxryHL/hy8psxnNMhHNPSePObs7HzE8cVJHiCiCljbP5
         E2OwSubQFY0UPVyyZ273+KTHY+FeIPdpLd4azC3uPz+EgwKozHFbZlFPg2fvX9BZYaJr
         6Vwp75Je5hW8zgJMlt6CtuUt+S8hENV+mHt4XtX9RHCD6dB+2yizwA1mfBeu+fbqJeo7
         YifbCPH2drYw6xC67RyGuS0d3WTvDcSwUswkc7BNZsn87yFM8zSFgbmiSrIl2dWyDq8b
         zN1g==
X-Forwarded-Encrypted: i=1; AJvYcCUFemkvfgYzP4Lu1A7N4TojpBwBlOpD80CYuAs4kQJO014MqqQgR1So8fzLVaymcLSpmMeo05iB3w==@kvack.org
X-Gm-Message-State: AOJu0Yw85ff6YVeAfEk6ajonAQhhIQtoMlaMRCvKsBYiqK2JLmAIOzKK
	9CzFUicJeUl/cMMRASA2AAwlp3Z5Jr0/wODlpOtIbqdeKZ3yETMv5/ohJN2/IxieqvE=
X-Gm-Gg: ASbGncvgaxavPP+Nd3W5Cj625468rsLcfjpS1hEmni8uAXC+Lsy2QKZknBca1VKg1sF
	cWZvBEeqA9HqMPdpvB+dgLoaFt7ri/k3hBomTQ9OMNuA3/131vtfnsF/OEHFsDvpRGlQwrJw30u
	h0aAaOH9UTS+DmUiapVB5BVwGU7n8QpiwjrtTdMKbKSP7I89hF0K1Y905IEqEOswm4XPYHEOHAK
	SqDsNIwfH7BCttvuPJxrRjzB7D8FDa2GkF15ZUmv+IrKQxzw448AU2v+T9Xm//ZKk4+R3UcSOyk
	nWGGNo4wR2w5pTnlzWlSCxa/QMm5Hyz2Y1IiKfsXpGScG7RA2M4dBorRP14S4d1T41SY6hZgPlp
	L7M0Pw2GXm/lUqMKcwRN8MQHfdPv8gwkC1hKOmEb5indFOo6WRptSmHqeofaxsKu41bNrz0+4Wg
	vwc1w=
X-Google-Smtp-Source: AGHT+IFzbHSpjbAdUeon2lhaXxPMeA3ROs733ToOq2tuRqC6DIIzW3ufW0i2Q93eAuRGazWAjP157w==
X-Received: by 2002:a17:903:94f:b0:250:643e:c947 with SMTP id d9443c01a7336-290273ee209mr70465645ad.28.1759975120758;
        Wed, 08 Oct 2025 18:58:40 -0700 (PDT)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034de53f9sm11033585ad.14.2025.10.08.18.58.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 18:58:40 -0700 (PDT)
From: Samuel Holland <samuel.holland@sifive.com>
To: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	linux-riscv@lists.infradead.org
Cc: devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Conor Dooley <conor@kernel.org>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Emil Renner Berthing <kernel@esmil.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Samuel Holland <samuel.holland@sifive.com>
Subject: [PATCH v2 00/18] riscv: Memory type control for platforms with physical memory aliases
Date: Wed,  8 Oct 2025 18:57:36 -0700
Message-ID: <20251009015839.3460231-1-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: a17oy174x6upukptqoigofcjj8x5391x
X-Rspamd-Queue-Id: 034C640004
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1759975121-699755
X-HE-Meta: U2FsdGVkX19yP7KT1Nt4cIGzpjoK3nrtO/Ha9B8N3IAhmXr59iXdG6EuOG0hZSdo/k7lDpoVrtVTLT6sKxUzT4qCTLSfBSkafnuP2bDdfuySBJoSJdy48EH4NH5mt0lYLs7Cy3sCGJjga+KONFetvFEY7EMnecS8h8tzyMk1GtyhQILDIVtHAHr9hk+aIxBC8L4/2oaA9KxGRxt9i6xbd8pg5Az4wIrRc2gHDWRjKdY71EcMHQ60cvA/R1ZPZBUeABFnzq28rtWaFWwf96fxlhdZmwrSTfM66dT0SEan06t8MZ52t5jFiYABThOxW3DD1Cl2rlq6+WT9KjR9nkIMdf8zNTurCO9zpiO1sWhIPLDXAhhWjQiS4FwPzMsKpbXHUQ08tw9T1TShvdP21xCr4oSSPxWyyTavbHoYOHUpB8V7yA+13gT7mhnABLyiwUqorfVv/5B9VicbPxclColkrAWNwXUOnbW8e1IMaPP+Z/ao1u2sJWwdLnLS9JTeRvsdjzIVwkuBI+F+TML6nQbnbSlvF2hJgCMAGycOy53gohC2kWo5OVhzimxwWgff1o3hqpoL8x2ntvwaSrvD9XxnrDO29Khh2HIeLyA3AowOPqNPTCUXLNoOgNLeybt9ZFwlT9zboEQaRQi+1aQy/vsQwEz7HSdvQbkr4sfrSXc0lIFwHWq/oJhUxFf1f5NbDlNTB3qTXBqfmxa5+I7RSAf08ZonXek6QT+upXlPQyNdVKhTJjQFWNCuHa/damjmQyNnWNC6dPRwLZ0bsj2GPFUX/xsp8S9gs/98VkP0Si94ris3F+uqZKJ01NMznTwnw6zNslOIp+YioZlA+yAzyYCTVWmSs/XhCsoAU5Ce/FQ7pWnuJrgageyFHhXGDIjV1bC7T0FLGamfecazu6FD8A2C+j+HqbyeiLP4A+nlEw9uPLJnYDQ3y1fYszpvEEUSl20EcpGs3Rccs2cdxqCUnvQ
 ovzuV+zY
 qZY5I7JBZVa4byx4EqaRJFht82fdDEE6G8Wyj77euMp2UTqNSwdwdlSZza9VxPBGZ0DqmqYhmaxAZSB0L3HJvehi6vxQ5TJSe829s5RzXbp/gdlIQUsa7mQSLFlPyfkzV9u5b1IuCqUHGQv2fJQ5Et++bLbp1q7QGEMFViLmKKTmYbetUaXdZ+WhVb+Djp9MqvGNUMvTeNv62dkqdOfgYk61a3B1I8myeThUt3brmrmWHEd+DC/H8eJb3tJsbc0AsH/GDw/E/oKFmTiVA0HcEQtpIMS1XZI034v5sUR/tKXyeJ41kSZRNo7mdjTVkGFOQ3SNcEnkX5rqKbdY2p10WGMISPg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On some RISC-V platforms, including StarFive JH7100 and ESWIN EIC7700,
DRAM is mapped to multiple physical address ranges, with each alias
having a different set of statically-determined Physical Memory
Attributes (PMAs), such as cacheability. Software can alter the PMAs for
a page by selecting a PFN from the corresponding physical address range.
On these platforms, this is the only way to allocate noncached memory
for use with noncoherent DMA.

These physical memory aliases are only visible to architecture code.
Generic MM code only ever sees the primary (cacheable) alias. The major
change from v1 of this series is that I was asked to move the hooks from
pfn_pXX()/pXX_pfn() to set_pXX()/pXXp_get().

 - Patches 1-7 ensure that architecture-specific code that hooks page
   table reads and writes is always called, and the calls are balanced.
 - Patches 8-11 refactor existing platform-specific memory type support
   to be modeled as variants on top of the standard Svpbmt extension,
   and apply the memory type transformation during PTE reads/writes.
 - Patches 12-16 add a new DT binding to describe physical memory
   regions, and implement a new memory type variant that transforms the
   PFN to use the desired alias when reading/writing page tables.
 - Patches 17-18 enable this new memory type variant on StarFive JH7100
   and ESWIN EIC7700.

I have boot-tested this series and tested DMA on SoCs with each of the
four ways to select a memory type: SiFive FU740 (none), SiFive
P470-based SoC (Svpbmt), Allwinner D1 (XTheadMae), and ESWIN EIC7700
(aliases).

Here is some basic `perf benchmark` data comparing relative performance
between v6.17 and either the generic MM changes or the whole series:

 Test        | Scenario   |  FU740 |   P470 |    D1  | EIC7700
 =============================================================
 syscall     | patch 1-10 | +3.17% | +0.89% | +2.60% |  +0.68%
   basic     |     series | -2.52% | -1.41% | +1.37% |  -0.64%
 -------------------------------------------------------------
 syscall     | patch 1-10 | +0.17% | -0.57% | +2.79% |  -1.12%
   fork      |     series | -1.31% | -5.91% | -1.50% |  -2.73%
 -------------------------------------------------------------
 syscall     | patch 1-10 | -0.24% | -0.30% | +2.76% |  +1.32%
   execve    |     series | -1.65% | -4.82% | -1.38% |  -0.66%
 -------------------------------------------------------------
 sched       | patch 1-10 | +1.54% | -5.76% | -5.09% |  -1.04%
   messaging |     series | +0.66% | +2.00% | +1.40% |  +1.97%
 -------------------------------------------------------------

The benchmark results are stable within each machine, and the same
binary was used on all machines. I would have expected the preparatory
changes (patch 1-10) to hurt performance somewhat, due to READ_ONCE/
WRITE_ONCE generating additional loads/stores, but surprisingly
performance was improved in some cases. The variation across machines
in response to the entire series is expected, as each of these machines
gets a different version of the alternative block.

Changes in v2:
 - Keep Kconfig options for each PBMT variant separate/non-overlapping
 - Move fixup code sequences to set_pXX() and pXXp_get()
 - Only define ALT_UNFIX_MT in configurations that need it
 - Improve inline documentation of ALT_FIXUP_MT/ALT_UNFIX_MT
 - Fix erroneously-escaped newline in assembly ALTERNATIVE_CFG_3 macro
 - Remove references to Physical Address Width (no longer part of Smmpt)
 - Remove special first entry from the list of physical memory regions
 - Fix compatible string in example
 - Put new code behind a new Kconfig option RISCV_ISA_XLINUXMEMALIAS
 - Document the calling convention of riscv_fixup/unfix_memory_alias()
 - Do not transform !pte_present() (e.g. swap) PTEs
 - Export riscv_fixup/unfix_memory_alias() to fix module compilation
 - Move the JH7100 DT changes from jh7100-common.dtsi to jh7100.dtsi
 - Keep RISCV_DMA_NONCOHERENT and RISCV_NONSTANDARD_CACHE_OPS selected

Anshuman Khandual (1):
  mm/ptdump: Replace READ_ONCE() with standard page table accessors

Samuel Holland (17):
  perf/core: Replace READ_ONCE() with standard page table accessors
  mm: Move the fallback definitions of pXXp_get()
  mm: Always use page table accessor functions
  mm: Allow page table accessors to be non-idempotent
  riscv: hibernate: Replace open-coded pXXp_get()
  riscv: mm: Always use page table accessor functions
  riscv: mm: Simplify set_p4d() and set_pgd()
  riscv: mm: Deduplicate _PAGE_CHG_MASK definition
  riscv: ptdump: Only show N and MT bits when enabled in the kernel
  riscv: mm: Fix up memory types when writing page tables
  riscv: mm: Expose all page table bits to assembly code
  riscv: alternative: Add an ALTERNATIVE_3 macro
  riscv: alternative: Allow calls with alternate link registers
  dt-bindings: riscv: Describe physical memory regions
  riscv: mm: Use physical memory aliases to apply PMAs
  riscv: dts: starfive: jh7100: Use physical memory ranges for DMA
  riscv: dts: eswin: eic7700: Use physical memory ranges for DMA

 .../bindings/riscv/physical-memory.yaml       |  91 +++++++
 arch/riscv/Kconfig                            |  16 ++
 arch/riscv/Kconfig.errata                     |  19 --
 arch/riscv/Kconfig.socs                       |   4 +
 arch/riscv/boot/dts/eswin/eic7700.dtsi        |   5 +
 .../boot/dts/starfive/jh7100-common.dtsi      |  24 --
 arch/riscv/boot/dts/starfive/jh7100.dtsi      |   4 +
 arch/riscv/include/asm/alternative-macros.h   |  45 +++-
 arch/riscv/include/asm/errata_list.h          |  45 ----
 arch/riscv/include/asm/hwcap.h                |   1 +
 arch/riscv/include/asm/pgtable-32.h           |  17 +-
 arch/riscv/include/asm/pgtable-64.h           | 228 +++++++++++++-----
 arch/riscv/include/asm/pgtable-bits.h         |  43 +++-
 arch/riscv/include/asm/pgtable.h              |  67 ++---
 arch/riscv/kernel/alternative.c               |   4 +-
 arch/riscv/kernel/cpufeature.c                |   6 +
 arch/riscv/kernel/hibernate.c                 |  18 +-
 arch/riscv/kernel/setup.c                     |   1 +
 arch/riscv/kvm/gstage.c                       |   6 +-
 arch/riscv/mm/Makefile                        |   1 +
 arch/riscv/mm/init.c                          |  68 +++---
 arch/riscv/mm/memory-alias.S                  | 123 ++++++++++
 arch/riscv/mm/pgtable.c                       | 114 +++++++--
 arch/riscv/mm/ptdump.c                        |  16 +-
 fs/dax.c                                      |   4 +-
 fs/proc/task_mmu.c                            |  27 ++-
 fs/userfaultfd.c                              |   6 +-
 include/dt-bindings/riscv/physical-memory.h   |  44 ++++
 include/linux/huge_mm.h                       |   8 +-
 include/linux/mm.h                            |  14 +-
 include/linux/pgtable.h                       | 112 ++++-----
 kernel/events/core.c                          |   8 +-
 mm/debug_vm_pgtable.c                         |   4 +-
 mm/filemap.c                                  |   6 +-
 mm/gup.c                                      |  37 +--
 mm/hmm.c                                      |   2 +-
 mm/huge_memory.c                              |  90 +++----
 mm/hugetlb.c                                  |  10 +-
 mm/hugetlb_vmemmap.c                          |   4 +-
 mm/kasan/init.c                               |  39 +--
 mm/kasan/shadow.c                             |  12 +-
 mm/khugepaged.c                               |  10 +-
 mm/ksm.c                                      |   2 +-
 mm/madvise.c                                  |   8 +-
 mm/mapping_dirty_helpers.c                    |   2 +-
 mm/memory-failure.c                           |  14 +-
 mm/memory.c                                   |  78 +++---
 mm/mempolicy.c                                |   4 +-
 mm/migrate.c                                  |   4 +-
 mm/migrate_device.c                           |  10 +-
 mm/mlock.c                                    |   6 +-
 mm/mprotect.c                                 |   4 +-
 mm/mremap.c                                   |  30 +--
 mm/page_table_check.c                         |   7 +-
 mm/page_vma_mapped.c                          |   6 +-
 mm/pagewalk.c                                 |  14 +-
 mm/percpu.c                                   |   8 +-
 mm/pgalloc-track.h                            |   8 +-
 mm/pgtable-generic.c                          |  25 +-
 mm/ptdump.c                                   |  10 +-
 mm/rmap.c                                     |   8 +-
 mm/sparse-vmemmap.c                           |  10 +-
 mm/userfaultfd.c                              |  10 +-
 mm/vmalloc.c                                  |  49 ++--
 mm/vmscan.c                                   |  16 +-
 65 files changed, 1110 insertions(+), 626 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/riscv/physical-memory.yaml
 create mode 100644 arch/riscv/mm/memory-alias.S
 create mode 100644 include/dt-bindings/riscv/physical-memory.h

-- 
2.47.2

