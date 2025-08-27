Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F98ACA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 16:46:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 439CB8E0008; Wed, 27 Aug 2025 12:46:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 410E58E0002; Wed, 27 Aug 2025 12:46:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 327488E0008; Wed, 27 Aug 2025 12:46:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1F7CE8E0002
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 12:46:45 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 98E0B118C13
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 16:46:44 +0000 (UTC)
X-FDA: 83823116328.28.F63E020
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	by imf10.hostedemail.com (Postfix) with ESMTP id 77F48C000D
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 16:46:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=0CmjU1Tb
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756313202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Oe8mL8TjjkGnR2jG5Rxs9VLauseuU6oqwYerqQXRro=;
	b=UT9wEXtq+UBEyIbwDc5AkkPEwn6KdaVkxYBdBV4juXmK5NNGZZIBFSrLphHr1kfpfO6vBa
	jDkAXsDILVTjnihtuTezLm3406Vh4dIppHTlJD65Glo8xu9XkDiESeiU1auboTSxxcySQN
	qRpn7FnLY1/yB0LiI7QAHbWkTc94BVA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=0CmjU1Tb;
	spf=none (imf10.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.167.53) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756313202; a=rsa-sha256;
	cv=none;
	b=wdEdqAb1rw7lTt3GOBZcUOqhdfk8HieOXcd7/L68NYQ7uTvgd6XGoAwlUjgaZpA+di1tur
	YjS0P8vZsML3tpRRGGGpVVHhRA3fsjBNW4EGFwXP3BEneiY3Jp/BzWqx/DzMVJKhz3ltsA
	eZFtij/0OuTc4nXZblbafrvyx3JoqtY=
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-55f42459098so1027352e87.0
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 09:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1756313200; x=1756918000; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Oe8mL8TjjkGnR2jG5Rxs9VLauseuU6oqwYerqQXRro=;
        b=0CmjU1TbFCHgomiYmd9Os7LvpJ+0z5blDWganG/jEECgIKppodW69AjARWth+IVhRq
         wib1UTZTfE/7HzsHsv0l87Zz3LvoJCzcAqXnijr0nlLbnla4kb/Lk04ijCInenvsvFD6
         nwzBZxfrIQm60p1ewxPM29xfmQbYCP4NT/s+2dgSFtnXf7pS8Znk8vaFlZ6IBQ50t5h6
         kMIQ0XfD+UV9DegcPajpFi8c5jZFAWpCsB+NsCaNlKWvyB4eXIOjUQzZH/4iXjMiyVv8
         A4O26onWtDp3mDmBAWYe67bCwcJ9ditJZNTgzBKr/9lpSXIEFEvcRehSZX3C3WtLxsk+
         fb1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756313200; x=1756918000;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/Oe8mL8TjjkGnR2jG5Rxs9VLauseuU6oqwYerqQXRro=;
        b=vjr/qBKfA4EHPRD0h1SRDzDhRtd6FVDxNyLzcpQDfFrdN9frzm/eK35a+8vY/lNDap
         TBSNkAaHyIYKb4cYmnga/IdDIUNrlgEioWKkLkS8qcKek0uVpk92rbHZLyiUhT7LfPk4
         0XEyvBCnE2DxZjjVN1tpcWo5uC0FC6y84y/AJwUERglDmLOc1fhbPBVlnujSy56iWhM4
         PZnPa7RYsnjmYlx3oZw/8gej9wkBFjtOBfBaEJEk0g6S9pDFWsyK3aW4DU5zwUrxQc3v
         IO77FuLx1VCwFV9Qcfoo7ju8sUn8U/ljnDxqTzB1FDdTs2S0E6s/2pQNd18RElmlw5AE
         JPew==
X-Forwarded-Encrypted: i=1; AJvYcCUK8bYZ1MgWLF2x9mYhV4dqS3tLsKDaT+DjbBfSh+0Foj6OUBkM+l6F/0Mp2xCqZBiqfWKtEQHwbQ==@kvack.org
X-Gm-Message-State: AOJu0Yy1ts7kKBM3L7hKjhWp+HEkvB6Vtp7hYJowggxtQfjdJfmQaQi2
	rzZzZsErDT/p6rzqZJFnEJI/m76UKYJZ/Jngow1DIZXD+TxEvQhS2jVIsKbx/5Kawcjgnwguk9Z
	8pyFcc0kr2uYWOnDLDgi0EoOfZFcUtWrE8CglRRgaTwc7rpSVooRB
X-Gm-Gg: ASbGncsf28TUJhfms4VB7YfH/H0smlT5vmFjCXB36XEnCkhbS883hXOVwhU6w4fPYwI
	iqsRL9mc/Kg1tZff9eunc5S6TvmBdUV3tRVeDGAH2/uIt+n7g2zN/K1zc9aCwjo7kKyW7AIYxQF
	YyzOBz+ZlS5HgyppPr1S2ywJQ1zcD3Ki/biJp4ClhCHeyicMSzcKbAydpXbVHqK2vPELOslrrrJ
	9yRiri/t0OFw9985qPZdkurE0IM0aDs6GTfOalkV4d9W1GUdg==
X-Google-Smtp-Source: AGHT+IH2vScJrK3ld667OkWoypLYcKly6TqnbjFjPvpTB4KCLVEthUMwQrvNGz6iiIbdkdd5rCAEnq3AM7MI6KeEyo4=
X-Received: by 2002:a05:6512:138c:b0:553:2969:1d6d with SMTP id
 2adb3069b0e04-55f4f4c6a98mr2026962e87.13.1756313200214; Wed, 27 Aug 2025
 09:46:40 -0700 (PDT)
MIME-Version: 1.0
References: <20250815-pinctrl-gpio-pinfuncs-v5-0-955de9fd91db@linaro.org>
 <CACRpkdaDGmdhaik+1saRv7Ts4myQ+tg1aQqGU3xQyT7ma8dJFw@mail.gmail.com>
 <CAHp75VephepLq61HrVy=PX2oKUQd5NK2qS-vOC5h_NR65td3Uw@mail.gmail.com>
 <CACRpkda4soRCLF5=W=6R4wnwT3pjk743j022XfJxjTTQzuarAA@mail.gmail.com>
 <534ad082-08fa-42c0-9c24-f0c11af7d5b2@sirena.org.uk> <CAMRc=Mdn0_yPXyYq4sbvH4P9-h71vEc4arLPBfSk1PiEFaB7jQ@mail.gmail.com>
 <1804d9dc-8814-47d4-af88-c819c3f17bc0@sirena.org.uk>
In-Reply-To: <1804d9dc-8814-47d4-af88-c819c3f17bc0@sirena.org.uk>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Wed, 27 Aug 2025 18:46:28 +0200
X-Gm-Features: Ac12FXzUBjVjZcm1OFCa8B8Pt22rGMmSNEEFj8GwunzU7aycJyqw28vaNlWwNSA
Message-ID: <CAMRc=MdKgqa+vjhHvD2+Tjw5NwBtFv-0aUivi5UuEQd+n4KxmA@mail.gmail.com>
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
X-Stat-Signature: x43z6ehmkctc9u4op3xjizqu48egomga
X-Rspam-User: 
X-Rspamd-Queue-Id: 77F48C000D
X-Rspamd-Server: rspam01
X-HE-Tag: 1756313202-348840
X-HE-Meta: U2FsdGVkX1+p1hkJfc8gvpjy88uxU/avHrSCQcWdED3ZwEP1/48D8tjuOk1hiSi6LJXyQqErAkLx3mD7fMMYCLgekvzalII3UzagFY4aSLkOnMQvcUVVuH4MCu5LEF0hZM41if/dB8bP5sgABp/PSAYUrvWnqd+IbxwdT/aDO8EUSXQ5KbTNiTuuG3GlnajZl2lyb8Ozn3XLEjuSnlaamtdzJb7QHKnLH855CgSSotA6aAkBP0QtB1rrGC0zG2SfYMRgV/pW9yuWfZ3Ei0uMSAGNjGqOUQ53CP8vjIUdN8A6plkUvzVcLZ/+4PDaGdLY7CvqXTPLX6Vz7nhpOlv/9CljQoVI6DBGJQ2TQ1Pbpiy58PZvOwAW6UsUJDp9STxFxjtp8NVeIgMFpUCtc6uAqn7HplFbUVfe3IS05siLt0RYR7BcgEjyr+IXVu1sGcmOBL+j59/4yU9QrEXa5nZ85kuUCisWQ7lWRI/fbvyRrCg8Wy9mrdxc8BBO8fkihZ3JIhu5zsoaOUFkQczhJN0Mm1ZpZ69XOwDIALAYc4jUQgxGXGoCvuO8MWCfPclJWqtHJQyktA8aO/JJeka0+vV0cYAW/n8pbB7RzXTXvIY0cpMeafurVXmbuARWVoFCw+1rCPPQxs2tli04fkxoZXAo8e8syNm8Sz+e3/4MowN+rI77eYRh6+j9OA9D3NrG8Yj9Qi1E36tYFPzDwmera3deK4S5lL75pkCVzwBj+X7VIgNnfuPCKf+EGyepXUjSAImzGxpACAsDrqZPrn4VN8g5pTJ726IQW6d2jhsLxI4uxkmBuvGm8fsPKaoBiEbGfbz50RUaXXgh66vFaqsbweQiOrWMG0JOaQIgXAzJ6R6u7ecNS/g5nCss9eBVmYjqhPysr5jtkkKr27OFDejTF8ABempyw7UZ/aQfMnLTTjyK+CLej3IaG/DxDXFngvLMl0r6N/mdhJqCgU6Ao/m+cuC
 UZ7H20FC
 4NUvsXcpqYfFx+/aIIyaC1Rzrh+HKmxOibwArMtoyOMZzPmsCmCPtwETlsZQPnYUo/ZJwaEYLTjOFROtWY4FINFpRna4aolkuZJIm8zXEDX32kgKIzHKXckZ292sLP7d87mkY02YvjWSf5DMk5kHv7xNqQo+hec2/YMkU5eP8Gl7wdk6QsxBK1VzGNUzXbrkNdiEAef8VwTL0Ar68V5keuLb1/SWyo8b4yHUIeO5VIG3OcvbIBWTESYPinkFPdDL+3UR6GcGO0EwBKZapJheLg9m7U0HsqM93p+ZFuWJpuBNsIYQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 12:22=E2=80=AFPM Mark Brown <broonie@kernel.org> wr=
ote:
>
> On Tue, Aug 26, 2025 at 08:19:37PM +0200, Bartosz Golaszewski wrote:
> > On Wed, Aug 20, 2025 at 8:41=E2=80=AFPM Mark Brown <broonie@kernel.org>=
 wrote:
> > > On Wed, Aug 20, 2025 at 09:12:49AM +0200, Linus Walleij wrote:
>
> > > > The qualcomm 32bit platforms fail in next anyway so I dropped the p=
atches
> > > > for now.
>
> > > FWIW the i.MX8MP also seems to have been broken by this:
>
> > I can't test it unfortunately - would you mind sharing some info on
> > what's failing exactly?
>
> I've just got the log I linked above.

So, I've been looking at this bisect email and clicking the links to
LAVA jobs and I can't find anything. Does it fail to build? Fail at
run-time? I'm not sure how to read this.

Bart

