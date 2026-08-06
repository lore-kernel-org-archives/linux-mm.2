Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79343C56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 15:48:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 348106B007B; Thu,  6 Aug 2026 11:48:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D15A6B0088; Thu,  6 Aug 2026 11:48:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1998B6B008A; Thu,  6 Aug 2026 11:48:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CC3506B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 11:48:01 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6ABB3400FD
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 15:48:01 +0000 (UTC)
X-FDA: 85071275562.11.B402D37
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2AFC1160009
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 15:47:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=fNJjGNd9;
	spf=pass (imf08.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.48 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786031279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=myJJrsaRCu8qhOQiELgkCPpgvl9NHKGEjAfdC/X/7GA=;
	b=kr8amoqs/xnW/WseNOZbwRwRBJFeXPsk6rba8RBK0jR9YYCfCmqsvi5CdpTBoOzhS1G3Ht
	YkmljdcFPIVA54+ezt1dbh6JfV0LLz6jQBaYli0Bf5MTrREKTkv0NBE3OKWjyucwlwe5Ib
	Q19WjFiuP0k7xmsHUnhJLP9pr+tvrvw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786031279;
	b=DvNC269hHl1/dvRIfBKY7gwntEnSov5bJ8ZC+uIWXabuzeuBeYr3rv48FXy4mf/9feqBAj
	SC6lfdJTRP7Do9FZI7fGpLXNdGkhsy/aS+Ra6EejDS9Fw0g+lVJNwxzwfprrPbObuusiZ0
	UEoFdK5MW7ioqaixykyHc8zTODkMwlo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=fNJjGNd9;
	spf=pass (imf08.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.48 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-902fc790cd5so14085746d6.1
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 08:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1786031278; x=1786636078; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=myJJrsaRCu8qhOQiELgkCPpgvl9NHKGEjAfdC/X/7GA=;
        b=fNJjGNd9WeS9e5phYmEv9SnWQKE3kKzyGER1ap2amhEvbJqJslhGFkIyiYwybb6HFX
         RPLR9WHUdoHehkJ5Tbfj/usCk2rVJT4SiwlXXE3mj95ZutIpMxo+bU6vMZed/Rrrl7L4
         qD7M3F/d4R8JZH7q6Sqqb3yhb0OqqA+WRX2X0uNtS9NzTqtjnmfpL8OUnXQovdeIj3Dg
         dJkHqxYQkF+EGN6UUxLFqPKLc+4j5JQVHTb7rkENSpXgganjpe46tAUs9ZGsnvpudDVU
         9TXY939uKBJBIHkAF1A2ELG0hdNovw737VhhWV5xUZ8C1dWl3F4L+9sJufHJ1GELtehH
         wlQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786031278; x=1786636078;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=myJJrsaRCu8qhOQiELgkCPpgvl9NHKGEjAfdC/X/7GA=;
        b=oadGF/F16bTqZdbOvdn1sGjA+VxzzhvNbNaGankgtnbXxtyzhf38RSVH3wSr0hqYet
         4ch80FWEEa0yfdTyGIy128+Q9I2PwxrB8aCVuF3ldTWkvcQLWJVxEAEqRGQ1+M2tqpys
         zgbarGa9ZLVg6OyZVtY6g00/lk5mgwC4mv+3v64wJebMf8nkoLHqfWn7BUCe3wpmGNHn
         Us2zt3ZZ0zW868Dc+nkFutyvYQQROEVhU/2tJJx0M0zijnWLqQ+MDcHOwtyIiY5eqxYb
         X0iL9XV3kkVElqIy/jlZpuKjah8noI1D76bPm7LvXiO7qlE84vFQtDoIsACEA6QGM5JT
         ibvw==
X-Forwarded-Encrypted: i=1; AHgh+RqMsjnpcz1/HCg9x6at8+1pfGD9a0pJQ9asls4nAXJi7Si92OozW+gzAKXWPFO1ibRI4DXyDH5wLg==@kvack.org
X-Gm-Message-State: AOJu0YwSNZC7x2Zc9ncH4B4FlAJU0eqVfCV29pyEitQmThIoqoeOcYVj
	trsf/zWXeAA/NLo7JBD70WuVeKJt8IC8w7t4SRmrrnaLKAlOK56kXj2QeyRwen5iFsA=
X-Gm-Gg: AR+sD11Z7pwlGjFj/DkLy4wHcUFeB/Pk1oCk/1eHQEL05CBLE4ayDFV3KWsEvzx9ocF
	aODVMYXDwW1WP9IX9udZOD1L2xG7hpu1HD2CJA5VkRksseIaWvqC1fhsGzET6i90ZGOSrZkBIWm
	PBqhHsW+CevTScu6VPBsrWz56L3UEzAwKpcin0QDwkT/CwLKSFobJRUrpRomBQI3X8D2CgnwaG6
	jF3EKuHRDY2PeWYae/XZo4uqllkULcLjzG51kS+oi4n0oU8D+k7dJot8vYlXYVde+xZL+geaHrM
	tRmCYthba1hdsbz+2VI3OrVdASDocbl1vFsx/oJUlCqD28TPDZEroSgQv8hmzgq9u02mZ85i++s
	enHVemak6c34/jmpyqguAyTkNUvAbxZhpzReSO8M1vERCTfSVN7zyqTHVYBMN+moTCFMjAomLtg
	UN234RUyGc7SS/jcBAH8uWC2YF/srg0KcX84+RuJq9YqBbi7SvX7Pk74O85ro=
X-Received: by 2002:a05:6214:1245:b0:8ca:1e0f:f20c with SMTP id 6a1803df08f44-90881081a90mr160100486d6.4.1786031278026;
        Thu, 06 Aug 2026 08:47:58 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9087ff9d720sm54902046d6.4.2026.08.06.08.47.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 08:47:56 -0700 (PDT)
Date: Thu, 6 Aug 2026 11:47:53 -0400
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
Subject: Re: [PATCH] memcg: keep folio's objcg same as its node
Message-ID: <anSsqaD3QAlvQ8cd@cmpxchg.org>
References: <20260806061830.3294679-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806061830.3294679-1-shakeel.butt@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2AFC1160009
X-Stat-Signature: osgzcegqywm37goru9izwjpf5f8dp9bd
X-HE-Tag: 1786031278-957663
X-HE-Meta: U2FsdGVkX19aIyWREqAtO0JBR5ftiBF3DP+D97Qb1IBQWiSnEB8JqoJD4ZWkoI3jJ8CtzDG/dWc4IfN/dD5oG0Dxnl+nj+oJgtx5ihVOXSEI2Jf3elyyN9VIlD9Ni4CWJqRRpbMriplp4ld5CvQiYwwtT8XbINh6MCQAOamsIT6bey67QBczFt3ewfP240CFmOhYZMHCokY/CO341dr7YjVt7HoGebTi6bt7/dNImgoMRj+nZQUzl4ilih8IRx+DERZDZiLQuJWWrVSknvCA9OolEQlEDMImaumVane+g4NNASEpLJKyE4pD2lUccLa628aw4ZinoxXrs3hDzuWKSe6eKB4eb+2R+OpbgEMKJ5YBia/tkizorFjMPLQr8Rl9Ies4a/1NUZaR4GaAaL5mzbDndvkaWDEDLYmLruyohrLHuEU38PHKJVOMhN8dchkRUO3ez1Hh2dd5D91IZt9erxh2hoV77U0w1TI4V97s2ygoFBBKBBcIZyBrrzkbOEvBO6AO5p56rqiiRWl4VU9MtSkcZYplR50EewVTb0YqTZix3p/J9Mhky5K3lAURqwyWcO8caf6OOz9zOiFg4ZE0cOIEG+kf/gY7YX0S/LGZkHMzfSC3ZAiQlSfWp6C6SIpJJARFZXIu8FKrJzdzUFnxZ0+A++PNmrtl4Tn6VTidmi66nhDMuWwHhot5Jp8AgGomIdciL7R8wlKb1DBnMcr5ly3WybD6KIU4tIybEclMm/FUwiniVAi5F2j8sjx+neUhjLhSKp0/rwflFdn+arYZt0035N5WA+/7lgfDEkaX/QElfDe/oa8scOu7zPS5jvAnDJU5MA5fMZoM9DrQopBHccpo59MQuv4mm39p8uCydT0o9SsOGARK3/gKhzisB/XfvYM9PJWZ83kAfX3YZ8vuJgNmvI8tWET6byevbp1Q425eP6VxsPnOnhHZocMMIrgtuYmpnYyhcHpH019NDgd
 1fIQyLp0
 gY1n27FrKHHxeDmvgWATBOnjNou6mqCmqru4Y9Lhkzt1dHSlqSr4aTJ9e0jAGVzvJdnjuOKqVncOgepryW0DVVF/PwUn9vNsKveqxGV/GtVWdL4BIw2wnT74ZP1Po5daVSffHyohrcP8mZpF1m5Wh0KBTLxJgjTvtX1TBYjd4JHLqw1bDPu2kmv2XpQqg7+CoM+spgr1rNU3Nu1dhtZGOFFcU58lHskKIRl9ZmRPe83PMBiS8YaJGd8rLlIMcu+UbQElUtDNnoDp37npSphRFoz65xQC8jwyjuyQsmdLMAH8dcd7alEFwFuK7oSKW6Tzgx8rY0gLOhV8m6wPy7yN2Ld2ZBb1NKnC5FbWNVKA8Xqg2vo2y6O4D3K8GEQs3RN7v5kQfRj3K5rYDWU29mN7r7w4Y8drLzRytjpJs5qt8bSRJKP1ApfR92VsudZFGcj/MVEmDuLi7qOtFyMSCFxbIu2hvuwY5RiVs18K7hiFI3Qyt87w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 05, 2026 at 11:18:30PM -0700, Shakeel Butt wrote:
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

Nice sleuthing.

> Reported-by: Karl Erik Hofseth <karl.e.hofseth@opoint.com>
> Closes: https://lore.kernel.org/all/anMmd1ADrDVwMO6v@work/
> Fixes: f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of dying memory cgroup for LRU folios")
> Cc: stable@vger.kernel.org
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---
>  mm/memcontrol.c | 33 +++++++++++++++++++++++++--------
>  1 file changed, 25 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 3057396dda53..2e98788dc8bd 100644
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
> @@ -5431,6 +5431,7 @@ void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
>  
>  	rcu_read_lock();
>  	memcg = obj_cgroup_memcg(objcg);
> +
>  	/* Force-charge the new page. The old one will be freed soon */
>  	if (!obj_cgroup_is_root(objcg)) {
>  		page_counter_charge(&memcg->memory, nr_pages);
> @@ -5438,7 +5439,12 @@ void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
>  			page_counter_charge(&memcg->memsw, nr_pages);
>  	}
>  
> -	obj_cgroup_get(objcg);
> +	/* If replacing folio of different node, get objcg of that node. */
> +	if (folio_nid(old) != folio_nid(new))
> +		objcg = __get_obj_cgroup_from_memcg(memcg, folio_nid(new));
> +	else
> +		obj_cgroup_get(objcg);
> +
>  	commit_charge(new, objcg);
>  	memcg1_commit_charge(new, memcg);
>  	rcu_read_unlock();
> @@ -5478,6 +5484,17 @@ void mem_cgroup_migrate(struct folio *old, struct folio *new)
>  	if (!objcg)
>  		return;
>  
> +	/* If migrating to different node, get objcg of that node. */
> +	if (folio_nid(old) != folio_nid(new)) {
> +		struct obj_cgroup *old_objcg = objcg;
> +
> +		rcu_read_lock();
> +		objcg = __get_obj_cgroup_from_memcg(obj_cgroup_memcg(old_objcg),
> +						    folio_nid(new));
> +		rcu_read_unlock();
> +		obj_cgroup_put(old_objcg);
> +	}
> +
>  	/* Transfer the charge and the objcg ref */
>  	commit_charge(new, objcg);

Just noticed Sashiko pointed this out too, but you put old_objcg while
old->memcg_data still references it. I don't see how that could lead
to a UAF but it's fragile.

Man, this is hairy. I missed the implications when I suggested to make
the objcg per node for simplifcation elsewhere. Now locality actually
matters -_-

A comment describing the race with reparenting would be very helpful.

