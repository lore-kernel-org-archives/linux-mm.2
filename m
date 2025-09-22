Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C44C0CAC5AC
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 23:23:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 305758E0011; Mon, 22 Sep 2025 19:23:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DC578E0001; Mon, 22 Sep 2025 19:23:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 218E88E0011; Mon, 22 Sep 2025 19:23:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1049D8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 19:23:11 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 99B931399D1
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 23:23:10 +0000 (UTC)
X-FDA: 83918464140.23.863301A
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id BAE54A0017
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 23:23:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EgOGLDog;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758583389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=syOw9Ju7maSQMJoOZeW4RQ04N8SC8w7XMJeEdKsYZk8=;
	b=ntzy1nJipLlCErRfJZx4VsqbICL45UzxbE+6BmDvK/H0RAooco0fswzgdEO7z3U1gTV1mS
	dCHNtDN/4ju1q1IlkBj6aSdvUMksDhevYYCIkbfOiYYZFZMC24eoqY8+bMQtuL+d29cwCn
	7bZhU4m3bw+5YQpT+6RVRn/BM3RrokE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758583389; a=rsa-sha256;
	cv=none;
	b=LJWuJNCdV2ANERXe77u07+3AkQcgfRlqMCgByJpFN8C7JS5AUAXLrX/wRFKRptHj1TUZgp
	/4NN5yOJmU+Mpd4nUFbtNZ1ViSe8/kKbMaLft+oVuLdibpgqGEMCkri0Mhjn/RXsZRnPpu
	57iyReyhA15k7CttDkAmEvn7NGDSQp4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EgOGLDog;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Mon, 22 Sep 2025 16:22:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758583384;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=syOw9Ju7maSQMJoOZeW4RQ04N8SC8w7XMJeEdKsYZk8=;
	b=EgOGLDogBBbcncEgiOkyC5L1FYT3AhDoDy0JRhVXAGqQ3EWGB2LAy171sGBEWgtks9KSnq
	zaD0gpqYWWkg3EohVh4C4q/myGGSBRdIMY2JrnjG0m8UO40KgkM/sZWCzjREh5bjCSSeuO
	btqG8R88PtOb53qbqw3ccmGraMa+gSo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	Peilin Ye <yepeilin@google.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf@vger.kernel.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Meta kernel team <kernel-team@meta.com>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2] memcg: skip cgroup_file_notify if spinning is not
 allowed
Message-ID: <nzr2ztya3duztwfnpcnl2azzcdg74hjbwzzs3nxax67nsu6ffq@leycq6l5d5y2>
References: <20250922220203.261714-1-shakeel.butt@linux.dev>
 <20250922160308.524be6ba4d418886095ab223@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250922160308.524be6ba4d418886095ab223@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BAE54A0017
X-Stat-Signature: s6izubgk1gd9ccx6j8pfoep1qakza9xx
X-Rspam-User: 
X-HE-Tag: 1758583386-263037
X-HE-Meta: U2FsdGVkX1+v4iCcW+rHh5xAfWKDHbEG5mVR0iayh8umOZiz77NPYl/GhR9AOUz1RdPXWoqfLEgSV3IlxHotzqrPdruqvb5k1RKLqEvDufqze42WdeTsIfNe6myeEgTN4EB4d/zcmvdLV7pM7iDSlgiqLHD2osmeW2or4uJ0ZJv9W1Uv75YhVMnkpZgk8IFaGhbWHtsMxtW/VIiiRN9i13ogEk1ecLVWyPXckBtf+3RSn672vpCHf+mhid7C6GCyokILX3B8dLZLHt2jDOJRNbzx6cd4tM+t4ZxF+PI803+Ez21as0uGWFwQ/M+5ULRwztPdoBU21571S9egSRXJosgTadrasKEsybXoIjHwEVELuZTn8ncxvIrZYgMWerI1AKG26PVlACzO24YBvCT/FZJZmWktfMAniAcTJRtVaU+LeZFstVTyHSWgEgVAPDx+D8eL6lwTqslD9lVspWMF9Nc++Vba62nvK867Gx8jvIbyqWkYx0k9gC52sPWS2g+fr2X/OEEnyDxFKtarnI3tr/gzRcFTt3xtpYMznumUL4vtFcZTaHWIma2C/Q3kvJb3Uz3h27W+0m7RknAusw/3L7MC3RHMqua8HagD6gGEk4LuZ6gPSUaVL0uCcETPYS2LMjzFzOXlV8hAITXHvxiZUK0sRspDtPxydXjzh/W6c8iIa4ko8GtrWzP3ZcGOjBfdRxZi0DgAtYPLFYrdkhv0WbiJPYN7Ns57jFGqSfS4RhgijzecT6gvjakgNBrmpoVKTGaUd1D+qWdvVP2ji+1/lTMkNfhh9NZS9E6Mu/E2VxGDVT5i8nKCE4A9QzMZQ9CgdbiNf58H72bJoNZUp4AFS6Sd0qWCZFpyvtseXgvuQMb8zbk5w6Q1lrqyIf6vVAOsO7D4RiDz46LR0T5KOwwZmGV8XF1e/zEGvF57NxNfJXc5KfxugBYSylZAK6t0Fz+Jc3eGkACRCA6rL3qEsXC
 EwJXNjjD
 zoJN3knP4ZEavtlkovFA9LixuLxHZ54eylX9fZUlbkICMT5kz+zFiWScHhGi9AmcDBm+LbkdKRYOybJOLMyV13lWnrFkvJNCc2IA+Y90bHqDUL4Vi7Vmy+xkcZ2yvfj/akeU3v9Y8s+tRmAurqAW+AZHPy47vTj9GfYVRdlkQYnP9CC5FeLwd6/2HTl2WHuSW9/rT/AkZvumlhhWClblF0Jj+0J07f2j17tLpehtfzqeygUsejtCmYksq5SNQCP7n5pIj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 22, 2025 at 04:03:08PM -0700, Andrew Morton wrote:
> On Mon, 22 Sep 2025 15:02:03 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:
> 
> > Generally memcg charging is allowed from all the contexts including NMI
> > where even spinning on spinlock can cause locking issues. However one
> > call chain was missed during the addition of memcg charging from any
> > context support. That is try_charge_memcg() -> memcg_memory_event() ->
> > cgroup_file_notify().
> > 
> > The possible function call tree under cgroup_file_notify() can acquire
> > many different spin locks in spinning mode. Some of them are
> > cgroup_file_kn_lock, kernfs_notify_lock, pool_workqeue's lock. So, let's
> > just skip cgroup_file_notify() from memcg charging if the context does
> > not allow spinning.
> > 
> > Alternative approach was also explored where instead of skipping
> > cgroup_file_notify(), we defer the memcg event processing to irq_work
> > [1]. However it adds complexity and it was decided to keep things simple
> > until we need more memcg events with !allow_spinning requirement.
> 
> What are the downsides here?  Inaccurate charging obviously, but how
> might this affect users?

Charging will still be accurate. The only thing we will miss is the
possible notifications to the userspace for memory.events[.local] files.

> 
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2307,12 +2307,13 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
> >  	bool drained = false;
> >  	bool raised_max_event = false;
> >  	unsigned long pflags;
> > +	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
> >  
> 
> Does this affect only the problematic call chain which you have
> identified, or might other callers be undesirably affected?

It will only affect the call chain which can not spin due to possibly
NMI context and at the moment only bpf programs can cause that.

