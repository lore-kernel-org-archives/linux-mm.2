Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4D96C55174
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 03:22:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9B326B008A; Sun,  2 Aug 2026 23:22:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4C2D6B0092; Sun,  2 Aug 2026 23:22:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3B586B0093; Sun,  2 Aug 2026 23:22:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 93D2F6B008A
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 23:22:24 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0B5721205AA
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 03:22:24 +0000 (UTC)
X-FDA: 85058510208.20.9F7621C
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf25.hostedemail.com (Postfix) with ESMTP id 337E8A0007
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 03:22:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=fXtT0fGS;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785727342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u3z7jErvysYS7pNJ/uLaA0r4Xt2Aj3qRn93q+F1nN8Y=;
	b=m6gqjYjJhL/j5369XbfMHAN3q4cZCMRrwudm5f/Bxj0S6IM3V9Y/64diyQzSzDhmOeYO9l
	UxJg7qXRdByKDzwdYvE1DI8j4f6Fqj+RPt8fmZNXQfDy2Tso/38d1qZnMeMHp8I1CHCIZU
	7dD/PHG4ymx4DdwQIxi4wWEosD3O94Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785727342;
	b=XrMUMqLKOa/7V1tphdm8U02Uvs4Stgeb2kutT0BJEVch+YVex5O5Z7UFAd/2XxCwXAZReI
	RPdsivI7FSbA425OlayO2jzPqs/WyheFYj23XrYvJvpS48vW6cwDKbDtgifpLoJxvM5Jyq
	own76O8EM0O9D0iFJtv5OPS1bKtI80M=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=fXtT0fGS;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785727334; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=u3z7jErvysYS7pNJ/uLaA0r4Xt2Aj3qRn93q+F1nN8Y=;
	b=fXtT0fGSpxH2BISkgUa76aeb6PC/bRDbqtQ5AxPpD0+QSMmQ1iB9W6XVF703N0bN8p5/YDFvcsFN+9WoJl4UO9hf0Bbgd5qHj3ovPnSKij0ZPa301DsKBhjSFVgohP6Jm3irkl/p1I9oa3d6p1wtAvz6guIl9ovJh8nwNns52Ac=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0X8DqCxp_1785727328;
Received: from 30.74.144.148(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X8DqCxp_1785727328 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 03 Aug 2026 11:22:08 +0800
Message-ID: <9692264d-74a0-4a69-9d57-49a8c90cf41d@linux.alibaba.com>
Date: Mon, 3 Aug 2026 11:22:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 3/6] mm/mglru: improve readability of
 isolate_folios()
To: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: axelrasmussen@google.com, david@kernel.org, hannes@cmpxchg.org,
 kasong@tencent.com, linux-kernel@vger.kernel.org, ljs@kernel.org,
 lyugaofei@xiaomi.com, mhocko@kernel.org, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, stevensd@chromium.org, weixugc@google.com,
 yuanchu@google.com, chenridong@xiaomi.com, zhangbo56@xiaomi.com,
 wangzicheng@honor.com, lianux.mm@gmail.com
References: <20260731083843.37811-1-baohua@kernel.org>
 <20260731083843.37811-4-baohua@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260731083843.37811-4-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 337E8A0007
X-Stat-Signature: jreroathfhaet5f7ms6ju31ce7gprfdg
X-Rspam-User: 
X-HE-Tag: 1785727339-181487
X-HE-Meta: U2FsdGVkX1/z0UVpWdCMN9NGqI85v9Oz/2tUq3AVpL8lKwS+7hW1JfY4fX5/X28jjRXHrl8YZK4sOcSdRCHIgF1TrYPpWci7Y8RGggTTRU1octBjzpCRydfZ/liYMVZV1zIoZhIcgIL6tkFuXaJ54klmLqVWKiiyfU8NJBq/2ZyabMKI+UBeI1sDr2JnS32qlk4wSEj8DAUJa1D7sTdrAIE+R9wwQn1s21Folvf91brQaVFjXf8ibJDqw/9VrbaTHmsMO+19p0aKgDSa+DFPWxUQ0Hofq5+wckSLXzc9xid18hRlXxlI32OiZMLB48o52gX5bTPyboshYAjy3REtoRBibR08eoUMOUCB+GvL8iMD1DUoHQWsiQ6GituoeQEbLdt9XPytvHjCMUsolrE8KFpi4PFmSxBpgEX6MUBH/LeoB5YtrVzgekTxcphwetLgLJXUwsZjkohBTtpyAXoISEI1pv5H9/bPJ+cYNJXnsrCPsfIgiGGFSKo1W+858cnAkwV23Q4QZDsQ6v80ORE+mHpYO/QFpes6Btzv3F2GEpvlwkn21U+rZTD+8qlX8d0HnY8a99k0HaRvXbU/CnJi1e2Q/ObXSJQW0f3NBxNX0Ow+8i9gCkxH+SXoZfbIzLYxcUDOgy2DtZQGPeD0XEbCpjIOBlWX1kWJMkh0UB0xDNRxb8HdLU6eKgh3HsUk5vn8NederrhgSYPO8ibUzWWRXJ/HmTGSbVERa5sEsOvNbKfXAVcH1BrinE1FWLyotKJ8V/BG+dBRNK9JxbORD0nF9hm4M9FPpkpBjPReitQrLH/cnn7WSrWaI3fY1heN4/2i4RRnQO0VP5T/sZaqeZ4QcYoGldHqJf1AL7Od6x1Wum4vsm5L8YICEtfhBrMUejValAVlX8WeiLJRUqfJMoZghoRotoD6AIKt0omxLKh9vpXFNuyjfE13obJC44Ezu9e0aHTINxFMA501A3QmBNA
 +pyHOj+T
 FhSJpRDvmA4bI1oLuShVNkWXvIUufJDr6AhNAxTswrIC+FyI+7FPI4c8vQ/bfAzT6sRN86aylGST30OxwZhxzu1DZfMcFtc1iH2cMqhcg7+NOigWYwI9jtDu6Hb1jnbA3lOljzUEDwtGg71HcEA5NwilqWRU5tTBjpfCogWzx+Zbq9JInIztcLSLBir6PjwyoZSO6YFqqYwSdeP1g8UWmgjmHO8+Ct8wQBrVpjL5spFEs98AfZ5t8ZlUBFeDT+K8nYRDe812sLOtYOQeakJrbAZCrqPpNd1JIF4jASuyt2s+yyGWiBxieemdtyDxdvinGLfwIDTbWkl5dALRTaej921uarYIXc9pROsD6e5Mp/bhaY1B5dTQXagoTXPDbgrNR7PvXsWESY+kIJzP6g3tXI8e9RV14ziemBGYHvUESJiFmEBK+vEcqUE9DTyj6cr62ioIJFicASP3or1iOKZBVa0pIhGyTtNIpWG7szIOyGaRo8kM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/31/26 4:38 PM, Barry Song (Xiaomi) wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> The for_each_evictable_type() loop in isolate_folios()
> is misleading: it does not actually iterate over each
> evictable type. Instead, get_type_to_scan() selects the
> type to scan, while the iterator `i` merely bounds the
> number of attempts.
> 
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> Co-developed-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---

Good cleanup. Some comments below.

>   mm/vmscan.c | 47 +++++++++++++++++++++++++++--------------------
>   1 file changed, 27 insertions(+), 20 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 31947fa60f18..0038f33aa318 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4828,35 +4828,42 @@ static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
>   	return positive_ctrl_err(&sp, &pv);
>   }
>   
> +static inline bool is_single_type_reclaim(int swappiness)
> +{
> +	return swappiness == MIN_SWAPPINESS ||
> +	       swappiness == SWAPPINESS_ANON_ONLY;
> +}
> +
>   static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   			  struct scan_control *sc, int swappiness,
>   			  struct list_head *list, int *isolated,
>   			  int *isolate_type, int *isolate_scanned)
>   {
> -	int i;
> -	int total_scanned = 0;
> +	bool single_type = is_single_type_reclaim(swappiness);
>   	int type = get_type_to_scan(lruvec, swappiness);
> +	int total_scanned = 0, scanned, tier;
> +	bool tried = false;

The tried' is a bit confusing. How about 'type_fallback_allowed'? Or 
other more readable variable name?

In addition, the 'single_type' variable can be removed, and just 
initialize 'type_fallback_allowed' directly:

bool type_fallback_allowed = !is_single_type_reclaim(swappiness);


> -	for_each_evictable_type(i, swappiness) {
> -		int scanned;
> -		int tier = get_tier_idx(lruvec, type);
> +retry:
> +	tier = get_tier_idx(lruvec, type);
> +	scanned = scan_folios(nr_to_scan, lruvec, sc,
> +			      type, tier, list, isolated);
>   
> -		scanned = scan_folios(nr_to_scan, lruvec, sc,
> -				      type, tier, list, isolated);
> +	total_scanned += scanned;
> +	if (*isolated) {
> +		*isolate_type = type;
> +		*isolate_scanned = scanned;
> +		return total_scanned;
> +	}
>   
> -		total_scanned += scanned;
> -		if (*isolated) {
> -			*isolate_type = type;
> -			*isolate_scanned = scanned;
> -			break;
> -		}
> -		/*
> -		 * If scanned > 0 and isolated == 0, avoid falling back to the
> -		 * other type, as this type remains sufficient. Falling back
> -		 * too readily can disrupt the positive_ctrl_err() bias.
> -		 */
> -		if (!scanned)
> -			type = !type;
> +	/*
> +	 * We are running out of the current reclaim type. Fall back to
> +	 * the other type if allowed.
> +	 */
> +	if (!tried && !scanned && !single_type) {
> +		type = !type;
> +		tried = true;
> +		goto retry;
>   	}
>   
>   	return total_scanned;


