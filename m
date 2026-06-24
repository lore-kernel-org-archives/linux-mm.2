Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA7E3CDE002
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 15:12:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEB3F6B0005; Wed, 24 Jun 2026 11:12:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC2436B0088; Wed, 24 Jun 2026 11:12:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADAC66B008A; Wed, 24 Jun 2026 11:12:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 83C7B6B0005
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 11:12:35 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0A404165EE9
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:12:35 +0000 (UTC)
X-FDA: 84915147870.24.286FA79
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf23.hostedemail.com (Postfix) with ESMTP id 36BA3140007
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:12:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=u4P44qA2;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 33_M7agYKCBA8uq3zsw44w1u.s421y3AD-220Bqs0.47w@flex--seanjc.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=33_M7agYKCBA8uq3zsw44w1u.s421y3AD-220Bqs0.47w@flex--seanjc.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782313953;
	b=oKGhD5eaSw5G2HYf38+MeQ/5EGk23j3v9BQWU4Et0UN0P5NPxQzhMj/PRvpky4Y20Vs9sV
	Vuhe6S2JNXs3UHJa0VwAM0J/6AnJrUMxRNVhjPevA6YL8uarQdPUIs83CJgqVKfKKWklCM
	FmVXVPezA2xCZ2Yl25o/ktTWMvHFatY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782313953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r4Rgqs0dmpAmBtoUIzRDi3XnAOaTZ7bU1jnGrXxRY7M=;
	b=wKB9V30qyAFyUEyor+gJJDEJgM3U+4D/9uf/3Mx95QoFFQymz8iaRQsMalpmEib0FEquX4
	nYKX/Z6yNwgaAS93/4NvXnqk5Kvup3Kgs0EfRHLGvgB9R3cMW8Kh89iG9BSeEQNeHREz/d
	lteWtIteEiw7syZY5bVEXip93UvDZXY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=u4P44qA2;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 33_M7agYKCBA8uq3zsw44w1u.s421y3AD-220Bqs0.47w@flex--seanjc.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=33_M7agYKCBA8uq3zsw44w1u.s421y3AD-220Bqs0.47w@flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-8423f6247c6so1601903b3a.3
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 08:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782313952; x=1782918752; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=r4Rgqs0dmpAmBtoUIzRDi3XnAOaTZ7bU1jnGrXxRY7M=;
        b=u4P44qA2QrH3P4nr6/mVDkKD0SAYx1zRITe2NQ33NdgtsZONvmLek342M8P+lB6m7m
         S9aOT58HbeTZVT14YJ9VzklKDrOxpMfzP3EamWm1PLUO+o/uIqzKk9zetuAxjFRHiRAw
         LZahnGdb2NIzYsNNslk8fmct+CTt2S++HVRWmw4uPV5l9XL8KknpKzycL4UeSTKu1oQT
         UHN7Si4yPX/FRqfql1QqZbxrfTkTSm1Jj9dN0lUASRJDyfRD1dBhY9Rqclm4izC5/m1a
         yYyf9/oTv3S8x0NGpKf5Fj9xQjENgN4AL1ETUAt9yKfoy6u4xU50bbvU1YsPaFYJTjLq
         qZGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782313952; x=1782918752;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r4Rgqs0dmpAmBtoUIzRDi3XnAOaTZ7bU1jnGrXxRY7M=;
        b=e8HPmaje71froQPV6iSzhFlppqHQTeWZd0CAdLclp2d57EOt1jf5N9hxno/7X0Z4Rh
         NXTxaKUZsDhYD4wmgV71e2W+NX8I+Xrc69OlQzMJN+vCuKiUv1+CbvoNdiQj/7tn3RSP
         X23pzNSrzPmIfXsisgXi2Q9tF3kFOge36HNd5ZqeUDvkUeP+qS4hIceej1/5Fa2/V7/+
         hGE/u7CKS16l7wzS2o3krVveBpl9+V4e4iWNHgLmxKLzKPS3a4mIU2awmajnZew0aRCc
         FIcAtje9YsW4LLNGhIYx9rNrqllu34M5FSDsb+1iFC30urp/Y7KUSJX7G/h6nSPDnqXk
         e0Qg==
X-Forwarded-Encrypted: i=1; AFNElJ9sZXY1MpTAP8N53hf/eyWRAcXpGnegiqq6ql5qnBqF3ay3aFCHdeMQq2iVXQq8Xk7dNZhLawhKNg==@kvack.org
X-Gm-Message-State: AOJu0YwquUb1c05d0z9cMrwOsk28/2c7dRE2oOi21a2zmiFHc6Tz7MGm
	dQIc1G4yFGdKp7z+vxz21EX6RSNhG+F8TikUvMPCAKMdZ4KMM7Ol0KqsKZJUZUyWW75GcZH5WT7
	XdIYAaQ==
X-Received: from pfbjj5.prod.google.com ([2002:a05:6a00:93a5:b0:842:507a:6d57])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:b4a:b0:843:49f0:f5a0
 with SMTP id d2e1a72fcca58-845a2caa198mr4791522b3a.32.1782313951462; Wed, 24
 Jun 2026 08:12:31 -0700 (PDT)
Date: Wed, 24 Jun 2026 08:12:30 -0700
In-Reply-To: <CAEvNRgGF+O7r-YHqcLp-ZgoXTCbqjuUhpOdD5eE5w2wu3YYYpw@mail.gmail.com>
Mime-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-4-9d2959357853@google.com>
 <a21bfc05-787e-4cd8-89af-8579357e6a12@linux.intel.com> <CAEvNRgGF+O7r-YHqcLp-ZgoXTCbqjuUhpOdD5eE5w2wu3YYYpw@mail.gmail.com>
Message-ID: <ajvz3uywXwa36FOp@google.com>
Subject: Re: [PATCH v8 04/46] KVM: Decouple kvm_has_arch_private_mem from CONFIG_KVM_VM_MEMORY_ATTRIBUTES
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Binbin Wu <binbin.wu@linux.intel.com>, aik@amd.com, andrew.jones@linux.dev, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
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
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 36BA3140007
X-Rspam-User: 
X-Stat-Signature: 5tr7jf5n48eae6sj8bywp8xnh1ihak1u
X-HE-Tag: 1782313953-125940
X-HE-Meta: U2FsdGVkX19RGl3eIPNS5XxAwS0MGHjgCqaIKDfh4Mo3lgeZMm72c9w0vWAS4izdVWs9gR9PXBECA1Pn5PBz3PpAgbee8DONyQLNAnOlfQ1pzV7E0W6ysvtUgexbVGnrQzXXwzb9tLmznpfNPK8JQM3xVKu1pPjbWooVPcL/j9a3jCfE4aE9WXzMoL8cKVkWs9Mhqr0itN17HTqtGrzWEZqpY0sywtyggLWJgN6ka3hErPluHcX0+b2gLwrNhqQJNPeUkEtPcWxiPmxLev/t99PZ7NzFu2LZ9td3zbxjvdyjlKjby7G3xJBdajWiWuzBjlhFng9CVa08UHt3pY50LizFdOSoDijR2+GMeK9t2HO00HnQP4CaijOQRggvcjhIDCexiLhSgmi01cKCWOBV5MZMk3ndiosiG/PUXHn0WNEMNx2pGQKbXGRDJkUifopUMxUB44bxVP6DvfiF9U6NrfZp+7HXXvamUrOmPhW0YwyrHzvY7yhVyhfKMgiu7WffCM1Q0pNmY7SESHoTv0DaHdDTEkLPnjaNxjrGuMqZGO/Tu+i4cnsePM6bP/fJQihNzoPWsgdSesk92oHMhS+2OtuttEuv7+Az6Au4I/cxzlA0S5rbvzw9ncpJ+yuElSwUTWEOylR5mhVcO+XniEbatUy6Uhsxy2Xd7QU1tjds5A20hoZfioD20GlCGI+/fOi35PEnCA1mpy+coVquqhFAFSYL+c6PV/BjRqOI7hRV0UML3S0c5ADrySXfCOhqwEyZ10bGQfGEHi8Mpwo1/2idKCuukyCBjHQ5OUm65QzvHCwnMLPDSHBEYE+KUpc0FvN9776f1qxenR1OuGNEn1sfSHSS4UeJ13vXhppsx8XGw1BXAkh4+DoC5BHFhgzX9eyLMUPmhMSgJbiedo2hs3/4iU8lWSy36pj+3lRQo9EdsNC/XdFNbo8tLdiwrAaiFDq15mpYVJT7/h+N4dtlIyv
 ia8MlP/K
 /+FxemAY9v74FzC3vLQLIkWhhDaakFgws+2+ppuTI3B0c+jOcyuL0GnHfcEI8r8y31oDNZdIwfwVcVX+KgJ4q4+JFzKVhQaY5Vhomira7NLt3OOjIeFZnKztZwuh5/4egzMmS1pFcI/FeZAFWv88N9r6Woz7E8LAftIlaPo72WXtMJYHOSHy7hgvPG9oFJvfzCfU7EOjtYngKAKv+tRxoDMeGdSm2VvxIMavD8BsEpEe3EvVPHyJ4bSuxBL8GdyRrkisOCQ5++cNq5Amt3HpYZUbiwVBNo1rwDPZqBYgMeF/r9oJHbm9PiD6lr+2iNICwQzWvWPo65iFm3GUhRaxABvd7TGBIzfkfLHjoLqAxPiv2l5NYztHno/j6CgHMK6e+Lsjhr6vQ1ItKUSGJKbfEJ4qkT+kyH+EGJ2MOu8YyNBqFejg7K5Cv8j1k37WBHK326X2RcVDgpNPXJzen76HMoXjCttjQZ+RYa6ElUxXeQjaP7QeXreZQz/wjZUquqXJAXCtgRsDRr7rN85u7JfNG9uo++n3HKTh9/AQBol6qr0uVfE42NzHf18jjrIwdXzI3p0j0p6RdC1ooOTrIrV1gG97uw0LZWCzH9xmCcA1RoQKovNVQynV/QHowu3g4//lK5OtK5YTwKY7RsWnzw+JCeLZpOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 23, 2026, Ackerley Tng wrote:
> Binbin Wu <binbin.wu@linux.intel.com> writes:
> 
> > On 6/19/2026 8:31 AM, Ackerley Tng via B4 Relay wrote:
> >> From: Sean Christopherson <seanjc@google.com>
> >>
> >> When memory attributes become trackable in guest_memfd, the concept of
> >> having private memory is no longer dependent on
> >> CONFIG_KVM_VM_MEMORY_ATTRIBUTES.
> >>
> >> With this, on x86, kvm_arch_has_private_mem() is defined if some CoCo
> >> platform support (or the testing CONFIG_KVM_SW_PROTECTED_VM) is compiled
> >> in.
> >>
> >> Signed-off-by: Sean Christopherson <seanjc@google.com>
> >> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> >> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> >
> > Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> >
> > One nit below.
> >
> >> ---
> >>  arch/x86/include/asm/kvm_host.h | 4 +++-
> >>  include/linux/kvm_host.h        | 2 +-
> >>  2 files changed, 4 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> >> index 8e8eb8a5e8a6b..1bde67cf6eb0e 100644
> >> --- a/arch/x86/include/asm/kvm_host.h
> >> +++ b/arch/x86/include/asm/kvm_host.h
> >> @@ -2394,7 +2394,9 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
> >>  		       int tdp_max_root_level, int tdp_huge_page_level);
> >>
> >>
> >> -#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
> >> +#if defined(CONFIG_KVM_SW_PROTECTED_VM) ||	\
> >> +	defined(CONFIG_KVM_INTEL_TDX) ||	\
> >> +	defined(CONFIG_KVM_AMD_SEV)
> >
> > Nit:
> > Vertically align the defined(XXX) statements for better readability?
> >
> 
> Sean had this aligned with spaces, and checkpatch complained about

checkpatch is a tool, it is neither omniscient nor authoritative.  And for things
like this, the *entire* purpose for rules/guildlines like "no tabs after spaces"
is to help ensure the code is easier to read, e.g. doesn't end up with wonky
formatting when viewed in certain editors or whatever.  So, ignore checkpatch if
it complains about formatting that is visually superior to what makes checkpatch
happy.

> having no spaces before tabs, so I switched it to tabs instead since I
> don't think alignment like that is officially documented either way.

This exact case may not be "officially" documented, but the general gist is in
Documentation/process/maintainer-tip.rst:

  When splitting function declarations or function calls, then please align
  the first argument in the second line with the first argument in the first
  line::

And there is lots and lots of prior art on-list (from me and others) that is more
or less as good as official documentation.

> Either way is fine :)

Please restore the alignment.

