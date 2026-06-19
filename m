Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E132CD98F8
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 08:13:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46B706B0088; Fri, 19 Jun 2026 04:13:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41BA66B008A; Fri, 19 Jun 2026 04:13:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30A266B008C; Fri, 19 Jun 2026 04:13:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0E9326B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 04:13:07 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8C016C18CE
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 08:13:06 +0000 (UTC)
X-FDA: 84895946772.08.5351EC7
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf14.hostedemail.com (Postfix) with ESMTP id AB49310000F
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 08:13:04 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=j8Bn61eN;
	spf=pass (imf14.hostedemail.com: domain of tabba@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781856784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RFwtLOklkbcVKFnDpfEXKv2zd3HGlCKJCihUf5qCkBo=;
	b=ykS9K/va8TW2lfupAyPoGfN/sPCfEs1pknTLT5r6Yqf8744NVx2ZdUD33qWRwlXx6TiCb8
	wW4T3BQK/cQRO2HyFr7hzgKNQRlFzBa/mhgrGjHZxtqf+DadOK2PVK0TQlpuxE9lIk6JnN
	KUCt8ssQTNoIygKf28Onats1fFMStfA=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=j8Bn61eN;
	spf=pass (imf14.hostedemail.com: domain of tabba@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781856784;
	b=H98J2XdKWoA1zTcn1tT5F6S0cE7ThMoPmthk++cQ7V6RIZpAcl5bErMVbpOxQ2M3WqrcWo
	4oDbBTfl7f5v4Es5Fx5RazC2WK3xHwj/JYfltq9SQBQf48j3reo8hzWWhjWwQDOegvxfWs
	PICjRT3eCR1MRhPHr4OoHW6HISD/Y2o=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-51765531803so194761cf.0
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 01:13:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781856784; cv=none;
        d=google.com; s=arc-20260327;
        b=OHVmfAv9W5vYHW/iP4YISt3c7VvOxGUEau8GeKpUC0wtl/l02IDeB+nNp2G7a5NcjI
         8P3fuaWyNTflCEBr9UroPf1IlZFmM47+8x/9ZQihyVhY+DtzusBVsvGRkvG1riXYCdJC
         hdwoacr7o5Gf23N0uE4vf0M9VSY5LslRr8EyYxOf9Z8mGxSxHxelBbSU9aoDT99uaAdd
         j8s4c/kiL3XG+EvqLFYY+ffQZPNs1G9l6LjqROJ9Mzuhjciya+yp0IS6LiS6eZwtSy2E
         R0FZziXqw2dlcU5U0WJRxTpQK/Xs0sETOzGt/6e2yamP8QQ2RxAk8l9fWPMeew0b7/Ma
         v4UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=RFwtLOklkbcVKFnDpfEXKv2zd3HGlCKJCihUf5qCkBo=;
        fh=HAfYjysTMuXot7dWzHpoJyH9NDxodpLYJA3kD5ReFS0=;
        b=Ysn96DbAPL0DR1CBIxNnX/qfiu559WXiNeNnPWwvgECTmM+sEr570hGiN3mDfakvrC
         Es6hlN6X8uy4D9xKr3F9bMjn2c7GC0SFWXa9KD4b944O1Rh1hIG3Wdkxs44i86Jke2qs
         bgUJjKdEIFT6FWnrjYIuoUCoaMr/fHctNkLvYi8+ccbaB4ap4A9kZ3O1krFta1aRKH2Q
         cyK+ucjTVdoRI0WiZlUta4mSLOugsxnEIVmCvd3nIMHFNGuG/m0XMdjjo99j1sgzrmxV
         K9Lzde/O/nBxRvDXqL/IlvLoQrlLrSmqKJsRN7O0iloy6SRR3RGtmD65+fUMX1djF0dZ
         TYFg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781856784; x=1782461584; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RFwtLOklkbcVKFnDpfEXKv2zd3HGlCKJCihUf5qCkBo=;
        b=j8Bn61eNG5JqnjqcyJzkihP+28fKw+K2yIlBKG4CYEdJuAee89xqoc4z5HW+t3DIul
         MRI5OvaPMzRt96qqvIPlL7OVHM2HKbj2DcRyWLKO0Mvnedc9aFcsjp31ccGjVQCZT7XO
         uyN8sJwTLUGw+44wB0Oa25cSzGF7Kv6Y/u2l5jup3pkLScLMEV+idnNslX8fuZDAe8GU
         6Ehbrml/5QtXlThEoWt6GrZIo7ID0RccUeetNIW9Hab9tZKMZck6bir7HXs2SwZHjH5C
         /z2411rkZPTao6H9s0U4kJ1+QF/np2vjj/MFHQ62oKs6aAhnScEcUt09xg6V3bUPvMUH
         wTAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781856784; x=1782461584;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=RFwtLOklkbcVKFnDpfEXKv2zd3HGlCKJCihUf5qCkBo=;
        b=jJFYsFm4X2Gjaez+v6r40domtdtR6b3mE06dZEi9h7o//YgNMepTzJKI6T6OIV8yrY
         pb5iac6NSOebdfehqOcp2CeGJNzkEs2WxaCer68Q+zATrpRANQOdD9g7b6T4SOeWb9jg
         6z7uxxiozeWja4e23xSMljR1TZ2AoZm0ASIi11vU/ualNgAAgaD6yuuLDh2N/nCx7yCW
         412c8bFMMinR/gHjqlQqBZRKnB76Ik9elqRntBdmQw/d2jeHOSLMqXmOF+8VLgAWQe0b
         aC3GERlRO+6LEqr4G/dRBl3VMdZl7V0vpksQkufBl7h8xyXZmE7rUkBcie0vLhPkGVVF
         P/jg==
X-Forwarded-Encrypted: i=1; AFNElJ/HzjODuDGQad6g7u2ur0fKQnrGsio8VElpV6VlKewDbPQzbTEDa76AtUySxYCW4nj5hRdIa5ZOeg==@kvack.org
X-Gm-Message-State: AOJu0YzA480GqGCra5+24uhA5Zg05QG29wWgqsCSvfzDpZxH/cm4axrw
	eodMApjSjCTHqVAwGZKOzkftinQgMOxJGktAFX8YDY4yNckaKr++l3iaoLaI6iIBpKGIqXR50Cm
	vPpRP1D7swr/beW+zAohRX6KAAEqOlXlczskgSXsy
X-Gm-Gg: AfdE7cnxaV83Nl2qYH9cQdmJFWvXyrpUwJ1tzwhvbGj/W5wbxxm/NIf4qT6uUR0bDg4
	c4Ty8REzv5dfBKrfTuYMzxUoGvreqLohcOXxEfH6aOVG97DdYfejqX598JfWG7fz+KCDXPAlINQ
	/G6du2AL8Cj3bHOTrJY9b35V2VLNRCNE41PA0iqC7TWwrHgw8EVZ/kzJyc1Azzsav7AXQV2EK0L
	+NUQ0t4SVhcbVwYthoOUSQ3DGKMC12bPYriG8qGZlbwj7lgw/+0HSyEGoKjoWoAhvE6ef5hntZJ
	WSh7q0xE
X-Received: by 2002:a05:622a:1906:b0:516:4f62:85ea with SMTP id
 d75a77b69052e-519e8d3111amr4387331cf.21.1781856782436; Fri, 19 Jun 2026
 01:13:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com> <20260618-gmem-inplace-conversion-v8-5-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-5-9d2959357853@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 19 Jun 2026 09:12:25 +0100
X-Gm-Features: AVVi8CcN5N8mHAFYGVLMZrPjXc2jn5V9jAAbKlAQIrOrX_OPU6MaDRc17hIP_FI
Message-ID: <CA+EHjTwrfont5S84MpiwSLfk5doD_RwS96EX88e07c4-1DeMZw@mail.gmail.com>
Subject: Re: [PATCH v8 05/46] KVM: Make CONFIG_KVM_VM_MEMORY_ATTRIBUTES selectable
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
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AB49310000F
X-Rspam-User: 
X-Stat-Signature: 8fpwk5c3aza8n1117ypgs33tftrx3d87
X-HE-Tag: 1781856784-659105
X-HE-Meta: U2FsdGVkX19jXxy/PD+25cRRe6FfIa6muEsAkLOYRixRAztmEDflB1slkaUaZDH18sxoWUPUMqnwCVgvvcsQGshMwh+uiNGEruAlcJk91q2q/q/9PORZ2HK/hiZz9qNLL1njal5D6qPAyOrz0WMYeU8F15UlCR3W6Gl/XGk18ffDqbZ40NmTzIucK1C9pgbKwR7GC9RZS2pxOi/i//PPj94PYJgC7aKdlX3b5DNv2bt05CW5TO83sJLpGTZ6q0VyPb8L76F4siZ5jmRCDjzolExsXBPcKwGKhFqwIY3tNif7gyAMlZJ/+IKniGNd8zFWI8dwF10erlpciEVHBli2MucOxTQ+WSex/pDKKaqpHrYtXaD1BGvoqAb0t354LJZo86Weq2hSZBq3Ge1e0JFpV94c6nZtihhHFkMBUoE6i5bufNFLqoXNNCuPI/kGITQZ1+CuOYkJ8XDBGPYGQA9CGMQi1nX3RABXh0EkdJRyD5fvXbT//u6r68EDirY7Blrr/cI+tCIVVxrHMpH7w2kmJEgzHzNTZZ7tKGbpgjfMe1CLb2DoI/rTsxgXm8+a5ZDw60AlFIxievavL8oUSFZUM2VKTD72VzBDFxxTsqhVcfQC+tOMg3x/axmwEI4qyuAr4wG5URkkPYI5MKpBJcgQSuMifjiJWoNXFzzk+F+qu4CTqoSPwwxObCZ/cpmIKHDJwvDM2zIz5dxaen6oCH5Tqra7veWELHCR8AiQ+rAOpHG6Q/3hJca27Ju9q2u2fuagH6pdf+DjP4Ih8sBRXR3wTMegKwMaStymXWBNincMgqSSLYYl5X+B1CepPijdIL+2keBtxuYCMnbcbqVOnuwg+TCBzb9Ue5UAOg6XaBK4llqKoT9TlpUbL0dp2KwwWlYLGsZ5df9qi7YyI18We23ltTErMMJxAOra3in1kMGgmLMOEz03JRHlHkkIZHOANtQzxyAD3QIHnH4FitjwCCS
 NoK4gXLv
 RroRoFLEfW9MOxnC0z8Qd6IHP2h3VE2Bal4BstFTT4ouAnXjU65dOMDZXqrOPiwzuHJFojU/g1WxvJx7bqBqdPH9veWvxeka9dAsUk957P08gSOFHp3Kx0udCk/bKU3regNHpfRMHORmzAvOm/WaBbLT7yz3PdW3Xvot/mCvRmLQkjfWPs3OItKbyt5DXXLTpLxXO8vWG03sBTP9SE5ufLbLhNtlJVsZ3TBo3p/VvI7s70bNwHNHXKV7HWmWve2R/3+jaXYgQp0L/jJBf7LDSYIJ4HkfXyguTmGrdUWHw66xoJ335P8pXO4Ru1k3klURD7FSmzaafMiOvr+U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 19 Jun 2026 at 01:31, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Ackerley Tng <ackerleytng@google.com>
>
> Make CONFIG_KVM_VM_MEMORY_ATTRIBUTES selectable, only for (CoCo) VM types
> that might use vm_memory_attributes.
>
> Also document CONFIG_KVM_VM_MEMORY_ATTRIBUTES to specifically be about the
> private/shared attribute.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

You're missing a SoB, but with that fixed:

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  arch/x86/kvm/Kconfig | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 24f96396cfa1c..c28393dc664eb 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -81,13 +81,16 @@ config KVM_WERROR
>           If in doubt, say "N".
>
>  config KVM_VM_MEMORY_ATTRIBUTES
> -       bool
> +       depends on KVM_SW_PROTECTED_VM || KVM_INTEL_TDX || KVM_AMD_SEV
> +       bool "Enable per-VM PRIVATE vs. SHARED attributes (for CoCo VMs)"
> +       help
> +         Enable support for tracking PRIVATE vs. SHARED memory using per-VM
> +         memory attributes.
>
>  config KVM_SW_PROTECTED_VM
>         bool "Enable support for KVM software-protected VMs"
>         depends on EXPERT
>         depends on KVM_X86 && X86_64
> -       select KVM_VM_MEMORY_ATTRIBUTES
>         help
>           Enable support for KVM software-protected VMs.  Currently, software-
>           protected VMs are purely a development and testing vehicle for
> @@ -138,7 +141,6 @@ config KVM_INTEL_TDX
>         bool "Intel Trust Domain Extensions (TDX) support"
>         default y
>         depends on INTEL_TDX_HOST
> -       select KVM_VM_MEMORY_ATTRIBUTES
>         select HAVE_KVM_ARCH_GMEM_POPULATE
>         help
>           Provides support for launching Intel Trust Domain Extensions (TDX)
> @@ -162,7 +164,6 @@ config KVM_AMD_SEV
>         depends on KVM_AMD && X86_64
>         depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
>         select ARCH_HAS_CC_PLATFORM
> -       select KVM_VM_MEMORY_ATTRIBUTES
>         select HAVE_KVM_ARCH_GMEM_PREPARE
>         select HAVE_KVM_ARCH_GMEM_INVALIDATE
>         select HAVE_KVM_ARCH_GMEM_POPULATE
>
> --
> 2.55.0.rc0.738.g0c8ab3ebcc-goog
>
>

