Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3553CCA470
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 06:59:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C6768E0008; Fri,  3 Oct 2025 02:59:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39DF58E0001; Fri,  3 Oct 2025 02:59:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B3D38E0008; Fri,  3 Oct 2025 02:59:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0F8788E0001
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 02:59:45 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8BBF687D11
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 06:59:44 +0000 (UTC)
X-FDA: 83955902688.18.0A72D2A
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf18.hostedemail.com (Postfix) with ESMTP id 05EF01C0006
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 06:59:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=rNU5cVhm;
	spf=pass (imf18.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759474782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WB9sbfpLecnMxMoiDerCoUS7521vhN66oFyAsMbTO/0=;
	b=WRvvL/28k2qkXqia+kyegV/P6FYi3Zr0KAcCs6818hsu388etkoMa+A+IGqdVuNoWWcsYl
	wB/0Nym+dNXhY7tmOit/lEIb0kIDLakhlYLOe2+0JQv4W1FXiIq77gfBSYBHNjvYrsUb7Y
	FaWCwX8L0TYHtOUA7rAIGSpQyrTABAE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=rNU5cVhm;
	spf=pass (imf18.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759474782; a=rsa-sha256;
	cv=none;
	b=7IUxrTX9T3exgvJTULohakJkfe408GBBnRtvMIdrwm4mXuDZb6KXAJ36k5H4WAFiMqLlA3
	KTT73uH66UMyCD+B2CX/YlM13ZrWOM8FF7I6F56eKkI243m81BfxfumuX/p2XVkT98+thn
	uvLg8AweCYnrhwlV1OUOJhq96vuALS0=
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20251003065939euoutp019f0ba12198a3099f25d5073ce32fdebf~q6P1pItK00562605626euoutp01Z
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 06:59:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20251003065939euoutp019f0ba12198a3099f25d5073ce32fdebf~q6P1pItK00562605626euoutp01Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1759474779;
	bh=WB9sbfpLecnMxMoiDerCoUS7521vhN66oFyAsMbTO/0=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=rNU5cVhmOZDMaP/OVCGCAd+ZxwmVqRRGG57bXmlVB/vN1it679D39JUs4rj/uD8O9
	 LGrFX2hKQxMK57173qZPyqhKP8sw40gFWvNADtmbVOOJhgVSnzve3te5S9Q11LX87K
	 Rz18lpX5u3vdLqOFqzdKcwE0nJDGMax+tDSmMxBI=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20251003065939eucas1p2a570a631290b2053af4bfee78ca93977~q6P1Z1Cy11393413934eucas1p25;
	Fri,  3 Oct 2025 06:59:39 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20251003065937eusmtip1440172238527b922b950b45020a53526~q6P0IH4u62724027240eusmtip1D;
	Fri,  3 Oct 2025 06:59:37 +0000 (GMT)
Message-ID: <c921d3d4-3f15-4b46-bd6c-2f48b2747e60@samsung.com>
Date: Fri, 3 Oct 2025 08:59:37 +0200
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH] kmsan: fix kmsan_handle_dma() to avoid false positives
To: Shigeru Yoshida <syoshida@redhat.com>, glider@google.com,
	elver@google.com, dvyukov@google.com, akpm@linux-foundation.org,
	jgg@ziepe.ca, leon@kernel.org
Cc: kasan-dev@googlegroups.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20251002051024.3096061-1-syoshida@redhat.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20251003065939eucas1p2a570a631290b2053af4bfee78ca93977
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20251002051101eucas1p250c65f775d8e64053ee7e009142c89c7
X-EPHeader: CA
X-CMS-RootMailID: 20251002051101eucas1p250c65f775d8e64053ee7e009142c89c7
References: <CGME20251002051101eucas1p250c65f775d8e64053ee7e009142c89c7@eucas1p2.samsung.com>
	<20251002051024.3096061-1-syoshida@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 05EF01C0006
X-Stat-Signature: k68fu77qd9g5898t3acwn6i4pe8s6nwj
X-HE-Tag: 1759474781-722749
X-HE-Meta: U2FsdGVkX19qLHskH98sIBJpt4Ckdxtd18lkFCrKzPDVj/prZ7VilCXMIhkMIl6P7RPukMAzZJAW8WQtq9tOlCGIpvBX8KpZpOZHxt6I2s3u8a8vg1JUV0aj7m9Za+8ACrc3+FHs0+2+RdGbflbf7RUXYB+ijuf4D6vGT4OjHxQDQumcEqFvSt+mKQ2bOtJGotnE5uyhCFrPIBIbNsymed+B8vN40F1g2bfaBr9xvcYncurJ6FZMdRJEimjVuXM4oPbv1FCIOtBoPLf+MTswJzEUyIdSsh19wJ12V4wZWGXw3dhnNLNxJ8P9L2L/xPm7BzSKGyUoXEBcra5U73LWeD2T4TarYWdC+GxXLz0bJFumfkHHg0yTwnf7ipBFXba3+uhzffIK8w1fXxIxDj9rlmbtjcMV/ywpMBmyNSo68KUraZJABL4kJtqi0Vbhi1IpOYGZk9QKMSYSyy8x5d4HOo7bXt5Tw0/5B2yuCPcMiF/4nEKmHf/CxRGpP6WpZqHhq2kLOIi4n7jzr92P0i91Dgvehu0j4njbSSW53okXFqRfjrC35iQY1x5OI/nATClIpjH76d0AC9t1zpWpCxkI8dobkf49wIeXWmvFWltFZ3rT3PlRxWuwUw7Vf38qepyT+t8L80NrXLOrV591cZNP8Kdye8WpEI1r3qdk1deyP8+zZ/aPCZBSWX6NprbeGyhGPHYQevxc+kacoV2VDpeqCAQu8lYJnuQ+kzFF6Ka28gQfHv8Jhcy8C6/sUPVzcfGMvhoRbTWWoEVbRvwMCfjhNXKr2v6L/8RfhNAseiIfvtpP8QIzvd1UoPTs1TrfzErac5JRfnORh6CgbhDTvPnr3iKfPUWBk9qTP1dgN0fJUldMdqWAJvCTpxeYDmuxO6VeCp3iPqujP5V4s4FsoBMnIytiO0Qm5isutc5fBCmLq9LrBv3a21zeaGcMb5YwPDhpGt0UtdMsRKxtb9ksAW4
 8qL6m/b/
 CtYp1Lz4Ye4Tk0C/FmqJgaMPhfxsFZOreZIkUsUuaJaKnwwUkNefk5CX3r9o3NkG7jDG1zQMfUjv6nYk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02.10.2025 07:10, Shigeru Yoshida wrote:
> KMSAN reports an uninitialized value issue in dma_map_phys()[1].  This
> is a false positive caused by the way the virtual address is handled
> in kmsan_handle_dma().  Fix it by translating the physical address to
> a virtual address using phys_to_virt().
>
> [1]
> BUG: KMSAN: uninit-value in dma_map_phys+0xdc5/0x1060
>   dma_map_phys+0xdc5/0x1060
>   dma_map_page_attrs+0xcf/0x130
>   e1000_xmit_frame+0x3c51/0x78f0
>   dev_hard_start_xmit+0x22f/0xa30
>   sch_direct_xmit+0x3b2/0xcf0
>   __dev_queue_xmit+0x3588/0x5e60
>   neigh_resolve_output+0x9c5/0xaf0
>   ip6_finish_output2+0x24e0/0x2d30
>   ip6_finish_output+0x903/0x10d0
>   ip6_output+0x331/0x600
>   mld_sendpack+0xb4a/0x1770
>   mld_ifc_work+0x1328/0x19b0
>   process_scheduled_works+0xb91/0x1d80
>   worker_thread+0xedf/0x1590
>   kthread+0xd5c/0xf00
>   ret_from_fork+0x1f5/0x4c0
>   ret_from_fork_asm+0x1a/0x30
>
> Uninit was created at:
>   __kmalloc_cache_noprof+0x8f5/0x16b0
>   syslog_print+0x9a/0xef0
>   do_syslog+0x849/0xfe0
>   __x64_sys_syslog+0x97/0x100
>   x64_sys_call+0x3cf8/0x3e30
>   do_syscall_64+0xd9/0xfa0
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Bytes 0-89 of 90 are uninitialized
> Memory access of size 90 starts at ffff8880367ed000
>
> CPU: 1 UID: 0 PID: 1552 Comm: kworker/1:2 Not tainted 6.17.0-next-20250929 #26 PREEMPT(none)
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-5.fc42 04/01/2014
> Workqueue: mld mld_ifc_work
>
> Fixes: 6eb1e769b2c1 ("kmsan: convert kmsan_handle_dma to use physical addresses")
> Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>

Applied to dma-mapping-for-next (for v6.18-rc1) branch. Thanks!

> ---
> The hash in the "Fixes" tag comes from the linux-next tree
> (next-20250929), as it has not yet been included in the mainline tree.
> ---
>   mm/kmsan/hooks.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/mm/kmsan/hooks.c b/mm/kmsan/hooks.c
> index 90bee565b9bc..2cee59d89c80 100644
> --- a/mm/kmsan/hooks.c
> +++ b/mm/kmsan/hooks.c
> @@ -339,13 +339,12 @@ static void kmsan_handle_dma_page(const void *addr, size_t size,
>   void kmsan_handle_dma(phys_addr_t phys, size_t size,
>   		      enum dma_data_direction dir)
>   {
> -	struct page *page = phys_to_page(phys);
>   	u64 page_offset, to_go;
>   	void *addr;
>   
>   	if (PhysHighMem(phys))
>   		return;
> -	addr = page_to_virt(page);
> +	addr = phys_to_virt(phys);
>   	/*
>   	 * The kernel may occasionally give us adjacent DMA pages not belonging
>   	 * to the same allocation. Process them separately to avoid triggering

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


