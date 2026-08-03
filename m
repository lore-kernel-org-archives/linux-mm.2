Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35D1DC55174
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 02:43:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E0226B008A; Sun,  2 Aug 2026 22:43:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 351F16B0092; Sun,  2 Aug 2026 22:43:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 219FE6B0093; Sun,  2 Aug 2026 22:43:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E67E96B008A
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 22:43:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 60105A1DF0
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 02:43:48 +0000 (UTC)
X-FDA: 85058412936.20.8C48A35
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7A8FD40002
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 02:43:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TZ0VWjQu;
	spf=pass (imf04.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785725026;
	b=5LcUTKGn1Lei8MKtX0VAZ76i+xHLKZvWt+80O085FAqeGWarX+wDsPcNlniJWRixa855u+
	TQK5m9G2/CPYi710LAATpxfktV83ulY+Oy+wGnQbGEudYQvQMsc7ZmLTrkyLcPi9rQlU80
	tiCQeicWJAKWuZhxX/hjJKzNAL9PEeo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TZ0VWjQu;
	spf=pass (imf04.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785725026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ozbrtj9FKM2gMHyvXDnf8Gn+fcpcrIHrGbkMU6IvrJ0=;
	b=GcgNXyJAMufOByw9zAQ0Qx+OjUL0GDZ37FcPuDxtHJYxuA4g8ZsHZ6RXGGXQryvQbR1vuE
	wCGDrgGeXiLHqAuAgBo/zUUBaQFD2lG2P4Cxkir9qZlL8JndTTY4cQm0vFx8fHHlvKEqti
	mHYY4raXBkAAL9Fds7G2LCNZtilobLM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785725026; x=1817261026;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CFNSytE+2tg0bkqq7UMDHzkgq4F5EqtfTyEFf8TpgrM=;
  b=TZ0VWjQuQacua1BR9lpqi6IzOVeR30HmIAHLHuDqNOElkDFTvRIB2Nhh
   o20jt4p49IgnkZMdwCtU8rt+fF2bp1RC6xnJtzBuccRiFfGBkTJXYV1OV
   Rg9HktLJhwPtqmxhh1Ca0+laU5t4QOi6rXOuJKxURimcZGl6q66z+rngZ
   de1cYMO4EA0gwzuCwskSqhnyk4j4qwrHh6gip8Pw8IKlkDCfxiXKBjhIb
   QlTtSoHhqdmYj5DVo7nlDlnsRKJ7bLDZGPH6adIzT3QMc8zlii9TtHPN+
   6fjwVdaydCJizWnNw2spi40/Q3FGTlQBTOmpHZNKxqMXqwk8CQOvNgoBo
   Q==;
X-CSE-ConnectionGUID: jepbuVVgQsC22RNXIzQPIw==
X-CSE-MsgGUID: q08kxDkjSCi0O8psoCC0Cw==
X-IronPort-AV: E=McAfee;i="6800,10657,11863"; a="90143903"
X-IronPort-AV: E=Sophos;i="6.25,201,1779174000"; 
   d="scan'208";a="90143903"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2026 19:43:44 -0700
X-CSE-ConnectionGUID: BEG4ZP1DRymmaTKVaWpetA==
X-CSE-MsgGUID: B7M1+kP7TIiUCgGwEr8Lcw==
X-ExtLoop1: 1
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.248]) ([10.124.240.248])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2026 19:43:30 -0700
Message-ID: <25ab36cf-888a-4547-b3f7-5bd4e057c1d0@intel.com>
Date: Mon, 3 Aug 2026 10:43:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 07/41] KVM: guest_memfd: Wire up core private/shared
 attribute interfaces
To: Sean Christopherson <seanjc@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>, aik@amd.com,
 andrew.jones@linux.dev, binbin.wu@linux.intel.com, brauner@kernel.org,
 chao.p.peng@linux.intel.com, david@kernel.org, jmattson@google.com,
 jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org,
 pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com,
 rientjes@google.com, shivankg@amd.com, steven.price@arm.com,
 tabba@google.com, willy@infradead.org, wyihan@google.com,
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org,
 suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org,
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
 <20260728-gmem-inplace-conversion-v9-7-35f9aec2aed2@google.com>
 <60d19013-d6d7-4eec-827a-2622e22cec98@intel.com>
 <CAEvNRgF0SxmoMtqq69tUih54A9K7j_wcMFRrq=r9w6TnAGAUQQ@mail.gmail.com>
 <dd4201f2-3660-46ad-958f-c70feb1ab1c3@intel.com>
 <amzMtg4K6qEEsudx@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <amzMtg4K6qEEsudx@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: yqtmwpmdx4ox54fjqi3jx4tsuynx47zx
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7A8FD40002
X-Rspam-User: 
X-HE-Tag: 1785725025-693096
X-HE-Meta: U2FsdGVkX19Ym8tKF3w4nnCphj+GMUw8enkjiHVnA3LUzTJXwIOlQ1sFjV0hhBKgtomcLob3z6yk4yVz41i5MRS71/87Y3tvNWy2xr0y5ZY/8D1JJNOV3eoBjJ4ISkYHRzhXpSrAMpd6IMQAIEQeHBI01lY4EylcR6e21BrjjfGxZKUBbGGUqfyrKm3l8Qfg1CeO+MU1sIEll9MlxGCzN/7JKDuTRZ7Kg+2hRTaXuoymXYC05JQJCtLSEP2zxOdk8Y6DImHD+1YAnBmWfYyWQHq7P6+CGr+WagfhuQ6Qu9WK/+9GhZE6pHGZg13HyNc3rYI1kdYmp3AP5RXB1+DOBiLnpgFceZbI/1JCx472AdWODJbERdWc9ZW2o0qgHNbfftSn5vdcnnz6dC5Sq0R6JrgRFGvP3VocRAEiGVsKmd+qVPflpki9TQ++7VfcE0M+3GFnoPn07u+uiVxl/xpsjBnzjCQh27wLiSxypsp/HnPr9xbk62JefIafPW74Yty544/HMKayv8hdDbqmEedHpFYeOyY9Dz+WbWzyebgU9lKRQsveZbkGQ+4Gn3cKZk1xkadCKI8a+fZwu4Rx1anifh5E22HVAY5DWYvF95NZvExf8kkdtCkoG8h7uKi8awf2+wQ7c1KaJ//at09n6AD66elwKc50CKk41Gruer2nUENHda/TOoaSb0o2HjshqpUNeKHLuLk2a80srDRFwIhzHVkB4dsdvI0Ecb10IKJ4Wf1hd4V1qbACchQB5CAqJdU2CZoj8Aus2hWOUILYVna9zWw1CBMhyfqDjGNWvvmVhxwsCCf+oCsDyguBjF4RkicutaoI+mxVNXTeOYO+QabUWqS7ZDGdvu/twUwXvY4bRu9hpCR+V1t/Rj5Z6gvRvq/pWI5oFZDooOZmiY4ZFJRUZ7GeYTlvnsrGRcdtVrOqw0ak8UVWP/vy7WwW25FFzxOB2XjkZ9PVFKE0NTu8y1q
 vKJfslZx
 IIe3jGfw8IaWWmsIY9CHjCV5UhsBElXaQRbJ+ps3SkOfKOegOsAEy3JJx/zyg8Ht165X66Y+lLDYJqIeVAOPnxk2m6FdA8TfBpAl6esiL6IJ2wDmwTXcfEBIw/2+uTPXtg5ZHHEWr2HMyO7ZvFbXeFZNSfKVMygA/xNWOQGQRlda3vHK7r8F+RH2kvgAWlJ3BsAGrAbER4qjk9JvrK+b00yImEK4GEVsMGThRQ9jjF0gK7M+BWlnEj35TOFFv/LiJODVYopEw7RwUhCbj9NizDOrxFg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/1/2026 12:26 AM, Sean Christopherson wrote:
> On Fri, Jul 31, 2026, Xiaoyao Li wrote:
>> On 7/31/2026 4:42 AM, Ackerley Tng wrote:
>>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>>>
>>>> On 7/29/2026 8:35 AM, Ackerley Tng via B4 Relay wrote:
>>>>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>>>>> index 33c9830190e2e..89cf922232920 100644
>>>>> --- a/virt/kvm/guest_memfd.c
>>>>> +++ b/virt/kvm/guest_memfd.c
>>>>> @@ -893,6 +893,27 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>>>>>     EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
>>>>>
>>>>>     #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
>>>>> +static bool kvm_range_is_private(struct file *file, pgoff_t index,
>>>>> +				 size_t nr_pages, struct kvm *kvm, gfn_t gfn)
>>>>> +{
>>>>> +	struct inode *inode = file_inode(file);
>>>>> +	pgoff_t last = index + nr_pages - 1;
>>>>> +	struct maple_tree *mt;
>>>>> +	void *entry;
>>>>> +
>>>>> +	if (!gmem_in_place_conversion)
>>>>> +		return kvm_range_has_vm_memory_attributes(kvm, gfn, gfn + nr_pages,
>>>>> +							  KVM_MEMORY_ATTRIBUTE_PRIVATE,
>>>>> +							  KVM_MEMORY_ATTRIBUTE_PRIVATE);
>>>>> +
>>>>> +	mt = &GMEM_I(inode)->attributes;
>>>>> +	mt_for_each(mt, entry, index, last) {
>>>>> +		if (kvm_gmem_interpret_entry(inode, entry) !=
>>>>> +		    KVM_MEMORY_ATTRIBUTE_PRIVATE)
>>>>> +			return false;
>>>>> +	}
>>>>> +	return true;
>>>>> +}
>>>>>
>>>>>     static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
>>>>>     				struct file *file, gfn_t gfn, struct page *src_page,
>>>>> @@ -913,9 +934,7 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
>>>>>
>>>>>     	folio_unlock(folio);
>>>>>
>>>>> -	if (!kvm_range_has_vm_memory_attributes(kvm, gfn, gfn + 1,
>>>>> -						KVM_MEMORY_ATTRIBUTE_PRIVATE,
>>>>> -						KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
>>>>> +	if (!kvm_range_is_private(file, index, 1, kvm, gfn)) {
>>>>
>>>> It's checking if a single gfn is private.
>>>>
>>>
>>> But with huge page support we'd need to check a range of gfns... I guess
>>> there's the argument of not keeping complexity for the future, but in
>>> this case it's undoing functionality for this series and probably adding
>>> it back later.
>>
>> let's leave the work for huge page support in the future.
> 
> It's not just for hugepage support, the core functionality is used in this series
> by __kvm_gmem_set_attributes() in:
> 
>    KVM: guest_memfd: Return early if range already has requested attributes
> 
>>>> We can just use kvm_mem_is_private()? And it seems can be a separate patch.
>>>>
>>>
>>> Do you mean that this refactoring could be a separate patch? I could
>>> refactor out kvm_range_is_private() in a separate patch, then put in the
>>> mt_for_each() check in this patch together as part of all the rest of
>>> the "wiring".
>>>
>>> I considered that but it seemed like the refactoring was too small to
>>> separate out into another patch when the mt_for_each() part is going to
>>> be in this patch anyway.
>>>
>>> Or, I could add an earlier patch to first replace the call to
>>> kvm_range_has_vm_memory_attributes() with a call to check just 1 gfn,
>>> then this wiring patch would be simpler.
>>>
>>
>> This is what I meant. An earlier patch to just replace
>> kvm_range_has_vm_memory_attributes() with kvm_mem_is_private(). Then we can
>> drop this 'big' diff in this patch.
>>
>> If kvm_range_is_private() is useful/required by huge page support, then let
>> the huge page series to introduce it. It has nothing to do with the in-place
>> conversion series.
> 
> If it weren't for the fact that the range-based search is used later in this
> series, I would 100% agree with Xiaoyao.  
 > But since the core logic is used and needed elsewhere,

I don't see it a problem. Without introducing kvm_range_is_private() in 
this patch, the core logic of range-based search on gmem can still be 
introduced as kvm_gmem_range_has_attributes() directly in patch 10 or in 
a separate patch.

 > and because kvm_range_has_vm_memory_attributes() takes a range,> my 
vote is to provide the plumbing now, even though a small portion of it isn't
> strictly necessary.

So my initial feedback was "we can just use kvm_mem_is_private(kvm, 
gfn)". It makes code simpler. And as a bonus, the logic to choose 
between gmem-based attribute query and vm-based attribute query is 
hidden from the static call.

The second bonus of dropping kvm_range_is_private() is that we can 
eliminate one more chunk in patch 20.

