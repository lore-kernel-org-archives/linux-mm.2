Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00450C5DF82
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 08:53:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 142D56B0092; Thu, 20 Aug 2026 04:53:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F3DD6B0095; Thu, 20 Aug 2026 04:53:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 009706B0098; Thu, 20 Aug 2026 04:53:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CC2E66B0092
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 04:53:16 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5EA34160545
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 08:53:16 +0000 (UTC)
X-FDA: 85121033592.07.2B3B2B4
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf02.hostedemail.com (Postfix) with ESMTP id A346F80002
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 08:53:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=WepVckGW;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787215994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o8Lji253+j+EUKJdFcDdXwfYlhhfwBCDuK0dwHnKqzw=;
	b=swzc7ymoxEXzb6Sr/OJyssS7KpEiYBiTqj1sOEeXZiOmJU5CMA3VNSHIOi8AICvusdIkJR
	guy9hgotN6GxnsP8uB8BjYlMCIPGHeSuR6c9FiwBXCqzlZUqf6duOLOd4iKcxMbauEk4xT
	4t5hII6S9g/+QUOHy5gJ5p7zm8oQDE0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787215994;
	b=eoG++UGzQkvLXSds+XfTOpas4/Ul1KhrT/eDeiz4tAyUp6C07Z/W/14hySY2pjrx6yUa6j
	KMOTMgyQeCgIs7yw5TsKdxipo3PSwBsmaZaTJnvCAt61jqx39hrBOQzMI4E4hySSWG/PTY
	S8Qz6YTrdo//dAimXAETqwRKbSZCidA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=WepVckGW;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787215989; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=o8Lji253+j+EUKJdFcDdXwfYlhhfwBCDuK0dwHnKqzw=;
	b=WepVckGW9SZcUgWY1ngYkR6E1lJc/s9Jn+9QSsIlkbEAfqD8AQhtWo+Gp0HSwkOHs1Qt+XO9+9WnCjB6cS2thT/8NPDgtZH7ut+CWCeyiz2PjrlvrZ+bWVQ41rOP7xs3vuHfRNc3uG3uqj4xJ3ZSsqxVE/QymEKeqUk4HTzWBSQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=23;SR=0;TI=SMTPD_---0X9J.X2b_1787215987;
Received: from 30.74.144.123(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X9J.X2b_1787215987 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 20 Aug 2026 16:53:08 +0800
Message-ID: <43bbc1de-039d-422d-9119-c7392e0229c6@linux.alibaba.com>
Date: Thu, 20 Aug 2026 16:53:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/7] mm/mglru: fix potential generation folio number leak
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>,
 Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
 <20260818-mglru-flags-cleanup-v1-6-8dbbdac0d28c@tencent.com>
 <5db7dbfe-ec22-4a25-a85d-497e6ed1f8b1@linux.alibaba.com>
 <CAMgjq7Bz5Kz0YxFcVwbWV4bh_T4qQH0vZYbxFCXDtLzeX5hjtQ@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAMgjq7Bz5Kz0YxFcVwbWV4bh_T4qQH0vZYbxFCXDtLzeX5hjtQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: oefddwxx7op1sky6b5m8a1ex5zpsfkwf
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A346F80002
X-HE-Tag: 1787215992-475908
X-HE-Meta: U2FsdGVkX18hmnx1+8JouE2k7SJ4335kD4ac6vjc/Jt9570uxOLP5uKRAXxKoEwPsQ/sa1/ssq8VVX5sFPfFx5U6ZgXo5PB90+B+HnbyI3gFPIOKUJvNMEMGYLHLZUBgYDF5uWXcbgtmPROPRWjeuITrSpaJbHMnL+L2dZapuE36K6ygximLsU2MFoHIZyg3aYt7Z6qVxtB8tFioEgIsRYrtItFgbTI31wDsjfB16CMOKX4NrgNPJRokVEaoj789gRyo86dlOhWuLGQgS0RJgs6DOI+Ol9ahNFDI3Jjm0cMq3WmHHNBjSKyJ3SaH9nkCK1vhLBgb0LMVyh8qYfIr++XHFfk2j/54RmUPDrbeRIJ1vNvPBc2r5YsrGg0q5fw1m8H27PaqjQpmTpFxPlRlUaDm3XNjQd3W0abV7zEKli5uxzyUm9+HweqiJ90HigXaJ8wS06C3wxptyVyW++yawKWvN2rmvniZih2WCVHpcWUmOgz/O30iEv1ng1fQCwJHRuuFO1Ug+vQqIS2s6SJ3TWF3/ev/f/RMWULghLtDkIsa2t30O3MEGdJjlEoEjXzzOoqGFSzcBmQJNJrOCV+Nkwddt+eZMGsGKtW4yowcghO444Vm1K1tJPqKZieerUir0kE5kPHpF1uSLFfP+APNJ+sK27alwD2ExBEtEwow1NFONUy6raQXPne4CJ2dNE/LJbAzHZ57HN3pQbWEt3Hj1j2ZjtJ9nmbtj/JooSrg9syOK8/onNJWwoKfff97ght9rU9o8HtjDfsHzXlgbnT2hb6sC84220HbHWuLXH0VthnqqpMNpPXUpYg8k/ei42r/8sFt68IFWIKNHwY5CjK1kEnBSKYSJG8aelE2hoRXKVKcKINz1giyoBrRw/QVBvdAHuJKPHB3xao20noRvZi/Il2Ct26TX3R2IA+OQTB7h/1gXQNQMtrlfK7kpJfaF8NKmDchtcGfq9DIz5CU/gy
 ltcLTBx+
 mnKX150uANSHbUZe42NW1L4MrlIlovnJ6iaZh+/NvLA1R1IkYK8BZ+3SySrUJ31r6BWl+CN/GXxGWfq6lUiFpMrl2k7gs0xFpDJjnuLGTMgw/O6qoVRi1QlbWrJvH1GEfj47UolxeV51gUm4cczeKGCWp4bPlusPmdnvGmz6zjV8N4+/qDUX0E6dovSheu9MKlMzgNXSlVeQQtnFUiPuz1DefqulJyDycJrGo89UKZgkkRkRYii6Ux8iGa50gNOQ/FFKJckVnKjiDupYf3tynQ4Do+3NS9krotQt50dUbpgqVNKgDifNRwGYtYVfaYSMrvMQoQshCS1Xb53eD7OMavOv9GAuqP8W/eLTS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/20/26 11:45 AM, Kairui Song wrote:
> On Thu, Aug 20, 2026 at 9:52 AM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
>> On 8/18/26 1:38 PM, Kairui Song via B4 Relay wrote:
>>> From: Kairui Song <kasong@tencent.com>
>>>
>>> Each generation of MGLRU accounts anon and file folio numbers
>>> separately. The page table walker's update_batch_size() derives the
>>> anon / file type of a folio from its current flags, but the page table
>>> walk holds neither the lruvec lock nor the folio lock, so the type can
>>> change during that period.
>>
>> Right.
>>
>>> MADV_FREE's lazyfree path clears PG_swapbacked under the lruvec lock,
>>> so the folio is no longer considered on the anon LRU list. Lazyfreed
>>> folios can also be changed back to the anon list again. If the flip
>>> lands between folio_update_gen()'s cmpxchg and the type read in
>>> update_batch_size(), the batched delta pair is applied to the wrong
>>> type. The anon and file generation counters then carry phantom deltas
>>> that nothing reconciles, permanently skewing lrugen->nr_pages and the
>>> reclaim budgets derived from it.
>>
>> But I think the problem occurs between update_batch_size() and
>> sort_folio(). update_batch_size() only updates the anon or file folio
>> statistics, while sort_folio() moves promoted folios to the
>> corresponding type's list:
>>
>> /* promoted */
>> if (gen != lru_gen_from_seq(lrugen->min_seq[type])) {
>>          list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
>>          return true;
>> }
>>
>> If the folio's anon/file type changes between these two steps (e.g., a
>> lazyfree folio), it would lead to what you described: "The anon and file
>> generation counters then carry phantom deltas that nothing reconciles,
>> permanently skewing lrugen->nr_pages and the reclaim budgets derived
>> from it."
> 
> Actually no, the counters follow eventual consistency (note the word
> "permanently"), we are fine with a drift as long as it will eventually
> be corrected. Lazy promotions creates counter drift from the physical
> location, but that is actually fixed by the sort_folio.
> 
> Now, for the type issue, use the lazyfree case as example (I think
> that's actually the only place,), lru_lazyfree will remove the folio
> form lruvec before marking it !PG_swapbacked, so during that removal
> period, the gen bits are zero (folio's gen == -1), so any lazy
> promotion CAS won't touch the counter, and only folio_update_gen will
> do it since folio_inc_gen only handles on list folios. The
> PG_swapbacked clearing in lazyfree only happens on folio wich has gen
> == -1 (off-list). And it makes sense since update PG_swapbacked need
> to update the counter and move the folio.
> 
> And if the CAS happends before the list removal, the list removal, the
> folio is on the anon list, so the CAS is moving a folio in the anon
> list, folio_update_gen will call update_batch_size asking it to update
> the anon counters, we are fine after this commit. (Before this commit,
> the CAS is moving a folio in the anon list but update_batch_size may
> occur on file coutners). The list removal will update the anon
> counter, and the subsequent list addition will account for the right
> file counter.
> 
> And if the CAS happens after the list add, we are still fine since the
> file counter is charged and sees a file type here.

Thanks for the expalnation. Now I see the problem and I think your are 
right.

(This involves the combination of the gen counter and the folio's type, 
so it would be better to have a diagram describing the race, otherwise 
it's indeed hard to follow.)

