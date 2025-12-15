Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77A80D41D74
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 07:38:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A51046B0006; Mon, 15 Dec 2025 02:38:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A01846B0007; Mon, 15 Dec 2025 02:38:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F0246B0008; Mon, 15 Dec 2025 02:38:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 75D076B0006
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 02:38:32 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E5E13140E69
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 07:38:31 +0000 (UTC)
X-FDA: 84220902822.01.5882D10
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1290E40007
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 07:38:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	spf=pass (imf04.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765784310; a=rsa-sha256;
	cv=none;
	b=caoMZ/pGvnhkR5F0NaKx63JrOQ2zfyEt3kehHm7cw5JC5kbd0CIM59K/0/IWVnlP28qGsK
	gvPACo1xk3RUgVUOKlREmDOj2AsmpB1RDCqOOq0mkejXg5nBHK4EQFuaQvgDg7DF6HAFOn
	OpYlGnbn/eYzxjAVRYQ0ZeLUMvLnAuQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765784310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dFBLUyUvGjBsuLLQvurq7Q9RL06UN9yGTtA1H8tq3v4=;
	b=gnC2xVgRm6Q4att7m/YBxeR3sCmBQp9FSVPA8xHeo/b3o1y5bYjR7lfOG9D5lcqgWrXg1k
	nfUReEwufTAzhjI4t11MA8NOEx+nUJ+mJTn7d+VbCzOgV5oS4GxJQPVIoRTHuEQ3gJOZ27
	3+r/CjzgMHgFM7zFLqa9Jnm5BLH7L2M=
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dVBjy18l7zYQtrL
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:37:58 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 5297C1A01A3
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:38:21 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP1 (Coremail) with SMTP id cCh0CgBHtOnpuj9pnAsAAQ--.24033S2;
	Mon, 15 Dec 2025 15:38:18 +0800 (CST)
Message-ID: <3edf7d6a-5e32-45f1-a6fc-ca5ca786551b@huaweicloud.com>
Date: Mon, 15 Dec 2025 15:38:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] mm/memcontrol: make lru_zone_size atomic and simplify
 sanity check
To: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org,
 Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: Kairui Song <kasong@tencent.com>
References: <20251215-mz-lru-size-cleanup-v1-1-95deb4d5e90f@tencent.com>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <20251215-mz-lru-size-cleanup-v1-1-95deb4d5e90f@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgBHtOnpuj9pnAsAAQ--.24033S2
X-Coremail-Antispam: 1UD129KBjvJXoWxuF48Xr1ktw1DXw17KryxAFb_yoWrCr4rpF
	ZIka40yFZ5ZryY93sFya1Dua4fZa1xKayfJr9rWw1UAr1aq3Zaq34UKr4fuFWUAr95GF4a
	qF90gFW8C3yYvrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8
	ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1
	7KsUUUUUU==
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspam-User: 
X-Rspamd-Queue-Id: 1290E40007
X-Rspamd-Server: rspam10
X-Stat-Signature: 39bhseuk8uykxs1x5inccyte5uxosnje
X-HE-Tag: 1765784306-62848
X-HE-Meta: U2FsdGVkX1/GnfpMKPRuCow367BDbP4yZyWmh+wN43gKgAAjtQh985FoCAp/w1WUzlqWfSWCXFCELtYZwuuQbcJoE2wYijoqg51f+kSTT6hLeu4ZNmLYl5ROkTVAzuvNIFg8jKIgRaWUTi+ibpZLhZUXRP0pTnhhjLzcofbwuvnWFu1ZG+HB8tSv0JXyJbk0iQ/+14L0CvuZc16Egicb/zfJwLLEAjTtWHt4eBYIJxJdayzLdEAPH0D2TUepk7fBIhim63tG/VqTqVziOdO4VUyhpOrHm+hcMkNuNKV2ki7b9wQU9k0Yk5c2TXyH1ZsSMMD1W/E9VqIQ/jZxMbulIi/bUHLDBgc+7Y12nowp5DPMY7RhnG7ck7N5htaEp1w2+l6i0YEdNT9SiPOksio762N9sLUt4KVLdjhw3pftN6hd46HxdukkPbYLlpwAdg5bOyupXzZ7g7pKgc8CVyF/0ExXR/gpUqC14qutZI2MrRI9WMvcxEJDjjVv464F48IEKq6GdHDIropZMu506sbilt06vh+YKzO+ml2Gc1EtQR5aDYPcqEpxb0BQBuyEBiV9Wn4HcgEg0IOXJ6bsdsJI0exvZZ5tDfv0mo8V6ul0gxx+3bPCuN5jZMhUR3AugIYZds8K1WM7mK6VduJ09qPu9Ui60XGKbI/7T+d86DutyD9wNDFZbQAdOLftorrPOOXZ/EUJH9dz41v2HMX/+ghsfnOoh+GCV9gL6rOVIOFIF63bbISQbtVfGUGoUHI6QxUurJ4/BGK7jmSAUNRHlw8e6Dqw3abT7GgaTJbi3lFMQsDqYg5UsDR0wJY/v669JkAgxoYzkc9lxlg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/15 14:45, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> commit ca707239e8a7 ("mm: update_lru_size warn and reset bad lru_size")
> introduced a sanity check to catch memcg counter underflow, which is
> more like a workaround for another bug: lru_zone_size is unsigned, so
> underflow will wrap it around and return an enormously large number,
> then the memcg shrinker will loop almost forever as the calculated
> number of folios to shrink is huge. That commit also checks if a zero
> value matches the empty LRU list, so we have to hold the LRU lock, and
> do the counter adding differently depending on whether the nr_pages is
> negative.
> 
> But later commit b4536f0c829c ("mm, memcg: fix the active list aging for
> lowmem requests when memcg is enabled") already removed the LRU
> emptiness check, doing the adding differently is meaningless now. And if

Agree.

I did submit a patch to address that, but it was not accepted.

For reference, here is the link to the discussion:

https://lore.kernel.org/lkml/CAOUHufbCCkOBGcSPZqNY+FXcrH8+U7_nRvftzOzKUBS4hn+kuQ@mail.gmail.com/

> we just turn it into an atomic long, underflow isn't a big issue either,
> and can be checked at the reader side. The reader size is much less
> frequently called than the updater.
> 
> So let's turn the counter into an atomic long and check at the
> reader side instead, which has a smaller overhead. Use atomic to avoid
> potential locking issue. The underflow correction is removed, which
> should be fine as if there is a mass leaking of the LRU size counter,
> something else may also have gone very wrong, and one should fix that
> leaking site instead.
> 
> For now still keep the LRU lock context, in thoery that can be removed
> too since the update is atomic, if we can tolerate a temporary
> inaccurate reading, but currently there is no benefit doing so yet.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/memcontrol.h |  9 +++++++--
>  mm/memcontrol.c            | 18 +-----------------
>  2 files changed, 8 insertions(+), 19 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 0651865a4564..197f48faa8ba 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -112,7 +112,7 @@ struct mem_cgroup_per_node {
>  	/* Fields which get updated often at the end. */
>  	struct lruvec		lruvec;
>  	CACHELINE_PADDING(_pad2_);
> -	unsigned long		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
> +	atomic_long_t		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
>  	struct mem_cgroup_reclaim_iter	iter;
>  
>  #ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
> @@ -903,10 +903,15 @@ static inline
>  unsigned long mem_cgroup_get_zone_lru_size(struct lruvec *lruvec,
>  		enum lru_list lru, int zone_idx)
>  {
> +	long val;
>  	struct mem_cgroup_per_node *mz;
>  
>  	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
> -	return READ_ONCE(mz->lru_zone_size[zone_idx][lru]);
> +	val = atomic_long_read(&mz->lru_zone_size[zone_idx][lru]);
> +	if (WARN_ON_ONCE(val < 0))
> +		return 0;
> +
> +	return val;
>  }
>  
>  void __mem_cgroup_handle_over_high(gfp_t gfp_mask);
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 9b07db2cb232..d5da09fbe43e 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1273,28 +1273,12 @@ void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
>  				int zid, int nr_pages)
>  {
>  	struct mem_cgroup_per_node *mz;
> -	unsigned long *lru_size;
> -	long size;
>  
>  	if (mem_cgroup_disabled())
>  		return;
>  
>  	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
> -	lru_size = &mz->lru_zone_size[zid][lru];
> -
> -	if (nr_pages < 0)
> -		*lru_size += nr_pages;
> -
> -	size = *lru_size;
> -	if (WARN_ONCE(size < 0,
> -		"%s(%p, %d, %d): lru_size %ld\n",
> -		__func__, lruvec, lru, nr_pages, size)) {
> -		VM_BUG_ON(1);
> -		*lru_size = 0;
> -	}
> -
> -	if (nr_pages > 0)
> -		*lru_size += nr_pages;
> +	atomic_long_add(nr_pages, &mz->lru_zone_size[zid][lru]);
>  }
>  
>  /**
> 
> ---
> base-commit: 1ef4e3be45a85a103a667cc39fd68c3826e6acb9
> change-id: 20251211-mz-lru-size-cleanup-c81deccfd5d7
> 
> Best regards,

-- 
Best regards,
Ridong


