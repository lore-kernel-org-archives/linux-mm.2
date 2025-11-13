Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24993CD8CBE
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 18:23:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6601E8E0007; Thu, 13 Nov 2025 13:23:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 611138E0002; Thu, 13 Nov 2025 13:23:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54E1E8E0007; Thu, 13 Nov 2025 13:23:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 43F798E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 13:23:46 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D7CA389ED5
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 18:23:45 +0000 (UTC)
X-FDA: 84106407210.29.2C2AA32
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	by imf13.hostedemail.com (Postfix) with ESMTP id CE88C20005
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 18:23:43 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	spf=pass (imf13.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.222.46 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763058223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pbr6KNR1bUXZYViotVbUoRUsmFwFNCwuoCWcfoEfOT8=;
	b=x9OjibpYBn82DhOqXNSyouTYgHxjS92N+jbgpjQhgXu90as6Wig9t7eL96YFJ6ZplP/3KE
	826qWlPDRVuzR/uv5buwLrvgsitxU7eeWOy32nQPnLPWIjPlCoLRDQrclbG0u9wtAI1UBk
	yL/Nlo8At7VoiD051O/W0AnY/MDoBCw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.222.46 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763058223; a=rsa-sha256;
	cv=none;
	b=GcxvuPo4x3+AgwTmKSecVgp1tkfHiYPuv1Aa00V0IosMo1ldE9JvcZrwiA+D50djhrty+c
	Q2S/vcNXoIiZIKYdGiJuOs+xXGE3hZIHBqrtggIKANZSo8sDZyWWmcIZMX7YRrjBxgxhib
	LD+sag8c0UWhg99uWhO2beVhDgnLr+8=
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-93721d29eb8so1288474241.1
        for <linux-mm@kvack.org>; Thu, 13 Nov 2025 10:23:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763058223; x=1763663023;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pbr6KNR1bUXZYViotVbUoRUsmFwFNCwuoCWcfoEfOT8=;
        b=dFeUnwAy21yGqDU8PPq1g9jh9OzLDFmbVqYFJwW5NIen5h3hFjAv1kHtRK+j1QoIk8
         BrrzUm1uB+VpP7gPyZnPbg5Lq2o5k9FNxDo0dr0pLdmjoWjIx2cgSM7FauLqstNg6/BM
         e8zk+J6T0hdIfrFJwGk93md/CNN4ItcbgVFwewO1fTMdI57umXGqS/0J3ZyWCixgaU5g
         6IYE6LB/SPHcTrlUB1HJRiZKp7uIc1QSN6ByLbmsnB63Vp0jLiiRQhr+xbseA2iGXVF+
         fL2DS+r5uHRpuolkB+JY+aECQ318kRJeyPyzs1/Nvbty401GNepngjsvgJA7UKR+fgsF
         hOnQ==
X-Forwarded-Encrypted: i=1; AJvYcCVivVZKZdjOgtiXi5sSDR4exw47UUkTzhpFcWs1VOON6ZGidgNQKrgeCeyC/DkBkPoiL9In3iGQEg==@kvack.org
X-Gm-Message-State: AOJu0Yxm7JLIjzeJKdUjlcnpwSUJC1C7KIojRnp9FGM7gwNxDbago6mO
	yRp7O0kkblUIkyY985Qk5Cam2ZSBVzZAqLfzUiXl6wWlpePI48z5bPIYXURhYUXNCJc=
X-Gm-Gg: ASbGncvdf9apDxu/d8P45gmR7U/qZbrvCnvar+abr/nmmt40ZlXxMJBZkWy7RYauT8F
	0HuEeYsxOyooqslLyqcte82BEFEOzFP7t85AYIGbj3IeR00+/Jn3+TAlt6Q7lVliMYICi6jH2m+
	pzYEHtjlHEXJm+UvtQh8VudFjOSzm+UPwK5sxyEb4+A/fqPeLquFmLCB3jvgQw7szGHvXCIc+KZ
	PL+wxt5MPxXq1Qoil9kb8Q24qfQKK9LSUFYJipzVzikn9OwiUwom+vIm6liEbpyaGUlW6LNPjR5
	ohzXOQjl9zo+P8a3xDdljVSOZeuDQH6jqNpPHBS/yiiZdVxNJPe87OSkPI5mB5gv8ZZqEw9HY+6
	wBC1wYJvhRd0jMoxdBCfxcIA3pIMpUCzGYlJ87tONOVydknHMVi0xFjsEEZZm4zKr1MwYJwlDcP
	s6yHcco3Duj2voCPl2xpY3t2+dD+i9tBk3G4hB7g==
X-Google-Smtp-Source: AGHT+IGKYvNnIj8fee8gzZ1hHwBYx2TXoHXDNkjC8jJbyhpebn00Mj4CYbDWFVi60hKa2J+ab7Uv5Q==
X-Received: by 2002:a05:6102:cd1:b0:5d7:dddd:5709 with SMTP id ada2fe7eead31-5dfc5365800mr415918137.0.1763058222578;
        Thu, 13 Nov 2025 10:23:42 -0800 (PST)
Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com. [209.85.217.44])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-5dfb7232b16sm904461137.10.2025.11.13.10.23.42
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Nov 2025 10:23:42 -0800 (PST)
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-5dfaceec8deso726785137.0
        for <linux-mm@kvack.org>; Thu, 13 Nov 2025 10:23:42 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWo/feJ/xR/LHUtTjbWQKgdDPRfnaihDmYmXLNsn0rJjf7pvs1l8+ThIVNW8AQaagmF/B2VEnKjKw==@kvack.org
X-Received: by 2002:a05:6102:3051:b0:5d4:1499:99a4 with SMTP id
 ada2fe7eead31-5dfb41e267fmr1793358137.13.1763058221928; Thu, 13 Nov 2025
 10:23:41 -0800 (PST)
MIME-Version: 1.0
References: <202511132024.tfRZgB5P-lkp@intel.com> <20251113100036.70130321f6629ce9cc8956cf@linux-foundation.org>
In-Reply-To: <20251113100036.70130321f6629ce9cc8956cf@linux-foundation.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 13 Nov 2025 19:23:30 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXpUat2cTH_YBqQNUQY4=Y3em38GDY5vr+HYhd_qk3qcA@mail.gmail.com>
X-Gm-Features: AWmQ_bnmukM8VT5G1Q69IqWca-tF6jQbLcv0pbKs9CiZ8jCmLwhTSfU1v9SpYUk
Message-ID: <CAMuHMdXpUat2cTH_YBqQNUQY4=Y3em38GDY5vr+HYhd_qk3qcA@mail.gmail.com>
Subject: Re: [akpm-mm:mm-unstable 36/283] include/uapi/linux/const.h:20:25:
 warning: conversion from 'long long unsigned int' to 'long unsigned int'
 changes value from '17179869184' to '0'
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, "David Hildenbrand (Red Hat)" <david@kernel.org>, oe-kbuild-all@lists.linux.dev, 
	Linux Memory Management List <linux-mm@kvack.org>, linux-sh@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CE88C20005
X-Stat-Signature: edf8o9qep5mx7uqaraz99eswa3ppxr5t
X-Rspam-User: 
X-HE-Tag: 1763058223-592325
X-HE-Meta: U2FsdGVkX191epeF/Yx5GTTie1ZazN2dz9w6qCjBzD1y7HS0nmBKzM6++FioAhMbSR8rlSIMQGE5RSU4VguM1V+gd0tlKN78oKyojgXLyjxFH+WeWOYy/sGeK9rPiDgNfBiFrpfdk/8GxWcuLjcHHUZG0uz30X+sKZi+4iRupuKOZplspXBqnVqgACekT9Su4sNnadfUZ7qoce0LumLVdzzJu5GjfRxMxTlCbnEJwxyCUcNb8IoQWlMk4wZzZ6QhsZmuw0rR7XWyV7Ox2WPn0eWAD5ar7hDk8yFPcx2JE/xPc9/5o316vwjX3AC1WN7SPulXS3DjV2PgM7C1F21tMTWkN9hnbeuyDskKy+gtAR7B6IJSeoeV/yOHsH9c8giR8NL1dRGk3t8zfUrMsiL8spUk2PszLK9OHCpiE8Z6WJFC2Z5msDltPMBuMwBphkF1YMRlILnFLcuIPvJJ9l6uKIDrjC+7zifIICbfMHnpthRk1s6rzEwSiRFJVn2EElKCLQXkj7YM/leKBV9T59Y+aEDCq9SOHhAzEaQq5JW+T43b2m6sKEtJcJm5rKh2U/bTGgvJuRs/i721GiEyBirX1x0MinylMYPwEXq57mZOe0Ssb2ehrTwVZ+1D2uF5AozQZVhbjdD2R7cOBMCM8F3/qpt7kyRJq5sHXVjhaFk/AhwbSDNm56751r+Qb0VgZkrhAXknvTxwG/FTm3XffosSoQZv1HjVyBEjqF7kfHX84EeGt/y3euJ0GPQJwdR6OpMvxCSJzzB2uwv8klSxN8APJEZYSAXiYNPpqzLo/wZdRmS4P88M00v5zLAaYHrdLZfYPJElf0ebXN7ho4JQJHhHeHf8W7yUUqecspj3zxAr3Atv8o/9SVmDrCnl9th6IA1kJVjSc9vBR6wHghI+Gk5teIzVyqNmnhRClTEKjFpHjCE2zjFKbRyAm2kRzfmEXWoBWt91rABg7q7wPvsRCBJ
 8Nn8O1We
 HhNyk8MKOtXKjZafSloClzjfxQXktDIuEuBjVSYvsGi+8ANhB+J64Cp9Hrzfl9UM2+XBe9B66kxLVVQmCaRFrQeG0xeA8VtdyTnVMsMMyWOr8FxQEu3iHq/qmze4t2pRa0fFM6xfszGyUW/YDY/vjXy54ZKmmbj8Si63PiYCGKBzFSHlR8lWzq2j1RawQ3+YmO0LMEJA0wQHiFyFeBBQwU8zqy8I/oo1qRuD/De6axovgQERtthG1wYGLks3Zgz09rcfA2U87m/Myp9/JXAEbWNC/p7wmjTe7/5/uiTGi/T927c50YmymrfHp2MZjS/nB1efJENVEbQGt7/FckpuGjTd0hkHp76zaCr2AQVp2A3lBwWxduYG7drAeM1LN2JU4OZXrDU0RiytjE31eonqbgGiDfj/7GPF9hPe2m+bPvMaDM0JRK4u1zHfq6VYOyznjdb+9J55/BHTlD6ibkDucq5nnncLy8xE42qZ9FqnqQje28HmTsxcoUXMpyd/3AlhZ1SxzF6XdMjBU81AtkvPzM3jfKdG9wjrSJySLKuBXf4+bOhdlQaI1CgQCdqzdIuD3ylpd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

On Thu, 13 Nov 2025 at 19:08, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 13 Nov 2025 20:26:42 +0800 kernel test robot <lkp@intel.com> wrote:
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
> > head:   f58b4cb6b0c11172a25c2ade23477f55596d7138
> > commit: 2f6ff71280ffddb27ad7174d24f573e2683870cd [36/283] mm: fix MAX_FOLIO_ORDER on powerpc configs with hugetlb
> > config: sh-randconfig-002-20251113 (https://download.01.org/0day-ci/archive/20251113/202511132024.tfRZgB5P-lkp@intel.com/config)
> > compiler: sh4-linux-gcc (GCC) 11.5.0
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251113/202511132024.tfRZgB5P-lkp@intel.com/reproduce)
> >
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202511132024.tfRZgB5P-lkp@intel.com/
> >
> > All warnings (new ones prefixed by >>):
> >
> >    In file included from arch/sh/include/asm/bug.h:112,
> >                     from include/linux/bug.h:5,
> >                     from include/linux/mmdebug.h:5,
> >                     from include/linux/mm.h:6,
> >                     from include/linux/migrate.h:5,
> >                     from mm/migrate.c:16:
> >    mm/internal.h: In function 'folio_set_order':
> > >> include/uapi/linux/const.h:20:25: warning: conversion from 'long long unsigned int' to 'long unsigned int' changes value from '17179869184' to '0' [-Woverflow]
> >       20 | #define __AC(X,Y)       (X##Y)
> >          |                         ^~~~~~
> >    include/asm-generic/bug.h:111:32: note: in definition of macro 'WARN_ON_ONCE'
> >      111 |         int __ret_warn_on = !!(condition);                      \
> >          |                                ^~~~~~~~~
> >    mm/internal.h:758:9: note: in expansion of macro 'VM_WARN_ON_ONCE'
> >      758 |         VM_WARN_ON_ONCE(order > MAX_FOLIO_ORDER);
> >          |         ^~~~~~~~~~~~~~~
> >    include/uapi/linux/const.h:21:25: note: in expansion of macro '__AC'
> >       21 | #define _AC(X,Y)        __AC(X,Y)
> >          |                         ^~~~
> >    include/linux/sizes.h:56:41: note: in expansion of macro '_AC'
> >       56 | #define SZ_16G                          _AC(0x400000000, ULL)
> >          |                                         ^~~
> >    include/linux/mm.h:2095:43: note: in expansion of macro 'SZ_16G'
> >     2095 | #define MAX_FOLIO_ORDER         get_order(SZ_16G)
> >          |                                           ^~~~~~
> >    mm/internal.h:758:33: note: in expansion of macro 'MAX_FOLIO_ORDER'
> >      758 |         VM_WARN_ON_ONCE(order > MAX_FOLIO_ORDER);
> >          |                                 ^~~~~~~~~~~~~~~
>
> Oh gee.
>
> Here's the patch: https://lkml.kernel.org/r/20251112145632.508687-1-david@kernel.org
>
> I'll append a copy below.
>
> For a start, you have found an sh config which sets neither
> CONFIG_32BIT not CONFIG_64BIT.  Should that even be possible?

Apparently yes...

arch/sh/mm/Kconfig:

    config 29BIT
            def_bool !32BIT
            select UNCACHED_MAPPING

    config 32BIT
            bool
            default !MMU

    config PMB
            bool "Support 32-bit physical addressing through PMB"
            depends on MMU && CPU_SH4A && !CPU_SH4AL_DSP
            select 32BIT
            select UNCACHED_MAPPING
            help
              If you say Y here, physical addressing will be extended to
              32-bits through the SH-4A PMB. If this is not set, legacy
              29-bit physical addressing will be used.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

