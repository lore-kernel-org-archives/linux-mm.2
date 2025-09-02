Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A81B7CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 13:30:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 138E68E000C; Tue,  2 Sep 2025 09:30:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C2958E0002; Tue,  2 Sep 2025 09:30:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1AB18E000C; Tue,  2 Sep 2025 09:30:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E09F18E0002
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 09:30:54 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8F5FD14016D
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:30:54 +0000 (UTC)
X-FDA: 83844395628.14.0507F9F
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	by imf30.hostedemail.com (Postfix) with ESMTP id 91A4080017
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:30:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=zgf8kL7z
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756819852; a=rsa-sha256;
	cv=none;
	b=z5F+veiK/GcKf5kvRWWeoPVT2vu3lbkWpufcXUWWU2wk0yI9eEdmRVP0K0FCQNn8Z0X9Qs
	Q95IgzuoiYOPvG5zl/ucVhQNLN7P+1wvYEfPjjG2jOABemW4aWtUqEG6L5TO4OZdD9j7Yv
	ALL6hXIVrVI0QJXVS0Pvfm93g72haq4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=zgf8kL7z;
	dmarc=none;
	spf=none (imf30.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.167.42) smtp.mailfrom=brgl@bgdev.pl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756819852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XZhR5vC+b5jGByrsGl+I17mSTr+5gAmJbDumtIuc2ZA=;
	b=nX6WY4JeLETWXqkEMG3TTg2uPRpsQC6FtFa0n5H3tZk4JD04oMpRbyS79CjeEHnLrNawgm
	2Wyj42UyKXGiQ7y3FBp56kEuwPe1y5taSTNPH7zvca3fgZaOO/5Zgk2WnWWLg8dyxJ1nS+
	38M7w64Iph+NLCjGBgzF37DVkv3JkR0=
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-55f6507bd53so5138243e87.3
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 06:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1756819851; x=1757424651; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XZhR5vC+b5jGByrsGl+I17mSTr+5gAmJbDumtIuc2ZA=;
        b=zgf8kL7zbLX46IU28jhhsckM06HgUISHMie+m693xB50YSQCUrShMOcJsMi/VgIbWX
         cycfcN2xktbQVqyrJj9wGLu+Ma2aekTJ17++UUQGwn6eB2nYsLdzN+DatlfndqudIqco
         Jwm1I6v805eRTd9MTyyZfE5dii33Y6Q38oJL2Xi8F7NdYAOJhP3nl+h+ws2WFXJg8NxL
         4tCKHBBVhPHGyZkfpQfH4Yay8SNSfcRp8mVyBz2Gfb6Yq5XqnGjXG0/C4FFObjHAbyY8
         1OY9ILFprKWl/xON8DiErA1xylMpzxRDAHODWq2ormcvUsQnCBM3GzEKCbQeSdGsSWBK
         uEOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756819851; x=1757424651;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XZhR5vC+b5jGByrsGl+I17mSTr+5gAmJbDumtIuc2ZA=;
        b=cElueE+UCDitz1MpvBz+iRN/h8AOxvb9P3qiM9g9DheEQF7hBmIxNpGd1Gy18pXrtb
         oGFa70GuExOi0WBSbD5ZXsSSLABAwhskL4qP1nvX9wMxDgkEEW/eu+1VJQ5Y0U3HPxeL
         uzZaRmCmkrnnJX6YSXvN0qg2+XAVPgYOhOaF+3YX6EUh2x4NKLJJvPppXttVPG0mZeJL
         zcXcwJGqeKZ04+9VsgOxHMqlvT5MyQK0xUS6yKgc1x4EftWlG2vfDMUbM+KHookr8FAM
         4trpPxuv+forEXPDln9e7BrtIEMhvkB4jPe8/DnvgdUWxGgbOI+Q9Cb9vvdKMDfzKNwY
         fy1w==
X-Forwarded-Encrypted: i=1; AJvYcCXlA9gcCKvS8xoVgielgEGRukqTfxlBah1LgHD9P9qBu6Qyy0TqRkSnlANml43qHUp0Sr0VLAHv6Q==@kvack.org
X-Gm-Message-State: AOJu0YytDzp1oJ2cV+wQlKcyx+ooR6OXW8vA4Gd2ngEQfG+PeSeLoLn0
	qhT7A0LEDORosNz65FmC4X8VKHriykZraLSKzewhDO9E1+nlLwf+dzb7vq/cyRvpbDkaaCNKVYv
	0lFB7INmCgE/bQ/Djrxyg7Dm3DmSOtItvnw+InHkyfA==
X-Gm-Gg: ASbGncuFuWnGz9S+U+m1TBw96jtQ2cNQhuJw92sWnxUPZWMZ2Wx1voyqdlSodFBWijP
	z/KMwNWLDQO5fmCpG77sqeNYUwtweoCzik5rtY8/Rm7pj3SI4boFuTeb0YpV0bA6UEEEQh1WEYn
	qrl7timvOSTSc1+TdQcqC7UYUIFJD++rFiWHOU8cCCvVy5sEUce3911IaXxdQq8lb6GaIfWByZy
	o1gopHI9IIfWy1wRNTclrjl/ndtTao5Tp5jM34=
X-Google-Smtp-Source: AGHT+IETXrXrPtCI9kHaUsOk3PiYBtzLQDyO5BpniBUPpd4tNEA5zWWpm33Zl8pshGOfywjYNp9sGHw+kB/41Th8Wwg=
X-Received: by 2002:a05:6512:2522:b0:55f:4429:15a6 with SMTP id
 2adb3069b0e04-55f70967db8mr4302395e87.48.1756819849325; Tue, 02 Sep 2025
 06:30:49 -0700 (PDT)
MIME-Version: 1.0
References: <20250902-pinctrl-gpio-pinfuncs-v7-0-bb091daedc52@linaro.org>
 <20250902-pinctrl-gpio-pinfuncs-v7-8-bb091daedc52@linaro.org> <aLbsr4s7nfvCKLnd@smile.fi.intel.com>
In-Reply-To: <aLbsr4s7nfvCKLnd@smile.fi.intel.com>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 2 Sep 2025 15:30:38 +0200
X-Gm-Features: Ac12FXwa7a499RP9JirYFVy7SbY2WfOVu2ugSGxCUkawbutvsj6hahPNBLiFvFg
Message-ID: <CAMRc=MfgXac4kRgeiw+SkNUZS_ThoX5qcXeRX5bPWm-t3JQ9Xg@mail.gmail.com>
Subject: Re: [PATCH v7 08/16] pinctrl: keembay: release allocated memory in
 detach path
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
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 91A4080017
X-Stat-Signature: zxr8crujcftxwpiijesf6dqx579crx16
X-HE-Tag: 1756819852-822883
X-HE-Meta: U2FsdGVkX1+u7Xu2vBs0HHpLbUowmjtQ7yFLqbQcWND1s3hp1HLVlJDqX2QtTmiZ1i5JUZPHb8eKSPsYkf89hWw/NCYWyPUcofl6JJ//YDHTzE90heVpJm+UUR6KI4VeumOEjv6L8SwhWrp1FQpXrMapACaLg4s6sy9lbgetKVdOxc22x4kw2dNiQ9IklGHjpJq5vpevdx4fml8/1ZzmxqwlEgNXppUQnWqLqJ8RvQMHyjMSqvfcmGepmbkdIb8V7K34dte+/ej2NBjoCyOpUiT6QaPhBmY+kpULyScUVKBhPlU1xIbgiSRaye2u0oXJBS0S81W1aiC7f6gZgicRPUOQcl0MwKm6n5NOoONf7aCrcNJGCkxHeIqVXyQXwSFvofMKVILPoL6xuCEusYdPjuRCBZHGyQVeor7wb8k8/2ozgng5fC7ibTL5VLaygy3XbFw033ihBZajaH+BsZDMOQuFHp8eDBU1+sK+KIV9XxjNF9fLVNFCkA+nwGB/dCfM0phts1MuUX+7ksnv4vag9zLzDeAlNs1THEt+RQwJzw2Mz4x4A5LNWDH9O2BX//VlJACAugbpb32xe4AjEB5rpvDbJRSyOXmwNrMAz1hJL7gsYBiOwAeKcCzW99vAKLpeYI0YbBn1GZYgnlIJ0W5ZaZF70n9/zaia0SXRJkcVVgAFiShGShna5E6ZqD/dRX5Eg6LjK6oA1C+m94H7/CZwDCrvu10MglIzEVhCbpvuUWNYh0VNoRShulzF02TS0Cd7WdGdNK7IcKr791FbvLmRVE6cSPJQ3H6xWjS9sOPE9C9mRVHtVvjN7eySZ+PSTPSf7a0S9TezAZ5Bir0pk5Ais2mbUhCcgzgiQjk86l7cNL/7YJw3XuR0HzD/MjnMTkVOEHcUuj4lr5OQE79XcH9Kvt9Gl976zT7PMRAzi99DgklsMnp7ZRjcXbhr8Hjwdnjim2LlDuof7cRDG0S1JN0
 YlBQdjhb
 dbj1SyVQO697RrXu+sNx989w7vLl3gkqbiweK1EI9DhNK0xmQf/GUP2VNn/mbMD2uq5jQfx+HH59yx3LwqjOdO61eXh5ubo7jc7iRzsy3SVNBf8/n9cNgI+wmU0MF1+2gSSihcmwTOdmaU8pbK26ijg2ZlChxnVedqlSbgKwt/7J58yUYZpngBrSXv1BHr9nhqDphhxPTwzoHM45vXInZ+Yzle2ZjmBM8Hq5TqERAzV/O4chd++c9tO7Z4Krf1KkLLPu4LDP7LR+5WhJNXFx6ST4Y7gyh3O6f+n19llqnWEklCPUYVamMF99i+vPVV3inhOTOPES2rQuJTsNertsNjgYX7Ynx93Pcyjr1ODOUPuEtj3g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 2, 2025 at 3:10=E2=80=AFPM Andy Shevchenko
<andriy.shevchenko@intel.com> wrote:
>
> On Tue, Sep 02, 2025 at 01:59:17PM +0200, Bartosz Golaszewski wrote:
> >
> > Unlike all the other allocations in this driver, the memory for storing
> > the pin function descriptions allocated with kcalloc() and later resize=
d
> > with krealloc() is never freed. Use devres like elsewhere to handle
> > that. While at it - replace krealloc() with more suitable
> > devm_krealloc_array().
>
> With that in mind...
>
> > Note: the logic in this module is pretty convoluted and could probably
> > use some revisiting, we should probably be able to calculate the exact
> > amount of memory needed in advance or even skip the allocation
> > altogether and just add each function to the radix tree separately.
>
> ...
>
> > Tested-by: Neil Armstrong <neil.armstrong@linaro.org>
>

Ah, I just ran b4 trailers -u and didn't check the result. :(

> This tag is not applicable to all patches, I do not believe this has been
> tested.
>
> ...
>
> > -     keembay_funcs =3D kcalloc(kpc->npins * 8, sizeof(*keembay_funcs),=
 GFP_KERNEL);
> > +     keembay_funcs =3D devm_kcalloc(kpc->dev, kpc->npins * 8,
>
> ...switching to size_mul() also adds more robustness against too big npin=
s
> values.
>

Eh... ok, if there'll be a v8.

Bart

> > +                                  sizeof(*keembay_funcs), GFP_KERNEL);
>
> --
> With Best Regards,
> Andy Shevchenko
>
>

