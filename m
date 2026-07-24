Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE1D9C531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 18:07:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D42E6B008C; Fri, 24 Jul 2026 14:07:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 884AC6B0092; Fri, 24 Jul 2026 14:07:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 773BD6B0095; Fri, 24 Jul 2026 14:07:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 405E56B008C
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 14:07:40 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B34A08011F
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 18:07:39 +0000 (UTC)
X-FDA: 85024453038.24.0CD8E6D
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf07.hostedemail.com (Postfix) with ESMTP id A203C40007
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 18:07:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=XRQut+gp;
	spf=pass (imf07.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.43 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784916457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nJ7PDP3fl+p5a28n/jRHcjrCN1+1Z9szAdk1WdxxOqM=;
	b=5GIXASeypx96ZOGVAcWQSzcnKnQ8q5Om/Onm6XLIFbDWHjzvJ6BhmacUEQWzu6PCLZ4U8n
	QV3w+V8W1IPveAk3CmcmOt5KsP1H/fJgBaJwVJsTnJCgBaVDg6GMN7RhoN1MHOuE5/yBNk
	R1TkYHE6cR3zSqIlJhPeRisVBegDYa8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784916457;
	b=EDwfqG1g+ds2KM3FLAHtWz74Ns/THTknwxgncVcwtSsWgrUYM70HxGGRJXA2GzqLrDA0XH
	l/+oxHjzHfPkMTbOasXlDf9yUocquOIZCcaQVLbDVp7HzWeXi0AgoisQYCQShZH/de8fSx
	1z7b6RHP2fvrZrowNEUO+3jeNUrefLw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=XRQut+gp;
	spf=pass (imf07.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.43 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-9030f8ea3b3so7899386d6.1
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 11:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1784916456; x=1785521256; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nJ7PDP3fl+p5a28n/jRHcjrCN1+1Z9szAdk1WdxxOqM=;
        b=XRQut+gpkoNyDOjKc9uccUzRnToMUjxfODTTcEblCNhZirmx9ZiXw1jYxNFY6Z2hEJ
         xDUoIrWYhoaxYgjLNdm6XVwExzbVyfCcilHA2brdNWgMrPXCu4UNcxkVBSk8/DCXP0Po
         ATt1ezZKOj/A7vY9nVdGwgFt+GZPbudLKPpM6XbARcyz/2npXVAt0EHQWfSVVZKa1Max
         M7FBlW9QQRcXJ9LUJOzxdT78uBpBHfBkt6xglbDf0OLXwU0S9V4IGca6PhYqb1bMxXPQ
         wL1ApClBc7b+NE5m6X8YOXgLCh1oqzrXuytxQNQlRvNe31x4vhnuk9IygRTnyVzaeE5d
         yBuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784916456; x=1785521256;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nJ7PDP3fl+p5a28n/jRHcjrCN1+1Z9szAdk1WdxxOqM=;
        b=I2WFXR5pckqJV46sYNUPV71Scu+68KijHTNka+iouhy9bSYsYPjGLjsZuEAaS17/CG
         OtZIOMoRlzeSQ4xTXj9VoeRaTeqnoZvdKCiqjnh0k16pW0VLuiXpTV+WorLlR524qrlh
         7NrBrSwkn37WE3fK336mn4/LmOjf70lvXoduCG//Pwa0rtHP3gFTAnuOGkRQWon0+lvW
         xJaouA+oalxlTQXrsxCPio8tYSc5baijyubalQldZ0HVh/Lhr72PsU0Mebkam49aVuW9
         6Cjdi9Xn55fRGUyrTMRX93Z9YCpnZW/BZPcqsdJoa0rNQIsNinFHu/pO/lQnIx0nkO7k
         I/1g==
X-Forwarded-Encrypted: i=1; AHgh+RqEj/auZORXEyhoVtlZwt8EQwL6uBRSft8918Ao6AoP0z2RLEipp5hN2jEVfnVxLvXEyQrp0xjFXg==@kvack.org
X-Gm-Message-State: AOJu0YwkBicEj6nAQ2052In3vIC9oIBlkv0ruE4hGneKDIxg97l8srFi
	C4hrU/Vgc1XrbLwxUVTg0ouf4Aq/EpwIlB3czdxAe4/sG1aJf7Ofxu0axTdzO5XHX/0=
X-Gm-Gg: AR+sD10/c3mPxoW5K1sDDPCwfp/XoixfdLQB1r2YLnp8JuHYmyvP/bBCQEajKpY/89f
	CC5O7wOR1UfZvI9XLjJbJNhfdFCqs2lvJcx+bJBM2QpwidUp03gIzXfFKxY8ES52b8Wcsa88EaT
	kSKWn/mKbioO3xtnql8LHQROYtnRRTDlqz2Ur+3fQLtFDcnaU1SINiybqjwsxonfmHvnCTvZulM
	lXTR2yqtdhEYz/H1U/YOO1bAy8VMmAYJL4+LR3TeRrlNIGBN0yIQJw7J4WS0BOx9jbY55rh4HlU
	02nns9lzgZ2bYqNW5FodMc/Uon1rIws7ZOTq9usi1xslNdUVclJJoyzhvCJA6Ak/rDZh5DH52T0
	xLh0RAev4g6Bgusp932OO0BuNaCQdBwC8fxpnoHmMc3Ngx1kEuU0dyJzrNhHpytfnmiYRNBJBnz
	w76jCYM2qL8Ek=
X-Received: by 2002:a05:6214:5c01:b0:907:562d:e3 with SMTP id 6a1803df08f44-907ca33efbbmr100210026d6.39.1784916456394;
        Fri, 24 Jul 2026 11:07:36 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907e854feadsm3525256d6.15.2026.07.24.11.07.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 11:07:35 -0700 (PDT)
Date: Fri, 24 Jul 2026 14:07:31 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 4/4] mm: page_alloc: fix non-movable reclaim storm in
 defrag_mode
Message-ID: <amOp4wV3Yl6PKx_1@cmpxchg.org>
References: <20260722150006.3848560-1-hannes@cmpxchg.org>
 <20260722150006.3848560-5-hannes@cmpxchg.org>
 <DK6WANTYCK4H.CRSXHW3ST1Q5@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DK6WANTYCK4H.CRSXHW3ST1Q5@linux.dev>
X-Stat-Signature: nign9gno7jokop86h74gakzpib3csz1j
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A203C40007
X-HE-Tag: 1784916457-36816
X-HE-Meta: U2FsdGVkX1+U81H7yb9D3YboGKgEaDBjxdf9SL1QlsI77QtgNoJYVEZlxCTjHNz7bjZuxRAygTQxdXGs2pPsfnurnAFd8zMz3QYgnQPq7rY2dRSlmdV4QybDoHWCEs1cf+Y6PEn3vNVzE6K9SqRRsJJ3BOx/Rp+aST3PmxmtWkGfdnDwimYTd36w+gJl5J/7lD4WAnnGfTIAVO5jMyLtDCpM/rzEIxyufUvUbGJu8hUnTIW47kpZg2bRRJha5QyRk87OZy8HSRIDfRT8ga9g8iSbzbzEWNzK4i5a/kMnKzHO7cYCF55zwc7Lr5cEmrKhrHufZ6o/4FFkkUhPkrIxzEnMeRsqmSz3FSXg8ng88eGDzNhPXJvvW+VBmx83aBD5aCFJfLXTa3xIa/vmuzox9j2bwZiPf14E5/VQOeu1jFdRQxxs/ywRkkWOQbrfmdeEOxVFbWhkVPUpyNHGhM7kUhgoQNhQyJt2dJNqn/NeZdYbDcmnyMIzwkrpwkPrqNGCTCzwQdJLdOcghM6INx+lTZdFjSXFuiiHvYYTahnXlL9SZ3N6Brjh4FT0COV8c+KHsQbRs73lfU1t1ozDStpXqtiNVwrdJVt8FaCRdcb4rLMoQhGxvxmNVlZFDyAKA0yvtK/JlUADdy45LIPS7ABa+Vwyxr1MJBuYn+ZCNgMKiXoxPsOaefONDXha9krIylMw7nZjmkAdBQ4iUF5dUB6SNp2TFw9uHhBG6D++zrEaECVqXv0J+LUpFurNQi14p6+1fl1j9pHCJI/G0fg5rKSGTtMxRJiKd1lOX4uRdRc+V+ORAHh7ifxutzJFv+hDF4fFe5apqUE+OCA0PniuFxpG49b5Ruh/f83tSu6ty77n9HV3fHP+T+7dHpqG7oG/5Mb2LFN/EgQ5NzhEGkqv+a36R4i6DVAKSZ69YphYvlFAPN3fWz8SFG75CklzdeviJLGMRbxJbOx0vdls5qRMClJ
 n+sVTw3E
 4b3QvehN+AV0ec5gj1EteSqNFLTaFgIBWSbgZwVWuQsl9ICIevvC+vVYhpFurIyixo42tnqQnbTGM9rf6PDGYew8fopc0krBkJK0+312y+wu5oAHbUVcKyr6nUBhehVTD+gzQUta+SH+yPM3/Y5FJISWEptjcvTByPXYfRvxKKWRE+aQO9cOjZJA/qt9fRsZ43BliHvlYE5YTL3lsTy7y5JE9v0sAAGCESyYd5yRbwnV4wAlpJfPPlBzd5SVAuqbvMVOGcQcFYDONPFqkBO4QPmIo7dRKNcqsnElmx97it6CiKouenYKqJShHBgwTOTh3I7iqK2pP+Hs1rL7N/QfSsCl8pPyDe85Rr7iFQK8qNgolBknfMlXUlGMIrKS7YfZ5+x98nsJhoU2ro8/LZb1PHpgWTNv2ZWF/5nvACQhhW3NnUa6Vq5RBuY0BfL/2/Y4rg7IUgeK5ER76wjo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 24, 2026 at 03:09:49PM +0000, Brendan Jackman wrote:
> On Wed Jul 22, 2026 at 2:56 PM UTC, Johannes Weiner wrote:
> > As we deployed defrag_mode into Meta production, pressure spikes and
> > excessive swapping were observed on some workloads. Tracing confirmed
> > that this is unmovable/reclaimable requests spinning in the allocator
> > and direct reclaim, causing excessive amounts of swap.
> >
> > The initial plan for defrag_mode was to rely on kswapd/kcompactd to
> > produce blocks, and if those are overwhelmed under high pressure, let
> > the allocator fall back (__rmqueue_steal()) after its retry loops.
> > However, that retrying results in more reclaim on some of these
> > workloads than we'd hoped, sometimes excessively so, spurred on by the
> > !costly order conditions in should_reclaim_retry().
> >
> > The storms are dependent on the request type. Reclaim will inevitably
> > make room in existing movable blocks, since that's where the LRU pages
> > live. So if movable requests retry on reclaim, they make progress.
> >
> > When non-movable requests spin in reclaim that isn't productive. They
> > cannot use the individually freed pages, and the process is unlikely
> > to accidentally free whole blocks to meet the ALLOC_NOFRAGMENT bar.
> > They spin and overreclaim excessively, which tanks performance and
> > triggers userspace guards like swap exhaustion or pressure based OOM.
> >
> > To fix this, send non-movable requests, regardless of order, into
> > pageblock reclaim/compaction. This way, they help move things along to
> > meet the ALLOC_NOFRAGMENT bar. After this patch, the reclaim storms
> > and excess OOM rates are no longer observed in production.
> >
> > The longer-term plan is still to have all requests, including the
> > movable ones, help make blocks to spread the cost of defragmenting
> > more evenly and fairly; combined with proper watermarking to reduce
> > allocation latencies in the common case. However, doing this naively
> > unearths scaling and concurrency limitations in compaction that need
> > to be addressed first. Promoting just non-movables for now is the
> > minimally viable bug fix for the above issue.
> 
> Please forgive the noob question, I'm still struggling to get a really
> good mental handle on this stuff. But what about compact_first here?
> When we're promoting the order for compaction does it also make sense to
> promote compaction itself?

My understanding is that this is just an optimization for requests
that are more likely shape-limited (block contiguity) rather than
capacity-limited (free order-0). In that case we do a quick async
compaction attempt first and skip a potentially unnecessary but still
disruptive reclaim invocation.

However, it does seem to me there is a bit of redundancy between the
allocator and reclaim: direct reclaim also has that early bailout
condition on compaction_ready() for costly orders.

In defrag_mode, since reclaim is promoted to pageblock_order (costly),
we always bail reclaim on compaction_ready(). So I would assume there
is not much difference from which we call first - although I have not
tested it.

> I'm aware you said "minimally viable bug fix" so it's fine if this falls
> outside of that, I'm just trying to poke around to improve my
> understanding.

It works in production, but I'm not entirely happy yet with the retry
logic. I also find it somewhat difficult to understand, especially the
split between should_reclaim_retry() and should_compact_retry().

I'm working on unifying them and put the defrag_mode order promotion
directly into the slowpath function. This way we can use "work_order"
and "order" throughout the functions and its callees as appropriate.

But yeah this is follow-up work to the fix here.

