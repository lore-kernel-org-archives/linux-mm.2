Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92BADCA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 07:50:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDB5D8E0010; Mon,  1 Sep 2025 03:50:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8C538E0003; Mon,  1 Sep 2025 03:50:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA1AB8E0010; Mon,  1 Sep 2025 03:50:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C51088E0003
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 03:50:36 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5D56D1406F3
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 07:50:36 +0000 (UTC)
X-FDA: 83839909272.02.59B1FF5
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf27.hostedemail.com (Postfix) with ESMTP id 851D240009
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 07:50:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=I4SnWZTX;
	spf=pass (imf27.hostedemail.com: domain of rientjes@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756713034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CkNip8h6TggKbPC4j1tIEtRIjWnEKoxCcwgwzmMlJgs=;
	b=jqEMO8Es5EwWPh7yRZCK8v+jSZt5i5n/CTpTjyglTFrwI1oLyCHo34GoCLEdzo2Fcu/xFF
	GoiF4dEtd+DNtbdZO5sJGvET5z0TqTctAoDt7+8t+Ir01t1//hlmzu1om0xAWFw+/8vIVm
	HISLdLND2yQshDCdymxnNsvqpOSk0UE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756713034; a=rsa-sha256;
	cv=none;
	b=xJVOhXD/bkzlNcDvPvkz0dnP4GN3Q9CumEJXWJs2FmY1EUl6LMmcyKL6aZeyMcxSTvQLy7
	UsEfasj341SfMpHdKYkhbyLwlW7QrJM0Ow/Zej6+lB3JLtRKpCPjlGX4r4kwRtd/edkwWO
	1h7u1m8DAAOQtfZIyVNoLSDfT4znI1E=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=I4SnWZTX;
	spf=pass (imf27.hostedemail.com: domain of rientjes@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-24936b6f321so228335ad.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 00:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756713033; x=1757317833; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CkNip8h6TggKbPC4j1tIEtRIjWnEKoxCcwgwzmMlJgs=;
        b=I4SnWZTX+SLHi2hysJ0K3duAGvU3sA69HougMEbQL1gwVhSzX+bLmJCg89qLsL6tan
         doKzrR/lz/8LbFAudCw27Yw+7T8OGoh8f7dFcjqMBcV0s8fpNCjNPpoCmeR7v68Bv6g0
         ytourEYbaDvjACCQ0xDryRQFr6Jab+zp3WEiq9jdYbh52MPi3NYXFZ/tcSIAMzGspnmd
         pno772AYj/dYJ7gciN+Vz/eMJsCDW1hoPREhbzvpMTuEXnRqOFrOp24ILYYVVh1aa+5u
         aL7blazeVPrczAdzHSh6NQcaR5yCJnH4de0cEI5XynLCbNEsljnhl6bajjPXx4NqRRNb
         jMwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756713033; x=1757317833;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CkNip8h6TggKbPC4j1tIEtRIjWnEKoxCcwgwzmMlJgs=;
        b=g13FATRSKJUj7j7Kvvl4GNeLGHmlax4v7TwRdNQIf7RuG0Dq5frxHK6rabOTcpclRG
         NaQRr5l6+VZmp1i1NQesD/0n3NX3WI3ziq+CdBvt52jcap4p3ekqGr9GedpfYTYpdNlD
         JWRWWCWjyWNQDGNCPFmnmADhkYrVkvRlyn6i1qniF3Jso2lWzK+rEJh70Bg2waVmMY22
         eaWmD8a92Hxg6GeB+myhLTfXU9P02NIu7cK3tQBLv4re+ziT+2ainGMUllFVaJmFSDEQ
         WJXe7Ja5owv1+HcJYgXtLNsHmlnl0jdpnM0cwwoW2MLwTPUsk5PClI9dScKI4hesi3oF
         QoVA==
X-Forwarded-Encrypted: i=1; AJvYcCUAS9acfibpDMlbP7+0fEyHKpUlcm4FmEuPOPR/WVrhkMVGZRBH7e3ShCGyVhDSH7SgOkQ95kmYhQ==@kvack.org
X-Gm-Message-State: AOJu0YxitnIJIxXOqr/VoUrL4QR+NHqy6TL/fyFqzXQscOKPpM65KFNM
	3ZP/DO+rqPWefap6ZpZvuD9Bx/4O890noBUFlEOaMvXEL381ys2RwQ4ARCgKPsOIKw==
X-Gm-Gg: ASbGncugLrfmcwH+uF4nhkdsqlFJegV7jdXPGAlqUKZ2bafITIi08pfOWKYF2kDDeJz
	H9HX/uTSxFNCEfDXXcZJTQEbMziNRBl5kxXst5K6FGQvVQGI7xhjJsWLSngVdE8aVz5ZtkDfHzP
	veX/8vk97tfaPTjDf/3WDQtFdB7k2UKab8UJYjwcCgnOJd7A/L4YFegzyKMxc6m1pm2G+wh/A6l
	Um+dCOjhpJ5rGenxcpd5f49IolLfxorr8k8zghZVWtwj5Q2nSr0c9e/JeYSZdpRerVJIzEAihn9
	PiYMYCpYTO33PyM0+MdnbkHPr/OPAgYUU8zstZG3xAbjcUiYge8d6pZnQIM73qq6dAGsZcPbqc9
	tqHhxQGXCf3+Ofh4T8uAK9eKPIvB5zqogoyLT54M/iyFL5KQaT0R59cTzLAf26xl4bjbavR4oRf
	ZcWw1zfhAgqCmFd0tSK2+OcXgLF1OJSV/RlBz3BTE5Pv03kTxBAT3m
X-Google-Smtp-Source: AGHT+IGn9QHXHHFTCaWm9H+w1dJZ0iGEeksBYBpp44VGJjpcufhxypiFwN2ftuqbOtcBBJEaj/QBwg==
X-Received: by 2002:a17:902:ce84:b0:248:f76d:2c67 with SMTP id d9443c01a7336-2493e7b9d86mr4983845ad.4.1756713032826;
        Mon, 01 Sep 2025 00:50:32 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:cfcf:e85f:553:d0bf] ([2a00:79e0:2eb0:8:cfcf:e85f:553:d0bf])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3276fcf0567sm15934209a91.27.2025.09.01.00.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 00:50:31 -0700 (PDT)
Date: Mon, 1 Sep 2025 00:50:29 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: yangshiguang1011@163.com
cc: harry.yoo@oracle.com, vbabka@suse.cz, akpm@linux-foundation.org, 
    cl@gentwo.org, roman.gushchin@linux.dev, glittao@gmail.com, 
    linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
    yangshiguang <yangshiguang@xiaomi.com>, stable@vger.kernel.org
Subject: Re: [PATCH v4] mm: slub: avoid wake up kswapd in set_track_prepare
In-Reply-To: <20250830020946.1767573-1-yangshiguang1011@163.com>
Message-ID: <c8f6933e-f733-4f86-c09d-8028ad862f33@google.com>
References: <20250830020946.1767573-1-yangshiguang1011@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 851D240009
X-Stat-Signature: gdp78nopneb7nzacz4xbjfdjdjd34eeb
X-HE-Tag: 1756713034-865520
X-HE-Meta: U2FsdGVkX1/5ZisXvLM26i2OvGOpZHgXs5O9PArp5T2uUZrLrcqLv6DAZ5rzckYibRvOeZxF5LX480wQ9MEmGVOnsfMT7c8WHiir3KinscrcRixyjteeiE1lXNx4g0pk4FhqF7XW5cYajEx284HxOx48huemr8lQPJNU3mP+onoTpBkQoEUIhTzK1Mjs/SyDTA040MCAHoyJwqxcXicYrig1i3eeWfBqz+BibpT4mRQol8ssURdgDW3Mn4iDcOjV6n8Iht8BSvwNLwPYySmGrqS2KcQXtEAR7FQdJS26pjXyh9xonepk7yZFBvm2ZOcoQKxF5qL0eNjvSSnbjqy8X9RWNyU1kSmzB/bbJs+1vtCaj65PIBur6+NoD04oUi0ZzCHFfFBkLxKrBWRPTedrf5aXxabZdJPHdQEy1tHUoORHv3dTvhHLMDqY30MGdc84wacg8JFDnErHLiRNg5Zifjo2be+QqKpnUYbTMA3p+ntoomzrVOdJLZ+8lEP7T/8EqTgO1kjF/fMn/tGHWY2Y4AuInvIosDmVatSjpIeH5KuOcGG4d39umy6IeQ1G+TeCTkO0y1A8IUFnS6C2YsRl0Rf7ZRRaXyBD0X0mPXT6UY+Q4Mrq1eqvRJXv/SypjW+Kq7YgHj56zoXBcybtG3wDItG2AjvEn/B8DUMCCK9ji0Go44zyDr/REOCOOgWk8EdyPD8jXSF+5mxYuk8SfdhXtbPjeJE+9WMkWl47xBwUUTCsPbyslqammNpQ9Wy/UwmVyZWIzDt32vsjLnMDDmsADMCFM3zIp1MuUyva8PBzQ5GuY4uoIzQjNX9rY07/xH6dr2dV8UbP/V5ZYvUgm2oPaxnzGpwri9ygM44P0eALBb5bWlRQgguQOJEvRImKMydLDG7IsqbipXWCoDxc+NxsAbILd7BWJo70k7VG8CQWn7OQkZLd2lJJX/ltWUKL16l+WJ1J/bXbO/mI3NWhS8w
 aLHGdIAo
 +CLQyevq1wadomXjX7mxfA0wzcFXqlFAbjsGg2mXxstodhCMBl5PTjtzbnZY1iEl+d32ZuKevZ+BYXyr/7oJXJ2Ud9meJnJ6G9EG7Qz2Pr29p52OH/4g0Z02p9pnJ8TnFd8ryZUxXXk6CU/Y4MJHBfXLuGP1CHI6u1J9UChb+Nyhr/UIJkvDDusokEKke/KBYpYVJ7pu9KWOC7M10xWz/zZPDIRwMlvW31e/mlBdH5W0s+JEdWAeIMd/ok0NTzviIyJS7+li8VntKXBb9UIs0NucdMH039iObqx20ePMKOBw1Ox4e5iZ+x1MmXsmXvy59smgO2PpyOKE4dqy3HhdaWd0HPZDaZvkSob8q2a+g8XpuZ7pD/zzqp2WIbtY5movYtcyB5QR5vnADOngf/eKRCqPd3d3XUtWkwHXU6Ov/J9nRNj7iPEBdRs6SwCUaTz8Q6CxatsrGgy1C9Nx40qEmUi3q/nkFOedYrw3wbfA2yaCnnGMWb14p0At5yJyoGnXSgewrRNUrBf+OmlY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 30 Aug 2025, yangshiguang1011@163.com wrote:

> From: yangshiguang <yangshiguang@xiaomi.com>
> 
> From: yangshiguang <yangshiguang@xiaomi.com>
> 

Duplicate lines.

> set_track_prepare() can incur lock recursion.
> The issue is that it is called from hrtimer_start_range_ns
> holding the per_cpu(hrtimer_bases)[n].lock, but when enabled
> CONFIG_DEBUG_OBJECTS_TIMERS, may wake up kswapd in set_track_prepare,
> and try to hold the per_cpu(hrtimer_bases)[n].lock.
> 
> Avoid deadlock caused by implicitly waking up kswapd by
> passing in allocation flags. And the slab caller context has
> preemption disabled, so __GFP_KSWAPD_RECLAIM must not appear in gfp_flags.
> 

This mentions __GFP_KSWAPD_RECLAIM, but the patch actually masks off 
__GFP_DIRECT_RECLAIM which would be a heavierweight operation.  Disabling 
direct reclaim does not necessarily imply that kswapd will be disabled as 
well.

Are you meaning to clear __GFP_RECLAIM in set_track_prepare()?

> The oops looks something like:
> 
> BUG: spinlock recursion on CPU#3, swapper/3/0
>  lock: 0xffffff8a4bf29c80, .magic: dead4ead, .owner: swapper/3/0, .owner_cpu: 3
> Hardware name: Qualcomm Technologies, Inc. Popsicle based on SM8850 (DT)
> Call trace:
> spin_bug+0x0
> _raw_spin_lock_irqsave+0x80
> hrtimer_try_to_cancel+0x94
> task_contending+0x10c
> enqueue_dl_entity+0x2a4
> dl_server_start+0x74
> enqueue_task_fair+0x568
> enqueue_task+0xac
> do_activate_task+0x14c
> ttwu_do_activate+0xcc
> try_to_wake_up+0x6c8
> default_wake_function+0x20
> autoremove_wake_function+0x1c
> __wake_up+0xac
> wakeup_kswapd+0x19c
> wake_all_kswapds+0x78
> __alloc_pages_slowpath+0x1ac
> __alloc_pages_noprof+0x298
> stack_depot_save_flags+0x6b0
> stack_depot_save+0x14
> set_track_prepare+0x5c
> ___slab_alloc+0xccc
> __kmalloc_cache_noprof+0x470
> __set_page_owner+0x2bc
> post_alloc_hook[jt]+0x1b8
> prep_new_page+0x28
> get_page_from_freelist+0x1edc
> __alloc_pages_noprof+0x13c
> alloc_slab_page+0x244
> allocate_slab+0x7c
> ___slab_alloc+0x8e8
> kmem_cache_alloc_noprof+0x450
> debug_objects_fill_pool+0x22c
> debug_object_activate+0x40
> enqueue_hrtimer[jt]+0xdc
> hrtimer_start_range_ns+0x5f8
> ...
> 
> Signed-off-by: yangshiguang <yangshiguang@xiaomi.com>
> Fixes: 5cf909c553e9 ("mm/slub: use stackdepot to save stack trace in objects")
> Cc: stable@vger.kernel.org
> ---
> 
> v1 -> v2:
>     propagate gfp flags to set_track_prepare()
> v2 -> v3:
>     Remove the gfp restriction in set_track_prepare()
> v3 -> v4:
>     Re-describe the comments in set_track_prepare.
> 
> [1]https://lore.kernel.org/all/20250801065121.876793-1-yangshiguang1011@163.com/
> [2]https://lore.kernel.org/all/20250814111641.380629-2-yangshiguang1011@163.com/
> [3]https://lore.kernel.org/all/20250825121737.2535732-1-yangshiguang1011@163.com/
> ---
>  mm/slub.c | 26 ++++++++++++++++----------
>  1 file changed, 16 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 30003763d224..b0af51a5321b 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -962,19 +962,25 @@ static struct track *get_track(struct kmem_cache *s, void *object,
>  }
>  
>  #ifdef CONFIG_STACKDEPOT
> -static noinline depot_stack_handle_t set_track_prepare(void)
> +static noinline depot_stack_handle_t set_track_prepare(gfp_t gfp_flags)
>  {
>  	depot_stack_handle_t handle;
>  	unsigned long entries[TRACK_ADDRS_COUNT];
>  	unsigned int nr_entries;
> +	/*
> +	 * Preemption is disabled in ___slab_alloc() so we need to disallow
> +	 * blocking. The flags are further adjusted by gfp_nested_mask() in
> +	 * stack_depot itself.
> +	 */
> +	gfp_flags &= ~(__GFP_DIRECT_RECLAIM);
>  
>  	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 3);
> -	handle = stack_depot_save(entries, nr_entries, GFP_NOWAIT);
> +	handle = stack_depot_save(entries, nr_entries, gfp_flags);
>  
>  	return handle;
>  }
>  #else
> -static inline depot_stack_handle_t set_track_prepare(void)
> +static inline depot_stack_handle_t set_track_prepare(gfp_t gfp_flags)
>  {
>  	return 0;
>  }
> @@ -996,9 +1002,9 @@ static void set_track_update(struct kmem_cache *s, void *object,
>  }
>  
>  static __always_inline void set_track(struct kmem_cache *s, void *object,
> -				      enum track_item alloc, unsigned long addr)
> +				      enum track_item alloc, unsigned long addr, gfp_t gfp_flags)
>  {
> -	depot_stack_handle_t handle = set_track_prepare();
> +	depot_stack_handle_t handle = set_track_prepare(gfp_flags);
>  
>  	set_track_update(s, object, alloc, addr, handle);
>  }
> @@ -1921,9 +1927,9 @@ static inline bool free_debug_processing(struct kmem_cache *s,
>  static inline void slab_pad_check(struct kmem_cache *s, struct slab *slab) {}
>  static inline int check_object(struct kmem_cache *s, struct slab *slab,
>  			void *object, u8 val) { return 1; }
> -static inline depot_stack_handle_t set_track_prepare(void) { return 0; }
> +static inline depot_stack_handle_t set_track_prepare(gfp_t gfp_flags) { return 0; }
>  static inline void set_track(struct kmem_cache *s, void *object,
> -			     enum track_item alloc, unsigned long addr) {}
> +			     enum track_item alloc, unsigned long addr, gfp_t gfp_flags) {}
>  static inline void add_full(struct kmem_cache *s, struct kmem_cache_node *n,
>  					struct slab *slab) {}
>  static inline void remove_full(struct kmem_cache *s, struct kmem_cache_node *n,
> @@ -3878,7 +3884,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
>  			 * tracking info and return the object.
>  			 */
>  			if (s->flags & SLAB_STORE_USER)
> -				set_track(s, freelist, TRACK_ALLOC, addr);
> +				set_track(s, freelist, TRACK_ALLOC, addr, gfpflags);
>  
>  			return freelist;
>  		}
> @@ -3910,7 +3916,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
>  			goto new_objects;
>  
>  		if (s->flags & SLAB_STORE_USER)
> -			set_track(s, freelist, TRACK_ALLOC, addr);
> +			set_track(s, freelist, TRACK_ALLOC, addr, gfpflags);
>  
>  		return freelist;
>  	}
> @@ -4422,7 +4428,7 @@ static noinline void free_to_partial_list(
>  	depot_stack_handle_t handle = 0;
>  
>  	if (s->flags & SLAB_STORE_USER)
> -		handle = set_track_prepare();
> +		handle = set_track_prepare(__GFP_NOWARN);
>  
>  	spin_lock_irqsave(&n->list_lock, flags);
>  
> -- 
> 2.43.0
> 
> 

