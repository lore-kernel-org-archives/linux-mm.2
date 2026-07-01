Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6BEAC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 11:18:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FE8B6B00A6; Wed,  1 Jul 2026 07:18:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D6C46B00A8; Wed,  1 Jul 2026 07:18:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5ED116B00A9; Wed,  1 Jul 2026 07:18:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 373AA6B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:18:55 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AC7D040306
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:18:54 +0000 (UTC)
X-FDA: 84939960588.18.BCEC00E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1ACEA18000A
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:18:51 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="dndkJ/bV";
	spf=pass (imf06.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782904732;
	b=S6BvHr6hEWTZ3BziJADhoqfka75wiXzIGa/eM95xLw2u9wsATZN7iPVMRqYkgCCdFO5z/Z
	4HW0btX8v5ptsV5QlOObMKft88/I5gbvmtdwbExX2x3SOQavOzbuOkudAYb7vCzKiZOKdx
	rKtviOR7slNEdj4w/REKdCfPChHYC7Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782904732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OI842uv23J+md4LMh/mG1d1Fm6026V66uHxTmYV3sqo=;
	b=YvcivY58gfe5B7a8RG/XulFSzOEWyGb4jmoxdoohYty0/2FAds5QUA5CCOwq42vL81hmBd
	FzB1LJkHECnfDYcfe0UL+FKOrQoMwD5hV4YOr0uGnfaDoJDrCFbzJ8TRf+yOFXIPz6MCGX
	wIIwZFjIplbg17CEmObrJBLe60QowdU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="dndkJ/bV";
	spf=pass (imf06.hostedemail.com: domain of xiaoyao.li@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=xiaoyao.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782904732; x=1814440732;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=KamIF/GbQilflin+sZ24rcVjwHbCunBsl6fGoIU62PA=;
  b=dndkJ/bVaRCVaQzTmC4eOUHdIbDPWWipZbV2aOIFYUgA3LgEp7wbC2Fe
   OTGygtlSlA3cku7q9IDPHGtQHg1LhhPkV+mMTsu0vHiqdjoGIOEeinfOU
   F7J0MdA+MbLru1MYrhn3i6lGH74iehhi0xHrOqIiTDF2tMT5KxniTXYeW
   SH3fMovFU6YfEHDi1hs6TSVIr4qhVIHpTFQAlXnhBC4b8uIooM4d/2RTS
   pK3lYsmvyMHbkpeD8y6znLxMDdoJaR3xNI89uo879LcuEZStJbns8ne45
   TIZpG43M44JFaLjHjjiPMXDyo9ETzkM+SxBrDUD4WUgzsiEqQmVStfr9P
   g==;
X-CSE-ConnectionGUID: 5nN7bScuTBi5rml/x0bB2Q==
X-CSE-MsgGUID: qDwl7TTjTOOvZlozcYfcGw==
X-IronPort-AV: E=McAfee;i="6800,10657,11833"; a="94789729"
X-IronPort-AV: E=Sophos;i="6.25,141,1779174000"; 
   d="scan'208";a="94789729"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 04:18:50 -0700
X-CSE-ConnectionGUID: aLlyHiwUTXyhs4lgY+f9QQ==
X-CSE-MsgGUID: bSTU4KQCQOiPSgzMr577Lw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,141,1779174000"; 
   d="scan'208";a="256461895"
Received: from unknown (HELO [10.239.158.49]) ([10.239.158.49])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 04:18:31 -0700
Message-ID: <ec45ccb5-e219-4e5e-969a-127c6166fd27@intel.com>
Date: Wed, 1 Jul 2026 19:18:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 25/46] KVM: guest_memfd: Enable INIT_SHARED on
 guest_memfd for x86 Coco VMs
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
 <20260618-gmem-inplace-conversion-v8-25-9d2959357853@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-25-9d2959357853@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1ACEA18000A
X-Stat-Signature: 3zg9gta68amt6qp58j594fxocipeirky
X-HE-Tag: 1782904731-569930
X-HE-Meta: U2FsdGVkX189biaa6rQp3vGSQ7xZ1sR8wdV/7tRxIwS+hyTdC/K5famVP0tcec+SxJZTZYf0lIg+VZEPL6kwVP1Cn6/+dqKtnOrpowJCVh1V5K1/mwAm/i2CGK+o+Aiv+W7lNmFujR7upToxOonP3T1ivvqrKsVaRQy87bvVoHAoScf9J6s0xVdf22r57XHvOEm5j6b2Z91SsX2LtcHm0rousMNlMV5VFI4mcv/xesSF8GqbvKOT/o/kH7JZ9izM7c9uHdDUjFzTn1dw4WENAf2sqfpkEX4IphVUC9GF6lW0ecTmu54EliD/6L70Wa/hVuuaApcS7/mQVTpltAXDeG3A/wW5l2Hl+PVMOXRZRC9YtKTaGe5xjy3WSFuEP/Pk4Ewpg7Ot7uaZRRirIUZAqvZtkAfTfwzbE3JWzQ/E+EHftEEDpP+sTN8ThYHxlmnapV6nNx1lrZbCufe9sErnJIvAFqQwdE/xROiG3IqTlpJft/gfTtwCK9Cn4Zl+Mt6I2Dk7dC02W9ZLF9UjGISYhrm8Sl5VmNdjN38S/OwfSwCmRiVxVqyhACzePL25nqjFPZIoHeQD+u2rz5jMdbnLl20BfVQTxOFBYqU6JjOr/jGDKy4LkL4jnzczYE5EsNMNbeAeMgsJ0RyRqYjtZisdC1lCwIztbQhfE+++JJsYLzusAbkWt9WepEMVBC99UrTPRwQghCxwvVELXWGZaPb/4s/SJi3h1FH4ccbP5ee5s4FqL2AvXTCqMhN9tupU+0zSTnH41pTiCvbE4qiMh/CjjicEazkp2T6qB8FbJqbVgRjld8rZCwhnTB+jOletgS4c/W/Zc21BmD2Da45O5DtbdzWVUG4hKrdlJoUSW9PxfrQ7AeaEwGfBOBtKU7Ca93MNM0SZHW4bT9iwQCLGw0dBE0xpgUssYU/Lw9Io84YFGOJpxPzsO75QfSe2iJe9OeWASCTzohiyffAvOEyRaiL
 BLCtvFat
 KM9lcdMJhR19RVFZelLxu/71Hiin9mZNih05yGPt2CNfc3mVCriA1wGGYym9FnQqMlOaPsYplsATDYUSmPefBdn3R5U1l26QBkVJjqYHgnJpgCCBnlvUfOjouifqlaxxgurX3NAGtX74F0HCrM/bkWofeq+tVmAppqIBH+eX/+J7xWpVHaQ38TJktpiYUASPx6IEionrxRwQtr4ZfvCfmCCCPUbKV05bXxxg4hcCaSqZoBD9yA8uL7ktAKqriLywpd+UepPZ5q2OJ8Z/jGP8DkKAcR486Rck7Bv0SYx/yBJzJzvcdLoRHH7d1h8ckNoTm8rBUlTZZdVnNMjT4OsTEo4+Hig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/19/2026 8:32 AM, Ackerley Tng via B4 Relay wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Now that guest_memfd supports tracking private vs. shared within gmem
> itself, allow userspace to specify INIT_SHARED on a guest_memfd instance
> for x86 Confidential Computing (CoCo) VMs, so long as in-place conversion
> is enabled, i.e. when it's actually possible for a guest_memfd instance to
> contain shared memory.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/kvm/x86.c | 13 +++++++------
>   1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2fde594e86d72..57a543dadb851 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -14116,14 +14116,15 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
>   }
>   
>   #ifdef CONFIG_KVM_GUEST_MEMFD
> -/*
> - * KVM doesn't yet support initializing guest_memfd memory as shared for VMs
> - * with private memory (the private vs. shared tracking needs to be moved into
> - * guest_memfd).
> - */
>   bool kvm_arch_supports_gmem_init_shared(struct kvm *kvm)
>   {
> -	return !kvm_arch_has_private_mem(kvm);
> +	/*
> +	 * INIT_SHARED is supported if in-place conversion is enabled, or if
> +	 * the VM doesn't support private memory.  If the VM has private memory
> +	 * and in-place conversion is disabled, then guest_memfd can _only_ be
> +	 * used for private memory.
> +	 */
> +	return gmem_in_place_conversion || !kvm_arch_has_private_mem(kvm);
>   }
>   
>   #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_PREPARE
> 


