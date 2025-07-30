Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F33FC87FCB
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 12:50:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76C266B008C; Wed, 30 Jul 2025 08:50:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 743F66B0092; Wed, 30 Jul 2025 08:50:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 680A76B0093; Wed, 30 Jul 2025 08:50:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5D9116B008C
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 08:50:32 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1D16D1342E9
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 12:50:32 +0000 (UTC)
X-FDA: 83720914704.04.7133410
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2A39940016
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 12:50:29 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=U6CG54hd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753879830; a=rsa-sha256;
	cv=none;
	b=KKFT/Stfey1tH0dE6G3AP6o1heQy8PIjkvGYtMjPG/4C3Hib+rhVWvjMfX53cUf8Y7d3eo
	BYoFgUIN+a47c6bl686elQOyngnFjkXd9Y02nkj9hU3H1S1C39KIUrnMFLhDPPiH4f9wUL
	D4SZOtRBeSGl+NZp8TUkfZOapSbhMgA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=U6CG54hd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753879830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tvvn2gu3QwfMvEps+Es99aXQTd4n5DxwynGQISYrqRE=;
	b=u9QkFRzOAkCEY7qvplbVQ510Q9NJJdXjwhvcqS7YIcLER0d3Dsltthpaza1VVbtaYcu6PN
	a4QPRiiU8dnwjon3o+g3TXWEa5sZGg99dW8SDVFxpUP6Y3g0hnpVEpNo0l0AUWJPxSVhr/
	P0ffiMcBjySzy6ZuotPXYNkKrYy/9hs=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-61592ff5ebbso1004269a12.3
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 05:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753879828; x=1754484628; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tvvn2gu3QwfMvEps+Es99aXQTd4n5DxwynGQISYrqRE=;
        b=U6CG54hd40ka2Smq2kea6mp3Tp6o2PyiMCr9hZ6ldCFVRr9Y7X6Xl50tj/88naWE9V
         fWAge3jcLNT9SCXFbHb1WemJlSl86MkI0vZ2DctS9sPaaLO1bGMV5hK2/v4SaRSbnrak
         ylSPGizxwiapxAb2MOwEobScWJAkYiboWBWtqDpyZC4yRYgiGunmSfsYgHtkYbo1lT7n
         JHGa5m34/pqEczdwPtKU6nqtuTVk7U4GddUMZXJTgvNkuBvICljy4JD2MuNLMXyYJSFU
         fS2llubmknMs8KJ5RMyIc4FuVPJRVKjW3SSuzo8/wG9SZXeyofMQa0o7Xmnpl7VYVK/1
         MwgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753879828; x=1754484628;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tvvn2gu3QwfMvEps+Es99aXQTd4n5DxwynGQISYrqRE=;
        b=KVrEmtUlUXShj3FjVunI04GI+8kFeKztcGzhS0+vVmNageWoLkZuhF29Bsmjz5ORTl
         hns0EctFX0Xzmb7pnEQ8zuP87ycbw+JxBPj127n2OdHYQYfinRLoVKxOw2k1cmqD7RVx
         8Uk9uAmD83ZQAcsrXiqwU1pfuks+61hfc29e6Ww1xBncHWkgc7ViCjl433zOv04ujaRk
         hD3U651UTWbvQOeQUYjvN+qKhbyza7bzA4wUPJUFuTY0s9htr7inN479moL2/sRTmm18
         JMs4NMXdTFsh0HyP8V8xClTflv8Gys2XCHHQoR+qmLWyk4SlezoSO8V48txWqlgscRyJ
         QHTA==
X-Forwarded-Encrypted: i=1; AJvYcCWidwAyU3YZA9pG4xYhRKOdgqx67ajO+fnCaWeUVLr4TNROOlYHY+EFAVbWDjeBAymYnQctjL1mhA==@kvack.org
X-Gm-Message-State: AOJu0Yx0dHa+M4j5tyo814V4R1YcfbgwKZW2U4t6hfPitX+zHEIhPjIN
	edLynYs5zXMvkHf4g/8Dkh+uyLxX5Tx2xC+7Ki6fa+vyWApck3Ez/ak9YfeZnk9Kmn12fH+qwDR
	RyJqBU94kpYLMCDKn9DrO9GUOVFrrFac=
X-Gm-Gg: ASbGncvC61Mb/h7jyrrupofs59DefxfuS6ei5TNqlZkVDxWpObmh+9lg9appFjDN8iS
	YfrmmkwFT7su3zwrYXJe56oPRidPEQyiOlyIQhspCiXlvrGU1aQ0oiJVMqFtNWByrhxzv7CnYIJ
	EObvENy6QglGCqTI9cXNqU+RB9b8SBXcWbJ73YPHuoKaWzKpbRgEAoFlW5+AZ/7If5dtphlqbNR
	NPKrz4Jzg==
X-Google-Smtp-Source: AGHT+IEJQOY2N21rRHh/x9SsZgR/AC6673gfg/Aq7DulgeR+61NEupHsjseGW2o2I6RkO01k98hTvI6/W9mnPdZHDTE=
X-Received: by 2002:a17:906:6a12:b0:ae0:b33d:2a4a with SMTP id
 a640c23a62f3a-af8fd97569fmr398869466b.35.1753879828299; Wed, 30 Jul 2025
 05:50:28 -0700 (PDT)
MIME-Version: 1.0
References: <20250724-pinctrl-gpio-pinfuncs-v3-0-af4db9302de4@linaro.org>
 <20250724-pinctrl-gpio-pinfuncs-v3-12-af4db9302de4@linaro.org>
 <CAHp75Vc4vsJh_-GbP+YO50veoGoGtfAPL4tjcF+73uophfmnGw@mail.gmail.com> <CAMRc=Mc1ophkofB6MmtD4adBAi69C3JyovM-S9YD_y7UA3V1qA@mail.gmail.com>
In-Reply-To: <CAMRc=Mc1ophkofB6MmtD4adBAi69C3JyovM-S9YD_y7UA3V1qA@mail.gmail.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Wed, 30 Jul 2025 14:49:51 +0200
X-Gm-Features: Ac12FXxgFDuQutFN_-MaFgaos1SbYd6nY92Ty-kjNsHnooD1EOK3KyGkMl4TA4s
Message-ID: <CAHp75VcV=K-DfOGs0z64==nO+wQNoEB2Ngd2vc+dLYr3WLChjg@mail.gmail.com>
Subject: Re: [PATCH v3 12/15] pinctrl: allow to mark pin functions as
 requestable GPIOs
To: Bartosz Golaszewski <brgl@bgdev.pl>
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
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2A39940016
X-Stat-Signature: 1b7w9esra8co4mf9tce4wb1a9tzhupjr
X-HE-Tag: 1753879829-206597
X-HE-Meta: U2FsdGVkX1/HoMK0Y1hVZ46OfSnUAab7V0nFa6YfXCuy3K2spHp1BXmui45WkBVN/tJwgrxCIeCUSHcTWctujdLu8qW3H9Me1BeZkVurXNWlpOmRv6OUlUOtnxlBlXaoKmYff/0WNoQafoSTnV3Tm/E14nDu6X0R8GgsZBDck+nZNzhD+ckb4aPHP13vzdUYjMiFljHz0k7pJatPtl7jZaNMDYZ1xU10tHVoSBV7TtV+lNz7XzejudYPWeGjAL3HIOZD45I9XXRTwReOIMY1ApkfWb8ovUISWka7rorYZxq/JUZQb86NIPNmgrMVa+VJYJi4LJ7j6Td89qMsDwmh1AkuvxMXM3S9bYENzYZubFsFgTskLJGWq4jb5HjB2e5kl3ZpUMbQ81yTsiQ9Byjwcnto/hLjPA6laA0dOx6xLoQToAtCn9CO0jFkMAdOrb9M9LEs0lJ3CtTySCD157mcOl3SJZYLpfkqPq3FxFT7dRMhLr0NVcZec2omRzpVBWRl5DqmYyKizM6UjsANx2bzb0dsZn7sylP+mL79IwEOj7jYAMlGKK3BAOKAupQiykR1wRM920bdXPkrK5ha7L9xSLNGSpx87svhrLu+DEZ/Ihoo3rbcYR0Fkbo/7Ht4AGmuFJi3CwPiedqq4rKaK97Xu0WiBpKcAiFOyWxC+qywR5jKpVoI+YJxDY7NnwK531SiLtUKpSRPDWaemyNZwvwnb9O7wD/hZXjJXoQcqmyL4yvOcu4jzg1bLHXgaPshUbCUs5n1H6nnFG3pLUZmr2sDhzhx17F0dbDQxfjmLxQgtUy7748BAUnJvVSh1vjxCRxoKYcSxHivQaHjcUkVaNmyJknxEH1nQIBAuv1yyqDI21VYDo5GFba2K9sqsvwLEGhRnu0SLHhCtJ/tjb2fK00W0RChrcuzFKjGeObjozvJWGDQZwkJvdgos7RGxvF7e1Nfc++v7ql/DtfSzG1a40f
 ZMWLs9ro
 59Xn+e0khE5ME8pSYpGgyw4IyKRKtMI+ISXML/+cnkD1QUlvDUi0Yan58NWq/mUMIfxh5MmofmouSWpb3YF6+zcWspP2s0c1bg9N22MSQKoRq9a68hga0A3i16EZTWkH2hqmNmsZASQYdUoKXZQgRbYVx/J9FeHapvT8JyxpulRCw7H5xRXm30wPbPo0YHLYZljoWce5ve03HEXZ94y0KrG/QiEK5jLDZDMdCsWZRC7l+c8geD+B+l4difcNR2lWwgnzjyBGA3ghYi4REsO3VPdrtyEs+azsRUsZSTs5Th8iPz8hvb97O04FQZC5M6s+0/ItmyWqS8V2Cis7U0smJjQFd29vvHRsOCrw6xx9/hCSDJe1H9oRipFsFipSvomSFTNC0q3xxJXQFIazbMH3IXYy4I1qoojkqtVWnttNugfQJ3qxxOL0mEJogBrF3OuagA88YE0pEjmFPkf2aYwAZ85k6WDl3wLApq2XA4Y1/c0EEKu8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 30, 2025 at 11:54=E2=80=AFAM Bartosz Golaszewski <brgl@bgdev.pl=
> wrote:
>
> On Thu, Jul 24, 2025 at 2:22=E2=80=AFPM Andy Shevchenko
> <andy.shevchenko@gmail.com> wrote:
> >
> > >  struct pinfunction {
> > >         const char *name;
> > >         const char * const *groups;
> > >         size_t ngroups;
> > > +       unsigned long flags;
> >
> > Not sure we need this. If the function is GPIO, pin control already
> > knows about this. The pin muxing has gpio request / release callbacks
> > that change the state. Why do we need an additional flag(s)?
> >
>
> I'm not following, how does the pin controller know that the function
> is GPIO exactly, other than by the bit set in this field?

AFAICS the gpio_owner !=3D NULL means that. No need to have a duplicate
of this information.

--=20
With Best Regards,
Andy Shevchenko

