Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3268BCA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 13:32:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92B738E000D; Tue,  2 Sep 2025 09:32:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 903138E0002; Tue,  2 Sep 2025 09:32:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 818D88E000D; Tue,  2 Sep 2025 09:32:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 71E768E0002
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 09:32:35 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3754DB6540
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:32:35 +0000 (UTC)
X-FDA: 83844399870.30.7236F9A
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf13.hostedemail.com (Postfix) with ESMTP id 43A522000B
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:32:33 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b="O/O2p4ZQ"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756819953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lnoH1+ZsxBYCzbeJtuEiwBsgC/lAs0DmEqE9uy46sWE=;
	b=1SCyBIqzBsGbL9jutK5gLArRTWHXKHVtXsTIki7cpGXR0uaNlMNgiTHVKx58eVcRxClCg4
	w0rLLdcFpfqFwm5TSIXeO6Q07dLH7Tyvo2CQ93tk1+uDOQbjZnR2N1jeCAnjDwJqXVinJ5
	Y6No8a18uGASV0KlMSLmHtA/99We0gA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b="O/O2p4ZQ";
	spf=none (imf13.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.167.50) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756819953; a=rsa-sha256;
	cv=none;
	b=Z010mhHaNSfXiq6K5U9BPvj40vq3WKuqI0Fe8ppHnIutMtcagOrsaAY9Ikm3+8aLavMzvf
	sxA6mV7/SHef3yy6EkhTXQebhtNs4RxpMsRw69y9/ixsD7c9DG1uAuaU+2d5c4xHCJpYP/
	enAv2nLqawkJudTXNE2FotRjHs0V7Ng=
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-55f6507bd53so5140376e87.3
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 06:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1756819951; x=1757424751; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lnoH1+ZsxBYCzbeJtuEiwBsgC/lAs0DmEqE9uy46sWE=;
        b=O/O2p4ZQdTEmhT1fOZCifyBo94ZKTf1T1qI40z/ZPv65KdRHAgdHdClNulNNvICn9t
         5t3pkgB5ARhNm6xND3I82bFUjX98L/Zbz9jz/8Od/BoNjNx79AEGJEuKzu0kMnhjRVgt
         qUChbKQohR1jrshaFkixeZ214Dn91FLYgIiWN5EPziO+3VvIeWBb5xVM46pSkL9yhIbt
         TskwEgG1A//id5/1cYbS2avb2UvNOka3lwAPjLVoIA9JzEwMUfHnSicU5MR4q8eAen9/
         CyL+QrL/qqSoz7c+uwa23yU9z4a66jAY1m1hOd1GBqrYAn9wKcmRsBqsPyIYWQ3Yp2Ey
         glnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756819951; x=1757424751;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lnoH1+ZsxBYCzbeJtuEiwBsgC/lAs0DmEqE9uy46sWE=;
        b=UvFFeoHNl27hYQDiSzyRwQ09J8gqY0bg7KlO+9RvsluGb4LCPowVQ4S2nvr7+/kgj0
         z1Obo1tgpvcyu3rv6uOTf86bf+hw2uaOvAXft/jlKgFFsLBmYWEldJuL4K5VNN9sNCvw
         mv3vn+WPg8N0mtsMIQ0KOgkg0qM2SZMJBzt4h81VBraaUq2Wc5+GD8xnEDWQEex/xP5d
         aFzKEHe9k7GuZwZPb9p1bpessnKwhEG6+kwSxHeDQl6low0U8UD/UYzn4pt4qZeJEwjm
         AdJPPk+HYH17ugG7I5ojt2xGl60drh7hB0EVJf+UphjaCKLDzLuSjJJYcjbhSUeMIwU8
         OF6Q==
X-Forwarded-Encrypted: i=1; AJvYcCUWX8JMEBm9FuayVcvWSv5i36LwDBld3klDUp36VEj8KWyVkRnC1POCG1o7ZVls1ZUSETZscDkyhg==@kvack.org
X-Gm-Message-State: AOJu0YzAp1kgQA6oDCevS4Dt8Fz8hNg+wzrSkwPDWVvJUQKdLzmVrb6V
	Jgi3W6J2GIrE+44NIl6HtQ33pEBJIc3UGCshF79MGM+D3j79XfMKAQ6VzoYOrVsfRwO4ajCo5pY
	Xl0PGYMHmwhiRdfo8DgjYPmJEefGYH0r3LJdQ93XSOw==
X-Gm-Gg: ASbGncslXqxWnvZ+6HCPUu6q8xV0JLTxtVMcSnQPsDWmXEpvOjmsHqndWStFAdnL3G2
	9fgVtc3Z/JRISw69HfNH8T31cUz2oFsNKW+7Jv7t4n/yT21bJ0Ru1aAy7mwfqOR0PvxP4A3oKql
	uuG5qFTSpQKQlKLuf21v68SX+T8cZwlJFXOb0vdLn+7qwBiuo/e79SdPA9sJ86av25cqjmf9E7+
	JeHgB87al+Jg9Xmu4/BbhJQj2wUL7X8r7G2mSQ=
X-Google-Smtp-Source: AGHT+IHbC8qI4AC5+0YZNljCnPe19ZYxRaps+B2CcXld1o2mGtDbXzoveQoI0IeEbDNxVlYlEUG/+tn7nGWqsyLzmeE=
X-Received: by 2002:a05:6512:3ca9:b0:55f:55ad:2263 with SMTP id
 2adb3069b0e04-55f708b6c5bmr4286185e87.16.1756819949961; Tue, 02 Sep 2025
 06:32:29 -0700 (PDT)
MIME-Version: 1.0
References: <20250902-pinctrl-gpio-pinfuncs-v7-0-bb091daedc52@linaro.org>
 <20250902-pinctrl-gpio-pinfuncs-v7-12-bb091daedc52@linaro.org> <aLbt2euqYQM5xXuZ@smile.fi.intel.com>
In-Reply-To: <aLbt2euqYQM5xXuZ@smile.fi.intel.com>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 2 Sep 2025 15:32:18 +0200
X-Gm-Features: Ac12FXySKFnql5rdsxfRBFF-2EejY2a696V_6zV_jaWq_9WtZl4uQNoHEj4w7YY
Message-ID: <CAMRc=Mdnp8T46Gi_xZintgc9AZGCGiRPYc9mR32Xwodxy7DLqw@mail.gmail.com>
Subject: Re: [PATCH v7 12/16] pinctrl: qcom: use generic pin function helpers
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
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, 
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 43A522000B
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: snccxharfnq8r7pz43u51bbzdxia6fxs
X-HE-Tag: 1756819952-747093
X-HE-Meta: U2FsdGVkX1/7AsjtQgmSC2S+SH3Jz6A6xS0ufy3T/jcpnT5j0mlo6rerOa+zXiw/4J1XjQVacSSVLETrIKVL1mEUBQ6QRi6ts8Ag43Bx/1ndFltRsN1ce3IIq4gDqhaU73V5SQQl46RxqfPGcaBCmervvkcefj5973InbCWZ1mZpZGluTmTOpoO04wPFxBVK+XUo+OcAODO7SOtuQPe4vwIjwDMNrqI4qD8sZZ3NVgpUt4TnGo6ZlBzakMwVarfa6yoAHJOPGCihxU70XT0vger+o1xDGugeTwT7UICY1wE113IryBu1DY81t5yfJUVUmWJq7D4+/wxO1qqVsaYQ+DzYFcd4bTelwCXUrmWyWkNl/FMNPpnJyDxQ9xVqj7UjOKqa2UxJ6Z44tv4vh8tYUh2PMNUTLin+opTMr2dnc1wPkEVPH+03F4R484531fYx1lRRb8OOrMhGT5PU/XGZTf7KQBCteBR09O/6/Q776HiPJFQ1kl0yowGM81wulnrDPSIZGdIxlBgZcfiPbF1vrjOGDVgqSKbPECvIbvIuZ19L8Ov4s9ZWt+npKpI3VybSOXnKXyQLDrJPpa+zOEI0zteWFE9eyoFdPVloccqBGUzGafL4fEOp821NwGhtfxMjJIAmZqOceag228JQUyJn2U6cFVbRPgicgDaeh7G13HytY97yom09AiTfTdIC6hisw7Eyyv2+u94MJsaq/OmqPvuURikjFQ0vGcXI5Zv2FO87gx0m+xJ0ZqvUob+kOM32W6i+TIfez4hNZl34IMt+qSe19Z90mJBz+XxPq6SZLjF1Lorx1hDjFO15XQz8+KowFk1Dnyv5FnaDScO/0/9lwJx/Pv6ZOfwXsACjbvJXqnPYoUidcPQArGBOXUQW62NS0eZOliv8qGLR379HMhqGWnEww+f/eufeR5M0I0S2Q6OteMoRlVO7WKNovJaYq6zC2hBqVfn1cBkz2ze/inY
 DmpDvSTV
 1XCR2F0o8C+l0vFKMKD2iW09Gmat75Rjqo6D6mrbVkJUztsIx+BNxEThvloijWitfjb1cmWVPtRzx4W4ok9u+jXAcxcpiZ3pgvGXFUhFImjOa5Aw43Rv7odtozEctmZ8mLrIpqfDZ25ja6rNyLZsFTPMKMiFvOpBwF7zPq7zzrICMOfoTsc6ClfySiWoBaW3JJSnLH5YOHxIwzSIar4qR6uZinG86la36bEqoYnGQhJphINQzdKvTmBR6mCbtH42J0KwUufTpFpk3T0+MgunAOm5XXfnEydh6OzA4ec/A8SPDGmA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 2, 2025 at 3:15=E2=80=AFPM Andy Shevchenko
<andriy.shevchenko@intel.com> wrote:
>
> On Tue, Sep 02, 2025 at 01:59:21PM +0200, Bartosz Golaszewski wrote:
> >
> > With the pinmux core no longer duplicating memory used to store the
> > struct pinfunction objects in .rodata, we can now use the existing
> > infrastructure for storing and looking up pin functions in qualcomm
> > drivers. Remove hand-crafted callbacks.
>
> ...
>
> > +     for (i =3D 0; i < soc_data->nfunctions; i++) {
> > +             func =3D &soc_data->functions[i];
> > +
> > +             ret =3D pinmux_generic_add_pinfunction(pctrl->pctrl, func=
, NULL);
> > +             if (ret < 0)
>
> Why not simply
>
>                 if (ret)
>
> > +                     return ret;
> > +     }

Because it returns a possibly positive selector number.

Bart

