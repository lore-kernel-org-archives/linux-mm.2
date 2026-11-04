Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D550C606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 06:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EKX5YswM
Received: by kanga.kvack.org (Postfix)
	id 08BCB6B05B9; Wed,  4 Nov 2026 01:18:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 016576B05BA; Wed,  4 Nov 2026 01:18:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6D1D6B05BB; Wed,  4 Nov 2026 01:18:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C1C166B05B9
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 01:18:09 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 32BA14066E
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:18:07 +0000 (UTC)
X-FDA: 85396431414.24.91B42BA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 960C140006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:18:05 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EKX5YswM;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793773085;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DaNErE6sECHgR+KjcW4dWzzVL6Omgg/o8kQ2UAAN4P8=;
	b=w2XT53S80YHXtfSVrKpMXmQuo3Xy0S77xGv3jl3KuY/n+ku+qenT12X5r842dWpHkZRaac
	C4kjF/TGr6Jb5t8sFbDYzVk2gYwPmoOpHoo7BHaA6UY4Iju9HT4bInz2CljEgAk2ijAZAT
	WdC/Zzdda++7A2AY9q/KsofYPkX2AJ0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793773085;
	b=sjGYObjs7pJRu32wyUQcGIi9xcM0QCb/2xD7rHvGj1GrlNvWoZHKnQ57LzDFJEXlSvWeRq
	fC4LUVdLfg7f69Mh1mWKM0YLHmy5yhmhtcN/hRF3rT4ZaMK396W8z6oe+1jsy7otNKgS+/
	gQRhIaUQl0WQ3TtZBRniVdhFKkPk/V0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EKX5YswM;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1EE6A60AAB;
	Wed,  4 Nov 2026 06:18:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFED81F000C1;
	Wed,  4 Nov 2026 06:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793773084;
	bh=DaNErE6sECHgR+KjcW4dWzzVL6Omgg/o8kQ2UAAN4P8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EKX5YswMc3+8Gmp1IeljsZfjnULF3wJwfIPh4OExNTP0KlrFqBan4jHbce3xORaph
	 zpr3TZUqa1DbiVrcVAvo5e1YPVIZ46/sdAzHOeV4WmvdWIqfEgGFraKKoCa0Xyhb+9
	 yjCkt+Ccm6/S5pe88bIdolAD/kJJDU88bHWQ7wYYNhSchP/XtZ/DblJSPYpCtVr6Jw
	 z21KuBw+yNW4QHeY7ohPK4fD+6VLfQhU4tMopwziF9nYo7hRtwFhuL0UGo1yO26Ybe
	 KbntdrU+cEDarLiJWvcCbxrJ77rzPcbx1WVovaOmGXi2YqxJNYZA6AjILQpEhzNRnq
	 NGvqg0hnClx8Q==
Message-ID: <sashiko-outbox-196747@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v17 09/12] mm: enable device page migration from HMM
 pagewalk
Reply-To: sashiko-reviews@lists.linux.dev
To: mpenttil@redhat.com, linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org, "David
 Hildenbrand" <david@kernel.org>, "Jason Gunthorpe" <jgg@nvidia.com>, "Leon
 Romanovsky" <leonro@nvidia.com>, "Alistair Popple" <apopple@nvidia.com>, "Balbir
 Singh" <balbirs@nvidia.com>, "Zi Yan" <ziy@nvidia.com>, "Matthew Brost" <matthew.brost@intel.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@suse.cz>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Lyude Paul" <lyude@redhat.com>, "Danilo
 Krummrich" <dakr@kernel.org>
In-Reply-To: <20261103061629.972669-10-mpenttil@redhat.com>
References: <20261103061629.972669-1-mpenttil@redhat.com>
 <20261103061629.972669-10-mpenttil@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 06:18:03 +0000
X-Rspamd-Server: rspam06
X-Stat-Signature: iwum9uaz7noicnfpri5pxzeiww68wn44
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 960C140006
X-Rspam-User: 
X-HE-Tag: 1793773085-223251
X-HE-Meta: U2FsdGVkX18MBrsyFQvMibUrhm0HSjfrgzLGyS71uIPZ5m610rZDMHdt86L5dIWEQmytuyE7xGfkM5fmGfCS6+8ZlHF94v3321G6Aq2j/aCE8PDaenI0gHKEZ6AnD6D82g2vLnTJKUavQwFN9qvWq02T8AmVSEUdbZBbYyaTyrnQDkAj1JkOZ167N7olbAwdEfUJw03qOVI6eE0TDVCxaGnzNmGM1+kGRB4mwro/iMIUrQGc073Q9oxQEEkhUT4naEWEk8Mc7G8+uaKZc+WhQFZOPz59fxzpmmDPeCjWas/KFqLOX6FSEeRpBfWmN609iz1Neb2zoaEFkWtl/5+7MZxdpR+hg0oVo1h84cdvV3skT5cVvjLbJ39N2dsANEJgwy3ZPMKzzxjm6HkkR7O1+e9TYtl/OQQUxddBI/jTFKpr87+EpF7YMZNh33r4kyncvibZsNe/40NtYuZxM/HObuSwFJIbTfqdrFy1u/Ex0cCirsrQMWsHHryU/Q4sXZf1605zqgoeBmFMn1wgaednMa/2TAEjgutKU7wuFQXF3glGAgBjXPWKmZPVbq7R/95+QKCN/hNUb+1+Rk9izsZHpz+V81u/0rb1Y5k4iGIrRCrcQ4UNtKr2s2dAQa6BHuKUCye3zN6GjA3+sRcwYykRTAhAexPIB3HhPJTXxej13SLK9QnUdoNPuSZNMCufSTgTj5AgaN5lRbA3qbV98wsS2kZ3PV8XQG6XA4gCbOhYkt74L0MtBHZ/g2YzATBhHbmm+VaEVpRkWnO2k5UZbbfi0GvMFESLfAPv/+q3pPqdJqlJTXLiWd305U7fItlmUWHBBLfj5R1UOmrGODAIhVax8qQ2T3OGl8zuF79nsmd79nsA83sy/J8DtjO8qMV4/4eh8rB6pLDLRByvKPNy4iQj0UUsK2yk34FRlxL9+310LnnxgLsXbYsAtL5U/T/jt2zDRsXEbHhQdnQQUAWjGhB
 /sQitN/l
 ZWJ0SM7VC3TyRM34Zdw4AOaARVEJlZx8rbdvQeOeE+fOt+UN30mNL1kFkt46YgxBCkGeb7dNQsId4yRvOMQWAX+EdQvvKPdNLvY8OrixCt5PWlFE97j7PN2p+UO6eSqp0GRKSr70HOQ4lIUIkGS2Csb8C619l7aWAbtOwvPM1Z10BlUqkDCUnzSR3xfdWIRjwC5CyECJqUPxPGPgJG+Kb0Tj8FHEzUNtkEpGM2Bow+72Hk4PpfUWJ8PnzT/1MyiWqqdNBjrq3tq/MVS3DPj6HmSp8cuAlpg/rECSfqoA/K1QHpwNXmHmjhJFTeId6tLq8PffkEQNUNm6CiRJK7RzMh4RvJMO3w5tKN0SKxI3AdPgj7TPfwJpnXDCjzfG+6s+u+lmQqO4p9XuFUFtYQV6OqeW3H7vbqVqaDYhOysAZhPEBk2u9CnZWOubciw22dbtwdLS5UYX8MbSVwXacurNfLsAfAoncyqEq9qvtMKmAqaqcPqOqG021Sdz9wOrvSCAl4lZs8X2DdzAw8RpGb1C7Ij85GSkPzLUbzbjWyUytYTkDla0mg5kcRnaG+6Oz060+kJ8Iap0zGK++ME7lJZLWbriBKe9Hlrt7HzZA4m3qUZlEU6GPanF3gw4SvAEkf+dc8JbWt4ygrQ5Tlf2ebj9YX9FeV/bChxP2dxyfdbuX/Ds4Ft4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 8 potential issue(=
s) to consider:
- [Critical] mm: hmm_range_fault_locked() zeroes hmm_pfns on -EBUSY migrati=
on retry
- [Critical] mm/hmm: missing rollback of earlier entries after fault in hmm=
_range_fault()
- [High] mm: missing folio_test_anon() check in hmm_vma_handle_migrate_prep=
are_pmd()
- [High] mm: early return in hmm_vma_walk_pmd() on folio split failure skip=
s PTEs
- [High] mm/hmm: folio_lock deadlock in migrate_vma_split_folio() and hmm_d=
o_fault()
- [Medium] mm: lost MIGRATE_PFN_WRITE on writable protnone entries in HMM m=
igration
- [Low] mm: build failure on incomplete struct migrate_vma when !CONFIG_MIG=
RATION
- [Low] mm/migrate_device: unused MIGRATE_VMA_FAULT and MIGRATE_VMA_WRITE f=
lags in migrate_vma_setup()
--

commit 00843344cdcc1e298091d82f4ddd5b2d3478ddb1
Author: Mika Penttil=C3=A4 <mpenttil@redhat.com>

mm: enable device page migration from HMM pagewalk

This commit enables migration collection in hmm_range_fault() via
hmm_select_migrate(), switches migrate_vma_setup() to use the HMM pagewalk
path with new MIGRATE_VMA_FAULT and MIGRATE_VMA_WRITE flags, and removes
the old migrate_vma_collect() page table walk helpers.

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

[Severity: Low]
As reported by Christoph Hellwig on v15 [1], are MIGRATE_VMA_FAULT and
MIGRATE_VMA_WRITE in enum migrate_vma_info and their handling in
migrate_vma_setup() needed when there are no in-tree callers?

Later patches in the series (for test_hmm and drm/nouveau/svm) drive
migrate-on-fault directly through hmm_range_fault() with HMM_PFN_REQ_MIGRATE
and migrate_hmm_range_setup(), leaving MIGRATE_VMA_FAULT and MIGRATE_VMA_WR=
ITE
unused across the tree.

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

[Severity: Low]
Will mm/hmm.c fail to build when CONFIG_HMM_MIRROR=3Dy and CONFIG_MIGRATION=
=3Dn?

Several drivers (such as INFINIBAND_ON_DEMAND_PAGING, DRM_AMDGPU_USERPTR, a=
nd
MSHV_ROOT) select CONFIG_HMM_MIRROR without selecting CONFIG_MIGRATION. When
CONFIG_MIGRATION is disabled, struct migrate_vma is only forward-declared in
include/linux/hmm.h, but hmm_range_fault_locked() in mm/hmm.c is compiled
outside #ifdef CONFIG_DEVICE_MIGRATION and dereferences
range->migrate->pgmap_owner:

mm/hmm.c:hmm_range_fault_locked() {
	if (hmm_select_migrate(range)) {
		WARN_ON_ONCE(range->pfn_flags_mask);
		WARN_ON_ONCE(range->dev_private_owner !=3D
			     range->migrate->pgmap_owner);
		...
	}
}

In addition, hmm_select_migrate() in include/linux/migrate.h is guarded by
#ifdef CONFIG_MIGRATION rather than #ifdef CONFIG_DEVICE_MIGRATION, even
though the migration implementation in mm/hmm.c and mm/migrate_device.c
depends on CONFIG_DEVICE_MIGRATION.

Should hmm_select_migrate() be guarded by CONFIG_DEVICE_MIGRATION (returnin=
g 0
when !CONFIG_DEVICE_MIGRATION), and should the range->migrate dereference in
hmm_range_fault_locked() be guarded or moved into a helper?

[ ... ]

> diff --git a/mm/hmm.c b/mm/hmm.c
> index 1c8a3fa29c4e6..0b38bf84c3690 100644
> --- a/mm/hmm.c
> +++ b/mm/hmm.c
> @@ -1658,14 +1658,43 @@ static int hmm_range_fault_locked(struct hmm_rang=
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

[Severity: Critical]
When a caller retries hmm_range_fault() after -EBUSY with the same range and
PFN array as documented here, won't hmm_range_fault_locked() wipe out all
previously collected entries by unconditionally zeroing range->hmm_pfns?

At the start of hmm_range_fault_locked() in mm/hmm.c:

	if (hmm_select_migrate(range)) {
		WARN_ON_ONCE(range->pfn_flags_mask);
		WARN_ON_ONCE(range->dev_private_owner !=3D
			     range->migrate->pgmap_owner);
		memset(range->hmm_pfns, 0,
		       ((range->end - range->start) >> PAGE_SHIFT) *
		       sizeof(*range->hmm_pfns));
	}

During the first call, hmm_vma_handle_migrate_prepare() and
hmm_vma_handle_migrate_prepare_pmd() lock folios, take references, install
migration PTEs/PMDs, and record HMM_PFN_VALID | HMM_PFN_MIGRATE in
range->hmm_pfns[]. If a later page in the range triggers an mmu_notifier
invalidation (for example during hmm_do_fault() or folio splitting) so that
mmu_interval_check_retry() returns -EBUSY, retrying hmm_range_fault() zeroes
range->hmm_pfns[].

On the retry walk, hmm_pfn_collected() in hmm_vma_handle_pte() and
hmm_vma_walk_pmd() evaluates to false for the migration entries installed by
the first attempt:

mm/hmm.c:hmm_vma_handle_pte() {
	if (softleaf_is_migration(entry) && hmm_select_migrate(range) &&
	    hmm_pfn_collected(*hmm_pfn) &&
	    hmm_pfn_to_page(*hmm_pfn) =3D=3D softleaf_to_page(entry))
		return 0;
}

With HMM_PFN_REQ_FAULT set, HMM treats its own migration PTE/PMD as a forei=
gn
migration entry and calls hmm_do_fault() -> handle_mm_fault() ->
migration_entry_wait(), deadlocking on the folio lock already held by curre=
nt.
Without HMM_PFN_REQ_FAULT (or if the retry aborts before reaching those
entries), range->hmm_pfns[] remains zeroed, so migrate_hmm_range_setup() ne=
ver
populates migrate->src[] for those pages and leaks the folio locks, folio
references, and migration PTEs.

[ ... ]

> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index ba6775a0d37e6..266f9c6d7b607 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c

[ ... ]

> @@ -741,9 +243,20 @@ int migrate_vma_setup(struct migrate_vma *args)
>  {
>  	const struct vm_area_struct *vma =3D args->vma;
>  	long nr_pages =3D (args->end - args->start) >> PAGE_SHIFT;
> +	struct hmm_range range =3D {
> +		.notifier =3D NULL,
> +		.hmm_pfns =3D args->src,
> +		.dev_private_owner =3D args->pgmap_owner,
> +		.migrate =3D args,
> +		.default_flags =3D HMM_PFN_REQ_MIGRATE
> +	};
> +	int ret;
> =20
>  	args->start &=3D PAGE_MASK;
>  	args->end &=3D PAGE_MASK;
> +	range.start =3D args->start;
> +	range.end =3D args->end;
> +
>  	if (!vma)
>  		return -EINVAL;
>  	/* The migrate_vma page walk has no hugetlb support. */
> @@ -766,10 +279,24 @@ int migrate_vma_setup(struct migrate_vma *args)
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
> +
> +	ret =3D hmm_range_fault(&range);
> +
> +	migrate_hmm_range_setup(&range);

[Severity: Critical]
As reported by Sashiko on v16 [2], when hmm_range_fault() faults at an addr=
ess
after already collecting earlier PTEs in the range, can concurrent page tab=
le
zapping cause a use-after-free of destination pages because the walk resumes
at hmm_vma_walk.last without re-validating [range->start, hmm_vma_walk.last=
)?

When HMM_PFN_REQ_MIGRATE | HMM_PFN_REQ_FAULT is used, walk_page_range()
collects present pages in [range->start, addr) via
hmm_vma_handle_migrate_prepare(), installing migration PTEs and setting
HMM_PFN_VALID | HMM_PFN_MIGRATE in range->hmm_pfns[]. When a later address
addr requires a fault, hmm_vma_handle_pte() drops the PTE lock, sets
hmm_vma_walk.last =3D addr via hmm_record_fault(), and returns
HMM_FAULT_PENDING:

mm/hmm.c:hmm_range_fault_locked() {
	ret =3D walk_page_range(mm, hmm_vma_walk.last, range->end,
			      &hmm_walk_ops, &hmm_vma_walk);
	if (ret =3D=3D HMM_FAULT_PENDING) {
		hmm_vma_migrate_disarm(&hmm_vma_walk);
		ret =3D hmm_do_fault(mm, &hmm_vma_walk);
		...
	}
}

While the PTE spinlock and migration mmu_notifier invalidation are dropped
during hmm_do_fault(), a concurrent madvise(MADV_DONTNEED) only requires
mmap_read_lock and can clear the migration PTEs in [range->start, addr) via
zap_pte_range() -> zap_nonpresent_ptes() without taking the folio lock. When
the loop resumes walk_page_range() at hmm_vma_walk.last =3D addr,
hmm_vma_handle_migrate_prepare_rollback() only inspects [addr, end) and nev=
er
re-checks [range->start, addr).

Those zapped entries keep HMM_PFN_VALID | HMM_PFN_MIGRATE in range->hmm_pfn=
s[]
and pass migrate_vma_check_page() because folio_mapped(src) is false. Later,
in __migrate_device_finalize(), remove_migration_ptes(src, dst, 0) finds no
migration PTEs to replace (so dst is never mapped into the CPU page tables =
or
given a page table refcount), and folio_put(dst) frees the destination folio
while the device driver still has it mapped.

[Severity: High]
As reported by Sashiko on v16 [3], can switching migrate_vma_setup() and
hmm_range_fault() to the HMM migration path deadlock on folio locks in
migrate_vma_split_folio() and hmm_do_fault(), or cause spurious split_folio=
()
-EAGAIN failures?

First, during migration collection, hmm_vma_handle_migrate_prepare() keeps =
all
previously collected folios in the range locked (using folio_trylock() to
avoid deadlocks). However, when it encounters a PTE-mapped large folio, it
calls migrate_vma_split_folio(), which takes a reference and does a blocking
folio_lock() while still holding the locks and migration PTEs on fault_folio
and all earlier collected folios:

mm/hmm.c:migrate_vma_split_folio() {
	if (folio !=3D fault_folio)
		folio_get(folio);

	lazy_mmu_mode_disable();
	pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
	hmm_vma_walk->ptelocked =3D false;

	if (folio !=3D fault_folio)
		folio_lock(folio);

	return __migrate_vma_split_folio(folio, fault_page);
}

If another task holds folio_lock(folio) and waits on one of the earlier
migration PTEs via migration_entry_wait() (or tries to lock one of the
already-collected folios), both tasks deadlock. Taking folio_get(folio) bef=
ore
folio_lock(folio) also means a concurrent caller blocking on folio_lock(fol=
io)
elevates the refcount and causes the lock holder's split_folio() to fail wi=
th
-EAGAIN.

Second, when HMM_PFN_REQ_FAULT is used with HMM_PFN_REQ_MIGRATE, encounteri=
ng
another thread's migration entry in hmm_vma_handle_pte() or hmm_vma_walk_pm=
d()
(or a swap or device-private entry) invokes hmm_do_fault() ->
handle_mm_fault(), which sleeps in migration_entry_wait() or folio_lock()
while still holding the locks and migration PTEs on all folios collected
earlier in the walk.

[Severity: High]
Does hmm_vma_handle_migrate_prepare_pmd() in mm/hmm.c miss a
folio_test_anon(folio) check when collecting or splitting a PMD-mapped THP?

At the PTE level, hmm_vma_handle_migrate_prepare() rejects non-anonymous
folios:

mm/hmm.c:hmm_vma_handle_migrate_prepare() {
	/* Only anonymous memory can be migrated to device memory */
	if (!page || !folio_test_anon(page_folio(page)))
		goto out;
}

However, hmm_vma_handle_migrate_prepare_pmd() selects any non-zero
pmd_trans_huge(*pmdp) folio when MIGRATE_VMA_SELECT_SYSTEM is set:

mm/hmm.c:hmm_vma_handle_migrate_prepare_pmd() {
	if (pmd_trans_huge(*pmdp)) {
		if (!(minfo & MIGRATE_VMA_SELECT_SYSTEM))
			goto out;

		folio =3D pmd_folio(*pmdp);
		if (is_huge_zero_folio(folio))
			return hmm_pfns_fill(start, end, hmm_vma_walk, 0);

	}
}

If HMM migration runs on a private file-backed or shmem VMA containing a
PMD-mapped page-cache/shmem THP, hmm_vma_handle_migrate_prepare_pmd() locks
the non-anonymous folio and either installs a PMD migration entry (holding =
the
file/shmem folio lock across subsequent faults in hmm_do_fault(), which take
mapping->invalidate_lock and invert the mapping->invalidate_lock -> folio_l=
ock
ordering) or splits the THP even though hmm_vma_handle_migrate_prepare() wi=
ll
reject all of its PTEs.

[Severity: High]
In hmm_vma_walk_pmd() in mm/hmm.c, when splitting a PTE-mapped large folio
fails in hmm_vma_handle_migrate_prepare(), doesn't returning 0 immediately
skip the remaining PTEs in [addr + PAGE_SIZE, end)?

In the PTE loop of hmm_vma_walk_pmd():

mm/hmm.c:hmm_vma_walk_pmd() {
	for (; addr < end; addr +=3D PAGE_SIZE, ptep++, hmm_pfns++) {
		...
		r =3D hmm_vma_handle_pte(walk, addr, end, pmdp, ptep, hmm_pfns);
		...
		r =3D hmm_vma_handle_migrate_prepare(walk, pmdp, addr, ptep,
						   hmm_pfns, &unmapped);
		if (r =3D=3D -EAGAIN) {
			addr =3D start;
			goto again;
		}
		if (r) {
			HMM_ASSERT_UNLOCKED(hmm_vma_walk);
			if (unmapped)
				flush_tlb_range(walk->vma, start, addr);
			return 0;
		}
	}
}

When migrate_vma_split_folio() fails at addr, it drops the PTE lock and
hmm_vma_handle_migrate_prepare() returns -EFAULT. Returning 0 from
hmm_vma_walk_pmd() tells walk_page_range() that the entire PMD range
[start, end) is complete, leaving [addr + PAGE_SIZE, end) unvisited and
unpopulated in range->hmm_pfns[]. Moreover, if an earlier pass in
hmm_vma_walk_pmd() had already collected PTEs at addresses above addr before
restarting via addr =3D start; goto again, dropping the PTE lock at addr and
returning 0 skips re-verifying and rolling back those collected entries in
[addr + PAGE_SIZE, end).

[Severity: Medium]
Can writable protnone PTEs and PMDs lose MIGRATE_PFN_WRITE in migrate->src[]
when migrated via migrate_vma_setup() or hmm_range_fault() without
HMM_PFN_REQ_FAULT?

For a present protnone PTE or PMD, pte_to_hmm_pfn_flags() and
pmd_to_hmm_pfn_flags() return 0, so HMM_PFN_WRITE is not set in *hmm_pfn.
Then hmm_vma_handle_migrate_prepare() and hmm_vma_handle_migrate_prepare_pm=
d()
collect the protnone entry, install a writable migration entry if
pte_write(pte) or pmd_write(*pmdp) is true, and set HMM_PFN_VALID |
HMM_PFN_MIGRATE in *hmm_pfn, but never set HMM_PFN_WRITE:

mm/hmm.c:hmm_vma_handle_migrate_prepare() {
		set_pte_at(mm, addr, ptep, swp_pte);
		folio_remove_rmap_pte(folio, page, walk->vma);
		folio_put(folio);
		*hmm_pfn |=3D HMM_PFN_VALID | HMM_PFN_MIGRATE;
}

When migrate_hmm_range_setup() builds migrate->src[i] from range->hmm_pfns[=
i]:

mm/migrate_device.c:migrate_hmm_range_setup() {
		migrate->src[i] |=3D MIGRATE_PFN_MIGRATE;
		migrate->src[i] |=3D (pfn & HMM_PFN_WRITE) ? MIGRATE_PFN_WRITE : 0;
		migrate->src[i] |=3D (pfn & HMM_PFN_COMPOUND) ? MIGRATE_PFN_COMPOUND : 0;
}

MIGRATE_PFN_WRITE is left unset even though the deleted
migrate_vma_collect_pmd() and migrate_vma_collect_huge_pmd() helpers preser=
ved
MIGRATE_PFN_WRITE whenever pte_write(pte) or pmd_write(*pmdp) was set. Shou=
ld
hmm_vma_handle_migrate_prepare() and hmm_vma_handle_migrate_prepare_pmd() a=
lso
set HMM_PFN_WRITE on *hmm_pfn when writable is true?

[1] https://lore.kernel.org/r/arY5zKsLuf7f_EYw@infradead.org
[2] https://lore.kernel.org/r/20261021060506.2377545-10-mpenttil@redhat.com
[3] https://lore.kernel.org/r/20261021060506.2377545-10-mpenttil@redhat.com

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103061629.9726=
69-1-mpenttil@redhat.com?part=3D9

