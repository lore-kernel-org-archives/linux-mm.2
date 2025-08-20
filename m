Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C728CA0EED
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 07:13:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EBF88E002A; Wed, 20 Aug 2025 03:13:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C4308E0011; Wed, 20 Aug 2025 03:13:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF4978E002A; Wed, 20 Aug 2025 03:13:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DAD7A8E0011
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 03:13:05 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 962CBB9675
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 07:13:05 +0000 (UTC)
X-FDA: 83796269130.11.C09FD8E
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	by imf21.hostedemail.com (Postfix) with ESMTP id A48CB1C000D
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 07:13:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b="z3A+uVq/";
	spf=pass (imf21.hostedemail.com: domain of linus.walleij@linaro.org designates 209.85.208.174 as permitted sender) smtp.mailfrom=linus.walleij@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755673983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S2fgjYTxYjXy8UMOqphDGxwyeF/52vWVWRMlWTcUmd0=;
	b=cKXFXsrijxvZACkPG/f46mYb6nglfFQYbdXkALCBgraUZW5u02bpzRhwOAomzNbJ3xQ+vh
	meFXcZ/KPulEQueOuIRflebNOcMTTz4Qpj2MYFHBleLvDAtyuIDMXALINPkxqM/c6qIyIq
	BeNLID7yMaWsjIDui2qrVf9p3pDz8vI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755673983; a=rsa-sha256;
	cv=none;
	b=Jf5vG5kPDkDcAPgp/QqrlE3jUonJd3EOjrNaDSvXAL9gEE33DAjObjwkWVPu6wLuE6+soa
	M/7s78/u83WZU5kpx+H5S8LbMAxcUud3GXf1X0DmXEoaqogTxEbB+tazgaFFPwVDJfra+K
	Xju9GjLxOvBJVslO7n4WUt7LzkiVtCw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b="z3A+uVq/";
	spf=pass (imf21.hostedemail.com: domain of linus.walleij@linaro.org designates 209.85.208.174 as permitted sender) smtp.mailfrom=linus.walleij@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-333f8d387d6so41507031fa.0
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 00:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755673982; x=1756278782; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S2fgjYTxYjXy8UMOqphDGxwyeF/52vWVWRMlWTcUmd0=;
        b=z3A+uVq/Za3Q6sPsxYH6xMk9fFk+wGsZkPcfVBgG/WEB9aSDtcEr27kMOpVb/yvIX7
         JSR4g7yJTYiYZVhZFN8VGPMGz0nSW6e4kWoBS2aqGfkRldnn4zNG2TK/uF9wr02r21Lj
         mSJxo+lcHlxr32Psm4XTTcvhhdSk7q8D6Ox9iImszUWUPrXSclVaEQA+dU7E/kjiLsjV
         JnYvxvNWerAmtYLioFivvJFfw1o1VcTZjczsXrgRCPZ0NadbjYPxwluoaw3vOPxY4s26
         gsx2hck6Um3+4d9JjC8nTAYUWdfFfEG13JxLiWzGuCcb+27tHQv0dE40hCzix24+6crO
         57EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755673982; x=1756278782;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S2fgjYTxYjXy8UMOqphDGxwyeF/52vWVWRMlWTcUmd0=;
        b=Q9rRymKRnelm6DFeadx+864lhkJhQ2ISTqTdAbCM91CEXRqAeEw3c7qZKCRFdd7l+g
         MmMJK6cqh33yp+uc0dp72bCVos15rOIhWaODIrUdf0q6FQj9IHIQ4sPiV9PbzyTrxN40
         HpJqVjVfiS7gYCvA9KLap4O7LFbEgUIZ2hUKv3i8wyas4r306oXlHTUrXY7OdtVmcevc
         PfGBzWwKx4yV8EK4U3MFpemcGRd+LTQ0QqseyPwC/Ju13WhqgUSyWqIDxnSGFtqfnwTs
         Th/H+KFy2YYhIW//tApRT3WCFylPmk/8Nx9gqcsk2xLIhlW586jlhvHT+U848EcIXibm
         yF5A==
X-Forwarded-Encrypted: i=1; AJvYcCXHSAmJD0VYIrn0GFMs1jvNGMUc8NczVBM1WWJHLwKvLP4lg1zYsnHYD+6KgKpy6NObPLowvmzLMw==@kvack.org
X-Gm-Message-State: AOJu0YyeqI2A2YSz9aaLmYueDGw/i8aM2eME1ETgsA8/9aMLePkN8nI4
	M4HlH80misDCIUFYRRzdEMBqfh5WhHbJJfbVzXFZ3rmtmlziEOyvyexe3OZ48BWBPpUXdFc5sEj
	AGr0O/2UPdhp8c8QB0WO8EpF1kKDxx0Qd8Jm7pTZgxQ==
X-Gm-Gg: ASbGnct+21G1Dsp8UUsnXZGi54eIYALY7MdYOc+nkCqHEJHhhThwUyfsG9RyvzlXlOa
	BLSQcWMEFIO2oTiI1JOd5Ajw2l0/mp86UVTXKnImlt6XUnmOaby3fsJIBqKj3Xwm0av5DgNYaeM
	tkRJd3kIdbLkvgwfGYx93BI9IOYdiKPcEHN0uChzxmtEsiIdo2NS/o4a/MI/lzfkLrq2UWHw6Cp
	egwzGPGfBKC
X-Google-Smtp-Source: AGHT+IF6EyOC5NaF9ylfzmvC/lF+XZ8ruNEnYsDF5O1GCCUBAqJgipnFljpMN/OqbECQRkpVCXWcXHbvMHeyWEs8R7M=
X-Received: by 2002:a05:651c:41d4:b0:332:45e8:3aca with SMTP id
 38308e7fff4ca-3353be058demr4837631fa.19.1755673981615; Wed, 20 Aug 2025
 00:13:01 -0700 (PDT)
MIME-Version: 1.0
References: <20250815-pinctrl-gpio-pinfuncs-v5-0-955de9fd91db@linaro.org>
 <CACRpkdaDGmdhaik+1saRv7Ts4myQ+tg1aQqGU3xQyT7ma8dJFw@mail.gmail.com> <CAHp75VephepLq61HrVy=PX2oKUQd5NK2qS-vOC5h_NR65td3Uw@mail.gmail.com>
In-Reply-To: <CAHp75VephepLq61HrVy=PX2oKUQd5NK2qS-vOC5h_NR65td3Uw@mail.gmail.com>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Wed, 20 Aug 2025 09:12:49 +0200
X-Gm-Features: Ac12FXx_mHZvAEY3OP5MA3Uo1ED7cgPY59m1esPAFUlhfqgk9BLjcKH2xKwqp3I
Message-ID: <CACRpkda4soRCLF5=W=6R4wnwT3pjk743j022XfJxjTTQzuarAA@mail.gmail.com>
Subject: Re: [PATCH v5 00/15] pinctrl: introduce the concept of a GPIO pin
 function category
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Bartosz Golaszewski <brgl@bgdev.pl>, Bjorn Andersson <andersson@kernel.org>, 
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
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, Chen-Yu Tsai <wenst@chromium.org>, 
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A48CB1C000D
X-Stat-Signature: ank1jxcmbco511p8j77bas4nw6zgp7fo
X-HE-Tag: 1755673983-721101
X-HE-Meta: U2FsdGVkX18tP7HQMPBzO6rrUocP757YL9RXLjuOTOrK1uvsBBYcV96oE5nHs6AnJ2e4Ye+WEfPfQGho0UpNciHeh/cTH8ZHz4lelWB+W4i7tYb+rSkToFM+rnJoLcQfum9mNERmYRtny5+ioxDNMO1FQUv8qzSXjalJvfAjWE49Fv+6pSM+4VxTPiue5LDGIua2teS24v3n0qf9lQQjQkuEjHLMBzSLZ4uTrYTT5qCVOlGY9yF16B8Vdijg6rqzIAR3LnQ77eanlapTIOhDHa0tXnraZ/ZtVZn8D2tSEtrQfSrvDGlC9NX6Dvl1h0r4fK8iQipQUlhbMjk6qPHND5AXXks/Um5yQ4WF6BABhntLl1LL8KjLNfqCQvQtKOhgrs+7+11q3pz/DYFOjtvOxWS4pDYRCTVeln14ZXR/zvcK9A/2eouWIokE3vTRgBa/cIjdz5/EvEqePz+Y9ziS613l+ezijbHRmXge5Cg0D33I9fSf+SHToYaS+f8YfpORjVTPkuQGJdv9yfEDMyBmYP+jHvwbjjgK2xZxiqiPQVAl4MhUwttdnGPW/v8bj2dPJOPCczRXQQ5qLpIMbWNGQLG8gvWvBEHzhTYshARO2ypJOpwi2qX7RR1VuNbStzhIzmbNspRm7+QEd63tl9LJFeLlJ0yN4jygVwWpzHhPbX9/FpC46s9bppvd/pQB6V+Xa8lpjbyi2wqEW8iKqsnNTU9rwHInRNiZxIx4EHlqxnpmE6fO2ok3iR+K6jK8cxq5bzXYGidkd6oxAuMfjinK4du6ClUBpECkVYWliauI/1Kcwnf75X6Z2EFlZQ71NA5ybxGBbNnupB1u745C5gVSk2kQzbwsklCMiZpaQ2O4ckaXqDM3e6uSypykajVcfh64yW5HDXk6smh4BbA6oNJi6XAdLe+LH0wE/G91UdPGmcIdzSlTRXEP27LRpXUGM6gj7IHW07ILtLG1GOQUryq
 osSLGTlt
 YgIl8uqR8FDwppidrJqbTo1WXxqPSrfrjnmMysEJ2hbXWEARcFg1ILOTtZmOwxF1NGOFYE0kgocQA1OO4TxwtLyrweLH5H33tSpT//FLeIZU49ssXqiATt1Xk0lRd+zbHHEL0aJXCd69VMRmod3ht0TszkdtOeJg8z40TjMBGvpIE+H4C82ZM+qvAzYcPe0UiI6jWfX8uOpBcSnI62FfZpsRuZel7YaD/c3oJaNtPM054CXUxpnDsCKI6pBpgADwMQ7lKHgRR+O0aWFoISyQyQuTMgOUe8CDhdmmM7hiHcgyInO5bD2XNM5eWzKiKGPw56A94gGUWEXB2Hc3dm9je/Kqz4V1dkHTHPV0P
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 8:31=E2=80=AFPM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> On Tue, Aug 19, 2025 at 4:02=E2=80=AFPM Linus Walleij <linus.walleij@lina=
ro.org> wrote:
> > On Fri, Aug 15, 2025 at 11:09=E2=80=AFAM Bartosz Golaszewski <brgl@bgde=
v.pl> wrote:

> > >       devres: provide devm_kmemdup_const()
> > >       pinctrl: ingenic: use struct pinfunction instead of struct func=
tion_desc
> > >       pinctrl: airoha: replace struct function_desc with struct pinfu=
nction
> > >       pinctrl: mediatek: mt7988: use PINCTRL_PIN_FUNCTION()
> > >       pinctrl: mediatek: moore: replace struct function_desc with str=
uct pinfunction
> > >       pinctrl: imx: don't access the pin function radix tree directly
> > >       pinctrl: keembay: release allocated memory in detach path
> > >       pinctrl: keembay: use a dedicated structure for the pinfunction=
 description
> > >       pinctrl: constify pinmux_generic_get_function()
> > >       pinctrl: make struct pinfunction a pointer in struct function_d=
esc
> > >       pinctrl: qcom: use generic pin function helpers
> > >       pinctrl: allow to mark pin functions as requestable GPIOs
> >
> > I applied these 12 patches as a starter so they can
> > stabilize in linux-next.
>
> Hmm... I'm still sure that we don't need to have a separate flags
> field, but since I am on vacation and will be able to look at this
> closer next week, I can't look closer to it.

The qualcomm 32bit platforms fail in next anyway so I dropped the patches
for now.

Both you and Bartosz are on vacation so let's let it rest for a week or two=
.

Yours,
Linus Walleij

