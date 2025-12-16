Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9E00D5B87A
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 01:14:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 287E46B0088; Mon, 15 Dec 2025 20:14:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23B436B0089; Mon, 15 Dec 2025 20:14:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10A866B008A; Mon, 15 Dec 2025 20:14:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F3C856B0088
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 20:14:57 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 87E1E1A043E
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 01:14:57 +0000 (UTC)
X-FDA: 84223565034.22.A15EB81
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8421220011
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 01:14:52 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	spf=pass (imf13.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765847695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rIaynRH42+btC5EwIhZEBvDgBTKITnbY2p2hRHq+n+Y=;
	b=OqAj6SN1fmLoto3bUcMFqrGpwdm6L/IhuUttx53bBHJjcIjfOHKYzxTxEqqfjFq0Tcc8K3
	54NVpFKuzZwiRlI9tsMfr7Jq5YX4qBeer96UUMg7k3nhfofcXo2ZFUXszE4rXcydcivTa4
	7UiEIgCqml9w3i3EKS5oUv6xkFIJjA4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765847695; a=rsa-sha256;
	cv=none;
	b=w7KILvu0bpMG/iPBgaau+5YRXgb5oVGcPixlawmyZc/nELIPUvup5UwS0xzirUglu7ngws
	bAMuTGnXKNlu/OKxM0NFTJ50Z2sUq82qarkh0q8rw4YlHA+bR6waciSeCxyu+URdwggQdV
	C8IX7BDCO4jeCcyN9WDpcOlOWLUulQY=
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dVf8t6mWlzYQtkc
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 09:14:22 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 5684D1A01A6
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 09:14:47 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP4 (Coremail) with SMTP id gCh0CgAniPiFskBpmppbAQ--.30924S2;
	Tue, 16 Dec 2025 09:14:47 +0800 (CST)
Message-ID: <6c69c4d9-f154-4ad3-93c8-907fa4f98b27@huaweicloud.com>
Date: Tue, 16 Dec 2025 09:14:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next 3/5] mm/mglru: extend shrink_one for both lrugen and
 non-lrugen
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, david@kernel.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, corbet@lwn.net, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, zhengqi.arch@bytedance.com,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, lujialin4@huawei.com, zhongjinji@honor.com
References: <20251209012557.1949239-1-chenridong@huaweicloud.com>
 <20251209012557.1949239-4-chenridong@huaweicloud.com>
 <20251215211357.GF905277@cmpxchg.org>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <20251215211357.GF905277@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgAniPiFskBpmppbAQ--.30924S2
X-Coremail-Antispam: 1UD129KBjvJXoWxJw18ZFykuw4rtrW5AF1DJrb_yoWrur45pa
	9xJFyjyayrArnIgr9aqF4UW34a9w48Jr1xJryDur1rCF9aqFyrKw17CrW8urWUZr9Y9r13
	Ary2qw17Ww4jvFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWr
	XwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU0
	s2-5UUUUU==
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8421220011
X-Stat-Signature: e4ordybj7hhns954p79uazdf7zbfg8u4
X-HE-Tag: 1765847692-875483
X-HE-Meta: U2FsdGVkX19IR7oUL9yZRNpIz9UxQvGu9oapkK/ArsaUvjkW7nyC3sADecq4l/MMCpvLbfXL0mUpC9xi0fBx9RZW49SWs0oj7/IfGzB3ykFsaEHhNXBZxjReMVBbsAlTukgdZwT+3IADGIdrEWPaz14678sjMxeI7DL8yloRbUzqipRMLJOd5KPRhihNF47OfcisHMq2Tpq56z+gFBAjWT8GsfpLw1wCFdyZ13b162oY0Z/ph+aVYQmn84N+O9icpyhd1dIyJgn8R4q+KTezmqDRCQgRyqAjEn6d0Ecxr2Zjm+WGROIyOimZj0NMRV32cTQ2ZzT41h79J9t/95m3P0NTePmcV6PyT8RVrTFqAPRZ8vaj7/KP5fbL/pJ4w5sPiiCwrI41VZn3uQBX1LXZVsOWvMXL6iNqRNBmyubtZCPZLBi34lCFQm1aHJ+wTreIFvt2wypUrNLI445g32/XLP4RM9g2QD1zJ3cqy5UdKDM4ZThWL0l9zbZ9G0dmErFbaYPe9I4RJJHO0rWX9xpAXGzaeNTpK6GdJ9N4PbZLRzCAsX5csbNNWdN9FlVdrFQHOpdkIxMlDUBRVpfwpbCEms7JYEwfprggO7iv4FewRhemDRCL/cETBlp3B2TzV5ZtgE7z57vCb2SwHzVAL3aGeJ767iN3jluP760Yr5bHNQLSeJX8SMyw2RrbkXy3T4jDI5k6fvCfucGbJSTrAEY05k2RfrRmwZzPKUsqNidcIecp0usbleu2lyLgh1fJGj/StXy7SI9VMAYolx14UFW8V+BQ5AWKXQrb7XL3e+8ZfbvSUL7LHWfw6kk+8NybKboGF5d779o2r360eqQ2cmJgFHohl+xY5udFh7pyM8UnUYRN4AggtyIBfkKYxKBp/bB/Mo1Ct0HoRws+g1Y2YPVwemam1c3vmZT79cgEM0c6AM1ngvSiqBfNv3Izgbeh1IB1JzJKSbfGnc1TeVxW9Af
 7RBCJ1bx
 tDxEDHjF/Yim6PQTaOgszmnR8wc8RXGKdXtU7AbasxkUsjfjob31EWViR7CmGnV43R1h1ud6/0YVgh03qn89NP6rLqFhDhRuJXEQ1Ly0iVLXrYJSZOQJlXmlVgB/K81eBdoaYlQmQw0oOiz7WIcUk8IPmD7Nt1M/a24YniUYPH0wPAMvtOlLXpiM9Y0R1wKSTii6v
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/16 5:13, Johannes Weiner wrote:
> On Tue, Dec 09, 2025 at 01:25:55AM +0000, Chen Ridong wrote:
>> From: Chen Ridong <chenridong@huawei.com>
>>
>> Currently, flush_reclaim_state is placed differently between
>> shrink_node_memcgs and shrink_many. shrink_many (only used for gen-LRU)
>> calls it after each lruvec is shrunk, while shrink_node_memcgs calls it
>> only after all lruvecs have been shrunk.
>>
>> This patch moves flush_reclaim_state into shrink_node_memcgs and calls it
>> after each lruvec. This unifies the behavior and is reasonable because:
>>
>> 1. flush_reclaim_state adds current->reclaim_state->reclaimed to
>>    sc->nr_reclaimed.
>> 2. For non-MGLRU root reclaim, this can help stop the iteration earlier
>>    when nr_to_reclaim is reached.
>> 3. For non-root reclaim, the effect is negligible since flush_reclaim_state
>>    does nothing in that case.
>>
>> After moving flush_reclaim_state into shrink_node_memcgs, shrink_one can be
>> extended to support both lrugen and non-lrugen paths. It will call
>> try_to_shrink_lruvec for lrugen root reclaim and shrink_lruvec otherwise.
>>
>> Signed-off-by: Chen Ridong <chenridong@huawei.com>
>> ---
>>  mm/vmscan.c | 57 +++++++++++++++++++++--------------------------------
>>  1 file changed, 23 insertions(+), 34 deletions(-)
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 584f41eb4c14..795f5ebd9341 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -4758,23 +4758,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>>  	return nr_to_scan < 0;
>>  }
>>  
>> -static void shrink_one(struct lruvec *lruvec, struct scan_control *sc)
>> -{
>> -	unsigned long scanned = sc->nr_scanned;
>> -	unsigned long reclaimed = sc->nr_reclaimed;
>> -	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>> -	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>> -
>> -	try_to_shrink_lruvec(lruvec, sc);
>> -
>> -	shrink_slab(sc->gfp_mask, pgdat->node_id, memcg, sc->priority);
>> -
>> -	if (!sc->proactive)
>> -		vmpressure(sc->gfp_mask, memcg, false, sc->nr_scanned - scanned,
>> -			   sc->nr_reclaimed - reclaimed);
>> -
>> -	flush_reclaim_state(sc);
>> -}
>> +static void shrink_one(struct lruvec *lruvec, struct scan_control *sc);
>>  
>>  static void shrink_many(struct pglist_data *pgdat, struct scan_control *sc)
>>  {
>> @@ -5760,6 +5744,27 @@ static inline bool should_continue_reclaim(struct pglist_data *pgdat,
>>  	return inactive_lru_pages > pages_for_compaction;
>>  }
>>  
>> +static void shrink_one(struct lruvec *lruvec, struct scan_control *sc)
>> +{
>> +	unsigned long scanned = sc->nr_scanned;
>> +	unsigned long reclaimed = sc->nr_reclaimed;
>> +	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>> +	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>> +
>> +	if (lru_gen_enabled() && root_reclaim(sc))
>> +		try_to_shrink_lruvec(lruvec, sc);
>> +	else
>> +		shrink_lruvec(lruvec, sc);
> 

Hi Johannes, thank you for your reply.

> Yikes. So we end up with:
> 
> shrink_node_memcgs()
>   shrink_one()
>     if lru_gen_enabled && root_reclaim(sc)
>       try_to_shrink_lruvec(lruvec, sc)
>     else
>       shrink_lruvec()
>         if lru_gen_enabled && !root_reclaim(sc)
>           lru_gen_shrink_lruvec(lruvec, sc)
>             try_to_shrink_lruvec()
> 
> I think it's doing too much at once. Can you get it into the following
> shape:
> 

You're absolutely right. This refactoring is indeed what patch 5/5 implements.

With patch 5/5 applied, the flow becomes:

shrink_node_memcgs()
    shrink_one()
        if lru_gen_enabled
	    lru_gen_shrink_lruvec  --> symmetric with else shrink_lruvec()
		if (root_reclaim(sc))  --> handle root reclaim.
		    try_to_shrink_lruvec()
		else
		    ...
		    try_to_shrink_lruvec()
	else
	    shrink_lruvec()

This matches the structure you described.

One note: shrink_one() is also called from lru_gen_shrink_node() when memcg is disabled, so I
believe it makes sense to keep this helper.

> shrink_node_memcgs()
>   for each memcg:
>     if lru_gen_enabled:
>       lru_gen_shrink_lruvec()
>     else
>       shrink_lruvec()
> 

Regarding the patch split, I currently kept patch 3/5 and 5/5 separate to make the changes clearer
in each step. Would you prefer that I merge patch 3/5 with patch 5/5, so the full refactoring
appears in one patch?

Looking forward to your guidance.

> and handle the differences in those two functions? Then look for
> overlap one level down, and so forth.

-- 
Best regards,
Ridong


