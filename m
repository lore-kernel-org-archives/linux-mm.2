Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26F76CD4F37
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 01:47:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EED68E0010; Wed, 12 Nov 2025 20:47:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 678B48E0002; Wed, 12 Nov 2025 20:47:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 518A48E0010; Wed, 12 Nov 2025 20:47:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 37BE38E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:47:02 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F348A160779
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:47:01 +0000 (UTC)
X-FDA: 84103895442.13.049AD87
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf05.hostedemail.com (Postfix) with ESMTP id 152E910000B
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:46:59 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=RSZifErQ;
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf05.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762998420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=GSzIa/C5f6OJIgZm6PYuMbKgOcm8FD5PfqT1N2NRHyU=;
	b=jqqGDaSe3G65PapbP0jH1tnha0RwCOo+ggp2G/ri4eUAULN9jIxWrHGCC1FHfUXsnDlZhM
	WMogjMABkezgtdmIBegIfFIkAh3weumo+zs9vEkzbR9sVoRl1o+Hj/zKldxn7/AuIYNo9F
	FngTc0WdM2f2trcIxbh3XGQcF/pBP54=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762998420; a=rsa-sha256;
	cv=none;
	b=jQmG5SnSr0fIajlZ9jg/l3y0Dz5eAqbFZHltowUX8GT2MwWLByA88uaSkHc6rCpq9EPlAE
	ZUZxDsm7VKa0RPKKw3mni4USd+mDXnFsaYC4cfZ0JTADH75Zjsjt1AYScdTTs6j+uKP7DA
	DB96lJDwB48E4alw0Sygj58Aym1Qcyc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=RSZifErQ;
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf05.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-bc09b3d3b06so168691a12.2
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 17:46:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1762998419; x=1763603219; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GSzIa/C5f6OJIgZm6PYuMbKgOcm8FD5PfqT1N2NRHyU=;
        b=RSZifErQ0T43zwAyKK0x/zoHE467Rwh4v7cOK1yzAOQaF2+8ohY8XbNEaRVFyKdxJx
         ttgi+ZFPWwCClbLeJoWmdUcmH4IGBqbzH9dY7RA7Shpd530URL7Oc7bBeQxA3vy5Ebzc
         OamLBSY/CraxDqeTtuFeLaet7o9VJngrxwvTpf32V84kby+hd67v/ZIuCUQZYc/UGYAn
         /i8yNmsi/zTokT4MwIGwPgCx6coCyPm5DFMLoQ8ew8RZvF6FMwLH/SzsieV7Y5i+qZdG
         LI2Z9PYpsPgqwZ1H1dkqV5tW1MuU3mL8YMxV7iEMBG5dTzC9dehyvgmfaFtklSqxz55T
         a6GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762998419; x=1763603219;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GSzIa/C5f6OJIgZm6PYuMbKgOcm8FD5PfqT1N2NRHyU=;
        b=GCZe3yOLNDrN6ywvUVbmIhf6q9R5AtbbiM68qQYUjCsnIdnnQUPsf+ryPuZBW/8JA6
         jSSATTn5V71AMX2OiR7JrnVsnUbVNgsYQStd1pJYtrwBpawnyeC51MhUhX0yu/4O2TbO
         1WNzBXzcpaPBFoPK7Zh4fN3f5X1pCLeDDpZMOMTdVZH0OzrheQOwJlOFBiw3Qs4BxUwa
         JNaxR/qzwdqO/B5F8gLda9CxAUFcERu3SeMpeuaQdqRMO9m4t+H5COBAlE6jldhH4dbW
         qGqDjTOzgsU+xsfro7V6pMQpB3J9C+TCdBkus5e5q2qj4D08YjW57HPCQFX0SXDyHzWr
         ajyg==
X-Forwarded-Encrypted: i=1; AJvYcCXa2qdkHRbavUwtBGB/C88ffCfGM/am1JJa9g1/djjPk9sz5olDWAX9m+3eS3ciSLWpDcf3dNM8Qg==@kvack.org
X-Gm-Message-State: AOJu0Ywnrxc8kdxQXcHM6NvHuCxi+gAHH2VW7u7tY/dTxn/TkOL8fz3J
	i1n39303Xe9yAxr9xN4COmBGLdYpifYfiCjCgrwFqPRy2zo8W0b4sX73rsAI6IXjHFY=
X-Gm-Gg: ASbGncuxA2JcZB6DQL4UceHs5DBfjxoeVn/C+UDFvrmsRMtZs7KzKW/Ji+O5DiWVlGa
	qIbuy1gRDygecEv4Al4IINonPOWEvF1+eex35nJQRP4C+23SzBp7nfBTkBt9CIbXPNzywpP/55Q
	iyh/4P4ctyi/gm9nyRYDgBGT0tyoqD9lHhXxRmNIzEfcHObG3te2vgWcQ7kJGKWMk6H4l4J3FYm
	owSaV3ufM4bjsHMUJsAcHfyylNKXu5qdzlBcE8xJAXH09h9/dtqCN8cEWhbtw3ZsE38BowfLS3f
	2a7SG3xB3en4tUkBbVIw5ucYb9lOmrXpKV5AcBiRfrf3oveOAB6WGoWWAMY6ya1e46GfJKAdVMT
	7NqcRZsP51z8O2JVpH6FyUzOwhxE0DYSK2sK54qEJBss+vPvJ0+l2J9EPpDxnqOsFU3KiIrWtoh
	MNwCCdcVqeu6VwJOOsVdIjfF5xO+eRVrlV
X-Google-Smtp-Source: AGHT+IGQ1oJIJsgSbTE25rUPYQbOXvZA9fZDeWGgVb5ZU8Gh8y0+bI+696VC2IPvCWeUs/WTbPO2dg==
X-Received: by 2002:a17:903:8cb:b0:295:6427:87d4 with SMTP id d9443c01a7336-2984ee18d1cmr62642185ad.50.1762998418704;
        Wed, 12 Nov 2025 17:46:58 -0800 (PST)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2ccae8sm4986485ad.98.2025.11.12.17.46.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 17:46:58 -0800 (PST)
From: Samuel Holland <samuel.holland@sifive.com>
To: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	linux-riscv@lists.infradead.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	linux-mm@kvack.org
Cc: devicetree@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>,
	linux-kernel@vger.kernel.org,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Conor Dooley <conor@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Emil Renner Berthing <kernel@esmil.dk>,
	Rob Herring <robh+dt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Andy Whitcroft <apw@canonical.com>,
	Dwaipayan Ray <dwaipayanray1@gmail.com>,
	Joe Perches <joe@perches.com>,
	Julia Lawall <Julia.Lawall@inria.fr>,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Nicolas Palix <nicolas.palix@imag.fr>
Subject: [PATCH v3 00/22] riscv: Memory type control for platforms with physical memory aliases
Date: Wed, 12 Nov 2025 17:45:13 -0800
Message-ID: <20251113014656.2605447-1-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 64nrkg4xhmsp8hqjw1o9tpf3qo7m5y6t
X-Rspam-User: 
X-Rspamd-Queue-Id: 152E910000B
X-Rspamd-Server: rspam10
X-HE-Tag: 1762998419-940430
X-HE-Meta: U2FsdGVkX196AAUdbFLwiEI4wfxb/uEcQcDKC/2FH4VBG7jx0zgjJ/iHRWQwC16/HcDk0Sc1WjOUVMNIt+XDnJtOQj7GbhxA300lp3OPTb6C4Z+GjoOO29x0NGNa05+YNH9puhPI68GU+UEKxVOL7aNeWqPSYsHFkgjmhMqP86amrR7+nxTfzLzE1PcMKzMchxHVZLL1HU+RYKThWwyVWjTZp03C/2sV022EUgVtHNmNhg0DnSX79J1pzhZSrijUGksYDNpjHAHyqGw7s4zSJN0rK4LWVcekergimWcoYrdzJ4zv50JIfAey0z7bBtyy3kQUrC0QE+IeEnogYds3nFCGoHMMjR9K1dSjQnBtXtT2HVlFLMZbgPdmcVrceIbk2YM9TABN03fnKaNGMNoJvhk3BqBaX2mdGGP8Zs+Euvfpt+ei/alKB2HKRYSyrZYN3w9ciKHkmdc954+M/XunP7bx5DTLKOOc+Rc5RAjWucUExt47f3rxwMUQT44gVwc7WlnhcRk0zzFq/O2rq5lurNGtMQ+Y4zmDom/Yjss7kS5ZMOFqVxgl8QBid1dhWAJRCdhFBeF/ZYig/iukmWmJjZI8ZhdA7zd5p9umlCOs1JiTIf+kfZ/ZrfiXOnzJuxD2cAGUjMHWbxT3e1wUhCOJ9yYl03ft4XgXUdCd78LV3FIyW8iY03WJpVwUp9jAPlAYxFz0kwtgdzKUZk/Asi0X8xnMD/0V/r8N22RrJKBp+mYAhXhdfbIjew8aQeM2TvmZoU1vIp1xukUyKXtJ1Ld/19ygkWM8edJJHqFdhHpGBHH5J/S5YnZFEnRbaFW1s0lUNeYv2yxNs2Atd7nRVk3HO0bbU55Zt3HGXDcMq0+rQEqn+AIBfYSdQ4Qz3a/xGfj6zG7PLrFQp6it048xMMyMMFb7ZgxAlNki24CjTGJxvqHhoXCMSsJdIfS39vLEXy8up624RCbBW7JcuWmGfN4
 NY/3uOCo
 KnKRSwlgjrb/wa1XBrPHRSqb8fu+zfGD8tRG5isXzHSNPZyNP7peCq80Ll+UURHZqA8S3D7KfwICHmflhSMpcaR63ocHEGUDbAbFN1DFfLvyEdGPsFdZb3rz2COH1xiI0FxIlGN2rpFf7/vDmBjdgCCvCnyTbj8i/gxbpQh6s8wchcBcgk9bwLHBzvN8LKkjzmoawq9AEtdWOqaAWYWHDGtOCpWYVupUFnw+TWQfq0oJD4eYHGXluIop3x+71RgnFP4ypviF6RV9akg9izqmo0ZW+fuMpwcaQl6Le2vCaC+ea+PRQz6lkLlBRXPmVh3THUo0VIMu84B6p6/MXiW5ILzRKn+qXXuGsiiXC6VFUCncyVEgRfu2zZ8GViQ==
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

 - Patches 1-10 ensure that architecture-specific code that hooks page
   table reads and writes is always called, and the calls are balanced.
 - Patches 11-14 refactor existing platform-specific memory type support
   to be modeled as variants on top of the standard Svpbmt extension,
   and apply the memory type transformation during PTE reads/writes.
 - Patches 15-20 add a new DT binding to describe physical memory
   regions, and implement a new memory type variant that transforms the
   PFN to use the desired alias when reading/writing page tables.
 - Patches 21-22 enable this new memory type variant on StarFive JH7100
   and ESWIN EIC7700.

I have boot-tested this series and tested DMA on SoCs with each of the
four ways to select a memory type: SiFive FU740 (none), SiFive
P470-based SoC (Svpbmt), Allwinner D1 (XTheadMae), StarFive JH7100
(aliases), and ESWIN EIC7700 (aliases).

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

Changes in v3:
 - Use upstream commit/patch for Anshuman Khandual's changes
 - Rebased on top of torvalds/master (v6.18-rc5+)
 - Add a checkpatch rule to warn on page table pointer dereference
 - Select DMA_DIRECT_REMAP when any memory type extension is enabled
 - Split PMR_IS_ALIAS flag from PMR_ALIAS_MASK number
 - Add "model" property to DT binding example to fix validation
 - Fix the logic to allow an alias to be paired with region entry 0
 - Fix the entry number of the paired region in the DT
 - Keep the ERRATA_STARFIVE_JH7100 option but update its description
 - CC all core MM reviewers

Changes in v2:
 - Keep Kconfig options for each PBMT variant separate/non-overlapping
 - Move fixup code sequences to set_pXX() and pXXp_get()
 - Only define ALT_UNFIX_MT in configurations that need it
 - Improve inline documentation of ALT_FIXUP_MT/ALT_UNFIX_MT
 - Fix erroneously-escaped newline in assembly ALTERNATIVE_CFG_3 macro
 - Remove references to Physical Address Width (no longer part of Smmpt)
 - Remove special first entry from the list of physical memory regions
 - Fix compatible string in DT binding example
 - Put new code behind a new Kconfig option RISCV_ISA_XLINUXMEMALIAS
 - Document the calling convention of riscv_fixup/unfix_memory_alias()
 - Do not transform !pte_present() (e.g. swap) PTEs
 - Export riscv_fixup/unfix_memory_alias() to fix module compilation
 - Move the JH7100 DT changes from jh7100-common.dtsi to jh7100.dtsi
 - Keep RISCV_DMA_NONCOHERENT and RISCV_NONSTANDARD_CACHE_OPS selected

Anshuman Khandual (4):
  mm/ptdump: replace READ_ONCE() with standard page table accessors
  mm: replace READ_ONCE() with standard page table accessors
  mm/dirty: replace READ_ONCE() with pudp_get()
  perf/events: replace READ_ONCE() with standard page table accessors

Samuel Holland (18):
  mm: Move the fallback definitions of pXXp_get()
  mm: Always use page table accessor functions
  checkpatch: Warn on page table access without accessors
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
  riscv: Fix logic for selecting DMA_DIRECT_REMAP
  dt-bindings: riscv: Describe physical memory regions
  riscv: mm: Use physical memory aliases to apply PMAs
  riscv: dts: starfive: jh7100: Use physical memory ranges for DMA
  riscv: dts: eswin: eic7700: Use physical memory ranges for DMA

 .../bindings/riscv/physical-memory.yaml       |  92 +++++++
 arch/riscv/Kconfig                            |  19 +-
 arch/riscv/Kconfig.errata                     |  11 +-
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
 include/dt-bindings/riscv/physical-memory.h   |  45 ++++
 include/linux/huge_mm.h                       |   8 +-
 include/linux/mm.h                            |  14 +-
 include/linux/pgtable.h                       | 112 ++++-----
 kernel/events/core.c                          |   8 +-
 mm/damon/vaddr.c                              |   2 +-
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
 mm/memory.c                                   |  80 +++---
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
 scripts/checkpatch.pl                         |   7 +
 67 files changed, 1129 insertions(+), 615 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/riscv/physical-memory.yaml
 create mode 100644 arch/riscv/mm/memory-alias.S
 create mode 100644 include/dt-bindings/riscv/physical-memory.h

-- 
2.47.2

base-commit: 24172e0d79900908cf5ebf366600616d29c9b417
branch: up/dma-alias

