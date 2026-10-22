Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 312A9606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 06:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X4VsFmg6
Received: by kanga.kvack.org (Postfix)
	id 015036B0885; Thu, 22 Oct 2026 02:06:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F091B6B0886; Thu, 22 Oct 2026 02:06:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF8C36B0887; Thu, 22 Oct 2026 02:06:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B2EA26B0885
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:06:37 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2395F4073E
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:06:37 +0000 (UTC)
X-FDA: 85349228034.02.020FC1E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9447A40006
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:06:35 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X4VsFmg6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792649195;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=USIeG4mPj5p6gJGNrF1061m2bBkd4+LoYAGwUGA3alE=;
	b=Tlr0pRjLwFqERhDOz5BqXnU8FRT/Iqafs6P2XVMlTWiIJEazW10t9dTgjTHOXcBfFjsLoR
	iCGMyqMZg13Qash+nUNDeKFmtgEe/Zd6LGW6HsQKJR2M4bMkSzF89PBhHdAa7yblTdHCR3
	sA9AdDVcq4YmVc8XuGVWAR923u+nTpA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X4VsFmg6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792649195;
	b=oLMxxwrML2wRx25PWCtmLKwC6V5DOcc0CFUsOl48KgawmpYYXbb/LHztnCjioX19lxGlt+
	ufYq4dC3u9+gEzOkXsZw+coULGG1RQw5DYhf87SA/U3MfUrcO2lCfw5p4NLVkFYfFfrzMc
	9WHd3mxwvLIXOcQtUVos3IiTQDSO8Vg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 43DFB60018;
	Thu, 22 Oct 2026 06:06:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE89D1F000C1;
	Thu, 22 Oct 2026 06:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792649194;
	bh=USIeG4mPj5p6gJGNrF1061m2bBkd4+LoYAGwUGA3alE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=X4VsFmg6NicAV9stEsHKhndRkDMi1LMvot8Awsm8N1OOsFl7V80PJWWOSUZ91wXky
	 yWpWqcv9P3PE1u5bBA7h+37mSmEti9zCaQ7b5ZNLiFGMWMfYKoV2vwIwOf4oZFzZVA
	 MA3j23fZpL7+GTiVf8FvOv44LlcuVngNl46RQ3TiI9/o6F9IPdks979MNWYUZ7WOU0
	 6hqzOQvksLKbT1dYn8GzUfWvfrp6DA8DbTlbOBV9cNb41koCeD+g8J0C/xVj4qD2FS
	 n1i5rKNEulJ4TC9SC6VXQ9+vNgpAD7Ue3LqOW+y1bOZVBf5x422QEfI88/Nr73fOXZ
	 XStgV37Qh6ZRg==
Message-ID: <sashiko-outbox-181051@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v16 03/12] mm/hmm: preparations for HMM to participate
 in migration
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
In-Reply-To: <20261021060506.2377545-4-mpenttil@redhat.com>
References: <20261021060506.2377545-1-mpenttil@redhat.com>
 <20261021060506.2377545-4-mpenttil@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 06:06:32 +0000
X-Rspamd-Queue-Id: 9447A40006
X-Stat-Signature: uzuiqhwwo1wg6njyypqh7dphr9zsedee
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792649195-438544
X-HE-Meta: U2FsdGVkX18kHBbQ6EAfYHH/dRYtz5K29z8nLGjRrvqZ39IbPLcjvhUjkctOeIsjQzQdOkVA1QqnDkujj0oA1910xycXRoDpgMBJWOvb5M2ZCD4LMuRhBmxjsSQH9Wu9gGGUOWeSDRNAgTci21dtwQkjzJd39SUXH4ed9ZI5u6y0c4DQ6ah3dOBIcUP8LFUUvrI3uVQ+0THF/kShtrKZigQpIpFU4MtRMrPU+miMAKdekZ3ylWLcF7k4a/MQjvLnIYwX07d6vEe3kbE0BOEqr6DlAEVjWn6Nnk/k7EpWE4+s/TBLVmUTegZUiYODrTgDkAn4tJz8YxSTPVy/ZeBbXJJbw6k9Y8p2gM+eHUKRB9SJ+9q7v1afrKI0A+U9N7l0fWCaClfgmS5NQqWmZI4ZSg0pvI4SEBlHkNAww2uRK7iE8kqzT+EwKYTp+rujsHYxKmouChgq4KvEAT9nZayFlW7kRFzY0AGzSQLSFEiI9MznZwxd28KGnPg8mE9UDB37ycwAh2YJJFX980nXcjU97hjJEM0zXJ+h25fz4js4BFclSTR5egSaHuyQ5PMFWncx9k1FAHcMXkpMz46/eA2SczcVvqgDmA/uHmuQbULmx8uyTSyNO7/ETnGfM1FVNIT/ZVtAypA0WdUI/VGjZGUGBFSSEQAUSNWjUx49AuOsl+HZYosmw1HZT1Nrqrm7Sa7NgLO4B6L58OxqWc9Q/I+R5RGiNjnNDoPNzPOKAo5LVcp1gjOMp0/Ejx2v7MVMEWu6x7pyJ8Uoedxyk25HvF4INg0NfNco4j8KAjPMWji50/KltvVsxSW/Cbh2+FuZoMWFnqKe/caTfJoNSxo5u9/rYkjCQP00j+6kcBGnCEpt1tII/gQ2Y82H2g4+5yEswVeIz47d5/VihzuuXy4h3HVZKSEr6jK6u5P09uhkt46kGOK/CVuw2fPDiHTeChU19qLX0y5iHu7n3/pN0HYgewx
 s/IqOBiL
 mnZR85Wuak1zrdo4uD5I/wAagCQpCwqfpieg3kxJ8E4RxlpznPX+ymLfkfOANj2Dq8Blsuc7h5Tw2YUXe/rh9uOMS11p4Z7u6V1LFw3Gv3tMAV6RjqP78LSi/GVyfYyeXYw7LJ7lMs6S5pfj1uq7s0Dyg+8kAvJwWEULT3VuU5SqbKKo/cA78TDqnuzKRqbY/4OvR5FCplpKwQpR7ZKNpH3gzMm/ApPb3srRdKFAlehLh4pPX1J+9bQ+imrSLqoO8iRrnlL4hQc6g5Pt7bZRr6RmuogHBe+bWOxfkBZOTk5lYMz+fvMnjAJmjDYncEhDhYkyqrzhqE6u90CuFIslHEETZ2V4TEdkLCxBJTeJoMN8DEtWHS2aA+gh54YMP8Zyxu8vcTmcZvmlvKyd9LVF9UuU2Jq984wO/uPlDaAMlSpPIofG0zaEbiOxjaYj/fJ+LfPCCMMwvP/2RiOdy4kJ9FuZDi17DjD7iYJOIGPq3fGw9+jw1Zr+XQUCQyePFP8C9Dvuu8hyiDS7wpp58//AEkUR44mhfmoshxPiAHbWGUmBkSLTmJZUyaQwqR3KxwKpL3a/QPi7vdBjwzGHKbXsr1wWIPDOBY/575uLh2Vk0s42xsS6WNIBEn2GTJieWPgKvzn9hByJ15yplITa5JaXMv5R4fPJ7o4Sb3+ob
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] mm/hmm: dead range check in hmm_vma_capture_migrate_range() allows=
 partial VMA
- [High] mm/hmm: mmu_notifier_invalidate_range_start() held across hmm_do_f=
ault()
- [Medium] mm/hmm: hmm_vma_walk_test() captures VMA for migration before ch=
ecking vm_flags
--

commit ca535286660d47fc1830230d8f80c9d3e5f37db0
Author: Mika Penttil=C3=A4 <mpenttil@redhat.com>

mm/hmm: preparations for HMM to participate in migration

This commit prepares hmm_range_fault() to support page migration by saving
the resolved VMA and range during the page walk, rejecting lock-drop mode
when migrating, and invoking MMU notifier invalidations around the walk.

> diff --git a/mm/hmm.c b/mm/hmm.c
> index 2f1e98c6b6440..4e9542aedc253 100644
> --- a/mm/hmm.c
> +++ b/mm/hmm.c

[ ... ]

> @@ -400,6 +409,58 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk =
*walk, unsigned long start,
>  }
>  #endif  /* CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
> =20
> +static int hmm_vma_capture_migrate_range(unsigned long start,
> +					 unsigned long end,
> +					 struct mm_walk *walk)
> +{
> +	struct hmm_vma_walk *hmm_vma_walk =3D walk->private;
> +	struct hmm_range *range =3D hmm_vma_walk->range;
> +
> +	if (!hmm_select_migrate(range))
> +		return 0;
> +
> +	if (hmm_vma_walk->vma && (hmm_vma_walk->vma !=3D walk->vma))
> +		return -ERANGE;
> +
> +	hmm_vma_walk->vma =3D walk->vma;
> +
> +	if (end - start > range->end - range->start)
> +		return -ERANGE;

[Severity: High]
Can this condition in mm/hmm.c:hmm_vma_capture_migrate_range() ever be true?

In hmm_range_fault_locked() -> walk_page_range() ->
walk_page_range_mm_unsafe() -> walk_page_test() -> hmm_vma_walk_test(), the
walker clamps the VMA subrange to the requested walk bounds:

    start >=3D hmm_vma_walk.last >=3D range->start
    end =3D min(range->end, vma->vm_end) <=3D range->end

Because end - start is always less than or equal to range->end - range->sta=
rt,
this check never triggers.

If [range->start, range->end) starts with an unmapped hole (without
HMM_PFN_REQ_FAULT set on the hole entries), walk_page_range_mm_unsafe() cal=
ls
hmm_vma_walk_hole() for [range->start, vma->vm_start) and then invokes
hmm_vma_walk_test() with start =3D=3D vma->vm_start > range->start.

hmm_vma_capture_migrate_range() accepts this partial VMA and records
hmm_vma_walk->start =3D vma->vm_start, which hmm_vma_post_range_fault() wri=
tes
to range->migrate->start via hmm_fill_migrate_vma(). However, the page walk
callbacks index range->hmm_pfns[] relative to range->start:

    &range->hmm_pfns[(start - range->start) >> PAGE_SHIFT]

When migrate_hmm_range_setup() later reads range->hmm_pfns[0] for
migrate->start, the PFN array is misaligned with the virtual address range.
Additionally, if the entire [range->start, range->end) falls in an unmapped
hole without fault requests, hmm_vma_walk_test() is never called and
range->migrate->vma remains uninitialized.

Should this check instead verify that the single VMA covers the entire
requested range (for example, vma->vm_start > range->start ||
vma->vm_end < range->end), and should hmm_vma_walk_hole() reject holes when
hmm_select_migrate(range) is enabled?

> +
> +	if (!hmm_vma_walk->mmu_armed) {
> +		hmm_vma_walk->start =3D start;
> +		hmm_vma_walk->end =3D end;
> +		mmu_notifier_range_init_owner(&hmm_vma_walk->mmu_range, MMU_NOTIFY_MIG=
RATE, 0,
> +					      walk->vma->vm_mm, start, end,
> +					      range->dev_private_owner);
> +		mmu_notifier_invalidate_range_start(&hmm_vma_walk->mmu_range);
> +		hmm_vma_walk->mmu_armed =3D true;
> +	}
> +
> +	return 0;
> +}
> +
> +static void hmm_vma_post_range_fault(struct hmm_vma_walk *hmm_vma_walk)
> +{
> +
> +	struct hmm_range *range =3D hmm_vma_walk->range;
> +
> +	if (hmm_select_migrate(range) &&
> +	    hmm_vma_walk->mmu_armed) {
> +		/*
> +		 *  The migrate_vma path has the following initialized,
> +		 *  so take care of fault path below.
> +		 */
> +		if (range->notifier) {
> +			hmm_fill_migrate_vma(range,
> +					     hmm_vma_walk->vma,
> +					     hmm_vma_walk->start,
> +					     hmm_vma_walk->end);
> +		}
> +		mmu_notifier_invalidate_range_end(&hmm_vma_walk->mmu_range);
> +	}
> +}
> +
>  static int hmm_vma_walk_pmd(pmd_t *pmdp,
>  			    unsigned long start,
>  			    unsigned long end,
> @@ -594,6 +655,11 @@ static int hmm_vma_walk_test(unsigned long start, un=
signed long end,
>  	struct hmm_vma_walk *hmm_vma_walk =3D walk->private;
>  	struct hmm_range *range =3D hmm_vma_walk->range;
>  	struct vm_area_struct *vma =3D walk->vma;
> +	int r;
> +
> +	r =3D hmm_vma_capture_migrate_range(start, end, walk);
> +	if (r)
> +		return r;
> =20
>  	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)) &&
>  	    vma->vm_flags & VM_READ)

[Severity: Medium]
In mm/hmm.c:hmm_vma_walk_test(), is it intentional that
hmm_vma_capture_migrate_range() runs before validating vma->vm_flags?

When walk->vma has VM_IO or VM_PFNMAP set, or lacks VM_READ, calling
hmm_vma_capture_migrate_range() first records hmm_vma_walk->vma =3D walk->v=
ma
and invokes mmu_notifier_invalidate_range_start() on the unsupported VMA. If
hmm_range_need_fault() then returns 0, hmm_vma_walk_test() fills
range->hmm_pfns with HMM_PFN_ERROR and returns 1 (skipping the VMA), after
which hmm_vma_post_range_fault() populates range->migrate->vma with the
unsupported VMA.

Also, in the fault migration path where range->notifier is set and
migrate_vma_setup() is not used, nothing in hmm_vma_walk_test() or
hmm_vma_capture_migrate_range() rejects is_vm_hugetlb_page(vma),
(vma->vm_flags & VM_SPECIAL), or vma_is_dax(vma), which migrate_vma_setup()
rejects with -EINVAL. Should VMA eligibility for both HMM and migration be
verified before capturing the VMA and arming the MMU notifier?

[ ... ]

> @@ -694,19 +760,31 @@ static int hmm_range_fault_locked(struct hmm_range =
*range, bool *locked)
>  {
>  	struct hmm_vma_walk hmm_vma_walk =3D {
>  		.range =3D range,
> -		.locked =3D locked,
> +		.mmlocked =3D locked,
>  		.last =3D range->start,
>  	};
> -	struct mm_struct *mm =3D range->notifier->mm;
> +	/*
> +	 *  Could be serving a device fault or come from migrate
> +	 *  entry point. For the former we have not resolved the vma
> +	 *  yet, and the latter we don't have a notifier (but have a vma).
> +	 *
> +	 */
> +	struct mm_struct *mm =3D hmm_range_fault_mm(range);
>  	int ret;
> =20
> +	/* Migration is incompatible with mmap lock drop */
> +	if (locked && hmm_select_migrate(range))
> +		return -EINVAL;
> +
>  	mmap_assert_locked(mm);
> =20
>  	do {
>  		/* If range is no longer valid force retry. */
> -		if (mmu_interval_check_retry(range->notifier,
> -					     range->notifier_seq))
> -			return -EBUSY;
> +		if (range->notifier && mmu_interval_check_retry(range->notifier,
> +								range->notifier_seq)) {
> +			ret =3D  -EBUSY;
> +			break;
> +		}
>  		ret =3D walk_page_range(mm, hmm_vma_walk.last, range->end,
>  				      &hmm_walk_ops, &hmm_vma_walk);
>  		/*
> @@ -732,6 +810,8 @@ static int hmm_range_fault_locked(struct hmm_range *r=
ange, bool *locked)
>  		 * output, and all >=3D are still at their input values.
>  		 */
>  	} while (ret =3D=3D -EBUSY);
> +
> +	hmm_vma_post_range_fault(&hmm_vma_walk);
>  	return ret;
>  }

[Severity: High]
What happens in mm/hmm.c:hmm_range_fault_locked() when migration is enabled
(as activated in the subsequent commit "mm: enable device page migration fr=
om
HMM pagewalk") and a page in the range needs to be faulted in via
hmm_do_fault()?

On the first iteration of walk_page_range(), hmm_vma_walk_test() ->
hmm_vma_capture_migrate_range() calls mmu_notifier_invalidate_range_start()
and sets hmm_vma_walk->mmu_armed =3D true before any PTEs are inspected, wh=
ile
mmu_notifier_invalidate_range_end() is deferred until
hmm_vma_post_range_fault() after the entire do { ... } while (ret =3D=3D -E=
BUSY)
loop completes.

When walk_page_range() returns HMM_FAULT_PENDING, hmm_do_fault() ->
handle_mm_fault() runs inside the active mmu_notifier_invalidate_range_star=
t()
and mmu_notifier_invalidate_range_end() section:

1. Across sleeping page faults (such as swap/file I/O, reclaim, userfaultfd,
   or migrate_to_ram()), mm->notifier_subscriptions->active_invalidate_rang=
es
   remains elevated and invalidate_seq remains odd, preventing
   mn_itree_inv_end() from completing nested invalidations and blocking
   concurrent mmu_interval_read_begin() and mmu_interval_notifier_remove()
   callers on subscriptions->wq.

2. When range->notifier is non-NULL, any nested invalidation inside
   handle_mm_fault() (for example, wp_page_copy() on a write fault or
   remove_device_exclusive_entry()) or any notifier not filtered by
   range->dev_private_owner updates range->notifier->invalidate_seq via
   mmu_interval_set_seq(). When hmm_do_fault() returns -EBUSY to re-walk the
   newly faulted page, the next iteration of the loop hits
   mmu_interval_check_retry(range->notifier, range->notifier_seq) and aborts
   with -EBUSY.

3. Because mmu_notifier_invalidate_range_start() is only called once before
   faulting when !hmm_vma_walk->mmu_armed, any PTE faulted into a previously
   empty entry by hmm_do_fault() is subsequently unmapped and replaced with=
 a
   migration entry on the retry walk without a post-fault
   mmu_notifier_invalidate_range_start() notification.

Should the mmu_notifier_invalidate_range_start() and
mmu_notifier_invalidate_range_end() pair be scoped around the migration
unmapping step rather than held across the hmm_do_fault() loop?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021060506.2377=
545-1-mpenttil@redhat.com?part=3D3

