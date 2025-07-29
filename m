Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACC18C83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 11:06:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3223C8E0003; Tue, 29 Jul 2025 07:06:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D3168E0001; Tue, 29 Jul 2025 07:06:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 211B38E0003; Tue, 29 Jul 2025 07:06:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0F2E68E0001
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 07:06:46 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7D205140569
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 11:06:45 +0000 (UTC)
X-FDA: 83717024370.22.4D32323
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	by imf20.hostedemail.com (Postfix) with ESMTP id 836731C0007
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 11:06:43 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=zLiSiypH
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753787203; a=rsa-sha256;
	cv=none;
	b=XEA6mj9xeZWjc0PH4aedTqnouZigDLjDmIqXx9N7d+dKY29zM4goRV7Wduqzo6pSBxqZaz
	FsEh/aud+joL7L88++M1vTXdxhGsda0s43jHcg4Z2ZnsZqIqAQCw6vsEo/eYFBKKT1KOG6
	hX4ubFMkRhdCVsD25FEVVtYDow+lY5o=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=zLiSiypH;
	dmarc=none;
	spf=none (imf20.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.208.178) smtp.mailfrom=brgl@bgdev.pl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753787203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VT6dUycl5sWhSXBL7/LG90t0tKRW5i7yHrlxM+huFP0=;
	b=NqF/EbRBlW4ahahlBH4QKxsFcpnSOTAsrgG0hKCvBGiZXXX0+8Fz9N6e9o+GxvXnDMInSb
	IQjusOpkruvKxbpzpH2leM9RzuY3lZgiOEp6r72/QVddq1tuKym6tpAil2BM35XgFLHxgg
	eiZyN49KgRUEO7SF+s8Y3Dckb2YuYxA=
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-33211f7f06eso10390681fa.2
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 04:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1753787201; x=1754392001; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VT6dUycl5sWhSXBL7/LG90t0tKRW5i7yHrlxM+huFP0=;
        b=zLiSiypHwDCR4GhyTTAgAmJ2a9hUN6tagRV1L2X2t2vg/R0aPswRZvGc40UZ9ZY05O
         erzGP9t5ZL/xSNg2cU5yVyv+P6+xJDIWlKo8Baaluk6IUBIqjGvZpD6b6faYLWMWypN5
         SmjK8J12upZoXC5LwMq4C/0BKeW9qzPxannEfDVIpy6Vg//bt7fg/PtJLzTI4a+jKMG+
         iC/l0u/Cqd+giJyX6SKcsG1gFShzvdVhr+YJEdc4dDVugd2Put8EYg9sbKLh20mND7ka
         daK6mNmByG5v4H2JJ6WCEEG1XFdecKQNLOEHLcDJjVS7Xk/NGQ2Xz4USQI/gy//4hbkF
         6NIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753787201; x=1754392001;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VT6dUycl5sWhSXBL7/LG90t0tKRW5i7yHrlxM+huFP0=;
        b=QIyLTZPtzh4NxtUAej4K0rVyqtU9vBMVHLtkULK9GnFd3KpMzz2xR/vXnRxwRx7MKY
         xvsGxiLp3UAuo9Qiqfj7deH5M0aGqRaKE22TZB8zr3UVXY1+QBglCmnsxad9sdLgNdMt
         PLr3k3rhCbj5dupSVsTKowP+WPNw58PbzTuzyetPexTduYu9ssPWpyIoWPL5GX8aHjyg
         LE2Y6i0GSvnV60LDTUR9ZXw0eNp1tyshnKJuEaVoezDgECY4lYaxoYvCHrVNWd8/PIZ/
         JD9wtFQPXG9sKRnW4sFIfzxUVOpXMIoxJUEg/IAnIOIqgchzpAP3R8G+ditN6nM7WX7A
         QFxQ==
X-Forwarded-Encrypted: i=1; AJvYcCUojI7QW0enNG3AnLNtPGwsSLgVgaw8iiggRU3c/ZpGfTmISFfW9SFEZNABdv7ba42GWkaY1OGWyg==@kvack.org
X-Gm-Message-State: AOJu0Ywdquxrtj9iRZRnbXlbVgn1GsFySbGwmD58Ny8LpErnFQNdS0hu
	NbA6ZLNAM2C86xxZmB41tC9GQFysEae5FtwGr9W5OywWH6PkckxX3fljQk2rBzTW6DXFHFO1qyG
	a+X8rRqmFG9MnbWZFijUaDPD5iv/NWNaoQZg2qurUQA==
X-Gm-Gg: ASbGnctBEemfI9pQshIWQMjix3GX5myf0Tnlc1ebEWIfKqYQ7LniiH3BZKqcYIor8L6
	TmS7BHVEd2I4AniJuwe4ZIIp6B2PjVd2Nn1de+8aTfPvt+6TD6iXy3dv7rUZOOY05ttRL2JhvVH
	IzLg8asUCUsN24rjrpa6MW4SCpIAs95WdxPOe4/RjrvORLSX9fG7C1yBTlSR2l6XwcZCtvbFU+3
	S6FDbwxggEJuooEJIWAdvmMW2CrDODEQImKwNB1o+N0I08bmA==
X-Google-Smtp-Source: AGHT+IGEtA7omnM/WlhyTqrp+MzpL6gEEuylcbCGv1UrMBzIlwoRMnKLy4I4IBpUujg7JTfAwDTQVRve7gVWQ9qxB2c=
X-Received: by 2002:a05:651c:a05:b0:332:1de5:c513 with SMTP id
 38308e7fff4ca-3321de5c9fcmr1978811fa.4.1753787201467; Tue, 29 Jul 2025
 04:06:41 -0700 (PDT)
MIME-Version: 1.0
References: <20250724-pinctrl-gpio-pinfuncs-v3-10-af4db9302de4@linaro.org>
 <202507261937.Txq9shpv-lkp@intel.com> <CAHp75VcrL56_8uKNrmLj9sk+t7qZfKNi6-W-yAKNZ+mSCXU8zw@mail.gmail.com>
 <CAMRc=MdfMEAjgkTNENZejzRPN4svCiy4VZS9Y5HG7Ht5XwqUgA@mail.gmail.com> <CAHp75Vd6Vwk8pLarDk+hDQ2S_ufZ6wNw9xffMUJfQ5M8bPJubw@mail.gmail.com>
In-Reply-To: <CAHp75Vd6Vwk8pLarDk+hDQ2S_ufZ6wNw9xffMUJfQ5M8bPJubw@mail.gmail.com>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 29 Jul 2025 13:06:29 +0200
X-Gm-Features: Ac12FXzAt3jZif6EiYx3ZXMNgUEi0RFk8sAKe5WQhjNVC8kK1iCEnpnQq5pB1LI
Message-ID: <CAMRc=MdNN_J_uB4wxGgpvaxmhgGCYwu5LXCEFBOurNWc2OmSaw@mail.gmail.com>
Subject: Re: [PATCH v3 10/15] pinctrl: make struct pinfunction a pointer in
 struct function_desc
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: kernel test robot <lkp@intel.com>, Linus Walleij <linus.walleij@linaro.org>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
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
	llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, 
	Linux Memory Management List <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 836731C0007
X-Stat-Signature: bsryyqm59fawepwkidn8jr4use44n9iz
X-HE-Tag: 1753787203-523514
X-HE-Meta: U2FsdGVkX1/SaEIJO44opqgTg5igVsyQewiCg1QjHwMK2ABYOoWtUGRzvGPj5MK2wyLx/Qliov0GOKBOF94Lk2E/O6A8G/LRpIT5LSWwCo8MYqZbWGeb1Mc605ixyIUfFhHyoYtGs5co8OS3ZpraP4UvQVfzwjNj1noabocgj9VK2pvzCSYnWtVhbsZ4JVh0c0k5dDuAcPY9fTl/ACzj2XvpWs0iT9eATEeeUZsP0+xhrNef8b36DjK+N25aUGa9DEEBkzRwozY4adH4fY6Tlaubd2jPNhgllVNzOcXm6BdCEswXHi0WfcyJv5TMjvm/OhQvgVAh2hm+uBwOH6WjVyl2c0uEEA3SbTTqpbXtZO5Kzo0HKB6ZT5ScQLuJ/oxd7zBbPYE2S5SV8qatCfn801RZyDkIfzur7w4PzuIEcVXQHBxaFfUMvh+WofXw5n6XUy6kX4nMq7ixlcE0gk8JU08AWmKlyTKRaytZq2WrO442wRFisdAd4LYZSOPnFYerAPEeBBGofxwMNGJWEo5RFGKyis4oD3aXByqm4w32qAI6pORYR5w2tbFPujHsNY2lSvMmJvfrTb/XkVjwsaS76RsQCJhfV8GZjXGypJxzzs8vidaUZULxkWcEKsaMy+VmEJishHO2unydoaHPiE6ayNXpvWfprNc15PciC0bzfyNW/Hn0qNnKH7ewuxBzvxK0AW7jHYmwHNoY1N9ZiiSt3E1gVpOVX9XYtBSa2+egGn5ZL+T6HvsVfELcIcZ4gxfUGK8d7A3EoYmRFmI1cLtd7BARNZs5guCfNSDMyZL3b/1x9TrXpenSrqGhjDqHPdUWnoqRjIPF9e930RnfU0B00pFx6TyJybRvs2uGpitX7/KEknQvjg07KK1Uv0jAo8wxAx7qU8jAbne0ZlCDWn8+EXNZ7KWhgg6XlPtqFky5EARfh7XzsNfA8Jvfie22+JH8LwwmjXWPS4ztGDanV3k
 PQA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 29, 2025 at 12:32=E2=80=AFPM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
>
> On Tue, Jul 29, 2025 at 11:27=E2=80=AFAM Bartosz Golaszewski <brgl@bgdev.=
pl> wrote:
> > On Sat, Jul 26, 2025 at 9:29=E2=80=AFPM Andy Shevchenko
> > <andy.shevchenko@gmail.com> wrote:
> > > On Sat, Jul 26, 2025 at 1:31=E2=80=AFPM kernel test robot <lkp@intel.=
com> wrote:
>
> ...
>
> > > > All warnings (new ones prefixed by >>):
> > > >
> > > > >> drivers/pinctrl/pinmux.c:917:7: warning: cast from 'void (*)(con=
st void *)' to 'void (*)(void *)' converts to incompatible function type [-=
Wcast-function-type-strict]
> > > >      917 |                                          (void (*)(void =
*))kfree_const,
> > > >          |                                          ^~~~~~~~~~~~~~~=
~~~~~~~~~~~~~~
> > > >    include/linux/device/devres.h:166:34: note: expanded from macro =
'devm_add_action_or_reset'
> > > >      166 |         __devm_add_action_or_reset(dev, action, data, #a=
ction)
> > > >          |                                         ^~~~~~
> > > >    1 warning generated.
> > >
> > > Good catch, LKP!
> >
> > Ah, strict function type cast...
>
> ...
>
> > > >    910          /*
> > > >    911           * FIXME: It's generally a bad idea to use devres i=
n subsystem core
> > > >    912           * code - managed interfaces are aimed at drivers -=
 but pinctrl already
> > > >    913           * uses it all over the place so it's a larger piec=
e of technical debt
> > > >    914           * to fix.
> > > >    915           */
> > >
> > > Indeed, this has to be addressed first, and IIRC I also got something
> > > like this in the past.
> >
> > I mean, it doesn't have to be addressed first really, it's another big
> > chunk of technical debt but we can live with it for now and address it
> > in parallel.
>
> I don't know how you can solve this issue without addressing that
> first. I do not consider "fixing" by casting out const specifier (the
> whole point of which is to be not mangled).
>

We can do nothing and keep on leaking this memory or we can
exceptionally cast out the const and pass it down to
devm_add_action_or_reset(). The scope of removing devres from pinctrl
core is quite big and honestly this series is already big as is. I
don't see it as a big issue. I can meet you in the middle and simply
implement devm_kmemdup_const() manually to avoid casting out the const
modifier.

Bartosz

