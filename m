Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D214C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 11:32:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D57956B008A; Tue, 21 Jul 2026 07:32:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D07526B0092; Tue, 21 Jul 2026 07:32:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF5806B0093; Tue, 21 Jul 2026 07:32:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 870736B008A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 07:32:34 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 098251C078D
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 11:32:34 +0000 (UTC)
X-FDA: 85012571028.27.B4557A4
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8A83C1C0006
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 11:32:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=mlVy1E9P;
	spf=pass (imf18.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784633551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AcQT6oTjanxItuAmimd9GFfZe4OYmXP7lT7W50sMfx8=;
	b=yZqnLIeIWsFshQGbH1DEsAnyXfJn8ar4agz6ZaTxh/zeSodz7rHlUQGP217GXLhRLsSsGu
	NoKcRplO37Tps4G/qz5eiL59ZhM0b9GNowv9VM1E0LQHazNhXHEH8lfqGmri3tEDSW6Be+
	Z7Hk38VZgAz6oYe76R243FZuvxSLL+8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784633551;
	b=nXEG5RGNALB8nplXV3GN/3v1SpPkPelBEwvHb/ew8GYmjYh3y3nzqzwuJJC96nYqufacHp
	wUiOnj7Hl1FJzfz7RigmskgXGgAmdFsNndXngNVOUWwgF8aORoqQkkM9/kV9HPrklEW2+e
	LvL1XqKeH41jXk1EPYVkw8BwrBdWaZQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=mlVy1E9P;
	spf=pass (imf18.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784633546; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=AcQT6oTjanxItuAmimd9GFfZe4OYmXP7lT7W50sMfx8=;
	b=mlVy1E9PH4XZWrmys62liAn7WrrLWWbkoyTno4SB/pocl72EC+xYuZKX13MAUhxMSj9wUyqdQ0O4sz+RXiSZtK0T+p75IyP51C8eVF1Y8qySkzvhmBtc1/eBYqLpiJah8Gik5Uagf/72GAb9Z4wda/+VjPNrhmnWHRE5dCLGxhA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=46;SR=0;TI=SMTPD_---0X7ZvAmG_1784633542;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X7ZvAmG_1784633542 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 21 Jul 2026 19:32:24 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Shivank Garg <shivankg@amd.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  David Hildenbrand <david@kernel.org>,
  Matthew Brost <matthew.brost@intel.com>,  Joshua Hahn
 <joshua.hahnjy@gmail.com>,  Rakie Kim <rakie.kim@sk.com>,  Byungchul Park
 <byungchul@sk.com>,  Gregory Price <gourry@gourry.net>,  Alistair Popple
 <apopple@nvidia.com>,  Lorenzo Stoakes <ljs@kernel.org>,  "Liam R.
 Howlett" <liam@infradead.org>,  Vlastimil Babka <vbabka@kernel.org>,  Mike
 Rapoport <rppt@kernel.org>,  Suren Baghdasaryan <surenb@google.com>,
  Michal Hocko <mhocko@suse.com>,  Karim Manaouil
 <kmanaouil.dev@gmail.com>,  Frank van der Linden <fvdl@google.com>,  Teja
 Vojjala <tejavojjala@google.com>,  Pravin Tamkhane
 <pravintamkhane@google.com>,  Kinsey Ho <kinseyho@google.com>,  Wei Xu
 <weixugc@google.com>,  Matthew Wilcox <willy@infradead.org>,  Davidlohr
 Bueso <dave@stgolabs.net>,  Vinod Koul <vkoul@kernel.org>,  Bharata B Rao
 <bharata@amd.com>,  SeongJae Park <sj@kernel.org>,  David Rientjes
 <rientjes@google.com>,  Xuezheng Chu <xuezhengchu@huawei.com>,  Yiannis
 Nikolakopoulos <yiannis@zptcorp.com>,  Dave Hansen
 <dave.hansen@intel.com>,  Johannes Weiner <hannes@cmpxchg.org>,  John
 Hubbard <jhubbard@nvidia.com>,  Peter Xu <peterx@redhat.com>,  Rik van
 Riel <riel@surriel.com>,  Shakeel Butt <shakeel.butt@linux.dev>,  Tejun
 Heo <tj@kernel.org>,  Fan Ni <nifan.cxl@gmail.com>,  Jonathan Cameron
 <jic23@kernel.org>,  "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,  Nathan
 Lynch <nathan.lynch@amd.com>,  Frank Li <Frank.li@nxp.com>,  Dan Williams
 <djbw@kernel.org>,  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,
  Mike Day <michael.day@amd.com>
Subject: Re: [PATCH RFC v6 3/5] mm/migrate: add copy offload registration
 infrastructure
In-Reply-To: <19F47514-EBC4-4659-8252-EC3765D9B601@nvidia.com> (Zi Yan's
	message of "Mon, 20 Jul 2026 10:44:34 -0400")
References: <20260630-shivank-batch-migrate-offload-v6-0-da95d7e8b8a2@amd.com>
	<20260630-shivank-batch-migrate-offload-v6-3-da95d7e8b8a2@amd.com>
	<87wlupx60s.fsf@DESKTOP-5N7EMDA>
	<19F47514-EBC4-4659-8252-EC3765D9B601@nvidia.com>
Date: Tue, 21 Jul 2026 19:32:22 +0800
Message-ID: <87se5cwpbt.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8A83C1C0006
X-Stat-Signature: risbkxx33qmw86yhj6c3sgjaixqprbyk
X-HE-Tag: 1784633549-946411
X-HE-Meta: U2FsdGVkX19WU3qUmST051An9t91R7B7estcX2NTEl+zoiQ1N2V33iO3pjMVdbWrT0z2pGIZLRFDzICnypEuKOfgJ0aukNLiCxi2S0c3zKTEeX5wmq33wUfwHNAA5/XTbfaqciRc5k5Q4au3YtlSVRbm5fTbhAU9fK7gdoD4MlmnI2vaZ+Xiv2rIzO+ZEeZ3Kb3SEr4P32XYP0fDsSIoGgfnYKveUzIsUmxij11ASzmTQumx8bJ6PdehbvFfPOSU/T+MzB3MElxKnMS3lQ8vfV/r090ql1GSJjUK7O2HUt9xgHjpzxzgAYHfHGrRXeLCBrNeLKZQHYHkHxCh1v0vkk3JgHN8o3DNB5kGBtMe6j84zl6ynOa04UmNPiLWozWYYB4YRfUvQ2C4juZBT2rjyeShMGLOAlmXQfcLZvkzoCpNO2rDtQ6gUUHTLhESSotUq7C0cFjPVciWdxVX92vvl+0qZ4qWTuGu09S7AL86KHMCsf2BV8nd2k/QZ5K6mfaddEUSUFCn0WRFq18YnGbZ4j1bkQkuHcE5y2HKzzea2e8b473nbO/vfSlbTpQsoSnZQWkFa0Z197hWap5DxQGEKtAfpg1mE2QXE5W8qvdWDx2T2tP5s4GIo+PUhYnjyqPblVo2Vb3qy0Q/ffrUJ0dY0ESs9HAgjD0a74AAJNQZcz/cH+vbRGNzj9QmnxAYiMT8/TPT9/UlcIghWsvBFaoRwL8RdKXeVhKrm8wS1iGFZ7PxeSna+yxdyp4hMGUfvnCEsHBzgruzOhyjMBDHQxqlwP/RZdpxDem7IYGAG4Z6V0nvmB5hsHdwNYnUOUtnzI3/z3KUPHBoIYVfCjNb4Gyf/YPQOcEHnAKt3a9Zo5KSnDBPGli40ZEo18QF3SsNExBTAIEkZjiXrUYhOvxBspcPTofketIRu42SIwZOYmxK3GJ3EGVy2Ujc5v4Hri//LVSykouPJ6I6GQ76eADWuNX
 ki3aExsP
 AciGRmcmpFljVxCdEmDfWE0YE4xMTqFIWJe/x30pgbYtK0FnaAXL3TbQPz54M/EIw3oH1V9R106yHVwPBn0aKprLCO/zvDyQhEWqqIcJM3w5GZi9Da07SfWg70K45BJQhCgFIDsqxRN3dSJf9wzJy9e/FF3qcOexJEWrr8PeUxt8NnxhtnIz5bI7Xc0V+ehvVxEIvqZMv8Wabp+J8Il9uacX8paP1a3bMg1z6suphe7rvV20yKfqZwk1swwWRDb6JV3RYFMghTbSmbJ4WFvvM7Etofcy565NtMep0FqAKOxtdVmwVYdU1ugx5xb+W1jcDLUxBLD1FrFRTyAEN6TmDnIA8HDzG0XqfMOrK9xxoRNRlo0XkvRmuzopfESwWt9M3MPUAW/xXif5mN7RBzJoAWo6rdSYmTZYSU3SB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Zi Yan <ziy@nvidia.com> writes:

> On 20 Jul 2026, at 7:19, Huang, Ying wrote:
>
>> Shivank Garg <shivankg@amd.com> writes:
>>
>> [snip]
>>
>>> diff --git a/mm/migrate.c b/mm/migrate.c
>>> index 41b732e78a67..4fed3110ca0a 100644
>>> --- a/mm/migrate.c
>>> +++ b/mm/migrate.c
>>> @@ -43,6 +43,7 @@
>>>  #include <linux/sched/sysctl.h>
>>>  #include <linux/memory-tiers.h>
>>>  #include <linux/pagewalk.h>
>>> +#include <linux/migrate_copy_offload.h>
>>>
>>>  #include <asm/tlbflush.h>
>>>
>>> @@ -51,12 +52,6 @@
>>>  #include "internal.h"
>>>  #include "swap.h"
>>>
>>> -/* For now, never offload. Wired up in later patch. */
>>> -static bool migrate_should_offload(int reason)
>>> -{
>>> -	return false;
>>> -}
>>> -
>>>  static const struct movable_operations *offline_movable_ops;
>>>  static const struct movable_operations *zsmalloc_movable_ops;
>>>
>>> @@ -2050,7 +2045,7 @@ static int migrate_pages_batch(struct list_head *from,
>>>
>>>  	/* Batch-copy eligible folios before the move phase */
>>>  	if (!list_empty(&unmap_batch))
>>> -		migrate_folios_mc_copy(&dst_batch, &unmap_batch, nr_batch);
>>> +		migrate_offload_batch_copy(&dst_batch, &unmap_batch, nr_batch);
>>>
>>>  	retry = 1;
>>>  	for (pass = 0; pass < nr_pass && retry; pass++) {
>>
>> Found a difference between v5 and v6 here.  In v5, migrate_pages_batch()
>> checks the return value of migrate_offload_batch_copy() and acts
>> accordingly. While in v6, it does not.  Why was this changed?
>>
>> IIUC, FOLIO_CONTENT_COPIED is now used to indicate a copy failure.  Is
>> this necessary?  Is it possible that some (but not all) folios fail to
>> be copied?
>
> Based on the discussion[1], FOLIO_CONTENT_COPIED is used to indicate both
> 1. folio is copied via offloading, and 2. MC copy failure. So the code
> no longer needs to store the return value of migrate_offload_batch_copy()
> and can just check dst->migrate_info & FOLIO_CONTENT_COPIED.
>
> For 32bit, FOLIO_CONTENT_COPIED is always 0, so all folios are always
> copied in the serialized path. Hmm, that might be causing double copying,
> since migrate_folios_mc_copy() copies batched folios and later
> migrate_folios_move() copies them again since
> dst->migrate_info & FOLIO_CONTENT_COPIED is always false. Maybe we could
> make migrate_folios_mc_copy() return immediately in 32bit, otherwise,
> we will need to find somewhere else to store FOLIO_CONTENT_COPIED.
>
> [1] https://lore.kernel.org/all/c2bfdf39-8caa-43bd-b1ad-2285b4cc767a@amd.com/

Thanks a lot for your information!  Although personally I don't think
that it's necessary to optimize for really rare folio_mc_copy() failure
cases, I am fine with it if you think that this is the better way.

>>
>> [snip]
>>

---
Best Regards,
Huang, Ying

