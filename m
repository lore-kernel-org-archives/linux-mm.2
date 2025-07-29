Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F6DCC87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 09:24:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEE046B00A1; Tue, 29 Jul 2025 05:24:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9F716B00A2; Tue, 29 Jul 2025 05:24:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98D5D6B00A3; Tue, 29 Jul 2025 05:24:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 867A86B00A1
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 05:24:10 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0CA828055E
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 09:24:10 +0000 (UTC)
X-FDA: 83716765860.04.89B0CAE
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	by imf18.hostedemail.com (Postfix) with ESMTP id DE3321C000B
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 09:24:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=xwtlrUrq
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753781048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OvMriwwuRsxStr2YyKe5TWPbRI0lQN4j3ZQYt22kpLE=;
	b=S1bqLEwdyes84l05toRSvP+Z6DvneKOPDuSMn4TT+JEN4Vl864RnAr38eHacwZu+y5MSQG
	tv2sCbPL9u7J5RSRb+RVZfg92TbXpxNI9M0YfrCSx2G027XT6+ZD1UsA5YSt069Jae47/o
	ywualokdfJattWPfNy4wxBZgLamQHlk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=xwtlrUrq;
	spf=none (imf18.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.208.170) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753781048; a=rsa-sha256;
	cv=none;
	b=CjfvRrc0rN678GIMQg/u0zbPyCvXlz+y8b6NxtA97CT25a1Sf2ZBMF+JA+uXtPWLzJCHL6
	ovpyr1NywYhmUWCHUYWkqqyO0nEPIeOEYOgdJDr5ukEx+YoBJ+F0fZ8sfaByGZZxZkpETu
	2KV+benbB7GMICR37xtX13LKYNYh2Yk=
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-32b561a861fso45402731fa.0
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 02:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1753781046; x=1754385846; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OvMriwwuRsxStr2YyKe5TWPbRI0lQN4j3ZQYt22kpLE=;
        b=xwtlrUrqRH08khr6S4ZDHW/VEDUCVsESp7gNzrhNK22r7AGl+cv/WKq+mBTBiaoemj
         IV3vnpp9M1DDM/ftOixpUJSHfZCwcmf+K8WgL+sMEzOHpJCFR6tQ5OmSrGqJZselxU5B
         vOIRoeCmeuVvwP277Q0xziTCEMslDd3uvBrf8gQpNYs/1T7cnc4KlgVfzpotu3EmTfnG
         vBSEaFqIDJlDTjAYj3nCxqU4jTj26FfEOoue43sJAxAn2w3pDp6JEiOYz3hMdrTzXZKB
         MwqgRHaO7RS+DOdfbpTW43V1QW4mqL3wyR3U0Zg+ZUrlWc8itc9pCxBSVGd7FOgagQSA
         M1nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753781046; x=1754385846;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OvMriwwuRsxStr2YyKe5TWPbRI0lQN4j3ZQYt22kpLE=;
        b=DchPiwD1oua4kEmTohXHDPv6V5h+Qb5PL4DZEislvxAbeUJ7+VuyH2tnscBDsxOUR+
         f4DpCRuLL5JZQZ/gpW0lkZnwycLK70r241rswR+Joe6l7tlEXoKK3IoVY+dKl+I4cICK
         w3pc6u9iAHS0BIAvuyX3rDl2r5MkKLXGj2A7iMKhfETdGPDGbfJBvSv3zCG06R1x+kSk
         Xw7OXa4UgtN9Ic5ALGHMIYG08Qtiwm0q/ZW3qNTam5i/fXqowueyUxytGBqGMIiiW6v9
         xNVJHRbNCJrwfZ5OLi8+YJVCkObJ9zFOXBGrWqqdlVaHSCajr/wzflH3GS0b7wc6DdHS
         hBvg==
X-Forwarded-Encrypted: i=1; AJvYcCUk5TAJIGsKwV6UA/z7bAo8czdKm7Di4Q+M7lC3Ur6VxOqLnBKnf2aNCD8QF6MvBWv5iFu7eKDvfA==@kvack.org
X-Gm-Message-State: AOJu0YwMd9n9k3lg5SQ48QUhWUbdbpEa1SNk1tSOS0+XTktELhxRiCx5
	jFKfSpRkf2pdJe9hunFsPj4a82Mtg5JyJdJxi+LgAuDCtv4OMy8PeI9zfvOtgbCsQJOMgBdZ1La
	OnHEM9dB+qrwa8si2nUrThGMO/XQocdrWwAFbMu397A==
X-Gm-Gg: ASbGncsdzlmnyq71Djj+O2gvuTIKPnRBHFY4AeUzfKuFE7JYYtA9dxFFgPyVowrCUvh
	1DxBNWusJgss5w0bS5BNdSyjIWKgusi3TWPU7EaKefaxufRWjXO6kToui4+PGV8+ZIbveSRvc5N
	cAlsIkCHnGeuWpJUhabw4il487Jaq9j3Zac8y441RG9jLNILWveZbQBV52iz7/laL/n8v4RIrin
	HAVTm8x5FxOPc7sWOkPR7xmyTBVSZKS2gYihBxDwhhprvieew==
X-Google-Smtp-Source: AGHT+IG4d8eX8f04SwumbDn+t8ORtzgwAVwNB5BHKdmUryIfl8eqxh2e3123W81layXfFQt1IEka9/bpWuzrKar7j3E=
X-Received: by 2002:a05:6512:3a86:b0:553:d910:9334 with SMTP id
 2adb3069b0e04-55b5f4df595mr4041752e87.46.1753781045533; Tue, 29 Jul 2025
 02:24:05 -0700 (PDT)
MIME-Version: 1.0
References: <20250724-pinctrl-gpio-pinfuncs-v3-0-af4db9302de4@linaro.org>
 <20250724-pinctrl-gpio-pinfuncs-v3-8-af4db9302de4@linaro.org> <CAHp75VdMmfV=z75K9AmB7GsWV8C1bZPLGi33duTCt+CM79spJg@mail.gmail.com>
In-Reply-To: <CAHp75VdMmfV=z75K9AmB7GsWV8C1bZPLGi33duTCt+CM79spJg@mail.gmail.com>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 29 Jul 2025 11:23:54 +0200
X-Gm-Features: Ac12FXwkqCsphx3p10ZENgy5ARM9FowTyJPFq-nwB_5x6uw2mPSH_J_dgheu8yg
Message-ID: <CAMRc=MeEo6p=6Tp5kORi9y5tGNJKrzh0kq7tpe_E=5TasMjgbg@mail.gmail.com>
Subject: Re: [PATCH v3 08/15] pinctrl: keembay: use a dedicated structure for
 the pinfunction description
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
X-Stat-Signature: efcuqmxsq6ukup8481bthccoz9xs3xsz
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DE3321C000B
X-Rspam-User: 
X-HE-Tag: 1753781047-530712
X-HE-Meta: U2FsdGVkX1/bDvFiTHHsUYO8u6GbDX9AeBSVseeqRHGiM8elDzpBeCuuEbLyj8665o9b/728rZn5wmZqPiK0aM0bE+wB/HhHhZvcREfjSDgqJCQWzuSYpjE6FNQ7/H0SY/lbKzsoLjzk7L9mY2TppO2KqhVZKXO9YkXKNKgTE4CU1WQOeI6lDZVF7KoSlJ21wvNMAkfOyNCAXxy0Ib5+0QGeUIw4RpPHXQCCjDw2g9xIbx/FMmCq6bQAF2281QAgp/mnMwGy0PdFvSrJCBcWleOuT3GQ9xSd+a4nmvQAOgvUwIU7jHVEhQ0LnEt4qYjMe9gC8GB4gBYRDsn+Z+yFL8wNxbAtxEu/HaK3GobCGbfqtAG1z48g+HOoUL49G0Hzw5jxLqzhKELCyIcYp6/MXf3GskDbM9cxtDwEosxyirZcopsckgPFIaW2kmwhiByQjbXfBKceNFg51EI4zuMMMrvBi3nJcTeFtw4/7z4Yp8ql0LH7GYPEj9Dxfkm4kY3SMxcoCjlsjIojC1lvPIwBqCn4SeNn/LFLwRk5LViIGqsoTe0srsacEJ/oRm6CuRwaEs/ni5Box77nqngYPtK6FNxVs1WjoEJxsvwmvvtbDiTfbdjaTQFfYXoM1lFE/IQfWkJtRhbGBIckZJwhvnWkTsS45vCAGY8tOKyFb60PjKbkVxXBRXshbLRpup5jjntr1rgBn6vViRCtRBE6wQet1htraV0AfjnV3lNADzSfV4rcSqOzANKJ/UaseZyJVX9EarqTgSw55goqF0r1hw1U9pL4kLhwIfYKSl8yNgB51EU1fxO2ebxTn/LWHg5omskz0+RTiPIeuSsLGdMrGkMnsoeDJRoGM1kb2Sz24GVTA5N+1eEp0wBNJp2G3hMVg14CGvSZ2UtVbmGBi6o3hFkc60qdY0oLgacFk4AYUmQjfxPi8yBka3+ucfMo43RRLqBx8LXB0TmYxIn9AchRFdT
 XN6uvVA9
 eB6mY3d+2Tu0u7JHq0HLCROUChRvMURYRzlikJih/QqIM27DKf2XAs4r4ojsS2kvIk58Va1hh+ISMraCTJHuq7yrAhGYKQFX+Fm6MH1a7n2mQrKG7jEIqCXFPP+UTNSx/7Jsyp7xRdqCJ+f1RPvEoHOYGwwM419sH35t6XBfbm/CrmlDm3uOylqqpx734pN6YrVSXZrIeQUbKEjCXGgB3goMogaDABqsNMANiVTw+HxrRWzBrHkOHgqPpbU+Jt0+tTRvh6zpKGsKQZRlRecCgdcNiBKP1/7WG79+RlMki7L/ASe0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 1:11=E2=80=AFPM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
>
> On Thu, Jul 24, 2025 at 11:25=E2=80=AFAM Bartosz Golaszewski <brgl@bgdev.=
pl> wrote:
> >
> > struct function_desc is a wrapper around struct pinfunction with an
> > additional void *data pointer. We're working towards reducing the usage
> > of struct function_desc in pinctrl drivers - they should only be create=
d
> > by pinmux core and accessed by drivers using
> > pinmux_generic_get_function().
>
> Any link to the discussion and perhaps an updated in-kernel
> documentation and/or TODO?
>

The discussions happened under v1 and v2 of this series. The "reducing
the usage ..." part refers to the need to avoid memory duplication of
struct pinfunction really but it's a prerequisite.

> > This driver uses the data pointer so in
> > order to stop using struct function_desc, we need to provide an
> > alternative that also wraps the mux mode which is passed to pinctrl cor=
e
> > as user data.
>
> ...
>
> > +struct keembay_pinfunction {
> > +       struct pinfunction func;
> > +       u8 mux_mode;
> > +};
>
> My gut's feeling that this type of construction will be in tons of the
> drivers, perhaps better to provide an alternative like
> struct pinfunction_with_mode {
>   ...

Nah, literally only this one so far. And I bet we could rework it to
avoid it altogether. Your proposal is too specific IMO. Let's cross
that bridge when (if) we get there.

> };
>
> Or even with variadic arguments... (just saying)
>

Oh please no. :)

Bartosz

