Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2247CA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 11:05:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20CB78E0002; Wed,  3 Sep 2025 07:05:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E3E58E0001; Wed,  3 Sep 2025 07:05:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FA048E0002; Wed,  3 Sep 2025 07:05:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F3FE88E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 07:05:42 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 954211A05E6
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 11:05:42 +0000 (UTC)
X-FDA: 83847658524.05.FDDF77E
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9256BA0013
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 11:05:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=ogeHREFo
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756897540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TY99cVzo51RXHn+Vw+SAL0C6lDtANRsUUB+6t6UiVNI=;
	b=Yx2tW8ilm+hU6zNfdKoGqSuAzLJ7yyoC60FAxMy8xGKkgvd4uSTNqTY6RvdPn27ohTuJLC
	aCM/e3gwiC/y3KQxS0i9fNgzCInNbleYsqqJrTlpO9HkwcLIOWNZyX0wTUjJbgvPEssSd2
	dHHX+ZPPL5Oe61LPNdNmaKf4E3Af0G4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=ogeHREFo;
	spf=none (imf25.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.167.45) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756897540; a=rsa-sha256;
	cv=none;
	b=TVza6s5plIePBM0MVme20CXL38LOivv3OYfdg5J0cB/xD58kGgHwi8NV7vjyXR1rWM4dXu
	FdwLKdKzO7B/g2b8h/9oTHfj7B4pTmcpTD36YcS3Ss/kGegXUZVcq0/h7LAoIE+YVmfI2Q
	k1DlzuPNruOtflCV4lM/BIY/nlqkXtk=
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-55f6ad5146eso3936875e87.0
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 04:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1756897539; x=1757502339; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TY99cVzo51RXHn+Vw+SAL0C6lDtANRsUUB+6t6UiVNI=;
        b=ogeHREFo9aIsQkHhuL8bBc6mzm/oBkejWqVzlKMMmFo7fNfTwSBL/4aXJLnkM+3HaF
         JijZqj9XD7rrw6smi7PrcPuPJkrMCmaaWtnqgfwK224XnziNctPV6cOnqtRmm1s+n2st
         GvVdLFNz7pKTjpSn4DS2cHNBOs4e4I1HMuwjFa47EnKneusYGg1nhKYhnSTcD1Qn81Qd
         2Fwjo/nAiky9qeItiZ7q982ROZpfZm8hEHv7bKlr7skehpzRXYNiy+UnDN2vzSS4qmso
         RGK3UxUBC1eZ+FRqzmI/zXowWSOedV/KDuBVuGWnP8DMiGoqaab8VtYCqxrxZiG5bDIV
         k+UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756897539; x=1757502339;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TY99cVzo51RXHn+Vw+SAL0C6lDtANRsUUB+6t6UiVNI=;
        b=B0+deIYUzxv7UM0FDnm7pX/CnajQpNXyEriJUqIChfbr1LQfKDBkwst7jVEWL3IlOb
         HwtfjBIwgaGJ0C8LZHkprXNypR/1c5Nm6/lIovp5N6U0MTRE4WYoifiS8r5wdIkI1VI6
         FsiloxCBMBVPqilS99BJPmFsIi7vYe7pRCxGzdkwS2MLoScEYA5jQDJ5OGLwUGVByLux
         AYdB8omWp3L8crP67eHYHaYRAlb+1XoigbHrcDUJBZ8DMnfymUe4IXAhmLahP0T/ER6R
         7z0EdEh7V97B9hk0eckua8qMjbKAM69OalSw8EU26NbQMG2vbEXcfl2RzDvJjvmnRj++
         mD5g==
X-Forwarded-Encrypted: i=1; AJvYcCWwZ98VVgJYjhfd6df2FokB+BHnTK0oys5SKmrgsVLsgH1zYjabBjc73mctUcfnB+EBW3EIQtH84A==@kvack.org
X-Gm-Message-State: AOJu0YyaZu9aCS2AYKyAvK8JU2l6+9EBfkS3KA6iO8npli1jkhsrK1Bh
	y+/Ez/dH5Uwac9lFgY8/5tM2POJcyvU2sDEQLGGmsquBp3StpiZcmmABqvT2MJc7Se819aPUNeo
	vtjEtyaKLP25OtkksXs1AYC+t2K5ysgxlBz0B2EOgvg==
X-Gm-Gg: ASbGncuQlBqswZHPe+Lc79qMZQ5MCCHxY+QCdZ96c4FPKC4jjx3Rc/nxCZ8Z4D9K+16
	FcQ9/tQh20E7af/0SlhYbHj6WoPW50A/2DD9n0MEGvfDyb7iX08uKcRsK1ttBJpeG4qFN8PajFx
	WUAG7NOOVuNNioAE+GjKfa/h0sJLRyjB5/6uGbYFooz3cKOb9gcDiuQqsWwTKeiSEAhMhTbg842
	/1lWtNLbwPq4Oz2g3qD9oQ9FtH/6SMPwbLSX0hGs5ANHYYbyQ==
X-Google-Smtp-Source: AGHT+IGaO6jKgae4Bb0nnUY/KIMNPM9fcQrt4rcPCJpxbytVdpNy16Q2X9IuotKVynxw9JndtWotWpVme+DKGbgxexI=
X-Received: by 2002:a05:6512:b8a:b0:55f:62f9:cad2 with SMTP id
 2adb3069b0e04-55f7093e564mr3786208e87.26.1756897538646; Wed, 03 Sep 2025
 04:05:38 -0700 (PDT)
MIME-Version: 1.0
References: <20250902-pinctrl-gpio-pinfuncs-v7-0-bb091daedc52@linaro.org>
 <20250902-pinctrl-gpio-pinfuncs-v7-16-bb091daedc52@linaro.org>
 <aLcBcjvMbrxoDYoC@smile.fi.intel.com> <CAMRc=MfcFMgkNqWNZV5o0NxkAvxBTjC3vv56Cr98n0R2CkxuPw@mail.gmail.com>
 <CAHp75VcgaqnDrPH27wxfgyK6zz4RAKJQB0r7G2vbTONTxkEzTw@mail.gmail.com>
 <CAMRc=MfhhX2NJ0fhhX8u+7=sdyUy0G27n7caGf9=TpHxUDJVxg@mail.gmail.com>
 <aLgW7J-j4nn0u8uo@smile.fi.intel.com> <CAMRc=MdA21fwnamymG6YhqBjKDso_nJs_4xefPNONQNfEcPHXA@mail.gmail.com>
 <aLgaoivmBUgoeO6B@smile.fi.intel.com> <CAMRc=Me84OX=UEmAXxmwE8oOH=1UBsyHe-7XmU0c8a2gG9JnCA@mail.gmail.com>
 <aLgeDNLABpmkShIU@smile.fi.intel.com>
In-Reply-To: <aLgeDNLABpmkShIU@smile.fi.intel.com>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Wed, 3 Sep 2025 13:05:27 +0200
X-Gm-Features: Ac12FXyayAu5ynqkVYj2uRlegQC_XlF19483EKV3MWs-LYc9T7mcvfMXmn9zXkQ
Message-ID: <CAMRc=MdD9g4WiBCP0qYGuy5e3pnQf5MUHTqkUOnrUvcWUYK27A@mail.gmail.com>
Subject: Re: [PATCH v7 16/16] pinctrl: qcom: make the pinmuxing strict
To: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>, Linus Walleij <linus.walleij@linaro.org>, 
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
X-Stat-Signature: hnyixzzpbx6np4oixbczc1sx8reeceqm
X-Rspam-User: 
X-Rspamd-Queue-Id: 9256BA0013
X-Rspamd-Server: rspam01
X-HE-Tag: 1756897540-480607
X-HE-Meta: U2FsdGVkX1+iz9+I1bxMQaqjnlcwHwCT9vpAhRXAfpwbho9QWmaugY3cuh1ZAr/pIM2imcaliezO9HOOmmXA1qrdfv8w6miIicubv+7uTYgQaGHnJrfNwLEKQRseFYktxObNYqmL8BCnIiNOmTJp62QLcqZJ9WXSqTZ4B4jZ3P4l40YanPRWx0NqHXNQrtdgC3y8q92wJIwn1Nf4xfMbK7cT4hpZ6ti10cOZwmA+yCyJ54zNH2NNhqL4PE3HrqMd6vjnKPWkK84OUgGllsM2ZPOUSEourVJc9Ruvh4ND3gIdb78MWTYWCCoUEqcipCejyQxjUl4eTVEIYajHlKF9NuoiIi8+C0N6eVehYPAOvTs/mjlHh3bPAFvIXZS4ZU+SZV7z+KMyX5FG3xoUdVvV525L2hdA7Cr4wJ5XBzSCBZ0856Dbf8mMkuAd+14X2xlOqBgvGPZY+5+z0FpPHAwWgjU2HAqehjWvvglxWwn5FsuQKA/khnZIFvfs+bNp4sVOiKie1ef+q2QeNobby432UAuLRysODncEU4Jgv5O+PmRG2wVl3yoCVbX7GOLgZnkgUbH3mbWLj0mUyc5r9xGVMwQK2TvpwG54tO5nX2KCdOp79Wknah3QVoTiyuNEV1Uw8clwmGU4VC4fS7LmPqJGRS1an5Ghf4+sskDgtr2s4GkUH5g/Dkrn/fftTUbHrDDfAdi+wn0FvPsXt9JKnPB2tyUTxhwAC73LjOtPq3zCd+OX3+MczkhHsUfVlQZ1svJ5lL8eM6k8dLfK+h2kdPlw0v3AZZR8vF7qMMsCncT5kOtTt7dUkc9Svkbq+eUdn47skblLOEhEgB/n3aECwAMEC277bTTjF4YFJq5+3Nx+eNaUvszifYoHfAo+5tAW5JAVwHIR3yi7lBro1nsV76tzg9LQ0wAE4OHtPyhR1dm/TCCd5anlVTaDxBVUv4OpBLiCp/ny7kog+Yyj26fHTaS
 dZtxQA8y
 7lTTXFlcpJc85ritWbvFgPYgKzcUUp51ftMU8yroatM21JnyMjUKOZJDKnVYBRONCfDoN8uMlxjAZ7k0Lcx2HeQ9iYe8b+51aYLnJ0HNZsGVQAVugMXVvhsYT+8ZLRZCHaGUTJI8sYXvyM9QFj9XAYr1TmopXUG8lPmBUQRgpKQBvEUUwXJE2ooTKy4qHGdJ4yOk/H29ha8yztP8kpovcVuWdOlWxLtlsct8dqU5iJIrJV4Vb5kmkrfJNfiec1Yext8FnrGoxOW16I5dtYKHEyL/UiVP+Rrje+FuWM3kv3ckgzeNQKLBw2w2fwsiVDvSsPYlW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 3, 2025 at 12:53=E2=80=AFPM Andy Shevchenko
<andriy.shevchenko@intel.com> wrote:
>
> On Wed, Sep 03, 2025 at 12:41:48PM +0200, Bartosz Golaszewski wrote:
> > On Wed, Sep 3, 2025 at 12:38=E2=80=AFPM Andy Shevchenko
> > <andriy.shevchenko@intel.com> wrote:
> > > On Wed, Sep 03, 2025 at 12:34:00PM +0200, Bartosz Golaszewski wrote:
> > > > On Wed, Sep 3, 2025 at 12:22=E2=80=AFPM Andy Shevchenko
> > > > <andriy.shevchenko@intel.com> wrote:
> > > > > On Wed, Sep 03, 2025 at 09:33:34AM +0200, Bartosz Golaszewski wro=
te:
> > > > > > On Tue, Sep 2, 2025 at 10:46=E2=80=AFPM Andy Shevchenko
> > > > > > <andy.shevchenko@gmail.com> wrote:
> > > > > > > On Tue, Sep 2, 2025 at 8:42=E2=80=AFPM Bartosz Golaszewski <b=
rgl@bgdev.pl> wrote:
> > > > > > > > On Tue, Sep 2, 2025 at 4:38=E2=80=AFPM Andy Shevchenko
> > > > > > > > <andriy.shevchenko@intel.com> wrote:
> > > > > > > > > On Tue, Sep 02, 2025 at 01:59:25PM +0200, Bartosz Golasze=
wski wrote:
>
> ...
>
> > > > > > > > > > The strict flag in struct pinmux_ops disallows the usag=
e of the same pin
> > > > > > > > > > as a GPIO and for another function. Without it, a rouge=
 user-space
> > > > > > > > > > process with enough privileges (or even a buggy driver)=
 can request a
> > > > > > > > > > used pin as GPIO and drive it, potentially confusing de=
vices or even
> > > > > > > > > > crashing the system. Set it globally for all pinctrl-ms=
m users.
> > > > > > > > >
> > > > > > > > > How does this keep (or allow) I=C2=B2C generic recovery m=
echanism to work?
> > > > > >
> > > > > > Anyway, what is your point? I don't think it has any impact on =
this.
> > > > >
> > > > > If we have a group of pins that are marked as I=C2=B2C, and we wa=
nt to use recovery
> > > > > via GPIOs, would it be still possible to request as GPIO when con=
troller driver
> > > > > is in the strict mode?
> > > >
> > > > Yes, if you mark that function as a "GPIO" function in the pin
> > > > controller driver.
> > >
> > > How would it prevent from requesting from user space?
> >
> > It wouldn't, we don't discriminate between user-space and in-kernel
> > GPIO users. A function either is a GPIO or isn't. Can you point me to
> > the driver you're thinking about or is this a purely speculative
> > question?
>
> The recovery mechanism is in I=C2=B2C core and many drivers use that.
> I'm not aware of Qualcomm drivers in particular. But mechanism is
> in use in I=C2=B2C DesignWare which is distributed a lot among platforms,
> so using word 'purely' is incorrect, and word 'speculative' is a bit
> strong, but you can think of the issue coming later on when somebody
> does something like this.
>
> The same applies to the in-band wakeup UART mechanism.
>
> Which means that with this series we will relax it back anyway for
> the above mentioned cases.
>
> (Not sure, but SPI DesignWare requires programming SPI native chip select=
s even
>  if the GPIO is used for that, this might have also some implications, bu=
t here
>  it's for real 'purely speculative'.)
>

The high-level answer is: yes, a pin that will be used by GPIOLIB
needs the function it's muxed to, to be marked as "GPIOable" in its
parent pin controller if it's strict. That's still better than the
current situation.

I can imagine we could differentiate between in-kernel and user-space
users of GPIOs and then make it impossible for the latter to request
certain pins while they could still be requested in the kernel but
that's outside of the scope of this series.

I don't see why this would stop these patches though, as they don't
break anything unless you decide to make your pin controller strict in
which situation you'd need to verify which functions can GPIOs anyway.

Bartosz

