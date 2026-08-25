Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FF11C5DF94
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 08:26:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45AE56B0099; Tue, 25 Aug 2026 04:26:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E4FD6B009B; Tue, 25 Aug 2026 04:26:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D5456B009D; Tue, 25 Aug 2026 04:26:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 091D46B0099
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 04:26:51 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 437951C18A7
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:26:50 +0000 (UTC)
X-FDA: 85139110980.08.065177E
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf23.hostedemail.com (Postfix) with ESMTP id D81EB140005
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:26:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=N1fwoPfA;
	spf=pass (imf23.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787646408;
	b=PPNWTYUUZKlsQJWogSIXyzzaUJOPKBKjJmTlUS0DocytXNCJsn/xGuFsXppHORg2rT3qj2
	omvbIxoKy01gysAaifE0B1hT1LUrOpVgEEwkilR6oq6JgdrFq7/lKoinhkyGx/NPMyk66W
	o2PAH02HZF9K0h3Fgw6lkEuCXcVy1mE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=N1fwoPfA;
	spf=pass (imf23.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787646408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qW7Fn+CTXs5Aol1aKED5nijw4eSHorzVltOmv7enE1c=;
	b=ej2Lgaxeu5K4x2QRFLk0NzgEOYIsIgV6jGhJnj9L9kydHCnXfEAGOlug6rqc2L/kG+qp5I
	SykiW1I9++U362Bti8fnz0BkYo4FQnqDAGyQUhw9Cyn93IUkK24O71ytld5gutYJfl/wGk
	ZIKwnILJfieeO/oe68Xc2J2JGKeDqac=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787646408; x=1819182408;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=04fCXQwIzzVhpPEdhP0bQfk8MOV6YRVQ9CSm1/h1hi0=;
  b=N1fwoPfASJdQcHdBSnZLUs5AxeaM+7ZunqM5F8jYmdHAlaZvL1Ka/71G
   Sc3pbD1OEPBClPmOSkU95GYLRd+VfEOARNWT8r00wmmJpwKwJb020HYGN
   9PTUuxAsYC7MYngbRbNFjIX0QvD6asjij1t947k9S+B7SyI0gX3Mpe2DO
   MpRJI8+x+dyIYvTc9zX9t/hov1hfrak+r4KRI1lDyY/gXRGRP+vDiDUBP
   hIWSsgHTD+JsDdn/KgIBj1ean5leo1ijr8UFgKLXYgJuCt0wSiSvXaQhw
   O/SheWhG9l/pOY8f2v/r/cBB1BiCU2FYqHYT2+hOQ5djO2wxarU+7Q3LP
   w==;
X-CSE-ConnectionGUID: qDiE4s00TxqK2xVS8eDaqQ==
X-CSE-MsgGUID: UI16nuDVTfiu6cyUn4UyfQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11885"; a="99454856"
X-IronPort-AV: E=Sophos;i="6.25,242,1779174000"; 
   d="scan'208";a="99454856"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2026 01:26:47 -0700
X-CSE-ConnectionGUID: h55LQIi+QsOn6JDnmuR4DQ==
X-CSE-MsgGUID: qni+GOQ/RrGZlEN/DsYqxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,242,1779174000"; 
   d="scan'208";a="270695755"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.119]) ([10.124.240.119])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2026 01:26:33 -0700
Message-ID: <45d51e32-a8da-4ca0-bba9-94b2086c57dd@intel.com>
Date: Tue, 25 Aug 2026 16:26:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 18/41] KVM: TDX: Make source page optional for
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
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com,
 Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-18-2fc18ee6d3ba@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20260807-gmem-inplace-conversion-v10-18-2fc18ee6d3ba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D81EB140005
X-Stat-Signature: 7zkc6totexrnuurw7obfhcrjhnatdjf8
X-HE-Tag: 1787646407-78439
X-HE-Meta: U2FsdGVkX1+4czVTLgbI7pyqFhirrsYL9H1hhJx3SR2PxeFmMLZG1P0uvWeIGDZL0S6Ms+29eDzEi6XvoYNrqB7wBZKpi8d/gEb7bUVOom5+ZPxjG19b6v4Fp2R8zxSoYaQrDA4TOHDSME/cBvbT17XdxD+Ylwg4Lff0hydHo9OyCPxKHUTTqjKzUYoUW1v4MFBfsnNDJk6LZZdpau4QeGkxM83jSq7UcpvZYRKiwwypaBN1V4ncVZSgRFJJwLxxPkpRsPggcHnBJ0tf9NDCEWy+zTyuG/Wf4hR+00bgXLGa4yEneGLA+rzYwY//0WySIbsTAqeguPLkN6TchaOIvA7l0fY1RHEkNOKvq6fKfaAFoJugBXMNWjN52PI/f0qho6KDh/1U9l7lRs/UMOW70EApL7mQAvUCRzIWUQ1CNRXiTKB/v5GlkF0jQbHIzLPNvMHWzDaE3pBUxtREVIv3OcFpDNSuM5KXm2wP5NdBQZbFYKKjDcunWY/R+rfkf2yYFO1C/LlKaxav38Ph9UTiie74ZI7ibOo3oo8JiU1vGHPkBbOcIH6PdS9WDomAKGkwjBmWLW+WRD7ErW/6cy99J8kH8J97Kjn+6jobn9Iqa7Aqcp73MR8TJOu0kcSjeLyXaiQh0p+ROTnGQ796mprBXtu9UTRutqreHoYOJsUHydI+Ee4REoiNXVf9i8bbA3bORkJOO1IzTR+aJMbNMmIzN8k7vp/rSyXJBm+Ep/FQBnHNZDBCfdnr4bGFuYk15x8nhw4TJ6yRXsP3tbbJSIQUqHHmaqghdayUPJswNNolHrhv58PzrFgso06uvoQYqz2dTiVmM7hJlLwJrZnPwdc4WU88cRF6cRvD6QT5APEB2BoWnlXghMvkFvMrh7+yo1SfjuuetmMal2R1F/e7AsjsXqWSstBuTRn2gqYJrlP2EXxNK7j1NIJg9m7zkBpuGzxLk69h3Xd549Ai+9Eumxm
 m9mqKTQi
 y3qc7bsn0PqlT0KtYBl1xq4J+owzt8vaYZ0yK7BWNtcus8xd+2q3MD2EwAFFXMkv5n/mlVXOX64Vq6HnrCVvhJZDPEQJMl/LzVwfXWnI+T+jePJkoyGlrrSgTcM8HayedpcOOUHki+3FlCI+Qm4WTlW2Uxjt72w0v7khCZMZFVTFh4sLg/XDMOJ5jRRTPfqY/B5QaqxUL7MUwFgZwfV/Dp1bBoO5PEIoU9MBNIayJ++yE1x8cFItPk4GFU5Ph19eQS9IYcpTFZ3KwDWI7koMZf1bV/GDEEZAofZ4Q2Y4SMCxRq4z1w+PrU/yUmaRyb7RNCiKu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/8/2026 5:52 AM, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> Update tdx_gmem_post_populate() to handle cases where userspace requests
> "no source page". To handle "no source page", populate (perform
> TDH.MEM.PAGE.ADD) using memory in-place at the target PFN.
> 
> Allow "no source page" only when gmem_in_place_conversion is enabled,
> because retroactively adding support for out-of-place conversion would mean
> requiring a userspace update for a feature that's being deprecated.
> 
> Also, KVM supporting "no source page" without in-place conversion would
> effectively be an obscure zero-page optimization that relies on the page
> being zeroed when it is allocated by guest_memfd.
> 
> Rejecting "no source page" without in-place conversion scenario is valuable
> for KVM developers since it helps newcomers understand what exactly is and
> isn't possible.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Tested-by: Shivank Garg <shivankg@amd.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

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
> index b272c20586a74..7654a9f5fa128 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -3189,7 +3189,7 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>   	if (KVM_BUG_ON(kvm_tdx->page_add_src, kvm))
>   		return -EIO;
>   
> -	kvm_tdx->page_add_src = src_page;
> +	kvm_tdx->page_add_src = src_page ?: pfn_to_page(pfn);
>   	ret = kvm_tdp_mmu_map_private_pfn(arg->vcpu, gfn, pfn);
>   	kvm_tdx->page_add_src = NULL;
>   
> @@ -3235,7 +3235,8 @@ static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *c
>   	if (copy_from_user(&region, u64_to_user_ptr(cmd->data), sizeof(region)))
>   		return -EFAULT;
>   
> -	if (!PAGE_ALIGNED(region.source_addr) || !region.source_addr ||
> +	if (!PAGE_ALIGNED(region.source_addr) ||
> +	    (!gmem_in_place_conversion && !region.source_addr) ||
>   	    !PAGE_ALIGNED(region.gpa) || !region.nr_pages ||
>   	    region.gpa + (region.nr_pages << PAGE_SHIFT) <= region.gpa ||
>   	    !vt_is_tdx_private_gpa(kvm, region.gpa) ||
> @@ -3266,7 +3267,8 @@ static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *c
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


