Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0040AC87FCF
	for <linux-mm@archiver.kernel.org>; Sun, 10 Aug 2025 07:20:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 618E66B009D; Sun, 10 Aug 2025 03:20:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C9B16B009E; Sun, 10 Aug 2025 03:20:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DF616B009F; Sun, 10 Aug 2025 03:20:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3C7176B009D
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 03:20:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BD8D114039D
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 07:20:52 +0000 (UTC)
X-FDA: 83760000744.13.35CD942
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	by imf06.hostedemail.com (Postfix) with ESMTP id C2F4A180006
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 07:20:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UbEEDbP9;
	spf=pass (imf06.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.208.181 as permitted sender) smtp.mailfrom=snovitoll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754810450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EpwULXc7N4PVrAxnhzJUCLFsDhMEPa8K20pRMtf9QU4=;
	b=a+MOPVG0/XbXbb9VHVq06LdaTtvtiH+aGGsRKfZiCtIgKwiqcqSuYQhuFESPWdAg/WXGlZ
	7z9KZUdQu0hMH1XFjIzDukAwHej9wGCmUHl/hw+aMJY+KEZ9Xi5QpQC+Z1+OeBdYHtTKhN
	tq0c1+dBNL7P1/8GlTOSS4Gjjtzty4Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754810450; a=rsa-sha256;
	cv=none;
	b=FIUSas8zyrR6L+AJTL5LFAm+N4y2nDSCQeK+trsNZuicRoB+La7Kqq9x/iOPA1IgyLaRq5
	Oxx/1Uct6feaHUDDoAmiU1U1ARBlq77C1WcMYlcd+Ni2PCbL+DI6xX7PUD57bdTh1ftTyY
	4xNG2P+1RPQfmOFqzJNktTqnWy7VUzY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UbEEDbP9;
	spf=pass (imf06.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.208.181 as permitted sender) smtp.mailfrom=snovitoll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-33230f1347fso28144911fa.3
        for <linux-mm@kvack.org>; Sun, 10 Aug 2025 00:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754810449; x=1755415249; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EpwULXc7N4PVrAxnhzJUCLFsDhMEPa8K20pRMtf9QU4=;
        b=UbEEDbP9o8JAxW/RxEasIg9PrPgrRzeuowNFQd+HNiQlsKiAVwqL3O45fCtxrZqIH4
         DHixv75y/jLJbMi44AHgoDKDIvqTPCJbOle5xaOnHfoY/vakoFKsrFHgqHtxMe7ONtXq
         +pqtfA+jyWmZHXr7kL6Bq4QhcM08JSv/ooPKQ1HqM5q0J2cof3w6u357LO7REx73oG6J
         wVEdcIJmJmQiXzF3kO6tJI4DHJnKeUZaAwZXsmlHsCcSSUWc6+yePTU+PpMGI9sHqlGh
         FJZfDeCYipVZmC4zyNrmgWiICvBrwSMPh7SW1OZkocIp93pHS/xR9ss51id944XzxeIz
         8vNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754810449; x=1755415249;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EpwULXc7N4PVrAxnhzJUCLFsDhMEPa8K20pRMtf9QU4=;
        b=q/da8etT93+Aivi0XnQEMa+5gzzJcN8MnfnK+C1DoK2zeMgXnuTNuHD1BNcLt4OVaW
         wvA7Z/eoqPuYgG4eXiEM7PAJz97cI2Iq6UXxGe3oLDfDa64V+YoRjxNCrETFA2qwUF4M
         HbRS7cJqMEMPo/6NXlSacpIn2odBD2/s45S5nT20TgCTKYVppv5kVICJi25vhrInotIG
         af1TR60WLMsRsS78tB3PjqspnqVc5ospRUs/AXpOmTvJTt12zGppZ2XciKCJ67jZs00u
         9x0IWdLMrPkaVcjtZA496EqdhMPJYJ91TLUL3aG1uuua7pLGAUEKJ0H1/R8TaNURh+45
         JkXA==
X-Forwarded-Encrypted: i=1; AJvYcCXPJYFpT9xQyyvzKea64s1Sp0oexwSyL+wp891coNDJ0+mHAlIz7nYZTc/dki2yWEYYzs2BqMO9Ow==@kvack.org
X-Gm-Message-State: AOJu0YyASkU/BRb+gsPhaQ3XKrmAfkplLfj+SUKhDPj6oKzNhPQIpngo
	zC27MCVj8DF9XkilImiPP9mzb7ayLPTw0lj9azKIYZRDHeED7uIZ9JoqJV3DEKc+I9uNxAcYZgo
	rz+IQza9c2+ckhVG0A7jT9IomzmKh5dc=
X-Gm-Gg: ASbGnctawoF+oBpYU47K1+q/bLRvFtrPvnLSYEqLqzWHVjPJxAwmWeNedrhjZjdTPc+
	TNZpXzOf19X/oYrqJbCwVvCk2KIVpysBoxZiarM15P0KKQh9GpFjBQQyydBYwa9WcCHqsf7Yc88
	i4LYkhWLugwfreIKhnAhh/NEqQrYdXOAAUrtobnVe/6r6VO6RpF62DYhOa7MxR9zEdcAHySXA4O
	vGi0eBpq9CrRHU85RGhyzbTD+ipkrJSA0SVkuk=
X-Google-Smtp-Source: AGHT+IEATVB+zShs5UtXixRak2GiQ/zc6xtl1NlPiWHkLLcdmonSWNJDigg98acT6MlYwLuyv4giEoaQ9ZJ5gULbnFg=
X-Received: by 2002:a2e:96cc:0:b0:32f:425b:3278 with SMTP id
 38308e7fff4ca-333a22ede04mr18232851fa.25.1754810448509; Sun, 10 Aug 2025
 00:20:48 -0700 (PDT)
MIME-Version: 1.0
References: <20250807194012.631367-1-snovitoll@gmail.com> <20250807194012.631367-2-snovitoll@gmail.com>
 <22872a3f-85dc-4740-b605-ba80b5a3b1bc@csgroup.eu> <CACzwLxjnofD0EsxrtgbG3svXHL+TpYcio4B67SCY9Mi3C-jdsQ@mail.gmail.com>
 <af677847-e625-43d7-8750-b2ce4ba9626c@csgroup.eu>
In-Reply-To: <af677847-e625-43d7-8750-b2ce4ba9626c@csgroup.eu>
From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Date: Sun, 10 Aug 2025 12:20:31 +0500
X-Gm-Features: Ac12FXxZS7GKPiKLVRILyIcM2smc0R0yETsf0Ytt07yeIUtr59o1Bn8VVZobpbU
Message-ID: <CACzwLxjr+Z+xUj-936rcWDSqEwfUP7bRB1xcqZQKGE7ux-gEXQ@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] kasan: introduce ARCH_DEFER_KASAN and unify static
 key across modes
To: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: ryabinin.a.a@gmail.com, bhe@redhat.com, hca@linux.ibm.com, 
	andreyknvl@gmail.com, akpm@linux-foundation.org, zhangqing@loongson.cn, 
	chenhuacai@loongson.cn, davidgow@google.co, glider@google.com, 
	dvyukov@google.com, alex@ghiti.fr, agordeev@linux.ibm.com, 
	vincenzo.frascino@arm.com, elver@google.com, kasan-dev@googlegroups.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C2F4A180006
X-Stat-Signature: tmzxdgjs8hey86j13s53inz3x6tb6n8g
X-Rspam-User: 
X-HE-Tag: 1754810450-835140
X-HE-Meta: U2FsdGVkX1/SXQq0tE7X/BJ7qthc5KSCnoklMGoUA//SKEs/KMtW3Rtm3cwqC97cgUd0EgpHAP7ENDcAEzPOGoZfPamolSUC/nm0PdmEBNd4X3OK+U4KjUMivO9omfVD51C9HgkEvb3w+Qyc9iaXxa4CnEb1n4XkdKVc1MB0LQbPoVMkhImdeU68loMoUtE23EwLQVXX2HOPf1QDCNWNWzVnLIoDfRmkTheSh71TY4vDwiS9kTb86LbHepDvWSsY1m1+OLer1Xa+LkILZj0g/2zB2BZAMyQiJ4CMIrx1681P5L/vUGsM1WwBMfpf8Fm0tOFPjroWi1w7H68BdaN06XyE2QAJt+KgYTO+we8m6SjY9np8tlzzV/zK8RuUEpIA6vDDLrEl53TuYtKR+Qj81axw4RvBw84keFSOxf2bFrOLMSzJIwiMUiytPQxVISFI8CAnxxSwrZzOz7Q1WbXJX9JD0F4/9kpky9liMe6sU46w8MZWGq7j4ynVVGyJXp5sa2kL+JY09mUKrrF07FlHOtnplG0pkPdWdWvPKpFt3CW2YQR2MvqaboR0gg44q0E8TKt85uXv18PUf4gbcrblJN2oIfRgnxifkmdYUOwTDep3ds9/JI6Cuug5TrybFp5WNldQIBgzYSp8Kodto0BcQk/pyroF1KFg8K9OZUWjFDP7MTD3ME2qf84RPlmkyDuSr7HyNli+DlQkbP+1soNkCESpQmK97dcEqaE+Re/vYWjf55axyCOfhdocuhOBZVrT92DMitUb8UsV+eO+gya/ZuJgqCK3A3WS5iHxMZ+9QKIre3pGR1R5ybzv+CMsjhwt23BHy22KBXrpFlkKJuxw7+1p/VdPqHMxzPEGmee5BKVuWDv0vUAE9czZXtfbSj+89eT01rlP5yEGKQVqSw/QjY5AqBRo9pEIrkEfhweU1h6lFrmDdW/o+BvlttO2QQ1G27nq042fKYjRKJzI5uh
 uzXS3i0G
 lPTnOF7PGByqpTYbCRtgSnpIUQ7vei1bkphD1TC8MW6kjJnTbDBWsKV3zAB2hAG9lveN4lqTMRtQpktJd7ZTAa/7NUn55O+QWj+/Zw8pPILer4K8/RCqboFB7R0vrclMT2/ol+IEPC2ZQa9R+qPBKcoEPhjYFFU2Pf7jstocENDTNEWwTWbRtNxRy0zFMqBNdPz6P11ROy1S1ik9JRFG53A7vzu4I0/GRszB0IX6UYSayJ5dN2peSpo/Mib2wQO37ivh2ye7iQAaXRwoUoLN90uKrdDj1FnPD6iiEB+et6QWq9AfD8wyuBxqMqOxPwuz805Gvc6pHOLG+F06o1CrZRamY6bDDYPgEEqREX7MrAxpeTwf4HpL8YsmdFlFwCtNKuPor4rsNZ4eHUB5TjtqHKmBVFHvrtc7OB/tiDwmm03i2Bq51CjceexrFQo8fIv672uBoNN6B8l9MXczI14nXzS7xa9vsMlwC51wlLuE3FxPsZZGvHFawWUXeJFL4DMosYJgXuQxsbdpMKGk3UpuslkI8Ar/s4TF3N7XNIoDuKljPVcFp4EPSZgEWrv7sK9dKd9nfMOl7+QAnZdWaqPRbGVHG83yVzlV8BXSG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 8, 2025 at 10:03=E2=80=AFPM Christophe Leroy
<christophe.leroy@csgroup.eu> wrote:
>
>
>
> Le 08/08/2025 =C3=A0 17:33, Sabyrzhan Tasbolatov a =C3=A9crit :
> > On Fri, Aug 8, 2025 at 10:03=E2=80=AFAM Christophe Leroy
> > <christophe.leroy@csgroup.eu> wrote:
> >>
> >>
> >>
> >> Le 07/08/2025 =C3=A0 21:40, Sabyrzhan Tasbolatov a =C3=A9crit :
> >>> Introduce CONFIG_ARCH_DEFER_KASAN to identify architectures [1] that =
need
> >>> to defer KASAN initialization until shadow memory is properly set up,
> >>> and unify the static key infrastructure across all KASAN modes.
> >>
> >> That probably desserves more details, maybe copy in informations from
> >> the top of cover letter.
> >>
> >> I think there should also be some exeplanations about
> >> kasan_arch_is_ready() becoming kasan_enabled(), and also why
> >> kasan_arch_is_ready() completely disappear from mm/kasan/common.c
> >> without being replaced by kasan_enabled().
> >>
> >>>
> >>> [1] PowerPC, UML, LoongArch selects ARCH_DEFER_KASAN.
> >>>
> >>> Closes: https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3=
A%2F%2Fbugzilla.kernel.org%2Fshow_bug.cgi%3Fid%3D217049&data=3D05%7C02%7Cch=
ristophe.leroy%40csgroup.eu%7Cfe4f5a759ad6452b047408ddd691024a%7C8b87af7d86=
474dc78df45f69a2011bb5%7C0%7C0%7C638902640503259176%7CUnknown%7CTWFpbGZsb3d=
8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbC=
IsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=3DUM4uvQihJdeWwcC6DIiJXbn4wGsrijjRcHc=
55uCMErI%3D&reserved=3D0
> >>> Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
> >>> ---
> >>> Changes in v5:
> >>> - Unified patches where arch (powerpc, UML, loongarch) selects
> >>>     ARCH_DEFER_KASAN in the first patch not to break
> >>>     bisectability
> >>> - Removed kasan_arch_is_ready completely as there is no user
> >>> - Removed __wrappers in v4, left only those where it's necessary
> >>>     due to different implementations
> >>>
> >>> Changes in v4:
> >>> - Fixed HW_TAGS static key functionality (was broken in v3)
> >>> - Merged configuration and implementation for atomicity
> >>> ---
> >>>    arch/loongarch/Kconfig                 |  1 +
> >>>    arch/loongarch/include/asm/kasan.h     |  7 ------
> >>>    arch/loongarch/mm/kasan_init.c         |  8 +++----
> >>>    arch/powerpc/Kconfig                   |  1 +
> >>>    arch/powerpc/include/asm/kasan.h       | 12 ----------
> >>>    arch/powerpc/mm/kasan/init_32.c        |  2 +-
> >>>    arch/powerpc/mm/kasan/init_book3e_64.c |  2 +-
> >>>    arch/powerpc/mm/kasan/init_book3s_64.c |  6 +----
> >>>    arch/um/Kconfig                        |  1 +
> >>>    arch/um/include/asm/kasan.h            |  5 ++--
> >>>    arch/um/kernel/mem.c                   | 10 ++++++--
> >>>    include/linux/kasan-enabled.h          | 32 ++++++++++++++++++----=
----
> >>>    include/linux/kasan.h                  |  6 +++++
> >>>    lib/Kconfig.kasan                      |  8 +++++++
> >>>    mm/kasan/common.c                      | 17 ++++++++++----
> >>>    mm/kasan/generic.c                     | 19 +++++++++++----
> >>>    mm/kasan/hw_tags.c                     |  9 +-------
> >>>    mm/kasan/kasan.h                       |  8 ++++++-
> >>>    mm/kasan/shadow.c                      | 12 +++++-----
> >>>    mm/kasan/sw_tags.c                     |  1 +
> >>>    mm/kasan/tags.c                        |  2 +-
> >>>    21 files changed, 100 insertions(+), 69 deletions(-)
> >>>
> >>> diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
> >>> index f0abc38c40a..cd64b2bc12d 100644
> >>> --- a/arch/loongarch/Kconfig
> >>> +++ b/arch/loongarch/Kconfig
> >>> @@ -9,6 +9,7 @@ config LOONGARCH
> >>>        select ACPI_PPTT if ACPI
> >>>        select ACPI_SYSTEM_POWER_STATES_SUPPORT if ACPI
> >>>        select ARCH_BINFMT_ELF_STATE
> >>> +     select ARCH_DEFER_KASAN if KASAN
> >>
> >> Instead of adding 'if KASAN' in all users, you could do in two steps:
> >>
> >> Add a symbol ARCH_NEEDS_DEFER_KASAN.
> >>
> >> +config ARCH_NEEDS_DEFER_KASAN
> >> +       bool
> >>
> >> And then:
> >>
> >> +config ARCH_DEFER_KASAN
> >> +       def_bool
> >> +       depends on KASAN
> >> +       depends on ARCH_DEFER_KASAN
> >> +       help
> >> +         Architectures should select this if they need to defer KASAN
> >> +         initialization until shadow memory is properly set up. This
> >> +         enables runtime control via static keys. Otherwise, KASAN us=
es
> >> +         compile-time constants for better performance.
> >>
> >
> > Actually, I don't see the benefits from this option. Sorry, have just
> > revisited this again.
> > With the new symbol, arch (PowerPC, UML, LoongArch) still needs select
> > 2 options:
> >
> > select ARCH_NEEDS_DEFER_KASAN
> > select ARCH_DEFER_KASAN
>
> Sorry, my mistake, ARCH_DEFER_KASAN has to be 'def_bool y'. Missing the
> 'y'. That way it is automatically set to 'y' as long as KASAN and
> ARCH_NEEDS_DEFER_KASAN are selected. Should be:
>
> config ARCH_DEFER_KASAN
>         def_bool y
>         depends on KASAN
>         depends on ARCH_NEEDS_DEFER_KASAN
>
>
> >
> > and the oneline with `if` condition is cleaner.
> > select ARCH_DEFER_KASAN if KASAN

Hello,

Have just had a chance to test this.

lib/Kconfig.kasan:
        config ARCH_NEEDS_DEFER_KASAN
                bool

        config ARCH_DEFER_KASAN
                def_bool y
                depends on KASAN
                depends on ARCH_NEEDS_DEFER_KASAN

It works for UML defconfig where arch/um/Kconfig is:

config UML
        bool
        default y
        select ARCH_NEEDS_DEFER_KASAN
        select ARCH_DEFER_KASAN if STATIC_LINK

But it prints warnings for PowerPC, LoongArch:

config LOONGARCH
        bool
        ...
        select ARCH_NEEDS_DEFER_KASAN
        select ARCH_DEFER_KASAN

$ make defconfig ARCH=3Dloongarch
*** Default configuration is based on 'loongson3_defconfig'

WARNING: unmet direct dependencies detected for ARCH_DEFER_KASAN
  Depends on [n]: KASAN [=3Dn] && ARCH_NEEDS_DEFER_KASAN [=3Dy]
  Selected by [y]:
  - LOONGARCH [=3Dy]


config PPC
        bool
        default y
        select ARCH_DEFER_KASAN if PPC_RADIX_MMU
        select ARCH_NEEDS_DEFER_KASAN

$ make ppc64_defconfig

WARNING: unmet direct dependencies detected for ARCH_DEFER_KASAN
  Depends on [n]: KASAN [=3Dn] && ARCH_NEEDS_DEFER_KASAN [=3Dy]
  Selected by [y]:
  - PPC [=3Dy] && PPC_RADIX_MMU [=3Dy]


> >
>
> I don't think so because it requires all architectures to add 'if KASAN'
> which is not convenient.
>
> Christophe

