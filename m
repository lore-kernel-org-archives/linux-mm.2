Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2767AC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 09:59:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC29B6B0088; Wed,  8 Jul 2026 05:59:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B74496B008A; Wed,  8 Jul 2026 05:59:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A63236B008C; Wed,  8 Jul 2026 05:59:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 77DA26B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:59:07 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F224E1A06F4
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 09:59:06 +0000 (UTC)
X-FDA: 84965161092.14.7EB882F
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf25.hostedemail.com (Postfix) with ESMTP id DB962A0005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 09:59:04 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H4jGjIH6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783504745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eDdUoK9vZYcJzDZ9mWdzXu682a87o0TkuSJF6MiXxWE=;
	b=n04t0adRFiChB3ZDN1hkE+mp02oUTdqqUlrZ6EQxu8nZkK5zX8/qcXCjyD5siPtjVQP4Ix
	s7dHubiPkdnxCy3oj6YUcpZFAPbeEr6LAsB7cMFNMi9ttYt6UKzifCl84dOOmO6egBT5Gg
	ch1OJG203zCPyGQ+dYcoYKc0BaEuC2c=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H4jGjIH6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783504745;
	b=oSwFm/xoPVg+LmH2S45EkuHXt6Mhspj0KM6xyAQ9tOnahBUdeVwjJtVb7sS/8aqJB/omBM
	T/GYB5cHTGv7Q3Lf5UWneLgIwhaO3EIWPieC5z+odbuV0SQtXvw0BVggaWwrMBNjsorv+G
	HiPWSIcJzAHgbLDE9qm1vwzPa0x0PxU=
Message-ID: <77b3b74d-c1bb-461b-8076-8729cdcf91f5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783504742;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eDdUoK9vZYcJzDZ9mWdzXu682a87o0TkuSJF6MiXxWE=;
	b=H4jGjIH6a1O2+FpGCj75NCmsTnAOxOzHA09ZrFJevtZQyyVzPtWnfI4Chq4W2ZZ2LyBI4M
	39QLUqp9qFtf2bifL74yYe3eWFvV5o/CufTVTKq+4537Jktwpf+e6iiEZQUy2Ck1yxmGlE
	y0beFgDYuF2hrkH03OhXgS63VvKg3Ds=
Date: Wed, 8 Jul 2026 10:58:44 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v1 2/2] mm/memory: add anonymous mTHP folios to deferred
 split list
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Joanne Koong <joannelkoong@gmail.com>, akpm@linux-foundation.org,
 ljs@kernel.org
Cc: alex@ghiti.fr, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 willy@infradead.org, linux-mm@kvack.org
References: <20260707201735.4113107-1-joannelkoong@gmail.com>
 <20260707201735.4113107-3-joannelkoong@gmail.com>
 <584098de-dd48-4004-8e7e-3d826e60c860@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <584098de-dd48-4004-8e7e-3d826e60c860@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: DB962A0005
X-Stat-Signature: dwjhe1sm9ajq7gi6f47d5suqseqmmbea
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783504744-284479
X-HE-Meta: U2FsdGVkX19d7BTdjiSqchg7JdcInAC26yIZQryf3l5zyoBG3WzqLChzmX7YOJK7P6g+/4yONzFOjQ1QdZt/VUj+/mMCmZwpqPO/GVNWLmdjg2EWDxaxqxRcdXzhsWz0V/b2z8pXx8wH2atfoX/oecLrUJO/Sf15FYVVEAZDdtm6Qg/StOhp9HaDlNG5HKz38U5jAbwSEFvh5KM9sYmwj9IL5/Oef7D3VSonpLhsFZY6OgY6gvNAzS7nZcqihtizRUghxDk6eGat1vREtgQGJaeer4grVDVP6PB9XcZop2KN8RWp7B9EYspj9SNOfxZPmjvimMKjGEPqmjjr6HES9LLDXHoar0ezluOs3RK91AykDMvzDgjRTTCTnzn0Sjxd3GwcWCrlmdON98DKbvPECGcpAYvuRMHrMCkZNtaCe6ng2rQkm/nOsJCHDAQrZ1WMNHZTV14mSlkKPZm3pUGvGud2TDun2WgjVqqWxmJV4ic+j/quGpvAUYMwmoBwJCUtX6SKF/20TdIMvv+p9bLtA3LJLnWRiWreq8c3nyYBlSSVA0q6wMcRXT2Nx7NZtRvngExT2g5f1hV+BwhdsD/rKcZ1lYX2tsT+Ac5JYLqzC8H/7Euk53JzQG0XFTWOpR30xenCM/dQ7PQoGxsO5yjY/L5+MS3889cpT0uNb6f8Uz4HUu5dQEy5dbxUpyBxWXTtucvxf1qq7QxINb+t78mBkZRtKlAkmY1x9SO68oOAIJg/t7fjaPX3QK/gXxxQhT9uoDutii3ZVPWzXtqNXH4J5U4TFV6YpDaea0/DiIzyeTvCy89Tk3df8YjlxYYhyHtY4hIHVicrT6HA0YVZ9Jv2hIBNpfYXv7btKr0a0z3yFKsp5GGBRjgP2OMv5UdD759Q2ugo1nWx3xea6lATfqyG+HwRlnnDaOOzuZdCiB2t4GmZlHEDrtvS5Q3HmC6+yMRy1Psx6LjT2U8GHHIrOes
 Cx/mCl5I
 IsYUVWZ0eSYHMmOxgSdpNIMgLcINPemqkrMYa8q1DxSzBcal4Kby1dSNCpfbrlhlZ0oXCKB50woY9qm8BjHhWC1xKYiOlKfWUMMV2WeeIZVg6SHBSqrwBRyq7MhHrxlXQFHv765A6xqzI3+zzuVByYmL6gif5uWbl/7IpjGhNSftp2FObD7L++YDD/7Fi96w9Z97X/2Mf1EWO+G0YJO/J7/csWaVXY/WmdqRzJ6iAWZbwuOVv1ahsG+vVy0fUDkDXqoVS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 08/07/2026 08:56, David Hildenbrand (Arm) wrote:
> On 7/7/26 22:17, Joanne Koong wrote:
>> Unlike for PMD-sized folios, an anonymous mTHP folio doesn't get added
>> to the deferred split list at fault or collapse time. As a result, a
>> fully mapped mTHP folio that is mostly zero-filled doesn't get split by
>> the deferred split shrinker when the system is under memory pressure.
>>
>> Add anonymous mTHP folios to the deferred split list so that if there's
>> memory pressure, a zero-filled mTHP can be split with its zero pages
>> remapped to the shared zero page and then reclaimed.
>>
>> To minimize overhead on the common order-0 fault path, the
>> deferred_split_folio() call is guarded by an inline folio_test_large()
>> check.
>>
>> Suggested-by: Usama Arif <usama.arif@linux.dev>
>> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
>> ---
>>  mm/memory.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/mm/memory.c b/mm/memory.c
>> index 6637c5b13c9b..441d918e3dc0 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -5259,6 +5259,8 @@ void map_anon_folio_pte_nopf(struct folio *folio, pte_t *pte,
>>  	folio_add_lru_vma(folio, vma);
>>  	set_ptes(vma->vm_mm, addr, pte, entry, nr_pages);
>>  	update_mmu_cache_range(NULL, vma, addr, pte, nr_pages);
>> +	if (folio_test_large(folio))
>> +		deferred_split_folio(folio, false);
>>  }
>>  
>>  static void map_anon_folio_pte_pf(struct folio *folio, pte_t *pte,
> 
> I had a session [1] at LSF/MM about having essentially all large anon folios
> part of the the deferred split queue.
> 
> (1) I don't think this scales.
> 

What if we only add the mTHPs for which the policy is set to always.

I think it doesn't scale if someone sets all orders to always, but if you only
set the 2M mTHP sysfs to always, it should be the same as what we have today
for PMD order?

The main motivation for this series is to try and bring the performance for
ARM on par with x86. One of the differences is TLB misses. I imagine the lower
churn in kernel by using larger page sizes will help as well. But we will
run into OOMs without the shrinker.
 

> (2) I suspect the shrinker should make smarter decisions of what to scan/reclaim
> first.

Yes definitely agree!

Alexandre is looking into this as well.

> 
> I think this needs more proper thought.
> 
> [1]
> https://docs.google.com/presentation/d/1RfKWCY1AMVns-WLn-QdAWbI2a-rA7fbFyh7XD1Wn5BY/edit?usp=sharing
> 


