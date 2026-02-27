Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91272FEFB6E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 17:55:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B61206B0005; Fri, 27 Feb 2026 12:55:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B38EB6B0088; Fri, 27 Feb 2026 12:55:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0D856B0089; Fri, 27 Feb 2026 12:55:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 81A926B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:55:47 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E7728C2760
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:55:46 +0000 (UTC)
X-FDA: 84490989492.07.DB8002B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id C7D4EC000D
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:55:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772214945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=QT4lGOiDabSkBcBNhAsVAf4zUds0OGjregrfqawFwjo=;
	b=YsW2wGw73utkTc/e2xbYoiaKk5H2GoSVaKWd8W4VNkDiVGJ38fJq4d9OQwMKgBHhY5dMVu
	M3HqaUx18AkmeS8PCVVe3wIbTp6+e3mkfFvgYwVvHdJB8BZ6IVQcB95e7UalG/AEeItpG5
	xk/q2FjGFATG+Gg5TGp4NtWyy/RJS+Q=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772214945; a=rsa-sha256;
	cv=none;
	b=U+9d4VRJot7ry2tlvx19tE8yYU/DgwHsnAx6ZmgEUd7arQd77rr7k8VDdvAjGV26ti/W3B
	TxmRQ594zkDfQDqMykWkqYCeN+YFtQZkluxxd9e+eg9XDfaeYViBPseJrWUBTSsBLsaqfw
	KoRFzkz0+FWQAPbYTQ3q8fndbC+spKo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3A0F414BF;
	Fri, 27 Feb 2026 09:55:37 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D8F6F3F73B;
	Fri, 27 Feb 2026 09:55:38 -0800 (PST)
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
	Yang Shi <yang@os.amperecomputing.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org
Subject: [PATCH v6 00/30] pkeys-based page table hardening
Date: Fri, 27 Feb 2026 17:54:48 +0000
Message-ID: <20260227175518.3728055-1-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C7D4EC000D
X-Stat-Signature: 875gcjixkxzbw9drbkzm7zz8p54c3pbt
X-Rspam-User: 
X-HE-Tag: 1772214944-939582
X-HE-Meta: U2FsdGVkX1/nHAC0MWK5FaRXy0dFc947E2FbsxI/a2pnPlwYxQFbEvLM5BdQQSBx3iymGJ922nNWjftSQ69+ugfXXZP94nhiDeoHMfmlWeRbzK8d3nnIDnMDq2synUXU3iZNAHtGt8cneYpM1QlSGVlV7Z2w6mezGH24QUuAvnWGNBVitlG5Knza3NIJ+yUrh9ijaZyKO7MmRtskLqLHTnFCZO6Q19Qox6X1smBVmMBhpYEFjzqKcpcCgs0Yn3wUk8CNDQu9LXEaXSqx9nMmeBiiYbCxJpQrbXbycFNx5uD7S3aRmUHmMCp9V28vKN2avFvv7VaZgaENRzNSmrLO7hCLl1NPf/+nIPz2Q5D+em7qCN2pKj9mH3I4V03D1Zf0sAW6qrKCe9BvlwOPUTjLQZCLlaQtdvnH6Yd4OQrzxmUgOClY+2McN7rhYg1ylXB6IFXBQhsYNWf91XPFveZMXUtC9kty8EWZ5nE46TTwVAA3YNqJae9A3c0rK3mB+brjBlVXbSIwHUvN15/eo0dWWikeJ8tLFYBM+ueIEbvVFTH1trLIYSRGltuDpO+DXdEyhPCEfoR7NevM+gMYsOH9VqpeMUD/tjSIp1A/Kj0u/bfnZmpDFCSGlGTSOY3UHE4kJcg+u8meZ5PVk6gVLldMLbz3ykrKBIgm3overoaZnldxBAC+q3MO8EK2TGWtwJFJckZUwyRhJVspJRmW4n+Cpghr1RIAmpneo4IxHqs6h0XRDaUvV6MM0Y6PadN/p50ZUvDRNixUEHraDPDjgjlLQQ1BV0jBqwktyyjxVClGWwx0SuPJ4bMMLNw7guGjV64GTWh+orfDuYwtu6imXbf1rgchhp9tN+X2RwL51of2Z1/CiAO61wmYrWlSYsHNWP3yLUqNQHwndos6NbLx0Nu9hNo/KX0ZClMLKPk31wuEmnyzw+hUYQhxlBeHb3h9j/BrZJO6pHTaPF1OiwrGUCA
 AfW58FMK
 HQJ9l+FJV+QMYoQRioPd8gR7/ftm8mp2LBIys9NkwfdLjx0ikijgUjfbokFsWGIJCDZ6Kx6WFd1GhzxaYDh/jJ2J7RnB7CtESJUzWl6hvRONRIKO+x6U6YPBOGhWorU/sDdQf+msBTyLvhcISjKudgAEuWITwlDEB0ytsP+zbmMw0+1dA0cbqFSX2kC92P9+IKQQEj8Fac/1SiZp1ETy5Z2nuvHKXQ9WtslKa2H59FJWXZi/r0DO5ku2sEm2e9HjxvA2qzWq/yjX8q96yZP+j0mIpFP/vJhg8CVakGxCDpWZBrmF9YHN3MS7vh+c6gZAbrIr/4LE80x5qlz85OvJC+D0j5CSEaJaVF5PD/XUeT00ve6CHmC00KPW5RB50IQTbd+thdrAP/RmEjQlt2jMAghabbo4eKmZ4FwwmNHRdxis5KMvLIsT4cVeJYR1jBTHAA+u2rqxV3LbwVcHENcJQ4q92MJ+JMhYdcyqO8dLuvkdtgYCPdOwbHlLuuv3raKEAJctWfR6p2IAtwMrs/dhBdPfHqfhZyG0YnYKd7tKzU65H9qg/rH2G8u2CHqSZGwIrEwFhcQoITiVyO6rw6+fLQQyiH3INR7/D7tKyJhBvf+fdsZYVus99IWRGbxmyfhROc0GeoCpiAJ/1lPhPxLoau+ccIxQh4W+NO+aopZ84r+XNL29t33ztBmNDMz0RxS3Hv6vcUvnQn/LEUGfKAPc7Mnj1H6rDkpObOevnNHu4NYp5JSvPe4l/jm1XIlTfiD4a4IaWrkfDOeJJW121XnN2ZitPFb1SeCWkZ61w3fwsYJEPYyVf2z2CbrwDgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

NEW in v6: support for large block mappings through a dedicated page table
allocator (patch 14-17)

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
protection with a reduced complexity and overhead. A rough performance
estimation has been performed on a modern arm64 system, see section
"Performance".

This series (especially v6) has similarities with the "PKS write
protected page tables" series posted by Rick Edgecombe a few years ago
[1] but it is not specific to x86/PKS - the approach is meant to be
generic.

This proposal was presented at Linux Security Summit Europe 2025 [2].
Note that changes in v6 (notably the dedicated page table allocator)
are not covered in that talk.

[Table of contents]

* kpkeys
  - pkey register management

* kpkeys_hardened_pgtables
  - Protected page table allocation
  - kpkeys level switching
  - Performance
  - Limitations

* This series
  - Branches

* Threat model

* Further use-cases

* Open questions


kpkeys
======

The use of pkeys involves two separate mechanisms: assigning a pkey to
pages, and defining the pkeys -> permissions mapping via the pkey
register. This is implemented through the following interface:

- Pages are assigned a pkey in the linear map using set_memory_pkey().
  This is sufficient for this series, but it is also plausible for
  higher-level allocators to support marking allocations with a given
  pkey.

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

pkey register management
------------------------

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
default pkey (0). Removing this assumption requires significant
reworking of the way POR_EL1 is saved/restored on exception entry and
context switch.


kpkeys_hardened_pgtables
========================

The kpkeys_hardened_pgtables feature uses the interface above to make
the (kernel and user) page tables read-only by default, enabling write
access only in helpers such as set_pte(). An efficient implementation
requires careful consideration; this is detailed in the following
subsections.

Protected page table allocation
-------------------------------

Kernel page tables are required as soon as the MMU is turned on, i.e.
extremely early. Different allocators are therefore used to obtain
page table pages (PTPs), depending on where we are in the boot sequence.
In chronological order:

1. Static pools (in the kernel image itself). This is typically used to
   map the kernel image. By definition these pools have a fixed size.

2. memblock. This is notably used to create the linear map.

3. Buddy allocator, via pagetable_alloc(). Used for everything else,
   including user page tables, once available.

Previously (until v5), this series relied on pagetable_*_ctor() to set
the pkey of each PTP allocated at step 3 and walked the kernel page
tables on boot to set the pkey of earlier PTPs (1. and 2.). This worked
fine, but it relied on the crucial assumption that the linear map is
fully PTE-mapped - in other words, that it is possible to set the pkey
for a page simply by changing the attributes of an existing PTE.

This assumption no longer holds on some arm64 systems, since [3], and it
never has on x86. The linear map may be created using block mappings
(PMD/PUD level). As a result, setting the pkey for one page may require
splitting block(s) down to PTEs. This creates extra overhead and may
lead to recursion, as the PTPs allocated for splitting themselves need
to be protected, and setting their pkey could lead to splitting as well.

From v6, this series therefore attempts to allocate PTPs in PMD-sized
blocks whenever possible. PTPs allocated in that manner are protected
very efficiently by setting the pkey at PMD level. Still, splitting
cannot be totally eliminated: PUD blocks need to be split, large
physically contiguous blocks may not be available on long-running
systems, and unused pages must have their pkey reset before being
eventually returned to the buddy allocator.

There have been attempts to address this issue before, notably in Rick's
series [1] with the same aim, and Mike Rapoport's proposal [4] for
unmapping regions of the linear map. Consensus has not been reached on
any of them, unfortunately. This series draws inspiration from those
attempts and introduces its own allocator. It does not aim to address
linear map fragmentation in general; on the contrary, it is designed
specifically to allocate pkey-protected PTPs, ideally in blocks, and
prevent any recursion while splitting the linear map.

This series protects the different sources of PTPs listed above as
follows:

1. Static pools are mostly contiguous already so they are left
   unchanged. A hook is introduced to allow the arch to set the pkey of
   those PTPs later during boot.

2. A separate memblock-based allocator is introduced for early page
   tables. This is a very simple allocator that obtains memory from
   memblock in large blocks. Since the linear map may not be ready yet,
   those blocks are tracked so that their pkey can be set later.

3. The main pkeys block allocator, based on the buddy allocator and
   hooked into pagetable_alloc(). In this initial prototype, a single
   global freelist is used. Its cache is refilled in whole PMD-sized
   blocks if possible, with fallback orders in case of memory pressure.
   A reserve of pages is kept available to allow splitting the linear
   map without any memory allocation. A shrinker is also included to
   allow cached pages to be reclaimed, while attempting to reduce block
   splitting.

The pkeys block allocator slightly increases the risk of allocation
failure because it must refill at least at order 2 (4 pages), since
splitting may use up to 2 pages whenever allocating at low orders.
This is deemed acceptable, and a net improvement over [1] where enough
pages were reserved to split the entire linear map down to PTEs.

All this infrastructure is generic. This series only includes the
required plumbing for arm64 (and some arm64 tuning for the refill
orders), but it is meant to be plumbed into x86 in a similar manner.

kpkeys level switching
----------------------

Page tables are only supposed to be written via a fairly small set of
helpers, so only a few switches to a privileged kpkeys level need to be
introduced.

However, a naive implementation is very inefficient when many PTEs are
changed at once, as the kpkeys level is switched twice for every PTE. On
arm64, this means two barriers (ISBs) per PTE. This is optimised by
making use of the lazy MMU mode to batch those switches: 1. switch to
KPKEYS_LVL_PGTABLES on arch_enter_lazy_mmu_mode(), 2. skip any kpkeys
switch while in that section, and 3. restore the kpkeys level on
arch_leave_lazy_mmu_mode(). When that last function already issues an
ISB (when updating kernel page tables), we get a further optimisation as
we can skip the ISB when restoring the kpkeys level.

The lazy MMU mode may be enabled/disabled in a nested manner. This is
handled in v6 thanks to [5] (merged in 7.0-rc1) - if nesting occurs,
only the outer section will switch kpkeys level.

Performance
-----------

No arm64 hardware currently implements POE. To estimate the performance
impact of kpkeys_hardened_pgtables, a mock implementation of kpkeys has
been used, replacing accesses to the POR_EL1 register with accesses to
another system register that is otherwise unused (CONTEXTIDR_EL1), and
leaving everything else unchanged. Most of the kpkeys overhead is
expected to originate from the barrier (ISB) that is required after
writing to POR_EL1, and from setting the POIndex (pkey) in page tables;
both of these are done exactly in the same way in the mock
implementation.

This mock implementation was evaluated on an AmpereOne A192-32X server,
using a variety of benchmarks that involve heavy page table
manipulations. The machine supports BBML2-noabort, which means that
large block mappings can be split and are used to create the linear map
by default since [3].

The table below shows the performance impact of enabling
CONFIG_KPKEYS_HARDENED_PGTABLES in two different configurations:

1. Large block mappings are used; page tables are allocated in blocks as
   per section "Protected page table allocation" above.

2. Large block mappings are not used (BBML2-noabort is force-disabled);
   page tables are allocated and protected individually. This is very
   similar to the approach in v5.

Note that the two sets of results are relative w.r.t. their own
baseline, as disabling large block mappings has performance
implications in itself.

Caveat: these numbers should be seen as a lower bound for the overhead
of a real POE-based protection. The hardware checks added by POE are
however not expected to incur significant extra overhead.

Reading example: for the fix_size_alloc_test benchmark, using 1 page per
iteration (no hugepage), kpkeys_hardened_pgtables incurs 11.20% overhead
with large block mappings, and 10.24% overhead without. Both results are
considered statistically significant (95% confidence interval),
indicated by "(R)".

+-------------------+----------------------------------+----------------------+---------------------+
| Benchmark         | Result Class                     | Large block mappings | PTE-only linear map |
+===================+==================================+======================+=====================+
| mmtests/kernbench | real time                        |               -0.26% |              -0.55% |
|                   | system time                      |               -1.87% |          (R) -2.24% |
|                   | user time                        |                0.01% |              -0.04% |
+-------------------+----------------------------------+----------------------+---------------------+
| micromm/fork      | fork: h:0                        |               -2.04% |          (R) -6.09% |
|                   | fork: h:1                        |           (R) -4.61% |         (R) -13.28% |
+-------------------+----------------------------------+----------------------+---------------------+
| micromm/munmap    | munmap: h:0                      |                1.70% |              -1.23% |
|                   | munmap: h:1                      |               -0.85% |              -0.79% |
+-------------------+----------------------------------+----------------------+---------------------+
| micromm/vmalloc   | fix_size_alloc_test: p:1, h:0    |          (R) -11.20% |         (R) -10.24% |
|                   | fix_size_alloc_test: p:4, h:0    |               -3.12% |              -5.67% |
|                   | fix_size_alloc_test: p:16, h:0   |               -4.09% |              -5.17% |
|                   | fix_size_alloc_test: p:64, h:0   |               -3.86% |              -2.40% |
|                   | fix_size_alloc_test: p:256, h:0  |               -2.14% |          (R) -2.79% |
|                   | fix_size_alloc_test: p:16, h:1   |               -5.74% |              -1.18% |
|                   | fix_size_alloc_test: p:64, h:1   |               -0.99% |               2.17% |
|                   | fix_size_alloc_test: p:256, h:1  |           (R) -2.53% |              -1.33% |
|                   | random_size_alloc_test: p:1, h:0 |           (R) -2.84% |          (R) -3.21% |
|                   | vm_map_ram_test: p:1, h:0        |          (R) -23.31% |         (R) -23.66% |
+-------------------+----------------------------------+----------------------+---------------------+

Benchmarks:
- mmtests/kernbench: running kernbench (kernel build) [6].
- micromm/{fork,munmap}: from David Hildenbrand's benchmark suite. A
  1 GB mapping is created and then fork/unmap is called. The mapping is
  created using either page-sized (h:0) or hugepage folios (h:1); in all
  cases the memory is PTE-mapped.
- micromm/vmalloc: from test_vmalloc.ko, varying the number of pages
  (p:) and whether huge pages are used (h:).

The results are overall very similar in both cases, and in line with the
results from v5 (with batching). On a "real-world" and fork-heavy
workload like kernbench, the estimated overhead of
kpkeys_hardened_pgtables is reasonable, around 2% system time overhead.
The real time overhead is negligible.

Microbenchmarks show some noticeable overheads, which tend to go down
when operating on larger page ranges. Because all PTEs in a given
mapping are modified in the same lazy MMU section, the kpkeys level is
changed just twice regardless of the mapping size; as a result the
relative overhead actually decreases as the size increases for
fix_size_alloc_test.

These results should be taken with a pinch of salt, as in the "large
block mappings" case the baseline (this series with
CONFIG_KPKEYS_HARDENED_PGTABLES disabled) appears to outperform
v7.0-rc1. This is to be investigated; it might explain the large
overhead in the fork benchmarks that wasn't observed in v5.

Limitations
-----------

- More testing/benchmarking is needed to better understand the
  implications of using a global allocator for all page tables. This may
  be beneficial in some cases thanks to the allocator's cache and lower
  linear map fragmentation, but the single global freelist risks
  creating contention.

- Since this series no longer walks kernel page tables to protect early
  PTPs, some of them may have been missed and left unprotected. This is
  notably the case for vmemmap (covered by patch 11 in [1]), and
  possibly for some statically allocated arm64 pools.


This series
===========

The series is composed of two parts:

- The kpkeys framework (patch 1-10). The main API is introduced in
  <linux/kpkeys.h>, and it is implemented on arm64 using the POE
  (Permission Overlay Extension) feature.

- The kpkeys_hardened_pgtables feature (patch 11-30). <linux/kpkeys.h>
  is extended with an API to protect page table pages and a guard object
  to switch kpkeys level accordingly, both gated on a static key. This
  is then used in generic and arm64 pgtable handling code as needed.
  Finally a simple KUnit-based test suite is added to demonstrate the
  page table protection.

Branches
--------

To make reviewing and testing easier, this series is available here:

  https://gitlab.arm.com/linux-arm/linux-kb

The following branches are available:

- kpkeys/rfc-v6 - this series, as posted

- kpkeys/rfc-v6-bench - this series + patch for benchmarking on
  a regular arm64 system (see section above)


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

- struct cred - proposal posted as a separate series [7]

- eBPF programs (preventing direct W/X to core kernel code/data) -
  work in progress [8]

- fixmap (occasionally used even after early boot, e.g.
  set_swapper_pgd() in arch/arm64/mm/mmu.c)

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

- Can the pkeys block allocator be abstracted into something more
  generic? This seems desirable considering other use-cases for changing
  attributes of regions of the linear map, but the handling of page
  tables while splitting may be difficult to integrate in a generic
  allocator.

- There is currently no restriction on how kpkeys levels map to pkeys
  permissions. A typical approach is to allocate one pkey per level and
  make it writable at that level only. As the number of levels
  increases, we may however run out of pkeys, especially on arm64 (just
  8 pkeys with POE). Depending on the use-cases, it may be acceptable to
  use the same pkey for the data associated to multiple levels.


Any comment or feedback is highly appreciated, be it on the high-level
approach or implementation choices!

- Kevin

---
Changelog

RFC v5..v6:

- Rebased on v7.0-rc1 (includes support for splitting large block
  mappings with BBML2-noabort [3] and nested lazy MMU sections [5])

- Completely new approach for allocating protected page tables, see
  section "Protected page table allocation". Patch 11-26 are mostly new.

- Patch 6: check arch_kpkeys_enabled() to make sure that page table
  attributes are still changed when using the mock implementation 

- Patch 9: new patch (thank you Yeoreum!)

- Patch 28: minor changes following the merging of the nested lazy MMU
  series [5]

- Patch 30:
    * Many tests added to provide better coverage of the various page
      table allocation paths
    * Require that the tests are built-in (many referenced symbols are
      not exported)
    * Some refactoring to reduce duplication and add logging

v5: https://lore.kernel.org/linux-hardening/20250815085512.2182322-1-kevin.brodsky@arm.com/

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

- Rebased on top of [9]. No direct impact on the patches, but it ensures that
  the ctor/dtor is always called for kernel pgtables. This is an
  important fix as kernel PTEs allocated after boot were not protected
  by kpkeys_hardened_pgtables in v3 - a new test was added to patch 17
  to ensure that pgtables created by vmalloc are protected too.

- Rebased on top of [10]. The batching of kpkeys level switches in patch
  18 relies on the last patch in [10].

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

- Rebased on v6.15-rc1. This includes [11], which renames a few POE
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
  Qi Zheng's and my own series [12][13], pagetable_*_ctor is
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

- Rebased on next-20250107, which includes [12] and [13].

- Added locking in patch 8. [Peter Zijlstra's suggestion]

RFC v1: https://lore.kernel.org/linux-hardening/20241206101110.1646108-1-kevin.brodsky@arm.com/
---
References

[1] https://lore.kernel.org/all/20210830235927.6443-1-rick.p.edgecombe@intel.com/
[2] https://lsseu2025.sched.com/event/25GEE/kernel-hardening-with-protection-keys-kevin-brodsky-arm
[3] https://lore.kernel.org/all/20250917190323.3828347-1-yang@os.amperecomputing.com/
[4] https://lore.kernel.org/all/20230308094106.227365-1-rppt@kernel.org/
[5] https://lore.kernel.org/all/20251215150323.2218608-1-kevin.brodsky@arm.com/
[6] https://github.com/gormanm/mmtests/blob/master/shellpack_src/src/kernbench/kernbench-bench
[7] https://lore.kernel.org/linux-mm/?q=s%3Apkeys+s%3Acred+s%3A0
[8] https://lore.kernel.org/all/aY3+Raf8eZqipCd6@e129823.arm.com/
[9] https://lore.kernel.org/linux-mm/20250408095222.860601-1-kevin.brodsky@arm.com/
[10] https://lore.kernel.org/linux-mm/20250304150444.3788920-1-ryan.roberts@arm.com/
[11] https://lore.kernel.org/linux-arm-kernel/20250219164029.2309119-1-kevin.brodsky@arm.com/
[12] https://lore.kernel.org/linux-mm/cover.1736317725.git.zhengqi.arch@bytedance.com/
[13] https://lore.kernel.org/linux-mm/20250103184415.2744423-1-kevin.brodsky@arm.com/
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
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-mm@kvack.org
Cc: x86@kernel.org

Kevin Brodsky (29):
  mm: Introduce kpkeys
  set_memory: Introduce set_memory_pkey() stub
  arm64: mm: Enable overlays for all EL1 indirect permissions
  arm64: Introduce por_elx_set_pkey_perms() helper
  arm64: Implement asm/kpkeys.h using POE
  arm64: set_memory: Implement set_memory_pkey()
  arm64: Reset POR_EL1 on exception entry
  arm64: Context-switch POR_EL1
  arm64: Enable kpkeys
  memblock: Move INIT_MEMBLOCK_* macros to header
  set_memory: Introduce arch_has_pte_only_direct_map()
  mm: kpkeys: Introduce kpkeys_hardened_pgtables feature
  mm: kpkeys: Introduce block-based page table allocator
  mm: kpkeys: Handle splitting of linear map
  mm: kpkeys: Defer early call to set_memory_pkey()
  mm: kpkeys: Add shrinker for block pgtable allocator
  mm: kpkeys: Introduce early page table allocator
  mm: kpkeys: Introduce hook for protecting static page tables
  arm64: cpufeature: Add helper to directly probe CPU for POE support
  arm64: set_memory: Implement arch_has_pte_only_direct_map()
  arm64: kpkeys: Support KPKEYS_LVL_PGTABLES
  arm64: kpkeys: Ensure the linear map can be modified
  arm64: kpkeys: Handle splitting of linear map
  arm64: kpkeys: Protect early page tables
  arm64: kpkeys: Protect init_pg_dir
  arm64: kpkeys: Guard page table writes
  arm64: kpkeys: Batch KPKEYS_LVL_PGTABLES switches
  arm64: kpkeys: Enable kpkeys_hardened_pgtables support
  mm: Add basic tests for kpkeys_hardened_pgtables

Yeoreum Yun (1):
  arm64: Initialize POR_EL1 register on cpu_resume()

 arch/arm64/Kconfig                        |   2 +
 arch/arm64/include/asm/cpufeature.h       |  12 +
 arch/arm64/include/asm/kpkeys.h           |  83 ++
 arch/arm64/include/asm/pgtable-prot.h     |  16 +-
 arch/arm64/include/asm/pgtable.h          |  66 +-
 arch/arm64/include/asm/por.h              |  11 +
 arch/arm64/include/asm/processor.h        |   2 +
 arch/arm64/include/asm/ptrace.h           |   4 +
 arch/arm64/include/asm/set_memory.h       |   7 +
 arch/arm64/kernel/asm-offsets.c           |   3 +
 arch/arm64/kernel/cpufeature.c            |   5 +-
 arch/arm64/kernel/entry.S                 |  24 +-
 arch/arm64/kernel/process.c               |   9 +
 arch/arm64/kernel/sleep.S                 |  12 +
 arch/arm64/kernel/smp.c                   |   2 +
 arch/arm64/mm/fault.c                     |   2 +
 arch/arm64/mm/mmu.c                       |  74 +-
 arch/arm64/mm/pageattr.c                  |  29 +-
 include/asm-generic/kpkeys.h              |  21 +
 include/linux/gfp_types.h                 |   3 +
 include/linux/kpkeys.h                    | 183 +++++
 include/linux/memblock.h                  |  11 +
 include/linux/mm.h                        |  14 +-
 include/linux/set_memory.h                |  20 +
 mm/Kconfig                                |   5 +
 mm/Makefile                               |   2 +
 mm/kpkeys_hardened_pgtables.c             | 919 ++++++++++++++++++++++
 mm/memblock.c                             |  11 -
 mm/tests/kpkeys_hardened_pgtables_kunit.c | 202 +++++
 security/Kconfig.hardening                |  24 +
 30 files changed, 1731 insertions(+), 47 deletions(-)
 create mode 100644 arch/arm64/include/asm/kpkeys.h
 create mode 100644 include/asm-generic/kpkeys.h
 create mode 100644 include/linux/kpkeys.h
 create mode 100644 mm/kpkeys_hardened_pgtables.c
 create mode 100644 mm/tests/kpkeys_hardened_pgtables_kunit.c


base-commit: 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f
-- 
2.51.2


