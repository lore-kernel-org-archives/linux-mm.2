Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43909C54F54
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 02:55:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D289A6B0088; Tue, 28 Jul 2026 22:55:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFFCE6B008A; Tue, 28 Jul 2026 22:55:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3EE06B008C; Tue, 28 Jul 2026 22:55:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8C36E6B0088
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 22:55:17 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 095951A04FD
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 02:55:17 +0000 (UTC)
X-FDA: 85040297874.03.04E9BCD
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf29.hostedemail.com (Postfix) with ESMTP id EAC3E120008
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 02:55:14 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=IW6AfO+Q;
	spf=pass (imf29.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785293715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Gu5Num2xknD+iSWUiEOP3hmmUxH8WHbfsyozOqoPB4=;
	b=IbS4v6j0Wwl3QGDeagBJ1VQI4kAqEqk9bUEQLQTYZHJkzAlcov5JOcI0vg9C8EnrTHcRaf
	SVAadlg9d2dkyHwiMiYe6x5BSx5h9Nn3EzZQFy354v2k7291NawaepjvlyKRqkU0+kwvwr
	thkXx8nmAYwETTNvS7CRu24esn/XacE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785293715;
	b=34Tf10pV5AZti84skJDHXIbLkzda9XOeCqFyRgxIrnUZgjFqVndxv2IjSTsGTpY8Jpk5fY
	vd0V4qqfCxtpO9/l5hLIx1851lxP9KS6yQdQC8RFCBlJF3JgjFgsIMl/bUI12aAYka4tSH
	8ZpV2ppAwQINTivmTARa5kwMsMpeZJQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=IW6AfO+Q;
	spf=pass (imf29.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4Gu5Num2xknD+iSWUiEOP3hmmUxH8WHbfsyozOqoPB4=; b=IW6AfO+Ql8jIDXXzqJcDalbSw8
	KUcVJJ9nMB7BI93VpUXYAFGY3yjwmLmUKnX831IfMXwYgrny9DSgtEjzg1y4use9FqnyejzsaqVRq
	2k0MYuzWXI9gWADvQklRwrbBRTsfH2f/6O8iBspMmT4KgYY4W/qS1z92UlHMUYCgCRJZxEnk4inMj
	I2IIkhzQBxKzw00yL10G0TL0Qyh7jxYVpg7eI8lDiwUIOd8qV3Ke5hzRwwqHhHisjh0CvXsI+TfqH
	SHQc9sf/lk9qUMdfAtfYsv2QAt4NnRx+WFgSQFNBSrBBTMcJU3O9YECmM2SDfChoGOPZQxnHNWZ8Z
	2FyUvXAQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wouRq-0000000F0aA-1Ytc;
	Wed, 29 Jul 2026 02:55:10 +0000
Date: Wed, 29 Jul 2026 03:55:10 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Gregory Price <gourry@gourry.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v7 06/13] hugetlb: Use the has_hwpoisoned flag
Message-ID: <amlrjtaFSEQLYbEO@casper.infradead.org>
References: <20260728204409.3396238-1-willy@infradead.org>
 <20260728204409.3396238-7-willy@infradead.org>
 <amlQYkGgLmxmwX9_@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amlQYkGgLmxmwX9_@gourry-fedora-PF4VCD3F>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EAC3E120008
X-Stat-Signature: bwzyin9o64wy1fn4mjigx5z65najnqwy
X-Rspam-User: 
X-HE-Tag: 1785293714-259483
X-HE-Meta: U2FsdGVkX18uF8DAxvnO94VRZXWMjETeoTwgzYXPDDFxQFRx1L3ZKDMgHxgrJ8VR/GSLmM6KQSYp3hZbIZZRetxFGLyndqNHo9zxtchbi4kN3WRDAL/89Rze3PuzkF5VDGmChjg63UxYxHCX+/fQGd168IfyDjAOi8DSjoCe2iN9vR+d8h3JdEskCTLWgmFoz4PPgtjdD/pjxcCVs4/R2Jmf0PeV27ChGt8YPHqWOwoWGe2P5+UCzTFKv1pgDcRRtKtizJ0Sclg5hfndA8/c2IwFNFMO1zUYiSbln8l0Lql1ZtJepVpJhI91dLXA6Hm7Of2A3QG6kvKP18UP8JZvyMkM/GS9DoAzVpr/rk+W3ghhcpxxzCXfCXdSIgIVTZJfAUkEjA5NuS0QKwUskdmojqd/DcFL98v6wYI+AT40hsoHyEwtn/qci0BO0U0qZ4od3V3GDHx7C7JXwbf3IqIPlRCmw2FT0F1OA7O+GUnacHVI5d83pnO8u+Lon0PyjhEUKhp7rzFAWY4cihRfNB/ttSzYYY2NqjaEuUz8FnhvHaDEHdZZaaaCwY5Qlk6dKLgo6QWsCqzAkgT5cZ+0roUyxW006Tx6HYXE/3+fdkPAsfoD2EfjRZR6R936d5oFjN8HlaP4BobLyjOR8nE8f0jFT1ZiiT3GNSC97wdELZRECmjuPPpaI8I6lotay72Rs9hZAxVLIw5rP/VTsKeEfIzqyU2rngT+LvWS50+XYQNaNxcgmWuBcrpceTf0mhu2CNkD/sCJ01CG5eYy+2y/bmrnuZXMAn1ukuUVLCGK4Vd+nfVLBqhuK+RPEFfG0BlWURgPZ/0ulLgPbVgECiuzft3li8X3CtOlxU+F1lA9jlP1MsQh7sbHMNUrFtU81in6+laptQ+Ca/O/0V2KQMmcoHwDO1loAHqlC74Wn9h2rlokwcREnPdPvML1G5pDjBHkC6rGkMsjIEjbQEDDbGV8KFu
 yWr6cpD/
 pnYD3OTRT2LTTbD4ISoevQmfH+3RoiKY9vaB1G15v3lOxIGR7OlCVRlWdgCTRMTK6O8TUWFsxTcLyiA1MAIos1nQuZGxDLT1ABDfjJz3E9mIwCI7JRplL4k28ns8RHwLTwbwXPzsTvHfdVWKVpGx+196TrFuZyK+/zqXOKna/cY/few+rWj7B3rPpL+vVTzAx/1Ird48tXtuWtvfj4j6a/bsgyHCznKCrx7c9Ny1Y8p3BsKpWH2U5+SGteA5gZCSkC00MYlAoGS+V5dzimOofNoUDMsM4BpKzmnZw2rA4eC6BpoySLQGjOHcxrQEYBWH9s4w/rwB7lhArDm1X4y4CFfX4vZJtHE25418Nfssi+ovAsv5LCuL0BFg5Qg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 09:36:37PM -0400, Gregory Price wrote:
> On Tue, Jul 28, 2026 at 09:43:58PM +0100, Matthew Wilcox (Oracle) wrote:
> > +
> > +#ifdef CONFIG_MEMORY_FAILURE
> > +static inline bool folio_test_huge_poison(const struct folio *folio)
> > +{
> > +	return (READ_ONCE(folio->page.page_type) >> 23) ==
> > +		((PGTY_hugetlb << 1) | 1);
> > +}
> > +
> > +static inline void folio_set_huge_poison(struct folio *folio)
> > +{
> > +	folio->page.page_type |= (1 << 23);
> > +}
> > +
> > +static inline void folio_clear_huge_poison(struct folio *folio)
> > +{
> > +	folio->page.page_type &= ~(1 << 23);
> > +}
> > +#else
> 
> Took me a second to realize why this was open-coded instead of using
> the generator macros.  The reasoning is buried in this comment:

I believe hugetlb is the first user of the low 24 bits of page_type.
As such, there aren't any generator macros yet ... and I'd probably want
there to be at least three before creating any.

> /*
>  * Check if a page is currently marked HWPoisoned.  This check is best
>  * effort only and inherently racy: there is no way to synchronize with
>  * failing hardware.  The caller may not have a refcount on the folio
>  * containing the page, so we must be careful to not trip any assertions.
>  */
>  static inline bool is_page_hwpoison(const struct page *page)
>  ...
> 
> which i presume is referring to VM_BUG_ON_FOLIO() in the set/clear in
> the macros.  Might be worth just note here if only so no one comes along
> and "fixes" this or writes more of these without the same reasoning.

It's even in the test ...

FOLIO_FLAG(has_hwpoisoned, FOLIO_SECOND_PAGE)
#define FOLIO_SECOND_PAGE       1
#define FOLIO_FLAG(name, page)                                          \
FOLIO_TEST_FLAG(name, page)                                             \
#define FOLIO_TEST_FLAG(name, page)                                     \
static __always_inline bool folio_test_##name(const struct folio *folio) \
{ return test_bit(PG_##name, const_folio_flags(folio, page)); }

static const unsigned long *const_folio_flags(const struct folio *folio,
                unsigned n)
{
        const struct page *page = &folio->page;

        VM_BUG_ON_PGFLAGS(page->compound_info & 1, page);
        VM_BUG_ON_PGFLAGS(n > 0 && !test_bit(PG_head, &page->flags.f), page);
        return &page[n].flags.f;
}

So there's two asserts that might trip; the first if the folio is freed
then reallocated into a larger folio and the former folio becomes a tail
page.  That's pretty unlikely for a hugetlb folio, but the second is
more likely.  That'll happen just by freeing the folio.

> > @@ -2725,13 +2748,19 @@ int unpoison_memory(unsigned long pfn)
> >  
> >  	ghp = get_hwpoison_page(p, MF_UNPOISON);
> >  	if (!ghp) {
> > +		spin_lock_irq(&hugetlb_lock);
> >  		if (folio_test_hugetlb(folio)) {
> >  			huge = true;
> >  			count = folio_free_raw_hwp(folio, false);
> > -			if (count == 0)
> > +			if (count == 0) {
> > +				spin_unlock_irq(&hugetlb_lock);
> >  				goto unlock_mutex;
> > +			}
> > +			ret = hugetlb_clear_poison(folio);
> > +		} else {
> > +			ret = TestClearPageHWPoison(p) ? 0 : -EBUSY;
> >  		}
> > -		ret = folio_test_clear_hwpoison(folio) ? 0 : -EBUSY;
> > +		spin_unlock_irq(&hugetlb_lock);
> 
> Adding new synchronization here without noting why - it's not
> immediately clear what this synchronizes.
> 
> Is this just fixing an unrelated bug / should it be a separate patch?

This prevents a hugetlb folio (which in this arm we don't have a
reference on) from being freed.  I think it ended up in this patch
because Sashiko pointed out the race during review of this patch.
It could probably go in its own patch 

