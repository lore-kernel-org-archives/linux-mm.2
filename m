Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CD27C982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 09:55:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 580416B0093; Wed, 23 Sep 2026 05:55:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 531316B0095; Wed, 23 Sep 2026 05:55:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46DAA6B0096; Wed, 23 Sep 2026 05:55:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 16EED6B0093
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 05:55:58 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 96A7BC06FB
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:55:57 +0000 (UTC)
X-FDA: 85244570754.12.B6DE756
Received: from mta0.migadu.com (out-65.mta0.migadu.com [91.218.175.65])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6076720002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:55:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ciGN5Y9+;
	spf=pass (imf03.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.65 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790157355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KLPKSI9kFj6i8iR1n3JuJChE7C8hbJOTjhwKEGT7aSE=;
	b=0hH/5tjcuSNE2t+XLxQzCxqf7PWMRRVp9vRKCSMGTJAqGEmLrbqHnfh4niisZL3kLMZXLQ
	Ni5FqQoYnRRrwaLljmIvRWygfYopr+H3nuDRleWdzxSPBQWOyf9D6WQ7Bvpo+MUv4WT4jW
	DU/wOEJ471OgZmRhvrjfkmeEGaxywrA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790157355;
	b=RAL4sPInxfD1XW9VWeBUQYKXEllQbBW5p7uuO7fzv+2Ol7pwOpxg7UmTHbhK9cyEqmZPEw
	wjwTHd286jRBAKBklFk0mL56Z2Mc8OaE+bkJzAWShauPV9z0eqFt+I8fjGQ43yOdFyNOoU
	NK94j9N3Z90knxb3Rv+HMyqpMrMaXE0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ciGN5Y9+;
	spf=pass (imf03.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.65 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=uJ1O5s9VLtgzemkGDdrkmpPu2/dB4/tV80lAnRg6dCo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790157354; v=1; x=1790762154;
 b=ciGN5Y9+jbEgWZ9u8vHalcYYozkWFW1c/WZqxX2fT+rzwkcLDPt7eYeNx10QhY2bYTzJnxXw
 Q5Veq2rz0dYfteX26KvuXueXNAVqlEdAD2FeqH9ESbeRzMhFt/L8VCVMzGf6OGMH8KmSAu4vcl/
 Yv3ki7MqFPJGH++DtehsSp/Q=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 2fd1ec4fc6184996;
	Wed, 23 Sep 2026 09:55:54 +0000
X-Mizu-Trace-ID: 2fd1ec4fc6184996
X-Migadu-Flow: FLOW_OUT
Message-ID: <2f01bd33-6b51-4978-a19b-cd1fd0bd013c@linux.dev>
Date: Wed, 23 Sep 2026 17:55:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: hongfu.li@linux.dev, Hongfu Li <lihongfu@kylinos.cn>,
 Chris Down <chris@chrisdown.name>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 stable@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Nhat Pham <nphamcs@gmail.com>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH v2 2/2] mm/memcg: migrate per-node hugetlb lruvec stat
 together with hugetlb folio
To: Muchun Song <muchun.song@linux.dev>
References: <20260923-for-hugetlb_state3-v2-0-e8a36245bfab@kylinos.cn>
 <20260923-for-hugetlb_state3-v2-2-e8a36245bfab@kylinos.cn>
 <15ac7069-d687-4985-90bd-25bc900b4bdd@linux.dev>
 <1835413c-e2de-41b0-8225-161afa50676a@linux.dev>
 <10149B0C-4108-4DB6-84B7-A301E8158CA4@linux.dev>
From: Hongfu Li <hongfu.li@linux.dev>
In-Reply-To: <10149B0C-4108-4DB6-84B7-A301E8158CA4@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: szwjfty9phgt65z67i3ayhdghnw5kj54
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6076720002
X-HE-Tag: 1790157355-4006
X-HE-Meta: U2FsdGVkX1/sYhymS50p3dvksG+exQwYSDa40+7qXzxE8UukSvb3DY4r1YfGubNvVZ+0WmSQYN5SFza+bqD28F+sm6yhYzvmIMQF00afNiSUqiX5RrUiDSSEa7MmUBuN8+4JBtwE3s1cOhyeFrClVje1xZlHVH+e6G68bJ8EWJLAbI6XP7MkCJRKYZXtO1BGpSeoikUYxGd3JUc13kZxEP0IA/LjFYzMPwI0H3d0uUy1VWPapxLAPy91acnymi8umwxeMyL9Vknuuu1J1UrUYb73TgMnWdxAvykCaJ0qZk8ZYz0Mo483QOyLuCh5kmMUmsYk1Z2RY0Xo1RZtEHnXIfoUi98JYZrB5Yk6mK03Xsylieqvl8bg/8Wc+dVaJdOYw9qmu+X3dB6SE/kMZU6kDVW4twsmJl1sgNcNs4I4m/Mv5CgzRL3GMesyJFw1fir4mgaopE5Uoypw/xin//KGPtiXbmPd2zHha3S6jHoeJ+yiyIya70mRmwtmU9ofSJhfqYbbsCpXG2BRtKWEj+pj778mLM0KzGrirva6DklpTnrSimh7qacaNdwE1YxiBMd6Yyeyvh0HVP5uZb+1Jd7ecGG/2+emB/RPLCVKk190MfGSB/8Xbmq0y9qiyqx9DGkYbHQAObE0cMY9Q5oklppROO9+Fyoti5haMb2q7XwAnY09f9wqJLuCcyy5iU8rb/uq8cPDPdt0VLCBLbl6OTfv59D3AbcXJ1YA42JLw1Gsjz8w1ulXWbrBsFo8kFkiSfX8vtChNBzegAPDf7Erk9gmzDCpbULvNeBTG5IHNKMw66g0qTFxd78kpyDbkhYZlVEpwCCRElayf0nkZNx1M0ZUN1m+d6gpn4WoLRjOenubwP1DlHHhzK3rgE/P5JbVgTtlW2EhnPBVM8oIeHPiBUAP72tGVnqE7GoBv4RmS7WpEh29x73fgxmYM1BTFYBuOESZdKZuC7ZOE26wCI4mcrJ
 aic/EWDI
 jD6Ub8gDdA/ZCq0xP6Mzcyo03m62Ig0sL11ONvx5MMk6XfpLLpMSbR8ai8Qp8OgyRzpC9QprkAKJmen7V5x3vU2956Y0ArghYJLmMhUMYogh1rRyVCOwRFLRTtVSm9G2rlEAqe7VzRSWGxdTM5WCqC1L5arvfQD/r62fc2kM/jVUHOO8otx9/qOF/cE8/zk9bGNYh8iH2RLZZGoD+LS7Bysz4Uy1NSXvxCZBAH0btBTG889Z+c0yP2tNljpSH4jO/f6Q0dJyFgYDQX/6F0SUR0y79fYXoFMxze1U76047pd/l49iWa9mLONCIefmsASAFwPIR9PgUMitW/1sdgfXkailWy6yOpf542BkXtoTex3fn/qqM67fLTjKe/SjwCFKsUJAUKjmAPzKq3k07zTDtu9T1kg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 9/23/26 3:56 PM, Muchun Song wrote:
>
>> On Sep 23, 2026, at 11:40, Hongfu Li <hongfu.li@linux.dev> wrote:
>>
>>
>> On 9/23/26 10:40 AM, Muchun Song wrote:
>>>
>>> On 2026/9/23 10:05, Hongfu Li wrote:
>>>> From: Hongfu Li <lihongfu@kylinos.cn>
>>>>
>>>> memory.numa_stat exposes per-node hugetlb counters from per-node lruvec
>>>> stats. These stats are accounted against folio_nid(): incremented on
>>>> the folio's node when handed to a user, decremented when the folio is
>>>> returned to the pool.
>>>>
>>>> During hugetlb folio migration, mem_cgroup_migrate() moves the charge
>>>> to the new folio and drops the memcg data of the old one, so the free
>>>> of the old folio right after the migration skips the memcg per-node
>>>> lruvec decrement. The hugetlb count stays attributed to the old node
>>>> for the rest of the life of the charge, while the target folio gets no
>>>> increment on the new node; its later free decrements a counter that
>>>> was never incremented.
>>>>
>>>> Migrate the per-node lruvec accounting alongside migration. Global
>>>> memcg totals remain balanced because they track resource consumption,
>>>> not node placement.
>>>>
>>>> Fixes: 05d4532b60e3 ("memcg/hugetlb: add hugeTLB counters to memcg")
>>>> Cc: stable@vger.kernel.org
>>>> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
>>>> Tested-by: Joshua Hahn <joshua.hahnjy@gmail.com>
>>>> Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
>>>> Reviewed-by: Oscar Salvador <osalvador@suse.de>
>>>> ---
>>>>    include/linux/memcontrol.h |  8 ++++++++
>>>>    mm/hugetlb.c               | 25 +++++++++++++++++++++++++
>>>>    mm/memcontrol.c            |  5 ++---
>>>>    3 files changed, 35 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>>>> index a8358f297b65..74110a324f9e 100644
>>>> --- a/include/linux/memcontrol.h
>>>> +++ b/include/linux/memcontrol.h
>>>> @@ -984,6 +984,9 @@ unsigned long lruvec_page_state_monotonic(const struct lruvec *lruvec,
>>>>    unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
>>>>                          enum node_stat_item idx);
>>>>    +void mod_memcg_lruvec_state(struct lruvec *lruvec,
>>>> +                enum node_stat_item idx, int val);
>>>> +
>>>>    void mem_cgroup_flush_stats(struct mem_cgroup *memcg);
>>>>    void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg);
>>>>    @@ -1452,6 +1455,11 @@ static inline unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
>>>>        return node_page_state(lruvec_pgdat(lruvec), idx);
>>>>    }
>>>>    +static inline void mod_memcg_lruvec_state(struct lruvec *lruvec,
>>>> +                      enum node_stat_item idx, int val)
>>>> +{
>>>> +}
>>>> +
>>>>    static inline void mem_cgroup_flush_stats(struct mem_cgroup *memcg)
>>>>    {
>>>>    }
>>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>>>> index 519c30b338a8..76d019594b39 100644
>>>> --- a/mm/hugetlb.c
>>>> +++ b/mm/hugetlb.c
>>>> @@ -23,6 +23,7 @@
>>>>    #include <linux/mmdebug.h>
>>>>    #include <linux/sched/signal.h>
>>>>    #include <linux/rmap.h>
>>>> +#include <linux/rcupdate.h>
>>>>    #include <linux/string_choices.h>
>>>>    #include <linux/string_helpers.h>
>>>>    #include <linux/swap.h>
>>>> @@ -7378,12 +7379,36 @@ void folio_putback_hugetlb(struct folio *folio)
>>>>        folio_put(folio);
>>>>    }
>>>>    +static void move_hugetlb_lruvec_stat(struct folio *old_folio,
>>>> +                     struct folio *new_folio)
>>>> +{
>>>> +    struct mem_cgroup *memcg;
>>>> +    long nr_pages = folio_nr_pages(old_folio);
>>>> +    int old_nid = folio_nid(old_folio);
>>>> +    int new_nid = folio_nid(new_folio);
>>>> +
>>>> +    if (old_nid == new_nid)
>>>> +        return;
>>>> +
>>>> +    guard(rcu)();
>>>> +
>>>> +    memcg = folio_memcg(new_folio);
>>>> +    if (!memcg)
>>>> +        return;
>>>> +
>>>> +    mod_memcg_lruvec_state(mem_cgroup_lruvec(memcg, NODE_DATA(old_nid)),
>>>> +                   NR_HUGETLB, -nr_pages);
>>> Why not use mod_lruvec_state? mod_memcg_lruvec_state is an internal
>>> API for memcg, I don't want it to be exported.
>> Thank you for the review.
>>
>> mod_lruvec_state() would update the node counter a second time.  It calls
>> mod_node_page_state() as well, and the target's node counter is already
>> updated in alloc_hugetlb_folio_nodemask() (patch 1/2):
>>
>>      lruvec_stat_mod_folio(folio, NR_HUGETLB, folio_nr_pages(folio));
>>
>> For an uncharged folio lruvec_stat_mod_folio() only updates the node
>> counter.  The target folio is not charged to any memcg at that point; its
>> charge only appears later in mem_cgroup_migrate().  So the node side is
>> already covered and only the per-memcg attribution has to follow the
>> charge here.
> Looking at the first patch again, I do not think the
> overall accounting is incorrect. My concern is where NR_HUGETLB
> accounting is performed.
>
> The low-level allocation helpers only take a folio from the
> hugetlb pool. They do not have enough context to decide how
> the folio should be accounted. That decision should be left
> to their callers, once the folio enters the relevant usage
> lifecycle.
>
> hugetlb_alloc_folio() is a good example. It first obtains a
> folio, then calls mem_cgroup_charge_hugetlb(), and only
> afterwards calls lruvec_stat_mod_folio(). At that point,
> the folio has the correct memcg and lruvec, so all relevant
> counters can be updated together.
>
> After this series, alloc_hugetlb_folio_reserve() and
> alloc_hugetlb_folio_nodemask() account NR_HUGETLB before
> returning the folio. This makes them unsuitable for callers
> that need to charge the folio afterwards. Before the charge,
> lruvec_stat_mod_folio() can update only the node counter.
> The later charge does not associate that earlier update with
> the new memcg.
>
> If a caller accounts again after charging, the node counter is
> updated twice. If it does not, the memcg and per-node lruvec
> counters remain missing. The caller then needs a memcg-only
> correction, creating a special accounting protocol between
> the helper and its callers.
>
> Migration exposes the same issue. The target gets node
> accounting before it inherits the source memcg. The second patch
> must update the lruvec state and then cancel its node changes,
> because the target allocation already updated the node counter.
> This works, but makes the accounting lifecycle harder to follow.
>
> Would it be cleaner to keep these helpers focused on allocation
> and let each caller account at the correct lifecycle point?
> Normal allocation can account after a successful memcg charge.
> Migration can move the complete lruvec state after it succeeds.

Hi Muchun,

Thanks a lot for the detailed explanation.

One thing keeps the target accounting in alloc_hugetlb_folio_nodemask(): the
node counter is paired with the folio's free, and a failed migration 
frees its
target right away (put_new_folio()/folio_put() -> free_huge_folio(), which
always decrements the node counter). If the target were accounted only 
after a
successful migration, every failed migration would decrement a node counter
that was never incremented.

Unless there is a way to let free_huge_folio() tell that the folio comes
from a failed migration, and skip the decrement for it.

> An uncharged path can explicitly update only the node counter
> if global accounting is still required.
>
> This would keep policy out of the low-level allocator and make
> the accounting lifecycle easier to follow.
>
> Thanks.
>
>>> Thanks.
>>>
>>>> + mod_memcg_lruvec_state(mem_cgroup_lruvec(memcg, NODE_DATA(new_nid)),
>>>> +                   NR_HUGETLB, nr_pages);
>>>> +}
>>>> +
>>>>    void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio,
>>>>                enum migrate_reason reason)
>>>>    {
>>>>        struct hstate *h = folio_hstate(old_folio);
>>>>          hugetlb_cgroup_migrate(old_folio, new_folio);
>>>> +    move_hugetlb_lruvec_stat(old_folio, new_folio);
>>>>        folio_set_owner_migrate_reason(new_folio, reason);
>>>>          /*
>>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>>> index 88824f783571..a5335da5d425 100644
>>>> --- a/mm/memcontrol.c
>>>> +++ b/mm/memcontrol.c
>>>> @@ -1015,9 +1015,8 @@ static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
>>>>        put_cpu();
>>>>    }
>>>>    -static void mod_memcg_lruvec_state(struct lruvec *lruvec,
>>>> -                     enum node_stat_item idx,
>>>> -                     int val)
>>>> +void mod_memcg_lruvec_state(struct lruvec *lruvec,
>>>> +                enum node_stat_item idx, int val)
>>>>    {
>>>>        struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>>>>        struct mem_cgroup_per_node *pn;
>>>>
>> -- 
>> Best regards,
>> Hongfu

-- 
Best regards,
Hongfu


