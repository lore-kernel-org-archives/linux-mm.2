Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4F8FCA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 15:07:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDB4E8E002D; Thu, 28 Aug 2025 11:06:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8BF68E0001; Thu, 28 Aug 2025 11:06:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7AB58E002D; Thu, 28 Aug 2025 11:06:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B12D98E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 11:06:11 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5DB0D57ECF
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 15:06:11 +0000 (UTC)
X-FDA: 83826491742.11.F45486F
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	by imf04.hostedemail.com (Postfix) with ESMTP id 37F8340004
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 15:06:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=2iD+dYXH
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756393569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RmZzYFeRtHhCTqoukOzpWHGqKe1b+6GRRn1Jw/JtbH8=;
	b=V+QfIIY0X/IxmULxom/h14zhbVNkLUVzVV9B7e/VOfrHP/R6vuXbcvH60u8lo6lx68fZeV
	MIKpkFFE4c1PcmGacG6zOEUffBEAwRu1IRLMBPQa1eeN1CsuGAmIh6rvcrR2LfWlj2igf7
	U3S/QthF5wfEiOP2z1Y8N8UkIy8xhoI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=2iD+dYXH;
	spf=none (imf04.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.167.44) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756393569; a=rsa-sha256;
	cv=none;
	b=X06A5Jw6Uuz/DgQ2a8M+gOYw2dKNsqGGzZJ0jGXVDTSQlAImL7CkQrN3ecIGxRq77OUaSO
	v+aGMykdvs8H6W3dJ6q1PXEJZXxOZn9ZUuzZZj2nSWC5JozXHdYrDThMeDdQNmGMm6ShWI
	5uEwsHFMzich607FjxxAwEd6BVJKPLo=
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-55f42dcbf4aso1071485e87.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1756393567; x=1756998367; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RmZzYFeRtHhCTqoukOzpWHGqKe1b+6GRRn1Jw/JtbH8=;
        b=2iD+dYXHXIMIsjW8HDKuImrG11SVNz5laQ+EAphDACYpKPbEulj3C5kSiMFpwztA1Y
         dU/ejEzBW1ZM64Q6Mf4j/J8/5Si2509kZa5Wd2/uI/sUAhrS53NVredji7vWsARjm8Kc
         5taDiLYk4DQhR6DlVpaajhUJHU+DpldkO4FUuscLYIhfpUWHWiTsr64y+OSp/pZyNlnA
         RYeCDVoDmFDdc9J31CFDOXQx16la1foCBcMA0MEuxWOxKEMR65qRANFj/UiIToDCLMpN
         a7jvrOTM8rMCMQQhm+66nWCzeeHSNAoLQD/BE+QEMepGV6ywxKtjiXLqYibYMoMdnWZS
         vNOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756393567; x=1756998367;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RmZzYFeRtHhCTqoukOzpWHGqKe1b+6GRRn1Jw/JtbH8=;
        b=PJpdnVWGcrqYrWtN4LDcT0K/YFj0ov3sFyZaslE6jIdUIVWYxNBVVPz9Bf+QZAfD/t
         tt3mEboFyVOTFb1kFF0D6avFse3JfmeP/2ZSF3LOvm9+nPBTNIhZutVAdaPgSc4in5p2
         IchjGoIDIDVIT1nOShlnvjgK7TRMaslMncD/iZL9I+KRxvy7XwLHLmN38rtsgPiPpCs4
         e/GSMaiRZHcW7CUBXRzIGNaZzEcqrvSKVp8XUSrbO67dae6vUnkag0F+vP5Z5AkLCYBP
         rgTBzY2xcav3uExKyOJamcfr3jURHxfacDBhlUijU0NjfXryhps7jFW6sb7q8KVb3WTt
         SdOQ==
X-Forwarded-Encrypted: i=1; AJvYcCXYFXmFoso86hoTwm5UAJOrpFMXMF+Elzpnuorl01zyZwNPgbdyl1r9J3mgMKL8/Dtj3keoVsDBJQ==@kvack.org
X-Gm-Message-State: AOJu0YyUx5a1XZ7AI8AzAN/EGfd7+9DWOZkMyBIuANvixMv+XWyPi0i+
	Z27ovGPTtMAE7gfTSP7IX6NcG6WKPzLvPVzHRBXDBExSKHnPurOA3o0vlCxIkTZCH6akCkubzMp
	cLN3hyqop4xQ4wLFiQRsVjgl5CcoGu9JeXZjYjGdDFQ==
X-Gm-Gg: ASbGncshRwSLA0NUyvMp/hy54Maj7ysNgIvPq36Djjssq+2U7i8q4o1PGsEgcKbNvMT
	R/nWBAojDMqAG2lppY+OhDr2Wlgp93DnhZNh3ElUqkDCwVJz9lLshqhqw6jA7u1Vjvkz2aGNFAT
	ZExR5USyMDpgmrnpvsmykqCklL8qoDe4GGgtMX9FrsXMETrO5HA0eOnFDNmsLFaPBWCc5Habybq
	Vg7ceihD3F7U6wkWFry4fOFu0AXCqvTJwEXqh0uqCdmRC0BLA==
X-Google-Smtp-Source: AGHT+IE3iToga29hoCNxE0T8DagXuUfkGuMta1TYBW4jpnncy+JoEDrvVPvrustOmHcaLq8T48+IshbcHhnVTj991MY=
X-Received: by 2002:a05:6512:a94:b0:55f:5704:806d with SMTP id
 2adb3069b0e04-55f570486bdmr2169702e87.21.1756393566910; Thu, 28 Aug 2025
 08:06:06 -0700 (PDT)
MIME-Version: 1.0
References: <20250815-pinctrl-gpio-pinfuncs-v5-0-955de9fd91db@linaro.org>
 <CACRpkdaDGmdhaik+1saRv7Ts4myQ+tg1aQqGU3xQyT7ma8dJFw@mail.gmail.com>
 <CAHp75VephepLq61HrVy=PX2oKUQd5NK2qS-vOC5h_NR65td3Uw@mail.gmail.com>
 <CACRpkda4soRCLF5=W=6R4wnwT3pjk743j022XfJxjTTQzuarAA@mail.gmail.com>
 <534ad082-08fa-42c0-9c24-f0c11af7d5b2@sirena.org.uk> <CAMRc=Mdn0_yPXyYq4sbvH4P9-h71vEc4arLPBfSk1PiEFaB7jQ@mail.gmail.com>
 <1804d9dc-8814-47d4-af88-c819c3f17bc0@sirena.org.uk> <CAMRc=MdKgqa+vjhHvD2+Tjw5NwBtFv-0aUivi5UuEQd+n4KxmA@mail.gmail.com>
 <aLAYoDyz8Xie4Dhb@finisterre.sirena.org.uk> <CAMRc=Mdd3fmKjFAfbUB-AAhx-5_CR+c7f36pePkF1k_2LDoORw@mail.gmail.com>
 <aLBggd4rGHV_5zQ7@finisterre.sirena.org.uk>
In-Reply-To: <aLBggd4rGHV_5zQ7@finisterre.sirena.org.uk>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 28 Aug 2025 17:05:55 +0200
X-Gm-Features: Ac12FXx5n8TdDo5k-Gc9YU8HcEZiyD1aufJb5T8PdE3CuzVh_XFc9j0GLQlkpOM
Message-ID: <CAMRc=MdgorsPpkkRF9amVhqPgzb5QBwFY87K-fZ04gONAkGCTQ@mail.gmail.com>
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
X-Stat-Signature: xaaax4i8fsxucrudi7fyps6ufppwu6as
X-Rspam-User: 
X-Rspamd-Queue-Id: 37F8340004
X-Rspamd-Server: rspam01
X-HE-Tag: 1756393568-799577
X-HE-Meta: U2FsdGVkX1/xeqpCWEEEKzSPA00TBpxAu3g6JWTXG6XWYsRn7I4wVVTRS4benxriKelIl/wrXN2rXuUxK5qHS56N38BnK+sd/HPNcxOQE+0z/XS8cGr+e5B2T/RyEQmrssXR2cFvUGnqSqRWbv27wox2mxkTh0NHgMgRtTmUDY8cfYMZB7OZqbk4kxxe00F43kANNoBEjQJGqFCgTBE2vsteeDFuSSc8ft2ADPGh+ENtIK3JzDUp4mk2us8dWe0KsRunFirTQqlgjZnfKIHezO1HYhh1cdqMZQXAmX5ob+oZf6PLljEY+plIEvOD6xWmov3+E6uxrVpla4ybOwxhJoxiVQtEvR3CWHNJodpM9hHpWcm/VOBPBkckK+G5yCPYsozfR0O2hvqPPpC5lIvc2D1j07yMtMYJC3BdNtG9lalSmHforVhRmHATbmnbB0QFtJZSgCgsNzSlhdMvC9SobT1+/cvoX7YA3y8KY73OZ2znKJtqr7vrOIF4aU0Gn576Oeqf6zPFpptuuV+ZIobKPO78okxhr8z37E8yFLxORg3QzZdSq6F/B2bLq4irPFvBbzKsKyObox/sOL17QaBFIj+Zk9/WCj7LJLpfQoWAYPbP3jMeItk1eSgJsFd2iV8KTT3+bFb5XYg2R/cn2zZeWWUjY8+ClYBPJQcXWfSA+ywX6fQdlwzzesohZHU2jpN2d/CkJD3wTluiXHoRf/1qFm5dADGOo2SKsBs7i7aZsnaFI2ogvDziTtf9ef+8QJgKM6t1pOaWM2ZXE96x7wETMiRLD9gxGm4cawDR6rK5UYk7fzB5QQTlnxEdPEo++O5N91Lb/l9KMJzV/MCD3vU5eL0PvksskproF2unQTceIro35zveLZq94ED81qjCDAFUS5ofZpk7ER9RXGEQiLLKUkNHxXZk3bHoihxGEGS8W1rIUWYVWB2U1SNp1IXhp8Piko+IJVL9BGqpmyIPFQA
 0+AOuPrF
 366QSzC5qQceOX+DRdDYHCdkkIA/58J3FfA1lCtIhyXi7qJ1dkgT3L2aGATHa30fRP7UK7yC24yolLo+ju+451SG5sV9xLLucV8FMzcEDwHPatxjVM5+htf7n69UdUXSDWfQzgUClbqJKDJUemTvRJxD92JCDvElXadnDE5tMk9fzuSfF+0EfJqRGAG7fd1t0uGe/D8U4pg7XUnsiHVWdjaH6egokJrHm9utGq6JJhS9w+9zcwHaQ58wljaeCQ/rYFzu9ZWku6oyE4xnPEp5BZpaWXqfV5G34k5pTUdz0BEUJNYTFcBePJ7MuOq3eXUAehqVG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 3:58=E2=80=AFPM Mark Brown <broonie@kernel.org> wro=
te:
>
> On Thu, Aug 28, 2025 at 03:36:43PM +0200, Bartosz Golaszewski wrote:
> > On Thu, Aug 28, 2025 at 10:51=E2=80=AFAM Mark Brown <broonie@kernel.org=
> wrote:
>
> > > It's failing prior to putting any output on the console.  I was also
> > > seeing an issue on i.MX6 so it might be all i.MX boards, same issue:
>
> > >    https://lava.sirena.org.uk/scheduler/job/1697667
>
> > > so it's possibly all the i.MX platforms failing.
>
> > Not even with earlycon? That's weird. There are no smatch warnings on
> > this patch and I can't see anything obviously wrong upon visual
> > inspection. I fixed all other issues but this one I can't test. :(
>
> This looks like it has something:
>
>    https://lava.sirena.org.uk/scheduler/job/1747304

Ah, now I see it, I confused two radix trees used in pinctrl with this
change. Cooking up a fix.

Thanks!
Bart

