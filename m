Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AB81C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 06:19:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DC5C6B008C; Fri, 10 Jul 2026 02:19:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28D326B0092; Fri, 10 Jul 2026 02:19:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17EC06B0093; Fri, 10 Jul 2026 02:19:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D92F06B008C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 02:19:29 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4230A14038C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 06:19:29 +0000 (UTC)
X-FDA: 84971865258.15.9F349DA
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1576040007
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 06:19:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K4rbRarg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783664367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DrsFrXe2gSCY+3C8A2OllD1L02A+ogsgIvQEHN3LEIs=;
	b=uK+Vzv0AAT8zPs7jUwh+qD3h1yu9p+m2FDWw8vku10tKzDaRYGhh/vBCdE2y1eQoCEImQE
	FkDPKh2IcB5MOO26vtu5Y0y4Ic2eXAw7DeMMOtTILVJBF6S4nuflpp8Lh2mXxfeiBXfMHu
	5hW9Z0pkYlZMTXIafLDSgkLkJGv4f9U=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K4rbRarg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783664367;
	b=lt+hIiML3TJK3i7dSS6k1OlnE2jIyfyy3cP70Vc2H0K5hVXYxYnfOfGN847zn9kWfpxwiX
	Mf0V/DsBSDUyceN6MXQ2gk4qJOC7Q7iJr/KbASpQVl+dYcdoeELb4ZOS+9im8M7xYnglGm
	kybAneI7oNYkJmoxn1SLWQUTvaAe6ak=
Message-ID: <843f6d0d-e893-43ef-9cb3-1df21fb64b8d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783664364;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DrsFrXe2gSCY+3C8A2OllD1L02A+ogsgIvQEHN3LEIs=;
	b=K4rbRargGu/1m7H7J1KlcEYwGgrEC/POAKdRi4IsE48sycrNl9n81QN99X5HnfmKV6pmcQ
	fysIWrFwHA85OWdrNsqN2XQV4xNxuSTFJBomRbesKeVzqYeissHyYD0AuQwjYYtYqTpCTE
	WW8SbGhVvnSDt+IBBP6XoZbP7zvPIcE=
Date: Fri, 10 Jul 2026 14:19:15 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4] mm: mglru: fix stale batch updates after memcg
 reparenting
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Harry Yoo <harry@kernel.org>, Usama Arif <usama.arif@linux.dev>,
 akpm@linux-foundation.org, david@kernel.org, kasong@tencent.com,
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, muchun.song@linux.dev,
 peiyang_he@smail.nju.edu.cn, mhocko@kernel.org, roman.gushchin@linux.dev,
 ljs@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>, stable@vger.kernel.org
References: <20260701145736.3785016-1-usama.arif@linux.dev>
 <2fb5ce53-666b-4b0a-a4ad-2b3a28c54768@kernel.org>
 <akU5VdOBkLGInh_t@cmpxchg.org>
 <cbba6349-55a1-416d-a686-d03ff72cc211@linux.dev>
 <alBQBRWDrVoh9P-a@cmpxchg.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <alBQBRWDrVoh9P-a@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: o1nzdj1sepw7wmtq15pwg86c7kdgk7ia
X-Rspamd-Queue-Id: 1576040007
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783664366-927408
X-HE-Meta: U2FsdGVkX18/iH6R+pN+UB79egI8yjsujf0wqQFNwfCVSYvf9iEcsvFLBiTxDnIbxfJ4dpteQ2dbvCfZNfCbbmkRMyZWqilrcnleIeBd/xfPXESBlAOi3I4HtMclH7gdfstNYnm1YL8vfcUcb2ee0xIuoKJoUfa3HVWOM2afHykh6ceBITqIQ+K2YBNoJGcb4FzfND8SXO/i/MsbyCeUeD5OxjTqyq2Nzoryhv55ATpEgo/kdm0ZdT7oZNY8f5+tzmOyJJINUHWJgf09cD9WJDiLmnDTz0p7fue2pHu/YrhuJoGUrvuwqJnD6GRuVfIKrfQYlfD1SC7SIX8vqCkOJnQm5VsyRfZi+WG8lN2g38c618WKuPQGx/MtU7g26FPlnuRp51fx/y8c0PVARJrC2v1fNQ6vDYpYCll6tz97Qege0PX69WbB5Yx2UhX8W378iPUkh+h4nmfw+244NJ/mGFHjnDGaCqZ1QnSZEmMXbgE8Kz6xNt/vJ1ohzOuYUHb1HMALk3lvdyTeDSC4E/R/itrnYYwc7b8VIGV4ESQs1SbQiR2sb3p+okrjJkFcIB4sKaG71dPnRSGA7zjsuXot3zPZtF8ixY4+7pzl8GWHSSieWqJLDXpOyUp+yx42EhEbkUmIVwsLUMFnnvsuwXgaccfyW9pmIUCSG0tExBLVjQb5ey8biI2PcRweydIQq+2x1+LhdRrmP3y06mcY7QUTrZiUJQJvMKSRja7lWvNCeNVHQtbbKL7bSVJdNrFFweP753Rjxf/vllN/UauMLdwC2U7z+b2yddNE+xaKbavntrPBS2KKm5c/chxYPqeuf0qwHcpgapK2+6cNwudR4GopFXyHMOxpJbOldbWquQ+a7Ly1eLB00MhKaQLZ2GJAjOhfqcjAEErRkL2rOnjpKHUmE5eTS+3bmKTfxgW7HA5t4cC5fTqrxPtrSHQj5NhUyfx3q8Pk2ngb1Q0aM5zQtpU
 65HNQUsU
 glVDqjVwj1PXmAsOmqoU75hwCg8dEiYg1xfJUcQZoEKYFhoZj+4WKO27D6vWzUltXq/0Sokp/MDACaqcA2L3SIK0h7PHGmED8czOnvU4oKisxpKIxaggvi173qBWFYO4of7FJ0fEkJ1mLxSoWY3YHHl8VTG9DW8rmA2eq80PZ0HTbwoqK1mPt34Dc0V2XYA+cnbx0dpYQMmWCp2z1IfU2OMAi+wfY77nswM+45+Iq1vKMSPheKd8lDmr3dMlLp1/2H6xb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/10/26 9:51 AM, Johannes Weiner wrote:
> On Thu, Jul 02, 2026 at 09:38:41AM +0800, Qi Zheng wrote:
>>
>>
>> On 7/1/26 11:59 PM, Johannes Weiner wrote:
>>> On Thu, Jul 02, 2026 at 12:36:42AM +0900, Harry Yoo wrote:
>>>>
>>>>
>>>> On 7/1/26 11:57 PM, Usama Arif wrote:
>>>>> On Wed,  1 Jul 2026 15:52:51 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:
>>>>>
>>>>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>>>
>>>>>> The mglru page table walker batches per-generation size deltas in
>>>>>> walk->nr_pages while walking page tables without holding the lruvec lock.
>>>>>> The reset_batch_size() later folds those deltas into walk->lruvec under
>>>>>> the lruvec lock.
>>>>>>
>>>>>> The page table walker can run concurrently with the memcg reparenting path
>>>>>> as follows:
>>>>>>
>>>>>> CPU0                           CPU1
>>>>>> ====                           ====
>>>>>>
>>>>>> walk_mm
>>>>>> --> walk_page_range
>>>>>>       --> update_batch_size
>>>>>>           --> walk->nr_pages += delta
>>>>>>
>>>>>>                                 mem_cgroup_css_offline
>>>>>>                                 --> memcg_reparent_objcgs
>>>>>>                                     --> lock lruvec
>>>>>>                                         lru_gen_reparent_memcg
>>>>>>                                         --> reparent child folios to parent
>>>>>>                                         unlock lruvec
>>>>>>
>>>>>>       lock lruvec
>>>>>>       reset_batch_size
>>>>>>       --> child lrugen->nr_pages += delta
>>>>>>
>>>>>> This will trigger the following warning in lru_gen_exit_memcg():
>>>>>>
>>>>>> 	VM_WARN_ON_ONCE(memchr_inv(lruvec->lrugen.nr_pages, 0,
>>>>>> 				   sizeof(lruvec->lrugen.nr_pages)));
>>>>>>
>>>>>> And the user-visible impact of underestimated nr_pages in MGLRU was
>>>>>> premature OOMs because MGLRU does not try to reclaim memory when nr_pages
>>>>>> reaches zero, but there are still more pages.
>>>>>>
>>>>>> To fix it, make reset_batch_size() check CSS_DYING under RCU before
>>>>>> flushing the pending batch. A non-dying memcg keeps the original lruvec
>>>>>> stable against RCU-delayed offlining; a dying memcg redirects the deltas
>>>>>> to the first non-dying ancestor.
>>>>>>
>>>>>> Reported-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
>>>>>> Closes: https://lore.kernel.org/all/5A9E929D82717101+12fcf643-efb8-4b9a-a53a-1e28cc894f0b@smail.nju.edu.cn
>>>>>> Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU folios")
>>>>>> Cc: <stable@vger.kernel.org>
>>>>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>>> Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
>>>>>> ---
>>>>>> Changes in v4:
>>>>>>    - re-implement lock_batch_lruvec() in a simpler way
>>>>>>      (suggested by Johannes and Harry)
>>>>>>    - collect Reviewed-by
>>>>>>    - rebase onto the next-20260630
>>>>>>
>>>>>> Changes in v3:
>>>>>>    - re-implement lock_batch_lruvec() by checking CSS_DYING under the RCU lock
>>>>>>      (suggested by Harry)
>>>>>>    - update the commit message (suggested by Harry)
>>>>>>    - temporarily drop the previous Reviewed-by tags
>>>>>>      (since the sync method has changed)
>>>>>>    - rebase onto the next-20260624
>>>>>>
>>>>>> Changes in v2:
>>>>>>    - update the commit message (pointed by Barry)
>>>>>>    - collect Reviewed-by
>>>>>>
>>>>>>    mm/vmscan.c | 41 ++++++++++++++++++++++++++++++++++-------
>>>>>>    1 file changed, 34 insertions(+), 7 deletions(-)
>>>>>>
>>>>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>>>>> index 35c3bb15ae96..ca1e2a870d51 100644
>>>>>> --- a/mm/vmscan.c
>>>>>> +++ b/mm/vmscan.c
>>>>>> @@ -3262,10 +3262,40 @@ static void update_batch_size(struct lru_gen_mm_walk *walk, struct folio *folio,
>>>>>>    	walk->nr_pages[new_gen][type][zone] += delta;
>>>>>>    }
>>>>>>    
>>>>>> +#ifdef CONFIG_MEMCG
>>>>>> +static struct lruvec *lock_batch_lruvec(struct lruvec *lruvec)
>>>>>> +{
>>>>>> +	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>>>>>> +	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>>>>>> +
>>>>>> +	rcu_read_lock();
>>>>>> +
>>>>>> +	/*
>>>>>> +	 * The memcg can be NULL when the memory controller is disabled.
>>>>>> +	 * Otherwise, the caller keeps the memcg owning @lruvec alive.
>>>>>> +	 */
>>>>>> +	while (unlikely(memcg && css_is_dying(&memcg->css))) {
>>>>>> +		memcg = parent_mem_cgroup(memcg);
>>>>>> +		lruvec = mem_cgroup_lruvec(memcg, pgdat);
>>>>>> +	}
>>>>>> +
>>>>>> +	spin_lock_irq(&lruvec->lru_lock);
>>>>>
>>>>> Do we need an rcu_read_unlock() here?
>>>>
>>>> lruvec_unlock_irq() does that.
>>>
>>> Yeah, that tripped me up too. And it makes me think Shakeel was right
>>> after all: this should live next to the other lruvec_lock() primitives.
>>>
>>> Sure, MGLRU is the only user, but it's still much easier to understand
>>> this if the code sits next to the rest of the API (and the unlock!).
>>>
>>> lruvec_live_lock_irq()?
>>
>> But lruvec_lock_irq() grabs the rcu lock too. :(
> 
> Yes, but it's self-explanatory if you put it with those definitions:
> 
> static inline void lruvec_lock_irq(struct lruvec *lruvec)
> {
>          rcu_read_lock();
>          spin_lock_irq(&lruvec->lru_lock);
> }
> 
> static struct lruvec *lruvec_live_lock_irq(struct lruvec *lruvec)
> {
> 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
> 
> 	rcu_read_lock();
> 	while (unlikely(memcg && css_is_dying(&memcg->css))) {
> 		memcg = parent_mem_cgroup(memcg);
> 		lruvec = mem_cgroup_lruvec(memcg, lruvec_pgdat(lruvec));
> 	}
> 	spin_lock_irq(&lruvec->lru_lock);
> }

All right, should the implementation for !CONFIG_MEMCG be placed here
too?

Will send the v5.

Thanks,
Qi

> 
> static inline void lruvec_unlock_irq(struct lruvec *lruvec)
> {
>          spin_unlock_irq(&lruvec->lru_lock);
>          rcu_read_unlock();
> }
> 
> etc.


