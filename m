Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9335F606A328
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 08:19:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 961EC6B05B4; Wed,  4 Nov 2026 03:19:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EBE16B05B5; Wed,  4 Nov 2026 03:19:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DAB76B05B6; Wed,  4 Nov 2026 03:19:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 51E496B05B4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 03:19:49 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E260A140646
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:19:48 +0000 (UTC)
X-FDA: 85396738056.09.A882A63
Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id E60B8C0006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:19:46 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	spf=pass (imf22.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.221.172 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793780387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=42r2UWM+27wxK3ur3WfunLpFTMSv5s5Q7SbgpgMkzU0=;
	b=rsc6P9ya7hpyY46Q38Zy9FgPyJMEooTrZwgls4+D/L7dS3HVGDLpntb1lDqWqegnCd0kCO
	u7MabK/PNopyBcd4+1epXM/6Cu7yv4445vRsfZAU9gWKGb+/zBqq9fHc2//4MzaGKbCvIj
	yviC2wu8t6YNF+TlTUJLU+9CB5ekU1s=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.221.172 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793780387;
	b=ZKBf+72cYZXkDACBaCD4YQQhjL1Q4ZjAvz8t+yTULaKp25ZZLMbliozzj6AlnGED9bN5H/
	frc2nlNS4CThb/zZWVuPrN+ZwcP2q8ltE0iiEO45951O7zhU5XxLDRoe2ZIOPT1fcmmm8l
	9dJOJ5C55lA+N76xGiFY3gvJFGXkQ6c=
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-5eae12762c9so127269e0c.1
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 00:19:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793780386; x=1794385186;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=42r2UWM+27wxK3ur3WfunLpFTMSv5s5Q7SbgpgMkzU0=;
        b=ddgaxUzcZ6A8irEJH622WXNg3ISl6998wKIgtfp16WkpZ6++EUXTITYhpisa7zTQpz
         mK/7SLXVheKzxGBaCkNT8gz+97yVT+vPkUejZ8P17ogHB7VkoB2g1iuNdkQEJZvjxjuZ
         YGaGm2gr+4es/b6LIut+xP7gw5sXDrFgxtLFa47XuZR5daaaqr58o3n9EjZzBtyJzG83
         R8n90dXem4Pr0NlSDYR2ww+BzHBBHcRWRnlzsx5XcADQKgKcRHNWjfx5I1DH0CTUFIub
         iz/0JIq84zUpydyDamqjzYY5V9npOCc4Mq66WWreKx6mDL0ftbqTUKq5RYKiHlBIev9t
         lJ6g==
X-Gm-Message-State: APuU4Z/OVS04OP0MGzDaEcfiNFJbzpq5hFCvUEZsKeWLU4A6PJ4x3o0R
	hsre2G0wSZ+HCHy0QhfO9Klcov09bOgb+PHL94gk2uJX+/eGUm9Uaw0qioforyZd
X-Gm-Gg: AYBFou3+1v+GJc/l8u49dgE5N1/4i5gHzEh1RilAj5O1qYL6VK98+IOLR4eaTaPbXTN
	0C/qz46ejDwNNSP3yFpYDuAe5IYyN12N6EwvR9dvk2MQt7tC3AHXbxHxGjNSmTbLV0uaqzeOxJr
	E0EtdcIUqlIa0YOwqVoBxHzq62DYSdP6RR9rVhGP5LeGGz31jY0CpZWWMRhp5s2l+xIgd4XTLKX
	0nE2ZRYvD+Qm9W0kKIqvaO9kuH6MtIaMNMHHHRwLnZDdZcZuRuBPhIwiZYV3gyXX4lZ5lMym/AJ
	uTPhMkhlJjcszcncdz/fWPefoCLbyxMYQ37eylG74fO04AAJoqe2gr5fWH+2HwrsD2FG8/LTU8O
	TqBdpc1kHqwMFDtM2Qwh3K1yG2pB3w9Zf+6Bl4jletbyqSGYHVo+PhKAzvLImkNdJFinu4iAKMA
	MemX3t8lkIHLZKTVg4AB1IPcFxK8KdP5EM35XluZXPsqNfV4dwiRzrBFQ7kzBR/cvN1qwf2lefC
	4DxC9l0x0TeF4hHT9YI1uyk4L0DGwVd2GrrmhhLVHCI+OwFTJJLEqNQ0Rmvt9w3+QRbR2hmF1kW
	3qlnVv/l/7w1sp2JBP6TBkx/K4GCmiofmE+7EuQLfjSD0ACEez4zmCuixnTGMQHomTCgSMw7Zkt
	K/DT+eMNlPtA=
X-Received: by 2002:a05:6122:3285:b0:5ea:db3c:4a3f with SMTP id 71dfb90a1353d-5ec68513891mr6307469e0c.2.1793780385927;
        Wed, 04 Nov 2026 00:19:45 -0800 (PST)
Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com. [209.85.222.54])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5eca8d77c6esm1159553e0c.6.2026.11.04.00.19.41
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2026 00:19:41 -0800 (PST)
Received: by mail-ua1-f54.google.com with SMTP id a1e0cc1a2514c-998318396ecso104142241.0
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 00:19:41 -0800 (PST)
X-Received: by 2002:a05:6102:f0b:b0:7a6:cd7e:72db with SMTP id
 ada2fe7eead31-7d072cbfbd3mr6080742137.26.1793780381117; Wed, 04 Nov 2026
 00:19:41 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <CGME20261015082334eucas1p2a3bbf3650f279abbd39d05d63e35aba6@eucas1p2.samsung.com>
 <20261015082315.56876-1-m.szyprowski@samsung.com> <20261015082315.56876-3-m.szyprowski@samsung.com>
 <CAMuHMdXcM9yvwLBSi-aYRinG3omhu5aoeNVYynfFQsnDDWR-Hw@mail.gmail.com> <b71ac175-fba5-4f61-bbdb-0b98dec9ccee@samsung.com>
In-Reply-To: <b71ac175-fba5-4f61-bbdb-0b98dec9ccee@samsung.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 4 Nov 2026 09:19:28 +0100
X-Gmail-Original-Message-ID: <CAMuHMdV2ET0Y_=m3LHmL12VNhqK7tBKod0kph6GdZ7Q8XXhP8A@mail.gmail.com>
X-Gm-Features: AclHuK8Bo6Tf1rmFVBv8cZ2-rN7MQ3PgSfZx0PHZRwoGrMuxFYn-96u56ubwNso
Message-ID: <CAMuHMdV2ET0Y_=m3LHmL12VNhqK7tBKod0kph6GdZ7Q8XXhP8A@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] of: reserved_mem: allocate and map the
 reserved_mem array early
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-mm@kvack.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>, 
	Rob Herring <robh@kernel.org>, Saravana Kannan <saravanak@kernel.org>, 
	Oreoluwa Babatunde <oreoluwa.babatunde@oss.qualcomm.com>, Wandun <chenwandun1@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: nqtzckocg169fqy8hdx3u4e51mzjju6a
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E60B8C0006
X-HE-Tag: 1793780386-626300
X-HE-Meta: U2FsdGVkX18AydaJuTajz+Q8a9dIkZafB15KFp7DwOuq3KF0sULSXmq5PUKPuwQNFhV64+yCAs2zIOAqzjeoITJfvcYWy40RI2crOO1Wa9TaeKt5bttGc+wfcuf+Cm3+dWUzEtJyxZu7KNlX3J58BXkwOQK00nHi1Xr5Z1Ap0jOYiJR6eiTpqfhJkDY0o4WLKg7xa+sIy17ga9pbZ/FFY4GjwfcFLtDhWBkd7of8c23svAN9p5/TS8RnvfmHY1yyOUHS1T4C/+N3NUocm5+lKEYSeaE6a9nxYWstb1p/sMzBFM9iBTropNnxDEL4QunrUOCEkKYhmBPBERIRTPro2REcpvoefvlEp+OIOhEUW5yiEIzf56K4+onO9ENd6YOiKThS00AKOGUFr+aQoZuqgK2nsDFq5KdfqgCVE53HXqggUXDW3XHxjPLk08SmCj0Xtph+10pNvcUWyhyzRMSc8j+Fo+x7fXrNESo+tlykUyvIa0ddfMxH4gkZBZzBxf5Fe8SO68WZqFzzuJVFYIiRKIVLyaRWLsCoxAF+Cl6QFl9wq56pcpobjEx/QecMxHFV3Qmtpy+5aoB2/s7dXVGtEpiLkipX25TaYSAGZpvgfXvgUMXLa+bqxtY4nkM7jSEFnT+gvnR0UUNxXi8oWX5gnMUoarlCk2C3+hfL4fBx6Jm/F/4Jq+AjeitNovHjX8FgoOIopLBnBjgMoipniqF6ODT0zmrNVrOWFT3b8XjUpaha+tKfiyZAgc979gIHXB0lb/xR3rSyyXxGDG3YlswHr5Qj+C5LKjs0X5W4s6ZPsJdPjKyixA9RmDAinZ2WMAJtdluhXiUHfxF9UxAy02XKrgKrf/bZcL4lnOFc8/385vBwMqI1iENnO97IfEjkljxeAt1IzDB2EDWRaN6fDG/9sL7YayXpbrNeX+Ztq5n8r7t9DbKBg0oRguyorFbgROOiXggC2b3pShjgxQgydOw
 X6+xu9Ut
 Q3JBtm+um1VuNF007VjFdCH3sGIwwjNKXq072Ed4nPg6xB2MkuGfxjvcZUb8FvbsiuVL+nw/mZIEVoJZ5NllaAQthxR4Zso/Pp8//9AlKwsIFom1N03f3Az8/ZagUeUP0qsPK5VYBpHFmcY6al16xrIfYIxbEXRD5z9e3SZDgzWMSY6jDqjnEIam1FegWshGnPwZh+1FZzyFPn9yVlURYxaq2qBoC808fwdDvMIzyDzqNEJpuME8OfmaxcXBacIGNL5jYcVilrDh2Wv/Cjby2CuGNGn5YJhbjtv7I9Vj/8X95jgEUcE0zcFxEnMbq1kp3f5XgdY2ZK+1DBDWRmcRVKZQcdokd0JKb9PqnURGTq6aVakgC9XcZTLQVBftqsOojH2lDPc0y3Jn88aTvEQSqA2OhJYFQ4GXuraoavV6PXedTHiev6l+qxlMHTj6DeSvhtrsRPxAtI3kyTPjcjKitoo3NA294C7FbOdIqlSrxF0xh4t2Pk1N71NBzJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Marek,

On Tue, 3 Nov 2026 at 20:25, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> On 03.11.2026 19:04, Geert Uytterhoeven wrote:
> > On Thu, 15 Oct 2026 at 10:29, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> >> Get rid of the static, limited-size reserved_mem array and replace it
> >> with array allocated by memblock_alloc_raw() and accessed directly or
> >> through a temporary early_memremap() mapping (depending on the
> >> architecture support). Such mapping is needed for some architectures
> >> (like ARM64), where linear map is not yet available during early boot
> >> scan. The array is allocated from the bottom of RAM to avoid placing it
> >> in highmem area, because some architectures (e.g. Xtensa, C-SKY, MIPS32)
> >> set the memblock limit to the end of lowmem only after the early scan.
> >> The early mapping is not used on PPC64, where the scan is done before
> >> early_ioremap_setup(), but the memory allocated by memblock is already
> >> accessible at that point.
> >>
> >> Having a single, writeable array with all reserved regions removes the
> >> need to perform two step initialization introduced by commit
> >> 8a6e02d0c00e ("of: reserved_mem: Restructure how the reserved memory
> >> regions are processed"), so all regions can be processed during the
> >> early scan again.
> >>
> >> The reserved_mem array is allocated only after all static (defined by
> >> the 'reg' property) regions are marked as reserved or no-map, so it
> >> cannot be placed in any of them. Errors of the early reservations are
> >> not recorded per region, only the fact that some of them failed is
> >> stored and a message asking to fix the device-tree is printed. The
> >> region specific init functions for the static regions are then called
> >> in a separate pass, once the array is available. Then all dynamically
> >> allocated reserved regions are processed.
> >>
> >> Suggested-by: Mike Rapoport <rppt@kernel.org>
> >> Link: https://lore.kernel.org/all/asc6brs_g0ky0wOM@kernel.org/
> >> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > Thanks for your patch, which is now commit aa05faf815836c47 ("of:
> > reserved_mem: allocate and map the reserved_mem array early")
> > in dt-rh/for-next.
> >
> > This causes an early crash on BeagleV Starlight Beta:
> >
> >  [...]
> >  earlycon: uart0 MMIO32:0x0000000012440000 (options '115200n8')
> >  printk: legacy bootconsole [uart0] enabled
> >  printk: debug: skip boot console de-registration.
> >  efi: UEFI not found.
> > -OF: reserved mem: 0x00000000fb000000..0x00000000fcffffff (32768 KiB)
> > map non-reusable framebuffer@fb000000
> > -OF: reserved mem: 0x00000000f9000000..0x00000000f9ffffff (16384 KiB)
> > map non-reusable framebuffer@f9000000
> > -OF: reserved mem: 0x00000000d0000000..0x00000000f7ffffff (655360 KiB)
> > map non-reusable framebuffer@d0000000
> > -OF: reserved mem: 0x00000000c9000000..0x00000000ccffffff (65536 KiB)
> > map non-reusable framebuffer@c9000000
> > -OF: reserved mem: 0x00000000fa000000..0x00000000faffffff (16384 KiB)
> > nomap non-reusable dma-reserved@fa000000
> > -Reserved memory: created DMA memory pool at 0x000000107a000000, size 16384 KiB
> > -OF: reserved mem: initialized node linux,dma@107a000000, compatible
> > id shared-dma-pool
> > -OF: reserved mem: 0x000000107a000000..0x000000107affffff (16384 KiB)
> > nomap non-reusable linux,dma@107a000000
> > -SBI HSM extension detected
> > -[...]
> > +Oops - store (or AMO) access fault [#1]
> > +Modules linked in:
> > +CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted
> > 7.4.0-rc1-starlight-00002-gaa05faf81583 #411 PREEMPT
> > +Hardware name: BeagleV Starlight Beta (DT)
> > +epc : __memset+0x68/0xfe
> > + ra : fdt_scan_reserved_mem+0x3a4/0x80a
> > +epc : ffffffff8087fd88 ra : ffffffff80a313c8 sp : ffffffff81403c20
> > + gp : ffffffff814dc6c0 tp : ffffffff8140cf80 t0 : ffffffc4fea38ff0
> > + t1 : 0000000080200000 t2 : ffffffc4fec03008 s0 : ffffffff81403d10
> > + s1 : ffffffffffffffff a0 : ffffffc4fea39000 a1 : 0000000000000000
> > + a2 : 00000000000000f0 a3 : ffffffc4fea390f0 a4 : 0000000000000008
> > + a5 : ffffffff8087fd88 a6 : 00000000000000f0 a7 : 0000000000001000
> > + s2 : ffffffc4fec00000 s3 : 00000000000000f0 s4 : 0000000000000000
> > + s5 : 0000000000002de0 s6 : 0000000000000006 s7 : fffffffffefefefe
> > + s8 : ffffffc4fec02fd4 s9 : ffffffff8148e318 s10: fffffffffefefeff
> > + s11: ffffffc4fea39000 t3 : ffffffff8150df00 t4 : ffffffff8150df00
> > + t5 : ffffffff8150df00 t6 : ffffffff8150df78 ssp : 0000000000000000
> > +status: 0000000200000100 badaddr: ffffffc4fea39000 cause: 0000000000000007
> > +[<ffffffff8087fd88>] __memset+0x68/0xfe
> > +[<ffffffff80a2f63a>] early_init_fdt_scan_reserved_mem+0xa4/0x110
> > +[<ffffffff80a06c8e>] paging_init+0x17c/0x46a
> > +[<ffffffff80a046dc>] setup_arch+0xdc/0x584
> > +[<ffffffff80a009b8>] start_kernel+0x98/0x940
> > +Code: 0000 8793 00e7 8305 97ba 8782 b023 00b2 b423 00b2 (b823) 00b2
> > +---[ end trace 0000000000000000 ]---
> > +Kernel panic - not syncing: Fatal exception in interrupt
> > +---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---
> >
> > Reverting the commit fixes the issue.
>
> Does moving early_init_fdt_scan_reserved_mem() to the end of setup_bootmem()
> in arch/riscv/mm/init.c change anything?

Unfortunately that doesn't make a difference.

> Could You provide a full boot log from the working kernel and /proc/iomem dump?

Sent by personal email.
The relevant part of /proc/iomem is:

    80000000-cfffffff : System RAM
      80200000-80201fff : Reserved
      80202000-81730bf7 : Kernel image
        80202000-80aa7e73 : Kernel code
        81000000-813fffff : Kernel rodata
        81600000-816dd9ff : Kernel data
        816de000-81730bf7 : Kernel bss
      81730bf8-817fffff : Reserved
      88000000-88007fff : Reserved
      9c000000-c7ffffff : Reserved
      c9000000-ccffffff : Reserved
    d0000000-f7ffffff : Reserved
    f8000000-f8ffffff : System RAM
    f9000000-fcffffff : Reserved
    fd000000-27fffffff : System RAM
      2772e1000-2773a0fff : Reserved
      2773a1000-277fa1fff : Reserved
      277fa2000-277fcbfff : Reserved
      277fce000-277fcefff : Reserved
      277fcf000-27ffcffff : Reserved
      27ffd0000-27fff6fff : Reserved
      27fff7000-27fffffff : Reserved

Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

