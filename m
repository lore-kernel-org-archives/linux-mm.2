Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CD45C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 16:39:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E2AC6B00BB; Wed, 23 Jul 2025 12:39:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 993216B00BE; Wed, 23 Jul 2025 12:39:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 833ED6B00BB; Wed, 23 Jul 2025 12:39:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 625736B00B1
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 12:39:39 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 17497140181
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 16:39:39 +0000 (UTC)
X-FDA: 83696090478.17.E790EBD
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1A84540010
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 16:39:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mYr3Y9uV;
	spf=pass (imf12.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753288777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iy6jNmLi0JGKHOOGtS88CNydGBMknaXlFXJUCshIh+g=;
	b=AlapAgU5oBmGh+XD+TkuV6jzRdtqXi440/Zs2EKb0/+ErZJOljg6qZi2Pr5gbjpmYFX731
	a0pnox1Tw0pFoxhd9wJ1LRYmsiNYX6b60/6hXk2QNEJjx3Jbs9DUg4Q0jahKAfLsK1Xm32
	K5E9ZDplxgRhQ4FZM1C3ygDyvC/dRaM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mYr3Y9uV;
	spf=pass (imf12.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753288777; a=rsa-sha256;
	cv=none;
	b=syq1fAld1zTRd/IxozvzoNO+8CEv6TwZkAuqp52nQfjjARF0Ol5pcw+77hOJvB4/vOy54b
	DPjm28Foib9yrU8uvAX5GehouHN5SGmdbFp+qlbNAAQROFz74+Ka9jlFXc9OrncksrTI4u
	7OLA3tcSZwV6PohmEBKWPU0vnYbJBxA=
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-55a4e55d3a9so27547e87.1
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753288775; x=1753893575; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iy6jNmLi0JGKHOOGtS88CNydGBMknaXlFXJUCshIh+g=;
        b=mYr3Y9uVcK4OAjHh7FX3YPGeRqE4tPtPVmhqTvpkq4/d5N4R7HNXPrQI7Bo3IKcU6T
         IfradU3aekU/QTPRKXC3GLGDy6Scz8vunrTBsuV559aIuD1kvgWmBezt9u9IgX0/4pCB
         ockPJCbcjXL/p4LRJWJNmYH8L2Ec3yviII2uUg5hqrCKliZJMPAoWwsEjyWDiXEiFUyf
         2lJsKCDi1d2XxLqukmC/uU+T44Jvbs4qKUDOMD8sCWBmDzbtfkVeVI3KRzbMClyKmq0d
         ClKi1deXZB8pmQ1fGbE8PL3h8wRGTiaKAAFJGY8Z89FWTmLaPuiNZKmuzr/YyWF0vXpk
         X2Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753288775; x=1753893575;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iy6jNmLi0JGKHOOGtS88CNydGBMknaXlFXJUCshIh+g=;
        b=ri9fq39POqOpy+e+6kgdcEGZJfJDdaT69Srcy9scIDhk1d07rp5X7DM5J+NDLtRNR3
         1Xzh9/B/bGuF7yhOQDjT+v23XKTOnxDYtHrekpJT0U4ApDoqCnT7Dz8goXVzhBiowoi3
         rGkjDm/VuLmbDCgglOWC2BmpLkIo6qEReklREcAvi5P+AlmhzO+u6fDURVgfJsxiArgx
         sH87vUbn9dPvagYAolOWBdZBcYgzUHbbxy7MHvy1bkDKd+YnRrO+mr214OwJ/MdzIKpt
         5h/pN3OE5ySFqgI5t50LzP8ujhmDjrJVK6z08ZjKKqj9hIijWusJN8mMA3uQfmOPxNey
         UwZA==
X-Forwarded-Encrypted: i=1; AJvYcCUh0RN6fcL1KxGjIFix7DctTJLJdFUSsCA0UoHyvcINVa7nMPUehR4fAn/dgRhDbyTCi4cnSG2FcA==@kvack.org
X-Gm-Message-State: AOJu0YxlAS/4maEkaBtbYrbtrSL0yel5E3mILsB4xjrPq2eXMjvVFiYk
	nVXC4Eq3c+/DUOZORTPw5YujUn8kQ2caBiNLkFcUWZC+d77anY+1wm7D
X-Gm-Gg: ASbGncvTQ01c+SUkPVtePmbkOtdVa+2p/frrFDHjNKFovLsjhDt81f7d3DwPDb0+KBw
	P5myg7Eada/50EDaJfVlDgpkCoMC90yRrOhlDTLpvEbD7rHb+w0TY7FU7p8rdMrt5V2o5hc1t4B
	NyYys+LXhM8w2hBXqshGXqjZK74JcFG+ANTKgmOg4HpMz/E9Pa8Boyb4nsdj6a+9iKL/JQaKAAf
	Qscc08QUbJpVlcM9XDjv9pIsajQboz2B4037ZVCfoslF9anI9eynDjuq+UqZMekQv6u0N0okK0+
	uiwBlvy7qjN6rjA1qcCmH0uOzvvC9tdvPPRV22kC2/PFi01ob9F6y4AvN4SAOu+llfLA74O9Ed6
	xUu6i9wjQBWOIOfdYW8TZjCQFqJ8THUsrjGFRFkfyW58vhYFASw==
X-Google-Smtp-Source: AGHT+IEgFsYIaDXXpqqSqg+UF+6+ocCr6tbdAt8s4+lhPV4mEf+DdO3yWqJnpAxEIZYMblVLFLudNw==
X-Received: by 2002:a05:6512:239c:b0:55a:2735:fe6a with SMTP id 2adb3069b0e04-55a5126993emr1340990e87.0.1753288774791;
        Wed, 23 Jul 2025 09:39:34 -0700 (PDT)
Received: from pc636 (host-95-203-21-188.mobileonline.telia.com. [95.203.21.188])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55a31d9fb6bsm2379029e87.167.2025.07.23.09.39.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jul 2025 09:39:34 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Wed, 23 Jul 2025 18:39:31 +0200
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
	maple-tree@lists.infradead.org
Subject: Re: [PATCH v5 02/14] slab: add sheaf support for batching
 kfree_rcu() operations
Message-ID: <aIEQQ0MW5e8KMvVL@pc636>
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
 <20250723-slub-percpu-caches-v5-2-b792cd830f5d@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250723-slub-percpu-caches-v5-2-b792cd830f5d@suse.cz>
X-Stat-Signature: dw1t56xk8sotsbpqa5cx68fnaga7frsh
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1A84540010
X-Rspam-User: 
X-HE-Tag: 1753288776-840225
X-HE-Meta: U2FsdGVkX19rYZPGiDBdVoypMTowR8vMvOdwMV85Rx8Xm0J3t6RXrTeSwPvBPrFMgHrgTqC2SrsQDaIrUSdxFyTuXqxdQ6IAqgpusd2FMDHBKjCDTsvLf3xCOcj/YJpRgqIWuW9Dwo28dGIIIfMjqIDAuyhrTvU/v7D7R3v1NZQd3N9AlczG1A3Xe784Z5riDwyXa41mAVv828lYK5bT6WwDkK1uWYto8q2z4e193P2/9VLJ3JgWhJ5gsdBR1r6bN+LtEsQCx70gWeTb3g/ayxY6280nBwGi9NhnnrIIheOtrh6BSb7+0dEOLpWi2gzrGiZmBDJrd9OXIadJ9G+9PAzUg+GYkf2DXCZDXtGk3nCYIvFYG9gWeS4edQkVG8+f2uqHCe5nv5rVsMmrLkf7L14pBIQyWEykzuR4QyhCB61eu+5t/DUTd+kKAncZvmtzL+5SNs5L2zbV2VDDCKXXc/bBCDlr9b4wMHy8ABCZOG2o9UavPmKW6HJr6VhmhSkjT0gFx3lEoYJQ9nte82SS2LJcU9mX5VgbBJHwsQeRD5ixHqrpkKoNd0TtChiEx6QokowWCXNRXPnOaCKab+Y9n+l9vZQ94jH20gKb0lYJN7+BBBU8iJpKXhkKSYI7vYeJhxgWMDgfq0ffqLvzkDJsG/Fr50dRCUcdlxHOMoE54LH6SRM4DjxsEDc6Nk9knS4Usni5OKnQdkJdB8Sc9OHacf3wKLKIOJ2jiWMmfagshToQPRumI5dixbADjw2kU+WKxy2gQzEsXw8159q61uwa19kGLwVEODpLVgwJTiS3lGaQ1NyN5U62rdZnx5iyYaYQ4kuTBw/b9wuGxdd/evftrBDlyapaBhFe9BRWvTvrWfedmxmDgKyUeWp053glJtheDK0bIrbI8qoILIa1BBWoYJVXJkuBE/QJzE2Ruuyj1+xZWLvPdwl2JpVV/XmQ9pziwwMWuYBadXbbDijs8xE
 oaaxDwCe
 xCT61wMdo+CM6QdleDZLYtYuhrylTwML5v9zxtRIR2RV4AofKVRUm109R8PVc5jaghtjQtIrpmieQlN0NeUsPMd3yhMrRKVhQ4MOFW9SbCeKh94GO2VV5Sfh1ppeXlkTM8V1/umsgJOrMMPcKH2JLda3j7ffLDMpaVUPhLs7VjPsZ6lf54AFbjjQxElvd8AJiqu3pm1tqLNLQyztKvncISf+sNtHxD5e++7Z1TMgrXVc6gF/ElXy02iAAOsB6ZKQJCvdfjwEF9os4Eo5hEvDOu+P5klRjo/MGHHMdlQzbqdAoaWFsRnL3V5paOsmC3vJ2aZD6R6+d8WhX5M1ILsTgxARDdPAdLxUjGSMliC35PswUoGb1DA10DY2yrSS+XsTdCu7MiEFaUe+ZRGlxh5AFWLL1Dhv6mTupbzwgUIVxgVUfxHZ5KyvZVJnPK1lVHzc/Cq7rP79zWWzZPFFnYPynhLxVvZrjPtpAhYhSU35urtYPWLP0X2rifHP1MZFMMyfHqG4FsSYrfkPzAU98qhLiT42gDw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 03:34:35PM +0200, Vlastimil Babka wrote:
> Extend the sheaf infrastructure for more efficient kfree_rcu() handling.
> For caches with sheaves, on each cpu maintain a rcu_free sheaf in
> addition to main and spare sheaves.
> 
> kfree_rcu() operations will try to put objects on this sheaf. Once full,
> the sheaf is detached and submitted to call_rcu() with a handler that
> will try to put it in the barn, or flush to slab pages using bulk free,
> when the barn is full. Then a new empty sheaf must be obtained to put
> more objects there.
> 
> It's possible that no free sheaves are available to use for a new
> rcu_free sheaf, and the allocation in kfree_rcu() context can only use
> GFP_NOWAIT and thus may fail. In that case, fall back to the existing
> kfree_rcu() implementation.
> 
> Expected advantages:
> - batching the kfree_rcu() operations, that could eventually replace the
>   existing batching
> - sheaves can be reused for allocations via barn instead of being
>   flushed to slabs, which is more efficient
>   - this includes cases where only some cpus are allowed to process rcu
>     callbacks (Android)
> 
> Possible disadvantage:
> - objects might be waiting for more than their grace period (it is
>   determined by the last object freed into the sheaf), increasing memory
>   usage - but the existing batching does that too.
> 
> Only implement this for CONFIG_KVFREE_RCU_BATCHED as the tiny
> implementation favors smaller memory footprint over performance.
> 
> Add CONFIG_SLUB_STATS counters free_rcu_sheaf and free_rcu_sheaf_fail to
> count how many kfree_rcu() used the rcu_free sheaf successfully and how
> many had to fall back to the existing implementation.
> 
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slab.h        |   2 +
>  mm/slab_common.c |  24 +++++++
>  mm/slub.c        | 193 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
>  3 files changed, 214 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/slab.h b/mm/slab.h
> index 1980330c2fcb4a4613a7e4f7efc78b349993fd89..44c9b70eaabbd87c06fb39b79dfb791d515acbde 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -459,6 +459,8 @@ static inline bool is_kmalloc_normal(struct kmem_cache *s)
>  	return !(s->flags & (SLAB_CACHE_DMA|SLAB_ACCOUNT|SLAB_RECLAIM_ACCOUNT));
>  }
>  
> +bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj);
> +
>  #define SLAB_CORE_FLAGS (SLAB_HWCACHE_ALIGN | SLAB_CACHE_DMA | \
>  			 SLAB_CACHE_DMA32 | SLAB_PANIC | \
>  			 SLAB_TYPESAFE_BY_RCU | SLAB_DEBUG_OBJECTS | \
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index e2b197e47866c30acdbd1fee4159f262a751c5a7..2d806e02568532a1000fd3912db6978e945dcfa8 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -1608,6 +1608,27 @@ static void kfree_rcu_work(struct work_struct *work)
>  		kvfree_rcu_list(head);
>  }
>  
> +static bool kfree_rcu_sheaf(void *obj)
> +{
> +	struct kmem_cache *s;
> +	struct folio *folio;
> +	struct slab *slab;
> +
> +	if (is_vmalloc_addr(obj))
> +		return false;
> +
> +	folio = virt_to_folio(obj);
> +	if (unlikely(!folio_test_slab(folio)))
> +		return false;
> +
> +	slab = folio_slab(folio);
> +	s = slab->slab_cache;
> +	if (s->cpu_sheaves)
> +		return __kfree_rcu_sheaf(s, obj);
> +
> +	return false;
> +}
> +
>  static bool
>  need_offload_krc(struct kfree_rcu_cpu *krcp)
>  {
> @@ -1952,6 +1973,9 @@ void kvfree_call_rcu(struct rcu_head *head, void *ptr)
>  	if (!head)
>  		might_sleep();
>  
> +	if (kfree_rcu_sheaf(ptr))
> +		return;
> +
>
I have a question here. kfree_rcu_sheaf(ptr) tries to revert freeing
an object over one more newly introduced path. This patch adds infra
for such purpose whereas we already have a main path over which we
free memory.

Why do not we use existing logic? As i see you can do:

   if (unlikely(!slab_free_hook(s, p[i], init, true))) {
        p[i] = p[--sheaf->size];
        continue;
   }

in the kfree_rcu_work() function where we process all ready to free objects.
I mean, for slab objects we can replace kfree_bulk() and scan all pointers
and free them over slab_free_hook().

Also we do use a pooled API and other improvements to speed up freeing.

Thanks!

--
Uladzislau Rezki

