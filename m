Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A595BCD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 07:16:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D621B6B0088; Wed,  3 Jun 2026 03:16:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEC5E6B008A; Wed,  3 Jun 2026 03:16:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB4D56B008C; Wed,  3 Jun 2026 03:16:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A69076B0088
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 03:16:12 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2D1A38CDA6
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 07:16:12 +0000 (UTC)
X-FDA: 84837742584.11.D5E6CED
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf05.hostedemail.com (Postfix) with ESMTP id 99A66100003
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 07:16:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pZNxQFnK;
	spf=pass (imf05.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780470969;
	b=7Jl0KmzAh4OAz67vYypElrAAJgu8N1OKWHLRT/i0c30kjjX8Ib91XTYwZFi1GAFel+gzgs
	I1xf39ZBWbLEICjBevWIwm2rafIXrODkFGv2A7DI6eGVM+byjFYefhEVsTLzi4So6w3O0F
	8kGlfOucRg1ReE78y4SZtWCXKiAOiQg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pZNxQFnK;
	spf=pass (imf05.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780470969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q5sVXXG5iIB+s5bZUY6unt5WcxY1ePGpKzFek5BfxMA=;
	b=ZMRaJP/JHnUD5fo2kpDK3y8+MuEQrdQqP86Hk1t7+lQ8dD6wHIWGthPNohm1ZMum9v5rgd
	kJOJplEmp3X8BLRk2lziByxrpo28MTJZXc01x1NP8eBQeKMcY58lUx0TeiiiAzByeCHk7E
	F0jMajtGnEy42Z52barE1cE3/FYKM4M=
Message-ID: <89e01c8e-1b08-45a6-a702-b23e45b70a29@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780470966;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q5sVXXG5iIB+s5bZUY6unt5WcxY1ePGpKzFek5BfxMA=;
	b=pZNxQFnKDfa4zACSef5UpUY/aGkNzGtg0dkRpfw2GtYv5O2Ap7oALYQKZV/t+iG/sUqmXu
	M9XBUgSy0pyER1DnjNwk6k8tPvmBLEczfg2Rh46i75Bjdc8BJXMPfes7YTkMhvRePB90aQ
	Bl2OvLcjKYUX70QwouK66aFPFqUTMUU=
Date: Wed, 3 Jun 2026 00:15:58 -0700
MIME-Version: 1.0
Subject: Re: [PATCH] mm/compaction: cap compact_gap() at COMPACT_CLUSTER_MAX
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, akpm@linux-foundation.org,
 surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260519200851.141955-1-jp.kobryn@linux.dev>
 <b4e49d71-bcd6-4c6c-87cb-2dbd75b3c2bb@kernel.org>
 <e318bbc0-3da5-4a49-bb1c-5777b7b4e4e7@linux.dev>
 <e65672e7-9a56-4489-84a1-db25d2c75f28@kernel.org>
 <b17dd2a3-8ca3-484e-8398-e5423f5df9c4@linux.dev>
 <71edb773-d156-49e6-ba6c-8159665a2dbc@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: JP Kobryn <jp.kobryn@linux.dev>
In-Reply-To: <71edb773-d156-49e6-ba6c-8159665a2dbc@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 99A66100003
X-Rspam-User: 
X-Stat-Signature: f6uqswohogbxcsg3y5mz59mezb3pb78m
X-HE-Tag: 1780470968-931223
X-HE-Meta: U2FsdGVkX1+VXbL/OGWc/K8KQ5cwH32Ku5vlqkzFPZp7yonxxL9He+0oFo/Zwum1K+omyWHHVLT8xq8pHBkCvlB6a2sfwhAS/IvXhxiYXNApHhilY65eHo80/Jil/pEPAZUqWQ9g8CCjtkE++8yDXNCQLklUur+RqfTwMKY9Fl2one/LoQUw+RiTUFwapP9xJ0DUVcfCbcBd+np0pHvRi639RF9I9lCjKkYCaoZh8fiRdSEDtBH677p3qD1foID/NDKxd3fvoMcYqgD6sYtOOLgFGYsmEYVW1UW58Y17IXMX22XoVyXMGOTOXRRdNjaIu0TV8PMRztu7PwGNz+ho7wvgQZoxT49ajQoSKHru+stSzfnXyhf0Lh4XC8rXALS5cQuFS+LucX2/hQ4Sjm6r2BQOIgWJFs/xyzG+eooZVoVdbDD/DNqwH8xfkrCgWCN8z9MJkrSEzwe3aPGWV3c1Fojk/zPJs0P1EU94JhEr9LEbcLLC6qXFQKp/iAo398o1d8HaxG1hp0o1Fv0qIQ5WUck4MGsYHZFutyKdAWbsJ+dOBXbDPyWcPUQqS3fvP9oRUHsbOCfOvrWY1Ztlv9MtHBZar8r6Urnuuiaykmi1M1sAOS/NbDCusAS3xscVXEbXS/gVqetwfLWo/85jUzy5yCm7UN81yoSCVZLzvjw7YJuCj1sunMm6e6xbuQukCO0WwVLelnI7dNN5slctqW928VxPwINbEo9y/Ar2F23R4zCHO68MvJdIZJ7MwiUF7P3xua5gElRy5nvHCPogqhVWbFsPUrbS08qKw02XLhHFSe9i7orpY0LkvKNdGxMHfcKXUgmQyI1DmN9vS+ppsMO3oQgKqRVX38rM3xpMrjSWRihARqkWJn0tJ4AxAs7vhyxFH0N7OYjcZT6IZVBwHwyUhaVrTlZDGdI03mKVgKpNDGzMMf8axpYee2WxgXt9hAX8PszalQb+09KksCqrzBk
 1i1jHdR8
 ItmqzDo5wgKBc8p9wA7Ps6YQnx3flAgOAsc0cYMZuBkbR2k8eRxBazhu60h78DOIjegNZDvFfRDRp+tvBZSIpvYmECIFxM2gRaUGr/0HEgLz2RKK0rzyE4nAc0XhwGa5eYSk2plXB14WvLFo3GC+Vqes8h/yGGmR+EMUvaSxT5LtLL9gHc9Aj6AHJAdiqkUEX99qSKXFX1SETIk8itOA1gntsriAYB0Q06vd8lTBLOFLuGK2miIJtTZCKehkpsmpkeijth1Nixwa9HaYtfQIKxeg5pb9LuUcle5NtI3NDQTaXjnIMeJsUYEjjig3XyTk6KBqr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/2/26 1:40 AM, Vlastimil Babka (SUSE) wrote:
> On 6/2/26 03:48, JP Kobryn wrote:
>> On 5/28/26 1:51 AM, Vlastimil Babka (SUSE) wrote:
>>> On 5/27/26 02:10, JP Kobryn wrote:
>>>> On 5/25/26 3:02 AM, Vlastimil Babka (SUSE) wrote:
>>>>> On 5/19/26 22:08, JP Kobryn (Meta) wrote:
>>>>>> compact_gap() returns 2 << order, which is used as watermark headroom in
>>>>>> __compaction_suitable() and as a reclaim target in kswapd. The computed
>>>>>> value scales exponentially by order. For order-9 THP allocations this
>>>>>> evaluates to 1024 pages, but the compaction free scanner's working set is
>>>>>> bounded by COMPACT_CLUSTER_MAX (32 pages). The scanner stops
>>>>>> isolating free
>>>>>> pages once it matches the migration batch. The current gap
>>>>>> over-reserves by
>>>>>> 32x.
>>>>>>
>>>>>> On fragmented production hosts, kswapd will try and reclaim up to the
>>>>>> gap,
>>>>>> but it only reaches that threshold 18% of the time, causing reclaim to
>>>>>> continue a majority of the time.
>>>>> But doesn't that mean there's genuine memory pressure? We're effectively
>>>>> raising the high watermark by 4 MB, but if processes are continuously
>>>>> allocating, we'd be reclaiming without the gap as well? Unless the
>>>>> workload
>>>>> is sized to fit without the gap.
>>>> It wasn't actual pressure, but the repetitive order-9 THP failures that were
>>>> waking up kswapd. I should make this more clear in the changelog. After
>>>> looking into why so much reclaim was occurring though, the compact gap stood
>>>> out since it dictates the target amount to reclaim.
>>> But the "amount to reclaim" is still defined as "reach high watermark +
>>> compact_gap()" and not "reclaim at least compact_gap() pages" right? Or did
>>> I miss something non-obvious.
>> Within kswapd_shrink_node(), sc->nr_to_reclaim is the sum of max(zone high
>> watermark or SWAP_CLUSTER_MAX) for each zone combined. The gap is not 
>> added to
>> that reclaim target though. It's used afterward as the threshold for 
>> abandoning
>> high order reclaim:
>>
>> if (sc->order && sc->nr_reclaimed >= compact_gap(sc->order))
>>      sc->order = 0;
>>
>> balance_pgdat() then returns sc->order and that becomes the kswapd 
>> reclaim_order
>> value, allowing this branch to be taken:
>>
>> if (reclaim_order < alloc_order)
>>      goto kswapd_try_sleep;
>>
>> Then in prepare_kswapd_sleep(), if pgdat_balanced() succeeds (at order-0),
>> kcompactd is woken up for the original alloc_order (order-9).
> 
> Oh I see, thanks for explaining. I think it makes sense to target this
> particular part (checking sc->nr_reclaimed) than change compact_gap()
> globally then? It seems we have some mismatch in the various heuristics? IIUC:

I gave this a try and got some interesting results. Based on mm-new as
of earlier today, I ran three variations: original compact_gap (2 <<
order), capped compact_gap (this patch), and capped downgrade gate which
has the original compact_gap (2 << order) but caps within
kswapd_shrink_node():

-       if (sc->order && sc->nr_reclaimed >= compact_gap(sc->order)) {
+       if (sc->order && sc->nr_reclaimed >=
+           min(compact_gap(sc->order), SWAP_CLUSTER_MAX)) {
              sc->order = 0;
        }

The new approach showed improvements in THP allocations.

thp_fault_fallback
  original gap: 1217
  capped gap (global): 738
  capped gap at downgrade gate: 898

More details are below.

> 
> - in shrink_node() we have a should_continue_reclaim() call, which will
> return false as soon as compaction is suitable, but before that, we are
> likely to not accumulate enough sc->nr_reclaimed, because sc->nr_to_reclaim
> would be capped by SWAP_CLUSTER_MAX's
> 
> - thus we won't pass the sc->nr_reclaimed >= compact_gap check in
> kswapd_shrink_node()
> 
> - balance_pgdat() will keep looping because we're not raising priority
> (kswapd_shrink_node() returned a high order) and pgdat_balanced() is false
> (it checks for high-order page availability)

I added some temporary tracepoints to verify paths taken. The average
hits across three 60s runs are shown below.

kswapd_shrink_node downgrade to order-0
  original gap:                     0
  capped gap (global, this patch): 28
  capped gap at downgrade gate:    80

So the downgrades are more frequent, but the suggested approach
regressed harder in terms of reclaim.

pgscan_kswapd
  original gap:                    6328
  capped gap (global, this patch): 3773
  capped gap at downgrade gate:    7988

pgsteal_kswapd
  original gap:                    5657
  capped gap (global, this patch): 3243
  capped gap at downgrade gate:    7101

This is because the suitability checks are still using the inflated gap
causing the split below.
  kswapd_shrink_node() gap:      32
  __compaction_suitable() gap: 1024

So it seems that capping globally (this patch) is the better option to
avoid the split above which causes unnecessary reclaim.

> 
> Maybe only reduce the sc->nr_reclaimed threshold to 2*COMPACT_CLUSTER_MAX then?

This was considered as well. But with the new findings, it would imply
even more reclaim.

> 
>>> So if kswapd did any work, it means the memory was consumed (i.e. there was
>>> some memory pressure) and amount of free memory was below high watermark +
>>> compact_gap()?
>> Hmm but kswapd can be woken up on a high order failure despite plenty of 
>> lower
>> order availability. That's really the case where compact_gap() matters for
>> higher orders.
> 
> Ack, thanks.
> 
>> Unless by pressure you mean the high order pages were gone?
> 
> No.
> 
>>
>>> BTW, are you using mglru here? (probably not)
>>> As that might be different and I'm not so familiar with it.
>> Using classic LRU.
>>
>>>>>> The over-sized gap also causes 46% of
>>>>>> order-9 compaction suitability checks to fail unnecessarily - the
>>>>>> zone has
>>>>>> sufficient free pages for the scanner to operate, but not enough to clear
>>>>>> the inflated threshold.
>>>>>>
>>>>>> Cap compact_gap() at COMPACT_CLUSTER_MAX to align the watermark headroom
>>>>>> with the scanner's actual capacity. Orders 0-4 are unaffected since their
>>>>>> gap is <= 32.
>>>>>>
>>>>>> A/B test on ~100 instagram production hosts (64GB, 60s measurement):
>>>>> What was the base kernel version?
>>>> 6.13. Additional benchmarks were done using a recent mm-new build as well,
>>>> and they showed similar reductions in reclaim.
>>> If it's a NUMA machine, we recently found an over-reclaim issue there fixed
>>> by 9c9828d3ead6 ("mm, page_alloc, thp: prevent reclaim for __GFP_THISNODE
>>> THP allocations")
>> Thanks for pointing this out. I tested this on a recent mm-new built that
>> includes 9c9828d3ead6, and I found the compact_gap() change was still 
>> helpful.
> 
> OK.
> 
>> My understanding is that 9c9828d3ead6 addresses direct reclaim for THP
>> allocations, while this patch affects the kswapd reclaim-compaction hand-off
>> path. The test runs still showed a benefit from capping the gap.
> 
> Yep.
> 
>>>>>> Unpatched (43 hosts)
>>>>>> pgscan_kswapd (mean/host): ~1.6M
>>>>>> reclaim efficiency (steal/scan): 83.8%
>>>>>> compaction success (success/stall): 2.1%
>>>>>> THP success (alloc/alloc+fallback): 4.9%
>>>>>> forced lru_add_drain (mean/host): ~107K
>>>>>>
>>>>>> Patched (59 hosts)
>>>>>> pgscan_kswapd (mean/host): ~449K
>>>>> Did the extra reclaim just disappear because we allow the allocations
>>>>> to use
>>>>> 4MB more memory? Or it shifted to direct reclaim?
>>>> Specifically in the order-9 case, the reclaim target goes from 1024 to 32.
>>>> What the data shows is that capping the gap allows compaction to take over
>>>> sooner and start working to produce large size pages needed for THP. Whereas
>>>> in the pre-patch state, trying to reclaim the full 2x THP delays compaction.
>>> So do I understand correctly we might have an issue due to lack of
>>> hysteresis? We require reaching high watermark + compact_gap() to terminate
>>> reclaim, but then compaction can find out we meanwhile dropped below that
>>> (due to concurrent allocations) and it's not suitable again?
>> On an unpatched kernel in a fragmented environment, 
>> compaction_suitable() can
>> remain false because the effective threshold for costly orders is the low
>> watermark + the compact gap. Kswapd has to keep reclaiming in high order 
>> mode
>> as a result.
> 
> I think this part might be ok.
> 
>> By capping the gap at SWAP_CLUSTER_MAX, compaction becomes 
>> suitable
>> sooner and kswapd reaches the high order reclaim cutoff sooner. So with 
> 
> And the problem is with the cutoff only which is not based on a
> watermark+gap threshold but wants to reclaim at least gap pages regardless
> of how many pages are already free.
> 
>> the patch,
>> kswapd is able to fall back to order-0 balancing earlier and wake up 
>> kcompactd
>> for the original high order request.
> 
> Yeah that's likely the crucial part.
> 
>>> However the suitability checks e.g. compaction_zonelist_suitable() are using
>>> min watermark, so that should provide the difference already.
>>> Actually it's low watermark because of __compaction_suitable() adding an
>>> extra low-min gap for costly orders. But still.
>>>
>>> I did just notice compaction_ready() might be too strict. It wants
>>> effectivly high wmark plus the gap plus the low-min difference. Is it
>>> perhaps the underlying issue here?
>> It's a good point. It does seem like that's worth looking into, and I'd be
>> happy to explore that separately.My thought at the moment though is that
>> changing compaction_ready() would be a different direction from the the 
>> original
>> focus of this patch, which started with the realization that the compaction
>> scanner working set is bounded by COMPACT_CLUSTER_MAX. Since 
> 
> Ack.
> 
>> compact_gap() is
>> used in multiple reclaim and compaction decisions, including 
>> compaction_ready(),
>> fixing its definition seemed like the right first change if the gap 
>> itself is
>> oversized.
> 
> Still I'd try to address the sc->nr_reclaimed usage first, and see if that's
> enough.

Let me know if I covered that above.

> 
>>>>>> reclaim efficiency (steal/scan): 91.0%
>>>>>> compaction success (success/stall): 28.3%
>>>>> Is this compaction success per compaction stall or per alloc stall?
>>>> That's per compaction.
>>>>
>>>>>> THP success (alloc/alloc+fallback): 17.2%
>>>>> Weird that things would improve that much. I would expect the free memory
>>>>> just to stabilize around the lower gap but then behave similarly. Are we
>>>>> missing something here?
>>>> This patch was tested in isolation, but also occurring was the case where
>>>> bursty net allocations reserve many pageblocks as high atomic. So as
>>>> THP-size pages become eligible, their blocks are reserved before being
>>>> allocated as THP.
>>>>
>>>>>> forced lru_add_drain (mean/host): ~64K
>>>>>>
>>>>>> Signed-off-by: JP Kobryn (Meta)<jp.kobryn@linux.dev>
>>>>>> ---
>>>>>> include/linux/compaction.h | 8 ++++----
>>>>>> 1 file changed, 4 insertions(+), 4 deletions(-)
>>>>>>
>>>>>> diff --git a/include/linux/compaction.h b/include/linux/compaction.h
>>>>>> index 173d9c07a8952..09aea63b8a89d 100644
>>>>>> --- a/include/linux/compaction.h
>>>>>> +++ b/include/linux/compaction.h
>>>>>> @@ -2,6 +2,8 @@
>>>>>> #ifndef _LINUX_COMPACTION_H
>>>>>> #define _LINUX_COMPACTION_H
>>>>>> +#include <linux/swap.h>
>>>>>> +
>>>>>> /*
>>>>>> * Determines how hard direct compaction should try to succeed.
>>>>>> * Lower value means higher priority, analogically to reclaim priority.
>>>>>> @@ -73,11 +75,9 @@ static inline unsigned long compact_gap(unsigned
>>>>>> int order)
>>>>>> * effectively limited by COMPACT_CLUSTER_MAX, as that's the maximum
>>>>>> * that the migrate scanner can have isolated on migrate list, and free
>>>>>> * scanner is only invoked when the number of isolated free pages is
>>>>>> - * lower than that. But it's not worth to complicate the formula here
>>>>>> - * as a bigger gap for higher orders than strictly necessary can also
>>>>>> - * improve chances of compaction success.
>>>>>> + * lower than that.
>>>>>> */
>>>>>> - return 2UL << order;
>>>>>> + return min(2UL << order, COMPACT_CLUSTER_MAX);
>>>>> Shouldn't it at least be 2x COMPACT_CLUSTER_MAX?
>>>> I'm thinking I could reframe this patch as reclaim-focused and use
>>>> min(2UL << order, COMPACT_CLUSTER_MAX) as a reclaim-only target, while
>>>> either leaving the other non-reclaim users of this function alone or
>>>> using the 2x form you suggest above. i.e. I can split this function
>>>> into a separate reclaim_compact_gap() and use the originally proposed cap.
>>>> Thoughts?
>>> Do I understand correctly you want to cap the reclaim target by
>>> COMPACT_CLUSTER_MAX but leave e.g. the compaction_suitable() usage as it is?
>>> But wouldn't that mean we'll actually make changes of passing
>>> compaction_suitable() worse?
>> Good call. I was trying to find some middle ground, but I realize that the
>> change is better left unified.
> 
> My question was based on not understanding the underlying issue, and that
> the "reclaim-only target" isn't based on watermark+gap but "reclaim gap
> worth of pages".  Now I think sc->nr_reclaimed is indeed the check that
> should be relaxed first.

Hopefully the data helps this time around.

