Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 413CEC87FCF
	for <linux-mm@archiver.kernel.org>; Sun, 10 Aug 2025 07:32:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A29A96B009F; Sun, 10 Aug 2025 03:32:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DA956B00A0; Sun, 10 Aug 2025 03:32:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C9256B00A1; Sun, 10 Aug 2025 03:32:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 76FBD6B009F
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 03:32:31 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C415211676C
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 07:32:30 +0000 (UTC)
X-FDA: 83760030060.19.16F4981
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	by imf16.hostedemail.com (Postfix) with ESMTP id BEE9C180005
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 07:32:28 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IpnRZEt1;
	spf=pass (imf16.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=snovitoll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754811148; a=rsa-sha256;
	cv=none;
	b=R1x1K+/I7zWZch5IMI2KTTGtq1uYWeDfMGiUhm4hT3Azs8gaThp3AwzAG+peu1Cq4JwC6f
	emrBWxk7UjkGAuwBApWBPtahuzHX6ayFbPhv26PESX+MjiPioBETb94hhy2UQn/GzrY+T2
	4w8fLGQiaqRObysfFy+DyJUO7qMOHRs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IpnRZEt1;
	spf=pass (imf16.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=snovitoll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754811148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=to3a2j5jgrrDRsoCDy9JGxvNqhRLdP/C+mURmWO4ysI=;
	b=n1uZObJ5UadsRlNeR/h83Mo0RS75fQmrTsTrcPsYlQVjzI7p4cWzX2S7L9yIovw3Fu8B18
	urvZBDTIZVh75WEvc/hsyDLH0UeKxfZh9/9BUmpBp/6DjwZEPawyifteASZUSWjRfNjfQg
	qqr4a8gIkLSngyrD2XbybAidPJ3kc9Q=
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-33253a73769so27897871fa.3
        for <linux-mm@kvack.org>; Sun, 10 Aug 2025 00:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754811147; x=1755415947; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=to3a2j5jgrrDRsoCDy9JGxvNqhRLdP/C+mURmWO4ysI=;
        b=IpnRZEt127MnjSyuZ8psgyz25Kq0TCvVwOh73L759vrVwYxHvqatyBmKF8meHA0XuX
         09jDVEJmLdjGsyDROYpDW7vtEmyJ8Yy35iu/qJ8US2G3rutmyeYqHK3q58AYbi2bQHa2
         oQojksqzIpomqxsrAgwwabTiOZY9egQ88CdjW/PapQtPasghIfpuzF1QKinOYQjYa27q
         pQhu6uI8joB0AkiWnyt29Vb04sw1w3R1BAXPpNaCDz5sygisKn4Q6JmRW+UJKAdDnrbq
         MA/htlrQkbS1RHAUENSF4LX5iuZVe7HM9A6gZzh4LD04bXp4QSuVbnrTBmTxWTKIsfkQ
         V6Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754811147; x=1755415947;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=to3a2j5jgrrDRsoCDy9JGxvNqhRLdP/C+mURmWO4ysI=;
        b=fEv9GrKnPfP/UOs9ooV2+hL/OWa94ae55A3wEZ/Nl1DpjgAahFIlspYm+yPRPXZ2va
         083m3MM1LtP9kwAFHUVZrg05XYRVLIq0ZVMr3PCf6AARPIq1SdmY5d6KGBUFWU+evw1c
         z0+Gcd51jjxeSGqJU0afoKqXwdGjLCtmip9qSIci8iGavMivP9vKfORyD0MFQOKZN277
         EF6QM9ugBVeK/Ol6JsJBV+uznSO80zKKsL8N7C66nlokq1jil4FisBFbUOmDGwMMBZU+
         zQLzj2bWirz+IrHCTOpQ2nKLNEvfQg3NPxCjOoOWj8euypn8I2YMK4jZnlTaWlvyC10r
         CZfg==
X-Forwarded-Encrypted: i=1; AJvYcCXWStg1rgIjK35xoUfHqjwSMUTJ8/CQZH+BYc7gvkcpjDsHp9BV/HAGUuHhRbwtpipnArF654R4LA==@kvack.org
X-Gm-Message-State: AOJu0YzgfvQGxiNVZIZXyYtZB2wbkvW6SRHMm3GvRL9kiGZzxK/Lj/87
	6ckvioTvcFtbJUJ7PAI1oqoFgQUi1wLoaytm9sU1nKOQkOC/Ks2cBwugIg56sUnS/mn8nYzuACH
	uLydGocpaHcpF6Qoozv8Eygo+6F79XLA=
X-Gm-Gg: ASbGnct7erxmyuDqU08dS9jFuT+voOLZAb9b0MG2KnoPIkT8ZmS7YxdEzlezboX0yX/
	EF23f6G6ZRSOX+p2PzbOhENnOUbGcxHkMSmqIJ/+j/Jcg70z6Q8RTZm4e6dMXu9dMvYFlZrDZ5B
	/DT1Izz+leoXRnl0ZEJSv1iau5YaLX6wpH15bQ8tUxpSHnhfbhpHHJu9CQfczJivPwb1A5axInF
	Pqb08bc0zGD6LKznXhppm/UZD2LgQsfuWsW2M7qzXD8u4HwuQ==
X-Google-Smtp-Source: AGHT+IHSiW6flEmK0NWVDywJ0JDvDzDflYl3FPZq6Arom7yJiee4WZtdkHowtUkS6j3k/g3AhngqPPQBa36CQfXo8jE=
X-Received: by 2002:a05:6512:1052:b0:553:2480:2308 with SMTP id
 2adb3069b0e04-55cc00eb7eemr2065404e87.21.1754811146600; Sun, 10 Aug 2025
 00:32:26 -0700 (PDT)
MIME-Version: 1.0
References: <20250807194012.631367-1-snovitoll@gmail.com> <20250807194012.631367-2-snovitoll@gmail.com>
 <22872a3f-85dc-4740-b605-ba80b5a3b1bc@csgroup.eu> <CACzwLxjnofD0EsxrtgbG3svXHL+TpYcio4B67SCY9Mi3C-jdsQ@mail.gmail.com>
 <af677847-e625-43d7-8750-b2ce4ba9626c@csgroup.eu> <CACzwLxjr+Z+xUj-936rcWDSqEwfUP7bRB1xcqZQKGE7ux-gEXQ@mail.gmail.com>
In-Reply-To: <CACzwLxjr+Z+xUj-936rcWDSqEwfUP7bRB1xcqZQKGE7ux-gEXQ@mail.gmail.com>
From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Date: Sun, 10 Aug 2025 12:32:08 +0500
X-Gm-Features: Ac12FXzPCnTCatZw8a7ccc080L84VXsdNPtKeE-8RXfhfS3owZfq0geCNjkMt-Q
Message-ID: <CACzwLxi5AKT_81ej4AZ1ztsncBDY4jDJCyWboF0X9-kiH_=NMA@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] kasan: introduce ARCH_DEFER_KASAN and unify static
 key across modes
To: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: ryabinin.a.a@gmail.com, bhe@redhat.com, hca@linux.ibm.com, 
	andreyknvl@gmail.com, akpm@linux-foundation.org, zhangqing@loongson.cn, 
	chenhuacai@loongson.cn, glider@google.com, dvyukov@google.com, alex@ghiti.fr, 
	agordeev@linux.ibm.com, vincenzo.frascino@arm.com, elver@google.com, 
	kasan-dev@googlegroups.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, linux-um@lists.infradead.org, linux-mm@kvack.org, 
	davidgow@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BEE9C180005
X-Stat-Signature: udbgsedybz6zk5csjfobber3rk73s8fi
X-HE-Tag: 1754811148-922853
X-HE-Meta: U2FsdGVkX1+XRFm44jCfivCFbSuBymotPgijvvAr7BThXwIVmnBySm+bx1XnKhyZq1DIAwHXj/nQtQtjg0IDQjYn6js1qiSPkIRJ/TOPMZVvtW8+260T7UZwPkXU3LZnNxYipwT+oYeAhW8+xS870WuSC0WrAoWre+Rkw5QUH8IswzqlfDDDDR3sSJfU2csZIxNxGucJqoKRa6Z7ujaf0OjnhykIu6hbnAuUo1IhUr8R6OtAmZis/LgPjK+kDNJp5m5B7nxrrjAYsoU65RKxeKfsBzxPdSYVpuOQJG+iCBFR/9uxigk/AvUJ2KYouUJpAQnhJVuo/rYsP69X9B3rQdMmle0p0nMQ4KOltQrh572v814aVREtMqjXxw5pyE2CTP9krP6PyC3haTxkwHQ3ZJlajCQzrTBZ2kSbMe/oHwhRp0f8S6cGjDFqzeICw90wcjDA4kj9HtztVANoNQGZtqjyFt6fDztTBa38G8tvjgSYawH1A1VTokJX5f/LpGIPmxVolG0T9zTbihPeT2Ya8/ECV5lbhz4Kr9YN8UN5mZDsCvRSuY1Lrf3Nk3QhSByJulffZqJq1rT/3aLs4jIBRVvlizK/IeGvrCsveluVjuhfogIMDDZkmsRQCtxo0re+8L5u91zEgZglSgA1Z1nXjdqASqCfqPZnYiJQjOxK8klgU424lbYm24oopxMlmh9iTi1zCh9kk29OMhDQC54Trp17u4/ffWKtZEEXRh2D/h5746ftoxAJKRi1wx42oqpXvvRGzmjrJ7+ZsRTC+p3fRWuO7q7OVeC3fb9kNUXbe1iBXKHXOSiCY5Aw3hv7LYpzPXS7uvU7wQxRSfLVuNhD5PVz8L8qwRDdXe7SdCzsoVDE2zeh7gvrhWctSWxtP8LlQa5MUnzqrhEBPDygSJg74IZn/ttCwuolbnZmVHnxrHXCRztO/neVoCq0dS0hWd7isKX81ZpfZUn8QQp+2BV
 eOdOylvB
 Gkz7krTZF2JTNSdFTcNUvqJ5vkFH6nNgZwWtoV2AuJd8ZiF2z3lkWhtrcIs2daExUd/HLZuWXdWCKFerOwfdeDKwk6nl5fkfsIwHWR39z6vxAUSDfbSVWbFY7REtPGCReq5CSgcUYsWstfAFcx8rrFlPU9TUCpwvXVdwl3rkuc2uL0ghrlkOikcIt+2DfqPcXDvaJXAPKtnZcndh9NLDCucPcvXcdFGh8pl2PIfJW2eiGQIvOH7ud3mZVPouEDgO0ljXyVZmjciHfAUwHJ1tmf/adleKw5GsVkpkL90ZQoBkx6NSYpkSg0e6P0ojKh+VSxkobhythgUNgIuP3LInmlIPrDLNIgMlxnBv4YNvSM3pTlCS+4hr7pziajR+PVq/mgYNpaR+B5baB8J7Ww5mtdwMddVrRVkAvPhn0MI0j+w136RCrM19W1rolWX2Svv9bycdQmRy3jHDbxwROaT3h4nWntukEM+W8sGNL1PSDhvvMkKmnm2ZRspso9sI0zp9dJ9Cd9ZhUvSNboPrs/tLIjyxxZnwlaDYKz04GSr7x21V+F0knRwPMpzsQjve6ZewhdwT7BiGMIJlKZR8N6raURMp52e6MLW0Cm0XU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 10, 2025 at 12:20=E2=80=AFPM Sabyrzhan Tasbolatov
<snovitoll@gmail.com> wrote:
>
> On Fri, Aug 8, 2025 at 10:03=E2=80=AFPM Christophe Leroy
> <christophe.leroy@csgroup.eu> wrote:
> >
> >
> >
> > Le 08/08/2025 =C3=A0 17:33, Sabyrzhan Tasbolatov a =C3=A9crit :
> > > On Fri, Aug 8, 2025 at 10:03=E2=80=AFAM Christophe Leroy
> > > <christophe.leroy@csgroup.eu> wrote:
> > >>
> > >>
> > >>
> > >> Le 07/08/2025 =C3=A0 21:40, Sabyrzhan Tasbolatov a =C3=A9crit :
> > >>> Introduce CONFIG_ARCH_DEFER_KASAN to identify architectures [1] tha=
t need
> > >>> to defer KASAN initialization until shadow memory is properly set u=
p,
> > >>> and unify the static key infrastructure across all KASAN modes.
> > >>
> > >> That probably desserves more details, maybe copy in informations fro=
m
> > >> the top of cover letter.
> > >>
> > >> I think there should also be some exeplanations about
> > >> kasan_arch_is_ready() becoming kasan_enabled(), and also why
> > >> kasan_arch_is_ready() completely disappear from mm/kasan/common.c
> > >> without being replaced by kasan_enabled().
> > >>
> > >>>
> > >>> [1] PowerPC, UML, LoongArch selects ARCH_DEFER_KASAN.
> > >>>
> > >>> Closes: https://eur01.safelinks.protection.outlook.com/?url=3Dhttps=
%3A%2F%2Fbugzilla.kernel.org%2Fshow_bug.cgi%3Fid%3D217049&data=3D05%7C02%7C=
christophe.leroy%40csgroup.eu%7Cfe4f5a759ad6452b047408ddd691024a%7C8b87af7d=
86474dc78df45f69a2011bb5%7C0%7C0%7C638902640503259176%7CUnknown%7CTWFpbGZsb=
3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFp=
bCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=3DUM4uvQihJdeWwcC6DIiJXbn4wGsrijjRc=
Hc55uCMErI%3D&reserved=3D0
> > >>> Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
> > >>> ---
> > >>> Changes in v5:
> > >>> - Unified patches where arch (powerpc, UML, loongarch) selects
> > >>>     ARCH_DEFER_KASAN in the first patch not to break
> > >>>     bisectability
> > >>> - Removed kasan_arch_is_ready completely as there is no user
> > >>> - Removed __wrappers in v4, left only those where it's necessary
> > >>>     due to different implementations
> > >>>
> > >>> Changes in v4:
> > >>> - Fixed HW_TAGS static key functionality (was broken in v3)
> > >>> - Merged configuration and implementation for atomicity
> > >>> ---
> > >>>    arch/loongarch/Kconfig                 |  1 +
> > >>>    arch/loongarch/include/asm/kasan.h     |  7 ------
> > >>>    arch/loongarch/mm/kasan_init.c         |  8 +++----
> > >>>    arch/powerpc/Kconfig                   |  1 +
> > >>>    arch/powerpc/include/asm/kasan.h       | 12 ----------
> > >>>    arch/powerpc/mm/kasan/init_32.c        |  2 +-
> > >>>    arch/powerpc/mm/kasan/init_book3e_64.c |  2 +-
> > >>>    arch/powerpc/mm/kasan/init_book3s_64.c |  6 +----
> > >>>    arch/um/Kconfig                        |  1 +
> > >>>    arch/um/include/asm/kasan.h            |  5 ++--
> > >>>    arch/um/kernel/mem.c                   | 10 ++++++--
> > >>>    include/linux/kasan-enabled.h          | 32 ++++++++++++++++++--=
------
> > >>>    include/linux/kasan.h                  |  6 +++++
> > >>>    lib/Kconfig.kasan                      |  8 +++++++
> > >>>    mm/kasan/common.c                      | 17 ++++++++++----
> > >>>    mm/kasan/generic.c                     | 19 +++++++++++----
> > >>>    mm/kasan/hw_tags.c                     |  9 +-------
> > >>>    mm/kasan/kasan.h                       |  8 ++++++-
> > >>>    mm/kasan/shadow.c                      | 12 +++++-----
> > >>>    mm/kasan/sw_tags.c                     |  1 +
> > >>>    mm/kasan/tags.c                        |  2 +-
> > >>>    21 files changed, 100 insertions(+), 69 deletions(-)
> > >>>
> > >>> diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
> > >>> index f0abc38c40a..cd64b2bc12d 100644
> > >>> --- a/arch/loongarch/Kconfig
> > >>> +++ b/arch/loongarch/Kconfig
> > >>> @@ -9,6 +9,7 @@ config LOONGARCH
> > >>>        select ACPI_PPTT if ACPI
> > >>>        select ACPI_SYSTEM_POWER_STATES_SUPPORT if ACPI
> > >>>        select ARCH_BINFMT_ELF_STATE
> > >>> +     select ARCH_DEFER_KASAN if KASAN
> > >>
> > >> Instead of adding 'if KASAN' in all users, you could do in two steps=
:
> > >>
> > >> Add a symbol ARCH_NEEDS_DEFER_KASAN.
> > >>
> > >> +config ARCH_NEEDS_DEFER_KASAN
> > >> +       bool
> > >>
> > >> And then:
> > >>
> > >> +config ARCH_DEFER_KASAN
> > >> +       def_bool
> > >> +       depends on KASAN
> > >> +       depends on ARCH_DEFER_KASAN
> > >> +       help
> > >> +         Architectures should select this if they need to defer KAS=
AN
> > >> +         initialization until shadow memory is properly set up. Thi=
s
> > >> +         enables runtime control via static keys. Otherwise, KASAN =
uses
> > >> +         compile-time constants for better performance.
> > >>
> > >
> > > Actually, I don't see the benefits from this option. Sorry, have just
> > > revisited this again.
> > > With the new symbol, arch (PowerPC, UML, LoongArch) still needs selec=
t
> > > 2 options:
> > >
> > > select ARCH_NEEDS_DEFER_KASAN
> > > select ARCH_DEFER_KASAN
> >
> > Sorry, my mistake, ARCH_DEFER_KASAN has to be 'def_bool y'. Missing the
> > 'y'. That way it is automatically set to 'y' as long as KASAN and
> > ARCH_NEEDS_DEFER_KASAN are selected. Should be:
> >
> > config ARCH_DEFER_KASAN
> >         def_bool y
> >         depends on KASAN
> >         depends on ARCH_NEEDS_DEFER_KASAN
> >
> >
> > >
> > > and the oneline with `if` condition is cleaner.
> > > select ARCH_DEFER_KASAN if KASAN
>
> Hello,
>
> Have just had a chance to test this.
>
> lib/Kconfig.kasan:
>         config ARCH_NEEDS_DEFER_KASAN
>                 bool
>
>         config ARCH_DEFER_KASAN
>                 def_bool y
>                 depends on KASAN
>                 depends on ARCH_NEEDS_DEFER_KASAN

Setting Kconfig.kasan without KASAN works fine for 3 arch that selects
ARCH_DEFER_KASAN:

config ARCH_DEFER_KASAN
       def_bool y
       depends on ARCH_NEEDS_DEFER_KASAN

Going to send v6 soon.

P.S.: Fixed email of David Gow.

>
> It works for UML defconfig where arch/um/Kconfig is:
>
> config UML
>         bool
>         default y
>         select ARCH_NEEDS_DEFER_KASAN
>         select ARCH_DEFER_KASAN if STATIC_LINK
>
> But it prints warnings for PowerPC, LoongArch:
>
> config LOONGARCH
>         bool
>         ...
>         select ARCH_NEEDS_DEFER_KASAN
>         select ARCH_DEFER_KASAN
>
> $ make defconfig ARCH=3Dloongarch
> *** Default configuration is based on 'loongson3_defconfig'
>
> WARNING: unmet direct dependencies detected for ARCH_DEFER_KASAN
>   Depends on [n]: KASAN [=3Dn] && ARCH_NEEDS_DEFER_KASAN [=3Dy]
>   Selected by [y]:
>   - LOONGARCH [=3Dy]
>
>
> config PPC
>         bool
>         default y
>         select ARCH_DEFER_KASAN if PPC_RADIX_MMU
>         select ARCH_NEEDS_DEFER_KASAN
>
> $ make ppc64_defconfig
>
> WARNING: unmet direct dependencies detected for ARCH_DEFER_KASAN
>   Depends on [n]: KASAN [=3Dn] && ARCH_NEEDS_DEFER_KASAN [=3Dy]
>   Selected by [y]:
>   - PPC [=3Dy] && PPC_RADIX_MMU [=3Dy]
>
>
> > >
> >
> > I don't think so because it requires all architectures to add 'if KASAN=
'
> > which is not convenient.
> >
> > Christophe

