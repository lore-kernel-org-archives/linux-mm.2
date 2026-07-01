Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79CEEC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 15:28:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A1D66B00A8; Wed,  1 Jul 2026 11:28:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 151A66B00AB; Wed,  1 Jul 2026 11:28:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 042CA6B00AE; Wed,  1 Jul 2026 11:28:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C646C6B00A8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:28:26 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4E6D81C7282
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 15:28:26 +0000 (UTC)
X-FDA: 84940589412.04.3332A6F
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2F1041C000E
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 15:28:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=A9AHdTMA;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf18.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.176 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782919704;
	b=jlHWvJ84nSe+HsHbhAQBM8B5FN5fgsePemhuon/3yiB+hxJv5BIj8AAqKcaMb6vymN/gMH
	h4wRz69j3vbLD+qwW5+CC5E/HjHUprmySVrvCjIa+MNyj6cKvWPTYYrbiD1Aj86SkYptWT
	P17E2Kj9+qgSjQC3pJzZpq8+TmS5hHo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782919704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qhbSR1sJa9JZNfq4AjFtt9zAbsMr2JS2dPAyTfvfRWA=;
	b=U42qhKdwzahdAFLFHkMIG9IWPo+pX5xobSfwEyTMNFtRZOAhNiYwcpQ1oVclpIkXYh5VfQ
	TpVCNFSQ4iNf7rWrRdG4fw1hq1DsKYq2z3kzzmMYkMM3RpUO54FFRCm7fvly/7eI4c3Nyh
	oC9B2Psv88D93fQNnhtbQiqjhIffLr0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=A9AHdTMA;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf18.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.176 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-92e5d50b0dbso66030785a.1
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 08:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1782919703; x=1783524503; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qhbSR1sJa9JZNfq4AjFtt9zAbsMr2JS2dPAyTfvfRWA=;
        b=A9AHdTMAwKpTGKbul6gD7L9sQNCHc8D/YTsnd1F59+pTDUVviUfyGRDMHECIUZ7DEE
         yOf5drI0YBA4g/3BjaXGxry+iwaQCHj3KWDvy+sXv6Wr5zO9qFbVbHWmZXUKjh6lTN71
         lJMJE3XSRPWtPqroozGjZZQgekV6ZF8x09YSdPtXXJCbI1PyjRzeOcgGpAd75ISxfOZX
         3F/ZCunTIe0VGk0ksd6vzFJfuB/Qu+cXOScTNvxO2JbAT+zj6ahFzPUcKXb+wlp16uhM
         DgL+fN3rZEalVlfd/5cnrI9FemnHCL8ZFjjXFaMlnwAn0Z5TSPS7Qx26Rbk+T1hyLVcx
         zwwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782919703; x=1783524503;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qhbSR1sJa9JZNfq4AjFtt9zAbsMr2JS2dPAyTfvfRWA=;
        b=PfP3cKLKa+kOFEjBLdg+x7alUziBM1CGxtbeBmX2KXOSkM6/KQ8Hds5iqQdmg8HZnh
         k88UcWYMWnos5F+IC0JwYstlz6glUg1zs+S93IXquBZDpp1czXrN6U3qy24TgTuTE9p0
         lD8OLJjd232olyiF5iCDHHcw220T5aBJI7vo9OfqDB6rImGgZtKPS4Q+EEYbHomemjIP
         MW6s0W5s7e009QlDY/Svi11MWPUyVa7yQ/Q2QqANDINRQd+HInACWgknL5n00iJCouNq
         gvD9j9LlmcdH8+gVzewcU7mlji/+3fqVLMSlvzCq2p/VWarIfsZt5n1OqY072eTx5GT+
         Px7g==
X-Forwarded-Encrypted: i=1; AFNElJ/yhsU4KcknyRV0Jhoe7/ywKoW8wmio0hlxf9O3TGpMpKAonRKdXxEx2XuiBzwr7ovM4Bc9XJDwSg==@kvack.org
X-Gm-Message-State: AOJu0YzBADNMdL6SuyduR5ZJZx0tAiJ5EUnzeJdywAqQDZSe2XnMTC67
	iBLhldQEGJSDHYnnEibPmX8ftOQ0On7BBY9VBxGtx+jE1hnu5GogKUkwKIvJ/H6SNKE=
X-Gm-Gg: AfdE7clUuoW5DEDLhV2jOcBYW3Uj4Qz9/R69djOiubc/u2+VphGp4ygcc/MAkd/U2I0
	eJyYr2fdqs3MDYm/cACchUCdt28XGLJrH/MctTqvfIX6STw1SDLS2k8vDF8RIgXl+GqVaKxcfkN
	9L1Vyk/9tLuYjxQJYvcDQIoQONzlAUs+oL9ky5ZrmQODZoAqCFawYiRjX4w0vq78/GLpyvh7qF2
	7VwbZsG5GTj8y460lkipIQkjjKIbvyxrJ27m2SdFM5uHhH0LrC1YCnI8VFgJzx7T0DHTDh8KoTH
	LjxDt9FmLV9TT24nW6uTipa41bQGuzCtBLOuMSHvD1JvTRhlPw91aEFy2r2n8lwlMmp5oAD+ybx
	gJuqGSm0foK0eBewafXr6TGP08SlbJdvXOX4DTfFwgNPS4D5XAe49pKZSmxVbg+Qgvz4jacEUr/
	wf0pXDXbXGakA=
X-Received: by 2002:a05:620a:444d:b0:92e:72a4:f279 with SMTP id af79cd13be357-92e7b37424fmr203341185a.46.1782919703137;
        Wed, 01 Jul 2026 08:28:23 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e622e7fe3sm590479685a.27.2026.07.01.08.28.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 08:28:22 -0700 (PDT)
Date: Wed, 1 Jul 2026 11:28:18 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] mm: compaction: support non-movable compaction for
 pageblock requests
Message-ID: <akUyEgKMryy6TntY@cmpxchg.org>
References: <20260626182215.1107966-1-hannes@cmpxchg.org>
 <20260626182215.1107966-3-hannes@cmpxchg.org>
 <e36dad58-d259-4533-be08-50d667d5144e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e36dad58-d259-4533-be08-50d667d5144e@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2F1041C000E
X-Stat-Signature: m1obu3ufph8wjoyw3drpoj8ytrznr94q
X-HE-Tag: 1782919704-186895
X-HE-Meta: U2FsdGVkX192WmVhsS7s90Q7DBBCEyOiMPuBH4uR+1jxg7wbHMAEMxLJoP+Isxi/11oXFrXxUC3yPUOINH/jm94toPsgWH72S3UepnRugKFrJDGciKb0+pddvYL4Iix1VNThcj2g7Cc+FB5HhZ5cvI4zXnC3xoShWwpbcV2ytbpnlP6qhOmGVhgsS63xh0fUe/gj5n+1Laxxu/CrwD5F0ERtd98qb1auDSFBf9+TXlEwevWxC2ZxUoO+HKlhrkHqZU9bJ+sJPM3k8x4QImMGgriGoD+UbvnH3GZhnoOOmKTIjswb+zYseGYDIkKPgWkLkVGtiZgk9hbAYovZ3DvTce6xkeMdVOoq2F5JbpKJyXOr9CedOm8vTKUf/YtQPnDZB0j23diVCcejRIsIpT5hapPnOatX2WHsl7NPEhrx6MOgR9eg9sg8ZsaOG7pKa77MHzRZYBiYMBu80Cu5JbVKRVnE/sXjojmzVt8VWbHuNekE7gm/pfwXt+Z6Rt+bKBGiCrvvLlvUDxlTwzHILzja6ZBx+ju7e1Ofm0CGdTjRs1GpwyowFZgVsjURCAVKrOVfdZ9SL50dWbt+0mi5r49GpxjEjY136LelGskCmoRqvPoYgoE5jrgPeqxxZHjVUmU8dzELaXTNTirP94ZF5STxpzlRi1JNEXQMDyjbevxaFRJzEvbRulPX6Pjp8c+O7bPLGGelqwe5DKK8+ZhlXnKDeC71Sgnb/lJILJbYfuEb7u5bT9Sh3zeioLOis9nbp8gh2DVgtNWZWUCSSeLzRTnz409CDjpalDFBgiFEQbhRy4U6KyJaQSxtLKTG8saUww/sZEnB4VwmTNfwM9jsiz/lc5Pvmz0hIDRqivXG5eIPTsCk1/D6j9iIsOHDgx7EEWDMCr4kDT0afXKD2mxFNt4exyZ1aHUM2a+SOwNbGFds3ghsG+5gMlCcJvGnPs4fyrHr7PaJ3q856O6/LUswvig
 wjUwgmyz
 imt5naR9CSFshWZdtyrqItMr9DBf3ZM7pI2Zi3kh1pdyBhs120LRpAqFzLamnLgF34Gru1R9JCAgaRWH/VRc7w0xEoUVGu+aLa0KYy4rKuLgI7kAeruPD+veBIpu8vN7Yq3inJtXq3g4zxNPEg99YrMSTe1AhRzlmLj4PR7wKy8b6S5wourQE04dPFhWHmLz3mbShV85HVKJYbacQohUTRUoY/qy7fCKiX5cRVtKOTSIo161LYt7HiLwHiP8x4LMGVBmtzutOG16o2tXaASzK1OjcGNNJKRV7m9ytkaWwf0fGKORfUB+HpGkNzwgmatwDVrVS6deT7RpQMcYkLBGz3+vUv8dn+K2H/NTIFxmEVxqlG4LAgVQyfUDLKBnhv4CXe9+Kvs6maUjN5RCg61F5zw74YcQD/5k200ze05JCkDFLih7f/MtVdCZ0BXVHS43YzQlVkRVh9CYkuUM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 01, 2026 at 04:19:29PM +0200, Vlastimil Babka (SUSE) wrote:
> On 6/26/26 20:21, Johannes Weiner wrote:
> > While trying to fix a reclaim storm in defrag_mode, I noticed that
> > non-movable direct compaction is extremely inefficient.
> > 
> > When searching for space to evacuate, compaction only allows blocks of
> > the same type as the incoming request. This is to prevent migratetype
> > pollution, where a small non-movable request frees space in a movable
> > block and provokes the allocator to fall back and pollute it.
> > 
> > This protection is reasonable on one hand, but the downside is that it
> > makes non-movable direct compaction nearly useless: if we get the type
> > annotations right, by definition there aren't any movable pages inside
> > the non-movable blocks it is allowed to scan.
> > 
> > With defrag_mode, the goal is the production of whole blocks, which
> > are essentially type neutral: __rmqueue_claim() will convert them
> > wholesale on alloc. This makes type mixing and pollution a non-issue.
> > 
> > Fix the pollution gates to take the requested order into account, and
> > allow whole-block requests to scan blocks of other types.
> > 
> > The only exception is CMA blocks. That type is sticky and these blocks
> > cannot be claimed to other types. Continue to be strict with them, and
> > allow only explicit ALLOC_CMA requests and kcompactd to evacuate them.
> > 
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Thanks!

> > diff --git a/mm/compaction.c b/mm/compaction.c
> > index f08765ade014..7df3a85d43af 100644
> > --- a/mm/compaction.c
> > +++ b/mm/compaction.c
> > @@ -1381,12 +1381,33 @@ static bool suitable_migration_source(struct compact_control *cc,
> >  	if (pageblock_skip_persistent(page))
> >  		return false;
> >  
> > -	if ((cc->mode != MIGRATE_ASYNC) || !cc->direct_compaction)
> > +	/*
> > +	 * Background compaction produces blocks for the zone at
> > +	 * large, with no particular allocation context. Allow all
> > +	 * block types, including CMA.
> > +	 */
> > +	if (!cc->direct_compaction)
> >  		return true;
> >  
> >  	block_mt = get_pageblock_migratetype(page);
> >  
> > -	if (cc->migratetype == MIGRATE_MOVABLE)
> > +	/*
> > +	 * CMA pages can only be taken by ALLOC_CMA requests. For anybody
> > +	 * else, vacating a CMA block consumes free pages the caller
> > +	 * could have used, and produces free pages it cannot.
> > +	 */
> > +	if (is_migrate_cma(block_mt) && !(cc->alloc_flags & ALLOC_CMA))
> > +		return false;
> > +
> > +	if (cc->mode != MIGRATE_ASYNC)
> > +		return true;
> 
> This now stands out as uncommented. Can we come up with a rationale? :)

Let's see. Originally it came from here:

commit 9927af740b1b9b1e769310bd0b91425e8047b803
Author: Mel Gorman <mel@csn.ul.ie>
Date:   Thu Jan 13 15:45:59 2011 -0800

    mm: compaction: perform a faster migration scan when migrating asynchronously

This limited async scanners to movable blocks. By keeping them to the
most productive space, it keeps their latencies down.

But then there was a follow up here:

commit 282722b0d258ec23fc79d80165418fee83f01736
Author: Vlastimil Babka <vbabka@kernel.org>
Date:   Mon May 8 15:54:49 2017 -0700

    mm, compaction: restrict async compaction to pageblocks of same migratetype

This made the migratetype filtering about preventing block
pollution. The patch quotes reduced extfrag numbers.

So now we have a block pollution guard that we apply only if... the
scanner is latency sensitive? :) Is this actually desired behavior?

Another way of looking at it would be this:

	/*
	 * Allocation fallbacks can spread migratable pages
	 * into non-movable blocks. This is high-effort,
	 * low-result work. Restrict it to sync scans.
	 */

