Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2453B105D996
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 02:35:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FD796B0089; Tue,  7 Apr 2026 22:35:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D3FC6B008A; Tue,  7 Apr 2026 22:35:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 712096B008C; Tue,  7 Apr 2026 22:35:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6296F6B0089
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 22:35:23 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 092DC160A09
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 02:35:23 +0000 (UTC)
X-FDA: 84633822126.18.CCEE866
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf07.hostedemail.com (Postfix) with ESMTP id 37C5B40013
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 02:35:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=GdJoRXh1;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775615721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rhgcVGNkIdqzP97BKYsaYuB6sJP9zA3v3Is4NOEz5rE=;
	b=qhY3J9w5u1b13BZrO5i9LbuhENnHtLLYqn+GVMQbPpZOa1zCu05ZdfeuCiCygJnSpvypbe
	y9X/Fzc3SCgzsJ8cZObYh5QwPLTbnw17rz3t+35sT/al1OouEJuotioF7su4aQw0EDV+Hz
	8qqbxOGFV9G3IJ3U/B1gUEXeYt08DLM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775615721; a=rsa-sha256;
	cv=none;
	b=wb/KqKAaLvScGCqGiKgjnJeiklO92ytYhQB6C+/33ixS15pZTNGE7YQyoXhMh4u7ZGqyK8
	nRA4L39Fb119ujhK+XN3TCiDnhGD2rbrqFl+m3IiPiymYQZMaUJS0DEw8rYb+q1f+1zVLj
	lVx+8jCwp7Fj7yTr0iPIVc+9SBL4JK4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=GdJoRXh1;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775615713; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=rhgcVGNkIdqzP97BKYsaYuB6sJP9zA3v3Is4NOEz5rE=;
	b=GdJoRXh17Qo7z4o7flxsr2lJswiYMvEIPicswCxLIHgtf+cFw8dR1LQ9bYRgD4VTp48RLXfFm2wxfA8w/9MXMIRwjmQTiyKZAyp5c+axude+8xFis7kpb6ZJ65s4ql8qxSpgNpLC4UHw6F2t21ijbi6NCyktCvHyzsiSQcG0A8E=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X0dBvl6_1775615707;
Received: from 30.74.144.134(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X0dBvl6_1775615707 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 08 Apr 2026 10:35:08 +0800
Message-ID: <367ea69a-c802-46d5-a2c7-259342cdc2ab@linux.alibaba.com>
Date: Wed, 8 Apr 2026 10:35:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] mm/vmscan:Fix the hot/cold inversion when swappiness
 = 0 or 201
To: Barry Song <baohua@kernel.org>, Kairui Song <ryncsn@gmail.com>
Cc: wangzhen <wangzhen5@honor.com>, Andrew Morton
 <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, "kasong@tencent.com" <kasong@tencent.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <7829b070df1b405dbc97dd6a028d8c8a@honor.com>
 <4451bdc432864aebb54f401eee51ea53@honor.com> <adUM54W3WYwEFj3J@KASONG-MC4>
 <CAGsJ_4yZHjSq=d1g7dJC9szwRVLuHqLpWt0Cphi7npzrQz6p3g@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAGsJ_4yZHjSq=d1g7dJC9szwRVLuHqLpWt0Cphi7npzrQz6p3g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: ts541quk4c7r171h66hxbagh9jjf7755
X-Rspamd-Queue-Id: 37C5B40013
X-Rspam-User: 
X-HE-Tag: 1775615718-403131
X-HE-Meta: U2FsdGVkX19zN8ZUkpnNm9jrbYafnn6bza1yfDdzi6YhrRBrbGbf5DIwPIXmck1xUsRYqUBDPldxH3iyFbijfQIiHoSlVv/X20ORqzpzWUUJGrlHIbkxAsl7wCR7OuY+lhE2vjc65kCeeD+IDT8a3XBMsAAr82EMr0wBVory24VsOdc5L8U0k96eGyfwNrOR9hwQagJw43BnY9BIAO/PjD/kgquTKoCz300DHVE0+wdXRgm0Nsn8ZZST81YyQz/WcFQ+pNTVMH8sxIrpvz1UwlTRbH+89hXzlLJNUXKb4wF7A0Emf10vER/OJ1BAwSM1720LxY1PGhNxeN+JsuuYiUg8Ox88UDKiV48+RViTNgCkmtgRNzEWTOf8LerYwfkyrsHTK9lnWJ8j5oBE7sYAkXSXVOGy0wvIdIR18fihzVvicWDMJEYqfhAertWUm5KW6XVjZEVoocQbttWDbwzQpmhwLUpZdIp9uoQsSLQOmRMG9T35VUEkpkjGgV7g/hygTJ3QTJ115MKvpElmklACPvP/vI/8aPbNn4UBNYhqEM7PgVeKfxTsuN4WjojOkzieaBFcp2/yF3dBv2dKvN9mES7LoLjAGGW4rjhTuE8/g9+AdX7ZylwdBsbH78FylHdSSnO2nwOKIxeolcldJQPCizUgj/0qQACEr50xyNP77ZukXQOYDiyZB/WA4xeQ/viuEgYdkKzIgCvGDL8yFzdpDWSNFh1ztr4DoMPngsG/lxw9B9HsDIFDksQdTRz8113OFnlQkRhwQXLQIK7BWnUy6gavuTAA743HdhM79xRbLo+rZaRb4cxXRWdBQQN1f8Me2Qkcmnrysq6IBqJabGrb5n7Gs9FDaU7ZTFdndhWV4KWY0X0LY/JhHWlJhRyAcFL7/VtQDUaCuSzVp/RWP9O18apoq3UY+PbQGXVX/qSKDiSTpD1vWfF5m5VKgdZ51WdWHwwQRI6+DhiX78WcgnN
 H8vh2OMt
 uhiLhBUtd3C3HEPRLp5todriwOEVWffmsUKf0hTDGM91rpb7/+xmP7x12AF/8y1ydAANPz+jWPSxAoc5glZyo0K3VaeqVJ8+o5FzROGz/RbnWA1dOTuJBi9Ft6rpZDXIfudRMQG/57ZuioyYxpvCjfqoA99MT7yOdw6qykVsQfaOIs4wGdftk20ie/iyG1K+l9ivs42DGLY7ynJGP2U8Q03QKsP9i/W3bbAP4zA+gxOTzHcpnh/IejbfjG352u1jQ1Nea64LxbEw0j8f27IA9CEpd/ubIo1K/6IBMx4faebZvFSj/TktBVt/v5CU2ys8zdJ/WYcMcUrCeW7M7TdF/fvxbOpXRDUvp6EOm/2U072jaPxvepwxlxJMXDtpCkUCocU04aXbb/0+A2SeZ8gHP02Hs7u+G7PQRFZj8e6yuUWzF+zIjSQPQmtccyydiCn0umUbyERVR/k9EJ0m4UNDEJfVnJKI0B83ORa72
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/8/26 7:00 AM, Barry Song wrote:
> On Tue, Apr 7, 2026 at 10:26 PM Kairui Song <ryncsn@gmail.com> wrote:
>>
>> On Tue, Apr 07, 2026 at 01:37:08PM +0800, wangzhen wrote:
>>> >From ac731b061f152cba05b9aa351652a04f933986e0 Mon Sep 17 00:00:00 2001
>>> From: w00021541 <wangzhen5@hihonor.com>
>>> Date: Tue, 7 Apr 2026 16:17:53 +0800
>>> Subject: [PATCH RFC] mm/vmscan:Fix the hot/cold inversion when swappiness = 0  or 201
>>>
>>> In some cases, when swappiness is set to 0 or 201, the oldest generation pages will be changed to the newest generation incorrectly.
>>>
>>> Consider the following aging scenario:
>>> MAX_NR_GENS=4, MIN_NR_GENS=2, swappiness=201, 3 anon gens, 4 file gens.
>>> 1. When swappiness = 201, should_run_aging will only check anon type.
>>> should_run_aging return true.
>>> 2. In inc_max_seq, if the anon and file type have MAX_NR_GENS, inc_min_seq will move the oldest generation pages to the second oldest to prepare for increasing max_seq.
>>> Here, the file type will enter inc_min_seq.
>>> 3. In inc_min_seq, first goto is true, the pages migration was skipped, resulting in the inversion of cold/hot pages.
>>>
>>> In fact, when MAX_NR_GENS=4 and MIN_NR_GENS=2, the for loop after the goto is unreachable.
>>>
>>> Consider the code in inc_max_seq:
>>> if (get_nr_gens(lruvec, type) ! = MAX_NR_GENS)
>>>      continue;
>>> This means that only get_nr_gens==4 can enter the inc_min_seq.
>>>
>>> Discuss the swappiness in three different scenarios:
>>> 1<=swappiness<=200:
>>> If should_run_aging returns true, both anon and file types must satisfy get_nr_gens<=3, indicating that no type satisfies get_nr_gens==MAX_NR_GENS.
>>> Therefore, both cannot enter inc_min_seq.
>>>
>>> swappiness=201:
>>> If should_run_aging returns true, the anon type must satisfy get_nr_gens<=3. Only file type can satisfy get_nr_gens==MAX_NR_GENS.
>>> After entering inc_min_seq, type && (swappiness == SWAPPINESS_ANON_ONLY) is true, the for loop will be skipped.
>>>
>>> swappiness=0:
>>> Same as swappiness=201
>>>
>>> so the two goto statements should be removed. This ensures that when swappiness=0 or 201, the oldest generation pages are correctly promoted to the second oldest generation.
>>> (When 1<= swappiness<=200, only both anon and file types get_nr_gens<=3 will age, preventing the inversion of hot/cold pages).
>>>
>>> Signed-off-by: w00021541 <wangzhen5@hihonor.com>

Please use your real name to sign off.

>>> ---
>>>   mm/vmscan.c | 14 +++-----------
>>>   1 file changed, 3 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>> index 0fc9373e8251..54c835b07d3e 100644
>>> --- a/mm/vmscan.c
>>> +++ b/mm/vmscan.c
>>> @@ -3843,7 +3843,7 @@ static void clear_mm_walk(void)
>>>                kfree(walk);
>>>   }
>>>
>>> -static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
>>> +static bool inc_min_seq(struct lruvec *lruvec, int type)
>>>   {
>>>        int zone;
>>>        int remaining = MAX_LRU_BATCH;
>>> @@ -3851,14 +3851,6 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
>>>        int hist = lru_hist_from_seq(lrugen->min_seq[type]);
>>>        int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
>>>
>>> -     /* For file type, skip the check if swappiness is anon only */
>>> -     if (type && (swappiness == SWAPPINESS_ANON_ONLY))
>>> -             goto done;
>>> -
>>> -     /* For anon type, skip the check if swappiness is zero (file only) */
>>> -     if (!type && !swappiness)
>>> -             goto done;
>>> -
>>
>> Hi, thanks for the patch.
>>
>> We have a very similar patch internally, and the result is kind of bad.
>>
>> Currently MGLRU forbid the gen distance between file and anon go larger
>> than 2, which mean with this patch, when under great pressure, you may
>> have to keep rotating a long list of the opposite type of folios to
>> reclaim another type.
>>
>> For example, when you have only 2 gens of file folios, swap disabled,
>> and there are 3 gens of anon folios. Anon folios are unevictable because
>> there is no SWAP. And file is also unevcitable due to force protection
>> of gen. Consider anon folios are mostly cold (at least a portion of them
>> are), now the oldest gen of anon folios will be very long (e.g. 12G,
>> 3145728 folios).
>>
>> Now, to reclaim any file folios, you have to age first. Before this
>> patch that is usually fast. But after this, it will have to rotate
>> all 3145728 folios to second oldest anon gen, will could take a
>> very long time.

I have the same concern. In many of our scenarios, swap is disabled 
(swappiness=0), and we only reclaim file folios. In such cases, the 
workloads really don’t care about the hot/cold status of anonymous folios.

>> During that period any concurrent reclaimer will get rejected
>> due to force protection, result in very ugly long tailing or
>> unexpected OOM.
>>
>> So I agree this is a good idea in general, I agree we should do
>> this. But better defer this until we patch up MGLRU to remove
>> the force protection first.
> 
> I suspect that once we can age file and anonymous pages
> separately, this issue will resolve itself. David already has
> some code for this [1].
> 
> Not sure when he will have time to push it upstream, but I
> may carve out some time to take care of it this month.
> 
> [1] https://lore.kernel.org/linux-mm/aam5nOyXs1sNdjTe@google.com/

Great. Sounds reasonable to me.

