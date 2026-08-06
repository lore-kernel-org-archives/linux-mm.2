Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9246FC56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 16:38:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 896226B009B; Thu,  6 Aug 2026 12:38:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8470D6B009E; Thu,  6 Aug 2026 12:38:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7612A6B009F; Thu,  6 Aug 2026 12:38:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 44BBB6B009B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 12:38:27 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7C964120160
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:38:26 +0000 (UTC)
X-FDA: 85071402612.29.F3799D0
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf27.hostedemail.com (Postfix) with ESMTP id A53DF40008
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:38:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hkvBpT7D;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786034304;
	b=5ieB3gwbxPXeRokvL9dsZ1/nOnMwuObCnaSdCIXgRu6IKfJXaXq+uIOJ6TIIeaZ/Cai+3J
	U+RIGifBgSov8UC2kkJNJkh73qF1p7gzTGV4mtUC7L8k0Kblnvui+eD42i+ChMzyy8d65E
	3SmP7FAoyKow9I8ow2g7Nr2UCmttFXs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hkvBpT7D;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786034304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ER4hDuyk/AXCOt6BhnNPQBwbY3PdYFFZY89XoDcPBsE=;
	b=vFpvakPb31vza97JM13zpgRv1+3CLtDoVTc7vyvw9jjCc1/g3++PgyY9TBIiI1zRC9JxEL
	y+oqY6CGOZcxOa6Os/zRa4U+/FwxHmizsZyBFa2OcdC8w3VzTSxGqq674vLA2cuMlABo3u
	bOfxBRGkKEzC/lIHnJOZBdr7yfG5Z78=
Date: Thu, 6 Aug 2026 09:37:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786034299;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ER4hDuyk/AXCOt6BhnNPQBwbY3PdYFFZY89XoDcPBsE=;
	b=hkvBpT7DRwR5rOmIF5NXXOYMXQWhVRFIw2Ix1e9jw2tCcuiotXDs6/JljnVjb5Sy8TuYBn
	v1DzI2/aLXzx91MTnb65qkoO3DuWYys3VLx9AGtNe72/4q51a/s9SnGGgWPdn3Le8ilDUt
	ck8dR4+GXlYxdaJKD6P0ifR9Ex7Pfjg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Michal Hocko <mhocko@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Karl Erik Hofseth <karl.e.hofseth@opoint.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH] memcg: keep folio's objcg same as its node
Message-ID: <anS1HHyoIAPfyk7z@linux.dev>
References: <20260806061830.3294679-1-shakeel.butt@linux.dev>
 <anSsqaD3QAlvQ8cd@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anSsqaD3QAlvQ8cd@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: A53DF40008
X-Stat-Signature: 8x6nngemw1ipi6nahy56jjgqg3k8ssbw
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786034301-544816
X-HE-Meta: U2FsdGVkX19fefYEy143rBoB2CzhVfqZFWwAbfR8dZRBY8C3nABQQwDibSw+ClvqNLpMihnIq8gYRqWbtUocvbTbgCjxII+ZaxJGhREctMn/qP4R1t8B22oz0ATPyXIdMsAWwNTXRNiBBluH5LppG3nMkFOWvhAA+iq2lxFFKV/hc+1U/sWaA/DjWUyPQO+Og93wAoq+vdWMJi+qJABSy+nC1wTVFPY5BSvlBtGIizUgcgn7CAt4nP13cAJbJpPk16MvuM4CWbRCU3Ltz24aoj2dIPU/hP9ABbJsgukw3MKZb34zpwyPA4hNApmD+y6KYh2rQXy2qUnI4s8s1LwMxO1t3jU741RTzKgAjV2ZiTzrkU6CZPxNvjXyk2bZYonUTTV8WeDEQrfdbAbYvwIKD/VER0WSs3nW2pMAa4LdjHIV6Q9gg600c0prVskq5EjA7DXpQarEKJmXiG6oPYaIRAWmQfeyWp7lNc0FOnXgQ3zkBNd3QBQIXUaZFpjZCW7UAk7AsmtH2m27YFof88CG8a7jh2xXuYpNs/PLWBN8/RaC6fngeZrx1uXqGVwfKyiaYT+oaNxSd82mpZqkT9EIJKjNIFlwxc12ObWtv50jHCGDmuwQbmeS2w7PtylalgKFkyh2ogryKLmlooNiBDklg9AjkZKSSu9V9DNVeXidEhD0j+P3khIDMbf89JJBgM42idAZLclVp8cNEO35gEdxoowZktbsNrizmm8n0b3kWGNdAMCDeCKolEcuZBgKBOCY+6xEcHrqIChEO249elq6WrtHuUzFgzMOEHHVvIPrEcxhc+TAikpYtwmUZOrdDirrYGuQwAdAn06Uk4isBRlW2+7FGw1+hLKoLG5pi4Qli/9o7MtxD7Lo3CQggunhNhZ+Hd+5VT1bSNQ344E5wdJdc14JkOjPFzsIUKa2XuAeEdgAtHZMGDFt2/2OC1C5aJDp3fIh9JcpHAqXunW9LAi
 148APylZ
 f+s1U+PsKCLxF6HNlvNnPQ6ezWvitPVQXtxyKY+50oRtpf5wzoMqg6P5mhMouKC96JMwmbQhd/Q5fg50tPV7h9y4VzSADWKCewto0inwEmxRQF/FC3/Y7NZu4PdCvNVnEK0iRONCi8EVQDKMEbZfv+1tj8QGfiBVgJM2LlRJ9X9fHqQ23qnxgIw6ck5CP2BS9XdWwT4UUHjfA7I38hZ36NvhAEupjGR9hmMVNGGltQQ13LEYgyrw/seC+h9qMcorf3DILm69Pn8STkg+0Jm5R7A6t+uUfEkwDpIfcnKiVM/gcM9c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 11:47:53AM -0400, Johannes Weiner wrote:
> On Wed, Aug 05, 2026 at 11:18:30PM -0700, Shakeel Butt wrote:
> > memcg_reparent_objcgs() has an inherent assumption that a folio's objcg
> > is the objcg of the folio's node.  Folio migration across nodes breaks
> > that assumption: the new folio simply inherits the old folio's objcg
> > while living on a different node.
> > 
> > Once the assumption is broken, the reparenting of the folio's objcg and
> > the reparenting of the folio's LRU list are no longer atomic.
> > memcg_reparent_objcgs() handles one node per iteration and drops all the
> > locks in between, so the objcg gets reparented in the iteration for the
> > objcg's node while the LRU list gets spliced in the iteration for the
> > folio's node.  Any LRU operation on that folio in between resolves its
> > lruvec through the objcg, and thus takes the lru_lock of the wrong
> > memcg, not the lru_lock of the list the folio is actually on.
> > 
> > Fix this by selecting the objcg by folio_nid() at charge time, and by
> > re-deriving it for the destination node in mem_cgroup_migrate() and
> > mem_cgroup_replace_folio().
> 
> Nice sleuthing.

Thanks and it was actually due to very good reproducer provided by Karl.

> 
> > Reported-by: Karl Erik Hofseth <karl.e.hofseth@opoint.com>
> > Closes: https://lore.kernel.org/all/anMmd1ADrDVwMO6v@work/
> > Fixes: f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of dying memory cgroup for LRU folios")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> > ---
> >  mm/memcontrol.c | 33 +++++++++++++++++++++++++--------
> >  1 file changed, 25 insertions(+), 8 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 3057396dda53..2e98788dc8bd 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2966,10 +2966,9 @@ struct mem_cgroup *mem_cgroup_from_virt(void *p)
> >  	return folio_memcg_check(virt_to_folio(p));
> >  }
> >  
> > -static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
> > +static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg,
> > +						      int nid)
> >  {
> > -	int nid = numa_node_id();
> > -
> >  	for (; memcg; memcg = parent_mem_cgroup(memcg)) {
> >  		struct obj_cgroup *objcg = rcu_dereference(memcg->nodeinfo[nid]->objcg);
> >  
> > @@ -2980,12 +2979,13 @@ static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
> >  	return NULL;
> >  }
> >  
> > -static inline struct obj_cgroup *get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
> > +static inline struct obj_cgroup *get_obj_cgroup_from_memcg(struct mem_cgroup *memcg,
> > +							   int nid)
> >  {
> >  	struct obj_cgroup *objcg;
> >  
> >  	rcu_read_lock();
> > -	objcg = __get_obj_cgroup_from_memcg(memcg);
> > +	objcg = __get_obj_cgroup_from_memcg(memcg, nid);
> >  	rcu_read_unlock();
> >  
> >  	return objcg;
> > @@ -3029,7 +3029,7 @@ static struct obj_cgroup *current_objcg_update(void)
> >  
> >  		rcu_read_lock();
> >  		memcg = mem_cgroup_from_task(current);
> > -		objcg = __get_obj_cgroup_from_memcg(memcg);
> > +		objcg = __get_obj_cgroup_from_memcg(memcg, numa_node_id());
> >  		rcu_read_unlock();
> >  
> >  		/*
> > @@ -5197,7 +5197,7 @@ static int charge_memcg(struct folio *folio, struct mem_cgroup *memcg,
> >  	int ret = 0;
> >  	struct obj_cgroup *objcg;
> >  
> > -	objcg = get_obj_cgroup_from_memcg(memcg);
> > +	objcg = get_obj_cgroup_from_memcg(memcg, folio_nid(folio));
> >  	/* Do not account at the root objcg level. */
> >  	if (!obj_cgroup_is_root(objcg))
> >  		ret = try_charge_memcg(memcg, gfp, folio_nr_pages(folio));
> > @@ -5431,6 +5431,7 @@ void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
> >  
> >  	rcu_read_lock();
> >  	memcg = obj_cgroup_memcg(objcg);
> > +
> >  	/* Force-charge the new page. The old one will be freed soon */
> >  	if (!obj_cgroup_is_root(objcg)) {
> >  		page_counter_charge(&memcg->memory, nr_pages);
> > @@ -5438,7 +5439,12 @@ void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
> >  			page_counter_charge(&memcg->memsw, nr_pages);
> >  	}
> >  
> > -	obj_cgroup_get(objcg);
> > +	/* If replacing folio of different node, get objcg of that node. */
> > +	if (folio_nid(old) != folio_nid(new))
> > +		objcg = __get_obj_cgroup_from_memcg(memcg, folio_nid(new));
> > +	else
> > +		obj_cgroup_get(objcg);
> > +
> >  	commit_charge(new, objcg);
> >  	memcg1_commit_charge(new, memcg);
> >  	rcu_read_unlock();
> > @@ -5478,6 +5484,17 @@ void mem_cgroup_migrate(struct folio *old, struct folio *new)
> >  	if (!objcg)
> >  		return;
> >  
> > +	/* If migrating to different node, get objcg of that node. */
> > +	if (folio_nid(old) != folio_nid(new)) {
> > +		struct obj_cgroup *old_objcg = objcg;
> > +
> > +		rcu_read_lock();
> > +		objcg = __get_obj_cgroup_from_memcg(obj_cgroup_memcg(old_objcg),
> > +						    folio_nid(new));
> > +		rcu_read_unlock();
> > +		obj_cgroup_put(old_objcg);
> > +	}
> > +
> >  	/* Transfer the charge and the objcg ref */
> >  	commit_charge(new, objcg);
> 
> Just noticed Sashiko pointed this out too, but you put old_objcg while
> old->memcg_data still references it. I don't see how that could lead
> to a UAF but it's fragile.

Yeah it is complaining about folio_unqueue_deferred_split(old) accessing
old->memcg_data internally. I will do the put at the end.

> 
> Man, this is hairy. I missed the implications when I suggested to make
> the objcg per node for simplifcation elsewhere. Now locality actually
> matters -_-

Yeah it has become complicated. The other concern Sashiko raised is the case
where the destination node's objcg has reached/reparented to root and the source
node's objcg is still not root. Since we skip root page counters for LRU pages,
this can unbalance them. It's one more check to add.

> 
> A comment describing the race with reparenting would be very helpful.

Will do.

