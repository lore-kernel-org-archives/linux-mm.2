Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD541EE20BD
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 08:17:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E06B46B0005; Mon,  9 Feb 2026 03:17:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB3A36B0088; Mon,  9 Feb 2026 03:17:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB2886B0089; Mon,  9 Feb 2026 03:17:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA3EB6B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 03:17:24 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2114E1B2FD3
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 08:17:24 +0000 (UTC)
X-FDA: 84424213608.13.D523702
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3A73840002
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 08:17:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	spf=pass (imf07.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770625042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jyaX9VSLBdbnNBt5AvbHUd6L7XoEFfkRLFyElTfcEc0=;
	b=E2XNiWp78shn1PsVXw03N4OW4NOIdnQeivpWSQ4BlbuXCK8kAnzoi+rCLQ69jCMnynpMH7
	EjFTM3zKU+iMX4igjt/4jTffEZ635cw+s9fAv1oJeBH25fU/e+Pqw7yx60a38XKYId/n5m
	mL9NV1p0+aZR9UdnnNKRSlH81ifRQYA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770625042; a=rsa-sha256;
	cv=none;
	b=Gzew8+oCm/XNgDGn7OnWkwpLVtdA2DVgx32D03a5sSWdaNP6AK+sThd/u/DYC7dIcvcTa4
	gM6yENWS7zdS9rfrUcABxto65dAAXJysTgGM5iGRKX+xBVDXLsi32W75jvqSnWe2lRwIQ0
	0IfKeWRz3/3bcniymRIA2JzV9RcvoFs=
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4f8cwH6s01zYQtlM
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 16:16:15 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 263DE40590
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 16:17:13 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP4 (Coremail) with SMTP id gCh0CgDnR_gGmIlph7o1Gw--.57276S2;
	Mon, 09 Feb 2026 16:17:12 +0800 (CST)
Message-ID: <6ad1fb5d-a859-4611-8af9-aa4d37aeeb38@huaweicloud.com>
Date: Mon, 9 Feb 2026 16:17:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH -next 1/7] vmscan: add memcg heat level for reclaim
To: Yuanchu Xie <yuanchu@google.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, weixugc@google.com,
 david@kernel.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 corbet@lwn.net, skhan@linuxfoundation.org, hannes@cmpxchg.org,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 zhengqi.arch@bytedance.com, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, lujialin4@huawei.com,
 ryncsn@gmail.com
References: <20260120134256.2271710-1-chenridong@huaweicloud.com>
 <20260120134256.2271710-2-chenridong@huaweicloud.com>
 <CAJj2-QEvrgQ+R-nc3LZ-cBfnzjakxfSgmNbqDa-RFBVOpdVaAQ@mail.gmail.com>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <CAJj2-QEvrgQ+R-nc3LZ-cBfnzjakxfSgmNbqDa-RFBVOpdVaAQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDnR_gGmIlph7o1Gw--.57276S2
X-Coremail-Antispam: 1UD129KBjvJXoW3XrWxWw47CFy7XrWkWry7GFg_yoWfZFyfpF
	Z3JF4ayan7Xr13Kwnaq3WUWr93Aw1xKr1ayrW3KF1fAwsIvr10vw42kr43ZFW5ArWUXr1f
	ZryYgr13uw4qva7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvYb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
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
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x07
	jIksgUUUUU=
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Stat-Signature: 6xdzgjrqfsfbrbkhorfhdxjnhdppfow9
X-Rspamd-Queue-Id: 3A73840002
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770625037-460419
X-HE-Meta: U2FsdGVkX18iomO4b2Ttm93OmUeMht0UsycCI7gTXFMp60vGnB4eAulx5Z1iGfkjOt+6c8y5KFzX7Zut6aOg2HFMj2x249cNUXKyUK5nm0EBmld+ZmeMJ/6BhhfUSCqsR9juHlpDbxNm9J7sRkIJJkEOiG5adMQJ65CE1w80TIROzDg8aJlxe+EFP1M+r+deLhI4q3ArxmqLoy2Mfsb+QHA7oDP41yZ7sT7AttzdIHjmvHJO+yMXeWYp+9D1e9fcvUiTQqO2aXSoS9gqhBnwuQdXtL+dKipkeuiSCLqUer1/XuR7FfdGmvnqk82shLO5Ek7X0GMpYxzApfyOKQUr4fzMKC4GKv7YkXhh8G1dZ44+m8IyIidjMhaEcvw1BiHhAM9IzILNS4FANTAcMJqWgmhQE7/cp5/4Pb42pTzCXNa7E+PV/2FwKi8afycWzkhzlgBOgPM5YZBFz44dhr+SCHiFvbDbSvwXcQwdQxonoZ8HWED46BYASidYBd2PeqD4VkMw5f4dJ07dAkbn2Ma5yPMTX9PX8lBOd4soQEJj/YP7FdLwSKcNRjkHjqPdNS1WeryRjMoqiyAiq13JLnt8FSj/NpXTttd4uIosWHXNHt0r+1Y4xr3pCrHm52DDjZJdsZVH+8Ln6eySKf4gjlkA0+z8Bl8Hs6X02gzaFQEttJnvTOyxtnAiEdWiVyMNY2EFy5K+FOCLklSQius7d41IoCwtoviasSPuPQD1vFdFb7agLitzI4KgZVpJtUPNStqg75SJm6uuAKTKyNO5wEhmOlrRUV1WMvosvPWv6AtDrqkoiuSmLwEEsPUMNHbvu9debJadNrEBOBDfI+mtt/oJtM1wWg1fORLdAzHzNLcfkMiAjPVUqB/RJxYMqjagykasWHpX90AVlfFRcA8x1+9nJ+g7FsoFAdSJgv6iaGZWZsW721tU3s9oMiDVlXiKpT8ApSPkdfwwZw+lQKLPPRw
 SLXKGR0N
 CvzUV8zZxiWPc7FiSwHOgB8sqCMzeW0qe+xHH5WrAKdhN4THNssfAEdUmJxVob7xuK41gvNP8fWUfIwkdZ2d/EOIsck2k8zN7uerOD/6m9/UHUD7JAjAmXvihYb4RJwOel5dgzzgNY5e5a7kkflNKiodBS45j0T9O5GZUgVtsi920QjwBuE4QxtjGnVdj+eA1BO3vBPQRdPXb1yYsSJ8oDwJhNcgH3q2WNdbdYV1Inc4LtBQ0L0W8Kko0Qt7KlkdqhBEMaiLRxtlGyhY6Dj8kIyPVOK+nvn6PaUa57r9apoNDwTI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Yuanchu,

On 2026/2/7 6:47, Yuanchu Xie wrote:
> Hi Ridong,
> 
> Thanks for working to reconcile the gaps between the LRU implementations.
> 
> On Tue, Jan 20, 2026 at 7:57 AM Chen Ridong <chenridong@huaweicloud.com> wrote:
>>
>> From: Chen Ridong <chenridong@huawei.com>
>>
>> The memcg LRU was originally introduced to improve scalability during
>> global reclaim. However, it is complex and only works with gen lru
>> global reclaim. Moreover, its implementation complexity has led to
>> performance regressions when handling a large number of memory cgroups [1].
>>
>> This patch introduces a per-memcg heat level for reclaim, aiming to unify
>> gen lru and traditional LRU global reclaim. The core idea is to track
>> per-node per-memcg reclaim state, including heat, last_decay, and
>> last_refault. The last_refault records the total reclaimed data from the
>> previous memcg reclaim. The last_decay is a time-based parameter; the heat
>> level decays over time if the memcg is not reclaimed again. Both last_decay
>> and last_refault are used to calculate the current heat level when reclaim
>> starts.
>>
>> Three reclaim heat levels are defined: cold, warm, and hot. Cold memcgs are
>> reclaimed first; only if cold memcgs cannot reclaim enough pages, warm
>> memcgs become eligible for reclaim. Hot memcgs are reclaimed last.
>>
>> While this design can be applied to all memcg reclaim scenarios, this patch
>> is conservative and only introduces heat levels for traditional LRU global
>> reclaim. Subsequent patches will replace the memcg LRU with
>> heat-level-based reclaim.
>>
>> Based on tests provided by YU Zhao, traditional LRU global reclaim shows
>> significant performance improvement with heat-level reclaim enabled.
>>
>> The results below are from a 2-hour run of the test [2].
>>
>> Throughput (number of requests)         before     after        Change
>> Total                                   1734169    2353717      +35%
>>
>> Tail latency (number of requests)       before     after        Change
>> [128s, inf)                             1231       1057         -14%
>> [64s, 128s)                             586        444          -24%
>> [32s, 64s)                              1658       1061         -36%
>> [16s, 32s)                              4611       2863         -38%
> 
> Do you have any numbers comparing heat-based reclaim to memcg LRU?  I
> know Johannes suggested removing memcg LRU, and what you have here
> applies to more reclaim scenarios.
> 

Yes, the test data is provided in patch 5/7.

>>
>> [1] https://lore.kernel.org/r/20251126171513.GC135004@cmpxchg.org
>> [2] https://lore.kernel.org/all/20221220214923.1229538-1-yuzhao@google.com/
>>
>> Signed-off-by: Chen Ridong <chenridong@huawei.com>
>> ---
>>  include/linux/memcontrol.h |   7 ++
>>  mm/memcontrol.c            |   3 +
>>  mm/vmscan.c                | 227 +++++++++++++++++++++++++++++--------
>>  3 files changed, 192 insertions(+), 45 deletions(-)
>>
>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>> index af352cabedba..b293caf70034 100644
>> --- a/include/linux/memcontrol.h
>> +++ b/include/linux/memcontrol.h
>> @@ -76,6 +76,12 @@ struct memcg_vmstats;
>>  struct lruvec_stats_percpu;
>>  struct lruvec_stats;
>>
>> +struct memcg_reclaim_state {
>> +       atomic_long_t heat;
>> +       unsigned long last_decay;
>> +       atomic_long_t last_refault;
>> +};
>> +
>>  struct mem_cgroup_reclaim_iter {
>>         struct mem_cgroup *position;
>>         /* scan generation, increased every round-trip */
>> @@ -114,6 +120,7 @@ struct mem_cgroup_per_node {
>>         CACHELINE_PADDING(_pad2_);
>>         unsigned long           lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
>>         struct mem_cgroup_reclaim_iter  iter;
>> +       struct memcg_reclaim_state      reclaim;
>>
>>  #ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
>>         /* slab stats for nmi context */
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index f2b87e02574e..675d49ad7e2c 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -3713,6 +3713,9 @@ static bool alloc_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)
>>
>>         lruvec_init(&pn->lruvec);
>>         pn->memcg = memcg;
>> +       atomic_long_set(&pn->reclaim.heat, 0);
>> +       pn->reclaim.last_decay = jiffies;
>> +       atomic_long_set(&pn->reclaim.last_refault, 0);
>>
>>         memcg->nodeinfo[node] = pn;
>>         return true;
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 4aa73f125772..3759cd52c336 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -5978,6 +5978,124 @@ static inline bool should_continue_reclaim(struct pglist_data *pgdat,
>>         return inactive_lru_pages > pages_for_compaction;
>>  }
>>
>> +enum memcg_scan_level {
>> +       MEMCG_LEVEL_COLD,
>> +       MEMCG_LEVEL_WARM,
>> +       MEMCG_LEVEL_HOT,
>> +       MEMCG_LEVEL_MAX,
>> +};
>> +
>> +#define MEMCG_HEAT_WARM                4
>> +#define MEMCG_HEAT_HOT         8
>> +#define MEMCG_HEAT_MAX         12
>> +#define MEMCG_HEAT_DECAY_STEP  1
>> +#define MEMCG_HEAT_DECAY_INTERVAL      (1 * HZ)
> I agree with Kairui; I'm somewhat concerned about this fixed decay
> interval and how it behaves with many memcgs or heavy pressure.
> 

Yes, a fixed decay interval may not be optimal for all scenarios. It serves as a
foundational baseline. Perhaps we could expose a BPF hook here for more flexible
tuning.

The referenced benchmark [2] specifically tests under heavy pressure
(continuously triggering global reclaim) and with a large number of memory cgroups.


>> +
>> +static void memcg_adjust_heat(struct mem_cgroup_per_node *pn, long delta)
>> +{
>> +       long heat, new_heat;
>> +
>> +       if (mem_cgroup_is_root(pn->memcg))
>> +               return;
>> +
>> +       heat = atomic_long_read(&pn->reclaim.heat);
>> +       do {
>> +               new_heat = clamp_t(long, heat + delta, 0, MEMCG_HEAT_MAX);
>> +               if (atomic_long_cmpxchg(&pn->reclaim.heat, heat, new_heat) == heat)
>> +                       break;
>> +               heat = atomic_long_read(&pn->reclaim.heat);
>> +       } while (1);
>> +}
>> +
>> +static void memcg_decay_heat(struct mem_cgroup_per_node *pn)
>> +{
>> +       unsigned long last;
>> +       unsigned long now = jiffies;
>> +
>> +       if (mem_cgroup_is_root(pn->memcg))
>> +               return;
>> +
>> +       last = READ_ONCE(pn->reclaim.last_decay);
>> +       if (!time_after(now, last + MEMCG_HEAT_DECAY_INTERVAL))
>> +               return;
>> +
>> +       if (cmpxchg(&pn->reclaim.last_decay, last, now) != last)
>> +               return;
>> +
>> +       memcg_adjust_heat(pn, -MEMCG_HEAT_DECAY_STEP);
>> +}
>> +
>> +static int memcg_heat_level(struct mem_cgroup_per_node *pn)
>> +{
>> +       long heat;
>> +
>> +       if (mem_cgroup_is_root(pn->memcg))
>> +               return MEMCG_LEVEL_COLD;
>> +
>> +       memcg_decay_heat(pn);
> The decay here is somewhat counterintuitive given the name memcg_heat_level.
> 

The decay is integrated into the level retrieval. Essentially, whenever
memcg_heat_level is fetched, we check if the decay interval has elapsed
(interval > MEMCG_HEAT_DECAY_INTERVAL). If so, the decay is applied.

>> +       heat = atomic_long_read(&pn->reclaim.heat);
>> +
>> +       if (heat >= MEMCG_HEAT_HOT)
>> +               return MEMCG_LEVEL_HOT;
>> +       if (heat >= MEMCG_HEAT_WARM)
>> +               return MEMCG_LEVEL_WARM;
>> +       return MEMCG_LEVEL_COLD;
>> +}
>> +
>> +static void memcg_record_reclaim_result(struct mem_cgroup_per_node *pn,
>> +                                       struct lruvec *lruvec,
>> +                                       unsigned long scanned,
>> +                                       unsigned long reclaimed)
>> +{
>> +       long delta;
>> +
>> +       if (mem_cgroup_is_root(pn->memcg))
>> +               return;
>> +
>> +       memcg_decay_heat(pn);
> Could you combine the decay and adjust later in this function?
> 

Sure.

>> +
>> +       /*
>> +        * Memory cgroup heat adjustment algorithm:
>> +        * - If scanned == 0: mark as hottest (+MAX_HEAT)
>> +        * - If reclaimed >= 50% * scanned: strong cool (-2)
>> +        * - If reclaimed >= 25% * scanned: mild cool (-1)
>> +        * - Otherwise:  warm up (+1)
>> +        */
>> +       if (!scanned)
>> +               delta = MEMCG_HEAT_MAX;
>> +       else if (reclaimed * 2 >= scanned)
>> +               delta = -2;
>> +       else if (reclaimed * 4 >= scanned)
>> +               delta = -1;
>> +       else
>> +               delta = 1;
>> +
>> +       /*
>> +        * Refault-based heat adjustment:
>> +        * - If refault increase > reclaimed pages: heat up (more cautious reclaim)
>> +        * - If no refaults and currently warm:     cool down (allow more reclaim)
>> +        * This prevents thrashing by backing off when refaults indicate over-reclaim.
>> +        */
>> +       if (lruvec) {
>> +               unsigned long total_refaults;
>> +               unsigned long prev;
>> +               long refault_delta;
>> +
>> +               total_refaults = lruvec_page_state(lruvec, WORKINGSET_ACTIVATE_ANON);
>> +               total_refaults += lruvec_page_state(lruvec, WORKINGSET_ACTIVATE_FILE);
>> +
>> +               prev = atomic_long_xchg(&pn->reclaim.last_refault, total_refaults);
>> +               refault_delta = total_refaults - prev;
>> +
>> +               if (refault_delta > reclaimed)
>> +                       delta++;
>> +               else if (!refault_delta && delta > 0)
>> +                       delta--;
>> +       }
> 
> I think this metric is based more on the memcg's reclaimability than
> on heat. Though the memcgs are grouped based on absolute metrics and
> not relative to others.
> 

I might be misunderstanding your comment. Could you elaborate?

As designed, the heat level is indeed derived from the memcg's own
reclaimability (reclaimed/scanned) and refault behavior. In essence, it
quantifies the difficulty or “heat” of reclaiming memory from that specific
cgroup. This metric directly correlates to whether a memcg can release memory
easily or not.

>> +
>> +       memcg_adjust_heat(pn, delta);
>> +}
>> +
>>  static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
>>  {
>> ...snip
>>  }
> 
> Thanks,
> Yuanchu

-- 
Best regards,
Ridong


