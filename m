Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65EC6CDB466
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 02:52:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 450246B0088; Mon, 22 Jun 2026 22:52:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 400CE6B008A; Mon, 22 Jun 2026 22:52:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F1926B008C; Mon, 22 Jun 2026 22:52:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 054206B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 22:52:04 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6EED0C1A61
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:52:04 +0000 (UTC)
X-FDA: 84909652968.29.1ACF239
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf11.hostedemail.com (Postfix) with ESMTP id D641640006
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:52:01 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IqwTSbJw;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of binbin.wu@linux.intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782183122;
	b=wOSYrs5DJmgeWVHaHuzdP3zIIptbE5EA5PwNLMGKi7v+b6H9vy8gnMgQQOXw0ZnvBpnEvf
	vGGTJHMHg0MCA44GjQGLoMymn/9NVTs3/iGu9kugCFEtSSMMtvrWFOh8/x7ST5rpmKKfjg
	HTNrbtcmQ0PHxXN265T9TYvegvTEKgA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782183122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+7Q+NUzmhIUzhnPRRS4RG9zk8PnTg2ytEjKZBaLaKYs=;
	b=z1DQO8kNKocqGLV1T2jejyNYSaZn2VZCN+zIU7TiwszGwIoK7l0aLoiYP1dSJ7ErjFdjNi
	9Tu1uhaVYwtg5yfbdOWilbMFEShx3TmVAjTYK55jzte+34KTBntGb2pQPTUKODWr5Y+7OB
	44q2lrTZqunclAdtNOBlJkAziB1+cro=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IqwTSbJw;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of binbin.wu@linux.intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782183122; x=1813719122;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fjVDDQxNLoarUNyLHXojlIytkjIfDGYDPBQea8XedRo=;
  b=IqwTSbJwMmhEafpktjWr2QNVrV0BBxPFftxRbwwes6oNcFbc3/Al+kFs
   VqgQVeF0pw4b35FRD3tYdIotl5vIbQj5dGCEMJr4o7V7jjZcr8Ehkt9qp
   OoLP6VnEhQRL6jDNiDMtX9p98mwij+wjOSSpn1m7wV2PPoIzzXN6pVIqw
   jE3jpTbAVKN/0iARUy9BmlTUjtbgash3BLJi7CzH0DzUGUtsl5V89GDGQ
   +PSj16OI5XarZWi+4yS2orjXTGqSIa9REZ/7059j6NXwveTAJr6nq1C0v
   /suMPnsR2YtDyEyPlgKZtLA125wZHU9LUXMRnD2IKq2sltD73Zzq79IOu
   Q==;
X-CSE-ConnectionGUID: B/UgFLAsQhWVL5z466/7Lw==
X-CSE-MsgGUID: kTgx3aFoSxq0/5+H6QvtxQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11825"; a="83010796"
X-IronPort-AV: E=Sophos;i="6.24,219,1774335600"; 
   d="scan'208";a="83010796"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 19:52:01 -0700
X-CSE-ConnectionGUID: DX/WscZvQoiIRwAKC5Kyvg==
X-CSE-MsgGUID: axAQd5q8QI2J7SjgRPnb8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,219,1774335600"; 
   d="scan'208";a="254374133"
Received: from unknown (HELO [10.238.2.81]) ([10.238.2.81])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 19:51:47 -0700
Message-ID: <a21bfc05-787e-4cd8-89af-8579357e6a12@linux.intel.com>
Date: Tue, 23 Jun 2026 10:51:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 04/46] KVM: Decouple kvm_has_arch_private_mem from
 CONFIG_KVM_VM_MEMORY_ATTRIBUTES
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
 <20260618-gmem-inplace-conversion-v8-4-9d2959357853@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-4-9d2959357853@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D641640006
X-Stat-Signature: h4ywamjnwoexw4hu3ayjoxgrg4a4kase
X-HE-Tag: 1782183121-814316
X-HE-Meta: U2FsdGVkX19m9vZgg5f4EE/IFKDjtDrkGHxQdJuYVOlTFgFyU9Zyggso+ZPuBjH8bVIulTN4M4ws/++9Di6EY+c06rXWmJYx/fuUV8aZl7yyvw3K/OoCkJ53jU2FMmiIaHcyXps/cPgZD2RYw84WtgLEnBUag/gcELjaF5VCspj/7HxHp31l8zP3/zWQAkeaMBfbCL6aQEbyMVs4xrgP/aewCd54A7HstlnqBXVSkbQSfPKKgEVRRdgVgQeHDez9xZt++zVCW+Q0dtm7i/A3rcfIHPoFjQD1PoVqNJT+Q/fxGuLi7tX96acXgg/MjTQZsG1PEdCu3FsRxv8l3vEnf1KN3m0c2ZBbp68KNzcyvKSvDrHkIfXrA3M4T2utCh8y1WRg58wtNmBEi99Jjp3NRFdKJ6CWUDd7H61yQo6eb8QwNFIZFCC3Ga6ISZ4/Jtf5hSZdoJogS6kqgr1ZVu7FjiFf9fa9os5s+pHo3fmwtcrd/RpOmk6bfiV1GzqpQdguVoXOyMQ2r6ooyd9mOT4qMOpPPRHZRS2Z8JwDW/cZTVzMFK3cBDfH8p3vvIBph/wb2CM6jMKEnCL9QYDnF12t/2ZlU009prv1G2iFC8+SMR5OFhoBZeK5uyzO9YoQmvk7B2xogslEcmw91HZpFSv1jjlHyLThWgLU53f0L+VIRx5I4fLTwFhCRPISw3CZmmR8UcHA+kbP+V+64lMy2NAtLnbufif291GaQjDcjaSA3tpzkf6TSOsq83w24iv+PgFZmGH0/8aXhabxWzASoxO9WxvnmhaG2ahA3F/fnW1A38UZe7pf2oaw/NqhM9DK/MCvUnUlkI0U8nl4/K67NVn8UQk9+U6nV8ZejKxiTvVg3oZDZjwcKtXZSCi8/oSkm1narVDama76F5cN1fUE2EDlsfi/aub6nFgLlW2V2lZIiZeEB05m1wE3nHH3pTtSMSjZfCUZcsgWq/1QGEPGSNU
 oprTHAcd
 GjWE/3IGI/wqd0sK5diLfdudt3kgYMlv9ag2LJ0X/H2POpuI2VI3iyOwPDSkelWPa5Lrbv/q03J8Q0vni4I8j2qDn/es9p9GvtxOAnwUTgQM+y8TZK0RtfjUbNSUo14AU66fwtTUQP2bHrnFsRqbGDAlmU3jwSYfeq2fi/9WfiybgMgpkBjSXnCNThME35p0AoJ9NKvUsKLColCV6ozj1lx1rYiWH3y+KEVL0QR7fA1AT66idznGOOuOczUQoJU/8E//jxWMA/wOgwEyN6Uo73kQ2WmLXsK0mzSZs/XCVpOTi1FlkAuNIWSO0s00ccUVp7rr8o47/ZJGnZKD6ZsIrf0joBA==
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

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

One nit below.

> ---
>  arch/x86/include/asm/kvm_host.h | 4 +++-
>  include/linux/kvm_host.h        | 2 +-
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 8e8eb8a5e8a6b..1bde67cf6eb0e 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2394,7 +2394,9 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
>  		       int tdp_max_root_level, int tdp_huge_page_level);
>  
>  
> -#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
> +#if defined(CONFIG_KVM_SW_PROTECTED_VM) ||	\
> +	defined(CONFIG_KVM_INTEL_TDX) ||	\
> +	defined(CONFIG_KVM_AMD_SEV)

Nit:
Vertically align the defined(XXX) statements for better readability?


>  #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
>  #endif
>  
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 201d0f2143976..d370e834d619e 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -722,7 +722,7 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
>  }
>  #endif
>  
> -#ifndef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
> +#ifndef kvm_arch_has_private_mem
>  static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
>  {
>  	return false;
> 


