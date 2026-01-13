Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B010CF45C6
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 01:21:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9222B6B008A; Mon, 12 Jan 2026 20:21:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 903006B008C; Mon, 12 Jan 2026 20:21:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 801EE6B0092; Mon, 12 Jan 2026 20:21:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6E8286B008A
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 20:21:37 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3AFE414125F
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 01:21:37 +0000 (UTC)
X-FDA: 84325188234.13.B618960
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4A0064000E
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 01:21:35 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="I0t5H5M/";
	spf=pass (imf07.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768267295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+kYsG3mV0sbzUWkAERcIglZDWBTvQOS7pyKTkWEtOSo=;
	b=xU9Ey85r1y5aULnlfYRPOmJtfubYX34fWlqJhMxWRen0gJmcTE16EuT9+yw0r1++6mSWbC
	gIcMNZIAgh4zTLnqNUHKi3YiiELO065s5Twkwh0rT6gRpkBAge3x/LGqr4uEzn98q94NJA
	gCdPB9qzhDgjDhwMBdUMEOSclqxYja0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="I0t5H5M/";
	spf=pass (imf07.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768267295; a=rsa-sha256;
	cv=none;
	b=aibAbmMdzqqG1X29k11jjQdtdDWuG7yM6jRVy3tj4jjYIiamAKyv6bTNymkErcPke4hqxv
	v3hkwOziarnq7Kaz2sIPAVmGIHOM2dNi7ZxHXPCvDVKRA6deDbwTgKTYRvgu9D0icTZ8cN
	AwytiRRXhEKbeQmlnEXxoS/wY8zo6LY=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-432d2c7dd52so3535007f8f.2
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 17:21:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768267294; x=1768872094; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+kYsG3mV0sbzUWkAERcIglZDWBTvQOS7pyKTkWEtOSo=;
        b=I0t5H5M/yQEok1ATZ1M589jiUuVB8cX8ryL+pcz0eAUeNrITSQHyrwkrw5W68kb44P
         DAUqky5WRitG+bqGV+wjAqZx+yQwDHne0dTDZEr38CRjLgWABLC4C5i3KHkPHF512cua
         QFRUYebFReLa1Y6fvkn3aPg+9ao0TDQ5pNL2AGuZocq/UmFobr9k9s0AQ/rhdLpKc/2u
         Zsjqdq666KjY09gYbdYsaA0f5bnlGzAoubwTR0fTyL7AzjDaipDu27UXBHeTxDn4UVb1
         fxLRwe6wETyaNrf1f9GlgMDic780T5vPcRyCHLIOOYOVcA+xFPiG93MiMI1eRlLRB/P7
         IyHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768267294; x=1768872094;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+kYsG3mV0sbzUWkAERcIglZDWBTvQOS7pyKTkWEtOSo=;
        b=PScYcXjLegyYrycSnnnuOyKvMaL8SUe6tcekTJhrX0d5VXRo2aMK/A3To1ieseo32s
         FewWUPHRV6XxR+6uDVQ8wVWZRorgiMx6H0O0yUURrjmajcFlRr4GcNOiNFbDnXOU2TWn
         8zPh51IVKraYladg2jX9Vqp4pHUeRCrXe0MQ3oODcuZpZ8WoJZfM6uKX83nWtAGUr6HE
         FLBI/MBZ0ibmwKiS/FOekImYwySXTh98QfoiBTEGnMuEOdiFyXZXs/dW5pJQOE+YmY83
         WxdGCt+UJYR1YbRG92MPRocqQUxvEuN0ceN7Gs7yaHv42wbAmICKyesuMoEzVW/daF16
         07+A==
X-Forwarded-Encrypted: i=1; AJvYcCXCYbid0cBr4rUrTkQXGswphFutCYJKsMAqeucOSEQSaa3PIkMAumJLW4BdTXt7rkG80h5HcxNOsw==@kvack.org
X-Gm-Message-State: AOJu0YzDqCUwhZZWRqOP6ISSPTbaKLBfq5zDb2bHjbgSOPxjoIsv2t1W
	v6oLBJcAwTZNG1Z6q5HI3ElZ+B81AGUC0sws+wutzgn+dJPmbiVNNqEr/Rg0T2YJE7DDoYHjVZx
	eXQit2JWfyNlIUPlJKbn5OEOggSDEkRs=
X-Gm-Gg: AY/fxX4aByhauHFvKxRquhZ8I6iYO/Ymxot5lOmZKln0IhJzELzKLul5FW6K1ujiF4O
	NkMn1mzhNY+F6OWaUHbnA7o6KO3uCFd6ILls2H2Jnh5D3atz+LkQO88IKayDDb2KsftmzwwgGvz
	1yj2U7VobSUcz9cgg/DL5dZV3KZptoPYRD3D3y3Fejw15bGZIfblIPFAAbxCUAFB3ls+SwRbSln
	R8w2H58wN8QPatv9JzIis6Vt4RoLxLm9hX5B/UF5Seh8eZCb5DR4y2nfoZ7vErVd/WDauj9LmxN
	mQ9j7dyAF7JpShmvacToMl7ZqrYgkg==
X-Google-Smtp-Source: AGHT+IE5+MYzhc0Zzqxijlxr3Cn+8K/KOSpIRkOxsGJGa0Q7A9J+AvpPJubIhPx3kkzmrDHIJv/bwm5X1GYdkxJ1AR4=
X-Received: by 2002:a05:6000:2304:b0:430:fdb8:8516 with SMTP id
 ffacd0b85a97d-432c37983camr23147516f8f.35.1768267293759; Mon, 12 Jan 2026
 17:21:33 -0800 (PST)
MIME-Version: 1.0
References: <cover.1768233085.git.m.wieczorretman@pm.me> <b1dcc32aa58fd94196885842e0e7f7501182a7c4.1768233085.git.m.wieczorretman@pm.me>
In-Reply-To: <b1dcc32aa58fd94196885842e0e7f7501182a7c4.1768233085.git.m.wieczorretman@pm.me>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Tue, 13 Jan 2026 02:21:22 +0100
X-Gm-Features: AZwV_Qi7NcaRI_4PWis1HHKIe5umJhGkHSO55_zW27-aOrJoc50Q2vucvefyxkc
Message-ID: <CA+fCnZd+ANJ2w4R7ww7GTM=92UGGFKpaL1h56iRMN2Lr14QN5w@mail.gmail.com>
Subject: Re: [PATCH v8 13/14] x86/kasan: Logical bit shift for kasan_mem_to_shadow
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, kasan-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4A0064000E
X-Stat-Signature: d994pgfrin1p4z1qft48jp7upweegsz6
X-HE-Tag: 1768267295-617063
X-HE-Meta: U2FsdGVkX1/ntVrv4xJIzAj8z34dYIHkVdLBXVnCoEbelmTE0fj2RIZ5vRbUPucR7PrN2mJB1xqxQ+J0PYWpdfqtvgHPnK8Gc/13aXwCUK4waIy8CMoWtPzEemN6+ZOstph+rxd4gU3m7LSCDEjCFGqQdVzIZL2c7o3y0dLpi3Ja1aO1B/oLc61hJ+uCCnIh8jraNipHPilUlOR+FJNSmGXAPjkWEI3vbHgDdXp26JuTJ6RAVSukvL0hgod4DQXp34suIS9qM2Vm6p6hxryHKdcJKUWwYcfuEdRRsOpZoFoO6IQtd27MWySbL36Yqvh/yvBgp/6wPiS7S/5zMXALMLWp5+k6vTi9h9ps7mdoUm4c4y3jb2jdszvCBkcBSHBQcnQLkAiFHk3FF6ik6gSfTQAMpdh11k+GC/8OVPKj5+3N/B7fZvKUrII8Y5p3z7telLnUQFhKL/cQePD//quZEOr413Nm6qlCNuVyrQCRy/Nni0GvIRkgLcgHKeT9T2Wm3CQ2yYukxSQGrT5maCOrQ7VxftuaGpwTmhPm1a2Bif9AibcLtF5K2j9mFRgTJVPgeUw3nl0bSWJW6AGNM/9gnvy3i05ze8x5aqAqSss1xtiC3QZEeh/LwMBpMYH0VZppIVn/Ug2d7ZF8OA0K7EBYoJzIb7ypgMhXhNWi2RLTksE9alMWFma72eFNtyX5nG8YmVd1EoFSE3w5gu9sjkVGFS2/1WNopUVZf46cjhAxUouip6xmfdMttW6QdoezulGA0vUsMqmn+F3o/PLtwbrdFfi1Qa/NihGRCXNxU/wgg0YB5i+FoIvWB2NiGR112qGOeaKqctV0iAI7tyYDAWxS9lJHUWs1Q/6vwvbMrwntVkj/r5fY8NIX3hCXsXEOhUuWoG4UzkJiRXwzIrymij90iLBkETIah7p+eJuKkSHTfp2pJwZaXUWaPOQpbFBKvE+zPLlGgEVCATzM3zs+B6e
 42dHQ3AS
 r3RTrlvv8SGRUT4HKGeb+CgB+xTink2cdvXQkfe4iJCEZmHVlaO/1cOMgU2DkbtES0faFIIwwouc6qYt7vwZTZ+t7oU7X6ZD+XVaWWy/ruksU4sqZ+no3SraTx1fby5wYAyOhd9yc5sYLuRzYHvPSNh5bIKu/BhG0mnX9029Xi5jic85RnTmeRoykoo6fdpK+W9FQsEAWJd5iDgvz34KwUWHKYomRFuo824U63039IqAv9PvRAKSHSejhtGhPcCUHwaGObs7JdVCG6CL7jTnuGud2M1Klg/vrGALEOyZePol6axsCMSnQ3LbtInIUxJ991fv1XsBbjozUW90tXYt9jnd62mPxByubYYtNNUrF9r3//j9gq67cukhzLl0Z8gENTjHEvpKmP23HBFgNCsN0oWPjBQgtaUP75s0l0QOKykJFvC+ENCXGL3JNsFJvooJBcGMh/6zQjeabojmZjDPftniwtK2Lco6F9kH2abWAMqpa+1O7Y9ofkOgnjxMv1kRKTUs/IrVt8B0QBQcmPSd2z4EZ+UTmb/jLO7Pi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 6:28=E2=80=AFPM Maciej Wieczor-Retman
<m.wieczorretman@pm.me> wrote:
>
> From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
>
> The tag-based KASAN adopts an arithemitc bit shift to convert a memory
> address to a shadow memory address. While it makes a lot of sense on
> arm64, it doesn't work well for all cases on x86 - either the
> non-canonical hook becomes quite complex for different paging levels, or
> the inline mode would need a lot more adjustments. Thus the best working
> scheme is the logical bit shift and non-canonical shadow offset that x86
> uses for generic KASAN, of course adjusted for the increased granularity
> from 8 to 16 bytes.
>
> Add an arch specific implementation of kasan_mem_to_shadow() that uses
> the logical bit shift.
>
> The non-canonical hook tries to calculate whether an address came from
> kasan_mem_to_shadow(). First it checks whether this address fits into
> the legal set of values possible to output from the mem to shadow
> function.
>
> Tie both generic and tag-based x86 KASAN modes to the address range
> check associated with generic KASAN.
>
> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
> ---
> Changelog v7:
> - Redo the patch message and add a comment to __kasan_mem_to_shadow() to
>   provide better explanation on why x86 doesn't work well with the
>   arithemitc bit shift approach (Marco).
>
> Changelog v4:
> - Add this patch to the series.
>
>  arch/x86/include/asm/kasan.h | 15 +++++++++++++++
>  mm/kasan/report.c            |  5 +++--
>  2 files changed, 18 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/include/asm/kasan.h b/arch/x86/include/asm/kasan.h
> index eab12527ed7f..9b7951a79753 100644
> --- a/arch/x86/include/asm/kasan.h
> +++ b/arch/x86/include/asm/kasan.h
> @@ -31,6 +31,21 @@
>  #include <linux/bits.h>
>
>  #ifdef CONFIG_KASAN_SW_TAGS
> +/*
> + * Using the non-arch specific implementation of __kasan_mem_to_shadow()=
 with a
> + * arithmetic bit shift can cause high code complexity in KASAN's non-ca=
nonical
> + * hook for x86 or might not work for some paging level and KASAN mode
> + * combinations. The inline mode compiler support could also suffer from=
 higher
> + * complexity for no specific benefit. Therefore the generic mode's logi=
cal
> + * shift implementation is used.
> + */
> +static inline void *__kasan_mem_to_shadow(const void *addr)
> +{
> +       return (void *)((unsigned long)addr >> KASAN_SHADOW_SCALE_SHIFT)
> +               + KASAN_SHADOW_OFFSET;
> +}
> +
> +#define kasan_mem_to_shadow(addr)      __kasan_mem_to_shadow(addr)
>  #define __tag_shifted(tag)             FIELD_PREP(GENMASK_ULL(60, 57), t=
ag)
>  #define __tag_reset(addr)              (sign_extend64((u64)(addr), 56))
>  #define __tag_get(addr)                        ((u8)FIELD_GET(GENMASK_UL=
L(60, 57), (u64)addr))
> diff --git a/mm/kasan/report.c b/mm/kasan/report.c
> index b5beb1b10bd2..db6a9a3d01b2 100644
> --- a/mm/kasan/report.c
> +++ b/mm/kasan/report.c
> @@ -642,13 +642,14 @@ void kasan_non_canonical_hook(unsigned long addr)
>         const char *bug_type;
>
>         /*
> -        * For Generic KASAN, kasan_mem_to_shadow() uses the logical righ=
t shift
> +        * For Generic KASAN and Software Tag-Based mode on the x86
> +        * architecture, kasan_mem_to_shadow() uses the logical right shi=
ft
>          * and never overflows with the chosen KASAN_SHADOW_OFFSET values=
 (on
>          * both x86 and arm64). Thus, the possible shadow addresses (even=
 for
>          * bogus pointers) belong to a single contiguous region that is t=
he
>          * result of kasan_mem_to_shadow() applied to the whole address s=
pace.
>          */
> -       if (IS_ENABLED(CONFIG_KASAN_GENERIC)) {
> +       if (IS_ENABLED(CONFIG_KASAN_GENERIC) || IS_ENABLED(CONFIG_X86_64)=
) {

Not a functionality but just a code organization related concern:

Here, we embed the CONFIG_X86_64 special case in the core KASAN code,
but the __kasan_mem_to_shadow definition to use the logical shift
exists in the x86-64 arch code, and it just copy-pastes one of the
cases from the core kasan_mem_to_shadow definition.

Should we just move the x86-64 special case to the core KASAN code too
then? I.e., change the kasan_mem_to_shadow definition in
include/linux/kasan.h to check for IS_ENABLED(CONFIG_X86_64)).

And we could also add a comment there explaining how using the logical
shift for SW_TAGS benefits some architectures (just arm64 for now, but
riscv in the future as well). And put your comment about why it's not
worth it for x86 there as well.

I don't have a strong preference, just an idea.

Any thoughts?

>                 if (addr < (unsigned long)kasan_mem_to_shadow((void *)(0U=
LL)) ||
>                     addr > (unsigned long)kasan_mem_to_shadow((void *)(~0=
ULL)))
>                         return;

There's also a comment lower in the function that needs to be updated
to mention Software Tag-Based mode on arm64 specifically.




> --
> 2.52.0
>
>

