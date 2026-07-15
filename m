Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F1F9C44507
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 01:18:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F2046B0092; Tue, 14 Jul 2026 21:18:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A20A6B0093; Tue, 14 Jul 2026 21:18:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 591446B0095; Tue, 14 Jul 2026 21:18:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 287B56B0092
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 21:18:35 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BBFC0A056E
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 01:18:34 +0000 (UTC)
X-FDA: 84989250948.27.481A1A6
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7E21A1C0006
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 01:18:31 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	spf=pass (imf20.hostedemail.com: domain of wangxuewen@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=wangxuewen@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784078312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OkMKVk4P0PbcXWc3yKxkzG+LWPnUfDIOgq8qFX2TSSg=;
	b=hKQxxufJj4adLj0U6MuVydmsSTycFuI6sV7y09C2hIVNlS6Xph/WqpDaNCHUqjZLeB7Oti
	UV+gspOSqd72XMOLlazvmfNg7GRwwio4fkdvnD/hqe91VKZnaYlU/E5nxEhxYk6F9DKmOH
	Pka595fwVFTg4+0Pa+OQxA71I6rna0A=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of wangxuewen@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=wangxuewen@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784078312;
	b=J72p0l7jUj9W1MOCG/49kSq7NxKo3Xd8fUnTmFuqmrkoI/3eNSwVpeEwk1kPr3TT/V92pb
	gnoFq4zUGWKuzikFfrkmGAh/UQClJCR+M9EpBFnceiFP4BH86JGQoEs6yOWdOxVAmC/nq4
	TtYnLHOJS8GxyQbOiLWIs/QoPMoGGGs=
X-UUID: 1376776e7feb11f1aa26b74ffac11d73-20260715
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:1688ebe3-db3a-448c-8430-08ac806101eb,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.12,REQID:1688ebe3-db3a-448c-8430-08ac806101eb,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:e7bac3a,CLOUDID:ac62efcc4b2e0075817572b3d91bb13b,BulkI
	D:260714220020ZHYS69O7,BulkQuantity:1,Recheck:0,SF:17|19|64|66|78|80|81|82
	|83|102|127|841|865|898,TC:nil,Content:0|15|52,EDM:-3,IP:-2,URL:0,File:nil
	,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,D
	KP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1376776e7feb11f1aa26b74ffac11d73-20260715
X-User: wangxuewen@kylinos.cn
Received: from [192.168.109.138] [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <wangxuewen@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 2114387964; Wed, 15 Jul 2026 09:18:24 +0800
Message-ID: <f1ef3691-f903-4d14-9805-c074a5980007@kylinos.cn>
Date: Wed, 15 Jul 2026 09:18:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm/kasan: fix swapped read/write lock usage in stack
 ring
To: Andrey Konovalov <andreyknvl@gmail.com>
Cc: ryabinin.a.a@gmail.com, glider@google.com, dvyukov@google.com,
 vincenzo.frascino@arm.com, akpm@linux-foundation.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260714081408.1596052-1-wangxuewen@kylinos.cn>
 <CA+fCnZcyZZAwhVpVe+PQfjNiS5XaZE8UGDocxnxYPxpX48+mxA@mail.gmail.com>
From: Xuewen Wang <wangxuewen@kylinos.cn>
In-Reply-To: <CA+fCnZcyZZAwhVpVe+PQfjNiS5XaZE8UGDocxnxYPxpX48+mxA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7E21A1C0006
X-Stat-Signature: pzud9djjwy5dqs9qx69akbhk94rpoifh
X-HE-Tag: 1784078311-130319
X-HE-Meta: U2FsdGVkX199TTePXFzs8PZt12lzYN2mpDtM4XAcMNOKnE1XKk4VdE9DRE5iR3/ypAReE1LdstPp6NRUCw+Jp+atgZac6m4mExTY0CWbR9xNINslv/AlvJ9OHJPaWRaV46MKKnqXOVJFf0VADS8HRqYwoz0G3XOurr2To5bna5SVLI66UxyY/mGsh76GhUmgJsoxy5SOg+NY2N73+L1L0heVkE3bwhYpqCbHFBvs2o2fk8ErT7QSA8ubeLYlr+G1+NT6u0PrI7TEB/YdnXe9ktwXpsFmyoNJo+f5Eol2eNq4Fi+tyFgovK913JipcFIZCDK04UmWWncFmIUcD0RfIyvdy6sGewWIvr+KaW9zxGkBNalg0UZ5ZNs09jokxEo0wGpT4Vg9DjwZzHUtT3Tbp2iZS3358T4aEZJvuXHeB0rNRZBGIMbchSJAVstKra4dFfkxleAv4PXxBlkMGF9zIZoaM7g25Y9AOpq4iHxxvFklAroM+MqgjQXJKKJmNtQXPcOIQXl2QHwXixKZ4SwgioxeUSZv3gijhn34xsD8ykanw4EMGHSzLC4PtL0WSkoHhcPekuRKfe4ORajShmNPRRY/MJN8y/mvpMboi1nFosjYwXBQmq6u0V6jJg6hjmwVTqkF6MsndiCi/udB6LHDCih1g094CgVcfbqyxLwl5OCWsVgmtVbDtDjxCJL5HufJt2K/cdA2kCMDgekW1dT2OimOb0k1trD5TWdKY5x9HGmW60Gz5oulEuEpARChiemVw4wMJ8n6Mjb/QZq96xY9V9OxNTV+TzN+67spfcwR9lTc1XdghSR4j4n5vMv5vb7uwj2kZqIjdzwynk7QA/K59OXVuj57F4Wv0oquDjV6gYxUSCUvJrGFVpiXSq9LaVV9ftu9QYNr98sWfNuv0uyyycEvv8gQOA/r9GaMD4Cf3L1BfMiGSWm06Gz8/Wnb71F33QHt/eWpGjn0k8YWa9D
 0VY69B7J
 arqIgV8LgZGXIkKt2D91UrXAN1Z0DDnpDrKqxwbGPuB2Crj6eiha0dFA4yGMqrhav0V4OZrC9s+0pUOvuh5Z0Ksv/uqylrWUCUY4Fa7VZDczkwqYlX7MUObb3+FRyr8WQBSDnx/Sdll876T9RdH7D4/pW4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrey,
Thank you for your clarification and correction.
I misunderstood the design intention of this rwlock before. I only judged it from conventional read-write lock semantics, and failed to notice that concurrent writes are guaranteed by slot-level atomic operations and cmpxchg reservation. The lock is specifically used to serialize the report path against all writers, while allowing multiple save_stack_info() instances to run in parallel without lock contention.
This patch is not appropriate, so I will drop it and not proceed with a new version.
Thanks again for your guidance.
Best regards,
Xuewen Wang

在 2026/7/14 21:59, Andrey Konovalov 写道:
> On Tue, Jul 14, 2026 at 10:14 AM Xuewen Wang <wangxuewen@kylinos.cn> wrote:
>>
>> The read-write lock semantics for stack_ring.lock are inverted:
>>
>> - save_stack_info() modifies stack ring entries but uses read_lock,
>>   which does not protect against concurrent writers and does not
>>   block readers from observing partial updates.
>> - kasan_complete_mode_report_info() only reads the stack ring but
>>   uses write_lock_irqsave(), which prevents concurrent readers from
>>   walking the ring simultaneously.
>>
>> Swap the lock types to match their actual access patterns:
>> - save_stack_info(): read_lock -> write_lock
>> - kasan_complete_mode_report_info(): write_lock -> read_lock
>>
>> Fixes: 7bc0584e5d2a ("kasan: implement stack ring for tag-based modes")
>> Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
>> ---
>>  mm/kasan/report_tags.c | 4 ++--
>>  mm/kasan/tags.c        | 4 ++--
>>  2 files changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/kasan/report_tags.c b/mm/kasan/report_tags.c
>> index d15f8f580e2c..62576b1470e1 100644
>> --- a/mm/kasan/report_tags.c
>> +++ b/mm/kasan/report_tags.c
>> @@ -39,7 +39,7 @@ void kasan_complete_mode_report_info(struct kasan_report_info *info)
>>                 return;
>>         }
>>
>> -       write_lock_irqsave(&stack_ring.lock, flags);
>> +       read_lock_irqsave(&stack_ring.lock, flags);
>>
>>         pos = atomic64_read(&stack_ring.pos);
>>
>> @@ -99,7 +99,7 @@ void kasan_complete_mode_report_info(struct kasan_report_info *info)
>>                 }
>>         }
>>
>> -       write_unlock_irqrestore(&stack_ring.lock, flags);
>> +       read_unlock_irqrestore(&stack_ring.lock, flags);
>>
>>         /* Assign the common bug type if no entries were found. */
>>         if (!info->bug_type)
>> diff --git a/mm/kasan/tags.c b/mm/kasan/tags.c
>> index d65d48b85f90..6aa09122f09e 100644
>> --- a/mm/kasan/tags.c
>> +++ b/mm/kasan/tags.c
>> @@ -110,7 +110,7 @@ static void save_stack_info(struct kmem_cache *cache, void *object,
>>          * Prevent save_stack_info() from modifying stack ring
>>          * when kasan_complete_mode_report_info() is walking it.
>>          */
>> -       read_lock_irqsave(&stack_ring.lock, flags);
>> +       write_lock_irqsave(&stack_ring.lock, flags);
>>
>>  next:
>>         pos = atomic64_fetch_add(1, &stack_ring.pos);
>> @@ -131,7 +131,7 @@ static void save_stack_info(struct kmem_cache *cache, void *object,
>>
>>         entry->ptr = object;
>>
>> -       read_unlock_irqrestore(&stack_ring.lock, flags);
>> +       write_unlock_irqrestore(&stack_ring.lock, flags);
>>
>>         if (old_stack)
>>                 stack_depot_put(old_stack);
>> --
>> 2.25.1
>>
> 
> This is no good.
> 
> RW lock here is used to prevent kasan_complete_mode_report_info() from
> running concurrently with save_stack_info(). But multiple
> save_stack_info() must be allowed to execute concurrently without
> contending for a lock. Concurrent writes coming from multiple
> save_stack_info() executing at the same time are handled via
> atomic64_fetch_add/try_cmpxchg() slot reservation.


