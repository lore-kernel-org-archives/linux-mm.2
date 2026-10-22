Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7012E606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 06:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=msmbMEjb
Received: by kanga.kvack.org (Postfix)
	id 594126B088E; Thu, 22 Oct 2026 02:06:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51D716B0890; Thu, 22 Oct 2026 02:06:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E46E6B0891; Thu, 22 Oct 2026 02:06:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 053066B088E
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:06:44 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7BC1EA82FD
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:06:44 +0000 (UTC)
X-FDA: 85349228328.10.BB37C52
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id D3821A0009
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:06:42 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=msmbMEjb;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792649203;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YbwpBf8xUETVGEncbj/oaI8Ia5OSMDatCr8bx3qRDKk=;
	b=3b0TN0xnfDiY2fTt+H+8TwHv5M6Jf9mLLm6Wscj5iZzmr93eUG4YC5saBssaleWUQ8Lzg0
	jkceTtrOlAO4rqAeagRyV9MXtUXa/71dfEzwTVKMC/4MOF2S9iduN+eqJTm05xNsbRXHA6
	URI/bIKelA84lQ3TqVfoYY4ErEf/yug=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=msmbMEjb;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792649203;
	b=bIvzr0iuylJKdt3J3uatJ6L0L9KGn6h/5nyzUtBWWfMu1tgxUsNQuKg3Vx6Qvt38HG4Olr
	BYHPlEUV2fMgupijashNGeqW/8UEk/RzElWbgwXt5dUQfCa31kP4bulI7L+uzHa4e+rhkq
	VHlg2PlKN8PyLG/4L3btEY11ekAAFgY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A699A41AD7;
	Thu, 22 Oct 2026 06:06:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 721A21F000C1;
	Thu, 22 Oct 2026 06:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792649202;
	bh=YbwpBf8xUETVGEncbj/oaI8Ia5OSMDatCr8bx3qRDKk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=msmbMEjbuTua1arpXR4xkHDG9EiH5Oh9/FWO1v24AhPSB/ABEWLQQVG3HNw/UqO9X
	 bkBbwZAOPLvdYwTOl5NheiGgaUqQakLlcWgbp6l6hbB5yTwV8NNMknquxAkxjOhulF
	 4cOPt5QYYuHI5DGd47ySkQ4zgzvQW6VD/3v+QdZ/8r9tKtM9m8NE2JyKGZ/UsAF7Cd
	 xfFEDwww3eE70OS+t4fIEqtwcbtwLMSRbizwJRMIwpMxN8I4jufA1DHw/9WAi4XNC5
	 0FYyKHq+GTMFqWdMEBhcEA/QpTg1C0bRSVAqaC+uCJ72K4KxvJwnRG5CuiwxJ1tNTx
	 8txRby6bUOx/g==
Message-ID: <sashiko-outbox-181057@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v16 09/12] mm: enable device page migration from HMM
 pagewalk
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
In-Reply-To: <20261021060506.2377545-10-mpenttil@redhat.com>
References: <20261021060506.2377545-1-mpenttil@redhat.com>
 <20261021060506.2377545-10-mpenttil@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 06:06:41 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D3821A0009
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: updfzirz8bdhkedxn75hpkyfisnusipj
X-HE-Tag: 1792649202-332019
X-HE-Meta: U2FsdGVkX1/pL6M+beGNdKTNvhO9OigRbUNPOaDiUh2jL6C9ge01x8eTAT95F3IZmtKLyZA3vMX9z9npU+E1//nsT6GoldNdBmQH6lSK7FRbVq6dQnm+QBIkyvMZ9yHAC8OAhnulikaZjb71mo+J6bDp4Z1xuEVYZCdg8QJVUZcnNTlgalSFd42nsILaIoZOa2+/4r+oGHjaKghn9ze3n1KjckopSAZEC0NwjjAP0IPKHaE7MPAJ+WKZjr3bIBvw8Jusvan/3KzQ9TY+6chT9/CS9u49xQoxCmFyI8E5gVtTT0atSuBk9pScITX1VcR+wcvoWXJpMpwOON9EpY19udLV06fHJAL+fwaieiGx86g9Ki8C/W/P12g+XQNxitf1V2KuA/Tn16lib6W0rMBxJPw2MMqipUzxyL91m43qtn3JhpL6KPoq7f5dfVV74afg962ZS4lr2FrPzgt9L0fuGqfpxS6z0RJlPqfFPGM4VDMoIGPdtw07nF//1ClBfUWaImtgG0WXsXdJcpqPngY6o0q4Cd4yAQbZcw7XiRvgdjJHFxH2y7l1fblqOrE+4tQn1l8ZuwjGszkd1Toft11zR0BDIzECimu3deDuj02kmcebLs/0jI9ZnUb03qu4usroq+0gDrO+feBTi8t9bzKz2/i/R2odVdcpwEzzW6gTcmUewUvV+JZdoqAPiej4Lb/0M4j6Knuqq6shk4u2GD6hua2hRKgNiDiRv5oXUtMsqDgMQWs0QGYv5fTJUIHV1O6Y/sgWGcjmawLGwm3viNd4ehnqYEEw7a8i62uM4H5AvJU4hH6i52xJGlNWQI/TjniuX46icI1JPlAO7rQCgynWjvwuYO4qYb0lD8wuA1SNrP7JW6yNyBSncBad755SlfN2OH7d3aUjVSC09H8LeFJz5uBcMtcqeucDf2gx5f8laeDDjND5CenXhd7D1TmMG6wpEm23v06jomZevgoPhSI
 jjn1FGDV
 8DW9vwL9LSxY0X+HwxSDAmZ6hkO3Nna62/0IZOS21q4HQiRTT7XozWp8F9FumJedvMkm+uQebkO2doNcTSNLok8GzStxcgL66zsHbKnN+OMXVr04JpVHDQ1dRJpo6Rrcfp4tLQo3ztch0YDOo9gr+0wIX6x/BHkCiBqzU7WGLmxz7wlHa1mEU29Fay+s9yQ/Ew+LtZb9vS/LN45CZWXmqE5QfoklgSW73xpf7UT2BFTxdLOWO30c8Lyjnn2l0ljuubDSDHHQbuVJ2Rooqb/d15sPetRAd0saJ5X7p3mnIDgsyaGaE1NSnXIvLHg0U2YG0giGpH2NNsrcs8y6kezfaOTmSu8rl+JCT6GTZqnia/wRRAP+QJ0h8cAfUixeE+6XD093O+pRKx4HrofqmmXqNPMiJ+gi1/yQP63KDMi8pbMA9b7ZvOzPfybtgztZrmdx4ejEBXtIb1QPqmbo/IpVaYgqggieGtJ5zl2nrSR42SDrvIXnwtrbTfU8TsKpwaNy3CpjlRxS/WmwElZA6eNT2QW+PYDlULk6nXOt/zu6hH6Q5Eo9KskloXhOGZtR7h+LbkQdzFDml6zWZ/dw0UYSSwPooENFypMG0p79Pspy8grbReFaXtfUZpOqfI+cRk6n66H6qoE4fXcMQFzvd4gG6kpW6OATVOWnQoES1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 9 potential issue(=
s) to consider:
- [Critical] mm: hmm_vma_handle_pte() corrupts migration PTE state during m=
igration
- [High] mm: migrate_vma_setup() skips non-VM_READ VMAs via hmm_vma_walk_te=
st()
- [High] mm: hmm_vma_handle_pte() faults entire PMD range [addr, end) on fa=
ult
- [High] mm: hmm_range_fault_locked() calls handle_mm_fault() under folio_l=
ock()
- [High] mm: hmm_vma_walk_pmd() fails to roll back collected entries on ret=
ry
- [High] mm: uninitialized migrate bounds and pfn offset in hmm_range_fault=
()
- [High] mm: self-invalidation of range->notifier during hmm_range_fault()
- [High] mm/hmm: refcount-before-lock and blocking folio_lock() in migrate_=
vma_split_folio()
- [Medium] mm: migrate_vma_setup() skips protnone pages when fault flag is =
unset
--

commit 6029fe80390f5816cec1bea4014e1df1b5d1785d
Author: Mika Penttil=C3=A4 <mpenttil@redhat.com>

mm: enable device page migration from HMM pagewalk

This commit enables device page migration through the HMM page table walk in
hmm_range_fault(), switches migrate_vma_setup() to use hmm_range_fault() and
migrate_hmm_range_setup(), and removes the legacy migrate_vma_collect() wal=
k.

> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
> index dd7dd7ec6995e..3780c4c116b8a 100644
> --- a/include/linux/migrate.h
> +++ b/include/linux/migrate.h
> @@ -181,6 +181,8 @@ enum migrate_vma_info {
>  	MIGRATE_VMA_SELECT_DEVICE_PRIVATE =3D 1 << 1,
>  	MIGRATE_VMA_SELECT_DEVICE_COHERENT =3D 1 << 2,
>  	MIGRATE_VMA_SELECT_COMPOUND =3D 1 << 3,
> +	MIGRATE_VMA_FAULT =3D 1 << 4,
> +	MIGRATE_VMA_WRITE =3D 1 << 5,
>  };
> =20
>  struct migrate_vma {
> @@ -218,10 +220,14 @@ struct migrate_vma {
>  	struct page		*fault_page;
>  };
> =20
> -// TODO: enable migration
>  static inline enum migrate_vma_info hmm_select_migrate(struct hmm_range =
*range)
>  {
> -	return 0;
> +	enum migrate_vma_info minfo;
> +
> +	minfo =3D (range->default_flags & HMM_PFN_REQ_MIGRATE) ?
> +		range->migrate->flags : 0;
> +
> +	return minfo;
>  }

[Severity: Critical]
When hmm_select_migrate() is enabled, can hmm_vma_handle_pte() in mm/hmm.c
roll back an already-installed migration PTE without restoring the page tab=
le
entry, and also skip waiting on foreign migration entries?

In mm/hmm.c:hmm_vma_handle_pte():

	if (!pte_present(pte)) {
		const softleaf_t entry =3D softleaf_from_pte(pte);
		...
		required_fault =3D
			hmm_pte_need_fault(hmm_vma_walk, pfn_req_flags, 0);
		if (!required_fault)
			goto out;
		...
		if (softleaf_is_migration(entry)) {
			if (!hmm_select_migrate(range)) {
				HMM_ASSERT_UNLOCKED(hmm_vma_walk);
				pte_unmap(ptep);
				hmm_vma_walk->last =3D addr;
				migration_entry_wait(walk->mm, pmdp, addr);
				return -EBUSY;
			}
			return 0;
		}
	...
out:
	hmm_vma_handle_migrate_prepare_rollback(hmm_vma_walk, addr,
						addr + PAGE_SIZE,
						hmm_pfn);
	*hmm_pfn =3D (*hmm_pfn & HMM_PFN_INOUT_FLAGS) | new_pfn_flags;
	return 0;

First, when HMM_PFN_REQ_FAULT is not set (the default in migrate_vma_setup(=
)),
required_fault is 0. If hmm_vma_handle_migrate_prepare() collects a page at
addr (locking the folio, taking a reference, installing a migration PTE, and
setting HMM_PFN_VALID | HMM_PFN_MIGRATE in *hmm_pfn) and that PTE is visited
again (for example when hmm_vma_walk_pmd() restarts from start after !ptep,
when hmm_range_fault_locked() loops on -EBUSY after a THP split, or when a
caller retries hmm_range_fault() on -EBUSY), hmm_vma_handle_pte() sees
!pte_present(pte) and jumps to out: before checking softleaf_is_migration().
At out:, hmm_vma_handle_migrate_prepare_rollback() unlocks the folio, drops
its reference, and clears *hmm_pfn to 0, leaving the migration PTE dangling
in the page table. A similar issue happens if migrate_vma_split_folio() fai=
ls
in hmm_vma_walk_pmd() and calls hmm_pfns_fill(addr, end, hmm_vma_walk,
HMM_PFN_ERROR) over entries that were already collected in a prior pass.

Second, when HMM_PFN_REQ_FAULT is set and hmm_vma_handle_pte() or
hmm_vma_walk_pmd() encounters a migration PTE or PMD installed by another
thread (!hmm_pfn_collected(*hmm_pfn)), checking if (!hmm_select_migrate(ran=
ge))
or if (!minfo) causes the walk to return 0 without waiting via
migration_entry_wait() / pmd_migration_entry_wait() and without populating
*hmm_pfn.

Should hmm_vma_handle_pte() check softleaf_is_migration(entry) before the
!required_fault branch and distinguish entries already collected by this wa=
lk
(hmm_pfn_collected(*hmm_pfn)) from foreign migration entries?

[Severity: High]
Also in mm/hmm.c:hmm_vma_walk_pmd(), when minfo is non-zero and the PTE lock
is dropped mid-PMD (such as in migrate_vma_split_folio() returning -EAGAIN =
at
addr > start), could already-collected entries in [start, addr) fail to be
rolled back if the PTE page table disappears or is replaced?

In mm/hmm.c:hmm_vma_walk_pmd():

	if (minfo) {
		ptep =3D pte_offset_map_lock(mm, pmdp, addr, &hmm_vma_walk->ptl);
		if (ptep) {
			lazy_mmu_mode_enable();
			hmm_vma_walk->ptelocked =3D true;
		} else {
			/* The pte table is gone */
			hmm_vma_handle_migrate_prepare_rollback(walk->private, addr, end, hmm_pf=
ns);
		}
	} else {
		ptep =3D pte_offset_map(pmdp, addr);
	}
	if (!ptep) {
		addr =3D start;
		goto again;
	}

When addr > start, the entries collected earlier in the same PMD are in
[start, addr) starting at hmm_pfns_start, whereas [addr, end) starting at
hmm_pfns is the unwalked remainder of the PMD. Passing addr, end, hmm_pfns =
to
hmm_vma_handle_migrate_prepare_rollback() leaves [start, addr) locked and
referenced with HMM_PFN_VALID | HMM_PFN_MIGRATE set.

Moreover, if addr is reset to start and goto again finds that *pmdp is now a
PMD migration entry (pmd_is_migration_entry(pmd)), or if hmm_vma_walk_hole(=
),
hmm_vma_handle_pmd(), or hmm_vma_handle_absent_pmd() returns HMM_FAULT_PEND=
ING
or -EFAULT before reaching their rollback calls, the previously collected
folios in hmm_pfns_start are never rolled back either.

Should the rollback when !ptep (and before early returns after goto again)
cover start to end using hmm_pfns_start?

[Severity: High]
Enabling hmm_select_migrate() also activates migrate_vma_split_folio() in
mm/hmm.c when hmm_vma_handle_migrate_prepare() encounters a PTE-mapped large
folio:

static int migrate_vma_split_folio(struct folio *folio,
				   struct page *fault_page,
				   struct hmm_vma_walk *hmm_vma_walk,
				   pte_t *ptep)
{
	struct folio *fault_folio =3D fault_page ? page_folio(fault_page) : NULL;

	if (folio !=3D fault_folio)
		folio_get(folio);

	lazy_mmu_mode_disable();
	pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
	hmm_vma_walk->ptelocked =3D false;

	if (folio !=3D fault_folio)
		folio_lock(folio);

	return __migrate_vma_split_folio(folio, fault_page);
}

Unlike hmm_vma_handle_migrate_prepare_pmd() and the order-0 path in
hmm_vma_handle_migrate_prepare(), which use folio_trylock() because current
may already hold folio_lock on fault_folio and on folios collected at earli=
er
addresses in the walk, migrate_vma_split_folio() calls blocking folio_lock(=
).
Can this deadlock if two concurrent migrations lock folios in opposite orde=
r,
or if another task holds folio_lock(folio) while waiting on a migration ent=
ry
installed earlier in this walk?

In addition, calling folio_get(folio) before blocking on folio_lock(folio)
means that if two tasks concurrently enter migrate_vma_split_folio() on the
same large folio, the waiting task's extra reference will cause the lock
holder's split_folio() call to fail with -EAGAIN. Would it be safer to use
folio_trylock() here as well?

> diff --git a/mm/hmm.c b/mm/hmm.c
> index 5a1471fd5d288..4d853ee8e8b8c 100644
> --- a/mm/hmm.c
> +++ b/mm/hmm.c
> @@ -1542,14 +1542,43 @@ static int hmm_range_fault_locked(struct hmm_rang=
e *range, bool *locked)
>   *		the invalidation to finish.
>   * -EFAULT:     A page was requested to be valid and could not be made v=
alid
>   *              ie it has no backing VMA or it is illegal to access
> + * -ERANGE:     The range crosses multiple VMAs, or space for hmm_pfns a=
rray
> + *              is too low.
>   *
>   * This is similar to get_user_pages(), except that it can read the page=
 tables
>   * without mutating them (ie causing faults).
>   *
>   * The mmap lock must be held by the caller and will remain held on retu=
rn.
>   * New users should prefer hmm_range_fault_unlocked_timeout() unless they
> - * specifically need to keep the mmap lock held across the call. This he=
lper
> - * cannot support VMAs whose fault handlers need to drop the mmap lock.
> + * specifically need to keep the mmap lock held across the call like whi=
le
> + * migrating. This helper cannot support VMAs whose fault handlers need =
to
> + * drop the mmap lock.
> + *
> + * If want to do migration after faulting, call hmm_range_fault() with
> + * range.default_flags of HMM_PFN_REQ_MIGRATE, and optionally
> + * HMM_PFN_REQ_FAULT|HMM_PFN_REQ_WRITE, and initialize range->migrate fi=
eld.
> + * range->migrate->vma will be populated during the call,
> + * and must be stable across the whole migrate process, which is
> + * why mmap_lock must be held around this call.
> + *
> + * When HMM_PFN_REQ_MIGRATE is set, migration collection may be partial =
on
> + * return and the caller takes responsibility for completing or aborting=
 it.
> + *
> + * On success, the caller must call migrate_hmm_range_setup() and may th=
en
> + * proceed with the normal migrate_vma sequence: prepare destination pag=
es,
> + * call migrate_vma_pages(), update device mappings as needed, and final=
ly
> + * call migrate_vma_finalize().
> + *
> + * On -EBUSY, the caller may retry hmm_range_fault() using the same rang=
e and
> + * PFN array without undoing entries collected by the previous attempt. =
If
> + * the caller stops retrying, it must abort the partial migration.
> + *
> + * On any other error, or when abandoning a retry, the caller must call
> + * migrate_hmm_range_setup(), migrate_vma_pages() with no valid destinat=
ion
> + * entries, and migrate_vma_finalize() to abort the partial migration.

[Severity: High]
What happens in migrate_hmm_range_setup() if hmm_range_fault() fails before
hmm_vma_capture_migrate_range() arms hmm_vma_walk->mmu_armed, or if
range->start begins in an unmapped hole before walk->vma->vm_start?

In mm/hmm.c:hmm_vma_post_range_fault():

	if (hmm_select_migrate(range) &&
	    hmm_vma_walk->mmu_armed) {
		if (range->notifier) {
			hmm_fill_migrate_vma(range,
					     hmm_vma_walk->vma,
					     hmm_vma_walk->start,
					     hmm_vma_walk->end);
		}
		mmu_notifier_invalidate_range_end(&hmm_vma_walk->mmu_range);
	}

When a caller drives migration directly through hmm_range_fault() with
range->notifier set, range->migrate->vma, range->migrate->start, and
range->migrate->end are only populated if hmm_vma_walk->mmu_armed is true. =
If
hmm_range_fault_locked() fails before mmu_armed is set (for instance, if
mmu_interval_check_retry() returns -EBUSY on entry, hmm_vma_walk_hole()
returns -EFAULT when !walk->vma, or hmm_vma_capture_migrate_range() returns
-ERANGE), calling migrate_hmm_range_setup() as documented above will compute
migrate->npages =3D (migrate->end - migrate->start) >> PAGE_SHIFT from
uninitialized or stale fields in range->migrate.

Additionally, in hmm_vma_capture_migrate_range():

	if (end - start > range->end - range->start)
		return -ERANGE;

	if (!hmm_vma_walk->mmu_armed) {
		hmm_vma_walk->start =3D start;
		hmm_vma_walk->end =3D end;

Because walk_page_range() clamps start and end to the VMA boundaries within
[range->start, range->end), end - start is never greater than
range->end - range->start. And if range->start < vma->vm_start (with
HMM_PFN_REQ_FAULT unset across the hole), hmm_vma_walk->start is set to
vma->vm_start while hmm_vma_walk_pmd() indexes range->hmm_pfns by
(addr - range->start) >> PAGE_SHIFT. When migrate_hmm_range_setup() then
reads range->hmm_pfns[0 .. migrate->npages - 1], won't it read from the
beginning of range->hmm_pfns instead of the VMA offset, misaligning
migrate->src[] and leaking any collected folios and migration PTEs at the e=
nd
of the range?

[Severity: High]
When hmm_range_fault() is called with both range->notifier and
HMM_PFN_REQ_MIGRATE set, won't internal MMU notifier invalidations during t=
he
walk trip mmu_interval_check_retry() and cause premature termination of the
internal -EBUSY loop?

In mm/hmm.c:hmm_range_fault_locked():

	do {
		/* If range is no longer valid force retry. */
		if (range->notifier && mmu_interval_check_retry(range->notifier,
								range->notifier_seq)) {
			ret =3D  -EBUSY;
			break;
		}
		ret =3D walk_page_range(mm, hmm_vma_walk.last, range->end,
				      &hmm_walk_ops, &hmm_vma_walk);
		if (ret =3D=3D HMM_FAULT_PENDING) {
			ret =3D hmm_do_fault(mm, &hmm_vma_walk);
			...
		}
	} while (ret =3D=3D -EBUSY);

	hmm_vma_post_range_fault(&hmm_vma_walk);
	return ret;

During the walk, hmm_vma_capture_migrate_range() calls
mmu_notifier_invalidate_range_start() with MMU_NOTIFY_MIGRATE, and any page
fault in hmm_do_fault() (such as a CoW or swap fault) or THP split in
hmm_vma_handle_migrate_prepare_pmd() triggers an MMU notifier invalidation
with owner =3D NULL. If range->notifier covers the migrated range, those
invalidations increment range->notifier's sequence count. When hmm_do_fault=
()
or hmm_vma_handle_migrate_prepare_pmd() returns -EBUSY to re-walk the fault=
ed
or split pages, mmu_interval_check_retry() will immediately break out of the
loop with -EBUSY, and hmm_vma_post_range_fault() will call
mmu_notifier_invalidate_range_end() while partial migration PTEs from earli=
er
addresses are still installed.

> + *
> + * The mmap read lock must remain held until the migration has either be=
en
> + * completed or aborted.
>   */
>  int hmm_range_fault(struct hmm_range *range)
>  {
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 3bcb398c4e02c..c61a9e54e06bb 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
[ ... ]
> @@ -764,10 +276,24 @@ int migrate_vma_setup(struct migrate_vma *args)
>  	args->cpages =3D 0;
>  	args->npages =3D 0;
> =20
> -	migrate_vma_collect(args);
> +	if (args->flags & MIGRATE_VMA_FAULT)
> +		range.default_flags |=3D HMM_PFN_REQ_FAULT;
> =20
> -	if (args->cpages)
> -		migrate_vma_unmap(args);
> +	if (args->flags & MIGRATE_VMA_WRITE)
> +		range.default_flags |=3D HMM_PFN_REQ_FAULT | HMM_PFN_REQ_WRITE;

[Severity: High]
When MIGRATE_VMA_FAULT or MIGRATE_VMA_WRITE is used (or HMM_PFN_REQ_MIGRATE
is combined with HMM_PFN_REQ_FAULT), can a fault on one PTE cause
hmm_do_fault() to fault across the rest of the PMD range, deadlocking on
already-locked folios or faulting caller-owned device-private pages back to
RAM?

In mm/hmm.c:hmm_vma_handle_pte():

fault:
	if (hmm_vma_walk->ptelocked) {
		lazy_mmu_mode_disable();
		pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
		hmm_vma_walk->ptelocked =3D false;
	} else {
		pte_unmap(ptep);
	}
	/* Fault any virtual address we were asked to fault */
	return hmm_record_fault(addr, end, required_fault, walk);

Here end is the end of the PMD walk range passed from hmm_vma_walk_pmd(), a=
nd
hmm_do_fault() loops from addr to end calling handle_mm_fault() on every pa=
ge
in [addr, end):

	for (; addr < end; addr +=3D PAGE_SIZE) {
		vm_fault_t ret;

		ret =3D handle_mm_fault(vma, addr, fault_flags, NULL);

If a subsequent PTE in [addr + PAGE_SIZE, end) is a device-private entry
owned by args->pgmap_owner, handle_mm_fault() will invoke do_swap_page() ->
pgmap->ops->migrate_to_ram() even though hmm_vma_handle_pte() normally avoi=
ds
faulting caller-owned device-private pages (and if that entry is
args->fault_page, which is already locked, do_swap_page() will wait forever
in softleaf_entry_wait_on_locked()). Similarly, if a subsequent PTE in
[addr + PAGE_SIZE, end) already has a migration entry installed by the
current thread during an earlier pass, handle_mm_fault() will call
migration_entry_wait() and deadlock on the folio lock held by current.

Should hmm_vma_handle_pte() pass addr + PAGE_SIZE instead of end to
hmm_record_fault()?

[Severity: High]
Relatedly, when hmm_range_fault_locked() calls hmm_do_fault() ->
handle_mm_fault() after a walk callback returns HMM_FAULT_PENDING, current
still holds folio_lock on all folios collected at earlier addresses in the
walk (via hmm_vma_handle_migrate_prepare() or
hmm_vma_handle_migrate_prepare_pmd()).

Does calling handle_mm_fault() while holding folio_lock on previously
collected folios violate mm lock ordering (where mapping->invalidate_lock in
filemap_fault() is acquired outside folio_lock) and risk a self-deadlock if
the faulted address resolves to the same folio that was already locked at an
earlier address in the range (such as a shared, KSM, or swap-cached folio
mapped at two addresses)?

> +
> +	ret =3D hmm_range_fault(&range);
> +
> +	migrate_hmm_range_setup(&range);

[Severity: High]
By switching migrate_vma_setup() from migrate_vma_collect() to
hmm_range_fault(), the walk now runs hmm_vma_walk_test() in mm/hmm.c:

	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)) &&
	    vma->vm_flags & VM_READ)
		return 0;
	...
	hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);

	/* Skip this vma and continue processing the next vma. */
	return 1;

Previously, migrate_vma_collect() did not have a .test_walk callback requir=
ing
VM_READ. With this change, if a VMA containing device-private or
device-coherent pages does not have VM_READ set (for example, an execute-on=
ly
VMA that faults on instruction fetch, or a VMA changed to PROT_NONE via
mprotect() before driver eviction or a FOLL_FORCE access), hmm_vma_walk_tes=
t()
skips the VMA, migrate_hmm_range_setup() sets args->cpages =3D 0, and
migrate_vma_setup() returns 0.

In pgmap->ops->migrate_to_ram() handlers (such as nouveau_dmem_migrate_to_r=
am(),
__drm_pagemap_migrate_to_ram(), svm_migrate_to_ram(), and
dmirror_devmem_fault()), a 0 return from migrate_vma_setup() with cpages =
=3D=3D 0
is treated as a race where another thread already migrated the page, so the
handler returns 0 without resolving the device-private swap PTE and the CPU
page fault retries indefinitely. Driver eviction paths also fail to migrate
device pages back to RAM when VM_READ is clear.

Should hmm_vma_walk_test() allow non-VM_READ VMAs when migrating (or when
faulting is not requested during migration)?

[Severity: Medium]
Does switching migrate_vma_setup() to hmm_range_fault() also cause present
pte_protnone() and pmd_protnone() pages (such as pages marked for NUMA
hinting faults by automatic NUMA balancing) to be skipped when
MIGRATE_VMA_FAULT is not set?

In mm/hmm.c, pte_to_hmm_pfn_flags() and pmd_to_hmm_pfn_flags() return 0
(without HMM_PFN_VALID) when pte_protnone(pte) or pmd_protnone(pmd) is true:

static inline unsigned long pte_to_hmm_pfn_flags(struct hmm_range *range,
						 pte_t pte)
{
	if (pte_none(pte) || !pte_present(pte) || pte_protnone(pte))
		return 0;
	return pte_write(pte) ? (HMM_PFN_VALID | HMM_PFN_WRITE) : HMM_PFN_VALID;
}

When callers invoke migrate_vma_setup() without MIGRATE_VMA_FAULT, no fault=
 is
triggered for protnone entries, and both hmm_vma_handle_migrate_prepare() a=
nd
hmm_vma_handle_migrate_prepare_pmd() bail out at:

	if (!(hmm_pfn[0] & HMM_PFN_VALID))
		goto out;

Previously, migrate_vma_collect_pmd() and migrate_vma_collect_huge_pmd()
collected and migrated present protnone PTEs and THP PMDs without requiring=
 a
fault.

[ ... ]

>
>  	/*
>  	 * At this point pages are locked and unmapped, and thus they have

=D1=82=D0=B8=D1=82=D1=8C=D1=81=D1=8F

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021060506.2377=
545-1-mpenttil@redhat.com?part=3D9

