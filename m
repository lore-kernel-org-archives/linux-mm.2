Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F14CDC9830C
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 03:22:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 621ED6B008A; Sat, 17 Jan 2026 22:22:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A54F6B008C; Sat, 17 Jan 2026 22:22:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B13A6B0092; Sat, 17 Jan 2026 22:22:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3A5326B008A
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 22:22:36 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C679F5871C
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 03:22:35 +0000 (UTC)
X-FDA: 84343637070.22.8714731
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf12.hostedemail.com (Postfix) with ESMTP id 23D5A4000A
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 03:22:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NeVH4nBE;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768706554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aYdG6iSFt6rOFFrw4mq3rc77nFFtef/gsB7GXuqleA0=;
	b=pp33iGZUQ6/jFNPgpG2iHPrpYHqfFhA84dxLGE0KnO4fFTRqkyUFTpeJHqoUNqIJ13hN6o
	gk+LwaBiYNk5y0hk8v3lG6fNAlZ7QWIj1rOxoTlceog1e9YrERPh1E+7KWz3i62B/DDgKm
	/UTQduZiFTZIKxtOkhD1OMwT+/G7aPc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768706554; a=rsa-sha256;
	cv=none;
	b=29e2N7A8kh+fgOwYlOdpJWKsOercrj6A5OdqpUokey7LjuYcYJKu5DKcJEe6Ivy2mYQcX+
	ooKDZ3wrM2tFD4RKYLZMqpj9U6iYUXTbFIaOCBQgrHusOaZji5H2Zk7DeLQ+Z6QOmKID4Y
	gql+YQYgDJL0zf4JzXcJ4nAYzY+MuPc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NeVH4nBE;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Sat, 17 Jan 2026 19:22:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768706552;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aYdG6iSFt6rOFFrw4mq3rc77nFFtef/gsB7GXuqleA0=;
	b=NeVH4nBEppqtD81dAjc5ZZIuu0vf64lQNh6sS5/+nMmDMyTFNDqYR3HPs+hD9kwN3zQDOz
	c2G/kNS/C6DI1XZp1x/trrCPd8Wb55NHi79e7LzexMkmWZTy9i6VrRL60IOhZ+onM0N30A
	jTDMb/YPPA6tb1HFyQzd+fIAidDrQDk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, 
	lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v3 28/30 fix 1/2] mm: memcontrol: fix
 lruvec_stats->state_local reparenting
Message-ID: <ifcth3hxyrwmmeo3nejettdtkw2ndxdjbylszmhq3vohuhsncl@k23pew6gywko>
References: <b11a0bde9fe18673a61a79398f226ad7cb04a894.1768389889.git.zhengqi.arch@bytedance.com>
 <e5afd1b5ae95d70f82433b9b4e13201342d16707.1768473427.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5afd1b5ae95d70f82433b9b4e13201342d16707.1768473427.git.zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 23D5A4000A
X-Rspam-User: 
X-Stat-Signature: o1rrnjahx47dh8gcaga8ewc1pxxacu9w
X-HE-Tag: 1768706553-22333
X-HE-Meta: U2FsdGVkX1+w8wb1V4bUEJxGUki5XLaZPTIbJSkWxT2zLRhm0L81W/th8fI1vkRj+ahgzB2gt+wZ6L5J1xhnNqodDFRGu139GwNknBtOCQ9T3/I0aKr1W5HjdMj+g0HE0y3BDwquhq2HMnAKm8/xzdHg4VQty7SPlWhvV1T5DvbkpwEZIkgXrphP3X3pJkKsT1P9g6sDIl+CBpe1CPgUkHv/Q9N7kYPf3iPthjCmkft83ln7vvIKvf/IpV0v4HR3lRs1rcoSgexYvUGUqHDaij8d0qsJ/tHJWmfUZ/6j+kFFXMYPu4ADhqSqt5++y+1fGts7K8MFRlbzcjz7iPaezFCs87tzrrs7v7oqCmuFjONmrDoaEP6n816gcXxJJ8BVAuuRBD75/BEA7ctKoI4SZxlRM8feJ8E9cLZNl0IiGKGJV/3+KBUIWLgWwSgKKXQf+svutfkbabABfgr6jdaNcpahtJliIjPU6lFb48L3UxIuPXfaWv31IKoy1O/Lr/I5eatzQhL2tOMMoyO9WzoAn1sbqb9hj0GtpfrqmhsLaaUjdVSCQnPjAQ8kussB3/ZKq3guoIC2jMCzriu2AnN4TbC0Vl2/iLhN2HM2vMVbaUPFTLj7inRoADnNFvd3+inHR1IRzo5DOb15sd45WTzj3YwLIBddw4fNbWNZf2ZnTSGcTx4kr+FRtsxkR1hOodcCC6uijeFaJtHNlIPma/Illmn/HgbBFvt5y9Bgzqr6iXmlwQv6wCWhwoKx7sCwG3GcpOU9Q2oMgpzXAj3UVfQrCgKOKF2UmZT9RM8oey8iCiecoskroNH6iexcwj2+d0jmwMmAXiejDAg0AgbALnUCpLZ3WOSkHH7r/r12/CyDB91Z9l66D19TTLocaXl42KYmWHKHeP8iNwLspToXELc/UnIW/UwnDqCfMzxaABnx4D3YfF2bMNEtF7PvgEAKJzx9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 06:41:38PM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
>  include/linux/memcontrol.h |  2 --
>  mm/memcontrol-v1.c         |  8 --------
>  mm/memcontrol-v1.h         |  5 ++++-
>  mm/memcontrol.c            | 19 ++++++++-----------
>  4 files changed, 12 insertions(+), 22 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 1fe554eec1e25..e0b84b109b7ac 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -944,8 +944,6 @@ bool memcg_vm_event_item_valid(enum vm_event_item idx);
>  unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx);
>  unsigned long lruvec_page_state_local(struct lruvec *lruvec,
>  				      enum node_stat_item idx);
> -void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
> -				       struct mem_cgroup *parent, int idx);
>  
>  void mem_cgroup_flush_stats(struct mem_cgroup *memcg);
>  void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg);
> diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
> index 03b924920d6a5..daf9bad8c45ea 100644
> --- a/mm/memcontrol-v1.c
> +++ b/mm/memcontrol-v1.c
> @@ -1909,14 +1909,6 @@ void reparent_memcg1_state_local(struct mem_cgroup *memcg, struct mem_cgroup *pa
>  		reparent_memcg_state_local(memcg, parent, memcg1_stats[i]);
>  }
>  
> -void reparent_memcg1_lruvec_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
> -{
> -	int i;
> -
> -	for (i = 0; i < ARRAY_SIZE(memcg1_stats); i++)
> -		reparent_memcg_lruvec_state_local(memcg, parent, memcg1_stats[i]);
> -}
> -
>  void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
>  {
>  	unsigned long memory, memsw;
> diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
> index 45528195d3578..5b1188f3d4173 100644
> --- a/mm/memcontrol-v1.h
> +++ b/mm/memcontrol-v1.h
> @@ -75,7 +75,6 @@ void memcg1_uncharge_batch(struct mem_cgroup *memcg, unsigned long pgpgout,
>  
>  void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s);
>  void reparent_memcg1_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent);
> -void reparent_memcg1_lruvec_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent);
>  
>  void memcg1_account_kmem(struct mem_cgroup *memcg, int nr_pages);
>  static inline bool memcg1_tcpmem_active(struct mem_cgroup *memcg)
> @@ -116,6 +115,10 @@ static inline void memcg1_uncharge_batch(struct mem_cgroup *memcg,
>  
>  static inline void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s) {}
>  
> +static inline void reparent_memcg1_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
> +{
> +}
> +
>  static inline void memcg1_account_kmem(struct mem_cgroup *memcg, int nr_pages) {}
>  static inline bool memcg1_tcpmem_active(struct mem_cgroup *memcg) { return false; }
>  static inline bool memcg1_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 7333a37830051..b7b35143d4d2d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -225,13 +225,13 @@ static inline struct obj_cgroup *__memcg_reparent_objcgs(struct mem_cgroup *memc
>  	return objcg;
>  }
>  
> -#ifdef CONFIG_MEMCG_V1
> +static void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
> +					      struct mem_cgroup *parent, int idx);
>  static void __mem_cgroup_flush_stats(struct mem_cgroup *memcg, bool force);
>  
>  static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
>  {

No reparenting local stats for v2.

> -	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
> -		return;
> +	int i;
>  
>  	synchronize_rcu();
>  
> @@ -239,13 +239,10 @@ static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgr
>  
>  	/* The following counts are all non-hierarchical and need to be reparented. */
>  	reparent_memcg1_state_local(memcg, parent);
> -	reparent_memcg1_lruvec_state_local(memcg, parent);
> -}
> -#else
> -static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
> -{
> +
> +	for (i = 0; i < NR_LRU_LISTS; i++)
> +		reparent_memcg_lruvec_state_local(memcg, parent, i);
>  }
> -#endif
>  
>  static inline void reparent_locks(struct mem_cgroup *memcg, struct mem_cgroup *parent)
>  {
> @@ -510,8 +507,8 @@ unsigned long lruvec_page_state_local(struct lruvec *lruvec,
>  	return x;
>  }
>  
> -void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
> -				       struct mem_cgroup *parent, int idx)
> +static void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
> +					      struct mem_cgroup *parent, int idx)
>  {
>  	int i = memcg_stats_index(idx);
>  	int nid;
> -- 
> 2.20.1
> 

