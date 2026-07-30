Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 768D0C54FD2
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 09:58:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85EC46B00A1; Thu, 30 Jul 2026 05:58:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 810076B00A2; Thu, 30 Jul 2026 05:58:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 702196B00A3; Thu, 30 Jul 2026 05:58:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 420466B00A1
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 05:58:22 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CA72EA092A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:58:21 +0000 (UTC)
X-FDA: 85044992802.27.F2D234C
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0F39D140003
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:58:18 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=P7rvLzGR;
	spf=pass (imf09.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785405499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qfmN1bQzqO+Rk0ffML22cDwczVuBArkQZFN9qfd1zMQ=;
	b=U2n+a5OU8TL27XBPVCuG3yiwXdkO1XJ6Hu6V18GXhFkRnOPhxZUgkE7Vcm0c+DaumIGw5z
	Y+Dwgi+47rDRy9JW2XF4H24RgQjVL7/IifWVotojNfMWNlchcwuMtDq5iCZGydPGk/NEdB
	GhC0EjiniWaPUogY4L7qYU2BXe/s7BE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785405499;
	b=EroMSqsjhvacSuSkH6XM4hokKp2lIZNTCyWplefE07jrTEjVrNLiDpnixSeyghi0NtpAD1
	9ymWU0gjfW++bv3k4Oe+eCBE+vspCujxvTone88La4H4OuzeWAbwtavChnPVdvi80F02oW
	S+82POnlNYs5yV+4ORswE03HJximzQM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=P7rvLzGR;
	spf=pass (imf09.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785405499; x=1816941499;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=jfFI1NumX8PLykOdxR0JzkYx01P6yXcIgS+lSqQphOE=;
  b=P7rvLzGRmngOjAIdiej0Sxo9vNx2sZzJSqEQrIrbtFeLD9Jou7wlrdJf
   gd85nBjviBhOPV6QJ/SY0xLECawOGGG/ZiEJIfcoMPJZHD1JTXG9B4eGd
   pSS+ZLXxUKVUpphSdB4LMyX0eXxnhpVZS7PGc771/5XCVcgUXAx2sxMme
   nSkjGx9927qoaQb9FBTzI6j/Ni+WTS+vrSnSeW6XSHDiHzNoZ7BOuNIjo
   kOyXIs3rvXN8vxVgFGTg0VVPxJrh8CoxXz19AbqhzKSuLa78EqwCNnTKX
   KNuWgB7Hyb+0Myg3NH8QXLpAsVe7xaLJjtwT94vu+Hhu1SLlPMjh8LDe/
   g==;
X-CSE-ConnectionGUID: +3r2zgbPSDmgkRvJ3QwDcw==
X-CSE-MsgGUID: 0y0hFsUQS9CcmD0XGhp5VA==
X-IronPort-AV: E=McAfee;i="6800,10657,11859"; a="86211553"
X-IronPort-AV: E=Sophos;i="6.25,194,1779174000"; 
   d="scan'208";a="86211553"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2026 02:58:17 -0700
X-CSE-ConnectionGUID: oS52XiaARmuPWXkloKb0ig==
X-CSE-MsgGUID: U5RpQ7eVQcaEsE41l48cdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,194,1779174000"; 
   d="scan'208";a="257576394"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.238.208.132]) ([10.238.208.132])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2026 02:58:00 -0700
Message-ID: <7dafaa90-f3d4-4be4-a5cc-472163f18040@intel.com>
Date: Thu, 30 Jul 2026 17:57:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 03/41] KVM: Enumerate support for PRIVATE memory iff
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
 Peter Xu <peterx@redhat.com>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
 <20260728-gmem-inplace-conversion-v9-3-35f9aec2aed2@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20260728-gmem-inplace-conversion-v9-3-35f9aec2aed2@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0F39D140003
X-Stat-Signature: g4akp4ct7xy5bqkyuz8ksetz3wp1ftgz
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785405498-859116
X-HE-Meta: U2FsdGVkX1/ZwyuNYe6sYt1+C0SpFr53i99VNuc59Bn+p6lQtILETRk+ZHZ73WdPftvTAcYcQttiFvI5IiCtMT66T63iV9S+PFPdNlOLHCSWYicyPKXqZGj28lzsaMtlHHL3hiDDL66MAJWHK8GvrJeHU7RshB0j7JV7jzkW0+OoQMmnpsJZtUcG7tCl7wcRPXaJPWUT7jZYX0d/76nRQ+GYf9Tay38RYHsrDcnfr4E/vBMIa5IhBXCmV2szWbzxFU1Qx6qEESjFoypbHzyNb0k1ARvSdk12Dt2VCGDI/QMoF0v7RakR1ga6n0hZ0JQvzJAj+pv0V/HfhTeyaiES1IuKtz68jnxzhKvF3f7qUzoTRRNUlFJrLUwOcoPIQhHFrn5PngrEnq29n9Lq792WIoznaG9YWudvidAx0AK4CVSCwfsPyKsWGaaQUfYsS7+Of22tvbfSpwSZSxZF6bqfyaYzqHZGQkCBWXm5VNQU+NCU0ucBcbNu7pRpfQ3tdCypBbk33iUlwzPZOA6PhcjX4JACOBaNTUjRMsxm5mZ59j2tKvK9xXVGQolCk4Xgf8ZIfZAJRvoDGOtbceLFtXAj+Si9H+axec3OwcgJlmK6FJC0RoiFN1ubtBVKP9LbBjGoyaIVnlTz5Fpak1wbh/1FCnBdhSXTOMjqP+14OgsuBpmgzZ97eDgQhKXssJmRlmwHysCMIQFdlhqjZaf0zYNn9+DaGajp4GebfalAaEHr64Ne+lT8V2EcTml7fsLonD1kSijNj/jSOMU2lpC93A2I/jYZTfeTmBAo9FVsVGhNmWonJUz0HuxRKTVsgkiMYfmopBb3qIbtC1eXqItZ30PVRqI23If0+8WopKx8fON1wHL3zX+WKGO56A5+OjEUoXIsNC3G8oms66kmGCHS1M3cdSvD7ZEAXnRQRtlAc39YE1fx9MxbeP0SdkyEguufi9mEnM0tMmizCp6u+rwdzBJ
 27Uol47k
 j2S3YToHpZgI5lMRbpf+vNTbSAQ8ccMZOUbc/Ke2p0W541Qp30OpF0D84hFUHsFOZwR4dUkQZ9q2uY1utABvOkg3u+Tgrf1zJBWEqGeYakIB2PEQkzFXf34VPLeQWkZ4SBBUcRK4+Y0GWUuOEiSfMpRJPgwipRtlN2UyCL41vLHgnW/n0o4NK49iSH9o8fBU2jbRBpjo+8yc3XAs6ak/PeWfSskdxVSthD1W3m9cr4b69kue7/oo9gxhmuuuniniQHsfvIpsHy6DpMCJq1d9LoweWNpCoGYhu3R+hVeCbgQBVYWhPeWkVVhbagnZ4dDt0nlCwyXMAW6nM9PY2fkNvmcwWag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/2026 8:35 AM, Ackerley Tng via B4 Relay wrote:
> From: Sean Christopherson <seanjc@google.com>

Though the patch order and diff of this patch is adjusted to what looks 
in v7, per Sean's request [1], the changelog still looks somewhat 
confusing and part incorrect to me.

[1] https://lore.kernel.org/all/akVGZOeR1ytfkamK@google.com/

> Explicitly guard reporting support for KVM_MEMORY_ATTRIBUTE_PRIVATE based
> on kvm_arch_has_private_mem being #defined in anticipation of decoupling
> kvm_supported_mem_attributes() from CONFIG_KVM_VM_MEMORY_ATTRIBUTES.

As I commented in v8, the "in anticipation of" thing is not correct.

> guest_memfd support for memory attributes will be unconditional to avoid
> yet more macros (all architectures that support guest_memfd are expected to
> use per-gmem attributes at some point), at which point enumerating support
> KVM_MEMORY_ATTRIBUTE_PRIVATE based solely on memory attributes being
> supported _somewhere_ would result in KVM over-reporting support on arm64.

1. I'm not sure what "memory attributes being supported somewhere" means.

2. the kvm_supported_mem_attributes() will be renamed to 
kvm_supported_vm_mem_attributes() and it's still under the guard of
CONFIG_KVM_VM_MEMORY_ATTRIBUTES, what's relationship with "guest_memfd 
support for memory attributes"?

> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> Tested-by: Shivank Garg <shivankg@amd.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>   include/linux/kvm_host.h | 2 +-
>   virt/kvm/kvm_main.c      | 2 ++
>   2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 9f78a466c6f3e..c125d2e8155a7 100644
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
> index 902aa166c9c0c..9501dd8d015d1 100644
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


