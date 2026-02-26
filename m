Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFC9DFC5935
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 11:38:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F09016B00BD; Thu, 26 Feb 2026 06:38:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB7496B00BF; Thu, 26 Feb 2026 06:38:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D987A6B00C0; Thu, 26 Feb 2026 06:38:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C444A6B00BD
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 06:38:28 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7B38B140B5F
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:38:28 +0000 (UTC)
X-FDA: 84486409896.27.B14EC94
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf03.hostedemail.com (Postfix) with ESMTP id 91C5720015
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:38:26 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lJPkmtZ5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772105906; a=rsa-sha256;
	cv=none;
	b=G/NGI0zDUsZ8xz9b4U1ANrJes1H7IVVZRO+XokD/ZDXEZIAGONCwfNsa0THtfEV1Z76GrA
	p5CXV/bGZf0NZ9tyPvHzErZSMib5/cYlxYg07dGqJnbkAa/RUdIrALicvP38aqc3e8kMKi
	GXv/iD10u/xDq55rBXFREt0NAQ+22Jw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lJPkmtZ5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772105906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oVaH2AoHyrpbqPRn9gALiYtw4uFm/ie/8+RysyrQGzU=;
	b=DPTc4XOuHxf8ktRtRJzwkVAyEnOYXsX3aPHQOx3LTY/uhyYxq4PBpwAPLUjca8496H9vTV
	2Z0HRlwfoedToMGFl7Vqg0IM00eLZmp+OO1eQuBaQn96yk0tUfGSuNHpvfqSCz0vcV8owv
	NG3JnCbjbMLOKbq/QeJf4ceyykc+qxs=
Message-ID: <e3cdcbfa-525d-4e0d-885a-8f7d69a7ee3d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772105904;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oVaH2AoHyrpbqPRn9gALiYtw4uFm/ie/8+RysyrQGzU=;
	b=lJPkmtZ530h0RaT4fu91t/bNwWMNVEIXdYTEi99XumvWDHNOWee3IjKoAVImZWm7XhGvax
	qFCbJBGfyInnEuhW3QlCU4zoZFi8xwNvrt/aByDnCLNcPJIwuToPOKUcbglYKAHVqf4PSY
	9Koo9hEPLX0q59Rbu+eHXWAkrNeJw84=
Date: Thu, 26 Feb 2026 19:37:57 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4 3/3] x86/tlb: add architecture-specific TLB IPI
 optimization support
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: akpm@linux-foundation.org, david@kernel.org, dave.hansen@intel.com,
 dave.hansen@linux.intel.com, ypodemsk@redhat.com, hughd@google.com,
 will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
 peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 x86@kernel.org, hpa@zytor.com, arnd@arndb.de, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, shy828301@gmail.com, riel@surriel.com, jannh@google.com,
 jgross@suse.com, pbonzini@redhat.com, boris.ostrovsky@oracle.com,
 virtualization@lists.linux.dev, kvm@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ioworker0@gmail.com
References: <20260202074557.16544-1-lance.yang@linux.dev>
 <20260202074557.16544-4-lance.yang@linux.dev> <aZ9Xcgxa0_ouGr31@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <aZ9Xcgxa0_ouGr31@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 91C5720015
X-Stat-Signature: zpibsoy6s6en4brueswui1wu5zijzq3j
X-HE-Tag: 1772105906-376480
X-HE-Meta: U2FsdGVkX19qPUWr5F3Uz3KkP9yso0I9uIOWl9gUkeVDTfhr3N1GeLElI71RoORV+rkcIBs5pgFt9t1Wmli6ScjaEmJGVYiZ+bJjmlGPpvdoqs9GaEwkqesKFkTvHoF9nM38KiC+ITspwOfEtM0daDzWXVVzPTHBZNT1fBkNlQSt9jJk9Pn8BmWy2NjjzkaRypNOGtEtfCM7SjmYiwadZuc6Dxyk0vU+5es5wTA9AwMlY0zD1sg+MzJRfx+sYMf2sXVartYntMs+tX6QAz6KCnyZ+3crwlSXRPaMLvuJJYqR4mZyxMjWYLQlsmXGijS/I7QdO8Dv0At7IBLd5uV/vLPksgo7HuY0qakj8JAXVy7RHacu4NxGQuFuS3psv9gXc5RdzRXo/URxFJeZobLruYsaEmwfSC0BQtNwzriH20Ws5N++Hp3wzcch/Ks9BLlKcQgsWEe4duezz5Wl0wVwCZfMBCSDrV42EMohkXWY86p4kxFnDGr9P6nCDwFxE/hIylsD/ShTnxmHz9c6/lDZlI/1BKBjn9NRSpy5kJnuM+faG5RutG87XfNTL6LkVae31O1J3B6wLidhae6qM6m9KQb3uRLrAK9cRmhoXCC39O+DD0kYxkvq3YNFvGGbgtVMmacQ13QuTU8jMjHOF1S09hODOidkMbpwQUQILXWSyj0g1yrsvJhu71vN8uFaE//XNYqDtwEOtxRT0qW6kC9Jr7X3MV0kaM2bgVdMYaQXVYNi58Dzhc0PZCwAL0CBNGZOmLXhukjRFxDudrYTW9M/TY3MCm6/YQsZXk7rBwR6gaixgtFFUajhGvzYMiemlOOfGvF1aaQVRrMOzjhvfPw71Rdu52u3F6EeTOATpYA6ob4lHg81wtDMHlgiFnuwtkcFec3qQjHJMKnsG8t72MXlayuL5qc9FKvfVBKH1l5XqdEw2RQKSL48BpN6CM7FPBdgGs/Ip2l+mQsW1qeTO8f
 KRS6Oksu
 A3x+4n4buB2jL2XoT2nxXaspEjr/qOgnrWCYArQf5U+/VV4XvPeTVF5XhJhm8jYQubv8fPwchyi+o5bz8rgVc71BR27iagDpXyWAVl2AZ61cWH0S41W+9nNGUxt/HnFMtjrCUnx6+1iHqFKvVlF5qDHIUC0vypmrJAsOM/m3oqmihK6NM367LxADpPNXqfmEk5JJDMkK62NMccu4yueG1OYHsvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/2/26 04:11, Sean Christopherson wrote:
> On Mon, Feb 02, 2026, Lance Yang wrote:
>> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
>> index 37dc8465e0f5..6a5e47ee4eb6 100644
>> --- a/arch/x86/kernel/kvm.c
>> +++ b/arch/x86/kernel/kvm.c
>> @@ -856,6 +856,12 @@ static void __init kvm_guest_init(void)
>>   #ifdef CONFIG_SMP
>>   	if (pv_tlb_flush_supported()) {
>>   		pv_ops.mmu.flush_tlb_multi = kvm_flush_tlb_multi;
>> +		/*
>> +		 * KVM's flush implementation calls native_flush_tlb_multi(),
>> +		 * which sends real IPIs when INVLPGB is not available.
> 
> Not on all (virtual) CPUs.  The entire point of KVM's PV TLB flush is to elide
> the IPIs.  If a vCPU was scheduled out by the host, the guest sets a flag and
> relies on the host to flush the TLB on behalf of the guest prior to the next
> VM-Enter.

Ah, I see. Thanks for the correction!

KVM only sends IPIs to running vCPUs; preempted ones are left out of the 
mask
and flushed on VM-Enter. So the old comment was wrong ...

IIUC, we still set the flag to true because only running vCPUs can be in a
software/lockless walk, and they all get the IPI, so the flush is enough.

Does that match what you had in mind?


Thanks,
Lance

> 
> 	for_each_cpu(cpu, flushmask) {
> 		/*
> 		 * The local vCPU is never preempted, so we do not explicitly
> 		 * skip check for local vCPU - it will never be cleared from
> 		 * flushmask.
> 		 */
> 		src = &per_cpu(steal_time, cpu);
> 		state = READ_ONCE(src->preempted);
> 		if ((state & KVM_VCPU_PREEMPTED)) {
> 			if (try_cmpxchg(&src->preempted, &state,
> 					state | KVM_VCPU_FLUSH_TLB))
> 				__cpumask_clear_cpu(cpu, flushmask);  <=== removes CPU from the IPI set
> 		}
> 	}
> 
> 	native_flush_tlb_multi(flushmask, info);
> 
>> +		if (!cpu_feature_enabled(X86_FEATURE_INVLPGB))
>> +			pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast = true;
>>   		pr_info("KVM setup pv remote TLB flush\n");
>>   	}


