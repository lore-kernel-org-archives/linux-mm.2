Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2426BCD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 09:02:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C18B6B0095; Tue, 12 May 2026 05:02:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 899CB6B0096; Tue, 12 May 2026 05:02:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D64B6B0098; Tue, 12 May 2026 05:02:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6C0266B0095
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:02:38 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 14953A03CF
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:02:38 +0000 (UTC)
X-FDA: 84758177196.12.941B508
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf07.hostedemail.com (Postfix) with ESMTP id B68AB4000E
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:02:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=JgHW3Z30;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778576556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+cyTZjQS6UqdXmYhbAizO7A1hVVtxlnJezCg5zZ803w=;
	b=Zg9H0XLZ9m5XUThYt3NFeKf8ajWjQJow14+FEVDWJAGn9bdVwmXZoNFtebpDA8otFD236w
	nAdKtnNlT0V8ntO1zkpyai6gk2iOmAZqc1npbSoyCr5mwoEpLQ0SXtJJXnrvuw8JoTq/r0
	U3+k6XWnXjy3atjYsPOJMICyZVkn108=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=JgHW3Z30;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778576556; a=rsa-sha256;
	cv=none;
	b=Tbdm+KEK+XQwkPTCRSTqrzxMpX3ORpVY7/gPpF2xZM5QdtneTapGS7wn5XjSBOu0SMgcCy
	r0yM9gmcQqkp+HoQbMm6g3e8emrowPS7R5yr3CCofi4hi4jA3rXBk1Wfjea54F8LPf3tds
	8u9zBNrGJy90ntacbCVLTzcMzn5TL6g=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778576550; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=+cyTZjQS6UqdXmYhbAizO7A1hVVtxlnJezCg5zZ803w=;
	b=JgHW3Z30lSDZbH0ulRwnZEoy1YJYvKEvCmQF7EGnYYCczt+Sj8fJ/wNW6qrko7jXjKFRfhd56aolAmZUVQVkRZNqfcDerIGnsF7strp4OQJeIDOtsQaLfJIGP4yj33fdO1eymKceHKCpu3cBRnZa7iDN3hAX1c2Czc58WAyV6Wg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=28;SR=0;TI=SMTPD_---0X2q-o6n_1778576545;
Received: from 30.74.144.137(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X2q-o6n_1778576545 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 12 May 2026 17:02:28 +0800
Message-ID: <a4c22e4c-5669-4323-8229-1da261e9c72f@linux.alibaba.com>
Date: Tue, 12 May 2026 17:02:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/12] mm/huge_memory: move THP gfp limit helper into
 header
To: Zi Yan <ziy@nvidia.com>, Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Barry Song <baohua@kernel.org>,
 Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Youngjun Park <youngjun.park@lge.com>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Yosry Ahmed <yosry@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Michal Hocko <mhocko@suse.com>,
 Michal Hocko <mhocko@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Axel Rasmussen <axelrasmussen@google.com>
References: <20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com>
 <20260421-swap-table-p4-v3-3-2f23759a76bc@tencent.com>
 <D631DCC9-85F0-4E68-88A0-AD5DE328818E@nvidia.com>
 <CAMgjq7BDmGWaVWBL+52_c=jgs293bgB+Qe-MafKE7dWZRsmx9A@mail.gmail.com>
 <125AABD0-02D5-4656-9F55-4B5BFBD5BD3D@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <125AABD0-02D5-4656-9F55-4B5BFBD5BD3D@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: owpy1xynaypzka6ut4ykmc9mxaueus5x
X-Rspamd-Queue-Id: B68AB4000E
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778576554-91981
X-HE-Meta: U2FsdGVkX18pdJvWb9T4cqSTGeuTJ4rqWPcshOsDioTs2YZ7Pk3ooV2bidK5EBoAYApbNH3xt3NEpPegZPJAHWFp4k9ORQYqNvqmUBAgSfTQuDRZWeD48ib5G5lagF0HYoEKrX3QQXylCMaALBn2ttUcgouilKVZlzlCjnT8Ed5Gc+6xgIuQdnH7FumKBIIQCslZXJHNISfxB/+ISnBD665ipnRr9qvVZ+sfg+uP0svqwqRwuJpdvDEAU3JMwmcn2CcOGl1Kv6smFz/zu03i7uvZnSrNsv3jrOvHrGA3RjBagxeS6VIOMkMk8q+jFm9XEeUJWOfKOnvdim0SL9bMA7ihjvIOd6qZvcWf/PgjQHIrsYSSbD/QqOWVOjpbcuIBJt6ULOxgd7hPKVRWwkN2PRJwHusG3NnDila+U/Zrz/nZcbYoRVVJG0RXFE0L+irr6iQGSjkrZNJZq9UCpmAicvXFf0OG3J898jQ3tkLQgEK96RIryNz24cojwhw2NuDrM47eY9Jza0IDqeg7crMfKkqrbu7JECSpXnbCqeLzz1IBVnxl19pJdJ6D8qckdH0LiQsmmSOZkOLl+Gqp//mRkAXPWQMUjxtl6nChYYRhDqEbUQhlVIHBjrnxLmLeLn+rTGfIKCN7yR4NoBFjMWW2AeU23jq8fTPOIkyum/fe/uA/J6S0aOHVBeR4+DQcsZOBx415vPJ2p6ZwqASLULpwYyGWXPRWzMzggrjyxbVSKX5tR7pM8D/fE+Npud83XWsE3Qg/0VXdRWZm3lC/sUhyO4wJheezEvbLgwgZY812gqKzyS2jmE9VMsGTHGKXiwt+Ost9g63c7f6DXDnmO81hZ5AyfkNWaXBsV3v3VJ2WehA2GFxQAhBAivkcjik5bBNRPHJ5oXZm62zI1/+hXzrkGCKo3mbvZt3Q09C4+z6xDIUfgjbd+17ikIggR2DTDQZ5o/Lw+e/aSHIWoYWXenG
 D9es1tav
 NoBaUcoKtrNN7qxeeYzURdcjgWGVPfP3K78YDjozg4vKJMGOBVucS4XoEW+Mz1sm7rNt1ouvjTXiKCCg0sMWVx73kuT5scvk6LV1JktkJAMYviexGiFlEpIOAa2i2U/3LUUqImmUjFNg3OVG0S/4XvgVxkxbF9w6Xe6LkJwFpz9r5ph9MrL5didfYn9j4f79i0BS0XuL36qsoYTM0eMGv+49HPot4hmofYlQ1aM66LDPoPkOboVkaK78kUxYoKqdK/lYpcS9e6FjLzYDfNBRvF9TBCfwWQU7WdnDXbV3olX+CXLPr8So2uBjAaEBOw2nS52iFhxKpLYSKs0o+BHq+erbKWPIQT3gLqhhbUjjj5s+eb8Tqwtu2dMaJ8AV1wIwi74L8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/22/26 1:23 AM, Zi Yan wrote:
> On 21 Apr 2026, at 13:21, Kairui Song wrote:
> 
>> On Tue, Apr 21, 2026 at 9:14 PM Zi Yan <ziy@nvidia.com> wrote:
>>>
>>> On 21 Apr 2026, at 2:16, Kairui Song via B4 Relay wrote:
>>>
>>>> From: Kairui Song <kasong@tencent.com>
>>>>
>>>> Shmem has some special requirements for THP GFP and has to limit it in
>>>> certain zones or provide a more lenient fallback.
>>>>
>>>> We'll use this helper for generic swap THP allocation, which needs to
>>>> support shmem. For a typical GFP_HIGHUSER_MOVABLE swap-in, this helper
>>>> is basically a no-op. But it's necessary for certain shmem users, mostly
>>>> drivers.
>>>>
>>>> No feature change.
>>>>
>>>> Signed-off-by: Kairui Song <kasong@tencent.com>
>>>> ---
>>>>   include/linux/huge_mm.h | 30 ++++++++++++++++++++++++++++++
>>>>   mm/shmem.c              | 30 +++---------------------------
>>>>   2 files changed, 33 insertions(+), 27 deletions(-)
>>>>
>>>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>>>> index 2949e5acff35..ffe5a120eee4 100644
>>>> --- a/include/linux/huge_mm.h
>>>> +++ b/include/linux/huge_mm.h
>>>> @@ -237,6 +237,31 @@ static inline bool thp_vma_suitable_order(struct vm_area_struct *vma,
>>>>        return true;
>>>>   }
>>>>
>>>> +/*
>>>> + * Make sure huge_gfp is always more limited than limit_gfp.
>>>> + * Some shmem users want THP allocation to be done less aggressively
>>>> + * and only in certain zone.
>>>> + */
>>>> +static inline gfp_t thp_limit_gfp_mask(gfp_t huge_gfp, gfp_t limit_gfp)
>>>
>>> Would it be better to rename it to thp_swap_limit_gfp_mask() or something
>>> more descriptive? I am just worried about misuses in the future due to
>>> the generic thp prefix.
>>
>> Good idea, I wasn't sure if this might be helpful for any other user,
>> but for now naming it more descriptive does help to avoid misuse.
>>
>> How about thp_shmem_limit_gfp_mask? Ordinary swap is fine with thp
>> gfp, only shmem is a bit special.
>>
> 
> Sounds good to me. Thanks.

Sounds good to me too. Feel free to add:
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

