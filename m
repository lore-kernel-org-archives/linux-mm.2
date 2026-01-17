Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 165CFC9830C
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 01:21:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 289566B0005; Fri, 16 Jan 2026 20:21:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 235DA6B0088; Fri, 16 Jan 2026 20:21:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 118656B0089; Fri, 16 Jan 2026 20:21:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F29E96B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 20:21:45 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 671931402C0
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 01:21:45 +0000 (UTC)
X-FDA: 84339703770.21.8B4C365
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9D468180007
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 01:21:43 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QONudsMb;
	spf=pass (imf06.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768612903; a=rsa-sha256;
	cv=none;
	b=RsihogmyI9FWcmQSCSua19vzD4xL0DOirSkO607gdoOuTXkLLRQGAVHiGm3MuKc+PrUaUd
	BC04K0B0EzJkrZh/6m7bUXUUDOISLwnG/HH5u0L4OeTzXz+WBOJD6W5ZtslXUd2ieT948S
	i/l59kvY8p3XEYdlLaNg+hkfmGvpZjU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QONudsMb;
	spf=pass (imf06.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768612903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4ZoieeAq320wYXZiN7yy2TmOrY+yh5Mr8oDFBIEecDc=;
	b=Mv4RXHFV/ru87fn9JSKDaLzEyNp28ZYJznew0O/W6k2Ot6O5ZKAgvKLAU98+YqkIdPneT/
	XNWnHPh8zBSmfN4UfH+sgpKoZC/ul+s+jmNxend4yUNc/KB3Nijf/Z8+K3cFTpoUZshVfT
	IZ8n6TRlb7Z6Ib9cftuX+TBe8wY1Ym8=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-432d256c2a9so2560344f8f.3
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 17:21:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768612902; x=1769217702; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4ZoieeAq320wYXZiN7yy2TmOrY+yh5Mr8oDFBIEecDc=;
        b=QONudsMbKNrnn/gIbxzrLYKLU/vSNHmFJCI5C8qvxpHwI77Ma9som4VKl1DKlMYvNH
         seypoI25AgI4jMMs+lIhiIphzjxIJ12rbgpks8wgm8Yqwxwc3FfAj3umktJ0AntlWypg
         oRsxoMGhoerhZafmKVQYPoWhkk0ncb8r1YWG6v3QNOmNVcOr5n0iCHQzR8Z3dkmL9YMI
         HkaJtDfwlFuwmipWLVDUQdbPq/4/yIF3t5MsE0Kir4N3fRtTCZMsMiH1dp3Oy8eXOirW
         JBIWrAr6CXnbXMeU31zbgFNVGv7cbXkxScJxQAUh7BaBzIdSmp9agMUAFGwxJzh+sC7I
         l8hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768612902; x=1769217702;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4ZoieeAq320wYXZiN7yy2TmOrY+yh5Mr8oDFBIEecDc=;
        b=WH+QpFLlvnYkl8prd8sCYN2L1Hk3AOKCFJv+J3C/hJs918kTXArNUqfGbC7lfxuzLq
         9hv3B5TgFZ8/5uR2ASFTh++IENla9+k9DbkkahqdEIbBBD+ifNQ/PjgMBd1YE3rMewo3
         YkT/S6ohI4oHInBR/JyzukfOQ67x4vF/MxysAhF+3H83edZ5qINAdK/UKMiKRbfsrmJe
         Jc30xATwqpXmlErBJUppJyqMdGfmL/Rd7tJdTXg+YXpaYuqu04FhAXtk3FledtusKSeY
         Q6ugTTPjlitg1GMdJGjtlolwogSAe7+pFsxeSo/xmubHcAxXOnNH7xowu8/XTI7NxPZ+
         zusw==
X-Forwarded-Encrypted: i=1; AJvYcCW4QgZIvENwdHud0t2xdVGoqqUCf8IllH6vgxP2xT6GbZBOQdNuidbp0diLsQUB6aN2tfZ25BP+KA==@kvack.org
X-Gm-Message-State: AOJu0YyWnnVGGTfjV220lKYFB9UiZCpiIgMgBRI64Ewoc6aC1GrbHdAG
	EmKNO4bwgasOWbbB6EAepsyz9Gslv4FQO7cn72fC/fVXqCA402zGaj7QrtkL+zGe8RCEDbYYpgH
	sZZI0/EA7WUC7Xve6KRQ89tk7B5rGyOs=
X-Gm-Gg: AY/fxX7h6xOl9DX7ddFWAut3N8Jg55trSNjnSi/gUwiFgEIHj+59zad426iJiJfro3c
	i3ONYsStJgCsoCxUeukzCfpVrP93Yyp17gwYGp+lpI6OtEK6ziqp0/bJyc447ztXkRAviKxal3t
	b6mnRgJSGHz1ggFqAT493ea7cIVlcjNkuKU3P5zzDy6gC86H0p+A372GMt3ngjIJdTdcwS/aXcw
	625OzqOhoIjM8UiCFtmW4JzMrbQWydE5CUi0qccXXUp3mFsm/piLv/vZpuZm0v+R0BZKB5wZW0f
	X0/Ts6BpKaFNgG6psDKYrWAe/A1A
X-Received: by 2002:a05:6000:1861:b0:42b:4267:83e3 with SMTP id
 ffacd0b85a97d-4356a0330a6mr6681825f8f.5.1768612902135; Fri, 16 Jan 2026
 17:21:42 -0800 (PST)
MIME-Version: 1.0
References: <cover.1768233085.git.m.wieczorretman@pm.me> <b1dcc32aa58fd94196885842e0e7f7501182a7c4.1768233085.git.m.wieczorretman@pm.me>
 <CA+fCnZd+ANJ2w4R7ww7GTM=92UGGFKpaL1h56iRMN2Lr14QN5w@mail.gmail.com>
 <aWfDiNl9-9bVrc7U@wieczorr-mobl1.localdomain> <CA+fCnZd4rJvKzdMPmpYmNSto_dbJ_v6fdNYv-13_vC2+bu-4bg@mail.gmail.com>
 <aWkVn8iY27APFYy_@wieczorr-mobl1.localdomain>
In-Reply-To: <aWkVn8iY27APFYy_@wieczorr-mobl1.localdomain>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Sat, 17 Jan 2026 02:21:31 +0100
X-Gm-Features: AZwV_Qg_yxoV1caCuXx4uiUVJpxmUSikYvM_SoJc_MuJvTE1bQn56yiQmf6n8wA
Message-ID: <CA+fCnZewHBm+qR=zeJ4DG6RJ-mHhLhF9G7f_xSaNt_PAogJv2A@mail.gmail.com>
Subject: Re: [PATCH v8 13/14] x86/kasan: Logical bit shift for kasan_mem_to_shadow
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, kasan-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9D468180007
X-Stat-Signature: mohzsuks46bghw74m5778j8io8q1f34e
X-Rspam-User: 
X-HE-Tag: 1768612903-795378
X-HE-Meta: U2FsdGVkX1+svx1qhmY0NiCs9eQh2P/1Q/ReZICVNgLaqvfmiRmDhjf+NQI27cwHwj/U1GH0Y/Xkvtmj1s55LzaU9mb4n4lHCYRe9LNmQNHIz5lnsRrAi61eK4Cu1M9zwOyGQYz8Nu+2hylEReSSP4mYtLsRhpAYsFhhsufVVTl5eBSw5oIydWG5/0sk65jakKEJdc1yJKcqvcqhnDNAnWKmQCrUwyRxuafvqd8Sxz29LeodnwFr7LZv8TQEHYHiKEjOxha98+TgGBo+N5ZUBD8voOtQpB7xrz23VAEwp0CXUf2MawI4dxifE9z1gN7EYDtmWSRKm7LEXG2DZc3m5PzxXnAn9xTRtU2H4mow4Lzyliyv630wpKfLQ1MV+Tsl0tyuEoVkGzz0pFPdTuKWkB5TZUktVjAtME1V4Ac9/EhSRE7WXuP4jzHb9nABOyq0LQb6pTuMiKknYf8+NN1AoHVgwgHWuOgVucgH39b2RQak6l0XIjPbCOLLio7DeMohtsmaTuJSw/RwfANk9L7JYEQN+HjvUjao8YGf4OM1Ck9U+G9xXsQc18fB2I+sGPLgxQNsecus//Zu8ZxTG6YLhsQ9/gAJqaW4s8wjjzhyz2xLhB0MAvRm4TmNg4TVA//xnjnRDz6HMT9atCfNTKKy5FCIspmFeyTxJKyBO7e7tXV496Cyf4PKRBwyFCtwazE0/GmK9KchqOfaqhQ8WGJwk27g9aqfq9cyzyAE3WNnNktujVnq8SKIVj2gRtyCh2CCZzuFaeAfcBEspfBh6PvEe81qLI8DfoRZgzaV4sNwbe/ZTzTr7nQ7rdvxb2Sl5enPdpyfUq5s4Cwmq+XtBxwvJySfvBOSmhqLbqSmgXduULfedHFEWgWEa0orypRNHFEjQ4xgclauhYEgymQxW7jCnL2rOgt3jxXt0URPDJwFCjcHP9kaZ0AgANG3AUGeupTD+bmaY6WnkDLMwMDkqHW
 DbHi8qSw
 Iv878ZoOV3LbSs7fVzDn08oMCF8iDNuxUUx+sP1+6vPCCa9fGSls0pN0b064QXxG4QfSgjtSLra1MQUtqzmtG2yg3ufRECVoKnA1hmc8BqqwNP7W5z0N36PPb1e+vEOf8GdP/DbYf67p0q0Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 5:43=E2=80=AFPM Maciej Wieczor-Retman
<m.wieczorretman@pm.me> wrote:
>
> x86 was easy to do because the kasan_mem_to_shadow() was already in the
> asm/kasan.h. arm64 took a bit more changes since I had to write the
> arch_kasan_non_canonical_hook in a separate file that would import the
> linux/kasan.h header in order to use kasan_mem_to_shadow(). Anyway below =
are the
> relevant bits from the patch - does that look okay? Or would you prefer s=
ome
> different names/placements?

One comment below, otherwise looks fine to me, thanks!

>
> diff --git a/arch/arm64/include/asm/kasan.h b/arch/arm64/include/asm/kasa=
n.h
> index b167e9d3da91..16b1f2ca3ea8 100644
> --- a/arch/arm64/include/asm/kasan.h
> +++ b/arch/arm64/include/asm/kasan.h
> @@ -17,6 +17,8 @@
>
>  asmlinkage void kasan_early_init(void);
>  void kasan_init(void);
> +bool __arch_kasan_non_canonical_hook(unsigned long addr);
> +#define arch_kasan_non_canonical_hook(addr) __arch_kasan_non_canonical_h=
ook(addr)
>
>  #else
>  static inline void kasan_init(void) { }
>
> diff --git a/arch/arm64/mm/Makefile b/arch/arm64/mm/Makefile
> index c26489cf96cd..a122ea67eced 100644
> --- a/arch/arm64/mm/Makefile
> +++ b/arch/arm64/mm/Makefile
> @@ -15,4 +15,6 @@ obj-$(CONFIG_ARM64_GCS)               +=3D gcs.o
>  KASAN_SANITIZE_physaddr.o      +=3D n
>
>  obj-$(CONFIG_KASAN)            +=3D kasan_init.o
> +obj-$(CONFIG_KASAN)            +=3D kasan.o
>  KASAN_SANITIZE_kasan_init.o    :=3D n
> +KASAN_SANITIZE_kasan.o         :=3D n
> diff --git a/arch/arm64/mm/kasan.c b/arch/arm64/mm/kasan.c
> new file mode 100644
> index 000000000000..b94d5fb480ca
> --- /dev/null
> +++ b/arch/arm64/mm/kasan.c
> @@ -0,0 +1,31 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * This file contains ARM64 specific KASAN code.
> + */
> +
> +#include <linux/kasan.h>
> +
> +bool __arch_kasan_non_canonical_hook(unsigned long addr) {
> +       /*
> +        * For Software Tag-Based KASAN, kasan_mem_to_shadow() uses the
> +        * arithmetic shift. Normally, this would make checking for a pos=
sible
> +        * shadow address complicated, as the shadow address computation
> +        * operation would overflow only for some memory addresses. Howev=
er, due
> +        * to the chosen KASAN_SHADOW_OFFSET values and the fact the
> +        * kasan_mem_to_shadow() only operates on pointers with the tag r=
eset,
> +        * the overflow always happens.
> +        *
> +        * For arm64, the top byte of the pointer gets reset to 0xFF. Thu=
s, the
> +        * possible shadow addresses belong to a region that is the resul=
t of
> +        * kasan_mem_to_shadow() applied to the memory range
> +        * [0xFF000000000000, 0xFFFFFFFFFFFFFFFF]. Despite the overflow, =
the
> +        * resulting possible shadow region is contiguous, as the overflo=
w
> +        * happens for both 0xFF000000000000 and 0xFFFFFFFFFFFFFFFF.
> +        */
> +       if (IS_ENABLED(CONFIG_KASAN_SW_TAGS)) {
> +               if (addr < (unsigned long)kasan_mem_to_shadow((void *)(0x=
FFULL << 56)) ||
> +                   addr > (unsigned long)kasan_mem_to_shadow((void *)(~0=
ULL)))
> +                       return true;
> +       }
> +       return false;
> +}
> diff --git a/include/linux/kasan.h b/include/linux/kasan.h
> index 9c6ac4b62eb9..146eecae4e9c 100644
> --- a/include/linux/kasan.h
> +++ b/include/linux/kasan.h
> ...
> @@ -403,6 +409,13 @@ static __always_inline bool kasan_check_byte(const v=
oid *addr)
>         return true;
>  }
>
> +#ifndef arch_kasan_non_canonical_hook
> +static inline bool arch_kasan_non_canonical_hook(unsigned long addr)
> +{
> +       return false;
> +}
> +#endif

Let's put this next to kasan_non_canonical_hook declaration.

> +
>  #else /* CONFIG_KASAN */
>
> diff --git a/mm/kasan/report.c b/mm/kasan/report.c
> index 62c01b4527eb..1c4893729ff6 100644
> --- a/mm/kasan/report.c
> +++ b/mm/kasan/report.c
> @@ -642,10 +642,19 @@ void kasan_non_canonical_hook(unsigned long addr)
>         const char *bug_type;
>
>         /*
> -        * All addresses that came as a result of the memory-to-shadow ma=
pping
> -        * (even for bogus pointers) must be >=3D KASAN_SHADOW_OFFSET.
> +        * For Generic KASAN, kasan_mem_to_shadow() uses the logical righ=
t shift
> +        * and never overflows with the chosen KASAN_SHADOW_OFFSET values=
. Thus,
> +        * the possible shadow addresses (even for bogus pointers) belong=
 to a
> +        * single contiguous region that is the result of kasan_mem_to_sh=
adow()
> +        * applied to the whole address space.
>          */
> -       if (addr < KASAN_SHADOW_OFFSET)
> +       if (IS_ENABLED(CONFIG_KASAN_GENERIC)) {
> +               if (addr < (unsigned long)kasan_mem_to_shadow((void *)(0U=
LL)) ||
> +                   addr > (unsigned long)kasan_mem_to_shadow((void *)(~0=
ULL)))
> +                       return;
> +       }
> +
> +       if(arch_kasan_non_canonical_hook(addr))
>                 return;
>
> --
> Kind regards
> Maciej Wiecz=C3=B3r-Retman
>

