Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06731C531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 13:21:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 901356B007B; Fri, 24 Jul 2026 09:21:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B1F46B0088; Fri, 24 Jul 2026 09:21:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C86E6B008A; Fri, 24 Jul 2026 09:21:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4D1D26B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 09:21:11 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D30DDA0B25
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 13:21:10 +0000 (UTC)
X-FDA: 85023731100.12.7D46632
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id 816E0A0013
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 13:21:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Lr0qAArm;
	spf=pass (imf15.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784899269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B1sCc/4/2+c9lGryyMIrT+t7xrQYTOS4UkDA1UHfcbk=;
	b=b8JuhqcPiJV4fIbgJs11Fir4lQqHJr5Mj6lpZcP2hhnhPe8Fni5/xUQJF2yVnP/qq2D5pg
	M9Y3F3DkgrIUvoFVNzBF3+mwdBEVpMECIfVYwE6tqVPPPoMowshYqpx+1ah/YoDOOgVoGU
	1p/jVUW9UiMmwL3TS6Ol12mi0vONdDE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Lr0qAArm;
	spf=pass (imf15.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784899269;
	b=Ri8UmlFNIOcHHdDEghEzcEtbfH4XkO6oD7vl/sIoup2fV6QzEB6a9AFeryR/+Q9x8UC4Yr
	y3ZJGBIHx9ZoW4dLK5dFkHlonB54kF58vUk5QuN4Wo7PlRbembdMb+5Y2qywJzMLNKcYas
	AidTTGEXE8C6QDa8UI8XW87v3zLDV1U=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=B1sCc/4/2+c9lGryyMIrT+t7xrQYTOS4UkDA1UHfcbk=; b=Lr0qAArm/6fzGDvHy+WFibQPFT
	H4P7PEcDF7n5ILR+emVLh4kAJdiZiQ4FCxf/S4iCdZz79LfMHlcEevk3lQkvCyzMDMs70FXx+HBQ6
	qlOnAagDuOqQDAj1HD5cCLfucV8qN6GsZm1l6Pq1DQ3S57AmsdlZIa1q2wAUgkHXjJkIDFGHLZSzY
	q8H9FAD8XXcEBUvFHuX4jL2v4MWT1pB3c/mKzZAficbtwGTfXzxqynN6EqL9koZGpbc2Km7b8t7s9
	QZj/tI8UgrygUuej7T17juSh7ycCf13QflR2CELqhChJAe292dAACVmcbLTzHBIHpeHGGRjQ/cxXb
	e1X/mf7w==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wnFpm-00000003XfT-3Efs;
	Fri, 24 Jul 2026 13:21:02 +0000
Date: Fri, 24 Jul 2026 14:21:02 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v4 07/14] hugetlb: Use the has_hwpoisoned flag
Message-ID: <amNmvtOLZxEwF-cg@casper.infradead.org>
References: <20260723143034.175661-1-willy@infradead.org>
 <20260723143034.175661-8-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723143034.175661-8-willy@infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 816E0A0013
X-Stat-Signature: r68x1uqki3oacuzzhn7tbqbirh6gxhun
X-HE-Tag: 1784899268-924720
X-HE-Meta: U2FsdGVkX1/+bs9DTSHFkxkBYUBthMc3Zf4gNW/s2nGsGnhUxwhv/43z9AG/79O0Nlg1Q3z+doJzPGL6DOBpu7qXpHBqrxz815dtxcgXzYklnFZJu5UPOyA39FhBA06azJWn5MO4U/mw1fHnTSFm6ImA3Dn7PE2sypGHXjj/xHuIqtMspbInT0TRhoxjRovUGkTyoVBl0YFpdPdFF53fvmY2P5+9g1V65uemcoesGlihDBUDzXcWp4FP4rNnUy03Ay+rOiTFyuIX89GXEH+wMq7+00qcGANd3FMKVGKht7oDGArFUZ+KPiXLFmsdth5DxYdDkP7ijFVEbFXEzIARo/Zdaa4toUPqWaoXhkscCXjhAgCM2Gnwxw/L8TJ+b78mPAQY6wCdPKhoMJ91snjpW8z97NbTJn64qimuqcZKhoPQceSYo1zwJ4XOWYjVPZBJdyJwHh7D0wKdrQTpf8Qk5txVm/Ol8wlM+7HgLn2Ppy1JNYOl5VwZu2WsaB+2ks7vQgvivehAq3p2Ie1qVil6lgt/IYQv3/TUFxfeT4Wpq+ZrKNOUXPPR4LhAtjssgUds1In5FmJsiS3myoEYr9ROoY2sKhyo4XvgySI37hZpE2liezb/MTWr2FjphSuWQ197W83jLXh4+fM1ymoOLEcJpoTbxVlg2YljnwcJx2VPkH+g5UpK29y8AG445hLH44NjuJ21pkTuaBr+SZkQMVTwLhjSm/+MsAa1Y+4ZeHh8dtbJIQUesw5kSbNpOeYC84E/rEELEQZx4ZGgFV5QjPmz8Zjv37JalPyxb5sKlgI+tep03rQg0YKS9+R8MdN3CcD3fNkad2q80NxF7kFLCT8/PR4WgXt7+wZjHEnSir3gI9Yukne7XuJDYbwMkATzIwFPgMEAbMHk3pcULEbK8ycsW84DrPHGCyVPFiP6Qa5xhyAf14CWO/nc5OBVItFsyOTcpj5HvfNuf0ljk3VqAJw
 vDvEFvJg
 TJ1KTX7DtIzKVBtVFNkZepEsgceaEkb8mMvHm6Zl0JoGhylzoSVEv+PlJRJDFGYIaeQzsI8gVM2BqiFiscRFkNPeG5ollGGH+bnVSPEeaDq6rOSI+zg0hu+NoDbToxTPkhFEW4u0LyWNaSIQ5lR6K+C1lR8YvOUsH968TCwV1FuGb6LkiGVR/185T+6G1I4hEXjhECA50dS24z4PFWAuOyzEQMvG+LpOlKDXm/cwKDX8u9dAxWi1eoVk30YJa78Hx4UEdlSCWaxNzLcPasLSEhdwqZseswtfKEyI1xBfnxy0LtDbQofIbg8DgBU10iKo6qGhrmRN7b7u91D7JewKCc+12Tu6Gv/nvtjCDO+qi10F7Mn0GUALDQsYH0RE8gb//LlWRJ1VqBsGcRyAmSMWVHbK2pJQ2h74VyCnB2HcKlOneGcTdGEMNr67a1uNSYz7cJBMdjkEGn5Cl4po=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sashiko review:
> --- Patch [7]: [PATCH v4 07/14] hugetlb: Use the has_hwpoisoned flag ---
> commit f67cbd0b3ba7a67258490d423b9fc8352cb972aa
> Author: Matthew Wilcox (Oracle) <willy@infradead.org>
> 
> hugetlb: Use the has_hwpoisoned flag
> 
> Other large folios use the has_hwpoisoned flag.  Convert hugetlb to match.
> This will help us use the per-page hwpoison flag in the future.
> 
> > diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> > index 18691c905ac94..4200deab2c3c4 100644
> > --- a/mm/memory-failure.c
> > +++ b/mm/memory-failure.c
> 
> [ ... ]
> 
> > @@ -1874,6 +1874,23 @@ static unsigned long __folio_free_raw_hwp(struct folio *folio, bool move_flag)
> >  #define	MF_HUGETLB_FOLIO_PRE_POISONED	3	/* folio already poisoned */
> >  #define	MF_HUGETLB_PAGE_PRE_POISONED	4	/* exact page already poisoned */
> >  #define	MF_HUGETLB_RETRY		5	/* hugepage is busy, retry */
> > +
> > +static inline int hugetlb_set_poison(struct folio *folio)
> > +{
> > +	if (folio_test_set_has_hwpoisoned(folio))
> > +		return MF_HUGETLB_FOLIO_PRE_POISONED;
> > +	folio_set_huge_poison(folio);
> > +	return 0;
> > +}
> 
> By replacing folio_test_set_hwpoison(folio) and no longer propagating 
> PG_hwpoison to the head page, does this break memory failure unmapping and 
> silently bypass hwpoison swap entry creation?
> 
> If a hardware memory error occurs on a tail page of a hugetlb folio, 
> memory_failure() calls TestSetPageHWPoison(p) on the exact tail page. It then 
> calls hugetlb_set_poison(), which sets PG_has_hwpoisoned but no longer sets 
> PG_hwpoison on the head page.
> 
> When unmapping the folio in try_to_unmap_one() in mm/rmap.c, the code 
> extracts the base PFN from the hugetlb PTE, calculates subpage as the head 
> page, and checks PageHWPoison(subpage):
> 
> mm/rmap.c:try_to_unmap_one() {
>     ...
>     VM_BUG_ON_PAGE(!PageHWPoison(subpage), subpage);
>     ...
>     if (PageHWPoison(subpage) && (flags & TTU_HWPOISON)) {
>         pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
>     ...
> }
> 
> Since PG_hwpoison is no longer on the head page, this check fails, triggering 
> VM_BUG_ON_PAGE. Without DEBUG_VM, the code skips inserting the hwpoison swap 
> entry, simply clearing the PTE, which silently allocates a new zeroed page on 
> subsequent accesses instead of delivering SIGBUS.

Oh; this is a good catch.  I have now reworked try_to_unmap() to handle
hugetlb pages a bit better and it'll be part of this patch in v5.

> > +
> > +static inline int hugetlb_clear_poison(struct folio *folio)
> > +{
> > +	if (!folio_test_clear_has_hwpoisoned(folio))
> > +		return -EBUSY;
> > +	folio_clear_huge_poison(folio);
> > +	return 0;
> > +}
> 
> Does this sequence open a race window with concurrent hugetlb freeing that 
> results in memory corruption?
> 
> When unpoison_memory() is called on a free hugetlb folio, 
> hugetlb_clear_poison() atomically clears PG_has_hwpoisoned first. This 
> exposes the folio to concurrent hugetlb demotion (demote_pool_huge_page()), 
> which can pick up the folio and call __update_and_free_hugetlb_folio(). This 
> function sets folio->page.page_type = UINT_MAX to return it to the buddy 
> allocator.
> 
> Concurrently, hugetlb_clear_poison() proceeds to execute 
> folio_clear_huge_poison() (defined in include/linux/page-flags.h), which 
> performs a non-atomic read-modify-write:
> 
> include/linux/page-flags.h:folio_clear_huge_poison() {
>     folio->page.page_type &= ~(1 << 23);
> }
> 
> This non-atomic write can overwrite the buddy allocator's UINT_MAX with 
> 0xFF7FFFFF. When the buddy allocator receives the page, it expects 
> page_type == UINT_MAX and will crash.

I'm not sure that it can be demoted while we're holding a reference to
the folio.  But I think it makes sense to change thusly:

+static inline int hugetlb_clear_poison(struct folio *folio)
+{
+	if (!folio_test_has_hwpoisoned(folio))
+		return -EBUSY;
+	folio_clear_huge_poison(folio);
+	folio_clear_has_hwpoisoned(folio));
+	return 0;
+}

(looking at Jiaqi's patches, maybe we shouldn't be clearing has_hwpoisoned
before freeing the folio?)

