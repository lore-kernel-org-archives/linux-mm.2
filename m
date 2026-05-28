Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35E14CD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 08:51:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D70C6B008A; Thu, 28 May 2026 04:51:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 260C86B008C; Thu, 28 May 2026 04:51:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 128576B0092; Thu, 28 May 2026 04:51:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 02F286B008A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 04:51:48 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A7DBA14073D
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:51:47 +0000 (UTC)
X-FDA: 84816210654.13.C32BF55
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id DD01914000E
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:51:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZiPnnVKy;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779958305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w4iFMi+qmGmwQsUkDx51DQK4FizO3KDSbwRH63jLBu8=;
	b=SQ7wb9qPaNDQHGQ+Ozqo3Cun0O0asKiPj6KjqQ2uVoKbolsqaCP8D1Lv30QLfiPVbNdS7h
	MUyoA445p6whSttZwJSUTujMawKCsW5TXhbv2PvSedN5KaqQzIlWVvK5WmUVhqTrDb2SjY
	C2icRc5AxJIPqqF8K9odiFSiZiLAsMc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZiPnnVKy;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779958305; a=rsa-sha256;
	cv=none;
	b=mWJkP2bGfDlCa4cKMQ5/uaHBeqopzpUukGeBJI7Z+xrql4P48pV9YH4w+Unwm5jsDBkOV9
	xR5YBwiRAeR++25sakJTYU2hAYCf+5vVKZtqjbkq5U5GhW/c1xe70LpenS0OtSFAbqme3w
	5IqzUdBvwuYV/BgoZVJNIgvGCZRfxDs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4CD546060C;
	Thu, 28 May 2026 08:51:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 185F71F000E9;
	Thu, 28 May 2026 08:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779958305;
	bh=w4iFMi+qmGmwQsUkDx51DQK4FizO3KDSbwRH63jLBu8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZiPnnVKyj6Y8cvnUHWilwQtnoINnb4hiL+Q/H5tZ3ef+JVUg9vcBzxJdWw1LZ0vOE
	 rbH+hkx9JnxmUWTVaTGiNB9UdLyVrbe2gdDJGJNQHj/DS0k5YbA2oQq7cmElz2829j
	 NafZ5ZBTiWBNp/nDwsOs5yo3WZMLA/DHmVl4Fc6XQxD14SWWSXEV7X2oEhpsJb3UxL
	 GiMUvcmsUln4YdZNRt/Azi78QOW20VCrRvNRGmeqkBxZthD5WTEYxAjsq7ycPfrgPj
	 06SSYFIFzjgONLqd7YHHgXnORWAou/bkG1O8/xhGtO69aHXMv+S+iCT1xg87R8MTwD
	 UM0K4aU8Bu7mA==
Message-ID: <e65672e7-9a56-4489-84a1-db25d2c75f28@kernel.org>
Date: Thu, 28 May 2026 10:51:41 +0200
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
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <e318bbc0-3da5-4a49-bb1c-5777b7b4e4e7@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DD01914000E
X-Stat-Signature: f78znb1wrdtky1scfxxfu3i6kmk5ku75
X-HE-Tag: 1779958305-758160
X-HE-Meta: U2FsdGVkX195xlaiUna+IkooSZ2kk9oioAVCnoKsBwj5S1nbMZc37HfPYxeabcuTNvo8ku4AgrRmmgLuiX72GEJ8j50n+HOMtygzLzqZEPe7MgkLcV5huTCQYYEP/+5IGi+eGriihCT2+KLJvajwkKPmwEzyJyKR50iSLBC/kBic3x++UP03qyWkPZg4VxAYQ0gjaUgHGDzWkzTqz2bB9e+t9xSeJw+r8c4aX2fXckOWdsOmGmoL+9zFZ4r/KGRlmnp1zAnL+d8FP5M3gFNmjNtWvR1ef4SUcDEmvze1ER02vmM7ecrK6JH3uZJXNZk0q+l1mHBlMMNOq0YypbdWw/iJ8PWCvd2ekZBPMtojzs3hs69BH/G9ipfuJqiLyuqHLr6mSzKzmCpBMcq77EPIObf337T3LcmK8FqxOFVX9QttcuGcYUryZU+ZKiWmI37mBDLm1Q8JHE5Un4KwXSd9mHvN9VBUOqM4a7r2lJ2Xtt1/USDXED42WNZ9WDdw7MZQtomqFdoSBxiv9NJa5L4OVqrSGQ+vSbYCuRg/gYyigDf5bJsrjqoeK7slb/jC1msBTyJxcvvUMLJbDRJMW0h8iFPyWkiduG+LOkUbE2gMBVNVgI7dDiEGO3toD5oL7U0CVJXSMrWIj/1Mt5t5WdI9QFwtx1TzF8A6/gXJmCp3YtVDyTpHG5cwIgkfh6tBF3po9TrfdHZagV4oWuQui+I6pX9LUAxQai7KIrBGxGCu3LJ/7WXYkKQsYQ+BnWkiZnsLEa0jul2pdiOa3V7/ZwMawElMjkIUkA6PQ9FEXxV46T31tSRUxMWepTrN6Ef6/AqOS7QxWoiK2Y3mhynPR8+dgK2mlyF6K9OttexOOfZIIc3zLQscSuNaAJZmmcNCIkt2CiaSJAhyRZr1wd2DuDrqHLW70btv/dbjf5uqje1OL+WRGsFx1OPjkOWr+e3DuSPp2cAPfLGijOWvJFU+FBD
 eM0aLWEm
 M8T0/N2yu1fk8VZyD0xJmibadH0rIJRWlsjfABrT7/5IiJpu20UpS1n+dMfamcYfeY8DCnyeVPJ3WjS5Ns5qFDuy7FJCNnGaz5WtsCXtVCE+YcDdIO+PTGNiZmPWTLOA8XJeinyIxk0V45kKiTp1yT/fKF1rX7z4cDZp4Wiyc/g1jFDpqv+MU93Pw96MjfHpZv/4eE7xxU2IKvnFkl2jumqxqDN3zlWmH9THQuYJYrdNj71lReHO6Ge+XlUd7exIFpq2jckrSCy7UmzM0NFlX0KZkVlXRYLTysblF1UYFN//USfmRqYzx6hpk0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/27/26 02:10, JP Kobryn wrote:
> On 5/25/26 3:02 AM, Vlastimil Babka (SUSE) wrote:
>> On 5/19/26 22:08, JP Kobryn (Meta) wrote:
>>> compact_gap() returns 2 << order, which is used as watermark headroom in
>>> __compaction_suitable() and as a reclaim target in kswapd. The computed
>>> value scales exponentially by order. For order-9 THP allocations this
>>> evaluates to 1024 pages, but the compaction free scanner's working set is
>>> bounded by COMPACT_CLUSTER_MAX (32 pages). The scanner stops 
>>> isolating free
>>> pages once it matches the migration batch. The current gap 
>>> over-reserves by
>>> 32x.
>>>
>>> On fragmented production hosts, kswapd will try and reclaim up to the 
>>> gap,
>>> but it only reaches that threshold 18% of the time, causing reclaim to
>>> continue a majority of the time.
>> But doesn't that mean there's genuine memory pressure? We're effectively
>> raising the high watermark by 4 MB, but if processes are continuously
>> allocating, we'd be reclaiming without the gap as well? Unless the 
>> workload
>> is sized to fit without the gap.
> 
> It wasn't actual pressure, but the repetitive order-9 THP failures that were
> waking up kswapd. I should make this more clear in the changelog. After
> looking into why so much reclaim was occurring though, the compact gap stood
> out since it dictates the target amount to reclaim.

But the "amount to reclaim" is still defined as "reach high watermark +
compact_gap()" and not "reclaim at least compact_gap() pages" right? Or did
I miss something non-obvious.

So if kswapd did any work, it means the memory was consumed (i.e. there was
some memory pressure) and amount of free memory was below high watermark +
compact_gap()?

BTW, are you using mglru here? (probably not)
As that might be different and I'm not so familiar with it.

>>> The over-sized gap also causes 46% of
>>> order-9 compaction suitability checks to fail unnecessarily - the 
>>> zone has
>>> sufficient free pages for the scanner to operate, but not enough to clear
>>> the inflated threshold.
>>>
>>> Cap compact_gap() at COMPACT_CLUSTER_MAX to align the watermark headroom
>>> with the scanner's actual capacity. Orders 0-4 are unaffected since their
>>> gap is <= 32.
>>>
>>> A/B test on ~100 instagram production hosts (64GB, 60s measurement):
>> What was the base kernel version?
> 
> 6.13. Additional benchmarks were done using a recent mm-new build as well,
> and they showed similar reductions in reclaim.

If it's a NUMA machine, we recently found an over-reclaim issue there fixed
by 9c9828d3ead6 ("mm, page_alloc, thp: prevent reclaim for __GFP_THISNODE
THP allocations")

>>> Unpatched (43 hosts)
>>> pgscan_kswapd (mean/host): ~1.6M
>>> reclaim efficiency (steal/scan): 83.8%
>>> compaction success (success/stall): 2.1%
>>> THP success (alloc/alloc+fallback): 4.9%
>>> forced lru_add_drain (mean/host): ~107K
>>>
>>> Patched (59 hosts)
>>> pgscan_kswapd (mean/host): ~449K
>> Did the extra reclaim just disappear because we allow the allocations 
>> to use
>> 4MB more memory? Or it shifted to direct reclaim?
> 
> Specifically in the order-9 case, the reclaim target goes from 1024 to 32.
> What the data shows is that capping the gap allows compaction to take over
> sooner and start working to produce large size pages needed for THP. Whereas
> in the pre-patch state, trying to reclaim the full 2x THP delays compaction.

So do I understand correctly we might have an issue due to lack of
hysteresis? We require reaching high watermark + compact_gap() to terminate
reclaim, but then compaction can find out we meanwhile dropped below that
(due to concurrent allocations) and it's not suitable again?

However the suitability checks e.g. compaction_zonelist_suitable() are using
min watermark, so that should provide the difference already.
Actually it's low watermark because of __compaction_suitable() adding an
extra low-min gap for costly orders. But still.

I did just notice compaction_ready() might be too strict. It wants
effectivly high wmark plus the gap plus the low-min difference. Is it
perhaps the underlying issue here?

>>> reclaim efficiency (steal/scan): 91.0%
>>> compaction success (success/stall): 28.3%
>> Is this compaction success per compaction stall or per alloc stall?
> 
> That's per compaction.
> 
>>> THP success (alloc/alloc+fallback): 17.2%
>> Weird that things would improve that much. I would expect the free memory
>> just to stabilize around the lower gap but then behave similarly. Are we
>> missing something here?
> 
> This patch was tested in isolation, but also occurring was the case where
> bursty net allocations reserve many pageblocks as high atomic. So as
> THP-size pages become eligible, their blocks are reserved before being
> allocated as THP.
> 
>>> forced lru_add_drain (mean/host): ~64K
>>>
>>> Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>
>>> ---
>>> include/linux/compaction.h | 8 ++++----
>>> 1 file changed, 4 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/include/linux/compaction.h b/include/linux/compaction.h
>>> index 173d9c07a8952..09aea63b8a89d 100644
>>> --- a/include/linux/compaction.h
>>> +++ b/include/linux/compaction.h
>>> @@ -2,6 +2,8 @@
>>> #ifndef _LINUX_COMPACTION_H
>>> #define _LINUX_COMPACTION_H
>>> +#include <linux/swap.h>
>>> +
>>> /*
>>> * Determines how hard direct compaction should try to succeed.
>>> * Lower value means higher priority, analogically to reclaim priority.
>>> @@ -73,11 +75,9 @@ static inline unsigned long compact_gap(unsigned 
>>> int order)
>>> * effectively limited by COMPACT_CLUSTER_MAX, as that's the maximum
>>> * that the migrate scanner can have isolated on migrate list, and free
>>> * scanner is only invoked when the number of isolated free pages is
>>> - * lower than that. But it's not worth to complicate the formula here
>>> - * as a bigger gap for higher orders than strictly necessary can also
>>> - * improve chances of compaction success.
>>> + * lower than that.
>>> */
>>> - return 2UL << order;
>>> + return min(2UL << order, COMPACT_CLUSTER_MAX);
>> Shouldn't it at least be 2x COMPACT_CLUSTER_MAX?
> 
> I'm thinking I could reframe this patch as reclaim-focused and use
> min(2UL << order, COMPACT_CLUSTER_MAX) as a reclaim-only target, while
> either leaving the other non-reclaim users of this function alone or
> using the 2x form you suggest above. i.e. I can split this function
> into a separate reclaim_compact_gap() and use the originally proposed cap.
> Thoughts?

Do I understand correctly you want to cap the reclaim target by
COMPACT_CLUSTER_MAX but leave e.g. the compaction_suitable() usage as it is?
But wouldn't that mean we'll actually make changes of passing
compaction_suitable() worse?

