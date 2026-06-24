Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3552CD4F26
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 00:13:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B486F6B0088; Tue, 23 Jun 2026 20:13:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF7D56B008A; Tue, 23 Jun 2026 20:13:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E8516B008C; Tue, 23 Jun 2026 20:13:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7B1646B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 20:13:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 05C5F1A019E
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 00:13:39 +0000 (UTC)
X-FDA: 84912882558.12.08DE151
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	by imf06.hostedemail.com (Postfix) with ESMTP id E941F180002
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 00:13:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=l15yvdGN;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782260017;
	b=ZMWZnvg60ETe914E4nb1Q/QLPV8y9QIm6WAX1rKvi/XERnHY6lVcp7726xK1gh+j0GT+dD
	N39/gh3plk/NpRBmngr5R1snK5KhJbA89zI9yMK9eeQod8pXkBaZ3UqHfzRvnGDXLCxfCn
	TmK8pAgCP8cXsgwcaTharn6XHapn1KQ=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782260017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AXfKSlAh1VQG+yH3bfeaIisPmAkRsyj1F3ZP6iafDhc=;
	b=cDj0vm6PZLYsWf7qNfenMWvpzX+Rqj8aTYhgJdYB71+z7VjQYEFrICia6Y01e82ujkjrLg
	BxDJrzENsDrsFyoqtMOcdmF5Z/jUEB4f2SBY8o6OeOmKmO8mkdxW4jwUjp/0tXAuAw43H5
	8e+/UNogsaAcZLR8N0ZUQlKaO/bDIQo=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=l15yvdGN;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-137dd4cc208so678558c88.1
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 17:13:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782260016; cv=none;
        d=google.com; s=arc-20260327;
        b=jpnLkUXhVTG6EGUg0Vm9CBLqCP97/GGUg93gzO+ZwiqroHEmSREl7QQ0uxVgKdBf0t
         Qd6tdHEGaltZFLvjECxl9B4LTcV5VzJhdScdC5JSnlQH4ZbFQLbrCD+EAFe1mnob058A
         jJwvjnymXJUAaOESa0xWeU9RS+T8lR3gN3zZAUPuT0II2kP6Qt8gXjtuRn40mrhJuGo/
         iB8+WSnPIcu65XTIv7KiicptCnH59c+jkpKvW2KGJ3HKaP1NfOm2QDflS+yzMc/8vMxE
         ZSx1F2lM6QsAd6/tFyoOwjd57aKhFvHVuSjKlaF//lujXTqFUdwJDMDmaefLUpII0p9H
         zN7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=AXfKSlAh1VQG+yH3bfeaIisPmAkRsyj1F3ZP6iafDhc=;
        fh=nHXjy6iuOpadKGq+rptdX6/wZq6ERd8av2ZUnxD9GqQ=;
        b=XoXXCOQs5Kv3tHZUPp+fV0sNYg2kMyRVfUntqHzyngTQuIEVXoJDhJP06bZqQEj76I
         DVILZGdQP+P2rG8XZUVVlkxB2VL1JBWHPqDKDWFB3H1A0RECT9PeSBqleEqZAizH8AcT
         TixgfFLL5HkUABTGckHfeeiJhb7xG8hCJuW4NwQbfmDh/tm4CT5AH4RKutPZJBLqT5Bu
         wdXoXYPC73j3xxQi3+B+FopQlc/RINEHpnTW3x0BayGZdz2GYcPdKzyaV0GLicNiBEgw
         HC3hTgHKEnjqm0VlfITBMFUJmVtXd3WcNaHvaAEbDyaPFduCAfTy9XB9ECXHwpg2hGTT
         tWIA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782260016; x=1782864816; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=AXfKSlAh1VQG+yH3bfeaIisPmAkRsyj1F3ZP6iafDhc=;
        b=l15yvdGNhCYlxKIjX4hw66kKiCoe8DgwYnLpGkkRg2LUfquhQ65QYB6iaAe+w5o1YU
         0tPfhGn1L6ga7ajZqqI23hOsMRuHEOPnaEnUYYEFEXAFaS5FlS8N+BJZn9IS5gBu1c26
         mDloBdQNgw5Hz3iB+6+BpfBOJa8DbYc67cJjAVSUkoOh72lpgKyrDC5CSA0fsRV9eBky
         GeA/PvuQqb+Z+FCpfzDjJnSuiwXqr5m7EYnCvsggExeTeKQCX3+hfxCKEKN5aLUPM+7S
         12jdM5gX9Zp8lqMIOdSbGY4kqXVqMs+lzEyXDwmq+yIbW49APfgKaZSLXNTJrZXMtKR+
         6Azg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782260016; x=1782864816;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AXfKSlAh1VQG+yH3bfeaIisPmAkRsyj1F3ZP6iafDhc=;
        b=fMJ0fOenN9I4+vCefx0rMKFlbjRbU2DU53COHftQzcIy2Mxzjo2v+KL+UzW6fgU37r
         U4a4RPb+IoG4RdLUZ/xxhTQbdPh+YVsOk6P1Uak6DDxEX6dGvcoz2XtAmFce8YlG4MsT
         4eqhVvR+CBZ/ccpz2XKegQ2mFjgJwgjA/gL17NmXBs1pQZDmVaLmn2P8TT8TO/ZLahpv
         /bISEiyIcX1gOcjmJaBJgRd+XtnaMCdL7aEkSy9gnMW/eX/Zr1lP8L5ez5+DvORiBTO8
         5laNaCdF7+6vT9GKrWdZuQ/lTHQjzo8I1E8+R7rH1FEu7d8md+pKp5hOQEzuzkfzZumG
         rRvw==
X-Forwarded-Encrypted: i=1; AFNElJ/207mrZa897ZU4NLsGJhJd/Fz2md9dW0Cn2Kw7fcTj9e2s3q+H4K6Q7D/pb3MtvOo+mQjNLSpk8Q==@kvack.org
X-Gm-Message-State: AOJu0YwATkmKKlEuuzevAMSZhr6tfELUe2wTlCH/qwxIrmi7cgN7uyr4
	vMwpGPnmRi3+eGbLX6UxXh7UPM4G/MtmNXp6bYBobEGTmKr/OsfbpC5O25CUNKEu/4QkQMuvUMT
	c9DilBggEskFuHiwDaTZBI9V/yjb8AMC7gxYGMnjl
X-Gm-Gg: AfdE7cmTYz7zs5dUh4Az2+J1wjpYxG8z3EV30KdBzvqEYA2jajK1RmmSMsRVskfylfm
	e3vZ3I/oqWbw3DOwxK7TkcOZnmenxXbtUpgXLteD56AVvU6h5zDSApYFZGDc27uzQ1ibaXnHBfm
	WzZkxTEnG1CzGjabQGdT91FuuGCshe5tFGXQvyBAIw9m5055EHHJOwcgQW6v+obM7ddd5Yx6xZR
	0VPa4SNIVCZIvdV4bwUnywNBTkQy599KpjUqHGjytshlTX/68ST09Xzgb/hnD6HsvSMJEnrmZsy
	Wk0FUgkIA2xfe3PVjPdRJhzlxRxSwYqxKLQS8CVlDfYOxvzPfpwX2ZIGNZY=
X-Received: by 2002:a05:7022:fe05:b0:12d:c3d8:1f95 with SMTP id
 a92af1059eb24-139c3c12ca8mr4394599c88.4.1782260014848; Tue, 23 Jun 2026
 17:13:34 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 23 Jun 2026 17:13:34 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 23 Jun 2026 17:13:33 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <a21bfc05-787e-4cd8-89af-8579357e6a12@linux.intel.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-4-9d2959357853@google.com> <a21bfc05-787e-4cd8-89af-8579357e6a12@linux.intel.com>
MIME-Version: 1.0
Date: Tue, 23 Jun 2026 17:13:33 -0700
X-Gm-Features: AVVi8Cdxrjo0g3tR27IbX_VUitZ5rT0F_mHH6JHHegralypGAFX77zV4x7wFDNs
Message-ID: <CAEvNRgGF+O7r-YHqcLp-ZgoXTCbqjuUhpOdD5eE5w2wu3YYYpw@mail.gmail.com>
Subject: Re: [PATCH v8 04/46] KVM: Decouple kvm_has_arch_private_mem from CONFIG_KVM_VM_MEMORY_ATTRIBUTES
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: aik@amd.com, andrew.jones@linux.dev, brauner@kernel.org, 
	chao.p.peng@linux.intel.com, david@kernel.org, jmattson@google.com, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: srb13b8tsxg6gnxsfzc1e77jptrbfied
X-Rspamd-Queue-Id: E941F180002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782260016-325944
X-HE-Meta: U2FsdGVkX1+hQBKGLqLKw4g8JY12TGOSsg8kttz8ANYtX6REzVZw/hqUBmwq4HUK/DJQPtm8Syi9taMAL7UY1vTmyLoLSVg45WqPTir2wkgTb309Sa33z+DjTVdfiyef3Qss+SVmnmCfQcBo6TIPCRlmRBA2IySDh4ig8JkG6YZHEp5sn8gLx8fxVdQqaek3Xzbva478QbpmRqQCmm63QrWzwvTdk9IFQKVQwqRGzE5znCGz1CcBrZ0enwa6nXzmugIg1X6dP+rnSvWHLVXEFiIOZTGULmNbv5ZvRhTdjmiCpv894d/iNrsmoEA1hsG41VJy8FioLr2Zq2fbUxi+BysAU0sMaGKnOx92Owi1NpauvCBuiWlN4V4b2gOXwxCbizCzR4yQ/mX146Cl5fi2sFqXOiyeXW3NB2wW1B0FRVzj5yd+4BKehoANxLRdIa6hJkrkjyj4aaVt5rtvH/kCZmNsiZK433adS4beSDPwV7L/apaZkVT/CvKb3Cdw/eg6RZIqJSs9yKBP9/9ttJM2iFkG6ZkT435adaluuemG7a3lTS2s/Mxm0bJ++uH3gXHZzhqDU7iALGYHx7FDVFz7lGa4+A2pSjSNYrDnMIroftu2UxhgbVPXxzyM8J8FrxynuY6hY3Q36dsiEgJKion9N7phhL+BnZCwf8RJtWeky0XohD7Tu4hpB6VjR35EI7VsBVLok/SRk24V8UjFFZVVV0Txb+EBEUcOT39iMDznIdzNcHh1RCGDvkbzVuBVqq8lNmONum7PFuYeDLlg584NDn+RxV1MfwF2CSresiH0fDf3lZ9/xNSEXvqg4erJweE7+4QvlGfYc2j3eLqgoqunMpvM4os3xaEeSMo1+6K/yJciDEBH0h1+zDojxxAL2IBPUd6C8w0gsY4nSt49BSsCt0tGWwhUAr6uR22Fkaa3Yk2HVInTcWvOGjGU40a0kIx/srjsv2/QJ3f0CJVVQ1q
 C41mt01d
 5bOxoNHr4tQsV8oT56EG3DXUFcmCEMIxdXayPwYFvAg+wyHK+Ms6dd9rMjWLPf5pEZGrbDKwxpgrV8VAMPCEK8WXSUXfOWvF2CYwFu/XzLnuaiMX9lWXaxWtgCVD+PSVftM4G0xd5Ub/PEGTiQYI0JjGBkKo4wtujibN6dWR2wQ2XhVkIVAGCqpLolqteWrM98SFFEX2/LBfJMpwCn6M1QmbBc2DZPXH94owjkSOigGoLycfDojPaQlfBrYZMVXECiSYs1W4Y/guPPTJUEtK+Pg+k+KHASPxON1pI08nkfNcAiMuUfzDjvcPd4BDfgK2fG5LQqjxuznuJE+2+kA7D5kNm+dLRn4tJVt8r3TStXslaPBUVnUVEUB7nCX5k7v4FitUt4FOZDp+TlP8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Binbin Wu <binbin.wu@linux.intel.com> writes:

> On 6/19/2026 8:31 AM, Ackerley Tng via B4 Relay wrote:
>> From: Sean Christopherson <seanjc@google.com>
>>
>> When memory attributes become trackable in guest_memfd, the concept of
>> having private memory is no longer dependent on
>> CONFIG_KVM_VM_MEMORY_ATTRIBUTES.
>>
>> With this, on x86, kvm_arch_has_private_mem() is defined if some CoCo
>> platform support (or the testing CONFIG_KVM_SW_PROTECTED_VM) is compiled
>> in.
>>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
>
> One nit below.
>
>> ---
>>  arch/x86/include/asm/kvm_host.h | 4 +++-
>>  include/linux/kvm_host.h        | 2 +-
>>  2 files changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 8e8eb8a5e8a6b..1bde67cf6eb0e 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -2394,7 +2394,9 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
>>  		       int tdp_max_root_level, int tdp_huge_page_level);
>>
>>
>> -#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
>> +#if defined(CONFIG_KVM_SW_PROTECTED_VM) ||	\
>> +	defined(CONFIG_KVM_INTEL_TDX) ||	\
>> +	defined(CONFIG_KVM_AMD_SEV)
>
> Nit:
> Vertically align the defined(XXX) statements for better readability?
>

Sean had this aligned with spaces, and checkpatch complained about
having no spaces before tabs, so I switched it to tabs instead since I
don't think alignment like that is officially documented either way.

Either way is fine :)

>>  #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
>>  #endif
>>
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index 201d0f2143976..d370e834d619e 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -722,7 +722,7 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
>>  }
>>  #endif
>>
>> -#ifndef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
>> +#ifndef kvm_arch_has_private_mem
>>  static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
>>  {
>>  	return false;
>>

