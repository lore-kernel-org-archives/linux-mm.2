Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B236FC5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 10:17:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 667E26B00AE; Wed, 12 Aug 2026 06:17:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 619156B0109; Wed, 12 Aug 2026 06:17:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 555C86B010E; Wed, 12 Aug 2026 06:17:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C4FC6B00AE
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:17:20 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A57DF160180
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:17:19 +0000 (UTC)
X-FDA: 85092214998.24.17BAAB8
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id DF255140007
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:17:15 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=KKMlr2Hh;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786529838;
	b=mjAbKIJzoF5EPwKwKBjDdaEGJ1KhGOYyyhI1vYm/JuAXxb2tTxZ0zfy+YYyWZBy8v8pUOF
	KwAwjp0HqVwTNIru1HE6vpU4l5okyPEG4pLgkGAUi2iGX7MAdASXuIHhvLoAvATuMMcA7k
	EmqUzCmWCbXGx4amweBkZTJPSf++/Vk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=KKMlr2Hh;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786529838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4HoO1GzcddlvJMkEk1X4eHDN/y9zqCqi6gXl6/6zpk0=;
	b=4Rqq+yLQ+hRbjiWGhiGbnYHxLsMAgH1Pk/HxZIwrQddqcW0ziuwj+o7ir9L+QsFcvIdW6D
	Aj9omexjPI5E3c73q37JX5oFwpP6rVRVgG4uHjAX7sWd+0PUfYhxdiscApc0o8Aao5CuRA
	JPqYlVR5mHEAofERxu/XfAiYev2kdCs=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1786529831; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=4HoO1GzcddlvJMkEk1X4eHDN/y9zqCqi6gXl6/6zpk0=;
	b=KKMlr2HhPM/D8nBnfTQQbkU0LpZdhdAigkpZSKCzB4j5WYFyuE+D1kBdSevS7KLKBaLpte3Nx0dKY0IM9XXXyWNBUpCJXNZ0/Nlos/SzgQLXc2TkCgV2KmT+kJCqgGmlrVv7sIflT8oZCFMOExUa97Ltas6VB6H3sy1lePU8pPE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X8rG74f_1786529828;
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X8rG74f_1786529828 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 12 Aug 2026 18:17:09 +0800
Message-ID: <d18ed09c-52b7-40ac-95e8-c1530246e2af@linux.alibaba.com>
Date: Wed, 12 Aug 2026 18:17:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mglru: Fix young counter undercount for large folios
To: Hui Zhu <hui.zhu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>,
 Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
References: <20260812065933.103627-1-hui.zhu@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260812065933.103627-1-hui.zhu@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DF255140007
X-Rspam-User: 
X-Stat-Signature: hcpuyxrp4ndodmadcts4xbqdeafmqpyg
X-Rspamd-Server: rspam06
X-HE-Tag: 1786529835-633258
X-HE-Meta: U2FsdGVkX19ECV6WDyIHnn3Ap60bkE21YPJ8CdZb6l3ua9FGMzrjaTDM/K/jFJoSnJOLSosM9dLAu8eQCO2Cz5alJDFn4yfh6NGl0/riBqZxQI2KW0LWptMdBc67QYlhRRtYNGSIbvAGVPqqx0jWbwR42w2al8Z1avxdt8P4OoeCSFPIwbZWt3dV8btf00e4IGwuxU8vshhZlj1kU0gwrthodhQYxPOne2Uz+RmpGicdiZqQXw2kuML7aY3Unp2Q+v9QWFVWSYLluAmY8BgcyCVR2+GPVuPZ4cYGIT2T/K6LGtIi7/d5pOQxP8qB6jlS4Mbu81IQZHANR4yEaXGuAucXMcbcycXUn8+RgM6mZL1TLcRPgxCMY7KVMwu8PQpxQsx8udhLXDi+DgQB15ZIoefCav65WeBqYFqI8mUeJJxuVgTw9CiUi5kH2ZvdQ38wqsvXxl53qcwoIA6/7xspx2yZiSz7ZXytU7KB1BJtw6HBPX68+NYb9mdb+Sykn1G4VD4p6AvQf4QcNTTR4Ur+llyaW/KYvg+KWLLpZcaMSOGd/PRW/a+m3PiS+040Jm00aOQtB4qxgsXROWpku/bNZaj4VUxMulZy0Bsxstzg3Loh218KzayaEIDyKXqE02yR9NBUwPud7BrQq2UnL6lckYlbX82QlAh8oCxFyLDDhHPOzSPz0rf6XnSG/RPQRN/SAD6C476Br1E48XQjNLMZFbwnvDSFhyBlkAGP+y65bxiFHi/EcBYra8SptDOnN1uAto4k4oV003p0nRSa5PbkG9qJFA+7R5ujguCHtgBunlTrIc+n35CIOnqfb7QkDJxiSYXrggykSzL9cQewj/qJjYwfqg+Dl9+JFNiTrHRlZetG5NkzzWhJD51hc/TV/wPw9u/B2IWb7qcBf09rfecLiEsWKGG3xg/uaR1407GbATNJ25qBFcC0s93JYhNSMUR0Quig6RGF20WTsQmOIZJ
 v9/GEsxl
 5jwqMOiPgHyzmnB2FQ/HyNeRE8wHunrGkoXcJwZ/1/h+LX/sJdLPaBJh7O7kJOQwRf7sbiLYmRQo0a6i8TM8xRdpUIw2eLfo6ZJspxW6V+pgKlqW2d/xYz6z3tLz368XHKdAt07s8wR2a7UIXn7/2HTKL/URC+RCyYNC+9tTLtQ3/AN+9YilaLEoqus5fBWNClLE4qkjk1OaHvgSzxzAnzaQAB7DQjsDtRtZwkxRTA10d+qi7fM4SyFvBK3k++fN0qHqF6K5yFp5jnND09mAOfAwKHKwHQLB41/fZQVPMZHJxlqM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/12/26 2:59 PM, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> In lru_gen_look_around(), the young counter tracks the number of young
> PTEs.  The original folio's contribution is represented by the initial
> value of young: test_and_clear_young_ptes_notify() is called on it at
> function entry, and the function returns early if it is not young.  In
> the subsequent loop, the original folio is skipped (its accessed bits
> were already cleared), so it is not double-counted.
> 
> However, young is initialized to 1 regardless of the folio size.  When
> the original folio is a large folio with nr PTEs, its young count is
> underestimated by nr - 1.  This inconsistency can cause
> suitable_to_scan() to return false, preventing the PMD from being added
> to the bloom filter and reducing aging accuracy for mTHP workloads.
> 
> Initialize young to nr so the original folio is accounted the same way
> as other young folios in the loop (young += nr).
> 
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---

Good catch. Please also add the Fixes tag:

Fixes: 56e5b60b2114 ("mm: support batched checking of the young flag for 
MGLRU")

With that,
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

>   mm/vmscan.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index bc324e37c5f1..264017850a55 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4192,7 +4192,7 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
>   	unsigned long end;
>   	struct lru_gen_mm_walk *walk;
>   	struct folio *last = NULL;
> -	int young = 1;
> +	int young = nr;
>   	pte_t *pte = pvmw->pte;
>   	unsigned long addr = pvmw->address;
>   	struct vm_area_struct *vma = pvmw->vma;


