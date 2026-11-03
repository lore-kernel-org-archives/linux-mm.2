Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65339606A324
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 19:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=sH5lu8/r
Received: by kanga.kvack.org (Postfix)
	id 4915F6B00EF; Tue,  3 Nov 2026 14:25:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 440C56B05B1; Tue,  3 Nov 2026 14:25:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 357B46B05B2; Tue,  3 Nov 2026 14:25:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0BD0E6B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:25:16 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 04F334053F
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:25:14 +0000 (UTC)
X-FDA: 85394786190.01.8427749
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3AF5E40004
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:25:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b="sH5lu8/r";
	spf=pass (imf04.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793733913;
	b=zXhs7sZe43niaES8s77sC26TxIIRzzLZkMqQLqPVFwoDGzyG7hKXGreaE6Hw97FCO01M9u
	L3JGsZJ4QFn3ACzQcGOEKVrqLI3CBEnJBPAOSraA5ZxWj6onj0YV9IVAFevqxp8HnM8w2/
	N+ddEGb07yZM+EE5wN2sqAg1RyEuplM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793733913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7PUwfrJVawcXLdfu41PY6uZ3y3+L4mK5joYpI+grGjw=;
	b=G0knZK8zUoTwfCYaKs6jUwNrUmCrgLwkFPTWu+yv01NjxNc6EKurdAbRIlGhqD+w95JEro
	Pbjf9phX33esbvl3UmiWG7+AeKtDQ8fIgsLdfBV7kzLe/yaNOiUa6sPXaBlcLrAYoDYSo2
	WdB1TxmWgl600JMd9XXs54YT0+fqVBk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b="sH5lu8/r";
	spf=pass (imf04.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20261103192509euoutp02d9e2adc354294152297538b93ddd31d0~kn3zLGMlh1817618176euoutp02H
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:25:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20261103192509euoutp02d9e2adc354294152297538b93ddd31d0~kn3zLGMlh1817618176euoutp02H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793733909;
	bh=7PUwfrJVawcXLdfu41PY6uZ3y3+L4mK5joYpI+grGjw=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=sH5lu8/rUJ8kh2OpQ2XUWcNXRPmyVlAwJrTiki7UFFRAW19QzkE8kJQ5P9ivn25ZR
	 WwtUo/9bgQaOqPLOFvqDg0YWqANrS5NOTe0FQ+upG+8uxIllUitHQD3/w5F4tOmLDb
	 yprHd+9El9lRX6kb2sY1MN6hCsPd8SQgEFQE7dx8=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20261103192509eucas1p1b2f9e4fdd60dc8eae89579a1440a30f6~kn3yjR5OT3099830998eucas1p1_;
	Tue,  3 Nov 2026 19:25:09 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20261103192508eusmtip2a833c7ccdaf7e75a797dd7005f03374d~kn3yAQfdV2937629376eusmtip29;
	Tue,  3 Nov 2026 19:25:08 +0000 (GMT)
Message-ID: <b71ac175-fba5-4f61-bbdb-0b98dec9ccee@samsung.com>
Date: Tue, 3 Nov 2026 20:25:08 +0100
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
In-Reply-To: <CAMuHMdXcM9yvwLBSi-aYRinG3omhu5aoeNVYynfFQsnDDWR-Hw@mail.gmail.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20261103192509eucas1p1b2f9e4fdd60dc8eae89579a1440a30f6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20261015082334eucas1p2a3bbf3650f279abbd39d05d63e35aba6
X-EPHeader: CA
X-CMS-RootMailID: 20261015082334eucas1p2a3bbf3650f279abbd39d05d63e35aba6
References: <CGME20261015082334eucas1p2a3bbf3650f279abbd39d05d63e35aba6@eucas1p2.samsung.com>
	<20261015082315.56876-1-m.szyprowski@samsung.com>
	<20261015082315.56876-3-m.szyprowski@samsung.com>
	<CAMuHMdXcM9yvwLBSi-aYRinG3omhu5aoeNVYynfFQsnDDWR-Hw@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Stat-Signature: pf4mjuwkn6rkxnsmprdp98ru41xktykg
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 3AF5E40004
X-HE-Tag: 1793733912-63792
X-HE-Meta: U2FsdGVkX1/sBnJsMpCUHcKllN8FMC38g+a+76iV25JzidcFzdh1D8uyYgxv2/vDMS+DVMejwK9P3nZkAWJdMHiZVgmY60fCD0tXvkM9mQ7PwmhwRnUVVQvdf5vyT+gsr27HAN2REUKFjZvI4EjVIH/G188eBCAa7WTif35seZJw2FI+Vzoh+yDH4rbLXUemwiESlQuAu7XWRfNCm1srvW1bPNVRVE7b2CBtQpoK5ytzLTOIskudV/oP6LmfLK18NMu7+T9mUjx90fBlaZNxDmx0sB9ZMdZH4dAvSYSD+UpLht6cdYG9PBvj4ZmPeOeIDZkIecFp8Gy9oEThQT/8p8CdFnHuHDlyxvFVdjY9P3JZtU3H/WdnDxxwILzVlHUqanm3TJja+DFVtCSTc9N/2aVG6htWmVTxY5iWIzAjjR+bFyVaJpkY8ealhB7O0h2zCXG8mf67+Hbffh8pp+Oc+LIvHz7g6OAJr7cn2YFwXeQJ3OiWZrdgcz3NJCfmAHniJWMC/jSIsYEyLXiJlwz5HVbY3lNfNrSBUI4E1KbpYFGWmkKjtJ/AZES+eZbGHG+nF70zGuNxNevDQT+mzCEjENH6gs40clVE7lpqzsBbWvVk+gLqgb307FoxQOIpK+2dcMgD+Jok1o5RKPlkgWQW6cgPT8y+jGn6qqIUcKrVNL47l3e6VqGobwLIg1copfjIduX9w872M5HLyd9uAwIB78QIi6c1KN+9v6m/LtviAobf6+lZSuZiLAgliJbKkWwXOS6Fkb4++45oEZ3DOYJcES05Lda9j1fBcWUeiNucZVjj+PDgORwOxYWRcgYFDnJJ36hJIjH3BO2frROgYZFhoBaHCsnJkInqguXo50aOBRZl4K5u3PdMUk5qkJaVgzrzxOjjQoMyesDBYowIPW5xShzHBtasLgUbMRBBzc+eIyLNVUTM6Ie1hRms71F8HujuKLga3OIACECv+B42JGj
 mbEX/Iez
 Vr/hJNfhz0WeWkypbzcB3ZJbHQCai2ysGHaA6DYf6rrMohuUa6L5poCvrGUwkIcIa8BtsvwYsDiV74XUFC8QO+yiBAk/C6dsAxfKSNM7BFlSLVkNdwfdHL6RLkNMgTBWBItuBApALW7PpSEx4U9p+ovtaXi7NF0BuwdKMKMblj6WbBcDfUBfWbQfhbTf7qcKxFy3vvgQ0/I7hX8hA6e68In1Rwihs7LjFY9wL9ONnXYgXTVQwIw0NVmZrbmT8vTw17ny42G3Z8U6LkLI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Geert,

On 03.11.2026 19:04, Geert Uytterhoeven wrote:
> On Thu, 15 Oct 2026 at 10:29, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
>> Get rid of the static, limited-size reserved_mem array and replace it
>> with array allocated by memblock_alloc_raw() and accessed directly or
>> through a temporary early_memremap() mapping (depending on the
>> architecture support). Such mapping is needed for some architectures
>> (like ARM64), where linear map is not yet available during early boot
>> scan. The array is allocated from the bottom of RAM to avoid placing it
>> in highmem area, because some architectures (e.g. Xtensa, C-SKY, MIPS32)
>> set the memblock limit to the end of lowmem only after the early scan.
>> The early mapping is not used on PPC64, where the scan is done before
>> early_ioremap_setup(), but the memory allocated by memblock is already
>> accessible at that point.
>>
>> Having a single, writeable array with all reserved regions removes the
>> need to perform two step initialization introduced by commit
>> 8a6e02d0c00e ("of: reserved_mem: Restructure how the reserved memory
>> regions are processed"), so all regions can be processed during the
>> early scan again.
>>
>> The reserved_mem array is allocated only after all static (defined by
>> the 'reg' property) regions are marked as reserved or no-map, so it
>> cannot be placed in any of them. Errors of the early reservations are
>> not recorded per region, only the fact that some of them failed is
>> stored and a message asking to fix the device-tree is printed. The
>> region specific init functions for the static regions are then called
>> in a separate pass, once the array is available. Then all dynamically
>> allocated reserved regions are processed.
>>
>> Suggested-by: Mike Rapoport <rppt@kernel.org>
>> Link: https://lore.kernel.org/all/asc6brs_g0ky0wOM@kernel.org/
>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Thanks for your patch, which is now commit aa05faf815836c47 ("of:
> reserved_mem: allocate and map the reserved_mem array early")
> in dt-rh/for-next.
>
> This causes an early crash on BeagleV Starlight Beta:
>
>  [...]
>  earlycon: uart0 MMIO32:0x0000000012440000 (options '115200n8')
>  printk: legacy bootconsole [uart0] enabled
>  printk: debug: skip boot console de-registration.
>  efi: UEFI not found.
> -OF: reserved mem: 0x00000000fb000000..0x00000000fcffffff (32768 KiB)
> map non-reusable framebuffer@fb000000
> -OF: reserved mem: 0x00000000f9000000..0x00000000f9ffffff (16384 KiB)
> map non-reusable framebuffer@f9000000
> -OF: reserved mem: 0x00000000d0000000..0x00000000f7ffffff (655360 KiB)
> map non-reusable framebuffer@d0000000
> -OF: reserved mem: 0x00000000c9000000..0x00000000ccffffff (65536 KiB)
> map non-reusable framebuffer@c9000000
> -OF: reserved mem: 0x00000000fa000000..0x00000000faffffff (16384 KiB)
> nomap non-reusable dma-reserved@fa000000
> -Reserved memory: created DMA memory pool at 0x000000107a000000, size 16384 KiB
> -OF: reserved mem: initialized node linux,dma@107a000000, compatible
> id shared-dma-pool
> -OF: reserved mem: 0x000000107a000000..0x000000107affffff (16384 KiB)
> nomap non-reusable linux,dma@107a000000
> -SBI HSM extension detected
> -[...]
> +Oops - store (or AMO) access fault [#1]
> +Modules linked in:
> +CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted
> 7.4.0-rc1-starlight-00002-gaa05faf81583 #411 PREEMPT
> +Hardware name: BeagleV Starlight Beta (DT)
> +epc : __memset+0x68/0xfe
> + ra : fdt_scan_reserved_mem+0x3a4/0x80a
> +epc : ffffffff8087fd88 ra : ffffffff80a313c8 sp : ffffffff81403c20
> + gp : ffffffff814dc6c0 tp : ffffffff8140cf80 t0 : ffffffc4fea38ff0
> + t1 : 0000000080200000 t2 : ffffffc4fec03008 s0 : ffffffff81403d10
> + s1 : ffffffffffffffff a0 : ffffffc4fea39000 a1 : 0000000000000000
> + a2 : 00000000000000f0 a3 : ffffffc4fea390f0 a4 : 0000000000000008
> + a5 : ffffffff8087fd88 a6 : 00000000000000f0 a7 : 0000000000001000
> + s2 : ffffffc4fec00000 s3 : 00000000000000f0 s4 : 0000000000000000
> + s5 : 0000000000002de0 s6 : 0000000000000006 s7 : fffffffffefefefe
> + s8 : ffffffc4fec02fd4 s9 : ffffffff8148e318 s10: fffffffffefefeff
> + s11: ffffffc4fea39000 t3 : ffffffff8150df00 t4 : ffffffff8150df00
> + t5 : ffffffff8150df00 t6 : ffffffff8150df78 ssp : 0000000000000000
> +status: 0000000200000100 badaddr: ffffffc4fea39000 cause: 0000000000000007
> +[<ffffffff8087fd88>] __memset+0x68/0xfe
> +[<ffffffff80a2f63a>] early_init_fdt_scan_reserved_mem+0xa4/0x110
> +[<ffffffff80a06c8e>] paging_init+0x17c/0x46a
> +[<ffffffff80a046dc>] setup_arch+0xdc/0x584
> +[<ffffffff80a009b8>] start_kernel+0x98/0x940
> +Code: 0000 8793 00e7 8305 97ba 8782 b023 00b2 b423 00b2 (b823) 00b2
> +---[ end trace 0000000000000000 ]---
> +Kernel panic - not syncing: Fatal exception in interrupt
> +---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---
>
> Reverting the commit fixes the issue.

Does moving early_init_fdt_scan_reserved_mem() to the end of setup_bootmem()
in arch/riscv/mm/init.c change anything?

Could You provide a full boot log from the working kernel and /proc/iomem dump?


Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


