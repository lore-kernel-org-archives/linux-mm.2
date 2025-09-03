Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53E51CA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 10:34:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DDCD8E0001; Wed,  3 Sep 2025 06:34:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B4D76B0008; Wed,  3 Sep 2025 06:34:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C9DF8E0001; Wed,  3 Sep 2025 06:34:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7CC6A6B0007
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 06:34:16 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 197DB11A4E3
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 10:34:16 +0000 (UTC)
X-FDA: 83847579312.22.804D5FC
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	by imf24.hostedemail.com (Postfix) with ESMTP id DC32018000D
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 10:34:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=dNiRcH+v
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756895654; a=rsa-sha256;
	cv=none;
	b=xqOqO0XORpIZ498DSONqHeHcEjFrqxtOWZwA33ph4SU63ZBxzaKyr39RSagiKV/ijLSi7U
	GS7sBJFJTFirCxMgtpwMMWc2BaSVNKYPm6/uPiasPOusktzAMX2GnWF+wUjT+rnzFTlRZ6
	fIJ4L95DA9EDZLokc94d4Ka9Xf0ZeDs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=dNiRcH+v;
	dmarc=none;
	spf=none (imf24.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.208.169) smtp.mailfrom=brgl@bgdev.pl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756895654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AVAB3SPxcLA6cClsIyttHLnupSB+I6SCJnu7WODswL8=;
	b=lUjCQBIDpFnNqUl9nhqHMvOsqmvzHybuEbEy9b7Q49fmVxvlIWpHQVn1Ih5y9dQ0rQvSuv
	LHNkASJmjdPm1j5i6gmAp9NFr2hQ8FcBYGxHEw4neQbOnxMm/vBNx9RgtldH+eFzAPoyAJ
	y/H2GUE5YryWscdIK/5MTInUleD1gdg=
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-336ce4a8bfcso27107881fa.0
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 03:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1756895652; x=1757500452; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AVAB3SPxcLA6cClsIyttHLnupSB+I6SCJnu7WODswL8=;
        b=dNiRcH+vsA3w9gFB6cX4xrCSGznjdrVXk5okocqTTVu8nEqb8lIYnjgwEgpv8KnsaB
         a3C0qkHmm+6T1kDaxyZ6NTcdt5gnj3IKKO39q8h1bT0O8FUPIPZdzA9VSGtDlc32+7Fk
         yLCwIz44F/yRrkq9seAhvC2MX+VXaOD9yHGrqyajzqAAR1R32w5TdPCIWVv7v6ov15uJ
         MevnNJsjoMJSZ8zLZDKaDIcAqRhYEA3WviyPkSxeoB8art97W3Tulg5wVVtQm/9KB2b+
         8h7DJ5NPJ6vM6Or0/zoRGcSAESelxyLAdJ5CwtKmjoZP42Fd3b6qGfBNGnjp7BVS0Dm3
         4njA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756895652; x=1757500452;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AVAB3SPxcLA6cClsIyttHLnupSB+I6SCJnu7WODswL8=;
        b=TJOzAIgpUczeU3LfzSzlu3LlVOeKtoJIeCBGL2+O24guM7BPnquw8/8zDLtOq8zde6
         2W6piHXC7Lz3rTNmPYuw+TrH5kTxYdmldw/Y2XT3tNbWLtyQZXINbHhtHN23DMXDPk01
         scMUWaDtFIotaUzmV7ZjZArFAgV3B1ectYhvUSYE+G8n2lQ2VF9qzFS4oUQHhxPAtDOT
         gMTquC8Qt0ccPiSerY0wPy30KzVP39VyJ0bk9nYjB5eKPjiG+LA0nxOIQqp5783Y/NBo
         on/FoXIMqBOyTh6swAcZ+W86anEiGNkUXuE9aacKQtl+SgyECBcxWMRRiuye5o0CLWbl
         gPJA==
X-Forwarded-Encrypted: i=1; AJvYcCXDFTmzfFPa8lq7GF8MtTDd05lQzhj925xMA5mYvfRzUaa3b2JHF4MV8/u80qfvMC8YCy4qCJx47A==@kvack.org
X-Gm-Message-State: AOJu0YwpcWbmzzpVW8HheIaZlnHNu5gZx3fu9QDqsLxBugDRyRj4eVGc
	wNSJxIZKFqEoXFG5HsYXLQ1T0ZYmRcBYCcLdwNWCqE5knBvy0lCCcb4ZodKyLzhvf61aO/SLD0N
	TY5sp0v9YcRmBLwAU+PJk8ZwKWdhjBQC7/XSeLR2gcg==
X-Gm-Gg: ASbGncvTRshQxzxQ/Lx8l6/wVub/igdih1vyDtZfBLYwTJUUAoKHtfzoNl+8k4TDtIG
	Nuy/CDFFMRNLRTYwlSkxM64jT5JlO4KsIYm07M0x42QV4yp/pbsewy7m3HALLLK0pfy959qKBGe
	C4nfFe5YcWcVNli/oDaUn1OjnRqxaS2Txt+FQFFq126dbJtGZkN8OahQLXS42exO0dSgzsGv0MC
	3a/VUvl4BuMgbjMSLjzhFyCl358wRGKnLhCq2uEVybHgC5z4w==
X-Google-Smtp-Source: AGHT+IGoaflavucoSX1WEgopzKKcdrinu9KA/FkcvAd1RueKhs+WVyWiixXNe2xfLOG4W6BWq8swdn67NOOrJeNUBug=
X-Received: by 2002:a05:651c:40d5:b0:336:8fa8:e03c with SMTP id
 38308e7fff4ca-336caf36f96mr24077381fa.31.1756895651781; Wed, 03 Sep 2025
 03:34:11 -0700 (PDT)
MIME-Version: 1.0
References: <20250902-pinctrl-gpio-pinfuncs-v7-0-bb091daedc52@linaro.org>
 <20250902-pinctrl-gpio-pinfuncs-v7-16-bb091daedc52@linaro.org>
 <aLcBcjvMbrxoDYoC@smile.fi.intel.com> <CAMRc=MfcFMgkNqWNZV5o0NxkAvxBTjC3vv56Cr98n0R2CkxuPw@mail.gmail.com>
 <CAHp75VcgaqnDrPH27wxfgyK6zz4RAKJQB0r7G2vbTONTxkEzTw@mail.gmail.com>
 <CAMRc=MfhhX2NJ0fhhX8u+7=sdyUy0G27n7caGf9=TpHxUDJVxg@mail.gmail.com> <aLgW7J-j4nn0u8uo@smile.fi.intel.com>
In-Reply-To: <aLgW7J-j4nn0u8uo@smile.fi.intel.com>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Wed, 3 Sep 2025 12:34:00 +0200
X-Gm-Features: Ac12FXzivaaUXd08fTdsNp_v1t2v6QHg93m25vorvolXWMo4UMb6c0rxngkBDGg
Message-ID: <CAMRc=MdA21fwnamymG6YhqBjKDso_nJs_4xefPNONQNfEcPHXA@mail.gmail.com>
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
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: DC32018000D
X-Stat-Signature: gjj7fwe53yy71drbn7zr3rhf31y54gtf
X-HE-Tag: 1756895653-36658
X-HE-Meta: U2FsdGVkX1+c1vMeY7WCsxYDV/1QvbF7ko6V3vUIaiqw4s5Z3WAHpqil1Z8ZKDvpi9Dz1nO9ujsXUN0bwPLSLlGb/lU8f84EmvJx3v/yOTp8uNIrSRUhkyG8NmsT96dJPW/arBnlC1s27NI+IPkG1tuLyHyQK+mXnwPtZaR2qjc6F93UH2AcbWdzfLOajczl31m3iQAIyB/nutrn0my3BecWsOZdpqzd03vlUjFhHk9N7/XTH+ttwN19LTqBIsDm7OTKFmC6jCHABfq2UrZU+z8dmtozqKCEdogojBVp2WViFpFsEJFEAwUCVO3os1Ht++Bq8l+YLFq366Zqor9zL784K0RNGv3PS28cbrz2QcS9ogOATVaNRDglXZCEvfQwLm3uyWf4sGvU5YE3rC4Ya4qb+UeCWC5MnND0C5HTu1KqIvcxpaReeuIWtte2xNzCZUe8Y5LQTjmRy04mVm4+gWKTkMnHMzUu/za25OHdhcCfLPDZsWxfGOzQYF9HAO0EPCDaicxzHvKJHETjncyt8DJlw+r8aYeCFuY5XxAlMdbo0AKdtoe+YbIK0K8cU8WIGac35j0XW9mK0SVcJLrZ4dZX/f9h9gnOm7mvFM5zD+gL8hvGiNgiKK05dUaYXPQg4iCwsItArkJkzmt9P7FRuQKm5a5kg489xWCbej/3SNSjJLd2nqZeUG5UNlbdR3fyfwPtVg+AkBntNAB+90RQ2t7uhnD2cWNRlq3NyMVQ3/RzOSfQOBHEk5ZcRdxz2KFxgnaEBvqHyV7dNoCYqPg3y43jaFi2aP/N2ZqL8zMUU7T24BYCcOdWL94zhQ391yBHLcmkoOnd/1joB1kG3/82yuP/WoPFC0VK1fJAGbdTU+kPFjkHUh0FYUEphrdXo717AZ06AI/5JLZnFtS5KY72oUBmm8VBwaQUuLHeqJv9WVVevaSYzUXz8KGDJYijv7yInJmKnU1QxxPa5BWUpJ9
 hBmd04E7
 vI9FhYb/L7RYmUCP/yCqBcD8hCC3sWxzhQy3s843+C1UBGcftPEQq+LHY2r615GUAIAWK3387R3bJnjW7/OBBn+YD7rsEKr8TkK8wLfXwPHu2Enm8A3hyCeKKaEpAmIKo+YoxuM38YCxS/FOr4liJTK4oCnnfJHK2YV04uNZP1iyXO6iwLD7H+XUji7t9/pjEm1N4agB7iWFZthIgdaJIxiGev9JqYRb4sVnAWfuFCIMKOQ+/EF/XOigLMnGy5bFnFu1T/XvhlGDjPXiFCV1ySAqVeHDuhPal+K2XaljUGj4JFvzUlYKJFKQ+Aw3utlD6H+QB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 3, 2025 at 12:22=E2=80=AFPM Andy Shevchenko
<andriy.shevchenko@intel.com> wrote:
>
> On Wed, Sep 03, 2025 at 09:33:34AM +0200, Bartosz Golaszewski wrote:
> > On Tue, Sep 2, 2025 at 10:46=E2=80=AFPM Andy Shevchenko
> > <andy.shevchenko@gmail.com> wrote:
> > > On Tue, Sep 2, 2025 at 8:42=E2=80=AFPM Bartosz Golaszewski <brgl@bgde=
v.pl> wrote:
> > > > On Tue, Sep 2, 2025 at 4:38=E2=80=AFPM Andy Shevchenko
> > > > <andriy.shevchenko@intel.com> wrote:
> > > > > On Tue, Sep 02, 2025 at 01:59:25PM +0200, Bartosz Golaszewski wro=
te:
>
> ...
>
> > > > > > The strict flag in struct pinmux_ops disallows the usage of the=
 same pin
> > > > > > as a GPIO and for another function. Without it, a rouge user-sp=
ace
> > > > > > process with enough privileges (or even a buggy driver) can req=
uest a
> > > > > > used pin as GPIO and drive it, potentially confusing devices or=
 even
> > > > > > crashing the system. Set it globally for all pinctrl-msm users.
> > > > >
> > > > > How does this keep (or allow) I=C2=B2C generic recovery mechanism=
 to work?
> >
> > Anyway, what is your point? I don't think it has any impact on this.
>
> If we have a group of pins that are marked as I=C2=B2C, and we want to us=
e recovery
> via GPIOs, would it be still possible to request as GPIO when controller =
driver
> is in the strict mode?
>

Yes, if you mark that function as a "GPIO" function in the pin
controller driver.

Bartosz

