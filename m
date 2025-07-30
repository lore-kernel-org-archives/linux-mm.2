Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6561AC87FC9
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 12:53:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F40FD6B0093; Wed, 30 Jul 2025 08:53:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEB0C6B0095; Wed, 30 Jul 2025 08:53:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDA156B0096; Wed, 30 Jul 2025 08:53:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CB8C06B0093
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 08:53:53 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 54AC080525
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 12:53:53 +0000 (UTC)
X-FDA: 83720923146.04.A673183
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	by imf10.hostedemail.com (Postfix) with ESMTP id 332D3C000C
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 12:53:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=k3pctjtZ
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753880031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qUTEvgPr5pDo52lKZf6mOXPWs0RWvEkRiwEoyLLTu3o=;
	b=7PNsWACtgZpNUx0I/3Oo0hlxv/N6KrohrXXNLUW60E34M4ZsvJWVOj1SrIZsJiyt+d7pIW
	R5XeQfcx07kvNj4aPmHE/kCdQQ3VaaZL0y4LqvB589NugTUpkHnyZ1QfjfDtAYmq8aMKcX
	D+6jK7eQpUKlAuVsNMYaiLlP5FYg8/I=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=k3pctjtZ;
	spf=none (imf10.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.208.173) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753880031; a=rsa-sha256;
	cv=none;
	b=7EsY2cT3p+UT7fEFcM3MdIV5xLWBeSM1fs78INtG4I/6Wri3RttvLx5+/k5a0hfCGKgNMW
	GmniEw76DGqyzyvxmhi8YGuxJcjjusUlsAFayX4cXzZj++StWIZhICxwX1nJ1ULLPAeN8P
	ch1CPQWxZ8FqHfjBiPU0mYRhT4OhsIU=
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-32b4876dfecso8579871fa.1
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 05:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1753880029; x=1754484829; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qUTEvgPr5pDo52lKZf6mOXPWs0RWvEkRiwEoyLLTu3o=;
        b=k3pctjtZ9Or506iLuWYZ6cBQ0wjudxz0FDYVCkCHpm5fUTImwehg8aDxcpqirwF2tj
         LXOR3sj0xlyLkIWtW2mf8Ss0v4zuJMh/ywp463oVdAAffiCGSnx8eIJ2+L3QL6yP0g9H
         C9gHpdUr19a+TU98ZBaD6DJLeQhPDKfHjFocb8wglfLBKzCMEfoUuSE0xQXczWA1tDPs
         rigUYdk/7bn/NJNV+TngsE8z+Y26mUb77mEnBDyrXFTrHtkxLKiMXVc5HtRwG8Vr1/eq
         RdaEKPYdd015eBtxe2bUrA752eKHcTi+DSJA+YYxKDHj0M2VAAtHTnoThZalH6WUXwBb
         8BLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753880029; x=1754484829;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qUTEvgPr5pDo52lKZf6mOXPWs0RWvEkRiwEoyLLTu3o=;
        b=EUh5eevNQLvFzRELVw/ZpkcwtWKqahTph3FsxlL3qh25TLSfvlVK13qH9SR4hq7mIQ
         WmxByGVKhYGTDX6YlJiFtqaS9GxNMTm+5YMGEnHc/6xHkJiN8eAXcem3erxRAGlAlPp6
         qtJj7O2dbB7UNJ6ha5sls50hZ12X/GAAqAxWJpRlqf04w8sL+LTQnH/RaZHxkuCvYDcN
         i1GvNjRxgAd5lDScvM+K2xJNFHb79Cxo8T1TuhzV3La2m7WnQUTEPVUERtr3ZjAGNhi3
         uSHe11OqBGKGxNkLqep833GWaellbXLc6cMUTvOgHegHh5ammG4HzbTh70fj3w5hpcDt
         xdTA==
X-Forwarded-Encrypted: i=1; AJvYcCXKod8PebimGDsYSYms5I2dn/LYeAEc9s8raP+fbsezoRtj3DkNAjW7C2WFL7c1anZ1QQwlZomy2A==@kvack.org
X-Gm-Message-State: AOJu0YzBviu6Tlpyp6+AkHvJVlo4lzRaQri7F/pTqFvgl+CW0dzayrAq
	5CsfWKVuTrJisK+K/9saalPkRws/c/mcYWuNtR4ghRJdYAJjda/VVhG/ORulCvVNE2rrlBz24QQ
	DL2i8RE/xT2Xdfkgt50FxJLfBN6cvEEOMnHe2THV8VQ==
X-Gm-Gg: ASbGncu0cXfN6zqcnJtoEW9Jv5fK4dOnUZ0ZM8IJduE+uWbwRXXyr49zge3bMoM1TQA
	tV/GJJkxIzwRQ5gkgOlxx1r3B+r9EkHDUGcTizlp5HWJNXgrjA0lvIJQvLxNwEZ9Ah1crHG+Zfe
	8rwe6B+MF4YoT6Zi3QEV5FjLxI0rWjk26Y3fTgO3KQvD79vT42jqrSATuLvqQaqaUyxq6qmf8J2
	ej3OWqxQT1Two0kGwnF3NqcGdpPrpMUZgwYqAM=
X-Google-Smtp-Source: AGHT+IGSuyPnAInz8gQT37fKK4pgrT4+RIAYI9IrKjK2MWPd45oP6K0zUhD/GSonCiRI3dzBbJ8n7cWJZ+qNt54xgoU=
X-Received: by 2002:a05:6512:ba1:b0:55b:83cf:b260 with SMTP id
 2adb3069b0e04-55b83cfb693mr305928e87.11.1753880028944; Wed, 30 Jul 2025
 05:53:48 -0700 (PDT)
MIME-Version: 1.0
References: <20250724-pinctrl-gpio-pinfuncs-v3-0-af4db9302de4@linaro.org>
 <20250724-pinctrl-gpio-pinfuncs-v3-12-af4db9302de4@linaro.org>
 <CAHp75Vc4vsJh_-GbP+YO50veoGoGtfAPL4tjcF+73uophfmnGw@mail.gmail.com>
 <CAMRc=Mc1ophkofB6MmtD4adBAi69C3JyovM-S9YD_y7UA3V1qA@mail.gmail.com> <CAHp75VcV=K-DfOGs0z64==nO+wQNoEB2Ngd2vc+dLYr3WLChjg@mail.gmail.com>
In-Reply-To: <CAHp75VcV=K-DfOGs0z64==nO+wQNoEB2Ngd2vc+dLYr3WLChjg@mail.gmail.com>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Wed, 30 Jul 2025 14:53:37 +0200
X-Gm-Features: Ac12FXya2mYA_HSI46S7KktzTvTwdWuT-o4vBrrr3z0vtr46fp0gRnU_ZqynDBk
Message-ID: <CAMRc=MeVOEFkdqf+SwQ-a=7ZPvpoerb4G_kn-aZgNLR3aTTUog@mail.gmail.com>
Subject: Re: [PATCH v3 12/15] pinctrl: allow to mark pin functions as
 requestable GPIOs
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, Alexey Klimov <alexey.klimov@linaro.org>, 
	Lorenzo Bianconi <lorenzo@kernel.org>, Sean Wang <sean.wang@kernel.org>, 
	Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
	Paul Cercueil <paul@crapouillou.net>, Kees Cook <kees@kernel.org>, 
	Andy Shevchenko <andy@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Dong Aisheng <aisheng.dong@nxp.com>, Fabio Estevam <festevam@gmail.com>, 
	Shawn Guo <shawnguo@kernel.org>, Jacky Bai <ping.bai@nxp.com>, 
	Pengutronix Kernel Team <kernel@pengutronix.de>, NXP S32 Linux Team <s32@nxp.com>, 
	Sascha Hauer <s.hauer@pengutronix.de>, Tony Lindgren <tony@atomide.com>, 
	Haojian Zhuang <haojian.zhuang@linaro.org>, Geert Uytterhoeven <geert+renesas@glider.be>, 
	linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mediatek@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-mm@kvack.org, imx@lists.linux.dev, 
	linux-omap@vger.kernel.org, linux-renesas-soc@vger.kernel.org, 
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: a54hnnowau5ujcpp9g4zytrpgbgqjpjc
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 332D3C000C
X-Rspam-User: 
X-HE-Tag: 1753880030-40664
X-HE-Meta: U2FsdGVkX18LWBBWn94S4pzu6cSpYWBASemalCFkIqRLoFfI+8nWB9MEn6REoJLyIqkkC8Pgqxf8k2FXDJ2PR9mrYyrI/gKVU4KbCkprGAGsm2DtL4Zne4/DoLkKVAAePm4//rep1V2FtVgGZCNFlcG84WzZyWexVE+NGhgKFEM4pnHr6kBIeLpzkunrE/gonGt5F4R7Kj05Y2WFB+wasI1MetUlslibzMot5i3zk42wMFMTSf2lkxg3EiiXF9pABQPShFAHYKiiR1lG5SjvcYhdAaM5aJyGP5LJYqsbgzkuuc98XdlbgkwL1tbZnvgz2gF8qhRk8MhXDnQoZxLq2xKFpPAOYYXQhr8VLpFFMput7TrEsEZT0RZzRdS2Y+pGXtTQ6GhFyHpvSXexwuMNrjlH52+okuxK1CyRD9gJhBZwrBmo/dZbATMtoLDWsP8r6yh8vULXGgMIkZ2edbRZAQZFd11siupoMQz0Pa0wWAOIkYnTuJiicNSiCqSqMi/5rO7j3QhITpHUh+g+RpuRf+ex03R2nE50tQhFfXoUXJMX+T6fwPBZpE0fEa4Hia17LFaGJKaWbKAUvBHwxb7pAHotWQNSd1fpRWln4rOHVBAD8JPVCBpjFUG6S2bLuAGnc3ajXpiKobSQr7FFTz60EOSsn6dkvYTYeFRwHzFhEP/cwOpt3JU9NO+s/Q7nTpoU39Z3j88Xatusvb3jeCiHmOhrU0EV2YplAwN0gYwPPETgCSZlYUrp0jVpws8HSZLvJBiPYV1Gy15JzZ0MwvJPA6vV6PmzWSAyJLjwFg7Ibnr2OmoxNp9sIVr31do7pzR/KCRcMAuTTpEmRa1kpr6AL9gG6WvI7mKjmYvbsd2AMqD5n6TpNeKzL6JBHjMZqqxtXOFVWn0pQPprYPfc9QzRWxTqH1PYKtnriinktnkOR3cKTdjooCGzieAwWr5yZkMoU/KNVxTipxojnSwOsr3
 TxwU0rxl
 P/K9V4fIrL9H/Q8njzkeVbXOcd7vAzGqtJFPEEmz8ykFt2T03dy+JEiEPdwVe0v3n1fTzIU+hEYhO/8ldUlf/8kzM9166pjtAkwGu2/vkJ/9XwTGpmcxtLQMlyKw7UUKKGTAzuVij4z0zq1eb8WzMgTZsIWWMRO16LD0jeXO6u2Zl9YWb285SVQvWGwRECA39NBtmksmD6gKQ2F/nTSnqQA9STkv91MOxNGEu8YU8GGChjP97xqDHyAqLdAJW7WYHXAE7mcrYxFT/ECQ6AO/KOBgf4rWkJAH24Obj3JXEHZT/1YI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 30, 2025 at 2:50=E2=80=AFPM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
>
> On Wed, Jul 30, 2025 at 11:54=E2=80=AFAM Bartosz Golaszewski <brgl@bgdev.=
pl> wrote:
> >
> > On Thu, Jul 24, 2025 at 2:22=E2=80=AFPM Andy Shevchenko
> > <andy.shevchenko@gmail.com> wrote:
> > >
> > > >  struct pinfunction {
> > > >         const char *name;
> > > >         const char * const *groups;
> > > >         size_t ngroups;
> > > > +       unsigned long flags;
> > >
> > > Not sure we need this. If the function is GPIO, pin control already
> > > knows about this. The pin muxing has gpio request / release callbacks
> > > that change the state. Why do we need an additional flag(s)?
> > >
> >
> > I'm not following, how does the pin controller know that the function
> > is GPIO exactly, other than by the bit set in this field?
>
> AFAICS the gpio_owner !=3D NULL means that. No need to have a duplicate
> of this information.
>

No, that's not at all what this series does... gpio_owner is the
consumer label of a pin used by the GPIOLIB framework. The flag I'm
introducing it telling the pinctrl core - before GPIOLIB is ever
involved - that *this pin can be requested as a GPIO by GPIOLIB*. It's
the other way around - without knowing this, for strict pinmuxers,
GPIOLIB would never be able to request this pin if it was muxed to a
function (even if the function is called "GPIO").

Bart

