Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35200CA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 15:49:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 921798E0009; Wed,  3 Sep 2025 11:49:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F83E8E0001; Wed,  3 Sep 2025 11:49:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80E0B8E0009; Wed,  3 Sep 2025 11:49:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6AC988E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 11:49:15 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 10D728641F
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 15:49:15 +0000 (UTC)
X-FDA: 83848373070.02.FDC2A7F
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf06.hostedemail.com (Postfix) with ESMTP id 07AC5180007
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 15:49:12 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mzPlPmQI;
	spf=pass (imf06.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756914553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xWM/Ee9c5tZH794jcWBxxK/ZiW23+RWkflZdSBvqMV4=;
	b=FLKUJlAfqvd+1Fd7I+/X95wpx4VpAsA0fOt1Se2i5UF+vqgLHbSO/RjWGVAB2e0BDkbyc9
	xj4TgV/1D3zHa4eRXDf+T5f0GMisIT6QaJ1mzt+03OYsuUd9/GHtANNT5sBiTSWm8nl5vg
	6Plwh6OqyUH280AcXu1o8KlOFd9Nmx4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mzPlPmQI;
	spf=pass (imf06.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756914553; a=rsa-sha256;
	cv=none;
	b=BBIGIbz6Z2iXJ3HIzlspCsTnfJ8akmTlYyIWlqDzW7+KIeCdpkbhnWcUgvB1z3kcRHP1IH
	9DOUbKApfM7BDLbR+4Gy5E3xZWrzlbmXV1RehvyhkAguHQA67ayklvIiTMGQJVDTU9Acoi
	K1ChAyRwey+nsdBdgqxOppiEEUH5qs8=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-45b8b8d45b3so763315e9.1
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 08:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756914551; x=1757519351; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xWM/Ee9c5tZH794jcWBxxK/ZiW23+RWkflZdSBvqMV4=;
        b=mzPlPmQI91Jhz1TVKV70jvuEKA2O4oRVYINAf8D0u8HvRjsmNnJbdtQx3Dk6v2WhuN
         /p8QlgEuy9EQ1kh0Iggo7Z6614v0YEy59UG5YMceP6CaVi6pphPgKKy7xfBWzkSj4n7S
         efRHyc5i++If9PHzAWtE13TEs6wsJg2i4lycfX+xSrdHwqOc7n29AWdO5X1MieDcf1vs
         UJPc+FhBS55itWbpCJCEthJJY+R6JtD58WlzHBvhox8KjNWc4G6XtbO3HoPUhdB+sQwo
         x27KQxCOhJTgujBFdLSXi8weuTxZg406kve3k7uCc6+IM20KWjVW7MEFyfLNvm2XCr7W
         oj5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756914551; x=1757519351;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xWM/Ee9c5tZH794jcWBxxK/ZiW23+RWkflZdSBvqMV4=;
        b=rAg3rd9AvCC3O1ftekiHWTwxbcC0DSIcTvw4egy9R88xx9IKCC4rkE+GYLPs2riuSn
         7UpjsUSMu4lt8T0IPb+iaWnVwLXaavD9J7Zeir01MmorUAXO6D48el/GShBSEDnMCkqo
         fRKshA/17OSqXcQnngQ9Pq3HCCtvdT28r4b+qj3oD0tpy2li5E2925LJo0B8zkpEPa8R
         07X78jTyJqWfDNi2rmX5jwKaqtfxKL5CEJDwzxi53g2GoNzGM9pBmsOyi+rDlaT02Npn
         LmapMx+hP97dqHwHPPrZUvD4r+H3jqNba8oMR6r5ahD2CB+G2aqsLjkmJqssmwYnOPOb
         fOtw==
X-Gm-Message-State: AOJu0Yz1soJ2XQ57wmpO2MXfXGQxB/wOeqmrAvgU/yDSqnp2iBYgkiFz
	eGywzdLHjjWdciVDlsDnisasv6+dmhMCV75cun+UGbviqc3UqfpVs2tT
X-Gm-Gg: ASbGncv3wlBYhYHqdzeKND/ELALsqaJn5MpDbsgJ0rqyQ48uvqu8derBh80/DdCG/IT
	vVL82GNarEurkviOTHxKoaAWlm733hbz1K5aV7/qGRxoDBmpHDBscj91Pefl4xBjhS26XnlIjNS
	yRlmyIxoot5XraAoIs7czVxDxsv3ZFr2a/ZP6S9tyDBtn7AjGZXw8if9ljy2s44/Q7JqtuQJxVu
	hpGAAdaVp8FXMw8DdCV6vGyRA2Edi1HCImHfxLS0YqSAot5hv+KVzTaX5OeenQozTB6pjkdZZaT
	MLxIA4TFPZbe1bF4/dEjHZQReloEjItzq1zXzVJkAtw0pOQ33EnkV9QIruEEqcjlLrBuIh1p6Uu
	aPMrSLBJ++OPY8bGNLyFT+9wvC1PBTp69NrKhOIDgdhVD8ljFxFlfEsKdCl8LFHVnahSu80bRue
	FR
X-Google-Smtp-Source: AGHT+IFt8LtX9m01F0TUuz2lfDDhzFr0dtBjRXexiZOo1zqUyYUKfasS8UrB0/k8solqEJWkCmlVAg==
X-Received: by 2002:a05:6000:24c3:b0:3dc:364d:8de6 with SMTP id ffacd0b85a97d-3dc364d903dmr3386228f8f.54.1756914551407;
        Wed, 03 Sep 2025 08:49:11 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1126:4:1449:d619:96c0:8e08? ([2620:10d:c092:500::5:3267])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf33fb9db4sm24120485f8f.47.2025.09.03.08.49.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 08:49:10 -0700 (PDT)
Message-ID: <c222c848-6636-46ef-9249-707d18046297@gmail.com>
Date: Wed, 3 Sep 2025 16:49:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] mm/show_mem: Dump the status of the mem alloc
 profiling before printing
Content-Language: en-GB
To: Yueyang Pan <pyyjason@gmail.com>, Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Vishal Moola <vishal.moola@gmail.com>, Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, kernel-team@meta.com, linux-kernel@vger.kernel.org
References: <cover.1756897825.git.pyyjason@gmail.com>
 <d7998ea0ddc2ea1a78bb6e89adf530526f76679a.1756897825.git.pyyjason@gmail.com>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <d7998ea0ddc2ea1a78bb6e89adf530526f76679a.1756897825.git.pyyjason@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 07AC5180007
X-Stat-Signature: n7m5huchu4g6upjz387ukzfazid5t3tu
X-Rspam-User: 
X-HE-Tag: 1756914552-17015
X-HE-Meta: U2FsdGVkX1/3MuvwOrraULfZKQSskJNb9lf2wu6900rUPyXf41nM9EAkX03V+ouxPXRRU1rQLMXrdqKcPrEYAtE7TMzUR4A54G38/RU+ffzC8L1gPu/qSXWvYPaIvdQdJ2g/SFbVV46g5z9+p1LYV3vvXUn8A72rWsCEst/wiaA2YSvaBo2DEvT3R8Z2yD2NrYmibqp+Xm9w7rGpsAU5aaGcmXsHpyrSyTS0Wbo/s61hUfk/WHltFqSOrQaAQZuefnaW1zM7ZWxvkfEXFUW9Ws4mSXGyUT1IosADkyiq5u3cHv4Wn7QPmG3YZWlilwD5SJulY30kT5yma3j3iQWtlQ6FI6kbrmonNYxBscoZ6LKki7+yPNXrde8hh+Q87ea4tQQP0KZhfit5HtTWHakp2TO60oyly3DWVJdflOBs9GgU9QubTeHHUoqGkcAbVHp+H6C7IiMc/Fac8kMYq9nTJN8/36+eUPuhG3BHHJeobxdBZrcqfk/48ufrjC+D+h7plNIT2/ez38ER34nxyyX9l7uwZf8tp2Kjk7yOIu0Q8dLtmZ2TqlG7M4DN9lcIM37mKSHaGY8eU84jbjYWtEOcb73o6TZ/Vqfzogc7KRmfBRGE5YHIEqp58FYOgDhPGkQJTpW5jIpcVOYc5Q3reIzazvOiAT2V83ircGOrL/IozNlrI+BZJumq9VjPx7IqW9E4temjN0ZuALm/RPW45Hlhnw3R0cyMZOAuDnl2VQME9MY5XnBe0F6Q++ub01FgE8FPq7nQuh2+EuAURjicUcTPZJwcvYTFauN6m7PBbmAMwKByzmDOcQrNj47TCocYempCw6qjFTmD2n78a65pq75TImQ8B/3V1wRPzgmXqur1QJQL5dJdezIMPx5sH2Q06T+Ouq/jBTXBAk8bLESBCW6VrOLZe8PYSSZxuH8igMxlczmsX4QDjkdgpqzKEMVgsR8jw/bWvisqQPBXp23xxGr
 YxJZoEty
 SVbXYwQtOnowZ7wrURtHTjbJbQZBg/GMb+JNKY+oR5fplOHlBTjpBVWRcWjTL6XgLJcvZDtKAesxNSj+SapUPyFXOVMNLYi0PZ0xFjxQEFBVkial6ecNUSUR+Wq9imaM+u9KO03UV5OCfDnWFmgZdNiShCkrh6FbPVr0IitZI0QFTgElY3jgs5I7WjYTN0PZaRAzZPg9tfbTQop8sYFjBhVR3S+a0JbqFc46l7JUZXKh2PN8lm27q7/lZYd/yFX6QUFPymJMxhpLTI/30y/NP64ys0bA/aX/cpAcrrtbx3/8yEzARpRQT7k2VGVJFSVJB0yrUeDgxwC/dFWPI6EtQ4CsOpCoHqKYS6IjEoVGvDE7GKlnLX23s5AiFI39/Gy5g6AoBGbm9oMFokdmvLmip8elnQjlJqtcb3Op0Jm0uWC9REzKLN60s8/18UqrE0TlpZS/9tyyVtHzG3f4WMA9T3K6lYohQIqqZw9jx8inWnpNyxxSwrZVi6w1Ho0phqLUanpIDKVz3vrI7Xa91lqM+BHlRjTcUT8B3utoryZBpTVcQ8FXLX87FH9E0zs5hMB1/JR4hhWqlQ+xbgMSUrsAgbHtOhFvlcR9XgcVhFLqe+sW7HD8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 03/09/2025 12:16, Yueyang Pan wrote:
> This patch prints the status of the memory allocation profiling
> before __show_mem actually prints the detailed allocation info.
> This way will let us know the `0B` we saw in allocation info is
> because the profiling is disabled or the allocation is actually
> 0B.
> 
> Signed-off-by: Yueyang Pan <pyyjason@gmail.com>

Acked-by: Usama Arif <usamaarif642@gmail.com>

> ---
>  mm/show_mem.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/show_mem.c b/mm/show_mem.c
> index ecf20a93ea54..fd85a028a926 100644
> --- a/mm/show_mem.c
> +++ b/mm/show_mem.c
> @@ -427,7 +427,8 @@ void __show_mem(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
>  
>  		nr = alloc_tag_top_users(tags, ARRAY_SIZE(tags), false);
>  		if (nr) {
> -			pr_notice("Memory allocations:\n");
> +			pr_notice("Memory allocations (profiling is currently turned %s):\n",
> +				mem_alloc_profiling_enabled() ? "on" : "off");
>  			for (i = 0; i < nr; i++) {
>  				struct codetag *ct = tags[i].ct;
>  				struct alloc_tag *tag = ct_to_alloc_tag(ct);


