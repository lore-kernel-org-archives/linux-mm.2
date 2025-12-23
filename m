Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C388E6FE24
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 18:09:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 778406B0005; Tue, 23 Dec 2025 13:09:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 724DD6B0089; Tue, 23 Dec 2025 13:09:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 607E06B008A; Tue, 23 Dec 2025 13:09:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4EDD06B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 13:09:39 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DEB3716046C
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 18:09:38 +0000 (UTC)
X-FDA: 84251523636.12.9721BD1
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf14.hostedemail.com (Postfix) with ESMTP id DAFD610000E
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 18:09:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="ZGaCs/5G";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766513377; a=rsa-sha256;
	cv=none;
	b=dPk6wXfmi+itBhvYz9guREzZQhXUmtPVbQgrVggq+ttAsD0Zif+p2pZUqx9YxTQ4a//93l
	50xZl+AV4L9CAwUzRirv8zRMRdh74V7b+FNL+ZypvmkNf/A+W7exsEgbxnWd8qQvTZRLnv
	DGcCfc/oUPbL5ALez4wVZuO8XWLKjkQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="ZGaCs/5G";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766513377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y0mvoCbuMd4eC9vUuRIk+xJnlqy18MydCTDV6Wj6wlQ=;
	b=WMsPS/90EtN0R47MMt1kFg8nFB9N996KVxX/0537pcHItAj5M3jUe/0leTFqXKjlXZXlVB
	KPdrequPBzSEEXo/bRTINz+hQ8eyp/HXRuU4T9rXkmPu1l+ByuVQ+9M5tOkBB4TJ9AI6Lf
	nd4AaMlSyDuI2KC73ETPbxRWPqyzbWo=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-64b8e5d1611so6227648a12.3
        for <linux-mm@kvack.org>; Tue, 23 Dec 2025 10:09:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1766513375; x=1767118175; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y0mvoCbuMd4eC9vUuRIk+xJnlqy18MydCTDV6Wj6wlQ=;
        b=ZGaCs/5GxsTKJ0mBFN9Az5PD68vNVLPfbJ4grCj5Lk4OX3qjqtewn8aDGF/XoUjZjY
         W7sr/0gOytO5k7vPfWuaKKojfINeMCLFWl1rm8/o+a++7oYHknLNvPUjquddUz1oVZrP
         CuxK2kje3R/OXBo+xlOSVAw/nQ2y7RTglD54H+/QNNgySuc9KE/rQfF3Qhg3s4/uA1WQ
         tJTrqAvy4KCcDUohNw43sl9IqBefDet+xNQ8t6RZI088bZUtXq9ljc+e8VHXv3VxewoT
         EcfGFCsEic5TMde/zFZHD/gM1Af3SYwjyaGFhCYAdQcpgFy3f1Yb51dNOZS0D12PcVS/
         4aPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766513375; x=1767118175;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=y0mvoCbuMd4eC9vUuRIk+xJnlqy18MydCTDV6Wj6wlQ=;
        b=wXbl6IeXglwGGRPsXZsbmUNTamb44x6tKQ0+Xlg8AV5UedkCMNF2mKKqczyCrew1d3
         TCCdY+XHK/za7/jSfgdOFHXITtjLdQ7B/q280LJwiHxtRW8gQ3lgM5+NvkSS6DQP3fFj
         W8BAwFhcID93ygRL9Q28Po0q9LLBkMP5U50aGp3mR5oacYFbQcl+2HAli8xrUiumMCbO
         Acc+JDplb2t4DB2Y4pwcPkgnW2KYuEaUF+ig0lJBGSo8HVpDgHGR2ZtrfO5AAhi/XYb3
         fMx8yQsqnLeIoYO6GATxm+gpVZKb1UW8aKKo2Tjs6Nz2rJX8A2aMNvRrILtE1s368rX7
         uneA==
X-Forwarded-Encrypted: i=1; AJvYcCU5CwwqHzQgen+IK+P+6jiUSeylP8mW+5aX48Vxm+q6Zqs8CjgsIeObWaNHpIKHu8CL3vyH97nIdA==@kvack.org
X-Gm-Message-State: AOJu0YxaxXISwwhMvbCPOci85SCGwQQTKr1Z5t5tFzRwDd7aBFAiH5Fl
	3FeO8UTP4wsAE8xyyrcSLBSryotsWwxEe3iTEaGaohvbJnB9PngIOjlah2+VahzLZZ/U0ThycCj
	xF56RAXQACW7BXGOaKUsjFfVl04hOytQpgHJ++FoUvLRXzCFL+FzDqUg=
X-Gm-Gg: AY/fxX6zUAilB0obnAwAsuQnQEAIF27x9j74YcudPkA+7nZlfNYBEP19yKRsHnt9GSJ
	gTbG6OkrswOO2pXIeLqqTMF5kYXMr5+bAf6Gl4om3+3psv8ra5+OvKgNgtICdk/tftrmWvkaM9Z
	px4VWGds0A8kWEb76heBFSeSSb+l8rw7kioi+mfDdPrKxevyy3/zhjSIrUTNTU38yrXvgwMP94x
	BfMbk86M/cKldExPSo+GNWKmR2sk/4T3V4suUtsvVyHuZBCU3nx9Yb+Vjz6Jr6HTxuHeEjYx5QA
	LeZ6MsuGlshWusucMOCXwmHnwg==
X-Google-Smtp-Source: AGHT+IHHyUf0R+vHniFfbEYJMvb3fpH/MlbN/XPxv0Z5WmJczLbpPFoRGmWoDzSU9Fg1wq7iuKESJj2bcABIf0GuBCY=
X-Received: by 2002:a05:6402:535b:20b0:64c:62f7:1ac4 with SMTP id
 4fb4d7f45d1cf-64c62f71cb9mr9764002a12.32.1766513375289; Tue, 23 Dec 2025
 10:09:35 -0800 (PST)
MIME-Version: 1.0
References: <20251206230222.853493-1-pratyush@kernel.org> <20251206230222.853493-4-pratyush@kernel.org>
In-Reply-To: <20251206230222.853493-4-pratyush@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 23 Dec 2025 13:08:59 -0500
X-Gm-Features: AQt7F2pUw5VhwuozKnCUEq4zB5jjvJjDYSUWusyCg9tH-jAG1cRM1Slm6WUoNhs
Message-ID: <CA+CK2bApV4A-hCO3eHX7-1QdjDX=FpnrVHfa8TQBt_1JStY-BA@mail.gmail.com>
Subject: Re: [RFC PATCH 03/10] liveupdate: do early initialization before
 hugepages are allocated
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Alexander Graf <graf@amazon.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Vipin Sharma <vipinsh@google.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, kexec@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: DAFD610000E
X-Stat-Signature: g5ujf5eqeifbri7rod4mdbn1q1jp74ss
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766513376-19012
X-HE-Meta: U2FsdGVkX1/BrU02xoUtjhMvIvUbsDFNP1TOzUl75+NmPas9LLcDODfawIkuZ7fOluYsw5GHqx6YsQ/PLUZufRk2tDKOb7eoBN6gRv6QYPMP3B4xZ62WlMA0CBazmg1FSEpu7rd7unRH77qx6qdhNcBTolWbW5hljJqN7j0Ndtdn/wRlqVwE5QMlRHLKXlBfotb2eh10hgYcZsD8paa2xFrx2wFWlE5LAZ96W2IX00p55GG1YrgVVi0N8IFlh/qkaWlG3aJi63oSHwRI9BNbBuMw9sngqUkPwNIcGWd7Tk2lfonZ4XTymFO2Q0RVFOdojyl1i+wMGPY/KyDco/jElVCNjXm8rRQthW7RpixZSB79UtEU6y6Takxyk+pipvfbrC6zCt/4R2y8HbrmZoYDsFrPggkRVHCIRE5fF6EnLpmTc0mVneRQkACmyVTxs4gKEXHBWy4xAdiCgauUbLKyM4PSk7Jz6InXGagUhfK2ibvq7a+s5vzpnFgxlLaVJ7/+b8PUE1MNgVTZC0MJGBuak+zSJA6bq4whnEa1FoOl2MBUjTClJRZAYYv2GwDKILE6uBKsYuQX0KeXF392bjXpL+jybXEZBEwuUSFFikr58PWMnZIgiO0Tk8IedAPnzmAtVGLBprQaxGxJ2h45vhFPKrgtX5AZ805xbF2iUwDnzriicR+zwpAQmrQ8tUSpj/wbTTIavWxunI5gz+Rp3Upwq79w4JCOxT452AhRl2uH/Ny9xnzAn+dXBAIQEwFdwNHjsZCn0oOTA8sxepGUhob1L0zN22qwoUksXO8sVYlBDpy07H4ljGQ3q/GtWbkTSGyig8jLKB9z2Ve5q937ntqNU1VEmWbjSDhXHLtGIFCRKVqpt8TxBYjo0onnZIRMiLZMJzGF3BcpBuGooz4N8FvEteDwUpd8BwJO3aK2cum7bmhqQs2GBDk8vVa9bV+VG9c5zR45ZwWa2jJVlyiEIKy
 R53zI/le
 dC6kMxO94Vy4WcYNFcpPS3gW0tRnbKdwxjEnTjS6WgDzlvNN9IQZjmbMpsFVD6ew2Shpv3O6J8Mpb2IUcNps5GPFgK1tL7ufbwDDoiZMNCUD/m0qkewc4WjVh93bKfgD6f99X4RIWHqkacluILPU3wq/kyrCWKVrNxFxryw9TvuAONj3wv2obNAayG6qC9TsR0g2RX+xmFLhd/tX3HYA4f+iTRzRf+Hr+N/YpLaBN3pl/+D/XFYQitvTU3A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Dec 6, 2025 at 6:03=E2=80=AFPM Pratyush Yadav <pratyush@kernel.org>=
 wrote:
>
> To support hugepage preservation using LUO, the hugetlb subsystem needs
> to get liveupdate data when it allocates the hugepages to find out how
> many pages are coming from live update.
>
> Move early LUO init from early_initcall to mm_core_init(). This is where
> gigantic hugepages are allocated on ARM64. On x86, they are allocated in
> setup_arch(), so have a call there as well. Keep track of whether the
> function was already called to avoid double-init.
>
> liveupdate_early_init() only gets the KHO subtree and validates the data
> to ensure it is valid and understood. These are read-only operations and
> do not need much from the system, so it is safe to call early in boot.
>
> Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
> ---
>  arch/x86/kernel/setup.c          |  7 +++++++
>  include/linux/liveupdate.h       |  6 ++++++
>  kernel/liveupdate/luo_core.c     | 30 ++++++++++++++++++++++++++----
>  kernel/liveupdate/luo_internal.h |  2 ++
>  mm/mm_init.c                     |  7 +++++++
>  5 files changed, 48 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 9bf00287c408..e2ec779afc2c 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -26,6 +26,7 @@
>  #include <linux/tboot.h>
>  #include <linux/usb/xhci-dbgp.h>
>  #include <linux/vmalloc.h>
> +#include <linux/liveupdate.h>
>
>  #include <uapi/linux/mount.h>
>
> @@ -1216,6 +1217,12 @@ void __init setup_arch(char **cmdline_p)
>
>         kho_memory_init();
>
> +       /*
> +        * Hugepages might be preserved from a liveupdate. Make sure it i=
s
> +        * initialized so hugetlb can query its state.
> +        */
> +       liveupdate_early_init();
> +
>         if (boot_cpu_has(X86_FEATURE_GBPAGES)) {
>                 hugetlb_cma_reserve(PUD_SHIFT - PAGE_SHIFT);
>                 hugetlb_bootmem_alloc();
> diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
> index ed81e7b31a9f..78e8c529e4e7 100644
> --- a/include/linux/liveupdate.h
> +++ b/include/linux/liveupdate.h
> @@ -214,6 +214,8 @@ struct liveupdate_flb {
>
>  #ifdef CONFIG_LIVEUPDATE
>
> +void __init liveupdate_early_init(void);
> +
>  /* Return true if live update orchestrator is enabled */
>  bool liveupdate_enabled(void);
>
> @@ -233,6 +235,10 @@ int liveupdate_flb_get_outgoing(struct liveupdate_fl=
b *flb, void **objp);
>
>  #else /* CONFIG_LIVEUPDATE */
>
> +static inline void liveupdate_early_init(void)
> +{
> +}
> +
>  static inline bool liveupdate_enabled(void)
>  {
>         return false;
> diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
> index 7a9ef16b37d8..2c740ecad8e6 100644
> --- a/kernel/liveupdate/luo_core.c
> +++ b/kernel/liveupdate/luo_core.c
> @@ -69,6 +69,13 @@ static struct {
>         u64 liveupdate_num;
>  } luo_global;
>
> +static bool __luo_early_initialized __initdata;
> +
> +bool __init luo_early_initialized(void)
> +{
> +       return __luo_early_initialized;
> +}

I think the above is not needed, both the global variable, and a new functi=
on.

> +
>  static int __init early_liveupdate_param(char *buf)
>  {
>         return kstrtobool(buf, &luo_global.enabled);
> @@ -133,20 +140,35 @@ static int __init luo_early_startup(void)
>         return err;
>  }
>
> -static int __init liveupdate_early_init(void)
> +/*
> + * This should only be called after KHO FDT is known. It gets the LUO su=
btree
> + * and does initial validation, making early boot read-only access possi=
ble.
> + */
> +void __init liveupdate_early_init(void)
>  {
>         int err;
>
> +       /*
> +        * HugeTLB needs LUO to be initialized early in boot, before giga=
ntic
> +        * hugepages are allocated. On x86, that happens in setup_arch(),=
 but on
> +        * ARM64 (and other architectures) that happens in mm_core_init()=
.
> +        *
> +        * Since the code in mm_core_init() is shared between all archite=
ctures,
> +        * this can lead to the init being called twice. Skip if initiali=
zation
> +        * was already done.
> +        */
> +       if (__luo_early_initialized)
> +               return;
> +
> +       __luo_early_initialized =3D true;

Please, make __luo_early_initialized static local.

> +
>         err =3D luo_early_startup();
>         if (err) {
>                 luo_global.enabled =3D false;
>                 luo_restore_fail("The incoming tree failed to initialize =
properly [%pe], disabling live update\n",
>                                  ERR_PTR(err));
>         }
> -
> -       return err;
>  }
> -early_initcall(liveupdate_early_init);
>
>  /* Called during boot to create outgoing LUO fdt tree */
>  static int __init luo_fdt_setup(void)
> diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_int=
ernal.h
> index 6115d6a4054d..171c54af7b38 100644
> --- a/kernel/liveupdate/luo_internal.h
> +++ b/kernel/liveupdate/luo_internal.h
> @@ -114,6 +114,8 @@ int __init luo_flb_setup_outgoing(void *fdt);
>  int __init luo_flb_setup_incoming(void *fdt);
>  void luo_flb_serialize(void);
>
> +bool __init luo_early_initialized(void);
> +
>  #ifdef CONFIG_LIVEUPDATE_TEST
>  void liveupdate_test_register(struct liveupdate_file_handler *fh);
>  void liveupdate_test_unregister(struct liveupdate_file_handler *fh);
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 93cec06c1c8a..9a5b06a93622 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -31,6 +31,7 @@
>  #include <linux/execmem.h>
>  #include <linux/vmstat.h>
>  #include <linux/kexec_handover.h>
> +#include <linux/liveupdate.h>
>  #include <linux/hugetlb.h>
>  #include "internal.h"
>  #include "slab.h"
> @@ -2681,6 +2682,12 @@ void __init mm_core_init(void)
>         arch_mm_preinit();
>
>         kho_memory_init();
> +       /*
> +        * Hugepages might be preserved from a liveupdate. Make sure it i=
s
> +        * initialized so hugetlb can query its state.
> +        */
> +       liveupdate_early_init();
> +
>         hugetlb_bootmem_alloc();
>
>         /* Initializations relying on SMP setup */
> --
> 2.43.0
>

