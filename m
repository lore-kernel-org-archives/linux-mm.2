Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99F31C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 05:41:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2977F6B009A; Tue, 22 Jul 2025 01:41:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26FA26B009B; Tue, 22 Jul 2025 01:41:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1852E6B009F; Tue, 22 Jul 2025 01:41:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 093026B009A
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 01:41:30 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A10E1110AFD
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 05:41:29 +0000 (UTC)
X-FDA: 83690803098.03.38907EC
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf23.hostedemail.com (Postfix) with ESMTP id 85840140002
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 05:41:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hSiHKl1e;
	spf=pass (imf23.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753162887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=neo6sMXBK7ts+8GOjMskG5befgLb4KxkB1TrtOvBUgo=;
	b=r7BWnZZzalxDKMKkebc9YsmlUNEGG+UDO/DIhv8UB6Ied0tKYRa0f2hwWHshKBpI/uTbGC
	FDDfKpclnMt14JYRZZ2ABAGS9QWARrRHNYXLZ8czHtGIh+G8SmAemOXMbAKVtFl/e7GB7X
	bd5mUZIpm60FHv6qzBQTTlojETDvoAY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753162887; a=rsa-sha256;
	cv=none;
	b=p3A1fghfZnqkUZWEk/2tBzXDmkpjz8WAShoppOIoed3pf/VwxZG60mK9FQXXM+tieKqZ1y
	UomN50AOogQ7RdOif7JjhlNrJI3VEnfJcvin2TSmDTTDBtSGZn/gBZENakY+zGGvJjQxzY
	ClW7fOpwXxinBZtId8zpYc+chJ6m86s=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hSiHKl1e;
	spf=pass (imf23.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753162887; x=1784698887;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=iBcyx2fSDKLp4DgJonC8/dTTFfildOPqKcy+wY7eDR8=;
  b=hSiHKl1evhvJhiqGIkh/X6F1niSWv75DACpxGXvXYmSXaeSbbSsfduD2
   DWMG0SVOT45DjmMvb010HpuG6yHCWKYTE6o917vci4KX5/IGR0pEIlnDL
   9wH8P7inizL8PU+SLiEXhtjr08U2/QZtfU8ZbN+0BXjP6sDTUV7mNfSru
   Ss15PmthjddLJqF+T6f+gdDHzTaDBa/TpAOz2yLKHsD7XfOnPr7An4fnc
   MnVGQPF1mGEe/J29YdL5BBMrTLYU8TrC5vmQzE/+RA9kZ0H0U5NDtpOes
   PZCCPsVWp/+Jt4suGN4mWQeYQ/nEV2qzIHvR4sIgWhKXZYrug4ALgjmH9
   A==;
X-CSE-ConnectionGUID: WzlG8R80TDGVcCfKhq4mYw==
X-CSE-MsgGUID: sZvdPZsURT+p69RisSw72w==
X-IronPort-AV: E=McAfee;i="6800,10657,11499"; a="43014905"
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="43014905"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 22:41:25 -0700
X-CSE-ConnectionGUID: bezS+jBDRN+5mqBAM7TZNg==
X-CSE-MsgGUID: vOIeWFnkTQytfKFYUDSdcg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="158338964"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 22:41:09 -0700
Message-ID: <27ac6ed0-f58a-4926-a069-8d9d7d61a41c@intel.com>
Date: Tue, 22 Jul 2025 13:41:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 13/21] KVM: x86/mmu: Handle guest page faults for
 guest_memfd with shared memory
To: Sean Christopherson <seanjc@google.com>, Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
 kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org,
 mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org,
 amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com,
 mic@digikod.net, vbabka@suse.cz, vannapurve@google.com,
 ackerleytng@google.com, mail@maciej.szmigiero.name, david@redhat.com,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
 quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com,
 roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250717162731.446579-1-tabba@google.com>
 <20250717162731.446579-14-tabba@google.com> <aH5vNqPrUFgtZCqU@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aH5vNqPrUFgtZCqU@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 85840140002
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: dxsygdje9e8mpyecstu3gkjd9dz7rmt5
X-HE-Tag: 1753162887-921456
X-HE-Meta: U2FsdGVkX1+zhiwapCq6ZRAJb5X50wAlsDgh6Cq8MgrNaERRHE4lCg7DjXHWKDCc6m+gUIqfdtuNOLkHN6OR62KKG2klRD7eGpT9wNtNQOoiOHp+r1g1xL0uxWx5P5dI8CFTC8+P2D2xTunhLeniPBzSpI4pEcWM9DT45dqJgNf44jgWnyr5//ni2K69sjWTRdYnH/yGYcDV0GaDR/BaplAPJuZb0gM0t758eerMOm1pQfCasLpXBQwmdQlDBcN6jRe5hB4Xw0mb5x6gIKugta/4dbZY7paAXGQl+NTsRuFdf8AbZ4nf+X5Ao0s7SDdYdaDgEgUvk34Yv15Cd14DEpY1JUSK+Iv7wcoD5Z1dMvWhc4yiJCdE2LkzSlpIEJz98C7EjjIT1laTag5jo0mP8wBi9YhOzugiqveN9ZxsyYT8QLmkRccJ4axoQeZspjwTuHO9OVyNxkzV1muS072hXUXLwUn7zmysiENUbWnn+KMIl9Dm8eOoOoN8qzqOvxGddNZUd2g4KgdKalginByF5Hlo0aOxn/ydNYZi6mwNnk2C6pQz/17jaOjIxg5WHXy6GsOBTDHP95aYSOBEZhgXZBaeHnBnksTOnXZxfGTlJaZmUWETeRzYEEagL4QJMe278LlOr3PYSKmUnHOkJxtY3NiNVfZ8ZxgI6It7AU9Oy/ODXo4WBUF6dpOpHOKE9iMVlVjziiO7N/dEK1Okooi3Q2jWsQkSdIKLiBdmhYKjJ3y0nqTOwD76lDf3pKTHpk4vMxrrHrH0TbyGWFffDX2rea5bLOHYMs1Nd9qLEfAqGTaqPXEGp2Dg6sBkOVo7KAz3AnjiwbB4McC+9Z0V5QQBeIENLMJtRZjJzrok2AB9UtL+3snln6gHwizwaoid/jQp73hrZWYT8SMt9IVvi+R9Xl6pd7d19n+KiD1TRBAu3zoWhSLl1dBlfVdnJTAmdEoBHjLbHR5unVsIw+64DF0
 HqAvn0TZ
 PM2Kw76ZQKbuM9fW+xIF5UWxHrQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/22/2025 12:47 AM, Sean Christopherson wrote:
> On Thu, Jul 17, 2025, Fuad Tabba wrote:
>> From: Ackerley Tng <ackerleytng@google.com>
>>
>> Update the KVM MMU fault handler to service guest page faults
>> for memory slots backed by guest_memfd with mmap support. For such
>> slots, the MMU must always fault in pages directly from guest_memfd,
>> bypassing the host's userspace_addr.
>>
>> This ensures that guest_memfd-backed memory is always handled through
>> the guest_memfd specific faulting path, regardless of whether it's for
>> private or non-private (shared) use cases.
>>
>> Additionally, rename kvm_mmu_faultin_pfn_private() to
>> kvm_mmu_faultin_pfn_gmem(), as this function is now used to fault in
>> pages from guest_memfd for both private and non-private memory,
>> accommodating the new use cases.
>>
>> Co-developed-by: David Hildenbrand <david@redhat.com>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>> Co-developed-by: Fuad Tabba <tabba@google.com>
>> Signed-off-by: Fuad Tabba <tabba@google.com>
>> ---
>>   arch/x86/kvm/mmu/mmu.c | 13 +++++++++----
>>   1 file changed, 9 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> index 94be15cde6da..ad5f337b496c 100644
>> --- a/arch/x86/kvm/mmu/mmu.c
>> +++ b/arch/x86/kvm/mmu/mmu.c
>> @@ -4511,8 +4511,8 @@ static void kvm_mmu_finish_page_fault(struct kvm_vcpu *vcpu,
>>   				 r == RET_PF_RETRY, fault->map_writable);
>>   }
>>   
>> -static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
>> -				       struct kvm_page_fault *fault)
>> +static int kvm_mmu_faultin_pfn_gmem(struct kvm_vcpu *vcpu,
>> +				    struct kvm_page_fault *fault)
>>   {
>>   	int max_order, r;
>>   
>> @@ -4536,13 +4536,18 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
>>   	return RET_PF_CONTINUE;
>>   }
>>   
>> +static bool fault_from_gmem(struct kvm_page_fault *fault)
> 
> Drop the helper.  It has exactly one caller, and it makes the code *harder* to
> read, e.g. raises the question of what "from gmem" even means.  If a separate
> series follows and needs/justifies this helper, then it can/should be added then.

there is another place requires the same check introduced by your
"KVM: x86/mmu: Extend guest_memfd's max mapping level to shared 
mappings" provided in [*]

[*] https://lore.kernel.org/kvm/aH7KghhsjaiIL3En@google.com/

---
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1ff7582d5fae..2d1894ed1623 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c

@@ -3335,8 +3336,9 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm, 
struct kvm_page_fault *fault,
         if (max_level == PG_LEVEL_4K)
                 return PG_LEVEL_4K;

-       if (is_private)
-               host_level = kvm_max_private_mapping_level(kvm, fault, 
slot, gfn);
+       if (is_private || kvm_memslot_is_gmem_only(slot))
+               host_level = kvm_gmem_max_mapping_level(kvm, fault, 
slot, gfn,
+                                                       is_private);
         else
                 host_level = host_pfn_mapping_level(kvm, gfn, slot);
         return min(host_level, max_level);

>> +{
>> +	return fault->is_private || kvm_memslot_is_gmem_only(fault->slot);
>> +}
>> +
>>   static int __kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
>>   				 struct kvm_page_fault *fault)
>>   {
>>   	unsigned int foll = fault->write ? FOLL_WRITE : 0;
>>   
>> -	if (fault->is_private)
>> -		return kvm_mmu_faultin_pfn_private(vcpu, fault);
>> +	if (fault_from_gmem(fault))
>> +		return kvm_mmu_faultin_pfn_gmem(vcpu, fault);
>>   
>>   	foll |= FOLL_NOWAIT;
>>   	fault->pfn = __kvm_faultin_pfn(fault->slot, fault->gfn, foll,
>> -- 
>> 2.50.0.727.gbf7dc18ff4-goog
>>


