Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EFF0C56205
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 18:15:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5D3B6B008A; Thu,  6 Aug 2026 14:15:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D34986B0092; Thu,  6 Aug 2026 14:15:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C24846B0093; Thu,  6 Aug 2026 14:15:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 978D86B008A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:15:34 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2276B80110
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 18:15:34 +0000 (UTC)
X-FDA: 85071647388.10.622965C
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf14.hostedemail.com (Postfix) with ESMTP id C89DD100016
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 18:15:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=pBrQ5pyg;
	spf=pass (imf14.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.179 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786040132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k5UoSi/kRUvJ5D9A+qAnQzZgG/DBYzn7/rZxUaSi0lw=;
	b=Iymmu02ZbO7T3Kdmbfft6/5/TgQB8AAAWvVSM+nVuzcvunrw2p4bhD1+o8u303KBBJrIxf
	LVTE+KHMlHvYVx2+oruC9UJYJaFmaMTSux/Au/cPyTY91q6lDFRP/Rd1anbSFDpxK1a15v
	+efMvi5BwlDLBO4p1VXLDUHxcDLih88=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786040132;
	b=WLcI7/R+nhlH+4MXSQ9ai4hGR81nr+6+uOd3Yf5rOjWHyMRAh5Jt5G17N8uUeKEnuKIUJH
	kjgC6fR0kl9yBVThDdpbGKdF7fIxp5W3Qm1bAaBVsq9prgLzBmLG3Gt5vrogqQccU483Wv
	rHIB1YIyThBFRz0cKqxBXsnXiotkAFY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=pBrQ5pyg;
	spf=pass (imf14.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.179 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-51c1372f84dso15200441cf.2
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 11:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1786040130; x=1786644930; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=k5UoSi/kRUvJ5D9A+qAnQzZgG/DBYzn7/rZxUaSi0lw=;
        b=pBrQ5pygSAImyHzq1cla4v2LNTA+QmTWomovm0zjpEiZ8C51sXF34Raih5L3ZOYWRW
         wK4+vsydOvR2RtRgUU+hGXJrF2xvrZLWc+5/5B8pq5M5vYWCXM3e25/ds4KtAiYRpAk/
         Z4UPeimxK21WlNAGSEaReHQDUNpbrsr8cYT70VCtxuoKjMXvMDVTPQDGNLAT5Mmlvktq
         VvZjsDmKlJ8HF3hWIZhIDka7QVQ8i6xDj4gjbllkMsgGKLG8COzemVFwiBha5Nz1RGsq
         7HK+6WLM2t7aPiqSPkOWOvZ8oxvFfPOWdWhhbz8aB5s+VI6XLOl8JE/UxNZoZcY5FC6s
         /Rig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786040130; x=1786644930;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=k5UoSi/kRUvJ5D9A+qAnQzZgG/DBYzn7/rZxUaSi0lw=;
        b=pjCeRF1yF6+uOPbuX+qmD6zxJvlfUPHHDS7KNYMk7bP5iYh/k67JN+QlCMfWoRqHdc
         QovU6E/zmd16fQHP7S/OZtkWg0scYv+JiLgq0iSNw1QkuZKlhQ/Dipqm6GpwbaD2fuXH
         IWaETXCSW6yYPgbfi/Jn9orI6rN0KHn7hY7nkHgcNe7ocCbpuErc5GpLFmSJJ0Jf2fd8
         eD4lxQmPRhOf7n0yVv2/Ymt8tYpxILQgzWvsyqjjV6caYevgM0j+xQKkUIR86xkhCKib
         Qjs2qZ+TQEqk31xe6o031edBi9A+LM4kiXeGZyIa+0cvYqiwcoZl9rSEOMM9oDOPpBsh
         kFZA==
X-Forwarded-Encrypted: i=1; AHgh+RrXNIzdMKsbP+t89lTTzCZEjNkMFpTF2vhT3TmhknGQC2r7wYOKIWbzgmLGNRsb3fGgJ+tniCQuPg==@kvack.org
X-Gm-Message-State: AOJu0YwljnaJcHim6s9kdJtwnQYePlNKmz4kY0tbHG80Ly2cwLkECq4r
	2X2XsTFrcN4QPA53It8xckJ48aMnq/DlSnmvkhT8G2UcIV5XRGxOZPauc8StR/ms+eY=
X-Gm-Gg: AR+sD11qHysWpJm22T6DzDYwoYMeoGCwEgsnB2wlfqtw3hG9geQdPhIAwqe1miyRjUe
	vU+vzCtjK5sZHVEnW+RTBKMD3i69YBcdbsZBbFPG0ZNN4u7qzPdSWdO3YzgBR9W9rVdMI3Nfo/T
	AEU1rs1oqtXo9rvSVYeh9NC2g2bqUEYNje2E2Oqk+9ulojtHIYDs1EsCcN6ku4JfzOkuD9ayjPO
	/gMuOj5ZvfxMusxxqayO3I56V9cMX2GE//4cHdctTmqksnFdtyMNeVB89XNfEjO/hZdVr4ihKFb
	7IP6wmEO0oo6qaRHZMBBnZPb/XVvFrWwGWMdqrRoj1WjOlH0KWFW4lim2Jalyq5dCwhUMVhCYIM
	r+ZyNVvYxcxWJv9TrUAZ/Nw9dTaj9MMqluI34sIHbFCJXxd6qPlgqlD6+d3WVDDzJTowujit91I
	fgsxPJ4NCwue10bDqmFJL1trTI252nmZUpLQFOO3h1BURLUalc+hiLa04OUSw=
X-Received: by 2002:ac8:5d16:0:b0:51c:92a0:b2ca with SMTP id d75a77b69052e-52ce617f426mr167955401cf.34.1786040130400;
        Thu, 06 Aug 2026 11:15:30 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-908800cb14csm57278926d6.48.2026.08.06.11.15.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 11:15:29 -0700 (PDT)
Date: Thu, 6 Aug 2026 14:15:26 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	Karl Erik Hofseth <karl.e.hofseth@opoint.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] memcg: keep folio's objcg same as its node
Message-ID: <anTPPr5hVV4aQLRD@cmpxchg.org>
References: <20260806165813.2526415-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806165813.2526415-1-shakeel.butt@linux.dev>
X-Rspamd-Queue-Id: C89DD100016
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: kidq9hyzwys9xntne8erdb4qm4eappcx
X-HE-Tag: 1786040131-481164
X-HE-Meta: U2FsdGVkX189Y0cJtNwWTidl13oF2QUxOywtOvtkbeSiYm2xcB1MQYYBD49Fn5luLXcp42tKkEo2Ck/4NQ+4fonYHpGmU/6ezEZIiTvbWtu3oge+Qxrpu2awM8wjOGpktk53sq7ikIIed+xRKMzIFtcx/QHP69dkaLZ732QOT6CzLQkYFkVcmi720XHL1Z9H6Mmx8Fbkox2NHcB47qH2H8Fdu6HoHqvPA7NVF4SdDBGY1JrLmpWbkHn/VeCqRcSMlOjmG4GCb3fXxO1lUblurZTkKxPHmQlnbkVYWoK4LkUaGzwQR8hcGvrK5IWSVIONOEoIhotyhx4vxxZKsjs9tFWaVpzGcLxBO8A3HUx7MIF5RgP9a5MeCcFduveu2QQJypFkdUL72itqMCF3CFeyW/kwtiJfVFwOEBk8j9IJRu/uy/KJA2PsVQ9zBzRtnDJdbJlOIdeXK8bztVJo6lPjissBCDo8MQik99gOYeA5rrVe86KSL7LGqg+HxrbBzMdG09cvPWoUKWXf1Okrk/pF4DV3cBveoAzkLVHIIzF/JDVpuo6R4XdmJ3bQss4TSMAn11KgC5RTYNI9BamUnmFHfYlJJ0+xDIb3xU3/ZMO2LRaoOHKV5ilmiQ9LtweJg8KiHdoyzBhw1O0S+RTBFBPYlJXJ3bn0+t2Aw/zfzmwd3ljvL9k8TiOyXCilXhhDW4D3GtP4l5kzdQWTfNjD5dDn/m8wOlHZuLzwOkF5ayjlG5EeHsxrQqVyQchZ+/q5nYbWNKt04Qm5VFNv9F6YxExbkDeehIUGn/dyY8xqdDbYEgAa+0LP+9NOlQVNXXiNhToV8jPIMOM9OkG8X9Rlb2ixiblHqN5cACGMWPxBwSkbe3L4Hev9ddINV/dE5Rl1OjahyWX77bLa51hvaw1/z+aEJQxkH0yZcA3Piq9sY9jgpalpSIvsGlzGl+SiXrJ8CeOURG0q9E0qI1D2Xf2L/rD
 xJmHFrws
 heC/1d6+NIbiPi/7Ox19IkWTMl1WAepgxtquBd2zSPZYimDqdIUfwENRCP3PN57xCGrrbAWPxEksTLD6vcjw/ffPo9LvCqbOPkVtqFdQvwWN6VJP0Ht3i7EuTVK/3sqgHcLahDkJQcr0tw5ZmIOt57SxAJgY3PikFLFBm5Wg811wo9zhL1ytfNdtW0Qx3fSO/efXFWGW7ZNFrnMxklik5q/f/Oy+VGpf5LoPw9GnoBinv/5EpSKPO9zVRA8kPEvZ7pIiiYrnYtD+3bNoK8ejFmzT1A3QMu2TnrSCLdX3iaJ+vO8PERiXXoymEuYQ0YVW3B05UE+yPcxBYbHGq18elKOJKSou36amYAt8M5IRZNm0VCmKTu3sTSzceDvqyB/UKiHr5pmt5Um1KrZ/duzr/3CTHThB+XZYdqY736qwHuhUUUPmul1pLJBquK1962P3jvIHI+CsSTdWbu3RBEa6EfwvUCuP6eDsyNSRTp28wMbrB5is=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 09:58:13AM -0700, Shakeel Butt wrote:
> memcg_reparent_objcgs() has an inherent assumption that a folio's objcg
> is the objcg of the folio's node.  Folio migration across nodes breaks
> that assumption: the new folio simply inherits the old folio's objcg
> while living on a different node.
> 
> Once the assumption is broken, the reparenting of the folio's objcg and
> the reparenting of the folio's LRU list are no longer atomic.
> memcg_reparent_objcgs() handles one node per iteration and drops all the
> locks in between, so the objcg gets reparented in the iteration for the
> objcg's node while the LRU list gets spliced in the iteration for the
> folio's node.  Any LRU operation on that folio in between resolves its
> lruvec through the objcg, and thus takes the lru_lock of the wrong
> memcg, not the lru_lock of the list the folio is actually on.
> 
> Fix this by selecting the objcg by folio_nid() at charge time, and by
> re-deriving it for the destination node in mem_cgroup_migrate() and
> mem_cgroup_replace_folio().
> 
> Reported-by: Karl Erik Hofseth <karl.e.hofseth@opoint.com>
> Closes: https://lore.kernel.org/all/anMmd1ADrDVwMO6v@work/
> Fixes: f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of dying memory cgroup for LRU folios")
> Cc: stable@vger.kernel.org
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---
> 
> Changes since v1: http://lore.kernel.org/20260806061830.3294679-1-shakeel.butt@linux.dev
> 
> - In mem_cgroup_migrate, do obj_cgroup_put at the end (Sashiko)
> - Handle scenario where destination node has been reparented to the root but the
>   source node's objcg has not yet (Sashiko)
> - Add comment explaining the race between migration and reparenting (Johannes)
> 
>  mm/memcontrol.c | 66 ++++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 54 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 3057396dda53..02c108cdd0f5 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2966,10 +2966,9 @@ struct mem_cgroup *mem_cgroup_from_virt(void *p)
>  	return folio_memcg_check(virt_to_folio(p));
>  }
>  
> -static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
> +static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg,
> +						      int nid)
>  {
> -	int nid = numa_node_id();
> -
>  	for (; memcg; memcg = parent_mem_cgroup(memcg)) {
>  		struct obj_cgroup *objcg = rcu_dereference(memcg->nodeinfo[nid]->objcg);
>  
> @@ -2980,12 +2979,13 @@ static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
>  	return NULL;
>  }
>  
> -static inline struct obj_cgroup *get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
> +static inline struct obj_cgroup *get_obj_cgroup_from_memcg(struct mem_cgroup *memcg,
> +							   int nid)
>  {
>  	struct obj_cgroup *objcg;
>  
>  	rcu_read_lock();
> -	objcg = __get_obj_cgroup_from_memcg(memcg);
> +	objcg = __get_obj_cgroup_from_memcg(memcg, nid);
>  	rcu_read_unlock();
>  
>  	return objcg;
> @@ -3029,7 +3029,7 @@ static struct obj_cgroup *current_objcg_update(void)
>  
>  		rcu_read_lock();
>  		memcg = mem_cgroup_from_task(current);
> -		objcg = __get_obj_cgroup_from_memcg(memcg);
> +		objcg = __get_obj_cgroup_from_memcg(memcg, numa_node_id());
>  		rcu_read_unlock();
>  
>  		/*
> @@ -5197,7 +5197,7 @@ static int charge_memcg(struct folio *folio, struct mem_cgroup *memcg,
>  	int ret = 0;
>  	struct obj_cgroup *objcg;
>  
> -	objcg = get_obj_cgroup_from_memcg(memcg);
> +	objcg = get_obj_cgroup_from_memcg(memcg, folio_nid(folio));
>  	/* Do not account at the root objcg level. */
>  	if (!obj_cgroup_is_root(objcg))
>  		ret = try_charge_memcg(memcg, gfp, folio_nr_pages(folio));
> @@ -5408,8 +5408,8 @@ void __mem_cgroup_uncharge_folios(struct folio_batch *folios)
>   */
>  void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
>  {
> +	struct obj_cgroup *objcg, *new_objcg = NULL;
>  	struct mem_cgroup *memcg;
> -	struct obj_cgroup *objcg;
>  	long nr_pages = folio_nr_pages(new);
>  
>  	VM_BUG_ON_FOLIO(!folio_test_locked(old), old);
> @@ -5431,6 +5431,7 @@ void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
>  
>  	rcu_read_lock();
>  	memcg = obj_cgroup_memcg(objcg);
> +
>  	/* Force-charge the new page. The old one will be freed soon */
>  	if (!obj_cgroup_is_root(objcg)) {
>  		page_counter_charge(&memcg->memory, nr_pages);
> @@ -5438,7 +5439,31 @@ void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
>  			page_counter_charge(&memcg->memsw, nr_pages);
>  	}
>  
> -	obj_cgroup_get(objcg);
> +	/*
> +	 * memcg_reparent_objcgs() reparents a node's objcgs and its LRU lists
> +	 * together, under that node's lru_locks. If a folio's objcg is on a
> +	 * different node, the two happen in separate iterations with the locks
> +	 * dropped in between, and an LRU operation in that window takes the
> +	 * lru_lock of the wrong memcg. Keep the objcg on the folio's node.
> +	 */
> +	if (folio_nid(old) != folio_nid(new))
> +		new_objcg = __get_obj_cgroup_from_memcg(memcg, folio_nid(new));
> +
> +	/*
> +	 * LRU folios are not accounted at the root level: swapping a non-root
> +	 * objcg for the root one would skip the uncharge and leak the charge.
> +	 * Keep the old one, the root memcg never reparents. No put needed,
> +	 * tryget takes no reference on the root objcg.
> +	 */
> +	if (new_objcg && obj_cgroup_is_root(new_objcg) &&
> +	    !obj_cgroup_is_root(objcg))
> +		new_objcg = NULL;

The two versions have quite some overlap. The refcounting is
different, but IMO that part is also hard to square.

How about a helper that always returns a referenced objcg?

static struct obj_cgroup *get_migration_objcg(struct folio *old, struct folio *new)
{
	struct obj_cgroup *old_objcg, *new_objcg;
	int new_nid = folio_nid(new);
	struct mem_cgroup *memcg;

	old_objcg = get_obj_cgroup_from_folio(old);

	if (folio_nid(old) == new_nid)
		return old_objcg;

	memcg = obj_cgroup_memcg(old_objcg);
	new_objcg = __get_obj_cgroup_from_memcg(memcg, new_nid);

	if (new_objcg && obj_cgroup_is_root(new_objcg) &&
	    !obj_cgroup_is_root(old_objcg))
		return old_objcg;

	obj_cgroup_put(old_objcg);

	return new_objcg;
}

In mem_cgroup_replace_folio(), this becomes:

	rcu_read_lock();

	... page counter update ...

	objcg = get_migration_objcg(old, new);
	commit_charge(new, objcg);
	memcg1_commit_charge(new, memcg);

	rcu_read_unlock();

> +
> +	if (new_objcg)
> +		objcg = new_objcg;
> +	else
> +		obj_cgroup_get(objcg);
> +
>  	commit_charge(new, objcg);
>  	memcg1_commit_charge(new, memcg);
>  	rcu_read_unlock();
> @@ -5457,7 +5482,7 @@ void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
>   */
>  void mem_cgroup_migrate(struct folio *old, struct folio *new)
>  {
> -	struct obj_cgroup *objcg;
> +	struct obj_cgroup *objcg, *new_objcg = NULL;
>  
>  	VM_BUG_ON_FOLIO(!folio_test_locked(old), old);
>  	VM_BUG_ON_FOLIO(!folio_test_locked(new), new);
> @@ -5478,12 +5503,29 @@ void mem_cgroup_migrate(struct folio *old, struct folio *new)
>  	if (!objcg)
>  		return;
>  
> -	/* Transfer the charge and the objcg ref */
> -	commit_charge(new, objcg);
> +	/* Keep the objcg on the folio's node, see mem_cgroup_replace_folio() */
> +	if (folio_nid(old) != folio_nid(new)) {
> +		rcu_read_lock();
> +		new_objcg = __get_obj_cgroup_from_memcg(obj_cgroup_memcg(objcg),
> +							folio_nid(new));
> +		rcu_read_unlock();
> +
> +		/* No root swap, see mem_cgroup_replace_folio(). */
> +		if (new_objcg && obj_cgroup_is_root(new_objcg) &&
> +		    !obj_cgroup_is_root(objcg))
> +			new_objcg = NULL;
> +	}
> +
> +	/* Transfer the charge and, unless it was swapped, the objcg ref */
> +	commit_charge(new, new_objcg ? : objcg);
>  
>  	/* Warning should never happen, so don't worry about refcount non-0 */
>  	WARN_ON_ONCE(folio_unqueue_deferred_split(old));
>  	old->memcg_data = 0;
> +
> +	/* @new took its own reference, drop @old's. */
> +	if (new_objcg)
> +		obj_cgroup_put(objcg);

And here it becomes:

	rcu_read_lock();
	objcg = get_migration_objcg(old, new);
	rcu_read_unlock();
	commit_charge(new, objcg);

	objcg = folio_objcg(old);
	old->memcg_data = 0;
	obj_cgroup_put(objcg);

