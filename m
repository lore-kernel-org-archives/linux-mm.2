Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B45E3CDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 06:24:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90EB56B00F8; Fri, 26 Jun 2026 02:24:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E6746B00FA; Fri, 26 Jun 2026 02:24:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FB756B00FB; Fri, 26 Jun 2026 02:24:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5836A6B00F8
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 02:24:45 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B92481C27FD
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 06:24:44 +0000 (UTC)
X-FDA: 84921075288.14.3BF44D5
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf05.hostedemail.com (Postfix) with ESMTP id D39B010000E
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 06:24:42 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SCHSdyuL;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782455083;
	b=Kl5kcYT60oxkqMNZk+IQ3ke5gPjVKws3FndYgqQrxuBC8XAP5KKotNJma+PervgMWSbu8F
	Pm9E7BXIsJIM5vlYoAD99h5tb5y5Pi//umue+RirIMSvGOOP+GFCdZOFgW6yOq+rMvinGG
	ctB1Y4xVJn1blDF3TUDzxaqlvJbxQc0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782455083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NgoXI/pWvN7GuJPUblNOuG55t1D6HkoC5HdaKGAVlw0=;
	b=Vn8z9Kc02SUcYv5ukyCWf7gf1ThfpQmNsSPMhKg/8aDVE6dEJAhj+nFg3WiGchMkcjFKgT
	0W0iEqSO8p0S/WqlV560JDrpSVv0/zGyknmTRcFfodTChloBIw7K+U/XaDyNinXn0kqGND
	qz6gehBvtlkaO2qYaNWH20TPqVrFPQw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SCHSdyuL;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <90fd5300-1016-42e7-abad-08ad85fb62b4@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782455079;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NgoXI/pWvN7GuJPUblNOuG55t1D6HkoC5HdaKGAVlw0=;
	b=SCHSdyuL3by3xzeUqlOpn5GvFi4n0Njtp7RwEDm2r/Afz/A856RT3d7CtPhFyZm2PnhQr/
	5JTnSnAZCirA9DjvwjvTbWEpPbIq4+iZzwWVGRWXFM3CrmNb6woZjfmpK2QcO0p/mmpUYo
	lS+NbkXXIQ04p2idLRZn2mDke96fKD0=
Date: Fri, 26 Jun 2026 14:24:17 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3] mm: mglru: fix stale batch updates after memcg
 reparenting
To: Harry Yoo <harry@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>
Cc: akpm@linux-foundation.org, david@kernel.org, kasong@tencent.com,
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, muchun.song@linux.dev,
 peiyang_he@smail.nju.edu.cn, mhocko@kernel.org, roman.gushchin@linux.dev,
 ljs@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>, stable@vger.kernel.org
References: <20260625151554.55105-1-qi.zheng@linux.dev>
 <aj12aVq3he6q7b2C@cmpxchg.org>
 <4c7b0c46-14f0-4a62-893e-e50714e09b74@linux.dev>
 <46ac28bf-5be1-4600-b522-0a1aa76c28e6@kernel.org>
 <08cf8972-6cfc-4452-9a3c-88e0368dbbf9@linux.dev>
 <afdaff7c-fe6b-40da-8f54-aeeab8fe8867@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <afdaff7c-fe6b-40da-8f54-aeeab8fe8867@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: z9tmptbe97g3dqzwtiwupc9sjg7nuq9w
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D39B010000E
X-HE-Tag: 1782455082-159134
X-HE-Meta: U2FsdGVkX1+LNqukDYwv0ztJRuRtMfc07HkgwXHfOxpoSxYV1Fueq2BNpR/h4hX2+zBbHIKLLTdQPo6/V9oRIL+bovLKvfpgpqleeKAuY5hhcPFs61aoqfo6QChCpn89OFFT6rh1BXFbw7llqLIluRbuqFoTNxIqpkZ19Vb41upTIX+D/H45/vOk1Pp3pkjHqp5c4vpouilBFr8w8TpaKQ9ObtRrULi6x5kKjRN+jbPZCCMcMqyaveGg+bIbJAv8/dKFEoVLEaduawIf+1DXZ1s1TJz0vwDAUzXjvaARsWVt7CsWFTT0UzQcmtMV71wVeO7ANnY3nD49SQXNgI3xrb11ZnNsto36fP0eiXWHbzdyWCzaWySbgYsStdFZ2z3WFn+5FzmSulm7/gRhxlMBUKInOzjBlIOWs0PU4BFCg077ovZSkXMRpgN+jG5PLVZC9HQgEqAT/z3LYWBOfVVBhv4ea0C8ElZVA4sr4xIJ084pxCSdaTPWqqpgz1O7auCzmX3bjNggQai6tYnglqVIe4UZjuGnEPPoGXUK+QBMxL3FKfPNaztivrDtgy9TBgOOGKXRpnHqIvA7ZZA2BXqndFGcYAtj8HzSyAyyuU49/HI02+hzZO6VdA7k0KGTHWJOhVxeJ0r+wJ+6wgFWVQmKANtFoQ276xGjj2NvU9R4L3lhAf0gNA0VaKabNPii9ThnIon83hcvzNHLZIB5Fd3DQott6TVIbdQA06C1wQI1YnhVnsYWhZCM0cTN0LeiS/fE0Uih1LWSrGCdBb+SH+tORtEPsQiw64VmYKTmWk3sM0LKP6ysLEEaD5rTn00RoMU6F4Fza/ZJgXECvhIVTMp8S/wXup9wXIITgCo0zCCCyij2iV/Arlt1/cvq3GAPgyOSl5/LBuaFV+cmxdpsFmIt/HBrE+PElkbmwpeeqZoRFZ84RXckVBM2hIuQkUF5nOk3/YuZWaKXIWz8Gsw8z/a
 +X/Ioduv
 Th3zB7Xx7km7E7CT9phOl1c82Jdgu21JvwR+ZmF066+KYD/JWXBfdK5Xh1Cpkus891tFD3NgpiSiBoeM599LOueQuKJjk8uURcEbI8y7IR2scYx6CbXQjGUuornHo8AxkX9MM4U1b1Olu2rSd5MeaWS5MMIxIeY3z67LRagzuOOx9NWcBJ6mgYXnna1O7mMvPzckm30uMJzHcpYEwPnNr2B/Kko13TTGp5ldPh3Om9ZO7t03Cu6761f9e6iZFczX2pxWw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/26/26 12:59 PM, Harry Yoo wrote:
> 
> 
> On 6/26/26 1:48 PM, Qi Zheng wrote:
>>
>>
>> On 6/26/26 12:43 PM, Harry Yoo wrote:
>>>
>>>
>>> On 6/26/26 11:27 AM, Qi Zheng wrote:
>>>> Hi Johannes,
>>>>
>>>> On 6/26/26 2:41 AM, Johannes Weiner wrote:
>>>>> On Thu, Jun 25, 2026 at 11:15:54PM +0800, Qi Zheng wrote:
>>>>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>>>
>>>>>> The mglru page table walker batches per-generation size deltas in
>>>>>> walk->nr_pages while walking page tables without holding the lruvec
>>>>>> lock.
>>>>>> The reset_batch_size() later folds those deltas into walk->lruvec
>>>>>> under
>>>>>> the lruvec lock.
>>>>>>
>>>>>> The page table walker can run concurrently with the memcg reparenting
>>>>>> path
>>>>>> as follows:
>>>>>>
>>>>>> CPU0                           CPU1
>>>>>> ====                           ====
>>>>>>
>>>>>> walk_mm
>>>>>> --> walk_page_range
>>>>>>        --> update_batch_size
>>>>>>            --> walk->nr_pages += delta
>>>>>>
>>>>>>                                  mem_cgroup_css_offline
>>>>>>                                  --> memcg_reparent_objcgs
>>>>>>                                      --> lock lruvec
>>>>>>                                          lru_gen_reparent_memcg
>>>>>>                                          --> reparent child folios to
>>>>>> parent
>>>>>>                                          unlock lruvec
>>>>>>
>>>>>>        lock lruvec
>>>>>>        reset_batch_size
>>>>>>        --> child lrugen->nr_pages += delta
>>>>>>
>>>>>> This will trigger the following warning in lru_gen_exit_memcg():
>>>>>>
>>>>>>       VM_WARN_ON_ONCE(memchr_inv(lruvec->lrugen.nr_pages, 0,
>>>>>>                      sizeof(lruvec->lrugen.nr_pages)));
>>>>>>
>>>>>> And the user-visible impact of underestimated nr_pages in MGLRU was
>>>>>> premature OOMs because MGLRU does not try to reclaim memory when
>>>>>> nr_pages
>>>>>> reaches zero, but there are still more pages.
>>>>>>
>>>>>> To fix it, make reset_batch_size() check CSS_DYING under RCU before
>>>>>> flushing the pending batch. A non-dying memcg keeps the original
>>>>>> lruvec
>>>>>> stable against RCU-delayed offlining; a dying memcg redirects the
>>>>>> deltas
>>>>>> to the first non-dying ancestor.
>>>>>>
>>>>>> Reported-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
>>>>>> Closes: https://lore.kernel.org/all/5A9E929D82717101+12fcf643-
>>>>>> efb8-4b9a-a53a-1e28cc894f0b@smail.nju.edu.cn
>>>>>> Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU
>>>>>> folios")
>>>>>> Cc: <stable@vger.kernel.org>
>>>>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>>> ---
>>>>>> Changes in v3:
>>>>>>     - re-implement lock_batch_lruvec() by checking CSS_DYING under the
>>>>>> RCU lock
>>>>>>       (suggested by Harry)
>>>>>>     - update the commit message (suggested by Harry)
>>>>>>     - temporarily drop the previous Reviewed-by tags
>>>>>>       (since the sync method has changed)
>>>>>>     - rebase onto the next-20260624
>>>>>>
>>>>>> Changes in v2:
>>>>>>     - update the commit message (pointed by Barry)
>>>>>>     - collect Reviewed-by
>>>>>>
>>>>>>     mm/vmscan.c | 45 ++++++++++++++++++++++++++++++++++++++-------
>>>>>>     1 file changed, 38 insertions(+), 7 deletions(-)
>>>>>>
>>>>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>>>>> index 35c3bb15ae96..1ec8c23c72b9 100644
>>>>>> --- a/mm/vmscan.c
>>>>>> +++ b/mm/vmscan.c
>>>>>> @@ -3262,10 +3262,44 @@ static void update_batch_size(struct
>>>>>> lru_gen_mm_walk *walk, struct folio *folio,
>>>>>>         walk->nr_pages[new_gen][type][zone] += delta;
>>>>>>     }
>>>>>>     +#ifdef CONFIG_MEMCG
>>>>>> +static struct lruvec *lock_batch_lruvec(struct lruvec *lruvec)
>>>>>> +{
>>>>>> +    struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>>>>>> +    struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>>>>>> +
>>>>>> +    rcu_read_lock();
>>>>>
>>>>> Where is this unlocked?
>>>>
>>>> The lruvec_unlock_irq() in reset_batch_size() will handle the unlocking.
>>>>
>>>>>
>>>>>> +    /*
>>>>>> +     * The memcg can be NULL when the memory controller is disabled.
>>>>>> +     * Otherwise, the caller keeps the memcg owning @lruvec alive.
>>>>>> +     */
>>>>>> +    if (!memcg || !css_is_dying(&memcg->css))
>>>>>> +        goto lock;
>>>>>> +
>>>>>> +    do {
>>>>>> +        memcg = parent_mem_cgroup(memcg);
>>>>>> +    } while (memcg && css_is_dying(&memcg->css));
>>>>>> +    lruvec = mem_cgroup_lruvec(memcg, pgdat);
>>>>>
>>>>>       while (unlikely(memcg && css_is_dying(&memcg->css))) {
>>>>>           memcg = parent_mem_cgroup(memcg);
>>>>>           lruvec = mem_cgroup_lruvec(memcg, pgdat);
>>>>
>>>> There is no need to acquire the lruvec before finding the first
>>>> non-dying memcg.
>>>
>>> struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>>> struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>>>
>>> rcu_read_lock()
>>>
>>> while (unlikely(memcg_is_dying(memcg)))
>>>           memcg = parent_mem_cgroup(memcg);
>>>
>>> lruvec = mem_cgroup_lruvec(memcg, pgdat);
>>
>> If the first memcg is already non-dying, there's no need to re-acquire
>> the lruvec. ;)
> 
> Oh, right :)
> 
> Hmm but I still think Johannes' suggestion makes the code cleaner.

I don't have a strong preference on which of the two coding styles is
more readable. BTW, is there any kernel documentation I could refer to
for this?

> Observing a dying cgroup should be rare anyway, it's worth focusing
> more on readability?

While it's rare to encounter consecutive dying memcgs, it can still
happen, right?

Thanks,
Qi

> 


