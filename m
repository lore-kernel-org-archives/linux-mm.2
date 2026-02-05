Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BC19E9D3F3
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 05:53:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 547476B0099; Thu,  5 Feb 2026 00:53:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51EF66B009B; Thu,  5 Feb 2026 00:53:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 448056B009D; Thu,  5 Feb 2026 00:53:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 31E2C6B0099
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 00:53:26 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D3CF6160405
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 05:53:25 +0000 (UTC)
X-FDA: 84409335570.15.9AFB89E
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	by imf20.hostedemail.com (Postfix) with ESMTP id EAE0F1C0003
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 05:53:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Dpf+gDvi;
	spf=pass (imf20.hostedemail.com: domain of usamaarif642@gmail.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770270804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iZkQCAZc4aOUYGMOWyP4b/GxoSCdG2JdZhnubn5ATyM=;
	b=vxfiT5ZtQLD7Twtu6QgKdmf969GwGPwmIKa9NOJRg+e8WwDF4mqXBEYQxJu8RV+891LfXd
	hlfxcovEpwwC3SA3gNJbwfJ76KJPRQt4WpoDlZLtV+UOgecQp6sTiTtQU2zXQZ3vxV8GQ4
	lRDBRf/aJilRqRmbc0MM2UU7ROJ0OB0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Dpf+gDvi;
	spf=pass (imf20.hostedemail.com: domain of usamaarif642@gmail.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770270804; a=rsa-sha256;
	cv=none;
	b=1hbB2eCmx/7VOocwlwRaVkLBe5xukgTiPagjg3G037MowBEhFTvLUcazFg/YDfEP7IpLsy
	SSMOVNI+mcjTaAq0C2FOTRqtHElrRy8P+hcH9mlMVfS2crH2eaQBmhJf3zvgdziJZynF4i
	5qCADkRCh/JR35fP5VLITbzoXIVTtbg=
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-2b729f4c154so866019eec.0
        for <linux-mm@kvack.org>; Wed, 04 Feb 2026 21:53:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770270803; x=1770875603; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iZkQCAZc4aOUYGMOWyP4b/GxoSCdG2JdZhnubn5ATyM=;
        b=Dpf+gDviIqpZjWCNwJpSfCVXXkMvyzGsuP5i/BFdK9sQfcoRUjL9ywSuMYoHFzzBc6
         eUieJv/f/S0dXEIL4PWFwvCMqQCPs9nNeIJaMwN/PlIc0ykMAMESNIljY20wVV11aXIg
         Guzwh+1/DZMTWf9d18pw/xNih8KEQGd5QdOYlUJeUDHbG/68Ibuao5cIZjFsakdwWwvt
         iXcda9QpL0Zv4NCTKFaxaUzAl7dmY+jf4K81tl0BdtiOKlR726MlgBmWfDsF28Vj27Yp
         lPHLli6zvDD923IG/6XUrGIumMSnZJBadtbCXjmmDuSzJKfeUSrFEAk/h+Yes52lDQ4m
         1JdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770270803; x=1770875603;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iZkQCAZc4aOUYGMOWyP4b/GxoSCdG2JdZhnubn5ATyM=;
        b=gl1JjSKo+VnIs1EGwsLHdM8Qv47VCOpetLDDPFune5RpKFa7+e3cnkFtuG+Zj8/qZ7
         PJK3nstLPLyNv89pbTGQqPGuZBpuFJOjpTSQxytqrwOy/2fOnOggb8tTtvfhdEi4oI6q
         /mB0uFaHlTIW4cjbFTDcSd+jSWDZF+WJD1KjUTp3/az1n7WUn0dl2Uweg/5Xml1YMSQQ
         2L1Db6IJGg949AO5Krl63b2pwowqS5wxO3BdyAwNLqhhETpMcvzrBZYIVDxbvH2zjz6H
         0WVhRmiwxgjtQCMG39WK5dhMPiNdJ0Dat4qwVNUhbrdIDFbQE4PtQBof+ktlSw3schoV
         LGNQ==
X-Forwarded-Encrypted: i=1; AJvYcCU8jBKIkn/d5BbO1dav5jVi5eXuetztxo8EeONoDPlzzJH8Or50b40ul2v5Snq1SMlwewANd5mj6g==@kvack.org
X-Gm-Message-State: AOJu0Yw0/Ereod4xz6/kI16uYt7pdI9DmJh9bMC4E13ZO6r4q1QEnGxx
	JPLVgKxd2zJjdnDBZ0EaurHigLh+T9IE0LtYqtZxFkWdUtGFqvP47mBI
X-Gm-Gg: AZuq6aLRtNknYuQZDoZ5i39YBJt9F0v0XCZZMjJL5G82v2MONa8t6e+D+0iUW7PRyP9
	7JojhrH8sZG17E+uiASjOCsNrLI/Kldbuc+b/BD0GDfUlJe/s9P8xqDgpP92dd+rG1n2CC3xFvA
	rApCdHvSH/P1/AFbxzXae0wIFNAWXwmnzJMl6lQZ/EdzdiggNEOkRtrO55Yvm9hGRv0TxMNRsd1
	hq0ej2upQyWGIB59TrRO8uMeI39E/RzWTXHVdnM7XUKgp+CX527o2IZ/sGB8SmqnaLvxc4A8F/Z
	/kMeSBT9Tu7kgETGVkdKwmNu0BRam6NTAptmWssKeTwnlQ51LfSSS79WLQ2nbu0erTvaPzA1Oa6
	glknyJdvKzHLx7cD+QxZ1X/wZFle+WQVaOh/Td8FLMn4wT+jGRhyPcu72Fq4eATrqkmhsRLNBGK
	poMhtZT4+0z6tP7etJBGj837lLpHhcaWPp4g==
X-Received: by 2002:a05:7301:678a:b0:2a4:3593:646a with SMTP id 5a478bee46e88-2b832a56456mr2841583eec.26.1770270802562;
        Wed, 04 Feb 2026 21:53:22 -0800 (PST)
Received: from [10.36.158.92] ([50.175.227.221])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b832e4c9c1sm2988962eec.10.2026.02.04.21.53.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Feb 2026 21:53:22 -0800 (PST)
Message-ID: <0bd16d42-8f55-4965-ba21-9d7fa6ecbdd7@gmail.com>
Date: Wed, 4 Feb 2026 21:53:21 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 02/12] mm/thp: add mTHP stats infrastructure for PUD THP
Content-Language: en-GB
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: ziy@nvidia.com, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
 hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev,
 kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, lance.yang@linux.dev,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260202005451.774496-1-usamaarif642@gmail.com>
 <20260202005451.774496-3-usamaarif642@gmail.com>
 <a2f775f3-b966-47ce-8e67-699582b2f0ac@lucifer.local>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <a2f775f3-b966-47ce-8e67-699582b2f0ac@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: ij3b5s5rpzsqr7qmtqdam994oqt3k6kb
X-Rspamd-Queue-Id: EAE0F1C0003
X-Rspam-User: 
X-HE-Tag: 1770270803-77945
X-HE-Meta: U2FsdGVkX1+6BX3zRKNXEhd4F9W/O21rzu8NGDrLuYDW+re16mabapHuaUzPruJ5/dnE/KVJbYlsaUmfE8ciuM1FwjhERZHwCYDa5z3ik2PJMIBFSWPpJDV4ztOhxa5Npqz+cOgcQi6thu8kSsmTp6rugPeFCK/Jy8fb37TtK2xiWdhPDQDjxlFpxZrmejKUFcm2BVwQQiKpegkhSfZMQWBZeEkxLRy82GZoKXswuTO3BauirpFF+Rxfx4qxtGTwooJxBV8g1p0tix/Lb5ho9hWFPIV/FghNxOv2I9b/fYWFekr+Z3162+0mBr4w7Z1Pq2zTARmm8irFA7x+dZ/tcEGKpe15KWg0CcO16qEZsl+iNWWTSdqKS6ygjHAJoBM/6eUIuX85+In/wzaG1YlDQjeEKh9aq2Cp2aa8L71b7FP7plScSQApHAgKry9ujfGefspMLxJIwCsfUg82BZ79cQNaXCqa8q5TRFfXxrf9XfCzRtnXLsWAZBSq0QK4vurCuXxZ8yzQQu6hQqbSs/dy0eJTbtO9HXiUDQp4jYQ5RYDIV8fmSGHBDO217EFZp9/mm49O50YsjKhNUimnZO5RnXe5XDxlU8pnPZjzUb3ZABczqGPoLRKlj9hujN8xkDrFhjGp0RzBwWUtv85iRMkIKX/QtOfTAG3pWf03rVRNN9ZWSckpVAHJyiHx3eeRtcs9tFBdlG51IekH2buL/GbgGv4kEvDWZ4C++uJGF5c6cRPkgyEkAllSRWho/yYPV1Cgx7RU8YrpixDrrjqoCXghjqSJ+qB7iKLLD2AtUNCnOH7OPM8lATpEEtPiY48UOm1dw/LMdmNC7zMZwi9d4AIs4GJWfJ/RkNN2w3PR916S7fw16EEvCfwEYDZOmBkAbQr44Mbd+HGVoD7HRH6+dSrq+tRy3QpKhFCrehi0cDCd/pJ7YV18rnwAL7iQa9KZVlO1xWQnNeHT1PZFWK9UpQn
 FZI0pvHT
 Itvo+fMO6iH1CPop2FHHLx7WX3zyB0rQ6IXccGiRfElTqYL4OAY76PkWjH2WVybCiWwXAXmGTE4gWam1m0l80cvs4Y/6M3oqdgpNdKS6jQ33JbC8vt+B9QpXQyTW9BeYFIZpuKSYvjXOnQSYFPW5SJqn5YRlqcvY7dILL+KDXonVv2Req38y9sTTxKak2nlgTVWxO2q7RZYICg3Pc5pRyyK3wwViI3eoWuE1+DmwPxUO1+6JJy2wD5zfVo9RBbUU80LC6B+mG7PSPFZe7x9oHPVoktNAsjWd3NsziYYDQ+yqnT0TDoxZ9Vc5A/kGUBcbpsBB6aa98kv95eJ1MdVBIUSK+HKbIiHCR6nMjLnN+YpNn/ZhkxMhlAUIiAWA2Dql+0KTo1NO8/JdcPOAr5biQbjjKoVgsnq2pvGIWvQhwNj05fzEByf54pAVKx7ktVbbiIYqk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 02/02/2026 03:56, Lorenzo Stoakes wrote:
> On Sun, Feb 01, 2026 at 04:50:19PM -0800, Usama Arif wrote:
>> Extend the mTHP (multi-size THP) statistics infrastructure to support
>> PUD-sized transparent huge pages.
>>
>> The mTHP framework tracks statistics for each supported THP size through
>> per-order counters exposed via sysfs. To add PUD THP support, PUD_ORDER
>> must be included in the set of tracked orders.
>>
>> With this change, PUD THP events (allocations, faults, splits, swaps)
>> are tracked and exposed through the existing sysfs interface at
>> /sys/kernel/mm/transparent_hugepage/hugepages-1048576kB/stats/. This
>> provides visibility into PUD THP behavior for debugging and performance
>> analysis.
>>
>> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
> 
> Yeah we really need to be basing this on mm-unstable once Nico's series is
> landed.
> 
> I think it's quite important as well for you to check that khugepaged mTHP works
> with all of this.
> 
>> ---
>>  include/linux/huge_mm.h | 42 +++++++++++++++++++++++++++++++++++++----
>>  mm/huge_memory.c        |  3 ++-
>>  2 files changed, 40 insertions(+), 5 deletions(-)
>>
>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>> index e672e45bb9cc7..5509ba8555b6e 100644
>> --- a/include/linux/huge_mm.h
>> +++ b/include/linux/huge_mm.h
>> @@ -76,7 +76,13 @@ extern struct kobj_attribute thpsize_shmem_enabled_attr;
>>   * and including PMD_ORDER, except order-0 (which is not "huge") and order-1
>>   * (which is a limitation of the THP implementation).
>>   */
>> -#define THP_ORDERS_ALL_ANON	((BIT(PMD_ORDER + 1) - 1) & ~(BIT(0) | BIT(1)))
>> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
>> +#define THP_ORDERS_ALL_ANON_PUD		BIT(PUD_ORDER)
>> +#else
>> +#define THP_ORDERS_ALL_ANON_PUD		0
>> +#endif
>> +#define THP_ORDERS_ALL_ANON	(((BIT(PMD_ORDER + 1) - 1) & ~(BIT(0) | BIT(1))) | \
>> +				 THP_ORDERS_ALL_ANON_PUD)
> 
> Err what is this change doing in a 'stats' change? This quietly updates
> __thp_vma_allowable_orders() to also support PUD order for anon memory... Can we
> put this in the right place?
> 

Yeah I didnt place it in the right place. Thanks!

>>
>>  /*
>>   * Mask of all large folio orders supported for file THP. Folios in a DAX
>> @@ -146,18 +152,46 @@ enum mthp_stat_item {
>>  };
>>
>>  #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && defined(CONFIG_SYSFS)
>> +
>> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> 
> By the way I'm not a fan of us treating an 'arch has' as a 'will use'.
> 
>> +#define MTHP_STAT_COUNT		(PMD_ORDER + 2)
> 
> Yeah I hate this. This is just 'one more thing to remember'.
> 
>> +#define MTHP_STAT_PUD_INDEX	(PMD_ORDER + 1)  /* PUD uses last index */
>> +#else
>> +#define MTHP_STAT_COUNT		(PMD_ORDER + 1)
>> +#endif
>> +
>>  struct mthp_stat {
>> -	unsigned long stats[ilog2(MAX_PTRS_PER_PTE) + 1][__MTHP_STAT_COUNT];
>> +	unsigned long stats[MTHP_STAT_COUNT][__MTHP_STAT_COUNT];
>>  };
>>
>>  DECLARE_PER_CPU(struct mthp_stat, mthp_stats);
>>
>> +static inline int mthp_stat_order_to_index(int order)
>> +{
>> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
>> +	if (order == PUD_ORDER)
>> +		return MTHP_STAT_PUD_INDEX;
> 
> This seems like a hack again.
> 
>> +#endif
>> +	return order;
>> +}
>> +
>>  static inline void mod_mthp_stat(int order, enum mthp_stat_item item, int delta)
>>  {
>> -	if (order <= 0 || order > PMD_ORDER)
>> +	int index;
>> +
>> +	if (order <= 0)
>> +		return;
>> +
>> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
>> +	if (order != PUD_ORDER && order > PMD_ORDER)
>>  		return;
>> +#else
>> +	if (order > PMD_ORDER)
>> +		return;
>> +#endif
> 
> Or we could actually define a max order... except now the hack contorts this
> code.
> 
> Is it really that bad to just take up memory for the order between PMD_ORDER and
> PUD_ORDER? ~72 bytes * cores and we avoid having to do this silly dance.


So up until a few hours before I sent the series. What you are saying is exactly what
I was doing, i.e. allocating up until PUD order. Its not a lot of memory wastage,
but it is there, and I saw this patch as an easy solution to it. For a server
with 512 cores, this is 36KB. Its not a lot because a server with 512 cores will
also have several 100GBs or TBs of memory.

I know its not elegant, but I do like the approach in this patch more. If there is a
very strong preference to switch to having all order to PUD as it would the make the
code more elegant, than I can switch to it.

> 
>>
>> -	this_cpu_add(mthp_stats.stats[order][item], delta);
>> +	index = mthp_stat_order_to_index(order);
>> +	this_cpu_add(mthp_stats.stats[index][item], delta);
>>  }
>>
>>  static inline void count_mthp_stat(int order, enum mthp_stat_item item)
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 3128b3beedb0a..d033624d7e1f2 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -598,11 +598,12 @@ static unsigned long sum_mthp_stat(int order, enum mthp_stat_item item)
>>  {
>>  	unsigned long sum = 0;
>>  	int cpu;
>> +	int index = mthp_stat_order_to_index(order);
>>
>>  	for_each_possible_cpu(cpu) {
>>  		struct mthp_stat *this = &per_cpu(mthp_stats, cpu);
>>
>> -		sum += this->stats[order][item];
>> +		sum += this->stats[index][item];
>>  	}
>>
>>  	return sum;
>> --
>> 2.47.3
>>


