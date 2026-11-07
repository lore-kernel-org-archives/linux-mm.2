Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11F97606EEA0
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 16:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SZH7L7+/
Received: by kanga.kvack.org (Postfix)
	id B9BD36B05B2; Sat,  7 Nov 2026 11:10:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B255E6B05B3; Sat,  7 Nov 2026 11:10:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EDAE6B05B4; Sat,  7 Nov 2026 11:10:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 673CA6B05B2
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 11:10:07 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EFD73140393
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 16:10:05 +0000 (UTC)
X-FDA: 85408809570.07.77BF55D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4786C20006
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 16:10:04 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="SZH7L7+/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794067804;
	b=R67WVN+OwiuxBfq//U2YplVWLRyHZJgas64vJIoyypUomgHIw7+leD+A/VYcAPVErXEyzb
	bW2JXykE652k+QTm/f0m2EX3fFBCJwhi92OCb68DknCizj/GDwlacm07XD02t5EQV5ummg
	3qZjYESfDALDEj4kzffekK6TbsF7gdw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794067804;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LyXRWaEfifY+PE7F6GWkwmdV4KhPbrNV7G9WQeqXIKs=;
	b=I58DH7CFlW9AQ1E+oWkVwWN4TnozYSM0veBJ2P9uLXE+mYeXRsqjDYOWE5xh5LryKTPMQW
	KQpog7eliQhuAYCoVpoyWiiKTHLS0+ckK9vDfU+J99BYFCoP7N0mkKz2S1UOwq/J81UMWQ
	rFhTniRDQFcjk+Nxaq1VxLDVed6TxcI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="SZH7L7+/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 46B0442497;
	Sat,  7 Nov 2026 16:10:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ECEF1F008A3;
	Sat,  7 Nov 2026 16:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794067803;
	bh=LyXRWaEfifY+PE7F6GWkwmdV4KhPbrNV7G9WQeqXIKs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SZH7L7+/nj/5xK9fHCNN5Cgji0FJN0S2hgbfX1u2rXwtY44nJ+j6l2dIPek+DxZnb
	 LHw21LH1TeWZj2bHTaXJ+1HjWHi918JcV2hznfc7ng6RLBFcw8pJbzrxKR4s1G1art
	 5XmZOGgZj3zH4bJQfDZLgDTj90E9Ni86HapMHmIwzjR7IwHvskOw6oQyNLzjVc5uC9
	 iuW7avqnPlP4m15KvFn5B+yCkpC4Lw1aj289UQyVSrkEDu04mqIIUxAhzBkTXjCny1
	 ZBkPClmGWDuu5XLVtGWCTgXKHMTSoTWFFvk5DdohdFoKkUuH0lnNONHVDYeqZkAbxk
	 XGVzc85tI/uJw==
Message-ID: <sashiko-outbox-203024@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] mm/memory-failure: set PG_hwpoison of a non-hugetlb
 page under hugetlb_lock
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mani Tofigh" <mt4022@columbia.edu>, "Muchun Song" <muchun.song@linux.dev>, "Oscar
 Salvador" <osalvador@suse.de>, "Miaohe Lin" <linmiaohe@huawei.com>, "Andrew
 Morton" <akpm@linux-foundation.org>
Cc: "David Hildenbrand" <david@kernel.org>, "Naoya Horiguchi" <nao.horiguchi@gmail.com>, "Kiryl
 Shutsemau" <kas@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Mike
 Kravetz" <mike.kravetz@oracle.com>, "Matthew Wilcox" <willy@infradead.org>, linux-mm@kvack.org, tz2294@columbia.edu
In-Reply-To: <20261106-hwpoison-hugetlb-ro-v3-1-c11186963647@columbia.edu>
References: <20261106-hwpoison-hugetlb-ro-v3-1-c11186963647@columbia.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 16:10:02 +0000
X-Rspamd-Queue-Id: 4786C20006
X-Rspamd-Server: rspam12
X-Stat-Signature: fs3nbh1paiabiyuidg3mh77bdoz6au4n
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794067804-587705
X-HE-Meta: U2FsdGVkX1+gt3cDQS8PA3R3w5oryqSiz2TigMQXby175EaAoOPM0P08syBBksN8M/pUM1pFmBTKNVyFRWMHnLGWq40khnagogv3j9LBW8pVACWW1YwKCP3jVfs7/I1mvL1xdmD4A/zGODxAvgIfhFaXCvbxT9mu7b7pYn5nTNj8U7wR9gihCRYDlnRaDHxJ4CSWx79nYYpwt/JUrliuCShluc20OUSNzBGFBUbX4Op9Y5pMsXcOY6cCGeGv+NNYEuYGwRZKp/KwjQQ3F7YHw+JzX3plluTY9IiEQMG2VZrektYGZYTdG1jx6s1an5ffbY1hrGmotZBBdoz/uZCZwwsL8PAdSQDQ+UqR1zeS3TyVPDV1jIWlzwaTp9rAOfNugNN1KqfeEni62is2Ngfc7Q6Ms5sTJJ0nPb8OfwKsg4H625Jue6/rWD6iwUojto1+kZumJ9HCNCNYrF920dZfQm9yvexkPIp1Br4RDkUOr9k4aA+tD+h6hsY/mC+Qcv8kBMsXenCpUrJrUWIlJlVNYamf6hF74hE79Etj0SYS/JYd4ZU5bvWxdjLfeP2Ym136+wpD3ThmwV+T1AjWoy+yaKDs5zgZSGFENe4bYVVnRdSoG6nJ/FhF6owDgZ2SMlZhqJU76lpS4iLOoqYqTrNlMSDqGuMmqERSqlRNT+XHpzyAj98o29f/eKdvMywGmRF9LUx4HfVBmuh78JYidLs809YmeWjXkBOl0UTeWa9lhJIIAjAQtXNU/39mR4u4Bn7dgGBCpcOBwJm0SiyBvPf8HllunUC/xWmlYKbRx3tvNtpAV+2EDiIh20oIA06D8Ynjz+v3oy9SVhyiUrCNxqDncJPYvCAv90i+YUHg/0reJb+wO/UMcyM2csvpdRgXC8Fh7zOwJS70I2H6wsX9lLjJVUNpLoCLUe5VENuD3OzLMhNxEtMztxCOqI1a1SIExo30XaAdazyVhC81LgomAK0
 CX2hBDe/
 p4tCtQJwnFZraxtrgWZ5O188+CD33pp1PLi3k2ncaK1Qb2d7xKqZDJAK+XwYUvKhp+M3RInPsrj4+A05eUCUvwNL2SQKtnLgMhSPWTXs5BoynA+CcAAqCjiBEQhRxg2qzUn5/fWIUnSfBNdv1j4N2KJ3RElUMfHq4RzcOnYFD7Z1HQ1ntUIGUCaMPeU1neeM7ujSxbbhvXbFDTdBqK3dirZWUy87tT36Ppg6IYxC11L3YgW0b5t4cj6EOZ9LEiAOyMoAYdI3AL5sN14kSnhbVE54pR5a1okIOoVfR+W3BG+5wI3Ivw7rEX1tyQnBBdkL8PD/4X93/mSJ/xA4J2VgC1V7b3uyV6NamxGVIXp4fcAt7hRHs1C+O/fAKtfJuzPNtysySQbdcc2mKNpCPiU1H/s5dqvlasq2nBB48ejO6mJAcM60vteMye0RvB32A6ew1vx38mamJzEhc3DZlrc+THERiwO43tsaBmj9gG1CtOGhrwHPH902t5lt+1i/nLjLtNEX6mWSV/Rv7k0AIKko/DUGV00uaxrS0sUohxG2nEiv3p3vL2ZVHj4aNgrHuEbmFhBu/c7YRDwze8ZFcvioENcypiz3kMOo5kn/b9OhiZ9XsAJfDmTYlhQSfNOJaWEhBNvN5w2ez50y6Y+A9iVkKEr/iekMw26yVbtIHsFmUALUf/m9l5iS+UGPSrReNiH0kD9vqYirZvT5vBNr5zICZM66PkKDhDNH2yIjCBgqFcqqkole7thBLpxsTnfbJpXIiDuew4OOaTaHCZf6NKjmrIvWa+pb0brfQKk87AlyG42SwLFo=
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
- [High] mm/memory-failure: missed retry in memory_failure() on hugetlb
  allocation
- [High] mm/memory-failure: first vmemmap page HVO race in
  clear_non_hugetlb_hwpoison()
- [Medium] mm/memory-failure: stale tail PG_hwpoison in
  clear_non_hugetlb_hwpoison()
--

commit 473f986d60ad157a360960de8cae3064b0d63305
Author: Mani Tofigh <mt4022@columbia.edu>

mm/memory-failure: set PG_hwpoison of a non-hugetlb page under hugetlb_lock

This commit sets PG_hugetlb on new hugetlb folios and sets PG_hwpoison on
non-hugetlb pages under hugetlb_lock to prevent racing with HugeTLB vmemmap
optimization (HVO), and adds a helper to conditionally clear PG_hwpoison on
the memory_failure() retry path.

> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 78f0a13349cb3..9795f07b26f59 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
[ ... ]
> @@ -2170,10 +2179,32 @@ static int try_memory_failure_hugetlb(unsigned lo=
ng pfn, int flags)
>  	return identify_page_state(pfn, p, page_flags);
>  }
> =20
> +/*
> + * If the page has become part of a hugetlb folio in the meantime, HVO m=
ay
> + * remap its struct page unless it is in the first vmemmap page of the
> + * folio.  Keep the flag then, since the retry takes it as its own.
> + */
> +static void clear_non_hugetlb_hwpoison(struct page *page)
> +{
> +	struct folio *folio;
> +
> +	spin_lock_irq(&hugetlb_lock);
> +	folio =3D page_folio(page);
> +	if (!folio_test_hugetlb(folio) ||
> +	    folio_page_idx(folio, page) < VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES)
> +		ClearPageHWPoison(page);

[Severity: High]
Does HVO also remap the first vmemmap page of a hugetlb folio without holdi=
ng
hugetlb_lock?

In vmemmap_optimize_pte(), when vmemmap_optimizable_pfn() is false (which is
the first vmemmap page of the folio), HVO duplicates src into a newly
allocated page dst, remaps the PTE to dst, and frees src:

mm/hugetlb_vmemmap.c:vmemmap_optimize_pte() {
	if (likely(vmemmap_optimizable_pfn(page_to_pfn(page), folio_order(folio)))=
) {
		dst =3D folio_vmemmap_shared_tail_page(folio);
		if (!dst)
			return -ENOMEM;
	} else {
		dst =3D vmemmap_dup_page_from_list(src, walk->vmemmap_pages);
	}

	list_add(&src->lru, walk->vmemmap_pages);
	...
	set_pte_at(&init_mm, addr, pte, mk_pte(dst, PAGE_KERNEL));
}

Because init_new_hugetlb_folio() sets PG_hugetlb before HVO runs, this crea=
tes
a race window on the first vmemmap page:

CPU0 (memory_failure)             CPU1 (hugetlb allocation)
get_huge_page_for_hwpoison()
  TestSetPageHWPoison(page)
                                  init_new_hugetlb_folio()
                                    __folio_set_hugetlb(folio)
                                  vmemmap_optimize_pte()
                                    dst =3D vmemmap_dup_page_from_list(src,=
 ...)
                                      copy_page(dst, src)
clear_non_hugetlb_hwpoison()
  ClearPageHWPoison(page)  <-- clears old src page
                                    set_pte_at(..., dst, ...)
                                    flush_tlb_all()

After the remap, dst still has PG_hwpoison set.  If page is the head page
(index 0), the retry in get_huge_page_for_hwpoison() ->
hugetlb_update_hwpoison() sees folio_test_set_hwpoison(folio) is already tr=
ue
on dst and aborts recovery with -EHWPOISON (MF_FAILED), leaving the poisoned
hugetlb folio undissolved in the pool or mapped in user processes with an
empty raw_hwp_page list.  Conversely, if hugetlb_update_hwpoison() runs
between copy_page() and set_pte_at()/flush_tlb_all(), its writes to
folio->flags and folio->_hugetlb_hwpoison (at struct page index 3, also in
the first vmemmap page) land in the displaced src page and are lost when src
is freed.

> +	spin_unlock_irq(&hugetlb_lock);
> +}

[Severity: Medium]
When folio_test_hugetlb(folio) is true and folio_page_idx(folio, page) is at
least VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES, can skipping ClearPageHWPoison()
leave a stale PG_hwpoison bit on a tail struct page?

When HVO is disabled, unsupported for the hstate, fails, or has not run yet,
the tail struct page is not remapped.  On the retry path,
try_memory_failure_hugetlb() -> get_huge_page_for_hwpoison() ->
hugetlb_update_hwpoison() sets PG_hwpoison on the head page and adds page to
raw_hwp_list_head(folio), but never clears PG_hwpoison on the tail struct
page.

If unpoison_memory() is later called on that tail PFN while the hugetlb fol=
io
is in use (ghp > 0), it frees raw_hwp_list_head(folio), drops the ghp
reference, and then TestClearPageHWPoison(p) succeeds on the tail page and
calls folio_put(folio) a second time, dropping the active reference on the
in-use hugetlb folio while leaving PG_hwpoison set on the head page:

mm/memory-failure.c:unpoison_memory() {
	} else {
		if (folio_test_hugetlb(folio)) {
			huge =3D true;
			count =3D folio_free_raw_hwp(folio, false);
			if (count =3D=3D 0) {
				folio_put(folio);
				goto unlock_mutex;
			}
		}

		folio_put(folio);
		if (TestClearPageHWPoison(p)) {
			folio_put(folio);
			ret =3D 0;
		}
	}
}

[ ... ]
> @@ -2487,7 +2520,7 @@ int memory_failure(unsigned long pfn, int flags)
>  			} else {
>  				/* We lost the race, try again */
>  				if (retry) {
> -					ClearPageHWPoison(p);
> +					clear_non_hugetlb_hwpoison(p);
>  					retry =3D false;
>  					goto try_again;
>  				}

[Severity: High]
Can memory_failure() miss this retry altogether when a page poisoned in
get_huge_page_for_hwpoison() becomes part of a new hugetlb folio?

In only_alloc_fresh_hugetlb_folio(), alloc_buddy_frozen_folio() and
alloc_gigantic_frozen_folio() remove the pages from the buddy allocator and
clear PageBuddy before init_new_hugetlb_folio() acquires hugetlb_lock and s=
ets
PG_hugetlb.  When check_pages_enabled is false (the default when
CONFIG_DEBUG_VM is disabled and init_on_alloc/page_poison are off) or in
alloc_contig_frozen_range_noprof() (which ignores check_new_pages()'s return
value), the allocator does not reject a page with PG_hwpoison set:

CPU0 (memory_failure)             CPU1 (hugetlb allocation)
                                  only_alloc_fresh_hugetlb_folio()
                                    alloc_buddy_frozen_folio()
                                      /* clears PageBuddy(p) */
get_huge_page_for_hwpoison()
  /* !folio_test_hugetlb(folio) */
  TestSetPageHWPoison(p)
  return MF_HUGETLB_NON_HUGEPAGE
                                    init_new_hugetlb_folio()
                                      __folio_set_hugetlb(folio)
                                  hugetlb_vmemmap_optimize_folio()
                                    /* remaps p to shared tail page,
                                       frees old vmemmap page */
get_hwpoison_page(p, flags)
  get_hwpoison_hugetlb_folio()
    /* returns -EBUSY or 0 */
/* skips is_free_buddy_page(p) retry,
   returns MF_IGNORED */          <-- PG_hwpoison lost

Because the retry block in memory_failure() is only reached when
get_hwpoison_page() returns 0 and is_free_buddy_page(p) is true, a concurre=
nt
hugetlb allocation that has already cleared PageBuddy bypasses the retry in
every hugetlb state:

1. While the new folio is still being initialized or HVO-optimized (neither
   HPG_freed nor HPG_migratable is set), get_hwpoison_hugetlb_folio() retur=
ns
   -EBUSY, get_any_page() returns -EIO after exhausting its retries, and
   memory_failure() exits via the default case (MF_MSG_GET_HWPOISON,
   MF_IGNORED).
2. Once the folio is placed on the hugetlb freelist (HPG_freed set),
   get_hwpoison_page() returns 0, is_free_buddy_page(p) is false, and
   memory_failure() exits via the MF_MSG_KERNEL_HIGH_ORDER (MF_IGNORED)
   branch.
3. If the folio is allocated for use and marked HPG_migratable,
   get_hwpoison_page() returns 1 and memory_failure() falls through into the
   non-hugetlb in-use page recovery path (hwpoison_filter(),
   split_huge_page_to_order(), etc.) on a hugetlb folio.

In (1) and (2), try_memory_failure_hugetlb() is never re-run: if HVO remaps=
 a
tail page, the PG_hwpoison bit set in the old vmemmap page is discarded when
that vmemmap page is freed, leaving the corrupted physical page in the
hugetlb pool as a healthy page.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106-hwpoison-h=
ugetlb-ro-v3-1-c11186963647@columbia.edu?part=3D1

