Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08B6BC61DB4
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 10:40:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDC5C6B00AE; Tue, 25 Aug 2026 06:40:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB3B46B00BE; Tue, 25 Aug 2026 06:40:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF1226B00BF; Tue, 25 Aug 2026 06:40:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ACAE66B00AE
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 06:40:23 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 28CBF1203D6
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:40:23 +0000 (UTC)
X-FDA: 85139447526.26.8ADCCDE
Received: from mta1.migadu.com (out-70.mta1.migadu.com [95.215.58.70])
	by imf25.hostedemail.com (Postfix) with ESMTP id A08EFA0007
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:40:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dBOcOR09;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.70 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787654421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SIIA6zvrxZiJ0B5UZd3zzfBNUj3IfmAWwyMpLfTiAsw=;
	b=Y8MdBUf3hdwhc5Ii7b3LItl4chsAYWm0rVUBFL9116k3t3wnmYm/KvcrFdTWZjxN6b3D9u
	/Jl8oiWpjxOWW248W+YQEDQXxxkPzGOsEcD2Q217Si+eumsJRTDfV4cJDHg+NmEl4uUx2f
	apKu8ZBLeJlJ8jr6aBcEcRGxxDbBF3Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787654421;
	b=gAYugGJ1VIKzWIrmvZDb5Xnam3RHVpGYxkJwvbtvtuAMLIucTaXtZ7Jjau+6zPhM8YZ9rC
	NhSXt/mxdbcNRcHCQ6n84mT9Km4gJz6vWW2FQC4dfVcmR2NVMFHqrwSGAh7+Zq33tJdO20
	3A8T1wjugdRCw2SVk0MFYy/hFwkERxU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dBOcOR09;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.70 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=4HCdqaL2UsJl3vhnbCh80t3WyCZKmIVtpPQk8zrG2d0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787654419; v=1; x=1788259219;
 b=dBOcOR09+4/zZYWeFG/SjOn26eOzwP1JmzqHOiZBrVeAPoRm8ZuGTwBIZylKr5wUCGOwl+va
 mP3/eNbWWiQBoI0rek60AbnfG6mK54vw6x68EtHm9btgj7JuMmK0MhRPaKjn/h8Y9d+i3AQ8SDL
 NnhRLedgLxa9kaFZJLjtjROc=
X-Envelope-To: linux-mm@kvack.org
Received: from [100.82.85.74] (101.71.133.200)
	by smtp.migadu.com with ESMTPS id 22f5c38e0082be38;
	Tue, 25 Aug 2026 10:40:19 +0000
X-Mizu-Trace-ID: 22f5c38e0082be38
X-Migadu-Flow: FLOW_OUT
Message-ID: <5d60e20a-64cd-4ce5-bc8b-86f0c976e618@linux.dev>
Date: Tue, 25 Aug 2026 18:40:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 04/17] mm/sparse-vmemmap: initialize shared tail
 vmemmap pages on allocation
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
 David Laight <david.laight.linux@gmail.com>,
 "Liam R . Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Muchun Song <muchun.song@linux.dev>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
 <20260825084608.47437-5-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260825084608.47437-5-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: qz4n3cz8pxiayrb49mnrx79ctda57144
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A08EFA0007
X-HE-Tag: 1787654420-556798
X-HE-Meta: U2FsdGVkX191QISZ38/46GMTttKRu/cfCSX4xufWgsIe0FeOtJk8u+IyR2wq22MM2kU2OyFDfgiSS1y8roW+/lZnmMkKzfzAUmazP+A15nWAbFj8lHnqDaPxSpewIWmgXISn40vkdYWz9GpbvS+oe4hdGMWdveyC8mlOGa0EKd7s74JyVzEIv/+yvY5DKhBEWjmGnb+ZdIL9YO+Y740OwBs2yI0QvmI5jGNSymjKEPBhI3FoK+7YitfcYiDPrbVzGr55jojt2HWHk05vNDTlNLaxKZv/1Hm0T9V3GWTcIiDOvPvMi0AZ2zPqtN+sBD9ZNIKI9s0cZBTt/SMW+oXAlagTwBAQuNhJieXNCYdoBBMg5Xhw00GMbSPQ5dF841OMdfIJfPf+n9iayBMG6c0BLDhGd42iE+wlEhAjDkOmUbdnNpHCEUbK1e2wZ7EeS8/zsmQ0cBJusCWhEbrJm477hKHc/2AM32KEPhFvzkbBLZgnxsuds0tM/JBZboLmaa4huDfAOZ0zgaX6u9vk1qXRIN0dVhIQkq+Nn7LCd9cRoMjCtIFEWj9OEn5Hia5/rxOh3bBJFdN3JqWKA8IYt/Rkrkfw2qRGyv739M0/T249dqEiQvplygGXbhErf1GAFzEe2rrA1vdkCCNeQhlOhOhMqWpHF/wnuNLQFu46siaRMhLwAW18NobwRAO/8ZqsZg4RNRggnxtgXp8VeLBRhMPhSa0/RqvPGqFdKgq+OqVCu1cjnIbolHPlHGtNmlqHnBgNZE1LvDzKOPMs+xZ7cQqpV+s9BSR2Ln1esHWkqv3cK0vpSMpgrfxYpgGL4fFgBK5HQBqP/WDjYyofiU1dv9b8CJf857NgO5gVoxSbR+Wus8benigdd8GgRTvEmlapr0BWWnQPcC8u39IdHWGXNM1BXn3J2JECjDwXRb4QSbqk++pzID7/3VjWBa8Oa8T8U/jpw+b514Bn2SkXjkLu6KM
 9M6dfcbf
 j5KKml4nZbhsV3MbqwrWZpbg+oBcXAWYhenK4PlBso7PTJIS9drU6ghuMzBeHz+3zTvoh9tWqGVPJyuMo+TVqC43w+Oer/hHMas6LQMyk7aazbkFXZOGkosEJmyFcdbtXXIP4YCF9ChQpFWRkh4CWuO1noQmX6wWl5tMZddsbX1FS1+fGUgUVe+v6q4do9iu6lbBBbZzoKk3+Zxb9ZX6Q6KZraaxERQWSqNNQP1WoB9fcOlkub7uluwk6e8LAR0K0xlhY2/A7c3WU0xjnTh3dzhJudsdqaqpKB8lx5cbeBhTKu/qGgw5NAfY35DwMb+cvVsWmIUSetpO42uQe+6I8Zy6T6sP96+A/m2qKIlK2Y5sd7GLRWW+fhmfqHY6whdiGRhf/Off5tU+1EvEPKS+k46JVPi+I9ZJUrbfV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/25/26 4:45 PM, Muchun Song wrote:
> The shared tail vmemmap page allocated in vmemmap_get_tail() used to be
> left uninitialized, because memmap_init_range() would later overwrite
> it.  That forced users such as HugeTLB to defer the initialization to
> their own setup paths.
> 
> Now that memmap_init_range() skips shared tail vmemmap pages, initialize
> them immediately in vmemmap_get_tail() with init_compound_tail()
> instead.
> 
> This moves the initialization to the point where the shared tail page is
> allocated and avoids relying on deferred handling in individual users.
> The remaining deferred initialization in HugeTLB will be removed once it
> switches to the section-based vmemmap optimization mechanism.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>   mm/sparse-vmemmap.c | 12 ++----------
>   1 file changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index aa6a4a2fae98..107215cf8488 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -338,19 +338,11 @@ static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *
>   	tail = zone->vmemmap_tails[idx];
>   	if (tail)
>   		return tail;
> -
> -	/*
> -	 * Only allocate the page, but do not initialize it.
> -	 *
> -	 * Any initialization done here will be overwritten by memmap_init().
> -	 *
> -	 * hugetlb_bootmem_struct_page_init() will take care of initialization
> -	 * after memmap_init().
> -	 */
> -
>   	p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
>   	if (!p)
>   		return NULL;
> +	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
> +		init_compound_tail(p + i, NULL, order, zone);

Until section->order is set, vmemmap_optimizable_pfn() (introduced by
patch #3) will always return false. As a result, the initialization here
won't actually take effect until patch #10.

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi

>   
>   	tail = virt_to_page(p);
>   	zone->vmemmap_tails[idx] = tail;


