Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D325FC43327
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 10:48:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C60616B00A8; Tue, 30 Jun 2026 06:48:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEA7B6B00AC; Tue, 30 Jun 2026 06:48:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB4426B00B0; Tue, 30 Jun 2026 06:48:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 826AB6B00A8
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:48:11 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 138E9167ED9
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:48:11 +0000 (UTC)
X-FDA: 84936254382.03.63CABA7
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf07.hostedemail.com (Postfix) with ESMTP id E77F14000B
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:48:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JN2GhHEm;
	spf=pass (imf07.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782816489;
	b=B2Vr36/636/3jv5mc+R4q29Co3bdm1dV1bsg6QFyXqzvmnbMc9a78a9nZcvApBaXURr4TN
	nWNDk+IIZZyn9sk6jgeFm0wQOkeC2xCJr0rcJH5tG010xyn6yYY2n/0zlIcvcYPksr72gy
	1GDeXqjX9aRohWKI8PAqh4SnwQbTP6Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782816489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vED+ZBppgNYserg4LvAxPsdVw7uElrkW4Oy1cIvNu58=;
	b=cEFiXJlF6P6jLxdWHfGTa1JDB+wRKfPr1oCab7adTNSxVLmQY0Mj7UL4sy6CTZZyWTZRjn
	yvCznt9t0x0cu9J3hSCFEeNcA/pqq/jCE4GYx69+26GWbQ2SpNQn0lJwJdBkeRWwJO3KP+
	2vw+DfxWNMlUwl1KlLZ/iFf0Bn/buXE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JN2GhHEm;
	spf=pass (imf07.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782816488; x=1814352488;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3lVVfc+fn9929mpQsDK3Jls66W7HEXpS9akiNi6RlX8=;
  b=JN2GhHEm3Iq1QexMExqJSA2gl2eiUfleTFPEjiMbVm+lLNYC08wnAgLF
   Hz9xbCvh+6SbTfpLh7jcvNvQKodvCw8YmaB2AaaycqIWteII3Cl8RqtRY
   ioDv3FgFoDVVlOodlz0h1kzutap+0hkPfMsiaa4kf++NEiaM5K6T0oX9h
   Sq0MeBt5PBBH3JGRfshCythYMypkhq3Crm7WNlzTtUWY4uf9AsNL+YEYK
   ZbCijUWTUon43oHqlywVOhdIY7vwNXskyjjeXdCiTjc5/v/N0+Zdsxosx
   LuWaqOiXtXshEghRjDsqf8qyZmk2VECMCc9+P0F8vxADw5MRzDeENcQg1
   w==;
X-CSE-ConnectionGUID: tmiWOgI2TxmtrJ+B5gAwaw==
X-CSE-MsgGUID: tB70zjUnSSKnjtFntNvwOQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11832"; a="106318221"
X-IronPort-AV: E=Sophos;i="6.24,233,1774335600"; 
   d="scan'208";a="106318221"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 03:48:07 -0700
X-CSE-ConnectionGUID: JBu/+lqkTGietoQsv+PEyg==
X-CSE-MsgGUID: bIygpzouSBKb3G2R28LYWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,233,1774335600"; 
   d="scan'208";a="257141581"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.239.158.70]) ([10.239.158.70])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 03:47:54 -0700
Message-ID: <6b1f0c77-f059-4f8d-8f46-443b944c59a0@intel.com>
Date: Tue, 30 Jun 2026 18:47:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 04/46] KVM: Decouple kvm_has_arch_private_mem from
 CONFIG_KVM_VM_MEMORY_ATTRIBUTES
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
 <20260618-gmem-inplace-conversion-v8-4-9d2959357853@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-4-9d2959357853@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1dothpa8wpe8ey6ce6bgugarx748afgy
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E77F14000B
X-HE-Tag: 1782816487-490779
X-HE-Meta: U2FsdGVkX19YHlcvTui6uMidLpoL0OS2WLT2m1xPcIdN0a6O53J6gF7PISsOgBMF8P1f08AqPik8Qn6EBFV7Syh2yo52rqgRPQXz5ymYihu1iVKF5xgc9puD+CyFKjK+hJ6T/CqnxbEwMnkxYxQg6bOJEF7HpraTxWwlfD5I0G96yhdzOPVLwqv83P69mgVT29kTggVPYQB8DLzPtwiDbcS9IwCh5FiOWPgeD5JN/vOEvIiVLryLDmQymr4Fvcxyul7CDUyauE9CHty9Kf85KxJwMsh4L/RS674uGrkeA96tZ4hp5bubsAbeX3vHxlpzZDfdmO2vEOxoYlpVjOYXNjumf430ZKvL6Slg2ly3NNhvNNJ1cVasoCjTraIDtRaGXJwyOvcqZeC3lZ1tTivQ+/9VebMy4BvaDPb6ePlKOpAoq4SgmVBs2H4FX47XJJSF4h+29t5C17BLZQ8a3TsfR5KYYgBwvWN+Hovyszj1uCoDoPqK+0to/TlUPOYdOnwdaPUQwPgeGADZEPlN50Vo1C+W7+M8MOEg7mZu84SFU5ar0fV44C4nOBQsAibt+ihGI4dqXvlq5cGYC9H1fSSrb8rsv5w5mnm1oVcPli41ny1gw4f90HXUT8ck9X1WOZnMcbXg2lSXEsme9u3iV5jDCZvrqicS6nw72jT9W7tLAKTKnm+uMlHZ4fNGGl2IY62yDvzs7VyCohH0N3WPUcT0dTssutsbI6cy5Bi37dup2AjMQ/aHzdi+6Djj91TRGbgReDAxQ4oJ6m+4Mgl23ZVB9I0pZAD/pnKJ1qBJsaSckXppancsjtkbbqEvzrZqy37oA6VGfgAttoqgSrqTYnblvKfUOsoPu/agCq2UpsH05XkALKgOmo/nPvh0EqV7ujHUVmPjeCelvMET0V9B9UpZXyXIHmneG3yAvPAu9d/UGhgkW1lo+VyCBL1VjPKa5k1+RXtXtAuY8zRP3gPR8bS
 +cXr7UbI
 /QZ7pOS9QquYvVjcWytcujBYpzNNM1sX2xO5g54JaWgjxd4O6cy2tDt9BjvRk5yYslDMoJG79KN5e22hQQ3mfFpjscMvztKVxd5vrS87UC6RSSwt9cEvw2nVS/yzPenUnfF/120mqs/7HqwN5ZDWD9tE12Io9NFFn+YGgZ0o/5MjE59bBJmiqHvL9yINxInkiz4RGHt1kuYk1UnIvjkTo+iejC8+6Lkdcgvfg1nLKuerZ6iisJz/fGVIHGEJ1y0OTIb2I1qXMjxsCA+XNsFEpeExT60yX4Dqe79mymwpaZk6o6jg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/19/2026 8:31 AM, Ackerley Tng via B4 Relay wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> When memory attributes become trackable in guest_memfd, the concept of
> having private memory is no longer dependent on
> CONFIG_KVM_VM_MEMORY_ATTRIBUTES.
> 
> With this, on x86, kvm_arch_has_private_mem() is defined if some CoCo
> platform support (or the testing CONFIG_KVM_SW_PROTECTED_VM) is compiled
> in.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/include/asm/kvm_host.h | 4 +++-
>   include/linux/kvm_host.h        | 2 +-
>   2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 8e8eb8a5e8a6b..1bde67cf6eb0e 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2394,7 +2394,9 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
>   		       int tdp_max_root_level, int tdp_huge_page_level);
>   
>   
> -#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
> +#if defined(CONFIG_KVM_SW_PROTECTED_VM) ||	\
> +	defined(CONFIG_KVM_INTEL_TDX) ||	\
> +	defined(CONFIG_KVM_AMD_SEV)

Maybe we can just remove the #ifdef and make it always avaiable?

>   #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
>   #endif
>   
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 201d0f2143976..d370e834d619e 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -722,7 +722,7 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
>   }
>   #endif
>   
> -#ifndef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
> +#ifndef kvm_arch_has_private_mem
>   static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
>   {
>   	return false;
> 


