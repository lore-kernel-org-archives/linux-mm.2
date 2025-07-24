Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B926AC83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 12:22:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B1BB6B02B2; Thu, 24 Jul 2025 08:22:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 262306B02B3; Thu, 24 Jul 2025 08:22:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 151D66B02B4; Thu, 24 Jul 2025 08:22:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F34DA6B02B2
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 08:22:33 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C74B01A02F9
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 12:22:33 +0000 (UTC)
X-FDA: 83699071386.14.FD3FF13
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf16.hostedemail.com (Postfix) with ESMTP id D4818180011
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 12:22:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lhqulrIm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753359752; a=rsa-sha256;
	cv=none;
	b=m+h8cs/Z51/8oOL0fQIxzAyXo6Qbozqq/hEzOpWGNTbA9+Vl39b9FdAM+LzsJOWen4MuIe
	buZHn8gcU82QIV9Nw6XzsRWmXB5SMvlQrE8JiNBcg+NvV0LLHXbANEMeSUROcInv67N6gx
	WU+bTNZ9YkGT1iMqVTAaP7YxvM4feto=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lhqulrIm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753359751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PCH9wMZuCq9rz+O+tflGRTfcHTnRU43/VMnWUAJfNWE=;
	b=2MK6Z9bno/ryPOx6yCN4N9RL+2xYPKm52yjgUAT9TfkvMy/+doqovZy+DIVyurTyVMQaBc
	qzLLLBuGBJQ/E2jBk6Ice/8Ile3AD0qpcNFuOCNMMtmbO+B0d+SLsqihPXdCJJ5FG4Venb
	Kyssvvckwkx/AetZeMq02JpY4UZrMzs=
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-ae3ec622d2fso144966566b.1
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753359750; x=1753964550; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PCH9wMZuCq9rz+O+tflGRTfcHTnRU43/VMnWUAJfNWE=;
        b=lhqulrImphDJnt48qagU++yR572csL7lwdkPJM/RPlwbCdOQ2wjogijxdDyw/vuzoi
         ddvWMvoWnj7B/hbZX+IadUPIqBCBTOoNKitkS9+2jQlLhdbCRWDJITldxP3XTzw/IJnG
         eP3Ewnr+51pyd/qqrQBcPi+IZ3+ScQxIK66lAhO7Q8WSxQMmFOHSKW/Uz7llsCIQ60iE
         XSm/+6uDAWPn5cvGIJ1wHOInPK4xMVEiQvOlakVknnED9pvwmU+ntbYvaTxTG38NdWM9
         Imd5HkuYbSOcSpAvZcogkMQfe7S9DB+eWULh2CfVW8OlremJPAwB2TceM72HDjo0c1tQ
         asTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753359750; x=1753964550;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PCH9wMZuCq9rz+O+tflGRTfcHTnRU43/VMnWUAJfNWE=;
        b=npIXOo6THsNuDKm33InjEO4R1sRXVmUFz1NmnHetk0ABlO3vQP4zz2uF8fjGUJswiF
         QxyP9IFgHToxVK54G6BdUtO6zft7BK87aWYBYHhYVXubdlumg3LvOb1Jv88Wyex1AuoL
         RFfbo0abhh+6XcTpXdd6ojJemLkN4LKxE+xe04B7d6D3NmPf3oCn7ZelzSOwIcv+ZVtx
         K2NI3RKBNRhcUZu0WSKrfpaD6skL3Wx5P7lua6R6ZxPD5HrwuADbiciYn6baMDvioTkn
         0FuLWASdaKBaYSuqsIDreqx0thLKElnMQdMjDaJypGnSfRxwbNHg9GUjy2gnmF/k9MnX
         9U3Q==
X-Forwarded-Encrypted: i=1; AJvYcCXgjEOZeXlhCrKBzMqY6GYBHSb0egh/dDcvUxcdY7rCbSscELODQpk2IepVUyfVN4LncQn9qg9txg==@kvack.org
X-Gm-Message-State: AOJu0YyaHcjm4pgLOmJApuSevfktD1fGHkV/GiKBYKJZHs948u8mNxG5
	YeXRsT+M0SBRO6GJmf06B3lVkw5EHmMpIMUdsPIDkjwIlT0IDsIffVbbgoQamAWFcuzKZvBHdws
	M5zp9C0D/3xbN7xwg5TSaUltLRyt9YcQ=
X-Gm-Gg: ASbGncsnoKc4c1RM2XfFzr18tX3AHJduJrfPDLIGMjWPngCqDhogedA2YOqV9bivsLX
	jgGQHPWyAlykwn8qKo9+lGEsL3XOtDXNse1QBqag1DIiGT5B46QOiOxGGt24gGuhpYzSYufMtGv
	lQ9K+z2yPNFGiwEwdQV9C7qUeG0CNzWyQOCzuAx71JFYgzq8PBKcUU15aKJfdqwrvpc9R4OuLDa
	gnp95JN6g==
X-Google-Smtp-Source: AGHT+IHK0IoDJ6PED5zWXfzDhpKgh5VZvydISu4XMaUvDPUT/I7krIj8dXVVfHCUqibcmSSRfe/rVr8gG8zy8ado+mw=
X-Received: by 2002:a17:907:60cb:b0:aec:6600:dbe3 with SMTP id
 a640c23a62f3a-af2f9385acfmr671282766b.56.1753359749816; Thu, 24 Jul 2025
 05:22:29 -0700 (PDT)
MIME-Version: 1.0
References: <20250724-pinctrl-gpio-pinfuncs-v3-0-af4db9302de4@linaro.org> <20250724-pinctrl-gpio-pinfuncs-v3-12-af4db9302de4@linaro.org>
In-Reply-To: <20250724-pinctrl-gpio-pinfuncs-v3-12-af4db9302de4@linaro.org>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Thu, 24 Jul 2025 14:21:53 +0200
X-Gm-Features: Ac12FXz2KOnsH_foq66JE5xieoDhq1Ik71OykKjuCvc1b-KzV3FeiggPCBwSd4M
Message-ID: <CAHp75Vc4vsJh_-GbP+YO50veoGoGtfAPL4tjcF+73uophfmnGw@mail.gmail.com>
Subject: Re: [PATCH v3 12/15] pinctrl: allow to mark pin functions as
 requestable GPIOs
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
	linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mediatek@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-mm@kvack.org, imx@lists.linux.dev, 
	linux-omap@vger.kernel.org, linux-renesas-soc@vger.kernel.org, 
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D4818180011
X-Stat-Signature: 5jtbzj3seqz5tww11p7b3er6rfe8n3u9
X-Rspam-User: 
X-HE-Tag: 1753359751-434304
X-HE-Meta: U2FsdGVkX1/VfHCvSOnBdIOWg5xMechJb0Cwny0/c5OHXcu/BzKa+A7iGsMAukVIwNlhbUWsM1vatCJjsSw65MDiB/y9atlkSVhk7lmX6EPaW5jpiQ11YpAr3KIroyyBfhUP3DDi/CnaxTPVhsi2QJYme/ISfulQeUbao2sk3o8tWsYguGPNVf0Rtt4gKMc8Ds2ZZzT4U/TGO9FgiY4FO1d2KiSOUAsEEOV1F/dvLByUqYK5RNeZRisPE+sQ2CD9ptqlhyh8IYMuddZt9OCcHLAiAUbdFsPsQRcQFkgNetwPHMc5dtg2tyP0uu3UDD2el43WKn7wkq1Xv3IusEYivNFJ9YO9FyzUcWAZX/TWm2dISeykHHqPbULv57P3rzQzMv5W9XE5tb8c0Qjnw+QbMku0zUoGZ5P22qRUdvuULZYu2BDPaiQXOw4TlDcaGhm7JnV4Mb8TyhfFJKt/8vDCLDZtMmYld/zgJPw3hxlDuwecUPmXZsPFBDCW9xIXbyGwi1FycRqI1ToZQkS9/m3njVhVRwinQj51UV0OpYHIKxXJuLdN8iBQV8q/qlC7iBs7WXQuOMcODTVLX2VGLuifOYr5KMzBvUVsjn7zaO1yHcstNAA+cC0uj4DyNLsxFdu004gCd/U6Jb69PUOwElEM42yGGFqZN5Pc5MAZh/WEnzVxIHNuVg0ka/RkLgdP9QNmJwuLO86RLqexQ04JXJuXDQjFV5O+dhpETBrBYBwWXCy9uqaaQBdxObsqqVTOZOchaGnRNpwcfTw733Ab6H0j53tXAqEzOiqjWab3PNgrNrffQX4Ts+YjAMicLphYIOyC+8f5+e1RtJf2ghDsEqp/ZDl5nuRh0mBjeXIoY/Bi1HmbwAh07aOji4M2s0avSvKS6HLNDAw16rF43AD030gx+06gz+BRqHgRQ9XugkDj+kNsu2vZ4+ZphlsasUS3IzctNDVJ/aiGh83frU/bLgp
 qdbeWvFy
 /3nBRmSX9TheGt0DxTxhsccPgQiUr/JJnbOAQrcnTfAbdHk6Fnn10BStJSfXSdXNkVx6PtVWg+zEcys4Qsj/K+j46Sg7AMuePaOW/ir3zKL5mGzuIGeCbdAoeykiQn/VTmpR9UoXfrDSCPx6Xk9dmqWgIBwDQ0eimxkbiwgXvA0Hy8cK123/6LphzjeiXjzvATYy6W64isZwxWG12ASHnHv79OsXHJXy2Yd9uNFykyFVWGjz3maWQTi2PLaC0qaNcoCLZF7o33JFP5ZGXSJ+hunOJBqKIR8OfLwLgngcA8aK5vfSOes36F2sshXYghE3FV7aB6Cokvcwbhqfqs1F5mQN3EDyTL9KdJHjAtb680rlLRnyOjFVdt6OORbEYjYKpzO4FIZKCI9Hw53Nj/qprpKQbRilI4NtEjMVoHwD0yoNwRXB2pd59bxpI+FBpIEg/3lUcYKvy3Ej6k5Aj8iGTEqWdUQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 11:25=E2=80=AFAM Bartosz Golaszewski <brgl@bgdev.pl=
> wrote:
>
> The name of the pin function has no real meaning to pinctrl core and is
> there only for human readability of device properties. Some pins are
> muxed as GPIOs but for "strict" pinmuxers it's impossible to request
> them as GPIOs if they're bound to a devide - even if their function name
> explicitly says "gpio". Add a new field to struct pinfunction that
> allows to pass additional flags to pinctrl core. While we could go with

passing
to the pinctrl

> a boolean "is_gpio" field, a flags field is more future-proof.
>
> If the PINFUNCTION_FLAG_GPIO is set for a given function, the pin muxed
> to it can be requested as GPIO even on strict pin controllers. Add a new

"...the pin, which is muxed to it, ..."

> callback to struct pinmux_ops - function_is_gpio() - that allows pinmux
> core to inspect a function and see if it's a GPIO one. Provide a generic
> implementation of this callback.

...

> -       if (ops->strict && desc->mux_usecount)
> +       if (ops->function_is_gpio && mux_setting)

Seems mux_setting presence is prior to the GPIO checks, I would swap
the parameters of &&.

> +               func_is_gpio =3D ops->function_is_gpio(pctldev,
> +                                                    mux_setting->func);

One line is okay.

> +       if (ops->strict && desc->mux_usecount && !func_is_gpio)
>                 return false;
>
>         return !(ops->strict && !!desc->gpio_owner);

I think this whole if/return chain can be made slightly more readable,
but I haven't had something to provide right now. Lemme think about
it,

...

> +               if (ops->function_is_gpio && mux_setting)
> +                       func_is_gpio =3D ops->function_is_gpio(pctldev,
> +                                                            mux_setting-=
>func);
> +               if ((!gpio_range || ops->strict) && !func_is_gpio &&
>                     desc->mux_usecount && strcmp(desc->mux_owner, owner))=
 {

This is very similar to the above check, I think at bare minimum here
can be a helper for both cases.

...

> +/**
> + * pinmux_generic_function_is_gpio() - returns true if given function is=
 a GPIO
> + * @pctldev: pin controller device
> + * @selector: function number

Missing Return section. Please run kernel-doc validator against new kernel-=
docs.

> + */
> +bool pinmux_generic_function_is_gpio(struct pinctrl_dev *pctldev,
> +                                    unsigned int selector)
> +{
> +       struct function_desc *function;
> +
> +       function =3D radix_tree_lookup(&pctldev->pin_function_tree,
> +                                    selector);

One line is okay.

> +       if (!function)
> +               return false;
> +
> +       return function->func->flags & PINFUNCTION_FLAG_GPIO;
> +}

...

>  struct pinfunction {
>         const char *name;
>         const char * const *groups;
>         size_t ngroups;
> +       unsigned long flags;

Not sure we need this. If the function is GPIO, pin control already
knows about this. The pin muxing has gpio request / release callbacks
that change the state. Why do we need an additional flag(s)?

>  };

--=20
With Best Regards,
Andy Shevchenko

