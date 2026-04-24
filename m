Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C32F3FB44A8
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 05:03:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B897A6B0005; Fri, 24 Apr 2026 01:03:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3B986B008A; Fri, 24 Apr 2026 01:03:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A29276B008C; Fri, 24 Apr 2026 01:03:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8DCAD6B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 01:03:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E613EA06F3
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 05:03:55 +0000 (UTC)
X-FDA: 84692257230.23.3407BD0
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf19.hostedemail.com (Postfix) with ESMTP id EB9911A0011
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 05:03:53 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=k6w7+Mgc;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777007034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rF/14iOG/TKWQJ1iA5emqkLbN1JUZtyc7urLxXkKtYs=;
	b=dtr19nVgzoZxCw/CB/6JFQWuzZ8ZTm1TO2fkE6kze3A47CHEIEPYQf+6FB29XBRCgKdEJw
	ayKVFTiEPUqIs1kzcNQzMNT1x2N8TMT0H9bCebUdLIqbF/8JwCZSwlP5Ft7lPwW8WqUpiW
	WE9yAnHr4AC5GzDHCB20PdglOS/OoPo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=k6w7+Mgc;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777007034; a=rsa-sha256;
	cv=none;
	b=4P9ltjOVsX0xrDa7dhLjHSENOLmONv38Avp7cVsFwTW/aG4seTb37JaeZ+pHJ2Fg+69Ag1
	sAtSSl6bkHv2EXfMT269pQtc5rtD44EHRNxzliFWqC6+FDbCAv0bO691vQqj3jhpSi6Uho
	DlqHMOiu8jQHmj40OWK3CzgXjol9jlo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777007031;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rF/14iOG/TKWQJ1iA5emqkLbN1JUZtyc7urLxXkKtYs=;
	b=k6w7+MgcqYIlU+lFz2OOnnJETtGqStoZm15MrlwZJlFr80pOyWH6gZ6d2zM2guk98Kx4hw
	tXCLb6gF/s7OF6Yz18Pc0TSuybZ8lAg9MR+ILu0Icc1wm4wkNrZjQ12wjGjJGxTsyLLXJc
	mGIvQmB9tRHJGZ2PRed7SjpDnA1qOfM=
From: Lance Yang <lance.yang@linux.dev>
To: dave.hansen@intel.com
Cc: lance.yang@linux.dev,
	akpm@linux-foundation.org,
	peterz@infradead.org,
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
Subject: Re: [PATCH 7.2 v9 2/2] x86/tlb: skip redundant sync IPIs for native TLB flush
Date: Fri, 24 Apr 2026 13:03:29 +0800
Message-Id: <20260424050329.96623-1-lance.yang@linux.dev>
In-Reply-To: <f856051b-10c7-4d65-9dbe-6b1677af74bd@intel.com>
References: <f856051b-10c7-4d65-9dbe-6b1677af74bd@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: f96ooibhcym13yji7rmkfizewhpprs9b
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EB9911A0011
X-HE-Tag: 1777007033-794619
X-HE-Meta: U2FsdGVkX18JHAlJddKvpUwiiH8AoeyGAt19qlDm+1ZFiJdrSPCv+X2pIDIhEJP0W0RQ1T4/n2bvUVx1ROYTTolw0V21aYG59r7zpWR61praZjsK2ad+/iHHYLNw+4waZ8VNx4yqg43Qz7naZgzKK4wUtQ7rhiDz+PHdcnbrbt9moEJclscMvE+eudG2R440OEdrW64mFlR+BA6Fozxx+XMsS29FPdODyq2GgdqGVq189G6YB/zQ9MtqxGpv+F/GGjBUbjupOrL9foGN0MnQft/EYiGtPGsxxbplvoLb86x8GkhufKmYhN+Rb7OpjAO7AIZIs8fA7M0PpyZ7h9JwSHtYhSteyDlqnyQAKpVPcWvufvyOYZePIrasYW1jLnkCTbxZnGGiRThKHzhQNfoqfz2DG4ghsZTTUpU/aL8nEz0ucyh8U8THjqD6EC6Elw8SBS4ECSMv/AVI7Qw/Z5SMZVoaKqm2DCe7WkmKvMy3G2vubkY07KGdWWRBP3EbhqfOaoDGxNTeb0QrWNx/cAoRpGiiA91DYqTF5xl39TP8EafJd5FDL/9mGBE7j66WPzO0keFOvw0Mdj3ILFM64vYTuDTKjaKRSIXRGrRYiO4OqBxt0RIFdNd6UHAy0DbGZPhFnc5JdN+wFgINfX7GgsIpiYnLtdOT03FvPMbtNF/He/XgkZZ6piECP9Ek1FhdeIN2O5kbXimzXuVfEIcSxHB+1bOQqzrP54M6Y3vx4uIEd2EB+ZdkFDdTFEoflzlx+NtsVs/QuvdfS0hSKCP2Ez1htyKQMIFkZvQFC5cyziVcNe0JRMVX2cWXynsCvaIHla+ywMIZSOOljqI70Q2BJgTZeeTaDmy5kWTqjc1RopuXEoI8edtXdrWLi/aoQVKBnW3q0QpenDMpPy8vw//W1B8whnEF2x2H35egNme6uORTTwFWHRULFsXJy7gR+uFN17mxOUkBo+kTIyhuEcY9ahk
 k+5De8Io
 2hmnoz6apo7z1Ht2zkUkP/JB4gWnrvQi87FJhmepb3uXrxFssko7+a77a1mZbLUbSJ6mNq/K+jOhK9SkxptbWsOzcCb9pxzje/jhxoVpjjMv0N4UInsUjOzYJC0OYlA46btSXz7hge8hSV/Lhyq361jOwaRknkqFI4q4xdlSdEF45BPSvGRK6oojNnGD1UrNLhWgVsFgsSQpgBh86U77KRE+EFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Dave,

On Thu, Apr 23, 2026 at 10:56:03AM -0700, Dave Hansen wrote:
[...]
>On 4/19/26 20:08, Lance Yang wrote:
>> -	flush_tlb_mm_range(tlb->mm, start, end, stride_shift, tlb->freed_tables);
>> +	/*
>> +	 * Treat unshared_tables just like freed_tables, such that lazy-TLB
>> +	 * CPUs also receive IPIs during unsharing of page tables, allowing
>> +	 * us to safely implement tlb_table_flush_implies_ipi_broadcast().
>> +	 */
>> +	flush_tlb_mm_range(tlb->mm, start, end, stride_shift,
>> +			   tlb->freed_tables || tlb->unshared_tables);
>>  }
>
>I've been staring at this trying to make sense of it for too long.
>
>Right now, flush_tlb_mm_range() literally has an argument named
>"freed_tables" and "tlb->freed_tables" is passed there. That seems
>totally sane. It's 100% straightforward to follow.
>
>But it makes zero logical sense to me to now mix "tlb->unshared_tables"
>in there. Sure, what you _want_ is the freed_tables==1 behavior from
>tlb->unshared_tables==1, and this obviously hacks that in there, but
>it's not explained well enough and not maintainable like this. IOW, it's
>still just hack.
>
>I think what's happened here is that info->freed_tables is being
>modified from being strictly related to page table freeing, and moved
>over to a bit which tells TLB flushing implementations whether they can
>respect CPUs in lazy TLB mode.
>
>It's mentioned in the comment, but then ever reflected into the code.
>
>Shouldn't we be doing something like the attached patch? Look at how
>that maps over to the flushing side, like in the hyperv code:

Cool, thanks!

I was trying to keep the change small by passing unshared_tables through
the exsiting freed_tables argument, but that made the code a bit harder
to follow ...

>
>> -       bool do_lazy = !info->freed_tables;
>> +       bool do_lazy = !info->wake_lazy_cpus;
>>  
>>         trace_hyperv_mmu_flush_tlb_multi(cpus, info);
>>  
>> @@ -198,7 +198,7 @@ static u64 hyperv_flush_tlb_others_ex(co
>>  
>>         flush->hv_vp_set.format = HV_GENERIC_SET_SPARSE_4K;
>>         nr_bank = cpumask_to_vpset_skip(&flush->hv_vp_set, cpus,
>> -                       info->freed_tables ? NULL : cpu_is_lazy);
>> +                       info->wake_lazy_cpus ? NULL : cpu_is_lazy);
>
>That even makes the hyperv code easier to read over what was there
>before, IMNHO.
>
>Thoughts?
[...]

Yeah, renaming the flush_tlb_info bit to wake_lazy_cpus reads much
better. Will fold this into v10, Thanks for spelling it out!

Lance

