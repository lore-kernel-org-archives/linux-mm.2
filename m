Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0468C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 06:21:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A565B6B0088; Thu, 27 Aug 2026 02:21:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A07DA6B008A; Thu, 27 Aug 2026 02:21:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91D176B0095; Thu, 27 Aug 2026 02:21:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 688866B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 02:21:47 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D0A88A02BA
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 06:21:46 +0000 (UTC)
X-FDA: 85146053412.08.DCEDD2D
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3BDFE100002
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 06:21:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=aX9mLAla;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787811705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ImPFWFRY5szdCXqhm0kmdf+B5mDUicA3YITvPHDWZdY=;
	b=2YvnNJcqfEKPEQs1kez9EroI+cpuyEbnrcXZYZxyY54itGnEnNsD8Z3f4hyPnGDOXGmAAS
	MztWjx6wQ59ur7bls4HQpBBeHL7teOOXtYZrTZBT4mChdHI03Z1XskalYRyzgOyMcHF4/q
	mC51on3DIVHZKvnQ+OuBdMOqiE0eaWo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787811705;
	b=qNNjUHHmS7Aahp0gZwiacscltZ4IfLj8jghcrDUWDx7PHjteJDN53oxjwTg4ZrlYfBAv25
	MoW9pE4PUKgDC8vcptPmn3gtGl5b6+cWga3xhWwIgRedBNFkU3jEihpWOdmA4CaN8ieoG/
	dRmHjGDKeRpk+W4hMApVx8M9VqkdKTg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=aX9mLAla;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787811696; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ImPFWFRY5szdCXqhm0kmdf+B5mDUicA3YITvPHDWZdY=;
	b=aX9mLAlaqOS9HE9bYTxNJW/LkBZTiqZOegd1rF/fBQqCRSimhoJH23xBRu7reVb4m9AohU1/Q59w3SAWZBzlgnsMz7DGwmqlUPbFmutMvyeNbHWLfpsIPSyQCvtACNdaGY6qq3Xv1jsnOUjQb2QH7RD79KBahj0U9he/l5LrBWs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R871e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0X9ir0wo_1787811692;
Received: from 30.74.144.120(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X9ir0wo_1787811692 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 27 Aug 2026 14:21:33 +0800
Message-ID: <70133332-966f-4bd2-99da-cfc5ad5fb6b6@linux.alibaba.com>
Date: Thu, 27 Aug 2026 14:21:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] mm/mglru: clean up isolate_folios and scan_folios for
 readability and clarity
To: Barry Song <baohua@kernel.org>, Kairui Song <ryncsn@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, axelrasmussen@google.com,
 baoquan.he@linux.dev, chenridong@xiaomi.com, david@kernel.org,
 hannes@cmpxchg.org, lianux.mm@gmail.com, linux-kernel@vger.kernel.org,
 ljs@kernel.org, lyugaofei@xiaomi.com, mhocko@kernel.org, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, stevensd@chromium.org, wangzicheng@honor.com,
 weixugc@google.com, yuanchu@google.com
References: <20260820045603.68809-1-baohua@kernel.org>
 <7e897a4e-2075-485a-8cc5-5bb928fba437@linux.alibaba.com>
 <CAMgjq7DFpKU=QdT4QNAREL8oLg-OAxM6zMcYkCECBVg=U5ECsg@mail.gmail.com>
 <56b8e283-f849-4fd7-9c2a-64b604176a82@linux.alibaba.com>
 <CAMgjq7Aemn51JRVx1_zxG=Z3ZhTBUW01erEpgHfDWT=BPGBLMw@mail.gmail.com>
 <CAGsJ_4xyurha07UNXB91jP5De+syHuVi4EyAXfMpMWZvr4n1kw@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAGsJ_4xyurha07UNXB91jP5De+syHuVi4EyAXfMpMWZvr4n1kw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3BDFE100002
X-Stat-Signature: dofwa5an8njy4qftmxw15mgfyt351hmo
X-HE-Tag: 1787811701-416826
X-HE-Meta: U2FsdGVkX185fqilFDKCEIPi96TrgfFpd2AeCNvU8hml6lZCSBiBX/2UxKVv1/+rD4BqhgJKXMsbsF0kaKGEDxbw/W8+ZfVMnN8iGx0yXbBBs7V9PTHHZYJbt8++bquLa8NtrQaoZxuGe1VeX+siEfgxiXABLvGuwPXkx6Z96YeYrklI4ltWSINbMHaldXgnYiDnSQGSKDINAYMoNl/4lwa24R3VUYJGCPMOdO3IHuBQ1B37oZZBClc4nRWT4o6AS7l1YIVF/tcdonotGLMmAM9TfG9t65wmy18hXk9qEgfXEB/FLBHPqht4TtL64q1OEy3rIQ+vvux6xaQpvzZazviPrs3+HUh3OUyhekY90ltKCl0Orjp1Z2gzze69/qCqo3bVz5vcLpT6C+1mTyN2JDC7tqcMvNhMn0HSJ0GyE5/AQ9va1oChY6LWtazWulvXC/X02QvutrO53q351Wb+3HlWjKmeeDZ0dyxW8IB7ilhMvntN5uP2PscXrNCIDVm24JCJhNFs4ByKWmOWb8QVOnLg7dIw+KHVmjgtF4GC2F6M/oMkcsHxgqUefx0+PbWOszet6OuseUalxPtyfD4Zk2t30mwlHodLdbXv95GFVnKgra6iZPVkgu/duLzRTdgD6PxTZhSlJ7V9FRwj4l3ZW81fCtc0zusHw8l+A0632iY/X8fE+HhztxogWVtfWZAN2BvsT7ud5dplFsjiqAS3O/24bkRMEsGlwr/HlaMuZt/tF4d6i+j4jIaSB/TKug8QVLhYpOoLJ7BfDSg92n7jHhimHsJwDetgLucim+CNkBtNklo978XDK2VMZ+dJCNpWaNDHUKLo4Xua7UnkQ6A9VVKjFFt5/ABqPlZFUJsIc1nksg1JmzqMc4nCLCkeDfO4jhUfgFsSUAyT9NnJzqriJ+UgTtQTZf0iRDEhvf36ynsW7hp9OCVDSGt83yg952s1kNmYtXq/uifhRy7JxqM
 ACRZWZgb
 9nUps/k8trXMPWLghHFYNVJ/ZG7Ti/QKY3mvu1yPlrlBAeMkzpvpk3NWmTTEzns2Oq+eyNGBCyejub+w5mkddfT1cQ4+tdb7SzGnrX3Cb2/gctyLm1xRiseXnK06caKUCyWwyCGyVZvzoaAUP9sDg6XZo0I3Ild+z67V8jEMWN7fPuyLVp8p6bEusMzbq9NWZ4mSWoE776Dm+AcMZtzV0Y4g7h8dNpCsXRLRfO60KEF5Ps9VmqCVmIhtf+hpRlm3POTtu8xgLeeIZyabvziad3/ICeNPcJ/RTA3BTAFrB1lFQYesiXGfhpGcXfxLdAFspoNFqQpbwIBJsD/FHJHGqEAA6qlKF9lD0JmgIf84JhOr+RjYs5BzJoSGSc6d1R4Sq1t1SbhCkQEX7hG5F7qx5JJrZBcATuSj9SWClELsha/CNLlITcZEY0R5tLiuALvZaRNYJsHmDuX8ukeqIXBG2WTsdtDeqzfRZeUVZDGHdkmYEatMGBu1kLuomqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/26/26 5:11 AM, Barry Song wrote:
> On Wed, Aug 26, 2026 at 2:10 AM Kairui Song <ryncsn@gmail.com> wrote:
>>
>> On Tue, Aug 25, 2026 at 5:06 PM Baolin Wang
>> <baolin.wang@linux.alibaba.com> wrote:
>>> On 8/24/26 7:05 PM, Kairui Song wrote:
>>>> On Mon, Aug 24, 2026 at 3:25 PM Baolin Wang
>>>> <baolin.wang@linux.alibaba.com> wrote:
>>>>> On 8/20/26 12:56 PM, Barry Song (Xiaomi) wrote:
>>>>>> This is a cleanup series split out from the MGLRU swappiness series [1],
>>>>>> with the cleanup changes separated to make them easier to review.
>>>>>>
>>>>>> Right now, isolate_folios() is quite difficult to follow:
>>>>>>
>>>>>> 1. It uses for_each_evictable_type(i, swappiness) to iterate over the
>>>>>> types, but i is not actually used as the type within the loop body.
>>>>>>
>>>>>> 2. It uses scanned == 0 to detect whether the current reclaim type is
>>>>>> exhausted, but this is not an accurate indication.
>>>>>>
>>>>>> 3. It has an internal retry when no folios can be isolated after scanning
>>>>>> some folios, but the retry is implemented in a way nobody can understand.
>>>>>>
>>>>>> This patchset makes these behaviors explicit and much easier to follow.
>>>>>>
>>>>>> Run kernel builds for several rounds in a 1 GB memcg and take the
>>>>>> average build time. The patchset shows almost no performance impact,
>>>>>> with a very small improvement that could simply be noise:
>>>>>
>>>>> Just FYI:
>>>>>
>>>>> I tested this patchset with a 3G memcg limit and a 10G zram device,
>>>>> running 'make -j32' to build kernel on my 32-core Arm machines, and got
>>>>> some performance improvement for ths sys time:
>>>>>           w/o patch       w/patch
>>>>> sys     1845s           1570s
>>>>>
>>>>
>>>> Hi Baoliln
>>>>
>>>> That's a very interesting result, can you share a bit more info about
>>>> it? e.g. vmstat? I'm curious how this happens.
>>>
>>> Sure.
>>>
>>>> I suspect patch 2 or 3 changes the swappiness / reclaim / aging type
>>>> selection behavior, or maybe it reduced the reclaim amount?
>>>
>>> I gathered the memcg stats as shown below.
>>>
>>> It looks like the direct reason for the performance improvement is an
>>> obvious reduction in anon refaults, which is what this patch aims to
>>> achieve I think. That is to say, we should respect the type chosen by
>>> the PID for reclaim, and try to exhaust that type before falling back to
>>> another.
>>>
>>> Before this series:
>>> workingset_refault_anon 59706846
>>> workingset_refault_file 9229283
>>> workingset_activate_anon 15108561
>>> workingset_activate_file 365660
>>> workingset_restore_anon 15108561
>>> workingset_restore_file 1018493
>>> workingset_nodereclaim 0
>>> pgsteal_kswapd 0
>>> pgsteal_direct 92589340
>>> pgsteal_khugepaged 549
>>> pgsteal_proactive 0
>>> pgscan_kswapd 0
>>> pgscan_direct 456629355
>>> pgscan_khugepaged 549
>>>
>>> After this series:
>>> workingset_refault_anon 41277086
>>> workingset_refault_file 9131522
>>> workingset_activate_anon 12924656
>>> workingset_activate_file 345901
>>> workingset_restore_anon 12924656
>>> workingset_restore_file 1005959
>>> workingset_nodereclaim 0
>>> pgsteal_kswapd 0
>>> pgsteal_direct 71723800
>>> pgsteal_khugepaged 4013
>>> pgsteal_proactive 0
>>> pgscan_kswapd 0
>>> pgscan_direct 342179445
>>> pgscan_khugepaged 9311
>>
>> Thanks for the info!
>>
>> I think it might matches what I had in mind: we currently have a very
>> subtle behavior for MGLRU: in try_to_inc_min_seq, it will refuse to
>> increase the gen min_seq beyound (max_seq - MIN_NR_GENS) even if the
>> last gen is empty, if another type still have MAX_NR_GENS left. As a
>> result, if one type is reclaimed more, and another type have many
>> folios stuck in the olest gen, the over reclaimed type will have a
>> very tiny oldest generation (all new folios land on the oldest
>> generation and are reclaimed immediately), that olest gen will stay at
>> a near zero size and gets exhausted very frequently, with min_seq not
>> increased.
>>
>> This will happen to file type very frequently if swappiness is low, or
>> happen very frequently to anon if files are frequently reclaimed,
>> really depends on the workload.
>>
>> The old "if (!scanned && type_fallback_allowed)" will return false and
>> raise the priority very frequently. Raising the priority means the
>> next reclaim cycle with run with larger reclaim ratio, resulting in
>> over-reclaim on both folios and slab. What's more, it might trigger
>> aging.
>>
>> With this series, it will see that as exhausted, and fall back to
>> other type, which in fact respects the swappiness / PID less, but also
> 
> We could have the following cases:
> 
>   1. If the reclaimed type has 3 generations left (with its oldest generation
>     exhausted), while !type still has 4 generations left, falling back might
>     be the best behavior. There is no way to avoid the fallback by increasing
>     `sc->priority`, because `should_run_aging()` will not trigger aging while
>     !type still has 4 generations.
> 
> 2. If the reclaimed type has 3 generations left (and its oldest generation is
>     exhausted), while !type also has 3 generations left, falling back might
>     violate swappiness. If we return and increase `sc->priority`,
>     `should_run_aging()` may return true and trigger aging instead:
> 
> return evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS == max_seq;
> 
> So maybe we could slightly adjust the code as shown below, although I’m
> not sure if the added complexity is worthwhile:
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 1f302386d8ab..181285463bbe 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4878,9 +4878,10 @@ static int isolate_folios(unsigned long
> nr_to_scan, struct lruvec *lruvec,
> 
>          /*
>           * We are running out of the current reclaim type. Fall back to
> -        * the other type if allowed.
> +        * the other type if it has at least two generations to reclaim.
>           */
> -       if (exhausted && type_fallback_allowed) {
> +       if (exhausted && type_fallback_allowed &&
> +           get_nr_gens(lruvec, !type) > MIN_NR_GENS + 1) {
>                  type = !type;
>                  type_fallback_allowed = false;
>                  goto retry;
> 
>> avoid the raised priority and over reclaim in some cases. I did a test
>> on my machine and it seems matches that model:

With the above changes, I can also reproduce the slight regression with 
NVMe swap (set swappiness = 100) mentioned by Kairui (but the zram case 
still looks good):

Before:
sys: 757
refault_anon 5554715
refault_file 3867998

After:
sys: 765
refault_anon 5791349
refault_file 3939552

>> Before:
>> *** Executing swappiness 1 ***
>> sys: 665.941
>> refault_file: 945242
>> refault_anon: 916129
>> pgscan_anon: 13195435
>> pgscan_file: 2419874
>> *** Executing swappiness 60 ***
>> sys: 650.801
>> refault_file: 238839
>> refault_anon: 1026646
>> pgscan_anon: 13082867
>> pgscan_file: 809642
>> *** Executing swappiness 100 ***
>> sys: 621.135
>> refault_file: 211113
>> refault_anon: 931943
>> pgscan_anon: 12008517
>> pgscan_file: 778586
>> *** Executing swappiness 150 ***
>> sys: 633.591
>> refault_file: 198239
>> refault_anon: 987093
>> pgscan_anon: 12645094
>> pgscan_file: 709927
>> *** Executing swappiness 200 ***
>> sys: 627.747
>> refault_file: 163649
>> refault_anon: 1024657
>> pgscan_anon: 12088189
>> pgscan_file: 653841
>>
>> After:
>> *** Executing swappiness 1 ***
>> sys: 729.234
>> refault_file: 962067
>> refault_anon: 1175614
>> pgscan_anon: 14588298
>> pgscan_file: 2396037
>> *** Executing swappiness 60 ***
>> sys: 677.685
>> refault_file: 238877
>> refault_anon: 1008627
>> pgscan_anon: 13744350
>> pgscan_file: 888445
>> *** Executing swappiness 100 ***
>> sys: 668.947
>> refault_file: 250359
>> refault_anon: 994929
>> pgscan_anon: 13307019
>> pgscan_file: 794981
>> *** Executing swappiness 150 ***
>> sys: 649.764
>> refault_file: 180899
>> refault_anon: 971073
>> pgscan_anon: 12238885
>> pgscan_file: 709684
>> *** Executing swappiness 200 ***
>> sys: 648.377
>> refault_file: 228112
>> refault_anon: 1237758
>> pgscan_anon: 12653346
>> pgscan_file: 734499
>>
>> So I think in theory we might see more ineffective swappiness after
>> this series, I'm also a bit concerned about the "lrugen->min_seq[type]
>> + MIN_NR_GENS == lrugen->max_seq;" check which is strictly related to
>> the limitation of try_to_inc_min_seq I mentioned here... In the long
>> term I think we better get rid of that limitation, not sure how the
>> behavior will change or fit after this.
> 
> In the earlier RFC, I got rid of the generation sync in
> `try_to_inc_min_seq()`:
> 
> https://lore.kernel.org/linux-mm/20260726122123.7614-4-baohua@kernel.org/
> 
> It does help with swappiness, but also slightly increases sys time at
> swappiness values around 60, so I dropped it from RFC v4.
> 
> Basically, letting file and anon catch up with each other seems to offer
> the best performance at normal swappiness values such as 60–100, but it
> essentially makes MGLRU's swappiness a toy.
> 
>>
>> BTW the above tests were done with ordinary block SWAP, with ZRAM, I
>> see an improvement instead (it's related to how SYNC SWAP discards the
>> folio immediately and blocks the thread while ordinary SWAP does IO
>> asynchronously so there would be less concurrent reclaim, and changes
>> the dirty/writeback mix that evict_folios()'s
>>   loop sees, especially nr_reclaimed, and here we will avoid raise of priority):
>>
>> Before:
>> *** Executing swappiness 1 ***
>> sys: 599.135
>> refault_file: 925843
>> refault_anon: 1838025
>> pgscan_anon: 20390687
>> pgscan_file: 2423955
>> *** Executing swappiness 60 ***
>> sys: 591.367
>> refault_file: 336184
>> refault_anon: 2350551
>> pgscan_anon: 21099503
>> pgscan_file: 1109003
>> *** Executing swappiness 100 ***
>> sys: 593.672
>> refault_file: 328276
>> refault_anon: 2332940
>> pgscan_anon: 20894727
>> pgscan_file: 954910
>> *** Executing swappiness 150 ***
>> sys: 585.939
>> refault_file: 296374
>> refault_anon: 2063673
>> pgscan_anon: 20537898
>> pgscan_file: 935107
>> *** Executing swappiness 200 ***
>> sys: 574.283
>> refault_file: 313356
>> refault_anon: 2065897
>> pgscan_anon: 20145043
>> pgscan_file: 881381
>>
>> After:
>> *** Executing swappiness 1 ***
>> sys: 578.699
>> refault_file: 844457
>> refault_anon: 1793171
>> pgscan_anon: 19307170
>> pgscan_file: 2364248
>> *** Executing swappiness 60 ***
>> sys: 582.053
>> refault_file: 390580
>> refault_anon: 2066277
>> pgscan_anon: 20413030
>> pgscan_file: 1201373
>> *** Executing swappiness 100 ***
>> sys: 567.520
>> refault_file: 295709
>> refault_anon: 1923291
>> pgscan_anon: 19299837
>> pgscan_file: 978007
>> *** Executing swappiness 150 ***
>> sys: 582.983
>> refault_file: 311833
>> refault_anon: 2041126
>> pgscan_anon: 20547029
>> pgscan_file: 940061
>> *** Executing swappiness 200 ***
>> sys: 562.710
>> refault_file: 301914
>> refault_anon: 2005846
>> pgscan_anon: 19257095
>> pgscan_file: 839522
>>
>> So in summary I think the gain is avoiding priority increase (by
>> falling back to another type and satisfying the reclaim target in one
>> iteration, when one type have a tailing draning gen); the loss is less
>> effective swappiness. In fact, I think we might fall back to another
>> type MORE, especially when under pressure, not less, contrary to what
>> the patch message suggests. Not really against this change, just a
>> headup that there is a impact on swappiness / aging of this change in
>> an unexpected way, and things may gets more interesting if we want to
>> lift that limitation in try_to_inc_min_seq as this is directly related
>> to that.

Thanks Kairui for your data and anylysis.

I mostly agree. But on whether we should fallback more, I still prefer 
Barry's idea. The current patch might be a bit too aggressive, cause it 
only fallback to another type when the oldest generation is fully 
exhausted. I've always felt that falling back too easily doesn't really 
respect the PID's choice.

Of course, there's also the concern you raised about the limitation in 
try_to_inc_min_seq() when updating the min_seq. I think we can address 
that together later, so that we respect the PID's choice (i.e., try the 
reclaimed type as much as possible) without ending up with a tailing 
draining generation that blocks aging. That may not be simple, though.

Anyway, personally I'd prefer to keep the original code until more 
impact investigation is done.

Just my 2 cents.

