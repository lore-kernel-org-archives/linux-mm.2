Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6F2CCA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 18:31:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29AD78E005C; Tue, 19 Aug 2025 14:31:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24B7B8E0043; Tue, 19 Aug 2025 14:31:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13A608E005C; Tue, 19 Aug 2025 14:31:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ED73B8E0043
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 14:31:58 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 94EEC80F31
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 18:31:58 +0000 (UTC)
X-FDA: 83794351116.24.EB5B5CD
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8C58E4000F
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 18:31:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="FP/ijPiX";
	spf=pass (imf12.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755628316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nduGwRgCS4jl5SzExLMSPPD9EivCrI3lCOm2UzUncAk=;
	b=ItiIF80DH8syPeH0K7HsHbbUxo40981y33seWp4lY+n3VV+xMxIZ38ndJl5ckvTq/Z1wL4
	Bc68YCf0ttvSaDKbXIO7BNVYKsZrCNU4tVhOI/14p4Iqb/JKG5UxNWixmNbgi92kCrUu22
	iik/aiGFGdz6/hWjz144WKnk1Q2hqM8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="FP/ijPiX";
	spf=pass (imf12.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755628316; a=rsa-sha256;
	cv=none;
	b=ykf9ISk8NCgREbWmxS7M3H4sWkbkMyC3yX8XkbcTwNnW24QyuVpPDswBELmpl95Qs+WTPw
	Lc2l/2vP0xtbSacKi15aX91udjDlep8hvZRQhTViLqshf4Dvj8Znn5eWfyTQ0m9IaZ34KW
	Cm+d06aca3nnVPb98rp20i01Byp+EvQ=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-afcb7acfde3so803187066b.3
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 11:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755628315; x=1756233115; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nduGwRgCS4jl5SzExLMSPPD9EivCrI3lCOm2UzUncAk=;
        b=FP/ijPiXPVzfzlBrTFS7Tsh7JbxSQt8bakcU5t4g4NOgugoeigS3aODgb4LQE8Dwk3
         PH5NANlpNmscS8bBFuEnJ0ybCKq3yOEzy0E0wJLbMLAy+rFS5ITRxCTdnWxfk1ZMMtWh
         L1dtvrhN7JjNRzzttrN7deCndLcouJnNnga7z3s/M5K5rXGq+MKVXt8lnLOiCeKLkA/R
         eFrNsoD0fRmBLSTVWpLW9SJq+EoD+iOBn11JWnX5lTzjg0oIEBMroHdOH/PUSmuHxehb
         8B7eaXf2JOmjgrj97usPYX+utXpe2ji1VLYyzTwKgYno+WeasEdv8A/IK5W4FdRu5DIf
         I2+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755628315; x=1756233115;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nduGwRgCS4jl5SzExLMSPPD9EivCrI3lCOm2UzUncAk=;
        b=p/kMAUxv4Bd3rqm/WLikd3HHTuCxJE8ZaP/UGmD2+MvZCzF8cSC0dssyfUTBuvAij4
         WLZ3CnWEvnTiLOnyLtQVt2k+jvcAO0DhMktY885fNPaaLf6umX0hSJRIQADKzbQyx9lT
         0UIChYW4gsmQ7VrUYzchpWC0TgYdgl2TTugqthvCVm0Wo6Fyn0VZb9pFSxBrEyVI86sz
         pfNY2aO6n0DPeACK4D6mS9IyitilOUN6fYWIy3uEdsKoICp1wr1oYVz3uPMz5IOwtlC6
         rMUELbFCQxKP7+T32zdvslvtXGiMPkks5I3FqfbwHa6CPh37UAaHTMpcnzyvkRNDmkIC
         pe0Q==
X-Forwarded-Encrypted: i=1; AJvYcCXQWUxDocoY5WUqBiiI5XgXXhzgKYgREFqzBsQSz4HjLSigie4ydnpm28cmlAkUYC3l+WQzFwK/9Q==@kvack.org
X-Gm-Message-State: AOJu0Yye9AyUd+rYTZYXhG6A/NGxIFVG8FmZCXV3v7cSfEsdVd3ZU39q
	kEhiPhmk+gTWJze9bp1f2xY7aRlr7QdioI0yGHe6HsnlVyq/HzNv8c+DqOdGd8Jl/rSL584Qavy
	IERF4CGxAOTOEp0i8KqiBsOTKsSTJjjU=
X-Gm-Gg: ASbGncub4iUuKIo6bOBhAhSR/Hr7/K5dSiKHgxvwk13yMrZmZAEC5dd9h2qD99mlhpw
	3WV+ugV4QUbPlESyBuPiwAjRFByeIa9o01XMQiylOK0GkeOnoSnjNS2UrzySvDXaN30jyN7Qu7s
	3dEFKAl1faOA0hWbXtcDup0Lq3egzgE+iIfu2IuL394yvLT+N4DOhPwqxcY47GQ3jpuEC8nv8DU
	XiZcaE=
X-Google-Smtp-Source: AGHT+IF9qpemszLCjKdTIPsWz0t4GcsgIaQduXYK/rUO4127Ry+Cx5d3EXzVvEU87daLwDxw0y5nugBK0Rk2QA9qZjg=
X-Received: by 2002:a17:906:dc8d:b0:af9:1be8:c2aa with SMTP id
 a640c23a62f3a-afddd1e42e4mr344769166b.45.1755628314808; Tue, 19 Aug 2025
 11:31:54 -0700 (PDT)
MIME-Version: 1.0
References: <20250815-pinctrl-gpio-pinfuncs-v5-0-955de9fd91db@linaro.org> <CACRpkdaDGmdhaik+1saRv7Ts4myQ+tg1aQqGU3xQyT7ma8dJFw@mail.gmail.com>
In-Reply-To: <CACRpkdaDGmdhaik+1saRv7Ts4myQ+tg1aQqGU3xQyT7ma8dJFw@mail.gmail.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Tue, 19 Aug 2025 21:31:17 +0300
X-Gm-Features: Ac12FXzsYRtjNObv84CHy6T-R0DRBoqbq7I0xmmsDobIVB43mAqIdnnlLv2k1FE
Message-ID: <CAHp75VephepLq61HrVy=PX2oKUQd5NK2qS-vOC5h_NR65td3Uw@mail.gmail.com>
Subject: Re: [PATCH v5 00/15] pinctrl: introduce the concept of a GPIO pin
 function category
To: Linus Walleij <linus.walleij@linaro.org>
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
X-Rspamd-Queue-Id: 8C58E4000F
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: srnff6u8b5k9b9jhc9dirrczg14zk9ga
X-HE-Tag: 1755628316-601452
X-HE-Meta: U2FsdGVkX1/fNtcRhq50RTSMW19itcFXZZGkGxVjKSv80f6mLqeoxH16Yic5aAv+esR444O9dzeSQQeN5yO9DrH49zbjRIW0Xzyc8crjHHoHFkM272g8NvKF7cEK2zu5w9yRlQhYJQylMmp8lJzvLflwzT/9Ps+Uj/7m7IG5pzOv30U8WEVIv9+34kZUPB/kNnHuA2TTBV/SK8ZnEY34qjMevDuHYfuSMlaag8Wgk8dAnRPPzC3bU6Y0yPl6t4EMXWiVm3X0IgHAJoDAzxFE+N43CTGU7jTtBmqqtAZATq3ccb2W7lz1TMZSC+4OrJCK36ntjo1odk1R17xymozl8GmUapOLI+nO/JRCN5cxXdwdYJvVcaMaapLQ3UA4L5DxErfWbQ0xScf3snVBJcoC73UPl0AbYsG3hJOo7naFwkKnPoRKS5qDTjqQ8pLiNZBu3IyON+cFXVdEXonm1aYfsxy0k0Xu16S/2xkTuzhULSwEZEl67OX4fdml7+9BiHVtM9PsftEHuF2uCUVjoKXT+03H2162UBTVQM40S3/SQtEKN160dRteaIRn289S0as7ieNuHnZw3WR6lMdoDZLQZseBvYuRv4ozXLzQ5nbl1hL/jVIIUgMIG+GQMr2a9URhjYcc2R7ivyHhdaO2MpMClDR0KToZkmNFCZEfNmVOq+o1Vecsn6+bXssiSDRF25TX0CfNbR4GNRIEotB+cSNt05IuorpkiGDj8qBubEhOOSA1y6OXOG59moNsCEIBpGDnKuItalOPyrUW8Xsw5YIBWKEJcViuP6Rb6VY2nte0Kv2Jlo8IJ2hfqChtHKgtbPa2j6eKDvCg+y52oNPjL9RfRomHxTrmie+YgrDPTJCjUeH4CmVOYrXAq8CaWBysw1d3hZ4Vs+bdkJ1UMf27pReTDxT1HFIqrhN4pJuz8+D4eDOdjOxKh79BHmors9n1QktUk/FZH0NpJaqXfbdcxTv
 L1DegNXb
 4U8iz+93331BKEPyz1LrEbxJroLvryMgZ7KXDRiszXBINBIjKiO2NyxeTti/5QwKBemogWjnyc3/j/zF5RdKnXCpsDEHjiLuJf4zKurAWdrwMBK+hzd6hzDUzXiwz+FG2sCzmOm8UwfSJ/LrRaFUBT9gNI/s5/uD+Os+SLePSbbAVI2wCPaSKXLbtLvV/23DcKsQTQykmyaJm+JgSLz6vDOMcvUmivH2Aui6JWYzmuN6jzwYaGM0XkmgXUHPLVIR5tuFveIBNiSYcPgizq+qDZmQssujMBulePyeBbVWi3F+WFzym/vnYYJkvlTek1d+EmuVKw7c09mWRpwngJGX2Y5nAHZVYlTArcCjBgSQFI6iql64uBWSoHr1OAZ497Kg7PWBTro9/A/HxrLcLLywVmPr9pso0L0jG8EdDNmb+z+WEcflj/KvtzP1BFpix+paVSZCqbnyE4bOCJBACEGGdcap6Y5PIXbaw7AVZ/oqe2HSgvfTrI97veWuKg+iq+X0oE5TqQKVwf+kzkYQ3FgqbbiTZ9g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 4:02=E2=80=AFPM Linus Walleij <linus.walleij@linaro=
.org> wrote:
> On Fri, Aug 15, 2025 at 11:09=E2=80=AFAM Bartosz Golaszewski <brgl@bgdev.=
pl> wrote:

...

> >       devres: provide devm_kmemdup_const()
> >       pinctrl: ingenic: use struct pinfunction instead of struct functi=
on_desc
> >       pinctrl: airoha: replace struct function_desc with struct pinfunc=
tion
> >       pinctrl: mediatek: mt7988: use PINCTRL_PIN_FUNCTION()
> >       pinctrl: mediatek: moore: replace struct function_desc with struc=
t pinfunction
> >       pinctrl: imx: don't access the pin function radix tree directly
> >       pinctrl: keembay: release allocated memory in detach path
> >       pinctrl: keembay: use a dedicated structure for the pinfunction d=
escription
> >       pinctrl: constify pinmux_generic_get_function()
> >       pinctrl: make struct pinfunction a pointer in struct function_des=
c
> >       pinctrl: qcom: use generic pin function helpers
> >       pinctrl: allow to mark pin functions as requestable GPIOs
>
> I applied these 12 patches as a starter so they can
> stabilize in linux-next.

Hmm... I'm still sure that we don't need to have a separate flags
field, but since I am on vacation and will be able to look at this
closer next week, I can't look closer to it.


--=20
With Best Regards,
Andy Shevchenko

