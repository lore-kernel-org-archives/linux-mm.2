Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2B3ECA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 03:57:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7064D9000EA; Wed, 13 Aug 2025 23:57:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DD64900088; Wed, 13 Aug 2025 23:57:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 621229000EA; Wed, 13 Aug 2025 23:57:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 536A9900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 23:57:55 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CD9C6593B6
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 03:57:54 +0000 (UTC)
X-FDA: 83774004468.28.AA1474C
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf03.hostedemail.com (Postfix) with ESMTP id D317620006
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 03:57:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=YhUSzXjy;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf03.hostedemail.com: domain of wenst@chromium.org designates 209.85.167.48 as permitted sender) smtp.mailfrom=wenst@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755143873; a=rsa-sha256;
	cv=none;
	b=5C+jWgp4lbUwHFoMAt38v61+oYnWowNbpeIxiFcFfMf+D7wXIQVtr1sn8H0UmZHXHJlFjy
	hbAlIE5rP9Bip7qXJpHTzZ2G7FYXKl7Tdf/Koe842qplz8eCBeCAVRHnhsj60somT6W/nZ
	wSb9Ba+o7M+LuK5pXoIPP85RJ/zXd1s=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=YhUSzXjy;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf03.hostedemail.com: domain of wenst@chromium.org designates 209.85.167.48 as permitted sender) smtp.mailfrom=wenst@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755143873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KuAzkdu+nBeW4XQJu6RSp1V8OBm3suYsUZfkIRqSD68=;
	b=ZzDiEhaoTKi55guOZW/GAFmgOnwhPvxNsHD8XE13gCV7lCPRVzhom3p46YhRcgWP0S6w7m
	aa25SWKLe/FS+JqZKvheEO0OLl6Mhgwc8cvMwWmKIy7PuuYoUzg9cHilguK+EgJBVC821r
	DpsVlie73mpMa925vgYhSyHbW0I6nyY=
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-55ce5253adcso512407e87.2
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 20:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1755143871; x=1755748671; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KuAzkdu+nBeW4XQJu6RSp1V8OBm3suYsUZfkIRqSD68=;
        b=YhUSzXjy01RSWRgE8FDuBwUucth//AG6AHJkoqgvJh3XUfK3mUBJvTnL7n0ZRc9zFW
         yO2XpAa9BksYeMMJIo0N+v67bkS0UvFurkKMR+CXO6+4Hp84MvM5nSRoYqjkZ6zpzeAg
         zWhVOlq4tXVgrFZcNxRd0aKjVmY8N+lP8fc78=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755143871; x=1755748671;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KuAzkdu+nBeW4XQJu6RSp1V8OBm3suYsUZfkIRqSD68=;
        b=vPCHXDTnBco4PY4Br6xm04+aUKupFj38ZsB12PjXK2je2lEiUCmUmLbiWtU8wqEPkd
         LCu/6IFNen54xLa/w0nrJuk7P46lMvKZ+GtDlw6Nm0yc+w/2ilmqrPm+IUJ/PxnmQf8O
         C/Yb7tuFb1sQ0SwfsL+q90mB4z4ayxRlyIjgNSI9reLKpjNgDjEUMPD1eQTIZOcxxmbQ
         WKeNRlt6QUFSbPGTAlmtFfQq9mKFLyUz1/igZF3BwT21qAUdXzP0Jw220MsRSRZm35Uy
         VuBuUw7XSkT1ZVkcddqrqESfpDCWHaiIN2i80OesHYWvecIbkq/P0LObs7ytXOcTvFcv
         QJtg==
X-Forwarded-Encrypted: i=1; AJvYcCXeYMUcjR0OB9z4x0imhOk/qUVibp+YRdyVm5Lfty+258ChhZ+TieFG5se019jR4KvzWdTPnS9VDA==@kvack.org
X-Gm-Message-State: AOJu0YxUqt27k9B59ooQebRnjD12CPXTgH2sMjCuIaj+cMjikoEIy+9q
	DuofASY9J7TrbBnIxhz6dD2u7+kVbmZjDIuEETB2QlCBWwoEAEtJuxNzcIwKTvRhea6Ydut/6VO
	x0K+ivgc2v+6O6NH6gIugHJE/GUCCV9m/J3lizLSb
X-Gm-Gg: ASbGnctFMvlnXfcODYavgSEdmWaeZ6A5dKW6jpSzOaxWUSqJIhhQs1SgMH50rIhxKmK
	hzBL8dqx8IRmooIifUoQibpAdbfzyqNX8Klv6j/7j8Yz9k3HW+c5wPwpSBQWdpvtwaYxvMhBreO
	w2Qrk+8J+TwfxEGZ1U/6v0Ztwo7FEbFM3bWiMRTuwvbesG541tJqLrAhzJs6NZf2Y8nC7nLQeVC
	Q9kaNRZncODNzv/tvV1/ueY5lHBMZg1oMvIldJ0GWi/Tg==
X-Google-Smtp-Source: AGHT+IF+5iKv8rMK9YHb6myK/q855kRCdUIsQfOlyE7uVil4m3zuwOKJ3gr0xAyECxLHg6Jl7SqsZkrMsfX9UPSHH2s=
X-Received: by 2002:a05:6512:b8a:b0:55b:8211:cc88 with SMTP id
 2adb3069b0e04-55ce508ddefmr488807e87.51.1755143871084; Wed, 13 Aug 2025
 20:57:51 -0700 (PDT)
MIME-Version: 1.0
References: <20250812-pinctrl-gpio-pinfuncs-v4-0-bb3906c55e64@linaro.org> <20250812-pinctrl-gpio-pinfuncs-v4-4-bb3906c55e64@linaro.org>
In-Reply-To: <20250812-pinctrl-gpio-pinfuncs-v4-4-bb3906c55e64@linaro.org>
From: Chen-Yu Tsai <wenst@chromium.org>
Date: Thu, 14 Aug 2025 11:57:40 +0800
X-Gm-Features: Ac12FXwH4SzGC_raZvHd6w5DhOOOwcWIZ0DYC3dWkFgv22xak8lk2qDrshBunvY
Message-ID: <CAGXv+5EDj4JEKAFC-Sv8kyiBNy8SViEXaepdssG5QTu_HtYQHw@mail.gmail.com>
Subject: Re: [PATCH v4 04/15] pinctrl: mediatek: mt7988: use PINCTRL_PIN_FUNCTION()
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
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: D317620006
X-Stat-Signature: s39zn1q1qg81wf7jmdp1wqdaezffmbx5
X-HE-Tag: 1755143872-946778
X-HE-Meta: U2FsdGVkX1+BlcuM+djfyhQkS8SfsYTrzngF57qiIf493RlG0KH8Kp/kGFaeMfV1Qp6VpE8WqGDty7MIK5rbyObbThpq3uOAQrP9DMyrc72JSTpV6Ww4HAjDt1fBOlbmkjb9ouMDmdr+wYYvCe6/QggjHVC69JNNDg+gvjMnC65rB2xil55RJktE2tueWCqvqOL6xz+bB2O4RU8WGuwSKsJQ98GfeoyZ0HiM3sbCx/u6FfKvGd6cLSj1+x7i7czw55jrNqyRnPY0n2GvZo9abG06MumKKfLqbYID8wgYgDMzOxD+BAG8YDlUKXTmjyvhbpcb6EoM0TxB7MRclgihS+TDAaRUBM4SIjEIGAbM0VKhE8LJni8QgiX/zRNqkPBsVhmg/dmurfwJbDZi87BpAGlDbxqStd8FYJe0HoLSPZ9OD8v3UyuF449yvL6F5wORxSNpmXzNZZKDhTOx+IdB1S5QbMESdUCCcoMRMD8/+/gC6rkzWp/vPy05TBtCM70OnanX/kh5SwR/7RKFk0yCR13ZMngZqACTAupYNgnE6K42MHyviM/CgYow9qlJz/Gi+qoq8K9EU9ntqHL3v+2zrUB14PHW7+tAxKh1F/GVi3C4j1IZReZwopntemIy4tEUxDLgxTU/epCbOaaG24VZeM720+P3m0wBtnoRv8x3AoUoNWs1G76MLucStEfCSXQjbSySbPm3xlDAaGGSnc7esY1EZDdKAS6SsulfQmpiTshbkFcMh7tHku8bRAIFgtfjJkGWq3zT5PSiCnhdy56Uy2JVpGLznKcSLZO3cab/cAVwBehX35Ae2r4a/QcXGwgiWkczeCBiu65ZoC7KJ0MrD/pS5hJJY9nJ5hy5kpB3bvSuxqWfBRBqYAaszmfR3dhGC4QoHMRA2YAsm20myNZzJN+akKgk6k+ybIC0mkkckXg73tpP27FLryeEhTrPk/CY0MjBcinFMpyBFVF20T2
 nJWeADsU
 GhoSMptDxAbG+xzukr7ojkQf0eY9usaG/T/9UQbcvg2c54OBCOxtXzVlXzQEgBcP/6+4JuXStGKh7dmJrsIhGiqBON2Y1oRZmBBJ7uAnovMSeD2WqPUizsD9+Iiu6ofs7ikRfChpbwZezDfVTMQEbUo8a8b/y/DcTx6+DgyNaS2bsNage1KhBRQXI9Fa3EDPSkT4zPMYnv5pRwDGJ02T9CKq6Wol/MBZVD17+Ar1qsfFU7EzxUZJSROTmqA5B/t2yzKMcWERn144bk9gxTVeXAfN4tC1jQQ6+HXkLDiEdI7VEyKGkfP9mVFJdfrDN69PvXhRAsVoD6X7znyJf8ReQUurUyb56GV7fbYpPj5wggnQFHkCmFZmVItw988kKftV15KNUnHRcwgM9A8TBqh10XH60Jw==
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
> We have a dedicated initializer macro for defining pin functions for
> mediatek drivers so use it here.
>
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>

