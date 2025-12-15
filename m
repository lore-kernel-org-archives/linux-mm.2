Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73D67D5B175
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 15:03:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7D866B0006; Mon, 15 Dec 2025 10:03:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE0256B0007; Mon, 15 Dec 2025 10:03:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9809D6B0008; Mon, 15 Dec 2025 10:03:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7F3406B0006
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 10:03:41 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C69C9160293
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:03:40 +0000 (UTC)
X-FDA: 84222024600.09.5A4485E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id C08901C000C
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:03:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765811019; a=rsa-sha256;
	cv=none;
	b=RTpnwq0OHmkddz6tvOXTyDyawo9EcAGguKJ90uhcf8Kkb4xerhUq2ZFbWjCqinLour2c71
	TWAelpWDXM51y7N5gWhit18BIsuMgHrMZZoZtmzJOqvVEPdKw1fvx+OqxaF4OEdOs2WG7y
	dXpfBELRxbRlxsqSMl7ogiQtx5fOrzM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765811019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=Us2pVkoJIeIXiCHiLZJ3kq0JaNmU3QwhNr+/c3xnPEU=;
	b=fZvF/kw88ecarm4lrG2C0xyk4PLegPIHwvvQteTG46oY2SkzRD6wvtvR5R2mKB7JECyi38
	pWZzcaUYgqszCBAmyHFVlNoV775W3BzqKAElMA9sa66z3NtaAazPO0NQYpM1YLvQUfqMeY
	zycT/FpgK8WXqtlY6h0bTmkT6YBGTa0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 52D58497;
	Mon, 15 Dec 2025 07:03:30 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2EB8D3F73B;
	Mon, 15 Dec 2025 07:03:32 -0800 (PST)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Woodhouse <dwmw2@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jann Horn <jannh@google.com>,
	Juergen Gross <jgross@suse.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	sparclinux@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	x86@kernel.org
Subject: [PATCH v6 00/14] Nesting support for lazy MMU mode
Date: Mon, 15 Dec 2025 15:03:09 +0000
Message-ID: <20251215150323.2218608-1-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C08901C000C
X-Stat-Signature: mh87bar8ac1q6drkc9s84y8k5jp1hu6i
X-HE-Tag: 1765811018-571389
X-HE-Meta: U2FsdGVkX1/HwojtW6g5y1y8zaZ3AgYZuYpvU9ueXcGwvK44GwV+CZTWwth9R1dbvzKyYVpY/oKZqHY4bUuog3aYHuWD/df17uPcBoQX2Jfmid3qJnbU/G+yoDNU0lm1lVOeFrh2DevWeUqhZiF7oWPZ67QrEVJtmyt2kVHurVHEjn6+f+Bfva2AomErSO9lhdub/AGyt6wCAsnQSpMbvq7zhVy8L8g0E70Az4Zq/jnxwaAbJRlHIL8/XBcv+Wiye5NTV9d5KqdgMPhmkV3M38Lt4mr/m/UBBDbkaJME/jOPe8t0AWeFeIXZPrKD2w1llMJ6C833lfyVUo4pN88L+0DwHP2oaCLm+E3cJrR+YApnCDwMqgRa4oPt7bEDHc9Aez4TAmY7fKhgw+nu+QanrYFvYGghnaVggO5yO5r6ZkOw1O9o/qcS3R96gmi+P6IdTt1yJkLy+YjM8Wn4AlTXeuYkspVicesDLG6n5aANSGaVtF/4NCX7pC6Afiv/97w8lIxEvYO2+ybBXk15MCKVJTTjTWOO1GjGIyb3yyY6CBtv7I/LJTaAqfeB7BFOLpCo4eQGBDmfL4oDcoVb7S0kPYR6HPPy5qaX+DEFeIb2/Vlgf363NQ4zV27oYrnjnm4M1hxN6ol02whmBov91Lbf/kKulpYdnvjzOiw9Q7f9Sv9Pb1XbZ3eAjQpmldQXN8cPHEUR2Sbh6zVV5qodBP5ztMoQufHSow4oFRIjuztfFEjN4QpLR6IwFPVuk07RgxU/QZI0FLvNYktSz76UDIKImqpozPWd4WbyD9cdUb53+5G3KI4hwe9DdW3QagNW79Lhaxlhna+90ojddJr09Zv++USUmDOayRlDwovbtRubgwh+I08wxHDDiy1FCdmbtp5aSy9sgVXQ3NHoGbpG4hHZ/oxVCveN60UVYYngl+NG6Dh2FIO9uryvQQNY3ZBhpfz4G43l82f7L9WWtOJvbbU
 rcU2QA4J
 JQwsbBFinyZCD+lSMbzlN6XHsR3fuwIvct10Xi7wq5AboGPKeMvRJt2RoQDbTzri2raR+jafE8MDoSgoXvAkStixA5HIffiiP4HObl9iRiGrkUpsGWnbbsn/jhhvK/6fqGyhqZLOJXNqLG9M46Adq9bOxeCMwMy32g+0FCdUDmyaFdMP3sEnsKewodEqF58Nys0KLna93UT2RgBCx0c+A96bWdfBpV4zPlBwWrqU9bNAaOY83X94WmThA290HIBISvyZNHnOsaWft9oWh2rpkvaFcb4Zp76s7dLCuGtvpi/Nu/p/WFyng9AJSPLmNOMzc+SB07IXyDxlc+B4Lf91qgxXUAPiL66wsQNlfUyEZqRjNygpECsjrVFUcYAPL72RufGToAs4Du04P+V1/eKAtjNQQf+p7k0MANH50i6WX0RoeKnf8AldRbCAIfTWyRum5HVeJ49YmQ6gaOJ4lmdxmi7jnqdAuVXNEj7KOTEAF19ZeZMfgd8q/vCp50VRMOjL7Th1S5da5i8LUTB3ZvKi44VdWA/xJG2YG8PGha19oln2XOZLBp/qnjKPlktho3d1z7+FGOXFNFTn+xUacaOON/VeKnOmu5Pf1MMjoHo7luZLUqCGBOQyGBKMWvz/CX/rAloG0TsOU5PDbTnu5hoRtiA9KKa+kXk6gRVBd0ULvZvSi6QwlSgpt9t8vnV97MqitrmGpd3MdvpOPWafCgimoFXJ1qiwODu67QF49XpifTJ/UZpghAMJpN9lb76OCUGq0Uk9LBqOBlOWEkWFKXdM1Gn/Gh/tS2dUApg7zs2MHETUUtANYXyvzryMzSb40WaNnc36hBRr6fGyzrnUOJEe7vK+tUuAMz4G7pjHgHi1VTY0HFlgGJQYGTXKEMC2pA8gdu+0onqpOterD56TbPMdDSW8WnAMgPe29Au6dG/z6CHQ0XdE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the lazy MMU mode was introduced eons ago, it wasn't made clear
whether such a sequence was legal:

	arch_enter_lazy_mmu_mode()
	...
		arch_enter_lazy_mmu_mode()
		...
		arch_leave_lazy_mmu_mode()
	...
	arch_leave_lazy_mmu_mode()

It seems fair to say that nested calls to
arch_{enter,leave}_lazy_mmu_mode() were not expected, and most
architectures never explicitly supported it.

Nesting does in fact occur in certain configurations, and avoiding it
has proved difficult. This series therefore enables lazy_mmu sections to
nest, on all architectures.

Nesting is handled using a counter in task_struct (patch 8), like other
stateless APIs such as pagefault_{disable,enable}(). This is fully
handled in a new generic layer in <linux/pgtable.h>; the arch_* API
remains unchanged. A new pair of calls, lazy_mmu_mode_{pause,resume}(),
is also introduced to allow functions that are called with the lazy MMU
mode enabled to temporarily pause it, regardless of nesting.

An arch now opts in to using the lazy MMU mode by selecting
CONFIG_ARCH_LAZY_MMU; this is more appropriate now that we have a
generic API, especially with state conditionally added to task_struct.

---

Background: Ryan Roberts' series from March [1] attempted to prevent
nesting from ever occurring, and mostly succeeded. Unfortunately, a
corner case (DEBUG_PAGEALLOC) may still cause nesting to occur on arm64.
Ryan proposed [2] to address that corner case at the generic level but
this approach received pushback; [3] then attempted to solve the issue
on arm64 only, but it was deemed too fragile.

It feels generally difficult to guarantee that lazy_mmu sections don't
nest, because callers of various standard mm functions do not know if
the function uses lazy_mmu itself.

The overall approach in v3/v4 is very close to what David Hildenbrand
proposed on v2 [4].

Unlike in v1/v2, no special provision is made for architectures to
save/restore extra state when entering/leaving the mode. Based on the
discussions so far, this does not seem to be required - an arch can
store any relevant state in thread_struct during arch_enter() and
restore it in arch_leave(). Nesting is not a concern as these functions
are only called at the top level, not in nested sections.

The introduction of a generic layer, and tracking of the lazy MMU state
in task_struct, also allows to streamline the arch callbacks - this
series removes 67 lines from arch/.

Patch overview:

* Patch 1: cleanup - avoids having to deal with the powerpc
  context-switching code

* Patch 2-4: prepare arch_flush_lazy_mmu_mode() to be called from the
  generic layer (patch 9)

* Patch 5: documentation clarification (not directly related to the
  changes in this series)

* Patch 6-7: new API + CONFIG_ARCH_LAZY_MMU

* Patch 8: ensure correctness in interrupt context

* Patch 9: nesting support

* Patch 10-13: replace arch-specific tracking of lazy MMU mode with
  generic API

* Patch 14: basic tests to ensure that the state added in patch 9 is
  tracked correctly

This series has been tested by running the mm kselftests on arm64 with
DEBUG_VM, DEBUG_PAGEALLOC, KFENCE and KASAN. Extensive testing on
powerpc was also kindly provided by Venkat Rao Bagalkote [5]. It was
build-tested on other architectures (with and without XEN_PV on x86).

- Kevin

[1] https://lore.kernel.org/all/20250303141542.3371656-1-ryan.roberts@arm.com/
[2] https://lore.kernel.org/all/20250530140446.2387131-1-ryan.roberts@arm.com/
[3] https://lore.kernel.org/all/20250606135654.178300-1-ryan.roberts@arm.com/
[4] https://lore.kernel.org/all/ef343405-c394-4763-a79f-21381f217b6c@redhat.com/
[5] https://lore.kernel.org/all/94889730-1AEF-458F-B623-04092C0D6819@linux.ibm.com/
---
Changelog

v5..v6:

- Rebased on v6.19-rc1
- Overall: no functional change
- Patch 5: new patch clarifying that generic code may not sleep while in lazy
  MMU mode [Alexander Gordeev]
- Patch 6: added description for the ARCH_HAS_LAZY_MMU_MODE option
  [Anshuman Khandual]
- Patch 9: rename in_lazy_mmu_mode() to is_lazy_mmu_mode_active() [Alexander]
- Patch 14: new patch with basic KUnit tests [Anshuman]
- Collected R-b/A-b/T-b tags

v5: https://lore.kernel.org/all/20251124132228.622678-1-kevin.brodsky@arm.com/

v4..v5:

- Rebased on mm-unstable
- Patch 3: added missing radix_enabled() check in arch_flush()
  [Ritesh Harjani]
- Patch 6: declare arch_flush_lazy_mmu_mode() as static inline on x86
  [Ryan Roberts]
- Patch 7 (formerly 12): moved before patch 8 to ensure correctness in
  interrupt context [Ryan]. The diffs in in_lazy_mmu_mode() and
  queue_pte_barriers() are moved to patch 8 and 9 resp.
- Patch 8:
  * Removed all restrictions regarding lazy_mmu_mode_{pause,resume}().
    They may now be called even when lazy MMU isn't enabled, and
    any call to lazy_mmu_mode_* may be made while paused (such calls
    will be ignored). [David, Ryan]
  * lazy_mmu_state.{nesting_level,active} are replaced with
    {enable_count,pause_count} to track arbitrary nesting of both
    enable/disable and pause/resume [Ryan]
  * Added __task_lazy_mmu_mode_active() for use in patch 12 [David]
  * Added documentation for all the functions [Ryan]
- Patch 9: keep existing test + set TIF_LAZY_MMU_PENDING instead of
  atomic RMW [David, Ryan]
- Patch 12: use __task_lazy_mmu_mode_active() instead of accessing
  lazy_mmu_state directly [David]
- Collected R-b/A-b tags

v4: https://lore.kernel.org/all/20251029100909.3381140-1-kevin.brodsky@arm.com/

v3..v4:

- Patch 2: restored ordering of preempt_{disable,enable}() [Dave Hansen]
- Patch 5 onwards: s/ARCH_LAZY_MMU/ARCH_HAS_LAZY_MMU_MODE/ [Mike Rapoport]
- Patch 7: renamed lazy_mmu_state members, removed VM_BUG_ON(),
  reordered writes to lazy_mmu_state members [David Hildenbrand]
- Dropped patch 13 as it doesn't seem justified [David H]
- Various improvements to commit messages [David H]

v3: https://lore.kernel.org/all/20251015082727.2395128-1-kevin.brodsky@arm.com/

v2..v3:

- Full rewrite; dropped all Acked-by/Reviewed-by.
- Rebased on v6.18-rc1.

v2: https://lore.kernel.org/all/20250908073931.4159362-1-kevin.brodsky@arm.com/

v1..v2:
- Rebased on mm-unstable.
- Patch 2: handled new calls to enter()/leave(), clarified how the "flush"
  pattern (leave() followed by enter()) is handled.
- Patch 5,6: removed unnecessary local variable [Alexander Gordeev's
  suggestion].
- Added Mike Rapoport's Acked-by.

v1: https://lore.kernel.org/all/20250904125736.3918646-1-kevin.brodsky@arm.com/
---
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: sparclinux@vger.kernel.org
Cc: xen-devel@lists.xenproject.org
Cc: x86@kernel.org
---
Alexander Gordeev (1):
  powerpc/64s: Do not re-activate batched TLB flush

Kevin Brodsky (13):
  x86/xen: simplify flush_lazy_mmu()
  powerpc/mm: implement arch_flush_lazy_mmu_mode()
  sparc/mm: implement arch_flush_lazy_mmu_mode()
  mm: clarify lazy_mmu sleeping constraints
  mm: introduce CONFIG_ARCH_HAS_LAZY_MMU_MODE
  mm: introduce generic lazy_mmu helpers
  mm: bail out of lazy_mmu_mode_* in interrupt context
  mm: enable lazy_mmu sections to nest
  arm64: mm: replace TIF_LAZY_MMU with is_lazy_mmu_mode_active()
  powerpc/mm: replace batch->active with is_lazy_mmu_mode_active()
  sparc/mm: replace batch->active with is_lazy_mmu_mode_active()
  x86/xen: use lazy_mmu_state when context-switching
  mm: Add basic tests for lazy_mmu

 arch/arm64/Kconfig                            |   1 +
 arch/arm64/include/asm/pgtable.h              |  41 +----
 arch/arm64/include/asm/thread_info.h          |   3 +-
 arch/arm64/mm/mmu.c                           |   8 +-
 arch/arm64/mm/pageattr.c                      |   4 +-
 .../include/asm/book3s/64/tlbflush-hash.h     |  20 +--
 arch/powerpc/include/asm/thread_info.h        |   2 -
 arch/powerpc/kernel/process.c                 |  25 ---
 arch/powerpc/mm/book3s64/hash_tlb.c           |  10 +-
 arch/powerpc/mm/book3s64/subpage_prot.c       |   4 +-
 arch/powerpc/platforms/Kconfig.cputype        |   1 +
 arch/sparc/Kconfig                            |   1 +
 arch/sparc/include/asm/tlbflush_64.h          |   5 +-
 arch/sparc/mm/tlb.c                           |  14 +-
 arch/x86/Kconfig                              |   1 +
 arch/x86/boot/compressed/misc.h               |   1 +
 arch/x86/boot/startup/sme.c                   |   1 +
 arch/x86/include/asm/paravirt.h               |   1 -
 arch/x86/include/asm/pgtable.h                |   1 +
 arch/x86/include/asm/thread_info.h            |   4 +-
 arch/x86/xen/enlighten_pv.c                   |   3 +-
 arch/x86/xen/mmu_pv.c                         |   6 +-
 fs/proc/task_mmu.c                            |   4 +-
 include/linux/mm_types_task.h                 |   5 +
 include/linux/pgtable.h                       | 158 +++++++++++++++++-
 include/linux/sched.h                         |  45 +++++
 mm/Kconfig                                    |  19 +++
 mm/Makefile                                   |   1 +
 mm/kasan/shadow.c                             |   8 +-
 mm/madvise.c                                  |  18 +-
 mm/memory.c                                   |  16 +-
 mm/migrate_device.c                           |   8 +-
 mm/mprotect.c                                 |   4 +-
 mm/mremap.c                                   |   4 +-
 mm/tests/lazy_mmu_mode_kunit.c                |  71 ++++++++
 mm/userfaultfd.c                              |   4 +-
 mm/vmalloc.c                                  |  12 +-
 mm/vmscan.c                                   |  12 +-
 38 files changed, 380 insertions(+), 166 deletions(-)
 create mode 100644 mm/tests/lazy_mmu_mode_kunit.c


base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
-- 
2.51.2


