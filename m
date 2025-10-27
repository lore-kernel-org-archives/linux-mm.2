Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 894B0CCF9E5
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 23:57:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5747800CD; Mon, 27 Oct 2025 19:57:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE087800C9; Mon, 27 Oct 2025 19:57:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA83A800CD; Mon, 27 Oct 2025 19:57:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B4494800C9
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:57:01 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 718AF878C7
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:57:01 +0000 (UTC)
X-FDA: 84045557442.30.0BC02E6
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8357D40004
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:56:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JghasgBr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of krishnagopi487@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=krishnagopi487@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761609419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1pmO2Ks/d5kzSWvg4XCnqwnFkB+CHRKiMcRi15wDnNs=;
	b=IIpx8Xk4WDMpMib9pB0pf+F3mqvQ/34osO/705N3Sdq7Cq3aHbdlymXMdDBaFtFiU6iOiM
	7reXbxr0/sgDxPTxLJSrLqZq8fVh1T/pm/h61IJ+5p5KrVLKnzOH504otO7UgjPfft0weV
	0V8j2c05LhfC8p0C4Lwct6uc0jzbt0E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761609419; a=rsa-sha256;
	cv=none;
	b=Q9J1MCcAQXMfyt2J9tSKOOx8C1V8yEBUbwKe1tlJcDCZKwga/u6pu2awYaXhTQ4Sxfqjxk
	lw0EKiKjNV39CF4MmRQASV4NSvEWlcVSeuhR/9sZ9vmDOJ9szAs4XtJLnd5f9p5B+lG3Dc
	uDOjUBe7JeKq+vAE0eg9B5y0phTGJ2o=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JghasgBr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of krishnagopi487@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=krishnagopi487@gmail.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b6ce806af3eso4859521a12.0
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 16:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761609418; x=1762214218; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1pmO2Ks/d5kzSWvg4XCnqwnFkB+CHRKiMcRi15wDnNs=;
        b=JghasgBrAOjuRv2MVeYuewZeMoQ7AE2MRBR/JrcTwlEHaEJ/lJa8XJrLoakgi5AbmG
         rrdBy5+k2Dt3fasfja8Zw0JqVobw8LyVw4ujoditqeWhVkQTrsNOnPjUvmARfcKoax2Y
         Y+wOoV10Xdxc/RM1/Sk3CGhBHaQMsPM4NS4dsJQlBWoMBPCjXanWBHZhYwja0kzGwVJG
         uFKb5vCT/dk65+bOf6/p6g/Kd9uvbRTzWdz7ueDix01RoZqLnD6BHd3qGKad402b/y3Z
         WZ0SQZPcFpmgNLv0FW4o6HkOAMsBU9N7wMRhRKTjEknGe9csosQ6g9BkcMF6ysXKdVOZ
         gJRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761609418; x=1762214218;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1pmO2Ks/d5kzSWvg4XCnqwnFkB+CHRKiMcRi15wDnNs=;
        b=fpAON3sEB+UZC0T7nRqyXgqcYl4EzNvFm5jPZkTvZ/tQZUaW39rJcgoDej1bPfF2xs
         9dmhg0hpRDjYMoqPAaLt4zPDB/s0aXkM38ZwCBwqHAuvPpNyvMosGHDn+ytlqCQkysmW
         hlmcWwgm78KH2Gjy14Mbj7RNlfkleKuaQlC7XM7HE3PfJmImjeVeSGsbHuWLx0a1c+d8
         fneEMl2O3XwMG2wuozlO4CaXfEU6k5z1bZLWTvdVIByclkVWAccN0x1i2YoLsDzCJmpz
         6wxaSfEZ22nI/kUiuTfUN5msmrmEAH5wx1CjzCyl/OfOUEkJJAu7oi71cy54NNP0n+L2
         Pqpw==
X-Forwarded-Encrypted: i=1; AJvYcCX6gNgSx4UrFAqOqjXjahN9/2Uwg0oXJdLxpz2s71kC0iZYmlvhSJ2Ka1qKcX1454FComNOrXQ8VA==@kvack.org
X-Gm-Message-State: AOJu0Yznd+LxsRJsh54MzMvWxbhkZoOzaBmOrPCXYoWOlHKVNNtP8uSU
	+KSW/eOCxxu7OSQyeIUDP0hmWCimxvqxfpQjPy3vqOUB4G3KcbfSc9Z0
X-Gm-Gg: ASbGncs4tJfYkZRZFi2AvYKPVGswROuwTdyHaLB7rtNlc5PoFLgg9C58usFz19Diqf6
	ixjMxcx82WEEYnKIK34LeNMPZ9EDXlxQigvYg42ewaSsj61YRsnFTWMP2TnwEpmWjRSyi8WLGWq
	nVULVrZXqxaIOthcsl3O8/EFg66KD0wUV8ypbMUKV60scd4ZNg2uKyj4eo7p2RuO1Ui1p85nUNI
	h1RGt7LYFkrLQ2QfXF7d3jX1/zicZLZwnR8o1NRoEYfufgyOSdkBlspguK8kZBfWe65TupOxDOk
	KDIJ2e7y6YfbMSsdHfHslkmmwHIkvkwIeJMZEjcdgmkRjd+aH0FZk/HOPE/susNyTmUrDkKzEpL
	Un8sSm2CbMEtCnHcmGp1DqHNnkXs4vsH5buKWNFX52fWNwMU1oYgUFGC2kreY7R0hoidh1TTZdu
	L1lt91RMpPoKfiH20bWpPuVSLS
X-Google-Smtp-Source: AGHT+IFgQ0X5YV3xU7p5DTXnxiJ9uiTQF/LgohkVz16uml4TCI8ef3zNjJ7wT+p7VkosTHV2zIWRbw==
X-Received: by 2002:a17:903:1666:b0:267:bd8d:19e with SMTP id d9443c01a7336-294cb3d03c7mr20202885ad.22.1761609418155;
        Mon, 27 Oct 2025 16:56:58 -0700 (PDT)
Received: from localhost ([103.70.166.143])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498cf3405sm96781305ad.2.2025.10.27.16.56.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Oct 2025 16:56:57 -0700 (PDT)
Date: Tue, 28 Oct 2025 05:26:54 +0530
From: Gopi Krishna Menon <krishnagopi487@gmail.com>
To: syzbot <syzbot+a894fe5447d0543e89c9@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com, 
	david@redhat.com, gourry@gourry.net, joshua.hahnjy@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com, rakie.kim@sk.com, 
	syzkaller-bugs@googlegroups.com, ying.huang@linux.alibaba.com, ziy@nvidia.com
Subject: Re: [syzbot] [mm?] WARNING in raw_alloc_io_data
Message-ID: <z742ziobbolobstu2ljazsv3hkp27pdpfghrtzj3vfr46w2v2s@jqdpqtdgy5qn>
References: <68ffe1a8.050a0220.3344a1.03a0.GAE@google.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ihf26owk5ldxigdu"
Content-Disposition: inline
In-Reply-To: <68ffe1a8.050a0220.3344a1.03a0.GAE@google.com>
X-Rspamd-Server: rspam01
X-Stat-Signature: 338zym7gtarmu6qmjdzm1ru1b4hfuguk
X-Rspam-User: 
X-Rspamd-Queue-Id: 8357D40004
X-HE-Tag: 1761609419-651071
X-HE-Meta: U2FsdGVkX1+TN3ho/BlAnZZm+7/clj/JL5Jqeru8DIvXr6+e35AS11tPlDcPd1ZSDtdODMlwT6q8oJkEc4b29wu3lCQ9qW1u0aN/t+hp5K/FzWLoQh7d/+z/fQEgjelxBoU9V9/Lf7GLoXMh8CCQ5qEefQy4QdPVpiF4ZOVzIUGMFBfkc45q2ff79cryaVdOftIiZe6/Et5Hm+FpC/nwLSK8PU/wtPD/pXRjVjBbg6JOoZ9ep1KUDZbgtq6UQPV+VAS4hdVG6gQ0HmCJqv3dEoA7QI7ixxTHpAFNRI920IZ5r65drF6DgZ+cPfgYPnn73hRxuL9e65lEiFk+P0tdMpPPHZmxbGuLNjwVSo1dMSlQBwOkM2vBemeTmOBO1CjoJUyHvlF41YPJXBBbZV+ezG/i/r2ddHrODKJR72JwVHiwVRveNl2XytSdPPq8Qx97yx+NzNDazGxnbmAN+e7Ux9HCNnkt2TY1ndo/Z9wp2UJ9YjNMDhs0UZP38EhLp+u2f4za6x/XwY651QHRc9Eqv73efJScaLsp8OitVtk0l/pkHxJEcRKqnt4zO3WoHoUFpoT4Vpi6eRjXDtHkdUJ7h3GSJKpYFH2KDJRdoU8lykC18FnXSkv2NauFvj3tbv99/Ovxj3gYoNdG2UycrDXs/JKObCpmCt2OI9V3Bx5ANi/FAbpc0AbNtRvBu5E8N/D31P+saji+1eWEXHHmu+3lkmf/24ln4A+ZGbMJ+tPmoSaNwedeMe0nrd1p8qkectHB1F0IagJtgCrlVlLn1mFVREmEQqM/QW9/JQEo5UXw6IRToFd8p41CeGGwVYZHMaYVyohgsSKfB2wqmIzYcnXB4RX8NcB0VxgN+KKJqCWc1HgiJnTlDHEkyXRU1cnIKAf1bb96yo4XvEv7LpNg2OQR6wZQu4y2NRoPAm46gGLu7QB3OOJhv7LlpJl2+nITC38TA9ic1pHG2CnXuYY9TWa
 b+Qinwo+
 rc2sKIGfgv6eHAWzuWIhvk0WOgvCv+QHC82pIFvSlMoFj8046DnFqIH1qwPkVYoPZkzAs8Y051zHkIYo+Xnuw1EWpum9UHXGO5f4wRALFZhWkBYDTSgjt629H44IgjAsjduUAoELxYeAEwAVzs3F64DIu5e1Xw9p7hfmfpoVp0IbPz5GaM3I/DCzwpkeebX3jmTjLbCGd4wnT/FvLlu9YvH98AFxa6/RJMpq6aCXHQ3I2Zou49QRzZh+jqABLPa9e8+Xl0mkLDuUcNyC/8gUGAltb+nNF/Nje35f/l9jkCvXI4nlCvvqnOJf2PuLNngquw7suFj8Pq0D3QTY37A9m57oKhQw7K+VaZMK8w/z5AHC5UIHTE252uI7PtQ20Zaq97zHhtbDsZ/c6+yGXhCppNLp0f5rp0JYG2PvKOZoO6oWhPNH5WEJgmXhFHQ7y9Tantcpvm94/IPWEby/Bc0oqFBambu8HAG4CsHzQ8fFk1tQuXRzMJTIiy5dE/EghA31EbeH8m0smXvj+nFOiu6vBHugKb16XTJOcujS2XNpU/7KxiDnmI05iLBeiiX+oeBz7NniVCpISFzqI1rwyx4jkyb3eqvKLWJEdaKKxvTtSkMw+NNcd+upkM1tMtIMnuUQ0PZDrH14h237cArz22OaSJ6c6mK0bMKFJz/ghI6q4dOyVseftu+WIeYh+hnfE6wJZ1+eRTuBdNM5NbjHTqakw4ArTuYji8xX/BUyL6WM1qCo7iYfXEPmJDr5dKuswGQyB2jhSoKyyxvcgxp7c9CaLeq6wvnuPEaK21Q554GMw9rLur3nH2QVDSiYfMdjZ9AAHF0sMHQD8HJ1cdBP170dTadeX6vOY0rV+li0axGzWmWmHWDlf9SCwBXwSV2ivFPNUzw88OSKx5zfq7OMHwLwjmSd+uIN3JXvXUm0CVInAcwtTVfQr0fm5lWi7VyX6CUN1HO9dGnCgZYma0cyZvfQKInMK900B
 nc9sPS1o
 d1v+j7WB1QSWe3fTuMzMJsk7iEvLLdGdS0Gx5Ixso113vPH3CBxsKbnxmtAiTJCtCB+hHXfhPJtC+9MfF2pMH5WrC/HGxV5IWC/9OhJKYlwj07nQayEPsE7Au+av/hcpcXIjnOxqnwMShuOfQ7aGsRQcrVBRs72AwFo7+pc9T2+z5FAeSJ89HK/wjrFpOAfGXqXkZmsNWE1DZGibIqwnFNTQaxAfd6F9D81zW93hLpgrWjQ4QtY2W+5sGSRTXy9Dc3rDQtrTK5n1kb10GoqQihRmc0d5BaQR6w0nOLouNOhnv97hWoHjnv09oKQasUIjISHaNbq4eOM7Yz45bptRek4ZW6aesgElvvZ/eBw48mwFzMraYCMYB+4MeOWreZ96zu4F2uIuy5ryESoguWY69KNVGlVo/72k5YqvaNXac1YKOkqX7cJQFBnveZJ14yvH8bWeSNXsSVUbDQCTMOJGmw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--ihf26owk5ldxigdu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 27, 2025 at 02:18:32PM -0700, syzbot wrote:

> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    dcb6fa37fd7b Linux 6.18-rc3
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=160597e2580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=609c87dcb0628493
> dashboard link: https://syzkaller.appspot.com/bug?extid=a894fe5447d0543e89c9
> compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11af27e2580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11c2d614580000
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-dcb6fa37.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/61176fd888a1/vmlinux-dcb6fa37.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/84e7e9924c22/bzImage-dcb6fa37.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+a894fe5447d0543e89c9@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 3 PID: 6091 at mm/page_alloc.c:5159 __alloc_frozen_pages_noprof+0x309/0x2470 mm/page_alloc.c:5159
> Modules linked in:
> CPU: 3 UID: 0 PID: 6091 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> RIP: 0010:__alloc_frozen_pages_noprof+0x309/0x2470 mm/page_alloc.c:5159
> Code: f0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc 83 fe 0a 0f 86 0c fe ff ff 80 3d d4 63 52 0e 00 75 0b c6 05 cb 63 52 0e 01 90 <0f> 0b 90 45 31 f6 eb 81 4d 85 f6 74 22 44 89 fa 89 ee 4c 89 f7 e8
> RSP: 0018:ffffc9000371f9f8 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000014 RDI: 0000000000040cc0
> RBP: 0000000000000014 R08: 0000000000000005 R09: 0000000000000009
> R10: 0000000000000014 R11: 0000000000000001 R12: 0000000000040cc0
> R13: 1ffff920006e3f55 R14: ffffffff9ab2c464 R15: 0000000000000014
> FS:  000055557bf92500(0000) GS:ffff8880d6d0a000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f84d9710300 CR3: 0000000032452000 CR4: 0000000000352ef0
> Call Trace:
>  <TASK>
>  alloc_pages_mpol+0x1fb/0x550 mm/mempolicy.c:2416
>  ___kmalloc_large_node+0xed/0x160 mm/slub.c:5583
>  __kmalloc_large_node_noprof+0x1c/0x70 mm/slub.c:5614
>  __do_kmalloc_node mm/slub.c:5630 [inline]
>  __kmalloc_noprof.cold+0xc/0x62 mm/slub.c:5654
>  kmalloc_noprof include/linux/slab.h:961 [inline]
>  raw_alloc_io_data drivers/usb/gadget/legacy/raw_gadget.c:673 [inline]
>  raw_alloc_io_data+0x12c/0x1a0 drivers/usb/gadget/legacy/raw_gadget.c:659
>  raw_ioctl_ep0_read drivers/usb/gadget/legacy/raw_gadget.c:776 [inline]
>  raw_ioctl+0x1397/0x2c30 drivers/usb/gadget/legacy/raw_gadget.c:1313
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl fs/ioctl.c:583 [inline]
>  __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xcd/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f84d938efc9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffe768729f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007f84d95e5fa0 RCX: 00007f84d938efc9
> RDX: 0000200000000080 RSI: 00000000c0085504 RDI: 0000000000000006
> RBP: 00007f84d9411f91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f84d95e5fa0 R14: 00007f84d95e5fa0 R15: 0000000000000003
>  </TASK>
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup

#syz test

--ihf26owk5ldxigdu
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-usb-raw_gadget-validate-io-length-in-raw_alloc_io_da.patch"

From ec93e88de10f0c0b02645e9caedad75323cf767c Mon Sep 17 00:00:00 2001
From: Gopi Krishna Menon <krishnagopi487@gmail.com>
Date: Sat, 25 Oct 2025 20:48:56 +0530
Subject: [PATCH] usb: raw_gadget: validate io length in raw_alloc_io_data()

Not checking the urb buffer length can  allow very large allocations
which cannot be handled by the allocators and can result in warning by
the allocators. Therefore for sizes larger than KMALLOC_MAX_SIZE we
return -EINVAL.

For testing

Signed-off-by: Gopi Krishna Menon <krishnagopi487@gmail.com>
---
 drivers/usb/gadget/legacy/raw_gadget.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/gadget/legacy/raw_gadget.c b/drivers/usb/gadget/legacy/raw_gadget.c
index b71680c58de6..c922ab42b0ca 100644
--- a/drivers/usb/gadget/legacy/raw_gadget.c
+++ b/drivers/usb/gadget/legacy/raw_gadget.c
@@ -667,6 +667,8 @@ static void *raw_alloc_io_data(struct usb_raw_ep_io *io, void __user *ptr,
 		return ERR_PTR(-EINVAL);
 	if (!usb_raw_io_flags_valid(io->flags))
 		return ERR_PTR(-EINVAL);
+	if (io->length > KMALLOC_MAX_SIZE)
+		return ERR_PTR(-EINVAL);
 	if (get_from_user)
 		data = memdup_user(ptr + sizeof(*io), io->length);
 	else {
-- 
2.43.0


--ihf26owk5ldxigdu--

