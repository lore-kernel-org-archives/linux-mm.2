Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8925ECD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 11:41:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 814EA6B0088; Wed,  3 Jun 2026 07:41:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EC786B008A; Wed,  3 Jun 2026 07:41:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 702366B008C; Wed,  3 Jun 2026 07:41:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5FE926B0088
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 07:41:41 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E26774034F
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:41:40 +0000 (UTC)
X-FDA: 84838411560.27.547FD5C
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf19.hostedemail.com (Postfix) with ESMTP id AA6571A0004
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:41:38 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=sUFDdO6s;
	spf=pass (imf19.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.174 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780486899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QunYua40k0szh1VG1CUNujPHNQ9BbnVbc6N14Ce3Fc0=;
	b=FajU0SN66vOI4UF2fXEP7gWjbL3DrIj3UsrIbYbgJs5pPyXvxY6/9ssURuN98Uih1ciHiu
	5ZAgeY7E4RihijTqtHCTPy1IlEwRaOt1lDG8LYV/7S7a2NghGOeE2fRMIJYN8hkQnarFm8
	MWD/7u3q9b1wUpxo22rZTHfyrAXavK8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=sUFDdO6s;
	spf=pass (imf19.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.174 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780486899;
	b=0lxUiR6aK7EqvIltrofc3hx2QjpJUEudXv3N1pp3t9squNdGIuusrbRzOL/k2APYa4DI1M
	EeNAyGIMJFPka+YK3y4VHMLPPn5eAms0ZOeAxyCps6GWfDKR1cwSj0GlZo0qTkpm0poMJ7
	Vm8tP3nR1l+78om/rMSx/4mMMyANmVI=
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-91587626ae1so142882185a.3
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 04:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1780486898; x=1781091698; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QunYua40k0szh1VG1CUNujPHNQ9BbnVbc6N14Ce3Fc0=;
        b=sUFDdO6sI+m00qo5PQT6UUBIj+najZTYrE1jpNyYIXG8RFcK10hN4+rqAlKZXRHG3P
         /IIryjL31r7g1PEIeGVKBc53LOFnop7mhSAU79qXquzGz2dgwwm8uNjuGmkmnweIZKi+
         OLe19Wbo8QKgEzWFJHWzusPX0DzZLHb0kYhavUUEGA7xoBbWiM98cV01qRxdHuQ8guJZ
         eGVmn+cZkpHlDC1Se1xZDdoKDl2GVhZdEAIJhuBcJ7A0YPk/g6d/pl+5vsy6yIuRQe0y
         1JmuF1SaMmNobsZhGoghPU9h4Li0UahqiXubgEC6hFhW2n1HVYzicIr/pPwRaQctLIhM
         9DGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780486898; x=1781091698;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QunYua40k0szh1VG1CUNujPHNQ9BbnVbc6N14Ce3Fc0=;
        b=gFrVOoM9rbTasvxU15CJU1TX0wEshseTFasQT0KR101vVBLAXj0uTD+1G6y9KsAmpf
         rFcnWvyeMnWqpy35dr1cLc5r8fIj2OwMp9+EiM9Q92Mcp1FSrmBElznh0ssom7Ggdur7
         nLJNGOXneJv09TCXag25x3bNKgLJqiTPNTuyLBkbpumbVnZw9vkZGWMzE0QHvrum+uB7
         UdC71Tqb9OPJIrrpH9ZxOU2wZd5edPsiUjp9NGUy4nk5VIRXVmMM6nJ166quO41Be1VC
         josYJLftQzwVL6iBL8NlZ7HNFVgHE3+BSnvpNbq3huh0tvLyRZi7/gZrYXrjzhBFd7Ag
         ndRA==
X-Forwarded-Encrypted: i=1; AFNElJ+O3Alc/YVF6n1s43XfuJcpHk8XrwhMGprhuuzL6fW9u9r2WA+Iahl5FquSSmfmW1lo/DxOiqAzYw==@kvack.org
X-Gm-Message-State: AOJu0YyIj+zgsu4Fatr0ZZ83fFfX8/50lLFViXTBVORLeOAO6iRTqi/Z
	4pCDPA39B0zLCUtPM/JtU/syFTZWVq7YRt27zfw86ZlqHrqHaZbiO47fdk1mw71UDxE=
X-Gm-Gg: Acq92OG3nclTY5fRODFWXKGfv4F8gdjY/b0IDaitizNdERndZIAstoyuyqI6tDNXv27
	7FtB1logYTViCK6q7unWvjbWM1AGb656hzSyfv6lw3Oak723bmdbLhY7lPxZLPHDBykjHCkT7vG
	mTIV3xb9QzJkpmc78VMQQkMQCaeadhLFizGVna2WcryzzRompeRcJuuevFvhJqgXBu4ES50jhUG
	LIhpG05HgM5kTsvU2Fz/HfTMoIc14BgRmro0QKNT0+XqmFBMAkQXfqar0xVOnIOx+GYDW3utAcz
	swxYnt8QD7z2qtott25i3qSsI5QwxtcWL01jYPFqdXuPDBhd9JGx+t0HTadv3OO00ISDveGjmrV
	+3vzaRYw7NrUdQlAjjafgLwd0QhnHu9lrNyWGjlzeusg6cFtyMiUtX9OZW4jMgKp+GWCgjxGpIk
	daHZAfEqpVQZMH8z5fCoTt3QKahWPuZmYY
X-Received: by 2002:a05:620a:a0d2:20b0:915:79c8:ec9c with SMTP id af79cd13be357-9158a798ff1mr350904085a.35.1780486897606;
        Wed, 03 Jun 2026 04:41:37 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd263003sm17426686d6.42.2026.06.03.04.41.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2026 04:41:36 -0700 (PDT)
Date: Wed, 3 Jun 2026 07:41:32 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	shakeel.butt@linux.dev, mhocko@kernel.org, david@fromorbit.com,
	roman.gushchin@linux.dev, muchun.song@linux.dev, qi.zheng@linux.dev,
	yosry.ahmed@linux.dev, ziy@nvidia.com, liam@infradead.org,
	usama.arif@linux.dev, kas@kernel.org, vbabka@kernel.org,
	ryncsn@gmail.com, zaslonko@linux.ibm.com, gor@linux.ibm.com,
	baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com,
	npache@redhat.com, ryan.roberts@arm.com, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/9] mm: switch THP shrinker to list_lru
Message-ID: <aiAS7GxsffqXWILD@cmpxchg.org>
References: <ah9PGv12mqai84ES@cmpxchg.org>
 <20260603044426.54863-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260603044426.54863-1-lance.yang@linux.dev>
X-Rspamd-Queue-Id: AA6571A0004
X-Stat-Signature: 6qtez56zmr3i55stha7z1wrk6m4kdzwg
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780486898-396579
X-HE-Meta: U2FsdGVkX19vQxcN6LXioC4Qdv8VToLbHFjj7uiPHCxozvreS1EgWTzZA73PO4JRkMnZ7R3Qlv7XzC07dYOzRGZO3MlMriZcdwBpW5kLEzk0b15ZusH1Zbj6u3i300/aTrPAB7P6yJXYTZ5PpuXBqgA6URE2RRZDBlRFWI+RCYd9pV/PNNiSNb0Eh1fBEo+eFZwmCKhYDuORnf7vID6LRWQ91rHRInAuSEqnS+WCiNAZh+bdrCbWJphwNOZcKKHjBkXStOAynt9n2KZJKkVQMFG2gKqtsz6lsVZKTXEhJZ2lRVD/da5JeJMQbo0Sy/Wd116pu0+oDB7vhNFn+rj4ZcVerusdZS6onKjJJjy3MqCvT4vgrlyON2B60c9M7iS6QlX03kRBCiU6iEjrXPKD/YJTwq+cKEqwJ9m+0214jxXbfVRWujJJ4h/Clpssn9AzJhpXjhIVEu0NBHESkB+dhDYpknTnZNXrUGkbAeG58pcRFT/efXuWF9TpabjqzKSkwKnnVEWn9xjRrZplNd8LRdhuMjSgroaxAFF1Zkkb2UNnq0bUlKUi+zs3C7qjNHeAqM201qokouBQdLWFdP8Xbx2wetwsNwq53wvIch/v/0XyVe681G+72GtuBmTcLsk9qGKFJSjpipFl9vQZkWb/w0na9oaF1gsOlQIvHgAw7Ay+4yl8Kw6pfdlm4Sj/+tb25YNYmBYCt6ADl08lWTVgMbLdDnVT8hEgJ5zyQGrNPjOPjKU4zo3BfT5DnPUE8KFIec/EYW/Sf26KOkBCggkkcHkIWF4cC/VRMGS5lImaRCoGUq8bWEpaeW//zcE+zYkCypiJUBzpuvmKERXqOAye4kRFEbJPNjeMwS9IE3HLWhRaoPElDxh44zufw5bZASfuplFmYcN+/LXQq0pDq9qGEZ7Xb65+f/GCi5Ubx7Cdcb08koevh9fK6CgKQbNjizoLFhOTYVSYLxAQscB6yqH
 XNL8GOz5
 OQCjnbWugELi3OjzG5ljFRu2F/QVOzNejXGiHiVrjSvfETWLHvbWmxtI4P8/uB++s4J7VXWSvqPCWz2ndz0Cjcik7KRBwiOAcV+Uj/4d97xBfplVK1JZeCIx1D14WVyHdV/UIKKLPZGjLNvVYVjGyn5JoyM9DLAl526ah5btVPrNOz3YON3WAw5E8x9NnKM4MptDqqU452JIgSCSeIZZBBXWzWXL12kBQSdzknX7mYtcJ2CkFOIG13St4zt5AxB/Hbt3GAfNoAah3mJ4emsa7eeS/B/eCenwf4VwvZ8vWCPwt9nPvyStbSxR7IUWShzJd7J2cO8+tuvyrH/urkwwob4uskDvWL1junesMENY7Gd/NBJ6uCxglaiZ9eB3CSkt2mKm1uB19uxjGN1mMXrpW2ap6u009DHaTkGou22QdeqlPs8PbaSSu7LCU79PNyK6+elFpnOzGEX/vZtQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 03, 2026 at 12:44:26PM +0800, Lance Yang wrote:
> 
> On Tue, Jun 02, 2026 at 05:46:02PM -0400, Johannes Weiner wrote:
> >On Mon, Jun 01, 2026 at 04:36:52PM +0800, Lance Yang wrote:
> >> As the changelog above says, the old queue is per-memcg only, rather
> >> than per-memcg-per-node. So reclaim on one node can still walk the whole
> >> memcg queue and split underused THPs from other nodes in the same memcg.
> >> 
> >> But I think the new one can lose reclaim in the cgroup.memory=nokmem
> >> case ...
> >> 
> >> With nokmem, the deferred shrinker can still run from memcg reclaim,
> >> because it is SHRINKER_NONSLAB. But the list_lru is no longer per-memcg:
> >> 
> >> __list_lru_init() clears memcg_aware,
> >> 
> >> 	if (mem_cgroup_kmem_disabled())
> >> 		memcg_aware = false;
> >> 
> >> so list_lru_from_memcg_idx() falls back to the shared node list:
> >> 
> >> static inline struct list_lru_one *
> >> list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
> >> {
> >> 	if (list_lru_memcg_aware(lru) && idx >= 0) {
> >> [...]
> >> 	}
> >> 	return &lru->node[nid].lru;
> >> }
> >> 
> >> That makes the shrinker bit unreliable. __list_lru_add() still sets the
> >> bit on the memcg passed in, but only when the list goes from empty to
> >> non-empty:
> >> 
> >> bool __list_lru_add(struct list_lru *lru, struct list_lru_one *l,
> >> 		    struct list_head *item, int nid,
> >> 		    struct mem_cgroup *memcg)
> >> {
> >> 	if (list_empty(item)) {
> >> [...]
> >> 		if (!l->nr_items++)
> >> 			set_shrinker_bit(memcg, nid, lru_shrinker_id(lru));
> >> [...]
> >> 		return true;
> >> 	}
> >> 	return false;
> >> }
> >> 
> >> If memcg A adds the first folio, A gets the bit. If memcg B later adds a
> >> folio to the same shared list, B does not get a bit, because the list
> >> was already non-empty.
> >> 
> >> So in the A-first/B-later case, reclaim from B may not call the deferred
> >> shrinker at all. The shared list is scanned from memcg reclaim only if
> >> reclaim runs from the memcg that has the bit, such as A here, or from
> >> global reclaim :)
> >> 
> >> Anyway, only after the shared list is emptied does the next memcg to add
> >> a folio get to be the one with the bit, IIUC :)
> >
> >Sorry for the delay, this took me a bit to think about. The shrinker
> >code is a mess.
> >
> >I read it the same way you do. And this is true for all list_lru users
> >when nokmem is set: we just set random nonsense shrinker bits.
> >
> >HOWEVER, the generic shrinker code fixes that up by IGNORING random
> >shrinker bits like this when !memcg_kmem_online(). And shrinking
> >correctly happens only against the shared root queue when the reclaim
> >iterator walks root_mem_cgroup.
> >
> >HOWEVER, the THP shrinker explicitly sets SHRINKER_NONSLAB, which in
> >turn overrides the previous override. So yes there is a weirdness: we
> >get the root cgroup invocation against the shared queue, and then one
> >more time triggered by that random memcg bit.
> >
> >The most direct fix is to just drop SHRINKER_NONSLAB. It declares
> >independence from kmem, which is no longer true.
> >
> >Cleaning up the shrinker code is left for another day.
> 
> Thanks for working on this!
> 
> Wondering if this fix trades one problem for another, though ...
> 
> Before this series, the deferred split shrinker had a real per-memcg
> queue. Even with cgroup.memory=nokmem, memcg reclaim could still scan
> that memcg's own deferred_split_queue:
> 
> memcg reclaim -> deferred split shrinker -> sc->memcg->deferred_split_queue
> 
> With the fix, nokmem + w/o SHRINKER_NONSLAB falls back to a
> non-memcg-aware shrinker:
> 
> memcg reclaim -> skip deferred split shrinker
> 
> root/global reclaim -> deferred split shrinker -> shared list_lru
> 
> Is that expected? There woud be no memcg-driven deferred split reclaim
> under nokmem, IIUC ...

Yes, this is all correct. list_lru is still inherently tied to the
kmem component of memcg (memcg_kmem_id()).

So without kmem, no isolation. But without kmem, no isolation *for a
lot of stuff*. It's a legacy knob when slab accounting was new and
expensive. But so many things depend on it now, disabling it just
punches a nassive hole into memcg functionality and isolation
coverage. It's not a sanctioned production use flag.

This change is negligible from a memcg semantics POV.

> Not sure what the right fix is, as I am not a memcg expert ...

