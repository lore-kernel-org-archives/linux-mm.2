Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BF21CA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 08:55:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC064900212; Fri, 15 Aug 2025 04:55:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B983A8E0002; Fri, 15 Aug 2025 04:55:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAE27900212; Fri, 15 Aug 2025 04:55:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9169F8E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 04:55:29 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 426511408D2
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:55:29 +0000 (UTC)
X-FDA: 83778383178.09.534E927
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6A0DF100007
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:55:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755248127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=4+QdAM8hYl7vx0HDv3aq9QjV4F5Cz1pvUXhxSAX+iWw=;
	b=6lVq89duRSwRgH8d5OjgCZKRAUK61b38h8NgCS6uXR05pFNXAT0uUifQpk+2/fSJ0vipFZ
	zw2v8M0S177BXPAcj95PZeZrONTrU6lBBjTt5WhKup201EPd0CvPQiVIKDssoXKc67B6K7
	hP0Ucc5gFv2DKXmAObgE9QqLUYUXqLE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755248127; a=rsa-sha256;
	cv=none;
	b=oF7GpIG0YTatYD6U+oKSd+Vl7cDMbTsbvq7FbQAs9gwbrzCdt6TZxRX2gPjE+vroc/kciS
	YIwZNdN9PvUeOCFFRU0uKmq9t2u9LBmQ29kSBL1kQt2T9s8xQoJ4i0SU2pm9BD+tlnrEFO
	4vBM93lUZZAkV/mJOHID8IhHaiKtdRk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3D3221688;
	Fri, 15 Aug 2025 01:55:18 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B47BD3F63F;
	Fri, 15 Aug 2025 01:55:21 -0700 (PDT)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-hardening@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jann Horn <jannh@google.com>,
	Jeff Xu <jeffxu@chromium.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Kees Cook <kees@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Maxwell Bland <mbland@motorola.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Pierre Langlois <pierre.langlois@arm.com>,
	Quentin Perret <qperret@google.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org
Subject: [RFC PATCH v5 00/18] pkeys-based page table hardening
Date: Fri, 15 Aug 2025 09:54:54 +0100
Message-ID: <20250815085512.2182322-1-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6A0DF100007
X-Stat-Signature: fa5wxjinkef8ssodi1dzwy6mh7fejcww
X-Rspam-User: 
X-HE-Tag: 1755248127-445130
X-HE-Meta: U2FsdGVkX19pWzsqUvQ8HoOjXvn2iYL/nIJtOSHZPkbH6uQczNiqBliqkIFE/VWZZFCSCLugAoDxqahvibq9MyJMgJqNVZ100nZCCX62pstZhQoXFr89s86NJ1sGFd06PP3b1y7emXT1MTOzhW/k8CafjjwfnBp6ngTmRJgfV1NlMb6g4hP9Ge3ghJr8qhwo9UPUltKprshGjurmvAJzqVl8nkY6qDd2Z6KCEnQFFt8+pbzN1kCRLdgLQZRpRUhmKBX6R5TuStI8NLpkaltdweEvmLkAfJMXkMSgZl8X8dgSTbnwybwhhYC/iNMIL69YiuY/Uip1w/x7KFTCea3iGtlcH8ZJDiZ5oKq5XVt8d7sEAfqmQ6gBpE0pfRF/jGa6bTzqyMbK4WQbcRk9RvBpsd8+aml7dzk/sY805vaSJL0vjzWe2LuIIFcCgh/AIQFlS5c/jRhnbCpmdURqJBCNMgEMWuEYBddGcthJvDjVfoFq1On/Ey7YwIOxRJVwH+I5uGzUdy6U05l2LMGRL2tLK4zC/8j02nJdrd3HM+QlIkVUC8/e3wgGSOv2QX/Al30rOYFgEbGqxMzpqrMj96SO3Dpjxbq1lYlf3bWHuK468mNzL4Cc1qSmiN39M+zgF3eWINZWcHw68ibUULxGpDXQDfMfb7eHJcebCm8xikwYEiwwCg+zBZ9Zd6yO0LjHDPgSuV4ARW9WSVH4MrJLPh3ciijJbGw0nck2Q7i4Qd8fc1X3gOD/0Jd3DI3iImAmK4FcVRDLGUItDbMsckJAdpiHCvJQnQrMn0ZBHCa/rz7lmQnfyuqCp1PW7jP3toHajD+ymZDHxcchqPAyf64ITck2VkxqbBEeKBtxXopN0Xg1AlL0WjU4UdIUHQftCD05JDK3rTYOGKavQD0cgAJ7XyqqL1gNS2QD1a3Sk49jB+R8uajZ3VJcIf6J41n3m3HT5sB/HQBCCvGZOjVl9hk85PH
 XI+Vn3Ss
 5KAeXBq3fCrBfczx4pJJyI1Lx5j57cZBYceytkk1y2u3Ft3vkj8bgOvKSgx9Gtqs9OlBeurqCmG7Vh89bjYWhV5NYXEVF132Xy8dcJ/ZUgI/N/uZETnY6gcIRAeTlVn9KMcxjfzZ6iG/pft+NYDPv8GHlF1w97vkyZIc+/myXqFpR0581M3mlBaORAkLup2T9p8qOBY44Ygx09fuzYNIO04oOAK6G4k+hUkjJK7YGPzvzp2+UH27s8afF6rfTjCJobmOsCS+owpXCYEI8Ei5eew0i8QSxFeRi61c+XiY5XsVK7llqZilN4RyvBstxBDbCY//q4Dv4fZk8h+qZHdIMAepV5F9mNZ9GiK+A7LpPHGKteSHEmuFFksiVcTDTqZB3Ugg4E4dWiayixE7Jd/Ma8UuOVSRZ6y8YTViswM7xf3a4V8RD+0sDJcdgVVtqNqY6O3Je0hiXaz0Ti1f4NVjpj3JQ/EsoYUU21ZyKhGESIUb2fHc91WGTN6CkGQKux9bD/TpxWdbM/B8M2mExTWEzGC+E8SToAno2Wq+Jo/M+yQlZFLtYCj4n1cBoEIOMX5Qxik7h323CHit9pOsKefeGt3c3Qg74kLBrYwjS7wNmtrXGkPA1gf5G91VC52NLUMo/J1VwHQZq4p1zYhIofV55Yv6owPX5mgegDfCCloCdHMt6FuhxTaSn31PI+w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a proposal to leverage protection keys (pkeys) to harden
critical kernel data, by making it mostly read-only. The series includes
a simple framework called "kpkeys" to manipulate pkeys for in-kernel use,
as well as a page table hardening feature based on that framework,
"kpkeys_hardened_pgtables". Both are implemented on arm64 as a proof of
concept, but they are designed to be compatible with any architecture
that supports pkeys.

The proposed approach is a typical use of pkeys: the data to protect is
mapped with a given pkey P, and the pkey register is initially configured
to grant read-only access to P. Where the protected data needs to be
written to, the pkey register is temporarily switched to grant write
access to P on the current CPU.

The key fact this approach relies on is that the target data is
only written to via a limited and well-defined API. This makes it
possible to explicitly switch the pkey register where needed, without
introducing excessively invasive changes, and only for a small amount of
trusted code.

Page tables were chosen as they are a popular (and critical) target for
attacks, but there are of course many others - this is only a starting
point (see section "Further use-cases"). It has become more and more
common for accesses to such target data to be mediated by a hypervisor
in vendor kernels; the hope is that kpkeys can provide much of that
protection in a simpler and cheaper manner. A rough performance
estimation has been performed on a modern arm64 system, see section
"Performance".

This series has similarities with the "PKS write protected page tables"
series posted by Rick Edgecombe a few years ago [1], but it is not
specific to x86/PKS - the approach is meant to be generic.

kpkeys
======

The use of pkeys involves two separate mechanisms: assigning a pkey to
pages, and defining the pkeys -> permissions mapping via the pkey
register. This is implemented through the following interface:

- Pages in the linear mapping are assigned a pkey using set_memory_pkey().
  This is sufficient for this series, but of course higher-level
  interfaces can be introduced later to ask allocators to return pages
  marked with a given pkey. It should also be possible to extend this to
  vmalloc() if needed.

- The pkey register is configured based on a *kpkeys level*. kpkeys
  levels are simple integers that correspond to a given configuration,
  for instance:

  KPKEYS_LVL_DEFAULT:
        RW access to KPKEYS_PKEY_DEFAULT
        RO access to any other KPKEYS_PKEY_*

  KPKEYS_LVL_<FEAT>:
        RW access to KPKEYS_PKEY_DEFAULT
        RW access to KPKEYS_PKEY_<FEAT>
        RO access to any other KPKEYS_PKEY_*

  Only pkeys that are managed by the kpkeys framework are impacted;
  permissions for other pkeys are left unchanged (this allows for other
  schemes using pkeys to be used in parallel, and arch-specific use of
  certain pkeys).

  The kpkeys level is changed by calling kpkeys_set_level(), setting the
  pkey register accordingly and returning the original value. A
  subsequent call to kpkeys_restore_pkey_reg() restores the kpkeys
  level. The numeric value of KPKEYS_LVL_* (kpkeys level) is purely
  symbolic and thus generic, however each architecture is free to define
  KPKEYS_PKEY_* (pkey value).

kpkeys_hardened_pgtables
========================

The kpkeys_hardened_pgtables feature uses the interface above to make
the (kernel and user) page tables read-only by default, enabling write
access only in helpers such as set_pte(). One complication is that those
helpers as well as page table allocators are used very early, before
kpkeys become available. Enabling kpkeys_hardened_pgtables, if and when
kpkeys become available, is therefore done as follows:

1. A static key is turned on. This enables a transition to
   KPKEYS_LVL_PGTABLES in all helpers writing to page tables, and also
   impacts page table allocators (step 3).

2. swapper_pg_dir is walked to set all early page table pages to
   KPKEYS_PKEY_PGTABLES.

3. Page table allocators set the returned pages to KPKEYS_PKEY_PGTABLES
   (and the pkey is reset upon freeing). This ensures that all page
   tables are mapped with that privileged pkey.

This series
===========

The series is composed of two parts:

- The kpkeys framework (patch 1-9). The main API is introduced in
  <linux/kpkeys.h>, and it is implemented on arm64 using the POE
  (Permission Overlay Extension) feature.

- The kpkeys_hardened_pgtables feature (patch 10-18). <linux/kpkeys.h>
  is extended with an API to set page table pages to a given pkey and a
  guard object to switch kpkeys level accordingly, both gated on a
  static key. This is then used in generic and arm64 pgtable handling
  code as needed. Finally a simple KUnit-based test suite is added to
  demonstrate the page table protection.

pkey register management
========================

The kpkeys model relies on the kernel pkey register being set to a
specific value for the duration of a relatively small section of code,
and otherwise to the default value. Accordingly, the arm64
implementation based on POE handles its pkey register (POR_EL1) as
follows:

- POR_EL1 is saved and reset to its default value on exception entry,
  and restored on exception return. This ensures that exception handling
  code runs in a fixed kpkeys state.

- POR_EL1 is context-switched per-thread. This allows sections of code
  that run at a non-default kpkeys level to sleep (e.g. when locking a
  mutex). For kpkeys_hardened_pgtables, only involuntary preemption is
  relevant and the previous point already handles that; however sleeping
  is likely to occur in more advanced uses of kpkeys.

An important assumption is that all kpkeys levels allow RW access to the
default pkey (0). Otherwise, saving POR_EL1 before resetting it on
exception entry would be a best difficult, and context-switching it too.

Performance
===========

No arm64 hardware currently implements POE. To estimate the performance
impact of kpkeys_hardened_pgtables, a mock implementation of kpkeys has
been used, replacing accesses to the POR_EL1 register with accesses to
another system register that is otherwise unused (CONTEXTIDR_EL1), and
leaving everything else unchanged. Most of the kpkeys overhead is
expected to originate from the barrier (ISB) that is required after
writing to POR_EL1, and from setting the POIndex (pkey) in page tables;
both of these are done exactly in the same way in the mock
implementation.

The original implementation of kpkeys_hardened_pgtables is very
inefficient when many PTEs are changed at once, as the kpkeys level is
switched twice for every PTE (two ISBs per PTE). Patch 18 introduces
an optimisation that makes use of the lazy_mmu mode to batch those
switches: 1. switch to KPKEYS_LVL_PGTABLES on arch_enter_lazy_mmu_mode(),
2. skip any kpkeys switch while in that section, and 3. restore the
kpkeys level on arch_leave_lazy_mmu_mode(). When that last function
already issues an ISB (when updating kernel page tables), we get a
further optimisation as we can skip the ISB when restoring the kpkeys
level.

Both implementations (without and with batching) were evaluated on an
Amazon EC2 M7g instance (Graviton3), using a variety of benchmarks that
involve heavy page table manipulations. The results shown below are
relative to the baseline for this series, which is 6.17-rc1. The
branches used for all three sets of results (baseline, with/without
batching) are available in a repository, see next section.

Caveat: these numbers should be seen as a lower bound for the overhead
of a real POE-based protection. The hardware checks added by POE are
however not expected to incur significant extra overhead.

Reading example: for the fix_size_alloc_test benchmark, using 1 page per
iteration (no hugepage), kpkeys_hardened_pgtables incurs 17.35% overhead
without batching, and 14.62% overhead with batching. Both results are
considered statistically significant (95% confidence interval),
indicated by "(R)".

+-------------------+----------------------------------+------------------+---------------+
| Benchmark         | Result Class                     | Without batching | With batching |
+===================+==================================+==================+===============+
| mmtests/kernbench | real time                        |            0.30% |         0.11% |
|                   | system time                      |        (R) 3.97% |     (R) 2.17% |
|                   | user time                        |            0.12% |         0.02% |
+-------------------+----------------------------------+------------------+---------------+
| micromm/fork      | fork: h:0                        |      (R) 217.31% |        -0.97% |
|                   | fork: h:1                        |      (R) 275.25% |     (R) 2.25% |
+-------------------+----------------------------------+------------------+---------------+
| micromm/munmap    | munmap: h:0                      |       (R) 15.57% |        -1.95% |
|                   | munmap: h:1                      |      (R) 169.53% |     (R) 6.53% |
+-------------------+----------------------------------+------------------+---------------+
| micromm/vmalloc   | fix_size_alloc_test: p:1, h:0    |       (R) 17.35% |    (R) 14.62% |
|                   | fix_size_alloc_test: p:4, h:0    |       (R) 37.54% |     (R) 9.35% |
|                   | fix_size_alloc_test: p:16, h:0   |       (R) 66.08% |     (R) 3.15% |
|                   | fix_size_alloc_test: p:64, h:0   |       (R) 82.94% |        -0.39% |
|                   | fix_size_alloc_test: p:256, h:0  |       (R) 87.85% |        -1.67% |
|                   | fix_size_alloc_test: p:16, h:1   |       (R) 50.31% |         3.00% |
|                   | fix_size_alloc_test: p:64, h:1   |       (R) 59.73% |         2.23% |
|                   | fix_size_alloc_test: p:256, h:1  |       (R) 62.14% |         1.51% |
|                   | random_size_alloc_test: p:1, h:0 |       (R) 77.82% |        -0.21% |
|                   | vm_map_ram_test: p:1, h:0        |       (R) 30.66% |    (R) 27.30% |
+-------------------+----------------------------------+------------------+---------------+

Benchmarks:
- mmtests/kernbench: running kernbench (kernel build) [4].
- micromm/{fork,munmap}: from David Hildenbrand's benchmark suite. A
  1 GB mapping is created and then fork/unmap is called. The mapping is
  created using either page-sized (h:0) or hugepage folios (h:1); in all
  cases the memory is PTE-mapped.
- micromm/vmalloc: from test_vmalloc.ko, varying the number of pages
  (p:) and whether huge pages are used (h:).

On a "real-world" and fork-heavy workload like kernbench, the estimated
overhead of kpkeys_hardened_pgtables is reasonable: 4% system time
overhead without batching, and about half that figure (2.2%) with
batching. The real time overhead is negligible.

Microbenchmarks show large overheads without batching, which increase
with the number of pages being manipulated. Batching drastically reduces
that overhead, almost negating it for micromm/fork. Because all PTEs in
the mapping are modified in the same lazy_mmu section, the kpkeys level
is changed just twice regardless of the mapping size; as a result the
relative overhead actually decreases as the size increases for
fix_size_alloc_test.

Note: the performance impact of set_memory_pkey() is likely to be
relatively low on arm64 because the linear mapping uses PTE-level
descriptors only. This means that set_memory_pkey() simply changes the
attributes of some PTE descriptors. However, some systems may be able to
use higher-level descriptors in the future [5], meaning that
set_memory_pkey() may have to split mappings. Allocating page tables
from a contiguous cache of pages could help minimise the overhead, as
proposed for x86 in [1].

Branches
========

To make reviewing and testing easier, this series is available here:

  https://gitlab.arm.com/linux-arm/linux-kb

The following branches are available:

- kpkeys/rfc-v5 - this series, as posted

- kpkeys/rfc-v5-base - the baseline for this series, that is 6.17-rc1

- kpkeys/rfc-v5-bench-batching - this series + patch for benchmarking on
  a regular arm64 system (see section above)

- kpkeys/rfc-v5-bench-no-batching - this series without patch 18
  (batching) + benchmarking patch

Threat model
============

The proposed scheme aims at mitigating data-only attacks (e.g.
use-after-free/cross-cache attacks). In other words, it is assumed that
control flow is not corrupted, and that the attacker does not achieve
arbitrary code execution. Nothing prevents the pkey register from being
set to its most permissive state - the assumption is that the register
is only modified on legitimate code paths.

A few related notes:

- Functions that set the pkey register are all implemented inline.
  Besides performance considerations, this is meant to avoid creating
  a function that can be used as a straightforward gadget to set the
  pkey register to an arbitrary value.

- kpkeys_set_level() only accepts a compile-time constant as argument,
  as a variable could be manipulated by an attacker. This could be
  relaxed but it seems unlikely that a variable kpkeys level would be
  needed in practice.

Further use-cases
=================

It should be possible to harden various targets using kpkeys, including:

- struct cred - kpkeys-based cred hardening is now available in a
  separate series [6]

- fixmap (occasionally used even after early boot, e.g.
  set_swapper_pgd() in arch/arm64/mm/mmu.c)

- eBPF programs (preventing direct access to core kernel code/data)

- SELinux state (e.g. struct selinux_state::initialized)

... and many others.

kpkeys could also be used to strengthen the confidentiality of secret
data by making it completely inaccessible by default, and granting
read-only or read-write access as needed. This requires such data to be
rarely accessed (or via a limited interface only). One example on arm64
is the pointer authentication keys in thread_struct, whose leakage to
userspace would lead to pointer authentication being easily defeated.

Open questions
==============

A few aspects in this RFC that are debatable and/or worth discussing:

- There is currently no restriction on how kpkeys levels map to pkeys
  permissions. A typical approach is to allocate one pkey per level and
  make it writable at that level only. As the number of levels
  increases, we may however run out of pkeys, especially on arm64 (just
  8 pkeys with POE). Depending on the use-cases, it may be acceptable to
  use the same pkey for the data associated to multiple levels.

  Another potential concern is that a given piece of code may require
  write access to multiple privileged pkeys. This could be addressed by
  introducing a notion of hierarchy in trust levels, where Tn is able to
  write to memory owned by Tm if n >= m, for instance.

- kpkeys_set_level() and kpkeys_restore_pkey_reg() are not symmetric:
  the former takes a kpkeys level and returns a pkey register value, to
  be consumed by the latter. It would be more intuitive to manipulate
  kpkeys levels only. However this assumes that there is a 1:1 mapping
  between kpkeys levels and pkey register values, while in principle
  the mapping is 1:n (certain pkeys may be used outside the kpkeys
  framework).

- An architecture that supports kpkeys is expected to select
  CONFIG_ARCH_HAS_KPKEYS and always enable them if available - there is
  no CONFIG_KPKEYS to control this behaviour. Since this creates no
  significant overhead (at least on arm64), it seemed better to keep it
  simple. Each hardening feature does have its own option and arch
  opt-in if needed (CONFIG_KPKEYS_HARDENED_PGTABLES,
  CONFIG_ARCH_HAS_KPKEYS_HARDENED_PGTABLES).


Any comment or feedback will be highly appreciated, be it on the
high-level approach or implementation choices!

- Kevin

---
Changelog

RFC v4..v5:

- Rebased on v6.17-rc1.

- Cover letter: re-ran benchmarks on top of v6.17-rc1, made various
  small improvements especially to the "Performance" section.

- Patch 18: disable batching while in interrupt, since POR_EL1 is reset
  on exception entry, making the TIF_LAZY_MMU flag meaningless. This
  fixes a crash that may occur when a page table page is freed while in
  interrupt context.

- Patch 17: ensure that the target kernel address is actually
  PTE-mapped. Certain mappings (e.g. code) may be PMD-mapped instead -
  this explains why the change made in v4 was required.


RFC v4: https://lore.kernel.org/linux-mm/20250411091631.954228-1-kevin.brodsky@arm.com/

RFC v3..v4:

- Added appropriate handling of the arm64 pkey register (POR_EL1):
  context-switching between threads and resetting on exception entry
  (patch 7 and 8). See section "pkey register management" above for more
  details. A new POR_EL1_INIT macro is introduced to make the default
  value available to assembly (where POR_EL1 is reset on exception
  entry); it is updated in each patch allocating new keys.

- Added patch 18 making use of the lazy_mmu mode to batch switches to
  KPKEYS_LVL_PGTABLES - just once per lazy_mmu section rather than on
  every pgtable write. See section "Performance" for details.

- Rebased on top of [2]. No direct impact on the patches, but it ensures that
  the ctor/dtor is always called for kernel pgtables. This is an
  important fix as kernel PTEs allocated after boot were not protected
  by kpkeys_hardened_pgtables in v3 - a new test was added to patch 17
  to ensure that pgtables created by vmalloc are protected too.

- Rebased on top of [3]. The batching of kpkeys level switches in patch
  18 relies on the last patch in [3].

- Moved kpkeys guard definitions out of <linux/kpkeys.h> and to a relevant
  header for each subsystem (e.g. <asm/pgtable.h> for the
  kpkeys_hardened_pgtables guard).

- Patch 1,5: marked kpkeys_{set_level,restore_pkey_reg} as
  __always_inline to ensure that no callable gadget is created.
  [Maxwell Bland's suggestion]

- Patch 5: added helper __kpkeys_set_pkey_reg_nosync().

- Patch 10: marked kernel_pgtables_set_pkey() and related helpers as
  __init. [Linus Walleij's suggestion]

- Patch 11: added helper kpkeys_hardened_pgtables_enabled(), renamed the
  static key to kpkeys_hardened_pgtables_key.

- Patch 17: followed the KUnit conventions more closely. [Kees Cook's
  suggestion]

- Patch 17: changed the address used in the write_linear_map_pte()
  test. It seems that the PTEs that map some functions are allocated in
  ZONE_DMA and read-only (unclear why exactly). This doesn't seem to
  occur for global variables.

- Various minor fixes/improvements.

- Rebased on v6.15-rc1. This includes [7], which renames a few POE
  symbols: s/POE_RXW/POE_RWX/ and
  s/por_set_pkey_perms/por_elx_set_pkey_perms/


RFC v3: https://lore.kernel.org/linux-hardening/20250203101839.1223008-1-kevin.brodsky@arm.com/

RFC v2..v3:

- Patch 1: kpkeys_set_level() may now return KPKEYS_PKEY_REG_INVAL to indicate
  that the pkey register wasn't written to, and as a result that
  kpkeys_restore_pkey_reg() should do nothing. This simplifies the conditional
  guard macro and also allows architectures to skip writes to the pkey
  register if the target value is the same as the current one.

- Patch 1: introduced additional KPKEYS_GUARD* macros to cover more use-cases
  and reduce duplication.

- Patch 6: reject pkey value above arch_max_pkey().

- Patch 13: added missing guard(kpkeys_hardened_pgtables) in
  __clear_young_dirty_pte().

- Rebased on v6.14-rc1.

RFC v2: https://lore.kernel.org/linux-hardening/20250108103250.3188419-1-kevin.brodsky@arm.com/

RFC v1..v2:

- A new approach is used to set the pkey of page table pages. Thanks to
  Qi Zheng's and my own series [8][9], pagetable_*_ctor is
  systematically called when a PTP is allocated at any level (PTE to
  PGD), and pagetable_*_dtor when it is freed, on all architectures.
  Patch 11 makes use of this to call kpkeys_{,un}protect_pgtable_memory
  from the common ctor/dtor helper. The arm64 patches from v1 (patch 12
  and 13) are dropped as they are no longer needed. Patch 10 is
  introduced to allow pagetable_*_ctor to fail at all levels, since
  kpkeys_protect_pgtable_memory may itself fail.
  [Original suggestion by Peter Zijlstra]

- Changed the prototype of kpkeys_{,un}protect_pgtable_memory in patch 9
  to take a struct folio * for more convenience, and implemented them
  out-of-line to avoid a circular dependency with <linux/mm.h>.

- Rebased on next-20250107, which includes [8] and [9].

- Added locking in patch 8. [Peter Zijlstra's suggestion]

RFC v1: https://lore.kernel.org/linux-hardening/20241206101110.1646108-1-kevin.brodsky@arm.com/
---
References

[1] https://lore.kernel.org/all/20210830235927.6443-1-rick.p.edgecombe@intel.com/
[2] https://lore.kernel.org/linux-mm/20250408095222.860601-1-kevin.brodsky@arm.com/
[3] https://lore.kernel.org/linux-mm/20250304150444.3788920-1-ryan.roberts@arm.com/
[4] https://github.com/gormanm/mmtests/blob/master/shellpack_src/src/kernbench/kernbench-bench
[5] https://lore.kernel.org/all/20250724221216.1998696-1-yang@os.amperecomputing.com/
[6] https://lore.kernel.org/linux-mm/?q=s%3Apkeys+s%3Acred+s%3A0
[7] https://lore.kernel.org/linux-arm-kernel/20250219164029.2309119-1-kevin.brodsky@arm.com/
[8] https://lore.kernel.org/linux-mm/cover.1736317725.git.zhengqi.arch@bytedance.com/
[9] https://lore.kernel.org/linux-mm/20250103184415.2744423-1-kevin.brodsky@arm.com/
---
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Maxwell Bland <mbland@motorola.com>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Pierre Langlois <pierre.langlois@arm.com>
Cc: Quentin Perret <qperret@google.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-mm@kvack.org
Cc: x86@kernel.org
---
Kevin Brodsky (18):
  mm: Introduce kpkeys
  set_memory: Introduce set_memory_pkey() stub
  arm64: mm: Enable overlays for all EL1 indirect permissions
  arm64: Introduce por_elx_set_pkey_perms() helper
  arm64: Implement asm/kpkeys.h using POE
  arm64: set_memory: Implement set_memory_pkey()
  arm64: Reset POR_EL1 on exception entry
  arm64: Context-switch POR_EL1
  arm64: Enable kpkeys
  mm: Introduce kernel_pgtables_set_pkey()
  mm: Introduce kpkeys_hardened_pgtables
  mm: Allow __pagetable_ctor() to fail
  mm: Map page tables with privileged pkey
  arm64: kpkeys: Support KPKEYS_LVL_PGTABLES
  arm64: mm: Guard page table writes with kpkeys
  arm64: Enable kpkeys_hardened_pgtables support
  mm: Add basic tests for kpkeys_hardened_pgtables
  arm64: mm: Batch kpkeys level switches

 arch/arm64/Kconfig                        |   2 +
 arch/arm64/include/asm/kpkeys.h           |  62 +++++++++
 arch/arm64/include/asm/pgtable-prot.h     |  16 +--
 arch/arm64/include/asm/pgtable.h          |  57 +++++++-
 arch/arm64/include/asm/por.h              |  11 ++
 arch/arm64/include/asm/processor.h        |   2 +
 arch/arm64/include/asm/ptrace.h           |   4 +
 arch/arm64/include/asm/set_memory.h       |   4 +
 arch/arm64/kernel/asm-offsets.c           |   3 +
 arch/arm64/kernel/cpufeature.c            |   5 +-
 arch/arm64/kernel/entry.S                 |  24 +++-
 arch/arm64/kernel/process.c               |   9 ++
 arch/arm64/kernel/smp.c                   |   2 +
 arch/arm64/mm/fault.c                     |   2 +
 arch/arm64/mm/mmu.c                       |  26 ++--
 arch/arm64/mm/pageattr.c                  |  25 ++++
 include/asm-generic/kpkeys.h              |  21 +++
 include/asm-generic/pgalloc.h             |  15 ++-
 include/linux/kpkeys.h                    | 157 ++++++++++++++++++++++
 include/linux/mm.h                        |  27 ++--
 include/linux/set_memory.h                |   7 +
 mm/Kconfig                                |   5 +
 mm/Makefile                               |   2 +
 mm/kpkeys_hardened_pgtables.c             |  44 ++++++
 mm/memory.c                               | 137 +++++++++++++++++++
 mm/tests/kpkeys_hardened_pgtables_kunit.c | 106 +++++++++++++++
 security/Kconfig.hardening                |  24 ++++
 27 files changed, 758 insertions(+), 41 deletions(-)
 create mode 100644 arch/arm64/include/asm/kpkeys.h
 create mode 100644 include/asm-generic/kpkeys.h
 create mode 100644 include/linux/kpkeys.h
 create mode 100644 mm/kpkeys_hardened_pgtables.c
 create mode 100644 mm/tests/kpkeys_hardened_pgtables_kunit.c


base-commit: 8f5ae30d69d7543eee0d70083daf4de8fe15d585
-- 
2.47.0


