Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8156CC531FC
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 15:19:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 644296B00CF; Mon, 27 Jul 2026 11:19:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FAFD6B00D0; Mon, 27 Jul 2026 11:19:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BABF6B00D1; Mon, 27 Jul 2026 11:19:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 18EF06B00CF
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 11:19:51 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9A61880774
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:19:50 +0000 (UTC)
X-FDA: 85034916540.09.3652F3D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6156880006
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:19:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=DRBgB5eu;
	spf=pass (imf30.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785165588;
	b=PmIW807d8f2X2Z5rdVJ+K5HeGQkpLuTjJ6XehZ8UWuse2uvcV4xzUaNBxZrlAzGtU6PgeU
	rAq2DlCaHpLt2TcsRXob75JgfG4TERebAzFU2nuQgd3ytgiQWW/R/isCIci4NiXQzc9c+v
	XyMrAK3x31jsd9YISsaSjeo4i8OhQu4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=DRBgB5eu;
	spf=pass (imf30.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785165588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kvFaYGmnPcUYTMTMoWdVLVVzjSaeldohJlXUNlxwbWo=;
	b=OdM9TF9qed60IJOIsSmnVJajOGh530aONLVMGBuEBioGxR6hf3mF3lAq+484FHYqmkMlIZ
	mr+wA9nJU8UvSz7hJWztMFz7/Iw+2BrhYhG4baX4yI4rEiWD9CMrDWsDFh4GdOXyP9BSBH
	qXDzWV59WpSw9I2OyW4/ax65+4OhqKk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kvFaYGmnPcUYTMTMoWdVLVVzjSaeldohJlXUNlxwbWo=; b=DRBgB5euulFhy0xU2HuVK0AR+J
	KyR8Ny4HEIa/BGaV3ArU4UbqXlOZheUfRnHdiZf5UnIPAy69Mnq2tlLNNmAyInO6StaHKy/fM9Sjl
	LPEkBN9DhmOevrhmbykAi9PKcuMt9QtuKBbUX4dUd9j8oN6jnQe+TpD7NuTsWWn08bWRHdtmeR5s3
	bJVr6Hv1AhEmxqgPScSi1cmbM8wJod0aNSeCRr49Dj1hoZG3JG5zaWmT9cKCfZvqNbfZCmAe8ZMc4
	VlWpmshZ+uot4zz37YUO1BwOw1Vsi14A+VYqXNQGBQ/zIvrLJdhOlgCa/ogYDejHE9BDDOm9K0WGp
	SkU57kBQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1woN7F-0000000Avqo-1yf6;
	Mon, 27 Jul 2026 15:19:41 +0000
Date: Mon, 27 Jul 2026 16:19:41 +0100
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
Subject: Re: [PATCH v5 05/12] hugetlb: Use the has_hwpoisoned flag
Message-ID: <amd3DRf6vOQjeFEN@casper.infradead.org>
References: <20260725160042.1557264-1-willy@infradead.org>
 <20260725160042.1557264-6-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260725160042.1557264-6-willy@infradead.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6156880006
X-Stat-Signature: w11hecz55qxr8reas9epwko88b81nef7
X-Rspam-User: 
X-HE-Tag: 1785165588-837356
X-HE-Meta: U2FsdGVkX18KHriAvSOteNoVSrtV+MsfhWA7CdvgNcw7Sm88limt0dTUVl1O0tfQ5JLtATGQ0Cx3NRQOvTRZO+4KY6z3fa2rUB6VwsOh+1GJsearijWt1osO38NKvPZZKKSqNQGvj4rGGfxmd38mkisw5v7DiqBUGrbW1mkGiOVOTrGv11J+/rYO1QaKs1E24OEyayCW0Hb4uX7anmz0OTBA9WtjSyFE1vcUWkU45Ii98GlyTBMzrNiM0kNSASYMDIkY2/LRPj9U3+UcU4qTEHjvmZUHCV0B531o3gQe040Ir+B8wn4hOMVxRd/BdgV2AJFVq8EQaqn2IkxjwByk1SfpMVxFL7z/iyqI/STw5zsJKwdxUYuY9RWBWi/+Yt6bDOWQVMXr2HrFNLxF5pKvNIuT9jQ8wBgHmWiDhM6/UzyS1gSDKIV+eJBl9k5cyd0O5hAr7t2t2L892ONsKo5Us8LGuFBnYUrgcSBYDqajzDeGRbTz8BgwCm5qfADT9FWxW+D+0jlyVqhiH/ogv5vutGIKEnHivU2E5V06wsoDR3FlDFG+nYKYVYKL9HXzlrNxI1x5S/6w/FXATEgoZhBdkPUoyi4WBGto52q+3NsaphCVx0ShhuFwd1fyhW6j1tqBtrXaKGcC8d9WfQtT/ayun1hukZXfpJgR6Jh4KU3sbKV4nr9YESC5R6LMB0f+bXhvFCkMr5aZEq4DN9jq00WudKKZtE3nGSGgGjCEx7xtm9IjFlald89ko0QpntNlJpb4HSThGuO09Y07eWlRsn/UWIvmHWcwdtvJEvm3IREMeCsRYfiZpFxn/pKCAMk30Qm1ukv3bObZuTrNf84bnVplLcK5jJEX6FJ9/UogHTjMV73w3GXr2ntx0vHj8IsSr9yJfrxfv1226CCTohmY2GwNTzq7DbFIKtLxeP4zJCIiJY5nBzzYzSWfxLE6MO41F7oTBf7j970D++hrxqyk1hm
 jN+wpQgI
 d2IZdFDJKBq+GKbAjAQ/wNL+9Il/vGYqwv4bMkpd3UHExHrmFdMrp5DxNikFKRYUcGEpMwvPjVdv6Yjm1bC2dZjaYGB5eQIiBts+ubcFQIWkkS/CfBzx3ZIfxsK/R7ycPAnincXb84pPKoa2CaExCQD/Q3ydxwnGESkbktNhUaiip81Dn8wyEmgRaoMDC43sXchBerW/sZIQoKyEKkoaP3OZazDZ8D/ulwmEwiJdXz+JEoonZzC0gqQXuqAL7DEDmZW4y4WBBfwZNmyn4Xp8ju0+w7HA0ix5fIcAUrQxZ+7EZuu3C2XAXIBwiCBPqxGiFqxGOMCO85HUeTDHMgTPLfCYC3Z5KdEFJG/GDeKbYxSUyga/J+omPuV9NzBn2BmVA09cJ+WE9+m/vM90BEoqNE9tbz/CftjeDofRB7yB/XDsgZts=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sashiko:
> --- Patch [5]: [PATCH v5 05/12] hugetlb: Use the has_hwpoisoned flag ---
> commit cca87d250a7a597186556cb9d897807edae0b82f
> Author: Matthew Wilcox (Oracle) <willy@infradead.org>
> 
> hugetlb: Use the has_hwpoisoned flag
> 
> This commit converts hugetlb to use the has_hwpoisoned flag to match
> other large folios. It introduces folio_test_huge_poison() for lockless
> checks to close a gap where a poisoned hugetlb folio could be observed
> without the hwpoison bit set during teardown.
> 
> > diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> > --- a/include/linux/page-flags.h
> > +++ b/include/linux/page-flags.h
> [ ... ]
> > @@ -1041,8 +1046,29 @@ PAGE_TYPE_OPS(Slab, slab, slab)
> >  
> >  #ifdef CONFIG_HUGETLB_PAGE
> >  FOLIO_TYPE_OPS(hugetlb, hugetlb)
> > +
> > +#ifdef CONFIG_MEMORY_FAILURE
> > +static inline bool folio_test_huge_poison(const struct folio *folio)
> > +{
> > +	return (READ_ONCE(folio->page.page_type) >> 23) ==
> > +		((PGTY_hugetlb << 1) | 1);
> > +}
> 
> This is a pre-existing issue, but does this logic fully close the race
> window?
> 
> The folio_test_huge_poison() function assumes the PGTY_hugetlb bits
> remain intact during teardown. However, __ClearPagehugetlb()
> unconditionally sets the entire page_type to UINT_MAX.
> 
> When __ClearPagehugetlb() is called, folio_test_huge_poison() will evaluate
> to false at the exact same moment folio_test_hugetlb() evaluates to false.
> Would this allow a concurrent is_page_hwpoison() check to miss the poison
> state?

Um, no?  Here's how is_page_hwpoison() looks:

static inline bool is_page_hwpoison(const struct page *page)
{
        const struct folio *folio;

        if (PageHWPoison(page))
                return true;
        folio = page_folio(page);
        if (folio_test_huge_poison(folio))
                return true;
        /* In case we raced with hugetlb transferring flags */
        return PageHWPoison(page);
}

We're relying on ordering; if we see a false folio_test_huge_poison(),
we recheck that the flag hasn't already been moved to the page.  Since
we always move the poison to the pages before clearing the page type,
I don't see how we can miss anything.

> > +static inline void folio_set_huge_poison(struct folio *folio)
> > +{
> > +	folio->page.page_type |= (1 << 23);
> > +}
> > +
> > +static inline void folio_clear_huge_poison(struct folio *folio)
> > +{
> > +	folio->page.page_type &= ~(1 << 23);
> > +}
> 
> Can this cause a data race on the page_type field?
> 
> In folio_clear_huge_poison(), the bitwise operation modifies the page_type
> field non-atomically. If unpoison_memory() calls this on a free hugetlb
> folio while a concurrent sysfs pool shrink calls __ClearPagehugetlb()
> under the hugetlb_lock, the UINT_MAX value could be overwritten with
> 0xFF7FFFFF.
> 
> Since unpoison_memory() relies on mf_mutex rather than hugetlb_lock,
> would this corrupted page_type trigger a VM_BUG_ON_PAGE in the buddy
> allocator when the page reaches free_pages_prepare()?

Hmm ... if we just move the hugetlb_clear_poison() call before the call
to folio_put(), that'll take care of this race, right?  Oh, but there's
two calls to folio_free_raw_hwp(), and the other one is when (ugh), we
don't have a reference to the folio.  So I think we wrap the whole thing
in hugetlb_lock to prevent this?

        ghp = get_hwpoison_page(p, MF_UNPOISON);
        if (!ghp) {
                spin_lock_irq(&hugetlb_lock);
                if (folio_test_hugetlb(folio)) {
                        huge = true;
                        count = folio_free_raw_hwp(folio, false);
                        if (count == 0)
                                goto unlock_mutex;
                        ret = hugetlb_clear_poison(folio);
                } else {
                        ret = TestClearPageHWPoison(p) ? 0 : -EBUSY;
                }
                spin_unlock_irq(&hugetlb_lock);

(this also includes the fix to the problem discussed below)

> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> [ ... ]
> > @@ -1498,10 +1498,10 @@ static void __update_and_free_hugetlb_folio(struct hstate *h,
> >  	}
> >  
> >  	/*
> > -	 * Move PageHWPoison flag from head page to the raw error pages,
> > -	 * which makes any healthy subpages reusable.
> > +	 * Move HWPoison flag to each error page
> > +	 * which makes any healthy pages reusable.
> >  	 */
> > -	if (unlikely(folio_test_hwpoison(folio)))
> > +	if (unlikely(folio_test_has_hwpoisoned(folio)))
> >  		folio_clear_hugetlb_hwpoison(folio);
> >  
> >  	VM_BUG_ON_FOLIO(folio_ref_count(folio), folio);
> 
> This is a pre-existing issue, but is there a risk of a double free in the
> hwpoison list teardown?
> 
> Both __update_and_free_hugetlb_folio() (via folio_clear_hugetlb_hwpoison())
> and unpoison_memory() can invoke __folio_free_raw_hwp() on the same folio
> concurrently. 
> 
> Looking at __folio_free_raw_hwp() in mm/memory-failure.c, it reads
> folio->hugetlb_hwpoison and sets it to NULL without any synchronization
> locks. If both threads read the pointer before either sets it to NULL,
> wouldn't they concurrently iterate the linked list and call kfree() on the
> same hwp_page elements?

I think that's right, but I also think it goes away later in this series
when hwp_page_lock serialises the calls to __folio_free_raw_hwp().

> > diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> > --- a/mm/memory-failure.c
> > +++ b/mm/memory-failure.c
> [ ... ]
> > @@ -2730,8 +2753,8 @@ int unpoison_memory(unsigned long pfn)
> >  			count = folio_free_raw_hwp(folio, false);
> >  			if (count == 0)
> >  				goto unlock_mutex;
> > +			ret = hugetlb_clear_poison(folio);
> >  		}
> > -		ret = folio_test_clear_hwpoison(folio) ? 0 : -EBUSY;
> >  	} else if (ghp < 0) {
> >  		if (ghp == -EHWPOISON) {
> >  			ret = put_page_back_buddy(p) ? 0 : -EBUSY;
> > @@ -2740,17 +2763,18 @@ int unpoison_memory(unsigned long pfn)
> >  			unpoison_pr_info("%#lx: failed to grab page\n",
> >  					 pfn, &unpoison_rs);
> >  		}
> 
> Does this logic change drop the ability to unpoison free non-hugetlb pages?
> 
> The refactoring of the if (!ghp) block removed the fallback logic that
> handled non-hugetlb pages. If get_hwpoison_page() returns 0 for a free
> buddy page, execution enters the if (!ghp) block. 
> 
> Because folio_test_hugetlb(folio) is false, it does nothing, drops through
> the entire if/else chain, and returns -EBUSY. Could this leave free buddy
> pages permanently poisoned?

Oh, I see.  I hadn't realised that case was also being handled here.
I'll rework it.

