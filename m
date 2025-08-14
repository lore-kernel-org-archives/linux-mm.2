Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B74FCA0ED1
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 03:56:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A6449000E9; Wed, 13 Aug 2025 23:56:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35716900088; Wed, 13 Aug 2025 23:56:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 245E99000E9; Wed, 13 Aug 2025 23:56:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 145AE900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 23:56:07 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8323E1604F2
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 03:56:06 +0000 (UTC)
X-FDA: 83773999932.13.A927906
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8865112000A
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 03:56:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=cDfGPM+R;
	spf=pass (imf29.hostedemail.com: domain of wenst@chromium.org designates 209.85.167.45 as permitted sender) smtp.mailfrom=wenst@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755143764; a=rsa-sha256;
	cv=none;
	b=QKHewXq3hMY2EJxH79XVOvObpvMWeyXMvYAFrn8H9R9E3CTcx8jlrrGphsPSvjLZCLQQgw
	nOc5xVFwkX7/Vb/SP/O7+PYUc8uBHRe/Dl9teP4f6NhyjFn7Zjs1dh1wV0GWvvWqQwQfgb
	CEcRO+pLZCCpRRSqXV82maNXZQbF92E=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=cDfGPM+R;
	spf=pass (imf29.hostedemail.com: domain of wenst@chromium.org designates 209.85.167.45 as permitted sender) smtp.mailfrom=wenst@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755143764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QPXgL5JA1NadViWzO3at4LaILf4SB9CfhgF57NmFOj0=;
	b=yt86IGEp/qlSzfZqYA6Z+oANSG0LB7Jd6Um7I2uEx6BpNSt3anIIKKpNKQp6Zh80OuzWHj
	EhwolzMvOr5tMeGFyIt3RuzAgrYJCvL5AcqwJdvq8pRvDz91+xI99Vo6JGbSrshnMnny8Q
	GufiQ6YmznqQ9FuJL36bo6mjZUwWOEI=
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-55ce5243f6dso522644e87.2
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 20:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1755143762; x=1755748562; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QPXgL5JA1NadViWzO3at4LaILf4SB9CfhgF57NmFOj0=;
        b=cDfGPM+RoG5FHMkxSBVCUbjvckAY/jLWqN+szmb3Jnb8ju7pn2YYOQ3U0bT+Xd1Krt
         LUszcDQrtofE/z5v79zu0SxviCMhqhtTuqUNGP/AifRihK9xLe797PnRM097jCH0tqwa
         j+RTUMspxKh5WPU9SzJRdzPUCoLib2n6nTUY0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755143762; x=1755748562;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QPXgL5JA1NadViWzO3at4LaILf4SB9CfhgF57NmFOj0=;
        b=oLci/UtpgqdpeE9ayEYaj3sF5H2h+ArUBUeAYWDo03DtDzMw3TcQ6+IY1CMjTiM1Md
         EQ4zJutPT6gmDepE2TeDLOL0vehDMrqHpEnrrbmVO5vFESiHffVPzkwQmrbfwOmPe8an
         nj3SC9zndjzp2Ul1BFmpGtHt1C5yxiNn56nal5kLk1bOrikCvd424T3+KF4YZaWdGYO7
         kuwgBh2lL+YDu6HMC2QgOqp1n+LoIoq/TSFSf/BulrRz2gMIt4hlEwTc+6fT1nfMjg6L
         wXAoNHhpaFt/o0KJdXgv71VHTPlxkxiSWhkG3X7wlvx2KhCZl6e7zR/2MrgZMf9Bpy/w
         iY+w==
X-Forwarded-Encrypted: i=1; AJvYcCUs+4Yarr/yBXOB+6e0QNggFxJ/YqJTN51M17Nqae6mKM0nuBnIWhjLOqOEqOzI3Nm2NJvtP74lTg==@kvack.org
X-Gm-Message-State: AOJu0YwycCQ+YI6Qae3QCaYUPYQh9lcIVeiGO84EZRnoq195RciFd3Tc
	sTsQUEjMU3mGRaQrK/+IQ0mLbOYraIZIjG+ubxOx4s5LBfeLPvx5VWKSiYv0jk810aruIn+lWyT
	Rs0++FioSaNJ4wqDGzB7KK97NHTOzlAq3m39kzu5A
X-Gm-Gg: ASbGncufnL6M9shRCN/BLni9tQZYBWhhL5FB1AJyL0pNT00ReuYdYayjNWc2BlkMltp
	tnGmXQzquOunI49x3lBs0vzIbYjVShI687PJdeFf/ILlLAZXHzAO0rUpvcp4gLdyk7JXykXiQxW
	s7NcGZY22kLmeG5DjT+WqsmeEG87usfrkIAeRLPZGwpxfECRsPONsihHmhB5f1wrY7d0xyWQyXS
	jgsh9sCWhDJrn3Rq1ii0KP5KZyubD4SSkA0cUr6sbJCTg==
X-Google-Smtp-Source: AGHT+IHQMv69+04AP9otNVcxhwI8uWKlLmUkdvXFQ1PCUQkCenB9LDrLy/Vl+cHfeBSUvo7zV0jpH3UAnLNxpErRIuE=
X-Received: by 2002:a05:6512:4406:b0:553:2868:6355 with SMTP id
 2adb3069b0e04-55ce4ffa5f7mr485589e87.18.1755143762579; Wed, 13 Aug 2025
 20:56:02 -0700 (PDT)
MIME-Version: 1.0
References: <20250812-pinctrl-gpio-pinfuncs-v4-0-bb3906c55e64@linaro.org> <20250812-pinctrl-gpio-pinfuncs-v4-5-bb3906c55e64@linaro.org>
In-Reply-To: <20250812-pinctrl-gpio-pinfuncs-v4-5-bb3906c55e64@linaro.org>
From: Chen-Yu Tsai <wenst@chromium.org>
Date: Thu, 14 Aug 2025 11:55:50 +0800
X-Gm-Features: Ac12FXwQl-cvQ51JsCsvzfEY1EzqeHLXUhAtiyz4lnmgFYbrRneNtPbyaTw1wc8
Message-ID: <CAGXv+5GE4eUjMhewRm9oa+GbJWt8tMC0RXvT0R5FEfVOAsJ3fQ@mail.gmail.com>
Subject: Re: [PATCH v4 05/15] pinctrl: mediatek: moore: replace struct
 function_desc with struct pinfunction
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
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mediatek@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-mm@kvack.org, imx@lists.linux.dev, 
	linux-omap@vger.kernel.org, linux-renesas-soc@vger.kernel.org, 
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8865112000A
X-Stat-Signature: amctb7xf3syo8frjd3hjy4ukx1xgobuc
X-Rspam-User: 
X-HE-Tag: 1755143764-995720
X-HE-Meta: U2FsdGVkX183a/G3HyNxT1NqPEI3aM9bs+ATgZOPSbl77Db2ARFyFD/zYaPI/aTg4veTDknXtYg1VDCp+QCYS4nck0Mrl7N0E164HTJt3vRSPG5ZHmK6jyiUwlcftnbFXZVuyYJGXnpyv00LSrt+e9cT3AcxCl0cPhNlx4tvDeFYI67kQtUm9sP0S4qXTlWFBAqP8FVWerHGjT/b7dh8n7V8MB+x1xhoYIKs9zhJnSedddrujkfCWlqLz+cW4rPhve8T08LYk0V62yaRGu+5LZYditzn6hOJUfpwjDHeiDlqfBK672lVGwhzB4BAmtPmGz30JFNGOLgQ3/G5mlXzhRtUIbXs7oWnLx/h1PjR1Wvp2OHashzHo4XHzoQRJHP5CactR1tHOrlM5fT52iHoTBhVqsAAZO4gW+xDcJlbiD6CZjiO1InMl5AZbWtH5qQIYcReqjYHH3bNSZq2rywWbjV7c6qBd/dS7cmDsA+b3wLY4hOxtgS+mTHK06i8a+3etCvERc1plC0gm7PDCP8g+j35Wk4ljUwALP0wpimxO9NJSrGCBmB1SDSoEvhO5QqdHJur8yRJuEOh1e/4hWVL5CAIbDZfLDpzQK79dEt2Qmjzv59AFQndw9e0Tmzfm83Q2ndbG18a1iUapF7O166Z0yJGBV7JM6yJxt0sRSLDDO/cLZdY/aCd18fCyexpFuG/0LfucFOztJrpMryPcPQCcHZxVpyKTzxnu5MEOQWeTX9B6SMb+KN8CpINaZ4I0kD5U7U1/G3wqzlzJ5pd+i1Dav0nRZ3JHJkk+lZLlzgXXB8eIULzRicbdJGJUldXdC+mzKkj7hgpqBDLDNRfrku+UJbAnolrP6NCbLeoo6aNLWGTHENgs2tL8UFQYipnMMXO9tjIvkF4rJRtbp52d7Vk5VAgfPk86FpJvbekIlfO0rIPeV4o+o/uprb381UfDHQz8GEO5pDAcwk6Gj9e16r
 I1LS3I7e
 eta07a++Ws4zvdrsuu4Nc3eCRabdssAZXVmzv153giCs4LsvXPDO4bhZ+S7Arxi9mKIR4Ly80AdMMQ5rVXJsr9oLva8I1dBMoDC9dobLe3KIPd+y/wjoeekOrUVE6zfAnT/uOKk6CPQnlnnGvUb1Bn+/oV1s1v3i2wwNa0szE/hMPWj5xBgbEhemzh2YN+CReOAG/M18fOxNLAfw3Bmt8KQ/NTGwpl1gF9w1FtyC48I7Fb8RYfAJDTrFY30zVXogov1HqIZLFLtT0ikBVTXOago2E9vWLtI1KR71QWN2q2qFj8W3/yAB5Ux8p1oafUKdphkKBdIIWQML0PJEWEKsSzx7BT6YWxdMs96TZYIgm5FooJMrFvUT/bilyKmwWBklI3BrsMKPgFlBTEFRMfrhR3xXLoQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 8:36=E2=80=AFPM Bartosz Golaszewski <brgl@bgdev.pl>=
 wrote:
>
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
>
> struct function_desc is a wrapper around struct pinfunction with an
> additional void *data pointer. This driver doesn't use the data pointer.
> We're also working towards reducing the usage of struct function_desc in
> pinctrl drivers - they should only be created by pinmux core and
> accessed by drivers using pinmux_generic_get_function(). Replace the
> struct function_desc objects in this driver with smaller struct
> pinfunction instances.
>
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>

