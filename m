Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A34CC5DF82
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 09:03:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 882D76B0095; Thu, 20 Aug 2026 05:02:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 858DE6B009B; Thu, 20 Aug 2026 05:02:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7963C6B009D; Thu, 20 Aug 2026 05:02:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5A45E6B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 05:02:59 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DE91612070C
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 09:02:58 +0000 (UTC)
X-FDA: 85121058036.21.24A3A9B
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1A8A710000A
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 09:02:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=eMlyuKVl;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787216577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WhwSASY61Vb36hFr4yqvOQldrzA+ZS8XNx2b1KiT3k0=;
	b=7xVGD4hE113nuyWOEWkcIw+FN3+cljzqhQ6nnlVzCSzYgMd77qXFu1y861nmHn5Kt8KyS3
	cwh1wDAkpFtrFLpbVxuDNV7k2o3Z8k3jEi8zvyACr+dQpvEKGUHVTrJJv3iC9k9WNMYHPk
	sG3z/XqauhvaJA48J0Q7e+YRsUvmMZA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787216577;
	b=qEJ4dA3OyNfO+AHmKUypIwwcY8DpoRtWTLBq0uIlk6npFMIs0ZMATx31tz6vJZwV3McX4p
	2n6T5wWLIdu84v+EGZch9wNMf9ZYCTXYVDfRdvaxQydbREl24kP/Uxfv/hkqmGg4K4yyKW
	1VNkzGIDRrUX3MJgGZUtBeCOPWB2zIY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=eMlyuKVl;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787216571; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=WhwSASY61Vb36hFr4yqvOQldrzA+ZS8XNx2b1KiT3k0=;
	b=eMlyuKVlUoswIYTRSB38qEh9ASWH2KqfADeVytu+n6t1olPHynt47Iwk4M6awBvrCsFcczkUiwXrffW6pHpWGeYB20lG10x1lFGD1lWjFQTqiXFG3ta+sMgw7fZ6RhV924cXiFKQUm4cTvYUNb7stniGfIO1LAAs6TW4kyfPqmc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0X9IyxVj_1787216569;
Received: from 30.74.144.123(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X9IyxVj_1787216569 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 20 Aug 2026 17:02:50 +0800
Message-ID: <f16fbf4f-e9e2-4a3b-b618-87b29e80693c@linux.alibaba.com>
Date: Thu, 20 Aug 2026 17:02:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] mm/mglru: improve readability of isolate_folios()
To: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: axelrasmussen@google.com, baoquan.he@linux.dev, chenridong@xiaomi.com,
 david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com,
 lianux.mm@gmail.com, linux-kernel@vger.kernel.org, ljs@kernel.org,
 lyugaofei@xiaomi.com, mhocko@kernel.org, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, stevensd@chromium.org, wangzicheng@honor.com,
 weixugc@google.com, yuanchu@google.com
References: <20260820045603.68809-1-baohua@kernel.org>
 <20260820045603.68809-2-baohua@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260820045603.68809-2-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: d4manthfymt7gf8qjtqf7abcc1cocab3
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1A8A710000A
X-HE-Tag: 1787216574-865854
X-HE-Meta: U2FsdGVkX18BPxlNz4X1nDrYI3Qg7R5UWcbp4Y3bOsV2JKpuaTbffJriJWLaAy/MnTpSYRtr7kRzrLLwEyodOlFRLI/eEs1R47m+c4kADRt3qaMOmRGoFsQp+SvEO1wvb5IwJxlV1JA2tgLG5213+5AhxKq8TYO5S9KPspbo+7HidbpsyYk2C1qrZGebLpLj7HOZReN9q6ZG389V1CJ47Csep6aRHVdzNtWZcNYKnxs7rb+aSoteoe5R3I6pKUUVOkcrruS3OJD5cWnvdyYyS1Vqgg6fXAjS1y1eBm+1mbuW71vffENfL5197ZWh8rWettaig9LoLGXOKiaWkd/FaumHBq1PVYuqI+A/g0N31ntA4/b5jFrNxrNCokfhBt/xmvfXhvN+Yfqjomz7OeHm/6YTqW/AQFwyCxNzE3QCBIWqhRdbf68yutThSsXTV2hIHFF4pGrUC49cxopvg/FrbrxK9ULZ4pc2cOeX1INjOtxqhfo494YKv8/nS4WaBwgcamBWCVBUdzhZNYs7VdoccoB6g1G/l5AERGDgtweOL20Fz7ygLiQL8zm2HBI0vGbjhLHj7Onap+XxWc+7AEqOTWjDNd1aLFdeKbapO8vq2DuM8ouTTOAnLBs12uz7RgcJ2ghMUbGkDBpeSruvutVkXqMO7anXg3cYW9i3DrMAp72pMt6NjBnVhQFAKoZ8+esxietJKyW27MblovnsJPARw3yxbp/vnq07tBZUyLrZ9GFqoPZJyUp7tsG/SdCbufjJnU7xnvKcXqrgj+ALJ9d+bP/g/MdohQp3hSMrgsnxjR9uXk/ZQi8QOK16qHAWxQmgBJg9eTdKfnA9v+nb8WtqoNO7r3ZF4UTA5Jyq0ce7Yh4FhKXuPGz4GyQOV2yO7urBDFu5KRfi58/0yhMu28T/lASe+ij4V3M9nQzHZgu53SVggftBlc65dZszCOBpJjuZSITOv665HA6wnhjC4Yt
 AZHhvBZ5
 XwD74f4Fe1SmLQGEsUSyEvu85es7yLq8fYxQAen3vbdIR5tHu/HoXOzGcTatYuM3jOLswpu8G7cKX5LpY2UFKzg4YnNvJkK8JVBkSC2SDCTrdv8mC3vkhnfmK709aYVjcfnrtxGjes06kOHXLMpMy7/spQ/8ZapMyjjo0DZxXEU1x6ZIZpOPky0nmsun+RbYHKkEuSITmT2HXSxhJq8tMjkxrH8XJ47n1oiZZHldV+MCd6kpOjTF56LUrIXbCFgnRDed9MB9oIXACCrmL5LTBEiHmDCxJ0EuuL1goxYqZbcdzkFJv0tTfKjc1gDMgT81WyWr3d13fS9oAk4Nqx+BKOscQeWR1Q94Y3XHMMUnc+sBbpC7rfiVXvIo2scuyNn0GavcXbzxq+0nOUD6F4F1qWnERDaEPrrcC2+9ebLvFp82gbFm3qPSR6bPBacD1+JI4Gn/ZwfHv8js8z+5U32j7XcQB3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/20/26 12:56 PM, Barry Song (Xiaomi) wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> The for_each_evictable_type() loop in isolate_folios()
> is misleading: it does not actually iterate over each
> evictable type. Instead, get_type_to_scan() selects the
> type to scan, while the iterator `i` merely bounds the
> number of attempts.
> 
> Make the fallback behavior explicit in the code and remove the
> opaque for_each_evictable_type(i, swappiness).
> 
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> Co-developed-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

>   mm/vmscan.c | 46 ++++++++++++++++++++++++++--------------------
>   1 file changed, 26 insertions(+), 20 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index c1404a59523d..d5cc30b667ad 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4833,35 +4833,41 @@ static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
>   	return positive_ctrl_err(&sp, &pv);
>   }
>   
> +static inline bool is_single_type_reclaim(int swappiness)
> +{
> +	return swappiness == MIN_SWAPPINESS ||
> +	       swappiness == SWAPPINESS_ANON_ONLY;
> +}

I can't think of a better function name either, so I'm fine with it :)

