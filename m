Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3AA5CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 13:29:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3323A8E0005; Tue,  2 Sep 2025 09:29:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30A158E0002; Tue,  2 Sep 2025 09:29:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21F978E0005; Tue,  2 Sep 2025 09:29:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0E2668E0002
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 09:29:49 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8FACE140190
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:29:48 +0000 (UTC)
X-FDA: 83844392856.11.436CCEF
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf07.hostedemail.com (Postfix) with ESMTP id 560DB40009
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:29:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=Nn9CJRfb
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756819786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jZCKJv4aYcw+dSdOw+40akoqTFv6AX+SyMdRpV8+ksQ=;
	b=S/0UQLzGUfm+H4+dOI2eWXvy6JLJIT2QBbKJYW32OgSjHBDoE3vgrYkLATYPzRx9P4QkqH
	IdQwobVhc60SRBdl/c8dIcMXOPUxyBSiRsPAiox0CuhOxpDMbHHXmEOGn9K+C/vLnGs357
	lW0gfzow77f50fK7GDuTiXuzTjBt2As=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756819786; a=rsa-sha256;
	cv=none;
	b=Huw6v48ficoInNfRd0Ij+NfYZkXOpf7fxrRGKnP4QfjGh0vNkdklSQ4huU2hApkHnKHLQT
	kIRVnleki6y0RCpZvaUi/y6aXDiQ/KNz93/yadldMC3L4YNRyaI5snmXgO6oTkm/5hDDc/
	uAm7mgPfmcm10wLZXmmDALlDknQBZEM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=Nn9CJRfb;
	spf=none (imf07.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.167.48) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-55f716e25d9so2797643e87.1
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 06:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1756819784; x=1757424584; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jZCKJv4aYcw+dSdOw+40akoqTFv6AX+SyMdRpV8+ksQ=;
        b=Nn9CJRfbf2HVj6AXBU5qoITyQCO7laTkaT4G8Uu9Vrghl63pL07AOfbT94F4eyCYYq
         FgllLMNywdZjBcVANFxEqk7PSn6nkJ7nvly11Aybu5Kp0KDKgUTBvrnt+NNoa2KTm8GH
         P5aNzw5fLsYunSTRXTK+mmZVCGn/JL7NWEFDzx0Pe6gkR8ozXGpDD+XXf7xnm6a+4u3k
         UeyBa8wAfd5bWE4sAX24NDN2cLqV1TaoEPoi9xZJ3gcugIxxkEwMHi7jDHebC9JPExBJ
         yGiyjsLu+gC4Zj29+nb+ipj6FFk9fvE3reqREuKzXi36TDvufWT13LwCrxSjvIX7jq73
         ssAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756819784; x=1757424584;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jZCKJv4aYcw+dSdOw+40akoqTFv6AX+SyMdRpV8+ksQ=;
        b=btj0sUNcfDdtU6wvjdNftUAW87VH9ZjBtvXRjpg5xdY1Q9ZzPdMTmQ0tukPiFxjM7n
         PpB+A4JX/HeqmDCM3AtYqd1mtyNv8XOrq1xDKWoI6boBgYO/lXlsKYhVN14FkVZ1DDGt
         V85pBe9KQcBKnN8agv+iu6G8JjQnPE+SknAXVqGihu5C8Gyu4WMZsbufWuxk4l1ZjlCm
         vW27XEKCfSiBZ161xX4xVmmznsYyFi2ZOnwv/zw8Nsi3xUAA0kxr4B1N8yTE7f10+lmB
         eP+Yabrip6sqBZXISImhL0n8OvwNgumNZ2PQ/gkiRAZYwSIrVwNGh0uln7t92Usq+V2l
         3R9g==
X-Forwarded-Encrypted: i=1; AJvYcCUwpPwtxjmoT3+1huPmhCaS48nXpGNgFvrVHtCP5BRTV870b6TfFMEihPYOElurynStMOc/Yc66jg==@kvack.org
X-Gm-Message-State: AOJu0YyN6r7TW1oKkHh2zi/stQUPp7MQzaK09J+uhew66EVkCfMVN8O3
	/8SjkofgEzvYFVtZ4VzCx4e4cTJznZGPnjbxVEdIj2oBEGPkysxsV9OIaSdGcIFV+VWOf93QvoW
	z9ZU9+J0JhdOjAqvHJ4F7I6H2MNIyjP2GaKdo1+l9gw==
X-Gm-Gg: ASbGncsgHUSWMJzDTgO85qCzzi+uAdhn9aW/QGMmxcgEgia7nJlv3nodAuXQnvVwSMY
	73Ws2uAIYB0WbDgwFhIgYwutAeJsUDvDmuEI6Ow+gPcf+CyfDfWuWXZagrzY4yCO/2X5lvxj1Ah
	7nlVGivEOXvtFHFyR9+9l6Ezib+Zlvl0qLIoHVDpCtjkxwruathzs7PgZHFjbbfyZ8jBvoGBes7
	PmbZu132zEUebHgV0CfJP/WOm/wnacrwKs8otWKGtmYnZKV/Q==
X-Google-Smtp-Source: AGHT+IEokI8/QdZgrQf6Khw+qmZIKYKiiUgjGe2BsWGspCY5PLtcBEV9VcspomwVXiAZN5jhrLGIGNRfYpYegqH5QMI=
X-Received: by 2002:a05:6512:6512:b0:55f:4760:ffc4 with SMTP id
 2adb3069b0e04-55f709953admr2780344e87.29.1756819782757; Tue, 02 Sep 2025
 06:29:42 -0700 (PDT)
MIME-Version: 1.0
References: <20250902-pinctrl-gpio-pinfuncs-v7-0-bb091daedc52@linaro.org>
 <20250902-pinctrl-gpio-pinfuncs-v7-1-bb091daedc52@linaro.org> <aLbrz5DYS5Yxx_UE@smile.fi.intel.com>
In-Reply-To: <aLbrz5DYS5Yxx_UE@smile.fi.intel.com>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 2 Sep 2025 15:29:31 +0200
X-Gm-Features: Ac12FXxptM2x0FIw3VzAD9gZWlHPceo9WcRvgcocpGcthnkDE6yjXmv7vVmpP9U
Message-ID: <CAMRc=Mfx5czDM=vfEYhFtVO3MviYaW4wKBYjGZ9ZnMbr-+T4mg@mail.gmail.com>
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 560DB40009
X-Stat-Signature: 87by4kscuuukdx416fagja4b1q1t36r1
X-Rspam-User: 
X-HE-Tag: 1756819786-194507
X-HE-Meta: U2FsdGVkX18wrAaK1LRaFCgBUPUEUBHa72Vvo4E5NSg1rb+htwD6Y/bZO1m833Ne23CrnuwwWFtgcTcpfbJPUkfqiqry0JZRl7PMvSYBzpEFzoN3qBBbHObRMm6U2ix4dT1PF4t1I0liPeP6A0r4cxukAT/ab9MN8RbfZunvZMsvOb/g5vJZh5AQ/g33/q4JQ/vVdJudlG2brFMrNne96JsYjQsm5tNZJJ1c++Fju63u9oiY/JkXMxzOZ2WFVZTSsGCprJYdArsdJvu5RU6yOKXdyZyZ/PJEJ1y9GIUkkYew5xDyWIMca/lgXFoJRL7DlVB4eQ8lnqYolHAQzp3NEySk8aAkXF314PY+IgkZDjeyHBWzeMiu2C9fEU1Lqwl25AeEbTlfoksv+EInMipDukVDIKJgNpyg9mPzcwTnBGrCO0jJin5OG7zYP/oKy2jDk1SSg2QtFHTckPC7/FgeEz0nRjfRssbkxLmD3u4Pmz+mtTUNljpRnPe1gaP68urgW+xowW29OBqSy7e8Vs3a5OQwFurwDYDaqUZCRrhFxFKprKveojvDP0CwAZiI2lFWCVCGrI2FxHZfty8J4KhV9/MQQNquYm1gSMaQdPzRiAmz+lo/hMSZqV1OqFTtZKDegsgE5pm6xmH+becIWgE1YRMxd1IV6CPWCdVsx834LdXmtAvBtARSniwuPFdM/NTiG17db54Wo+2nBXl5MXql2/C0d9ahK8mJiOBX2oFeucxvU6oP9GjTiLrpvWN3WABUF5D2S4CPq8RolP8Nz+ofaGr69Eg6KTAqmIZSMlnZ4fGwMh7Coz8MmHSBvT91UQxy+x72HtZSPpSzaUzC9eWMcZUC71SpOgzNJddWEX0+qKG+Bu2mRiP0+wbdFFURPxpDkL191o5sf7J1wUFuLqLFdG8nOlI0BZlM59cehECw7NY+Fyp1j/uAWUAWdt7iEbpX3K2FCqF1jdjVkfR2AUe
 l6Dyqw37
 7w8Udn11qDHCNFkQk+7nAlOqczb1xdiL3IhfcvGf96z34wF+Z9ClDerPqRypLeaRp+rbf2vpIE1ucAdlHjd2uvFB+gm5Ap6/A01LFBuLG5+sa9kpDUtyXrl6jZhLbi75xOby268lDf6d8vOOWmG1Hp/67UrYreQdiVwSFrjbyXvnugTHnTjdpZxy7Oc2KWwKrDQeZkqcQHN53CsVlWpv46Ij7L7DV3EDymAccvVdlAkXXN7H/jkUsh9dUYsx7QSqAfq8KVVIBapeRwU6A3XPDiTn2y//O870PnLLZpK75EJdb/3ZFOkJU5N+9SMl4ytRcWiEUQtnNUVsEh8JqqdNBglde74+AUIQMj/RA3L485D0LG8ESEa8YTeyKvThSMoMeXQbIhmVU1Dho1nZ4O6MV3fTuCd0tVbUGodZT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 2, 2025 at 3:06=E2=80=AFPM Andy Shevchenko
<andriy.shevchenko@intel.com> wrote:
>
> On Tue, Sep 02, 2025 at 01:59:10PM +0200, Bartosz Golaszewski wrote:
> > From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> >
> > While the API contract in docs doesn't specify it explicitly,
>
> So, why not to amend the doc at the same time?
>

Because this series is already big as is. That would be another commit
that can be separate.

> > the generic implementation of the get_function_name() callback from str=
uct
> > pinmux_ops - pinmux_generic_get_function_name() - can fail and return
> > NULL. This is already checked in pinmux_check_ops() so add a similar
> > check in pinmux_func_name_to_selector() instead of passing the returned
> > pointer right down to strcmp() where the NULL can get dereferenced. Thi=
s
> > is normal operation when adding new pinfunctions.
>
> Fixes?

This has always been like that.

> Reported?

I mean, technically Mark Brown reported my previous patch failing but
I don't think we do this if we're still within the same series just
another iteration?

> Closes?

Ditto.

>
> ...
>
> >       while (selector < nfuncs) {
> >               const char *fname =3D ops->get_function_name(pctldev, sel=
ector);
> >
> > -             if (!strcmp(function, fname))
> > +             if (fname && !strcmp(function, fname))
> >                       return selector;
>
> I would slightly refactor this:
>
>                 const char *fname;
>
>                 fname =3D ops->get_function_name(pctldev, selector);
>                 if (fname && !strcmp(function, fname))
>                         return selector;
>
> >               selector++;
>

You can do this in a subsequent patch, I prefer a smaller diff personally.

Bartosz

