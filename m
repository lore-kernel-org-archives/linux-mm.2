Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0DB6CD98E4
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 03:04:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 501996B0088; Sun, 21 Jun 2026 23:04:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B2406B008A; Sun, 21 Jun 2026 23:04:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C7F46B008C; Sun, 21 Jun 2026 23:04:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0D9706B0088
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 23:04:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 61FD7166CDD
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 03:04:24 +0000 (UTC)
X-FDA: 84906055248.12.2986022
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf21.hostedemail.com (Postfix) with ESMTP id 11F7F1C0003
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 03:04:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=wqr9jtKQ;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782097462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gdVeD2YQ+4emLsNSDcMg53zBGqzDXufzRzbIKHc1Gs8=;
	b=vRWUuoH7Sg7Tgr8y54RBfp8Kh8SxYUUJzI/PetFa4UU1wIJ8HASXeI6wS02ZJEz8zTmXWk
	j0ts4blzCo6FZk1JQKfroNiACQit1IklEb14OJK4sVGaeq05MUli8+SeTW+AzOrn5h630J
	3vMGLpl4qVyvB0Yiar3GAwZOf+6MKCs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=wqr9jtKQ;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782097462;
	b=6rcf6pslW1IsqpZ4IhkiuKVqz1NS6k4R9IInAm/grdIzIFXej8/heMbaWnl/Rgy06kEWOy
	/7iFMlEW/1p48wGpfuGXrcCqrqIaF0l1BegkBr6ZfOq9iUTIc+OPq1XW1v1Huf2ShrMz04
	MM/QuqqaRQBSU+a5LZ8aEouIptoRkVY=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782097458; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=gdVeD2YQ+4emLsNSDcMg53zBGqzDXufzRzbIKHc1Gs8=;
	b=wqr9jtKQoHbmvSTo9Zy1fhgbDMaxlAYEltFn200kmYmCLk2MLnBpSpNPCbvQ2q7JI8Zkf7kxqRT+OrydUamTQLIqO6ZsRKTV9j0SuFLASnPGNLLbDpQzIDdz6MQ7XVeQyKMfUpLKvZraQgEARFqzmFpcHzKVO1wQtw8DAoanT9o=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0X5GfpWi_1782097455;
Received: from 30.74.144.120(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X5GfpWi_1782097455 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 22 Jun 2026 11:04:16 +0800
Message-ID: <6e89f868-ca7a-484f-aeea-5d8d029714f2@linux.alibaba.com>
Date: Mon, 22 Jun 2026 11:04:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: Avoiding split large folios if swap has no space
To: "Barry Song (Xiaomi)" <baohua@kernel.org>, david@kernel.org
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, dev.jain@arm.com,
 kasong@tencent.com, lance.yang@linux.dev, liam@infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 npache@redhat.com, qi.zheng@linux.dev, ryan.roberts@arm.com,
 shakeel.butt@linux.dev, weixugc@google.com, yuanchu@google.com,
 zhaonanzhe@xiaomi.com, ziy@nvidia.com
References: <5790c4a4-d502-4180-82f5-47de5809a4fe@kernel.org>
 <20260620081017.89085-1-baohua@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260620081017.89085-1-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 11F7F1C0003
X-Stat-Signature: uat5pz5fhefe4p9d4d6axzpzj5h1imsj
X-Rspam-User: 
X-HE-Tag: 1782097460-202686
X-HE-Meta: U2FsdGVkX1+KueIpnREQzVUMCMtSykDt69vPcgcEbR9/wd/4gZQdwxSEZKCkCzCdTzNPFiJ1LbJMHTZBmjBH5MQN4KlvyvsA7OPRH+I3nmVvX8wNYjpv0IW33NxH4jTsiP/CeTewJXhKwUekX5KKRWYWcnPIQE+2dtiJamJIeaLJYMvbvS3LCX9qnHTNvwKbMb3MPSi6tGX2ctiQkmXMfuQtOGGABd13Pvidseb62w7Mok1ykcy6MT30EOrmFh8HRzEo7udTmXaM3IYSmZuqPGLkJREOQprupdpCcDq6bCo/LP15SjneW7G4Hd2gMOx9LUaF7fBIiecLZc0m4m2DnIbsmojj4a1jy72fmpT1N/rdc82CXTjMQFIaXuZH6kJatnqCJbIloR5gSFCCFcDl2tfWo5XosqaBsaB/UIGmgREYVihY4cIlgGZk5/b/fuv7hcWuh9+w4vsk9zeBI07PVCGn0tUjekkyVGOqRETJrX0RcKtA+zY6U5OuWwt0z9FBl5dW5IZlKpMdqMIIu8PR8aqunBHXMm9TCD9osbrkcG+ESLmHCcoJCiyxay22GtTDXGxlGbGnds8M/lv+9ERgeqc5+5aFfrctRNhO5ageZ441G4Lc+g5htJKAZiXHVnimgc6CmElkOsQDVRsrhkvTLtALZvmzfkT8sPdytkEvXTZWRNwP5YFSroeoe4CvMwgx5TYvwLVahfq0bS9rXg0GDFifQkiCKJdctfum276cWxHBCUoPBoDwi/C75vk9H7asfzbZrRX7BwrSVT1v0rY7JzQ80zkr9cp5WWPNXYuTJKEcAXL7wWgU8KgLrVHRLxwJMHtEW5xfXmJGCipxDnInnJviDC03Bz7X5bZC2M2TkVC/ddQSkczO09/dyrIPeB/GvmJvDHkXnLSLS/JdSzuk+srqPgAgeJExX99Fi8Hx/w3pyppmgWFAYVZli0iutOG+qD0JAU119s19BauktpR
 nE3O6JPS
 ByvBM/2s9RsPdPfDfMRjVmSqyHYKjS0b930BRnVQid26uetniqAwORmVGj6HYg9hgFbLI/2XTikv7XHs9k58SFf4bf62olbVSbpDtwiS0hI/R8EOAthmjWvF+qqKrxAHZBGoiLzXcb40aEGvW8CrugdGDGrCbPP3gif20Rkq5BjIPygGufFN9eOq39xGZR77anddN7E7XSLeRvdcFf/3RZIJMzTKpXjvxyWChC19uPilTn+nd6JS0IkWTkrwM8nCf5AebtyCLBiaDiQBHj3XOYMhv48eflgfgZNMYZw9IE7H/8ARg/AFJWXGE6ADfbJmEXcQJmjkVuMPoW/8cT+E5Vn2mbxFzbr1BEShjn+3w6apmOI8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/20/26 4:10 PM, Barry Song (Xiaomi) wrote:
> On Fri, Jun 19, 2026 at 10:04 PM David Hildenbrand (Arm) <david@kernel.org> wrote:
> [...]
>>>        /*
>>>         * The page can not be swapped.
>>>         *
>>> @@ -1280,6 +1289,8 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
>>>
>>>                                if (!folio_test_large(folio))
>>>                                        goto activate_locked_split;
>>> +                             if (!__can_reclaim_anon_pages(memcg, sc))
>>> +                                     goto activate_locked_split;
>>
>> Why are we even trying to allocate swap space if we cannot reclaim such pages?
>> Makes we wonder whether we would want to have that check earlier, before the
>> folio_alloc_swap().
>>
>> Any downsides?
> 
> I don't think there are any obvious downsides there. One issue is that
> the memcg may not be passed from reclaim_pages(), so memcg would
> always be NULL. However, the folio could still belong to a memcg
> whose swap quota has been exhausted. In that case, my
> __can_reclaim_anon_pages() will fail when checking whether we can
> swap out. But switching to folio_memcg() also seems awkward.
> 
> So I feel Kairui’s suggestion [1] might be the best approach. In
> folio_alloc_swap(), we return -EAGAIN to tell vmscan.c that
> we can split the folio and retry the swap-out.
> only when there are sufficient swap slots and sufficient memcg swap
> quota do we return -EAGAIN, allowing vmscan to perform a split.
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 78b49b0658ad..62e2c506ccae 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1755,6 +1755,9 @@ int folio_alloc_swap(struct folio *folio)
>   			VM_WARN_ON_ONCE(1);
>   			return -EINVAL;
>   		}
> +
> +		if (get_nr_swap_pages() < (1 << order))
> +			return -ENOMEM;

Shouldn't this return -EAGAIN? Suppose we try to swap out an order-9 
large folio but get_nr_swap_pages() returns 256, then we'd still need to 
split the order-9 large folio to reclaim some memory.

>   	}
>   
>   again:
> @@ -1769,11 +1772,13 @@ int folio_alloc_swap(struct folio *folio)
>   	}
>   
>   	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
> -	if (unlikely(mem_cgroup_try_charge_swap(folio)))
> +	if (unlikely(mem_cgroup_try_charge_swap(folio))) {
>   		swap_cache_del_folio(folio);
> +		return -ENOMEM;
> +	}
>   
>   	if (unlikely(!folio_test_swapcache(folio)))
> -		return -ENOMEM;
> +		return -EAGAIN;
>   
>   	return 0;
>   }
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 299b5d9e8836..63e8578454ea 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1257,6 +1257,8 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
>   		 */
>   		if (folio_test_anon(folio) && folio_test_swapbacked(folio) &&
>   				!folio_test_swapcache(folio)) {
> +			int ret;
> +
>   			if (!(sc->gfp_mask & __GFP_IO))
>   				goto keep_locked;
>   			if (folio_maybe_dma_pinned(folio))
> @@ -1275,10 +1277,10 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
>   				    split_folio_to_list(folio, folio_list))
>   					goto activate_locked;
>   			}
> -			if (folio_alloc_swap(folio)) {
> +			if ((ret = folio_alloc_swap(folio))) {

Also, please give shmem some love (shmem also calls folio_alloc_swap() 
when swapping out) :)

