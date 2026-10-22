Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1915A606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 06:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZGCylY8y
Received: by kanga.kvack.org (Postfix)
	id 3BEC66B0892; Thu, 22 Oct 2026 02:06:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36F1D6B0894; Thu, 22 Oct 2026 02:06:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 237C46B0895; Thu, 22 Oct 2026 02:06:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E14206B0892
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:06:49 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C1BBE8070F
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:06:48 +0000 (UTC)
X-FDA: 85349228496.26.AA1D51D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 35F0640005
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:06:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZGCylY8y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792649207;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xyz7kNJsYTtP7FKPzHrh2zQQt8iembKlO92slQjti2Q=;
	b=E7LtwzuIjWOqhwW8fsGokmnd3yIQbseMvwiIs4cd3QxabfpKNjIRUpRsueQGIkzLD3K5BJ
	dQ/ogm7nnA+vpFNZ4uI4w8npKM8THgbOfrcE60p5A9/cplbeC8UrbpMlgTMY8oI+hTUYfL
	wMwUfXI1B0FxdjHruA1IqjKYIoihjxo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZGCylY8y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792649207;
	b=mjvr8nS66RVZT34bp5xw7kGdPu8Y8FJCu9+s/4wXd1dx8DuXZ+V7pbvZqRdz/J3M6gNGLW
	ThSnm4csB+a7LKSKdbgHsWQZRfkTmij8U/1DNd9CZl5nFGCjWuKnK76N/hWrIU1CILyYAI
	tm0Be/uUn5MWzLwHQLwcXnKewKLGHrc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BA09D60210;
	Thu, 22 Oct 2026 06:06:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF30F1F000C1;
	Thu, 22 Oct 2026 06:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792649206;
	bh=xyz7kNJsYTtP7FKPzHrh2zQQt8iembKlO92slQjti2Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZGCylY8yiKYbpiLASjmeOEV46JP69PLF5nImXPksCH5otcs/md+ptyLffWCL8Ym3y
	 42+OAHcDBW2z7N+DL1GdDmcM1v+Bw7xCfrIjCLnzhS5QHv0eWFsOsx0pyXEdWDYQck
	 xuhrKEcIcQTBP5eVq5iyO6cF2PtCzhlzWLiY0hbNG8dMJ8lSOcHEiOPiebwPkQqFUI
	 cmAvIoJ/SFJA5xme92ScocIDOEg4r9+SJ2xZXcefymeev2BRXjuqoRLnWuJLYoFqbE
	 6s7S7R6exR1NClVzdHSL64YbK5fRIpk/0GFU+JC+KmrXGpaPt3mWIMn3KotmEVIBU0
	 BhsqS8M69VBGg==
Message-ID: <sashiko-outbox-181059@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v16 11/12] Documentation/mm/hmm: document migration
 through hmm_range_fault()
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
In-Reply-To: <20261021060506.2377545-12-mpenttil@redhat.com>
References: <20261021060506.2377545-1-mpenttil@redhat.com>
 <20261021060506.2377545-12-mpenttil@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 06:06:44 +0000
X-Rspamd-Queue-Id: 35F0640005
X-Stat-Signature: 3e7j5zbxykqgbwebuhq1h7j1iutq3tgh
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792649207-774111
X-HE-Meta: U2FsdGVkX1+kr0No6fS1M6cCw+cr+/eqDOjwov9xwWzPcYxLFe1wJkdfgdQxGEGPjCemcvg/7CZmfdczmt7IXtOtNUETZ1QsPN72QIIrmGrRncSz11odR0Bdv6RxPXAdDl38rIyqqIlLtRWGoFIQX6F6hdtPSz4jLEOFY3iw6F1cGARf6dhXX+rHUSrTvP4tLOOPJbu1UrBGx2PPvknvluSbYm5aZCTrCyrMf7lN153ez00GQveHU/6a3/5PTQnMF5B5vULDkOHqKtoe4FCGGR7gPTG9l7pFkL5z3vwJC4Wj00z/SzRpwpAv0qKEA4a1w+UOXtFTL0n53RIYcx2E2qWBh6s1JNiUDy2GEbo90FVReyKwX0OwnAWfPLuYTrxq+NeXM/XPLRbiGyQaGKjvUHuuOCkEa8Vnc5/NhEtD3Maax0Q6g/kMEk9C7idNffiCX/fr/eVKip6wX1DNlx6YpeJjjLgdlRUxKa8t2TXHPp4ZD4SoPiYvchoJYIGZo9iBUSJMYKKD3viOoCNPuOnlYeDwgdJ9BCocoNPJyHnVN7dGaIniyrQx5woxLea6pjWECuQLM42VQ/Iei9/y7jXdylukwMFgt0B8yoaXJW2/j0G0+YS1owr784rIDkm+xvbCp2F6NG9BOesEYMvfh/NXaIsZWnSaB3FSH7Vzgq8eBtmKeFXZG9TFZTYV+YiJxAdAe1uyhj4mIzFd3ebbfXV2fmMAv78zvMEjnwHDbU5erCXjykVDiXu5w1QJbLXND9J+qsMAKzLcUJX6+c76q8xBGTiVzoNkyq1VPxG2i+x8oCh4+77WCiOFhyHrMn/w4Tku8WL3WNzu0ayImlVMqNdKnoINSkwKjA5Cpu+UVFfjnsAgBHUsevb053tTSkx3hPkQnx33Lao6I9HsiNbW6AiQEjl+iCbLLMKpaFrUBML1pYKWbxbBbqDhB0sCZTOf4JwclxwKB0C1VyeCX3OHTxA
 UfoIL3jz
 3v7TdrVTzqhsZFCXkDYGnb/lMtirdDaq0AvzSboGszu+R2+QTatlmjxiYuPjMFt6ihlO57qWhMenqaP1Rwc2RKLXEhi0/+wNCjG9q0KqNoBO5h0l6txF/LKHTOAfxHblG+v04qv9gJTR3m8N3qrANLF9MqUSosDgxII7bXQrJy9BY4PMksKqAMy70KK4jyK/XPRtuo0enOQemWksES5f2wpvwARthd45SIIIXLKZjNpt5x7ku5mvCqYxX1Td2rvFbFMMZkztdhdaJAreorQVH9kATNuf3NQmqmHAORzHE9BILBxHx9eZ/nYogAhAzz3bQCDx83XN1fGClWnLUJJbjMLeL18/rN56/6YEdXDnZKlhaKtKOv5kyImn/JCYOP9AKEzabMJZh/NF/91g2HfApWpJzwFDdPOHHFpVLRL+eIUwS4dVRH1IJabW+eVsMB64PuchKTUX/oygr3YU6jb3IczQXV2C17BX9c+yF5LeXqaID45mkGFo0rpOjPineAR3cMIt2irrRGUOxQNioM+z3I5jd/l2r9FMgXo0eUnasq4F6tRz/Sb+o02rWS4POmXo06FzFqL1kDXQNQmOk/gEdPRN/3/bv9ZLksm0KRjYSNikV0Nobwb8C8O2tVE1lW5N2u6mnH+stufaZPgMBw4EvLii20TAB3p8gQ6HTyhd4Y8LDAH/0LM4XDiKu7UlvckSAYB9Z0LCBOFhyGh/MFRGW2GVqWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Critical] mm/hmm: dangling migration PTE and UAF on migration collection=
 rollback
- [High] mm/hmm: incomplete rollback of collected folios in hmm_vma_walk_pm=
d()
- [High] mm/hmm: uninitialized bounds and pfn state bugs in migrate_hmm_ran=
ge_setup()
- [Medium] mm/hmm: test_hmm: unmapped device pages on retry in do_fault_and=
_migrate()
--

commit d7bcd4b72dc6ea1ed912615ed1934d28e4808508
Author: Mika Penttil=C3=A4 <mpenttil@redhat.com>

Documentation/mm/hmm: document migration through hmm_range_fault()

This patch series enables driving device page migration collection through
hmm_range_fault() and migrate_hmm_range_setup(), updates migrate_vma_setup()
to use the HMM pagewalk path, and adds a migrate-on-fault selftest and
documentation.

> diff --git a/Documentation/mm/hmm.rst b/Documentation/mm/hmm.rst
> index fc1b8dc198250..58424e5f5873c 100644
> --- a/Documentation/mm/hmm.rst
> +++ b/Documentation/mm/hmm.rst
> @@ -427,6 +434,38 @@ between device driver specific code and shared commo=
n code:
> =20
>     The lock can now be released.
> =20
> +Migration collection through hmm_range_fault()
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +The collection phase of migration (steps 1 and 2 above) can also be driv=
en by
> +hmm_range_fault() directly, sharing its page table walk. This lets a dri=
ver
> +fault in and collect a range for migration in one walk, which is useful =
for
> +migrate on fault.
> +
> +To do so, the driver sets ``HMM_PFN_REQ_MIGRATE`` in ``range->default_fl=
ags``
> +and points ``range->migrate`` at a ``struct migrate_vma`` it has filled =
in
> +(``flags``, ``src``, ``dst``, ``pgmap_owner``). Usually ``HMM_PFN_REQ_FA=
ULT``
> +(and ``HMM_PFN_REQ_WRITE``) is set as well, so missing pages are faulted=
 in
> +before being collected. The mmap_read_lock() has to be held for the whole
> +migration, since the vma must stay stable.
> +
> +hmm_range_fault() collects the entries the same way migrate_vma_setup() =
does,
> +taking a folio reference, locking it and installing a migration PTE. Col=
lected
> +entries are marked with ``HMM_PFN_VALID | HMM_PFN_MIGRATE`` in
> +``range->hmm_pfns``. If the page tables change while locks are dropped t=
he
> +partially collected entries are rolled back automatically.
> +
> +After hmm_range_fault() returns, the driver calls::
> +
> +    void migrate_hmm_range_setup(struct hmm_range *range);
> +
> +to translate ``range->hmm_pfns`` into ``migrate->src[]`` (``migrate->dst=
[]`` is
> +zeroed) and initialize ``migrate->cpages`` and ``migrate->npages``. From=
 here on
> +the ``range->migrate`` struct is ready for the rest of the flow (steps 3
> +onwards), i.e. migrate_vma_pages() and migrate_vma_finalize(). This shou=
ld be
> +called even on error, since hmm_range_fault() may have collected part of=
 the
> +range before failing.
> +
>  Exclusive access memory
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =20
> diff --git a/lib/test_hmm.c b/lib/test_hmm.c
> index b409c42bfe6fc..2045896493ae3 100644
> --- a/lib/test_hmm.c
> +++ b/lib/test_hmm.c

[ ... ]

> @@ -1377,6 +1398,127 @@ static int dmirror_migrate_to_device(struct dmirr=
or *dmirror,
>  	return ret;
>  }
> =20
> +static int do_fault_and_migrate(struct dmirror *dmirror, struct hmm_rang=
e *range)
> +{
> +	struct migrate_vma *migrate =3D range->migrate;
> +	unsigned long timeout =3D
> +		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
> +	int ret;
> +
> +	do {
> +		mmap_read_lock(dmirror->notifier.mm);
> +
> +		/* Fault-in pages for migration */
> +		ret =3D dmirror_range_fault(dmirror, range);
> +		/*
> +		 * Set this up even on error: hmm_range_fault() may have collected
> +		 * part of the range before failing.
> +		 */
> +		migrate_hmm_range_setup(range);
> +		if (ret) {
> +			/*
> +			 * dst[] entries are empty, so this marks every collected
> +			 * migration as failed. finalize then restores the source
> +			 * mappings and drops the associated locks/references.
> +			 */
> +			migrate_vma_pages(migrate);
> +			migrate_vma_finalize(migrate);
> +			goto unlock;
> +		}
> +
> +		pr_debug("Migrating from sys mem to device mem\n");
> +
> +		dmirror_migrate_alloc_and_copy(migrate, dmirror);
> +		migrate_vma_pages(migrate);
> +
> +		mutex_lock(&dmirror->mutex);
> +		if (mmu_interval_read_retry(&dmirror->notifier,
> +					    range->notifier_seq))
> +			ret =3D -EBUSY;
> +		else
> +			ret =3D __dmirror_migrate_map_locked(migrate, dmirror);
> +		mutex_unlock(&dmirror->mutex);
> +
> +		migrate_vma_finalize(migrate);
> +unlock:
> +		mmap_read_unlock(dmirror->notifier.mm);
> +	} while (ret =3D=3D -EBUSY && !time_after(jiffies, timeout));
> +
> +	return ret;
> +}
> +
> +static int dmirror_fault_and_migrate_to_device(struct dmirror *dmirror,
> +					       struct hmm_dmirror_cmd *cmd)
> +{
> +	unsigned long start, size, end, next;
> +	unsigned long src_pfns[PFNS_ARRAY_SIZE] =3D { 0 };
> +	unsigned long dst_pfns[PFNS_ARRAY_SIZE] =3D { 0 };
> +	struct migrate_vma migrate =3D { 0 };
> +	struct hmm_range range =3D { 0 };
> +	struct dmirror_bounce bounce;
> +	int ret =3D 0;
> +
> +	/* Whole range */
> +	start =3D cmd->addr;
> +	size =3D cmd->npages << PAGE_SHIFT;
> +	end =3D start + size;
> +
> +	if (!mmget_not_zero(dmirror->notifier.mm)) {
> +		ret =3D -EFAULT;
> +		goto out;
> +	}
> +
> +	migrate.pgmap_owner =3D dmirror->mdevice;
> +	migrate.src =3D src_pfns;
> +	migrate.dst =3D dst_pfns;
> +	migrate.flags =3D MIGRATE_VMA_SELECT_SYSTEM;

[Severity: Medium]
In do_fault_and_migrate() in lib/test_hmm.c, dmirror_range_fault() runs
hmm_range_fault() with HMM_PFN_REQ_FAULT | HMM_PFN_REQ_MIGRATE and unlocks
dmirror->mutex, after which migrate_hmm_range_setup(),
dmirror_migrate_alloc_and_copy(), and migrate_vma_pages() commit the folio
migration from system memory to device-private pages.

If a concurrent invalidation in the process address space updates
dmirror->notifier before mutex_lock(&dmirror->mutex) is acquired in
do_fault_and_migrate(), mmu_interval_read_retry() returns true, setting
ret =3D -EBUSY and skipping __dmirror_migrate_map_locked(), while
migrate_vma_finalize() still installs device-private swap ptes into the cpu
page table and frees the source system pages.

On the next iteration of the retry loop, the pages in the cpu page table are
already device-private pages owned by dmirror->mdevice, while
dmirror_fault_and_migrate_to_device() only sets migrate.flags to
MIGRATE_VMA_SELECT_SYSTEM. Because hmm_vma_handle_migrate_prepare() does not
set HMM_PFN_MIGRATE on those entries and migrate_hmm_range_setup() zeroes
migrate->src[], __dmirror_migrate_map_locked() skips them.

Won't this leave the migrated device pages absent from dmirror->pt on retry
and cause dmirror_do_read() to fail with -ENOENT when invoked via
HMM_DMIRROR_MIGRATE_ON_FAULT_TO_DEV?

[ ... ]

> diff --git a/mm/hmm.c b/mm/hmm.c
> index 2f1e98c6b6440..4d853ee8e8b8c 100644
> --- a/mm/hmm.c
> +++ b/mm/hmm.c

[ ... ]

> @@ -296,14 +369,26 @@ static int hmm_vma_handle_pte(struct mm_walk *walk,=
 unsigned long addr,
>  			goto fault;
> =20
>  		if (softleaf_is_migration(entry)) {
> -			pte_unmap(ptep);
> -			hmm_vma_walk->last =3D addr;
> -			migration_entry_wait(walk->mm, pmdp, addr);
> -			return -EBUSY;
> +			if (!hmm_select_migrate(range)) {
> +				HMM_ASSERT_UNLOCKED(hmm_vma_walk);
> +				pte_unmap(ptep);
> +				hmm_vma_walk->last =3D addr;
> +				migration_entry_wait(walk->mm, pmdp, addr);
> +				return -EBUSY;
> +			}
> +			return 0;
>  		}
> =20
>  		/* Report error for everything else */
> -		pte_unmap(ptep);
> +
> +		if (hmm_vma_walk->ptelocked) {
> +			lazy_mmu_mode_disable();
> +			pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
> +			hmm_vma_walk->ptelocked =3D false;
> +		} else {
> +			pte_unmap(ptep);
> +		}
> +
>  		return -EFAULT;
>  	}
> =20
> @@ -320,7 +405,14 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, =
unsigned long addr,
>  	if (!vm_normal_page(walk->vma, addr, pte) &&
>  	    !is_zero_pfn(pte_pfn(pte))) {
>  		if (hmm_pte_need_fault(hmm_vma_walk, pfn_req_flags, 0)) {
> -			pte_unmap(ptep);
> +			if (hmm_vma_walk->ptelocked) {
> +				lazy_mmu_mode_disable();
> +				pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
> +				hmm_vma_walk->ptelocked =3D false;
> +			} else {
> +				pte_unmap(ptep);
> +			}
> +
>  			return -EFAULT;
>  		}
>  		new_pfn_flags =3D HMM_PFN_ERROR;
> @@ -329,11 +421,20 @@ static int hmm_vma_handle_pte(struct mm_walk *walk,=
 unsigned long addr,
> =20
>  	new_pfn_flags =3D pte_pfn(pte) | cpu_flags;
>  out:
> +	hmm_vma_handle_migrate_prepare_rollback(hmm_vma_walk, addr,
> +						addr + PAGE_SIZE,
> +						hmm_pfn);
>  	*hmm_pfn =3D (*hmm_pfn & HMM_PFN_INOUT_FLAGS) | new_pfn_flags;
>  	return 0;

[Severity: Critical]
When hmm_vma_handle_migrate_prepare() in mm/hmm.c collects a present page, =
it
takes a folio reference with folio_get(), locks the folio with
folio_trylock(), installs a migration pte via set_pte_at(), removes the rmap
with folio_remove_rmap_pte(), drops the pte reference with folio_put(), and
marks *hmm_pfn with HMM_PFN_VALID | HMM_PFN_MIGRATE.

In hmm_vma_handle_pte(), when !pte_present(pte) is true, the check:

	required_fault =3D
		hmm_pte_need_fault(hmm_vma_walk, pfn_req_flags, 0);
	if (!required_fault)
		goto out;

is evaluated before softleaf_is_migration(entry). When HMM_PFN_REQ_FAULT is
not set for an entry (for example when hmm_range_fault() is called with
HMM_PFN_REQ_MIGRATE only, or with per-pfn fault flags) and the walk restarts
or retries over a migration pte that was already installed by this walk,
hmm_vma_handle_pte() jumps to out: and calls
hmm_vma_handle_migrate_prepare_rollback().

That rollback unlocks the folio, drops the collection reference via
folio_put(folio), and clears HMM_PFN_VALID | HMM_PFN_MIGRATE without calling
remove_migration_ptes(). Because HMM_PFN_MIGRATE is cleared,
migrate_hmm_range_setup() and migrate_vma_finalize() never restore the pte.
Similarly, in hmm_vma_walk_pmd(), if hmm_vma_handle_migrate_prepare() fails
with a non--EAGAIN error at addr (when migrate_vma_split_folio() fails), it
calls hmm_pfns_fill(addr, end, hmm_vma_walk, HMM_PFN_ERROR), which runs
hmm_vma_handle_migrate_prepare_rollback() across [addr, end) without removi=
ng
any migration ptes that may already be installed in (addr, end) from an
earlier pass. Doesn't this leave dangling migration ptes in the process page
tables pointing to unlocked and potentially freed folios?

Conversely, when HMM_PFN_REQ_FAULT and HMM_PFN_REQ_MIGRATE are both set,
softleaf_is_migration(entry) in hmm_vma_handle_pte() and
pmd_is_migration_entry(pmd) in hmm_vma_walk_pmd():

	if (thp_migration_supported() && pmd_is_migration_entry(pmd)) {
		if (!minfo) {
			if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns_start, npages, 0)) {
				hmm_vma_walk->last =3D addr;
				pmd_migration_entry_wait(walk->mm, pmdp);
				return -EBUSY;
			}
			for (i =3D 0; start < end; start +=3D PAGE_SIZE, i++)
				hmm_pfns_start[i] &=3D HMM_PFN_INOUT_FLAGS;
		}
		...
		return 0;
	}

return 0 whenever migration is enabled without checking
hmm_pfn_collected(*hmm_pfn). If a migration pte or pmd was installed by
another concurrent thread (such as compaction, reclaim, or another migratio=
n)
rather than the current walk, won't hmm_range_fault() skip
migration_entry_wait() and pmd_migration_entry_wait() and return 0 with
unpopulated hmm_pfns entries?

[ ... ]

> @@ -456,24 +1183,70 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
>  	 * recover.
>  	 */
>  	if (pmd_bad(pmd)) {
> -		if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0))
> +		if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns_start, npages, 0))
>  			return -EFAULT;
> -		return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
> +		return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
>  	}
> =20
> -	ptep =3D pte_offset_map(pmdp, addr);
> -	if (!ptep)
> +	if (minfo) {
> +		ptep =3D pte_offset_map_lock(mm, pmdp, addr, &hmm_vma_walk->ptl);
> +		if (ptep) {
> +			lazy_mmu_mode_enable();
> +			hmm_vma_walk->ptelocked =3D true;
> +		} else {
> +			/* The pte table is gone */
> +			hmm_vma_handle_migrate_prepare_rollback(walk->private, addr, end, hmm=
_pfns);
> +		}
> +	} else {
> +		ptep =3D pte_offset_map(pmdp, addr);
> +	}
> +	if (!ptep) {
> +		addr =3D start;
>  		goto again;
> +	}
> +
>  	for (; addr < end; addr +=3D PAGE_SIZE, ptep++, hmm_pfns++) {
> -		int r;
> =20
>  		r =3D hmm_vma_handle_pte(walk, addr, end, pmdp, ptep, hmm_pfns);
>  		if (r) {
> -			/* hmm_vma_handle_pte() did pte_unmap() */
> +			/* hmm_vma_handle_pte() did pte_unmap() / pte_unmap_unlock */
> +			if (unmapped)
> +				flush_tlb_range(walk->vma, start, addr);
>  			return r;
>  		}
> +
> +		r =3D hmm_vma_handle_migrate_prepare(walk, pmdp, ptep, addr, hmm_pfns,=
 &unmapped);
> +		if (r =3D=3D -EAGAIN) {
> +			HMM_ASSERT_UNLOCKED(hmm_vma_walk);
> +			if (unmapped) {
> +				flush_tlb_range(walk->vma, start, addr);
> +				unmapped =3D false;
> +			}
> +			goto again;
> +		}
> +		if (r) {
> +			/* A non -EAGAIN error here means migrate_vma_split_folio()
> +			 * already dropped the PTE lock and cleared ptelocked.
> +			 */
> +			HMM_ASSERT_UNLOCKED(hmm_vma_walk);
> +			if (unmapped)
> +				flush_tlb_range(walk->vma, start, addr);
> +			hmm_pfns_fill(addr, end, hmm_vma_walk, HMM_PFN_ERROR);
> +			return 0;
> +		}
>  	}

[Severity: High]
In hmm_vma_walk_pmd() in mm/hmm.c, after entries in [start, addr) have been
collected into hmm_pfns_start with HMM_PFN_VALID | HMM_PFN_MIGRATE,
hmm_vma_handle_migrate_prepare() may encounter a pte-mapped large folio at
addr > start and call migrate_vma_split_folio(), which drops
hmm_vma_walk->ptl, splits the folio, and returns -EAGAIN.

hmm_vma_walk_pmd() then jumps to again: without resetting addr =3D start:

1. At again:, hmm_pfns points to addr rather than start. If
   pte_offset_map_lock() returns NULL because the pte table disappeared whi=
le
   the lock was dropped, hmm_vma_handle_migrate_prepare_rollback(walk->priv=
ate,
   addr, end, hmm_pfns) runs before addr =3D start, rolling back the unvisi=
ted
   tail [addr, end) instead of [start, addr) (hmm_pfns_start).
2. If while the pte lock was dropped a concurrent MADV_DONTNEED zapped the
   migration ptes in [start, addr) (or the pte table was freed and replaced
   by a new pte table) and pte_offset_map_lock() succeeds at addr > start,
   the loop resumes from addr without re-walking or rolling back
   [start, addr). hmm_range_fault() then returns 0 with
   HMM_PFN_VALID | HMM_PFN_MIGRATE still set for folios whose migration ptes
   were already cleared, so remove_migration_ptes() installs no ptes for the
   destination device folio and migrate_vma_finalize() frees the destination
   folio while it is mapped by the device.
3. If the pte table was replaced by a pmd migration entry while the lock was
   dropped, the pmd_is_migration_entry(pmd) check in hmm_vma_walk_pmd() sees
   minfo !=3D 0 and returns 0 without rolling back hmm_pfns_start.
4. When re-walking a range that already has collected entries in hmm_pfns,
   the fault and -EFAULT paths in hmm_vma_handle_pte(), hmm_vma_walk_hole(),
   hmm_vma_handle_pmd(), and hmm_vma_handle_absent_pmd() return
   HMM_FAULT_PENDING or -EFAULT without calling
   hmm_vma_handle_migrate_prepare_rollback(), leaving the previously
   collected folio locked while hmm_do_fault() runs or when
   hmm_range_fault_locked() aborts on mmu_interval_check_retry().

Can these paths leak folio locks and references or self-deadlock on
folio_lock() during fault handling?

[ ... ]

> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 0c437004329d9..c61a9e54e06bb 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c

[ ... ]

> @@ -1528,3 +1054,58 @@ int migrate_device_coherent_folio(struct folio *fo=
lio)
>  		return 0;
>  	return -EBUSY;
>  }
> +
> +/**
> + * migrate_hmm_range_setup() - prepare to migrate a range of memory
> + * @range: contains pointer to struct migrate_vma to be set up.
> + *
> + * When collecting has been done with hmm_range_fault(), this
> + * should be called next, and completes range->migrate by
> + * populating migrate->src[] and migrate->dst[]
> + * using range->hmm_pfns[].
> + * Also, migrate->cpages and migrate->npages get initialized.
> + * After migrate_hmm_range_setup(), range->migrate is good
> + * for the rest of the migrate_vma_* flow.
> + */
> +void migrate_hmm_range_setup(struct hmm_range *range)
> +{
> +	struct migrate_vma *migrate =3D range->migrate;
> +
> +	if (!migrate)
> +		return;
> +
> +	migrate->npages =3D (migrate->end - migrate->start) >> PAGE_SHIFT;
> +	migrate->cpages =3D 0;
> +
> +	for (unsigned long i =3D 0; i < migrate->npages; i++) {
> +		unsigned long pfn =3D range->hmm_pfns[i];
> +
> +		/*
> +		 * We are only interested in entries to be
> +		 * migrated.
> +		 */
> +		if (!(pfn & HMM_PFN_MIGRATE)) {
> +			migrate->src[i] =3D 0;
> +			migrate->dst[i] =3D 0;
> +			continue;
> +		}
> +
> +		migrate->cpages++;
> +
> +		/* HMM_PFN_MIGRATE without HMM_PFN_VALID denotes the special zero page=
 */
> +		if (pfn & HMM_PFN_VALID)
> +			migrate->src[i] =3D migrate_pfn(page_to_pfn(hmm_pfn_to_page(pfn)));
> +		else
> +			migrate->src[i] =3D 0;
> +
> +		migrate->src[i] |=3D MIGRATE_PFN_MIGRATE;
> +		migrate->src[i] |=3D (pfn & HMM_PFN_WRITE) ? MIGRATE_PFN_WRITE : 0;
> +		migrate->src[i] |=3D (pfn & HMM_PFN_COMPOUND) ? MIGRATE_PFN_COMPOUND :=
 0;
> +		migrate->dst[i] =3D 0;
> +	}
> +
> +	if (migrate->cpages)
> +		migrate_vma_unmap(migrate);
> +
> +}
> +EXPORT_SYMBOL(migrate_hmm_range_setup);

[Severity: High]
There appear to be three issues with how migrate_hmm_range_setup() in
mm/migrate_device.c and hmm_vma_post_range_fault() in mm/hmm.c handle range
bounds and range->hmm_pfns state:

1. Documentation/mm/hmm.rst states that drivers initialize flags, src, dst,
   and pgmap_owner in range->migrate and call migrate_hmm_range_setup(range)
   even on error. However, hmm_vma_post_range_fault() in mm/hmm.c only calls
   hmm_fill_migrate_vma() to set migrate->vma, migrate->start, and
   migrate->end when hmm_vma_walk->mmu_armed is true:

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

   If hmm_range_fault() fails before hmm_vma_capture_migrate_range() sets
   mmu_armed =3D true (for example when mmu_interval_check_retry() fails at=
 the
   start of hmm_range_fault_locked(), or when range->start falls in an
   unmapped hole so hmm_vma_walk_hole() returns -EFAULT before test_walk
   runs), migrate->start and migrate->end are never updated. Doesn't
   migrate_hmm_range_setup() then compute migrate->npages from uninitialized
   memory or stale bounds from a previous loop iteration (such as the chunk
   loop in dmirror_fault_and_migrate_to_device())?

2. Pagewalk callbacks in mm/hmm.c index range->hmm_pfns using
   (addr - range->start) >> PAGE_SHIFT. If [range->start, range->end) starts
   in a vma hole (range->start < vma->vm_start) and HMM_PFN_REQ_FAULT is not
   set for the hole, hmm_vma_walk_hole() fills the leading hole entries with
   HMM_PFN_ERROR and the walk continues into the vma, where
   hmm_vma_capture_migrate_range() sets hmm_vma_walk->start =3D vma->vm_sta=
rt
   and hmm_fill_migrate_vma() sets migrate->start =3D vma->vm_start. Because
   migrate_hmm_range_setup() indexes range->hmm_pfns from 0 rather than
   (migrate->start - range->start) >> PAGE_SHIFT, won't it read the leading
   HMM_PFN_ERROR entries and ignore the trailing collected entries in
   range->hmm_pfns, leaking their folio locks, folio references, and
   installed migration ptes?

3. Documentation/mm/hmm.rst states that migrate_hmm_range_setup() translates
   range->hmm_pfns into migrate->src[], without requiring range->hmm_pfns to
   alias migrate->src or be zero-initialized, and migrate_hmm_range_setup()
   does not clear HMM_PFN_VALID | HMM_PFN_MIGRATE in range->hmm_pfns[i]. Wh=
en
   range->hmm_pfns and migrate->src are separate arrays and range->hmm_pfns=
 is
   reused across -EBUSY retries or multi-chunk walks (or contains
   uninitialized data), won't hmm_vma_handle_migrate_prepare_rollback() see
   hmm_pfn_collected(range->hmm_pfns[i]) as true and call folio_unlock() and
   folio_put() on already-finalized or bogus pfns?

([
  {
    "id": "PVF1",
    "Patch": "mm/hmm: implement rollback for device page migration in HMM p=
agewalk",
    "Commit": "5c75620371e34a43110051163d33f29ab4f700b4"
  },
  {
    "id": "PVF2",
    "Patch": "mm/hmm: implement rollback for device page migration in HMM p=
agewalk",
    "Commit": "5c75620371e34a43110051163d33f29ab4f700b4"
  },
  {
    "id": "PVF3",
    "Patch": "mm: add helper to convert HMM pfn to migrate pfn",
    "Commit": "9636fd16690a9c1da892fd55feb0d227311adfe2"
  },
  {
    "id": "PVF4",
    "Patch": "lib/test_hmm: add a new testcase for the migrate on fault",
    "Commit": "43a1dd324a1ecfe103c0cf9ba76ea8935506e50c"
  }
])

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021060506.2377=
545-1-mpenttil@redhat.com?part=3D11

