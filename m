Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EA07E6B26B
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 01:01:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3B086B0088; Mon, 22 Dec 2025 20:00:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC7DA6B0089; Mon, 22 Dec 2025 20:00:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF4AB6B008A; Mon, 22 Dec 2025 20:00:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AE3776B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 20:00:59 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2A6E1C08E4
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 01:00:59 +0000 (UTC)
X-FDA: 84248931438.12.9CD29B7
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5370CC0004
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 01:00:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	spf=pass (imf22.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766451657; a=rsa-sha256;
	cv=none;
	b=XRgrfP5bzgMmYJ2w+4Ttoi6gFFMjWOlSbNC7cgeg7mEGESioKHVB2dLr/Sy7QhxYqJc392
	YVHZ+jVJcQt2LB71/f56/SVTFX8BjtoGd1aEURqyrUGnTy5UMmPbkk4ItsCL9ax4KVbEWo
	iLvG9BsBBV66tEMzdaQEmgdGP74/NDM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766451657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fIOF/yeujThf0GlPbWdXphuM+F15C/kDhTZvUX3cLSQ=;
	b=v1YYtvrrRBrYG9vf5dijbLzqxCXFXzJ1esUJ3qtzyhyiJYmdcyq+RUiyo2/VEHQ0vNRJgB
	wRyUBZwOHX0jVDQsEXm0h75Sw1vQvly6hpIEQzAczgqNUE//A0RLQxHmERAa11LPpjiSse
	1Q1Nhyn5EgKtE3LRqQiA6JlQjI5NY/g=
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dZxWJ73d9zYQtfr
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 09:00:12 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 25FEF40576
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 09:00:49 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP4 (Coremail) with SMTP id gCh0CgBH9va_6Ulp6keYBA--.39397S2;
	Tue, 23 Dec 2025 09:00:48 +0800 (CST)
Message-ID: <135f565e-b660-4773-8f98-fcbef9772f42@huaweicloud.com>
Date: Tue, 23 Dec 2025 09:00:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next 3/5] mm/mglru: extend shrink_one for both lrugen and
 non-lrugen
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, akpm@linux-foundation.org,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 david@kernel.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 corbet@lwn.net, roman.gushchin@linux.dev, muchun.song@linux.dev,
 zhengqi.arch@bytedance.com, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, lujialin4@huawei.com,
 zhongjinji@honor.com
References: <20251209012557.1949239-1-chenridong@huaweicloud.com>
 <20251209012557.1949239-4-chenridong@huaweicloud.com>
 <20251215211357.GF905277@cmpxchg.org>
 <6c69c4d9-f154-4ad3-93c8-907fa4f98b27@huaweicloud.com>
 <7kwk3bkvhvflsyxgljnxzvrxco2u2rxjcdwqooeboyrkf2oxjj@2nywxl2sc6g5>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <7kwk3bkvhvflsyxgljnxzvrxco2u2rxjcdwqooeboyrkf2oxjj@2nywxl2sc6g5>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgBH9va_6Ulp6keYBA--.39397S2
X-Coremail-Antispam: 1UD129KBjvJXoW3AF1DGw43Kry5KrW7tF1DJrb_yoW7trWrpa
	9xJFyjyayrZrnIgr9aqF4jg3sIvw48Jr1IqryDWw1rCFnaqFyrKF17CrWUuFy8ZrWF9r17
	Jry7Xw17W3yFvFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5370CC0004
X-Stat-Signature: ba1uhy6kp3rsqb4qtoncc9tgdwg3enme
X-HE-Tag: 1766451652-350013
X-HE-Meta: U2FsdGVkX18Y3KxDTtSKcaD52yM7Xo7211V9A9Rb+2lyVX3j0TPPmppFD7Sy3Ih2T+gwuXdd6tiUCpAWDPaH0Zo+o9JumKYHkZHk/l5nLQieKEzFwpGf/P06VoEOE7NuRf3vbCqY2ZuAO8f38Up+BSEU2HzRNCmy708Kbc8AhITWcuT2Sunw29Rz38OJ40N7QiiiRYjgNoFHxycDI/AhqQ6GspSdv5nnpEx2I7Ps+Qvf2SibSB1OU1VtIh/DTTrTGC+iNQfeYI1MCynORLNTGarlVntVPw4ZqYSqboVcdpHQzMdX95BamMoQruVdXYtxq9jE5SeNbeePElbYWzRIPPJR0fRmrtiB9IoWdpefjBWZiIDA2EmIO3krNTcCUNfK6BmOy+vonIciUxcctilkX995WtMjw7h/EPX9hK+p+2jKir8h2GklTJC0R7fy+9bAJyIyq9F4FuAEAUb/wld05HqIs3aKkcpjRNIgA9dL6Q+0twY5ZiZ+z7g3MIh43Nk32Lb/oRLLpjd8TPwshUImyOnE1S4lVIC5FBTmc5jV93EdcZ+KN9LvJpXjCb+B1ivQONK1xdQuXD8N3ZKqp7ycOrXJ3LqvWPhOyU3VYuvkFuUbRy0Q/qYzCeYFojuF8HO6FnuK4Um5CPiRf3SwjdBCiClUK8OE+99ORQ5YQKgpDKmtXWGaQEkGGN7S6NStoIpFC/nghfBK5aeHz1yyTnRUXQ/4L+ncl46XmxavCqH41myXdtOTNOqNjHVQOZwHqQvjiO7oM1dRmdkId0yhXJoJ9zRO3H93vKunW4mxrkCayhtibRFaac30FcZrHsyY+/4iF106R7EqnF61boSlIDgZ6eG7fF5FIqp6FCRoL4K+5wzQubd+78V2N6qTOpjunOcLqdcvnE6bdIgZYZ0iBvUc+Sz61SmMGFDbMhYYt302W2BmYiNGxY4D/1BcDP7zgJRyqvvRBUzm5CUHLV31+Y1
 b56xv5FB
 vDI/WNOSSXH6hkJOeG2TSkAQAgnN0lFb992GHQdJ2Hzqoz16x84bf6z9nlxxJB6hC6iDON2TBmnBMghANmHCGpyiQ7HaQN2a/iGE/S+c7ln25am2prYe3H7trghF4kuma37nbBmiIQz55Pz/meGEYaI6KQlTIEfAmLWJfje9dcqq4w1+bgZJOdiRHYppNhpLEGE28
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/23 5:36, Shakeel Butt wrote:
> On Tue, Dec 16, 2025 at 09:14:45AM +0800, Chen Ridong wrote:
>>
>>
>> On 2025/12/16 5:13, Johannes Weiner wrote:
>>> On Tue, Dec 09, 2025 at 01:25:55AM +0000, Chen Ridong wrote:
>>>> From: Chen Ridong <chenridong@huawei.com>
>>>>
>>>> Currently, flush_reclaim_state is placed differently between
>>>> shrink_node_memcgs and shrink_many. shrink_many (only used for gen-LRU)
>>>> calls it after each lruvec is shrunk, while shrink_node_memcgs calls it
>>>> only after all lruvecs have been shrunk.
>>>>
>>>> This patch moves flush_reclaim_state into shrink_node_memcgs and calls it
>>>> after each lruvec. This unifies the behavior and is reasonable because:
>>>>
>>>> 1. flush_reclaim_state adds current->reclaim_state->reclaimed to
>>>>    sc->nr_reclaimed.
>>>> 2. For non-MGLRU root reclaim, this can help stop the iteration earlier
>>>>    when nr_to_reclaim is reached.
>>>> 3. For non-root reclaim, the effect is negligible since flush_reclaim_state
>>>>    does nothing in that case.
>>>>
>>>> After moving flush_reclaim_state into shrink_node_memcgs, shrink_one can be
>>>> extended to support both lrugen and non-lrugen paths. It will call
>>>> try_to_shrink_lruvec for lrugen root reclaim and shrink_lruvec otherwise.
>>>>
>>>> Signed-off-by: Chen Ridong <chenridong@huawei.com>
>>>> ---
>>>>  mm/vmscan.c | 57 +++++++++++++++++++++--------------------------------
>>>>  1 file changed, 23 insertions(+), 34 deletions(-)
>>>>
>>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>>> index 584f41eb4c14..795f5ebd9341 100644
>>>> --- a/mm/vmscan.c
>>>> +++ b/mm/vmscan.c
>>>> @@ -4758,23 +4758,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>>>>  	return nr_to_scan < 0;
>>>>  }
>>>>  
>>>> -static void shrink_one(struct lruvec *lruvec, struct scan_control *sc)
>>>> -{
>>>> -	unsigned long scanned = sc->nr_scanned;
>>>> -	unsigned long reclaimed = sc->nr_reclaimed;
>>>> -	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>>>> -	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>>>> -
>>>> -	try_to_shrink_lruvec(lruvec, sc);
>>>> -
>>>> -	shrink_slab(sc->gfp_mask, pgdat->node_id, memcg, sc->priority);
>>>> -
>>>> -	if (!sc->proactive)
>>>> -		vmpressure(sc->gfp_mask, memcg, false, sc->nr_scanned - scanned,
>>>> -			   sc->nr_reclaimed - reclaimed);
>>>> -
>>>> -	flush_reclaim_state(sc);
>>>> -}
>>>> +static void shrink_one(struct lruvec *lruvec, struct scan_control *sc);
>>>>  
>>>>  static void shrink_many(struct pglist_data *pgdat, struct scan_control *sc)
>>>>  {
>>>> @@ -5760,6 +5744,27 @@ static inline bool should_continue_reclaim(struct pglist_data *pgdat,
>>>>  	return inactive_lru_pages > pages_for_compaction;
>>>>  }
>>>>  
>>>> +static void shrink_one(struct lruvec *lruvec, struct scan_control *sc)
>>>> +{
>>>> +	unsigned long scanned = sc->nr_scanned;
>>>> +	unsigned long reclaimed = sc->nr_reclaimed;
>>>> +	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>>>> +	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>>>> +
>>>> +	if (lru_gen_enabled() && root_reclaim(sc))
>>>> +		try_to_shrink_lruvec(lruvec, sc);
>>>> +	else
>>>> +		shrink_lruvec(lruvec, sc);
>>>
>>
>> Hi Johannes, thank you for your reply.
>>
>>> Yikes. So we end up with:
>>>
>>> shrink_node_memcgs()
>>>   shrink_one()
>>>     if lru_gen_enabled && root_reclaim(sc)
>>>       try_to_shrink_lruvec(lruvec, sc)
>>>     else
>>>       shrink_lruvec()
>>>         if lru_gen_enabled && !root_reclaim(sc)
>>>           lru_gen_shrink_lruvec(lruvec, sc)
>>>             try_to_shrink_lruvec()
>>>
>>> I think it's doing too much at once. Can you get it into the following
>>> shape:
>>>
>>
>> You're absolutely right. This refactoring is indeed what patch 5/5 implements.
>>
>> With patch 5/5 applied, the flow becomes:
>>
>> shrink_node_memcgs()
>>     shrink_one()
>>         if lru_gen_enabled
>> 	    lru_gen_shrink_lruvec  --> symmetric with else shrink_lruvec()
>> 		if (root_reclaim(sc))  --> handle root reclaim.
>> 		    try_to_shrink_lruvec()
>> 		else
>> 		    ...
>> 		    try_to_shrink_lruvec()
>> 	else
>> 	    shrink_lruvec()
>>
>> This matches the structure you described.
>>
>> One note: shrink_one() is also called from lru_gen_shrink_node() when memcg is disabled, so I
>> believe it makes sense to keep this helper.
> 
> I think we don't need shrink_one as it can be inlined to its callers and
> also shrink_node_memcgs() already handles mem_cgroup_disabled() case, so
> lru_gen_shrink_node() should not need shrink_one for such case.
> 
I think you mean:

shrink_node
    lru_gen_shrink_node
    // We do not need to handle memcg-disabled case here,
    // because shrink_node_memcgs can already handle it.
	shrink_node_memcgs
	    for each memcg:
	        if lru_gen_enabled:
		    lru_gen_shrink_lruvec()
		else
		    shrink_lruvec()
	    shrink_slab(sc->gfp_mask, pgdat->node_id, memcg, sc->priority);
	    if (!sc->proactive)
		vmpressure(...)
	    flush_reclaim_state(sc);

With this structure, both shrink_many and shrink_one are no longer needed. That looks much cleaner.
I will update it accordingly.

Thank you very much.

>>
>>> shrink_node_memcgs()
>>>   for each memcg:
>>>     if lru_gen_enabled:
>>>       lru_gen_shrink_lruvec()
>>>     else
>>>       shrink_lruvec()
>>>
> 
> I actually like what Johannes has requested above but if that is not
> possible without changing some behavior then let's aim to do as much as
> possible in this series while keeping the same behavior. In a followup
> we can try to combine the behavior part.
> 
>>
>> Regarding the patch split, I currently kept patch 3/5 and 5/5 separate to make the changes clearer
>> in each step. Would you prefer that I merge patch 3/5 with patch 5/5, so the full refactoring
>> appears in one patch?
>>
>> Looking forward to your guidance.

-- 
Best regards,
Ridong


