Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8D8BC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 07:22:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64B926B00A8; Wed,  1 Jul 2026 03:22:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FCB66B00A9; Wed,  1 Jul 2026 03:22:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 512FC6B00AB; Wed,  1 Jul 2026 03:22:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 276B66B00A8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 03:22:51 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 93508C17D9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:22:50 +0000 (UTC)
X-FDA: 84939365700.12.A360B85
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf06.hostedemail.com (Postfix) with ESMTP id 892C5180002
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:22:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XQmGOI1f;
	spf=pass (imf06.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782890568;
	b=lrT+L7aur/PbV4mmEJ6BV6vM7cO+w7kJSghWEI8T6IM+LCpusufWRT+R1B5N5hcolUodR5
	nNpkv/SA6pcGI/nOoFEqR2GcnHFqm7bimSzKTSMfQLa7ZcVgBDCWpAb+rwb0Ph+J4WjOVm
	cRzZFysjHO14/5TJGZtog3PBhlbFsws=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782890568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3diLSjTizWT0vHiPO+k2q65MDFC8rMZGq2/bNmfMlQk=;
	b=0bIMQ8U+Q07Rnk0JUPY2WjJ/hSQ8fNy/9liW0picFxv2l40Q4LRtsFB0WsLSZsYYOgmk+T
	IMAqF8IOzn76FCcbRdycGx/GluF/ymSkJFCx2wZyYjuW688CGr+Xb7bYTqYgygty3CaBip
	AvF5Aw+jD1kt5a6ktPqnIJgN0U2kR2U=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XQmGOI1f;
	spf=pass (imf06.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782890567; x=1814426567;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=O95arKx9T5MkaZlIQszzS6sq+z6RycCRVDU6C6dp8F8=;
  b=XQmGOI1fJisTrg7QqbBAO/xiwGnKkd1huBRxe1AKF615REyyy1lZYgn5
   9ECRIcrn/+vXKoNax2f5TBSz6GllKCbXP9mRd6LqUs0hkz5WFNCYypylo
   fP3gtFtBa1ZbF0hUOp2KKLcy+jyI6q0OK/Yr3jH6UhlGtEBS6hpag5mQT
   b0utK7oDUy1cRC9KOgfIoRml+t6ontylDeqstUWXIpkO1MOsMQnqaMMze
   7qdLsZZ/1Dlphn1YWZkKj+QlH3ndCd+aee45inRzj8WSXKTqph49CiaUA
   ujun+HAEp57zcZrTIoKyYNX508ngEWRqUasF8aRN37SNoeWOsGpeH4JZO
   g==;
X-CSE-ConnectionGUID: xFJcj0PLSQW1um9bmNwBzw==
X-CSE-MsgGUID: H2LOfzmyTjufxMMY7NWtVg==
X-IronPort-AV: E=McAfee;i="6800,10657,11833"; a="94212707"
X-IronPort-AV: E=Sophos;i="6.24,235,1774335600"; 
   d="scan'208";a="94212707"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 00:22:46 -0700
X-CSE-ConnectionGUID: OCgLTDNcQc+i2MkkRhnhSQ==
X-CSE-MsgGUID: ze+nbZzkTA6u9tCtlTgwPQ==
X-ExtLoop1: 1
Received: from unknown (HELO [10.239.158.49]) ([10.239.158.49])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 00:22:29 -0700
Message-ID: <8494b247-64b5-4a04-b964-1f778c17acc3@intel.com>
Date: Wed, 1 Jul 2026 15:22:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 08/46] KVM: Provide generic interface for checking
 memory private/shared status
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
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-8-9d2959357853@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-8-9d2959357853@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 892C5180002
X-Stat-Signature: d17tj8y44pz5edad8j3qtg5ktz8bp7sg
X-HE-Tag: 1782890567-446326
X-HE-Meta: U2FsdGVkX1+oX/UZKGF/BFx89+7iGaF2jKpogq9cvQvGcgx67xdqlSvWCBoSihJzTVmFJyQV2oSap9ZC+jV3VsdlDA7SR4YLgtWXiDm1aHeunEfhDeKuVucxoPt8/28K/kUMe9YMYytNFrwmyDzKhiNmlk7hsxzKecZtywndGYXqXLM/Tolw9SsZxmpXcBSdkw3/bYuh6CASFhGbypDevfKBOsx8UoDo0QjRmIL4KAlNj9pQhvMUOe3j2cbewq3B/cgNev8svhUUZ1g7pEp1Qhhi3C7QwI01wnZLZnYYpvLXBF+5ZLftt7RSzhnQ/KZsBbF1UBIQxDyFI6IuSFvh8wj3CBaK39l17IOld6nral/tmPAwPZKOAK/8SfCagvUS8YBhmt7S5AZZKUmMAqHk1LgBdTyReU+fDFJpafr3uTf7QHvfHe3Wr5CP6lsg5ORSXKavHVJlkAMWF0SzGAg563bNlD1bOUnTbV/dtx89/JBXxFcqqYuxWKMTvmFTo1ijmRtcuL+tL8G6Kl7ZIRri7lsXcPKZwNjje3ggMr+sj451399Rmu4TaMqbQcstD0ErTns6lcLBVJWe/ffZSiV/+agb7W+jwGFfOGCte88UctfyWIKbqH7UItNuKHBswJ2O2IsZSC+UGt+dTMcHaTsExxAZokNr+PZqgx9Xcznq2HHbsaqsfNH+jgL8TpkXeRqcgn/bt3kY+d//zPYUNBeGZ/shTnDGkUd8kYN3S3jEIKXGRBwJ/fM33/pzBjZapMnb5B9PqnvWS4sWvuUhgq2giTmWMNmimC+nxbY4Th2xV959d7fI4rISHTVFcfVxF4OZCgYfSkE9p7QFYyN1xIaurQLlY/sLlu9DwPN70WHza7S3COGHshkYd74RzC9KgEgf2xFcf6Af2rAnjQ5fSNeOuV4Fv7t+CaCXPLvfpDz18lkiTBRcX41/W214m50OjJ67Ic0V8YhjCCJRU90EHys
 xmQoztQ0
 yjWrE120ICXj8QtW4H0ivuFwZwdIEx/a3UpHgXiHKNU6eRbDt7jF/tCkFCbLF6kMkh8MruZ0aAmoRCrLETUxRTpPakxJa6VZnvaPFJHlWZ8l0t+7ZnMai/5RTDt4fp2DxnN3RDiZWwciwkUYBx+tPVDGv0NYX1+pjRgAj7gkU8vVBbwVsOfTEf/Mf3Aoszqo3b29nJekKcOXv3wYdzXa52DuaYAqLf1/ljI7Z4iJC70q9x8qxZDcJTOtoV0gDGCBGFPKKOszlu0sKaV5730tbrYfWASK4gCS9HcJ9stu+qB76otU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/19/2026 8:31 AM, Ackerley Tng via B4 Relay wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Introduce a generic kvm_mem_is_private() interface using a static call to
> determine if a GFN is private. This allows the implementation for checking
> a GFN's private/shared status to be set at runtime.
> 
> In preparation for choosing implementations between a guest_memfd lookup
> and the existing VM attribute lookup, rename the existing
> VM-attribute-based check to kvm_vm_mem_is_private to emphasize that it
> looks up VM attributes.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

One nit below.

> ---
>   include/linux/kvm_host.h | 12 +++++++++++-
>   virt/kvm/kvm_main.c      | 15 +++++++++++++++
>   2 files changed, 26 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index eb26d4ea8945a..3915da2a61778 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2546,7 +2546,7 @@ bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
>   bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
>   					 struct kvm_gfn_range *range);
>   
> -static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> +static inline bool kvm_vm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>   {
>   	return kvm_get_vm_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
>   }
> @@ -2557,6 +2557,16 @@ static inline bool kvm_mem_range_is_private(struct kvm *kvm, gfn_t start,
>   						  KVM_MEMORY_ATTRIBUTE_PRIVATE,
>   						  KVM_MEMORY_ATTRIBUTE_PRIVATE);
>   }
> +#endif  /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */

Since it stops the original #define scope of 
CONFIG_KVM_VM_MEMORY_ATTRIBUTES here, ...

> +#ifdef kvm_arch_has_private_mem
> +typedef bool (kvm_mem_is_private_t)(struct kvm *kvm, gfn_t gfn);
> +DECLARE_STATIC_CALL(__kvm_mem_is_private, kvm_mem_is_private_t);
> +
> +static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> +{
> +	return static_call(__kvm_mem_is_private)(kvm, gfn);
> +}
>   #else
>   static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>   {

... we need to update the comment of #endif to match with the new scope 
kvm_arch_has_private_mem as below. Or just delete the comment.

--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2572,7 +2572,7 @@ static inline bool kvm_mem_is_private(struct kvm 
*kvm, gfn_t gfn)
  {
         return false;
  }
-#endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
+#endif /* kvm_arch_has_private_mem */

  #ifdef CONFIG_KVM_GUEST_MEMFD
  int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,

