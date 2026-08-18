Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4577FC5DF67
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 03:19:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C9C16B0370; Mon, 17 Aug 2026 23:19:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57B316B0844; Mon, 17 Aug 2026 23:19:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 469826B08CD; Mon, 17 Aug 2026 23:19:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2D2746B0370
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 23:19:49 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A91F01C195B
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:19:48 +0000 (UTC)
X-FDA: 85112935656.28.CB89303
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf05.hostedemail.com (Postfix) with ESMTP id 784D1100003
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:19:45 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=vmaWZ58w;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf05.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787023187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7J/Uduy/xE+C4LP4mB+3ZctUtQysnqQkKDdtyXBHTxo=;
	b=nW8GksoCh5ixa3us82VYXPPuX+1MsrQ1YRlTc/6XCVyKWWg5Hjv0R2VmGGHgCk99+BQSnI
	Oop0OieVsHMF+7KwQcy7i2nP2klYQh3dQpDFsruVfm1QerQSBqNrTCQN+5MKB65zkW8ngl
	d4GdQdjbqgfVHtr7aJqyfZEA/4VGRN8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=vmaWZ58w;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf05.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787023187;
	b=V+B7G/beWFbqF0TfKTqorao2piGTbrINCnVMbvVScUmO4HOVoWrDPb55yQxVoA7797kJDH
	uEB+zEoe7XaC/y1DGhHnWLxJmaE8zoRz+/+my2wdAFY6T/OrFK/ue9XMpsqs98N/gKUk/C
	eKIpEKF3l6jT7DU9SkrTpkv5LxsX1Pc=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787023182; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=7J/Uduy/xE+C4LP4mB+3ZctUtQysnqQkKDdtyXBHTxo=;
	b=vmaWZ58wrenNsdFecVeRQFpPmiWUbDCIp7HpQfqZQsqi+A5kJ+CgH9RjG/21MTbEQ2h1d3z/M0QngEurigEnWJhryygATwDEGtnWhEC0HFrMZHMOjgt7NJiRSFCLnF7iZc5IdnFvDGJ//ozsV9fBZhDhwXx97klX8fGmdgDzJFw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X9BvS.-_1787023179;
Received: from 30.74.144.114(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X9BvS.-_1787023179 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 18 Aug 2026 11:19:40 +0800
Message-ID: <7e99b10a-183c-446b-9fbe-8db8cfc0acca@linux.alibaba.com>
Date: Tue, 18 Aug 2026 11:19:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v2 1/2] mm/vmscan: fix missing NR_ISOLATED
 counter update in MGLRU reclaim path
To: Hui Zhu <hui.zhu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
References: <cover.1786950138.git.zhuhui@kylinos.cn>
 <9635d3c027bb8a5a416df04ea891a482beb3de9e.1786950138.git.zhuhui@kylinos.cn>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <9635d3c027bb8a5a416df04ea891a482beb3de9e.1786950138.git.zhuhui@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: qjpnrw6myd49f57xcx5ken9tpot5r9gn
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 784D1100003
X-HE-Tag: 1787023185-372588
X-HE-Meta: U2FsdGVkX1+raSQh9TK3Kb4IW6+sxH+DVbv86MPE7rAaycaenrbEpgoh4WaPK+IzR6Ly08lajAUGQIbMk5OxytT9F4ScjEf/cz70zXrtO9S10Hqgp7DUoq3P+p7z2sGrZK7KO3fNjC1pAor/Ovzrd+g59cl3ADoOMSNEyjG7xKFvunfTK8riIoMUsDTraNVBDz+5+y52rOjwQTdllA3y2PPXtMi3zkjlIDq2+2uqpmrOvZ4l002q7wQNbODMq34ICZBi0ddRZ/pEzcZxn2jiJQY3+NSTW2+mhbQyzfHVjLu0BBjqcOjmTTfoH7/AWWNmc9HF9rnXngpaHTEYYydpBcB+LjFAW1/uG8fSw6wqca0GpajHRDtjFQraa4yqv9YB0NeQVLvZcHRrRZeyNFTn3VjCpgPhMV4W3UoKNFMpOBeAwtR4ZufY0rVvuMaY5rml3uxUyV+jzXm5MBxXn5yR4IcwBz5lnDMTNlAlnpkzM3UHGlvNTBE70heWMJDhq02vyMOGxwvYi75apjMeQUjt6OPfOS2vFGGHMhulUMrez0UYO37WVjOGVkXsPMBPk9QG/Ot5/mcxSQlWdMwj429zKNa7GBaPxV5wgq8ceH9lPQi/pwzlzo5wE6I6bTETjy3H3YgJx1eJTOTpl3NGHqRETyR5hf2D1gbabsdqZJqZSJG5NEpu1mXeSbbXg9GncSMMT1OCNpHrDDywwtEPSAADNV5WUSjWUd5k+fAlaGh3T7GDrL4YdOVa42+bIsbFlyT8lNEA6/kC9Swkb38OKcNwsOChTPU+/d9CnSNcSzK26nl/O+wBhskPTb+wFbKST+eDhVSm3L3eemkzLBu73S6LlPvsgwRn9gaLMSR+5VvCqxNuazcQXwNRqTTFe4PPWaIFXISc/kL7xYyCoceNAIUbgjEz1UOMw3UMRUm3kx1LUMMU56wrdWhBkFJVp4S+M8OuvrpDhNV3uMvvZ3rue3k
 RsZmmjZX
 PYVDUP3FXo6Zv1xKrQcdwizB7rshQVSGmltu2DWVEZYwxuCGElWRTllI+8S1a+JVGihfO35Te2CFA7RBrIfQ/b520otUSr4q0HDBRTB7F1yJx/pm/ujSqjvFXMXSNThtagBZVhEf70riXkcQV90aD8e3eNDABcb9pOe2txgjvXanCLT8yJWeLKJRjW8HW7GH/IjBzefqNtGLRLZQRItU3y2D6/MtR1McKGmOvRqHCBM3W2O4LV2OLQdc/tk5NZnoT0kTzhjyvN51SiEJYKelJkvI4NEa2nkwTN/YnR5l/8fvPi5dmINijOa9iHLI5oDqTO6/W/fv8hJFxFNt+x59UuCriNmIiH2ZCi8hB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/17/26 3:11 PM, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> MGLRU evict_folios() isolates folios from the LRU without updating
> the NR_ISOLATED_ANON/FILE counters, unlike the legacy
> shrink_inactive_list() path. This causes compaction's
> too_many_isolated() check to under-count isolated pages when MGLRU
> reclaim is active.
> 
> Add NR_ISOLATED counter updates in evict_folios(): increment after
> isolate_folios() and decrement after all retry passes complete, using
> the existing nr_isolated which holds the original isolated count.
> 
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---

Changes look good to me with one nit below.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

>   mm/vmscan.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index c1404a59523d..fdc45d7d8fba 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4892,6 +4892,9 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   	scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness,
>   				 &list, &isolated, &type, &type_scanned);
>   	nr_isolated = isolated;
> +	if (nr_isolated)
> +		__mod_node_page_state(pgdat, NR_ISOLATED_ANON + type,
> +				      nr_isolated);
>   
>   	/* Scanning may have emptied the oldest gen, flush it */
>   	if (scanned)
> @@ -4954,6 +4957,10 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   		goto retry;
>   	}
>   
> +	if (nr_isolated)

Nit: we can remove this check, since we never reach here if nr_isolated 
is 0.

> +		mod_node_page_state(pgdat, NR_ISOLATED_ANON + type,
> +				    -nr_isolated);
> +
>   	if (nr_isolated > total_reclaimed)
>   		mod_lruvec_state(lruvec, PGROTATE_ANON + type,
>   				 nr_isolated - total_reclaimed);


