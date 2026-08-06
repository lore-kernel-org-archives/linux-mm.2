Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91989C56203
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 08:39:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B18C86B007B; Thu,  6 Aug 2026 04:39:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF01C6B008A; Thu,  6 Aug 2026 04:39:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A05B66B00AD; Thu,  6 Aug 2026 04:39:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 710426B008A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 04:39:57 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E45741606DA
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:39:56 +0000 (UTC)
X-FDA: 85070196792.26.2BEFF38
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2D58C140002
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:39:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=XAD0GC3B;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786005595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Gqz5UQ/u6n2s4zX9DANEMnPoL4oWY3qnGjaNJsdpscQ=;
	b=BrJ/LbyLJN61OG+6iYnM/XWZ4QwqYrq211jerZqzcoD/RmUfW0lyzLvQQqqmt3OYOPp6Zy
	zCF7TYXeZb91Cpv9UD/V9U2+vxYDBm1JWTqb7YUHp1g4pTrn66GHLN4FHbS7DRWq/N7mTS
	KZjo1Sg0pC06Whq5IrGPplzf3UPWXes=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=XAD0GC3B;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786005595;
	b=0DKj75y1wBmZ2ZDiUTCTMJJ26vYG4UWw1M5ohz51HKscPf48TIEofs+EXcg58WrCB+ErHu
	78f/Csz2TZMZxs9SVkjoQqVe60Xs6QJPLJWSwY1FDvFXuEpNoYjvtZwgHX1RsReppP6nRc
	8GNJhB8IblxDBwL3DAX+y0e/VVnx5e4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 836C4153B;
	Thu,  6 Aug 2026 01:39:49 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C4F063F632;
	Thu,  6 Aug 2026 01:39:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786005593; bh=1/GXhzlocZP3RO99ssHRo2N31fXX+evtIf1AglwmeYk=;
	h=From:To:Cc:Subject:Date:From;
	b=XAD0GC3BFV+aOtURbErU8rEzfMbSmdJMzfNwzK/FHv0gx1gos8TDz/dRjKI0JzDR0
	 AQ4BuCvKLoJi+XVzKw+vUT1ULkUCtkTdaFTQUlv601HAIs75njL9FmO8WmoPB+Psrr
	 TDc5b83VZ6vnRuzuzlPGu/pmjS3BAMBtce5CKFQo=
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
Subject: [PATCH 0/9] mm: distinguish PTE table storage from PTE values
Date: Thu,  6 Aug 2026 09:38:38 +0100
Message-ID: <20260806083926.1807279-1-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2D58C140002
X-Stat-Signature: xstyg8ypau3wang6kxojnzbpsncr8zpo
X-Rspam-User: 
X-HE-Tag: 1786005595-570746
X-HE-Meta: U2FsdGVkX19dWrMCo47VNTp6vj/ZoRFDH49fLUuUSPYZOhm6l6HC/eTpLNKNejNmCHhDhv/3MaHg33fPV7kjYyBsN3QTCqOtzwpJ+5wGzaR4KclJaYX1EjZir61US5R+1cZwCmxhNus8v0yb3Ps8eS+mTTo+QVY3xfzD/Aiqzv7BFBuu1/dDou1U02bFyTQMmD4KhqzgG3w8gDNeelKHoEt/kFowG2940WagqC+LrOY7c3lj45VCGGUqNKEGUpakiBbZ1r286QdS1ess2VEUpW5g6xe++rRK9UTNgfq48x38VTYithUnLRucZxWdS2NhLkgJcQCZ+tlsbsSiI9ZFFMhCBIZbJnJhPltvruiqTVbrcZolBO9rLB02Odh0WcDfUpc3E5jMevl0/qY0Qnc9KiaYcT3fHyMNh0LUdNzPSDa2ZDiGDGkIX2XHe/zYt4wIR0GUwjO6BA/3jVcokvCbdzB6yVTLolxL864Lzsr6Y6p/cSh897mIq5ES5mNcF/fZang057dXca0DPMR9AkjMQ020O2P6kuZA79+LCYaRQZX3IhnCzctPf6qDYEhRR+C9dtkMFCua3ZjffOCawEHE9Yyei3vwH3s82c86tUkgVYM99zcSrfTgNUXZlwZBFcScT4S/9qQPBpRIwqWamqYXakwWtZxalKq/VsBd2SsGGDzlicmVOmKDAh1OQtPe0ZWXuzfWMCVt3Iqcpzsdj5QtnnSRyupMHTZMTJKdOo/5Lv9UjrdJ57t8Aoz5AuqGvyevHV31ZNyNaenxSXjyJX1sde8gc9uYG7rjIIr0wJ8ksPVJXmZSsKPsoSvnEGxAe4MwUO5z1Ds6HbdBc5lZ2xgF/PqgH043ZSLcVaFAc4W4VAS6dCKs3NGRr2hwwI1joJg4qMM/Symyqm9eCjnW4HF5RNwQm9eUkfEbS8u7LPA8SIj2hVQ8lE277pfYdwMVTnBUICh6KAtm8xE5wzRUVVS
 OjQEPT2/
 bPmrMsSQtOY2mwGyvD3WZQryWPcrNbp632gBZXTDT1cbeg+Rnr88H0jFGxijz9ccILcnjBm8psqakmHMaJpDqziDOdTwjcxEk059drcbhT3wLZ26euWlpAOC+wux8IPxnouhPiONC20OYHVD4GKwvTkqtmxehLqZJg2kG4e7jwl9rR/0DWGyqaLqb6XF2/VKsgKxzztacjwFlqAyh4n5gdw3BqdqN1CSTJVR7NiL8HMwOut9W6kJ8L+OawUCOFmRhTbqEvyYAH8F653e3ZOm7C7/d78s1NjldGDUQgsKa9YdhtUxIcJ1/oXi9wNputh+Xz/dHAcizCXYCwQ5t6bfpNfqpIQYFmNIa2TxjGbm5Tz+T19XJOMAC5/xJOLE3NKUHBK4qjag+PfvGoDQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

pte_t currently describes both a logical PTE value and an element stored
in a PTE table. Consequently, pte_t * can point either to a standalone
value, often a stack copy, or to a PTE-table slot. The compiler cannot
distinguish these cases. A value pointer can therefore be passed to an
interface that expects table storage, while table storage can be read by
direct dereference instead of the architecture accessor.

This series begins a staged conversion at the PTE level. It introduces
hw_pte_t as the element type for PTE-table storage and converts generic
MM to use hw_pte_t *. Logical PTE values remain pte_t. Interfaces that
intentionally return a value through pte_t *, such as install_pte,
remain value interfaces; the relevant parameters are named ptentp to
make that distinction explicit.

The generic definition aliases hw_pte_t to pte_t unless an architecture
selects ARCH_HAS_HW_PTE_T, which enables a distinct generic wrapper. No
architecture selects it in this series, so the representation and
behaviour of every architecture are preserved. ptep_get() keeps its
existing READ_ONCE() semantics and converts the stored element through
__pte_from_hw(). An architecture can later select the option and convert
its PTE interfaces to make the distinction compiler-enforced.
Architecture PTE implementations and most architecture code are
deliberately left for those later opt-in conversions.

Here, hw_pte_t identifies PTE-table storage rather than table lifetime:
complete PTE tables use hw_pte_t whether or not they are currently
linked into a page-table hierarchy, while standalone copied values use
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
[3] https://github.com/musamaanjum/linux/commits/pte0_arm/

Thanks,
Usama
---
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
/// Pointers named "ptentp" refer to temporary logical PTE values and are
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

Muhammad Usama Anjum (9):
  mm: introduce hw_pte_t for PTE table storage
  mm: make hw_pte_t visible to generic PTE interfaces
  mm: name pointers to copied PTE values ptentp
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
 include/linux/hugetlb.h                       | 52 ++++++------
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
 mm/khugepaged.c                               | 24 +++---
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
 mm/sparse-vmemmap.c                           | 24 +++---
 mm/swap_state.c                               |  3 +-
 mm/swapfile.c                                 |  5 +-
 mm/userfaultfd.c                              | 32 ++++----
 mm/util.c                                     |  2 +-
 mm/vmalloc.c                                  | 13 +--
 mm/vmscan.c                                   |  6 +-
 66 files changed, 437 insertions(+), 368 deletions(-)
 create mode 100644 include/linux/pgtable_types.h

-- 
2.47.3


