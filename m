Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 540A3C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 16:24:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A4286B00C7; Tue, 30 Jun 2026 12:24:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87C1A6B00C8; Tue, 30 Jun 2026 12:24:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 792546B00C9; Tue, 30 Jun 2026 12:24:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1A3456B00C7
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:24:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2F23814055B
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:24:24 +0000 (UTC)
X-FDA: 84937101648.06.AE28C5D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf24.hostedemail.com (Postfix) with ESMTP id 99BA818000A
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:24:20 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=aTTXsdkT;
	spf=pass (imf24.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782836662;
	b=HOMtfmpNBMeu6EoHC0H/EtLI+k7H65Fzuhgs3Xu6YxqDgGduv74AYagD1hdRk6JKZ17k0N
	SbMHscLGlYyulOzOx76A/ppYbtHIKPQJJrTWWNhUB3hLyZCDP/b335yI2xH4VsgF4hjjpL
	v2xEgpzfIP4wUk6gtAA6aJ2mJXHZ+h4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782836662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5G/pFf84I/e+aTM9lWKZSedXgMU80nkv9MvT7Ozww0g=;
	b=G3FUaUTtilGMfd8yFZpZS++BUHRmJeYJIaVbBtuZetBk+66mDPYICkue+BB8/LVh1zqXdU
	p6FIP/2+mICl/vt943c/AmDBkDZGbt7085sTgNiZwXjS2B9b7EA2OJsmE7Y/EFOKmcjo1A
	VlfHvvIIepa7bGE/X/nU0xfog3efdU8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=aTTXsdkT;
	spf=pass (imf24.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782836660; x=1814372660;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=jA+Z5cSC4JkMlTEcMPICRNGh0TWd7xD+/PkK+LHbEkI=;
  b=aTTXsdkTovPhZjBYaKleTJ4/+2a3bF0b90/KIpB+bqrY+WgZ12PAAOcR
   RHmc1xR8Z8hda6yE7PZi6SELpadpfJ2mdtLQICaboVXISLVglfOuWqpR1
   wn+wGmBkrV5EjUfvhDsv17/Ldac2rpruQO2wBa0wQ1Bf5GJB3TIuH6JN2
   iP0Z1wo1FpgR1kvIigWLnpgs1NIxzrXHmWeEVuwcwRnozY7XAIXpGqxom
   zzHPdJur4p50EY2+HjtfWmp2lHmMss4vaN5eYzlSEK4jYz3hFYntrAORm
   2ZW3pmdtJznuGXg59jrtxwNIaYV5SBKiTsEe6T+d47J9O/nyq/zQRr2FE
   g==;
X-CSE-ConnectionGUID: E+jhLANgSE2jK5rP8WRAiA==
X-CSE-MsgGUID: n+2X2C6URA6VCIIIJYh9ug==
X-IronPort-AV: E=McAfee;i="6800,10657,11833"; a="100983388"
X-IronPort-AV: E=Sophos;i="6.24,234,1774335600"; 
   d="scan'208";a="100983388"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 09:24:19 -0700
X-CSE-ConnectionGUID: P5X392gpQj6ht692ZNvZ0w==
X-CSE-MsgGUID: Y/RTZ8sDRUCfvUTyYMkP/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,234,1774335600"; 
   d="scan'208";a="251255791"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.232.239]) ([10.124.232.239])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 09:24:05 -0700
Message-ID: <6df5cb10-645c-42de-b0f8-3fdf61067653@intel.com>
Date: Wed, 1 Jul 2026 00:24:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 04/46] KVM: Decouple kvm_has_arch_private_mem from
 CONFIG_KVM_VM_MEMORY_ATTRIBUTES
To: Sean Christopherson <seanjc@google.com>
Cc: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev,
 binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com,
 david@kernel.org, jmattson@google.com, jthoughton@google.com,
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com,
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com,
 shivankg@amd.com, steven.price@arm.com, tabba@google.com,
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com,
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com,
 aneesh.kumar@kernel.org, liam@infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-4-9d2959357853@google.com>
 <6b1f0c77-f059-4f8d-8f46-443b944c59a0@intel.com>
 <akO_Y0-ERgBoCqoQ@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <akO_Y0-ERgBoCqoQ@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: eaqqtw4p6s5wbmkeo1xf13gcm5fusf98
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 99BA818000A
X-HE-Tag: 1782836660-14370
X-HE-Meta: U2FsdGVkX1/itvB3RUpv970igX61/BXG8ifzV+Am6xy/vIJNlCdaWpnVDoSOGrtwWfYbF5frEfo6yKult23uzMFTW8u3wDwfJrv6g9UM6Ye3CoPGkUp4vuR2kiB068xCkJom8JBZihPuvnjVkwd/BCWRcYNvGd+9xUh34Be6mxmwC+Z/6lNt23RM7MI8um48tpopNxKoQBJ586FBCw6h+6ehX5GkWkTkZ+BkJg3ej5VJJt/CEHFpTriAKl4WMdV3lz+YHfGn6xhKl9LUiaMfIFOcsDVBMXXmAzxreoSB5QG/+ZV5t9ZQyxuWR6meniYz0PwMQ7QC0kxE9IXBchTMb0bl1by2rbRLGnnue7UKxdKD3UsC/QMvr0yBQo1+EVhssvKHBjA8486YKNaszX+qq2cAC4xqszwaiVE4VS0rIu+ezyNQ/OBModkO+FTRaB94mf7MHFS6dRNW1LqUrF7T/CAbYmCG5Pem+SvrglsljQpfdkBPXa2WT7Oj4hx2+Ep4dZOu7kzUeOfj4SfQuHfnOubepkWKoyqfnlNKeA5jzGsBGFE1GOQO3qtfFeYfnm8xlIBnnvEOUf+lu3VAYTD30+4tsc12KFJAsIpemSRi16jy7chMIY/C4wpBYeTpAoMYDzzmb4VVB2WrUp8nTFye1sEdrAO5aQj2Q1rHCxAYlr19r9cSTkjHygVhfMnr6tUks1xNV9sk07h5zsb4sHIVYLxlURusL8McOY3Iwb7KStRdsVFY2y3V0UxlV3topGi3IWOyrdEYpierTOd4KkC7xna6GCEbvz6aPgSKxdjhdRpYAs00h12BF2UrJ/McplY5joZ36iK64tDxpo+feTQLTtQEPOpssNkrf0hFmcDs54cBD6iafgy/hV+2ruYTAjpLHfRfKashvnYccWFnnoNHyIFN7mhM8YlkP4PtvTTY1fV7A2HnAQ6bwDywJCHcMTROmeeq9QFlCggyCvTPnIW
 veiv+fh8
 bsjFCDTB8D34XR3LiHOSjpiqbLFZ+EZtHF56a09Cthbu7HCHtG7xaYUXaknpURheoSZETkhvK3uKpbtlx8Cwa7/bWir3VxlZJboP95qpVt1jAaFdghJkaGd+U7p72LdHpZCzoVef75hNG68M4Ji8EiwEMwUiNwO1V63JzOvTAkGDayZD3ScmEojnIOMMRQADw0BU8ASx8dYP8ibi3LaLD4G3XY7ebud7hyqp9omI4qNjhBoSj/4Ueh5rUrbzFSeR7RGEO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/30/2026 9:06 PM, Sean Christopherson wrote:
> On Tue, Jun 30, 2026, Xiaoyao Li wrote:
>> On 6/19/2026 8:31 AM, Ackerley Tng via B4 Relay wrote:
>>>    arch/x86/include/asm/kvm_host.h | 4 +++-
>>>    include/linux/kvm_host.h        | 2 +-
>>>    2 files changed, 4 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>>> index 8e8eb8a5e8a6b..1bde67cf6eb0e 100644
>>> --- a/arch/x86/include/asm/kvm_host.h
>>> +++ b/arch/x86/include/asm/kvm_host.h
>>> @@ -2394,7 +2394,9 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
>>>    		       int tdp_max_root_level, int tdp_huge_page_level);
>>> -#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
>>> +#if defined(CONFIG_KVM_SW_PROTECTED_VM) ||	\
>>> +	defined(CONFIG_KVM_INTEL_TDX) ||	\
>>> +	defined(CONFIG_KVM_AMD_SEV)
>>
>> Maybe we can just remove the #ifdef and make it always avaiable?
> 
> No, because common KVM keys off the macro to determine whether or not PRIVATE is
> a supported attribute:
> 
>    #ifdef kvm_arch_has_private_mem
>    static u64 kvm_supports_private_mem(struct kvm *kvm)
>    {
> 	return !kvm || kvm_arch_has_private_mem(kvm);
>    }
>    #else
>    #define kvm_supports_private_mem(kvm) false
>    #endif
> 
> And also whether or not to provide the in-place conversion param (without PRIVATE,
> conversions aren't supported in general):
> 
>    #ifdef kvm_arch_has_private_mem
>    bool __ro_after_init gmem_in_place_conversion = !IS_ENABLED(CONFIG_KVM_VM_MEMORY_ATTRIBUTES);
>    module_param(gmem_in_place_conversion, bool, 0444);
>    EXPORT_SYMBOL_FOR_KVM_INTERNAL(gmem_in_place_conversion);
>    #endif
> 
> I agree the #ifdeffery is ugly, but kvm_supports_private_mem() in particular
> needs to evaluate to false if PRIVATE memory isn't supported.

I agree with the above after seeing the later patches. But just to the 
state where this patch applies on top, the #ifdef is not necessary.

Maybe add some log to explain it will be helpful.

