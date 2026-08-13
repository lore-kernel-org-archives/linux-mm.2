Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A967C5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 08:28:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D1FE6B0205; Thu, 13 Aug 2026 04:28:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7830C6B0207; Thu, 13 Aug 2026 04:28:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 697B96B020A; Thu, 13 Aug 2026 04:28:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 40B016B0205
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:28:58 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CAFD8A2C0A
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:28:57 +0000 (UTC)
X-FDA: 85095570714.27.006BC97
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0028E18000C
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:28:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Y5HzERcS;
	spf=pass (imf24.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786609736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fgiJKTttCwuzu5gzwlJpsUc5acP5ulEuNQCsjjnCulg=;
	b=odgkUyHMuBrYFn5sYEg8m3tbgf0BOeMmQp8O/vgTTspcfi6LFait50HrprqxpcbEwl9sPJ
	u0LXo1xe2nGCl3hUZ1x/o9Cessp7skZyX/E3GQMsGgf++PIbmHeBDoe/Pnd6MIUtnpDB1H
	5VfhN/Wb/uogpa8oiIkox1ZVoHDEkYI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Y5HzERcS;
	spf=pass (imf24.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786609736;
	b=5gwDOY6qQHJuJuezlvJKWhW80m/eoRjYb0QWZTSrZljrtoTHKdrEJsDe/tupm8ucqQ+X9s
	5pRxrtH8i3OxCtFnH8NCWXWn+ZLlZkaWOSeKxmfyWHbcuaREzhT4epQJuJVsu0o5oC69hD
	qMeK3iCk+Cecd0SKvrGnypjUxAnuOHU=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-49954b88fffso4796915e9.0
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 01:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786609734; x=1787214534; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fgiJKTttCwuzu5gzwlJpsUc5acP5ulEuNQCsjjnCulg=;
        b=Y5HzERcSbk1DYEeABuOCt0kP0KngjxhXq+pqBQwUayAFqtJdtjCmDQ3r2N8g8ggxQc
         lBZcleBnOoIcN/e39kXXnQiig8OXCC8AcrKafRAGR32erQNy+94n87kp5MRX/PsNpwcP
         4OLqnpw4AnWOkiFRTtMSacU4Wu/7SnGlXygKlbPKVkTJnpjyVnMFpjLaFtdMPpUEB3yl
         NNQBIVsjxuabqe2dd/mr9RKpAk9EtT8NUfjQxmGtSDARSLMp1pBm9yEco7rtkBcET2yU
         XAY+4D115Mw7OSCTGvk0Q9HTPzoR2uHzXc/rPgslFdTNOr9m/uyVvqOvlSTPobKOTydW
         XcJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786609734; x=1787214534;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fgiJKTttCwuzu5gzwlJpsUc5acP5ulEuNQCsjjnCulg=;
        b=MFNdaXOE+f2abSwlyZOKd825nq2nIMO+UTNpFc1F01yeMI1KXdhgBowSpD5W7qJciq
         IkVsyk2LkYYS0JEwUuXClVTWIIzzMBJ1s3yxxCYppYbVDo8pvOTnZM4Q8fe1mCfK2VPZ
         WqEFL6CK0iK5hv3b3wKyhacESk2BuHKEGrUVo6zAA8LRn94DIz2VPWupeX59TEFJ/ruH
         ve/YOG/0BNQmaxmSU1LiH6cttUc6WnmFQ3cga0Q159bORy9CHOKnsGwVhbz0aHNvqtPh
         QlPM9gru3IEXUztTSNsq5K50uBOKdmkH9qkXrrVASnQ49kmVcyuOFnb3BoWvNbvTebes
         SFug==
X-Forwarded-Encrypted: i=1; AHgh+RqfkPIJnj98FAxwg6/bCugf2l4xj+7RmCMqDZQbhCyAC0V//Ai67Y9YkYmogG/NXggnU1LKAA+/fg==@kvack.org
X-Gm-Message-State: AOJu0YxcIzxNG8DcBUqQdyKWIA/2wgijfk9RC/LGjMd9YOwduySZs2M1
	P620XdZRxZwysNBSYAybBeMybL6aXHPUfY9YR2f3aSRhX7FOgZi/exUgrt3kp/2zhFk=
X-Gm-Gg: AR+sD1241MTqn7NvSTZ/R3WCwdtPe/CWmuqvRVZwLCkB39hfalp2ahE/M/d4HHUCMI3
	kZ2/RMMWc4ib38te+x+C+VhGaKRkqRsluJr7+evE48K7kh5XJm/jwYim4ci5/wA8+7FmRQhHE0B
	aDHY6Tic2gDw+jutWQHqMdEzdfH5cVM9nE2qA6TPlU9hvlNMeaeeTqSq+CtA0KxfoNEkOG6EYU4
	mjWZhquUKNsQCybS5rX+JxjcgcLA6TKBG/cPmD3JZbuH4e/aFNPXZQgbP7Jd5BlcQJHZFEodybO
	aBWL6t1t46asLw1N1mTyJesjsufsErvJGmjYS348do0zEOUiG7woEgcyFr9pl/ND0SHW0yTKJXw
	CJX8JD8kY6RaUhKxGpLD0m9WZ7VycmU0EzyOnfzmrL2jHaMa0+TuiXUwDI3C218KLaUOURyGcw1
	L2EaH71BD2TeLSUQ1bECrDHS4jgqyZPtyskd8nvcpUJBkwdblpo0Ar7vt1qldIsrnGsJ4ArcM=
X-Received: by 2002:a05:600c:3143:b0:499:795a:c5fc with SMTP id 5b1f17b1804b1-499821c5aeemr42857285e9.7.1786609734405;
        Thu, 13 Aug 2026 01:28:54 -0700 (PDT)
Received: from localhost (109-81-29-60.rct.o2.cz. [109.81.29.60])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4815a5af191sm4559176f8f.19.2026.08.13.01.28.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 01:28:53 -0700 (PDT)
Date: Thu, 13 Aug 2026 10:28:52 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>, Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] memcg: simplify v1 event ratelimiting
Message-ID: <an2ARNynd2QQU6eJ@tiehlicka>
References: <20260811203203.3456029-1-shakeel.butt@linux.dev>
 <20260811203203.3456029-10-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811203203.3456029-10-shakeel.butt@linux.dev>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0028E18000C
X-Stat-Signature: 4qsstugh7y37iboh4sguk5gqu9jgtud9
X-Rspam-User: 
X-HE-Tag: 1786609735-469175
X-HE-Meta: U2FsdGVkX1/iw713TrWff/mEv+6ywu8SqHGMhk7ne0y+K9CUCdG8W6ir//79zrXtFcll1jPOhYso6Zyq4oHFcnC6MH3qBNiV3pTgJDo2pzfoiFnZg5W095jWP0qKgdLVycgiepo0QJb4e8Ol7IJsyd6HcHAJOW/nn7TchqwaXpVFMO9AfpF3hMzmeciQ433Yzomg04pBzoOh+iIYjjAP5axZp7xxNz1gDUgcqn/sURPJnxV3vxkvVs6RFRvFyaToR+/Mg8TiuUjKSdTEQcODVXrLXeutvHjl0ZypQHWTp6cjceqcDzOgVT74IM8Tk2MP8ArQhVbwH8YqnnYQWo/UAIOeDkuUDhzgeFC1tqmgJlkPh+ZCBcdA04oojiFyBQmbwEx5NTYBD4Kl57oBp9dSbxxknFJvLqPH27w4nVteqOxRSkl1FGW9xSV88klk5chunbi2fh7ZUW5YMSu1Uss4Mb/TuO9wjimmp2hnQc5nQa4elzON6Y+f7krMQFBsK6pI/CmK9zu0nVQg8e+6FYCogd9K15O36PRvDA3k7lbVZAMWfGuVyw3th4aRR0M4EB2hpQVtrdleWef+96YORf1hfFYcL4ZIwT3PO3dkIDmq7U3kE2tsz4CURlW5VXDXDn5NhQDBD9x/lC/sorwEYUKvqbv2tdIFolzIWZnKV0gCEn13Eb4BUkmbU+dBzQPevhJBOHT4k7hq0d8nTFe+uwhe1/9BzZYknyYH/FMrBOiT3HUlwIh0FUojLJfVFGbuzl7lWsTNjDIzf87V5hq0e0FDXflpBU/QHZJDvCjgM1i02Ht2i2JBujMt0+yxV4hVbi0haI0rVBcCB8BuQ+C0ws6+sP5nZwnugp8+fArayyg+vtuCTglm8GC/79wi31yxuGGLPUHlT0g3HzDtQPmlfRtGO/7QDHL+oCzhR0OWDkNSIVhl+8t0v2bA00vYKmo30GzowigqzqIgda3pDdL4hq8
 VhWV+2jv
 T36do8ADHyejmyiEDSfLTBH/DK/Z+f50URMU5PisVIT0lH8Z5x2qadhj0NGb7Dfci+8QqiL0uVzSXXif6ZDZkXhTZbpNKBIy/eFUNUJY4tCgsE5iTrg/6VyUqu17LAGBPMyJwGRvTbg4oAAPYe0l29GOmTwPgtpxiKJQph8nrq/j84iLh0Ik91rbpVyms4lhdVMDsfni04ktzzVMBk90Ppyrw5VEagnVNhw5N0aFpIFrmoyxoqRDhKss7bE5gMUZnoCsaNJLsOVhbZs7/WmzwKjVCVVoIKJkLoHE5n2nyh28BcGR/fI4AXJeZ4v6KUCeDrkERpTsHHmj805QGXtCz1E9axWukma+D9ZlqdXwT1QRafALmXFg0hzEteJyHvE0k8KZ1fc13BPQfSyMVJKPy9GMGcl4FJsjSv4xL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 11-08-26 13:32:03, Shakeel Butt wrote:
> Thresholds are the only periodic v1 event left, so the target enum, the
> per-cpu target array and the switch in memcg1_event_ratelimit() all
> collapse to a single counter.
> 
> memcg1_check_events() no longer needs a node id either, which lets
> memcg1_uncharge_batch() drop its nid argument and struct
> uncharge_gather drop the field feeding it.
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
>  mm/memcontrol-v1.c | 43 +++++++++++--------------------------------
>  mm/memcontrol-v1.h |  4 ++--
>  mm/memcontrol.c    |  4 +---
>  3 files changed, 14 insertions(+), 37 deletions(-)
> 
> diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
> index 475f998b7643..bf2c7d53b01b 100644
> --- a/mm/memcontrol-v1.c
> +++ b/mm/memcontrol-v1.c
> @@ -200,15 +200,9 @@ static void mem_cgroup_threshold(struct mem_cgroup *memcg)
>   * to trigger some periodic events. This is straightforward and better
>   * than using jiffies etc. to handle periodic memcg event.
>   */
> -enum mem_cgroup_events_target {
> -	MEM_CGROUP_TARGET_THRESH,
> -	MEM_CGROUP_TARGET_SOFTLIMIT,
> -	MEM_CGROUP_NTARGETS,
> -};
> -
>  struct memcg1_events_percpu {
>  	unsigned long nr_page_events;
> -	unsigned long targets[MEM_CGROUP_NTARGETS];
> +	unsigned long threshold_target;
>  };
>  
>  static void memcg1_charge_statistics(struct mem_cgroup *memcg, int nr_pages)
> @@ -225,43 +219,28 @@ static void memcg1_charge_statistics(struct mem_cgroup *memcg, int nr_pages)
>  }
>  
>  #define THRESHOLDS_EVENTS_TARGET 128
> -#define SOFTLIMIT_EVENTS_TARGET 1024
>  
> -static bool memcg1_event_ratelimit(struct mem_cgroup *memcg,
> -				enum mem_cgroup_events_target target)
> +static bool memcg1_event_ratelimit(struct mem_cgroup *memcg)
>  {
>  	unsigned long val, next;
>  
>  	val = __this_cpu_read(memcg->events_percpu->nr_page_events);
> -	next = __this_cpu_read(memcg->events_percpu->targets[target]);
> +	next = __this_cpu_read(memcg->events_percpu->threshold_target);
>  	/* from time_after() in jiffies.h */
>  	if ((long)(next - val) < 0) {
> -		switch (target) {
> -		case MEM_CGROUP_TARGET_THRESH:
> -			next = val + THRESHOLDS_EVENTS_TARGET;
> -			break;
> -		case MEM_CGROUP_TARGET_SOFTLIMIT:
> -			next = val + SOFTLIMIT_EVENTS_TARGET;
> -			break;
> -		default:
> -			break;
> -		}
> -		__this_cpu_write(memcg->events_percpu->targets[target], next);
> +		__this_cpu_write(memcg->events_percpu->threshold_target,
> +				 val + THRESHOLDS_EVENTS_TARGET);
>  		return true;
>  	}
>  	return false;
>  }
>  
> -/*
> - * Check events in order.
> - *
> - */
> -static void memcg1_check_events(struct mem_cgroup *memcg, int nid)
> +static void memcg1_check_events(struct mem_cgroup *memcg)
>  {
>  	if (IS_ENABLED(CONFIG_PREEMPT_RT))
>  		return;
>  
> -	if (unlikely(memcg1_event_ratelimit(memcg, MEM_CGROUP_TARGET_THRESH)))
> +	if (unlikely(memcg1_event_ratelimit(memcg)))
>  		mem_cgroup_threshold(memcg);
>  }
>  
> @@ -271,7 +250,7 @@ void memcg1_commit_charge(struct folio *folio, struct mem_cgroup *memcg)
>  
>  	local_irq_save(flags);
>  	memcg1_charge_statistics(memcg, folio_nr_pages(folio));
> -	memcg1_check_events(memcg, folio_nid(folio));
> +	memcg1_check_events(memcg);
>  	local_irq_restore(flags);
>  }
>  
> @@ -344,7 +323,7 @@ void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci)
>  	VM_WARN_ON_IRQS_ENABLED();
>  	memcg1_charge_statistics(memcg, -folio_nr_pages(folio));
>  	preempt_enable_nested();
> -	memcg1_check_events(memcg, folio_nid(folio));
> +	memcg1_check_events(memcg);
>  
>  	rcu_read_unlock();
>  	obj_cgroup_put(objcg);
> @@ -398,14 +377,14 @@ void memcg1_swapin(struct folio *folio)
>  #endif
>  
>  void memcg1_uncharge_batch(struct mem_cgroup *memcg, unsigned long pgpgout,
> -			   unsigned long nr_memory, int nid)
> +			   unsigned long nr_memory)
>  {
>  	unsigned long flags;
>  
>  	local_irq_save(flags);
>  	count_memcg_events(memcg, PGPGOUT, pgpgout);
>  	__this_cpu_add(memcg->events_percpu->nr_page_events, nr_memory);
> -	memcg1_check_events(memcg, nid);
> +	memcg1_check_events(memcg);
>  	local_irq_restore(flags);
>  }
>  
> diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
> index f48d0e22e615..b9a21f0fd2c3 100644
> --- a/mm/memcontrol-v1.h
> +++ b/mm/memcontrol-v1.h
> @@ -59,7 +59,7 @@ void memcg1_oom_recover(struct mem_cgroup *memcg);
>  
>  void memcg1_commit_charge(struct folio *folio, struct mem_cgroup *memcg);
>  void memcg1_uncharge_batch(struct mem_cgroup *memcg, unsigned long pgpgout,
> -			   unsigned long nr_memory, int nid);
> +			   unsigned long nr_memory);
>  
>  void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s);
>  void reparent_memcg1_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent);
> @@ -107,7 +107,7 @@ static inline void memcg1_commit_charge(struct folio *folio,
>  
>  static inline void memcg1_uncharge_batch(struct mem_cgroup *memcg,
>  					 unsigned long pgpgout,
> -					 unsigned long nr_memory, int nid) {}
> +					 unsigned long nr_memory) {}
>  
>  static inline void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s) {}
>  
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index ba3ef821553d..44ef376d657b 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5293,7 +5293,6 @@ struct uncharge_gather {
>  	unsigned long nr_memory;
>  	unsigned long pgpgout;
>  	unsigned long nr_kmem;
> -	int nid;
>  };
>  
>  static inline void uncharge_gather_clear(struct uncharge_gather *ug)
> @@ -5316,7 +5315,7 @@ static void uncharge_batch(const struct uncharge_gather *ug)
>  		memcg1_oom_recover(memcg);
>  	}
>  
> -	memcg1_uncharge_batch(memcg, ug->pgpgout, ug->nr_memory, ug->nid);
> +	memcg1_uncharge_batch(memcg, ug->pgpgout, ug->nr_memory);
>  	rcu_read_unlock();
>  
>  	/* drop reference from uncharge_folio */
> @@ -5345,7 +5344,6 @@ static void uncharge_folio(struct folio *folio, struct uncharge_gather *ug)
>  			uncharge_gather_clear(ug);
>  		}
>  		ug->objcg = objcg;
> -		ug->nid = folio_nid(folio);
>  
>  		/* pairs with obj_cgroup_put in uncharge_batch */
>  		obj_cgroup_get(objcg);
> -- 
> 2.53.0-Meta

-- 
Michal Hocko
SUSE Labs

