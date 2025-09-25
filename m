Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CAF4CAC5B5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 22:35:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 018838E0003; Thu, 25 Sep 2025 18:35:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F32D58E0001; Thu, 25 Sep 2025 18:35:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6F758E0003; Thu, 25 Sep 2025 18:35:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D06F28E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 18:35:34 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 87F04140531
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 22:35:34 +0000 (UTC)
X-FDA: 83929230588.08.F208900
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf24.hostedemail.com (Postfix) with ESMTP id AB5E2180015
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 22:35:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rjFAuv+v;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758839733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hkg5zckxQ8GP8jm1BEOp+9MhHJlmSLMqWWjnVJllXHw=;
	b=vLt9NtGaPefz9qZ/ZxZb9XdAiRDonBwhzRupPVwrsLZDKnwmULmcLSfCPSzVno0VW0Ftfd
	Yb92ZJGKIRRRYxLZC8yXy6RkRHJROD1fs5XfyDw8QFwnmOFuModPMzBtMc2Zy2QcOiukws
	nb2BrFpVhTSuyumCXYQTf7cE1JBvEvc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758839733; a=rsa-sha256;
	cv=none;
	b=bAJl24JG/Z9zFmcB9xR93Cc6ZL/zzB9NDAWay3JOYQ3X/f86H4u+WxBNd1i+4FK7PKblC/
	pexjPDePy/XAFHQzpciW8H5K4RalctgMXfEQ6SesHCj4YhO4mDkuBcvPtgZsnSM3KZzrlT
	0Vbx2YwHZL9+RpueFLiOG0zyjrAaY8g=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rjFAuv+v;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 25 Sep 2025 15:35:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758839730;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hkg5zckxQ8GP8jm1BEOp+9MhHJlmSLMqWWjnVJllXHw=;
	b=rjFAuv+vIIMF4ssQt7iSaVlPj42f/9JuK/CYoEfllfXBMH/2REL4+FHvtzF/DVKNZen3kW
	/hbHNQNKe8LTHEsW+5blhwoc8BpG/Tik53Ff8AgJSWsnzGN8OXRO1DKI2t48WnS5pyTKtO
	KOvRhKrcSCOigK4YnyWCa3/DEkMt/co=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, lorenzo.stoakes@oracle.com, 
	harry.yoo@oracle.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v2 4/4] mm: thp: reparent the split queue during memcg
 offline
Message-ID: <wlbplybaecktirfzygddbvrerzrozzfudlqavkbmhnmoyt6xmf@64ikayr3fdlo>
References: <cover.1758618527.git.zhengqi.arch@bytedance.com>
 <55370bda7b2df617033ac12116c1712144bb7591.1758618527.git.zhengqi.arch@bytedance.com>
 <b041b58d-b0e4-4a01-a459-5449c232c437@redhat.com>
 <46da5d33-20d5-4b32-bca5-466474424178@bytedance.com>
 <39f22c1a-705e-4e76-919a-2ca99d1ed7d6@redhat.com>
 <BF7CAAA2-E42B-4D90-8E35-C5936596D4EB@nvidia.com>
 <tyl5nag4exta7mmxejhzd5xduulfy5pjzde4mpklscqoygkaso@zdyadmle3wjj>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tyl5nag4exta7mmxejhzd5xduulfy5pjzde4mpklscqoygkaso@zdyadmle3wjj>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AB5E2180015
X-Stat-Signature: b6nrxwy5kd6wcwebn7a7w59fsewfkuor
X-Rspam-User: 
X-HE-Tag: 1758839732-650030
X-HE-Meta: U2FsdGVkX19AkpPTMH6HT6oGfjJTHOWW+032PIgYbkaqWBwbrurKFEo+3zFyc5TEkJavALoVNs1HPHBATiP7EskOJ2dOX7ejoOWx3F0kOFnkl6WC+NaiomZEjLMpDxBcE9Q+1hoA9mL4UP/hICF0aV0V+BuugN0kvizNueKo144q4JGivBvCcCgXfCdbnqDstuw13/rsWuxnhUsIT3A7Ns7VInnY0VkDyhW0pHNvpSPFCnC2XDxZ0LPQGXpUWsjsufHSxcTxa4+pcLiqGPlGemjm7RTqI1skWM6JakiAYljTsylSOXcf902cJl1f/TEgtS6dfvGS/jeQVP/e4CurjZGp40eqLlYZSwcOtTrbbES4Gs45HhsftTaXyDcR2As+i5rIfFCaTQGvuwbfBYWlviX8ZzXvKjHXcC/15kd4vX/zTX2eVTCJA8JDFFvm3ro+B2fWnLAxpwdm4P+HY+UBmFTt58BxExDdeayX/jVdJ1zgeRvX9uNvMWco8VK+zc7nSWwQkyHzxZPEuf5m/5wGG99guNJRN7RdLCGEG0WQqJ0I/LyyzaIf27qFVWrqpVgm13nA0tLbZjUqzv3UEFXTnPBZ+25r8JfLNy7B1/AaBdpQ+1yNHOSnmCGTbbtYmu7dfo2olo8xEMZqp1ug7M75aqeG3BIcyHlgE0AYbFW42hUyksT5JHOrKF2vx/ubGsvsjjEXdI8NbR0vb+QZ0+H/FdpqCzgq40hcagl+YHd9NFS95eHFXkmg6Xn8OQDKcqDGaRa9PDLpDbe68rzaCG7/LeIuUlyvCbjbNE6XqU4AqKp1QUq2HYVss9QPifFjazZ+gEpgG1KYMlki40DFCDg4hrnUGzifYcUEfO6uX/ZAN0akJXgsAWotWw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 25, 2025 at 03:15:26PM -0700, Shakeel Butt wrote:
> On Thu, Sep 25, 2025 at 03:49:52PM -0400, Zi Yan wrote:
> > On 25 Sep 2025, at 15:35, David Hildenbrand wrote:
> > 
> > > On 25.09.25 08:11, Qi Zheng wrote:
> > >> Hi David,
> > >
> > > Hi :)
> > >
> > > [...]
> > >
> > >>>> +++ b/include/linux/mmzone.h
> > >>>> @@ -1346,6 +1346,7 @@ struct deferred_split {
> > >>>>        spinlock_t split_queue_lock;
> > >>>>        struct list_head split_queue;
> > >>>>        unsigned long split_queue_len;
> > >>>> +    bool is_dying;
> > >>>
> > >>> It's a bit weird to query whether the "struct deferred_split" is dying.
> > >>> Shouldn't this be a memcg property? (and in particular, not exist for
> > >>
> > >> There is indeed a CSS_DYING flag. But we must modify 'is_dying' under
> > >> the protection of the split_queue_lock, otherwise the folio may be added
> > >> back to the deferred_split of child memcg.
> > >
> > > Is there no way to reuse the existing mechanisms, and find a way to have the shrinker / queue locking sync against that?
> > >
> > > There is also the offline_css() function where we clear CSS_ONLINE. But it happens after calling ss->css_offline(css);
> > 
> > I see CSS_DYING will be set by kill_css() before offline_css() is called.
> > Probably the code can check CSS_DYING instead.
> > 
> > >
> > > Being able to query "is the memcg going offline" and having a way to sync against that would be probably cleanest.
> > 
> > So basically, something like:
> > 1. at folio_split_queue_lock*() time, get folio’s memcg or
> >    its parent memcg until there is no CSS_DYING set or CSS_ONLINE is set.
> > 2. return the associated deferred_split_queue.
> > 
> 
> Yes, css_is_dying() can be used but please note that there is a rcu
> grace period between setting CSS_DYING and clearing CSS_ONLINE (i.e.
> reparenting deferred split queue) and during that period the deferred
> split THPs of the dying memcg will be hidden from shrinkers (which
> might be fine).

BTW if this period is not acceptable and we don't want to add is_dying
to struct deferred_split, we can use something similar to what list_lru
does in the similar situation i.e. set a special value (LONG_MIN) in its
nr_items variable. That is make split_queue_len a long and set it to
LONG_MIN during memcg offlining/reparenting.

