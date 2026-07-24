Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E15C3C531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 13:41:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC7EF6B008A; Fri, 24 Jul 2026 09:41:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E792E6B0092; Fri, 24 Jul 2026 09:41:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D918C6B0095; Fri, 24 Jul 2026 09:41:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B82C16B008A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 09:41:22 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 42562C034B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 13:41:22 +0000 (UTC)
X-FDA: 85023782004.26.4F4E382
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf24.hostedemail.com (Postfix) with ESMTP id 57DBC180003
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 13:41:20 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=fjUMa1+b;
	spf=pass (imf24.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784900480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2oFbcbP9GUrTzCBiqlNDgP43sOQHVXZdlfi2dyJMC18=;
	b=PtXsnvpJa9Z9l+oe8ualHVj2SZd4vNbHNNshseCK/ZQDG2DfYEKpbDXArdmtEdLLYR7gj6
	Ro2LGi5RUriT5wguS6dIbfS+OHVGDJICOMX8WhK6CX0M0ThRZm97Rad95HxAH05AkDuFlL
	wKBdsm91tfF1WE5hBGKQ744V2Zlq2oE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784900480;
	b=lfC1h0scJ6FRXHZRMDhrRfz6QMyO1VC66+6eRYDo+BQsE7/aJ34NYuvoKsuUOdQ6Nu6PEY
	9pyjISUNxpUeMGcFwgtG/GOC/8Ga2OtdaeAwm59Od5PkbgL3ZrVvK2QUfwfm/jZlYVLxGk
	ze/KkwSNA+aYibZ0VaMm9wk09CoyY7M=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=fjUMa1+b;
	spf=pass (imf24.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=2oFbcbP9GUrTzCBiqlNDgP43sOQHVXZdlfi2dyJMC18=; b=fjUMa1+bvke2jKzKthKkemhDUm
	Zbl1OGeBkqqkfzRZDRU+H4Sk4I41atce5K3Cme1OQFlyunDlvCg9ttew66CnAJs8Nfzqa8rySK9Oo
	eK4dmC8LpXq5vPS/n1opBpefbBQNO5POCutw7OnfWx/eCia4gSfuYVu+8Kq2Psm4vatrlkVTfd10G
	csrBeWzR00412/bUjYnUdJNAJuGmnyrLAsmFnnFDnC/GR3aNby9iRTyIQlu89+YyVDwzWbFOWJQMS
	PPZLtAr88sEesBwFThVSndwy228sXXs0kJens6Z5v6QXobJnSKRv52qRpDfobvuCKD8YZYoxRZYfl
	pgIo3Naw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wnG9N-00000003b4v-3FmK;
	Fri, 24 Jul 2026 13:41:17 +0000
Date: Fri, 24 Jul 2026 14:41:17 +0100
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
Subject: Re: [PATCH v4 08/14] mm: Remove locking mf_mutex in
 is_raw_hwpoison_page_in_hugepage()
Message-ID: <amNrfc_FDfEdPaD6@casper.infradead.org>
References: <20260723143034.175661-1-willy@infradead.org>
 <20260723143034.175661-9-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723143034.175661-9-willy@infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 57DBC180003
X-Stat-Signature: oz4cyfacx8t6w7gsmq89cncioquayjyb
X-HE-Tag: 1784900480-332111
X-HE-Meta: U2FsdGVkX1+A431M4htF1ADi0MqSiCy9VPxavLv7Z94GaaOFfuneAirMHp2Mb6el8WzXJxHD8XGiggUlX+s+53FYcEFLNaSan9/JDXno/uzWuTDbI52gHKl57IMhVbQxstD9TdXOXPEYjF3JruFtH9/yHM1QJBbcLTfwOKhk3hHrU9dx/d1XiG8OjlC4wKyPCDNrdRf3KGAElRMbuMKouZgpw6N0QSxyPWxCBEW3C7S3uGYeMwtHF3thAG6iJv1n/UzsLqSKFuaLWHZKu8nhpWu3jCUflg9kSQRls1dVk7LL+MA4IepqrMBY+xK8H0apB1Bo585qTEZ3qRxe9XmdvdBtJ5JAkMupnJ47j8hb7htyHKKWoEkzAxcEqx5m19VEAbBKEuGc5r0z2j4YzP8DBK/WGqZDgq6sRNP1ZNyHQFX5E0fXJyauteG5SrKO0ngU291CAaZBvltqBUf4AOZQCBhEDC1G1Uu8w1+cGo0xURpbulNdQM75rLzMvYMNn4wHR7zUJ+oxlQBibcdLaQozG5mZSiRiwOrHiaQEmINYNIbcm27RKIYtyWWXL/s3DcDh7gL8fQiRoF9+nb41tcUsZ6ML8OZYWr/eHt6F794hV+Ph2aaQ88RA2EVuLabrdEAxU5/TpGuAF09yrPizOEetHIQnGFd8a1FpUQXyYLcKUlrG9pEgCgz5Vhtd/G4PboCEs2rtpf7DFUcJV8N3LD4NhHG4TNvoprZnOmVwU7oUAZxjlUpYi2pqcTau7NnL6UWjmJ9+5L78uaJ/XkwHZQj6PL3n/FUrhHrIr7KMwk+XLAAtynb6MHEFADxm+InNtmQQ13H72i3wcrBcwZHhrhrPV0G0QV/M8daI9oNkNBhytP0H/iJDw5Fqcnzad3mJVjE+Pt0kQIiSyAagPrycAZIJ86T7B3eGThQZX70pBAClFRsdCW5I2uXCzSyl8g6WuhCHxZBFY8Y6laOiVZ26SoB
 YLcjKozi
 do+un3nuKLpIYRsWOmiQvtaeFFreCy367ne8LP7Cof2zu9CgocdBdoWSxPfrKmUhTbRZxDQ0txH7J/LBHBPikHH+UnfCnXzNLwLiEXugyGqMC9WQWIa2+hGYj0AoIqIsJexWdkr+fXQRi6tTdjvtx0ZJIIZ+2iWDH1PMdIVlv911dcxqB1rXwIo3JtrdsJr3OYly9hGJc2CLF9npONRGdVifnGwaaIjm61t97XTS5QMJUsYd421ZUd/K8Uls3giuS3KnCElwIgBgElaEMA5JQU52KPbCW73+EM2hZCbSm8CENbm9co4a1ctEAoA0It7gHo3mSlD8FAsHvRpbDjKZFbclNTM++rgskw6Gl6fKHUKfURr4HqVA774qv2GiMvG7sgrDyKcFakpTMoLzfXAfPQ8K3iel7afY7S6V8dU6BjsjqIn6yLSiLL2FiCqC16hLhzE3EbpMBNd7p81A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sashiko review:
> --- Patch [8]: [PATCH v4 08/14] mm: Remove locking mf_mutex in is_raw_hwpoison_page_in_hugepage() ---
> commit c0f68557b399585852271ea0bc6a590caa47b3ad
> Author: Matthew Wilcox (Oracle) <willy@infradead.org>
> 
> mm: Remove locking mf_mutex in is_raw_hwpoison_page_in_hugepage()
> 
> This commit removes the mf_mutex protection from the raw hwpoison list
> iteration in hugetlb_page_hwpoison(), relying on lockless llist traversal
> using READ_ONCE(). It also renames the function and modifies it to take a
> folio.
> 
> > diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> > index 4200deab2c3c4..5076ee5d4788d 100644
> > --- a/mm/memory-failure.c
> > +++ b/mm/memory-failure.c
> [ ... ]
> > @@ -1817,37 +1817,30 @@ struct raw_hwp_page {
> >  	struct page *page;
> >  };
> >  
> > -bool is_raw_hwpoison_page_in_hugepage(struct page *page)
> > +/*
> > + * Check if a given @page in a hugetlb folio is HWPOISON.
> > + */
> > +bool hugetlb_page_hwpoison(const struct folio *folio, const struct page *page)
> >  {
> [ ... ]
> > -	mutex_lock(&mf_mutex);
> > -
> > -	llist_for_each_entry(p, folio->hugetlb_hwpoison.first, node) {
> > -		if (page == p->page) {
> > -			ret = true;
> > -			break;
> > -		}
> > +	llist_for_each_entry(p, READ_ONCE(list->first), node) {
> > +		if (page == p->page)
> > +			return true;
> >  	}
> 
> Is the assumption in the commit message that updates only add to the head of
> the list accurate?
> 
> Looking at __folio_free_raw_hwp() in mm/memory-failure.c, the entire list can
> be concurrently detached and its nodes freed via kfree() without an RCU grace
> period:
> 
>     head = llist_del_all(&folio->hugetlb_hwpoison);
>     llist_for_each_entry_safe(p, next, head, node) {
>         ...
>         kfree(p);
>     }
> 
> This freeing can happen while the folio is still in active use. For example,
> if a subsequent memory failure on the same folio fails a GFP_ATOMIC allocation
> in hugetlb_update_hwpoison():
> 
>     } else {
>         folio_set_hugetlb_raw_hwp_unreliable(folio);
>         __folio_free_raw_hwp(folio, false);
>     }
> 
> Since callers like hugetlbfs_read_iter() explicitly drop the folio lock before
> calling adjust_range_hwpoison() (which triggers this lockless traversal),
> could a concurrent memory failure free these list nodes while this loop is
> still accessing them, leading to a use-after-free?
> 
> > -	mutex_unlock(&mf_mutex);
> > -
> > -	return ret;
> > +	return false;
> >  }

argh.  I give up on this cleverness.  I'm going with the new spinlock
approach (like I did in v3) but retaining the per-folio list of pages
rather than having a global hash table.

