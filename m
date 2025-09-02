Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1054CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 17:38:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 276998E0006; Tue,  2 Sep 2025 13:38:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 227298E0003; Tue,  2 Sep 2025 13:38:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 116198E0006; Tue,  2 Sep 2025 13:38:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F13268E0003
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:38:15 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A90311A0217
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 17:38:15 +0000 (UTC)
X-FDA: 83845018950.25.88AC0CC
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf30.hostedemail.com (Postfix) with ESMTP id 67A0C80007
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 17:38:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b="XNB/l7r4"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756834693; a=rsa-sha256;
	cv=none;
	b=03s93dRVG6b5cpI6oHz8F9dHPTw29LoVlxYDNTmdju6dEipmXbE1Tm1qlXfPlT1tYvShuI
	MAGsEQMIR7PcEirYyto78SPBFdWDbHsrH/QhUq0+dMvl8pXe1SeQoXwXiER406zecMuWb4
	GnK9KHke5TaR4/7Ucoiug+qp21JgFjk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b="XNB/l7r4";
	dmarc=none;
	spf=none (imf30.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.167.50) smtp.mailfrom=brgl@bgdev.pl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756834693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nMdZlkimpPBEuPAWoTrzN+8f/yVdz1IgzbjTh40gfDQ=;
	b=4sH+k/PuXG6H60wCP6supn+BqEGrThh4j99xpNgzC/hC0WFtwx18fW+RE2S1BCwmNR5nsc
	zspZL7ab7sBbB0bRta4aR7o9wMYWmmN5CtpgKQk/FifVFUlw2pZbsFf2ktjIAmx5BdD5q0
	V1wigzyIHGPiEdK4JWB6KKqSBRnq3yE=
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-55f7b6e4145so2229324e87.1
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 10:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1756834691; x=1757439491; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nMdZlkimpPBEuPAWoTrzN+8f/yVdz1IgzbjTh40gfDQ=;
        b=XNB/l7r4nMDsDkGMP3lKzXMtgefC9HTyG5V/XoigRXroQRefM7G60oC0+EO5lzGXwn
         u8UlmGGjnZYxPqByu+jXiPWbvPdQxrCHSHkFF45Id75hMKW7KbQjderEcFy2XNAXBkpK
         mjK7dYrhgNRPjUq673J5rMDRLpwt3CFS3sst4D+rcko1DwDy0w0RkiXR+YneI8fPvch8
         iippCR0A1mKwM73DzoVqq+dshtH91IkHsBMM2faxztQVy/DCDGySsQ/G6zuo5o+oqztL
         5CafOB0vzl2CDBIqSIvOk2kl92HXV55i7y6ZUX55bwB4cG5le0TGr8Kd/Uhk69Pr3xBH
         E0Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756834691; x=1757439491;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nMdZlkimpPBEuPAWoTrzN+8f/yVdz1IgzbjTh40gfDQ=;
        b=j/auKBvzdBdHd5ecTia0SpleOG25p1TSl2QdArZ6imikUHZJVQfM0wCloDLtd/2u0j
         fEBRfgXa/90P2NSFwsrUGWuazTFeB06psJPJJs7XNjDOsZNZypLFpvozQTnk5OVrqCc0
         4t86VBtUgeU4R/qgo1cPTfH80mttaHC2+hmlJvSMzMgMKXp4HI+23mv3f0s797QdkSlm
         rvzKyUBdrVmKqUYnM+RgrpaDxfUEJhzsakhGs9ot4IB5j3rpA9rS0MZamI1o5aBGWNsq
         zaS8n+WmHLzjODk8kXgn9tECQwDTcXlJ0Be3m7PFLwJn5LuSDRhoxyNCGxB6So9BhsV0
         W+IQ==
X-Forwarded-Encrypted: i=1; AJvYcCU2gkm/BiGwZqiN8OgTwFK7yMid32WoQ5RvG/Pasls6TS60DMELYcvvs4LA6F6rau/yhrVC65mSkw==@kvack.org
X-Gm-Message-State: AOJu0YzsKkpOkVLzKEIfD1YYRMxGCzeZKsDBWTBNKF6NQ5hwJOvybeDq
	5NHwOh6MS8jkn3FvbZPtBP6wya9aO8kEp3VKZam1iwEKp1dBrfKVqv+Pp4bYmcN5mgtHdPOwQSX
	luymxj+PovL3feRasopM2Tkp6eSn7AU9atujtDtwEzg==
X-Gm-Gg: ASbGncuaGkxus1im00VG7gbEKGd4hbxQZ+ygmqmuDBL8VN9c1TbOL8KGy0yc4b1NA2H
	8Qa7j+Yd0kuEAmdKLXdLvBzYzALnJ0bCmgoEmCl1j6PmvPUUvrjFM6mfW2iuZTuFFC4vZcnVrBO
	/5XgDKjkSEmePgRl5+Wab1ebDvvifxohc0yKh/dqyzlVgueMuR0u0WYL3zpPJ2FFQrXCY4CPbKp
	3ju1dm+5juN+JQZNLInevZ/po52GQLPfo52VEQ=
X-Google-Smtp-Source: AGHT+IFm+23zbyZl8sFvNScDe+I2YeYbDYPXFeVHpq8D0bnsdMaG/KEVvVZ9a/rq1R21K2fB6GO+UcDGweplkB3yAgc=
X-Received: by 2002:a05:6512:b01:b0:55f:6cbd:fc0f with SMTP id
 2adb3069b0e04-55f70566bf2mr4012228e87.0.1756834691121; Tue, 02 Sep 2025
 10:38:11 -0700 (PDT)
MIME-Version: 1.0
References: <20250902-pinctrl-gpio-pinfuncs-v7-0-bb091daedc52@linaro.org> <aLcDP36eEIZ_tqFv@smile.fi.intel.com>
In-Reply-To: <aLcDP36eEIZ_tqFv@smile.fi.intel.com>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 2 Sep 2025 19:37:59 +0200
X-Gm-Features: Ac12FXyPcmhwrJUG952loM2GHhwbaAf9Pg-CA5a2iq5iRb4akDGioSRihDizLT0
Message-ID: <CAMRc=McSpciZCCzhSRwDqUw-7qiqqQqNAqngSm5mGNefWBJinA@mail.gmail.com>
Subject: Re: [PATCH v7 00/16] pinctrl: introduce the concept of a GPIO pin
 function category
To: Andy Shevchenko <andriy.shevchenko@intel.com>
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
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Neil Armstrong <neil.armstrong@linaro.org>, 
	Mark Brown <broonie@kernel.org>, linux-gpio@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mediatek@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-mips@vger.kernel.org, linux-hardening@vger.kernel.org, 
	linux-mm@kvack.org, imx@lists.linux.dev, linux-omap@vger.kernel.org, 
	linux-renesas-soc@vger.kernel.org, 
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, stable@vger.kernel.org, 
	Chen-Yu Tsai <wenst@chromium.org>, Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 67A0C80007
X-Stat-Signature: ut7n579impf8j4jb69r3m5qwcf3qk89u
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756834693-852546
X-HE-Meta: U2FsdGVkX19TRTIY0FGXS3DmoAfhc66jQ091Tb9BfsSlgiTkFxht6NP/9qPAILCnqjbX0oeBEtrm3/75AhNYjp0K6OKppn/3HnAGq37wZW8ueQqQrumY/ApfhsEqdfoRBIpfVR9kOJLSLoTJrtXNAtj6NrSA8CTglQmy66diMM8IN5ElvjF7C+mxQpcBdt7iuHed9DYMUC6K05IkNr69QVDFxb2eVMs227y6EFCCyfRr3mo2Ysc7u7DtB3zIjl6AL1/f5iabwx8Fk58taIteNOGv3AQLV2OONSPrEOcg6gbqBZtNGVpTwwbLgssvSC8A713A6noBlzPm01qpo+3tIfxxn6DR8dcbr0ADEqxCLmEmFtNl/h6YnbSMBGTfraaWBhYvPq4T2mqQvsC5qr88psIJsONrN0UTb6byFDAFTARSOUQyqbPmwgHupWcCinfm8dVqZ+NDLL6Xy/xzxWXNbWvaOQaoGrVY9GnGil1U4qqWrGqPex5ZljRrxDg9MgHWAPqTLyLvw37m7JYWzl/JdMQ2JavhqwkZ5tkt31lA4h4gGpeJboczmoL/HttpVVAR+6OhPPzTe2U9ECpgK+MNQWSwJTT7R0ZBSWgpv7XsaCEXWkjAkucdZYIm6XQHao4CbTVt3dNx2Mwk88j/Wu3AzPB3X+pz1Ezl6LzpIjKtvymmf10TwA/OxFlAWSHeudWi1LnhbVTZSebReLQ7ikYeMOKD52q+aStgydhFBsRrWCKBxPuh+opsa9dd3wRlB3HLwakc6LVDSZTzAibLsw8q8ewAbw31TyFxtSM+8Gz+lFl9mPS+t7eT3AzsPPJRSiRiLo9KDnzhxZNxOhqUykIuAIpN1hBf0iTxuBgxNDEO4UaGO6iPxvwqzA8urwsOuZdGo9vKIHmAt+031IsEoI7q4GLPrC49RFh2I2isZwlxU9EUw5FQOOnnxdId1TK76HmHKjdvnLooL0ZzHKamUHS
 AZavdOET
 ObJGdzJWKS+htouCBv6jDVuveb1hCMikFkt+/3Nnn2F6hlrVZz6ubLdBSuo1clo5Ox8WkgtQKwfuUynbHZGHApeRvJtsi7Hoh1O2s1S/yj0jDXHhC0FkE9mS3WKF4kLgBVhgvsxYGUm4g8hKUUFIuoa/wLJCgY+KmMgZVR0liXv+vd5RuwM4ZJqglg/hRMw06m5CA3F9M9QV3ZKRK33B8Qx4WZPURmnJygzKxXDlgIlaf+M3Bzuppzs7/6QBRskLMLtTPdo4f4tpOcJ0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 2, 2025 at 4:46=E2=80=AFPM Andy Shevchenko
<andriy.shevchenko@intel.com> wrote:
>
> On Tue, Sep 02, 2025 at 01:59:09PM +0200, Bartosz Golaszewski wrote:
> > Problem: when pinctrl core binds pins to a consumer device and the
> > pinmux ops of the underlying driver are marked as strict, the pin in
> > question can no longer be requested as a GPIO using the GPIO descriptor
> > API. It will result in the following error:
> >
> > [    5.095688] sc8280xp-tlmm f100000.pinctrl: pin GPIO_25 already reque=
sted by regulator-edp-3p3; cannot claim for f100000.pinctrl:570
> > [    5.107822] sc8280xp-tlmm f100000.pinctrl: error -EINVAL: pin-25 (f1=
00000.pinctrl:570)
> >
> > This typically makes sense except when the pins are muxed to a function
> > that actually says "GPIO". Of course, the function name is just a strin=
g
> > so it has no meaning to the pinctrl subsystem.
> >
> > We have many Qualcomm SoCs (and I can imagine it's a common pattern in
> > other platforms as well) where we mux a pin to "gpio" function using th=
e
> > `pinctrl-X` property in order to configure bias or drive-strength and
> > then access it using the gpiod API. This makes it impossible to mark th=
e
> > pin controller module as "strict".
> >
> > This series proposes to introduce a concept of a sub-category of
> > pinfunctions: GPIO functions where the above is not true and the pin
> > muxed as a GPIO can still be accessed via the GPIO consumer API even fo=
r
> > strict pinmuxers.
> >
> > To that end: we first clean up the drivers that use struct function_des=
c
> > and make them use the smaller struct pinfunction instead - which is the
> > correct structure for drivers to describe their pin functions with. We
> > also rework pinmux core to not duplicate memory used to store the
> > pinfunctions unless they're allocated dynamically.
> >
> > First: provide the kmemdup_const() helper which only duplicates memory
> > if it's not in the .rodata section. Then rework all pinctrl drivers tha=
t
> > instantiate objects of type struct function_desc as they should only be
> > created by pinmux core. Next constify the return value of the accessor
> > used to expose these structures to users and finally convert the
> > pinfunction object within struct function_desc to a pointer and use
> > kmemdup_const() to assign it. With this done proceed to add
> > infrastructure for the GPIO pin function category and use it in Qualcom=
m
> > drivers. At the very end: make the Qualcomm pinmuxer strict.
>
> I read all this and do not understand why we take all this way,
> Esp. see my Q in patch 16. Can we rather limit this to the controller
> driver to decide and have it handle all the possible configurations,
> muxing, etc?
>
> I think what we are trying to do here is to delegate part of the
> driver's work pin mux / pin control core. While it sounds like right
> direction the implementation (design wise) seems to me unscalable.
>
> In any case first 12 patch (in case they are not regressing) are good
> to go as soon as they can. I like the part of constification.
>

I'm not sure how to rephrase it. Strict pinmuxers are already a thing,
but on many platforms it's impossible to use them BECAUSE pinctrl
doesn't care about what a function does semantically. It just so
happens that some functions are GPIOs and as such can also be used by
GPIOLIB. Except that if the pinmuxer is "strict", any gpiod_get() call
will fail BECAUSE pinctrl does not know that a function called "gpio"
is actually a GPIO and will say NO if anything tries to request a
muxed pin. This (the function name) is just a string, it could as well
be called "andy" for all pinctrl cares. This is why we're doing it at
the pinctrl core level - because it will benefit many other platforms
as Linus mentioned elsewhere - he has some other platforms lined up
for a similar conversion. And also because it cannot be done at the
driver level at the moment, it's the pinctrl core that says "NO" to
GPIOLIB. I think you missed the entire point of this series.

Bartosz

