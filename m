Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B333CAC5A7
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 16:21:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 960B18E000C; Tue, 23 Sep 2025 12:21:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 938198E0001; Tue, 23 Sep 2025 12:21:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84DB18E000C; Tue, 23 Sep 2025 12:21:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 69FDF8E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 12:21:34 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 14A4B140548
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 16:21:34 +0000 (UTC)
X-FDA: 83921030508.02.11AD172
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf22.hostedemail.com (Postfix) with ESMTP id 409FCC0002
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 16:21:31 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ns0uKXIr;
	spf=pass (imf22.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758644492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hX/x2YQu8IshGIhtT2j6+6VZWl/6xDk05tyNGFgYJMM=;
	b=ZsPXM+rVWzjcOStPC98cmyShG+XGfI9VykhdzgboKquMb8s2PCLpTPl0GGPA8dRp1o9nU/
	TkuG8vobHclD64Jgr8XTC3rme+shp9SUN83IjY3c7QMCBmezxS8jPOiXY+GWF5EX5FlE9s
	z7K02/q4a3kzWCPfjos5nHF/P2OSQ90=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758644492; a=rsa-sha256;
	cv=none;
	b=rDUcO0LQoAx8+CSvEzk0WrR02zPc7W9DVJJPWvcqYtTRHThX2O+z0C7UZ48LetBcoFEVpS
	WOiLugZG8ZY23h+5CYvpvyS2ZnB/oXlW8PC3ijcY57GUr0/wdiu3BPVEJVsA3II0PGKFWd
	xPyfYCZxz3vCGvafIq9qoV4j0L/2Fyg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ns0uKXIr;
	spf=pass (imf22.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3f2ae6fae12so2197365f8f.1
        for <linux-mm@kvack.org>; Tue, 23 Sep 2025 09:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758644490; x=1759249290; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hX/x2YQu8IshGIhtT2j6+6VZWl/6xDk05tyNGFgYJMM=;
        b=Ns0uKXIrwwyFN0kI3LemoPgv0E4j5T2XL/pLYWSm05GGlxNElbQk6divghR8Br633+
         UK67+GID8gBEeNJyZhpK2eU54vBsi2zC24DcD64pNzRc2wdgDGYI88SkGFAS69LuODRJ
         M3Nk7FQ6P1avvQNieRl64eH2HJRHP7FeBcVpTDcfsh/dOxN2KBQndRuL0APGuU8h88BX
         z5HBdPqlRgdtAOGdkbvRqWEOaYB8mDf/RJpbrCLZGra40cTM2wdSiDtTuEsEqzczCW8/
         J7rtqGu9N8+Z+KE1FPz+7ZfHxsjZeDmynzDq0D+IX2kZI48E7VvBhcn5YC7DH6OaGOvu
         0phA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758644490; x=1759249290;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hX/x2YQu8IshGIhtT2j6+6VZWl/6xDk05tyNGFgYJMM=;
        b=Rb/6OU52La6DMTVe2aEeZYDomv/beDi9WQJAt095ZZzfPvtCTUP1Zxa5PIjPyMJKIU
         by9WKXOJDT5XtQxwgv62cWh9IsKYYZ81I7v1cjKHHRn0tUGa99fDgteF3oHA91Ttt2EX
         oRNcvODSKcSivE1b/VeED/cNotlXfYybjQS2PXYBeQE0vm0s7Mm7UvzHN5+fGZ7PTi7f
         radM0aIJRYnlsMVgMWJQMKk/IBzXIiF1Wrlg0t6ratJSoOgfGTN0gWUU1pBLkBUH/4ma
         pFkzglDquoqofqr1oai3trWb4EddGfxb/wP2cI7hLWfRmoxmXPy+PPMtgKUDQJ35Kehg
         r0Uw==
X-Forwarded-Encrypted: i=1; AJvYcCWjKCrsOXlSibEZWKBsTzRdKaRdDCcytmKgN0JGmqhCkWqLQ4RBCS8am4LdolBubTFjABfcCsg7ug==@kvack.org
X-Gm-Message-State: AOJu0Yyd/SsGP9C/vUrlCemRA25SswvaYihHg4PFQEm9/Xy2TR0GkLT7
	BBk87qm13VcJrV7dK7/UG9xJfmOUV8WBF1h/0b4i0kVJhIpWHYl7+3NJ8MgJF9ovH4BXgcb7sDR
	6ihqCvzzk+BIfDasC3GeBy3rQpQ9IxV8=
X-Gm-Gg: ASbGncvutS9QkLu+uY1WheVCxL8wEXLoGpeXY/ZBE5Z/8+Af+mKQjj7mInWOKC+BcQi
	cWMlcxu0PLBWu+Neyzyf+vV/xIMCFcW3xvIrEKbZUiHbCIWMBxUbAcK1zbcMXqv/ymG/+W5Qc91
	P7PdS3BO1QG5d6My45G8Gihvfql6NtMj8zUZ173hiHBgGijT1/zP6Qd0owAyAg+k3Fv0FEF+JKy
	do9T72zFQ==
X-Google-Smtp-Source: AGHT+IFLsDfbMe1B7TKn5qcjOcHKMSiE+AnSedjc8CXlaTSbb/VI4iDnnpzChliLj+DF3rJyI7LW0Ktytb6lz8NGyJA=
X-Received: by 2002:a05:6000:2012:b0:3e5:190b:b04e with SMTP id
 ffacd0b85a97d-405c9a01b60mr2346265f8f.37.1758644490092; Tue, 23 Sep 2025
 09:21:30 -0700 (PDT)
MIME-Version: 1.0
References: <20250916222755.466009-1-yeoreum.yun@arm.com> <20250916222755.466009-2-yeoreum.yun@arm.com>
In-Reply-To: <20250916222755.466009-2-yeoreum.yun@arm.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Tue, 23 Sep 2025 18:21:19 +0200
X-Gm-Features: AS18NWDlzRK91ohBlIigdupIpzh6rhNy0WQJ68f3CbaJYvAQUJclJ8mywpVCdno
Message-ID: <CA+fCnZdRySvANWkT1oK38Ke1Uf9yUm1qyb5-vatJhZR+-eay5g@mail.gmail.com>
Subject: Re: [PATCH v8 1/2] kasan/hw-tags: introduce kasan.write_only option
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: ryabinin.a.a@gmail.com, glider@google.com, dvyukov@google.com, 
	vincenzo.frascino@arm.com, corbet@lwn.net, catalin.marinas@arm.com, 
	will@kernel.org, akpm@linux-foundation.org, scott@os.amperecomputing.com, 
	jhubbard@nvidia.com, pankaj.gupta@amd.com, leitao@debian.org, 
	kaleshsingh@google.com, maz@kernel.org, broonie@kernel.org, 
	oliver.upton@linux.dev, james.morse@arm.com, ardb@kernel.org, 
	hardevsinh.palaniya@siliconsignals.io, david@redhat.com, 
	yang@os.amperecomputing.com, kasan-dev@googlegroups.com, 
	workflows@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 409FCC0002
X-Stat-Signature: squstqqtx5unnnqcgnwts3u713pdzkkq
X-Rspam-User: 
X-HE-Tag: 1758644491-356484
X-HE-Meta: U2FsdGVkX19jvVQ3+oNvNgNTcQmLXd2pW2eL6VZGk9y8KgbSU/nfa4aaMJqoi9aTq3qJl6Ot0fnxHYnDiQFX/OMuFv2l0i5QmQcfWJ6toelN1P2cA8SJEhqNJpmYMn9KemqWOtPVYLztqfwaZ+mmwJ6w6HK2gH1NDyrcB6Qivde6I8+ZXB/6dxNwtPP6RTD9oiFQ8ZMpSUebxZF0mv2MHv66Bvu7M25xdxW58E5tXK0Un/AOgcx4NNNxcjT5s7Aplt0EcYoIkdPkOvf6hotBPv8RAHN4VJf0B6M6CLdUAihbYywYS6DimzCrCOV5klWE5xj83pWSPYewSy2dXkGwDWsr0qnLenies1Xb1R0lCz/llS5lCDDPo08OAKa9o+qhBrPz9CpWv0vgADnDAas2K08u5f1kPo4n7gAAaJJyqAv+lmss5vV8hkr8XpSSz4PIej0gMhaGvPLwo9MGNZI5NYO8RZhAi9Q+NOxsPqZJWNPj5v/NKCzF2vq7YhXwo67uQQLyt3I+hGeBcUXqzrFjywlbzvoYWGnuQ1ND47Nxd+2gL8ER9sv86Q0OoasslOXjJ5ch787W5SxGEnv90JsI2x/66QNV5eAxaTMKwoKqIMJxqjSPXNjt35MCt226MPQIQrz+VLS16pAHJJ2UmvC4oWiv4IRx+WrZdeE8n9jl43fKIr5ta/A6+IxNeZ0FlIKW+kFMvyH/ds5JDKZTEGqWaBTiA1SZXoB/7Npa7yG35i9HZliHLTDoih98W4ILZh95sQcHPt+mm7zImH8UAq8k7O3wZK/h/wg+B/odNVHGsQ57oZdJAcnJeZDBFs+voZ4UGrIMv7Wr7WJuSN+bOeSztLCuINyhLJvmzJZ+s0hsAVjgBH4BHrB27YryfGuQ24Bpyn72DelRCIfuLOLpAGBQ2OFEHGjRi7kQZ8vHnXnBlFH1XlbR7vO6Cg8pkxlYB5I8EfXJKi8g7KKLrgf2Gw7
 dH5oa6tY
 Om+U9EUi1rQNF0nXMvI1Xj2rJyao17elggChpwpfwlTg65nxQZAHth8ljTQ67azTr/cQVCFHZDjGn2gw0YgL5cUidITL3EQ2q//U4P6aEn4PjVK1rNALLH0YIqRMHb+C/r7KLC7FMXV9770M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 12:28=E2=80=AFAM Yeoreum Yun <yeoreum.yun@arm.com> =
wrote:
>
> Since Armv8.9, FEATURE_MTE_STORE_ONLY feature is introduced to restrict
> raise of tag check fault on store operation only.
> Introduce KASAN write only mode based on this feature.
>
> KASAN write only mode restricts KASAN checks operation for write only and
> omits the checks for fetch/read operations when accessing memory.
> So it might be used not only debugging enviroment but also normal
> enviroment to check memory safty.
>
> This features can be controlled with "kasan.write_only" arguments.
> When "kasan.write_only=3Don", KASAN checks write operation only otherwise
> KASAN checks all operations.
>
> This changes the MTE_STORE_ONLY feature as BOOT_CPU_FEATURE like
> ARM64_MTE_ASYMM so that makes it initialise in kasan_init_hw_tags()
> with other function together.
>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
>  Documentation/dev-tools/kasan.rst  |  3 ++
>  arch/arm64/include/asm/memory.h    |  1 +
>  arch/arm64/include/asm/mte-kasan.h |  6 ++++
>  arch/arm64/kernel/cpufeature.c     |  2 +-
>  arch/arm64/kernel/mte.c            | 18 ++++++++++++
>  mm/kasan/hw_tags.c                 | 45 ++++++++++++++++++++++++++++--
>  mm/kasan/kasan.h                   |  7 +++++
>  7 files changed, 79 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/dev-tools/kasan.rst b/Documentation/dev-tools/=
kasan.rst
> index 0a1418ab72fd..a034700da7c4 100644
> --- a/Documentation/dev-tools/kasan.rst
> +++ b/Documentation/dev-tools/kasan.rst
> @@ -143,6 +143,9 @@ disabling KASAN altogether or controlling its feature=
s:
>    Asymmetric mode: a bad access is detected synchronously on reads and
>    asynchronously on writes.
>
> +- ``kasan.write_only=3Doff`` or ``kasan.write_only=3Don`` controls wheth=
er KASAN
> +  checks the write (store) accesses only or all accesses (default: ``off=
``).
> +
>  - ``kasan.vmalloc=3Doff`` or ``=3Don`` disables or enables tagging of vm=
alloc
>    allocations (default: ``on``).
>
> diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/mem=
ory.h
> index 5213248e081b..f1505c4acb38 100644
> --- a/arch/arm64/include/asm/memory.h
> +++ b/arch/arm64/include/asm/memory.h
> @@ -308,6 +308,7 @@ static inline const void *__tag_set(const void *addr,=
 u8 tag)
>  #define arch_enable_tag_checks_sync()          mte_enable_kernel_sync()
>  #define arch_enable_tag_checks_async()         mte_enable_kernel_async()
>  #define arch_enable_tag_checks_asymm()         mte_enable_kernel_asymm()
> +#define arch_enable_tag_checks_write_only()    mte_enable_kernel_store_o=
nly()
>  #define arch_suppress_tag_checks_start()       mte_enable_tco()
>  #define arch_suppress_tag_checks_stop()                mte_disable_tco()
>  #define arch_force_async_tag_fault()           mte_check_tfsr_exit()
> diff --git a/arch/arm64/include/asm/mte-kasan.h b/arch/arm64/include/asm/=
mte-kasan.h
> index 2e98028c1965..0f9b08e8fb8d 100644
> --- a/arch/arm64/include/asm/mte-kasan.h
> +++ b/arch/arm64/include/asm/mte-kasan.h
> @@ -200,6 +200,7 @@ static inline void mte_set_mem_tag_range(void *addr, =
size_t size, u8 tag,
>  void mte_enable_kernel_sync(void);
>  void mte_enable_kernel_async(void);
>  void mte_enable_kernel_asymm(void);
> +int mte_enable_kernel_store_only(void);
>
>  #else /* CONFIG_ARM64_MTE */
>
> @@ -251,6 +252,11 @@ static inline void mte_enable_kernel_asymm(void)
>  {
>  }
>
> +static inline int mte_enable_kernel_store_only(void)
> +{
> +       return -EINVAL;
> +}
> +
>  #endif /* CONFIG_ARM64_MTE */
>
>  #endif /* __ASSEMBLY__ */
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeatur=
e.c
> index ef269a5a37e1..1f6e8c87aae7 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -2945,7 +2945,7 @@ static const struct arm64_cpu_capabilities arm64_fe=
atures[] =3D {
>         {
>                 .desc =3D "Store Only MTE Tag Check",
>                 .capability =3D ARM64_MTE_STORE_ONLY,
> -               .type =3D ARM64_CPUCAP_SYSTEM_FEATURE,
> +               .type =3D ARM64_CPUCAP_BOOT_CPU_FEATURE,
>                 .matches =3D has_cpuid_feature,
>                 ARM64_CPUID_FIELDS(ID_AA64PFR2_EL1, MTESTOREONLY, IMP)
>         },
> diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
> index e5e773844889..54a52dc5c1ae 100644
> --- a/arch/arm64/kernel/mte.c
> +++ b/arch/arm64/kernel/mte.c
> @@ -157,6 +157,24 @@ void mte_enable_kernel_asymm(void)
>                 mte_enable_kernel_sync();
>         }
>  }
> +
> +int mte_enable_kernel_store_only(void)
> +{
> +       /*
> +        * If the CPU does not support MTE store only,
> +        * the kernel checks all operations.
> +        */
> +       if (!cpus_have_cap(ARM64_MTE_STORE_ONLY))
> +               return -EINVAL;
> +
> +       sysreg_clear_set(sctlr_el1, SCTLR_EL1_TCSO_MASK,
> +                        SYS_FIELD_PREP(SCTLR_EL1, TCSO, 1));
> +       isb();
> +
> +       pr_info_once("MTE: enabled store only mode at EL1\n");
> +
> +       return 0;
> +}
>  #endif
>
>  #ifdef CONFIG_KASAN_HW_TAGS
> diff --git a/mm/kasan/hw_tags.c b/mm/kasan/hw_tags.c
> index 9a6927394b54..646f090e57e3 100644
> --- a/mm/kasan/hw_tags.c
> +++ b/mm/kasan/hw_tags.c
> @@ -67,6 +67,9 @@ DEFINE_STATIC_KEY_FALSE(kasan_flag_vmalloc);
>  #endif
>  EXPORT_SYMBOL_GPL(kasan_flag_vmalloc);
>
> +/* Whether to check write accesses only. */
> +static bool kasan_flag_write_only =3D false;
> +
>  #define PAGE_ALLOC_SAMPLE_DEFAULT      1
>  #define PAGE_ALLOC_SAMPLE_ORDER_DEFAULT        3
>
> @@ -141,6 +144,23 @@ static int __init early_kasan_flag_vmalloc(char *arg=
)
>  }
>  early_param("kasan.vmalloc", early_kasan_flag_vmalloc);
>
> +/* kasan.write_only=3Doff/on */
> +static int __init early_kasan_flag_write_only(char *arg)
> +{
> +       if (!arg)
> +               return -EINVAL;
> +
> +       if (!strcmp(arg, "off"))
> +               kasan_flag_write_only =3D false;
> +       else if (!strcmp(arg, "on"))
> +               kasan_flag_write_only =3D true;
> +       else
> +               return -EINVAL;
> +
> +       return 0;
> +}
> +early_param("kasan.write_only", early_kasan_flag_write_only);
> +
>  static inline const char *kasan_mode_info(void)
>  {
>         if (kasan_mode =3D=3D KASAN_MODE_ASYNC)
> @@ -262,10 +282,11 @@ void __init kasan_init_hw_tags(void)
>         /* KASAN is now initialized, enable it. */
>         static_branch_enable(&kasan_flag_enabled);
>
> -       pr_info("KernelAddressSanitizer initialized (hw-tags, mode=3D%s, =
vmalloc=3D%s, stacktrace=3D%s)\n",
> +       pr_info("KernelAddressSanitizer initialized (hw-tags, mode=3D%s, =
vmalloc=3D%s, stacktrace=3D%s, write_only=3D%s)\n",
>                 kasan_mode_info(),
>                 str_on_off(kasan_vmalloc_enabled()),
> -               str_on_off(kasan_stack_collection_enabled()));
> +               str_on_off(kasan_stack_collection_enabled()),
> +               str_on_off(kasan_flag_write_only));
>  }
>
>  #ifdef CONFIG_KASAN_VMALLOC
> @@ -392,6 +413,20 @@ void kasan_enable_hw_tags(void)
>                 hw_enable_tag_checks_asymm();
>         else
>                 hw_enable_tag_checks_sync();
> +
> +       /*
> +        * CPUs can only be in one of two states:
> +        *   - All CPUs support the write_only feature
> +        *   - No CPUs support the write_only feature
> +        *
> +        * If the first CPU attempts hw_enable_tag_checks_write_only() an=
d
> +        * finds the feature unsupported, kasan_flag_write_only is set to=
 OFF
> +        * to avoid further unnecessary calls on other CPUs.
> +        */
> +       if (kasan_flag_write_only && hw_enable_tag_checks_write_only()) {
> +               kasan_flag_write_only =3D false;
> +               pr_err_once("write-only mode is not supported and thus no=
t enabled\n");
> +       }
>  }
>
>  #if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
> @@ -404,4 +439,10 @@ VISIBLE_IF_KUNIT void kasan_force_async_fault(void)
>  }
>  EXPORT_SYMBOL_IF_KUNIT(kasan_force_async_fault);
>
> +VISIBLE_IF_KUNIT bool kasan_write_only_enabled(void)
> +{
> +       return kasan_flag_write_only;
> +}
> +EXPORT_SYMBOL_IF_KUNIT(kasan_write_only_enabled);
> +
>  #endif
> diff --git a/mm/kasan/kasan.h b/mm/kasan/kasan.h
> index 129178be5e64..844eedf2ef9c 100644
> --- a/mm/kasan/kasan.h
> +++ b/mm/kasan/kasan.h
> @@ -431,6 +431,7 @@ static inline const void *arch_kasan_set_tag(const vo=
id *addr, u8 tag)
>  #define hw_suppress_tag_checks_start()         arch_suppress_tag_checks_=
start()
>  #define hw_suppress_tag_checks_stop()          arch_suppress_tag_checks_=
stop()
>  #define hw_force_async_tag_fault()             arch_force_async_tag_faul=
t()
> +#define hw_enable_tag_checks_write_only()      arch_enable_tag_checks_wr=
ite_only()
>  #define hw_get_random_tag()                    arch_get_random_tag()
>  #define hw_get_mem_tag(addr)                   arch_get_mem_tag(addr)
>  #define hw_set_mem_tag_range(addr, size, tag, init) \
> @@ -451,11 +452,17 @@ void __init kasan_init_tags(void);
>  #if defined(CONFIG_KASAN_HW_TAGS) && IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
>
>  void kasan_force_async_fault(void);
> +bool kasan_write_only_enabled(void);
>
>  #else /* CONFIG_KASAN_HW_TAGS && CONFIG_KASAN_KUNIT_TEST */
>
>  static inline void kasan_force_async_fault(void) { }
>
> +static inline bool kasan_write_only_enabled(void)
> +{
> +       return false;
> +}
> +
>  #endif /* CONFIG_KASAN_HW_TAGS && CONFIG_KASAN_KUNIT_TEST */
>
>  #ifdef CONFIG_KASAN_SW_TAGS
> --
> LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}
>

Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>

