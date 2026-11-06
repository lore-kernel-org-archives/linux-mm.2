Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2063C606A32E
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 18:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MwDW+goc
Received: by kanga.kvack.org (Postfix)
	id B5B5C6B05BB; Fri,  6 Nov 2026 13:43:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE4CE6B05BC; Fri,  6 Nov 2026 13:43:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 984746B05BD; Fri,  6 Nov 2026 13:43:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 657006B05BB
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:43:17 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C4550A0195
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 18:43:10 +0000 (UTC)
X-FDA: 85405566540.26.6B0A4E4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1798C80004
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 18:43:08 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MwDW+goc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793990589;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RBoFLKX2ohtJPCOfYodmuNH9LJF96lmNOkH4FDboQ4U=;
	b=dt7qQJ+51n2vTjr9g733CGW750QcVlMm0R0JjVOIKSDRtetONtXKHi8SFuFAIuvuQoLESq
	NslWx0T3jzRZN7AMhzNPfPDxAZu/n2C5fDLg3FDHC9hQv+vjHTDuH9rRTSptYW4vcLpzIv
	sAzpl3f+A2zjQ6hcZaa0JOcNQ0Zi2jw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MwDW+goc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793990589;
	b=Opzus3PTylS8Cytyj8KYQMDP40wsBJqro0T0YQLozLRGI37G0iBNLUto0eEFzZtfP2YH5p
	XuuZSmYzlEB6PhYP2Rc9FswNvp+9BJUvg7Qbw3yxs5AW+HRN9ky9Vkx6KhogaoK1HUKscR
	HpozNpOt9Z16I65z79H9tmiURteIdIc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6963942E48;
	Fri,  6 Nov 2026 18:43:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E81001F008A1;
	Fri,  6 Nov 2026 18:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793990587;
	bh=RBoFLKX2ohtJPCOfYodmuNH9LJF96lmNOkH4FDboQ4U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MwDW+gocQYJkSRqlEe/AAc13iaCVhmgh4DK9UuYs3/Y6VkSSNWoUnwt9caNDt3eTJ
	 GR2fdojeZZKVpIgIL77t/cvwbjEye2b6br+Sp6FiV92nuypxNN3HFJWDxazQuhWfez
	 Y/4uiCCTuT6FquLuDpusjvWaeK9WRwtVNocBo+/jaf2sbZmOEIAwEW6uV3weUagHFV
	 IBann16kY2isf5VnFz/Y0U6vNmwoTGfvYmPoTYwjnXOzUt7oSekQe7uwJGhP0hbTmj
	 VbWSynqLYlUsAu/4f+16J4ph8VVFKSGTXXGyRDTTF+AgTBBBHBTsEFSKILPyyNb7r9
	 oLpXj6txC5NOA==
Message-ID: <sashiko-outbox-202072@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 17/32] mm: swap in PMD swap entries as whole THPs
 during swapoff
Reply-To: sashiko-reviews@lists.linux.dev
To: "Usama Arif" <usama.arif@linux.dev>, "Andrew Morton" <akpm@linux-foundation.org>, david@kernel.org, chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org
Cc: chenhuacai@kernel.org, ying.huang@linux.alibaba.com, "Baoquan He" <baoquan.he@linux.dev>, willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org, baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com, "Nico
 Pache" <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com, "Vlastimil
 Babka" <vbabka@kernel.org>, lance.yang@linux.dev, nphamcs@gmail.com, shikemeng@huaweicloud.com, yosry@kernel.org, qi.zheng@linux.dev, luizcap@redhat.com, kernel-team@meta.com
In-Reply-To: <20261105183940.2236717-18-usama.arif@linux.dev>
References: <20261105183940.2236717-1-usama.arif@linux.dev>
 <20261105183940.2236717-18-usama.arif@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 18:43:05 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1798C80004
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: hh3fh3gztoz585e8o95nuedtyy6ryck7
X-HE-Tag: 1793990588-439380
X-HE-Meta: U2FsdGVkX18bJM0NuA0bc7kvzSMhwgFGFwO/bx6PW5uKyhxnUb86rPSzUDsXYnY/8ivPp+ZMk1U7ybtCA+ah3ripmj7zsTzQ2FiEh4xFA7rUEoR78hREceO21tNe0ZYeM/o8dBZT2Vjp2hfoM53RSVwE0l3FyqwVEmYAZ4wvHwbyisqQvterDnS25ECJej3zeGQH46PS855MnaRZC1g8CVy0Oro3T89MJG5S3L6W6o/APvV1tHUNyTrrvqQrMTU1w0RNkE9Nx1Cb6t7nacn93VY3VyXXtakceiaxCtpplMHZ4x7L39dA6/lI0SzT58s4Lwefvo3Z/D8iVrIxzNb9AXDQv4MPyMKPg8qJyyXEV6uQcrNP73B0COJrQE7bTA2L8U3+Jj6ghE08kPIEv5DuBfTbd1HjgSEY96p34ww8jUxpFvX4DwWCN0HE6U21CpQsLqGKBOpdIt38+bM0Q27Cd6CB0ha3PSvRL/q5+DzzVb16Tar42wlWEwxIRmkCGpY3JeOVnINZmeej4RA7mjm5ssDg38J3ULv8Gri3K0YXoH1EIbx+31GsDd0wy9o0kEZamYZbmC+n+xLU0j6FE/eYCviYGff5sc/TZIdv/xXtisAy0PEsiaGSGZOCu5Hpyf8yD9n/NoYiOccyHt8njCvycmnR6s2soCN9PU2jjD/fGLWE6sVwXg+rLj1hvbymg1RXL0uSxh1+6Ou0bvhwGSc1jRx/jh8JVwVhThpeSjQ+K6etk8+0QyapHIHBOrlm2i2K6B5ZiS+c7SoM0ShHbfXEkw8y8TtSBtkE8WH22ih0r3lwQlQX/2W58Ke54cp6wkw5FoGKpskkd8+7w+Mt3UJuk3X6IZ1ZQUCQc0W0CwPiUQu+Ggf4tOf47kAL2FdtUjioeUJkUgsV9tdu4u54duVhteVCfa8WUYWbdKTj3a+yBIttDPIWvr+EpipLc9NtJSa1azGReNOtvgchxq0y5Sl
 qnUUDEad
 ND7RPqUCxBhxWFuJpgUE8DK/49vuprfR7afURiA1jYqK7T3M4V+Vik5VLdO34eBeyIdlno5OfTeWPXaAElFU7jekGxeQue0+qeo84Dbu9Ig6c8M92Gc8I7ddzVO5sWYNS3i4hLP7D/5WL3RjAkhsvBAE+PxB8t0veATn5GgmQej096rHnKXmwVhMjDG6Jy3MrUAUI5Dmg9oFYk0Vj6o1QtIskufDQdPGPYCtiTiFNW9sCnpjszlhvlvJkerBk829F7Sd2jFjAgLmbsw9NlMsyMtzVnNn8Z6OFe0Sg2Yc/Ef3yHckslF4/dRxRjG9/0OAtBkVRBBQEislJaAyBk+rLLc9OQIu1RcJ6VjU/pNTfeNSe6aIWQ9zMn71B9lmk7kEAhUqLh/2Ask20fVvlMz/yJ+A2i+6ij4ON1X5/rnas8UfnJmdoV0ZNc6meS2CdI0zt2ix1pn3+gOst6hnPYoqE4vDOu87ranfknuaOfXS5CjibyXl2lR90tQJ5Xrx5r2nGRtg5DFvarPOW2aHW3gazke2BpRbS9ySdSd9FeHlpqZreLzchJMo9mYfW+lIZHeotUxPH
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
- [Critical] mm/swapfile: race between unuse_pmd_entry() and
  do_swap_page() corrupts rmap
--

commit 2a3a8bc71439dccac7a6dee3671d26f7c3dba876
Author: Usama Arif <usama.arif@linux.dev>

mm: swap in PMD swap entries as whole THPs during swapoff

This commit adds swap_pmd_cache_lookup(), unuse_pmd(), and unuse_pmd_entry()
to swap in PMD swap entries as whole THPs during swapoff when possible,
falling back to splitting the PMD into PTEs otherwise.

> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 6b5149b88fa43..7e91dc50a5131 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c

[ ... ]

> @@ -2695,6 +2696,182 @@ static int unuse_pte_range(struct vm_area_struct =
*vma, pmd_t *pmd,

[ ... ]

> +static int unuse_pmd_entry(struct vm_area_struct *vma, pmd_t *pmd,
> +			   unsigned long addr, softleaf_t entry)
> +{
> +	enum swap_pmd_cache cache_state;
> +	struct folio *folio;
> +	pmd_t pmdval;
> +	int ret;
> +
> +	cache_state =3D swap_pmd_cache_lookup(entry, &folio);
> +	if (cache_state =3D=3D SWAP_PMD_CACHE_SPLIT) {
> +		ret =3D -EAGAIN;
> +		goto split_fallback;
> +	}
> +	if (!folio) {
> +		struct vm_fault vmf =3D {
> +			.vma =3D vma,
> +			.address =3D addr,
> +			.real_address =3D addr,
> +			.pmd =3D pmd,
> +		};
> +
> +		if (zswap_is_present(entry, HPAGE_PMD_NR)) {
> +			ret =3D -EAGAIN;
> +			goto split_fallback;
> +		}
> +
> +		folio =3D swapin_sync(entry, GFP_HIGHUSER_MOVABLE,
> +				    BIT(HPAGE_PMD_ORDER), &vmf, NULL, 0);
> +		if (IS_ERR_OR_NULL(folio)) {
> +			ret =3D folio ? PTR_ERR(folio) : -ENOMEM;
> +			goto split_fallback;
> +		}
> +	}
> +
> +	folio_lock(folio);
> +	folio_wait_writeback(folio);
> +	/*
> +	 * If the cached folio is no longer PMD-sized (e.g. split in the
> +	 * swap cache by deferred_split_scan() or memory_failure() while
> +	 * the PMD swap entry was installed), the PMD swap entry no longer
> +	 * maps a single contiguous folio.  Split the PMD swap entry so
> +	 * unuse_pte_range() can swap the per-slot folios in individually.
> +	 */
> +	if (folio_nr_pages(folio) !=3D HPAGE_PMD_NR) {
> +		folio_unlock(folio);
> +		folio_put(folio);
> +		ret =3D -EAGAIN;
> +		goto split_fallback;
> +	}
> +	ret =3D unuse_pmd(vma, pmd, addr, entry, folio);
> +	/*
> +	 * PTE fallback cannot add a single-page rmap to a newly allocated,
> +	 * PMD-sized !anon folio, and it cannot do anything useful with a folio
> +	 * that failed to read. Remove either from the swap cache so each slot
> +	 * is read back into an order-0 folio. An uptodate anon swap-cache folio
> +	 * can be mapped one PTE at a time and must stay cached so poisoned
> +	 * subpages remain visible.
> +	 */
> +	if (ret && folio_matches_swap_entry(folio, entry) &&
> +	    (!folio_test_uptodate(folio) || !folio_test_anon(folio)))
> +		swap_cache_del_folio(folio);

[Severity: Critical]
Can a concurrent page fault in do_swap_page() race with unuse_pmd_entry() a=
nd
map this newly allocated PMD-sized !anon folio via PTEs before
swap_cache_del_folio() runs, corrupting the folio's rmap state?

In mm/swapfile.c, try_to_unuse() -> unuse_mm() -> unuse_pmd_range() ->
unuse_pmd_entry() calls swapin_sync() with BIT(HPAGE_PMD_ORDER) without
holding pmd_lock (and with only mmap_read_lock(mm) held). swapin_sync()
allocates an order HPAGE_PMD_ORDER folio with !folio_test_anon(folio) and
folio_test_pmd_mappable(folio) =3D=3D true, inserts it into the swap cache
covering [entry, entry + HPAGE_PMD_NR), and initiates swap_read_folio().

When the swap read completes, the folio is unlocked before unuse_pmd_entry()
acquires folio_lock(folio). During that window, a concurrent page fault on
split PTEs covering the same swap range (either in the same mm after a
concurrent PMD split such as madvise or mprotect, or in a forked mm whose P=
MD
swap entry was split into HPAGE_PMD_NR contiguous PTE swap entries) can ent=
er
do_swap_page(), find the folio via swap_cache_get_folio(entry), and lock it
first.

In mm/memory.c:do_swap_page(), when all HPAGE_PMD_NR PTEs in the split page
table are still contiguous swap entries, folio_pte_range() and
swap_pte_batch() compute nr_pages =3D=3D HPAGE_PMD_NR =3D=3D folio_nr_pages=
(folio), so
the size mismatch check does not trigger:

	if (!folio_test_anon(folio) && folio_test_large(folio) &&
	    nr_pages !=3D folio_nr_pages(folio)) {
		if (!WARN_ON_ONCE(folio_test_dirty(folio)))
			swap_cache_del_folio(folio);
		goto out_nomap;
	}

do_swap_page() then calls folio_add_new_anon_rmap(folio, vma, address,
rmap_flags) and maps the folio across HPAGE_PMD_NR PTEs with set_ptes().
However, mm/rmap.c:folio_add_new_anon_rmap() assumes any
folio_test_pmd_mappable(folio) folio is being mapped at the PMD level:

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

This initializes PMD-mapped rmap accounting (_entire_mapcount =3D 0,
_large_mapcount =3D 1, per-page _mapcount left at -1, and PageAnonExclusive=
 set
only on page 0) on a folio that is actually mapped by HPAGE_PMD_NR PTEs, wh=
ich
will corrupt mapcounts and trigger BUG checks when those PTEs are later
unmapped via folio_remove_rmap_ptes().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105183940.2236=
717-1-usama.arif@linux.dev?part=3D17

