Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6B5CCD5BD2
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 00:10:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6B6A6B0005; Tue, 26 May 2026 20:10:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1C6C6B008A; Tue, 26 May 2026 20:10:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 938E36B008C; Tue, 26 May 2026 20:10:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7E14C6B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 20:10:50 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 339FE1C0368
	for <linux-mm@kvack.org>; Wed, 27 May 2026 00:10:50 +0000 (UTC)
X-FDA: 84811269060.18.F56AEB6
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf02.hostedemail.com (Postfix) with ESMTP id BFABA80008
	for <linux-mm@kvack.org>; Wed, 27 May 2026 00:10:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vQNx8Uyk;
	spf=pass (imf02.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779840648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jXa1QKzuwglS2S9C9tG6wdCTZm+qoqm09mLxH1alJME=;
	b=Os+we0giew1G9Xm5XbiZHxa4DUc2vJ84LXoUxgCLkYhX++w8Yr5xb+auGccSntyvIripY9
	o5bpbY6Mi49Xt0/vRtY7vhDBEpfbERqD5rWkfbIJAxy45g9FUqxc8269x0kKvjiCW4alKC
	KP9mYcISlUFGlJ64WQ+oO1BWA0gHvwg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vQNx8Uyk;
	spf=pass (imf02.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779840648; a=rsa-sha256;
	cv=none;
	b=X8SVk/C62gEsJiLLKW5dmdo1AYWz90KXb/Q0+9sUQPpuKsExf8/APaDC34SI/SFwHlhSFr
	ys1h3S/RgUpMGr5KjAG23JenYGswv2pyeA9Od6h8w/NjN8oh4uSO0mnrzZOW+nOX6c9e9W
	NPqxVCcrGCDp42cmhR7XtQWSpty/d4I=
Message-ID: <e318bbc0-3da5-4a49-bb1c-5777b7b4e4e7@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779840643;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jXa1QKzuwglS2S9C9tG6wdCTZm+qoqm09mLxH1alJME=;
	b=vQNx8Uyk2e3dJiqQ+GWcAKYffrPyW8Qqy1kkxqGx/5pERinvxAN42yJ1xaZ+V9w7h96U4x
	T1TpXhp4TYWNnDY3vKs0FAKIvGC4Cr+meHFdTsQcCpr3Cd0uWqG8m9/FSgs6NsyhkAqG3Z
	N/we+jC6miGRctpsQhpOF0ZV43RTvDk=
Date: Tue, 26 May 2026 17:10:31 -0700
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
Content-Language: en-US
In-Reply-To: <b4e49d71-bcd6-4c6c-87cb-2dbd75b3c2bb@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: zbpss3765c3ts1hugq8agpw5rm637kc8
X-Rspam-User: 
X-Rspamd-Queue-Id: BFABA80008
X-HE-Tag: 1779840646-263281
X-HE-Meta: U2FsdGVkX1+KZ53GxsjldjO6qTeoKB0SMhNc5TsYbPGFjxHfWpDwt7ZbedqLOXT7IrYjY65h9VOCuz3iNYr/ctcNYiGBj9kGPxKEEwOCL4bXPlQqcf569nirm0JQ+7VVHMLVCl8UNbC4AgHk+f44H2KijMHUIRk4YOktXxagkwQRBdpay5RK1stbRiuM54sdUQpRO/pw1idw3mSwh63kMl7OuWsoVGlClQ+vCBc0Ardxkn2nFAnqBRynVCy8GasF9ITcSe++lN6kk7PC/o+15e/j5zfUb6nzD6+VcBY8SQKwu7w4HZkAWDH/AKnNS3z1AhosTl+DowkWwKjj9w9eB1mp5q9ZWGA5gkD1fKDytH8uI/e4SL/Rnw08zz7rQ07sxoOAgh/xT+BWV1kpi4kl0thTFOduHB3ON5B3yqJEL0t0QEfDX7f3U0bEHCdk91jiBa04p5Khl/5mBpSp2VlTv4zwRPJLZpCnHw6Sc3XoLGp1R9HqY7gseGLr8P2M1VM9+adpEBA+X1DjlFD4lugiHdmuobYP8aKj+MDLL0+zMBluA3ew+1CNvAZ928uZgu586kyvyhPBEWzNuclS1Z+QTKQHzPtlSFOinX64bPF4TzxPuoQLxEsS+jGahcIMRMZJCF07gbOviBu9kXQkGiuBbAAbP6I93CkuEExqt7n8wOw8qeIaXHN49qC0JBwwWv6e93l704W9DKLyXUoGjcqyY0vnFS90DMYRK7JgdPR5DWnoO5o0UARZV6c6rLo5f0J5aq+hTNy4ltYd1s5qHHsT+ecic23qrxx7G6l5XCvvefuch0XT+OUyZjubrWgeQYBXMJypeErp7RG6YDRMksi22oa/ob/qFP6Y777Kre7C/9UAfDOi4z0xRa9xolygYILoSlxrriYutVDm8LIrPH7vGv0NlV+U7PUcES0nF743NMdQT4AMcKpIdNMHmyq2WBBTQ2TbTjFuKC9v0IN15jo
 G6iQUIu9
 EOoqdS4V4yPi9rtmb6cp42qIKinhsnVkAL7xaXNzVKaQcl/Y+MUZWI+IsKRF1qatjq/5PeAGsSD97+3LCsq1Xp8+/S6tqgIwZJ8VDwzK4Cr/FeuX51evrM0PMDvaUcrzI+0FO+HBQW5J/lpddKyv7jVzlNSXidm8S2Yc6JDSrZJLfpauTciZKs9RdZulfTFUNKHfV0pjD5Y74XSQXSABcOyB6M9UHLslVBFmhgjbTAaPWLRW9jHnzbrsHFnl2CEuZdyW84IRPRONSTt53TW1fJEDrmnaAqS7wn7Mc85OWmIy6lPM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/25/26 3:02 AM, Vlastimil Babka (SUSE) wrote:
> On 5/19/26 22:08, JP Kobryn (Meta) wrote:
>> compact_gap() returns 2 << order, which is used as watermark headroom in
>> __compaction_suitable() and as a reclaim target in kswapd. The computed
>> value scales exponentially by order. For order-9 THP allocations this
>> evaluates to 1024 pages, but the compaction free scanner's working set is
>> bounded by COMPACT_CLUSTER_MAX (32 pages). The scanner stops 
>> isolating free
>> pages once it matches the migration batch. The current gap 
>> over-reserves by
>> 32x.
>>
>> On fragmented production hosts, kswapd will try and reclaim up to the 
>> gap,
>> but it only reaches that threshold 18% of the time, causing reclaim to
>> continue a majority of the time.
> But doesn't that mean there's genuine memory pressure? We're effectively
> raising the high watermark by 4 MB, but if processes are continuously
> allocating, we'd be reclaiming without the gap as well? Unless the 
> workload
> is sized to fit without the gap.

It wasn't actual pressure, but the repetitive order-9 THP failures that were
waking up kswapd. I should make this more clear in the changelog. After
looking into why so much reclaim was occurring though, the compact gap stood
out since it dictates the target amount to reclaim.

>> The over-sized gap also causes 46% of
>> order-9 compaction suitability checks to fail unnecessarily - the 
>> zone has
>> sufficient free pages for the scanner to operate, but not enough to clear
>> the inflated threshold.
>>
>> Cap compact_gap() at COMPACT_CLUSTER_MAX to align the watermark headroom
>> with the scanner's actual capacity. Orders 0-4 are unaffected since their
>> gap is <= 32.
>>
>> A/B test on ~100 instagram production hosts (64GB, 60s measurement):
> What was the base kernel version?

6.13. Additional benchmarks were done using a recent mm-new build as well,
and they showed similar reductions in reclaim.

>> Unpatched (43 hosts)
>> pgscan_kswapd (mean/host): ~1.6M
>> reclaim efficiency (steal/scan): 83.8%
>> compaction success (success/stall): 2.1%
>> THP success (alloc/alloc+fallback): 4.9%
>> forced lru_add_drain (mean/host): ~107K
>>
>> Patched (59 hosts)
>> pgscan_kswapd (mean/host): ~449K
> Did the extra reclaim just disappear because we allow the allocations 
> to use
> 4MB more memory? Or it shifted to direct reclaim?

Specifically in the order-9 case, the reclaim target goes from 1024 to 32.
What the data shows is that capping the gap allows compaction to take over
sooner and start working to produce large size pages needed for THP. Whereas
in the pre-patch state, trying to reclaim the full 2x THP delays compaction.

>> reclaim efficiency (steal/scan): 91.0%
>> compaction success (success/stall): 28.3%
> Is this compaction success per compaction stall or per alloc stall?

That's per compaction.

>> THP success (alloc/alloc+fallback): 17.2%
> Weird that things would improve that much. I would expect the free memory
> just to stabilize around the lower gap but then behave similarly. Are we
> missing something here?

This patch was tested in isolation, but also occurring was the case where
bursty net allocations reserve many pageblocks as high atomic. So as
THP-size pages become eligible, their blocks are reserved before being
allocated as THP.

>> forced lru_add_drain (mean/host): ~64K
>>
>> Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>
>> ---
>> include/linux/compaction.h | 8 ++++----
>> 1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/linux/compaction.h b/include/linux/compaction.h
>> index 173d9c07a8952..09aea63b8a89d 100644
>> --- a/include/linux/compaction.h
>> +++ b/include/linux/compaction.h
>> @@ -2,6 +2,8 @@
>> #ifndef _LINUX_COMPACTION_H
>> #define _LINUX_COMPACTION_H
>> +#include <linux/swap.h>
>> +
>> /*
>> * Determines how hard direct compaction should try to succeed.
>> * Lower value means higher priority, analogically to reclaim priority.
>> @@ -73,11 +75,9 @@ static inline unsigned long compact_gap(unsigned 
>> int order)
>> * effectively limited by COMPACT_CLUSTER_MAX, as that's the maximum
>> * that the migrate scanner can have isolated on migrate list, and free
>> * scanner is only invoked when the number of isolated free pages is
>> - * lower than that. But it's not worth to complicate the formula here
>> - * as a bigger gap for higher orders than strictly necessary can also
>> - * improve chances of compaction success.
>> + * lower than that.
>> */
>> - return 2UL << order;
>> + return min(2UL << order, COMPACT_CLUSTER_MAX);
> Shouldn't it at least be 2x COMPACT_CLUSTER_MAX?

I'm thinking I could reframe this patch as reclaim-focused and use
min(2UL << order, COMPACT_CLUSTER_MAX) as a reclaim-only target, while
either leaving the other non-reclaim users of this function alone or
using the 2x form you suggest above. i.e. I can split this function
into a separate reclaim_compact_gap() and use the originally proposed cap.
Thoughts?

