Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1009C83F26
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 14:45:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49A236B008A; Wed, 30 Jul 2025 10:45:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 471556B008C; Wed, 30 Jul 2025 10:45:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 361446B0092; Wed, 30 Jul 2025 10:45:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2400D6B008A
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 10:45:38 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 804428066E
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 14:45:37 +0000 (UTC)
X-FDA: 83721204714.08.B564649
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5A91614000A
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 14:45:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=ICCbGchV
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753886735; a=rsa-sha256;
	cv=none;
	b=6yuYt6C8W8TpHWOcyNZj+mq00byv0a2HtQloeKrqOXa4RtQsHnd1N5owzwKN9gt32qBeA0
	ojs3sDgCDokbUTIToijh6yPhQ9hiSIVdZMxLg66vzK1TKc+Dly6brROvDp6t91F+C0rDyV
	8HaGXOE7rj5wNl52UPtyLKAkaGLULKs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=ICCbGchV;
	dmarc=none;
	spf=none (imf23.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.167.45) smtp.mailfrom=brgl@bgdev.pl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753886735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m6AXuDDeUL1WpUxErghD7iQZDxn7tXl0MHZ3gm9RjBI=;
	b=m1nEClvPlnMLgtVfdwLuPocPGrN9tUK6omZRD786hKzLycyGUg8mBbzw00H0kqEYMbHljW
	faccNCla5lRij14a4v4T3xMUENuOERuF/KfXPO9ZvEUP1BpIEIIdwuJGT7efix/pkFsLxY
	ITF6R4Y27GdQzvh5pj24fwplEnQvdy0=
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-55b829c7f1aso612312e87.2
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 07:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1753886733; x=1754491533; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m6AXuDDeUL1WpUxErghD7iQZDxn7tXl0MHZ3gm9RjBI=;
        b=ICCbGchV88MUe4/Iv9ilm2t7oOXU6w1pgLOswdglio79LtKswltxbUztoUE3OfqMhb
         BDKspblr2PQjLvJEbgH3HYsSXe4Yia//S2U1NTpsIjz4lHYSK7nW4j87vCRP/SvpjzvJ
         1GgOk4mfVRi2342oBDXyjYe9gUUuKa+vv1Upwm9/VxlbbHGPcRNBh2XBtTIq3xM+QUGK
         lNsZCS7qd5I9gFXPvAEOSP/u3H5q3JW8cPw1UnzYR1K00WoHsZr2bt/rDglgX2SUsxWe
         +oPfK5glKGH9RqCGvIDR30V6kHFxtOZZr6dJ5n9cb1mOcF5EWvQG5uqsV4Xu0SW9jjmL
         sWdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753886733; x=1754491533;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m6AXuDDeUL1WpUxErghD7iQZDxn7tXl0MHZ3gm9RjBI=;
        b=LFoWeaSEzCK10IzzRvwkwkdQal/N65iw1ixjkuVEI8bIvHLyI9Pqt9+phYV85+aDzC
         Mqr5f2wOHJtx74VYWaZMX1wemQWe+B2VXC5SuR6R45k7hbke/3iuwBBAHec9g1Fu9vwB
         t1hqTLofE784MSi+jOkjuguy9hBU85qoEglZ7APyhYunyAQiq+B6WjPH7jbSJqfA20bO
         g/V4P3c1zZ24TABz9XP7NBULqVH5r4KCoz0rq4S7+xSF68lKBlOi9LLE7HdRboPzK9bN
         UPBuQgQUt5u0vf5E3VT1+rhpdpFIM9PMCpJux+g/yuhjzBlZCZDVhdxqYdymLwftjNVJ
         Dn6A==
X-Forwarded-Encrypted: i=1; AJvYcCWeJhyLrE1j4GexWjOKZlBT1xRf7xPJqJfC8CZy7sEGiBOX7MDo7ENiiij2zI5+jKgShCmVq1kI5Q==@kvack.org
X-Gm-Message-State: AOJu0Yx1Pe52xLnjIH297U9N4MiCqRorimUamgNMfXAOjq/fT5PreyRy
	p0zeQAkeeZIt/ym8ZUfX+zzrWETs7IFZ0p/UrbGfsPswk5dW3Xq6ElDuTqZY1NaKspCGHKoiWeR
	LG39b7HbHBps1JE7T75UDXrqUqOqGBXct2qLPzE4sjg==
X-Gm-Gg: ASbGncvnmtrxz/NSsyQBMczwgU5wfyQoJuPcQWyNiYu6T9JvLI8IE15mNrRBVHJil+E
	vRX7R759V1DdCVlRL/hvB6zYxfgwWo2eRyvJzcz/KmgJb10xxqydyJNhURFFpepbCbIy71KTO6u
	AbtICfK8y6SN5vMIayyXLq8Rv9wuChHWnFsDdjS+qaxMRlmMa2ir630qPrKKBL/3B6dNfyaWZkG
	sRZInQ1IfEkaAMno2g6jzdT7lGOLLAnrB1peZQ=
X-Google-Smtp-Source: AGHT+IG0Q6hH9i+UpqLftCvpSVBouzPpbLbuygIY2t4i0+nQyoHOVMz3gwtmG10RMLHn13yYgB8U2bSlEYWDzelEprk=
X-Received: by 2002:a05:6512:23a3:b0:554:f7ec:3b23 with SMTP id
 2adb3069b0e04-55b7c027afamr1034186e87.15.1753886733212; Wed, 30 Jul 2025
 07:45:33 -0700 (PDT)
MIME-Version: 1.0
References: <20250724-pinctrl-gpio-pinfuncs-v3-0-af4db9302de4@linaro.org>
 <20250724-pinctrl-gpio-pinfuncs-v3-12-af4db9302de4@linaro.org>
 <CAHp75Vc4vsJh_-GbP+YO50veoGoGtfAPL4tjcF+73uophfmnGw@mail.gmail.com>
 <CAMRc=Mc1ophkofB6MmtD4adBAi69C3JyovM-S9YD_y7UA3V1qA@mail.gmail.com>
 <CAHp75VcV=K-DfOGs0z64==nO+wQNoEB2Ngd2vc+dLYr3WLChjg@mail.gmail.com>
 <CAMRc=MeVOEFkdqf+SwQ-a=7ZPvpoerb4G_kn-aZgNLR3aTTUog@mail.gmail.com> <CAHp75Vd_5HVwzuiV17XKkzpEvzd8dzPDRRx5w-VqZnjuCz6m6A@mail.gmail.com>
In-Reply-To: <CAHp75Vd_5HVwzuiV17XKkzpEvzd8dzPDRRx5w-VqZnjuCz6m6A@mail.gmail.com>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Wed, 30 Jul 2025 16:45:21 +0200
X-Gm-Features: Ac12FXyd8ePQ6VSvFuinf3meGy3NBROTyjzQV07xe8o_XLvEkxT-hmgEmHvLoEA
Message-ID: <CAMRc=McPvFzb7CSFSKOsQZD9ZPwtf+bCw+Ui=m6OoX0GxH9DtQ@mail.gmail.com>
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
X-Stat-Signature: tkyjhk9pdrukxqtou3y8nfjcexo584oz
X-Rspam-User: 
X-Rspamd-Queue-Id: 5A91614000A
X-Rspamd-Server: rspam02
X-HE-Tag: 1753886735-302468
X-HE-Meta: U2FsdGVkX1+ddM/5d2zwW7GjBjBAms+qd1f839xp6CewbL26YKFqP479SOwNZQQZvH6q7KMfGbJxuNQS9fmdQWfO4pC4jIsQHpnj08rogv6V4pXxzB+YApED4gx73H5OUUMp1fWldZUUIiQmfG42kEW4piyiYcgCMN9akd7goq078iJIru/0RbwTr0qpGKfV59NDs0WdxiTP89Uopx1ScnRcBQkuOeNAMqpq8uFsZulx35p5k+QUbWlKMqZg9ulck/3SGVAUqwbm5mM4XOGCs3sEjjSEqPIgqm421rDvfDNK2Q4kGcX5JBZ6FATvKSKDbvXpqiCLgv03f6Cemb5cGkejqAIej8Urx7XK9yXpvj8VDrL3e8kKL/EoyzlBF1NHwqvQDHfnD50YX8ZiB4W5eT/DHWqiCLaRzqLwQw6f7QbnY+0Vo0RaSZY5fDKIE2I3mSnOq6oEKTegIctlUwg5Ys2rZz1gaXrt1bmSbQwSW4zJmAFE5Fmw0wfHCJ90+mKWEuZlHTN76A3J4lDfAqQd6YusPGODiVyHrgaz1Qppano/n2LU732IswKrg7G6LEi+vgq4hJQUwD9oxXbcBr7X6wLJ8GLEYKB5/4v6Ar6hC72gJfbf7VFCTrEvzlKou27JmBMYR/n+R4bSC/+O3C3YcKzrYuqre7BKDT36/KQjQJrz2sKz402ARG7pzZ855TzCsJulE2G6Qg4cys1M6e6qQwT2AnzlwopkRuIwkvUhHKwqI5vPRpU5BNnBVwEfBw24WUQWw7Zz2DqKp4if/u2INGczL2T0SNoyEDT0LZeHuGhA2rUCJvdSIPSYyY7iu+3l9pDVYrjOZRnHnrWAMSnEMTCmJETOOGfwn8oPcXhO4wNOJuoDG0oD1+xoOf/oJ4lgZHBTVmx7vW6rx6D1bJb2SIEYI8UXDaSzd9zm64pfItMzFlQxH/GBoQliXBtrg2o2PnDm+CVPamHTrW7G2Rc
 GTWRDYNy
 m/5b0BkWPteimrU8+h4MjRTnE+ikxx5iy+lT71t6Rp2Kk+J9l0W69IaYHYPeRk45NIgMTgq2xo6f06GJAMG+2nJ2RndJD1C0H8hKSYe4GThghKBsiMXil1AY3MmqjLRmW0Ulkvsefl7OBwkzC6eIEglGxrn5Bf0uYlGodU6lcMs0oKex8ycZBtN0dYQx7gZHbJMCwkqJxcIxZ5lB8hQdpohTzwczEGBRMPSfUa9F6BHn9t2PdtUXpjSXG9tYa5P9SrZTCmTjDjZFQzR266jw0HRuoORatuPe0b5X3HoYJE4qFfe5Csmbr12QrTt3sC8+PK9XBLJW3qJey9eUnWeYdy9NEAw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 30, 2025 at 3:30=E2=80=AFPM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
>
> On Wed, Jul 30, 2025 at 2:53=E2=80=AFPM Bartosz Golaszewski <brgl@bgdev.p=
l> wrote:
> > On Wed, Jul 30, 2025 at 2:50=E2=80=AFPM Andy Shevchenko
> > <andy.shevchenko@gmail.com> wrote:
> > > On Wed, Jul 30, 2025 at 11:54=E2=80=AFAM Bartosz Golaszewski <brgl@bg=
dev.pl> wrote:
> > > > On Thu, Jul 24, 2025 at 2:22=E2=80=AFPM Andy Shevchenko
> > > > <andy.shevchenko@gmail.com> wrote:
> > > > >
> > > > > >  struct pinfunction {
> > > > > >         const char *name;
> > > > > >         const char * const *groups;
> > > > > >         size_t ngroups;
> > > > > > +       unsigned long flags;
> > > > >
> > > > > Not sure we need this. If the function is GPIO, pin control alrea=
dy
> > > > > knows about this. The pin muxing has gpio request / release callb=
acks
> > > > > that change the state. Why do we need an additional flag(s)?
> > > >
> > > > I'm not following, how does the pin controller know that the functi=
on
> > > > is GPIO exactly, other than by the bit set in this field?
> > >
> > > AFAICS the gpio_owner !=3D NULL means that. No need to have a duplica=
te
> > > of this information.
> >
> > No, that's not at all what this series does... gpio_owner is the
> > consumer label of a pin used by the GPIOLIB framework. The flag I'm
> > introducing it telling the pinctrl core - before GPIOLIB is ever
> > involved - that *this pin can be requested as a GPIO by GPIOLIB*.
>
> The certain pin control driver may even not know about this. But even
> though the proposed change is an overkill. If it indeed needs to be
> done, the solution of valid_mask approach sounds to me much better. It
> will be a single bitmask per pin control to tell this.
>
> > It's
> > the other way around - without knowing this, for strict pinmuxers,
> > GPIOLIB would never be able to request this pin if it was muxed to a
> > function (even if the function is called "GPIO").
>
> I need to read the series again, but I truly believe we don't need
> this new field in the struct pinfunction.
>

Without a code example, I can't tell what you're imagining but let me
give some more context: the flags field could only exist in the
qualcomm drivers but the problem will be the same on all existing
platforms so IMO it's better to centralize it right away. And if we're
already centralizing it, let's make it future proof by making it
possible to define more such flags if we need it. Since the GPIO
category is a function property, it only makes sense to put it in the
structure defining the function.

Bartosz

