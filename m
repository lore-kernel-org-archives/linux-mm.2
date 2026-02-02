Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A5ABE7315A
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 12:15:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DC356B0099; Mon,  2 Feb 2026 07:15:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55FDC6B00A5; Mon,  2 Feb 2026 07:15:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 437F46B00A6; Mon,  2 Feb 2026 07:15:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2FB126B0099
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 07:15:01 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 55D851AFA45
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 12:15:00 +0000 (UTC)
X-FDA: 84399410760.10.2EC5700
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4A21A8000B
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 12:14:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=c43ucQG9;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770034498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jituq4TCCBnJRRiPEJzrUjf8Tl3pN0KvOPn2lg/6vfc=;
	b=utz6jrY78gE+oPspCim/1RWKqM5IPTRjVnpLdM8RwXrbMY7Sf595Fq6YDsxdVJCqfymAMr
	WjaQ0NM8xUMtMpnEBKFsYi93QKe04/Plqzjx4hG9JUdGhP3wgG1yCHiVDLtvnsu4wJ4gNx
	uFg/CBM12LscaLssfbYNxKQgC7rW7Vk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=c43ucQG9;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770034498; a=rsa-sha256;
	cv=none;
	b=5yfnyrZq55iPwXajJBWrEFRSgsAM1+1XImf6I3JZwlNXg8wIYce5iAbNZa6PKSiyF+y0Y0
	+PGnmBRKoKEDRbPN+gcIKYvkqNqLAMMR1t3NNCtfVTBfYMSHYz1uEbAcHIAYhLBz0xT/+A
	JH7afyz8uYzxaOgX8ytFQA07K2Dl6e8=
Message-ID: <0f44dfb7-fce3-44c1-ab25-b013ba18a59b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770034495;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jituq4TCCBnJRRiPEJzrUjf8Tl3pN0KvOPn2lg/6vfc=;
	b=c43ucQG9ejToxHXbWiUtSl7n+JmaAbVKsyyyHJ67d+OURnCrLJ1c7JPyZwM8bBK+3f7Xbx
	WcuCypGqT3+1lpn5LaGRnO61hbdZX5On3WJ1PuhqJicfTM70UlMTt2ktFd2ZJ/Cy+RtXxT
	d+dpXXZfc5SXdF6be85Pzf8UNBt0izw=
Date: Mon, 2 Feb 2026 20:14:32 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4 1/3] mm: use targeted IPIs for TLB sync with lockless
 page table walkers
Content-Language: en-US
To: Peter Zijlstra <peterz@infradead.org>
Cc: akpm@linux-foundation.org, david@kernel.org, dave.hansen@intel.com,
 dave.hansen@linux.intel.com, ypodemsk@redhat.com, hughd@google.com,
 will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, arnd@arndb.de, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 shy828301@gmail.com, riel@surriel.com, jannh@google.com, jgross@suse.com,
 seanjc@google.com, pbonzini@redhat.com, boris.ostrovsky@oracle.com,
 virtualization@lists.linux.dev, kvm@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ioworker0@gmail.com
References: <20260202074557.16544-1-lance.yang@linux.dev>
 <20260202074557.16544-2-lance.yang@linux.dev>
 <20260202094245.GD2995752@noisy.programming.kicks-ass.net>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260202094245.GD2995752@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: wshz15y5jt7n3gmh3f15daowm9xtxfnh
X-Rspamd-Queue-Id: 4A21A8000B
X-Rspam-User: 
X-HE-Tag: 1770034498-360889
X-HE-Meta: U2FsdGVkX19i2piRSgHi40jFFxuolkJO4JvQOjKEGszNQR6pIVN6e5Bh421lbXKvMk1fdPCmSX3MwWgAOEtonMR6jgtG5tK/u2oYMKVqB5tQWQOGvZx58rq5JodMV/IVc23RPXbkb9QdP4FfUX/XQoKizWEBJ0ger0RSCHJAQwzvwJCDrfOj7NchBUANzwR8xKJgf37ALukfIR6p6UhPOav40knLYc7wJbemJjXXoQ59/3F42lvW06Xa8LBPCUQUuRT4ZXupcBL26BnwgM2SWK5AX7k5zIow0Mcym/cRl7k+4BxpB/iqYn69TWTftPu/2VnGb2+CsQp05Vsuxh2TLSqAoAsVwbP5XKxWley4+EQiFa+gNuvPP/+6bZWocrt6/ciMUJEek7l7L86yztMYrvBXZFnCYmcswXh+9/pxdIkXDbGc8x74l2SkjYvwV/0MosFJXXw/pG/jwkjchITo5dDOMMo3UnVr2PLE0dpRIVi6AoWLIW43C7wyRk8ny7GWR+NHsMrG/PxSxCl5cfJWBiMtmky2iVwepNOrLDtyXdeVjY3UagMrfN8trBGbom0JC7ok6iurJ4+xzeWEr0kqScTc4is/jcthjVpoWBiwQjjFa8ps68C2qZYwvf8NMYVPaL7ygttYuhHDJJdpVMoqjvb5ZB16gKQsPGvU2JmrrA1JbaWGeEOy209Qd3kQPBZyWote33zqa/5Ggw95YCpFinub98bKPinPxBvlUyHt4ECqRMGMme3Pu5TOhscIbt4sU8jM97hmL/7morLNC6FNRFQG0aPJwuDLtzhEL7Z6KZGasq+AmiJL77/91lIKy+ggZDYculqWs4M51sI/PsIbPsij8F8Uvi2g/jjbLg2z9WhMbCaETOUuFWR8b0MZfD0mxPN3PBLeCYszqtei+JccHriTLi+OoiIDtFYq1JIRZ6hv1lTz1pHF5T+1z1sTJNPTZjK9TIK6eBw7KW1f4om
 D/39lkIh
 +Nw4s8rO6YkeLQ7HjyFUA0+Dpn8ajLpV6F3mT3gD2oyl+d4+kw7JHm36Ryzg0WJecEir47f4NZU6fmvBBLN7+IBBEE1a8DynC58hf2Hfe+dB/FvtMTclLdZGTq3cXLMJIrh6bvA/HStgawCddqA8oJ2kC1suF4JxwGv6xLNagnQKZLSf1/OhQMqxNDWxc9jnKeNjKGiB2uzh6OaLQeAMAIse01Iakc8hAKCLb0KK/JZ6FIE3Ev2BNu8U1dQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Peter,

Thanks for taking time to review!

On 2026/2/2 17:42, Peter Zijlstra wrote:
> On Mon, Feb 02, 2026 at 03:45:55PM +0800, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> Currently, tlb_remove_table_sync_one() broadcasts IPIs to all CPUs to wait
>> for any concurrent lockless page table walkers (e.g., GUP-fast). This is
>> inefficient on systems with many CPUs, especially for RT workloads[1].
>>
>> This patch introduces a per-CPU tracking mechanism to record which CPUs are
>> actively performing lockless page table walks for a specific mm_struct.
>> When freeing/unsharing page tables, we can now send IPIs only to the CPUs
>> that are actually walking that mm, instead of broadcasting to all CPUs.
>>
>> In preparation for targeted IPIs; a follow-up will switch callers to
>> tlb_remove_table_sync_mm().
>>
>> Note that the tracking adds ~3% latency to GUP-fast, as measured on a
>> 64-core system.
> 
> What architecture, and that is acceptable?

x86-64.

I ran ./gup_bench which spawns 60 threads, each doing 500k GUP-fast
operations (pinning 8 pages per call) via the gup_test ioctl.

Results for pin pages:
- Before: avg 1.489s (10 runs)
- After:  avg 1.533s (10 runs)

Given we avoid broadcast IPIs on large systems, I think this is a
reasonable trade-off :)

> 
>> +/*
>> + * Track CPUs doing lockless page table walks to avoid broadcast IPIs
>> + * during TLB flushes.
>> + */
>> +DECLARE_PER_CPU(struct mm_struct *, active_lockless_pt_walk_mm);
>> +
>> +static inline void pt_walk_lockless_start(struct mm_struct *mm)
>> +{
>> +	lockdep_assert_irqs_disabled();
>> +
>> +	/*
>> +	 * Tell other CPUs we're doing lockless page table walk.
>> +	 *
>> +	 * Full barrier needed to prevent page table reads from being
>> +	 * reordered before this write.
>> +	 *
>> +	 * Pairs with smp_rmb() in tlb_remove_table_sync_mm().
>> +	 */
>> +	this_cpu_write(active_lockless_pt_walk_mm, mm);
>> +	smp_mb();
> 
> One thing to try is something like:
> 
> 	xchg(this_cpu_ptr(&active_lockless_pt_walk_mm), mm);
> 
> That *might* be a little better on x86_64, on anything else you really
> don't want to use this_cpu_() ops when you *know* IRQs are already
> disabled.

Ah, good to know that. Thanks!

IIUC, xchg() provides the full barrier we need ;)

> 
>> +}
>> +
>> +static inline void pt_walk_lockless_end(void)
>> +{
>> +	lockdep_assert_irqs_disabled();
>> +
>> +	/*
>> +	 * Clear the pointer so other CPUs no longer see this CPU as walking
>> +	 * the mm. Use smp_store_release to ensure page table reads complete
>> +	 * before the clear is visible to other CPUs.
>> +	 */
>> +	smp_store_release(this_cpu_ptr(&active_lockless_pt_walk_mm), NULL);
>> +}
>> +
>>   int get_user_pages_fast(unsigned long start, int nr_pages,
>>   			unsigned int gup_flags, struct page **pages);
>>   int pin_user_pages_fast(unsigned long start, int nr_pages,
> 
>> diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
>> index 2faa23d7f8d4..35c89e4b6230 100644
>> --- a/mm/mmu_gather.c
>> +++ b/mm/mmu_gather.c
>> @@ -285,6 +285,56 @@ void tlb_remove_table_sync_one(void)
>>   	smp_call_function(tlb_remove_table_smp_sync, NULL, 1);
>>   }
>>   
>> +DEFINE_PER_CPU(struct mm_struct *, active_lockless_pt_walk_mm);
>> +EXPORT_PER_CPU_SYMBOL_GPL(active_lockless_pt_walk_mm);
> 
> Why the heck is this exported? Both users are firmly core code.

OK. Will drop this export.

> 
>> +/**
>> + * tlb_remove_table_sync_mm - send IPIs to CPUs doing lockless page table
>> + * walk for @mm
>> + *
>> + * @mm: target mm; only CPUs walking this mm get an IPI.
>> + *
>> + * Like tlb_remove_table_sync_one() but only targets CPUs in
>> + * active_lockless_pt_walk_mm.
>> + */
>> +void tlb_remove_table_sync_mm(struct mm_struct *mm)
>> +{
>> +	cpumask_var_t target_cpus;
>> +	bool found_any = false;
>> +	int cpu;
>> +
>> +	if (WARN_ONCE(!mm, "NULL mm in %s\n", __func__)) {
>> +		tlb_remove_table_sync_one();
>> +		return;
>> +	}
>> +
>> +	/* If we can't, fall back to broadcast. */
>> +	if (!alloc_cpumask_var(&target_cpus, GFP_ATOMIC)) {
>> +		tlb_remove_table_sync_one();
>> +		return;
>> +	}
>> +
>> +	cpumask_clear(target_cpus);
>> +
>> +	/* Pairs with smp_mb() in pt_walk_lockless_start(). */
> 
> Pairs how? The start thing does something like:
> 
> 	[W] active_lockless_pt_walk_mm = mm
> 	MB
> 	[L] page-tables
> 
> So this is:
> 
> 	[L] page-tables
> 	RMB
> 	[L] active_lockless_pt_walk_mm
> 
> ?

On the walker side (pt_walk_lockless_start):

  [W]  active_lockless_pt_walk_mm = mm
  MB
  [L] page-tables (walker reads page tables)

So the walker publishes "I'm walking this mm" before reading page tables.

On the sync side we don't read page-tables. We do:

  RMB
  [L] active_lockless_pt_walk_mm (we read the per-CPU pointer below)

We need to observe the walker's store of active_lockless_pt_walk_mm before
we decide which CPUs to IPI.

So on the sync side we do smp_rmb(), then read active_lockless_pt_walk_mm.

That pairs with the full barrier in pt_walk_lockless_start().

> 
>> +	smp_rmb();
>> +
>> +	/* Find CPUs doing lockless page table walks for this mm */
>> +	for_each_online_cpu(cpu) {
>> +		if (per_cpu(active_lockless_pt_walk_mm, cpu) == mm) {
>> +			cpumask_set_cpu(cpu, target_cpus);
> 
> You really don't need this to be atomic.
> 
>> +			found_any = true;
>> +		}
>> +	}
>> +
>> +	/* Only send IPIs to CPUs actually doing lockless walks */
>> +	if (found_any)
>> +		smp_call_function_many(target_cpus, tlb_remove_table_smp_sync,
>> +				       NULL, 1);
> 
> Coding style wants { } here. Also, isn't this what we have
> smp_call_function_many_cond() for?

Right! That would be better, something like:

static bool tlb_remove_table_sync_mm_cond(int cpu, void *mm)
{
	return per_cpu(active_lockless_pt_walk_mm, cpu) == (struct mm_struct *)mm;
}

on_each_cpu_cond_mask(tlb_remove_table_sync_mm_cond,
			tlb_remove_table_smp_sync,
			(void *)mm, true, cpu_online_mask);

> 
>> +	free_cpumask_var(target_cpus);
>> +}
>> +
>>   static void tlb_remove_table_rcu(struct rcu_head *head)
>>   {
>>   	__tlb_remove_table_free(container_of(head, struct mmu_table_batch, rcu));
>> -- 
>> 2.49.0
>>

Thanks,
Lance


