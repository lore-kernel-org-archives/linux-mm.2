Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BD2DF94CD4
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 06:59:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F37996B0088; Wed, 22 Apr 2026 02:59:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE7C16B008A; Wed, 22 Apr 2026 02:59:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFD446B008C; Wed, 22 Apr 2026 02:59:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D2A456B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 02:59:00 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9CD8C8D9FD
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 06:59:00 +0000 (UTC)
X-FDA: 84685289640.26.E54FA2A
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf14.hostedemail.com (Postfix) with ESMTP id DF31C100012
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 06:58:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=KR5JPJJq;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776841138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XM12gL3yRFzB62wuc7W+kz1nWoO9r6KLELNWp9GUo34=;
	b=dKgkWXp4/viXGeHt8UYXzNntO4vl7I56/hbAq7lcYcJwDRJSsKWIvXakjmCsJ6Ol+uEDd7
	f/zGj66E2YNhOYzTRxoDN36YsmoPKccoDcXnKJorKFT1+klBHDO9WbWiWFkYwccwEgK8TO
	KMN/G4Z0N5jxYlmXXs2ScjWXrBi8Y+8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776841138; a=rsa-sha256;
	cv=none;
	b=EvCsUMOpAxOZ+5SzobDHffqMj6NwmjOXl5j6jQke4KAlQiH7+1YOyeO30ROyVXJ+KVvvX5
	yLf9XN8DxKcqSMkTPAc3oyzZhYwae40FgzjUq5PrFn6tNxblOnBVmdMRTwJmCmx/+GDZEE
	mxFezo76I3Uk9ALOFU5UfDsJj/+ck7w=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=KR5JPJJq;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776841132; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=XM12gL3yRFzB62wuc7W+kz1nWoO9r6KLELNWp9GUo34=;
	b=KR5JPJJqCsJb+anS9ZhVBW9R2wcEut8jNBnVLTIUZ98yM9ipe9xuy/6ZClza7nFbplhf6x/oJ/WN6gtKzW2v+m+CjTvZKrGsi3LpfzBfVcW+jAcWbnugGF3wzFZrOwvLuG+ZsEVqYTPGgjACePEnf8d7/DOCt+S3dZ1LwkwOIfU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X1VQVOV_1776841131;
Received: from 30.74.144.136(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X1VQVOV_1776841131 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 22 Apr 2026 14:58:51 +0800
Message-ID: <8d4df864-2954-4eb6-b8d7-ae6595646e6e@linux.alibaba.com>
Date: Wed, 22 Apr 2026 14:58:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2] mm: Improve pgdat_balanced() to avoid
 over-reclamation for higher-order allocation
To: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Wang Lian <wanglian@kylinos.cn>, Kunwu Chan <chentao@kylinos.cn>
References: <20260422021842.78495-1-baohua@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260422021842.78495-1-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: c9isuxxcx53icmpkoxwc8qhpfhgftw8j
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DF31C100012
X-Rspam-User: 
X-HE-Tag: 1776841136-50003
X-HE-Meta: U2FsdGVkX19ILIJZlzJiZZ0ol05FRHxGtt3wxH7PJcDmmARwnpk8AESVGzN6VMOXgvkR2FHB0YRTwlcUeDua2d3zeEtGfk8265zxgQUeb2mksj7ZzcuEf0gHbeeTz7TCn0lNYGegAXEuMGTT+09kmjRZZPbS8M43yeuNfcVHakhClAc6WqLLCZ6YoO1u8+YReCx2EhEdwkOJHDASD62KhqY1TTM/md7Y0FGpZ6LlbIoPghNMiyLfrXGhBDVcdGLqL0A1IfSA6556TILCT3qhWG/7Kvq8DKfqhlL04fy2LKA6hogyDk6RS6iX8Wb2uNDCP54lzYGvlBGvrFeXxLpDfOPvUo5RrmkjzOU1rQduoouzKR+bSd/UTCiyR/ifu6LHxLfsNdr2/MqR2Ea5O10qZynSrWdvEDpn48ndSXTqKWQM6jrAt6jSFWjddngpYoHCsJvGw5KBNmqqY5bPCwlX2qc2TcWjw1RINDm9HYwNmkAvihhs0wb+vICeWl9S0xatedOiDh6Gw4xHi7apvgk1wOeyIMPZffjcbcy3A6xWTd54YdlHTybv8emQ1ZCdduWzukxIQk9CNf6nx1xnQGa4v5xiBBRQzuPtFGVqtUN0qpWBfP6rfeU0DksNK5ufNi2uW8/SHhDsCHShkTirYNfr/a32fFaQAQqOzmAMHrlI0hQoqfnNaXRJ0mvUlhTfCpC7CSZS3f4ejUvarxHRhXjvVkd+p2er82wCZpM09KM3CJcNYOKma3Rl0X9jbXqCS1F9sBuAKRroTCOX+pqdwH7YwAiSvKnuN5BJY49Tlchd05+8SqpbbjUw/zXCAiG53NS07xm3SrNeTaK03KxVVqYKOuSicMfnSRxUsiu6BiynR2IUhK6g/CTeM57ffb3GUT+pCu+peho7SIhG9l6kTWa5b+T87rTrUNZGbVat0uTOvH2idkngTh6TWPjvrDs7pU3ddDGcNLqALhb/Bd1BBni
 Tp+6w1DE
 +zUjMqbh1TQrl75rnEmExZtP9wXvVij4Ej4O7gV3ARGSWLomvQZP+eS3gPmC+2RL8sMLBmQ2q1asBx5rlh9rgNFHlNe3kfNraz73BGf0mZkWuYA7NlM3oTl1sLZd0lDJGeljGUxCzcj0llyVuzzxsCj8glpPXa0nsI0dQ6xGfb3f7WQrdsy7c132ZgfI1I6J3xz7eL03B2dh/f9qz+sJXTiTJVccc2G+SAYYr+WimMUziSLbW9TPa0XRMX3RlUx75iom2KYtoTCMXVAsEVZLpYCuoP41XPRwkYD50wIPmQOsRZ6UGtYnwqwoX4gZlhvkp1eJcrQfGMwf4KhEbq9j/xkgItIFn4zPA6QjrCZMV/QkS97AAdgIVAWbitZaF+2t42GleP+Oh1yhEba1ftH9nsY6N9szklgvOFAHzAErFpr5ETzRQBqRnUiyRkgnlUNi51vCgzoBsu2Dw2diApi+DyxGVT6Pr//OhWhRF2v+VIwU4+b3NNk0JugctdBdoerrKBbcwpnLBf2MUjc8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/22/26 10:18 AM, Barry Song (Xiaomi) wrote:
> We may encounter cases where the system still has plenty of free
> memory, but cannot satisfy higher-order allocations. On phones, we
> have observed that bursty network transfers can cause devices to
> heat up. Baolin and Kairui have seen similar behavior on servers.
> 
> Currently, kswapd behaves as follows: when a higher-order allocation
> is issued with __GFP_KSWAPD_RECLAIM, pgdat_balanced() returns false
> because __zone_watermark_ok() fails if no suitable higher-order
> pages exist, even when free memory is well above the high watermark.
> As a result, kswapd_shrink_node() sets an excessively large
> sc->nr_to_reclaim and attempts aggressive reclamation:
> 
>   for_each_managed_zone_pgdat(zone, pgdat, z, sc->reclaim_idx) {
>   	sc->nr_to_reclaim += max(high_wmark_pages(zone), SWAP_CLUSTER_MAX);
>   }
> 
> We have an opportunity to re-evaluate the balance by resetting
> sc->order to 0 after shrink_node() with the following code
> in kswapd_shrink_node():
>   /*
>    * Fragmentation may mean that the system cannot be rebalanced for
>    * high-order allocations. If twice the allocation size has been
>    * reclaimed then recheck watermarks only at order-0 to prevent
>    * excessive reclaim.
>    */
>   if (sc->order && sc->nr_reclaimed >= compact_gap(sc->order))
>   	sc->order = 0;
> 
> But we have actually scanned and over-reclaimed far more than
> compact_gap(sc->order). If higher-order allocations continue, we may
> see persistently high kswapd CPU utilization coexisting with plenty of
> free memory in the system.
> 
> We may want to evaluate the situation earlier at the beginning.
> If there is plenty of free memory, we could avoid triggering
> reclamation with an excessively large sc->nr_to_reclaim value
> and instead prefer compaction.
> 
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Qi Zheng <zhengqi.arch@bytedance.com>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Kairui Song <kasong@tencent.com>
> Cc: Axel Rasmussen <axelrasmussen@google.com>
> Cc: Yuanchu Xie <yuanchu@google.com>
> Cc: Wei Xu <weixugc@google.com>
> Co-developed-by: Wang Lian <wanglian@kylinos.cn>
> Co-developed-by: Kunwu Chan <chentao@kylinos.cn>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---

Thanks Barry for sending out the RFC patch for discussion.

Yes, we have indeed seen reports from our customers' scenarios where 
fragmentation caused kswapd to be woken up and reclaim too many file 
folios (even when free memory was sufficient), leading to severe I/O 
contention that impacted some applications.

However, I'm concerned that this patch might also have side effects, 
such as affecting system defragmentation. In some scenarios, directly 
reclaiming clean pagecache to free up space might be a faster way to 
defragment. At the very least, I think under defrag_mode, we should be 
more aggressive about defragmentation (including reclaiming some memory 
by kswapd).

>   -RFC v1 was "mm: net: disable kswapd for high-order network
>    buffer allocation":
>   https://lore.kernel.org/linux-mm/20251013101636.69220-1-21cnbao@gmail.com/
> 
>   mm/vmscan.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index bd1b1aa12581..4f9668aa8eef 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -6964,6 +6964,13 @@ static bool pgdat_balanced(pg_data_t *pgdat, int order, int highest_zoneidx)
>   		if (__zone_watermark_ok(zone, order, mark, highest_zoneidx,
>   					0, free_pages))
>   			return true;
> +		/*
> +		 * Free pages may be well above the watermark, but if
> +		 * higher-order pages are unavailable, kswapd may still
> +		 * trigger excessive reclamation.
> +		 */
> +		if (order && compaction_suitable(zone, order, mark, highest_zoneidx))
> +			return true;
>   	}
>   
>   	/*


