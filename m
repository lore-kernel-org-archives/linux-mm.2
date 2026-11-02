Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 208B0606A327
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 18:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WxpkZ1cy
Received: by kanga.kvack.org (Postfix)
	id 03BF66B00EF; Mon,  2 Nov 2026 13:37:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2F206B05B1; Mon,  2 Nov 2026 13:37:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E49776B05B2; Mon,  2 Nov 2026 13:37:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AC8826B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 13:37:13 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2E1E416020E
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 18:37:13 +0000 (UTC)
X-FDA: 85391036346.22.B7C3CBC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7DE7B40003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 18:37:11 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WxpkZ1cy;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793644631;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qDKFQDXPG+iBZS2vDWMkMnQLcy7Gc9+loqT8Y69xRHs=;
	b=kb3Zqu4robOlPgQT8MZTwzAJgL6Xs56GdTra6n2amPneBmImLQmLC3zQURnTe3giOzFbx6
	hyshy7SBYHlrS759hkcVaTZeOxobfSerNCWYZgf9sTJaCpxFPvMi30y30F3z7iYvXig73T
	0kWRq4eGuYDJEI8jvGlcM6wmSgmGf7c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793644631;
	b=GB8g9M90favCjbBxB288nWY3NmmgkrwVgcvVP2tddBaXsfN7anFiw7vyB7862WE3IUD81+
	N9ue0TGuJOg48ILsCGiQ6IBpuSM+m1IKQuPVRoi7EINJG5irfReMbIkCo1LV5T1YEh8Ydj
	SLtfcrc0Ka9fUeG2H58J5embaZfG2x8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WxpkZ1cy;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E849B41B2D;
	Mon,  2 Nov 2026 18:37:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5187F1F00A16;
	Mon,  2 Nov 2026 18:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793644629;
	bh=qDKFQDXPG+iBZS2vDWMkMnQLcy7Gc9+loqT8Y69xRHs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WxpkZ1cyZ6Q7rZo65XP2VV8z5wya3l9GeTOaUf/QlMLk4WGFsSAZGoH0//7wf8j2t
	 ROcAM4N9btzawEaVAYqsIXSAEb2qwO9uvoHq1wRx1St6oTX64NpNO/IGu4A4mhyfNl
	 86X58ggVim9hb4Cl5oLytzt6VLzdeSCqof/17F8PxC2HJ5e/NeDo2EBHzrXqSn6ZA7
	 xNl32Zx+LDYiSxCEc2FUfqBc66oKCRitBa+2K/qSX99Utge9bpfrSGj9yWkLUbFU6s
	 ok+0YSMD8vwlnaYC+nESP6ZLWH3ZSMM1s/vQ1p11sD1zV62T+l5/Onzi0uzK8nk0YN
	 aeS1f9yofo23Q==
Message-ID: <sashiko-outbox-193951@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm/memory-failure: set PG_hwpoison of a non-hugetlb
 page under hugetlb_lock
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mani Tofigh" <mt4022@columbia.edu>, "Muchun Song" <muchun.song@linux.dev>, "Oscar
 Salvador" <osalvador@suse.de>, "Miaohe Lin" <linmiaohe@huawei.com>, "Andrew
 Morton" <akpm@linux-foundation.org>
Cc: "David Hildenbrand" <david@kernel.org>, "Naoya Horiguchi" <nao.horiguchi@gmail.com>, "Kiryl
 Shutsemau" <kas@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, linux-mm@kvack.org, tz2294@columbia.edu
In-Reply-To: <20261101-hwpoison-hugetlb-ro-v1-1-a42d6411cb65@columbia.edu>
References: <20261101-hwpoison-hugetlb-ro-v1-1-a42d6411cb65@columbia.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 18:37:08 +0000
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7DE7B40003
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: o7tcuuxahkc1qf6ny5crza4j7m83f9m9
X-Rspam-User: 
X-HE-Tag: 1793644631-379824
X-HE-Meta: U2FsdGVkX1/V2NQJeBPHvRkwbbbKwaCKv3f+nUWMlMcAaCe8A8ejqsrQw1vD6Lez1j202Wth4r1QBpb/MDzYLyausnYB5f9dcPTlPWPMxp8HSOpe3KB/Rotc9sLGJzaSI8lJV8RZ/3H+A/kSE1ypu/46AFAWCoKJUHWcd/Q56zztuz+02DZdwOXAZPUPyFPjW8qrAcyfasGlDDGr725ddig4KLzONOf1OIQADNmi0DswvMj313Q9rkBB6uyoDPXqv/FFBktQ2+1vxlYZmdxkcaxn7ChQe1+94RwIQdjXv4Y3NRxkdZuCCGRlJw1GEScEZ0TwNPBM4mCdJA/VH3jVlNZoPy0yUu3f9a3DPL1oC8ImgFJXVuAEn37TMRawL/b235Pd+OrU7P4wyEJlgJXnnW4wQeHuk0MDen/Idw9nBLBTmxtI7AVu9aY8HhY+FSKBQegW6gcS770r/Lw+KufiyoyUcU7TA70SL1yUr/3B9KpovjhKsg7iG80N58aICaPZwbuQqHRH3gkReU30abe+h3Q8KkDkgJOUMZxVYTApYqNvQ6f0DcV5fYVyJpbol6QgCWq7n01SS4YTIuOwBs99MgCVyeAUCrlphZjG9OSXL7L2aSgIj89xfNuvPqhdk/ryt72A/HOOfzPR0Fqr/3zfoczpjezUFz6P2xQzv6O6f8kgA9XitPwcxWP0A8nD2naDSiPLwDBNL96e3XgGbjeuY6LwJSITKtBwVqhcFTfhkNOMmF+SMYlbbvlScB3ioxjDL6/xauaKPHCwSSFi2hq0QcMplRLGIhY3a5EFQUwz5huhXpXRWDW2xWPOAOW0S07J1Oocbp/SmTqw5EO45ep28gSU96tjhKIXWz/cFWYEKKdmQFB2TL4wPqT/LoVOMfnSUBEvFOggs7N+dtZs48enNJ03clmKqutH1sByrMoCO8ufqbCe1cSfHWSSAKbm6yvH4/rXuHHygkUA1LWYqI7
 qMn7g5Di
 IBMUgdgMbfGoWXSqk9bGfjzxum6jIoJKaqwhGyxfLdLk4tOJ77OdGLfF7QiOLpTrfaA0zPUB3dzUVW5rgaZGL563lvnljVZJzI0H1yLa4d8mLj30AYFNKA05HUqFCC4AchTqyOqlcBPzS+4L5+OgBHoEdJ9kPG7QDjS3kfQIfZpFWxZ2YDmbcjCct3/2CwwMsDm5PcaYpL6n4MLnlQyUPGE8GlBUTeF0axTgcu73TCoqtRMGO4MMgAPzgb9hjBWExp0mcacVA75g8efqMwn6oz+6FBfKvFfiQiVXzhqIkxePlEv400Giz+Ofuy0C6COCyt62yiQDKr4cmeAj3eZz5Pu4L4vuGfPRRsR0jUfTMgFjQh9Wo3tWioP0Wle2knQ+4qxMXsrkwj/Oag6wpbeGD9CzIjqOQD5qeTtHNtKVdkf3ileCp70NuWXbmieqpOGXJKAR4ZaA099mUSNEhvyUYiOzox046gXwufglY23tphcIJY0qB7bu2HRcpP36ZUfsnCwEZI2D5O5nEPhrZVvPuh9x0kN+BEpMQ1KF07EYGX4GIjYbBOwdE9xE3Et/dubyBvGUxqxIaEe8r6ETRHbqjDiUgLqZqrkiRHW8yQ7H6Rp4M+WChDfu5NXXwRXm2XklXzk5NWjHhlPLnTTp/15FwkokbGkKFkWC9ZvFAneBphs2Q/tymvnVhPBCZjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] mm: clear_non_hugetlb_hwpoison() leaves PG_hwpoison set and breaks=
 retry
- [High] mm: race before init_new_hugetlb_folio() loses PG_hwpoison or skip=
s retry
--

commit 031004fbe7e0ec6720c8987fdb6bdfbeb3ef7d90
Author: Mani Tofigh <mt4022@columbia.edu>

mm/memory-failure: set PG_hwpoison of a non-hugetlb page under hugetlb_lock

This commit sets the hugetlb flag on newly initialized hugetlb folios and
sets PG_hwpoison on non-hugetlb pages while holding hugetlb_lock. This is
intended to prevent a race where memory_failure() sets PG_hwpoison on a tail
struct page after hugetlb vmemmap optimization has remapped it to the shared
tail page.

> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index b705f9f97f420..087b385aa0604 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c

[ ... ]

> @@ -2060,7 +2061,11 @@ static int get_huge_page_for_hwpoison(unsigned lon=
g pfn, int flags,
>  	spin_lock_irq(&hugetlb_lock);
>  	folio =3D page_folio(page);
>  	if (!folio_test_hugetlb(folio)) {
> -		ret =3D MF_HUGETLB_NON_HUGEPAGE;
> +		/* Mark it before it can become part of a new hugetlb folio. */
> +		if (TestSetPageHWPoison(page))
> +			ret =3D MF_HUGETLB_NON_HUGEPAGE_POISONED;
> +		else
> +			ret =3D MF_HUGETLB_NON_HUGEPAGE;
>  		goto out_unlock;
>  	} else if (flags & MF_COUNT_INCREASED) {
>  		ret =3D MF_HUGETLB_IN_USED;

[ ... ]

> @@ -2189,10 +2197,24 @@ static int try_memory_failure_hugetlb(unsigned lo=
ng pfn, int flags)
>  	return identify_page_state(pfn, p, page_flags);
>  }
> =20
> +/* Keep the flag if the page has become hugetlb in the meantime. */
> +static void clear_non_hugetlb_hwpoison(struct page *page)
> +{
> +	spin_lock_irq(&hugetlb_lock);
> +	if (!folio_test_hugetlb(page_folio(page)))
> +		ClearPageHWPoison(page);
> +	spin_unlock_irq(&hugetlb_lock);
> +}

[Severity: High]
If the page becomes part of a new hugetlb folio before the retry path runs,
does skipping ClearPageHWPoison(page) in clear_non_hugetlb_hwpoison() break
the subsequent retry in try_memory_failure_hugetlb()?

On the first pass, get_huge_page_for_hwpoison() sees
!folio_test_hugetlb(folio), calls TestSetPageHWPoison(page) on p, and retur=
ns
MF_HUGETLB_NON_HUGEPAGE. Because memory_failure() holds mf_mutex and exits
immediately on -EEXIST, reaching the retry path guarantees that this
invocation of memory_failure() is the one that set PG_hwpoison on p.

If p is concurrently allocated as the head page of a new hugetlb folio
(p =3D=3D &folio->page) and take_page_off_buddy(p) returns false,
clear_non_hugetlb_hwpoison(p) sees folio_test_hugetlb(page_folio(p)) is true
and leaves PG_hwpoison set on &folio->page. When memory_failure() jumps to
try_again:

  memory_failure()
    try_memory_failure_hugetlb()
      get_huge_page_for_hwpoison()
        hugetlb_update_hwpoison()
          folio_test_set_hwpoison(folio) -> returns true
            returns MF_HUGETLB_FOLIO_PRE_POISONED

get_huge_page_for_hwpoison() then aborts to out_unlock, and
try_memory_failure_hugetlb() reports MF_FAILED and returns -EHWPOISON witho=
ut
dissolving a free hugetlb folio via __page_handle_poison() or unmapping and
recovering an in-use hugetlb folio via hwpoison_user_mappings() and
identify_page_state().

Similarly, if p becomes a tail page whose struct page is not remapped to the
shared vmemmap tail page (such as tail pages in the first vmemmap page when
HVO is enabled, or any tail page when HVO is disabled or has not run yet),
skipping ClearPageHWPoison(p) leaves PG_hwpoison set on that tail struct pa=
ge,
where neither folio_clear_hugetlb_hwpoison() nor unpoison_memory() will cle=
ar
it.

> +
>  #else

[ ... ]

> @@ -2506,7 +2529,7 @@ int memory_failure(unsigned long pfn, int flags)
>  			} else {
>  				/* We lost the race, try again */
>  				if (retry) {
> -					ClearPageHWPoison(p);
> +					clear_non_hugetlb_hwpoison(p);
>  					retry =3D false;
>  					goto try_again;
>  				}

[Severity: High]
Can a page still become a tail page of an HVO-optimized hugetlb folio after
get_huge_page_for_hwpoison() marks it, and then miss this retry path
altogether?

In only_alloc_fresh_hugetlb_folio(), alloc_buddy_frozen_folio() and
alloc_gigantic_frozen_folio() allocate and prepare the compound page before
calling init_new_hugetlb_folio(folio):

  only_alloc_fresh_hugetlb_folio()
    alloc_buddy_frozen_folio() / alloc_gigantic_frozen_folio()
    /* window before hugetlb_lock is taken */
    init_new_hugetlb_folio(folio)
      spin_lock_irq(&hugetlb_lock)
      __folio_set_hugetlb(folio)
      spin_unlock_irq(&hugetlb_lock)

If get_huge_page_for_hwpoison() runs in that window (or while p is still in
the buddy allocator when page checking is not enabled, or during
alloc_contig_frozen_range_noprof() which ignores check_new_pages()'s return
value), folio_test_hugetlb(folio) is still false. get_huge_page_for_hwpoiso=
n()
sets PG_hwpoison on p's pre-HVO struct page and returns -ENOENT.

The allocating task then runs init_new_hugetlb_folio(folio) and
hugetlb_vmemmap_optimize_folio(), which frees p's tail vmemmap page and los=
es
the PG_hwpoison flag that was just set on p.

When memory_failure() then calls get_hwpoison_page(p, flags), the retry blo=
ck
is only reachable when get_hwpoison_page() returns 0 and is_free_buddy_page=
(p)
is true:

1. If the new hugetlb folio is placed on the hugetlb freelist (HPG_freed),
   get_hwpoison_page() returns 0, but is_free_buddy_page(p) is false becaus=
e p
   is now a hugetlb page rather than a buddy page. memory_failure() takes t=
he
   MF_MSG_KERNEL_HIGH_ORDER (MF_IGNORED) branch without retrying, leaving t=
he
   corrupted folio unpoisoned in the hugetlb free pool.

2. If the new hugetlb folio is still in HVO initialization (!HPG_freed &&
   !HPG_migratable), get_hwpoison_page() returns -EIO and memory_failure()
   exits via the default MF_MSG_GET_HWPOISON (MF_IGNORED) case without
   retrying.

3. If the new hugetlb folio has already been allocated to a user and marked
   HPG_migratable, get_hwpoison_page() pins the folio and returns 1.
   memory_failure() then proceeds into the non-hugetlb recovery path on a
   hugetlb folio, where hwpoison_filter(p) can call ClearPageHWPoison(p)
   without hugetlb_lock or folio_test_large(folio) will call
   folio_set_has_hwpoisoned(folio) and try_to_split_thp_page() on the huget=
lb
   folio.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261101-hwpoison-h=
ugetlb-ro-v1-1-a42d6411cb65@columbia.edu?part=3D1

