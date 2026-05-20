Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05EC9CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 12:09:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B1336B0095; Wed, 20 May 2026 08:09:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 689176B0096; Wed, 20 May 2026 08:09:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 577846B0098; Wed, 20 May 2026 08:09:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 48B066B0095
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:09:04 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1790BC15B8
	for <linux-mm@kvack.org>; Wed, 20 May 2026 12:09:04 +0000 (UTC)
X-FDA: 84787677408.16.BC874D0
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf21.hostedemail.com (Postfix) with ESMTP id 234EE1C0010
	for <linux-mm@kvack.org>; Wed, 20 May 2026 12:09:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aeYmUmPA;
	spf=pass (imf21.hostedemail.com: domain of tabba@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779278942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1loqKNqBfUQEUiKNjIaf2//9gQU5EZIeIdKcljTtYYk=;
	b=CwBgxxs8YS+oqDiUII6piEdrcf8Miti7PyXtfMtZFLHbEy9HSK6Gw6NpiyxYJgN+RZn8pX
	qmTN01CivwXSSdi1/zjQuPrdTa4y6LEzb8v46k0wzcRl/MOZM/MJ0lHMZdHMfL5EY1E0Y7
	evHhbWbPhMqSGJ8uay17Kc5xpbe2H/Q=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aeYmUmPA;
	spf=pass (imf21.hostedemail.com: domain of tabba@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779278942; a=rsa-sha256;
	cv=pass;
	b=8pHX59aCLOn5ygRr5xGupPcdvue+V0CXRJW9d/mvlGTigrT1Z4NYpFuh5dsHNzOU2x7sbM
	d2+Z7Ex8Dno9Fpu+kt41Q1f7LKkscD7xFHCxTHTaCYIFS4dHzxpqaiXu3BgHQEWMJIrmdD
	2+LTwOoa7pOAjxGDdkMP0pNnanKboYE=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-50d6b393d60so8141cf.0
        for <linux-mm@kvack.org>; Wed, 20 May 2026 05:09:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779278941; cv=none;
        d=google.com; s=arc-20240605;
        b=gySV/KjGzxz7IrSzfKE04yyPjv8CEUL0aVoHvY/+AWtNSwTtWVc5819W+WL6Wdu1n0
         aFx2QySRT+RgO61HBFPdWgVzNgzhdoMzCxzX5iP8l1FeuFqtKZT7Cn42JHfbKm+1OKXb
         1SPACQxu2H1QzxebsWCLpy6tkznZDZucuOpYhpDFxNtDypCePZ9fSZB56VJeAjGgFywk
         aFMBq7dy4IzebwN7BInpQG18W8DSAS3bbek4cMIJwZ2Ew/+VHbWRuj39mAPJd0hgeyc8
         t9Ey6YTuTcjQaCZvohKvpGIxwmoE7AbKoEUPjAneNY/JRuk2oTJhWrDNVBnFkrvX6BU5
         z0Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=1loqKNqBfUQEUiKNjIaf2//9gQU5EZIeIdKcljTtYYk=;
        fh=Biu3HP2jcblW+j15loRnDk/elcs6UWUoUCVWZzc+PFY=;
        b=N5HfdRsaKnAEf/ABxkmk2IVxobFQJsfJsYC4LQM65nM9A+V9/CV7oaGFPvibOPz+HF
         AT07U43phaGNI1PgXaGxgB8rEJuBMjcy5zjwytKdafng+0LNcENRJcvxOmgvBgoD6Ff2
         UsbFHV+XjqDwHEpicFF9EQCypb3/qScLquisJONmgO2p1mRpat/hrLr14dvRUWya4ygh
         Ox5sgNTldcEmqItYo6fUVth4gbYArQz7PZYQqGWwJxQu3i0fX/gGnqATVnFesu516Ym/
         EoP4KMvJgtWO4q7bMEHSHq7kiArnjR69UAiDd10BrilCdV5IoPIPdLE1Q2gUHwnoH/vr
         JgUg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779278941; x=1779883741; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1loqKNqBfUQEUiKNjIaf2//9gQU5EZIeIdKcljTtYYk=;
        b=aeYmUmPAo0zzWKbaG/qauKiR/H6srmEHplewgkRlEjANTcNMTCdAiFY+jIQq+GxeJ2
         pqG2f5/t9OcMdbFNfKIBPT8XPBpTyhupgqsW9FImWGuASsFRlk3RtDbuGa07b8O90smU
         m3Ygvh0QRc59ftRW40aB/aD56ucVqPjWQx/HlqXhLMbcR9TnW8/lZpkbFc6tvlvP8Lfb
         gSdcZFHxXZ98PY65RS+b/bsR7++NvqtsFU3x6vx3r15hAXB8gBKap5nUkqfNJ4T8sGvv
         L/V3eoDxHvRGLXrDIfrGTzmS4Nspu+wZR7IZtH6Yizvx6PlyQEMiSRNatraaTzlhCRNY
         rRBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779278941; x=1779883741;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1loqKNqBfUQEUiKNjIaf2//9gQU5EZIeIdKcljTtYYk=;
        b=HEwMLQXLpOk+fw6jE6vJ+aMbUKiv4Hw9/U31QGhxGjoDIR6RLjqKS9HnASzHd+iLWL
         2piXKX5cTK4yh0ivcRPUQf9A4ClnPeou6bjHbZ2HVx+SiuIHLM+UCSFb/X/8l7Kj8Vuy
         dFpRn17SfLxWKyVGyj19yel7AZSqb2EjUL41L8RefyZxrROGRApxDMuXjRza5dL7fjcv
         f63zHWXc/tgRLBTWpSWGQEPbVWTbGO3oLFBbnGVsClcc4YcYd00LB3Ky8jwmEV1abHB8
         VD9uLp4Spv654J33fcfHgjIunH/gyGhA8SRDkzZbTOdrW4OKRQGI5hbclsiMhWzg0m8J
         jMtw==
X-Forwarded-Encrypted: i=1; AFNElJ+71I2d/s+ziID1fTxq2jI9j1omd4apWtf6/NQcdVI1rV/ZKChxyeb/AOBXjOF/QBz+2Nn99TTjAg==@kvack.org
X-Gm-Message-State: AOJu0Yyzr59qYjsDNiEgXzkE6zXyK6Oht41Ro4BA8k3RUby9vykiosAP
	qlYRV7VnqzVnwPpwouGphD7RTvWjL6r2vHRezzctrOTV1xXpE5xaP3qeSMHV3BRm6Y3z8toMZAE
	S9R/OEA0MM5y9tnNVwoGTUs84jzclI9u29K/6JZgk
X-Gm-Gg: Acq92OGltCdTHuA3PgHivq4UFyFr7GJEDR1syP5cSqr4ftdN7/15yfflTiDaAR1nSHg
	4VVKi5IDWZ8Tlu+skxoq2NkddjuP+/VAWoRdoAFejatN+BdD2j85ZUjeoJs60jKBdpA/lFTNZJQ
	KjMkmjYF+TBU3JSyWdHDKdrVXZ7xn5szei2wzPbF7WoMwxLtp8nMOKsL6OfV8+dVB00VeUx8oXU
	HF8L34EVIsbGWkAVSSppLChaP1aSRf5t8niMcEourMYuoSjfLOz47tAi4gFAmjS3a2R7RQblxkU
	RdqPP4OX6oADQUC4Pm0=
X-Received: by 2002:ac8:5907:0:b0:510:f9b:fb5f with SMTP id
 d75a77b69052e-51679440a95mr44783061cf.16.1779278940348; Wed, 20 May 2026
 05:09:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com> <20260507-gmem-inplace-conversion-v6-4-91ab5a8b19a4@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-4-91ab5a8b19a4@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 20 May 2026 13:08:23 +0100
X-Gm-Features: AVHnY4Kw8N8ACb__H9yJPhDqghW33wyYCjP9ISJAFWq6b956Jd8VrKBSA3-Ts4o
Message-ID: <CA+EHjTyJcR5Vnd2t0Jwy2OxL4DoyE60-hafytFjNi_Ys0DXHiw@mail.gmail.com>
Subject: Re: [PATCH v6 04/43] KVM: Stub in ability to disable per-VM memory
 attribute tracking
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 234EE1C0010
X-Stat-Signature: tfuia5pin5wi7dcsf869curdyfyc48ew
X-HE-Tag: 1779278941-817359
X-HE-Meta: U2FsdGVkX19XVy/q54lztgslnhOX7OjsiQ0XUWr+61upi13GcRjEFAkDPJAc9XjvrgJbDG1mmexyfA9Z3A+UYVYhdUb+EHHIFAZMCdmlj9wXJnaUsw7Y1XfdB0W7/QvO1TNANKUTVVEaWnJhCdm3kvDHPbAzc3OINrTLTDzOIKB0mR2pdd51LP2N1eLn7WQgRpOrxeo3TQe7Ss4EDbTQd+vZ4TfrKKI/aerEPWhO5n2gUM3RZD2OQV4GYmgjwIs3O6C8P07U3kVFWib0q9N6hhEbrmpl2Q4FJeEHLgqwu+SUfzlworOhzzyDZRnHcOZBMu5RbsOCIJ0vDpWXzaMaf6EO3u9ksrw5hy2gn+Lmrdh+Hh71RMjIi+6Ks93OFSGdp4HxTt4GkTD4LQ8E32nPBHn7vcgoITsdunubPxlnJ3unckx+lvICvViTvoQ+pXgsNvcDNhE84aSYEbFjz/7/UPH41QIbeJwzH6bPPzvZbRqrr1nkrj7nbN/ALg5Qhq03eAM2P6mx5DhkIRo2fpy6DFvcFSaIdUYfjlUbNX+ci4x2sSjzuQaIsH+4+IOBvqr5VAdk2uT5ZlTKAlKgrptIT35QSNN3WJnx3HaRYQ6m4v26nt74Ps0elDKRMpKm+opWeSpGqiygAraFofN8g/QwI80Jnmora50BA+Ckg9ZPC7RHi2NsWECwurXnXsdVx8r2f8Vt9Sg3OrIA3OqKUGxnPtC0TqUFQVpYdpmNatFSqsX3ccpY5DwgRFY5U4HDDEjsZ9Fip0s+DxFj0mQlOnqa7e8pMpFqf3V9hiyhYL6WtABPti5OEB7+IHDo+ZsfVEZFyq+beMJ4Jj08FyW1iuwJIjlqNoF9By8g/xLgeTM4iOsJxK0mbW79laq/Xlc8d/gHpRXJ928piHxI4j6VCaSBu0eFn+l8K6R+XNMBCVscrzFnNrK4MV0+sz88bfHtUPFN53b0HFgBgiIZe3vy77a
 tR5QowEU
 xpMqchIDQwgDHgzWYKvuYzoE/0aD+/qVYSh/+Z4rxCvTDfBGPNltdrnXHVbD0tf/VcZOaB3UozGra3bZPdbpSrERo8ioan+5q+W0aMlSZiCR2Z0ev7h2XIZ2RR5E25UU7ACOzBWZRB5Uz3OgTgFR+ZP04lITMIRKdV1r2OWEKgcjU5m1VjeO27Mtq8Getfd9E3uvOJiLeGM+omb740RA7NpuujmjzfoCl5jP4TtXsFVf8LYihC6HbdZ2UUpoDOSjr8kJg/4NHRtg27PIkkJK0t23d0vmnJnWU35nD
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
> Introduce the basic infrastructure to allow per-VM memory attribute
> tracking to be disabled. This will be built-upon in a later patch, where a
> module param can disable per-VM memory attribute tracking.
>
> Split the Kconfig option into a base KVM_MEMORY_ATTRIBUTES and the
> existing KVM_VM_MEMORY_ATTRIBUTES. The base option provides the core
> plumbing, while the latter enables the full per-VM tracking via an xarray
> and the associated ioctls.
>
> kvm_get_memory_attributes() now performs a static call that either looks up
> kvm->mem_attr_array with CONFIG_KVM_VM_MEMORY_ATTRIBUTES is enabled, or
> just returns 0 otherwise. The static call can be patched depending on
> whether per-VM tracking is enabled by the CONFIG.
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
>  include/linux/kvm_host.h        | 23 ++++++++++++---------
>  virt/kvm/Kconfig                |  4 ++++
>  virt/kvm/kvm_main.c             | 44 ++++++++++++++++++++++++++++++++++++++++-
>  4 files changed, 62 insertions(+), 11 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 60b997764beef..c9aa50bcdac2d 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2369,7 +2369,7 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
>                        int tdp_max_root_level, int tdp_huge_page_level);
>
>
> -#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
> +#ifdef CONFIG_KVM_MEMORY_ATTRIBUTES
>  #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
>  #endif
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 7d079f9701346..c5ba2cb34e45c 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2528,19 +2528,15 @@ static inline bool kvm_memslot_is_gmem_only(const struct kvm_memory_slot *slot)
>         return slot->flags & KVM_MEMSLOT_GMEM_ONLY;
>  }
>
> -#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
> +#ifdef CONFIG_KVM_MEMORY_ATTRIBUTES
> +typedef unsigned long (kvm_get_memory_attributes_t)(struct kvm *kvm, gfn_t gfn);
> +DECLARE_STATIC_CALL(__kvm_get_memory_attributes, kvm_get_memory_attributes_t);
> +
>  static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
>  {
> -       return xa_to_value(xa_load(&kvm->mem_attr_array, gfn));
> +       return static_call(__kvm_get_memory_attributes)(kvm, gfn);
>  }
>
> -bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
> -                                    unsigned long mask, unsigned long attrs);
> -bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
> -                                       struct kvm_gfn_range *range);
> -bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
> -                                        struct kvm_gfn_range *range);
> -
>  static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>  {
>         return kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
> @@ -2550,6 +2546,15 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>  {
>         return false;
>  }
> +#endif
> +
> +#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
> +bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
> +                                    unsigned long mask, unsigned long attrs);
> +bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
> +                                       struct kvm_gfn_range *range);
> +bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
> +                                        struct kvm_gfn_range *range);
>  #endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
>
>  #ifdef CONFIG_KVM_GUEST_MEMFD
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index 5119cb37145fc..3fea89c45cfb4 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -100,7 +100,11 @@ config KVM_ELIDE_TLB_FLUSH_IF_YOUNG
>  config KVM_MMU_LOCKLESS_AGING
>         bool
>
> +config KVM_MEMORY_ATTRIBUTES
> +       bool
> +
>  config KVM_VM_MEMORY_ATTRIBUTES
> +       select KVM_MEMORY_ATTRIBUTES
>         bool
>
>  config KVM_GUEST_MEMFD
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index abb9cfa3eb04d..ee26f1d9b5fda 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -101,6 +101,17 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(halt_poll_ns_shrink);
>  static bool __ro_after_init allow_unsafe_mappings;
>  module_param(allow_unsafe_mappings, bool, 0444);
>
> +#ifdef CONFIG_KVM_MEMORY_ATTRIBUTES
> +#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
> +static bool vm_memory_attributes = true;
> +#else
> +#define vm_memory_attributes false
> +#endif
> +DEFINE_STATIC_CALL_RET0(__kvm_get_memory_attributes, kvm_get_memory_attributes_t);
> +EXPORT_SYMBOL_FOR_KVM_INTERNAL(STATIC_CALL_KEY(__kvm_get_memory_attributes));
> +EXPORT_SYMBOL_FOR_KVM_INTERNAL(STATIC_CALL_TRAMP(__kvm_get_memory_attributes));
> +#endif
> +
>  /*
>   * Ordering of locks:
>   *
> @@ -2418,7 +2429,7 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
>  }
>  #endif /* CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT */
>
> -#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
> +#ifdef CONFIG_KVM_MEMORY_ATTRIBUTES
>  static u64 kvm_supported_mem_attributes(struct kvm *kvm)
>  {
>  #ifdef kvm_arch_has_private_mem
> @@ -2429,6 +2440,12 @@ static u64 kvm_supported_mem_attributes(struct kvm *kvm)
>         return 0;
>  }
>
> +#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
> +static unsigned long kvm_get_vm_memory_attributes(struct kvm *kvm, gfn_t gfn)
> +{
> +       return xa_to_value(xa_load(&kvm->mem_attr_array, gfn));
> +}
> +
>  /*
>   * Returns true if _all_ gfns in the range [@start, @end) have attributes
>   * such that the bits in @mask match @attrs.
> @@ -2625,7 +2642,24 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
>
>         return kvm_vm_set_mem_attributes(kvm, start, end, attrs->attributes);
>  }
> +#else  /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
> +static unsigned long kvm_get_vm_memory_attributes(struct kvm *kvm, gfn_t gfn)
> +{
> +       BUILD_BUG_ON(1);
> +}
>  #endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
> +static void kvm_init_memory_attributes(void)
> +{
> +       if (vm_memory_attributes)
> +               static_call_update(__kvm_get_memory_attributes,
> +                                  kvm_get_vm_memory_attributes);
> +       else
> +               static_call_update(__kvm_get_memory_attributes,
> +                                  (void *)__static_call_return0);
> +}
> +#else  /* CONFIG_KVM_MEMORY_ATTRIBUTES */
> +static void kvm_init_memory_attributes(void) { }
> +#endif /* CONFIG_KVM_MEMORY_ATTRIBUTES */
>
>  struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn)
>  {
> @@ -4925,6 +4959,9 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
>                 return 1;
>  #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
>         case KVM_CAP_MEMORY_ATTRIBUTES:
> +               if (!vm_memory_attributes)
> +                       return 0;
> +
>                 return kvm_supported_mem_attributes(kvm);
>  #endif
>  #ifdef CONFIG_KVM_GUEST_MEMFD
> @@ -5331,6 +5368,10 @@ static long kvm_vm_ioctl(struct file *filp,
>         case KVM_SET_MEMORY_ATTRIBUTES: {
>                 struct kvm_memory_attributes attrs;
>
> +               r = -ENOTTY;
> +               if (!vm_memory_attributes)
> +                       goto out;
> +
>                 r = -EFAULT;
>                 if (copy_from_user(&attrs, argp, sizeof(attrs)))
>                         goto out;
> @@ -6527,6 +6568,7 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
>         kvm_preempt_ops.sched_in = kvm_sched_in;
>         kvm_preempt_ops.sched_out = kvm_sched_out;
>
> +       kvm_init_memory_attributes();
>         kvm_init_debug();
>
>         r = kvm_vfio_ops_init();
>
> --
> 2.54.0.563.g4f69b47b94-goog
>
>

