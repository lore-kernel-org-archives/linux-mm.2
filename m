Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EBAB606A329
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 20:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JsiJfY7M
Received: by kanga.kvack.org (Postfix)
	id 023236B05B9; Fri,  6 Nov 2026 15:58:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3C226B05BA; Fri,  6 Nov 2026 15:58:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7F876B05BB; Fri,  6 Nov 2026 15:58:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE6826B05B9
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:58:08 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 50AB940203
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 20:58:08 +0000 (UTC)
X-FDA: 85405906656.13.585CD59
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id B9D8514000D
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 20:58:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JsiJfY7M;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793998686;
	b=zbg+vShAVjZ4l/IfoazAj36kAoGtSS0+l88DCI6i3xPQsNTsK0yJPdZetfSyw4zkK0QOPI
	KhdOu2yCpdA7L85G519SyxZ9ZpnOOKFiiKxCR4L3JE8KFKurgjEw00zMVhKdV2N2ArmRI5
	nbrCRAnsiIZIOZglnisZKM8WjURfF5s=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JsiJfY7M;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793998686;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XhP7iSuH+CSHvQSXlTXioMgVpRPpR1Fm9xpPUME+C6s=;
	b=6lQkyhxirRVpguMCJI8IH6kWBXy3+K2AdEY6QBk4o5bND5g5/NJ7IYp1e1jmck6Lg/cNo8
	zVcAU619r/c24LIocUEXBW4/0LLS8m6Jxc6dmFyb17aeEeTcaEdkn4hRMkSZPr3LvSN2l+
	fh5xH7pNXPPM8R/z9vAECMVoHvNFj+8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5310560145;
	Fri,  6 Nov 2026 20:58:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6794B1F008A2;
	Fri,  6 Nov 2026 20:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793998686;
	bh=XhP7iSuH+CSHvQSXlTXioMgVpRPpR1Fm9xpPUME+C6s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JsiJfY7MIXZHzaQCprlm+CSmEvLROEMhzWczwMxjVLWmDXvR659RrenIC2+uyg/lL
	 6bpTCE4hW3Rggi/liOIFh4GGCEY3JwaB6L8v0WNtjx//UKQA6UinttzlkjJ+Aaf8mK
	 5Lok0h0XOcuj34rBnloa7ZDlNdrGCjoA+7ApkVOyMu/bQtPNIP3IxJZS9H53Pitpn2
	 td7Xpl5IvNyF21TRe0p3ltXx/BGjW66GRqZPNWvyHCZ0s+KZQB2n7bmex/We/qRUVq
	 BdreymjKl9zePqXNJsDrOhs2TG3Pofzwk6WFXo4Der9EecXogyXS7UDqA4GUWlfuvi
	 Rb7BPGHtKnXow==
Message-ID: <sashiko-outbox-202266@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/3] mm/khugepaged: release contended mmap read lock
 after scanning enough VMAs
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "Zi Yan" <ziy@nvidia.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Liam
 R. Howlett" <liam@infradead.org>, "Nico Pache" <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance
 Yang" <lance.yang@linux.dev>, "Usama Arif" <usama.arif@linux.dev>, "Kiryl
 Shutsemau" <kas@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
In-Reply-To: <20261105-khugepaged-latency-fix-v2-3-4384bbfe4606@kernel.org>
References: <20261105-khugepaged-latency-fix-v2-0-4384bbfe4606@kernel.org>
 <20261105-khugepaged-latency-fix-v2-3-4384bbfe4606@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 20:58:05 +0000
X-Stat-Signature: ws3hrftcpcyozzanypkrf5et49mghaoe
X-Rspamd-Queue-Id: B9D8514000D
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793998686-785909
X-HE-Meta: U2FsdGVkX1+QXXIvwQfrsBzWAkhCfI2/BUbiQkiwNu5l0dAh4P8c/WBGWvwdHev/q2NWt2l1pM4pXas/uf8E2tPd3g112FVbntVZQK+HvzJiem6WlP6WvuOaj/FqI8OgguZchyMGsR6+SN5zNULN0qMQDOqCy18Da9egls4xIpWjVXQy+0Wd4VFsEr6iqEOYbb25mPVDZiRSBkr4jT7XvBqusQQBqZvJ+q79zWBCAGOyaDkOjc/LGPIFoGE/aPAIjTxQJDok6mLDXq9SWPXzPP5iLzQFqx13BDdx0yVa/4jEtSlX7DnyupZ878Gu2d4BsYisHSobqCR5cUOZVgSfAQD0qWm7uCf3plyWGCUARNWjI/4OKttRH8/e/xR4rUXKloRrbUw1zWBaqnJsd2VgmwuK5x9x7Eb9dY6oVMfsADH2BRBkKGLUCyz5NH9U9s6bHr9CuTksUa+aTMb/N8PoD+TYySPa1OAaI8+0NDsurw+2KUlPH+lgSsMwbjL/quTnfEiRHRXnPVGgIn7c4gPYVgxBcejYNTKCl5taDiIhvEQc8bt0obHSEd3m6lqjFoanl2P2iWs/0w1AXi6yiqYgc/0JUgWYRlPs39CDAhv/+DXa3iv87mLLwc2dTsvbBys3P75d8xeW81X9mMOAcNFTKNRUnB0GwyhXhLjCg3Dccak55jaPaJHdVZtEYLPJ+aepe4j0SiiB2l47Q/Wq/B+11CXP0DthLDSwwW93a+TaUhgUvbWxPUWsLJeY9jVsTzizkakbgQO65o+W5ovTdDLHOtu/866JfejI+9wUZWFo3y5BL0E0hgSFmry1+NSFrKGQG0v2bdWrAN99E0MsQ+Vqbhx8E0GYmYdVC9Nlx3esnuZeXZjpHC8/tF7/zamGJyI3TTBMvEjIONMAwXN5DHOiLT/LZb6SdF1L3r+hOSCYxbICTdvK6cCQkONa+gwWX5TT36Zqhk1u4ijZSxQlGAI
 aWCRWZUu
 +DUNV6jjWP3Snc77qjNj/eRlT8Z6as/TqGBv74GnJIiAyL/qMAP6dZiOMX12GQ7KzwFRyDDR5LwWRyEIX9lischF6CY+YuV+Inz4H/xpLN3r1/pQkfenWAG7pQU/DUcI5TsS90TA/mMMgJHZGdPriqGzwBNQN2Eh8wvN2Gfk+c/BOi1JWmL4DobxxMgf4zE5hJGiOYMdKyXYaArczH4Jl9kXipcjHFjyCxfP9wMuo0cowleaNjsygS5kdjE8TpdX4GgGfi1uKNFuyvJjVc1dIl8eoYxjXP4MluDLgXM3P55Zpb7ZnnZRnGcdwznIhVFBSyoowv0m4ECO194vvTPoX/6AmcCAUvEdwj8lDNjLbMht8t77MG9sNLwlPfQES98GFl3FhMoZ62Esy8Q/l9Fy0l0hQ+IyGCB5SKQsFz7P6otb2jTo1jrjKa6rc0KZCdk8GYnI5Y2DBbvrh+dEHa0lIV9vDhgfnI+JEa192rJTrCHyfwmmv4O12sY7+v3jGbt+9MJNZyNsWXUr4J9JEtb6Quz94FteNlx9/rjpFRBBuYbyxCTG3D7yYsZ1kSz/YhLxRnBOuwwZexM1IamFBuOo/CzzTseQPD55FWTDDc8gVo4ePqyRUA2dGFEIjE9KIErAz1D6h
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [High] mm/khugepaged: lack of forward progress in
  collapse_scan_mm_slot()
- [Medium] mm/khugepaged: sub-PMD mTHP VMAs bypass cursor advance and
  overflow check
--

commit 9bc41c7859cdd4759479e883a9c557ea64a1a2c7
Author: Lorenzo Stoakes (ARM) <ljs@kernel.org>

mm/khugepaged: release contended mmap read lock after scanning enough VMAs

This commit periodically checks whether mmap_lock is contended in
collapse_scan_mm_slot() after scanning a batch of VMAs, dropping and
re-acquiring the read lock and resetting the VMA iterator to
mm_slot->address. It also checks for unsigned long overflow when aligning
vma->vm_end for ineligible VMAs.

> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 216c4b8d28c40..eaa01dae5a030 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -66,6 +66,12 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_hash, MM_=
SLOTS_HASH_BITS);
> =20
>  static struct kmem_cache *mm_slot_cache __ro_after_init;
> =20
> +/*
> + * The number of VMAs to walk before checking for, and relieving, mmap l=
ock
> + * contention, as a function of the pages_to_scan budget.
> + */
> +#define KHUGEPAGED_MAX_VMA_SCAN_BATCH(pages_to_scan) ((pages_to_scan) / =
4)
> +
>  /**
>   * struct khugepaged_mm_slot - khugepaged information per mm that is bei=
ng scanned
>   * @slot: hash lookup from mm to mm_slot
> @@ -2910,6 +2916,7 @@ static void collapse_scan_mm_slot(unsigned int prog=
ress_max,
>  	struct mm_struct *mm;
>  	struct vm_area_struct *vma;
>  	unsigned int progress_prev =3D cc->progress;
> +	unsigned int nr_vmas_batch =3D 0;
> =20
>  	lockdep_assert_held(&khugepaged_mm_lock);
>  	*result =3D SCAN_FAIL;
> @@ -2942,15 +2949,35 @@ static void collapse_scan_mm_slot(unsigned int pr=
ogress_max,
>  	for_each_vma(vmi, vma) {
>  		unsigned long hstart, hend;
> =20
> +		/* Relieve mmap lock contention after walking a batch of VMAs. */
> +		if (nr_vmas_batch++ >=3D KHUGEPAGED_MAX_VMA_SCAN_BATCH(progress_max)) {
> +			nr_vmas_batch =3D 0;
> +			if (mmap_lock_is_contended(mm)) {
> +				mmap_read_unlock(mm);
> +				cond_resched();
> +				mmap_read_lock(mm);
> +				vma_iter_set(&vmi, mm_slot->address);
> +				continue;
> +			}
> +		}

[Severity: High]
Can collapse_scan_mm_slot() fail to make forward progress here when
mmap_lock is contended?

In pages_to_scan_store(), khugepaged_pages_to_scan can be set to any positi=
ve
value:

mm/khugepaged.c:pages_to_scan_store() {
	err =3D kstrtouint(buf, 10, &pages);
	if (err || !pages)
		return -EINVAL;

	khugepaged_pages_to_scan =3D pages;
}

When khugepaged_pages_to_scan (passed as progress_max) is 1, 2, or 3,
KHUGEPAGED_MAX_VMA_SCAN_BATCH(progress_max) evaluates to 0. Because the bat=
ch
check runs at the top of the for_each_vma() loop before
collapse_test_exit_or_disable(mm) or any VMA handling, nr_vmas_batch++ >=3D=
 0
triggers on the first VMA before any VMA is scanned. If mmap_lock_is_conten=
ded()
is true, it resets nr_vmas_batch to 0, drops and re-acquires mmap_read_lock=
(mm),
rewinds vmi to the unchanged mm_slot->address, and executes continue without
advancing mm_slot->address, incrementing cc->progress, or checking
collapse_test_exit_or_disable(mm).

Even when progress_max >=3D 4, for an eligible VMA whose vm_end is not alig=
ned
to HPAGE_PMD_SIZE:

mm/khugepaged.c:collapse_scan_mm_slot() {
		hstart =3D ALIGN(vma->vm_start, HPAGE_PMD_SIZE);
		hend =3D ALIGN_DOWN(vma->vm_end, HPAGE_PMD_SIZE);
		if (mm_slot->address > hend) {
			cc->progress++;
			continue;
		}
		if (mm_slot->address < hstart)
			mm_slot->address =3D hstart;
		...
		while (mm_slot->address < hend) {
			...
			mm_slot->address +=3D HPAGE_PMD_SIZE;
			...
		}
}

Once the inner loop finishes (or if hstart =3D=3D hend), mm_slot->address i=
s left
at hend, which is less than vma->vm_end and still lies inside that VMA. If =
the
batch contention check triggers at the start of the next VMA (for example w=
hen
progress_max is 4..7 so the batch threshold is 1), vma_iter_set(&vmi,
mm_slot->address) rewinds the iterator back to the previous VMA where
mm_slot->address =3D=3D hend, which then does no work and neither advances
mm_slot->address nor increments cc->progress.

> +
>  		cond_resched();
>  		if (unlikely(collapse_test_exit_or_disable(mm))) {
>  			cc->progress++;
>  			break;
>  		}
>  		if (!collapse_possible_orders(vma, vma->vm_flags, TVA_KHUGEPAGED)) {
> -			/* Unable to collapse, skip to the next candidate. */
> -			mm_slot->address =3D ALIGN(vma->vm_end, HPAGE_PMD_SIZE);
> +			const unsigned long next =3D
> +				ALIGN(vma->vm_end, HPAGE_PMD_SIZE);
> +
>  			cc->progress++;
> +			/* Check for overflow. */
> +			if (unlikely(next < vma->vm_end)) {
> +				vma =3D NULL;
> +				break;
> +			}
> +			/* Unable to collapse, skip to the next candidate. */
> +			mm_slot->address =3D next;
>  			continue;
>  		}
>  		hstart =3D ALIGN(vma->vm_start, HPAGE_PMD_SIZE);

[Severity: Medium]
As reported by Sashiko on v1 [1], what happens if an anonymous VMA does not
span a full PMD (so hstart >=3D hend), but sub-PMD anonymous mTHP orders are
enabled?

In collapse_possible_orders(), anonymous VMAs are checked against
THP_ORDERS_ALL_ANON:

mm/khugepaged.c:collapse_possible_orders() {
	if ((tva_flags =3D=3D TVA_KHUGEPAGED) && vma_is_anonymous(vma))
		orders =3D THP_ORDERS_ALL_ANON;
	else
		orders =3D BIT(HPAGE_PMD_ORDER);

	return thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
}

A faulted-in anonymous VMA that is smaller than HPAGE_PMD_SIZE (or does not
span a full PMD) will return non-zero from collapse_possible_orders() when a
sub-PMD order is enabled, skipping the !collapse_possible_orders() block:

1. If the VMA starts at or straddles a PMD boundary (so hstart =3D=3D hend)=
, it
   sets mm_slot->address =3D hstart (< vma->vm_end), skips the inner while
   (mm_slot->address < hend) loop without incrementing cc->progress, and
   leaves mm_slot->address inside the VMA, so vma_iter_set(&vmi,
   mm_slot->address) will rewind back to this VMA on contention.

2. On architectures where user mappings can reach the top incomplete PMD ra=
nge
   above ULONG_MAX - HPAGE_PMD_SIZE + 1 (such as 64-bit s390 where TASK_SIZE
   is -PAGE_SIZE), a sub-PMD anonymous VMA with vm_start > ULONG_MAX -
   HPAGE_PMD_SIZE + 1 bypasses the next < vma->vm_end overflow check above.
   Then hstart =3D ALIGN(vma->vm_start, HPAGE_PMD_SIZE) wraps to 0 while he=
nd =3D
   ALIGN_DOWN(vma->vm_end, HPAGE_PMD_SIZE) is ULONG_MAX - HPAGE_PMD_SIZE + =
1,
   causing the while (mm_slot->address < hend) loop to run from address 0 w=
ith
   the wrong VMA and rewind mm_slot->address.

Should the hstart >=3D hend case also advance mm_slot->address to
ALIGN(vma->vm_end, HPAGE_PMD_SIZE) with the overflow check before computing
hstart?

[1] https://lore.kernel.org/r/20261103-khugepaged-latency-fix-v1-5-a07ab16a=
c860@kernel.org

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-khugepaged=
-latency-fix-v2-0-4384bbfe4606@kernel.org?part=3D3

