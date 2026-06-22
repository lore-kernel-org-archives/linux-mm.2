Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27D00CDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 09:08:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF19A6B008C; Mon, 22 Jun 2026 05:08:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC8CA6B0092; Mon, 22 Jun 2026 05:08:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D07A36B0093; Mon, 22 Jun 2026 05:08:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A18A36B008C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 05:08:41 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 271C31403BE
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 09:08:41 +0000 (UTC)
X-FDA: 84906973242.22.951A7A0
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5ADFBC0009
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 09:08:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lmC6kglw;
	spf=pass (imf22.hostedemail.com: domain of binbin.wu@linux.intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782119318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mka01ewdlG1HTBeV0ghfI0ZGv+HpamNL80QIAB9UbZY=;
	b=XSxypZlyAxeVbFaW1yBxrM9D1kJlSje3HGYQBTndsmp4xNtiEJ/F4KSRhokg/zkvfrzdHZ
	YoeOrfky0infhA3ZgTbTVp8AJfJ8qX+qbE4jyfjVUXY+jXXIb8hnC2ecmGb2Hwv4TuoUwB
	iHZEW7ub9HegfJF6249v7RXiEFOh8so=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782119318;
	b=AdLeYEcALGP1zSuca/EI1Fx31JumC3pVCJ2BTQGFk2SpNgaPEMVYnDfO2ZyOKkcACVZLtS
	52lAEYnqTjj1zNulEPI+KhO+J5VDcS1okzBh0yKJ4l3vvYl2axMgOzpCFnW1pRYFuqLSSc
	liwm8Wirt8OzKTunEPx3QzoSl/eFnUA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lmC6kglw;
	spf=pass (imf22.hostedemail.com: domain of binbin.wu@linux.intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782119318; x=1813655318;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FXXp3XnnK+h7it17TWsBjNahQbzhpOBnqzH77Gg3oyY=;
  b=lmC6kglwX4TsU4z3XINIe74vfOsN0tgAz+3DqL4263Wppp5w4iwCVzOg
   vL/sxCtV7hHh7/WrXeKJJWakNQ1O0BaLHQ2b87qLVA7ZQYK7W0Kje73fV
   GF+6nmF4PBWaU29bSAWtXZzVOQobDOA7MV+D0dW6zokgOReDvIwnHyRHJ
   KMgH2JnS+lD8VQHtNjbJlnZaTaGMl3L8qkFd1agV2w+E/vSCrYW31yZHx
   sj0bxAYOfGh8MIATUYX0yuSr1c1OKUD3wPaSF6IHcQ7VPh3ZsMBvf7bLh
   9cLT8Ws+bsYwI65QDCvOotuEi7H82io+ib4o/ynTkVxNGRA0cbU60orJp
   g==;
X-CSE-ConnectionGUID: Ymg60GYATWKJjZElEwOJcA==
X-CSE-MsgGUID: IfhBqVm2QMmk0T3ckxUAZA==
X-IronPort-AV: E=McAfee;i="6800,10657,11824"; a="100396420"
X-IronPort-AV: E=Sophos;i="6.24,218,1774335600"; 
   d="scan'208";a="100396420"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 02:08:37 -0700
X-CSE-ConnectionGUID: 4ErWbjSDR3WHIlqXrzczlQ==
X-CSE-MsgGUID: sPY+aiHyTLWvSIqlDpESFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,218,1774335600"; 
   d="scan'208";a="248291517"
Received: from unknown (HELO [10.238.2.81]) ([10.238.2.81])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 02:08:24 -0700
Message-ID: <aceb07e1-77bc-49b6-a932-5fd9b5a21727@linux.intel.com>
Date: Mon, 22 Jun 2026 17:08:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 01/46] KVM: guest_memfd: Introduce per-gmem attributes,
 use to guard user mappings
To: ackerleytng@google.com
Cc: aik@amd.com, andrew.jones@linux.dev, brauner@kernel.org,
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
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-1-9d2959357853@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-1-9d2959357853@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9oypno5q464a6bni36udobbgg8w7aqjt
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5ADFBC0009
X-HE-Tag: 1782119318-907025
X-HE-Meta: U2FsdGVkX18asHVlrYJn7vSm+acJH/DZ8cVWwvVfo7KjQy0QDN7ctdSDekbvUlS7IcPCVYosQUznp2gXLU6BwpIJyYgj/gI3fYza9625mY7wbj2t6fujkF1YSoluOO47Qh2bfv4kJ8wArH7KWfjisjNIeurXehJT78PGjc0tj5+o7mmQPfwdDmk5YnJ2euL7HqqVGt3X3fYQ0667DaOJngEcyGuprSLku3zTLENH2u/VVo+QcXQ/rq8cOMrIQio4Rr9KUIqarErZs0aQ7ndTr8kOWZDW5Uen3t8/B7EDNle/FOi0cxxkC44Rm05AkjSWpQGWJWZGG17bkWaf2YbmrrV/Ibf9SB+eBSbcG0H+lXCeMfi94EhrUbKMGtTukg/Wspf6lgADUNmZ6787jNzcdYOmb5Fq3OIDKnGjSJbyPOtn4K2KylPosjZermBnMnXSWp4OIv2SpvHc6sbsLEWq0rKX6NCPfVUg6Kv2exRuveCte/+r8k0dIBQuMjG8DzYIO24j1kyEOmxjDe/+wSpYmDrxdgvcSDpjgLAzSXAKB2ZD1lM+034H+wAZPfEixiAB/FiRAZI10QTbEHmalCW2FzoGoVi/N/Lq478ZSn0tSXOMF4dQ8kSO4c4V+FiAEZKPElpt0oahxgeA5ozVKUXuyt3ACXLOqnhv2kwwHvbVkR8i6FBnEHoJG5pfVLc6lYZstL21VaI6fKo569WoikQqb15R5kKwhGpABRAMXXfQCM0tDCUwTsxhtX8B14y/3+NI7hJ7bso+Ef4rOOo5jyusPDGmSHDdIVrHSYxaFXu0X866jenvvM6RkU4ibVMyhuoKD3Fwzh0PdT/e1V3UjVu8QRaKRSQ2m7d/ikhpG6QVfil5r25VGCjQsU2DiTdLeOT2YSSdNbwQy97u96hX78ocR55KzFAjLfOqLb1EgHb0s7gVv2Jko84y2Qyk16Mkoa5zZfAYhsmodt2QldW6Fgg
 IyNtw+I3
 kRAnz1KvziuNXhydu05R2mKVV6ztmtFyNybJWwV4aly2cr0MGZw9GTZ9m1NUBXgVZ72gjLwRCa4pIREkqgj3QIQ5pLnaTENp6z3imzUmKFEMZCl+rDWY/9cSh9Ag9oxnnkeBaqlWIwfAL+IvAeMUkYb4FaIwwJZhnQ7nXG9PNIxKVoIp6WuyU0G531D/wmZB8Y6RQEGfNfv6pmjHEEhawiQWo3XoGEnd/xeqAnTUf+Snsq9yHi7c36Ct+bl8MkADd8kTT2g8qcpnUJ4orfydPRUdTohMb2/BE7EcW/BhlYJzbnI8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/19/2026 8:31 AM, Ackerley Tng via B4 Relay wrote:

[...]

>  
> +static u64 kvm_gmem_get_attributes(struct inode *inode, pgoff_t index)
> +{
> +	struct maple_tree *mt = &GMEM_I(inode)->attributes;
> +	void *entry = mtree_load(mt, index);
> +
> +	return WARN_ON_ONCE(!entry) ? 0 : xa_to_value(entry);

If the entry is unexpectedly missing, returning 0 means the attribute would be treated as shared.
And then in kvm_gmem_fault_user_mapping(), it would allow the userspace to fault in the folio.

Should gmem deny such edge case?

> +}
> +
> +static bool kvm_gmem_is_private_mem(struct inode *inode, pgoff_t index)
> +{
> +	return kvm_gmem_get_attributes(inode, index) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
> +}
> +
> +static bool kvm_gmem_is_shared_mem(struct inode *inode, pgoff_t index)
> +{
> +	return !kvm_gmem_is_private_mem(inode, index);
> +}
> +
>  static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
>  				    pgoff_t index, struct folio *folio)
>  {
> @@ -397,10 +423,13 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
>  	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
>  		return VM_FAULT_SIGBUS;
>  
> -	if (!(GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED))
> -		return VM_FAULT_SIGBUS;
> +	filemap_invalidate_lock_shared(inode->i_mapping);
> +	if (kvm_gmem_is_shared_mem(inode, vmf->pgoff))
> +		folio = kvm_gmem_get_folio(inode, vmf->pgoff);
> +	else
> +		folio = ERR_PTR(-EACCES);
> +	filemap_invalidate_unlock_shared(inode->i_mapping);
>  
> -	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
>  	if (IS_ERR(folio)) {
>  		if (PTR_ERR(folio) == -EAGAIN)
>  			return VM_FAULT_RETRY;
> @@ -557,6 +586,51 @@ bool __weak kvm_arch_supports_gmem_init_shared(struct kvm *kvm)
>  	return true;
>  }
>  

