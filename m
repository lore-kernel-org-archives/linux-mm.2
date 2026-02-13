Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86D0AEDF170
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 15:07:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB0DE6B0005; Fri, 13 Feb 2026 10:07:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A352A6B0088; Fri, 13 Feb 2026 10:07:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 941256B008A; Fri, 13 Feb 2026 10:07:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 83F1D6B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 10:07:33 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D49EB593DB
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 15:07:32 +0000 (UTC)
X-FDA: 84439762344.14.9D87FC9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0EFD712000B
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 15:07:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=itVjokIe;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770995251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uojxyVfGQerpVYTGu8/Z0EiuhJCcc/owTFnkbrjsF00=;
	b=T4rnC0Xhp4BO/tWi3vf4AIFkRTgG0iTBxWF2jPAxIcVJiTHve63iwO6g2VJnKeEusxWH5G
	ISN4impJ9YL4JQttt5D//MQb4x4n04jgMAcYrjYJwiVq9+lhQcuvAD88MJ5HI3ZGcVGckc
	owSVznyhsR0/fc2gDK6L/sEb77//f68=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=itVjokIe;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770995251; a=rsa-sha256;
	cv=none;
	b=iAdSIn1w9tLKLvKaf2/To2/g9EmzUKIIPW3GWeT0Ype2RMbS+OljEL2rzqQ8YPaUphLbCA
	yHMDaMIpqRVQG8jzRj6up1wLy0G6+6QSm2HC2qDwf+bVXLD5yNORTUbM0rAMwqk9t18Ez+
	Wr7pRkzV9wr91G1qBtT/XGJchE0stF0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E238244381;
	Fri, 13 Feb 2026 15:07:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BA76C116C6;
	Fri, 13 Feb 2026 15:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770995249;
	bh=AH0AJpT++zf8FgMVPuLv37uUnHoF9bm8SpIB5HE8mNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=itVjokIenZXRJlHUJ9HVaveBSwIkb31xiIs8APERZyDSEHQhhGOQH8+c6/PVrjt6w
	 GWNdkc+S0nuG9Jk1RPABvFZLMXXXeizyhCQX+dAm1cAT6er0rW+doOgmeDuHt3pTzU
	 EYZSmGpEi+DtVX29+iVJBTWxMt1b4FjdsloGU08icpY5RBh4HHGxzqgvBkxL//ww8/
	 6bb9SScoffEzJquBntlPZNHCPA5iEO6gnRWNZLND3kd5CXnn3Yb78y1K4jp/IaZ1mL
	 cs1GNkrljONHfMsOY8wCnKR3nBRsBvyVypQ+WpNEFpbS1tS12wy1VHMWf5ZemAIz/d
	 tzR8dPeuoaqCQ==
From: SeongJae Park <sj@kernel.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: SeongJae Park <sj@kernel.org>,
	Qiliang Yuan <realwujing@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Lance Yang <lance.yang@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9] mm/page_alloc: boost watermarks on atomic allocation failure
Date: Fri, 13 Feb 2026 07:07:20 -0800
Message-ID: <20260213150721.72997-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <c2388a14-9ef1-419b-b86a-56629708be15@suse.cz>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0EFD712000B
X-Rspamd-Server: rspam07
X-Stat-Signature: p4wp9fekhbesjtmbizwbrmjhh715nw3t
X-HE-Tag: 1770995250-344556
X-HE-Meta: U2FsdGVkX1/frjWROicEGpXaAUZKlal6pCThvfLBXk0f3nJcblNpmDpEYQculyr8Z28L9D10g0x8D6wkKihwuSLdurCJ/LmoM50VgEIR7ZggTP63ufSK/CGSSqbaJYYbCkyehs0XYqz3TXKQgOOnvwoDZc7MWUyrPJtyi3nV1HV3G3r3d0MnDoATQnX3QpD1mHQhmt+rtkRIsR8NgJDjAKdHtWJ9pH/oCcyhCkoPgBmt2zuTdTRWkcKbbJUCUDFz9uw29jWTMdleht4xT23HUTid3cmveQuFZ30fbYDznmjX+E+qFrhs1bfpHY3kbIyBVeJ1gXkx5hS6A10NCmajVx3lKfrYvkdhJwvzIRELKdxgJU454JG9qxIgnFYxNtQ+96BA3r0a0NWJ29BTN+FNyVaBccNHtQ5U6lham0IFQRmH1xjtdRzHjHxGxaJ0zcqQJ0g8Kvd5DadGwYmwHWupc17cCusSdjhZGi+ufdoiwjHopZxBi/v3c2Jd4BgAzSiuyHehbJ6P1NCcIJjKFo5tvz/saIK9v2d4pPPUq+R4OW9V+EaQivneT30oWDWnjmw4omqMMVIlmYr8TPrIz4PW09RRJjydvkPQlL/GK+sKVQ6kti8DCT2fwecgu7T7Yp84frOu94pp50hXUzwZ8Sfo1mERRDZlZDK3Fak2ElOREEKX6iastrYqUdaJCzG2aApEu0qO6O6YV7smRRcYxUWMJLTPLasn1R9c7IGpLsCRK5vQFUtMHu8KSTeiZeiB/8KVvph+BtvdW7hmmGsjQ4I4ft1dHeRSzW1hDmGIo98VgWfF96mBz9r9lSU1vr270DV80a4loeeZgUC+KqeEb40gu1l7D2aRQX87LqlA0iO6wEKm0tC70zwfLxStTMfu4zyae4cioOZklEoIsGBXEJD4czggTNZQFMC9yHpTOl5oSqWNH3N8oB14esrrZAHCnGbrNO2d1qenI9rBOdRKsKL
 +4x5Lpbi
 r+107f175AzOZApyfPMUPhv4ZYKrJfYEhLvtTgqBFDtNcIRVdVpfVlToijyZp9tH1E7FKxPVVh2LMxLdu4JAI/zS6C0HtER6ZxhlXrlMrMUOIWaYGo18sDGXG9N/OGJOkwVYTPLaXuZ3d+xqOGnjit0DGIMO7RO+JF71CxO9qKr2bdmTVcCGSWCb532DYvfHa1Rbq50PTShHk2w0BJ8NARDn/lHZ3aszQSiPyje3hsMmfWMSu+QyinrE6shoBCTLMiY0+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 13 Feb 2026 09:46:14 +0100 Vlastimil Babka <vbabka@suse.cz> wrote:

> On 2/13/26 04:17, Qiliang Yuan wrote:
> > Atomic allocations (GFP_ATOMIC) are prone to failure under heavy memory
> > pressure as they cannot enter direct reclaim. This patch introduces a
> > watermark boost mechanism to mitigate this issue.
> > 
> > When a GFP_ATOMIC request enters the slowpath, the preferred zone's
> > watermark_boost is increased under zone->lock protection. This triggers
> > kswapd to proactively reclaim memory, creating a safety buffer for
> > future atomic allocations. A 1-second debounce timer prevents excessive
> > boosts during traffic bursts.
> > 
> > This approach reuses existing watermark_boost infrastructure with
> > minimal overhead and proper locking to ensure thread safety.
[...]
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index c380f063e8b7..8af88584a8bd 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -218,6 +218,13 @@ unsigned int pageblock_order __read_mostly;
> >  static void __free_pages_ok(struct page *page, unsigned int order,
> >  			    fpi_t fpi_flags);
> >  
> > +/*
> > + * Boost watermarks by ~0.1% of zone size on atomic allocation pressure.
> > + * This provides zone-proportional safety buffers: ~1MB per 1GB of zone size.
> > + * Larger zones under GFP_ATOMIC pressure need proportionally larger reserves.
> > + */
> > +#define ATOMIC_BOOST_FACTOR 1
> 
> ... so now we #define 1 but it makes little sense without that hardcoded
> 1000 below.

I agree.  I think it could be easier to understand if we use 10000 as the
denominator, consistent to other similar ones, like watermark_scale_factor.
Or, defining as a constant local variable or hard-coded value before its real
single use case might be easier to read, for below-mentioned reason.

> 
> > +
> >  /*
> >   * results with 256, 32 in the lowmem_reserve sysctl:
> >   *	1G machine -> (16M dma, 800M-16M normal, 1G-800M high)
> > @@ -2161,6 +2168,9 @@ bool pageblock_unisolate_and_move_free_pages(struct zone *zone, struct page *pag
> >  static inline bool boost_watermark(struct zone *zone)
> >  {
> >  	unsigned long max_boost;
> > +	unsigned long boost_amount;
> > +
> > +	lockdep_assert_held(&zone->lock);
> >  
> >  	if (!watermark_boost_factor)
> >  		return false;
> > @@ -2189,12 +2199,43 @@ static inline bool boost_watermark(struct zone *zone)
> >  
> >  	max_boost = max(pageblock_nr_pages, max_boost);
> >  
> > -	zone->watermark_boost = min(zone->watermark_boost + pageblock_nr_pages,
> > -		max_boost);
> > +	boost_amount = max(pageblock_nr_pages,
> > +			   mult_frac(zone_managed_pages(zone), ATOMIC_BOOST_FACTOR, 1000));
> 
> I don't think mult_frac() was a great suggestion. We're talking about right
> shifting by a constant 10. In the other cases of mult_frac() we use dynamic
> values for x and n so it's justified. But this IMHO is unnecessary complication.

This file uses multi_frac() in two places with hard-coded denominator 10000.
Hence I feel it is more consistent to use mutl_frac() with the same denominator
(10000) and consistent naming.  In terms of overhead, I think the added
overhead is negligible, since this is called only once per second.

No strong opinion but just a trivial and personal taste, though.  Right
shifting should also be good to me. :)

And now I find I was thinking the ATOMIC_BOOST_SHIFT coulb be better to be
consistent with other similar code, because it is defined as a macro.  That is,
I was assuming it would be used in multiple places and therefore better to be
easily understood by readers.  Now I find it is actually being used only here.
What about defining it as a constant local variable here, or just hard-coding?


Thanks,
SJ

[...]

