Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 825EEEA811B
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 14:32:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2FA36B0005; Tue, 10 Feb 2026 09:32:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBD716B0088; Tue, 10 Feb 2026 09:32:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBF426B0089; Tue, 10 Feb 2026 09:32:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AE1146B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 09:32:27 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5055713B480
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 14:32:27 +0000 (UTC)
X-FDA: 84428787534.06.817C92E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 67F15A000B
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 14:32:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tK7IYnAc;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770733945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cbfx/5YuzB95hsGsDJ/8syYZFXnzmnQ2tRtrGxpgVRc=;
	b=2A/sbkfh44COtAwBPEHNIdNjWyaSJRrYoMVqNK+KdhgXJks4yuVVPpVXDy3MJiNU21O3wy
	S8vBwF537u5Zjs2tTsklQinlyMVvhsP3RKTkKmGhCNlk6dhmCH6ZjEK6y4wzvBpfvRRgox
	uS2AKLkWz7nRpHFBdFnBDs9Jx1FR9ow=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tK7IYnAc;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770733945; a=rsa-sha256;
	cv=none;
	b=L2wav8jTJnu4zAVmbaF8uwfte5ZfwFWtr/LMWK9GMCMJkBOV+gSXkdCibixp7bFLSJyMAT
	o2g5t0Nxy+UUy5TCB042yz+hDjP+3sTwSZB/FlBkYz5RqM4AC5gZfet+Osokry3AoP/d8p
	M7+2ucznaWBMkKss7hrSj1vrGdE1Bh4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5D6C841730;
	Tue, 10 Feb 2026 14:32:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BAF6C116C6;
	Tue, 10 Feb 2026 14:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770733944;
	bh=vv5Zq1a2kZ6Z8ryTAztTiVCuOLZVOcUxPcen6TdorBY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tK7IYnAcdjb9ap2rQ2hqhsOtXKhyz79pPw/2oxUvH8iT93UwpTp4jM+MTgL99hHl0
	 cDh6QhgnqMXgp4qJDkU1HP52ujmJTqMClPMUXL2YZapvUAQ3hGXnMfXAy6KwxcdHFH
	 5MOC5sl2eox3cY2bRPGgb0W7SazfvYLaXG0OS93A8wKiVxplpfFRHHuBx3zq1KSm4a
	 dg4lr8jj/lJrAf7cYlCsdZm3Cyd3MIsNj4jXwOCuGTEvP79e6Mj5A4f2RCyeeDBscM
	 vgzzoPKNCeRzpP35l9qS1TLl9IY0ziViQg2QHbZYwXSTWCMpHypG3SxpKsz+6z2iEw
	 AmNw9BFzEm4jA==
Date: Tue, 10 Feb 2026 16:32:18 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-mm@kvack.org, Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH] mm: Fix memblock_free_late() when using deferred struct
 page
Message-ID: <aYtBctm4TlHGnzXV@kernel.org>
References: <ec2aaef14783869b3be6e3c253b2dcbf67dbc12a.camel@kernel.crashing.org>
 <aYJBBs17B-SQXFqq@kernel.org>
 <279931074239b7f3812c4cb3969f887303c8cc26.camel@kernel.crashing.org>
 <aYL3zxuTLT8N7C8-@kernel.org>
 <c3769af482913dd7ee9d5302c8afa990255691a5.camel@kernel.crashing.org>
 <aYXDeN0WGQG8-cxe@kernel.org>
 <bf0231accb89709968efb4d8e1be9970aeb716f8.camel@kernel.crashing.org>
 <e5d5a1105d90ee1e7fe7eafaed2ed03bbad0c46b.camel@kernel.crashing.org>
 <5a44609fe992624573a3ca0a293888bd623e2a06.camel@kernel.crashing.org>
 <0344bfbeb017cafc0f7bd4433eeacd9bc802d9c9.camel@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0344bfbeb017cafc0f7bd4433eeacd9bc802d9c9.camel@kernel.crashing.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 67F15A000B
X-Stat-Signature: pmggox4p8ohwsgefame73q8i7kam1eje
X-Rspam-User: 
X-HE-Tag: 1770733945-419652
X-HE-Meta: U2FsdGVkX1+dM/A7ubdR0TXeyMAlQuBwK6+INHk0ezyB/hjaViG7Pm8mhJyIOiykmDfw6ZksnDuQM++4c8XuIe7n0IL2umBM5c5rEwtvbpfMfKJczSxTKJW8pDSpJrjcTpl1zbLSvBMrns8DB9b602vtrz3kFMxdQzctbJlEnvFQGJa3/t9Ln4CnvCUChvUGs0hP9lFl1AZRteYRFA0k9KrWGemvlEH8aybkqHk8FcdB8sVCMy24s0oP5Ss0O0NKQqaTf3wb6EJOB2euA6KeZYkAI+R+mXHYOZTWURDk1F5/RlvjVhuD3iR5tw5DGgVbY6y81GVaT1qloXK+/u8s1UWkgq9CInUqwlFZhlrlKaLDgXyRp42EfDhNPu/1bde6NpnABUrdjg6NOYcXeEvbazk7Zsk73K4jyVybgVZ0RAacDHUYf1WyU5bgB7vlydzKwDhzGpMyI0FqD9ngPOV3ZCYR/YcbFY5vnpQi1x/Ge3cqqQ5uJG1prLICr34msO/YtKpbDqaVJBawyhXcjx51EN6UDobygHhp55L609ShxvjjGCT+jq/GWanIpPTLIB0CnscrMXMRIiz/Euy9osAmrXr/KRRcr/3pksLk74/IkfFE0Jq9rBzjaYGQ1z806ydZjZLuThXMO0J8tIA1gE7pv25ZQHJwX3PDd6msGri3AZwG9YCHPtuT1mkoXOKZaiAX8NHjJWwne6GO2mPtnwI00KF5NqY9UbDlYVIKGqDgxvG+/3aKniA8EaBCnUtKwReBHLigUu1gDCSeXiOJX6uT7Wmg5zzWlO28jXx/CuEZ4gnM4L+k22YZmAWFAVeO8WAzDLRmz4boKxxPAPAGgokajU1w2nmSR9BOby4+F4pnxsg6arQ4IJ4eA9CSbahUAIA3j3ry7qi7vKhNXgxQT6Y4cPwymR9MjJqK6yL4k2CJB6jQzFOA3WiEDPBxvmndbMHqVk1XyPPfdifagcSAWTq
 FA5rINIF
 IeTIoqron9diYQ9VEvYC7VBLUjJKIUpqXvynV/6rxryaDQU38FTH6haUBt9BSXrQLggqkhmOMFxdySu+0J3kJk5vAJLoDbWyrGrZYN51HL8kNLvsT+gfhGn2qbMTlRJsB3aX9BrpR1ILXEtGoRmeoR3QNcmA40rfNII2ubiDqgwRf1i+k0+PnoOlcLLMuQDp9lNfnKsqUhZEUQzspAJTMSjKI5n1iAK/zxRt5BnVFyw84rhdBWkccJcyJ1DyV6T5bP+Juyrjz4VbIlYAT1SQyQSD3HrFGy4+BNBSpOitJlGOrz+1OX/hsAoUPdQEszHzD2lf2nDhk+K5Z1uV5L5Xr/XeqdrDbm537/5hXIqQ7lmtb7g2wOcbp0uc57Oh/N3cSaZ1nS1WdktPxbwppUJV9v6+7WSQ9s4Q3dr7DX6EogmX2Xvw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ben,

On Tue, Feb 10, 2026 at 07:34:15PM +1100, Benjamin Herrenschmidt wrote:
> On Tue, 2026-02-10 at 17:17 +1100, Benjamin Herrenschmidt wrote:
> > 
> > So ... that was a backport to 6.12.68 and my original patch is
> > crashing
> > the same way ! (it was working last week interestingly enough,
> > something else got backported that gets in the way maybe ?).
> > 
> > I'm going to have to go back to digging :-(
> > 
> > I suspect the pages aren't reserved. I swear this was working :-)
> 
> So I rebuilt with a bit of extra debug prints, CONFIG_DEBUG_VM on, and
> memblock=debug ... it's not hitting the reserved check, but it's also
> not crashing the same way (still 6.12, I'll play with upstream again
> later):
> 
>  .../...

Do you mind sending the entire log?
 
> 
> [    0.045633] Freeing SMP alternatives memory: 36K
> [    0.045633] pid_max: default: 32768 minimum: 301
> [    0.045633] memblock_free_late: [0x000000003d36b000-0x000000003d37bfff] efi_free_boot_services+0x11f/0x2e0
> [    0.045633] memblock_free_late: [0x000000003b336000-0x000000003d36afff] efi_free_boot_services+0x11f/0x2e0
> [    0.045633] memblock_free_late: [0x000000003b317000-0x000000003b335fff] efi_free_boot_services+0x11f/0x2e0
> [    0.045633] memblock_free_late: [0x000000003b2f7000-0x000000003b316fff] efi_free_boot_services+0x11f/0x2e0
> [    0.045633] memblock_free_late: [0x000000003b000000-0x000000003b1fffff] efi_free_boot_services+0x11f/0x2e0
> [    0.045633] memblock_free_late: [0x00000000393de000-0x00000000393defff] efi_free_boot_services+0x11f/0x2e0
> [    0.045633] memblock_free_late: [0x0000000038e73000-0x00000000390cdfff] efi_free_boot_services+0x11f/0x2e0
> [    0.045633] LSM: initializing lsm=lockdown,capability,landlock,yama,safesetid,selinux,bpf,ima
> [    0.045633] landlock: Up and running.
> [    0.045633] Yama: becoming mindful.
> [    0.045633] SELinux:  Initializing.
> [    0.045633] LSM support for eBPF active
> [    0.045633] Mount-cache hash table entries: 2048 (order: 2, 16384 bytes, linear)
> [    0.045633] Mountpoint-cache hash table entries: 2048 (order: 2, 16384 bytes, linear)
> [    0.045633] smpboot: CPU0: Intel(R) Xeon(R) Platinum 8259CL CPU @ 2.50GHz (family: 0x6, model: 0x55, stepping: 0x7)
> [    0.045633] Performance Events: unsupported p6 CPU model 85 no PMU driver, software events only.
> [    0.045633] signal: max sigframe size: 3632
> [    0.045633] rcu: Hierarchical SRCU implementation.
> [    0.045633] rcu: 	Max phase no-delay instances is 1000.
> [    0.045633] Timer migration: 1 hierarchy levels; 8 children per group; 1 crossnode level
> [    0.045633] smp: Bringing up secondary CPUs ...
> [    0.045633] smpboot: x86: Booting SMP configuration:
> [    0.045633] .... node  #0, CPUs:      #1
> [    0.045633] MDS CPU bug present and SMT on, data leak possible. See https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/mds.html for more details.
> [    0.045633] MMIO Stale Data CPU bug present and SMT on, data leak possible. See https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/processor_mmio_stale_data.html for more details.
> [    0.045633] smp: Brought up 1 node, 2 CPUs
> [    0.045633] smpboot: Total of 2 processors activated (9999.97 BogoMIPS)
> [    0.045633] node 0 deferred pages initialised in 0ms
> [    0.045633] Memory: 900460K/999468K available (16384K kernel code, 9440K rwdata, 11364K rodata, 3740K init, 6440K bss, 94600K reserved, 0K cma-reserved)
> [    0.045633] devtmpfs: initialized
> [    0.045633] x86/mm: Memory block size: 128MB
> [    0.045633] ------------[ cut here ]------------
> [    0.045633] page type is 1, passed migratetype is 0 (nr=16)
> [    0.045633] WARNING: CPU: 1 PID: 2 at mm/page_alloc.c:721 rmqueue_bulk+0x82e/0x880
> [    0.045633] Modules linked in:
> [    0.045633] CPU: 1 UID: 0 PID: 2 Comm: kthreadd Not tainted 6.12.68-93.123.amzn2023.x86_64 #1
> [    0.045633] Hardware name: Amazon EC2 t3.micro/, BIOS 1.0 10/16/2017
> [    0.045633] RIP: 0010:rmqueue_bulk+0x82e/0x880
> [    0.045633] Code: c6 05 be be 13 02 01 e8 b0 b5 ff ff 44 89 e9 8b 14 24 48 c7 c7 a8 6d 51 8e 48 89 c6 b8 01 00 00 00 d3 e0 89 c1 e8 32 4f d2 ff <0f> 0b 4c 8b 44 24 48 e9 79 fc ff ff 48 c7 c6 e0 77 51 8e 4c 89 e7
> [    0.045633] RSP: 0000:ffffd592c002f898 EFLAGS: 00010086
> [    0.045633] RAX: 0000000000000000 RBX: ffff8e363b2cbc80 RCX: ffffffff8f1f0c68
> [    0.045633] RDX: 0000000000000000 RSI: 00000000fffeffff RDI: 0000000000000001
> [    0.045633] RBP: fffffb9c40e3a408 R08: 0000000000000000 R09: ffffd592c002f740
> [    0.045633] R10: ffffd592c002f738 R11: ffffffff8f370ca8 R12: fffffb9c40e3a400
> [    0.045633] R13: 0000000000000004 R14: 0000000000000003 R15: 0000000000038e90
> [    0.045633] FS:  0000000000000000(0000) GS:ffff8e3639f00000(0000) knlGS:0000000000000000
> [    0.045633] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    0.045633] CR2: 0000000000000000 CR3: 000000001bc34001 CR4: 00000000007706f0
> [    0.045633] PKRU: 55555554
> [    0.045633] Call Trace:
> [    0.045633]  <TASK>
> [    0.045633]  __rmqueue_pcplist+0x233/0x2c0
> [    0.045633]  rmqueue.constprop.0+0x4b6/0xe80
> [    0.045633]  ? _raw_spin_unlock+0xa/0x30
> [    0.045633]  ? rmqueue.constprop.0+0x557/0xe80
> [    0.045633]  ? _raw_spin_unlock_irqrestore+0xa/0x30
> [    0.045633]  get_page_from_freelist+0x16e/0x5f0
> [    0.045633]  __alloc_pages_noprof+0x18a/0x350
> [    0.045633]  alloc_pages_mpol_noprof+0xf2/0x1e0
> [    0.045633]  ? shuffle_freelist+0x126/0x1b0
> [    0.045633]  allocate_slab+0x2b3/0x410
> [    0.045633]  ___slab_alloc+0x396/0x830
> [    0.045633]  ? switch_hrtimer_base+0x8e/0x190
> [    0.045633]  ? timerqueue_add+0x9b/0xc0
> [    0.045633]  ? dup_task_struct+0x2d/0x1b0
> [    0.045633]  ? _raw_spin_unlock_irqrestore+0xa/0x30
> [    0.045633]  ? start_dl_timer+0xb0/0x140
> [    0.045633]  kmem_cache_alloc_node_noprof+0x271/0x2e0
> [    0.045633]  ? dup_task_struct+0x2d/0x1b0
> [    0.045633]  dup_task_struct+0x2d/0x1b0
> [    0.045633]  copy_process+0x195/0x17e0
> [    0.045633]  kernel_clone+0x9a/0x3b0
> [    0.045633]  ? psi_task_switch+0x105/0x290
> [    0.045633]  kernel_thread+0x6b/0x90
> [    0.045633]  ? __pfx_kthread+0x10/0x10
> [    0.045633]  kthreadd+0x276/0x2d0
> [    0.045633]  ? __pfx_kthreadd+0x10/0x10
> [    0.045633]  ret_from_fork+0x30/0x50
> [    0.045633]  ? __pfx_kthreadd+0x10/0x10
> [    0.045633]  ret_from_fork_asm+0x1a/0x30
> [    0.045633]  </TASK>
> [    0.045633] ---[ end trace 0000000000000000 ]---
> [    0.045633] ------------[ cut here ]------------
> [    0.045633] page type is 1, passed migratetype is 0 (nr=8)
> [    0.045633] WARNING: CPU: 1 PID: 2 at mm/page_alloc.c:686 expand+0x1af/0x1e0
> [    0.045633] Modules linked in:
> [    0.045633] CPU: 1 UID: 0 PID: 2 Comm: kthreadd Tainted: G        W          6.12.68-93.123.amzn2023.x86_64 #1
> [    0.045633] Tainted: [W]=WARN
> [    0.045633] Hardware name: Amazon EC2 t3.micro/, BIOS 1.0 10/16/2017
> [    0.045633] RIP: 0010:expand+0x1af/0x1e0
> [    0.045633] Code: c6 05 af 06 14 02 01 e8 9f fd ff ff 89 e9 8b 54 24 34 48 c7 c7 a8 6d 51 8e 48 89 c6 b8 01 00 00 00 d3 e0 89 c1 e8 21 97 d2 ff <0f> 0b e9 e5 fe ff ff 48 c7 c6 e0 6d 51 8e 4c 89 ff e8 eb 23 fc ff
> [    0.045633] RSP: 0000:ffffd592c002f828 EFLAGS: 00010082
> [    0.045633] RAX: 0000000000000000 RBX: ffff8e363b2cbc80 RCX: ffffffff8f1f0c68
> [    0.045633] RDX: 0000000000000000 RSI: 00000000fffeffff RDI: 0000000000000001
> [    0.045633] RBP: 0000000000000003 R08: 0000000000000000 R09: ffffd592c002f6d0
> [    0.045633] R10: ffffd592c002f6c8 R11: ffffffff8f370ca8 R12: 0000000000000008
> [    0.045633] R13: 0000000000038e98 R14: 0000000000000003 R15: fffffb9c40e3a600
> [    0.045633] FS:  0000000000000000(0000) GS:ffff8e3639f00000(0000) knlGS:0000000000000000
> [    0.045633] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    0.045633] CR2: 0000000000000000 CR3: 000000001bc34001 CR4: 00000000007706f0
> [    0.045633] PKRU: 55555554
> [    0.045633] Call Trace:
> [    0.045633]  <TASK>
> [    0.045633]  rmqueue_bulk+0x541/0x880
> [    0.045633]  __rmqueue_pcplist+0x233/0x2c0
> [    0.045633]  rmqueue.constprop.0+0x4b6/0xe80
> [    0.045633]  ? _raw_spin_unlock+0xa/0x30
> [    0.045633]  ? rmqueue.constprop.0+0x557/0xe80
> [    0.045633]  ? _raw_spin_unlock_irqrestore+0xa/0x30
> [    0.045633]  get_page_from_freelist+0x16e/0x5f0
> [    0.045633]  __alloc_pages_noprof+0x18a/0x350
> [    0.045633]  alloc_pages_mpol_noprof+0xf2/0x1e0
> [    0.045633]  ? shuffle_freelist+0x126/0x1b0
> [    0.045633]  allocate_slab+0x2b3/0x410
> [    0.045633]  ___slab_alloc+0x396/0x830
> [    0.045633]  ? switch_hrtimer_base+0x8e/0x190
> [    0.045633]  ? timerqueue_add+0x9b/0xc0
> [    0.045633]  ? dup_task_struct+0x2d/0x1b0
> [    0.045633]  ? _raw_spin_unlock_irqrestore+0xa/0x30
> [    0.045633]  ? start_dl_timer+0xb0/0x140
> [    0.045633]  kmem_cache_alloc_node_noprof+0x271/0x2e0
> [    0.045633]  ? dup_task_struct+0x2d/0x1b0
> [    0.045633]  dup_task_struct+0x2d/0x1b0
> [    0.045633]  copy_process+0x195/0x17e0
> [    0.045633]  kernel_clone+0x9a/0x3b0
> [    0.045633]  ? psi_task_switch+0x105/0x290
> [    0.045633]  kernel_thread+0x6b/0x90
> [    0.045633]  ? __pfx_kthread+0x10/0x10
> [    0.045633]  kthreadd+0x276/0x2d0
> [    0.045633]  ? __pfx_kthreadd+0x10/0x10
> [    0.045633]  ret_from_fork+0x30/0x50
> [    0.045633]  ? __pfx_kthreadd+0x10/0x10
> [    0.045633]  ret_from_fork_asm+0x1a/0x30
> [    0.045633]  </TASK>
> [    0.045633] ---[ end trace 0000000000000000 ]---
> 
> > > 
> > 
> 

-- 
Sincerely yours,
Mike.

