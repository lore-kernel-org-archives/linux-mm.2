Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D52F606A32C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 18:04:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C37D36B05B4; Tue,  3 Nov 2026 13:04:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE8616B05B5; Tue,  3 Nov 2026 13:04:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFE8F6B05B6; Tue,  3 Nov 2026 13:04:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8AF806B05B4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 13:04:45 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 368D88043D
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 18:04:45 +0000 (UTC)
X-FDA: 85394583330.18.5502EE0
Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3EA0916000D
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 18:04:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	spf=pass (imf08.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.221.172 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793729083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6s58Pb4hAe6Hy7/bwQYEC0q1H7BmJZKjEQo1aMto/nU=;
	b=SIiU8b8xLnI846KSXe1yTB5Nf67KwL0nMQbyixHPpNoKdXsJVuAcccC3aEpCUeWvKKuNxR
	2piROoUq/lQn83w5dQcW+BHQT1cavH5LGU4dwtPw5lHUz64JWUvZdPOdJuUN/QicNl38Ma
	+dgtPjHJeCzF5WOfVV5b5r1G5jLRW9w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793729083;
	b=ZYEO1t4cP7if6JnOySUy+j5h2cqaOuqkQV1OLj9ahIMuPYQKDT5Zx3zUK30sZKvVuc9MyW
	vC1+SJ3N2v80q2eTwnVEAWSHhnWp362kEW2HMuiY80wSRbEn7HJ1QH57h1kKjkEwMgsPtK
	wS721RfQ6BAuuoRvT6qtY30CS8LOjqU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.221.172 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-5ec20398b05so3106627e0c.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 10:04:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793729082; x=1794333882;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=6s58Pb4hAe6Hy7/bwQYEC0q1H7BmJZKjEQo1aMto/nU=;
        b=LN78S9aBAsr7Mn3NP8hZiY3CNkd3ANoCsutPKSq95wZMWPbdgsOvrQ4xObZQZ7Y8/I
         fFfzt2z9ufyfqb7IkjaciI3haP1Cgxy1hG4T34F5/9V7Mbga29/M8xBfBTjaVvR0pbMj
         j5nZPdhSSm6UY5VNZ324DXmk4w3yL9xJLtvEuOwnJCzhG02mi7JLb0R7Pg40dXaf7iJg
         W7/grV4amnVBh7P1mfVb0VQ5uSC1sBXgP6G7DPybLPFTGLJc77tQOSX5gz2HWaRJXUYZ
         6EnlYJQYDk+Q4bRmtrcVp2uhcueszGJZbnFmt5AB2XxK8TSForpiJ9ukhdDjpNONKzdd
         OEGQ==
X-Gm-Message-State: APuU4Z97OG3ye0osEllRVUOaZxUhadl2gy53yqyjJQnFjzA8mzdCYotI
	+A56vGdaxFcQV4m+Y3BQHcEdxyFMAES9L3l1fTSUEgbZWVmNoc9q6YvHBUUR9tdm
X-Gm-Gg: AYBFou2wozaR9qAADLBlscvYHvnA9UkSJHl3T5Y7wXzAv62zmyhKn2j/WcunnSefH2s
	WRtya1mjght3ekwgrD1CEf6r/U48cCzfK/tWz8y2H12LnyikFaBsKoKGd6hykCL3N0oMrtcKeQi
	We5bcL1icidDxxBiYYQuFQ3B44itiBQxHAujN+JbaE2pLLL0vo7Q5LR8lRKHlIJf15A+crM/0VA
	GQrocmS7PN1pzpNHWfUrup68h264L9Ie86rhkNhraZG+iqLeIXPsWzLHsqk0a/hvi4UeTeck6ax
	097G2jGO2qn3UUTJkFhepe8DUflAaLC9NZsgFkglnbKx7KGptXPs38PETBhzexMDPxxurObXuOB
	7J+ZOba6y0REMhFbF8f9AHQNy98hhx6QOCicuy6NQG1n3Hiipn4MZq4OMynHcU9/qHrKJrm6K8C
	Kl/4cRbavK9BXVuUe1V9RhKO1wGWutTLO5jBJU2e3Se82MPJ/Sk1FbfwAyo7UoMsB6fWqk4NbBH
	kYVmuS6L0VBrkKp2XDNZz2f0NjlCXo8pcat19Z92dljjguRhrh/Hvk6TD56KjRN0eeiiEBPGd+5
	EKBhrqvKZar0OoBIpD3Ewrl14d5bb6Wp2ktkNvx+Mz9pte1wJMXoApJIaMae4lgE6A==
X-Received: by 2002:a05:6122:2108:b0:5ea:be1b:1b24 with SMTP id 71dfb90a1353d-5ec68944fd6mr6043236e0c.13.1793729082245;
        Tue, 03 Nov 2026 10:04:42 -0800 (PST)
Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com. [209.85.222.44])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ec69c5389dsm13274048e0c.12.2026.11.03.10.04.39
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 10:04:40 -0800 (PST)
Received: by mail-ua1-f44.google.com with SMTP id a1e0cc1a2514c-998749fe872so205873241.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 10:04:39 -0800 (PST)
X-Received: by 2002:a05:6102:14a3:b0:7a1:f951:664f with SMTP id
 ada2fe7eead31-7d072ca34famr5656944137.22.1793729079166; Tue, 03 Nov 2026
 10:04:39 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <CGME20261015082334eucas1p2a3bbf3650f279abbd39d05d63e35aba6@eucas1p2.samsung.com>
 <20261015082315.56876-1-m.szyprowski@samsung.com> <20261015082315.56876-3-m.szyprowski@samsung.com>
In-Reply-To: <20261015082315.56876-3-m.szyprowski@samsung.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 3 Nov 2026 19:04:28 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXcM9yvwLBSi-aYRinG3omhu5aoeNVYynfFQsnDDWR-Hw@mail.gmail.com>
X-Gm-Features: AclHuK_SLyopQmsKezfvIJp8vgdHBUR6jbYkiTzIVRA3K3sJMZtG6ZwxF0OVemw
Message-ID: <CAMuHMdXcM9yvwLBSi-aYRinG3omhu5aoeNVYynfFQsnDDWR-Hw@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] of: reserved_mem: allocate and map the
 reserved_mem array early
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-mm@kvack.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>, 
	Rob Herring <robh@kernel.org>, Saravana Kannan <saravanak@kernel.org>, 
	Oreoluwa Babatunde <oreoluwa.babatunde@oss.qualcomm.com>, Wandun <chenwandun1@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 81sytuxoip38atdcnqnfhsjdm14rko7g
X-Rspam-User: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3EA0916000D
X-HE-Tag: 1793729083-119272
X-HE-Meta: U2FsdGVkX1+KybhGeWGl9FebQ7Pimt6HOm7oORXtYHrqf/VRxerAxhArRXOHSoqP2ZnH7GkwCFk/CR5z4pmY4RTOjgBYxPpg3F1xrdAEQVbmAC+wnqO/Yccq/WkZbZrVIctK6W/QPjeCL0XjfdGllwqh1qMT/g7Eod7XuHPonuyJb9LAN6C9dB8QdNpRPwXW/dXTprwT4gzvQPBATgSyZga2ketGggdTEAdkUxH3npfI1lRbTc/++g6sIQ4mhXeh/JlQYfcvX2N/KT0DUplb5uwRDXuWnusY3EmF9XRG7pr3LMBX5ID+L+8/TL1gJqcFgeAvShGFYj6xbCS6myc5u4JN+jkNd+1MsPPUIxbSLV56mURoqW7m/1Jjd5Px6k1VuGQZMnlNYgZQoiwgwa/YLNTuoxn2XK032kE+Rm4TKRqx2HCr5S6+6+SMyPRfY+re6LbTTZb1lDL8RJbRA2cNRRXxKWseHGJqHntV3/L8V0b2CvjuKC8zwRJqo5di0kPlew3CB5lTzfSZg28JSZihBCVm0EDjWFqSDgH3LHNCtwX72cvYFVXNMCACIbmMZXe7ZD68x8pPVtwoUBDuJGOGVxiDBeFFyjRi2Wd4WvCAbaGzzMp55UajEQWDlj3ub3yVAXG9v6q6QVkRkv+YS5XMxHOyeWpxaySZzqt227poC2byhwNhtz7d7iL/0vOBKhkPZJhdZHglzzEArZHlrYncSlGZY+KcjbfOXvJ0H3iHAHAjpB3PTXagZM7I15welYcj+C9R/tIc2vN4QE34s+zhrcAj9tguZzafKcldsmn1Nh8yTVFUA7kkc1QhQEBQv7RmoQ3MEeMcKR0bgq/cmHl2VrJSjoHFXshZs6xaYUQd4C0BpoEi02/+96dSfNKVZXYInCvgoc27aggU91vdBPn+/DtK2E1uR41T9Ba96F2EhIPQuKhxIhfD9K59J8aS//eBLGdw/5OwlrC/mMXROGh
 aG/ArWLo
 wUPjGS1adMVImtp5JPrnOyoah++EbTY6PL66QzEF58h0/UfytW7mYqWPGd2OHfHl/qCQGFYpCHPMSsSrOmQW/cJDY1swwRtUBOvMpcDm44IO32dZRFXaoEOFGS4hiCJ8VUSZdQgwgkMMuKXIr/HCrjceIOjqpsaUE770ZB9eRJbt0Y5UXZ+S6TYOgj4w8DdTQXtkayC5311Hrx6wkeJ7L5l5vm4TaqFm+dKIaFBN6+lVF3CbQu1heE0UnOHsHgMaBGUxj2BFebsgn5N4/5p+ZrOydMB59HnGKs678U1BBkA1FQOfZQIZvv7HhkSkdZ+KqaQjvh/sp+gYAapZo0pPTL0AhTwiLvuDFWaPVqrDxDki4W7KK80LcyshcakxiMHWVVgWJD0n4kCj8ypXHye9nE4JxOhsl6BSSHE/NoyDwQjmqsC+MgS1LaNaC8LSgMEOcbbV5X6BKOWAi4ZcfnCzJCfMkVbUkzCtzbgq0aQYUelUAIIhlqd5oRPOKbQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Marek,

On Thu, 15 Oct 2026 at 10:29, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> Get rid of the static, limited-size reserved_mem array and replace it
> with array allocated by memblock_alloc_raw() and accessed directly or
> through a temporary early_memremap() mapping (depending on the
> architecture support). Such mapping is needed for some architectures
> (like ARM64), where linear map is not yet available during early boot
> scan. The array is allocated from the bottom of RAM to avoid placing it
> in highmem area, because some architectures (e.g. Xtensa, C-SKY, MIPS32)
> set the memblock limit to the end of lowmem only after the early scan.
> The early mapping is not used on PPC64, where the scan is done before
> early_ioremap_setup(), but the memory allocated by memblock is already
> accessible at that point.
>
> Having a single, writeable array with all reserved regions removes the
> need to perform two step initialization introduced by commit
> 8a6e02d0c00e ("of: reserved_mem: Restructure how the reserved memory
> regions are processed"), so all regions can be processed during the
> early scan again.
>
> The reserved_mem array is allocated only after all static (defined by
> the 'reg' property) regions are marked as reserved or no-map, so it
> cannot be placed in any of them. Errors of the early reservations are
> not recorded per region, only the fact that some of them failed is
> stored and a message asking to fix the device-tree is printed. The
> region specific init functions for the static regions are then called
> in a separate pass, once the array is available. Then all dynamically
> allocated reserved regions are processed.
>
> Suggested-by: Mike Rapoport <rppt@kernel.org>
> Link: https://lore.kernel.org/all/asc6brs_g0ky0wOM@kernel.org/
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

Thanks for your patch, which is now commit aa05faf815836c47 ("of:
reserved_mem: allocate and map the reserved_mem array early")
in dt-rh/for-next.

This causes an early crash on BeagleV Starlight Beta:

 [...]
 earlycon: uart0 MMIO32:0x0000000012440000 (options '115200n8')
 printk: legacy bootconsole [uart0] enabled
 printk: debug: skip boot console de-registration.
 efi: UEFI not found.
-OF: reserved mem: 0x00000000fb000000..0x00000000fcffffff (32768 KiB)
map non-reusable framebuffer@fb000000
-OF: reserved mem: 0x00000000f9000000..0x00000000f9ffffff (16384 KiB)
map non-reusable framebuffer@f9000000
-OF: reserved mem: 0x00000000d0000000..0x00000000f7ffffff (655360 KiB)
map non-reusable framebuffer@d0000000
-OF: reserved mem: 0x00000000c9000000..0x00000000ccffffff (65536 KiB)
map non-reusable framebuffer@c9000000
-OF: reserved mem: 0x00000000fa000000..0x00000000faffffff (16384 KiB)
nomap non-reusable dma-reserved@fa000000
-Reserved memory: created DMA memory pool at 0x000000107a000000, size 16384 KiB
-OF: reserved mem: initialized node linux,dma@107a000000, compatible
id shared-dma-pool
-OF: reserved mem: 0x000000107a000000..0x000000107affffff (16384 KiB)
nomap non-reusable linux,dma@107a000000
-SBI HSM extension detected
-[...]
+Oops - store (or AMO) access fault [#1]
+Modules linked in:
+CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted
7.4.0-rc1-starlight-00002-gaa05faf81583 #411 PREEMPT
+Hardware name: BeagleV Starlight Beta (DT)
+epc : __memset+0x68/0xfe
+ ra : fdt_scan_reserved_mem+0x3a4/0x80a
+epc : ffffffff8087fd88 ra : ffffffff80a313c8 sp : ffffffff81403c20
+ gp : ffffffff814dc6c0 tp : ffffffff8140cf80 t0 : ffffffc4fea38ff0
+ t1 : 0000000080200000 t2 : ffffffc4fec03008 s0 : ffffffff81403d10
+ s1 : ffffffffffffffff a0 : ffffffc4fea39000 a1 : 0000000000000000
+ a2 : 00000000000000f0 a3 : ffffffc4fea390f0 a4 : 0000000000000008
+ a5 : ffffffff8087fd88 a6 : 00000000000000f0 a7 : 0000000000001000
+ s2 : ffffffc4fec00000 s3 : 00000000000000f0 s4 : 0000000000000000
+ s5 : 0000000000002de0 s6 : 0000000000000006 s7 : fffffffffefefefe
+ s8 : ffffffc4fec02fd4 s9 : ffffffff8148e318 s10: fffffffffefefeff
+ s11: ffffffc4fea39000 t3 : ffffffff8150df00 t4 : ffffffff8150df00
+ t5 : ffffffff8150df00 t6 : ffffffff8150df78 ssp : 0000000000000000
+status: 0000000200000100 badaddr: ffffffc4fea39000 cause: 0000000000000007
+[<ffffffff8087fd88>] __memset+0x68/0xfe
+[<ffffffff80a2f63a>] early_init_fdt_scan_reserved_mem+0xa4/0x110
+[<ffffffff80a06c8e>] paging_init+0x17c/0x46a
+[<ffffffff80a046dc>] setup_arch+0xdc/0x584
+[<ffffffff80a009b8>] start_kernel+0x98/0x940
+Code: 0000 8793 00e7 8305 97ba 8782 b023 00b2 b423 00b2 (b823) 00b2
+---[ end trace 0000000000000000 ]---
+Kernel panic - not syncing: Fatal exception in interrupt
+---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---

Reverting the commit fixes the issue.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

