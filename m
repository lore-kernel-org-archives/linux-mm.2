Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFCE4606A33C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 06:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=t0GaDORo
Received: by kanga.kvack.org (Postfix)
	id D8E276B00EF; Thu, 29 Oct 2026 02:19:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D65456B05B1; Thu, 29 Oct 2026 02:19:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA7EC6B05B4; Thu, 29 Oct 2026 02:19:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A76866B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:19:34 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 646E5A02D3
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:19:33 +0000 (UTC)
X-FDA: 85374662226.24.4475F4D
Received: from mta1.migadu.com (out-20.mta1.migadu.com [95.215.58.20])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4523C1C0005
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:19:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t0GaDORo;
	spf=pass (imf21.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.20 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793254771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mZElNr4luEtzZZ0O/K8I6GXZDNPe8XWgMVKSP+jJ9n8=;
	b=sS3ynwXNhn52vFcIAPZjzUGwDz56m1lqCQxpr1DizWLOq30w/006di75d27D08slpGf0a+
	71yhnCWyYOSnTYiX1qTZ/9kpeDINkBy9cloi636V5EIcbjjL+9eR+JJWcFHuurg+PCcBd6
	0vBmpcG9ZdmTJdQJxF/cel0bp5xmBEY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793254771;
	b=BT44hATOVC9gfDIwcsJ3rffUNHEgfdgT1FlCfBSgZhoMIan2hrHDE1lV87+CEb3dlbJ/Og
	j7Ur+mNz0kXMmhWr96tLK9lv8Jql4a5MGSeBSl7IwrF9m2rRk1g65Rfs2cmF2ZlsHwqm3/
	gwmrIriS9zVYTnFrI/QleHznGrW5T/I=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t0GaDORo;
	spf=pass (imf21.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.20 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=XbuiEYOxIfwUc/1yQoSDFfJ/vqmXXN2lOdBbPBDeo00=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793254769; v=1; x=1793859569;
 b=t0GaDORoxdS6kVlTG2PkR06Y2gIQMt7yWZDAXFsJ7F0rZA7IjYMDoHcHOVnTx3NHpSGlTCP+
 37zPYUuOl991HVgAVy/qNFW36HDpQW42nQ7yyY7gLiLAoJPKcqb+08KmrDGlxr/2HziuNEbaXuL
 P6FenMZ29S3Km+cP1jfp30i8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b10954797ac84e40;
	Thu, 29 Oct 2026 06:19:29 +0000
X-Mizu-Trace-ID: b10954797ac84e40
X-Migadu-Flow: FLOW_OUT
Message-ID: <8fe9539a-1a0b-44a0-aec9-032235e8fee3@linux.dev>
Date: Thu, 29 Oct 2026 14:19:17 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (macOS/Intel)
Subject: Re: [PATCH] mm/compaction: annotate data race for
 zone->free_area[order].nr_free
To: Dev Jain <dev.jain@arm.com>, Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: teawater <zhuhui@kylinos.cn>
References: <20261028090747.68086-1-hui.zhu@linux.dev>
 <548d9950-cc77-4c1b-b78a-34e304adb989@arm.com>
Content-Language: en-US
From: Hui Zhu <hui.zhu@linux.dev>
In-Reply-To: <548d9950-cc77-4c1b-b78a-34e304adb989@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4523C1C0005
X-Stat-Signature: cj5a9yqpfinx5snuthaztdsz7j4cenoc
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793254771-641677
X-HE-Meta: U2FsdGVkX1/kdKiotOPn1gnpZS43E+id6X6om5nehVJC2zYes2H8qMz04+CNIoALvpUa7RqbiXG2RQhadNXqXMhPF/xl24xHlvOTRjcnJCeKgnUi/cBD+E7nyRNy2V+UXITJTt9G60htv4oexthv2VGye2B3RxlJUapaPylJ5jKAVqbB34DMj+yHz1MUysL4gVnL1EI4G/8aSqjYy9g5K9mSVwqN2ldVkQg9j5/+DvGoJR2Rvgj8W+V3M0jzhQPDrfKwGx3mjtULC4au+fRwFY9078Ppt28NwF7xWuGpEU34DtvCIJH7U172xg3J/QqaQ8v1h5jfjYWI9LM0nyIC/4WcloW50espGdSc6yaEywUunxy+dn/GopEsDfO5AAc0XSt5aRo6nhIUzeJ4hK74jK9Jc29yNmRkjVXTqh9m2uWHqfmLMkztp8p+js+V3eB/4PCGuW7WSoDLs/NmTeWXa3XhIBUlCy63EISTGsc+Az0qMlk6O5bX0wNfceq/24vfH4BXqXAvxCHT9PxykArDqY1LPrtlMrlxMg8fL2RiBmTc6vm+drHSSSIqx0tzyDM1R4vf1zPpGx03kOTXLkIEhEfke/DasDyYDYIoA9TtYjVGPxVehaluRLag05AgbdPC54D2rYns5o1IeHpAlCDHo1wOG8Dv7Ypjmt7lt1ocELq04ufB/Mwb8VVmGDzRjJY9SNo9FLwMDPGCZtedbxJuj0TBorlYhMPQJ5ZriGuLmIeJjNCfwMHh08Y451fZKcfHTAu/hhNFegw4hTXlLgP5j3lmAdlr0Edk1OdMZfx23tnhq1RsLiIVCxZ0cNI7wr1TfaS1PtTRwdCieX16KGUr61vxQ7r2WkaS8UiNMJ93WK85pR5AayWvpv6ojHsjkQzEZf5tKE04iV5/0CJlDATpQbwxgt5UaxB31H8Z7mWjoF/xD1AxM1XvHlnoY1tkjeprpsFDIaYh43lb0lC4vic
 289e8iDu
 HBdpZYoO1oDlGnSyYg/OtXcrrKfiBqwmikD7SmJsBL3n6hLw0qSVnwGey6IhV7XwEHyaX6+ZIFfI76zwOAqGxdeQb/87o2c3HvQ1eVFkUiQ0Qnlj+oSe9+oGz7A1e844vuWg3WRjzW66CsRtPdQcl9tRifK6R6k+XovB6+NUjhNNUyGdN3tbkGSCcL72kjqCnsrHN1JXXoq2YcIb5SOsUd0wCXSFO0MtUR77orMPZiOcI60Fm1qmJsXhg89l9BFkZrXAFL5bUVoZvjwRs/4KPj36xipQ18xsUSVDqpUxI9qt2VFosZu6y7N+gFEXw+XN2LF+dD8cyz0HntrQ4TBTlWAj6LkQOf6LOelVu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


在 2026/10/28 18:30, Dev Jain 写道:
>
> On 28/10/26 2:37 pm, Hui Zhu wrote:
>> From: teawater <zhuhui@kylinos.cn>
>>
>> KCSAN reports a data-race on nr_free which also exists on mainline:
>>
>>    BUG: KCSAN: data-race in fast_isolate_freepages+0x284/0x1550 mm/compaction.c:1589
>>
>>    race at unknown origin, with read to 0xffff9894ff3dcb60 of 8 bytes by task 179078 on cpu 12:
>>     fast_isolate_freepages+0x284/0x1550 mm/compaction.c:1589
>>     isolate_freepages+0x52/0x650 mm/compaction.c:1722
>>     compaction_alloc_noprof+0x36e/0x3e0 mm/compaction.c:1850
>>     compaction_alloc+0x21/0x30 mm/compaction.c:1880
>>     migrate_folio_unmap+0x7f/0x820 mm/migrate.c:1177
>>     migrate_pages_batch+0x37e/0x1200 mm/migrate.c:1762
>>     migrate_pages_sync+0xce/0x560 mm/migrate.c:1928
>>     migrate_pages+0x8c6/0xc20 mm/migrate.c:2037
>>     compact_zone+0x539/0x10b0 mm/compaction.c:2660
>>     compact_zone_order+0x1b8/0x230 mm/compaction.c:2795
>>     try_to_compact_pages+0x20b/0x630 mm/compaction.c:2851
>>     __alloc_pages_direct_compact+0x98/0x2b0 mm/page_alloc.c:3722
>>     __alloc_pages_slowpath.constprop.0+0x452/0xdf0 mm/page_alloc.c:4401
>>     __alloc_pages_noprof+0x28a/0x2d0 mm/page_alloc.c:4794
>>     alloc_pages_mpol_noprof+0x1b1/0x470 mm/mempolicy.c:2270
>>     alloc_pages_noprof+0x7a/0xe0 mm/mempolicy.c:2347
>>     io_mem_alloc_compound io_uring/io_uring.c:2848 [inline]
>>     io_pages_map+0xb9/0x330 io_uring/io_uring.c:2892
>>     io_allocate_scq_urings+0x231/0x300 io_uring/io_uring.c:3933
>>     io_uring_create+0x29c/0x9c0 io_uring/io_uring.c:4091
>>     io_uring_setup+0xb6/0x100 io_uring/io_uring.c:4203
>>     __do_sys_io_uring_setup io_uring/io_uring.c:4230 [inline]
>>     __se_sys_io_uring_setup io_uring/io_uring.c:4224 [inline]
>>     __x64_sys_io_uring_setup+0x66/0xe0 io_uring/io_uring.c:4224
>>     x64_sys_call+0x1816/0x1d90 arch/x86/include/generated/asm/syscalls_64.h:426
>>     do_syscall_x64 arch/x86/entry/common.c:51 [inline]
>>     do_syscall_64+0x70/0x2a0 arch/x86/entry/common.c:81
>>     entry_SYSCALL_64_after_hwframe+0x76/0xe0
>>
>>    value changed: 0x00000000000002f4 -> 0x00000000000002f5
>>
>> nr_free is only updated with zone->lock held, but fast_isolate_freepages()
>> and fast_find_migrateblock() read it locklessly to skip an order that has
>> no free pages.  page_alloc.o is excluded from KCSAN, so the writer is not
>> instrumented and the report is of unknown origin.
>>
>> The race is benign: a stale zero only skips the order for this round, and
>> a stale non-zero just finds an empty MIGRATE_MOVABLE freelist under the
>> lock.  Annotate both reads with data_race(), following commit
>> af1c31acc853 ("mm/vmstat: annotate data race for zone->free_area[order].nr_free").
>>
>> No functional change intended.
>>
>> Signed-off-by: teawater <zhuhui@kylinos.cn>
> teawater? What?

Oops! Should be:

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>

>
>
>> ---
>>   mm/compaction.c | 12 ++++++++++--
>>   1 file changed, 10 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/compaction.c b/mm/compaction.c
>> index f1b2060eb2016..499ec7ceaa3ed 100644
>> --- a/mm/compaction.c
>> +++ b/mm/compaction.c
>> @@ -1601,7 +1601,11 @@ static void fast_isolate_freepages(struct compact_control *cc)
>>   		unsigned int order_scanned = 0;
>>   		unsigned long high_pfn = 0;
>>   
>> -		if (!area->nr_free)
>> +		/*
>> +		 * Access to nr_free is lockless as it is only a hint; a stale
>> +		 * value is harmless. Use data_race to avoid KCSAN warning.
>> +		 */
> The comment is noise, the reason of using data_race() is a well-known fact.
>
> Apart from that, do we have the same problem with zone_watermark_ok? It also
> uses area->nr_free without zone lock.

Yes, __zone_watermark_ok() has the same lockless read of area->nr_free
(mm/page_alloc.c:3646), but it does not need annotating.

mm/Makefile sets KCSAN_SANITIZE_page_alloc.o := n, and all writers of 
nr_free
live in that same translation unit (__add_to_free_list() at page_alloc.c:792
and __del_page_from_free_list() at page_alloc.c:843, both static 
inline). With
both sides uninstrumented, no watchpoint is ever installed and KCSAN cannot
report it.

That is also why the compaction report says "race at unknown origin": 
the read
side in compaction.c is instrumented, the writer in page_alloc.c is not, so
KCSAN infers the race without being able to attribute it
(kernel/kcsan/core.c:687). af1c31acc853 hit the same thing in vmstat.c.

The race is equally benign: a stale zero fails the watermark check and the
allocator retries; a stale non-zero passes it, and __rmqueue() re-checks 
under
zone->lock via find_suitable_fallback() (page_alloc.c:2266).

So annotating page_alloc.c:3646 would be a documentation-only change to 
another
subsystem, silencing a report that cannot occur. I'd keep this patch 
scoped to
mm/compaction. If the KCSAN exclusion for page_alloc.o is ever lifted, 
it will
need the annotation then -- but that means sweeping the whole file.

I also checked the remaining readers of free_area[].nr_free; all are under
zone->lock: show_mem.c:378, page_reporting.c:188, page_alloc.c:2266.

Best,
Hui

>> +		if (!data_race(area->nr_free))
>>   			continue;
>>   
>>   		spin_lock_irqsave(&cc->zone->lock, flags);
>> @@ -2031,7 +2035,11 @@ static unsigned long fast_find_migrateblock(struct compact_control *cc)
>>   		unsigned long flags;
>>   		struct page *freepage;
>>   
>> -		if (!area->nr_free)
>> +		/*
>> +		 * Access to nr_free is lockless as it is only a hint; a stale
>> +		 * value is harmless. Use data_race to avoid KCSAN warning.
>> +		 */
>> +		if (!data_race(area->nr_free))
>>   			continue;
>>   
>>   		spin_lock_irqsave(&cc->zone->lock, flags);

