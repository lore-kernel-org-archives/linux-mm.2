Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D155AC53209
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:44:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D76D56B00C7; Mon, 27 Jul 2026 10:44:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D279D6B00C8; Mon, 27 Jul 2026 10:44:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3DA36B00D5; Mon, 27 Jul 2026 10:44:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A04976B00C7
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:44:02 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 35E01A079D
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:44:02 +0000 (UTC)
X-FDA: 85034826324.18.7D00C16
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id 61D48A0009
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:43:59 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=FzSS4rVN;
	spf=pass (imf15.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785163440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/qlnN76+tF13o25mQrF2tByNLJl9jVDI3UupoYwfeo8=;
	b=gxgZeg3ZNwmd1NSYP4o/OoY+sld+OC9lONOdQDf7tzgK3SQLQICZM/Y5JQ7pjwMPJ95b4M
	DcqeKe/R/KeftUyMLcIZO6spcMIvUk/3xyyATJsP61W7iM2MjSq/MoNNAZ2bgFwATTNWHX
	QVeXXzIhx7wzIYj8YfnpHpP1lf20xyM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=FzSS4rVN;
	spf=pass (imf15.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785163440;
	b=u0M1srLjBFMLI+ECyDDhdyvREGknA0GlSrn1NqZBOLHN7YAWGXmES3tb8lgG1Mfri1s4d1
	/VWNVD8MUbkCFdiP+T1wDTHQ71Uo505i+aEsCn8rPdsx/S3A2Jv14KK+t3jprI8yI9GHHs
	aDMsUJIveEgQArL5nXjyVr85rtylQjg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/qlnN76+tF13o25mQrF2tByNLJl9jVDI3UupoYwfeo8=; b=FzSS4rVNlmr2vAmNPfcByvvRVm
	muTlKZJB75MZFWDauFFbHpKxidXffT1sKlfKz8rKlrdtgWFJWlHLVN7jKkJT5trsA9spB62OyXr+o
	vzS1ITss3JwL7f04WZ8KhvlO1pYqxJ88MnPFnPC3n0wZQdK9tBUSAHY128m92RQ6g99YYI8UoOUbr
	lBxtt2hfFJO4tS3O2XVllmCDs6vWz6AZ9eNXcqw8BOaIUZm6AVhwkb58EH3i8+19A/XCiJvFLpTU0
	zpymd//i1OPXyZAp1KS6a/su4PpSdMOtrLGgcidm7Rgh/UBQu+MhuD+yTNaeQ5y6/fl2XQ+pxQxEg
	278UE33Q==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1woMYb-0000000AsJm-1HZL;
	Mon, 27 Jul 2026 14:43:53 +0000
Date: Mon, 27 Jul 2026 15:43:53 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>, stable@vger.kernel.org,
	Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: Re: [PATCH v5 01/12] memory-failure: Fix hardware poison check in
 unpoison_memory() again
Message-ID: <amduqWdnxeYwToax@casper.infradead.org>
References: <20260725160042.1557264-1-willy@infradead.org>
 <20260725160042.1557264-2-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260725160042.1557264-2-willy@infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 61D48A0009
X-Stat-Signature: 7dpwez1mkdwwg53tf6ofi9mzox7pmod9
X-HE-Tag: 1785163439-482851
X-HE-Meta: U2FsdGVkX18MwoTB+bcefYaJTh+gHKlalezqb0uEVlMSfJ2prDHDC5f5PXjwW80QzD0HQ74wIhjG7fDKRofQ2nBId45bKUrg+Re1CtWjxemwvYFmBAnokYcJNz/pPyp7G9Vb4FAN7rcaa4h7sq7pC0HOzg1v4o11dF/pegtpZJkJcAsMtipZMNxlBLC26j1mJ/qms+yi+AyTfHoO9fVKmzofZC6kPYHK0D9oj7JRZHVOXsmvhimDqlnaOlska6EJXKQXIFWO5+X9i7uBAcARfkpK6qCVfhbppKfIWe2ZwnK5sSSp4z+JMPn/va09wYF81YwXKl/EKSCMVYX0ing6G5KdX8nvtRt/yDq82xhmHhL030yJaqbJa8v8GGz2SQXYjSZZ2F0DBwX7E6pkDwmFvxnYFW/0/z7lmytT5fj6PzZzJZDEhu8vOEVV59GwjRD0zljAYkEcRbQIzE2ZSkY3H0YIVsfdaBsE8y9qRUfrtf1+6fR4879C0jOhcx97fV6z1fs/i0WxA4MC90+xiz3X7XeEQl1DgHzm+R+ehmAxaeuVXH6xfEjVDj1fumuIjxanlgI6IgtWi5PfZL7s+e5B9Amfa1S/SZ5pPxBnR8mK1bcv8ZVfCKxT5dDEG5wJCAM4TLFgEhKsGCj5um4dVLZKSJ5dNaHJmbufWwmQYd0cBW0DhZaNQQVqfbruTqdeEJKof2H5o2DQsSQKRMvxS5ZUHddvERZFwtN97k19x4jOND1znkNaX4F16pqLdkFrF1f73bW6KRsvthWZeX36a5nbfHrojv5QsXDc3cqU8D6FnNi0LbLEZpQG5WDkZTyiYbdcLAgErsJsmTO/Gm4wP2tSXF2Pzv30Je0a+O6fvpkEeFUOYtBO2rcYRzZ8EvCIg2bc+fIcboWSKo6mwmfu1rUfjP0ho3UzOgcM+4wcSMCH0mdgbk77o70WFRmGSbWEayGpcTmge2sJ6pWdyHYwB0Q
 tcv/89ik
 xUb8gdtzruuNr8eAcHZ6MEtFDVsqE2uiqOZO/b3L5NRWj/gjnjHIpoHSW2UmbWCrzUuQCeOoB3QtfF+v2hOpXcIIolqhRrCiraRG2w1j6wv5XDldvx3vDPx3XO6cyyagjbU4OsQMKkoUMito+eAjtSDw6FOPi7yTARIJKBeIpplnNogqFy5xGI0d6y2UkGGZzUMFLHQNaA8FZUDIcz6+G+qbzOzABjY+63L8AeFPbVGPmclbPjeyDgL181tmhqYaJ0Xkram6vmjiOD/Uygucqlw3CNOzZOQANIxcD7T+Dm1EdrN7M5prPhEIu3fQsD0tMmfQQBGbXc6Umz56k64OWoAR3kaM2+GPUevI16SvCy4mIYwGrcemOiqD/JPQymO68RhuOvm5ctDbZcD6VPCPXIxW7yGfIolDlsNpe7ExxdZNPQlI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sashiko:
> --- Patch [1]: [PATCH v5 01/12] memory-failure: Fix hardware poison check in unpoison_memory() again ---
> commit 4beed8e27f2afa68261389ac2133cfe324d37d0e
> Author: Matthew Wilcox (Oracle) <willy@infradead.org>
> 
> memory-failure: Fix hardware poison check in unpoison_memory() again
> 
> This commit modifies unpoison_memory() to use is_page_hwpoison() to better
> support hugetlb folios and ensures the HWPoison flag is cleared on the correct
> head page.
> 
> > diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> > index 51508a55c4055..944e6e1d49719 100644
> > --- a/mm/memory-failure.c
> > +++ b/mm/memory-failure.c
> > @@ -2695,8 +2695,8 @@ int unpoison_memory(unsigned long pfn)
> >  		goto unlock_mutex;
> >  	}
> >  
> > -	if (!PageHWPoison(p)) {
> > -		unpoison_pr_info("%#lx: page was already unpoisoned\n",
> > +	if (!is_page_hwpoison(p)) {
> > +		unpoison_pr_info("%#lx: page is not poisoned\n",
> 
> Can this speculative evaluation of is_page_hwpoison() trigger a panic?
> 
> Since this is evaluated without a reference on the page, the underlying
> page could be concurrently freed and reallocated as a tail page.
> Looking at is_page_hwpoison() in include/linux/page-flags.h, it calls
> folio_test_hugetlb(folio), which uses const_folio_flags(). That function

No it doesn't.  folio_test_hugetlb() is one of th FOLIO_TYPE_OPS which is
defined as return data_race(folio->page.page_type >> 24) == PGTY_##lname;
and no asserts.  I mean, there probably should be!  But this is irrelevant;
this whole function contains many such folio tests and the same problem
applies to all of them.  This patch doesn't make it worse.

> enforces a strict assertion:
> 
> VM_BUG_ON_PGFLAGS(PageTail(&folio->page))
> 
> If the page is concurrently reallocated as a tail page while
> is_page_hwpoison() executes, won't this crash the kernel on debug builds?
> 
> >  				 pfn, &unpoison_rs);
> >  		goto unlock_mutex;
> >  	}
> 
> [ ... ]
> 
> > @@ -2748,6 +2748,7 @@ int unpoison_memory(unsigned long pfn)
> >  				folio_put(folio);
> >  				goto unlock_mutex;
> >  			}
> > +			p = &folio->page;
> >  		}
> >  
> >  		folio_put(folio);
> 
> This isn't a bug introduced by this patch, but does this lead to a
> double folio_put() and use-after-free for hugetlb folios?
> 
> If memory_failure() handles an in-use hugetlb folio, me_huge_page()
> might fail to dissolve it, meaning no extra poison reference is taken
> but the folio remains marked as hwpoisoned. If the folio is later
> unmapped and holds a single transient reference, unpoison_memory()
> will acquire a reference (ghp = 1) and perform the folio_put(folio)
> seen just below this reassignment.

I'm not an expert in the memory-poison field, but this also seems wrong.
Don't all hugetlb folios have a folio_mapping()?  And thus we'll never
take the dissolve path in me_huge_page().

At any rate, it says "not introduced by this patch", so I'm not going
to take any action.

> By reassigning p = &folio->page here, the subsequent call to
> TestClearPageHWPoison(p) will be tested on the head page and return
> true, triggering a second unconditional folio_put(folio). Does this
> underflow the transient pin and cause a use-after-free?
> 
> 
> This is a pre-existing issue, but does this same logic underflow the
> refcount for THP folios that previously failed to split?
> 
> If memory_failure() handles a THP and try_to_split_thp_page() fails, it
> explicitly drops the reference acquired via get_hwpoison_page(p), leaving
> the THP with no extra poison pin. However, TestSetPageHWPoison(p) was
> already called.
> 
> If the THP later reaches a state with a single transient reference
> and no mappings, unpoison_memory() acquires a reference (ghp = 1),
> calls folio_put(folio) once, and then TestClearPageHWPoison(p) clears
> the flag and returns true. This triggers the second folio_put(folio),
> dropping a non-existent poison pin.

I don't know, and I'm losing patience with the Sashiko rabbit holes.
This is all getting very far afield from the problem I actually want
to fix.

