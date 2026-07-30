Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E93FAC55165
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 23:49:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9DC86B008A; Thu, 30 Jul 2026 19:49:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A27956B008C; Thu, 30 Jul 2026 19:49:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 916606B0092; Thu, 30 Jul 2026 19:49:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 685306B008A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 19:49:22 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E007E1402F3
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 23:49:21 +0000 (UTC)
X-FDA: 85047086922.25.84BD4D7
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf17.hostedemail.com (Postfix) with ESMTP id 411FE4000E
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 23:49:19 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SAEFzgt+;
	spf=pass (imf17.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785455359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LblOIv/FIoElGnMN5aj+GTRM045+ZcMq1qCGy6r+sT8=;
	b=WIX1R0mBlk0BrkXoGkrN1USvziowDdUQILkoSLQzW5JqeBpMQFBAtO/4jCwrJtSiiwBn7T
	sH4ZP7dKvbx2yezhFeFnqJS741OMnde0SE69vkRTim9x/Cjnf2ropNzjTRHTiQIdDZ2LC4
	7UozKfPGcqCL5JjKxqox/WQ4e4Hy4KI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SAEFzgt+;
	spf=pass (imf17.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785455359;
	b=1czke6C3sDI4QVqsI0o8LSSel/5165cxjW67ZgKOW4cpOhpKWn0CNWL+qJVPe6JxzVzngO
	UnuIhNTRxfle6GI/3jJOIt1cyApMjrJud7DIHZkK5HvWlEydSWUcu0QiObMqUNk0n1tP1e
	rEAn4TcKepKWtSvqSrvYtOGEeB0RzSc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785455360; x=1816991360;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=EBqRt2FUcludAcZTS+/lEH3JghanKhXyWdirr2aKXZk=;
  b=SAEFzgt+jBfWI0TLRkBCRNBfCN0I8oNJ3FGWzcrCjuR0iOIQDPick8PN
   juzAwnRKL3PYOvWxZIeFyhtZCqoU5iLUoGzUmNwn2phgPL6sNOBvzrTcp
   pXWQN1NfgMy9Uax+ZcKPjjGuTDW5Loj5ZqFVzZBRTjAqIzs2VJynlECRQ
   lIOu8n30pqoS8lri36pvznyy7GQTjzg9Vaz4YuPSLTWdH8a3zhOyc6gI9
   P16XV3pN4FUQNcd3SUkmfl1CdqDi49sjXC+Eo9H4BE9iRMR86P8qIzHI4
   x9iZKoVdIrAdBwO5L+HfLSPC6DoAnKEKEivepvCgYojbkxR/8HJ0/KD17
   w==;
X-CSE-ConnectionGUID: 0o2mdWkMSHCqrupBoDwN/w==
X-CSE-MsgGUID: rXcIjJbyRemPGnzGBCQmUQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11860"; a="96670043"
X-IronPort-AV: E=Sophos;i="6.25,195,1779174000"; 
   d="scan'208";a="96670043"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2026 16:49:18 -0700
X-CSE-ConnectionGUID: 3hvv/sojQLGAat42r0fN/g==
X-CSE-MsgGUID: 6mgkoACnRjCJhd9evfHvNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,195,1779174000"; 
   d="scan'208";a="298631756"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.248]) ([10.124.240.248])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2026 16:49:03 -0700
Message-ID: <dd4201f2-3660-46ad-958f-c70feb1ab1c3@intel.com>
Date: Fri, 31 Jul 2026 07:49:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 07/41] KVM: guest_memfd: Wire up core private/shared
 attribute interfaces
To: Ackerley Tng <ackerleytng@google.com>, aik@amd.com,
 andrew.jones@linux.dev, binbin.wu@linux.intel.com, brauner@kernel.org,
 chao.p.peng@linux.intel.com, david@kernel.org, jmattson@google.com,
 jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org,
 pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com,
 rientjes@google.com, shivankg@amd.com, steven.price@arm.com,
 tabba@google.com, willy@infradead.org, wyihan@google.com,
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org,
 suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>,
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
 Peter Xu <peterx@redhat.com>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
 <20260728-gmem-inplace-conversion-v9-7-35f9aec2aed2@google.com>
 <60d19013-d6d7-4eec-827a-2622e22cec98@intel.com>
 <CAEvNRgF0SxmoMtqq69tUih54A9K7j_wcMFRrq=r9w6TnAGAUQQ@mail.gmail.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <CAEvNRgF0SxmoMtqq69tUih54A9K7j_wcMFRrq=r9w6TnAGAUQQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 411FE4000E
X-Stat-Signature: skjkapuh37tk1ud86p9c9yp93pxkntye
X-HE-Tag: 1785455359-224210
X-HE-Meta: U2FsdGVkX1+7GjwnFu5mIxTo0vZh9LBANSfgb/Ac7cTuXTJN6sCoIorteWDB9mWq7rdXreaujgFkxkD+XLAzbK+Yik7YbMvqDBdmzKoxDuz5zCuhAkTJfrdJucFolMnuSKSUV7H9Samyyov95xtEcAD0hX1bAHO6GYpMoE4GwjnQoaHrG/BJ5XKjkpHAKHsyU5D52VHn2LwnVssaiAxLzwlagefdLlMjLpNhLjzx/j/tR3AyYUcFjZ0ZcSbBktHeg5yz6tOG/pfdciXsgHCvWwv/Q0eMhcbMqu3esJZ8Fnb5kRqcNqlH8/Ij0D3le6vk6h+EMbdtUdKIGvsfskDW9ZNtq2066muDPCZXwl5unx6pH6U8Uq+i8r01T164tspEw4+moM09FVyQ7oyxsQ7t7pliWxeikQDos/3G26JWVKFEuMy5ccK/y8Mm9KVC06L8BoH91IannYqvZuwsKX8vwZAqZeNmGaX9tShoNlQluLYul7MZQ9Su48JQVYcAQ+2b16gjxIXz7wGr1krys2WR3ZYBIkud8S5pOl2LkhUv9Hb89uwXuC8fyKvkyHInXTDEsh+NszswoNy4UISXCOYB9PcUBTA9vyKz3JcX4fNKq44BbyUH8ggAT4Yr3XBzVq1m6exI08qUB+/HJORHl8L32JE8VBMtLtjZfplFIsC96DEXdlnFQPJGn6P96Fxhx1cTOXXrn0ndhvGLRL8JH6pvpdzmroc5GZDBdPhWEY/YKWvKJZ3Vk9+mKU4297TA+aoxqnqfLpzBbAVN9yUIl0CLZUTGEGkX0KWpUExud17yD7K7mk/6W1Wtwmiq6VWiMVoo9+OeCldi7AhsZ1qNrWaxDtGly3sbvDeZhq6FSkUA9JABOoxXphjljCYg3ab1CNvMuKZrEV6dsBS3tq3qSnbr5kXDRLBgzmxo1cEEZg5n0fdNu/73ytYRP1Yk10Lmh1UA8GMabZsvupSCteYeU0T
 PsmVuv+a
 QpwwFAS+mH/1eKLnoPthtnwGLoM7/EJRPO0p7N33Q9mJdJGFwsrZO6y+fqFmcBZjNULHDKOFQsGv2Vt/AxKqkvm8P20E3QlsCXjMFc2bxy5qMdd0f3r8GwT5UpY2iGehMe8I7N6bH45c7Yd2l2uc9/SY7g7p+PBVNOVzGI3IL7FPHB9+8U80R41l17jIUkCGn3EfN40+wZ8M7XcyvoB/oz8MmFYb4/sl5QMmegB91Ygusdtu1S2eKOLbPSnePZbEwB1xCXquHCqSjg72X9yUsMaZI4s7oS9ZHjUH4306TbhRQiJDT3dw3xRvLVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/31/2026 4:42 AM, Ackerley Tng wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> 
>> On 7/29/2026 8:35 AM, Ackerley Tng via B4 Relay wrote:
>>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>>> index 33c9830190e2e..89cf922232920 100644
>>> --- a/virt/kvm/guest_memfd.c
>>> +++ b/virt/kvm/guest_memfd.c
>>> @@ -893,6 +893,27 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>>>    EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
>>>
>>>    #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
>>> +static bool kvm_range_is_private(struct file *file, pgoff_t index,
>>> +				 size_t nr_pages, struct kvm *kvm, gfn_t gfn)
>>> +{
>>> +	struct inode *inode = file_inode(file);
>>> +	pgoff_t last = index + nr_pages - 1;
>>> +	struct maple_tree *mt;
>>> +	void *entry;
>>> +
>>> +	if (!gmem_in_place_conversion)
>>> +		return kvm_range_has_vm_memory_attributes(kvm, gfn, gfn + nr_pages,
>>> +							  KVM_MEMORY_ATTRIBUTE_PRIVATE,
>>> +							  KVM_MEMORY_ATTRIBUTE_PRIVATE);
>>> +
>>> +	mt = &GMEM_I(inode)->attributes;
>>> +	mt_for_each(mt, entry, index, last) {
>>> +		if (kvm_gmem_interpret_entry(inode, entry) !=
>>> +		    KVM_MEMORY_ATTRIBUTE_PRIVATE)
>>> +			return false;
>>> +	}
>>> +	return true;
>>> +}
>>>
>>>    static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
>>>    				struct file *file, gfn_t gfn, struct page *src_page,
>>> @@ -913,9 +934,7 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
>>>
>>>    	folio_unlock(folio);
>>>
>>> -	if (!kvm_range_has_vm_memory_attributes(kvm, gfn, gfn + 1,
>>> -						KVM_MEMORY_ATTRIBUTE_PRIVATE,
>>> -						KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
>>> +	if (!kvm_range_is_private(file, index, 1, kvm, gfn)) {
>>
>> It's checking if a single gfn is private.
>>
> 
> But with huge page support we'd need to check a range of gfns... I guess
> there's the argument of not keeping complexity for the future, but in
> this case it's undoing functionality for this series and probably adding
> it back later.

let's leave the work for huge page support in the future.

>> We can just use kvm_mem_is_private()? And it seems can be a separate patch.
>>
> 
> Do you mean that this refactoring could be a separate patch? I could
> refactor out kvm_range_is_private() in a separate patch, then put in the
> mt_for_each() check in this patch together as part of all the rest of
> the "wiring".
> 
> I considered that but it seemed like the refactoring was too small to
> separate out into another patch when the mt_for_each() part is going to
> be in this patch anyway.
> 
> Or, I could add an earlier patch to first replace the call to
> kvm_range_has_vm_memory_attributes() with a call to check just 1 gfn,
> then this wiring patch would be simpler.
>

This is what I meant. An earlier patch to just replace 
kvm_range_has_vm_memory_attributes() with kvm_mem_is_private(). Then we 
can drop this 'big' diff in this patch.

If kvm_range_is_private() is useful/required by huge page support, then 
let the huge page series to introduce it. It has nothing to do with the 
in-place conversion series.

> Let me know what y'all think is best. Thanks!
> 
>>>    		ret = -EINVAL;
>>>    		goto out_put_folio;
>>>    	}


