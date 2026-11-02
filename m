Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F248606A326
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 13:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DAowWd3B
Received: by kanga.kvack.org (Postfix)
	id 488606B05B1; Mon,  2 Nov 2026 08:49:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4398D6B05B2; Mon,  2 Nov 2026 08:49:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3281A6B05B3; Mon,  2 Nov 2026 08:49:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 089E76B05B1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:49:09 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8A6941C45F9
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 13:49:08 +0000 (UTC)
X-FDA: 85390310376.07.2D0C4C5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id A906580005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 13:49:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DAowWd3B;
	spf=pass (imf30.hostedemail.com: domain of chenhuacai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793627346;
	b=K2ddDDQApg6qyyIGUkThhB91/QmOztnqo5rNkZ6I1LtF5e5zvmNYtXCsSPORJ4itJ9sPV5
	fwAvB/6CaQFUKHaXtN0NQbtVrPnDNuhteLFJSRDLAYpykVXhJh55W3aLPVCz0Zq0+FLH9M
	AV6RAepK6si8vEa8SYp6UPjQSgmEZGQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DAowWd3B;
	spf=pass (imf30.hostedemail.com: domain of chenhuacai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793627346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t19/VpHeuZfEnwqIz1VMgr6RSjKRD0I7ktZ5p1JSZr4=;
	b=7yx9sWlHP6tauBNcEQ8EuKMBHFQ2hTpiyAqk2AMH6wiD6vD806bAcK/C1hjtZY7DVddG80
	VgKuVV/3BdIuZeFpaHlz1U1eBF5zKrO+wddTCi3ZI0qknaMELPd9n1Ua88hvS6iaIG2alQ
	1G89Z3Wd0ZZC3ppu7mDfRElUeIjtZDk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1B5DB600E2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 13:49:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7DF11F00A16
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 13:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793627345;
	bh=t19/VpHeuZfEnwqIz1VMgr6RSjKRD0I7ktZ5p1JSZr4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=DAowWd3BMUfOYCsfzNlODEe95CKBes8NC8j1cPffVVZVFZQDgdjT3WLYp2VnOJKLt
	 IcB5y6w4kUbZv1cPdCLmYUMPvVqna4N8ai3wCyeqKoNhUv6hPHZbuo2QK42VD4MfyX
	 cZ3anIB5v1r1ErFiJja5fVMTccdAfNPZov4fMU0jCf3MTvzuVElfzRLIYoICiQhYvv
	 4QXnxTUll0IjMX98rYsajwypqPrJbDI9NAqt3fjuZ2b7ZpdxK7BDLcSmsgYV0E91dN
	 UGrsiqKH7M3QRPihurxs3rvC8y32qzJF1yUiasKVU7E0oj8Z6GPxntDn3NiKSXU8UD
	 UcfkHjax1xpmg==
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-7cc0e865dd1so985143137.1
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 05:49:05 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBxIxR3AimoXuZJ5ahIEsLbVQ0eYDY5gYE++VhLY7aC3UxzSuKbKGBwa1ZNUSDco8eVGOgiblGnY9A==@kvack.org
X-Gm-Message-State: APuU4Z9Y7dm468hfSUmNNCax68JJ0jl5VQTgg6EVwMJnrhFUhbkUfOSf
	kPqEuXMOpOdjeErYo7T/A8cgoUFAoTIGWuZaS09Oy0XiPr/i8Uu1LcuRv5bJ27lJdbc1v9Wtt0A
	cLa35zcJ/o7Dlogr5UFGkxC7if1jgV1Y=
X-Received: by 2002:a05:6102:6047:b0:7c3:ac59:158b with SMTP id
 ada2fe7eead31-7d072c91ddemr2933364137.23.1793627344929; Mon, 02 Nov 2026
 05:49:04 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261102032525.3597743-1-songmuchun@bytedance.com>
 <20261102032525.3597743-8-songmuchun@bytedance.com> <sashiko-outbox-192874@kernel.org>
 <2D6DE4F4-8DB1-45D4-B076-36FE6714C575@linux.dev>
In-Reply-To: <2D6DE4F4-8DB1-45D4-B076-36FE6714C575@linux.dev>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 2 Nov 2026 21:48:52 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4BPOJJy367p0MZcEWk3WziV3rPiCtoKPSGOqrQt5W1Pw@mail.gmail.com>
X-Gm-Features: AclHuK8vnwbfTipAOd6WMVXtrU5YJ6-7EJCkQE6p8MgAvtOeminm8SJMrGrSJ0M
Message-ID: <CAAhV-H4BPOJJy367p0MZcEWk3WziV3rPiCtoKPSGOqrQt5W1Pw@mail.gmail.com>
Subject: Re: [PATCH v2 07/12] mm: hugetlb_vmemmap: simplify shared tail page handling
To: Muchun Song <muchun.song@linux.dev>
Cc: sashiko-reviews@lists.linux.dev, Muchun Song <songmuchun@bytedance.com>, 
	Oscar Salvador <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>, 
	Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, Lance Yang <lance.yang@linux.dev>, 
	James Houghton <jthoughton@google.com>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
	WANG Xuerui <kernel@xen0n.name>, loongarch@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: A906580005
X-Stat-Signature: b1mr1eqe53rr3xdwdhh7ox3q6am9c83u
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793627346-430469
X-HE-Meta: U2FsdGVkX1/X3aN/RzIEchfbAyOAatq3CVLY23It2fyrEGHDX3za5OG51oUfhUNIfom/o19Hyb5oQhmEsk7oCVpuYphEEtX/Z9d/vYt7B8ML0d2yzy0PrXCcB/6+S9K8J19qQYFHEuQC3lvCQLr29pqxPEi9+se93NcX6ihQP3xf00GSAyCg3bc7jAgNS9xtsO+PjtV4bRsgdzRueM9EAK/rED3IYUGBqCdaepNWBQG4vVPgxgPM8UJr2Lp0BJ/7Xw87sC9TX5VSd4f/zgx+TD5+TPtvhh3Miv5XngQHM9HhC2I9stqtQD6XzExACtWwavYx7P6GEAphRQ1ltjzfxI+E6gdzcutfpV+9ymiLxaC/MQwGnKcnjz0X74ulsuhN6+tMmXu9ZEZAQB2igaKjUFJ8QC/JJhtpPTMXL+yZE/a2tgHd7qAKuMQpr7PsCk9CF/62D+1xupwuGTkGLcI9fgOxhl9B63UfVrVVeJD5qFNKNOEeeoSc54SAKN0RiLrrws73xWfMeMK0soUCV4OVAbALvHFq5s0otxtJR3Oxp5HtKqwRk2Cv+lzk3Boub3KNv21h1u06VDxwSAT3505YgXJMmRN52E2DAbeiucRCLQPOhzQtNpCkK9NcHogeCN65eRAl1ZAtkq62ObmoqGmrhB0gLOmBSZlVjetUkxpxe393EUxWTAUXNvjQUw0AczIZYdIqB6rAggWFqqUK5Q5CjvyO3yZ6/cJL8N1yCm7m9P4vwzljqkvXxQwscfFuM8yFg+IpYMVJ4s9JgNW4TvOfK41oAeW1d46Uq6qSUwEHgkBZdeJG5LFWL4l6NPa0ccb3HbnK6GjvfYbgzJZqVmxxPWaqCPY8bAGgV35N6B+EoReTuKj7a4dfFgmhyWs+pb8WTdJtpPIF2DS9MLi53BYto/rUZDS557yaO3xz0s++hrSY226JSW0u82veFQpf+KSA8rBuQMpSFX0BaigAIiP
 2CfgQkDh
 eL8Tib4tdPkRTcZCReQXH+emehq1FmEH384odDSMI+aKsRA9R5+x1+7IL4vhQVOBWrVqq/aWnzzawaeKIfE/StD9JN63F/tssbxF1pS0MFHCMUiQ0RBeqw2Q9L+GGfvUSn3Z0JrZGctIbg4Fo77TXGgF3gUXMhNRMyVGhpM5iTmr2ApnPGTh8WUHKuW5LVr9/oSBbg5zQjLtYsXEr7R7uIynxHtH58PDNUjylgyNrbwaL7g9lowsjtzrZLsdcbaZ82kMWCbP3UGd0IsivZOlUIcqSU5hRhnlxRBYbJVv0XS+hsPzdgh0/wyos/2+k5TyfzQfmaqQnnLFhFamD0xLudvsJi9OM/i1xHZZ3TtX5v33IYJz65LCdXkPS8RRElRkTqFogHgTaS/ncBoVUlHWVt9ecu7o2Mejs+ZXL3j9GHK+SYGSORcDnabFwdA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 2, 2026 at 2:12=E2=80=AFPM Muchun Song <muchun.song@linux.dev> =
wrote:
>
>
>
> > On Nov 2, 2026, at 11:52, sashiko-bot@kernel.org wrote:
> >
> > Thank you for your contribution! Sashiko AI review found 1 potential is=
sue(s) to consider:
> > - [High] mm: hugetlb_vmemmap: uninitialized tail page read in vmemmap_o=
ptimize_pte()
> > --
> >
> > commit 32511c4a4d8ec3d45e0f629f89666a78dc9372ee
> > Author: Muchun Song <muchun.song@linux.dev>
> >
> > mm: hugetlb_vmemmap: simplify shared tail page handling
> >
> > This commit removes the vmemmap_tail field from struct vmemmap_remap_wa=
lk and
> > updates vmemmap_optimize_pte() and vmemmap_restore_pte() to derive the =
shared
> > tail page directly from the folio being processed.
> >
> >> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> >> index 5e84004db4b87..d0af251aa533c 100644
> >> --- a/mm/hugetlb_vmemmap.c
> >> +++ b/mm/hugetlb_vmemmap.c
> >
> > [ ... ]
> >
> >> @@ -213,53 +211,53 @@ static struct page *vmemmap_dup_page_from_list(c=
onst struct page *src,
> >>      return dst;
> >> }
> >>
> >> -static void vmemmap_optimize_pte(pte_t *pte, unsigned long addr,
> >> -                             struct vmemmap_remap_walk *walk)
> >> +static inline struct page *folio_vmemmap_shared_tail_page(const struc=
t folio *folio)
> >> {
> >> -    struct page *page =3D pte_page(ptep_get(pte));
> >> -    pte_t entry;
> >> -
> >> -    /* Remapping the head page requires r/w */
> >> -    if (unlikely(walk->nr_walked =3D=3D 0)) {
> >> -            struct page *head;
> >> +    return vmemmap_shared_tail_page(folio_order(folio), folio_zone(fo=
lio));
> >> +}
> >>
> >> -            VM_WARN_ON_ONCE(!PageHead((const struct page *)addr));
> >> +static int vmemmap_optimize_pte(pte_t *pte, unsigned long addr,
> >> +                            struct vmemmap_remap_walk *walk)
> >> +{
> >> +    const struct page *page =3D (const struct page *)addr;
> >> +    const struct folio *folio =3D page_folio(page);
> >> +    struct page *src =3D pte_page(ptep_get(pte)), *dst;
> >>
> >> -            head =3D vmemmap_dup_page_from_list(page, walk->vmemmap_p=
ages);
> >> -            entry =3D mk_pte(head, PAGE_KERNEL);
> >> +    if (likely(vmemmap_optimizable_pfn(page_to_pfn(page), folio_order=
(folio)))) {
> >> +            dst =3D folio_vmemmap_shared_tail_page(folio);
> >> +            if (!dst)
> >> +                    return -ENOMEM;
> >>      } else {
> >> -            VM_WARN_ON_ONCE(!PageTail((const struct page *)addr));
> >> -
> >> -            /*
> >> -             * Map the shared tail page writable. A lockless get that=
 read
> >> -             * a non-zero refcount before the remap can still do its
> >> -             * cmpxchg after it. The refcount is zero, so the cmpxchg
> >> -             * fails and leaves the page unchanged.
> >> -             */
> >> -            entry =3D mk_pte(walk->vmemmap_tail, PAGE_KERNEL);
> >> +            dst =3D vmemmap_dup_page_from_list(src, walk->vmemmap_pag=
es);
> >>      }
> >
> > [Severity: High]
> > Can calling page_folio(page), folio_order(folio), and
> > folio_vmemmap_shared_tail_page(folio) on every PTE in vmemmap_optimize_=
pte()
> > read uninitialized tail struct pages for bootmem gigantic hugepages?
> >
> > During early boot in alloc_bootmem_huge_page(), gigantic hugepages mark=
 all
> > tail pages [pfn + 1, pfn + nr_pages) with memblock_reserved_mark_noinit=
(), so
> > memmap_init_reserved_pages() skips initializing their struct pages:
> >
> > mm/hugetlb.c:alloc_bootmem_huge_page() {
> >    ...
> >       if (hugetlb_vmemmap_optimizable(h))
> >               hugetlb_vmemmap_optimize_bootmem_page(pfn, huge_page_orde=
r(h));
> >    ...
> >       memblock_reserved_mark_noinit(PFN_PHYS(pfn + 1),
> >                                     (nr_pages - 1) * PAGE_SIZE);
> > }
> >
> > When a bootmem gigantic hugepage is not aligned to PAGES_PER_SECTION (f=
or
> > example, when nr_pages < PAGES_PER_SECTION, such as on 64-bit LoongArch=
 with
> > 16KB base pages where SECTION_SIZE_BITS is 29 and PMD_SHIFT is 25 with
> > CONFIG_ARCH_FORCE_MAX_ORDER=3D10), section_set_compound_order_range() r=
eturns
>
> This issue does not occur with the default LoongArch configuration. For
> 16KB base pages, LoongArch defaults ARCH_FORCE_MAX_ORDER to 11, which
> matches HUGETLB_PAGE_ORDER.
>
> The reported case requires manually overriding CONFIG_ARCH_FORCE_MAX_ORDE=
R
> to 10 while keeping HugeTLB enabled. This creates an **invalid configurat=
ion**
> that Kconfig currently permits:
>
> HUGETLB_PAGE_ORDER      =3D 11
> MAX_FOLIO_ORDER         =3D 10
>
> LoongArch does not select ARCH_HAS_GIGANTIC_PAGE, so the generic MM code
> assumes that folios cannot exceed MAX_PAGE_ORDER. The forced configuratio=
n
> violates that assumption and is already diagnosed by:
>
>         WARN_ON(order > MAX_FOLIO_ORDER);
>
> in hugetlb_add_hstate().
>
> Therefore, this is not a regression in a supported LoongArch configuratio=
n,
> and I don't think this series needs to handle it. The proper fix is a sep=
arate
> LoongArch Kconfig change preventing ARCH_FORCE_MAX_ORDER from being set b=
elow
> the HugeTLB order when HugeTLB is enabled.
Yes, this isn't a regression, the problem existed before this series.

I suggest change BUILD_BUG_ON_INVALID(HUGETLB_PAGE_ORDER >
MAX_FOLIO_ORDER) to MAYBE_BUILD_BUG_ON(HUGETLB_PAGE_ORDER >
MAX_FOLIO_ORDER) in mm/hugetlb.c, which cause a build error
immediately for invalid ARCH_FORCE_MAX_ORDER configurations.

Huacai

>
> Cc LoongArch maintainers.
>
> Thanks,
> Muchun
>
> > early without setting section->compound_page_order:
> >
> > include/linux/vmemmap-optimization.h:section_set_compound_order_range()=
 {
> >       unsigned long section_nr =3D pfn_to_section_nr(pfn);
> >
> >       if (!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION))
> >               return;
> >    ...
> > }
> >
> > In that case, sparse_init() allocates regular vmemmap pages via
> > memmap_alloc(), leaving them uninitialized (or filled with 0xff under
> > CONFIG_DEBUG_VM).
> >
> > Later, gather_bootmem_prealloc_node() initializes only the first
> > VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES struct pages (covering only the fi=
rst
> > vmemmap PTE), and prep_and_add_bootmem_folios() defers initializing the
> > remaining tail struct pages until after hugetlb_vmemmap_optimize_folios=
()
> > runs and fails:
> >
> > mm/hugetlb.c:gather_bootmem_prealloc_node() {
> >    ...
> >               hugetlb_folio_init_vmemmap(folio, h,
> >                                          VMEMMAP_OPTIMIZATION_NR_STRUCT=
_PAGES);
> >               init_new_hugetlb_folio(folio);
> >
> >               if (vmemmap_optimizable_order(pfn_to_section_compound_ord=
er(pfn)))
> >                       folio_set_hugetlb_vmemmap_optimized(folio);
> >    ...
> > }
> >
> > mm/hugetlb.c:prep_and_add_bootmem_folios() {
> >       /* Send list for bulk vmemmap optimization processing */
> >       hugetlb_vmemmap_optimize_folios(h, folio_list);
> >
> >       list_for_each_entry_safe(folio, tmp_f, folio_list, lru) {
> >               if (!folio_test_hugetlb_vmemmap_optimized(folio)) {
> >                       hugetlb_folio_init_tail_vmemmap(folio, h,
> >                                       VMEMMAP_OPTIMIZATION_NR_STRUCT_PA=
GES,
> >                                       pages_per_huge_page(h));
> >               }
> >    ...
> > }
> >
> > Previously, __hugetlb_vmemmap_optimize_folio() derived vmemmap_tail upf=
ront
> > from the initialized head folio, and vmemmap_optimize_pte() checked
> > walk->nr_walked =3D=3D 0 without inspecting tail struct pages.
> >
> > With this change, on the second and subsequent PTEs (where addr >=3D
> > vmemmap_start + VMEMMAP_OPTIMIZATION_SIZE), page->compound_info in the =
tail
> > struct page at addr has not been initialized by prep_compound_tail() ye=
t:
> >
> > 1. If the raw vmemmap backing pages are zeroed, page_folio(page) return=
s page
> > itself rather than the head folio, folio_order(folio) returns 0, and
> > vmemmap_optimizable_pfn() returns false. vmemmap_optimize_pte() then fa=
lls
> > back to vmemmap_dup_page_from_list(src, walk->vmemmap_pages) for every =
tail
> > PTE, rotating the displaced vmemmap pages across the tail PTEs instead =
of
> > mapping the shared tail page, while leaving HPG_vmemmap_optimized set s=
o
> > prep_and_add_bootmem_folios() skips hugetlb_folio_init_tail_vmemmap().
> >
> > 2. If CONFIG_DEBUG_VM is enabled, page_init_poison() fills the uninitia=
lized
> > tail struct pages with 0xff. _compound_head(page) then evaluates to the
> > poisoned tail page itself, and folio_order(folio) reads 0xff, leading t=
o an
> > out-of-bounds shift in vmemmap_optimizable_pfn() and an out-of-bounds
> > node_zones access in folio_zone(folio).
> >
> > --
> > Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102032525.=
3597743-1-songmuchun@bytedance.com?part=3D7
>

