Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 201D5C5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 09:07:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1E956B009D; Fri, 21 Aug 2026 05:07:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECF366B009F; Fri, 21 Aug 2026 05:07:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBF916B00A0; Fri, 21 Aug 2026 05:07:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B29D76B009D
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 05:07:44 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AD58D12038F
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 09:07:42 +0000 (UTC)
X-FDA: 85124698764.05.96FFB27
Received: from mta0.migadu.com (out-143.mta0.migadu.com [91.218.175.143])
	by imf27.hostedemail.com (Postfix) with ESMTP id A45BE4000D
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 09:07:40 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=E+d7wi3n;
	spf=pass (imf27.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.143 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787303260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DIrXe8lV0NdiFGvtqybC76RwxD61MZwOtglYbfCGs5Q=;
	b=8Cxmlvfv56vpz4V22IwXrmH4AnGyc5GwDLwkhiDyIX0KQ8icJER11sehw9eKRlME9wH3dC
	ljmCVh/yvcrjclpL8FfRGwaoaIh+cJUjPaVdtPB73wWEUWzYTSA1tW7lNdZtTzK2CVXsbL
	YKcyRpW7kenu3w3OQHtEG3roQJ0xjhY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=E+d7wi3n;
	spf=pass (imf27.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.143 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787303261;
	b=sDPTv2Km13r4wekLFwctxJfIDmJGkC9Z5Ltk73Q17joakXsQYE/mvs/p2yHCUb11hmjMO6
	zN16yo9wD+30kerQqfUCCXx+dl1Os5G+eKsQkQSeJ3tb3tX7J2CB0TPyY794Iaul/jfE/t
	EkIhtwyKXoTSAQLcBpY/p4izXQ4yUjY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=eCwASTHpoWsrxN4d3WgmkrBfGb32xZZ4Xx/zGVsxROM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787303259; v=1; x=1787908059;
 b=E+d7wi3ntrxmw3Z/Qg1QdNBJQBxB3fUijiPs2r2gyq/eG/2Od1toiLkeP2U8zEA9ofcgL2+6
 oyCSSV0dTfCnhPxLTOu20GQ6rXJ0PhKlBGytSxqsmu6MKbjSBCplMDltY8MoqqkQ5d8MVPgPvQv
 qJBYn6UevB8S6YakwrzN19Dc=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.63.107.123] (14.29.108.92)
	by smtp.migadu.com with ESMTPS id d1d12baf5bc52389;
	Fri, 21 Aug 2026 09:07:39 +0000
X-Mizu-Trace-ID: d1d12baf5bc52389
X-Migadu-Flow: FLOW_OUT
Message-ID: <f45848da-9569-453f-b0c0-8aa984e1976d@linux.dev>
Date: Fri, 21 Aug 2026 17:07:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/4] mm/vmscan: honour node reclaim limits per type
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Ridong Chen <chenridong@xiaomi.com>
References: <20260821081741.1340277-1-ridong.chen@linux.dev>
 <aogMyu5R_DZRqp2J@tiehlicka>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <aogMyu5R_DZRqp2J@tiehlicka>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A45BE4000D
X-Stat-Signature: 7c87zzwobng7nr646i5i6cz14oi4dno4
X-Rspam-User: 
X-HE-Tag: 1787303260-770640
X-HE-Meta: U2FsdGVkX1/2Sroq8Ru1S6BZQZgotQKfhTK8gkZhK9BCjcSZprZaVIQ8hCIwljTulqElSzBbkqMwyABN/OdVzws8kbFWTF379eZK4Nif+7MBQCcarjAn3EhH0+0NGmR1V3Np1mhUsgOELL+OpnbFUEFWP8+fCyR6Y8L9BSxPJxIJHGHXxZgNSiMLmjyd8a/ifVhK/zFju1tcAuk0BOjIdbrhhUoXlOF9wf2obfj8evQ5SX7DxRprMoBWJi02uPU/YnLS2TyecMMHI0KFp/+30rh1AA4kcwhVRQ1z8yFwkhXrcgyuXN72ZWb7e+z9leAWzWdptTccwcpQ+1BBk1BQTEeRsXU5IavH6VC0EQc5fCaHgT8DDj/kZNX+mhfwZ0y4yOvhdx6A60FwgFrQnilY+g9twnFxAh5f/O80q2Mc7YmkNNfJWjkm0veQskgvUUEm42GYeQxyyA3gxuqWDLKrTK1nGMt3xurbETa5Gi1hr8uh4L7azCC5gyW7g4R0Z1FTRauwgSRozL2FvFlrgfPgSOt336z8juNd1IEou2j7Lk7Y5bHjKHmiZYH9DKKVEmeyLKPeiWfdCP46lO0wYLMurrNVuOCwHlmpzSBEOS/kOAMA51+E98ihWSxlsF5SKjOR1xGVphXESOaBT4Xv2skryNzz5jxMZS0NQ60VzvM5Md2lcLtunxHV/Ql3tYKuKzhWcR0df8cxSpeKJLXCuQYKLDOB3d5j3/mFUyak3TnPiu0Tb/FDGoF3wc6KWPtnJ6WtZQA/cghqwoJI6PhygkIIxrrOel1IiE1akiXhCfPj+KCkMKRCJHv3VO8bQa6GMqxv7BfsfuyKXyA/nsmrTOMj8K1493H4isLHyS2QXgTwIPFNDkIifvZG3Qa+4ia0Eh2IXNWcS/tm1Tl+DxqzbUkleB6zTU7GHFlxFfecsFwjCROZPn6zjz+z6Wm8lQ3LFgkZxKlI2xLtuiUQqWUEgsk
 DDlvmAvP
 rcPA3LGrKLf5h3PuCL0qNnkXT1dgv9BrHe5+F4eNZlDhl4FCXWdVQUfc7Umlp3+CYmL2r8OQwEX4+CJx/cQfUpA1pP/7O7mNx+Yh9HTJ6LS+qTMLURp9vFYzFaGa0vqccKxt+UDPeFBCH+7cIch2FaQmF/6Uoq2j1yG6+U2Rkn4Jwa1hQ1QCTgP1Sc7pSSio6gISn3Klg/2gDux1uuKRyWmcSKOvLHkFX9/lz5y2NMI3/LRwSvFHNm6/YsHjHYNyQF7wtVB7+FNymKNh+vpCCqbjykQkvK6RKhtc1TAkFEsu6itrLfKih6o0PWjqxthmJmcPq94hinv1lkxfD1JehULWvMxaIOh5EqPdbE/ghIns3Tb3WP/DbrZFXdl8j/AhxXn+iKaCVzAj778VwykXqnHATRg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/21/2026 4:31 PM, Michal Hocko wrote:
> On Fri 21-08-26 16:17:37, Ridong Chen wrote:
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> min_unmapped_pages and min_slab_pages are documented as per-type limits,
>> but node reclaim treats them as one combined gate: once either is
>> exceeded, shrink_node() reclaims slab, file and anon together and pushes
>> the other type below its limit. Per-node proactive reclaim reuses the
>> same gate and fares worse -- with page cache and slab both under their
>> limits it reclaims nothing and returns -EAGAIN on an anon-heavy node [1].
>>
>> This series gates each type separately via two scan_control flags
>> (skip_slab_reclaim, skip_file_reclaim) set only on the node reclaim path,
>> drops the combined gate, and extends node_reclaim()'s early bail to check
>> anon. The flags default to zero, so kswapd, direct, memcg and drop_caches
>> are unaffected.
> 
> You are explaining what but missing the most important part _Why_ do we
> need to have this addressed? Is this just addressing Sashiko review
> refernced below? Is there any real usecase where the current behavior
> matters?
> 

Hi Michal,

Thank you for your reply. I should have made the background much clearer.

Yes, the original issue comes from Sashiko's review. Sashiko found that 
proactive reclaim fails to reclaim memory when the node's unmapped file or slab 
pages are below the minimum thresholds, even though there is plenty of anonymous 
memory available.

After further discussion, we realized that min_unmapped_pages and min_slab_pages 
may not be used correctly. Apart from the issue above, there are other problems 
as mentioned by Barry in [2]:

Even when page cache is below min_unmapped_pages, it may still be reclaimed as 
long as slab is sufficient. Similarly, slab may still be reclaimed even when it 
is below min_slab_pages.

node_reclaim() cannot reclaim anonymous pages if both page cache and slab are 
below their respective thresholds, even when there is plenty of anonymous memory 
available.

To address these issues, I am sending this series to facilitate discussion. Your 
feedback would be greatly appreciated.

[2] 
https://lore.kernel.org/linux-mm/CAGsJ_4xCi1TzV0sg=8ZFhfAq7v=k=Q6a10DNDouYOrjcJL-5=A@mail.gmail.com/

>> Tested on QEMU (x86_64, 2 NUMA nodes), A/B kernels differing only in this
>> series.
>>
>> Proactive reclaim (echo to node/reclaim) on an anon-heavy node, file and
>> slab under their limits:
>>
>>    metric              before   after
>>    -----------------   ------   -----------
>>    pages reclaimed     0 MiB    254 MiB anon
>>    return value        -EAGAIN  0
>>
>> Node reclaim (zone_reclaim_mode) with one type under its limit -- the type
>> under its limit must be left alone:
>>
>>    type under limit    before          after
>>    -----------------   -------------   --------
>>    slab                645 scans       0 scans
>>    page cache          83 MiB scanned  0 MiB
>>
>> [1] https://sashiko.dev/#/patchset/20260723045718.2052070-1-ridong.chen@linux.dev
>>
>> Ridong Chen (4):
>>    mm/vmscan: only reclaim slab in node reclaim when over min_slab_pages
>>    mm/vmscan: only reclaim file pages in node reclaim when over
>>      min_unmapped_pages
>>    mm/vmscan: drop the combined limit gate in __node_reclaim()
>>    mm/vmscan: do not skip node reclaim when only anon is reclaimable
>>
>>   mm/vmscan.c | 89 ++++++++++++++++++++++++++++++++++++++++-------------
>>   1 file changed, 67 insertions(+), 22 deletions(-)
>>
>> -- 
>> 2.34.1
> 

-- 
Best regards
Ridong


