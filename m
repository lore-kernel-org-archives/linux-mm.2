Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3348C55ABA
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 21:21:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3F426B0095; Tue,  4 Aug 2026 17:21:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEF1C6B0096; Tue,  4 Aug 2026 17:21:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2CFD6B0098; Tue,  4 Aug 2026 17:21:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8A8686B0095
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 17:21:51 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D8654A0316
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 21:21:50 +0000 (UTC)
X-FDA: 85064859180.26.9CC3420
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf27.hostedemail.com (Postfix) with ESMTP id B39EA40007
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 21:21:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=L4DABoEF;
	spf=pass (imf27.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785878509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qs1s8L5LRmXTdCMqmij4CMcIl3PXcjczNV0suhyRfvY=;
	b=ZYqZb+pr6ZOIsDD4/QStMvcN6xDm2y1jrPdKmqHL0SneVBpCGWry6DoMOjlNTMmkQxtq9X
	zGRc4RlFgZXRMpDphS8SlyfPrwWepP8bnc2aJhLCaZkUG89F6wbP5bvns+kkUhGDDPg1Gt
	FExYP7XalSrFhCH+//nVGA5J7vJWXfE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785878509;
	b=6QlOM3HYd8uoJqktwHwHIaw76f6QodkjRb+G/fOugn1o58Ntcay/N791yjUHTm+o0J0oGJ
	9o4h1KW2AC11M1UU/vCKePcOfPHUKI/leeVYJduD5ME1I0LqhOw7SWZOv+rR+GUG4KdfC2
	50Mv1uTPkrq++SHi+jnh/dvuipr9fhY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=L4DABoEF;
	spf=pass (imf27.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qs1s8L5LRmXTdCMqmij4CMcIl3PXcjczNV0suhyRfvY=; b=L4DABoEFIYp/1VRcJI3ynzeSTY
	ZBzpvXIDfmOkjlGTMXO9laKtVOr2MjBIxQz9m1EpPPGNQz81nmnCmYnrM0/gWqd64zj+JYeL3C5ec
	BsVVMBmcd0AThvU3YSsQUO4jrGPJ4hQn8xfWugSHaCVi4k8W3YCpoPyK16JkTGHrCCCyZloBIlehQ
	pMo6ANdAYk8TJG8hRs/LAjiia8Y1t6YkuSKs+XE2iEkMq9xP7S8M4W/w9ZQQh/eOsgqayTsSBDr6V
	tnf42RIM0J7ua1WffOiiMA9S0OtV3mP9kfonVuSRCUuUtUs86r/gYR27p2XPDSzr1PYczDGa1K3oF
	NBuphS8A==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wrMZl-00000004myG-3AFG;
	Tue, 04 Aug 2026 21:21:37 +0000
Date: Tue, 4 Aug 2026 22:21:29 +0100
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
Subject: Re: [PATCH v8 10/15] mm: Check individual hugetlb pages for poison
Message-ID: <anJX2bjH57IHz-jX@casper.infradead.org>
References: <20260731200802.574821-1-willy@infradead.org>
 <20260731200802.574821-11-willy@infradead.org>
 <anI5bPVScck1WXvh@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anI5bPVScck1WXvh@gourry-fedora-PF4VCD3F>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B39EA40007
X-Stat-Signature: 93od8hkra1whwbq8p7pmrk4fscbwbxfc
X-HE-Tag: 1785878508-679119
X-HE-Meta: U2FsdGVkX19Kn6GZh0vyNVqxEzsLIppha+ZKk+WbRBFZu0GUwzTt+1aw5n/hpmS57chjycwV/B5Nf7BVloaGjwjq0ksX5fRqDvTxcLCh5XH8Qy22pdQ/pzp6jt579f5TCS5b0UgKj5D5U1GJ7DXupHDJM/Dgapm+4XKRtIgNjZhQGNOkdgndF0a+VrgEYlMVARNoAc1pdYJ5Zq0X7SfBQPjkMfDynuCsdDX1ChyA6rTR4v6xRMYAlMVUi/R1SjvsjIwk/UwCEFsHwsRX1Oh8+lPEKRqiQw2LTEespqNrFr3hT+NxSPxoOlBL8VvLXsi5UR64F3bHolNijIDgpngVT9CX/XvMhusRZgMJhb0WJk+9u1fh+Un0sEcWoizgJ0ORbGkmnz5UeWdwtoNkSy1FfT5b4QpeOqKfuN850lBUWnnuDhRQQ8K9vGLZSaucjvshQtKTj4ITrE2Gb6FeVWBTWBqf2yw4Z5sqNWh9cAJxE7AvoPTNmf/pSzDHEbegFnn7IV6UzfsN/xUT2DA7nzb9HBHWsG2vDAGZXuAHAP84F/qXFUFC1bNvaGSTooE+LaYBmxSMRtF8F43YPkv7OONqTJn7W68f/HS4vApas75X5NRme7UKcW2DwSONN9QPayTkItUCFvT2gpe61wvM12y84Xe7CCcyvoft66hqdoZETPSju8+b9Z6qhrY1W5LoXc1w6GrkGwWp37C6LjRgGogWBaCzDOnab1Ng7lcZ/co6nf5nCtd21R7dqyiLZZZtM+DZZFwS6w0x1u00BtX/MIQM/1WLqE9McTxCQJxZ2lZmCp0TeAdAldwv0dmTH9C8BKSzjaXi5fD58Zo9d5XCm2SR4LbTSV/WD8BJfReNLmfVvcOpvnSTJo6rG3p797XOPWF0cbnyROKECHyvcjqATBID84npyrGiPrM8xqfj2LSZaoQuO5Wi5Ez3YK12JcYuJ/Ee1awoO3u3ds9vAO/uGIq
 C3pbHy9p
 /v6QdZEtV4S6rgjo4SGAthHiQlOdDUdAcNjr+KYOh8EO0gEKQuFlGAQ4lV5ZYt+MVUQkBf0jkCdY8iGxu8uTIaCy1v+5GeGZyt8EafhCXtM0EiBq/ArmD2bDuaH6Pca9JEaOgauZhD33AzG15NnaebCSkBkrHXjPswO3ti5+8+2kRpKoi6V/yWVaeB+jyMNH/jJTz6vE7g/ZIy8Mm3VRs3NW6KCMIDQbMpySNhQ/5ng3GXR0EJ5FhQBxYF+G7BOqI+vMNEdCp6lvQYsDlWwEaond1Cc3dHsfQeA/BQwZOC3jBaOLwBOtKPSs34G6759MuwHQs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 03:15:37PM -0400, Gregory Price wrote:
> On Fri, Jul 31, 2026 at 09:07:55PM +0100, Matthew Wilcox (Oracle) wrote:
> > +/*
> > + * We have no reference on the folio containing this page.
> > + * The hugetlb_lock keeps hugetlb folios from being freed.
> > + */
> > +bool hugetlb_unref_page_hwpoison(const struct page *page)
> > +{
> > +	const struct folio *folio;
> > +	unsigned long flags;
> > +	bool ret;
> > +
> > +	spin_lock_irqsave(&hugetlb_lock, flags);
> > +	folio = page_folio(page);
> > +	if (!folio_test_huge_poison(folio)) {
> > +		ret = PageHWPoison(page);
> > +		goto unlock;
> > +	}
> > +
> > +	ret = precise_page_poisoned(folio, page);
> > +unlock:
> > +	spin_unlock_irqrestore(&hugetlb_lock, flags);
> > +	return ret;
> > +}
> > +
> 
> I ended up with the same question as sashiko - i think this behavior
> implies we must hold a reference on the page, otherwise the folio can
> be invalid and all these accesses are unsafe.
> 
> But that must be the existing behavior for poison checks like this, so
> this is at least no worse. Not sure it's worth addressing.

Let me just paste Sashiko's comment in here so we preserve it in the
lore archives and so we're definitely talking about the same thing:

> This is a pre-existing issue, but does calling page_folio()
> here without holding a reference to the page risk a panic during
> lockless PFN scanning?  If a monitoring tool reads /proc/kpageflags or
> /proc/kcore, pfn_to_online_page() retrieves the page without acquiring
> a reference. If the page is concurrently freed and reallocated for
> driver use, compound_info (which aliases lru.next) could be modified.
> Could this cause page_folio() to misidentify the page as a tail page
> and return an invalid folio pointer, leading to an out-of-bounds memory
> read when folio_test_huge_poison() accesses folio->page.page_type?
> While the hugetlb_lock is held here, can it stabilize unreferenced
> pages that might have already been repurposed into non-hugetlb pages?

Sashiko is mistaken (... and fair enough, I suspect you aren't the only
human who's confused by this either)

It's quite right that we can observe a page in literally any state since
we do not hold a refcount.  But it is forbidden to use bit 0 of lru.next
for any purpose other than indicating "this is a tail page":

       /*
         * Five words (20/40 bytes) are available in this union.
         * WARNING: bit 0 of the first word is used for PageTail(). That
         * means the other users of this union MUST NOT use the bit to
         * avoid collision and false-positive PageTail().
         */

That's been the rule since 2015 with commit 1d798ca3f164

So the pointer we get back from page_folio() must have been a folio _at
some point_.  It may not be a folio now.  It may be a folio, but not one
that contains this page.  But it's not a wild pointer, and treating it
as if it's a folio won't cause any harm (as long as we're really careful).

Specifically, we call:

> +	if (!folio_test_huge_poison(folio)) {

and all that does is access folio->page.page_type aka mapcount.  So if
the pointer we have is not a current folio, it'll just return false and
we'll check PageHWPoison.

So the only case this can return 'true' is if the folio was hugetlb
at that exact point.  And we've got the hugetlb lock, so it can't stop
being a hugetlb folio.  At this point it's safe to walk the list.

That's my reasoning, and I think Sashiko has explained enough of its
reasoning to be fairly sure Sashiko is wrong about this.  But hey,
you're not Sashiko.  Maybe you've found a gap in my logic.

