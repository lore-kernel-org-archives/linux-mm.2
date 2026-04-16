Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A330AF8A160
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 11:22:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAA2D6B008A; Thu, 16 Apr 2026 07:22:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C826D6B008C; Thu, 16 Apr 2026 07:22:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B98106B0092; Thu, 16 Apr 2026 07:22:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A88416B008A
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 07:22:32 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4E801C27C5
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 11:22:32 +0000 (UTC)
X-FDA: 84664180944.06.827EF8C
Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4575012000F
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 11:22:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	spf=pass (imf29.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.221.170 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776338550; a=rsa-sha256;
	cv=none;
	b=gD8JHCrBAieeCrrSeDH8m6/8EsMQJECcTPnILfjQKjP4vkgJlS+qHe5JNcQf2spcuMGrkE
	UEX3IKZdJ2/koAMkyh7c1ZRDeS1/kXLV11bE6FYNzSh8keGmdI0RHJkbQUxe4glLHfyJnE
	ZJl8OaYKKWmTHrz6QYbz3wBZan2fDL8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.221.170 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776338550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I6jqlHRyBmHp78NPQbVn/INUSPCxYZ/sUXVIyq1nXfE=;
	b=tzFkX1ZiOLzUIxRGr0z4gQfD7AVumQ8+YavcNxXi2KRrQr4uwXgNe6XFYlu/tFJ47uPo50
	AlaYEx7JjZmiHBBPqDw11b7TjfFgb4BWLldq/PszMVRi6ppbe3W/dsY/UL1hkdJ7+fkoEw
	o1H9CnxQrXVGTnqeUDLYl0JGTtjiDeU=
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-56d95bc93e3so4675507e0c.1
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 04:22:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776338549; x=1776943349;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I6jqlHRyBmHp78NPQbVn/INUSPCxYZ/sUXVIyq1nXfE=;
        b=Kbf/lN5VewPDnTwh60TpG28/DjrCBELUntglxJG8irhHPkriqthmE3pNcSipxHhxfe
         vaMYiqbe9QbCXZV/3JruWPta63LDKq/MrOtJHrjH/YvK6GlrX8Smd3/Kl4tTNXJwRt9w
         xRpNGvX0adVT7sh6exf70Jf+HEhDr8zWvpzL1EgOEKhJAFN2E3WM/2uDeyVWcvPFhuvY
         FmtJamLbJzVxuV+nv8gpNZH/cELdQiR2Jlflcs97ibBx+0d37sHV4MHHJ0Y+BdFzf3+F
         f0MESrGB98ksytIdAWfulqrWAPe1gh6NU5APNq0qRKV+SAvauRGK1ghlzjjaGR4t89/R
         pDyw==
X-Forwarded-Encrypted: i=1; AFNElJ9yymSbZh3Ho/ovrnFkWBUx0yGpPCGvMEO3IJ5J/HzrnyX2MY/MdJPbmf9OdP69zO2StZhBnxlkUw==@kvack.org
X-Gm-Message-State: AOJu0YwISHarYEcv5vktLRfpNGJxCg9J5MaSeWz30313WDx+p4WLJXql
	PbkwOLJWmz3gjwBc2EwJlo5RIYzk3WNoIGut2KKNfoPKtWDBsZchnqmvJ2FV1ebD
X-Gm-Gg: AeBDietMhF3sdhN/CWsuPVhvRTTc2imnaaxwxMwANh/MWkpgcks97LNcxI7ZO3kgY2F
	SqKeisIRlnzb2WTKQmMpM7/q6gfjspoa+k1Na0/Cf973sXgecqcmiWg4PsaQcr3lcaSR9e/pkH6
	7uS4dBe/7xxPikHxvxdxCfSCA6G9VJuq8LNmXaR4e4DJi5tOhTpIqzjz5T4146KTxWntqog85QF
	fsWi3yFGeKy5ThLNVnu+2XVWih7+kWkvz/SFKkckvjlTtzTse+vQg58ha+hv8D5FguM2G9vFIXv
	KqUIgzr/qeCea1fw49/umDBzNQG1Fwpx9WtwQGRzAQue1YNwmc+OeflVFm55qX4qjaUk/fvdWyT
	8rcowpqv/JnfhLZzbvnecakVmUNwRku8UNQLhS62sh1jHj24XCfRqS68z2XYkobRG8mlAME+5O2
	LTX3j3sbol0bKe0UzT1eLFmfnnxUw8ojmQiWSidwarKd5KVSpXzpIO/aJc1GpC83irAe9ueTI=
X-Received: by 2002:a05:6122:8b82:b0:56d:2ca7:fbc3 with SMTP id 71dfb90a1353d-56f3bba6252mr14119769e0c.5.1776338549310;
        Thu, 16 Apr 2026 04:22:29 -0700 (PDT)
Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com. [209.85.222.50])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-56f89dfee48sm2780370e0c.5.2026.04.16.04.22.27
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2026 04:22:27 -0700 (PDT)
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-9540bb77b1aso4158628241.1
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 04:22:27 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+/y3jCTxutcKWcfJ9SICZXmrNT5HUSP7DxEJpEkUYh8c8artA91CuDoRuQMqM9LirqI5HcRmor9w==@kvack.org
X-Received: by 2002:a05:6102:6044:b0:5ff:c64d:2283 with SMTP id
 ada2fe7eead31-60a0157295cmr11348128137.30.1776338547396; Thu, 16 Apr 2026
 04:22:27 -0700 (PDT)
MIME-Version: 1.0
References: <20260410120044.031381086@kernel.org> <20260410120319.397219631@kernel.org>
In-Reply-To: <20260410120319.397219631@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 16 Apr 2026 13:22:16 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVoo_6i9=2oQj-=yjW7nK8eL4og08bdYvk_EGj=_cQvQA@mail.gmail.com>
X-Gm-Features: AQROBzCJ6rVnwwfhi99PI36wWXAFQ5DEgo1zw3RhVwYNSXoxkTYAcgIxt5Z0K1g
Message-ID: <CAMuHMdVoo_6i9=2oQj-=yjW7nK8eL4og08bdYvk_EGj=_cQvQA@mail.gmail.com>
Subject: Re: [patch 27/38] m68k: Select ARCH_HAS_RANDOM_ENTROPY
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-m68k@lists.linux-m68k.org, 
	Arnd Bergmann <arnd@arndb.de>, x86@kernel.org, Lu Baolu <baolu.lu@linux.intel.com>, 
	iommu@lists.linux.dev, Michael Grzeschik <m.grzeschik@pengutronix.de>, netdev@vger.kernel.org, 
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
X-Rspamd-Server: rspam10
X-Stat-Signature: 4zryphwmm9ak3ydhus61ezsdjfwa6uja
X-Rspam-User: 
X-Rspamd-Queue-Id: 4575012000F
X-HE-Tag: 1776338550-968779
X-HE-Meta: U2FsdGVkX1/vHR3+gVLoi0bUHGYT6d2kLJRiH4m3SWGNHGWBV1kPGxedJFbYSGRRiU07Y72sEG9Mbhhi/7PYcCujxeh4D8jyGGWLTa3/WbaN2iRkfR1PrpezUsL00XkicdkOLnqU5Qnk2sGC9Ub0vQdLSNcOMD6WlyQDaCPjsqFxxIYs/LOKH1GyYhqx9BV0CKPu4cYoRiSwPpGI9aA1jNlnsdl8R+IL+324i9d29E6l0rlnV2p8x4EJQHfOoJ5OmTSAvG3wB4MqdCy4j6V1ZJiPan17K0leZfl2HEan0euX7CApY1qyKLUhPWUDibLv2UVaX7nIj/2/KcYmsSrtaJ2f1lbf2HEHON25jYT95iCLeiAaFqw6r5iXPVL6JXYOFW/pq1foDlm3kMx23kjP1lcOwOYr7ykrZIkOuyP8qnYzqyzhhqtC3F9uqbDKZDMwCU15riCnxEb7G/UqMNb8xccDcD00RYtmGj9oNlZjwmVNFufLSHyjDMmzegELi/1ztsotTyzaIFA0tAMJYaY6psSRXjah5I04vjRw25umvFLikdrAAExOHdcl/wvlKoBaguSsnNAgwMpkMkn1XZR6WI1NwfRh5RpBDsD711YNagAffRMxuNqdppxhqoihSN1G2EL992HnP/2MKMVBH2Me5zr6IonXeshhSNLgWqeaN72ZDzPLS+euWFnANCsPhuoCY90WzZxbLqseFAwqETmKqQ1wd9SEa/9o++wSq2/nW/qh/XYf/v8UB+iarZsSWevXQ+pPpWXrr8iqdpr2mKIguuAqZTDZBfCTbuqsx57s7/Zza6kzhUTL/YAXZoh0IEe62qCUSb42iqKjzr9g3AGIGxsgdvsHv8oL3JdLjok8RdmNN4OErGBgSF97mkKtNXLc5Jjqp2zmUwukfHD6HbwVWFBPb3VxaLObLjBMNyX0BMWqS/vgMkMHOOlT8Y7WCnLm0QXk+mM/cv3N/3oB8Aw
 K/NLXDOO
 g9ND5CmGBtuhz07qfULgD9111t8fi6Hwy98xD27FsSn8AO1cSL2AVEC9zq9KQoB+pC3iQdRbroTP5+04a2S54/J4Azqc3mHJevqWpKz1gSxxorw0Q3fOm5tLkrM1dUYlxaHGMx1+bBDWzcspGxATBYhzSQTkDCBBeb8NUbs3cNKoD/CXE9XdmM6ij4Ze8U6tudvjVM8YLbfRAt9bu9doFRQa+DLF5E1+oj4nxSFHl3ixTwerYId5ycttlrcjbHMfcVrmdSbEB809qgwLstnf2sdjvgeYY1xB5L6/RSFmLZWFwNzRoDzIB4nWG+iXpVev8CCgA/2UNNZMDOf5/7yueHdPhAU21Fuv7vjj7dFIMMOMcih30N4VUTXHu/DqM+7F04sbQHW2FXSkQzndxLubs/o2tfDf5JzxCB6ObATgkKTUBv1NPLNpGd71fUrolYG8u464ED8nk6GmFNoFiZdCVNQgTTxZhxvUlim8lxkRYiJqRGR1y7nBDb9vKgFp7MvvCmLp85mSLZuXgybxbO9gfDdG/PbttvsiW6yMZqWRHZ1TwkyE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Apr 2026 at 14:20, Thomas Gleixner <tglx@kernel.org> wrote:
> The only remaining usage of get_cycles() is to provide
> random_get_entropy().
>
> Switch m68k over to the new scheme of selecting ARCH_HAS_RANDOM_ENTROPY and
> providing random_get_entropy() in asm/random.h.
>
> Remove asm/timex.h as it has no functionality anymore.
>
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>

Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

