Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C19F6606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 22:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YCcnkB08
Received: by kanga.kvack.org (Postfix)
	id 8C6BB6B05B6; Sat,  7 Nov 2026 17:08:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 877D26B05BA; Sat,  7 Nov 2026 17:08:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 767226B05BB; Sat,  7 Nov 2026 17:08:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E8026B05B6
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 17:08:49 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C2863160404
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:08:48 +0000 (UTC)
X-FDA: 85409713536.12.0309659
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 27038180002
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:08:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YCcnkB08;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794089327;
	b=nGBl0XkjKs4ZbOENFoVbDs37Pnae+zoPuFXNnjYN2xXoAAjg+4GrrCSoLQg5lgwTSFlSl4
	+HVxUf4UrmAx9BUkHPqb4KWC1MNDgAKWCslOIRbVaG90U+uii7xAaDlJQWMKVwaq9OoF+v
	i6aWm8C0woGLrB2mUxe/wKm9C1vHblc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794089327;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aEieITx+KUAUSQuIBYCd+x9ko31Ux1YeTupJxlTiaJk=;
	b=y3yUzllnGwIOyy77xlnYSShj8XUgwXtqy77Muxh6a+QhiP7juL45T0mlzzC72uNoE5eufT
	LHAko4F9mJGsM0vtEO/RgpZubdLonmCduLTohfv3RscitDvRW5wEY6qcfT0tFRQnbfDv3v
	xqdwbgy1r1pifDAajF30SxZlOAXNBds=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YCcnkB08;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AF5976114C;
	Sat,  7 Nov 2026 22:08:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E88CC1F0089F;
	Sat,  7 Nov 2026 22:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794089326;
	bh=aEieITx+KUAUSQuIBYCd+x9ko31Ux1YeTupJxlTiaJk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YCcnkB08AWIz4eAzbPklG/KP2JGU10t4r2d1wRBO6PssxUpNBHtccgn1qYyQwcWUJ
	 DRZCz5EuSL+mnnDbYTUkENt9Ii6t5OdVhuy8uJDTW/5E/0H5bNdSFBxErsZuWE3B8N
	 jE9SlxBg3jkuuuMN7CRGETFinf0VL/MP9cPSIoQAId8aQNCEsXdNuPzmt25h1CuCIX
	 qHJ9k3dVQpjncrBr7iXDLTDocZJxTHxprLhM8nvo6DloGa8m1gdsiQSXJT6pmlH/aj
	 MbYf+DekYfsmwwQEfKz/fm+OAUktYC8rQ++0I63U1bxgKpT7XkML1w3xUExiiKFMLF
	 KOwPv68LXrjGQ==
Message-ID: <sashiko-outbox-203356@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 6.6 1/2] mm: replace free hugepage folios after
 migration
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Bundschuh" <mkbund@amazon.com>
Cc: sashal@kernel.org, linux-mm@kvack.org, david@kernel.org, yangge <yangge1116@126.com>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Barry Song" <21cnbao@gmail.com>, "David
 Hildenbrand" <david@redhat.com>, "SeongJae Park" <sj@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>
In-Reply-To: <20261106220812.2874571-2-mkbund@amazon.com>
References: <20261105070431.3100950-1-mkbund@amazon.com>
 <20261106220812.2874571-1-mkbund@amazon.com>
 <20261106220812.2874571-2-mkbund@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 22:08:45 +0000
X-Rspamd-Queue-Id: 27038180002
X-Rspamd-Server: rspam12
X-Stat-Signature: gibjo7c4zzwfbsd65znspx6ycctoxsm8
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794089327-660616
X-HE-Meta: U2FsdGVkX19kfsIDoe4aFP6DvIC4MgJBG7I6dSZcXinElB745h+gI3K5C2oJDOSaFSzk/mYRF+78hd7G5HWNZCEjOaR1ZEZw6klSU3GIH73+WppesHi6kq+qa689F14Qrht1jEutnIXjSw5KebwUgPtH4ntJcyINyzBskgO504I5OqDksTenPUsPVBuxwWhGCyVkYHTOlMXinHWhkRiGLatqQi8u8sotKvFzkrIEq0L+2Xrf24zR4l6dkspluVHNDiwOeN/zUWjEsBOkuFMi7NhyXFBuPYXri0DVBzLKS0rSjM3Vl+WcPxvFgoo08Gcuyjh3RPtYYhF7D8//ByZzF3B3hdZqJBMP6KbVtDUkEOjcMGQ66txOhFAmPoAtV/OcEcMNwuvxnwpbMEv81rcqQBTgVhFrp5OOPW1Pk4MgOIqkWF0lm1NX00s5gecz1OgEre6lAcGGysef601PfdNTXyut4tEtCiQKHy+j9dT7EiUu0ZBKES29eqqDKk7QdzXAMOkbSR7XzbVYVnaF2cSjT5EvvxRjCLh4Zlj4pWNwi8iHJIEbgwjs/6MbCD+VyZrEun1QuuSovmw+titxlCLk8HuYHLvR0UNFSCSg0PK7/ZC2t7ie+zqyFEsPhHE9ZYmHNkvFhQLzKTky249rrai0SgoflAlfR1tpFRzgtziYfVxx01qZk5NUgMkJGQ3PpGjcQ9X4rEBapSDohuMm8r2dfVCZiNig4kCVjRldfh/z/lfGWLosGR7n9zIJU+fchWagjTW/Z8758kew1apFZi8xfGoXFxS5+esdSTrR4seoiZUzm2RV51E63BGY2a4qoAS1lMO50Cpf32ur8btXXgDECKTpQjSdqpHbpLJ87zSyaGmNWad3rU/lEClMN7QhFqQJIgUmpP7lpWmOEnPTUMHB//CDZVTNj4AtDxgQi58xh5VbRWHQWcCGla3KL1G5pcHWRqwmCFJnZGLC6Hcdhw/
 tJ0QH5OE
 4vVHC56t9z4GOVrOPbR3OKtaTinI27WuR2wFcNc+n2L2MicrzGxbrWT7uTVV5qoY96pF11SBuby1SzcdXuhm5Ic8+DJyyC5VOM0faRO16qpf5vnaXII316ivw/Nji3+rfXRhQcQBKlbU+IfLVqswnxxUOb/cNe2Sd9LFa0cisdJPfowKihNzCEOYmmdrWDq/Y4v1xgSSKs5/56Jst6iiFdTKDlDooudSzI8b/QbskkUS8H1pf1R42A8n9GbDvpWgbH9XPDO14PJ/KrDSWbsMyuh8UeWyP059M4ICXU0Z2fNLqMWY56JU+ery2pS7I8KPTXseJZJ0JE9toAZ+zHMoAJ3Q89IFsDRXs40OHhqakDUj9gbtdpZOjWO3wazEMr/YaJMgFw00YiZx6rOkjq7UO/fcpW+htSuBTSL9HYNErWXn3Zx0pAcd5VAjRDggsNZWrQsmhg6NhsbF6Nv0rLradZZbMF3TYZEIvweW1UpTfCzFaM+tQcJm0SuvkpZtaMqwrEnrfCvO1AA0XIfNqUOizkqiLK4KSAQZqdlxHBq9G7eyPhiq9naEEtMbqIATf2HO73uWwz7ath6MPrT03qs1Qx6Ng+LmE3ToLULv3fyH7OL8Nfw/Fk8kOgG4PKBSRB+Y3O2AMoADUFrbIBCgDF4sxh4LxecI8C+r3z+OFcH3l5ss45Ndp8GrrZaDnC4HKoHNOp+P4q4J52jQJHuDhEaJJDLGAlR8nNDJRmsC5AVvaemWICC1/lcBUqe5e4Jf19ab6/2onxIVLPAOkX48qq71CfSyk2w==
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
- [High] mm: hugetlb: skipping isolated folios in dequeue breaks resv
  accounting
- [Medium] mm: hugetlb: pfn step in replace_free_hugepage_folios()
  over-allocates
- [Medium] mm: hugetlb: missing free_hpage_work flush after hugetlb
  migration
--

commit 001656b3d65502344f54f0dc762e32f45c183341
Author: yangge <yangge1116@126.com>

mm: replace free hugepage folios after migration

This commit skips isolated free hugetlb folios during pool dequeuing and
adds replace_free_hugepage_folios() to replace and dissolve free hugetlb
folios in the target range after migration in alloc_contig_range().

Link: https://lkml.kernel.org/r/1734503588-16254-1-git-send-email-yangge111=
6@126.com
Link: https://lkml.kernel.org/r/1736582300-11364-1-git-send-email-yangge111=
6@126.com

> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 8bfaaa84bb3f7..2ef28c49b9d0f 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c

[ ... ]

> @@ -1344,6 +1345,9 @@ static struct folio *dequeue_hugetlb_folio_node_exa=
ct(struct hstate *h,
>  		if (folio_test_hwpoison(folio))
>  			continue;
> =20
> +		if (is_migrate_isolate_page(&folio->page))
> +			continue;
> +
>  		list_move(&folio->lru, &h->hugepage_activelist);
>  		folio_ref_unfreeze(folio, 1);
>  		folio_clear_hugetlb_freed(folio);

[Severity: High]
Does skipping isolated folios in dequeue_hugetlb_folio_node_exact() while
still counting them in h->free_huge_pages break hugetlb reservation
accounting?

available_huge_pages(h) computes h->free_huge_pages - h->resv_huge_pages,
so a free folio in a MIGRATE_ISOLATE pageblock still appears as an
available unreserved page even though it cannot be dequeued.  When
alloc_hugetlb_folio_nodemask() or an unreserved fault sees
available_huge_pages(h) > 0, dequeue_hugetlb_folio_node_exact() skips the
isolated folio and consumes a non-isolated free folio that was backing
h->resv_huge_pages instead of allocating a temporary migration folio via
alloc_migrate_hugetlb_folio().

Once the reserved free folios have been replaced by isolated free folios:

1. A page fault on a VMA with a valid reservation sees
   dequeue_hugetlb_folio_vma() return NULL and falls back to
   alloc_buddy_hugetlb_folio_with_mpol(), which fails with -ENOSPC (and
   delivers SIGBUS) whenever surplus overcommit is disabled
   (nr_overcommit_huge_pages =3D=3D 0 by default, or gigantic pages).

2. In offline_pages(), dissolve_free_huge_pages() dissolves the unreserved
   folio (dropping available_huge_pages(h) to 0 and shrinking
   h->max_huge_pages) and then fails with -EBUSY on the remaining isolated
   free folios because !available_huge_pages(h).

Also, is_migrate_isolate_page(&folio->page) only checks the head pageblock
and misses isolated tail pageblocks when huge_page_order(h) >
pageblock_order.

> @@ -3048,6 +3052,44 @@ int isolate_or_dissolve_huge_page(struct page *pag=
e, struct list_head *list)
>  	return ret;
>  }
> =20
> +/*
> + *  replace_free_hugepage_folios - Replace free hugepage folios in a giv=
en pfn
> + *  range with new folios.
> + *  @start_pfn: start pfn of the given pfn range
> + *  @end_pfn: end pfn of the given pfn range
> + *  Returns 0 on success, otherwise negated error.
> + */
> +int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long =
end_pfn)
> +{
> +	struct hstate *h;
> +	struct folio *folio;
> +	int ret =3D 0;
> +
> +	LIST_HEAD(isolate_list);
> +
> +	while (start_pfn < end_pfn) {
> +		folio =3D pfn_folio(start_pfn);
> +		if (folio_test_hugetlb(folio)) {
> +			h =3D folio_hstate(folio);
> +		} else {
> +			start_pfn++;
> +			continue;
> +		}
> +
> +		if (!folio_ref_count(folio)) {
> +			ret =3D alloc_and_dissolve_hugetlb_folio(h, folio,
> +							       &isolate_list);

[Severity: Medium]
When HugeTLB vmemmap optimization (HVO) is active, can
replace_free_hugepage_folios() miss temporary or surplus folios that were
just freed by __alloc_contig_migrate_range()?

Because dequeue_hugetlb_folio_node_exact() now skips isolated free folios,
hugetlb migrations in the range fall back to alloc_migrate_hugetlb_folio(),
which sets HPG_temporary.  When migration finishes, free_huge_folio() frees
the old folio via update_and_free_hugetlb_folio(h, folio, true); for an HVO
folio, this keeps a reference count of 1 and queues the folio onto
hpage_freelist for free_hpage_work to restore vmemmap asynchronously.

Without flushing free_hpage_work (for example via
wait_for_freed_hugetlb_folios() or flush_free_hpage_work(h)) before
scanning the range, folio_ref_count(folio) is still 1 here and
test_pages_isolated() subsequently fails with -EBUSY because the folio has
not yet been returned to the buddy allocator.

> +			if (ret)
> +				break;
> +
> +			putback_movable_pages(&isolate_list);
> +		}
> +		start_pfn++;
> +	}

[Severity: Medium]
Can advancing start_pfn by 1 cause replace_free_hugepage_folios() to call
alloc_and_dissolve_hugetlb_folio() on every tail page of the same hugepage
if it was not dissolved?

In alloc_and_dissolve_hugetlb_folio(), __update_and_free_hugetlb_folio()
can fail to restore vmemmap under memory pressure and put old_folio back on
the hugetlb freelist as a surplus page with refcount 0 while still
returning 0:

mm/hugetlb.c:__update_and_free_hugetlb_folio() {
    ...
	if (hugetlb_vmemmap_restore(h, &folio->page)) {
		spin_lock_irq(&hugetlb_lock);
		add_hugetlb_folio(h, folio, true);
		spin_unlock_irq(&hugetlb_lock);
		return;
	}
    ...
}

Because old_folio remains a free hugetlb folio and start_pfn only increments
by 1, the loop hits the same folio on each of its remaining tail PFNs,
allocating a new replacement hugepage and incrementing h->nr_huge_pages and
h->surplus_huge_pages on every tail PFN (up to 511 extra hugepages for a
2MB folio).  The same repeated scan happens if
alloc_and_dissolve_hugetlb_folio() isolates a concurrently referenced folio
into isolate_list and putback_movable_pages(&isolate_list) immediately
releases it.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106220812.2874=
571-1-mkbund@amazon.com?part=3D1

