Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2BFCCD8CA8
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 19:42:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CADB6B0005; Mon,  8 Jun 2026 15:42:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37BAA6B0088; Mon,  8 Jun 2026 15:42:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 243576B008A; Mon,  8 Jun 2026 15:42:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 133A36B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:42:37 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8EAA9163546
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 19:42:36 +0000 (UTC)
X-FDA: 84857767512.22.34DF3CA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1B5C0180008
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 19:42:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="ivWG0/Rr";
	spf=pass (imf06.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780947754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UyaugOeWdyxnQAKpdKSlyb4RePHF9b2tnJFLR/rHRb8=;
	b=PlrtClBZ+S/TbjSBlP4vRSywZJcBleLO7cgYuqLG97eL0OOlsnpbRHOuE1dnV/ZLMoarXM
	9if0GdLnBsgZfFwcwcYZ/d5/2kZRU8xYwf3xgW2fylJOfStiWjZGoBgdxzlxCiY3rXRMGf
	FH601/Yk8nsBk016kOdkUODLTjGHMZM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780947754;
	b=y3KuKCSMzHLM1nLGslio4vAmca68T7MfNQ5rlUXtz4vKa9dL+DPlVPGIfrGXOOW85O+S2W
	jpEsk/VgLO84hvixUH7a+ilcHrqIrV8fM5PWu8uHmEHIxX5M+T7r6TRnvPJrtblDD3BUxj
	QSZFtmXljfrFXAs9q2RX8ZQE4uNdi5A=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="ivWG0/Rr";
	spf=pass (imf06.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780947753;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UyaugOeWdyxnQAKpdKSlyb4RePHF9b2tnJFLR/rHRb8=;
	b=ivWG0/RrVbKPioNKLnJNFDTKFW9ey5PzM1HZr/ULHgHlAKiSrEVww7rYPkbaxjq3y+9V7V
	8cCMBVfOKmb3oLO7Z8nNlCih8zWZCgRuY0ukEMWMx55xUoQwAxUuFmxgXlYk4xSDo/ueuh
	6vnN3T0cPNkoogJbE91/mGzdNa1S83w=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-78-etHUnEieO0-4rjhd0lrREw-1; Mon, 08 Jun 2026 15:42:32 -0400
X-MC-Unique: etHUnEieO0-4rjhd0lrREw-1
X-Mimecast-MFC-AGG-ID: etHUnEieO0-4rjhd0lrREw_1780947751
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-bf2dfdc0582so354694166b.3
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 12:42:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780947751; x=1781552551;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UyaugOeWdyxnQAKpdKSlyb4RePHF9b2tnJFLR/rHRb8=;
        b=cRixDU82xRoxdmlQAH1qYGxzIPAgHe8Al1HaEHmXkGNKU/Y3nXFk6HFbhH6KJHjLPe
         STH/0nfJ8bZL2h3KLQYpCj5cPe6VdDQcPKxOGmlaCa8wNLPxDIn9S632ALfDKKemT4nT
         46+DgDVVQbqjgyDjifZM2uuJgA4wajVRjznCNtXBhZanhS0MpSX9OI5herm6I2M/mZ6O
         Mj1i5tXthqQ7HlbPFjU5h8g+2WUUpbR/bIrrY6AUt6yOvHqncv4DRAmukrVolgpPCgnw
         w068Rv8mJLEUvIOxNssZYcuBS7DaKU2cAOsj1vYi20u+etzAHEF7FndaE86eZE3RHwZI
         iKeg==
X-Forwarded-Encrypted: i=1; AFNElJ/I+bsBpq9JHyeU1uX8CPwj8Jm54LYwywHcfEoueTfJ9ZNdbB1PYTxvoTlkmuobqfHe0BxRnCDB3Q==@kvack.org
X-Gm-Message-State: AOJu0YxfuyHwbHvvgLc6OizaqnaFrZuioZ9kqFz7UA4tz4vpyKESlRtn
	AnDkZ72nqcif6dDdMrUTb1ewFoYY2S9GxBk8JTaRG6n3afhdPkUim+8gq/2Z5Z7lu/d9M+y850G
	5ZQO0IUYBcLBg2KMwFXsc6+UcRrOEuLYDu/0eAdkKFYFhhUgDGKIi
X-Gm-Gg: Acq92OGdzpfCiwCPq7+RzrZxUBBMgaCwMnZkp6o1KOjpo4HdbhH4y3/B4Bib1LKoOeo
	jJGaz8dS2ISqu9nfkGvSW0XoTDocuT9PTjOF9GUEGd3Z7bbNvbk5QRpcDkn3w+3ZHf29s9TG+7v
	yqLq1ueS7zPkuJ7UQPLnoTFGzOVh+11cbVpm02utMwdBIYPi6WK2yx5SboZN0H+n19VjftIctX3
	e3LRBMb5ErP4CRCev4AsoQiH3GV57IrwHbemiZPFcITpkm1Ud7rAQLt3T11v9mFYEER9sM6tPDb
	To7N0aCb0M9VtEpzrzkghenjq82ohcQ0NuZNMRlKmBFu5j7LITLtA4xKfIWUoJMBgWq30yz6hef
	zE5ProOtIGIOpBFiqUZ8d04giY+HJs6jvsgsCd8EApI+rkFlnhjWJIw==
X-Received: by 2002:a17:906:4fca:b0:beb:9dc2:6f3f with SMTP id a640c23a62f3a-bf372c2cca4mr809349366b.36.1780947750628;
        Mon, 08 Jun 2026 12:42:30 -0700 (PDT)
X-Received: by 2002:a17:906:4fca:b0:beb:9dc2:6f3f with SMTP id a640c23a62f3a-bf372c2cca4mr809347366b.36.1780947750169;
        Mon, 08 Jun 2026 12:42:30 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bf054e05199sm897247566b.29.2026.06.08.12.42.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 12:42:29 -0700 (PDT)
Date: Mon, 8 Jun 2026 15:42:22 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v10 12/37] mm: use folio_zero_user for user pages in
 post_alloc_hook
Message-ID: <20260608153957-mutt-send-email-mst@kernel.org>
References: <cover.1780906288.git.mst@redhat.com>
 <f92f6f06e5804b4ea7f68b8664b7e69953b50f4e.1780906288.git.mst@redhat.com>
 <aiacZ6_7SG3nvVjM@lucifer>
MIME-Version: 1.0
In-Reply-To: <aiacZ6_7SG3nvVjM@lucifer>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Yha2Vk7h0wwecbWfZFDwAGAzvgUJ8t1hkdmdwBQV7RA_1780947751
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1B5C0180008
X-Stat-Signature: tou6afos3ij8bkz6y3kmybkmbycgsjjf
X-HE-Tag: 1780947753-438882
X-HE-Meta: U2FsdGVkX1+XHHALV0c9AXqU3mh3RnPFuscg+pHvymcGOdoJmN80JxHJm3xi2uS56uwIbyJuwv21EN+C24HiVGbEOiuANst7RXebPaTuTvRIQFnkSdwCPKGDVUaz6MgrI6VIZOv4k4qx+LMQoUd/cnD/undSR7iA2wlw06D5lExEMusHRQEnbGEH0oU9qco9jxJpp/guZkKhCwkXV+IK1w+Q3VqnpwjkzS9rc+wEIxBSje5/d3cLIq7FcZuB1GIsD87tyzW/IIAhNXYILE8ExAhe+KGNaygzAtHcmb/XuqXyuv4m1KWvHINsBenw2qSEHyo2fII8clxCdeyhqQdhB1qqQ+D6TJfXfOxb6wVc52nb3+fQZrU4zmtUmdNphAAWAXMacvnBaXj0gwwradyd0Oy9rvXoDXtmYbMTSJBmu069jOM1IxS0oZVLiNXC62hHOwXFvkdYZGDzaOPX122Npl8v+1MJi8BVC7aEv0WN1IPeGkDXZjSlJ66PisEg22BGVv+uREt/COTUtKyYsFxbhDeSWBBVna/JQMHv2UYJY5hNZc/eg6LZwZjGZn7labmVykRgI2QaPCCGfZhYNDmiIT98LL6GQq3i4WbBs1HGZkLmaSfxIOxScvzGFtIfSJ6B1QFfVKiY9XEQOOsCzfdCdEVlWhVun4mP9TBpLKsaXhG1raLJTcEVgTPqiU8AEQo7V4cf3av53KXuIePOjH69sg00Ny4ikwttsTKDI9UFJqEs1Oq/VzBvk78aK5yADtx2EZIOqMhpZpgNYkHVsTL1ccFiWC/7425ugrXFTewmyHUaf4IUctEVxsfDD8aeFvBpTQR1jRzWqObMOCrM1zhrYFGdYnTTFFLPu6ZYC1kdY1nlS3d958JccnrPltjA/smLakDfHn85Oy77tKJdhcRCSU0Q+5kALginbvUwNIUTCcuR+R6ThVrlAZjhfQEehj/A/MdOepyCxXh3EbVzUwj
 QdLhl7D6
 Un+uukfY0N1wh1z3o7F8/bAZKRW39qNvpQ404oOOdZI22DtGRwKwtWiFQvRG0JbcSnOq3V1rbjEe8WbRsjrxYifPt5u7QCqo/ARovDapKJBnSz1Llz/nNjNWK2L5Q963tMZVGCfFLOaUMuD9Ed7IKLYCC/E04Ua7sB7sx7FYvgu78OkZ3sCSkm05qm0hDSuQTlbbCLH9GSX7HY4c8NeJPp2Pc66Bquf44Vp7Jnaap2x4J8+mrEHJLyGae7RiXZ9EVuthsdloaEzEw1UtN1/w5kzeGP7ZivaZXWEwo4GL1EpPKx8FaY0auDDKz4LQ4Xqg7LnvtkwhIQpLAGcO2yxNny2149v0l7ymw/oZs5MWv11dVbEbrDlpwH3KZdXBGEEAxF2H7AvAgWNpdL2xF7E1Ib9/yPtI0nQj53eptJmPWsHTGqHr688yLlbLihlq3pgvLZcJfRH3IhJkIHAuQ1G4aMa2PuHg6fe5XcxjxSx2EjCLegdzJzsBThdWZAjN1Y0BOgavIbDawVxE7zG3TRLk9dkv3eQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 12:23:07PM +0100, Lorenzo Stoakes wrote:
> On Mon, Jun 08, 2026 at 04:36:38AM -0400, Michael S. Tsirkin wrote:
> > When post_alloc_hook() needs to zero a page for an explicit
> > __GFP_ZERO allocation for a user page (user_addr is set), use folio_zero_user()
> > instead of kernel_init_pages().  This zeros near the faulting
> > address last, keeping those cachelines hot for the impending
> > user access.
> >
> > folio_zero_user() is only used for explicit __GFP_ZERO, not for
> > init_on_alloc.  On architectures with virtually-indexed caches
> > (e.g., ARM), clear_user_highpage() performs per-line cache
> > operations; using it for init_on_alloc would add overhead that
> > kernel_init_pages() avoids (the page fault path flushes the
> > cache at PTE installation time regardless).
> >
> > No functional change yet: current callers do not pass __GFP_ZERO
> > for user pages (they zero at the callsite instead).  Subsequent
> > patches will convert them.
> >
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > Assisted-by: Claude:claude-opus-4-6
> > ---
> >  mm/page_alloc.c | 35 ++++++++++++++++++++++++++++++++---
> >  1 file changed, 32 insertions(+), 3 deletions(-)
> >
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 4676fd49819e..d4fbf1861a8a 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -1861,9 +1861,38 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
> >  		for (i = 0; i != 1 << order; ++i)
> >  			page_kasan_tag_reset(page + i);
> >  	}
> > -	/* If memory is still not initialized, initialize it now. */
> > -	if (init)
> > -		kernel_init_pages(page, 1 << order);
> > +	/*
> > +	 * On architectures with cache aliasing, pages zeroed via the
> > +	 * kernel direct map (e.g. init_on_free) must be re-zeroed
> > +	 * through a user-congruent mapping.  Host-zeroed pages
> > +	 * (zeroed flag) don't need this: physical RAM is clean.
> > +	 */
> > +	if (!init && (gfp_flags & __GFP_ZERO) &&
> > +	    user_addr != USER_ADDR_NONE &&
> > +	    user_alloc_needs_zeroing())
> 
> We check this (gfp_flags & __GFP_ZERO) && user_addr != USER_ADDR_NONE thing
> twice, can we just put in a 'init_should_folio_zero' const bool or something?
> 
> > +		init = true;
> 
> As Vlasta says not sure if we want to add complexity just for these arches.
> 
> > +	/*
> > +	 * If memory is still not initialized, initialize it now.
> 
> I kinda hate that 'init' is unclear as to 'do init' or 'was init somewhere
> else'... Anwyay.
> 
> > +	 * When __GFP_ZERO was explicitly requested and user_addr is set,
> > +	 * use folio_zero_user() which zeros near the faulting address
> > +	 * last, keeping those cachelines hot.  For init_on_alloc, use
> > +	 * kernel_init_pages() to avoid unnecessary cache flush overhead
> > +	 * on architectures with virtually-indexed caches.
> 
> This whole paragraph seems pretty useless and just describing the code?
> 
> > +	 */
> > +	if (init) {
> > +		if ((gfp_flags & __GFP_ZERO) && user_addr != USER_ADDR_NONE) {
> > +			/*
> > +			 * folio_zero_user relies on folio_nr_pages which
> > +			 * requires __GFP_COMP for order > 0.  All user folio
> > +			 * allocations set __GFP_COMP via __folio_alloc.
> 
> This whole paragraph is useless and very like the kind of stuff AI generates for
> comments, i.e. overly long + entirely unnecessary stuff.


It was an attempt to make sashiko shut up, it doesn't understand the
context and kept complaining. Didn't really help so yea I should drop this.

> 
> > +			 * user_addr != USER_ADDR_NONE implies sleepable
> > +			 * context (user page fault).
> 
> Can you safely assume that? Also inferring which context we are in from this
> parameter seems risky.
> 
> It seems to me that you're now making it such that kernel developers:
> 
> - Have to know when and when not to specify a user address, and under what
>   circumstances we might consider that to be mapped.
> 
> - Need to know to do this correctly for aliasing architectures or have silent
>   correctness issues.
> 
> - Need to take context into account when specifying this.
> 
> We definitely need to find a simpler way to do this!
> 
> > +			 */
> > +			VM_WARN_ON_ONCE(order && !(gfp_flags & __GFP_COMP));
> 
> Surely by now we can assume this?

Another attempt to make it obvious.


> > +			folio_zero_user(page_folio(page), user_addr);
> > +		} else
> > +			kernel_init_pages(page, 1 << order);
> 
> I hate this hanging else branch... definitely prefer {} on both branches.
> 
> But in any case it seems like we could avoid some indentation with something
> like:
> 
> 	if (init && init_should_folio_zero) {
> 		...
> 	} else if (init) {
> 		...
> 	}
> 
> Or even a:
> 
> 	if (!init)
> 		goto out;
> 
> And stick an out label below?
> 
> > +	}
> 
> >
> >  	set_page_owner(page, order, gfp_flags);
> >  	page_table_check_alloc(page, order);
> > --
> > MST
> >
> 
> Oh and in general it seems that this conflicts with [0] which removes
> kernel_init_pages().
> 
> [0];https://lore.kernel.org/all/20260422102729.166599-1-hsalunke@amd.com/
> 
> Thanks, Lorenzo


