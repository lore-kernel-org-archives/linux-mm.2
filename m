Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A90E7D1F9CF
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 11:55:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 163456B0008; Thu,  4 Dec 2025 06:55:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 114036B000E; Thu,  4 Dec 2025 06:55:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 029E06B002B; Thu,  4 Dec 2025 06:55:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E08DD6B0008
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 06:55:07 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2DE6CBC3F2
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 11:55:07 +0000 (UTC)
X-FDA: 84181632654.01.2B18C40
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4DE37C0002
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 11:55:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qSVT9OMS;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764849305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QUKzIqjXOT1S93jDicjj1D81R/loWPmYSN7SgH3R27Q=;
	b=Iv0u+HX50Nt8qrLHbOxxpL8JBzb9hUz1N0Rv9KcbRkVQ8VhFXX6JV1b42BLUeyDVbUpXCj
	iRW7vgJ3fbm7tJ5zgzmw/QCht3fDTD0H/6BFPgURdoebUB3ySnKI9HtTG68U9fucizY2pS
	4VVNCTUtw6BJKxZQ5QqjCNDu4oDEWco=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764849305; a=rsa-sha256;
	cv=none;
	b=0UWu/k4V3qequZn4itNQkdzl/DkymghoGSxXOKbbQp62gudqCET4z6BbYvOU5EBaCPOFll
	5JMF8Us32osBZhzhZte+UnEeCidITYR4DrjfAkARfAn83t7DjP8MeUeR6I21Z9P1EkpMLa
	S6kjA8WIxeacUSkpoNU2PZikhvrQm+A=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qSVT9OMS;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5F6DC444A0;
	Thu,  4 Dec 2025 11:55:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09FBEC4CEFB;
	Thu,  4 Dec 2025 11:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764849304;
	bh=v4OR7s2iAfpeKTApYIZ900a9qVzXp95UxXLFYkoRXs8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qSVT9OMSfs7yyCsQPOsdN90XnNTtafjfUD/dmcMfCTu8c2/lzqD1FogceFgxXWzqr
	 r203f3zuJK0foURONQHzxJY2jfHSaa5AoJChRe4r19+AoA9EnTfj6foTvHD81rZuYr
	 +9WQJigb/TTGAv/7xHl4ji1cf24S+iuagvkePOMK308/MkKZZkTDd4wyyflPIau25X
	 dYu0+XoM3toWaO6ttRBEFhHbAzSYaGblktewxJFBPQPKnwG/h9uUM5IOZm/d78tiKQ
	 bk35ayeXFgwv0FBkufVLisWx3GU2X8p4Dr34J/GS+L/Fmlm5g5c4stAETD6d0Mn/kA
	 LwCmKQbUjpj2A==
Message-ID: <173a99ed-483e-44b4-9784-598464323a39@kernel.org>
Date: Thu, 4 Dec 2025 12:54:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next] mm: vmscan: correct nr_requested tracing in
 scan_folios
To: Chen Ridong <chenridong@huaweicloud.com>, akpm@linux-foundation.org,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 hannes@cmpxchg.org, mhocko@kernel.org, zhengqi.arch@bytedance.com,
 shakeel.butt@linux.dev, lorenzo.stoakes@oracle.com, yuzhao@google.com,
 jaewon31.kim@samsung.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, lujialin4@huawei.com,
 chenridong@huawei.com
References: <20251203094002.1745458-1-chenridong@huaweicloud.com>
 <98cbf348-ff21-4c90-af32-b8009c34e5fd@kernel.org>
 <75ce1699-2c5a-4aab-acee-cca5c6a1e37c@huaweicloud.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <75ce1699-2c5a-4aab-acee-cca5c6a1e37c@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4DE37C0002
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: t6u9zoywb3yp5pny7pbbuyshm65h3jps
X-HE-Tag: 1764849305-859186
X-HE-Meta: U2FsdGVkX1//ArqpWVzInlpPExTk4I70cg55m6hvPSI0gFA3kAIF6VYLQ7MU1WJE7xn9THS7vB4EoEj6X8QgFVlV6OyYYWdx8LyBofjWXyQkD31lOqMdTzz2KpGLZzmB4ctj3aqU902cHkr4s6ng9FRZXgmQUufseTpINteKJQnhMa6xhAXXn36k1tL7BWP4zYU7rqfrBHXyw0I1dvcvVXrzwtgNCPS915rG0V7glCnL+cUDMiKPPCH+mR2JAf2Zkvl4Qr43O+kBMenRGZG+XmgrowtT1JctmJFHj91U+yoeHr4N+DWPJq73edbO7jC2DJYg/fwF7ZXSRaXk+QHgwItpFWYHyNDINt1pQbO2J5v/BF0O/+0Fd50vtbPCgGhiD2NM6k3nAacAqertJ4GHebo654ilCVIj3YnYJWKAuPy1qE+4ARFYmT+XBAGm7RW4y6LmjeWSnLQ+6UsJG2UGsA0NJy/bVPXaa0TXUGWfKH8wveIIwq8K8k8Q/8x5xhpNJBr6DOyds6DYAFRK5rRfXyO0uJuqrSEX+jiD/sQ0ecTBfr5nu9iBkYcH7MXuUqhrg05gVEisP5gPudZeltQZzkpK2xdE/NdHT5x7U8W5sixCSq6ACJB4xbMmECLS8Ym+bQMPi5aP8UPkUBgh80Krkn3cIOxcoBlKL1YBvhWKQNS53SfhwDDAOrWJCmfelD/px3IfKA+aDWmfcCwMAi09VcuxCyb1Lhgkm8NSMUgAMfx7x89/P6bmbJhm7yNFgwzi2mm1pmmowDrORIsXx1d9h8CCKBB1bh/rREQBobbfLhlnH05duSXpyl0DJL6TW+Hy9fyUapnkUW7IFV09Uh4JCsaIB0nXvoFTOMV5VzU/Q7le/H88ZGPUDgaiUaxe6vkNqdB5BSTqGPjMOdKhJm/6/6h1EzqtHYgE0ozCbqL3I3HU+ThA+VF3ymqu3UYu9zzgHlKquTBR/zCg8S3Gv6D
 wiwBnK84
 TCudeunr/1TNhw0IyrAC4miiUusSLjanDsGkEB8thEbKlWVioGimsqrHT2w2A84IZ7azC3wX9gK9eZgtZrpe3lH0r/3JzxB0gn45FTyQgLbC1lfBS/epI9Gjv+8JTm3wJjISXLPI6Gn26kSGHBD72fBEoPp1+P0lpzWyNLVsHCwb7BUipvpQVyfaZhnu/hZrCwmxRLt6ZwDGRI5x8OBpHqqvmNvtK9I27Benyeo+9OQuIE5aT4hlULOFy/DQ8t2qWAYRPYJfu0/AgE2o/elTrfS9/KfKqR7ZL3UwMOtBtAE4F9WTC3zFX6q4E+nbw3Erj3yAdxZId2eWfU6/sp6gx8+rpXOAezfVAHZ15
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/4/25 01:46, Chen Ridong wrote:
> 
> 
> On 2025/12/3 19:33, David Hildenbrand (Red Hat) wrote:
>> On 12/3/25 10:40, Chen Ridong wrote:
>>> From: Chen Ridong <chenridong@huawei.com>
>>>
>>> When enabling vmscan tracing, it is observed that nr_requested is always
>>> 4096, which is confusing.
>>>
>>>           mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
>>>           mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
>>>           mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
>>>           mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
>>>           mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
>>>           mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
>>>           mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
>>>
>>> This is because it prints MAX_LRU_BATCH, which is meaningless as it's a
>>> constant. To fix this, modify it to print nr_to_scan as isolate_lru_folios
>>> does.
>>>
>>> Fixes: 8c2214fc9a47 ("mm: multi-gen LRU: reuse some legacy trace events")
>>> Signed-off-by: Chen Ridong <chenridong@huawei.com>
>>> ---
>>>    mm/vmscan.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>> index fddd168a9737..8cfafd50a7a8 100644
>>> --- a/mm/vmscan.c
>>> +++ b/mm/vmscan.c
>>> @@ -4601,7 +4601,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>>>        count_memcg_events(memcg, item, isolated);
>>>        count_memcg_events(memcg, PGREFILL, sorted);
>>>        __count_vm_events(PGSCAN_ANON + type, isolated);
>>> -    trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, MAX_LRU_BATCH,
>>> +    trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
>>>                    scanned, skipped, isolated,
>>
>> We do that in isolate_lru_folios().
>>
>> Given that we do
>>
>>      int remaining = min(nr_to_scan, MAX_LRU_BATCH);
>>
>> and effectively cap it, I wonder if we would want to trace that capped valued instead of MAX_LRU_BATCH.
>>
> 
> I prefer tracing nr_to_scan, as it reflects the original target number of pages we intended to scan.

But it's misleading, because we're also tracing "scanned, skipped, 
isolated", and one might wonder how it relates to nr_to_scan?

> Even if nr_to_scan exceeds MAX_LRU_BATCH, we can still deduce that it was effectively capped by
> examining the actual scanned, skipped, or isolated counts. However, if we trace min(nr_to_scan,
> MAX_LRU_BATCH) instead, we would lose visibility into what the original nr_to_scan value was.

Is that really required for the purpose we are tracing here?

-- 
Cheers

David

