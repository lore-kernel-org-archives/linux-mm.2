Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58A14E937E4
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 13:23:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25F1A6B0089; Sun, 12 Apr 2026 09:23:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 210006B008A; Sun, 12 Apr 2026 09:23:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FF4E6B0092; Sun, 12 Apr 2026 09:23:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ED3D36B0089
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 09:23:07 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8ACB7E3F6D
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 13:23:07 +0000 (UTC)
X-FDA: 84649969614.01.CC45604
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3135740003
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 13:23:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nNCYPfq7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of linmag7@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=linmag7@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776000185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gDdA9vu4Fz00bgurrj0mXlyC2hJ8rRfiuCUxuR8xwe8=;
	b=4PVrIvrb/VAycFX33sdmgXMU1Ec6UAq7Nx/oyPL4MqHjWLJh4yaVKVwAfBpD2/Nv19Nm10
	E8uI5xg91ykkJoW6gaEGCclvx+Dr52ek3FdIJzj2JoqNSJK9H9ey6nBCTOnZms4L9As8L4
	rcSxt069bY+CcUNAUdq1iiNuR1hb6yw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776000185; a=rsa-sha256;
	cv=pass;
	b=zXpxaYlnxSCrtuZqGuofb+RbYKl3tyaBiokfPR6eLwMRHFmTHs7J6mI6+UGwJJeVinb5y7
	fdA+KX1997SDwYkj+uVjQRHNEk8m//F+De5QaLm5RbTtoH+QxzEtC7gMKTx9+rRmHfy+UU
	6kDyylHbkKfdDmSGBoKBl4wqAViI+SY=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nNCYPfq7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of linmag7@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=linmag7@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-671802026c3so74746a12.1
        for <linux-mm@kvack.org>; Sun, 12 Apr 2026 06:23:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776000183; cv=none;
        d=google.com; s=arc-20240605;
        b=K1RhDjw+FynTFaPNm9deJXZKAR4akLs9ZrIcO/6ItNwDpIMlZ07CRp3B0Bq5KmpxuF
         TkY+P8vu/6XiCVNHuafkzCnGgNbpHFnCNcpOwr/xFhL4WY6KbjfCKg3eAyrtAJsn58e+
         MjcSsf76chrJ6dz7lMcgr3u37hHT/qRwvIcKxByVgHUi3VZ+XeqS6FDqzB9WuzbOXElu
         EO3vUnx08fNpedC2Pl2cHgAiulKY2MBEk1zOPVrygL887dV6n+PRonW/xlels21YQrQr
         BkkWBEGq/xseA5aJZe5JrcukfB5Gft2o/RkWeE7gyMClL/Kbii3/LczdEOI9J8vAQAHx
         9Fhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gDdA9vu4Fz00bgurrj0mXlyC2hJ8rRfiuCUxuR8xwe8=;
        fh=kuFJ+LR1c8tobI5Yz5/lEw+Uz8CqonzIhbbxhw3Lr0g=;
        b=hcJopz4gPQ7OrD5Rn41fm+5Wv6JACMb4yvrTW7emerwydnaBvjf2gaUnsyuDGlpMB2
         32Ww1/FQ1ozv5wEbFJTtyTqddk2y4X0O8elhRvuegt27jPiIrgJlVygjY8Uw4ccVJNMv
         P48RacyPayvr7XIL1wGDMuqg5gQstzh0Ou2Y1oOGzHyBtGlLrf/W6YwcTdUARWsw4uaU
         EOcMGcZZqXfOiuwxpu9FeSGW+wPDBZudFDh23wYN8Uil4VoUM5CjLMW2DMlDdfTyWxkL
         kpPHDagJaweuusNY6wy6IKqlqBws8M3yhc22kAq4jyYZmO9zMRri+8F3wGkyMzVORw8Y
         6hQw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776000183; x=1776604983; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gDdA9vu4Fz00bgurrj0mXlyC2hJ8rRfiuCUxuR8xwe8=;
        b=nNCYPfq7HR3SaSe9XKu3fQ2gl3ICnxPdUuqwGAfTdTpDQyW4YI4GPMA2pjJQupvNu+
         xMJogJBohLQMsELPIZcEAZbEMCDSHsEyEUj5aAuAwHOunGBKFX19YlfwvZ8jHIKn/Y/D
         r5T8q9KMrEokXlgvmPvg96iQmroFmZ9OuGYbNxX6YBiXiyMJlNBalPzR4TEDg3Tffh3B
         lL5ExggEFosxUb/hUfB9YWgL0/nZ3WNUXQZsQq7replMICVjMDjhWCTZt1ckWgl7i19B
         U/tWRVqMEPsJ4LKfxYlQSS9IgzGBOZDHewKU7Bzh+E0Ur6aPqSWaECXQQJAwi00d+F49
         qO/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776000183; x=1776604983;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gDdA9vu4Fz00bgurrj0mXlyC2hJ8rRfiuCUxuR8xwe8=;
        b=HIjYeN8LnchO8oyf2SGU4I4LZUnLNUIx4OdqwPz4ZPkgiubZRIxQ1j3r8OYTXevMJt
         L0FGO7VEaMW3QviBzlgDWfx2mg0EpfTPZpG2sEei01nYce5ypAXpOosvsgkDdXh/f6wq
         aMUrBfj6I/D9A8bghfs28KF81KkMcAkjL1TcyXOy8ObtQs493iNi88O5GbiedQHi0xwO
         4XIoxFa7SO5gamzCSwAx1+HKwiL+gvQoyRdFdQeSOhns0jORdst52vD4O3Es1OrNcTJF
         Jv9cH+sCnPAmkCMIFx7bSriEkiR0hNKu7bxAqLxqCOlP+re9P6kKXtZDZlG7TRtqta+s
         W4MQ==
X-Forwarded-Encrypted: i=1; AJvYcCVrXIGZgPJt1AdUbMUBJyBzW/KOGyV5qYb1rwsTR9ScdNREB2aG1VqAB2ObqyJtYLn428f8l0Ef+g==@kvack.org
X-Gm-Message-State: AOJu0Yxdeltm8Ffcuux4jHZvgqy2Ea67eat7RSzo3ZHHMjzPoclDSg4/
	No5NMkXNUgtcNPIkaq8jl9YkuQTVuMROPvBkUY8SqUj2Uz46jlQMiQXYQAbtlRtXXF/bMljMPUV
	sXRVYPcS8MD52zdACj75eS3zueTwzkDI=
X-Gm-Gg: AeBDiesgCIsy6uP9OJyCy5eO8C21xOEk/TaQsbzt/OAg203nJYAf73vWHBBIK48M5vJ
	e3qUXlIKHrYWFpnlrnuUE5eIstgbFoQ/anPqeWVq3jwII71MVK0/F/Edf1H7GWpvVSNgdnbFwj/
	7AXLTpVZ3+Dkm1x87oajgf0gU/wUxfITmkax5gZSnE+PvMX+WTGbYk82Pl04t4hh4M/NukzN3WX
	4j4Wmb3ZJM/MeG8HQL3wXR78xaBrllVLe0tQ1kfxkRKjvjslFm6/8fGT4l4EvedLqCw0XBeOemI
	uYQ7uviDRer7UYdxu6JuWnfMVoJK+sw6PeG4F48G
X-Received: by 2002:a17:907:e113:b0:b9c:6ef1:ed18 with SMTP id
 a640c23a62f3a-b9d727aa4fdmr352963766b.25.1776000183133; Sun, 12 Apr 2026
 06:23:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260410120044.031381086@kernel.org> <20260410120319.131582521@kernel.org>
In-Reply-To: <20260410120319.131582521@kernel.org>
From: Magnus Lindholm <linmag7@gmail.com>
Date: Sun, 12 Apr 2026 15:22:51 +0200
X-Gm-Features: AQROBzAeMsaeSVePCJ__tEd4f2rWAY6MixXzp_fii2b8vyUpLt4xjSbtYzENFaw
Message-ID: <CA+=Fv5S68wZQapeaYTspOfsuGk=nBj60sx-ojHBSqrxV59Q+ZA@mail.gmail.com>
Subject: Re: [patch 23/38] alpha: Select ARCH_HAS_RANDOM_ENTROPY
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, 
	Richard Henderson <richard.henderson@linaro.org>, linux-alpha@vger.kernel.org, 
	Arnd Bergmann <arnd@arndb.de>, x86@kernel.org, Lu Baolu <baolu.lu@linux.intel.com>, 
	iommu@lists.linux.dev, Michael Grzeschik <m.grzeschik@pengutronix.de>, netdev@vger.kernel.org, 
	linux-wireless@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	linux-crypto@vger.kernel.org, Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org, 
	David Woodhouse <dwmw2@infradead.org>, Bernie Thompson <bernie@plugable.com>, linux-fbdev@vger.kernel.org, 
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Thomas Sailer <t.sailer@alumni.ethz.ch>, 
	linux-hams@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>, 
	Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Huacai Chen <chenhuacai@kernel.org>, 
	loongarch@lists.linux.dev, Geert Uytterhoeven <geert@linux-m68k.org>, 
	linux-m68k@lists.linux-m68k.org, Dinh Nguyen <dinguyen@kernel.org>, 
	Jonas Bonn <jonas@southpole.se>, linux-openrisc@vger.kernel.org, 
	Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org, 
	Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org, 
	Paul Walmsley <pjw@kernel.org>, linux-riscv@lists.infradead.org, 
	Heiko Carstens <hca@linux.ibm.com>, linux-s390@vger.kernel.org, 
	"David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3135740003
X-Stat-Signature: 59okf6wrt8a1cnbqpemxp9d4xsjjior3
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776000184-944458
X-HE-Meta: U2FsdGVkX18G4vGQYyt0tCA3nr/VP6JTsTfPTpC/VUnzChzOSMbg773/6LVL2+NGP2YLL3ZppYXxvlCHckafm5ARSPUpcqT487SXcSrhWnc4axei76ic/kis+XCm8+kHioAuOyDhm1DSjVV6qxBSm4aXwPWCtXotsle4qpMeZnZnXRZYIh096lVs9P0VAUxrFxi3gvtfVV47xX1LNKQpo0DUCrqqRz6BbZjdVRumoU6uM85cl9d28sCwmL5yZMdlusBNnM5jFfvSu+/M0USS1WXespHgcTJpknm3KIfWhRJoYYls0M8bZjwWbopugIPEjcrGAccv+7JbBsLCMy5cuhq5W4T2kR06c8dPBUeDEIk4kJVTTkgmxmeWzPVDcoQP5Jsi9gQr/WMhrOAuDwO5yGIjSfo+k5OUnVPzHDqvbdPsoTveTFIouy5LwPn6snpT+0D80NFq35t/Gl8Rszbpb3Nu15cFW70EbzrLGTPrjpZSkoqIaNnUnIVGfMzzxlE9+4JSjLrSxxRBpVvFAO95VYH/1B/pxXnbhTeX3l+ayx/YHM6LpvHuY7GF3VlLFXHS85GBQItD1ukoMpeF69XbSkiiCKqtE8Tr3FeASJOIANekzQJCwiC4CrBQFyaeC/+tRMXomOWaQPOpIeYsZ5IFX6xpj7/Sk8eB7UcQd37QgHL1oZ1HeolDGgoTHz6jMra8XxPDdEc5GAu+PrzOxlOL4+HxFkqkWM1fkjiUfjC+2rQ1BsfGCMK+gsaqlw4/Z0VAtQMhJy6PiKfY71dTx4mTg3lZlUsnXFE2R6H+AmBLql4tYUMoSbcRQBEWogU3jRcz/NKXucsW7CQe0t3F7Dpu7lutTwHXhE/UvMlMaYqdNFVpNRIeK2wjPOslJOzizHCh2ptUbLY5GOemPZqkSCVmqHhkGzsrYVg+tNdN6TlmeZZXjkhnfsJrlxvW2M0qdrEFmRTSsVJ0gwNLKhQy+ex
 tMA7L0eL
 aRFhkWLwCpMUZincnLd7AV/cjTjkckdsiHtG9zYUZRICwasoD5Qhxm+nk5T5AlrqmTiS0Y181slXiLjKzIrtLpVPbHwB/pAY17ZG3ZqEx0u5OWcc6+/5f8n+6ZXQ3gYYaC8i4pbby7i9UIJXbCefofE4ZAcyD9l7kqBKAllWhj1xUIra3/WEJZdAUgDFtWw7PZBcf/Qgtt594JpR1Xw9mhU20AB2nMm+o2oRQf5iz4xO/If78KFr1U08g4VonY/gc6Q48wI9qXe/Nvjygwg13g2ovcFQxtpAVCpa9WreJHKtECvo6G/AcDRlmpX2qHLfWcAE/ZS9nV3dXlFgqK9OFTCRq4eqBVOKr5/penJvGTMltHFXAjVzw9RQbkbiW5XhRgmA88e9oFl3uS2u10VsQym4P0WsryyZCkmZR7JW1nLqo9BK4HfVM8rIMpeLayzBbSadT8DT64QQcb3Q4l7/F8NrpnEk8vRzFE8MIsehWcAbsCDi51azAWLgrEYurMD2M/Cy16pkIA93yPH885CcaD4rltaTWtfVeG11+mSF8jnbAlFy05zhJk87QI27XAyRkqdwORH03KibTxzCCPqp3ZstjkaqFm7EjKWDx72WCuKeccONE26AfKvs2Ug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10, 2026 at 2:36=E2=80=AFPM Thomas Gleixner <tglx@kernel.org> w=
rote:
>
> The only remaining usage of get_cycles() is to provide
> random_get_entropy().
>
> Switch alpha over to the new scheme of selecting ARCH_HAS_RANDOM_ENTROPY
> and providing random_get_entropy() in asm/random.h.
>
> Remove asm/timex.h as it has no functionality anymore.
>
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>
> Cc: Richard Henderson <richard.henderson@linaro.org>
> Cc: linux-alpha@vger.kernel.org
> ---
>  arch/alpha/Kconfig              |    1 +
>  arch/alpha/include/asm/random.h |   14 ++++++++++++++
>  arch/alpha/include/asm/timex.h  |   26 --------------------------
>  3 files changed, 15 insertions(+), 26 deletions(-)

Hi,

The Alpha side looks fine to me.

I've applied this patch on top of v7.0-rc7, built a kernel successfully,
boot-tested it on an Alpha UP2000+ (SMP) without issues.

Acked-by: Magnus Lindholm <linmag7@gmail.com>
Tested-by: Magnus Lindholm <linmag7@gmail.com>

