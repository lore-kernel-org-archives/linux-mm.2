Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D557BCD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 13:20:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6DFC6B0005; Wed, 20 May 2026 09:20:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E45406B0088; Wed, 20 May 2026 09:20:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D82BE6B008A; Wed, 20 May 2026 09:20:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 796D66B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 09:20:29 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 214AE14032A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 13:20:29 +0000 (UTC)
X-FDA: 84787857378.07.1432EC5
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0889A40009
	for <linux-mm@kvack.org>; Wed, 20 May 2026 13:20:26 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sRFdAQmj;
	spf=pass (imf12.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779283227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NglNKIPq1qLVfrKsWY3QACNOviMl7btMLa/RT1SC8Fg=;
	b=XSbl2Eh8kjrp7vPMKslMJOaYCzBeizn2n6Q2Gtkr0aGUHaF43gXIu1DCo7X1iaWgjQu5OW
	S/utOJxmy5DJ80UFBf7PLBj//lqG+bOXWXRSSbVxlKpugI5WIGZ8C+OQXqxuI/X/RlsMyq
	kcuml6PFeeIFd2oydChI4nbR5M248CQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sRFdAQmj;
	spf=pass (imf12.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779283227; a=rsa-sha256;
	cv=none;
	b=WxiRuLPtIDhLvSjw4Moh6BYAWjm8rsdKlMe5lPrKyBkx7m0YyY3LPFRZGvawGvIE+7lY0A
	+3zbWDND3yYUzxyFPHYfX1xXf9+5LaCvuwSLvgjRBa1XYeA6q0G5fbsJUMxhnkCcP7+QOw
	GnCt/jAU0aXdCd3U61c+GvPbyKcgXMs=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-488ff90d6c7so37793385e9.2
        for <linux-mm@kvack.org>; Wed, 20 May 2026 06:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779283225; x=1779888025; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NglNKIPq1qLVfrKsWY3QACNOviMl7btMLa/RT1SC8Fg=;
        b=sRFdAQmjmlWvx2XIh8sNlIdV/+6paNw61goHTbdb5sgahv/3bJL5qoYe2+wsEEnidv
         njHiuu9jpC1rYDoxsA1R6b78yQzmsm4JTD5TgmEPLbcksYl7fsSt5+iErJoCL5o/3eWc
         Lud4R9Dod6c4x+vZYX++bT3GYKBKtqzIGHPYBw4k5VJm6Sc/veKnBzJah9w2odVvJ6Kh
         8nJpAgKBBES8oHglEu+P2aSd1ft/iS6vvwSPi7tEC7lbWVNLRMZtICAom+Nr9ERkBKoH
         w5J1GbBwtuU7NQzHC7i/IBeLeQoTobY5gNo3/SK244wF4KLw/QVH/g0dSZyZWbWO1Ri6
         Qfng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779283225; x=1779888025;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NglNKIPq1qLVfrKsWY3QACNOviMl7btMLa/RT1SC8Fg=;
        b=sgfB426Qer/corQlvbsxSC09qC41YZ6NLQ8EiZ3fSRWEXJaWpvMZOC3NPdr2TWoQbt
         8IUnuYeSCJs9rV/lHtHnZQUFrF0opu24ctW7rxq/jfWRAuHx+ca/eQrR4QnN4cEg4y9I
         yJiiTtL/7O5rzEPIsCrXAyenHly3SQj4QCBNAaF7O0e5f5a5c2oA5dptXXyP8Ya29+3K
         vjzBbxETIiP0YKgvlSSQN50uolfTQwMhrVz1nQW2CzsQwnv2oKl0zoR1VIUeHxSJbLXb
         pkAhZyggACJw10KxkrcGeNfRL2Fcsur27wixQnmMV48zUCacFWjWKAoQFmgLODqpD8qI
         hftg==
X-Forwarded-Encrypted: i=1; AFNElJ+P+Ngy28WY9bvVrYVhAqYGFsxcEdnik98b6ZJHw6ae/gLih9vcFONUmOZdh0a1ZZYhojuvsnkzzw==@kvack.org
X-Gm-Message-State: AOJu0YwUPk7r2hZR7RbzWVy3ne710IEU6Q2EeRVNzDo1UjgvPSJ/ehnF
	F67YFWDBRcPv5zMFmiSB+2osEIf0RsHLuHpODR9QYs1h6V8sBzc+uE3J
X-Gm-Gg: Acq92OH6TbGgXwomParKkoEEUJmpUwyOuLC1+/Lr+4ZNiIQPztyhmhKtI1GCUdStoF5
	MY7/KuXxzPO6OpnjFe4vdiFT2Np7bY/M9mk4OQs8J1frJwzH5QQtgEhm90po2TKwMtudowweC0P
	1aJkH6KHyCyxsiR9yriSOpnegyaWUbtaVyK2V3H8pZadGkLyvb6+CgagRbHPHe5Z+Ps1XcRywb3
	HljO8uGuMYYfBcQHH2sV+/xrWUUnToMy+w64Z/oxD55APn8whbo9/xlzX1ivLOP0ixqFzndDvaJ
	8Tdze6MOkPB5cK5ZHBvaSIx76btRaY1u26gAHjoLI7ejPjdsIwv9tvkA3iBWOzNJHXG87L+i9Jl
	GmHQfSuraYzXKO/OnJ4Wz1SpN67LzAQMCExQb345OspicZWZ179E/3KjqBxEJuwUOve+eVHJllt
	PMystubu4nBVKHZyCKCpYCDEu4ADWXOvbXlUL5JQNJjLcpsqtVL0mQ1gxeupD5qZUp
X-Received: by 2002:a05:600c:470e:b0:48d:361:4df6 with SMTP id 5b1f17b1804b1-48fe60eabbcmr353411015e9.9.1779283225112;
        Wed, 20 May 2026 06:20:25 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe4dac000sm406738105e9.0.2026.05.20.06.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 06:20:24 -0700 (PDT)
Date: Wed, 20 May 2026 14:20:23 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner
 <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Qi Zheng
 <qi.zheng@linux.dev>, Alexandre Ghiti <alex@ghiti.fr>, Joshua Hahn
 <joshua.hahnjy@gmail.com>, Harry Yoo <harry@kernel.org>, Meta kernel team
 <kernel-team@meta.com>, linux-mm@kvack.org, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH 2/4] memcg: uint16_t for nr_bytes in obj_stock_pcp
Message-ID: <20260520142023.6eae5ec7@pumpkin>
In-Reply-To: <20260520053123.2709959-3-shakeel.butt@linux.dev>
References: <20260520053123.2709959-1-shakeel.butt@linux.dev>
	<20260520053123.2709959-3-shakeel.butt@linux.dev>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fpetazgee3c3y3kt8xqsfur7bj9ssqb5
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0889A40009
X-Rspam-User: 
X-HE-Tag: 1779283226-36579
X-HE-Meta: U2FsdGVkX18BEwzidJtZA12BTqYRlo2jow4Wzsbsm4phfxyLsHTWB/lAIHg6no3jbE3EnYxrxVeBOCp2KLSCjqu+W0iob3ZOZEWBhVGaZuiG9ZM++gXloM2S3f52DaQZjxjxpBT1RpXA3Px8p23i/K0nWlstMFwk2bxF4mxYyOmkM4xIPH8NUAUi9baX2lpCla4MVDgE7gqnII4igjFGNUCaeDJHa3INMREDHvMZhmPo1+IaTZm3QibPOGw24ovNcZ23n/pIFn67MykhMkGFaBKPMNY4FVyqfo5Ios5K1J0SE6zqSO5YiQiyF3L/PWWnUmX1Y3PFaDbW1F7XgnIfojGvsNjlF3N7TnKqCrk4Zfl/ydERegx4zds29BSTOwHILNzYYniupKhJJxJHpELVz5JJEwc0HSso/l0cst54c54tRQRiPPqe+h066P0XDapCLaThTJQisEi/t5on+UT4abY9tKmMK0NQ+cOCB0aAwKRqk+0An5pryerR96060N7fRkpdlZ2UAgMScHJJMLhrWdfkY//US91ATYmGMBlZh2lcHzj04WwtVpijShwtKP0g5JwJiwDLEI9n//peQ5dK2OpBFtsr8tejPlkJae2hMLKDduCkkER7gSTfcsigfslWDzXlrn0crUsY7VjwEuWMdjLH5+6cRLWX32SHXnVSDxfDSujqgEdgABAHB3vpcVqD+jGyu+5ajNoBuBNhssblzHpRLIlHGID01mf8RifXeB12M3voP0LLgWmj4HmWZUpYiZcaNA+2hsqTm3l0yVEf4TFrhS6/51uo236LD1ycNJ7Xy5xY3MYRzVPrs9UQCiZGTNYRhfhZip58X05u4s8a4au7inR9eS3TfMz9PEwx/nUB/91lar1A1oN8jwkVsRFkFC5jTyqPEgzjJPSJX2ArFBQClTzt/Wmlzf5n0nY+xJVFwnZJBwKhd5Zj219VWCuK71414s/Na0DyGKsM6dx
 HQ8V+iTK
 aw06rp1BTveULf77VVyDcCTMTQc2b0WWvVI/maELozZT66RanGIuGEw8aisCZIkHKj78qRerS5wJLOUJLx6FuDw+7hDCjkCKUCJwcMiU0biUiE/Ey6MXN4JzrBkWNhiBkpYbQS258l36bBwqSHhaKUSclFROLD2SEswvOg5gGfmtbPWbT6y6fmgfnpzul2hE2MkDCnu7yWt7D2kJcvxOLPo0TNeo6icSt3UkAaZm9EyvZq/Ox3+Pq1eatRdzzQtGRkC2p+vP9WMz/A5zYgeeINso8tbh+iVEN2s5cOB/u6+Hu8AfmIdUgrKvARnfbh/XiRnW7Ku2kMVBxjbkOxKE1zS2gFvE/XAKXz+tRay9bCYhnLac+BXcbn/6qeXtvOj18YBdMuqTYzeTinJ2QY9ZReEb2nF+Hl0EmYg4jeF2OIPG4dL6HxqqwN7KRGwqnCU8Y8SmvSZbUZI0aJ+N0jIPxjR9aqElWLdV2PdRgpNFXuMqCIivbWyruyTt32+NLhwGItDScAaxu/8uNoqI00OPHPHvjWIZWDMpdslUVj2ftBKAQqKjEzEa/JuaAIoTDmWbINbI3dpfoiBn9rC0ceh3a3mdqPrVh3gGmXwxM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 19 May 2026 22:31:20 -0700
Shakeel Butt <shakeel.butt@linux.dev> wrote:

> Currently struct obj_stock_pcp stores nr_bytes in an 'unsigned int'
> which is 4 bytes on 64-bit machines. Switch the field to uint16_t to
> shrink the per-CPU cache.
> 
> The kernel supports PAGE_SIZE_4KB, _8KB, _16KB, _32KB, _64KB and
> _256KB (see HAVE_PAGE_SIZE_* in arch/Kconfig). After the
> PAGE_SIZE-aligned flush in __refill_obj_stock(), the sub-page
> remainder fits in uint16_t up through 64KiB pages where PAGE_SIZE - 1
> == U16_MAX, but on 256KiB pages PAGE_SIZE - 1 == 0x3FFFF exceeds
> U16_MAX. The accumulator also needs to stay within uint16_t between
> page-aligned flushes on 64KiB pages where PAGE_SIZE itself is
> U16_MAX + 1.
> 
> Accumulate the new total in an 'unsigned int' local, then:
> 
>   1. Flush whenever the accumulator would hit U16_MAX. Together with
>      the existing allow_uncharge flush at PAGE_SIZE, this keeps the
>      uint16_t safe on PAGE_SIZE <= 64KiB.
> 
>   2. On configs with PAGE_SHIFT > 16 (PAGE_SIZE_256KB on hexagon and
>      powerpc 44x), push any sub-page remainder above U16_MAX into
>      objcg->nr_charged_bytes via atomic_add before storing back, so
>      the store cannot silently truncate. The PAGE_SHIFT > 16 guard
>      folds the branch out at compile time on smaller page sizes.
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> Tested-by: kernel test robot <oliver.sang@intel.com>
> ---
>  mm/memcontrol.c | 33 +++++++++++++++++++++++++++------
>  1 file changed, 27 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d7c162946719..b3d63d9f267c 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2019,7 +2019,7 @@ static DEFINE_PER_CPU_ALIGNED(struct memcg_stock_pcp, memcg_stock) = {
>  
>  struct obj_stock_pcp {
>  	local_trylock_t lock;
> -	unsigned int nr_bytes;
> +	uint16_t nr_bytes;
>  	struct obj_cgroup *cached_objcg;
>  	int16_t node_id;

You might want to move it to this hole.
The size of 'lock' depends on kernel build options.

-- David

>  	int nr_slab_reclaimable_b;
> @@ -3331,6 +3331,7 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
>  			       bool allow_uncharge)
>  {
>  	unsigned int nr_pages = 0;
> +	unsigned int stock_nr_bytes;
>  
>  	if (!stock) {
>  		nr_pages = nr_bytes >> PAGE_SHIFT;
> @@ -3339,21 +3340,41 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
>  		goto out;
>  	}
>  
> +	stock_nr_bytes = stock->nr_bytes;
>  	if (READ_ONCE(stock->cached_objcg) != objcg) { /* reset if necessary */
>  		drain_obj_stock(stock);
>  		obj_cgroup_get(objcg);
> -		stock->nr_bytes = atomic_read(&objcg->nr_charged_bytes)
> +		stock_nr_bytes = atomic_read(&objcg->nr_charged_bytes)
>  				? atomic_xchg(&objcg->nr_charged_bytes, 0) : 0;
>  		WRITE_ONCE(stock->cached_objcg, objcg);
>  
>  		allow_uncharge = true;	/* Allow uncharge when objcg changes */
>  	}
> -	stock->nr_bytes += nr_bytes;
> +	stock_nr_bytes += nr_bytes;
> +
> +	/* Since stock->nr_bytes is uint16_t, don't refill >= U16_MAX */
> +	if ((allow_uncharge && (stock_nr_bytes > PAGE_SIZE)) ||
> +	    stock_nr_bytes >= U16_MAX) {
> +		nr_pages = stock_nr_bytes >> PAGE_SHIFT;
> +		stock_nr_bytes &= (PAGE_SIZE - 1);
> +
> +		/*
> +		 * On configs with PAGE_SHIFT > 16 (PAGE_SIZE_256KB on
> +		 * hexagon and powerpc 44x), the sub-page remainder can
> +		 * still exceed U16_MAX. Push the excess back to
> +		 * objcg->nr_charged_bytes so the store into uint16_t
> +		 * cannot silently truncate; folded out at compile time
> +		 * on smaller page sizes.
> +		 */
> +		if (PAGE_SHIFT > 16 && stock_nr_bytes > U16_MAX) {
> +			unsigned int kept = stock_nr_bytes & U16_MAX;
>  
> -	if (allow_uncharge && (stock->nr_bytes > PAGE_SIZE)) {
> -		nr_pages = stock->nr_bytes >> PAGE_SHIFT;
> -		stock->nr_bytes &= (PAGE_SIZE - 1);
> +			atomic_add(stock_nr_bytes - kept,
> +				   &objcg->nr_charged_bytes);
> +			stock_nr_bytes = kept;
> +		}
>  	}
> +	stock->nr_bytes = stock_nr_bytes;
>  
>  out:
>  	if (nr_pages)


