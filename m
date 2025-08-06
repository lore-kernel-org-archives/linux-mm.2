Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5547DC87FCA
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 04:36:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C070A6B0093; Wed,  6 Aug 2025 00:35:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDF226B0096; Wed,  6 Aug 2025 00:35:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1BEC6B0098; Wed,  6 Aug 2025 00:35:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A250C6B0093
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 00:35:59 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4DAD71DB78A
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 04:35:59 +0000 (UTC)
X-FDA: 83745070038.05.D2E3187
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5CE77140002
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 04:35:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OYUjOOwa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=snovitoll@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754454957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dyl+4iOlTi/aeKebUp39F24cwHyqM1kxjjt1F2AMIE8=;
	b=7rXRi7IC7o0UJ544lR9o9xOMwd/ajoFBlldtrNb+M0yonBhdCcRqLZFlZcKvQLyowWShrt
	0Mwm4ci+85jgeqGEjF+2gQnevM1Mb6FucxxJRLJiMZSY2AFZSBZu5nBJ8RIkExhWADpK1a
	pVKnrO2eh4lVOgaCMuzsOMkIPkq3aN0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754454957; a=rsa-sha256;
	cv=none;
	b=kxlkQuP6ljSX0prkBkGPR0NEeUMSDiKS374EaCoTNbAQ6HHXptz+NqSvvt1BN6wf4fFHVX
	0nokNfuYjg8ONupwuNBNna58HEK4m/MzomWOBghVsJ9/gBekKiGonqx3eRp1f6UHDY7/V4
	pLmKtO77ed2iY5DV+wWmGCdJF1A+NlA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OYUjOOwa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=snovitoll@gmail.com
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-3322e4ac12cso43156381fa.2
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 21:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754454955; x=1755059755; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dyl+4iOlTi/aeKebUp39F24cwHyqM1kxjjt1F2AMIE8=;
        b=OYUjOOwaM6VsUput4wRA+ytGdkXG52XssJ3mO0iZEdZ1EQ6B7tTjIHCBm8uOQGhlZf
         M9op6rxl91sHbCTm4IBoRSQlbizLUM9OvBA5yiyRz+OqJwNw4bWEHrFnLTF3yZD0Dr10
         D6149Rf20jymlN/jzOhGo8guIuy0uSPlDi6VRMivrx6Wr8TVny1IrmsaD3cFZksuQzvK
         w1PJah976a8a4XpBetkeKALN5rPKkSJvYrRtM8088KAukVy8JZvX3dzl/ekg0Y5tlsDr
         MZKnhCoWM5zMZy8KS5KN8+Fn7bln8zxzJfLmotFxFoPtnIlixGefHrttJxqOkOv05j0Q
         E/Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754454955; x=1755059755;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dyl+4iOlTi/aeKebUp39F24cwHyqM1kxjjt1F2AMIE8=;
        b=FwTKxUi1PRwtuGUx4ZoSCvpp0lsfeP8x0f9WkFhiDXYSaGkmouCE1tk2Z1Km4w8jHC
         7sevGSiDsQnndgcX4MYggYeIggEjWmN+X3yoUL3S+Jwo8mYa2BId/ZzfcdkWJqMSB3P9
         AnfRPzZelw4tbXqJO7DC7ca6bMisI5voPIt5/gXx3V5/SlyAcKFMhWbK6P/Es/FREOoK
         ULw40TACaXLpuZjr+y4T+j9+tzwRINJsUvh+Mx7c3N8YPGiO/HlntHLEOg+o5ETPERGy
         GscEpoPJxJp1iUOrk7fqYTlIx5V1gxFt7FOZFO410HKi9QM9dZ48KcMrGL194JmCA8OP
         9lyw==
X-Forwarded-Encrypted: i=1; AJvYcCWFBs/w3OzaIa3mwSUoiZnSy+2iQleIPUBpTlGO3Wq/50jnNdWijCDjpOqaa8molbHO7GJZL9FqHw==@kvack.org
X-Gm-Message-State: AOJu0YyBIC+kqulThxMUpKVSbeqZYRpQZiJboe1+S0KCRDDZBxDbGDDy
	z25FUqYrLGBg5W6wo8xApghKfechj4YLa6+MLUwfotM06idZoY8aby+3IjnBp9UojMwxWEtVqJy
	xZkHrRJCFnWF2vXJ/lnegAPxyWElyoJc=
X-Gm-Gg: ASbGncvRapRG8k/+3LzcWl6qP+XmaoGgUsbdLb361Px9c1ubEt6asyt1r1m0Wx2ExAp
	Just4eCE36XgqdZ4fAdvql8k0CbbMc/AujqRXO7Pc+wfTF0ZxuVvoyHU8LedXcECPJDM31UA8Gr
	81U0376wgXtpYXHX1xU69qERKHRNQsDgURJ4m9XMylI+rHdTiuauQKbGpo+6uW2NU9d7H0sUcpo
	1kWUOQ=
X-Google-Smtp-Source: AGHT+IELREFbM69cWDMgkv0oAyeZWfUsogtR626ngafWyGyn4A7prZJUgwVT4kX8m1x5U9hUnIU0ztH0bEfAmGCquxc=
X-Received: by 2002:a05:651c:f0e:b0:32c:e253:20cc with SMTP id
 38308e7fff4ca-3338128c651mr2551171fa.11.1754454955157; Tue, 05 Aug 2025
 21:35:55 -0700 (PDT)
MIME-Version: 1.0
References: <20250805142622.560992-1-snovitoll@gmail.com> <20250805142622.560992-7-snovitoll@gmail.com>
 <60895f3d-abe2-4fc3-afc3-176a188f06d4@gmail.com>
In-Reply-To: <60895f3d-abe2-4fc3-afc3-176a188f06d4@gmail.com>
From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Date: Wed, 6 Aug 2025 09:35:38 +0500
X-Gm-Features: Ac12FXwBfBQD8yoFidSr60fw7LigvE8ZBweRU29uoAzLmmdybvheO1FdbNA_5DM
Message-ID: <CACzwLxhs+Rt9-q6tKi3Kvu7HpZ2VgZAc4XEXZ4MEB60UbFjDKg@mail.gmail.com>
Subject: Re: [PATCH v4 6/9] kasan/um: select ARCH_DEFER_KASAN and call kasan_init_generic
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: hca@linux.ibm.com, christophe.leroy@csgroup.eu, andreyknvl@gmail.com, 
	agordeev@linux.ibm.com, akpm@linux-foundation.org, zhangqing@loongson.cn, 
	chenhuacai@loongson.cn, trishalfonso@google.com, davidgow@google.com, 
	glider@google.com, dvyukov@google.com, kasan-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, linux-um@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5CE77140002
X-Stat-Signature: mw3pxrzphhhg8j78w6y7uz8w5semm65h
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754454957-852057
X-HE-Meta: U2FsdGVkX19G+Ch/z3qB6uXviJXzX1RWRnSCePbD/tT6g3j2PQtmU8HgxPop7Ge7/6RaQ3ZVBdkmGB+C8OnY4a1Eaq9Kb41W6EfjQIUiHhdEIQ5FTZhUQKFi0ENoB925CoYiKzwQy4kXRESvGtXn/dsqqeKeY95CSza2RT8DuQFTdxJGuOh8/Gbtkr81ap19B15rgEPpbbxtwQTvHbjPNlik1+cUUaSHz/G8LAyQJOYxjeq7DU7rA6k5HV0F9h1yaJ9uqN3dG+AlZMi3DZGsqSut3mmgFdCpvPSvKIn3hjtIEs4Yt1aQZlXf16PS2Mxssj0HvZrYrODPO73JYw3HOkRRjs33uC9+nr7sMqRFdQvv7LmcslYQvxsIzIZjwGxTy4Tg7jdNGRSxre6d9eciA2GVhQA5itKR1x0FVpyRZPY51DLgg5Ejr2eJeOitfVOGmbujdUhIVakKbiqbkTTSseQtH5UeCqh3S9JcyyVukudNeQjeRplUSYOZsW6v+9+tA8vFtVyaEINd7AyRcpPylCKkCWtoxBJDTU9S93+8ky5fHWGKpHtPwpFtWb8UJ2Znce2bQ8atNj/zX6sO+zOJ1nmtyOi0Na2EWYWSx8hjJrR0fc2hPUyAhMMyneDO6cGLv0mfFuw1zGH/IAcNVpHZB/UhFEy6Kaj3JwRUPee0kWSQoFrBfZ7VLOoSIf23Z80DWlynqmyce2vczPFtOPBeaUAnnqwwoocjpGnAqV6URKJQYwIeEI+soid+ufw4BbGcQ+UnN8LVLl5HPT0U4+tScwEhZRYXqxVxU40CUq1+o4uFEP6sc3IoyMlTrLLKt1wWR1IWKpsapEcXPnB7M+UvESLburpci9zv0Z/BuRfaC5nwPhGhjeYhtWoyFQYfYIqrh8Ihw8CxKbyM7MdAj/JDA/RbpnrwOPTe6yn+ShU5G6VqpNUawnhxEENB5wgbIQTLtAwUni5d656ePlrtqOq
 v2DHPqg9
 bgE47RL6ZMhOVqCBsoR9ZWMMfIhlN/pxEotQS+3qQ0YRtMhRADLvDhx46KOHnQvs3UFAFG4dgVFXHOfnO2f/dIRK7p9FnUp531OSMaIOo+lr4RsJ8RTCgMK+nzM/QWgxVu5JVUhk+bLuSWPsUpccNi4XgAdPbyPRwnQ/4Ua+A0MXZOJ+BOJNXnS7u16spFYFniYOug+4GYhQgvI2DCemEVMbby7yglgqpNImTrhsy7vt7OFpO0mx8t/srgWwn03thgK2cxtgvSyJ1qbV447yaTbEtIB9Bt8Ee3+chiqRqInSs3OjjmqrdmjaFo3fcPR0ttjErcxcJeZ5PCGmYRrtQf/GtOOnEbXQgQ/jGtvWjOazcaokHEtPr+gBD/SnRsNLLZToeLEJBpdviDyohHyEy0iOJrtWCOjRZXek/9qdASZ5xlV3rGDfVqUc2DrY5YtSVN2I1vaw6EY+fqVxZKIZ3AnjwHiSKMURtsNhAowo84QhCaGY0T7nj0UVuWw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 5, 2025 at 10:19=E2=80=AFPM Andrey Ryabinin <ryabinin.a.a@gmail=
.com> wrote:
>
>
>
> On 8/5/25 4:26 PM, Sabyrzhan Tasbolatov wrote:
> >
> > diff --git a/arch/um/Kconfig b/arch/um/Kconfig
> > index 9083bfdb773..8d14c8fc2cd 100644
> > --- a/arch/um/Kconfig
> > +++ b/arch/um/Kconfig
> > @@ -5,6 +5,7 @@ menu "UML-specific options"
> >  config UML
> >       bool
> >       default y
> > +     select ARCH_DEFER_KASAN
>
> select ARCH_DEFER_KASAN if STATIC_LINK

As pointed out in commit 5b301409e8bc("UML: add support for KASAN
under x86_64"),

: Also note that, while UML supports both KASAN in inline mode
(CONFIG_KASAN_INLINE)
: and static linking (CONFIG_STATIC_LINK), it does not support both at
the same time.

I've tested that for UML,
ARCH_DEFER_KASAN works if STATIC_LINK && KASAN_OUTLINE
ARCH_DEFER_KASAN works if KASAN_INLINE && !STATIC_LINK

ARCH_DEFER_KASAN if STATIC_LINK, and KASAN_INLINE=3Dy by default from defco=
nfig
crashes with SEGFAULT here (I didn't understand what it is, I think
the main() constructors
is not prepared in UML):

 =E2=96=BA 0       0x609d6f87 strlen+43
   1       0x60a20db0 _dl_new_object+48
   2       0x60a24627 _dl_non_dynamic_init+103
   3       0x60a25f9a __libc_init_first+42
   4       0x609eb6b2 __libc_start_main_impl+2434
   5       0x6004a025 _start+37

Since this is the case only for UML, AFAIU, I don't think we want to change
conditions in lib/Kconfig.kasan. Shall I leave UML Kconfig as it is? e.g.

select ARCH_DEFER_KASAN

>
> >       select ARCH_WANTS_DYNAMIC_TASK_STRUCT
> >       select ARCH_HAS_CACHE_LINE_SIZE
> >       select ARCH_HAS_CPU_FINALIZE_INIT
> > diff --git a/arch/um/include/asm/kasan.h b/arch/um/include/asm/kasan.h
> > index f97bb1f7b85..81bcdc0f962 100644
> > --- a/arch/um/include/asm/kasan.h
> > +++ b/arch/um/include/asm/kasan.h
> > @@ -24,11 +24,6 @@
> >
> >  #ifdef CONFIG_KASAN
> >  void kasan_init(void);
> > -extern int kasan_um_is_ready;
> > -
> > -#ifdef CONFIG_STATIC_LINK
> > -#define kasan_arch_is_ready() (kasan_um_is_ready)
> > -#endif
> >  #else
> >  static inline void kasan_init(void) { }
> >  #endif /* CONFIG_KASAN */

