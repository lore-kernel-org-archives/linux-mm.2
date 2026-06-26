Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01F91CDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 07:05:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBDA76B0088; Fri, 26 Jun 2026 03:05:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C47526B0093; Fri, 26 Jun 2026 03:05:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0E8C6B00A2; Fri, 26 Jun 2026 03:05:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7FE516B0088
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 03:05:11 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D17CA1C295E
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 07:05:10 +0000 (UTC)
X-FDA: 84921177180.23.AC9136A
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0113E1C0007
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 07:05:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=b8c9dZcU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782457509;
	b=Q6ks3gJfrhZCp7NCaV0xfoN34XG3ttfPk4WjE3M5r4swrrd6dwt+oQydBcbIrPXDMoZ8LO
	oE0f8v0BOyxzbrQNb5hXYkmlvZ+jKP+4gLVBPXI4N8Teba/vAp/a5pO90ANdn222KBB3mQ
	TeurRzhZiJsqZOlCO6fjkZqToZ/DNfE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782457509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z+bLG5UfpgPjMKqrgsZ8bW9KeIBxng26HYMlgjgCAW8=;
	b=3259LSCvGSZJnLppCnAjJF34yNIeNkoEl8Ad+4wXj+9O/6xBdK5m4w+nO/2JVHCGnDHQkU
	Nxvg3LbR1hSOpRIjPSIhM64Pct6B1CI77k1LVZjJOp8Op4U8z1xaFosdBfW4gPU3wOq8Za
	PETk1NH+uE3zKznKZ3fkhEpKSm+qJyE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=b8c9dZcU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
Message-ID: <c0e366ec-ee5d-42d9-ba33-7c630660e8af@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782457506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z+bLG5UfpgPjMKqrgsZ8bW9KeIBxng26HYMlgjgCAW8=;
	b=b8c9dZcUJ81dwTVzshi/HpGfP2I4P05U8G/nHRbW1IMykFToKsM4HP5YTqv8SYOgHWNRlo
	py1nnHBBimpqvdb1M374AOU511u8l2FGtbmXIXTytfR6NgpZecQavFQSkOvnbf8To8MWhh
	Pkwt4WyjLFQlCmpa+M34ZHTpXOuepAs=
Date: Fri, 26 Jun 2026 15:04:17 +0800
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
 <90fd5300-1016-42e7-abad-08ad85fb62b4@linux.dev>
 <5a0c6597-6b96-4781-a71b-fd1298b2b7bb@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <5a0c6597-6b96-4781-a71b-fd1298b2b7bb@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0113E1C0007
X-Rspam-User: 
X-Stat-Signature: atgbk7szueumhj93i4tatu8aczrepigb
X-HE-Tag: 1782457508-491271
X-HE-Meta: U2FsdGVkX1+pDdRa1oJ5eAS4Vg9ExhcfVviBpJzGhgRFDiLIvVLv2e+hqMo7p8sM3BCcEfIbmw4/Il1B5fjbFlYCHNpKq+5+5gYoCn4KLca/Dzzf5kbkDiDBe4ghYXLeg1txsumh9aCS0zImKA2RtSLMq1g9GKFuur8SEWBNJv5bFutABHbIN6wQckWOV82Iy1eCSyzQVqeneP0148Vw0EqyPbm1k88fYZvZ5lYrbqXu0kSiUIuROHqlj2mkiEDBXVOQdXsb+o+Zz4uNNCg+ikx2NKiU8Vwct7j9tzTzhOGSAtDlnQfqljjgeEfGPEH1TkRKzdr22n27x4uOUUXPRYso8MOtsvjJVYu98JIEyh0lRVDYtSUDAdyesS4DgVmO0ERZng29043Gvkojeu4ILxIVT0EAM4Ys7ufbayHktf1nGTd3VjoZXzp4J1ngDAB0MuSdz4dzCCF1ZD8lcXtfauQwoq8bUFxFwubrxyfV00Qw5n6iQ+YqD5LvsGStIb6LUFH3X/tlrmyCrDSS7zf/rtEU0OqU7FKqG7kdgWcYsEZ1i9utQf5zhMZlVaJ7+13K6WAZO+3A1uxP1v2ys0LpjqJaUcS9ECPGh6BmqZFWkW2A4C3ioVG46PVe9iajgN1FuTBLDsYMjezSTfLpaSGt1Mox4Da7RF6ajo5Bn8yn8TTIo5+HTg/7rPrU4dJ4WDWJ0/3UUj/LMzfZFs0JogI+NDvUGBs2oDSZAcJOmuoRpAojm6ngUH0fEnZ5larKhKYAJFIDeZFmL6elslhyxEOx/Vz7J9nxf8RsSuCcIGLy0RYAbWkjLZwRy7tSXAx5SIkxFjSo6X6PQFz58Cvqv1N/h8DfM6qoXyAv4RHNwBS/OaqAgzRh9nUWxmPj7wdp9olRQqvv5IMOhqXZrqwY/hC9wnucNedW2OpIdPHIHdV69Lb1zUK3K0UFYiDh/3D2cPyrnPcOc8EarI9Xv9oMmiM
 LALLlSNq
 ru1KSL1MV7BJnRbw3QhGSLOxzJL+wr+LuHyndEl++cmZ+JmVPY95Bg3rGhZyuXXONL3cH8+BknblHe0AWJ4GeCt3Xtwwkn/PTY15IqmVZ0+iW+Z2MXXBwR8NBCcIWt3bSbS8pyDL8mQxH2YnbB/m9R0mK0sBTtrP08654V4lFWIosUl4rvjFUdsO2XZVOKZ8zQLWVkDvp7ekbgEH1NZ0MQQwFYPoWPBTrcvC3Q17q1y8I8PljDCcpuqJ4uYY1CeuKVmGQFCtQYTAmwiMPpF1avqKJynweTgR/YMPX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/26/26 2:48 PM, Harry Yoo wrote:
> 
> 
> On 6/26/26 3:24 PM, Qi Zheng wrote:
>>
>>
>> On 6/26/26 12:59 PM, Harry Yoo wrote:
>>>
>>>
>>> On 6/26/26 1:48 PM, Qi Zheng wrote:
>>>>
>>>>
>>>> On 6/26/26 12:43 PM, Harry Yoo wrote:
>>>>>
>>>>>
>>>>> On 6/26/26 11:27 AM, Qi Zheng wrote:
>>>>>> Hi Johannes,
>>>>>>
>>>>>> On 6/26/26 2:41 AM, Johannes Weiner wrote:
>>>>>>> On Thu, Jun 25, 2026 at 11:15:54PM +0800, Qi Zheng wrote:
>>>>>>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>>>>>
>>>>>>>> The mglru page table walker batches per-generation size deltas in
>>>>>>>> walk->nr_pages while walking page tables without holding the lruvec
>>>>>>>> lock.
>>>>>>>> The reset_batch_size() later folds those deltas into walk->lruvec
>>>>>>>> under
>>>>>>>> the lruvec lock.
>>>>>>>>
>>>>>>>> The page table walker can run concurrently with the memcg
>>>>>>>> reparenting
>>>>>>>> path
>>>>>>>> as follows:
>>>>>>>>
>>>>>>>> CPU0                           CPU1
>>>>>>>> ====                           ====
>>>>>>>>
>>>>>>>> walk_mm
>>>>>>>> --> walk_page_range
>>>>>>>>         --> update_batch_size
>>>>>>>>             --> walk->nr_pages += delta
>>>>>>>>
>>>>>>>>                                   mem_cgroup_css_offline
>>>>>>>>                                   --> memcg_reparent_objcgs
>>>>>>>>                                       --> lock lruvec
>>>>>>>>                                           lru_gen_reparent_memcg
>>>>>>>>                                           --> reparent child
>>>>>>>> folios to
>>>>>>>> parent
>>>>>>>>                                           unlock lruvec
>>>>>>>>
>>>>>>>>         lock lruvec
>>>>>>>>         reset_batch_size
>>>>>>>>         --> child lrugen->nr_pages += delta
>>>>>>>>
>>>>>>>> This will trigger the following warning in lru_gen_exit_memcg():
>>>>>>>>
>>>>>>>>        VM_WARN_ON_ONCE(memchr_inv(lruvec->lrugen.nr_pages, 0,
>>>>>>>>                       sizeof(lruvec->lrugen.nr_pages)));
>>>>>>>>
>>>>>>>> And the user-visible impact of underestimated nr_pages in MGLRU was
>>>>>>>> premature OOMs because MGLRU does not try to reclaim memory when
>>>>>>>> nr_pages
>>>>>>>> reaches zero, but there are still more pages.
>>>>>>>>
>>>>>>>> To fix it, make reset_batch_size() check CSS_DYING under RCU before
>>>>>>>> flushing the pending batch. A non-dying memcg keeps the original
>>>>>>>> lruvec
>>>>>>>> stable against RCU-delayed offlining; a dying memcg redirects the
>>>>>>>> deltas
>>>>>>>> to the first non-dying ancestor.
>>>>>>>>
>>>>>>>> Reported-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
>>>>>>>> Closes: https://lore.kernel.org/all/5A9E929D82717101+12fcf643-
>>>>>>>> efb8-4b9a-a53a-1e28cc894f0b@smail.nju.edu.cn
>>>>>>>> Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU
>>>>>>>> folios")
>>>>>>>> Cc: <stable@vger.kernel.org>
>>>>>>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>>>>> ---
>>>>>>>> Changes in v3:
>>>>>>>>      - re-implement lock_batch_lruvec() by checking CSS_DYING
>>>>>>>> under the
>>>>>>>> RCU lock
>>>>>>>>        (suggested by Harry)
>>>>>>>>      - update the commit message (suggested by Harry)
>>>>>>>>      - temporarily drop the previous Reviewed-by tags
>>>>>>>>        (since the sync method has changed)
>>>>>>>>      - rebase onto the next-20260624
>>>>>>>>
>>>>>>>> Changes in v2:
>>>>>>>>      - update the commit message (pointed by Barry)
>>>>>>>>      - collect Reviewed-by
>>>>>>>>
>>>>>>>>      mm/vmscan.c | 45 ++++++++++++++++++++++++++++++++++++++-------
>>>>>>>>      1 file changed, 38 insertions(+), 7 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>>>>>>> index 35c3bb15ae96..1ec8c23c72b9 100644
>>>>>>>> --- a/mm/vmscan.c
>>>>>>>> +++ b/mm/vmscan.c
>>>>>>>> @@ -3262,10 +3262,44 @@ static void update_batch_size(struct
>>>>>>>> lru_gen_mm_walk *walk, struct folio *folio,
>>>>>>>>          walk->nr_pages[new_gen][type][zone] += delta;
>>>>>>>>      }
>>>>>>>>      +#ifdef CONFIG_MEMCG
>>>>>>>> +static struct lruvec *lock_batch_lruvec(struct lruvec *lruvec)
>>>>>>>> +{
>>>>>>>> +    struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>>>>>>>> +    struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>>>>>>>> +
>>>>>>>> +    rcu_read_lock();
>>>>>>>
>>>>>>> Where is this unlocked?
>>>>>>
>>>>>> The lruvec_unlock_irq() in reset_batch_size() will handle the
>>>>>> unlocking.
>>>>>>
>>>>>>>
>>>>>>>> +    /*
>>>>>>>> +     * The memcg can be NULL when the memory controller is
>>>>>>>> disabled.
>>>>>>>> +     * Otherwise, the caller keeps the memcg owning @lruvec alive.
>>>>>>>> +     */
>>>>>>>> +    if (!memcg || !css_is_dying(&memcg->css))
>>>>>>>> +        goto lock;
>>>>>>>> +
>>>>>>>> +    do {
>>>>>>>> +        memcg = parent_mem_cgroup(memcg);
>>>>>>>> +    } while (memcg && css_is_dying(&memcg->css));
>>>>>>>> +    lruvec = mem_cgroup_lruvec(memcg, pgdat);
>>>>>>>
>>>>>>>        while (unlikely(memcg && css_is_dying(&memcg->css))) {
>>>>>>>            memcg = parent_mem_cgroup(memcg);
>>>>>>>            lruvec = mem_cgroup_lruvec(memcg, pgdat);
>>>>>>
>>>>>> There is no need to acquire the lruvec before finding the first
>>>>>> non-dying memcg.
>>>>>
>>>>> struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>>>>> struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>>>>>
>>>>> rcu_read_lock()
>>>>>
>>>>> while (unlikely(memcg_is_dying(memcg)))
>>>>>            memcg = parent_mem_cgroup(memcg);
>>>>>
>>>>> lruvec = mem_cgroup_lruvec(memcg, pgdat);
>>>>
>>>> If the first memcg is already non-dying, there's no need to re-acquire
>>>> the lruvec. ;)
>>>
>>> Oh, right :)
>>>
>>> Hmm but I still think Johannes' suggestion makes the code cleaner.
>>
>> I don't have a strong preference on which of the two coding styles is
>> more readable. BTW, is there any kernel documentation I could refer to
>> for this?
> 
> I don't think there's a coding style guide that specifically
> mentions this. Just thought it's cleaner because it merges if (...) goto
> lock; and do-while into a single while loop.
> 
>>> Observing a dying cgroup should be rare anyway, it's worth focusing
>>> more on readability?
>>
>> While it's rare to encounter consecutive dying memcgs, it can still
>> happen, right?
> 
> But is worth saving a few instruction in a basic block that is
> unlikely() to be executed?

I don't have a strong opinion here. Hi Johannes, I'll leave the decision
up to you. If necessary, I can send out the v4.

> 
> I'm not a memcg maintainer myself, though. just my 2 cents.

I'd like to express my gratitude for your reviews, and especially
for your invaluable help with the earlier dying memcg work!

Thanks,
Qi

> 


