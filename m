Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1C27C624D7
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 10:30:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A96636B00BC; Thu,  3 Sep 2026 06:30:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6DE56B00BD; Thu,  3 Sep 2026 06:30:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 934E46B00BE; Thu,  3 Sep 2026 06:30:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 617C96B00BC
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:30:50 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EA8CA1A04BE
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:30:49 +0000 (UTC)
X-FDA: 85172082618.02.6A742E6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 136B91C0005
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:30:47 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HcD41GFn;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788431448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=FBRd5Z2KW+FW9mvVuln9cFqgGLLCbLCMkD6+nZ6a2DM=;
	b=KfbQaDXOTYn84QABnTm7JpTT0st9Lak9DCUl/loylXOp8vSrcuRX/O/OtEfrWNcO8MiOxQ
	w/nWJ0di/Wl+lEMaicgDPhsZyZpwNPb8CU7SH2E8CRLkK3cxqEWi/K3iCoSAR2QJpYlVtf
	yKMg5K3yTielUnYyyiyGaZT0xef+ZO8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HcD41GFn;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788431448;
	b=n7fhENIBkjHK0NKhoIR66wvM5QH2+P+1fodjMcnkL/nBCpAQj7dq+c3ZR+qSEEqED5mW2o
	WNX5q3Ge55Z3oe5JpchSCt3gE8Ornmw+pged6RkY8BNueQVIUZFQJaRVMG/cjMeSNbUmjK
	KzWAJ3C+XRTN2YNjsPijmCD3Qz+t154=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 22CFD1596;
	Thu,  3 Sep 2026 03:30:43 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B56423F673;
	Thu,  3 Sep 2026 03:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788431446; bh=aIJuznfc9+x+T9t6CWjU8riug4jWFHnV2Y3X1zCinUQ=;
	h=From:To:Cc:Subject:Date:From;
	b=HcD41GFnI7IENNpaP3GqDjy6DF37NZr132PK5kJfK9CtOM3S1qk9y+fcKN3SUV7fv
	 CcM7MKiGKbgjlj33bjiNiW6EInEK8eNPJw+PJmDcxUdsa3kYv2xrBMuqJaCxXVXbPK
	 8bCqsp/QujWMcuoR0Bd78MRtwtmH8W61WUnmuzNQ=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
To: Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Dimitri Sivanich <dimitri.sivanich@hpe.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Nick Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	SJ Park <sj@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Mike Rapoport <rppt@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	ziy@nvidia.com,
	pfalcato@suse.de,
	agordeev@linux.ibm.com,
	ryan.roberts@arm.com
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>,
	linux-kernel@vger.kernel.org,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-parisc@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	damon@lists.linux.dev
Subject: [PATCH v2 0/8] mm: distinguish PTE table storage from PTE values
Date: Thu,  3 Sep 2026 11:29:52 +0100
Message-ID: <20260903103002.1091859-1-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 9x9aeqr3bgp95hkb49yegjofuf665b6e
X-Rspamd-Queue-Id: 136B91C0005
X-HE-Tag: 1788431447-168911
X-HE-Meta: U2FsdGVkX18NcGaK4Dm05m9KcjVlB74aI1dxoMjUH0ftv7W7v+ieaM2/sO4Z4RKGAMJcUNHj7BW/UB65UrjZj5+/+vjwPwawVvHthv1+p4juR7E0jt4vKFTDwO9CjUNRhXobfW3WTLUEAG6Hwcmr32mBBnT0GddVPGoHhUCwc7cha5ZimfSnO+heEZ5zcoZI7Ujy231s2vMF10ySjeVYlf8qCBH5ckWDzw5mnUHPkWj6iSVh4BjhRI9gXZ8jJ0iUFCRZTEILHchj81abo1uTRitlySriaC3llkPONvhsyvFZNM4To4jnd60mUk0YXJw8qRoja6jn8BBwbxo60W3qyNISWCS8k1rmNGWARap61KRgJILVKbguPgmtM8PHQOD+7heN1CSaLp/mkwSTuqfKS/nZAWjTH11N5URkrIWWVWC+3FOwlheUnUUHwwjyIoyeI2Bc6RzUNGA3/Zi0fRukOvZgclQa3zLJrNVIrQ0wfkV7idAWBpXshCi8Y4KPaYmKZwWBbZbcSN8wQKQ+YpX9k5pVxSZW5lSEd7TyzMYvrbqdATa4iK2WdO0Lz9X8cpGIMV69PEhhTF+VGAzSQh2HB38/XZZVdvmgsxtCTGgtmVKrp06CfXVnITMMorVo/PXheE/SffRJVSQvi597jNxhWkitoufnghbcKdJ3TNu3urDCmdRS3EScXK//D6eoC9bwkJUI1+v+K+tjUyezEmi3l8PPWD0d6EKAuZSECw8BXy+3zv0wDfTawb0VO08s+yCA7+N7rXPdORbnXF4Y4dHLkv7QzISTHlyRsE5yI8+7DXgNwu0oWvqRVuLpW7zQ3DPZfy8BvYqb9AlOH9PqWVgt/gu2dSpXPfgEw8HqWPEN5zTADrH6QCRP+SsjPs8xwhh/Lqjh55ibU/nYUZh75roA4ZNn+7b34qm6PF2M438iqHm2Vi5iJBh/HKMoR3KixDlfki7lxue0zShAe3bTUC7
 Fpj0by1W
 3/n/+/CqV0oWACYDm0ee9JE/zPeQIPT2s7kDZrnj5qrz0d/Ocffe6VmdECzdKOIMINVi803KoSn800HJwrhSWRgvXRshD5cHbMeH6vUzYfY5zjzxix/cHzPuNuJgvHva3s7+Zr6zzJnoUvJU4EKIAqgx/YULMOzMHh/exsYJQkJIskKr0J7KKQMJ5bB6WfUcXsTJPdVjDLM44181+NYudGXCwCeOqJg09AHcUDAXkBQnVJ9OkQ+mjAW2+UuGBlsPGEhYkxzrvgot/rg7QycxvCAZUfD07hbKw6KtcbuWsMEUPsyhVmm54vT68wxMezjuw0QaeYxnGqwgiqtlnVYM/ZteItwgXo9zQnrY/fcopGmU+nTc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

pte_t currently describes both a software PTE value and an element stored
in a PTE table. Consequently, pte_t * can point either to a software PTE
value, often a stack copy, or to a PTE-table slot. The compiler cannot
distinguish these cases. A value pointer can therefore be passed to an
interface that expects table storage, while table storage can be read by
direct dereference instead of the architecture accessor.

This series begins a staged conversion at the PTE level. It introduces
hw_pte_t as the element type for PTE-table storage and converts generic
MM to use hw_pte_t *. Software PTE values remain pte_t. Interfaces that
intentionally return a value through pte_t *, such as install_pte,
remain value interfaces; the relevant parameters are named ptentp to
make that distinction explicit.

The generic definition aliases hw_pte_t to pte_t unless an architecture
selects ARCH_HAS_HW_PTE_T, which enables a distinct generic wrapper named
__hw_pte_t. Some architectures define pgtable_t in headers parsed before
the generic hw_pte_t typedef is visible. The structure tag allows those
headers to define pgtable_t as struct __hw_pte_t * without creating an
include-order dependency. This is required when converting s390, m68k,
powerpc and sparc.

No architecture selects ARCH_HAS_HW_PTE_T in this series, so the
representation and behavior of every architecture are preserved. ptep_get()
keeps its existing READ_ONCE() semantics and converts the stored element
through __pte_from_hw(). An architecture can later select the option and
convert its PTE interfaces to make the distinction compiler-enforced.
Architecture PTE implementations and most architecture code are
deliberately left for those later opt-in conversions.

Here, hw_pte_t identifies PTE-table storage rather than table lifetime:
complete PTE tables use hw_pte_t whether or not they are currently
linked into a page-table hierarchy, while software PTE values use
pte_t. The distinction between complete but unlinked tables and
hardware-reachable tables was raised during discussion and remains an
important point for review.

PMD, PUD, P4D and PGD storage are deliberately out of scope. They can be
converted in later series after the PTE boundary is agreed, avoiding the
PMD-specific cases that made an all-level conversion difficult to
review.

Most mechanical pointer conversions were generated with the Coccinelle
script included below, then audited and fixed by hand.

This series does not add a second ptep_get_once() accessor and does not
remove or replace STRICT_MM_TYPECHECKS.

The design discussion is available at [1]; while the original idea came
from [2].

I've the patches here [3] for arm64 conversion which I used to find
usages in generic code which I missed during development. These would be
sent separately.

[1] https://lore.kernel.org/all/6110202c-057b-4701-8c04-1a76ee7bb9ab@arm.com/
[2] https://lore.kernel.org/all/a063f6c5-2785-4a9f-8079-25edb3e54cef@arm.com
[3] https://gitlab.arm.com/linux-arm/linux-us/-/commits/pte0_arm

Thanks,
Usama
---
Changes since v1:
- Name the generic wrapper structure __hw_pte_t so architectures can
  forward-declare it before the generic typedef is visible.
- Use software PTE value terminology consistently
- Fold the prerequisite header includes into the generic storage
  conversion
- Explain why the NOMMU stub converts the stored entry without
  ptep_get().
- Rebase onto mm-new and rerun the Coccinelle conversion.

Changes since RFC v1:
- Add ARCH_HAS_HW_PTE_T so architectures can opt in to a distinct
  PTE-table storage type.
- Define the distinct hw_pte_t wrapper and its conversion helpers in
  generic code instead of requiring each architecture to define them.
- Read hw_pte_t through READ_ONCE() before converting it to pte_t.
- Drop the previous mremap patch in favour of [a]. Apply [a] first if
  it is not already present.
- Drop the previous two dead-code conversion patches; the affected
  code was cleaned up separately in [b] and [c].

[a] https://lore.kernel.org/linux-mm/20260720141633.501799-1-agordeev@linux.ibm.com/
[b] https://lore.kernel.org/all/20260730111316.3672672-1-usama.anjum@arm.com
[c] https://lore.kernel.org/all/20260730094501.3002718-1-usama.anjum@arm.com

---
// SPDX-License-Identifier: GPL-2.0-only
///
/// Rename raw PTE pointer types to hardware PTE pointer types.
///
/// This is a mechanical type rename. It converts common declarations,
/// function parameters, prototypes, return types and casts from "pte_t *"
/// to "hw_pte_t *". Plain "pte_t" objects are intentionally left unchanged.
/// Pointers named "ptentp" refer to temporary software PTE values and are
/// intentionally ignored in all modes.
/// Re-run in context mode afterwards to audit remaining raw pte_t pointers
/// and cases that need hand conversion, such as trace macros and mixed
/// declarations.
///
/// Confidence: Moderate
// Options: --no-includes --include-headers

virtual patch
virtual report
virtual context

@local_decl depends on patch@
identifier x != ptentp;
@@
- pte_t *x;
+ hw_pte_t *x;

@local_decl_init depends on patch@
identifier x != ptentp;
expression e;
@@
- pte_t *x = e;
+ hw_pte_t *x = e;

@param_proto depends on patch@
identifier f;
identifier x != ptentp;
type R;
@@
R f(...,
- pte_t *x
+ hw_pte_t *x
,...);

@param_proto_unnamed depends on patch@
identifier f;
type R;
@@
R f(...,
- pte_t *
+ hw_pte_t *
,...);

@param_def depends on patch@
identifier f;
identifier x != ptentp;
type R;
@@
R f(...,
- pte_t *x
+ hw_pte_t *x
,...)
{ ... }

@ret_proto depends on patch@
identifier f;
parameter list ps;
@@
- pte_t *
+ hw_pte_t *
  f(ps);

@ret_def depends on patch@
identifier f;
parameter list ps;
@@
- pte_t *
+ hw_pte_t *
  f(ps)
{ ... }

@struct_member depends on patch@
identifier S;
identifier x != ptentp;
@@
struct S {
...
- pte_t *x;
+ hw_pte_t *x;
...
};

@union_member depends on patch@
identifier x != ptentp;
@@
union {
...
- pte_t *x;
+ hw_pte_t *x;
...
};

@union_member_in_struct depends on patch@
identifier S;
identifier x != ptentp;
@@
struct S {
...
union {
...
- pte_t *x;
+ hw_pte_t *x;
...
};
...
};

@fnptr_struct_member depends on patch@
identifier S,f;
identifier x != ptentp;
type R;
@@
struct S {
...
R (*f)(...,
- pte_t *x
+ hw_pte_t *x
,...);
...
};

@fnptr_typedef_pte_fn_t depends on patch@
identifier x != ptentp;
@@
typedef int (*pte_fn_t)(...,
- pte_t *x
+ hw_pte_t *x
,...);

@cast depends on patch@
expression e;
@@
- (pte_t *)e
+ (hw_pte_t *)e

@remaining_decl depends on context || report@
identifier x != ptentp;
position p;
@@
* pte_t *x@p;

@remaining_decl_init depends on context || report@
identifier x != ptentp;
expression e;
position p;
@@
* pte_t *x@p = e;

@remaining_param_proto depends on context || report@
identifier f;
identifier x != ptentp;
type R;
position p;
@@
R f(...,
* pte_t *x@p
,...);

@remaining_param_proto_unnamed depends on context || report@
identifier f;
type R;
position p;
@@
R f(...,
* pte_t *@p
,...);

@remaining_param_def depends on context || report@
identifier f;
identifier x != ptentp;
type R;
position p;
@@
R f(...,
* pte_t *x@p
,...)
{ ... }

@remaining_ret_proto depends on context || report@
identifier f;
parameter list ps;
position p;
@@
* pte_t *f@p(ps);

@remaining_ret_def depends on context || report@
identifier f;
parameter list ps;
position p;
@@
* pte_t *f@p(ps)
{ ... }

@remaining_struct_member depends on context || report@
identifier S;
identifier x != ptentp;
position p;
@@
struct S {
...
* pte_t *x@p;
...
};

@remaining_union_member depends on context || report@
identifier x != ptentp;
position p;
@@
union {
...
* pte_t *x@p;
...
};

@remaining_union_member_in_struct depends on context || report@
identifier S;
identifier x != ptentp;
position p;
@@
struct S {
...
union {
...
* pte_t *x@p;
...
};
...
};

@remaining_fnptr_struct_member depends on context || report@
identifier S,f;
identifier x != ptentp;
type R;
position p;
@@
struct S {
...
R (*f)(...,
* pte_t *x@p
,...);
...
};

@remaining_fnptr_typedef_pte_fn_t depends on context || report@
identifier x != ptentp;
position p;
@@
typedef int (*pte_fn_t)(...,
* pte_t *x@p
,...);

Muhammad Usama Anjum (8):
  mm: introduce hw_pte_t for PTE table storage
  mm: rename pointers to software PTE values as ptentp
  mm: use hw_pte_t for generic PTE table storage
  mm: convert PTE table entries in ptep_get()
  mm: convert PTE table entry to pte
  mm/kasan: use hw_pte_t for the early shadow PTE table
  drm/i915: use hw_pte_t for PTE range callbacks
  xen: use hw_pte_t for PTE range callbacks

 MAINTAINERS                                   |  1 +
 .../drm/i915/gem/selftests/i915_gem_mman.c    |  4 +-
 drivers/gpu/drm/i915/i915_mm.c                |  4 +-
 drivers/xen/gntdev.c                          |  2 +-
 drivers/xen/privcmd.c                         |  2 +-
 drivers/xen/xenbus/xenbus_client.c            |  2 +-
 drivers/xen/xlate_mmu.c                       |  4 +-
 fs/hugetlbfs/inode.c                          |  3 +-
 fs/proc/task_mmu.c                            | 33 ++++----
 include/asm-generic/hugetlb.h                 | 15 ++--
 include/asm-generic/pgalloc.h                 |  6 +-
 include/asm-generic/tlb.h                     |  5 +-
 include/linux/hugetlb.h                       | 53 ++++++------
 include/linux/kasan.h                         |  2 +-
 include/linux/mm.h                            | 26 +++---
 include/linux/page_table_check.h              | 10 ++-
 include/linux/pagewalk.h                      | 10 +--
 include/linux/pgtable.h                       | 81 ++++++++++---------
 include/linux/pgtable_types.h                 | 19 +++++
 include/linux/rmap.h                          |  2 +-
 include/linux/swapops.h                       |  6 +-
 include/linux/vmalloc.h                       |  4 +-
 include/trace/events/xen.h                    | 10 +--
 kernel/bpf/arena.c                            |  9 ++-
 kernel/events/core.c                          |  3 +-
 mm/Kconfig                                    |  3 +
 mm/damon/ops-common.c                         |  2 +-
 mm/damon/ops-common.h                         |  2 +-
 mm/damon/vaddr.c                              | 20 ++---
 mm/debug_vm_pgtable.c                         |  2 +-
 mm/filemap.c                                  |  4 +-
 mm/gup.c                                      |  9 ++-
 mm/highmem.c                                  | 15 ++--
 mm/hmm.c                                      |  6 +-
 mm/huge_memory.c                              |  4 +-
 mm/hugetlb.c                                  | 60 +++++++-------
 mm/hugetlb_vmemmap.c                          | 13 +--
 mm/internal.h                                 | 16 ++--
 mm/kasan/init.c                               | 14 ++--
 mm/kasan/shadow.c                             |  6 +-
 mm/khugepaged.c                               | 50 +++++++-----
 mm/ksm.c                                      | 11 +--
 mm/madvise.c                                  | 18 +++--
 mm/mapping_dirty_helpers.c                    |  4 +-
 mm/memory-failure.c                           |  6 +-
 mm/memory.c                                   | 78 +++++++++---------
 mm/mempolicy.c                                |  4 +-
 mm/migrate.c                                  |  4 +-
 mm/migrate_device.c                           |  4 +-
 mm/mincore.c                                  |  4 +-
 mm/mlock.c                                    |  4 +-
 mm/mprotect.c                                 | 19 ++---
 mm/mremap.c                                   |  4 +-
 mm/page_table_check.c                         |  4 +-
 mm/pagewalk.c                                 |  9 ++-
 mm/percpu.c                                   |  2 +-
 mm/pgtable-generic.c                          | 20 ++---
 mm/ptdump.c                                   |  4 +-
 mm/rmap.c                                     |  6 +-
 mm/sparse-vmemmap.c                           | 22 ++---
 mm/swap_state.c                               |  3 +-
 mm/swapfile.c                                 |  5 +-
 mm/userfaultfd.c                              | 32 ++++----
 mm/util.c                                     |  2 +-
 mm/vmalloc.c                                  | 11 +--
 mm/vmscan.c                                   |  6 +-
 66 files changed, 453 insertions(+), 375 deletions(-)
 create mode 100644 include/linux/pgtable_types.h

-- 
2.47.3


