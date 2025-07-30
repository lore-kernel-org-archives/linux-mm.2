Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EE2BC83F26
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 13:30:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC01D6B0089; Wed, 30 Jul 2025 09:30:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C70EB6B0092; Wed, 30 Jul 2025 09:30:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B86BC6B0095; Wed, 30 Jul 2025 09:30:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A8B6F6B0089
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 09:30:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 59B651A044F
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 13:30:46 +0000 (UTC)
X-FDA: 83721016092.04.B288935
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf05.hostedemail.com (Postfix) with ESMTP id 58225100019
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 13:30:44 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="C/xFPabi";
	spf=pass (imf05.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753882244; a=rsa-sha256;
	cv=none;
	b=W+ARj0xL6aUmjF5VfaZryi3B1fiz/zkOKeXftsSCn7uAwGscXUH6q/M09qdv00qYBAzvMu
	PKL1iYB/ce/Of9WoS/TuhGIAjG4m+tjYHm8jK05p6xWwu7ut1R3ivJU7rICARPFfwxCCxa
	ocZB/94mxTJLZ3Uil9x4yjCaQ/CStBE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="C/xFPabi";
	spf=pass (imf05.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753882244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qi9l6TBdgjaQnQAqpjO6D0pjlwGQDGt3b3+CN6Y3/yI=;
	b=XF5ds0LuMz2PKginxhRfRBI9hJyQhi1VPfIVfHTronqBTQDv84GUWCgN+/4+iDPAPzWDwc
	1W9D1z21QAV3myeL9ym23TYlsyAvfjnUYckh/lfvR/lLPcNscvTdn2x2bq7CmfKbCwL5N8
	NamWBLmpCOnM07W0oQA7q/YrF57WMus=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-ae36dc91dc7so1160069466b.2
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 06:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753882243; x=1754487043; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qi9l6TBdgjaQnQAqpjO6D0pjlwGQDGt3b3+CN6Y3/yI=;
        b=C/xFPabitY+wiwpApgXS+KOo4lu6YCvlEWcxFM2x1EbKKO9uPCHwUsWWShBA3O50V/
         zLIuon53inR+QsZM2Rraxue0pklfJuBhceuW/l7uqk5CgaBns9iBZAoYnA+/ivCmioEG
         Y+JVhbQ12xjEpmwHWu3wCSAQw74SSYq7QLujvkWVEQbnMckn+YEtPDkQBcy0CaeEoG3u
         2SseOj5zjlqlZfHcAi9duCFH6aFLtdUkW+lcBTwQQlBi3kQIMq6gqhDOBMOMG6MQ0l22
         K7tHFVMh7XDsw0g58K2T+I9za5nJ/F9DzTNmiWA+m02RCvNv5pNA7VzY/+L03ez2p9Ro
         FrvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753882243; x=1754487043;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qi9l6TBdgjaQnQAqpjO6D0pjlwGQDGt3b3+CN6Y3/yI=;
        b=q0e23PgNgzjWMXhmnZdyVnTBxLqVQCNK7j/OTKzsounPQp5SSm7+q6XuLAhqz/N0GI
         gu1pOFTx6OTO6cSXH1dmMU7TU7mEypaXsS16PU+YnXJ+izdTaEEI/Eg3rTtnRoBqRX5l
         7JVISUeU0sNNJ4Y4a8YznzukbUiaH/gfMtjkFWYUojdBJ0p450O2g8/envFYKu6iTYKW
         xOGuJcNKX2X0qXSI6YIDKiZ2uv7JUlMD9GzntifEtkD65XvkEkaqWVHaMttanTshOQ1F
         oIzH67iDLiE7F3YDbBxVe41BaTP81aV55+19DTja1KfFpetlBikt92fwebcNYDccwSVJ
         b8vg==
X-Forwarded-Encrypted: i=1; AJvYcCVDMzYzlcgsrCg9u1jv9D70NJwPD9n1JYWQfMLt+m6pt3rSKkYy1zFYBpo3odJzyffI+7ip3K5Rbw==@kvack.org
X-Gm-Message-State: AOJu0YwT56m8eGSgJUEpqg2MrDPscraw+1GCwioMnvfSwuLC9WHUX9Xg
	dshgqiosrXfy5BL92/FcB0XT4nzFSa09+UFpcnTSO23fOX6RHsluOVySg1VT6vzW7nMoofw0NwK
	i+t/cJ4VnLqbnrjcVbnOevtTn5GcKniI=
X-Gm-Gg: ASbGnctZtAeKbVX9n4NGqpKYDcdKSU6QOpQVc9z9Zec6+ou18u3D2ysAlPj6GmqP/8H
	+kVaRwtJoGRzT9L+ttKLYEsppnXCMZiDtStr/rK7JUDE4U4lANvvKguigDy0cLMQ4bYVPQj2rzR
	g56zCH2PVyX/I/POGnY1YrAgGNTXuZrT6792ec214ot1Zh3DvKopQumkkLpJdMNd24xPpBIIwn/
	5/a+zacoG/HT+u7LWeL
X-Google-Smtp-Source: AGHT+IE7FH6m4Dj0jSn6Xv2SOxyVdUI56jx+oEPv/YLtr96ycR8jtmVTuCl5DRsdQyIzWn8vHcnXCm+w9rLeyqQEmTc=
X-Received: by 2002:a17:907:dab:b0:ae3:60fb:1b3b with SMTP id
 a640c23a62f3a-af8fda93d6emr386293566b.58.1753882242487; Wed, 30 Jul 2025
 06:30:42 -0700 (PDT)
MIME-Version: 1.0
References: <20250724-pinctrl-gpio-pinfuncs-v3-0-af4db9302de4@linaro.org>
 <20250724-pinctrl-gpio-pinfuncs-v3-12-af4db9302de4@linaro.org>
 <CAHp75Vc4vsJh_-GbP+YO50veoGoGtfAPL4tjcF+73uophfmnGw@mail.gmail.com>
 <CAMRc=Mc1ophkofB6MmtD4adBAi69C3JyovM-S9YD_y7UA3V1qA@mail.gmail.com>
 <CAHp75VcV=K-DfOGs0z64==nO+wQNoEB2Ngd2vc+dLYr3WLChjg@mail.gmail.com> <CAMRc=MeVOEFkdqf+SwQ-a=7ZPvpoerb4G_kn-aZgNLR3aTTUog@mail.gmail.com>
In-Reply-To: <CAMRc=MeVOEFkdqf+SwQ-a=7ZPvpoerb4G_kn-aZgNLR3aTTUog@mail.gmail.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Wed, 30 Jul 2025 15:30:04 +0200
X-Gm-Features: Ac12FXyFKinLiyKOfaCHk8Jvp-MCK0UJT4pw-WeZSCiJVFAceB4TVkbq9UOtwlo
Message-ID: <CAHp75Vd_5HVwzuiV17XKkzpEvzd8dzPDRRx5w-VqZnjuCz6m6A@mail.gmail.com>
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 58225100019
X-Stat-Signature: h81154ofmzj4rcmk4tuufganwmscjbj6
X-HE-Tag: 1753882244-176720
X-HE-Meta: U2FsdGVkX1+VWy2dKkON9Ho4sBfVkljZG0xrPDhomq6dqJZsWH3lJTRisUUQ8bojdHO3M4AOkQkHdG3XTd0UfoJy2D0yNoIFlAwfaxUBBiuZpPYoUi1tpZDAc/USQ2alvikaI3Cq4Bak1lqt9nlOY2ZG3YbysenWW3jkVOSgVDF8OjNtlhBIq2ly5TA1ENW6H3Hm95AXLoZNmgHby60s6pQF5ywKypc+CwtSN9DWQca8zu7QzHjGO2KTRSsMAz7UWjlb+zG48chLuYZoQBbNajCTW60GED1LEXT4LLjDek5EA+WtgCxr5bjq1F7e0qIF8/33S8WXQPDcmyrDPfPlrvc/S+ojE6cOiL24rW6PVVFl+ktnPeZeHIDiN6L4QOeZRt2R9yO4QnejzC9riMa4msbhZADw5hYVgBVYNQ+nJe54yVnamf54wQ507hE9kz6QUouXkIGIh5Y2CisQlRdj3eQwMDRqBi+HRzvOz2ZplWHHreyZhTSGSNx00yhTNcWkpaEbWfnrKSjxh8kpyUHAOd8HLecvvVh1xkLcqpczY7FtiyaZdw+222KQoFDPgZieiKdrdk8hY0NpceCYXsIsCQAYHwZQEJn+kH94IDjhJ/CEDUMlEMkmMzcXIh3kGlc38Of0CFPyjVNgollOMGfgeuW7yuD2XQQd7Oi0MKRlI+tMLaePxEHwo5iTRwhoyWobdQRaMjxQJ+zmaVas70cz1IhyNfm+FgJFeZEzpPBg+RRFAZPNJG+/kkZQTWbO5CltUdR/I9U13/u9mezgIk7AFD95IFKJe2I39H+5h044xxgigNTPiHOMut2NtWknKLSrWKz1hvWG6VhjEyiHcfVWRgXe1O6Hj40q8Xuk+yWbNCoIGP+IsRAtwbwK3Rdz7zruSDvnGZyvKevOZanKjYtqNsS/DcSmtPuEjJgMRrfvKfRuYnWIQSPCg2PKve4+DZgtiVAD05fmFPo4v1CfGmL
 xFCUA8iN
 tsAusoZEJNSyUVEXbWF37nzRwADo/CmRCqN6gnCqm8cP9VCnNgfX/ATZJkggwbwq9q/AwHepOVXBUC0pGXhpLVBo74Qp865FM60WDe8UWLeinjjwmLfW9uiQ+U1TRpIalMOZnaK3yfOU7KXMkRcOHqFGEnfE8ouPmXV1cEa+Sj7v8WmbIYzxn8CtIbIY3ik9aX8QqQdIuBI3smGvGWEU/sm8cMMQv0osP4wNv8JFuzj1clCOsRa3mphZe0z/avpvsYHz8kvoF8GYmC0018QEwIDqSZKpPQVktV2aMiwz0s3MLdWQYR4cJnsZA0rdv7dZ/TiiE2kyQgV6SnyZZjk8PuQqYZ5kFsFo5c60WZE59wKnSGcfj/wE0Rp+/7+C5eJa7YNPUMCSgmoxARncVLPBXVJjT57E8b23FVS3UM29PUBmFejZyFOB78xguKWNZQEgcGesCjFUOqAEpbNmRsDwhbp9Y+4ropE3wgt4ifAULLa8FU3sg/BWLw9UrKNJWPP1dpt129Nt7qeRN/VRQ5YGEpqeycQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 30, 2025 at 2:53=E2=80=AFPM Bartosz Golaszewski <brgl@bgdev.pl>=
 wrote:
> On Wed, Jul 30, 2025 at 2:50=E2=80=AFPM Andy Shevchenko
> <andy.shevchenko@gmail.com> wrote:
> > On Wed, Jul 30, 2025 at 11:54=E2=80=AFAM Bartosz Golaszewski <brgl@bgde=
v.pl> wrote:
> > > On Thu, Jul 24, 2025 at 2:22=E2=80=AFPM Andy Shevchenko
> > > <andy.shevchenko@gmail.com> wrote:
> > > >
> > > > >  struct pinfunction {
> > > > >         const char *name;
> > > > >         const char * const *groups;
> > > > >         size_t ngroups;
> > > > > +       unsigned long flags;
> > > >
> > > > Not sure we need this. If the function is GPIO, pin control already
> > > > knows about this. The pin muxing has gpio request / release callbac=
ks
> > > > that change the state. Why do we need an additional flag(s)?
> > >
> > > I'm not following, how does the pin controller know that the function
> > > is GPIO exactly, other than by the bit set in this field?
> >
> > AFAICS the gpio_owner !=3D NULL means that. No need to have a duplicate
> > of this information.
>
> No, that's not at all what this series does... gpio_owner is the
> consumer label of a pin used by the GPIOLIB framework. The flag I'm
> introducing it telling the pinctrl core - before GPIOLIB is ever
> involved - that *this pin can be requested as a GPIO by GPIOLIB*.

The certain pin control driver may even not know about this. But even
though the proposed change is an overkill. If it indeed needs to be
done, the solution of valid_mask approach sounds to me much better. It
will be a single bitmask per pin control to tell this.

> It's
> the other way around - without knowing this, for strict pinmuxers,
> GPIOLIB would never be able to request this pin if it was muxed to a
> function (even if the function is called "GPIO").

I need to read the series again, but I truly believe we don't need
this new field in the struct pinfunction.



--=20
With Best Regards,
Andy Shevchenko

