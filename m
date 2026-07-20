Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 871F8C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 20:39:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56B4D6B00BD; Mon, 20 Jul 2026 16:39:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51BC06B00BF; Mon, 20 Jul 2026 16:39:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 409D36B00C0; Mon, 20 Jul 2026 16:39:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0FB6C6B00BD
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 16:39:11 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 96B151602F9
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 20:39:10 +0000 (UTC)
X-FDA: 85010319660.12.D3676CA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id DE2974000A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 20:39:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="D6TlA/dC";
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784579948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mg5iXUvgOcpHtJjakeR8eQ/Gu2h/VJqFWFpqvTe/RYc=;
	b=CeIRTApWgu7v703LlQHMmxvDvfuzSBt+COunrpALUHlHjeL8oD/2divQDwzCAgWm+eyidg
	12FRgA267F7qjPUaPpB+5kPPb/rhMziZj30xA/anmEi23MV2MT0BoC1QlqFmU9kHQkbY6U
	RAGX6MfMCG6Jhax6kyOO586LdfGtYGI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784579948;
	b=bSE2tfzL/okl7KPpc3/ieBqcWQ6uYcPDdeb2shE81/ztIWESxQJ2pWCyEeDEyeJjVVnCgG
	VO7F2IUYXzzDqdOsVpuTnqgdg1DWMZlX0NwHSGsIxHLWQrvOL73w6axVAnf8F4i1s/jvm5
	swZBTa0RIb+huAowNWB2/Ok/iE5xdrM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="D6TlA/dC";
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2885E60A7A;
	Mon, 20 Jul 2026 20:39:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E8491F000E9;
	Mon, 20 Jul 2026 20:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784579947;
	bh=mg5iXUvgOcpHtJjakeR8eQ/Gu2h/VJqFWFpqvTe/RYc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=D6TlA/dC/7ffmyD5i48P0Qkq1eu/nEwWvhrYfF/MO3udrUcJiWVSXuFzDt8V1UFPF
	 7DJUFsHU+7hH5DzG+rmIa6TgkJwaVqR4JLen4tyQgNnRg4+xtQd5escB1iUZR+Bl6F
	 eL/f+wnqRp2DCbX4mH1YdcINpVCI3LuG++qm3A/nNnVgE6OUwHjga0pQr0SdMzjmDk
	 6GIPLcDHPMmhtgGDLcsjfy1uVTg8bSZlGIYOHp+pRRkGq7ZvEjfUh5zSp4xxroewdm
	 AG6Z3DM3eJm5n0qLLTKgufE2G2XKkKSwWhSFJXy1HfPkO7Q3RIh9hbUw7nBwzl3hwu
	 bdi9X8uQ5sPOA==
Message-ID: <c72cffbb-2d2a-415c-bb25-a4e1e62a2dd7@kernel.org>
Date: Mon, 20 Jul 2026 22:39:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slub: fix missing debugfs entries for caches created
 before sysfs init
Content-Language: en-US
To: Li Xiasong <lixiasong1@huawei.com>, Harry Yoo <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, yuehaibing@huawei.com,
 zhangchangzhong@huawei.com, weiyongjun1@huawei.com
References: <20260720145124.3684976-1-lixiasong1@huawei.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260720145124.3684976-1-lixiasong1@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4stw88o3im94ow5mizr8c35qbk3k6jgi
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DE2974000A
X-HE-Tag: 1784579948-161808
X-HE-Meta: U2FsdGVkX19I6rKlV3sU5u17eHeOsO2ADuoaKJu/QH4lrFh27F38WxFWxM9+RsChF1FoHXV2l8Qtb3hk1lGTqzOTU2dDI61tc8X50AMMeoRJABVLfNm2Pv7TMuIL/wlUbqfP5H4eQZrED7xAzuuc5Du6EhqYObCiH1swN9pLFzv1RS10MhjRww0O2PKbvP/vvvpYnb2/sex7FJm9jbAWqrQyLjSR6UHZcbYjSS2ckIAzSr5DEX55x/mq1MkBQSZUo1u+sg+oYflFaQdSPFbYYGsOKKNm/M2UlqBGOa86lQaNEUZdo/SbrSZCVcuLl/upGdY/VeKfSYK1otkW//Gd9lDuU69S4FR6LtWwAlNgtahpRnmfD5OeC9tTx4V5Bc9P/tm30pvEowLcRyv4y6yEBzpkLYqXjWlXzpISr6NZFQNzUz+a/bAAW08I7JS4yb5P8l5vDphxfbLY6Q2X5K1+bMhEzX1Vjopfs36DWogh6Peq4uX3fc7QRqjb3oWD3KbYwkChVMF1c+d127TI00PpeiYaPtax9Cx041rrn6ao+iTfRBHRMNsJczR6sqKYWb0+AE5M4ZH8LpXf6JDIj9XiOAS7skP3pebduRV+i2o5oAJEQV2xXpnkqZNqfVfb60TcbOjWUshqcQnkZPsKSTog3130nitdUKLvJ8Z7dG4SwlZXHmK+Tfa8T2vsAzNWIkbiWt7GY4J6M52JHtVFfTOSHJ+fum3VOxpDetUU9pnDGfUxZmM62IVJTjwkMweL4SPps7WHTOLyJi71I02KCkhSx4a+T3kZseJZcuzkUIJ4THi/RhS5UG6eVtgyeEO8Wc02OGnLjMLakvYU6HSLFVEGKadhbU4MiXzJeX00598XWZ0+U8qfB3Ryca7HUECLL4DhQkyI+yeONjq9DUEIDfUv1TbNKANxmRgJx7B0htIYQF2fAex5dSx0SgqaWKcuCacgHI1NSNEoql/4wjzrdMH
 2VIWqdsr
 Tl+FG6PrSN77pAaMiTNJQ9nV7Vqce71Ch8jy6WbpY1ojLR7OirQuesQP07PeqA7OgNb6TK9KzQtsljPkJ4t0yDEyv+UyfhyB7hS777/o8EHwIWR0nbBsLqDkzQbEs6jHOPw/l68vuP6QCL6DDYT3ffJsfr3SuG1PtJTgESRxEpzNpYM1ZnPAv+L/OPah2vcoCYu7cTNzOx30yLM0EzQXFzUavcr1ZLxMod1KTsKrFZekofua2ztt1U0kGrHwhvTW/N1gyZGLl6VP/4eoH7ePgWz9JC0w2K+N2x1QxoFhI/agwChXyoS5wrw/hP+YC8E56pD5i
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/20/26 16:51, Li Xiasong wrote:
> slab_debugfs_init() creates the slab debugfs root at device
> initcall time, while slab_sysfs_init() moves slab_state to FULL
> at late initcall time. SLAB_STORE_USER caches created in this
> window currently miss their debugfs entries because
> do_kmem_cache_create() skips debugfs_slab_add() when slab_state
> <= UP. This was observed with MPTCP's request_sock_subflow_v6
> cache, whose slab debugfs directory was missing.
> 
> The affected initcall window is:
> 
>   slab_debugfs_init()
>     slab_debugfs_root = debugfs_create_dir(...)
> 
>   kmem_cache_create(..., SLAB_STORE_USER, ...)
>     do_kmem_cache_create()
>       if (slab_state <= UP)
>         return without debugfs entries
> 
>   slab_sysfs_init()
>     slab_state = FULL
> 
> Run slab_debugfs_init() after slab_sysfs_init() and protect its scan of
> slab_caches with slab_mutex.
> 
> Fixes: 1a5ad30b89b4 ("mm: slub: make slab_sysfs_init() a late_initcall")
> Signed-off-by: Li Xiasong <lixiasong1@huawei.com>

Oops, good catch. Cc: stable perhaps?

> ---
>  mm/slub.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 9ec774dc7009..d35e40c7a7ba 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -9992,16 +9992,23 @@ static int __init slab_debugfs_init(void)
>  {
>  	struct kmem_cache *s;
>  
> +	mutex_lock(&slab_mutex);
> +
>  	slab_debugfs_root = debugfs_create_dir("slab", NULL);
>  
>  	list_for_each_entry(s, &slab_caches, list)
>  		if (s->flags & SLAB_STORE_USER)
>  			debugfs_slab_add(s);
>  
> +	mutex_unlock(&slab_mutex);
>  	return 0;
>  
>  }
> -__initcall(slab_debugfs_init);
> +/*
> + * This must be after slab_sysfs_init(), otherwise caches created between
> + * the debugfs scan and slab_state reaching FULL miss their debugfs entries.
> + */
> +late_initcall(slab_debugfs_init);

Hm but does anything guarantee the ordering between late_initcall() is what
we would want? Or it's possible we still miss something because the ordering
could be:

slab_debugfs_init()
$some_other_late_initcall_fn() -> kmem_cache_create()
slab_sysfs_init()

What about a single late_initcall() function that walks the list once and
calls both sysfs and debugfs parts?

>  #endif
>  /*
>   * The /proc/slabinfo ABI


