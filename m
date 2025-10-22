Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B9B2CCD1BB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 11:55:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3D5E8E000A; Wed, 22 Oct 2025 07:55:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E14E88E0002; Wed, 22 Oct 2025 07:55:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2ABF8E000A; Wed, 22 Oct 2025 07:55:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C1B328E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 07:55:19 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 88BE5C0837
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 11:55:19 +0000 (UTC)
X-FDA: 84025594758.09.51C3A36
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf07.hostedemail.com (Postfix) with ESMTP id 674EA4000A
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 11:55:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Tzl4UIUC;
	spf=pass (imf07.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761134117; a=rsa-sha256;
	cv=none;
	b=lpT/P2Bp2l1GDXjLS18xyMw6qEnDYiy5nD4po+6DP954dOlfPZh9RuvGlb3KdXyzDv3tlU
	/i/cY7oNu7eihog51dh3baSfofbz9suYBRfKgCxFTZG5QDfTxwwK89OW7bXsLUOVnb9zJZ
	D05+irA18XJG2PNIKZ6gOiun6ktOh6Q=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Tzl4UIUC;
	spf=pass (imf07.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761134117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3anz9Xoypecd3KnBJKu2SEe+GoHlBtB+8NICP5dLvZU=;
	b=KlQO0JhyAXFhKnXyJo9GRBQiNPza8e9Ml4bphPUtlNlL7v6XINl6q6eC+sEQjRSt7FJNKh
	gP5Cw49BmM9RKPgDmhO6SZFSNvRIp1+eMfgUn+ZpPD7cqXi7vV6YUdIVpmvjyeWLmAM1pJ
	p8ibVSlzGQ+KTfqpeWF6yvcYYnT3GLY=
X-Forwarded-Encrypted: i=1; AJvYcCWYWdlcwv3UWtzT1WqYX2l2tDbnxz1jPORyVUp2XsbHsYW4Gb5JYvCl/1442gNnskRuwwtmLwx7Ug==@kvack.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761134115;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3anz9Xoypecd3KnBJKu2SEe+GoHlBtB+8NICP5dLvZU=;
	b=Tzl4UIUC21NlJx0TK2fafI0rxpzkvhzsHKMJHmK6rLll0yOuIXW5U10PC2l12Mcm6zVHT3
	kN7OiTuSX7pvbjN/UJDsAahMTFz7R08MtQsfymCm6UHM7oBS9DFLun0DPo/kseZ8mCrepX
	Q/YT9/w+dTXzjNluHHo/h0u1Yc7uTPM=
X-Gm-Message-State: AOJu0Ywcv3VR1BjqpxxTDi1TUGCZa4jqP3cECgBZTptlr8RgHGMx0bou
	yqPpPAU1SAI3qWFb6iqNZqHFDZuqfMjDOH17uGZTMF6O+spLUeqKd/BgaUgO98zrDL+rqmtexFd
	53GWFgSWCA4qRGBYH5ge7u2wHzLOXeds=
X-Google-Smtp-Source: AGHT+IHZJxZ1U3oPvy2l5YN+pFjSaAAubn8QK4QwG6aE2rmfYuNYY/hyqdkxjgytGV7PtICYeaJLn4Vz3+u/qBym7iE=
X-Received: by 2002:ad4:5b85:0:b0:766:be67:3e63 with SMTP id
 6a1803df08f44-87c20572737mr235341646d6.18.1761134105050; Wed, 22 Oct 2025
 04:55:05 -0700 (PDT)
MIME-Version: 1.0
References: <20251001065707.920170-1-balbirs@nvidia.com> <20251001065707.920170-5-balbirs@nvidia.com>
In-Reply-To: <20251001065707.920170-5-balbirs@nvidia.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
Date: Wed, 22 Oct 2025 19:54:28 +0800
X-Gmail-Original-Message-ID: <CABzRoyZZ8QLF5PSeDCVxgcnQmF9kFQ3RZdNq0Deik3o9OrK+BQ@mail.gmail.com>
X-Gm-Features: AS18NWCWKcU0vSe5CKpt6Lz9fM0G_zvx7umDf5kOeC6brpsJ4Dt06pu0gaElRJ0
Message-ID: <CABzRoyZZ8QLF5PSeDCVxgcnQmF9kFQ3RZdNq0Deik3o9OrK+BQ@mail.gmail.com>
Subject: Re: [v7 04/16] mm/rmap: extend rmap and migration support
 device-private entries
To: Balbir Singh <balbirs@nvidia.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linux-mm@kvack.org, akpm@linux-foundation.org, 
	David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Oscar Salvador <osalvador@suse.de>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Ralph Campbell <rcampbell@nvidia.com>, =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>, 
	Matthew Brost <matthew.brost@intel.com>, Francois Dugast <francois.dugast@intel.com>, 
	SeongJae Park <sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: tg9kzq8xtpm3ubpf7u6grx9fop5t18yi
X-Rspamd-Queue-Id: 674EA4000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1761134117-882084
X-HE-Meta: U2FsdGVkX19miYDiwo/zkI1Myl6w0sJFuzSKprQ9drxbr5kmedG/xxFI1EHpb+aTiBvzMuAqsYrZ58P0+isIOIzrSMYAbmzj2fWaBzt+n0l+ZPimu7Yuz8IpHEX5B6Ly2C3WH8x/H6AFTUoJm9LjUvVK6lr50FUIP9Z8BHvlMABWRR86pqYX4w2V8Uso+pfL5cmDjAb3IjO9IvCSWjxLzvcALL1v3UE7K39edOivYnnN1GFYaqggMfFKTraL3lelfwWStIfR4YQiVa0rhcuoV589zeDg4rCctpMMPrNhaK2lLungkGeRIt8FqY2tT6W4xocWOEgSzlc6PlTwZ0Hklo+hWCoQ4c5D9rhSJZAD9Lww6Z3thQ3Xn4ZSsBYBTKc+4tojT9LZ6hXA9OecysSn6hxOhbNT58a91e8GWL7mxt9gXa0RM99l5nBKjBtQV+Foem1O24MIb6VOPQ+0qxyuD9sawJS8Kg0Z5IHkPLN1W/vjLG/05dU6YyrvV07tP+rYIm3zRmezNB279lVAqUglBpQ4rU+7r+/9tn0nAB2Dt19OQ20///grC6dA3XNGlvnhFuq6iEeQXtwzK4Z2EIxKwhoewDsljUgI3VrcD0JEv2SCF0VsByxKlPhn4AjyM4RQiK6ywIcu7iHuOED+sy2WDz4Ysd9ry6sPsMg6O2kcztCYz7YSnlIiijoKH7o9MrGSjAUCxbk5nFfexulLKHkR9gcMR4B7TxKoBc7livZB8ulD0sDM/xcZix9ACKxzSpDi3SLSSdw0Vm/CsyKIS+m7A9sQSXxZyiIBhOXUCnWjqtFCG0kLIA9vLp3n4CB61SdFQXVpFXrlVOYOgACUibzAS6C5yIJ6Ky/+YuCIBGTtAobXhUYQTBFIp9gcwi28aL+cPWlQqArw1haKn/he3390vmCs3Tzxox1k8QMAbk5fMEkjwVdC2eOZW8dFIK1P71PVjqqfXqPsIBbd8CdsCf2
 DKllDgkf
 6+XMsAlCNzX8WFk5ehpg8ORIIVSRb0rf0mqbfB9bP1wbUrDVQ3rPS1FoEIjzhuW7xBHjvWXmoYZ97HxNLfppoJupc8XDtYNgLbRZ0gGLTbvOCcXmvAcnmJ5zrvvUXNbeNPl5Ml6V6tkZbnygzbR4e5VRqopl73bOXLLePrtPzoLBQG8iQP7emnOArKnWLc/lgzewSQK4A5WF6h/y9TbRZLVyht0QP+vuev4SfUWtThbEyyV4bnxl2ZDZGdss4J0Y9sOLw0Bxl26O5/P4uwE3XPONF5wQtrZY1pZp1bj/LUMgiZvQOkYgAO4oho6il0z/LzZ46XgykqwYnLF1ufao3qX78Mg2dJ9BL7fpWeu9imNWu0EvbMvEYtBATncERmxUZ5Lzb4YIyBb7RXIZsQX3TtzkJqzaqdhswW31ngnEXCyst07+AiJASF643nrEaPEjrraVnc22b3Uth1JrjPIc1VSWn2Z1AQ7csiYrY+dk3yV2hjQFibk91gzmNVZ15Opa7nkiFtlsMilxfODX4Zp5dJKuB9XBQ8qvWmhSb+w44qTxC2okgFAARkZVkkG6gGGHa7yBBi4lcGrV56ZnuiDwj0xKcawlBAVH+8wgy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 1, 2025 at 3:25=E2=80=AFPM Balbir Singh <balbirs@nvidia.com> wr=
ote:
>
> Add device-private THP support to reverse mapping infrastructure, enablin=
g
> proper handling during migration and walk operations.
>
> The key changes are:
> - add_migration_pmd()/remove_migration_pmd(): Handle device-private
>   entries during folio migration and splitting
> - page_vma_mapped_walk(): Recognize device-private THP entries during
>   VMA traversal operations
>
> This change supports folio splitting and migration operations on
> device-private entries.
>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: Rakie Kim <rakie.kim@sk.com>
> Cc: Byungchul Park <byungchul@sk.com>
> Cc: Gregory Price <gourry@gourry.net>
> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: Danilo Krummrich <dakr@kernel.org>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Simona Vetter <simona@ffwll.ch>
> Cc: Ralph Campbell <rcampbell@nvidia.com>
> Cc: Mika Penttil=C3=A4 <mpenttil@redhat.com>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Francois Dugast <francois.dugast@intel.com>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
> Reviewed-by: SeongJae Park <sj@kernel.org>
> ---
>  mm/damon/ops-common.c | 20 +++++++++++++++++---
>  mm/huge_memory.c      | 16 +++++++++++++++-
>  mm/page_idle.c        |  7 +++++--
>  mm/page_vma_mapped.c  |  7 +++++++
>  mm/rmap.c             | 24 ++++++++++++++++++++----
>  5 files changed, 64 insertions(+), 10 deletions(-)
>
> diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
> index 998c5180a603..ac54bf5b2623 100644
> --- a/mm/damon/ops-common.c
> +++ b/mm/damon/ops-common.c
> @@ -75,12 +75,24 @@ void damon_ptep_mkold(pte_t *pte, struct vm_area_stru=
ct *vma, unsigned long addr
>  void damon_pmdp_mkold(pmd_t *pmd, struct vm_area_struct *vma, unsigned l=
ong addr)
>  {
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -       struct folio *folio =3D damon_get_folio(pmd_pfn(pmdp_get(pmd)));
> +       pmd_t pmdval =3D pmdp_get(pmd);
> +       struct folio *folio;
> +       bool young =3D false;
> +       unsigned long pfn;
> +
> +       if (likely(pmd_present(pmdval)))
> +               pfn =3D pmd_pfn(pmdval);
> +       else
> +               pfn =3D swp_offset_pfn(pmd_to_swp_entry(pmdval));
>
> +       folio =3D damon_get_folio(pfn);
>         if (!folio)
>                 return;
>
> -       if (pmdp_clear_young_notify(vma, addr, pmd))
> +       if (likely(pmd_present(pmdval)))
> +               young |=3D pmdp_clear_young_notify(vma, addr, pmd);
> +       young |=3D mmu_notifier_clear_young(vma->vm_mm, addr, addr + HPAG=
E_PMD_SIZE);
> +       if (young)
>                 folio_set_young(folio);
>
>         folio_set_idle(folio);
> @@ -203,7 +215,9 @@ static bool damon_folio_young_one(struct folio *folio=
,
>                                 mmu_notifier_test_young(vma->vm_mm, addr)=
;
>                 } else {
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -                       *accessed =3D pmd_young(pmdp_get(pvmw.pmd)) ||
> +                       pmd_t pmd =3D pmdp_get(pvmw.pmd);
> +
> +                       *accessed =3D (pmd_present(pmd) && pmd_young(pmd)=
) ||
>                                 !folio_test_idle(folio) ||
>                                 mmu_notifier_test_young(vma->vm_mm, addr)=
;
>  #else
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 8e0a1747762d..483b8341ce22 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4628,7 +4628,10 @@ int set_pmd_migration_entry(struct page_vma_mapped=
_walk *pvmw,
>                 return 0;
>
>         flush_cache_range(vma, address, address + HPAGE_PMD_SIZE);
> -       pmdval =3D pmdp_invalidate(vma, address, pvmw->pmd);
> +       if (unlikely(!pmd_present(*pvmw->pmd)))
> +               pmdval =3D pmdp_huge_get_and_clear(vma->vm_mm, address, p=
vmw->pmd);
> +       else
> +               pmdval =3D pmdp_invalidate(vma, address, pvmw->pmd);
>
>         /* See folio_try_share_anon_rmap_pmd(): invalidate PMD first. */
>         anon_exclusive =3D folio_test_anon(folio) && PageAnonExclusive(pa=
ge);
> @@ -4678,6 +4681,17 @@ void remove_migration_pmd(struct page_vma_mapped_w=
alk *pvmw, struct page *new)
>         entry =3D pmd_to_swp_entry(*pvmw->pmd);
>         folio_get(folio);
>         pmde =3D folio_mk_pmd(folio, READ_ONCE(vma->vm_page_prot));
> +
> +       if (folio_is_device_private(folio)) {
> +               if (pmd_write(pmde))
> +                       entry =3D make_writable_device_private_entry(
> +                                                       page_to_pfn(new))=
;
> +               else
> +                       entry =3D make_readable_device_private_entry(
> +                                                       page_to_pfn(new))=
;
> +               pmde =3D swp_entry_to_pmd(entry);
> +       }
> +
>         if (pmd_swp_soft_dirty(*pvmw->pmd))
>                 pmde =3D pmd_mksoft_dirty(pmde);
>         if (is_writable_migration_entry(entry))
> diff --git a/mm/page_idle.c b/mm/page_idle.c
> index a82b340dc204..d4299de81031 100644
> --- a/mm/page_idle.c
> +++ b/mm/page_idle.c
> @@ -71,8 +71,11 @@ static bool page_idle_clear_pte_refs_one(struct folio =
*folio,
>                                 referenced |=3D ptep_test_and_clear_young=
(vma, addr, pvmw.pte);
>                         referenced |=3D mmu_notifier_clear_young(vma->vm_=
mm, addr, addr + PAGE_SIZE);
>                 } else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
> -                       if (pmdp_clear_young_notify(vma, addr, pvmw.pmd))
> -                               referenced =3D true;
> +                       pmd_t pmdval =3D pmdp_get(pvmw.pmd);
> +
> +                       if (likely(pmd_present(pmdval)))
> +                               referenced |=3D pmdp_clear_young_notify(v=
ma, addr, pvmw.pmd);
> +                       referenced |=3D mmu_notifier_clear_young(vma->vm_=
mm, addr, addr + PMD_SIZE);
>                 } else {
>                         /* unexpected pmd-mapped page? */
>                         WARN_ON_ONCE(1);
> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
> index c498a91b6706..137ce27ff68c 100644
> --- a/mm/page_vma_mapped.c
> +++ b/mm/page_vma_mapped.c
> @@ -277,6 +277,13 @@ bool page_vma_mapped_walk(struct page_vma_mapped_wal=
k *pvmw)
>                          * cannot return prematurely, while zap_huge_pmd(=
) has
>                          * cleared *pmd but not decremented compound_mapc=
ount().
>                          */
> +                       swp_entry_t entry =3D pmd_to_swp_entry(pmde);
> +
> +                       if (is_device_private_entry(entry)) {
> +                               pvmw->ptl =3D pmd_lock(mm, pvmw->pmd);
> +                               return true;
> +                       }
> +

We could make this simpler:

                        if (is_device_private_entry(pmd_to_swp_entry(pmde))=
) {
                                pvmw->ptl =3D pmd_lock(mm, pvmw->pmd);
                                return true;
                        }

Thanks,
Lance

>                         if ((pvmw->flags & PVMW_SYNC) &&
>                             thp_vma_suitable_order(vma, pvmw->address,
>                                                    PMD_ORDER) &&
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 9bab13429975..c3fc30cf3636 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1046,9 +1046,16 @@ static int page_vma_mkclean_one(struct page_vma_ma=
pped_walk *pvmw)
>                 } else {
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>                         pmd_t *pmd =3D pvmw->pmd;
> -                       pmd_t entry;
> +                       pmd_t entry =3D pmdp_get(pmd);
>
> -                       if (!pmd_dirty(*pmd) && !pmd_write(*pmd))
> +                       /*
> +                        * Please see the comment above (!pte_present).
> +                        * A non present PMD is not writable from a CPU
> +                        * perspective.
> +                        */
> +                       if (!pmd_present(entry))
> +                               continue;
> +                       if (!pmd_dirty(entry) && !pmd_write(entry))
>                                 continue;
>
>                         flush_cache_range(vma, address,
> @@ -2343,6 +2350,9 @@ static bool try_to_migrate_one(struct folio *folio,=
 struct vm_area_struct *vma,
>         while (page_vma_mapped_walk(&pvmw)) {
>                 /* PMD-mapped THP migration entry */
>                 if (!pvmw.pte) {
> +                       __maybe_unused unsigned long pfn;
> +                       __maybe_unused pmd_t pmdval;
> +
>                         if (flags & TTU_SPLIT_HUGE_PMD) {
>                                 split_huge_pmd_locked(vma, pvmw.address,
>                                                       pvmw.pmd, true);
> @@ -2351,8 +2361,14 @@ static bool try_to_migrate_one(struct folio *folio=
, struct vm_area_struct *vma,
>                                 break;
>                         }
>  #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
> -                       subpage =3D folio_page(folio,
> -                               pmd_pfn(*pvmw.pmd) - folio_pfn(folio));
> +                       pmdval =3D pmdp_get(pvmw.pmd);
> +                       if (likely(pmd_present(pmdval)))
> +                               pfn =3D pmd_pfn(pmdval);
> +                       else
> +                               pfn =3D swp_offset_pfn(pmd_to_swp_entry(p=
mdval));
> +
> +                       subpage =3D folio_page(folio, pfn - folio_pfn(fol=
io));
> +
>                         VM_BUG_ON_FOLIO(folio_test_hugetlb(folio) ||
>                                         !folio_test_pmd_mappable(folio), =
folio);
>
> --
> 2.51.0
>
>

