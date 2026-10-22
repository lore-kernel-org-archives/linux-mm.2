Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BAB3606A31B
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 11:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=ObOTgVLE
Received: by kanga.kvack.org (Postfix)
	id 773BF6B0912; Thu, 22 Oct 2026 07:26:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74B396B0914; Thu, 22 Oct 2026 07:26:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 662086B0915; Thu, 22 Oct 2026 07:26:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 324BB6B0912
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 07:26:38 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 26E831C4127
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 11:26:36 +0000 (UTC)
X-FDA: 85350034392.17.BE48635
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf01.hostedemail.com (Postfix) with ESMTP id C26BB4000A
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 11:26:32 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ObOTgVLE;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792668394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wjJzAk76F+CxMgpyPLvq57N3yZotfosVsROZyeNCQWc=;
	b=xRU36EJYlD4l0/LNvZJkSBr7RpA6YdzB3AWvRjFXAEIqciAAr/kVc44Xx+8aVXAJIc7Hiw
	dsO9QBCkjqVY29lETMHDbelzyyr3qnpCf5BZSdWcTwCUxLriP3Gbk6tqxCdedEBTEBr5Ge
	CCXi2/s+DdATjXGsuT50BaKyQttPrVk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ObOTgVLE;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792668394;
	b=13aZ2WVefjxcHdl/gm8RCDpyys1g46Tv9EniPcr0soIldtLSt31ISmzHpaAlGJOTo/Kmdg
	iQ6qiDzp+cV5t4hQRARfWIVOj+Z3y9Q8oNTlUW3azna5PI71rc46JBQNB5c7DcmM8DCNrK
	wq4vNs4Ph0IqCbRZUF6u5vYRcNHZQHU=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792668388; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=wjJzAk76F+CxMgpyPLvq57N3yZotfosVsROZyeNCQWc=;
	b=ObOTgVLEL3GpiCLOj3TkwzlRr3AQ4UUpjR2Xp3MW7SddfjRhhr/8K0Hv0JjGTrRo7eIbn08nQzaIOj/XGyJiSiCVYpX0+mCXjhipvcvrxgvKx8IuXNoSThSJwyQ1VvlzdYhmzUVA1PainOb4jNZDw/AWpjqmhw4FhNM3pnW1nS4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R261e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0XDJ5s7r_1792668386;
Received: from 30.74.144.160(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDJ5s7r_1792668386 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 22 Oct 2026 19:26:27 +0800
Message-ID: <fc302ca3-6bf6-4bde-b3e8-8d2e93a4e4ac@linux.alibaba.com>
Date: Thu, 22 Oct 2026 19:26:25 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2] mm: vmscan: avoid anon scanning for GFP_NOIO with
 low swapcache in MGLRU
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com,
 baoquan.he@linux.dev, david@kernel.org, hannes@cmpxchg.org,
 kasong@tencent.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 liuxiang.277@bytedance.com, ljs@kernel.org, mhocko@kernel.org,
 qi.zheng@linux.dev, shakeel.butt@linux.dev, weixugc@google.com,
 yuanchu@google.com, zhangbo56@xiaomi.com
References: <0cbd219d-f69d-4f72-aec5-43e1f2d978de@linux.alibaba.com>
 <20261022102726.56682-1-baohua@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261022102726.56682-1-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C26BB4000A
X-Stat-Signature: ad3uhwfpbozchycx64a7h4qejqehzw7d
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792668392-901617
X-HE-Meta: U2FsdGVkX1/Me0K0zEubctcH3QgnhoDhXis4vVK68IwKV/8dfKJRwZ8q00gux8vBiuGVys5fjzzB50qubUpRCyIFCwjpuBdkPhZ3osLanXnkY8inGbxyNwu6BfaZ5J3FLXL+GNEi/eBnGjbWktvYp4gExdOK4S8I4CTgNxeN9KI9UVKtRQBUHpHSkNt+6WO+o+WBwMA4tNJ79D552mchxfIuIzmjcxw6DoskLyq0gn6seWeLFG2DsEvDFJgPBkiwV9UQU2jSv65l1FhH2oBR0hPYyuQxPpV1tjDx2A4vlGd69U6F0lUwhFqzGW4fZ2tZE/XKO3ftpX36jHvnYyzzgU2y/X5UqVB2a50Hy80A9eJqnf4S9kVy1WDflt6CIVfEFALgRif+GKhfJ1sHMh/yhAIN6IoMGzMAC9urH2FMayFVuHt8YqVci+P6rYiLvsyStO1Nv2Y60oCJNzcA1Uhz/nNwFZ1Q3xo9qEOog+BTYnv94bvvvdSwfgcmZrld/mO4sGcQN3Gf3G6xSNsPtwrhHO/4mhVN996OB3CiasT7GtsGAzxO1cso1W7iSNPZNuHxp4PndB4jC00R8BV5eUzFGhrfsrrsxQqzgpXweR/GbCwgStW8sTeYtevr94tKoUe6Nx0tl72jkDbQIIcfWnlluF7APKtZXpBg5n4CO/3mnsLpnsdHphxk+ejMUXg2CpQg7IAHs9QGQKx3RIK/f/KxGGcMR/tlR7CyR5HABdL1HLr+mVjXezAJd0MPYMCLjLamSom96zjHKN4DNZ/bLgF9iHYH8XIlqfL/i9uEm3KioxUh9slG80FOuO65I9akmzY9x64FkcyZuiicZ5OzIlbK1FX1HEfOx1Ff0WW1U7krY4eLcLGVO0h43lWdlBGJIPn2eft2A7tHkiX0JxqZD2swmv9Sok6UlV2qkOLgcFkUmrkyhLo1DjpQxUx+Q3zAb3eSPhLlYdJmRUST1CsUjfM
 USZoWJ4P
 yZEUph+bxufJpbTo5cuk/brwXhWIx7LVKN1sAMBhVMLdkhzBEIBsUHbKlf3jQ6wUsO3I7RxjGbLCwM0RiGrcwtYjuZzTy6yS+muGRQwsG+yHcb5EoGOw/HSEQ7wzR6z23HOl/EhH9hvvc0vEFLK7ysAB1b5mF0uFvBACRP+148MgyXyAu6uVx2lNXI46wFZ7OU3YM/fx4G+F1YYN9lhhtHDDmFS7DPgeWrtrUUzB078l3Nviex5VvlatTChGKJ6vOqqE7EWZqhXbXresU1OtzgLMxwaZ6HLJnOJC9LZSl47Q+RTXlrklLZUqK1CpID3RRaUNBT39uYlDjEquV7mc9HukFKsRWyQ3l/z25jSkkIHh2Zrqoj6lU2seksg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/22/26 6:27 PM, Barry Song (Xiaomi) wrote:
> On Thu, Oct 22, 2026 at 4:49 PM Baolin Wang <baolin.wang@linux.alibaba.com> wrote:
>>
>>
>>
>> On 10/22/26 5:55 AM, Barry Song wrote:
>>> On Wed, Oct 21, 2026 at 3:28 PM Baolin Wang
>>> <baolin.wang@linux.alibaba.com> wrote:
>>> [...]
>>>
>>>>>     static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *sc)
>>>>>     {
>>>>>         unsigned long total;
>>>>>         int swappiness = get_swappiness(lruvec, sc);
>>>>>         struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>>>>>
>>>>> +     swappiness = get_scan_swappiness(lruvec, sc, swappiness);
>>>>> +
>>>>>         total = lruvec_evictable_size(lruvec, swappiness);
>>>>>
>>>>>         /* whether the size is big enough to be helpful */
>>>>> @@ -5249,9 +5265,10 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>>>>>         bool need_rotate = false, should_age = false;
>>>>>         long nr_batch, nr_to_scan;
>>>>>         int swappiness = get_swappiness(lruvec, sc);
>>>>> +     int scan_swappiness = get_scan_swappiness(lruvec, sc, swappiness);
>>>>
>>>> IMO, 'swappiness' and 'scan_swappiness' are really confusing. Why move
>>>> this logic into get_swappiness()? In get_swappiness(), we already have
>>>> some similar logic to adjust swappiness when there is no available swap
>>>> space.
>>>>
>>>
>>> Yes. It is very confusing. we can't do that in get_swappiness() as otherwise,
>>> we will get cold/hot inversion due to GFP_NOIO. for a real swappiness=0,
>>> we allow cold/hot inversion for anon, but for GFP_NOIO, this is not the
>>> case.
>>
>> But can_reclaim_anon_pages() doesn't only handle the GFP_NOIO case, it
>> also covers the swap space limitation scenario. The latter is what
>> concerns me more.
>>
>> If we're only talking about the GFP_NOIO case, I'd agree with your
>> concern. However, we could introduce a helper to force anon aging and
>> add comments explaining why we need this. That would look more
>> maintainable than 2 confusing swappiness variables, no?
>>
>> Just my 2 cents.
>>
>> Something like below (untested):
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index daa7e37c2236..7c1d26e6b9d7 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -2890,7 +2890,7 @@ static int get_swappiness(struct lruvec *lruvec,
>> struct scan_control *sc)
>>           if (swappiness == SWAPPINESS_ANON_ONLY)
>>                   return swappiness;
>>
>> -       if (!sc->may_swap)
>> +       if (!sc->may_swap || !(sc->gfp_mask & __GFP_IO))
>>                   return 0;
> 
> For GFP_NOIO, we should also check whether swapcache is low, since
> GFP_NOIO can reclaim swapcache. We already have
> reclaimable_anon_is_low() for this.

Ah, yes, just a quick sample to show what I had in mind. :). Sould also 
consider reclaimable_anon_is_low() for the GFP_NOIO case.

>>           if (!can_demote(pgdat->node_id, sc, memcg) &&
>> @@ -4049,7 +4049,7 @@ static inline void flush_lru_batch(struct
>> list_head *head, struct list_head **ba
>>           *batch_end = NULL;
>>    }
>>
>> -static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
>> +static bool inc_min_seq(struct lruvec *lruvec, int type, int
>> swappiness, bool force_anon_aging)
>>    {
>>           int zone;
>>           int remaining = MAX_LRU_BATCH;
>> @@ -4063,7 +4063,7 @@ static bool inc_min_seq(struct lruvec *lruvec, int
>> type, int swappiness)
>>                   goto done;
>>
>>           /* For anon type, skip the check if swappiness is zero (file
>> only) */
>> -       if (!type && !swappiness)
>> +       if (!type && !swappiness && !force_anon_aging)
>>                   goto done;
>>
>>           VM_WARN_ON_ONCE(get_nr_gens(lruvec, type) != MAX_NR_GENS);
>> @@ -4183,7 +4183,20 @@ static void try_to_inc_min_seq(struct lruvec
>> *lruvec, int swappiness)
>>           }
>>    }
>>
>> -static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int
>> swappiness)
>> +static bool is_force_anon_aging(struct scan_control *sc, struct lruvec
>> *lruvec,
>> +               int swappiness)
>> +{
>> +       if (swappiness || (sc->gfp_mask & __GFP_IO))
>> +               return false;
> 
> As above, GFP_NOIO doesn't imply swappiness=0 if there are many
> swapcache folios to reclaim. So we should check
> reclaimable_anon_is_low() here.
> 
>> +
>> +       /*
>> +        * Explain why we neeed to force increase anon min seq.
>> +        * xxxxxx
>> +        */
>> +       return swappiness != sc_swappiness(sc, lruvec_memcg(lruvec));
>> +}
>> +
>> +static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int
>> swappiness, bool force_anon_aging)
>>    {
>>           bool success;
>>           int prev, next;
>> @@ -4205,7 +4218,7 @@ static bool inc_max_seq(struct lruvec *lruvec,
>> unsigned long seq, int swappiness
>>                   if (get_nr_gens(lruvec, type) != MAX_NR_GENS)
>>                           continue;
>>
>> -               if (inc_min_seq(lruvec, type, swappiness))
>> +               if (inc_min_seq(lruvec, type, swappiness, force_anon_aging))
>>                           continue;
>>
>>                   lruvec_unlock_irq(lruvec);
>> @@ -4249,7 +4262,7 @@ static bool inc_max_seq(struct lruvec *lruvec,
>> unsigned long seq, int swappiness
>>    }
>>
>>    static bool try_to_inc_max_seq(struct lruvec *lruvec, unsigned long seq,
>> -                              int swappiness, bool force_scan)
>> +                              int swappiness, bool force_scan, bool
>> force_anon_aging)
>>    {
>>           bool success;
>>           struct lru_gen_mm_walk *walk;
>> @@ -4260,7 +4273,7 @@ static bool try_to_inc_max_seq(struct lruvec
>> *lruvec, unsigned long seq,
>>           VM_WARN_ON_ONCE(seq > READ_ONCE(lrugen->max_seq));
>>
>>           if (!mm_state)
>> -               return inc_max_seq(lruvec, seq, swappiness);
>> +               return inc_max_seq(lruvec, seq, swappiness,
>> force_anon_aging);
>>
>>           /* see the comment in iterate_mm_list() */
>>           if (seq <= READ_ONCE(mm_state->seq))
>> @@ -4295,7 +4308,7 @@ static bool try_to_inc_max_seq(struct lruvec
>> *lruvec, unsigned long seq,
>>           } while (mm);
>>    done:
>>           if (success) {
>> -               success = inc_max_seq(lruvec, seq, swappiness);
>> +               success = inc_max_seq(lruvec, seq, swappiness,
>> force_anon_aging);
>>                   WARN_ON_ONCE(!success);
>>           }
>>
>> @@ -5262,7 +5275,9 @@ static bool try_to_shrink_lruvec(struct lruvec
>> *lruvec, struct scan_control *sc)
>>                   }
>>
>>                   if (should_run_aging(lruvec, max_seq, sc, swappiness)) {
>> -                       if (try_to_inc_max_seq(lruvec, max_seq,
>> swappiness, false))
> 
> This is quite tricky. If we pass swappiness=0, anon aging will be
> skipped. Do we want that for GFP_NOIO cases? I mean, these are not
> real cases where anon aging should be disabled.

No, we have real use cases where 'vm_swappiness' is set to 0, which 
means the workload never reclaims anon folios. So in this case we don't 
need to age anon folios.
> static int should_skip_vma(unsigned long start, unsigned long end, struct mm_walk *args)
> {
>          ...
>          if (vma == get_gate_vma(vma->vm_mm))
>                  return true;
>          ...
> }
> 
>> +                       bool force_anon_aging = is_force_anon_aging(sc,
>> lruvec, swappiness);
> 
> Adding a force_anon_aging argument to inc_max_seq() seems like
> quite a burden. Maybe a cleaner approach is to pass sc all the
> way to inc_max_seq() and let it detect GFP_NOIO cases itself?

OK, still look good to me.

> BTW, I guess we don't need to worry about swappiness at all. We can
> simply bypass anon reclaim?
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index fc823fe3bd1f..fa6d9860156d 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4903,6 +4903,8 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   	int skipped = 0;
>   	unsigned long remaining = nr_to_scan;
>   	struct lru_gen_folio *lrugen = &lruvec->lrugen;
> +	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
> +	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>   
>   	VM_WARN_ON_ONCE(nr_to_scan > MAX_LRU_BATCH);
>   	VM_WARN_ON_ONCE(!list_empty(list));
> @@ -4910,6 +4912,9 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   	if (get_nr_gens(lruvec, type) == MIN_NR_GENS)
>   		return 0;
>   
> +	if (!type && reclaimable_anon_is_low(memcg, pgdat->node_id, sc))
> +		return 0;
> +
>   	gen = lru_gen_from_seq(lrugen->min_seq[type]);
>   
>   	for (i = MAX_NR_ZONES; i > 0; i--) {
> @@ -5164,12 +5169,19 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
>   			     struct scan_control *sc, int swappiness)
>   {
> +	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
> +	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>   	DEFINE_MIN_SEQ(lruvec);
>   
>   	/* have to run aging, since eviction is not possible anymore */
>   	if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_seq)
>   		return true;
>   
> +	/* run aging when GFP_NOIO limits anon reclaim with few swapcache folios */
> +	if (swappiness && min_seq[LRU_GEN_FILE] + MIN_NR_GENS > max_seq &&
> +	    reclaimable_anon_is_low(memcg, pgdat->node_id, sc))
> +		return true;

I've considered this, but we'd still need to add some code in 
get_nr_to_scan()/lruvec_is_sizable() to filter out the anon folios for 
GFP_NOIO case. Rather than spreading the logic across multiple places, 
I'd prefer adding a helper with proper comments to handle the aging 
issue, like the sample code I showed.

