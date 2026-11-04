Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12AC0606A328
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 10:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=aVwRKbt/
Received: by kanga.kvack.org (Postfix)
	id E8BEF6B05B3; Wed,  4 Nov 2026 05:44:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3CEE6B05B4; Wed,  4 Nov 2026 05:44:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D790D6B05B5; Wed,  4 Nov 2026 05:44:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A70706B05B3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 05:44:44 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 241BAC0612
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 10:44:44 +0000 (UTC)
X-FDA: 85397103288.11.0644AF7
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf19.hostedemail.com (Postfix) with ESMTP id 92EDD1A000A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 10:44:41 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b="aVwRKbt/";
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf19.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793789082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QCti1+cjG3WmeJe83h4JqyxWGyupjY6tSFq+NOeohc4=;
	b=6zdGXNBvVLp8z3/aKohFtfS8Qx+78u5CsoCmz9RlBKADRtQ9XhaAkGqSO+58tlG5Kh7Ag6
	J+pMqjL4YncwDBN9lz7AS3ZYtDc9mva+XZW9lOoNMRMoRRQxNPod5OPqUVJIzhMS+VZ3iG
	vio707NSQfZuhLDeQcbhj9N5Nn923Ks=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793789082;
	b=wNi5DT0t0sUxxgKA0k6ZcAD/mf9vdpRL1CF2ZrRyhZDp5TdWdRorH7vCFYSCyXi1OHFPig
	AOmdlEkhzicRKY6RTrqak8Gwdw7tAbWCsZ3/vZChNCJGdcfNdlz6iPZQhfxIEq9bra+q/D
	xQzBSgmbxv4PAQCOYENmwISBkl9DX/Q=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b="aVwRKbt/";
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf19.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20261104104439euoutp017130ee968873cb9bcb527f3d78a405a8~k0anbrmsz2541425414euoutp01q
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 10:44:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20261104104439euoutp017130ee968873cb9bcb527f3d78a405a8~k0anbrmsz2541425414euoutp01q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793789079;
	bh=QCti1+cjG3WmeJe83h4JqyxWGyupjY6tSFq+NOeohc4=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=aVwRKbt/eCuT/LLi+iS2q2MvTjPe8+YgOc5ZiYaPi5lajxwrALZ6sLsgnNobEEc++
	 45fJxHdrSWbpDIfoAOppkPHqPK9OX5RhrPSo2To2U72qfabgmLUhzzuJukiuSxo4ah
	 p2v6a4XYQc+oJlIi0Am/8en6Qm+8DVdu3JVbZjN4=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20261104104438eucas1p1d6a04d93c57861bfd221971b6df5ce0b~k0anNqHe-0214602146eucas1p1Q;
	Wed,  4 Nov 2026 10:44:38 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261104104437eusmtip1b1ace1fd24a647c7c83a0ed6c768be5b~k0amZBb451927419274eusmtip1F;
	Wed,  4 Nov 2026 10:44:37 +0000 (GMT)
Message-ID: <29cfb3a7-81c2-4c52-913b-cf72e19ff0d8@samsung.com>
Date: Wed, 4 Nov 2026 11:44:37 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v3 2/2] of: reserved_mem: allocate and map the
 reserved_mem array early
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-mm@kvack.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>, Rob Herring
	<robh@kernel.org>, Saravana Kannan <saravanak@kernel.org>, Oreoluwa
	Babatunde <oreoluwa.babatunde@oss.qualcomm.com>, Wandun
	<chenwandun1@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <CAMuHMdV2ET0Y_=m3LHmL12VNhqK7tBKod0kph6GdZ7Q8XXhP8A@mail.gmail.com>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20261104104438eucas1p1d6a04d93c57861bfd221971b6df5ce0b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20261015082334eucas1p2a3bbf3650f279abbd39d05d63e35aba6
X-EPHeader: CA
X-CMS-RootMailID: 20261015082334eucas1p2a3bbf3650f279abbd39d05d63e35aba6
References: <CGME20261015082334eucas1p2a3bbf3650f279abbd39d05d63e35aba6@eucas1p2.samsung.com>
	<20261015082315.56876-1-m.szyprowski@samsung.com>
	<20261015082315.56876-3-m.szyprowski@samsung.com>
	<CAMuHMdXcM9yvwLBSi-aYRinG3omhu5aoeNVYynfFQsnDDWR-Hw@mail.gmail.com>
	<b71ac175-fba5-4f61-bbdb-0b98dec9ccee@samsung.com>
	<CAMuHMdV2ET0Y_=m3LHmL12VNhqK7tBKod0kph6GdZ7Q8XXhP8A@mail.gmail.com>
X-Stat-Signature: ozpzzpq1mam13366jnscjqke4y6rr31m
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 92EDD1A000A
X-HE-Tag: 1793789081-54906
X-HE-Meta: U2FsdGVkX18XAnQTRY9Q/KExoAaYLl4vQp2V/+rsWqNQxK/1HOsPrgh5vWeK8qpC7wWYGDt1DVwvCTCBV8YmVaH3CxB1S3dgsodPYC+V1cDjj9JPVrZm8wVVXBdox+JEitIEeEHbR0rIm21HkzWuAm+jjGXu/PUfOJBgBx8Gr2SeS7YYCwQf4lRt3PmjXrPok7LDGo2WInbjBHgEZmqhBiu3s3qEpCnq+FwNa0G2xR6rkkWUIWMy1vaYxpdTXnhhN7owOoCJKg/uwnfTUzj5JLyKgya5mMH6d7nLJTAgKDn40NR3BTGZTjQfazxqOYJOCmPcDb3wQCGNQ1gtUTxDzqxbwM7zJEE3ALqcYQ96A0G9qqeqGOlRqeB6+sGPbVdNilDommqW2cRaK09+ZxZHdqcbx+Ar429sWc6jWSBQVJoQNX/j588WM3QXGq4DGN8Sbg2QbD2/K5fACdDsPe5di+O6tHguNpl2+akrGowi44WQRkUCq1mtHrwkshyqWGiId5kNox552+cv5Lj3fMY5rOvjnhXnejhItUzm3aFs5cZ5/BtD/ZLGcdiLLj7GQhVMPQ3AOsmm3VyXxFYYOiUE64T5E440N5Mlkl+3HoHyPo6Pl7U0JRLALKBKPJjoC5tr2RY256w6ol6tAzQ7Ys6Rti8tKstvMFvlBdq4g7UYQHmcyQd8pAyQAoQlm/djC8dIifAryl2T/9k95UOGytcvZAanDBPprNpuMZ5DOCVTh44lN+Nadlh7gURwTBY2GPKQtCsSac9Pa3/g0o8Ee+i8ujfMkAloSQDPUXmzVdH24OAFAIpp3kAlkxEimDj2LlsLM7eNRElHNycMANScoOdUajVaKX9qh/ymC+4uRwBn0LfyWIpNnsPTNN983wRmzTScicg15HYGNVDoH+H3pcY+MFEw0q/beDFOrm2FM+EL6p5PuMPTEmhOmWTVYoKNR8O42B4dKv2p/0GccdymrEO
 +XO+ShjW
 2LI2LSGfVY/34aqDiuEHEr5JSdu6A4vc4i8vgosYt5Xt+79qK61ERsIpr6QfgNIvbNF3IiibBjchS5iHWCgH1aETjNDMQwjdRYkR0B7PaXijV4IE5H6L26mkfyYteRMJUptQuWLMhdDU1vnyrVZqJNusuJm4EfFoanNbK7EMMkJpIKjLG8fxnGWV2/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 04.11.2026 09:19, Geert Uytterhoeven wrote:
> On Tue, 3 Nov 2026 at 20:25, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
>> On 03.11.2026 19:04, Geert Uytterhoeven wrote:
>>> On Thu, 15 Oct 2026 at 10:29, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
>>>> Get rid of the static, limited-size reserved_mem array and replace it
>>>> with array allocated by memblock_alloc_raw() and accessed directly or
>>>> through a temporary early_memremap() mapping (depending on the
>>>> architecture support). Such mapping is needed for some architectures
>>>> (like ARM64), where linear map is not yet available during early boot
>>>> scan. The array is allocated from the bottom of RAM to avoid placing it
>>>> in highmem area, because some architectures (e.g. Xtensa, C-SKY, MIPS32)
>>>> set the memblock limit to the end of lowmem only after the early scan.
>>>> The early mapping is not used on PPC64, where the scan is done before
>>>> early_ioremap_setup(), but the memory allocated by memblock is already
>>>> accessible at that point.
>>>>
>>>> Having a single, writeable array with all reserved regions removes the
>>>> need to perform two step initialization introduced by commit
>>>> 8a6e02d0c00e ("of: reserved_mem: Restructure how the reserved memory
>>>> regions are processed"), so all regions can be processed during the
>>>> early scan again.
>>>>
>>>> The reserved_mem array is allocated only after all static (defined by
>>>> the 'reg' property) regions are marked as reserved or no-map, so it
>>>> cannot be placed in any of them. Errors of the early reservations are
>>>> not recorded per region, only the fact that some of them failed is
>>>> stored and a message asking to fix the device-tree is printed. The
>>>> region specific init functions for the static regions are then called
>>>> in a separate pass, once the array is available. Then all dynamically
>>>> allocated reserved regions are processed.
>>>>
>>>> Suggested-by: Mike Rapoport <rppt@kernel.org>
>>>> Link: https://lore.kernel.org/all/asc6brs_g0ky0wOM@kernel.org/
>>>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>>> Thanks for your patch, which is now commit aa05faf815836c47 ("of:
>>> reserved_mem: allocate and map the reserved_mem array early")
>>> in dt-rh/for-next.
>>>
>>> This causes an early crash on BeagleV Starlight Beta:
>>>
>>>  [...]
>>>  earlycon: uart0 MMIO32:0x0000000012440000 (options '115200n8')
>>>  printk: legacy bootconsole [uart0] enabled
>>>  printk: debug: skip boot console de-registration.
>>>  efi: UEFI not found.
>>> -OF: reserved mem: 0x00000000fb000000..0x00000000fcffffff (32768 KiB)
>>> map non-reusable framebuffer@fb000000
>>> -OF: reserved mem: 0x00000000f9000000..0x00000000f9ffffff (16384 KiB)
>>> map non-reusable framebuffer@f9000000
>>> -OF: reserved mem: 0x00000000d0000000..0x00000000f7ffffff (655360 KiB)
>>> map non-reusable framebuffer@d0000000
>>> -OF: reserved mem: 0x00000000c9000000..0x00000000ccffffff (65536 KiB)
>>> map non-reusable framebuffer@c9000000
>>> -OF: reserved mem: 0x00000000fa000000..0x00000000faffffff (16384 KiB)
>>> nomap non-reusable dma-reserved@fa000000
>>> -Reserved memory: created DMA memory pool at 0x000000107a000000, size 16384 KiB
>>> -OF: reserved mem: initialized node linux,dma@107a000000, compatible
>>> id shared-dma-pool
>>> -OF: reserved mem: 0x000000107a000000..0x000000107affffff (16384 KiB)
>>> nomap non-reusable linux,dma@107a000000
>>> -SBI HSM extension detected
>>> -[...]
>>> +Oops - store (or AMO) access fault [#1]
>>> +Modules linked in:
>>> +CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted
>>> 7.4.0-rc1-starlight-00002-gaa05faf81583 #411 PREEMPT
>>> +Hardware name: BeagleV Starlight Beta (DT)
>>> +epc : __memset+0x68/0xfe
>>> + ra : fdt_scan_reserved_mem+0x3a4/0x80a
>>> +epc : ffffffff8087fd88 ra : ffffffff80a313c8 sp : ffffffff81403c20
>>> + gp : ffffffff814dc6c0 tp : ffffffff8140cf80 t0 : ffffffc4fea38ff0
>>> + t1 : 0000000080200000 t2 : ffffffc4fec03008 s0 : ffffffff81403d10
>>> + s1 : ffffffffffffffff a0 : ffffffc4fea39000 a1 : 0000000000000000
>>> + a2 : 00000000000000f0 a3 : ffffffc4fea390f0 a4 : 0000000000000008
>>> + a5 : ffffffff8087fd88 a6 : 00000000000000f0 a7 : 0000000000001000
>>> + s2 : ffffffc4fec00000 s3 : 00000000000000f0 s4 : 0000000000000000
>>> + s5 : 0000000000002de0 s6 : 0000000000000006 s7 : fffffffffefefefe
>>> + s8 : ffffffc4fec02fd4 s9 : ffffffff8148e318 s10: fffffffffefefeff
>>> + s11: ffffffc4fea39000 t3 : ffffffff8150df00 t4 : ffffffff8150df00
>>> + t5 : ffffffff8150df00 t6 : ffffffff8150df78 ssp : 0000000000000000
>>> +status: 0000000200000100 badaddr: ffffffc4fea39000 cause: 0000000000000007
>>> +[<ffffffff8087fd88>] __memset+0x68/0xfe
>>> +[<ffffffff80a2f63a>] early_init_fdt_scan_reserved_mem+0xa4/0x110
>>> +[<ffffffff80a06c8e>] paging_init+0x17c/0x46a
>>> +[<ffffffff80a046dc>] setup_arch+0xdc/0x584
>>> +[<ffffffff80a009b8>] start_kernel+0x98/0x940
>>> +Code: 0000 8793 00e7 8305 97ba 8782 b023 00b2 b423 00b2 (b823) 00b2
>>> +---[ end trace 0000000000000000 ]---
>>> +Kernel panic - not syncing: Fatal exception in interrupt
>>> +---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---
>>>
>>> Reverting the commit fixes the issue.
>> Does moving early_init_fdt_scan_reserved_mem() to the end of setup_bootmem()
>> in arch/riscv/mm/init.c change anything?
> Unfortunately that doesn't make a difference.

Well, that's still a potential issue, so I will send a separate fix for that.


>> Could You provide a full boot log from the working kernel and /proc/iomem dump?
> Sent by personal email.
> The relevant part of /proc/iomem is:
>
>     80000000-cfffffff : System RAM
>       80200000-80201fff : Reserved
>       80202000-81730bf7 : Kernel image
>         80202000-80aa7e73 : Kernel code
>         81000000-813fffff : Kernel rodata
>         81600000-816dd9ff : Kernel data
>         816de000-81730bf7 : Kernel bss
>       81730bf8-817fffff : Reserved
>       88000000-88007fff : Reserved
>       9c000000-c7ffffff : Reserved
>       c9000000-ccffffff : Reserved
>     d0000000-f7ffffff : Reserved
>     f8000000-f8ffffff : System RAM
>     f9000000-fcffffff : Reserved
>     fd000000-27fffffff : System RAM
>       2772e1000-2773a0fff : Reserved
>       2773a1000-277fa1fff : Reserved
>       277fa2000-277fcbfff : Reserved
>       277fce000-277fcefff : Reserved
>       277fcf000-27ffcffff : Reserved
>       27ffd0000-27fff6fff : Reserved
>       27fff7000-27fffffff : Reserved


This turned out to be a bootloader issue on this board. The protected opensbi
memory region was placed before kernel and not properly described in dt.
Kernel treated it as a normal memory resulting in the above crash. Confirmed
by Geert in private discussion.


Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


