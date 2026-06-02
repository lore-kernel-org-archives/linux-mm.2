Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF489C5DF71
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 08:41:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FEE16B03E6; Tue,  2 Jun 2026 04:41:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AFB46B03E9; Tue,  2 Jun 2026 04:41:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19F806B03EA; Tue,  2 Jun 2026 04:41:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 097826B03E6
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:41:05 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 854401A0819
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 08:41:04 +0000 (UTC)
X-FDA: 84834327648.15.0906EF6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id C1A0FA0006
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 08:41:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n0dpJB8W;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780389662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kCFTRUycDdBmqPQwI4uMA55U/gf3S30zfDiscHVO54E=;
	b=6+52nssD8fMOKdhm606qB3rAC0mystIcts4RrJWJMfyRw8EkgllLPoUsyM153t3jfeiguz
	7dfheGs5P2kgWW+ZqzIlY12x8nLEOij2ILGDdx8+jzC4ppmGViKmNgqN1+HndvKJoo3sOz
	2kZSZDfaBnMzrG/FQqBKzUiy+K4T3pI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n0dpJB8W;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780389662;
	b=EocIRBcTT7M21k3+972j5fm2cGwi6aEZ1TlvHlqwwX0znzI4iFdKQN0edGi//X4vWkB+kk
	xjCPnoHdGPjED9Qnxen+o5TdmBYkmsBC+8CIVejsewIiqQHWfqur+MW4PgS4SguvdbSMhV
	AhJTu5KVFPVgPlmwU8W2ylFQR+3GZOc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 226ED60126;
	Tue,  2 Jun 2026 08:41:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A501F00893;
	Tue,  2 Jun 2026 08:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780389661;
	bh=kCFTRUycDdBmqPQwI4uMA55U/gf3S30zfDiscHVO54E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=n0dpJB8Wpm+7HTGbdua4sAbSgTqoT9Ko+gkr5D0BR7s9DCHBpsFDELBPEw++ezWWJ
	 15WKURFH/5ZBZY97dRcA7Eu7dUzi07+gCzzhkN7wFihRdUxV8okvA6pvMnd93Qb0Pl
	 FsJ2lyM9bSQC0SRMh77UOIZNSav01sc+0TeXphGcG6VIfBH7/1QYxYtcBEyONAWlng
	 l3Wcarv8rerrK9SdMih7vaR+wzsPYkdlKgy3HrmYQk7M05bqwyhvniDcfQFWTEEYem
	 oj7P014MWQY9L51b2MY7QI3g6UPJJ4XyMOP9Y3GPRtfheYCdpPEZdqHk3EXV9wK5De
	 xXHB8OvwXvjLw==
Message-ID: <71edb773-d156-49e6-ba6c-8159665a2dbc@kernel.org>
Date: Tue, 2 Jun 2026 10:40:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/compaction: cap compact_gap() at COMPACT_CLUSTER_MAX
Content-Language: en-US
To: JP Kobryn <jp.kobryn@linux.dev>, akpm@linux-foundation.org,
 surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260519200851.141955-1-jp.kobryn@linux.dev>
 <b4e49d71-bcd6-4c6c-87cb-2dbd75b3c2bb@kernel.org>
 <e318bbc0-3da5-4a49-bb1c-5777b7b4e4e7@linux.dev>
 <e65672e7-9a56-4489-84a1-db25d2c75f28@kernel.org>
 <b17dd2a3-8ca3-484e-8398-e5423f5df9c4@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <b17dd2a3-8ca3-484e-8398-e5423f5df9c4@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C1A0FA0006
X-Stat-Signature: 6nq9mmuizk3hmogg3ewc4583edmtk4m1
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780389662-420734
X-HE-Meta: U2FsdGVkX19SXwXE57tarrb8+IZH+LnRNInjQC6LbCaYSPQ7Ald2RX5mglT5PIiRYc1GSYTey6K3/wz6dmCskBscweyy0tiI0kijuYZyaqEG0hnPA3oUy79QHU/R/G9ura0WUOpye1Utc93NRmUfn7/WLj8fDgPhjcpZmo5sEqH+upyc1BRsl2araSytm0Y6nOTE1zwaWYFw1suq2+LHtbPVLXSkPZZhnuLzyfTaRZBoL5Nku3Rq7qOhu2SEwsDxRa9az3I/JKS2Oyt+hYO9L3wJwSpQTo3u0I73Y/6LeTN3TR+P3ctCmFWTG/scoNmLK8y5gJdeT3IIqCGNjWEGwJoVUyGG/fcLElbjOWEvkwyRqUtT61Nj8pvtOr82ERSWaLWVUuWRO2u1mDzeTwZ7jMayanfGax+YQEHtZ8Wy8j1ObafsObY/N+HERo4K+2th1hnC4eMXTta9a2E6SF3A2dHlJqQQchKjeE4PddRFEVjCGS9Ac62TlfXBLcMTMzIqN+bwNUS/UzxTigcW+3OAZ/O67cjO0Z+h21U9EiUObxqBmFM9BkQAGhv48BdGriCH33+n9ghW2xRB+tXHWAafURQj3IECCBDpocwipH3IL6GaZYZdx+Vwg5ETRnwVsBVoWBurPCMmsopaY7lASdBS8rM53v+VmfDLSbca6QuD8VnTHn7/I6cQSjvDhTNnbJIp2KE8F+iVKU5cocb/mnmcgpU1anbHSz8EzSzNgTlvXmxLSSSjji6joshsURZpPVcCa04euFY742THILjrm3FvOeJ3+zaZ9KS8cTxbMoahvJJkRZg21KAQqwA4XInTVedCjPt7vQZf4MtA58K6tSZ4o97fYk0imuA69D+75lgjo8tQBhmZJgexOsSKQV5UiGuT16XC5h9OYyFyhRq80l+QM5dIT2nlO8hZJQD+Bh2XSGAf7ysh8Q5MMkmeRUPGZLghypkhPbK5y7eWe0jaksE
 pLYqsWwb
 oHrn9Bmn4eGgLEqK8CeHSZu6w6senmR3UgSxAFT6N6mxbMLOZJY/k3H7e/z61JqYGc/YcpxovzNBOrbvMv4H6q63LD8vmX9q9lJwbPvT/kWispOfmVtPiNNF89AegC+uPojE56+JiPWUi8PKCgv60Er8G5/WxqZJ6j/S6M1cl+CvmiwpLg21IUlupXDMBLCy30GL+45Gc9gBMAnTJFcaF/qX2sBczgMTrwP8dFjo6QIkHE5AfM4cAnnN+F2jZlLaCUq4Ku8De0zLfPf04QMgOHWtojfAFyd4fGjj4GRCPVl0BJnvIplImf8SLU7LtOZ+FpDY5MP/0Bxlz3QuYnlFFb/NAAqBsZw5sVYdV2WhZ77bSoI01qwsbMFK6UA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/2/26 03:48, JP Kobryn wrote:
> On 5/28/26 1:51 AM, Vlastimil Babka (SUSE) wrote:
>> On 5/27/26 02:10, JP Kobryn wrote:
>>> On 5/25/26 3:02 AM, Vlastimil Babka (SUSE) wrote:
>>>> On 5/19/26 22:08, JP Kobryn (Meta) wrote:
>>>>> compact_gap() returns 2 << order, which is used as watermark headroom in
>>>>> __compaction_suitable() and as a reclaim target in kswapd. The computed
>>>>> value scales exponentially by order. For order-9 THP allocations this
>>>>> evaluates to 1024 pages, but the compaction free scanner's working set is
>>>>> bounded by COMPACT_CLUSTER_MAX (32 pages). The scanner stops
>>>>> isolating free
>>>>> pages once it matches the migration batch. The current gap
>>>>> over-reserves by
>>>>> 32x.
>>>>>
>>>>> On fragmented production hosts, kswapd will try and reclaim up to the
>>>>> gap,
>>>>> but it only reaches that threshold 18% of the time, causing reclaim to
>>>>> continue a majority of the time.
>>>> But doesn't that mean there's genuine memory pressure? We're effectively
>>>> raising the high watermark by 4 MB, but if processes are continuously
>>>> allocating, we'd be reclaiming without the gap as well? Unless the
>>>> workload
>>>> is sized to fit without the gap.
>>> It wasn't actual pressure, but the repetitive order-9 THP failures that were
>>> waking up kswapd. I should make this more clear in the changelog. After
>>> looking into why so much reclaim was occurring though, the compact gap stood
>>> out since it dictates the target amount to reclaim.
>> But the "amount to reclaim" is still defined as "reach high watermark +
>> compact_gap()" and not "reclaim at least compact_gap() pages" right? Or did
>> I miss something non-obvious.
> Within kswapd_shrink_node(), sc->nr_to_reclaim is the sum of max(zone high
> watermark or SWAP_CLUSTER_MAX) for each zone combined. The gap is not 
> added to
> that reclaim target though. It's used afterward as the threshold for 
> abandoning
> high order reclaim:
> 
> if (sc->order && sc->nr_reclaimed >= compact_gap(sc->order))
>      sc->order = 0;
> 
> balance_pgdat() then returns sc->order and that becomes the kswapd 
> reclaim_order
> value, allowing this branch to be taken:
> 
> if (reclaim_order < alloc_order)
>      goto kswapd_try_sleep;
> 
> Then in prepare_kswapd_sleep(), if pgdat_balanced() succeeds (at order-0),
> kcompactd is woken up for the original alloc_order (order-9).

Oh I see, thanks for explaining. I think it makes sense to target this
particular part (checking sc->nr_reclaimed) than change compact_gap()
globally then? It seems we have some mismatch in the various heuristics? IIUC:

- in shrink_node() we have a should_continue_reclaim() call, which will
return false as soon as compaction is suitable, but before that, we are
likely to not accumulate enough sc->nr_reclaimed, because sc->nr_to_reclaim
would be capped by SWAP_CLUSTER_MAX's

- thus we won't pass the sc->nr_reclaimed >= compact_gap check in
kswapd_shrink_node()

- balance_pgdat() will keep looping because we're not raising priority
(kswapd_shrink_node() returned a high order) and pgdat_balanced() is false
(it checks for high-order page availability)

Maybe only reduce the sc->nr_reclaimed threshold to 2*COMPACT_CLUSTER_MAX then?

>> So if kswapd did any work, it means the memory was consumed (i.e. there was
>> some memory pressure) and amount of free memory was below high watermark +
>> compact_gap()?
> Hmm but kswapd can be woken up on a high order failure despite plenty of 
> lower
> order availability. That's really the case where compact_gap() matters for
> higher orders.

Ack, thanks.

> Unless by pressure you mean the high order pages were gone?

No.

> 
>> BTW, are you using mglru here? (probably not)
>> As that might be different and I'm not so familiar with it.
> Using classic LRU.
> 
>>>>> The over-sized gap also causes 46% of
>>>>> order-9 compaction suitability checks to fail unnecessarily - the
>>>>> zone has
>>>>> sufficient free pages for the scanner to operate, but not enough to clear
>>>>> the inflated threshold.
>>>>>
>>>>> Cap compact_gap() at COMPACT_CLUSTER_MAX to align the watermark headroom
>>>>> with the scanner's actual capacity. Orders 0-4 are unaffected since their
>>>>> gap is <= 32.
>>>>>
>>>>> A/B test on ~100 instagram production hosts (64GB, 60s measurement):
>>>> What was the base kernel version?
>>> 6.13. Additional benchmarks were done using a recent mm-new build as well,
>>> and they showed similar reductions in reclaim.
>> If it's a NUMA machine, we recently found an over-reclaim issue there fixed
>> by 9c9828d3ead6 ("mm, page_alloc, thp: prevent reclaim for __GFP_THISNODE
>> THP allocations")
> Thanks for pointing this out. I tested this on a recent mm-new built that
> includes 9c9828d3ead6, and I found the compact_gap() change was still 
> helpful.

OK.

> My understanding is that 9c9828d3ead6 addresses direct reclaim for THP
> allocations, while this patch affects the kswapd reclaim-compaction hand-off
> path. The test runs still showed a benefit from capping the gap.

Yep.

>>>>> Unpatched (43 hosts)
>>>>> pgscan_kswapd (mean/host): ~1.6M
>>>>> reclaim efficiency (steal/scan): 83.8%
>>>>> compaction success (success/stall): 2.1%
>>>>> THP success (alloc/alloc+fallback): 4.9%
>>>>> forced lru_add_drain (mean/host): ~107K
>>>>>
>>>>> Patched (59 hosts)
>>>>> pgscan_kswapd (mean/host): ~449K
>>>> Did the extra reclaim just disappear because we allow the allocations
>>>> to use
>>>> 4MB more memory? Or it shifted to direct reclaim?
>>> Specifically in the order-9 case, the reclaim target goes from 1024 to 32.
>>> What the data shows is that capping the gap allows compaction to take over
>>> sooner and start working to produce large size pages needed for THP. Whereas
>>> in the pre-patch state, trying to reclaim the full 2x THP delays compaction.
>> So do I understand correctly we might have an issue due to lack of
>> hysteresis? We require reaching high watermark + compact_gap() to terminate
>> reclaim, but then compaction can find out we meanwhile dropped below that
>> (due to concurrent allocations) and it's not suitable again?
> On an unpatched kernel in a fragmented environment, 
> compaction_suitable() can
> remain false because the effective threshold for costly orders is the low
> watermark + the compact gap. Kswapd has to keep reclaiming in high order 
> mode
> as a result.

I think this part might be ok.

> By capping the gap at SWAP_CLUSTER_MAX, compaction becomes 
> suitable
> sooner and kswapd reaches the high order reclaim cutoff sooner. So with 

And the problem is with the cutoff only which is not based on a
watermark+gap threshold but wants to reclaim at least gap pages regardless
of how many pages are already free.

> the patch,
> kswapd is able to fall back to order-0 balancing earlier and wake up 
> kcompactd
> for the original high order request.

Yeah that's likely the crucial part.

>> However the suitability checks e.g. compaction_zonelist_suitable() are using
>> min watermark, so that should provide the difference already.
>> Actually it's low watermark because of __compaction_suitable() adding an
>> extra low-min gap for costly orders. But still.
>>
>> I did just notice compaction_ready() might be too strict. It wants
>> effectivly high wmark plus the gap plus the low-min difference. Is it
>> perhaps the underlying issue here?
> It's a good point. It does seem like that's worth looking into, and I'd be
> happy to explore that separately.My thought at the moment though is that
> changing compaction_ready() would be a different direction from the the 
> original
> focus of this patch, which started with the realization that the compaction
> scanner working set is bounded by COMPACT_CLUSTER_MAX. Since 

Ack.

> compact_gap() is
> used in multiple reclaim and compaction decisions, including 
> compaction_ready(),
> fixing its definition seemed like the right first change if the gap 
> itself is
> oversized.

Still I'd try to address the sc->nr_reclaimed usage first, and see if that's
enough.

>>>>> reclaim efficiency (steal/scan): 91.0%
>>>>> compaction success (success/stall): 28.3%
>>>> Is this compaction success per compaction stall or per alloc stall?
>>> That's per compaction.
>>>
>>>>> THP success (alloc/alloc+fallback): 17.2%
>>>> Weird that things would improve that much. I would expect the free memory
>>>> just to stabilize around the lower gap but then behave similarly. Are we
>>>> missing something here?
>>> This patch was tested in isolation, but also occurring was the case where
>>> bursty net allocations reserve many pageblocks as high atomic. So as
>>> THP-size pages become eligible, their blocks are reserved before being
>>> allocated as THP.
>>>
>>>>> forced lru_add_drain (mean/host): ~64K
>>>>>
>>>>> Signed-off-by: JP Kobryn (Meta)<jp.kobryn@linux.dev>
>>>>> ---
>>>>> include/linux/compaction.h | 8 ++++----
>>>>> 1 file changed, 4 insertions(+), 4 deletions(-)
>>>>>
>>>>> diff --git a/include/linux/compaction.h b/include/linux/compaction.h
>>>>> index 173d9c07a8952..09aea63b8a89d 100644
>>>>> --- a/include/linux/compaction.h
>>>>> +++ b/include/linux/compaction.h
>>>>> @@ -2,6 +2,8 @@
>>>>> #ifndef _LINUX_COMPACTION_H
>>>>> #define _LINUX_COMPACTION_H
>>>>> +#include <linux/swap.h>
>>>>> +
>>>>> /*
>>>>> * Determines how hard direct compaction should try to succeed.
>>>>> * Lower value means higher priority, analogically to reclaim priority.
>>>>> @@ -73,11 +75,9 @@ static inline unsigned long compact_gap(unsigned
>>>>> int order)
>>>>> * effectively limited by COMPACT_CLUSTER_MAX, as that's the maximum
>>>>> * that the migrate scanner can have isolated on migrate list, and free
>>>>> * scanner is only invoked when the number of isolated free pages is
>>>>> - * lower than that. But it's not worth to complicate the formula here
>>>>> - * as a bigger gap for higher orders than strictly necessary can also
>>>>> - * improve chances of compaction success.
>>>>> + * lower than that.
>>>>> */
>>>>> - return 2UL << order;
>>>>> + return min(2UL << order, COMPACT_CLUSTER_MAX);
>>>> Shouldn't it at least be 2x COMPACT_CLUSTER_MAX?
>>> I'm thinking I could reframe this patch as reclaim-focused and use
>>> min(2UL << order, COMPACT_CLUSTER_MAX) as a reclaim-only target, while
>>> either leaving the other non-reclaim users of this function alone or
>>> using the 2x form you suggest above. i.e. I can split this function
>>> into a separate reclaim_compact_gap() and use the originally proposed cap.
>>> Thoughts?
>> Do I understand correctly you want to cap the reclaim target by
>> COMPACT_CLUSTER_MAX but leave e.g. the compaction_suitable() usage as it is?
>> But wouldn't that mean we'll actually make changes of passing
>> compaction_suitable() worse?
> Good call. I was trying to find some middle ground, but I realize that the
> change is better left unified.

My question was based on not understanding the underlying issue, and that
the "reclaim-only target" isn't based on watermark+gap but "reclaim gap
worth of pages".  Now I think sc->nr_reclaimed is indeed the check that
should be relaxed first.

> Also, I tested a 2x COMPACT_CLUSTER_MAX cap and I saw mixed results - either
> similar to this patch or worse, with no improvements over the
> COMPACT_CLUSTER_MAX cap.

Right. Thanks!


