Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADA74CCF9E3
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 15:52:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA0A08E0135; Sat, 25 Oct 2025 11:52:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B787D8E0150; Sat, 25 Oct 2025 11:52:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A937C8E0135; Sat, 25 Oct 2025 11:52:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8E02A8E0135
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:52:20 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 42EB649C94
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 15:52:20 +0000 (UTC)
X-FDA: 84037078440.08.C960856
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4799718000A
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 15:52:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=j3SWMhnr;
	spf=pass (imf24.hostedemail.com: domain of krishnagopi487@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=krishnagopi487@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761407538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S/G5OIygkBFviJhEHCwC7irT8X1Sky8Y9qSJRyc+oiA=;
	b=W3SoDMWbNRpCs7zW86NnMeRGowJpwYXaAoNn/kv6TuZ1gSwezZ9IN0ChtjMFxJqwwDSy8S
	BSeI3y46s7xBVbPNuP8pj40WItysIxKldkNdfDqVIM+/sqoVF4bnlw4di62IKKg/O5+AE2
	JVtRDPXnx70qV0NMQUjcSiEJtGkW5j4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=j3SWMhnr;
	spf=pass (imf24.hostedemail.com: domain of krishnagopi487@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=krishnagopi487@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761407538; a=rsa-sha256;
	cv=none;
	b=qRXTOo3YCPRxWC6Q9EvVAufJU7AvrBkOKA+rV43iWV77dEwQPwOBZJxrUEB5U9cprYWvQw
	Pa12oIfkGahfaYMJfWLor07j7t45HKk7zJu2w9/pNWXE5OfRc3nd1DxgMBKy3bgLzWbEzH
	NFK1zFYt5RgXNcSv7gXEUf1hBpnU8t8=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b6ce806af3eso2836101a12.0
        for <linux-mm@kvack.org>; Sat, 25 Oct 2025 08:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761407537; x=1762012337; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=S/G5OIygkBFviJhEHCwC7irT8X1Sky8Y9qSJRyc+oiA=;
        b=j3SWMhnrV8npmM/Y/Wp7ln/PTFMVFZEYURSuJizORICwrsGE6jo70M0ANq6WckTtxq
         sNAViaWBsoi10lnBecaEfX2CVnCj250V1zEEnjmOYT2ziQPWI7d/bEliKUJY0vHdtTUV
         vmPZ1lDqrCKs+dIkAd5l5xocZoxtECxznrFc0ZsDi/CKin2o44ihI2pa84VEyIkh/crD
         d5s8mK0P0CK24fJ78HXIyyPo1T+ACaOz91+wZJArekOXuBXW9HBUlAs++VIJEyQC+65N
         3nLL3kuvvuZ2rKD05HOGs/N6e1zh0rjtsSp799BkUnfLCo5RyJG/iskmFGPVaZuWCUp3
         fCQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761407537; x=1762012337;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S/G5OIygkBFviJhEHCwC7irT8X1Sky8Y9qSJRyc+oiA=;
        b=wsjvsq07TuFb61WT0YEATyaNWXrFaFQL0SzdnpJ4sAocNVQalm26eK3XZZjX16bzWR
         rIY9D4/Ox4qK9EQAx8YaU4qGUXxcYBudH6rkMvLny90JKCmESVMJPfQFXYMiXWtKp2j0
         XoIEUgVrJkO0vvtXaaGWWytsT9xnX8tTqqg9SW3D+3enZFyPB853e5vUixJmn+VbwuVz
         haxCJZ9XE9CE6hueR7qNNCN0sQLbFBWfiv1qO9wQ6XiDdrVuvxRLeIVa4JvWezn9IY7M
         4U5ijmHS9i1P4suKPLAIXLZ6UkR8nbBQ4mbWc6+hNtrv8N1WVkHInXwMiG+HFgAr3b5l
         bzLg==
X-Forwarded-Encrypted: i=1; AJvYcCWQLD3pLAMKqTLKeClXaXNNRPhPOcY6OwEIVW/T3XqkWfqawfasLgRt709sB9qyREGBWOPN7gHnBg==@kvack.org
X-Gm-Message-State: AOJu0Yx+9su0ITWWokjAo/0MG5BtFHszqivEwpT4BhllamCT2cxwnhyZ
	HMmPXCx8JeDgMfgfPgPrPh7hArh8SmHYLls71s1u5EOjCMv0hsdyH3lT
X-Gm-Gg: ASbGnctQGiGt8HG1FUmR22cJK4CnffpFmGifaiJWWdd/Gnwg5QGNrvfgIADlEOryij1
	LQpjtNIouACN2hG+ZMHcsoKJFkVZNiZ6Ya9opASUMZjXsf6eeIo0tUmuO1Bc6w4CkQm+HN3Kz+T
	xr1PBOA0nIpabaW1MCF50yLVsiaGtb6h+r3plZvqmoIUMCeokSd/IIbUMs7EYHJSp5s//k8x507
	C9gX013Bsjf/p91Ydo5Sc6pjLHBfOE8WTFpmaFTblKikE1oy/FtVTf94OCPOujPmfBvHD1keL5j
	R0CH3tZXv08mjbWKZgRCgnAGlgvpb1nEDV2b6zFp9FnVW3s7s4qqMfuLUenFIZT7eerFUqo/Yk8
	Tlc4P6nkXb1qMpTdo3HD6H62mK+waXEHTEBl3tCupPJX40pnHhwHqt/U/kZGWD+GM/EZyjaE+1u
	xreOmkKsJQ3VbIO/7ZWvOCwkj/
X-Google-Smtp-Source: AGHT+IEhyK8NPE+GeBL8Nk7M6rEMwtjl7+2UMd2puyrSw7MC6zF3PkKy2fcSzfiXgmhFNVN3kLPSSA==
X-Received: by 2002:a17:902:c94a:b0:25d:5b09:a201 with SMTP id d9443c01a7336-2948b9c00c5mr84166735ad.27.1761407536907;
        Sat, 25 Oct 2025 08:52:16 -0700 (PDT)
Received: from localhost ([103.70.166.143])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498cf3f4asm26661525ad.11.2025.10.25.08.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Oct 2025 08:52:16 -0700 (PDT)
Date: Sat, 25 Oct 2025 21:22:12 +0530
From: Gopi Krishna Menon <krishnagopi487@gmail.com>
To: syzbot <syzbot+d8fd35fa6177afa8c92b@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com, 
	david@redhat.com, gourry@gourry.net, joshua.hahnjy@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com, rakie.kim@sk.com, 
	syzkaller-bugs@googlegroups.com, ying.huang@linux.alibaba.com, ziy@nvidia.com
Subject: Re: [syzbot] [mm?] WARNING in raw_ioctl
Message-ID: <hmzw6ng2gv6ctvgjhpttxuodpxriz63kpcnu7keywc2aioiw3v@x5xcenq5whr7>
References: <68fc07a0.a70a0220.3bf6c6.01ab.GAE@google.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ovxwxiyonj66htjx"
Content-Disposition: inline
In-Reply-To: <68fc07a0.a70a0220.3bf6c6.01ab.GAE@google.com>
X-Rspamd-Queue-Id: 4799718000A
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: e4qts5xghc3iutp6mbfg7jd7mc8k9srr
X-HE-Tag: 1761407538-825903
X-HE-Meta: U2FsdGVkX18MnL30hagqWNIqtekgSD8ydkwbXNojuqhTCN8ZjTpZZ2lt3mG6/ftUkoVXa/KMkIARrJY6F2BBdRAxpB32Rr/3XkvB/i219OYTpJUUUEGvgY4irDHiPHoIQnBzjNJWfK+Nx7vv/jy4z5APnJA9GauRKrEpWMD8nelafQG8OvCjgrxhsHJ6/Emid2ersKhxV6P8nGCCXS4mpJY6VEgWLYQ/H84qau/lKL4ipN8P2CFrQnFhFk2hhWXzkUdQxA3fcpzmHHkU/nTSIL1g7OPL0j/HK1vgSYCuFmM09vB6dMVC1GUgeQ+J7SiOfrLZmpB6+Ym1nlcscmo1sC8ULDKle5ylGXb4RBIpoCuCgESfhhgP2/E+DUSljRwgrVBWaHabb6xKPTwNiVsAJDuO/KXLJHz7Qz3Jgk5b3vD4sEwvh8kRMCYJzrqBnUJYZXo6aQAnjSh1XBReQJzr7CyLlA1x7bERRdX9snGjs4408kRXEyfb7Rass7kWWlMcZENHGD+QI7RO1FWwQrLW1vEHUliKpHju+WPYWbFO0JQckrRKaBmo8b0zKs+NVqdRq59hgbO6sGT2Qr7N2jmIdkkbN+9wBwj0G+WOeQkiLOlb4naLoM8ZgnNar/QD6UH2V8DH51mmimOPc9qYYdYr5AN4EQgWznrSbJhMfpL1xoX4B0/oSt9DANH8i1qwJBhz5j+OKxYFCiJc2fYt5xTq7qUOd9vTwtZrTxIJMKW/kd/O2NoAjjwWTr7bhbAsgVCId/w0/ToTKC9GfwUHOxc/+VDyuOhur8A7HCxMdnWmZPsxILccmimTrzX0WIqKUx2CU/XvHvVubmNSGLRUn+PHD7M2+8npitRO6VdXvD+bJKU0sFBMvW/4aSPvmT/ac3TYM5l0iI+PCA9ZTna96AHiF8iWot6gBV3nYUnDBrGLU99XwlWdJgH/lWcxMUGASTz7v3ch8GPuXKYCaY3Vm9J
 BQh4v8p0
 PwwA6YVE5CNKTG8xzFCvbUdPk3IEKP4QG2sc1zDzbotf1E84+35FaxiBz4FZSZn/wojCg2THQXEwTstpAi5sgYi4BSyUABu4CzerQ5ivfDW16qeVmE2dv88CaOVXkEKKnsxrIEBMpL/SJI4iJwDH2r/J0N/UmM0GZljIVGSpAYetqtDdN9c/lrF0qMqLUnPrxIWBDTI7wHUsiKJdPFslta71U4au4rQBQ4Z+oohMtrl7Yz42DZTmwqRF3+WNf4cfrs/5wPy0/B3lH0Ss2u/GXfh8vDht5IKhkjrJKmVQjqU/CIBJJMYFRJV22IiONBASF0vkPaqOockO4GUuKr89YK9morqKDk5P3803WevlaOp3fvo8qWG0SzkEbqeVw+h5jUUTFGbJv2f0Zy6uGdG0KeTwE9QuiEppjQSZeGNlwVYo9xTN1XtYvhxbysQ/LozsptF3RYWzsCTEbzm7EEZG8oczwxXGuMGV12s08fJuVAw3esA8XGskUjqeGEM3UAaoK47MGmvP0aaxMv0/ZO8YsLrzKe5H/cJIefN7vwSQWkb18l/We1Il+4BnDDXJR3iFbV7PGLMPT7jZZaRuI0OYippTDTPO7tUKWBWJu99Ybbc9B8W7rKRcC9WGrjbIAQjDhlDy+oZn3TljdRp5942S6FPU2nOI1nQQg8xgOdHq1GaoOHuHJXaiLrgmfkynKwr/LUossfb7KZO9+EY+I89FVXlAgr4A31lht7aBkO53ESfgrpkiN7LCLbLY1VDeA7l1ZiXulvsL5W6/tJbnv6FOb+4s2nr9rgKqg89XIEIeQtX1P2GD8jKAL07gvRp3mLwlajB0QPitRI/gOnhZD+BZ/uBpiMvvoQSSgvMLFV/7Iubu25PIrtbMHFwt00NEazaMV6zIVzFtD1dWEJFi+05djCY6AEPPSjrr5XRu8i2WXcbhXEU3iU1P22JYQjY9a34qnjBSNUDBzk9YEa28uQ5iWv6poWei6
 vnm/4wrM
 fF+fOUkJxvnjtAYLeeINHfXJpy3BVxMoFHLX/FLm6A+j3VVQNETgnT9SdS3qkf6mBL6KG+TVnaSHHNYchU6cinvBzQsUh55y+ERoZ7Brqre8F0gBjR61sYsm4jnquEKQXRmdngYv1/r4Lk4wYdv6nXFaYcAeSrnjdJbMU0dO02HXDk9V9FugGTdJrgUUj8ATd9KDtPqJBxSdxkm6V6asuTGLP/6AlUYk0KauHq0Eqbi3ZcF6MkqlkTL1vOs6v8diAYLGyLe+2nkufU7mJMYGdpv7Ao4V8edAY5wLtCsfPr1d5X3blyvyEH4RMPTpjKTNxqYwgps6M7gFS2LFWkh3To//AI87CaGR3w/uRYU1VWz+j5dpIP5ZBFRSTlbidejmsYz/pwq368PTStEOpSl5uBxhRBE1faQsksV+iiRZB+FdoxTYw5IQKiHX3/aKErsLGVT+mYvi06UfhZ9aA7Le6gxLEak5j16X10XTHC9NL7o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--ovxwxiyonj66htjx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 24, 2025 at 04:11:28PM -0700, syzbot wrote:

> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    72fb0170ef1f Add linux-next specific files for 20251024
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=10fd0be2580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=e812d103f45aa955
> dashboard link: https://syzkaller.appspot.com/bug?extid=d8fd35fa6177afa8c92b
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=119eae7c580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=140693e2580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/be1fa3d1f761/disk-72fb0170.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/57302bf7af40/vmlinux-72fb0170.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/91c806bb2a2b/bzImage-72fb0170.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+d8fd35fa6177afa8c92b@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: mm/page_alloc.c:5190 at __alloc_frozen_pages_noprof+0x2c8/0x370 mm/page_alloc.c:5190, CPU#1: syz.0.17/6001
> Modules linked in:
> CPU: 1 UID: 0 PID: 6001 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/02/2025
> RIP: 0010:__alloc_frozen_pages_noprof+0x2c8/0x370 mm/page_alloc.c:5190
> Code: 74 10 4c 89 e7 89 54 24 0c e8 64 b9 0d 00 8b 54 24 0c 49 83 3c 24 00 0f 85 a5 fe ff ff e9 a6 fe ff ff c6 05 b1 7d 70 0d 01 90 <0f> 0b 90 e9 18 ff ff ff a9 00 00 08 00 48 8b 4c 24 10 4c 8d 44 24
> RSP: 0018:ffffc90003017920 EFLAGS: 00010246
> RAX: ffffc90003017900 RBX: 0000000000000013 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc90003017988
> RBP: ffffc90003017a18 R08: ffffc90003017987 R09: 0000000000000000
> R10: ffffc90003017960 R11: fffff52000602f31 R12: 0000000000000000
> R13: 1ffff92000602f28 R14: 0000000000040cc0 R15: dffffc0000000000
> FS:  000055558dedb500(0000) GS:ffff888125ddc000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffef4504a80 CR3: 0000000072ffa000 CR4: 00000000003526f0
> Call Trace:
>  <TASK>
>  alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2418
>  ___kmalloc_large_node+0x5f/0x1b0 mm/slub.c:5583
>  __kmalloc_large_node_noprof+0x18/0x90 mm/slub.c:5614
>  __do_kmalloc_node mm/slub.c:5630 [inline]
>  __kmalloc_noprof+0x4c9/0x800 mm/slub.c:5654
>  kmalloc_noprof include/linux/slab.h:961 [inline]
>  raw_alloc_io_data drivers/usb/gadget/legacy/raw_gadget.c:673 [inline]
>  raw_ioctl_ep_read drivers/usb/gadget/legacy/raw_gadget.c:1162 [inline]
>  raw_ioctl+0x18fb/0x3be0 drivers/usb/gadget/legacy/raw_gadget.c:1325
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fccefd8efc9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffef4505ad8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007fcceffe5fa0 RCX: 00007fccefd8efc9
> RDX: 00002000000000c0 RSI: 00000000c0085508 RDI: 0000000000000004
> RBP: 00007fccefe11f91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fcceffe5fa0 R14: 00007fcceffe5fa0 R15: 0000000000000003
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

I misunderstood what io->data is and thought of it as a buffer for
storing one packet which dosent make any sense. Since io->data is the
raw data for the transfer itself in memory, it is possible that the
transfer length is several kilo bytes in size. This is also
documented by Andrey Konovalov in his patch [1], which dropped the
transfer length checks because there can be problems with USB devices
whose configuration descriptor exceeds PAGE_SIZE in length.

But since this value comes from userspace, it is possible that the user
passes a very large value (as in syzbot's case) which would be invalid
and raise warnings in the allocator. Therefore I think we should
validate the length in raw_alloc_io_data and prevent invalid values
(values which is greater than KMALLOC_MAX_SIZE) to prevent warnings from
the allocator. 

[1] : https://lore.kernel.org/all/a6024e8eab679043e9b8a5defdb41c4bda62f02b.1761085528.git.andreyknvl@gmail.com/

#syz test


--ovxwxiyonj66htjx
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-usb-raw_gadget-validate-io-length-in-raw_alloc_io_da.patch"

From ec93e88de10f0c0b02645e9caedad75323cf767c Mon Sep 17 00:00:00 2001
From: Gopi Krishna Menon <krishnagopi487@gmail.com>
Date: Sat, 25 Oct 2025 20:48:56 +0530
Subject: [PATCH] usb: raw_gadget: validate io length in raw_alloc_io_data()

Not checking the io buffer length can  allow very large allocations
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


--ovxwxiyonj66htjx--

