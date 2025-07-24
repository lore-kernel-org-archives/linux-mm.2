Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66FB8C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 11:13:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05B6C8E0072; Thu, 24 Jul 2025 07:13:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0335E8E0051; Thu, 24 Jul 2025 07:13:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB1F88E0072; Thu, 24 Jul 2025 07:13:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DD5718E0051
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 07:13:29 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8A9C4112692
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 11:13:29 +0000 (UTC)
X-FDA: 83698897338.29.D54FCAF
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf25.hostedemail.com (Postfix) with ESMTP id 86A74A000D
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 11:13:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iYpqLl69;
	spf=pass (imf25.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753355607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hZNixusr+c3cACc4GCTidZUQE/E0dLpa/Bb6bVcQhms=;
	b=e341tlnF427UZZkpul7mOIcKW/VFlbSMXhpPfLEByH1OtE/ITA4BoN8U1QcOGnKpJKCZj+
	z1TDVoq9GoJZ0vhVhgiWgPHFUtVXNysjRiey8kpzYn8uGVlym5siAJX0XrLSzEua+tXD4+
	ESSjaZ0PZTe4JjRNoR6/JvxrA0hRSP8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753355607; a=rsa-sha256;
	cv=none;
	b=xVQ5rvb7ahaqJYwyzLikMQgRFP0yLlJrtRHogCZC5B7uG0hHrg0KvBw8YOt3+Mr1stLCGI
	1D7CsbbNP2ENR8t71Mnb6281fiN8KLbjHWegI9a42SWpZYeNuQ0DpchH09XD3kmTQoa75o
	jb4t93+iVBYsjjZl1yauXL5Bd+jMkvQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iYpqLl69;
	spf=pass (imf25.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-608acb0a27fso1520230a12.0
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 04:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753355606; x=1753960406; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hZNixusr+c3cACc4GCTidZUQE/E0dLpa/Bb6bVcQhms=;
        b=iYpqLl69+mAM4rHRmYY35iB+/46HmQi5qlRqLsI+JKiDMLp+JnlqXFrARopW4U7T1D
         K4qeLbmgUCv8t5XR1uE91Aqvrc5wDmNA+WYWGYsXJ4FhRYhq9YOuWCo3XUbvXr1gSMHg
         PUz6IiazaiHe9YR1HCEXDZ4+rIxtQFZ76tLkMzE8fseImc3KxRwfUUSdfVXK5qBTdPpN
         J7QRUxt2JbZqHjvW2nY1qI6/4kI3CfkllJjs0/WrxB7JdCtOGTv0g6pRu/xo7Uxg8vJr
         3AMpT5BD2Yg8ooAnE1q7/6RZfpudMTdBqRyNbamxAFOAr+KG0+JyxItdD27ViKNAPVTc
         S5XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753355606; x=1753960406;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hZNixusr+c3cACc4GCTidZUQE/E0dLpa/Bb6bVcQhms=;
        b=EQwxuBXGxkUElE91ZWaEOR1yNjARI23SSZ8kVFW2nzzLZO8iatxAwDBZVnZ4KS0IcX
         jaX+/dhRR2iLzNITlBQ1DUFL+aQ2ELE5Puv0Rp2J/WkkVNbFeUNpqUut4wcKIiyUPoNu
         UJ1Oqzlec9q/NllOdn4SwBwXw6bfeLsi/A0f/jZbb2L/gZsX7tcvdIDhhhL8ojv3TEHD
         6b/fQjrMDwMy51SFPVXW3txT0rC2KlzmNFe3tNXn4O4wkd20LuKd01vU26LkcFDgh+GL
         OVT5sKfNV5lYeHhinMvAcsGrpC4FKrMznt9PAeRL3vp1OgXPukk7hcexLKlE90dgABq8
         mpaA==
X-Forwarded-Encrypted: i=1; AJvYcCXYCVR7aPYOuEi90GW59umQMjw9PjviFEd3A5BcDjjQqS2cSoAF6B8Yc4EByc/H0NqVBwiBbRBvAg==@kvack.org
X-Gm-Message-State: AOJu0YwBhJX91jy1oeRm1bWitWh8bANiKJnhrQ+b9GCI5Qzp/0e9ubTt
	fT9Jpqbn1oGvlRVgIErDRiaT1g2PjtzwA4bojE8Jq0u0m7cs5WpIS9iMUQwIinpKgoAAEZJeeM0
	IfTBPam4BT+pbdWMLpsoV4spfrXqj36NNeaX3
X-Gm-Gg: ASbGncsstItBIkd/z4Owd8AovmbROpO8j1mzzM2gd7GvyrBJ4r/mZpTRAfjait5guW2
	Zzq6W/mOAYqo1k7Gzs2ALzFlZILxtFimUfoLanSPhjyBSRNPqVdHKbrCD2BGZ1kvfVcPRHYeSUz
	G5s86t0CIKI4eaVOAGLN6FNV/MIXMPZTEXDIBFB5r1rtbxZ87iHX3a6eAD+F8Eau+ufh8KduZi9
	CejBJszZqw40SakjgGR
X-Google-Smtp-Source: AGHT+IELZnhRssUojeUfzx03q7k6D/HSNcNEJ5i+elToR/sTLOJXIaiozbv7LfFc6lY38aKQkwYpn9FdGW+sEeYsiSw=
X-Received: by 2002:a17:906:f581:b0:ade:2e4b:50d1 with SMTP id
 a640c23a62f3a-af2f895ad43mr692412466b.29.1753355605638; Thu, 24 Jul 2025
 04:13:25 -0700 (PDT)
MIME-Version: 1.0
References: <20250724-pinctrl-gpio-pinfuncs-v3-0-af4db9302de4@linaro.org>
 <20250724-pinctrl-gpio-pinfuncs-v3-1-af4db9302de4@linaro.org> <e1253b8a-4940-417f-b530-09e57c6a8932@lucifer.local>
In-Reply-To: <e1253b8a-4940-417f-b530-09e57c6a8932@lucifer.local>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Thu, 24 Jul 2025 13:12:49 +0200
X-Gm-Features: Ac12FXx4uwXTilr-eVY-szF3msWYq6-eRwPAeJOQDJhF69DCjZUNeC203FQ8yl0
Message-ID: <CAHp75VeWbhuL1pYvEza44Pnb5YUufgY=1WYXSx2nNMJVfcytTA@mail.gmail.com>
Subject: Re: [PATCH v3 01/15] lib: provide kmemdup_const()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Bartosz Golaszewski <brgl@bgdev.pl>, Linus Walleij <linus.walleij@linaro.org>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Alexey Klimov <alexey.klimov@linaro.org>, Lorenzo Bianconi <lorenzo@kernel.org>, 
	Sean Wang <sean.wang@kernel.org>, Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
	Paul Cercueil <paul@crapouillou.net>, Kees Cook <kees@kernel.org>, 
	Andy Shevchenko <andy@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Dong Aisheng <aisheng.dong@nxp.com>, 
	Fabio Estevam <festevam@gmail.com>, Shawn Guo <shawnguo@kernel.org>, Jacky Bai <ping.bai@nxp.com>, 
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 86A74A000D
X-Stat-Signature: cjccgf9i764q5hri4tn9fo5tcjtncimm
X-Rspam-User: 
X-HE-Tag: 1753355607-92643
X-HE-Meta: U2FsdGVkX1+6CJfRb/KcJt7cIIylwXU4rQKp11vgX8bIMRMhYIgzM1mckg7FQ+YJz7s809lI2+cFQupMQUWhGDva5a6olntxMJHI8pH464OF94kERb8syChGourGaQsEK+bOxT3/RRe3edKfqhAVu0KXSMXby4wbR/nFL76tE8bat4mKXM4Yn1Yw2nStf/XjLftTVXejJaHMk4mvYv6rpzmroKXOsbH3LKT54lbL29ZEEaGd0IB/Av1vILT9d5Gj6qPqhaRYsjXqw+Zyg47ewuLzkHujn2cBjqs0ubLEaCeVPdKKmxbNBDZlXS6bs5VyuRzkpcVJl8U6xmeGiHJs7ZKWhg3EmA8J8RufFCGNH8arT0z+KjLwd7uqfsfEzgXPQlEeA66vl8pQnf+9vqZcGkPM558bTRCrBESjJrdDxkb9nzCYMQXA5JH3P9b3GEuUbze7wtqBrLmZFlbtefUrQt95SBLMim2abbybUGUgxWebZuCgEBTl+396DTAvhjaSPhxvV3Dxc6Fk9DUH/G4JcAIq//bUEo1UPiCfnCVdYAgaZMPe5v27Gfpn4IAskxVRyJiO89oQwh6A8/VgChfY2vv4zFO32O97ketuAQg4Mk0Iz0eoHywyzhcXtuzCcBT/brPQpv4hBpJISHSZmMIEGZ5KnFqHd3eagA8m6TNEKkI2rXk5kuIOawRhit3BF7DZmKLMSsv2HoZp+fCTW7O/K2ogLqOdZYvI0hU1BjwILbf+9V5Yj3QOx4c5oz0SwF2mmLvAQd7prGvTqK14WygAcpl/y7ppRdruRnW82YjyxgVmgWSpAD53e0QjsmfYuq5xYvuxg+NFd90Gowb+AMGJjOoUKZENvMvD7nqExYjJqzT22KS64sSlIRh7X8DrlOcPneGsgFjScDgbalaLjhl0TfpqBP0BrCsRVGUlUytyqWH+wvx0F0EP9QrAlNDeg8ky5/8lnxyvmSuXGHtaZUR
 rxyuhyzy
 2wbNl2KVI7RZ0+0IUe08lModm6r7XxMKsMEKYtGCBQd4c6koRhlPPj6O8jCq9XZzDlurXgTDhKDDHUj3up+8j/AsNQt/+RJjANhPmsjWAAe/iZxxRu91iooPzD6Pooz9DWgrg/aTF9GhUbUkH4hK8YGT76JoHQkWdiyUpV3DyW+CpyFQbsH+8QLAewGvAHNIguzTFadbgLBbs1EWjECN/zMBVlcb9p3LzQ6Nzm5D8p/WvARgtSoViVagovJac4vHelKdOQoBKG0TR8Vce/FkcisbWoF4w9l7MlewGp3VONUh+4pHDF4av3F5uKZDU3ARxFnavskPSnSfvlg4NQnP1kCBu43eC4jboCn6RAuMGGQjRZRUQ1kyPXbcQ561fsT6yBD8KB3+p0WT96ZdPqrxnpAQcA6AUIF/Ke/RsyjC7eS/KlKJEwCdx+BNy+oqEeExR4vYjkXNpOZbZfv6zKeqCDW/Db3vP+jaYst7KJCxmzZzX9CeXD2rtKcd0lQYp7kGlr2YoZPFkhJi/b78M5rzn4S2COxypLd4wFcCO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 1:10=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
> On Thu, Jul 24, 2025 at 11:24:29AM +0200, Bartosz Golaszewski wrote:

...

> >  extern void *kmemdup_noprof(const void *src, size_t len, gfp_t gfp) __=
realloc_size(2);
> >  #define kmemdup(...) alloc_hooks(kmemdup_noprof(__VA_ARGS__))
> >
> > +extern const void *kmemdup_const(const void *src, size_t len, gfp_t gf=
p);
>
> Please drop extern, it's unnecessary.

It's all over the header. This should be done as a precursor patch and
I know that usually people push back on doing that. I gave up on this.
Kernel is going to rot sooner or later... :-(

> >  extern void *kvmemdup(const void *src, size_t len, gfp_t gfp) __reallo=
c_size(2);
> >  extern char *kmemdup_nul(const char *s, size_t len, gfp_t gfp);
> >  extern void *kmemdup_array(const void *src, size_t count, size_t eleme=
nt_size, gfp_t gfp)


--=20
With Best Regards,
Andy Shevchenko

