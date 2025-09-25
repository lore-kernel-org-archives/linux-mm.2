Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2C5BCAC5B5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 22:15:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C4698E0003; Thu, 25 Sep 2025 18:15:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19B5D8E0001; Thu, 25 Sep 2025 18:15:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D8898E0003; Thu, 25 Sep 2025 18:15:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F09828E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 18:15:39 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A76911DFE28
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 22:15:39 +0000 (UTC)
X-FDA: 83929180398.27.7CD27D7
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf02.hostedemail.com (Postfix) with ESMTP id B6DE78000C
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 22:15:37 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nExaS2C6;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758838538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W+bbO6SaS0KRxab+lWSDdoC0WeKs4PytoWV0GEgq6Tc=;
	b=7T+ORWidwxQ/5dNTsl2edT4uUeVJJeqaQSXbofjKX8b+wVEWCzRnkZn8qx1fUOq4LaX2iJ
	we5gC8NRm8rfEsznygDrxkwoINduFb2j1+t6G6uVyXFfgwRm81LF6SGilEXLmd433oAFpH
	+Csbq/xsOoMYRNtUrutBBQimRAuyG/4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nExaS2C6;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758838538; a=rsa-sha256;
	cv=none;
	b=htgMokNRu23evBJkFFcn99xEqlhYw+m5ZL0w7nOrbqfpPxGnWJm3lqRasIH3TzKe4HVNZQ
	A2IHv4RVfyZfVxNFfGhGnAV9KIDsFzf3Rjoyh/8N6BrnSu1sSdKkyELHTejiPp9OU2geYT
	tvChAs95XYwNuv1it3co+NEhQbyhxk8=
Date: Thu, 25 Sep 2025 15:15:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758838535;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W+bbO6SaS0KRxab+lWSDdoC0WeKs4PytoWV0GEgq6Tc=;
	b=nExaS2C6Dcgxn4eNrjxVd//6ySpTajLoWfisBDkQtd1gKwEcoBmyBs8d0B45hZNvfkAHVT
	KarzIBsSkiP9PK+tND5YDgP7MySL5zFSP5y+cdhaCd4Lzkhsuu+go4bfuYXrcjqqUvPait
	I4XbqyYwMH3IUKyzloJRC0B5mCs6OCE=
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
Message-ID: <tyl5nag4exta7mmxejhzd5xduulfy5pjzde4mpklscqoygkaso@zdyadmle3wjj>
References: <cover.1758618527.git.zhengqi.arch@bytedance.com>
 <55370bda7b2df617033ac12116c1712144bb7591.1758618527.git.zhengqi.arch@bytedance.com>
 <b041b58d-b0e4-4a01-a459-5449c232c437@redhat.com>
 <46da5d33-20d5-4b32-bca5-466474424178@bytedance.com>
 <39f22c1a-705e-4e76-919a-2ca99d1ed7d6@redhat.com>
 <BF7CAAA2-E42B-4D90-8E35-C5936596D4EB@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BF7CAAA2-E42B-4D90-8E35-C5936596D4EB@nvidia.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: B6DE78000C
X-Rspamd-Server: rspam05
X-Stat-Signature: 8izuoo5ioriwz39ioei6makjudw1q7qn
X-Rspam-User: 
X-HE-Tag: 1758838537-380112
X-HE-Meta: U2FsdGVkX1+2VYWpEJx9ApRCYdrOAStLquBP74tGsOL4YFKA7p0X3Tot47NV9a/sOyO/XZM4pWvhrN2Bosb8HqGqRDiM7e8ob2cfsiBvWdaprSyIfSNzgkPiYVju2QW/t56EMHI6MxeSiKb5lTSAj97arRTs1fwrikOFmNETnY4CEWbjlAvxBjnR35i4ui/Fj3xQG2GZV8KS3WV8kecIIiVsk8jkfyMfOHjpRs9l+3uG9iERw8WVPwBXYH17KnbSQevi/KjbA10imRweRuUuPPe6WZ4/R1BnsBv5afTndshet/XHQccC2HwtVPo9E7wJKK8oG+jt4qu594uZkLsx7njxShucicqUeG6lhddaqMFFvse9EvZu6puGz6thfi9Qy4Vbm4LnvKe4xjo4rGZOLwBlePdGuGpD5rfn5cONfMt/FwvVRx8TNQMjiisFGWH3dF5KSiHCcEVc05ykAQcyqLtFH9OrfWElkbxyWjpa7JOAVdNj8j7uhV0HIy8VHkDKg/dR3zTx2MLF1WFF4iEmGrXac66/G6Buc1dgOG0YDL+fUvVx8BE9T+soC9NNh7/eSH8RlmnvUS18EVe8jmEv6S0iZ8XLnFv+X0nbfxbmP0VcqaT5DtE4jxgRncPDFqlFgSMpVIwQKsrFKtoqzwZRFkHhsY/0nSYwcEDwZEItOXk8oKKV+mGmQS/3eZLovv8fC64QsQ3eyXeVlF2LpjHKc7EsdiXavkVXXUq+DNGJFlYr6gcF/Sg+5Wd75fk3xlPAfYXLiWIbbD1hZqtQZys6J7DCeui0+S5Ie+AEPvlgHFOcxPUWi7cIj2NRLY5fHoGCin8QYEzO+SN5eEnjZFXmkxbuu39IsF67CT+jTp/KU2oWTdQ07FxFyS435aEie48n+vis91m72b6GGA/VvONJ5Fw1sbwCBAYnrK2P/s5ukAcJVPYQpxWnZOfTJ7LDgL9mi06RylIOvyQ2BIGs0vY
 YtL1VlxK
 zfA7hrnI/Ek8hqIlhK01QcvfS3OYi48o7cxqYWAGdQiWulUx6kbyTHJSqPNH5FIbFU0SvsPGk78xMovK3jFMlSEqxWkDjSx2eVOl40F03eBU8M0eTdErTpSscmhxNd8kt2LJXQyOmbuQtDvv001VC17x66tNVsTwMXbGvYCffmtweqzb6CYZzMxBDmYIRbLHKe5L5nb8CLqay0FbDD5pu9om/68+OCYoiBYGGObdMdjpBQuk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 25, 2025 at 03:49:52PM -0400, Zi Yan wrote:
> On 25 Sep 2025, at 15:35, David Hildenbrand wrote:
> 
> > On 25.09.25 08:11, Qi Zheng wrote:
> >> Hi David,
> >
> > Hi :)
> >
> > [...]
> >
> >>>> +++ b/include/linux/mmzone.h
> >>>> @@ -1346,6 +1346,7 @@ struct deferred_split {
> >>>>        spinlock_t split_queue_lock;
> >>>>        struct list_head split_queue;
> >>>>        unsigned long split_queue_len;
> >>>> +    bool is_dying;
> >>>
> >>> It's a bit weird to query whether the "struct deferred_split" is dying.
> >>> Shouldn't this be a memcg property? (and in particular, not exist for
> >>
> >> There is indeed a CSS_DYING flag. But we must modify 'is_dying' under
> >> the protection of the split_queue_lock, otherwise the folio may be added
> >> back to the deferred_split of child memcg.
> >
> > Is there no way to reuse the existing mechanisms, and find a way to have the shrinker / queue locking sync against that?
> >
> > There is also the offline_css() function where we clear CSS_ONLINE. But it happens after calling ss->css_offline(css);
> 
> I see CSS_DYING will be set by kill_css() before offline_css() is called.
> Probably the code can check CSS_DYING instead.
> 
> >
> > Being able to query "is the memcg going offline" and having a way to sync against that would be probably cleanest.
> 
> So basically, something like:
> 1. at folio_split_queue_lock*() time, get folio’s memcg or
>    its parent memcg until there is no CSS_DYING set or CSS_ONLINE is set.
> 2. return the associated deferred_split_queue.
> 

Yes, css_is_dying() can be used but please note that there is a rcu
grace period between setting CSS_DYING and clearing CSS_ONLINE (i.e.
reparenting deferred split queue) and during that period the deferred
split THPs of the dying memcg will be hidden from shrinkers (which
might be fine).

