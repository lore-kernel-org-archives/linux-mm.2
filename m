Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FAD0C43327
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 09:20:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B5716B00A6; Wed,  1 Jul 2026 05:20:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 765CC6B00A8; Wed,  1 Jul 2026 05:20:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62F806B00A9; Wed,  1 Jul 2026 05:20:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3E4CA6B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:20:32 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9CD12C1891
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:20:31 +0000 (UTC)
X-FDA: 84939662262.26.524E29B
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf31.hostedemail.com (Postfix) with ESMTP id 07A8920002
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:20:27 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GBZnRBOk;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf31.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782897629;
	b=ZFTB5u8GeRN8S6Zhfdgrm3vGFD1QwtgO1eZC6yHZbJT50sJJgjBVgNVnxaLXI9iXgSz/E1
	YuucJXhzrTtAHDzy10rl0PkSlrHzYaQ3E782I3oz9jOE3tTw0LpG6A4fn/2pGS/UbUGbZ6
	j6Z52YxByKuwXBCy9kEzM7KXGv94jUk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782897629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jtTCcvxORQonvZo+0sPcfiNEj5kalNM3KaHLQMcW5lI=;
	b=mL6FwkfHx/DRukjaRWp7pWpNlK9Cwte9n15N7+Y4vCZpzXZKfnhCHQKxA0Vg9bm0wDIdPA
	DYsZf+lFGeblC5aSOdXKVvWkWA9gKOizoDPsW0xJ2Ri3KXSHgwSZjKFQN05VOdzTQGGjGF
	JH1LAj5nL/7kXNRYVf1w87AUT7Q8O6w=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GBZnRBOk;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf31.hostedemail.com: domain of xiaoyao.li@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782897628; x=1814433628;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7J8U0aOHIOgQWuEsjj2TtWJ9iF88n4wrQKbJKxMJsMU=;
  b=GBZnRBOkTYvWF/KbAbb6KLB2ZZEdsDN9JWgsA4zOFu6L02C5jkKMg+WL
   XX21LwA5QazT6R1rSbm9jsnZbBBlVBIxnbbO3mMv+LsK8FUxgqUMazBas
   4UU+Y59+feTOcFq2WtFVYGANHoQz0xk2xKqY2piExbzJiKpRUQnHPvAbj
   9ks6+kybnWyyyvTIaqGWjg9JAurVpxEiRecoZ5DUShfSEULOPKAsH636H
   OnWWFyATQryy0CaTYzkRHs+zFOUl2AaVdnCDzE1vlinFRJLHD0mmA4VWi
   s1Rbfd4f+mZ2i56ll5+OC5ghuji1U/bm8t3r8J0VnDCP60wRqZlnXaMUE
   w==;
X-CSE-ConnectionGUID: ADJAwrdlQouaG0v6ntNZFw==
X-CSE-MsgGUID: XL5LqOVUSymrDdAP1O4heg==
X-IronPort-AV: E=McAfee;i="6800,10657,11833"; a="71148530"
X-IronPort-AV: E=Sophos;i="6.24,235,1774335600"; 
   d="scan'208";a="71148530"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 02:20:26 -0700
X-CSE-ConnectionGUID: GCoFRbeXS+CWkw/DTSBMHg==
X-CSE-MsgGUID: g0z9xiZWQNWS5ThC6q4GpA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,235,1774335600"; 
   d="scan'208";a="252647190"
Received: from unknown (HELO [10.239.158.49]) ([10.239.158.49])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 02:19:59 -0700
Message-ID: <739e6834-40b3-405b-ada4-d31c38d8416a@intel.com>
Date: Wed, 1 Jul 2026 17:19:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 06/46] KVM: Enumerate support for PRIVATE memory iff
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
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-6-9d2959357853@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-6-9d2959357853@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 07A8920002
X-Rspam-User: 
X-Stat-Signature: 6hmqqd8hwanaqj9x6yddm8x57i8ia7hm
X-HE-Tag: 1782897627-382391
X-HE-Meta: U2FsdGVkX1/VmGX9ln4c6eTXMQnVgF45/varEDmpFZ5MPtxxaljXVnxwL8QN5RDf9SfKDeDvxL5OT1tGiIXP6Nq0jJXJCdraMZJmgV1XXerAuGTJznDVtpxdlF6J8ahQKnTZ7Z215rxO4WuqyVhIBpvG6YoIXH7aWvo1KAauBwSiY+w1UePgNYgu7sGRw7whdq6ajnITI77QoPb9P0R2YEkvg5cuncvJ3Sd7z2bItJ4+NBl/tWHswTP+/H7P2x5J5jR9ZeVvfCDFmGvofzzDbvGa3wLsjR9wksj+gGdWgjYDMQlJg7u7pcMKlAwcbYCBfK1FheiWjSwDlCdDe4ol4TJ93Wt8aovAo8rX0MgqwgZ3Qme01rS+wIwg1Bun1lOZDNEq4iMQdb4D5uQCwEN/DYHKCYfnpyne27/5QB6NtlDoYnbealt+dOCTh7GzvV8xvEGdEFgs5hmV99G09NbC1HoktqcUQYwB8ivPF5sTuhVz6Da8QwwF5OdURKFui6CoND4uNH77/l14o1ZwX+mI4l76kJwqBPzNA8FJqs4P7TIx7wO1K5Lon4uiZVistkL5ubfj8WguMPy0WFG9c2Cpp3NBstjcuRbKSZCIF+5UYT4LYQbAixobNKyoRx94Wp0V4Qu5FwL7CHoEGPyvhZFx0BfbnWnhtxSac7f1nFChrB6GqRfWuw2eBsdlQqifJXVq5MlgzyLW2gq4jd4vj1yImnf5eN30VqEmTbtC0IC6THjwhObEKVSBZXz05lz4GLshgXk4YGcDQnNXqbrEvU7F6vCtZiTfjeCeKIkMoJlZMwbMLtTsqGrFffjCaFugwhbKlHJtsozciYwDsRV99fXRP4rO65NuhJwrQkFZNyCVpe8N+7Jw1XKgVlCyJmPg/zg3dlw4WHUBZ9hkdpTivZGR6kWl8D3Zsv7VpqDUG+jTKIS+Lq5ovL7z/N00qabBr+BeuoerYUX49hLEE/xvVsi
 bGqB2VjM
 KxzlccV6wCrPMakSX6mhA6E0O8xY5PMWjDGjQuV28AXqfKc9gDdhBXimvHOOW+maQewybt/z6rGl1LxQHpI4PmR6pq88ucvWEKcmYqKTohSvpyDlD1rJwxOj+bzLf7f7+UNlBQUm3QIev7mgXdV3q4sn8Yed2L96J2KXjEO43J/p91X7V91Lhm/tCIYBzFanUN/fcKOy50PqwKHPfYBzPV8HnwIDiuvJ96gzveSW2XJxsMEW40FL2+4vrBsDRVyAQNaUHh31pJlX7/UzNDaZwKP3JEqZhq4/qw9WKp6wdQLpktf4WPdvDpdjA5kIi2MafpjOUic1UHqislxtcjSpuBlr12LAwZO9rDtWuaoisKlTSaCo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/19/2026 8:31 AM, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> Explicitly guard reporting support for KVM_MEMORY_ATTRIBUTE_PRIVATE based
> on kvm_arch_has_private_mem being #defined in anticipation of decoupling
> kvm_supported_mem_attributes() from CONFIG_KVM_VM_MEMORY_ATTRIBUTES.

Well, after this series, kvm_supported_mem_attributes() is renamed to 
kvm_supported_vm_mem_attributes(), and it's still under 
CONFIG_KVM_VM_MEMORY_ATTRIBUTES.

> guest_memfd support for memory attributes will be unconditional to avoid
> yet more macros (all architectures that support guest_memfd are expected to
> use per-gmem attributes at some point), at which point enumerating support
> KVM_MEMORY_ATTRIBUTE_PRIVATE based solely on memory attributes being
> supported _somewhere_ would result in KVM over-reporting support on arm64.

I don't understand it. This patch only changes the behavior of 
kvm_supported_mem_attributes(), the usage of which is guarded by 
CONFIG_KVM_VM_MEMORY_ATTRIBUTES. This is config is only visible to x86 
due to patch 03. How does it affect arm64?

> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>   virt/kvm/kvm_main.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 1ccc4895a4c26..7b989b659cf82 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2421,8 +2421,10 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
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


