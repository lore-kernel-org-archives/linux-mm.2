Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63969CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 08:49:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DCE78E0008; Mon, 10 Nov 2025 03:49:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B4918E0002; Mon, 10 Nov 2025 03:49:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F14E8E0008; Mon, 10 Nov 2025 03:49:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7F8128E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 03:49:05 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1A7D44BDC0
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:49:05 +0000 (UTC)
X-FDA: 84094072650.07.424FBB0
Received: from mail-ej1-f67.google.com (mail-ej1-f67.google.com [209.85.218.67])
	by imf19.hostedemail.com (Postfix) with ESMTP id E3C561A0005
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:49:02 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=MqR7zQvs;
	spf=pass (imf19.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.67 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762764543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MYB3eNFBCkjH9q1uLbtzcXRkRk6p1kh+Sygy8eTu3sY=;
	b=KShaXauD1HkT+e05nQndnYS2P/b2INC+yOb03G1iWe3oixtkEY3M/iB7H9CPxztK0+mDmr
	jclgc22JAvo37FG8iYVpICoxA7IA2PIn2yXLLaOL814UiLaAtt/bBoWMu4bYh2yEvABZmx
	eiZNi8oqPmcX78S8SH4Sl94xOiO1tMo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=MqR7zQvs;
	spf=pass (imf19.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.67 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762764543; a=rsa-sha256;
	cv=none;
	b=tdQaKMgfcfzX8bbbgbeE6hFCcNLkteuQF3TVNLVa4BSMMJuqfmdPfZ9Jmc7XqwcDlO8fap
	rM7LjlNjetdTzv2xnnyGn1sRzOzoAcw2ZniRceD5Rbxio6bp+LJYlk80KCNvzoWOmrk9Xv
	e93ImxkXQBYvC8oFPZkk/wGzqC3QbUA=
Received: by mail-ej1-f67.google.com with SMTP id a640c23a62f3a-b64cdbb949cso480065366b.1
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 00:49:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762764541; x=1763369341; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MYB3eNFBCkjH9q1uLbtzcXRkRk6p1kh+Sygy8eTu3sY=;
        b=MqR7zQvsw2GHj7cHJAEuLk/4c7bWhkBTZtvk5/ft14525Vpb5RGehO/UWe8t/rDjRf
         hZ7QMN0r2F7MrzH7j1mDD0gpuKivLSRadUAtQae/UqIixv21vVl0/uIoTELZfJpNUPvi
         +G6t2lkpZSymY51DmDIsrWt9b1msIGyzYiZi843h+rTpeETwcS5djmAnbz2AYBYzzg32
         GWhe1AlMIN7iH5vTAt2i5lksNmahXmupDbfGUvbHO87sxzW/CR0BmfuRfSHuJvI3L1fU
         kYKK+2I5OKS8QAqiBCD8CQKKcJA1xx7t9c1hkYIy3nj40Ain2WBZyEenE/sytTh09XyA
         gbPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762764541; x=1763369341;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MYB3eNFBCkjH9q1uLbtzcXRkRk6p1kh+Sygy8eTu3sY=;
        b=M+U74qL2cWxEpJPOAJgo4fyqVc9Aw8KILdWoHPiLnNVxjReI12tJFuDrkxsQKjoejE
         X/pJQrVTlrbftMjfBby7IrZgE60J8siDZ30UL41u3ffy3SMt8oYNmZJ4PyBNlMK4vNL3
         5ya/3muj8LWkb3CatPwv84ckwrGBQ7djiXhyfJ44kO3qduMK0XZuD9rwKL5Z8VHjD4f+
         +pJ41+AtA+nvHGgGgiKdu2uZWKNGuJJTiSO/ElvBYfG+PWsPMdbeEdcI59pn//xlEC9v
         qze5od6zo41vev792c3XfsbXKOpNr9nE+Dugvgg4VKU8R23uXBBg4YPoB6g73grg+Prk
         q4ow==
X-Forwarded-Encrypted: i=1; AJvYcCVT9ydxkzQg+DwSYeivf6V9jldQ10G8hY4v+F6aZkC3rmpuT+sKHQEyBvg7DyOIGfUDs3SpmYypaA==@kvack.org
X-Gm-Message-State: AOJu0YzTEO+Jn91tdmjYLmIgjmXmAN36g5oEbWXuo4MgwP0/fPeG0kdz
	5yrgkID0I/TpAcCqRxuDHltkh4va1fiDavL3OzBFRr2WT8UB1nbKQKi8MiWRBlZTXhc=
X-Gm-Gg: ASbGncs7fGpgf80CdCibAvBCudgBIdD+3epQpuZjWs94sSPd8xSjtE6ZulNvfOnSleI
	8A3Md1L7zHxgtw0Fk6nFoxaptYjGA1nkrfdq2ZJL+cnOvHqxe0beAMXP1k+xoC+qwrIuf/tTAeT
	mZAE+WwF1Uu1bJ8hqZ+sv5jW6sjcWxcf/+nUqrRzTTcQ/zxYtrmbiboRG6UtmyoUeneMWKO5ECT
	hbYY6twlde2rRcn+PSJF12LwUzjzY44oWgUeZaIruO1vZR8nYE6WvCP6nuA2QgUyh52hN6hil+Q
	hbhwPJg3ryWFXZf7szWVd1TA6SFnmaAzZVXf8MYgTGFzlnunyLMvdGaGF3z1B7yaYiInGSGlJ4a
	pm9rqP1PntgTcBRdZXP5GfwGUz1Dbaf1Cdal7VFAyAYe93a2eo/up9HKcXEYemQtrR+/aAXzBF5
	ZLrm0iDX3NSsiOWJI2bus3j7tA
X-Google-Smtp-Source: AGHT+IHkCcGZffVbGb8qG3xm/rRfqIb/GgVIQQoNThnr6QrJwoyhjqnbS9/gl3lEpfFn0E7hIkOGtw==
X-Received: by 2002:a17:907:9807:b0:b6d:2b14:4aa4 with SMTP id a640c23a62f3a-b72e05ac909mr660427666b.63.1762764541165;
        Mon, 10 Nov 2025 00:49:01 -0800 (PST)
Received: from localhost (109-81-31-109.rct.o2.cz. [109.81.31.109])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b72bf9be184sm1016802566b.56.2025.11.10.00.49.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 00:49:00 -0800 (PST)
Date: Mon, 10 Nov 2025 09:48:59 +0100
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Rientjes <rientjes@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH] mm: memcg: dump memcg protection info on oom or alloc
 failures
Message-ID: <aRGm-yJwkHIlF07I@tiehlicka>
References: <20251107234041.3632644-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251107234041.3632644-1-shakeel.butt@linux.dev>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E3C561A0005
X-Stat-Signature: 8d6h654xrxuo47ku9cz97a3bxg4do3ks
X-Rspam-User: 
X-HE-Tag: 1762764542-451932
X-HE-Meta: U2FsdGVkX1+wkWlgkgZeXFI8MhOXbPmwcKosZrbFgKam0vhKctBDJ2pOlI3jPSq4X43LhiNIeW8+hFBTQ8PTQQI9Iy0LdBH+ynmHdyZp1gA3Pho3+C0VBnv6mIghy6oOFmMqOS8vNA0fzPwP7xT1c3v05nAuzKxNhuJWuRn/stnL64vv5K4atIe7WTxQvTXJT2eyv9fgdRoJCgJgDOcdScQ29B5ahOrDSNK8FM4lbFs1aHnZ6Zjku/P4Y3HQGg9l925cZ1+cBdFjbTlX6QM1xkGh07ybLlu1FLmL2dfQTYgeI4OS94OwOuyUiLeuBJCdjzhX8DDueE7xd4wkMMGvOnrGEHdOVm2mi/MiQ/nYSYivC/VsJdki3ThwigaS00F0zRGJfmu/C+V7LZwh/+18Mkabl5fQ2Yv68OqX+JrM7V2T0PPI82Uoa98CGfn8YIfexEF5iNmox7Xppn3/7a15FWSsRJNWLRC72fXGvApZlwaY+YXHBihxIYvwcwDIVaKR0EJl1W1XxecKFEO6ARjsYNf08lP6j8qdTv6esxQ8ap/280rUnvm5stkWAeEwX3JXLxmyzmgo3DL9sFD27g1JGDKp+YgqAg5EL2zkZQj1c3A8U4kjZrwSFwTFlAB2ypQpeh/dmiz8TtWNn8WteeieU4It7skb2GzXD8AgDRE0rnY9Sy3DWTBJXVZa4Jixzvf1g18WB9We0hC2IouVjNMnCOAxegL/DjX8DVH71BIkYVmc7JlP/uOaoCsDNqKfJpwBSXRQwJv8gfm5lL8Ps0HrqlOVmG3QleQeIl/pnn7qCRGxJz8OSL0wUrV8jZEyl/oL04Kry9VNsFqO0qMsiEN0MN5V75uzJeXp92zKwhTkENlPhOiPM57kdMkog2jTRUmNquGAiNtxZ1MgIHPb2jh6UlIhFt5m3lF8uzmjvvbGOH+zcETuOCXs1Tu/rNTYpta4RMjU1IBJthAW0ResoRH
 nZW6YWKH
 VaHGCjdBqgqSmTSF67EYT/sLhlzCD/QCtYHb7yjU1KacAoJY6l1NDAMsuStSUtksoQAbyIdBhYEeWhAdtAFb+ykX1EndFWu0hCFXTUpfyxvqAnuvBMR2oTA3OWwpynf9DvOCHPkyq07AJvMmcpCPfDZ7N4z4j/gzOXKNZtbUmjTotePLAXIWwQ6tYFYECvUDSQBwNfW5SvOT0foZeq5jAXZ9j1pthQjdEGKTYrxJif2/MJ0lINmBC7JU4DaEqXb/wHuFO8Mo8rzegN3G7LHu2aH/Io+tQjkFVsAbQ6ZfuM/FtOgIoPm8KvNQrA6arLTqTWW02MBGRKnyUSOlYbatopBVaR2gglvhrOcP8kSPl1eTlK865w88/UGrDSSI52LmDH9W/pv5O6mZgCl4A6rYzIw+5/oXsDYn+tFajnsFLx+C8uHbo5vb0Hs7FmeGCUv3hJRBWPJToKFv+8/F+FTv+pSghxdyCr1LoH+v1inNQB0EprkXOgeIq2w8pOA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 07-11-25 15:40:41, Shakeel Butt wrote:
> Currently kernel dumps memory state on oom and allocation failures. One
> of the question usually raised on those dumps is why the kernel has not
> reclaimed the reclaimable memory instead of triggering oom. One
> potential reason is the usage of memory protection provided by memcg.
> So, let's also dump the memory protected by the memcg in such reports to
> ease the debugging.

Makes sense to me.

> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
>  include/linux/memcontrol.h |  5 +++++
>  mm/memcontrol.c            | 13 +++++++++++++
>  mm/oom_kill.c              |  1 +
>  mm/page_alloc.c            |  1 +
>  4 files changed, 20 insertions(+)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 8d2e250535a8..6861f0ff02b5 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -1779,6 +1779,7 @@ static inline bool memcg_is_dying(struct mem_cgroup *memcg)
>  	return memcg ? css_is_dying(&memcg->css) : false;
>  }
>  
> +void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg);
>  #else
>  static inline bool mem_cgroup_kmem_disabled(void)
>  {
> @@ -1850,6 +1851,10 @@ static inline bool memcg_is_dying(struct mem_cgroup *memcg)
>  {
>  	return false;
>  }
> +
> +static inline void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg)
> +{
> +}
>  #endif /* CONFIG_MEMCG */
>  
>  #if defined(CONFIG_MEMCG) && defined(CONFIG_ZSWAP)
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index c34029e92bab..623446821b00 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5636,3 +5636,16 @@ bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid)
>  {
>  	return memcg ? cpuset_node_allowed(memcg->css.cgroup, nid) : true;
>  }
> +
> +void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg)
> +{
> +	if (mem_cgroup_disabled() || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
> +		return;
> +
> +	if (!memcg)
> +		memcg = root_mem_cgroup;
> +
> +	pr_warn("Memory cgroup min protection %lukB -- low protection %lukB",
> +		K(atomic_long_read(&memcg->memory.children_min_usage)*PAGE_SIZE),
> +		K(atomic_long_read(&memcg->memory.children_low_usage)*PAGE_SIZE));
> +}
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index c145b0feecc1..5eb11fbba704 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -472,6 +472,7 @@ static void dump_header(struct oom_control *oc)
>  		if (should_dump_unreclaim_slab())
>  			dump_unreclaimable_slab();
>  	}
> +	mem_cgroup_show_protected_memory(oc->memcg);
>  	if (sysctl_oom_dump_tasks)
>  		dump_tasks(oc);
>  }
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index e4efda1158b2..26be5734253f 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3977,6 +3977,7 @@ static void warn_alloc_show_mem(gfp_t gfp_mask, nodemask_t *nodemask)
>  		filter &= ~SHOW_MEM_FILTER_NODES;
>  
>  	__show_mem(filter, nodemask, gfp_zone(gfp_mask));
> +	mem_cgroup_show_protected_memory(NULL);
>  }
>  
>  void warn_alloc(gfp_t gfp_mask, nodemask_t *nodemask, const char *fmt, ...)
> -- 
> 2.47.3

-- 
Michal Hocko
SUSE Labs

