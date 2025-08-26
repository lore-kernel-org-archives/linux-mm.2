Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4020CA0FE7
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 18:19:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECFD98E00F9; Tue, 26 Aug 2025 14:19:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA6EB8E00EC; Tue, 26 Aug 2025 14:19:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBBD18E00F9; Tue, 26 Aug 2025 14:19:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C97F18E00EC
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 14:19:52 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 60FBC83EED
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 18:19:52 +0000 (UTC)
X-FDA: 83819722224.13.F75D9E1
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3C99D40008
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 18:19:49 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=xCJx2vL3
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756232390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XQz/VrYK3cwCtAlJzmwCDIZSeNenI6Rm8ZKZbd4vuEk=;
	b=vBBY9HjR0TXoICGuT7ShbcSmzbNF0lr4TR4STok98MKcGQ2z/mEAm4ZK7a1uYIMtovOzGK
	N5wS2ZFASWoguS7BirwDi2OC0XR5SpC7iBkq+aXt8Bk8W7IQaxquYZjAuccmcotgZLXeNi
	tbjDn9HRYLgb9Yagr0sVOhvAPqiLoNw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=xCJx2vL3;
	dmarc=none;
	spf=none (imf04.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.167.47) smtp.mailfrom=brgl@bgdev.pl
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756232390; a=rsa-sha256;
	cv=none;
	b=Gkjzr1w9KLnTBpD0QRFMcVA7JwjiOToH4y/PLoLftgkoomL8EEKk7V0/7v1R0e7vvO672L
	U17ufV+5BCasZa0wzJydSs37uQCI+Qw9eKdzivgxPG3tjF+kY146sn55ZeWFNqjei6A9um
	MIUIcxxE39zQN/+iofLn26JYaHtpCg4=
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-55f3fc15e09so2779055e87.3
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 11:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1756232388; x=1756837188; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XQz/VrYK3cwCtAlJzmwCDIZSeNenI6Rm8ZKZbd4vuEk=;
        b=xCJx2vL3MGcT5HoZZId0BzA3cK6GN3ywiV2au5B/2zNDwd39kFOAqZkTJ5LYpK1Ojv
         kWpWh64U8iYJ50dNZQhQE7ib454MxL7kBfbxSpfBke5uylvuNU7fXP/mMEjsRiuVpWa1
         cFKPL9U3dvHAra2Eos5UJnRwjt/+5Nqiud7QYX30Fc23iO4ygYKZNw2cije5KcA0gZOI
         WfsFiqYyk3/eXkG0tRGl98ACuoaVEZm6PjRF5iYCdMYSDJSSYDRkRkkYLryIPU88sxVy
         Wnd/4WTN+JUkuN41/fQ7IEUg8AyatKzuOQRXnoxfTiT4gZeKr0SQS6WiaeAPp38ulzJA
         8cvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756232388; x=1756837188;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XQz/VrYK3cwCtAlJzmwCDIZSeNenI6Rm8ZKZbd4vuEk=;
        b=us8Jlo7cirlXQph7dc8PNxskDrRWIBMtR6mcNFs5CqynoGJH8QtTlUaBBDbDVlxF3v
         rx7NpfqRXlGJE3DriRxSufuRiQq3B86S+QtXheT16A47I/rzOKOrNZO4JUahCFhW/iWQ
         1E2+ZkpH/bY4dWAvp/Mxz5Nw2PxsCyW7Y1woQYzx/4V3m5h4y8S1CfXtQuRWYc6rNoX/
         vU+pYap8uqd7p7bqEYpzxnJFgnWxqRxcNr+8levkxFIKtVXIUX+fnEFXF2SZ5yzuaMlA
         TC9RCjRb2POTBUh/ivfrSvUVsXCH+3kx3u7w1h9EJQCcob0JrZMXWpkN0HgP7cx4wlLA
         2Spg==
X-Forwarded-Encrypted: i=1; AJvYcCVFuE6H7kyOCy/YgwRsyJerFhiF1br+eujrgCI8vcDMv0K2KYR/YTCrKBAhtPAL78q9YrmjVOCSEw==@kvack.org
X-Gm-Message-State: AOJu0Yx9W4Uv6v97bruOPxveNDx+NTFhFqm5iNNBd+M43W5QSImRLYUS
	ynnxtKaEEYhTEU9xs9W6ZXkRTFE4GCB1QyB8OAKUhmMrFc/run924U+By61AMONQRWVamBg+z2j
	ZqCMfuCtwshK5arn+C2oPb/KAFyinBqXWlRj6MhseOg==
X-Gm-Gg: ASbGnctZcdlxf6oo8MxHf83Eiw82afz8DoVg0xO5iHvl9aibjI3chbH0GlAE6+f+400
	3wd+Yoc/HccV0dP3xp1ECD6E+A0uaIiVf+D7Ir27fsVEyNJiZ+sZzpgYew9JZ044F2pCB+6XKyy
	cd5PVDOHOngtOVFUd6i4oUrXTorWf6r0KjErBK2MuJ7se8mZqlLNeeuQNVk2cwih+JYDhkEIr09
	XBI/RMFCzdbLmKBNq6vgLiD8PNMUi8yQIIxncJnu5jQFAisBTKfG4RtxccA
X-Google-Smtp-Source: AGHT+IH9/wDD1C5c1pzIo5M6703fhe2Ju79J3Cg57MCbuHB+kMzD9Ry2MpuHtwyxY9EgNTzhw0WfnDm8emGE0JQOveU=
X-Received: by 2002:a05:6512:3d87:b0:55f:3d7c:387b with SMTP id
 2adb3069b0e04-55f3d7c3badmr3365498e87.12.1756232388100; Tue, 26 Aug 2025
 11:19:48 -0700 (PDT)
MIME-Version: 1.0
References: <20250815-pinctrl-gpio-pinfuncs-v5-0-955de9fd91db@linaro.org>
 <CACRpkdaDGmdhaik+1saRv7Ts4myQ+tg1aQqGU3xQyT7ma8dJFw@mail.gmail.com>
 <CAHp75VephepLq61HrVy=PX2oKUQd5NK2qS-vOC5h_NR65td3Uw@mail.gmail.com>
 <CACRpkda4soRCLF5=W=6R4wnwT3pjk743j022XfJxjTTQzuarAA@mail.gmail.com> <534ad082-08fa-42c0-9c24-f0c11af7d5b2@sirena.org.uk>
In-Reply-To: <534ad082-08fa-42c0-9c24-f0c11af7d5b2@sirena.org.uk>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 26 Aug 2025 20:19:37 +0200
X-Gm-Features: Ac12FXxAYIw0w_2T1YaN-IyY2JYcpKwwddZS_ZNL3wGJGwAsl60-M2w6oLQOL30
Message-ID: <CAMRc=Mdn0_yPXyYq4sbvH4P9-h71vEc4arLPBfSk1PiEFaB7jQ@mail.gmail.com>
Subject: Re: [PATCH v5 00/15] pinctrl: introduce the concept of a GPIO pin
 function category
To: Mark Brown <broonie@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, Andy Shevchenko <andy.shevchenko@gmail.com>, 
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
X-Rspamd-Queue-Id: 3C99D40008
X-Stat-Signature: pozexkk3q1u9tcezp55jj85dheunfhyr
X-Rspam-User: 
X-HE-Tag: 1756232389-795322
X-HE-Meta: U2FsdGVkX18WEnaG/UTSVJ9V0+PPVW4RPq3A2i3+q9db2tUZIM9QOEttI2BdRq4xjfnMKVVc1TFTe6EQevn576x7EVEKcjMeKcwqXpzjzbt6GUuiaymYm9P3+RissAVe9e2amOAGCCj/T4rstlOTURiYmQF5kD0HUB7lhNmO96ZTIQj1NwPzgsF+DIaHwywS5R/WDeiWUGNsi6TuyQWVQ8gAU2vOd8vzXJCMLR20h9DJJo0dwLwXLT++3dulzlvvJmrIyOob05co144TgzsRuSQeiRs6+0n/LopbZg0L8fwGJps0ESVMpzr8LxFLe7yHyAOksdGdbaIdQJJ1NR3oZD8bQTxq4qWQlDWshW7B2sKoHTM24BxR1MxnvpwcTXxfQhigevA7NOMTHTPpmKX1OKw1UcSXeYpdP5044IqIifDS8Cwcph2XGEykebhtEJl2fbd76d7rjNSsdkPgqd1LfLHUnFgZZQdtXF+U5acO64laCKRUI0H1mpO1ArJtPAwtR2TDfP9+AhhUwJrTfyLtDHDR93I/uWX0jPpbEH1r6i9wTHufsAo5Vi2qFIs1xmBuJAv2i3ieJIfhUvCggwfXTI4o2YuJKtHS07I31o/ZB7sJytLW+XVs4ePi/v3fCft4W/Mx5Vl5CQ7rrJP6awklLM2k8E37E/LLF9DSfnESce6CNcbxTl3cZroLp3Iopa6w9naPYzLn7Ye+fZpEUWCxDyR5tupbLw/z0XGAC+GKDDTDQiNlCDBF4fvNBZR7z5kT2O7JUYr53a4VH3d97HWLy+W9YZ/bV4dM9EIpB4sg09pd86s0HoudYOFlbds9raIR8XU0bVAP2IhmRYvTPK4T6ojXV4AK77vwF9P8X2af2lP5ASSyPcalUAWTyU3TPd0N4ANwksm5C6qcd18oFGdeF7C/HYqJ5x7QMzhggF0KPF0Sye9NXDNG9QB8tqB5lpE+IExkR5UKMehMzG6Q+DQ
 F2B2OAJ2
 nDePt+ffUBm8PEAsBmVus5A1c2VzypjHnqpT1Z4qJMa1fhcd2SEupQa5AFZEPbhFpDZL9UFRk2HYRmFbPjWz0sR/G+jVYWWkos53/95a61tIvVVbaB8AC391lhG66Sol3kKQb566kQ+6/6p0bcUXVgkFlLbxD6bzuMzGChMC0yTJ02PJ47bm07Cu/qpOjt7ezXdPk/HhQTGu3kJS5g5ze8HMQQAJA6C6nOSvQ8GXV1Zy+yJnuguFYjZwvLj35hYZJF4SGsq02smgMb4R0nA9pkPLVoaSX3RrXnjD82QSDTmUlrpk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 20, 2025 at 8:41=E2=80=AFPM Mark Brown <broonie@kernel.org> wro=
te:
>
> On Wed, Aug 20, 2025 at 09:12:49AM +0200, Linus Walleij wrote:
>
> > The qualcomm 32bit platforms fail in next anyway so I dropped the patch=
es
> > for now.
>
> FWIW the i.MX8MP also seems to have been broken by this:
>

I can't test it unfortunately - would you mind sharing some info on
what's failing exactly?

Bartosz

