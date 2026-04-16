Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81AE1F8A161
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 11:29:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3FD66B0005; Thu, 16 Apr 2026 07:29:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF11F6B0089; Thu, 16 Apr 2026 07:29:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B06666B008A; Thu, 16 Apr 2026 07:29:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A12A96B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 07:29:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 30950140823
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 11:29:55 +0000 (UTC)
X-FDA: 84664199550.06.21E6D8F
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf16.hostedemail.com (Postfix) with ESMTP id 309BD18000D
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 11:29:53 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776338993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0N28AiHhMQm9a3ncbvMl4jwXcNZbOrN6OiiJm2DjJOE=;
	b=lYuzM1beocIVdft1IvbhM/ObgfsHYSN6XL4QP4SpwU73iUPCeA47R+iF1aGd6HW9Tku0/B
	g+hzirRUenQcCAuv32FC/B6p7B1RpbSNnjG37jZsZw7o5lNr6bEO2cXX+JoV1jrYrC+gro
	dZP22ivqLEk4x8dhMCIWBIfOGIJV22I=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776338993; a=rsa-sha256;
	cv=none;
	b=pEiXKiRHzVirziT09oi1wKsgp5bCg+gSNqTxt6lzssefH6QFUmMnaz994smpVTEJ7J26Pz
	2cLNwfzmMMtdM2xobUSJAKRdDBAeohp8tIacLa9p7yuTZHHQK92J/EMP/I+VHHEL04pubr
	UreytKTNQuCGc6rSbsPCZzhcdA1AIE8=
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8cb40149037so729424985a.2
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 04:29:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776338992; x=1776943792;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0N28AiHhMQm9a3ncbvMl4jwXcNZbOrN6OiiJm2DjJOE=;
        b=HW9J2EUhRD1lwAST6puUBPKIgU0xke9ReRQKIChIoDP7NjT7RYCLeXKvCTJu7rLwy5
         alCeYGy7a4p8HrnYy1zwtjDfkLdSyhdH+ax1MPljSBvN2vKRYya/sFcBAuOzkfPt4oGT
         I3YFkEENfQFs0NAkO6alL2LWJC/UW/AIwT4X3u+iCvWeZZxfVcR5u2NWlXSWpBA6g6/4
         ORRtjxHuxjOwRx1kgJQTch2+8YAoW+XF1FF3QZmcMU8GwisRHLFCg7WwEYnE63UJimym
         Uebs/jBFjPtGCM8UaAfqwNZI4ba99ssTyaREkpbhUbldtuGGKLPKmuMTZiYg5ZN11G9R
         9RwQ==
X-Forwarded-Encrypted: i=1; AFNElJ8YGFmGWVBtoUQDAoNVLiZKCK7NIV9+X49Is3cgArHb937Uy1OlwU7DlVifP6sJMVOMg/IjiywMyQ==@kvack.org
X-Gm-Message-State: AOJu0Yx44/WCrQCSoqRahH4M029oW+bbw/sue18yKQsI4yrEhlRgMTvT
	CD1D0D5LFCOI9N5CkfUExvxaLABGw1FuLAW/AlEhWkaNzZy+bjeOktxyjELJ252M
X-Gm-Gg: AeBDiesedJCUCvMjIsada0LEnNatvWRio3c/gJQYg3m6hCj4mI3PpbHVJAZ8plWch7R
	0dfW0AupvtO8y0hUn87KKRD15iuvv7ZX2cHgH2lD4Qgqd93mDNWZLFT6Ci4oM7JE8EaKnjy/wRh
	YmcTRjgBAjm/vVXgBgpQ4m5ajZDOxdbGmIGyTpySpYfJ+nOVEvTW5UWaK+FcsxheBDIeZuIJJXr
	oRnMC/YNquXmiavDOG+aKre/TD7l4zB/SLcGtKVHAt5Eimubau0DBWoLh/Cb1JdPJUP1+/cIizp
	SvrYSDNPrfdDaApW1H5Oiydaw3UT/XNNZhjjmOVGfyEvVWgUjg2ibcSD7WpMJ/jfDQcbYfykPvR
	sbv5BcCERIzY5QJO1THVMfMUZ2E+2d7oqaicHsHjW56GVpw24Y/8YE2wfghuaj8XGPIt+5I2m8d
	o8ls956e3vyWoipTESHGj+uBeGEYisrSBAlGhSZimsiTWl7wcARrDua9wy36Zgk0c6rXmIV0/rk
	crYtz5U5/p1eg==
X-Received: by 2002:a05:620a:4451:b0:8c6:a034:9224 with SMTP id af79cd13be357-8ddcfbaf5cemr3683770985a.47.1776338992196;
        Thu, 16 Apr 2026 04:29:52 -0700 (PDT)
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com. [209.85.222.178])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8e4f2345c3bsm398922985a.24.2026.04.16.04.29.51
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2026 04:29:52 -0700 (PDT)
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8d560ede296so924642285a.0
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 04:29:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8i6TRwjMyATqMAwxepMDxl/qf4y4gxPbtLP24rl+p+CTa4QB8MqpK54RxWfOixt2hQc1NAW30uzw==@kvack.org
X-Received: by 2002:a05:6102:3fa2:b0:608:1b6e:f4dc with SMTP id
 ada2fe7eead31-609ff0c50e9mr11028119137.11.1776338540828; Thu, 16 Apr 2026
 04:22:20 -0700 (PDT)
MIME-Version: 1.0
References: <20260410120044.031381086@kernel.org> <20260410120318.045532623@kernel.org>
In-Reply-To: <20260410120318.045532623@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 16 Apr 2026 13:22:09 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXtR7T62Wf+yDM=J0+96C64qRws=ffX_xXbfzfbS0Xz8g@mail.gmail.com>
X-Gm-Features: AQROBzCyA8BqoTVnHFn7fWQMKVWyMF2wrQlYn44P8f0X0RsdCOwGnnxui8decDA
Message-ID: <CAMuHMdXtR7T62Wf+yDM=J0+96C64qRws=ffX_xXbfzfbS0Xz8g@mail.gmail.com>
Subject: Re: [patch 07/38] treewide: Consolidate cycles_t
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, x86@kernel.org, 
	Lu Baolu <baolu.lu@linux.intel.com>, iommu@lists.linux.dev, 
	Michael Grzeschik <m.grzeschik@pengutronix.de>, netdev@vger.kernel.org, 
	linux-wireless@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	linux-crypto@vger.kernel.org, Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org, 
	David Woodhouse <dwmw2@infradead.org>, Bernie Thompson <bernie@plugable.com>, linux-fbdev@vger.kernel.org, 
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Thomas Sailer <t.sailer@alumni.ethz.ch>, 
	linux-hams@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>, 
	Richard Henderson <richard.henderson@linaro.org>, linux-alpha@vger.kernel.org, 
	Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Huacai Chen <chenhuacai@kernel.org>, 
	loongarch@lists.linux.dev, Dinh Nguyen <dinguyen@kernel.org>, 
	Jonas Bonn <jonas@southpole.se>, linux-openrisc@vger.kernel.org, 
	Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org, 
	Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org, 
	Paul Walmsley <pjw@kernel.org>, linux-riscv@lists.infradead.org, 
	Heiko Carstens <hca@linux.ibm.com>, linux-s390@vger.kernel.org, 
	"David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 309BD18000D
X-Stat-Signature: ocsnfoyznpn46f8nzouteqw1g37r9rpb
X-Rspam-User: 
X-HE-Tag: 1776338993-169425
X-HE-Meta: U2FsdGVkX18NLVy4V7XzDLK2zgSeoUVOlADUQcH4mqdcurY8GF92IrveILe62p93d6cnnAkAw2AC+9P7i2xoD0iydVoO7QYqote1dB+LSyu+Y5lugdDkRdvQs3lWcflGkZA/TyFvNbHLTdEUwHqw7tifPZ6Kv9Q+K8INJnZ5rIXRV3/hGN+Pal1RiqkwfuPbIqaC2ZLIYPsZSpSsDyZuYVWpJ5XWVcvllEbrs719K5sVEHiYpTRKRUOuazNtsMP6U2yWxOrBnbIjQWLV1pJxKV7QMmtKnjCAU62I1gWXWnMyNoWm6924jHMsei+IX9MYFzP3kwzi7P7b/HUcnLeeGOq6l21ZnHhVg9fxzJ6JNHfT1l7yfZwp3vq9ASOKUTm6Ge4eqHBCky0hsJ1i9hY8rLumUIXUlhJ/RmMK08a1+01RooWo8YPf0wCn+El/T6tIoMNSvuxJDM4V8GQq7zA99UEPFG30DCMpnpZsvQiIHBgmYXUnX1wvZnwoc75AZ3Iz1rXLCwJHNYh6EDppN4TV9l8WDgM7ZANVxJyDxGX9ZXUlpkg5BuMlrBfdSJTwmfXl/JzVXMaqhY8NtKQBRxRrwH2ndvoUaSEIPUFcLq3Vca2TKldNO/YSryUjF7zBUB1FvIWWxoUh2YqOQAvkpoQcDZIS0Suho8wq0WWmHkU7bWRI7x1Ga3SRkbPHAUbF9Odyq9dgXe9HdI2xvHq4/Gz+QJAMXhdpVTXF/HA7ENFTn+hYfqZZDJj/6Ccy64cxXFCcOqbx/0y71WiXSZoCcPFXs0IsxAFVMC5BoegQlKp8SubCiJEQ1/9hjq3houkxynD6iDvSuSfF5f61ukL7BTHtFkKej+9zrcLFcN9m5uOqCKCJIBO/fmcKK5ZXcCyCAvwVOLAvpkddp7knLwgCpHoNYZv2CJSPGqxNwNlSXhMeoQCW6zrAieLWM8Xjp/przdNYuougHoRGLul9MlV+bmB
 VB4flcvx
 tOWPTUeE5cMj/hWFjspsxSUZzD/xHqd2s5eVNQvgXgyp/1xF7Uo8iCFO83qZ4762EUZYg/zhY9J/cxFCpj3DGnTv4ZL26tZoq4/UgB2E6XhkGkK8bbv8We2Xc304Gd/SX9GRLTSninbWhoAtldzqUda8ekOgCY7M2BRPJ2FiyYJKz9/HX0Tk5Dsy8jawLuLRevJBCDhf7+ReH38IDXBz7Rf9g8NmPDwSpNZcX+elTQBq8GlJT0AK4mi/c3yy8yVFUfcl5AhJ29qvRRWw7InJFtz3qbtQQcRsNZdYMo04xT2YNexjogRswwuHivhVUOppxlHfRHaP69WXfgnkguxJgxD516cP8FGFjd8p4AXzwF2Hv9ZnOjfWXARa4i8SGjPGFfm2JDb2kpnLfFTyJc+WE07G7HV6ENefPgAtKnYWnZYB8LYVt24fDpq38RAdkcrYek54TA1AYzJepYmOYQnNJkZiMeu+Kn0DGS0zZByPXFzwQZt+jYry+MqQdxqqftp4LhxDR4EUxrXcTZ6nqhY/ppWpEgNZ/VNH5MhzdB+WaoFddqyI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Apr 2026 at 14:19, Thomas Gleixner <tglx@kernel.org> wrote:
> Most architectures define cycles_t as unsigned long execpt:
>
>  - x86 requires it to be 64-bit independent of the 32-bit/64-bit build.
>
>  - parisc and mips define it as unsigned int
>
>    parisc has no real reason to do so as there are only a few usage sites
>    which either expand it to a 64-bit value or utilize only the lower
>    32bits.
>
>    mips has no real requirement either.
>
> Move the typedef to types.h and provide a config switch to enforce the
> 64-bit type for x86.
>
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>

>  arch/m68k/include/asm/timex.h      |    2 --

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org> # m68k

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

