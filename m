Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06183C5516D
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 08:26:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3FCC6B00BE; Fri, 31 Jul 2026 04:26:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF0FB6B00BF; Fri, 31 Jul 2026 04:26:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B9236B00C0; Fri, 31 Jul 2026 04:26:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 640036B00BE
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 04:26:54 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D26E51C0AAE
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 08:26:53 +0000 (UTC)
X-FDA: 85048391106.22.C314F77
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf31.hostedemail.com (Postfix) with ESMTP id 89A9020007
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 08:26:50 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Gdg2fqhM;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf31.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785486411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jQO6RJJpDBufvNLvtb3u/YM2NGYqsygvubbrUh7q/6E=;
	b=60vio7bWX4C4lKHduvVtBTmG8ukcqvrpXSzCn43r+kLm2siaK74qtTmvkbTB6uI0yedFrV
	MP9idcqzTu0DFPzpLjfAAW/dvf9kBv4pndxVrOvffR1NNyx1Zwhk1P3Nmn1DudvaBIK5hz
	4Tu37sc6JxkGVvxYBMASVha17ZlTqfE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Gdg2fqhM;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf31.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785486411;
	b=5gq/aKaBdA7/UPeo+8jy6LKbfPi7szREftZPfC2MVeLoLY63DRSXmT7M+HWL7rn3+Dh9gk
	gTCZR9LvNUJHCyrSgMzio0aBk5qWBZ/qj4ZcDZDlBThpbh1qOBI6l7SxWPp3g/IisO1XwY
	EwDOLgOxvBNbxsZWx1rSwiODGHObtvA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785486410; x=1817022410;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5dNmxu5/DKV/iLc1cxX1Ef3+PAoXGe1Aq8VEZB3JYrg=;
  b=Gdg2fqhMtLlqtXxM4xLVfTOddYFQDcvosHiDDMT+snUBaMVJZakq+b8B
   52LNo5Kqq6uifBNjDrncn6PLuw0hoApytt2qyE8G8QII0KQaLfwK5jMIY
   jnT+/T15UKMKMYrYT507FrMAw4PHjkxPT8y9QgobtOzKXxwwyFdScokv3
   JUF72F+rY6Wusmx7FzBSHydPK+5J3glfHIc3bAquIindtbjR8k+FTc+bp
   L2IlYn+Kw7vCX4YFnoxHH8C5S9jlrQmnVvHwT7JP2UkhVTFOtYhS6EJ8K
   zqXQMLwjUIMriC65363djFj34MfIUuWd5g2kCd7q+S2b5DbVVoCxCgD5h
   w==;
X-CSE-ConnectionGUID: 3cKqbzgGR/+ZxCbDwQlZJA==
X-CSE-MsgGUID: uIpEFN6uQoKqFPVg8HwgKQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11860"; a="86126083"
X-IronPort-AV: E=Sophos;i="6.25,196,1779174000"; 
   d="scan'208";a="86126083"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2026 01:26:49 -0700
X-CSE-ConnectionGUID: KbSyPLdZQD6xu1UMvfTcHw==
X-CSE-MsgGUID: g90yMGrGQQeZJeLvX6Oqmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,196,1779174000"; 
   d="scan'208";a="265591573"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.248]) ([10.124.240.248])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2026 01:26:34 -0700
Message-ID: <d3fef015-0546-4993-b354-a8464d79e48c@intel.com>
Date: Fri, 31 Jul 2026 16:26:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 18/41] KVM: TDX: Make source page optional for
 KVM_TDX_INIT_MEM_REGION
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
 Peter Xu <peterx@redhat.com>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
 <20260728-gmem-inplace-conversion-v9-18-35f9aec2aed2@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20260728-gmem-inplace-conversion-v9-18-35f9aec2aed2@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 89A9020007
X-Rspam-User: 
X-Stat-Signature: b8u4wuxedr3z6rkp98gzadftjr56ujgx
X-HE-Tag: 1785486410-29813
X-HE-Meta: U2FsdGVkX1+XVpQqK1nEoe1CzS7zWwog0KYu6Y+OiNvg1r9QkaGmhmvc2m+/+YTXN4xxUfXzB+0vIVKKN/4W0pCbaQ/2qlRDst/6NxjctYFHAl4VajN3vitXVZ9QcIvB1+sR3rOKCw551SZr/eQuWHsoCJsaYLgSyejxIFpYVrFJe1htb69+mm+0GFKenvQPPN7g8TsNZQQVUlS+shLDfckElfHePVzp33DuxALYvRvmlJhv5mnQ1fbvC4sFHgNzomIdb1LFlnrx9O6XKmE7gEJfWYBkqoYDYwvL+nCPE3W6GA0+xJu4yQ9373K0NP0uiKVPZ0DxRV5dbPb+3cPwL3P+E5IxDQiPgUHmkyJrZXKwJAbM7Yr9PrhO4SrmgeMW0ny+oG6CKNZAsT3Ssy/STEkI3IQZMCcevbgjneIWwo2cyXXP9ZD1gDSK/+zZbXBbveqck688ZX4BXGV+7ckc0vZ0hK4rUXGxjzA1oJjHRufVe6cJwre2TvRi/ELq0M8i+Rw11pC3/nFxMD1QMhMz8cfVrvnE2D2O7GhNdkMEqaTHzuIVnDDSO6AX34VuV4/YmJCfGbebVJaUxJNTYGM0XjZh/jhXFSCH44jDcmGfi2sbYjOB/EhS3G3n7yEANvP1UWKfZpg8g07CG47KB0swzGiHpNbtuaHLVUG7r2shGuO+9TpAI8LGYiOC4QjiY/VZgBED8Z938oXMJ6OrRcQE6tfnIYzU5w5/sqW0RQoF/kl+yrOO1Dt8WCN1hKjKuzkQhDianp9YnR/QG3AAtTgrNhOikZFNyOXAa5BLosiQ1Ywu+r9AYfJ2pIhSVU4W6jAPgr/aChTn+p+lw0dw3QXAdI6W5vyGPnVnU3TjQMj/iAPTnWxebLCyhY2tISmlv0tGM3h16mIPrpcGfx/WIWwJ1wygkCS8njzOZ/4O3nLhqwut0o3UaXAEK2q7P2Voz0dYXd2T5Ja+3HDXP0GWl6n
 OxIfLKAL
 mkdXcItXaOoTvzZcBm9WzNo17OaBImzr0vqnmascjXxzSPGdhLFmNxPocuhHZs1RNOBIu4uoxmRICsZibtjts0U4tDk3VlxDC/ERl6Ag5aU5oN5vc1BpLHNY8DPy0B84MWjy+LqaoSf5KLEwuElWB/x02n5cBQMIjhQNj1RN8FaiL7tBZ0X3VGA+Jbbm5F+GnS8Sb6i4CNnNPsx4ciF+jSJ88k4c3d35kNGVUJbCPhdVOO2vXpbk3yrTbUsmTfxzqVMJ/lWjbXiH3xFCl0O8adNur4FzpOPJVtmqsGltlXiSSKV7l2zv/mtn9u0vc+aK1u8nSR/lv1P0MNQZwYwW77ifcTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/2026 8:35 AM, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> Update tdx_gmem_post_populate() to handle cases where userspace requests
> "no source page". To handle "no source page", populate (perform
> TDH.MEM.PAGE.ADD) using memory in-place at the target PFN.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Tested-by: Shivank Garg <shivankg@amd.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>   Documentation/virt/kvm/x86/intel-tdx.rst | 4 ++++
>   arch/x86/kvm/vmx/tdx.c                   | 8 +++++---
>   2 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/x86/intel-tdx.rst b/Documentation/virt/kvm/x86/intel-tdx.rst
> index 6a222e9d09541..d8d9409120e61 100644
> --- a/Documentation/virt/kvm/x86/intel-tdx.rst
> +++ b/Documentation/virt/kvm/x86/intel-tdx.rst
> @@ -158,6 +158,10 @@ KVM_TDX_INIT_MEM_REGION
>   Initialize @nr_pages TDX guest private memory starting from @gpa with userspace
>   provided data from @source_addr. @source_addr must be PAGE_SIZE-aligned.
>   
> +If guest_memfd in-place conversion is enabled, pass 0 for @source_addr
> +to represent "no source page". A source page is required if in-place
> +conversion is not enabled or not supported.
> +
>   Note, before calling this sub command, memory attribute of the range
>   [gpa, gpa + nr_pages] needs to be private.  Userspace can use
>   KVM_SET_MEMORY_ATTRIBUTES to set the attribute.
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index d1af0a752e97e..e890da5f18aed 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -3192,7 +3192,7 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>   	if (KVM_BUG_ON(kvm_tdx->page_add_src, kvm))
>   		return -EIO;
>   
> -	kvm_tdx->page_add_src = src_page;
> +	kvm_tdx->page_add_src = src_page ?: pfn_to_page(pfn);
>   	ret = kvm_tdp_mmu_map_private_pfn(arg->vcpu, gfn, pfn);
>   	kvm_tdx->page_add_src = NULL;
>   
> @@ -3238,7 +3238,8 @@ static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *c
>   	if (copy_from_user(&region, u64_to_user_ptr(cmd->data), sizeof(region)))
>   		return -EFAULT;
>   
> -	if (!PAGE_ALIGNED(region.source_addr) || !region.source_addr ||
> +	if (!PAGE_ALIGNED(region.source_addr) ||
> +	    (!gmem_in_place_conversion && !region.source_addr) ||

Sorry, I still want to discuss why we only allow in-place PAGE.ADD for 
gmem_in_place_conversion only. Though Yan raised this opinion[1] in 
previous v8, I'm not quite following her argument. So let me try again.

I think in-place PAGE.ADD of TDX doesn't need to depend on 
gmem_in_place_conversion. There are two use cases actually.

1). Userspace sets the gmem page as private, and invokes the in-place 
PAGE.ADD by passing a 0 source_addr. Due to patch 16, the target PFN 
will be ADD'ed to TD as a all-0 page.

2). Userspace sets the gmem page as shared, and writes the desired 
content to it. Then converts the page to private, and invokes the 
in-place PAGE.ADD by passing a 0 source_addr. The target PFN will be 
ADD'ed to TD with desired content.

For gmem_in_place_conversion == false, only case 1) is possible.
For gmem_in_place_conversion == true, both case 1) and 2) are possible.

Basically, this patch is changing the behavior of 
KVM_TDX_INIT_MEM_REGION. Before, it returns -EINVAL when 
region.source_addr == 0. Now it wants to allow the "region.source_addr 
== 0" case. If we can allow it unconditionally, why bother adding the 
restriction to allow it only when gmem_in_place_conversion == true?


[1] https://lore.kernel.org/all/akI9m02jgKAdi4gX@yzhao56-desk.sh.intel.com/

>   	    !PAGE_ALIGNED(region.gpa) || !region.nr_pages ||
>   	    region.gpa + (region.nr_pages << PAGE_SHIFT) <= region.gpa ||
>   	    !vt_is_tdx_private_gpa(kvm, region.gpa) ||
> @@ -3269,7 +3270,8 @@ static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *c
>   			break;
>   		}
>   
> -		region.source_addr += PAGE_SIZE;
> +		if (region.source_addr)
> +			region.source_addr += PAGE_SIZE;
>   		region.gpa += PAGE_SIZE;
>   		region.nr_pages--;
>   
> 


