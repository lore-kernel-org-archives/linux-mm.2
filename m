Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C96FC531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 14:00:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 661006B007B; Fri, 24 Jul 2026 10:00:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 613106B0088; Fri, 24 Jul 2026 10:00:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 528356B008A; Fri, 24 Jul 2026 10:00:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 158346B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:00:52 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 786721A03AE
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 14:00:51 +0000 (UTC)
X-FDA: 85023831102.16.F3A3F7D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5C7102001E
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 14:00:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=s8807+jX;
	spf=pass (imf13.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784901649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YLWZJH05bPsYo6l/NwF/IdTDbMw1JogUtckT/duPcEU=;
	b=Slejnu+7HYhxy/VmfCA4IL31IQdZaxpOjWP13+HVU8Lfa2mZ7C7+IoCkGHnQDtITYOtQYp
	STlKH4DZinu5MBQvfB33Ue5BPMEMXbB7cI6vilgmUyeDtU4MIr379BgEsRnqS+5Cqepby0
	Qoi9jV/LwontGy54u6HOTQyEPoD+rj0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784901649;
	b=DXou1Pg+fKE13qzAwzyHwujS3tuVSrPeJs2M636bLRFQUa41fo27UALf7gvzDGtOOkKPQS
	RqDBBa/AtQEPVoQIrzIia4VA/pdBl7cwA7wl5FAjixHjEzODX3d9VHGFhLTrlD9Na5NU9C
	suCjCE5Sw5ds9rzQgTL1bzJDwRietx4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=s8807+jX;
	spf=pass (imf13.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=YLWZJH05bPsYo6l/NwF/IdTDbMw1JogUtckT/duPcEU=; b=s8807+jX9Z4Ckxqf1zi2eT/GGH
	5WVUk0PSJhIKjcBfwqldUI7xVMu0LjbnZamXKH/Xe5mqeijRXXCfehjXfHH8IF90YU9V2na3vJUIn
	uuKXh5XyLpGdi1C8UAj388swgUMTMNRLwWp/JPNc8wiY0H+s9RAwTSXfM+6aNbKsBxrUQSKQ9bMj4
	HBGf2nEhPpclRhHRXAkxrJwT5Yya7i7NRXDqkPTURjfcznEdyfz4yfE+nhNYgqLtZvw7EoAlRPpi8
	j4CINfqSfg91ZAg6wN5ZjNyttrgei0tquzo3tbXV4QTil22ElO01vy1lqa+uEOHyrnq9wWejcrUs9
	MKCb7gVA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wnGS1-00000003e4P-44QJ;
	Fri, 24 Jul 2026 14:00:34 +0000
Date: Fri, 24 Jul 2026 15:00:33 +0100
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
Subject: Re: [PATCH v4 09/14] mm: Check individual hugetlb pages for poison
Message-ID: <amNwARfIFyEXE_zE@casper.infradead.org>
References: <20260723143034.175661-1-willy@infradead.org>
 <20260723143034.175661-10-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723143034.175661-10-willy@infradead.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5C7102001E
X-Stat-Signature: s8skjpg73spkgee4kjowom8xpzint37m
X-Rspam-User: 
X-HE-Tag: 1784901649-301607
X-HE-Meta: U2FsdGVkX1+Trs1oCNGeC4OBxNTozrcZdTChqmSSKiPehDMZzKvHwbIZMNdfA9ykvw1YUQikHHkG0s92EzSw27zs1w6SMOHp+x3YYiruDrfIkLSAhiz0mQRDbwdHal0UJIXPbvVM7/pSiAWMzMmMiuWRczHgYdlqSIbAjP+FvvEH7xY8X910IGkgqDIUH5Ts3yYZ91JZaw8lyd7ip6XCAiyl82oYgc67gJOJdFxgFH4HOcUgygWyyKSQUmNHeZ5Q3N5zlk2OD3oLPJR7st25XmjY7GyYln6Qces52WQQL9BDrW7Lyw7kq/ySzbj+iGmjjVR7wP/Xr7yqinMYTVi+4HQ1AS3+JrXhyzEXbSzx/64HOgNZe304C5fRnyg+E0YngZcyVZOAcgbhlggixRCAo6dyVLpgrRp/9WGAHpWCZVrTWYpk2jzudFdmMHnOQnaYrN1hiM5g+xw2q8ff1ZJvHSEZMZIesiXicXG9nAZbxmxmVGmWQKlbw28vYu64VS2Ql4y6xCAhX4wydVa2Yr2XK4w3p4vrgbCrgriLv0Xdv8WiJ4yLDjhTmZ0IEUaKebMA6dnSspViI5GnSf4PJ7Qm0daw7rWCPvYbaj9QJwdtl/OGcq6XnRvfAhIn2GlSOMon1jPG56aeDXIjYfWhRJOd5MdzspDhC3M3/U3nx/O64960CBQXTz4N+vz9pWJDLbA16/v26x/GdN2icEiL5JMLg95MdIxnrdMz1ZfSh3Kjqe+1/s2ueb2hUL+fJo3EIl3u1c9WVd2aBoc1fyzdQjuztHOnmkR3Bhx19g5Fpf1LPelpC2pGtvCndR3XRmHqQRSdN4KrYlzYcLCgHt9NHD0dS0hdkvTP3JefBcxTZci9iO7U087f+5qVzhrvC3GpUKmfhL9CrcHKrrYtrTyKw1FSyQMyNGT5bJqtiBcj2tKw3mV4xzQG1t0e3h9MRyPRRu8sM3oMDQWhEDF6QY0F7FX
 FcWcHMOJ
 52GVjgZmfR7eIOoGo81BDGFtLgC64RF01qv0CbHNV9SA21aZOX2sPiRgkKn/P/7U/fh8jN+j5t7gkgIQ4zBMXystiDSZhj3LWacXAqdYbybfFHjxEtm8nuKQ9FghzjbntgxwBMeAKTL0WOmSA4zKxrjSlUNCHqfrcb6BLa7YBxhBgRbq6VD0thP6iVCDKSXAzkS3MsnmnVOnJVh3YzNS5XWec5GinozhD6gQvFSFvmLss5qz+6HBDVsFediHjigg7Qqb+gdEVnu84Yvi9jcDj01/q1tx82Md2u5gQG0y/1JPHANkfymf6XDsWcgOAekCKAPPGPPZUsR/mkYci2iJw8XZZ1GptqmUGQRsCyhfpXeiZ6to7rosPd8tlTHI+5WK9pJfU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sashiko review:
> --- Patch [9]: [PATCH v4 09/14] mm: Check individual hugetlb pages for poison ---
> commit 5da9009498dbc7d3d1fea29d7065847731ac20dc
> Author: Matthew Wilcox (Oracle) <willy@infradead.org>
> Subject: mm: Check individual hugetlb pages for poison
> 
> This commit modifies the hugetlb hardware poison checking logic to verify
> individual subpages instead of the entire folio. It introduces a new
> function to safely perform this check without holding a folio reference by
> relying on the hugetlb_lock.
> 
> Link: N/A
> 
> > diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> > index 7c4652dd517a3..9cde74320e48a 100644
> > --- a/include/linux/page-flags.h
> > +++ b/include/linux/page-flags.h
> 
> [ ... ]
> 
> > @@ -1090,6 +1090,8 @@ static inline bool PageHuge(const struct page *page)
> >  	return folio_test_hugetlb(page_folio(page));
> >  }
> >  
> > +bool hugetlb_unref_page_hwpoison(const struct page *page);
> 
> Does this cause a build failure when CONFIG_MEMORY_FAILURE is not set?
> 
> When CONFIG_MEMORY_FAILURE=n, mm/memory-failure.c isn't compiled, meaning
> hugetlb_unref_page_hwpoison() is not defined.
> 
> Since is_page_hwpoison() is an inline function that evaluates a runtime
> condition when CONFIG_HUGETLB_PAGE=y, the compiler can't optimize the
> branch away.
> 
> Will this result in an undefined reference to hugetlb_unref_page_hwpoison()
> for callers like fs/proc/kcore.c?

Oh, right, need to define FOLIO_TEST_FLAG_FALSE(huge_poison) if
CONFIG_MEMORY_FAILURE isn't defined.

> > @@ -1104,7 +1106,7 @@ static inline bool is_page_hwpoison(const struct page *page)
> >  		return true;
> >  	folio = page_folio(page);
> 
> This is a pre-existing issue, but can this speculative folio access cause a
> kernel panic?
> 
> In PFN-scanning contexts like /proc/kcore, is_page_hwpoison() is called
> without holding a stabilizing reference.
> 
> It calls page_folio() speculatively and reads flags via
> folio_test_huge_poison().
> 
> If the page is concurrently freed and reallocated to a non-compound user
> (like SLAB) that stores data in the compound_head field, page_folio() will
> return a garbage pointer.

... what?  Slab is a good compound page user.  You're drinking the
bad bot juice again.

> This isn't a bug introduced by this patch, but could the non-atomic
> modification of the poison flag corrupt the buddy allocator?
> 
> unpoison_memory() calls hugetlb_clear_poison(folio) which performs a
> non-atomic read-modify-write:
> 
>     folio->page.page_type &= ~(1 << 23);
> 
> When get_hwpoison_page() returns 0 for a free hugetlb folio,
> unpoison_memory() does not hold a reference. Concurrently, the folio can
> be freed to the buddy allocator.
> 
> If the non-atomic modification in unpoison_memory() races with
> __folio_clear_hugetlb() or the buddy allocator's __SetPageBuddy(), it can
> overwrite their updates.
> 
> For example, if it overwrites the buddy flag, PageBuddy() becomes
> false for a page on the buddy list, crashing the allocator when accessed.

I think it re-found the same problem it complained about earlier.

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
> 
> Can this list traversal result in a use-after-free?

As earlier, I'll protect this with a spinlock.


