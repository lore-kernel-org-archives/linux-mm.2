Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DC26606A31B
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 06:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N265SDxC
Received: by kanga.kvack.org (Postfix)
	id BAE2A6B0888; Thu, 22 Oct 2026 02:06:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B11A66B088A; Thu, 22 Oct 2026 02:06:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A26086B088B; Thu, 22 Oct 2026 02:06:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6FCD16B0888
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:06:40 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E7B93801E2
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:06:39 +0000 (UTC)
X-FDA: 85349228118.07.9789509
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 44DB5C0005
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:06:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N265SDxC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792649198;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QmFVfIPiK3yVL8cu4/DHMMWLupj6SzaAmbRjChM9ymw=;
	b=rNw/CNokr3zyxar4Z2IioVY9fIPI23/8yLTdgpWInM8bEQ8EqnLWS2AWlETNVoCVY32F30
	xAA44ytYLoFrOGyz6cHt+YeoH0JZPk3TmGKtGDj+rY9S67v8ALXnShPWXo8TnaIv1hnYBj
	1bi5PHrWCN+/Tfs/3h2Fkp53q/IJAvM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N265SDxC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792649198;
	b=HD3oryaVT55Fj2I2KyGyQpL020DuhALybSBS5SirtrMNrXOsCyJtHIlJqeu9lDxOYc9V5Y
	VLc33+jWQih5LeFVO5fScPRWolDB8uENelJ35I7ryWr2JChQ0Yr3kbLEFZedSyUgA7/EAf
	vRijX9/K4C012T20korIKp09ilCAr7c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9CDF2447A2;
	Thu, 22 Oct 2026 06:06:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D2241F000C1;
	Thu, 22 Oct 2026 06:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792649197;
	bh=QmFVfIPiK3yVL8cu4/DHMMWLupj6SzaAmbRjChM9ymw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=N265SDxCwwe/ejJ86Rr1WAah+tOi2q5dnEXxIJu48uq6nX71+u0zlyRb3oXKN5pYf
	 j/LMJie81CzDaL/OZML4UnIHl2UGcWfETwdOPTwmAPMBAICxFY1L4K0GZACT3R8eXr
	 8Cv5+reZSYeFlwCbytD14jEzoKWJqVZSMK26PiLvVryRt+qt8WoF1sDH76DcM+KlSU
	 WC8ed8+bdX1+ormTTKj08Z1QBHH44OlSI8PWXnioGsw/AygELm1ScaK0l6Q/cdb5q9
	 RwavKi8PKZigD/BfgzpLlPMelvx7k2TRFNIqssnPPehTzcXTG2/bOQ62f9JACDd1Zk
	 +4l+iu3Ax6imw==
Message-ID: <sashiko-outbox-181053@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v16 05/12] mm/hmm: migrate collection in HMM pagewalk -
 pte level
Reply-To: sashiko-reviews@lists.linux.dev
To: mpenttil@redhat.com, linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org, "David
 Hildenbrand" <david@kernel.org>, "Jason Gunthorpe" <jgg@nvidia.com>, "Leon
 Romanovsky" <leonro@nvidia.com>, "Alistair Popple" <apopple@nvidia.com>, "Balbir
 Singh" <balbirs@nvidia.com>, "Zi Yan" <ziy@nvidia.com>, "Matthew Brost" <matthew.brost@intel.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <Liam.Howlett@oracle.com>, "Vlastimil Babka" <vbabka@suse.cz>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Lyude Paul" <lyude@redhat.com>, "Danilo
 Krummrich" <dakr@kernel.org>
In-Reply-To: <20261021060506.2377545-6-mpenttil@redhat.com>
References: <20261021060506.2377545-1-mpenttil@redhat.com>
 <20261021060506.2377545-6-mpenttil@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 06:06:35 +0000
X-Rspamd-Queue-Id: 44DB5C0005
X-Stat-Signature: t3185u7h5mwz7abqxdyh9k91a3so3m6m
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792649198-66625
X-HE-Meta: U2FsdGVkX18axlefUN7rZkOSr5q3WW9Qu9eqDOib/uJb6vw3nHZua85XK4pUqRLBQan6DXked8l0gBwXQUj0fHr8bZ3pe9Aq2lXGJv+jUV4A/iPqM0n6fQ37SAe4pmejhUJRNMN4BzyHoRghJtGNk19YyqtloRxT+23/iPQjOkWsJlNUuaNtW+VyaLoExXEqSbOWjBScJPkRSzzlCkSyMnUwQOcSFzSm0gRboI3lenc0LkEvCI9cJ3eRgUFwh2hrVkm5MA/QwmqWCtNErMRzGd1aQtHiFxwXesXwwzPdb1bfy3rJA2i7ZpHsTag23AzbOSHzmyDWp+SYoEFuN4XTcLfgKJx3O7+sQizoNmALrGl3/69rfb5bO6hvgJaUiDtcZhjtxX1EvF9EtoDMf6bi1B2XhT1TtEm5nXgT3wCMUVVcBZG4vZzfU6dkeWWhGinp17SkZbKo9dAmYp6jjqW5z5Bw0XSJKGxxBOqlhCAVExb4+qVZxvsQa2xV3Nv+BOaHEuyZAXR3Vd80qEVqD6ccly0+m7B7po7KaOREIgwzkKFyrWMTz+H6VwaiMhsD019ot+7dpRXN2Pq/dPmxHsPpoNN1G35nyuKhhGg73Rj6mgfLW4H3/lWdmZHhlqaymaSzQXOvSFHdDNZnyjSmBtujvsa782dh7sIyayWO1Vmd+nULM4rZynSHw2x855CtKv+bNXsiH1fsnQOVDGnI+fhDh87ZN03A+97HCH6VAEhJQ3JHjrZFlxS/TFDX4NHfTxeOW0B+5dyixrhnfxRbrkXWfFuv1IxWqlFbMuxI2qJUjFe3akdTUTobspEVvVFkwS68JW4/YV8DjzXQmVaayMoo2DtqC7imGBjxEreORekyH5+9w92gmzPWKxlDM5u0eSPjN0eySS8lN4MmZmLdOI9yjBiO4R/82KmiyP9Cun6xxmoMVlhKd8yA13GieDOvVteceLmHKLdKDYYcMMwaQei
 9LzQRyGD
 Yx7YzPwF5qINKg5wryq2MyK8lgdrpftamYXGoykmsxWBQ0maqScHn4TYP8+cKeVf3O+mTVw0Cvmo0IzDeyKH6iiGUhRmniNCgTUR4fyoUFuDyQlYDR5DoihTTgEhSVkK1AYNvIgCS2TCubYywee9a0P4dBKeXQ99mPcEQQIMLU/O6SlLE97uWXWOsG5YPN2ID+u7KCqlxPvOtA4fkQst+z4FWVH9PpyHKd6jC8Ht1lvKqxRTJfBfGMtq0IFl15jdHxOkT4K75PJENLOlBWct47higZdX57ls7NMhbbNkphjm8SXxuktdb4Qofm/iTT+UGW6jXV3mwVrUHTFj3mcluCbuejDJLkApNHXEG8ir+Jz3gAVmknJIB/3qw0UniSWIcU0SqmZhACeqRxSdIQk9d7RmXmCdHe4/GY4kJ2nM/c7IDz/lkk1FTXatLByANJLQNqe447bE+pLuHdnss2Vb7N7mHmC2JJQvJY6txKnjJLR3tp7GXKCt/zd1Sv4ByCBQ9XWXBRNx6rC71UYxFvkVFVLwYtMzdQ7jNYNBWxwRRnvP2bTnztYXujt+aaN2w84sF6BIskuVMhfSr3tFR4j9/QrDKOo8f0PhzJHTzcLramflomlK7EL0kZuWBzsgeqD4Mg7/F8Fs9zdH495Jc2ZitQVpo22Wt2t+pFCtn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:
- [Critical] mm/hmm: folio locks held across handle_mm_fault() and broken m=
igration PTE rollback
- [High] mm/hmm: folio split failure in hmm_vma_handle_migrate_prepare() ab=
orts PMD walk
- [High] mm/hmm: hmm_vma_handle_migrate_prepare() skips pte_protnone() and =
unowned PTEs
- [High] mm/hmm: blocking folio_lock() after folio_get() in migrate_vma_spl=
it_folio()
- [High] mm/hmm: UAF and lock drop on tail fault_page in migrate_vma_split_=
folio()
- [Medium] mm/hmm: fix zero pfn handling in hmm_vma_handle_migrate_prepare()
--

commit 16c2ec58848b6b4b76d718d33377a04eaa06ff45
Author: Mika Penttil=C3=A4 <mpenttil@redhat.com>

mm/hmm: migrate collection in HMM pagewalk - pte level

This commit implements migrate_vma_split_folio() and
hmm_vma_handle_migrate_prepare() in mm/hmm.c to split large folios and
install migration page table entries during pagewalk-based device
migration.

> diff --git a/mm/hmm.c b/mm/hmm.c
> index 119e70dbca56f..0ce947d0e5727 100644
> --- a/mm/hmm.c
> +++ b/mm/hmm.c
> @@ -491,6 +491,63 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk =
*walk, unsigned long start,
>  #endif  /* CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
> =20
>  #ifdef CONFIG_DEVICE_MIGRATION
> +/**
> + * migrate_vma_split_folio() - Helper function to split a THP folio
> + * @folio: the folio to split
> + * @fault_page: struct page associated with the fault if any
> + * @hmm_vma_walk: walk in progress
> + * @ptep: pte_t * for unmap and unlock ptl
> + *
> + * Returns 0 on success
> + */
> +static int migrate_vma_split_folio(struct folio *folio,
> +				   struct page *fault_page,
> +				   struct hmm_vma_walk *hmm_vma_walk,
> +				   pte_t *ptep)
> +{
> +	int ret;
> +	struct folio *fault_folio =3D fault_page ? page_folio(fault_page) : NUL=
L;
> +	struct folio *new_fault_folio =3D NULL;
> +
> +	if (folio !=3D fault_folio)
> +		folio_get(folio);
> +
> +	pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
> +	hmm_vma_walk->ptelocked =3D false;
> +
> +	if (folio !=3D fault_folio)
> +		folio_lock(folio);
> +
> +	ret =3D split_folio(folio);

[Severity: High]
When hmm_range_fault() -> hmm_vma_walk_pmd() ->
hmm_vma_handle_migrate_prepare() calls migrate_vma_split_folio() on a large
system or device-private folio with folio !=3D fault_folio,
migrate_vma_split_folio() takes a reference via folio_get(folio), drops the
page table lock with pte_unmap_unlock(ptep, hmm_vma_walk->ptl), and then
blocks on folio_lock(folio) before calling split_folio(folio).

Does this sequence introduce three regressions?

First, when concurrent tasks attempt to split or migrate the same large
folio, any task blocked in folio_lock(folio) holds an extra reference on
folio, causing the lock holder's split_folio() -> __folio_split() reference
count freeze check to fail with -EAGAIN (which
hmm_vma_handle_migrate_prepare() converts into -EFAULT).

Second, because the page table lock is dropped before folio_lock(folio) is
acquired, another thread can finish splitting folio and release the folio
lock before folio_lock(folio) returns. Calling split_folio(folio) without
re-checking folio_test_large(folio) under the folio lock will trigger
VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio) in __folio_split()
and fail with -EINVAL.

Third, earlier iterations of the page table walk in hmm_vma_walk_pmd() lock
collected folios via folio_trylock() and replace their page table entries
with migration entries (and fault_folio is also held locked when
migrate->fault_page is set). Blocking unconditionally on folio_lock(folio)
while holding locks and active migration entries on previously collected
folios violates the trylock-only requirement documented in
hmm_vma_handle_migrate_prepare() and can deadlock against concurrent
migrations or tasks waiting in migration_entry_wait().

> +	if (ret) {
> +		if (folio !=3D fault_folio) {
> +			folio_unlock(folio);
> +			folio_put(folio);
> +		}
> +		return ret;
> +	}
> +
> +	new_fault_folio =3D fault_page ? page_folio(fault_page) : NULL;
> +
> +	/*
> +	 * Ensure the lock is held on the correct
> +	 * folio after the split
> +	 */
> +	if (!new_fault_folio) {
> +		folio_unlock(folio);
> +		folio_put(folio);
> +	} else if (folio !=3D new_fault_folio) {
> +		if (new_fault_folio !=3D fault_folio) {
> +			folio_get(new_fault_folio);
> +			folio_lock(new_fault_folio);
> +		}
> +		folio_unlock(folio);
> +		folio_put(folio);
> +	}

[Severity: High]
Can this trigger a use-after-free when fault_page is a tail subpage of a
large device-private folio?

In mm/memory.c:do_swap_page(), when a page fault hits a device-private
entry mapping a tail subpage (vmf->page), do_swap_page() locks and takes a
single reference on folio =3D page_folio(vmf->page), drops vmf->ptl, and
calls pgmap->ops->migrate_to_ram(vmf) with migrate->fault_page =3D vmf->pag=
e:

mm/memory.c:do_swap_page() {
    ...
    folio =3D page_folio(vmf->page);
    if (folio_trylock(folio)) {
        struct dev_pagemap *pgmap;

        folio_get(folio);
        pte_unmap_unlock(vmf->pte, vmf->ptl);
        pgmap =3D page_pgmap(vmf->page);
        ret =3D pgmap->ops->migrate_to_ram(vmf);
        /* migrate_to_ram() might have split the folio. */
        folio =3D page_folio(vmf->page);
        folio_unlock(folio);
        folio_put(folio);
    ...
}

In migrate_vma_split_folio(), fault_folio =3D page_folio(fault_page) equals
folio on entry. Calling split_folio(folio) passes lock_at =3D &folio->page
instead of fault_page (unlike split_huge_page(fault_page)) to
mm/huge_memory.c:__folio_split():

mm/huge_memory.c:__folio_split() {
    ...
    for (new_folio =3D folio; new_folio !=3D end_folio; new_folio =3D next)=
 {
        next =3D folio_next(new_folio);
        if (new_folio =3D=3D page_folio(lock_at))
            continue;
        ...
        if (is_swapcache && !folio_mapped(new_folio))
            folio_free_swap(new_folio);
        folio_unlock(new_folio);
        folio_put(new_folio);
    }
}

Because lock_at is &folio->page (subpage 0), __folio_split() unlocks and
calls folio_put() on every other subfolio resulting from the split,
including new_fault_folio =3D page_folio(fault_page). If fault_page's page
table entry was concurrently zapped (for instance via MADV_DONTNEED after
do_swap_page() dropped vmf->ptl or right after __folio_split() unlocked
new_fault_folio), new_fault_folio has no remaining references and is freed
before split_folio(folio) returns.

Won't migrate_vma_split_folio() then call folio_get(new_fault_folio) and
folio_lock(new_fault_folio) on the unpinned and freed new_fault_folio
(hitting VM_BUG_ON_FOLIO(folio_ref_zero_or_close_to_overflow(folio), folio)
or a use-after-free) while also holding two order-0 folio locks at once?

> +
> +	return 0;
> +}
> +
>  static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
>  					      pmd_t *pmdp,
>  					      unsigned long start,
> @@ -501,6 +558,11 @@ static int hmm_vma_handle_migrate_prepare_pmd(const =
struct mm_walk *walk,
>  	return 0;
>  }
> =20
> +/*
> + * Install migration entries if migration requested, either from fault
> + * or migrate paths.
> + *
> + */
>  static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
>  					  pmd_t *pmdp,
>  					  pte_t *ptep,
> @@ -508,8 +570,207 @@ static int hmm_vma_handle_migrate_prepare(const str=
uct mm_walk *walk,
>  					  unsigned long *hmm_pfn,
>  					  bool *unmapped)
>  {
> -	// TODO: implement migration entry insertion
> +	struct hmm_vma_walk *hmm_vma_walk =3D walk->private;
> +	struct hmm_range *range =3D hmm_vma_walk->range;
> +	struct migrate_vma *migrate =3D range->migrate;
> +	struct mm_struct *mm =3D walk->vma->vm_mm;
> +	struct folio *fault_folio =3D NULL;
> +	enum migrate_vma_info minfo;
> +	struct dev_pagemap *pgmap;
> +	bool anon_exclusive;
> +	struct folio *folio;
> +	unsigned long pfn;
> +	struct page *page;
> +	softleaf_t entry;
> +	pte_t pte, swp_pte;
> +	bool writable =3D false;
> +
> +	// Do we want to migrate at all?
> +	minfo =3D hmm_select_migrate(range);
> +	if (!minfo)
> +		return 0;
> +
> +	WARN_ON_ONCE(!migrate);
> +	HMM_ASSERT_PTE_LOCKED(hmm_vma_walk, true);
> +
> +	fault_folio =3D migrate->fault_page ?
> +		page_folio(migrate->fault_page) : NULL;
> +
> +	pte =3D ptep_get(ptep);
> +
> +	if (pte_none(pte)) {
> +		if (vma_is_anonymous(walk->vma)) {
> +			*hmm_pfn &=3D HMM_PFN_INOUT_FLAGS;
> +			*hmm_pfn |=3D HMM_PFN_MIGRATE;
> +			goto out;
> +		}
> +	}
> +
> +	if (!(hmm_pfn[0] & HMM_PFN_VALID))
> +		goto out;
> +
> +	if (!pte_present(pte)) {
> +		/*
> +		 * Only care about unaddressable device page special
> +		 * page table entry. Other special swap entries are not
> +		 * migratable, and we ignore regular swapped page.
> +		 */
> +		entry =3D softleaf_from_pte(pte);
> +		if (!softleaf_is_device_private(entry))
> +			goto out;
> +
> +		if (!(minfo & MIGRATE_VMA_SELECT_DEVICE_PRIVATE))
> +			goto out;
> +
> +		page =3D softleaf_to_page(entry);
> +		folio =3D page_folio(page);
> +		if (folio->pgmap->owner !=3D migrate->pgmap_owner)
> +			goto out;

[Severity: High]
Does gating hmm_vma_handle_migrate_prepare() on HMM_PFN_VALID cause
hmm_range_fault() to skip pte_protnone() pages and unowned device-private
entries?

When migrate_vma_setup() is switched to hmm_range_fault() in the later
commit "mm: enable device page migration from HMM pagewalk", existing
callers (drm_pagemap_migrate_to_devmem(), svm_migrate_ram_to_vram(),
nouveau_dmem_migrate_vma(), and dmirror_migrate_to_device()) do not set
MIGRATE_VMA_FAULT, so range.default_flags is HMM_PFN_REQ_MIGRATE without
HMM_PFN_REQ_FAULT.

In hmm_vma_walk_pmd() -> hmm_vma_handle_pte(), when a present entry has
pte_protnone(pte) set (for example by task_numa_work() ->
change_prot_numa() or userfaultfd), pte_to_hmm_pfn_flags() returns 0:

mm/hmm.c:pte_to_hmm_pfn_flags() {
    if (pte_none(pte) || !pte_present(pte) || pte_protnone(pte))
        return 0;
    return pte_write(pte) ? (HMM_PFN_VALID | HMM_PFN_WRITE) : HMM_PFN_VALID;
}

Because hmm_pte_need_fault() also returns 0 when HMM_PFN_REQ_FAULT is not
set, hmm_vma_handle_pte() writes pte_pfn(pte) without HMM_PFN_VALID into
*hmm_pfn. Then hmm_vma_handle_migrate_prepare() checks
!(hmm_pfn[0] & HMM_PFN_VALID) and skips the page, whereas
migrate_vma_collect_pmd() previously collected all present normal pages
regardless of pte_protnone(pte) (and migrate_hmm_range_setup() and
hmm_pfn_collected() also require HMM_PFN_VALID to distinguish a collected
page from a zero page). This causes full-range migrations such as
drm_pagemap_migrate_to_devmem() to fail with -EBUSY and partial migrations
in amdkfd and nouveau to leave pages behind in system memory.

Similarly, for non-present device-private entries, hmm_vma_handle_pte()
only sets HMM_PFN_VALID when page_pgmap(softleaf_to_page(entry))->owner
matches range->dev_private_owner (and faults a read-only device-private
entry to system memory if HMM_PFN_REQ_FAULT | HMM_PFN_REQ_WRITE is set):

mm/hmm.c:hmm_vma_handle_pte() {
    ...
    if (softleaf_is_device_private(entry) &&
        page_pgmap(softleaf_to_page(entry))->owner =3D=3D
        range->dev_private_owner) {
        cpu_flags =3D HMM_PFN_VALID;
        if (softleaf_is_device_private_write(entry))
            cpu_flags |=3D HMM_PFN_WRITE;
        new_pfn_flags =3D softleaf_to_pfn(entry) | cpu_flags;
        goto out;
    }
}

Doesn't that make the !pte_present(pte) device-private migration path here
unreachable unless range->dev_private_owner is also set to
migrate->pgmap_owner?

> +
> +		if (folio_test_large(folio)) {
> +			int ret;
> +
> +			ret =3D migrate_vma_split_folio(folio,
> +						      migrate->fault_page,
> +						      hmm_vma_walk,
> +						      ptep);
> +			if (ret)
> +				goto out_error;
> +			return -EAGAIN;
> +		}
> +
> +		pfn =3D page_to_pfn(page);
> +		if (softleaf_is_device_private_write(entry))
> +			writable =3D true;
> +	} else {
> +		pfn =3D pte_pfn(pte);
> +		if (is_zero_pfn(pfn) &&
> +		    (minfo & MIGRATE_VMA_SELECT_SYSTEM)) {
> +			*hmm_pfn =3D HMM_PFN_MIGRATE;
> +			goto out;
> +		}

[Severity: Medium]
When is_zero_pfn(pfn) && (minfo & MIGRATE_VMA_SELECT_SYSTEM) is true,
hmm_vma_handle_pte() has already set:

    *hmm_pfn =3D (*hmm_pfn & HMM_PFN_INOUT_FLAGS) | pte_pfn(pte) | HMM_PFN_=
VALID;

Unlike the pte_none(pte) branch above (which preserves HMM_PFN_INOUT_FLAGS
and checks vma_is_anonymous(walk->vma)) and hmm_pfns_fill() (used for
pmd_none and is_huge_zero_folio() in the later commit "mm/hmm: migrate
collection in HMM pagewalk - pmd level"), assigning *hmm_pfn =3D
HMM_PFN_MIGRATE directly wipes out sticky HMM_PFN_INOUT_FLAGS
(HMM_PFN_DMA_MAPPED | HMM_PFN_P2PDMA | HMM_PFN_P2PDMA_BUS).

It also omits the vma_is_anonymous(walk->vma) check, even though
mm/migrate_device.c:migrate_vma_insert_page() refuses to populate
non-anonymous mappings:

mm/migrate_device.c:migrate_vma_insert_page() {
    /* Only allow populating anonymous memory */
    if (!vma_is_anonymous(vma))
        goto abort;
}

If a non-anonymous mapping maps a zero page (for example via ksm zero-page
merging in a private file mapping or dax_load_hole()), won't setting
*hmm_pfn =3D HMM_PFN_MIGRATE cause migrate_hmm_range_setup() to set
migrate->src[i] =3D MIGRATE_PFN_MIGRATE and increment migrate->cpages for a
page that migrate_vma_insert_page() will reject, while also losing the
valid zero-page pfn and HMM_PFN_VALID in range->hmm_pfns for callers like
nouveau_dmem_migrate_fault() that fall back to mapping in place?

> +		page =3D vm_normal_page(walk->vma, addr, pte);
> +		if (page && !is_zone_device_page(page) &&
> +		    !(minfo & MIGRATE_VMA_SELECT_SYSTEM)) {
> +			goto out;
> +		} else if (page && is_device_coherent_page(page)) {
> +			pgmap =3D page_pgmap(page);
> +
> +			if (!(minfo &
> +			      MIGRATE_VMA_SELECT_DEVICE_COHERENT) ||
> +			    pgmap->owner !=3D migrate->pgmap_owner)
> +				goto out;
> +		}
> +
> +		folio =3D page ? page_folio(page) : NULL;
> +		if (folio && folio_test_large(folio)) {
> +			int ret;
> +
> +			ret =3D migrate_vma_split_folio(folio,
> +						      migrate->fault_page,
> +						      hmm_vma_walk,
> +						      ptep);
> +			if (ret)
> +				goto out_error;
> +			return -EAGAIN;
> +		}

[Severity: High]
When migrate_vma_split_folio() fails (both here and in the !pte_present(pte)
branch above), hmm_vma_handle_migrate_prepare() jumps to out_error and
returns -EFAULT.

In hmm_vma_walk_pmd(), any non-zero, non--EAGAIN return from
hmm_vma_handle_migrate_prepare() fills [addr, end) with HMM_PFN_ERROR and
aborts the loop while returning 0:

mm/hmm.c:hmm_vma_walk_pmd() {
    ...
    r =3D hmm_vma_handle_migrate_prepare(walk, pmdp, ptep, addr, hmm_pfns, =
&unmapped);
    ...
    if (r) {
        /* A non -EAGAIN error here means migrate_vma_split_folio()
         * already dropped the PTE lock and cleared ptelocked.
         */
        HMM_ASSERT_UNLOCKED(hmm_vma_walk);
        if (unmapped)
            flush_tlb_range(walk->vma, start, addr);
        hmm_pfns_fill(addr, end, hmm_vma_walk, HMM_PFN_ERROR);
        return 0;
    }
}

split_folio() can routinely fail with -EBUSY or -EAGAIN when a folio has
extra references (such as gup pins or per-cpu lru caches) or -EINVAL when a
mapping has min_order > 0. When that happens during a call to
hmm_range_fault() with HMM_PFN_REQ_MIGRATE (such as migrate_vma_setup() in
"mm: enable device page migration from HMM pagewalk",
do_fault_and_migrate() in "lib/test_hmm: add a new testcase for the migrate
on fault", or nouveau_dmem_migrate_fault() in "drm/nouveau/svm: add support
for migrate on fault"), doesn't returning -EFAULT cause two regressions?

First, at addr, hmm_vma_handle_pte() already populated *hmm_pfns with the
valid pfn and HMM_PFN_VALID, which hmm_pfns_fill() overwrites with
HMM_PFN_ERROR. For callers like nouveau_dmem_migrate_fault() that fall back
to mapping range.hmm_pfns[0] in place via nouveau_dmem_hmm_pfn_to_map()
when a page is not migrated, losing HMM_PFN_VALID causes the in-place
mapping to fail.

Second, for the remaining entries in [addr + PAGE_SIZE, end) of the pmd,
hmm_vma_walk_pmd() never runs hmm_vma_handle_pte() or
hmm_vma_handle_migrate_prepare(), so unmapped or non-present pages in
[addr + PAGE_SIZE, end) are never faulted in when HMM_PFN_REQ_FAULT (or
MIGRATE_VMA_FAULT / MIGRATE_VMA_WRITE) is set, and valid order-0 pages in
[addr + PAGE_SIZE, end) are never collected for migration, yet
hmm_range_fault() returns 0 with HMM_PFN_ERROR in range->hmm_pfns.

> +
> +		writable =3D pte_write(pte);
> +	}
> +
> +	if (!page || !page->mapping)
> +		goto out;
> +
> +	/*
> +	 * By getting a reference on the folio we pin it and that blocks
> +	 * any kind of migration. Side effect is that it "freezes" the
> +	 * pte.
> +	 *
> +	 * We drop this reference after isolating the folio from the lru
> +	 * for non device folio (device folio are not on the lru and thus
> +	 * can't be dropped from it).
> +	 */
> +	folio =3D page_folio(page);
> +	folio_get(folio);
> +
> +	/*
> +	 * We rely on folio_trylock() to avoid deadlock between
> +	 * concurrent migrations where each is waiting on the others
> +	 * folio lock. If we can't immediately lock the folio we fail this
> +	 * migration as it is only best effort anyway.
> +	 *
> +	 * If we can lock the folio it's safe to set up a migration entry
> +	 * now. In the common case where the folio is mapped once in a
> +	 * single process setting up the migration entry now is an
> +	 * optimisation to avoid walking the rmap later with
> +	 * try_to_migrate().
> +	 */
> +
> +	if (fault_folio =3D=3D folio || folio_trylock(folio)) {
> +		anon_exclusive =3D folio_test_anon(folio) &&
> +			PageAnonExclusive(page);
> +
> +		if (pte_present(pte))
> +			flush_cache_page(walk->vma, addr, pfn);
> +
> +		if (anon_exclusive) {
> +			pte =3D ptep_clear_flush(walk->vma, addr, ptep);
> +
> +			if (folio_try_share_anon_rmap_pte(folio, page)) {
> +				set_pte_at(mm, addr, ptep, pte);
> +				if (fault_folio !=3D folio)
> +					folio_unlock(folio);
> +				folio_put(folio);
> +				goto out;
> +			}
> +		} else {
> +			pte =3D ptep_get_and_clear(mm, addr, ptep);
> +		}
> +
> +		if (pte_present(pte) && pte_dirty(pte))
> +			folio_mark_dirty(folio);
> +
> +		/* Setup special migration page table entry */
> +		if (writable)
> +			entry =3D make_writable_migration_entry(pfn);
> +		else if (anon_exclusive)
> +			entry =3D make_readable_exclusive_migration_entry(pfn);
> +		else
> +			entry =3D make_readable_migration_entry(pfn);
> +
> +		if (pte_present(pte)) {
> +			if (pte_young(pte))
> +				entry =3D make_migration_entry_young(entry);
> +			if (pte_dirty(pte))
> +				entry =3D make_migration_entry_dirty(entry);
> +		}
> +
> +		swp_pte =3D swp_entry_to_pte(entry);
> +		if (pte_present(pte)) {
> +			if (pte_soft_dirty(pte))
> +				swp_pte =3D pte_swp_mksoft_dirty(swp_pte);
> +			if (pte_uffd(pte))
> +				swp_pte =3D pte_swp_mkuffd(swp_pte);
> +		} else {
> +			if (pte_swp_soft_dirty(pte))
> +				swp_pte =3D pte_swp_mksoft_dirty(swp_pte);
> +			if (pte_swp_uffd(pte))
> +				swp_pte =3D pte_swp_mkuffd(swp_pte);
> +		}
> +
> +		set_pte_at(mm, addr, ptep, swp_pte);
> +		folio_remove_rmap_pte(folio, page, walk->vma);
> +		folio_put(folio);
> +		*hmm_pfn |=3D HMM_PFN_MIGRATE;
> +		if (pte_present(pte))
> +			*unmapped =3D true;

[Severity: Critical]
While the later commit "mm/hmm: implement rollback for device page
migration in HMM pagewalk" adds hmm_vma_handle_migrate_prepare_rollback()
and "mm: enable device page migration from HMM pagewalk" documents
caller-side abort via migrate_hmm_range_setup(), does locking folios and
installing migration entries per-entry during the walk still leave three
regressions across the series when a range contains a mix of present
entries, entries requiring faults, or large folios?

1. Holding folio_lock across handle_mm_fault():
In hmm_vma_walk_pmd(), hmm_vma_handle_migrate_prepare() locks each
collected folio with folio_trylock(), pins it with folio_get(), and
installs a migration entry immediately. When a subsequent entry or hole in
the walk requires a page fault, hmm_vma_handle_pte() or hmm_vma_walk_hole()
returns HMM_FAULT_PENDING and hmm_range_fault_locked() calls hmm_do_fault()
-> handle_mm_fault() while the task still holds folio_lock on all folios
collected earlier in the range:

mm/hmm.c:hmm_range_fault_locked() {
    ...
    ret =3D walk_page_range(mm, hmm_vma_walk.last, range->end,
                          &hmm_walk_ops, &hmm_vma_walk);
    if (ret =3D=3D HMM_FAULT_PENDING) {
        ret =3D hmm_do_fault(mm, &hmm_vma_walk);
        if (ret =3D=3D HMM_FAULT_UNLOCKED) {
            ret =3D fatal_signal_pending(current) ? -EINTR :
                -EBUSY;
            break;
        }
    }
}

Holding folio_lock across handle_mm_fault() violates lock ordering
(folio_lock held before handle_mm_fault(), mapping->invalidate_lock, and
other folio locks) and deadlocks if handle_mm_fault() touches a locked
folio, or if hmm_do_fault() (which loops for addr < fault_end calling
handle_mm_fault() on every page up to the end of the pmd) encounters a
migration entry installed in an earlier pass/retry and blocks forever in
do_swap_page() -> migration_entry_wait() on a folio locked by current.

2. Orphaned migration entries when required_fault =3D=3D 0:
In hmm_vma_handle_pte(), the check for !required_fault precedes the check
for softleaf_is_migration(entry):

mm/hmm.c:hmm_vma_handle_pte() {
    ...
    required_fault =3D
        hmm_pte_need_fault(hmm_vma_walk, pfn_req_flags, 0);
    if (!required_fault)
        goto out;
    ...
    if (softleaf_is_migration(entry)) {
        if (!hmm_select_migrate(range)) {
            ...
        }
        return 0;
    }
}

When required_fault =3D=3D 0 (the default for migrate_vma_setup() without
MIGRATE_VMA_FAULT) and a walk re-visits an already-installed migration
entry (for example when !ptep resets addr =3D start and jumps to again:, or
when hmm_pfns_fill(addr, end, ..., HMM_PFN_ERROR) runs on a split failure
after a retry), hmm_vma_handle_pte() jumps to out:, which calls
hmm_vma_handle_migrate_prepare_rollback() (unlocking the folio and dropping
its migration reference) and overwrites *hmm_pfn with 0 while leaving the
migration entry installed in the page table.

3. Wrong rollback range on !ptep and missing rollback before fault:
In hmm_vma_walk_pmd(), if migrate_vma_split_folio() at addr > start drops
the page table lock and returns -EAGAIN, and pte_offset_map_lock()
subsequently sees the page table gone (!ptep), the rollback patch calls
hmm_vma_handle_migrate_prepare_rollback(walk->private, addr, end, hmm_pfns)
on [addr, end) instead of [start, addr) where the entries from the vanished
page table were actually collected:

mm/hmm.c:hmm_vma_walk_pmd() {
again:
    ptep =3D pte_offset_map_lock(walk->mm, pmdp, addr, &hmm_vma_walk->ptl);
    if (!ptep) {
        addr =3D start;
        goto again;
    }

    for (; addr < end; addr +=3D PAGE_SIZE, ptep++, hmm_pfns++) {
        r =3D hmm_vma_handle_pte(walk, addr, end, pmdp, ptep, hmm_pfns);
        ...
        r =3D hmm_vma_handle_migrate_prepare(walk, pmdp, ptep, addr, hmm_pf=
ns, &unmapped);
}

Furthermore, when a vanished page table becomes pmd_none (or an entry
requires a fault on retry) with required_fault !=3D 0, hmm_vma_walk_hole()
and the fault: path in hmm_vma_handle_pte() return HMM_FAULT_PENDING
without rolling back previously collected entries in the range before
hmm_do_fault() runs.

> +	} else {
> +		folio_put(folio);
> +	}
> +out:
>  	return 0;
> +out_error:
> +	return -EFAULT;
>  }
> =20
>  #else

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021060506.2377=
545-1-mpenttil@redhat.com?part=3D5

