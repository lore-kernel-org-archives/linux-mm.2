Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29743C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 09:45:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 239EF6B00F6; Wed, 12 Aug 2026 05:45:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E9AF6B00F7; Wed, 12 Aug 2026 05:45:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B5356B00F8; Wed, 12 Aug 2026 05:45:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D40CF6B00F6
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 05:45:51 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5AFD680112
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:45:51 +0000 (UTC)
X-FDA: 85092135702.13.0EC3020
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf14.hostedemail.com (Postfix) with ESMTP id 95DCF100007
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:45:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Nq6CsukA;
	spf=pass (imf14.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786527949;
	b=vGoTU/Hb5P6e92+uQwkCV6wKKawVWxWwe4N5QJQztHtIkHOsnfmO2ZRRBOLuGNXKolN0dg
	1T5HO4oCpYe9AfDlDmvin8fFf0SYZvcxUMa6EC2q1e2cMs8a3gBV7BK6HWMWHh3+flq2mx
	slcNYIKfMQoWuCZRS3lTeJanhrKqDyA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Nq6CsukA;
	spf=pass (imf14.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786527949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MeE5ontgY1hh1Gn3h57f+BRqxtyeT2e58zvWam3vuHE=;
	b=1NCe3r1LGL2eOYKjKWcyWWS7HTKwTuuyvagwvXpSuPiqumxSo2INvA5AJ/Rghrbef2XewB
	3dOykFHnO58Z/BLzpYg/FnJ10CoVBmqOdr6h0VsEDZzT31XYWrkz7r5wJ0UXpB99/ZVwtF
	wfOCD6q1ZnPGYxJ/lCIVYO9UcwalP2s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786527949; x=1818063949;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=k2pFVBuHbEgDL9fsrNxSQM9oxmXhYdThPBDj2S6Ri8o=;
  b=Nq6CsukA88EW4mVflNJwIkaKGh97iM2TEIYbMUfKUAn2EL06QniMXxaQ
   n0reO7cdm3feyPh8Ram5iNsGBIgALpSjrbi/JIILUiQzGttE0dCiDWEVE
   sc/eGPAM6oEuNxKK6ZQ5iQ1xo92JbQD4V9mjxO1rFoZkj3ucja7wPz9DI
   nBxpVEsBG6yG0VBZf/+tBb+J+l8kWcN8BjrMwQosh/+wFZAkUIeusSH73
   FZf7LU6VpiuSmU+yIEzRnnHiIusjCk9rPqUzbOI3e9Pqf5AquEYa02AtH
   ihBkBfdHl/GynsSRKrpbXz18YVADQZNvO3NnBJCNc3cT1DH8xvCtUV6dH
   Q==;
X-CSE-ConnectionGUID: VvII5jnNRdyN7XN8+OcBKg==
X-CSE-MsgGUID: bdMWGPlnSiCB5J8Nsfwfyg==
X-IronPort-AV: E=McAfee;i="6800,10657,11872"; a="87097295"
X-IronPort-AV: E=Sophos;i="6.25,219,1779174000"; 
   d="scan'208";a="87097295"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2026 02:45:47 -0700
X-CSE-ConnectionGUID: iA51UbaQRN6kQuJUiJ7UBg==
X-CSE-MsgGUID: Sa2YR4TXTseveV8gKuW5Bw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,219,1779174000"; 
   d="scan'208";a="267093839"
Received: from unknown (HELO [10.238.208.98]) ([10.238.208.98])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2026 02:45:32 -0700
Message-ID: <33482cef-9fb7-4a45-b45a-261e0a4e7de3@intel.com>
Date: Wed, 12 Aug 2026 17:45:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 07/41] KVM: guest_memfd: Stub in ability to enable
 in-place shared<=>private conversion
To: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev,
 binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com,
 david@kernel.org, jmattson@google.com, jthoughton@google.com,
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com,
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com,
 shivankg@amd.com, steven.price@arm.com, tabba@google.com,
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com,
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com,
 aneesh.kumar@kernel.org, liam@infradead.org,
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
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com,
 Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-7-2fc18ee6d3ba@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20260807-gmem-inplace-conversion-v10-7-2fc18ee6d3ba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 95DCF100007
X-Stat-Signature: 5hniwfunxu6mbm5regiuf7izdd3r4dkg
X-HE-Tag: 1786527948-790548
X-HE-Meta: U2FsdGVkX1/jmKdzRkuuCk/2oe+UFAK4xu0strfIu5GgDyGCC+lYjGk2pz/kDRbApRCuAHQgZabaThwoB8q9n+K1/PCqWQOJTcrTuVgWkSaZFb4TAM8Z/l4TPb3T+c15Q+7e1ljU7lwd0fduF4Hj5xbHlDH2Xopq/L75vkzvNv8u1KHyVtlRcGMmTAFi/Q01Arf8NBImSJGMxp/7qmeUv9rwbFW/6l7eNNgg+RO4e5hiUkgApIE0coT6vnhtH88wL+BLO/Sz5kups6Is58pawGKsOPM203EatKRSPO/NcVxmdxQSnlhcr7er0s2vndx0wIcm4ODCn3JgNJ/kRWHP8Fh9ss/FT2J0f5sbvHJE1BPRjxo0CF/7HGuY7IpSxVVR1jwOqgpjVzOPv4JtUOror4U7YYUSjjBWbqCG4A/ZkCIiYBlwKvqAvWSYO2IpsdXTQiyuuib2K8tv/xOrH7mglVUCCTHrCbTi3eDIwMhBDvlkTPA5RS9LG7suBwIoyAyTF9TjrpZtZihipBGZCF5HW+50YY0pI6CTesoGz/GmP5zPGT+gW/Esktz3Vd8PQ5rL6M+dPjLaxBKj/B+0jrB3/ee+2UCxdnv7lBu+xVdB2bbYQKG0D4DIMplMiVhzDHY3AwX6BhoKjf5KtXmjRYzlWVYz6Vfb0XumFmzU6GGJuO8LpzX2bpLtik50jHWvTcWVaZymAreLJAJ7eE4zNRDmq/nVWVkA87C4mbZTtH4tatlkWCYJuM4KqohC4clClJILc6h1xQT66/XfL8l/btGmFW7S0Z/dqcPBm/NTOmAH/VRjasrOgKjiiRpE/xgxEXWPXNbAlQOUfp/hT5uBaIm49y4yhxG0LUBzvvC7Dq7B1+Hf76kpnCjl3FAnuQ4zkpDdAzFH+4ng7Eg+/jpkW87oXJmAqbPNEU+1oRM3wWZ2TlGP/rssl1QKFtBhk27jZjPJHw/Cjdb9L8r13a9FCTT
 O7fRVdCN
 6dZvM9pZU9BtQYNnilwlX6tt9tWsrsKDiUVBit978Wa4+rcO3Qt6TDuNVd0X27SSqOk3+0FOw6BWmwNsnK33Mt45lWnBbIvKXsKuh6KL0uOI8SZw1flE6/J7W/cDgHoH+HrqEFsQ1OIZSAfjEpc/3EaxXDlp4hyPlTgX9P3lepthWXr7e3jZzpuOeKRoY1fnnZAUCGi97NXu3vD+c6JfiiGh/WyAg6xeEYfjuMXzhaYU2vmSo9PoayMMFdJDkZAJa9x/JYiCI9kFG5fPV5q6EtszkjwCs4GHh2LDi4mpM/rTNNtPS0dOVR2A5w6KVn+ogMZmj8RDFBrG31YhBVKAoUoO7Jmva2tgAiqFV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/8/2026 5:52 AM, Ackerley Tng via B4 Relay wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Stub in global variable to enable in-place guest_memfd private<=>shared
> memory conversion, which will eventually be exposed to userspace via a
> module param, and wire up the __kvm_mem_is_private() static call to the
> guest_memfd version when in-place conversion is enabled, i.e. when gmem is
> the sole authority on private vs. shared memory.
> 
> Cc: Fuad Tabba <tabba@google.com>
> Cc: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

The names will finalized eventually and it won't impact the 
implementation. So,

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   include/linux/kvm_host.h |  6 ++++++
>   virt/kvm/guest_memfd.c   | 26 ++++++++++++++++++++++++++
>   virt/kvm/kvm_main.c      | 12 +++++++++++-
>   3 files changed, 43 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 65fbce46b63f4..9477ecebbbced 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2580,6 +2580,8 @@ static inline bool kvm_vm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>   #endif  /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
>   
>   #ifdef kvm_arch_has_private_mem
> +extern bool gmem_in_place_conversion;
> +
>   typedef bool (kvm_mem_is_private_t)(struct kvm *kvm, gfn_t gfn);
>   DECLARE_STATIC_CALL(__kvm_mem_is_private, kvm_mem_is_private_t);
>   
> @@ -2588,6 +2590,8 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>   	return static_call(__kvm_mem_is_private)(kvm, gfn);
>   }
>   #else
> +#define gmem_in_place_conversion false
> +
>   static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>   {
>   	return false;
> @@ -2595,6 +2599,8 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>   #endif /* kvm_arch_has_private_mem */
>   
>   #ifdef CONFIG_KVM_GUEST_MEMFD
> +bool kvm_gmem_is_private(struct kvm *kvm, gfn_t gfn);
> +
>   int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>   		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
>   		     int *max_order);
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 1f1ae61b4878b..75979c885e030 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -475,6 +475,32 @@ static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
>   	return 0;
>   }
>   
> +bool kvm_gmem_is_private(struct kvm *kvm, gfn_t gfn)
> +{
> +	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
> +	struct inode *inode;
> +
> +	if (!slot)
> +		return 0;
> +
> +	CLASS(gmem_get_file, file)(slot);
> +	if (!file)
> +		return 0;
> +
> +	inode = file_inode(file);
> +
> +	/*
> +	 * Rely on the maple tree's internal RCU lock to ensure a stable result.
> +	 * This result can become stale as soon as the lock is dropped, so the
> +	 * caller _must_ protect consumption of private vs. shared either by
> +	 * holding guest_memfd's invalidate lock for the entire duration, or by
> +	 * checking mmu_invalidate_retry_gfn() under mmu_lock to serialize
> +	 * against concurrent attribute updates.
> +	 */
> +	return kvm_gmem_is_private_mem(inode, kvm_gmem_get_index(slot, gfn));
> +}
> +EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_is_private);
> +
>   static struct file_operations kvm_gmem_fops = {
>   	.mmap		= kvm_gmem_mmap,
>   	.open		= generic_file_open,
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index a01d336eab18b..0a5a1bee8de0f 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -102,6 +102,10 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(halt_poll_ns_shrink);
>   static bool __ro_after_init allow_unsafe_mappings;
>   module_param(allow_unsafe_mappings, bool, 0444);
>   
> +#ifdef kvm_arch_has_private_mem
> +bool __ro_after_init gmem_in_place_conversion = false;
> +#endif
> +
>   /*
>    * Ordering of locks:
>    *
> @@ -2423,6 +2427,9 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
>   static u64 kvm_supported_vm_mem_attributes(struct kvm *kvm)
>   {
>   #ifdef kvm_arch_has_private_mem
> +	if (gmem_in_place_conversion)
> +		return 0;
> +
>   	if (!kvm || kvm_arch_has_private_mem(kvm))
>   		return KVM_MEMORY_ATTRIBUTE_PRIVATE;
>   #endif
> @@ -2634,8 +2641,11 @@ EXPORT_STATIC_CALL_GPL(__kvm_mem_is_private);
>   
>   static void kvm_init_memory_attributes(void)
>   {
> +	if (gmem_in_place_conversion)
> +		static_call_update(__kvm_mem_is_private, kvm_gmem_is_private);
>   #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
> -	static_call_update(__kvm_mem_is_private, kvm_vm_mem_is_private);
> +	else
> +		static_call_update(__kvm_mem_is_private, kvm_vm_mem_is_private);
>   #endif
>   }
>   #else
> 


