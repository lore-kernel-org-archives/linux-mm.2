Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F487C5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 11:11:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 420706B00A0; Fri, 21 Aug 2026 07:11:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D6286B00A1; Fri, 21 Aug 2026 07:11:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C1E96B00A2; Fri, 21 Aug 2026 07:11:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 08FC36B00A0
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 07:11:08 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8FABEC03D1
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 11:11:07 +0000 (UTC)
X-FDA: 85125009774.14.9085D78
Received: from mta1.migadu.com (out-221.mta1.migadu.com [95.215.58.221])
	by imf28.hostedemail.com (Postfix) with ESMTP id F022AC0009
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 11:11:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PweMOWrt;
	spf=pass (imf28.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.221 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787310665;
	b=NYDSy2Hd7/ZdwpxgZjWmGQsopF7vBFBEH2yP+P1KvxZCu8BmK5wAi/1uya3n+cez2vPkMx
	GDN2Iqu0bZ2HmS2rZSWPtifDpBWom2+9GXoiXyvFo/3rle0wy5BtB1GjOfE1laIJzypY79
	frNLCrAzktBJHr/jLWgep0DGgy6b0DY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PweMOWrt;
	spf=pass (imf28.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.221 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787310665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j/25JLPoqdfVadeGTDdGMM8uezKGQJJiOnLkO2eIaF4=;
	b=OXRmrpiHoOxd0Hz3lsBxhS12MSp2KYB8p5GRL3YWo0hqVT8+//1DhAzR8VPRMQUvqm55QY
	y3dOkH3SXzAnvHfnctOYdwYOairK5dPpOIEDcTfUIA+avUhU6G2rPNJYR4Ae/yHeEaAAJ9
	8AdZ27utcNnRbiiKOXJBx3kHIA0p7tY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=mYT5UwAijBVrK97F80QgCk6yK1ol3oBU2yNff7Zom3U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787310660; v=1; x=1787915460;
 b=PweMOWrtxn5pcuHfwUDRwK7ciSTQW157JD3/teCOC00jUPbK89UwrQ3SIBfbamaKb6mw5pXs
 UrR82rsqipW2eXj8fvwLVdAAJZBkxngCScpCTD5Skv1iuv2zs7XlcuBKX/gFAp7lWsazCGorqO8
 ufe8+IT9R20Q2Kj4AWRFaeqQ=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.63.107.123] (14.29.108.92)
	by smtp.migadu.com with ESMTPS id 9025f6b9289340ee;
	Fri, 21 Aug 2026 11:10:50 +0000
X-Mizu-Trace-ID: 9025f6b9289340ee
X-Migadu-Flow: FLOW_OUT
Message-ID: <dba83897-9bbb-4a44-9021-8f938bb6a12f@linux.dev>
Date: Fri, 21 Aug 2026 19:10:45 +0800
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
 <aogZZsXwCyOXISaw@tiehlicka> <bc9c3de9-17b9-4ba1-8065-3270bb455630@linux.dev>
 <aogwUac-sjfcs7Vi@tiehlicka>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <aogwUac-sjfcs7Vi@tiehlicka>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: F022AC0009
X-Rspam-User: 
X-Stat-Signature: h1im1jmfkhyk6sz1cg9cuxsfufota5ws
X-Rspamd-Server: rspam06
X-HE-Tag: 1787310663-914480
X-HE-Meta: U2FsdGVkX183o8YttYpi0/kDJlO/VBptG4QXifpsme3ZezteBu6QYtAZkSZSYJv5rRTYRwhS+o4GrjilDG87PN1qJ+5Ew4lV8Dk4IStd5ft5jyhFtwIFNFWtMP4DKHv5J/6OFIpfticfikKaPlXMqBl4GTUpq+xcWiEUReu3l503zEf66vVmN53WHktSmaCfW92Va0SXW6sE70vY+4/iXQDp03uJV2eMW8YGGo/hdE3gtZu1yU43VNCj5SNZFvQU6QXnIpr7wCyxMROiZsbwVs+Qm+1mE/J3jDQiMH9fJYmTsOl04e/QluSprzaBcRldF54bskKMuHtNROH1luupiEU3PxF1QwLN4U8VBfUQwdGSWXnqY5ng16fJZdJxezDqNYN7bzT0XxhbzB29TQwG3oa26sdBEtDd+sETO8tKS4lZ2ymrhdaR7lJ2yyLUIL7sQr2EljXLRK/w5Ka4OhRLum+8WfRtpbPXHy3kSW3SV4h3FGRa9RdWjHmsS+EO/eSU/zcJLf/gYgppgomCCPqJq2aYrWAB7Hu7/W/qQnYFDtOrwRLWrMOAb1FwRWSTfQs6qN7nnHvCpl0GKVdQ+fBAAWjCqIxL7ZkXyChULCGyjxG9usVn1tTjUpe4kCr2qWrgeft8aSfLRHgIVsFWjNCacnPR2yg+vY0F/+omxu9jzpUB+8sPl0XlXBxgXPQCY8id6uBGkMcDP+lugAPqxkcxEjwB1UPPA/oLMB6JewcNPHrCCbaavD32yrAixK3HSxAbHggxCcXjuU6n6z8wKhWH7ksM+WYCndXfEnK8yROwI+VuBJh3A0PNesKOpkQPrjiQ8G18yqOPsO57um5lzKRtPOc13Nr8FwG9K6fbkmb8bXAmdgBupvcFGZhF6bhqoqWLHqfqizOgmnFPKG7XgggjTh9V5HuopPFCkZ/GlYQCGZVLsVDEtITGJLu4p7zqGmupnUliCkFbkCZ/C0cS3nY
 OTcmWGHV
 JOSUJ3NwZVXwzI6DI1SRxrkeW6lSUzFwMm2ggu8qy3zH4ghg86Avoqr6iSlx+hsfUnhe6W1LsGPkmH7O+3BvM6K07WsTSv3kR3qjIVymeOo47opLCTqUuMNn8LNUzLA8y3r9J71msr2p6+50m3Rx4I4nJD8jlDl/nKwj1OILYYShHpD5bIMudcZ2Z/AoFPZwbg7GapqHEigftzwi4Yv8HTTnrew9rD/wDoHz5b+V+qrMki4gWYiCcPlf6bbeJtGhwIR8WGltFVHMLJ1o2bIkIZC3gKOiCtfNwsVGWvqilfvnc8vk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/21/2026 7:02 PM, Michal Hocko wrote:
> On Fri 21-08-26 18:52:12, Ridong Chen wrote:
>>
>>
>> On 8/21/2026 5:24 PM, Michal Hocko wrote:
>>> On Fri 21-08-26 17:07:32, Ridong Chen wrote:
>>>>
>>>>
>>>> On 8/21/2026 4:31 PM, Michal Hocko wrote:
>>>>> On Fri 21-08-26 16:17:37, Ridong Chen wrote:
>>>>>> From: Ridong Chen <chenridong@xiaomi.com>
>>>>>>
>>>>>> min_unmapped_pages and min_slab_pages are documented as per-type limits,
>>>>>> but node reclaim treats them as one combined gate: once either is
>>>>>> exceeded, shrink_node() reclaims slab, file and anon together and pushes
>>>>>> the other type below its limit. Per-node proactive reclaim reuses the
>>>>>> same gate and fares worse -- with page cache and slab both under their
>>>>>> limits it reclaims nothing and returns -EAGAIN on an anon-heavy node [1].
>>>>>>
>>>>>> This series gates each type separately via two scan_control flags
>>>>>> (skip_slab_reclaim, skip_file_reclaim) set only on the node reclaim path,
>>>>>> drops the combined gate, and extends node_reclaim()'s early bail to check
>>>>>> anon. The flags default to zero, so kswapd, direct, memcg and drop_caches
>>>>>> are unaffected.
>>>>>
>>>>> You are explaining what but missing the most important part _Why_ do we
>>>>> need to have this addressed? Is this just addressing Sashiko review
>>>>> refernced below? Is there any real usecase where the current behavior
>>>>> matters?
>>>>>
>>>>
>>>> Hi Michal,
>>>>
>>>> Thank you for your reply. I should have made the background much clearer.
>>>>
>>>> Yes, the original issue comes from Sashiko's review. Sashiko found that
>>>> proactive reclaim fails to reclaim memory when the node's unmapped file or
>>>> slab pages are below the minimum thresholds, even though there is plenty of
>>>> anonymous memory available.
>>>>
>>>> After further discussion, we realized that min_unmapped_pages and
>>>> min_slab_pages may not be used correctly. Apart from the issue above, there
>>>> are other problems as mentioned by Barry in [2]:
>>>>
>>>> Even when page cache is below min_unmapped_pages, it may still be reclaimed
>>>> as long as slab is sufficient. Similarly, slab may still be reclaimed even
>>>> when it is below min_slab_pages.
>>>>
>>>> node_reclaim() cannot reclaim anonymous pages if both page cache and slab
>>>> are below their respective thresholds, even when there is plenty of
>>>> anonymous memory available.
>>>>
>>>> To address these issues, I am sending this series to facilitate discussion.
>>>> Your feedback would be greatly appreciated.
>>>
>>> Those interfaces are relicts from the distant past same as the node
>>> reclaim. I wouldn't bother fixing those unless there is a real usecase.
>>> Pro-active per node reclaim is a different thing and we should probably
>>> divorce it from those min_$foo counters altogether (if they are not
>>> yet).
>>>
>>
>> Yeah, proactive per-node reclaim currently does not divorce from those
>> min_$foo counters.
>>
>> Did you mean that min_slab_pages and min_unmapped_pages should influence
>> proactive per-node reclaim?
> 
> Nope, exactly opposite
> 

I would really appreciate it if you could clarify this further. Sorry, I'm not 
sure I fully understand what you meant.

-- 
Best regards
Ridong


