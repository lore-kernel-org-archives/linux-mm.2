Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1461C5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 10:52:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC6776B009D; Fri, 21 Aug 2026 06:52:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B76976B009F; Fri, 21 Aug 2026 06:52:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A64FF6B00A0; Fri, 21 Aug 2026 06:52:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 81E846B009D
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 06:52:27 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 07B20140418
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:52:27 +0000 (UTC)
X-FDA: 85124962734.24.BBC2416
Received: from mta0.migadu.com (out-37.mta0.migadu.com [91.218.175.37])
	by imf24.hostedemail.com (Postfix) with ESMTP id C4797180009
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:52:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YnpO4Omu;
	spf=pass (imf24.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.37 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787309545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S+HfJeV+mmSguAe4TzM1n9NG4wd8dOLKFpN9m3PreTg=;
	b=wuEuujJtCVqxwkEuo3d+hRQv2jj1koo9TKeiT46pE/sfEgXFW337QrIxzFYKoIEg8TFb3f
	696NYHb8QbWkQWyRRobOrjcMvF+hRIV3F/HdMgqIBTlI2wiP5+TLe077TpucIv2brI2StN
	a5p4QDgm8MO3AjPj5YaNgZzcw28Gdzo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YnpO4Omu;
	spf=pass (imf24.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.37 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787309545;
	b=f3O0gk8NCXNwuTMfK2B7ekpPKmVqL5e3uQ99BB2ufcRep/SJPeX3KoaZl63yvs+Dvktv4Z
	1IA2ekRn3S7cJCvliOHRdP6M1GH16/ZOXCNLgAFYA3Vke8RLMTgINU1NV98XfnCtVAxMCN
	y46itVT9V7hJdrCZ1YVNUbxCCmTlBUM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=OJ4pxc/BY65f+YEdniNKvlySGT/ge79fTwWc2GA2zdM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787309543; v=1; x=1787914343;
 b=YnpO4OmuH0tFHOshJVDhjjNyRj1oLTMLHtrVvOOxQt43gYQXbtZEBCnXZc+y4Wi5KWW0E6sU
 5QRqTMt/enjXvh0w7ubtwPuNLbknDLwpRuEecmsbo5ruLE2oKIHKwTjLoTwvsoEtRmwWuea0N6d
 ZSkZCcdPPz9LOFSkYCEYF2fM=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.63.107.123] (14.29.108.92)
	by smtp.migadu.com with ESMTPS id 926e7f4a7c17a838;
	Fri, 21 Aug 2026 10:52:23 +0000
X-Mizu-Trace-ID: 926e7f4a7c17a838
X-Migadu-Flow: FLOW_OUT
Message-ID: <bc9c3de9-17b9-4ba1-8065-3270bb455630@linux.dev>
Date: Fri, 21 Aug 2026 18:52:12 +0800
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
 <aogMyu5R_DZRqp2J@tiehlicka> <f45848da-9569-453f-b0c0-8aa984e1976d@linux.dev>
 <aogZZsXwCyOXISaw@tiehlicka>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <aogZZsXwCyOXISaw@tiehlicka>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C4797180009
X-Stat-Signature: nw1gcpq39nbu14x3xc51ius5dhrtua9j
X-Rspam-User: 
X-HE-Tag: 1787309544-655263
X-HE-Meta: U2FsdGVkX1/LKlCXIFEpEPe82OUUyqgH7n1VjSzMHKp3wSy4cZe7L0azrEzrtwqJ+ZG0DZisZnjfl1ouRghKbUU2lzwBgBc+cFv6mS0DjBOjT0+mvzARIT2CihwtIQ66O4FL8lWqRbp/SVklUe6YULkyc+rACEt3ammpU2gX6u1HcPi9VjTbw5hlvAlCvysURy4jEEhxae6PCPEMYgJ/DJjxVSEKr0O0z0s5JNxbIdpQsFXakiAtrRBfJN0BrnaxJCcGVg55xInYiJTfRd5q2m5yHrVVvRkumacD/dqbKA/0SL5fNgxRGjb0ztHhMKxB7NvPuspq033OWfW618qykhEmn9VgUQY6yBVCyOmKqRfgB6++f/ZC1xPcmWxYpPCJc9Cdf3zHa6DhuG/hSOjWCnaivp2A8M8lq+v4iKKFVMl7pn7xlorCR0OX7zCCvYdnzTEOR5tZYnZpYsu/8XjtwEhp9ZiYejMARhsGEcJ+sPLBryhgl8OicX166jyMRyDBGvjXN9fpanxs3T01zlHWHeuw+CRlANEAgXnn6OhrI+/w6j7/WSajoZMuEe0cvcAvFTED83XfbFlmP72eSDE2pxX/hlJlxRwuj6o4+FHlh3L/tRknLL8DiBZZswnI6aHHjq86u3PVAU3O6T7etJEJ7b1J+GCzXd9E82qG9sSAhPgg9MTgTozypVvP/VmQX2YAb+2TkN1zMVdidvNAia5nRySAIH2gvarPo8eV2MQbnn8KzgTXTPfemO8LjetV4haSsEPh7Xr9XbfEwhbA0/ZX5N0Witc0b8kZpF9NJZIyEycRLImIcZBYo/Ny01KzlnbNL+CU/t85YKVS+DbtMBvRSqfW7A/6GF+mqNVc5+Q/0h7wiz2+ZOPpklX3D1IJxQKI72dEm6Xuf75CHPc72G/NHX22EAEU0vBvYvGUQIz+ZhlBktBqwYyWGYKYO3/qMWvAU+2ocMTYTQFillR1MGm
 eVffcHg4
 peDPo1XvJSjnYqxq7zSdIWj7pkfrfxtXlypNUHroVF6/NrsRTOeuHbU4neb6NYJfAPGZTfNgYGNGEvvPv1owku77FvxfmGRWweDwOxXmBCemEOucSMDRr6AfTw4eeBrBUQzbgkN6AEN4WwBNIB9BQm0MMhODCePFsJofDmDfS1klB7IVEX33cmO0bnRw0DLxbbTTcMoCOA2v5TixwspzsDwFB0mD5Mn2wFYROZhs6PD+AVwo2+gDnMUeY+IieYVIPq8xL052bBrqzDBX+d2jlbp1YPuSQeb9KBDwJzifZixakSAJH4XunwMgMgIyh6KLpwmp8FrK7TI2TRuSBKrrvQOL+cg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/21/2026 5:24 PM, Michal Hocko wrote:
> On Fri 21-08-26 17:07:32, Ridong Chen wrote:
>>
>>
>> On 8/21/2026 4:31 PM, Michal Hocko wrote:
>>> On Fri 21-08-26 16:17:37, Ridong Chen wrote:
>>>> From: Ridong Chen <chenridong@xiaomi.com>
>>>>
>>>> min_unmapped_pages and min_slab_pages are documented as per-type limits,
>>>> but node reclaim treats them as one combined gate: once either is
>>>> exceeded, shrink_node() reclaims slab, file and anon together and pushes
>>>> the other type below its limit. Per-node proactive reclaim reuses the
>>>> same gate and fares worse -- with page cache and slab both under their
>>>> limits it reclaims nothing and returns -EAGAIN on an anon-heavy node [1].
>>>>
>>>> This series gates each type separately via two scan_control flags
>>>> (skip_slab_reclaim, skip_file_reclaim) set only on the node reclaim path,
>>>> drops the combined gate, and extends node_reclaim()'s early bail to check
>>>> anon. The flags default to zero, so kswapd, direct, memcg and drop_caches
>>>> are unaffected.
>>>
>>> You are explaining what but missing the most important part _Why_ do we
>>> need to have this addressed? Is this just addressing Sashiko review
>>> refernced below? Is there any real usecase where the current behavior
>>> matters?
>>>
>>
>> Hi Michal,
>>
>> Thank you for your reply. I should have made the background much clearer.
>>
>> Yes, the original issue comes from Sashiko's review. Sashiko found that
>> proactive reclaim fails to reclaim memory when the node's unmapped file or
>> slab pages are below the minimum thresholds, even though there is plenty of
>> anonymous memory available.
>>
>> After further discussion, we realized that min_unmapped_pages and
>> min_slab_pages may not be used correctly. Apart from the issue above, there
>> are other problems as mentioned by Barry in [2]:
>>
>> Even when page cache is below min_unmapped_pages, it may still be reclaimed
>> as long as slab is sufficient. Similarly, slab may still be reclaimed even
>> when it is below min_slab_pages.
>>
>> node_reclaim() cannot reclaim anonymous pages if both page cache and slab
>> are below their respective thresholds, even when there is plenty of
>> anonymous memory available.
>>
>> To address these issues, I am sending this series to facilitate discussion.
>> Your feedback would be greatly appreciated.
> 
> Those interfaces are relicts from the distant past same as the node
> reclaim. I wouldn't bother fixing those unless there is a real usecase.
> Pro-active per node reclaim is a different thing and we should probably
> divorce it from those min_$foo counters altogether (if they are not
> yet).
> 

Yeah, proactive per-node reclaim currently does not divorce from those min_$foo 
counters.

Did you mean that min_slab_pages and min_unmapped_pages should influence 
proactive per-node reclaim? If so, perhaps the easiest fix would be something 
like this:

```
static unsigned long __node_reclaim(struct pglist_data *pgdat,
				    unsigned long nr_pages,
				    struct scan_control *sc)
{
...
if (sc->proactive ||
     node_pagecache_reclaimable(pgdat) > pgdat->min_unmapped_pages ||
     node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) > pgdat->min_slab_pages) {
	do {
			shrink_node(pgdat, sc);
	} while (sc->nr_reclaimed < nr_pages && --sc->priority >= 0);
}
...
}
```

> Same as checkpatch.pl, shashiko is giving you hints and you shouldn't
> simply follow them without a deeper considerations. Consider that there
> is review capacity required for any patch posted. We do not want to
> waste that scarce resource.
> 

You are right. I should be more considerate. Sometimes, due to my lack of 
experience, I cannot come up with a good solution on my own, so I send RFCs to 
gather professional opinions. Thank you for your time and guidance.

-- 
Best regards
Ridong


