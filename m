Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AF5960A67AC
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 21:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QsLNzWr2
Received: by kanga.kvack.org (Postfix)
	id 5AB626B00EF; Wed,  4 Nov 2026 16:09:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55AEB6B05B0; Wed,  4 Nov 2026 16:09:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 471966B05B1; Wed,  4 Nov 2026 16:09:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1E2C36B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:09:18 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9F85C1C4238
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:09:17 +0000 (UTC)
X-FDA: 85398677154.08.1DD849A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0B7BB120004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:09:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QsLNzWr2;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793826556;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wMfQpl/W2CRZOjlxwnGR40WLjCwOiUYScdBiYuAHHho=;
	b=00HDAh1QYyi7tn6KOKTgEo1V7Zn6EI91RNNq9aPz35lh31Rupkut3f3luVs82ELyPdF7T/
	cuYujQ/1InylPZBT8BjsF29OiJ6E1V0YDUotydXJD2B/8u1Rkr2u6DwjHo6Br2uHNBbD/y
	kaLglrccCXAoQikm9h2akjaJSXh84As=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QsLNzWr2;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793826556;
	b=QkPOP8PTMy8sHf7Zddw0monyjn6Jb9dEjPUW0U9Q1/QJWiQay2k2Gadh8yhIBO/nBSSyWg
	slG5+b1blHnWeJQyhSpt3Ah0YwiXUxTGUYPOa/d9+X5iRv1HEVWRh79KZlTAko6JzkEzMq
	q0XKpgVDS/ARNF3p1gSnu+qrZ7lkSw8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3BA7E605FF;
	Wed,  4 Nov 2026 21:09:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 625A61F00A2A;
	Wed,  4 Nov 2026 21:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793826554;
	bh=wMfQpl/W2CRZOjlxwnGR40WLjCwOiUYScdBiYuAHHho=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QsLNzWr2ps8/l1TqX3V4AtZE5OBGVxh3Q7Jbz3bsmGqpL6JAmYohYaW5rZj+paA8V
	 N0gck4OMV4y1RfTTgkCmcKA337ic913EPJWfeMKLoA8SEk4Bid1J9DXxsYRTuWwUCR
	 JY6IyvoixFZ28CW7pvQlHtbvEaqXf6FSvwtBZ/CZGx/rlkiedX4t8gAcUHiJbwhruy
	 W+vtljQjpbjfkJnSZHa9q3gKvpHIe1OWasForvO+kl1ZgkIl/xW1VRf+V3V4p/NkBK
	 VyJB8j6KzLcHtQHKaZ48/c32m7/YrDjr9cZ+KozERz0FBVj9epm3coxfIQghEPuGTG
	 GA7KihqO4VPmw==
Message-ID: <sashiko-outbox-198049@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] mm/memory-failure: set PG_hwpoison of a non-hugetlb
 page under hugetlb_lock
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mani Tofigh" <mt4022@columbia.edu>, "Muchun Song" <muchun.song@linux.dev>, "Oscar
 Salvador" <osalvador@suse.de>, "Miaohe Lin" <linmiaohe@huawei.com>, "Andrew
 Morton" <akpm@linux-foundation.org>
Cc: "David Hildenbrand" <david@kernel.org>, "Naoya Horiguchi" <nao.horiguchi@gmail.com>, "Kiryl
 Shutsemau" <kas@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Mike
 Kravetz" <mike.kravetz@oracle.com>, "Matthew Wilcox" <willy@infradead.org>, linux-mm@kvack.org, tz2294@columbia.edu
In-Reply-To: <20261103-hwpoison-hugetlb-ro-v2-1-43876fc9eef1@columbia.edu>
References: <20261103-hwpoison-hugetlb-ro-v2-1-43876fc9eef1@columbia.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 21:09:08 +0000
X-Stat-Signature: f8sfqnwzy7amy6nhwib6ezpchxwgm3uc
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 0B7BB120004
X-HE-Tag: 1793826555-692503
X-HE-Meta: U2FsdGVkX19rTPqR8Zmrqn0/AUz8iEWGe6h9QXHZGY+mLr/kDrY2z5NzuQyIWpHmiuuLTaOAskyfOg88pRcnY1BixCZCSXxQXYO40fN8hX2rA9jLk0V16XJ/OUwauuY5rSUviQNonrud+Ci/oV9Fw6NCg5Q/oLwoGRBLRrvTGlOqwE+87rozGTGq1poC++z9TSRYSHI9kci/8QkNRVOX5VTXAbjPbdPVEaGer21xQtYtFTLirulZByiD7GHB/UCDBgcE1dzusOf9iAmKiiQBlg+DJMULAuZhVclksbFXoYuCqOjQSVAl5ymdIRPdPEKnYeHv8Zw2WAgEaJm6BTkeZIOQeiuzxwlnshCLseS6stO3yuwcbJD+boGkKK3WcMIsEe67XTdovr25l50Hxb5G0BusDBcR08j8kwQhfv/bE7JQhrkrBP3yHVT4LRoMrvdEI4S1AtD7vX/q2w08pEJ2khbBOsJUMQ/PRVTEzBRxKEuJyETO19Il9fj0z8kVwzSJCVIEzj9TTl8g4fJ7h37/yO7sdB1UJzN0aTZALHGQVjuQoZC68fOGBkj1AKTgC9xhbCXJJtB0R+y+fbSbzO9Hqrb6zAqegOYxmIOExT7Ccc47ecCJlhRgjba07H3W8/xqmVTQNf8RwApf+4T9ZjTWoSDFEgAu3PKqnnqCNnY2hFbhzKNnEHBBg1dcf1j5h6iZGfhudAHbWFQ+uGi9Tsv3elX+c/YwP5tsPU2rWVvYa+Mh3rIp4NyJdaJXNoclKm5fjJo9dVmYXuvk3rnGL57mJ9AmgJh4YZhTWfucdGRByMCLalH3RMwmBJpYbzB8zBc0OMYwslc0Q9mnk8/pJb53BcuLT8I9udn5WjPBlVOjlULqm11pMcyZQ4YuAhkVR/QioAriLluIYclpBdUZZkYmOByKKnnMNZ0Rz1kJ8CmI9cbOX1P0wNRJZv2/a7FPY+dVLv+ghg37VYEEuwmF3MN
 F9d1qxDm
 XfRpgKEQi81aY03sekUuh7+96PWoUzvzmnfXWu7iGlzrOX/EAmtfgc7436FupejhsXdLDZCiIelNGrgrUqeaoFnkaBQhy2Rf/V5UbE8T1/N7ZSzrXH6M7pmXhAAzW526U2hHa+37d11x9W8hY0fg3Rep0DcQsK5ml+91xEf500XKTzKvbn657INfZ1mvaWHnUsynE3W2pbW83rl20VQwZ/roGOQKQ/LaH5yRB0ecSYIlvl79LgofJqfA1LSwHuAYTaher21tp/YIXy45IMp1S9+XeTJQbj2vEC6Fl05h9pewT/3ts9RO9ejWeWHRXN+6gEf+cYAhFyxQPx6bUasckcXbcTaHCaVp9NsnVuImj325UJMQAtcyWtwnwpehNlFOGlVmSU/iiyJTGdIhxsIctUmy+n7xR7Z5zmOeTZ3JhMTFU++WABClYdt02ZXwQ270dpKLHt0EgERH0FZfvp4X8Loi2gdrKtz9C+oqBN2Wn0fMWiMG5M+pvGu0FmbisowsTb38me+PBZ+XaVuckyYYFmFHTMH1rxiA/4T2tEzgSWCMXsfLSVNw7j8O78lBwQGJLNZNMOgU00eQEvT1AgI5ROFns7P24f/jvoT2PU7RQjSuYF2puMLRdB/mESnmxqDMIf+DT2LVwPrrk7zMIaTwIOV8fw/NtDrVbYY2EwPLH8nhWnKxaKL59Tc3/89rykIEiiVdnHt4cLN79PnKTevF6or/Sgw==
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
- [High] mm/memory-failure: missed retry when poisoned page becomes hugetlb=
 folio
- [High] mm/memory-failure: broken HVO assumptions in clear_non_hugetlb_hwp=
oison()
--

commit cd482078045f6c62698aca153687853e7f4a179f
Author: Mani Tofigh <mt4022@columbia.edu>

mm/memory-failure: set PG_hwpoison of a non-hugetlb page under hugetlb_lock

This commit sets the hugetlb flag on newly initialized hugetlb folios and
sets PG_hwpoison on non-hugetlb pages while holding hugetlb_lock in
get_huge_page_for_hwpoison(). The goal is to prevent memory_failure() from
setting PG_hwpoison on the shared vmemmap tail page if the target page
concurrently becomes part of an HVO-optimized hugetlb folio.

> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index b215312f261b8..80bac8d544d40 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c

[ ... ]

> @@ -2169,10 +2177,32 @@ static int try_memory_failure_hugetlb(unsigned lo=
ng pfn, int flags)
>  	return identify_page_state(pfn, p, page_flags);
>  }
> =20
> +/*
> + * Keep the flag if the page has become a tail page of a hugetlb folio in
> + * the meantime, as HVO may remap its struct page.  A head page is never
> + * remapped, and keeping the flag there would make the retry take the
> + * folio for already poisoned.
> + */
> +static void clear_non_hugetlb_hwpoison(struct page *page)
> +{
> +	struct folio *folio;
> +
> +	spin_lock_irq(&hugetlb_lock);
> +	folio =3D page_folio(page);
> +	if (!folio_test_hugetlb(folio) || &folio->page =3D=3D page)
> +		ClearPageHWPoison(page);
> +	spin_unlock_irq(&hugetlb_lock);
> +}

[Severity: High]
As reported by Sashiko on v1 [1], does clear_non_hugetlb_hwpoison() rely on
accurate assumptions about how HVO remaps struct page entries?

First, the comment states that a head page is never remapped, yet
__hugetlb_vmemmap_optimize_folio() allocates a new vmemmap_head page, copies
the first vmemmap page into it, and remaps &folio->page to vmemmap_head
outside hugetlb_lock:

mm/hugetlb_vmemmap.c:__hugetlb_vmemmap_optimize_folio() {
	vmemmap_head =3D alloc_pages_node(nid, GFP_KERNEL, 0);
	if (!vmemmap_head) {
		ret =3D -ENOMEM;
		goto out;
	}

	copy_page(page_to_virt(vmemmap_head), folio);
	...
	ret =3D vmemmap_remap_free(vmemmap_start, vmemmap_end,
				 vmemmap_head, vmemmap_tail,
				 vmemmap_pages, flags);
}

When page =3D=3D &folio->page, if copy_page() runs after
get_huge_page_for_hwpoison() sets PG_hwpoison on page, and
clear_non_hugetlb_hwpoison() runs ClearPageHWPoison(page) before the PTE for
&folio->page is updated to vmemmap_head and TLB-flushed, ClearPageHWPoison()
only clears the flag on the old vmemmap page being freed. vmemmap_head keeps
PG_hwpoison set, so the retry in hugetlb_update_hwpoison() sees
folio_test_set_hwpoison(folio) =3D=3D true and aborts with
MF_HUGETLB_FOLIO_PRE_POISONED (-EHWPOISON), leaving the poisoned hugetlb
folio undissolved.

Second, when page is a tail page (&folio->page !=3D page) and
folio_test_hugetlb(folio) is true, clear_non_hugetlb_hwpoison()
unconditionally skips ClearPageHWPoison(page). However, tail pages 1..63
reside in the first 4KB vmemmap page (HUGETLB_VMEMMAP_RESERVE_SIZE), which =
is
copied to vmemmap_head and is never remapped to vmemmap_tail or overwritten
by __hugetlb_vmemmap_restore_folio(); and when HVO is disabled or fails, no
tail pages are remapped at all.

If PG_hwpoison is left set on one of those non-remapped tail struct pages,
can this cause recovery to abort with -EEXIST if the hugetlb folio is freed
before try_again re-acquires hugetlb_lock (such as when
alloc_surplus_hugetlb_folio() fails its overcommit recheck), or trigger
bad_page() upon buddy free if the hugetlb error is later filtered by
hwpoison_filter() or cleared via unpoison_memory()?

[ ... ]

> @@ -2486,7 +2517,7 @@ int memory_failure(unsigned long pfn, int flags)
>  			} else {
>  				/* We lost the race, try again */
>  				if (retry) {
> -					ClearPageHWPoison(p);
> +					clear_non_hugetlb_hwpoison(p);
>  					retry =3D false;
>  					goto try_again;
>  				}

[Severity: High]
As reported by Sashiko on v1 [1], is this retry block actually reached when=
 a
non-hugetlb page becomes part of a new hugetlb folio after
get_huge_page_for_hwpoison() sets PG_hwpoison and drops hugetlb_lock?

In only_alloc_fresh_hugetlb_folio(), alloc_buddy_frozen_folio() and
alloc_gigantic_frozen_folio() remove the pages from the buddy or contig
allocator (clearing PageBuddy and preparing the compound page) before calli=
ng
init_new_hugetlb_folio() to take hugetlb_lock and set PG_hugetlb;
demote_free_hugetlb_folios() similarly prepares split compound folios before
calling init_new_hugetlb_folio(). Moreover, when check_pages_enabled is fal=
se
or in alloc_contig_frozen_range_noprof() (which ignores the return value of
check_new_pages()), the page allocator does not reject a free buddy page wi=
th
PG_hwpoison set, and get_hwpoison_page() sleeps in zone_pcp_disable() before
inspecting p.

In memory_failure(), clear_non_hugetlb_hwpoison(p) and goto try_again are
gated behind get_hwpoison_page(p, flags) returning 0 and
is_free_buddy_page(p) returning true:

	res =3D get_hwpoison_page(p, flags);
	switch (res) {
	case 0:
		if (is_free_buddy_page(p)) {
			if (take_page_off_buddy(p)) {
				...
			} else {
				/* We lost the race, try again */
				if (retry) {
					clear_non_hugetlb_hwpoison(p);
					retry =3D false;
					goto try_again;
				}
				res =3D MF_FAILED;
			}
			res =3D action_result(pfn, MF_MSG_BUDDY, res);
		} else {
			res =3D action_result(pfn, MF_MSG_KERNEL_HIGH_ORDER, MF_IGNORED);
		}
		goto unlock_mutex;

Whenever the concurrent hugetlb allocation has already removed p from the
buddy freelist before memory_failure() reaches is_free_buddy_page(p), won't
the retry path be bypassed in all three hugetlb states?

1. If the new hugetlb folio is on the hugetlb freelist (HPG_freed set),
   get_hwpoison_hugetlb_folio() and get_any_page() return 0,
   is_free_buddy_page(p) is false, and memory_failure() exits via the
   MF_MSG_KERNEL_HIGH_ORDER branch without retrying.

2. If the new hugetlb folio is still in init_new_hugetlb_folio() or
   hugetlb_vmemmap_optimize_folios() (!HPG_freed and !HPG_migratable),
   get_hwpoison_hugetlb_folio() returns -EBUSY, get_any_page() returns -EIO
   after exhausting its retries, and memory_failure() exits via the default
   MF_MSG_GET_HWPOISON branch without retrying.

3. If the new hugetlb folio has already become in-use (HPG_migratable set),
   get_hwpoison_hugetlb_folio() pins the folio and returns 1, and
   get_any_page() sees PageHuge(p) and returns 1. memory_failure() then fal=
ls
   through into the non-hugetlb in-use path with a hugetlb folio: if
   hwpoison_filter(p) matches, it calls ClearPageHWPoison(p) without
   hugetlb_lock (touching the shared vmemmap_tail page if HVO-optimized), a=
nd
   otherwise it calls folio_set_has_hwpoisoned(folio) and
   split_huge_page_to_order() on the hugetlb folio.

In the first two cases, if p became a remapped tail page (>=3D 64) of an
HVO-optimized hugetlb folio, freeing the original vmemmap page discards
PG_hwpoison and leaves the poisoned hugetlb folio in the pool; if p became
the head page, PG_hwpoison stays set with an empty raw_hwp_page list and is
cleared when the folio is later freed; and if p became a non-remapped tail
page, PG_hwpoison stays on the tail struct page and triggers bad_page() when
the folio is freed.

[1] https://lore.kernel.org/r/20261101-hwpoison-hugetlb-ro-v1-1-a42d6411cb6=
5@columbia.edu

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103-hwpoison-h=
ugetlb-ro-v2-1-43876fc9eef1@columbia.edu?part=3D1

