Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED00ECA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 13:02:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77A888E0031; Tue, 19 Aug 2025 09:02:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7520E8E0009; Tue, 19 Aug 2025 09:02:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 668088E0031; Tue, 19 Aug 2025 09:02:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 513A48E0009
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 09:02:03 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 164DB1172F9
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:02:03 +0000 (UTC)
X-FDA: 83793519726.26.52C4DBA
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	by imf29.hostedemail.com (Postfix) with ESMTP id 04230120017
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:02:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=P6PXGCxy;
	spf=pass (imf29.hostedemail.com: domain of linus.walleij@linaro.org designates 209.85.208.170 as permitted sender) smtp.mailfrom=linus.walleij@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755608521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qxb1RM5Ht9n1r5SEfzEp8KCVi3ssjTbIBjJD7cNdVUs=;
	b=q/bnVpqCog8Esk5gPb0kFGPJwXnNNoI7m3rqaSYmvWBK/IRF0E6eKhNJjAwlJENU9iHd39
	CQ4Rl10Unfap1xKZYIISnRpeIFQtqVV6jZzWxgNf2VP+IJKb0vi45LsnEj8n0mIDGm3VhX
	bhhr5Fv5v7WJEjjMeTr4tgmDIjm2Hww=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=P6PXGCxy;
	spf=pass (imf29.hostedemail.com: domain of linus.walleij@linaro.org designates 209.85.208.170 as permitted sender) smtp.mailfrom=linus.walleij@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755608521; a=rsa-sha256;
	cv=none;
	b=PjZTmnwrhDV9sZFA1pIlVjgmukP1EkGKXdnFZcXdltC52FRK2JnUNoykgP6J3oU5nmvqwz
	Mw2MD45urprr1PzFpS+jl182Q7I7rCSSf0iX+3LaCjKkLqhASZf90vQ9sKzjcvaB2GpY8T
	zXMPR6RAaR/TZkr6C+WmH3N7jvXPXYc=
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-335360f9b6aso2887781fa.0
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 06:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755608519; x=1756213319; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qxb1RM5Ht9n1r5SEfzEp8KCVi3ssjTbIBjJD7cNdVUs=;
        b=P6PXGCxyG0cto7eupl2WnalTfIIYt9VM7oR7UvbGvsyCmooZhQjUjDBM5bg6j+ed4C
         +e1N1pABDaBrwt6LQtD3HxzUh8Bfw6VmG0hZwPrqmG1KAyV4DPnqxFtrWfUqusB6Fo8o
         dI1kU9iYsrWFDHqksSCcAbgBo6XqhHQTF6jlqX7RbDH8DGBduiLAiyeIHDkvWiz7G/Oy
         pk+lz2XwZ++tVAHCTHZbkkbaoXn/HAnmumoB2Aw5+Bkz6bpICZu2/2qQMzQWOS9IdigK
         nP+RkdCE/YTsZhzIFztzY/tnlO0cm5D8bS1UNVsRYC9VCj1Fv1ceeLMmd6CeylfjWv4E
         JSBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755608519; x=1756213319;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qxb1RM5Ht9n1r5SEfzEp8KCVi3ssjTbIBjJD7cNdVUs=;
        b=iNnPa3UOFlO0jBM97meREZmj2lqA5eGHj6n2Ps3UjRXiAs+jIpAvWfbJYox5XRJOk6
         uyeU7nhw+4bKBrcb5AHg/9GgaGz+PpllqNzj0FZ9otENr3mIEfF7bHMymlX186XV3S5a
         i4g2iN28acGeYHDdzDPIYgQWw+DlHZPDa5O9qqCcnnXNDZHXqILT9x3L1YI/B6KnBVbJ
         /G6pQMxnq/p8c4OXiAclcTXbe62JOp0KjSTUqml2xAXjELnAP/mI6+tXASeKePOvoyK0
         qSsX+Hy5Dgf9kgvILcm2PA1VA8m5jNQkbHOV++jKhzO977tpszEgb0eY1Hj/csI9HqL3
         3aKA==
X-Forwarded-Encrypted: i=1; AJvYcCW0yDMPYbJh+haejn2C2x2Yba7+vNBGGRNmrFVt9Fxa+PJmtC36IWcbY6ynXPaimWrcgumkqtZ0Zw==@kvack.org
X-Gm-Message-State: AOJu0YwbtwvFEHvGW0zildhFz5BlkHYFbb9/BjutWYlZUX0oc6hUfjqc
	jxemk8F/v5ZOM6OAq+Sz1kPbg6f2c+bzhVTSdjUNQkaAyKwaRw8UdcdTgIwDfxkfOkNIi0dGSky
	NKoT0bhFXB9ogp1k2z7km6uF+N6N1Ezywse/qssI5jw==
X-Gm-Gg: ASbGncsRTWeetQ9TrFbMp2nYL6xQrB99hUQ/uU6OcexsRJgWzh4WPGkka6jiKqOwG3q
	jdEXu/+8ndZ5Y7FRs5F3nh2nNAlP48zFA1EgnCZ5px2dTD7lTBHpNDbsqK9JN/OqD+pztZUjWrq
	wQDdduJr//UjkpXbmJ8n/XW3X94GlchFAzVBr4Ckr+8CixqQIdZfioqLDQosg246LUN1gLW3YIY
	Tuqxio=
X-Google-Smtp-Source: AGHT+IE7bjsIxvb3/p90/iX8lbM0JfYfSlfdYQ83gKcwpD46fl2MWv7BXJs8CRajKFvUVpb0cf1UMxfJ5zwUc8D1bZs=
X-Received: by 2002:a2e:a490:0:b0:332:20c7:2820 with SMTP id
 38308e7fff4ca-33531348988mr4833881fa.5.1755608518741; Tue, 19 Aug 2025
 06:01:58 -0700 (PDT)
MIME-Version: 1.0
References: <20250815-pinctrl-gpio-pinfuncs-v5-0-955de9fd91db@linaro.org>
In-Reply-To: <20250815-pinctrl-gpio-pinfuncs-v5-0-955de9fd91db@linaro.org>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Tue, 19 Aug 2025 15:01:47 +0200
X-Gm-Features: Ac12FXyC72fjsmfBKj8qknXL2IcZGnP7oQB_by_QmlQnlUNrEkhpI-BF0K24mIM
Message-ID: <CACRpkdaDGmdhaik+1saRv7Ts4myQ+tg1aQqGU3xQyT7ma8dJFw@mail.gmail.com>
Subject: Re: [PATCH v5 00/15] pinctrl: introduce the concept of a GPIO pin
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
	Danilo Krummrich <dakr@kernel.org>, linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mediatek@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-mm@kvack.org, imx@lists.linux.dev, 
	linux-omap@vger.kernel.org, linux-renesas-soc@vger.kernel.org, 
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, Chen-Yu Tsai <wenst@chromium.org>, 
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 04230120017
X-Stat-Signature: dy43fdxnxsg8gct61rctyf1js44nzejo
X-Rspam-User: 
X-HE-Tag: 1755608520-171975
X-HE-Meta: U2FsdGVkX1+bwNj+r8O6iop+rsRw2OAZ/yKGZA7mHIyMyruO727Hm2B4HEjR3Y29YGa/14Hrxy3kmH6MvhzRv/KGIgOiDmJ+aG1DGWxJhgUZdAoqmpjLY52f6g2PIliOnaLHyNBkvM4QpRZg/x6hbVYXs9ZE94A3Me/nPAyb19vcdg7bGF9NgRUy/FfPQUxZ/J6UaAC/PYnwHVYBa9Bw84JX78SLmbCgrMhpQxPFkDqWxhzGfds9Ll7Z4tlzPw1p9TiflH702MdyMHm98aSdyxX7pyPcGlQzrDvoMM2qjrucKwElJCQ7O5PfEmZmG0TgLKQdey3zfVQFDTnsF4V127JV6YDedWLzkcmS9fMuHJmN3pmAhqzHfvraDnC+LoRoZbgTAMKlrPF2YhJgCfgk3qWjdS1ODlhZEjpNqRuNcjwOBnzbO9KoUhouvCROwPUQhQCq+nm0eXEu2tsPc2Kz38T35sI04rhJNqrzIG9V1/mwDkDa2zdmUF1ri/6LjA0d7W0RACF1lQ+mzERoVpCReBeAMcnQyaoy8EPDBOolCfXL6peKwkuMZa09Sho8AvxIpZ11GR3d53ST3kV6espLFL6ucJ5K4eIwPcIrVhxbaJ45Rf7kKVcTfTtUIegtRzah+bHAo2832Y0Dw1/AmCPmCWIRv2SjINsGywrjaWMlBY3pEicQlU3O9gYgOSjJUtHSz//9a9KSzcE4A1WeUfjinXgA4EBhJW3cp/YgVxV8je9qPAMB/rx7vFxBBdVvsFADFtiV8JDTgi+esOO6tnfDWpyYPHSuiIii5SenvOwuAxoJg7XFpd1aoU/JuzB10TOkupu3SD/UpxI5f2WBW032B4hbC6COcGH1ENW6U7W15555gPJhAGcNhLdLo7EHlI3Toy6n6IEvf0IOszcOKd0eJ0k7Zn4vz63WcvAQed5vl9YHRhKBUrkJjg4Hny6LHkQJCa1aNELUcK8zJ+4EVNM
 CZSnctqj
 BAg4HutSKCkEkcdiAmwcXfiwuAiFBiXxhxYvBxTdQ8pHnuyBe6y7NbS4IzmjBgKJnxHUlBmlvCY/MWQ2v1/4xeZCa0M8xicqbfPvVUJDdljzhFEbAsYs0FfhQIFygRXbsi5jPD32n/zE8utDOIPzNFFcF5FSj+N+6ZB0SLX1IactaSyLUV/oQKn9JD1YOPwcnybzRt7AB0/YLBV+WQVo6I4A16yEXzrivIkrqID0jrghvrL2G1Zz0uUSPUK3e4cyEyLKB0FFLyI+1HIuDjSK0Q/GlTbqjcOoQ0QXpr9YAhJIZ1xTW4eZthoNik0TyXyphuh2Lfv0kvijzU/A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 11:09=E2=80=AFAM Bartosz Golaszewski <brgl@bgdev.pl=
> wrote:

> Problem: when pinctrl core binds pins to a consumer device and the
> pinmux ops of the underlying driver are marked as strict, the pin in
> question can no longer be requested as a GPIO using the GPIO descriptor
> API. It will result in the following error:
>
> [    5.095688] sc8280xp-tlmm f100000.pinctrl: pin GPIO_25 already request=
ed by regulator-edp-3p3; cannot claim for f100000.pinctrl:570
> [    5.107822] sc8280xp-tlmm f100000.pinctrl: error -EINVAL: pin-25 (f100=
000.pinctrl:570)
>
> This typically makes sense except when the pins are muxed to a function
> that actually says "GPIO". Of course, the function name is just a string
> so it has no meaning to the pinctrl subsystem.
>
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
>
> To that end: we first clean up the drivers that use struct function_desc
> and make them use the smaller struct pinfunction instead - which is the
> correct structure for drivers to describe their pin functions with. We
> also rework pinmux core to not duplicate memory used to store the
> pinfunctions unless they're allocated dynamically.
>
> First: provide the kmemdup_const() helper which only duplicates memory
> if it's not in the .rodata section. Then rework all pinctrl drivers that
> instantiate objects of type struct function_desc as they should only be
> created by pinmux core. Next constify the return value of the accessor
> used to expose these structures to users and finally convert the
> pinfunction object within struct function_desc to a pointer and use
> kmemdup_const() to assign it. With this done proceed to add
> infrastructure for the GPIO pin function category and use it in Qualcomm
> drivers. At the very end: make the Qualcomm pinmuxer strict.
>
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
(...)
> Bartosz Golaszewski (15):
>       devres: provide devm_kmemdup_const()
>       pinctrl: ingenic: use struct pinfunction instead of struct function=
_desc
>       pinctrl: airoha: replace struct function_desc with struct pinfuncti=
on
>       pinctrl: mediatek: mt7988: use PINCTRL_PIN_FUNCTION()
>       pinctrl: mediatek: moore: replace struct function_desc with struct =
pinfunction
>       pinctrl: imx: don't access the pin function radix tree directly
>       pinctrl: keembay: release allocated memory in detach path
>       pinctrl: keembay: use a dedicated structure for the pinfunction des=
cription
>       pinctrl: constify pinmux_generic_get_function()
>       pinctrl: make struct pinfunction a pointer in struct function_desc
>       pinctrl: qcom: use generic pin function helpers
>       pinctrl: allow to mark pin functions as requestable GPIOs

I applied these 12 patches as a starter so they can
stabilize in linux-next.

>       pinctrl: qcom: add infrastructure for marking pin functions as GPIO=
s
>       pinctrl: qcom: mark the `gpio` and `egpio` pins function as non-str=
ict functions
>       pinctrl: qcom: make the pinmuxing strict

Neil reports of regressions on qcom platforms so I assume it's something
in the last three patches that's causing it and I hold these three off
until you have time to look at it (and focus at just the final qcom pieces)=
.

Yours,
Linus Walleij

