Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1EFFC531C9
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 16:47:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A183D6B008C; Mon, 27 Jul 2026 12:47:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C8166B0093; Mon, 27 Jul 2026 12:47:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 891866B0095; Mon, 27 Jul 2026 12:47:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4AA336B008C
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:47:39 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A84E114011D
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:47:38 +0000 (UTC)
X-FDA: 85035137796.11.726E3A5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 994AC80002
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:47:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=eNStiesH;
	spf=pass (imf02.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785170857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nT98Pvyhq3pUzz26qd9QnantLxIao/nQc8drPdV+5HQ=;
	b=LAZBOl48IKzs+hqiCl3/wJEAeTpyrPolmKR/+8dxYlwHaxCb3lt/E59acu7PpFpXbffXBB
	lK2R7XZK981rVEOdHJVPkPO8/c8AwEVwp9DO4gfX6USXZqWjXRdrEbadCNbciGggX4dNMQ
	1Jppu6YzEV9FYBA6MwHdvHHjksY9PcY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785170857;
	b=zgdU/j6D/6m6s8yxHi+usq8iiN9k+lnsiE1v/P9Kqb7gL6m1/W4Z8sWGMlMfmNAX9ktY2i
	hZJqoLNhdf2swz4SVq+atbEHpHk6psgvhBdzwnvo5qHULldY3/72JZ/GV0Dte4bHUgUJeP
	FXgaggzBXDW1mD6BT5zILaOPmT+3hdg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=eNStiesH;
	spf=pass (imf02.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 635E51682;
	Mon, 27 Jul 2026 09:47:31 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C8E073F86F;
	Mon, 27 Jul 2026 09:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785170855; bh=w4k+bQmvUuHGI/24VevNijHqxyxPwL/+LhPYxLtjyuU=;
	h=From:To:Cc:Subject:Date:From;
	b=eNStiesHwmBomV6wrOQ8H5zsD4tgspqHk2F4hp05t+nsAbON7NhhaJZIlsbIoaDE5
	 MQeD7VCk0M0n0M/zvl59Kf+yEaeZvKmNlr01S/W3ryf24Ziy0VJkB3GKbm+aeaR8ZL
	 t+/uPNoYKFC+9W5v+wKeGdyfY/NjlIvdqscmhDX0=
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
Subject: [PATCH RFC 00/11] mm: distinguish PTE table storage from PTE values
Date: Mon, 27 Jul 2026 17:46:51 +0100
Message-ID: <20260727164715.2866609-1-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 994AC80002
X-Stat-Signature: quizajp36bi5t4r6767xbogwpg8euf4w
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785170856-847177
X-HE-Meta: U2FsdGVkX1/7vwGPffu+LbWYzMz1TdkfhJUpLfQgacm6NG6BnRO3k741+P2zG8+zK3NRAR9yM51O0BGZ3t0C4OO2dWQgYEGF3/9c1JFeTMpoYWj2L408HuCw8beEkNdn3aaJWKfUl0IkF5/v3q6CrelY1hQV8SQTylOHUJHMrHL1fGL4xXSLarnmB/fXJnTnYS35zzDSoIwoGZfWmVdh1/9z6rExBV7Pqccexk0ao7rqMkYMWAk9aaScH8IIc1+tAqSRomXIwBEl6/S71/Y35M95qM24Aqwj4fDE2GDR0p4yAsIeGncbQ4CptDXtHEuNH5OGrE1mlGVr0SQM3XU4A/oUlXuvfb/tvLx6c5Gx8VknxxBk4FBPJgqaV1/0pgWbk7MNtLIocHBZ+Ftza6gFpJIphwBB2meFnkdZJvbIz23fRQyRysE8LSVTiyBBuzzYbtuzU8XPmkvhkg/4gJinEYjgeo0UL3Mcyrj5y8maNcxix4/kmuaQy77IDiSlHI9hoRX4Yu8MyahqXbdLNmjKFiuKOFOPTx7QP+fHnPz+zPrg382Cb317iLrjAUoL6piNQGoPVIqHjDI9wTnOfButLnDsA/54vXwtayELq4TnhUfwEhAROHOH0a/m9f/U1vj+r8VHDMXEfwKHsTcc0VYPYFae+Eqq0KT/uBD5GAyBVtd8UI2+rKa3sSXklASFzfjCPDPdZFgoa3vv1d6P67ZdvRNyJjYHKe1VqBRLlpauMtllEC16AMiwczYIEJLTP2H4fLPYVJBzsp7euWSkdBGnV3SZhu9omvbsnyPdTuci0pRM83WxOTeDRbjRkRqZR8PndMiKwBiOycDdTiAXt6ac8OxMPXbbmPVRtgdtdKF35ewxWqh7As29PS5Eqa5b5uAkSdZhax7PNgkbx7EwibifMDcI9sxQFXEltzzMy5nyUyNx4k5d950tT+j+nnsZ6RyyJuSK3ePBoGJLDkUlrSK
 WjuYOPHw
 k6FUvzA4ZJ777IuL0fVOkNEGYMAsBeZCbvOaX1Wi8s1KX1dpCQ+XuKOAc82c3Se0qdpgidcTb4PKdw8fDs/zNE/JNPjrcxJS9sVd7EMhU1UB91LOYK/njnmfP4Xn0RgQq7zws5hqwun9c5s0lxOQ26HiYTFLKMe6/zMsGKO2UF/AL9/S8bZoJyV4FdTPuJOM9ZyljsX9TH2MuRLiO+/gG0OGT9BwOaRszHIfmFivI0O8IiwS7W8H8GsO5CqtWFcUBX5gvpHvg2aqU09OABGTog/DbbP36tlWSYaTdkYY0kbH6tLHHM9BLH/AUfpDk8SQjKr+bDXcdlkjK+XVATDd8TFUpPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

pte_t currently describes both a logical PTE value and an element stored in
a PTE table. Consequently, pte_t * can point either to a standalone value,
often a stack copy, or to a PTE-table slot. The compiler cannot distinguish
these cases. A value pointer can therefore be passed to an interface that
expects table storage, while table storage can be read by direct
dereference instead of the architecture accessor.

This series begins a staged conversion at the PTE level. It introduces
hw_pte_t as the element type for PTE-table storage and converts generic MM
to use hw_pte_t *. Logical PTE values remain pte_t. Interfaces that
intentionally return a value through pte_t *, such as install_pte, remain
value interfaces; the relevant parameters are named ptentp to make that
distinction explicit.

The generic definition aliases hw_pte_t to pte_t, so this series preserves
the representation and behaviour of every architecture. ptep_get() keeps
its existing READ_ONCE() semantics and converts the stored element through
__pte_from_hw(). An architecture can later define a distinct hw_pte_t and
convert its PTE interfaces to make the distinction compiler-enforced.
Architecture PTE implementations and most architecture code are
deliberately left for those later opt-in conversions.

Here, hw_pte_t identifies PTE-table storage rather than table lifetime:
complete PTE tables use hw_pte_t whether or not they are currently linked
into a page-table hierarchy, while standalone copied values use pte_t. The
distinction between complete but unlinked tables and hardware-reachable
tables was raised during discussion and remains an important point for
review.

PMD, PUD, P4D and PGD storage are deliberately out of scope. They can be
converted in later series after the PTE boundary is agreed, avoiding the
PMD-specific cases that made an all-level conversion difficult to review.

Most mechanical pointer conversions were generated with the Coccinelle
script included below, then audited and fixed by hand.

This series does not add a second ptep_get_once() accessor and does not
remove or replace STRICT_MM_TYPECHECKS.

The design discussion is available at [1]; while the original idea came from
[2].

[1] https://lore.kernel.org/all/6110202c-057b-4701-8c04-1a76ee7bb9ab@arm.com/
[2] https://lore.kernel.org/all/a063f6c5-2785-4a9f-8079-25edb3e54cef@arm.com

Thanks,
Usama
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

Muhammad Usama Anjum (11):
  mm: introduce hw_pte_t for PTE table storage
  mm: make hw_pte_t visible to generic PTE interfaces
  mm: name pointers to copied PTE values ptentp
  mm: use hw_pte_t for generic PTE table storage
  mm: convert PTE table entries in ptep_get()
  mm/kasan: use hw_pte_t for the early shadow PTE table
  mm/mremap: use ptep_get() for the destination PTE
  drm/i915: use hw_pte_t for PTE range callbacks
  misc/sgi-gru: use ptep_get() for page-table reads
  parisc: use hw_pte_t for the data-break callback
  xen: use hw_pte_t for PTE range callbacks

 MAINTAINERS                                   |  1 +
 .../drm/i915/gem/selftests/i915_gem_mman.c    |  4 +-
 drivers/gpu/drm/i915/i915_mm.c                |  4 +-
 drivers/misc/sgi-gru/grufault.c               |  4 +-
 drivers/parisc/sba_iommu.c                    |  4 +-
 drivers/xen/gntdev.c                          |  2 +-
 drivers/xen/privcmd.c                         |  2 +-
 drivers/xen/xenbus/xenbus_client.c            |  2 +-
 drivers/xen/xlate_mmu.c                       |  4 +-
 fs/hugetlbfs/inode.c                          |  3 +-
 fs/proc/task_mmu.c                            | 39 ++++-----
 include/asm-generic/hugetlb.h                 | 15 ++--
 include/asm-generic/pgalloc.h                 |  6 +-
 include/asm-generic/tlb.h                     |  6 +-
 include/linux/hugetlb.h                       | 50 +++++++-----
 include/linux/kasan.h                         |  2 +-
 include/linux/mm.h                            | 26 +++---
 include/linux/page_table_check.h              | 10 ++-
 include/linux/pagewalk.h                      | 10 +--
 include/linux/pgtable.h                       | 81 ++++++++++---------
 include/linux/pgtable_types.h                 | 12 +++
 include/linux/rmap.h                          |  2 +-
 include/linux/swapops.h                       |  6 +-
 include/linux/vmalloc.h                       |  4 +-
 include/trace/events/xen.h                    | 10 +--
 kernel/bpf/arena.c                            |  9 ++-
 kernel/events/core.c                          |  3 +-
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
 mm/khugepaged.c                               | 23 +++---
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
 mm/mremap.c                                   |  6 +-
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
 67 files changed, 435 insertions(+), 374 deletions(-)
 create mode 100644 include/linux/pgtable_types.h

-- 
2.47.3


