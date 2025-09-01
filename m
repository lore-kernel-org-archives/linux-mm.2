Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2267ACA1000
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 19:22:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AA318E0006; Mon,  1 Sep 2025 15:22:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55BF78E0001; Mon,  1 Sep 2025 15:22:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4709E8E0006; Mon,  1 Sep 2025 15:22:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 311F58E0001
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:22:39 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A4731BB27C
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 19:22:38 +0000 (UTC)
X-FDA: 83841653196.30.6D173A7
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	by imf06.hostedemail.com (Postfix) with ESMTP id 89B14180007
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 19:22:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b="2PUubG/D"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756754556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i7ewcbrPHINPUvrYPT4zyhNXGIzXoRLTJHpyb8YY7mI=;
	b=nSEUDujBae5TTz7cBkpOIKfu4NTII7Qm6qIPZfxkNJ4dFs8C8R3YSP+GnQ7qVj8JMvCpKt
	Ykg/qYF+z5LbrzyhrrzR1nP1exQK9RkjfZOU26sDGFZb+3nAcCu0zG7OuxUJfTxyOZQW7t
	CdzPJY+1Mxe1itwmLy4vEZnlFIiHXwA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b="2PUubG/D";
	spf=none (imf06.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.167.42) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756754556; a=rsa-sha256;
	cv=none;
	b=UyMGCKUoq8UJ+RoyZZnmaMVooYn5VTNNwBz7lji3ndFBvsKmb+EEOLGZWL4WBILB+ZZ6g2
	yEIx9rexpZxtsr7AWidABJq15a354AyywWIu+7pfT9rOTkrzLpIVSCajwkH8jf4AAgS1J6
	NZpdcESI/6IalV0T+PfE9MrLkUQLoB8=
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-55f78f32580so1135085e87.3
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 12:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1756754554; x=1757359354; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i7ewcbrPHINPUvrYPT4zyhNXGIzXoRLTJHpyb8YY7mI=;
        b=2PUubG/DvcBp8rBn4KSAAs6+/KZZzADLB0sOXyLziL3MYfGDulhFSCxos4LCumxyCd
         HawwbJaYH8P38U/gt+En+VqGq15r1DK4IgTfH6SUrHW+rIh9DM5KKFF3hlHH59R1GmbU
         2xkjLg7c1+ReaWkteGs5d8CuylgQubPMTvkajNNqRdrOG+Xqvsv83puXiqZJ/ckpZaKe
         vSzCESC0isZBx7+wYOJ1ayBKxT6dodG6o++DsTqxQhSYCI7ZEfyiRMPTTCzdYPAzyogI
         og6Euvhus0LHF+pClBs3SxUpCrY7byla9kpP8hO38pLwMliuGW7i9aMIzkn1GGVpmEDh
         +NUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756754554; x=1757359354;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i7ewcbrPHINPUvrYPT4zyhNXGIzXoRLTJHpyb8YY7mI=;
        b=kP/dQV/lWQ5vl2DG4E2s2YqJvHCdmu/EfD3McXl57lT8nOdtWVxTnJddj5oOQ4lCtn
         AqHvcs5BuSr42mU1NnYsKNtLx5pO3F9a+iR6j1n4CmXqj7n5fmEXR74teXdwRrioBoNE
         o92mMwmzqB5CoxQgBu5mQ0qppGBVve6fEKtw1b+BTJu6kFfemni3xMER3kw+JXoj07lO
         nhEz0We3JiECAVA33maxWdXSGXi+vo0ATPg/+Xj0gDoD7D+l4OLKPDmz3+Xt+XE1qc9H
         BxTJEbbuNwUKozboSPlNFxHZNnpXHDEY/UU49iRZrPiseeDWtD1nroa4aZP96OcooCBO
         oJHw==
X-Forwarded-Encrypted: i=1; AJvYcCVq6pqPb4AH1ly7S2ak+wFQNGwPDCetDQK0DTxVuhqR3uMlTfZ/b1HL5wy7BHkanrh8B/eJ6ctDuA==@kvack.org
X-Gm-Message-State: AOJu0YwD3vgFjU2URLEnWA/PGmqUM9ldP1Y1I+5sd07orjKpNGfvRFi6
	3rSq+8CVntH5ZMefq0/eqibq0tpEePDWCu8qR553E4SoGb0HSOtyDVUYxssrW7C3YGfkBewDfP7
	qhRdbMmMbLsXWB+b8qCokp9xyUw0cuDK0IMGU9aKY+w==
X-Gm-Gg: ASbGncv9S6XjMXmEtA4VaKrKcYUPbtbdesQELEp3niTZiLsScX5epHRe3yglVPtvZNE
	/Msa+fqO+jedZyhvBg7G7lGfbHs2LfJ3URvbNKVF1iyqVPeMiyu7ZNJyC5udy2KVkuxR05G9Vd9
	WV5iprrMvPbNBxvKfiK19nIEWk/nwP/7u/ZxnJCGyWTltRcjee+391b2BYaJSo5gba+ncJVHlfy
	2250XlvZ81mOMIUo6O/ZMPp0G8vNYomvYlkcgLw8w8VqhpuUQ==
X-Google-Smtp-Source: AGHT+IFcWj/MxjmrVdPmxch8QritOIaLTRMlhZkDbys4s6fntW4mvCl/nwD9FPfF52jhBYUT32dL+MvS1Koz6TeQoRU=
X-Received: by 2002:a05:6512:1051:b0:55f:4f46:9f2a with SMTP id
 2adb3069b0e04-55f708b5e26mr2212325e87.19.1756754554484; Mon, 01 Sep 2025
 12:22:34 -0700 (PDT)
MIME-Version: 1.0
References: <20250828-pinctrl-gpio-pinfuncs-v6-0-c9abb6bdb689@linaro.org>
 <20250828-pinctrl-gpio-pinfuncs-v6-6-c9abb6bdb689@linaro.org>
 <61bad868-d976-4f49-805c-8d14d4d8b3e4@sirena.org.uk> <CAMRc=MfB_3e0sjCpV+XaKcKvit7Opk5LczH2wsxO=RftrAabjg@mail.gmail.com>
 <4a633387-08a9-43c8-81d7-488e7222aeda@sirena.org.uk>
In-Reply-To: <4a633387-08a9-43c8-81d7-488e7222aeda@sirena.org.uk>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Mon, 1 Sep 2025 21:22:23 +0200
X-Gm-Features: Ac12FXzmS2jWw7xFpjYhhy0Ln3t9KFQZe_l3JIooPobPNCmkv86DLX_8q8OSWPk
Message-ID: <CAMRc=Mf0dOvwsWb6uraCQXeauLYP0TqY6xsQnV3fM0w=wROW+Q@mail.gmail.com>
Subject: Re: [PATCH v6 06/15] pinctrl: imx: don't access the pin function
 radix tree directly
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Alexey Klimov <alexey.klimov@linaro.org>, Lorenzo Bianconi <lorenzo@kernel.org>, 
	Mark Brown <broonie@kernel.org>, Sean Wang <sean.wang@kernel.org>, 
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
	Danilo Krummrich <dakr@kernel.org>, Neil Armstrong <neil.armstrong@linaro.org>, linux-gpio@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mediatek@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-mips@vger.kernel.org, linux-hardening@vger.kernel.org, 
	linux-mm@kvack.org, imx@lists.linux.dev, linux-omap@vger.kernel.org, 
	linux-renesas-soc@vger.kernel.org, 
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 89B14180007
X-Rspam-User: 
X-Stat-Signature: 546ery111dkep4spy1etiisgn8e45pdm
X-Rspamd-Server: rspam09
X-HE-Tag: 1756754556-725642
X-HE-Meta: U2FsdGVkX1+g1Pg1aJLEMyGa2HN/Awna2KuEPhex6a77OklsQfZTMn01pyDK/m+YYmi0DtdI9sQlU+F7ZFKxZAc446ChG58+++uMLITS30Ce7Q1cg71d3WpcnuWKP2x+Ao3KEEGOKSUPYvj3KP/T99YX2umujLaWy64jNSYsIFQjLPCnYiFQKuz5nD1KaoEQG1/6TVbwpg8YiZtlnadiCweY7x6HW3Q0aLrN/B6wGM3kXdZi1V4BUIKIUdN7l5afNP2JuuXMUmGpPZiaKbcOKv2wSlk8E9zVrGI5B0vWHxliR6dRdpky/lE0FItgoY4ygz+mNB7tcZlUA/ZQOYWl3UoU2l2WGn1dlfc6iW5GdH+i5UsrbdYSMJI3Ag1nvbJK+Sh4I+m3tZwHfK+DmJo8agGCE0QWfN1gUMo3H5R4ZMG/o+cetbNKaRdI93E8QXJQScKmvAvAsSTyabQQPQmVZxaxjiIyF6bk5ATXWSxxk4BxfuM+nVTalxJAWB9/XRCmeHXwxfXbCsGmK7+sEVDJ2M28YGiNv50T+K7fUmqko2V+Bqo/hddctlKHE3ZdisF61semH0j8CNVBZa2hC/ehecnX2Qqt4TLfzgzfR3/7xuyDg7yVWKy8eOKySWbAj325Z5UkFgWdHIG1/IMT034HjG8PTV6k9zRGT8LanTJLuzELFEukVllKaFGEDp6P1HeIsK/15OplUyVHHar5yYt40fxrTACG6zyLQ7d3k/4dVW+YhiLJ6iI7r4SCBw19KipDpg7dfGpKrHal2e7UyHwbR6GuK2m+t3azbca/OnogDtqB+6Px3YhXFH1ubnmoNlSdLGsxGfggXA5evMjs7adRkk6XoTEr3VfhWt7/1UQfhUJv+KaCciob8s8VUxPWULQKj5X6slAIaeXqMfxaIrH2tEfyG7TN7T4hbF7tbqK7zlaAtU0WaTQMmyVec2dt8nlAgXZrXkVEM/oksSK480H
 osodC/CK
 adZ/78fPCLF2MttlgPKzqxPNgSz6+LRaPqlXgTqleK+mZO3SQW+E9knj2Qvzl68iSWrdksih5dMv5zJCK6WyDbEBvvsiUDSksNkwxqX5WVGaTFt6Ir9ZJI0yIlmox44Utw0GLpCvyu0KQBToLfYujVh5r9dS3I8mrc9iLz9CA81WGfEFy1hrHRHnybmOX2MLFTghjN5XD8rAtSBbHMlGItAEDMNKbC9960IID5cuYapqM950UK46RLSsErInahGmTkbux51bIYt0qEsx7fe3wu0BQSy7w2pf28PtJ5+HAPFrYCXveehmF1gLdfZg4MEDaXZGRq10c8sbzlVydz3/jSLMZ08MUKPVr+Dgnx0MkmgDEOVo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 1, 2025 at 4:37=E2=80=AFPM Mark Brown <broonie@kernel.org> wrot=
e:
>
> On Mon, Sep 01, 2025 at 03:20:44PM +0200, Bartosz Golaszewski wrote:
>
> > That's not a lot of info but it fails in strcmp() which - I suppose -
> > is the one in pinmux_func_name_to_selector(). Any chance you could
> > check what the value of np->name is in imx_pinctrl_parse_functions()?
> > Is it NULL for some reason?
>
> [    0.628245] imx8mp-pinctrl 30330000.pinctrl: np->name pinctrl
>
> https://lava.sirena.org.uk/scheduler/job/1758947#L705

Linus,

FYI: I reproduced the bug on qemu with an older ARMv7 IMX SoC. Should
be able to debug it and figure it out shortly.

Bart

