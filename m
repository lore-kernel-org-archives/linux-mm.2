Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB994CD5BA4
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 08:44:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A57B6B0088; Thu, 21 May 2026 04:44:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 055BD6B008A; Thu, 21 May 2026 04:44:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E601C6B008C; Thu, 21 May 2026 04:44:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D4C686B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 04:44:05 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 785494056C
	for <linux-mm@kvack.org>; Thu, 21 May 2026 08:44:05 +0000 (UTC)
X-FDA: 84790789650.01.07226BD
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8BCEC40002
	for <linux-mm@kvack.org>; Thu, 21 May 2026 08:44:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kZs5I9Tl;
	spf=pass (imf11.hostedemail.com: domain of tabba@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=tabba@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779353043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1kiAAPdqT4PYHNduYcz+D7nl/8os61F/7CmhrRm2X2M=;
	b=wDDr6J9Bp3kaHQ75CKxhyp/jARYb93sK4VDmjPOGVqNhTwTjDIZ6NKLarh+07ncI1ZuOwX
	5tK5JV3lO9Y88rSz4LiX/ueDYwPkXMzLfSZ6I40b7emghSwVhf3ComWhiXoyLHjNaaFTZm
	LXAbJBVn9QeCZtoRDlxJ44GTFTX+lHM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779353043; a=rsa-sha256;
	cv=pass;
	b=HFpboeB5tEuTFSRAvG6zFfcZft9QMo9sOhbPeER3iiEGgmcoxwwUbXdsVY3NSyEy0tUUbY
	Yao/S3sx71ek2v146WMvy9jxWY36FRLEFVsSwBSKMGxG+VphqDI189mY/XI4WyJstzLsIq
	enUG/Kq0ndTFd4fdp6P2hW5GwrDFJhs=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kZs5I9Tl;
	spf=pass (imf11.hostedemail.com: domain of tabba@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=tabba@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-50e61648f10so4211cf.1
        for <linux-mm@kvack.org>; Thu, 21 May 2026 01:44:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779353042; cv=none;
        d=google.com; s=arc-20240605;
        b=dDJVI8nCOCwO/6u/s2PgaC3tUOPmNz0dnKX8XXcdjA9Hn9HnCiBieRH1c1coIZJkyE
         xxMdsIFm9IFfbC5HInk7OLh+Ee/B+kbnSEunQ52ln58A81uJGcDnJD54dsB9DkEf2M5z
         J4CjjpEkv3tkoz6EmzIOAmpU0Gcd4qBrkNupboR6ukDONgFW/qo72vwYkNLU+QC/f0Jt
         K9pWW3ZUTTRvmssyPCbjP58BykpFywECKMPqOLemgvTAl2o288bgIJBXqiGhtHWm8FAt
         FUjBqp2dEmlojcggGRws7bDk8pGPrXBofH+sR5eDb/L0vpwdr3ylGtbuBBTz/obnWntM
         GsHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=1kiAAPdqT4PYHNduYcz+D7nl/8os61F/7CmhrRm2X2M=;
        fh=CfgmeGZiws8iRUz+7SmffFTz4KhpyNI1WqeFbuJw3y4=;
        b=JgS6R10b75nEWgjWo29HSLbkeOIp2OeeWh/MDTOUbnYnTeQ/btqXTFIv23SJSFkdfZ
         QP/12WhBWckZkBmS54X6Nx6JSC8bEorPPw5YEZW7tHM5gG6rVQl5vNCiZeciXYZTn9r0
         1IHyhMtNMtSf+PSlYah5YjsCxjqRmQnvK6UrVKEHYSqNFyM0zJ6Mb03cVm0XQXGE17+g
         oN81pOMeEH7pVl9/h5MKMGGmTQTqoGKtRj44fze+b4/2OfknORp84NnWhwO/YoRa1Lqd
         Mq9hQfFvI2JOOYtm8cbTM0l86K70cjyra6rVAnf8yt2RXM1tnzG8lPLUTkHvStWYIidD
         ya5g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779353042; x=1779957842; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1kiAAPdqT4PYHNduYcz+D7nl/8os61F/7CmhrRm2X2M=;
        b=kZs5I9TlDvYKR6QspXlIflJPxcvVnK07+G6bsoQCoshU7xFkTJ9RnDI7S288LEEKpA
         SoJfctTukJ0PL8H4BAvqpZqZu9lsXJMtm3Q0+bRc9TIIJuL9ZN5NErbUUBqdZVOy540h
         u9Y6o9Q9aUkjrgCgVkZxNhx6qJjIilhJC7s9d3RD8+YWC/s3ilMhhh2CbDsHwfFGqEbq
         vqAPF/k47ks9jgXqaFH8KOPAT9n14RE26EuolLdoiJxGYyl8WB3U3oFwfgLiM+1LjbC3
         x3TKwdIAi+it3Nq1dmCJIcl3OjNQIlUFYN8Ko8sA8Dx0ebjrEltan0pmdJ1MjrlGV36R
         pz6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779353042; x=1779957842;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1kiAAPdqT4PYHNduYcz+D7nl/8os61F/7CmhrRm2X2M=;
        b=n9xoMAGSs3Y+N0XFDFchTReog6M6nGRqTv9FFlKVkOnMQ4Kcwa8MJPI8Ky/uzloZEU
         IszCeyJ+OjvtIPKFjSWCwdt43fK+P9DUJ1XgYWrseZ0bylxDt+4RYXKXxs5rlkWsjztS
         aIKl07AvTCb2yuMu6r2h5SQazy0JRuaGAYbJXAZluenkjgSqONxGgVhaQakeXk0U0D7V
         7DalzjHCV+dItV2c5YEHNdfiz8c6QQvjO4AwL7mj7HdIf+Ug8KzN/CofYY/26prwUfFA
         BWT/WkzVw7vNk+zTKV/34Cs5QJqT0IW2ccdycWRK52Bagv47J6ZQgUckqSJ0WjKbvINs
         EAGA==
X-Forwarded-Encrypted: i=1; AFNElJ/mco8/QzhoFmgPy46vPiiIXE8US4NzheqlyyZ6tRP6I53eo3TfsoIUklqrCk1PqZjaaktS+svGhg==@kvack.org
X-Gm-Message-State: AOJu0YxzBATe75X3b4RdhfPiTRHnBkjvlf1SBHkPAp4zdyw9/sUj4Xdh
	mi6EetEIzH/iFmcncFTlyDEUoWOxq05tCvSKEhfGGRE3SXkDi9yOac4u0+/dov0gGZJuKaQAieV
	yFaQoGCZXMye5H+PBFc8HbDt/WO4/JAu0MwRKD23w
X-Gm-Gg: Acq92OEYSJml34uyV+4BH+XyTKb1AEfjGR1SDxD7PROhRtnEOcXjazDsPigICo4hw1a
	Bof5xTElsSZZO54rYOENXEwWF00hDyN0szm/jyLQL5nQD8ac4pZrbxLAkRh03UXdWC7C7R+DatL
	QvhEtbtgTAKAI8KnXTRdXuTzLUwvqWieOozQ82AVAjvqZcoQ/OrXiisTVMOOrbVZJqtXObbfRJm
	te25d4IAmxnrKmC7zUPGp8R9lsCHnDfSh7bcSQLFGUuIy18RZWJlnBb1YpAoZ0+8cimLlmai/8y
	fDdJE5GTyF+tI1Y+R7M=
X-Received: by 2002:a05:622a:4cc5:b0:516:4f62:85e8 with SMTP id
 d75a77b69052e-516c552713emr7157791cf.19.1779353041810; Thu, 21 May 2026
 01:44:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com> <20260507-gmem-inplace-conversion-v6-19-91ab5a8b19a4@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-19-91ab5a8b19a4@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 21 May 2026 09:44:00 +0100
X-Gm-Features: AVHnY4IQ5gCtMUjytcQydV2ClyWPBKSROIDG9-iOU8lHVPfTjxaIUJeWGPDUkE8
Message-ID: <CA+EHjTzu=28Sr3=9A9LmJEGz0tBEDbU9taznVV5kdL7s8Nw=Jg@mail.gmail.com>
Subject: Re: [PATCH v6 19/43] KVM: Let userspace disable per-VM mem
 attributes, enable per-gmem attributes
To: ackerleytng@google.com
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 8BCEC40002
X-Stat-Signature: rjibtx4at1xs5kaht3tpwyi75snt988a
X-Rspamd-Server: rspam06
X-HE-Tag: 1779353043-94907
X-HE-Meta: U2FsdGVkX189cI6h2jVss1Y4x6AZ6ANkwpkmc7WQxk8jJzyr6563YryCh+xSQ4sFSzaO3lMm4QQnqkMPSZ4xZDHRcjV5R/qnVNxkfbkCWdhT2xYrx0ih1TuO5555XE7EsIxFfvQLsKsNeUSGC8geCpc8b/jwmhppgZCNIIvTcYdb10a/1gKMDjcYRfiuoSttHtWLO+q5UYKMe98lBGHrcSCAiJFeFwv/p8B45jz2ud7Mm25dz9SmSu5TZIVXHY6c65CaSxX7Dd/UEqCUYY1yPpN9UXoiEZGB7/0fHEOQD+gpDMMgAZfLTUpSB4yTB6jjgbPaQOGZy4KN1PC7wuVD1NDtBgtGiTN9H1+MKIebI0YFkjK3+v2Ao5fg8xKr+Ka3LbVgUH9keD4x3+sj/WbzcaBQ3RZ8DKQcKcIvEYsowd7bC2zDqWzanZEcAnQA0ERZkH4iH3WRE2XNYKMqX8hC4zmxydAso1qQ1rLs7+IG4Z684tD32qBrhpEIkcge1j3mLT+Ze1LVSIcT8AwmnUMk0k8lbYGgwIvZjCe5KdQDGXVBMRKWzkQGmTgVpbcjoVLvB0xFhKYDrPjk1yYwok8et8OSlTXp1wgFFJj5nJMUmVnIcLAhxcQ5VaqVZjBGO77m3nsCpT5BCLmRcwJl22ENRdd4vdO/UWZQy1GYfbPDezLM4ZMrOfyJw8xTVFBI1wd7FrPrYlab/ScM4fMRH8rvTBTKQH0OZ46ZlI/uPH1Dxy1xEzg9hsVpnxtG50thKOJLvJ17PEjNaEQaRs5lT45z2ASK3jd7X6QGwcMR01kM5qa1t1dBrUoDWNNUx7aOoeKs2m6mA+4Dl+oXfMLc+gB8SLagsgifhV3s+F61EdI9RUxb2fsT3hbLVTuhKD2rAu0qJ6JTFlSVLAuAm9elLlK4e7htkbvoWqx0sLKXSLblEHfCAkdv6DMB700cUXX1fB0p2rKZUvX3YDgYbX/gOGx
 hJ7njpKs
 lVykQMFfhp9iQSIGl+mZ6ONLmYaFA0hbZVvx+HMlYNCE4OkT32Rmb2hRjYzxBMitdu4sMHDaVS+CEM4QdV0s0NjoKorw4ShOwWB/zVTsczNR64xyewyyDQmmk70EHWffbOvIUuLPp4o2TNfLIDCJklpvQXuyxniNlwev9uiG8PbawbzzOwaWBYyDiIFzfEpTlBp8GQah3rZ4q3/c0Navkpu3vD5ykcrIQUNQaoYFxo8ZRkAPTs8b/nT3KBpZjnt4c0R2THLXS4UQtxNbFGb+cGX86EvAbwSi84pe8/NoL17DOJK4smt4IfxWm4BVLc2RQVgPSMR3+Nw2Sruo0EpCu7E9PMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ackerley,

On Thu, 7 May 2026 at 21:22, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Sean Christopherson <seanjc@google.com>
>
> Make vm_memory_attributes a module parameter so that userspace can disable
> the use of memory attributes on the VM level.
>
> To avoid inconsistencies in the way memory attributes are tracked in KVM
> and guest_memfd, the vm_memory_attributes module_param is made
> read-only (0444).
>
> Make CONFIG_KVM_VM_MEMORY_ATTRIBUTES selectable, only for (CoCo) VM types
> that might use vm_memory_attributes.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Config files always confuse me, but Sashiko might be onto something:

https://sashiko.dev/#/patchset/20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4%40google.com?part=19

I think this partially goes back to commit 6, the one I flagged
yesterday. But also adding "default y" to KVM_VM_MEMORY_ATTRIBUTES?
The default value should at least fix this issue, but I'm not sure if
it would cause other problems...

Cheers,
/fuad


> ---
>  arch/x86/kvm/Kconfig | 13 +++++++++----
>  virt/kvm/kvm_main.c  |  1 +
>  2 files changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index b6d65ee664d0f..8b97d341bd33f 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -82,13 +82,20 @@ config KVM_WERROR
>
>  config KVM_VM_MEMORY_ATTRIBUTES
>         select KVM_MEMORY_ATTRIBUTES
> -       bool
> +       depends on KVM_SW_PROTECTED_VM || KVM_INTEL_TDX || KVM_AMD_SEV
> +       bool "Enable per-VM memory attributes (for CoCo VMs)"
> +       help
> +         Enable support for per-VM memory attributes, which are deprecated in
> +         favor of tracking memory attributes in guest_memfd.  Select this if
> +         you need to run CoCo VMs using a VMM that doesn't support guest_memfd
> +         memory attributes.
> +
> +         If unsure, say N.
>
>  config KVM_SW_PROTECTED_VM
>         bool "Enable support for KVM software-protected VMs"
>         depends on EXPERT
>         depends on KVM_X86 && X86_64
> -       select KVM_VM_MEMORY_ATTRIBUTES
>         help
>           Enable support for KVM software-protected VMs.  Currently, software-
>           protected VMs are purely a development and testing vehicle for
> @@ -139,7 +146,6 @@ config KVM_INTEL_TDX
>         bool "Intel Trust Domain Extensions (TDX) support"
>         default y
>         depends on INTEL_TDX_HOST
> -       select KVM_VM_MEMORY_ATTRIBUTES
>         select HAVE_KVM_ARCH_GMEM_POPULATE
>         help
>           Provides support for launching Intel Trust Domain Extensions (TDX)
> @@ -163,7 +169,6 @@ config KVM_AMD_SEV
>         depends on KVM_AMD && X86_64
>         depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
>         select ARCH_HAS_CC_PLATFORM
> -       select KVM_VM_MEMORY_ATTRIBUTES
>         select HAVE_KVM_ARCH_GMEM_PREPARE
>         select HAVE_KVM_ARCH_GMEM_INVALIDATE
>         select HAVE_KVM_ARCH_GMEM_POPULATE
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index cec02d68d7039..ba195bb239aaa 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -104,6 +104,7 @@ module_param(allow_unsafe_mappings, bool, 0444);
>  #ifdef CONFIG_KVM_MEMORY_ATTRIBUTES
>  #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
>  bool vm_memory_attributes = true;
> +module_param(vm_memory_attributes, bool, 0444);
>  #endif
>  DEFINE_STATIC_CALL_RET0(__kvm_get_memory_attributes, kvm_get_memory_attributes_t);
>  EXPORT_SYMBOL_FOR_KVM_INTERNAL(STATIC_CALL_KEY(__kvm_get_memory_attributes));
>
> --
> 2.54.0.563.g4f69b47b94-goog
>
>

