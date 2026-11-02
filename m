Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B6B5606A337
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 03:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fkuI0iLs
Received: by kanga.kvack.org (Postfix)
	id 5B1CA6B05B4; Sun,  1 Nov 2026 22:52:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5886D6B05B5; Sun,  1 Nov 2026 22:52:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C57D6B05B7; Sun,  1 Nov 2026 22:52:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1D9616B05B4
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 22:52:41 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 57087C0BFB
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:52:38 +0000 (UTC)
X-FDA: 85388807196.10.046F916
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9C579100004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:52:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fkuI0iLs;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793591556;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cX4IVpVLnvryQWsXW1OKHS1dQ6xd/jMTkk4DydFZLgk=;
	b=VRRZmIM0QqZBYmFYZ6nRo3ucu1WHDhH9DjKw9zZ5IKB91W/K2S4TolZdwEXfpJ9ae406hs
	RVM+Po+XT89vvVB4dLAyp83JcIshXY1Ou4EKO0DVq0BhZukjsGzdJBwngeNwb2oHmX5m4x
	8rmYl7EuiAOun9PwGJWHhiN1UtpSn6Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793591556;
	b=2lpEWnVLDOc53002iUhwNLPZRzEyHonSsIuVxK0S/Gb+k3Fuon6cXRjVFeNti1y8UGN19h
	vLG9tAmqKUMdm2sKzvbmU1B0IhA1N6vRSOFXdpTMj+YFGWc6U9538BX7EHE8GQvba9OlBc
	CczCWrc3wHnlqlcJKOFiuuQbCodVsKs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fkuI0iLs;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5B797405C5;
	Mon,  2 Nov 2026 03:52:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB6E1F00919;
	Mon,  2 Nov 2026 03:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793591555;
	bh=cX4IVpVLnvryQWsXW1OKHS1dQ6xd/jMTkk4DydFZLgk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fkuI0iLsSHyNXxMUXoK1LPpDJ2L7yxksvPdzghBA56q5PSRJhLXOKeFmKsiID+hW7
	 WqQV8J90o/PAr6o9s35QBL3oXSyAIUPsqB8z2FeaAoN8cqySzRb3MKcpqdog8GYS23
	 FudapdLLFvYq28EF3hxh6tZERVpUmU/XUu0orAPolAdou0XL5SVZJJ8GIptLHYrDnR
	 wjSHCZNXeUEp9Qi27mOt4FgTOTBOI+bHYzSIGAlgiQoTIe2gcQOZa9X8U/6O14qLy3
	 9i0I0YYady0A0JOsGJitbFwYcFK/E3C47eJP64iRm7CDTkgmNtu3R5mcd0Mrypdk95
	 0qwVQhAC0PDdw==
Message-ID: <sashiko-outbox-192874@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 07/12] mm: hugetlb_vmemmap: simplify shared tail page
 handling
Reply-To: sashiko-reviews@lists.linux.dev
To: "Muchun Song" <songmuchun@bytedance.com>, "Oscar Salvador" <osalvador@suse.de>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Mike Rapoport" <rppt@kernel.org>
Cc: "Qi Zheng" <qi.zheng@linux.dev>, "Lance Yang" <lance.yang@linux.dev>, "James
 Houghton" <jthoughton@google.com>, "David Hildenbrand" <david@kernel.org>, "Muchun
 Song" <muchun.song@linux.dev>, linux-mm@kvack.org
In-Reply-To: <20261102032525.3597743-8-songmuchun@bytedance.com>
References: <20261102032525.3597743-1-songmuchun@bytedance.com>
 <20261102032525.3597743-8-songmuchun@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 03:52:34 +0000
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9C579100004
X-Stat-Signature: 1gb7s6xp4wrjttadid1qj8rigwkzf1mq
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793591556-932175
X-HE-Meta: U2FsdGVkX1+QhgzmOQRfOiQNJHc0UkuTtNorZ8hzhy0+N8MEuf7DQlEAka16C8UnUvwPxj8NzXuf2ww0epOkishx+PCks4PRMyl/H1gJGp1vsHrFQirl2x4hzddJNHXxi40hMVfsjvXc6J38l9RQ2w14MAG8IWbQOjZUaXaR4orDLXbiTWlfyp6GtCH0OGCjnNOu5ow0kDKCXQ1jQD4lwpt8TVpO6YmdCBMXOg5mqiJ0HKQook8vVLi+C91hC8vs40aQ4LOsZgPCNaAOMKkyDuMbh5JRp5LDiRlutXCWkup0TnxkNpDmIC4u1IOBltWhoGXBrEnmAjQ/1UdN6Tp/GMzlTPkzwRmgfpdeiz/S06IFlnbt47pKkVp9wCb88zpi6NnVHV/ClXOLkzx66ltwh4IfkfksIAm5O0Fi4xvrN5il8L0WTste9vFQ8ztVRKZjwry7BnAcdF5Xyy3OSx7RiOAkQgjOCZx4dSL96JI0sJ1UwXa/xvvXNy59tdr4v8zPsIr9hILyCS6UgexK0EZvhrCZSDcL4QgB1BiXi1xDy0HOZbAi5hxyMn2j5D0qOGiaZsXxxhripaGG5RhPyaoR8utqYhqgpJDgFerhaYPJLfhHz2lHcAB2AynuAc61XNYafCWZk1ye4fRiZminqx1uPBKqrV1Z8VpqtmG8nj2W40k+GIsniYgbuYG2MPgJBs+osPjSh63p1zxCBjLIXY/veQOmkUbC77LB9OpSvEli7gtLOOzE16wDLJJT5bSVCOs6L+o0Y2KFrOhqe5mdNW7tO+FY3XbTM8HcQZ4+Pa41I4gdG6WQHtszaZBXIfbE8S20pLgjQjuN9AIRS3mWAcoYGLoZIbnFnaBpJl0qCBU4UqCXD/+gT/XJWJu6bZjP8En2o6goZwMRBgPTlbTmRWdF3xjtQdl8YhY7uHgy5e9HNBxVK5G25PPFbM1+FGcBpETyqYAKVn4TQxuRfvJHzNm
 F1Ebi1Th
 0sh5fvwCGbk+jPJei5rguJDqtJhjfnKx3I6jRLbtdF4SyyeJ/66/+H+g6XlXZuIcW4LP6uTvLLIvSiL893mxFU5rNuUk1t/lA0nDu67Q6icWedCTipk81OOWTrpboqr6wH2/iF530B9lkpVQKD+9QnA+5+/PAITFHEwlGoiH2uIe6wAutVvIchN+1tzJ94WXpOueyXgzON6vNbt6VO4vcsQZR70gGvKbCl7OoocFmSGemtXQJ41vHadth6BoM+o5dOEKxSH5Nr5D3ycJBFBZDnV1L2cAouo4rqHFvGapKTCTXxsFOqSajhwJAfm4ScyYaSMBdsMGfx+s7VoAr0H1lN7sHtubNsI4gDf+AzdrnWubkswBG0sFsV0xa1Gli9oo8vhqzkPQhDBr0Lxn7l205X5CtshgEyNW+cl73jIgbI3mzp8EyI3w7aS7UUnl62GQs+RqSu7GZuAch6fpe8xiAQqw2aWfVIpWW8qPUw1FbnOASyAY6AlkkSlmIic0bA89TNDDnZWOf9cP4TXV53soQ7lUWlm1zj4tc7X+RhxSHAnOvq99LNkWxwM9HI7JE7VmYjknWZVk9fFh8WJn8dbwe3PNtG6Nm8mLE1YsyxCKyzAeAMFurTdfYnGehea8feABPFhvjWYE0s/IDqq4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] mm: hugetlb_vmemmap: uninitialized tail page read in vmemmap_optim=
ize_pte()
--

commit 32511c4a4d8ec3d45e0f629f89666a78dc9372ee
Author: Muchun Song <muchun.song@linux.dev>

mm: hugetlb_vmemmap: simplify shared tail page handling

This commit removes the vmemmap_tail field from struct vmemmap_remap_walk a=
nd
updates vmemmap_optimize_pte() and vmemmap_restore_pte() to derive the shar=
ed
tail page directly from the folio being processed.

> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> index 5e84004db4b87..d0af251aa533c 100644
> --- a/mm/hugetlb_vmemmap.c
> +++ b/mm/hugetlb_vmemmap.c

[ ... ]

> @@ -213,53 +211,53 @@ static struct page *vmemmap_dup_page_from_list(cons=
t struct page *src,
>  	return dst;
>  }
> =20
> -static void vmemmap_optimize_pte(pte_t *pte, unsigned long addr,
> -				 struct vmemmap_remap_walk *walk)
> +static inline struct page *folio_vmemmap_shared_tail_page(const struct f=
olio *folio)
>  {
> -	struct page *page =3D pte_page(ptep_get(pte));
> -	pte_t entry;
> -
> -	/* Remapping the head page requires r/w */
> -	if (unlikely(walk->nr_walked =3D=3D 0)) {
> -		struct page *head;
> +	return vmemmap_shared_tail_page(folio_order(folio), folio_zone(folio));
> +}
> =20
> -		VM_WARN_ON_ONCE(!PageHead((const struct page *)addr));
> +static int vmemmap_optimize_pte(pte_t *pte, unsigned long addr,
> +				struct vmemmap_remap_walk *walk)
> +{
> +	const struct page *page =3D (const struct page *)addr;
> +	const struct folio *folio =3D page_folio(page);
> +	struct page *src =3D pte_page(ptep_get(pte)), *dst;
> =20
> -		head =3D vmemmap_dup_page_from_list(page, walk->vmemmap_pages);
> -		entry =3D mk_pte(head, PAGE_KERNEL);
> +	if (likely(vmemmap_optimizable_pfn(page_to_pfn(page), folio_order(folio=
)))) {
> +		dst =3D folio_vmemmap_shared_tail_page(folio);
> +		if (!dst)
> +			return -ENOMEM;
>  	} else {
> -		VM_WARN_ON_ONCE(!PageTail((const struct page *)addr));
> -
> -		/*
> -		 * Map the shared tail page writable. A lockless get that read
> -		 * a non-zero refcount before the remap can still do its
> -		 * cmpxchg after it. The refcount is zero, so the cmpxchg
> -		 * fails and leaves the page unchanged.
> -		 */
> -		entry =3D mk_pte(walk->vmemmap_tail, PAGE_KERNEL);
> +		dst =3D vmemmap_dup_page_from_list(src, walk->vmemmap_pages);
>  	}

[Severity: High]
Can calling page_folio(page), folio_order(folio), and
folio_vmemmap_shared_tail_page(folio) on every PTE in vmemmap_optimize_pte()
read uninitialized tail struct pages for bootmem gigantic hugepages?

During early boot in alloc_bootmem_huge_page(), gigantic hugepages mark all
tail pages [pfn + 1, pfn + nr_pages) with memblock_reserved_mark_noinit(), =
so
memmap_init_reserved_pages() skips initializing their struct pages:

mm/hugetlb.c:alloc_bootmem_huge_page() {
    ...
	if (hugetlb_vmemmap_optimizable(h))
		hugetlb_vmemmap_optimize_bootmem_page(pfn, huge_page_order(h));
    ...
	memblock_reserved_mark_noinit(PFN_PHYS(pfn + 1),
				      (nr_pages - 1) * PAGE_SIZE);
}

When a bootmem gigantic hugepage is not aligned to PAGES_PER_SECTION (for
example, when nr_pages < PAGES_PER_SECTION, such as on 64-bit LoongArch with
16KB base pages where SECTION_SIZE_BITS is 29 and PMD_SHIFT is 25 with
CONFIG_ARCH_FORCE_MAX_ORDER=3D10), section_set_compound_order_range() retur=
ns
early without setting section->compound_page_order:

include/linux/vmemmap-optimization.h:section_set_compound_order_range() {
	unsigned long section_nr =3D pfn_to_section_nr(pfn);

	if (!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION))
		return;
    ...
}

In that case, sparse_init() allocates regular vmemmap pages via
memmap_alloc(), leaving them uninitialized (or filled with 0xff under
CONFIG_DEBUG_VM).

Later, gather_bootmem_prealloc_node() initializes only the first
VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES struct pages (covering only the first
vmemmap PTE), and prep_and_add_bootmem_folios() defers initializing the
remaining tail struct pages until after hugetlb_vmemmap_optimize_folios()
runs and fails:

mm/hugetlb.c:gather_bootmem_prealloc_node() {
    ...
		hugetlb_folio_init_vmemmap(folio, h,
					   VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES);
		init_new_hugetlb_folio(folio);

		if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
			folio_set_hugetlb_vmemmap_optimized(folio);
    ...
}

mm/hugetlb.c:prep_and_add_bootmem_folios() {
	/* Send list for bulk vmemmap optimization processing */
	hugetlb_vmemmap_optimize_folios(h, folio_list);

	list_for_each_entry_safe(folio, tmp_f, folio_list, lru) {
		if (!folio_test_hugetlb_vmemmap_optimized(folio)) {
			hugetlb_folio_init_tail_vmemmap(folio, h,
					VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES,
					pages_per_huge_page(h));
		}
    ...
}

Previously, __hugetlb_vmemmap_optimize_folio() derived vmemmap_tail upfront
from the initialized head folio, and vmemmap_optimize_pte() checked
walk->nr_walked =3D=3D 0 without inspecting tail struct pages.

With this change, on the second and subsequent PTEs (where addr >=3D
vmemmap_start + VMEMMAP_OPTIMIZATION_SIZE), page->compound_info in the tail
struct page at addr has not been initialized by prep_compound_tail() yet:

1. If the raw vmemmap backing pages are zeroed, page_folio(page) returns pa=
ge
itself rather than the head folio, folio_order(folio) returns 0, and
vmemmap_optimizable_pfn() returns false. vmemmap_optimize_pte() then falls
back to vmemmap_dup_page_from_list(src, walk->vmemmap_pages) for every tail
PTE, rotating the displaced vmemmap pages across the tail PTEs instead of
mapping the shared tail page, while leaving HPG_vmemmap_optimized set so
prep_and_add_bootmem_folios() skips hugetlb_folio_init_tail_vmemmap().

2. If CONFIG_DEBUG_VM is enabled, page_init_poison() fills the uninitialized
tail struct pages with 0xff. _compound_head(page) then evaluates to the
poisoned tail page itself, and folio_order(folio) reads 0xff, leading to an
out-of-bounds shift in vmemmap_optimizable_pfn() and an out-of-bounds
node_zones access in folio_zone(folio).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102032525.3597=
743-1-songmuchun@bytedance.com?part=3D7

