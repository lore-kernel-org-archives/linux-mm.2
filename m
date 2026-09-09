Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6483FC79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 18:21:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C06E6B008A; Wed,  9 Sep 2026 14:21:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 571EB6B0095; Wed,  9 Sep 2026 14:21:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4607E6B0096; Wed,  9 Sep 2026 14:21:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B1B96B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:21:14 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A7648401E2
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 18:21:13 +0000 (UTC)
X-FDA: 85195040826.18.CF95F90
Received: from mail-yx2-f8.google.com (mail-yx2-f8.google.com [74.125.224.136])
	by imf01.hostedemail.com (Postfix) with ESMTP id 84A2440004
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 18:21:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=ASNgJNKF;
	spf=pass (imf01.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.224.136 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788978071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CUMCov5LhTuYJkVeQH8wQuxKR0Qh1nB1q0JH2zRc7+s=;
	b=iWa7pkIdylgnoPNxhPY72cfBy2Zl4DHgISZbSQfAZAcojHr+YFMiN99ERP7kZOeRVES1MB
	2v/A+AqDmSi3QpMSgkeASJ+TX5Ssjc0FhBWB+Ys0yvrun4AcQIj3PQ557tOoWDdgomZ5Su
	LKeUu9wgUAkY0pdA8Y6JDcLi6jVVHbw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=ASNgJNKF;
	spf=pass (imf01.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.224.136 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788978071;
	b=nZK8i6oVyBG0XUbyEjNhJzrZU0Czuvxx5EydgBKCfOGQ9BDJxvwipp22HcyCcRdAdkUM9i
	TM5AU9hYh+EAjy/1l7j1cSPG7V4YWHu1STgRhMxf3n2PDwhIawpgC5L2unv3kVm8XD5N19
	naqb/D5sjOstjTlEDpKkeleAiv5fpXE=
Received: by mail-yx2-f8.google.com with SMTP id 956f58d0204a3-66d0f3138aeso2186703d50.0
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 11:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1788978070; x=1789582870; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CUMCov5LhTuYJkVeQH8wQuxKR0Qh1nB1q0JH2zRc7+s=;
        b=ASNgJNKFi/VMeIih7pHFBvYgmQVKxzFvK7rItXvGXcJLZ5P6hGX8WhAX1Sn//LWXfW
         1Udhj4b4QUp38lH4in/nud64Gm6n5suy3Li5JX1ywTxrU32hrKyXiVERx75ATvfjinc5
         yDQeUQOs0YyqZRB1jUySaJC4/lDgyZ8Rc24TkU3I7Hc57y/QVCPEFbyhiPgr1L8nxSQe
         1evBiEgWjzESprOKMjoYIGPyHFaBpqtUV78rtJ2uSp3x4s/+kbGNl6Dm1pvM+fGtg41M
         aRrxXs3ladTs4G041pc6lgnx7BdEG6W3pmwYy9iK2ArQQ+vmt2uJW0fdgRvOYftm3orw
         Btkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788978070; x=1789582870;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CUMCov5LhTuYJkVeQH8wQuxKR0Qh1nB1q0JH2zRc7+s=;
        b=N7zMoUqXeHZilFCMZ0Vkylu6JUsNRerZdCcz1yccmOfyUNalGC+nBOU7+IDu5Z+Ith
         cc0qgAtW17GWuBJMw8/SDOIZwXHRbmMXCq0HHJoa6zBuEUKB1vdM7QyGab28UsNDuqh8
         C9ktQG9mj7hzdE12nv5SfxpCg7Be9PoaEqyjNPDWnG2dCgMYkDIgnPxzPHfGjSzTRS2B
         OHRhHM7+CpaTTMw+7sjTXucHbIVkd2Lpyqey9EBfG6c+pB/x/ZBRahb2P85S3JCBVfS8
         tW7PsKwH/ea4zBHBVVUkD/Z8i5gd23rbafIVI8Nbq60Ee17okxhv+m+fZOQrXjJ5e2R1
         KPEA==
X-Forwarded-Encrypted: i=1; AKwUvBwrqUfNznxJ8WacSTyhYki5ndkQQVSSHl7bLGF7gjqEFvDvrmjeX61fH3EsbrlWK7owFBl+66evrg==@kvack.org
X-Gm-Message-State: AFuF++kb15FuamUsrGQD7J5hjPZ7beT3100YhHIh9TsIas7UN91laOhw
	XSAlbmg+glRdNAKBAub30hXKxZ5mCF47S9WFipOAe5Kq/84SIwVfzq+lF5QH3kq58Gs=
X-Gm-Gg: AYBFou0GHEqK8Bi4Yx6xLFHEDIg+2BsHEL6JMZO8kHI46eMBjov0jyy3MmXbUq7KO8s
	Zdnjrp6ZuU+5qytZNmwnQEqQErODEPzcOdSe8YUQguXkhHsqMw9YzO8nuv8SmmQwuloKrLJ1TGG
	ljQOLBLvmjuDLjU5PGDoMMkNAHQNjK/+k8d2GhAQAOB7mNa1L+Yd1bH71ebax5jpBD0VZMqZLIB
	EEd2iquNZBBCSXHnpuuVO3AOgw9IQ3K45AwzlR6wP3K+UjY5IkVbChgbvYPSfejeWegTeONS0UQ
	67Gx+sClHA/EFDlV+SvwcWlxChknjbo8Aexb8HQ8mkZ2jwfUg+u77BstUl9oLW7DmVzcqHdhgPX
	JDrOLoOb7+D9E0DslVMFZpu6rYBnKsIY8TnhvIeyV6ig0bqSfPoQPGbBR900JRmWbWPJbe4r0Mr
	NbWAKKzL4c1P30xlHOWMCTb94q1PKf5+/Fig2+ekFOGhEybDkHvA7PdXK+2OuZgrULMzTNrYo=
X-Received: by 2002:a53:e447:0:b0:66f:c1bc:c081 with SMTP id 956f58d0204a3-66fc1bcc626mr7160601d50.73.1788978070364;
        Wed, 09 Sep 2026 11:21:10 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-910406871b6sm152808526d6.32.2026.09.09.11.21.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 11:21:08 -0700 (PDT)
Date: Wed, 9 Sep 2026 14:21:04 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Qinyun Tan <qinyuntan@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Usama Arif <usama.arif@linux.dev>,
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Xunlei Pang <xlpang@linux.alibaba.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] mm: memcontrol: drop kmemcg_id and use the memcg
 ID for list_lru indexing
Message-ID: <aqGjkGA7XeYEHA2T@cmpxchg.org>
References: <20260907110111.2286932-1-qinyuntan@linux.alibaba.com>
 <20260907110111.2286932-2-qinyuntan@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907110111.2286932-2-qinyuntan@linux.alibaba.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 84A2440004
X-Stat-Signature: wx5woxyszaunh3ptdsu9y1k5cn8ci18e
X-Rspam-User: 
X-HE-Tag: 1788978071-169901
X-HE-Meta: U2FsdGVkX19+vUQfCaldY7XsaHne2tHU+eQDeyKASDRTCOEwgT0shmr7hEF16kr6JfGtYAFxefpJCQ4qBM4L0Dfm49ethOMQMSLBk7hqzS+OrMlYZNYSQrT5jezDJjwrgAqpcRuDsEbX/iL74q3G28Z/mINGSQHpA5HFaCgXvx+IU+8juiYT5a/MrmodqOH7gn/B9g0plY1TPuCgOyppiFf3sBtFoRdg6duxFfJfZP430JgNNnAbbwEdl5KPPIMfydV2l7/8F3NL8i5yZ4nBJ4epBQZvBluPzOS6p9ebBNNVD6sutqsS9dJdq19h2957nNxi9ZMI6OirqaxFerXLYnPQqhU8rjD/t1BBVMFYhk51nw5ckV5qkHoLL8m/HnRTxjQcdJsprcppr2Csz1iM5OTz8VMxm6O2+8hgmgwMI2c6tHgiBIVbiwx8b10MgjRhoyXOf53KRgt56y21h7kOnR9Pf+mW75/9/x/Lh3u2CKJo8fvqZonlOtxxGj3EXweD+Po/FWrwsjVngY9DL8M83grj3nF2Ly5FHLtKNx5y4L+iygMZzY6M/0PkqWASkuBMxf3pwLnpUf9z7y9wjx5VLEUf2KRL1plEC3YUNBup2OVWNa8ltKqCCN5ekqVPrPwwm3da5iGNixfI0/YEkx0shfkedorIlg6paugOYMAvFjmqcQzt8W4fYj3n2dUyvhmZxCS2u7Plaj/6zVAt7s3Yww4LspRN1GTgEG/IWfAtU9RNQDfSk/bDN6kiu0Hxu9aW2ACw5e/u1wyqcvzCtnuLc8LX12XfGSWDnpHcJqZVOl42NDwPbOMO1FVbXEyurQkkdyOoRq/RHzjbAKnnweVyFPojxnG3Ey4xUZ+GgOCba1MV8oQ1jMvv2Z+nisSIjsxXT7CiL9pL8Pe5wv3q5KbzL6X4WmfsxCzRciBpHHbE8MIX11+paZwpTNjqzMcKitnbJUEAkZZXEXqnokXyJNz
 nxjxLeJu
 dDMmcbwpFTaaTMQOLflK4OwcDirer6HIjw7TMMjpPyJfz+03atH54+d1nB7QA0ENTqWGPIbZK5BTenqBXqzwkWyNzN6zfvx4EwvpnedM9f/Ps+3muY6dywAXXxcRmSFWjOghSSubBvOkgK2VI1NVF/TqoDYjo9meAsd3JHuzbFa1SUfWX8bEd8xp/t/tqrhN8k/F0rK/5oltePC+ZrnXYbk7mVGpvIB09fwUW1h8+vrQabG9IL+DYIMO0aNRN1Wn153hsW+fohNwZKeGejUS6RFzdr8fpXWBAtmjLXr4RO5X6k7cj1dG8CKwNHtEwyQ8uxJlj1LbE062/tK6gEO0vAuBr9tcwp+r8kK97JeE8wXeyG/oZV4//h3sHkt0Pj4aYkY042YAVp4/5g5yLiD/hMKWx61dOH0HsAq8I7TS42jC1vaODkUajPF3t1u5FAZEp0g20BmFLBa1w9U+bID/dJB6IcMOmxWMcxGNG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 07:01:08PM +0800, Qinyun Tan wrote:
> kmemcg_id is a copy of the memcg ID assigned in memcg_online_kmem(),
> and is only used as the list_lru xarray index.  With
> cgroup.memory=nokmem the assignment never happens, so every memcg
> resolves to the per-node lists.  The next patch needs the index to
> work under nokmem as well, so drop the copy and use the memcg ID.
> 
> The ID works just as well as the copy did: root and NULL still
> return -1 and use the per-node lists, and the ID is only released
> after the list_lru reparenting, so a stale or recycled ID can never
> reach a live list_lru entry.
> 
> The early return of memcg_offline_kmem() under nokmem is dropped as
> well, so the reparenting also covers lrus that stay memcg aware
> without kmem accounting.
> 
> Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
> ---
>  include/linux/memcontrol.h |  8 +++++---
>  mm/list_lru.c              | 10 +++++-----
>  mm/memcontrol.c            |  6 ------
>  3 files changed, 10 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index fdf4812e1d818..edeb287978934 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -254,7 +254,6 @@ struct mem_cgroup {
>  #if BITS_PER_LONG < 64
>  	seqlock_t		socket_pressure_seqlock;
>  #endif
> -	int kmemcg_id;
>  
>  #ifdef CONFIG_CGROUP_WRITEBACK
>  	struct list_head cgwb_list;
> @@ -1775,12 +1774,15 @@ static inline void memcg_kmem_uncharge_page(struct page *page, int order)
>  }
>  
>  /*
> - * A helper for accessing memcg's kmem_id, used for getting
> + * A helper for accessing the memcg ID, used for getting
>   * corresponding LRU lists.
>   */
>  static inline int memcg_kmem_id(struct mem_cgroup *memcg)
>  {
> -	return memcg ? memcg->kmemcg_id : -1;
> +	if (!memcg || mem_cgroup_is_root(memcg))
> +		return -1;
> +
> +	return memcg->id.id;
>  }

This is a private ID with lifetime only guaranteed for online
groups. Reparenting happens right before it dies at offlining right
now, but this is not a great dependency to have.

Use mem_cgroup_id() instead and just get rid of that helper.

>  struct mem_cgroup *mem_cgroup_from_virt(void *p);
> diff --git a/mm/list_lru.c b/mm/list_lru.c
> index a4522ca93ebcb..6fd4e9af84396 100644
> --- a/mm/list_lru.c
> +++ b/mm/list_lru.c
> @@ -502,7 +502,7 @@ static void memcg_reparent_list_lru_one(struct list_lru *lru, int nid,
>  					struct list_lru_one *src,
>  					struct mem_cgroup *dst_memcg)
>  {
> -	int dst_idx = dst_memcg->kmemcg_id;
> +	int dst_idx = memcg_kmem_id(dst_memcg);
>  	struct list_lru_one *dst;
>  
>  	spin_lock_irq(&src->lock);
> @@ -536,7 +536,7 @@ void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *paren
>  		 * allocating a new mlru since CSS_DYING is already set for this
>  		 * memcg a rcu grace period ago.
>  		 */
> -		mlru = xa_load(&lru->xa, memcg->kmemcg_id);
> +		mlru = xa_load(&lru->xa, memcg_kmem_id(memcg));
>  		if (!mlru)
>  			continue;
>  
> @@ -551,7 +551,7 @@ void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *paren
>  		for_each_node(i)
>  			memcg_reparent_list_lru_one(lru, i, &mlru->node[i], parent);
>  
> -		xa_erase_irq(&lru->xa, memcg->kmemcg_id);
> +		xa_erase_irq(&lru->xa, memcg_kmem_id(memcg));
>  
>  		/*
>  		 * Here all list_lrus corresponding to the cgroup are guaranteed
> @@ -566,7 +566,7 @@ void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *paren
>  static inline bool memcg_list_lru_allocated(struct mem_cgroup *memcg,
>  					    struct list_lru *lru)
>  {
> -	int idx = memcg->kmemcg_id;
> +	int idx = memcg_kmem_id(memcg);
>  
>  	return idx < 0 || xa_load(&lru->xa, idx);
>  }
> @@ -602,7 +602,7 @@ static int __memcg_list_lru_alloc(struct mem_cgroup *memcg,
>  			if (!mlru)
>  				return -ENOMEM;
>  		}
> -		xas_set(&xas, pos->kmemcg_id);
> +		xas_set(&xas, memcg_kmem_id(pos));
>  		do {
>  			xas_lock_irqsave(&xas, flags);
>  			if (!xas_load(&xas) && !css_is_dying(&pos->css)) {
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 7ce50bccf1264..619d4c1f2e8f2 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3780,17 +3780,12 @@ static void memcg_online_kmem(struct mem_cgroup *memcg)
>  		return;
>  
>  	static_branch_enable(&memcg_kmem_online_key);
> -
> -	memcg->kmemcg_id = memcg->id.id;
>  }
>  
>  static void memcg_offline_kmem(struct mem_cgroup *memcg)
>  {
>  	struct mem_cgroup *parent;
>  
> -	if (mem_cgroup_kmem_disabled())
> -		return;
> -
>  	if (unlikely(mem_cgroup_is_root(memcg)))
>  		return;

Both of these functions do very little now and the asymmetry you're
adding on the mem_cgroup_kmem_disabled() check looks odd. Please just
inline them into mem_cgroup_css_online()/offline():

onlining:
	if (!mem_cgroup_kmem_disabled() && likely(!mem_cgroup_is_root()))
		static_branch_enable(&memcg_kmem_online_key);

offlining:
	memcg_reparent_list_lrus(memcg, parent);

The root check is unnecessary because roots are not destroyed. But if
you'd rather not make that change here, keep the root check, and leave
its removal to a separate cleanup patch, that's fine too.

