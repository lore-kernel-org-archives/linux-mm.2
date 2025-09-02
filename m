Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D646BCA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 17:50:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15A548E0003; Tue,  2 Sep 2025 13:50:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 109B38E0001; Tue,  2 Sep 2025 13:50:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3B208E0003; Tue,  2 Sep 2025 13:50:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DF7678E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:50:15 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8FC9A1DD824
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 17:50:15 +0000 (UTC)
X-FDA: 83845049190.30.910C511
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9A1671C000D
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 17:50:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=z7qdAtee
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756835413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qq79ok73NgzUNSPN3ElH84ehBnROIulXyA0yyA4cddE=;
	b=swkYMKoL/M9CU+KMbm7nq/LDiKOklsVuz7xmBXrMGjYVbehq3rS6UYDBYtTZ/Hu41X788r
	LAoLmv+ZIUPckvTs7hZJ95+aLm3sd5yGsM6LsQ2MAIDlxDO6ICE84ONvDr5jvt5Tw7/5Pt
	TvM7gNa4VEH/+mcuumYAOuaEnTJHWQg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=z7qdAtee;
	dmarc=none;
	spf=none (imf20.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.167.54) smtp.mailfrom=brgl@bgdev.pl
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756835413; a=rsa-sha256;
	cv=none;
	b=yckG7qgzzPwyQrJTQAQjmUihVO3ZlnhBxJfUaFYL+fT1HtaQ7iWJd9ziiRslbc8Gk3qAJo
	cWBBwqB+8xEt5NvtfHF4Un95p07nMFXspwxvArhqOcYdjDU/ytrSWnX4+RbH9oPEhLGcCl
	AnSKkj+0ROC6y1wUK0AkqrMrZafQHHU=
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-560888dc903so433259e87.2
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 10:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1756835412; x=1757440212; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qq79ok73NgzUNSPN3ElH84ehBnROIulXyA0yyA4cddE=;
        b=z7qdAteeedK/dTc06AnYQ51qw25wymD5h1IEOsZLRHXexvBMYqea7r418g9lIgrZyR
         lAw/CjIMmKFih1H2b7wt5jLIbkQYOiQMlkwk/yqKbz/dkkXM19HOtuecShWjxSVpf4BD
         CsXhVvAwNYdSqiZ4AMfkR5WFri163qxaEHwGhzMzDzaHaXB4SlWejZtX8L+L3Z+PpYoO
         WBz1NPuza3/3kXaL/w8SMmYs5ny0CZ3GpinuBgHZcNM+y3OrQZjVCsUDsZNxLItdq1cX
         E+pMApgrH8qPayY68MrXAxSGjqInkibT7fjvPRWdc/As8UJBNSWaVh44noaK+LsScZFU
         SaFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756835412; x=1757440212;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qq79ok73NgzUNSPN3ElH84ehBnROIulXyA0yyA4cddE=;
        b=KnzG1/2Y5e2fq0BG3/yTgeb82MdlKlhJlKtYnKAN10o7FBSXeeA7jaE0UebOvdqHXl
         q+BE+xPAL5bxE8+iCleWNXmMNhyihVeUgkzbjZMsJXwnNkxg1i9XUy2ppGnbdJ0lmXb0
         /N6obocQE66ax5+lPfJOEo7bAmsK4mCERbPgGnE4HbPqUjMYwbrYB/nzgpC3FJwhYoch
         r8ZE1Xh96lwI3vKZttf8WagX8/DrAH/ovJ1l998C5I/Fxk8Md2sSFU3IqZmzNKbGEBXP
         FBqFYfYIb6r9um6u8x9Ai+RGpLRjlwSnBamPwHOqcb1IWxBy8XD9tkZnESy4yN3Jb3yG
         1aOA==
X-Forwarded-Encrypted: i=1; AJvYcCVejWlXrGApwZnJI2j3wf42H2xM0ds6jgSXoW90PWkO1zV+i5G1hzaISJ/I08ZxhEqOJGcS5jy5WA==@kvack.org
X-Gm-Message-State: AOJu0YwvgKSjUgUjUhKjYugTWPe9QU9S2MTraymt52oAIKn1fjPC7U/N
	y+xGkpZ3S7FQWlSxMr2I5Ik7qZ5OviAblN9fmPBb11w1/mDQLU0nHgmh6IMhsX38SNWq64I/3/t
	v9QM5FL9jLBVp7ZLqG6qmYS+/0cxyyUjLOeO9YB8DSA==
X-Gm-Gg: ASbGncshkelKRxxIGjuXvar/gRdSiB3Uplkn7nHtEo4jTnjhFGi7tFbhJYYQ7DkgHMT
	LzExjp49KZurYEqc7TOV+QBJX+iu96tsPoma5prBIZ4kO2mPmuX6Tj5tqvUtwmnZ1qLDGCVvzsM
	8W9aWb+Y/2K5+B7YMn9OzJTaOanRKwl5a9JkcvNV/P9lrg7kr46XdUhuZoBiFIaAn3O9AQHG9sz
	KQnWQQCmM5GLSyZVnWKTrvmde91pWMFjS1iw1YQIR9TzXN4Vg==
X-Google-Smtp-Source: AGHT+IHWxMY/UX5pahdxyPomER2R5wCG7WJNOYIC76WLDnRgZXryLWeY1Ce628zgGwqGftmJqN1QawcJ1KuqTk6lVI8=
X-Received: by 2002:a05:6512:3b12:b0:55f:4f99:f3c9 with SMTP id
 2adb3069b0e04-55f708ec830mr4334057e87.32.1756835411674; Tue, 02 Sep 2025
 10:50:11 -0700 (PDT)
MIME-Version: 1.0
References: <20250902-pinctrl-gpio-pinfuncs-v7-0-bb091daedc52@linaro.org>
 <20250902-pinctrl-gpio-pinfuncs-v7-13-bb091daedc52@linaro.org> <aLb_pOG-yc-CHoiY@smile.fi.intel.com>
In-Reply-To: <aLb_pOG-yc-CHoiY@smile.fi.intel.com>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 2 Sep 2025 19:50:00 +0200
X-Gm-Features: Ac12FXzmJRg8_mGsvbk9kTYEAk6i5wfrx-8rp8gdl4L5LHxLn-6rA1BsDeyDmdo
Message-ID: <CAMRc=Mc-NEFawz11Lr5JGStoe=PU7b91E-MVB3xkdBr_JoiStQ@mail.gmail.com>
Subject: Re: [PATCH v7 13/16] pinctrl: allow to mark pin functions as
 requestable GPIOs
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
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9A1671C000D
X-Stat-Signature: pznqxatsu1pptr918trr4dsee4dgznau
X-Rspam-User: 
X-HE-Tag: 1756835413-230411
X-HE-Meta: U2FsdGVkX1/LaJmH7Zi6ErCqZXDcMM/DyFfFPI4bQB648MfcT3WcN2xQLUdG3ZEWyXdxSzO1MBwD2cXbF/0eJd8oBGEPh03eajevuHGpODEBpLkJaecf4aVHhnoIy6FNgab5z0OqRrZXyrraUaMiPAFcl+sgORRyUUy8RlqU8FlECHOGjgDY65oHL1oqW3ee1mnkijmM5VM+EGj8dMm+J1sSiyYysZkQpUhdu9GvGpDwsM7cvECOKGhknm5Q4z0/Txrqx8NEpjzmh/Wi8qI8qhZ90hOUrtRZNF8nnp8ZHrFZBgOB0jrWO2kHazzoJVvzyGUM13hINmVV6wtslS+zt1LetdsaLbE6V5RIpsaF2e17rHs6XiOmI1A7FIlmKWQQ1mciCYbFFP23+31bZO/jKGFdpFfR1yoc3RY7oCrBaqVwOBXYNZrUG1pJhJwNnOFevcjcUy0a66lxUf0suyeJgzFY1e6FQzlq/76YrCHuBlScgMcVcGqQE2DOwnaz2B2Eb3t9nwdBLg+0wqCxpqM2+gpVg0oEcz32T8u0/nzTNn0gdVEZFQBuTz+Xkxpm//2HRNzgMFph9w9XsqyFk8K59R8+m9JEJYQ1HB2BqsJ4wtGTFVEJgFlbP3PXNl3j7gRYEw8FzM/pD7hTMnoeSPDMOd3HHequi2fAVqlU1muY2rgcVnDOJ3pqbhBjMWWrORt9IQkfQun1wjI55ySg/nRU4MshZblapmK2AuI1xgU4JRROCiAFPbcZppXESBcBlMZX/pf1r2/HoQoeO52XwZSyjwtXUPg+llg/MrZ0r3ezuMcc9TqaOTjXOAzRHzbCGQ3I0WV9seHcnyA9EdikIL7yakpUn4AZt2tvYDloZc2nIuVOykbhE7mUb5/muXyUMhNllyGeFrrkkabsIY2AC3BCth/dGLWAsYMsOYVXhE/Vym9BZ4upquORhibqpNkxma+zf0OyE5KRjHP8Ec8bayM
 nZnDC85c
 7zTBsy0ekwL4Sk3IFKgCfvK8JRu0pS8LsxzbUogIQFaHmfE4uLNqtaxJuZTyRzuscRbiRZSGlEBK1pFmpokDTQZMMg59AAVK6RX7Qz8kKLZdQeYB1h4WSk2GAyohDWf3i87UwCVjuNzgcLWP+ziwt4yWmkdxMADMnPCfYz/tUohGAWkoENapb0S3gjygOwwVFkjpbre0CXynydy00gtqkILumwByAHiWeUz5My70pWwz2zyHT+MhcX2xxEm2WxwwsggwjcY15DgfLpl+YflzFvcE3/rL4xL2IgfvWjZh5y2+vlkw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 2, 2025 at 4:31=E2=80=AFPM Andy Shevchenko
<andriy.shevchenko@intel.com> wrote:
>
> On Tue, Sep 02, 2025 at 01:59:22PM +0200, Bartosz Golaszewski wrote:
> >
> > The name of the pin function has no real meaning to pinctrl core and is
> > there only for human readability of device properties. Some pins are
> > muxed as GPIOs but for "strict" pinmuxers it's impossible to request
> > them as GPIOs if they're bound to a devide - even if their function nam=
e
> > explicitly says "gpio". Add a new field to struct pinfunction that
> > allows to pass additional flags to pinctrl core.
>
> Which I disagree with. The pin control _knows_ about itself. If one needs
> to request a pin as GPIO it can be done differently (perhaps with a new,
> special callback or with the existing ones, I need to dive to this).

What? Why? Makes no sense, there already is a function for requesting
a pin as GPIO, it's called pinctrl_gpio_request(). And it's affected
by this series because otherwise we fail as explained in the cover
letter.

> On a brief view this can be done in the same way as valid_mask in GPIO,
> actually this is exactly what should be (re-)used in my opinion here.
>

Except that the valid_mask is very unclear and IMO it's much cleaner
to have a flag for that.

> > While we could go with
> > a boolean "is_gpio" field, a flags field is more future-proof.
>
> This sentence is probably extra in the commit message and can be omitted.
>
> > If the PINFUNCTION_FLAG_GPIO is set for a given function, the pin muxed
> > to it can be requested as GPIO even on strict pin controllers.
>
> So. this changes the contract between pin control (mux) core and drivers.

Yes, that's allowed in the kernel. The current contract is wrong and
the reason why we can for instance confuse debug UARTs by requesting
its pins as GPIOs from user-space whereas a strict pinmuxer will not
allow it. But to convert pinmuxers to "strict" we need to change the
behavior.

> Why? How is it supposed to work on the really strict controllers, please?
>

Like what I explained several times? You have pins used by a device.
User-space comes around and requests them and fiddles with them and
now the state of your device is undefined/broken. With a strict
pinmuxer user-space will fail to request the pins muxed to a non-GPIO
function.

> > Add a new callback to struct pinmux_ops - function_is_gpio() - that all=
ows
> > pinmux core to inspect a function and see if it's a GPIO one. Provide a
> > generic implementation of this callback.

Bartosz

