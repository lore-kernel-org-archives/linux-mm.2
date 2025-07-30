Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69AB6C87FC9
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 12:53:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0457D6B0088; Wed, 30 Jul 2025 08:53:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F388A6B0089; Wed, 30 Jul 2025 08:53:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E27396B0093; Wed, 30 Jul 2025 08:53:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CF5556B0088
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 08:53:28 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 536DE803D1
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 12:53:28 +0000 (UTC)
X-FDA: 83720922096.27.0293F9D
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4C1DF1C0007
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 12:53:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nVW2Ha68;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753880006; a=rsa-sha256;
	cv=none;
	b=W+0kpSFg8QFNkD+pC19Lcr/N4TPQrfkNl4YvFZtdjjX4Crf6J7Sm3l0R5L5I7qm0Tnck5i
	hyubbgoBZqTrTgm1mP1lZUeYD1JLb70ClYvBATeLG4DZiyWlJnNGFUv1rlIUDJLCbuhUM3
	lWNoBAYKAtVJAcUtE7kHs0z5I5TNyic=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nVW2Ha68;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753880006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iHuGd1o3geC90thSCnWisGLP32owTrOKYJC4wfO+xvA=;
	b=kjTIk8gu8evtxYsPGjRK9je3fpxccTzfnC1J0O+HzFZoprGp7pknwo28PblMKh+GjhsTne
	XjB1Uvzt7ytQlnt6O4qGzzePTM8PxqRsPHDs9xljscp36+/z1VU4XFNY16y9Rr/SL17XXO
	s3d7Q+UlbiS/62WtSBmVoILvSAEDang=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-ae6fa02d8feso1040315866b.0
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 05:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753880005; x=1754484805; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iHuGd1o3geC90thSCnWisGLP32owTrOKYJC4wfO+xvA=;
        b=nVW2Ha68BQ+e2nkXIY3bkgje0g268RSAELPgtx1SO+ytP8QlYRHKU/E5PhmaFLyySG
         e/t1rm74rrM6G1UR3kUv4d7yIPdL2lHT5LMFKWVHwPxYMvBHt8sovxA9QGOvUWt7rCAL
         EFlD3gXRGi5LgZn3yIdYsKk67W6IU7NHwH0dVcC5paLFz5BGCvRHk2xxQ/8oFW6WixGI
         T0JJtLMOL+MEc3VF9ULSRz9LtmBXlojNovYVMBeJixQX9F1gYJyJJe85WV2z8qCl/JhU
         7jIuc5uNtV85IYnpUVLyBLhtzzb4sRK+1bSZZJUcMZ/k8frlhVjAZvF9DitbqWfddVd6
         kmaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753880005; x=1754484805;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iHuGd1o3geC90thSCnWisGLP32owTrOKYJC4wfO+xvA=;
        b=OKoesNvptVHmHiHahA3rBpBCr8Qs5hGEoTc7WV4W4PsJGKBl2COltH3mlZ+ivEqT1T
         bx8BqC8ZzYvbUDCIJfuguDVls0Oip2WLuwX52AX9oPIhj6CKJ6bhAsQpvqDbHz4nYOkc
         JgbwiCHb/2iluhCXWnZHSkuMteBqKsrZnf3Y1FhSdtPY+zFtIH1YrSjFrHREuoTK62gZ
         /4UcXGcq3GxbQ2L8jAaliffFzGqLOj4cibLixGFNx1cHj5jzi5ad/uk/HUyZgTrFD7d/
         4lwoa9l7xffJMnNsfzljo4S1319vHrXEHY7RMsfWuM+DA7qurfjghRIMIzFJmoWMefWt
         HICA==
X-Forwarded-Encrypted: i=1; AJvYcCX9ct+kV9uc+yKicG9Ug0J69NGAZZ2Owi7qfeqAAV2J4iGD+NMXZSGsrH5vopYYt0XT74vJLv+oTQ==@kvack.org
X-Gm-Message-State: AOJu0YyR9D+FfYB5WM+SiLaioFa0xCXCDZHyt2sXz8R8lw4fYdMwHSJP
	uCPZnBkFq1oPW+1jjwX/7MQheohQYPODbmte8VVRDMQ+TIf5yIsQPf5tv4skKy3keLyHbU4xL74
	pVeNSZSOw0xH2Yv1+pFl1VfD5C6j+Wyo=
X-Gm-Gg: ASbGncvvUdxqkPlqKXfwInegB783BFD58po6MeywBrVeoa9My/i0EDYGoXNJ0c04is1
	9iefx1z45Uot0IMv1m1t/8HtPT8yedXHziEBdRXVV5p1kGZe3USNSWdgNywn8RLqYB1dOh0lQ89
	Xz4r8z0CndpARq7fploTu73nDH969hLemGhhustlG1EE7X7loqGTYHAv0WO8IDTTDx4NPddhRZv
	I1uQlvI1g==
X-Google-Smtp-Source: AGHT+IExcFLcRiu5QtKTR/cGupB5CiCW+Pjw09y0EZqUm/lnXA4CrvfRLkkrfhzcJE8+pxyrQnSgTbf1NQKA1MoVcOw=
X-Received: by 2002:a17:907:60d0:b0:ae1:1a30:6682 with SMTP id
 a640c23a62f3a-af8fd739a45mr409970266b.18.1753880004488; Wed, 30 Jul 2025
 05:53:24 -0700 (PDT)
MIME-Version: 1.0
References: <20250724-pinctrl-gpio-pinfuncs-v3-0-af4db9302de4@linaro.org>
 <20250724-pinctrl-gpio-pinfuncs-v3-12-af4db9302de4@linaro.org>
 <CAHp75Vc4vsJh_-GbP+YO50veoGoGtfAPL4tjcF+73uophfmnGw@mail.gmail.com>
 <CAMRc=Mc1ophkofB6MmtD4adBAi69C3JyovM-S9YD_y7UA3V1qA@mail.gmail.com> <CAHp75VcV=K-DfOGs0z64==nO+wQNoEB2Ngd2vc+dLYr3WLChjg@mail.gmail.com>
In-Reply-To: <CAHp75VcV=K-DfOGs0z64==nO+wQNoEB2Ngd2vc+dLYr3WLChjg@mail.gmail.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Wed, 30 Jul 2025 14:52:47 +0200
X-Gm-Features: Ac12FXy6gmS688CUsaG6BseFKvaIP4Sk1EUtOxMURXryhfGHjEY11oJr_rDyuZs
Message-ID: <CAHp75Vc-kFPz9J5CQgrwb+5Wgzyxne4RVn5efEDwwATAHTxC+A@mail.gmail.com>
Subject: Re: [PATCH v3 12/15] pinctrl: allow to mark pin functions as
 requestable GPIOs
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
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4C1DF1C0007
X-Stat-Signature: 6o4kqizis1acpqokdu6tcmhdxpqwopwd
X-HE-Tag: 1753880006-680971
X-HE-Meta: U2FsdGVkX18saIp49zYIYfxaexqyP5iiw7G4JZg/AyxYuFq8JBTs0gBtEz5gCfnvu+fcMcqid8UKojW3lPEl7Ke2Kdfyd/UH1wjafgminK8AHvUZnGFpTynhLKOVmaPU8Um7PZyQr3NCNpUb9iVMLq9mI4ZAfeVeFs+Pr/rMWyElchdhFMw1CQ37BISb9smTBYL0IqScq+KLXW14ZjgBEOqMdQpCRRYMjZRUXMSgxCZmULJzEWQz3aQxkCPJ3ecAFPfIyLEnPpe+n2fVa1daL1/mJ7gU3MYKz7B0+N9tQAXQIrTF2kmrjvacF4y1dZIRJiHkOBH3Guak+qn4j2LGmKlRByfxmRsGQLi+yVsPgHLpfI/lKGoGEBJZIhIcaq4xMIoU5kIfTmqVecGyipRRfEzySJrHAb7bHnnYyoODgc9QHSiPcnyiM7e7ZZTLCWpG7FzURttEOVF4DhCJlsjguXwz/53mGk5P5pBlKuVZ9tqbHlu6MV/XSvlZ2oBRaQ/n4aE2NFb7b7FdMEWO+X5bJr9klHMTBbMj5dScSarYvKs5VeE4fzTnYet++baOrvQYWONwL01DEX+j/V5bmWaByDBm4aEaMlXxRqaFhihBOgBAQq2XGW57eyCWviv/7oqGRnJJqL0r2bMe6LuAK+NVhZ761c94daABFOLmPBH9HhSm70DGt+5YbZSYAv5X5X91WpjqsBhaCVnBkttsM9RxwnkjGr5CISB75a2FZmne2jKh6yTqUGayhlNXRkE5iwAtkOuu9C4uXhQd8AVNzz5WwQYRrG/JYv+5elh4IAoC7cfIkkWpPHKNknpthpCvb+dveckUhSRFQQMnPZ8JEvCiSWgxGuIn7+z3FIvE8zFCWRIrhiAVYICV6AeFzxTcX7IKRIrqP8VQj0suQ1s0tPzgt+smNzcME0CdzxtKNYZmDQv0cdEF7BArsWheN+2pvtvVnbKSboa5q+YzHRSwg7N
 pEMmhYMz
 24sQ/3iIZjpeqRDyqB4Q56yI6JyYcRZWECujVyr+Fsb3jctz/VDEBazpDMzYVDC+xt4Rvq/+KfpXC1s19u3RPSzkJRO5tB0Ne3bW5XQ/0l2VfhVcdXl/R3kPA1y/XIRgHwcQt8ORwvLoEtaA5YK92TRtqtMg8tw7DgZh/4CkZc2gDWCA/4epQhscf+A4vyk6ov6moKVf6muTHdoo7jtPF++Mw69RhYXJqC/UmOoBQM6XIu/p4pESBQ+9n4tnKdayTLf4ywAELi9JPq5Gj1ji6Ku+eQeZxKOqWuK+pSok2HKzCvhtBmkuy8vo/jtPe5s5A0B72Us2eOo9U6AMQ5ztjKyj7OBvtaOAW0K4+/sJ5FZueX/CK64pSz/ELcBpXXc0b0kvNhBQjYXmg8pnieqjJFPr+kk0OZ5qbqfQAVgqd3HG+FBxAcI9WKHFCeroPoQfRznI2zFXOu2iBQcjA20R1cVOmgYKrNrKL8qApHgHqzxu3YKE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 30, 2025 at 2:49=E2=80=AFPM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> On Wed, Jul 30, 2025 at 11:54=E2=80=AFAM Bartosz Golaszewski <brgl@bgdev.=
pl> wrote:
> > On Thu, Jul 24, 2025 at 2:22=E2=80=AFPM Andy Shevchenko
> > <andy.shevchenko@gmail.com> wrote:
> > >
> > > >  struct pinfunction {
> > > >         const char *name;
> > > >         const char * const *groups;
> > > >         size_t ngroups;
> > > > +       unsigned long flags;
> > >
> > > Not sure we need this. If the function is GPIO, pin control already
> > > knows about this. The pin muxing has gpio request / release callbacks
> > > that change the state. Why do we need an additional flag(s)?
> >
> > I'm not following, how does the pin controller know that the function
> > is GPIO exactly, other than by the bit set in this field?
>
> AFAICS the gpio_owner !=3D NULL means that. No need to have a duplicate
> of this information.

To be clear, the pin control and muxing core knows about this, if the
certain pin control driver needs that information it can request this
from the core or do some other shortcuts (as it knows the state as
well in the HW). So, I do not see any need for this flag. But again,
maybe I'm missing the subtle corner case?


--=20
With Best Regards,
Andy Shevchenko

