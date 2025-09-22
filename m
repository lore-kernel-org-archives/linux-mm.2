Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2F8DCAC5A7
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 08:41:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EA018E000C; Mon, 22 Sep 2025 04:41:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29A708E0001; Mon, 22 Sep 2025 04:41:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D7CD8E000C; Mon, 22 Sep 2025 04:41:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 016538E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 04:41:25 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B6F2DC0556
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 08:41:25 +0000 (UTC)
X-FDA: 83916242130.24.A70622D
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf01.hostedemail.com (Postfix) with ESMTP id CC6CD40003
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 08:41:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=nCUHaBhP;
	spf=pass (imf01.hostedemail.com: domain of usama.anjum@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758530484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hTVUYr2bAjNqw8bMTaw6icRSRw6Z7VhEHT7GRBQatU8=;
	b=A06RE0sB65Bn7RwvdhmSH5ltkhGxULyw+ZOCqEQ2AdDrex8YroB0qKccQyLp6MsKSakMlv
	pzaC9FG90KJmDnc20Ss3yJZLSF3zTiUyMvAYGEDmBhbgxscTiU82tSDGyh66PrU/s64ugq
	5GpdJL00fXX/EsfF+lJXDtquCswAE1o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758530484; a=rsa-sha256;
	cv=none;
	b=SXPwB3Udpkbw0eOq+gJFgl8HhuVOXCg68La4ERCIU/mmXTYrhPQHhSJv/UwmfzVq1rnZH6
	kk+8dDaKAdTBXHU0g+OsCWgHb35fq5nOsJT3E7tV42qz1Iu2dTqtzwoRzKpvoYGj9UgPOF
	B+ZMjqt0KYWL7SfC3WQZsmIUfGTRods=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=nCUHaBhP;
	spf=pass (imf01.hostedemail.com: domain of usama.anjum@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1758530480;
	bh=x4aklYGFshEx41NI2ERMJ10pOo0Dk0GTz3xaw/4licM=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=nCUHaBhPvG0KaFJG6BOXE4BwhzOe2Q1u5auBLvDgrG8mGKnQIu3OGiwqu00yc2mUa
	 LdGjScXZHd9FajMF9M2OjqjbKz/kB3fZNug/YUjj3RqzpBRVY1PK5BFG54Zr8xVq67
	 sn8Hdy/c6Ss5zX+jxF2gtzr+LnSWczBtJjXS20YpSkajSUc3yg9Np6vwptI8lvUlsg
	 H6y8YeiF06Rj9xev8rcWzkCoBnxHJrK7Gw0f58s7+J6vtMtBeab+H/mHpADS9Tgw+k
	 IBbSPrRSHpqFuAz9/77RoEAlv1FHRZdShfz8EEjMNk9ZtUcrxQAs8ICaxKVkfh0rhQ
	 ZCps+Zm2hlkkQ==
Received: from [192.168.100.175] (unknown [103.151.43.82])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: usama.anjum)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 16B5217E124A;
	Mon, 22 Sep 2025 10:41:17 +0200 (CEST)
Message-ID: <a5400d9f-fb72-41ca-bedc-aa1c880a2234@collabora.com>
Date: Mon, 22 Sep 2025 13:39:02 +0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@collabora.com, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Jinjiang Tu <tujinjiang@huawei.com>, Suren Baghdasaryan <surenb@google.com>,
 Penglei Jiang <superman.xpt@gmail.com>, Mark Brown <broonie@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Andrei Vagin <avagin@gmail.com>,
 =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
 Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3] fs/proc/task_mmu: check p->vec_buf for NULL
To: Jakub Acs <acsjakub@amazon.de>
References: <20250922082206.6889-1-acsjakub@amazon.de>
Content-Language: en-US
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
In-Reply-To: <20250922082206.6889-1-acsjakub@amazon.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CC6CD40003
X-Stat-Signature: cxid4b3x5x43pc4jxk87ctii41fhhuih
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758530483-175382
X-HE-Meta: U2FsdGVkX1/5egXfkv9qlG4hjX9gvgWsmUlt4+OQJ9eA5+ZG3PHp3HprTpPQnD0RN33X5VVZF1AY0cJjnsyTe10keGlwASSt5Mm7p949wUUFDaucDUUY3ZrhhMrMfW3v/VcRtcWbkps0g15G60uQOIR8xyj+h0UTgXaK2d/3nxcbclSK0f6atspaUpcke+fRvMcYAlDziMk0PIBAWVNabB6F6KAErsnOVxI6ABBra3iK1axMh6dvGqVmCK3ogVD0qEi00vlwT10rZ5f3EatjTi1qZHWG7uTiXEH/QBDunwC1jfIaRuFQnvBexwCBe5lAETv1b9ubFGeNQ/LZEieWu3AHrrtMlbidM8iTc5/Nm9A6c6NlWZWou7lh4p/6GmFfLUlswhb+hCSk1NnA6tygvbGUsbB/Ei4AiVDa2+Bmgvh7GPXxKdQ/f2HhYWQc6KMuhECS7TEZVsHPtcZKJp7NB7Dobc53+J6tlcOTJQfkCRhU5v/6hT901IB0xGuPghpPhcOQJsh5QhipTgcGbo5+W+iKtgMRXzq9cIa7EpXTdmNHJeIx0CbzZZjWuKeTfNIZFM//6h9zaOySVJqEKLP1C6S3/RT2r5Qvq3QhxBFvVhdYlGJNhqkvsb154rYg3JO2qMlYrvwUm+l9yZ6dsUyBgUujFHFOHYl0p7Ay7R10Z5sHjVsiHlT7N07R1KAd01q1ru62csUJX+PjF7m8DdZKzE04NYio/UDJV7Vd1jp6R1liszgDbUCM/3J0gyoXezBNnL+hgH5zUUJZ8/ukwA1UjC3kjdViTqzNnDQOsVMnugJCXAfdiN34vanqMjpE2yHv6g0UyNjbJiwMzSkaGwIuv5INsN7cIoodKN8SKIWYzwVBRORh8YCB8EdzVnVbi+SW6PecpdbRxmBcR6dLxDhqcoyT7Qk8t+giydE6fNx4hQU1wLmd9CFcXoti4gShi+louo7h5ZQ14mLdGFJZhX5
 LDjVGT4P
 Snoftddea5MtFRFTTq2JuMstlSLCAi4lRCl31xXbVB7EBMxKM1Y8PZDc5un8p5SP6scw6mvWawpPC65COzPgjM9N75vNCOKld55PY+imuQuh0tJRZZ0EvEeSbo+OsxJto+CMw+D95PqihD5R1EOJCKHHr+Ksh1EpIQzixG7NOyPxjpQL5EPbRDx2xb3X6mOnULak2i9FaKaZY7DC+rQp8d3Lsiz1pNt/nWWjGY36sE62x7+UyZ7sTlYfFkrPfHlfrXW1ukTs++i+r2Ui279srIXLxQD/zRJe8se+cgrCSH2vwdWct6oT5swgzl/4Oe0Z9r8ar9XWfU2CxbtEeNMdUMmAmQzbNfdzON/u97SiCDsnXm8lacKiTTFvm8gehiPFACQ7a3U+AWBJbBDkO6ECniXRnCzx46A4EHTqxeN7z7B0xpx0pc+JxQHNFbRz7UIiEr93Wxhmoz+mY46KWnVoPfLOAwRxTeizIoRPOnYffznJ+J3q2uj1dJEuaUNuQxZRgFQXh60LvWhuiOFRLABjjnBA/2CekC5FKKHeSyQNeZYohMchJf6E0rxPXpS2GlaXuDYkLYI4TPpz75OFFWuGpuSyM1s9CC4ZUp6+UUtNjVTarz4wHisZW8X75Z0GZ+oI0tOtfMYFUX7tIum8NKsys6/Vmvnt8MllSv0pNGOUABChpwixan6QgSBBXcMj+igyAfDuewuP09EhuwFV0S/PYOwemnIzr7QK0Y/YJHIzyj4eNotgiMtvL+d19bsFxdab6P5hbCMaBBtEPf3+TcL1wam9VqzndNSLdSnkherv7RCblR+ArqVB3mrE+eyRodnS6rQhUFotnAtVQf0tO03xZGfpr0Sr0F+h33u8+SiHOTOrDuV1bj5xSZ96wKIaiGO+V9kalx5v4TpS/Nx0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Added mm list to cc as well

On 9/22/25 1:22 PM, Jakub Acs wrote:
> When PAGEMAP_SCAN ioctl invoked with vec_len = 0 reaches
> pagemap_scan_backout_range(), kernel panics with null-ptr-deref:
> 
> [   44.936808] Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN NOPTI
> [   44.937797] KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> [   44.938391] CPU: 1 UID: 0 PID: 2480 Comm: reproducer Not tainted 6.17.0-rc6 #22 PREEMPT(none)
> [   44.939062] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
> [   44.939935] RIP: 0010:pagemap_scan_thp_entry.isra.0+0x741/0xa80
> 
> <snip registers, unreliable trace>
> 
> [   44.946828] Call Trace:
> [   44.947030]  <TASK>
> [   44.949219]  pagemap_scan_pmd_entry+0xec/0xfa0
> [   44.952593]  walk_pmd_range.isra.0+0x302/0x910
> [   44.954069]  walk_pud_range.isra.0+0x419/0x790
> [   44.954427]  walk_p4d_range+0x41e/0x620
> [   44.954743]  walk_pgd_range+0x31e/0x630
> [   44.955057]  __walk_page_range+0x160/0x670
> [   44.956883]  walk_page_range_mm+0x408/0x980
> [   44.958677]  walk_page_range+0x66/0x90
> [   44.958984]  do_pagemap_scan+0x28d/0x9c0
> [   44.961833]  do_pagemap_cmd+0x59/0x80
> [   44.962484]  __x64_sys_ioctl+0x18d/0x210
> [   44.962804]  do_syscall_64+0x5b/0x290
> [   44.963111]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> vec_len = 0 in pagemap_scan_init_bounce_buffer() means no buffers are
> allocated and p->vec_buf remains set to NULL.
> 
> This breaks an assumption made later in pagemap_scan_backout_range(),
> that page_region is always allocated for p->vec_buf_index.
> 
> Fix it by explicitly checking p->vec_buf for NULL before dereferencing.
> 
> Other sites that might run into same deref-issue are already (directly
> or transitively) protected by checking p->vec_buf.
> 
> Note:
> From PAGEMAP_SCAN man page, it seems vec_len = 0 is valid when no output
> is requested and it's only the side effects caller is interested in,
> hence it passes check in pagemap_scan_get_args().
> 
> This issue was found by syzkaller.
> 
> Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
> Signed-off-by: Jakub Acs <acsjakub@amazon.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Jinjiang Tu <tujinjiang@huawei.com>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Penglei Jiang <superman.xpt@gmail.com>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Andrei Vagin <avagin@gmail.com>
> Cc: "Michał Mirosław" <mirq-linux@rere.qmqm.pl>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org
> Cc: stable@vger.kernel.org
> ---
> v1 -> v2: check p->vec_buf instead of cur_buf
> v2 -> v3: fix commit title
> 
> v1: https://lore.kernel.org/all/20250919142106.43527-1-acsjakub@amazon.de/ 
> v2: https://lore.kernel.org/all/20250922081713.77303-1-acsjakub@amazon.de/
> 
>  fs/proc/task_mmu.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 29cca0e6d0ff..b26ae556b446 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -2417,6 +2417,9 @@ static void pagemap_scan_backout_range(struct pagemap_scan_private *p,
>  {
>  	struct page_region *cur_buf = &p->vec_buf[p->vec_buf_index];
>  
> +	if (!p->vec_buf)
> +		return;
> +
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>


---
Thanks,
Usama

