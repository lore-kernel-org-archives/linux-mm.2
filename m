Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C767CD6E55
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 01:49:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74DB36B04EE; Mon,  1 Jun 2026 21:49:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FDC36B04EF; Mon,  1 Jun 2026 21:49:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 614116B04F0; Mon,  1 Jun 2026 21:49:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4E97F6B04EE
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 21:49:14 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 600D21207E0
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 01:49:13 +0000 (UTC)
X-FDA: 84833289786.20.CBAA1F0
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id B463B14000A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 01:49:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Lzis5RgC;
	spf=pass (imf26.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780364951;
	b=lQmLXIocPkWxt3oxdseBEssB0TwOKAIT8meKxBKXeNtP4dLjy0Q64l1SJxudqp3sN9RN+k
	NCk+0m6BW8SZGcTLKCCRMQlsRgbpMcmnJPgJDj4eCtDRPFEQRiKz3Ec/scnJaZszAik37r
	u9/CqPG7tdIOyb/U06zZogLIU0UHj1Y=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Lzis5RgC;
	spf=pass (imf26.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780364951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OAMMqpYAwNLEAYKLUiBIBfq+i7pcpCAB6V/HwVkq/+4=;
	b=TxNGNiDHKJgx6myeJn56bug0GUyQqIyWRgdHGn+Et8YdGnscFbBEq/fqv4SGjfZt27ifxd
	uiALE8No+p1YyiydeZYhS0lVNsdsxDJ0fQcuVXvT53skEverkVtyOcB7YAhxibrAh0I+wW
	y44NX/VUrpVYYc+D5w0E1GuFeLL1qK0=
Message-ID: <b17dd2a3-8ca3-484e-8398-e5423f5df9c4@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780364947;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OAMMqpYAwNLEAYKLUiBIBfq+i7pcpCAB6V/HwVkq/+4=;
	b=Lzis5RgCMKTrknJEamurfwvNtQltWCVNh4oqq/kIcL6Zy3IscgWOXP7jnwvaaAK0vPOxo9
	tLZlp83EX8ocTUaT7yOB4UlapbcQoVDFsFYSfxI1n+3EiB8IedTL7fOqveiLfz/7dLgI4x
	EKTaeuOdGEQKbLAo603uSeDgTrCUdPc=
Date: Mon, 1 Jun 2026 18:48:50 -0700
MIME-Version: 1.0
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: JP Kobryn <jp.kobryn@linux.dev>
Subject: Re: [PATCH] mm/compaction: cap compact_gap() at COMPACT_CLUSTER_MAX
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, akpm@linux-foundation.org,
 surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260519200851.141955-1-jp.kobryn@linux.dev>
 <b4e49d71-bcd6-4c6c-87cb-2dbd75b3c2bb@kernel.org>
 <e318bbc0-3da5-4a49-bb1c-5777b7b4e4e7@linux.dev>
 <e65672e7-9a56-4489-84a1-db25d2c75f28@kernel.org>
Content-Language: en-US
In-Reply-To: <e65672e7-9a56-4489-84a1-db25d2c75f28@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B463B14000A
X-Rspam-User: 
X-Stat-Signature: uskbx4uj5j7admnsifpf8rgz8ox4qa86
X-HE-Tag: 1780364949-474046
X-HE-Meta: U2FsdGVkX18gqzrZeacpY5CCxr8eYK0oqulLFAkoj9g+MUVYH6Z+A23Yd8GZ3A2orODgl3lExbh9dLuyVxEVw7y+Kcr7HPz6bpxOu6CLoKhGsNbt4ZlQE9RSbmsYVGTAg4PZDb0SRmzqSx83UnL8K9dFAF5cd22JbU7NN6dhcu5kxQhrtVao+coi1Y7ApUVNc72vtsNPMPhM/w4whD76MXJmwppNYgN8vI7b5DLt3x86wLmqYE4f+Vz2jjgAaFc0oFFKC4VKB6ZlauS/OuOz/eoanQuhBoJhRNLsI6seRRdKGA2eKjwCJsNeHYPBGzt8QEn1D6yZ0nIyTzJbvwcUQVvfEYOL8Xh2krAvsaYeBMjLL3czu1wlxsfkYEECa65C4Fc5YaGYaH2IaA9j7nJ1Y3IilziVlU7ha+OaKKF2Jb26mIqA713wIRwO4poV+vGOXaEfNKi2Ong0lXyqwV7XTlZ72CtOUiTC3OZRn5VMz8t6/pPqtjHU0gyBgWz9RjZk1EtK2bDY40LfTo48NXR8D1OKW5RMl45pD2ceYpA46bs/NRLYPBSQKDFDeMHavNar/wLTXc1hbev1rEGtlUN0zLkPG0/B8ivdj03QEIQnyTHBTOfbAD54CftuqIUf24I4ZEiRGtkNJ+ZZxnrD69+R8TqVwtEE9Db0CWwexIiCvxq7995zzdr2sMRBZWprFv1roCK38/2WK8d+nkW4Ugnwq9wGxcunHAJenww6AK1D0MiDKBSI+NGN5XKA5sdpD3HV9uIpGhCaI3YdI0Dy+P+anXKpm2K6ebO28Z3HcsnAkWHBZ3SPewO9BBjYlnjGibZ14cZy7kjoL8y2vb+UuhAv0dro4AlUQ9wnBUskB5SEisAb/j3291DYhuMiSyP8VOqHp5+3bHgFMUqAyAYRi9HQiBAsiTndj8egnq3hpueLILTaFR7iplMnH9B6543PB2fgzyr36+3T0loR7Nc5QVV
 CJl1H5Q6
 WkdpdYgnhqiAdJGuHM40JKDjbXxH0VSnzmspbGMfJWqp7v0wfMV3APTNFLRpu9PufpzzUMAk4v1ViX4JQLkNT25AW54fsaUSbZJ0rWkngdKQs58m85wT3kGJVIpkD3WtE63nm+q2P/bvMoOKFFqHIAK3wX/XPQbkYnsVrVTKM3waISZ/kahQpwVmwfWceymINQJHop9fdklRFSU8cnt92+y1fimfxB2oeB1zujunKVeA/Gac269Lgo72ZE2kwl1kENqKXHXzOfcuY1wD1eJ4YFKRrQ3WnX9N669VaXL2bV6075hTrLeNLWocPSb7PztMY3omU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/28/26 1:51 AM, Vlastimil Babka (SUSE) wrote:
> On 5/27/26 02:10, JP Kobryn wrote:
>> On 5/25/26 3:02 AM, Vlastimil Babka (SUSE) wrote:
>>> On 5/19/26 22:08, JP Kobryn (Meta) wrote:
>>>> compact_gap() returns 2 << order, which is used as watermark headroom in
>>>> __compaction_suitable() and as a reclaim target in kswapd. The computed
>>>> value scales exponentially by order. For order-9 THP allocations this
>>>> evaluates to 1024 pages, but the compaction free scanner's working set is
>>>> bounded by COMPACT_CLUSTER_MAX (32 pages). The scanner stops
>>>> isolating free
>>>> pages once it matches the migration batch. The current gap
>>>> over-reserves by
>>>> 32x.
>>>>
>>>> On fragmented production hosts, kswapd will try and reclaim up to the
>>>> gap,
>>>> but it only reaches that threshold 18% of the time, causing reclaim to
>>>> continue a majority of the time.
>>> But doesn't that mean there's genuine memory pressure? We're effectively
>>> raising the high watermark by 4 MB, but if processes are continuously
>>> allocating, we'd be reclaiming without the gap as well? Unless the
>>> workload
>>> is sized to fit without the gap.
>> It wasn't actual pressure, but the repetitive order-9 THP failures that were
>> waking up kswapd. I should make this more clear in the changelog. After
>> looking into why so much reclaim was occurring though, the compact gap stood
>> out since it dictates the target amount to reclaim.
> But the "amount to reclaim" is still defined as "reach high watermark +
> compact_gap()" and not "reclaim at least compact_gap() pages" right? Or did
> I miss something non-obvious.
Within kswapd_shrink_node(), sc->nr_to_reclaim is the sum of max(zone high
watermark or SWAP_CLUSTER_MAX) for each zone combined. The gap is not 
added to
that reclaim target though. It's used afterward as the threshold for 
abandoning
high order reclaim:

if (sc->order && sc->nr_reclaimed >= compact_gap(sc->order))
     sc->order = 0;

balance_pgdat() then returns sc->order and that becomes the kswapd 
reclaim_order
value, allowing this branch to be taken:

if (reclaim_order < alloc_order)
     goto kswapd_try_sleep;

Then in prepare_kswapd_sleep(), if pgdat_balanced() succeeds (at order-0),
kcompactd is woken up for the original alloc_order (order-9).

> So if kswapd did any work, it means the memory was consumed (i.e. there was
> some memory pressure) and amount of free memory was below high watermark +
> compact_gap()?
Hmm but kswapd can be woken up on a high order failure despite plenty of 
lower
order availability. That's really the case where compact_gap() matters for
higher orders. Unless by pressure you mean the high order pages were gone?

> BTW, are you using mglru here? (probably not)
> As that might be different and I'm not so familiar with it.
Using classic LRU.

>>>> The over-sized gap also causes 46% of
>>>> order-9 compaction suitability checks to fail unnecessarily - the
>>>> zone has
>>>> sufficient free pages for the scanner to operate, but not enough to clear
>>>> the inflated threshold.
>>>>
>>>> Cap compact_gap() at COMPACT_CLUSTER_MAX to align the watermark headroom
>>>> with the scanner's actual capacity. Orders 0-4 are unaffected since their
>>>> gap is <= 32.
>>>>
>>>> A/B test on ~100 instagram production hosts (64GB, 60s measurement):
>>> What was the base kernel version?
>> 6.13. Additional benchmarks were done using a recent mm-new build as well,
>> and they showed similar reductions in reclaim.
> If it's a NUMA machine, we recently found an over-reclaim issue there fixed
> by 9c9828d3ead6 ("mm, page_alloc, thp: prevent reclaim for __GFP_THISNODE
> THP allocations")
Thanks for pointing this out. I tested this on a recent mm-new built that
includes 9c9828d3ead6, and I found the compact_gap() change was still 
helpful.
My understanding is that 9c9828d3ead6 addresses direct reclaim for THP
allocations, while this patch affects the kswapd reclaim-compaction hand-off
path. The test runs still showed a benefit from capping the gap.

>>>> Unpatched (43 hosts)
>>>> pgscan_kswapd (mean/host): ~1.6M
>>>> reclaim efficiency (steal/scan): 83.8%
>>>> compaction success (success/stall): 2.1%
>>>> THP success (alloc/alloc+fallback): 4.9%
>>>> forced lru_add_drain (mean/host): ~107K
>>>>
>>>> Patched (59 hosts)
>>>> pgscan_kswapd (mean/host): ~449K
>>> Did the extra reclaim just disappear because we allow the allocations
>>> to use
>>> 4MB more memory? Or it shifted to direct reclaim?
>> Specifically in the order-9 case, the reclaim target goes from 1024 to 32.
>> What the data shows is that capping the gap allows compaction to take over
>> sooner and start working to produce large size pages needed for THP. Whereas
>> in the pre-patch state, trying to reclaim the full 2x THP delays compaction.
> So do I understand correctly we might have an issue due to lack of
> hysteresis? We require reaching high watermark + compact_gap() to terminate
> reclaim, but then compaction can find out we meanwhile dropped below that
> (due to concurrent allocations) and it's not suitable again?
On an unpatched kernel in a fragmented environment, 
compaction_suitable() can
remain false because the effective threshold for costly orders is the low
watermark + the compact gap. Kswapd has to keep reclaiming in high order 
mode
as a result. By capping the gap at SWAP_CLUSTER_MAX, compaction becomes 
suitable
sooner and kswapd reaches the high order reclaim cutoff sooner. So with 
the patch,
kswapd is able to fall back to order-0 balancing earlier and wake up 
kcompactd
for the original high order request.

> However the suitability checks e.g. compaction_zonelist_suitable() are using
> min watermark, so that should provide the difference already.
> Actually it's low watermark because of __compaction_suitable() adding an
> extra low-min gap for costly orders. But still.
>
> I did just notice compaction_ready() might be too strict. It wants
> effectivly high wmark plus the gap plus the low-min difference. Is it
> perhaps the underlying issue here?
It's a good point. It does seem like that's worth looking into, and I'd be
happy to explore that separately. My thought at the moment though is that
changing compaction_ready() would be a different direction from the the 
original
focus of this patch, which started with the realization that the compaction
scanner working set is bounded by COMPACT_CLUSTER_MAX. Since 
compact_gap() is
used in multiple reclaim and compaction decisions, including 
compaction_ready(),
fixing its definition seemed like the right first change if the gap 
itself is
oversized.

>>>> reclaim efficiency (steal/scan): 91.0%
>>>> compaction success (success/stall): 28.3%
>>> Is this compaction success per compaction stall or per alloc stall?
>> That's per compaction.
>>
>>>> THP success (alloc/alloc+fallback): 17.2%
>>> Weird that things would improve that much. I would expect the free memory
>>> just to stabilize around the lower gap but then behave similarly. Are we
>>> missing something here?
>> This patch was tested in isolation, but also occurring was the case where
>> bursty net allocations reserve many pageblocks as high atomic. So as
>> THP-size pages become eligible, their blocks are reserved before being
>> allocated as THP.
>>
>>>> forced lru_add_drain (mean/host): ~64K
>>>>
>>>> Signed-off-by: JP Kobryn (Meta)<jp.kobryn@linux.dev>
>>>> ---
>>>> include/linux/compaction.h | 8 ++++----
>>>> 1 file changed, 4 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/include/linux/compaction.h b/include/linux/compaction.h
>>>> index 173d9c07a8952..09aea63b8a89d 100644
>>>> --- a/include/linux/compaction.h
>>>> +++ b/include/linux/compaction.h
>>>> @@ -2,6 +2,8 @@
>>>> #ifndef _LINUX_COMPACTION_H
>>>> #define _LINUX_COMPACTION_H
>>>> +#include <linux/swap.h>
>>>> +
>>>> /*
>>>> * Determines how hard direct compaction should try to succeed.
>>>> * Lower value means higher priority, analogically to reclaim priority.
>>>> @@ -73,11 +75,9 @@ static inline unsigned long compact_gap(unsigned
>>>> int order)
>>>> * effectively limited by COMPACT_CLUSTER_MAX, as that's the maximum
>>>> * that the migrate scanner can have isolated on migrate list, and free
>>>> * scanner is only invoked when the number of isolated free pages is
>>>> - * lower than that. But it's not worth to complicate the formula here
>>>> - * as a bigger gap for higher orders than strictly necessary can also
>>>> - * improve chances of compaction success.
>>>> + * lower than that.
>>>> */
>>>> - return 2UL << order;
>>>> + return min(2UL << order, COMPACT_CLUSTER_MAX);
>>> Shouldn't it at least be 2x COMPACT_CLUSTER_MAX?
>> I'm thinking I could reframe this patch as reclaim-focused and use
>> min(2UL << order, COMPACT_CLUSTER_MAX) as a reclaim-only target, while
>> either leaving the other non-reclaim users of this function alone or
>> using the 2x form you suggest above. i.e. I can split this function
>> into a separate reclaim_compact_gap() and use the originally proposed cap.
>> Thoughts?
> Do I understand correctly you want to cap the reclaim target by
> COMPACT_CLUSTER_MAX but leave e.g. the compaction_suitable() usage as it is?
> But wouldn't that mean we'll actually make changes of passing
> compaction_suitable() worse?
Good call. I was trying to find some middle ground, but I realize that the
change is better left unified.

Also, I tested a 2x COMPACT_CLUSTER_MAX cap and I saw mixed results - either
similar to this patch or worse, with no improvements over the
COMPACT_CLUSTER_MAX cap.

