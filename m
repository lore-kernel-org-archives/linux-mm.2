Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DF95EE644C
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 15:49:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C0116B0088; Wed, 31 Dec 2025 10:49:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 677286B0089; Wed, 31 Dec 2025 10:49:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 575786B008A; Wed, 31 Dec 2025 10:49:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 426566B0088
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 10:49:47 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E9D9C1A764B
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 15:49:46 +0000 (UTC)
X-FDA: 84280201572.04.15AF647
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf10.hostedemail.com (Postfix) with ESMTP id 039F2C000E
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 15:49:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=V5+8zPMK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of linmag7@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=linmag7@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767196185; a=rsa-sha256;
	cv=none;
	b=G/1gYcpCITP98sXTn40s3ISQHBZreAhVZVEPdI2Q+cv+KqLy8KpGtbthbiJeEJv7YwKD9k
	28NU4HaxCIasBb9jIZs83hlgZI9DS+0TJYMMoFyQEyTr4EnU16ebc6FF48qs1BwI6FtAYz
	Z81hYWa/TXfxyFIlHZcj5iwMXmdh5tc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=V5+8zPMK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of linmag7@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=linmag7@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767196185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H6r7yw9l553CBnZ0Oq6/Kvj3e3aIbXAlTRdm8Qc8sow=;
	b=VAX5U37IDiKwhZO+uX/HXkR9mQ+PyKIqTInCl+QCQGV0WvqQa1Iw+EFKwoDvnvZ1dHfmu4
	Xv2xTMkc2wQMwSZZXCGfoDbwtGDJQRNcjXc2ov4vdxn/zKJs2HMJmVC/VB0r4ytRk6Ui67
	cumgnzUi624AIXGEx/NxRJ6JkBKUiGQ=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-649e28dccadso18458985a12.3
        for <linux-mm@kvack.org>; Wed, 31 Dec 2025 07:49:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767196183; x=1767800983; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H6r7yw9l553CBnZ0Oq6/Kvj3e3aIbXAlTRdm8Qc8sow=;
        b=V5+8zPMKetgfI/fFH4vBRMqiEI1Jic5u5CNgvrfWicz0vmenH4NbyJ7pesDj4I/KZI
         X/6tSADcFoSKvCp9rX3kiFe0XwjjSJFQoh5hRNb2hbYSe6vj5GoP37XDDmPW/XHaqHnA
         PYb4RL/w4CvZ3XKN7uS5GF7Nxomtu22CTmQJJ3Ew5y4S6mqFICrf56qKzXap3YaDJKT3
         aFtveWGmN59jPpeCZ++bzE2JKRHNns/6X9oyOFMhI+86RpA38qFZNrZRd/xpIYWX20Ry
         4xwmEoYogF2VXdzJbjEPAkWJYOllIhDi0mk75635TiX/a9hS8a4HzYmiDUAp2gryEPCm
         rssA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767196183; x=1767800983;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=H6r7yw9l553CBnZ0Oq6/Kvj3e3aIbXAlTRdm8Qc8sow=;
        b=rCAZuh9nTHWp+rNEJCvNj1GK081oWEqExOjETEt9zdtq79oA9aBpWzMvH5xTDQzzOc
         fRLWDI8ASERVFtP5fDgstrbVJMgq5yTvtul3JCEGT4cE8vpKpYP4lCp1TLVLBPz0ZN+B
         d9YVyFiFGSup9LPUu+ieXCQbQ5ft1gqZDoOPaOdZTHHDuXHl2M6Gp+Rss00g+nf2DYXj
         uEVRaR2JYdNzxBkYIUEjwyjakqT+NTmxx4hvY41IO9dk6n4atZqitYVjRdyv6wfGhDVN
         bz4QWzJINw1TGLettwFKP4s6F+RChGtx/ZcPt50DBLtMWdReFC9ciIwRplBoBGaaPTTM
         P16w==
X-Forwarded-Encrypted: i=1; AJvYcCUrAH8mPuyJKbFFxCCggSJk12R6CMmiYnL0EJBnzyfFwvld1TIY5fga056r0fnC1y/r0n7lL+rsaw==@kvack.org
X-Gm-Message-State: AOJu0YxtNQMrcGMX04glsvs9ozEhThRpnOKwSP5CQ1/da9iwvhzF4C2c
	7fclAGm9uluMWGJ/+yiEBN1cPRZ9RLWLgHJgapQKnGL3VN1tJtylLwEpqGvB+aaccemB233C6kk
	ANU5eqMMzdhcTZUV9YU2gzb1fv8OfUCk=
X-Gm-Gg: AY/fxX5Yopz795IlAmaSVM+JXAWtlaMswrt6pQn29Bvs0qlxo2It0Bic4avLi+0F6Zz
	GOL7j6tSQxbx8O/9G9Z5FS3o8m16arx23G431FkS5yS30hWso4LG0/Y4Xr2z47A6oCbj75gs2FO
	7Unr05jB7p+ZD9Zn16Ooy4Dk2BHmEZfmOuX4drO8jqybqOOVHNE7Vwz2Sxw+sQpUPNdE+B/SuoK
	MRyhmiyDvR06Lzlvp5SXBLcEvHAKvss4RMk17+2tNKYn2ti67dx0SXIRnzKvur1PCfDR8NJ
X-Google-Smtp-Source: AGHT+IFWPXcZKnGq0Krk9SV9S7c2h0pNtpTmEWv1Brc1vDiv5zIRm5JUQPWxix5qBNEZM9fT8eFcchz/mGnlgfTZ7QQ=
X-Received: by 2002:a05:6402:430d:b0:64d:170:7976 with SMTP id
 4fb4d7f45d1cf-64d01707bacmr33060451a12.16.1767196183052; Wed, 31 Dec 2025
 07:49:43 -0800 (PST)
MIME-Version: 1.0
References: <20251228124001.3624742-1-rppt@kernel.org> <20251228124001.3624742-2-rppt@kernel.org>
In-Reply-To: <20251228124001.3624742-2-rppt@kernel.org>
From: Magnus Lindholm <linmag7@gmail.com>
Date: Wed, 31 Dec 2025 16:49:31 +0100
X-Gm-Features: AQt7F2rayRHt2K_8t_heYN2h4Fxse0t-QPEGBzoKWlAlrWu2fr6sWsAyLE9oYEU
Message-ID: <CA+=Fv5TDfwnu7Qf2y=PLWWN1EvNpNbr8habnTO7R4_caAySDzw@mail.gmail.com>
Subject: Re: [PATCH 01/28] alpha: introduce arch_zone_limits_init()
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alex Shi <alexs@kernel.org>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Andreas Larsson <andreas@gaisler.com>, 
	Borislav Petkov <bp@alien8.de>, Brian Cain <bcain@kernel.org>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	"David S. Miller" <davem@davemloft.net>, Dave Hansen <dave.hansen@linux.intel.com>, 
	David Hildenbrand <david@kernel.org>, Dinh Nguyen <dinguyen@kernel.org>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, Guo Ren <guoren@kernel.org>, 
	Heiko Carstens <hca@linux.ibm.com>, Helge Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Johannes Berg <johannes@sipsolutions.net>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Jonathan Corbet <corbet@lwn.net>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Matt Turner <mattst88@gmail.com>, Max Filippov <jcmvbkbc@gmail.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>, Michal Simek <monstr@monstr.eu>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Richard Weinberger <richard@nod.at>, Russell King <linux@armlinux.org.uk>, 
	Stafford Horne <shorne@gmail.com>, Suren Baghdasaryan <surenb@google.com>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, Thomas Gleixner <tglx@linutronix.de>, 
	Vasily Gorbik <gor@linux.ibm.com>, Vineet Gupta <vgupta@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Will Deacon <will@kernel.org>, x86@kernel.org, linux-alpha@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org, 
	linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, 
	linux-mm@kvack.org, linux-openrisc@vger.kernel.org, 
	linux-parisc@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, linux-sh@vger.kernel.org, 
	linux-snps-arc@lists.infradead.org, linux-um@lists.infradead.org, 
	linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev, 
	sparclinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 039F2C000E
X-Stat-Signature: 9xziuw3tsowbkyuef75yxax58jjd35fw
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767196184-519492
X-HE-Meta: U2FsdGVkX19D7s0ZFjqKhiIONDsYpulzuf57MVjYRH1gHAzAaZS5SsvIXeFU37QDbxy81G6FDbR6mbZbhlsxSZJNcXXdcZHLPdmK++zsrPJb7hzIHVUKmEzQoC/EYzwDoB16wrwZ7oCIIHvvEUc9gYSvS09jNG8cyMUeMR3Fq+1JI4Wv2brTQ9ZKQjBxvV6LRP7F0os50oHaozFGTN5WvRoSV3QYnxNTi1vdpIo1vD2GrjsLlVoxz9XVzfwLrTvvaqn4NZTRNMRFMHubZXEH3Y6APRqZRMSEUA+FkCsnrl8l1BiRXeb/BKpImcGGV6S7JQsmroE+RQTsLYBBgUHL1OvV1Ur4+fTIcnJM4THjkCLkHxpoBMx5maCGdVDSxv+e7OOcvL140c5+a2OBh9QLEJUU2F3Gd6gGa1jUerH/jaqeN9ZsQJVcWddt7WyW4c22W9cIsZzYYwujc6/+MHQeP+zniRLgarQeLnl53kKrigKmH82oL8R6TCru3ncW2oIzvxP5siFSIkiUkpWC0Dsyd77s1iwj/bFqYs2yOkGAc1j0MBXD366qRkp3XPjyBmjdHCENvFt0W/F9prs/2ii+b/nKOBYk7lhyIOiDUFGlrjIYa19zpVUxgHuW1TS7nqkIF2Vmtzda4SSX9EVRjnpsCZ5l490jyYEz3Rnv2gDcvJuVfHq8Uee9L5nEN62D40FeUoJkZfjmJ0mnifLr0myALuuMhYrHlYFZjwr3Py/83msQxwJTSs0m2CFUAW2BVPT6FZj6wnjXwUV+cS5t/Jr7Xc/j5kqszf+mU5UXNb2PSH0D54R6zJiuz9ikwEq1dPAIc8f/sb1EVnZekBg+JXmRg/IBCfRJB6PswIm7Iih5jTE87gaqTgRGoVJkuVslN/51Ms72tiSftzXdTjOnMF55F2N2d1xF5mET7W1TqNPrceCBJKqz0BGrCjvx417NHz9tNmqiYqHEocBMACtns6i
 zXu0q1Wd
 hGFLFO9RCAIZhNbJkuwBAT18PvaiYdYTGzOppTIydwWMPc+6t/KT7AAdrTXyK4Xi2cklRA//pSBHUbi0aMTcAIKNqpiLSFKAd3qdTbb19TEmThgHrXaPiIxwHWnKTVCcq3eWWQ4mI4oEL7tFY7r+lgWOw1Mo5A5s1RY3hvCPT/tjsDsydTjw/qEZKackk2PaONPjXjxTtb/ge6g5cjbu8cjUDeNa96UIgeKFiHHNN9sTg3bdJC3Nmef7+9ph/RBUY6khqvMxXyfaIo3dM039PoOzh05DKkXbGVpvsCtcTI4H1vMkyoLOa6UK1ra5GD10QOy7LfyIu3+luuLEIbOMJzM92YYFtVhZzhD5+9LSaV4NUTNGyvNKov2SuwetDnNrD/yL8d/Zt1K7k9bZhPivvJZ8KDmT49U1aj1GewlzYYbQ78rTVdqvQgEd85qB9NkqRlNmUbMd7DbcR7NwSFzYF9fV3oj0NDqQL+NhHI80X5jG1svU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Dec 28, 2025 at 1:40=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> Move calculations of zone limits to a dedicated arch_zone_limits_init()
> function.
>
> Later MM core will use this function as an architecture specific callback
> during nodes and zones initialization and thus there won't be a need to
> call free_area_init() from every architecture.
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  arch/alpha/mm/init.c | 15 ++++++++++-----
>  include/linux/mm.h   |  1 +
>  2 files changed, 11 insertions(+), 5 deletions(-)
>
> diff --git a/arch/alpha/mm/init.c b/arch/alpha/mm/init.c
> index 4c5ab9cd8a0a..cd0cb1abde5f 100644
> --- a/arch/alpha/mm/init.c
> +++ b/arch/alpha/mm/init.c
> @@ -208,12 +208,8 @@ callback_init(void * kernel_end)
>         return kernel_end;
>  }
>
> -/*
> - * paging_init() sets up the memory map.
> - */
> -void __init paging_init(void)
> +void __init arch_zone_limits_init(unsigned long *max_zone_pfn)
>  {
> -       unsigned long max_zone_pfn[MAX_NR_ZONES] =3D {0, };
>         unsigned long dma_pfn;
>
>         dma_pfn =3D virt_to_phys((char *)MAX_DMA_ADDRESS) >> PAGE_SHIFT;
> @@ -221,8 +217,17 @@ void __init paging_init(void)
>
>         max_zone_pfn[ZONE_DMA] =3D dma_pfn;
>         max_zone_pfn[ZONE_NORMAL] =3D max_pfn;
> +}
> +
> +/*
> + * paging_init() sets up the memory map.
> + */
> +void __init paging_init(void)
> +{
> +       unsigned long max_zone_pfn[MAX_NR_ZONES] =3D {0, };
>
>         /* Initialize mem_map[].  */
> +       arch_zone_limits_init(max_zone_pfn);
>         free_area_init(max_zone_pfn);
>
>         /* Initialize the kernel's ZERO_PGE. */
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 15076261d0c2..628c0e0ac313 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3552,6 +3552,7 @@ static inline unsigned long get_num_physpages(void)
>   * free_area_init(max_zone_pfns);
>   */
>  void free_area_init(unsigned long *max_zone_pfn);
> +void arch_zone_limits_init(unsigned long *max_zone_pfn);
>  unsigned long node_map_pfn_alignment(void);
>  extern unsigned long absent_pages_in_range(unsigned long start_pfn,
>                                                 unsigned long end_pfn);
> --
> 2.51.0
>

This looks fine to me from the Alpha side.

Acked-by: Magnus Lindholm <linmag7@gmail.com>

