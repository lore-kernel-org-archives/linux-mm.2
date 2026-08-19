Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 961B3C5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 07:55:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D6616B0098; Wed, 19 Aug 2026 03:55:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7872A6B009B; Wed, 19 Aug 2026 03:55:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69C816B00A5; Wed, 19 Aug 2026 03:55:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EECF16B0098
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 03:55:26 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7B0E3160276
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 07:55:26 +0000 (UTC)
X-FDA: 85117259052.14.345EE4C
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9B6E6C0007
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 07:55:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="cw8D7L//";
	spf=pass (imf28.hostedemail.com: domain of xiqi2@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=xiqi2@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787126124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8lNMdlW0Nw6U6jz4ZvINzApTzItfPmk1qUKo/jVdrSU=;
	b=KSilM2k29musUJ5f456mWi/qLiDeklBfJWt0mas9DGE7hMIS5D1F7MMI9rlyG2VNSU+UE2
	PvWN41y1Pv1/1tycwgFu38fc2tSE3x6h3r7UzEmcyp45hVG0nIITYU2N6nNGutZNjSWx5q
	AHh39YYF9bwmw8s6gjnV751Mf/6M4oE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="cw8D7L//";
	spf=pass (imf28.hostedemail.com: domain of xiqi2@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=xiqi2@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787126124;
	b=0zxaxIpOds3ipnjvNegjW2x6YldeoF2buMXYYctXmN7njnT4jUB9Hd443VPZjmqsxe/Mz0
	q16DSxxhZ3se0uagtSVQ+5+n0Ayz4bWnldWf/NP5pUvtpZAAkkGIH2vu5AMwdIfIQ9tXgI
	k4I8SQbcxH1g0bViuBJoQX+nwXmDd8o=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=8lNMdlW0Nw6U6jz4ZvINzApTzItfPmk1qUKo/jVdrSU=;
	b=cw8D7L//tUx1Bzw65IYvCu3OHY9pN2GcdbUf9Wqd9JCppaldu1inmwMg59R6hLQqHoJOkVB4z
	4aa8dCm9mY2q0i2lCOYqv63PRRh0Qe69D3hsaoY9gzxcjjabUNV6ywl1SFjPbJTGNRZ2EDNYOLl
	qGITRrTHNMzhioXF0h3Asbo=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4hPz9x2vDVz12LHh;
	Wed, 19 Aug 2026 15:44:53 +0800 (CST)
Received: from kwepemo200010.china.huawei.com (unknown [7.202.195.178])
	by mail.maildlp.com (Postfix) with ESMTPS id 8744040537;
	Wed, 19 Aug 2026 15:55:14 +0800 (CST)
Received: from [10.174.178.56] (10.174.178.56) by
 kwepemo200010.china.huawei.com (7.202.195.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 19 Aug 2026 15:55:13 +0800
Message-ID: <ad225cf4-143e-4c6d-9fe9-8c6fe8c621a1@huawei.com>
Date: Wed, 19 Aug 2026 15:55:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_isolation: fix UBSAN shift-out-of-bounds warning
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
CC: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner
	<hannes@cmpxchg.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<sunnanyong@huawei.com>, <wangkefeng.wang@huawei.com>
References: <20260818112855.3831692-1-xiqi2@huawei.com>
 <DKSB5XV53PQN.2G3U9Z7HJFLNO@nvidia.com>
Content-Language: en-GB
From: Qi Xi <xiqi2@huawei.com>
In-Reply-To: <DKSB5XV53PQN.2G3U9Z7HJFLNO@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.56]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemo200010.china.huawei.com (7.202.195.178)
X-Stat-Signature: egf6nnzhpjngbtfssyihua8zd37qhz8f
X-Rspamd-Queue-Id: 9B6E6C0007
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787126122-986496
X-HE-Meta: U2FsdGVkX194OcbPjTaQ7tQ3VaoB2zCKdNwvAMDDKjG6s7DomK5tMtgK6nXF4rmxwdhKaUELEHAF0s3GjZj/USRzdlKFxMLFmaeL485vJ8ILeXwm6w7BhXcQXIv7/YX4O1cQ/WB8EXhVdwp3YC3FPzI5O0Zj2pvcNs7g1lodFT6+cGXu0RW1mRY7gdH06utrfj86nSAQgorOb82zlYp6H/rzsKL0UwohoAGYJiB4VT1vfukUK2UuS4vnBqHdU2p9dHZ+SxSrNU9nHvFRvGrQXjmS59Z+lzsNoJWSWV1sqFtyFNcENgCv+5pdC1Ii1db5aWSuCNPUjYLaPuev1Aia9xrH7ckVn1CDP/321cW69tngk9q+DK+T/Yb9oktYramItw8ZFVi/v3GnPLfw2ayzzsmJqMVs93Ko0QvLOe8pZlbeEnIMgfRxxbygpdtU4oPJPpCCsCsSep64ktcXuNGPh0pOR31sd9dn5zJfd9vzhyvPunz90yZHPh75GuzzEgdQb2jdAT78UFFobEKbwhHZazuz6kCkGCZ0yGtiQG6WqlB9DbNaaK9QLzpJ6DJtcFv+UezmlVsEd3RaMqCZ6EawmeOruQ7u4D4tdd86r/WECPIES51BuKH+1YoUQpe8oaJMhBjkbD5j0h2dgQ19yV4oT5QKhAaJM/vPjgU+vB0cV/pdvqkAFs0BC81CFHMGGrf9M8YmUGvtBdIHvZ+p4to3Y32ZdeAbh9np+iTMgixwWwOFlxJnemVIfpRwFW3lNw45du3CTc9bxAYq4jD0uUhst3tg2qD34hLkhz4D6elxRcDt6nYqG9/CJ2CiA/AJKpYyDBgIBv1bOvaZvom1rxTtAb4UgISqxFpPveUsaF0GAk6c89gE/KeJw7ecaQYfQPsUtYmJ5XNKF2ecmlYjgnYQtrXxyiBwoDO31XPdLezHY85WA4PuddjeeB8xT+b9H5NiHwRAnKTq5E6mF1hv8av
 VbekuxDw
 7HTuiReVyiMmaI/ey1EOdoTEfvBOLkLsW4b9MW8sOmkAcE2YYpGAg6Njt1RvYgTp0FSZybdAxRMKIaMEuKOvlMDiuhZODZI+hvBG0y3aRq88AcFNtDbySfVeDfM+WCiJcskiHAC6yR10snksEV+2mTOXl9k4Azzjbbe+8Lm3QoFtYwWjcpCzp7r+lJsONeGeg/YrRI4/9GgCzmR9/HSIF+q9zYeBSWbsvWSw81V7MoRiOoTRfMxi1to9GyqAD7V/8Gkqcl388inX0bVo/H9a7s2llVVQyB1Q8yrLllb4/h2hYTKa/3FP2KIoo7xsjdJuAHAhjl8SW+xhCN52rRLgE0GjcaWmfdsfdmkVXTstmqnlbGgxznzWzWzT2t+NtkxIGAR7dGG2E5Tay+pIPiYBXfnbNPaoZVHX1J+hIHoFJM0JrlZzS0SjF+tcSFWUXz1OXniqxGAkDWv4j07o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 19/08/2026 03:14, Zi Yan wrote:
> On Tue Aug 18, 2026 at 7:28 AM EDT, Qi Xi wrote:
>> A contig-range allocation racing with buddy allocation on the adjacent
>> pageblock can trigger:
>>
>>   UBSAN: shift-out-of-bounds in mm/page_isolation.c:393:15
>>   shift exponent -749042176 is negative
>>   Call trace:
>>    isolate_single_pageblock
>>    start_isolate_page_range
>>    alloc_contig_frozen_range_noprof
>>    alloc_contig_range_noprof
>>
>> isolate_single_pageblock() first calls set_migratetype_isolate() with
>> zone->lock held, which marks the pageblock MIGRATE_ISOLATE and moves any
>> free page straddling the boundary out of the way.  Once the lock is
>> dropped, it scans the MAX_ORDER_NR_PAGES-aligned window [start_pfn,
>> boundary_pfn) locklessly, only to skip the free pages already handled
>> above and to detect in-use pages straddling the boundary.  Since this
>> scan only reads page state to decide how far to skip and returns -EBUSY
>> on a straddling in-use page, it does not take the lock.
>>
>> The window also covers the adjacent pageblock, whose free pages stay on
>> the normal movable/CMA freelist and can be allocated concurrently.  So
>> after the scan observes PageBuddy(page), another CPU can allocate the
>> page, leaving a stale value in page->private that makes "1 << order" shift
>> out of range.
>>
>> Use buddy_order_unsafe() to read the order exactly once (READ_ONCE), and
>> guard the shift with an order <= MAX_PAGE_ORDER check so it is never
>> performed with a bogus value.
>>
>> Fixes: b2c9e2fbba32 ("mm: make alloc_contig_range work at pageblock granularity")
>> Signed-off-by: Qi Xi <xiqi2@huawei.com>
>> ---
>>   mm/page_isolation.c | 13 ++++++++-----
>>   1 file changed, 8 insertions(+), 5 deletions(-)
>>
> The fix makes sense to me.
> Please Cc stable for this. Thanks.
>
> Sashiko has two more concerns:
>
> 1. order can still be bogus even if it is within MAX_PAGE_ORDER.
>      a. it can trigger VM_WARN_ON_ONCE();
>      b. it can skip arbitrary pages and miss an in-use compound page.
>
> For 1a, we can remove VM_WARN_ON_ONCE() and just fail
> isolate_single_pageblock() if PageBuddy crosses the boundary, since
> pageblock_isolate_and_move_free_pages() handles it.
>
> For 1b, after we makes the change in 1a, PageBuddy skip cannot land us
> beyond the boundary, so the concern is gone.
>
>
> 2. In PageCompound() branch, a bogus nr_pages can also cause the
> shift-out-of-bounds.
>
> It will need a different fix.
>
>
> Hi Qi,
>
> Do you mind fixing 1a along with this patch?
>
> For this patch alone,
>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
Thanks for the review and suggestions.  I'll address them in a
follow-up: fold concern 1a into a v2, and send a separate patch
for concern 2.  Both will carry Cc: stable.

Qi



