Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C4E4C83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 11:07:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA9056B00FB; Thu, 24 Jul 2025 07:07:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7ED36B00FC; Thu, 24 Jul 2025 07:07:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D94C66B00FE; Thu, 24 Jul 2025 07:07:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CA6C16B00FB
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 07:07:09 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 77CD5B89E8
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 11:07:09 +0000 (UTC)
X-FDA: 83698881378.28.D82BB6A
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7C68E180011
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 11:07:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hFaelweS;
	spf=pass (imf24.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753355227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=43dwDfmrGoNVQcXDC2wAL8Jp+SeF4PP+nL7X5CzoIgA=;
	b=MdgsBv9v6PQkPS4dtm6mun3n4RVlRMVP7XPqKTSMv/IOrTbnKnf2tKgQMEqrj/Io61HtI7
	091R2xAV2p2s/a45YHdidQYAQ0vMQFYkwpuRs4AJBa2ZwJD91vWD0rYHUo04FaIHw28dhp
	IKra7GT+TYL2FaPAS2Feho86H6DNTHU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753355227; a=rsa-sha256;
	cv=none;
	b=cvQH4s+cQMHvHLxaHqLBsLuUtNKB1RXUvrq9R7awomy/39wp1DbBuEguJhQDDMWI+RMT1/
	6iON7Cqfk6PLJboTKpzMspXnQDCobdPxtsAblePM/X7VM3fLUY1sp9htxPznQt8fNFS6Hp
	YbCr4KTwQksYQclploUpEnCzas76PTY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hFaelweS;
	spf=pass (imf24.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-ae3be3eabd8so200896766b.1
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 04:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753355226; x=1753960026; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=43dwDfmrGoNVQcXDC2wAL8Jp+SeF4PP+nL7X5CzoIgA=;
        b=hFaelweSiJN+vvpWnBvVJIoAbZYijAZ/2KiC3C6JdnD6VW7Qyz2Ls6aUr0sL4sAxGk
         o3Rc9TMW4u5Gx4qSLa3IJsjGbvp0XTs/WM6NzIQ5bWmVdNZQbX1qODQAwnGWbYuWt27p
         A8d0zP0D3hjbfIh+xfKc0k8M37+tXDIjZm3BhypWQ/Su/ycW/2j/EC0uSp0cI3/GGvVo
         /ToYX3uauOX704iNjWwRWfmqj6F8ydli0NGglI2M0Mnht4tFz0h/iXAVUWwq7d6Qw6fz
         jQ6BQvwrHqYQXRSz0dEGlLmk6OPE9ngUU0uyKMj7ns8JbtsEscKx8il3YnIU+RBr9Eb3
         qK4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753355226; x=1753960026;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=43dwDfmrGoNVQcXDC2wAL8Jp+SeF4PP+nL7X5CzoIgA=;
        b=NI38YFECNxFsLTLv2++GqxvTBv5Ou6xeG8fLeo/1+2pIQ1In450Ng52ROxe9Pu3r0Z
         jWL9Y7R2Mvr9ch/OeCPpYQnwiXfVx0gBYVnpU+dOuoUY4/hqu6PK+hcni0fSDpGNhO6G
         WiHimBDI4G/1XHC2pzKRzrRSVdwF7SFhRgekjKJdHHhIqY88ltZLWhbfJdv6mImi+prE
         12uESOy30mMGece0JOBDqqbfg4hPn9cztSYiV+DLd6SdTa4iALx3oyiyDk7vDNmC6LfJ
         VK4DOe1lOdT0xBfClIxPofnDnWdzOFzpErFHcYMZO0wX8moQQsX5AlON5yoWZNOOcU3g
         EG0A==
X-Forwarded-Encrypted: i=1; AJvYcCWeJS+nBqCok2ouXDLO0XhIouWyYFoeDgHOcYAYaSk03Ylp8Zvb3MgCpZJRAhcT65NFyAXV1YEhSg==@kvack.org
X-Gm-Message-State: AOJu0YyLq2qAMY5sXQCmYNCJH5iL+G/LtOxh/bmkz6w8tQbBxBwvjAwi
	KVc35Zzh/GQ52tkOSSMtoFGHSwm/AEvueiCG1vXHsaYI8IwPnMBoOwd8/WlHtH6s/Lz5SJV5W8N
	fm8qeTILNymms9zU91yZE1pQltctz9ms=
X-Gm-Gg: ASbGnct79i/Oa7a+ZF619CaSh5SY9j/D6oADvvf5w7wZe/5Mfh4+zr8vSJrcU3S/zs5
	+/8FvNPhSea+rtSflCiIx9SqpPn8GUaQKgHLD+iahsNbXcQIKiW4fnBnzZBCYCwEahoi8DgKb1G
	PK0Bv0C0GXbZgr41kEHuRMjrFP1C/1XmJhfmsjRY08qe021z3kqzIGCP55dkF198IEJuwMtyYkS
	Ltp5IuNgg==
X-Google-Smtp-Source: AGHT+IEQNn6mc1SbQNgvNLpYIewbgmuOfADdxy4q8WVZzoOl9KNmTiYVcFlWZZpZmc6xxLaaxaSRyyOaGbD95ShsFlU=
X-Received: by 2002:a17:906:4785:b0:ae6:c334:af3a with SMTP id
 a640c23a62f3a-af4c1e266admr182496066b.6.1753355225671; Thu, 24 Jul 2025
 04:07:05 -0700 (PDT)
MIME-Version: 1.0
References: <20250724-pinctrl-gpio-pinfuncs-v3-0-af4db9302de4@linaro.org> <20250724-pinctrl-gpio-pinfuncs-v3-7-af4db9302de4@linaro.org>
In-Reply-To: <20250724-pinctrl-gpio-pinfuncs-v3-7-af4db9302de4@linaro.org>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Thu, 24 Jul 2025 13:06:29 +0200
X-Gm-Features: Ac12FXwnivN4zoY_g5_4Ly7908cvVHMEFQ3vZsc8P3-b_-oZW11Scn4jIzuxtTQ
Message-ID: <CAHp75VcLaVsztRtiwUkNZJRGwd5+T-x3t2VGog=0E82D3U-qLw@mail.gmail.com>
Subject: Re: [PATCH v3 07/15] pinctrl: keembay: release allocated memory in
 detach path
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
X-Rspamd-Queue-Id: 7C68E180011
X-Stat-Signature: r4eqnabk4qcc51d37itfrubopy5xqxpd
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753355227-820577
X-HE-Meta: U2FsdGVkX19WDCyYnVF3jj+lKHYwcV8ZnM6e6u8i8j2GVihHeDR2Xk0kk43pW1q7f2e7fwp79kC9r32yTOUMPXRS5efD0Hz6XCYH70rdM+XqgdLFp5lcOaLpYmZfY59/z6RhySdKR6pVYoSPMKy7LTT5dB9+2c0u/etwafKPG8oR2554My0XVPsVaaX56TfSfAouJwTlm12HVLep8SUt84XB6hXo6ov9+xcD1NhVUfhs+SnHPnnp6/ztT9AJLBjhVVpSu0A5uS3qo0aZFIhhGDq1LOlGJSXm19AcO9IuRLQlPVFJjrnjXp6i+jfCf/XIaziGpPwqrkIFfgF45YWUm7nHV9qeI4FfW5Ut+9A8/D1j22Bj4g7X3zlHfPe9ib5DAPexASB/jDlK2okQnnjPeFOqObqF7qjBYp4HQkm8lc7fyxnFfoGyik8J6Yx1baQAHOry4UiQsQuI/pI0FbDlwoJQfUd+RfuKLUoRFYutuNRdHz6XfWDVIM2ywMmhmJwOSDWk8nQZjJdzLygLMQ219g1pE4s8pQpdwtF5N12iDP/d2C+ZHxxf2y/JA99jfrUfaw0pR1/1FZSdPz5Y6puapE3U1LPjawC3gsGl2NjnL03ssf3+yftnFqmHohYxXPeK/nyroe8Wo5A99tSE0p/4wnN0vMRNtVrNGkzvmSahlKQ5Z20wXuJWw7qeeQgVmGYGj7yRPlrL3mLvOMmGVTtSzKvcoEGhnK09NXVmfYdPpIYtKeBWg6lIuL52DjrXRWNaX6bEn276yXY9dJGQa1YXaSaNCydnykcs9EyFe0nTSyAarXWXnAd7DXqIT/lkaU2C4z0j6IvXmWcsIlH+NvdvjSMTuqb9al3lqONXMHlGWnBVzQf1lbu+yZK6+qnqXJhdzU6DQZo274dRYUECfZo+FFonHdpJdeONkija2qWL2Gd0sxA81WF3pHcnaXmw/aRKGCDp2GfHntazDqnQs4Y
 OnjZrGjc
 Kh0ijuYTfeFB2bxsZ5Snc97xOnLlsgMqRI6PRepllcLcnQzAM8mIsK5X6StlrLQPWzepDgjUvoNVYrm4Vpz3k4uOnZv9rS7jmUaU6KVNhOxD1yDYQQug1xGfsmlcKnJvU3KNRvMMR8qJrK09AVXwbTt2p7w4PRxzrLsq1xMb1kCxZbyMVdPZMORqiMhrbivjLI1iy43V8DSNg9+qr8U1APOD76mU//eMexXb0Mrz6LIVrBClQiH4XOqIxepBArfRrMbzeo1axFsFkjMEN+xr+JibtVZ+PsfNJf6lJstpGyPTd8WYYCtcLLnt+519SakE3lOOR+hbvcZCqbNiDEwFULwTvfxyc+Hn2UReAvQS1ykbAEdnxSafRWY6mAf00tHTF98XtOSZ37BwUbolGetQzLNjPwlPf1fRxqsV8f+zDW+i75YCN714mPkF2e/Y4XyJxeju2GLrt1Mas+qC3j5xHvNV4NIrRgl0FE8UQoCtIoQBK+bNsrPWiPYxeZAXAl6sw3j37ZyXhwpc4ScMRtB1++684hA==
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
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
>
> Unlike all the other allocations in this driver, the memory for storing
> the pin function descriptions allocated with kcalloc() and later resized
> with krealloc() is never freed. Use devres like elsewhere to handle
> that.
>
> Note: the logic in this module is pretty convoluted and could probably
> use some revisiting, we should probably be able to calculate the exact
> amount of memory needed in advance or even skip the allocation
> alltogether and just add each function to the radix tree separately.

altogether

...

>         /* Reallocate memory based on actual number of functions */
> -       new_funcs =3D krealloc(keembay_funcs, kpc->nfuncs * sizeof(*new_f=
uncs), GFP_KERNEL);
> +       new_funcs =3D devm_krealloc(kpc->dev, keembay_funcs,
> +                                 kpc->nfuncs * sizeof(*new_funcs), GFP_K=
ERNEL);
>         if (!new_funcs) {

krealloc_array() ?

--=20
With Best Regards,
Andy Shevchenko

