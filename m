Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCEFAC5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 08:23:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B97486B008A; Wed, 12 Aug 2026 04:23:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6E6F6B00A7; Wed, 12 Aug 2026 04:23:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A846F6B00AA; Wed, 12 Aug 2026 04:23:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 816446B008A
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 04:23:57 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1935E1C0F86
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:23:57 +0000 (UTC)
X-FDA: 85091929314.10.DB9FA76
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6D17D40003
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:23:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iwAyO77L;
	spf=pass (imf01.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786523035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=easo59BvRc7iRCEXdv80R8cz4I/aUXsXPjP+R9mZTyo=;
	b=NVdjOaqZcgcQ/DVMEctj4NaeIeNvB0VZ9+clqzPxIfQ9L3IyeoGbITxtbbwC+FQ+XxRAa8
	R/E9M098KKAqXdxYnjEYXDO00FjI079s4bVa6eiuq+EV0Wp88DI+p/E38vpFq/0vafGdsJ
	oQtz+wp7D5gJ4xleJnDJ8UZAcWklO9s=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iwAyO77L;
	spf=pass (imf01.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786523035;
	b=LAFi8q4usfqN1VivTsvysyDe9O1xfiTxHR0KKeF4HzQI3U3YJG0OpB2/QJZ8fzPDuOE+VT
	/xV8cvmPgYyaaL/K90M3ljAdrBqF5FQCi7DqzuP4eFLu8bxDFshoVc8hspck9K1K++nqVh
	7fDuUFlANnsD/PR1GyjbdGX8tj9I/GY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786523034; x=1818059034;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=W+jcq+2Wzamwh76nz0OcGlGI0ou5c5gwJ2B1PP/p9zc=;
  b=iwAyO77Lo6lBb6+g4b2tI7LUg2VT6cotOs2bWrp4VmWDIAASSOMBrT5U
   qIIRuv+/SQNvzUU4ihHx+QN4SjUC/jm9ZCNtdtCB2tA5/yFTdJVeiGZyh
   xC48v+DpXl2gAZ3fEM0goc2rFtVeSyyY9rV0zci2ydjsglRLjtdaTnSNj
   HLK7z3qVSICsRWxGL25m5oZN0eZ2LWj2ifw3CIeV2IfwiXX6zwPYIVcqS
   ussQYa9GvThMdSsKLsPJNvthSMhyDMan40zsS1b4ijc6EEerosC0hNyoQ
   42bMXuxtOzhcmIH6ZWnKlE4KRMoM/s66C9oL+c9QD7TX8P95O4do4R5Zq
   w==;
X-CSE-ConnectionGUID: V9FbWqnrQhe+Vd0IMndLUw==
X-CSE-MsgGUID: QVrrXq3tQQ2qC05nq1MOsA==
X-IronPort-AV: E=McAfee;i="6800,10657,11872"; a="97414830"
X-IronPort-AV: E=Sophos;i="6.25,219,1779174000"; 
   d="scan'208";a="97414830"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2026 01:23:53 -0700
X-CSE-ConnectionGUID: BVDpwXjLQ5mrX6YTBE6jjA==
X-CSE-MsgGUID: wd0espIgTjCF/EZNhS5SlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,219,1779174000"; 
   d="scan'208";a="257380624"
Received: from unknown (HELO [10.238.208.98]) ([10.238.208.98])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2026 01:23:34 -0700
Message-ID: <2f68b143-f3e1-48b7-8666-52072249e0be@intel.com>
Date: Wed, 12 Aug 2026 16:23:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 04/41] KVM: Enumerate support for PRIVATE memory iff
 kvm_arch_has_private_mem is defined
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
 <20260807-gmem-inplace-conversion-v10-4-2fc18ee6d3ba@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20260807-gmem-inplace-conversion-v10-4-2fc18ee6d3ba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6D17D40003
X-Stat-Signature: q7ghctomtas7oxea5ywskmpc8escykk8
X-Rspam-User: 
X-HE-Tag: 1786523034-390228
X-HE-Meta: U2FsdGVkX18w8LoG5G7Vreeq/8siGKFe725UM9+xJiFL9AurxBUhIAp3QN5GaeeKG+6WFp6selAiqHUaM/q8C0+w53kt7vfHK6iEtlEYypl3MmuIH3jHZSUyWCrz4ujHu7Ye/0Gkj//Vl9qMsKWFoeETAEZzHkzwfkItkRYwl5yO3ZQlvfcVYXxrD+aTs6HJYCe2NgN4OgI96NHepy9Rftebq8p7ZQYqCMpz466yV4U+UySiqBhwG60Mpb/fBQkFWU628eiVQdaky1h15LJR1152nsIEKvYTW0oBAFzeDtPI+rnAktKjkcStBJPj4qDaBT5Y/Gyrbpp8Q99EL8QvH3pZQ2LrilxBvgy3iwRU5fpTrfKrbHgzzncoXhywrI2DyNzazoErfl0IFAbvo/vftJpTCNq0i26kKTLF+2I2ocV7GhZFwH+cxdskMlK4W4PE4XjLm5f2/M34XxAEu5Jr/SThYLjFGW6yugV10OgvADRdox1R3iYm9+mXzk9nZaQtioG/plWsJ52k8GVQMpbXPhSXDTvhpFns2LRHakCbegKCvsPoEgUqWNaNdVi1ytmSybh+x1GD8E1BCjpk8/1lfVttUtoRIfJBSwyZk5gAi+HSB2VGd4W2w2f6fLAhhElMmlEVGxYdLr9b5omxxzhy3L9tToMxntEVaCBaZ6ob1g0xqmqtCm+0t8TQiV56cprDAr919c+UKFy3Sx9t7z5e6Cynk4wSiaSJ5FKXhMdIz561lCaw9DZmK+buxtH2lSrcjsg5JafkZxC1z271TEBv/RjTna70j/+4mZSQatnkyDUV2MQgJf4NecDb5FKn6oJwSmqoQlMyIOCR1AxRXqBUUz6i1bdMFL24K53YmoBgFOmsLI2+qTSS1hD7K9qbCVz10cW6hUb+hdUtuLsaelmMJkw2mW3kpJoZc0+KcGSGGTcIZdqQ87755pJ+frCsSeQnO4/MI8yU90Y5SFVqCEs
 WsrkifA0
 H9q4jvOcq0WSZcBAEGaykmtx/kF/Q4SYFeFK77x6K1b5aM4sYjZDQbNzTVP5yfubMnsXtNrSt0V8lRraaFZ5CqLxsPARAwaghT9my2DfSZhrmr4yhugOMm0diVNL6NbElI/hgWBlUowqe8rizpTMDMx5Thtucy9P4kzMy458CwOfugIKcDWDymEZ25h2F81jfQZYv8/YqJIQBtVbL9ap8wyympQ/ml2kHM/cjGdzkYMGOVPE8fJq1TnSTU3uxfSfpa0TYiYFtrCabX+lMm71csy0WRoConqj2Xs7W78/bLnoxwPPY7ixYEAz2ZqxFwnmSRVbxE+g+AxXkE5OcmrZmNNDTUWx5+ZdatKvobBfMm5KgZmg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/8/2026 5:52 AM, Ackerley Tng via B4 Relay wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Explicitly guard reporting support for KVM_MEMORY_ATTRIBUTE_PRIVATE based
> on kvm_arch_has_private_mem being #defined in anticipation of tracking
> PRIVATE vs. SHARED state per-guest_memfd, not per-VM (to allow in-place
> conversion).
> 
> guest_memfd support for memory attributes is expected to be unconditional
> to avoid yet more macros (all architectures that support guest_memfd are
> expected to use per-gmem attributes at some point), at which point
> enumerating support KVM_MEMORY_ATTRIBUTE_PRIVATE based solely on memory
> attributes being supported by KVM at-large would result in a system-scope
> check (NULL @kvm) over-reporting support on arm64.
> 
> Give architectures full control over overriding the default definition of
> kvm_arch_has_private_mem() by removing the coupling with
> CONFIG_KVM_VM_MEMORY_ATTRIBUTES.
> 
> In a later patch, kvm_arch_has_private_mem() will be defined based on
> whether architectural features are compiled in, and made orthogonal to
> CONFIG_KVM_VM_MEMORY_ATTRIBUTES.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> Tested-by: Shivank Garg <shivankg@amd.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   include/linux/kvm_host.h | 2 +-
>   virt/kvm/kvm_main.c      | 2 ++
>   2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 3e86cdd00e59b..e3666d0b40b74 100644
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
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index e3a77d1e6d8ae..560ff05e95959 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2422,8 +2422,10 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
>   #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
>   static u64 kvm_supported_mem_attributes(struct kvm *kvm)
>   {
> +#ifdef kvm_arch_has_private_mem
>   	if (!kvm || kvm_arch_has_private_mem(kvm))
>   		return KVM_MEMORY_ATTRIBUTE_PRIVATE;
> +#endif
>   
>   	return 0;
>   }
> 


