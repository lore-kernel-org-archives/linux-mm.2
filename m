Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E708DC83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 11:05:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 750318E006F; Thu, 24 Jul 2025 07:05:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 727FA8E0051; Thu, 24 Jul 2025 07:05:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63DB48E006F; Thu, 24 Jul 2025 07:05:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 54C298E0051
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 07:05:01 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 04B21C0351
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 11:05:00 +0000 (UTC)
X-FDA: 83698876002.30.8A1097A
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4056E8000D
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 11:04:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Et3CrKPW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753355099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hIUwmPHAS5I/CUOP00py81w0hjNzvTvkcVdQbKas/DA=;
	b=WixKY4fBOPSJzEscS/6edtmx3xSUbiQcwLZVJ4uIicAo1/hweoGarpx2jIq+lkyWpQ4FSU
	XitJ6a3V46rzy3Cg++rVe/spsOwIJfU+BgDUKK8WLI6NeB/0U6crmtZ0FnzetNXp4o4SPB
	tBJzBEsife2zA1lZ2hDBLiuadeWQt4Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753355099; a=rsa-sha256;
	cv=none;
	b=XeUWSrB8cpMetMUxKys29CKAnXk2KJ2Q/ZGFyU2bfekXCzR4r6OIv2t1x60ErHB/LetK9C
	jx1qZKLWBg4xAzpr6Ro//OS8xFNDFt+mCM58efsnJncCDsRv+DW0RQNxyMYmsB3IBdbymt
	NrxpGur0JeilndYgamMiD8G5p91MQ3I=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Et3CrKPW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-60cc11b34f6so3498181a12.0
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 04:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753355097; x=1753959897; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hIUwmPHAS5I/CUOP00py81w0hjNzvTvkcVdQbKas/DA=;
        b=Et3CrKPWLXX0iRshQpuzKYRnuIKwlJ0/iNWJzGYrqvaoxlNjZ7ORmXKKI6Ja6V0DkK
         B5JjqjLfVytAeSl5yoIRkF3InM79RmvdJ9kpp6pm510W53twk4vnmaJxn6RtcasZIHkh
         ZTskNLqFbeiqTlHuPPf5WY99d1pQSRHn8R6d55+5la4xNj3AlRQ7OACcKJgoF/4dsmYq
         y6Wqun3abPV6xCPhoyBDSIKBGTelU0z8ZOKBNOFzjKbO14bKv1LVIAxPW0x9VMpG2ekb
         gOdI61XXnb49lqBEXuHTU/jzp/c17Gzp4faxnh+zFWu5adYrDkpCdArLpuWLXw3LTUxV
         f9Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753355097; x=1753959897;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hIUwmPHAS5I/CUOP00py81w0hjNzvTvkcVdQbKas/DA=;
        b=gnIjj8qqGC+7eGVtGIQFm+8SN43StsfEgDOM9+JuRv2w3BeMvQ7l00OfugL2xOtY9T
         PSiCBO7HuYOL2vCD2uJKsUZnS7q1wmCLO+8n0e4MOjdYe759suc8fI7pmdF+es0Byz31
         4mq++jf/ibv4H4N5dvEUzrfCRZXegS1moo8SbQfNP0RDqAXVCbCwnSPN5WQ24I4ovLP7
         TLPyBwEl+idz5wI4nSeuXi9uPfvNBrDgn7RzNclFkM/bRx+xa02OQ5hc2wcX9usBtjum
         6pGiHKbrsIVfWVqy+hVfw89P4WCVV8HOkCv1gwByTqROob4i+5e68+GEhFaD7LEfDdzq
         zi1Q==
X-Forwarded-Encrypted: i=1; AJvYcCUuP5yJHaLsP0Ppj36rUw5Jc2dkJSPlFkYb4U7WD4s4j/N2s4TaXIVG6j9wDcakmrPqiWc3yqD59A==@kvack.org
X-Gm-Message-State: AOJu0YyaHLqiwe1K9vNy+eCkJW1PavrziTZf36VqZs/GMlX+VMMjygKu
	27jD4DBKJTs10gniMZszqFJz61+kausl1yEFr9gmbF/OqpCWkbQIaEvBUjcNxNzVDXsX2xf/Mx7
	cqZRWloj20L2QIQFxYoygF9iAUt1YFAY=
X-Gm-Gg: ASbGnctTCHPG+HNIcezFIzz6W5LoUIT0r+MaxYu+9R+rnjfplbMeOsScuo6+4E126cr
	4Szl7QGqTGmoDrWEQOYqgPOfIrsaklQcMnuKV8uTojo1ZrhbUakIKhjouFAoUZh3YdKAXLbIdh8
	JqR+LXtuuQ4vr3IBkpGVBnaGVFPO2IdSfLMdqUoEKb7i8GXuIh+jKD1eGLRnzlCEOIhe6f7GY2z
	63ZOmkI0A==
X-Google-Smtp-Source: AGHT+IHPG9CppWQlW2WG11oa6jW9jIvsCOFaEPh9C4R84HymaGR9H07ZVvtMJ1em3UaqkyymENVRG1C3VhJB+3+pi38=
X-Received: by 2002:a17:906:478a:b0:ae0:7e95:fb with SMTP id
 a640c23a62f3a-af4c1e2633dmr202631066b.5.1753355097066; Thu, 24 Jul 2025
 04:04:57 -0700 (PDT)
MIME-Version: 1.0
References: <20250724-pinctrl-gpio-pinfuncs-v3-0-af4db9302de4@linaro.org> <20250724-pinctrl-gpio-pinfuncs-v3-1-af4db9302de4@linaro.org>
In-Reply-To: <20250724-pinctrl-gpio-pinfuncs-v3-1-af4db9302de4@linaro.org>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Thu, 24 Jul 2025 13:04:20 +0200
X-Gm-Features: Ac12FXwYO9py2pad9YYkUaWtcE51AjTlJa3erYsopqu9ohpn5SMp_S7iBIXDS4k
Message-ID: <CAHp75VdoZr0YCm3Pc7F5jOV8Q-H9K+gje2fi71nonHoXq2YPdQ@mail.gmail.com>
Subject: Re: [PATCH v3 01/15] lib: provide kmemdup_const()
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
X-Stat-Signature: rxddz9ab5b91d3bkb1qmdjt1bjjm3omt
X-Rspamd-Queue-Id: 4056E8000D
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753355099-730481
X-HE-Meta: U2FsdGVkX19tMYBKqwtlwfzx6NMavB3uUp2iZGCWU90NJyGI+AYcf+KBj+z+H8QhCYdq9ioVpmr3H3rqBxCODCGBZ/S+Y7Dgm595P7Z+cyU7I/HWPIC76WgZDH1pFgcpqfX2dbmYbCHAL/jOC5gPglXqiqXURN+f0pKYQkvzruiDY3038ocW02K4UTOgrJDkMxzTfyMeu5ipbvWSsA4X9E8cwY5pJO5Ca2xm7ncSyXrbpsh03NdGMLKVQQg4syFIEGBeSbhZw+/zZTrlZ+6fjeo0uo/L7vv4oKB6FckYXMnS9YGESn3CHBWZh1LBFY6UnLX+jA3KpTT+NEyuFsRcWPHkNiVVaZy4nTdTcLouMiOhzA78fL/eGAEn69XhC9rXLSnFErfwwwl0gTIYAYtyCoXSXAGUz9ny8tqteI5tXQ7u25xC5xOSTNayKIRGGOKwrRDpzlWo1ZldMsgbjaPl2WdR+8NoBL05rPvualmFMT0SDmRxQ1HRV0ZHvRAToVQbCC4tqt9Wsenuk+FNOC/cnL/sXaM2JTdvN9viUol81c32dikmYZAQcSWZZddiaYDiYp37fuKXyBgWE7Ox4hnnwrumaFkWwsDQoEM3EsKkfy9fYjqjaMgOQQ3fUuSGrbpWnX2mMGBFFvnRjLS6UN0BSdTEmJJURMzRfj7jrjGMQ8hm2UeDE4UcZ1C3PWMu2UugQip4RNowAu9WOPm90cMGWQ7IFBjhjYprytnbJy23u4UvTHZtVYACZDCs/HdB8EE1AfS6iFQjbeQN0uALCpbPKlFNWtQoMRRrV+34r2793bvIiUfkGOqIiN55MBICObVriV/JO9CijVGJQO9p1JDmkgXi1PYee/vMdsuL0GE9F9+5CPSyN/V+hKq+c+0wsUHvDMEGkLuL9h1W1yvQE1KckkZYzJyM/NyI01mSkgIRSrIGbX4n9Sl3ZW6hgY285SzM58NZDOMU35//Q5ROqfp
 o+bvvPu0
 qMESd+EM5v27U6m2s4YctmCcHf0skb13clyNPBeDg1c3m61Xv5smBIYTMXGyxPclrcDLO18AjXaKkbu9KyNijm7u/D87G8GJtJT7mT9GmwkxvqPLSAFIuNnOK868QCExMk5rHpRoktEmcZBNc1u88yc7dVfqTt075MZH1LXah3X1mFO8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 11:24=E2=80=AFAM Bartosz Golaszewski <brgl@bgdev.pl=
> wrote:
>
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
>
> Provide a function similar to strdup_const() but for copying blocks of
> memory that are likely to be placed in .rodata.

Makes sense, one nit-pick below.

...

>  extern void *kmemdup_noprof(const void *src, size_t len, gfp_t gfp) __re=
alloc_size(2);
>  #define kmemdup(...)   alloc_hooks(kmemdup_noprof(__VA_ARGS__))
>
> +extern const void *kmemdup_const(const void *src, size_t len, gfp_t gfp)=
;

Can we locate this in the similar order to the C-file? I would put it
before kmemdup_array().

>  extern void *kvmemdup(const void *src, size_t len, gfp_t gfp) __realloc_=
size(2);
>  extern char *kmemdup_nul(const char *s, size_t len, gfp_t gfp);
>  extern void *kmemdup_array(const void *src, size_t count, size_t element=
_size, gfp_t gfp)

(below left for the context)
> +
>  /**
>   * kmemdup_array - duplicate a given array.

--=20
With Best Regards,
Andy Shevchenko

