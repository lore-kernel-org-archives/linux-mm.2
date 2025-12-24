Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 124E8E74900
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 00:58:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50A766B0005; Tue, 23 Dec 2025 19:58:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48DCB6B0088; Tue, 23 Dec 2025 19:58:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 399BC6B008A; Tue, 23 Dec 2025 19:58:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C42C6B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 19:58:21 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AC56A59686
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 00:58:20 +0000 (UTC)
X-FDA: 84252553560.19.B9E2045
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf28.hostedemail.com (Postfix) with ESMTP id F3719C000C
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 00:58:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EJPLAitW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766537899; a=rsa-sha256;
	cv=none;
	b=5Uwh2wRJhfFz9SqcDLeylIeGtyJoZ5qH9VNMJ8EDYdLIqS7iKiHh+OpSPIh+JzwtD32x2z
	9F7aFYrDY4OLbNDNH3RxEbmg4B9nUz2chTe5JlitI/ugqPGtdtvXNvnz7/W7wpBlcAR5yO
	EjNb1iR5xZuBiznwwGihxx068Z4cReA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EJPLAitW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766537899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nMWD7UiGq4+nKnU4Z5jjdenRiWuzNHLLrtk/SYoaKkY=;
	b=pkXI6YnDaaSKPYGIzd8su5isIbqjWt6DKm3B/HreExaq5VBXRt1V8gWZSbifjPaRApV9WQ
	d2071tk0Cl/VF82nxTSXTSGTin0Np4xiR4zeqc3BNP1BJvSyt+ihvHpAARATx/33CHOukP
	1F+tSj/KHW/FGH0DgYOaZwvwtN2D2WQ=
Date: Tue, 23 Dec 2025 16:58:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766537896;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nMWD7UiGq4+nKnU4Z5jjdenRiWuzNHLLrtk/SYoaKkY=;
	b=EJPLAitWCuidgw7MtCISWSK6vFEbH/3fbEMzVSM45A0kSaL147SH1Ar/mBr7f5CW15JMW0
	RLT6PNCvY5dMy/tJdwxdPQziwCZ19S7/ZCzBxoUd6rNB3tzJrQmQDXebfUBksXV3Vg+H2P
	tpcoEKT8jP3bAotwqYs5PnqKtc3LeEg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com, 
	mhocko@suse.com, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, 
	lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 00/28] Eliminate Dying Memory Cgroup
Message-ID: <wvj4w7ifmrifnh5bvftdziudsj52fdnwlhbt2oifwmxmi4eore@ob3mrfahhnm5>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <5dsb6q2r4xsi24kk5gcnckljuvgvvp6nwifwvc4wuho5hsifeg@5ukg2dq6ini5>
 <vsr4khfsp4unk73a75ky7i35nzdjqsbodyeeuxipu3arormfjr@awi2srdwawfu>
 <utl6esq7jz5e4f7kwgrpwdjc2rm3yi33ljb6xkm5nxzufa4o7s@hblq2piu3vnz>
 <7enyz6xhyjjp5djpj7jnvqiymqfpmb2gmhmmj7r5rkzjyix7o7@mpxpa566abyd>
 <llwoiz4k5l44z2dyo6oubcflfarhep654cr5tvcrnkltbw4eni@kxywzukbgyha>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <llwoiz4k5l44z2dyo6oubcflfarhep654cr5tvcrnkltbw4eni@kxywzukbgyha>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F3719C000C
X-Stat-Signature: yb5wrjqhozkfazsx6tsd6oeeemmurgeo
X-HE-Tag: 1766537898-693574
X-HE-Meta: U2FsdGVkX1+R8e3XEJ7pOFVgcWQVe1Yiz2nmSc6npdGZixqXcdZCS0JTi4wc6Mym2bO1k/vBZbNYo50k2bm5B1+8+p8psqcC+OOyHe/4czyX4gUVBga+Iu+twPG/H4GrjAI0zPVBh52/5VbCtfjQB+AjTObdGaA8sk6aeYbNRm3DRqoonHIDRin9xsl9VnX8SnLZGCTnU+Huptu3U8+XXwUOAsUBnkoYi7LvKpsuZrJLtcvMBnqfksMzxmDRf0p9TCOTR9BlyglKpxcQPubEREGBhbshQvBZlQIoWGQcdEQdIZKv0seRpsItdDGgK1Qq8DQlTH0ufxuvqYG1RnCFc98x2My2aCCMEgNi+FTT8lc3QOVBWwgS7DwRDQn519prvqI/8ow0uDdu8rGqWbpKKGiiKTSDHupJukF6uuj6kVkL37GZ5ls0IBYyAQcFVbgkLUzSjP99Wi26/g8D2mq5EIttyks56BFbm7TQ9kCBk9z/yjVr8rEjk9t+0VJAzGlOC4a8FA8UiYTCG/pqy31OVyFxNZ49Q6XU57gcEhwelvqIB0aj1feF7+O1pyziEl7ZaZoKpzN3fY9xMVpYI+dBhBJ+TYSjW4iy+RJvktz6IHu5KRsJwzgfxvbKOOkMAOUZIevYiuMf8VW/L9NvsWK21WrluLN+PQgMcZjPbPL9NVDXI3yHffpHA91lBYf8/h0R1bBW4NPnf6fDb0A0piX5leaL/W1JP4qodzZw9cVOw2GzQgv5rbiamyUDemon22itZWks7ykyLfTtdF3GfBjhvhMX2yYI24grSxk6AcYMqVGaF+yPyzqTBo0/ET6E3ToV6AgQXmr6vYBXxJibveGwygQvL2npL1XPneF7cekmOrkI0DMoEqjmzaFaBX3X/njF5q8mlKsDosucraTrZKrQL/krNHhyA/0K/0su77vzTH3GceWfqhbHJx9WREMfAYBOKx9VdmpLuvWIYhATtCJ
 Yn1J07wv
 ImCvOQueIgFWPT9tBoIQY+SjIC/G0bHNbgThhNMGBwLU21iDIt8XXNe9Gi0cy8QbwcIRsIGmdyNuJTrF0aAwLhCY3RAoBIYkH/sv9leBHKHzZTfZdbBoh1cTqyYTHShowD6uTP0TChDVe9pN3L57G2/hAYRv7+BJ3vZOJ137FFilWFsZSGE+zMJ4fFf3m8P7gGPlRX/idujsGtVI0StSKdNuhGQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 24, 2025 at 12:43:00AM +0000, Yosry Ahmed wrote:
[...]
> > 
> > I think you meant child's memcg here.
> 
> Yes, sorry.
> 
> > 
> > > before
> > > reparenting, and using it to update the stats after reparenting? A grace
> > > period only works if the entire scope of using the memcg is within the
> > > RCU critical section.
> > 
> > Yeah this is an issue.
> > 
> > > 
> > > For example, __mem_cgroup_try_charge_swap() currently does this when
> > > incrementing MEMCG_SWAP. While this specific example isn't problematic
> > > because the reference won't be dropped until MEMCG_SWAP is decremented
> > > again, the pattern of grabbing a ref to the memcg then updating a stat
> > > could generally cause the problem.
> > > 
> > > Most stats are updated using lruvec_stat_mod_folio(), which updates the
> > > stats in the same RCU critical section as obtaining the memcg pointer
> > > from the folio, so it can be fixed with a grace period. However, I think
> > > it can be easily missed in the future if other code paths update memcg
> > > stats in a different way. We should try to enforce that stat updates
> > > cannot only happen from the same RCU critical section where the memcg
> > > pointer is acquired.
> > 
> > The core stats update functions are mod_memcg_state() and
> > mod_memcg_lruvec_state(). If for v1 only, we add additional check for
> > CSS_DYING and go to parent if CSS_DYING is set then shouldn't we avoid
> > this issue?
> 
> But this is still racy, right? The cgroup could become dying right after
> we check CSS_DYING, no?

We do reparenting in css_offline() callback and cgroup offlining
happen somewhat like this:

1. Set CSS_DYING
2. Trigger percpu ref kill
3. Kernel makes sure css ref killed is seen by all CPUs and then trigger
   css_offline callback.

So, if in the stats update function we check CSS_DYING flag and the
actual stats update within rcu, I think we are good.

