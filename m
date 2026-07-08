Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B65A6C44501
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 23:49:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A92F56B00AA; Wed,  8 Jul 2026 19:49:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4A136B00AB; Wed,  8 Jul 2026 19:49:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E4E16B00AC; Wed,  8 Jul 2026 19:49:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 58CF76B00AA
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 19:49:49 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C53764034C
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 23:49:48 +0000 (UTC)
X-FDA: 84967254456.16.CE1AC05
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf18.hostedemail.com (Postfix) with ESMTP id CB5051C0004
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 23:49:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VGvpa+Cg;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf18.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783554586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rib4ibu+dts9p9/XbnX7ZcTmfXYVT7n2/w0qnalOJkU=;
	b=u2eGrNYxETGre+xyrjKoUIoqTs6EECda8Xla9dGTHWdTVkKj9q+GHsBelQ9Mvn0C5jfveM
	5INGKhLSMfoCE6udEGGI0D69Gc6P2iaVwrSgeSS4RlhhTjb+ZXiXJScGH69bFnuORHx3kI
	a0RfrpAPA05mSYv2m0FH+rHy0jpaUCI=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VGvpa+Cg;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf18.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783554586;
	b=BMRHOHpDCHm0el+2u9j5WmZ0F3JkKKBr/Zd0JFab1feH4qsukLrWcS5bC8JaYGtXkT0h6R
	aNHMsPspBubIjgPzmgR0F6jv2R9dKtUqq5HkeVXqTNAnenhQxxDgocZBjTBPmFF7pfccHD
	rql7+FYp+BQ+0DECKkCvZeeiJ6jy+pk=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-493b8d92a4eso11105e9.1
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 16:49:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783554585; cv=none;
        d=google.com; s=arc-20260327;
        b=IcP575+xCxueyujHbKzhSUHsYrsTFWdomDpcdzsOh0f4zkWpYE/Vh/9E7z4/MLkBeu
         3ZDULfL73pw+0CwV3sdqHd84lH0HcZ1ftTDwjEIaLsw7qKYiMkgIPo17V4helIyTx++7
         Aewb8dT20aUNrWt7hb4yiGLMk8WyKBZfLRlDFFytnCotxTcR6Tno1qK3drXx3y/nuK2n
         XgYo5tUIf4Bmi89+fHJktPyGwXaKFPD6CKnJQ7RQ9E1gfp3spUxl4qZnGrjSp1y2qBLy
         OnmD2L94i8xbAjr05MDqlHNFgK0XEJucPZFpuwZBy9Cg9MgmTRCdl6WgwLEuhhd+r4U5
         ufnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rib4ibu+dts9p9/XbnX7ZcTmfXYVT7n2/w0qnalOJkU=;
        fh=7wKcvDD1/ZE1ef5d6OOK5Ps89MbTvIHU02qaYdT0fuw=;
        b=WkDBnReq+lto3NztJrffdEpyNya1SJAH4bzMyTOTti+eWaLeRHudw5R7L4bgmNQpFI
         c0u+m+FfXNCEnt3l7bfS6uAKCfzQqDf+7pXO87BiIlEbVqUO9svc0cmm6VX2t+Wu/A67
         FLTPqJBJQxmADvhsmsBOo3vCXpkoo0fxVCB3N1CYa4KnVCRZ7fwgk3ltEyaCp0FAULf4
         zPns87AgBIBCdrGrQzB1cZrLADeDG8cZYchqYV2BCp5OJ7+bbhBoiFGrvLOOur+krW9e
         1Bmx/mCYwC3s5JIWEeuz/EBrABhu3yOzvtSEg4qSgfOaE+wTfDJBmFU7ZM0lfhJZafy8
         jlrA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783554585; x=1784159385; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rib4ibu+dts9p9/XbnX7ZcTmfXYVT7n2/w0qnalOJkU=;
        b=VGvpa+Cgj+y7B+xU2zV6T0VytpBZTiyngFOCRAY0YMAJbJ2dCzZW/DYWPBxDvzfnCa
         t8BWFsQyZxjEhPb9+W1gNtpzx8uCZ9A7bO04qpIkl45PwlMVa2IK/7hU64VaJj1K0hm/
         ULw3oKIjrydp+cNw922WNAtZ1W/2ZWQR0RqUds36j1ANzfkntyT/3Dd+vyyMV0UIRQ3g
         qFxIXmmbjSYEbMiUWUMGrjrfPkzwZZMWQDueuMxPXqvGeCkT23Q7U8gePKYAKWXU+TwO
         DunaGnYgAby+g95Vlslb5+K0Cgy9dVczEgz26NwLYcDZ5aDAC+Jo+oCR2Vnn0FS8X7i4
         5yrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783554585; x=1784159385;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rib4ibu+dts9p9/XbnX7ZcTmfXYVT7n2/w0qnalOJkU=;
        b=H7Z2exjV8FYPD8FmeQEZZoljiaT8d5X/3hd+5TWsFcdIcgW5eAWOWYeVX85SnFgZMg
         EDeLlkFuiKjUTvvPkeeTAXBSIst46GSwNN0OVj1aXNKGGjzO0AjzEbaST6rUi+0LJEh7
         wxeBbrjZoxyRA03MJTc3/WYFjtbwFHJ+6hHJX1D9W/z0FFeDiRRVcceYqhCTTFdBtfyM
         qF8rukRmM3BRp3kt9wJZH2rgOCxlDx3PvAhMf8gUoDv+2RLIYCL9nKwy5RsyC4SA+mZP
         0xBnjVZixfreQiFk32cQg9eimd46RVyG3k1C9Z+XxSDBhN2Y5EJC3zs1fseTlwZ0HVMZ
         guCg==
X-Forwarded-Encrypted: i=1; AHgh+RpPeboMSyvecpy/QPyKOBSi/wrP9XdPBSNtlLk8Jy+G9xsSN0B/M2Y4p2/DK+JINc+6L1enlqtSyg==@kvack.org
X-Gm-Message-State: AOJu0Yy1BMsdBGwHBDsybgliGAkaaZaAjB6OlaUKeMd5fbOo2MOIV4px
	4lm7K6oTC3mpRAhrTl0TQZNvS324zrKN2Y20qAz+sHpYpq4aFQmH49ia0qVOQRFBEWpYktQmgoH
	Y1GOyN8heNkyXgK+fr7LQnLZK3JpYjWWyDGM1Ph/d
X-Gm-Gg: AfdE7cmE9Lwe2ZoykEYXiDelqQMLbYISQOdaHVwnLpINm9LbpnIqfLpH6xsZrk7ALQm
	/JzMuDWZeXfQ2gp2OD+jBlqNL2ZaK732W6ZM045s1PvHlstSMlFChFtBK3T/ZgcK9ksMAJf/1EE
	YDbSqLXrq56UKc1QInS/uljmyWgtqmB9k23JJr+gBbqzjmtYBc/272Ps85hODFo5I2j6/rWfmhJ
	M1gxsyTWJhhPAjG6EjTKvKHLs5666lL0lJ3r/AnQPhDkh4GtQ9jI/Tog5jmW8MHPTnEM99lzD64
	uoJOwG436JgHHpQqpbsuGeZddWXG332kxEdXIYLZ5P52XIwSBNZR97/Krg==
X-Received: by 2002:a05:600d:644a:10b0:490:b3cd:fc4d with SMTP id
 5b1f17b1804b1-493ec91fb9cmr44975e9.9.1783554584679; Wed, 08 Jul 2026 16:49:44
 -0700 (PDT)
MIME-Version: 1.0
References: <20260701-tegra-vpr-v3-0-d80f7b871bb4@nvidia.com> <20260701-tegra-vpr-v3-6-d80f7b871bb4@nvidia.com>
In-Reply-To: <20260701-tegra-vpr-v3-6-d80f7b871bb4@nvidia.com>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Wed, 8 Jul 2026 16:49:31 -0700
X-Gm-Features: AUfX_mzOMAhQgIZCGlz9_znmnioZkDYwZn81U0HlPggiFRGlpgF5nj0v4x5iIA0
Message-ID: <CABdmKX2i_vxs3EgJgydEbXoTxqWe9g9pj=hqPKuwf0ge0SjZuQ@mail.gmail.com>
Subject: Re: [PATCH v3 06/11] mm/cma: Allow dynamically creating CMA areas
To: Thierry Reding <thierry.reding@kernel.org>
Cc: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Jonathan Hunter <jonathanh@nvidia.com>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, Sowjanya Komatineni <skomatineni@nvidia.com>, 
	Luca Ceresoli <luca.ceresoli@bootlin.com>, Mikko Perttunen <mperttunen@nvidia.com>, 
	Yury Norov <yury.norov@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	Russell King <linux@armlinux.org.uk>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, 
	Sumit Semwal <sumit.semwal@linaro.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org, 
	linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-mm@kvack.org, iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org, 
	linux-trace-kernel@vger.kernel.org, Thierry Reding <treding@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: yf4931kpzoqrs8bpwy7skrz1ikpuqeaf
X-Rspamd-Queue-Id: CB5051C0004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783554586-395165
X-HE-Meta: U2FsdGVkX185SbVfTt2Fua3MoZXRm5zlNvdT/NyEPSUWdlQpJnFoAg9RjmzTIPictyxF9i4qswCVazE20UdjRxCdiwPF3dcnnvNhsk8RWZ3qzi/TBbrJ3Scui40yXoF0dyREvKe87bKFcC11cyXo5WRtFlx57uWeM/zkVmmnT91nBb445N5NUH92vMuLhQNmJ6gFgLplfKneFW1JgAqQ3xAqPMAonVqvmFXfrPXATtFVyK/3d8R/BMG1T+yB2EsxjJSK1aSAaOtldeYFZyxSJzKdZk77/guCrohnyKJ771dY8nGGRvh0qlzBdPAOi+yuRdNclMjoJbHJlLGpH4P9WcfIyj50BelJtXyeT9GmD/ZWGZxd8ZLcJTbnX00Q9fCsMSrqCBof9PKX7DFnXGYpWK4ueKIQfOvTeAAcXJboxmHZGJQP6vAqyZ1exf0tS4Bou2olcIOmYZjmycTAqYUGFGcCGwVw/3AyBNTo0YEvgytY89KDwpT2pHBtXxr5Dqu4237cQcZ5bL+fb7juOonQxOPvT89LSTGsPBM/ZdhrWCM930GMUXR07voC99jzdruo9vISZKoeLk2IjgkfCGK9L/Jl9Lq5k130NXz2SImRvZDwGISC4KLqFAy4xoGX4tAenx5eRx9YoGXqoSLkbnVaYp8cunW+eXjQ/vpEYTJ0wVUNQd2NUTlXGIFtAEMCADuKGub2qymBb1t0c7+TdmKtKkMfbjqCxS2jqCmEACJnN5r0cZ6n9rkA+Z4XFhRrWDGTT9ZAFwd+6BE9bkhJDRwFwa0OQh3ZTk/sAlxPMyCM8VfJAwtbdCM0TK6cqDGYCZvdgTYguQw4f6wzm8hgy1MIoaDD8g52j+/fsQny1c8lRPqrD8VQpDaatEbJvc6qo/rfm1oHX8eLxKtm/ldRab6WT4rJmilpxrJDq7ZkmmbYE/LJYf6q8lL5CLyfS1VPk5oC0GKOqA97e/H9pasKNCB
 XyFho9ea
 5GtghAiEgR1vg/74u3oEllvEPHuEMZRHh1NIcvk7n9vZIyiLx7inp8+bIJEQ9QGULOvElRBygt8Zn84aGiMtsC/q3PsHmoH6DXaO0IPtA8fwsFYoCTu2ZC8Zb34F4s8kM4Z+ttJsCZEr0nBa3x2+e17tFSgEKcz4fUtjcWAU5MnCW8A2H68vLBiJjSXMFjT26eWS8HsjcgGvy8Eic4EfhzcanRoVcDo3GitFiYHnV6pAKbAZxFD4vNtVtm2TpV0h3DhfxirMjp3AIR/bqgEpI54EqB07hk9rTFAjTLiQBEVCylIrg27CKwyVL2Ct7z/ROIBbeVbcm5CjDdSC2XzFP9EqrfRGiqj1VPQdZadATZDXN+yf8myzwPvEV8OSMo6nfxhzes7qUZBTut+4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 1, 2026 at 9:09=E2=80=AFAM Thierry Reding <thierry.reding@kerne=
l.org> wrote:
>
> From: Thierry Reding <treding@nvidia.com>
>
> There is no technical reason why there should be a limited number of CMA
> regions, so extract some code into helpers and use them to create extra
> functions (cma_create() and cma_free()) that allow creating and freeing,
> respectively, CMA regions dynamically at runtime.
>
> The static array of CMA areas cannot be replaced by dynamically created
> areas because for many of them, allocation must not fail and some cases
> may need to initialize them before the slab allocator is even available.
> To account for this, keep these "early" areas in a separate list and
> track the dynamic areas in a separate list.

Hi, It looks like you'll also need to update the CMA dma-buf heap's
add_cma_heaps init function so that it adds all the CMA areas, not
just the early ones.

>
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
> Changes in v3:
> - rebase on top of recent linux-next, update kernel/dma/contiguous.c
> - use kzalloc_obj() instead of kzalloc() with sizeof()
>
> Changes in v2:
> - rename fixed number of CMA areas to reflect their main use
> - account for pages in dynamically allocated regions
> ---
>  arch/arm/mm/dma-mapping.c |   2 +-
>  arch/s390/mm/init.c       |   2 +-
>  include/linux/cma.h       |   8 +-
>  kernel/dma/contiguous.c   |   2 +-
>  mm/cma.c                  | 187 +++++++++++++++++++++++++++++++++++++---=
------
>  mm/cma.h                  |   5 +-
>  6 files changed, 165 insertions(+), 41 deletions(-)
>
> diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
> index f9bc53b60f99..934952ab2102 100644
> --- a/arch/arm/mm/dma-mapping.c
> +++ b/arch/arm/mm/dma-mapping.c
> @@ -254,7 +254,7 @@ struct dma_contig_early_reserve {
>         unsigned long size;
>  };
>
> -static struct dma_contig_early_reserve dma_mmu_remap[MAX_CMA_AREAS] __in=
itdata;
> +static struct dma_contig_early_reserve dma_mmu_remap[MAX_EARLY_CMA_AREAS=
] __initdata;
>
>  static int dma_mmu_remap_num __initdata;
>
> diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
> index f07168a0d3dd..f8f78f1434ea 100644
> --- a/arch/s390/mm/init.c
> +++ b/arch/s390/mm/init.c
> @@ -241,7 +241,7 @@ static int s390_cma_mem_notifier(struct notifier_bloc=
k *nb,
>         mem_data.start =3D arg->start_pfn << PAGE_SHIFT;
>         mem_data.end =3D mem_data.start + (arg->nr_pages << PAGE_SHIFT);
>         if (action =3D=3D MEM_GOING_OFFLINE)
> -               rc =3D cma_for_each_area(s390_cma_check_range, &mem_data)=
;
> +               rc =3D cma_for_each_early_area(s390_cma_check_range, &mem=
_data);
>         return notifier_from_errno(rc);
>  }
>
> diff --git a/include/linux/cma.h b/include/linux/cma.h
> index 8555d38a97b1..fb7a4923c3ba 100644
> --- a/include/linux/cma.h
> +++ b/include/linux/cma.h
> @@ -7,7 +7,7 @@
>  #include <linux/numa.h>
>
>  #ifdef CONFIG_CMA_AREAS
> -#define MAX_CMA_AREAS  CONFIG_CMA_AREAS
> +#define MAX_EARLY_CMA_AREAS    CONFIG_CMA_AREAS
>  #endif
>
>  #define CMA_MAX_NAME 64
> @@ -57,8 +57,14 @@ struct page *cma_alloc_frozen_compound(struct cma *cma=
, unsigned int order);
>  bool cma_release_frozen(struct cma *cma, const struct page *pages,
>                 unsigned long count);
>
> +extern int cma_for_each_early_area(int (*it)(struct cma *cma, void *data=
), void *data);
>  extern int cma_for_each_area(int (*it)(struct cma *cma, void *data), voi=
d *data);
>  extern bool cma_intersects(struct cma *cma, unsigned long start, unsigne=
d long end);
>
>  extern void cma_reserve_pages_on_error(struct cma *cma);
> +
> +extern struct cma *cma_create(phys_addr_t base, phys_addr_t size,
> +                             unsigned int order_per_bit, const char *nam=
e);
> +extern void cma_free(struct cma *cma);
> +
>  #endif
> diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
> index f754079a287d..7975551f69b3 100644
> --- a/kernel/dma/contiguous.c
> +++ b/kernel/dma/contiguous.c
> @@ -52,7 +52,7 @@
>  #define CMA_SIZE_MBYTES 0
>  #endif
>
> -static struct cma *dma_contiguous_areas[MAX_CMA_AREAS];
> +static struct cma *dma_contiguous_areas[MAX_EARLY_CMA_AREAS];
>  static unsigned int dma_contiguous_areas_num;
>
>  static int dma_contiguous_insert_area(struct cma *cma)
> diff --git a/mm/cma.c b/mm/cma.c
> index a13ce4999b39..f989e2e98594 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -34,7 +34,12 @@
>  #include "internal.h"
>  #include "cma.h"
>
> -struct cma cma_areas[MAX_CMA_AREAS];
> +static DEFINE_MUTEX(cma_lock);
> +
> +struct cma cma_early_areas[MAX_EARLY_CMA_AREAS];
> +unsigned int cma_early_area_count;
> +
> +static LIST_HEAD(cma_areas);
>  unsigned int cma_area_count;
>
>  phys_addr_t cma_get_base(const struct cma *cma)
> @@ -198,7 +203,6 @@ static void __init cma_activate_area(struct cma *cma)
>                                 free_reserved_page(pfn_to_page(pfn));
>                 }
>         }
> -       totalcma_pages -=3D cma->count;
>         cma->available_count =3D cma->count =3D 0;
>         pr_err("CMA area %s could not be activated\n", cma->name);
>  }
> @@ -207,8 +211,8 @@ static int __init cma_init_reserved_areas(void)
>  {
>         int i;
>
> -       for (i =3D 0; i < cma_area_count; i++)
> -               cma_activate_area(&cma_areas[i]);
> +       for (i =3D 0; i < cma_early_area_count; i++)
> +               cma_activate_area(&cma_early_areas[i]);
>
>         return 0;
>  }
> @@ -219,41 +223,77 @@ void __init cma_reserve_pages_on_error(struct cma *=
cma)
>         set_bit(CMA_RESERVE_PAGES_ON_ERROR, &cma->flags);
>  }
>
> +static void __init cma_init_area(struct cma *cma, const char *name,
> +                                phys_addr_t size, unsigned int order_per=
_bit)
> +{
> +       if (name)
> +               strscpy(cma->name, name);
> +       else
> +               snprintf(cma->name, CMA_MAX_NAME,  "cma%d\n", cma_area_co=
unt);
> +
> +       cma->available_count =3D cma->count =3D size >> PAGE_SHIFT;
> +       cma->order_per_bit =3D order_per_bit;
> +
> +       INIT_LIST_HEAD(&cma->node);
> +}
> +
>  static int __init cma_new_area(const char *name, phys_addr_t size,
>                                unsigned int order_per_bit,
>                                struct cma **res_cma)
>  {
>         struct cma *cma;
>
> -       if (cma_area_count =3D=3D ARRAY_SIZE(cma_areas)) {
> +       if (cma_early_area_count =3D=3D ARRAY_SIZE(cma_early_areas)) {
>                 pr_err("Not enough slots for CMA reserved regions!\n");
>                 return -ENOSPC;
>         }
>
> +       mutex_lock(&cma_lock);
> +
>         /*
>          * Each reserved area must be initialised later, when more kernel
>          * subsystems (like slab allocator) are available.
>          */
> -       cma =3D &cma_areas[cma_area_count];
> -       cma_area_count++;
> +       cma =3D &cma_early_areas[cma_early_area_count];
> +       cma_early_area_count++;
>
> -       if (name)
> -               strscpy(cma->name, name);
> -       else
> -               snprintf(cma->name, CMA_MAX_NAME,  "cma%d\n", cma_area_co=
unt);
> +       cma_init_area(cma, name, size, order_per_bit);
>
> -       cma->available_count =3D cma->count =3D size >> PAGE_SHIFT;
> -       cma->order_per_bit =3D order_per_bit;
> -       *res_cma =3D cma;
>         totalcma_pages +=3D cma->count;
> +       *res_cma =3D cma;
> +
> +       mutex_unlock(&cma_lock);
>
>         return 0;
>  }
>
>  static void __init cma_drop_area(struct cma *cma)
>  {
> +       mutex_lock(&cma_lock);
>         totalcma_pages -=3D cma->count;
> -       cma_area_count--;
> +       cma_early_area_count--;
> +       mutex_unlock(&cma_lock);
> +}
> +
> +static int __init cma_check_memory(phys_addr_t base, phys_addr_t size)
> +{
> +       if (!size || !memblock_is_region_reserved(base, size))
> +               return -EINVAL;
> +
> +       /*
> +        * CMA uses CMA_MIN_ALIGNMENT_BYTES as alignment requirement whic=
h
> +        * needs pageblock_order to be initialized. Let's enforce it.
> +        */
> +       if (!pageblock_order) {
> +               pr_err("pageblock_order not yet initialized. Called durin=
g early boot?\n");
> +               return -EINVAL;
> +       }
> +
> +       /* ensure minimal alignment required by mm core */
> +       if (!IS_ALIGNED(base | size, CMA_MIN_ALIGNMENT_BYTES))
> +               return -EINVAL;
> +
> +       return 0;
>  }
>
>  /**
> @@ -276,22 +316,9 @@ int __init cma_init_reserved_mem(phys_addr_t base, p=
hys_addr_t size,
>         struct cma *cma;
>         int ret;
>
> -       /* Sanity checks */
> -       if (!size || !memblock_is_region_reserved(base, size))
> -               return -EINVAL;
> -
> -       /*
> -        * CMA uses CMA_MIN_ALIGNMENT_BYTES as alignment requirement whic=
h
> -        * needs pageblock_order to be initialized. Let's enforce it.
> -        */
> -       if (!pageblock_order) {
> -               pr_err("pageblock_order not yet initialized. Called durin=
g early boot?\n");
> -               return -EINVAL;
> -       }
> -
> -       /* ensure minimal alignment required by mm core */
> -       if (!IS_ALIGNED(base | size, CMA_MIN_ALIGNMENT_BYTES))
> -               return -EINVAL;
> +       ret =3D cma_check_memory(base, size);
> +       if (ret < 0)
> +               return ret;
>
>         ret =3D cma_new_area(name, size, order_per_bit, &cma);
>         if (ret !=3D 0)
> @@ -444,7 +471,7 @@ static int __init __cma_declare_contiguous_nid(phys_a=
ddr_t *basep,
>         pr_debug("%s(size %pa, base %pa, limit %pa alignment %pa)\n",
>                 __func__, &size, &base, &limit, &alignment);
>
> -       if (cma_area_count =3D=3D ARRAY_SIZE(cma_areas)) {
> +       if (cma_early_area_count =3D=3D ARRAY_SIZE(cma_early_areas)) {
>                 pr_err("Not enough slots for CMA reserved regions!\n");
>                 return -ENOSPC;
>         }
> @@ -1051,12 +1078,12 @@ bool cma_release_frozen(struct cma *cma, const st=
ruct page *pages,
>         return true;
>  }
>
> -int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data=
)
> +int cma_for_each_early_area(int (*it)(struct cma *cma, void *data), void=
 *data)
>  {
>         int i;
>
> -       for (i =3D 0; i < cma_area_count; i++) {
> -               int ret =3D it(&cma_areas[i], data);
> +       for (i =3D 0; i < cma_early_area_count; i++) {
> +               int ret =3D it(&cma_early_areas[i], data);
>
>                 if (ret)
>                         return ret;
> @@ -1065,6 +1092,25 @@ int cma_for_each_area(int (*it)(struct cma *cma, v=
oid *data), void *data)
>         return 0;
>  }
>
> +int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data=
)
> +{
> +       struct cma *cma;
> +
> +       mutex_lock(&cma_lock);
> +
> +       list_for_each_entry(cma, &cma_areas, node) {
> +               int ret =3D it(cma, data);
> +
> +               if (ret) {
> +                       mutex_unlock(&cma_lock);
> +                       return ret;
> +               }
> +       }
> +
> +       mutex_unlock(&cma_lock);
> +       return 0;
> +}
> +
>  bool cma_intersects(struct cma *cma, unsigned long start, unsigned long =
end)
>  {
>         int r;
> @@ -1147,3 +1193,74 @@ void __init *cma_reserve_early(struct cma *cma, un=
signed long size)
>
>         return ret;
>  }
> +
> +struct cma *__init cma_create(phys_addr_t base, phys_addr_t size,
> +                             unsigned int order_per_bit, const char *nam=
e)
> +{
> +       struct cma *cma;
> +       int ret;
> +
> +       ret =3D cma_check_memory(base, size);
> +       if (ret < 0)
> +               return ERR_PTR(ret);
> +
> +       cma =3D kzalloc_obj(*cma, GFP_KERNEL);
> +       if (!cma)
> +               return ERR_PTR(-ENOMEM);
> +
> +       cma_init_area(cma, name, size, order_per_bit);
> +       cma->ranges[0].base_pfn =3D PFN_DOWN(base);
> +       cma->ranges[0].early_pfn =3D PFN_DOWN(base);
> +       cma->ranges[0].count =3D cma->count;
> +       cma->nranges =3D 1;
> +
> +       cma_activate_area(cma);
> +
> +       mutex_lock(&cma_lock);
> +       list_add_tail(&cma->node, &cma_areas);
> +       totalcma_pages +=3D cma->count;
> +       cma_area_count++;
> +       mutex_unlock(&cma_lock);
> +
> +       return cma;
> +}
> +
> +void cma_free(struct cma *cma)
> +{
> +       unsigned int i;
> +
> +       /*
> +        * Safety check to prevent a CMA with active allocations from bei=
ng
> +        * released.
> +        */
> +       for (i =3D 0; i < cma->nranges; i++) {
> +               unsigned long nbits =3D cma_bitmap_maxno(cma, &cma->range=
s[i]);
> +
> +               if (!bitmap_empty(cma->ranges[i].bitmap, nbits)) {
> +                       WARN(1, "%s: range %u not empty\n", cma->name, i)=
;
> +                       return;
> +               }
> +       }
> +
> +       /* free reserved pages and the bitmap */
> +       for (i =3D 0; i < cma->nranges; i++) {
> +               struct cma_memrange *cmr =3D &cma->ranges[i];
> +               unsigned long end_pfn, pfn;
> +
> +               end_pfn =3D cmr->base_pfn + cmr->count;
> +               for (pfn =3D cmr->base_pfn; pfn < end_pfn; pfn++)
> +                       free_reserved_page(pfn_to_page(pfn));
> +
> +               bitmap_free(cmr->bitmap);
> +       }
> +
> +       mutex_destroy(&cma->alloc_mutex);
> +
> +       mutex_lock(&cma_lock);
> +       totalcma_pages -=3D cma->count;
> +       list_del(&cma->node);
> +       cma_area_count--;
> +       mutex_unlock(&cma_lock);
> +
> +       kfree(cma);
> +}
> diff --git a/mm/cma.h b/mm/cma.h
> index c70180c36559..ae4db9819e38 100644
> --- a/mm/cma.h
> +++ b/mm/cma.h
> @@ -41,6 +41,7 @@ struct cma {
>         unsigned long   available_count;
>         unsigned int order_per_bit; /* Order of pages represented by one =
bit */
>         spinlock_t      lock;
> +       struct list_head node;
>         struct mutex alloc_mutex;
>  #ifdef CONFIG_CMA_DEBUGFS
>         struct hlist_head mem_head;
> @@ -71,8 +72,8 @@ enum cma_flags {
>         CMA_ACTIVATED,
>  };
>
> -extern struct cma cma_areas[MAX_CMA_AREAS];
> -extern unsigned int cma_area_count;
> +extern struct cma cma_early_areas[MAX_EARLY_CMA_AREAS];
> +extern unsigned int cma_early_area_count;
>
>  static inline unsigned long cma_bitmap_maxno(struct cma *cma,
>                 struct cma_memrange *cmr)
>
> --
> 2.54.0
>

