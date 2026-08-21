Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 822F1C5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 03:05:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9ADB76B009B; Thu, 20 Aug 2026 23:05:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9379B6B009D; Thu, 20 Aug 2026 23:05:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DAD26B009F; Thu, 20 Aug 2026 23:05:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4E9C66B009B
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 23:05:39 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CE1FD120332
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 03:05:38 +0000 (UTC)
X-FDA: 85123786356.18.7805C0A
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2ECA8100003
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 03:05:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=A7t4ICUk;
	spf=pass (imf05.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787281536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DIantMH/ZenzYj2xaWvN156L4f4pfdDt7+3JXrxO3wI=;
	b=NnM9wIovvnqtCWBeVg0r610TUsEhbHkPAvhfEAOWu+fOc+rOmQwhZiATKkhy5JsYLIS1yx
	/JB7/OvjYVNC+0AI2Bk8zASCMWPhlnVCj7AF9+nrAy3eNhZwK9Q94d/OnJZXw1RZWktUVU
	/ghWRcJo13jSVl+evTOcHyjgUzy3aNE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=A7t4ICUk;
	spf=pass (imf05.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787281536;
	b=oHTFXy3mNsAFcJOjqqd/UolX4IFgNuxi3XZku5abJeY1M9iC/h6hnbqZ/IhhwofZs2Y7U1
	OZ66dXoWW0afYc03vHM4ePzAP9pqJxs/7YjPS5euSzO+2fKF0AilwIuDvTLGYuhW22RaQo
	z4qBb+V9lKX0OZN+U5U0fR/CvEvAV2g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787281537; x=1818817537;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=dedcoEmUAKUk7YmPtA3wkGYwA/i32pF22h4YcKAscyg=;
  b=A7t4ICUkgdVDKhUfGIk8BP3EehFXW1YrzicX3G70hbPmELVPQI/EwXop
   K0/nSLQ0kmO/4sHnJjo7sXkqlSeFkj6rx01NqeLQj89zRtf79iwcJXWZd
   YtYePIEPPWoJYPuL1rq1DsbhYXB6Uzgf88M2zwLT21TtVOlnDFVRTvLIJ
   KPIbq9b0xuehkjLd3tX8bwluwRzDlnnMOzxJkpHPCI1PfezPxOIf97hJ2
   nFa2t3p5q+l7A0e9Jvv61FJmQhJmX5ygdIpTfXIOS6v2moyfqnkFDNHiu
   1vvOyq+7brJaJOHEuRMU4NaxidexaHZZ2JT6zH/enC3ZvlgUm7u+jwsR1
   Q==;
X-CSE-ConnectionGUID: JZuUDRVuS7a69qYKU1JF8A==
X-CSE-MsgGUID: 4doMg1dYQuS6KsUoUQHFhA==
X-IronPort-AV: E=McAfee;i="6800,10657,11881"; a="91700453"
X-IronPort-AV: E=Sophos;i="6.25,234,1779174000"; 
   d="scan'208";a="91700453"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2026 20:05:35 -0700
X-CSE-ConnectionGUID: 7MhXezB7RU+EV+DHFikReg==
X-CSE-MsgGUID: YTXbn5W/Q4OQ6BfbzvVtsQ==
X-ExtLoop1: 1
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.119]) ([10.124.240.119])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2026 20:05:17 -0700
Message-ID: <a410cca6-0776-44af-8353-9b7375e2fd4e@intel.com>
Date: Fri, 21 Aug 2026 11:05:15 +0800
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2ECA8100003
X-Stat-Signature: tgfitgra5bkb6ow96tbpidygkjzityba
X-Rspam-User: 
X-HE-Tag: 1787281535-945902
X-HE-Meta: U2FsdGVkX1/hyRseWQMq81aiMppHeJUhGghY1pGn5+vsGdRlL1Ky1x8JbkBWZUu0zhY7Wh8IyCVpw3h+GsNih32ygNr0yeGqGdiU1E+G2akwEXkaYEk7JQ0VxfjWIQqVg6L1wvdx4XDKzO6meIsAKbj48i3CNQMK7GtLuYVhcMX2nsGyGDOmiZvtyKZtdQ8ILltlILno0NF9CAKIBYaviqxO30czs7UegCngkxVy6n3PbsD1qQEuK4RcSbSQjxEJOMG6Ads5p/N3KK/u7ct6LsZiLfqtyVyfwuKalzuq7Q1k3b8nktB2cd2Dj+Ni8mVMgZaQnmxW4wfFkdWagbu5LdcEy0o7Zrn2Qx779EJZTo0cgUkeUSBZVfDQpjjuqVgqq0+szcCMPPknGwf4idAfe8EGLHclZoqDya51cMbKOW2FXjAxu8UUE4GMKG4rQfZSbsnC8V+AFJqGBuhzZFoYsvC/DUi4RzyIh2AsLo6+hI1SwVyh+W7Wo4iicpGRMmvr/P/ZaaGnl4gblD6m/O1UZcmccTKAt12/zC7I/PxqjgBXyehWUxFZgltL3RVlFD5U6kIfTiDDgZ8EK8X0UCFcqreE4cZ21y5EaAYDvgllXhoutx9AfZSVnPhkeaa6wXv2cLE7R+BWpMipKNKgG0iBBSzi4K7zrTMKFloUe6jHz0myjSUqxZIqJoDS0j+jiV4hIvYavp3LOv25aj4p6riF4dYl6qYJfhvmfAHSb5lvjAR0Q0wmAlmhx1Qr/21a9rHJbgjt5LOk/1iy9eEG6EcelbLYTLrl6OZOWfiiJlk+86C0qEw7Xm3CoaDwE7B7QmbGG/2JEBH77wex/oO5xzK8JRcYL7kc3C3l/ED3PViQz1myDb7IGiN+DicVZZtq2LiQc+rjgcuqxNREEpeRtt2D4ytTvAPMCJ6sy1IrKl8xrBK47iymnjqc6HWHg0TqkZQWzEzPYui7JVkbfFuY/P9
 LcYfBR2c
 5iGcmfgRn4NfIM+KfSQhqiptXtu+/kOo0ZZM+cS0gGcYv5vX0C4h8BzCofKQedYVNJEmbuRwCUIk34OXLgJBKUCV5ZbANLpqEO2230gngIJDv3HSNombJZvKaQCEUt0QFsXVOa2f1Nwh292GLuZLb1VgTKRa+jk1yGoA8LDkC/XSrg1S1noNVxTXUncMJeAw176d9xXBpGPp3vXOov4w5GbfrPTJa+io9WKIM6djYpcamaNjb/TO9fTvRUpKooHQpIKCjgoRAGFT8gSFMfLion/AZYCwemWAwz/fQycpzJEUscZI=
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

I find this patch changes the default memory type for a @gfn.

- When memory attribute is tracked per-VM, the default memory type is 
always shared.

- when gmem_in_place_conversion is true,
   - if the @gfn has no memslot, or the memslot where the @gfn locates
     doesn't have gmem bound, the default memory type is shared,
   - otherwise, the default memory type is determined by the
     GUEST_MEMFD_FLAG_INIT_SHARED flag.

I think we should document this change.

> Cc: Fuad Tabba <tabba@google.com>
> Cc: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
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


