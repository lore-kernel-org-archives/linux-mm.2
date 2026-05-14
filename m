Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D0A5CD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 11:13:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 922726B0088; Thu, 14 May 2026 07:13:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AC616B008A; Thu, 14 May 2026 07:13:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 773FA6B008C; Thu, 14 May 2026 07:13:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 62A766B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 07:13:55 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0D77FA03D4
	for <linux-mm@kvack.org>; Thu, 14 May 2026 11:13:55 +0000 (UTC)
X-FDA: 84765765630.18.CE7BA7C
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf14.hostedemail.com (Postfix) with ESMTP id 566E510000B
	for <linux-mm@kvack.org>; Thu, 14 May 2026 11:13:51 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=3UhhzCy4;
	spf=pass (imf14.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778757233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eLdzmnS4HlCcjbg1+JnOr4mOcjOgGssYgMzS57rsRiw=;
	b=AD71NUjFvAdxDYxzZMWLVEQf8vf7ciKsc05zgsOQ6WvexureZsYMh866l3/fVhr8oijbkI
	ZyWXQJKDt0wdBQohCubjVruYOvcxjxs/VSnznlhjgk2QN19ZMXNGiDPKgp9SJ4/WvEnJaK
	G1Gfrlga60MlQ+KlqN42tm+LhvCerWY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=3UhhzCy4;
	spf=pass (imf14.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778757233; a=rsa-sha256;
	cv=none;
	b=dEA+j8KcufBsNS7oHLx5fARU2yku+X9RipwbkyovSxMw4rmwdvV/J7/zhvx/XecNFzMzCn
	C93zQDJ8qJ6rg3B71lSNsbKDgBpO41gb72ELXl67AXPuDsny0PcuPYb15Gg1Bk4F0GhvW/
	tBBK1KRkm4MRdgT76b9AE51UkRzhDLQ=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=eLdzmnS4HlCcjbg1+JnOr4mOcjOgGssYgMzS57rsRiw=;
	b=3UhhzCy4h7tYEBC4ieDPO7HikB2GMa+xGd27ppz7l/FFfoM4wwTFEaqkBvQODZkW4gM/e0hz3
	QikUtC5RTb6uT/+gVbxjaQegM1Na57rlVEO+nIT35NMvN+cr0RcHJ3wWOtZDMMuitveu/Fe531/
	RSIf97Cln71haEAeiTAKTOU=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4gGSDy0YH8z1cyPt;
	Thu, 14 May 2026 19:06:10 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 9060F402AB;
	Thu, 14 May 2026 19:13:46 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 14 May 2026 19:13:45 +0800
Message-ID: <f98b2773-cf0c-4e63-a600-76e79755a336@huawei.com>
Date: Thu, 14 May 2026 19:13:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/damon/vaddr: attempt per-vma lock during page table
 walk
To: SeongJae Park <sj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-mm@kvack.org>, <sunnanyong@huawei.com>
References: <20260514020059.149541-1-sj@kernel.org>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <20260514020059.149541-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Stat-Signature: nysr5ifygcioxqjmnfr3z438sf5gjkko
X-Rspamd-Queue-Id: 566E510000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778757231-4959
X-HE-Meta: U2FsdGVkX1/VJ8e9cCpo7doZgIXU9EedQow53EzAb9ddU19BBT25gD0xPKJhycD9x5Vr3uKJwdmJ+cdBVYckTI5vggRiwjIOlZk8d7xPbeIiskBhqkOX2G3noQxrYOK4607rIR4OGJ2HhM2boaV8UnQ1Qw0WVaSwWxeKt2FEMB1xJiam0SkDDQgmql6g+mgSKxoS8gUId4Y7PVm2ThhzXmHZuNxKsCE7FrO4geuj33MQx8CMqRKSqA0Nokxnguin1TvjR24Q0EQlt5B5LfUWIYwKw3E2osNMDIlW8XpwGsFCHXrF6lBrs3TzT4O3YwjsXyrlIIo+jkRtMPah6NtGBk8MXQUZb1MAR/8SpQTW4mtwE/v/R8KIRYLwB0QRs9K+tncnva4FZVbGNqP1lCqlp5PK0Ey1Z4qTvzcQq28sA5pHHDuYdIXu48rb+0gaJ1lhWL7DkRjWfKgtAIJxTEyB23vGsR50yMyxnT9mp1Tus4vNWaA+fl+tGA+bo/mf9PwffFosj7f0TjreKSG1CLLFhN+kYXgm2a+9b67rywVAYc2T+YSR8Ggyad2QANsodDGHuWETNyJsaMkzXVjdlJgtg26eTsRv0KPXoM8Q7NmGT8nlz3DN1pkI2AKLTL3QJj9WLs9kG+gCsP+KkYnvmnz4ySGc6ZZBMf8GgZh1h6PNJ/BE4tQjscUV2SzkBNBj7fYvRZR4zugplko23d6/r2LJwIcsL1iWBwVuIA1VN128iqhyzefmqLeMtukloJvfKdmPvJJj/9TtSJv2qBbLk5eK07moDxBvxtNwSKSQ2hLbh3V0RhQWMw4deXddPJCXAzbDuKfHdLyBKOB+FLzS6zoA/OTJIcW3WUrszo4g5k5yGJSnrK8iViRHlpSMD8kQOwKTc+w/ltgimw7x5/fafEZLwxMnuhQ3TVaP1wmBZrY7Gh7MIeIIVGvAop51QS64HHJ0avmNFBOiQDw96pAI9QV
 iA/i2yxx
 s5cqO6OhOV4nc/SrXeRHVmVzL3r9y0BNcL7Qv/5gvS2FHApvHaCEj9naaun56nRWA2FBeYe/S7JFaA0Lz3B+UHZzSo5X7LnXxn7Y15Ik4UDhqc2OEzPffX5F+N2qvXBwtN5X2leb605nVBY8yZUyGGL+p9PxpcZ6ORAaXHB5zUnrEFLyHZZKcqij5ihPa08drKAr79YkjrhhqtR3pISa/QEq2UVAP1vwCYDtLpCE2iYd+gR2Udu3Rlu8Zj2tRBbzW73fDeehhaJlEjgNwf6fpxEDB2QzfEc46AZWVm0awiMRq6GrjSZhEUJP2baTQulXUhkRnKDJP+yC1wQMeT6NBV+MPnkewA4fxu1AVctHFMF8WuKg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/14/2026 10:00 AM, SeongJae Park wrote:
> On Tue, 12 May 2026 23:15:23 +0800 Kefeng Wang <wangkefeng.wang@huawei.com> wrote:
> 
>> Currently, DAMON virtual address operations use mmap_read_lock
>> during page table walks, which can cause unnecessary contention
>> under high concurrency.
>>
>> Introduce damon_va_walk_page_range() to first attempt acquiring a
>> per-vma lock. If the VMA is found and the range is fully contained
>> within it, the page table walk proceeds with the per-vma lock
>> instead of mmap_read_lock.
>>
>> This optimization is particularly effective for damon_va_young()
>> and damon_va_mkold(), which are frequently called and typically
>> operate within a single VMA.
> 
> Maybe this is not only making DAMON faster, but avoid DAMON blocking others.
> 
Yes, this is exactly what per-vma is for.


> And because we don't have performance measurements, how about making this
> sentence less assertive?  E.g., "This optimization is particularly expected to
> be effective for ..."

Fine to me.

> 
> I guess Andrew could make the adjustment when he picks this into mm.git.  If
> not I will repost this with the trivial change if you don't mind.
> 
>>

Sure

>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> 
> Reviewed-by: SeongJae Park <sj@kernel.org>
> 

Thanks

>> ---
>> v2: avoid handling VMAs with the VM_PFNMAP for per-vma path, found by
>>      Sashiko review.
> 
> This patch helped Sashiko finding [1] yet another DAMON bug (impact is minor
> imho).  The bug is orthogonal to this patch so there is no blocker for this
> patch.
> 
>> v1: https://lore.kernel.org/linux-mm/20260511132546.1973270-1-wangkefeng.wang@huawei.com/
> 
> [1] https://lore.kernel.org/20260514015053.149396-1-sj@kernel.org
> 
> 
> Thanks,
> SJ
> 
> [...]
> 


