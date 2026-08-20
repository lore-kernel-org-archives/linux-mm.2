Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FAC6C5DF85
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 02:27:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 100766B008A; Wed, 19 Aug 2026 22:27:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D7D66B0092; Wed, 19 Aug 2026 22:27:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2FAF6B0095; Wed, 19 Aug 2026 22:27:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C85306B008A
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 22:27:40 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4B8B312051D
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 02:27:40 +0000 (UTC)
X-FDA: 85120061880.29.AE392F7
Received: from mta0.migadu.com (out-63.mta0.migadu.com [91.218.175.63])
	by imf05.hostedemail.com (Postfix) with ESMTP id 26260100003
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 02:27:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="At/R+v4T";
	spf=pass (imf05.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.63 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787192858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HQ4JrqWfg6rcUfrxgmks5B59bH5YLEOCIKTUbtrUoAw=;
	b=aiPHmFGFXUidH7olA2lZn87PwQwDU9mldaLopJmNl1OaqQBH2n5+Ytu42fX71wP9iaLOtG
	0E9vywCqTlpX49Sk6jd+Pyo6IiUPxbfCJZ8e8rKhPfyu9gZI4yWNnMF5njFf3okLFZKH9f
	72NrAamBY+p5EG+nLy/nPOffdW1QGAk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787192858;
	b=Jg7dAh2UUIYy9BdR0bU/7Jqe/JfaEpycKObr7PlC0A87RcpSwHXzEFfcdi/g7lOhD6esCz
	QPOEYDm0faS3kKfIKvZs433CfvuynGJPQOB+zj7lyqGswstPWEq6wfjvZaplckI4WjdHAy
	yYAbu9+97dhGvDmajzXg85Rfp1u1tJI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="At/R+v4T";
	spf=pass (imf05.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.63 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=YsLQYCJr8WPj7R2aBamgjE8gGQQJpFvoi1/lm8X5IB4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787192856; v=1; x=1787797656;
 b=At/R+v4TjNAVFSN5Gp0ZDIh+L83/8tWvUX2pvfs/cT2liC6rbzZkw9n1Vcvuxm3PAtBeYOu2
 AXQAMcK53/FZnmQSmkBSzsB6U0mMdN6npqguJJjoqSxHRpPmw9z/mnzD8y1gEchBwzy5FM8Axci
 qblAu0kqUuXLCj15F6J2D+Z4=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (223.70.159.239)
	by mta12.migadu.com with ESMTPS id 541c12e0acfb2d92;
	Thu, 20 Aug 2026 02:27:26 +0000
X-Mizu-Trace-ID: 541c12e0acfb2d92
X-Migadu-Flow: FLOW_OUT
Date: Thu, 20 Aug 2026 10:27:17 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: kasong@tencent.com, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>,
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH 7/7] mm/mglru: improve code readability and harden
 folio_inc_gen
Message-ID: <aoZmBUKokVVwGzUr@MiWiFi-R3L-srv>
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
 <20260818-mglru-flags-cleanup-v1-7-8dbbdac0d28c@tencent.com>
 <aoZQD3b6q8s-pXU0@MiWiFi-R3L-srv>
 <aoZQ7oUMupCen5H0@MiWiFi-R3L-srv>
 <144f8a6c-8f1e-4793-9ed7-78f06b0e93c4@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <144f8a6c-8f1e-4793-9ed7-78f06b0e93c4@linux.alibaba.com>
X-Rspam-User: 
X-Stat-Signature: 9a674hqdj177yqaoarbqji7pgyeoqyci
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 26260100003
X-HE-Tag: 1787192857-132964
X-HE-Meta: U2FsdGVkX1+zRoGIVIgpCUhewsj9DqZLxvgc10e1zSCSNMgc3/ETaNZTsLxvYGe+t2LZ7BqJ1qoDV162EU/SJLdTR/EP/3LQx598T4RjzUxvc7Zs0mbL7KlACQZOWtRG53/tvXG3L7jbRs7kCbRGT9jD+KetGWKUPerL0W8A7qMogB1hrjv9AYMQvYcVDX3aOxtj3Y609JaIYFqbZxm4KHN/8xpUAsIuOWkoEnu1i0Ahy8iGX57pm57Sxxyac6W2TteZtPgKrQBAvjm+3rlCL8eNLhrEMUyDRwojrGROF6yFasI8SU4G90hd4Z2pLJfgHw8vpCKu8ZQ+EoqkB/mU7pTt2TArM4ab4xybQypm/D4L74zTCsHheuS7h36bZ0C+xN7jAJZ/rEE0vlcBA8APG+DrsRpLRYIk2KvEmb+CsKnhUfBSheFbvGnj4ZVIueo13PlOKytzCZGDzwg0xf4QZg/GSe34+6ia1JOtjxKr9BFSpbP9N6fDgmxMhRAGUCBdaawaCd8LcQ2lQdT0NTXqYEBSn47dNa1xeg4NT8vGeRKGRFNe8GchAnl99YeCycVzgYvUfc8pwGfwOuV/WoaieohjPyP71CBziOzd63epwe/iPUW30So3Ytfi0bOkne6K5P24KHb7GpUsyNxDtd9JoZZZJ6PI74QRLX+ZremXS9Jl0xb0Nnu7m0Bo6U7kAX0112v1P/fifqlEdlBDUwvlv35l8Cg9E12gVh1k1WQ3Mp87St1HxjWdnYDHhougUjvBkbWXTUAcp0XbfaapPt10U9CqxGJ8Mf+x5bRd2NztoMBcTr/Mp2imxn6Obv3fBhtn2c7Yj1M/ZFOWBZEebnKiiUxioxd2Kw5Y4AA9ZySBtZqtM5kLQIItJC6kI+9M7qCawp+WUugk5B5aHr6iWIZ8fITnS4HxryXJNWQ2hX+vi4col44Mkkqn33+7D4ZUEUajvtcRZQIHuqTaTxuEDTM
 /wWOirut
 VO651RgK06MPQr+nbQvoGiG/1Bw/snDDTIJ29dXef40r7DcMcM7RDYIk9177JJu8CFpWOYJY+p6CU0HdTC4wDb8e39/zjL8u5kw8eRZH/HUta/OO5O6uuKunsoWcOpKXWSO1jpbKUXrXp3wth4MnqdVpVHKONeeB1LQeyCxLaNqOzCnKCGuY4j8b6WNsWYHr0DxXmysdK/bEX05DJXSPQQkhTElAt+WpLnBTRGrMGY1nQjdZ7UOv/PH16bPj4UTZyuh/6y/zdmd4p2r9XJcrNwtGb9Q5fQpe2YjX/qbcMskZRQfdR6Dq0Pz+VQ10iLewfRdUgol664LEjOQAfYw13chePwWoucXR8F7wtj5qM866lH5vasi6d9cE3RCQdD8CGeH2zTI8AtEFeNkRzOtJt3X8Tk5E6wdzH4OeVd9gZp3w0uumKe3MsPEjL2jwDv7xS6oX9JfbRGrRpiNBb/ulCK2Ekh1GqNm/D12+tQLhFuWZwHxtumUw5+MmlUuZxLhAnZLQFMyMtCYCZW4I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/20/26 at 09:02am, Baolin Wang wrote:
> 
> 
> On 8/20/26 8:57 AM, Baoquan He wrote:
> > On 08/20/26 at 08:53am, Baoquan He wrote:
> > > On 08/18/26 at 01:38pm, Kairui Song via B4 Relay wrote:
> > > > From: Kairui Song <kasong@tencent.com>
> > > > 
> > > > The helper should never be called for an off-list folio, and it always
> > > > expects the folio to be in the oldest generation before doing any
> > > > cmpxchg. Add a sanity check for the off-list case: if it is ever
> > > > violated, bail out and keep the folio flags untouched to minimize the
> > > > damage, instead of silently treating the folio as if it were in the
> > > > oldest generation and promoting it updating the flags to an unexpected
> > > > status.
> > > > 
> > > > Also rename the variables to clearly distinguish the folio's current
> > > > gen from the oldest gen.
> > > > 
> > > > Signed-off-by: Kairui Song <kasong@tencent.com>
> > > > ---
> > > >   mm/vmscan.c | 14 +++++++++-----
> > > >   1 file changed, 9 insertions(+), 5 deletions(-)
> > > > 
> > > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > > index 7169cac60869..7e3ae0c6cba3 100644
> > > > --- a/mm/vmscan.c
> > > > +++ b/mm/vmscan.c
> > > > @@ -3308,18 +3308,22 @@ static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
> > > >   {
> > > >   	int type = folio_is_file_lru(folio);
> > > >   	struct lru_gen_folio *lrugen = &lruvec->lrugen;
> > > > -	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
> > > > +	int new_gen, old_gen, min_gen = lru_gen_from_seq(lrugen->min_seq[type]);
> > > >   	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
> > > >   	do {
> > > > -		new_gen = lru_gen_from_flags(old_flags);
> > > > +		old_gen = lru_gen_from_flags(old_flags);
> > > > +		/* This helper should never be called for off-list folios */
> > > > +		VM_WARN_ON_ONCE(old_gen < 0);
> > > > +		if (old_gen < 0)
> > > > +			return min_gen;
> > > 
> > > As Barry doubted, I think this change is wrong. old_gen < 0 in folio_inc_gen()
> > > could only happen inc_min_seq() call it. While inc_min_seq() call it
> > > because inc_max_seq() need increase max_gen to max_gen + 1 and found
> > > get_nr_gens(lruvec, type) == MAX_NR_GENS, it has to move the oldest gen to
> >                                              ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > 2nd old oldest gen. Here returning min_gen for old_gen < 0 means it will
> >    ~~~~~~~~~~~~~~~~
> > Here, I mean it has to move folios from the oldest gen (min_gen) to the 2nd
> > oldest gen (min_gen + 1). The empty min_gen will become the new max_gen.
> > 
> > > be put in the lastest max_gen. It may not be expected.
> 
> But how does old_gen < 0 actually happen? folio_inc_gen() is called under
> the lru lock, so how can a folio listed in MGLRU have a gen counter < 0? If
> this can happen in any case, we should fix this bug first.

That's a good question, and I agree with you that folio_inc_gen() is
called under lru lock, and lru_gen_del_folio() which clears the gen
and take folio off lru is also called under lru lock. So old_gen < 0
here is a "should never happen" defensive branch (plus the
WARN_ON_ONCE), and if it really occurs there is a real bug to fix.
Wondering how Barry trigger his printk debugging and observed it.

However, the defensive branch itself is incorrect. Not only folio of
old_gen < 0 are put in the new max_gen, but what is worse, it doesn't
clear the old_gen <0 in folio->flags even though it's put back in the
min_gen list, next time aging comes to next round of min_gen and sort_folio()
will get a lrugen->folios[-1] out of bound accessing

static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_control *sc,
                       int tier_idx)
{
	...
        /* promoted */
        if (gen != lru_gen_from_seq(lrugen->min_seq[type])) {
                list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
                return true;
        }
	...
}

So I think we should keep the old code unchanged, fix any warning report 
triggered by VM_WARN_ON_ONCE(old_gen < 0).


