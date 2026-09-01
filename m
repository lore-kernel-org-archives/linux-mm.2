Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17DCEC61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 08:20:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B2106B00C3; Tue,  1 Sep 2026 04:20:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 189656B00C4; Tue,  1 Sep 2026 04:20:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A0D26B00C5; Tue,  1 Sep 2026 04:20:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CCA1A6B00C3
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:20:17 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5060740353
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:20:17 +0000 (UTC)
X-FDA: 85164496074.13.CEF0F6F
Received: from mta1.migadu.com (out-73.mta1.migadu.com [95.215.58.73])
	by imf28.hostedemail.com (Postfix) with ESMTP id 13D6AC0004
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:20:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=paj0EtmS;
	spf=pass (imf28.hostedemail.com: domain of fuad.tabba@linux.dev designates 95.215.58.73 as permitted sender) smtp.mailfrom=fuad.tabba@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788250815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U/PHmFgF2wGArxx4VTzzv5Tmgt2+FuAUC7T25Dczz3k=;
	b=qYTbWbqJ5s8hR1c99IbESdx8x4kcXE0rfUh9BhXcEYwgR7dX1glJTQCk46NNgza7OLP9EK
	4ODPjDg3wQEq2HP7L0bl89ZeJtYawSSn7mFctrONCFMzp0sMLf+AsIUop9FDrV3kH05ziy
	OE1aSTYgKYvMwTPCRQBQwSOXfZ4Cg0k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788250815;
	b=RPdvCoLl+Yxut2wqdZylqYBJgCKtk5u9o0Wh4h4p2GtyevcK3FCapEKPwBTbLLuPDqgDyK
	sDxKbzREmDJgKsix+YNJrfeMW2Azqydg1tv7tAPRbK3xY6cR9OcpL1KmkCVMmVcaYGMdTA
	p30aYDSoB/0n8Af74wWPytL5tgS30PQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=paj0EtmS;
	spf=pass (imf28.hostedemail.com: domain of fuad.tabba@linux.dev designates 95.215.58.73 as permitted sender) smtp.mailfrom=fuad.tabba@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=dPSr56z5rAs+SkiIx0/dU1tmsjqb2fO0/em7DI52Cpg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788250813; v=1; x=1788855613;
 b=paj0EtmSVacoEcS3+vfFsYSNX6rTYWIsaTQ3sx1pn5M/sp742MNB0h3wvf3fezicxxvwBTeZ
 MhzerZxd0BeLvg4WClysGROX+wCwsuaYR0o+wXWciRa5TPQcUwy1GcJSIGg37mVxZ3ka0S5ZRg8
 zq1e73xthzGtIB0k4pXJg29w=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 546b3367cac6a555;
	Tue, 01 Sep 2026 08:20:13 +0000
X-Mizu-Trace-ID: 546b3367cac6a555
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5b2a73da7e1so5533e87.0
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 01:20:13 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzqPgfQdsr3yJraV5eCjbv6P6AO5nPQ0XCUiRuI+BVtNkDaa+XMYH6IZ+4Oe6eTIyWG4+vEtIl1dw==@kvack.org
X-Gm-Message-State: AFuF++kcXlKe+IHjYsKc7J5Vsg15xrIVJpPudMG6i4iz+DujQ5INaR6l
	+Em4Ruo3i5u+bUjXIHGQV/yduPvAQHk1SH5uE3WGkIM++lYd0yRpxVvnz0HA7rL8kZAUPZtrbXX
	mZMLeN7YXlT8TAGIBP5t/EdkcPIjwBIxZYJxer5MK
X-Received: by 2002:a05:6512:3416:b0:5b1:5141:9156 with SMTP id
 2adb3069b0e04-5b600a4e6c1mr82007e87.9.1788250812101; Tue, 01 Sep 2026
 01:20:12 -0700 (PDT)
MIME-Version: 1.0
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com> <20260830-gmem-inplace-conversion-v12-23-85e5fd25252a@google.com>
In-Reply-To: <20260830-gmem-inplace-conversion-v12-23-85e5fd25252a@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 1 Sep 2026 09:19:35 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzALzghuG5J-LFuG5pXJ4WgEfrMHgwkMHnq1U-D6yS7Pg@mail.gmail.com>
X-Gm-Features: AcwNN1VEd61L_O2SZt1wLXP8U1ZnnNtTHeRYFc82-Kw9mTwcloJaTFPGEc_5sR8
Message-ID: <CA+EHjTzALzghuG5J-LFuG5pXJ4WgEfrMHgwkMHnq1U-D6yS7Pg@mail.gmail.com>
Subject: Re: [PATCH v12 23/45] KVM: Let userspace disable per-VM mem
 attributes, enable per-gmem attributes
To: ackerleytng@google.com
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
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
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev, 
	Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 13D6AC0004
X-Stat-Signature: w7g6kfcwjhr4a3k883bqhrx4de9iwu58
X-HE-Tag: 1788250814-447717
X-HE-Meta: U2FsdGVkX1+Cyjw9+NH+OxW7+MqYDXQdScKBe9nonKddIZfEADQFBjrMNKNa1RfQMSri0NQgENzuX3xD96clHQVg0jgyCMIMMC5+8PHjMZVTDeHsbD18UQKQkLMecMRAPLM/3Txgz4GKxdn/J/krOAWfpNpEcWYEUuvIIdtIce+gT+S5l6CEXQ528AED5wdWF4IOwTQRoHMEGVdjh9gldcAQMwcMbMUuwpzgcKo2U3k/eSin0IbOSxNcO6nYUVmVeu+AxqqHeps7lYVcxjjSH3NWYh7CT/oEaeClLKHvB0Tr0HJNvhS9Rn/4HQfR2AfSK6OFuhmgGpTwWjg9UaOSieQpUuGXxJi0UNVKV/obAUC0MK8Db8DHIDYffYXoOLtBFZU64U28WFB+tnT8kOoOz6drPzc8X8gI7HyZ7zVkrtMHh7s4gQ7jCa7NwXLTDxHimpXoROILGeplP39t3RwLOHNaenw3S6NHuT3QzOv3UYy+VQnyrRNOIpl+5IJD30apJMSnXY85Q3i8esPLnjKstvuSHmYEoryBosergKVQL6+/9ulx+Z+EZ9FmW3DwdNoaNE5kmnAhqcvSWS/EYZbS2m/EWMy9++0hX6aVMr5O8x2S8L9t2dMqZ4K8ZWtN8jMCHkrAXvKFBGp5dU7tRp8C89u7T5UAbIFSSSpZYx2yt3cbTGmGTpQdOpwKG7KTQL99iLzSjDUsD8SprcB9/n/K0pZCSAbPXWmh+4AvP4DZHFxO2zy3acG4XcCjZP7r7bXMLMVBOZaxxgIheURrr6io3EYUl4uxtUHaZxV0bbI1T7SNYbTfU1k+2FSXG+1KSqEquees9LpXi+VYmS/LzMF6/s8Hfxl+CqzcmKE4XEeN/fBMHbwvXquw+WHUY3PIk6r947W7MvUVSi4SXXFStJexvJith2R92O3SU4WtEafKpMKGW1hLONxJ+6yTFPu8ZXvNUoZgIR1vBuLEThLHzPN
 afFg5NEF
 3Hw1AEc1B6lF5D8GN8C58z58AnPagbxApoegRoN7ajSZbHugXNDVioMpe/OiiGs4b6c2XHjX+e37RAhUMeKflBmbHvMWu5/uA6EKvVHZD7AuuHb10UtCeagbmDI83sDJrdbtv6bITkcBUbDe7MkuxyLTQTpJ/OcbdsA0Rg4YhiB8KpIVs0cAWlqH57/KuTEq5zRFty3+gUj/bkkXS3hDjNeLNmdpenFZE5mmmHFJEMu/bGndyvcje8npND6VmpTpq4bjK8QU/NLybMm9BzN1HMnOmRJNycAHOiW1b
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Sean, Ackerley,

On Mon, 31 Aug 2026 at 01:25, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
...
> +       kvm.gmem_in_place_conversion=
> +                       [KVM] Controls whether KVM enables in-place conversion
> +                       support for guest_memfd and tracks the private/shared
> +                       state of memory per guest_memfd instead of per VM.
> +
> +                       If enabled, KVM enables the KVM_SET_MEMORY_ATTRIBUTES2
> +                       ioctl on guest_memfd file descriptors and disables the
> +                       legacy VM-scoped KVM_SET_MEMORY_ATTRIBUTES ioctl for
> +                       private memory state tracking. Only the
> +                       KVM_MEMORY_ATTRIBUTE_PRIVATE attribute moves to
> +                       per-guest_memfd tracking; other attributes remain
> +                       per-VM.
> +
> +                       This parameter toggles KVM's in-place conversion
> +                       capability support. Whether a VMM uses separate backends
> +                       or out-of-place memory management is determined by
> +                       userspace VMM design.
> +
> +                       Note, this parameter is only available when
> +                       CONFIG_KVM_VM_MEMORY_ATTRIBUTES=y. When
> +                       CONFIG_KVM_VM_MEMORY_ATTRIBUTES is not set, in-place
> +                       conversion is unconditionally enabled.
> +
> +                       Default is Y (on).

The parameter is only settable when CONFIG_KVM_VM_MEMORY_ATTRIBUTES=y, and
in that config gmem_in_place_conversion initialises to
!IS_ENABLED(CONFIG_KVM_VM_MEMORY_ATTRIBUTES), i.e. N, not Y. Is the doc line
wrong, or is N-by-default not what was intended here?

Cheers,
/fuad

> +
>         kvm.nx_huge_pages=
>                         [KVM] Controls the software workaround for the
>                         X86_BUG_ITLB_MULTIHIT bug.
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 83e26ce45fb79..e840418427a1d 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1851,7 +1851,9 @@ enum kvm_intr_type {
>         ((vcpu) && (vcpu)->arch.handling_intr_from_guest && \
>          (!!in_nmi() == ((vcpu)->arch.handling_intr_from_guest == KVM_HANDLING_NMI)))
>
> -#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
> +#if defined(CONFIG_KVM_SW_PROTECTED_VM) ||     \
> +    defined(CONFIG_KVM_INTEL_TDX) ||           \
> +    defined(CONFIG_KVM_AMD_SEV)
>  #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
>  #endif
>  #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index abb108886733a..2c3c22aeafa54 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -81,13 +81,21 @@ config KVM_WERROR
>           If in doubt, say "N".
>
>  config KVM_VM_MEMORY_ATTRIBUTES
> -       bool
> +       bool "Enable per-VM PRIVATE vs. SHARED attributes (for CoCo VMs)"
> +       depends on KVM_SW_PROTECTED_VM || KVM_INTEL_TDX || KVM_AMD_SEV
> +       help
> +         Enable support for tracking PRIVATE vs. SHARED memory using per-VM
> +         memory attributes.  Using per-VM attributes is deprecated in favor of
> +         tracking PRIVATE state in guest_memfd.  Select this if you need to run
> +         CoCo VMs using a VMM that doesn't support guest_memfd memory
> +         attributes.
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
> @@ -138,7 +146,6 @@ config KVM_INTEL_TDX
>         bool "Intel Trust Domain Extensions (TDX) support"
>         default y
>         depends on INTEL_TDX_HOST
> -       select KVM_VM_MEMORY_ATTRIBUTES
>         select HAVE_KVM_ARCH_GMEM_POPULATE
>         help
>           Provides support for launching Intel Trust Domain Extensions (TDX)
> @@ -162,7 +169,6 @@ config KVM_AMD_SEV
>         depends on KVM_AMD && X86_64
>         depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
>         select ARCH_HAS_CC_PLATFORM
> -       select KVM_VM_MEMORY_ATTRIBUTES
>         select HAVE_KVM_ARCH_GMEM_CONVERT
>         select HAVE_KVM_ARCH_GMEM_RECLAIM
>         select HAVE_KVM_ARCH_GMEM_INVALIDATE
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 05c518c9b8078..929fd3e1a01e6 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -103,7 +103,10 @@ static bool __ro_after_init allow_unsafe_mappings;
>  module_param(allow_unsafe_mappings, bool, 0444);
>
>  #ifdef kvm_arch_has_private_mem
> -bool __ro_after_init gmem_in_place_conversion = false;
> +bool __ro_after_init gmem_in_place_conversion = !IS_ENABLED(CONFIG_KVM_VM_MEMORY_ATTRIBUTES);
> +#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
> +module_param(gmem_in_place_conversion, bool, 0444);
> +#endif
>  EXPORT_SYMBOL_FOR_KVM_INTERNAL(gmem_in_place_conversion);
>  #endif
>
>
> --
> 2.55.0.897.gb25b4bd76c-goog
>
>

