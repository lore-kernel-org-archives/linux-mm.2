Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF871606A329
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 18:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z4fR9ZJ3
Received: by kanga.kvack.org (Postfix)
	id 0D3706B05B8; Fri,  6 Nov 2026 13:43:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05CF86B05B9; Fri,  6 Nov 2026 13:43:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E408E6B05BA; Fri,  6 Nov 2026 13:43:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B56EC6B05B8
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:43:14 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2EC0A1401B6
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 18:43:14 +0000 (UTC)
X-FDA: 85405566708.24.5530CF5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9537540003
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 18:43:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z4fR9ZJ3;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793990592;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SR/Tk+nIbMEU0cvP77yTgIdCGmiBJLUKXWLkyc5XtN4=;
	b=umbd1JN6Pxi0aih/XPMslZDJZeagffm3CZ98TYbOXl7YYUJOu5Z8XAUbrasz3yuwywQx8H
	m1/4EUehgv6Bq9ruWi3UbDFcSRwVpRDu1Cc4+5/sY6pgIXfj71Hhz9HGFznpDzoSTOVYVv
	/gggExozN0ez6MlY+zaXkk9EAbweV2Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793990592;
	b=ks8kspk5EZxKSCRG0CcE9Ae8Hb6Id10WtAL0zZyXWv0uKC+RxZYZbzMKwpbMIzIHKRWfIo
	FGxA4588fBRQdp1yaH8yrHHXivBBZldYyeF85mK65mgiMXXU+rUUuhXztS+Zvk5J3riwm1
	efMNDkl1kaZg+bOkMGNa2KM/bzfqVzM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z4fR9ZJ3;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1E978605DA;
	Fri,  6 Nov 2026 18:43:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89E471F0089F;
	Fri,  6 Nov 2026 18:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793990591;
	bh=SR/Tk+nIbMEU0cvP77yTgIdCGmiBJLUKXWLkyc5XtN4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Z4fR9ZJ33HjvsNIS6xzbIu8R9SS25m1M88YWKiH8qk+owN682fo6N/PjSCEXE4OlK
	 nbo1+iJfbZ1AoJQHxSdWEiSWRfl0py0cJ9D+thuM9A8SAbch5lis/FyG2uSQe0dlki
	 tz9mqIhhAFjKb4g16PTwUU0+X80DZj2gtyB8zg3+lHRW+3SIDjXGnz8F7Ewnc8iDfL
	 NzYr3rlkARv/K1XINVInZZmsbwyNoGDisnoRRtYZyAUuibrrFxEcJjcKrpzLcyt2Nv
	 qUiREb+QHW8QuMmUgb3PCf+8kDtA1zsLfC2ZAEyqBpwmkYvd/WjxPqZJJ7VewQ2MB8
	 L/pKaa9TX23aw==
Message-ID: <sashiko-outbox-202083@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 28/32] mm: handle PMD swap entries in UFFDIO_MOVE
Reply-To: sashiko-reviews@lists.linux.dev
To: "Usama Arif" <usama.arif@linux.dev>, "Andrew Morton" <akpm@linux-foundation.org>, david@kernel.org, chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org
Cc: chenhuacai@kernel.org, ying.huang@linux.alibaba.com, "Baoquan He" <baoquan.he@linux.dev>, willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org, baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com, "Nico
 Pache" <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com, "Vlastimil
 Babka" <vbabka@kernel.org>, lance.yang@linux.dev, nphamcs@gmail.com, shikemeng@huaweicloud.com, yosry@kernel.org, qi.zheng@linux.dev, luizcap@redhat.com, kernel-team@meta.com
In-Reply-To: <20261105183940.2236717-29-usama.arif@linux.dev>
References: <20261105183940.2236717-1-usama.arif@linux.dev>
 <20261105183940.2236717-29-usama.arif@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 18:43:09 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: rrdffmqgxdkhq88i74zbyowgs5ksq6qa
X-Rspamd-Queue-Id: 9537540003
X-Rspam-User: 
X-HE-Tag: 1793990592-756958
X-HE-Meta: U2FsdGVkX19Ads7b+97DfotL1DfUyEfbFcLCTGTC5OPSdM02uDjpU6vfHeUNAYIlkKhLj2As0HKdQ85qps4ZX554b1YkghWsdbZ0pKmLgo7DxhqhB/NAGghrneWsR3INyCsQRxjnbpmtIxsmW+b8ev3PpfcA21bdt95LfIPcF04czJ0uZP13MyGpgJPOs/oEDPDSgLOkOtw/2OQ2U1yu75gZdWdUIhWeoGRVW3UScLovEA7315++H8H+wOcPqaDuzz8xFHakNn7Av0hm8ydCTyaPylPoa8cdKDaEQ99nghe2aQpxhZVRF//t5hULNZWBlUgPBbNHycMxrU/1rsseuitZUlSit15hKirXg2n294tRlvacRnYVe3veg4ErUkvVrqCPsnvc1YJ3hFhADggrecK3MCX8D796KTUR8Bc5bVFh4fuu56hCkgei2K0r/Msaztuk3NsHaZtHxaZM2FD3R9K1v/t6TedJtuPwuxOhLr99UDAHfkG6c7qOFi3Su8MdxbzSF0HMzjc8onzHHxqUj+MP5KgvY+Y4JyI/gHl5oZob4N5dEQPz7PTBNYJ3T4x4GmZZUJS2XHtsrm+rTdOURn+fOui6nvNYzOWvPM7qMy+MRnK4IA3LmpA7mKsgbKT04XNZU3xWMXAS1W0Lu93tK8Ak92d01+YtlPa8xhAvRmfgJhdRQi98vHhnk7pTosoWl5C/10e56zhAevUWoCSRm+NZkQRNU6IC9JgyfmdaPd2rsTosi+DPQNd44cBsxTbvdOKYqhNGos47J4DxDeoRy/2zxYGqJbr7xxbQmzCpa6UZzHkyAfBuBdeY5c0357Cxvxuj9jA8017L2zcW5luU1zpgQW3OTBksoXAIkBXvhwEZLyg2O9D1NyYxkipfvpE8Py4BPQKNWOT1mHP/dbanjHFQ7jbjVqJ3jEEwyWZMMzYVHElEjpTCoby/1vMOD6sZpI899tx0+Nz0450Sefu
 hfdManM8
 s5eqRsh9iN91RF77d1loTBN9HgDDCxRW3GORJNXFLv4b+FlPJ4BsG5n6fLcQHXwgqLqbCuqBeo9lRDJ8vmU9dw8bVdVFyZ+1LzWazGU1VApwVC/Xes1wFGjcQHOELqMySLBiwhj4LfbRWj4SkGS/y0qBbaHR3wu8AVne519cMbtjoZN1B7F7Ny4Cy7/G0+O2RkpPk7zSQZKZlZgOWwJNNkp2uSfwmnTKOlG3tdSa29025PQfCvuabUCVz9Wk6rzBiGA//jlvmg5Wr87YOv3ssDvx46dkhcVfDSTelz0x4OBwUtN8c0B3SW77ND/Vw8QUp7LjQxpjS+n1O0B5FsYKl8ORmK3MR5J2Ug4/67GYRi5Xy234btheORqbr+sNEvtzVZtgjEvF6jDlD1xMl9ts88+/xzAqZgew2bZ3D6slM8Mcs37Hso5PuqfdA3bdGkMahxR7hBSULjKhStb73WDZULIt1DZkbmEkKhFDpKpP5XuYvhW/SiEyFOSHjMnMBh5Cyx3EBCWX2dflFCXh3iLaRDXtmWJMLFQPe6eOOJlsSsQMLSZ3mWEbvWSVdu7LxrcUMo7L+D0FND42lqKXX+ZwL5JVEvM8aEY9Tuk1sK1Ynrdjptp8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Medium] mm: move_swap_pmd() sets anon rmap on unmapped swap-cache
  folios
- [Medium] mm: move_pages_huge_pmd() drops src_ptl before swap lookup
  and split
- [Medium] mm: move_pages() splits PMD swap entries before checking
  movability
--

commit 0e469173a6b536c3bd6b664124f92ddaf042afb0
Author: Usama Arif <usama.arif@linux.dev>

mm: handle PMD swap entries in UFFDIO_MOVE

This commit adds support for moving PMD-level swap entries in UFFDIO_MOVE v=
ia
a new move_swap_pmd() helper in move_pages_huge_pmd(), while rejecting PMD
swap entries at the destination in move_pages() with -EEXIST.

> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 65922d9e4bec1..e02a885ea1d0b 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2938,6 +2938,79 @@ int change_huge_pud(struct mmu_gather *tlb, struct=
 vm_area_struct *vma,
>  #endif
> =20
>  #ifdef CONFIG_USERFAULTFD
> +#ifdef CONFIG_THP_SWAP
> +/*
> + * Move a PMD-level swap entry from src_pmd to dst_pmd. Both PMD locks a=
re
> + * acquired here; src_folio (if present) must already be locked. The dep=
osited
> + * page table backing the source THP is moved across with the entry.
> + */
> +static int move_swap_pmd(struct mm_struct *mm, struct vm_area_struct *ds=
t_vma,
> +			 unsigned long dst_addr, unsigned long src_addr,
> +			 pmd_t *dst_pmd, pmd_t *src_pmd,
> +			 pmd_t orig_dst_pmd, pmd_t orig_src_pmd,
> +			 spinlock_t *dst_ptl, spinlock_t *src_ptl,
> +			 struct folio *src_folio, swp_entry_t entry)
> +{

[ ... ]

> +	if (src_folio) {
> +		folio_move_anon_rmap(src_folio, dst_vma);
> +		src_folio->index =3D linear_anon_page_index(dst_vma, dst_addr);

[Severity: Medium]
Can src_folio be a newly allocated swap-cache folio that has not yet been
marked anonymous with folio_add_new_anon_rmap()?

If a swapped-out THP had its folio evicted from the swap cache and a fresh
PMD-order folio was subsequently allocated into the swap cache (for example,
via MADV_WILLNEED in swapin_walk_pmd_entry() -> swapin_pmd_swap_entry() ->
swapin_sync() -> __swap_cache_alloc_folio(), or a racing swap-in fault befo=
re
the folio is mapped), src_folio->mapping is still NULL
(!folio_test_anon(src_folio)).

Calling folio_move_anon_rmap(src_folio, dst_vma) unconditionally in
move_swap_pmd() writes dst_vma->anon_vma + FOLIO_MAPPING_ANON into
src_folio->mapping without going through folio_add_new_anon_rmap():

mm/rmap.c:folio_add_new_anon_rmap() {
	...
	__folio_mod_stat(folio, nr, nr_pmdmapped);
	mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON, 1);
}

When the folio is later freed, free_pages_prepare() sees
folio_test_anon(folio) and decrements MTHP_STAT_NR_ANON without a matching
increment:

mm/page_alloc.c:free_pages_prepare() {
	...
	if (folio_test_anon(folio)) {
		mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
		folio->mapping =3D NULL;
	}
}

Stamping FOLIO_MAPPING_ANON early also defeats the !folio_test_anon(folio)
checks in unuse_pmd_entry(), do_huge_pmd_swap_page(), and do_swap_page() th=
at
delete newly allocated swap-cache folios on PTE fallback or read failure:

mm/swapfile.c:unuse_pmd_entry() {
	...
	if (ret && folio_matches_swap_entry(folio, entry) &&
	    (!folio_test_uptodate(folio) || !folio_test_anon(folio)))
		swap_cache_del_folio(folio);
}

Should move_swap_pmd() check folio_test_anon(src_folio) before calling
folio_move_anon_rmap() and updating src_folio->index?

[ ... ]

> @@ -2972,11 +3045,95 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd=
_t *dst_pmd, pmd_t *src_pmd, pm
>  	}
> =20
>  	if (!pmd_trans_huge(src_pmdval)) {
> -		spin_unlock(src_ptl);
>  		if (pmd_is_migration_entry(src_pmdval)) {
> +			spin_unlock(src_ptl);
>  			pmd_migration_entry_wait(mm, src_pmd);
>  			return -EAGAIN;
>  		}
> +#ifdef CONFIG_THP_SWAP
> +		if (pmd_is_swap_entry(src_pmdval)) {
> +			swp_entry_t entry;
> +			struct swap_info_struct *si;
> +			enum swap_pmd_cache cache_state;
> +
> +			/*
> +			 * UFFDIO_MOVE on anon mappings requires single-owner
> +			 * semantics; refuse to move a shared swap entry.
> +			 */
> +			if (!pmd_swp_exclusive(src_pmdval)) {
> +				spin_unlock(src_ptl);
> +				return -EBUSY;
> +			}
> +
> +			entry =3D softleaf_from_pmd(src_pmdval);
> +			spin_unlock(src_ptl);
> +
> +			/*
> +			 * Pin the swap device against a racing swapoff. NULL
> +			 * means swapoff is in progress, which resolves on its
> +			 * own, so ask the caller to retry. An error pointer
> +			 * means the entry names no swap device at all: that
> +			 * never resolves, so report it instead of spinning in
> +			 * the caller's -EAGAIN loop.
> +			 */
> +			si =3D get_swap_device(entry);
> +			if (!si)
> +				return -EAGAIN;
> +			if (IS_ERR(si))
> +				return PTR_ERR(si);
> +
> +			src_folio =3D NULL;
> +			cache_state =3D swap_pmd_cache_lookup(entry, &src_folio);
> +			if (cache_state =3D=3D SWAP_PMD_CACHE_SPLIT) {
> +				put_swap_device(si);
> +				__split_huge_pmd(src_vma, src_pmd, src_addr);
> +				return -EAGAIN;
> +			}

[Severity: Medium]
What happens if src_pmd changes after spin_unlock(src_ptl) before
get_swap_device(), swap_pmd_cache_lookup(), and __split_huge_pmd() run in
move_pages_huge_pmd()?

Because src_ptl is released before calling get_swap_device(entry) and
swap_pmd_cache_lookup(entry, &src_folio), and __split_huge_pmd() is called
without verifying that src_pmd still matches src_pmdval:

1. A racing swap-in fault, MADV_WILLNEED, or swapoff can swap the THP back =
in
   (making src_pmd a present THP) or populate a PMD-sized swap-cache folio
   while those swap slots are reused or partially populated as order-0 foli=
os.
   If swap_pmd_cache_lookup() then sees SWAP_PMD_CACHE_SPLIT,
   move_pages_huge_pmd() unconditionally calls __split_huge_pmd(src_vma,
   src_pmd, src_addr), shattering a present THP (whose folio will then be
   split in move_pages_ptes() on retry) or splitting a PMD swap entry backed
   by a PMD-sized swap-cache folio so the retry in move_pages_ptes() fails
   with -EBUSY.

2. A racing swapoff followed by swapon of a smaller swap device on the same
   swap type can complete after spin_unlock(src_ptl) and before
   get_swap_device(entry), causing get_swap_device() to log a false "Bad sw=
ap
   offset" error and return ERR_PTR(-EIO), failing UFFDIO_MOVE with -EIO
   instead of retrying.

By comparison, swapin_pmd_swap_entry() in mm/madvise.c performs
swap_pmd_cache_lookup() and get_swap_device() while still holding the PMD
lock, and swapin_walk_pmd_entry() rechecks pmd_same() before calling
__split_huge_pmd():

mm/madvise.c:swapin_pmd_swap_entry() {
	...
	cache_state =3D swap_pmd_cache_lookup(entry, &folio);
	...
	si =3D get_swap_device(entry);
	spin_unlock(ptl);
}

Could move_pages_huge_pmd() keep src_ptl held across get_swap_device() and
swap_pmd_cache_lookup(), and split under src_ptl via split_huge_pmd_locked()
(or recheck pmd_same() before splitting)?

[ ... ]

> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 8cff0f820ca51..38b63e9cff62d 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -2072,6 +2072,20 @@ static ssize_t move_pages(struct userfaultfd_ctx *=
ctx, unsigned long dst_start,
>  			break;
>  		}
> =20
> +		/*
> +		 * A PMD swap entry at dst is a swapped-out THP, not a hole,
> +		 * and unlike a PMD migration entry it will not resolve on its
> +		 * own. Nothing below faults it back in: pte_alloc() skips a
> +		 * !pmd_none PMD, pte_offset_map_rw_nolock() then fails on the
> +		 * non-present PMD, and the -EAGAIN that produces would be
> +		 * retried forever by the loop below. Be strict, exactly as for
> +		 * a present THP.
> +		 */
> +		if (unlikely(pmd_is_swap_entry(dst_pmdval))) {
> +			err =3D -EEXIST;
> +			break;
> +		}
> +
>  		ptl =3D pmd_trans_huge_lock(src_pmd, src_vma);
>  		if (ptl) {
>  			/* Check if we can move the pmd without splitting it. */

[Severity: Medium]
When move_splits_huge_pmd() or !pmd_none(dst_pmdval) is true in move_pages(=
),
doesn't the fallback path unconditionally call split_huge_pmd() on a source
PMD swap entry before checking whether the resulting PTE swap entries can be
moved?

In mm/userfaultfd.c:move_pages(), the split branch only checks exclusivity
when pmd_present(*src_pmd) is true:

mm/userfaultfd.c:move_pages() {
	...
	if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len) ||
	    !pmd_none(dst_pmdval)) {
		/* Can be a migration entry */
		if (pmd_present(*src_pmd)) {
			struct folio *folio =3D pmd_folio(*src_pmd);

			if (!is_huge_zero_folio(folio) &&
			    !PageAnonExclusive(&folio->page)) {
				spin_unlock(ptl);
				err =3D -EBUSY;
				break;
			}
		}

		spin_unlock(ptl);
		split_huge_pmd(src_vma, src_pmd, src_addr);
		/* The folio will be split by move_pages_pte() */
		continue;
	}
}

If *src_pmd is a PMD swap entry and UFFDIO_MOVE is called with a sub-PMD
length, an unaligned address, or a destination PMD that already has an empty
PTE page table (!pmd_none(dst_pmdval)):

1. If !pmd_swp_exclusive(*src_pmd), split_huge_pmd() shatters the shared PMD
   swap entry into PTE swap entries before move_pages_ptes() rejects them
   with -EBUSY.

2. If *src_pmd is exclusive and backed by a PMD-sized folio in the swap cac=
he
   (SWAP_PMD_CACHE_HUGE), split_huge_pmd() shatters the PMD swap entry into
   PTE swap entries that still point to the large swap-cache folio. On the
   next iteration, move_pages_ptes() immediately fails with -EBUSY because
   folio_test_large(folio) is true:

mm/userfaultfd.c:move_pages_ptes() {
	...
	if (folio) {
		if (folio_test_large(folio)) {
			ret =3D -EBUSY;
			folio_put(folio);
			goto out;
		}
}

That leaves src_pmd permanently split into PTE swap entries that even a
subsequent PMD-aligned UFFDIO_MOVE cannot move while the large folio remains
in the swap cache.

Should move_pages() check pmd_is_swap_entry(*src_pmd) before splitting, and
refuse with -EBUSY if !pmd_swp_exclusive(*src_pmd) or if the swap cache hol=
ds
a large folio?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105183940.2236=
717-1-usama.arif@linux.dev?part=3D28

