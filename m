Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10B6DC55171
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 15:59:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6C9B6B0088; Fri, 31 Jul 2026 11:59:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF59F6B009E; Fri, 31 Jul 2026 11:59:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC06A6B009F; Fri, 31 Jul 2026 11:59:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7D8CB6B0088
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 11:59:54 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EC97B1603FA
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 15:59:53 +0000 (UTC)
X-FDA: 85049532666.03.25A06CC
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf16.hostedemail.com (Postfix) with ESMTP id 654F918000B
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 15:59:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=RMZZeAgK;
	spf=pass (imf16.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785513592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ymVGcC4AX0GlAPgLHOLokJGJhYmKcjYRm3lVzOv1mw=;
	b=1q+Wio/K6AMrchz5Bco8rkg3XrcnguLmG3flc0U3XHYuGCVAtQbIxPdqOxv5KTE9tqsjD/
	gm88W6ACm59R5bXL4qooiab0YbQ9qkUUjiaMlbLsiRSRMHzw3RrUmLvDuyBDgWV3n7MrjK
	5Pu4/kE757GmNLUIi1271r/CVnb9oiI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785513592;
	b=2HiroBMQixyp9KujW9FasSyuccZdOrJxsHphxWkP1MCq9bVDMzNJ1LcBwiAUQ8T6beV/QC
	73CTmKBamjA2nZlafuVvsLH/Ve+XcCOlBrjkAekZACPFJtqeexSvzTw7awN/peeBTvwbWb
	CeWIHg4L20cpIkPtwOCR1QmdnAvmeZc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=RMZZeAgK;
	spf=pass (imf16.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1ymVGcC4AX0GlAPgLHOLokJGJhYmKcjYRm3lVzOv1mw=; b=RMZZeAgK7KjBH4ZjFJvsmvhvoX
	3ybXK8xGn/j9wo3Q6fHryJUBZ8EbCDe9bnuKCafu5KNp4lZxnfdHS7vm+A6ThZvqHy/6JKtWrYsnm
	4qsvd+DD9aXxQLIp/OTiC2vxJ0OZQCL8iHXWtEYjB1t2347Zx7PabAXAv3KVlKH29OmR0KK9sEN4o
	wZl2AmyzE7A640Kufh2LJD6iLcuwLYFGTfsfW3Xq8Nv8fEB7F+bmUzse/u9Us28NRtLEKoFXWX1yE
	U7GsNDHnPZvstoHx2RPVFYa1zxsIyQRi8X5RpysRE4J8RujQSzbmeW2rAcVGeNVBVmipt/LJadRE0
	3RKq78jw==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wppeG-0000000CwRW-2TvD;
	Fri, 31 Jul 2026 15:59:48 +0000
Date: Fri, 31 Jul 2026 11:59:44 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: syzbot <syzbot+78a7af91b68fc6394771@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, jannh@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, pfalcato@suse.de, 
	syzkaller-bugs@googlegroups.com, vbabka@kernel.org, Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [syzbot] [mm?] WARNING in mas_nomem
Message-ID: <6yf7k4fmg4tkbmli6t4qzrk2eiyuuynoc2oimbgaebught2yh5@dspb7xile3kj>
References: <6a6c4f18.b1a781d0.210f9.001f.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a6c4f18.b1a781d0.210f9.001f.GAE@google.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 654F918000B
X-Stat-Signature: w91s4gzq7m8m8nj197u1qcqbxzcg4prx
X-Rspam-User: 
X-HE-Tag: 1785513591-780959
X-HE-Meta: U2FsdGVkX19TmyahqVLEtbZ3hO4uPfoi7PXaXjrRDL8IWyV70IVl2aoGPTtNmabiTPV/UzrXTcZOBWoozstYo5OlpXlLM4CoF+S8y4kWlTSX5FoWz/ls8cB38k5zt0E9B/Na9iQLCY/b6WGIe0wd+arIxcGGEBMTxBiYJ0SeEgXkdv8IPbqhiVY3UXeT4AfCE6Yv10NU+3Y82Vov3TRwZHGgL9GyN1fphn/SzLZpYyf448MdlVCrnXbzZJqRfkzJHZ97OOQ56NY2/ij9fdzg++SKMhn7w3PFko3IrmfmpHqEh7F5BUCFq1GRa4u2sX57ihlZxDqqrJUAN5VKqPABv3ONr+3oujux95OCnCPHlephsV/N1/j6ShYNwQQ/Osymwk8+hYT9ITaUNJ8zzkG2f9Xix4eXFtKlwpRkhtCvAYzxIoNIEH7ymxUcEfMxBJbnFVRQFy2qU5IstTCR7wsV8berKiKMej5A/u/y3gAHJWhxeIG/BOtLlcUaCVgYnRrnBp/5fy3t06lt6+VgJlflSjg7Rn+fx9WuWivoyTWXEiHWOMm4+JhqgHWWF0jaJYf/FgOUtXBSaS6QaSB2aQSvcChiWTM8HH+eqnF5KwsGXrxKU0GSPKAGiEm227x0HoYY20dTEH4reqTbBSn40rfnTBhuxPsdh8a9L5kyHK+sjFIGjPK6EtbhjZKMJI4O+8sl2s6KHZNhNMdxeQjmtHS9nau9PPhOjS8OdqGl83cgX+ghUHNAEnF1P4U4JID2YLlNWbmsD3xBqtCVAnmfWsn/xpxa+fAav88M5HfNyHsyslBS0kkCsKlN9YdiYRkB2hFIcfTATpDYsIiDHbu5RCfV3uivm2RgZ7lzgnl0fXSf834hANkWxaNFgtbkISse2y/ycy1MV3xqQcBSiU/tsaVivKmCyq5Qe8cqYRms7PgAQ6ul3P6wn1tAYPJraE/wDRBxOyq40T0B7w08e//zIhP
 b6fdmw8T
 vZQQJpiDxhbTKjbpSKDYgXbiugJbmcSF4dtmiJdr/Ap1qlM5R62r8KKA/N3fyHCnrEJ45tVfxFXCVtFk9Ivrcxgr9P87f3Y7/7ucAvRgLoPhMNBZaSS5uD6oa4fDzy6mZairiPAukppBiRCrUDquu4MiqgLFKv5aUDalRrRLILA4pzmjfnUJ7Xa6E8ybiWHxZP4Vabo8IUloyN+UILorUd0fskcDcLJI4hFWTyq5AvbC9PeJl2tV5pc/G/lcePLkh9qo9gKlBO/7ZZTUVnJyGIjWTcQG0EDrMafKX9zeulAf98JB/MMibN4rcdlCUOwJckdVj49NbXGU6hqSpmYdW1iAg0e9a+RWOEoqHEbU/XR71TsrwlOb+o0nhhpnCPBcgS1GMDvaIpHWYW8Ggqm5iVDl5ZZ6UkeH4ocvl+4d/MVRN4gnVYnwaabuBTzymbIJXrUeb2S/RVVV/mktaoSH0bv0dkZX1jkEeaOqGegmCkE8aYlBvO3GFXg9iwZI52Bv2CZQkyOnW9DEqzNZAo13xM/njdN+iObIHg4E2kqR//5boET58zdkCG37/vDMjrvAq93vc43Ae/1FTGQoJ2J6IG6ggAyWaIWMoMY+v+yi7GBny32nktTqkV8d5FSqqMuUiUEYAVSUGP1LFl1cogXVuVCAcrYU5yVcOU+B1wxtDuEXCG6TKNQ9pUZm5v1ANIz8xJ80KYDq0dO6RYY3F9Z4IN2cP3CelaVjiGbH8kC+JklVUqR8sDO0XAMCSVO20T5a/Hw9EqfH7HKazr0ntDQRGxSHiR7RaJ9mB4zn5mFmAlyMObz2McL6QY5e5JagEpZEmnp1fxgsPULEvJz06WDETRI+KbFb6O8suihgjR4PujhZl+WPjXTpU4CEibSC546EgJmNVU875R7lg0SGlXTQVHFbDnoAx8VznlzcbaUd0u55FWzf8baOFtamJoz6Zqtub6JKmhtxOEwSwuegyAIl41ppDCrHo
 L/Rl92X6
 jR8TBfiyY3Ewtdd+oCbZYOMGXRNI4uK+NT0zH0ferffrlhcc8U7+CgHA53QB6BTQ50f3jitkLiCwXLW8mZiFGB7V9FLTDetBrrzfeWT/1awADufQRGQ3AQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/07/31 12:30AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    cc2b5f627e8c Add linux-next specific files for 20260714
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=15ce5632580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=2290ccbf984c524f
> dashboard link: https://syzkaller.appspot.com/bug?extid=78a7af91b68fc6394771
> compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=179151b9580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/6836f8efb1da/disk-cc2b5f62.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/0109d3477cc7/vmlinux-cc2b5f62.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/c2e49e350bbf/bzImage-cc2b5f62.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+78a7af91b68fc6394771@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> !mas->sheaf && !mas->alloc
> WARNING: lib/maple_tree.c:5751 at mas_nomem+0x1cc/0x210 lib/maple_tree.c:5751, CPU#0: udevd/5627
> Modules linked in:
> CPU: 0 UID: 0 PID: 5627 Comm: udevd Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/16/2026
> RIP: 0010:mas_nomem+0x1cc/0x210 lib/maple_tree.c:5751
> Code: 4c 89 ff e8 d6 85 ea f6 49 c7 07 00 00 00 00 b0 01 e9 95 fe ff ff e8 f3 2d 7e f6 90 0f 0b 90 e9 2b ff ff ff e8 e5 2d 7e f6 90 <0f> 0b 90 e9 77 fe ff ff 89 d1 80 e1 07 80 c1 03 38 c1 0f 8c ce fe
> RSP: 0018:ffffc9000562f8f0 EFLAGS: 00010293
> RAX: ffffffff8b4775cb RBX: 1ffff92000ac5fbf RCX: ffff8880366e3e80
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000cc0 R08: 00000000ffffffff R09: 1ffffffff1ca1a86
> R10: dffffc0000000000 R11: fffffbfff1ca1a87 R12: dffffc0000000000
> R13: ffffc9000562fe18 R14: ffffc9000562fde0 R15: ffffc9000562fdf8
> FS:  00007f9021203880(0000) GS:ffff8881259f2000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000056467bb0d750 CR3: 0000000046416000 CR4: 00000000003526f0
> Call Trace:
>  <TASK>
>  mas_store_gfp+0x37a/0x820 lib/maple_tree.c:4987
>  vma_iter_clear_gfp include/linux/mm.h:1674 [inline]
>  do_vmi_align_munmap+0x30c/0x4d0 mm/vma.c:1644
>  do_vmi_munmap+0x252/0x2d0 mm/vma.c:1697
>  __vm_munmap+0x241/0x3e0 mm/vma.c:3347
>  __do_sys_munmap mm/mmap.c:1079 [inline]
>  __se_sys_munmap mm/mmap.c:1076 [inline]
>  __x64_sys_munmap+0x60/0x70 mm/mmap.c:1076
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x17b/0x530 arch/x86/entry/syscall_64.c:85
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f9021368097
> Code: 73 01 c3 48 8b 0d 61 2d 0d 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 0b 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 31 2d 0d 00 f7 d8 64 89 01 48
> RSP: 002b:00007ffeaf32d0a8 EFLAGS: 00000206 ORIG_RAX: 000000000000000b
> RAX: ffffffffffffffda RBX: 000056467bad9bf0 RCX: 00007f9021368097
> RDX: 0000000000000000 RSI: 00000000009480e8 RDI: 00007f90208ba000
> RBP: 000056467bad9910 R08: 000056467baec140 R09: 0000000000000006
> R10: 0000000000000000 R11: 0000000000000206 R12: 00005646569e2588
> R13: 00007ffeaf32d130 R14: 0000000000000000 R15: 0000000000000000
>  </TASK>


Okay, so I'm going to change this warn_on again.

The plan is to:
1. Make mas_erase() and mtree_erase() use __NO_FAIL on retry.
2. Remove the warning so that any failures won't cause the warning.
3. Make mas_store() use __NO_FAIL on retry, like mas_erase().
4. Add the check for locks that cannot sleep to mas_store().

Basically any caller that cannot correctly return the failure will avoid
failing by allocating with __NO_FAIL.  This means the warning is not
necessary.

Thanks to Vlastimil and Pedro for the help on the plan.

Summary of previous conversation is here:
https://lore.kernel.org/all/20260618152451.GE231643@ziepe.ca/


Cheers,
Liam

