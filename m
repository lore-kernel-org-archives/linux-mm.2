Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E90CBCA9EDE
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 02:52:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF5B76B008C; Mon, 12 Oct 2026 22:52:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA6AC6B0092; Mon, 12 Oct 2026 22:52:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 995416B0095; Mon, 12 Oct 2026 22:52:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C1F96B008C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 22:52:37 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F40A1A8C52
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 02:52:36 +0000 (UTC)
X-FDA: 85316079912.12.92C9964
Received: from mta1.migadu.com (out-140.mta1.migadu.com [95.215.58.140])
	by imf20.hostedemail.com (Postfix) with ESMTP id CF6F41C0009
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 02:52:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NAMtpaTP;
	spf=pass (imf20.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.140 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791859955;
	b=ZP3rK9+YjO9HApbo7K56FC3ZT8bQvbi5eTEV9grP43qFSIFxiKOveh4IFaXgRg+pYQEyeH
	+N8+dPCu73OJpTXVRf2sMYmz8AlRQRiOsriCUad+m9+gEE0FeC+zIy6d0rsBCM580K1VbB
	MoH/ej9s/KwStY63tKEhcRhHwwIosxI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NAMtpaTP;
	spf=pass (imf20.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.140 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791859955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Fj+lKWf228aMEeTxkotor9yBL+IOb/Lnniaw3b95XA=;
	b=A5YUAtn0lIaZjlkOqMaC22GyCA898Wze4GM6T5DzKLSsn9XR99oeEjkulaaJr8Gtp8Sf0K
	7OWu+p7a6mLvTbMXd1eGxBlcAx5WGCjoFeTi54BjlrTFL6B/mOQQty+e5GaqRV/JLHUrFy
	PoXT71RSsflTRh8ddFSFCyYcbgWvbXc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=uL6ePUcLBZZOUIyB5RLHnAYGU9PprjKQPlmJBefHVMY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791859953; v=1; x=1792464753;
 b=NAMtpaTPaCQ5A3BTTO3fwnlTUTeVof9HIoOGcULZS+jzEK5ALCPSDHs+G2rJtftClVL2B4Uw
 8G2dxy/mHsi0XK3sZIcQYIjPxYzpVb9PGXdsqCR1OIgj+Rb24JiQONZiPoa5aomONHCzQcDD9QG
 OrXo0ye+S5CeYVkCzx/61iIs=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6830bd04216ac914;
	Tue, 13 Oct 2026 02:52:33 +0000
X-Mizu-Trace-ID: 6830bd04216ac914
X-Migadu-Flow: FLOW_OUT
Message-ID: <c2d25c25-2fd4-4bb5-a021-3cdf23e493d0@linux.dev>
Date: Tue, 13 Oct 2026 10:52:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/shrinker: size shrinker_info_unit to a power of
 two
To: Konstantin Khorenko <khorenko@virtuozzo.com>,
 Andrew Morton <akpm@linux-foundation.org>, Dave Chinner
 <david@fromorbit.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20261012-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v1-0-5a7608393b7a@virtuozzo.com>
 <20261012-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v1-1-5a7608393b7a@virtuozzo.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20261012-b4-prep-vstor-144715-size-shrinker_info_unit-to-a-power-of-two-v1-1-5a7608393b7a@virtuozzo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CF6F41C0009
X-Stat-Signature: frkgoea4f7k7afnqq6yq8zy9kboqf3cd
X-HE-Tag: 1791859954-568698
X-HE-Meta: U2FsdGVkX198NL7LF1Ii8TORzifUgYSQ006468REN+y3fk7+GkXXq3sE/inOTKClj8gtduRhk8/KjgNFFDUCNdddxg5uAKUkngxEdlmqzg0k333WFywDuLDxQ6iJWYldrKYS7XFZuiZa0JNfKEmHEdVdkXthYMAg7hZQrSsdzpqPx+CQD3dUeeIYwyNa19fMZdf7zNOrN3BcnTlyAF2kY+yuTxIGMf/FFNLAi5XqMhjij1KB1AwT9CIEgmjjixX8t2FvFWSXmDpi2yB7DrU+58gg8QEhQTCwEfVTbCy8eDQwcpdFq22LW8Ke7vXq+zXt52F0W/bzJ/zhKcyg5oZ9jeO4AsFzV+n8yrrfUcPjlhqRhZySj1ccMV4pHDexqy7+xEo1ZCk+w1CPsOLB9NUb+Pf/JiFvXYSN2ruSS/OGuldRkCVk762QRtRGEN7m6piE38hC7KyabK7f9ZJ66guL+iSriJkq6gZ9vVXTDOnkD8B8AWa7Wq1MGOk/zPFIPL8Ts764bHrqyttDXuanxkue9vE/joM6E0hVSKofSMd/ozbowUt76vb1Rl34XyjF3iwKusofjCRlQ9BNOWbRl3VcV/NBd5SNsHhYxAjd9IxCMS194IZG3hveg7QwuWVSSPaitP0k5LimA5CQ8hdpmOfSqYfKj0bkHIwm3j+CUJOIFNBbw0f6hnbwjfnRj87cYvSPZqqMP+jCg0zNkIMI9GOV2HqeLdKmSZ3QeuSujgey/L+GTD75GtSvuJtNHR3prYipOl5IJGUzLIZXLnk/oPksTFmcJqiz9FuyPf0Wg8vCK8ozDz35KG45HCJRnXF+FExgcuevT6hExlifEsHPfAJcSDMd4VKO+NbpoS9dYe75wYUx2i2sbLoC/0HFMaYZE75VyjsCiYYbRMmPqz1ThhHdAH0Yyo3FGjSc9gg+Wrdthts1u6Zb+P6iM73JzNyjX0OmwuOp8M2Brec1sMDNzon
 dzrmxiAZ
 7/fGkWLY7ykYgzjXnklz5PcDAu7UtJCNyi+9o4+3eT0y0VADnBW/oc90RJzf+BWTpQeFpZHOOccpGU2fMatceS47sNfXwZx+bUXPCYS3P3wV1I6GfPMHAQrM7yo/yIlVVNQzipOtJzXd5Fdo6yJkZbtsNEBhVELwvqcZ0oc44m6h8urgAtZ83OtG2jDEXPjuEHDP2h00c6bc68/NMTFnJYdTRh/Vo6eJhRA/7y7msKbZbwlbNDi1tF0erlaSQ8hj/h+nl3yexZdK3q51N7U3RmTNz/GtLs0Cv8r9HT3ymHXllB1WNGoOJVBdtBL39VZ97M0Sj/kHARCjJDHFI8PfbNzkPIG7RJxQ3yx71ggVNfTkYako2dEBDLaNGzh34KpUc41jAjTk6hBKZIn7dOc9cBa0mi+Z4PZWK5aDV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/13/26 3:02 AM, Konstantin Khorenko wrote:
> Every memory cgroup allocates, per NUMA node, one shrinker_info_unit
> for every SHRINKER_UNIT_BITS shrinker ids up to shrinker_nr_max. The
> unit holds BITS_PER_LONG atomic_long_t of deferred work, a power of
> two, plus the one-word bitmap of shrinkers with objects charged to the
> cgroup. That word takes the unit just past the power of two, to 520
> bytes on 64-bit, so every unit comes from kmalloc-1k and almost half of
> it is padding.
> 
> The units are allocated when the cgroup goes online and freed when it is
> freed, so a dying cgroup keeps them until the last reference to it is
> gone. Their number is the number of memory cgroups, times the NUMA
> nodes, times shrinker_nr_max / SHRINKER_UNIT_BITS. shrinker_nr_max is
> the peak number of memcg-aware shrinkers registered at once, and every
> superblock registers one, so a host that mounts many filesystems and
> runs many cgroups carries the padding as unreclaimable slab, and keeps
> paying it for new cgroups after the mounts are gone.
> 
> Let a unit cover one id less than a word holds. The bitmap still fits
> one word, and nr_deferred[] plus that word add up to BITS_PER_LONG
> longs, so the unit fills a power-of-two kmalloc slot exactly and, on
> 64-bit, the memory taken by units halves, for about one unit more in
> BITS_PER_LONG.
> round_up() in expand_shrinker_info() needs a power-of-two step and
> becomes roundup(); the other uses of SHRINKER_UNIT_BITS are divisions,
> modulos and multiplications that do not care. Assert the unit size at
> build time, since the layout depends on it.
> 
> Assisted-by: LLM
> Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
> ---
>   include/linux/shrinker.h | 9 ++++++++-
>   mm/shrinker.c            | 2 +-
>   2 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
> index 1a00be90d93a9..c250ab68d346c 100644
> --- a/include/linux/shrinker.h
> +++ b/include/linux/shrinker.h
> @@ -7,7 +7,11 @@
>   #include <linux/refcount.h>
>   #include <linux/completion.h>
>   
> -#define SHRINKER_UNIT_BITS	BITS_PER_LONG
> +/*
> + * One id less than a word holds, so that nr_deferred[] and the map word add
> + * up to BITS_PER_LONG longs: a power of two, which fills a kmalloc slot.
> + */
> +#define SHRINKER_UNIT_BITS	(BITS_PER_LONG - 1)
>   
>   /*
>    * Bitmap and deferred work of shrinker::id corresponding to memcg-aware
> @@ -18,6 +22,9 @@ struct shrinker_info_unit {
>   	DECLARE_BITMAP(map, SHRINKER_UNIT_BITS);
>   };
>   
> +static_assert(!(sizeof(struct shrinker_info_unit) &
> +		(sizeof(struct shrinker_info_unit) - 1)));
> +
>   struct shrinker_info {
>   	struct rcu_head rcu;
>   	int map_nr_max;
> diff --git a/mm/shrinker.c b/mm/shrinker.c
> index 7ec2a9704f6f2..a9418072a509e 100644
> --- a/mm/shrinker.c
> +++ b/mm/shrinker.c
> @@ -159,7 +159,7 @@ static int expand_one_shrinker_info(struct mem_cgroup *memcg, int new_size,
>   static int expand_shrinker_info(int new_id)
>   {
>   	int ret = 0;
> -	int new_nr_max = round_up(new_id + 1, SHRINKER_UNIT_BITS);
> +	int new_nr_max = roundup(new_id + 1, SHRINKER_UNIT_BITS);
>   	int new_size, old_size = 0;
>   	struct mem_cgroup *memcg;
>   
> 

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi




