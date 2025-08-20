Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D166DCA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 09:59:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5921D6B00B1; Wed, 20 Aug 2025 05:59:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 542B46B00B6; Wed, 20 Aug 2025 05:59:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 431566B00B7; Wed, 20 Aug 2025 05:59:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2C55E6B00B1
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:59:42 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CEAE858FAD
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:59:41 +0000 (UTC)
X-FDA: 83796688962.30.8DD63B6
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0DF031A0002
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:59:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lMrU+tds;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755683980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pPSwHXJiuPboMvGmzdZl86YoheXT2JJemMGGCNbTXh4=;
	b=NJoE3uo7JcmD5jfaA9PHF3cKpt/+p/S2dYd8GtUVdsscbd/QBtFiZsr7dHZTkvLPYyrRdM
	dMKA/rrRTixZh9HY/HNFw5xKInj62yZC4Bdy8QdNTi9HhXQgzOGQUXOc/BpPcAfOKP2T/z
	/k1qdJ2+Yk5ktwRM/eXKM2EhePWnfGA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lMrU+tds;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755683980; a=rsa-sha256;
	cv=none;
	b=nT9fgjttcpx5yn9XHcNnySjUuxL/ndPWaKqSh3N105n8oXAjW3NOUXbbq31AIR1lZ3jLw+
	GYUDskqWNT7oBdWdhzpwQ2jxPlEFTfROD3FDZkrvYpXJ48M8voGagfFs/3dvCBf7gAOROy
	lDx36dFuhghhXG1Hv3FDrtnwjA+i3Ko=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-afcb72d5409so947738366b.0
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 02:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755683978; x=1756288778; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pPSwHXJiuPboMvGmzdZl86YoheXT2JJemMGGCNbTXh4=;
        b=lMrU+tds0HF48gbVqjdcSBuZ7CMolhLbc03+I5LHZYVD3oXqRv2NFKlqBhbaGdGeuT
         e6EvLotkXf2b0NGFQBOrBEzUnVFLmCwFch3HHCUMppuog+m6Z4hN2KUoKco4OeKBx/jO
         H9P7ycHVcpMPo2ddLt+slYZBF5dzEcltGMivempVYryL0KzuQ6Ch0WqAyfL69YrlTNuW
         hdt3usTtsyv4oD/wZwLtu8G0JXfkXz2svvxoFkLFQbie9MSkjudKoLQKWBRckUjMyGk6
         SaUBDGrajpzTABmi1fQxRHkTzfoFe2Tc/3Rkt8+LDKi1hX+v2WKlRf2O9q4RoKZqdO8m
         //ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755683978; x=1756288778;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pPSwHXJiuPboMvGmzdZl86YoheXT2JJemMGGCNbTXh4=;
        b=Uon2y6SP7OMOLbUHaoQ+ANn9pT7vmO6pH9k1D4Ylqs63DAzF93fco5X8fix4Y0HIlc
         CDjq575OENoxkWlZe4j/VxHcgWmDfo6Svk+Zu/NjDWJ2VStVuOd8ay0VntJvi2GPqxb1
         joA9MLMiTZhQ091YDQyUN7UtUXKIS4Lk6RTTX1krH1lKclzOVusvnBb7p+rj/2JEGmog
         N+bXkHoPcP/YJplgRoe386eC96c9XJpLF1xYaO9NnYgIneKjX+fwECHqkoMP5nO4VUaI
         mhuGicO/6YaeeJkaGmmY2k5VIZ0ZPIyXdOGUyykTGKjmhiusto+ODKgSa9lR0/LlPNEp
         ByGg==
X-Forwarded-Encrypted: i=1; AJvYcCWA8wDiloHnGbqFOFL9kP5Pbh+0yEEkvhn3Pw1tAAYDCCtnpIGtLnP0tKu2pjgq9me3U6Lw1APeeg==@kvack.org
X-Gm-Message-State: AOJu0YwCWF/fG2zF40E2tDCLbZE9ZL5fuDO2Mq61hpfTRKucKs3pVZRC
	VAHIlMvv2sSHsV5Jc3Dr0SfjEsCMzXG8wMOXCksxGK98qvJm31sO7tI75H0UWHBXvvhqDK3u6Yy
	/CgA3WAKH4GndEmpg1P1IgVI5xSup7e0=
X-Gm-Gg: ASbGncvWiF6zUHBOBdVjs16lf5yifHu4z2Ms54Qxi/fciN6VQ8IumGOp7QjRYwixhKZ
	Y6TGjOuH1FHvUvJdsSjgana72jdcz0Q9qMoWFEj42Rbb0RyJhWYE0WPG2OKSRcHDTk6t3AY5CfK
	yhNgkLjGcZMgQTG77h4rhU2i2sQlEFEPLxdBg1Hl66ywoI8LQQAwJC4Ek9AnEtQH+hlWo/6EBqw
	T3fyGXeow==
X-Google-Smtp-Source: AGHT+IFLILsumUxXGG8Le22U8VXLfiB3UImn/sKCUBHCwulcrWRoCPLLCjJAWxmPAx6D8QUNkGdtQmpTps7zJUlvWzY=
X-Received: by 2002:a17:906:fe01:b0:ae8:fd2d:44b8 with SMTP id
 a640c23a62f3a-afdf00e1d0amr167565066b.29.1755683978222; Wed, 20 Aug 2025
 02:59:38 -0700 (PDT)
MIME-Version: 1.0
References: <20250815-pinctrl-gpio-pinfuncs-v5-0-955de9fd91db@linaro.org>
 <CACRpkdaDGmdhaik+1saRv7Ts4myQ+tg1aQqGU3xQyT7ma8dJFw@mail.gmail.com>
 <CAHp75VephepLq61HrVy=PX2oKUQd5NK2qS-vOC5h_NR65td3Uw@mail.gmail.com> <CACRpkda4soRCLF5=W=6R4wnwT3pjk743j022XfJxjTTQzuarAA@mail.gmail.com>
In-Reply-To: <CACRpkda4soRCLF5=W=6R4wnwT3pjk743j022XfJxjTTQzuarAA@mail.gmail.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Wed, 20 Aug 2025 12:59:01 +0300
X-Gm-Features: Ac12FXycXziPzAbLNx1s7hMXfLqQ2mmNzJaOepqBGK1kK3uBfF-tyE-7OZscDUk
Message-ID: <CAHp75VfNhBrukJ46ahY77La5Ywkeu1xiC_eUbUj99ZQcderHbw@mail.gmail.com>
Subject: Re: [PATCH v5 00/15] pinctrl: introduce the concept of a GPIO pin
 function category
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Bartosz Golaszewski <brgl@bgdev.pl>, Bjorn Andersson <andersson@kernel.org>, 
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
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mediatek@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-mm@kvack.org, imx@lists.linux.dev, 
	linux-omap@vger.kernel.org, linux-renesas-soc@vger.kernel.org, 
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, Chen-Yu Tsai <wenst@chromium.org>, 
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0DF031A0002
X-Stat-Signature: 55y6gutsbcda5a4a6wdz98utnsysay4a
X-Rspam-User: 
X-HE-Tag: 1755683979-123487
X-HE-Meta: U2FsdGVkX1+vJPRNkoDUidZZKjXYZBz/zsOeNgltYo2uoIINyqyhSH7o/wlxiRroqMtiojJmW7h3neCwO2Ve/nQew72850WveVLzpiDgDmL/6LNRbxvzLLsnjr7kB0M4vnyaaoTonJRHFZom7oLyZvyavSQOGMPrao9GOYjeQBIlCtWuZ79d3DdIPtEzDU+7yQaQV40WCjOunr3k4d4ccwRScRZqAs7mb0B1ecq+9jxhfEEuzKuf9oujs972W76n3Kn5hOiEGxtSSNFeVnc+URza+CgQnREAfCndAsFbBi/ffuS/Z7SRAlTjBO7i15hCvmllAY/iJVs2eZWTfHkYSYznhlG+SJ6PCcz0SQhgzhf20hzlVbZq4USrYJSQQi3NmKi+XRc2nCp87dLyk9/JHdlz7tQG62Va/wkmvTuV6s39KzZtMt/8a1T+gIC2UTwLVpV/6RPJc1nulBMyzvj6SjsLeDCJG5TaRXKTZcyAuHnwv9JBlyzXIJbtagIBmPaEUVVPhjxIKGPkKetydz8gbHGJ/I9mEOtK2bG7/I3xHZb8FbuO1fDfnuJeM4fkrOYpkzLtz02wGkzq4D8tfuLyoATVKVwkGgovCV+qFCTy1ixXT8xDDjDKqK/3tv2FZIXAvQ7xQkFp7Me1cZANMM3TK/HPlNcWKutI/xSVVh9sHyBfMJSTIAfi0cDrV0qVETzq0nd66EPNUT0LXl06UYt39cFxCflCbfcBVJSfjuW8vi+XC2jyz9zwecQFnBKe9JNIsL/iR7s0vJ5jnwW9tBS/MMX0PeXQXNt55XVkJHyCWUiUgDEGWthHnP2S+mKA6yMO5fzBw0OwK6PHzujp8Vg6CI0kR+eR4faOPV3yrqfMuuW3sk/ZX8x6S0ONPGF1s8JN4zAwe3fB1Sleh3dSGuWOVgYd2yDRXzFxJ4Gkx78jiw+muGDEGyL8lyF8BLH7e5GzWF0FkIO9nrFJDncxfkC
 MRrr41Qa
 SeDSso2xXwaFTKSZnE8eHvwvmAyORyVuaps3up9eabwRnahKbs1FAUAOe47jaaRfdhKmmleUsbsL3uWv4q2/rkMrc6VRN7+RZE4rKLmRu5qwznVXkmS8CojmwjiCEUOSCGFvt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 20, 2025 at 10:13=E2=80=AFAM Linus Walleij <linus.walleij@linar=
o.org> wrote:
> On Tue, Aug 19, 2025 at 8:31=E2=80=AFPM Andy Shevchenko
> <andy.shevchenko@gmail.com> wrote:
> > On Tue, Aug 19, 2025 at 4:02=E2=80=AFPM Linus Walleij <linus.walleij@li=
naro.org> wrote:
> > > On Fri, Aug 15, 2025 at 11:09=E2=80=AFAM Bartosz Golaszewski <brgl@bg=
dev.pl> wrote:

...

> > > >       devres: provide devm_kmemdup_const()
> > > >       pinctrl: ingenic: use struct pinfunction instead of struct fu=
nction_desc
> > > >       pinctrl: airoha: replace struct function_desc with struct pin=
function
> > > >       pinctrl: mediatek: mt7988: use PINCTRL_PIN_FUNCTION()
> > > >       pinctrl: mediatek: moore: replace struct function_desc with s=
truct pinfunction
> > > >       pinctrl: imx: don't access the pin function radix tree direct=
ly
> > > >       pinctrl: keembay: release allocated memory in detach path
> > > >       pinctrl: keembay: use a dedicated structure for the pinfuncti=
on description
> > > >       pinctrl: constify pinmux_generic_get_function()

At least the above I'm pretty much okay with. Can you still have them
being applied?

> > > >       pinctrl: make struct pinfunction a pointer in struct function=
_desc
> > > >       pinctrl: qcom: use generic pin function helpers
> > > >       pinctrl: allow to mark pin functions as requestable GPIOs
> > >
> > > I applied these 12 patches as a starter so they can
> > > stabilize in linux-next.
> >
> > Hmm... I'm still sure that we don't need to have a separate flags
> > field, but since I am on vacation and will be able to look at this
> > closer next week, I can't look closer to it.
>
> The qualcomm 32bit platforms fail in next anyway so I dropped the patches
> for now.
>
> Both you and Bartosz are on vacation so let's let it rest for a week or t=
wo.

I will be available fully next week.

--=20
With Best Regards,
Andy Shevchenko

