Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5A1DC55182
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 02:21:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF6846B007B; Mon,  3 Aug 2026 22:21:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA67B6B0088; Mon,  3 Aug 2026 22:21:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6E606B008A; Mon,  3 Aug 2026 22:21:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 682BB6B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 22:21:20 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E79C31C11BE
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 02:21:19 +0000 (UTC)
X-FDA: 85061985078.17.56B2508
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf10.hostedemail.com (Postfix) with ESMTP id 77BDFC0006
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 02:21:17 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=n5URVGG8;
	spf=pass (imf10.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785810077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4flt237WY2Z0ZHSYYroEZi6u7igH3Hfpwu43V+wrtU4=;
	b=GeCUauexDulZC2PpjxZ4CZWIIykO/RUCEsQousor4J0/D29oMuCrJvvw0Li/n3x3TSQvXg
	1G3t8eWSQEG0mKq5rFI8/RXKajiDpX5W+8WqCEi3mvH0OCowM4SIPul6U0hPmkp3elnNS2
	tqzztRy+pMT2tgDDrKUJNGyOPUUPgWs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=n5URVGG8;
	spf=pass (imf10.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785810077;
	b=r8P/EU2bO7r7rKgmMGH+TXUi99FEju1BOIsI/hHLeypH0qYiGl2wvwPjbiI3+xCsu3rcmR
	jSjyO982rUQ9sjS4hZi06WDmQJNqy+KzwGmc8LFKe2wGZG/tumC3dtVolYkhj/eNt14bne
	ltvOa1EGYCQxxNor5b0PkD5L2mvrGNQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785810078; x=1817346078;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+ungbiIvue01mlh3xVvXxn27VLIAH9BlA+zmntBJ5rM=;
  b=n5URVGG8eAdSZ5BceLrtT0gG2GrtVhUeIixoI1QzWc/6TZE/5O3Rm3ek
   Tx/IFWssCbBE1qzH4JfcqiQVyRyYeKC+RU2cmnMTTpuHorsV4BGxTIWrz
   2Llm+9EfDasg0T2WyIFT8YMPRc7MHpjNUQCVKhuMieWl+Nf99Me2kwhx+
   JchT/ZVxV2wp3TeW62wAc8H28cVdZ63GtgYNDLeSPpjGUOx4LRCsChsIP
   caTLW6cYwQSzp9oFIyO+9BmzZ7Yj9nR1qydejXr+w+TIJfiB/JBh4gF7R
   sa8NVyIE5UEDVUMKBheqE9x8g7z/XRrlrvzCVfzBnRpLJ/nWSRg/LFMym
   Q==;
X-CSE-ConnectionGUID: eLPb5+g3TKiLE3X9X6003A==
X-CSE-MsgGUID: GPzatvS5S6m2EGkYmZIgwQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11864"; a="86122361"
X-IronPort-AV: E=Sophos;i="6.25,203,1779174000"; 
   d="scan'208";a="86122361"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2026 19:21:16 -0700
X-CSE-ConnectionGUID: wexSi1NfRrucV12fpDeh0Q==
X-CSE-MsgGUID: Ov1ycEjhQ0S6ouDKkZLVyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,203,1779174000"; 
   d="scan'208";a="266496543"
Received: from fuxiaogu-mobl1.ccr.corp.intel.com (HELO [10.238.208.47]) ([10.238.208.47])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2026 19:21:03 -0700
Message-ID: <8baf2065-b07f-4555-9c16-1330ecec4903@intel.com>
Date: Tue, 4 Aug 2026 10:21:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 18/41] KVM: TDX: Make source page optional for
 KVM_TDX_INIT_MEM_REGION
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
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Vlastimil Babka <vbabka@kernel.org>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
 <20260728-gmem-inplace-conversion-v9-18-35f9aec2aed2@google.com>
 <d3fef015-0546-4993-b354-a8464d79e48c@intel.com>
 <amzJQ8u8I18B4Gdm@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <amzJQ8u8I18B4Gdm@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 77BDFC0006
X-Stat-Signature: qxrm6s535innbx43wz4jcp5tnhc55dc8
X-HE-Tag: 1785810077-153423
X-HE-Meta: U2FsdGVkX19xczZcdlD7nbKCeTM7Z7o5HIPu1zBMy5zgpAs1pzJ5WwfGiw2VIe+1X0ZKpOVHRDbCjVzZ79PxMYjSC1URWZCqfF3my9/XylHUeYPLhMKJmnVWSXSiG3oKzbugMWvFh9BjhNPJlvvXYw+0+DuTVcKfu+FE5v/+bgMJMopkEJlfhsRj3it/KJ6PL+AkFtoHug613WYAXyWCXMsry562FyUQcq+fKZHuDV0nAMHQA2ihIJ63un+nqiWUftGsI5y/g34q/4fuYNuxSXhV0xaGypTsQJxjnm8DQ4Qt5mW4GxWkjO9lxt7z/mVb6a5Vz4tQWpRGGXBcs01Btq173jPjZ+BTPa3gFUPGzRExJHwwuAL7inRrwvFhkvXCsoUGGKFrBCQXCV2rU8yIoOz5M0DCOnEqSaddv70mAHlshWAYrV59mKHndnC3Cb4tBOUu0e0WgfxInJFiYkGkQfim450ydTEbbDkXJDIlyWfam5f1zbKSdkVuvscHnBAH2hZbpz/nPRKDdBMMyfQxz6ep/3L3elwUzMHN8g0fTA3A/TQ836EGQ9R6OekU68grPClsuPK87T2+e39MODVNdwM+HKKBqN+We4CWKWDApFDnZWnWz5Bqpg1gY9wepyyqiJI8FcTP3mhv/SdiNK+EcW9l7DifiCzwkKZpcyM8FNAVhVnsSvxb9+LffWfARnHhedN+6eGbCekArB/ElZyOj3/OGhZlqWHMeGqyrqXr4nUviLq0+eT7ZIxSSYH5JU0bQH3xEVSYOP6wlhd39LJv0b1589vi60svclXTWk3E/9Fa4JL03rlW3wQKmSKCFhhRJm4ZPeBFuFuzfjWLe7tqFPuWPA9V3gFnsSHJ5KIEeYKSx/zP1lh43KrfDOYOWtIy3K0KrFTrIr1+c5+l9Lg1VQQzdMApszJhUugqhxQ24W9mF30HHE2Amu/sdclNgL5dAMXZd0RXtgW8E4ReEaF
 YW8enwdV
 O0vR2zhmN6tGpXGltpX7ElVqXwmTkm0SzmYwa1XyD40V10zwccyFz0UvtU1e1c8oBMIw8CFIJSC9bIUlDNymRdr2N61+C5t0yNwT81KouwG2wJKpSffUWDKNfvBKFAZf/CMMlgkOB4M5tY0OTxd0PENMlM54JdBbiumpNsGvVbvMyxduJxAkwEVQTnsy1KgHDjyddDma6oEAkkWsuHu5XuToFE0XDGnV5pyfPt4YNZBiwXpCc3sva/pC6Ry+/MTV00Q/NINQhIbfXjrY2mrGpi7U9DvCs2SQYfBt7ZaW/heRTb/GP1jLJ9qLz3H6KZ9nGoMZD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/1/2026 12:11 AM, Sean Christopherson wrote:
> On Fri, Jul 31, 2026, Xiaoyao Li wrote:
>> On 7/29/2026 8:35 AM, Ackerley Tng via B4 Relay wrote:
>>> From: Ackerley Tng <ackerleytng@google.com>
>>>
>>> Update tdx_gmem_post_populate() to handle cases where userspace requests
>>> "no source page". To handle "no source page", populate (perform
>>> TDH.MEM.PAGE.ADD) using memory in-place at the target PFN.
>>>
>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>> Tested-by: Shivank Garg <shivankg@amd.com>
>>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>>> ---
>>>    Documentation/virt/kvm/x86/intel-tdx.rst | 4 ++++
>>>    arch/x86/kvm/vmx/tdx.c                   | 8 +++++---
>>>    2 files changed, 9 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/Documentation/virt/kvm/x86/intel-tdx.rst b/Documentation/virt/kvm/x86/intel-tdx.rst
>>> index 6a222e9d09541..d8d9409120e61 100644
>>> --- a/Documentation/virt/kvm/x86/intel-tdx.rst
>>> +++ b/Documentation/virt/kvm/x86/intel-tdx.rst
>>> @@ -158,6 +158,10 @@ KVM_TDX_INIT_MEM_REGION
>>>    Initialize @nr_pages TDX guest private memory starting from @gpa with userspace
>>>    provided data from @source_addr. @source_addr must be PAGE_SIZE-aligned.
>>> +If guest_memfd in-place conversion is enabled, pass 0 for @source_addr
>>> +to represent "no source page". A source page is required if in-place
>>> +conversion is not enabled or not supported.
>>> +
>>>    Note, before calling this sub command, memory attribute of the range
>>>    [gpa, gpa + nr_pages] needs to be private.  Userspace can use
>>>    KVM_SET_MEMORY_ATTRIBUTES to set the attribute.
>>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>>> index d1af0a752e97e..e890da5f18aed 100644
>>> --- a/arch/x86/kvm/vmx/tdx.c
>>> +++ b/arch/x86/kvm/vmx/tdx.c
>>> @@ -3192,7 +3192,7 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>>>    	if (KVM_BUG_ON(kvm_tdx->page_add_src, kvm))
>>>    		return -EIO;
>>> -	kvm_tdx->page_add_src = src_page;
>>> +	kvm_tdx->page_add_src = src_page ?: pfn_to_page(pfn);
>>>    	ret = kvm_tdp_mmu_map_private_pfn(arg->vcpu, gfn, pfn);
>>>    	kvm_tdx->page_add_src = NULL;
>>> @@ -3238,7 +3238,8 @@ static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *c
>>>    	if (copy_from_user(&region, u64_to_user_ptr(cmd->data), sizeof(region)))
>>>    		return -EFAULT;
>>> -	if (!PAGE_ALIGNED(region.source_addr) || !region.source_addr ||
>>> +	if (!PAGE_ALIGNED(region.source_addr) ||
>>> +	    (!gmem_in_place_conversion && !region.source_addr) ||
>>
>> Sorry, I still want to discuss why we only allow in-place PAGE.ADD for
>> gmem_in_place_conversion only. Though Yan raised this opinion[1] in previous
>> v8, I'm not quite following her argument. So let me try again.
>>
>> I think in-place PAGE.ADD of TDX doesn't need to depend on
>> gmem_in_place_conversion. There are two use cases actually.
>>
>> 1). Userspace sets the gmem page as private, and invokes the in-place
>> PAGE.ADD by passing a 0 source_addr. Due to patch 16, the target PFN will be
>> ADD'ed to TD as a all-0 page.
>>
>> 2). Userspace sets the gmem page as shared, and writes the desired content
>> to it. Then converts the page to private, and invokes the in-place PAGE.ADD
>> by passing a 0 source_addr. The target PFN will be ADD'ed to TD with desired
>> content.
>>
>> For gmem_in_place_conversion == false, only case 1) is possible.
>> For gmem_in_place_conversion == true, both case 1) and 2) are possible.
>>
>> Basically, this patch is changing the behavior of KVM_TDX_INIT_MEM_REGION.
>> Before, it returns -EINVAL when region.source_addr == 0. Now it wants to
>> allow the "region.source_addr == 0" case. If we can allow it
>> unconditionally, why bother adding the restriction to allow it only when
>> gmem_in_place_conversion == true?
> 
> As I said[*] in that thread:
> 
>   : Because retroactively adding support for out-of-place conversion is pointless
>   : (requires a userspace update for a feature that's being deprecated), KVM can't
>   : generally support using the source for out-of-place conversion (it's effectively
>   : an obscure zero-page optimization), and IMO rejecting the out-of-place conversion
>   : scenario is valuable for KVM developers, e.g. to help newcomers understand what
>   : exactly is and isn't possible.

Fair enough.

Ackerley, please update the changelog to add the reason why we decided 
to only support in-place PAGE.ADD for TDX for in-place gmem only.

> [*] https://lore.kernel.org/all/akMPZePBdwQlD74H@google.com


