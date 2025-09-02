Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63F83CA1007
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 22:18:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BA526B0006; Tue,  2 Sep 2025 18:18:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 891976B000C; Tue,  2 Sep 2025 18:18:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A7846B000D; Tue,  2 Sep 2025 18:18:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 69DA86B0006
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 18:18:34 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 14D341403F1
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 22:18:34 +0000 (UTC)
X-FDA: 83845725348.19.1637CCD
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0BAEB40011
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 22:18:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=GMiLl0LO;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf12.hostedemail.com: domain of linus.walleij@linaro.org designates 209.85.167.51 as permitted sender) smtp.mailfrom=linus.walleij@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756851512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=li67uZ6xqKQCADV810jgcapd5oaTXRr3DZZuD3FIP0o=;
	b=eOvCa+NK7fEBP3LJ0e84/7KuJTx6s4943Dc7M/oY3DHNj7aeQCT44/iMZk0a2uZmdCHiHz
	VhPW9BYhQlJa6ApzuJ/dDGFXaul/CBJJrqHZs6GQ8McJSCMYy/4neCkusMMYwg/DYkwD8j
	l7kDwhpjuZtWKUvy8G2HBeGZWmtzr/A=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=GMiLl0LO;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf12.hostedemail.com: domain of linus.walleij@linaro.org designates 209.85.167.51 as permitted sender) smtp.mailfrom=linus.walleij@linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756851512; a=rsa-sha256;
	cv=none;
	b=eCa8AtkbRKmltqQOMxEjvS7lwdl6dRhuctohw9xGEIQLm+5tJ9+5JDS4na1d6cMN59y1K0
	7Mks4mOPERwzGmVo047zoyWCPG1m+Q4H8wbnHDFlFLxDO/fnZ2FMJNCTjvmdqiU6CuWqnm
	alNgaaIRJt7DCFOjb1oSA7DEat/W41E=
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-55f69cf4b77so4243668e87.2
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 15:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756851510; x=1757456310; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=li67uZ6xqKQCADV810jgcapd5oaTXRr3DZZuD3FIP0o=;
        b=GMiLl0LOZGhOU2OmyY665XBm4Wa25NWLR6kJAwb0PsduS5URA8u5lqBq93To1d2smk
         oBCiRpEp9QUBgYl2PDVmEcD9l2aa/hId5d1ehIcWualixO+Lv5PuNzsuniOGZoo32yNu
         QpRrfJZUnCUwkn71zDVu7H5cofM5lKud8ggUZQUfsSee7+Zm/98Kh5ShGDJlU0LYn1IZ
         wR7EHPqUu6XZwLMiE2C3TthbnjM1xjoIc2coqVnFns054OKBS1ER8kIBlIF3Ls/0SLYr
         b2cDpEQgdj2YHYdQFlZ5tFK/Wtoqruqp6z1jfXcT4jeP8qKPbzjMAMsLQmLt+0ulqzSe
         EomQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756851510; x=1757456310;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=li67uZ6xqKQCADV810jgcapd5oaTXRr3DZZuD3FIP0o=;
        b=OmhTftUwPa0I+CAnMKf1z8kClDctGGSJC0P6CQjoRpC3B21JVD6OOcEfcOWbMeeCl8
         myaDg5zwcaQdY0xWK1QBBwNfxW+uEDwhYTmF9ohR+kOOdDPFV71UHjrYhuly0UW8wHzw
         /qxDEjvsvHjFjiYYw7G4NQnAJvZ/Rr0fU9xadCO5ELojchJA7Z4vzsyaMFlyWEBNIy3U
         aJ2RHzzJz1PY5wy9CzbPzcarZbw05y4viDm4rE+ncniEnNUxrUvdCFQgYE2zDbCkQlL+
         HNg8HY3Q0zGJbczfn+jL+9MY+DbsvNucn6usmasp6OBgEiFEOq4CVRxJTrMSY3HMLMRS
         esrw==
X-Forwarded-Encrypted: i=1; AJvYcCXiK9Y9ESVnWp4nl2jpHssVfvjN9BFdNhOCxV1WRFIlUopzgdUV6zAXy8WEq5xffJ8CbqLwUK3oJA==@kvack.org
X-Gm-Message-State: AOJu0Yx4VJg/zTFeUR3ZcLUyPGp4tewP+1HUS6e9+xllL39/xS1oj7vO
	ZjyVjQpl0ox7EhADwS5zyaIRQhFi+pUbRZkOT3kHoB+BTRn7i42j2D71vBIugVLufYPS+2KTEoz
	VtX5e0cwLBi034RuUSPtUCFuL772TNhrL4WCz5zbbvw==
X-Gm-Gg: ASbGnctPP/sOhNv9uo/Yp3viRRgxj+D9ZEYBBilvFXTQmGqq0yxLlYiHed0EhSMMNNv
	sbSPQCDXaKAvEG0HGh8pYVMRTaZQcdld8nsqIZsT5arruk4EUzXIDSLMBk8lBlGZOw3xo7DxouI
	o99esGK/kNHtBPTt/fA+zDoHIhHx4y88HXBKjGztvAeHJhJj9WjD3fbZTyzgpW8XDdjulhTn8mE
	mMgxy7MmCLKEwkV8A==
X-Google-Smtp-Source: AGHT+IFb5FJ4SVuaW/MZYjqlxiCtjVdy/Gs9hCmULK5gWsYMbnHTDsvg0XfXKbqBDAFJs9xAYF0giEeS6uNYA+ao+FQ=
X-Received: by 2002:a05:6512:3d11:b0:55f:65fc:8db5 with SMTP id
 2adb3069b0e04-55f708b9c56mr3711945e87.23.1756851510074; Tue, 02 Sep 2025
 15:18:30 -0700 (PDT)
MIME-Version: 1.0
References: <20250902-pinctrl-gpio-pinfuncs-v7-0-bb091daedc52@linaro.org>
In-Reply-To: <20250902-pinctrl-gpio-pinfuncs-v7-0-bb091daedc52@linaro.org>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Wed, 3 Sep 2025 00:18:18 +0200
X-Gm-Features: Ac12FXw-1tPuaZxU9kVS8RfwbL5AeZ_YF1A5IdRwoR4crjvnC6JAL_oHeKPOKoA
Message-ID: <CACRpkdZ-Toq9MziPisZCcT7zcL3rosQYZ1Jw=RWCH1KZTbeBug@mail.gmail.com>
Subject: Re: [PATCH v7 00/16] pinctrl: introduce the concept of a GPIO pin
 function category
To: Bartosz Golaszewski <brgl@bgdev.pl>
Cc: Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
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
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, stable@vger.kernel.org, 
	Chen-Yu Tsai <wenst@chromium.org>, Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0BAEB40011
X-Stat-Signature: 8ci4p3fn366w1dxtbq9o81bcnj9d81fw
X-Rspam-User: 
X-HE-Tag: 1756851511-430281
X-HE-Meta: U2FsdGVkX1+l6rIUCOuZhV7XrjhE7LL7iShtWU+YPDWlrufjkkxtUniSFvPVv8PmAD4mcUwQ6lYz1LrcbFF6z4J3uK44QYxu7bBMOhCnuMgmtCu7QxDSJN316rbQR+f1votOd7ghUuogpLaUsHTWnGQqFG+Bl7JqpphIeMAwTMij/rRmeYKncSPGgM2Qvq5J/fzj1itScHTQhqM5YYgIM+U95ctMLZaq9spNMG/UuSyZ0BhzBWLTQHhDFS+yGQ4/A7PhEY5Ixw1gnWV4ogy1l+sSqNVjz6rJJs169++5QCqLiDwSwldDQRXoFDU9RNbS8SGflcQuaHgep0il2HPWNIxY1/pqQZAw8eTz0y91ABXSf/oc2KT2RwwGP8mkfJc6mmSL7u52gbjnOPSZa8/tqCRt5j5PwMeXowcIMsvEAEJ1jD0dQHFFS1CGABCvn1W4PYysU9rlRk92ykoLvW+GnzshlkqGKcoRuaqSX8De1ezyjExRpxecsWE3Fc9CHD680TqcZzkiqMk+QH2RMGVSv37sWth63IvnFXkjJsmZCfrktLlgScb7Bjp0VpAEl3fKlSXmOdp8NpxI1uDPNK7icnQSJ5mTwMNwDYxpW3PrLMCV2t4yO1qLXYoFyrHNvN4KqJ4275TrUdbTATsmY2qHQhApqSfrCsx5seu6G4iB4ja9HyLa5uVb66VB4g5paCrrD5VONGIOhyNrve85GxGpqGFXjcmy+4mlsFwtW5Kpal5WdJIrKsDm8pD+O4KpzWyQwEzc4ut9Av6jrVCKLtzOUzx56vw5ADkmr9nqHKnVOdOhhFQocDyDkbDEOBi3GqkArsMHOFjhGHftYaV5NG0uhshOiqvr1pmD11mtqgoqOb9zuJQ7mSCtAeBj4g+SR5v+W/1lWI4AMGKG4dGd+IaEUWAq0ZPaOL/VXrDmuJ39cP5/+Uexa1ydNszZP+M52qR1OSVbqvtzMDPzhwVlM7k
 s6yhkSdn
 nxerFTE9V4T309ok8zmkOBdcF02P7BRSWLArBvh3t6T2CHpUL/jTm+5DP5v6lHPWstCBCaEACWn09bZDAboWkzfvn8kNqPMTPrfha2pnPh3fRjUpkyhlZHCde0IiRbsMCxVFro9zzGtknKPelYa6QX/Ciy/o4VblHqf39QX43ic3JYKbGsBaW+O6K+ehngmK1V32FKyTh2FuzFt3z0iKz/g3YlCO0s2Q70T1Uf016Ba3GobuH9/oW5ZDn6nhDz4c6XjhJ4I0fReOcEQQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 2, 2025 at 1:59=E2=80=AFPM Bartosz Golaszewski <brgl@bgdev.pl> =
wrote:

> We have many Qualcomm SoCs (and I can imagine it's a common pattern in
> other platforms as well) where we mux a pin to "gpio" function using the
> `pinctrl-X` property in order to configure bias or drive-strength and
> then access it using the gpiod API. This makes it impossible to mark the
> pin controller module as "strict".
>
> This series proposes to introduce a concept of a sub-category of
> pinfunctions: GPIO functions where the above is not true and the pin
> muxed as a GPIO can still be accessed via the GPIO consumer API even for
> strict pinmuxers.

This is what I want for pin control, and fixes an ages old issue
that pin control has no intrinsic awareness of if a pin is muxed
to a function providing GPIO.
So patches applied!

Any remaining code nitpicks can be fixed in-tree, I need this
to be able to apply the much desired Broadcom STB driver,
so this needs to go into -next now for cooking.

I also want to strictify some drivers using this, bringing GPIO
function awareness into them, which is a good thing!

Yours,
Linus Walleij

