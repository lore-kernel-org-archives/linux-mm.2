Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82834CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 12:08:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D19BA6B008C; Wed, 20 May 2026 08:08:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCA366B0092; Wed, 20 May 2026 08:08:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB8BE6B0095; Wed, 20 May 2026 08:08:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A76A36B008C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:08:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 31F3312027F
	for <linux-mm@kvack.org>; Wed, 20 May 2026 12:08:56 +0000 (UTC)
X-FDA: 84787677072.23.571E34C
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3EF9CA000B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 12:08:54 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aFDl0dvG;
	spf=pass (imf15.hostedemail.com: domain of tabba@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779278934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0e+G9jJA0Qdw1DFvqZm8i4ZRk5ML+liKRoq2xKwcnGc=;
	b=LoYhgs7w+KOv/cmPs6H0WQhgMvhroGM/jfNiKwJUA7L3Z/g3dr1VkGwUcxDMnmkOf/pHRk
	qa49Ji9D8vmYJkBzZUw14PhmN8GqXGYYQj/mfsdLpxiMaxD1sKU7U0eg9d2BJT3o8Ta3GZ
	qAh2E/S4MaVcC0yj/m8z4/gE9PWWmUo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779278934; a=rsa-sha256;
	cv=pass;
	b=qqlUcKpXqDk4BBTg2m5Vm83XKVRhOcLRzuS0jZjcYuJEsd3fliOhBLKX/TOOa0SLY6/q9p
	adI4HfTjqK0QKP+yHqGhETI81mIMLI7xwznExk2BY+MniwQrKMw8UDH2tcGuD+4VWequJP
	WbFojNlsrDjqBC0/fE2xnJE4eJ9G/5o=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aFDl0dvG;
	spf=pass (imf15.hostedemail.com: domain of tabba@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-515548f390fso601cf.0
        for <linux-mm@kvack.org>; Wed, 20 May 2026 05:08:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779278933; cv=none;
        d=google.com; s=arc-20240605;
        b=VLhwCwmWCYX5ryLOD8bFs3pqsUGEIsLFrVEFdeqcPzV6IOdP4i5JIGdlgZeolcS/uO
         WJiV0puGXOnf9NkWP9puhX1R5soqL2C/gNw0Bcxdqwc20wkzBrwZg757AfBbjlM1JHLW
         mI8QpVVt67X991bUu+/Dx9eCMWLBREew9PoBrEEYtX8PFacLZt/OmD+NSKG2cdqXDYl0
         VnAkoXroLz0VB4x+AX47xLLl72ZjPoyS/bJhkXSNBcWizZjj4oXQxbzyTFrEhWj5PtJv
         tHY843RlSWDuQ6a0RINJ3+DmPkI9j8DsBw/hcgcpF/jftri2Vz8GuNYTKHffpRNaQulL
         GIbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=0e+G9jJA0Qdw1DFvqZm8i4ZRk5ML+liKRoq2xKwcnGc=;
        fh=rCjY7bupDwJLB4F5mrmu/YbLIC2Mmu2smfQPT1Ww9M0=;
        b=R3H2zRTaqfHC+jkUnmKFkUg0bXogBUtMQ2WsfuwvpUds8DIuYOgt84hhrza1yAiQpP
         tvh/W4FoOgF1IUiy87pTG/t72EN1GBF0aB/AfwwI3jMu/1JIQAwlMF2hUlL7aXsW+1UI
         Z082UVUMkOpNSMrHLA+ytzZlZojhgx9EortxEluxETPC2Jfh7YuLby8r8UwCBxKmnX2p
         XhphKEcRs3mmn4NvosEDEjnuBMBeiGEcSEkjDy0Q1Gk98agXTXEikK5QycWedmjtgAip
         BArtyup0hcehu7cdmCyI/ib+XULU3fOC4Z2APQMJ2c5eKbqn7yk6eiYDskOnSdq3UabB
         tmvw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779278933; x=1779883733; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0e+G9jJA0Qdw1DFvqZm8i4ZRk5ML+liKRoq2xKwcnGc=;
        b=aFDl0dvGW+i1mMq9TJ9Zu/eUOi0dLeriHYsKJJKAshbj+wehf3I/Ruv+0CoKtu+2Zo
         LwftXZSp8U2q3S6de653dwcW61VAxvSf5X6pb0gWXdBpchjq60NbF/9XFASbL5fvpbDH
         lTKBHPIadye2dK2xqve9tM3bwZDjtqYRZiVSz2sok1wXdyc9J672tORLjSScoT7htkDo
         y09uMlbT5l5LtG2UNq1m3BA/g675PuMM6tNFm44WOlG7pQQ/0+GBg6UebhfGBQlnTIPA
         RO+fp52Abd4Tdujf0KUZsGWNSO6FWfmqljeOg1mVzTwZk+L8hCPRrM7xrWB+63cX/a9/
         xUCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779278933; x=1779883733;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0e+G9jJA0Qdw1DFvqZm8i4ZRk5ML+liKRoq2xKwcnGc=;
        b=Mtes9vkl+19hEV1ZyR8NZdD0wt5+mQb2dm0N9blo50uheWcu3fG/DKhwaCknn1hCKZ
         MrftGpb1p0D1F/zYWOcmuzza/Ka3KOdgzerlQFL+DDH6VYUT+lsJZH32nyO03hUcpaGM
         YXWtvPzn0c2sC3rijKRq5kmbDYz+bMOf9k96M2lNKYelpC0opeT/GUZnhH4THy8ZDCQm
         dfQkV4Ni7wLOwTUN6a5q8HcNZSKjD2fUje3BcoJg5dDvbwlGg/4fwZhW7RqdyOiQOCJT
         03GDesjqVZPCPKxJlUp1mb+XxQQE9QqjfEoZjk4pOlggja1QUc+hCfrw5HZbsb9Bcgb5
         V1cg==
X-Forwarded-Encrypted: i=1; AFNElJ+b4iBcXBB/gJpF39IL4RG+PTWQEN3z/9BoUHIVrpJn8jcNmyztZNbcGg+42qSDgeVs/rNZ99+HTQ==@kvack.org
X-Gm-Message-State: AOJu0YzAH0us9uruUajc1gJFzVIa0CKRC37Ch+jxLgwI+5Lo/k+oRYcL
	ir9ll3m7cQxUlv8hpa7yza+UbNYkNm1sEVvOfCYwV8zp5BWkuovPjILSkGB4kNrBPo6Vp26QPEp
	vZxMWdytBcdaEjw7JNr6SpdlwkZ5ozKRnIAC/6GdV
X-Gm-Gg: Acq92OEb+o7Anwu3gONYrfce/vZwbf0sjzsJC0/vTr1dnQBDr2OixYUJjwbZWh7ZyYn
	ZqX1jJ0vZd/FsG4+omxKuo3WWuqOSwGA/cueIBhQc1Yjomzfxq4Zem+qYDvk2tYbaPPwCnYhqqI
	g2jsV7bRSrNa4Qy4uHtpNOGMtNFuZi9fymsAOnhiae/uOqEbDdXMh8oBQ9kCECrbz4q7KAYl5bs
	KoqD0kUBoyeDp+mgdyZQj7CmJK72shIlC5/zugmepX3SDAGFYwXrproPfXxvpL+fQRUFHIjcMaF
	cL/Yrl4iQ+lJRZZozr0=
X-Received: by 2002:a05:622a:d04:b0:50f:af60:3496 with SMTP id
 d75a77b69052e-5167b5765f0mr39671891cf.1.1779278932741; Wed, 20 May 2026
 05:08:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com> <20260507-gmem-inplace-conversion-v6-2-91ab5a8b19a4@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-2-91ab5a8b19a4@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 20 May 2026 13:08:15 +0100
X-Gm-Features: AVHnY4KBKfgyi_eBxWBlexdsB2vmcgOHdCyR81rdHfnvKJlVZGLuwL2FE3zd1TQ
Message-ID: <CA+EHjTwnMMbqLP=NFjM-FKYnvdzxi-z9Q0oEenQEy=WPcT5gZg@mail.gmail.com>
Subject: Re: [PATCH v6 02/43] KVM: Rename KVM_GENERIC_MEMORY_ATTRIBUTES to KVM_VM_MEMORY_ATTRIBUTES
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3EF9CA000B
X-Stat-Signature: jypyrth9dej9n3ocjipy5t4h7yuba8dg
X-Rspam-User: 
X-HE-Tag: 1779278934-296111
X-HE-Meta: U2FsdGVkX1/pZMDYxIEzFYFVg9VRc8+WzBhkX0VoO687SJeC62SAlaowAK5CkTzmK4BTdZzr8/hJ6BOngSmrP2DuQk/oaHIoPcNo8sjR5gOWw+eI8bdvTcNUkeTN+rxjZ3ahSE7GwZBUVmVNAy3eXYHZa+/rFMUizUn20GnZdI3hVgY4rUBAzmkyJLn2vKcxUSb8T43+ENyDzMcavB4vuMihmuOT0tfHuOE8Wu7yn0YhQCd0P/rnmJUEv8xPW++z0xfMSZiuusyp2aDWotqMNOISM/9fD1aTSU10U7L0Y6ouzwJaoZqtibQmMdLG12mZ/44CALx+fqLQpBoOfMqraDe53kGGXGX2RxmGREY/HAY01+GJ6vOfabhTM7ywYxhCBNhs26Iaqh2APd1bQHHROUJWlMlpfwXsWnyy4f/Ca2v+hFZ6F3Aur1SiH9b7RdNBrI5mzHouof8JE31lb0A5CUrClYWWm/6/jYcWb8sD0mYCeYR44ogBOU9Q9vjPiwBvI0hT5EoxT4uDiEXiDi6EZ3ZJ5sE53kJBxSSEzFtySsuhb3hUikRfUCN5gG80iXGzAmj4rfldcJUv4B5q2cjtaLDX0/MMshEWcjn3pLWal6wrBR0vFIioAEtgMScoVeVwmIsYj7WGgW/DiMOmZKBh/5p2EX68DThDS0yj5YbXFxAiweI2ZjgWeLO6yFex4CSs74YGct3WEMoWeaiigDEbAsbG/5gMUaooG/+HygiMtNJwgpAkbB108aBcHQUFQwR3TMJXXTG+WnPygT7QZr0nisgdb4yqJTITDvqEsSCvcJqxBySLWOcd/vdKc6pw2G6rjoM3Vd11frJTVc/JEyMX0Kp3fhtrcM87Qe6KX3Cy+57ISAfs93XFsmaqRlUuTL8zhHcfANHy8hdLMC3EZG67o9RHa/r1giNlHmM3465kSuWRe0WJL6WKwwdqJJW8P+VLxDhfAfLI+OvBKm+510B
 L3GsBUvf
 d3Jgu4pVOBBrGP4vlgNOVkxxDSH1mnY3q8xnnwbYM13ZZwStgBL9iThNwaDkMZL4R/ctFJk5mLbGLe84ZwBhAyTn0D9cbwe81D7vX2YXUxJMDnSanFJa8P69RN3Y9df96BK2Bco1HB9m/LhF475zZ42DtezTSWe07Et4d0yKGji9Cwc/xstAC5el9pRG4TmrNnkC89VbpvWkLhANSO5oDXjI5Gcr8+LBDyD1Iey3VWz+XxhCZ45bD0DhObq3CxzCWPpBACdRC9MSGDOrAwWcnYz5AMtXyaO27b1GDTQ8mjVNTjUaT9yY/Jz+bjZA+cN06YsvW6Pqug0w5vBU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 7 May 2026 at 21:22, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Sean Christopherson <seanjc@google.com>
>
> Rename the per-VM memory attributes Kconfig to make it explicitly about
> per-VM attributes in anticipation of adding memory attributes support to
> guest_memfd, at which point it will be possible (and desirable) to have
> memory attributes without the per-VM support, even in x86.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


> ---
>  arch/x86/include/asm/kvm_host.h |  2 +-
>  arch/x86/kvm/Kconfig            |  6 +++---
>  arch/x86/kvm/mmu/mmu.c          |  2 +-
>  arch/x86/kvm/x86.c              |  2 +-
>  include/linux/kvm_host.h        |  8 ++++----
>  include/trace/events/kvm.h      |  4 ++--
>  virt/kvm/Kconfig                |  2 +-
>  virt/kvm/kvm_main.c             | 14 +++++++-------
>  8 files changed, 20 insertions(+), 20 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index c470e40a00aa4..60b997764beef 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2369,7 +2369,7 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
>                        int tdp_max_root_level, int tdp_huge_page_level);
>
>
> -#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
> +#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
>  #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
>  #endif
>
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 801bf9e520db3..26f6afd51bbdc 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -84,7 +84,7 @@ config KVM_SW_PROTECTED_VM
>         bool "Enable support for KVM software-protected VMs"
>         depends on EXPERT
>         depends on KVM_X86 && X86_64
> -       select KVM_GENERIC_MEMORY_ATTRIBUTES
> +       select KVM_VM_MEMORY_ATTRIBUTES
>         help
>           Enable support for KVM software-protected VMs.  Currently, software-
>           protected VMs are purely a development and testing vehicle for
> @@ -135,7 +135,7 @@ config KVM_INTEL_TDX
>         bool "Intel Trust Domain Extensions (TDX) support"
>         default y
>         depends on INTEL_TDX_HOST
> -       select KVM_GENERIC_MEMORY_ATTRIBUTES
> +       select KVM_VM_MEMORY_ATTRIBUTES
>         select HAVE_KVM_ARCH_GMEM_POPULATE
>         help
>           Provides support for launching Intel Trust Domain Extensions (TDX)
> @@ -159,7 +159,7 @@ config KVM_AMD_SEV
>         depends on KVM_AMD && X86_64
>         depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
>         select ARCH_HAS_CC_PLATFORM
> -       select KVM_GENERIC_MEMORY_ATTRIBUTES
> +       select KVM_VM_MEMORY_ATTRIBUTES
>         select HAVE_KVM_ARCH_GMEM_PREPARE
>         select HAVE_KVM_ARCH_GMEM_INVALIDATE
>         select HAVE_KVM_ARCH_GMEM_POPULATE
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 892246204435c..a80a876ab4ad6 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -7899,7 +7899,7 @@ void kvm_mmu_pre_destroy_vm(struct kvm *kvm)
>                 vhost_task_stop(kvm->arch.nx_huge_page_recovery_thread);
>  }
>
> -#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
> +#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
>  static bool hugepage_test_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
>                                 int level)
>  {
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0a1b63c63d1a9..1560de1e95be0 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -13625,7 +13625,7 @@ static int kvm_alloc_memslot_metadata(struct kvm *kvm,
>                 }
>         }
>
> -#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
> +#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
>         kvm_mmu_init_memslot_memory_attributes(kvm, slot);
>  #endif
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 4c14aee1fb063..7b9faa3545300 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -722,7 +722,7 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
>  }
>  #endif
>
> -#ifndef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
> +#ifndef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
>  static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
>  {
>         return false;
> @@ -871,7 +871,7 @@ struct kvm {
>  #ifdef CONFIG_HAVE_KVM_PM_NOTIFIER
>         struct notifier_block pm_notifier;
>  #endif
> -#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
> +#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
>         /* Protected by slots_lock (for writes) and RCU (for reads) */
>         struct xarray mem_attr_array;
>  #endif
> @@ -2528,7 +2528,7 @@ static inline bool kvm_memslot_is_gmem_only(const struct kvm_memory_slot *slot)
>         return slot->flags & KVM_MEMSLOT_GMEM_ONLY;
>  }
>
> -#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
> +#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
>  static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
>  {
>         return xa_to_value(xa_load(&kvm->mem_attr_array, gfn));
> @@ -2550,7 +2550,7 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>  {
>         return false;
>  }
> -#endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
> +#endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
>
>  #ifdef CONFIG_KVM_GUEST_MEMFD
>  int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
> index b282e3a867696..1ba72bd73ea2f 100644
> --- a/include/trace/events/kvm.h
> +++ b/include/trace/events/kvm.h
> @@ -358,7 +358,7 @@ TRACE_EVENT(kvm_dirty_ring_exit,
>         TP_printk("vcpu %d", __entry->vcpu_id)
>  );
>
> -#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
> +#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
>  /*
>   * @start:     Starting address of guest memory range
>   * @end:       End address of guest memory range
> @@ -383,7 +383,7 @@ TRACE_EVENT(kvm_vm_set_mem_attributes,
>         TP_printk("%#016llx -- %#016llx [0x%lx]",
>                   __entry->start, __entry->end, __entry->attr)
>  );
> -#endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
> +#endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
>
>  TRACE_EVENT(kvm_unmap_hva_range,
>         TP_PROTO(unsigned long start, unsigned long end),
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index 794976b88c6f9..5119cb37145fc 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -100,7 +100,7 @@ config KVM_ELIDE_TLB_FLUSH_IF_YOUNG
>  config KVM_MMU_LOCKLESS_AGING
>         bool
>
> -config KVM_GENERIC_MEMORY_ATTRIBUTES
> +config KVM_VM_MEMORY_ATTRIBUTES
>         bool
>
>  config KVM_GUEST_MEMFD
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 89489996fbc1e..306153abbafa5 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1115,7 +1115,7 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
>         spin_lock_init(&kvm->mn_invalidate_lock);
>         rcuwait_init(&kvm->mn_memslots_update_rcuwait);
>         xa_init(&kvm->vcpu_array);
> -#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
> +#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
>         xa_init(&kvm->mem_attr_array);
>  #endif
>
> @@ -1300,7 +1300,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
>         cleanup_srcu_struct(&kvm->irq_srcu);
>         srcu_barrier(&kvm->srcu);
>         cleanup_srcu_struct(&kvm->srcu);
> -#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
> +#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
>         xa_destroy(&kvm->mem_attr_array);
>  #endif
>         kvm_arch_free_vm(kvm);
> @@ -2418,7 +2418,7 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
>  }
>  #endif /* CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT */
>
> -#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
> +#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
>  static u64 kvm_supported_mem_attributes(struct kvm *kvm)
>  {
>         if (!kvm || kvm_arch_has_private_mem(kvm))
> @@ -2623,7 +2623,7 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
>
>         return kvm_vm_set_mem_attributes(kvm, start, end, attrs->attributes);
>  }
> -#endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
> +#endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
>
>  struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn)
>  {
> @@ -4921,7 +4921,7 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
>         case KVM_CAP_SYSTEM_EVENT_DATA:
>         case KVM_CAP_DEVICE_CTRL:
>                 return 1;
> -#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
> +#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
>         case KVM_CAP_MEMORY_ATTRIBUTES:
>                 return kvm_supported_mem_attributes(kvm);
>  #endif
> @@ -5325,7 +5325,7 @@ static long kvm_vm_ioctl(struct file *filp,
>                 break;
>         }
>  #endif /* CONFIG_HAVE_KVM_IRQ_ROUTING */
> -#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
> +#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
>         case KVM_SET_MEMORY_ATTRIBUTES: {
>                 struct kvm_memory_attributes attrs;
>
> @@ -5336,7 +5336,7 @@ static long kvm_vm_ioctl(struct file *filp,
>                 r = kvm_vm_ioctl_set_mem_attributes(kvm, &attrs);
>                 break;
>         }
> -#endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
> +#endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
>         case KVM_CREATE_DEVICE: {
>                 struct kvm_create_device cd;
>
>
> --
> 2.54.0.563.g4f69b47b94-goog
>
>

