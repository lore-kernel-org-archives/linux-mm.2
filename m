Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EBF0CA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 17:39:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83F9D8E000C; Mon,  8 Sep 2025 13:39:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 816B18E0001; Mon,  8 Sep 2025 13:39:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 753A78E000C; Mon,  8 Sep 2025 13:39:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 639A78E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 13:39:57 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1D60EB73DB
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 17:39:57 +0000 (UTC)
X-FDA: 83866796034.04.E9D5DCD
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4468D14000A
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 17:39:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZLOjI2W1;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757353195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UqG1+1cfzn6SRqfp+y4ls9je7NnsECHyQJszT61fGcM=;
	b=P+RJtst5NRg5perOHcZ2u/8AO7/btHd6HVAbW8jGWnuakEB/SOZTU4OV9J9oy3s9Nb4jUo
	Ww8rOPdgHK5nVaXshchOKMSzDm7LtCeyBbE0OX1jey36CRLhtHg5eAZm3nY2+1eRZoCa+7
	XyDTD9HqkPKrqEvQ1uB7YrCE/btaSN4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757353195; a=rsa-sha256;
	cv=none;
	b=5/T2Ap5SHAtz8XQ3m0YC0VfGpTmyz/9M39IuBj4g0txlFfAy3YOSPTKzBxjoEyoBM5Xzik
	gmFtZx761SLhDS+Qb6LTS/+6h6U2Pk5Qkun38sKgGFQhKTEAnDmn3gZieT7645yohZyHjT
	zzG4vzD2Wtzl3iRJ8M7o3y0gF/8UIDM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZLOjI2W1;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Mon, 8 Sep 2025 10:39:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757353193;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UqG1+1cfzn6SRqfp+y4ls9je7NnsECHyQJszT61fGcM=;
	b=ZLOjI2W1TsnO+n+7Msg21yOwuialHG5Vd0MmH0abjFtTCfZ3QMyzLoEnQTRKlrQwkqV+kk
	C6APWTp9lt1ST7AUs4vBXG67D5ERA6iCOLd/ctnisLUuvCqViq2DHM6M/ihnFFV/MFmvtl
	6SY8zJVbkuDu4au4nxL0QF6VsJbbklM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	Peilin Ye <yepeilin@google.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf@vger.kernel.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH] memcg: skip cgroup_file_notify if spinning is not allowed
Message-ID: <lhmdi6npaxqeuaumjhmq24ckpul7ufopwzxjbsezhepguqkxag@wolz4r2fazu2>
References: <20250905201606.66198-1-shakeel.butt@linux.dev>
 <aL6htMt-jHAaCGLv@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aL6htMt-jHAaCGLv@tiehlicka>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4468D14000A
X-Stat-Signature: yw3rccjk4985b7dc1cusp5jd15qwe33f
X-Rspam-User: 
X-HE-Tag: 1757353195-884823
X-HE-Meta: U2FsdGVkX18LshckiAj1peCE8T5IeftJpXpjDWYbF9++KBVdQRhBGD5HeaHIxAsKTPdJ4omVVQi0IlamLxM5xTCLwa4pp51+u7yOrp3jPY5i0t53SVkLw2ewjjVGBL5uP0i5DFLcOGQMiknVHlP4Zj9icsJlX7EWvDyjN3Wgs3aOpzUhiVPUverydZ3qy8dMeaoTNHwliqsRCOzI1hPj1qy4v4nwQBWByBwtymKH444QmJ+O26v6JeMitmR8+6MgNBqbYJLWMflcUFkcFgnPtihsMPZmOViXz5slQyPp/PLMxczZvjIVkMYBFUCD0hX3MLgY/dtnsGPpqS7XuZaCOrYLAUc/lEjuKL4NTwJ0ulg7X4ZvzbOzuoIWoxpdmfS7tWkgCqFNyRS+pBJxelKNVAOhFEybzgvNoa7BKVMmny7Z0Jzd3ZCkfBnoGy61o+7D69a//gUrLqLisynt0a7tO5FPz1xvRa2XYUQrf+2GjaW/zQ0XeokpcoQTiVZ2GPP78523ctJtAKHQ2gyFjd3cnW1Rf8mRx0CPsUxhAK5HmaDqs2LmJz3MrOqvX9N0TD47nOzSOQE/z4cFHm5E8PDCwrsYUQ+2j0QA7ODPPv9DRIIpRK0z3J8lweDYbMNlq+EaFytOebwqKzm79Iwz2vh+3ir48muUuI2eEdXx0qSlFZMWdpqJCAp2VCcmdpOEBlqTAkqPcpm83l/TcCU6ecTmIucHCy96+35lPYhNm5QGzjw9o1lVvBPo7AusUP29hit5drf6OzkOg2xutPzPK6fm/Am0Hh8lMmapBo9OPajwzCVy7K+d36jrc9ch4VL2d7xh7tZo3/b4SSuMzw8nfVynLwEtlbz5p8HzAmNprzuKY2oM7m/ERQfoMQLr7yK6sGiaD2VIo53zR30YQG1fsu3ULqbEgvlbyC0+1M5phmqr1VhqryyLiBYCOJ3yBmJo8OUnHu0hBMWMFUvp5ZT/OPz
 HsYfEBef
 fdcUXuRQh/Ih3RTbYdLckAI/nnoHGhhrS8Lfe33C91cKpJP0YJh+Hc+aw8JJE+hKt0r1qAnHQup+Hq+1ZYg8xijIFyXiJ02S2aivZbAXn1Au6LsJnQyhdGHRLd6jqVHNYKI0hzoDjAtZdhehel/3n2Ns+bxOWh1QiQTIwStQxB6b0emXzCtYJY5IfpPB3RLyWAPd0ClUUxQJZiFG2wyWlVftRBMKQbSpuovyOZnPGhy5MrgN/soKXkW8OaX48t2XOhxekm63roEaM5651asOZkQf3YlNgKfw3QBg97gDSHY04AruA+1A3nfqEiij77TUKy+i/yoBDaaozyUn0WkPyFm7Uv/u88sBrmCrc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 08, 2025 at 11:28:20AM +0200, Michal Hocko wrote:
> On Fri 05-09-25 13:16:06, Shakeel Butt wrote:
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
> > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> 
> Acked-by: Michal Hocko <mhocko@suse.com>

Thanks.

> 
> > ---
> >  include/linux/memcontrol.h | 23 ++++++++++++++++-------
> >  mm/memcontrol.c            |  7 ++++---
> >  2 files changed, 20 insertions(+), 10 deletions(-)
> > 
> > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > index 9dc5b52672a6..054fa34c936a 100644
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -993,22 +993,25 @@ static inline void count_memcg_event_mm(struct mm_struct *mm,
> >  	count_memcg_events_mm(mm, idx, 1);
> >  }
> >  
> > -static inline void memcg_memory_event(struct mem_cgroup *memcg,
> > -				      enum memcg_memory_event event)
> > +static inline void __memcg_memory_event(struct mem_cgroup *memcg,
> > +					enum memcg_memory_event event,
> > +					bool allow_spinning)
> >  {
> >  	bool swap_event = event == MEMCG_SWAP_HIGH || event == MEMCG_SWAP_MAX ||
> >  			  event == MEMCG_SWAP_FAIL;
> >  
> >  	atomic_long_inc(&memcg->memory_events_local[event]);
> 
> Doesn't this involve locking on 32b? I guess we do not care all that
> much but we might want to bail out early on those arches for
> !allow_spinning
> 

I am prototyping irq_work based approach and if that looks good then we
might not need to worry about 32b at all.

