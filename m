Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F5EBC5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 00:57:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44ED56B009D; Wed, 19 Aug 2026 20:57:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 425986B009E; Wed, 19 Aug 2026 20:57:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33B826B009F; Wed, 19 Aug 2026 20:57:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 14E7A6B009D
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 20:57:32 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 218571C1A06
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 00:57:31 +0000 (UTC)
X-FDA: 85119834702.17.3293585
Received: from mta0.migadu.com (out-112.mta0.migadu.com [91.218.175.112])
	by imf27.hostedemail.com (Postfix) with ESMTP id C946B4000C
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 00:57:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Pe7zO9zO;
	spf=pass (imf27.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.112 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787187449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5TG1b8QVpNt8y8d3fuSQwRv4xsw8hTvY+gqUoeNgI8w=;
	b=mdtkD8F9gBV4ALpF6CE9/DBxFW8VcU8E/ZFSIPIWvMuwEIoBEWjCXZn95QJZCXfcQBQQNx
	dkS6sC4XZ+jA/FZgrL8r3k2NDB6j+j6FIbVRIz3HYFD+N46As3Ge4QRhHp6QAIO3rlwe7Y
	oh58E+cMb/IF+u50G8tGj/a12yy+kUE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787187449;
	b=gXncDcINLbvm4Z/kPRvnUv5tNBJTwVLys3IwsKemD3LPWLMxh2ae5175NA8/6+GWThL9Wp
	r5fxWH8hm1ePadsxOkb+2iE1HN8UysyMaUDURRdkGcX1XCwcpPomhQjtth525wMqNFsLgQ
	nOGhwO+F8rgh0wQZBlA/U39Ibi2tZLg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Pe7zO9zO;
	spf=pass (imf27.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.112 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=W5bMEGa3K0yKxwJJ056tu4gCbLooVX1YsofUpz0vBZU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787187445; v=1; x=1787792245;
 b=Pe7zO9zOQTqAq5uNnVZid5txuhBeo716DGjKXmN8B6Uw4crSGltQ2UUbZdv7AGUrcTxijvye
 LvIAkWGDWuHDRIMPd7BanrhJ/QqPJHH956vHq33W+gaEJDvtj+on7cvw7Z6BDzv1+8NNw7YweFb
 FosP9D0qnAFFrQyPp7E0npKg=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (3.112.29.171)
	by mta11.migadu.com with ESMTPS id de9ebbe7155f0653;
	Thu, 20 Aug 2026 00:57:25 +0000
X-Mizu-Trace-ID: de9ebbe7155f0653
X-Migadu-Flow: FLOW_OUT
Date: Thu, 20 Aug 2026 08:57:18 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>,
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH 7/7] mm/mglru: improve code readability and harden
 folio_inc_gen
Message-ID: <aoZQ7oUMupCen5H0@MiWiFi-R3L-srv>
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
 <20260818-mglru-flags-cleanup-v1-7-8dbbdac0d28c@tencent.com>
 <aoZQD3b6q8s-pXU0@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoZQD3b6q8s-pXU0@MiWiFi-R3L-srv>
X-Rspam-User: 
X-Stat-Signature: brr8q1s9jczqaf9yxruuht3qqc7ngsba
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C946B4000C
X-HE-Tag: 1787187446-479237
X-HE-Meta: U2FsdGVkX18Tu0XT65TyYMr9uXmhUCcvgmfLn9I2i4uLGw4/p9F6U4j9tXDUptA0wZiecICU2NARRYO2YvHrgkrrh1OrQFUAV4Ha33tjYAv7fCwHUWR2paePAGZPveP090rX28QU7LDoz6DUCss48ARx+/z7fOFAl1Fd7N7Y4EWLes6aO2fsPZnAAJuqXlK2VvxZEI8i0ij2BCFbfiN+02Z421g+X0MylNfVzy6GKOnXUC5OxQtTmIgG9ll42Tp5EGEriBXAI6MYl7fSMga2bD1vtDOtwZofzr++YdeLDFsp7fIo63hOH1mw18N1Vsx8BdLXzDzrgPGq+pPyjKr7Anx+ErCTJPtn4HfIWYdtl6JYvx8ostTMwoULNapS4vEoeo+LGf7x2w40zokYUiOpEhOlNDCW7jtq7GaGM30e2XqFZOaA+TQu5WFniLjUnNlv1M8Wbas3lHkhEC2kd4jbJLvLfXezm7V0X6jArcYBtp2Fc2dL8yu+gA4XCYTYIQ5633boPjZd8Fbq0DAWeaTXvvwzFLDlGy/QPtDzB9kp4jdErhmwWWgHKjxnoHrLvXTMLXXwEkvDZbrBJCvztdkLAcClxlUu4TvWBT1WdNo4mfKb+dnLpUYJBmg7OIflTkM0Sio3KUewKXyVE11ZGp6VbgGwyc/OTtKJyGuJJ+xeIyM9fQFTYNvOSyrqCB+pyLNunvQnMlJCsQAw5WGkX3dI1UhT4roMaZexPultN3tUQ25vrGF3KyA7dqZghK65NOmku6vn9olPtD+dPGB+z1DKhja5XOfG2tBDFlVDspieUhvIDhdOY1w9JKXZs8b+O9IFhG6ItoEtReYJ4aQG61E4RCtxCAKr3wE+jsL/oTmY8eH+pkfBSI16dQko9NGkLkhdFfMhRhu6MmhtSLK9hTJ6gVgO87s0ORcHgZkkFMXDCvSehstNgNvWiGqrxRnW74kQeLSUSKzeA1JBnBMpm41
 Kqz45Wot
 wX9h7xn7moC+IbWGsmRr+KatvzTMijuVHNDp8HEKARsx0XrkSRkF45N1112PCqw5QOrn8ideaq8VpA7pe/FD4WI+4bGV6xDZYHfJrerZyeWB9nhtpoBpyHqz465HTmNZI6eIIPsorgCmfTjNSnAmjXAwSUb0SSnVp9uPBv7BOuFSZcXG6REZZ85HY24FNKcjjTju3C70d5jOF1cZ/gQvEMdx3PD9WJFaIR4sTg3S15Tz684RycvxX/XzGEMMdRJXhZgm77P7SGEbDm5hn4fDpRIvhHR84yJ4PaJg9hgdQqLpAf7WJpS/6UaPzN7MsCRqVJG28seoFPtaLUk3Ii6Kcfzk+ALcCWGAjbNUX262dBwkOZqE3F5GxuxVYU2hi90ZLjj5XUik99LKn0EogkU2QylgZcHzwVjl6j7SIOWej5nXmf4RPW6r+Qzmmrm/v8+4CkaUqr1/OXir8A9lHpEZjBaUxmAiAdvCXSvu1KiNEZvDLnfRwmDMcfh/dBhrZLJIplOikQwgWIFf5AfBz62wojXG0Z90+4qVFsy3F2+pkVbWE61vzoq5jJGduXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/20/26 at 08:53am, Baoquan He wrote:
> On 08/18/26 at 01:38pm, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> > 
> > The helper should never be called for an off-list folio, and it always
> > expects the folio to be in the oldest generation before doing any
> > cmpxchg. Add a sanity check for the off-list case: if it is ever
> > violated, bail out and keep the folio flags untouched to minimize the
> > damage, instead of silently treating the folio as if it were in the
> > oldest generation and promoting it updating the flags to an unexpected
> > status.
> > 
> > Also rename the variables to clearly distinguish the folio's current
> > gen from the oldest gen.
> > 
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  mm/vmscan.c | 14 +++++++++-----
> >  1 file changed, 9 insertions(+), 5 deletions(-)
> > 
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 7169cac60869..7e3ae0c6cba3 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -3308,18 +3308,22 @@ static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
> >  {
> >  	int type = folio_is_file_lru(folio);
> >  	struct lru_gen_folio *lrugen = &lruvec->lrugen;
> > -	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
> > +	int new_gen, old_gen, min_gen = lru_gen_from_seq(lrugen->min_seq[type]);
> >  	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
> >  
> >  	do {
> > -		new_gen = lru_gen_from_flags(old_flags);
> > +		old_gen = lru_gen_from_flags(old_flags);
> > +		/* This helper should never be called for off-list folios */
> > +		VM_WARN_ON_ONCE(old_gen < 0);
> > +		if (old_gen < 0)
> > +			return min_gen;
> 
> As Barry doubted, I think this change is wrong. old_gen < 0 in folio_inc_gen()
> could only happen inc_min_seq() call it. While inc_min_seq() call it
> because inc_max_seq() need increase max_gen to max_gen + 1 and found
> get_nr_gens(lruvec, type) == MAX_NR_GENS, it has to move the oldest gen to
                                            ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 2nd old oldest gen. Here returning min_gen for old_gen < 0 means it will
  ~~~~~~~~~~~~~~~~
Here, I mean it has to move folios from the oldest gen (min_gen) to the 2nd
oldest gen (min_gen + 1). The empty min_gen will become the new max_gen.

> be put in the lastest max_gen. It may not be expected.
> 
> >  
> >  		/* folio_update_gen() has promoted this page? */
> > -		if (new_gen >= 0 && new_gen != old_gen)
> > -			return new_gen;
> > +		if (old_gen != min_gen)
> > +			return old_gen;
> >  
> >  		new_flags = old_flags;
> > -		new_gen = (old_gen + 1) % MAX_NR_GENS;
> > +		new_gen = (min_gen + 1) % MAX_NR_GENS;
> >  		lru_gen_set_flags(&new_flags, new_gen);
> >  		lru_refs_set_flags(&new_flags, 0);
> >  	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
> > 
> > -- 
> > 2.55.0
> > 
> > 

