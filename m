Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AC74606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 02:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Kmi42mXl
Received: by kanga.kvack.org (Postfix)
	id 21FE66B0646; Thu, 12 Nov 2026 21:37:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AABA6B0647; Thu, 12 Nov 2026 21:37:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 075406B0648; Thu, 12 Nov 2026 21:37:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D05086B0646
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 21:37:16 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 30005120252
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:37:16 +0000 (UTC)
X-FDA: 85428534072.01.0F2B667
Received: from mta0.migadu.com (out-131.mta0.migadu.com [91.218.175.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id 36DC720002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:37:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Kmi42mXl;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.131 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794537434;
	b=wXLdZIuevuhfLo0i15YExSiKRl8myY8Xhz4JUDh7Y+akiEa+BLx/I3tDWRtcsyky5gYGBG
	zG5RdXCUdahKcJpSOhw8JnDq8eCcw0uRU3q1FuUi6C1Zq20fwhvpgoT6wiVn09RU+P59jP
	nyXeX0pBFvvA5OaGhyyoncTJAWwUP2k=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Kmi42mXl;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.131 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794537434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K1FZSZTtwlQFE90cbI0Nr3F5RUyKerMzzNbSuIEFiEg=;
	b=VPD1pjVWQwsIcBoJsVTQ+/tVqwx9aLRz6JbSPVr/v0f5XMeYPvVtYWRbinw7zX+8piKgDw
	E9oDAWrdyFxPPETJOTBBQdG5R0PNeAIY4czMxLEhFf0a1Or0jI2RE7VZysWPC2bCEyavgQ
	JrHRC2YMzSDcdTjXhR9XJqXxsvFwqyU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=MFXk5wTZQlNYOhRGLZAR7H0oTSAkWycqp+1VJkXLZqo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794537431; v=1; x=1795142231;
 b=Kmi42mXlThlbRJtif9w0jI/C3akIzoRzs+jo9m20zM/DvMgcGRPO8XeGs0yhyiOO8CDfTl8W
 VuZLmw8sC/4EbVCE87fDYr4Wsh8UlxQkxi0KnQ5rw7fx8+cBCCSEET8OfOgenNnX1cREAfhlg6p
 2XRWMiXpgmH3dhF+SBEK91SU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 5429636b6996bd30;
	Fri, 13 Nov 2026 02:37:11 +0000
X-Mizu-Trace-ID: 5429636b6996bd30
X-Migadu-Flow: FLOW_OUT
Date: Thu, 12 Nov 2026 18:37:10 -0800
From: Shakeel Butt <shakeel.butt@linux.dev>
To: sashiko-reviews@lists.linux.dev
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Dave Chinner <david@fromorbit.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	Chris Mason <mason@kernel.org>
Subject: Re: [PATCH] mm: list_lru: don't use a new memcg's lists for an
 offline memcg
Message-ID: <avZ3rcGiLnWS4qUq@linux.dev>
References: <20261112221248.3512447-1-shakeel.butt@linux.dev>
 <sashiko-outbox-211977@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-211977@kernel.org>
X-Stat-Signature: xftezrc397omx7f97s1nidu58khy57cm
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 36DC720002
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794537433-709748
X-HE-Meta: U2FsdGVkX1+ckVO1HdYUhvpjcSOjtR6/0V/N5QZrjx3vFKmHhR8mKfbCtCySFUKZw6XijaTxAKbdQY80NU2as/PtDQeY6lI74T8GBYERkEJ88/Tw4vVTGxnwwpwq/eS/D0XKdV9q+dVVsOiil+1fm0x8Q25FkVZzGV/ej/POL/4vijCDwxLP30IL9xpJWH4Zb/Ln4SsXYfnX7UbA6dlP5azYnVQlekKuCMVgrrsMSyEaTUKrE1jY2Hfh4Gb9AooC57wAar1PSTSJr13oPdW9hQuIvRZzMHhyYjt8BpYhVRWtMMlDnTQV9o5sXUy5Uw/ZnBQy7CGz4b2+paZfcsso5+FhsI65LAoYN5Uf/XBrIDLwet72eEBzN9uZJ7QvR70VwYerJu1Q+jNEY1VvmGx7JiJVBxPAZFSP9cpJN0DRfwXxC6QXO5APMBd1qLAvCvBaAUrnPbj+JJE5CoGWn7NjtQcZQBg6Tz+/8WwTY53uA5hpwHOvuUWHApO9LFKq1hy7ru0h9ZNqMxJMDSBEQKwKQ+wZVzyPSIcFYo+hKRRhIF39G6JsdNDgsTuUnu8Wer1ubNWznT2+ad3By749XWcHbRX0DYIVy/8sv1DS3u3WIko4jTMwm7LQDxnlzBmuE58FWxpxu1R8Mwuw3j5oDhxAlK74N0uuyZXyawib8LJrO18iQGwfz7S6Hs6SZ0o5XVmFHV+HJ8Dbh2w4nOnVYRWmaaNQDgwjVRyidtSV2BxM+Ub+siQfkldY8GAUm1yBKqYfbF8/0DXwT7kWbDnuyrucNcOJmYpgHH1rLHZ7uf6Rhii+kRRmaDeDjqjruFT1oUukKOrq5V67zia4TPX9a/s6EP/UzFvHY1zFJXaVEevnxdw7aYVinHpr5VKQd53Rl4LJiL/lQqhSyCJvflnX/GtplNsHi2cvKWd/FPNSgdN2PdGWNAWXF4QzRcnhZzS4KUIbHmF+yIAVg8ON8Gr++xM
 JgwxDOH+
 +FoIN1M2IZk5/ecWOQUlxeNGT434ut1lGnGEdP3iRhhR2Q6Am8On86IMj48N5RE87bysUfZbwdDt/ZMFbULvCC6gLHUlgCsx7b0GqhvKN81qPgipCQJIlYN3W7R8aFe5DtLfuZ70SKaqAyoMmn4IpVP9gRqzwYGgYcexkdklq0pnEJ+YsDY8S75aHhO49EIP4ESXQUOGfkIMaAHZz7OA2FZgnTcTCn89K0HDRU2RENzfvm6psVb1ntp5Cde3yTfhfp00thcr1AeYJfJe9h8h/L1MQ7j6jce7DnKFc1WmgOzguGDhzLvIpiCv9eKN8WMu9J6jxT6JP8kgG506fINHl4BE1bNVKW+CvVLctJzH0wiUQV76XsshvESB9ig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 12:15:11AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [High] mm: list_lru: missing mlru->memcg check in
>   memcg_list_lru_allocated()
> --
> 
> commit d213b82b7b4ca4978c858df10a2a8cdea14626e4
> Author: Shakeel Butt <shakeel.butt@linux.dev>
> 
> mm: list_lru: don't use a new memcg's lists for an offline memcg
> 
> This commit records the owning memcg in struct list_lru_memcg and checks it
> in list_lru_from_memcg() so that an offline memcg whose kmemcg_id was reused
> does not use the new memcg's lists.
> 
> > diff --git a/mm/list_lru.c b/mm/list_lru.c
> > index d1d256822ccc7..937dbf239c9d4 100644
> > --- a/mm/list_lru.c
> > +++ b/mm/list_lru.c
> > @@ -72,12 +72,15 @@ static int lru_shrinker_id(struct list_lru *lru)
> >  }
> >  
> >  static inline struct list_lru_one *
> > -list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
> > +list_lru_from_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg)
> >  {
> > +	int idx = memcg_kmem_id(memcg);
> > +
> >  	if (list_lru_memcg_aware(lru) && idx >= 0) {
> >  		struct list_lru_memcg *mlru = xa_load(&lru->xa, idx);
> >  
> > -		return mlru ? &mlru->node[nid] : NULL;
> > +		/* Lists at a reused index belong to another memcg. */
> > +		return mlru && mlru->memcg == memcg ? &mlru->node[nid] : NULL;
> >  	}
> >  	return &lru->node[nid].lru;
> >  }
> 
> [ ... ]
> 
> > @@ -602,6 +604,8 @@ static int __memcg_list_lru_alloc(struct mem_cgroup *memcg,
> >  			if (!mlru)
> >  				return -ENOMEM;
> >  		}
> > +		/* Set before the lists are published, and never changed after. */
> > +		mlru->memcg = pos;
> >  		xas_set(&xas, pos->kmemcg_id);
> >  		do {
> >  			xas_lock_irqsave(&xas, flags);
> 
> [Severity: High]
> Does memcg_list_lru_allocated() also need to check mlru->memcg == memcg?

Yes this is correct and Andrew already have a fix for this.


