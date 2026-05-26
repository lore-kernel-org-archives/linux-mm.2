Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B313DCD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 08:35:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEAC26B0088; Tue, 26 May 2026 04:35:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9BB46B008A; Tue, 26 May 2026 04:35:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8A4B6B008C; Tue, 26 May 2026 04:35:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B4BF76B0088
	for <linux-mm@kvack.org>; Tue, 26 May 2026 04:35:30 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4ECE5A0320
	for <linux-mm@kvack.org>; Tue, 26 May 2026 08:35:30 +0000 (UTC)
X-FDA: 84808912020.02.BB10ADE
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
	by imf01.hostedemail.com (Postfix) with ESMTP id 32C6E4000D
	for <linux-mm@kvack.org>; Tue, 26 May 2026 08:35:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	spf=pass (imf01.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.200 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779784528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f+HL4z7GpzfkFjsV6bRVZYSsmIvQMkleGqL1J3UAMV0=;
	b=8Q/B+q07e9qL/CR6NS92CADU4wvNm8ijK3pIDZDmY0G3RrKR5n3DXKIArmuxzXbTG9tuiK
	KMNpHbEF1r8mHiMkZkNebXOtu3yykf8l9Hz5jknTJKb/v71aY6SgEMD6SQDsXwiGPDpQe9
	U5bd0/1A0/UuTmZlERGPpEDCZSZ0GgM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.200 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779784528; a=rsa-sha256;
	cv=none;
	b=3+h3MrtfnNC9AmLqq5E+VphykOs7IRRJLDrcPCKcLO0muBgLUWyj66CArEgr+AGjwIxRxB
	3iOYQxh6S6f5mqtDOBmNJXFg8hOvdpAohhexvHaugpaNSsZXnLIkKZ9W9q/+DQBdz6OnRW
	Usfq5RBitDy2b1moq64XpGmjEjHRWJ0=
Received: by mail.gandi.net (Postfix) with ESMTPSA id 27FBC3EBB8;
	Tue, 26 May 2026 08:35:19 +0000 (UTC)
Message-ID: <f8f08e5a-9801-45ff-9350-c3c88599f19c@ghiti.fr>
Date: Tue, 26 May 2026 10:35:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/8] mm: percpu: charge obj_exts allocation with
 __GFP_ACCOUNT
From: Alexandre Ghiti <alex@ghiti.fr>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Vlastimil Babka <vbabka@kernel.org>, Yosry Ahmed <yosry@kernel.org>,
 Nhat Pham <nphamcs@gmail.com>, Sergey Senozhatsky
 <senozhatsky@chromium.org>, Chengming Zhou <chengming.zhou@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Minchan Kim <minchan@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Barry Song <baohua@kernel.org>,
 Kairui Song <kasong@tencent.com>, Wei Xu <weixugc@google.com>,
 Yuanchu Xie <yuanchu@google.com>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260511202136.330358-1-alex@ghiti.fr>
 <20260511202136.330358-3-alex@ghiti.fr> <ag8-Dfoco9qQho0A@linux.dev>
 <b434907e-2036-4260-bced-1adb8e26c917@ghiti.fr>
Content-Language: en-US
In-Reply-To: <b434907e-2036-4260-bced-1adb8e26c917@ghiti.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Score: -100
X-GND-Cause: dmFkZTGmR5l3NgefEEZKglBnN+xbss2Eg7C7+y8areTebhSg75VGARYPK55R/h8z5vFFlLxQ+dw7qv2FJH1yCZG1eT0B1VzEgTt/oWrGhWSdbPA1FW0WEBMXpG4nHR2vym1CVm7D+bP5FCLFcomV7E3Gvf/K6yKAn/wFqT3iUtr9forSTflY/FSXK73qUhYeQZp5pHi7+cFZSB4p/je+OScL5Z2JUyUKehjwwjV9ppsRgFDvRZGVk+aIgpRpW1WGvYUbMTDGVt16T1X9EgxSbeL2nIAGn3CANu4iqqbSklKhTHEnlz+GA8OG2vO2I+RWak6IX5w5ogaQravzQrguM4zr2aRTRcmryhskQuotCwDl6/3ePVr4KecI4Au6Fz1m+1XlurH1JmXn0IwHeHcLcH1b7dwlmzR8o2pHsX3MDqNB+PRt/zzP9jmJy3+nDE62LdGrlm8MNU69BKYByNYFy5qsTalUDY1dTCPnk1P7uuuiayYPGj2PII20ytH2BUWGUTlDd1kaAWt0hBX1PXob6aGHe2DEZKS76RMSkPcYcTAeqUXal/s22eltdGs9LKQK3zz6+/aTWM8C20iaCGKZH/Bad1Zfp5EPf8H3V3qLOZ01j0NAtYYN8yIKgbW3j7oaa2kUM3rzCg52nuLECvgIu0Bk9KjvaBUIPiQwwjIyJixgpVljuw
X-GND-State: clean
X-Stat-Signature: kqye5wa6py4phx531de9bqs3b1ad6j7p
X-Rspamd-Queue-Id: 32C6E4000D
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779784527-667348
X-HE-Meta: U2FsdGVkX1/PcuRWcQrbWhcS7l1HT2ttt+aR4gJXVs9U+6CfhjItJcDyI4R89D/3RXbdokPnFLiCMRnRbSUtF0LDIVhY0NeW3f5DblrLMu9I5B5yFwg/c3gxXW1ilyP+Kh69xPGCqmdraH+6izhBN1nwuYGGmiFUbPM/abwxblJCy1plnnTGlxZSOSvN4foEs1miJjZDWW2mcM90BfNr9R4l2a09bbFODylW6lIsPViCnmIkQ0s9B8/BhI14jLuNIZR2TgSVRUR4MKQWYuRALoZhmkSED/uBkZs7LTCcLX3SbMG2M4jljzyWZd3k1mxwMu4L5yKCM7H322Wv4epw3DKqrH7vQIAjJWG5g7GAYVfibyBv8oDx/iFneDIfqW0Zn2oeB01KXNop/n53N4Tendurq3q7DEOc+ceyJ8jzO9EE8v5HhsgoiZpxF0EvNzFQVqg8yay2o1jHdY/De3lJ0je24ua6vCx8z9T5B8MdoE05EMK8cTH6UnVxS+ak6rJo/tu1+cZypsFZ5URSHFRAXTcRb/X0m8wLLqXuHdtDIQHdInrHx8ylj+hPiNt6wmyay5proe+o2vnacIOMI8D6EYNvxdyC0WiU36O5o+8TsFQI8zT9Lx5YtSofWRFtug8a/zNmgrdYW/CoPne/J5b+OqzJsDGPTP5TAVJqSJVmUqaRGhPZdAPvNR6VcFv5K5R3qHf/sUnFHDjvA0AkhoTBI7HShjPFHdMtXcAOd2RsR1cfUvWDTator1qQDIfO1LJN+8EJhshEKciNNsu8icOtBVttSgCgtb0SEhtryn7DFT0S9/eoSsb8PYF429ZCM2wYOeAet+48DEzwAMQsHUIrtxv2lTysWQFy915NhH+h1ufcr8PFzFlSGH4ZIxqswF0mN6VIVsAVwMYrYdxCF/k9ILDaX65z2aMpOMABQ03Yp6xWheC3Ye2bxWkoCN3VQ2x99FHKrFfggsJ2OHbwI3R
 Wro2cL2G
 bG7QE+y8tgB4ROFE3JeB7hb6s8tbkbNsVSZGTwTBvwsy0z01MPgGWgiHGipNEooUuCXIbs/T8ND5pE1LITpRqEtaq2Twkd7nIX9N9mG/VbB+wUApnL5US7OtAYVXyqG1/qOo/LAMNeedIfFcmtTp1h1G+HYx3h09/nKpumjMMgP4yEPm3m4tTuMC/wmhAHqqC7u9AdNNdYsDN7qKIX30PENPOW94nFA9BO5vE2vELFdkmQFH/xRcXa1uNFNWz905OZs5T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 5/22/26 10:11, Alexandre Ghiti wrote:
> Hi Shakeel,
>
> On 5/21/26 19:25, Shakeel Butt wrote:
>> On Mon, May 11, 2026 at 10:20:37PM +0200, Alexandre Ghiti wrote:
>>> This is a preparatory patch for upcoming per-memcg-per-node kmem
>>> accounting.
>>>
>>> pcpu allocations are always fully charged at once using
>>> pcpu_obj_full_size(), which returns the size of the pcpu "metadata" +
>>> pcpu "payload". But metadata and payload may not be allocated on the
>>> same numa node, so charge the metadata independently from the payload.
>>>
>>> Do this by explicitly passing __GFP_ACCOUNT to the obj_exts allocation
>>> and remove its accounting in pcpu_memcg_pre_alloc_hook().
>> Will all the entries in obj_exts array be for the same memcg? If not 
>> then why we
>> are charging the whole array to the one which happen to allocate the 
>> array?
>
>
> Hmm, I overlooked the amount allocated, so that's my mistake: the 
> chunk-allocating-memcg will be charged for all the metadata, although 
> before the charge was distributed. And according to Claude, the 
> metadata would represent 64kB, so not negligible.
>

I realize that I did not mention my setup: I have been testing this 
series on a 176 core machine, and the 64KB that Claude gave me was based 
on a 32K unit_size. But actually it's not right. Here is my understanding:

- unit_size is 512K on this machine, which means that each cpu gets a 
region this size every time a new chunk is allocated => 176 * 512 = 88MB 
per chunk

- obj_exts = unit_size / PCPU_MIN_ALLOC_SIZE * sizeof(pcpuobj_ext) = 
512K * 2  = 1MB (obj_exts is one memcg pointer for each 4B)

Let me know what you think, but I don't think that's acceptable, I'm 
looking into another solution.

Thanks

Alex


>
>>
>> Sorry I don't know the details of percpu allocator, so asking some dumb
>> questions:
>>
>> 1. Does the alloc_percpu() (& similar functions) allocate the 
>> underlying on a
>>     single node or does it allocate memory for each cpu on their 
>> local node?
>>     For slub, it is on the same node, so the situation is easier to 
>> handle.
>
>
> To me, chunk metadata and actual pages are allocated differently:
>
> - pcpu_alloc_pages() tries to allocate the pages on the cpu local node 
> https://elixir.bootlin.com/linux/v7.0.9/source/mm/percpu-vm.c#L95. But 
> to me no guarantee it won't fallback to any other node. And I don't 
> think that __GFP_THISNODE would be a good idea here.
>
> - pcpu_alloc_chunk() uses kmalloc or vmalloc depending on the size, so 
> not attached to specific node, that's why I wanted GFP_ACCOUNT to do 
> the job for us in the first place.
>
>
>>
>> 2. On a typical system how much memory is consumed by obj_exts for 
>> the percpu
>>     allocator chunks? I am wondering if we don't charge it, how much 
>> will we
>>     loose?
>
>
> So according to my previous answer, 64kB. I have just noticed that a 
> bunch of dynamically allocated chunk fields are not accounted either, 
> which again according to Claude represent 2.3kB. I don't have much 
> experience in accounting but that's far from negligible right? Which 
> amount are we keen to lose to make the code simpler (or for other 
> reasons)?
>
>
>>
>> 3. What would be side effect on assuming that obj_exts is on the same 
>> node as
>>     the given chunk?
>
>
> Given the size of obj_exts, overcharging one node while undercharging 
> others?
>
> To conclude, you're right, I did not dive deep enough into the 
> metadata sizes, I'll fix that.
>
> Thanks,
>
> Alex
>

