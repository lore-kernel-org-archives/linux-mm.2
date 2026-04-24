Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05C28FED3EC
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 15:50:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 633D26B0005; Fri, 24 Apr 2026 11:50:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60BA36B008A; Fri, 24 Apr 2026 11:50:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 522466B0092; Fri, 24 Apr 2026 11:50:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4213A6B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:50:19 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E016C140222
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:50:18 +0000 (UTC)
X-FDA: 84693886116.23.7DB0DE5
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0507F80011
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:50:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nDYZtFLL;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777045817; a=rsa-sha256;
	cv=none;
	b=dgouwoO6w5D3QybvGUgt/54viU/hYngvAKmHqg/pvJsCO73Mzl+XjE7wfBP1rmZ6Tg1E/P
	26Gws2xJlX6H23vb6t3CLf0aOrTsG4nwyO5grc9sTsUO0/C8RhtXxLnEEM8RbC3TwjoSyM
	R/tu7bYBBDfOmiqSK8Sq2NDCKrjCRMo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nDYZtFLL;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777045817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0j98C+k0FMWienD6UU5F2vb7kP4FNq4bGSEt/E3eHFc=;
	b=WuvVtIlcS6zhV9EGKNYXIRgBRnBNXIgBbtjUqOppEPfV2HO74mR85Fv/YXYcfocPXFVo6F
	5qp7RtA4Esv/pJFBKOcfAoLweGZVWzTX1aHo1DzZck5Nm/MeRdLCRCEt6v2A49bO96hg+p
	sHK8dcmhe3WwGyBFylxV8EgnoQs0IBY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777045812;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0j98C+k0FMWienD6UU5F2vb7kP4FNq4bGSEt/E3eHFc=;
	b=nDYZtFLLrnOgK12w/V+IKSpSn1f+kKAdlx9MxGf9+VxfN8W+VCYuqrJwbVbkr853pz5rGx
	DSsRYviaI913+dgjdnpLDuo5l1LinOTZYG0rPmnGn/WaHi4nK1Qh8qC8CpUOvF1BW3DNGZ
	zruonZ1x3yeh1kvHTNrfZAZ1C0jmVD0=
From: Lance Yang <lance.yang@linux.dev>
To: peterz@infradead.org,
	dave.hansen@intel.com
Cc: lance.yang@linux.dev,
	akpm@linux-foundation.org,
	david@kernel.org,
	dave.hansen@linux.intel.com,
	ypodemsk@redhat.com,
	hughd@google.com,
	will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	arnd@arndb.de,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	shy828301@gmail.com,
	riel@surriel.com,
	jannh@google.com,
	jgross@suse.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	boris.ostrovsky@oracle.com,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ioworker0@gmail.com
Subject: Re: [PATCH 7.2 v10 2/2] x86/tlb: skip redundant sync IPIs for native TLB flush
Date: Fri, 24 Apr 2026 23:49:43 +0800
Message-Id: <20260424154943.67564-1-lance.yang@linux.dev>
In-Reply-To: <20260424151247.GG3126523@noisy.programming.kicks-ass.net>
References: <20260424151247.GG3126523@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Stat-Signature: w1b3acef87sq5s3zbp613536ycbk7byf
X-Rspam-User: 
X-Rspamd-Queue-Id: 0507F80011
X-HE-Tag: 1777045816-405271
X-HE-Meta: U2FsdGVkX19UC9QpQlEUKolc5AFFRcJcF+dzgsVQULHN1wuVb0mJbAqPRq5zdkA8ZbqNaf9zuOPRAcGSeenYDhUszD9llCGo833FtWcTdPXoEXFN7YN80d0HyMZn9IfNcK+2SM7SJV/0HmKvFlLWX7dTp07XP2jEv6cpwd/HsKDkngOC3w+foF1ywxyJYGb73KlaQasoaYR8vSvmM9e1M8nvq6HmjN+VAklk57eTcaFBF/fkFr/2OwSs+tVBLk/1AUCmMeiS5Ztn1DdhxfWjCeG0/MeVHmxcfOZeFrci2NUx8CNL4y+OZpRWDe4BtkFEKJ5lb/5ruNKjvLIDhEZ577tYjflxUDI4fYHMxaHeoP8W4jhBLnfTTQFHFD7DxZS8VoGMWP1kXOAo0yHVkT9xddJGrdil8OuvVHwXxUWIh5gtPWn4SwdrjCbIsCm8J743692/bW8bgqpNkbB045bPKvRsz8FH67iXy8j/6s6yeplEbdYeUu6qOAg7jMhonY2brJxi2/gtbh8jm9KayDDY71Aj/0hLBMocNAdh0byIpgEoDDPfFA2eet3aoWam8S+I0TsFiyHq0tTRlfTmksuq92lJWAZXpOv94ndllk4UuSUMA9whMb/X7O2LPo9Br5kqfOitr+kl+8LNQVU9CAPTrQw6An++4QWZWPlpKd8oYxr2+UOwx3bHWgT3IKs02ZHT5VqtCZBvV7dprZVJ11s29OMcg6WCQ/vLdeiKB/4HQaUIMP0W233ogjZuE3ytAsWaXbHbnl/uEcNFNZYRQXwjxhtXB5jMc97wrbwhc9BFKTSSuPpF/FEEwlNVnZjhvH6iW6dpCTCHlA3tZUTe7nO4Y7gRFf49RWjPodqvRSJlWC3NUgBVmRd1yy8yTtdgAoFugTI3KVH3HfWXKtPPyMfKroTlEkxsgnfmOBqvORfwsgVld3RHQAhfGXVE1eX4kDmRDiOtRcIpsfYvPjuepXj
 VuiIhuvm
 6drgwZxb7F/zRFfH2o+rQrqHmtlZdLrukSEZM/qmZ1KzER7rGC5NGH8ckuvFQzr7ljK+AWSLCcEhg1QbEzomYQX95SW0+fzA9o1BN3tVuJ/VHAA+4NwR1vOtceq0oP/8RKw5OYOtM/QBJhqeUJYNnueJqFEf/9Ji/hBOGjNq1rMIaq7UIAEAyupTZHAIISoR6s9BJ4tXtna0TopZhkd9UTmXfzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, Apr 24, 2026 at 05:12:47PM +0200, Peter Zijlstra wrote:
>On Fri, Apr 24, 2026 at 02:25:28PM +0800, Lance Yang wrote:
>> diff --git a/arch/x86/hyperv/mmu.c b/arch/x86/hyperv/mmu.c
>> index cfcb60468b01..2cf1eeaffd6f 100644
>> --- a/arch/x86/hyperv/mmu.c
>> +++ b/arch/x86/hyperv/mmu.c
>> @@ -63,7 +63,7 @@ static void hyperv_flush_tlb_multi(const struct cpumask *cpus,
>>  	struct hv_tlb_flush *flush;
>>  	u64 status;
>>  	unsigned long flags;
>> -	bool do_lazy = !info->freed_tables;
>> +	bool do_lazy = !info->wake_lazy_cpus;
>>  
>>  	trace_hyperv_mmu_flush_tlb_multi(cpus, info);
>>  
>> @@ -198,7 +198,7 @@ static u64 hyperv_flush_tlb_others_ex(const struct cpumask *cpus,
>>  
>>  	flush->hv_vp_set.format = HV_GENERIC_SET_SPARSE_4K;
>>  	nr_bank = cpumask_to_vpset_skip(&flush->hv_vp_set, cpus,
>> -			info->freed_tables ? NULL : cpu_is_lazy);
>> +			info->wake_lazy_cpus ? NULL : cpu_is_lazy);
>>  	if (nr_bank < 0)
>>  		return HV_STATUS_INVALID_PARAMETER;
>>  
>> diff --git a/arch/x86/include/asm/tlb.h b/arch/x86/include/asm/tlb.h
>> index 866ea78ba156..fb256fd95f95 100644
>> --- a/arch/x86/include/asm/tlb.h
>> +++ b/arch/x86/include/asm/tlb.h
>
>>  static inline void tlb_flush(struct mmu_gather *tlb)
>>  {
>>  	unsigned long start = 0UL, end = TLB_FLUSH_ALL;
>>  	unsigned int stride_shift = tlb_get_unmap_shift(tlb);
>>  
>> +	/*
>> +	 * Both freed_tables and unshared_tables must wake lazy-TLB CPUs, so
>> +	 * they receive IPIs before reusing or freeing page tables, allowing
>> +	 * us to safely implement tlb_table_flush_implies_ipi_broadcast().
>> +	 */
>> +	bool wake_lazy_cpus = tlb->freed_tables || tlb->unshared_tables;
>> +
>>  	if (!tlb->fullmm && !tlb->need_flush_all) {
>>  		start = tlb->start;
>>  		end = tlb->end;
>>  	}
>>  
>> -	flush_tlb_mm_range(tlb->mm, start, end, stride_shift, tlb->freed_tables);
>> +	flush_tlb_mm_range(tlb->mm, start, end, stride_shift, wake_lazy_cpus);
>>  }
>>  
>>  static inline void invlpg(unsigned long addr)
>> diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
>> index 5a3cdc439e38..39b9454781c3 100644
>> --- a/arch/x86/include/asm/tlbflush.h
>> +++ b/arch/x86/include/asm/tlbflush.h
>> @@ -225,7 +227,7 @@ struct flush_tlb_info {
>>  	u64			new_tlb_gen;
>>  	unsigned int		initiating_cpu;
>>  	u8			stride_shift;
>> -	u8			freed_tables;
>> +	u8			wake_lazy_cpus;
>>  	u8			trim_cpumask;
>>  };
>>  
>> @@ -315,7 +317,7 @@ static inline bool mm_in_asid_transition(struct mm_struct *mm) { return false; }
>>  extern void flush_tlb_all(void);
>>  extern void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
>>  				unsigned long end, unsigned int stride_shift,
>> -				bool freed_tables);
>> +				bool wake_lazy_cpus);
>>  extern void flush_tlb_kernel_range(unsigned long start, unsigned long end);
>>  
>>  static inline void flush_tlb_page(struct vm_area_struct *vma, unsigned long a)
>
>> diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
>> index 621e09d049cb..3ce254a3982c 100644
>> --- a/arch/x86/mm/tlb.c
>> +++ b/arch/x86/mm/tlb.c
>> @@ -1360,16 +1362,16 @@ STATIC_NOPV void native_flush_tlb_multi(const struct cpumask *cpumask,
>>  				(info->end - info->start) >> PAGE_SHIFT);
>>  
>>  	/*
>> -	 * If no page tables were freed, we can skip sending IPIs to
>> -	 * CPUs in lazy TLB mode. They will flush the CPU themselves
>> -	 * at the next context switch.
>> +	 * If lazy-TLB CPUs do not need to be woken, we can skip sending
>> +	 * IPIs to them. They will flush themselves at the next context
>> +	 * switch.
>>  	 *
>> -	 * However, if page tables are getting freed, we need to send the
>> -	 * IPI everywhere, to prevent CPUs in lazy TLB mode from tripping
>> -	 * up on the new contents of what used to be page tables, while
>> -	 * doing a speculative memory access.
>> +	 * However, if page tables are getting freed or unshared, we need
>> +	 * to send the IPI everywhere, to prevent CPUs in lazy TLB mode
>> +	 * from tripping up on the new contents of what used to be page
>> +	 * tables, while doing a speculative memory access.
>>  	 */
>> -	if (info->freed_tables || mm_in_asid_transition(info->mm))
>> +	if (info->wake_lazy_cpus || mm_in_asid_transition(info->mm))
>>  		on_each_cpu_mask(cpumask, flush_tlb_func, (void *)info, true);
>>  	else
>>  		on_each_cpu_cond_mask(should_flush_tlb, flush_tlb_func,
>> @@ -1402,7 +1404,7 @@ static DEFINE_PER_CPU(unsigned int, flush_tlb_info_idx);
>>  
>>  static struct flush_tlb_info *get_flush_tlb_info(struct mm_struct *mm,
>>  			unsigned long start, unsigned long end,
>> -			unsigned int stride_shift, bool freed_tables,
>> +			unsigned int stride_shift, bool wake_lazy_cpus,
>>  			u64 new_tlb_gen)
>>  {
>>  	struct flush_tlb_info *info = this_cpu_ptr(&flush_tlb_info);
>> @@ -1429,7 +1431,7 @@ static struct flush_tlb_info *get_flush_tlb_info(struct mm_struct *mm,
>>  	info->end		= end;
>>  	info->mm		= mm;
>>  	info->stride_shift	= stride_shift;
>> -	info->freed_tables	= freed_tables;
>> +	info->wake_lazy_cpus	= wake_lazy_cpus;
>>  	info->new_tlb_gen	= new_tlb_gen;
>>  	info->initiating_cpu	= smp_processor_id();
>>  	info->trim_cpumask	= 0;
>> @@ -1448,7 +1450,7 @@ static void put_flush_tlb_info(void)
>>  
>>  void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
>>  				unsigned long end, unsigned int stride_shift,
>> -				bool freed_tables)
>> +				bool wake_lazy_cpus)
>>  {
>>  	struct flush_tlb_info *info;
>>  	int cpu = get_cpu();
>> @@ -1457,7 +1459,7 @@ void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
>>  	/* This is also a barrier that synchronizes with switch_mm(). */
>>  	new_tlb_gen = inc_mm_tlb_gen(mm);
>>  
>> -	info = get_flush_tlb_info(mm, start, end, stride_shift, freed_tables,
>> +	info = get_flush_tlb_info(mm, start, end, stride_shift, wake_lazy_cpus,
>>  				  new_tlb_gen);
>>  
>>  	/*
>
>This whole s/freed_tables/wake_lazy_cpus/ rename should probably be its
>own patch, as should that include unshare_tables thing be.
>
>That seems like unrelated changes.

Thanks, makes sense! Will split the pure s/freed_tables/wake_lazy_cpus/
rename out.

For the tlb->unshared_tables part, I would keep it with this patch, 
since lazy-TLB CPUs still have to be woken before reusing unshared page
tables.

@Dave what do you think?

Thanks,
Lance

