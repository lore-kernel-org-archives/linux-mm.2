Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E30CCA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 20:14:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 714B06B0025; Thu, 28 Aug 2025 16:14:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EB696B0029; Thu, 28 Aug 2025 16:14:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 601FA6B002B; Thu, 28 Aug 2025 16:14:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4C8056B0025
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:14:45 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0295D1A0391
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 20:14:44 +0000 (UTC)
X-FDA: 83827269330.13.4DC957D
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf02.hostedemail.com (Postfix) with ESMTP id 12BE680010
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 20:14:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=N4IDl0HH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756412083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1gnvrp+Bx3ZYJFKBzNh94mqis3ow5fvVnk0m91vI1jw=;
	b=MQsuQvNzLCr3bUct5EcuKd6j86iWB8kX4zI2rXruX9xyKGIOD2CXoXBMMjXMnsN9Rb4CSr
	FJ5LjCBh9AluyBvz9kJ8JFdmKkoz7CEJC928gxXsMkAcZQjz1AZq/JHIGiLog20Oq3tYTa
	k+PyIq36rVIRfenI+7cx1/OFmQH69Cc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=N4IDl0HH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756412083; a=rsa-sha256;
	cv=none;
	b=i129CMHIOmVmdZkguqpIti6XZ69xvPedtAY2mgjwg1fbMq9KuEbgD4KswwVZ/gm7j98KVR
	3LKgyXQgbf81T3ZCGQHzp6zbkOY44+GjQ0sYYRWKqy7D0x/GQESsvm4Jk8FpriHSA+w8F8
	eGhIDHdLdO0zsucrORVrHn4F2wnTc9E=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-45b55ed86b9so7906425e9.0
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 13:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756412081; x=1757016881; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1gnvrp+Bx3ZYJFKBzNh94mqis3ow5fvVnk0m91vI1jw=;
        b=N4IDl0HH2munZ/O6ngPWhi8lBcdW2ZaYa7ZzVEQzflM2O+OC85Ck13YPTMc6NWncO5
         34T/sYoiHnuSV9uQIKzaD65JjdrUKMeG5Qxul8yYXaD1qxpAzTu04/OwkjpblRGQiFxz
         avrFTZ7XLnHJhUiazDphjsHCnywBEnKdJkxj5k2CDcV9n3vNTfEF8V+adaoxW6qb9l34
         6zaQ559xJw3OMxJuHgI9T1UurMA4v7MfvQNknx4sR75gtTkbrPc3lgJpt3jGdZtS1vVt
         XjSrbytPQ8WJSoLnEBmWfdBAi/jPFtF5jxOnX5B2DRVaGEr3DkI+jj6euuYUG3e0++/5
         Aj7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756412081; x=1757016881;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1gnvrp+Bx3ZYJFKBzNh94mqis3ow5fvVnk0m91vI1jw=;
        b=dS/PkabaIQQHL7KEj3bp6vcvEqOCL0CfsCwX5X6owiZz9JqSwWTlGgwkwcxcPX4OLj
         YNjE6+xRX9/tJ8Pmpwn0sexawhybe0cFl0PH6VryZZNU2RKYBgBCHAwKKV8r7xE0NdEY
         o/H1OOpH2eUuNi1fCriWsWO8z2wKPisGM/BPUkmK55CBmC7nazj2GseIPEqZDL39JGIO
         OdMpD3AqT1xP1L/KNrCnS32822kuoWS08uWcNgsqDZBFPI2QHo4A69iWsTjppDvxT2qP
         voVZJ3OehdM34CpucNVB/TNhmOXSGL3rFLde/jAciJkuwTCioVyNWso8GxBlPN+OkEac
         yvCg==
X-Forwarded-Encrypted: i=1; AJvYcCWdQlix8DnY6thQOuhiABMrIVq5Jz5BNAuidQkan0c31MPXPWeT1SNK7pvrltsXgT07m88cD9NUwg==@kvack.org
X-Gm-Message-State: AOJu0YxwTyFJ+U1X1AynqV2d/8qRLiGQfhWbq2HGeU4H0c5O2jTRR415
	gD5717v0jco2wn1q2zdrVi7KUibAf4BffGerlmJN0c95nH8k31vWtEdKqR1wYDgu0mKcBkA4XD+
	c7mVOX6AsEQGgsmkXVZU6WIptFf3W51c=
X-Gm-Gg: ASbGnctE8a8ROSZaltHI94EC75+mXtK8683M3/xspriBaw5ojK0Whb3/nz7N02Nnbqi
	cjU+GcaTPG1hQLS+LTHddMpX8kkFPXrDQ40xwBq6idrXRVB5AR8GbMFQ0QCq/mKwKaNc+R9otd8
	nPaKDpyR6MSRjD58pj2wqWvqECd8VuTzefc4nXce882ohAlkslbMnbANMOp9oD8f98oqtL4txRZ
	Zy+0zkiwFYh9f+Ml+WOVGt1yBybxZo=
X-Google-Smtp-Source: AGHT+IGkMoq8h0tkXujVtGDFS8K8ZzpaXHvOixuVaujtWP0Wkn9zIKEQpxZ+6u9akm/7cu9i2UZVR/zTm0+xUXb1N/o=
X-Received: by 2002:a05:600c:4683:b0:458:bfb1:1fc7 with SMTP id
 5b1f17b1804b1-45b5179cc59mr217845785e9.6.1756412081217; Thu, 28 Aug 2025
 13:14:41 -0700 (PDT)
MIME-Version: 1.0
References: <20250820071243.1567338-1-yeoreum.yun@arm.com> <20250820071243.1567338-2-yeoreum.yun@arm.com>
In-Reply-To: <20250820071243.1567338-2-yeoreum.yun@arm.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Thu, 28 Aug 2025 22:14:29 +0200
X-Gm-Features: Ac12FXyhL3jNKGMqxsJ0nOjlFtUtP70OOH_yRbqkrkgUfzCeogdUcj5xo329MPY
Message-ID: <CA+fCnZfv6G19P=bWqEUpbA36E9zaHBqDBZyDYV5YnMuAX1zGug@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] kasan/hw-tags: introduce kasan.write_only option
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
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 12BE680010
X-Stat-Signature: tim1iqqfs96hneezwxsgn5rkk9hs7whk
X-Rspam-User: 
X-HE-Tag: 1756412082-480235
X-HE-Meta: U2FsdGVkX181PkCM1vGDXDwOKehYL1ivrfy/W2ZwG1m1tlNiY0ZEpeyZRiffAyU3ZlOLl0JlvbTqW5W4aQjwp/J9rnDxdYpuiGamYkK4tSXXg6JBskpmIx3LJ1WIOFNjLUghCS9phSrmnx46dI/Y4PR6zzSSIsUW2wcGVZAFsthtWgDLXrZv6+pOlBauvtSajm124uxWkyAz3rVU3LqMN4RAjB/qEp7A/ZEC3xCz2a00eiKLRhiogNk+mziDrCH4WE4eFRC2mpgZegsFcof8LC9mEHcj0111u0eSBsi0/qcmay7LmdU770OSyezgQsePamAzOpMaTzk5Mg8spyu7i615np6LVp5fqVldRXLEEB5/aZgbsWCYcWqbNZKXc2/XNYEM2pWmVSX3cBdhYz8dN+/JOd1Voyi5luVdHVktc5oOOBRPDSjCCEkTWSYitL/WQKIix/cyDVT9NMBUz1soepuOiCwjdMXCIOPZyMN+RXFo8SI1zPUGeF4VmAZgEOnP397LMHOs8kgemL26NKWm0kbjPua1IXW4fZg04d9riP0pSKd8tQv/3/futbaSttsQ0T3VYSv8YXYf5/efLeo9y4AIT4RLckAy6Ake35vmUn55+42wgYPnBIUTOqEx3uhX+bPErlktKvd7rAjJ62lIWMQvRtsgQa4Pjrw/FHeFNctTrX4EyUwS/HHyjRaQCxHgMOR3/lG65LJhb4vVir5tViRLQjGERcb7ju8Xb1Y19aJ21LkReQZlLGo7/Kit8pokIRKiyJ0UClI/T85dlcRtVdquB5jTCN/lLHDO6lquMpTGlLPnUy10oYrEDk7hhCFkQcpqN6A03g8Epg+qXK8MrwRRUDRl3k3bxQxhS+PdpHkV0D3Cae6bO8hW6LfiOXo8POzplwpYI4pwDjtbCu9/wNm+Q2scCXEDrUJgSF0fj7Y39F3ow24K9oCh6Q+Ngh/qQJZSzAIsD2AtH4g58KB
 Oa9Dqcdo
 bFFtWwI2QYa+/43/kZCYGbyZVeqdkdpDYErbB8B0D27hWzrr71hNV1AQn+4Dgs2LGqzDSewcQh01udRbio/Q/FspGHq6WKAphlTEWnm+A3Oew35Bq/158gP+HRQQGiAzjGOFKRvlt2GyiaWnhHSFsD+muIimljq/49cSA9n7IUyqr1LBty9yzABOAB9S/nkW64DbcbmB7qO+9uFCf389bib2p5QbNEdmbtnv+Dx4XVFQ3xdgSoML7p0ATfE55vWg8NXnTIOUI1dlpzknjyblMMSpWvFX8HmBPAT3lnTe/rPh1/juE6vM73eXVnbYthGw+u0+C0Es3Sq3fMAOvPFgcy7Ty7ENFr29lO3EgYQhzQrfP0xlTh0ALDi+DRkxzxZf8DXszSAqVVJlVLPtsyKgViz6IXZXAfdEmJrco+1v2GebZ0MEgpIpGS/52ByO7IOinKyxoHIwcsoFCm81QzKU4NiFsO0wHLBPkMMr3z1NdJXwVHTI8UYTfGoFyc+eeaneeMAhazmfZauL19SJ86Y5UF2Jt3LDSGgt00PGb+R65K5No/pIHP3LqEwv+nw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 20, 2025 at 9:12=E2=80=AFAM Yeoreum Yun <yeoreum.yun@arm.com> w=
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
>  arch/arm64/include/asm/mte-kasan.h |  6 +++
>  arch/arm64/kernel/cpufeature.c     |  2 +-
>  arch/arm64/kernel/mte.c            | 18 ++++++++
>  mm/kasan/hw_tags.c                 | 70 +++++++++++++++++++++++++++++-
>  mm/kasan/kasan.h                   |  7 +++
>  7 files changed, 104 insertions(+), 3 deletions(-)
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

Nit: a dot missing at the end of the sentence.

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
> index 9a6927394b54..334e9e84983e 100644
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
> @@ -67,6 +74,9 @@ DEFINE_STATIC_KEY_FALSE(kasan_flag_vmalloc);
>  #endif
>  EXPORT_SYMBOL_GPL(kasan_flag_vmalloc);
>
> +/* Whether to check write access only. */

Nit: access =3D> accesses

> +static bool kasan_flag_write_only =3D false;
> +
>  #define PAGE_ALLOC_SAMPLE_DEFAULT      1
>  #define PAGE_ALLOC_SAMPLE_ORDER_DEFAULT        3
>
> @@ -141,6 +151,23 @@ static int __init early_kasan_flag_vmalloc(char *arg=
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
> @@ -257,15 +284,28 @@ void __init kasan_init_hw_tags(void)
>                 break;
>         }
>
> +       switch (kasan_arg_write_only) {
> +       case KASAN_ARG_WRITE_ONLY_DEFAULT:
> +               /* Default is specified by kasan_flag_write_only definiti=
on. */
> +               break;
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
> @@ -392,6 +432,26 @@ void kasan_enable_hw_tags(void)
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
> +        * finds the feature unsupported, kasan_arg_write_only is set to =
OFF
> +        * to avoid further unnecessary calls on other CPUs.
> +        *
> +        * Although this could be tracked with a single variable, both
> +        * kasan_arg_write_only (boot argument) and kasan_flag_write_only
> +        * (hardware state) are kept separate, consistent with other opti=
ons.
> +        */
> +       if (kasan_arg_write_only =3D=3D KASAN_ARG_WRITE_ONLY_ON &&
> +           hw_enable_tag_checks_write_only()) {
> +               kasan_arg_write_only =3D KASAN_ARG_WRITE_ONLY_OFF;
> +               kasan_flag_write_only =3D false;
> +               pr_err_once("write-only mode is not supported and thus no=
t enabled\n");
> +       }
>  }
>
>  #if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
> @@ -404,4 +464,10 @@ VISIBLE_IF_KUNIT void kasan_force_async_fault(void)
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

For the KASAN parts:

Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>

Thank you!

