Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA21EE9B258
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 12:19:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9E6F6B0088; Tue, 24 Feb 2026 07:19:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6F686B0089; Tue, 24 Feb 2026 07:19:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9CB56B008A; Tue, 24 Feb 2026 07:19:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B6B966B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 07:19:00 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4CCFE8BE52
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 12:19:00 +0000 (UTC)
X-FDA: 84479254440.20.76D6983
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3725F40003
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 12:18:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=skyN0xnR;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771935538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EwzxsqX59s+nykKGKsV+/BFhtEGlW2DTi98NYRGnb4k=;
	b=Yr1qO5c2c0rbiiYz1l85Nsl3SFo3frgmqKCnmElqS0CBpqmr/P7b+wZtRCf6JOxEdn0nmz
	MRf2KZ7k9hZVYfvcNQhtS1S7lv0PFvT+NFUQuEaopKwxSaupLVpzvTvbjQ8XGn4jqd00q4
	Q7aqhP6caMgYQB8vl1O3Nef6KnE6ToA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771935538; a=rsa-sha256;
	cv=none;
	b=G0KxVMux3E339b2CpU1KRHa0aSs8CNpvlIgh0hWjAyDvAViiB8ZNHKXm+UB09cfNKAeuPu
	vAXi7BCZyOfAYWjxVMDtay93EyWHujf4+suco+SxPuPnpha1OssueO2KRZoS05MfGdEosl
	jU/nGV+ZUfGQ4xVxcWwKgq/0I/Ul0F0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=skyN0xnR;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <5cc90e7a-ae32-4352-8e0b-2eee5a5ee122@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771935535;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EwzxsqX59s+nykKGKsV+/BFhtEGlW2DTi98NYRGnb4k=;
	b=skyN0xnRjwRgE04aLNLlLTrPx8oL4jHzrR0//J5EgUt8UGZeWhbyo6JsPyzz7fgoYbBl+q
	tmcEamzE/HoZRWqgxEyscc1vh59cFCapGF5WwILOMLW/SWiPe2yExbx5gWCfIPXoqn1tEB
	XgjVifKLg9ce4HG6BA34Phgl+hyuXjQ=
Date: Tue, 24 Feb 2026 20:18:46 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/1] mm/mmu_gather: replace IPI with synchronize_rcu()
 when batch allocation fails
Content-Language: en-US
To: Peter Zijlstra <peterz@infradead.org>
Cc: akpm@linux-foundation.org, david@kernel.org, dave.hansen@intel.com,
 will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
 linux-arch@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260224030700.35857-1-lance.yang@linux.dev>
 <20260224114152.GX1395266@noisy.programming.kicks-ass.net>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260224114152.GX1395266@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Stat-Signature: kwaqm7g4s4qe4xt3az6oo3xix33jrws3
X-Rspamd-Queue-Id: 3725F40003
X-Rspam-User: 
X-HE-Tag: 1771935537-89240
X-HE-Meta: U2FsdGVkX182y/1g4AyczlkpTAlZDgmNR+cYOzoT0oAFeMZOkHVbzJ7BDrxNcEr9TOl1se1KZ7NR0fvq0FXvs8NoyfxDmf9HF6/iuG3f2BhlK+UXwXSE0S5ouhXyiRqD0LKVOQPhmrtjaeHdCHjpcOQOrdbVnfYkIviHsfKhsKtKRmQ72T89CZ1u9jWCmaVAcCmtiB+CSKLZNymdGOsPhW0RPs07M3tERZciG3tagRVRi8U6UuFCUoJfd12b1jQI2lYmjMIGNXE1Ywbfm5DaEgcNUwJ0ESN334eoFRGgrsE1nKZSVIUfledYgwriB4x3+GU3sdXqydAIPMctp4szrXymwsOoHNmJlrfZZF12/iwI0zTDf9T4Ad1amevb1XUjVARylaO+JVPNDdqDgeHOVp7CA0inTcraEX5y1lqseV5R79Zf9fR+uiF8aQZIcMvuqkuA741TcXfYnfMRNxvZa0vOyDnfXU65zVaM5XhV970LeTD6uc1lrIlpbp3Qy+Sb6LvwII5+JZq6zCnxachsTPMEwwwBNvcI4wgan5sXFZ+vllMU+vjIWwf+CVUcQuzUp0C1vu30q1O/GTuEmqgOMrDATNX0v87m7fsb48slm/k/NtsCEm75ZUqINuHurkEVxIGdnExzd1sbr+SQ7wUuv6xiQvteILSrWHXwBwDrGl6sBeqNDrh9L5Y9U6DBbZXlnFuEo7UvUpldPaG9twhcyS1d1OgeOa5h37FHPb90lbg8/e+p4DE8lz1fq7fL66oNpLy99HBbjb1eTMpE+FydEqMtJ5rDZ4vEe7VgobncbtJBUDp3pCkZDPV0lVULDJWNps7qY2amDvYyMUhcQ/uTeptpBOgH6BB+dtxZF5XM36YYLEYmu//QI2DcXyEUuUU4t+9uXlAz4qa+6XwP//itmeWW7ltMgB4mPZs2Dk/D+JEaP1gIXL5iknX5ggdlWGZEM7O9ul3NvtdnnGQ5+gG
 WHb/JLro
 61smdA3ZSpPfEgAsFjv7srP2yJM/ZlfVEkeSKAEeakMAZbraJV3DFeNwpfFILqGtdJUUsHkZxTTH2tc2ahgCOxR8EqsUj3opBefP6HossGv1/Ok1b5HtOwByUEvuVeyXILDUntnz7SlFmZRt4T8OlGxtL+ft+aGnfOy/0ZtnL5MQEvM23Kw0jsvtKKGXO/i1TC18vo93Cey48X/xOcSNVOVAm7PRJ2Tjdzl7xuFRWo9XtQ5o/8FpTY+fkvE6t6RAu9CuU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/2/24 19:41, Peter Zijlstra wrote:
> On Tue, Feb 24, 2026 at 11:07:00AM +0800, Lance Yang wrote:
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
> 
> So sending the IPIs also requires non-atomic context, so change there.

Yeah, you're right!

> What isn't explained, and very much not clear to me, is why
> tlb_remove_table_sync_one() is retained?

Good point. tlb_remove_table_sync_one() is still needed in:

1) khugepaged (mm/khugepaged.c) - after pmdp_collapse_flush()
2) tlb_finish_mmu() (tlb.h) - when tlb->fully_unshared_tables
3) ...

These are not slow paths like batch allocation failure. This patch only
converts this obvious slow path first.

I'm working on converting the remaining callers as well, but not with
RCU, looking at other options (e.g. targeted IPI).

> 
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
>> + *
>> + * Like tlb_remove_table_sync_one() but uses RCU grace period instead of IPI
>> + * broadcast. Use in slow paths where sleeping is acceptable.
>> + *
>> + * Software/Lockless page-table walkers use local_irq_disable(), which is also
>> + * an RCU read-side critical section. synchronize_rcu() waits for all such
>> + * sections, providing the same guarantee as tlb_remove_table_sync_one() but
>> + * without disrupting all CPUs with IPIs.
>> + *
>> + * Do not use for freeing memory. Use RCU callbacks instead to avoid latency
>> + * spikes. Cannot be called from any atomic context.
>> + */
>> +void tlb_remove_table_sync_rcu(void)
>> +{
>> +	might_sleep();
>> +	synchronize_rcu();
> 
> synchronize_rcu() should end up in a might_sleep() at some point if it
> blocks (which it typically will).

Right, will drop the explicit might_sleep() and "Cannot be called from
any atomic context" from kerneldoc since both have the same requirements.

Thanks,
Lance

