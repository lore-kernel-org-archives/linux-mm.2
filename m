Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 186D2E9B250
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 11:32:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7ADAF6B0095; Tue, 24 Feb 2026 06:32:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7620B6B0098; Tue, 24 Feb 2026 06:32:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 664816B009B; Tue, 24 Feb 2026 06:32:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 52AB96B0095
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 06:32:25 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0138CC1EF0
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:32:24 +0000 (UTC)
X-FDA: 84479137050.02.19DA423
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf16.hostedemail.com (Postfix) with ESMTP id 86C03180017
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:32:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aGQXpr+L;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771932743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0sUWrbvtvOac8BzVrjFlUEtf6mDEIHrNMXT5s8eGfSo=;
	b=Y1q+iZgqimwImLNGDZJ6c/H+NtqWsUx2Rud9HtijsBz48mumrjEliKDalDRy/MjhM2AcF7
	XlhBs/Nf9WDoURbDi2AZRSamM2ECZr6zEjg2g961F8MsfFAu1VR+Z0sulM82PinveP+D/u
	WQoiwUF7w5BsmlTZtmnSGve0l7+zH/o=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aGQXpr+L;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771932743; a=rsa-sha256;
	cv=none;
	b=la48/PDgLctvBek5Sc+uomDZorNgc55q8Xn1LmozAk88Vm0wEHgDgHfCtsbWGydFVsbnQs
	xjNbiaR1ETVv9HYq2yiAlv0MzjokeJWVDj1gww7gcL28hEs4lOZlpioGyVlOu/F60ghvOk
	Ac5HmFh0McuDIIDxuzZpvaVn5Dnz7Gs=
Message-ID: <d8c66312-9961-448b-a786-27faf7a822a5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771932737;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0sUWrbvtvOac8BzVrjFlUEtf6mDEIHrNMXT5s8eGfSo=;
	b=aGQXpr+LFW5UzYlxmtjZAQfaKo3zEtunIzqMLPndRcd0xxFbuOjoWhJ0xxPlu+itItvZYR
	P+25P7pa5OxTJwsTEa3ITD0E2r7Nz4kjvl5jtsdytuZSl3rG8uPtk0+Msf9/Yo4qqAmxMt
	uJ49Hwu6106BiPXR3FnUesDHnVw7NJY=
Date: Tue, 24 Feb 2026 19:32:08 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/1] mm/mmu_gather: replace IPI with synchronize_rcu()
 when batch allocation fails
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 peterz@infradead.org
Cc: dave.hansen@intel.com, will@kernel.org, aneesh.kumar@kernel.org,
 npiggin@gmail.com, linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260224030700.35857-1-lance.yang@linux.dev>
 <d5c90e6b-9dc9-4524-bcd7-534e311beec2@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <d5c90e6b-9dc9-4524-bcd7-534e311beec2@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: g6w3iprohdf4muawrcp8ax8s1hwntz5z
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 86C03180017
X-HE-Tag: 1771932741-687311
X-HE-Meta: U2FsdGVkX1+PO1/U49J9CamSY9PUIbuE36aEyig3F1ZAh1IF6/BEe7s8TkiOuVYi6/uZCuQM2sOcenqIdfvPvNxERDV1HWfTL7sx8q4ITw05nqnxmb5A86pIOO3kgzHA+XYj0eKvr6S0BMnwNwQGByk9rCBfXT9nESCmLSzjQU4BBj6EWaK2En7Z4Nbi75oV6lBD8/R7cQRB0vOq9oFQxV+QXvs34khR755BpNKNKTEtKiAEkMawHSnZlywCDH3Bbc3oT5kajUwZuF7mzA3GFhFH79IP1R97GmL2OdP61AJn/NSBAS0SIJEQItoF2UkHsbsKr8bWAy6+uis1M2oCVW/y0VBOaLEuW8SBGrEg3KxcL2HS2uqT9W4ilSOj7IRQrg4XCgyi9nuAp1ZpUac7cBGdQxncOQpJE8w5feoGkn65Rg20JgasscThVzVfSygI9QS/NDBvJBMGXMTrZTWkORtwIyPDHCL/lziJiRe73MnshjX8aNGC0IFmsFOvRpz6J1E4QcmDmbam6xQt8yg1qNVnB0fSQDgLS8jcqnkpfFbaekb6fFhwruQFLsQw7PBY/6fMilWXuufcLExu+Asl11GYZHSgeY+Fh7CDMeyKsmAy3h54SmJr4hW7Q9UASH5M1F1pbyJhUIAjE7u5HXmLHOMuCE/9v1Gtdy8sJbBD5ChMIFTyWNQoRv4HG0v/zbYWTjIJ5IeZXmIOl1R5FeGzWxC9dR45d9xnm8i/zTWNkIiz4E38tHl5Vru6Cvl5QtHr92RhVpa9ZiJWKXiQp5iyhmEnUMtNvLHhON1k/SqRYGK2J8DHm3Tlaz+wKYbt4dWzSyWL62TAPK2prXLGtmOEvS3669JLiNHOyqjAvCfjOSwO6/uH1S4c/d20tZAK1RnoVeQs7XOD3fMr0MqZdzA3505NgEUya/uaH7N8qThOOCQZXJuoVo+VIOnqJhQL1cJ5bftcRQmtUsnx4QD8SlM
 7xTQR0Vy
 8YJVlrvN3MliOPTPKSt3NBvGtRf08qWUhQiX8rp8FxZzlX9BvoRVIIPktIGhqW9+hqJqiepWEjqMq1gGIMWcrAihBv6Wyn+QXT7+NO/V77M6jID51MZRXprCBhduSq4tTUwlfV/MbWw8uUStafQ0R3IqobnulteHsV1oc5OadVFiN++q9sl/Wq42A7Stwj7etZ6L20FZJMTRbYjaK1r9Wu8nUdPLDiqRElcj556EVS5X6Cb4UIKmti6K8Y7lJcQfWuWIqmGtJUHtzsNooSKnteTLcKSyy01ZHkwGDI/rIV2zleM/nOol3441nZodiusfnKsyp4tFX2LWJsyVBeX4+l0p96d+BrRB7hN/amg0aXCzMcgAYXR90qX6LwWJlW9TaaQpkM76ROaamNSrhFSZGPsURNDkkjNMs1kMbIM57cxAW2EI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/2/24 19:04, David Hildenbrand (Arm) wrote:
> On 2/24/26 04:07, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> When freeing page tables, we try to batch them. If batch allocation fails
>> (GFP_NOWAIT), __tlb_remove_table_one() immediately frees the one without
>> batching.
>>
>> On !CONFIG_PT_RECLAIM, the fallback sends an IPI to all CPUs via
>> tlb_remove_table_sync_one(). It disrupts all CPUs even when only a single
>> process is unmapping memory. IPI broadcast was reported to hurt RT
>> workloads[1].
>>
>> tlb_remove_table_sync_one() synchronizes with lockless page-table walkers
>> (e.g. GUP-fast) that rely on IRQ disabling. These walkers use
>> local_irq_disable(), which is also an RCU read-side critical section.
>>
>> This patch introduces tlb_remove_table_sync_rcu() which uses RCU grace
>> period (synchronize_rcu()) instead of IPI broadcast. This provides the
>> same guarantee as IPI but without disrupting all CPUs. Since batch
>> allocation already failed, we are in a way slow path where sleeping is
>> acceptable - we are in process context (unmap_region, exit_mmap) with only
>> mmap_lock held. might_sleep() will catch any invalid context.
>>
>> [1] https://lore.kernel.org/linux-mm/1b27a3fa-359a-43d0-bdeb-c31341749367@kernel.org/
>>
>> Link: https://lore.kernel.org/linux-mm/20260202150957.GD1282955@noisy.programming.kicks-ass.net/
>> Link: https://lore.kernel.org/linux-mm/dfdfeac9-5cd5-46fc-a5c1-9ccf9bd3502a@intel.com/
>> Link: https://lore.kernel.org/linux-mm/bc489455-bb18-44dc-8518-ae75abda6bec@kernel.org/
>> Suggested-by: Peter Zijlstra <peterz@infradead.org>
>> Suggested-by: Dave Hansen <dave.hansen@intel.com>
>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>> v1 -> v2:
>> - Wrap synchronize_rcu() in tlb_remove_table_sync_rcu() with proper
>>    kerneldoc (per David)
>> - Add might_sleep() to make sleeping constraint explicit (per Dave)
>> - Clarify this is for synchronization, not memory freeing (per Dave)
>> - https://lore.kernel.org/linux-mm/20260223033604.10198-1-lance.yang@linux.dev/
>>
>>   include/asm-generic/tlb.h |  4 ++++
>>   mm/mmu_gather.c           | 22 +++++++++++++++++++++-
>>   2 files changed, 25 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
>> index 4aeac0c3d3f0..bdcc2778ac64 100644
>> --- a/include/asm-generic/tlb.h
>> +++ b/include/asm-generic/tlb.h
>> @@ -251,6 +251,8 @@ static inline void tlb_remove_table(struct mmu_gather *tlb, void *table)
>>   
>>   void tlb_remove_table_sync_one(void);
>>   
>> +void tlb_remove_table_sync_rcu(void);
>> +
>>   #else
>>   
>>   #ifdef tlb_needs_table_invalidate
>> @@ -259,6 +261,8 @@ void tlb_remove_table_sync_one(void);
>>   
>>   static inline void tlb_remove_table_sync_one(void) { }
>>   
>> +static inline void tlb_remove_table_sync_rcu(void) { }
>> +
>>   #endif /* CONFIG_MMU_GATHER_RCU_TABLE_FREE */
>>   
>>   
>> diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
>> index fe5b6a031717..2c6fa8db55df 100644
>> --- a/mm/mmu_gather.c
>> +++ b/mm/mmu_gather.c
>> @@ -296,6 +296,26 @@ static void tlb_remove_table_free(struct mmu_table_batch *batch)
>>   	call_rcu(&batch->rcu, tlb_remove_table_rcu);
>>   }
>>   
>> +/**
>> + * tlb_remove_table_sync_rcu() - synchronize with software page-table walkers
> 
> Nit: no need for the "()"

Oops, @Andrew could you drop the "()" here when applying?

> 
> Thanks!
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks for taking time to review!

