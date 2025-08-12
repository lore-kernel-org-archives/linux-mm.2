Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D37CCA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 16:25:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAF4F8E016A; Tue, 12 Aug 2025 12:25:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5F568E0168; Tue, 12 Aug 2025 12:25:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B013C8E016A; Tue, 12 Aug 2025 12:25:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 96E838E0168
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 12:25:21 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2432A1A03CB
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 16:25:21 +0000 (UTC)
X-FDA: 83768630442.11.8C5091E
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2F791C0002
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 16:25:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=e14lb8Dj;
	spf=pass (imf22.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755015919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l54bXCSQ2N1WCwc3yA5CAnPI3s4L8oTQr7q8YqSeHxE=;
	b=m2C73uQwiAtqyfyCLgcjP4s2gy/4CNWRst+HIeG/5Onh+cSNdUdM+2t1CxwkODMcED8bmW
	Y2N2lJ3lfCegEfjx5fIjGbkHGErqIpuuBHW+6GdEvi39AnCMngFxVPGPpRHdUxUMPkr/ee
	Bfxw8CikmV03+9lIkhiFoBmGNXf3eK8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755015919; a=rsa-sha256;
	cv=none;
	b=k5u3GSgIwX3/h+S5KVctnfhEhMKpIxschspAo4qLtiIV1bEqquDk/8jNd1r6I6h6lDlVXW
	wxk5eitx9cqsJbhz0K9jqfJhPb1jUbB8yA6Yw03Ca1L/Pyit0gjPjsbbmqqfCVU1AtxicR
	GGa0sW6nUzhu7NvnccjA0V3hxT7X4A4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=e14lb8Dj;
	spf=pass (imf22.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-45a0dc77a15so12733175e9.2
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755015917; x=1755620717; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l54bXCSQ2N1WCwc3yA5CAnPI3s4L8oTQr7q8YqSeHxE=;
        b=e14lb8DjATMeArbgr+VHmkfXp7Cy7vcp70P8AWgKp6Mqy726WHFkGuynGfAEwfysWc
         KkBAL8fUJKdYjS9clflsfiTyz5fqSGoyKHrYrQ/0W9KO4OB9OXJIzTID2SOXLQjbEs7z
         a6ahE1FurPLkpyL3Ra+P1hba83Ijlt2/vij3wFer3itqkRcb4ebzKJ6LIC7p+DgwFSq0
         fdGCiSjf//IyQWmhIXsgfNJbG3+D7MkRZKZ8P6UYjBxeh6wzWpRX/JhLw48F5Lo8CCxk
         svML9jJQNNiWJFD9Nsr+Nfj0ufQC1In+RGeLB/S7RCoTMVhDYID/4v6jNcWde7W0BG6E
         a1Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755015917; x=1755620717;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l54bXCSQ2N1WCwc3yA5CAnPI3s4L8oTQr7q8YqSeHxE=;
        b=w6sTTpUjMlPGm9mmhv9ZYaBus5hqdz3gwyucX+HGcPkGe7axazhuwqM/leHUFeILOy
         Tb/8Lrwpf48A0XLD2LZxpSoBzaxX+xNrX8fYCWRevLQWXjM3WjDSdwyl0KPetK/HXvz+
         a4dcuXbIhLGtx6ON7uKeO23t8GJYM6USc51kPi9LzYbpg8SJX2eNk3valc9Y5Dw/NH6X
         TelYr/ClS0JzVaWdXJCzi5OFGHPp3RmVkbgyKcso9InUnVh3Dk8pBDETgKc4Ie7vFLbF
         eB/RN0rhpMAAhhAkBjDmZxYrALFDAKw5uCz8n2fwDRAZOyKOozOIPHKgB9GIP3zh+6U4
         dMyw==
X-Forwarded-Encrypted: i=1; AJvYcCW7DqJD9x5E1+AkTiDaAqig1cK9zC0ZTTQAILg00iVmwEZQy2YNubo3VQST8qUJ6u+xZ+HEFkXkAA==@kvack.org
X-Gm-Message-State: AOJu0YyY6dkgc3VjJYwiMRMJyF6ANRSkX0TdoDuQf6G6NZsRdbDt3UdO
	5c8owiUxu7w6iulT32fQwC1NvYTaNNxh+6gKvdJrYOSAVTQzCsK3rIxehRnWriOr+WzHk1wqWYX
	ZnIhxBsXrruBo1xVtSJA6bVgOYqm5tr8=
X-Gm-Gg: ASbGncuV6gF6YeIftrtIiZ8esSu0N3q5KekAcJaVcJXIIR92q5GPBo4qsanGJIuxZTv
	eTALsDuomEh4qJv8Uyab/H+VnKZaeCvCgjC3HLqMALU76inibW7OERyKOaLlnPosUkZdci4omuD
	iVaw/HKowSSYqqQwX9KXfsbyxzsvpCnKG2ydVQECBYSa7M8TYIwpC7nD7qPynYzLgQ/vGNvTHCN
	KuxR7snaQ==
X-Google-Smtp-Source: AGHT+IEO/ebtLytO3+gzax+bQ48WGSY9jQ2PI+BH3b16Ceok+c7sqVLxabYPw0NXmuXDwNr7yF9uSwRiesUbNbf7dL4=
X-Received: by 2002:a05:600c:4692:b0:456:475b:7af6 with SMTP id
 5b1f17b1804b1-45a15b0bf05mr4355835e9.7.1755015917114; Tue, 12 Aug 2025
 09:25:17 -0700 (PDT)
MIME-Version: 1.0
References: <20250811173626.1878783-1-yeoreum.yun@arm.com> <20250811173626.1878783-2-yeoreum.yun@arm.com>
In-Reply-To: <20250811173626.1878783-2-yeoreum.yun@arm.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Tue, 12 Aug 2025 18:25:03 +0200
X-Gm-Features: Ac12FXyXZGDJqhGX1iCy4SWWpZA7ZwLA8x1I9FgM3lq8ZOVHVmywuvVz0HAZZV0
Message-ID: <CA+fCnZe6F9dn8qGbNsgWXkQ_3e8oSQ80sd3X=aHFa-AUy_7kjg@mail.gmail.com>
Subject: Re: [PATCH 1/2] kasan/hw-tags: introduce store only mode
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2F791C0002
X-Stat-Signature: 69nuhb1fsycef5be39zykpuj6a44qcqq
X-Rspam-User: 
X-HE-Tag: 1755015918-956722
X-HE-Meta: U2FsdGVkX1/jMdvudgmQzcIxtq9vwCrjwQBqPMcCgIycizeb7e7HFjigBfAqa3s+Y/EbTrcGpyZV9cgCvnSJA6LYreR7IZ/ju28tzODOjkFpVE65McCG9Vd5LkEkfqnWBDSS8MW/m/+LH3C8piHTyM32KuVVt8JsfMzUmQVoMx4hjl8XM5IFhrfOUUR5u6Z59SnJ2RuasUSD5fc3HjopSHWiLqWxKkLF0hdCnSMvVwn0Z5GUfVKN51msN1obdXQO05aOw+Ty0A2sr/veXVYoxHpzWvAfNAXGvTWjcHR+NYaB0tDKkUb0MpVpEsObpNIOcba0v30xWfkjQCetzAPZm2g8tRgk3ZtuGaYKiWUU/0qRUG1Hv2DU+k2xKke1up8hud0GzHK+aQWVNtLf3AMfBqBvSaHmHFOB4f7HKMAGsYIKeQokXfjsYmB+fbGSJHv6GREuFXRsQmBWdr9zrX/YbQ0pehDlLFc3LA6AbzK8lACe48mAN6g2TPuv6B6+y9cPP2x3kxnjLQT9qWTvPJ1wsdMQ1DWGjWFiyKd0vGlKtNWSAsmfZOI5co6Dkw4YEcP9D7Mxsbre2ifGcxiGfgFl8+EPONPhu/W25wkNLRoCkjKuCG6+pEfmdz9KC0aFX6i5upx0/IE5yiQ/hmzJOjq5dYBnLYbRXfhZdrzopCc2hVouB5R19Tp1L0pj4OaGs6ZrpPeR0xE7+t+ieYpEAOVLpmx1Oy7AXh526jmBKjFlulRdCJXvkXR/8rLIv5m76IWO+XEbNTEk5XXwe2/S7Trcx+26IOiHuIcQoT96wgV1xBEyQsJMH7AAVhn/ozAveZWVfQEVb/KZZqGLTsaCVxvhJ7CNkY4Qh6eEc8ccoKMW/+sw55/z0yj9wPuZTnfPwvW3Bbmb0un2jc03Tv4/nufl3R6fORUsi+kNd4Xvy5eWrS98O7llYpb34duQkEnVvrrpDD+v8PLR4b07g/edYKK
 X1yMt/hX
 PKfp5nPpCLy83mcQQeZDwq/sgIrIuYu/Vpa0z/GsXXfE99TKrB4sJDjCzM44aTDgwc2oGXojipNaQ8wRn5Iu2FsSNVfTyznmRTAnw72lILoeavE6nLYwPmxW1k3uEzdNy4J4jER9NLj2iK0ZaE1wWdsECpFnbahOtqyrWHrWaXMCvYUa6HIk7/C0RDfIWZKkw4JpJT5N0iUKojsoQUquY5v+JZkSIqBOchi4cj1SJL83XNhDK5qMtzfmpBHOXPRmIQQCWpOp6fy5aRr41lACjkmLMNBSo2bMhxlmjf3Kr9OHwQNaulW2w3YnJpYznMpnKSeT0t5dqINff0cqExmTAHN147KMYX4XT6fDSGCde2EYWINRwjQtpHQehDfDTlTt9/bYlMF9RXOelQWeh49sCcPxZkt/5Qf+7AWFyDYT7MkRchxY4VrDbud/S65WlUdcL0KI64aC8LMm8ADxISaTKGwQv0UC0Y9eA7tnnbrSMWMcIRZY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025 at 7:36=E2=80=AFPM Yeoreum Yun <yeoreum.yun@arm.com> w=
rote:
>
> Since Armv8.9, FEATURE_MTE_STORE_ONLY feature is introduced to restrict
> raise of tag check fault on store operation only.

To clarify: this feature is independent on the sync/async/asymm modes?
So any mode can be used together with FEATURE_MTE_STORE_ONLY?

> Introcude KASAN store only mode based on this feature.
>
> KASAN store only mode restricts KASAN checks operation for store only and
> omits the checks for fetch/read operation when accessing memory.
> So it might be used not only debugging enviroment but also normal
> enviroment to check memory safty.
>
> This features can be controlled with "kasan.stonly" arguments.
> When "kasan.stonly=3Don", KASAN checks store only mode otherwise
> KASAN checks all operations.

"stonly" looks cryptic, how about "kasan.store_only"?

Also, are there any existing/planned modes/extensions of the feature?
E.g. read only? Knowing this will allow to better plan the
command-line parameter format.

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
> index 0a1418ab72fd..7567a2ca0e39 100644
> --- a/Documentation/dev-tools/kasan.rst
> +++ b/Documentation/dev-tools/kasan.rst
> @@ -163,6 +163,9 @@ disabling KASAN altogether or controlling its feature=
s:
>    This parameter is intended to allow sampling only large page_alloc
>    allocations, which is the biggest source of the performance overhead.
>
> +- ``kasan.stonly=3Doff`` or ``kasan.stonly=3Don`` controls whether KASAN=
 checks
> +  store operation only or all operation.

How about:

``kasan.store_only=3Doff`` or ``=3Don`` controls whether KASAN checks only
the store (write) accesses only or all accesses (default: ``off``).

And let's put this next to kasan.mode, as the new parameter is related.

> +
>  Error reports
>  ~~~~~~~~~~~~~
>
> diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/mem=
ory.h
> index 5213248e081b..9d8c72c9c91f 100644
> --- a/arch/arm64/include/asm/memory.h
> +++ b/arch/arm64/include/asm/memory.h
> @@ -308,6 +308,7 @@ static inline const void *__tag_set(const void *addr,=
 u8 tag)
>  #define arch_enable_tag_checks_sync()          mte_enable_kernel_sync()
>  #define arch_enable_tag_checks_async()         mte_enable_kernel_async()
>  #define arch_enable_tag_checks_asymm()         mte_enable_kernel_asymm()
> +#define arch_enable_tag_checks_stonly()        mte_enable_kernel_stonly(=
)
>  #define arch_suppress_tag_checks_start()       mte_enable_tco()
>  #define arch_suppress_tag_checks_stop()                mte_disable_tco()
>  #define arch_force_async_tag_fault()           mte_check_tfsr_exit()
> diff --git a/arch/arm64/include/asm/mte-kasan.h b/arch/arm64/include/asm/=
mte-kasan.h
> index 2e98028c1965..d75908ed9d0f 100644
> --- a/arch/arm64/include/asm/mte-kasan.h
> +++ b/arch/arm64/include/asm/mte-kasan.h
> @@ -200,6 +200,7 @@ static inline void mte_set_mem_tag_range(void *addr, =
size_t size, u8 tag,
>  void mte_enable_kernel_sync(void);
>  void mte_enable_kernel_async(void);
>  void mte_enable_kernel_asymm(void);
> +int mte_enable_kernel_stonly(void);
>
>  #else /* CONFIG_ARM64_MTE */
>
> @@ -251,6 +252,11 @@ static inline void mte_enable_kernel_asymm(void)
>  {
>  }
>
> +static inline int mte_enable_kenrel_stonly(void)
> +{
> +       return -EINVAL;
> +}
> +
>  #endif /* CONFIG_ARM64_MTE */
>
>  #endif /* __ASSEMBLY__ */
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeatur=
e.c
> index 9ad065f15f1d..fdc510fe0187 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -2404,6 +2404,11 @@ static void cpu_enable_mte(struct arm64_cpu_capabi=
lities const *cap)
>
>         kasan_init_hw_tags_cpu();
>  }
> +
> +static void cpu_enable_mte_stonly(struct arm64_cpu_capabilities const *c=
ap)
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
> +               .cpu_enable =3D cpu_enable_mte_stonly,
>                 ARM64_CPUID_FIELDS(ID_AA64PFR2_EL1, MTESTOREONLY, IMP)
>         },
>  #endif /* CONFIG_ARM64_MTE */
> diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
> index e5e773844889..a1cb2a8a79a1 100644
> --- a/arch/arm64/kernel/mte.c
> +++ b/arch/arm64/kernel/mte.c
> @@ -157,6 +157,20 @@ void mte_enable_kernel_asymm(void)
>                 mte_enable_kernel_sync();
>         }
>  }
> +
> +int mte_enable_kernel_stonly(void)
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

Why do we need a separate late init function? Can we not enable
store-only at the same place where we enable async/asymm?


>  #else
>  static inline void kasan_init_hw_tags_cpu(void) { }
>  static inline void kasan_init_hw_tags(void) { }
> +static inline void kasan_late_init_hw_tags_cpu(void) { }
>  #endif
>
>  #ifdef CONFIG_KASAN_VMALLOC
> diff --git a/mm/kasan/hw_tags.c b/mm/kasan/hw_tags.c
> index 9a6927394b54..2caa6fe5ed47 100644
> --- a/mm/kasan/hw_tags.c
> +++ b/mm/kasan/hw_tags.c
> @@ -41,9 +41,16 @@ enum kasan_arg_vmalloc {
>         KASAN_ARG_VMALLOC_ON,
>  };
>
> +enum kasan_arg_stonly {
> +       KASAN_ARG_STONLY_DEFAULT,
> +       KASAN_ARG_STONLY_OFF,
> +       KASAN_ARG_STONLY_ON,
> +};
> +
>  static enum kasan_arg kasan_arg __ro_after_init;
>  static enum kasan_arg_mode kasan_arg_mode __ro_after_init;
>  static enum kasan_arg_vmalloc kasan_arg_vmalloc __initdata;
> +static enum kasan_arg_stonly kasan_arg_stonly __ro_after_init;
>
>  /*
>   * Whether KASAN is enabled at all.
> @@ -67,6 +74,9 @@ DEFINE_STATIC_KEY_FALSE(kasan_flag_vmalloc);
>  #endif
>  EXPORT_SYMBOL_GPL(kasan_flag_vmalloc);
>
> +DEFINE_STATIC_KEY_FALSE(kasan_flag_stonly);
> +EXPORT_SYMBOL_GPL(kasan_flag_stonly);
> +
>  #define PAGE_ALLOC_SAMPLE_DEFAULT      1
>  #define PAGE_ALLOC_SAMPLE_ORDER_DEFAULT        3
>
> @@ -141,6 +151,23 @@ static int __init early_kasan_flag_vmalloc(char *arg=
)
>  }
>  early_param("kasan.vmalloc", early_kasan_flag_vmalloc);
>
> +/* kasan.stonly=3Doff/on */
> +static int __init early_kasan_flag_stonly(char *arg)
> +{
> +       if (!arg)
> +               return -EINVAL;
> +
> +       if (!strcmp(arg, "off"))
> +               kasan_arg_stonly =3D KASAN_ARG_STONLY_OFF;
> +       else if (!strcmp(arg, "on"))
> +               kasan_arg_stonly =3D KASAN_ARG_STONLY_ON;
> +       else
> +               return -EINVAL;
> +
> +       return 0;
> +}
> +early_param("kasan.stonly", early_kasan_flag_stonly);
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
> + * Not marked as __init as a CPU can be hot-plugged after boot.
> + */
> +void kasan_late_init_hw_tags_cpu(void)
> +{
> +       /*
> +        * Enable stonly mode only when explicitly requested through the =
command line.
> +        * If system doesn't support, kasan checks all operation.
> +        */
> +       kasan_enable_stonly();
> +}
> +
>  /* kasan_init_hw_tags() is called once on boot CPU. */
>  void __init kasan_init_hw_tags(void)
>  {
> @@ -257,15 +298,28 @@ void __init kasan_init_hw_tags(void)
>                 break;
>         }
>
> +       switch (kasan_arg_stonly) {
> +       case KASAN_ARG_STONLY_DEFAULT:
> +               /* Default is specified by kasan_flag_stonly definition. =
*/
> +               break;
> +       case KASAN_ARG_STONLY_OFF:
> +               static_branch_disable(&kasan_flag_stonly);
> +               break;
> +       case KASAN_ARG_STONLY_ON:
> +               static_branch_enable(&kasan_flag_stonly);
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
vmalloc=3D%s, stacktrace=3D%s stonly=3D%s\n",
>                 kasan_mode_info(),
>                 str_on_off(kasan_vmalloc_enabled()),
> -               str_on_off(kasan_stack_collection_enabled()));
> +               str_on_off(kasan_stack_collection_enabled()),
> +               str_on_off(kasan_stonly_enabled()));
>  }
>
>  #ifdef CONFIG_KASAN_VMALLOC
> @@ -394,6 +448,22 @@ void kasan_enable_hw_tags(void)
>                 hw_enable_tag_checks_sync();
>  }
>
> +void kasan_enable_stonly(void)
> +{
> +       if (kasan_arg_stonly =3D=3D KASAN_ARG_STONLY_ON) {
> +               if (hw_enable_tag_checks_stonly()) {
> +                       static_branch_disable(&kasan_flag_stonly);
> +                       kasan_arg_stonly =3D KASAN_ARG_STONLY_OFF;
> +                       pr_warn_once("KernelAddressSanitizer: store only =
mode isn't supported (hw-tags)\n");
> +               }
> +       }
> +}
> +
> +bool kasan_stonly_enabled(void)
> +{
> +       return static_branch_unlikely(&kasan_flag_stonly);
> +}
> +
>  #if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
>
>  EXPORT_SYMBOL_IF_KUNIT(kasan_enable_hw_tags);
> @@ -404,4 +474,6 @@ VISIBLE_IF_KUNIT void kasan_force_async_fault(void)
>  }
>  EXPORT_SYMBOL_IF_KUNIT(kasan_force_async_fault);
>
> +EXPORT_SYMBOL_IF_KUNIT(kasan_stonly_enabled);
> +
>  #endif
> diff --git a/mm/kasan/kasan.h b/mm/kasan/kasan.h
> index 129178be5e64..cfbcebdbcbec 100644
> --- a/mm/kasan/kasan.h
> +++ b/mm/kasan/kasan.h
> @@ -33,6 +33,7 @@ static inline bool kasan_stack_collection_enabled(void)
>  #include "../slab.h"
>
>  DECLARE_STATIC_KEY_TRUE(kasan_flag_vmalloc);
> +DECLARE_STATIC_KEY_FALSE(kasan_flag_stonly);
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
> +#define hw_enable_tag_checks_stonly()          arch_enable_tag_checks_st=
only()
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
> +void kasan_enable_stonly(void);
> +bool kasan_stonly_enabled(void);
>
>  #else /* CONFIG_KASAN_HW_TAGS */
>
>  static inline void kasan_enable_hw_tags(void) { }
> +static inline void kasan_enable_stonly(void) { }
> +
> +static inline bool kasan_stonly_enabled(void)
> +{
> +       return false;
> +}
>
>  #endif /* CONFIG_KASAN_HW_TAGS */
>
> --
> LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}
>

