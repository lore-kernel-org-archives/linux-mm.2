Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E750BCA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 15:21:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78BDB900255; Fri, 15 Aug 2025 11:21:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7631E90024B; Fri, 15 Aug 2025 11:21:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A078900255; Fri, 15 Aug 2025 11:21:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 529A690024B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 11:21:37 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B3A2FC01E8
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 15:21:36 +0000 (UTC)
X-FDA: 83779356192.11.637001B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7A3B6C0013
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 15:21:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=AKcb396S
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755271295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ckWSyQm27ceppsDFfNgJVy7L1x6OANk8Hk0vUn3JOSQ=;
	b=0vxorZluV7N1g1+uKxYYDSKZZWLA2cmQCSHwfnX1lZpehcpWevkvo2RByHW6n236X7ezo+
	CUixbpdigQaIdJaG7YnorKA9VId0rVb/OZtUbmQf9XKs7jmYpFztw8PH0VT0duw/8qTMW5
	MUK6iOjJHDI4Ysr4buDpVPqJa8fnOm8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=AKcb396S;
	spf=none (imf10.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755271295; a=rsa-sha256;
	cv=none;
	b=hunsuhIV8TW9hcdT+/bKDNCGw/Y2P8+7oKKNPbocG9sApioad1vXFVa1FXAkl5M7ZH7O4L
	i80o0Y5kXib8nkBCKuTop6SEhp7lqOvRjM3g+HcotIGNzBc1+StFpeOrsGhuHcQSpHZrS+
	SQJ2IWmZC1qXr/dZStzfu381vLQaJqY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=ckWSyQm27ceppsDFfNgJVy7L1x6OANk8Hk0vUn3JOSQ=; b=AKcb396SU//d/ev41/4z3OEllO
	an25qOeVMOy4sA/KMMDzLDEk4kcxAMuFwTOBbw3aBHAPWeyRueU2Tqr4gknrqGeV0IoWJYEjmu4wx
	FJ9QeiOBX3LuwNGrnl4RiwocAJ8D6d6BhJCQBbwTbHgTLfffJ/kuycjXSQCFkWcSgFSNCDS6axWap
	4UwaLKyGyh0HqAWLG75LXQCw9W2hsM6t0vXMXw/VyK1S9gyMQSaKgQ8Pg0yHv+YqZILX88H8+zavG
	Kf9I5J5gpUqqi7nLejN3AMAkUFbBPvdlgfAszL8LLFOF/bkI9KJcYWBYQ/mpMl7MpqGQZKR853hYr
	E3hRRs6w==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1umwFI-0000000ELoM-19fp;
	Fri, 15 Aug 2025 15:21:32 +0000
Date: Fri, 15 Aug 2025 16:21:32 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page-writeback: drop usage of folio_index
Message-ID: <aJ9QfA07LTEUyhti@casper.infradead.org>
References: <20250815121252.41315-1-ryncsn@gmail.com>
 <aJ8m42sM1NX_wEE9@casper.infradead.org>
 <CAMgjq7CYzdmt+mJbbkrskiksfvXuhOhLQ72hTnqGhc5nu8uH0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7CYzdmt+mJbbkrskiksfvXuhOhLQ72hTnqGhc5nu8uH0g@mail.gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7A3B6C0013
X-Stat-Signature: 1i1cxghms3sh5m6rig87ewom6fjiyrt6
X-Rspam-User: 
X-HE-Tag: 1755271294-541290
X-HE-Meta: U2FsdGVkX1/DB9oZqKlsxlLymswSPbazF1WDUi49T3qa5yhuIvaZ9pMuJQs2ExDO80M9Byt8HYTHJfqPBVAsY7+oEmfdDdHHcXQg1L6lxhYko1/EyAyD4+TFMf3r0ZPOZXxBustOEoOQzOtll4kCiYwfJ9UZPSz7vX2dkZlgc5x+XpaXPiDj73d76CapqPMA9pwGUrtoVlbw2M2487rUusrdM5mBzEuhGAAahyvwlw8fDcfo2vjUxbtkMekxNQC38sA75PRPECfJMCeH54MpNWqzxggrRvpDNY//nlZzl+Ua7uPmM+QVW0OYANpANEGdd8/ZLWRQpUwxYY6YUtQ/2kFRbFrF+MVlfFEIpoJi4xlpY7u1jv71NOFaQ/LGmuvAI0wRj+ubTdoZqxJBBsmkpGCmpZfQBLdpbIZO9yby5EMJx6m9NXOPnEudPiuVHXd86VuYeh7zP48mBSvGduSVSccuZvPppYfTQ589alvCY0gnIZ1ltVTQvmwZWswOJQ2KBGmNJ+vnP+o39oGx4On0WySie3FSvNJ9hX6Dyjjv/HLezaDVLF+eYhzWoU9ArpOJRZ7AFnfQdnQi5IdUWGdHL1ORszjcszeT9IbagQkh4mF79Qpt2198RsSj0TN6DDIkK5MKQMZuVVqFhpCdrPrwjjwx8QgSjdcQIxHCvDUyr+p478/atjEyhBpa2qYvUm3DNPzEygsBDVRzL5oly9pdZBxy3kBkRylA6D1uWY/rKyhc75YG0bvqzmZOvOdZEwaNH/ev7CtesBi7dz/h+XFLKUaE4tw4y1fWYq506qRhjBcDd3UGrN+DO8FEkp8Y09xOeZm+1YLjQj68ihMYwSiI5FWT4lcMo6dwlwU6bL5pKKOs9gDps71x0WA42JvJpkDvn5xZ2VSMG8Xc24NMAG7TtfUAXQ4D6VGwSSDG+R3kopBJkUpgrzfKtpx1V8H4JUA1ihD2l+WqFRAlrgvWGRK
 47DIx28g
 VtOQa6kb+KG//1t4Wh1cu627S5xHr3JW+6j6LF+FzemrjBnHcPzQ44CDQpyQxgp/U27rxGg//y9KTxrEydrCjJ+uyXc6Ktd5sQ0Y1zXCoHg1+7E05BDVxkax8yyAjFDmFsUc8c2vnHTGa83SIh20+tZoXnpklP6JW5jxZgf7MjSO21/VRbw86BOGMmGHKvuK8M5LOwMScQSJvzxDSlChOcUcbPRHpKbIoJrbD3KDEVkdcG9NoZQQsE4sX7lTNqRBXXU51Do+/nBiNzW8d930k50ZIN6BhRkb5HBq9YTNxlCxbfuUuAwb4Y3kj8Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 11:03:56PM +0800, Kairui Song wrote:
> On Fri, Aug 15, 2025 at 9:48 PM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Fri, Aug 15, 2025 at 08:12:52PM +0800, Kairui Song wrote:
> > > +++ b/mm/page-writeback.c
> > > @@ -2739,8 +2739,8 @@ void __folio_mark_dirty(struct folio *folio, struct address_space *mapping,
> > >       if (folio->mapping) {   /* Race with truncate? */
> > >               WARN_ON_ONCE(warn && !folio_test_uptodate(folio));
> > >               folio_account_dirtied(folio, mapping);
> > > -             __xa_set_mark(&mapping->i_pages, folio_index(folio),
> > > -                             PAGECACHE_TAG_DIRTY);
> > > +             __xa_set_mark(&mapping->i_pages, folio->index,
> > > +                           PAGECACHE_TAG_DIRTY);
> > >       }
> > >       xa_unlock_irqrestore(&mapping->i_pages, flags);
> > >  }
> >
> > What about a shmem folio that's been moved to the swap cache?  I used
> > folio_index() here because I couldn't prove to my satisfaction that this
> > couldn't happen.
> 
> I just checked all callers of __folio_mark_dirty:
> 
> - block_dirty_folio
>     __folio_mark_dirty
> 
> - filemap_dirty_folio
>     __folio_mark_dirty
> 
> For these two, all their caller are from other fs not related to
> shmem/swap cache)
> 
> - mark_buffer_dirty
>     __folio_mark_dirty (mapping is folio->mapping)
> 
> - folio_redirty_for_writepage
>     filemap_dirty_folio
>       __folio_mark_dirty (mapping is folio->mapping)
> 
> For these two, __folio_mark_dirty is called with folio->mapping, and
> swap cache space is never set to folio->mapping. If the folio is a
> swap cache here, folio_index returns its swap cache index, which is
> not equal to its index in shmem or any other map, things will go very
> wrong.
> 
> And, currently both shmem / swap cache uses noop_dirty_folio, so they
> should never call into the helper here.

Yes, we've made quite a few changes around here and maybe it can't
happen now.

> I think I can add below sanity check here, just to clarify things and
> for debugging:
> 
> /*
>  * Shmem writeback relies on swap, and swap writeback
>  * is LRU based, not using the dirty mark.
>  */
> VM_WARN_ON(shmem_mapping(mapping) || folio_test_swapcache(folio))

That might be a good idea.

> And maybe we can also have a VM_WARN_ON for `folio->mapping != mapping` here?

I don't think that will work.  We can definitely see folio->mapping ==
NULL as the zap_page_range() path blocks folio freeing with the page
table lock rather than by taking the folio lock.  So truncation can
start but not complete (as it will wait on the PTL for mapped folios).

I think it's always true that folio->mapping will be either NULL or
equal to mapping, but maybe there's another case I've forgotten about.

