Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3056DCA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 09:53:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B08E58E002D; Mon, 18 Aug 2025 05:53:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB9A48E001E; Mon, 18 Aug 2025 05:53:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A8278E002D; Mon, 18 Aug 2025 05:53:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 842C18E001E
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 05:53:43 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 34B905B8CE
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 09:53:43 +0000 (UTC)
X-FDA: 83789416326.09.7B94670
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3ED5012000A
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 09:53:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=A07aaP0H;
	spf=pass (imf29.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755510821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7aUrhtA5C8N8LDrztESsi6kkNfyVuogrllyu5DxXOhU=;
	b=rotZBsPVeD9I+lFkrdmo4QnAXY5Yki8Fy/6S6UjmheI8NX/CuO7+faJMcB5Ff/7eKodbiY
	6LE2nwRXNvDjnnC40enWLpkUtlJ0QX+WS8L/Wp3ZX187QOXH09jFN+FkTgOlUkuf4i9U+5
	d5SX/Asl3DE5wlaF3qdrpjcm1RRnYeQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=A07aaP0H;
	spf=pass (imf29.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755510821; a=rsa-sha256;
	cv=none;
	b=r3+brA+QgpfzW8sLFXbq7LUZdRAyQeH5eca3M1S3t4hKZ34D/UospTuj1/N3bN97nnRkHR
	p4A6mfjD7WgOJmwwuTJWbLqBhWwQK3tDLXmbsB6WlHgLWpFsJ7b7lIhF0TWF+SMQFB4qkG
	1lJreXoCoQDigCRbU1ap1eYkbVxHUdk=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3b9d41c1149so3013790f8f.0
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755510819; x=1756115619; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7aUrhtA5C8N8LDrztESsi6kkNfyVuogrllyu5DxXOhU=;
        b=A07aaP0H8oNNcsQc6yECc0grkfl/FynbjJQvb89DboVwThG6aGR84HwcJDnT7E6xqu
         yk3OO34gj2hJqH3XI+tT1tM/6u0M94igOb6WB5p2mLo19lT0gTRJn63LNNepaBej0yV3
         YWcClBfvsw+E8v7ahPCozcRVs7D1p9m5nwPjXgNdoIIsuDuMfCGpUmdG8fH0Mf/vCrYV
         KH6rliFImIpu1U5CZqnvUDAqvSHt6kwYuI3bQ62m/VoURXhC2KVe8y2Xp7Wj9w2dGFCL
         kqAJ+0vh/UdbF/Q7hYzbVX4qQ6bF6Y6bZ91h/Izxqf4MzZ4Ex6SY6TuSFYfaIk/Ge4xA
         bu9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755510819; x=1756115619;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7aUrhtA5C8N8LDrztESsi6kkNfyVuogrllyu5DxXOhU=;
        b=DEMrRnb0y3GChDNW+6i/7JgE0l/4nbdId73ypGnw4xxLiZpgehPx9jZsmW4koXgyUf
         mRpugZkejbNWj1hD1rvicyjfI6cNlIhLpiOt+fxf+W/ZiZGXHo45DUyBw/JjXOOk1FTy
         LPIR42/jQQXV8/SNkM/RzoetSeM9G1+j9OB6Ox6/51rek03jI3o9ruoY/FZ4fRlBgtl1
         nJ/w/yxheK9vG74BpENgG5wlIafficoaKqkNaBPGTGw4LbcenNzT+6Qfjz/NS3s0/vKf
         cpUbR7l7fKhYzse4YdNQjsvHeX6+/sdoRNqg+bD/QoH5gc1s4VMt/xO12zjHF2mlxbe2
         RJkw==
X-Forwarded-Encrypted: i=1; AJvYcCWc2MmMFk2ubwPC4nL4KmQZ4qG12Z0+3I1GG8TYFhhsWDrNXdwp15qduUj5je+Q6GEJBsrpwXtsLA==@kvack.org
X-Gm-Message-State: AOJu0YwayqO+hv3HZmhtRzpdPzRuKy0+SF7mS1WSnEuta1G6DTflhWAD
	9Bfvmt6TJoibKGMf7XfCSV0XH+ci3vBYqVahzg2NcwCa+HILhLN21kfj/gm1CgGYdZ6E9z74s8v
	noVFjBzvijasOSs3sreJMyr8HYuaCw0Q=
X-Gm-Gg: ASbGncvK36nuAX06XpIwhaJyvWz3WMB0xy1TZqiZgJn9+mTcFhRJ4AcHM5pDm9muO6R
	fprpTGuCcGPLqbkcW41RF7ba80rt1AFQx/C0apaxnRaYqRhlFubmbjF47w+QUe+T/Hf+ncPB/nU
	e9W99ejuz2d38AZISXzm4Z4CqqKt7AovQ0MiPBVsv3vaeQ7/a64qFAWJe84XnO7hqaCZzaf/bpU
	n5iQCBReA==
X-Google-Smtp-Source: AGHT+IE5sWPnO2jWHmGFO9/uqaRATarRkbmdpoRmK2O7FZqlephlWzYr5r52Bl9rK+p5u8FdUbRUw0a6xAxNdaOOYWo=
X-Received: by 2002:a05:6000:2382:b0:3b7:664a:8416 with SMTP id
 ffacd0b85a97d-3bb672ef363mr7732028f8f.23.1755510819196; Mon, 18 Aug 2025
 02:53:39 -0700 (PDT)
MIME-Version: 1.0
References: <20250818075051.996764-1-yeoreum.yun@arm.com> <20250818075051.996764-2-yeoreum.yun@arm.com>
In-Reply-To: <20250818075051.996764-2-yeoreum.yun@arm.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Mon, 18 Aug 2025 11:53:26 +0200
X-Gm-Features: Ac12FXzRBfgg3LizE0EW60Q0iO4G5vgy9DjWhPtH5IcEjjDvGoLaCnutYA-AZ-c
Message-ID: <CA+fCnZcce88Sj=oAe-cwydu7Ums=wk2Ps=JZkz0RwO-M_DjfVQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] kasan/hw-tags: introduce kasan.write_only option
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
X-Stat-Signature: q1zeki48opzw9k9sen5bxmdk4kj43h9a
X-Rspam-User: 
X-Rspamd-Queue-Id: 3ED5012000A
X-Rspamd-Server: rspam05
X-HE-Tag: 1755510821-627600
X-HE-Meta: U2FsdGVkX1/15ayajnK1rkQCSInTgKzyLMW8hvoTRJNaS9WJNpSzlVk35YzZCsaM6KU4RARsdbQlHbsd5dmrtTzaRwFmtqBKDQyU9uSrt85Ko1OuP8EQpqUO9vA0YCl183ViiO+OtVjvVetSnFt6STInoRe5SbemgBmnm9wnklmLMYXE8Xb625/VMwvq7+9Lc+anHaaSduM2nWW2j+zmMNF7CAqx8/lv3CL+CRYuoz8gTlNT0uMpLN9cnGyGEf1D3FkJ39DxoaOGP61FEr8llIsus6m1jZaXgfavUEj7Wpy5eBoauK0pO321j7rTinOwNASP+gLX1XQu+wg51lPxK5CNd/lHf23btXwb1nZvwGPGuDzvr8IY9MiLMGm2ovSElPXpl4XhyyNX0R1B5ZJB46dC6d8Y7RHQmLI6rDnu2GiHehw2O6r53dPz866KOX4ko7voxH8I8aL0KY7gMYMSMlcfPP2sg5XQ1Hc/qt1K+/plIqAy++hqcjwFQifKmIVEUP1UTQc01G6szmFJst3x+mWWh7k0M/8+nYG52iudYHvxfRsXVyYNtb6FmbH1RWT8eI/rFv+mI3cpe7WiSnvLlgTlJ/uSBz9heFODBm/CigZNxPX9CNiYsw7RgkW3TMn7y9KzICjuoVs2O24qZThNOy/5QG75g6R+JgkPZmpWildVg6nsQGnhFykjGL3enGX8UhyR1a//MqohhoxVcG2B+mB1AnVaFbn30xW+6Vv/IJsKQgoWgYds2irZpcprz8S61UPu1aJZP7sksHFHMCxVatWUbP2YqsGKAEuQkxIh5vkzRzGd1do2qRdGHbuUv2zeD6SbGAz3lTlYFEl/foDcsq1pGLVSJq1PhqaYF95NhFNHSiOeI36/8XtA5whc3Eo6gb+XkZ8A8LzCfu3zy3G8Fl7u1FgTZ3xrPZeUumYonqfj6n2RVZaEa3Ea6o7+ZkmMhSOnh82KgM0+W+iwlau
 iPvAnZrY
 hOzVJmah3FlebsPe+TtIuzVfI87QITmLfZeyKtvPiJ6R+23Ddu240voCvIQq2C4XtIIChRCMCDPi3if+6Z927gF9l7IxpK4bvGoVRPPaLVUS9J+uZcYxE7S4j5iO65YE00q4EQiFjwmsi3IA6qufoJic6AoKt1Ziqn/E+J2Z/qn8VtKiyIkjBva49etFFe79MvFriv8pBsi/Xw8g2VkBK+ucFv+6gyEhHhy/b+xFX0LKxJHbTju+3HrDR679Fp8XYnluHEdhCip0jO7Ri1ilUhFwvJsG3+RB26zQ1PdeMgR2AQUIT6W7+KB7B75DhA9berkyukUYprtkMIPHANQwgSvjVfYL6LCOmIBbUjBmMrbny17zt4vigAhlQ8Cs8QsywkFX7spwWbCeH4CeSvsWrharbgcNh6Ctvk+aROKMzzWBgVajh3WPWlkciRl2oOQfhP/KT8rm41GY8Vb5i47L/eUA6TFWOZpqh9Kw/U5yrYt/eZK4gY02vOPvLQmNvMrECXYkTetswZ4Q5ZfCQgY3PrZoUO9VRbKNT9l23
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 18, 2025 at 9:51=E2=80=AFAM Yeoreum Yun <yeoreum.yun@arm.com> w=
rote:
>
> Since Armv8.9, FEATURE_MTE_STORE_ONLY feature is introduced to restrict
> raise of tag check fault on store operation only.
> Introcude KASAN write only mode based on this feature.
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
> ---
>  Documentation/dev-tools/kasan.rst  |  3 ++
>  arch/arm64/include/asm/memory.h    |  1 +
>  arch/arm64/include/asm/mte-kasan.h |  6 ++++
>  arch/arm64/kernel/cpufeature.c     |  2 +-
>  arch/arm64/kernel/mte.c            | 18 ++++++++++
>  mm/kasan/hw_tags.c                 | 54 ++++++++++++++++++++++++++++--
>  mm/kasan/kasan.h                   |  7 ++++
>  7 files changed, 88 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/dev-tools/kasan.rst b/Documentation/dev-tools/=
kasan.rst
> index 0a1418ab72fd..fe1a1e152275 100644
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
``)
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
> index 9ad065f15f1d..505bd56e21a2 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -2920,7 +2920,7 @@ static const struct arm64_cpu_capabilities arm64_fe=
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
> index e5e773844889..cd5452eb7486 100644
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
> +       pr_info_once("MTE: enabled stonly mode at EL1\n");
> +
> +       return 0;
> +}
>  #endif
>
>  #ifdef CONFIG_KASAN_HW_TAGS
> diff --git a/mm/kasan/hw_tags.c b/mm/kasan/hw_tags.c
> index 9a6927394b54..df67b48739b4 100644
> --- a/mm/kasan/hw_tags.c
> +++ b/mm/kasan/hw_tags.c
> @@ -41,9 +41,16 @@ enum kasan_arg_vmalloc {
>         KASAN_ARG_VMALLOC_ON,
>  };
>
> +enum kasan_arg_write_only {
> +       KASAN_ARG_WRITE_ONLY_DEFAULT,
> +       KASAN_ARG_WRITE_ONLY_OFF,
> +       KASAN_ARG_WRITE_ONLY_ON,
> +};
> +
>  static enum kasan_arg kasan_arg __ro_after_init;
>  static enum kasan_arg_mode kasan_arg_mode __ro_after_init;
>  static enum kasan_arg_vmalloc kasan_arg_vmalloc __initdata;
> +static enum kasan_arg_write_only kasan_arg_write_only __ro_after_init;
>
>  /*
>   * Whether KASAN is enabled at all.
> @@ -67,6 +74,8 @@ DEFINE_STATIC_KEY_FALSE(kasan_flag_vmalloc);
>  #endif
>  EXPORT_SYMBOL_GPL(kasan_flag_vmalloc);
>
> +static bool kasan_flag_write_only;
> +
>  #define PAGE_ALLOC_SAMPLE_DEFAULT      1
>  #define PAGE_ALLOC_SAMPLE_ORDER_DEFAULT        3
>
> @@ -141,6 +150,23 @@ static int __init early_kasan_flag_vmalloc(char *arg=
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
> +               kasan_arg_write_only =3D KASAN_ARG_WRITE_ONLY_OFF;
> +       else if (!strcmp(arg, "on"))
> +               kasan_arg_write_only =3D KASAN_ARG_WRITE_ONLY_ON;
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
> @@ -257,15 +283,26 @@ void __init kasan_init_hw_tags(void)
>                 break;
>         }
>
> +       switch (kasan_arg_write_only) {
> +       case KASAN_ARG_WRITE_ONLY_DEFAULT:

Let's keep this part similar to the other parameters for consistency:

/* Default is specified by kasan_flag_write_only definition. */
break;

> +       case KASAN_ARG_WRITE_ONLY_OFF:
> +               kasan_flag_write_only =3D false;
> +               break;
> +       case KASAN_ARG_WRITE_ONLY_ON:
> +               kasan_flag_write_only =3D true;
> +               break;
> +       }
> +
>         kasan_init_tags();
>
>         /* KASAN is now initialized, enable it. */
>         static_branch_enable(&kasan_flag_enabled);
>
> -       pr_info("KernelAddressSanitizer initialized (hw-tags, mode=3D%s, =
vmalloc=3D%s, stacktrace=3D%s)\n",
> +       pr_info("KernelAddressSanitizer initialized (hw-tags, mode=3D%s, =
vmalloc=3D%s, stacktrace=3D%s, write_only=3D%s\n",
>                 kasan_mode_info(),
>                 str_on_off(kasan_vmalloc_enabled()),
> -               str_on_off(kasan_stack_collection_enabled()));
> +               str_on_off(kasan_stack_collection_enabled()),
> +               str_on_off(kasan_arg_write_only));
>  }
>
>  #ifdef CONFIG_KASAN_VMALLOC
> @@ -392,6 +429,13 @@ void kasan_enable_hw_tags(void)
>                 hw_enable_tag_checks_asymm();
>         else
>                 hw_enable_tag_checks_sync();
> +
> +       if (kasan_arg_write_only =3D=3D KASAN_ARG_WRITE_ONLY_ON &&

We already set kasan_flag_write_only by this point, right? Let's check
that one then.

> +           hw_enable_tag_checks_write_only()) {
> +               kasan_arg_write_only =3D=3D KASAN_ARG_WRITE_ONLY_OFF;

Typo in =3D=3D in the line above. But also I think we can just drop the
line: kasan_arg_write_only is KASAN_ARG_WRITE_ONLY_ON after all, it's
just not supported and thus kasan_flag_write_only is set to false to
reflect that.

> +               kasan_flag_write_only =3D false;
> +               pr_warn_once("System doesn't support write-only option. D=
isable it\n");

Let's do pr_err like the rest of KASAN code. And:

pr_err_once("write-only mode is not supported and thus not enabled\n");



> +       }
>  }
>
>  #if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
> @@ -404,4 +448,10 @@ VISIBLE_IF_KUNIT void kasan_force_async_fault(void)
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
> index 129178be5e64..c1490136c96b 100644
> --- a/mm/kasan/kasan.h
> +++ b/mm/kasan/kasan.h
> @@ -428,6 +428,7 @@ static inline const void *arch_kasan_set_tag(const vo=
id *addr, u8 tag)
>  #define hw_enable_tag_checks_sync()            arch_enable_tag_checks_sy=
nc()
>  #define hw_enable_tag_checks_async()           arch_enable_tag_checks_as=
ync()
>  #define hw_enable_tag_checks_asymm()           arch_enable_tag_checks_as=
ymm()
> +#define hw_enable_tag_checks_write_only()      arch_enable_tag_checks_wr=
ite_only()
>  #define hw_suppress_tag_checks_start()         arch_suppress_tag_checks_=
start()
>  #define hw_suppress_tag_checks_stop()          arch_suppress_tag_checks_=
stop()
>  #define hw_force_async_tag_fault()             arch_force_async_tag_faul=
t()
> @@ -437,11 +438,17 @@ static inline const void *arch_kasan_set_tag(const =
void *addr, u8 tag)
>                         arch_set_mem_tag_range((addr), (size), (tag), (in=
it))
>
>  void kasan_enable_hw_tags(void);
> +bool kasan_write_only_enabled(void);

This should go next to kasan_force_async_fault().

>
>  #else /* CONFIG_KASAN_HW_TAGS */
>
>  static inline void kasan_enable_hw_tags(void) { }
>
> +static inline bool kasan_write_only_enabled(void)
> +{
> +       return false;
> +}

And this too.


> +
>  #endif /* CONFIG_KASAN_HW_TAGS */
>
>  #if defined(CONFIG_KASAN_SW_TAGS) || defined(CONFIG_KASAN_HW_TAGS)
> --
> LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}
>

