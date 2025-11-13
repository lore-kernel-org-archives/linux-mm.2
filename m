Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F3E2CD3445
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 01:42:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED3148E000F; Wed, 12 Nov 2025 20:42:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAB038E0002; Wed, 12 Nov 2025 20:42:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE9328E000F; Wed, 12 Nov 2025 20:42:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CFA0D8E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:42:49 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5D4A1160772
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:42:49 +0000 (UTC)
X-FDA: 84103884858.06.FD4101E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6C48C20014
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:42:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Q4lsqY4V;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf13.hostedemail.com: domain of binbin.wu@linux.intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762998166; a=rsa-sha256;
	cv=none;
	b=1vCKc+7zTCPHbxuPyppsgsq3RzTPWkppf0/JpEHBitQp1fpvj0FkSftCzfnB7F5IyqQP4E
	TGnuH2SAQ3z9l2Rz+oppabzycMemjSE6tM5Z+eGZLvOBr1WdHxvBImniJXCtZlOnfmgvg6
	8NbYzBY69vLkO4JgTiv0poasnTa41R8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Q4lsqY4V;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf13.hostedemail.com: domain of binbin.wu@linux.intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762998166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VT1994pC1494Qkwb45rLrsGK74ygpTSWjtnNzbMc5Mo=;
	b=4eQe9ZcOBxM89MyvnT13xOsjKYJJ52TZrv5bJxqSLN6IKFk219fUrZ2V/OHD0NmOWMSDhP
	hq5CpiAjbf0phMJrXMD31j0tSfrfti1YzE4NHdqhrlzGCEFurat+QDpPaf4haPQHwWxL2A
	+OMr+7vaJVX2XNlKaEiiunIT4xtkBAs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762998166; x=1794534166;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=J6kO8MinoWEoGkaYJTyrYhudby1TwSS/GObHrnk96Qk=;
  b=Q4lsqY4VXX4igiIgshReZkyUtIgsWlt/3ol98tkOjnkpawdgTu7G5CZs
   ui2RzS6wPdpnMFN5iQwFkR6HzGCOAvOImdiATC+7tjwBI6hazPLiI+O8U
   vco0brm5UgrvCLxkxVX/HgaayuGOiKrVyjjFKdib+jDANbt3wA71Css7t
   bED2XTfJw2/jut2ror+uN0nfcIbKFEuM5AOQlnqVR6sUNJj2f1WGfWLRp
   psQh/cKHiTwf/rR2pW5orMcOlFlwkDYJeqtOfJluCvGbCmXkGuISNgTmY
   dvUotlKOeO8l+bWEcYAfFtKtQjMZ1Elge6cFzjB1RnIJEA3JToTFh4COU
   g==;
X-CSE-ConnectionGUID: aLpexhvMTcCGVL68e9dgfw==
X-CSE-MsgGUID: ioWxOhlQS/CBdNNwm9NW9g==
X-IronPort-AV: E=McAfee;i="6800,10657,11611"; a="65225854"
X-IronPort-AV: E=Sophos;i="6.19,300,1754982000"; 
   d="scan'208";a="65225854"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 17:42:44 -0800
X-CSE-ConnectionGUID: UV41EMOGRgSJ6IjRZ/og6g==
X-CSE-MsgGUID: cb9xlMdyS3Cqc07OKTsBXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,300,1754982000"; 
   d="scan'208";a="188618989"
Received: from yinghaoj-desk.ccr.corp.intel.com (HELO [10.238.1.225]) ([10.238.1.225])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 17:42:25 -0800
Message-ID: <f2bfa5ad-4c74-4b6d-baa7-d0d01d5d9b15@linux.intel.com>
Date: Thu, 13 Nov 2025 09:42:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 03/37] KVM: Enumerate support for PRIVATE memory
 iff kvm_arch_has_private_mem is defined
To: Ackerley Tng <ackerleytng@google.com>
Cc: cgroups@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, x86@kernel.org,
 akpm@linux-foundation.org, bp@alien8.de, brauner@kernel.org,
 chao.p.peng@intel.com, chenhuacai@kernel.org, corbet@lwn.net,
 dave.hansen@intel.com, dave.hansen@linux.intel.com, david@redhat.com,
 dmatlack@google.com, erdemaktas@google.com, fan.du@intel.com,
 fvdl@google.com, haibo1.xu@intel.com, hannes@cmpxchg.org, hch@infradead.org,
 hpa@zytor.com, hughd@google.com, ira.weiny@intel.com,
 isaku.yamahata@intel.com, jack@suse.cz, james.morse@arm.com,
 jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, jhubbard@nvidia.com,
 jroedel@suse.de, jthoughton@google.com, jun.miao@intel.com,
 kai.huang@intel.com, keirf@google.com, kent.overstreet@linux.dev,
 liam.merwick@oracle.com, maciej.wieczor-retman@intel.com,
 mail@maciej.szmigiero.name, maobibo@loongson.cn,
 mathieu.desnoyers@efficios.com, maz@kernel.org, mhiramat@kernel.org,
 mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, mingo@redhat.com,
 mlevitsk@redhat.com, mpe@ellerman.id.au, muchun.song@linux.dev,
 nikunj@amd.com, nsaenz@amazon.es, oliver.upton@linux.dev,
 palmer@dabbelt.com, pankaj.gupta@amd.com, paul.walmsley@sifive.com,
 pbonzini@redhat.com, peterx@redhat.com, pgonda@google.com, prsampat@amd.com,
 pvorel@suse.cz, qperret@google.com, richard.weiyang@gmail.com,
 rick.p.edgecombe@intel.com, rientjes@google.com, rostedt@goodmis.org,
 roypat@amazon.co.uk, rppt@kernel.org, seanjc@google.com,
 shakeel.butt@linux.dev, shuah@kernel.org, steven.price@arm.com,
 steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com,
 tglx@linutronix.de, thomas.lendacky@amd.com, vannapurve@google.com,
 vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com,
 wei.w.wang@intel.com, will@kernel.org, willy@infradead.org,
 wyihan@google.com, xiaoyao.li@intel.com, yan.y.zhao@intel.com,
 yilun.xu@intel.com, yuzenghui@huawei.com, zhiquan1.li@intel.com
References: <cover.1760731772.git.ackerleytng@google.com>
 <405686bacd68ce6c76aa5e6ef40f0a5324983c5b.1760731772.git.ackerleytng@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <405686bacd68ce6c76aa5e6ef40f0a5324983c5b.1760731772.git.ackerleytng@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6C48C20014
X-Stat-Signature: q1xq1roqekhgakfc4b1kuj8887noow7b
X-Rspam-User: 
X-HE-Tag: 1762998166-407208
X-HE-Meta: U2FsdGVkX1/ekGH0p5Y2Pu7L8hTAbMN0QGxYiOcucPUNiAklvE0jwnCFKJ/h830/7NuT5tz7VVmyauMIWmGxdCMIbmpAwHlP+AKw21DV+mkQ0HNUp/6+XEAyYTjjRBgOKmxPJyy72G1sGS6R0jIb89sVP4hvxpO6PKTYS9bPOhGazOzvepnJVYA1ej91P+RqXtkStACC3J44t187N8lit9XzJZOpcmwNkTfIbpN6J9lI2zL1AoRSJMGSelSvdOG82GbjCLDYXRKaZgueJ84OrR0FsJ4hwpBNKtmWX+T2nAsuE5xwobrU0EH6z8VhtlO+ocNJA5FVBf2mhOfiBUG8+jcYfGN/8J09gxMECc/TNXUDGzv9dJ9m23SA0PZW1qnYul6tOsgl2H6JJxsVT2bqyZ0f8ERivzQ8tSa+zVI0klVzGEYL2ThcOHZKY4s7QJVph/w/XvhkgTJHYzuEIejEApIJewWrai/WzmPyyG/fmGfxRGMqwjavmfK3LGYbfw21bDkbzal22s+gSNe3JLpBpYxVZVfXNdkppRSnc1HDXDHaoTa4O191OJNWJQHhJkzifQwG9quo9jjOM7Sl8xuVef6VMw0ZuthUNTOnHGSFgAZ4E6x6B88ivtq5ht2NCvlpTnrKHr1RTdPiPmynroiCNPz2x9HOeXHtFoGcadiW1IZyqDaNsj9Z1DVph4wE/k7GwwFkU3lEUwtL2KLFK92aQvPqoj3EhHQ7LcDL/tp7T5/GfJCUrl2mxphAusA+pQ4TA2S+ynU89o5EKO9d/v4GQLmP2517lK0CH7bec7RS93rdD5PMMZTvOd7JVR6Vi5DvrJXlXIxzjMYu2jCGxMQB5SnhYFipFlWgqnaYl3GixVE2prUibevxAxxnz8CX9qBRbcub/EnfpYY3UQ2i8j6BKwJBKuomee+1mUVatzXfXGT6euDa1VJ2slL3gHFiLPhLvo7A1RHIoqgd1AP72p+
 yBeOvjVp
 GMDUE9IJFW8MUrtF/w/hrOOhtQct5Jz4L0oLlIJjjnxFZhjfNpDpS8562/RF5k3t/5JsFfV8Pcpf8t4FiY8QO5oIlag3FtWxHT3vG3+kx3qKR9exoT+Uhi3ykUah8jAtPtL1WHJXVqwbBJfgJKwcEPkDQSscsBtDJJJfQmiapDQodLY8M3XjYWrNgm2OulAIw/poK8yRQUyOZQ4AE1XoddMxDjoFIVYNyZHp8BT5r0kESZ5oC8mj6p8y1M4hdnb103k5V+suKcbA9SWzYz1bVlX3X/H/4xTCkNn7AJSHWj1tJY3g84DpYk37eOZLApXC5cWw0ssp0KCLl0W1NU+xtSV+HawGdTSOrBmhGqQKKQ/02IgQmiVmlQfWh0MMvhA8caRRDjCacr8IXPzR5Dyh0jBFYxA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/18/2025 4:11 AM, Ackerley Tng wrote:
> From: Sean Christopherson <seanjc@google.com>
>
> Explicitly guard reporting support for KVM_MEMORY_ATTRIBUTE_PRIVATE based
> on kvm_arch_has_private_mem being #defined in anticipation of decoupling
> kvm_supported_mem_attributes() from CONFIG_KVM_VM_MEMORY_ATTRIBUTES.
> guest_memfd support for memory attributes will be unconditional to avoid
> yet more macros (all architectures that support guest_memfd are expect to
  expect -> expected

> user per-gmem attributes at some point), at which point enumerating support
    ^
   use
> KVM_MEMORY_ATTRIBUTE_PRIVATE based solely on memory attributes being
> supported _somewhere_ would result in KVM over-reporting support on arm64.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   include/linux/kvm_host.h | 2 +-
>   virt/kvm/kvm_main.c      | 2 ++
>   2 files changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index fddb373fcbaaf..21bf30e8d3cc1 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -721,7 +721,7 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
>   }
>   #endif
>   
> -#ifndef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
> +#ifndef kvm_arch_has_private_mem
>   static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
>   {
>   	return false;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index f73047ea4333e..591795a3fa124 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2428,8 +2428,10 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
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


