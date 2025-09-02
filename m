Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FC8ECA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 14:02:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59CE38E000F; Tue,  2 Sep 2025 10:02:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 573458E0001; Tue,  2 Sep 2025 10:02:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 489868E000F; Tue,  2 Sep 2025 10:02:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3A6518E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 10:02:44 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CE0AB1186F4
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:02:43 +0000 (UTC)
X-FDA: 83844475806.04.094A337
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7A241100012
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:02:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=JWe6Bncx
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756821761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t6qJ4Krbe8Eig8u7HuRNaH82OJCGzRpxUAzmtO7ZEgM=;
	b=tj56hCt4ZoKSTUkOcxS4pYFy62uoVj5q2NcqAXVXT3cIdwfbk9TD/xMCnbetnJt/5/FEKJ
	i/lgE8Ksx+JqYAAuXImtBtftrFMKG5DxqE9b1K+/JylJYVzaLm9CVEykrOFivwVw+f+bFY
	TXkKRYY2iW/JkkqAq/cJy0VLaeu8Gww=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756821761; a=rsa-sha256;
	cv=none;
	b=N6AxNr71VnqB6BbghPnY98SXM8XtXTMzvOKpC3eYKRbT5/bbG05oNU3E8SDSyHjAZktpwQ
	FVc83CxtXks7Bnz3GoiDMQUtoDCOyskxRNQcg35CQhfvpirPdXzKDawvI0+FMgEoWmmKFz
	2nT0Fkj0dDyKgmwVbtIOlonekR5lY3E=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=JWe6Bncx;
	spf=none (imf14.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.167.48) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5607c2f1598so1694171e87.3
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 07:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1756821759; x=1757426559; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t6qJ4Krbe8Eig8u7HuRNaH82OJCGzRpxUAzmtO7ZEgM=;
        b=JWe6BncxAB3PEV+WMxZQzK/5bgMyPqYihCLSBSi6vWPwg3g1JNLmMNN3q3QMIgUexa
         Nlf2JAqMLScSu26IP9yf75FPvE/k/62sCJ87OmQ1/uJ+z/THuyzxDOTBNjycajOejD7h
         vQcZcrYXCi83esxHXMcGXY9VTWnUEKBHdDVhSU2vU2qg4niLsoQN+JwLfpYKOUp77sj7
         Fe7h9SiS9X4NyEQgLxCNqBUlCGHsV/Zr65ogPX3FEPADZhWdbOxH8hM03KDt/Ae4hOcO
         pXVEWq/JuszMw5JuCFhd7HnY5ZMKUj3Q4GhCrYLBKe/exO7+8Lx009Ql53xtBovi8RLx
         Yevw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756821759; x=1757426559;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t6qJ4Krbe8Eig8u7HuRNaH82OJCGzRpxUAzmtO7ZEgM=;
        b=fLn8TdI9tanytDgCPMjfFFgg5FxHsJ4jQjYc9N1IMNnRs3ObB/J5xqVVMNPWnoOo8M
         DvVZztGB4gUWfdnDsGQ2qoYNh4r8ssv0JBAdUc8b117u07GRj9hHz42mkWxEOo4jLKsz
         5TSawpbCni6tGYst5FnHzO82geyISDCZFHTs/13K9JuAHr/U9Pr6bVHzfQcV8AJshW/Z
         +mwV11IxiG6k6DmFoEV8N3uTuZCkoRK45qK2MMuBNZZmweBa4BqFg+vkneQGfQO10oiL
         jbY+7xi1wNJSyJFyjjzzYT6xTDEWQ2QGHMqTyoe65z+CeByxHyKtW6Vs+7ikADWrdbgf
         jaFQ==
X-Forwarded-Encrypted: i=1; AJvYcCV9PfN3hp4zc8TaWsWiKBeBRAvJT9z2/wmWDt5m3vPlndB8J18PUVnYRlEshHBuGpeogT0FwILIEw==@kvack.org
X-Gm-Message-State: AOJu0Yw3oBjEwQV+nOAVnW5fys4bfbCYNXSnCi7qutw6cF1bACOgfqSx
	jBobrHKdLsXMyRJEkt/ZH1fnha3H+SVbo6tsdpwZMoLjHimdPU1tE4mgE7XB5VatuoI/BxWTQn0
	2VtmK+KauPUvsR8jqLTzbQf+JoFlborqZyUgGORAPzw==
X-Gm-Gg: ASbGncsv56+qW2CxHiQyJN+nzoQI2TvFgA4ZIAEfeay8ysLBi5IbhGdo8alLg9vJ1z4
	6BTr94U10OpdANLuSOlPXue4aFC4W61Q9jtca7z4MRUcLZ+1uGPVNX8zVqTysDgmvEXMzGj8SXh
	loW0qoFZS6TiJmg4DwstkKqPcemfGgT2iWQDVwAewUMzRuZweAgyfAYsvx2T8ncMjQZKV855QIc
	9+YG38oehg4/n0G30UB406/GfHNhH8vBlTz4PkssI4G2GbC7g==
X-Google-Smtp-Source: AGHT+IF0XxTo4Eof/cAnsUmsXyl7FaRgZjHqhfNse8z4FzsrSjUbnY+JobcnARjelIxZIYceGk+U5xWeRaOHkRoNgZc=
X-Received: by 2002:a05:6512:1289:b0:55f:3f25:f03d with SMTP id
 2adb3069b0e04-55f708dbc89mr4083265e87.32.1756821758848; Tue, 02 Sep 2025
 07:02:38 -0700 (PDT)
MIME-Version: 1.0
References: <20250902-pinctrl-gpio-pinfuncs-v7-0-bb091daedc52@linaro.org>
 <20250902-pinctrl-gpio-pinfuncs-v7-1-bb091daedc52@linaro.org>
 <aLbrz5DYS5Yxx_UE@smile.fi.intel.com> <CAMRc=Mfx5czDM=vfEYhFtVO3MviYaW4wKBYjGZ9ZnMbr-+T4mg@mail.gmail.com>
 <aLb2HH5zgxdbDiPo@smile.fi.intel.com>
In-Reply-To: <aLb2HH5zgxdbDiPo@smile.fi.intel.com>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 2 Sep 2025 16:02:27 +0200
X-Gm-Features: Ac12FXzmmMVa4i5hYh_JJ6GZvRRv05y-_-Nk_APJiumjkhCqONHKECafTZ1ySu4
Message-ID: <CAMRc=Mdp2djgGbgu_uwLSkrtRPomAU=6-SRdzCdSbrHWzS2c2A@mail.gmail.com>
Subject: Re: [PATCH v7 01/16] pinctrl: check the return value of pinmux_ops::get_function_name()
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
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7A241100012
X-Stat-Signature: poqxtmd3geh3bgyo8jw7z1hohsxokfns
X-HE-Tag: 1756821761-147085
X-HE-Meta: U2FsdGVkX1+B+lhitkNl4wcolo2M7/9x12gUiwJ2IG+050Qx1f6n3JrKNsaWk9gC1vupqij/ZFN5lkjld5XZZqcxZY/TGqVXbmN4M3h0QWunVllR4UYijtgmpmJWB9RsCatMEsgBCNgYHP3WKZ5reb1070/Okcy4ya0x4kaPF89I3OeV2q4Sl91l8ZXMlSz27w/iLfxrfZ0pXuatb+fYGioJkr4hs3i3qaAfFj5nTiOzryW9Tid0NY6jkLVUV3yXfLQNImC1ZbcQ/7piAUSzeDczGoGMjIIhzWl0vqoY+vTD6c/PzgG+AVg1svA5WfjMREZp7F3cfoeqB9E/135TEF/CyZrl7PNlqUcQWTLIJjdKtJmqY3thFsq9ri4TdVaieCoONpnrqDPvoNvINkOTGZpGkfLJ4ArfeOzYKWjjhY5qfZophWhwS+Tn6xo8Lo27jvirDPWvv9Dfuwwg0v0+sxwgF/O1EUEjI0qcU2Ndca0DyqQsxHg5+VsqulMLTTDidS7hyNst6mspnIyiGFdNcVCtiOCMY+y/1ca1rXTBHSW7q2d/KvoCcwzgx0pm0F/8RL7op4i37PTpXVCWXmUC6tERuiU7Q0D0Zn2SYlmfdmXedi9xhHUtFIFbU35Jeo2omcKMuuMFvIi35URgngbz9zdg8L8Y8uAKGMo2QKOJnrYWyojQ5JqY1+1a0XVZWck5IJxexmQip+Kbval0TqDrYazfhn/vkHykwAIovsWclkf9r8SVEi//hQKflyhTJ+yVPbYR0LT/MSxQfW64wkL+tuuXXcml3L1yO7NIvpZvKp499Y/sXeQYatS5xKnCDgRvAq1rMnBygTHLm9vYJrEEJ+QzRGXLx7EJhSUArh172J5TKQZkb3ZaA11bbNYyxaPNVXeGvfkVSvBwWGx/ABY/3SY8Oo2RFZgcltdnNNuCMDMFn0Nqr7B2GUi/Q4mMWtBArr1VVmJ14HNEqZifOAH
 ZkW2duWq
 7l9OuRbu4anL2xcxq2cCnPbDoXKpqHzz0R+ou4i5vo54gb3PTBGp5R6w4hhbfeyrCiVYMkA9R8gU2W4b4PVPSd1VOt1EjYtHP8aZjjAGa9xKg0RZtwcBx36J7xMiPbwWW60x2WQRzIeXhlbgR4Iin6fi4Ef+bKVpUi2ZrYBLLrOibT2UYnuKOvnhArPIP89V/aRkRJDHSxbiLMWjzZ6Bk6gyLQv3W3DJen2Z7MFyH5ZxV5H0CBPiMXoeMTmApWKKsyZJJArjdJgpqZVeUFVRmuNVz3g7IXZ1Lt9/TJdwPbkKVjOlEuVhB0bqyyLh+vL4zIXpo1z9ydfoa3cZL0rgXe/W0diVNol4Lbqsi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 2, 2025 at 3:50=E2=80=AFPM Andy Shevchenko
<andriy.shevchenko@intel.com> wrote:
>
> On Tue, Sep 02, 2025 at 03:29:31PM +0200, Bartosz Golaszewski wrote:
> > On Tue, Sep 2, 2025 at 3:06=E2=80=AFPM Andy Shevchenko
> > <andriy.shevchenko@intel.com> wrote:
> > > On Tue, Sep 02, 2025 at 01:59:10PM +0200, Bartosz Golaszewski wrote:
> > > >
> > > > While the API contract in docs doesn't specify it explicitly,
> > >
> > > So, why not to amend the doc at the same time?
> >
> > Because this series is already big as is. That would be another commit
> > that can be separate.
>
> I meant _in the same_ patch.
>
> > > > the generic implementation of the get_function_name() callback from=
 struct
> > > > pinmux_ops - pinmux_generic_get_function_name() - can fail and retu=
rn
> > > > NULL. This is already checked in pinmux_check_ops() so add a simila=
r
> > > > check in pinmux_func_name_to_selector() instead of passing the retu=
rned
> > > > pointer right down to strcmp() where the NULL can get dereferenced.=
 This
> > > > is normal operation when adding new pinfunctions.
>
> > > Fixes?
> >
> > This has always been like that.
> >
> > > Reported?
> >
> > I mean, technically Mark Brown reported my previous patch failing but
> > I don't think we do this if we're still within the same series just
> > another iteration?
> >
> > > Closes?
> >
> > Ditto.
>
> I meant that this fixes a potential issue disregard to your series, right=
?
>

No, as long as the imx driver keeps putting stuff into the pin
function radix tree directly, this cannot happen. The issue was
triggered by the discrepancy between the number of added selectors and
the hardcoded number of functions (we started at 0 which was not in
the radix tree and crashed before we got to 1).

Bart

