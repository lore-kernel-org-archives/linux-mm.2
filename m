Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10E6EE6780F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 18:29:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A5BE6B0088; Mon, 22 Dec 2025 13:29:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 429C66B0089; Mon, 22 Dec 2025 13:29:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 327D56B008A; Mon, 22 Dec 2025 13:29:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1DC976B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 13:29:04 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B2549891DB
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 18:29:03 +0000 (UTC)
X-FDA: 84247943766.10.212CAAF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 176CFA0009
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 18:29:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="JduX/84u";
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766428142; a=rsa-sha256;
	cv=none;
	b=28s1XowIHheEnWhmTEbK4CoPdUioyZUWRPwJJCRpbWxrhuwTNwy2bQ1jvNikQi1YNCfUPN
	8WlQ56fw3OAyC99tSrm4wNw7rrZRqDsni//xIzBt/whaOCw17Z8cEJW1uxNozdC98gaQy+
	GgfPUWLV8JHGOmyLlEAqOtSLZNFFoCc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="JduX/84u";
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766428142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jOhpifGRYLGSFw90OdITwSnBEby/nuVqXWRyoXzg+2k=;
	b=O/YNVX8vqaXmGj+wBbNuxE4bakz3CZmGKvpNQD3rR8flFXfOpqfCJYwkUTmk6Wml06ePtA
	tSgGIPLjsyTtq3yREcgrEJAWtS0bUA1uqVvlG/k/Zj6b40CTtVEuPWYtIwGJMW3tYonSUp
	1nNMHpjTZZvbkpy4VkpScxCY1UEA8lE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4907A60161;
	Mon, 22 Dec 2025 18:29:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94DEEC16AAE;
	Mon, 22 Dec 2025 18:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766428141;
	bh=Uor7O6PlqV2DP6dKfSla1JVTHiPVWpq8f+nPhUIwYs8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=JduX/84u5Udsh7O8KGzLr7SA9syTfgPwmrJJfM1ngLgKGvz9muyKqMOSdK4XoIpet
	 4cE3CEXBxFMse6eSW8g9DllKjnPktv7/tYysKWjqQkuf+Aemt2wLaAh9jFWWhKKPop
	 5gQHS5tclJRj486VESPC+GNeD9QnFemr8UtC0fnc=
Date: Mon, 22 Dec 2025 10:29:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, Jiayuan Chen <jiayuan.chen@shopee.com>, Johannes
 Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal
 Hocko <mhocko@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel
 Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm/vmscan: mitigate spurious kswapd_failures reset
 from direct reclaim
Message-Id: <20251222102900.91eddc815291496eaf60cbf8@linux-foundation.org>
In-Reply-To: <20251222122022.254268-1-jiayuan.chen@linux.dev>
References: <20251222122022.254268-1-jiayuan.chen@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 176CFA0009
X-Rspamd-Server: rspam10
X-Stat-Signature: 7ht3pweixpebqungrfwgdrpm4d6xejjb
X-HE-Tag: 1766428141-609327
X-HE-Meta: U2FsdGVkX1945hj9bcrBw89/84hfeNlb1dt0i1rWsal+r/MF9EmP+znVnUglgSW3Upq22OefbQlF+6bQ5vryzWGSL6jTq2ZyYP0+OnYLwJprq+x8ZWXq9GIueJihn4AuJIIPvoqz7Vkzji4YFPHCL0tYwr///iFIlQYfbL8GC6V7GamR9cgdlQ57peVWpB8oagt1GmItMjavZQegm8wklJdD/0ZqVKfCVxwKrLEkIGromRPoyMI/zjbY8WuQ9z7w2mlYg8DL5dnLWPHSK05h1w8uUC0YBmsRSdOGZ1nxmTLYGcpD25DEWTyLs8GrnrYIKzt9hkIHiGED5TxnaGNzSGNtpL0q1x2f2wrIVR31yZTkZ9Sxj5y3kDmNxdSX+z10ZcPSKTOcMC8kwd8jUhjZa+Bh6Hj72vXhlqheJaoPh/ZIdbuXnZz9xmVzvp6gV5N1aRCy43Z4vtNdc6A8NMbdOHjZeaULMmuxwA5hr6uWMWJHjsF9fPErZjguoy9o5CqfeydqqrQmtjkUrtO5Oh93WMk+pfaC9PXDD//bLmK+qdrv1X6UQlvymhKuWrALfB8jrZ1LPqkS2YA9TIg6D9WwKvhj5TdtXGbgk4tL0GaLg0leP5ssQ9g/E9szkEPqQfGvAzGwvgPnNojNDlM4lspsfXiPWvQFrNWV3iUlw/4KlD/TZopWqvmbdxBRrwnR/c4jg3J9Bw8YZ8oqaNC8R+BMUGD2dgoxfDc643jFeYiSgoEHGinMGqJiTfSk87BhVUAXTRL4GQBlOuUC2GNtFoxxZUFpFKXgPTBVH3X1GQiSLnv9Fe61W6HikgQBX8AVZnxeik6pbF4OAdl1lSigS+X/eWZV3+Y1H//hq37pCP43X/+FjxoB0ZdQQdz9D10CRSyfdvSd3MLrl++PYzZcBVQgOL8YOB78SqI3IzMtCQMtnuWmcXPHxGSYimSKrfIuWQokuTNh3heeGtMaPDyvifK
 Mc2/icdn
 0lsRgpCYx9oaITIcVK7/B5hZ5xUbm5bEKbHPy4j+q5XJqwY6ODXjsPrR7bID53t3th1iY6YgrtrBt0r0ox/OriMo5SHY4K6b9EaD4uyJLa2JgB2/FYy1eLn+HgR7sp6G2JhaJCWr0/4aMYSyzOO8iuaDCe6APY0I8Vwaj3N0eAruEYEO8/YEiUBF61mEcuiHUNebaHLleULsDJVYxOGLYKauzjyB9xR7Z0u1K4ySYvsRfukaFzE1UimbmulgrbCRjJdP/o0ic+OpnQxlpdq19dNM/QwpZLmsFuXl1jF8FcCWLKDjnDdyWdRHLLGsI0RTfn80ooSrF6CzcXMSgJmtENd5SwHfSUfWunWOn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 22 Dec 2025 20:20:21 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:

> From: Jiayuan Chen <jiayuan.chen@shopee.com>
> 
> When kswapd fails to reclaim memory, kswapd_failures is incremented.
> Once it reaches MAX_RECLAIM_RETRIES, kswapd stops running to avoid
> futile reclaim attempts. However, any successful direct reclaim
> unconditionally resets kswapd_failures to 0, which can cause problems.
> 
> We observed an issue in production on a multi-NUMA system where a
> process allocated large amounts of anonymous pages on a single NUMA
> node, causing its watermark to drop below high and evicting most file
> pages:
> 
> $ numastat -m
> Per-node system memory usage (in MBs):
>                           Node 0          Node 1           Total
>                  --------------- --------------- ---------------
> MemTotal               128222.19       127983.91       256206.11
> MemFree                  1414.48         1432.80         2847.29
> MemUsed                126807.71       126551.11       252358.82
> SwapCached                  0.00            0.00            0.00
> Active                  29017.91        25554.57        54572.48
> Inactive                92749.06        95377.00       188126.06
> Active(anon)            28998.96        23356.47        52355.43
> Inactive(anon)          92685.27        87466.11       180151.39
> Active(file)               18.95         2198.10         2217.05
> Inactive(file)             63.79         7910.89         7974.68
> 
> With swap disabled, only file pages can be reclaimed. When kswapd is
> woken (e.g., via wake_all_kswapds()), it runs continuously but cannot
> raise free memory above the high watermark since reclaimable file pages
> are insufficient. Normally, kswapd would eventually stop after
> kswapd_failures reaches MAX_RECLAIM_RETRIES.
> 
> However, pods on this machine have memory.high set in their cgroup.

What's a "pod"?

> Business processes continuously trigger the high limit, causing frequent
> direct reclaim that keeps resetting kswapd_failures to 0. This prevents
> kswapd from ever stopping.
> 
> The result is that kswapd runs endlessly, repeatedly evicting the few
> remaining file pages which are actually hot. These pages constantly
> refault, generating sustained heavy IO READ pressure.

Yes, not good.

> Fix this by only resetting kswapd_failures from direct reclaim when the
> node is actually balanced. This prevents direct reclaim from keeping
> kswapd alive when the node cannot be balanced through reclaim alone.
>
> ...
>
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2648,6 +2648,15 @@ static bool can_age_anon_pages(struct lruvec *lruvec,
>  			  lruvec_memcg(lruvec));
>  }
>  
> +static bool pgdat_balanced(pg_data_t *pgdat, int order, int highest_zoneidx);

Forward declaration could be avoided by relocating pgdat_balanced(),
although the patch will get a lot larger.

> +static inline void reset_kswapd_failures(struct pglist_data *pgdat,
> +					 struct scan_control *sc)

It would be nice to have a nice comment explaining why this is here. 
Why are we checking for balanced?

> +{
> +	if (!current_is_kswapd() &&

kswapd can no longer clear ->kswapd_failures.  What's the thinking here?

> +	    pgdat_balanced(pgdat, sc->order, sc->reclaim_idx))
> +		atomic_set(&pgdat->kswapd_failures, 0);
> +}
> +
>  #ifdef CONFIG_LRU_GEN
>  
>  #ifdef CONFIG_LRU_GEN_ENABLED
> @@ -5065,7 +5074,7 @@ static void lru_gen_shrink_node(struct pglist_data *pgdat, struct scan_control *
>  	blk_finish_plug(&plug);
>  done:
>  	if (sc->nr_reclaimed > reclaimed)
> -		atomic_set(&pgdat->kswapd_failures, 0);
> +		reset_kswapd_failures(pgdat, sc);
>  }
>  
>  /******************************************************************************
> @@ -6139,7 +6148,7 @@ static void shrink_node(pg_data_t *pgdat, struct scan_control *sc)
>  	 * successful direct reclaim run will revive a dormant kswapd.
>  	 */
>  	if (reclaimable)
> -		atomic_set(&pgdat->kswapd_failures, 0);
> +		reset_kswapd_failures(pgdat, sc);
>  	else if (sc->cache_trim_mode)
>  		sc->cache_trim_mode_failed = 1;
>  }


