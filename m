Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 492C5CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 05:03:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BBD49000EC; Thu, 14 Aug 2025 01:03:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99383900088; Thu, 14 Aug 2025 01:03:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A9B99000EC; Thu, 14 Aug 2025 01:03:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 74BCC900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 01:03:50 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F3CB682A68
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 05:03:49 +0000 (UTC)
X-FDA: 83774170578.13.BF752FE
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf28.hostedemail.com (Postfix) with ESMTP id 222E7C0007
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 05:03:47 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LDDU+Xo4;
	spf=pass (imf28.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755147828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pW2IKQF7j9mZWFismjJbM7MyE155/GaGBWF52ohr4tg=;
	b=66iUHad+EsH58luANUIUGpVHjk1dH5HM5WqOU8xQI5vb9LWdL531K5cL14O9ogMU58ycI9
	BBKKbltzYvtUH10kO6vrKIB89nTMtLyrv1WIM1tEqXZo3JMDIzdmXm9lN//YmTJq6hYbKZ
	rKwZdLHWSvAqRYD7Y+cCgsJrYlwOpEo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LDDU+Xo4;
	spf=pass (imf28.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755147828; a=rsa-sha256;
	cv=none;
	b=6q+J8Vnhm2AaQsQfQsgzjgozV+5wtqnOi0RxFuTpYwPfcVdPCLUQtVF/uG/hlCU2OQRlYG
	D5BTcR/C0fpdSO/kffMnZ8Bp6sOwc8ttVqsZI+DuWdwCdHzQ0g+juzaTu9JXR1kcra3hGY
	qFnqqdYIeMD0ptfWcMYaq9PYVjYgAVw=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3b9edf504e6so240949f8f.3
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 22:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755147826; x=1755752626; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pW2IKQF7j9mZWFismjJbM7MyE155/GaGBWF52ohr4tg=;
        b=LDDU+Xo4SjdutxPRSxSfzYSTYT4L1Y+f7UZKA+JQg5UGxDCIoGdSWZS3G1uYqsqvbR
         dgJWR4XGk5fvLKjXMlyQHnf8uFz/orNZHPHTO4pNmOW/MjvuYcZkggC5Z/KUObPs2LUv
         6vZsxQr6ucq3drprLU7UV6wOiI6OnZnYFoUe4E5bQ6+VHRJHzZDj+D4BvRElKsNW6k+d
         YtyfzeqBBtEfzbG8te04BrgnEqdbGPtWzXhsuOTIvUZvcTJHZnCTUGYBcfjYUpg55JlR
         6KdzfJogqNaa+NPZEKTVG99wnRd6kBbqvJhYGxWaIeDX1E7UqKz7plB+ZoAhpydsIWjc
         xNcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755147826; x=1755752626;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pW2IKQF7j9mZWFismjJbM7MyE155/GaGBWF52ohr4tg=;
        b=hi1u+FF3693zzkZsPoe43l0b3oSl7CVizHpVXt5VYYV3iMYhRzULtfSmTGtBUssjyc
         f+FTJ71kBlkAAQ3mdu6oalbBuXUCNKYCoTQfnt7Xbu06SrZqlU/QHNEKptdHWE7bkX9r
         ScA+4m38C5SKSXeMenJU3sUChlUKkUjKJT20xglCci3Lq5aLyEjNv+Cf7PDmJqaHbNC4
         Wikdfq8SVJmmpMPMyw9Xo98XuzafsHQZqWRL/drAstpPgbN5nOEpou2VobMHgAg3kSsx
         byfz1578Y+mGUYcxBYYu5cj+4Y/qeeyswgdS+Om1JvzgtSmaIDz7guvmAI9xHiiXhkk4
         WrCA==
X-Forwarded-Encrypted: i=1; AJvYcCWAfMFZIEltQhP27DRqMUn/x+TBspyXaCwh7212JdPyA6W7VZFR5DLJyLmrmyjzi2d3w9xCiEdj+w==@kvack.org
X-Gm-Message-State: AOJu0Yx/turi8gk+lr9bK4juEMcAZYnmC2K6NqsQMusNACQ9fQm6bbQV
	4UyxwXgPl1F7Eik3Arv3n/zmBR/y7dkGfao+6FvCGSHpNSPURar7aLCE4PIJBVGZt6crgO6yuPo
	w9FRBv4MwyPeQVQBqU/bhB7+3VdM7xlg=
X-Gm-Gg: ASbGncuOYgA2Pd33mM4Ho5jcq2dvSyw2IjQUoNj3CRjiKwdrhW8pbusgH0mgJGuhtIJ
	m8oaMuRkac7PNn2nsl+Wy1OfnCCSCgdC1LnXwZucoeVUpYWBW76rpoKp9xsief8g1Kz/2PPnn8R
	XVmGhnSgTwelj+n0hi5jnxtYNrOfLm+A7l2hsThKVqK8Z/FsvHMypLrG+S51R0z2qSX3cy9D8kA
	7sLrs1yNw==
X-Google-Smtp-Source: AGHT+IEqGsCznIdsWiUNkmTT/k6ovR9nMFnO5FAhQ2CUZuGmxYnJakxuzLCMBAdtiX4aOx5ItmFn7auMNRJz0+3OENI=
X-Received: by 2002:a05:6000:24ca:b0:3a6:d93e:5282 with SMTP id
 ffacd0b85a97d-3b9edf7fdcbmr1203348f8f.59.1755147826108; Wed, 13 Aug 2025
 22:03:46 -0700 (PDT)
MIME-Version: 1.0
References: <20250813175335.3980268-1-yeoreum.yun@arm.com> <20250813175335.3980268-2-yeoreum.yun@arm.com>
In-Reply-To: <20250813175335.3980268-2-yeoreum.yun@arm.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Thu, 14 Aug 2025 07:03:35 +0200
X-Gm-Features: Ac12FXxBGO26NYRCWV_AgLObziM7IFpY6wdJZ5x9xu9uGkMLHTUun4-BDhxGOCU
Message-ID: <CA+fCnZd=EQ+5b=rBQ66LkJ3Bz2GrKHvnYk0DQLbs=o9=k0C69g@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] kasan/hw-tags: introduce kasan.store_only option
To: Yeoreum Yun <yeoreum.yun@arm.com>, glider@google.com, Marco Elver <elver@google.com>
Cc: ryabinin.a.a@gmail.com, dvyukov@google.com, vincenzo.frascino@arm.com, 
	corbet@lwn.net, catalin.marinas@arm.com, will@kernel.org, 
	akpm@linux-foundation.org, scott@os.amperecomputing.com, jhubbard@nvidia.com, 
	pankaj.gupta@amd.com, leitao@debian.org, kaleshsingh@google.com, 
	maz@kernel.org, broonie@kernel.org, oliver.upton@linux.dev, 
	james.morse@arm.com, ardb@kernel.org, hardevsinh.palaniya@siliconsignals.io, 
	david@redhat.com, yang@os.amperecomputing.com, kasan-dev@googlegroups.com, 
	workflows@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 222E7C0007
X-Rspamd-Server: rspam06
X-Stat-Signature: 5fzm6zre4j5zsic3ra8y4eygan5y5gnh
X-HE-Tag: 1755147827-775459
X-HE-Meta: U2FsdGVkX1/7OXLxMT1MWmdCaEuKj1fnIhRIR2ryHf7CpWmErKe9qPk5Xfy/tbXnAR+iNdFQVkeSc5pcAwg8EuKvBhfK5lW5GArn1daoA+4QA2iGuVOkeHy3oYEjcAFtDJvoS/PAE0DHLpdgsZrn2Rs3JhYj8mfnb+0DbkDGYcW1KztFinTmXHiCIK+8aRI0weoD0pWXtfpSNY+ubeIDTRNGemdA9NQahsA0ji+xuuG8F6DqjMmkT/DVuPlZo6z6pbW0KJP8GXrM2XkQ5tLGyzGlnZUa/mDHZfWm3TnMrsGr+2pDImEEpQ/SZhc08GdJM3N0CUJ/a1CiIRFLww5Q/PPS4PaS+xQHFmZbR34+b/DJljgpAYCW/IkjcDCa9AdTsgz6Gxt+Gxc7ilbK9g2c4+obIruEj8Kq3VKuEzN69k/ShmH5OIY7DQpbGb2ISEQoLKO2heN9ftQbMcKEIiVHyW6NL9c5McoQWT1aq2XsskJiTmisWm/JTb/+NEJIl7Jy3LuyVA5F+ccubO/Q+GLhvzZxELmhzJoyLZ3zA3RQkgw8v6jV11pBM45UkUqyL4STtVBwkZdkyFMQOcESCyOwrMMIrqrscwYzIBGrfXVnpZzyr3MSIZsym7NerabEGZep0MWIhZIi7O+tmgARBugEDWDRA8QtrSk++ZlwmIFXuOYcAzMqe7GyI3avJq8PK8wjz1Y/YJv1zlOKwwvb/aBZ7nIM2avaTEbK5wddZDFCp6KKZbZ0J+WQ8dKj2wudUTFH/sObRfEp1wUx4LdmAf+ULqDTtSAeeSdZsgjONpnsR3G+zhmoiIGBeKMF9NKLfpGPXa78ujCgkDKhCO7oZSMiLAbj3xwiseOML6d8KyMD3lneYd9X8PIm95RCKkBMNdmLgyO8fqc+DFleHDPi2R4PXlze6/8G5EtGFXfvcP/wzbNmEZ2x4RwGf0n9LgFly3hoNR5JxWWbnSusfYzFHL9
 3c6W4gCq
 iaTQkEXG+gnPmje0BRXf9C6jEyIZIfONgPkJq6PSC5J/qY4dpTuVltjHo5IeOIiIevsA+OKzmcp5Q2eWd1sjmTIEPMAzSTc/1vbvyM5c/Ixc/1cur9mzQCw5jEi3zxL+YhYLBN9wG8+5olMk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13, 2025 at 7:53=E2=80=AFPM Yeoreum Yun <yeoreum.yun@arm.com> w=
rote:
>
> Since Armv8.9, FEATURE_MTE_STORE_ONLY feature is introduced to restrict
> raise of tag check fault on store operation only.
> Introcude KASAN store only mode based on this feature.
>
> KASAN store only mode restricts KASAN checks operation for store only and
> omits the checks for fetch/read operation when accessing memory.
> So it might be used not only debugging enviroment but also normal
> enviroment to check memory safty.
>
> This features can be controlled with "kasan.store_only" arguments.
> When "kasan.store_only=3Don", KASAN checks store only mode otherwise
> KASAN checks all operations.

I'm thinking if we should name this "kasan.write_only" instead of
"kasan.store_only". This would align the terms with the
"kasan.fault=3Dpanic_on_write" parameter we already have. But then it
would be different from "FEATURE_MTE_STORE_ONLY", which is what Arm
documentation uses (right?).

Marco, Alexander, any opinion?

>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>  Documentation/dev-tools/kasan.rst  |  3 ++
>  arch/arm64/include/asm/memory.h    |  1 +
>  arch/arm64/include/asm/mte-kasan.h |  6 +++
>  arch/arm64/kernel/cpufeature.c     |  6 +++
>  arch/arm64/kernel/mte.c            | 14 ++++++
>  include/linux/kasan.h              |  2 +
>  mm/kasan/hw_tags.c                 | 76 +++++++++++++++++++++++++++++-
>  mm/kasan/kasan.h                   | 10 ++++
>  8 files changed, 116 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/dev-tools/kasan.rst b/Documentation/dev-tools/=
kasan.rst
> index 0a1418ab72fd..fcb70dd821ec 100644
> --- a/Documentation/dev-tools/kasan.rst
> +++ b/Documentation/dev-tools/kasan.rst
> @@ -143,6 +143,9 @@ disabling KASAN altogether or controlling its feature=
s:
>    Asymmetric mode: a bad access is detected synchronously on reads and
>    asynchronously on writes.
>
> +- ``kasan.store_only=3Doff`` or ``kasan.store_only=3Don`` controls wheth=
er KASAN
> +  checks the store (write) accesses only or all accesses (default: ``off=
``)
> +
>  - ``kasan.vmalloc=3Doff`` or ``=3Don`` disables or enables tagging of vm=
alloc
>    allocations (default: ``on``).
>
> diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/mem=
ory.h
> index 5213248e081b..ae29cd3db78d 100644
> --- a/arch/arm64/include/asm/memory.h
> +++ b/arch/arm64/include/asm/memory.h
> @@ -308,6 +308,7 @@ static inline const void *__tag_set(const void *addr,=
 u8 tag)
>  #define arch_enable_tag_checks_sync()          mte_enable_kernel_sync()
>  #define arch_enable_tag_checks_async()         mte_enable_kernel_async()
>  #define arch_enable_tag_checks_asymm()         mte_enable_kernel_asymm()
> +#define arch_enable_tag_checks_store_only()    mte_enable_kernel_store_o=
nly()
>  #define arch_suppress_tag_checks_start()       mte_enable_tco()
>  #define arch_suppress_tag_checks_stop()                mte_disable_tco()
>  #define arch_force_async_tag_fault()           mte_check_tfsr_exit()
> diff --git a/arch/arm64/include/asm/mte-kasan.h b/arch/arm64/include/asm/=
mte-kasan.h
> index 2e98028c1965..3e1cc341d47a 100644
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
> +static inline int mte_enable_kenrel_store_only(void)

Typo in the function name. Please build/boot test without MTE/KASAN enabled=
.

> +{
> +       return -EINVAL;
> +}
> +
>  #endif /* CONFIG_ARM64_MTE */
>
>  #endif /* __ASSEMBLY__ */
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeatur=
e.c
> index 9ad065f15f1d..7b724fcf20a7 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -2404,6 +2404,11 @@ static void cpu_enable_mte(struct arm64_cpu_capabi=
lities const *cap)
>
>         kasan_init_hw_tags_cpu();
>  }
> +
> +static void cpu_enable_mte_store_only(struct arm64_cpu_capabilities cons=
t *cap)
> +{
> +       kasan_late_init_hw_tags_cpu();
> +}
>  #endif /* CONFIG_ARM64_MTE */
>
>  static void user_feature_fixup(void)
> @@ -2922,6 +2927,7 @@ static const struct arm64_cpu_capabilities arm64_fe=
atures[] =3D {
>                 .capability =3D ARM64_MTE_STORE_ONLY,
>                 .type =3D ARM64_CPUCAP_SYSTEM_FEATURE,
>                 .matches =3D has_cpuid_feature,
> +               .cpu_enable =3D cpu_enable_mte_store_only,
>                 ARM64_CPUID_FIELDS(ID_AA64PFR2_EL1, MTESTOREONLY, IMP)
>         },
>  #endif /* CONFIG_ARM64_MTE */
> diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
> index e5e773844889..8eb1f66f2ccd 100644
> --- a/arch/arm64/kernel/mte.c
> +++ b/arch/arm64/kernel/mte.c
> @@ -157,6 +157,20 @@ void mte_enable_kernel_asymm(void)
>                 mte_enable_kernel_sync();
>         }
>  }
> +
> +int mte_enable_kernel_store_only(void)
> +{
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
> diff --git a/include/linux/kasan.h b/include/linux/kasan.h
> index 890011071f2b..28951b29c593 100644
> --- a/include/linux/kasan.h
> +++ b/include/linux/kasan.h
> @@ -552,9 +552,11 @@ static inline void kasan_init_sw_tags(void) { }
>  #ifdef CONFIG_KASAN_HW_TAGS
>  void kasan_init_hw_tags_cpu(void);
>  void __init kasan_init_hw_tags(void);
> +void kasan_late_init_hw_tags_cpu(void);
>  #else
>  static inline void kasan_init_hw_tags_cpu(void) { }
>  static inline void kasan_init_hw_tags(void) { }
> +static inline void kasan_late_init_hw_tags_cpu(void) { }
>  #endif
>
>  #ifdef CONFIG_KASAN_VMALLOC
> diff --git a/mm/kasan/hw_tags.c b/mm/kasan/hw_tags.c
> index 9a6927394b54..c2f90c06076e 100644
> --- a/mm/kasan/hw_tags.c
> +++ b/mm/kasan/hw_tags.c
> @@ -41,9 +41,16 @@ enum kasan_arg_vmalloc {
>         KASAN_ARG_VMALLOC_ON,
>  };
>
> +enum kasan_arg_store_only {
> +       KASAN_ARG_STORE_ONLY_DEFAULT,
> +       KASAN_ARG_STORE_ONLY_OFF,
> +       KASAN_ARG_STORE_ONLY_ON,
> +};
> +
>  static enum kasan_arg kasan_arg __ro_after_init;
>  static enum kasan_arg_mode kasan_arg_mode __ro_after_init;
>  static enum kasan_arg_vmalloc kasan_arg_vmalloc __initdata;
> +static enum kasan_arg_store_only kasan_arg_store_only __ro_after_init;
>
>  /*
>   * Whether KASAN is enabled at all.
> @@ -67,6 +74,9 @@ DEFINE_STATIC_KEY_FALSE(kasan_flag_vmalloc);
>  #endif
>  EXPORT_SYMBOL_GPL(kasan_flag_vmalloc);
>
> +DEFINE_STATIC_KEY_FALSE(kasan_flag_store_only);

Is there a reason to have this as a static key? I think a normal
global bool would work, just as a normal variable works for
kasan_mode.

> +EXPORT_SYMBOL_GPL(kasan_flag_store_only);
> +
>  #define PAGE_ALLOC_SAMPLE_DEFAULT      1
>  #define PAGE_ALLOC_SAMPLE_ORDER_DEFAULT        3
>
> @@ -141,6 +151,23 @@ static int __init early_kasan_flag_vmalloc(char *arg=
)
>  }
>  early_param("kasan.vmalloc", early_kasan_flag_vmalloc);
>
> +/* kasan.store_only=3Doff/on */
> +static int __init early_kasan_flag_store_only(char *arg)
> +{
> +       if (!arg)
> +               return -EINVAL;
> +
> +       if (!strcmp(arg, "off"))
> +               kasan_arg_store_only =3D KASAN_ARG_STORE_ONLY_OFF;
> +       else if (!strcmp(arg, "on"))
> +               kasan_arg_store_only =3D KASAN_ARG_STORE_ONLY_ON;
> +       else
> +               return -EINVAL;
> +
> +       return 0;
> +}
> +early_param("kasan.store_only", early_kasan_flag_store_only);
> +
>  static inline const char *kasan_mode_info(void)
>  {
>         if (kasan_mode =3D=3D KASAN_MODE_ASYNC)
> @@ -219,6 +246,20 @@ void kasan_init_hw_tags_cpu(void)
>         kasan_enable_hw_tags();
>  }
>
> +/*
> + * kasan_late_init_hw_tags_cpu_post() is called for each CPU after
> + * all cpus are bring-up at boot.

"CPUs"
"brought up"

And please spell-check other comments.

> + * Not marked as __init as a CPU can be hot-plugged after boot.
> + */
> +void kasan_late_init_hw_tags_cpu(void)
> +{
> +       /*
> +        * Enable stonly mode only when explicitly requested through the =
command line.

"store-only"

> +        * If system doesn't support, kasan checks all operation.

"If the system doesn't support this mode, KASAN will check both load
and store operations."

> +        */
> +       kasan_enable_store_only();
> +}
> +
>  /* kasan_init_hw_tags() is called once on boot CPU. */
>  void __init kasan_init_hw_tags(void)
>  {
> @@ -257,15 +298,28 @@ void __init kasan_init_hw_tags(void)
>                 break;
>         }
>
> +       switch (kasan_arg_store_only) {
> +       case KASAN_ARG_STORE_ONLY_DEFAULT:
> +               /* Default is specified by kasan_flag_store_only definiti=
on. */
> +               break;
> +       case KASAN_ARG_STORE_ONLY_OFF:
> +               static_branch_disable(&kasan_flag_store_only);
> +               break;
> +       case KASAN_ARG_STORE_ONLY_ON:
> +               static_branch_enable(&kasan_flag_store_only);
> +               break;
> +       }

Let's move this part to kasan_late_init_hw_tags_cpu. Since that's
where the final decision of whether the store-only mode is enabled is
taken, we should just set the global flag there.

> +
>         kasan_init_tags();
>
>         /* KASAN is now initialized, enable it. */
>         static_branch_enable(&kasan_flag_enabled);
>
> -       pr_info("KernelAddressSanitizer initialized (hw-tags, mode=3D%s, =
vmalloc=3D%s, stacktrace=3D%s)\n",
> +       pr_info("KernelAddressSanitizer initialized (hw-tags, mode=3D%s, =
vmalloc=3D%s, stacktrace=3D%s store_only=3D%s\n",

Let's put "store_only" here next to "mode".

You're also missing a comma.

>                 kasan_mode_info(),
>                 str_on_off(kasan_vmalloc_enabled()),
> -               str_on_off(kasan_stack_collection_enabled()));
> +               str_on_off(kasan_stack_collection_enabled()),
> +               str_on_off(kasan_store_only_enabled()));
>  }
>
>  #ifdef CONFIG_KASAN_VMALLOC
> @@ -394,6 +448,22 @@ void kasan_enable_hw_tags(void)
>                 hw_enable_tag_checks_sync();
>  }
>
> +void kasan_enable_store_only(void)

Do we need this as a separate function? I think we can just move the
code to kasan_late_init_hw_tags_cpu.

> +{
> +       if (kasan_arg_store_only =3D=3D KASAN_ARG_STORE_ONLY_ON) {
> +               if (hw_enable_tag_checks_store_only()) {
> +                       static_branch_disable(&kasan_flag_store_only);
> +                       kasan_arg_store_only =3D KASAN_ARG_STORE_ONLY_OFF=
;
> +                       pr_warn_once("KernelAddressSanitizer: store only =
mode isn't supported (hw-tags)\n");

No need for the "KernelAddressSanitizer" prefix, it's already defined
via pr_fmt().

> +               }
> +       }
> +}
> +
> +bool kasan_store_only_enabled(void)
> +{
> +       return static_branch_unlikely(&kasan_flag_store_only);
> +}
> +
>  #if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
>
>  EXPORT_SYMBOL_IF_KUNIT(kasan_enable_hw_tags);
> @@ -404,4 +474,6 @@ VISIBLE_IF_KUNIT void kasan_force_async_fault(void)
>  }
>  EXPORT_SYMBOL_IF_KUNIT(kasan_force_async_fault);
>
> +EXPORT_SYMBOL_IF_KUNIT(kasan_store_only_enabled);
> +
>  #endif
> diff --git a/mm/kasan/kasan.h b/mm/kasan/kasan.h
> index 129178be5e64..1d853de1c499 100644
> --- a/mm/kasan/kasan.h
> +++ b/mm/kasan/kasan.h
> @@ -33,6 +33,7 @@ static inline bool kasan_stack_collection_enabled(void)
>  #include "../slab.h"
>
>  DECLARE_STATIC_KEY_TRUE(kasan_flag_vmalloc);
> +DECLARE_STATIC_KEY_FALSE(kasan_flag_stonly);

kasan_flag_store_only

Did you build test this at all?


>
>  enum kasan_mode {
>         KASAN_MODE_SYNC,
> @@ -428,6 +429,7 @@ static inline const void *arch_kasan_set_tag(const vo=
id *addr, u8 tag)
>  #define hw_enable_tag_checks_sync()            arch_enable_tag_checks_sy=
nc()
>  #define hw_enable_tag_checks_async()           arch_enable_tag_checks_as=
ync()
>  #define hw_enable_tag_checks_asymm()           arch_enable_tag_checks_as=
ymm()
> +#define hw_enable_tag_checks_store_only()      arch_enable_tag_checks_st=
ore_only()
>  #define hw_suppress_tag_checks_start()         arch_suppress_tag_checks_=
start()
>  #define hw_suppress_tag_checks_stop()          arch_suppress_tag_checks_=
stop()
>  #define hw_force_async_tag_fault()             arch_force_async_tag_faul=
t()
> @@ -437,10 +439,18 @@ static inline const void *arch_kasan_set_tag(const =
void *addr, u8 tag)
>                         arch_set_mem_tag_range((addr), (size), (tag), (in=
it))
>
>  void kasan_enable_hw_tags(void);
> +void kasan_enable_store_only(void);
> +bool kasan_store_only_enabled(void);
>
>  #else /* CONFIG_KASAN_HW_TAGS */
>
>  static inline void kasan_enable_hw_tags(void) { }
> +static inline void kasan_enable_store_only(void) { }
> +
> +static inline bool kasan_store_only_enabled(void)
> +{
> +       return false;
> +}
>
>  #endif /* CONFIG_KASAN_HW_TAGS */
>
> --
> LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}
>
> --
> You received this message because you are subscribed to the Google Groups=
 "kasan-dev" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to kasan-dev+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/kasan-dev=
/20250813175335.3980268-2-yeoreum.yun%40arm.com.

