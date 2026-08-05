Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56807C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 09:24:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C9AE6B00A0; Wed,  5 Aug 2026 05:24:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37A846B00A3; Wed,  5 Aug 2026 05:24:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28F986B00A4; Wed,  5 Aug 2026 05:24:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 03D1D6B00A0
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 05:24:55 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 76029A0426
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:24:55 +0000 (UTC)
X-FDA: 85066681350.01.C4A27F0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id DE0DC140008
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:24:53 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kQz8WvBK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785921893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cE1RF8+B9xlu8JqN7BsOEkjNJ9HyU3K0bbai2LbODjM=;
	b=7jg5Z/qhWJlzgQFv9/dTCdl2QI1sZwfMgovYV3q9xLWXshdK+iAaNVLO4p1p5ThmBNqJ3D
	7dpa375os205bD6xry3gbY8s0R3AOuSs6XZM9jo+9K7I2G+baVUkN+28bcU/vDutbu4psr
	o2eM1ED3ltHimq7bGbW7KfSxwZC7Kes=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kQz8WvBK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785921893;
	b=YrYX9p5lPw8vGeCorvL72xWRkTKGzV3xsohLxHuJ8kkgnRqoDcfUQX1PkLv+8YZAWXtv1k
	0EAt8AMI8JSPLykO5nwTZVf8KFgH2DR403sKlxCqJbu+htgX6BZi8PI41kurXvsAAUNcvy
	/aPxTHvuj4i69JwPS1Oq4PRHAYvKPoA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6D0C5600AE;
	Wed,  5 Aug 2026 09:24:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913BB1F000E9;
	Wed,  5 Aug 2026 09:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785921893;
	bh=cE1RF8+B9xlu8JqN7BsOEkjNJ9HyU3K0bbai2LbODjM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kQz8WvBK1A7wtbOa6nE1JssG23sOFr3ByccxOTJ5JvWqUgzj15YqwTRWwp29h5gn8
	 z/+rYjxVc/PPTwYCCNSTV3qhcjQMCk0jqccDcdYZUE0oVWWvsr4kv1r00OfRsFKoAf
	 aOeuThEBeTxORdw6AxXdmQV5Wea/piB7xMfHBOYSMdlcfKxIlVB5vEstPHMu5lpqb0
	 o8TE6YvaTmlxyaTVvrX4qTtsFMXM2P6BJYlpaXs3oY0FV0CNj2Qs0t4c9E1r3C0LRz
	 i7VIz9/rwY4O0YTqEnoDgHA+ggZJbZHN+zlhCEi9L8ofEUaNKsCu+sGwMtTrU7a8Ud
	 CeD9PtG6ik11g==
Date: Wed, 5 Aug 2026 10:24:36 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: dayou5941@163.com, akpm@linux-foundation.org, ziy@nvidia.com, 
	linux-mm@kvack.org, liyouhong <liyouhong@kylinos.cn>, 
	Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/memory-failure: fix concurrent access issue in
 min_order_for_split()
Message-ID: <anL_I_2o3vfAaRLr@lucifer>
References: <20260805072625.2437636-1-dayou5941@163.com>
 <dbdb0f70-669b-4c68-a9cf-89d30c20f12f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dbdb0f70-669b-4c68-a9cf-89d30c20f12f@kernel.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DE0DC140008
X-Stat-Signature: awjtzidctjoiwqzfpib387187pg9gedp
X-Rspam-User: 
X-HE-Tag: 1785921893-660516
X-HE-Meta: U2FsdGVkX19S6Yrwtap4HtKxUROzeJutx1JnciFbZ7JVB/wtUGR04pIXJmYGJJ2SrEOfvalwuzPqBA7v3xFNjoAulItjqfoCF1FIbXYUwLlVFyRARWe79lJTxVINfq9asdVhVTG2ReZkKrh5X50hPro935W/k9LaT2X34yY8tarWqORk/iCigQ/y/tUCkIKuDWsdMHPMTM2g65hMo+OLOPHsAx5Dy/YF+8z4pQXPD6S5VhIEdeIb9Iw7fCV8KOTV4BrzuFWEuULpUWpDm7Fi5i6kdlHODA6RAuCfDoTJCs4NPFDEDc8xq5rofu8xXX+lA95rVrFPG1zq2BeDXIlYHmrBRYBHj5GGy3i8zgYPDe2QacFxOQJwRCZgGbFa8C+7srBa8krX9nPELdFm6A8q6WURkcv2FclriDJgiGlnwBg0iBd654eM2chTyxViZVWga9TX7aIfnK2peZupDPSXY2BK4EQ5YKDfSVDpWvLLKf0Mw5G41Hx2ddq3WW1hy5O6hND8NJZgwRWsRMfmktkTFIu8i2QTYquaVlKrYeQX7QPrKbkTLgdSsKAH38AnXX5nAgDEsZBVIY5jSHtACXiwVEcOqMRXe6QnzTlESfZO6B4QN8yPnPAnzJ3xFp9n4x8rlQs74d+WLmnvgtpKF2zIhAvuD7/MlLwI+T7CdFWWSE5kIGm6NoiLZTm/J4A/1D0d/w1HuBEijtwE2OyY6OoowqZz5/y551T646Kek7KBvlQckEXGR9UMtw9P8Y1/2ZVQqwugC0i8WdlKH38oFQge1mMB+t18z7Lg/pH4Nm5EhhZ3tYRZfHkSX2HrlBjynsOlu7/A8+cJoBLhqQs6xAsalrwjAtEi7R3XtXdbQyI9RLRXMhKzvwwKgEkSPoLFklZYRV2X4M+sFWSpU4cu12EwrcbvpAKdXkTlKrRWzAf75wMZI82lScNsjmZMM79yXx9jnhI5EFtKPZTALaJMU7Q
 ak/rOgTK
 2QMIjhv6BwOfgaQnFhkmojeJC549LGjEIh8yJXlKckUNA2TijH7OuOo6Gdz/ieR5uLKCzQ6Iz7/r0fzHADTrlqQR9WEtjUyJpte3Km2JjeRRhMdJWV5gsxjD5O8CSndIUHzM8Fdtsp3P5D69l+OWHpBJt/fZdOEJh7No9yhgs1uBnUxnc3QAZa5eUdPLnblIiDXDw3LWtHBputlZer/MHwTOFRihkJR7ZfCsA0aJKmgaTMEBmawAEIMFra/j65sk1SPtCLRlPRYqFlHGU427ZGgFS8mvOIEcvBydOPnbthJTsxIzlWr4Ytls78PLLOF9hPHFHPjtNU6Z6Wv2Un8Da/j8JHPxL4g6OCCWuua4HwfqpBV3+fOy8dsuyeW4b/uW56Th7KxECR2IFEC77UWmmHPWWKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 05, 2026 at 11:07:18AM +0200, David Hildenbrand (Arm) wrote:
> On 8/5/26 09:26, dayou5941@163.com wrote:
> > From: liyouhong <liyouhong@kylinos.cn>
> >
> > min_order_for_split() accesses folio->mapping without proper
> > synchronization. While the compiler typically caches the value
> > in a register making a NULL deref unlikely in practice, the
> > real issue is that the callers in memory-failure.c do not hold
> > the folio lock at the time of the call:
> >
> > - memory_failure() explicitly drops the folio lock before calling
> >   min_order_for_split().
> > - soft_offline_in_use_page() has not yet acquired the folio lock
> >   when calling min_order_for_split().
> >
> > This means the value of folio->mapping may be modified by a
> > truncate or invalidate operation while min_order_for_split() is
> > executing, leading to a torn read or use of a stale mapping value.
>
> I recall that a mapping can get freed after truncating the last folio.

Yeah.

>
> But Lorenzo had some cocnerns about the validity of the report, so I'll let him reply.

The report is entirely theoretical :)

In practice it seems the compiler always hoists, so the !NULL check is performed
before anything's dereferenced.

But we really shouldn't rely on that, and I agree the fix should be in the
memory failure code.

>
> >
> > Fixes: 689b8986776c ("mm/memory-failure: improve large block size folio handling")
> > Reported-by: Sashiko <sashiko-bot@kernel.org>
> > Closes: https://sashiko.dev/#/patchset/20260803060001.800638-1-dayou5941@163.com
> > Cc: stable@vger.kernel.org
> > Signed-off-by: liyouhong <liyouhong@kylinos.cn>
> > ---
> > v2:
> > - Dropped the approach of caching folio->mapping inside min_order_for_split() in favor of adding the folio lock at the callers.
> > - Added VM_WARN_ON_ONCE_FOLIO() in min_order_for_split().
> > - Updated the commit message to clarify that the real issue is the callers not holding the folio lock, rather than a TOCTOU race.
> > v1: https://lore.kernel.org/all/20260804035828.2684059-1-dayou5941@163.com/
> >
> > ---
> >  mm/huge_memory.c    |  2 ++
> >  mm/memory-failure.c | 12 ++++++++++--
> >  2 files changed, 12 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 58cabe6af33d..e3f16dadc1d4 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -4300,6 +4300,8 @@ int folio_split(struct folio *folio, unsigned int new_order,
> >   */
> >  unsigned int min_order_for_split(struct folio *folio)
> >  {
> > +	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);

This is good thanks.

> > +
> >  	if (folio_test_anon(folio))
> >  		return 0;
> >
> > diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> > index 3b1e6946821b..7391524b5046 100644
> > --- a/mm/memory-failure.c
> > +++ b/mm/memory-failure.c
> > @@ -2437,12 +2437,17 @@ int memory_failure(unsigned long pfn, int flags)
> >  		res = -EOPNOTSUPP;
> >  		goto unlock_mutex;
> >  	}
> > +
> >  	folio_unlock(folio);
> >
> >  	if (folio_test_large(folio)) {
> > -		const int new_order = min_order_for_split(folio);
> > +		const int new_order;
> >  		int err;
> >
> > +		folio_lock(folio);
> > +		new_order = min_order_for_split(folio);
> > +		folio_unlock(folio);
> > +
> >  		/*
> >  		 * The flag must be set after the refcount is bumped
> >  		 * otherwise it may race with THP split.
> > @@ -2796,8 +2801,11 @@ static int soft_offline_in_use_page(struct page *page)
> >  	};
> >
> >  	if (!huge && folio_test_large(folio)) {
> > -		const int new_order = min_order_for_split(folio);
> > +		const int new_order;
> >
> > +		folio_lock(folio);
> > +		new_order = min_order_for_split(folio);
> > +		folio_unlock(folio);
> >  		/*
> >  		 * If new_order (target split order) is not 0, do not split the
> >  		 * folio at all to retain the still accessible large folio.
>
> We already grab the page lock in try_to_split_thp_page(). I think these
> needs a serious cleanup.
>
> While at it, we can fix the missing put_page() in case new_order != 0 in
> soft_offline_in_use_page() ...
>
> So i think we really should do the following:
>
>
> From 58c4ccbb04e13c4c14ef7a94f4b44f8901183081 Mon Sep 17 00:00:00 2001
> From: "David Hildenbrand (Arm)" <david@kernel.org>
> Date: Wed, 5 Aug 2026 11:01:46 +0200
> Subject: [PATCH] tmp
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  mm/memory-failure.c | 46 +++++++++++++++------------------------------
>  1 file changed, 15 insertions(+), 31 deletions(-)
>
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index aaf14608b30e2..de97a7a36764d 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1705,26 +1705,6 @@ static int identify_page_state(unsigned long pfn, struct page *p,
>  	return page_action(ps, p, pfn);
>  }
>
> -/*
> - * When 'release' is 'false', it means that if thp split has failed,
> - * there is still more to do, hence the page refcount we took earlier
> - * is still needed.
> - */
> -static int try_to_split_thp_page(struct page *page, unsigned int new_order,
> -		bool release)
> -{
> -	int ret;
> -
> -	lock_page(page);
> -	ret = split_huge_page_to_order(page, new_order);
> -	unlock_page(page);
> -
> -	if (ret && release)
> -		put_page(page);
> -
> -	return ret;
> -}
> -
>  static void unmap_and_kill(struct list_head *to_kill, unsigned long pfn,
>  		struct address_space *mapping, pgoff_t index, int flags)
>  {
> @@ -2509,7 +2489,6 @@ int memory_failure(unsigned long pfn, int flags)
>  	folio_unlock(folio);
>
>  	if (folio_test_large(folio)) {
> -		const int new_order = min_order_for_split(folio);
>  		int err;
>
>  		/*
> @@ -2526,24 +2505,24 @@ int memory_failure(unsigned long pfn, int flags)
>  		 * page is a valid handlable page.
>  		 */
>  		folio_set_has_hwpoisoned(folio);
> -		err = try_to_split_thp_page(p, new_order, /* release= */ false);
> +
> +		lock_page(p);
> +		err = split_huge_page_to_order(p, min_order_for_split(folio));
> +		unlock_page(p);
>  		/*
>  		 * If splitting a folio to order-0 fails, kill the process.
>  		 * Split the folio regardless to minimize unusable pages.
>  		 * Because the memory failure code cannot handle large
>  		 * folios, this split is always treated as if it failed.
>  		 */
> -		if (err || new_order) {
> -			/* get folio again in case the original one is split */
> -			folio = page_folio(p);
> +		folio = page_folio(p);
> +		if (folio_test_large(folio)) {
>  			res = -EHWPOISON;
>  			kill_procs_now(p, pfn, flags, folio);
>  			put_page(p);
>  			action_result(pfn, MF_MSG_UNSPLIT_THP, MF_FAILED);
>  			goto unlock_mutex;
>  		}
> -		VM_BUG_ON_PAGE(!page_count(p), p);
> -		folio = page_folio(p);
>  	}

Oh yeah that's much nicer!

>
>  	/*
> @@ -2862,8 +2841,7 @@ static int soft_offline_in_use_page(struct page *page)
>  	};
>
>  	if (!huge && folio_test_large(folio)) {
> -		const int new_order = min_order_for_split(folio);
> -
> +		lock_page(page);
>  		/*
>  		 * If new_order (target split order) is not 0, do not split the
>  		 * folio at all to retain the still accessible large folio.
> @@ -2871,8 +2849,14 @@ static int soft_offline_in_use_page(struct page *page)
>  		 * preferred, split it to non-zero new_order like it is done in
>  		 * memory_failure().
>  		 */
> -		if (new_order || try_to_split_thp_page(page, /* new_order= */ 0,
> -						       /* release= */ true)) {
> +		if (!min_order_for_split(folio))
> +			ret = split_huge_page_to_order(page, 0);
> +		else
> +			ret = -EBUSY;
> +		unlock_page(page);
> +
> +		if (ret) {
> +			put_page(page);
>  			pr_info("%#lx: thp split failed\n", pfn);
>  			return -EBUSY;

Maybe return ret here? Seems a bit pointless to set ret, gate on it then not
return it (even if result is the same)

Otherwise LGTM!

>  		}
> --
> 2.43.0
>
>
> Likely some more cleanups on top are possible.
>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

