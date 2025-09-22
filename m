Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7BBFCAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 17:06:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 312488E000C; Mon, 22 Sep 2025 13:06:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EA178E0001; Mon, 22 Sep 2025 13:06:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2001D8E000C; Mon, 22 Sep 2025 13:06:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0BB348E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 13:06:45 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B5AEC1601AD
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 17:06:44 +0000 (UTC)
X-FDA: 83917515528.09.5B92B79
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	by imf16.hostedemail.com (Postfix) with ESMTP id 749A818000F
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 17:06:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=freebox-fr.20230601.gappssmtp.com header.s=20230601 header.b=wRX1X88p;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of nschichan@freebox.fr designates 209.85.167.46 as permitted sender) smtp.mailfrom=nschichan@freebox.fr
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758560802; a=rsa-sha256;
	cv=none;
	b=3m03LdeQ5RgsF1XWDz9erbG6tGMmX3wv3EjPLc7Esl9c8qsruUBtBPYT8v03+0/fk4eneI
	3sdngFZ/4o7Y0G0t5WoizwICmLab4Dczsb6gpu1ZnfJmmcGAKJdI8XKrOgB0LqeXEZggWv
	AfFULtgvsozrWXt54udDmjnwyw0ngdc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=freebox-fr.20230601.gappssmtp.com header.s=20230601 header.b=wRX1X88p;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of nschichan@freebox.fr designates 209.85.167.46 as permitted sender) smtp.mailfrom=nschichan@freebox.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758560802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Et/xnvrYuQUk0byB46PUmXIo7392F/K55Vqq2WX1kEA=;
	b=FVcIWNCBABDPYYsD/Xfy2zX4FEaSS23C9sdx0cUMcnoc2f886mJzaFBIrrOPT4b0vfBqbd
	lcROHerDZixRdazADKtSeL7H0+OOPHoIUk5PZLBolj+zyVhjwjWHJrMxteGGC3V1ImKFT6
	uiQGJGKrUwLJ0VS4aoaQRHEfuDTT/vk=
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-57eef777d3eso1128220e87.1
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=freebox-fr.20230601.gappssmtp.com; s=20230601; t=1758560800; x=1759165600; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Et/xnvrYuQUk0byB46PUmXIo7392F/K55Vqq2WX1kEA=;
        b=wRX1X88p1QFxVzyUNBdtl9QaIZY3OYm2rbbcUKzxOcO9JLY9LgAUhbhcksmHTtz2Zf
         gTiwOPksXqwZSZZ1JqiYc3rVRM60ozaYwP5Pn+M/AqBRU7qfqcBjVYgXxtwhAqqnHFaZ
         uZcy2KDXm+op63o1254+Jr+VZ+9Ou6MFO0DcOKo0SBpCqgZFJf0vZEnpMNx/woR2Ifcz
         iERqY3DU+zzY4BOtiIbGVqnAtK7LiOAnymOiezibXOrNVUohwWqElHGMDu/+7+i1h+RC
         hzfT/GF1Nn3AbT72klRf9jQx/CqLDrM/VGzI5zcUUbOsrMekLxP1hBr0jE+7eibo+yEP
         L1ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758560800; x=1759165600;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Et/xnvrYuQUk0byB46PUmXIo7392F/K55Vqq2WX1kEA=;
        b=Rv+b57yquYpjoMzaPS+KpJXQRXVcgFnsbmsU9udG7u7kQHMUz5f3F/hEcI6SFwMoGK
         hEyVutkRJDetmLdvFXI/makw7dxLjJWcmIvJmGds0sJd8IDgsVVWce7IuUb+byCqGTeg
         jzRK39fCrcXl37X9Q19qLWuka2RhWptvk+cHrU6T0ytgOvqpoDUwvpmJvVQVzb961P9+
         VOuq6JPTLxNpTOgHLhBgXotwCyi9hYSC1J3LTBUHjPekAXH1X/rMuuPRFL0B8dZ4okgu
         +IIrsOIJrstGJp3TUU6ni/Uj6uO5DbepeFP4Do/uWkBmidrab4hIe3N+KzY5AvzEB957
         qZ4g==
X-Forwarded-Encrypted: i=1; AJvYcCXvy7K8xwpSo4LSJy2klQvqkwi5tHZ+7916Q8DCumaXyWiMI4Qfw3x6DMswP7rzAzVMlwtTSHcILg==@kvack.org
X-Gm-Message-State: AOJu0Yx7I3AMTrPho1yStHLWImhDaVRG8ZBeW3kn1rRFyCEPXW5wz/E+
	8cclBTFgwSIqPzIntigEIZ3wxP2F/oK1LurKjcGlL+6hrY7FyBsDnXC/YYsvyKzLiDH90CZHnMr
	jpETcFjEj1fc7pJIsMCuYqPycWGlJoUXE0uZq8U1/Ew==
X-Gm-Gg: ASbGncukKfg2xO1PMH0L61HtbLHwfcarzjG5RUYQ/z4Imvf4PwSjJZ7E9uMlPq80eV/
	tjABSTPk9220bVUoiuZ5Bl7KCqcyxXy4B5fE+TLNz164x4D9g/plaqz9VGa0P6QS3ng6ZxJJv+o
	myd1aQbxATuunYZwPLzBmPKaAEdiAuIyz8Bg6qzyFBXi28ez5J3WZTqOi6F6pVbTWkhCaPNkHHb
	29M
X-Google-Smtp-Source: AGHT+IGGtpp1dzmc7QwuqgW2pSLIm4mtcBhZLeu+2i3+Ni9prtVcG/n56U1c5SPCEyTQDr/U3BLl49JsojBTLduSacs=
X-Received: by 2002:a05:6512:4013:b0:57b:aff6:68a2 with SMTP id
 2adb3069b0e04-57baff66a5amr2706206e87.26.1758560800251; Mon, 22 Sep 2025
 10:06:40 -0700 (PDT)
MIME-Version: 1.0
References: <4ff89b72-03ff-4447-9d21-dd6a5fe1550f@app.fastmail.com>
 <20250917125951.GA1390993@nvidia.com> <02b0f383-1c43-4eeb-a76f-830c2970b833@app.fastmail.com>
 <CAMuHMdVecUeLZ2LPpa457C0a=uduvDhQ4KZJx-++dEFJraRi3w@mail.gmail.com>
 <547dcb81-434d-4910-aa7c-1d69019fcb3d@app.fastmail.com> <20250919143436.GC2132010@nvidia.com>
 <44f910bf-ac2c-4b2f-8e50-5cfc7dd0761a@app.fastmail.com>
In-Reply-To: <44f910bf-ac2c-4b2f-8e50-5cfc7dd0761a@app.fastmail.com>
From: Nicolas Schichan <nschichan@freebox.fr>
Date: Mon, 22 Sep 2025 19:05:49 +0200
X-Gm-Features: AS18NWDJSAue7YE7c8rlG0jvR5lve033dTh_Rnu2Tx6e392cgPO_ZPu-mU9r2No
Message-ID: <CAHNNwZCsBY+ta2-OqD40K0-C8N25PLMYfOJowiVeaEMotqR1nQ@mail.gmail.com>
Subject: Re: [TECH TOPIC] Reaching consensus on CONFIG_HIGHMEM phaseout
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Geert Uytterhoeven <geert@linux-m68k.org>, ksummit@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linuxppc-dev@lists.ozlabs.org, linux-mips@vger.kernel.org, linux-mm@kvack.org, 
	imx@lists.linux.dev, Christophe Leroy <christophe.leroy@csgroup.eu>, 
	Richard Weinberger <richard@nod.at>, Lucas Stach <l.stach@pengutronix.de>, 
	Linus Walleij <linus.walleij@linaro.org>, Geert Uytterhoeven <geert+renesas@glider.be>, 
	Ankur Arora <ankur.a.arora@oracle.com>, David Hildenbrand <david@redhat.com>, 
	Mike Rapoport <rppt@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Matthew Wilcox <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Suren Baghdasaryan <surenb@google.com>, Ira Weiny <ira.weiny@intel.com>, Nishanth Menon <nm@ti.com>, 
	=?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>, 
	Alexander Sverdlin <alexander.sverdlin@gmail.com>, 
	"Chester A. Unal" <chester.a.unal@arinc9.com>, 
	Sergio Paracuellos <sergio.paracuellos@gmail.com>, Andreas Larsson <andreas@gaisler.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 749A818000F
X-Stat-Signature: jbox3egjbrwqy67sgd3dfg5x97d7kat7
X-Rspam-User: 
X-HE-Tag: 1758560802-10893
X-HE-Meta: U2FsdGVkX1/Oy9yDNMHXB5zU0+idZXuwOcEr3WnIdwExiGvGOhT+SqyOEu55LOarHArsGqVUNNWil+U3cIe5Qc+7QtByJijzribsQKmjavbuRhyXxctNdD668q8N6q35id0onoWA+Kw9L/pYFxP16gk/a9TQd7UmE8A2NGv57nUwI8rhNwY1sBMAYzSi6oQ56ahoVQ3lLZLZqM2oCvIr1tCzqGL2bzLljYKlApc8bSVG4BuvQf2oBVeC8tPu3JWZdf14FiZKa+cODEtJcAkLRM0diTN6PBxnLgwiL0pHUKrE4bQkfCMONL+ktOnGfwqMWloBcn6rXG0KMvuUBMA74sJT1uagKDVvNFHm6mxX1Ig4A4xSmaOfhjvgGAEe2PVUftQPp6eEbSeRZXWLJ6sA2zurzY5K6x8USWlkhWlS62/4Js6NZCLRHxoJBw6VOzyw3IywgAwpVfM36CEyVdzEv+NyEz471a3ZRBn0+0HoTLBpzHtseVRpv0N0dVRp699vMQA3jimhp1thRn6u8SU4bYLKvwELr8imv4A/Zzpc3c70bJX650Pl31zKi43fIesKiLbxUQ6sKyuDV0NtbaQ3IndNUM01aWhbg/J21lqqG8qkA1aD1vGS3dbJ8W9x4Oj+DjgMPDFH1xIjrCA+T+LTXTRtmONcVpBkCO6h/KSIKsTx2CPkzwo+CYxSOvd3K1jF2Lcl/i42r64Icv0pcO65Df+xPSh2OQbk46auGtmRiyjBk3OYKBi6nrPu0kLe2Us70xumXJRi/zS7Z2XB7Ar/ynrT6oVxb0E649GJOexTxQq/Cp3d1eDIHLrlN1W96z+HqMvl1hOFM04TCyCD8WVp1xQp6cdakeqlHIyAbmMZl7PqpVFrJNzZpKbzMDjrRokuW152ROv21IMm128kD8TCkMZWBLIVx+1oQi03/5SN/VkpVzJfD7DgLKWgNjqLFu/AoL0RMgqeljpZ9ZDL0qM
 m0eQ98Ew
 fDZ7eacysG7BgFnfmw2RSnXK+mgoAiTaZbrluAv0xsFLVLGJ83eiJ2EioSi4tL+Cm0B09tvQWUp3B7WBMYuXLKEOZlDHEZgW6TVF23K5GCBSWnnkMHpSZVbridtuiK1OBm8tc5hwgvoIQq0/RyTG57dv2FTDa9oj0rQXuKsW0vLK3sTI2Pa18Uqpp+ICJPewGLFgKXPDmNI0n5pnj7r8mO60jc8xhqbpDJRCjvo6ZqFKuUdy0/yaa9AZwHnQgvGvgBYErcqX8B3W2hU10SNXbvYtp3CzMJ6inoXgbDVC49FRPlEC4B40vOWaBWwY/JHtj/kwaDY/NiQAmQCvVLocuP7BjNyns0NBjcSGzLCQ88WbvqERZp+Gtm7u0vlYnr5QyJEV9/7xKK4TrhGI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Fri, Sep 19, 2025, at 16:34, Jason Gunthorpe wrote:
> > On Fri, Sep 19, 2025 at 04:22:20PM +0200, Arnd Bergmann wrote:
[...]
> > I am right it sounds like we can drop vivt cache support with highmem?
> > vivt is alot easier to understand if kmap isn't running around
> > creating virtual addresses aliases!
>
> I think so, yes. I've prototyped a patch for it to add a dependency
> on !VIVT and the drop the code paths that are clearly no longer
> needed without it. This obviously needs proper testing, but the
> diffstat is promising:
>
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index f14bac913d50..0a31cfaf3818 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1214,6 +1214,7 @@ config ARCH_SPARSEMEM_ENABLE
>  config HIGHMEM
>         bool "High Memory Support"
>         depends on MMU
> +       depends on !CPU_CACHE_VIVT
>         select KMAP_LOCAL
>         select KMAP_LOCAL_NON_LINEAR_PTE_ARRAY
>         help
>  arch/arm/Kconfig                    |  1 +
>  arch/arm/configs/gemini_defconfig   |  1 -
>  arch/arm/configs/multi_v5_defconfig |  1 -
>  arch/arm/configs/mvebu_v5_defconfig |  1 -
>  arch/arm/include/asm/highmem.h      | 56 +-----------------------
>  arch/arm/mm/cache-feroceon-l2.c     | 31 +------------
>  arch/arm/mm/cache-xsc3l2.c          | 47 +++-----------------
>  arch/arm/mm/dma-mapping.c           | 14 ++----
>  arch/arm/mm/flush.c                 | 19 ++------
>  mm/highmem.c                        | 86 +++++--------------------------------
>  10 files changed, 27 insertions(+), 230 deletions(-)
>
> I did get an email from Nicolas Schichan (added to Cc here),
> and he is still supporting a widely deployed Kirkwood based
> platform that uses 1GB RAM configurations. He should get
> a chance to test that with CONFIG_VMSPLIT_3G_OPT, but I
> would expect that to continue working, possibly with minor
> bugfixes.

Hello Arnd,

We don't use HIGMEM on our Kirkwood platform, we are happy using a
2G/2G WMSPLIT. We don't need a lot of virtual address space for
userland, and with the 2G split we don't waste physical memory.

I'm happy to test your patch serie with VMSPLIT_3G_OPT and see if it
still boots with it once you send it.

Regards,

-- 
Nicolas Schichan

