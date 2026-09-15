Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CC7BC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 13:00:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C0076B009E; Tue, 15 Sep 2026 09:00:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46EFA6B00AC; Tue, 15 Sep 2026 09:00:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3851C6B00AD; Tue, 15 Sep 2026 09:00:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1B2476B009E
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:00:38 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B3343A040B
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 13:00:37 +0000 (UTC)
X-FDA: 85216005714.10.75C1B69
Received: from mta0.migadu.com (out-1.mta0.migadu.com [91.218.175.1])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6246B4000C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 13:00:34 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vr+p6Dgs;
	spf=pass (imf04.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.1 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789477235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B3JcHqndr+GXgxLzalEJuNjq1/BYTAkHjY2qZe4kq90=;
	b=Muau1PxQYrLVexQZOctI9SsKyovRSZc62DuEwL4Ig1X1MqoU+YrYuXA+JBrbnzT08O4GM7
	PGOJX61wQ9wK0Mmtib5CUOXz7BFUFtCjZCuKsbn3jdz6S6lM58NPVEuOU8Jq+DmvhHBFKZ
	dgx/kpZ61l6v0a0aNaeqhERimDzejpc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vr+p6Dgs;
	spf=pass (imf04.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.1 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789477235;
	b=I0wNztPHXAQQWtP8NhdkFt83rBOibjcHhqf8AMEb+XLd2mL6aAIrbEdCwbEKCw68FCvxIW
	Rk/LZ/S+oQNy/YVcJ3c3veFBfoWr2m9WsW3fVEdyD3wL6xed3CE9YsCgu3kUnTwxL3NR6B
	xsjsObhbiHHszyJ0FOOgRCKyzPrJA+Y=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=8Iig13WWjneOyX8KyPeO4Ee/L4k/7+zpdoNaaUmwk8Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789477232; v=1; x=1790082032;
 b=vr+p6DgsZ0C0zJcb5Ejn1YU5qWlSM1DOoRV4Z9MNs4WXOYjcLGCTduGVivAZHXNSLJsqLHxG
 C5+y0Ywu/fjj8B4sikDK1vnrQRk1h27l7PGGA96MIvm1xzeoucAfAACxs+bZ/iVrBC5bzqbCe4Q
 VyDxcmEcujdjxZBAGuqpTcKA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 91b1d043b12ab9bd;
	Tue, 15 Sep 2026 13:00:11 +0000
X-Mizu-Trace-ID: 91b1d043b12ab9bd
X-Migadu-Flow: FLOW_OUT
Message-ID: <166d8533-127c-4e2b-b37e-a6650c981a97@linux.dev>
Date: Tue, 15 Sep 2026 21:00:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm/damon: fix typos in comments
To: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
Cc: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 ahuang12@lenovo.com
References: <20260915102746.647-1-adrianhuang0701@gmail.com>
Content-Language: en-US
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <20260915102746.647-1-adrianhuang0701@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: urcj4dgzzaewp5c4tjxyxfi3kh1baxiu
X-Rspamd-Queue-Id: 6246B4000C
X-Rspamd-Server: rspam07
X-HE-Tag: 1789477234-953388
X-HE-Meta: U2FsdGVkX1/T8dqv2H2FmX3iRqoj4Nq5JQ4abEN8O/tdJu9rWdFl8Q/lQYWkhFO63FHvCVuulbAzRmlOeEBjsPqpKyMkD5BGDiGAd2bNlW8XeQ5dYQx4jq/LTrA1sTWzq2m31e9KUuvCehFhLqVnFX3LRJPmxFx8YbUnQatHUoUZztUpqlwUIPnWQbaDkv+ReAcuzqigHZjMZQ0qxpcj79lzSGFs8AQxVjVsyKN7QQkeMe5jofA6knHAu7CoFEGDxXWa4FRfQ9IV2YVi21WGBE8Z7jg0LajQfOYXk8mggKejcvjmgv7vjyr0eDCm6PTzynOmuFUbCTLKWbVClB0ExZLVgIWDuc8ob3DWaCGGv9J46DIHOd8LkuAL4UGjiJVBixe85Llvdf4QXbKNRS9WCHzHb0TvsWKbjzd01uOhVOKbW/iXpFbrR5DKtA4FFPDuGRO8p3GkXsp/wSXDDCi9HlR1eDmrL/cFQhzq+G8elZ2xeTe1VMJ2ZQjmDPku9P5F508uqhCtVBK3O/pRovX5YynZxWczjiYoW0nULoKqwITEuvm6qP+Lm53aTyYCYXXyZ+bjne4yZn6/CRLKraTT9IzwKQMXloUikn+NOpnlu617Oedr2KqbYaMIg2rwMqKz0WfJdbhfXz0VGiERlospojTuVF8MJySB58x6nNFyt72kpmgoUmWqdNaMVDpe1BzTj4ZYlGx3fxKrvbeDWGWShlvOxC6qv5SxzPJcFOUEKUhruPQ3TQ7lxVG1ucy90DTkq1gu0EbHupG0ks654KHipzpiHk2hyvU7afYWmHs4FDVEf7i2VKUBcYO5aGZL4KDJe7DMMe5UYsTPOxwlQwjzWUzpUWh+YO9D+Mnm+v82Gxbfk5yJG0H1YKIqFpw580F0S0WPGIrXjAs9EErBBoc0c3wMvjqOpoZFwPQCykaiF+ne+VqCZh1WVfMJKaBJGIyEWpI3713g6/xrpQAeiDh
 fLvQ+mHC
 Wo5QcPcbADuAbOTsDVj2dnPLya5Zr4vKysB+Lnnhh313ompvN4trL1OPnBOsLCDsYmjj4YWmVnC7DlL30f8w50vQZsUxeoxWQBMEbSJ00iwp0HcVONf7dkz0M6THWARioybOHYCVoLPNh/ZF6oVpNlXxcRW2F12J/SCejDjHIj2uX7CuWXVAxel2q5HCfeylp7Y/18B6W0r/4iZIC8cYyh+fKgQvQi7E+thNeo4jhXl6LvalJ6+vS21NyTeznkPG+5o/Sf/Ticwu9chNcZUpdKp59bkLtSqVYoPR6SpxtRO/P3+E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/15/26 6:27 PM, Adrian Huang (Lenovo) wrote:
> Correct spelling mistakes. No functional changes.
> 
> Signed-off-by: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>
> ---
>  mm/damon/core.c     | 6 +++---
>  mm/damon/lru_sort.c | 2 +-
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 0c98f7e267d0..981a153619c0 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2447,7 +2447,7 @@ static bool damos_valid_target(struct damon_ctx *c, struct damon_region *r,
>   * This function checks if a given region should be skipped or not for the
>   * reason.  If only the starting part of the region has previously charged,
>   * this function splits the region into two so that the second one covers the
> - * area that not charged in the previous charge widnow, and return true.  The
> + * area that not charged in the previous charge window, and return true.  The
>   * caller can see the second one on the next iteration of the region walk.
>   * Note that this means the caller should use damon_for_each_region() instead
>   * of damon_for_each_region_safe().  If damon_for_each_region_safe() is used,
> @@ -2613,7 +2613,7 @@ static void damos_walk_call_walk(struct damon_ctx *ctx, struct damon_target *t,
>   * This function is called when kdamond finished applying the action of a DAMOS
>   * scheme to all regions that eligible for the given &damos->apply_interval_us.
>   * If every scheme of @ctx including @s now finished walking for at least one
> - * &damos->apply_interval_us, this function makrs the handling of the given
> + * &damos->apply_interval_us, this function marks the handling of the given
>   * DAMOS walk request is done, so that damos_walk() can wake up and return.
>   */
>  static void damos_walk_complete(struct damon_ctx *ctx, struct damos *s)
> @@ -4143,7 +4143,7 @@ static bool damon_find_system_rams_range(unsigned long *start,
>   * This function sets the region of @t as requested by @start and @end.  If the
>   * values of @start and @end are zero, however, this function finds 'System
>   * RAM' resources and sets the region to cover all the resource.  In the latter
> - * case, this function saves the start and the end addresseses of the first and
> + * case, this function saves the start and the end addresses of the first and
>   * the last resources in @start and @end, respectively.
>   *
>   * Return: 0 on success, negative error code otherwise.
> diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
> index ad8e86dd3a93..273efa3c913e 100644
> --- a/mm/damon/lru_sort.c
> +++ b/mm/damon/lru_sort.c
> @@ -260,7 +260,7 @@ static int damon_lru_sort_add_filters(struct damos *hot_scheme,
>  		return -ENOMEM;
>  	damos_add_filter(hot_scheme, filter);
>  
> -	/* disabllow de-prioritizing young pages */
> +	/* disallow de-prioritizing young pages */
>  	filter = damos_new_filter(DAMOS_FILTER_TYPE_YOUNG, true, false);
>  	if (!filter)
>  		return -ENOMEM;

Reviewed-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>

Thanks,
Zenghui

