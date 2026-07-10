Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9E2CC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 17:17:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E0C56B0088; Fri, 10 Jul 2026 13:17:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B7F36B0092; Fri, 10 Jul 2026 13:17:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F5626B0093; Fri, 10 Jul 2026 13:17:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 45E486B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:17:02 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B9B68C38E7
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:17:01 +0000 (UTC)
X-FDA: 84973522242.02.D28F431
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id 073AC140008
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:16:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=wM0amu2R;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf26.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783703820;
	b=yG7qKdqhkQ9xWWTEwpIXyZJrvy+EbS89m/TduerYhu9Jd2BvF93WOeOeo1TNJ10wotQRuz
	7U6FHj6fYWIrxB3tCcjJyxYC35Xmct0C7ySMq2wEBGgogj8zvIom23sxPA3m2QaaPArFUa
	sCDD8EU9QOkWRC9I8umtXeFGKDMw1Rw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=wM0amu2R;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf26.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783703820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oXE/qdzDgEJh+tk6GkgML+u27UjBbh+JDL0zV5QbKUA=;
	b=mXy1NjjW+09ge6IgkGdqdI7Y1S0ocYm5dmJjeF2zRhbASjhN5RU39Gd7qqiJm1loPGS82N
	a+aifxFFBbcyVbPmuOGvmno51M0x3qJmArheE2LlekhQhSfxqGQmBuF5qI5RFKFyrSD1K8
	ogX+JFqnWe31zeOQzh6fgeVsjpDO8WY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=oXE/qdzDgEJh+tk6GkgML+u27UjBbh+JDL0zV5QbKUA=; b=wM0amu2R7kPfLA6TxU6kNtPdMT
	vgVkF+Av+X2ffQ7AozHzzq5I1zXOAPkqdJdlGIR/Vk3Lcy13Xf5RPpPLTaAXtHun5LKjGQixC5t/r
	wkIGDzCU20f+9HZwO5pKjUFjqWikBZIU2sLYJTrbNLNTXrDuiNLksmfz3bRH2dcKwEL/p0Ciw4bbf
	QSqq6E3Qf6khtU0mX/QBG4Y9jM77GcUTiMHKbLaQS9z63TUs8viguVUTA6+QDYH/k2NdXasur0Na9
	MPhur4kHXx+KkYxp0cgZhcRwG08fUarV0vcTv31cLel9NXZ6M5lwvZh3r42AEibLRHTg4QJYPsDty
	FF1gB0VQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wiEqM-00000007WIj-1WXe;
	Fri, 10 Jul 2026 17:16:54 +0000
Date: Fri, 10 Jul 2026 18:16:54 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v2 06/10] memory-failure: Prevent UAF in raw_hwp_page list
Message-ID: <alEpBqExnyvBnnxi@casper.infradead.org>
References: <20260709184740.1286561-7-willy@infradead.org>
 <20260710150204.1887475-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710150204.1887475-1-usama.arif@linux.dev>
X-Rspamd-Queue-Id: 073AC140008
X-Rspam-User: 
X-Stat-Signature: tpshhqbbm7jj8kj6usdoj76gkragq9n1
X-Rspamd-Server: rspam03
X-HE-Tag: 1783703818-223889
X-HE-Meta: U2FsdGVkX18ijxdIro+Y+I2XUh8+YslrOweK9EIlOQv4MZ5e2HodSCDuwqSocT+8RgE+5jEE+1Rt9CO4AzoVnVbRVlxpx47ciBOzhkIdyiH9yrmTfKlL4Lk13oq3j00SN9Qd8JVA07jEsHe6eTlWdA+nP+TBxENSFjAXnAvTz8RwXsV3SC7US2aj0Yd9Q2FJgytEwoWEAugsGfCJBfZBd0EyC14OiNSgH60My++2mAaKZiUvdKqnnlT+iF7yFgl2WbbjHnFtwkH+0zWAP50GVhKTndh4rNPLDZ9ILE5wML4ohiUQf39OCq7MC15rK5Sf73dlfiJdlH60JhW423Be4FKgiks1RzDkR7rxKIMDIQc5xWEbrikKhVbCR33jyJ1hpgsf4b6e+AyiaJ9CYA+CjXxPYrBDsLnikwQGYyHs3l5UYT/S5KVNoWnda9MRdOr9KN7kh9NHRcZvWuC8GUcLrjk3srKQW/8MkVZMmid+FBsJeB/6kCFHaBjRc1LTIijC77CyKPzLNvnVy+GN5N6byM1noMaojpyryMVaRJGq9ngl6PUNchr9r/0Fp3Bcio4CTzVGtbyc/8RXFJjynsQKrVs9WRMaiUK1a8/JcjX0GhfHE9jnznAmmYjlWdtrqsKLUxCndg94yNxkXRDWQsGBnoNLSvwREvPklmAsVUf+B2MJYKcgZxxQ27LTMKvMfFVkSN6ICXZfYuOqLYRHyzzsz7tVnU4AtrFu8sExO1mkXybFDj3nBlWFJNPeVZyIds2iMzUzkMj40W8NbhxegWfvx/ifZ/dgeNJi1QAuNgO2SEe8UarKe3ftRwWEnImOyU5Pn3F+IKyoFOE+WthM5tlVCs4VTCJn3mRZ62+TMgm3BQyhxWXDarK0xVb/lHYvmyd+ISTS9EBMdAFQr1LyB51O6t1AMfD6FOMO98OJKXtCwHGf6iyYqcfsMM29HtkR1TaepQcBFlwf2umq6PIZAJs
 fcgLn7Mx
 F0jXa5cbbOTqAJXNeZG/jj+mmv/cVzQ2kTVoISImhhQ4YYNFKxL3Pw7Uvtfxyk432X/a9peaZiX4oVo2mrvlduelRDAjd8J5J67kc9KxtgzSC0E7ca/Tv34XnIE5UKrGxZer/sgN3eCwVTLGOIqbyc6pTNNex8b1SEuSur3MbF5HlGJh/HhMpcRMIpoc1NOFhZwhl7LZx5toJTmRGEjrnnUgFb6SmbRrlDICAO8zr/Mq8ChscfNpT7zmfZNWyovGO7tjSC4tbF1K+zdbT7Wx8b/S5s8O9ntg0zCwNqOcp5tIotAZpGhJSWahUMAtwsqpBu1nbWZM4WZgyFhgLaJqcdeVswX49TF6SotsYTm351uwMhgBQhIILdHOPH1NcbchVRlOfcYNijWZbcmI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 08:02:03AM -0700, Usama Arif wrote:
> > +void folio_clear_hugetlb_hwpoison(struct folio *folio)
> > +{
> > +	mutex_lock(&mf_mutex);
> 
> This wrapper can now sleep, but its external caller is the hugetlb free
> path.  __update_and_free_hugetlb_folio() is reached from
> update_and_free_hugetlb_folio(), which has a comment saying
> "Defer freeing to avoid using GFP_ATOMIC"

Yeah, Sashiko also pointed this out.

I think I'm going to have to change how we track hwpoison in hugetlb
in order to make this work.  Let me think out loud here:

is_page_hwpoison() can be called without a reference on the folio
containing the page.  The answer can be wrong in this case, but any
UAF must be benign.

Grabbing the mf_mutex inside hugetlb_page_hwpoison() is insufficient
because we can't protect against folio_clear_hugetlb_hwpoison() (the
approach attempted in this patch).

We could add a spinlock for protecting freeing & checking of the list.
That's probably simplest.

It'd be better to protect the list with RCU.  But then we'd need to
put an RCU head inside raw_hwp_page, doubling its size from 2 pointers
to 4.

We could completely change how we do this; instead of having an llist,
we could have an array of 32-bit page indices.  Reallocate it when we
run out, doubling its size each time, and put an rcu head in that.
That'd give us 32-bytes the first time, space for 4 indices, then double
to 64 (space for 12 indices), double again to 128 (28 indices), etc.

We could also RCU-free the folio if it's hwpoisoned.  We'd need to
clear the hugetlb flag before asking RCU to cover up this problem
to ensure that any reader that saw the hugetlb flag set started its
grace period before.

Probably all too much trouble.  I think I'll add a global spinlock.

> > +	__folio_clear_hugetlb_hwpoison(folio);
> > +	mutex_unlock(&mf_mutex);
> > +}
> > +
> >  static int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
> >  				 bool *migratable_cleared)
> >  {
> > @@ -2051,7 +2058,7 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags)
> >  	folio_lock(folio);
> >  
> >  	if (hwpoison_filter(p)) {
> > -		folio_clear_hugetlb_hwpoison(folio);
> > +		__folio_clear_hugetlb_hwpoison(folio);
> >  		if (migratable_cleared)
> >  			folio_set_hugetlb_migratable(folio);
> >  		folio_unlock(folio);
> > -- 
> > 2.47.3
> > 
> > 

