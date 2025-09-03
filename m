Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4E73CA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 07:33:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16EF66B0007; Wed,  3 Sep 2025 03:33:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 145EF6B0008; Wed,  3 Sep 2025 03:33:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05B9A6B000C; Wed,  3 Sep 2025 03:33:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E75E26B0007
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 03:33:50 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8AF4EB9FCA
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 07:33:50 +0000 (UTC)
X-FDA: 83847124620.26.233F183
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6F9B818000A
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 07:33:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=F5PVmmm7
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756884828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YNYvzh/kc3+s5XJiH2jNySFaGPSj6mlg48FZqtmCTZw=;
	b=FanggV/IjBXqbL807CZRLalun963Vho2kYfSy+YtLbBRAyWQuROEfrFg8RaHdKEsO9W1zv
	jI6iwlZbHAZRnDVXT7ezsHfjnmKVW/snkt1peNfm9yDJgf96y05Woo93YfRGxVBXDSM6ks
	w3Lp+6O58cEKScB/wgoYDGtF3jQw/pU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=F5PVmmm7;
	spf=none (imf06.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.208.175) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756884828; a=rsa-sha256;
	cv=none;
	b=zBDzwEM7d0qIggCjPCCyZIqjC6wHYa5c/i2yBiOfLaYgfP5XOZuBcfdDfn0fzbSDRgC1Ku
	W8hNw/qCEK3DrpY6YIgfvyyHzf19xGpt8HwvnKTD2gsh7iIGAdwe9AXRDafxSvqAL+MiQP
	zpMnZZzy6xL3rVGLSqDB2mWK8pJc8dQ=
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-336e16f4729so23691731fa.1
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 00:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1756884826; x=1757489626; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YNYvzh/kc3+s5XJiH2jNySFaGPSj6mlg48FZqtmCTZw=;
        b=F5PVmmm7rlUQ2/GHaHl2ntrmI6EvIiypbgb2xVi9/FJ/9gDiQB0S1dwatSHxS7Xv6m
         k+6242F3dvaSEOj2cmcDZ5X0+WLSGa5KZBgvF/phzo+4Z198uOECLCE1DHCHPBtsX6pO
         WKz84AplhP6028Ygfhm3Pt6cC0PMxIsFsaCDkENdxT4q087rZQFXOJgWWlSq7hHAxP0a
         ijHNSzH4tYRH1kIw2FOB7DZDFNPtmP/lxrvWFyQphwxL22VG2Mbs8sWlt21eJ9LcmggJ
         yDg0dGNlWSDCtCMEu1RpNPARCnn4EbKjQKhdTLuN2aM/GihwsrzSiNi6qOInWUpOxpu+
         B9RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756884826; x=1757489626;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YNYvzh/kc3+s5XJiH2jNySFaGPSj6mlg48FZqtmCTZw=;
        b=REYsvSEnqws/RQct32oc3dv3L1zqyUKwWLgN6NQ8vmorvIWahA473QjI/k2vmvrF7m
         RMIPZJerfIuYpWmVxNr+A0Yh6om8fv0NHUjDu46g/y4iaCaVpRPmnkBnaDyZ2yOh2GAy
         gHJA1GFvxJFcBDwYa6ZHEovONt7J1orFZRlOHz2G3ABZXCc4nj4jobEn0Jju2+02MdHy
         DqsQ4AYKltTVFkbfR0fbP3z5A5f8yOV/9CABACNIT68vwv85JCuRGoFWuNAR9gUkO6tk
         Xtvrg5a7AWhq5ZtkgjmwrYLYloP3bldj+mBDkTlc12VdehQYTrC4Y/5VkcwKJJ5VHDdg
         Z18Q==
X-Forwarded-Encrypted: i=1; AJvYcCXH1vnLvcRBf3OZrvmDRbpMRUWvVftcyqZK6RgImkG5SFy5xiXUjb3DILsJuWYB9cThbtTPm2xqWw==@kvack.org
X-Gm-Message-State: AOJu0YxiS9+8z8QoBBqEP7K1oHBEsMKICFOPy5qXgN9keDwptGnrrQaP
	C6f6rjhGM71JFjtD5H4SXhKvrhLy0gYA3HRM2x54iTbmea6zEaVoQocYcvMBpCyzoa/TuwW19nx
	33BtptLhSyPMVOHlB2cpJoHZgQ15GkxEYahP9Y5V5Cw==
X-Gm-Gg: ASbGncv2dQW/2hNx/mbhqsOLONKIA+JFYRxZYOCC1zDu+QvbYd6TbKFLCN57NL9xqjG
	gqBWbxpfLY+VYGRmRN9OGainQUQYRY+0puHOP6DX8euRmpUj+qCnHFo4S/kZDeOhejyVkSkPpJA
	kaBLYSmNqpdn13ZjAU1MQhOVsjxoI9WYEb7fDo5Tj0BoBh8uys+hTARp9llJbqTeyLB5OAutVE5
	ZfWA/D39dRfuebe4U5OZ1/DVU6xyAaZNxh+AeUDagflSFd6Pg==
X-Google-Smtp-Source: AGHT+IHQMDojBvXdcYFr83Du1enPEHK0Ti//rRC94x6rK+6MbJgsPNbFLU1zOeSW5BOM5GJv9hHYWvwxYnse2nh/rU8=
X-Received: by 2002:a2e:a58a:0:b0:337:9e3b:895f with SMTP id
 38308e7fff4ca-3379e3b9b47mr24730131fa.0.1756884826262; Wed, 03 Sep 2025
 00:33:46 -0700 (PDT)
MIME-Version: 1.0
References: <20250902-pinctrl-gpio-pinfuncs-v7-0-bb091daedc52@linaro.org>
 <20250902-pinctrl-gpio-pinfuncs-v7-16-bb091daedc52@linaro.org>
 <aLcBcjvMbrxoDYoC@smile.fi.intel.com> <CAMRc=MfcFMgkNqWNZV5o0NxkAvxBTjC3vv56Cr98n0R2CkxuPw@mail.gmail.com>
 <CAHp75VcgaqnDrPH27wxfgyK6zz4RAKJQB0r7G2vbTONTxkEzTw@mail.gmail.com>
In-Reply-To: <CAHp75VcgaqnDrPH27wxfgyK6zz4RAKJQB0r7G2vbTONTxkEzTw@mail.gmail.com>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Wed, 3 Sep 2025 09:33:34 +0200
X-Gm-Features: Ac12FXwfTFesdkv2AsVGJLh1I6xBKdxxPYffotwRnf3CookQp3k-WXkxYMLzaTo
Message-ID: <CAMRc=MfhhX2NJ0fhhX8u+7=sdyUy0G27n7caGf9=TpHxUDJVxg@mail.gmail.com>
Subject: Re: [PATCH v7 16/16] pinctrl: qcom: make the pinmuxing strict
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@intel.com>, Linus Walleij <linus.walleij@linaro.org>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Alexey Klimov <alexey.klimov@linaro.org>, Lorenzo Bianconi <lorenzo@kernel.org>, 
	Sean Wang <sean.wang@kernel.org>, Matthias Brugger <matthias.bgg@gmail.com>, 
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
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, 
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6F9B818000A
X-Stat-Signature: ik7r5omixitpuhutawgijetmxq5nd3k7
X-Rspam-User: 
X-HE-Tag: 1756884828-998186
X-HE-Meta: U2FsdGVkX1/U/lkNDa7SQyl+MWxQHe32XiCqLlBBMLy+/7EL93k+IKhOqR0iSxxKYCVKMnuBRYL+/vkea8t03yJRVh31YYdJfWKV5HBIijQzgjx5Xns6QScrlyyYIntxHcxc4amjjBylDCr6YoE2n6qSCqV4HbxOHmD/3Yzhq4xoiXMHRs/8M1UpwaN3FTx/le+BUH8t1h4xGJE4b46d2MB+U+WoxMIw6DOtplPWVKFt6ZD+rdYgevp5s+e8ktZXQOvizYzMwme9exg44S/f4yEtgAx2DOq1vA39nUiebfGhK60/cCRJOv6pgvX/HGkfnhuAJGQ/f1yvfhmwZKzO5MTCx9/BGcbiLlS3A0ybJTzNDInFuvrrQ7tkO2/aTVwXXstlX3PtPUmd1TjJ/UVZsMJIOpnbFsyrk0WV6Q5hJklyEnF9cHlGR+jKTcQ5DhfKEMdEWd/raEaoSsaLFfzIR9EkWZ9zxavYhgpVp78M/Kum1TsD5UuAEh6XsmTH3ihrK7KBlXd0IYCESxoJk6NY2hHWi70TdXKZVV06pLNVF8rMniGMI1qkKRfWGcJxowezS2enSV6VAHOxURYwFPEp5wvEsnSNqYcdE9nofQ2X/pnsDAE0GA4Kl7lbw9ZYkOCJOkNyf9odWZEwhho+AFddNCKEDa1DP0dMHonVM7YEXmtuvEEmPNKbwm7YiopjS/DcSl2Vn8zjbIJYcJxK2/esLpDeGvGC2cxt4GXmWJ02XqE3d1d0xE0wtHKtZSQv+7Oc5BAEYtUQY1fcg/30pot9zZhSae6/l7giWjbyWF061z1NuRb/Y90wP8JzMAAEWnc5Uq1zuThmHhggUQBhGfmGpB3z5rWf7KP5V7sifccryxnAt04J44UYzr8iqmIq8UoICIZA76Y0Xh46JX0/+jROYC5U+JKW1Ol4dh0wVFJFlZnyqSXIlMTHwr9TPftIe1svjD3Q28SCzLd/cBMKXyw
 VQHROWZR
 D0MjKbZW/J15SMSlKyJQXQxw/Tx5b0+pQe19dVREUqZtsIAMZvIGbOb6we/s2q6sE0dMiC1zSpIrtuSXZwtqs9FM3FrIK6/wT2cxKmAvuguvDnw62Wqqj5qM2oTAX6QlzjEIlw+ZQpEE64heF0Ntznt8Cuikjyb0gmWLfyOTAjbu4tLercy7shhLPXuleuTZS46bhu48Wac9a3nGj2f3+fAZGdGx/D8tIFUXpBPR0HzfWJljqaAWjuwOFi5SZf3zkvx23p2K+VBa9K1Rmduh1WkDlX4RXcUEMPAdki/C/OwlE6xBlsX30IWH7/CzIdCWD1ySP1zSW7U2GEH6zAmxkhmzjv0UGJNxBg/5G8j2dtGPeUlRW1DPv+prC1R4XbRFA8D0gnjbTtqhWPG4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 2, 2025 at 10:46=E2=80=AFPM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
>
> On Tue, Sep 2, 2025 at 8:42=E2=80=AFPM Bartosz Golaszewski <brgl@bgdev.pl=
> wrote:
> >
> > On Tue, Sep 2, 2025 at 4:38=E2=80=AFPM Andy Shevchenko
> > <andriy.shevchenko@intel.com> wrote:
> > >
> > > On Tue, Sep 02, 2025 at 01:59:25PM +0200, Bartosz Golaszewski wrote:
> > > > From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> > > >
> > > > The strict flag in struct pinmux_ops disallows the usage of the sam=
e pin
> > > > as a GPIO and for another function. Without it, a rouge user-space
> > > > process with enough privileges (or even a buggy driver) can request=
 a
> > > > used pin as GPIO and drive it, potentially confusing devices or eve=
n
> > > > crashing the system. Set it globally for all pinctrl-msm users.
> > >
> > > How does this keep (or allow) I=E6=B6=8E generic recovery mechanism t=
o work?
> >
> > What even is the "generic recovery mechanism"? That's the first time
> > I'm hearing this name.
>
> "I=C2=B2C generic recovery mechanism" (I dunno why you put away the I=C2=
=B2C keyword).
>

For some reason it was displayed like that[1] in my client. I see it's
correct in lore though.

Anyway, what is your point? I don't think it has any impact on this.

Bartosz

[1] https://postimg.cc/7GFtxzzR

