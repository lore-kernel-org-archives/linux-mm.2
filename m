Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75C6ACA1016
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 01:18:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDE108E0008; Mon,  8 Sep 2025 21:18:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8E9F8E0002; Mon,  8 Sep 2025 21:18:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B56088E0008; Mon,  8 Sep 2025 21:18:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9F5DF8E0002
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 21:18:51 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6ECBBB7FAB
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 01:18:51 +0000 (UTC)
X-FDA: 83867952462.21.2BAC3DD
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6D57A1C0004
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 01:18:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Ox6dc2GX;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757380729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BCOMaIA3bRDs5y9C8OpoEHGFUb9T7qWgqZAgYrwfhIo=;
	b=Ue5TWWG5cDPi6kBGwvJrmsl4S1fomY/Y1Y5E0enr9Rd8/gulirtWIXMbjxpUe6GMTEMd0T
	aTey/bCu0VBxuRB/Qis0HPSnbqHheMEg5BT/EgGdkmS913PxPRcoamD/3ZIAoaVgu9RO9H
	lRFtEDsGFDP9kfS46+hMQiEYL1LhXmA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Ox6dc2GX;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757380729; a=rsa-sha256;
	cv=none;
	b=U5i5VV0hE22wST8mXZqDu6iWRS/B3OYhK8APg9gUuMCGtCIZrXsB4xBanDwK7JRRlpl1od
	4mB43Pq4kq/nKuDrEWlkh0EysHEkm1qEd5rZyMHpZYG5AY67yBzc5lFlqnd4dVsZQi7rU0
	Ng1dQ73MNRvjV7XsCCABfUZ4RbTJJ3Y=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1757380725; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=BCOMaIA3bRDs5y9C8OpoEHGFUb9T7qWgqZAgYrwfhIo=;
	b=Ox6dc2GXlsKo2AA2uBmPJq9/S45uRa+BuyTmvIcsejWtOevSLfatJ8ITFxKbBoyXK3uSJb0p8vRiW8H1HDJYFKa+8i52a81vH3W/sYrM/fpQ2cOWimJIVT83JZmVV2gcfLAoNH/X/2bK+oyMGFNQaVeoSzRPEiyEbwjwSdirHxA=
Received: from 30.74.144.127(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WnbpUQR_1757380722 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 09 Sep 2025 09:18:43 +0800
Message-ID: <8f4aa09b-f005-4def-baed-a905a99aa19f@linux.alibaba.com>
Date: Tue, 9 Sep 2025 09:18:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/15] mm, swap: wrap swap cache replacement with a
 helper
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>,
 Chris Li <chrisl@kernel.org>, Barry Song <baohua@kernel.org>,
 Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@redhat.com>,
 Yosry Ahmed <yosryahmed@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org
References: <20250905191357.78298-1-ryncsn@gmail.com>
 <20250905191357.78298-11-ryncsn@gmail.com>
 <f8051ae4-1b9d-42dc-8272-24a05741d86e@linux.alibaba.com>
 <CAMgjq7CQSGAhah8xwzJJUOLYEEQer63ZERsP6W-JVDCt4mSFMw@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAMgjq7CQSGAhah8xwzJJUOLYEEQer63ZERsP6W-JVDCt4mSFMw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ak5yic4eg7wb5m6croz5x7y8o65g4tpm
X-Rspam-User: 
X-Rspamd-Queue-Id: 6D57A1C0004
X-Rspamd-Server: rspam04
X-HE-Tag: 1757380728-231453
X-HE-Meta: U2FsdGVkX18bjyY8oC3+EoL+kezGNS7MjIF8R1hLiPufElItS2d9Wn/0fJk6ps7oHACkf4cRSu3ASCGQiUJJLdk4nAOJdsOnnD68k6uEuMZUR24rKiyR+HiSMOe5lHZuxIXFE9cFaPG1JHEw0ifDh3fERQ+OyDx8NfwBCkWmMqGS+pKsbnvyDH7bYCQsAW9IT3xJrpEAvaqVptDtCXhopa2mMUj7wVSDyKUzdV4EhXsa9XKCfxm+8s5xqWKqK73/JwbAC1rNlDyYfAlc5Hwfk3a93necdXaUDxG44xnpmUQRX1ZwUQLECo3+pzqTZUZxV4ZvrELz7bp1rOtCzwbhTogABHKlsvwg3vEFwB0ML5AdCgGCjQ1WkJsP3dQ0U6+cWSZSkbS6OcfnznFB1vYHe+xgM3eWCPDL1Lr6Z5GoKIcd2Egd9zm6zuFnVDjrShJqoQwTmTnwty2ShV8/ti0E8XACQOUW26ROcX8tRiAdM8ceE6F7hFCX6SdGHa1WgdDfScv6uCunqWhKt20OHiIKRlrjrqe5rjl20OjE/17wIwPAmZNZ/gt0MoEGYx7iz56Cc7rsofRNqdN0vYAhLoDswn6/X8jYckWEbSPrltf+KMq9JeuPlCP9WXlnlK7ruLnbhpcAEnSzTAHeW93XRZDRWiahK1l6UCKW72V5LKtyVeN8AAjJc28JV/A+/wLTyTMmxeEit2J7LQb8t0J0KHuPaclJynvQ7HqUyCm1Jv2tEBCYfd0720q7qa8D8k9MXvcX90Y4wLHatdGF215ec67QLeFQFLbXPAC0Qy/HisnP07944IikLibujohakN6NYVtITqbwe2Rk0jqHXFcyDPBZ7pP137VCp/PxImveYoukiEcYhvgtp6clT1Tlg8QrUQdKNeVdt3A+pAnhoYmC6V8c9Xrlm/mGh2VZEK1DaR4HxcHiHWW/ma1k0i81jQgMpj2XA76O9JKkukHrmKMvjw9
 kQyQae2r
 ngOe0dqmk/LDSKDOdXGPo2TTkLy7rcCZsqOM8qpAWFVjmNAHdw4DI+xxmWpPhct4DSJ8IAQUwiFtourgqcBNnRx+SI3MGm1HMLig/knoW9m+jwkebRXrX8sJOoXmMgz40Ih5m7JXRjliXc1+pQWJX8LLakJyJTqwfXPPn91TN61fuKF1Bsr8lduN8dmrwuTG9QpISg18cxKQpcpWp0IldHhnmbuL3+917O0gq58sJVYoTwvRdq1DfenoIsTIi9u+OaaR1OMG3/a/2RsxulTxlPrzxapMswO+jb4tkdbK0wcLfRo1vQ4VyXhn/Xg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/8 18:44, Kairui Song wrote:
> On Mon, Sep 8, 2025 at 11:52 AM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
>>
>>
>>
>> On 2025/9/6 03:13, Kairui Song wrote:
>>> From: Kairui Song <kasong@tencent.com>
>>>
>>> There are currently three swap cache users that are trying to replace an
>>> existing folio with a new one: huge memory splitting, migration, and
>>> shmem replacement. What they are doing is quite similar.
>>>
>>> Introduce a common helper for this. In later commits, they can be easily
>>> switched to use the swap table by updating this helper.
>>>
>>> The newly added helper also makes the swap cache API better defined, and
>>> debugging is easier.
>>>
>>> Signed-off-by: Kairui Song <kasong@tencent.com>
>>> ---
>>>    mm/huge_memory.c |  5 ++---
>>>    mm/migrate.c     | 11 +++--------
>>>    mm/shmem.c       | 10 ++--------
>>>    mm/swap.h        |  3 +++
>>>    mm/swap_state.c  | 32 ++++++++++++++++++++++++++++++++
>>>    5 files changed, 42 insertions(+), 19 deletions(-)
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 26cedfcd7418..a4d192c8d794 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -3798,9 +3798,8 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>>>                         * NOTE: shmem in swap cache is not supported yet.
>>>                         */
>>>                        if (swap_cache) {
>>> -                             __xa_store(&swap_cache->i_pages,
>>> -                                        swap_cache_index(new_folio->swap),
>>> -                                        new_folio, 0);
>>> +                             __swap_cache_replace_folio(swap_cache, new_folio->swap,
>>> +                                                        folio, new_folio);
>>>                                continue;
>>>                        }
>>
>> IIUC, it doesn't seem like a simple function replacement here. It
>> appears that the original code has a bug: if the 'new_folio' is a large
>> folio after split, we need to iterate over each swap entry of the large
>> swapcache folio and then restore the new 'new_folio'.
>>
> 
> That should be OK. We have a check in uniform_split_supported and
> non_uniform_split_supported that swapcache folio can only be splitted
> into order0. And it seems there is no support for splitting pure
> swapcache folio now.

Ah, yes. Better to mention that in the commit message, otherwise, it 
will make people (at least for me) doubt whether this is a 
non-functional change.

With David's comments addressed, feel free to add:
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

> Maybe we can try to enable and make use of higher order split
> after this series for swapcache. I just had a try to use some hackish
> code to split random folios in the swap cache to larger order, it seems
> fine after this series.


