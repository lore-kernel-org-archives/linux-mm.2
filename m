Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA66FC5AC67
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 08:23:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4F3F6B01F1; Thu, 13 Aug 2026 04:23:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF8A76B01F9; Thu, 13 Aug 2026 04:23:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE6246B01FB; Thu, 13 Aug 2026 04:23:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 95C4D6B01F1
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:23:02 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 36483405F1
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:23:02 +0000 (UTC)
X-FDA: 85095555804.20.B28AA4C
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf26.hostedemail.com (Postfix) with ESMTP id 23302140005
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:22:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=GLtHXKbw;
	spf=pass (imf26.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786609380;
	b=4WUyVGirbYX7V0psDiAg03EgZrRQzYJ/fSa40YbZpPe/ghN6OHfJDoaiouwrSV81aGvrVR
	wP5g/hqRIY28ysD0/ESzp4epiBL+QA9z6AnjsSq7+ZacnWYft5GHjEiUzpKtfxEAHknkWl
	LbRFw5b4B294MSbKTG8PAZDqt56m5Gg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=GLtHXKbw;
	spf=pass (imf26.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786609380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ADGYe9gSWNwrnz5xQxNpg6LlRco8vJEKHwyfHThFbis=;
	b=X6qL0ZwmshTLk+0lJOrZ32q4ulo53UccfpZa7SES37GXoR0ZgHtSdfjP+9KG+pEYWvgaJ+
	5bUptyDZvL/LrIXEfgDi//0cXqLOCC7sYFctXdcPZE0NRd1snETXJLc7dwTe3PbE2GcOeA
	tRNtotdKsHJuv0d9tDRGw7Qakzfa5Ko=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-49558ce01afso14397835e9.1
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 01:22:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786609379; x=1787214179; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ADGYe9gSWNwrnz5xQxNpg6LlRco8vJEKHwyfHThFbis=;
        b=GLtHXKbwC/BdlXVSz5QTyLecflSoFx4zHTyzfKm1uKdef2bSN+N6UfCD0QTt1AGaKY
         sTWqY3cPbfpdh2oPNXWltjh2S4lgK1VWWTVoADLlMh67im55nd5iOfyhsutL1M8Ek3mB
         lDluF18Ehw/FBuWrfpM5VPSnS7+KUPobcRIqcaHpy9ZqPG3wwdI5gfPg9oxhsOOlhXZp
         zEyxgBYgeSIBmS/nz/nIqQweR7EMJA9Bxm1FurNaIN5YXAPXXD5obIV62JLNf79GqQE6
         4zBWOQB3Cu3+HL9R1JLNR97jYn68Rpd9QWALVgJT/rCkpanLSwc0TZc4rMzYc8wgdz0U
         rYjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786609379; x=1787214179;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ADGYe9gSWNwrnz5xQxNpg6LlRco8vJEKHwyfHThFbis=;
        b=c2hB2clReDh0gfHIDuaGVY7LqKZlxc+MQAIqOBWMBwtD4PHjHob3N7n8DJ4gNlVmCO
         3IAY1Btjf1wrHdZHV1JcxrbPpyqDGRXeQpcAn1ju3GgdV+mGyS0oHVNwnsHIc/rpScTp
         aNlTg3AAL+p7h6gNShqKNvqiOUveRfNu0wAFjzHQhmOAYrofUa3dxIdKfCxzrjR9AH9d
         tGLE6n5oKg6C3MZJpO80EE8F/Piypcx8Frk1k8w/C23fHUYbZMHmfTj3vwTRP+OW6oot
         mPTw1F4r0rRG2Vi+rXY48YEJJ1x753XXA2gdEeEAMBSo8revyUOL/QC9+4ls/3rOk3Yk
         uI1Q==
X-Forwarded-Encrypted: i=1; AHgh+Rq7NBchi3t2HgDC8hr6u172JTaxz2JdM6nr7lm3DHNGvth2q57C1jxTHLQCcXIh1/Agj7etUB5jxw==@kvack.org
X-Gm-Message-State: AOJu0Yx9q8bJaTChSSh9DboZjbUgZsNIFcMetGr1GLCwvAy4q9vUVVAg
	KzFUrAf7PBrH9hpNfJ1JvZYx3EnLoUQx/n4v24uAdcsSt2/ttPzJs52Aw6IDewFjGYE=
X-Gm-Gg: AR+sD11TkUeyQH1P3wWDyHWslXeialyaBMBvg5ViYGzyseuUnTiRBWS7xKHxoWVuxsi
	CJgddTPDA/pUuKokPx8NkiNS5KTvw11zoz63S4O2ig7O5mb1149fQmf1Uz+8RYTRedIL1Iwe4EW
	VwA/3dDYvhCF3US32ICALrI1SIysriGU6l8MlYiC8reqcqg0ebo66x+IcBOJ406BtPYCN7c0YsZ
	QW5D77dLVkGxJ8yVxI5T7lVe16yfeZPrmMG0+zabsIIoZLh022rWkwf+DShdJIz/9eR29VvV6os
	/DvxyTQb8P2tedojb5iP/4Dwdtk92G8YvD8ocIU4+wq+thpG6Rk8Nu2QzXPIEYVcdrRLNDl6t5u
	kuIJ4QMSxyAmrrmHvCVAD1ZRn17QIETue8kQHa7uPY2K8e7dlcd+4g0m+vKRrCCRR8Cp0KPPeN5
	OFc8fx5Dqu8yldFBEWKHdgyCb12fcxAfAxJawQZp96ZnmS0JQ6EP8/N0OsVD8Mr2tzZErOgG4=
X-Received: by 2002:a05:600c:4fc5:b0:499:7f38:d77 with SMTP id 5b1f17b1804b1-49982183d4amr40750515e9.6.1786609378615;
        Thu, 13 Aug 2026 01:22:58 -0700 (PDT)
Received: from localhost (109-81-29-60.rct.o2.cz. [109.81.29.60])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49981de6a05sm70856685e9.1.2026.08.13.01.22.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 01:22:58 -0700 (PDT)
Date: Thu, 13 Aug 2026 10:22:57 +0200
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
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzbot+12ee2725d5fde63a9c96@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/9] memcg: make the v1 soft limit knob inert
Message-ID: <an1-4Rgwlsfd9Hjt@tiehlicka>
References: <20260811203203.3456029-1-shakeel.butt@linux.dev>
 <20260811203203.3456029-2-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811203203.3456029-2-shakeel.butt@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 23302140005
X-Stat-Signature: b8j5ph1tpu1bef87bxy3xwoecskjbfqs
X-HE-Tag: 1786609379-974798
X-HE-Meta: U2FsdGVkX1+yrbufXWoekBb7Av4AEhWMm2giluOrtuDiBZerZrwCp3jCkL73KaTh8RBD1ukFc2CPAplhBrbXqoUTuKyuCYp8PlFHTFavcdud2nmusgb6nAoUEtb+cwSanSifCwCi8MF7X+877B3cIsSrQJgnwEnQS4DixxTi1YqBaNm1nyCeyDvLaRMf8trUW07nrC6I9QpOkOu0sjQBjEmHPI5ZvgmMS6ME2jyEnFye9vl8v6sETAoIGCyJveSmgoRPymAgIAXvbx5il9c5S0FKLkUBA1QKEPRlP68v8vZpy4zlcAlBO2psXdBQx5EC/hzz9wPL30TEGUbwEwsbpXvT/9qWlWijb7E7CmMvN/o6ZVrdiTUTR9kNauH4clH5owDmTgI9OW4uhsNfCQoM/AsI7VQwoehtXWa1NhL1k447vcW7MHZ6Hfds+xdeTfiWfHe0mRoi6PEaTdaIbVDn+k7PsnspaxDoR7/hyGVDvJuDY9/FmSYHic7LAqu4yxkOQWIE2Q2kAlVj7ZMC9rc9hk8c08oieD6mLPYiKh6AymBpwr2KsbSz5GnFo8Gnfe/vRR3ANRZ6R/ZM3g3AZqA62nwJcFs1FvcESDaUQxfbcxZMqMfef7eYEbQAXaEyPDqJOqlpauI0HmdX3sAvQuOgdxNe8COEvsYXLqOuOlNbKR97qdxUY7EWS5Cz6GTpTK2JrQydp1KOPzbBux/ygExrZjY1CKTC+7wl3gkfWQSRuL1lUK0znqhMeM8nWSNLsxQxChdT6qnKITVZYrVsGzdlrq10JaykLn3pU0j/FE8+QRRdpFjfDa02uEr8cs2XjCmSHb5wyaN/RknAda0oEJL4ULdik5shyAMcDNJyyf+qxasrN3lH+b3gPj4jpVBngKLwRaAtqzbxOt/wJ2D26htGKhrle4vp4B7ElNw+EshVXPUHxT2keM3P1IflHNB85yF1V3GT3VjYcyPz0gFHM4m
 YslHH3HS
 IdZQ9IKThD4TKeobH5VGyhbP+EFnMuui1dybVzlUkqWcHfEgMoOkGA1EU3tjZklNN1nav1HUi2KnilxXUtv2yHQOCjXCHk9hzeqwC2/dYP/J7ge9C4bX6FhYC9T+d+UnfLf3YfcTMCLZ09990Aa3/Dba5cozD4XTv+5N8dzENfRk5h4zYVRYx/HbdRumbrtw6YVDifQW16pfwq1rIO7JyU9FWI9aet3viPtUWooklvo5mmav2aI86ed+O9nh5oQra0fEyB/e9/dz+RhdQRSaJDRqn520lMMdkaginqyHTkd/PMEmi1/4vRfaGuG2PAXUv6L/5VxCNvNrwonVeOsl+Gp+Ywf++Wm+QrXVvJs1C1RxO9/AXOAXYDb0WgBVUZIt2S6cyyYRN7zl+DDFULWep1whvFobvvM8H0PJfCqbzHDt1DAHINbE6bM8tk4kslNrvwKVXi//sG3e/wkmOQV99d7lpJHoiOz45mnYlE9vN5oERXssfpQLxzfrDtVTzraMGn/C/jUDNDLEqz2pPaIAReLLXqg3K5D6YQWj3hgryAL5oL3e0FHqnZC3loZ8bbBcgKbS8CPL06FhH9LJQtaP85DXEaPFLEj5rOq3h7884yj7aWXcbeYY7Ak0QhoFhc0O67H2t6n9qcvQiE+Sx5jsLpjQMmLbE24vGoWO/5sfbwu0s9neO6q09NqABSknboTapLeHRtwKZkdItnY1cpa4RYMsljQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 11-08-26 13:31:55, Shakeel Butt wrote:
> The v1 soft limit has been deprecated since v6.12 and nobody has
> reported depending on it. Start the removal by decoupling the interface
> from the implementation: keep memory.soft_limit_in_bytes, but ignore
> writes to it and always report the maximum value on read similar to
> what memory.kmem.limit_in_bytes already does.
> 
> Writes are still parsed, so malformed input keeps returning -EINVAL.
> The knob now also behaves the same everywhere: it used to return
> -EOPNOTSUPP on PREEMPT_RT, where soft limit reclaim has always been
> disabled.

Is there any specific reason to not return EOPNOTSUPP for everybody now?

> This also fixes the syzbot report linked below. Soft limit reclaim is
> the only caller that runs shrink_lruvec() from kswapd against a
> specific memcg, so it is the only way to reach lru_gen_shrink_lruvec()
> and in turn set_mm_walk(), which warns when called from kswapd.
> 
> Reported-by: syzbot+12ee2725d5fde63a9c96@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/6a7a6929.b50370da.49fe0.005e.GAE@google.com/
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Anyway
Acked-by: Michal Hocko <mhocko@suse.com>

> ---
>  .../admin-guide/cgroup-v1/memory.rst          | 49 +++----------------
>  mm/memcontrol-v1.c                            | 43 +++++++++-------
>  2 files changed, 32 insertions(+), 60 deletions(-)
> 
> diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentation/admin-guide/cgroup-v1/memory.rst
> index 7db63c002922..7d2a44af52c9 100644
> --- a/Documentation/admin-guide/cgroup-v1/memory.rst
> +++ b/Documentation/admin-guide/cgroup-v1/memory.rst
> @@ -47,7 +47,6 @@ Features:
>   - pages are linked to per-memcg LRU exclusively, and there is no global LRU.
>   - optionally, memory+swap usage can be accounted and limited.
>   - hierarchical accounting
> - - soft limit
>   - moving (recharging) account at moving a task is selectable.
>   - usage threshold notifier
>   - memory pressure notifier
> @@ -76,10 +75,9 @@ Brief summary of control files.
>   memory.memsw.failcnt		     show the number of memory+Swap hits limits
>   memory.max_usage_in_bytes	     show max memory usage recorded
>   memory.memsw.max_usage_in_bytes     show max memory+Swap usage recorded
> - memory.soft_limit_in_bytes	     set/show soft limit of memory usage
> -				     This knob is not available on CONFIG_PREEMPT_RT systems.
> -                                     This knob is deprecated and shouldn't be
> -                                     used.
> + memory.soft_limit_in_bytes	     This knob is deprecated and has no effect.
> +                                     Writes are ignored and reads always
> +                                     return the maximum value.
>   memory.stat			     show various statistics
>   memory.use_hierarchy		     set/show hierarchical account enabled
>                                       This knob is deprecated and shouldn't be
> @@ -340,9 +338,6 @@ memory.kmem.usage_in_bytes, or in a separate counter when it makes sense.
>  The main "kmem" counter is fed into the main counter, so kmem charges will
>  also be visible from the user counter.
>  
> -Currently no soft limit is implemented for kernel memory. It is future work
> -to trigger slab reclaim when those limits are reached.
> -
>  2.7.1 Current Kernel Memory resources accounted
>  -----------------------------------------------
>  
> @@ -710,42 +705,10 @@ For compatibility reasons writing 1 to memory.use_hierarchy will always pass::
>  
>  THIS IS DEPRECATED!
>  
> -Soft limits allow for greater sharing of memory. The idea behind soft limits
> -is to allow control groups to use as much of the memory as needed, provided
> -
> -a. There is no memory contention
> -b. They do not exceed their hard limit
> -
> -When the system detects memory contention or low memory, control groups
> -are pushed back to their soft limits. If the soft limit of each control
> -group is very high, they are pushed back as much as possible to make
> -sure that one control group does not starve the others of memory.
> -
> -Please note that soft limits is a best-effort feature; it comes with
> -no guarantees, but it does its best to make sure that when memory is
> -heavily contended for, memory is allocated based on the soft limit
> -hints/setup. Currently soft limit based reclaim is set up such that
> -it gets invoked from balance_pgdat (kswapd).
> -
> -7.1 Interface
> --------------
> -
> -Soft limits can be setup by using the following commands (in this example we
> -assume a soft limit of 256 MiB)::
> -
> -	# echo 256M > memory.soft_limit_in_bytes
> -
> -If we want to change this to 1G, we can at any time use::
> +Writing to memory.soft_limit_in_bytes has no effect and reading it will
> +always return the maximum value.
>  
> -	# echo 1G > memory.soft_limit_in_bytes
> -
> -.. note::
> -       Soft limits take effect over a long period of time, since they involve
> -       reclaiming memory for balancing between memory cgroups
> -
> -.. note::
> -       It is recommended to set the soft limit always below the hard limit,
> -       otherwise the hard limit will take precedence.
> +Use memory.low and memory.min in cgroup v2 instead.
>  
>  .. _cgroup-v1-memory-move-charges:
>  
> diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
> index 835fc8e51184..05ef55cae4dc 100644
> --- a/mm/memcontrol-v1.c
> +++ b/mm/memcontrol-v1.c
> @@ -96,7 +96,6 @@ enum {
>  	RES_LIMIT,
>  	RES_MAX_USAGE,
>  	RES_FAILCNT,
> -	RES_SOFT_LIMIT,
>  };
>  
>  #ifdef CONFIG_LOCKDEP
> @@ -1888,6 +1887,30 @@ static int mem_cgroup_hierarchy_write(struct cgroup_subsys_state *css,
>  	return -EINVAL;
>  }
>  
> +static u64 mem_cgroup_soft_limit_read(struct cgroup_subsys_state *css,
> +				      struct cftype *cft)
> +{
> +	return (u64)PAGE_COUNTER_MAX * PAGE_SIZE;
> +}
> +
> +static ssize_t mem_cgroup_soft_limit_write(struct kernfs_open_file *of,
> +					   char *buf, size_t nbytes, loff_t off)
> +{
> +	unsigned long nr_pages;
> +	int ret;
> +
> +	ret = page_counter_memparse(strstrip(buf), "-1", &nr_pages);
> +	if (ret)
> +		return ret;
> +
> +	pr_warn_once("soft_limit_in_bytes is deprecated and will be removed. "
> +		     "Writing any value to this file has no effect. "
> +		     "Please report your usecase to linux-mm@kvack.org if you "
> +		     "depend on this functionality.\n");
> +
> +	return nbytes;
> +}
> +
>  static u64 mem_cgroup_read_u64(struct cgroup_subsys_state *css,
>  			       struct cftype *cft)
>  {
> @@ -1924,8 +1947,6 @@ static u64 mem_cgroup_read_u64(struct cgroup_subsys_state *css,
>  		return (u64)counter->watermark * PAGE_SIZE;
>  	case RES_FAILCNT:
>  		return counter->failcnt;
> -	case RES_SOFT_LIMIT:
> -		return (u64)READ_ONCE(memcg->soft_limit) * PAGE_SIZE;
>  	default:
>  		BUG();
>  	}
> @@ -2020,17 +2041,6 @@ static ssize_t mem_cgroup_write(struct kernfs_open_file *of,
>  			break;
>  		}
>  		break;
> -	case RES_SOFT_LIMIT:
> -		if (IS_ENABLED(CONFIG_PREEMPT_RT)) {
> -			ret = -EOPNOTSUPP;
> -		} else {
> -			pr_warn_once("soft_limit_in_bytes is deprecated and will be removed. "
> -				     "Please report your usecase to linux-mm@kvack.org if you "
> -				     "depend on this functionality.\n");
> -			WRITE_ONCE(memcg->soft_limit, nr_pages);
> -			ret = 0;
> -		}
> -		break;
>  	}
>  	return ret ?: nbytes;
>  }
> @@ -2384,9 +2394,8 @@ struct cftype mem_cgroup_legacy_files[] = {
>  	},
>  	{
>  		.name = "soft_limit_in_bytes",
> -		.private = MEMFILE_PRIVATE(_MEM, RES_SOFT_LIMIT),
> -		.write = mem_cgroup_write,
> -		.read_u64 = mem_cgroup_read_u64,
> +		.write = mem_cgroup_soft_limit_write,
> +		.read_u64 = mem_cgroup_soft_limit_read,
>  	},
>  	{
>  		.name = "failcnt",
> -- 
> 2.53.0-Meta

-- 
Michal Hocko
SUSE Labs

