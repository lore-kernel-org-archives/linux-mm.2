Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CE08CDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 04:48:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F7556B00E5; Fri, 26 Jun 2026 00:48:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A8AE6B00E6; Fri, 26 Jun 2026 00:48:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 197A56B00E7; Fri, 26 Jun 2026 00:48:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EAE0B6B00E5
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:48:52 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 72D978D56B
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:48:52 +0000 (UTC)
X-FDA: 84920833704.09.40881BC
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf20.hostedemail.com (Postfix) with ESMTP id 85AD61C0004
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:48:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=u6W1Mh5t;
	spf=pass (imf20.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782449330;
	b=WOrpMuubpzSh/fdaVeKnTje1jMQzhKLhsE6BUThjeSPM0uS5rNpqdebnpjpdyeC1BUJ9hd
	b0SB4+EcFVIzIBFJKB3qC1v+VG99ApUDNvP80dDwOZATcjS0k3cK8LnFO6pKZSA/R0SWQq
	9TfAvcZYnXXB7WrtLOfuRznpoQUD7ek=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782449330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hXWAjRXwVjfvQ2EeAYBpqAd/3dxRlR+I4BBsCU5i8SU=;
	b=XdmfEyZgmYUyTYGgLIpbagJxaJyk7KpiUCTEvZJRp/l2yGueDYQ+DpBOVIzoDo81mM/HnI
	CGewv0xTu6j7K9fsvs0BpjEqXlw/zMlyN6wpzfjvipS17Z5dOVefREVOQxRkZv4X8tiiDu
	Vj2WjDhtfPVsGq1I1asb+wr4PRfQvVg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=u6W1Mh5t;
	spf=pass (imf20.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <08cf8972-6cfc-4452-9a3c-88e0368dbbf9@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782449328;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hXWAjRXwVjfvQ2EeAYBpqAd/3dxRlR+I4BBsCU5i8SU=;
	b=u6W1Mh5tSI/Kxm1HgHeZwa/QlBHUNxcYuSPz2Jt+pfXZ9gjN1Ra9iT1TBy5lDtQH3pB0Dv
	WL+8IYnioDUK/Cs/3jMFCkweHWzC0/LkkwQIKhLtDgpOHEyn04+66sZSZs0BrAPBJ6qm1z
	K7PpuICdv8vceJ68w5R598mrhjnWb2s=
Date: Fri, 26 Jun 2026 12:48:37 +0800
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
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <46ac28bf-5be1-4600-b522-0a1aa76c28e6@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 85AD61C0004
X-Stat-Signature: oiiixiwk68ax6iksxefgzzuz8fcroc8z
X-HE-Tag: 1782449330-578143
X-HE-Meta: U2FsdGVkX1/pf2T2tuHgLwkHUI5dwxw40YPx+1R5WixxfFGmM8HRqGmuiTvyiINHCcnSqtWkw2t5xPoZDRfkmuD8pKPXnDu1zini42GuUY2e7ayaVPABTC7tXPZiZMt+VKHa+qRt8TeZEK1RJ+BuERs4r6cat2gOXOwLtIlC5d0V2trK/TcAR1iYGeT7nzuXK8odnlUpaSgN7IC42ppRmM4iKHVwSfvyQ9OaqQRBcUUCFjeh6HfAIwSZWI13hXQC++B31MsEZsdKK1weo9mjknjCiCvCZQ1tlfQHRkm0DxllOzdDK8esHUM7iHaFSLxpvoiIsf/6C0PKmMDtyO/qr+98j6mXktVpxzuWN/RTUoc1HEqOUiDVuCE4nRQdVBrEOtnilR5CppNJi5dUDN/++kGYfoPLLQ/QMsIzHdyi2qfoSqzXMrx9PaM9I8wjSwea7Rh8joE3fKE7ot1Hxf8ALakNNPTD+WySX5PIiFP3tyuTIMAaktdPulPbP/6als0b9AbsUJX2S3TqckFd80V7dqt/3C2+diWPpJRtFxJKyEI6G8pwQIpRbMG+SqQjnKc4Dj6ThIdJEXhNK55RB6YKgrnEIVzeG9Ft+c9He2VsYXXZcCxtwjtV6XyBjvp1FTbZMXn5p3+/QNOw8pymMkEhYSDurlKZvgtGWzcNqiSE0kelUThEw5sMp5ujb2CHHwEKoeO793NRiNo87U9MqyOSLYymgNWNCxx/9e9x/N21hM/eyCAF3tG0wEwpepdGgCl481i8IOoQMVBFMnj2d5xFOjLfEg09p33RZezLNImF0nNpJtVqKh4uMrC6+ouP6ZkOS2hDtfYQG67z/75t5xRssGo3LNowsLi4XUOKVuwxg3IzBox0Ro+z55+/Wx7Hi7b7gcUskHDQOA38LzwDSG5mOOklqrLzogeZ61ZYCHynWcuRgKE7oh6Gdez9dZWZY3UJCKvmdhQZR0VHBuXod8O
 6tALG11Y
 F5rXZvuTwEShrXVYRtu+KSP4W8GPXNjrBImZr/jHNxB3oL7NpSEtdPFxlA1onkOwsL7Xa9tJNyUWbfeX36lemuz2s0jvCUIGAbevTGezfYmkhK4X//xnXdEco+2L0xSUmqiYM8SqN0Nd8fvp6NPJS6JJZFsKT85ebQbu/TvLJmEynaZGkBiVnUcE1RmiHE4B3BGsCL5zlLpZoTTSBb+6/rOG8iBgBVW5sgZiyZL+7fDS/RLtJLdQr17lcEJyXVdE20tfi6H0eIOaXdAlfvj0QHs1KgwUCJcBj7PVd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/26/26 12:43 PM, Harry Yoo wrote:
> 
> 
> On 6/26/26 11:27 AM, Qi Zheng wrote:
>> Hi Johannes,
>>
>> On 6/26/26 2:41 AM, Johannes Weiner wrote:
>>> On Thu, Jun 25, 2026 at 11:15:54PM +0800, Qi Zheng wrote:
>>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>
>>>> The mglru page table walker batches per-generation size deltas in
>>>> walk->nr_pages while walking page tables without holding the lruvec
>>>> lock.
>>>> The reset_batch_size() later folds those deltas into walk->lruvec under
>>>> the lruvec lock.
>>>>
>>>> The page table walker can run concurrently with the memcg reparenting
>>>> path
>>>> as follows:
>>>>
>>>> CPU0                           CPU1
>>>> ====                           ====
>>>>
>>>> walk_mm
>>>> --> walk_page_range
>>>>       --> update_batch_size
>>>>           --> walk->nr_pages += delta
>>>>
>>>>                                 mem_cgroup_css_offline
>>>>                                 --> memcg_reparent_objcgs
>>>>                                     --> lock lruvec
>>>>                                         lru_gen_reparent_memcg
>>>>                                         --> reparent child folios to
>>>> parent
>>>>                                         unlock lruvec
>>>>
>>>>       lock lruvec
>>>>       reset_batch_size
>>>>       --> child lrugen->nr_pages += delta
>>>>
>>>> This will trigger the following warning in lru_gen_exit_memcg():
>>>>
>>>>      VM_WARN_ON_ONCE(memchr_inv(lruvec->lrugen.nr_pages, 0,
>>>>                     sizeof(lruvec->lrugen.nr_pages)));
>>>>
>>>> And the user-visible impact of underestimated nr_pages in MGLRU was
>>>> premature OOMs because MGLRU does not try to reclaim memory when
>>>> nr_pages
>>>> reaches zero, but there are still more pages.
>>>>
>>>> To fix it, make reset_batch_size() check CSS_DYING under RCU before
>>>> flushing the pending batch. A non-dying memcg keeps the original lruvec
>>>> stable against RCU-delayed offlining; a dying memcg redirects the deltas
>>>> to the first non-dying ancestor.
>>>>
>>>> Reported-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
>>>> Closes: https://lore.kernel.org/all/5A9E929D82717101+12fcf643-
>>>> efb8-4b9a-a53a-1e28cc894f0b@smail.nju.edu.cn
>>>> Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU folios")
>>>> Cc: <stable@vger.kernel.org>
>>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>>> ---
>>>> Changes in v3:
>>>>    - re-implement lock_batch_lruvec() by checking CSS_DYING under the
>>>> RCU lock
>>>>      (suggested by Harry)
>>>>    - update the commit message (suggested by Harry)
>>>>    - temporarily drop the previous Reviewed-by tags
>>>>      (since the sync method has changed)
>>>>    - rebase onto the next-20260624
>>>>
>>>> Changes in v2:
>>>>    - update the commit message (pointed by Barry)
>>>>    - collect Reviewed-by
>>>>
>>>>    mm/vmscan.c | 45 ++++++++++++++++++++++++++++++++++++++-------
>>>>    1 file changed, 38 insertions(+), 7 deletions(-)
>>>>
>>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>>> index 35c3bb15ae96..1ec8c23c72b9 100644
>>>> --- a/mm/vmscan.c
>>>> +++ b/mm/vmscan.c
>>>> @@ -3262,10 +3262,44 @@ static void update_batch_size(struct
>>>> lru_gen_mm_walk *walk, struct folio *folio,
>>>>        walk->nr_pages[new_gen][type][zone] += delta;
>>>>    }
>>>>    +#ifdef CONFIG_MEMCG
>>>> +static struct lruvec *lock_batch_lruvec(struct lruvec *lruvec)
>>>> +{
>>>> +    struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>>>> +    struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>>>> +
>>>> +    rcu_read_lock();
>>>
>>> Where is this unlocked?
>>
>> The lruvec_unlock_irq() in reset_batch_size() will handle the unlocking.
>>
>>>
>>>> +    /*
>>>> +     * The memcg can be NULL when the memory controller is disabled.
>>>> +     * Otherwise, the caller keeps the memcg owning @lruvec alive.
>>>> +     */
>>>> +    if (!memcg || !css_is_dying(&memcg->css))
>>>> +        goto lock;
>>>> +
>>>> +    do {
>>>> +        memcg = parent_mem_cgroup(memcg);
>>>> +    } while (memcg && css_is_dying(&memcg->css));
>>>> +    lruvec = mem_cgroup_lruvec(memcg, pgdat);
>>>
>>>      while (unlikely(memcg && css_is_dying(&memcg->css))) {
>>>          memcg = parent_mem_cgroup(memcg);
>>>          lruvec = mem_cgroup_lruvec(memcg, pgdat);
>>
>> There is no need to acquire the lruvec before finding the first
>> non-dying memcg.
> 
> struct pglist_data *pgdat = lruvec_pgdat(lruvec);
> struct mem_cgroup *memcg = lruvec_memcg(lruvec);
> 
> rcu_read_lock()
> 
> while (unlikely(memcg_is_dying(memcg)))
>          memcg = parent_mem_cgroup(memcg);
> 
> lruvec = mem_cgroup_lruvec(memcg, pgdat);

If the first memcg is already non-dying, there's no need to re-acquire
the lruvec. ;)

Thanks,
Qi

> spin_lock_irq(&lruvec->lru_lock);
> 
> return lruvec;
> 
> should work?
> 
> if the memory controller is disabled, it's equivalent to:
> 
> rcu_read_lock();
> spin_lock_irq(&lruvec->lru_lock);
> return lruvec;
> 


