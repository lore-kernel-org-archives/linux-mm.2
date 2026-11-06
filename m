Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83B37606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 18:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J4qmlh1+
Received: by kanga.kvack.org (Postfix)
	id 911036B05B4; Fri,  6 Nov 2026 13:43:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C1096B05B8; Fri,  6 Nov 2026 13:43:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B18A6B05B9; Fri,  6 Nov 2026 13:43:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E6B806B05B4
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:43:11 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 85CA1A019A
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 18:43:11 +0000 (UTC)
X-FDA: 85405566582.30.228634C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id E9256140008
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 18:43:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J4qmlh1+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793990590;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4VXNhdVB1zPb/1iHJuZxMDgL4Pk8lsL6uSz8sbk2F68=;
	b=e5jy4N9loYpz0q+mNt4xM94hNLmB0jXiHFhyDgll7RiY/5jJ4TOCRvd60d/SYruzF3L0m5
	QMRcGvOomeIxx2JcIbxu9teqeDNBRaQE55O20F34MeEtvnWXzm107Kz6zLF6lzP2eQG3VC
	7ZN8BSMEB+TtAWxYDggCStd7Xgj9b+w=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J4qmlh1+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793990590;
	b=bxF2kiPGmZtjYt5yjIvGaOvTUVVsHqKqYO0cdKztwUl8yH+oxs1LHu1ymA7uAPcchoVJZr
	jn7xfGl/w9K0RQTv90G+ElFRrrOo+vwD131oaESApkL+uwPHmljpqF9wTM2Ru15ZdagSy3
	Kf3aK1dQhqzOHf+Qsgk+x8F/6HU2eJ8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5C37C60145;
	Fri,  6 Nov 2026 18:43:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C751F0089F;
	Fri,  6 Nov 2026 18:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793990589;
	bh=4VXNhdVB1zPb/1iHJuZxMDgL4Pk8lsL6uSz8sbk2F68=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=J4qmlh1+PKFdvdFh0DBOHUVGg4hxbDsHM9dZtfhAYLGrqu8X+HHkucGav4cZaGfoC
	 7nvhZBUvQ5QWHMrnW7T5LRcXHdrd+VLt8aqdBXAyfTjbjH5xTmIin64nuk6v3jJhxS
	 iXprNvAEHTdp5+oDYcmdPHdAYD6G5y3hi5kRB2w3hEf1s93/G+zgdwneDziZcB6l1w
	 KhOAmFATa2uV631VurMQGPgANxg3wrAi/EIeCxpuSLNu+7ztV8E9nM/CQbKzwbl0zg
	 Mt+CH7CpNJdKhL9vsbJSfrhlXFTgY52hmULGe7wQR6MnXFXBt+wi1C1G2PvEgt9//E
	 Pc5O0493djmZA==
Message-ID: <sashiko-outbox-202082@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 27/32] mm: handle PMD swap entries in MADV_WILLNEED
Reply-To: sashiko-reviews@lists.linux.dev
To: "Usama Arif" <usama.arif@linux.dev>, "Andrew Morton" <akpm@linux-foundation.org>, david@kernel.org, chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org
Cc: chenhuacai@kernel.org, ying.huang@linux.alibaba.com, "Baoquan He" <baoquan.he@linux.dev>, willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org, baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com, "Nico
 Pache" <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com, "Vlastimil
 Babka" <vbabka@kernel.org>, lance.yang@linux.dev, nphamcs@gmail.com, shikemeng@huaweicloud.com, yosry@kernel.org, qi.zheng@linux.dev, luizcap@redhat.com, kernel-team@meta.com
In-Reply-To: <20261105183940.2236717-28-usama.arif@linux.dev>
References: <20261105183940.2236717-1-usama.arif@linux.dev>
 <20261105183940.2236717-28-usama.arif@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 18:43:07 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E9256140008
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 543sa7guejac9q4n8y7kw4ixxfe6fnct
X-HE-Tag: 1793990589-646293
X-HE-Meta: U2FsdGVkX19BAoH0pmJC+EVBjQ31i0Kcy9OHhjxY6Kx3U3UeQrqMjnz6bkdXhVwawOgQAem6lsnTURxqCU6Hv7s4ENi00POBXrqs4du9G/YP+jqrqHClziXT+90eBSxIjYTEYcqFktPpk/KtjAj/Hm47nMnjyQn5IqQfUK8TrhJEXQXezEz35swlkf8WSs+re9lYLDNhTohY6ESCuP8vKjdtBPCBT4Di3gLCtI08zeRlheQ6ABYW56Uxzmf8kXK1E6qhJKxp6/Ll3RpBj6Ru1Du73hhiLjGqCPTwBmNnTvIgk8Q3tMNrvSmgpdc4w3WEzyMgXgMIBHyFEcMrONn++bBNGYn6q2Ps9IfHBUao53FDvEu+fF6yZryHsCvi0CY8p7kihoskWGSjrvt4duXELNlWXHPSOlJz1rx17YmRoSqO5P6gYlvZmEtUHCJEVw4dqKmnmlwnSUf+4pNCRkScsHU6K65Koo9jvzzkgJuP6iuX1y8oBxQSFqJqewGEIBCnwcnR9wP3v+00IS8cqYgiyXJdd3I5NDVlWBgyW5gUaQPZlW96gtUp9QHDPBjgXrfznITPlKyX3beth5lJPT5kY01UhQ2TsMjhh1dQCvNRs/8czH4/cfDYrPJxYByqB6ZIU8M8v6Pprq3vJjECUTTmwJfPbIK4Eemxnd2kfHvoWDJLEOlmcaInbtMV55abAHdZauMca8aa/F7LzQv0DAKuxua6FbGegbrHw1vLCWNiV0TPsjbbf7qfZnCSbkQO1/FJHIVAgVlpDfUk27lWH1Dr4OFK+X8sem+9ANHuw7+Uds9CtHynrdfbn5Co2NAbV5PZcsfyIt4fZ6LmweAqxs0Z/W88EXTzUrRtbY2r4PD9coTLZtL3bj+lUj+lQ1cFYhc9Mi2QG/viZsxrGBwXqFS44YbweGJEDh3pfFNCsR3kZMHaBH6ufJ0hDJa0bIKYSauPrBdqo6YEFPcR2E9+go9
 epsshcPj
 0CuJ+PQvRBvE0bmaKUCciHV+PLvhk8UsvaojNH7QwzyW3AaGjUreB/p2cWMwjbM/2GX/rGRWDNJcFdzIeDj4CUYJYpL07WcAyhv935M4NSdrJFDHmA8ZFJLDl88ZQVcYd+DWE3cLG47r9Aw5dXKaKJl9sSzA1KON6q81npjjYlTMGdpSXMhvpsnG8eVcx5Qnb7RTH9sujq3jNK199gZzxYhJuwGHOuVbLIUwBCVP4mOlQJ3bh9meG1Mb6OcAithi7SYDK10j4ur8Ad7m0gfw3sTz0Ix3WJr2jk0rRsAcBwFESQbO/l2//YnPbbr27UCJiGFnxl1Dqs9AVoKVrFhArhvuhVcEhhq2yMMcm2t5+9oMYqUq3duGwv1/fZ1BB26OWzRwcr8rO8zBW4O3jKhxPY68N7jABJ3SVmN3zR9iekvs+IsRT7Iha9umRzOOinCjLCEmli9EhCwy4Y2ig/YiN0NvHF7UpamZdAs/EFIMvPAmF9M42DURP2bG2Kxt6BtmDqsQP/bHUqYG6NRLY0pRRqiidKpeXfGHzAOXepOvM5xSh3NwbyJd4MU3VuqGYYHi0d6x+/zhuDVhHWGmYvxVwOZvCbIMPwuuaQcwV8SK/KRp3i4E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Critical] mm: rmap corruption from unmapped PMD folio cached by
  swapin_pmd_swap_entry()
--

commit 14ed08337de0c0909e93ae1d8b999993fb793692
Author: Usama Arif <usama.arif@linux.dev>

mm: handle PMD swap entries in MADV_WILLNEED

This commit teaches MADV_WILLNEED to prefetch PMD swap entries as a single
PMD-order folio when THP policy allows it, falling back to splitting the
PMD into PTEs when PMD-order swapin is disallowed or fails.

> diff --git a/mm/madvise.c b/mm/madvise.c
> index f7f17efdd926d..576be4b8744c2 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
[ ... ]
> @@ -193,6 +194,108 @@ static int madvise_update_vma(vm_flags_t new_flags,
>  }
> =20
>  #ifdef CONFIG_SWAP
> +/*
> + * Prefetch a whole PMD swap entry as one PMD-order folio.
> + *
> + * Called with the PMD lock held; always drops it. Returns true when the
> + * caller should ask the walker to retry so the PTE path can handle the
> + * covered slots individually.
> + */
> +static bool swapin_pmd_swap_entry(struct vm_area_struct *vma, pmd_t *pmd,
> +				  unsigned long addr, softleaf_t entry,
> +				  spinlock_t *ptl)
> +{
[ ... ]
> +	/*
> +	 * The range was PMD-mapped when it was swapped out, but the policy may
> +	 * have changed since: MADV_NOHUGEPAGE, or the sysfs knob. Reading it
> +	 * back at PMD order would then hand do_swap_page() a PMD-sized folio to
> +	 * map with PTEs, which is exactly what the policy forbids. Split now
> +	 * and let the PTE path prefetch at order 0 - the next fault would split
> +	 * the entry anyway, so nothing is lost that the VMA still permits.
> +	 */
> +	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_PAGEFAULT,
> +				     HPAGE_PMD_ORDER)) {
> +		spin_unlock(ptl);
> +		return true;
> +	}
> +
> +	cache_state =3D swap_pmd_cache_lookup(entry, &folio);
> +	if (cache_state =3D=3D SWAP_PMD_CACHE_HUGE) {
> +		/* Already cached as one PMD-sized folio, nothing to do. */
> +		folio_put(folio);
> +		spin_unlock(ptl);
> +		return false;
> +	}
> +	if (cache_state =3D=3D SWAP_PMD_CACHE_SPLIT ||
> +	    zswap_is_present(entry, HPAGE_PMD_NR)) {
> +		spin_unlock(ptl);
> +		return true;
> +	}
> +
> +	/*
> +	 * Pin the swap device under the PMD lock so the PMD-swap-entry
> +	 * observation keeps the entry valid for swapin_sync().
> +	 */
> +	si =3D get_swap_device(entry);
> +	spin_unlock(ptl);
> +	if (IS_ERR_OR_NULL(si))
> +		return false;
> +
> +	folio =3D swapin_sync(entry, GFP_HIGHUSER_MOVABLE, BIT(HPAGE_PMD_ORDER),
> +			    &vmf, NULL, 0);

[Severity: Critical]
Can leaving a newly allocated PMD-order folio unmapped in the swap cache
corrupt rmap and mapcount state if the PMD swap entry is split before a
PMD fault maps it?

When madvise_willneed() -> swapin_walk_pmd_entry() ->
swapin_pmd_swap_entry() calls swapin_sync() with BIT(HPAGE_PMD_ORDER), it
inserts a fresh HPAGE_PMD_ORDER folio into the swap cache and leaves it
unmapped (!folio_test_anon(folio)).

Before a PMD page fault maps that folio via do_huge_pmd_swap_page(), the
PMD swap entry can be split into 512 contiguous PTE swap entries without
removing the cached folio. For example, if userspace applies
MADV_NOHUGEPAGE (or the sysfs THP policy changes) and then either calls
MADV_WILLNEED again (hitting the !thp_vma_allowable_order() check above
and splitting via __split_huge_pmd()) or faults on the range (causing
do_huge_pmd_swap_page() to split the PMD for PTE fallback), or performs a
partial munmap(), mprotect(), MADV_DONTNEED, or MADV_FREE, the unmapped
PMD-order folio remains in the swap cache while the page table now holds
PTE swap entries.

When do_swap_page() then faults on one of those 512 contiguous PTE swap
entries, swap_cache_get_folio() returns the HPAGE_PMD_ORDER folio and
swap_pte_batch() batches all 512 PTEs so nr_pages =3D=3D folio_nr_pages(fol=
io),
bypassing the partial mapping check:

mm/memory.c:do_swap_page() {
	...
	if (!folio_test_anon(folio) && folio_test_large(folio) &&
	    nr_pages !=3D folio_nr_pages(folio)) {
		if (!WARN_ON_ONCE(folio_test_dirty(folio)))
			swap_cache_del_folio(folio);
		goto out_nomap;
	}
	...
	} else if (!folio_test_anon(folio)) {
		VM_WARN_ON_ONCE_FOLIO(folio_nr_pages(folio) !=3D nr_pages, folio);
		VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);
		folio_add_new_anon_rmap(folio, vma, address, rmap_flags);
		folio_put_swap(folio, NULL);
	}
	...
	set_ptes(vma->vm_mm, addr, ptep, pte, nr_pages);
}

Because folio_test_pmd_mappable(folio) is true for an HPAGE_PMD_ORDER
folio, folio_add_new_anon_rmap() initializes the folio as PMD-mapped
rather than PTE-mapped:

mm/rmap.c:folio_add_new_anon_rmap() {
	...
	} else if (!folio_test_pmd_mappable(folio)) {
		...
	} else {
		nr =3D folio_large_nr_pages(folio);
		/* increment count (starts at -1) */
		atomic_set(&folio->_entire_mapcount, 0);
		folio_set_large_mapcount(folio, 1, vma);
		if (IS_ENABLED(CONFIG_PAGE_MAPCOUNT))
			atomic_set(&folio->_nr_pages_mapped, ENTIRELY_MAPPED);
		if (exclusive)
			SetPageAnonExclusive(&folio->page);
		nr_pmdmapped =3D nr;
	}
}

This maps the folio with 512 PTEs while setting _entire_mapcount =3D 0,
_large_mapcount =3D 1, nr_pmdmapped =3D 512, leaving per-page _mapcount at =
-1,
and only setting PageAnonExclusive on the head page even when tail pages
are mapped by writable PTEs.

Similarly, if swapoff runs on the split PTE swap entries, unuse_pte() will
find the unmapped HPAGE_PMD_ORDER folio in the swap cache:

mm/swapfile.c:unuse_pte() {
	...
	if (!folio_test_anon(folio)) {
		VM_WARN_ON_ONCE(folio_test_large(folio));
		VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
		folio_add_new_anon_rmap(folio, vma, addr, rmap_flags);
	}
}

Would it make sense to ensure that unmapped PMD-order folios in the swap
cache are either removed when a PMD swap entry is split or rejected by PTE
swapin paths such as do_swap_page() and unuse_pte()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105183940.2236=
717-1-usama.arif@linux.dev?part=3D27

